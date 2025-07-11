Return-Path: <kvm+bounces-52138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A3BFCB01A53
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:09:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3BF1F7BBC08
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 11:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 972A7289806;
	Fri, 11 Jul 2025 11:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wE3+qMbi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0BCA920
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 11:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752232175; cv=none; b=btEs0oZQmywsQA8YJNdJdyMctd1ta207jeCTKNSQYuyh1hce1iBjLo5/pZ/zUHiegeDOMeHH4xLU2Yvgk+MdsgSEj9ULDI2X/mcBjpJFgotruVr68DEaiGAhaaNa30kkYI27/2xNnaZNFpnEi3s9jo9IgdxVnyl7Dy2HN/jrkFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752232175; c=relaxed/simple;
	bh=pEbsbZRW72uqAMiY+GWSPB3tnRE4dYbX0ZSg/zik3CM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GbX61n8GWBx6/7Y4/QPPPP2waiNobztV5lOFQgRHnVbslWEaVXR65lwyJqWCzx9JtR8m13BbLABXKlj+Zzu2SOzqAuWyio98aOK3lltgB1ABbIwUifnCAwUNqT8IHfqiaubkSr4SWH2lErf3LhcfMHZ2N9MX48Mr6bNhVD+PSRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wE3+qMbi; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso100081cf.0
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 04:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752232173; x=1752836973; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YtL2RY30FqQCse8pZRhypsMK1Ug1daCGyP2jBjuiKck=;
        b=wE3+qMbizN8X/mDoh8cIWnDGvuwBTzvFFjajouOToSxs04BNz4lzpIAdxKSXH9/8bh
         EWY7E7ZwUZXZqIHEsraQm/pJ5lqKAVK+sYa6CzWyaSV2mXrIHN3xWa8UXOkx3FK2Desu
         e+pH/HCuOL1rEIv5oohwjVa9mK3IMzI1Wj7XqxoTQRf9rtMMeTZKWU2gxuHHiqJfG+ay
         xDwMT6qEgxNWtUA71f8h99vPmkB4M3OTwO7gKNBAb9SBDdmWCteeLRQ9bh4arOyFYqKT
         Vi2rhOgIMkQvol8vclnGpMifuI0XmB8piw4/hImFQxNL9FMbM+UACgRlqB1J5tyxRUfF
         fomw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752232173; x=1752836973;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YtL2RY30FqQCse8pZRhypsMK1Ug1daCGyP2jBjuiKck=;
        b=dUi2YJEENG+GDfiKobWDvjq8FTo5akVH/cAzKAd45JHrCo87NXOHW421Jang2eqv12
         l87Hwbibh9kL3d8oUZ5h2XhqSyuGjvFMYd7cfxC3Xzi9tSJciSS/uPR32pLO7qBpgWPA
         xxHRep/O2fZ4bPRaaTBck2DQvwtOv7It/F0nGKWumTPg0GJ4AkzRyQAsTDPr2Rf7n1sC
         BN6JiHBqkoIWR0RJRZ3fUTuioS+mPv7EXYj7klrJmh54oRt07BAnKTcqDUwRJYev052M
         9mEJ0M5YMstykzbhSgLJDDFRVI9TNvq6ZzYe3HC2VyHJT8iy5reum2nr6tkYxjmbXcow
         XntQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1KFFsmW5LY+dH5KBsQE2Wy9KEklIBg6mbN8lzrDRDry72nkhEjFQBNR0QzSRxnQGhPN4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCQYYMT/gbZ51Ps7z8z4MDHjxaW7e8A2iwUq/aQWVK7hJygLl7
	KNaepfQLTyuqjzdJdZKhtCY6opO32L/98Y/hgx5s9qEuziCv2PZk3fayKUX/iNKCxiAu4ui7idi
	UhbeIbb3JYgUYrd0I+H4BfkVsr8mtx/vS4vog+DTX
X-Gm-Gg: ASbGncvQbu6VufztyTzsBni18r+BnG3W4OVhLaQpdM5R2tULQZbs0CWUU8O12gpz3sU
	oHDcv7U34lrAXxihe34jBzWcZMmwU9srT1dNmnd70hC6gB82TilKM5ue+WRidMpw628pI8a43Wa
	+Ba8oakxF6aqwbHkiIWEzxQ1nSUOmnQmu6v0yjlBWHbJjdpuJcMWNaXdbC49Ecx3WOxKyJDmt27
	MUi/vYrXjVOi/efEA==
