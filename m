Return-Path: <kvm+bounces-36266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94BFFA1955C
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 16:36:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A36E1882F75
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 15:36:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD8E82144D1;
	Wed, 22 Jan 2025 15:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SQc2GEWI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B3F16BE3A
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 15:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737560156; cv=none; b=nmJRfU4+hNl+zDwD9cva84B+Ses6T/bYV73CTq2WO6nHaKY4cg0468X5wQNiVfBUJUUldve3L/vi9gqee62FcYdi0daKmzCADrsn7XVMAeSHoTvplftJVnARsmEqewbj0Nf6HvDr7XXXguuV0ObBXUv86Uj5vPcqVRbKXiXsx/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737560156; c=relaxed/simple;
	bh=Ip4NH+fhuRokBmenNFbP2yTN6gVeJlXM0m6WIrGcySQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fouimqrOroHizdm+H4SBKbwKgAADOYIrOfyQdA4B6NOctb9R9yux58SX//4ohNe7SUbe6HuSay452Xv752ecRM8GoV6ft3DrqW+wlns2W2/MEbGCk8IGsj+LoCCGo/97krdlx20oNXyk8p4gukLEEJ3x6a9RFwRN7tUMyy1dGPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SQc2GEWI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737560154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=q38EjAxJ1lDLlHHWV9Wt2ZVxFDpzVDPBJs/duV0zwkY=;
	b=SQc2GEWIHr2P+cl5skNwQrqEokhizFnEq9kWird2xPXvOgEteCIJXr2CM4j3IH1ZpKt16q
	2lQJq08gvFT2hiGsj8yCRB9yDY9odxVzN+Njra88n8uW8EgrrzlM+MHDP2ALNVtBZB1Cnw
	vuWBu3JbwBQB2OIaXmjDbAwqhGriT/Y=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-Abi17zJrMV6HlpLDyXAbHw-1; Wed, 22 Jan 2025 10:35:53 -0500
X-MC-Unique: Abi17zJrMV6HlpLDyXAbHw-1
X-Mimecast-MFC-AGG-ID: Abi17zJrMV6HlpLDyXAbHw
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4359206e1e4so55676205e9.2
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 07:35:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737560152; x=1738164952;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=q38EjAxJ1lDLlHHWV9Wt2ZVxFDpzVDPBJs/duV0zwkY=;
        b=WZXys0roSJPYquwmkqKhtJZMswwsYxCdwrSCzpa1VeqjFsIf3HYNFZNfhLCY5RHrJY
         TZ/Wye5bVIahdMrHykhBcESN51rZme3gxDSP9hdHaA0acWKt3WEPg5EILg5YFVv2GmgI
         jY8dShbyfv+Er223IlpVP1+4VOsav68ferhcBCZ0OfXGYCY61hcmTN4lbuk3qUVNHJYv
         dazUBn8ITQ36NlIj+fJC7rmUSPfwh8NdZklLd/wD3tHfBId4Ebd6SfkSR+aM8f/wDqrP
         VkegTu+q6OI8LyFJjsoBgjJb+LnNo2HzqMOEaQWb5d+Fzk+NF4M5CeAel9Xyy+RfFpIh
         3wlA==
X-Forwarded-Encrypted: i=1; AJvYcCUwedYyFViHLIpWAu8AINtg5Wgpr4Z9Leq6qv9LJHLIznQ9taGG8NJezNGHYjw2/69xV2Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv5ujK/xhl0XQ532L//vn+vuqouvoGGSnrlT+4yuYudz8EdZct
	qFy8WF2XJcRtDKSRnCYRh+fC7NM/IO3i07A7fvaZzAGe+ukRr7VFl4kl9f238s3R+NMIMwWb++7
	D4EZU94urHlna8GLIN1Re2OaEULIm1SdCB3A4qu4wY2Kwnizw3A==
X-Gm-Gg: ASbGncsjqVxvSoNNZbYGNzTAIoOL8jOsCsjr2Ybd6YfrRdUueqweUnt51VsOBXzPZHj
	+3/+DgAE87YkRZaRWazKtFU4gxcU4/50bz7ZrVXxWXOdhfJlEtm/vrMJGAZYetaKJrZTAJPBoo9
	jDQSlq1WTXj1V/+N+wbpHxFzct3EDjQ4uAqglxJExcL+CdLSXYrF5QEFV6UywijetIPiKK0MyYj
	hZ9rP9BEV9TK4Vh7yNZssxY2pR+mrh8u9g6o3b3whEcj3HsHrDq4zpRZT1KyZWT22atRFW+8w8B
	74o3EpokgRD+LxLmI0EE/LzHETtF6Dq2ayDxKi3rORPuP1v84cSZtNGSD8Zi/SjvYboY327kuon
	40HAdnFEgrULPmzjhhjdfow==
X-Received: by 2002:a05:600c:3d96:b0:434:a26c:8291 with SMTP id 5b1f17b1804b1-4389143b5dbmr192205535e9.24.1737560151627;
        Wed, 22 Jan 2025 07:35:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEmQa/wKYEFJo1rFWtlQvMZdVHgrCX1WxhMRt4UkLW8LHiu9pFpZn5xxu1YGH2sHPbzaS+8Kg==
X-Received: by 2002:a05:600c:3d96:b0:434:a26c:8291 with SMTP id 5b1f17b1804b1-4389143b5dbmr192204875e9.24.1737560151242;
        Wed, 22 Jan 2025 07:35:51 -0800 (PST)
Received: from ?IPV6:2003:cb:c70b:db00:724d:8b0c:110e:3713? (p200300cbc70bdb00724d8b0c110e3713.dip0.t-ipconnect.de. [2003:cb:c70b:db00:724d:8b0c:110e:3713])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b31df407sm29654035e9.37.2025.01.22.07.35.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 07:35:49 -0800 (PST)
Message-ID: <c15c84f2-bf19-4a62-91b8-03eefd0c1c89@redhat.com>
Date: Wed, 22 Jan 2025 16:35:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/9] KVM: Mapping of guest_memfd at the host and a
 software protected VM type
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
References: <20250122152738.1173160-1-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250122152738.1173160-1-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22.01.25 16:27, Fuad Tabba wrote:
> The purpose of this series is to serve as a potential base for
> restricted mmap() support for guest_memfd [1]. It would allow
> experimentation with what that support would be like, in the safe
> environment of a new VM type used for testing.
> 
> This series adds a new VM type for arm64,
> KVM_VM_TYPE_ARM_SW_PROTECTED, analogous to the x86
> KVM_X86_SW_PROTECTED_VM. This type is to serve as a development
> and testing vehicle for Confidential (CoCo) VMs.
> 
> Similar to the x86 type, this is currently only for development
> and testing. It's not meant to be used for "real" VMs, and
> especially not in production. The behavior and effective ABI for
> software-protected VMs is unstable.
> 
> This series enables mmap() support for guest_memfd specifically
> for the new software-protected VM type, only when explicitly
> enabled in the config.

Hi!

IIUC, in this series, there is no "private" vs "shared" distinction, 
right? So all pages are mappable, and "conversion" does not exist?

-- 
Cheers,

David / dhildenb


