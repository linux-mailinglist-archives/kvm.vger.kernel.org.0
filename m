Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1429541CA1C
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 18:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345691AbhI2Qbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 12:31:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41516 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345687AbhI2Qbr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Sep 2021 12:31:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632933006;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t7eXK8bCTNOOv/qDjkAKe8YLsRux6EkwGlTN7TYoSGc=;
        b=bOAPgmu7Snz/Ho0kwPYWYSsjGAcC+25Q381GweCFPc0C05IF8V2e0N7We7Wdfe8bI/CST6
        dHXMGLVBsPwKpMQYvP/E+MmbxitRCOqqCzTIPphUT7/l1QO8IN7i46QGmGshvFSCyJadqD
        gUCSkFdi0ieCal3mKXaBMcom8nZP7u4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-Ps_XncIOMcqzLg8UW18LgA-1; Wed, 29 Sep 2021 12:30:04 -0400
X-MC-Unique: Ps_XncIOMcqzLg8UW18LgA-1
Received: by mail-wr1-f72.google.com with SMTP id a10-20020a5d508a000000b00160723ce588so798310wrt.23
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 09:30:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=t7eXK8bCTNOOv/qDjkAKe8YLsRux6EkwGlTN7TYoSGc=;
        b=Mvc1RBCrL3hWog2SGOtMOWMWvz+5/FwgykXTKV7D9crlFvu6wzQB8Nofq2YuSCMY6O
         CSl7tagIH6di1kasbXGmzSV2YPVE70kjWviML8LOAoXjTQg4Onm7HI40qxKP+z7e39Bf
         pUEnjv9sR5OXFXgzrZ7aIswRZ0l3aHiUSPrjhrgavaEzua3IjtgUCNidJ7x43liTHIJa
         mlx4UFMZ5IIwsWSMLVrId/ODhwsexpP2tOxItT2MSNulh2AqKBnUODQfpYDLkyxsMqpW
         4NozHfWNYTc25wtT3hCsSGZPoTITPxopp2EDDUKQlPY0bCKJFxN4dNTENPBEFM9ZwGpg
         uurA==
X-Gm-Message-State: AOAM5307tIxEY057AQX5bjHkf2FB4rsqsCQnn31CAnFB4iTjVXtylfrj
        X/6kL/f24Kubk7SBgKTlpw8v/TktrCrkSE+PrlmcKaNYvU/gIyf50OW34Vp6ACeSSR986JGgbJx
        ATG1QEIuqjoS1
X-Received: by 2002:adf:f191:: with SMTP id h17mr943921wro.43.1632933003596;
        Wed, 29 Sep 2021 09:30:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMKQ2tzAe8SV4xU9Q4r3+pzNtUhyQ6D04HKaRcV2gBTFGRYqLL3oOhEANMbHZjKoZNw4mKbA==
X-Received: by 2002:adf:f191:: with SMTP id h17mr943889wro.43.1632933003388;
        Wed, 29 Sep 2021 09:30:03 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id q18sm2165702wmc.7.2021.09.29.09.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 09:30:02 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 03/10] KVM: arm64: vgic-v2: Check cpu interface region
 is not above the VM IPA size
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-4-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <4e4248ae-234c-20cb-6428-00a0cc7de5b9@redhat.com>
Date:   Wed, 29 Sep 2021 18:30:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210928184803.2496885-4-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 9/28/21 8:47 PM, Ricardo Koller wrote:
> Verify that the GICv2 CPU interface does not extend beyond the
> VM-specified IPA range (phys_size).
>
>   base + size > phys_size AND base < phys_size
>
> Add the missing check into kvm_vgic_addr() which is called when setting
> the region. This patch also enables some superfluous checks for the
> distributor (vgic_check_ioaddr was enough as alignment == size for the
> distributors).
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic-kvm-device.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> index f714aded67b2..b379eb81fddb 100644
> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
> @@ -79,7 +79,7 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  {
>  	int r = 0;
>  	struct vgic_dist *vgic = &kvm->arch.vgic;
> -	phys_addr_t *addr_ptr, alignment;
> +	phys_addr_t *addr_ptr, alignment, size;
>  	u64 undef_value = VGIC_ADDR_UNDEF;
>  
>  	mutex_lock(&kvm->lock);
> @@ -88,16 +88,19 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
>  		addr_ptr = &vgic->vgic_dist_base;
>  		alignment = SZ_4K;
> +		size = KVM_VGIC_V2_DIST_SIZE;
>  		break;
>  	case KVM_VGIC_V2_ADDR_TYPE_CPU:
>  		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V2);
>  		addr_ptr = &vgic->vgic_cpu_base;
>  		alignment = SZ_4K;
> +		size = KVM_VGIC_V2_CPU_SIZE;
>  		break;
>  	case KVM_VGIC_V3_ADDR_TYPE_DIST:
>  		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V3);
>  		addr_ptr = &vgic->vgic_dist_base;
>  		alignment = SZ_64K;
> +		size = KVM_VGIC_V3_DIST_SIZE;
>  		break;
>  	case KVM_VGIC_V3_ADDR_TYPE_REDIST: {
>  		struct vgic_redist_region *rdreg;
> @@ -162,7 +165,7 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>  		goto out;
>  
>  	if (write) {
> -		r = vgic_check_ioaddr(kvm, addr_ptr, *addr, alignment);
> +		r = vgic_check_iorange(kvm, addr_ptr, *addr, alignment, size);
>  		if (!r)
>  			*addr_ptr = *addr;
>  	} else {
Looks god to me

Reviewed-by: Eric Auger <eric.auger@redhat.com>


Eric

