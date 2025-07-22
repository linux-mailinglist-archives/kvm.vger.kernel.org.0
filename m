Return-Path: <kvm+bounces-53134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CFEDB0DF11
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 16:41:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4626CAC6869
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 14:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 919A82EB5A1;
	Tue, 22 Jul 2025 14:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AiHqHNur"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F122EA726
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 14:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753194954; cv=none; b=USSMM0EPBZMu87MsAyRpNCE8eo8xGPH5XJ2f8I854M9nHBBzuWn3npwzo+M+xfF6u5KJh0mh3TNS1K8bUltHy5Cg/4EBTjNQWWtQBQju5tHF3/mhkJXmlw2aw+asfYeaCUMap94hjR8GSbYYGZ1q1ox5hnPds7QabRWgrmluWTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753194954; c=relaxed/simple;
	bh=NaNfX7QoGI/ejLumvvk9NJCH7rC9UvvllVGHooYztIg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XSJjYZC3B0n1Os5IlC9tBawIw2JcwbBHjIX8dJxb/cnblEH6GDcTuudFXpPHG2NVcixy0C9/hpdjx/eu8yqQM1K4edAkmx4pAragQqbOGdIEbU36nYbhAXonSM3sUq5V/rUg9Wz3WnB8kfhvsEj3y+AA+0xFd9V0+8Jk1B/ld38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AiHqHNur; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23692793178so47392075ad.0
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 07:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753194952; x=1753799752; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KUCGvGmWdwg0m3EIpNIWNp9O4aLo9Fe5P7KfBDNlB2k=;
        b=AiHqHNurog2rR6o3RN8PDe2rEgoOWqnvWG9H/Kn0zXGN4S1mOkMhUQOg/vKYszWTBB
         1aGyEB06cfYV7C2x6NFX9gXKx1YoRrHHhsHWwArCG/Gzr9kDPgbK/T82VbwEn2Yorh5e
         UwoVRDq7S1l6AxUvG8c+5rBx0HwQroOUPF5BOjrtrjvpA08TKnZ/RLpyt2ABE0Rr/dhf
         5Ptfz0UxyfD4ZJ5W7tcm4LeHZTDxoW/5rrsp59NF0eONg3kLznSq3gsKnXBTn+TzircP
         WO31Brud91Z8kcSUFW4uR9Cl3buSAPZNEdXb0F0mLPhu6bnw8eFFLSuNK/tXiKWIM8rR
         gGrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753194952; x=1753799752;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KUCGvGmWdwg0m3EIpNIWNp9O4aLo9Fe5P7KfBDNlB2k=;
        b=iDBtZMXe+1jj9TZn863sormxACTD+rVSJ2WwxN32OaFP3redSd6zGhv/ltRKKMOM+r
         zQUMHapTumy1e0ZyJNriG3EH23ilCj+UTUuESkNTDikOTX3aT3E/j+zqn+zbjRvu34z+
         gK46MwyJO3aNYuiOJ/3gUoCBbY9U5Wy1/vEi280XWbbjgpBT1CyaSGxtIKLkxhOtE8jc
         XBkSaV+DDSOc6fqZZ1v+QmV5pU5uoQlq8S4B0GqBe/biq3F5L69ecTfvkMJ2O6dfi0wR
         rp++RF1us9+ucLX6pTHviake18Yw7r4+3PNsmHwC+RSjRFTlhdBj0EqNdAMLqYCjxCPO
         lRFA==
X-Forwarded-Encrypted: i=1; AJvYcCV5hLnBCXJF3fsoHaetFcM8UabNEMYRYjJHxZ6tAyvihepqb0dJoXcXLwZYzvqPNT3YLQ4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxK5d6emF0Osuvc7LqaJC0iopjpjPSvABF9+K3OdjtHPcBmCCEy
	V2MG1mdaqU66n7kKbwlqIx4Nw+irqFHY6Fl3+3Rn6CM/S9cMwNOygLSb8mf6yGP+89T1XPnUAl0
	fvU3vHA==
X-Google-Smtp-Source: AGHT+IHc8QcIoTZ0c4wrEcszME7DPaA+xp/Za1q86kov57qJSFV6RsvFN0CRYQMoGS6Gqfb6Seefy3gIDqU=
X-Received: from pjyr14.prod.google.com ([2002:a17:90a:e18e:b0:309:f831:28e0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea0d:b0:23d:ed91:6142
 with SMTP id d9443c01a7336-23e3b84e93cmr215232985ad.42.1753194952414; Tue, 22
 Jul 2025 07:35:52 -0700 (PDT)
Date: Tue, 22 Jul 2025 07:35:50 -0700
In-Reply-To: <CAGtprH_r+eQjdi8q5LABz7LHEhK-xAMi4ciz83j3GnMm5EZRqQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com> <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
 <aH5RxqcTXRnQbP5R@google.com> <1fe0f46a-152a-4b5b-99e2-2a74873dafdc@intel.com>
 <aH55BLkx7UkdeBfT@google.com> <CAGtprH8H2c=bK-7rA1wC1-9f=g8mK3PNXja54bucZ8DnWF7z3g@mail.gmail.com>
 <aH69a_CVJU0-P9wY@google.com> <CAGtprH_r+eQjdi8q5LABz7LHEhK-xAMi4ciz83j3GnMm5EZRqQ@mail.gmail.com>
Message-ID: <aH-hxiD2DwovFpqg@google.com>
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
> On Mon, Jul 21, 2025 at 3:21=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Mon, Jul 21, 2025, Vishal Annapurve wrote:
> > > On Mon, Jul 21, 2025 at 10:29=E2=80=AFAM Sean Christopherson <seanjc@=
google.com> wrote:
> > > >
> > > > >
> > > > > > > 2) KVM fetches shared faults through userspace page tables an=
d not
> > > > > > > guest_memfd directly.
> > > > > >
> > > > > > This is also irrelevant.  KVM _already_ supports resolving shar=
ed faults through
> > > > > > userspace page tables.  That support won't go away as KVM will =
always need/want
> > > > > > to support mapping VM_IO and/or VM_PFNMAP memory into the guest=
 (even for TDX).
> > >
> > > As a combination of [1] and [2], I believe we are saying that for
> > > memslots backed by mappable guest_memfd files, KVM will always serve
> > > both shared/private faults using kvm_gmem_get_pfn().
> >
> > No, KVM can't guarantee that with taking and holding mmap_lock across h=
va_to_pfn(),
> > and as I mentioned earlier in the thread, that's a non-starter for me.
>=20
> I think what you mean is that if KVM wants to enforce the behavior
> that VMAs passed by the userspace are backed by the same guest_memfd
> file as passed in the memslot then KVM will need to hold mmap_lock
> across hva_to_pfn() to verify that.

No, I'm talking about the case where userspace creates a memslot *without*
KVM_MEM_GUEST_MEMFD, but with userspace_addr pointing at a mmap()'d guest_m=
emfd
instance.  That is the scenario Xiaoyao brought up:

 : Actually, QEMU can use gmem with mmap support as the normal memory even
 : without passing the gmem fd to kvm_userspace_memory_region2.guest_memfd
 : on KVM_SET_USER_MEMORY_REGION2.
 :
 : ...
 :=20
 : However, it fails actually, because the kvm_arch_suports_gmem_mmap()
 : returns false for TDX VMs, which means userspace cannot allocate gmem
 : with mmap just for shared memory for TDX.

