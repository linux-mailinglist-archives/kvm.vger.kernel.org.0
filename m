Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67A01F1AEA
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 16:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729949AbgFHOY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 10:24:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56600 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729776AbgFHOY1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 10:24:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591626267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RvqpRgRgvNRWBq4GX41/PVrRgf4iheRb8T7cXZ3C5KA=;
        b=PcdNDAnjjZTXUbVoSbAznyjlkeRjIZQi7FBXQEbBIjhvcOT/3clzSA5ty3NdxEI/7amfy7
        Un+5+vUuRpxEXemBMVvY1pjG1hNkJrpER7JsIDD1gtPI8Tj2HxIwDZuTwubi6LSTX/azXU
        5Yz1O9hTuj5SEwWiudS8k6HSzDQHV7I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-35K7qlVcMs6UGdUd9djO3Q-1; Mon, 08 Jun 2020 10:24:23 -0400
X-MC-Unique: 35K7qlVcMs6UGdUd9djO3Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 018EF8018A7;
        Mon,  8 Jun 2020 14:24:21 +0000 (UTC)
Received: from starship-rhel (unknown [10.35.206.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE2538926C;
        Mon,  8 Jun 2020 14:24:15 +0000 (UTC)
Message-ID: <48581807ab540690d970d499c8c311f1735b3222.camel@redhat.com>
Subject: Re: [PATCH] x86/cpu: Reinitialize IA32_FEAT_CTL MSR on BSP during
 wakeup
From:   mlevitsk <mlevitsk@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Brad Campbell <lists2009@fnarfbargle.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Date:   Mon, 08 Jun 2020 17:24:14 +0300
In-Reply-To: <20200605200728.10145-1-sean.j.christopherson@intel.com>
References: <20200605200728.10145-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2020-06-05 at 13:07 -0700, Sean Christopherson wrote:
> Reinitialize IA32_FEAT_CTL on the BSP during wakeup to handle the
> case
> where firmware doesn't initialize or save/restore across S3.  This
> fixes
> a bug where IA32_FEAT_CTL is left uninitialized and results in VMXON
> taking a #GP due to VMX not being fully enabled, i.e. breaks KVM.
> 
> Use init_ia32_feat_ctl() to "restore" IA32_FEAT_CTL as it already
> deals
> with the case where the MSR is locked, and because APs already redo
> init_ia32_feat_ctl() during suspend by virtue of the SMP boot flow
> being
> used to reinitialize APs upon wakeup.  Do the call in the early
> wakeup
> flow to avoid dependencies in the syscore_ops chain, e.g. simply
> adding
> a resume hook is not guaranteed to work, as KVM does VMXON in its own
> resume hook, kvm_resume(), when KVM has active guests.
> 
> Reported-by: Brad Campbell <lists2009@fnarfbargle.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Fixes: 21bd3467a58e ("KVM: VMX: Drop initialization of IA32_FEAT_CTL
> MSR")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/cpu.h | 5 +++++
>  arch/x86/kernel/cpu/cpu.h  | 4 ----
>  arch/x86/power/cpu.c       | 6 ++++++
>  3 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
> index dd17c2da1af5..da78ccbd493b 100644
> --- a/arch/x86/include/asm/cpu.h
> +++ b/arch/x86/include/asm/cpu.h
> @@ -58,4 +58,9 @@ static inline bool handle_guest_split_lock(unsigned
> long ip)
>  	return false;
>  }
>  #endif
> +#ifdef CONFIG_IA32_FEAT_CTL
> +void init_ia32_feat_ctl(struct cpuinfo_x86 *c);
> +#else
> +static inline void init_ia32_feat_ctl(struct cpuinfo_x86 *c) {}
> +#endif
>  #endif /* _ASM_X86_CPU_H */
> diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
> index 37fdefd14f28..38ab6e115eac 100644
> --- a/arch/x86/kernel/cpu/cpu.h
> +++ b/arch/x86/kernel/cpu/cpu.h
> @@ -80,8 +80,4 @@ extern void x86_spec_ctrl_setup_ap(void);
>  
>  extern u64 x86_read_arch_cap_msr(void);
>  
> -#ifdef CONFIG_IA32_FEAT_CTL
> -void init_ia32_feat_ctl(struct cpuinfo_x86 *c);
> -#endif
> -
>  #endif /* ARCH_X86_CPU_H */
> diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
> index aaff9ed7ff45..b0d3c5ca6d80 100644
> --- a/arch/x86/power/cpu.c
> +++ b/arch/x86/power/cpu.c
> @@ -193,6 +193,8 @@ static void fix_processor_context(void)
>   */
>  static void notrace __restore_processor_state(struct saved_context
> *ctxt)
>  {
> +	struct cpuinfo_x86 *c;
> +
>  	if (ctxt->misc_enable_saved)
>  		wrmsrl(MSR_IA32_MISC_ENABLE, ctxt->misc_enable);
>  	/*
> @@ -263,6 +265,10 @@ static void notrace
> __restore_processor_state(struct saved_context *ctxt)
>  	mtrr_bp_restore();
>  	perf_restore_debug_store();
>  	msr_restore_context(ctxt);
> +
> +	c = &cpu_data(smp_processor_id());
> +	if (cpu_has(c, X86_FEATURE_MSR_IA32_FEAT_CTL))
> +		init_ia32_feat_ctl(c);
>  }
>  
>  /* Needed by apm.c */


I don't have currently an active VMX system to test this on,
but from the code and from my knowelege of this area this looks all
right.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

