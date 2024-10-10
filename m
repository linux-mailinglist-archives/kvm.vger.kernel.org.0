Return-Path: <kvm+bounces-28423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61F5D9986AE
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 14:54:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D36551F22926
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 12:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 026051C6F65;
	Thu, 10 Oct 2024 12:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FHCtasNx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27591C232C
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 12:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728564836; cv=none; b=OfLfcyD7isuUZE4VtwEBMHXmS4g1i3NIBl/Dd9C7HCyed51gUYjRMc6txnbBZzlmK7piXGNtb3JbHSW10yOG7c49YEEiX/fOc+wS9UVoDinG36AO50ig/pRrn0meIzUP/HpIWLI67xF2zX1NB4LNoc2vOIRM+MJ02MfXvo4Nm48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728564836; c=relaxed/simple;
	bh=EFme/4SxALJe+BlJbK7fmuj0KFid9zEOfCzeZRFTRg4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PD11pIU0OaukO9vNgoYBjKVxNS8s+raSQEWzkdFaohlqdrcqvkzEkxOQDZoj8X5W2OpdEQRtMUrnHPloC/LxzwLfSYHfUQcIbmvr6d3FRcsOpiTH8BRBgh4sxnUNqn1OCZKzEBFcEL13+pGZCdF6NVo/Gsm6HpTDHioxi3u3r7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FHCtasNx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728564833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Dp6cnJFLdZ5gBOMD1Ds1O6L7Mcku1/oXYrG/mj/D0fw=;
	b=FHCtasNxgSTtV2nHr4M9Ee1HgW7lEGdk+4UbHKCSMDHyjTaStxarbGH12UjxOp8YfVIqNw
	/KnQ/W5jEvkZddZvzdpAkFXp6hiDWdlV+WKY414UZ9++uTiMxOpkDeU4eYYxeNklCChAND
	+5udF27A+HR/YN1WZ7Tk6CUJ97q7Z6Y=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-Ji3Dh6UwMtCpBVTHUWFZ7Q-1; Thu, 10 Oct 2024 08:53:52 -0400
X-MC-Unique: Ji3Dh6UwMtCpBVTHUWFZ7Q-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a993fa36b2dso73497766b.2
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 05:53:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728564830; x=1729169630;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dp6cnJFLdZ5gBOMD1Ds1O6L7Mcku1/oXYrG/mj/D0fw=;
        b=G/IyYm3oACzv3uqjKpmD8ELJGcFpiV+RPQA7NCqbMnlJgiMduPlaiDapUE1oTlgGTq
         is2v/c+UaOT9LSqGR7OD5drJgZIPgjO+lZttRlDEXknN3Szq830+LbQoaOkuT1NzDGbR
         Kz6JPhBGIg9IH3YetwM8J+1SC1KjsalNNjJ9q3Z1M4IVEKs1yEBf5deu4EPxX/voiQun
         xIyv1FSlZUb2YKbhvwMKTlViCZ6nGmJI5UVQSSM1dhqz8vqCBiCxL7jW6Ni5MeZJ75oi
         C8fU3v1yTD6KMAwAXhjj9WroqcrUt+bfIlXa7QGinQiAdXuUxnXFPEdL22dcm+/DgUgj
         QkAg==
X-Gm-Message-State: AOJu0Yyk004hCZ6Jr3hdti0W+wpKpMFUm+h3re71/hMrHzJbq/DTHYxL
	x/VCCmFyNvhldFRxvCK4z9rlcqGcEyQoD8ozeeFvB/briZUSg1iXEVXNgb1jvLF+G4hDIrOKoMY
	FrAv+QL+RPAw3cPgGiWjtQ7qvDd4cgZx5SfdWFIY64S1kpjvefUORjQ047mJS
X-Received: by 2002:a17:907:6e8e:b0:a8d:2b7a:ff44 with SMTP id a640c23a62f3a-a998d1f4ecdmr547192566b.32.1728564830619;
        Thu, 10 Oct 2024 05:53:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFd2Mcs/kk09rIwxZfXjqHQaW8CeS5JeRjB1xiwk5tURERdxopVCJcBGwSOUyc4zOEz9zZmyg==
X-Received: by 2002:a17:907:6e8e:b0:a8d:2b7a:ff44 with SMTP id a640c23a62f3a-a998d1f4ecdmr547190966b.32.1728564830225;
        Thu, 10 Oct 2024 05:53:50 -0700 (PDT)
Received: from [192.168.10.81] ([151.81.124.37])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a99a7ec5894sm85691466b.42.2024.10.10.05.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 05:53:49 -0700 (PDT)
Message-ID: <d31a2049-da55-4ee8-bb73-6304787aa27e@redhat.com>
Date: Thu, 10 Oct 2024 14:53:48 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] KVM: x86: Rename APIC base setters to better capture
 their relationship
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241009181742.1128779-1-seanjc@google.com>
 <20241009181742.1128779-7-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241009181742.1128779-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/24 20:17, Sean Christopherson wrote:
> Rename kvm_set_apic_base() and kvm_lapic_set_base() to kvm_apic_set_base()
> and __kvm_apic_set_base() respectively to capture that the underscores
> version is a "special" variant (it exists purely to avoid recalculating
> the optimized map multiple times when stuffing the RESET value).
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/lapic.c | 8 ++++----
>   arch/x86/kvm/lapic.h | 3 +--
>   arch/x86/kvm/x86.c   | 4 ++--
>   3 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 6239cfd89aad..0a73d9a09fe0 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2577,7 +2577,7 @@ u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu)
>   	return (tpr & 0xf0) >> 4;
>   }
>   
> -void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
> +static void __kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value)
>   {
>   	u64 old_value = vcpu->arch.apic_base;
>   	struct kvm_lapic *apic = vcpu->arch.apic;
> @@ -2628,7 +2628,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>   	}
>   }
>   
> -int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> +int kvm_apic_set_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   {
>   	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
>   	enum lapic_mode new_mode = kvm_apic_mode(msr_info->data);
> @@ -2644,7 +2644,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			return 1;
>   	}
>   
> -	kvm_lapic_set_base(vcpu, msr_info->data);
> +	__kvm_apic_set_base(vcpu, msr_info->data);
>   	kvm_recalculate_apic_map(vcpu->kvm);
>   	return 0;
>   }
> @@ -2752,7 +2752,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>   		msr_val = APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE;
>   		if (kvm_vcpu_is_reset_bsp(vcpu))
>   			msr_val |= MSR_IA32_APICBASE_BSP;
> -		kvm_lapic_set_base(vcpu, msr_val);
> +		__kvm_apic_set_base(vcpu, msr_val);

Might be worth a comment here, otherwise

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

for the entire series.

Paolo


