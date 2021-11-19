Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563694572BC
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 17:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbhKSQW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 11:22:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28950 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234650AbhKSQW6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 11:22:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637338795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KV/tkCgmsS7i2APUX/7qyOc6gDmwY8m+7cktraXzQn0=;
        b=NB36R+taVKTCjwEYwjuaZm5fLpMkkdHoXp3f1T7oFZxhMbalourQCTNwCc9y/odUw6j0YR
        z6dO8ffpXE/QXMGA8Ye3CBC1tCXpC9hZqIqyMjoBrPYNbqvgcY6/vNzCIxXNIoJrcugOKB
        VNiem1ZjddCvSjcMD5cstYYfl6+zh/U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-560-RM7S80wHNsixISl-kVaQMQ-1; Fri, 19 Nov 2021 11:19:54 -0500
X-MC-Unique: RM7S80wHNsixISl-kVaQMQ-1
Received: by mail-wm1-f72.google.com with SMTP id n41-20020a05600c502900b003335ab97f41so4990481wmr.3
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 08:19:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=KV/tkCgmsS7i2APUX/7qyOc6gDmwY8m+7cktraXzQn0=;
        b=IbfYpFBxpxGB4vBXH3X01uHKmMF0k+4l8Or2PMYcyY7NoER/nH0vjS2gAbY6Vjx8MB
         mC9JvNdN0fH7SFpkYjUKlYPb/HFErn7aFjhLOQIUH+NXi1BgJrCQFWnGVKwsabVjRqag
         rCycmoK6VErCVnZzwfZheqXDP0+XIIDPNiOmscDOXRHox0sI0oAF09zclnGhmvUnLnJC
         vCjgAq9Pq0DRVivO9/Ss/W88K+cUqsmWhYDhy9dG/ZB8mMfPo2Ysl5aSREfOsCJG4nlO
         kv//iAVjdLNIGRz31CErpxoPOhe3M40yt4QLRg3BKT/rUamAxJ2+b6uf8er456eJTZeL
         O+QA==
X-Gm-Message-State: AOAM533TvKaCvg1CO8nXpJDl3bHYZaiVptbZYjpG+FpDtYnum/pz5Iyc
        RWsQ+5BVIGF/qtUiLdZi680KXVzZajbpVnvssSMDcX2+vPv/nO8TxXO6R+zxwZryn2z/sJBKYVF
        RBE9Z2Cb3AlDO
X-Received: by 2002:a05:600c:2117:: with SMTP id u23mr1016432wml.19.1637338793351;
        Fri, 19 Nov 2021 08:19:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyypSNe83wKPHORFILceewC9LXVrcDFK0lsfkP7ru/nhY1odUOFzw45jOp2yZPs390wmI5MTQ==
X-Received: by 2002:a05:600c:2117:: with SMTP id u23mr1016388wml.19.1637338793086;
        Fri, 19 Nov 2021 08:19:53 -0800 (PST)
Received: from fedora (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f81sm13871621wmf.22.2021.11.19.08.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 08:19:52 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Li RongQing <lirongqing@baidu.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, lirongqing@baidu.com,
        stable@kernel.org
Subject: Re: [v4][PATCH 2/2] KVM: Clear pv eoi pending bit only when it is set
In-Reply-To: <1636026974-50555-2-git-send-email-lirongqing@baidu.com>
References: <1636026974-50555-1-git-send-email-lirongqing@baidu.com>
 <1636026974-50555-2-git-send-email-lirongqing@baidu.com>
Date:   Fri, 19 Nov 2021 17:19:50 +0100
Message-ID: <8735nsnmmx.fsf@redhat.com>
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
> diff v3: remove printk in a new patch
> diff v4: fix comments place
>  arch/x86/kvm/lapic.c |   40 +++++++++++++++++++---------------------
>  1 files changed, 19 insertions(+), 21 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 752c48e..b1de23e 100644
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
> @@ -690,12 +681,26 @@ static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
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
> +
> +	if (val && pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0)
> +		return false;
>  
> +	/*
> +	 * Clear pending bit in any case: it will be set again on vmentry.
> +	 * While this might not be ideal from performance point of view,
> +	 * this makes sure pv eoi is only enabled when we know it's safe.
> +	 */
>  	__clear_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
> +
> +	return val;
>  }
>  
>  static int apic_has_interrupt_for_ppr(struct kvm_lapic *apic, u32 ppr)
> @@ -2671,7 +2676,6 @@ void __kvm_migrate_apic_timer(struct kvm_vcpu *vcpu)
>  static void apic_sync_pv_eoi_from_guest(struct kvm_vcpu *vcpu,
>  					struct kvm_lapic *apic)
>  {
> -	bool pending;
>  	int vector;
>  	/*
>  	 * PV EOI state is derived from KVM_APIC_PV_EOI_PENDING in host
> @@ -2685,14 +2689,8 @@ static void apic_sync_pv_eoi_from_guest(struct kvm_vcpu *vcpu,
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

I see my R-b tag is missign, so

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

