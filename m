Return-Path: <kvm+bounces-52169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92E4CB01EE3
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 16:19:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26B205827C5
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 14:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4A3A2E499A;
	Fri, 11 Jul 2025 14:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ldasQLkh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E472DFF28
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 14:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752243506; cv=none; b=HcCzwkkO7wfCVyxl05jCJLcdQhdELXHrLaxa9KiqjrLtmpMUY8j2y3DHpKgxHWnl8KNL12XhyCnfVqsTH0ooxxOJDZkNpbKIdaVc3w2p/sAet3NnQSljA+zuj2KrlJF1Kd6brED1D4KSrbr5hiT3rItiF49j8Aj5SbHEucPUHU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752243506; c=relaxed/simple;
	bh=EeHQX3xHa/SasShpS2hysO5j+FP/KZl3ZrefBTI2Wdo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UcPi771laZ0yKeHmQBfwcP2fU8NMlsBB9EmC7O0f0OfTiNpmeiiBEMCx/DKoDuLeBsLJpsQYNhqHP44pPNFIIwVZgXirMSYjDWOWyxOXOy+3xKbvXAGAPpR3nO1AoNN585XFenJ2JX5sNGKCknCtnos3JiivYW+kmphY6rwZ9bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ldasQLkh; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso167681cf.0
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 07:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752243504; x=1752848304; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SPqXh8MG6l1A7ppi1PWLeVr8JkzkP6r8TXr4WFndhco=;
        b=ldasQLkhO4TyYirnq5XDRizAfGHZLV5GfU7p/n1Ya7DvaJOh+wFbgrcd1jGnwyrl2o
         yN2THmb7Lj47WQ8lZyw3N4R78QrYHqxFUyrMnaNQRoHgRnEn0vbR/lG84DSduTtMcbXL
         ozeaUSMkhJfWroWFCm7cp2c9OIHltm/5EWz9xbwQtIK6qQdOU5xofYGlV/F/QyeKEUV9
         l7egifHXu5aZlnE8VP2BIXHhzuW2ptjyXTEKDawWMy3hH8rMkDLq1JGNC2E65AHAo6q4
         hkipXEq0hmIxycCMyxoI+G3XVjDAZKuHRbIMqPpyZZOBBpRMi1O8/Z7dYa63vXpmi+vU
         joJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752243504; x=1752848304;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SPqXh8MG6l1A7ppi1PWLeVr8JkzkP6r8TXr4WFndhco=;
        b=iko9GsQMgtKbhASVVDmhURlhPaUD4/sKu8NiuU+a6y9IfO8nxWSFnyVra9axYh1OxL
         DiCUuP6E9l4yVt3vFsiWIr3PgDC4JEzxSJqhcqbtMOw4VRMhsCF2D6cE9eCfSsZdV129
         qUO1jXOufWuGHtRLmV5hYYXmE9Hzw6NQWiJ9RB6Cig6Yuu/ougUQogfoAaSvznaFj/P6
         UM9Ete4L8SmHO2FAc97AvG5xSe4jjSdgAddU8vdo025p7fM7URerzUV/I8YHsPji3Oye
         erL2yNlale7BlAiSmGWPIlAGKsyoQ+VFwUL+oTTw4mCjt5kZiu9j5LiHtxrFj80FiWGE
         NDzw==
X-Forwarded-Encrypted: i=1; AJvYcCWMGe5GtI1e8oNpgxb/LpixwUsa3tUQO1NiMpicXFngYausXP+To7F0oxPvdDOqwArSPoA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgCiXRcovQKtt0jj85opkCkzazlRbAh0q8HVHoOMBD55iivMMq
	taLWvKvl4TLxDup2vgF8dq3m3eHtp31XOIVNYmkkwq0om94epUJeMT+DftjHwqikllLdgUfGhih
	h8JT+5SB/q2tGLlodnR463+MqbgLZkorA10oPpeJk
