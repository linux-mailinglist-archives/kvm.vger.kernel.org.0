Return-Path: <kvm+bounces-53492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B701FB126D7
	for <lists+kvm@lfdr.de>; Sat, 26 Jul 2025 00:26:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7231D3AD201
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 22:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CFF1256C91;
	Fri, 25 Jul 2025 22:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qhoD5gce"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5A32528FC
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 22:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753482362; cv=none; b=kixfphPf8xGA9Rwllw8LcICFAiyNO0GGtDqREujRN+oN3JEUD5HXBm8tCsv/GmAj3q9/PA1wTuDZNc/YhQqrJV2Pyt/dihoFeC/gz7jq4rqyYDshhb6EO7x2D0sNaXBjzmzMAUrISD4A6pdjsSwzXU213n3oOf05o8GuaWOnjeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753482362; c=relaxed/simple;
	bh=pEZGJ/+pn5DmA3NCmRo+S67yh6XKcvssc7owYYiGbk0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c3smUC/H10HsTkSRiImJiQL/HCOLnWfU/bgn9zOHq7sn5QkBfOQIIqohNz7f5wg6uMod28XlWA0y33PFTnPfM3ibLJdEYfPwY953DuRGpBxZEjd2UuhiRwqNeVe/+Eli84xpq6yNicLfVDQSFJDgtFDdJvyT4pCkm44xvt5P7Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qhoD5gce; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-754f57d3259so3810744b3a.2
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 15:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753482360; x=1754087160; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Lq9QQ8w3hMdR19q3/dpKc/mSw+VikFUTc+/jJzJxpA=;
        b=qhoD5gcekgKKpSQHLYCjbFXaXqO3SGI6RYTIAE0E3JR7h789UJE3/6p2opndw2A7GE
         aYAVvPRMotx1aPS9k44f3IvMGLvqF77A58kSyUMqnd6j/4quQwdG+MG7+zji7bjnbUds
         KpyIPqEuV2n7ylfh4qtpboGfS6uAb8C9+75L8CWmFC6+fsBHeOTSXy7Fw595TdCAlBlc
         7rDbWsAXbtn4QvK8fXQIHhfGTXrnHlBtFrfH1diwcquPGesIjUx8h8PnwFq4LFKDE/vC
         ZGlGFfkTr6aTaq1ytOid9vCGTTTNs9imVmYe88Dkcgp5jHL73M2AWPJz/sJ7UbG+lkNO
         13rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753482360; x=1754087160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Lq9QQ8w3hMdR19q3/dpKc/mSw+VikFUTc+/jJzJxpA=;
        b=N/7GJjhlDt3Mxm6OUIWjYyN4P90cI+013QrOI5zbTG7GfCxC9FRSgonnmJnj0Z2l95
         +z7XF6/sksym8qOJKiLQfete4wCv2ZXl9ce63kTdTtiuja2Cckbr0LRSQV6Lcte56vEm
         vEUuvRtAnKHgsTivRKcFMWjjIo4zRB8QZ2WppcZIiOb49k84gXNNppalL/aw87AKvsBQ
         vgSsEWsyrzHXpzspcf3o02RRRBlqZBeTfB7VC+kAQST53nb9ededZja7yGpDHDVs058F
         NOgu19Xn8UuhBFU/0ECw+liStEy099eZ+qz2Qpiy97M7au0QSoEVCUtfdH3mWZAXGoUY
         juqA==
X-Forwarded-Encrypted: i=1; AJvYcCX5NamVCMDO6PS46GNOOsGZyc3h0OzAtdUTIWRUNDOH9hTx9DfQImsBzSlRy4RtAoT8sTw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTXvYkxeQVFWLecTzeqwrddoH2+nBHuhRoD3A6UZWTJYqpJsyR
	BJMG196Xwq6W7ZHG+Hl/cyvq16zEMav6rgGAVdE2qD42xOGyl3jhh6Bv6sNYhOPEkH8dMhJhKBV
	vxfgpdqEu3FaHFKtI6bPorAZRFw==
