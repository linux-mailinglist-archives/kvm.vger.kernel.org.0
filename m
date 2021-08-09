Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA883E4A5D
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 18:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbhHIQya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 12:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233075AbhHIQy3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 12:54:29 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74792C061796
        for <kvm@vger.kernel.org>; Mon,  9 Aug 2021 09:54:09 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id f3so6438489plg.3
        for <kvm@vger.kernel.org>; Mon, 09 Aug 2021 09:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vKoYQRDH+Wjsz6hbWc1vGfeTf051Y0mGdYB8Ul+Z0Ls=;
        b=kqcMZwS917tKDqBTTwkutmGTpL9mLaRCuS1p3XZ0LpZ14LbgPe0zHQnSwCwja26grr
         3xDMruZmDkriQT3wsNlOJL291BmmG4HIH1iDZ6+47eS6nZuBVUjwb+1T86gjlgytzred
         sY66il0+Q2Ao2Oui/KMQ6z2OX3cDQRFSJ9Vx7q43Qdiud15Bk2Kb2F0UdNGVJBrwlTxd
         0Nu6zOiG69QoPR3GEY8UHQKyom8Ez1qRje7BiIJ7HFlZg0n/BphVhMZiv38XkqsrdQpT
         38+a/GOgdfaoJ4eT8xBCaSWF++wHrUZqXnCgPCuzIFsrrSKTRiHG/GQfVxZ/6Y1L9Ugf
         RwHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vKoYQRDH+Wjsz6hbWc1vGfeTf051Y0mGdYB8Ul+Z0Ls=;
        b=P/re9DrFzNa/lVD6bR7h8G09uW/hNa3Fqi6/fX8mILVpPOCOmbTIh33IFeWCKMAgzR
         En50pOCihIls+WzI3E00wx2TuZBWMtRrI+1Lik7uJxF8e4xjr+ycE1XI/e29WyI/SnlF
         oWEt6O1Rt/Jwdx3DYj8+zSxJgxph9IC15O3q9w9vXo44wnq3tYgUu3Ky5XztscOV/6ol
         ePKmWhGstzsmIMoXAWTHC7+ZYt8xYUdwN/TMk+pQRaqi6sHbfU/f9k2Qudd6XZzxRup3
         XoKzWx5/ta0hAkegL6dUzYXpr3CoZuJ5bUoFeulqJWd9IosxfVya9VdOKgYHe9UAQKYM
         iAgw==
X-Gm-Message-State: AOAM533xU8e9f91E7n4JllAyPjlfgUSDeuD+fyA4p4XO1ydQ+2GNY866
        CaqHyx2RmcA0b1QxBjXKl4mGDg==
X-Google-Smtp-Source: ABdhPJwXA7iilxoGJ2kF9DwWX3NmGW5lCdsCR3FRGZ5QpxqDBdhU07dKj6xtNENdSeRRBCd1JQWNzQ==
X-Received: by 2002:a65:438c:: with SMTP id m12mr455399pgp.163.1628528048716;
        Mon, 09 Aug 2021 09:54:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d20sm1034423pfu.36.2021.08.09.09.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 09:54:08 -0700 (PDT)
Date:   Mon, 9 Aug 2021 16:54:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: Don't reset dr6 unconditionally when the vcpu
 being scheduled out
Message-ID: <YRFdq8sNuXYpgemU@google.com>
References: <20210808232919.862835-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210808232919.862835-1-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 09, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> The commit efdab992813fb ("KVM: x86: fix escape of guest dr6 to the host")
> fixed a bug.  It did a great job and reset dr6 unconditionally when the
> vcpu being scheduled out since the linux kernel only activates breakpoints
> in rescheduling (perf events).
> 
> But writing to debug registers is slow, and it can be shown in perf results
> sometimes even neither the host nor the guest activate breakpoints.
> 
> It'd be better to reset it conditionally and this patch moves the code of
> reseting dr6 to the path of VM-exit where we can check the related
> conditions.  And the comment is also updated.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
> And even in the future, the linux kernel might activate breakpoint
> in interrupts (rather than in rescheduling only),  the host would
> not be confused by the stale dr6 after this patch.  The possible future
> author who would implement it wouldn't need to care about how the kvm
> mananges debug registers since it sticks to the host's expectations.

