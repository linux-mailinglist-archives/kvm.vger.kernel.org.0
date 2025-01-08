Return-Path: <kvm+bounces-34849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5F18A067A7
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 22:58:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6C223A7089
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 21:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 545872040B0;
	Wed,  8 Jan 2025 21:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Itl/xZvR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BD51A8411
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 21:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736373495; cv=none; b=R8Pf9A/J9NBh4/ca6lO778NfSyZ9dXdV5RWn5rRcvWVZaaoUc9LfYRMYoqK70Z8sXLQMph01F2ZVqfst2uBtBEr3jQ37sEnhiEaPk5YuXeqdHwetJV1XMIfOsqDl6xg2VLSNjk7az8VDyQA+/YOIgIrHEHIL84BYgsfEvC0UTHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736373495; c=relaxed/simple;
	bh=VFxS6IVlzinJoQmrxhhGmMY2lTuIipJb30aOmBNZ2Rk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KRtugOpWgMQ3l3PI1MZ78N72ENMTWgLsumFmRFkO/BgdSTR+F0/ljg4ChY2Rvd0AYDmQYnkxAJCLlA/AJ/taFxiWa8UoyuCOW3xk1q50waYzHAZ8JsS8z2bKXAqsQGvCleIXUCIAWE22B/KUX5//mJ48z+k3/YIPtr15yAjSsCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Itl/xZvR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736373492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VZT12k8zyiJJctayBGmmsPk5QVebozGKzATCMYJ680I=;
	b=Itl/xZvRXLgOpVlc34UUzRg7EQ5cHEQVAdBMdTvpDDyTdDwioV/T8bCoxP1OtaIpBN9tvM
	Z8XhHaCRyU//aeHPsS9TTu40glCe6jmu1glvio6X1TFttb0LPOKV8djZ79OBFItsfmSFZY
	Ho8z4R1n+xpOhcDBirl+XVd7DOp/8Is=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-fdES6T1UNKGIR2nF5kh7Gg-1; Wed, 08 Jan 2025 16:58:11 -0500
X-MC-Unique: fdES6T1UNKGIR2nF5kh7Gg-1
X-Mimecast-MFC-AGG-ID: fdES6T1UNKGIR2nF5kh7Gg
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-385dcae001fso86908f8f.1
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 13:58:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736373490; x=1736978290;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VZT12k8zyiJJctayBGmmsPk5QVebozGKzATCMYJ680I=;
        b=VtCjGd8Yyn6oI3E3agqIXoiWfqt/6BGFxNrK1rbr6TEDmjmHEA8DIgVJOPTakrpOOC
         4iqEfQAzl8llnB9ftfsY3qsXRmSLK1VpzsKBcscLY3kSG1xNC55zUWc/UDGegvXaVZwu
         fT0rV0J/sIHyDr7GXASZCbzNXjvD5kYn7khqsRyGNSNb4YYIabM42tXue0EVMxUFtAHe
         y+lJJ0T+TPXLV2XcDbPkg2hP+7IcliMMJAmQO4CR7lYcJGpPLlPf6BPQ5TZHM7Do/p96
         ZleaYbo/mW/8BnCZHPZ7SG6Iqdqi7guk9AOs3KK72Ft4G5rYu2cY8AD4suoHNk+6mUYg
         jbzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWaHiDzenp93Ipsn4byAGF0oqWIX582t4ZPs8I7kXCQyq940ldeF+EP03ANvHxsqh2tR0M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+3AYGwACsmJcs9qwMULozFVHD24Gtl/O1ai2QCmHoFYpGZ8Ls
	Zc+3G1rOjDLEr6oZxp6zCGI+NL03oCxVVguKMoE2dooaJPpr9MRJkkaQQqvwiOmROb/GfEUYyWU
	z2I4UYCZOaQgBN+pAm44wNuwAw/GDRcn+HPkO7K4Q/ZUN3QUZWGb/5f4YkkcL
X-Gm-Gg: ASbGncsIfehtFr/N5RjbIK9an+l+t/wjiIB5ozxaONMXa6RII84wXXTNM1TofTU2LRD
	KHsQoQCJLByzB5TLYl2itZqqXjDlyDNtBHCrnVj2e8a03OjzwiI3BDPCt0POEc1ig2H5pIQgvNw
	QUOqppJ0mJLRZiJi3xnaRdO77oPMUwFBwmdqmQHWx3BXpTtga7RtHvloUtIF1JVjvkwpg0/GyAC
	pM6uwxp7klRV8T8vOZNxaGtq9SnqtHqqBUMaIWa8JgFt97qI1HJ0cj7qPLfXEjzRkFePRVwBBE8
	rYjMQGwSvcPpCNX5UWe+PTQ5xdb0epuT0V+n1B5Fgh6ZEx72KY88YTbSoq507b0xsdeRjLJmAIl
	mswlJLw==
X-Received: by 2002:a05:6000:4022:b0:386:459e:655d with SMTP id ffacd0b85a97d-38a87306d7bmr3618361f8f.20.1736373490403;
        Wed, 08 Jan 2025 13:58:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IED5L3QNm0ccYZa2iABw/WSGCd6JNXqhK/014y/yN+xNteWP/agfFRhwV9pFvl4fnOZ7FGBhQ==
X-Received: by 2002:a05:6000:4022:b0:386:459e:655d with SMTP id ffacd0b85a97d-38a87306d7bmr3618347f8f.20.1736373490093;
        Wed, 08 Jan 2025 13:58:10 -0800 (PST)
Received: from ?IPV6:2003:cb:c70d:3a00:d73c:6a8:ca9f:1df7? (p200300cbc70d3a00d73c06a8ca9f1df7.dip0.t-ipconnect.de. [2003:cb:c70d:3a00:d73c:6a8:ca9f:1df7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e9a51bbbsm729705e9.39.2025.01.08.13.58.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2025 13:58:09 -0800 (PST)
Message-ID: <5e2a7936-498a-4f65-923c-353f7ca1ab17@redhat.com>
Date: Wed, 8 Jan 2025 22:58:08 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/7] hostmem: Factor out applying settings
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241214134555.440097-1-william.roche@oracle.com>
 <20241214134555.440097-6-william.roche@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241214134555.440097-6-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14.12.24 14:45, “William Roche wrote:
> From: David Hildenbrand <david@redhat.com>
> 
> We want to reuse the functionality when remapping or resizing RAM.

We should drop the "or resizing of RAM." part, as that does no longer apply.

> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: William Roche <william.roche@oracle.com>
> ---

-- 
Cheers,

David / dhildenb


