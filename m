Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBDC43B75B
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 18:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235999AbhJZQkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 12:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbhJZQkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 12:40:19 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72395C061767
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 09:37:55 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id t11so10710242plq.11
        for <kvm@vger.kernel.org>; Tue, 26 Oct 2021 09:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9OJA0DYk/+bmg6KQJ8dcy/bsZjx+8jt3B2rPkt4S2lE=;
        b=suJTGyXg5yWgwl4sIcxUN/D8f+rk/F3yQiQdMFu++jOwCRao/1c9WUOt1UFr63a5mR
         OYJxAMwAxP4OTLrFDM/6182iXFCSCwt2/j/ROIl4usJ+MRREPxF1PuVDMR7CgpGKRU9l
         SUhBBJfD99rYNNN2vnwY9jmUfA65XlXQCk56WvU6jcR8RvemNKMGCFSwk12QUVpePnO2
         a5fchcywm3/zHqThlKcQIrRhsslRt8ITuNhZtb/7sloo5RVCEv3klkScn1Y2YGjg3tXR
         FtazhWu2IydF7VgfJpt2y+Bpw2ZXwx5euGHzjkHYPlvZHV1s4yevTTjuG1rRonM3Q+MK
         Z4Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9OJA0DYk/+bmg6KQJ8dcy/bsZjx+8jt3B2rPkt4S2lE=;
        b=4+1xMwFS8TSkwi3STF8M1poNDh0ldjIa/6IsyfF+/vLJPxeSXwhgahbvLRAy2zxzjX
         /oyowjfFcfiopsE/Wz+ZwRtrwo1GXB/pKcJSibwpyOyNHMFcffbhx9dxBoq9LhBPrf4d
         ferJFdgI5s/UXIcO0stynPkokgd2o1PKkg/gjTgbH6zOdLvPHhRKBWebFxYoVP8iuz6P
         GsMW9VU5aTJpsQz6H/xVUU6tBzFHn+nsgVtAfnVeRlJKZ+A/DOXaipYxDLeAwGDuxyw5
         CwqWMqboUsztmjp25HQg3sYS2yYcZSRvA+vOBIPV1scePxA+fqIGpR31rS/HaaKJfPz6
         QNag==
X-Gm-Message-State: AOAM531o4lfUfoN0khTHTGZbsOAoclHKRPZeX4x+MqiUhZLic5rslWYE
        psL6NXFH83MJ63HGkdKRMb/G+g==
X-Google-Smtp-Source: ABdhPJzjediTuRD9CTnetuoeTHNyo14omSTC3XRhPFY2QJ841gBjAfmJzNBlNl+dcQTFChLPbKr5dg==
X-Received: by 2002:a17:90a:530f:: with SMTP id x15mr30102443pjh.156.1635266274680;
        Tue, 26 Oct 2021 09:37:54 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q18sm25710421pfj.46.2021.10.26.09.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 09:37:54 -0700 (PDT)
Date:   Tue, 26 Oct 2021 16:37:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong93@linux.alibaba.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: VMX: fix instruction skipping when handling UD
 exception
Message-ID: <YXgu3pvk+Ifrl0Yu@google.com>
References: <cover.1634870747.git.houwenlong93@linux.alibaba.com>
 <8ad4de9dae77ee3690ee9bd3c5a51d235d619eb6.1634870747.git.houwenlong93@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ad4de9dae77ee3690ee9bd3c5a51d235d619eb6.1634870747.git.houwenlong93@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 22, 2021, Hou Wenlong wrote:
