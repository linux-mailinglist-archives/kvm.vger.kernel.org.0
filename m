Return-Path: <kvm+bounces-67999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C35CD1BEC8
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 02:26:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D23493069A4E
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 01:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90F4329D281;
	Wed, 14 Jan 2026 01:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FwTIbEtc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4779F22756A
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 01:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768353879; cv=none; b=WghJCJfNpna51uFC2uk5xQZ445TLXPJ+66rkl9u3iiEG1nWPgqOlsjC4R/PHC7SS+2SNsRGs182GsYPBi4sgrJLuskshQkaEidYjQ+D8aMHd8D+4d9v2RC/RV4EFZvJ3OmMPVr4YYK2XAcWeTgT9/pGVrJF/sAEwLhOv0mC2jjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768353879; c=relaxed/simple;
	bh=RhOmT8gnRxb4GJFNX0u3LFK2KCbb7/IvX2Y20hT7PYk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=orn0ElVGcjEDWTM1Sp7dn9CpF0+9ACTzxhA2einZb6YgqxfwBbjK8enGgtsXVb8BvKhrKhdrkcJy8cpcgOMpoOw2qWW+2Ltgtjc9rX2cnam1m+2JYHwY0JQhkcW8GTljmM1Ga+JNO9QpOiTe0jRkDgxv0DIkf3BBy+Tivy0Hhy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FwTIbEtc; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29f2b45ecffso35781445ad.2
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 17:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768353878; x=1768958678; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UREWOOERSGsoei6PYixce07xag0oLXrRqrB4uDGwmcY=;
        b=FwTIbEtcKzydV5EDGLE0dYhB0hQSkABTX/6bULStExcrtXbIls1h4D6hIQoZzYWrdi
         9h6Jxj36173FTM14J0v+5Ah3zLai88dsJ8PFne9IDkAEhLHNnAwfZXOyVAdI1xqZGvhm
         dnxnrkhC/YOHCRbfmLrYP3liSvLqIsIifvWI4lPk1i5L6eJwAZN/pk5zWCGIyatOUsl4
         ijTHPdTul61jxdSDYW4Upuxcf/7LIamppLaM9317eSGlhOgu7cYrGEkOSaK1Y4sPdGBY
         YAUmfx/KfkVwZmiWZbLvukdNQN4OSV+8/fsK2KhcWZLOHI/XfKLMRZE9mUrMCWalXuvt
         dAJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768353878; x=1768958678;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UREWOOERSGsoei6PYixce07xag0oLXrRqrB4uDGwmcY=;
        b=P5SK+6tZsx/xPDZlzHK87tiR2TaDvHczUaY1gxj8NW8T2C7Q327jojMqZMes5rhutt
         963xgI0Rclptby57D/pUCABpSgArB8Jd9pIU1ltyRaV9bkjw8XoIeioZgV3RZemrSGfk
         crRbHPGWbgdxkOx5etr2c8RoReEXEOHJVyqQr/S9KDD/QZ6L53i+L2oNe3juijX82ZHt
         Nh9z7qpAUzExzaNSyv4TOUARDU72W4CLAK9RUJqbcACvRpCXNCclgrYXvsxdzGzmAySY
         2qPuQ0Am0sMz9u8pebtxh66tuvPBzU3pnRlr0xgqh/Cath9leUdNjvlu0NilH9Nzl8Lb
         94Ew==
X-Forwarded-Encrypted: i=1; AJvYcCXG5yR3urj6OqNkxOe8Si+/U8NnURHrO8xdwcZgNTQ57BgzdIZ87Ws11WTIanrSBAgno+s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLQ529BrduKJNP1nefGmJxO3uCt0VS7a+dzut2GpXvG7IWMHHd
	vmvuXfUikmpeBuueCZKy8FVDz0Wk5ofGZ+3MoA4c6NC4KUE+aUf/JN64u2xLHktbMCZpEtoFB2U
	wA5TZWA==
X-Received: from plbkf4.prod.google.com ([2002:a17:903:5c4:b0:29f:1b90:e900])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:191:b0:2a3:e7aa:dd6e
 with SMTP id d9443c01a7336-2a59bc0cad0mr3243415ad.38.1768353877564; Tue, 13
 Jan 2026 17:24:37 -0800 (PST)
Date: Tue, 13 Jan 2026 17:24:36 -0800
In-Reply-To: <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <CAGtprH-eEUzHDUB0CK2V162HHqvE8kT3bAacb6d3xDYJPwBiYA@mail.gmail.com>
 <CAEvNRgGG+xYhsz62foOrTeAxUCYxpCKCJnNgTAMYMV=w2eq+6Q@mail.gmail.com>
 <aV2A39fXgzuM4Toa@google.com> <CAEvNRgFOER_j61-3u2dEoYdFMPNKaVGEL_=o2WVHfBi8nN+T0A@mail.gmail.com>
 <aV2eIalRLSEGozY0@google.com> <CAEvNRgHSm0k2hthxLPg8oXO_Y9juA9cxOBp2YdFFYOnDkxpv5g@mail.gmail.com>
 <aWbkcRshLiL4NWZg@yzhao56-desk.sh.intel.com>
