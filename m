Return-Path: <kvm+bounces-38174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F2BFA36129
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 16:13:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F0787A5200
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 15:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B25D1266B59;
	Fri, 14 Feb 2025 15:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4unEzZHu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC03266583
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 15:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739545947; cv=none; b=ZE0Yy/J2ArXAvSeLNmrlEZ0H2hRnp0VtJh5Wo0hZcNcTJfzfOJEd2jaqrnfUqgeuYX//nFjfPEl70dFmVD1HX9yqXSTZ9h9IycJ7tT1Apyr12Vzn7Yl1ZJpls2SCLCnXtWG/0dEBJj+nVGpLHQgUIqa0g/GXOHY26taVSElo7Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739545947; c=relaxed/simple;
	bh=vnf59c/nCBMxHn6akesMOQzZ9e2bty1aDeq1/eACv1k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H1LAKysTueFThhNmf39dpeSzo/oI4k5nDQVFDXpYASHrx3ztYhoJbp7EqSjPh14UAbmaYT1Or0vhIb9vgoOLSV7gssLPwaTZY5LmCXS9WrimzRs/8ZI8ptW4maKrRVOCARVSzreeZBY7PT84VzEFguNjvNevhXfE1+FaoNnE4QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4unEzZHu; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-220e7d654acso25597075ad.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 07:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739545945; x=1740150745; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z55zQaimMbt2FvsqKqjvjDqM4izV/gI6a1eQPX+1LEc=;
        b=4unEzZHui7weM60DPT9Dip8Zt0TC1bCwFH5OobrB0kpZi+iFF/wEhM8Lh2QT8NPai3
         iK+ukrtjCubHn4WnErOoUuG1aBtjhxw9lil40WdGidVn4fMgCDU0lNeS9gEkjbo+tS5c
         3RlutYZ+qhnCHnJGzK4K87qDEEWYc2qY+Pzh2RzEUaU/Pqlo8oBwJ4cWfvblsp2Irogm
         PdI63KjchI0VMho5tolaEEbeAkNTAoDxovHftMxIogiL6nOH165fobDLxSzJYYowHRWJ
         gSoX/aAbXFlIZHb6mTCMUfYY3N6JOUYhvftN7acwcUjHxX9tua2BllwrpKT+Hi7G+6vN
         mEmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739545945; x=1740150745;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z55zQaimMbt2FvsqKqjvjDqM4izV/gI6a1eQPX+1LEc=;
        b=JzQ+1ewYoPe02fMu2RCkm1cecO4sePdzHIp1/MkAy0jofWeDo8Iu+kUJ7ciWJ5wWTa
         kgwsVaM/7ANiWx5Ed6Tat5vTtmK8dG+/TgCZyqcz2GA9O+BphAJvkAT9h5vyRYEhT5MS
         vTJMbsE4ataWR5zjTLxbmRuOUQQheOFRIN2uad1twWVxJlucId4qRMAKA8Selwgz4V79
         vq8+6NTdiWP8ZhnYJ855DBRjTvXwpuB9MXQnnIlCETferSoTPicI8hD3nWtyeyTmnxhy
         Y+/NDwL8CG1vEoqjpJvXizmJHPnLKsnmuS0Q7ULxyJAu8hSspgp4L3L5tD4IBAq3YSoQ
         oY4w==
X-Forwarded-Encrypted: i=1; AJvYcCVDRSDJy+w3g9Xta8yxXm9sDAoNKYFFePWvDjBJ+/RuMBuKqd1BRJ2txHxLVvCr7gEs1QE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/ChYbRiBriYuCVyFwaKKDod9FB6Y6I0wFyxb8KDxxIg3O98Od
	0//CHBkpVMmWT+GzIboL24QI1Q9dL7TyOXRHOotd/8SrxdoNzk1QQ4pxU8UTL/qUwLf/5gk8KF5
	LAQ==
