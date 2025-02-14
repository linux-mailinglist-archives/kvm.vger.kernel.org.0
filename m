Return-Path: <kvm+bounces-38149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44B6FA35C9C
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 12:34:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5C4A7A29D3
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 11:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED2D72638B7;
	Fri, 14 Feb 2025 11:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y4hKNkw6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A4325A651
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 11:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739532860; cv=none; b=BWEh9mLJ5E70Agwnlllhb3cNUqNzf67gaJ3KX31iHTV7T9Me8498KHh5R6wYdwGHFsI+KaKt0rYf7p5fvj9/gut9nzuluIhp6KqcaZlIk9XBYtTecF6nrHmQtiMpHh5mv0Aknbs9MMNmyc8/ivrTwcBVzgI2qbFrtERQR78v0d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739532860; c=relaxed/simple;
	bh=oIIxZXp55qHUezW1KXD6M19h0CDt+B15X3kzsrT1cbg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fdhFnxEtJ6LryS5D1kQHcED4lcwFbw8XrfsUk7IrR8KY/uaL3blIhbOOxQ0jBzBLEretWMArvsMaSrlpR1ncXIpQl/RwD+S3u5hMSvSzGv40VxRbTeLPKROzrfOzAwi+uDGJCoX6on+WOG/S5mD0wC5EONi6fqwtUxvISE5X3qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y4hKNkw6; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-47180c199ebso206751cf.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 03:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739532857; x=1740137657; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oIIxZXp55qHUezW1KXD6M19h0CDt+B15X3kzsrT1cbg=;
        b=y4hKNkw6c2iAGVkR8HIhYcttA6Od+6RqkuCPtgBJu9Ar7apnIdqM7ULZhjV5VkpfEZ
         UhEsvJ6o9pEBIY+SfmIngx6araktNFAolgg+rG8u84w+hzWgJ99cxo4fuCuT8zqYTB3T
         jUDVT1+nuFLsYjf5LzfAmdGIFDW1mjFUVV9feY9T9l3X09dQ5YJ05ywC6Lw3/tKYd1lF
         z9r3l2tkR0YMioZBaGD0Sh0sofS4z7rntgL+pEUN1AbS7rmQLuQnXT8evRBSyjwTJ5uc
         epHGAF64DJaYD9sc2/WjxygZfEXPEoN/MaGDhEZu0KDkhpv4OCoRTAlCCtLVLlEHALDu
         NVYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739532857; x=1740137657;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oIIxZXp55qHUezW1KXD6M19h0CDt+B15X3kzsrT1cbg=;
        b=L6YhBp5MPe6UBrIyOnEeaxuumhrjpO4iWkus8DquQ6xMpStYWHerQjzRJsCEZ18voZ
         zbgyGhiThaFlGlm4AwXesLN2Ay1Mp2f1xbfqRQOuos7To1EZ+1nw3+J9jgqqluwZqB6A
         LM8YFh2FIBjcSYwhXDOlmAfxHGAInkJbYxV/NN9tv1rFeDF2gLeqQkAHSxzaxlJKq9kd
         0IT0cEJ0xLsODQpOudAP3tDngAencOIxRZ6dIZH+ThsFxJbygVTTqnFmO/gwnLNMyGbt
         rocxrL9lpZkSkE+bQiTNAuhNFxMzXOUL4DviqXQvRffBYm573oCBXUWa06GmSOOlrqij
         Ps4w==
X-Forwarded-Encrypted: i=1; AJvYcCW43vp8ke8raouztQ9u9pLwXnSOxRUejX324zrYq4tMXfriFNInAsAvY+if9T4B8a8wTLY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeNLUjg4AvigcHIaHI8KH4GGm9sNzVRa5WOH9r0AJDzwprMm/N
	4eaFgUCh7oBGdEkb/8ryLB3nRmJUR87cldR+hFn/oyowuol3jadjuol3I9RelhiueZlkAYm8zVK
	/0L8x3r1YLZYJEUHcMMT/3gbAcgfxoRlik0l4
