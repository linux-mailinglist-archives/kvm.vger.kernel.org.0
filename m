Return-Path: <kvm+bounces-6818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B132A83A5C6
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 10:44:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3EBCBB2F442
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 09:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADB1918044;
	Wed, 24 Jan 2024 09:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fvcrZf67"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E89818036
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 09:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706089275; cv=none; b=j5gq/k81rOCsYIcZw8TY0sTN8qnxpsn8rJm+X9qGu3tmhCJ2yEsF9uLsIgDR+plf6weUIdcTYPsPhTsjKORtSBxzXhYWMXR710RClyjrLTQ+oh8RN1v7wZpMG0IiI3mNXb/mcXapt1FD2x2h5iDgJieQId4gkJk4xtB4q0uNxP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706089275; c=relaxed/simple;
	bh=0EpT3CK+Limf2hGvFJ/GiDh1uJ1ffx0DanYWdJ0Uijs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bWtXXzZGkCcIhe6W9BaQPOgmT4xqoM/96Z0hjdDvSJvRouT6S+jPsbTXkuMcVKZZqhtF2ajcuqiBlhPftLAfkkh6zp2hNeXTV3TlEVKyGIvryBoMQV0FGJfWsS6bXDbo4Nt1ZrB5JvZbiJUTjkArgJ8Uef/VJ4wTcALD8gzyC5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fvcrZf67; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706089273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gx6UDE3WqgCxA+YsuAbtHMHWU0KJY6DuLd1G/I2mTs0=;
	b=fvcrZf670yAjTdYnyVMi6zpnahM1UInZRILBrdjmt/DSLCH/MkqNBAf9QyilJcn5PWauIs
	3LJ3YYfTL/qr1Wcp93toEOIB0AFo6M3lcuzU+U7AyRpgn7WGy+QXMe2x+ov6Tbkz420wSV
	wgbtfaMoKgdGnm302FXYevJ90GeRmAw=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-oIPhumFfOrOL6Z2YMjWN5A-1; Wed, 24 Jan 2024 04:41:11 -0500
X-MC-Unique: oIPhumFfOrOL6Z2YMjWN5A-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-42a34134f4cso61532941cf.2
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 01:41:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706089271; x=1706694071;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gx6UDE3WqgCxA+YsuAbtHMHWU0KJY6DuLd1G/I2mTs0=;
        b=gv0y/rHNmvaYRnIOdEwCzmL+KFdSijSUgtSaX/jGzmpiby4oWgSqpBJLdPFLREhQaP
         TLfTU/YmE14cyfRu4TrBBhMnSrv+KMqIGrb+evflZL14rjk/t+KpQ1uMPoVaNsUhq33C
         PjlcxpZpiWIUTcNkqwa9Owyobcvysw0MWQTs55Yr/EOdNaOvhJOE+6mqPx+eMslLlkQB
         z4RuEoeWdwIzu1bc0k/tmVftx63G/P+rGXCfGA5WAkoH4lAzGo3EAQ0297d7GsXCl39v
         6ZwKSjXsGhZ9UIzj4q6bE7a+x+gsrIOCJLJVFGGfJdxaKUmJiwBCDcWnhd0zhvDvXZCo
         f+Eg==
X-Gm-Message-State: AOJu0YzaNN3/fV12Ck4ZFFBb+7MQ8a2QDRIOKecc/geDLZRV7Vz7RZoY
	na97CZvyyAUZ/7Bi0h8huiSdEc0LZD3kUd5pubraZ9CwdPXpKkVYV1YjtzM8aLCUG+uye4gZiUx
	S1Z9pOB8Sn74TAL1L3nVuEdlyGx823zhBEOOiVfFbBbMedIaP4Q==
X-Received: by 2002:a05:622a:1103:b0:42a:2ee1:74b3 with SMTP id e3-20020a05622a110300b0042a2ee174b3mr2650315qty.6.1706089270713;
        Wed, 24 Jan 2024 01:41:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEDGRqsb/R8L8hbnk8L4IdXUS0xDsxstZqw9Z4Ey4fpOzEJvtifee7J8+h9k5v+cErpfz4kgw==
X-Received: by 2002:a05:622a:1103:b0:42a:2ee1:74b3 with SMTP id e3-20020a05622a110300b0042a2ee174b3mr2650307qty.6.1706089270478;
        Wed, 24 Jan 2024 01:41:10 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-177-121.web.vodafone.de. [109.43.177.121])
        by smtp.gmail.com with ESMTPSA id m5-20020ac86885000000b0042a11ed1240sm4211877qtq.92.2024.01.24.01.41.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jan 2024 01:41:10 -0800 (PST)
Message-ID: <44e2bf47-9948-42d6-aa6a-6a24e29d7ee1@redhat.com>
Date: Wed, 24 Jan 2024 10:41:05 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 21/24] lib: Add strcasecmp and strncasecmp
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, alexandru.elisei@arm.com, eric.auger@redhat.com
References: <20240124071815.6898-26-andrew.jones@linux.dev>
 <20240124071815.6898-47-andrew.jones@linux.dev>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240124071815.6898-47-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/01/2024 08.18, Andrew Jones wrote:
> We'll soon want a case insensitive string comparison. Add toupper()
> and tolower() too (the latter gets used by the new string functions).
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>   lib/ctype.h  | 10 ++++++++++
>   lib/string.c | 14 ++++++++++++++
>   lib/string.h |  2 ++
>   3 files changed, 26 insertions(+)

Reviewed-by: Thomas Huth <thuth@redhat.com>



