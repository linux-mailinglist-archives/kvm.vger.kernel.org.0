Return-Path: <kvm+bounces-51026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0A12AEBECA
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 20:00:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F4CE6A56FE
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 17:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 112CB2EBB8E;
	Fri, 27 Jun 2025 17:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="soeC9Nr5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BC32E88A9
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 17:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751047191; cv=none; b=ILSdTnsb3cJzdLSqQBXK9v+UHF5TuU2mbQhSZ/ss8F4sT3RUGoNkh7xL3UsiXsW2I68dIdSDxX4u3A5ZLBFvkW4ZqHXFZ/Av38WmhcZf+jkTvhl/LN6+jRJaOL/JOs9lEagT+mRMeLA4ABr/FYDhQrIpFNEBlKSkZNLKbpq3riU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751047191; c=relaxed/simple;
	bh=d2OwBuoaVJe5rQ0Zhn56lxg3ii/D/3hwyLERPbl2/O8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nGxlKl0XEdBaLOK+h2HUcMjmddDsC1RsSp+vnEIfEbSU4U2LF1FJvbLSBKMda5JXvjNCHRDBSGrRI7yQwAgXLMyuKP5/XuxzKqCLA6O6lTi4a+0z1btYWRu8e/XAjO5f2fs1lc67QbQB7DkDzkz75pcF22l65osjk1S+yRp5re8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=soeC9Nr5; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-748f3613e6aso71557b3a.0
        for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 10:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751047189; x=1751651989; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SRtvMJ21kZsL1YOacYg4JvIxFtgWxwLC8XLslq9FYAM=;
        b=soeC9Nr5cjLY2CX3KACn0flfOZozAbem0wmlpNkSf0zrs+qlKdUdR08sIGmHMFEv0W
         EUrAvCEmbtUwDhrR3KfW3P0ZWVxX3NbDpIglG6OT1IP3KExp4BpBJ8ce8HXNGH8LRMoE
         DLQtX9vXzAcFGQ1RSWz94arM7RWkrxEB74umCNJlQ2Xr1lc+MV2L0nBxUi2GzDEI+pxJ
         9g8LDPq/clN5YMEyFU2UEFrD7bnX8CPRAFOGG9URmlu80YI4uA7P/mP0h2OdkZQd6+vS
         0XY1+qdNG3jhCWHFiX1Kep10icPnNVSZSBB5I4ipzYAPeQ//+5M6jz7SM4vgDtpo32Uu
         lg+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751047189; x=1751651989;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SRtvMJ21kZsL1YOacYg4JvIxFtgWxwLC8XLslq9FYAM=;
        b=HIm8huCnrpuT7qQZ/8rKvdLcXKECcsPAFQJ0OyDtbdKLJbjE/jFlDCR7xDozSk0gd5
         08B1kHGtaypZ8bVtRGTh/pQYsZkWAoY1b/S5x6JgJFHw2PogAoEf8m+O84KopQw7cVN5
         IcL7yZOEt6jFQo+rIfm12lqPRg0KdTJKN1987H7OSVUEdVpbn2WxJ31YrM3K3JG746gJ
         FR7wOtvrFplJv2lPy888Oc8Wnw3ygfxB5DixDr7+atmIz7n7zANnL/2YatceQunzYRPh
         sxsl1lZW2XlOz4aA7OCBuGweUsnHWEk3injCZO9NILmcwlCHRyqGbYzzCXfAXaVADwaV
         K09Q==
X-Forwarded-Encrypted: i=1; AJvYcCWBAERp1RxkeIlh+uXnyc2Aulj/J310Vj4apinRk9plHynUsqCY7ekOqmr/gAHbShDUIuk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz54Z5xMpld3iGnKr+YcbFZkKJt6zAdB9D4vETMz3leJz2aBSUm
	fB4JYojnU2OvwAO+7/a8aOBaoxCgHlO7B+6Z5Hgn1SkUqILJ2t3YB5VZjK/aMxt0KMjB9XOFNZM
	gfDzPqNYu4gEzxtpH5Ej2ZzTqPw==
