Return-Path: <kvm+bounces-48394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37748ACDDDE
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 14:27:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7B8616D564
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 12:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4717128ECE2;
	Wed,  4 Jun 2025 12:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M3fNhg8s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD51528EA7E
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 12:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749040017; cv=none; b=ksTeJD2vYs7yof45g0a6DMV4oOIM7aBUe1iqMJyDz1SOZtsEo1Yvsg0/P5gj12wYIeI8VgkWWW47bigV0hqjPvsCWP/gNOJNW3iwDNfU+yz1AvJDgFmE/RaA6bhTjmn0mDiEYhNI3LEQRKSQ/ohtCAoJhEWICpqDYK25YqvVx/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749040017; c=relaxed/simple;
	bh=A7TqLIeJ5CLbMZAQ1Zg/O2PsiKyVkpr+YJ74zRbx7AY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N2hx1UbbeXILa22qJDx8L4VeereHeh8lKqFX4JhM6psP3GDtjqfmrESkNWIedGitLAuXCDJYG7AAG3esJp71GDYC27/JXeNaz7XzJ2xqn9bQ//ma0/o82nIPMVlSWb+YnRi3XxzmV4QU174PeHmsdDanpgLFlOYwaI3jimYuf6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M3fNhg8s; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749040014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Q+aRfq2GW38vhFS2hoYFrz2Xx/pbsUYxa82R0G/kuMk=;
	b=M3fNhg8sXWV8i8Go4o4JU5Y+ISrEgEF1mozzOqYTfex/uzdu8j7TUuSJ81dw/Z+AKVFiGe
	5gZtsZmrX7xyqo8/squPEonCnEklEASx8mXBeeBxWX39yBQQziLFKff64hxPovRw47DDWC
	JKn6aEKoNjA+6lbpM80wRFD79v+eS3M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-c145iSlbNBqKi5wLaniuGg-1; Wed, 04 Jun 2025 08:26:53 -0400
X-MC-Unique: c145iSlbNBqKi5wLaniuGg-1
X-Mimecast-MFC-AGG-ID: c145iSlbNBqKi5wLaniuGg_1749040012
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-450dada0f83so39817085e9.0
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 05:26:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749040012; x=1749644812;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Q+aRfq2GW38vhFS2hoYFrz2Xx/pbsUYxa82R0G/kuMk=;
        b=pAPV0PObUeoj5ydRSD9EBQtxAmFYocrXSTp71pu5FGePdj1AOyvFOrpTCvkalNe2gQ
         8KdopF1D29V0d3F3y4Pueo2KnFa2QR+RR2SNexLNkyXOy457EEUQ4NuTJhQj7RXm+x6U
         98fXHuSFwOnt7QSOiRDN+Bp7iy8XE/w1vqL/Bfn56xFm0++7iuQ9onMimqk7a7b1DyKc
         o5sID+APKIRo9axDc1gqimDSBdaQ1SEtenTBIcuoCuXmo0+BpF+WHtCRVMQ+VH7y9f8P
         cT83zFQN0x/g1xg3ftnyifUvBgeau3wpHMJGJQZXRLQ5ZslecbQpYRdBSbqSbNOE2D8c
         O1fA==
X-Forwarded-Encrypted: i=1; AJvYcCU9fvMcQPiHY+3mnm0MwdKSb2m5JYlOWrFIWqGi+h+NuIAy9aah2k50pKGKnCAKQXUAr80=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7ohTRyVtlJhm5HnfdVuW6oFvKaq8wYmfRyzeqHcOOewL6iFbx
	eG7+e2c3bh9KtVBSMe4dYcFhdzyoG8uHDfOKioXgzhXPhqxfxvAcRxhreeeyVLvs+BlMqc8a74r
	SkVyP6aCF3qWVZKF52OMFlwjwjvG+3jiMaa6iKoI7xasqbHlM9hkREw==
X-Gm-Gg: ASbGnctEjJbfIgT/zeNriLVuZdalY2EgGXhK/kmvM/wfNwVlmvFfujayyxnQ9tEGdJR
	WTYKyyl/gajvWznLfF3eXhsGHVMBlbpgWSwYoZtY4d3VQma883Smgl2TneVbvOIYsS7se2O5Mt/
	CNokfFhRMSZ5hO3uuJoDNGwCbERp6M6N0sqnE8rBZqDIohk9rYwbrfG8y5BF3xpE0HIjHi6lF2i
	GK/2b7bKFCcYg4kiCIkNU2NUM1Ae7G1/GhUCw8Cn6RSY8m401aBaLEz0b2lnD7yE74+UzO46KoP
	HcXu7T3cCGo7Zc8q//WvruXJCGKLP61Rus1nU1JoSnEFsAjS56/EW4n/sdEgDPpkZzuG05nTJkj
	Bmof6tZay6uh4WizHlcKqdiTfngXLy2oxi95cnac=
X-Received: by 2002:a05:600c:870c:b0:43c:ee3f:2c3 with SMTP id 5b1f17b1804b1-451f0a636ebmr22965525e9.7.1749040012487;
        Wed, 04 Jun 2025 05:26:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFExWHzdiWQndGAxNRarobM5yA3gJhRQVXlyu2LxUdQOrlj9R1BVLaEKWqX19XbJI84tys7wA==
X-Received: by 2002:a05:600c:870c:b0:43c:ee3f:2c3 with SMTP id 5b1f17b1804b1-451f0a636ebmr22965165e9.7.1749040012067;
        Wed, 04 Jun 2025 05:26:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1b:b800:6fdb:1af2:4fbd:1fdf? (p200300d82f1bb8006fdb1af24fbd1fdf.dip0.t-ipconnect.de. [2003:d8:2f1b:b800:6fdb:1af2:4fbd:1fdf])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4efe5b92bsm21276266f8f.9.2025.06.04.05.26.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 05:26:51 -0700 (PDT)
Message-ID: <b497b0aa-a8bc-45b9-9059-71dbbe551ebb@redhat.com>
Date: Wed, 4 Jun 2025 14:26:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 08/16] KVM: guest_memfd: Allow host to map guest_memfd
 pages
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
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
References: <20250527180245.1413463-1-tabba@google.com>
 <20250527180245.1413463-9-tabba@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250527180245.1413463-9-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27.05.25 20:02, Fuad Tabba wrote:
> This patch enables support for shared memory in guest_memfd, including
> mapping that memory at the host userspace. This support is gated by the
> configuration option KVM_GMEM_SHARED_MEM, and toggled by the guest_memfd
> flag GUEST_MEMFD_FLAG_SUPPORT_SHARED, which can be set when creating a
> guest_memfd instance.
> 
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 10 ++++
>   arch/x86/kvm/x86.c              |  3 +-

Nit: I would split off the x86 bits. Meaning, this patch would only 
introduce the infrastructure and a x86 KVM patch would enable it for 
selected x86 VMs.


-- 
Cheers,

David / dhildenb


