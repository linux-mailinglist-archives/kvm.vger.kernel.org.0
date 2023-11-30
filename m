Return-Path: <kvm+bounces-2835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26F947FE674
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 03:02:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4CB028214B
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 02:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48E6CCA76;
	Thu, 30 Nov 2023 02:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LfaTCrAm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36E0D5E
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 18:02:10 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5d340a9cf07so2797637b3.3
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 18:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701309730; x=1701914530; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p5qGWsyuSpyUxVCjDr7Vtr3DU5QXEtFZRiCX/LhUA7Q=;
        b=LfaTCrAmd6yZDQdXxE/UEo7la816+qPZ3cSVNTPckgPyfq5wPTBTZLfmQwJHzagnLx
         PFbrRd9bbU9oKWrkhUulpiVm7HSwaaPZnfP22X9EpMsakoyZENtVw9+PXT9MvDtGHBgC
         D9/vINjkjPaK+KoHqMIy0iObvqOT6LMwzviW3YvlQj6gV7X0pPRe16R8Am7Y8+Rr+jcc
         Dt++721k9natgHk4TKWr219VslonrPhvWh/fKyA7aGrig3bvi/weK1VlqTycE2p8weFt
         QJw1AJOhps5fuU7r6Vyt120zDh4U+WheBUfDNYQZ2FCQNGF5xt3ayeuUn8C1sc1iwheS
         MwRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701309730; x=1701914530;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p5qGWsyuSpyUxVCjDr7Vtr3DU5QXEtFZRiCX/LhUA7Q=;
        b=nys4cLlH+q8O3K9XT+JM/MQ5GDA92+nMxN+uvuFGgXK1vKUwuiah9bL3d9pfanRpzw
         kovO7srsIdGOmuXcGCTAP8awF7BTkUfkl8Z4aCVkk6IOL1UoBUP5Rz8mBQTFlIqJIB0L
         qkAbHCunxmmz8l+qD8c2cb9qw06bzzpsdBTgHkdjgsSvd0+8sBaJ7wzt9dY5PQZB1dP0
         2ltc0XWSlg157joH4B2KJwUHlNHQf/iCKBdQ+droIxxq3bK/+4Y6bypPZe7Ux1QujhJq
         FHa2IkSAQTQSla5i1mkaha9soD9LBHWQSrfBv2lFU2VwGsIB3f5ZN9I00EtGkVM0STal
         qZhQ==
X-Gm-Message-State: AOJu0YwgdUncuhyZ75ZcgN7DLO2NN6qhbdcfH1jqEXGSWKIbALBWLlcJ
	MchNnvANo2MsUgq5/GBBMyMnDQkIilQ=
X-Google-Smtp-Source: AGHT+IFFDXNizpZ3vuH6xJBBRUPvzbuvqFOYFoh+t1YBbvxwcXUL+r5zJu2BpTJXrcb2S71zCUhlon51++M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:ec5:b0:5ca:321f:a368 with SMTP id
 cs5-20020a05690c0ec500b005ca321fa368mr767996ywb.7.1701309730213; Wed, 29 Nov
 2023 18:02:10 -0800 (PST)
Date: Wed, 29 Nov 2023 18:02:08 -0800
In-Reply-To: <20231130011650.GD1389974@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <0-v1-08396538817d+13c5-vfio_kvm_kconfig_jgg@nvidia.com>
 <87edgy87ig.fsf@mail.lhotse> <ZWagNsu1XQIqk5z9@google.com>
 <875y1k3nm9.fsf@mail.lhotse> <ZWfgYdSoJAZqL2Gx@google.com> <20231130011650.GD1389974@nvidia.com>
Message-ID: <ZWftIIEpbLP2xF5H@google.com>
Subject: Re: Ping? Re: [PATCH rc] kvm: Prevent compiling virt/kvm/vfio.c
 unless VFIO is selected
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@redhat.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, James Morse <james.morse@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	Marc Zyngier <maz@kernel.org>, Ingo Molnar <mingo@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>, 
	x86@kernel.org, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 29, 2023, Jason Gunthorpe wrote:
> On Wed, Nov 29, 2023 at 05:07:45PM -0800, Sean Christopherson wrote:
> > On Wed, Nov 29, 2023, Michael Ellerman wrote:
> > > Sean Christopherson <seanjc@google.com> writes:
> > > > On Fri, Nov 10, 2023, Michael Ellerman wrote:
> > > >> Jason Gunthorpe <jgg@nvidia.com> writes:
> > > >> > There are a bunch of reported randconfig failures now because of this,
> > > >> > something like:
> > > >> >
> > > >> >>> arch/powerpc/kvm/../../../virt/kvm/vfio.c:89:7: warning: attribute declaration must precede definition [-Wignored-attributes]
> > > >> >            fn = symbol_get(vfio_file_iommu_group);
> > > >> >                 ^
> > > >> >    include/linux/module.h:805:60: note: expanded from macro 'symbol_get'
> > > >> >    #define symbol_get(x) ({ extern typeof(x) x __attribute__((weak,visibility("hidden"))); &(x); })
> > > >> >
> > > >> > It happens because the arch forces KVM_VFIO without knowing if VFIO is
> > > >> > even enabled.
> > > >> 
> > > >> This is still breaking some builds. Can we get this fix in please?
> > > >> 
> > > >> cheers
> > > >> 
> > > >> > Split the kconfig so the arch selects the usual HAVE_KVM_ARCH_VFIO and
> > > >> > then KVM_VFIO is only enabled if the arch wants it and VFIO is turned on.
> > > >
> > > > Heh, so I was trying to figure out why things like vfio_file_set_kvm() aren't
> > > > problematic, i.e. why the existing mess didn't cause failures.  I can't repro the
> > > > warning (requires clang-16?), but IIUC the reason only the group code is problematic
> > > > is that vfio.h creates a stub for vfio_file_iommu_group() and thus there's no symbol,
> > > > whereas vfio.h declares vfio_file_set_kvm() unconditionally.
> > > 
> > > That warning I'm unsure about.
> > 
> > Ah, it's the same warning, I just missed the CONFIG_MODULES=n requirement.
> 
> Oh, wait, doesn't that mean the approach won't work? IIRC doesn't
> symbol_get turn into just &fn when non-modular turning this into a
> link failure without the kconfig part?

Yes, but it doesn't cause linker errors.  IIUC, because the extern declaration
is tagged "weak", a dummy default is used.  E.g. on x86, this is what is generated
with VFIO=y

                fn = symbol_get(vfio_file_is_valid);
                if (!fn)
   0xffffffff810396c5 <+5>:	mov    $0xffffffff81829230,%rax
   0xffffffff810396cc <+12>:	test   %rax,%rax

whereas VFIO=n gets

                fn = symbol_get(vfio_file_is_valid);
                if (!fn)
   0xffffffff810396c5 <+5>:	mov    $0x0,%rax
   0xffffffff810396cc <+12>:	test   %rax,%rax

I have no idea if the fact that symbol_get() generates '0', i.e. the !NULL checks
work as expected, is intentional or if KVM works by sheer dumb luck.  I'm not
entirely sure I want to find out, though it's definitely extra motiviation to get
the KVM mess fixed sooner than later. 

