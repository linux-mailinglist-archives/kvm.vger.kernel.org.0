Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 638CB9DEA1
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 09:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbfH0HWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 03:22:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54778 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbfH0HWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 03:22:54 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2D872C054907
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 07:22:53 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id j10so10981063wrb.16
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 00:22:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=pzHviUK3atqXhQXnPVoHHHqmzFOi+zrzBFXLMguzsmQ=;
        b=sqtp2WgBIwLow2rWg3icX8ATiZAUCfU98ONTPbqpNJzLAyK77/1xd8k2CJ4yxroPw6
         25B4ERGG+uSMvje7EUA7qBLnJmJeNhCDb9QdQ3Y7+6sWOhbd9WrKKEP/lkr8asBKaDxE
         DVt2Ch09CwCGkc3bCGB0+kh/WIARydfP/KG4POnEeWVCwc68/J8w+NtVnlZP4DUnt1jA
         ngFIvgE8n+pta3cP/uJbeB7PEyg5sTqy0fxTFdLVuUBFoLIPxX9uSk1bblnZjeI8L8T4
         NyoYMwu+hCg9ATUYlRfrzRsHoAyO/g8/EN0ejL8kQtX2gMugZBftBLbRk4wCw53byuaY
         U5wg==
X-Gm-Message-State: APjAAAUyO7jvR9iFvQoPivU84AEKIsAVY7Sm+m19cL0+on1SxKJe02aU
        bj4C4qgfBMDFXzoaDOs2tgZQTrd+xVjMLlFtIvZjhgxDsb8rfl+KSMSI14f48NUIJs2xM/fcSZL
        G2aX48BElKiZK
X-Received: by 2002:a5d:4b05:: with SMTP id v5mr27160266wrq.208.1566890571694;
        Tue, 27 Aug 2019 00:22:51 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz815ouJgJL1bqVreLWWsWgyzkebpEQJyMyRKKuLdX2UXpOSf2gDYTBZHr3gTlZ0ShYqwGXGQ==
X-Received: by 2002:a5d:4b05:: with SMTP id v5mr27160234wrq.208.1566890571484;
        Tue, 27 Aug 2019 00:22:51 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-89-176-161-20.net.upcbroadband.cz. [89.176.161.20])
        by smtp.gmail.com with ESMTPSA id f7sm18038767wrf.8.2019.08.27.00.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 00:22:51 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Suthikulpanit\, Suravee" <Suravee.Suthikulpanit@amd.com>
Cc:     "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar\@redhat.com" <rkrcmar@redhat.com>,
        "joro\@8bytes.org" <joro@8bytes.org>,
        "graf\@amazon.com" <graf@amazon.com>,
        "jschoenh\@amazon.de" <jschoenh@amazon.de>,
        "karahmed\@amazon.de" <karahmed@amazon.de>,
        "rimasluk\@amazon.com" <rimasluk@amazon.com>,
        "Grimm\, Jon" <Jon.Grimm@amd.com>,
        "Suthikulpanit\, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 05/15] kvm: lapic: Introduce APICv update helper function
In-Reply-To: <1565886293-115836-6-git-send-email-suravee.suthikulpanit@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com> <1565886293-115836-6-git-send-email-suravee.suthikulpanit@amd.com>
Date:   Tue, 27 Aug 2019 09:22:50 +0200
Message-ID: <87a7bvm5rp.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com> writes:

> Re-factor code into a helper function for setting lapic parameters when
> activate/deactivate APICv, and export the function for subsequent usage.
>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/lapic.c | 22 +++++++++++++++++-----
>  arch/x86/kvm/lapic.h |  1 +
>  2 files changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 4dabc31..90f79ca 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2153,6 +2153,21 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>  
>  }
>  
> +void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_lapic *apic = vcpu->arch.apic;
> +
> +	if (vcpu->arch.apicv_active) {
> +		/* irr_pending is always true when apicv is activated. */
> +		apic->irr_pending = true;
> +		apic->isr_count = 1;
> +	} else {
> +		apic->irr_pending = (apic_search_irr(apic) != -1);
> +		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
> +	}
> +}
> +EXPORT_SYMBOL(kvm_apic_update_apicv);

EXPORT_SYMBOL_GPL please.

> +
>  void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> @@ -2197,8 +2212,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  		kvm_lapic_set_reg(apic, APIC_ISR + 0x10 * i, 0);
>  		kvm_lapic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
>  	}
> -	apic->irr_pending = vcpu->arch.apicv_active;
> -	apic->isr_count = vcpu->arch.apicv_active ? 1 : 0;
> +	kvm_apic_update_apicv(vcpu);
>  	apic->highest_isr_cache = -1;
>  	update_divide_count(apic);
>  	atomic_set(&apic->lapic_timer.pending, 0);
> @@ -2468,9 +2482,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>  	apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
>  	update_divide_count(apic);
>  	start_apic_timer(apic);
> -	apic->irr_pending = true;
> -	apic->isr_count = vcpu->arch.apicv_active ?
> -				1 : count_vectors(apic->regs + APIC_ISR);
> +	kvm_apic_update_apicv(vcpu);
>  	apic->highest_isr_cache = -1;
>  	if (vcpu->arch.apicv_active) {
>  		kvm_x86_ops->apicv_post_state_restore(vcpu);
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index d6d049b..3892d50 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -90,6 +90,7 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
>  int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq,
>  		     struct dest_map *dest_map);
>  int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type);
> +void kvm_apic_update_apicv(struct kvm_vcpu *vcpu);
>  
>  bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
>  		struct kvm_lapic_irq *irq, int *r, struct dest_map *dest_map);

-- 
Vitaly
