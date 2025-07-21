Return-Path: <kvm+bounces-52998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 474DDB0C6B0
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:42:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3EA51AA6E5F
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 503312DD5F3;
	Mon, 21 Jul 2025 14:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WMLOcC6L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC73E2D8383
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 14:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753108939; cv=none; b=JEziDPXYmv2/L0A9dm1CsWs2ZU7D0nmVGMyJ2DccwCmm/hsJCqysBxpbvV9MPsAR0c9SiVt7Lb7XGcAqqOTZT1BJgtiTGcQSSTSSAMZD36Vnz6XknheUO2JGm0HgoQwya0BF0LRGysU3SdMibqI6xLnP1cYVFv5AiKM4mOZS0Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753108939; c=relaxed/simple;
	bh=tAkACTqBc7iDyjbX4+Ym/8m7pcYe2h7ohna/mojj4Co=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hj7aNbjzjtVRZOK002I3V56zQE9N1z6T0YfmXtsDgTyH7C9pRlyp52KsKcf1NDJdqP+t3nQKxy7ZmRhm8EtlAmeMvtRYgrJ1bDmUE+V94HrM1sAESuCngU1QhYPISO7DYyB+/ImYyUbzxNUsoVQKtEiC5DJjd/rR1pRuoAvAj2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WMLOcC6L; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3138c50d2a0so6586819a91.2
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 07:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753108937; x=1753713737; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0goFzyfUB48nlOh0zNIdkcSt6jKBrbzO05Ipxz1r+/M=;
        b=WMLOcC6L+4yAO0oLXqB0YFUkw+A124vx10lWESaUGqy23wc0fJIJndBXs5UJnsL4nD
         bUnUMt6nhY+G+BFOk9wJaEduldxe8aFlVmpymypBdsSkpAG6F4rGDBsy4AqNwiItKGkJ
         zBeuQ3ZxyyAogYWpAG8slNbu1WtL3V5+yhPe8u8+PX/YZRitG0a5nLoX9e9ZQ/4t/h9U
         f43CRFpnOhkBrzPZ/i1cxjFIlTOo5plWHsy+fdaclujEMGs8yiZixCq1Tplf+ms2/l6N
         F8cZu8gAB9bMA8lyZ1aBH0pKkF7igAXXOaHnOzvTh8Il5+s9s9BT/Ri0sbuKtDI1T7Mr
         K5mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753108937; x=1753713737;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0goFzyfUB48nlOh0zNIdkcSt6jKBrbzO05Ipxz1r+/M=;
        b=pwkbWldnxUeUaAnPeYmOdQnLmppFrNWigukJUZR9F94sEPxbcQKixupu+Sksx3TeoE
         ntAFT28cN7LO6VsyFTnXI56KJ3jUiGonjj4u61j7n8jmsT2pHwa2rAKgIWwzeZ+uBIDC
         yJVB82jBaXkwMP12nf6kO1sxyRF0mStLX8OT/vD8maO+lwmnLC0la6j5eUrgxbcDdyg0
         iHclmxwt+sMs6FvDQ4DcW457rcmXTHmcg2FOeMWcoVSnOCvgyGdBdJgHHF9k82RgIGJ4
         7MgI3gSxFGJljZmwN79bIL8BQvPC+vcgMUG5l/ospvyma1xYuN8f24En9PHQDMtsYXAx
         pMPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJfdvVPlOFfQW5jnfLALTjFwjVP0OlaAntdDUmTAZpqvLhF5DuTiRTc5Fqpae8C8raH+U=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUuBOgYYh31EFud9L7F+UWKqlceDL9/VuSe6Db1SZ3NPBa6/V9
	nJRbtlUckX63ecU7hoA2yOn/KFQzQCiSQD44cBuar/BAtrUPb+Bzi8tE0aeT3rSC8Upr+JDfgTP
	v1052JQ==
