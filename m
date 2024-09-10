Return-Path: <kvm+bounces-26210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD775972BF5
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 10:18:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69185285001
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 08:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3495218E75B;
	Tue, 10 Sep 2024 08:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P/fMk7/T"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E256187860
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 08:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725956196; cv=none; b=JwgKfb8vXrGoAU3W34BRxGCG2cJ+NT+SB4nCTg9bb0GIQIkFA9z8AcGUPHDZOCJbrKCfUNeEhd9A8UKEy1TEBz5tXLAx2Df2nudWVrBaKWWHJdVJNwTfNSg8OpNTrh0+Dyq3+Bh7CPFxOqM0URWAwkARsE63+vrvu6xX6ytF98M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725956196; c=relaxed/simple;
	bh=1cP/A0KxfoX+tNfZ/0kldrN3vRzU0dU83KFJQJkaPVY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WN+FIuUMws860dyMXGpzCkVUtpm+NA6SgEVt5HE80S0yza2BzZfhnC7Y4HNoSRDkebsOYmpr9qBp3cZ41ebvslshAzk6U8VSRrG6lkPPZj7Cfa72I7iwVHUQIf90fsExiCN05phMnIQX2Z8KOVfDCkc90j509kioXYspqn51Ggo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P/fMk7/T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725956193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7T8hGkEiRUE85g8dfge0UQzCTu3abH89aAk2D2zpZ1U=;
	b=P/fMk7/THxpzD6sq6+HyFmAh929+mcCa5lgMqvJLBeCbIo779nDxyjNyQYdaCzZlOuzBHP
	3/GeX2XPlNmB0EbCHdimLVhunoTGH0deXnUI3daDp0RQjTNbAIp0g1TqHaJz41cg4FVU5b
	uR53BjPAtg6Co6P0xRp/ZlSGEu8NkZ0=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-411-Z8JYWn8lMAO4moCwxak9VA-1; Tue, 10 Sep 2024 04:16:31 -0400
X-MC-Unique: Z8JYWn8lMAO4moCwxak9VA-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5356908d54dso5159072e87.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 01:16:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725956189; x=1726560989;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7T8hGkEiRUE85g8dfge0UQzCTu3abH89aAk2D2zpZ1U=;
        b=lPSGNaxsHs1jdLl64ecGsv4GsQsxeSSZcz3tF5/FGvM59RDOTE0jAyWxoj0E0k9UK/
         SGKi2hg4xHkBvbM279oZw7V+Qvz8Gu5gIVz6+/Iyu6vRGpmNgxlpgcrYbWv4hNE1Z8kA
         y9BgK5sN5UvtrHYAeNVqesdyq+7+aM4sJorovLrf5glHwSEqGDgqw5O1YAicDLCoK2HR
         zUcd6ffotd3QyAy4X76mROy4Kfu26zW9vy0RjXEw5cQ8MUuxHBRJ9JUvTxq3zldGplNE
         kPOlRAodUjKhpNa8T/Uzm9J9pmoTYGpnz8XEWfZktkSapgC8Ofj/MThFWQTeSHYPiI+S
         xoHA==
X-Forwarded-Encrypted: i=1; AJvYcCWHc1jC7W8+gJgsPJNmChCw70BBoPHYM+XNrLGZMuO/RoSX25C232t2B/0uJ22UI6AbuYY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXf38i/oRaRI5LOs6T/fEdplUp4Be7AmBoAR0Rfs6dhcZ1beTt
	1yNEk9L2o7R6z6h+fz/1KxmBMRO1ZbrXkMEE/zGtEWKlxy7GgQvZDw2d2XnDrxWlnGlRQPji+BP
	kdQOIaX1CrFglvXr/y+mjH6kE8pa+tA16lAYnQwyJJNayyt93s1sZW4Yw22vJ
X-Received: by 2002:a05:6512:1110:b0:535:6400:1da8 with SMTP id 2adb3069b0e04-536587b42afmr8638123e87.28.1725956189336;
        Tue, 10 Sep 2024 01:16:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFaFrhtSp+vFrYDT5bW+iywaJuoR8w00Hzs3YVtpOauRLTZdYj6Kg9VYOY8Z4r+qFTWIvmWsA==
X-Received: by 2002:a05:6512:1110:b0:535:6400:1da8 with SMTP id 2adb3069b0e04-536587b42afmr8638085e87.28.1725956188780;
        Tue, 10 Sep 2024 01:16:28 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3789564a52csm8190834f8f.11.2024.09.10.01.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 01:16:28 -0700 (PDT)
Message-ID: <e4ebdfca-fcb8-43fb-a15b-591d083b286f@redhat.com>
Date: Tue, 10 Sep 2024 10:16:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/21] KVM: TDX: Handle TLB tracking for TDX
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-14-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240904030751.117579-14-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 05:07, Rick Edgecombe wrote:
> +static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * TDX calls tdx_track() in tdx_sept_remove_private_spte() to ensure
> +	 * private EPT will be flushed on the next TD enter.
> +	 * No need to call tdx_track() here again even when this callback is as
> +	 * a result of zapping private EPT.
> +	 * Just invoke invept() directly here to work for both shared EPT and
> +	 * private EPT.
> +	 */
> +	if (is_td_vcpu(vcpu)) {
> +		ept_sync_global();
> +		return;
> +	}
> +
> +	vmx_flush_tlb_all(vcpu);
> +}
> +
> +static void vt_flush_tlb_current(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		tdx_flush_tlb_current(vcpu);
> +		return;
> +	}
> +
> +	vmx_flush_tlb_current(vcpu);
> +}
> +

I'd do it slightly different:

static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
{
	if (is_td_vcpu(vcpu)) {
		tdx_flush_tlb_all(vcpu);
		return;
	}

	vmx_flush_tlb_all(vcpu);
}

static void vt_flush_tlb_current(struct kvm_vcpu *vcpu)
{
	if (is_td_vcpu(vcpu)) {
		/*
		 * flush_tlb_current() is used only the first time for
		 * the vcpu runs, since TDX supports neither shadow
		 * nested paging nor SMM.  Keep this function simple.
		 */
		tdx_flush_tlb_all(vcpu);
		return;
	}

	vmx_flush_tlb_current(vcpu);
}

and put the implementation details close to tdx_track:

void tdx_flush_tlb_all(struct kvm_vcpu *vcpu)
{
	/*
	 * TDX calls tdx_track() in tdx_sept_remove_private_spte() to
	 * ensure private EPT will be flushed on the next TD enter.
	 * No need to call tdx_track() here again, even when this
	 * callback is a result of zapping private EPT.  Just
	 * invoke invept() directly here, which works for both shared
	 * EPT and private EPT.
	 */
	ept_sync_global();
}


