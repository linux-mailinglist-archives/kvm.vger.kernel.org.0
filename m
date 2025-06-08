Return-Path: <kvm+bounces-48703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10CACAD15EE
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 01:43:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E1041686D9
	for <lists+kvm@lfdr.de>; Sun,  8 Jun 2025 23:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BF46266B77;
	Sun,  8 Jun 2025 23:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qb4TR9ky"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CA020DD48
	for <kvm@vger.kernel.org>; Sun,  8 Jun 2025 23:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749426186; cv=none; b=OXR6omEb8XxM1rYqzg/8rzcXUqBUbDPHcZHq8c/FP5WUowIKmsqJeJsgbqgP7xeCHOELTvyqqu51RhaX+iUuxlO+Mrl835Vi0Z6T3G2+/5F4E9l04cI6kJrMIY2HrFtOyPMEyMw6uwgwIyXcB+q8tlh/pn40/iJu7APkfnAR/e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749426186; c=relaxed/simple;
	bh=CIQ9YYwRaWcxV9gZOomLEuovngdq15gjETsoqhAJEM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QeqLgPPpv2RzYGhkwzKi6ggxyen65xj+vhr0JsLlx/FvuJ4TCTb1yGcDV9Zx+5YzsIBzoSx5GW5sP+mREh+njI85iHl7belWT1IIi5N1DuKMZFI/ycD/LY5Y/XcI/Bl6BtPBRoqSS+uEeZ0fqmYYOoqOrYi+G+Ux/FeIwYDqHq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qb4TR9ky; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749426184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sV7jw4zv8DF/228SxSyGWu8M2zC9Ud0L/iBvUN6Lp8w=;
	b=Qb4TR9kyau/8PCgyYwTKpTxKwTi5ot1QT8322Z7riANPO9rpWbLuaDXuKoelLcTM2SsEkW
	H1qBn+pYmNnMiOy/Po9Sb++mHZV/frzJe21OYnWp1txcwS6HnQlaqcsm/w8iKGTGuNRsWA
	p64cBJnCMU8Vxfx4sDhfVcqHV4K84zs=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-nASU13iAPSCQa9xmlnPe0Q-1; Sun, 08 Jun 2025 19:43:02 -0400
X-MC-Unique: nASU13iAPSCQa9xmlnPe0Q-1
X-Mimecast-MFC-AGG-ID: nASU13iAPSCQa9xmlnPe0Q_1749426181
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-234fedd3e51so32416375ad.1
        for <kvm@vger.kernel.org>; Sun, 08 Jun 2025 16:43:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749426181; x=1750030981;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sV7jw4zv8DF/228SxSyGWu8M2zC9Ud0L/iBvUN6Lp8w=;
        b=ZLYbmxD2it9so6cXqUak0eBf2ug9XSi7zcFcjYDi/IzQJ9415lU46Kp898GAAewq3K
         8W5Mze+ALmM0wKDuswqnOPuIS3gxt3oW3WbE0dGBXmir1Qy/OBShXe82HAr8uplbgMCJ
         7wX0f72m0JmcOHZjF50zmc/Gxs+2K3Vg+qsvqntHtsD9Y1hng8rwvpwief4Fn2avyfdP
         hkFgQ+1WCU6JgH9McZQrqFsWn2Ura0XKwWjVzvjJM9keiE4v7Xvegug+5VKCAfLUmh5N
         UScbgpT9MHMDK8E6p883CbRoh7Mk1+Icvf/NHEWBrf8QSBQPydzqNktX77G4vq6OG8yu
         MV6A==
X-Forwarded-Encrypted: i=1; AJvYcCXzQv+sPIDe6U+WR9YxaBg13jaZZMSX70FyYxL8EBRjYhN6oBbqh84gIKGh/Nk4H1cPt0w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz1lQ96nF3yF+rfXWjoJeNHYq3Zsuu88kilgcgwnnIPgQR+3cr
	hbCTpiv625B59jH+AWDR/O4XVMD8Sd3VnjsXvWy/UvKlOVPp45FD7RXdeZhuEQt28qo3Et905tQ
	3GOmega0XxotIZZYNopcl7fUinzeYZfGiUVmsAZx0v/vp2WLkXhFX6w==
X-Gm-Gg: ASbGncsaXeS31r6nZLW00C8OXGHym/g59G3uKXc3XDvwJwReeB22k90GothHIthGXkD
	8h8EF8KXCTfIKPcgES3RbJumYjouvesUBA7klTxLNKkNP1r9aNeQKlDd0Guke6WmeHDGN87uoRQ
	M9tcGxc42wUdWgjJzrswwuqBklExDbsW8kH2z6Qw4t+LCZlMSj8ZDoPw6d4HOFouSjcu0abjav1
	ZYq2PHdkeGuNSOB/MS13qJLxEAigETZov4X/9DPxBcUIZJnzfavVaM4m4dsu1L5u+3Q0sOdFdk5
	BB1awWt4ioLD/p77FfD2O3/kADtT6twr82j6hYT6vzpmb/mGjOQ=
X-Received: by 2002:a17:903:230b:b0:234:ef42:5d48 with SMTP id d9443c01a7336-23601d82cf8mr163243505ad.38.1749426181476;
        Sun, 08 Jun 2025 16:43:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG7bor77vjvj+YZaqMIThNhyNLCg9HXt8FW1PEgAUkMFTVnRH59XUdt2gBjoBPbQYitKhphEw==
X-Received: by 2002:a17:903:230b:b0:234:ef42:5d48 with SMTP id d9443c01a7336-23601d82cf8mr163242965ad.38.1749426181096;
        Sun, 08 Jun 2025 16:43:01 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-236032fceb2sm43669945ad.96.2025.06.08.16.42.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jun 2025 16:43:00 -0700 (PDT)
Message-ID: <af2fe174-492e-4eff-9077-a450ab393ceb@redhat.com>
Date: Mon, 9 Jun 2025 09:42:41 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 09/18] KVM: guest_memfd: Track shared memory support
 in memslot
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
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250605153800.557144-1-tabba@google.com>
 <20250605153800.557144-10-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250605153800.557144-10-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/25 1:37 AM, Fuad Tabba wrote:
> Add a new internal flag in the top half of memslot->flags to track when
> a guest_memfd-backed slot supports shared memory, which is reserved for
> internal use in KVM.
> 
> This avoids repeatedly checking the underlying guest_memfd file for
> shared memory support, which requires taking a reference on the file.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   include/linux/kvm_host.h | 11 ++++++++++-
>   virt/kvm/guest_memfd.c   |  2 ++
>   2 files changed, 12 insertions(+), 1 deletion(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


