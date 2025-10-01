Return-Path: <kvm+bounces-59336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57A21BB14E6
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 18:55:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07014177327
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 16:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 167252D1F7E;
	Wed,  1 Oct 2025 16:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D+Ixwi7j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06AC28153A
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 16:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759337740; cv=none; b=UwbvoI/9ku6UG/YTJ5vn6aql6Kf5ZqZMj9DV6tujRkDiEr1Vkx/j57uyRxkteIAkXH0IYk0dVtLDU7f+7VnBQgq8iQgpSkOwIvXYCW3Vz9+AYW3w3tcKZgwDxW/Dow8WhszZHmMUWHaAgWxEiH7/Z4V8rlq8gei2LMDe6d+a1UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759337740; c=relaxed/simple;
	bh=Nw4Avdnnjq56W3DhoQg3b0JPdrX5PkzeIu2m81xC9L8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ocmd6sdsBAHsumcN45JvYJz5zbKBuEEwdMzD3gEoZpgkqjRhsPAGPpUZ/A0sTjGKjaiq9K7NQ7NlKHcKXpGKNRzvEHxbnKDoVdtoA3B7WbTCWPSe2+uWkpw/j/PtI/pJgS+NLLdlpl62Kl18zB28LB+0R5Zf6yF7CuLoiGKA3YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D+Ixwi7j; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-27356178876so57098485ad.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 09:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759337738; x=1759942538; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UNyQbvzow/mhpmYas76FE2CqqCPGeJucQxrLl/NhhQI=;
        b=D+Ixwi7jcH/3rHMn04X0UhB/2l8eDnwKgn6rtSfq18dlttzon+chcFO00+9PCe7Ts5
         BQwCIPUdGY6tPZxiww3r335GVwB6nk79V9MiAfJEhrSj+d38OZE9Am1ksRBvncK9sxZ8
         024E5RI8WGS5FHrI9Z3WMkJ3En97KVh7UihyZTiQz0PbtK3dwNV4SiSteO2Siq2/cYPY
         2r6FmaAHSWr2g+PaYxHA5ylOMh0gUoEqi7v2E5lP51+SxmSIxchH1f9fzXM7IHA37Ig3
         /O1c6uxKvXs9JUKC/Bj1rM0uI/W8t7lxDIujR0adZ5uwTBGkdMPB2Kn3Rim4222/BvQi
         zkQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759337738; x=1759942538;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UNyQbvzow/mhpmYas76FE2CqqCPGeJucQxrLl/NhhQI=;
        b=qDzBuEJZ7NgILk0GhCGHpuj4bYFNBSRc4sxJEjTJnB3z4d/tUj87z+ijolsq62jMkJ
         8X4eYpWjKu9TmpzbuNYOTLH/MYA5b5TarvXCr+3xBeCIJVIk6mboVzDMfQOTdfz8VVf8
         y7O1w8OLxErPfSm+6CKQlKUCYBX/89+c4AJOAO6tyLMMdrBMWN6qTRCY1CXfjGNY+WrQ
         hRNrcBCm5r+xHg1sqKe7wSKQKv7QXDho33F/DtFT8Y9SLFWUSD1E4px87Riv6UXuJIzs
         iuNL7JERg97z6kNAyAoPzC70Umeu5cNCuDtu/K4EfiECAykZtCjaLGOFKJtBXRqaS+PR
         7diA==
X-Forwarded-Encrypted: i=1; AJvYcCU+gHMT79/lVIujqVjinOgZlhjgxkU1QJpGXNMx+k3H3QQ1s804rajGEB7QTR0IXcxE5zs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLiAkAlVAYzM9ANj7bWk6EM5JjS8ETSINbvyGfNLqEg/KBm4B4
	DLllDFA4QDdp8p37OOMRl1xG/5OieyV48Wyg2Wws4VMYtwofDXYmAib4KzL0xRtqq7Wnfjhshav
	RVYRJdA==
X-Google-Smtp-Source: AGHT+IFbleLiOllM8oSjGlHNtpxd2L2C0N5Mjl8Um+LgOUG3P+4Gw9bm6dL1Mb6vYImkIrK2MyoFExzw6SI=
X-Received: from plw21.prod.google.com ([2002:a17:903:45d5:b0:268:11e:8271])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db03:b0:279:fa:30fe
 with SMTP id d9443c01a7336-28e7f2b5302mr58620075ad.26.1759337738221; Wed, 01
 Oct 2025 09:55:38 -0700 (PDT)
Date: Wed, 1 Oct 2025 09:55:36 -0700
In-Reply-To: <CAGtprH9sU7bA=Cb11vdy=bELXEmx6JA9H5goJUjPzvgC2URxAg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com>
 <aNxqYMqtBKll-TgV@google.com> <CAGtprH9sU7bA=Cb11vdy=bELXEmx6JA9H5goJUjPzvgC2URxAg@mail.gmail.com>
Message-ID: <aN1dCAuOfy5RADR0@google.com>
Subject: Re: [RFC PATCH v2 02/51] KVM: guest_memfd: Introduce and use
 shareability to guard faulting
From: Sean Christopherson <seanjc@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>, 
	Fuad Tabba <tabba@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, David Hildenbrand <david@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 01, 2025, Vishal Annapurve wrote:
> On Tue, Sep 30, 2025 at 4:40=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > > +};
> > > +
> > > +enum shareability {
> > > +     SHAREABILITY_GUEST =3D 1, /* Only the guest can map (fault) fol=
ios in this range. */
> > > +     SHAREABILITY_ALL =3D 2,   /* Both guest and host can fault foli=
os in this range. */
> > > +};
> >
> > Rather than define new values and new KVM uAPI, I think we should inste=
ad simply
> > support KVM_SET_MEMORY_ATTRIBUTES.  We'll probably need a new CAP, as I=
'm not sure
> > supporting KVM_CHECK_EXTENSION+KVM_CAP_MEMORY_ATTRIBUTES on a gmem fd w=
ould be a
> > good idea (e.g. trying to do KVM_CAP_GUEST_MEMFD_FLAGS on a gmem fd doe=
sn't work
> > because the whole point is to get flags _before_ creating the gmem inst=
ance).  But
> > adding e.g. KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES is easy enough.
> >
> > But for specifying PRIVATE vs. SHARED, I don't see any reason to define=
 new uAPI.
> > I also don't want an entirely new set of terms in KVM to describe the s=
ame things.
> > PRIVATE and SHARED are far from perfect, but they're better than https:=
//xkcd.com/927.
> > And if we ever want to let userspace restrict RWX protections in gmem, =
we'll have
> > a ready-made way to do so.
> >
>=20
> I don't understand why we need to reuse KVM_SET_MEMORY_ATTRIBUTES. It
> anyways is a new ABI as it's on a guest_memfd FD instead of KVM FD.

Yes, it's new functionality, but the semantics are the same (modulo s/addre=
ss/offset),
which makes life easier for KVM and its developers.  Specifically I want to=
 avoid
ending up with two entirely different ways for describing private vs. share=
d memory.
E.g. I don't want to have to translate between SHAREABILITY_GUEST and PRIVA=
TE,
in code or in conversation.

> RWX protections seem to be pagetable configuration rather than
> guest_memfd properties. Can mmap flags + kvm userfaultfd help enforce
> RWX protections?

No, because mmap() is optional.  Potential use cases are for (seletively)
restricting _guest_ access as well as host access.  mmap() isn't a good fit
regardless, as that's much more about describing what the process wants, no=
t
the properties of the underlying memory.

E.g. read-only and noexec file systems exist for a reason.

