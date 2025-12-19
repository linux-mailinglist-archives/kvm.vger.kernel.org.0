Return-Path: <kvm+bounces-66314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C5E75CCF146
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 10:06:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C55AA304A7E4
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 09:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E3932E7622;
	Fri, 19 Dec 2025 09:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DvoYspIx";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="N2C0Ay8i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D70B2D1914
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 09:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766135185; cv=none; b=Q1UL2GC9DxV3zB1yrjhd6Y4cPEEY9RVktv8Sw46V8PksmzdPo5fPsgFmfILGHAybULnfk58WEhffKAT6e3etutFySRXFwrJvjIEPNS0GvrjlEDxEK0vzXNrc1AkF+MM9zF78FMexQhiH/B4iKM8/eVX6LQr944c+RsREuKko/i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766135185; c=relaxed/simple;
	bh=Ya983u4axH6kjlKeYBWtPpboTZW33y5xeVr4MOP0TRA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Eas4Tn/QA6OyxGA7DsfuAwxpAzq9rTsIIpdUnaxtKQiabvNH5epjiizSEdRSOsFETAzz1sdTkZW6w1yoVvbnxZwr9Oue9FUjt9x0WAz9sBNOJschsyc/AJ30gKmjJDG96t1KS7GCcBW+jDmHADE7oB0jHvnsRiZue+6FIUbNFvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DvoYspIx; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=N2C0Ay8i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766135181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uEJJ3ZBJInAIh15iKCZRVqfAs4YnUHwyNO2S/KWdSaM=;
	b=DvoYspIxx7whvLsOvRUlWLraKaTJf74XQZvts/1Q6/Z1gg8Lc470FRlHXPUJWNauZgPoUE
	v7M0xigBeW0muY5A7Fnzdy7m530lsjJdhSlQSuAy/wXf4hh3nbR3IYTyBOn9u/E3aqpOUz
	FFVz/gpjQjXknU3QBY28MAQt4uS729U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-nr3AxtwtPWeN0uKppc-b3A-1; Fri, 19 Dec 2025 04:06:20 -0500
X-MC-Unique: nr3AxtwtPWeN0uKppc-b3A-1
X-Mimecast-MFC-AGG-ID: nr3AxtwtPWeN0uKppc-b3A_1766135179
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477964c22e0so11612345e9.0
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 01:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766135179; x=1766739979; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uEJJ3ZBJInAIh15iKCZRVqfAs4YnUHwyNO2S/KWdSaM=;
        b=N2C0Ay8iFl+7oTUqHvmLPjU7UBmdN/bFA7DZqCeUaZunitNVyo7pGUsH3zOkqNTuMi
         4r9U+g6DkAX0MmKadMDyfyEVoAgRagUPZ2uU8Hke1bMqqX9Trz0/XOo8aTNr8q7ln93n
         68BhAhoRGtbi9iWSZwo6bs+bdH6Jt++JG7IoD/T5m2lZML4Nm52NKRoAoMyHjXCSpSPk
         H+jyYlLD5Oyhzy3Ma04xL4iJoeVRByhsuY+UhGaMrT5FOIbY+90SS1EvbNKsIxq6KJgS
         0sKZwVb4CWnBgNM6RgiCE7Auyx+Enu1u9rLNqtayVmrpGRB90XRchqrFtQakNx4dIpXj
         f6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766135179; x=1766739979;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uEJJ3ZBJInAIh15iKCZRVqfAs4YnUHwyNO2S/KWdSaM=;
        b=SS6YH/LE9tVpog46QDRwn6ydKy1gJiZENzJmh6hyH2n9gojJm+bJWzKzRT0dbDNXfJ
         DjALkPdfM70w/gWrD5C3BNKkoZ8GIneqY6GXtGW6QNCPDsWVROIFO0ktjQE4alWhorCB
         RaZ12DaDs8g5QwDu1DDSqPZeU6kfhOUck+KODvgvPsybWOrwZls5/RBP7ZIDFQDQpKs5
         hnu9wxfXktn6wZPbZbnI3Cs8WQwqD2h/xRI12UfFQGCJTvggFNLBFKR+p5mN7F8eIGlM
         bb4Sm9Gz958/s3yiGtdbblD4fhHFGGoVDvjfxXgXlygHhB1SfSBuT7X9qiRdxoJVezoF
         Wpeg==
