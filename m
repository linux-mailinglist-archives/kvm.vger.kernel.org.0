Return-Path: <kvm+bounces-53157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5981BB0E100
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 17:54:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BCE11897E10
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 15:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B795279DD8;
	Tue, 22 Jul 2025 15:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XU+z6+2E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD15279354
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 15:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753199668; cv=none; b=fu4J6uYURCk2ecAPhUC28dylfvuFgEdB4/+7ep1j133LRJO8kotuCetWA0afIlAKE/hS0nuj/DJa7uXhG3wgU/n3Uv/MsUjBBDBLxjYz21HfY/p1RLFj9ox5U8JAI6fK44dx+OGzlmth0SFdd74l3TmFIVqH9FiUQ0WvwpE3x4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753199668; c=relaxed/simple;
	bh=IbxyI+d4DwDdJfWKyRK5YK5E+tDQKNfuGXF+3uEwdSQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tu9uSsFx8CNl+AQpRhIo3yLpHsx9c3aJNVVD2h1dbDNv3dn1BZfGJyJCBsdIgwvawi7lXp+KS7zfXLLWo2NRkQfWyNIopmrm4CUM9/cypjhnz8ZOs2gdTqb22CAhiG0MfJx/XCQhc/nWv7XblJmueeIlfQwf/IgX3hUphPi0dKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XU+z6+2E; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313f702d37fso6101106a91.3
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 08:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753199667; x=1753804467; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2EB07ZZ1nZF+2zxBd27QnHrigr6tNVGhECi/rfOelmg=;
        b=XU+z6+2E8r9RiruAwG3GJ5Roczk2sO4Qw0QrvBRCDas2tmoOsVIGI5OmWS+8bUXKom
         k0/6+os7V/VvbZSD+Cb6jl4G061CTbDaKIh1aT14w4mM54Mlq06xdZBxk5QilcFrzwha
         U9y3lt2+qyP56rvQHo0ZLwvp3G//siSg3yBuh6fNXfPHG0Ad+zJDbHCZRNTmfPzuOOP2
         79qsgMbhqQmwQVnfvtwLWU3hBGQV8BJEkwE8+n9mbqN6SJYYTB4Zt0hMHtCFZtE48y4Z
         wmMbiTuszJqekttXpsg2ZqEdSBkkgC1t0GCYyG/IF+zHjokvEUNgYmHwG/xLeKX006/2
         c7tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753199667; x=1753804467;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2EB07ZZ1nZF+2zxBd27QnHrigr6tNVGhECi/rfOelmg=;
        b=nW1sjSoyHrRNPrForJFoUuvIDQeFWquz33Q7Mlpv8KMbkXumSk+GR050FbgqpGTfeE
         Kws+e7s1LFsl+PDcptOq5XEMIGEpsVDCWQwuQL4xGNzNg5Mh4YRsdA5xipZc1t3qC+EV
         32KXW67WhxXcYMhInCIpcf4Xq+ci7wUl+OSplDb5fQPTiH1om21OsT+Qsnccy5RQIQ29
         437rRHltwBqj44DerkrQRWFcwQ/RYngiZQxwEbLuIT+iFRSxVh14mttG6taJ4En+uzjB
         ukdE6tSU8PFpEK/WR6dGrS9Ee4rLnRUMWlMUcGmQ1qddnQC75f4l9+rXT71b/9/RFR9q
         tBrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUiJD/yPjhx0iGvBal5jiSiOZsyzbqsTtkrBop3IbHKF5L3WrVYKfpBaNShIZC1u+mxxPM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+EIfnKZkE0nt9+bFRzP7pkgH9Q5JlH2nOCvQNc9XkgwN5y7gN
	vH9uQcP6QNeO+T4lSQXurxrIa1MLhmaNYDFhA8qKy6+C16xVCbkhT1DLrqGY50UoLoCKdW4+2NM
	4pioXcw==
