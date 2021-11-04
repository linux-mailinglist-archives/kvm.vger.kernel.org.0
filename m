Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1A344523F
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 12:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhKDLfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 07:35:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41551 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229705AbhKDLfX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Nov 2021 07:35:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636025565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9hfDzJRzFXBzyVbPrAxTW9kn1j9dpX7mBcx6PiiipR8=;
        b=R/mPz1miR4vm/Al6qoj8d9jbkhQKb3ggiaAYJuV08c6OPavX/E8sT0CiY4g0BqX0PoLnX4
        R/QY6f8h6fASy9jrFO6xKQUtZmA+2/4vSFofDgDsM4V3/cGvJVInxT3jGll0KjOekmrH3m
        gfT5lL1b0TQRXramCGjjYnqlRq+Csvw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-kunNeY80O_WVmfre_bTp8w-1; Thu, 04 Nov 2021 07:32:43 -0400
X-MC-Unique: kunNeY80O_WVmfre_bTp8w-1
Received: by mail-wr1-f72.google.com with SMTP id d13-20020adf9b8d000000b00160a94c235aso925183wrc.2
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 04:32:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9hfDzJRzFXBzyVbPrAxTW9kn1j9dpX7mBcx6PiiipR8=;
        b=Med6ynYd0n+K/8/fYvPcoD0VfaxHoS+J8lf4RsB8l1KkxvJmOSPbXyd/u8cijrUG6Y
         9q/gu+qFpYJgVI1w2cGt3yHku29gavo58zzkUoFU2Rad+hIcc7wAdHU/L5zjXJlBvQ6K
         HfqcQtUs0938IUVeNnvHMz7xmatxjtq6oHxKDo2rDZ8zfnd2gHjvkbJKWpbq4Mpa/V5P
         lz1HbJEokxJgyF4FUp5SeIu5Oi+1om7w93Xp+EQkBqhwRQcj5rkMhOZAZepNZC+Xa0Ns
         TXzA9j+7JDCg1T/C9eWD9jLA/4zfxM74QkIEIYIH/bLPFwh5T8bxQ7YxmEo6o74NyKTq
         8r6g==
X-Gm-Message-State: AOAM531QW1IoJA1gHGUDEdG5hQqGCwfgYv79Fcp96ssjj+smHkNImxTU
        OzT0PJDllEMD5fGYOOUBhsjBzTIN+yueIisrY/uxzJvknD+Wistn5uyexz+7Rx9GdvyyXJMYkqU
        eW8nsm+sLnuex
X-Received: by 2002:adf:9147:: with SMTP id j65mr63657785wrj.163.1636025562626;
        Thu, 04 Nov 2021 04:32:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGEzgUHrLGorqMUUmENA20P95eLb+2+s9kV+rdirboiaivoyuJ/rFbRwsT58IQ5h9roEJjlw==
X-Received: by 2002:adf:9147:: with SMTP id j65mr63657761wrj.163.1636025562406;
        Thu, 04 Nov 2021 04:32:42 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f15sm4691079wrt.26.2021.11.04.04.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 04:32:41 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Li RongQing <lirongqing@baidu.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     seanjc@google.com, lirongqing@baidu.com
Subject: Re: [v3][PATCH 2/2] KVM: Clear pv eoi pending bit only when it is set
In-Reply-To: <1636024059-53855-2-git-send-email-lirongqing@baidu.com>
References: <1636024059-53855-1-git-send-email-lirongqing@baidu.com>
 <1636024059-53855-2-git-send-email-lirongqing@baidu.com>
Date:   Thu, 04 Nov 2021 12:32:41 +0100
Message-ID: <87a6ikma06.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Li RongQing <lirongqing@baidu.com> writes:

> merge pv_eoi_get_pending and pv_eoi_clr_pending into a single
> function pv_eoi_test_and_clear_pending, which returns and clear
> the value of the pending bit.
>
> and clear pv eoi pending bit only when it is set, to avoid calling
> pv_eoi_put_user(), this can speed about 300 nsec on AMD EPYC most
> of the time
>
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> diff v2: merge as pv_eoi_test_and_clear_pending
> diff v3: remove printk with a new patch
>  arch/x86/kvm/lapic.c |   39 ++++++++++++++++++---------------------
>  1 files changed, 18 insertions(+), 21 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 752c48e..9c3b1b3 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -673,15 +673,6 @@ static inline bool pv_eoi_enabled(struct kvm_vcpu *vcpu)
>  	return vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED;
>  }
>  
> -static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
> -{
> -	u8 val;
> -	if (pv_eoi_get_user(vcpu, &val) < 0)
> -		return false;
> -
> -	return val & KVM_PV_EOI_ENABLED;
> -}
> -
>  static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
>  {
>  	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_ENABLED) < 0)
> @@ -690,12 +681,25 @@ static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
>  	__set_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
>  }
>  
> -static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
> +static bool pv_eoi_test_and_clr_pending(struct kvm_vcpu *vcpu)
>  {
> -	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0)
> -		return;
> +	u8 val;
> +
> +	if (pv_eoi_get_user(vcpu, &val) < 0)
> +		return false;
> +
> +	val &= KVM_PV_EOI_ENABLED;
>  
> +	/*
> +	 * Clear pending bit in any case: it will be set again on vmentry.
> +	 * While this might not be ideal from performance point of view,
> +	 * this makes sure pv eoi is only enabled when we know it's safe.
> +	 */

This comment is misplaced now, as one may read it as we're clearing the
bit in guest's memory while in fact it refers to a bit in
'vcpu->arch.apic_attention'. Moreover, we're now checking 'val' so 'in
any case' above is certainly misleading.

We can add a 

	"Disable PV EOI in guest's memory in case it was previously
	enabled" (or something like that)

comment here (but I don't think it gives much value to be honest).

> +	if (val && pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0)
> +		return false;

Let's move the original comment here.

>  	__clear_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
> +
> +	return !!val;

('!!' is not really needed, the function returns bool)

>  }
>  
>  static int apic_has_interrupt_for_ppr(struct kvm_lapic *apic, u32 ppr)
> @@ -2671,7 +2675,6 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
>  static void apic_sync_pv_eoi_from_guest(struct kvm_vcpu *vcpu,
>  					struct kvm_lapic *apic)
>  {
> -	bool pending;
>  	int vector;
>  	/*
>  	 * PV EOI state is derived from KVM_APIC_PV_EOI_PENDING in host
> @@ -2685,14 +2688,8 @@ static void apic_sync_pv_eoi_from_guest(struct kvm_vcpu *vcpu,
>  	 * 	-> host enabled PV EOI, guest executed EOI.
>  	 */
>  	BUG_ON(!pv_eoi_enabled(vcpu));
> -	pending = pv_eoi_get_pending(vcpu);
> -	/*
> -	 * Clear pending bit in any case: it will be set again on vmentry.
> -	 * While this might not be ideal from performance point of view,
> -	 * this makes sure pv eoi is only enabled when we know it's safe.
> -	 */
> -	pv_eoi_clr_pending(vcpu);
> -	if (pending)
> +
> +	if (pv_eoi_test_and_clr_pending(vcpu))
>  		return;
>  	vector = apic_set_eoi(apic);
>  	trace_kvm_pv_eoi(apic, vector);

-- 
Vitaly

