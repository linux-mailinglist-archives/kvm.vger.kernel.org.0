Return-Path: <kvm+bounces-10649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8023B86E2F3
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 15:05:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFB211C218FC
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 14:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EE826EB7D;
	Fri,  1 Mar 2024 14:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A1phmCRK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B506E60C
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 14:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709301913; cv=none; b=aJhYVk206jm0FH7w70F3oM0vQn9s8IzB4+bkuyAS4p6KOXXqSBJJ9D4uADssuUcobTF+eD55FdujBRLpzpBqItAPkGJC08Jfiudkbz0sTrXVzjFW+SZ7iZhds76nIsotWWJ/r6ptci5GBhuBrCH9W/ECcvJxiXNTS9Fn4rORNNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709301913; c=relaxed/simple;
	bh=5FFji0evPJiIEMZatJK8QJ8yeL40hHU8Y/bLCYr4UQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DlONRlc2MOHYDjtctHesQVdl7NQ6FT/H2LuPjtOWDGIi5iZlr2s4hJ2IhWIai9qCEhUqAmW5n1PYiJxEONk2NeJwu6z3o/hmKgH3UlcO4HSmytWQGlikUTVzFIAnNLgAYhHmgSPFuyGMNO/A4DjFWmklzy7djHKUmqkyB1wSj60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A1phmCRK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709301910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YphiZellMbZ+Y5xIqDpD84y1HO6iOWPJPSjFDhAMAbk=;
	b=A1phmCRKgpaOFOtVLAtnWjCZfIxISszfGj25ABu38hQjNBcFy+UheyfppxRr0y+I+hSWVq
	IRt48VJiQxy1kLKS436yjqog8ECWKxoMX2qEn8kiE8oxSAkgSDuuuGEgZk9FzTZxTPSkJC
	cr+tzC895H2qZ8YS9IuXgpFoKCYdmBU=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-FKhIO5SFPEGOZ_izWJbcZw-1; Fri, 01 Mar 2024 09:05:09 -0500
X-MC-Unique: FKhIO5SFPEGOZ_izWJbcZw-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-42ec819e830so7032211cf.3
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 06:05:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709301908; x=1709906708;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YphiZellMbZ+Y5xIqDpD84y1HO6iOWPJPSjFDhAMAbk=;
        b=pKc1UYbBF4aMMu6tq2UDq0bb+PciBDjWMsWbAng3tcy1B76Ut9/d5JOSdTMG5E21l/
         NmvA+LIl3IeCrSjoavB49D1ucHMdyq54gIRyO4ePy9OTAwGXyq2HiPNWMFgYirllCASL
         64u+SW97MNW/vlW1hC0/9e78+SBrVgotkVgggCb1yKr3Xn8XO3TsUBC72MEBQyN5kGkO
         A3bCppf2PicOuVe58HrtcYGETKXT/VGpW/HIwuCv2GIHWp2R2xQ2wv6qYjutn15idHwC
         cDFJZrLphgTlLlWxvIqQ8jtFcq3MtvtZd2wB8YyO4N29kZ7NRa/c/ZHxYpRzmlkuuyPh
         2W4A==
X-Gm-Message-State: AOJu0Ywoyfo8Mmwd3i+BN6BbO8woCfmoCuLW7Rnd0EVUuN6/LriY5BLT
	rcVU6kTNeWl47r1xVHh/JPIHqr+N5mR9jbPqplFGhV79I/kflyZ+PstGTKPtRx4rkgWbGNGftki
	iDF0hUnjuSXhJQY6pviU6svzncFbr5Wwi//NPpyvzu0Cx8hw9MA==
X-Received: by 2002:ac8:5dd0:0:b0:42e:b20e:b691 with SMTP id e16-20020ac85dd0000000b0042eb20eb691mr2042767qtx.49.1709301908590;
        Fri, 01 Mar 2024 06:05:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHH7e4vYSFYBzWNAc72YehUDF7uIHRPeKh16MtOAfwQ1sHS/Vx1HjrZXV4re/6hiN7peh81eg==
X-Received: by 2002:ac8:5dd0:0:b0:42e:b20e:b691 with SMTP id e16-20020ac85dd0000000b0042eb20eb691mr2042734qtx.49.1709301908304;
        Fri, 01 Mar 2024 06:05:08 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-133.web.vodafone.de. [109.43.178.133])
        by smtp.gmail.com with ESMTPSA id jv12-20020a05622aa08c00b0042ea9d4f563sm1705753qtb.62.2024.03.01.06.05.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 06:05:07 -0800 (PST)
Message-ID: <d9b53b30-0640-499d-a543-b7ab8b3d48aa@redhat.com>
Date: Fri, 1 Mar 2024 15:05:03 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 4/7] powerpc: add asm/time.h header with
 delay and get_clock_us/ms
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
 Nico Boehr <nrb@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Marc Hartmayer
 <mhartmay@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org
References: <20240226093832.1468383-1-npiggin@gmail.com>
 <20240226093832.1468383-5-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240226093832.1468383-5-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/02/2024 10.38, Nicholas Piggin wrote:
> This matches s390x clock and delay APIs, so common test code can start
> using time facilities.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   lib/powerpc/asm/processor.h | 21 ---------------------
>   lib/powerpc/asm/time.h      | 30 ++++++++++++++++++++++++++++++
>   lib/powerpc/processor.c     | 11 +++++++++++
>   lib/powerpc/smp.c           |  1 +
>   lib/ppc64/asm/time.h        |  1 +
>   powerpc/spapr_vpa.c         |  1 +
>   powerpc/sprs.c              |  1 +
>   powerpc/tm.c                |  1 +
>   8 files changed, 46 insertions(+), 21 deletions(-)
>   create mode 100644 lib/powerpc/asm/time.h
>   create mode 100644 lib/ppc64/asm/time.h

Reviewed-by: Thomas Huth <thuth@redhat.com>


