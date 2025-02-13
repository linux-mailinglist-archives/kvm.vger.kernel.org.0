Return-Path: <kvm+bounces-38011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 998C2A339E1
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 09:25:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73110188C8A2
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 08:25:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE9B120C009;
	Thu, 13 Feb 2025 08:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JIYVhPuo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D7F20B7E8
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 08:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739435138; cv=none; b=g/UkkGBz/8od/I24QFVWQfwJXK3GCOeWknSW17WVkYFSTru9albAYCk1AxjV1pDqSBdZJWV6n9EIkTffTs0WKLhLjnZygEVwrAKsFzoeV9KVtp5jZFOqktjRWBIusBj6Q+xytMpGZQunMdOYAhOgZ7ChxkIinyOjGdb3UrVu1j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739435138; c=relaxed/simple;
	bh=kPO1tc82x3B/hTEAGztrzX0xKtUpDpnoP9c35ehnQ6c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gs1WD/56Eb6qHQQaCEBdF/8zAypxCRl/8Pw+cRLJvV9H17ryW3fMTEkZCruy6Qw2XVl1T2JZ1XTetV8muWfJ4mDvfneHFdc/b8j7SwVR0sZA+S69GmZR+aanIX7DDMx5EVJbeP8zU0suDAx3iEW9fDlhtkvN4AMpuWzV3AgSSu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JIYVhPuo; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-47180c199ebso144931cf.0
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 00:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739435134; x=1740039934; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YIO7H+WXIoRkEaRZulor7Xae9SUOPAovGJ7X7Qex5fY=;
        b=JIYVhPuoJmw47DgKaQRrMfyWP0zq9yL2GHyir/1vVW8pj2dmyUYhvoPcEW8URvFWgi
         0tUqWZC0C8wi55c9p8nieWeE76hyFmJXElv1v19PXTY+TDV8JgK+bXl3Nq0cnewQka4b
         PXEWvgIeCUUqgNnh9WjWz1KYVn+cu1tIhwjykmFxj0ECkY6hyxLE0iE9QxiTId4fmUON
         oY4wi3bFgI8hc0tzsAGxUvswNjMd8/tT77kfA7y/F7eSsH6Q5yvhlfl6mmMdA3D+k/Ve
         82PMLIMZE3vxEEgjIGhthhot/Xen4Vx9z9M8CxWD1qmDPNHq6OM4WYaLaBTKQdZ/t8bj
         j6Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739435134; x=1740039934;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YIO7H+WXIoRkEaRZulor7Xae9SUOPAovGJ7X7Qex5fY=;
        b=q5sAnG5VbG5yzv0IwzOfFlegCk1VmCeJr/quXoy8utAcay0/W/vJ48q/XohYeHdHiy
         fy0TuZgRHvcb5Jm/K4Y6UmDWy0xTdypri9c41v0KDkcPH4mXH+MNIKtQda3YakHIhfdN
         UN0JDBzXx9Les5l466JE8FeXV7Bgd8jRNqYamkNEP1nMWtyCKeIqob+ZCUeTQBbfzzKa
         z/TmIAgpH9dFbi0mOU0GBcLPQ31aoxCAN9Cghz3tCgRVMpz/ipZJrgluzsrDYqaZpdcD
         X0Wd6QR2Br40VnqcLvL+9dyZi14dAlt2K1EZe+fRuzzHTjmP9Aq3AErkileoyDAEuO5W
         ayBA==
X-Gm-Message-State: AOJu0YxymfwXViK+ReyTNGMxcqYG5bqHdx5lAseCybv6g7CbVsZxWXOV
	2Pz27ZQYbL1MIoX0GYtwyPqO60G5A/b1qUe91sN5cTCEN8LpsJ9lxnIvAJOjpBzsyCjywGd0uEx
	3Q0GjRnmq7thOj/1MVjCrZZ8dwpmfigS4X731
X-Gm-Gg: ASbGncsSQJ9yXPdOHsvWsBy2Cd2i1YtrDtpBUB3Rb3MpWwY4s1hN0ZdJXBfhrKp2x2P
	3eBaYxsUVUXi0xNpPC+IGDQpPxhi5E0+BduDeyLi1Pm6o2LQ15pMBCmACD0DJBhByZXDg0oA=
X-Google-Smtp-Source: AGHT+IGVzyHE/LU6Zw8g4d72LuWGhrfsFDxlcENmVL6AWJe3zwC9RJAf2owdTYpyFdLFDhp308ql/pjxSLaUBWAke3s=
X-Received: by 2002:ac8:5dd4:0:b0:471:b96c:726c with SMTP id
 d75a77b69052e-471c0216bcamr2640151cf.20.1739435133955; Thu, 13 Feb 2025
 00:25:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211121128.703390-1-tabba@google.com> <20250211121128.703390-4-tabba@google.com>
 <Z60RacIJMwL0M8On@x1.local>
