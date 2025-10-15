Return-Path: <kvm+bounces-60061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A3ADBDC76F
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 06:30:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AFFB34EDE45
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 04:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64DC02F7459;
	Wed, 15 Oct 2025 04:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="SVqt5/PX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB407272E4E
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 04:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760502599; cv=none; b=ruB6YXKMVhtlMAGgqECy/3ohWe85wLhtyLtFNewb58D708XqUXTeqin/m90DlsKfdSiSZXqYT4Rm8C8sgwKrLT/cvahgam9RwSpZQNdVniCtgYIVlEN9d9h3LDXcxZN2g2lmj2ipq1MYtFhJQ9GujU88VaqyDn+fQQ6by1XA6ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760502599; c=relaxed/simple;
	bh=M2zDHCCYWUdnjwe5pOHg2byeFEHyefwFxZynektqzvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oSr/nBAF2WNia5XzV/A37eFBE+opWCO/vMs+o8J/YaYl0VUBil4gsNj/OlJMGAPs2aaS51nEhqUYj3fDVsiTx7WTuPosmhcLLif3d2tnanA8laZxpuYJARfg3EG09YWdPWSnSF1kW5wi+LV7tCthgjpb0oCgSqFsNpcVMibdfe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=SVqt5/PX; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-856701dc22aso880333185a.3
        for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 21:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1760502596; x=1761107396; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=eugTF4A8DuXM7Fbi+JHs27SgHYAot9yWnzezvTXV2Mg=;
        b=SVqt5/PXCDgsFpBmQD9AcLxQz0TybbOkp43vsUKG//mlrRzVTSQ72ctJIPHT8pqp0v
         GAsr1cfZcC1kUnedtfCsT/6kWjBXqtI7eNEk2ezvW6nYtRUe+BG0pW3gqfRzhto2sMaJ
         WqGp1bCtfNwelZYAB/HUCgzMPvKYy6PEw5+yEh1hTRBEdJ8XOp9uVY3nRDpNUJJRLmHv
         0WyPqUcAqlruB1JbLR3Tv/AGJ2UH8nl1XMAwgi8OUAdceoaHtBYACOEX192PN/BlVX6h
         Evo6jRbEvDsoLJJHfS0kOTd85hI9So7ccW6nlQC41BAxnCwuf3MNe/Z8MntaopUEir+8
         Ugxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760502596; x=1761107396;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eugTF4A8DuXM7Fbi+JHs27SgHYAot9yWnzezvTXV2Mg=;
        b=rNcBMUSvF4fOfgaecjdiX3S3waGBiwrQsG5Szf/RYUhb712H+g1XiyPqTEtbx9AN/i
         +HhQnsMtsGb6jt1LZsgcqfOICfU1MlCSaw4yaZagH7ZrFvvEGkkUNpeaMbCbwi55jv4Z
         N3QISi3HqkNpEcu60kvLF0if8aGl2aFYe/dOASLRehBLKsYSvefoKdJXTXVtYJjVQ64R
         JNJR7hKQLxrQR7lqITco3hAaCxriFIjSLmx5CVc2Qh9KFYOWTxWKWsGcXzm7+Bupk7uj
         DkSuTEHIvgieW7kdAlpto+kpRuTEo0b9ge0Umnfl78MIGDaJH6I466GK4dDVs0ojpLHP
         nxCA==
X-Gm-Message-State: AOJu0YziSVt5fhANq+MN3lOY7zSTvlGnp2CcbG4RzOXAs76PG6IBg5oO
	wRzZZIp2nbZEV84qoZ4DAZVuLlhtkwG8FxwOupBFD1WDHdz6llH6jl1rkqvrMmbF8sU=
X-Gm-Gg: ASbGncsVCocWKqluJBBgAM64YD8RKbQtqqFzu46Ir8MpbnnPhYD+RUzi/Jp7YHPZQkE
	vNn34YjzKs0Xt2JPFOrHkU4UUX6AsTtE6DQl5Kq+3ISvr0MfO9hQ0hTh2gNFyWVZDBrllq528+J
	rdgyG0D1Cb0MYSErQ8L5OiYWA/I5xG8IDxiYJammONhwnLkncyiX9OLcIEBrddSg0uv5FQtt2Dj
	UhPoDGnbOyz6DPiVApovY03zKP3zwxGMmZM+dHUQtcYW/zzubaIHfRhkMyf6Petb/UhvUR4He0a
	Thrd3IR+iCguB45V0n/B6QtZIHl3qpfSRX4nwOTc/tstzvttjar+eNBUKNd7XQzZsVjq51IlUu4
	qbmcwI/ERtLPq+6i1YH6mR4QJvoHqcaZsHDlbcqAS7H6nKt2o25F2+HCfGU0AgPdu9vU+ZYUjsC
	G8PgJeqhYD5CQWrRQ2tDFyW4lVoMGyebprNH3W5nOKpDZe9ssm+ZMiS7T25DW54lNQ2K8NSyzWH
	pKg
X-Google-Smtp-Source: AGHT+IFJd4uVCr8zwPTMX8b4kvHGDz0d4o8PJEWUm4bOEud7KXEJv2PzL4AeMxoTMDxZV2d+d+cRbw==
X-Received: by 2002:a05:620a:4492:b0:860:a484:e341 with SMTP id af79cd13be357-8834fe99256mr4017450285a.17.1760502596460;
        Tue, 14 Oct 2025 21:29:56 -0700 (PDT)
Received: from ?IPV6:2003:fa:af00:da00:8e63:e663:d61a:1504? (p200300faaf00da008e63e663d61a1504.dip0.t-ipconnect.de. [2003:fa:af00:da00:8e63:e663:d61a:1504])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8849f9ae428sm1336755785a.16.2025.10.14.21.29.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 21:29:56 -0700 (PDT)
Message-ID: <87f3f6c6-b44c-430f-9768-321d84f9bf65@grsecurity.net>
Date: Wed, 15 Oct 2025 06:29:54 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/eventinj: Use global asm label for nested NMI IP
 address verification
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
References: <20250915144936.113996-1-chao.gao@intel.com>
 <20250915144936.113996-2-chao.gao@intel.com>
 <a8c4d415-a23b-46f6-89fc-28facaba0a44@grsecurity.net>
 <aO79InNMh/5tp3ih@intel.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <aO79InNMh/5tp3ih@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/15/25 03:47, Chao Gao wrote:
> On Tue, Sep 16, 2025 at 12:10:46PM +0200, Mathias Krause wrote:
>> Am 15.09.25 um 16:49 schrieb Chao Gao:
>>> [...]
>>
>> This change basically eliminates the need for the global
>> 'ip_after_iret', it can be local to nmi_iret_isr() now.
> 
> You meant 'iret_stack', right? if so, sure, I will make it local to
> nmi_iret_isr().

Bleh, sure. Sorry for the confusion.

