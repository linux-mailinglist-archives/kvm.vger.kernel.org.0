Return-Path: <kvm+bounces-53477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B479B12624
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 23:32:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46FEF3AD902
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 21:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89F5F242910;
	Fri, 25 Jul 2025 21:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ets3r8As"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB7D481B1
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 21:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753479120; cv=none; b=A7xaV+AO4/2qURIAdke1NOYFhn1h10Uma8x3iSHDRNspJPOYMLEfU3dfyDuNjuaCFhCQy4wyaTRujykLrJgzSHs+BMGiZVA6qszWKQw/3caQVY4ETAp3WOj3dmE3B0Rmz+zxaP5GQQG88hbgYRMVUKu6Q7ccnSKxU7Lks6I/aPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753479120; c=relaxed/simple;
	bh=s8EYSRl4Upj9AAeXNTjEnXg/I8gOZCm1XU7aiYdvk28=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cq68TwBv8cnwgcY9bfBiX51VZD53LfdTZM8htt3cSQrBgdstW0zFfO7z8Eov/IpKFKAW7NCD4Q++DJlinATlzmmjbfIxf8RkmaKG+BhJKy6aeSYMAF1OWicCn20n9v48OkWsJx2akXeLs+kxWe5Wzsi29HJTnpKcfIPMFsW7EgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ets3r8As; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74d15d90cdbso2096417b3a.0
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 14:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753479119; x=1754083919; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s/2wQleH7ITFpN7KmyE45uwJ+UkF1jVuCUBrc+xrmHs=;
        b=Ets3r8AsbhuK//7edbGs8Jo5lqlhzrq8O1n0hExPRip6DcgDNb6unyOaqnCTHWlXZ9
         /K4Sm8JsPgdMbfxoLP9SacqQkmNzniczb4oVeFbJ3tI/nnE6EI/lLMDzqJz7suwZGUnd
         R7hVyfndtvrBGkte9FVnx2YbGwpsgIeMDqBlC7XrnpTfKCJWSxursCcOLTeDR3xZF36m
         xOyexkudcp0dcPZV4P318l8zV9Nw6+hwWv7XPADExC4uwU0WsVi0/VaAfvgwwoG0TzAb
         OAlJm7SBnFWuzgM8STyeX4ujatz2ZxGe8CsAqS/4b+7G6vBxROnBm7tRUTPkS7cwDxSx
         1Mmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753479119; x=1754083919;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s/2wQleH7ITFpN7KmyE45uwJ+UkF1jVuCUBrc+xrmHs=;
        b=QzB8KbUIDR37cD+XcpGAevHNNmk2KFPi0/gZH7lOhJSZYz4X9CRCynMVgAJ3oDAm3q
         fzQBKuo7TXyhgZ6gZb1HYK7vGvWBVXZux8hMCid/ZsHzKXPhyWJ0jS/MdQCVqUaDVsTh
         aU/yIz80sXoUS2KUUj7ebyB+I+gP3kjgKmmzctkv8lplJRrFvehxjK3/N3HnJtQlJ5sc
         YLROjpxUYaEM+cVvP10naRsqAk6WMgX3wtCrrq4SMHD6gnXtZ7t0xrL7uQcd+nK4WCk4
         /YCrWuouJAf0f1aTXCwvGT3q0skgn1euUBmFgUdD5ZQ7DFNhHyxhQClLFWPeb4swaCoi
         rH2w==
X-Forwarded-Encrypted: i=1; AJvYcCXVK2mkVO4vXmB6jpdt8ydXy0B/O1JASwZ6OLXEMuT5SdY57lpXkG0I2UsHwqu6ygh0rg8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yybs1oapOkjPZ7ExT7TULIIt/b2ruStUd9cM9yY7IVJss1m5+qb
	lynjFMzhzCDUTHHtX46noyFsSExxO+5lm/k5wdKxVdkQdExAR+bMlsEq0X+f2e2gGUKG/J54sTa
	ahJZPTqRF2AVmA9M7vtafM58iTQ==
X-Google-Smtp-Source: AGHT+IGesKxQTKVmzs1CWmOLMYF7g3871uG3DVQpvVnVgh0Q1qhmnR88/PeohzOlETvzSfBr5Eb7p3CMiXA/OH+/rw==
X-Received: from pfbfj4.prod.google.com ([2002:a05:6a00:3a04:b0:748:fa96:6db3])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:ac8:b0:74e:a9c0:9b5c with SMTP id d2e1a72fcca58-763358302abmr4894396b3a.13.1753479118583;
 Fri, 25 Jul 2025 14:31:58 -0700 (PDT)
Date: Fri, 25 Jul 2025 14:31:57 -0700
In-Reply-To: <aIPgjOLq8erW06gK@google.com>
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
Message-ID: <diqzpldoc5yq.fsf@ackerleytng-ctop.c.googlers.com>
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
>> > Invoking host_pfn_mapping_level() isn't just undesirable, it's flat out wrong, as
>> > KVM will not verify slot->userspace_addr actually points at the (same) guest_memfd
>> > instance.
>> >
>> 
>> This is true too, that invoking host_pfn_mapping_level() could return
>> totally wrong information if slot->userspace_addr points somewhere else
>> completely.
>> 
>> What if slot->userspace_addr is set up to match the fd+offset in the
>> same guest_memfd, and kvm_gmem_max_mapping_level() returns 2M but it's
>> actually mapped into the host at 4K?
>> 
>> A little out of my depth here, but would mappings being recovered to the
>> 2M level be a problem?
>
> No, because again, by design, the host userspace mapping has _zero_ influence on
> the guest mapping.
>

Not trying to solve any problem but mostly trying to understand mapping
levels better.

Before guest_memfd, why does kvm_mmu_max_mapping_level() need to do
host_pfn_mapping_level()?

Was it about THP folios?

>> For enforcement of shared/private-ness of memory, recovering the
>> mappings to the 2M level is okay since if some part had been private,
>> guest_memfd wouldn't have returned 2M.
>> 
>> As for alignment, if guest_memfd could return 2M to
>> kvm_gmem_max_mapping_level(), then userspace_addr would have been 2M
>> aligned, which would correctly permit mapping recovery to 2M, so that
>> sounds like it works too.
>> 
>> Maybe the right solution here is that since slot->userspace_addr need
>> not point at the same guest_memfd+offset configured in the memslot, when
>> guest_memfd responds to kvm_gmem_max_mapping_level(), it should check if
>> the requested GFN is mapped in host userspace, and if so, return the
>> smaller of the two mapping levels.
>
> NAK.
>
> I don't understand what problem you're trying to solve, at all.  Setting aside
> guest_memfd for the moment, GFN=>HVA mappings are 100% userspace controlled, via
> memslots.  If userspace is accessing guest memory, it is userspace's responsibility
> to ensure it's accessing the _right_ guest memory.
>
> That doesn't change in any way for guest_memfd.  It is still userspace's
> responsibility to ensure any accesses to guest memory through an HVA access the
> correct GFN.
>
> But for guest_memfd guest mappings, the HVA is irrelevant, period.  The only reason
> we aren't going to kill off slot->userspace_addr entirely is so that _KVM_ accesses
> to guest memory Just Work, without any meaningful changes to (a well-behaved)
> userspace.
>
> For CoCo VMs (including pKVM), guest_memfd needs to ensure it doesn't create a
> hugepage that contains mixed memory, e.g. must not create a 2MiB userspace mapping
> if the 2MiB range contains private memory.  But that is simply a sub-case of the
> generate requirement that untrusted entities don't have access to private memory,
> and that KVM doesn't induce memory corruption due to mapping memory as both shared
> and private. 

