Return-Path: <kvm+bounces-38672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9195A3D8EF
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 12:39:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91579188879B
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 11:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 477091F37CE;
	Thu, 20 Feb 2025 11:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DCV8ms4m"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1CA1D63C2
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 11:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740051461; cv=none; b=dsAprxX4uueDvADjuFLx78aKKJhyKt5+IfJ759zDkYqP22l/qRVWla4uFk9CbaFCopi30+hYsAw7mE+PHOv7Uyvf8HfDsrgXLAwcAIEjF7uEBAccQB3Xf6d4U9o+my0ferTCpOCU1wtkQy73ZWw9PzX4uOO3m62JDtwXEgMA9wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740051461; c=relaxed/simple;
	bh=5xUt3v1R/CIqoTUbVQl5lKZKgZvLzDbY0JMzm+/VETE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bW10HbFL/wDtOPjf0nzfl59FIBIJVFiXkxMeQu84lRVDgpN6VJQbd42dYJ3bE66nBW62FvV3LRR2HWOrXsL5H17dcXEibCGK4+H9UOUzUW6Y2Nh3nPdtOwOVDPeunhfUxwKy0eBP6ccB+aIDVie+U2or3s9Sxa4SWpynw88TwEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DCV8ms4m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740051459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jcQmx6fCwwby0EdwPPI8FmiWVsYZp8K+x+USnDpiaw0=;
	b=DCV8ms4mhdAzwW++DD1yvx842MeobJH88XBYy4/3MKEh6c9wjkGSwFBQCoXs1lr/UgXtJD
	i2p2iBMBVUsnrbQ1fQJQyifYxFsPcOf6SLwqW/tYnZ7H8UwQY/emq7wZwfmHyPlFfVt71L
	44N9mgYUbHx0i22Uul4ohHrV2HS/ZjM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-132-hQO3msdoNpSEUVe30TEgiA-1; Thu, 20 Feb 2025 06:37:37 -0500
X-MC-Unique: hQO3msdoNpSEUVe30TEgiA-1
X-Mimecast-MFC-AGG-ID: hQO3msdoNpSEUVe30TEgiA_1740051456
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43941ad86d4so4083645e9.2
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 03:37:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740051456; x=1740656256;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jcQmx6fCwwby0EdwPPI8FmiWVsYZp8K+x+USnDpiaw0=;
        b=GBIqmRF15OHZqF7tkoyL+JvvPvu4oDx9VNV9mUynb9om0vXKsvIX07EuBT9xN8skUZ
         RYiBD/0Sl3vSDty+30NtWWmWGqM8zv7BnA78NvXoO1X3tlPNpZWmxeq9qFuNA5uAm+ok
         QHOLueyoQT8MQvZp5AFTAdB06XMDaUyXapV2sCXEQbBmxSGyvOUACQTKA05lunoxc94Z
         aazko+vpC8Gbe3EXBoUZP1q5OeU2ShOYBlY2sJ90N5+8clgja8cTk3rkj9JysAfuN+gf
         yfEDSdE5wwf+Te9cbTpiFj2ZnFSOOUXYz0qAZ1S8s0v1UnfHnak+/nTjR3txJ0CcXXo+
         04IQ==
X-Forwarded-Encrypted: i=1; AJvYcCUADReUol8wehWOHQ9m7Mt0oRLxWGsXXMp8HdIDjYs6Jf4SawwEaQlyucZgxDy5cEiRlmo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdwYSM6M2KLeOsFkvVqEJsGRhtWfTKccd0+XqeRCIev4cuMTNC
	S2CM9e2nbtbRYubQRAAmQquaO4csD+bQUdgOnLT9x0BWdNOtkjDClHFV7b68tG77INBK8m5wljn
	2NzZaROMmRTL33w4ovupEIWqQEdFG/24HQHut33GIcVbfYDAvXg==
X-Gm-Gg: ASbGnctXj36Obyw+eE3qfxNGC09HG0uDgBsockECpB5j1gFBoDJW0befRQZLI4G6mBl
	bYPwAEKrOfzFR9b3NTxu8wVAZ0olwHPNr8n/IaA8b1ICnurS1cSMO42hzPeWzJFlfRbRK6W3Dqu
	X4k6X5OLKh5YECFpxwyte0exFBIxdZIXI7iAYbnXS6snLVZetY0pMc2N4/1yQID/jbW3ACC2kfI
	jZeHR+pJyCwlBBnpqUeopjuZ4gwLW1WD66sKrCpULX9odRVnnGkucJ7ANMBQ8d3jsAGF19lnwS7
	q+T0Uv3HJdBDB9JFVlyxen0CWdg+pB3uuf+SmLpaXM5KMAAYLUhTp55zQH+RTqWIjUgKwQquRbo
	nVFNNnxTdly2PH0QjTA+5CNJYMG9lRg==
X-Received: by 2002:a05:600c:3582:b0:439:942c:c1b6 with SMTP id 5b1f17b1804b1-439942cc29amr85105415e9.9.1740051456459;
        Thu, 20 Feb 2025 03:37:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEXtDf2oBKhCqZNLcZj5Hmmm3+qvL5evag5oCcM5BxUR3P5arAyGsFm7nW9J2A+kP7LYORbuw==
X-Received: by 2002:a05:600c:3582:b0:439:942c:c1b6 with SMTP id 5b1f17b1804b1-439942cc29amr85104835e9.9.1740051455995;
        Thu, 20 Feb 2025 03:37:35 -0800 (PST)
Received: from ?IPV6:2003:cb:c706:2000:e44c:bc46:d8d3:be5? (p200300cbc7062000e44cbc46d8d30be5.dip0.t-ipconnect.de. [2003:cb:c706:2000:e44c:bc46:d8d3:be5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a04f8a2sm238630835e9.2.2025.02.20.03.37.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 03:37:34 -0800 (PST)
Message-ID: <9abf6dd8-919d-44a4-8352-ee350fec8ad3@redhat.com>
Date: Thu, 20 Feb 2025 12:37:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/11] KVM: guest_memfd: Add KVM capability to check if
 guest_memfd is shared
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com
References: <20250211121128.703390-1-tabba@google.com>
 <20250211121128.703390-5-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250211121128.703390-5-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.02.25 13:11, Fuad Tabba wrote:
> Add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which indicates
> that the VM supports shared memory in guest_memfd, or that the
> host can create VMs that support shared memory. Supporting shared
> memory implies that memory can be mapped when shared with the
> host.

Was there a good reason to not squash this into the next patch?

-- 
Cheers,

David / dhildenb


