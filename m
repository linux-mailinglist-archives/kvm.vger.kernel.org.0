Return-Path: <kvm+bounces-7744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 342EC845D3F
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 17:29:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DCEFB1F29A8A
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C0C37E112;
	Thu,  1 Feb 2024 16:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K8/UCzaN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B087E10D
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 16:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706804903; cv=none; b=Pka03YZEeQVG9T5hmoJscz7xm4IYc7G6YzeH5L3ZRPp/wxq6SH/qE2Y7L62MSNBm3JdIEu1QqxCziJsltT+4YxTW9TEl7S1bbv+Fwx0WmxSsasIrdkCW8tqvoT/PrO63U6qjs0OAEEY7PwZJD7Nas/NLsT3r7gko4eBqXP4O7VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706804903; c=relaxed/simple;
	bh=RQMfGk2sJ0rdt76vd4PcTcu/WBOV61LRsFVxlUgak2I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y+ZZLknrQVD2FTyioVo2NUxVebHcTYtj7Bd3f/VFl3ATiMlZdnscJEHguvehCJ5aSE+kpgxGTukfOljkMwNNzZptAp05BPYyUbpvNElYsQNivzSTv2/XKFmIdH1H3Qcawl8h+j1HAWhQSgDWYdYKupmw/Nbw1kKqSsl1kPXV1vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K8/UCzaN; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6bea4c8b9so1454772276.3
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 08:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706804900; x=1707409700; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bfEEknfYaN1apdI2sXi9cfWLVgQqiO/RJh7exSDt4iY=;
        b=K8/UCzaNKjyI0cQPkjmYfi7rGtsdGvYew4iCc8iuHvVB2JkL5vhdI7WFC4ei56+peO
         BfBeZ7+3vGO5cAL4QmCi6/X9fARX/i6Lq9oNF7T8UlhM0+pF46sfBFgJIDUrKFrIfGWe
         9C7HpBbOVWyavTAFkC2yRgEbgUyW9asR/Tfry9uAzMddWeP+IeQ+MeemxVZC/2FWx0Zo
         n8hrKwxP44EgcWBppqp1ROeC+hiQZXxw23c1b1pYovGEjGXx6Z7YnjsGmhMgail0lIkB
         88TUB6dzkXj9X9VXdZFoD5fQ4cjPLug16iDD5uJkIVXrqEFbwJsnZ645XDSSQJLOVno+
         EITQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706804900; x=1707409700;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bfEEknfYaN1apdI2sXi9cfWLVgQqiO/RJh7exSDt4iY=;
        b=AqhgOCnC4C5gHLcYg0gdVZFcZD2zfFA+fOSugHgR4Kcl6AZ0j16P9mjQ6aMgj1JzTx
         pDtBgyS5yV9eZy88aFtq/HKRPk1qD44xlgy1900V2mBQ7NWcOFOYYwP1DHHwoWHqNqxT
         ItBBNMszac4vDdEyssC/gvTXTLZITnk9RkDChPBcYGLSUHvbgXI2hDY6WsCq/wtcOdou
         6geAiTrnV1QWIkgFC72JMcXqZEkK/2hL3ePSqoU2PVq1b5XHapCXhU2u9wBg4nmAucNn
         cWeIoN7hElDRyofawINGaC5mBjEBNBgMfkc6ibvMeGdszcLVREH8o70zv1h0cXXMzWTw
         /deg==
X-Gm-Message-State: AOJu0YzrPABNMC5k4fNYIQpua3zbd52LFpneMsyZjZgo6toWiKGomGwq
	V9AwWbburKalzC38wGApyl00n0WVPhVgc5dd/zIPQK1gm3RLuvAjhJ8/LahT5EMONN0qYAmMuiB
	RZw==
X-Google-Smtp-Source: AGHT+IEM/kpoxGnS59af2IFUsnl8Hae3asOrNvlRUbSTpkZgi2SS0WuDgKjRP6lYwDZ8+IkSHWxZ1zIjAjs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2602:b0:dc2:3426:c9ee with SMTP id
 dw2-20020a056902260200b00dc23426c9eemr184460ybb.11.1706804900620; Thu, 01 Feb
 2024 08:28:20 -0800 (PST)
Date: Thu, 1 Feb 2024 08:28:19 -0800
In-Reply-To: <ZbrxiSNV7e1C6LO-@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-7-amoorthy@google.com>
 <CADrL8HWYKSiDZ_ahGbMXjup=r75B4JqC3LvT8A-qPVenV+MOiw@mail.gmail.com>
 <CAF7b7mrA3rB33sUZe3HX33+fXpF=8VwD284LpCcEn9KT9OgwUQ@mail.gmail.com>
 <CADrL8HXSzm_C9UwUb8-H_c6-TRgpkKLE+qeXfyN-X_rHGj2vuw@mail.gmail.com> <ZbrxiSNV7e1C6LO-@linux.dev>
Message-ID: <ZbvGoz67L3gtnHhI@google.com>
Subject: Re: [PATCH v6 06/14] KVM: Add memslot flag to let userspace force an
 exit on missing hva mappings
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: James Houghton <jthoughton@google.com>, Anish Moorthy <amoorthy@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 01, 2024, Oliver Upton wrote:
> On Wed, Jan 31, 2024 at 04:26:08PM -0800, James Houghton wrote:
> > On Wed, Jan 31, 2024 at 2:00=E2=80=AFPM Anish Moorthy <amoorthy@google.=
com> wrote:
>=20
> [...]
>=20
> > On that note, I think we need to drop the patch that causes
> > read-faults in RO memslots to go through fast GUP. KVM didn't do that
> > for a good reason[1].
> >=20
> > That would break KVM_EXIT_ON_MISSING for RO memslots, so I think that
> > the right way to implement KVM_EXIT_ON_MISSING is to have
> > hva_to_pfn_slow pass FOLL_NOFAULT, at least for the RO memslot case.
> > We still get the win we're looking for: don't grab the userfaultfd
> > locks.
>=20
> Is there even a legitimate use case that warrants optimizing faults on
> RO memslots? My expectation is that the VMM uses these to back things
> like guest ROM, or at least that's what QEMU does. In that case I'd
> expect faults to be exceedingly rare, and if the VMM actually cared it
> could just pre-populate the primary mapping.
>=20
> I understand why we would want to support KVM_EXIT_ON_MISSING for the
> sake of completeness of the UAPI, but it'd be surprising if this
> mattered in the context of post-copy.

Yeah, I let's just make KVM_EXIT_ON_MISSING mutually exclusive with
KVM_MEM_READONLY.  KVM (oviously) honors the primary MMU protections, so us=
erspace
can (and does) map read-only memory into the guest without READONLY.  As Ol=
iver
pointed out, making the *memslot* RO is intended for use cases where usersp=
ace
wants writes to be treated like emulated MMIO.

We can always add support in the future in the extremely unlikely event som=
eone
comes along with a legitimate reason for KVM_EXIT_ON_MISSING to play nice w=
ith
KVM_MEM_READONLY.

