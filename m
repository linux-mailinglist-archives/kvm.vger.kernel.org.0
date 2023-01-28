Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14E567F338
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 01:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbjA1Ahb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 19:37:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjA1Ah3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 19:37:29 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DB81C31C
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 16:37:28 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id b24-20020a17090a551800b0022beefa7a23so10233011pji.5
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 16:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=X9rFteB/OvrIgZT76ETC3cs4lJmFmkP7IRP2qqR/ZH4=;
        b=Inae36NNwscklWednII+BkctwitcyZOXU5Lpll1cnbzVMokTHfm+d3ek79KM8u38lQ
         Oodg15MUbiv3U9oEaBtA7JRgfu2Qeg3hpLhvAvTtNG0jWstuNAcWU6RtBMFK+BdWyWPF
         dpCOZqOP0Bf8OS49i4/E0dFh4uNfOK4oAhYdMnuuQztzTQGnwaRVp79rNoJwRkmqtEdZ
         CDKj6B+83j88LF4HYi7rzDUszQo3oWuP6NKZa2xhIa6w1lLCtWT2L+GeTYnXt3hXe9r3
         Khh27YfgrFX4h4GVtKReYZWqXtd8zVZX++6aUYRY7tQmbQIYPR4X9w5OUr9w9vO2DrFK
         eU8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X9rFteB/OvrIgZT76ETC3cs4lJmFmkP7IRP2qqR/ZH4=;
        b=JtEi/LPI85VDHEnZInrbCf77THsBQFM588Y1zCSIRpJkKgTr5UbnL0NMYV1czgJeAV
         xY/cTcQWLlVhQVAuNox3cTHZ0gIUgFoj57SzGYiU71akKFZWtiyrzpNUVJ0+3tDP961e
         bWKkPDVN27nfpgZ5kiodQCQbB4UANklbaBmHKnJ0clvquORKXvGsUYgYLl7iE+3rduWG
         KRnAcuMzmmxO8f6U+5hTKxstXcwNgl4YrkTjkBq1npVmfAiN4vAve52oOj1mMUYwXlLx
         09xe/2jlWJRn0IsOf+v5slsxH6FdLQISSarCDMHacEIlXEKbHQ9YkL+LuooT8j51Er8H
         fpJw==
X-Gm-Message-State: AO0yUKXxdVtH+W0RfInnpKCvb2HIMhyMq83AeYRzyTJNzGIfaNDUNPQI
        VMecd3pTjJgxB+D4Kw1O0a9b1Q==
X-Google-Smtp-Source: AK7set/nRB49McILBM66+YZXvGUfNKEMOv5Ivj8SB4uU2ic1MTlNVvfCij9/1gg+SJw/R7olGOkRdg==
X-Received: by 2002:a17:90a:6949:b0:219:f970:5119 with SMTP id j9-20020a17090a694900b00219f9705119mr207876pjm.1.1674866248063;
        Fri, 27 Jan 2023 16:37:28 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y7-20020a17090a474700b0022bae41c820sm3230160pjg.56.2023.01.27.16.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 16:37:27 -0800 (PST)
Date:   Sat, 28 Jan 2023 00:37:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 02/11] KVM: nSVM: clean up the copying of V_INTR bits
 from vmcb02 to vmcb12
Message-ID: <Y9RuQz8dAT7DZGYk@google.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221129193717.513824-3-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 29, 2022, Maxim Levitsky wrote:
> the V_IRQ and v_TPR bits don't exist when virtual interrupt
> masking is not enabled, therefore the KVM should not copy these
> bits regardless of V_IRQ intercept.

Hmm, the APM disagrees:

 The APIC's TPR always controls the task priority for physical interrupts, and the
 V_TPR always controls virtual interrupts.

   While running a guest with V_INTR_MASKING cleared to 0:
     • Writes to CR8 affect both the APIC's TPR and the V_TPR register.


 ...

 The three VMCB fields V_IRQ, V_INTR_PRIO, and V_INTR_VECTOR indicate whether there
 is a virtual interrupt pending, and, if so, what its vector number and priority are.

IIUC, V_INTR_MASKING_MASK is mostly about EFLAGS.IF, with a small side effect on
TPR.  E.g. a VMM could pend a V_IRQ but clear V_INTR_MASKING and expect the guest
to take the V_IRQ.  At least, that's my reading of things.

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 23 ++++++++---------------
>  1 file changed, 8 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 37af0338da7c32..aad3145b2f62fe 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -412,24 +412,17 @@ void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
>   */
>  void nested_sync_control_from_vmcb02(struct vcpu_svm *svm)
>  {
> -	u32 mask;
> +	u32 mask = 0;
>  	svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
>  	svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
>  
> -	/* Only a few fields of int_ctl are written by the processor.  */
> -	mask = V_IRQ_MASK | V_TPR_MASK;
> -	if (!(svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK) &&
> -	    svm_is_intercept(svm, INTERCEPT_VINTR)) {
> -		/*
> -		 * In order to request an interrupt window, L0 is usurping
> -		 * svm->vmcb->control.int_ctl and possibly setting V_IRQ
> -		 * even if it was clear in L1's VMCB.  Restoring it would be
> -		 * wrong.  However, in this case V_IRQ will remain true until
> -		 * interrupt_window_interception calls svm_clear_vintr and
> -		 * restores int_ctl.  We can just leave it aside.
> -		 */
> -		mask &= ~V_IRQ_MASK;
> -	}
> +	/*
> +	 * Only a few fields of int_ctl are written by the processor.
> +	 * Copy back only the bits that are passed through to the L2.

Just "L2", not "the L2".

> +	 */
> +

Unnecessary newline.

> +	if (svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
> +		mask = V_IRQ_MASK | V_TPR_MASK;
>  
>  	if (nested_vgif_enabled(svm))
>  		mask |= V_GIF_MASK;
> -- 
> 2.26.3
> 