Message-ID: <aWbwVG8aZupbHBh4@google.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Vishal Annapurve <vannapurve@google.com>, pbonzini@redhat.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kas@kernel.org, 
	tabba@google.com, michael.roth@amd.com, david@kernel.org, sagis@google.com, 
	vbabka@suse.cz, thomas.lendacky@amd.com, nik.borisov@suse.com, 
	pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 14, 2026, Yan Zhao wrote:
> On Mon, Jan 12, 2026 at 12:15:17PM -0800, Ackerley Tng wrote:
> > Sean Christopherson <seanjc@google.com> writes:
> > 
> > > Mapping a hugepage for memory that KVM _knows_ is contiguous and homogenous is
> > > conceptually totally fine, i.e. I'm not totally opposed to adding support for
> > > mapping multiple guest_memfd folios with a single hugepage. As to whether we
> > 
> > Sean, I'd like to clarify this.
> > 
> > > do (a) nothing,
> > 
> > What does do nothing mean here?

Don't support hugepage's for shared mappings, at least for now (as Rick pointed
out, doing nothing now doesn't mean we can't do something in the future).

> > In this patch series the TDX functions do sanity checks ensuring that
> > mapping size <= folio size. IIUC the checks at mapping time, like in
> > tdh_mem_page_aug() would be fine since at the time of mapping, the
> > mapping size <= folio size, but we'd be in trouble at the time of
> > zapping, since that's when mapping sizes > folio sizes get discovered.
> > 
> > The sanity checks are in principle in direct conflict with allowing
> > mapping of multiple guest_memfd folios at hugepage level.
> > 
> > > (b) change the refcounting, or
> > 
> > I think this is pretty hard unless something changes in core MM that
> > allows refcounting to be customizable by the FS. guest_memfd would love
> > to have that, but customizable refcounting is going to hurt refcounting
> > performance throughout the kernel.
> > 
> > > (c) add support for mapping multiple folios in one page,
> > 
> > Where would the changes need to be made, IIUC there aren't any checks
> > currently elsewhere in KVM to ensure that mapping size <= folio size,
> > other than the sanity checks in the TDX code proposed in this series.
> > 
> > Does any support need to be added, or is it about amending the
> > unenforced/unwritten rule from "mapping size <= folio size" to "mapping
> > size <= contiguous memory size"?
>
> The rule is not "unenforced/unwritten". In fact, it's the de facto standard in
> KVM.

Ya, more or less.

The rules aren't formally documented because the overarching rule is very
simple: KVM must not map memory into the guest that the guest shouldn't have
access to.  That falls firmly into the "well, duh" category, and so it's not
written down anywhere :-)

How exactly KVM has honored that rule has varied over the years, and still varies
between architectures.  In the past KVM x86 special cased HugeTLB and THP, but
that proved to be a pain to maintain and wasn't extensible, e.g. didn't play nice
with DAX, and so KVM x86 pivoted to pulling the mapping size from the primary MMU
page tables.

But arm64 still special cases THP and HugeTLB, *and* VM_PFNMAP memory (eww).

> For non-gmem cases, KVM uses the mapping size in the primary MMU as the max
> mapping size in the secondary MMU, while the primary MMU does not create a
> mapping larger than the backend folio size.

Super strictly speaking, this might not hold true for VM_PFNMAP memory.  E.g. a
driver _could_ split a folio (no idea why it would) but map the entire thing into
userspace, and then userspace could have off that memory to KVM.

So I wouldn't say _KVM's_ rule isn't so much "mapping size <= folio size", it's
that "KVM mapping size <= primary MMU mapping size", at least for x86.  Arm's
VM_PFNMAP code sketches me out a bit, but on the other hand, a driver mapping
discontiguous pages into a single VM_PFNMAP VMA would be even more sketch.

But yes, ignoring VM_PFNMAP, AFAIK the primary MMU and thus KVM doesn't map larger
than the folio size.

> When splitting the backend folio, the Linux kernel unmaps the folio from both
> the primary MMU and the KVM-managed secondary MMU (through the MMU notifier).
> 
> On the non-KVM side, though IOMMU stage-2 mappings are allowed to be larger
> than folio sizes, splitting folios while they are still mapped in the IOMMU
> stage-2 page table is not permitted due to the extra folio refcount held by the
> IOMMU.
> 
> For gmem cases, KVM also does not create mappings larger than the folio size
> allocated from gmem. This is why the TDX huge page series relies on gmem's
> ability to allocate huge folios.
> 
> We really need to be careful if we hope to break this long-established rule.

+100 to being careful, but at the same time I don't think we should get _too_
fixated on the guest_memfd folio size.  E.g. similar to VM_PFNMAP, where there
might not be a folio, if guest_memfd stopped using folios, then the entire
discussion becomes moot.

And as above, the long-standing rule isn't about the implementation details so
much as it is about KVM's behavior.  If the simplest solution to support huge
guest_memfd pages is to decouple the max order from the folio, then so be it.

That said, I'd very much like to get a sense of the alternatives, because at the
end of the day, guest_memfd needs to track the max mapping sizes _somewhere_,
and naively, tying that to the folio seems like an easy solution.

