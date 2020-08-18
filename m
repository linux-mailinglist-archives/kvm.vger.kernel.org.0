Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C712E248FFC
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 23:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgHRVQo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 17:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726953AbgHRVQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 17:16:35 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C3BC061342
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:34 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id f5so13687946pfe.2
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=QXoI23I8LR3P1imR6KC/RuDpT40fikKZX7u3wsa4t6s=;
        b=F4yEG7h1wj58O6AEjAa67RP7BeF2OrbmVMKZFFyQuWmxwFkkZJ5t3Buqx5pMO6JHV1
         W/D0NWCr2g18ZtjZ62TyZrrd4udKqVfNnS78cyPy5/4OiQ8XTCxnHD4ApkvaRma44f4U
         E4jBxw9FE5cLuT3zb7f5TnFhoHO3ZljgOXQpe0Gli0vxqeEt+13L8hwmgI8n2zPl7wcD
         zKoUIPi2chlL2pag2yyW7XIxfN4GGEOLq8kMffB0hpplwVnJkLyvwQjxMJ2lLyn8Lf/J
         4xwNup+HsAtgFRJK5vRZ408EpCJyt+F9nQ4rxbtTa/btAM6qP1utJdw+FcXnon1laclc
         Gxpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QXoI23I8LR3P1imR6KC/RuDpT40fikKZX7u3wsa4t6s=;
        b=Zyb7KJK1GQPKvuF2rbNR7+MeLAL22RgOpxjaaRyNQbcfwYslMQ+pvhlVhfseA4bZQP
         F4UMNqozCvnTib0IZuO9NmegfQLzWURM2QX+/eawiJL1llbUTuWLrhqdjtovw8y9NEmy
         0DQhKOzmNR5rAizoLgBuBWQnaOCiaNeFuDfqWfeymkCCZHEVDciW3HTuVMGbGDpztlKP
         a6/R+wAOQnggD2BwAzRfIgUUADHaVYgPCRS8NBK/9mDTCV+WLfOWHyeD7l1JTpKLH/iv
         z6LL2V9yVWGCj5COLsT/rntTfrSeS7RUw9irsU/X5ftCzCm2quJVCLkjoAqLfAdvCsRi
         ySaw==
X-Gm-Message-State: AOAM532l6o4ZfGyWN9n6mBU9vvWHigSByZEFAhxgtXk3nw8hm1YspCOl
        ObSlRUi+FSBZtCPxe08ymQy2yWeubEoEla5f
X-Google-Smtp-Source: ABdhPJzKf2ZkKnOHKX1cNWJFxAaK2Jz3c/+zV6WxRor2mxQ1VMujLbVc5B8722MKbG1n8RBgJVkc8R7zyA4uRHw/
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:a28c:fdff:fed8:8d46])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:f2d7:: with SMTP id
 gt23mr1515351pjb.0.1597785394491; Tue, 18 Aug 2020 14:16:34 -0700 (PDT)
Date:   Tue, 18 Aug 2020 14:15:29 -0700
In-Reply-To: <20200818211533.849501-1-aaronlewis@google.com>
Message-Id: <20200818211533.849501-8-aaronlewis@google.com>
Mime-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v3 07/12] KVM: x86: Ensure the MSR bitmap never clears
 userspace tracked MSRs
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, graf@amazon.com
Cc:     pshier@google.com, oupton@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SDM volume 3: 24.6.9 "MSR-Bitmap Address" and APM volume 2: 15.11 "MS
intercepts" describe MSR permission bitmaps.  Permission bitmaps are
used to control whether an execution of rdmsr or wrmsr will cause a
vm exit.  For userspace tracked MSRs it is required they cause a vm
exit, so the host is able to forward the MSR to userspace.  This change
adds vmx/svm support to ensure the permission bitmap is properly set to
cause a vm_exit to the host when rdmsr or wrmsr is used by one of the
userspace tracked MSRs.  Also, to avoid repeatedly setting them,
kvm_make_request() is used to coalesce these into a single call.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/kvm/svm/svm.c          | 49 ++++++++++++++++++++++++++-------
 arch/x86/kvm/vmx/vmx.c          | 13 ++++++++-
 arch/x86/kvm/x86.c              | 16 +++++++++++
 4 files changed, 70 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6c4c5b972395..65e9dcc19cc2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -87,6 +87,7 @@
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(27, KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_APF_READY		KVM_ARCH_REQ(28)
+#define KVM_REQ_USER_MSR_UPDATE KVM_ARCH_REQ(29)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -1242,6 +1243,8 @@ struct kvm_x86_ops {
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
+
+	void (*set_user_msr_intercept)(struct kvm_vcpu *vcpu, u32 msr);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 56e9cf284c2a..c49d121ee102 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -583,13 +583,27 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 	return !!test_bit(bit_write,  &tmp);
 }
 
