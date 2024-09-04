Return-Path: <kvm+bounces-25831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A85BE96B109
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 08:10:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 389132819EB
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 06:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1885084D13;
	Wed,  4 Sep 2024 06:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Az0zsf+c"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A9384A36
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 06:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725430231; cv=none; b=heVaaYRB7anO077QEM1Tn0mteZY2uU64yWFyrb3h+GJ1QAL8XmUs82AXlUVa/uJ0iHZKwfsiH3HJEIUDe33RhkQQEgPFONp7YUpOpPeTHMVgKxJZKry1Cd0UBEEN7n1mJTSofFHJcH8BrWxWKYcHV5yx19c+70VXXXZAiDmCyoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725430231; c=relaxed/simple;
	bh=/qr1qZBgzj4Bl3UmsQg/YF4ckGvsFa5uUnsPbgL5cWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gkGtohOYEN+IdJMlLcUCz3uYAgM6KTiL1RDEJk0vfLJabva2FDXYzwzNShSWT/ZGUPx3ih+mXkagCFkBfU0Z+NA8FAdmwL6aJ6pgm1d60+sbh4WAczbt/Ciu3mQX03XlCJuqrkpvA3rJePgd13arEN8V4tNK0VOzWQ+AVVbC2XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Az0zsf+c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725430228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=l6V+fxyx9J17jMpvz7+Fq8AeiBhZGiwz6aJOg0X+z7o=;
	b=Az0zsf+cNf4tNkJWQnKP7uMM1XToP2o2q3oRmrZV5su4LjTCUfAchTSMSQ/usQZvplaahn
	DO1rtfN105Qqd33S3pmenrRnNp7DbIZL1+3OjqQDds7OmmNislot8p1Y3c74KvE3UWfGDe
	CZ71sugEhjGWx4G6IcxXgnxpzEpyHPU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-Mta0MHULPSGzGUI3S2XrdA-1; Wed, 04 Sep 2024 02:10:27 -0400
X-MC-Unique: Mta0MHULPSGzGUI3S2XrdA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a8696019319so460436166b.1
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 23:10:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725430226; x=1726035026;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l6V+fxyx9J17jMpvz7+Fq8AeiBhZGiwz6aJOg0X+z7o=;
        b=LLb/u25fgtGtGi2vSebQpdbL0+GjmnPsoMHWOHp+P3GyOdHJzcxj4jrl3CkT1ooiTx
         NapJCvYt/yFnJMZ6W+aN0xsV6YVRzqVxt+ah8uycFIbZ/YyHBm5/iFC0gPiBrrfN86cQ
         d2l7iH7EYQZ2IO6/iOi0LAQzzigxvxSAbyp3kgsAhi52RrECKJwcmwnZTx4/dzh6XPnI
         YOpWz0EIvyAAjy0VAyZ2+Yh5iAc7/lDPVbInnwChRtFlyULxgRXcokeDFLMPTVTxq623
         9p3/pEGwrrBMrxouzXkcgClEWrpAzdm0KMkApw2RmmCv0GJCV0cxSAAxG0E/KZeaku3s
         /ZOA==
X-Forwarded-Encrypted: i=1; AJvYcCW0ZM57kogv6LA/CpgD1qCyB9fxV3Mb4O6s7lvN5hJO+5RTwz3AQ7dPJk0Zkz6efqikLvU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8ANaEUZqb9xhzSZ4ZXoMeE6Gg9WOLWAEV0ZeX7ly6Izxpq7C1
	9JypVajATd2cKA/gFThnk+5PTBSTiSh1RfqnDGN8jftHq5lyYCpT7rPUwkUyo1rTeZT4dUimVne
	33pWpxOMrYihFT3fXO3c1nmdQTUL5lLY54FYMamPu38PkXflThA==
X-Received: by 2002:a17:907:7e98:b0:a7a:97ca:3059 with SMTP id a640c23a62f3a-a89b9568fb7mr914180566b.34.1725430225924;
        Tue, 03 Sep 2024 23:10:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2R4cP9J+W47K4+S/93+/qMlByI9g4pLQSot/De5DcDW6cAfj6YNv4/0hVq6CwiaDFPMR8sw==
X-Received: by 2002:a17:907:7e98:b0:a7a:97ca:3059 with SMTP id a640c23a62f3a-a89b9568fb7mr914178066b.34.1725430225410;
        Tue, 03 Sep 2024 23:10:25 -0700 (PDT)
Received: from [192.168.0.6] (ip-109-43-176-181.web.vodafone.de. [109.43.176.181])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a898900e746sm768992066b.52.2024.09.03.23.10.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2024 23:10:24 -0700 (PDT)
Message-ID: <f8c797ae-a8de-4e6f-a1b5-c0db79e15011@redhat.com>
Date: Wed, 4 Sep 2024 08:10:23 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 2/3] configure: Support cross compiling
 with clang
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
Cc: pbonzini@redhat.com, lvivier@redhat.com, frankja@linux.ibm.com,
 imbrenda@linux.ibm.com, nrb@linux.ibm.com, atishp@rivosinc.com,
 cade.richard@berkeley.edu, jamestiotio@gmail.com
References: <20240903163046.869262-5-andrew.jones@linux.dev>
 <20240903163046.869262-7-andrew.jones@linux.dev>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240903163046.869262-7-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/09/2024 18.30, Andrew Jones wrote:
> When a user specifies the compiler with --cc assume it's already
> fully named, even if the user also specifies a cross-prefix. This
> allows clang to be selected for the compiler, which doesn't use
> prefixes, but also still provide a cross prefix for binutils. If
> a user needs a prefix on the compiler that they specify with --cc,
> then they'll just have to specify it with the prefix prepended.
> 
> Also ensure user provided cflags are used when testing the compiler,
> since the flags may drastically change behavior, such as the --target
> flag for clang.
> 
> With these changes it's possible to cross compile for riscv with
> clang after configuring with
> 
>   ./configure --arch=riscv64 --cc=clang --cflags='--target=riscv64' \
>               --cross-prefix=riscv64-linux-gnu-
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>   configure | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>


