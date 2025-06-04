Return-Path: <kvm+bounces-48427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 25006ACE263
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 18:44:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 563FB18977F7
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 16:44:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18C0D1E885A;
	Wed,  4 Jun 2025 16:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GBXRqseM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095FF1DE4E6
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 16:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749055442; cv=none; b=FqKFqUITnlNgFG5Vuj/nkOymlEkcv453p0JW7995fEv1OUoIg7mB91lfNuDmdvcEDiQD1wN+aCpcMwqyoTlnbbYIlCS9rFrViUNnUpMhhGhUKg/11BSWRU/R8x1eexw5Ok75pavhUlh8i2ECJG3gliZUtnUXPJF84GSwMNN0Hmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749055442; c=relaxed/simple;
	bh=D+aWTJlBR5Z1dDFyEuWrqwhKgcw6YgC3O9B89j9DBdM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TgzB+m0yHvu51wN0MF9DnYrKQhSOuEuhGR8vgR5VjknnnD8NEBcSoCcK3PeuGZuBSsxZJ8TpuwmZBgqTMMXKbzqTbgIoRD0yBZL9PjLTMVS5IPIS6JxgjUmAp6p4078fpSSvPS/CqC1X/QotRt7hfNqj1Y8/ZbxK1EV7r60jKOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GBXRqseM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749055436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5uX+RcrMuYZZlT9e7PZl8kq+9gKjyZrSElVvecqGEe0=;
	b=GBXRqseMSTyFZOcntX+I+AwRzNJIVeogCjE8t1WcuJcZeHwnUwbyda626S31us7peOTCKG
	OkH2WDWcGx0JOGCGq3kPAhYt8h5ugE6h5BZzmP/54DnZYtMA4fY5HnF8pIRcqp64jVRusu
	2TgJUEpzi8lFxLPs8iWWnpwiUrEUxYw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-akaDOl3cPFSAjXKkJQM6DA-1; Wed, 04 Jun 2025 12:43:55 -0400
X-MC-Unique: akaDOl3cPFSAjXKkJQM6DA-1
X-Mimecast-MFC-AGG-ID: akaDOl3cPFSAjXKkJQM6DA_1749055434
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a3696a0d3aso6970f8f.2
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 09:43:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749055434; x=1749660234;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5uX+RcrMuYZZlT9e7PZl8kq+9gKjyZrSElVvecqGEe0=;
        b=f3XAtXs3JNZbPtN+We2429HQCl3ro6tqVpypEGzKwNiuOkXcLIKv2GzCilH98kCBkG
         /BmkdiCuJXGNHkf1DwYH7D+Pi0nUXlONBsfm0ADeWTyC6Qjw84HNqE+5yEoYijhTR+4e
         BBjJoHBj1HAgzJe3ZvsLliI5lLzcTHJ7k7bW1jt6BLkTzsnbLgHxTrTqk8W5EDDvEUXM
         LA0ylnHM27raDMst1ivJ+6NLyn/kh+AzbDYr+8KS8lL8JbMg/WwMKnlr0ibqTlk8G9jq
         HgN3NPx0kBUQE0ZndBwJWln/OIiEDt3a/TpoLVPscr4ByNq1D57tM8AW52n53EbM4isk
         o9GQ==
X-Gm-Message-State: AOJu0Yw77Y0wXa7L8dnJ4PJ2+6CuJQNLXlbS3Kh+vAPZF4c7U7xjnwXP
	Lrxm6Ijnrg3zXD0ZAGhlsx5iulUux9iuMpa8XCx3ArZ9dvstHqXLsgtVe0yFcfHI0Fy7ZgYqZJ2
	nWdmF+YJW01q3HkQhuoxUPACxxe3y2vJbx8A+N+EA99kmjUVgOR28Tg==
X-Gm-Gg: ASbGnctVgkIk0uuxE9UBTLiDTjur63zhL0t4Lz8O9Pz/Y1Gjl+flu/eItjU1vPQCqIs
	Kru+k8SI+5Wgq/pQt5Dcw65WQhLrALgVeJTnzoaJr9L1zhNhX0zph7fDXMnMbH1y1mNWp3PjTlH
	Xsy/o8/humoApV9q3DfXI4u3jYeJCeFVxEnn+fZYHfekMMp928stv22kfJq29SMGQsYwfvmyT75
	JbFupcAQ4GKXna0+z6uoYa8nU8DutEHJt+GGkwcbdEaUGFwBntT0kuFSpeJPwR6TWgEGZ7t3XWH
	rsE0YLOKC+mQjw==