X-Google-Smtp-Source: AGHT+IEZxdfrdgDIlR5zUkMlJz/kBxt4HyXLAe0BLt5xpkZQemjoRXVB0UGSeGU8+zfIGfEMo0h1ofcgL6D2PyWz8A==
X-Received: from pfmm16.prod.google.com ([2002:a05:6a00:2490:b0:746:3185:144e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:84d:b0:74e:ac5b:17ff with SMTP id d2e1a72fcca58-763343da33dmr4952699b3a.13.1753482359896;
 Fri, 25 Jul 2025 15:25:59 -0700 (PDT)
Date: Fri, 25 Jul 2025 15:25:58 -0700
In-Reply-To: <aIP-qSnH1jjuykmP@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-16-tabba@google.com>
 <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com> <aIOMPpTWKWoM_O5J@google.com>
 <diqzy0sccjfz.fsf@ackerleytng-ctop.c.googlers.com> <aIO7PRBzpFqk8D13@google.com>
 <diqzseikcbef.fsf@ackerleytng-ctop.c.googlers.com> <aIPgjOLq8erW06gK@google.com>
 <diqzpldoc5yq.fsf@ackerleytng-ctop.c.googlers.com> <aIP-qSnH1jjuykmP@google.com>
Message-ID: <diqzms8rdi15.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v16 15/22] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
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

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Jul 25, 2025, Ackerley Tng wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> > On Fri, Jul 25, 2025, Ackerley Tng wrote:
>> >> Sean Christopherson <seanjc@google.com> writes:
>> >> > Invoking host_pfn_mapping_level() isn't just undesirable, it's flat out wrong, as
>> >> > KVM will not verify slot->userspace_addr actually points at the (same) guest_memfd
>> >> > instance.
>> >> >
>> >> 
>> >> This is true too, that invoking host_pfn_mapping_level() could return
>> >> totally wrong information if slot->userspace_addr points somewhere else
>> >> completely.
>> >> 
>> >> What if slot->userspace_addr is set up to match the fd+offset in the
>> >> same guest_memfd, and kvm_gmem_max_mapping_level() returns 2M but it's
>> >> actually mapped into the host at 4K?
>> >> 
>> >> A little out of my depth here, but would mappings being recovered to the
>> >> 2M level be a problem?
>> >
>> > No, because again, by design, the host userspace mapping has _zero_ influence on
>> > the guest mapping.
>> 
>> Not trying to solve any problem but mostly trying to understand mapping
>> levels better.
>> 
>> Before guest_memfd, why does kvm_mmu_max_mapping_level() need to do
>> host_pfn_mapping_level()?
>> 
>> Was it about THP folios?
>
> And HugeTLB, and Device DAX, and probably at least one other type of backing at
> this point.
>
> Without guest_memfd, guest mappings are a strict subset of the host userspace
> mappings for the associated address space (i.e. process) (ignoring that the guest
> and host mappings are separate page tables).
>
> When mapping memory into the guest, KVM manages a Secondary MMU (in mmu_notifier
> parlance), where the Primary MMU is managed by mm/, and is for all intents and
> purposes synonymous with the address space of the userspace VMM.
>
> To get a pfn to insert into the Secondary MMU's PTEs (SPTE, which was originally
> "shadow PTEs", but has been retrofitted to "secondary PTEs" so that it's not an
> outright lie when using stage-2 page tables), the pfn *must* be faulted into and
> mapped in the Primary MMU.  I.e. under no circumstance can a SPTE point at memory
> that isn't mapped into the Primary MMU.
>
> Side note, except for VM_EXEC, protections for Secondary MMU mappings must also
> be a strict subset of the Primary MMU's mappings.  E.g. KVM can't create a
> WRITABLE SPTE if the userspace VMA is read-only.  EXEC protections are exempt,
> so that guest memory doesn't have to be mapped executable in the VMM, which would
> basically make the VMM a CVE factory :-)
>
> All of that holds true for hugepages as well, because that rule is just a special
> case of the general rule that all memory must be first mapped into the Primary
> MMU.  Rather than query the backing store's allowed page size, KVM x86 simply
> looks at the Primary MMU's userspace page tables.  Originally, KVM _did_ query
> the VMA directly for HugeTLB, but when things like DAX came along, we realized
> that poking into backing stores directly was going to be a maintenance nightmare.
>
> So instead, KVM was reworked to peek at the userspace page tables for everything,
> and knock wood, that approach has Just Worked for all backing stores.
>
> Which actually highlights the brilliance of having KVM be a Secondary MMU that's
> fully subordinate to the Primary MMU.  Modulo some terrible logic with respect to
> VM_PFNMAP and "struct page" that has now been fixed, literally anything that can
> be mapped into the VMM can be mapped into a KVM guest, without KVM needing to
> know *anything* about the underlying memory.
>
> Jumping back to guest_memfd, the main principle of guest_memfd is that it allows
> _KVM_ to be the Primary MMU (mm/ is now becoming another "primary" MMU, but I
> would call KVM 1a and mm/ 1b).  Instead of the VMM's address space and page
> tables being the source of truth, guest_memfd is the source of truth.  And that's
> why I'm so adamant that host_pfn_mapping_level() is completely out of scope for
> guest_memfd; that API _only_ makes sense when KVM is operating as a Seconary MMU.

Thanks! Appreciate the detailed response :)

It fits together for me now.