X-Google-Smtp-Source: AGHT+IGD9GjUmk2mTKpI5WThiVPOreH1K6U86raMu0YkKxP22VhfLnDZ4ZgBcgSwwkWvRKO4X9OvNPQVInU=
X-Received: from pjbqo11.prod.google.com ([2002:a17:90b:3dcb:b0:311:7d77:229f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:5d12:b0:31c:39c5:ffbd
 with SMTP id 98e67ed59e1d1-31c9f4b4177mr29758044a91.24.1753199666565; Tue, 22
 Jul 2025 08:54:26 -0700 (PDT)
Date: Tue, 22 Jul 2025 08:54:25 -0700
In-Reply-To: <13654746-3edc-4e4a-ac4f-fa281b83b2ae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com> <608cc9a5-cf25-47fe-b4eb-bdaff7406c2e@intel.com>
 <aH-iGMkP3Ad5yncW@google.com> <13654746-3edc-4e4a-ac4f-fa281b83b2ae@intel.com>
Message-ID: <aH-0MdNJbH19Mhm3@google.com>
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
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

On Tue, Jul 22, 2025, Xiaoyao Li wrote:
> On 7/22/2025 10:37 PM, Sean Christopherson wrote:
> > On Tue, Jul 22, 2025, Xiaoyao Li wrote:
> > > On 7/21/2025 8:22 PM, Xiaoyao Li wrote:
> > > > On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> > > > > +/*
> > > > > + * CoCo VMs with hardware support that use guest_memfd only for
> > > > > backing private
> > > > > + * memory, e.g., TDX, cannot use guest_memfd with userspace mapp=
ing
> > > > > enabled.
> > > > > + */
> > > > > +#define kvm_arch_supports_gmem_mmap(kvm)=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 \
> > > > > +=C2=A0=C2=A0=C2=A0 (IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&=
=C2=A0=C2=A0=C2=A0 \
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0 (kvm)->arch.vm_type =3D=3D KVM_X86_DEFA=
ULT_VM)
> > > >=20
> > > > I want to share the findings when I do the POC to enable gmem mmap =
in QEMU.
> > > >=20
> > > > Actually, QEMU can use gmem with mmap support as the normal memory =
even
> > > > without passing the gmem fd to kvm_userspace_memory_region2.guest_m=
emfd
> > > > on KVM_SET_USER_MEMORY_REGION2.
> > > >=20
> > > > Since the gmem is mmapable, QEMU can pass the userspace addr got fr=
om
> > > > mmap() on gmem fd to kvm_userspace_memory_region(2).userspace_addr.=
 It
> > > > works well for non-coco VMs on x86.
> > >=20
> > > one more findings.
> > >=20
> > > I tested with QEMU by creating normal (non-private) memory with mmapa=
ble
> > > guest memfd, and enforcily passing the fd of the gmem to struct
> > > kvm_userspace_memory_region2 when QEMU sets up memory region.
> > >=20
> > > It hits the kvm_gmem_bind() error since QEMU tries to back different =
GPA
> > > region with the same gmem.
> > >=20
> > > So, the question is do we want to allow the multi-binding for shared-=
only
> > > gmem?
> >=20
> > Can you elaborate, maybe with code?  I don't think I fully understand t=
he setup.
>=20
> well, I haven't fully sorted it out. Just share what I get so far.
>=20
> the problem hit when SMM is enabled (which is enabled by default).
>=20
> - The trace of "-machine q35,smm=3Doff":
>=20
> kvm_set_user_memory AddrSpace#0 Slot#0 flags=3D0x4 gpa=3D0x0 size=3D0x800=
00000
> ua=3D0x7f5733fff000 guest_memfd=3D15 guest_memfd_offset=3D0x0 ret=3D0
> kvm_set_user_memory AddrSpace#0 Slot#1 flags=3D0x4 gpa=3D0x100000000
> size=3D0x80000000 ua=3D0x7f57b3fff000 guest_memfd=3D15
> guest_memfd_offset=3D0x80000000 ret=3D0
> kvm_set_user_memory AddrSpace#0 Slot#2 flags=3D0x2 gpa=3D0xffc00000
> size=3D0x400000 ua=3D0x7f5840a00000 guest_memfd=3D-1 guest_memfd_offset=
=3D0x0 ret=3D0
> kvm_set_user_memory AddrSpace#0 Slot#0 flags=3D0x0 gpa=3D0x0 size=3D0x0
> ua=3D0x7f5733fff000 guest_memfd=3D15 guest_memfd_offset=3D0x0 ret=3D0
> kvm_set_user_memory AddrSpace#0 Slot#0 flags=3D0x4 gpa=3D0x0 size=3D0xc00=
00
> ua=3D0x7f5733fff000 guest_memfd=3D15 guest_memfd_offset=3D0x0 ret=3D0
> kvm_set_user_memory AddrSpace#0 Slot#3 flags=3D0x2 gpa=3D0xc0000 size=3D0=
x20000
> ua=3D0x7f5841000000 guest_memfd=3D-1 guest_memfd_offset=3D0x0 ret=3D0
> kvm_set_user_memory AddrSpace#0 Slot#4 flags=3D0x2 gpa=3D0xe0000 size=3D0=
x20000
> ua=3D0x7f5840de0000 guest_memfd=3D-1 guest_memfd_offset=3D0x3e0000 ret=3D=
0
> kvm_set_user_memory AddrSpace#0 Slot#5 flags=3D0x4 gpa=3D0x100000
> size=3D0x7ff00000 ua=3D0x7f57340ff000 guest_memfd=3D15 guest_memfd_offset=
=3D0x100000
> ret=3D0
>=20
> - The trace of "-machine q35"
>=20
> kvm_set_user_memory AddrSpace#0 Slot#0 flags=3D0x4 gpa=3D0x0 size=3D0x800=
00000
> ua=3D0x7f8faffff000 guest_memfd=3D15 guest_memfd_offset=3D0x0 ret=3D0
> kvm_set_user_memory AddrSpace#0 Slot#1 flags=3D0x4 gpa=3D0x100000000
> size=3D0x80000000 ua=3D0x7f902ffff000 guest_memfd=3D15
> guest_memfd_offset=3D0x80000000 ret=3D0
> kvm_set_user_memory AddrSpace#0 Slot#2 flags=3D0x2 gpa=3D0xffc00000
> size=3D0x400000 ua=3D0x7f90bd000000 guest_memfd=3D-1 guest_memfd_offset=
=3D0x0 ret=3D0
> kvm_set_user_memory AddrSpace#0 Slot#3 flags=3D0x4 gpa=3D0xfeda0000 size=
=3D0x20000
> ua=3D0x7f8fb009f000 guest_memfd=3D15 guest_memfd_offset=3D0xa0000 ret=3D-=
22
> qemu-system-x86_64: kvm_set_user_memory_region: KVM_SET_USER_MEMORY_REGIO=
N2
> failed, slot=3D3, start=3D0xfeda0000, size=3D0x20000, flags=3D0x4, guest_=
memfd=3D15,
> guest_memfd_offset=3D0xa0000: Invalid argument
> kvm_set_phys_mem: error registering slot: Invalid argument
>=20
>=20
> where QEMU tries to setup the memory region for [0xfeda0000, +0x20000],
> which is back'ed by gmem (fd is 15) allocated for normal RAM, from offset
> 0xa0000.
>=20
> What I have tracked down in QEMU is mch_realize(), where it sets up some
> memory region starting from 0xfeda0000.

Oh yay, SMM.  The problem lies in memory regions that are aliased into low =
memory
(IIRC, there's at least one other such scenario, but don't quote me on that=
).
For SMRAM, when the "high" SMRAM location (0xfeda0000) is enabled, the "leg=
acy"
SMRAM location (0xa0000) gets remapped (aliased in QEMU's vernacular) to th=
e
high location, resulting in two CPU physical addresses pointing at the same
underyling memory[*].  From KVM's perspective, that means two GPA ranges po=
inting
at the same HVA.

As for whether or not we want to support such madness...  I'd definitely sa=
y "not
now", and probably not ever.  Emulating SMM puts the VMM *firmly* in the TC=
B of
the guest, and so guest_memfd benefits like not having to map guest memory =
into
userspace pretty much go out the window.  For such a use case, I don't thin=
k it's
unreasonable to require QEMU (or any other VMM) to map the aliases via HVA =
only,
i.e. to not take full advantage of guest_memfd.

[*] https://opensecuritytraining.info/IntroBIOS_files/Day1_08_Advanced%20x8=
6%20-%20BIOS%20and%20SMM%20Internals%20-%20SMRAM.pdf

