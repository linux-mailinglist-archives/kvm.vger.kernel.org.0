Return-Path: <kvm+bounces-12370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C48CD8857CB
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 12:08:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 634D71F23261
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 11:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B1E858121;
	Thu, 21 Mar 2024 11:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IQgnc9nP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485631CA9A;
	Thu, 21 Mar 2024 11:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711019275; cv=none; b=cPa7QE5juU3NtJhfaNlmSDj+6z8ecUswQKdxuMUrXC07opl4buvbySeBE52zZe0uRtunelvWaM32l/idNrVEiPXBqz3Eq/+TBbHXNeRFTL5/bX1qd5ob/hPXHCauN8AaKf4amSqIT5MfUylYupEO8Qa0ZryiQPBIjKLXBIGDMmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711019275; c=relaxed/simple;
	bh=991r5jVPabzsSiBI/2AWFmPQe3N0Culave2SmDvtwig=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=q153jhm3EaJw46qKo/b44ulqCTLAJQIA+oZgo6+6WQTgi7D2D9bEAmCMg/3V9oAq8T556RH230X7lFfXI1rkqxdtZTrhSiBt+wIE3EkJV4tm3Q+hb9plNtUscx7fBmChoJ0xZy90vGjSPwnGBycY75BjKYIE1GOf4y88XdWXzjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IQgnc9nP; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2d094bc2244so11870011fa.1;
        Thu, 21 Mar 2024 04:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711019272; x=1711624072; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LBA/ZrsdEP2mJDzZKy68MDsPNZzNplR+dVmyq9Un4qk=;
        b=IQgnc9nPvZVfyR95ZgpmAoguW5Kus9Rg1ze2NIGHaAwAAQ5Z1SrIzC9Bj/QRpAxjQJ
         75CEwsRwdBJpVxVsUj18f6vVcpE1wwXK7oL3IOSG8VOl8DFbQDiGzuaGqbPFRUDcvlXo
         9vtXcyk6KLD7RFImYSzT8eQFMjiGzvdGbKPw+mdxx5I6LoIhCfHHwM2OxgqgXfaM3UHL
         yWy6n5wOJruhsIEhbWMBxpsS5RjvUiPgYAvC5MTdcp3lSuK2+DIYoiFzrWX3auzVuVWp
         zlJXX5OUGA6GhlRIoHiVStKbVOR0rIAdAfz/nTCDObKz1NgAKOE1yzQaZRyarRYupLez
         GPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711019272; x=1711624072;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LBA/ZrsdEP2mJDzZKy68MDsPNZzNplR+dVmyq9Un4qk=;
        b=A6C5ynnEyW+7dE4LjoC704hFNOe0dC2yN3H9/hNqj1WXVoBQgphua5Kjy320obqUWK
         dzbhdyDHF4LwzyKbnGYkQdv1xRnsfpv0bXyZkemm0JlfBh0iqovXf2Nz+3IgQoQtDA0O
         27YwpmN8dKi0/i9Kr9nrNk31eWD3np068orgAfiqY80GG+w1tqFnnY/HG1Xy/Zahft0P
         65tNvivuSMqGRqAQckVIQ08edMxB+OX+F6XNZPmAY/K0g8TAEwP4lnUz/TSEaRHUfLmP
         l+i+8T7vw/n+m0PXAcBF08iu3fv+FGCMVapVK4n76TX+B1MmFcc/AbrVT5w0NPXqpwCo
         lhRQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4Wk8Pq7ADK/4JF6YyQG2kmIAbx66dkcoapX9PaYA4otHmAeZP3nsgPQT0WV0YjWAya8NjXB1cnUSxn3XRLS3t01t6SbD8ZIcYySYa
X-Gm-Message-State: AOJu0Yza3QwigmT36pUqKYwvp7Sm/ajnGgvDwnZ8l9F2SgfBY7T5HnOt
	jeupy3qm1VUVi3OtVU78qoI09IpAnwzyu9KytCwJfn7/7HiraxCf
X-Google-Smtp-Source: AGHT+IGX1IDugtt7aqvnV1u2P6JH4LDutUHs6obm/B1+3FHLV5PEVN89PYCsimtbkvZmRut8Tc1Rbw==
X-Received: by 2002:ac2:54b5:0:b0:513:426e:625 with SMTP id w21-20020ac254b5000000b00513426e0625mr5007201lfk.22.1711019272230;
        Thu, 21 Mar 2024 04:07:52 -0700 (PDT)
Received: from [192.168.16.136] (54-240-197-226.amazon.com. [54.240.197.226])
        by smtp.gmail.com with ESMTPSA id fl25-20020a05600c0b9900b00414778ca80fsm122464wmb.16.2024.03.21.04.07.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Mar 2024 04:07:51 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <a80b46a2-d07a-466e-b2b3-bed685292e47@xen.org>
Date: Thu, 21 Mar 2024 11:07:50 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 1/3] KVM: Add helpers to consolidate gfn_to_pfn_cache's
 page split check
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+106a4f72b0474e1d1b33@syzkaller.appspotmail.com,
 David Woodhouse <dwmw2@infradead.org>
References: <20240320001542.3203871-1-seanjc@google.com>
 <20240320001542.3203871-2-seanjc@google.com>
Organization: Xen Project
In-Reply-To: <20240320001542.3203871-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/03/2024 00:15, Sean Christopherson wrote:
> Add a helper to check that the incoming length for a gfn_to_pfn_cache is
> valid with respect to the cache's GPA and/or HVA.  To avoid activating a
> cache with a bogus GPA, a future fix will fork the page split check in
> the inner refresh path into activate() and the public rerfresh() APIs, at

nit: typo

> which point KVM will check the length in three separate places.
> 
> Deliberately keep the "page offset" logic open coded, as the only other
> path that consumes the offset, __kvm_gpc_refresh(), already needs to
> differentiate between GPA-based and HVA-based caches, and it's not obvious
> that using a helper is a net positive in overall code readability.
> 
> Note, for GPA-based caches, this has a subtle side effect of using the GPA
> instead of the resolved HVA in the check() path, but that should be a nop
> as the HVA offset is derived from the GPA, i.e. the two offsets are
> identical, barring a KVM bug.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   virt/kvm/pfncache.c | 27 +++++++++++++++++++--------
>   1 file changed, 19 insertions(+), 8 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


