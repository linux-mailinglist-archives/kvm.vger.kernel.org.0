Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A14623B3CD
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 06:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgHDEVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 00:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgHDEVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 00:21:04 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C13C06174A
        for <kvm@vger.kernel.org>; Mon,  3 Aug 2020 21:21:04 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id t11so16112044pfq.21
        for <kvm@vger.kernel.org>; Mon, 03 Aug 2020 21:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CAgmMnQwHlrdjfSqIwoZHX1Ll3mqpCJfgOQXx/NjxeQ=;
        b=owNHARPAa4aHvNLpWZa8sHYePvwqbiy5JNc1ETIZSoUNwLkzyAsaA4B4uPlBsOOnlc
         QIhlQd450vjbwRcLVvU8m8bt3isNn12mr5iwL44DJNZQ0g+2ko9FjXJYq07KU/xgCaFw
         JViBu76QUk7n53boGOImpxIhgxpL2VYdRr0VhjnnoL5vpKl0jAiSW/s8YyRwY6/Qo6Ry
         ihksff9RjXasAc9V/RCVowE9NLn8SM4fRlguY8ONwCSladjAWe2iiGTPggodOt+TdADX
         joWYRUxkn7odWDermiE6tcq09d0T3wrTHR9xnxg3Y5VR1K05/Em8fHi3UnFMWzoH4dZn
         j00w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CAgmMnQwHlrdjfSqIwoZHX1Ll3mqpCJfgOQXx/NjxeQ=;
        b=FemeeC78R97nJzJLIaIKxgHub2A2bKrBjeyeLvBMDxdL2ebz1ofg3s8KuOwWcCtKwx
         lbWYi6YrLTz78ghI52n0m7mnj+9aSMB9BMB8h3/Sfpzlih7a5cmrk/92mhtsBqOZU2J/
         XF3XqlJMnA3D+y28xQPGPHEJ/aGW1HoJx0f+UJbhSkCLTFxmylb1YIU3uueQgiZ/9wf1
         1ykMaGIwzyQKrMh6wUxMfnnzU5+lwPrNOtf5JFWkChSqel9CL57edInGfFAcrY1KgZ2t
         SUl+sSb0CwGsTNHPS7UhqlgMzf3ydz/gA0IQW4eWyfbrwPHzzu0gFbD5qVDVQk15vx/Z
         T40A==
X-Gm-Message-State: AOAM532FFYE4pif0QNH4METCHIMZ5buh4AQm7fwU8qAp0FKfH7s9BQfH
        hNhUyzg1WaD11gjmDW3CK5sncv4yfEIGLLdk
X-Google-Smtp-Source: ABdhPJxRAdg50atCF+2pd4wif38GcvMqDRKlsxavnM+r2JyjaWkQSma1kQq1a7CEadmzTDxZs1COUiFRTFk20ZWN
X-Received: by 2002:a63:fd03:: with SMTP id d3mr17619482pgh.76.1596514863450;
 Mon, 03 Aug 2020 21:21:03 -0700 (PDT)
Date:   Mon,  3 Aug 2020 21:20:41 -0700
In-Reply-To: <20200804042043.3592620-1-aaronlewis@google.com>
Message-Id: <20200804042043.3592620-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20200804042043.3592620-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
Subject: [PATCH 4/6] KVM: x86: Ensure the MSR bitmap never clears userspace
 tracked MSRs
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
index 510055471dd0..07a85f5f0b8a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -87,6 +87,7 @@
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(27, KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_APF_READY		KVM_ARCH_REQ(28)
+#define KVM_REQ_USER_MSR_UPDATE KVM_ARCH_REQ(29)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -1271,6 +1272,8 @@ struct kvm_x86_ops {
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
+
+	void (*set_user_msr_intercept)(struct kvm_vcpu *vcpu, u32 msr);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index eb673b59f7b7..c560d283b2af 100644
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
@@ -4088,6 +4115,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
+
+	.set_user_msr_intercept = svm_set_user_msr_intercept,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1313e47a5a1e..3d3d9eaeca64 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3728,6 +3728,10 @@ static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
 			__clear_bit(msr, msr_bitmap + 0xc00 / f);
 
 	}
+
+	if (type & MSR_TYPE_R || type & MSR_TYPE_W) {
+		kvm_make_request(KVM_REQ_USER_MSR_UPDATE, vcpu);
+	}
 }
 
 static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
@@ -3795,7 +3799,7 @@ static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
 }
 
 static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu,
-					 unsigned long *msr_bitmap, u8 mode)
+					unsigned long *msr_bitmap, u8 mode)
 {
 	int msr;
 
@@ -3819,6 +3823,11 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu,
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
@@ -7965,6 +7974,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
+
+	.set_user_msr_intercept = vmx_set_user_msr_intercept,
 };
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 47619b49818a..45bf59f94d34 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3537,6 +3537,19 @@ bool kvm_msr_user_exit(struct kvm *kvm, u32 index)
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
@@ -8553,6 +8566,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_vcpu_update_apicv(vcpu);
 		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
 			kvm_check_async_pf_completion(vcpu);
+
+		if (kvm_check_request(KVM_REQ_USER_MSR_UPDATE, vcpu))
+			kvm_set_user_msr_intercepts(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
-- 
2.28.0.163.g6104cc2f0b6-goog

