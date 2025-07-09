Return-Path: <kvm+bounces-51977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C7E6AFECED
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 17:00:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 971DB6473B9
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 15:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 077342E6D2F;
	Wed,  9 Jul 2025 15:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MfyKwjx3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3482C2ABF
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 15:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752073208; cv=none; b=Xkbz/mZvwlIZl7Y79pDZG5zdcfHsxMGtHZ6JfG2X2vP3jjqLenTvYdEeQQltC876VKbWwxrSnuVZYpZ8ra2d0nWirV1kVWDorSUX8kVuZvRxlTHMhytL2K0CfzLD074nNXp04C5H3La/m/tpbRDFTbm7McIuFpVTvJUHpGyTaW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752073208; c=relaxed/simple;
	bh=B9Oiu1rYO7kb4Rbx/R2PzIjG/vjXHDSn58ZvxIx3Eng=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BpFfgD5A7gd++UoGKJ1IGKRzVh3q92yjWt3PMvkSawi3XhbSxQOoSULbJaW+dZk1qkWbEx7vdUeEuk6L9tfysfWowl5ZpfXK3OrAgZoq51ZYKGBXf/X5dKa/YVXFKAMjiknDXE+EhJpXN3ihPs1lizrEClG1DHkpCdYIv47Y1W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MfyKwjx3; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2369261224bso66645ad.0
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 08:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752073206; x=1752678006; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EgTnAwf0t/6F9APa2rh1DyKxauhomMCkahh2HJItwX0=;
        b=MfyKwjx3nX24F99iC2py8lcZG7sdzQhK02cBPPcFo7Hso0DPH0GbdpYt+irMdF8l2z
         NCR0bAGeK2BozuZaO/bAfffrGPfwV4SKXU+/3Oc7RgfxUU/lk6so04f0uE6Noc3DhEpr
         9njwESzWnkeWVBrZXvzKpKzyqrOkOLhh3SFY7C17iNzpI+iWHL4VOLT8AKfXS9jQ1F7u
         mE0Ip19mGChe1OWQAT/adAIbGZolaugq47z+rn9QLtngPRy7Da5UbyJ/8Zv0g+QRwZhQ
         cklJwMJlgRKVY0dU/JVDh7jV/5thD7xKAZigJF+rpGfO2Ah40u10BihxMhbHu5GW4H6m
         xmpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752073206; x=1752678006;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EgTnAwf0t/6F9APa2rh1DyKxauhomMCkahh2HJItwX0=;
        b=NpUbPSsZbq32n3vh9m2ZR6cEx0BvX2X/zP5TPiU8pbCo2IuoSGydCPglC0jOCGk0g6
         G8hq2J2+caDZ86yWOhf8uIqNaCM40Dr5yrjcCoRL0qXAOhh+CjhlnXoBLA3Im1ZQDDKn
         7puc4WwAxzIAkYf1yJXny2TZ9gzCH+jayW4jnI0fmCB3x7oo5V07GDQvDSqTF/VH2E0z
         CfnabjDYqMYq32Qq+njh509IrLf+/rQkum63mrGxfOwIFUezv+Jnst4xV3YoCti4N5LZ
         mGEbwKJlSG1i0SgOwYwE0VwjyZ51ce47XHSNKLh4rWJMhWcKNdnw4OtBhqe1/HK8pF3v
         DkAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUYR4PKcdJWRBJfBvcwdJI8EvfDdxYFYH/YjtVVZVzbfXikI3W59J6+r+NwBs4yxe/eQg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxodOqmgfOSaMyecZQ4X2zlJTqmeHDX8aP79H9QFoAUMkY+kgoU
	PgMg7Z40TCOF+Z9JIP+1j0emgXgEv5sBDBWiQHsMeyi6IcZKMQMUa/Si8mSGVDyjxZPSwkp/RWm
	2ZR2g9w==
X-Google-Smtp-Source: AGHT+IGIxCNWDvTXdGWXukQOWTlHDKHcqKhvDakCv68J774ZGhWIyAsbzsp2bcmyGLtmMTkKs6eBKiZcgtc=
X-Received: from plvv2.prod.google.com ([2002:a17:902:d082:b0:234:3f28:4851])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f87:b0:235:e96b:191c
 with SMTP id d9443c01a7336-23ddb34fa56mr52368805ad.29.1752073205780; Wed, 09
 Jul 2025 08:00:05 -0700 (PDT)
Date: Wed, 9 Jul 2025 08:00:04 -0700
In-Reply-To: <CAGtprH86N7XgEXq0UyOexjVRXYV1KdOguURVOYXTnQzsTHPrJQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aG0pNijVpl0czqXu@google.com> <a0129a912e21c5f3219b382f2f51571ab2709460.camel@intel.com>
 <CAGtprH8ozWpFLa2TSRLci-SgXRfJxcW7BsJSYOxa4Lgud+76qQ@mail.gmail.com>
 <eeb8f4b8308b5160f913294c4373290a64e736b8.camel@intel.com>
 <CAGtprH8cg1HwuYG0mrkTbpnZfHoKJDd63CAQGEScCDA-9Qbsqw@mail.gmail.com>
 <b1348c229c67e2bad24e273ec9a7fc29771e18c5.camel@intel.com>
 <aG1dbD2Xnpi_Cqf_@google.com> <5decd42b3239d665d5e6c5c23e58c16c86488ca8.camel@intel.com>
 <aG1ps4uC4jyr8ED1@google.com> <CAGtprH86N7XgEXq0UyOexjVRXYV1KdOguURVOYXTnQzsTHPrJQ@mail.gmail.com>
