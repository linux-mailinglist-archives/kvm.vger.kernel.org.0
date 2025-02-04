Return-Path: <kvm+bounces-37255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0486A278F5
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 18:50:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39C471670A0
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 17:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0F32163AA;
	Tue,  4 Feb 2025 17:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g+Kfig3K"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED40215F74
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 17:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738691427; cv=none; b=HM/HorcwLOo2Qm0VZhk6C8D/0v0A8w+H2LqAJr8d6hCvZ/REs4+j0tk+HF3+jvh+OgO/jMbmM1WNUuHNXlnBtFaq47KD5AynZR3RjdrUDXjPq4YcswK62GrzCl5otC2JolLEDSsz643cBt/DRTBXDe98YQlxQwEnA6bbU/n068E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738691427; c=relaxed/simple;
	bh=fDOCUG4Wa9wQYfo76718L/VAMknz9Dzh++Xf+8VgtXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d+k5JVmtMmcpN8kHLELA48Tm2IPWKm8Yrt2UfdEmF2L0f6BupcsJG7+m2Ys+mKam1z1uDuiqzf0Oj9ALykGtXLCeqSnXINWcgz7dxe04kE13kC69fctCoHJouziRfHFM/jxCTb0ytpv/YBPM+nbFkEBC1AXzPi+HMrB+zQuMGrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g+Kfig3K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738691424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cCAfUQtOu7IcGoh9whRLfLqU6KGUvoUvxjONbv3P3nc=;
	b=g+Kfig3KQwESAph+yHmRK86AjiURy+aOOkYFH46aFEET6QDIt1gx59yGQXa4aw+reNNWS+
	YiYC2yhHOmEprIyzP+nId9EMw+vODckMYFi34H5QMU4TGMB8k/UsJYprP4tzWejozVJRgl
	TlbMh9unZJ0ERCnUtYElqjxTSFYvO60=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-hL5p7Qt0Pla_-t6UJ2CJsA-1; Tue, 04 Feb 2025 12:50:23 -0500
X-MC-Unique: hL5p7Qt0Pla_-t6UJ2CJsA-1
X-Mimecast-MFC-AGG-ID: hL5p7Qt0Pla_-t6UJ2CJsA
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-436219070b4so30906245e9.1
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 09:50:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738691420; x=1739296220;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cCAfUQtOu7IcGoh9whRLfLqU6KGUvoUvxjONbv3P3nc=;
        b=s/ZC9I7SXogrMr7RMF4oR43dOuqc7tvys12ibsLglvzr45azwnxYuu2XvU8IJopo9c
         b4J3xPzmpLJALv0GBirTlrvtBUzvN9vEGbwfTCvmR6OQMsYa9TsTntpaydNZE9lnsmuL
         Ud/uklUbzUFvVCMtfDRvO+OwsBU0L7ceb2jb5F1+BX9zFKc4gvFKJwtnEL/2VrQgJo82
         aZSVAd7KK0fZfQauomi+ltJt+wohhK21AdQTrTM/jZCnzZU/ptFShg6fAe6evXzFUIM2
         VnDVzjHCQxYmsqEBXdSWtWFUHr6iD/ler5IVVe+cvvWZbEMm9H4ybh1MjgXjXH+AtEvq
         9tkA==
X-Forwarded-Encrypted: i=1; AJvYcCWGg6nuSpit+iwJNjIFP8eEt8lumYx1pqZSk06PtnCr6JG32EhuKhNBMRjJzMvk2tBnOlI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0opoU7cIxXp9S2PdqSzOHsX8wP9aypqMdz8fsNAi6Fl7jCI/T
	vaJ4dUOqudrqbCXpR7KMgBAT1fczjiRBgDcJxHmIjlb36jCXM1wxtrb5S21aTyszQcmm67b2EEi
	ud1rdtqdhHfZECV+wTVzz9HnQQoRUgKJuMi8CamY+Wp+9eHhTkw==
X-Gm-Gg: ASbGncvE82I7Lytk0YuQa9/pIcmcBY1s5gifXRESQGvMzm5E7s4umuv4gX03PcairSM
	4QMtdxM4JVh87vKgazZdTk12Q8iL2n6nMweQ07EVClL0le4PDKhqKOdFUwJAj88B2vADzmBUq8h
	V0P5lQflZiADNZwmwBTghWeMpusXBEIT6r7DHLaZmneMdNyCLtmYAEKck3MMTX2Wf2+nhdS+69R
	3vrZ6HzVFdw2TeKnv+zAakeJQ/ltlteM/izGqcxotUwQ0BuCH3hotuqKCxXNrYqAIOH+BPhWtRS
	CFlmuUawDrdZUWzfVELZYFxNwx+hJbBi018esuI1Ol7sjIBcmpi/xSeQOt9eTJelj1XvLFJrehq
	XOY8RK56sSZyABbm1EKa6rYCdrPw=
X-Received: by 2002:a5d:47a8:0:b0:38d:b1a5:3f7d with SMTP id ffacd0b85a97d-38db1a54457mr897904f8f.5.1738691420547;
        Tue, 04 Feb 2025 09:50:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFKHaQ78txw70BlPWkqNs3FNC+578qbzMprMfPcUy14Rd4z5YUhWmjXpg8KqoyDaBgkv2j1BA==
X-Received: by 2002:a5d:47a8:0:b0:38d:b1a5:3f7d with SMTP id ffacd0b85a97d-38db1a54457mr897890f8f.5.1738691420179;
        Tue, 04 Feb 2025 09:50:20 -0800 (PST)
Received: from ?IPV6:2003:cb:c70a:300:3ae1:c3c0:cef:8413? (p200300cbc70a03003ae1c3c00cef8413.dip0.t-ipconnect.de. [2003:cb:c70a:300:3ae1:c3c0:cef:8413])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c5c1b547csm16633215f8f.62.2025.02.04.09.50.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2025 09:50:19 -0800 (PST)
Message-ID: <7a899f00-833e-4472-abc5-b2b9173eb133@redhat.com>
Date: Tue, 4 Feb 2025 18:50:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 6/6] hostmem: Handle remapping of RAM
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <20250201095726.3768796-1-william.roche@oracle.com>
 <20250201095726.3768796-7-william.roche@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250201095726.3768796-7-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>       /*
> @@ -595,6 +628,7 @@ static const TypeInfo host_memory_backend_info = {
>       .instance_size = sizeof(HostMemoryBackend),
>       .instance_init = host_memory_backend_init,
>       .instance_post_init = host_memory_backend_post_init,
> +    .instance_finalize = host_memory_backend_finalize,
>       .interfaces = (InterfaceInfo[]) {
>           { TYPE_USER_CREATABLE },
>           { }
> diff --git a/include/system/hostmem.h b/include/system/hostmem.h
> index 5c21ca55c0..170849e8a4 100644
> --- a/include/system/hostmem.h
> +++ b/include/system/hostmem.h
> @@ -83,6 +83,7 @@ struct HostMemoryBackend {
>       HostMemPolicy policy;
>   
>       MemoryRegion mr;
> +    RAMBlockNotifier ram_notifier;
>   };

Thinking about Peters comment, it would be a nice improvement to have a 
single global memory-backend notifier that looks up the fitting memory 
backend, instead of having one per memory backend.

A per-ramblock notifier might also be possible, but that's a bit 
harder/ackward to configure: e.g., the resize callback is passed to 
memory_region_init_resizeable_ram() right now.

-- 
Cheers,

David / dhildenb


