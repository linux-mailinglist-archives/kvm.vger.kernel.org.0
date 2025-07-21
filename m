Return-Path: <kvm+bounces-52980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E1D2B0C573
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 15:45:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A88221AA2491
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 13:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DACB2D97B9;
	Mon, 21 Jul 2025 13:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vte6I+vD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C0728D840
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 13:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753105535; cv=none; b=Qk+5nQT6paTxyJEkm0Hd48xltvfvszvw02ymYHs3pZ4qoULcDO1k9EvcHt9re/BP9vX/Hw1Ny2srpExBKFxmy9p1Dj0VDYdIeW1XltmYLxnPVIEVvxbiTGXm2Ddk13pDFwAhWSrmlwrmrd+zy6D6qrCtd0UwHq51iIU+sgyS02s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753105535; c=relaxed/simple;
	bh=xS8FHRQqRz1nSiwIVN6mTqgxMWHxF+OgzCsTtwKG9q8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B739w7NUTAzIG//AyjFoUThR9M4bnSqOHn6NAXIwEU3/okHykC0TnOSi3KpSgQK/RcXFEy8+9OGfEAbXkEN6IYX/XIs6/ZxMl2RSy6wM6iZhgeILeXFaRzCSXZzZpSZZGwko4q9bJ9HCdgZgbJkj0kLoHPUuOiXiJDTm2EAMm7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vte6I+vD; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-237f18108d2so277565ad.0
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 06:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753105533; x=1753710333; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gQBY4/lqxzZEDnjripdA0AMheXR9IyeEye91HdZllXE=;
        b=Vte6I+vD9fYDazndsFJj/rDQDq+8es01LC3aDMSYeVS/I9s9Fc3Ll0i4h0q5u+yLrk
         8NLTKyR0+fojoiYkXClZycP53CnRT6PSHnHHqQ5U4ZQUbc64gb8Suz0wP5g54d64m5Ae
         Ws0+soheNjFo92xaGQVt/6FDYUd1K6EDXDT4TrdVO7bezLy+YW8ljlMKSNu81Y7uZ10c
         GFDI5ReMG7fdepXx1gh3aWKwp3q4NxBf47R+UsUv10FXrJswbYH+CM58C8VU5W5oUvsQ
         LlBzdTc4RYVeE3BpfSeKngjkIPwTzbe8jaawVzABQOSTmQJT39RNXJ66TkuYe11JOCtN
         P2gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753105533; x=1753710333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gQBY4/lqxzZEDnjripdA0AMheXR9IyeEye91HdZllXE=;
        b=vp1aZPEskQLLQhCt/lXCaTNpVJjMtMGiraFf+HWiRdA4roPPW2U9CTTmom3/PCSRh7
         a28yf2xLFNp0xtYsPP6SVyUAoxfm1Vt9xIHMmnUmnAioIVce+MCzYuaX//YLQHIH3R8/
         75LYVEIKyQ0mor/SIMST9PcLQ80pzX7IVqyU0fOfe5w1eFROh39HWYbFls7VwedePLYg
         slH2Rw/URHThqvm/NoiEb1ZDeqgzxj+DysfxROiufGFvUkxy7PvjD59O+L/Ut7+cXuMs
         7VewYu6kqn7xU9e3fOosyUX9xPPtQMVHP/SXlzk/C/bLoK6DxcBq2AQz3fA9YaDLTVTW
         z+IA==
X-Forwarded-Encrypted: i=1; AJvYcCUrdU6ksorPqq0pHcgu0Br1z51FLU2BhWkK6iZVVg6Du1Lz9T2JKJMN/vFEYd/fl/RhgwE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNyZ3WeARJhFMgP6G0KxA9O7V6/RA61vFk+sXd8DmCf9DHFCHL
	u8j0tTvNws3W+XLZyNtxCLlObB4tzFjf/q781t6/lWG9veIh6LlfiB5HUL4g+6K7o4ME9uwJhxp
	xjWLfrPfXiHnqhuwIjYh7RrjWXugUqIWjmAWddUig
X-Gm-Gg: ASbGncuqnWTWLZ426BBs3CnuQmnGboqMXxoWC8evU5kTsCKp5GSlp4L8Em+4dU/M+cd
	vYeWhmv15nqVuLuRVrc8lXQoaK8tqjubD0qHm1fhPw9P9gFmxNQSC8VsOc1pZJs1qIjpGh3TO69
	T/uJGCmj+WaDWhGK8NjA7jyEcMER1j9eoC9s4/2zj15IQ2iucYJxMlqeei20EXgUVw6G5U3daEf
	jLtoXDeunyhFPVHotnlTqCn4i6wJZhHieEdipLW
X-Google-Smtp-Source: AGHT+IHgNq4HFEWMWRcmuIn4waZQ8L7YkPL51NiUKU8DKiTWVp4UcwGMr4KoSHwclm773Kr4g3s26lBtxz0ISLcojo0=
X-Received: by 2002:a17:903:3c30:b0:23c:7be2:59d0 with SMTP id
 d9443c01a7336-23f72bde123mr4371025ad.23.1753105532950; Mon, 21 Jul 2025
 06:45:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
In-Reply-To: <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 21 Jul 2025 06:45:20 -0700
X-Gm-Features: Ac12FXxBtzFRH5FT7AkkjtuMY19h9DQ20jtILflp5xgXgKiIQbsSMqanr3p0fog
Message-ID: <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2025 at 5:22=E2=80=AFAM Xiaoyao Li <xiaoyao.li@intel.com> w=
rote:
>
> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> > +/*
> > + * CoCo VMs with hardware support that use guest_memfd only for backin=
g private
> > + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping en=
abled.
> > + */
> > +#define kvm_arch_supports_gmem_mmap(kvm)             \
> > +     (IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&   \
> > +      (kvm)->arch.vm_type =3D=3D KVM_X86_DEFAULT_VM)
>
> I want to share the findings when I do the POC to enable gmem mmap in QEM=
U.
>
> Actually, QEMU can use gmem with mmap support as the normal memory even
> without passing the gmem fd to kvm_userspace_memory_region2.guest_memfd
> on KVM_SET_USER_MEMORY_REGION2.
>
> Since the gmem is mmapable, QEMU can pass the userspace addr got from
> mmap() on gmem fd to kvm_userspace_memory_region(2).userspace_addr. It
> works well for non-coco VMs on x86.
>
> Then it seems feasible to use gmem with mmap for the shared memory of
> TDX, and an additional gmem without mmap for the private memory. i.e.,
> For struct kvm_userspace_memory_region, the @userspace_addr is passed
> with the uaddr returned from gmem0 with mmap, while @guest_memfd is
> passed with another gmem1 fd without mmap.
>
> However, it fails actually, because the kvm_arch_suports_gmem_mmap()
> returns false for TDX VMs, which means userspace cannot allocate gmem
> with mmap just for shared memory for TDX.

Why do you want such a usecase to work?

If kvm allows mappable guest_memfd files for TDX VMs without
conversion support, userspace will be able to use those for backing
private memory unless:
1) KVM checks at binding time if the guest_memfd passed during memslot
creation is not a mappable one and doesn't enforce "not mappable"
requirement for TDX VMs at creation time.
2) KVM fetches shared faults through userspace page tables and not
guest_memfd directly.

I don't see value in trying to go out of way to support such a usecase.

>
> SO my question is do we want to support such case?

