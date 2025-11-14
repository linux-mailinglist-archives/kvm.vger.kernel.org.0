Return-Path: <kvm+bounces-63231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0496CC5E291
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 17:19:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5198542789C
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 16:08:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A051F3385B3;
	Fri, 14 Nov 2025 15:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="R4vTryJK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B38633121C
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 15:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763135927; cv=none; b=Z4m5w7nb2qW/8UtFyKGiavJSouDHBQtmBk2jZsUULRp4v8mmxLo6ScN5IAZRePd89fftkGIOI4Ou2AihKAvb0BQaDsZXBndbV3qjt/fmWDM7rpAgWzhtNK73H69NwVBCSxrQnFxHxnZuJgO+Ysb24DRCEs1ECG6/NN1LDB2fEck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763135927; c=relaxed/simple;
	bh=C7Fjr8Xto2frMhhgVW189R2RvwowbHZfW5FHZo0pYvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lyX8uahYHxSWQSQ9uKKhFmiNS2QgpeyTopGX+JG13/7rBPelqbypm4TmQiMqUqZiDHhBI3vdZZ9LcYdBxMRusViH6oD0GTuqJvkkJ17xIWABkM+7qTXAtmj8DrC8Jz580pwJwlN9afmLySJWvzz3RCJqvdLCCA+ATjb2j1Z/+MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=R4vTryJK; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8824ce98111so25979766d6.0
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 07:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763135925; x=1763740725; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=hWRzwP7yaYI/iz3QDVFwP7hE6cNynh4rlrUlmbjDl1A=;
        b=R4vTryJK/hCTNzVWoHOIF55KTpt4vDrzlvNDXnO/34r0EFpssdtMK/PVDWzmGHaW+o
         /DkD16L8TdgD0YXuq6zIRkFsktkN8Z+Pe/UMeoJGH98ovt5fBiPiM6Sqxi5eIr5uGu5f
         Liy8vAx8jKoLFhIyWX8yhsWKW6wzVHpllgRKoJr4Br7nCevH1josiRg6EbUyfazgkGtd
         1WcNj8VtSSU1fKGkNgpYmFB6AxrghZ2H8SUfsdrFHftsgRWl3K3o0P7tPmZfqDYCFybt
         89bvhHoERzsK4vNslwU3lkA1YoejG9WJDxZSYnMYFCqB8bcS304ad6tr+p/rfzRvbJv3
         yv4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763135925; x=1763740725;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hWRzwP7yaYI/iz3QDVFwP7hE6cNynh4rlrUlmbjDl1A=;
        b=qP3cvOzndOdoVeHXMUk0IrJpP3iCK2Errdsl2FZKe2JSglyBoOFWQnbjurh0tTaJDM
         jbFFXEgxS2joGyaAP432udIjrWng23/+r40sqHQG6LLolNOXITkMIWP1FTXlgSl7ioQS
         yRvt0wBq3mij74CmWr+aekSjbJm3Mgv2E9eSPPL8lHYXj0iMGRRCOeda7MrQo6MlozQ9
         pu+mO8gSzS6mXd9hkLZ/Q/A6q3yJ4CGPUfE8au6G8NRcfenPpbynQVsYVMOQSuV6KyoF
         4QdpoB+j0QF6nTn1X5urO4cTPocT5ijaDTWvCDhhOC9x8MJ+pxoIugrkKH5M0c5LnLnW
         Xvyw==
X-Gm-Message-State: AOJu0YxLDVblTUVp3tCP3iSf5GkIr7ZbQ3SVy6KOHOqChp/5IJ4BGYbS
	qRbYvm0CWsQSKOHgGIywH6erOR2jfp6k134Mmbjaa/J/psq9dlZNVA+dS3dGQtGCCc4=
