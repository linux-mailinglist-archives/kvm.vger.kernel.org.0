Return-Path: <kvm+bounces-59574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 05202BC19C5
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 15:58:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2E09188A871
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 13:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 370C02E22BD;
	Tue,  7 Oct 2025 13:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kc0DNiPQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA392E1EEC
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 13:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759845502; cv=none; b=s0y2jhVl/DZIZTP+tCx4fbfQwUrzGyM9BX3N7aFjVaGOMUPaKDky6pjBWFCHTGTLJcWONcI1H7ihOOdpHFsqo2ts8veq0ruLlQVUrNFHQUuXPTEyNsZ9do78gtTOYJdOgvCWGywfv9TEhAu6arozYfQUcLOqwidEv7CDD3PzxWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759845502; c=relaxed/simple;
	bh=2p6sw/d5o9WykeyOnWT+2vs8b7uJ9tBZ8iAVCQgjDZQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EueMggUEFvOg9Z75ZOa9VjNzzQ/Q+qEKkqZz6ejJ6XrpaLJGJ9zxwIFCL3U2uN154sZImauFsO7XVYYvFldhD70PovqTwqcCo77q7VFKhjm+s0JgrCB5ZIQVmFqibWecuuHDH8ClcEa98W+lx0AD9qY5M5Su16W/1vDF5KKA09s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kc0DNiPQ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b55443b4114so4263017a12.2
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 06:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759845500; x=1760450300; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4rlYUY99rqPM8GfD927WUvhieIqn1G/yd0+acs0pn14=;
        b=Kc0DNiPQcf/Yg01kLqjQ2vgJ4iF8e+BxDeVfek9w09kHNgTtWfloa6M9vZfkcMndko
         P7OcTak5OqvEIPyvXQWKAWL+I8ggor676Gl/ZAi6tD9BKnndGPwZ7BvztfkW2AhvCb8R
         tR/GD/91sPOM597EU4hYlxBCxNUOtcOS//siFo9xeGqGNy3zDONYdoD96hDRtLWBhXcm
         Byeq6nHbFyFT30rJHeC0Nb+6pxh9lH0EVYDxKzB8NWOQutGWPYb4A/qE1Rls4U8bZcHz
         mYIIdEVyiOuvl7+VmIUkr5Wvefplcgdtd4zFb3OLTfwSavPlW1rnb+pi87r3npqnyNeN
         Bt2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759845500; x=1760450300;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4rlYUY99rqPM8GfD927WUvhieIqn1G/yd0+acs0pn14=;
        b=JlbzDNKXbxh1BlCw4aMIEsFGzuFVsEnr0ORwGqEexwOfK+yATMKiL3J+UqaJ4KCwCl
         GIeS3zjarfoBhaneZhdENNlGFrJIbrxpku5/cHou2gIJoKlK36LvhckgN19vLk8flFIC
         MYdPFo54b/k9S2fvRKu91qDWXUgwViIfwpitKt0K7BQXramY/FWLZic1NkJD/q6ncuQb
         PbdDUahUSTNwLJrSVDcsiJYVlZpeXbqf+wJTHQrjACZkfHbqANvwCEf5YbmZphZzc0uh
         irZpW1Be33619gupmTdmYJQdMidaXwwWSPT0HLKNebQxhg4rZYW6/zsNiZIMgYHZklrt
         D8bg==
X-Forwarded-Encrypted: i=1; AJvYcCWmP+nONI8QVpDc3e9Kb4oPehWqQiUpdjIZXK83rpyj7Edmt70bWPy83XWJpz2DQdbPLQU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCU/aD7OTregPFRO5L4510xSNgE6OAJm47vQTtvnq9Tg6bGmUS
	G4x2eqUT9dX1DmuLCx0qHidy48plGqolJsKT8fVqZCxyMIcAXJUzqxNQi+M3KqqMfNxr3f7A8vA
	L1eS8Tg==
X-Google-Smtp-Source: AGHT+IH44LYFtR2Z9aj26aSM38dj+lWGcrky74kzzSLe1xZuZzZCEhZOyIjquiME0rIkS/AaVEe3J4tloO4=
X-Received: from pjbmw12.prod.google.com ([2002:a17:90b:4d0c:b0:329:b272:45a7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c05:b0:335:2823:3686
 with SMTP id 98e67ed59e1d1-339c274089dmr20831446a91.2.1759845499915; Tue, 07
 Oct 2025 06:58:19 -0700 (PDT)
Date: Tue, 7 Oct 2025 06:58:18 -0700
In-Reply-To: <fc0bb268-07b7-41ef-9a82-791d381f56ac@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231105163040.14904-1-pbonzini@redhat.com> <20231105163040.14904-16-pbonzini@redhat.com>
 <fc0bb268-07b7-41ef-9a82-791d381f56ac@amazon.com>
Message-ID: <aOUceqlAnsjQ8mo4@google.com>
Subject: Re: [PATCH 15/34] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From: Sean Christopherson <seanjc@google.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Anish Moorthy <amoorthy@google.com>, David Matlack <dmatlack@google.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 03, 2025, Nikita Kalyazin wrote:
> On 05/11/2023 16:30, Paolo Bonzini wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > 
> > Introduce an ioctl(), KVM_CREATE_GUEST_MEMFD, to allow creating file-based
> > memory that is tied to a specific KVM virtual machine and whose primary
> > purpose is to serve guest memory.
> 
> ...
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index f1a575d39b3b..8f46d757a2c5 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> 
> ...
> 
> > -static int check_memory_region_flags(const struct kvm_userspace_memory_region2 *mem)
> > +static int check_memory_region_flags(struct kvm *kvm,
> > +				     const struct kvm_userspace_memory_region2 *mem)
> >   {
> >   	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
> > +	if (kvm_arch_has_private_mem(kvm))
> > +		valid_flags |= KVM_MEM_GUEST_MEMFD;
> > +
> > +	/* Dirty logging private memory is not currently supported. */
> > +	if (mem->flags & KVM_MEM_GUEST_MEMFD)
> > +		valid_flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
> 
> I was wondering whether this restriction is still required at this stage or
> can be lifted in cases where the guest memory is accessible by the host.

Off the top of my head, I can't think of any reason why dirty logging wouldn't
work with guest_memfd for non-CoCo VMs.  We'd likely need to explicitly enumerate
support to userspace, and there might be some assumptions lurking in KVM, but
fundamentally it should Just Work (TM).

> Specifically, it would be useful to support differential memory snapshots
> based on dirty page tracking in Firecracker [1] or in live migration.  As an
> experiment, I removed the check and was able to produce a diff snapshot and
> restore a Firecracker VM from it.
> 
> [1] https://github.com/firecracker-microvm/firecracker/blob/main/docs/snapshotting/snapshot-support.md#creating-diff-snapshots
> 
> > +
> >   #ifdef __KVM_HAVE_READONLY_MEM
> >   	valid_flags |= KVM_MEM_READONLY;
> >   #endif
> > @@ -2018,7 +2029,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >   	int as_id, id;
> >   	int r;
> > -	r = check_memory_region_flags(mem);
> > +	r = check_memory_region_flags(kvm, mem);
> >   	if (r)
> >   		return r;