X-Forwarded-Encrypted: i=1; AJvYcCWhjG8e3foAP6KDIsvVxiZLViJs7KzQbD+kQnwJ5bnfpfprLuFDL0O9EXfMjPAvEROJAlM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9E/tkTzw1E2N3pxvaMEQ1UNSSzzrfGxMCjikYxGTXjbr95mmd
	+s4zEsUIKzU8SMIdWfkZFM/jQp5vWpR3KjMfc+oX07/tIln78IYMj0NvseeU6f+Ut+ehjOAK5A8
	q6arDa3UTwYzrCz0+Qm1GlE5ckEdWZ1HaQ3AIRSFgE1Eq2dGGpKCc/g==
X-Gm-Gg: AY/fxX6iLKE26i0MGwF/SHlc7ijZ1eox+zHyruIpKuknZelpLziWAzm3wiNvmhlg3m9
	HbkV1t7jK9D+wRq/a7IAplkfPTXlxPHWwQALI7KOHxtUwF/9ELQ8xc+wb/dzkT6JcicgY4/aEeq
	euVEhgnXVkKAFX5FLFhWUMFD3laD0a8nNqMj4GfKOPern7VAxNUtaSBmHtv0U6hYPI2tVumkeCO
	Wv3QMyNKz32I7G3Yw5oKxre+vdTzMizNS0edF28EAB+a4Q9M4gE259RCLEhBiCzVc5y4LKh63+k
	K2yg4r3JwH3LNfMFHApfIj+z9xpEYSTPMiSaplXGnfJc71lkP+b4nvamdiVNIs5fD+AXNwn2dDR
	WSvcqrotIpqs5
X-Received: by 2002:a05:600c:c493:b0:45d:5c71:769d with SMTP id 5b1f17b1804b1-47d18ba7befmr19461135e9.8.1766135178935;
        Fri, 19 Dec 2025 01:06:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE7eioW6Xn+tnoEhKXG2yusHQOhJIOjn1R2GKM3dKlAw2syLOpgGZtPDJfLlzWKSUJFj636Ug==
X-Received: by 2002:a05:600c:c493:b0:45d:5c71:769d with SMTP id 5b1f17b1804b1-47d18ba7befmr19460835e9.8.1766135178533;
        Fri, 19 Dec 2025 01:06:18 -0800 (PST)
Received: from [192.168.88.32] ([216.128.11.227])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be3963fc3sm32985095e9.0.2025.12.19.01.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 01:06:17 -0800 (PST)
Message-ID: <63de3a12-36bc-45bf-a3e5-89246f4ec73f@redhat.com>
Date: Fri, 19 Dec 2025 10:06:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next ] vdpa: fix caching attributes of MMIO regions by
 setting them explicitly
To: mst@redhat.com
Cc: virtualization@lists.linux.dev, eperezma@redhat.com, kvm@vger.kernel.org,
 jerinj@marvell.com, ndabilpuram@marvell.com, schalla@marvell.com,
 Kommula Shiva Shankar <kshankar@marvell.com>, netdev@vger.kernel.org,
 jasowang@redhat.com
References: <20251216175918.544641-1-kshankar@marvell.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20251216175918.544641-1-kshankar@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/16/25 6:59 PM, Kommula Shiva Shankar wrote:
> Explicitly set non-cached caching attributes for MMIO regions.
> Default write-back mode can cause CPU to cache device memory,
> causing invalid reads and unpredictable behavior.
> 
> Invalid read and write issues were observed on ARM64 when mapping the
> notification area to userspace via mmap.
> 
> Signed-off-by: Kommula Shiva Shankar <kshankar@marvell.com>

@Micheal: despite the net-next prefix, I assume this patch will go via
your tree, as it looks unrelated from networking.

Cheers,

Paolo


