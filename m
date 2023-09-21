Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF2A7AA283
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 23:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjIUVUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 17:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbjIUVT7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 17:19:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CE67696
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695316212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=yGSo9sDHzd5CMzk7FyS0r4V/a8qi3JNE5pWHwlm8AKM=;
        b=bg++GvStkcGp8lgGKkzXYvr95lWqHAICUfhgDKwFK/NIlt2dNckuUXJiL0xEXf7ih6ouVQ
        Y8DS8T4AQ/5qBJI/caLgl4X/oYiiFnKJLCtzmx0ht4mN7AayclIalUfSR9urYb/UGk/f57
        HpHukbvM0Set5vu+jtqKR24DuwK+ZWc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-wgFi1pJ3PXe1NIs5rJji4g-1; Thu, 21 Sep 2023 07:49:41 -0400
X-MC-Unique: wgFi1pJ3PXe1NIs5rJji4g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F68A381170A;
        Thu, 21 Sep 2023 11:49:41 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1238420268DB;
        Thu, 21 Sep 2023 11:49:41 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bp@alien8.de
Subject: [PATCH] x86/cpu: clear SVM feature if disabled by BIOS
Date:   Thu, 21 Sep 2023 07:49:40 -0400
Message-Id: <20230921114940.957141-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When SVM is disabled by BIOS, one cannot use KVM but the
svm feature is still shown in the output of /proc/cpuinfo.
On Intel machines, VMX is cleared by init_ia32_feat_ctl(),
so do the same on AMD and Hygon processors.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/msr-index.h |  6 +++++-
 arch/x86/include/asm/svm.h       |  6 ------
 arch/x86/kernel/cpu/amd.c        | 10 ++++++++++
 arch/x86/kernel/cpu/hygon.c      | 10 ++++++++++
 arch/x86/kvm/svm/svm.c           |  8 --------
 5 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1d111350197f..6a6b0f763f67 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1112,12 +1112,16 @@
 #define MSR_IA32_VMX_MISC_INTEL_PT                 (1ULL << 14)
 #define MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS (1ULL << 29)
 #define MSR_IA32_VMX_MISC_PREEMPTION_TIMER_SCALE   0x1F
-/* AMD-V MSRs */
 
+/* AMD-V MSRs */
 #define MSR_VM_CR                       0xc0010114
 #define MSR_VM_IGNNE                    0xc0010115
 #define MSR_VM_HSAVE_PA                 0xc0010117
 
+#define SVM_VM_CR_VALID_MASK		0x001fULL
+#define SVM_VM_CR_SVM_LOCK_MASK		0x0008ULL
+#define SVM_VM_CR_SVM_DIS_MASK		0x0010ULL
+
 /* Hardware Feedback Interface */
 #define MSR_IA32_HW_FEEDBACK_PTR        0x17d0
 #define MSR_IA32_HW_FEEDBACK_CONFIG     0x17d1
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 19bf955b67e0..fb8366af59da 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -229,10 +229,6 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_IOIO_SIZE_MASK (7 << SVM_IOIO_SIZE_SHIFT)
 #define SVM_IOIO_ASIZE_MASK (7 << SVM_IOIO_ASIZE_SHIFT)
 
-#define SVM_VM_CR_VALID_MASK	0x001fULL
-#define SVM_VM_CR_SVM_LOCK_MASK 0x0008ULL
-#define SVM_VM_CR_SVM_DIS_MASK  0x0010ULL
-
 #define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
 #define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
 #define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
@@ -571,8 +567,6 @@ struct vmcb {
 
 #define SVM_CPUID_FUNC 0x8000000a
 
-#define SVM_VM_CR_SVM_DISABLE 4
-
 #define SVM_SELECTOR_S_SHIFT 4
 #define SVM_SELECTOR_DPL_SHIFT 5
 #define SVM_SELECTOR_P_SHIFT 7
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index dd8379d84445..1011ce20f513 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1031,6 +1031,8 @@ static void zenbleed_check(struct cpuinfo_x86 *c)
 
 static void init_amd(struct cpuinfo_x86 *c)
 {
+	u64 vm_cr;
+
 	early_init_amd(c);
 
 	/*
@@ -1082,6 +1084,14 @@ static void init_amd(struct cpuinfo_x86 *c)
 
 	init_amd_cacheinfo(c);
 
+	if (cpu_has(c, X86_FEATURE_SVM)) {
+		rdmsrl(MSR_VM_CR, vm_cr);
+		if (vm_cr & SVM_VM_CR_SVM_DIS_MASK) {
+			pr_notice_once("SVM disabled (by BIOS) in MSR_VM_CR\n");
+			clear_cpu_cap(c, X86_FEATURE_SVM);
+		}
+	}
+
 	if (!cpu_has(c, X86_FEATURE_LFENCE_RDTSC) && cpu_has(c, X86_FEATURE_XMM2)) {
 		/*
 		 * Use LFENCE for execution serialization.  On families which
diff --git a/arch/x86/kernel/cpu/hygon.c b/arch/x86/kernel/cpu/hygon.c
index defdc594be14..16f34639ecf7 100644
--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -290,6 +290,8 @@ static void early_init_hygon(struct cpuinfo_x86 *c)
 
 static void init_hygon(struct cpuinfo_x86 *c)
 {
+	u64 vm_cr;
+
 	early_init_hygon(c);
 
 	/*
@@ -320,6 +322,14 @@ static void init_hygon(struct cpuinfo_x86 *c)
 
 	init_hygon_cacheinfo(c);
 
+	if (cpu_has(c, X86_FEATURE_SVM)) {
+		rdmsrl(MSR_VM_CR, vm_cr);
+		if (vm_cr & SVM_VM_CR_SVM_DIS_MASK) {
+			pr_notice_once("SVM disabled (by BIOS) in MSR_VM_CR\n");
+			clear_cpu_cap(c, X86_FEATURE_SVM);
+		}
+	}
+
 	if (cpu_has(c, X86_FEATURE_XMM2)) {
 		/*
 		 * Use LFENCE for execution serialization.  On families which
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f283eb47f6ac..7b91efb72ea6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -531,8 +531,6 @@ static bool __kvm_is_svm_supported(void)
 	int cpu = smp_processor_id();
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
-	u64 vm_cr;
-
 	if (c->x86_vendor != X86_VENDOR_AMD &&
 	    c->x86_vendor != X86_VENDOR_HYGON) {
 		pr_err("CPU %d isn't AMD or Hygon\n", cpu);
@@ -549,12 +547,6 @@ static bool __kvm_is_svm_supported(void)
 		return false;
 	}
 
-	rdmsrl(MSR_VM_CR, vm_cr);
-	if (vm_cr & (1 << SVM_VM_CR_SVM_DISABLE)) {
-		pr_err("SVM disabled (by BIOS) in MSR_VM_CR on CPU %d\n", cpu);
-		return false;
-	}
-
 	return true;
 }
 
-- 
2.39.1

