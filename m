Return-Path: <kvm+bounces-53473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92456B124B0
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 21:16:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9068168E28
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 19:16:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BACC0259CB2;
	Fri, 25 Jul 2025 19:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DFNUPj2z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982E9239E75
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 19:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753470995; cv=none; b=l4iZ7le2wIADmfcua4xkDTctiYd0lv4ppxwe0XBPJpmQsmMOkCgco6r3etDaxjdQAa1j0IOVOObmtPHZkykqGu2QoXNynE+6H36xCtoBjf2pNymRnp5uTwkvIlafCahPFlTlLkH5kDqHto5RtFmuNiWpwWP+NHUsN4tx145hewM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753470995; c=relaxed/simple;
	bh=t9FrhtQpYgn6vS+BcC1pt2nWbNWPMHh+SQZ1IZX19Zk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pzXTSL/h5fJtApCNnLoI5pFWiz0H7ETW9fxUqXmq6BsZ2Sgr2su+jyjF6/cDPXQDcODTmeW7oHfa3d6gnV3pcyfTInB9mtuzPGA66kzIt6EfZeNw7X4v4AQnwZQauPIPLCrchbBlCN1FYlSEi5qK78fYfIeEKWPsJEHv3oOoNcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DFNUPj2z; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2fcbd76b61so3229453a12.3
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 12:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753470993; x=1754075793; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5WlSKTdQJz4BcWRlFGcWGmeAyhSggOtqFKeQJDFCZ8k=;
        b=DFNUPj2zqyHQIoDLJDea4UyjOniDa1OLiMkE3mvtwatrDC+Ridj1VEsWtqvVatwPNW
         U4kR/EHXx4kdpBmh5j+REhClZQy7t9ogbH/KQvtOs2cuW2q/8gXDbS0lTF53bmtd5bw4
         lJ8OuQ6kR2PkK/ylzHOWq1BabauEaWyRl3KX2jnyLd5EpQjGu94Goy+AMwkeu5JKDil+
         DIYrpT5Tuaw7/XwXqVlc6GPsjo/zSZSCuNd0MInEVAcbPl6UbMinFYGQxAt8ykEXbjpG
         cbdjFJ8uK6iuhj99qcqxzBEoblMH3yWRgVkGAM0UZUB9jzkT5mNEAwCt31c4a91dxBzm
         WA+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753470993; x=1754075793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5WlSKTdQJz4BcWRlFGcWGmeAyhSggOtqFKeQJDFCZ8k=;
        b=WCzotKmWmO8vGm1u+YkXlDa+UTtj7t+/NAcw6u/xOff+neqb1a1nJf0i+yFh7XRGUd
         d8+NXd5UMloORxQ+5kLvoHy66nNoxjvU4J96Mx9fuJ3bkH4fANrjbq3Uoj70I78WyHSB
         up4cepyGsqUXb2T+0TldW1cPke4w3vKOwrlT/izMyMa8batN2xQEThqqE5X36qFn6rPP
         /P5qsvHpvq4Cy12DrVSaDRlzd60a+zfHlccY7mfJ8XOdfLSsMfa+x8BNn11efNAptZeu
         O82JvUof77Uh8cvGrCrkyEB+0FajC38/jAoWEn93zGAW4/8Pg1YV/PUyhgtwCBhjVCCG
         qelA==
X-Forwarded-Encrypted: i=1; AJvYcCV5ec4+vLA7fao/bsoaPDohC6yk+4V3fu4+b4VKsa/kpw7hvuP3TLrUcnPumV3wsGz1Mp4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzmjwcu8AIZerX14bVP/7X+Nh8TfHm+6o/Vjf8YpTh/OeP3yjK3
	8IrGhu3ddpFia7DqaBuI07Gh9V2rWW/oiLHZvuAkfG3iz3uVDU37Eiry/U5kCSKsKMbObVlEmnB
	CFqTE/C/b83GwwPjmI0k1t/EMVg==
X-Google-Smtp-Source: AGHT+IG5yikix3DRNgEwYyvsz70LuAraxRVgFySsHgY92IzME9+2iJeI2z0Py1tuIkdALoYNsqefn1ymxFcNG6k/Uw==
X-Received: from pfbmd15.prod.google.com ([2002:a05:6a00:770f:b0:746:279c:7298])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:70c8:b0:21e:f2b5:30de with SMTP id adf61e73a8af0-23d700afbc9mr4649670637.12.1753470992563;
 Fri, 25 Jul 2025 12:16:32 -0700 (PDT)
Date: Fri, 25 Jul 2025 12:16:31 -0700
In-Reply-To: <aIO90h_oJsvyxR45@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <20250723104714.1674617-15-tabba@google.com>
 <1ff6a90a-3e03-4104-9833-4b07bb84831f@intel.com> <aIK0ZcTJC96XNPvj@google.com>
 <diqzcy9pdvkk.fsf@ackerleytng-ctop.c.googlers.com> <diqz7bzxduyv.fsf@ackerleytng-ctop.c.googlers.com>
 <aIOVNcp7p2hU-YHM@google.com> <aIO90h_oJsvyxR45@google.com>
Message-ID: <diqzv7ngcc8g.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v16 14/22] KVM: x86/mmu: Enforce guest_memfd's max order
 when recovering hugepages
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
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

> On Fri, Jul 25, 2025, Sean Christopherson wrote:
>> On Thu, Jul 24, 2025, Ackerley Tng wrote:
>> I also don't want to effectively speculatively add kvm_gmem_mapping_order() or
>> expand kvm_gmem_get_pfn(), e.g. to say "no create", so what if we just do this?
>> 
>> 	/* For faults, use the gmem information that was resolved earlier. */
>> 	if (fault) {
>> 		pfn = fault->pfn;
>> 		max_level = fault->max_level;
>> 	} else {
>> 		/* TODO: Call into guest_memfd once hugepages are supported. */
>
> Aha!  Even better, we can full on WARN:
>
> 		WARN_ONCE(1, "Get pfn+order from guest_memfd");
>
> Because guest_memfd doesn't yet support dirty logging:
>
> 	/* Dirty logging private memory is not currently supported. */
> 	if (mem->flags & KVM_MEM_GUEST_MEMFD)
> 		valid_flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
>
> which kills off the kvm_mmu_recover_huge_pages() call from kvm_mmu_slot_apply_flags().
> And if KVM ever supports in-place recover for kvm_recover_nx_huge_pages() (which
> is doubtful given that mitigation shouldn't be required going forward), lack of
> hugepage support means any guest_memfd-based shadow page can't be a possible NX
> hugepage.

Thanks, this sounds good!

