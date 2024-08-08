Return-Path: <kvm+bounces-23591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B53AC94B411
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 02:17:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 46BD61F23B30
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 00:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C8E933EC;
	Thu,  8 Aug 2024 00:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RWLcg4lK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216AC184E
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 00:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723076269; cv=none; b=cR5UJ6xdckGTYVxdD3C0QZzDxN2E9gqpfitwgYTbokjwDGG8DxYYTKvzqkPrvk2qViWwv/ZnXbuRK+W9htVH0REp51AUjZtZWx5wSvEGJYYv4kOAiYVhbdU2wIqaoACu+b1qr4Y5Cku8lp1xQKknJ0QwuxqZ9Ns+5l0ZW8SpSIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723076269; c=relaxed/simple;
	bh=gwourquQqQgArHZuQMizcUTmxF5q+y+29ipyy+zP9eQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qT/FNew6cl/i/mxjNMD/rpNfBb0QpGLXUlDq2mtV/Zka1L75esfjGIT5TCzxfJzmxaC8DT8orzZ0dg+6B/jhSQjZFUcOZDhS1G1tUOZeKFSlYWHEbHP/OBPdhkQgr6BR5vq2e80K8y1I2ZVinLnl7Ec2FztcbcKsSTsKnKVg1jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RWLcg4lK; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e035f7b5976so1087512276.0
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2024 17:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723076267; x=1723681067; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r/kJVEFH5qjayplD5GVSM8FS6nnkv+gRXSy0GjQP8O0=;
        b=RWLcg4lKiZLnYLOu2aaa3R8qvcCd2YS0/Zk0xseWhG5jfMbG/nPIFQLwvd8kqy+col
         UV7HJtjS6q9UnuE/Pd7sxL5dDQSjetrakKmVYUZrbmesO9hReR81pCLzO4cEGKQsgLdU
         4Tghsd2DWgq/kTevIPe09mDVmXIGVwBQnsiEYe2lqWboGgWRVElXjYopD3aSyDeA8+YN
         O/erW2jdaWQsXsKxD/ncDZQYe2qQm8vCzqr3rmnilusEjJBA1uzPAn/K9Lb6lGx0fWMd
         +7XPldOKhrdmdJHcGZFmC2EzoIJ4kYO3mvNfeH3iUWunciA26pJuxV1vxYkkYpyJR2dC
         c0jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723076267; x=1723681067;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=r/kJVEFH5qjayplD5GVSM8FS6nnkv+gRXSy0GjQP8O0=;
        b=my8P6JQq6oeQDXGVvP9fOYM8sWYEWcVY1PDnFaubbiyOnvL9kDOJTO6slW+wchCv4G
         mmxl9WTrUA/S+SUljS4llhIahrfvO02CaeHkeMmOQoT284YcCeTO261y/uLTdcIod22E
         Z2R2owlP/+M1fwSQqascBcD7oVaTwpBIvFZjfRqsopLPSqucBWnAn5Dh7HJvBQiDsH7p
         7+0re0IBE6sXszL8gE0a8X0lR8UBMsZ0Samx7jps6tbolSrTUIiOl9+STqy6brdOyOMW
         IZvpepACQlqPv1+oj27PTwYD1m7BN36kzEM9CDNOjRJayD0y8MOat5o5djXYn0HjV0at
         PzEg==
X-Gm-Message-State: AOJu0Yx3ZK03l08JPHxbvggyDZOgiNz/tJ0h9MH8Gr9a4O8LAY6wk96t
	85kRfkfTGWhkYErupcJlPJCT318pBR2AnOqUz9qlSQbUKZepvyRzEs1iHr5kfh/LmNmNLY0f5cr
	D/A==
X-Google-Smtp-Source: AGHT+IGd41vgvUvW9KjGrejv+hMEBy5r1ZRLxG0BRevHpPhbssnp8x8WU7uASiTBL/HsemDLzKvEtYI71OM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:98a:0:b0:e03:52c8:ad30 with SMTP id
 3f1490d57ef6-e0e9f93ec17mr161276.3.1723076266966; Wed, 07 Aug 2024 17:17:46
 -0700 (PDT)
Date: Wed, 7 Aug 2024 17:17:45 -0700
In-Reply-To: <CADrL8HXVNcbcuu9qF3wtkccpW6_QEnXQ1ViWEceeS9QGdQUTiw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801224349.25325-1-seanjc@google.com> <CADrL8HXVNcbcuu9qF3wtkccpW6_QEnXQ1ViWEceeS9QGdQUTiw@mail.gmail.com>
Message-ID: <ZrQOqVsyEulBt7S9@google.com>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2024.08.07 - KVM userfault
 (guest_memfd/HugeTLB postcopy)
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, Anish Moorthy <amoorthy@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 07, 2024, James Houghton wrote:
> On Thu, Aug 1, 2024 at 3:44=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > Early warning for next week's PUCK since there's actually a topic this =
time.
> > James is going to lead a discussion on KVM userfault[*](name subject to=
 change).
>=20
> Thanks for attending, everyone!
>=20
> We seemed to arrive at the following conclusions:
>=20
> 1. For guest_memfd, stage 2 mapping installation will never go through
> GUP / virtual addresses to do the GFN --> PFN translation, including
> when it supports non-private memory.
> 2. Something like KVM Userfault is indeed necessary to handle
> post-copy for guest_memfd VMs, especially when guest_memfd supports
> non-private memory.
> 3. We should not hook into the overall GFN --> HVA translation, we
> should only be hooking the GFN --> PFN translation steps to figure out
> how to create stage 2 mappings. That is, KVM's own accesses to guest
> memory should just go through mm/userfaultfd.
> 4. We don't need the concept of "async userfaults" (making KVM block
> when attempting to access userfault memory) in KVM Userfault.
>=20
> So I need to think more about what exactly the API should look like
> for controlling if a page should exit to userspace before KVM is
> allowed to map it into stage 2 and if this should apply to all of
> guest memory or only guest_memfd.
>=20
> It sounds like it may most likely be something like a per-VM bitmap
> that describes which pages are allowed to be mapped into stage 2,
> applying to all memory, not just guest_memfd memory. Even though it is
> solving a problem for guest_memfd specifically, it is slightly cleaner
> to have it apply to all memory.
>=20
> If this per-VM bitmap applies to all memory, then we don't need to
> wait for guest_memfd to support non-private memory before working on a
> full implementation. But if not, perhaps it makes sense to wait.

Per-memslot likely makes more sense.  Unlike attributes, the bitmap only ne=
eds
to exist during post-copy, and unless we do something clever, i.e. use some=
thing
other than a bitmap, the bitmap needs to be fully allocated, which would re=
sult
in unnecessary overhead if there are gaps in guest physical memory.

The other hiccup with a per-VM bitmap is that it would force us to define A=
BI
for things we don't care about.  E.g. what happens if the local APIC is in-=
kernel
and userspace marks the APIC page as USERFAULT?  Ditto for gfns without mem=
slots.

E.g. add a KVM_MEM_USERFAULT flag along with a userfault_bitmap user pointe=
r
that is valid when the flag is set.  Unlike dirty logging, KVM is only a re=
ader
of the bitmap, so I'm pretty sure we don't need a copy in KVM.

When userspace creates the VM on the target, it allocates a bitmap for each
memslot and sets KVM_MEM_USERFAULT.  When migration completes, userspace cl=
ears
KVM_MEM_USERFAULT for each memslot, and then deletes the associated bitmap.