X-Google-Smtp-Source: AGHT+IERmXIWH70IswPePcnTHu8w/geAIcWqwjz0lTJocB7rOcnLO6OtVHZyap867obl3kpAHCdb6bS3TpHBmI7izYE=
X-Received: by 2002:ac8:7d4e:0:b0:4a5:9af6:8f84 with SMTP id
 d75a77b69052e-4a9fbe8344fmr3522001cf.14.1752232172426; Fri, 11 Jul 2025
 04:09:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709105946.4009897-17-tabba@google.com> <20250711095937.22365-1-roypat@amazon.co.uk>
In-Reply-To: <20250711095937.22365-1-roypat@amazon.co.uk>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 11 Jul 2025 12:08:55 +0100
X-Gm-Features: Ac12FXy7m-zlvbmjUHarQqtRk7cRzn7RmdIcZj367UfAD88hqnMBvOGnU1eJgFc
Message-ID: <CA+EHjTz8nC-_904=N==B=SJ0sb8AV047LbnA8x6gqZr3cRONPQ@mail.gmail.com>
Subject: Re: [PATCH v13 16/20] KVM: arm64: Handle guest_memfd-backed guest
 page faults
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "ackerleytng@google.com" <ackerleytng@google.com>, 
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
	"mail@maciej.szmigiero.name" <mail@maciej.szmigiero.name>, "maz@kernel.org" <maz@kernel.org>, 
	"mic@digikod.net" <mic@digikod.net>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, 
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

Hi Patrick,


On Fri, 11 Jul 2025 at 10:59, Roy, Patrick <roypat@amazon.co.uk> wrote:
>
>
> Hi Fuad,
>
> On Wed, 2025-07-09 at 11:59 +0100, Fuad Tabba wrote:> -snip-
> > +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
> > +
> > +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > +                     struct kvm_s2_trans *nested,
> > +                     struct kvm_memory_slot *memslot, bool is_perm)
> > +{
> > +       bool write_fault, exec_fault, writable;
> > +       enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
> > +       enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
> > +       struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
> > +       struct page *page;
> > +       struct kvm *kvm = vcpu->kvm;
> > +       void *memcache;
> > +       kvm_pfn_t pfn;
> > +       gfn_t gfn;
> > +       int ret;
> > +
> > +       ret = prepare_mmu_memcache(vcpu, true, &memcache);
> > +       if (ret)
> > +               return ret;
> > +
> > +       if (nested)
> > +               gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> > +       else
> > +               gfn = fault_ipa >> PAGE_SHIFT;
> > +
> > +       write_fault = kvm_is_write_fault(vcpu);
> > +       exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
> > +
> > +       if (write_fault && exec_fault) {
> > +               kvm_err("Simultaneous write and execution fault\n");
> > +               return -EFAULT;
> > +       }
> > +
> > +       if (is_perm && !write_fault && !exec_fault) {
> > +               kvm_err("Unexpected L2 read permission error\n");
> > +               return -EFAULT;
> > +       }
> > +
> > +       ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
> > +       if (ret) {
> > +               kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
> > +                                             write_fault, exec_fault, false);
> > +               return ret;
> > +       }
> > +
> > +       writable = !(memslot->flags & KVM_MEM_READONLY);
> > +
> > +       if (nested)
> > +               adjust_nested_fault_perms(nested, &prot, &writable);
> > +
> > +       if (writable)
> > +               prot |= KVM_PGTABLE_PROT_W;
> > +
> > +       if (exec_fault ||
> > +           (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
> > +            (!nested || kvm_s2_trans_executable(nested))))
> > +               prot |= KVM_PGTABLE_PROT_X;
> > +
> > +       kvm_fault_lock(kvm);
>
> Doesn't this race with gmem invalidations (e.g. fallocate(PUNCH_HOLE))?
> E.g. if between kvm_gmem_get_pfn() above and this kvm_fault_lock() a
> gmem invalidation occurs, don't we end up with stage-2 page tables
> refering to a stale host page? In user_mem_abort() there's the "grab
> mmu_invalidate_seq before dropping mmap_lock and check it hasnt changed
> after grabbing mmu_lock" which prevents this, but I don't really see an
> equivalent here.

You're right. I'll add a check for this.

Thanks for pointing this out,
/fuad

> > +       ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_SIZE,
> > +                                                __pfn_to_phys(pfn), prot,
> > +                                                memcache, flags);
> > +       kvm_release_faultin_page(kvm, page, !!ret, writable);
> > +       kvm_fault_unlock(kvm);
> > +
> > +       if (writable && !ret)
> > +               mark_page_dirty_in_slot(kvm, memslot, gfn);
> > +
> > +       return ret != -EAGAIN ? ret : 0;
> > +}
> > +
> > -snip-
>
> Best,
> Patrick
>
>

