Return-Path: <kvm+bounces-23650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 079B394C512
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 21:05:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7F92AB23B5E
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 19:05:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 800431552E7;
	Thu,  8 Aug 2024 19:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XRAqXoow"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41533146A9B
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 19:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723143914; cv=none; b=RE3yDNAv9LgKKN5Bj8QjJRQlfyn5sTKL6Q22eXadTpXF7EB+lfA9HRosFwPA7BSPO1UB6vSdMAQX/Y8VZWPKguvTTOrlb1xB/NiMeT/4d7F+mnUrt5bABXin7iYA7a5Nhvga0TYaD5JYLnD77p6wruihSqyslceeQ3WCR0YtJAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723143914; c=relaxed/simple;
	bh=2JvB8KiY+PuqAF0GhkTY8OddkOOK+xHWu3DUoPWQw7k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=klwSkX8OG2nH/ko/qExBXnqhzEIYywi/rYK4k1E9O8eU+w2JaHWlV5QZ1WXCPyTKIGQSc4DPH8dzzlnuNTdcUW8YJBfuQPax3Ge995c6ln3aykLmVBPSatKAVn/xgiCeEj6RXJDEi3m/r3zwQpkH5FyPeP8DJwARYJYuwGdjGXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XRAqXoow; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4518d9fa2f4so26251cf.0
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 12:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723143912; x=1723748712; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2JvB8KiY+PuqAF0GhkTY8OddkOOK+xHWu3DUoPWQw7k=;
        b=XRAqXoowBsE2LCCY5DWtw8eJ/mutgjZhFUUnePPPTKrMlAP1iY2mRGBhryxbjnVZsj
         fAjqpjOdGg8P+8k0QjNPyh6SQxcJWguzjFvQxaRm95Q5gbjdn4WxjPmZI1Pov7tupJIF
         VGkTg17xNlY8PRfjkRqjxY/5WpFOZzHMJlr0W0LBBxLQHPFzDfxJb2QJ04+c7hgqveyT
         Ni2AU71nX57tnjta77RPXYqs7UV9SpxbhoQfhkzEJIxLEi+P+N8e8soqZdccEE+GaSu1
         e5+UXb09sXKmaI7eNzMXkdLJc02izd5rb+zXalz5BK7mdK3qBlj7e2Z+FaPU7zSZ0jsv
         aLPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723143912; x=1723748712;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2JvB8KiY+PuqAF0GhkTY8OddkOOK+xHWu3DUoPWQw7k=;
        b=smm1/FIGG7fMmCNBlh1GKYkF5fwBg52JtpszSKXqCTiJCz/bh4LdZadgPhR6sujZwi
         9s6eEODZvl07CsBJpWmelK3yxg1uZE5Btw9ODXhEpTfjrrGL1iZGX2EllsZxHnkpUWuS
         KS/zHLL0W7WTGZF51z+h4KCOwqLkgH5nEJMq21dBARCvhTM4a+aA8jChhNd5rGQodbx1
         4O6peySuFazaF4o+qf1kEunFmDjVIulq3qcwAI8h7PF44l7mmItHO5fIpGAvKx7Nirrh
         nMjNbwh7HLsWz13ZOgo3VE5DSAQ75dW5t0eVbQWvRZYqYaLGwW3VXWJsG4lctWc1Wf0e
         RR2A==
X-Forwarded-Encrypted: i=1; AJvYcCXnI2lRz7JPaXq7I1FsUDWv3HapzLKCwCw8TmpTTJehd8cn14jHv+b1oh/0+1pT30LsLGLnkbPLjJBnM6aV8ADU77ge
X-Gm-Message-State: AOJu0YzwmujaInUsGuCibSBmVFutPc3S2vaIqoysbcejdSV9o27UZmq+
	QQue11ssmPo00SmXklp1KzMlSfXh1v52noq5gCb/e+ZjFkltXakTWtB/MoFS0zXiASmvnQoD8YX
	Z3mNJKol5qNSyYtLGRQ6kzcXVgykgpf0BOFDL
X-Google-Smtp-Source: AGHT+IFIlgJQdU3HoiHXPbkIB4GKly6SE8zVkLmKYy0KXL7tnF5o/COzyvy6qpBzkurJ0OWbYZqnlwn3gVNXK6B4bgA=
X-Received: by 2002:a05:622a:1786:b0:44b:74aa:1838 with SMTP id
 d75a77b69052e-4530de641aamr415531cf.5.1723143911952; Thu, 08 Aug 2024
 12:05:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240801224349.25325-1-seanjc@google.com> <CADrL8HXVNcbcuu9qF3wtkccpW6_QEnXQ1ViWEceeS9QGdQUTiw@mail.gmail.com>
 <DS0PR11MB63733F7AEC9B2E80A52C33D4DCB92@DS0PR11MB6373.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB63733F7AEC9B2E80A52C33D4DCB92@DS0PR11MB6373.namprd11.prod.outlook.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 8 Aug 2024 12:04:35 -0700
Message-ID: <CADrL8HWH3d2r12xWv+fYM5mfUnnavLBhHDhof0MwGKeroJHWHA@mail.gmail.com>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2024.08.07 - KVM userfault
 (guest_memfd/HugeTLB postcopy)
To: "Wang, Wei W" <wei.w.wang@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Peter Xu <peterx@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, David Matlack <dmatlack@google.com>, 
	Anish Moorthy <amoorthy@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 8, 2024 at 5:15=E2=80=AFAM Wang, Wei W <wei.w.wang@intel.com> w=
rote:
>
> On Thursday, August 8, 2024 1:22 AM, James Houghton wrote:
> > 1. For guest_memfd, stage 2 mapping installation will never go through =
GUP /
> > virtual addresses to do the GFN --> PFN translation, including when it =
supports
> > non-private memory.
> > 2. Something like KVM Userfault is indeed necessary to handle post-copy=
 for
> > guest_memfd VMs, especially when guest_memfd supports non-private
> > memory.
> > 3. We should not hook into the overall GFN --> HVA translation, we shou=
ld
> > only be hooking the GFN --> PFN translation steps to figure out how to =
create
> > stage 2 mappings. That is, KVM's own accesses to guest memory should ju=
st go
> > through mm/userfaultfd.
>
> Sorry.. still a bit confused about this one: will gmem finally support GU=
P and VMA?
> For 1. above, seems no, but for 3. here, KVM's own accesses to gmem will =
go
> through userfaultfd via GUP?
> Also, how would vhost's access to gmem get faulted to userspace?

Hi Wei,

From what we discussed in the meeting, guest_memfd will be mappable
into userspace (so VMAs can be created for it), and so GUP will be
able to work on it. However, KVM will *not* use GUP for doing gfn ->
pfn translations for installing stage 2 mappings. (For guest-private
memory, GUP cannot be used, but the claim is that GUP will never be
used, no matter if it's guest-private or guest-shared.)

KVM's own accesses to guest memory (i.e., places where it does
copy_to/from_user) will go through GUP. By default, that's just how it
would work. What I'm saying is that we aren't going to add anything
extra to have "KVM Userfault" prevent KVM from doing a
copy_to/from_user (like how I had it in the RFC, where KVM Userfault
can block the translation of gfn -> hva).

vhost's accesses to guest memory will be the same as KVM's: it will go
through copy_to/from_user.

Hopefully that's a little clearer. :)

