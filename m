Return-Path: <kvm+bounces-34848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 208B8A06794
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 22:53:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A11D41888631
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 21:53:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A656202C4F;
	Wed,  8 Jan 2025 21:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YMd96TyZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C164C1A01C6
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 21:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736373211; cv=none; b=KnxZXyTbPKWpNGEtkg4leeG469aczVeF0EykDBWe1TYqmRF7c7qC/u1v/LOAEgDPahXpiGu2B4YTmtK3xcUDUPmplx8cqFijUj6aDzWKUkceLDsURM0IkiIn5bH29QtxCNnh2vov/sMKMDid6qNmLhAcbclM6GDvMRdp9BXLoww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736373211; c=relaxed/simple;
	bh=NQt81YJDcxAL3s+/0h6N8OUPeWSRDeF3BWlqF9nq8ao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MpvQRwzLmOZS8NRo7WSA9UuImwZBhveSSErfR3Ug1Mjj/6HoM+Kfem9QzlNzUT3pJKWB/zLaSOnLC1FY0aWC7KISvDnB2CUTTYtQLqjaSrYCPjKNCzxwM6dwp4ax4Rjgg3OGekQaiGZy4+56bT5pb6CaH7JiCB81gxh/mohzghI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YMd96TyZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736373208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=vHvlQp1aQA5l/um+YechYvvftWyn9AOMcuaRx3SfcL8=;
	b=YMd96TyZClPBbwKXx5fYbz63KtZkwWi75/siAyfCnqyGMeL9l770DcLx8XBWc2M9bame8m
	iEKeojJD7hztY9dxw00D91I9bwukRtiKbQaEPutwvdmjiLhiFEfqLup8A1yIeJ0ukKRvPr
	bN8vyXX0bpMtrj8Pcw5hfJw6me4ighA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-183-L-QlQNMRMPmTyAOmsvC2vQ-1; Wed, 08 Jan 2025 16:53:27 -0500
X-MC-Unique: L-QlQNMRMPmTyAOmsvC2vQ-1
X-Mimecast-MFC-AGG-ID: L-QlQNMRMPmTyAOmsvC2vQ
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4361efc9dc6so1330175e9.3
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 13:53:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736373206; x=1736978006;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vHvlQp1aQA5l/um+YechYvvftWyn9AOMcuaRx3SfcL8=;
        b=Aru7zCml0e58G6irf/KsVJW5x3uWt9cI5Z6J7lHbemsbRqr3RtOSoSWDedhaXHhB5s
         QkspxeUaEXMMZo7FQCSYjK0AdKX1+J+1hgpQqIRMdM94vCKw0IAKJ766xnyL1nKpFXtt
         xPG7yzsesqbmPSFX1Fbg8ren6PHMlDoDFSHf2OtuzqNssSFdYLe61e61/V8HjkXzxtS9
         rZNlqGfV1ZLfd9cfT/jBB8mhBLoNKDRpaqNZHcK77XYO0zppEjzah2buDDj7j+Y0HZAi
         z/kaWGT77R98WLTJD6RbjE+jcnazGcQjWUxUiYIbub0DubFqojSL2SUit4RlSfOvcWSA
         CXrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmVNUrLknU7Q1H9fXkKRdco2GPUxmbSBfnVSzd7FxY0Adr2UYDFmgwrWTxV72BCBFj6Fs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyduvqs1twIY/VTdAu/VrHnXJbeuD3U0FOJUPUzsvmdSGML7va6
	QqsV73aosv5KW4jvX4PJcdXDTbuzTm3NDyYQq3U75zWk0+e0qzkdXYU5veNQ8xZr5pxLvifF3P6
	i+NZxFRL8k2/muy49EOqKXTKCKWop7btYb3jgAUGmAUO0kP3qdw==
X-Gm-Gg: ASbGnct8tRSGuwf0YxyE4LanQnKSKC7Dbh9vDeeO79nmRIKxxQv76yNmWrNrcjHvyca
	Rj4zNWudxvwmU3qj3kK0P3EQZ0QpubSOQ3cr5FRvcpwUoFIdtAUHJ0zkXqcIpnOsGZDy7F5Yx/u
	TqeoWukBcJFAmhgdCl/77qaELCrzptIM1vsIkniCg5nLck9+4icKrSYhh6DACC3p/ZvwbqszWTo
	PEVt4w8MQriCFOlr06MPnD6d3pg+YsyVwQzbqxZpHwwRePA6F5wvWw55yE/gQEbjnQEnLerzGku
	wtrCVAI9JQFlIZI74/+RQkaJaDr8pZXUYYNgS38bkmHmVyxuiDhTD4qmAchoazjLkzdSduWJz6x
	wuRBJcw==
X-Received: by 2002:a05:600c:1386:b0:434:f8e5:1bb with SMTP id 5b1f17b1804b1-436e26aeb43mr40080675e9.12.1736373206330;
        Wed, 08 Jan 2025 13:53:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE3rDS1hnE25fBfA1d5/lNO0uT9AX7FuBxSWBmfEMxNTmreerhi9TLvtnMmXsUDtITkyp8U6Q==
X-Received: by 2002:a05:600c:1386:b0:434:f8e5:1bb with SMTP id 5b1f17b1804b1-436e26aeb43mr40080505e9.12.1736373205924;
        Wed, 08 Jan 2025 13:53:25 -0800 (PST)
Received: from ?IPV6:2003:cb:c70d:3a00:d73c:6a8:ca9f:1df7? (p200300cbc70d3a00d73c06a8ca9f1df7.dip0.t-ipconnect.de. [2003:cb:c70d:3a00:d73c:6a8:ca9f:1df7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e2e94ed7sm33441315e9.42.2025.01.08.13.53.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2025 13:53:24 -0800 (PST)
Message-ID: <e13ddad7-77cf-489b-9e32-d336edb01c85@redhat.com>
Date: Wed, 8 Jan 2025 22:53:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/7] system/physmem: Memory settings applied on remap
 notification
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241214134555.440097-1-william.roche@oracle.com>
 <20241214134555.440097-8-william.roche@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241214134555.440097-8-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14.12.24 14:45, “William Roche wrote:
> From: William Roche <william.roche@oracle.com>
> 
> Merging and dump settings are handled by the remap notification
> in addition to memory policy and preallocation.
> 
> Signed-off-by: William Roche <william.roche@oracle.com>
> ---
>   system/physmem.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/system/physmem.c b/system/physmem.c
> index 9fc74a5699..c0bfa20efc 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -2242,8 +2242,6 @@ void qemu_ram_remap(ram_addr_t addr)
>                       }
>                       qemu_ram_remap_mmap(block, vaddr, page_size, offset);
>                   }
> -                memory_try_enable_merging(vaddr, page_size);
> -                qemu_ram_setup_dump(vaddr, page_size);
>                   ram_block_notify_remap(block->host, offset, page_size);
>               }
>   

Ah yes, indeed.

-- 
Cheers,

David / dhildenb