X-Gm-Gg: ASbGncvg1bZA3c/b+5cCTc/WhhuG4q4oguVh/60tC3WXCXNVhMh5Y2t4vJ7ecFMG1/T
	Z3sWluZmPdye7LA8FYXLg5DpecTrS1DVbCY/D/ZUO9Cc5RwuWzNKd8vZPMyy0GPUCKKz0tmo=
X-Google-Smtp-Source: AGHT+IHtlxcMR3vxqJWY40h6ajM6F3iajxeDdssyRx/Y0YsmLzdFANWrYFIiKj2QO/E2Jl5nbjtDGwGC4XIUy4DvM7w=
X-Received: by 2002:a05:622a:d0:b0:467:7c30:3446 with SMTP id
 d75a77b69052e-471cf9817a6mr2328871cf.25.1739532857266; Fri, 14 Feb 2025
 03:34:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211121128.703390-1-tabba@google.com> <20250211121128.703390-10-tabba@google.com>
 <Z6t227f31unTnQQt@google.com> <CA+EHjTweTLDzhcCoEZYP4iyuti+8TU3HbtLHh+u5ark6WDjbsA@mail.gmail.com>
 <Z6t6_M8un1Cf3nmk@google.com> <d9645330-3a0d-4950-a50b-ce82b428e08c@amazon.co.uk>
 <Z6uEQFDbMGboHYx7@google.com> <Z68lZUeGWwIe-tEK@google.com>
In-Reply-To: <Z68lZUeGWwIe-tEK@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 14 Feb 2025 11:33:40 +0000
X-Gm-Features: AWEUYZkg9ciLMmzUzGdibdWHAPxNuB7L-_G6HGADGpvsMSO9kriMESSOnmZ50-k
Message-ID: <CA+EHjTz=d99Mz9jXt5onmtkJgxDetZ32NYkFv98L50BJgSbgGg@mail.gmail.com>
Subject: Re: [PATCH v3 09/11] KVM: arm64: Introduce KVM_VM_TYPE_ARM_SW_PROTECTED
 machine type
To: Quentin Perret <qperret@google.com>
Cc: Patrick Roy <roypat@amazon.co.uk>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
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
Content-Type: text/plain; charset="UTF-8"

Hi Quentin,

On Fri, 14 Feb 2025 at 11:13, Quentin Perret <qperret@google.com> wrote:
>
> On Tuesday 11 Feb 2025 at 17:09:20 (+0000), Quentin Perret wrote:
> > Hi Patrick,
> >
> > On Tuesday 11 Feb 2025 at 16:32:31 (+0000), Patrick Roy wrote:
> > > I was hoping that SW_PROTECTED_VM will be the VM type that something
> > > like Firecracker could use, e.g. an interface to guest_memfd specifically
> > > _without_ pKVM, as Fuad was saying.
> >
> > I had, probably incorrectly, assumed that we'd eventually want to allow
> > gmem for all VMs, including traditional KVM VMs that don't have anything
> > special. Perhaps the gmem support could be exposed via a KVM_CAP in this
> > case?
> >
> > Anyway, no objection to the proposed approach in this patch assuming we
> > will eventually have HW_PROTECTED_VM for pKVM VMs, and that _that_ can be
> > bit 31 :).
>
> Thinking about this a bit deeper, I am still wondering what this new
> SW_PROTECTED VM type is buying us? Given that SW_PROTECTED VMs accept
> both guest-memfd backed memslots and traditional HVA-backed memslots, we
> could just make normal KVM guests accept guest-memfd memslots and get
> the same thing? Is there any reason not to do that instead? Even though
> SW_PROTECTED VMs are documented as 'unstable', the reality is this is
> UAPI and you can bet it will end up being relied upon, so I would prefer
> to have a solid reason for introducing this new VM type.

The more I think about it, I agree with you. I think that reasonable
behavior (for kvm/arm64) would be to allow using guest_memfd with all
VM types. If the VM type is a non-protected type, then its memory is
considered shared by default and is mappable --- as long as the
kconfig option is enabled. If VM is protected then the memory is not
shared by default.

What do you think Patrick? Do you need an explicit VM type?

Cheers,
/fuad

> Cheers,
> Quentin

