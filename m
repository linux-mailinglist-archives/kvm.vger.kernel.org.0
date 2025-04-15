Return-Path: <kvm+bounces-43357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 46B43A8A54C
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 19:23:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D9841892AE6
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 17:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C08621CC5A;
	Tue, 15 Apr 2025 17:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bLOmJoYF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2590D19E819
	for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 17:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744737792; cv=none; b=SYRdVQeiMDDPq2ovlReTDtxjB61tENm7Se+6VbQycTcnbFKX9C1Fp1rO+cYfYlMQkiJC++MI+YTCAoGTkQARfBUTMvg72AwAhFhXCRuZVBtZxAKC4Epwml/cZWfInAwVoR/j0vDs4Xk57J2rP/uYe1/Q1DsCChBvri3m1VattPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744737792; c=relaxed/simple;
	bh=Y1JUWPISlkJt8B//Qod84czkkX1C5W9WGafAlty3jgw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lMv1xy/gYbflGkBMVp14E8XO7ClT6IdHkj/wADjVUPSBVnpQMhRQfasbqtJtyoV8ocQPzoFrd437Ijvb0MI6SklvJMi+0It0zYqrP2Z5TGSMbuMheA3J5vyVUmQRTMUn4kC6HJO+qGOWn4ISFa3bSkMI/ddcN8yIGk3gb/afa8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bLOmJoYF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744737790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bhSV341q24aO8EQtF4O9ohvrxfGYa7rxKYrPlGIJdUg=;
	b=bLOmJoYFdAYfwEg12nM1QDZ8aicULeyptngTWLeIP+FtOVeirCQ+ouZuy9I3ByFhmGEAMR
	CnE75EZD6SssP1j1efYJaOjAzYl1jtgwj5rAG79lBFcKF3PONmWXb1MC9z/TIxoZfzQ9eS
	pnSY8u2Y3CBjZupOiPTXQPRSeNLHBJY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-fe8xljIPNrSHwwa74j8Iaw-1; Tue, 15 Apr 2025 13:23:08 -0400
X-MC-Unique: fe8xljIPNrSHwwa74j8Iaw-1
X-Mimecast-MFC-AGG-ID: fe8xljIPNrSHwwa74j8Iaw_1744737787
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3913b2d355fso2234062f8f.1
        for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 10:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744737787; x=1745342587;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bhSV341q24aO8EQtF4O9ohvrxfGYa7rxKYrPlGIJdUg=;
        b=T4c1JqrtIXoXl1iaEuv1CP3syormQDbRiU8tioM4oWCSrJhHeBQOtE/n8ge18qqAld
         cZrHLKR+afNQUuIo4CbgLKen82zxZUagaYG8u6Z9No0yyXQWy0fXbKjBv5+jmAgblxnw
         uFGmTofwqfep2nRiGV9h+Qug3Y4danyCl9JKZl0FkQvCCal/1r049uz1dmbROcXD3fmu
         QQCfwnHABwPqieIozQVhfpyraFXRnkn5FCj0kQy76lPO1c144tghTt+eee9nEvR+PSbo
         P/e2QozawXKjtU2IgbvhQDeD2Kx2GsvD64gZD+2w3mrRbnYihfMlcxRTHh3Ul80poPA0
         f1Qg==
X-Gm-Message-State: AOJu0YxM6BPtOXsP4LROoHFU8fNXAtRC+ml2y6IyyuYSwc156bCwbMGU
	KAZFmZ5TaSeqU8ooOVSYenC8bIYw2iMXZ7yFNJsVEk/bhLBxtJwlTz9Ok2Y8tsYjfruAo/k0FEd
	bmht7hQHVwxO8c6YXs2APENSQL0NWTxcspNtUIowfXRFujmYYbQ==
X-Gm-Gg: ASbGncvk6DDFVqN0GWJCZO4e3GQUd0/oIVhiiS+Ng92OZiJFUzOZ6nkqdLYggGhC1Xu
	SiiPo+SVQPHExEMlihQsoXRBaFDqRrEZcojyJbOxxb/EK6VetCKPEXdxPNuLcBvoTo4hi/qIdX4
	grgXgatuIP0oGeIYS/mY6Jr6PHXEg0wpmxfoTfSIGuBZ8/JgZd9S3fwu3Ulkz5SpP12lgpzjmw1
	n9hWnotuekCdzY5x3fvrkFe3ev9wb7ONf8tiTJaPpDx5nNikBK0uaOEuf2xTcGtO6yg8Jz/mpMx
	VCXJ7HWGKTCmpNve+WaxNc269rZn/OQFazMY6jOmojweDSHxJBOr7AHVGdJ5dJJt3RBC9qj/h3y
	sF0j86xZmnQIAyXFyiIjXsaDG/U+ay0fOmzWDsg==
X-Received: by 2002:a05:6000:18a8:b0:38f:4d40:358 with SMTP id ffacd0b85a97d-39ee272a150mr306344f8f.9.1744737787182;
        Tue, 15 Apr 2025 10:23:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4OtdBioxAO9IjozxlQnFj1BS+sjgx5ZDKW2N/G7FZqybmVgYzyJbmNYE8JRuotcchKYMdqA==
X-Received: by 2002:a05:6000:18a8:b0:38f:4d40:358 with SMTP id ffacd0b85a97d-39ee272a150mr306300f8f.9.1744737786686;
        Tue, 15 Apr 2025 10:23:06 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f02:2900:f54f:bad7:c5f4:9404? (p200300d82f022900f54fbad7c5f49404.dip0.t-ipconnect.de. [2003:d8:2f02:2900:f54f:bad7:c5f4:9404])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39eae963fccsm14758626f8f.3.2025.04.15.10.23.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Apr 2025 10:23:05 -0700 (PDT)
Message-ID: <497af7b4-3884-499d-88e2-2b0053ccecaf@redhat.com>
Date: Tue, 15 Apr 2025 19:23:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/9] KVM: guest_memfd: Handle in-place shared memory as
 guest_memfd backed memory
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com
References: <20250318161823.4005529-1-tabba@google.com>
 <20250318161823.4005529-5-tabba@google.com>
 <8ebc66ae-5f37-44c0-884b-564a65467fe4@redhat.com>
 <CA+EHjTwjShH8vw-YsSmPk0yNY3akLFT3R9COtWLVgLozT_G7nA@mail.gmail.com>
 <103b8afc-96e3-4a04-b36c-9a8154296426@redhat.com>
 <CA+EHjTxuAE1N3NOngNGfZYxPb1AJPmrUR5vhHpv353YUjEgfRg@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTxuAE1N3NOngNGfZYxPb1AJPmrUR5vhHpv353YUjEgfRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>>
>> ... and ideally it would be part of this series. After all, this series
>> shrunk a bit :)
> 
> True, although Ackerley is working hard on adding more things on top
> (mainly selftests though) :) That said, having multiple series
> floating around was clearly not the way to go. So yes, this will be
> part of this series.
> 
>> Feel free to use my commits when helpful: they are still missing
>> descriptions and probably have other issues. Feel free to turn my SOB
>> into a Co-developed-by+SOB and make yourself the author.
>>
>> Alternatively, let me know and I can polish them up and we can discuss
>> what you have in mind (either here or elsewhere).
>>
>> I'd suggest we go full-steam on this series to finally get it over the
>> finish line :)
> 
> Sure. I can take it over from here and bug you whenever I have any questions :)

Just let me know if I can be of any help (privately, or on the list).

This has very high priority now for me :)

-- 
Cheers,

David / dhildenb


