Return-Path: <kvm+bounces-37900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 49CAFA31261
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 18:05:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4F1507A4C5D
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 17:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DDF8260A22;
	Tue, 11 Feb 2025 17:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kfGr+D8u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1830525EFB0
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 17:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739293485; cv=none; b=XnH8XapMh1ykVj50SKz9DkoOL68X7UvOEhof43iwTwFP69Du5Nw3IWmUzwWjpFOJ1u3v/MzwSSximDOJfMQc9xuLtelH05vseCba7W2eBLmnxUKWXbyMmSUDdm7YJVo+4NahROUk+TUqhpqLUr2yFrOW34Ww5fbNFT/9DtxO3FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739293485; c=relaxed/simple;
	bh=V86bMiSkAru+Bbu+zuXNPDX5giXllsmqtLGcFA6lukM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TWYLevHBOyT6b57lZsCK8DB2z6fzRB7BLblNwLo7C6ju/a8+Lku1zhnk2cC62Y+gmI9fT0orTmOY31gkQZC/TL+/piOEShesW3Fm5JVh1EFAb7grx4jsQ2V3QyTP4ZkhIsEyaAfbjWKg1o9XNZGzcjj+hym/SoanNfa1C9sauaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kfGr+D8u; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4718e224eb1so194981cf.1
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 09:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739293483; x=1739898283; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=V86bMiSkAru+Bbu+zuXNPDX5giXllsmqtLGcFA6lukM=;
        b=kfGr+D8uCx5uvEd6gdl3iYX1xYhLarcbr7pOhNkqdQyrpOS6be8b5Ana8zgOgpZ/dY
         IrSO5249djZ/4VwlUd5ItouzbpwMNonZrgEl+SVzRAi/zEJs6RTvMg6DczGlLcDylI4R
         vMyuFAcB4u98meQiUlAnX6BhLByKEKpDhcZNIKmSxfQna5qfMbaRAxPtOacWvhC0pPIQ
         z4bpfHC/Dx0y3uu7jxNYMTn69pGTS2QS006VyKHjixaDskZB/woMQV6d0rq4FFLEMKys
         c8g8fAF3GC9CiOT/w5HiBUtJwgpQAm3EwexP5dMSVgPDhsKMqbON5jzSXhUEs7kYdNHV
         7xug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739293483; x=1739898283;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V86bMiSkAru+Bbu+zuXNPDX5giXllsmqtLGcFA6lukM=;
        b=b5i2VkjnqGSxXzIWbNGYoNgryqSdmJ6PWJjwOM7h2KUqFnRvHglwM69ufH2ujeziBN
         3PDgsyDZN36I1u6Loknhn5J0+ZIKJXuj7q40cx5RZBgRVl4xAO8q/mfBloAt0RtEr+PV
         cFadTEhNzrLAD3w7pEE3PyWkfPTAQN+0ppt4Fp7462tdZJSyYXz++2HOU7dSDaJpUBjF
         sBa83vz7psrSTrBywFUSQHsMYw+hNlRO9QBNt3mpRvwdDUUL8YP7EXfAnQcwhuIV9HGo
         tb8lHSoPGJy0TmXZ1EBv8YXomEcckaDLEUqllyCIyTvGFEeFbU/f9kmW6Y29YJWTdU3T
         JpOQ==
X-Gm-Message-State: AOJu0YyZb0BHFPejs8qe+K0dWfSYd6xI1N6n+PDi8g/esm+dhLBygWku
	ReYSOJDDMk5L53W/duBf3lbhmq8VZ0YPQvZiCu6eZyl39H6Fop2/jMmFxO35qoa+qBe0lKJPP5P
	BpTRORJgh3Wt46OvRcI+7qof6JE82zRCHfGys
X-Gm-Gg: ASbGnctEv5i+Ih6K1WkAtaXGvPVa24FOlw7BgeGlsqm5WdaT0sVj/zY6yLAxAeCkbzG
	8u1TK+uzK2CBiHCl/4EGoEB9n4vqN/F/Y2qLZ8PbLXTwJtIPnZ4MB2B3I2t8O8HFlutSm++E=
