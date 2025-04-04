Return-Path: <kvm+bounces-42622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 525ECA7B7EE
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 08:44:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 505373B70B2
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 06:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69C1218B47D;
	Fri,  4 Apr 2025 06:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f0TXJWSF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C1214D283
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 06:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743749052; cv=none; b=o6daqdujkxDnZr4jSI+3fiQmvQawo02NFNf3HkRZN9egjNAOLiPzTESoClx1VG/mhBMwm7e7WpUFsNg3EEHc88VIpaIdGg+0sSuqQmRkLrYzc6vttHi3qfYo/M7bZYKfFHk3UaBVG7UNuKm3DB9RWDArWAbScxRcgy62jPzqy3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743749052; c=relaxed/simple;
	bh=6tboxHh39lsWBhL0q6KdQRyoD4CPiWoAevrPN4IVEBM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wu/1W3tnJSabYLA897Xc23ZQqqoa20hbXmKEHus7LSQt7xirQW8xxq0FRIRdgsv51dZIS92wSSj+LnXXQQ509YU82BgQGXEFKEuXPa5Vea3ygn4nQd3mIv4NvGp9uZu1JK2dANiJbJeiLE9Xl6+WSzK6dByVmcAKjHgGEe7sv+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f0TXJWSF; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4769e30af66so163091cf.1
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 23:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743749049; x=1744353849; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QRp7k+A1pFrQ49ZEN8qzXLBlpSlTBAeehOkWfvELJA8=;
        b=f0TXJWSFvJuDyiUvltCyGdcfsFtZVImr7UawgnwcLt7IgXtGZvcpUa7n8DHgt5QzD6
         8ItV0erSurMjFhoVugBDKEPpRw1clsPWW8kmc6qe8TbFYy6jbcTnUkOTBgEMRtLqcqUO
         Mg9YcpxtYKuCvMzT/4Pmoz67hspNu0EbArTicuyuqAOBzf2DQa3CR/EW/cVBedjSPtcV
         HrtrNSWJhFM4nEvZrnr+EeNQhjHUnOrgS0kwv1YwuuwYxhcp5a20eMNeIEVkV2EFWSTf
         BrCBx+SrtSmOSVErRvQBYGApXPNxIvYDHZEiqJn9MCiHXFZa1a8/T9+bMDQTU6WLOkLr
         IQfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743749049; x=1744353849;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QRp7k+A1pFrQ49ZEN8qzXLBlpSlTBAeehOkWfvELJA8=;
        b=BXhqIhROOQJwHEEnEKkUKDpsh+JKGFR8cZAaCAgqcGt0pOxo6MUVF0ZUg+zB0EncMa
         y+fyjAkE0hd7w4y9WHUKMTLDsriPaLV4Fxd7RrSCZ6/vk9KdWespTTNsdccIigjCoSTj
         Zs6o7+v/vx8jJ/G1upYjJPXLBsJQaOKdZBElXy2u7KMuI4R2Wo4VbjZSl9fy3GGwboj/
         VUThEQBN556xZ8iO95gAlIZlpXHW/RaHAa/OlPnQ7ymD8tjhgGmX9aAmYSzb5BQaxy+d
         6vx7P3Pg1HKOKNIXBwqWGcwxQDL11CTc00ok1KZNtyItSCqkW4jDtb6X/xmSN8yPuChC
         D9VA==
X-Forwarded-Encrypted: i=1; AJvYcCVWPKOh3EBShRRt5eqPocyZKpV8FC4T+FbapouiZ6DRY+CHhq4jVWSrs7M3J2BEwyBclN8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2Y3xqxrUvYCQMNPyv9ulNhFjmYFtBKDOjaOQqK3fD2PLNr5HH
	NW6J/J03GW9XyxcouQKOvz2f8zwyKk1DIoigoIx4SLNmAcW2JNv+ot33LSzAJA9FvNuvea+zc4G
	xXzplBZsckq+htuIYEc08NX4PGhZQznAjaOq9
X-Gm-Gg: ASbGncuqZKZ4/PZANlS2VsQ95hNJI+PRcVPHxuAgjioVtty0+u6AD7YZ5MJ9EA+TSQp
	3MPcSpn7l14YXP9Z3GY0rzrEnq+Kq4d9eTJfiMVgSoCA6OdE2DLlaEPsDMAVyQNewKPn3oZl9Mh
	249Y7X39IQo1x0oWUVjAVrsBPcAw==
X-Google-Smtp-Source: AGHT+IG09thUi2Cg5lfaR7AITr07s/waMELK/8mVmq0xXQpugyCN1C8fMQdmgtAODVMkq1XoS/cFYvIp5rTrjTIV7Wc=
X-Received: by 2002:ac8:5790:0:b0:477:871c:5e80 with SMTP id
 d75a77b69052e-4792654b0f3mr2010081cf.5.1743749049397; Thu, 03 Apr 2025
 23:44:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250328153133.3504118-4-tabba@google.com> <diqz1puanquh.fsf@ackerleytng-ctop.c.googlers.com>
 <Z-3OtjCJYyMXuUX7@google.com> <CA+EHjTwEFm1=pS6hBJ++zujkHCDQtCq548OKZirobPbzCzTqSA@mail.gmail.com>
 <Z-6gZGSbOvfrTPjV@google.com>
