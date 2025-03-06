Return-Path: <kvm+bounces-40226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B02B8A545B7
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 10:01:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1A061883E71
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 09:01:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0BF2066EF;
	Thu,  6 Mar 2025 09:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E6qtp8mN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC708828
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 09:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741251665; cv=none; b=k9qCiaOMMH+A9Rq4pbOKKquWxkkJ5tpcgKvwJygJ4HBKExAJJQFOeok0ERpd8GsF0zGqLehtAusbhvp+MDO5F14lBxZ4F0HHbLOfAzzsYn2B1jkyqAizfee9nl3Wc4xvOUOqBRMXFKwO8FuEU3UH8vlbIayZTyJrS6y3HqMWLAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741251665; c=relaxed/simple;
	bh=kpr2G1t2lYW/A7fi2Y1YgX1tpsvekdQ0DJ4km8eVkJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LU9kDFahRnYT49Acal+JoKkTXnlscuwaU9xmtK2wr3mdRXyuBAjs4goz7c9JYDJLRjHLzTJGMKHobXC2VB0trQL0pPi+rr5lMdHGH8l2Uuo8DPDrQBuGNL+eiXBJ88MjrYzTtsn7++XhNp5gh5i+2BMRgrjPmnjNGE+cWRv0gBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E6qtp8mN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741251662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pY2indv9DvyBZQJoUjIBXHffPxVcc0dm+eOOwrLDR6k=;
	b=E6qtp8mNXb6jBmSFaRQigSZZ6VdmeuYpMkyoiLkG3dDHb6Oz+V93prl9tl+Uk/nIao3Pww
	a+NdlkeQz2Fn4uAY0+cSQbeMZB66FV4D9c4q4uMbJtx161MqNzrpo2h/Cwzp4+HO1jM/uG
	9uirW2tZeh35V2/jgb+73x4y97LBXv0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-suTpbEUCPE-TiCjwMXo70w-1; Thu, 06 Mar 2025 04:01:00 -0500
X-MC-Unique: suTpbEUCPE-TiCjwMXo70w-1
X-Mimecast-MFC-AGG-ID: suTpbEUCPE-TiCjwMXo70w_1741251659
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-438e180821aso1516085e9.1
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 01:01:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741251659; x=1741856459;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pY2indv9DvyBZQJoUjIBXHffPxVcc0dm+eOOwrLDR6k=;
        b=BLvfFRznWyJDPZjaNolAxRIhz9rM7yUxT+OpAvoy0ir94w/NOv/qWUNkZ2A5HInW6w
         7UslepGBJuwm8izjBgIbWWTpntogvVJR4cuZNS2ge386A6DT3O04ivMeDHFmpW+sg8X8
         oKoXLMWBwJXeDv4g4pdhjioUX953FeKNswKqJG6ZwXFNz3V0UGfYWKaP3LGWCyL8EnVG
         Pxcgwchcri5e8bWbApvTlEuv/F3UDOic5DP3kztAEO+kNExx5ioVyw+K5Bqesd0j5J5g
         /14CcWzR/f6cFS+C8yGqdbmCONuNXrjaKa4p6rSPV7CY+tEPLMF4r1r03Pp4NUmnTYTJ
         8hbg==
X-Forwarded-Encrypted: i=1; AJvYcCXYP03+GvhE7lljqtGpuSdtZaN2DI5/6hkq/PEA3Xu1nkaAxibe3KtRFhdjOnRiP2qPx4w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0Tl0AiXruaVSjzyAtEvoD3iIGxV06qCcEigzbZ7brxFs0+gsA
	Uc8f6m4YBa0RamECyV1liFyYjnxTpFxwOfrHjCWwcSG1ZsGUzQUoMOS2IWgi6UPndwdWPue7hjh
	lLbTyqUTQagveG+fgB77dN8NLNu6A+qBFNbWqqViVvd3rn/As5Q==
X-Gm-Gg: ASbGncto+UuIfXI/U0M2yn5sKwt+yjKCi8oU+ffuxs3tgqw+PmX6W+cHLNDS/k8JnKX
	VrdgTJZP5SroRdvE8ZD10VyVAeTFKBQOubq0UGZJwZGlVkRS8S+JgMcQI/xY1tEboH5ZFcHNtt6
	1winXsJ8hNVuFWysbM5Sj/Q8B9DtHsLfrUutaKxlr0CR6O47i+eblFdFk6eyLUQtN92NWMKRvwu
	FXcHw9W11FTFPj8+6l4zXSZ6W4+cyn5w6+oGOKxpBFdWe0cCVsLkUAjTXOR44fNsc1/yH8AgKZs
	aXXKWf7OkZJca03kbxkkVZ3/Qw7QCBbnMnk11dpUBalznNA=
X-Received: by 2002:a05:600c:35d4:b0:439:9f42:c137 with SMTP id 5b1f17b1804b1-43bd298f9fbmr59118335e9.11.1741251659394;
        Thu, 06 Mar 2025 01:00:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG2NgeNdUnGXbD+op2sXJsB/SN3xlXNlbIFOWQaCFoi1UgYgSk1r/tZKHyzVnT9tI/XhwhMWA==
X-Received: by 2002:a05:600c:35d4:b0:439:9f42:c137 with SMTP id 5b1f17b1804b1-43bd298f9fbmr59118055e9.11.1741251659046;
        Thu, 06 Mar 2025 01:00:59 -0800 (PST)
Received: from [192.168.0.7] (ip-109-42-51-231.web.vodafone.de. [109.42.51.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bdd948cd0sm12787105e9.38.2025.03.06.01.00.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 01:00:58 -0800 (PST)
Message-ID: <a10378eb-4bff-488c-86f7-b4fec20feb6a@redhat.com>
Date: Thu, 6 Mar 2025 10:00:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC kvm-unit-tests PATCH] lib: Use __ASSEMBLER__ instead of
 __ASSEMBLY__
To: Sean Christopherson <seanjc@google.com>,
 Andrew Jones <andrew.jones@linux.dev>, Laurent Vivier <lvivier@redhat.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org
References: <20250222014526.2302653-1-seanjc@google.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250222014526.2302653-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/02/2025 02.45, Sean Christopherson wrote:
> Convert all non-x86 #ifdefs from __ASSEMBLY__ to __ASSEMBLER__, and remove
> all manual __ASSEMBLY__ #defines.  __ASSEMBLY_ was inherited blindly from
> the Linux kernel, and must be manually defined, e.g. through build rules
> or with the aforementioned explicit #defines in assembly code.
> 
> __ASSEMBLER__ on the other hand is automatically defined by the compiler
> when preprocessing assembly, i.e. doesn't require manually #defines for
> the code to function correctly.
> 
> Ignore x86, as x86 doesn't actually rely on __ASSEMBLY__ at the moment,
> and is undergoing a parallel cleanup.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> Completely untested.  This is essentially a "rage" patch after spending
> way, way too much time trying to understand why I couldn't include some
> __ASSEMBLY__ protected headers in x86 assembly files.

Thanks, applied (after fixing the spot that Andrew mentioned and another one 
that has been merged in between)!

BTW, do you happen to know why the kernel uses __ASSEMBLY__ and not 
__ASSEMBLER__? Just grown historically, or is there a real reason?

  Thomas


