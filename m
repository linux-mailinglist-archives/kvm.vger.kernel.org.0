Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E316241175
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 22:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgHJUL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 16:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbgHJUL5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 16:11:57 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA8AC061787
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 13:11:57 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id y10so7507466plp.6
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 13:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vMfoBO7nBJeomzdNZAfqP4kKn3LHAx4KtNydfQWOUvY=;
        b=mSZ07bh7fcEy9UixbUl9HQf/fuMlTOmLjhafIPqKwMpso/Td57Kf3gncedJFy6vhd8
         VyOKeX9nDL5LmbVxWtdPOeuGNCO1LDlC6GhI3w6lIrzvhc2ZXkhiyHDFFDI4OKx0eytv
         7STB2Tf0lNwd7qRLF/mv92A6PpzTdFezj8BQ7zo1ZAnFguFjKUYwjmSn6AQCdsdCbzUz
         fuEvqsMPI8lYuld07Wdou5Z94G173yNNFRMgLcGBmvZaKT4cQXRdVNW90s9mKxhEHpul
         f+XkXwKoAC29FM4GEr5oRl7S5xVtrnfFUd2s12uuH73y0hzK+CMiA/YGDIp4CXvrwtkx
         CSpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vMfoBO7nBJeomzdNZAfqP4kKn3LHAx4KtNydfQWOUvY=;
        b=VdIo7XUKUpl+QDmlNIbbgzQPwk6MnyLtwtUCw80w9XvP8VPiytMciJPJY2u+5lwR38
         e6FfTe2hzS82Een2G8223suttdCMD+EfXxLSBn137ly0KxAwfvqAOO6WGA6JJAyUw93I
         Qg0mDdZQzCyfDhQYIo0OyreuDR6RvdyGHidOGsxH2XCL0ZvDaZMljVKWZoNogDiU7eWP
         +UmzFPn0Cyk7KeIe0uDCNhpGGa+FTji1noyVha39azUl5PB6CUF48rOoclmTTplf0Yq9
         G0Ht0r6zm0nInP4VWkH2wjhsEr974Th2MVRfn6mIvIQkPADT7stxsUzlq5wcqrXEG2K1
         X8kQ==
X-Gm-Message-State: AOAM532WPyS6HVLSdERvbumTpdAl7vHOcS0lCigMol2j+IoIXs6NwLzx
        mqZ0SZAx1j31olfHUXur0/nAp9V+wLNUhcJi
X-Google-Smtp-Source: ABdhPJx+RNosn8DwAGvGubjSRxUkYLsVnopy23TtK2d5wT51KYL14jXwO6hc77+hw6wQphaKZluwx4iUGCMfza+v
X-Received: by 2002:a17:90a:3488:: with SMTP id p8mr192043pjb.1.1597090316804;
 Mon, 10 Aug 2020 13:11:56 -0700 (PDT)
Date:   Mon, 10 Aug 2020 13:11:31 -0700
In-Reply-To: <20200810201134.2031613-1-aaronlewis@google.com>
Message-Id: <20200810201134.2031613-6-aaronlewis@google.com>
Mime-Version: 1.0
References: <20200810201134.2031613-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH v2 5/8] KVM: x86: Ensure the MSR bitmap never clears userspace
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
index 4dff6147557e..b79600086bd3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3555,6 +3555,19 @@ bool kvm_msr_user_exit(struct kvm *kvm, u32 index)
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
@@ -8583,6 +8596,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_vcpu_update_apicv(vcpu);
 		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
 			kvm_check_async_pf_completion(vcpu);
+
+		if (kvm_check_request(KVM_REQ_USER_MSR_UPDATE, vcpu))
+			kvm_set_user_msr_intercepts(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
-- 
2.28.0.236.gb10cc79966-goog

