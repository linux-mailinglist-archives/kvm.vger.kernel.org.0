Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3E076DBC0
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 01:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbjHBXnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 19:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbjHBXnm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 19:43:42 -0400
Received: from out-94.mta1.migadu.com (out-94.mta1.migadu.com [95.215.58.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370A130D7
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 16:43:31 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691019810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=by9Fz9Qt422lsiWQg/f50bedIz2GotLsFDYI7uVLLxQ=;
        b=rZ7xMp03WXBqwaAKe1D+H2MC+2WKXMI46EadiPKK6ny+b+knjenVUB2Jl3Vj1cmjEf0vXj
        yVVi+ZXGSiGBOfxImk0CvgfhgX23cFqu9qXEAB8fWl/tqagETNqWMMVMQPqSjRb2z074gQ
        nBQmXsMZsfqCAThEFHNnprCrL/cw7Y0=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH kvmtool v3 09/17] aarch64: Add support for finding vCPU for given MPIDR
Date:   Wed,  2 Aug 2023 23:42:47 +0000
Message-ID: <20230802234255.466782-10-oliver.upton@linux.dev>
In-Reply-To: <20230802234255.466782-1-oliver.upton@linux.dev>
References: <20230802234255.466782-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some PSCI calls take an MPIDR affinity as an argument. Add a helper to
get the vCPU that matches an MPIDR so we can find the intended
recipient.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arm/aarch64/include/kvm/kvm-arch.h |  1 +
 arm/aarch64/kvm.c                  | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
index 0d3b169b3c93..dacbc9286f50 100644
--- a/arm/aarch64/include/kvm/kvm-arch.h
+++ b/arm/aarch64/include/kvm/kvm-arch.h
@@ -6,6 +6,7 @@
 struct kvm;
 unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd);
 int kvm__arch_get_ipa_limit(struct kvm *kvm);
+struct kvm_cpu *kvm__arch_mpidr_to_vcpu(struct kvm *kvm, u64 target_mpidr);
 
 #define MAX_PAGE_SIZE	SZ_64K
 
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 848e6909994a..4929ce48843b 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -1,4 +1,5 @@
 #include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
 
 #include <asm/image.h>
 
@@ -165,3 +166,18 @@ void __kvm__arm_init(struct kvm *kvm)
 {
 	kvm__arch_enable_mte(kvm);
 }
+
+struct kvm_cpu *kvm__arch_mpidr_to_vcpu(struct kvm *kvm, u64 target_mpidr)
+{
+	int i;
+
+	for (i = 0; i < kvm->nrcpus; i++) {
+		struct kvm_cpu *tmp = kvm->cpus[i];
+		u64 mpidr = kvm_cpu__get_vcpu_mpidr(tmp) & ARM_MPIDR_HWID_BITMASK;
+
+		if (mpidr == target_mpidr)
+			return tmp;
+	}
+
+	return NULL;
+}
-- 
2.41.0.585.gd2178a4bd4-goog