In-Reply-To: <Z60RacIJMwL0M8On@x1.local>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 13 Feb 2025 08:24:57 +0000
X-Gm-Features: AWEUYZkM07o7Zzm_Om1YM784wK6IGgklVseiQzsh4GkkLThpFRZEVr5Ei8mNkKQ
Message-ID: <CA+EHjTwRNgozO++uK1bFyiRwH7j816g_7Qfhj9VdX55Kh_huSw@mail.gmail.com>
Subject: Re: [PATCH v3 03/11] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Peter,

On Wed, 12 Feb 2025 at 21:24, Peter Xu <peterx@redhat.com> wrote:
>
> On Tue, Feb 11, 2025 at 12:11:19PM +0000, Fuad Tabba wrote:
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index 54e959e7d68f..4e759e8020c5 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -124,3 +124,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
> >  config HAVE_KVM_ARCH_GMEM_INVALIDATE
> >         bool
> >         depends on KVM_PRIVATE_MEM
> > +
> > +config KVM_GMEM_SHARED_MEM
> > +       select KVM_PRIVATE_MEM
> > +       bool
>
> No strong opinion here, but this might not be straightforward enough for
> any reader to know why a shared mem option will select a private mem..
>
> I wonder would it be clearer if we could have a config for gmem alone, and
> select that option no matter how gmem would be consumed.  Then the two
> options above could select it.
>
> I'm not sure whether there're too many guest-memfd stuff hard-coded to
> PRIVATE_MEM, actually that's what I hit myself both in qemu & kvm when I
> wanted to try guest-memfd on QEMU as purely shared (aka no conversions, no
> duplicated backends, but in-place).  So pretty much a pure question to ask
> here.

Yes, the whole thing with guest_memfd being initially called private
mem has left a few things like this, e.g., config options, function
names. It has caused (and will probably continue to cause) confusion.

In order not to blend bikeshedding over names and the patch series
adding mmap support (i.e., this one), I am planning on sending a
separate patch series to handle the name issue/

> The other thing is, currently guest-memfd binding only allows 1:1 binding
> to kvm memslots for a specific offset range of gmem, rather than being able
> to be mapped in multiple memslots:
>
> kvm_gmem_bind():
>         if (!xa_empty(&gmem->bindings) &&
>             xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT)) {
>                 filemap_invalidate_unlock(inode->i_mapping);
>                 goto err;
>         }
>
> I didn't dig further yet, but I feel like this won't trivially work with
> things like SMRAM when in-place, which can map the same portion of a gmem
> range more than once.  I wonder if this is a hard limit for guest-memfd,
> and whether you hit anything similar when working on this series.

I haven't thought about this much, but it could be something to tackle later on.

Thank you,
/fuad

> Thanks,
>
> --
> Peter Xu
>

On Wed, 12 Feb 2025 at 21:24, Peter Xu <peterx@redhat.com> wrote:
>
> On Tue, Feb 11, 2025 at 12:11:19PM +0000, Fuad Tabba wrote:
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index 54e959e7d68f..4e759e8020c5 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -124,3 +124,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
> >  config HAVE_KVM_ARCH_GMEM_INVALIDATE
> >         bool
> >         depends on KVM_PRIVATE_MEM
> > +
> > +config KVM_GMEM_SHARED_MEM
> > +       select KVM_PRIVATE_MEM
> > +       bool
>
> No strong opinion here, but this might not be straightforward enough for
> any reader to know why a shared mem option will select a private mem..
>
> I wonder would it be clearer if we could have a config for gmem alone, and
> select that option no matter how gmem would be consumed.  Then the two
> options above could select it.
>
> I'm not sure whether there're too many guest-memfd stuff hard-coded to
> PRIVATE_MEM, actually that's what I hit myself both in qemu & kvm when I
> wanted to try guest-memfd on QEMU as purely shared (aka no conversions, no
> duplicated backends, but in-place).  So pretty much a pure question to ask
> here.
>
> The other thing is, currently guest-memfd binding only allows 1:1 binding
> to kvm memslots for a specific offset range of gmem, rather than being able
> to be mapped in multiple memslots:
>
> kvm_gmem_bind():
>         if (!xa_empty(&gmem->bindings) &&
>             xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT)) {
>                 filemap_invalidate_unlock(inode->i_mapping);
>                 goto err;
>         }
>
> I didn't dig further yet, but I feel like this won't trivially work with
> things like SMRAM when in-place, which can map the same portion of a gmem
> range more than once.  I wonder if this is a hard limit for guest-memfd,
> and whether you hit anything similar when working on this series.
>
> Thanks,
>
> --
> Peter Xu
>

