Return-Path: <kvm+bounces-8407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FC0684F159
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 09:28:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A9E0B2298C
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 08:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E03AF65BDE;
	Fri,  9 Feb 2024 08:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BJJ1KyiO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3898493
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 08:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707467310; cv=none; b=jYkr6GaKFmPWR4+d9AkdGQ7OKEI70sTRzZizCxH3kWKsDsAhmlIgZ7kT+4dRyKOUxjGgYaQqYUjYSh7TEUW5plwJjR6nkblofCnZPAnmh7yzzLIEPdmvNdfI1SjXfH1Wow399qp/7FoYRCnjsRS5ZoQIouZzKuSHSD7UApFXdaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707467310; c=relaxed/simple;
	bh=3HreAf3C7WSTTW6o9UNHFC8JLdzrORRUrztXIvGrHdY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oCmzMWSy+8p+ni/Ot47lR3iDqHy61OyAAIO9pcU50iRg2oJhrkTUnX4K9x3B12OMEAIebTcmsBl//Pd29wxszz+sVd7baRRs9+62ee/4Cd9X5MvYItxDycTz/3vi+n6EHKCDzgCP8sNMyU6e5yGIl7NUXZWPptKMDHcs4JOP9VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BJJ1KyiO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707467307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lSIosa7H9Vqr6g6wkjLttbFme+deNKcmttLyp+MsKjU=;
	b=BJJ1KyiOg9hBpniBEZQeJppk5yBbhCX9ehCoZI4qIuEzyXJzZiwezAwovdDR9vG/TfzxDf
	gZG/IosvtcINhhT8wvcZSP3ewCCZyjJiCtf7SB/gorU3h9kBI3VLgZFR4tswPJ/QsAIBBU
	EdZbwjdcupb6fA+IkSdmCdZt7ZLMaJU=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-iC1QLjrSN0-cM73u5Yfy8A-1; Fri, 09 Feb 2024 03:28:25 -0500
X-MC-Unique: iC1QLjrSN0-cM73u5Yfy8A-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5116d7eb706so615447e87.1
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 00:28:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707467304; x=1708072104;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lSIosa7H9Vqr6g6wkjLttbFme+deNKcmttLyp+MsKjU=;
        b=PCEFzxY8HizRU2j6Q9BJGnb8qV4JQGX2f2HTmfh8VKeUVAvGGysrbTF2ga12VJDXfx
         50zo3n2PIw39F19azpQ9LH/dcXgLcspbW2QhdBGj0Y8XWBgoMW7WpRyrqmTOwL0/Bx1B
         ZpUd1JbDYM3/TxRT/drV5ZBapqT5qMvOwefvUt9o++DtP0IJz/9ELF05aQySkDxE5ZcX
         aWao3lKnnEOo275sSeb2Um906tXxEBhQVGaow61PGyu9vE5XYU7JG6ew9n5MoOhxHfTo
         /VEKuTazbj0+RMbVHX9bzNbGKsJyw16ifkL1eQw7jDLyorm0V5uyZDfmk5PNYhynhvpM
         mbNg==
X-Gm-Message-State: AOJu0YzM3yOE88un1IMM2JQKRFE0c/OnR5H7VwnJaiO2xbJZsvbdOEAr
	51cHun0/duS3Sssnycc9Ylp7SzrK6XZsw8QD3FmKeP1+R7SupROfMXypKr3Icrzlkl2o3bMebwN
	RPDeK0NfexRYRdY+mp/HBcIwRuibm4BvACvrDjW01R+H0izVbYA==
X-Received: by 2002:a19:8c50:0:b0:511:5361:20df with SMTP id i16-20020a198c50000000b00511536120dfmr532243lfj.13.1707467304489;
        Fri, 09 Feb 2024 00:28:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH4iC+FRipMyVJYsUFGfBqVSr7OvTucmAa52sfLjON5ya4vVilp+U93Cecd2K9MevakvwHq5Q==
X-Received: by 2002:a19:8c50:0:b0:511:5361:20df with SMTP id i16-20020a198c50000000b00511536120dfmr532225lfj.13.1707467304116;
        Fri, 09 Feb 2024 00:28:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVltiJ29BtpoUYrPf1SZB45utAeCwTbqwI56ds2Aa8EuZgPms0LwddB+C5/ltorHPajgsPjWHznwdj56pQ6nu24/cSU0eXH1BGFKlLpjR6rvBc3CaDz7fawO3HG0y/7Gj1kRsXQceUY8H9DTHj7+R44o5x/+wAiDlcMMgMVxyLdLPEAfjjAlfUUxE++n5R8EJIaBBcUd/sybg4tB7HpCx0xfR7A3QZtmcA4CGK+PO2aZ3a4C3MTk7GaNjIS70jqUB8QQi/QEZtTvXyQPH2SeBlVAk3amng9fA+1lWXwUoI8AxAXRBESY/XUYLDZ8hU2RQuaRJyEuWMq21JPhPOlKlAvy0qf8iePnq2dDkTWjkRgl9+vU2u0DhldVHMj2B3GnDXN84fFK6s9RaZwI3YbGQeghRctNDpy3xzctkbPneerKo1h0eN4mdodAM7NkNUCmR5Z9nBofp5yuUCaQgVQg4gzECnx0ypTC+kVRzZq9/hWL3AcB68IavYtB4tow7DLo1gLXWRDd9TcE1hYecDqA1g4uLor
Received: from [192.168.0.9] (ip-109-43-177-145.web.vodafone.de. [109.43.177.145])
        by smtp.gmail.com with ESMTPSA id x21-20020ac24895000000b00511749fec62sm90472lfc.72.2024.02.09.00.28.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 00:28:23 -0800 (PST)
Message-ID: <cf01bf0c-ad31-4bb8-918f-98de47d40d7d@redhat.com>
Date: Fri, 9 Feb 2024 09:28:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 5/8] arch-run: rename migration
 variables
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
 Nico Boehr <nrb@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Marc Hartmayer
 <mhartmay@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, kvmarm@lists.linux.dev,
 kvm-riscv@lists.infradead.org
References: <20240209070141.421569-1-npiggin@gmail.com>
 <20240209070141.421569-6-npiggin@gmail.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240209070141.421569-6-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/02/2024 08.01, Nicholas Piggin wrote:
> Using 1 and 2 for source and destination is confusing, particularly
> now with multiple migrations that flip between them. Do a rename
> pass to tidy things up.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   scripts/arch-run.bash | 115 +++++++++++++++++++++---------------------
>   1 file changed, 58 insertions(+), 57 deletions(-)


Acked-by: Thomas Huth <thuth@redhat.com>