X-Received: by 2002:a05:6000:400d:b0:3a4:db94:2cfc with SMTP id ffacd0b85a97d-3a51d97b8c9mr3072853f8f.43.1749055433848;
        Wed, 04 Jun 2025 09:43:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCntt0U7ekMD/3TwxfttPyNya1EiPp8j8ZDG5E1tlDGzx3/ONAjY/WPQcKTOr2WSgewAeoZQ==
X-Received: by 2002:a05:6000:400d:b0:3a4:db94:2cfc with SMTP id ffacd0b85a97d-3a51d97b8c9mr3072830f8f.43.1749055433447;
        Wed, 04 Jun 2025 09:43:53 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.64.79])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3a4f009748fsm21929578f8f.80.2025.06.04.09.43.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 09:43:52 -0700 (PDT)
Message-ID: <e84bd556-38db-49eb-9ea1-f30ea84f2d3a@redhat.com>
Date: Wed, 4 Jun 2025 18:43:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/15] KVM: x86: Fold kvm_setup_default_irq_routing() into
 kvm_ioapic_init()
To: Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250519232808.2745331-1-seanjc@google.com>
 <20250519232808.2745331-6-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250519232808.2745331-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/25 01:27, Sean Christopherson wrote:
> Move the default IRQ routing table used for in-kernel I/O APIC routing to
> ioapic.c where it belongs, and fold the call to kvm_set_irq_routing() into
> kvm_ioapic_init() (the call via kvm_setup_default_irq_routing() is done
> immediately after kvm_ioapic_init()).
> 
> In addition to making it more obvious that the so called "default" routing
> only applies to an in-kernel I/O APIC, getting it out of irq_comm.c will
> allow removing irq_comm.c entirely, and will also allow for guarding KVM's
> in-kernel I/O APIC emulation with a Kconfig with minimal #ifdefs.
> 
> No functional change intended.

Well, it also applies to the PIC.  Even though the IOAPIC and PIC (and 
PIT) do come in a bundle, it's a bit weird to have the PIC routing 
entries initialized by kvm_ioapic_init().  Please keep 
kvm_setup_default_irq_routine() a separate function.

