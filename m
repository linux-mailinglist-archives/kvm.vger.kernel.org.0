Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1074C912E
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 18:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbiCARLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 12:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236402AbiCARLO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 12:11:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AD2950E19
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 09:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646154629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pnsAjWbVbEgg0kwSB8d4gVVRxWcCPyACdR5EmJNscc4=;
        b=eDeeKv4yB93GFQQn4FCp8UdX53ZKxmfYbt9VxRhJpIYSMQuBHalpp2aS8r6Ml1T8rQ7x3j
        yyB63hNmEquWu7ro8OPCwcYq12H2LBP1tPkdAxJWgDNKvLeAuAn+Hc7FGZDBi0d41smopH
        rndIaWWHVsOZsXdoB6evgcdqcG9zUp4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-C0RVVMNpNjGiMF_z82RXxA-1; Tue, 01 Mar 2022 12:10:27 -0500
X-MC-Unique: C0RVVMNpNjGiMF_z82RXxA-1
Received: by mail-wr1-f70.google.com with SMTP id ay18-20020a5d6f12000000b001efe36eb038so2110726wrb.17
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 09:10:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pnsAjWbVbEgg0kwSB8d4gVVRxWcCPyACdR5EmJNscc4=;
        b=NKzi2fl+/XVChvRBK/ccEvYdXP+Yi/p3rIb31NcyEB2cbggNmlQQ35gblYkiht5swA
         gJGeF875F4THPrJqu9sDH9lgjzG59vQmf7OuCTIHW/l83KevMAlniNxGPAHhd0QvhQWi
         tWTxIoFcrbpuyPaIJY610OkHEcekhBd7LZHi++eYkV/CrIxouEXy3NqjmdDYJXVLhY7A
         ivjFbkj3fnSatyEa0Xa4AUOCxZaCo+wF1UWanvmVIKF905eVIXTZGqafTc/7DC3Ajhgu
         DscKzhGbtB8G5W/Vmnj2kcgDDBI6rvkgEMWUVZngJDqcchnouc1Nok8M/pQA3qtsZ5tN
         jllg==
X-Gm-Message-State: AOAM533NWUDDekwzt4hnMqiD5ZThCYqbWgip9Ki8YWig+7c/8UF3RuNk
        OQD6O2BX4qDPxlNPC2TZRs2LpPE6E6kV4hyGWEOMOkd3gw9xbbNkT1DBTpbGX1tPy3zwGdORdmC
        SfXrqT9+ITxJd
X-Received: by 2002:a05:6000:c8:b0:1ef:7e4a:e3a1 with SMTP id q8-20020a05600000c800b001ef7e4ae3a1mr13731894wrx.452.1646154626584;
        Tue, 01 Mar 2022 09:10:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx+Oe+GqOOQ7Ofj6oSzBC8NVk/cBtyJqS65Z6mKuKsznfgmMMvunKgAgBkurfpHAKJIbY0ILg==
X-Received: by 2002:a05:6000:c8:b0:1ef:7e4a:e3a1 with SMTP id q8-20020a05600000c800b001ef7e4ae3a1mr13731866wrx.452.1646154626293;
        Tue, 01 Mar 2022 09:10:26 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id v11-20020adfe4cb000000b001e62a8914c7sm14143015wrm.59.2022.03.01.09.10.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 09:10:25 -0800 (PST)
Message-ID: <b3c7dccc-588c-7f4a-c003-769aecd3fdda@redhat.com>
Date:   Tue, 1 Mar 2022 18:10:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.15 2/2] KVM: x86: nSVM: deal with L1
 hypervisor that intercepts interrupts but lets L2 control them
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220222140527.211584-1-sashal@kernel.org>
 <20220222140527.211584-2-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220222140527.211584-2-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/22 15:05, Sasha Levin wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> [ Upstream commit 2b0ecccb55310a4b8ad5d59c703cf8c821be6260 ]
> 
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
> Message-Id: <20220207155447.840194-8-mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/svm/svm.c | 17 +++++++++++++----
>   1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f05aa7290267d..aeee6df523af9 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3465,11 +3465,13 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
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
> @@ -3521,9 +3523,13 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
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
> @@ -3531,7 +3537,7 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>   	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_intr(svm))
>   		return -EBUSY;
>   
> -	return !svm_interrupt_blocked(vcpu);
> +	return 1;
>   }
>   
>   static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
> @@ -4286,11 +4292,14 @@ static int svm_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
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


Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

