Return-Path: <kvm+bounces-22332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B1CAB93D7B3
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 19:34:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9B191C23195
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 17:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C4B17D342;
	Fri, 26 Jul 2024 17:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f3W+lXIc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99A318AEA
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 17:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722015283; cv=none; b=A7Zmf+66oAijlR40lkCCLVTNoQRSsBfNbSx2DNeuDYmem1R2UmbjmRqpetOnUcoHqLHdXDFCdtIEKeXGeMBB1unwwfpdL/Xo+MMjNU63oQd+jw/CC8HUYe/4J/m1TM6Y+stGwuh3Nlo3zTpzlCw6XIrIF9CtET+c05WP43vJ/QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722015283; c=relaxed/simple;
	bh=ZnYnIXoXxIb6+vQl5JcmJ28GfasirmJi22QkG1uh3UY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p/bt1Kv1fnNq/1+gXYYz4ZBlnVvVVHVEbkQMTJ25nLSFwpqIagb0DFVwZ20LPhbwmVRoZGGXcuzgC+xADYr7SXuMGhGfBnHEtFe9KCahcXMJ4/JG0KbVEUcnHelXZTquUP3fWyCmgRHixaFw+2h8v1wB1lcvzOAIFM7Xh5zm0ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f3W+lXIc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722015280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rq4Im9vqHsfoyM9FOFKTn1tGLcCn4/tVd/HQLonaYPU=;
	b=f3W+lXIcCzDSGnOkaytFEklRuHMV8vio9SqQjOMfp66eJtW+gg5TPE5kpFZVG4OagH03WY
	CFSMIZCIKymD0EfkbbKcVUDEyt1rADY+I3rOi/dIkH69dc26x3g3/a8EVBpTmhNaFGUiU9
	lzgF9yPYVEiaD5jvFteB5JoARB0aLlg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-533-owuy_HlKMmKyuoW20yds_g-1; Fri, 26 Jul 2024 13:34:39 -0400
X-MC-Unique: owuy_HlKMmKyuoW20yds_g-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42666ed2d5fso16163885e9.3
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 10:34:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722015278; x=1722620078;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rq4Im9vqHsfoyM9FOFKTn1tGLcCn4/tVd/HQLonaYPU=;
        b=qXQvb0X8B/inwqemxo6GLmfqicXrJKKNJioM/k78zKDD4bIq28Zwq554eKBHQ19hnv
         x1gdR/pYVW8KGsBS5xxAXAXCHafGPJ6K23JlQwzPIrkq4tceg3NtqNOdJpR6DiRZ/drO
         udttA15m3jEZ4C6gRl1XDlZST288AOUD+Yn7KNmF/G/HXR4ozyJx+sxIGbpwV1isyJI5
         F4yyCcWk5tKwqYobVtc4624/ZPbiObRMUsqTgLpdDoT4KBOlNEHciliZQXrVQ//3eo64
         51CBRd0pQ1PABRLTQovDTph4ueX3TDnQNoAS+3V5lnLkU/fCdooYTcuLv+WvJFlG4uvd
         OWog==
X-Forwarded-Encrypted: i=1; AJvYcCWrYJI1i2/DPEQptMGMN+xog3MWugRaKqsc3FDhP0XJUsrIRtfOwyG2OvgzdSJUYFCT6sJqyD6uMcwQUwx/7CrMoo2k
X-Gm-Message-State: AOJu0YwfYOb6Grwqd1gyIx1gb2p+Uvttwl3bimeLh3S4Vr0vDMMiiq03
	mLxpATR4dlsz664EB6oMhaQQpZc50E63BtnuE05ZByHT3+mP6BJgdk7SYIVcHEXHth1J15UXG6u
	V5JbzglLHNy7JomjiRwDXrksPd0/OXACNElH3Lx92klXTuxbf1Q==
X-Received: by 2002:a05:600c:3585:b0:426:5c9b:dee6 with SMTP id 5b1f17b1804b1-42811dd19e3mr2036165e9.26.1722015278184;
        Fri, 26 Jul 2024 10:34:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1qAycT9ZRsbQjSQ0QUwONvOsueYDPp5FNV80W08mT3b5jYmBGx5IEqB4d1jTPtfc1HAhbDA==
X-Received: by 2002:a05:600c:3585:b0:426:5c9b:dee6 with SMTP id 5b1f17b1804b1-42811dd19e3mr2036035e9.26.1722015277786;
        Fri, 26 Jul 2024 10:34:37 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-427f93594b6sm129099845e9.5.2024.07.26.10.34.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jul 2024 10:34:37 -0700 (PDT)
Message-ID: <d37454cb-458d-4585-bf76-d7adf50ffbac@redhat.com>
Date: Fri, 26 Jul 2024 19:34:36 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Eliminate log spam from limited APIC timer
 periods
To: Jim Mattson <jmattson@google.com>, Sean Christopherson
 <seanjc@google.com>, kvm@vger.kernel.org
Cc: James Houghton <jthoughton@google.com>
References: <20240724190640.2449291-1-jmattson@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240724190640.2449291-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/24/24 21:05, Jim Mattson wrote:
> SAP's vSMP MemoryONE continuously requests a local APIC timer period
> less than 500 us, resulting in the following kernel log spam:
> 
>    kvm: vcpu 15: requested 70240 ns lapic timer period limited to 500000 ns
>    kvm: vcpu 19: requested 52848 ns lapic timer period limited to 500000 ns
>    kvm: vcpu 15: requested 70256 ns lapic timer period limited to 500000 ns
>    kvm: vcpu 9: requested 70256 ns lapic timer period limited to 500000 ns
>    kvm: vcpu 9: requested 70208 ns lapic timer period limited to 500000 ns
>    kvm: vcpu 9: requested 387520 ns lapic timer period limited to 500000 ns
>    kvm: vcpu 9: requested 70160 ns lapic timer period limited to 500000 ns
>    kvm: vcpu 66: requested 205744 ns lapic timer period limited to 500000 ns
>    kvm: vcpu 9: requested 70224 ns lapic timer period limited to 500000 ns
>    kvm: vcpu 9: requested 70256 ns lapic timer period limited to 500000 ns
>    limit_periodic_timer_frequency: 7569 callbacks suppressed
>    ...
> 
> To eliminate this spam, change the pr_info_ratelimited() in
> limit_periodic_timer_frequency() to pr_info_once().
> 
> Reported-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Jim Mattson <jmattson@google.com>

Applied, thanks.

Paolo

> ---
>   arch/x86/kvm/lapic.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index f64a5cc0ce72..c576a53733e5 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1743,7 +1743,7 @@ static void limit_periodic_timer_frequency(struct kvm_lapic *apic)
>   		s64 min_period = min_timer_period_us * 1000LL;
>   
>   		if (apic->lapic_timer.period < min_period) {
> -			pr_info_ratelimited(
> +			pr_info_once(
>   			    "vcpu %i: requested %lld ns "
>   			    "lapic timer period limited to %lld ns\n",
>   			    apic->vcpu->vcpu_id,


