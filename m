Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5132DA0B3
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 20:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502514AbgLNTjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 14:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502231AbgLNTjM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 14:39:12 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A931C0613D6
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 11:38:32 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id w16so13279860pga.9
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 11:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7ML7ThXu8y4LI3MvZ4tRJfKc7dUKZJX7duL+1BfFjz4=;
        b=nng+F48fGur3o1uwwTgM/1tCRsagqNFpojAjfFep0QysXyAcifr8JuIm9qxFuAMgCh
         5WaRdBqfhtwWAg91tH7D4YUWd+40dnYLECgA99C+q8LLM/AiUNO2QUVfTzJyW0tmX2iO
         1hwk4iVsqmeV6g37Q/KpUBVY5wpNpPvHIg/brXueB+Z1SQXdiURqGWi9LO8ctSSevKcP
         Mfdz0Us5LlLAtxcTJ1v00aCyS6BSXcYT1TYpXk0T1MraNB0Y+BhCZYaQEcgdfW/gR20Y
         122w/B2A0AycQeBoDqy7BmigwpkcK8UulBjK/xHXoTEPP5p0fXYOu9R927Al/SBmZqPv
         Z7BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7ML7ThXu8y4LI3MvZ4tRJfKc7dUKZJX7duL+1BfFjz4=;
        b=CSkgm1qYFE6157Ava/2wqWQCEcYcU6gW3awoUXHqE5qS+tYOsS8CvkcpmlrBOiyiOj
         Ib+9Mf5QXFzVdoq0uW013Qgf0e9VXGFeMGr15HVTA/eoEheLTT64g1oMzGELHOHEhlCU
         RJTKewJuNTP5LNzVUg7iPMRwsTWuZzE1ydjkGImluG0Xl/RbHSPmE/J+5Csh5BotRI27
         IqubYRbvpKVYzvPgD5S/elVFor3liBCKoztqDfmzvT5dxA8Fi7Ju3UO1Zn7mdo1x1FB8
         vgRgQZEQhZjLekxQusGZMbqQbrECk31gYJ2CB7r72DtASH7+4NKzYLx0LhPMl8qApfPU
         SRjA==
X-Gm-Message-State: AOAM533FMWNbG1eCF4fO2gRrvlld4EWaZ0nhJ7oFJLvAs/OcfSsN41H7
        HhfYqL8c8O7q21gbKuCKrHK5JQ==
X-Google-Smtp-Source: ABdhPJzZbXVpUg3QFZ/YUx6ClXATAvESyuTowwoLEVEoFfBa0X5Mc/V8DGVRR8RnRMEZP721M9afmQ==
X-Received: by 2002:aa7:9501:0:b029:155:3b11:d5c4 with SMTP id b1-20020aa795010000b02901553b11d5c4mr24567294pfp.76.1607974711328;
        Mon, 14 Dec 2020 11:38:31 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id c62sm17084018pfa.116.2020.12.14.11.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 11:38:30 -0800 (PST)
Date:   Mon, 14 Dec 2020 11:38:23 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
Message-ID: <X9e/L3YTAT/N+ljh@google.com>
References: <20201214174127.1398114-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214174127.1398114-1-michael.roth@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Andy, who provided a lot of feedback on v1.

On Mon, Dec 14, 2020, Michael Roth wrote:

Cc: Andy Lutomirski <luto@kernel.org>

> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
> v2:
> * rebase on latest kvm/next
> * move VMLOAD to just after vmexit so we can use it to handle all FS/GS
>   host state restoration and rather than relying on loadsegment() and
>   explicit write to MSR_GS_BASE (Andy)
> * drop 'host' field from struct vcpu_svm since it is no longer needed
>   for storing FS/GS/LDT state (Andy)
> ---
>  arch/x86/kvm/svm/svm.c | 44 ++++++++++++++++--------------------------
>  arch/x86/kvm/svm/svm.h | 14 +++-----------
>  2 files changed, 20 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 0e52fac4f5ae..fb15b7bd461f 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1367,15 +1367,19 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  		vmcb_mark_all_dirty(svm->vmcb);
>  	}
>  
> -#ifdef CONFIG_X86_64
> -	rdmsrl(MSR_GS_BASE, to_svm(vcpu)->host.gs_base);
> -#endif
> -	savesegment(fs, svm->host.fs);
> -	savesegment(gs, svm->host.gs);
> -	svm->host.ldt = kvm_read_ldt();
> -
> -	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
> +	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
>  		rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
> +	}

