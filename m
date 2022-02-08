Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB85D4AD7BE
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 12:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355886AbiBHLqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 06:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376339AbiBHLq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 06:46:29 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7119DF8E3FD;
        Tue,  8 Feb 2022 03:33:43 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id eg42so21031686edb.7;
        Tue, 08 Feb 2022 03:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JfVdcw47d18nQG2rowWs40TfFKXN2zrXWEZ3tMD7/FA=;
        b=jsMC8ZEI1cmNHLjEG9oQOhIA/hm25fdLrIfMO49qjprOh3w27zcmDJOYTpG9BoKW4D
         We/EkQFRfwqVDO8uCTPW58cDVQRwb/CDMyvnVNiRI59VZx2ZFFuX/LzDPDkWJgRKI+oK
         8b/G0v6OFT9Cx11Xq8rUQieH8nEoD7lG3ycrkMSGzKJLpTzBh8iiXqmTYtpeQwg4gdK4
         QP2fK5GToK1G8nYKkQlbg0ZrxMB1FXWP75Gtg4B8T+zCIFiN7+o1HZH584LYFPUSFynZ
         1XATRw9hfO7pax0hEhIMdtgBSNmoaKJypVQoJFvE8p7DHFMVIZ7PBkKwEDGV6ntMZgoz
         AKDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JfVdcw47d18nQG2rowWs40TfFKXN2zrXWEZ3tMD7/FA=;
        b=q5QCyrGe18DyhRftbihiweZrFs9nnHXNnVXwaaJybQRQ078yYindA3KzSCjvLE3jBG
         43ZV5hHMwwxuZGs/U0blrq/U0InjwutYqS24WRMtze2RjtGDsppz3FMibEiAqORxwIAI
         VwYLNoLTqi8AfvuExXtUuRrpm7nozfIJl0JsWayvzPFz7r+75mUbMiwVysWMfKtj2yL5
         27BAkQCpDkjAxiqnJXPhcl8sEBv1QMnRYGttG4Paklzeq/uNX2EqTogO4mXE/PFojPM0
         LQMwpUMjhWlBUoaa7+yE4ClEiBd5nTmR8TVt1p2XiqXujoR/wOOS5GpvTxXCczdurT+y
         HwvQ==
X-Gm-Message-State: AOAM531DL6rQUJaNYoBVTcXW65MCHHbEpPLkn/MvAw46O3GX3EnHBL1g
        FNNh9p9KU6R0caqKABi8SG8=
X-Google-Smtp-Source: ABdhPJyYIr/gkhgvzV2Lhq6wiCw/Y3s61L6r61qau3wQGpfMzCAXSgnohQuv5o/Q1RwNzvl/w8SxMw==
X-Received: by 2002:a05:6402:164a:: with SMTP id s10mr3996093edx.51.1644320013608;
        Tue, 08 Feb 2022 03:33:33 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id p6sm742414ejf.11.2022.02.08.03.33.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 03:33:33 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <dd9305d6-1e3a-24f9-1d48-c5dac440112d@redhat.com>
Date:   Tue, 8 Feb 2022 12:33:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH RESEND 07/30] KVM: x86: nSVM: deal with L1 hypervisor that
 intercepts interrupts but lets L2 control them
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        David Airlie <airlied@linux.ie>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>
References: <20220207155447.840194-1-mlevitsk@redhat.com>
 <20220207155447.840194-8-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220207155447.840194-8-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/7/22 16:54, Maxim Levitsky wrote:
> Fix a corner case in which the L1 hypervisor intercepts
> interrupts (INTERCEPT_INTR) and either doesn't set
> virtual interrupt masking (V_INTR_MASKING) or enters a
> nested guest with EFLAGS.IF disabled prior to the entry.
> 
> In this case, despite the fact that L1 intercepts the interrupts,
> KVM still needs to set up an interrupt window to wait before
> injecting the INTR vmexit.
> 
> Currently the KVM instead enters an endless loop of 'req_immediate_exit'.
> 
> Exactly the same issue also happens for SMIs and NMI.
> Fix this as well.
> 
> Note that on VMX, this case is impossible as there is only
> 'vmexit on external interrupts' execution control which either set,
> in which case both host and guest's EFLAGS.IF
> are ignored, or not set, in which case no VMexits are delivered.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>   arch/x86/kvm/svm/svm.c | 17 +++++++++++++----
>   1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9a4e299ed5673..22e614008cf59 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3372,11 +3372,13 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>   	if (svm->nested.nested_run_pending)
>   		return -EBUSY;
>   
> +	if (svm_nmi_blocked(vcpu))
> +		return 0;
> +
>   	/* An NMI must not be injected into L2 if it's supposed to VM-Exit.  */
>   	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
>   		return -EBUSY;
> -
> -	return !svm_nmi_blocked(vcpu);
> +	return 1;
>   }
>   
>   static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
> @@ -3428,9 +3430,13 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
>   static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>   {
>   	struct vcpu_svm *svm = to_svm(vcpu);
> +
>   	if (svm->nested.nested_run_pending)
>   		return -EBUSY;
>   
> +	if (svm_interrupt_blocked(vcpu))
> +		return 0;
> +
>   	/*
>   	 * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
>   	 * e.g. if the IRQ arrived asynchronously after checking nested events.
> @@ -3438,7 +3444,7 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>   	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_intr(svm))
>   		return -EBUSY;
>   
> -	return !svm_interrupt_blocked(vcpu);
> +	return 1;
>   }
>   
>   static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
> @@ -4169,11 +4175,14 @@ static int svm_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>   	if (svm->nested.nested_run_pending)
>   		return -EBUSY;
>   
> +	if (svm_smi_blocked(vcpu))
> +		return 0;
> +
>   	/* An SMI must not be injected into L2 if it's supposed to VM-Exit.  */
>   	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_smi(svm))
>   		return -EBUSY;
>   
> -	return !svm_smi_blocked(vcpu);
> +	return 1;
>   }
>   
>   static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)

Can you prepare a testcase for at least the interrupt case?

Thanks,

Paolo
