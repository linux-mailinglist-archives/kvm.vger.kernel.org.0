Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B89667E3C2
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbjA0LmC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:42:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbjA0Ll2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:41:28 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D2FF78AEB;
        Fri, 27 Jan 2023 03:41:06 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 480471576;
        Fri, 27 Jan 2023 03:41:19 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BEBA93F64C;
        Fri, 27 Jan 2023 03:40:34 -0800 (PST)
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
Subject: [RFC kvmtool 17/31] arm: Add kernel size to VM context
Date:   Fri, 27 Jan 2023 11:39:18 +0000
Message-Id: <20230127113932.166089-18-suzuki.poulose@arm.com>
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

Add the kernel image size to the VM context, as we are going to use it
later. This matches what we already do with the initrd.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
[Fix kernel size printed in debug messages]
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/include/arm-common/kvm-arch.h | 1 +
 arm/kvm.c                         | 8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index 41b31f11..b5a4b851 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -108,6 +108,7 @@ struct kvm_arch {
 	 */
 	u64	memory_guest_start;
 	u64	kern_guest_start;
+	u64	kern_size;
 	u64	initrd_guest_start;
 	u64	initrd_size;
 	u64	dtb_guest_start;
diff --git a/arm/kvm.c b/arm/kvm.c
index 2510a322..acb627b2 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -153,7 +153,6 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 	limit = kvm->ram_start + min(kvm->ram_size, (u64)SZ_256M) - 1;
 
 	pos = kvm->ram_start + kvm__arch_get_kern_offset(kvm, fd_kernel);
-	kvm->arch.kern_guest_start = host_to_guest_flat(kvm, pos);
 	file_size = read_file(fd_kernel, pos, limit - pos);
 	if (file_size < 0) {
 		if (errno == ENOMEM)
@@ -161,9 +160,12 @@ bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
 
 		die_perror("kernel read");
 	}
+
+	kvm->arch.kern_guest_start = host_to_guest_flat(kvm, pos);
+	kvm->arch.kern_size = file_size;
 	kernel_end = pos + file_size;
-	pr_debug("Loaded kernel to 0x%llx (%zd bytes)",
-		 kvm->arch.kern_guest_start, file_size);
+	pr_debug("Loaded kernel to 0x%llx (%llu bytes)",
+		 kvm->arch.kern_guest_start, kvm->arch.kern_size);
 
 	/*
 	 * Now load backwards from the end of memory so the kernel
-- 
2.34.1

