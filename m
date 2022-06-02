Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31EA53BF4F
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 22:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239188AbiFBUIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 16:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239029AbiFBUIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 16:08:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE66236140
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 13:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654200508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IB/Vlnp4xtDrg/E/9iId0p0IwjHTTbtc1GZm3Z/63a4=;
        b=DLM6yiu6LQ+Phva+CDJEANBGLIqI/6pZmp7B2EdVnieHOBXI84uJed4qsBJh24QsloN54s
        P1bup9D+ErhGBwb3h9/PqvU/3diW6lmd9D5FqpW+IBxta+yS62AtjlD59c68hIy8pWViEj
        LUCRhWJ/w99el60aRa7IXtI7ybDjGrs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-408-B2tQvIAsOaeKMvCriUeEJA-1; Thu, 02 Jun 2022 16:08:26 -0400
X-MC-Unique: B2tQvIAsOaeKMvCriUeEJA-1
Received: by mail-wm1-f72.google.com with SMTP id m10-20020a05600c3b0a00b003948b870a8dso5647084wms.2
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 13:08:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IB/Vlnp4xtDrg/E/9iId0p0IwjHTTbtc1GZm3Z/63a4=;
        b=WiunkvTH8wyR4jgwJExa7gToCFJm81n7XtzIs8SkpFF2rlOzTGQKh/ucJypB4o43sE
         qan5/OVkCugZtQEqqMcMfJs5XUGNghRpP/wvgdrebxyA7JQLjE2GoFp6RTgcWnL6drXB
         PB2T7B8F0jkX7aOlsVDua62MUUJ3ho+yAJe7S+o18xtkX1ufXeNQk88PdqfA8csCV/Cc
         6LOs+79mEIl1t//Pkthli1F6aPe88MM/d8kCwsZoN+BPPN7AO47XN909WUdJoOA4VHDA
         hbpZkQiYlPjD4Ty8WynpSc3os9VMWkzw34cUWSzGHnhyIZmciz9vY77tPvn1Gy0WgH6S
         kIsA==
X-Gm-Message-State: AOAM533RCImRBnF0j2ZBdhJiNq1AQe19fWtvU5NLr1HJCDyQ20wpw1Tv
        rvFfysdCsiN/PF0XSgjXcBq2zTMmD9mELpZGWMVx0vZ1EGvM9yyLHsHYI0LynLIcL4GuSgbPSRQ
        5shFamfM3Fgyi
X-Received: by 2002:adf:e8cd:0:b0:210:2b10:ab22 with SMTP id k13-20020adfe8cd000000b002102b10ab22mr4970814wrn.476.1654200505457;
        Thu, 02 Jun 2022 13:08:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyM5F6JgsKGDtu6GyHns/lkcUnrlSJd7dUYftOOVGVMQv8KigpKfTOOpmHYrxeyjunNyCekoQ==
X-Received: by 2002:adf:e8cd:0:b0:210:2b10:ab22 with SMTP id k13-20020adfe8cd000000b002102b10ab22mr4970800wrn.476.1654200505241;
        Thu, 02 Jun 2022 13:08:25 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id bg20-20020a05600c3c9400b0039c15861001sm3796679wmb.21.2022.06.02.13.08.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jun 2022 13:08:24 -0700 (PDT)
Message-ID: <203411bb-39e5-ea3a-3265-354adf1fb551@redhat.com>
Date:   Thu, 2 Jun 2022 22:08:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/3] KVM: arm64: Don't read a HW interrupt pending state
 in user context
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc:     Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>, kernel-team@android.com
References: <20220602083025.1110433-1-maz@kernel.org>
 <20220602083025.1110433-2-maz@kernel.org>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20220602083025.1110433-2-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marc,