In-Reply-To: <Z-6gZGSbOvfrTPjV@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 4 Apr 2025 07:43:32 +0100
X-Gm-Features: ATxdqUFnj4_SKvrYDsdE58wYUCji883bNG1U9QIzdDfMDlyNRgNZNbRwG-gZp1U
Message-ID: <CA+EHjTzpd4BW3RfCRK=S9oNnjAYj_1k2xwxku+msgVwVLwd4Fg@mail.gmail.com>
Subject: Re: [PATCH v7 3/7] KVM: guest_memfd: Track folio sharing within a
 struct kvm_gmem_private
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
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
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="UTF-8"

Hi Sean,

On Thu, 3 Apr 2025 at 15:51, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Apr 03, 2025, Fuad Tabba wrote:
> > On Thu, 3 Apr 2025 at 00:56, Sean Christopherson <seanjc@google.com> wrote:
> > > On Wed, Apr 02, 2025, Ackerley Tng wrote:
> > > > > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > > > > index ac6b8853699d..cde16ed3b230 100644
> > > > > --- a/virt/kvm/guest_memfd.c
> > > > > +++ b/virt/kvm/guest_memfd.c
> > > > > @@ -17,6 +17,18 @@ struct kvm_gmem {
> > > > >     struct list_head entry;
> > > > >  };
> > > > >
> > > > > +struct kvm_gmem_inode_private {
> > > > > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > > > > +   struct xarray shared_offsets;
> > > > > +   rwlock_t offsets_lock;
> > > >
> > > > This lock doesn't work, either that or this lock can't be held while
> > > > faulting, because holding this lock means we can't sleep, and we need to
> > > > sleep to allocate.
> > >
> > > rwlock_t is a variant of a spinlock, which can't be held when sleeping.
> > >
> > > What exactly does offsets_lock protect, and what are the rules for holding it?
> > > At a glance, it's flawed.  Something needs to prevent KVM from installing a mapping
> > > for a private gfn that is being converted to shared.  KVM doesn't hold references
> > > to PFNs while they're mapped into the guest, and kvm_gmem_get_pfn() doesn't check
> > > shared_offsets let alone take offsets_lock.
> >
> > You're right about the rwlock_t. The goal of the offsets_lock is to
> > protect the shared offsets -- i.e., it's just meant to protect the
> > SHARED/PRIVATE status of a folio, not more, hence why it's not checked
> > in kvm_gmem_get_pfn(). It used to be protected by the
> > filemap_invalidate_lock, but the problem is that it would be called
> > from an interrupt context.
> >
> > However, this is wrong, as you've pointed out. The purpose of locking
> > is to ensure  that no two conversions of the same folio happen at the
> > same time. An alternative I had written up is to rely on having
> > exclusive access to the folio to ensure that, since this is tied to
> > the folio. That could be either by acquiring the folio lock, or
> > ensuring that the folio doesn't have any outstanding references,
> > indicating that we have exclusive access to it. This would avoid the
> > whole locking issue.
> >
> > > ... Something needs to prevent KVM from installing a mapping
> > > for a private gfn that is being converted to shared.  ...
> >
> > > guest_memfd currently handles races between kvm_gmem_fault() and PUNCH_HOLE via
> > > kvm_gmem_invalidate_{begin,end}().  I don't see any equivalent functionality in
> > > the shared/private conversion code.
> >
> > For in-place sharing, KVM can install a mapping for a SHARED gfn. What
> > it cannot do is install a mapping for a transient (i.e., NONE) gfn. We
> > don't rely on kvm_gmem_get_pfn() for that, but on the individual KVM
> > mmu fault handlers, but that said...
>
> Consumption of shared/private physical pages _must_ be enforced by guest_memfd.
> The private vs. shared state in the MMU handlers is that VM's view of the world
> and desired state.  The guest_memfd inode is the single source of true for the
> state of the _physical_ page.
>
> E.g. on TDX, if KVM installs a private SPTE for a PFN that is in actuality shared,
> there will be machine checks and the host will likely crash.

I agree. As a plus, I've made that change and it actually simplifies the logic .

> > > I would much, much prefer one large series that shows the full picture than a
> > > mish mash of partial series that I can't actually review, even if the big series
> > > is 100+ patches (hopefully not).
> >
> > Dropping the RFC from the second series was not intentional, the first
> > series is the one where I intended to drop the RFC. I apologize for
> > that.  Especially since I obviously don't know how to handle modules
> > and wanted some input on how to do that :)
>
> In this case, the rules for modules are pretty simple.  Code in mm/ can't call
> into KVM.  Either avoid callbacks entirely, or implement via a layer of
> indirection, e.g. function pointer or ops table, so that KVM can provide its
> implementation at runtime.

Ack.

Thanks again!
/fuad