Eh, I don't think this is a valid argument.  KGBD already manipulates breakpoints
in NMI context, activating breakpoints from interrupt context would absolutely
require a full audit of the kernel.

> Another solution is changing breakpoint.c and make the linux kernel
> always reset dr6 in activating breakpoints.  So that dr6 is allowed
> to be stale when host breakpoints is not enabled and we don't need
> to reset dr6 in this case. But it would be no harm to reset it even in
> both places and killing stale states is good in programing.

Hmm, other than further penalizing guests that enable debug breakpoints.

What about adding a arch.switch_db_regs flag to note that DR6 is loaded with a
guest value and keeping the reset code in kvm_arch_vcpu_put()?

>  arch/x86/kvm/x86.c | 29 +++++++++++++++++++++--------
>  1 file changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4116567f3d44..39b5dad2dd19 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4310,12 +4310,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  
>  	static_call(kvm_x86_vcpu_put)(vcpu);
>  	vcpu->arch.last_host_tsc = rdtsc();
> -	/*
> -	 * If userspace has set any breakpoints or watchpoints, dr6 is restored
> -	 * on every vmexit, but if not, we might have a stale dr6 from the
> -	 * guest. do_debug expects dr6 to be cleared after it runs, do the same.
> -	 */
> -	set_debugreg(0, 6);
>  }
>  
>  static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
> @@ -9375,6 +9369,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	fastpath_t exit_fastpath;
>  
>  	bool req_immediate_exit = false;
> +	bool reset_dr6 = false;
>  
>  	/* Forbid vmenter if vcpu dirty ring is soft-full */
>  	if (unlikely(vcpu->kvm->dirty_ring_size &&
> @@ -9601,6 +9596,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		set_debugreg(vcpu->arch.eff_db[3], 3);
>  		set_debugreg(vcpu->arch.dr6, 6);

Not directly related to this patch, but why does KVM_DEBUGREG_RELOAD exist?
Commit ae561edeb421 ("KVM: x86: DR0-DR3 are not clear on reset") added it to
ensure DR0-3 are fresh when they're modified through non-standard paths, but I
don't see any reason why the new values _must_ be loaded into hardware.  eff_db
needs to be updated, but I don't see why hardware DRs need to be updated unless
hardware breakpoints are active or DR exiting is disabled, and in those cases
updating hardware is handled by KVM_DEBUGREG_WONT_EXIT and KVM_DEBUGREG_BP_ENABLED.

Am I missing something?

>  		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
> +		reset_dr6 = true;
>  	} else if (unlikely(hw_breakpoint_active())) {
>  		set_debugreg(0, 7);
>  	}
> @@ -9631,17 +9627,34 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		kvm_update_dr0123(vcpu);
>  		kvm_update_dr7(vcpu);
>  		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
> +		reset_dr6 = true;
>  	}
>  
>  	/*
>  	 * If the guest has used debug registers, at least dr7
>  	 * will be disabled while returning to the host.
> +	 *
> +	 * If we have active breakpoints in the host, restore the old state.
> +	 *
>  	 * If we don't have active breakpoints in the host, we don't
> -	 * care about the messed up debug address registers. But if
> -	 * we have some of them active, restore the old state.
> +	 * care about the messed up debug address registers but dr6
> +	 * which is expected to be cleared normally.  Otherwise we might
> +	 * leak a stale dr6 from the guest and confuse the host since
> +	 * neither the host reset dr6 on activating next breakpoints nor
> +	 * the hardware clear it on dilivering #DB.  The Intel SDM says:
> +	 *
> +	 *   Certain debug exceptions may clear bits 0-3. The remaining
> +	 *   contents of the DR6 register are never cleared by the
> +	 *   processor. To avoid confusion in identifying debug
> +	 *   exceptions, debug handlers should clear the register before
> +	 *   returning to the interrupted task.
> +	 *
> +	 * Keep it simple and live up to expectations: clear DR6 immediately.
>  	 */
>  	if (hw_breakpoint_active())
>  		hw_breakpoint_restore();
> +	else if (unlikely(reset_dr6))
> +		set_debugreg(DR6_RESERVED, 6);
>  
>  	vcpu->arch.last_vmentry_cpu = vcpu->cpu;
>  	vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
> -- 
> 2.19.1.6.gb485710b
> 
