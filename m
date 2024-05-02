Return-Path: <kvm+bounces-16400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 913B08B9666
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 10:23:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9F681C2155E
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 08:23:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA17340BF5;
	Thu,  2 May 2024 08:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SPUwWpr9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F58540879
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 08:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714638210; cv=none; b=qn8XX2AdcXz80OqNpSOQX6ttx3ae08RBPfKHEpkCeEgsqFYnuAYVH/EGdylKGh2ETGbACUCbyY0ltwzwnQzzDWkW3VUVA/ptXRrBLdOtAvNOKfR5BNuyExbv7znldLG0qoOgkes2oleCQKZ2Iggto6Mr5wiAZzaXfwAQhQ+WXPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714638210; c=relaxed/simple;
	bh=ZE+ngAnTCcsMSeiqF7e9PkuEtQy1o+nImccEUeE4khQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QGrN9JDDhIjQOR2rDFc5tu4Jbiu6spaZXNhFNaaHQlzw0dlFItLJ+Vnroc73Sb3xZea28klxrAoMSbTOFQvgue37V1kxlDnB/E3cRhgE2T44M5Y5JijwnObdJWdBSVo73nGp+wr46mfJlJ0nWP47gmVOqe7YCcfnl+XsjsNra9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SPUwWpr9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714638207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w5km4/BthBCY3+a3KkxvTt8Ci9HCPSEYsYp2lASqktk=;
	b=SPUwWpr9Va0kUWv28ib3Lz4l3pGcfPwGOsNo4Q1xN8gbBktcCNFokjQFpDCwgFxvphD4eg
	OdVuvsurCV7uk6Thb0NY8vpV1PXIRM1WNLN8ofQVq3nZz0vFdneRy6T14qVMKHStb8LIgh
	DnrILrRmS0EP2DyZSCirpaUbXEmvuOk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-yqAyGfNxOYCpmZGvAVaf-g-1; Thu, 02 May 2024 04:23:25 -0400
X-MC-Unique: yqAyGfNxOYCpmZGvAVaf-g-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4167351545cso53863535e9.1
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 01:23:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714638204; x=1715243004;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w5km4/BthBCY3+a3KkxvTt8Ci9HCPSEYsYp2lASqktk=;
        b=mxixu13pYB6R90PTSdmuiE8r4wt3SjYdTbXxJl2VHJ4SIihQjQCp1hKPAhvmG+2gC3
         ccOYyd1+dXX38rrnJOct3b5PZ/EZddkTFng7Z9lBI99ntlirUMkDB1aX0rpjT6HAd6tS
         uWm/8PbfZsrjS3UFPm5r2UWVIQAvZR3nC80txfn7mfB0bHIDFfASHxxo8ntYdL3f/Aah
         D5SgZZf+D5s8CouRkyo3ZWEJ+OvKRCXHy3BVm0UYRzzQMr89OxZN/+fg1Aa1haWgdWAD
         8mxU73XOGqqRwSaezcN0DaR6k938NFMvJk8Gix4iRA57FSFB47tw3hAm+4gbaM9TXyCK
         JTRQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6T+8Fo6jpyHJJQuG1bMCXFKOeXPCYllJaMGiWEqEDxa//mWo9/7E+ncXvwDdsfO3WXoyIzY2xwKFdm5ysliH2gBGO
X-Gm-Message-State: AOJu0YzLDzBWVEqLnOX1kvESB0RAepoIG00BkZZz2DrZ3qLjzhF5VlfQ
	GtT1KiE5whdfmOMeSG0+xwLHZklQQAGc+w2Kbku5RrxmhkNqYHM+T8kdpuWRTq8ewmVZz9vf1o/
	039ISMxcpqVKllkFg0wYJiSClQPOldRpy839WyO9S76qOuGhjTg==
X-Received: by 2002:a05:600c:3d0a:b0:418:e7b6:21de with SMTP id bh10-20020a05600c3d0a00b00418e7b621demr3971470wmb.23.1714638204781;
        Thu, 02 May 2024 01:23:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPgGlTEo2U9DPytMcpxxfhGvFdTayJOWEviyctdTbnI07tu/xfP/RLwUzgzjLL8wvtBjYeCQ==
X-Received: by 2002:a05:600c:3d0a:b0:418:e7b6:21de with SMTP id bh10-20020a05600c3d0a00b00418e7b621demr3971445wmb.23.1714638204428;
        Thu, 02 May 2024 01:23:24 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-34.web.vodafone.de. [109.43.179.34])
        by smtp.gmail.com with ESMTPSA id bd13-20020a05600c1f0d00b0041c012ca327sm1083150wmb.45.2024.05.02.01.23.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 01:23:24 -0700 (PDT)
Message-ID: <2be99a78-878c-4819-8c42-1b795019af2f@redhat.com>
Date: Thu, 2 May 2024 10:23:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 0/5] add shellcheck support
To: Nicholas Piggin <npiggin@gmail.com>, Andrew Jones <andrew.jones@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, =?UTF-8?Q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 David Woodhouse <dwmw@amazon.co.uk>, Ricardo Koller <ricarkol@google.com>,
 rminmin <renmm6@chinaunicom.cn>, Gavin Shan <gshan@redhat.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org
References: <20240501112938.931452-1-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240501112938.931452-1-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/05/2024 13.29, Nicholas Piggin wrote:
> This is based on upstream directly now, not ahead of the powerpc
> series.

Thanks! ... maybe you could also rebase the powerpc series on this now? (I 
haven't forgotten about it, just did not find enough spare time for more 
reviewing yet)

> Since v2:
> - Rebased to upstream with some patches merged.
> - Just a few comment typos and small issues (e.g., quoting
>    `make shellcheck` in docs) that people picked up from the
>    last round.

When I now run "make shellcheck", I'm still getting an error:

In config.mak line 16:
AR=ar
^-- SC2209 (warning): Use var=$(command) to assign output (or quote to 
assign string).

Not sure why it's complaining about "ar" but not about the other lines in there?

Also, it only seems to work for in-tree builds. If I run it from an 
out-of-tree build directory, I get:

*/efi/run: */efi/run: openBinaryFile: does not exist (No such file or directory)

  Thomas


