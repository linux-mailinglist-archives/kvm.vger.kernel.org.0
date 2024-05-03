Return-Path: <kvm+bounces-16485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 886398BA728
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 08:35:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7EC128257F
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 06:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABA1714658F;
	Fri,  3 May 2024 06:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cP655uGs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7361F614
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 06:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714718115; cv=none; b=NtTEmlyEm72FNEIlXEIpLZaV5pp1FirQpxQr2scTBuqQp63UmNSan62HmiW65+I/vQEOKPqjQbLtossgVuSQT18RvHpijgNUcOLo5hdqRCrTfqjlDT6hKly6xqLjav3uYbuzYWW85wQSXsOpWjsUm3uwEqO/8DSCDYUuQ3HDftc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714718115; c=relaxed/simple;
	bh=LqwwyCERY8OkvxiiXh2EXX+tvE3h0No58Fb/mOgdW+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JKcnHXFNYDoLjrJLbZIYZfAk+ucvOUep/aJaKp9LxeYzzuUebANe5+xOgsBmrAZ04ceUPq9qKZj/d3j+CJoa2S8u6XKF5abqiG+MwBSp9XYzlfoBC/zGFs0yvZbaqak+FCdd6JWfFjMQkweJbDCX61AcvuYWOGVzpuT6mz/i3U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cP655uGs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714718113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=esVujG4oIhQrEcm/O6iebU5lC8d05HhTaZJi0SEv/K4=;
	b=cP655uGsYVwR0K8CsjWvGZjnK0x3zCaxbm8wmxyjeptmUmqV/Vmo0008EJmMudK0wnPupK
	8I/aJ0kkO7s3gGJMkhA9J9TUmZkjTLEW4sPC0utanDQOZMrqdWR7HUZ9klkBl10SBA76AY
	YMvLws73B7UjF6Ew9n05i7jhzaxKsrU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-X5QSEGhTPUWKRT2w_1Ve5g-1; Fri, 03 May 2024 02:35:10 -0400
X-MC-Unique: X5QSEGhTPUWKRT2w_1Ve5g-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4365ab4c663so80518481cf.0
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 23:35:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714718110; x=1715322910;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=esVujG4oIhQrEcm/O6iebU5lC8d05HhTaZJi0SEv/K4=;
        b=lP+fvLm/gGAjR5i/uTbqYcTeY9o4ncOF8RA2BryuMW6ZKq/E6Xi6uDUYk5fwr0nWaQ
         H/rOudpjfnq5BH5qPQIXgIxyBMvtTJy4IoO5ARisgAQMfat1fPen+skRuMDgu3TelvrD
         JVpkzCHxpXsoXil2yn90A7fejOpamc8Ow4qgjJSzZoJRVUX5mWiFdPXiqixsgbO2r8Vn
         N8s+e34+f+EtVsb5QiOO9ByjKYJllNvxIPUk+aPzvbq+2cGv9F08kNj9fMdem77yzsfc
         /HX1YBP+Tv2KZluYHLPdZ7eCskXDgasUGGWMBJiTTjF0i4f+b6UXwqCtYtRnvctCgCIG
         IC1w==
X-Gm-Message-State: AOJu0YzcUeknbiRSQbD2N98SuoV/poCOQrtn8FEYBc4/70bCZXy3ZNAw
	iB2D/EPYy3Ut8fvzD6aqKUdnAtOiGOMvYQmG+u06FQ5j7gvjidJwuOZxwscthkXJVSVnWO8ExaR
	4fSVstSixyO4ebwtg40syWViCjSI35DE34u9NF6rn0Up4YpNf4g==
X-Received: by 2002:a05:622a:64e:b0:43a:dc29:a219 with SMTP id a14-20020a05622a064e00b0043adc29a219mr1829134qtb.2.1714718110470;
        Thu, 02 May 2024 23:35:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFBwJMzszwMrOyWBGEvWcj7L8f6jc3WnErhE1iLTDHj0A5t8mdbgsUAOQGI/FzHj0uoHtlR5Q==
X-Received: by 2002:a05:622a:64e:b0:43a:dc29:a219 with SMTP id a14-20020a05622a064e00b0043adc29a219mr1829118qtb.2.1714718110040;
        Thu, 02 May 2024 23:35:10 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-34.web.vodafone.de. [109.43.179.34])
        by smtp.gmail.com with ESMTPSA id z6-20020a05622a124600b0043781985244sm1245696qtx.59.2024.05.02.23.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 23:35:09 -0700 (PDT)
Message-ID: <252ef6c6-e0e1-4eaa-bf4a-b678e4e8b190@redhat.com>
Date: Fri, 3 May 2024 08:35:07 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 0/2] shellcheck: post-merge fixups
To: Nicholas Piggin <npiggin@gmail.com>, Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org
References: <20240503052510.968229-1-npiggin@gmail.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240503052510.968229-1-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/05/2024 07.25, Nicholas Piggin wrote:
> Thomas noticed a couple of issues after merge (did you report at
> least one before merge and I didn't notice? -- apologies if yes).

No worries, I just started testing at the same time as Drew pushed the 
patches to the master branch.

> Thanks,
> Nick
> 
> Nicholas Piggin (2):
>    shellcheck: Fix shellcheck target with out of tree build
>    shellcheck: Suppress SC2209 quoting warning in config.mak
> 
>   Makefile  | 2 +-
>   configure | 2 ++
>   2 files changed, 3 insertions(+), 1 deletion(-)

Thanks! Fixes applied.

  Thomas