Message-ID: <aG6D9NqG0r6iKPL0@google.com>
Subject: Re: [RFC PATCH v2 00/51] 1G page support for guest_memfd
From: Sean Christopherson <seanjc@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "pvorel@suse.cz" <pvorel@suse.cz>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	Jun Miao <jun.miao@intel.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pdurrant@amazon.co.uk" <pdurrant@amazon.co.uk>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"peterx@redhat.com" <peterx@redhat.com>, "x86@kernel.org" <x86@kernel.org>, 
	"amoorthy@google.com" <amoorthy@google.com>, "tabba@google.com" <tabba@google.com>, 
	"quic_svaddagi@quicinc.com" <quic_svaddagi@quicinc.com>, "maz@kernel.org" <maz@kernel.org>, 
	"vkuznets@redhat.com" <vkuznets@redhat.com>, 
	"anthony.yznaga@oracle.com" <anthony.yznaga@oracle.com>, 
	"mail@maciej.szmigiero.name" <mail@maciej.szmigiero.name>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, Wei W Wang <wei.w.wang@intel.com>, 
	Fan Du <fan.du@intel.com>, 
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>, Dave Hansen <dave.hansen@intel.com>, 
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, 
	"quic_mnalajal@quicinc.com" <quic_mnalajal@quicinc.com>, "aik@amd.com" <aik@amd.com>, 
	"usama.arif@bytedance.com" <usama.arif@bytedance.com>, "fvdl@google.com" <fvdl@google.com>, 
	"jack@suse.cz" <jack@suse.cz>, "quic_cvanscha@quicinc.com" <quic_cvanscha@quicinc.com>, 
	Kirill Shutemov <kirill.shutemov@intel.com>, "willy@infradead.org" <willy@infradead.org>, 
	"steven.price@arm.com" <steven.price@arm.com>, "anup@brainfault.org" <anup@brainfault.org>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "keirf@google.com" <keirf@google.com>, 
	"mic@digikod.net" <mic@digikod.net>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nsaenz@amazon.es" <nsaenz@amazon.es>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "muchun.song@linux.dev" <muchun.song@linux.dev>, 
	Zhiquan1 Li <zhiquan1.li@intel.com>, "rientjes@google.com" <rientjes@google.com>, 
	Erdem Aktas <erdemaktas@google.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>, 
	"david@redhat.com" <david@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "hughd@google.com" <hughd@google.com>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, Haibo1 Xu <haibo1.xu@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"rppt@kernel.org" <rppt@kernel.org>, "steven.sistare@oracle.com" <steven.sistare@oracle.com>, 
	"jarkko@kernel.org" <jarkko@kernel.org>, "quic_pheragu@quicinc.com" <quic_pheragu@quicinc.com>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, Kai Huang <kai.huang@intel.com>, 
	"shuah@kernel.org" <shuah@kernel.org>, "bfoster@redhat.com" <bfoster@redhat.com>, 
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, Chao P Peng <chao.p.peng@intel.com>, 
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, Alexander Graf <graf@amazon.com>, 
	"nikunj@amd.com" <nikunj@amd.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"jgowans@amazon.com" <jgowans@amazon.com>, Yilun Xu <yilun.xu@intel.com>, 
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"quic_tsoni@quicinc.com" <quic_tsoni@quicinc.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, Ira Weiny <ira.weiny@intel.com>, 
	"richard.weiyang@gmail.com" <richard.weiyang@gmail.com>, 
	"kent.overstreet@linux.dev" <kent.overstreet@linux.dev>, "qperret@google.com" <qperret@google.com>, 
	"dmatlack@google.com" <dmatlack@google.com>, "james.morse@arm.com" <james.morse@arm.com>, 
	"brauner@kernel.org" <brauner@kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "pgonda@google.com" <pgonda@google.com>, 
	"quic_pderrin@quicinc.com" <quic_pderrin@quicinc.com>, "roypat@amazon.co.uk" <roypat@amazon.co.uk>, 
	"hch@infradead.org" <hch@infradead.org>, "will@kernel.org" <will@kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 09, 2025, Vishal Annapurve wrote:
> I think we can simplify the role of guest_memfd in line with discussion [1]:

I genuinely don't understand what you're trying to "simplify".  We need to define
an ABI that is flexible and robust, but beyond that most of these guidelines boil
down to "don't write bad code".

> 1) guest_memfd is a memory provider for userspace, KVM, IOMMU.

No, guest_memfd is a memory provider for KVM guests.  That memory *might* be
mapped by userspace and/or into IOMMU page tables in order out of functional
necessity, but guest_memfd exists solely to serve memory to KVM guests, full stop.

> 3) KVM should ideally associate the lifetime of backing
> pagetables/protection tables/RMP tables with the lifetime of the
> binding of memslots with guest_memfd.

Again, please align your indentation.

>          - Today KVM SNP logic ties RMP table entry lifetimes with how
>            long the folios are mapped in guest_memfd, which I think should be
>            revisited.

Why?  Memslots are ephemeral per-"struct kvm" mappings.  RMP entries and guest_memfd
inodes are tied to the Virtual Machine, not to the "struct kvm" instance.

> Some very early thoughts on how guest_memfd could be laid out for the long term:
> 1) guest_memfd code ideally should be built-in to the kernel.

Why?  How is this at all relevant?  If we need to bake some parts of guest_memfd
into the kernel in order to avoid nasty exports and/or ordering dependencies, then
we can do so.  But that is 100% an implementation detail and in no way a design
goal.