Unnecessary change that violates preferred coding style.  Checkpatch explicitly
complains about this.

WARNING: braces {} are not necessary for single statement blocks
#132: FILE: arch/x86/kvm/svm/svm.c:1370:
+	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
 		rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
+

> +
> +	asm volatile(__ex("vmsave")
> +		     : : "a" (page_to_pfn(sd->save_area) << PAGE_SHIFT)

I'm pretty sure this can be page_to_phys().

> +		     : "memory");

I think we can defer this until we're actually planning on running the guest,
i.e. put this in svm_prepare_guest_switch().

> +	/*
> +	 * Store a pointer to the save area to we can access it after
> +	 * vmexit for vmload. This is needed since per-cpu accesses
> +	 * won't be available until GS is restored as part of vmload
> +	 */
> +	svm->host_save_area = sd->save_area;

Unless I'm missing something with how SVM loads guest state, you can avoid
adding host_save_area by saving the PA of the save area on the stack prior to
the vmload of guest state.

>  
>  	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
>  		u64 tsc_ratio = vcpu->arch.tsc_scaling_ratio;
> @@ -1403,18 +1407,10 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
>  	avic_vcpu_put(vcpu);
>  
>  	++vcpu->stat.host_state_reload;
> -	kvm_load_ldt(svm->host.ldt);
> -#ifdef CONFIG_X86_64
> -	loadsegment(fs, svm->host.fs);
> -	wrmsrl(MSR_KERNEL_GS_BASE, current->thread.gsbase);
> -	load_gs_index(svm->host.gs);
> -#else
> -#ifdef CONFIG_X86_32_LAZY_GS
> -	loadsegment(gs, svm->host.gs);
> -#endif
> -#endif
> -	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
> +
> +	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
>  		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
> +	}

Same bogus change and checkpatch warning.

>  }
>  
>  static unsigned long svm_get_rflags(struct kvm_vcpu *vcpu)
> @@ -3507,14 +3503,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>  
>  	__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);

Tying in with avoiding svm->host_save_area, what about passing in the PA of the
save area and doing the vmload in __svm_vcpu_run()?  One less instance of inline
assembly to stare at...

>  
> -#ifdef CONFIG_X86_64
> -	native_wrmsrl(MSR_GS_BASE, svm->host.gs_base);
> -#else
> -	loadsegment(fs, svm->host.fs);
> -#ifndef CONFIG_X86_32_LAZY_GS
> -	loadsegment(gs, svm->host.gs);
> -#endif
> -#endif
> +	asm volatile(__ex("vmload")
> +		     : : "a" (page_to_pfn(svm->host_save_area) << PAGE_SHIFT));
>  
>  	/*
>  	 * VMEXIT disables interrupts (host state), but tracing and lockdep
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index fdff76eb6ceb..bf01a8c19ec0 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -21,11 +21,6 @@
>  #include <asm/svm.h>
>  
>  static const u32 host_save_user_msrs[] = {
> -#ifdef CONFIG_X86_64
> -	MSR_STAR, MSR_LSTAR, MSR_CSTAR, MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
> -	MSR_FS_BASE,
> -#endif
> -	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
>  	MSR_TSC_AUX,

With this being whittled down to TSC_AUX, a good follow-on series would be to
add SVM usage of the "user return" MSRs to handle TSC_AUX.  If no one objects,
I'll plan on doing that in the not-too-distant future as a ramp task of sorts.

>  };
>  
> @@ -117,12 +112,9 @@ struct vcpu_svm {
>  	u64 next_rip;
>  
>  	u64 host_user_msrs[NR_HOST_SAVE_USER_MSRS];
> -	struct {
> -		u16 fs;
> -		u16 gs;
> -		u16 ldt;
> -		u64 gs_base;
> -	} host;
> +
> +	/* set by vcpu_load(), for use when per-cpu accesses aren't available */
> +	struct page *host_save_area;
>  
>  	u64 spec_ctrl;
>  	/*
> -- 
> 2.25.1
> 