X-Gm-Gg: ASbGncv2q6i31bvfDplP64ayuB0JMrwthWBX3FFBMXuNx+dleKvqWgJ3oRbY6fwoa3V
	0FIgesuo+xvVrHGdinoZDzoBWr11Yzh3Ja7jnhqLkHeCmdrfjP9b787e+tKLxz8VADCmv2BIZih
	4GIw8Vlb0pnxG9AXeUTRkLcGs+zimPluZCruK9w8SS4NqctX7LFNHZpCZNXvpmG0YH+oDqphReC
	DzL8is=
X-Google-Smtp-Source: AGHT+IFB29LZRp6S9EJ4JwmCmEMzaf7JXF7ZrEyQ3VcuzP+ZF9XJDCj3TztBCcGyfvrNcJcm+eOBHyX3XQUVn4sD0j4=
X-Received: by 2002:a05:622a:49:b0:4a9:d263:d983 with SMTP id
 d75a77b69052e-4a9fbf49438mr3728031cf.22.1752243503244; Fri, 11 Jul 2025
 07:18:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709105946.4009897-17-tabba@google.com> <20250711095937.22365-1-roypat@amazon.co.uk>
 <86a55aalbv.wl-maz@kernel.org>
In-Reply-To: <86a55aalbv.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 11 Jul 2025 15:17:46 +0100
X-Gm-Features: Ac12FXwgQHu30_kYr5OEcOlHvsbWxMi7kgse2dUFQjfHWptAQiWGsqT7tOy6s0Q
Message-ID: <CA+EHjTz-MWYUKA6dbcZGvt=rRXnorrpJHbNLq-Kng5q7yaLERA@mail.gmail.com>
Subject: Re: [PATCH v13 16/20] KVM: arm64: Handle guest_memfd-backed guest
 page faults
To: Marc Zyngier <maz@kernel.org>
Cc: "Roy, Patrick" <roypat@amazon.co.uk>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "amoorthy@google.com" <amoorthy@google.com>, 
	"anup@brainfault.org" <anup@brainfault.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"brauner@kernel.org" <brauner@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "david@redhat.com" <david@redhat.com>, 
	"dmatlack@google.com" <dmatlack@google.com>, "fvdl@google.com" <fvdl@google.com>, 
	"hch@infradead.org" <hch@infradead.org>, "hughd@google.com" <hughd@google.com>, 
	"ira.weiny@intel.com" <ira.weiny@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"isaku.yamahata@intel.com" <isaku.yamahata@intel.com>, "james.morse@arm.com" <james.morse@arm.com>, 
	"jarkko@kernel.org" <jarkko@kernel.org>, "jgg@nvidia.com" <jgg@nvidia.com>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"keirf@google.com" <keirf@google.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>, 
	"linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"mail@maciej.szmigiero.name" <mail@maciej.szmigiero.name>, "mic@digikod.net" <mic@digikod.net>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>, 
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, 
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"peterx@redhat.com" <peterx@redhat.com>, "qperret@google.com" <qperret@google.com>, 
	"quic_cvanscha@quicinc.com" <quic_cvanscha@quicinc.com>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, 
	"quic_mnalajal@quicinc.com" <quic_mnalajal@quicinc.com>, 
	"quic_pderrin@quicinc.com" <quic_pderrin@quicinc.com>, 
	"quic_pheragu@quicinc.com" <quic_pheragu@quicinc.com>, 
	"quic_svaddagi@quicinc.com" <quic_svaddagi@quicinc.com>, 
	"quic_tsoni@quicinc.com" <quic_tsoni@quicinc.com>, "rientjes@google.com" <rientjes@google.com>, 
	"seanjc@google.com" <seanjc@google.com>, "shuah@kernel.org" <shuah@kernel.org>, 
	"steven.price@arm.com" <steven.price@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"vannapurve@google.com" <vannapurve@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "wei.w.wang@intel.com" <wei.w.wang@intel.com>, 
	"will@kernel.org" <will@kernel.org>, "willy@infradead.org" <willy@infradead.org>, 
	"xiaoyao.li@intel.com" <xiaoyao.li@intel.com>, "yilun.xu@intel.com" <yilun.xu@intel.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Fri, 11 Jul 2025 at 14:50, Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 11 Jul 2025 10:59:39 +0100,
