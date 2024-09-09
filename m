Return-Path: <kvm+bounces-26136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8CEB971E19
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 17:33:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D554D1C22354
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 15:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B30D644375;
	Mon,  9 Sep 2024 15:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BJ4npUj4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2D173440
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 15:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725896025; cv=none; b=W4VvVnWmpSbaS59JH4CuXfzwRdUfCMtZciKHWNXA0ysREIXnA0A2OesLH4nIX0RsTM/Z+3OkGGSu0nKUerXNkljCnaSixU/Z6Z0vq6wDGb+vaEyMVGoMDXsED6XPVZr6zJP9Flmh0ZtFtpusThtgrN5CnjSSk8ZMEpdTuuBTutw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725896025; c=relaxed/simple;
	bh=UMQZe0Ltvv2IG2a9wljq7TM3IkBwoLnGQUULyAPtGAk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TE8zxnkOtmD2X4C4XwhDVxuGxYPvMuq1pwWPOMOswxdD9Rl30GLlkqV6UfAWXf3WBBbNoH8TomH7XnoNSY/Py6ebp9BrZvNzcXQjc/ZFHKwbMcFLxmxDcv2h7oCd6XwMQbXeXvpSTgJ4QLNljdI3YVQ1DIOBNgFKnFDPSBmHm00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BJ4npUj4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725896023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WidaePpOhrsaL47Ug1d7ZVUIzC/tXX366e9bJY3o/FY=;
	b=BJ4npUj4OMdVAo4i9wPaPHSgpAZcvBHbovuEhgdDKjZEjCnrym0K3mJNDOyaRiu9Bd57oA
	APgvzi5WAHdab5Q+WRW5izTSiEd//t+afD7u9Q6Gbgo5Bj8a4kHo061YLXiu1PBmu6U6+q
	gi3Uz1kkpv+codF4XBof26Yk0GXiCbY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-j8BQXuCoMuiRb_gqJuwRsA-1; Mon, 09 Sep 2024 11:33:42 -0400
X-MC-Unique: j8BQXuCoMuiRb_gqJuwRsA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-42caf073db8so18538415e9.3
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 08:33:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725896021; x=1726500821;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WidaePpOhrsaL47Ug1d7ZVUIzC/tXX366e9bJY3o/FY=;
        b=beD2lKXOiSgHh8NmLmC06ppmon2wEq28xy3JSf9dcVm5pTNusuLL8V/V0ZxMhyjQAQ
         YoxXPmV7I3lMG2r6YsGABxiDdof0VEUEY4xFH6Zq+G0PaO9S/rVohTbP8HRv3EFocw05
         uZjZY52R2INtcjlbkQYqYhi/QfQQ4LCTIrcoJkr1WyXY5QSqHhBWhiixVez0kIQDeKoa
         O8FV33Iuv2d85tfhzuD/njQd9qvjppf8GbQ2i1Jh12fKzkB4eyKgURte9Eyi54HpbUIh
         ShUrQMHUmSe47W+9k85SirCUj9+SZBlQyVvY0Z9ozy5U9NpnLmjZcr1ZMzPNr0bzBoDn
         bMEw==
X-Forwarded-Encrypted: i=1; AJvYcCXjcG04A8g8rW7jON2SHgNy69eJ3GLyXZ/Xzl0iB505khzHQJWlPzibsKwgtzVAqhfnZXs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRBDvHV+9z2RqRhmDOiNiJp6o1RSOVNwL8FQaad16dbUt2KuoG
	OkLhV0fX6Nb7YdIZVayw9NjIwG8lbL1vAglg7JsXS43h+bSx/YF4l8KQWnHYVE8h5PqRUVj/1Dk
	QxiID7j1KRrKIYcj9i1s2TNJF8lmlxyMxgQACMug5JtsqCeS6BQ==
X-Received: by 2002:a05:600c:5102:b0:42c:bbd5:af60 with SMTP id 5b1f17b1804b1-42cbbd5b298mr10870435e9.24.1725896020798;
        Mon, 09 Sep 2024 08:33:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4dw4cu2zgK6ywhn2YqWBHMvf6OtteRJfVRRO50kbxvWZF7bAUiZqNmFhsu/81vGaAeWGxag==
X-Received: by 2002:a05:600c:5102:b0:42c:bbd5:af60 with SMTP id 5b1f17b1804b1-42cbbd5b298mr10870175e9.24.1725896020281;
        Mon, 09 Sep 2024 08:33:40 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-42caeb8181csm80215315e9.33.2024.09.09.08.33.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 08:33:39 -0700 (PDT)
Message-ID: <32ab1360-84c4-4eec-b1ee-d3e63cdbee44@redhat.com>
Date: Mon, 9 Sep 2024 17:33:38 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/21] KVM: x86/mmu: Add setter for shadow_mmio_value
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-12-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240904030751.117579-12-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 05:07, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Future changes will want to set shadow_mmio_value from TDX code. Add a
> helper to setter with a name that makes more sense from that context.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> [split into new patch]
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> TDX MMU part 2 v1:
>   - Split into new patch
> ---
>   arch/x86/kvm/mmu.h      | 1 +
>   arch/x86/kvm/mmu/spte.c | 6 ++++++
>   2 files changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 5faa416ac874..72035154a23a 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -78,6 +78,7 @@ static inline gfn_t kvm_mmu_max_gfn(void)
>   u8 kvm_mmu_get_max_tdp_level(void);
>   
>   void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
> +void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value);
>   void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
>   void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
>   
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index d4527965e48c..46a26be0245b 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -409,6 +409,12 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
>   }
>   EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
>   
> +void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value)
> +{
> +	kvm->arch.shadow_mmio_value = mmio_value;
> +}
> +EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_value);
> +
>   void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask)
>   {
>   	/* shadow_me_value must be a subset of shadow_me_mask */

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>