X-Google-Smtp-Source: AGHT+IFcdkXJQ5mq4r5yhxc+LIPkmYG03Xmdm90vC00pltuvE/fBSBVg/9+YzNBK579Y1GYfnIriEnbbDBA=
X-Received: from plgb14.prod.google.com ([2002:a17:902:d50e:b0:220:eaf6:fcbf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ec92:b0:21f:6ce8:29df
 with SMTP id d9443c01a7336-220d33a5d29mr124724705ad.3.1739545945448; Fri, 14
 Feb 2025 07:12:25 -0800 (PST)
Date: Fri, 14 Feb 2025 07:12:24 -0800
In-Reply-To: <a17d4cd4-b902-4578-83c4-78bb7e0c4bd1@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Z6t227f31unTnQQt@google.com> <CA+EHjTweTLDzhcCoEZYP4iyuti+8TU3HbtLHh+u5ark6WDjbsA@mail.gmail.com>
 <Z6t6_M8un1Cf3nmk@google.com> <d9645330-3a0d-4950-a50b-ce82b428e08c@amazon.co.uk>
 <Z6uEQFDbMGboHYx7@google.com> <Z68lZUeGWwIe-tEK@google.com>
 <CA+EHjTz=d99Mz9jXt5onmtkJgxDetZ32NYkFv98L50BJgSbgGg@mail.gmail.com>
 <ebbc4523-6bec-4f4f-a509-d10a264a9a97@amazon.co.uk> <CA+EHjTyiRAun3XbRUZA52Pq2kSk+gHFt_PksJcCh7P1V3-J3_A@mail.gmail.com>
 <a17d4cd4-b902-4578-83c4-78bb7e0c4bd1@amazon.co.uk>
Message-ID: <Z69dWOVK6OnmS8NP@google.com>
Subject: Re: [PATCH v3 09/11] KVM: arm64: Introduce KVM_VM_TYPE_ARM_SW_PROTECTED
 machine type
From: Sean Christopherson <seanjc@google.com>
To: Patrick Roy <roypat@amazon.co.uk>
Cc: Fuad Tabba <tabba@google.com>, Quentin Perret <qperret@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, keirf@google.com, 
	shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, 
	jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 14, 2025, Patrick Roy wrote:
> On Fri, 2025-02-14 at 13:11 +0000, Fuad Tabba wrote:
> > On Fri, 14 Feb 2025 at 12:37, Patrick Roy <roypat@amazon.co.uk> wrote:
> >> On Fri, 2025-02-14 at 11:33 +0000, Fuad Tabba wrote:
> >>> Hi Quentin,
> >>>
> >>> On Fri, 14 Feb 2025 at 11:13, Quentin Perret <qperret@google.com> wrote:
> >>>>
> >>>> On Tuesday 11 Feb 2025 at 17:09:20 (+0000), Quentin Perret wrote:
> >>>>> Hi Patrick,
> >>>>>
> >>>>> On Tuesday 11 Feb 2025 at 16:32:31 (+0000), Patrick Roy wrote:
> >>>>>> I was hoping that SW_PROTECTED_VM will be the VM type that something
> >>>>>> like Firecracker could use, e.g. an interface to guest_memfd specifically
> >>>>>> _without_ pKVM, as Fuad was saying.
> >>>>>
> >>>>> I had, probably incorrectly, assumed that we'd eventually want to allow
> >>>>> gmem for all VMs, including traditional KVM VMs that don't have anything
> >>>>> special. Perhaps the gmem support could be exposed via a KVM_CAP in this
> >>>>> case?
> >>>>>
> >>>>> Anyway, no objection to the proposed approach in this patch assuming we
> >>>>> will eventually have HW_PROTECTED_VM for pKVM VMs, and that _that_ can be
> >>>>> bit 31 :).
> >>>>
> >>>> Thinking about this a bit deeper, I am still wondering what this new
> >>>> SW_PROTECTED VM type is buying us? Given that SW_PROTECTED VMs accept
> >>>> both guest-memfd backed memslots and traditional HVA-backed memslots, we
> >>>> could just make normal KVM guests accept guest-memfd memslots and get
> >>>> the same thing? Is there any reason not to do that instead?

Once guest_memfd can be mmap()'d, no.  KVM_X86_SW_PROTECTED_VM was added for
testing and development of guest_memfd largely because KVM can't support a "real"
VM if KVM can't read/write guest memory through its normal mechanisms.  The gap
is most apparent on x86, but it holds true for arm64 as well.

> >>>> Even though SW_PROTECTED VMs are documented as 'unstable', the reality
> >>>> is this is UAPI and you can bet it will end up being relied upon, so I
> >>>> would prefer to have a solid reason for introducing this new VM type.
> >>>
> >>> The more I think about it, I agree with you. I think that reasonable
> >>> behavior (for kvm/arm64) would be to allow using guest_memfd with all
> >>> VM types. If the VM type is a non-protected type, then its memory is
> >>> considered shared by default and is mappable --- as long as the
> >>> kconfig option is enabled. If VM is protected then the memory is not
> >>> shared by default.

This aligns with what I see happening for x86, except that for non-protected VMs
there will be no shared vs. private, because such VMs won't have a concept of
private memory.

