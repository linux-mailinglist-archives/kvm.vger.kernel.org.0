Return-Path: <kvm+bounces-47681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CBD0EAC3BD9
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 10:41:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CA7C18955D4
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 08:41:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13C711E990E;
	Mon, 26 May 2025 08:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UC1TkN0/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219991DFDB9
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 08:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748248867; cv=none; b=oS+ArBiZ67iGeg8JagcvhQ4mnN7Ea3/+13DpuoZsMJImFuq1OfomJxBGqRdt/z3waUUYTuQHO97m6l7QLTM/72aylY1o/ECubAUlAmGOKEsGVU2tIRzdUOdxvU8TOuNieQIsbWzhyFwjbq1E7RvWTAkcsDqpKETlBNLxJbPW+b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748248867; c=relaxed/simple;
	bh=RM9w2GB5PustMhTtUEFtQgzDYegYWrx4oF+aPu3tkrk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hN3ZFBTde8cRYM4OMPGWWYfpSby1YUzfy/XyBmp7ZxmSCr4RuUv1NXYbpgpXDH39i+1X3jpptCEklD1Zt38ccPqHWUPdt2oZN5YxloVlPezMz1wWLb2B4u4y5ieykQ/qC4lGA3jfpJPz6ZG079TnO8LKlpvD/PLyXhT6P6Tj+sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UC1TkN0/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748248863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZpcUBhTst15dsBOEnXLvH1gi6TvxGnz3SV2jdOZSxv0=;
	b=UC1TkN0/qCRm6/dHWW278fFQRYLNc3L3HGpymtXvjhpUEcBqSntf4HjV5UXgYeNzFXgc0r
	edCIpPHR+HNWbF+yIIoW0whKKh0T9vTMzrCoFkj+zxjkkD0u7SC66wCYpvyXik/y6jnD5F
	H8MOCsFtwq6HO3Q4rCMuOK8km/viRS4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-P2AKRccOM0qAfNlXHeMTgA-1; Mon, 26 May 2025 04:41:01 -0400
X-MC-Unique: P2AKRccOM0qAfNlXHeMTgA-1
X-Mimecast-MFC-AGG-ID: P2AKRccOM0qAfNlXHeMTgA_1748248860
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43d734da1a3so11771415e9.0
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 01:41:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748248860; x=1748853660;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZpcUBhTst15dsBOEnXLvH1gi6TvxGnz3SV2jdOZSxv0=;
        b=BO18hkE47FPfYIOIHzHZulQAg4vetayidtbaQIKnuwQPEwokQIBwcI7vBVroT6MW4q
         ms1jl/2GZNGE2Ns+cLJcrx+bCq5DM4CDvliOj+aG+03Gm8JTTDSKGQDGXoIaI3vMkR74
         nJERJT3ZSHsPbA70SO8Gs4XW9G2BbQsGbSXeOuADV83+wtX0CrJzrGgXUn8l2ueAbh19
         /40ovvhgvoapSqDxY8eceh8nxN3bgP2UJXKVam4qBu/GkLJB6J9TBKlB7nt6TrbINBx9
         8ToLrS4X4YA9MI0ERH3jn/CQcs+ovutIMZy/kMpxOuHzIm9I3lVWMGW5klBENAN0sRDR
         C6Jw==
X-Forwarded-Encrypted: i=1; AJvYcCXAl9trY8ukrQ3diIeKs6qVoP2N01gncAm+FtGK/UR+A9a3suSYQ3lvE2TQWFbi8UGXjc0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7ELmT80h5aHIukNnrhXqLv3bO8Edb4CDZIWBRQ/brTPsXR+2q
	zLzAaQtC0cmrltiYxHwnAoqtLVc/EJTb8xO+VSmGOrvybedZ/b7UOudKT3TlXYBi2Yo+fVZcT1I
	4hakQ+/y0IpKQp+lAxQEdK4hn3svYCIrzQXzXiv7waTOXiBDYp1fXow==
X-Gm-Gg: ASbGncsmFVuvSg2uLrZBdgmQ0aJMTsQToKx/wsEe64/2+IK0HjCyQnrNN5hBxqa4ZsZ
	hjFm8EzmyzvQ5SnYwEqUyTOWuOJHqGrRdLbDAnmRbcw6afovA18SWmCyWGZM92niPBA1oEZDZEa
	Q4i2tEyusjWeY+0xfIIBpFlehd5JlovOBC5ceB68iNcuKYM8Ez1J3fA3uKQL1xtmMCBQRfPRyJf
	AwcKUuHMbQZe+kOcGyIfwEvsMRBc+VMQYVkk+RqTotFvQnNT2ExmBXxscM/R1cYXKSL9bggwi5L
	O+g2+wco9vwSkRD6kEWMy3YJVMHG9k1RAZKUxEENuTbNSqhOhK3yqyLOuVt9vrT6FY/d1qjQ/lL
	L22viVvaK31I5CymyPOKMtVtFhqr4c9sJTvYLp+I=
X-Received: by 2002:a05:6000:430c:b0:3a4:de13:2a25 with SMTP id ffacd0b85a97d-3a4de132a86mr410806f8f.45.1748248860485;
        Mon, 26 May 2025 01:41:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFOT0PRDQkw2BbtqS6ln5FEsK4w1cAtNG/jx5p3gGTCCdC12E+iPVZbLd1eljg2uUrCLTNfHg==
X-Received: by 2002:a05:6000:430c:b0:3a4:de13:2a25 with SMTP id ffacd0b85a97d-3a4de132a86mr410776f8f.45.1748248860127;
        Mon, 26 May 2025 01:41:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f19:6500:e1c1:8216:4c25:efe4? (p200300d82f196500e1c182164c25efe4.dip0.t-ipconnect.de. [2003:d8:2f19:6500:e1c1:8216:4c25:efe4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4d7a5d224sm2962324f8f.41.2025.05.26.01.40.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 May 2025 01:40:59 -0700 (PDT)
Message-ID: <87d5e6c8-01c8-4981-98e5-f92e29157240@redhat.com>
Date: Mon, 26 May 2025 10:40:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/10] memory: Change
 memory_region_set_ram_discard_manager() to return the result
To: Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy
 <aik@amd.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-3-chenyi.qiang@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250520102856.132417-3-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.05.25 12:28, Chenyi Qiang wrote:
> Modify memory_region_set_ram_discard_manager() to return -EBUSY if a
> RamDiscardManager is already set in the MemoryRegion. The caller must
> handle this failure, such as having virtio-mem undo its actions and fail
> the realize() process. Opportunistically move the call earlier to avoid
> complex error handling.
> 
> This change is beneficial when introducing a new RamDiscardManager
> instance besides virtio-mem. After
> ram_block_coordinated_discard_require(true) unlocks all
> RamDiscardManager instances, only one instance is allowed to be set for
> one MemoryRegion at present.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


