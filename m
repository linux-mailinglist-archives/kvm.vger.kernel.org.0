Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC8B369C79
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 00:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbhDWWTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 18:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbhDWWTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 18:19:53 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFEAC06174A
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 15:19:16 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 7-20020a5b01070000b02904ed6442e5f6so2722175ybx.23
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 15:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=ZeMCYbj1aYDCT611v/iAK4CU8ivRbdiEyLm96+1Ix7Y=;
        b=Pt7uCfyTVNCA6uCGkxBae7hS3KK28MR5DU5pV8ZnuvpsWobv3JBSznmaRbPFnLNN/Q
         kyBauWTh5Xh3/0ZkaC6GOjMxbPzrUE4JvpP/9zvhYHmdWokTzlvueNplDesUnRiKy/jX
         NN7yPceYTYp+fYhMcUkQZ7MAGZ3s4fvXkShN10CSJw0zWvEt3/anC8TEDrVBpVsi6KcA
         ugZ3QjcNg7Z5+MdKOzzPgrrS5yDr0SlP5RZkfVENDiILKX4IBKtHeR7lhmTcVLHhJBYK
         YWpeLLjVF0MZFj8VYFzAyPiWfu09VoT6VCz13wVSjhOsGKFy1pDkUtxvDdySdYTBvkAY
         n4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=ZeMCYbj1aYDCT611v/iAK4CU8ivRbdiEyLm96+1Ix7Y=;
        b=EI7m+99N+BRBrA4OwlPQ8VBXd0Aj/+JarDrtVh9zPL+V6rrPmsmrwpPrFzM6uEHvbw
         FyLFA+kY7OgJk5NP1GCar91WWBHqkZ249AD6dCe6gN3b7MLpzE/aYK4b4jl01MV/3p7B
         CSe8LZ+r59GSHgIs/i12vtw1rQ96rqnthAnMkj+NqqfDogRGO4FyOnnMNWIc99r8OaO4
         ShjKl8iBxSbW5ldVwVsYIzjwV/sLDTz8nPpuq+N0gzOt4W92bE+ow55tzUVn7/Pmt2aP
         L975LDsSgfgw51Fn9k4UIRajvoH6sy7imAakkKc67s4NAbPI5RX1mB53ARXXoFK6fNIU
         JNZQ==
X-Gm-Message-State: AOAM5309kN94z5zczM7U+DFw7EkPJzajBMkplyQWcLCHqgHcU1nidEVx
        HkkSC4b3AE79gMjSpsZrMtcm5eVa2Ek=
X-Google-Smtp-Source: ABdhPJzg0VE4zv3xkrjxBhvKB/coMS12ngomMzmKvcqVHJBKUcZUJ1+Wd24Az2sIhxMZFu4d217A5rp39pY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:840c:: with SMTP id u12mr8338990ybk.345.1619216355427;
 Fri, 23 Apr 2021 15:19:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 15:19:12 -0700
Message-Id: <20210423221912.3857243-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH] KVM: VMX: Invert the inlining of MSR interception helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Invert the inline declarations of the MSR interception helpers between
the wrapper, vmx_set_intercept_for_msr(), and the core implementations,
vmx_{dis,en}able_intercept_for_msr().  Letting the compiler _not_
inline the implementation reduces KVM's code footprint by ~3k bytes.

Back when the helpers were added in commit 904e14fb7cb9 ("KVM: VMX: make
MSR bitmaps per-VCPU"), both the wrapper and the implementations were
__always_inline because the end code distilled down to a few conditionals
and a bit operation.  Today, the implementations involve a variety of
checks and bit ops in order to support userspace MSR filtering.

Furthermore, the vast majority of calls to manipulate MSR interception
are not performance sensitive, e.g. vCPU creation and x2APIC toggling.
On the other hand, the one path that is performance sensitive, dynamic
LBR passthrough, uses the wrappers, i.e. is largely untouched by
inverting the inlining.

In short, forcing the low level MSR interception code to be inlined no
longer makes sense.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 17 ++---------------
 arch/x86/kvm/vmx/vmx.h | 15 +++++++++++++--
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6501d66167b8..b77bc72d97a4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -362,8 +362,6 @@ static const struct kernel_param_ops vmentry_l1d_flush_ops = {
 module_param_cb(vmentry_l1d_flush, &vmentry_l1d_flush_ops, NULL, 0644);
 
 static u32 vmx_segment_access_rights(struct kvm_segment *var);
-static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
-							  u32 msr, int type);
 
 void vmx_vmexit(void);
 
@@ -3818,8 +3816,7 @@ static void vmx_set_msr_bitmap_write(ulong *msr_bitmap, u32 msr)
 		__set_bit(msr & 0x1fff, msr_bitmap + 0xc00 / f);
 }
 
-static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
-							  u32 msr, int type)
+void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
@@ -3864,8 +3861,7 @@ static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
 		vmx_clear_msr_bitmap_write(msr_bitmap, msr);
 }
 
-static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
-							 u32 msr, int type)
+void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
@@ -3898,15 +3894,6 @@ static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
 		vmx_set_msr_bitmap_write(msr_bitmap, msr);
 }
 
-void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
-						      u32 msr, int type, bool value)
-{
-	if (value)
-		vmx_enable_intercept_for_msr(vcpu, msr, type);
-	else
-		vmx_disable_intercept_for_msr(vcpu, msr, type);
-}
-
 static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
 {
 	u8 mode = 0;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 19fe09fad2fe..008cb87ff088 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -392,8 +392,19 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
-void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
-	u32 msr, int type, bool value);
+
+void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
+void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
+
+static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
+					     int type, bool value)
+{
+	if (value)
+		vmx_enable_intercept_for_msr(vcpu, msr, type);
+	else
+		vmx_disable_intercept_for_msr(vcpu, msr, type);
+}
+
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
 
 static inline u8 vmx_get_rvi(void)
-- 
2.31.1.498.g6c1eba8ee3d-goog