X-Google-Smtp-Source: AGHT+IEJ+bjLeZTUfUfKDLe1LsRRhzuv2RwpCfUPWTo0Nomfp5QFIPNH2ZxIutJZB2fcJTSI1oFs3d8UxLE=
X-Received: from pjz11.prod.google.com ([2002:a17:90b:56cb:b0:31c:2fe4:33b7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5810:b0:313:23ed:701
 with SMTP id 98e67ed59e1d1-31caf821680mr23427409a91.4.1753108936848; Mon, 21
 Jul 2025 07:42:16 -0700 (PDT)
Date: Mon, 21 Jul 2025 07:42:14 -0700
In-Reply-To: <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com> <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
Message-ID: <aH5RxqcTXRnQbP5R@google.com>
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
From: Sean Christopherson <seanjc@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2025, Vishal Annapurve wrote:
> On Mon, Jul 21, 2025 at 5:22=E2=80=AFAM Xiaoyao Li <xiaoyao.li@intel.com>=
 wrote:
> >
> > On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> > > +/*
> > > + * CoCo VMs with hardware support that use guest_memfd only for back=
ing private
> > > + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping =
enabled.
> > > + */
> > > +#define kvm_arch_supports_gmem_mmap(kvm)             \
> > > +     (IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&   \
> > > +      (kvm)->arch.vm_type =3D=3D KVM_X86_DEFAULT_VM)
> >
> > I want to share the findings when I do the POC to enable gmem mmap in Q=
EMU.
> >
> > Actually, QEMU can use gmem with mmap support as the normal memory even
> > without passing the gmem fd to kvm_userspace_memory_region2.guest_memfd
> > on KVM_SET_USER_MEMORY_REGION2.
> >
> > Since the gmem is mmapable, QEMU can pass the userspace addr got from
> > mmap() on gmem fd to kvm_userspace_memory_region(2).userspace_addr. It
> > works well for non-coco VMs on x86.
> >
> > Then it seems feasible to use gmem with mmap for the shared memory of
> > TDX, and an additional gmem without mmap for the private memory. i.e.,
> > For struct kvm_userspace_memory_region, the @userspace_addr is passed
> > with the uaddr returned from gmem0 with mmap, while @guest_memfd is
> > passed with another gmem1 fd without mmap.
> >
> > However, it fails actually, because the kvm_arch_suports_gmem_mmap()
> > returns false for TDX VMs, which means userspace cannot allocate gmem
> > with mmap just for shared memory for TDX.
>=20
> Why do you want such a usecase to work?

I'm guessing Xiaoyao was asking an honest question in response to finding a
perceived flaw when trying to get this all working in QEMU.

> If kvm allows mappable guest_memfd files for TDX VMs without
> conversion support, userspace will be able to use those for backing

s/able/unable?

> private memory unless:
> 1) KVM checks at binding time if the guest_memfd passed during memslot
> creation is not a mappable one and doesn't enforce "not mappable"
> requirement for TDX VMs at creation time.

Xiaoyao's question is about "just for shared memory", so this is irrelevant=
 for
the question at hand.

> 2) KVM fetches shared faults through userspace page tables and not
> guest_memfd directly.

This is also irrelevant.  KVM _already_ supports resolving shared faults th=
rough
userspace page tables.  That support won't go away as KVM will always need/=
want
to support mapping VM_IO and/or VM_PFNMAP memory into the guest (even for T=
DX).

> I don't see value in trying to go out of way to support such a usecase.

But if/when KVM gains support for tracking shared vs. private in guest_memf=
d
itself, i.e. when TDX _does_ support mmap() on guest_memfd, KVM won't have =
to go
out of its to support using guest_memfd for the @userspace_addr backing sto=
re.
Unless I'm missing something, the only thing needed to "support" this scena=
rio is:

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index d01bd7a2c2bd..34403d2f1eeb 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -533,7 +533,7 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_=
guest_memfd *args)
        u64 flags =3D args->flags;
        u64 valid_flags =3D 0;
=20
-       if (kvm_arch_supports_gmem_mmap(kvm))
+       // if (kvm_arch_supports_gmem_mmap(kvm))
                valid_flags |=3D GUEST_MEMFD_FLAG_MMAP;
=20
        if (flags & ~valid_flags)

I think the question we actually want to answer is: do we want to go out of=
 our
way to *prevent* such a usecase.  E.g. is there any risk/danger that we nee=
d to
mitigate, and would the cost of the mitigation be acceptable?

I think the answer is "no", because preventing userspace from using guest_m=
emfd
as shared-only memory would require resolving the VMA during hva_to_pfn() i=
n order
to fully prevent such behavior, and I defintely don't want to take mmap_loc=
k
around hva_to_pfn_fast().

I don't see any obvious danger lurking.  KVM's pre-guest_memfd memory manag=
ement
scheme is all about effectively making KVM behave like "just another" users=
pace
agent.  E.g. if/when TDX/SNP support comes along, guest_memfd must not allo=
w mapping
private memory into userspace regardless of what KVM supports for page faul=
ts.

So unless I'm missing something, for now we do nothing, and let this suppor=
t come
along naturally once TDX support mmap() on guest_memfd.

