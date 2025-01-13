Return-Path: <kvm+bounces-35285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6FDDA0B4E7
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 11:56:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B12431677EC
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 10:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33F1622F148;
	Mon, 13 Jan 2025 10:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AvsLuknP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB55D8F49
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 10:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736765806; cv=none; b=heqyrt5OfzmRX2Y1x9nfhi7XJkMNI/U9WeSdWMTBSf+LfZQbyD7xlS3yuOH4Hr6xk62XdOQFYFjz4Xa0Euk8JsSPn0u2odoUvF8PdvAOQBybOyhCly8R4b5WfOI9PjBSzB9QSgChAGwjsAfXq5uGuRE8PkoQ3rZahC5um5v/wsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736765806; c=relaxed/simple;
	bh=Ffpu9+s28n95nG5W3Qyqcjr9G/muce6kEMF3vXv6lDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AmIWAz4jdo/PxeIJkeHBH68ezcezl0CQUDjmgp7A3Fl3IaUwTqL/9q1izP613vpXCh617rMUz4TRvW1f4Ac0rKQKXKXqrj2g7rR1wVjAx5Ne3q+1r3LFF/1kKIRrBQckwLgLS2fm9HLG1zqQjULUGsToHcddD1jPKGic7w1xEBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AvsLuknP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736765803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Bqt6IiG5+9sByjnA4zN5pMEQNuV3hcpep/21Cc5Uf5E=;
	b=AvsLuknPOzNzImwlKv84hcq97DmOljSwdv98oEj1GR/7OgZzvToMiDgQ+/tunndt7UvOkt
	kQFuK1aD6S5tY5gQdgNlwphIGy54bzzGMZdVUHoZwxHSVdQTmwTLKVgcvffqfEODeemEDS
	zZo1asNkIzxs5N1XJni9keoDr991JqQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-63-ElsM9lDQP2KyT6tbNht0cw-1; Mon, 13 Jan 2025 05:56:42 -0500
X-MC-Unique: ElsM9lDQP2KyT6tbNht0cw-1
X-Mimecast-MFC-AGG-ID: ElsM9lDQP2KyT6tbNht0cw
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4359eb032c9so33074675e9.2
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 02:56:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736765801; x=1737370601;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Bqt6IiG5+9sByjnA4zN5pMEQNuV3hcpep/21Cc5Uf5E=;
        b=jXORVicd7SQn3LAcHP756SVCpG+ojUX67Qb6hMuH7kz2pILfWGViCnOwYQctUl/2ZR
         20KnM8tHj+u0oFp51uZdiDZ40KHxE6hBgTeGA0WTDc+0QHQsTrDTqh9dmsMGfSLyHZOo
         8gZOO9HOxvsu2Vl13JXLGEZHA7DeZILwwEkZqw3iH6cFnWV9/KR3ZK9zG/wYUfdKgtZH
         bypfxZEAhd6NBQbKbNc1/VOARejW6bPj2CBTUAUnzwUNI6/MB1eJyUVJ3RXlpopqwQBf
         eQcDZ8sw8xuVczFA7KbyaSqC5WJIZtvtRkyz+quAIDY/xDeaR1wXrq+xwBcgrqZyZeBb
         juGw==
X-Forwarded-Encrypted: i=1; AJvYcCVt7rXfnQE1RpbiE8/p/rhVtw2CsBCDnOc7HEMwI6M8flQhxpr0G196CpbSMp3DlCuz3s4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdS7l9wCjRDojRD4FbEB0a2zdvxCU27Aae0i0PY/Ss14WwGSjU
	f7urPxaJ5BnMmSnvkS+mjXP8jo89daXugO11xOCcbYNpN+eTPw9Axxcba757os4BCjv8Ce0iFac
	gxoyZOPB2dQcSIbW5BAAQF+jy5nVnm7Lf28KPNY9/YmeHqgfl6Q==
X-Gm-Gg: ASbGncv4l/tOaFMoYVQ2PDzzXO0y/Q3WzPNBu0uQd0UjKOa4i9hRCtt3vrFw9DKEMEU
	bIFab3EcFQLMXHjZMtQnNU1cICDEWuTeeR1Yg6yoLshr/QHs5nXQCCN6pJPuJR/J1PuGzRngmsc
	4ZSFaMd7SPQSQwYL9pnU48ys0fdO/NKo2q4wdQnnjwnl/SBFpc94y9edwJTnLIo79t07TilZkah
	UBnpnSjNLYcq6fgMD75e2uyq+sy8wocMIScI+ft3OGuV13HjMeR9JUGbGny3coVGM1snnMcPUYg
	CND3x1BeyjKyaR4=
X-Received: by 2002:a05:600c:5246:b0:434:feb1:adbb with SMTP id 5b1f17b1804b1-436e271d5d6mr185865255e9.31.1736765800924;
        Mon, 13 Jan 2025 02:56:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH+BRgJuFH5H5TuTYWmTL0xnS/ANrc8IOsYYBRorVvUh0h5E9NVB5udF6X1PquPeA7N7buHSw==
X-Received: by 2002:a05:600c:5246:b0:434:feb1:adbb with SMTP id 5b1f17b1804b1-436e271d5d6mr185864985e9.31.1736765800561;
        Mon, 13 Jan 2025 02:56:40 -0800 (PST)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e9e62133sm139003545e9.33.2025.01.13.02.56.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2025 02:56:40 -0800 (PST)
Message-ID: <3e23b5b0-963c-4ca1-a26b-dd5f247a3a60@redhat.com>
Date: Mon, 13 Jan 2025 11:56:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] RAMBlock: make guest_memfd require coordinate discard
To: Chenyi Qiang <chenyi.qiang@intel.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-7-chenyi.qiang@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241213070852.106092-7-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.12.24 08:08, Chenyi Qiang wrote:
> As guest_memfd is now managed by guest_memfd_manager with
> RamDiscardManager, only block uncoordinated discard.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>   system/physmem.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/system/physmem.c b/system/physmem.c
> index 532182a6dd..585090b063 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -1872,7 +1872,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>           assert(kvm_enabled());
>           assert(new_block->guest_memfd < 0);
>   
> -        ret = ram_block_discard_require(true);
> +        ret = ram_block_coordinated_discard_require(true);
>           if (ret < 0) {
>               error_setg_errno(errp, -ret,
>                                "cannot set up private guest memory: discard currently blocked");

Would that also unlock virtio-mem by accident?

-- 
Cheers,

David / dhildenb


