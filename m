Return-Path: <kvm+bounces-53475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB2AB124EC
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 21:53:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 057924E396B
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 19:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF40C24EA9D;
	Fri, 25 Jul 2025 19:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MNdOVYhW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EBA24BC0A
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 19:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753473168; cv=none; b=jR3n7/9AbekD2pRb9HIIYLKFpDSkdYgcCogAQHYoMMKbx4AAOtRsUliHIay8PgDM/gF2/kCEwUkivhitSXxDiu3OXlsUAwv2Li0PNOsa54C9ICVcLmNHWDjD1AfpqStCS9qUqMCheOAaXcyv/LgR4GwBDIYYavjX58T/0CZPseo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753473168; c=relaxed/simple;
	bh=D/BxQwI45NEctT9RKmkNXq7H6TV6FVvhywdeOEV7K08=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dRAeb6g4WADIYUQKs6cQD6kU/ZEU0Ogo4omNF3U33zvsWi7l6mcLmyNV5d+EK92aVXGx9aFBg4OoHNIpqsZ4S9Ytnux8j8MgxCxkviWqfET1QSFqMNnJb/Ntb3lsR+QP7e/WYLM9qbPmAAcr8gI9Zf0V32rEOv4aClC8uHEtWYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MNdOVYhW; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23dc7d3e708so17937765ad.3
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 12:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753473166; x=1754077966; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QGGwHKzNdqzja55fvEizh1HPckulPqbm51MIc4WTZ8o=;
        b=MNdOVYhWreytd/dpsRBCwICFppehR0tFqdpKPXjuC/ahPcH02IaYNvh/P/QlCG3hZQ
         bHuzFBe3ThTbDLbnzGt6p8D7L8CHzOGVWo65HlFscoSIVEgxthJFTUz/mqYxWBwpiZ2J
         Sh96tEJ3SggJ398Qspp4Eew4aNbUF/YQNBuJmX/+Iqeg/r63KmHNTYLROHbbWpTABJ13
         7ynmEz6F/WgSXJYi9RxtQsUI3GPxQvZE8h1M1GukcAWI99adcckXEtczw+feS9/tQOs3
         6M1n7vzm2isJc7sR1bTz/QwcpQDBMse8K99O16Z69X/rbfg1B6WQObppx6y0n1WoSKTV
         hGHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753473166; x=1754077966;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QGGwHKzNdqzja55fvEizh1HPckulPqbm51MIc4WTZ8o=;
        b=LRIucWj7MrRVsM9BjKioEUIBqCYLfAJPm9nOSbG1/OjRagmf3qA9UESN4JEZNMZZ+D
         oJkTXZ9Si2xzMpm7YVXkdrKbtfPSd0Bes8Vhm0Btlh/I2RMnuVAr8wAdSnePY3xL+fCK
         C8HrlcUBM1VWswSxB+uso6ukXrFHdcPQgEA7ZGeLg+xalMXqupsgxcr+5NvtwkIqcz4H
         rjU3TXZh74R5n+ShnPFiQA2lxVn5VKAnRDgZdyEA2OFO2qzsEz84L2bJQsRfUnUcFxNc
         tkD6Wn8DbcrVJgN7W3Ht1wu36k09dsYqm0QIVDp6QzlNOgJ45UmX7XnnMZlTvCCE3YZ8
         m/Bw==
X-Forwarded-Encrypted: i=1; AJvYcCVvNP6RsiXmpu5el2PQejMFOusDbNCZPiG5piWaLizdFsJW6UeQ12QLNiTnk4VjjLLUh4M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh/+NFADHmDNsm+mXb4m8SnxFYqsKHOJZ0poh+aQPd3WX+0Vhg
	y571Y1MN/L7DRh6z/dpp/LGw+9Ks/tXAybbs3G7pbg1CmpMPE8HRZvtoUnTRisFVqDDhiRjNvDQ
	xERJZww==
X-Google-Smtp-Source: AGHT+IGKfp2ZEdZFD4nXV8opXXNSrJNr2MwInumKeRrkZ/nbSrnkah7OjJY3KrZp8KeOnG/KWd4mQPv9Jxk=
X-Received: from pjbqd15.prod.google.com ([2002:a17:90b:3ccf:b0:314:d44:4108])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d414:b0:23f:b4c4:710c
 with SMTP id d9443c01a7336-23fb4c4730amr32702405ad.38.1753473165998; Fri, 25
 Jul 2025 12:52:45 -0700 (PDT)
Date: Fri, 25 Jul 2025 12:52:44 -0700
In-Reply-To: <diqzseikcbef.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-16-tabba@google.com>
 <diqza54tdv3p.fsf@ackerleytng-ctop.c.googlers.com> <aIOMPpTWKWoM_O5J@google.com>
 <diqzy0sccjfz.fsf@ackerleytng-ctop.c.googlers.com> <aIO7PRBzpFqk8D13@google.com>
 <diqzseikcbef.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aIPgjOLq8erW06gK@google.com>
Subject: Re: [PATCH v16 15/22] KVM: x86/mmu: Extend guest_memfd's max mapping
 level to shared mappings
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
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
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 25, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > Invoking host_pfn_mapping_level() isn't just undesirable, it's flat out wrong, as
> > KVM will not verify slot->userspace_addr actually points at the (same) guest_memfd
> > instance.
> >
> 
> This is true too, that invoking host_pfn_mapping_level() could return
> totally wrong information if slot->userspace_addr points somewhere else
> completely.
> 
> What if slot->userspace_addr is set up to match the fd+offset in the
> same guest_memfd, and kvm_gmem_max_mapping_level() returns 2M but it's
> actually mapped into the host at 4K?
> 
> A little out of my depth here, but would mappings being recovered to the
> 2M level be a problem?

No, because again, by design, the host userspace mapping has _zero_ influence on
the guest mapping.

> For enforcement of shared/private-ness of memory, recovering the
> mappings to the 2M level is okay since if some part had been private,
> guest_memfd wouldn't have returned 2M.
> 
> As for alignment, if guest_memfd could return 2M to
> kvm_gmem_max_mapping_level(), then userspace_addr would have been 2M
> aligned, which would correctly permit mapping recovery to 2M, so that
> sounds like it works too.
> 
> Maybe the right solution here is that since slot->userspace_addr need
> not point at the same guest_memfd+offset configured in the memslot, when
> guest_memfd responds to kvm_gmem_max_mapping_level(), it should check if
> the requested GFN is mapped in host userspace, and if so, return the
> smaller of the two mapping levels.

NAK.

I don't understand what problem you're trying to solve, at all.  Setting aside
guest_memfd for the moment, GFN=>HVA mappings are 100% userspace controlled, via
memslots.  If userspace is accessing guest memory, it is userspace's responsibility
to ensure it's accessing the _right_ guest memory.

That doesn't change in any way for guest_memfd.  It is still userspace's
responsibility to ensure any accesses to guest memory through an HVA access the
correct GFN.

But for guest_memfd guest mappings, the HVA is irrelevant, period.  The only reason
we aren't going to kill off slot->userspace_addr entirely is so that _KVM_ accesses
to guest memory Just Work, without any meaningful changes to (a well-behaved)
userspace.

For CoCo VMs (including pKVM), guest_memfd needs to ensure it doesn't create a
hugepage that contains mixed memory, e.g. must not create a 2MiB userspace mapping
if the 2MiB range contains private memory.  But that is simply a sub-case of the
generate requirement that untrusted entities don't have access to private memory,
and that KVM doesn't induce memory corruption due to mapping memory as both shared
and private. 

