Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED596616D1
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 17:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbjAHQom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 11:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233282AbjAHQol (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 11:44:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECA32AF6
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 08:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673196238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3N60ZM47durAt2eYzES+eC+6e822LLlnoCx24xYvH/s=;
        b=WQDzvMUZMLZ6006FbXeME9K6lsfbPuFzofAkQI5XuIqpPZANVgoT1W+o6sAm5rYOxDj7mQ
        n/ksCQwpnEg5qw8a52DdzIrATCZpGV48ZqerC+EVGvLKDo/vd6+1UrTzzfy48xSNp8M7HK
        AhzsSFs4bLmWOogOYtslNvb5ySi9XT4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-228-u-7ibi22NXeQhfJ-iiVPgw-1; Sun, 08 Jan 2023 11:43:56 -0500
X-MC-Unique: u-7ibi22NXeQhfJ-iiVPgw-1
Received: by mail-ej1-f70.google.com with SMTP id hp2-20020a1709073e0200b0084d47e3fe82so127993ejc.8
        for <kvm@vger.kernel.org>; Sun, 08 Jan 2023 08:43:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3N60ZM47durAt2eYzES+eC+6e822LLlnoCx24xYvH/s=;
        b=QFp2pgcFl55QDZpWjKV0hOsAdLbNqFYqOLI+vmNaar3G6AR0TYvqLkfnT5wpW9q0Q8
         y98IDpLjnzLEV+B+e2uoGtAl82HqAaVQprBu3lxkQOZCAPKmPdFCCUrPUSvV1fb7yX6U
         0rJRUno0Cdgvvs9fWUgVpN4oOTQETOvyvXEMAzI7ukbTf70SQ1RqLvwKmL8p6edUyjWz
         emRZ/iWU2BrHKbRPLhUOuqihDhzBO/7ikbD9Hhakj4oaBMNqLTsb0CxmNue6pciDhR6L
         rUrZEC59XoKXbV602+V2ceFaRZ6bgZG5C3Xqbyq2UP0+efZaQcY5ktz5C91RZ41c1Kru
         BdgQ==
X-Gm-Message-State: AFqh2kqcNbj7o/WjYXryjrmVGWCU9k1CT7pVQuXxSutdO6dr7paIdKo7
        8ESFj0D04VI2ohG7bcloFtKNAB9djonhsqdPHxYrN2NxVq/c2KHFk6I3TS3CxHsRLHI3RVm4FH6
        v668N2hG+iquY
X-Received: by 2002:a17:906:3a85:b0:7c4:f0b5:fedc with SMTP id y5-20020a1709063a8500b007c4f0b5fedcmr52650426ejd.65.1673196235832;
        Sun, 08 Jan 2023 08:43:55 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsyCEFH40Wu7vN3fEiG8h91Ev3TxQ4PGRLsJ7MMAsL9JzoRs+qc4MgF8mePuVUJhiyTZEbyiw==
X-Received: by 2002:a17:906:3a85:b0:7c4:f0b5:fedc with SMTP id y5-20020a1709063a8500b007c4f0b5fedcmr52650420ejd.65.1673196235689;
        Sun, 08 Jan 2023 08:43:55 -0800 (PST)
Received: from starship ([89.237.103.62])
        by smtp.gmail.com with ESMTPSA id l6-20020a170906078600b0084d381d0528sm1443478ejc.180.2023.01.08.08.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 08:43:55 -0800 (PST)
Message-ID: <5e3d6e7c1039d79a867eadd6c849717f71e34024.camel@redhat.com>
Subject: Re: [PATCH 3/6] KVM: x86: Mark x2APIC DFR reg as non-existent for
 x2APIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Orr <marcorr@google.com>, Ben Gardon <bgardon@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>
Date:   Sun, 08 Jan 2023 18:43:53 +0200
In-Reply-To: <20230107011025.565472-4-seanjc@google.com>
References: <20230107011025.565472-1-seanjc@google.com>
         <20230107011025.565472-4-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2023-01-07 at 01:10 +0000, Sean Christopherson wrote:
> Mark APIC_DFR as being invalid/non-existent in x2APIC mode instead of
> handling it as a one-off check in kvm_x2apic_msr_read().  This will allow
> reusing "valid_reg_mask" to generate VMX's interception bitmaps for
> x2APIC.  Handling DFR in the common read path may also fix the Hyper-V
> PV MSR interface, if that can coexist with x2APIC.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index bf53e4752f30..c49b13418638 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1541,7 +1541,6 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
>  		APIC_REG_MASK(APIC_TASKPRI) |
>  		APIC_REG_MASK(APIC_PROCPRI) |
>  		APIC_REG_MASK(APIC_LDR) |
> -		APIC_REG_MASK(APIC_DFR) |
>  		APIC_REG_MASK(APIC_SPIV) |
>  		APIC_REGS_MASK(APIC_ISR, APIC_ISR_NR) |
>  		APIC_REGS_MASK(APIC_TMR, APIC_ISR_NR) |
> @@ -1562,12 +1561,13 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
>  		valid_reg_mask |= APIC_REG_MASK(APIC_LVTCMCI);
>  
>  	/*
> -	 * ARBPRI and ICR2 are not valid in x2APIC mode.  WARN if KVM reads ICR
> -	 * in x2APIC mode as it's an 8-byte register in x2APIC and needs to be
> -	 * manually handled by the caller.
> +	 * ARBPRI, DFR, and ICR2 are not valid in x2APIC mode.  WARN if KVM
> +	 * reads ICR in x2APIC mode as it's an 8-byte register in x2APIC and
> +	 * needs to be manually handled by the caller.
>  	 */
>  	if (!apic_x2apic_mode(apic))
>  		valid_reg_mask |= APIC_REG_MASK(APIC_ARBPRI) |
> +				  APIC_REG_MASK(APIC_DFR) |
>  				  APIC_REG_MASK(APIC_ICR2);
>  	else
>  		WARN_ON_ONCE(offset == APIC_ICR);
> @@ -3141,9 +3141,6 @@ int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
>  	if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(apic))
>  		return 1;
>  
> -	if (reg == APIC_DFR)
> -		return 1;
> -
>  	return kvm_lapic_msr_read(apic, reg, data);
>  }
>  


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Best regards,
	Maxim Levitsky

