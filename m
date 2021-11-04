Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E6944521D
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 12:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhKDLZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 07:25:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59483 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229809AbhKDLZj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Nov 2021 07:25:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636024981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K8sI30c73cValizSw9Dlvwm0Wsq5gOVefBQ4Yhmnwlk=;
        b=TjCtq5rQyUrcA5+R8AaUlyh/E0kJISYpEVeRb3Pjge0ggyZwHFSBA+FRXFBuKPPpUu5oJc
        SPS8RRovcNk6syf5NCdFLpvvwdNPnjy0QJI+msoDOsH3CXg85jZ7xnZimOVFDEFivBffCV
        Tglg2T/Qb+Th8Vc4v+XeSFurLVI2CLA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-KoPnXamZP4mIGf5KqRFD1A-1; Thu, 04 Nov 2021 07:23:00 -0400
X-MC-Unique: KoPnXamZP4mIGf5KqRFD1A-1
Received: by mail-wm1-f69.google.com with SMTP id m1-20020a1ca301000000b003231d5b3c4cso4274666wme.5
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 04:23:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=K8sI30c73cValizSw9Dlvwm0Wsq5gOVefBQ4Yhmnwlk=;
        b=nITgAuAh+dcSpyRfc/2m8FH1JC4Qpr6DTChK1OQcg37KpvPR6oDC+h386b/zSD6J/d
         gQ3nmEZf27W+u6v7bagJLN+GegK4Xs5UN02lYuGkaR9Ii+8cmH8j1TkjJSNAKzUSpsox
         bHdNxyQRwsr39k034ViZ0CdUVhd6F+/2Ldc34sw5HkHBCD7bYv6kMb974YHtIhu8ignH
         ygOOtcA/sOPPviKTcd7IrNvJ7vMx2YLTFT9bW0cu6yjYQg+8o7VqwYoVQqqiVZYb3Z7x
         UKBkNKVZpXsaYAmLNv+tZnjRrYSormNFt75MMRfWo3klUMUEFZLjSMBVYAA4jEFZVSA8
         EpzA==
X-Gm-Message-State: AOAM531cXutfu7ikCgAWhEL6WtqTfhc/0UtU7o4MvjjyZNWnj/dcBPYM
        rXq92f6+Z6+gXlj5do/qiVP6n5rVOycA8Ac+7MZb37IYD3PAMmpB/9SmLrmycAX7NYPZCj0qlpJ
        p3V3QvTjhS/9b
X-Received: by 2002:a5d:5888:: with SMTP id n8mr20132987wrf.234.1636024979561;
        Thu, 04 Nov 2021 04:22:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx09lb7TJrY38K3gJiy1HbvcfP3AZzCSYOR8IVAJyQMYoKfmdQagXFfjA10YXgKRmTW9Gv4YQ==
X-Received: by 2002:a5d:5888:: with SMTP id n8mr20132972wrf.234.1636024979384;
        Thu, 04 Nov 2021 04:22:59 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l5sm8117640wms.16.2021.11.04.04.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 04:22:58 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Li RongQing <lirongqing@baidu.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     seanjc@google.com, lirongqing@baidu.com
Subject: Re: [v3][PATCH 1/2] KVM: x86: don't print when fail to read/write
 pv eoi memory
In-Reply-To: <1636024059-53855-1-git-send-email-lirongqing@baidu.com>
References: <1636024059-53855-1-git-send-email-lirongqing@baidu.com>
Date:   Thu, 04 Nov 2021 12:22:58 +0100
Message-ID: <87czngmagd.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Li RongQing <lirongqing@baidu.com> writes:

> If guest gives MSR_KVM_PV_EOI_EN a wrong value, this printk() will
> be trigged, and kernel log is spammed with the useless message
>
> Fixes: 0d88800d5472 ("kvm: x86: ioapic and apic debug macros cleanup")
> Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Paolo,

I'd Cc: stable@ here as these messages are not even ratelimited.

> ---
>  arch/x86/kvm/lapic.c |   18 ++++++------------
>  1 files changed, 6 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index d6ac32f..752c48e 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -676,31 +676,25 @@ static inline bool pv_eoi_enabled(struct kvm_vcpu *vcpu)
>  static bool pv_eoi_get_pending(struct kvm_vcpu *vcpu)
>  {
>  	u8 val;
> -	if (pv_eoi_get_user(vcpu, &val) < 0) {
> -		printk(KERN_WARNING "Can't read EOI MSR value: 0x%llx\n",
> -			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
> +	if (pv_eoi_get_user(vcpu, &val) < 0)
>  		return false;
> -	}
> +
>  	return val & KVM_PV_EOI_ENABLED;
>  }
>  
>  static void pv_eoi_set_pending(struct kvm_vcpu *vcpu)
>  {
> -	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_ENABLED) < 0) {
> -		printk(KERN_WARNING "Can't set EOI MSR value: 0x%llx\n",
> -			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
> +	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_ENABLED) < 0)
>  		return;
> -	}
> +
>  	__set_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
>  }
>  
>  static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
>  {
> -	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0) {
> -		printk(KERN_WARNING "Can't clear EOI MSR value: 0x%llx\n",
> -			   (unsigned long long)vcpu->arch.pv_eoi.msr_val);
> +	if (pv_eoi_put_user(vcpu, KVM_PV_EOI_DISABLED) < 0)
>  		return;
> -	}
> +
>  	__clear_bit(KVM_APIC_PV_EOI_PENDING, &vcpu->arch.apic_attention);
>  }

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