+static void __set_msr_interception(u32 *msrpm, u32 msr, int read, int write,
+				   u32 offset)
+{
+	u8 bit_read, bit_write;
+	unsigned long tmp;
+
+	bit_read  = 2 * (msr & 0x0f);
+	bit_write = 2 * (msr & 0x0f) + 1;
+	tmp       = msrpm[offset];
+
+	read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
+	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
+
+	msrpm[offset] = tmp;
+}
+
 static void set_msr_interception(struct kvm_vcpu *vcpu, u32 msr, int read,
 				 int write)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 *msrpm = svm->msrpm;
-	u8 bit_read, bit_write;
-	unsigned long tmp;
 	u32 offset;
 
 	/*
@@ -598,17 +612,30 @@ static void set_msr_interception(struct kvm_vcpu *vcpu, u32 msr, int read,
 	 */
 	WARN_ON(!valid_msr_intercept(msr));
 
-	offset    = svm_msrpm_offset(msr);
-	bit_read  = 2 * (msr & 0x0f);
-	bit_write = 2 * (msr & 0x0f) + 1;
-	tmp       = msrpm[offset];
-
+	offset = svm_msrpm_offset(msr);
 	BUG_ON(offset == MSR_INVALID);
 
-	read  ? clear_bit(bit_read,  &tmp) : set_bit(bit_read,  &tmp);
-	write ? clear_bit(bit_write, &tmp) : set_bit(bit_write, &tmp);
+	__set_msr_interception(msrpm, msr, read, write, offset);
 
-	msrpm[offset] = tmp;
+	if (read || write)
+		kvm_make_request(KVM_REQ_USER_MSR_UPDATE, vcpu);
+}
+
+static void set_user_msr_interception(struct kvm_vcpu *vcpu, u32 msr, int read,
+				      int write)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 *msrpm = svm->msrpm;
+	u32 offset;
+
+	offset = svm_msrpm_offset(msr);
+	if (offset != MSR_INVALID)
+		__set_msr_interception(msrpm, msr, read, write, offset);
+}
+
+void svm_set_user_msr_intercept(struct kvm_vcpu *vcpu, u32 msr)
+{
+	set_user_msr_interception(vcpu, msr, 0, 0);
 }
 
 static void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm)
@@ -4153,6 +4180,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
+
+	.set_user_msr_intercept = svm_set_user_msr_intercept,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index de03df72e742..12478ea7aac7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3725,6 +3725,10 @@ static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
 			__clear_bit(msr, msr_bitmap + 0xc00 / f);
 
 	}
+
+	if (type & MSR_TYPE_R || type & MSR_TYPE_W) {
+		kvm_make_request(KVM_REQ_USER_MSR_UPDATE, vcpu);
+	}
 }
 
 static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
@@ -3792,7 +3796,7 @@ static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
 }
 
 static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu,
-					 unsigned long *msr_bitmap, u8 mode)
+					unsigned long *msr_bitmap, u8 mode)
 {
 	int msr;
 
@@ -3816,6 +3820,11 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu,
 	}
 }
 
+void vmx_set_user_msr_intercept(struct kvm_vcpu *vcpu, u32 msr)
+{
+	vmx_enable_intercept_for_msr(vcpu, msr, MSR_TYPE_RW);
+}
+
 void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -8002,6 +8011,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
+
+	.set_user_msr_intercept = vmx_set_user_msr_intercept,
 };
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b370b3f4b4f3..44cbcf22ec36 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3647,6 +3647,19 @@ bool kvm_msr_user_exit(struct kvm *kvm, u32 index)
 }
 EXPORT_SYMBOL_GPL(kvm_msr_user_exit);
 
+static void kvm_set_user_msr_intercepts(struct kvm_vcpu *vcpu)
+{
+	struct kvm_msr_list *msr_list = vcpu->kvm->arch.user_exit_msrs;
+	u32 i, msr;
+
+	if (msr_list) {
+		for (i = 0; i < msr_list->nmsrs; i++) {
+			msr = msr_list->indices[i];
+			kvm_x86_ops.set_user_msr_intercept(vcpu, msr);
+		}
+	}
+}
+
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r = 0;
@@ -8823,6 +8836,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_vcpu_update_apicv(vcpu);
 		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
 			kvm_check_async_pf_completion(vcpu);
+
+		if (kvm_check_request(KVM_REQ_USER_MSR_UPDATE, vcpu))
+			kvm_set_user_msr_intercepts(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
-- 
2.28.0.220.ged08abb693-goog

