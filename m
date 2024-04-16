Return-Path: <kvm+bounces-14729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BB278A6497
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 09:14:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 026302836CB
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 07:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09B7A76044;
	Tue, 16 Apr 2024 07:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dOYeuYsM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B875A39863
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 07:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713251648; cv=none; b=XlZO9GanzyG87x4LIzFybBylE48GGdeu1tEEhiCl3p2Sur7CmcPtVYG0q5asMnIYHcZZfBQIxkuh4M8HhMyzVLPJj4cpoVNkxKFhnLdKmUu1VSKDfsi4tSUb+mQokJDV7i8Bk4rURxdGBygjQx86wuxM+nXJFnVl5R2IEgQkIJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713251648; c=relaxed/simple;
	bh=zhlPaLuG8LY4jm4pwLz4/7ygwkcekjYjJGpSIHundeA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z1lUs+Ix2aiFa3Mp3kFxmMA0VWQm0I2p9hHCd8mOSHZBYRZ7/gV60igzAvNRnYDuMinjXtCcr73b4u0z1x2wJspSfZtViFfGeEHStk7jBA+ZmXeEfT94oHS5G7ZYy3mXL54YTm+pq+kajbmrzkhOM316xnzHlT7XoyRt7sarFE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dOYeuYsM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713251645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8bMa2NdMCt/jjygLXBA/F/vbbeeUkOfz7KmWUdw8p0k=;
	b=dOYeuYsM+9gpP3I8AiLdl/yaEFCuQjhorxmlgyQvAN0LgMtZQuFM/W5oAm/TWoRLn/iwAC
	tUI954bfAxYgJzbN5EJ82VH+u2xgaNawitJcq7UYsg3AC1sr4MJ+ScJo1jbhqawCNQ8emJ
	tvDb4+J4OQPBpImwg2P3g4k3u9G4WJg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-e4RtEl7hN7ig9VHoi1tlKA-1; Tue, 16 Apr 2024 03:14:03 -0400
X-MC-Unique: e4RtEl7hN7ig9VHoi1tlKA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a54c11dccfaso86026066b.2
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 00:14:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713251642; x=1713856442;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8bMa2NdMCt/jjygLXBA/F/vbbeeUkOfz7KmWUdw8p0k=;
        b=RufJ87bAAJmmQUUteDFAj9Bh2s1YfcLEu6zuuBYvIUxjsjsLhOTBoyST9j3/FcBdH7
         v2cu9reoY9qqSQdQw8Bphm1+ylO/cvx1KnQVa9/vMt3QvkyEWonVEYYxdW+o3oFzoMcO
         v1XMFDalTBuqm04sLZb1B3V0juFFBz7jWBPWBkAiPHijcm03F+CoOwuR1uW9XbwjWkQJ
         tUFxYAb6Wu8VVggC04/EL6RDyedfkUgjYp9hcROWA4NtTL02uK1klNLzE3iXReDT2d+q
         MLx1gEzDpmjhFFecmz0kctez54kKBYm5igGAoH6DX07QJ28xhRgGjsamSithKbDmU1az
         JWug==
X-Forwarded-Encrypted: i=1; AJvYcCXAe9Texvw1CfUBTImPBE0N8umJBF3j2fcJaZs305pWS66N9+ETkeKNZnMpd7Mu7LZ5/fvjfuO6X0gXVbWpujtpU/ik
X-Gm-Message-State: AOJu0YzPvUPBYgliF17eqiBWcXK8D4bTbeQuHlBehKX0u50PjntY/gdF
	HFK+jQVoftAp3gvne9oznfswGFhSdVXPDA4L1WwGxoKcWy8h9XWTsTsCt3r1Ar2TaY7NZNXoyvH
	xGHnMoKgNrvs5h9vfSsqoQpUAF7C73wlN8FkSrEkTHTxuJ45s9KPG4THQ3A==
X-Received: by 2002:a17:907:36ca:b0:a52:551e:7502 with SMTP id bj10-20020a17090736ca00b00a52551e7502mr7064202ejc.9.1713251642801;
        Tue, 16 Apr 2024 00:14:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjGVg/wKHQOfBuW1kLaLPCindSvX/WpMQR9ygezy0OgodDCIT2qFBWEa706lvyo3JP6F8U8g==
X-Received: by 2002:a17:907:36ca:b0:a52:551e:7502 with SMTP id bj10-20020a17090736ca00b00a52551e7502mr7064184ejc.9.1713251642519;
        Tue, 16 Apr 2024 00:14:02 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-50.web.vodafone.de. [109.43.179.50])
        by smtp.gmail.com with ESMTPSA id bv21-20020a170906b1d500b00a520b294d9dsm6450771ejb.150.2024.04.16.00.14.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 00:14:02 -0700 (PDT)
Message-ID: <eb6044c5-27f6-4d71-a34c-03339a14f867@redhat.com>
Date: Tue, 16 Apr 2024 09:14:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v8 09/35] powerpc: Fix stack backtrace
 termination
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240405083539.374995-1-npiggin@gmail.com>
 <20240405083539.374995-10-npiggin@gmail.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240405083539.374995-10-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/04/2024 10.35, Nicholas Piggin wrote:
> The backtrace handler terminates when it sees a NULL caller address,
> but the powerpc stack setup does not keep such a NULL caller frame
> at the start of the stack.
> 
> This happens to work on pseries because the memory at 0 is mapped and
> it contains 0 at the location of the return address pointer if it
> were a stack frame. But this is fragile, and does not work with powernv
> where address 0 contains firmware instructions.
> 
> Use the existing dummy frame on stack as the NULL caller, and create a
> new frame on stack for the entry code.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   powerpc/cstart64.S | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)

Reviewed-by: Thomas Huth <thuth@redhat.com>


