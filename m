Return-Path: <kvm+bounces-49623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CE2EADB399
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 16:23:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22B421889E8C
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 14:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F1232153ED;
	Mon, 16 Jun 2025 14:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BqTu91rv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993F120DD54
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 14:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750083423; cv=none; b=NlGsoZMNY+F4Oztw3jNuW4KIIG1IuYpTpwJuk7X1tpClqyBI5Fq1lJjhxOgIuzEokWIgbRi88W57uH9cy2wB0COUWmPdq2/TiPBpdMjwUXFxtH8gDukaO6sl/dQTOnDkV7U00bkIm6F5mm2xHD7OHKVcEgc72dlOo6cUN+jf+9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750083423; c=relaxed/simple;
	bh=9uRf0WMCaGLLdpM9p3n0p1w7LXUdHBAlts8JzTpgscA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NIacOkR49pKzVxlLwfEUxTKARDmJcnc/mB5oUwJPQq4F3bdtMgfqABg2DWG3Z+TghkNt6DPgLLCX7MtitQb/zzFUTfMY3pBUCCrt8on7kzvt0PHU6z4BEx5pydpzD3bpg8CS5qFLlQb00XGoaWFNv562P4A5TQ/MgSRQgBshsHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BqTu91rv; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4a58ef58a38so371831cf.0
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 07:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750083420; x=1750688220; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iliBNCA/alokLJH8ihl4uJo9frRveDfW0WQYLrLAMnQ=;
        b=BqTu91rvlvPxredVoEg+z5B8Ij8Q9ZP07bvxGFUyHClR22UEE0Jw8neXUpGAXDECKh
         5kZTntCYsxnIuazOnoR2M9tXfEbq9Mo+Lub6+mlTcgGiIemUrhlF/KeYu6MIoInYjklg
         O9uKRXA6gGCWnxKkbEtS78DpLbIqJrogKG7R75qGVGpNYl9FBVx1+mF6U4IAXkKYUiuP
         uyPlJvG7maTUNU/L5Q/aeaBkbDKGZopBp0uy4UhcJRqsv+iBWtbfZEZ5ZjRMu6Twf09a
         XLsu6k175Oa88Vn4RAWwSaFr8Bu0Gbo+PC5AWI6NxuyEJEcxozb8TGbuBQEjPQV8yXhD
         5q2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750083420; x=1750688220;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iliBNCA/alokLJH8ihl4uJo9frRveDfW0WQYLrLAMnQ=;
        b=n2kvDwOgxW+Hh8hrcecT30bULA8UqzQImpwhjkmnc2hBO1DejOWcwTH18BCHlF61ig
         qmrYBKFSawifn5Fp+sM+9awC3RylldHw9ZBTgY48HTE+dnwimthe9nc/gSKZOKRz70z/
         bFtNeJHiwS5x6yQ3mZsrfLvVNhfdTTy+cLpcI69dHDOAReXAZkM/TnpUmOSi228fRi04
         fzczLoJBe5oPisBxtwp9KMdz+Xjs8lqNufJ6pBDaIQmNQ0OyIJ/4WNcqsnVMupfunp31
         EYJiE0qPCD1qxzarv4NgQ9akjLhWVIRC2ZxxOec6f+flMC3rYtxX06RydS2MrO7Y9/js
         Ww6g==
X-Forwarded-Encrypted: i=1; AJvYcCUo7bC7XCZX32ySLDx93l25cG3j+aY8LynXeEdk4UPWHApkzOsmzHzvTFV5NvFzfsxpDDE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfcHoRESWQkZYtAS48IqqW85Q9+aSs7PwLritDqzzK+6KAN8XF
	uiZ7LzlNAuPgPtyPcIy9bmiAYJnGwQBN+vX+6dsfgR3CcURsloDJrMtyf8cFXaeAqezMWcmy/RG
	r2B/bbhBye/GHWuTeag2bxAhuYqMJdaqU+/jY5gnc
X-Gm-Gg: ASbGncullFApokAIH1WFIZzr/11wpgXzSyGlsO35UuqhYslQJvyrRadm6i8Dcbyye3U
	QZwkndbilUGwd6vAtDYh4EOCB88gwvpIc5Eog8ehKmPvaMTKSCFbkLcA+KBTwu41sBJmrEjcIuh
	cJ4akHgq/IxFDN9xn1Vwho3TxIug4zEoIz6SZORPlrAII=
X-Google-Smtp-Source: AGHT+IGzWmuYL3B8dV748tigWYEhH43hk3bAQ+TCIZFE52eDg3g6la4vCh3GTbO8RbJbKaucVpM7Es71i3t5qjUi6DM=
X-Received: by 2002:ac8:598b:0:b0:47b:3a5:8380 with SMTP id
 d75a77b69052e-4a73d730e4dmr6595391cf.28.1750083420050; Mon, 16 Jun 2025
 07:17:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-9-tabba@google.com>
 <aEySD5XoxKbkcuEZ@google.com> <68501fa5dce32_2376af294d1@iweiny-mobl.notmuch> <bbc213c3-bc3d-4f57-b357-a79a9e9290c5@redhat.com>
