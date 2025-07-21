Return-Path: <kvm+bounces-53022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10876B0CAD7
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 21:09:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FA6B1AA155C
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 19:09:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E39E22A7E2;
	Mon, 21 Jul 2025 19:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PKkrrtGd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51F022652D
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 19:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753124964; cv=none; b=mxlYR52Wcs4PdZZg+8NNEIXxK/ayrKjRY2sGtIFvuQaBHxFTk45+074VZPOaDdGOWBvIJROP1P5ejRP5vTWZQ9DCxNiW6qDbVMTcixlo23eMw3iCPTQ7e39EcNzrc+dqMXpfD6Vh2G8ELGyb8Fc9LCgYq1YEhoc5Xq9wt7zl8b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753124964; c=relaxed/simple;
	bh=byLk1Un5cMIblBwKFOOFhF8YB588UvGbXUIm/33CqN8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IdgSQwSoF5QAt6BzF1YOA9d4cuW6VohL7bvk5TK90ENZ2hjnms2A+i4X5pLSAt1+Cm7joCgCi+2TLQPNH1QVPWIGzSEk5wnhxZ39KmNYcfpOPrB7tu1FGOswYMIchxTCnaPv/TASMqF9k3BZQ11oZlPZJBDEi+TUG4FgMSklZqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PKkrrtGd; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31cb5cc3edcso3792579a91.0
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 12:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753124962; x=1753729762; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Si1iE2iNBG/ks3WLyUfkQmiowbypc4vWR85emDi8O7c=;
        b=PKkrrtGdtu3XocXsY45rRTgtN94qKvfUMMOQWiTWLLz1dqwHcpqEce8cyryr2ykZp/
         ZZgYqMbficJlj85W9wbeGTHv9yQGaEkLMPSMnMwmhYYNfRGVgUreSf9pWThwwIgm3Zlb
         xL5IEglac6DHnCbZLiCPDIK5ew6hRX79mvTC4t6uAwnPsMuEDJqEaAyje6u5TCvfVfKS
         VHEBE+fZ27VpFFp/8qzzaFxQvECHFGeTa2GG5opk6Rq1ohIA93pEsjszZvsfg2zUg3ju
         g5W0/DsNTvSEOxKNDeZcoA/GOR/nK0cLLRwt0E/M0E4HvtmA7GwWc7yJ8+FE74MUIoEt
         rwzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753124962; x=1753729762;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Si1iE2iNBG/ks3WLyUfkQmiowbypc4vWR85emDi8O7c=;
        b=QvcsAL3Od/nweqCdT9KK78LXgJfQevSc1OHwVRLT44G23GCkMDcICCrGI+lxzgUz1l
         QQfLvlXfTRKoQMNkt3xV6MPtSFBWvZ6NLmMxGkT34RItTRBXaaC9UP8C7Ot+/XfKMN0o
         wbXeKWd8NlQSP01zmHo/c+g12nzs/aNZ4JuqLCTvtXj67YTPIJiIf6bCEUackMun5qoo
         ZetoKqwYyz2alRWJhDQEDUHddjwrtXpkjrR4slB/4up7uPZNKOiiOyErIOMEpmeNdwDp
         ojXdK5TACxmpxW3KMxksbprpFtEfmIl8UkAi6E31Ry9uPP93TmkecOeEfC6JwgNHNPPn
         UcpA==
X-Gm-Message-State: AOJu0YzvIuYsnsA/WRfhvHxSNzsISB+5+7K6O2Zx06UQsADPQeGO4NlQ
	1CcoUV2TL6JUMijr0C4MrmBvuQsZoNdqcPcrMS5vdEzTYZ0b9znnJ/9SD+dFzlPg2FhxY8Oql1a
	w4szklA==
X-Google-Smtp-Source: AGHT+IGbFJhpUQREKI8MWV2U6QwjTBevOOYx6cNDrdGaRxBnZH6BAHAIN1v9eC/o9N2pBUnhgExVswlyNEw=
X-Received: from pjbqo12.prod.google.com ([2002:a17:90b:3dcc:b0:31c:2fe4:33ba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c4b:b0:311:fde5:c4be
 with SMTP id 98e67ed59e1d1-31c9f45c8e9mr24240317a91.35.1753124961668; Mon, 21
 Jul 2025 12:09:21 -0700 (PDT)
Date: Mon, 21 Jul 2025 12:09:20 -0700
In-Reply-To: <CA+EHjTw766UKoLVoxGWDS2adq4m0TWsxwTWMGsjMK=qkSx4iCQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-5-tabba@google.com>
 <aH5uqeQqvzgJOCN0@google.com> <CA+EHjTw766UKoLVoxGWDS2adq4m0TWsxwTWMGsjMK=qkSx4iCQ@mail.gmail.com>
Message-ID: <aH6QYFTKoDqnxrW8@google.com>
Subject: Re: [PATCH v15 04/21] KVM: x86: Introduce kvm->arch.supports_gmem
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
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
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 21, 2025, Fuad Tabba wrote:
> Hi Sean,
> 
> On Mon, 21 Jul 2025 at 17:45, Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Jul 17, 2025, Fuad Tabba wrote:
> > > Introduce a new boolean member, supports_gmem, to kvm->arch.
> > >
> > > Previously, the has_private_mem boolean within kvm->arch was implicitly
> > > used to indicate whether guest_memfd was supported for a KVM instance.
> > > However, with the broader support for guest_memfd, it's not exclusively
> > > for private or confidential memory. Therefore, it's necessary to
> > > distinguish between a VM's general guest_memfd capabilities and its
> > > support for private memory.
> > >
> > > This new supports_gmem member will now explicitly indicate guest_memfd
> > > support for a given VM, allowing has_private_mem to represent only
> > > support for private memory.
> > >
> > > Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> > > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > > Reviewed-by: Shivank Garg <shivankg@amd.com>
> > > Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> > > Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > Co-developed-by: David Hildenbrand <david@redhat.com>
> > > Signed-off-by: David Hildenbrand <david@redhat.com>
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> >
> > NAK, this introduces unnecessary potential for bugs, e.g. KVM will get a false
> > negative if kvm_arch_supports_gmem() is invoked before kvm_x86_ops.vm_init().
> >
> > Patch 2 makes this a moot point because kvm_arch_supports_gmem() can simply go away.
> 
> Just to reiterate, this is a NAK to the whole patch

Ya, in effect.  Well, more specifically to adding arch.supports_gmem, not to the
idea of support guest_memfd broadly.

> (which if I recall correctly, you had suggested),

Sort of[*].  In that thread, I was reacting to the (ab)use of has_private_mem.
And FWIW, I was envisioning supports_gmem being set in common x86.c super early
on, though what pushed me into NAK territory was seeing the final usage, where
"optimizing" kvm_arch_supports_gmem() isn't worth any amount of complexity.

 : And then rather than rename has_private_mem, either add supports_gmem or do what
 : you did for kvm_arch_supports_gmem_shared_mem() and explicitly check the VM type.

[*] https://lore.kernel.org/all/aEyLlbyMmNEBCAVj@google.com

> since the newer patch that you propose makes this patch, and the function
> kvm_arch_supports_gmem() unnecessary.