X-Google-Smtp-Source: AGHT+IGHzx0jys4ZhUUXxRoNLQVTrBfRYdepSd18LQuziEpvvfy/c9PGS4BmVIi497ELX8Rztn76ytniDfu9D31iVQ==
X-Received: from plpb14.prod.google.com ([2002:a17:902:d60e:b0:236:91fa:131a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:da8d:b0:234:cb4a:bc1b with SMTP id d9443c01a7336-23ac488584amr70876905ad.49.1751047189093;
 Fri, 27 Jun 2025 10:59:49 -0700 (PDT)
Date: Fri, 27 Jun 2025 10:59:47 -0700
In-Reply-To: <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com> <0072a5c0cf289b3ba4d209c9c36f54728041e12d.camel@intel.com>
 <aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com> <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com> <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
 <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com> <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com> <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki> <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
Message-ID: <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
From: Ackerley Tng <ackerleytng@google.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"Shutemov, Kirill" <kirill.shutemov@intel.com>
Cc: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"Du, Fan" <fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "tabba@google.com" <tabba@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"Li, Zhiquan1" <zhiquan1.li@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:

> On Thu, 2025-06-26 at 18:16 +0300, Shutemov, Kirill wrote:
>> > > Please see my reply to Yan, I'm hoping y'all will agree to something
>> > > between option f/g instead.
>> > 
>> > I'm not sure about the HWPoison approach, but I'm not totally against it. My
>> > bias is that all the MM concepts are tightly interlinked. If may fit
>> > perfectly,
>> > but every new use needs to be checked for how fits in with the other MM
>> > users of
>> > it. Every time I've decided a page flag was the perfect solution to my
>> > problem,
>> > I got informed otherwise. Let me try to flag Kirill to this discussion. He
>> > might
>> > have some insights.
>> 
>> We chatted with Rick about this.
>> 
>> If I understand correctly, we are discussing the situation where the TDX
>> module failed to return a page to the kernel.
>> 
>> I think it is reasonable to use HWPoison for this case. We cannot
>> guarantee that we will read back whatever we write to the page. TDX module
>> has creative ways to corrupt it. 
>> 
>> The memory is no longer functioning as memory. It matches the definition
>> of HWPoison quite closely.
>
> ok! Lets go f/g. Unless Yan objects.

Follow up as I think about this more: Perhaps we don't need to check for
HWpoison (or TDX unmap errors) on conversion.

On a high level, we don't need to check for HWpoison because conversion
is about changing memory metadata, as in memory privacy status and
struct folio sizes, and not touching memory contents at all. HWpoison
means the memory and its contents shouldn't be used.

Specifically for private-to-shared conversions where the TDX unmap error
can happen, we will

1. HWpoison the page
2. Bug the TD

This falsely successful conversion means the host (guest_memfd) will
think the memory is shared while it may still be mapped in Secure-EPTs.

I think that is okay because the only existing user (TD) stops using
that memory, and no future users can use the memory:

1. The TD will be bugged by then. A non-running TD cannot touch memory
   that had the error on unmapping.

2. The page was not mapped into host page tables (since it was
   private). Even if it were mapped, it will be unmapped from host page
   tables (host page table unmaps don't fail). If the host tries to
   touch the memory, on the next fault, core-mm would notice that the
   page is poisoned and not fault it in.

By the way, when we "bug the TD", can we assume that ALL vCPUs, not just
the one that is did the failed unmap will stop running?

I guess even if the other vCPUs don't stop running, the TDs vCPUs will
access the page as shared thinking the conversion succeeded and keep
hitting #VEs. If the TD accesses the page as private, it's fine since
the page was not unmapped from Secure-EPTs due to the unmap failure and
the host cannot write to it (host will see HWpoison on next fault) and
so there's no host crash and doesn't defeat the purpose of guest_memfd.

If the guest_memfd with a HWpoisoned page is linked to a new, runnable
TD, the new TD would need to fault in the page as private. When it tries
to fault in the page to the new TD, it will hit the HWpoison and
userspace will get to know about the HWpoison.

Yan, Rick, let me know what you think of this!

