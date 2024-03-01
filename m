Return-Path: <kvm+bounces-10633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2306E86E025
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 12:26:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B730B284E98
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 11:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 664616CBE1;
	Fri,  1 Mar 2024 11:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IYxrHid8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2119E20300
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 11:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709292365; cv=none; b=s/5ALFCbLPuaNEPNIoc7KtmiK6z7h5gTP4RE6E9ezDOZp98nNWovhzpiwefyntTZlAfjMCmofxuYoK+6Mg6XqlwFcMEeHpocRSN15lBZQhEFTtk+4xdydR+79hlXGIZjx9y8F6dgv5OG+x9mBaWvcE6gKqbuiNEt5K++xfAlTzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709292365; c=relaxed/simple;
	bh=PUQUEAguC7a4iodr6Z1RP3waTSFcj0XsUi8Jo092jnk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QdJqBMfIlUna1G4/fT3CW4QS+pD4v46vKFsXt8KJBX0XHeHC7SjYAEgi21Qq/A8Mf4ruMEbrB3jqJOCsdl6VocHV6T4+XLa7nYzR9PhrdEoD7tIWtHMpG4jca05njFHCwijRcFMpbofjrO38ofA+76n3ZzuQ0U6cdJbJgpciGC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IYxrHid8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709292362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=F99ZBpwcts994IwUQySStogjROuvdQA8mnKDnTZ7VIQ=;
	b=IYxrHid8/x1HP9MZydwNsvgMcbpkmqO7dS1wNBfaM8IBfaBSokbrhrBvemmt9p8IbAKaD4
	R1kDvM9EWmfq1BOjkaiPkeATaIJl1qeiw3sIKLwcduDDXzmQEvtIXlVyGm2aw3wdxWJ+xE
	FWhRuiOVcD4myuqG/oTx8p9kRj9gm7w=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-KMkweal0MjOiQiRkxfG3Xg-1; Fri, 01 Mar 2024 06:26:01 -0500
X-MC-Unique: KMkweal0MjOiQiRkxfG3Xg-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-42ea49780c1so24570971cf.2
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 03:26:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709292361; x=1709897161;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F99ZBpwcts994IwUQySStogjROuvdQA8mnKDnTZ7VIQ=;
        b=IyCCr5oSLOdx91LFw25VVPKEsiD4OnXW5aJEsJy+Fw1t25eqK4O5LcvNR82HuOmNRS
         3HHWwdWA0m1NuZhLCIXh1zm3K1larhglv3Bs4sLP/cYaq9UFbPru7IPfTxbh3OjsoJkp
         1gNp9uFwOs6DDmTO/Ahh2WZzBeC0We9XOxAXGR40c4m5KhdCgPLbdBEkb/3SLy8OQkDY
         DW3bPiBJG5eZjos3N+RppC1ogW+R8nT8K50EW1IZeR/eilyWAQwxv/ARlNU4/UaRUe9g
         ZdNMIscasA7Sj3gGBR5sB6u3fNMbjzs3fRssIB1Qh/gmKEETZD9Ja/v6xIH5P3XEtyyD
         xNVA==
X-Forwarded-Encrypted: i=1; AJvYcCW/8l8Rjdjm4Pv7QwCwGmrixIZrHfEfJ1SRz1XnlCAsgLtmJRf/5KRUhu9ciABLqdrm0m+NlMfdo9jrFLBNTM1asnau
X-Gm-Message-State: AOJu0YwVfzpIUN/IZIlcHqiEqkX9q/qYp9FHRj4eJoE8AjCEFUHZ37oD
	ftn6dHXYFG5QvGGmz1lJ6Jh7kZj2OU8zqwIW1RodGYY4/QXzGTUaxlK8rm89Yayc30AQbGQU/sp
	eKO2wYUA4zol7mm+mnUhTqYzNC8TnkGNV4LyBbdIxh5USw81PQA==
X-Received: by 2002:a05:622a:190c:b0:42e:b2fa:80cc with SMTP id w12-20020a05622a190c00b0042eb2fa80ccmr1484908qtc.56.1709292361039;
        Fri, 01 Mar 2024 03:26:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHbQCdB9jRZGAsNwj3H5NlUMm3A1jQlDhe6tfyELOMd7VcIMNwpobakiwetJJebgSUBT6GSyQ==
X-Received: by 2002:a05:622a:190c:b0:42e:b2fa:80cc with SMTP id w12-20020a05622a190c00b0042eb2fa80ccmr1484891qtc.56.1709292360786;
        Fri, 01 Mar 2024 03:26:00 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-133.web.vodafone.de. [109.43.178.133])
        by smtp.gmail.com with ESMTPSA id j19-20020ac85c53000000b0042e7c95c5d6sm1605442qtj.18.2024.03.01.03.25.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 03:26:00 -0800 (PST)
Message-ID: <e38eec04-5d2d-4027-85b8-91d072306d4f@redhat.com>
Date: Fri, 1 Mar 2024 12:25:56 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 08/32] powerpc/sprs: Avoid taking PMU
 interrupts caused by register fuzzing
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-9-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240226101218.1472843-9-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/02/2024 11.11, Nicholas Piggin wrote:
> Storing certain values in MMCR0 can cause PMU interrupts when msleep
> enables MSR[EE], and this crashes the test. Freeze the PMU counters
> and clear any PMU exception before calling msleep.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   lib/powerpc/asm/reg.h |  4 ++++
>   powerpc/sprs.c        | 17 +++++++++++------
>   2 files changed, 15 insertions(+), 6 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>


