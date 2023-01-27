Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A2067E3B4
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjA0Ll2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233690AbjA0LlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:41:11 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18908126CA;
        Fri, 27 Jan 2023 03:40:44 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C11D16A3;
        Fri, 27 Jan 2023 03:41:02 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B29523F64C;
        Fri, 27 Jan 2023 03:40:17 -0800 (PST)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     suzuki.poulose@arm.com,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, linux-coco@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RFC kvmtool 11/31] arm64: Lock realm RAM in memory
Date:   Fri, 27 Jan 2023 11:39:12 +0000
Message-Id: <20230127113932.166089-12-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127113932.166089-1-suzuki.poulose@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127113932.166089-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

RMM doesn't yet support paging protected memory pages. Thus the VMM
must pin the entire VM memory.

Use mlock2 to keep the realm pages pinned in memory once they are faulted
in. Use the MLOCK_ONFAULT flag to prevent pre-mapping the pages and
maintain some semblance of on demand-paging for a realm VM.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/kvm.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/arm/kvm.c b/arm/kvm.c
index d51cc15d..0e40b753 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -7,6 +7,8 @@
 
 #include "arm-common/gic.h"
 
+#include <sys/resource.h>
+
 #include <linux/kernel.h>
 #include <linux/kvm.h>
 #include <linux/sizes.h>
@@ -24,6 +26,25 @@ bool kvm__arch_cpu_supports_vm(void)
 	return true;
 }
 
+static void try_increase_mlock_limit(struct kvm *kvm)
+{
+	u64 size = kvm->arch.ram_alloc_size;
+	struct rlimit mlock_limit, new_limit;
+
+	if (getrlimit(RLIMIT_MEMLOCK, &mlock_limit)) {
+		perror("getrlimit(RLIMIT_MEMLOCK)");
+		return;
+	}
+
+	if (mlock_limit.rlim_cur > size)
+		return;
+
+	new_limit.rlim_cur = size;
+	new_limit.rlim_max = max((rlim_t)size, mlock_limit.rlim_max);
+	/* Requires CAP_SYS_RESOURCE capability. */
+	setrlimit(RLIMIT_MEMLOCK, &new_limit);
+}
+
 void kvm__init_ram(struct kvm *kvm)
 {
 	u64 phys_start, phys_size;
@@ -49,8 +70,27 @@ void kvm__init_ram(struct kvm *kvm)
 	kvm->ram_start = (void *)ALIGN((unsigned long)kvm->arch.ram_alloc_start,
 					SZ_2M);
 
-	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
-		MADV_MERGEABLE);
+	/*
+	 * Do not merge pages if this is a Realm.
+	 *  a) We cannot replace a page in realm stage2 without export/import
+	 *
+	 * Pin the realm memory until we have export/import, due to the same
+	 * reason as above.
+	 *
+	 * Use mlock2(,,MLOCK_ONFAULT) to allow faulting in pages and thus
+	 * allowing to lazily populate the PAR.
+	 */
+	if (kvm->cfg.arch.is_realm) {
+		int ret;
+
+		try_increase_mlock_limit(kvm);
+		ret = mlock2(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
+			     MLOCK_ONFAULT);
+		if (ret)
+			die_perror("mlock2");
+	} else {
+		madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size, MADV_MERGEABLE);
+	}
 
 	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
 		MADV_HUGEPAGE);
-- 
2.34.1

