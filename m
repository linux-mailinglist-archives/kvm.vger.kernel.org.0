Return-Path: <kvm+bounces-53242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 888ECB0F3D0
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:21:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50440188D288
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 13:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2CBD2E6D31;
	Wed, 23 Jul 2025 13:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B2HVZQWc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AE32D29C7
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 13:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753276645; cv=none; b=L7ssxWtU+339B3Wz68q4p5+qq2QUDXN0SPoGJK4nnjESMNswQobZgvqYzTjrz4mo0YiH7eEAH958Yso8Jo0/KD1us4HjfjJ3GEgwh5m8er0fyy5D83XBE6le3Y4rBhny3bflJcVHQiM0PRm8TYlpTLQr5xxxf1HgP5tfOwNyYyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753276645; c=relaxed/simple;
	bh=sr1UX7CzeB/+TLcdngnIcc/1/Tgw0s4VOGi12Fb3WLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FQgro+JBT3oov6qVAmISBP8u93Ob56fE6+0XzIse32gpX8wcyWBIPaGBhgmK7g34EaVFLLnasttYHb2bZfAEGh3VUaX3C/2voTVhUu3MvgtseHmnu/RQSyFja39KiV38Fz77/ojAhX7LZcI/9+lfXYVgjewtuKehjAlnFEAMaIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B2HVZQWc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753276642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QUvOWYi7qqvGYE01TjZyNH5FIGW2BUt0z90QQ23/hCw=;
	b=B2HVZQWch2O7OKUlVCI+dDVSBMMFDmFx2z/uKIEPi+NgE53Eaf/lSkbpsG+jp4wXoCjptw
	ZmFg4vd7PHgi/1TH9Mbkrhr8sqREOocJe65UuOryesyJLJ2FnOlZGj6KCVp22QLq1Yz1on
	kNkrWckFLwNxlsNnnan57q8avKT69ZI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-207-TXHcB9cSOuuwj57zvx474w-1; Wed, 23 Jul 2025 09:17:21 -0400
X-MC-Unique: TXHcB9cSOuuwj57zvx474w-1
X-Mimecast-MFC-AGG-ID: TXHcB9cSOuuwj57zvx474w_1753276640
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a503f28b09so588541f8f.0
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 06:17:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753276640; x=1753881440;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QUvOWYi7qqvGYE01TjZyNH5FIGW2BUt0z90QQ23/hCw=;
        b=OGVdEJsHoPnD6eyXm9kYQOSsMczteQJr/4RBEljpEgc106feDitZw/meZT7ki2E9nI
         c7wCjAGLv0kcSH9I4jaEJIPIFUP/rYiujx/z0T0U2d705IpDtQNepARh4zMs5yzFRpnx
         binRc9KyY7hDzHSml/nltUADMSzCqohy+ebjPFZDqOTGtCnqdvzHtrqEM0i4akU4cFXM
         YG4s0V2mT4/8EBl4PgMcb2k26cpGaNqErZ1Ts+rWWrZsjAWG2CXFB3CF/8NSN+7J7eMW
         Y7rS5ZUETTaT8C2TGDE50lGPXf8OEMPdbCzNKAvvF90q/TWOx66tSvC/C6zD/Z8cfB5J
         bBnQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0CdvDEOl02VVn82QUf0MvQ3TlfAljdctsLKrlVKelGS/QsXT05W7we8iwaF+VCYDT2LA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZuVG4XQZLIOs5+JyiY8PLkQbZ0oKcyVAPUqpS7KUxBhxJQj0a
	T5qW4dtx6Ubc7UVFWAzdZ9RYMjMGM7fOxEq/QO+++fg6x7Oddf/ecjoY3oOceaaa9KSBG13CDeH
	QLaS4FvTf9psrWx51Aa5Ft/7zvZvJ5IJDTPLmE+59JMEhz/BC/1aPwQ==
X-Gm-Gg: ASbGncuiuMU7VYv4jz555e+5amZjp8wanKZEA7UIpbeikC4CFdpt3gupnfrGLN9NFw4
	lmRjIWWx6y5wEq7lvH/H68kK+PcbVERUatxO6d8LhX2vPigh9LXcGX54RLP8Z1W62DxE0BcnVD5
	1p8J9taPfUzH/XxrVdejia/qxk7RwxU0Du2DXuYdlyS4qTe6ANEJ1jubSPOdjEja08F6g/O9AUK
	lTZ/fgIKrhsgoWJztaLD+GnZteMWNhwlcp/WOAvb+JwLI26txVsF4SzOmoyconLrCOdALJH/m93
	acq0Tx9xYOffQxuV1bqqQRzJJBQm70FIVIr2Hvv8G9hfm94rSIhXrZQ22hNf8vBwYLrGFSMOZo6
	+2K3c05ZZVMtYzhaZzuZFZNM06qQxJBPhKhqie3LcoeM4IIpzGwE89D2zzNAgLjES3KY=