> When kvm.force_emulation_prefix is enabled, instruction with
> kvm prefix would trigger an UD exception and do instruction
> emulation. The emulation may need to exit to userspace due
> to userspace io, and the complete_userspace_io callback may
> skip instruction, i.e. MSR accesses emulation would exit to
> userspace if userspace wanted to know about the MSR fault.
> However, VM_EXIT_INSTRUCTION_LEN in vmcs is invalid now, it
> should use kvm_emulate_instruction() to skip instruction.
> 
> Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 4 ++--
>  arch/x86/kvm/vmx/vmx.h | 9 +++++++++
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1c8b2b6e7ed9..01049d65da26 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1501,8 +1501,8 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  	 * (namely Hyper-V) don't set it due to it being undefined behavior,
>  	 * i.e. we end up advancing IP with some random value.
>  	 */
> -	if (!static_cpu_has(X86_FEATURE_HYPERVISOR) ||
> -	    exit_reason.basic != EXIT_REASON_EPT_MISCONFIG) {
> +	if (!is_ud_exit(vcpu) && (!static_cpu_has(X86_FEATURE_HYPERVISOR) ||

This is incomplete and is just a workaround for the underlying bug.  The same
mess can occur if the emulator triggers an exit to userspace during "normal"
emulation, e.g. if unrestricted guest is disabled and the guest accesses an MSR
while in Big RM.  In that case, there's no #UD to key off of.

The correct way to fix this is to attach a different callback when the MSR access
comes from the emulator.  I'd say rename the existing complete_emulated_{rd,wr}msr()
callbacks to complete_fast_{rd,wr}msr() to match the port I/O nomenclature.

Something like this (which also has some opportunistic simplification of the
error handling in kvm_emulate_{rd,wr}msr()).

---
 arch/x86/kvm/x86.c | 82 +++++++++++++++++++++++++---------------------
 1 file changed, 45 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac83d873d65b..7ff5b8d58ca3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1814,18 +1814,44 @@ int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
 }
 EXPORT_SYMBOL_GPL(kvm_set_msr);

-static int complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
+static void __complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
 {
-	int err = vcpu->run->msr.error;
-	if (!err) {
+	if (!vcpu->run->msr.error) {
 		kvm_rax_write(vcpu, (u32)vcpu->run->msr.data);
 		kvm_rdx_write(vcpu, vcpu->run->msr.data >> 32);
 	}
+}

-	return static_call(kvm_x86_complete_emulated_msr)(vcpu, err);
+static int complete_emulated_msr_access(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->run->msr.error) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
+	return kvm_emulate_instruction(vcpu, EMULTYPE_SKIP);
+}
+
+static int complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
+{
+	__complete_emulated_rdmsr(vcpu);
+
+	return complete_emulated_msr_access(vcpu);
 }

 static int complete_emulated_wrmsr(struct kvm_vcpu *vcpu)
+{
+	return complete_emulated_msr_access(vcpu);
+}
+
+static int complete_fast_rdmsr(struct kvm_vcpu *vcpu)
+{
+	__complete_emulated_rdmsr(vcpu);
+
+	return static_call(kvm_x86_complete_emulated_msr)(vcpu, vcpu->run->msr.error);
+}
+
+static int complete_fast_wrmsr(struct kvm_vcpu *vcpu)
 {
 	return static_call(kvm_x86_complete_emulated_msr)(vcpu, vcpu->run->msr.error);
 }
@@ -1864,18 +1890,6 @@ static int kvm_msr_user_space(struct kvm_vcpu *vcpu, u32 index,
 	return 1;
 }

-static int kvm_get_msr_user_space(struct kvm_vcpu *vcpu, u32 index, int r)
-{
-	return kvm_msr_user_space(vcpu, index, KVM_EXIT_X86_RDMSR, 0,
-				   complete_emulated_rdmsr, r);
-}
-
-static int kvm_set_msr_user_space(struct kvm_vcpu *vcpu, u32 index, u64 data, int r)
-{
-	return kvm_msr_user_space(vcpu, index, KVM_EXIT_X86_WRMSR, data,
-				   complete_emulated_wrmsr, r);
-}
-
 int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 {
 	u32 ecx = kvm_rcx_read(vcpu);
@@ -1883,19 +1897,15 @@ int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 	int r;

 	r = kvm_get_msr(vcpu, ecx, &data);
-
-	/* MSR read failed? See if we should ask user space */
-	if (r && kvm_get_msr_user_space(vcpu, ecx, r)) {
-		/* Bounce to user space */
-		return 0;
-	}
-
 	if (!r) {
 		trace_kvm_msr_read(ecx, data);

 		kvm_rax_write(vcpu, data & -1u);
 		kvm_rdx_write(vcpu, (data >> 32) & -1u);
 	} else {
+		if (kvm_msr_user_space(vcpu, ecx, KVM_EXIT_X86_RDMSR, 0,
+				       complete_fast_rdmsr, r))
+			return 0;
 		trace_kvm_msr_read_ex(ecx);
 	}

@@ -1910,20 +1920,16 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 	int r;

 	r = kvm_set_msr(vcpu, ecx, data);
-
-	/* MSR write failed? See if we should ask user space */
-	if (r && kvm_set_msr_user_space(vcpu, ecx, data, r))
-		/* Bounce to user space */
-		return 0;
-
-	/* Signal all other negative errors to userspace */
-	if (r < 0)
-		return r;
-
-	if (!r)
+	if (!r) {
 		trace_kvm_msr_write(ecx, data);
-	else
+	} else {
+		if (kvm_msr_user_space(vcpu, ecx, KVM_EXIT_X86_WRMSR, data,
+				       complete_fast_wrmsr, r))
+			return 0;
+		if (r < 0)
+			return r;
 		trace_kvm_msr_write_ex(ecx, data);
+	}

 	return static_call(kvm_x86_complete_emulated_msr)(vcpu, r);
 }
@@ -7387,7 +7393,8 @@ static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,

 	r = kvm_get_msr(vcpu, msr_index, pdata);

-	if (r && kvm_get_msr_user_space(vcpu, msr_index, r)) {
+	if (r && kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_RDMSR, 0,
+				    complete_emulated_rdmsr, r)) {
 		/* Bounce to user space */
 		return X86EMUL_IO_NEEDED;
 	}
@@ -7403,7 +7410,8 @@ static int emulator_set_msr(struct x86_emulate_ctxt *ctxt,

 	r = kvm_set_msr(vcpu, msr_index, data);

-	if (r && kvm_set_msr_user_space(vcpu, msr_index, data, r)) {
+	if (r && kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_WRMSR, data,
+				    complete_emulated_wrmsr, r)) {
 		/* Bounce to user space */
 		return X86EMUL_IO_NEEDED;
 	}
--