X-Google-Smtp-Source: AGHT+IF7aYlVm1xzV6KlQql8nz/pm5Skr2y21paH9VHEetpgDIV7e10kWCB78TfSzxQM03Xr6mTxoDQeyNg9K06ecLk=
X-Received: by 2002:a05:622a:142:b0:46e:131e:5ba6 with SMTP id
 d75a77b69052e-471a23c5623mr3996491cf.0.1739293482451; Tue, 11 Feb 2025
 09:04:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211121128.703390-1-tabba@google.com> <20250211121128.703390-9-tabba@google.com>
 <Z6tzfMW0TdwdAWxT@google.com> <CA+EHjTy3dmpLGL1kXiqZXh4uA4xOJDeTwffj7u6XyaH3jBU26w@mail.gmail.com>
 <Z6t6FSNwREpyMrG3@google.com> <CA+EHjTyU5K4Ro+gx1RcBcs2P2bjoVM24LO0AHSU+yjjQFCsw8Q@mail.gmail.com>
 <Z6uBd-L_npR_VqVY@google.com>
In-Reply-To: <Z6uBd-L_npR_VqVY@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 11 Feb 2025 17:04:05 +0000
X-Gm-Features: AWEUYZnXWmEcIQ4_KoI0fEL7v7bvD8iOJAejHMkavqWY58TJUX-76Md1mIBrLsQ
Message-ID: <CA+EHjTw1AboQg3Uzj5ptanxu6NPeonERpFZ+40RDUJkBFw2tqg@mail.gmail.com>
Subject: Re: [PATCH v3 08/11] KVM: arm64: Handle guest_memfd()-backed guest
 page faults
To: Quentin Perret <qperret@google.com>
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
	maz@kernel.org, will@kernel.org, keirf@google.com, roypat@amazon.co.uk, 
	shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, 
	jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Quentin,

On Tue, 11 Feb 2025 at 16:57, Quentin Perret <qperret@google.com> wrote:
>
> On Tuesday 11 Feb 2025 at 16:34:02 (+0000), Fuad Tabba wrote:
> > > Sorry, yes, that wasn't clear. I meant that kvm_mem_is_private() calls
> > > kvm_get_memory_attributes() which indexes kvm->mem_attr_array. The
> > > comment in struct kvm indicates that this xarray is protected by RCU for
> > > readers, so I was just checking if we were relying on
> > > kvm_handle_guest_abort() to take srcu_read_lock(&kvm->srcu) for us, or
> > > if there was something else more subtle here.
> >
> > I was kind of afraid that people would be confused by this, and I
> > commented on it in the commit message of the earlier patch:
> > https://lore.kernel.org/all/20250211121128.703390-6-tabba@google.com/
> >
> > > Note that the word "private" in the name of the function
> > > kvm_mem_is_private() doesn't necessarily indicate that the memory
> > > isn't shared, but is due to the history and evolution of
> > > guest_memfd and the various names it has received. In effect,
> > > this function is used to multiplex between the path of a normal
> > > page fault and the path of a guest_memfd backed page fault.
> >
> > kvm_mem_is_private() is property of the memslot itself. No xarrays
> > harmed in the process :)
>
> Ah, I see, but could someone enable CONFIG_GENERIC_PRIVATE_MEM and
> related and get confused? Should KVM_GENERIC_MEMORY_ATTRIBUTES=n
> depend on !ARM64? Or is it KVM_GMEM_SHARED_MEM that needs to depend on
> the generic implementation being off?

VMs that have sharing in place don't need
KVM_GENERIC_MEMORY_ATTRIBUTES, since that presents the userspace
view/desire of the state of the folio. It's not necessarily an arm64
thing, for example, CCA would need it, since it behaves like TDX.

I guess that KVM_GMEM_SHARED_MEM and KVM_GENERIC_MEMORY_ATTRIBUTES are
mutually exclusive. I cannot think how the two could be used or useful
together. We could have a check to ensure that both are not enabled at
the same time. The behavior in this patch series is that
KVM_GMEM_SHARED_MEM selects GENERIC_PRIVATE_MEM.

Also, to help reduce the confusion above, I could rename the variable
is_private in user_mem_abort() to is_guestmem. WDYT?

Cheers,
/fuad


> Thanks,
> Quentin