X-Received: by 2002:a05:6000:1449:b0:3a4:ebfc:8c7 with SMTP id ffacd0b85a97d-3b7694beef4mr2628844f8f.8.1753276639716;
        Wed, 23 Jul 2025 06:17:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGs9I1KLbQeMu1ajtdHhYyM5hqYLgRpOaRoFft+2iVCe2Ctcg0/AKmdicmyvq7Lk8vhHyXlWw==
X-Received: by 2002:a05:6000:1449:b0:3a4:ebfc:8c7 with SMTP id ffacd0b85a97d-3b7694beef4mr2628761f8f.8.1753276638372;
        Wed, 23 Jul 2025 06:17:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f00:4000:a438:1541:1da1:723a? (p200300d82f004000a43815411da1723a.dip0.t-ipconnect.de. [2003:d8:2f00:4000:a438:1541:1da1:723a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca2bb96sm16449200f8f.30.2025.07.23.06.17.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 06:17:17 -0700 (PDT)
Message-ID: <8ef1ddd4-6597-4897-8e85-e839c1759889@redhat.com>
Date: Wed, 23 Jul 2025 15:17:14 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 09/22] KVM: x86: Enable KVM_GUEST_MEMFD for all 64-bit
 builds
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
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
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250723104714.1674617-1-tabba@google.com>
 <20250723104714.1674617-10-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAmgsLPQFCRvGjuMACgkQTd4Q
 9wD/g1o0bxAAqYC7gTyGj5rZwvy1VesF6YoQncH0yI79lvXUYOX+Nngko4v4dTlOQvrd/vhb
 02e9FtpA1CxgwdgIPFKIuXvdSyXAp0xXuIuRPQYbgNriQFkaBlHe9mSf8O09J3SCVa/5ezKM
 OLW/OONSV/Fr2VI1wxAYj3/Rb+U6rpzqIQ3Uh/5Rjmla6pTl7Z9/o1zKlVOX1SxVGSrlXhqt
 kwdbjdj/csSzoAbUF/duDuhyEl11/xStm/lBMzVuf3ZhV5SSgLAflLBo4l6mR5RolpPv5wad
 GpYS/hm7HsmEA0PBAPNb5DvZQ7vNaX23FlgylSXyv72UVsObHsu6pT4sfoxvJ5nJxvzGi69U
 s1uryvlAfS6E+D5ULrV35taTwSpcBAh0/RqRbV0mTc57vvAoXofBDcs3Z30IReFS34QSpjvl
 Hxbe7itHGuuhEVM1qmq2U72ezOQ7MzADbwCtn+yGeISQqeFn9QMAZVAkXsc9Wp0SW/WQKb76
 FkSRalBZcc2vXM0VqhFVzTb6iNqYXqVKyuPKwhBunhTt6XnIfhpRgqveCPNIasSX05VQR6/a
 OBHZX3seTikp7A1z9iZIsdtJxB88dGkpeMj6qJ5RLzUsPUVPodEcz1B5aTEbYK6428H8MeLq
 NFPwmknOlDzQNC6RND8Ez7YEhzqvw7263MojcmmPcLelYbfOwU0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAHCwXwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCaCwtJQUJG8aPFAAKCRBN3hD3AP+DWlDnD/4k2TW+HyOOOePVm23F5HOhNNd7nNv3
 Vq2cLcW1DteHUdxMO0X+zqrKDHI5hgnE/E2QH9jyV8mB8l/ndElobciaJcbl1cM43vVzPIWn
 01vW62oxUNtEvzLLxGLPTrnMxWdZgxr7ACCWKUnMGE2E8eca0cT2pnIJoQRz242xqe/nYxBB
 /BAK+dsxHIfcQzl88G83oaO7vb7s/cWMYRKOg+WIgp0MJ8DO2IU5JmUtyJB+V3YzzM4cMic3
 bNn8nHjTWw/9+QQ5vg3TXHZ5XMu9mtfw2La3bHJ6AybL0DvEkdGxk6YHqJVEukciLMWDWqQQ
 RtbBhqcprgUxipNvdn9KwNpGciM+hNtM9kf9gt0fjv79l/FiSw6KbCPX9b636GzgNy0Ev2UV
 m00EtcpRXXMlEpbP4V947ufWVK2Mz7RFUfU4+ETDd1scMQDHzrXItryHLZWhopPI4Z+ps0rB
 CQHfSpl+wG4XbJJu1D8/Ww3FsO42TMFrNr2/cmqwuUZ0a0uxrpkNYrsGjkEu7a+9MheyTzcm
 vyU2knz5/stkTN2LKz5REqOe24oRnypjpAfaoxRYXs+F8wml519InWlwCra49IUSxD1hXPxO
 WBe5lqcozu9LpNDH/brVSzHCSb7vjNGvvSVESDuoiHK8gNlf0v+epy5WYd7CGAgODPvDShGN
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250723104714.1674617-10-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23.07.25 12:47, Fuad Tabba wrote:
> Enable KVM_GUEST_MEMFD for all KVM x86 64-bit builds, i.e. for "default"
> VM types when running on 64-bit KVM.  This will allow using guest_memfd
> to back non-private memory for all VM shapes, by supporting mmap() on
> guest_memfd.

It's a bit weird, because mmap() support gets added in a later patch. 
But I suspect this is fine.


Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