In-Reply-To: <bbc213c3-bc3d-4f57-b357-a79a9e9290c5@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 16 Jun 2025 15:16:23 +0100
X-Gm-Features: AX0GCFubuN1u9odHppAUjWTL1pNLwEjisFi03_cvycUw_8Z9O5jZLBfZUe_W0d0
Message-ID: <CA+EHjTxvqDr1tavpx7d9OyC2VfUqAko864zH9Qn5+B0UQiM93g@mail.gmail.com>
Subject: Re: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map guest_memfd pages
To: David Hildenbrand <david@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
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

On Mon, 16 Jun 2025 at 15:03, David Hildenbrand <david@redhat.com> wrote:
>
> On 16.06.25 15:44, Ira Weiny wrote:
> > Sean Christopherson wrote:
> >> On Wed, Jun 11, 2025, Fuad Tabba wrote:
> >>> This patch enables support for shared memory in guest_memfd, including
> >>
> >> Please don't lead with with "This patch", simply state what changes are being
> >> made as a command.
> >>
> >>> mapping that memory from host userspace.
> >>
> >>> This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
> >>> and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
> >>> flag at creation time.
> >>
> >> Why?  I can see that from the patch.
> >>
> >> This changelog is way, way, waaay too light on details.  Sorry for jumping in at
> >> the 11th hour, but we've spent what, 2 years working on this?
> >>
> >>> Reviewed-by: Gavin Shan <gshan@redhat.com>
> >>> Acked-by: David Hildenbrand <david@redhat.com>
> >>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> >>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>> ---
> >>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> >>> index d00b85cb168c..cb19150fd595 100644
> >>> --- a/include/uapi/linux/kvm.h
> >>> +++ b/include/uapi/linux/kvm.h
> >>> @@ -1570,6 +1570,7 @@ struct kvm_memory_attributes {
> >>>   #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> >>>
> >>>   #define KVM_CREATE_GUEST_MEMFD    _IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> >>> +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED    (1ULL << 0)
> >>
> >> I find the SUPPORT_SHARED terminology to be super confusing.  I had to dig quite
> >> deep to undesrtand that "support shared" actually mean "userspace explicitly
> >> enable sharing on _this_ guest_memfd instance".  E.g. I was surprised to see
> >>
> >> IMO, GUEST_MEMFD_FLAG_SHAREABLE would be more appropriate.  But even that is
> >> weird to me.  For non-CoCo VMs, there is no concept of shared vs. private.  What's
> >> novel and notable is that the memory is _mappable_.  Yeah, yeah, pKVM's use case
> >> is to share memory, but that's a _use case_, not the property of guest_memfd that
> >> is being controlled by userspace.
> >>
> >> And kvm_gmem_memslot_supports_shared() is even worse.  It's simply that the
> >> memslot is bound to a mappable guest_memfd instance, it's that the guest_memfd
> >> instance is the _only_ entry point to the memslot.
> >>
> >> So my vote would be "GUEST_MEMFD_FLAG_MAPPABLE", and then something like
> >
> > If we are going to change this; FLAG_MAPPABLE is not clear to me either.
> > The guest can map private memory, right?  I see your point about shared
> > being overloaded with file shared but it would not be the first time a
> > term is overloaded.  kvm_slot_has_gmem() does makes a lot of sense.
> >
> > If it is going to change; how about GUEST_MEMFD_FLAG_USER_MAPPABLE?
>
> If "shared" is not good enough terminology ...
>
> ... can we please just find a way to name what this "non-private" memory
> is called? That something is mappable into $whatever is not the right
> way to look at this IMHO. As raised in the past, we can easily support
> read()/write()/etc to this non-private memory.
>
>
> I'll note, the "non-private" memory in guest-memfd behaves just like ...
> the "shared" memory in shmem ... well, or like other memory in memfd.
> (which is based on mm/shmem.c).
>
> "Private" is also not the best way to describe the "protected\encrypted"
> memory, but that ship has sailed with KVM_MEMORY_ATTRIBUTE_PRIVATE.
>
> I'll further note that in the doc of KVM_SET_USER_MEMORY_REGION2 we talk
> about "private" vs "shared" memory ... so that would have to be improved
> as well.

To add to what David just wrote, V1 of this series used the term
"mappable" [1].  After a few discussions, I thought the consensus was
that "shared" was a more accurate description --- i.e., mappability
was a side effect of it being shared with the host.

One could argue that non-CoCo VMs have no concept of "shared" vs
"private". A different way of looking at it is, non-CoCo VMs have
their state as shared by default.

I don't have a strong opinion. What would be good if we could agree on
the terminology before I respin this.

Thanks,
/fuad


[1] https://lore.kernel.org/all/20250122152738.1173160-4-tabba@google.com/


> --
> Cheers,
>
> David / dhildenb
>

