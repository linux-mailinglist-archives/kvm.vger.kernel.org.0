Return-Path: <kvm+bounces-11742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DCDB87A9BE
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 15:49:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 599E8281ED9
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 14:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E5B8446A2;
	Wed, 13 Mar 2024 14:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fiTcRvfX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409AC3D0DD
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 14:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710341335; cv=none; b=Cdg/AgBNHYXCOEEoG3fCjkdYnEdGi3qW3qnhLfp2n4eHklFWkHOYRpodq1wGuFOvytOSkVOTvQGF2qluInV+vzKGxC7IAIaBBXI6/MLjTE8HMm7QR0W+oS6HLuzI0vdU3QiAfhlIrH/ZVN998BGGnQYlG2ksc4CqLkzW1fu9VZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710341335; c=relaxed/simple;
	bh=wYEkrJjWGVx0jUWCjYrd/YRNNm9Cl5QCj3a74RDOIV4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HWLFWXBL0SFBkIqewPjdIQL7ZluYvucG+YpHImoDttGG8J97GHJREJWfNCwfqnsz2W45SOhW0eU07bUzs1LnvO3RIsBqKJcKAQDGE2xtbFVGXlY3eU2J1854vJUs4aW+0WnMam8ildfHSR/89rxBYiYqpIvuuvyUGqlaUwZJ4ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fiTcRvfX; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dd0ae66422fso2061701276.0
        for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 07:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710341333; x=1710946133; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yZFsDiSg8Veluka6E47FAf82LDK/U1v1gTIe6ZTkV+A=;
        b=fiTcRvfXD0T2fdrvNJoPF8f7tezf99bCT8HVRom32qbxhpubkE4z6+QWzVVkzHBo5b
         wEpVHwOw4AeU3vgio7YI8BjR1JpRE/S2kk6xsg/7dGIRKK4X9H+X/MKGFW83+s+z9l4j
         btjTj+iacauQI3mmZewJfVuIaPa68IMDlIFAHqbliSP5thKGiSPlQa6+xYfDTq5xc+Fi
         G8kvzNTvJD0rvV5Qy5+pItUlS2DZSqpNyjKc0DRCfIF7uNQxg+tQViuD7FI2OeBHtMg6
         rRkpFQbK+auso86TUp3XMowC2MMZzP3SZM2fc6oGsr8GLW/swWyXNbxjDagwdCpxnkfa
         V8Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710341333; x=1710946133;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yZFsDiSg8Veluka6E47FAf82LDK/U1v1gTIe6ZTkV+A=;
        b=JdsUBs+Yucp5JFsZnmia0OsLeBLqYLS4x7qIaO7LNwrLGU6SkihQ9MdSdHzsO4kwMd
         NsO9s6VqW2SHtjaq9lE8A9dN+pwqaO+Syh4YBZFLGFtmUr1A8cyrfrsuwGKJ39sCgNkK
         6VvO+AyY1itkmiMiUo4qlYZ9egoYg5WsozVZxSgM8mx12iQewkpUFqPRMGzIRIYF00fZ
         XKJHBVM5MOBXuGuJN7QKGwTSf5zsxp+zUCcv1HxDGKmUHczxcKIeFR6FhVmzgJJ7juA1
         3MCDq3sKfveUWN4wJRXWDjpOrgyt+ClmgyDKPd5cVZfVSFnh4L0YHlrrldoDpR2Dol0l
         vXxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXdxh6nCsD8Fjkre9gN4kISEVqk6NZOKD9TTRO4duYCPQRvUiUKiR+sZWO6ADjPGMfFz/RZ/3ca0qSjfqmqJ2z3USq
X-Gm-Message-State: AOJu0YzuxBlWk++TIyl0wlguKlWaBdeB6dyflo96edW9DfwF2xnqsP7a
	lcvxSHF434nARdCQ3Y/QtyQTKOUXjRz4ZdK9TA0V+cXFFKv4L5il88zvq1Aq5c1KXqMuJ+UcxZW
	9YQ==
X-Google-Smtp-Source: AGHT+IHgpPoNg9mBT3unR5ry0NDCq89tXvMg05S2JkM5aQGWQRzEQ3Jm9vXfbQ5VGa1cuXTitkvbJZ34Vco=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:388:0:b0:dcc:5463:49a8 with SMTP id
 k8-20020a5b0388000000b00dcc546349a8mr522047ybp.6.1710341333372; Wed, 13 Mar
 2024 07:48:53 -0700 (PDT)
Date: Wed, 13 Mar 2024 07:48:51 -0700
In-Reply-To: <0b109bc4-ee4c-4f13-996f-b89fbee09c0b@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240229025759.1187910-1-stevensd@google.com> <ZeCIX5Aw5s1L0YEh@infradead.org>
 <CAD=HUj7fT2CVXLfi5mty0rSzpG_jK9fhcKYGQnTf_H8Hg-541Q@mail.gmail.com>
 <72285e50-6ffc-4f24-b97b-8c381b1ddf8e@amd.com> <ZfGrS4QS_WhBWiDl@google.com> <0b109bc4-ee4c-4f13-996f-b89fbee09c0b@amd.com>
Message-ID: <ZfG801lYHRxlhZGT@google.com>
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: "Christian =?utf-8?B?S8O2bmln?=" <christian.koenig@amd.com>
Cc: David Stevens <stevensd@chromium.org>, Christoph Hellwig <hch@infradead.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 13, 2024, Christian K=C3=B6nig wrote:
> Am 13.03.24 um 14:34 schrieb Sean Christopherson:
> > On Wed, Mar 13, 2024, Christian K=C3=B6nig wrote:
> > > And when you have either of those two functionalities the requirement=
 to add
> > > a long term reference to the struct page goes away completely. So whe=
n this
> > > is done right you don't need to grab a reference in the first place.
> > The KVM issue that this series is solving isn't that KVM grabs a refere=
nce, it's
> > that KVM assumes that any non-reserved pfn that is backed by "struct pa=
ge" is
> > refcounted.
>=20
> Well why does it assumes that? When you have a MMU notifier that seems
> unnecessary.

Indeed, it's legacy code that we're trying to clean up.  It's the bulk of t=
his
series.

> > What Christoph is objecting to is that, in this series, KVM is explicit=
ly adding
> > support for mapping non-compound (huge)pages into KVM guests.  David is=
 arguing
> > that Christoph's objection to _KVM_ adding support is unfair, because t=
he real
> > problem is that the kernel already maps such pages into host userspace.=
  I.e. if
> > the userspace mapping ceases to exist, then there are no mappings for K=
VM to follow
> > and propagate to KVM's stage-2 page tables.
>=20
> And I have to agree with Christoph that this doesn't make much sense. KVM
> should *never* map (huge) pages from VMAs marked with VM_PFNMAP into KVM
> guests in the first place.
>=20
> What it should do instead is to mirror the PFN from the host page tables
> into the guest page tables.

That's exactly what this series does.  Christoph is objecting to KVM playin=
g nice
with non-compound hugepages, as he feels that such mappings should not exis=
t
*anywhere*.

I.e. Christoph is (implicitly) saying that instead of modifying KVM to play=
 nice,
we should instead fix the TTM allocations.  And David pointed out that that=
 was
tried and got NAK'd.