On 6/2/22 10:30, Marc Zyngier wrote:
> Since 5bfa685e62e9 ("KVM: arm64: vgic: Read HW interrupt pending state
> from the HW"), we're able to source the pending bit for an interrupt
> that is stored either on the physical distributor or on a device.
> 
> However, this state is only available when the vcpu is loaded,
> and is not intended to be accessed from userspace. Unfortunately,
> the GICv2 emulation doesn't provide specific userspace accessors,
> and we fallback with the ones that are intended for the guest,
> with fatal consequences.
> 
> Add a new vgic_uaccess_read_pending() accessor for userspace
> to use, build on top of the existing vgic_mmio_read_pending().
> 
> Reported-by: Eric Auger <eauger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Fixes: 5bfa685e62e9 ("KVM: arm64: vgic: Read HW interrupt pending state from the HW")
Feel free to add my
Tested-by: Eric Auger <eric.auger@redhat.com>

Thanks!

Eric
> ---
>  arch/arm64/kvm/vgic/vgic-mmio-v2.c |  4 ++--
>  arch/arm64/kvm/vgic/vgic-mmio.c    | 19 ++++++++++++++++---
>  arch/arm64/kvm/vgic/vgic-mmio.h    |  3 +++
>  3 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
> index 77a67e9d3d14..e070cda86e12 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
> @@ -429,11 +429,11 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
>  		vgic_mmio_read_pending, vgic_mmio_write_spending,
> -		NULL, vgic_uaccess_write_spending, 1,
> +		vgic_uaccess_read_pending, vgic_uaccess_write_spending, 1,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
>  		vgic_mmio_read_pending, vgic_mmio_write_cpending,
> -		NULL, vgic_uaccess_write_cpending, 1,
> +		vgic_uaccess_read_pending, vgic_uaccess_write_cpending, 1,
>  		VGIC_ACCESS_32bit),
>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
>  		vgic_mmio_read_active, vgic_mmio_write_sactive,
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
> index 49837d3a3ef5..dc8c52487e47 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio.c
> @@ -226,8 +226,9 @@ int vgic_uaccess_write_cenable(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> -unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
> -				     gpa_t addr, unsigned int len)
> +static unsigned long __read_pending(struct kvm_vcpu *vcpu,
> +				    gpa_t addr, unsigned int len,
> +				    bool is_user)
>  {
>  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
>  	u32 value = 0;
> @@ -248,7 +249,7 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
>  						    IRQCHIP_STATE_PENDING,
>  						    &val);
>  			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
> -		} else if (vgic_irq_is_mapped_level(irq)) {
> +		} else if (!is_user && vgic_irq_is_mapped_level(irq)) {
>  			val = vgic_get_phys_line_level(irq);
>  		} else {
>  			val = irq_is_pending(irq);
> @@ -263,6 +264,18 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
>  	return value;
>  }
>  
> +unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
> +				     gpa_t addr, unsigned int len)
> +{
> +	return __read_pending(vcpu, addr, len, false);
> +}
> +
> +unsigned long vgic_uaccess_read_pending(struct kvm_vcpu *vcpu,
> +					gpa_t addr, unsigned int len)
> +{
> +	return __read_pending(vcpu, addr, len, true);
> +}
> +
>  static bool is_vgic_v2_sgi(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
>  {
>  	return (vgic_irq_is_sgi(irq->intid) &&
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio.h b/arch/arm64/kvm/vgic/vgic-mmio.h
> index 3fa696f198a3..6082d4b66d39 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio.h
> +++ b/arch/arm64/kvm/vgic/vgic-mmio.h
> @@ -149,6 +149,9 @@ int vgic_uaccess_write_cenable(struct kvm_vcpu *vcpu,
>  unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
>  				     gpa_t addr, unsigned int len);
>  
> +unsigned long vgic_uaccess_read_pending(struct kvm_vcpu *vcpu,
> +					gpa_t addr, unsigned int len);
> +
>  void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
>  			      gpa_t addr, unsigned int len,
>  			      unsigned long val);