X-Gm-Gg: ASbGncthTReEaToiWDpgu3k+TP/zaxmQID04Xsh+On3A1rAi/uSc//ZTSCKeMcZb9AM
	gR/0vU9IiJBaulVFQtFGb7X3JEIobBSqMF92X8akEaqowDzbiD+WhCUoZpwSSzLLr2zw28+9Dgs
	7+zzAiElyA36ADYoGoDG35NPFdGhk8nVgNlOCnD8pOfL+m9y2LfD0G98V0meNdM6eCcVCc7W4SO
	G3RQ+/adjJStSbbGfICu36vE3hFdf/OF12BnXlFaGZRg5wpW75cyDcHbpfcWlLFdn3IMrsMNXeS
	4xoIo8SLj8O2IxcTNEA0ogJ6W/hI4h8gxrEORJeBZ4tZy6Dd8xhNaysJ2UQKwQuRtMKWaLnPRiq
	kc1fD5x6VbZJgyElVJ/NYydgVjRDraPDVJ5du+mGlNSj7CobRrIE9jJdNG1XiXKhUUN3n/PeIC8
	Olj22kqUhhFh/IdDnAtPXf0k40UvqW+oodK1GLzCKqAOuRQ/CnetvGF32ihtnxbfjFuDb/7+34a
	7HB11fVe4mTn/rVwO4jRW0mECPPkA3JSnDxeCYnizzZ6vmVY4d2t98D
X-Google-Smtp-Source: AGHT+IE7eiGd3vEuNVBCnEAo9tQkcil+B3Q6M+8Td3zOqsuTZ0gqLQ+T0rf73N9UcDNXrhI66caTiA==
X-Received: by 2002:a05:6214:1256:b0:880:46a7:b1c3 with SMTP id 6a1803df08f44-882925dfb0emr43805336d6.28.1763135924857;
        Fri, 14 Nov 2025 07:58:44 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8828652d941sm33112566d6.30.2025.11.14.07.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Nov 2025 07:58:43 -0800 (PST)
Message-ID: <9b2d7e48-a847-4c84-89cc-b8d3962f4498@grsecurity.net>
Date: Fri, 14 Nov 2025 16:58:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Better backtraces for leaf
 functions
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
 Eric Auger <eric.auger@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, Thomas Huth <thuth@redhat.com>
References: <20250915215432.362444-1-minipli@grsecurity.net>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20250915215432.362444-1-minipli@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

+Sean

Sean, while you're currently in KUT maintainer mode, can you please take
a look at this? The ARM bits have already been ack'ed by Andrew and
Paolo, apparently, has little time for KUT as well. But as you currently
seem to be looking through the pending KUT patches, maybe this one can
get some attention as well?

Thanks,
Mathias

On 15.09.25 23:54, Mathias Krause wrote:
> This is v2 of [1], trying to enhance backtraces involving leaf
> functions.
> 
> This version fixes backtraces on ARM and ARM64 as well, as ARM currently
> fails hard for leaf functions lacking a proper stack frame setup, making
> it dereference invalid pointers. ARM64 just skips frames, much like x86
> does.
> 
> v2 fixes this by introducing the concept of "late CFLAGS" that get
> evaluated in the top-level Makefile once all other optional flags have
> been added to $(CFLAGS), which is needed for x86's version at least.
> 
> Please apply!
> 
> Thanks,
> Mathias
> 
> [1] https://lore.kernel.org/kvm/20250724181759.1974692-1-minipli@grsecurity.net/
> 
> Mathias Krause (4):
>   Makefile: Provide a concept of late CFLAGS
>   x86: Better backtraces for leaf functions
>   arm64: Better backtraces for leaf functions
>   arm: Fix backtraces involving leaf functions
> 
>  Makefile            |  4 ++++
>  arm/Makefile.arm    |  8 ++++++++
>  arm/Makefile.arm64  |  6 ++++++
>  x86/Makefile.common | 11 +++++++++++
>  lib/arm/stack.c     | 18 ++++++++++++++++--
>  5 files changed, 45 insertions(+), 2 deletions(-)
> 