Paolo

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/ioapic.c   | 32 ++++++++++++++++++++++++++++++++
>   arch/x86/kvm/irq.h      |  1 -
>   arch/x86/kvm/irq_comm.c | 32 --------------------------------
>   arch/x86/kvm/x86.c      |  6 ------
>   4 files changed, 32 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index 8c8a8062eb19..dc45ea9f5b9c 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -710,6 +710,32 @@ static const struct kvm_io_device_ops ioapic_mmio_ops = {
>   	.write    = ioapic_mmio_write,
>   };
>   
> +#define IOAPIC_ROUTING_ENTRY(irq) \
> +	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
> +	  .u.irqchip = { .irqchip = KVM_IRQCHIP_IOAPIC, .pin = (irq) } }
> +#define ROUTING_ENTRY1(irq) IOAPIC_ROUTING_ENTRY(irq)
> +
> +#define PIC_ROUTING_ENTRY(irq) \
> +	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
> +	  .u.irqchip = { .irqchip = SELECT_PIC(irq), .pin = (irq) % 8 } }
> +#define ROUTING_ENTRY2(irq) \
> +	IOAPIC_ROUTING_ENTRY(irq), PIC_ROUTING_ENTRY(irq)
> +
> +static const struct kvm_irq_routing_entry default_routing[] = {
> +	ROUTING_ENTRY2(0), ROUTING_ENTRY2(1),
> +	ROUTING_ENTRY2(2), ROUTING_ENTRY2(3),
> +	ROUTING_ENTRY2(4), ROUTING_ENTRY2(5),
> +	ROUTING_ENTRY2(6), ROUTING_ENTRY2(7),
> +	ROUTING_ENTRY2(8), ROUTING_ENTRY2(9),
> +	ROUTING_ENTRY2(10), ROUTING_ENTRY2(11),
> +	ROUTING_ENTRY2(12), ROUTING_ENTRY2(13),
> +	ROUTING_ENTRY2(14), ROUTING_ENTRY2(15),
> +	ROUTING_ENTRY1(16), ROUTING_ENTRY1(17),
> +	ROUTING_ENTRY1(18), ROUTING_ENTRY1(19),
> +	ROUTING_ENTRY1(20), ROUTING_ENTRY1(21),
> +	ROUTING_ENTRY1(22), ROUTING_ENTRY1(23),
> +};
> +
>   int kvm_ioapic_init(struct kvm *kvm)
>   {
>   	struct kvm_ioapic *ioapic;
> @@ -731,8 +757,14 @@ int kvm_ioapic_init(struct kvm *kvm)
>   	if (ret < 0) {
>   		kvm->arch.vioapic = NULL;
>   		kfree(ioapic);
> +		return ret;
>   	}
>   
> +	ret = kvm_set_irq_routing(kvm, default_routing,
> +				  ARRAY_SIZE(default_routing), 0);
> +	if (ret)
> +		kvm_ioapic_destroy(kvm);
> +
>   	return ret;
>   }
>   
> diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
> index 33dd5666b656..f6134289523e 100644
> --- a/arch/x86/kvm/irq.h
> +++ b/arch/x86/kvm/irq.h
> @@ -107,7 +107,6 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu);
>   
>   int apic_has_pending_timer(struct kvm_vcpu *vcpu);
>   
> -int kvm_setup_default_irq_routing(struct kvm *kvm);
>   int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
>   			     struct kvm_lapic_irq *irq,
>   			     struct dest_map *dest_map);
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index b85e4be2ddff..998c4a34d87c 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -334,38 +334,6 @@ bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
>   }
>   EXPORT_SYMBOL_GPL(kvm_intr_is_single_vcpu);
>   
> -#define IOAPIC_ROUTING_ENTRY(irq) \
> -	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
> -	  .u.irqchip = { .irqchip = KVM_IRQCHIP_IOAPIC, .pin = (irq) } }
> -#define ROUTING_ENTRY1(irq) IOAPIC_ROUTING_ENTRY(irq)
> -
> -#define PIC_ROUTING_ENTRY(irq) \
> -	{ .gsi = irq, .type = KVM_IRQ_ROUTING_IRQCHIP,	\
> -	  .u.irqchip = { .irqchip = SELECT_PIC(irq), .pin = (irq) % 8 } }
> -#define ROUTING_ENTRY2(irq) \
> -	IOAPIC_ROUTING_ENTRY(irq), PIC_ROUTING_ENTRY(irq)
> -
> -static const struct kvm_irq_routing_entry default_routing[] = {
> -	ROUTING_ENTRY2(0), ROUTING_ENTRY2(1),
> -	ROUTING_ENTRY2(2), ROUTING_ENTRY2(3),
> -	ROUTING_ENTRY2(4), ROUTING_ENTRY2(5),
> -	ROUTING_ENTRY2(6), ROUTING_ENTRY2(7),
> -	ROUTING_ENTRY2(8), ROUTING_ENTRY2(9),
> -	ROUTING_ENTRY2(10), ROUTING_ENTRY2(11),
> -	ROUTING_ENTRY2(12), ROUTING_ENTRY2(13),
> -	ROUTING_ENTRY2(14), ROUTING_ENTRY2(15),
> -	ROUTING_ENTRY1(16), ROUTING_ENTRY1(17),
> -	ROUTING_ENTRY1(18), ROUTING_ENTRY1(19),
> -	ROUTING_ENTRY1(20), ROUTING_ENTRY1(21),
> -	ROUTING_ENTRY1(22), ROUTING_ENTRY1(23),
> -};
> -
> -int kvm_setup_default_irq_routing(struct kvm *kvm)
> -{
> -	return kvm_set_irq_routing(kvm, default_routing,
> -				   ARRAY_SIZE(default_routing), 0);
> -}
> -
>   void kvm_scan_ioapic_irq(struct kvm_vcpu *vcpu, u32 dest_id, u16 dest_mode,
>   			 u8 vector, unsigned long *ioapic_handled_vectors)
>   {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f9f798f286ce..4a9c252c9dab 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7118,12 +7118,6 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>   			goto create_irqchip_unlock;
>   		}
>   
> -		r = kvm_setup_default_irq_routing(kvm);
> -		if (r) {
> -			kvm_ioapic_destroy(kvm);
> -			kvm_pic_destroy(kvm);
> -			goto create_irqchip_unlock;
> -		}
>   		/* Write kvm->irq_routing before enabling irqchip_in_kernel. */
>   		smp_wmb();
>   		kvm->arch.irqchip_mode = KVM_IRQCHIP_KERNEL;


