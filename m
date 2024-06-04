Return-Path: <kvm+bounces-18752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E7E58FB084
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 12:53:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F761283464
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 10:53:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 026B8145353;
	Tue,  4 Jun 2024 10:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DPBb9PH/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8956145347
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 10:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717498416; cv=none; b=pHwB4UjWINuQtxK/6owaWoR7qIAu2FML3AhENptbRiT9LtDmt2hPm+1nVfWTbacoJgf6TsbcDDDvDgvTQMOWLiE1IhV9u1/CIgFO0/LcjKm7IvF18cj2ABwLxYc5Q8LHml+EaU3UiJQS1g6WBl7UAYiEP/GFq7B54vB4OjOCfn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717498416; c=relaxed/simple;
	bh=UH8l1aOHKNfS3HrTqJTIU17OVXp7137QYEG358YqoLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eiQbtbu+tdjTsSqAOu/Ca7ngvBjyqGu/Td9zT4xqjfCP8aV8wMcrxZLq2+gRhFuLbnTiMY+pTLeTzjM4vjDEnga3Qq77es9zn2UjH1dJiX/JPVhKYr2YN/oD8yXhbO0DMEN9F/2StvFuio2YTvfZJb3MmH/n1rKZ5L3t3QQo9Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DPBb9PH/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717498413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=khLXT47kqpcrtDLU6hojN1Y8iwI4i0MMg0kRPkLwAKQ=;
	b=DPBb9PH/0RwAVdbaamqAn2Gy1ikGFRPkjGeyLdjl5Jo7JYXUix95Rxy8RGoCdvyWQKABUv
	ePaUs/L/W5tJvUbWWMDrfS+RsJ764j3H5N9KP+l+0j4GGExurXDG+k7ZENun/szwjGXFWg
	+DVtNp6KTMyqnLQqQ1RP+6+O7Jok3uQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-5MOm1CFNMpeCn66PcEggsQ-1; Tue, 04 Jun 2024 06:53:32 -0400
X-MC-Unique: 5MOm1CFNMpeCn66PcEggsQ-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-794c059f55eso465573585a.2
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 03:53:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717498412; x=1718103212;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=khLXT47kqpcrtDLU6hojN1Y8iwI4i0MMg0kRPkLwAKQ=;
        b=IW3J6WDHmrP2nZWsBWeYSE6sPCyVcF9W0YMcuOwjT9RItYGQKg73nSROFXMYaCI9+W
         oBq+XGdiensw0vY0UZ+aTK9wYbHOOcfYYoOkPGTL7ynX5e45ruqkt835Uy2S6hqgLzeX
         C4LvGvSlDrx5abgRm3abAjW+b1pmcUGtJlTf3FiaLfnMm/1cWwuiMDwoTECLTRYTTT6V
         TlzSI2VZnoDno/8lT5P2PqyLeYR/sfXjWKkq7pcX0mcYhKcuUBdc5RgmTyAWDlTxRnsw
         4rL/pBhAC248eUEYI5tK3NFChi1kKecQbbDFT47HgXX1TF1hPlmx1f/L7lbptzXZ8W/B
         Ng8A==
X-Forwarded-Encrypted: i=1; AJvYcCXs7K1UujrJBJ+/oc+Yqo8biPXFsRc4tNY1sdBRLQt7KKZzo9uZ2quWGZvz+uhM1bY1GbUWUG0O6whOr1JICO1jFSjE
X-Gm-Message-State: AOJu0Ywlrhn2MiPnbgkbAV+lwiNfwdivIZ+r31fuUKp2UKgH1gwe/goA
	ALXaE6E4ahh/Cp5M0oVBnGhQ//oa42l7jETQdGeYJBk02RBmuwYyD9M2c1zFqcESjylY9c82cDq
	4vgQ5q5eRUNbXPhsifDrcOi2XFaLOWax8CKXrn6Nxi4+SXC1Ej/Uc6mJm4A==
X-Received: by 2002:a05:620a:46a6:b0:794:f011:7a30 with SMTP id af79cd13be357-794f5c669c0mr1562812385a.14.1717498411888;
        Tue, 04 Jun 2024 03:53:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHymc98QpftOUqvFlvr/bYlT6Z8NbMKWzQR6dsIzYHNQdoHJ2RUVlPg2ortFt5CFWmtmRCzbQ==
X-Received: by 2002:a05:620a:46a6:b0:794:f011:7a30 with SMTP id af79cd13be357-794f5c669c0mr1562810185a.14.1717498411452;
        Tue, 04 Jun 2024 03:53:31 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-178-97.web.vodafone.de. [109.43.178.97])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-794f2efc653sm352278885a.18.2024.06.04.03.53.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 03:53:30 -0700 (PDT)
Message-ID: <4938edb7-c057-4f92-b59b-31f0b7ba6f54@redhat.com>
Date: Tue, 4 Jun 2024 12:53:27 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 30/31] powerpc: Add facility to query
 TCG or KVM host
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-31-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240504122841.1177683-31-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/05/2024 14.28, Nicholas Piggin wrote:
> Use device tree properties to determine whether KVM or TCG is in
> use.
> 
> Logically these are not the inverse of one another, because KVM can be
> used on top of a TCG processor (if TCG is emulating HV mode, or if it
> provides a nested hypervisor interface with spapr). This can be a
> problem because some issues relate to TCG CPU emulation, and some to
> the spapr hypervisor implementation. At the moment there is no way to
> determine TCG is running a KVM host that is running the tests, but the
> two independent variables are added in case that is able to be
> determined in future. For now that case is just incorrectly considered
> to be kvm && !tcg.
> 
> Use this facility to restrict some of the known test failures to TCG.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   lib/powerpc/asm/processor.h |  3 +++
>   lib/powerpc/setup.c         | 25 +++++++++++++++++++++++++
>   powerpc/atomics.c           |  2 +-
>   powerpc/interrupts.c        |  6 ++++--
>   powerpc/mmu.c               |  2 +-
>   powerpc/pmu.c               |  6 +++---
>   powerpc/sprs.c              |  2 +-
>   powerpc/timebase.c          |  4 ++--
>   powerpc/tm.c                |  2 +-
>   9 files changed, 41 insertions(+), 11 deletions(-)

As mentioned elsewhere, it would be nice to have this earlier in the series 
so you could use the conditions in the earlier patches already (but if it is 
too cumbersome to rework, I don't insist on that).

Reviewed-by: Thomas Huth <thuth@redhat.com>



