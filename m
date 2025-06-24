Return-Path: <kvm+bounces-50491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51F96AE66E1
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 15:45:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07CB34A27FD
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 13:45:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AFB229ACC0;
	Tue, 24 Jun 2025 13:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L6qXFziv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5341A288AD;
	Tue, 24 Jun 2025 13:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750772713; cv=none; b=BTWUcWk4EpIWUrnyvCQfVETrYOlytxTHz5x71ySFpYlp38ki2i5jJMiN95FgEegGwylzEw/nzp4JU/RQpXYtOe0c/7yZRV6FZgj1GPn7kLvqfhQ6TLshRVIKUwji+W9SsExhG13xEX9fg7rMnf2AOLh9qxe/TLJPlNnMDVToAlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750772713; c=relaxed/simple;
	bh=NbgHzDUBmwnWmkyYM/rM7TxCssTYLxDcNXZpU2MUuaU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UEwhWRU9w27yrv16WvgWfo1mm38GTNyOU3VUquO4i+qLbdbSuu4n8gNWMbvUHtWNy5yYH4/3hqcxHF4v07o7b4gxCF5WHa2q5/PuvWySNhaUfkFYijBdApgVkMSjfrauBpsrs6T7veNe8ZXKL6OU3PiS7Oo0Tw3EMVOZGxc01PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L6qXFziv; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2360ff7ac1bso3721255ad.3;
        Tue, 24 Jun 2025 06:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750772711; x=1751377511; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hPyjYbs2owAVe++gWy+5tVf+VNEm2obRf5tzZhSqcfE=;
        b=L6qXFzivk3uONwY2T8IPW1UO8465444GeYs9oCtl2bbKExIOePkGXgwsdzkYtacwZb
         F5otCYpxwsaD51Suvm5XdZh9cLtxTHGjTtDF2gQo1EVsMX4rcPcrclaB52lmtUnHde5c
         EYN3GGwrnlzI2z0LTPCqnPBxkpO4ksDHGkgzDTlZNjAyX0chGeXsd+zQYVOZoVfZvfwA
         x7SSuAHP9c4nU+BqqmbFT2owXNZaN0ldTxE7j/iKFueX0q4mMIC6lIzCh6MUjs3ZnVJz
         1Zh7uNPFvlaIHsNxZbjHAHOFxxsxl7Qo+xqIax2azwG+3BBUSGBvsIj1XB9UQOS6JuMT
         6opA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750772711; x=1751377511;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hPyjYbs2owAVe++gWy+5tVf+VNEm2obRf5tzZhSqcfE=;
        b=KL9T7aHQNiiHg1k6/d6keW7zVxQksEDVwTLkQIJRdH36yF7RveOd2rUE1twpI798gG
         ceFsrpvu7JIZDqeDMrg0usOUX3/VkYnI+nv7ZbAjN3nAWM2j/qOcdygxtPNUUyPe+7km
         WA3WSSrg8ev2vG3v2g218K4VnGlmCATE+JOnktHQx6TGd4TdVQF2G9taIBkSzLzhfO6M
         psGr0vC+cEjUWCIAM4pJScJProW408aI3hX8s+VPj/TImrP+/aQkT7rsG/xDrB0Wl1MJ
         w0fpqW1vg8p2kPzoqV3eZ/wzokJw+RSpqqbiXWwMAT+dlgHeDVyanDLHzFUqGd0tmz7J
         sJ8g==
X-Forwarded-Encrypted: i=1; AJvYcCVNsPKgiNgRVGVhreU7CscZ/VAHglrJpPVfRqarQ2wKKYWXo6u/h0sSzLaoCEmhDK/+MC0=@vger.kernel.org, AJvYcCW6OVIFJ7p3QYHXR+jQYjjqg1VUgaOixJADWZfbkr1Us8s9h8h55L9QXhBNhdEjEAQYvHrpowoUvLfd@vger.kernel.org
X-Gm-Message-State: AOJu0Yyl/dudqiT7+DS2z35E5xHgwAyA0ITCJ7LNV4Cfm8Emg5b3rTqm
	gN8sm5RirAZUs2pEQQXO8NYkpb4XA+l5XsJ5CsyqJ5wDsuCWpUtrqF11
X-Gm-Gg: ASbGnctMTHTOkN59IGx9YqIVpXzJHLSTYtz/DlfPCZAzg12MM/YjcUffBd+L+4SFdSy
	7q853LSz5YAzprROD12QIWHlI+Udz1LvTAgB4CGBo5H0dr3cMiRHdQY5CHUWyNTIlthGn1hhSLn
	ylJno/PeL7QtYmcXl08MoEpn9TmbL0hkESqj2eqogpMNxCFQncS6+H/a/DwdJBQEHQkeDaJocFk
	9kmmQv7L3//7J+/0VQq6oDwvISXkJr4GYlbP47wrtFp5Rzx/2t897n973uUOI7hvzDEaj9CVxF3
	g3lIqJ33C/SMObnO74I0fQI9aEHG5lXaf5dhGhS5Jq0fSr8KdfTWQPQwBXiSF09IIxZsLA==
X-Google-Smtp-Source: AGHT+IFF6NvmX1J7jxALkG5GWpXs1/Tdp9Xfdc7JJ1p84XCdCSRFWP6KPDIPM/jXOPCrTFxkVi1ZHw==
X-Received: by 2002:a17:902:f68e:b0:223:65dc:4580 with SMTP id d9443c01a7336-237d9bd103amr239231235ad.52.1750772711364;
        Tue, 24 Jun 2025 06:45:11 -0700 (PDT)
Received: from [192.168.0.150] ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d875382bsm106956305ad.254.2025.06.24.06.45.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 06:45:10 -0700 (PDT)
Message-ID: <f833718d-ea25-4e21-a103-4ee0153ca990@gmail.com>
Date: Tue, 24 Jun 2025 20:45:07 +0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next] Documentation: KVM: fix reference for
 kvm_ppc_resize_hpt and various typos
To: Jonathan Corbet <corbet@lwn.net>, Alok Tiwari <alok.a.tiwari@oracle.com>,
 pbonzini@redhat.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20250623191152.44118-1-alok.a.tiwari@oracle.com>
 <aFniQYHCyi4BKVcs@archie.me> <87jz5171lk.fsf@trenco.lwn.net>
Content-Language: en-US
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <87jz5171lk.fsf@trenco.lwn.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/24/25 19:42, Jonathan Corbet wrote:
> Bagas Sanjaya <bagasdotme@gmail.com> writes:
> 
>> On Mon, Jun 23, 2025 at 12:11:47PM -0700, Alok Tiwari wrote:
>>>   If this ioctl is called when a hash table has already been allocated,
>>>   with a different order from the existing hash table, the existing hash
>>> -table will be freed and a new one allocated.  If this is ioctl is
>>> -called when a hash table has already been allocated of the same order
>>> +table will be freed and a new one allocated. If this ioctl is called
>>> +when a hash table has already been allocated of the same order
>>
>> Two spaces between sentences (just to be consistent), please.
> 
> Spaces after periods are explicitly documented as something we do not
> "correct" or harass our contributors about.  Please, for the Nth time,
> do not add unnecessary friction to the process of improving our
> documentation.
> 

OK, thanks!

-- 
An old man doll... just what I always wanted! - Clara