> "Roy, Patrick" <roypat@amazon.co.uk> wrote:
> >
> >
> > Hi Fuad,
> >
> > On Wed, 2025-07-09 at 11:59 +0100, Fuad Tabba wrote:> -snip-
> > > +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
> > > +
> > > +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > > +                     struct kvm_s2_trans *nested,
> > > +                     struct kvm_memory_slot *memslot, bool is_perm)
> > > +{
> > > +       bool write_fault, exec_fault, writable;
> > > +       enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
> > > +       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > > +       struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> > > +       struct page *page;
> > > +       struct kvm *kvm = vcpu->kvm;
> > > +       void *memcache;
> > > +       kvm_pfn_t pfn;
> > > +       gfn_t gfn;
> > > +       int ret;
> > > +
> > > +       ret = prepare_mmu_memcache(vcpu, true, &memcache);
> > > +       if (ret)
> > > +               return ret;
> > > +
> > > +       if (nested)
> > > +               gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> > > +       else
> > > +               gfn = fault_ipa >> PAGE_SHIFT;
> > > +
> > > +       write_fault = kvm_is_write_fault(vcpu);
> > > +       exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> > > +
> > > +       if (write_fault && exec_fault) {
> > > +               kvm_err("Simultaneous write and execution fault\n");
> > > +               return -EFAULT;
> > > +       }
> > > +
> > > +       if (is_perm && !write_fault && !exec_fault) {
> > > +               kvm_err("Unexpected L2 read permission error\n");
> > > +               return -EFAULT;
> > > +       }
> > > +
> > > +       ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
> > > +       if (ret) {
> > > +               kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
> > > +                                             write_fault, exec_fault, false);
> > > +               return ret;
> > > +       }
> > > +
> > > +       writable = !(memslot->flags & KVM_MEM_READONLY);
> > > +
> > > +       if (nested)
> > > +               adjust_nested_fault_perms(nested, &prot, &writable);
> > > +
> > > +       if (writable)
> > > +               prot |= KVM_PGTABLE_PROT_W;
> > > +
> > > +       if (exec_fault ||
> > > +           (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
> > > +            (!nested || kvm_s2_trans_executable(nested))))
> > > +               prot |= KVM_PGTABLE_PROT_X;
> > > +
> > > +       kvm_fault_lock(kvm);
> >
> > Doesn't this race with gmem invalidations (e.g. fallocate(PUNCH_HOLE))?
> > E.g. if between kvm_gmem_get_pfn() above and this kvm_fault_lock() a
> > gmem invalidation occurs, don't we end up with stage-2 page tables
> > refering to a stale host page? In user_mem_abort() there's the "grab
> > mmu_invalidate_seq before dropping mmap_lock and check it hasnt changed
> > after grabbing mmu_lock" which prevents this, but I don't really see an
> > equivalent here.
>
> Indeed. We have a similar construct in kvm_translate_vncr() as well,
> and I'd definitely expect something of the sort 'round here. If for
> some reason this is not needed, then a comment explaining why would be
> welcome.
>
> But this brings me to another interesting bit: kvm_translate_vncr() is
> another path that deals with a guest translation fault (despite being
> caught as an EL2 S1 fault), and calls kvm_faultin_pfn(). What happens
> when the backing store is gmem? Probably nothin

I'll add guest_memfd handling logic to kvm_translate_vncr().

> I don't immediately see why NV and gmem should be incompatible, so
> something must be done on that front too (including the return to
> userspace if the page is gone).

Should it return to userspace or go back to the guest?
user_mem_abort() returns to the guest if the page disappears (I don't
quite understand the rationale behind that, but it was a deliberate
change [1]): on mmu_invalidate_retry() it sets ret to -EAGAIN [2],
which gets flipped to 0 on returning from user_mem_abort() [3].

[1] https://lore.kernel.org/all/20210114121350.123684-4-wangyanan55@huawei.com/
[2] https://elixir.bootlin.com/linux/v6.16-rc5/source/arch/arm64/kvm/mmu.c#L1690
[3] https://elixir.bootlin.com/linux/v6.16-rc5/source/arch/arm64/kvm/mmu.c#L1764

Cheers,
/fuad


> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

