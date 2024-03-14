Return-Path: <kvm+bounces-11797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DF3E87BF3B
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 15:45:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 14724B24838
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 14:45:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A64EF70CC1;
	Thu, 14 Mar 2024 14:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AJzgJGq+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4024D6E5E7
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 14:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710427546; cv=none; b=Y2aU50Rkb7hs3qvLBqRE9NwGhMszi5hG585lk2fgUUygmR6WjHqZWL7wTbRcL3tV4r4bCb+vqyO0bD8YDmb4thBtdYNDL6V1qbvYTu1sqdoJVNRl2WdagElt5Jm/QJbc0TV//9mLZtXLR+/UJ8RgMujlhztyTznopPJYQdibTds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710427546; c=relaxed/simple;
	bh=BwYbNtMX4PnyM344LqBkdMRm1pxVcNQYFxGRXHYxk3E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N7FVxzJzeFO68SVwCUV6V59wia1g5mXPwyh45KU6Co+e46tlym8BTbVoxMetdygVmCOTtxP/mdZ0Lp5paHu5IrzXLrN7aWVnF44PKO5WurgV6BKGu5y3I2/c6PL/wmheILDpdqQbCdb4U0cR9/ybt3ZnR+px1EhiPGeJfUUts3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AJzgJGq+; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-609fb151752so19952587b3.2
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 07:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710427544; x=1711032344; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N/k6WMtb7RwOB5cuqYeM7NcbURLzoglqZlXeN+xJ3W4=;
        b=AJzgJGq+sodS6b/dJnXcgoCtxeSWEaha+AEyIc8B8sI5XqJsqBIKlYLp5USkdTFXfc
         IG+en119/6KI3k3j3tapMgSdgPuAE/P0Zsk7deroiMxXO3agDirF5Lc7F2Z5DZ+ta3/3
         FeP9nze9VngBHH6314/AmzmJrTnAEtrm4WcjM9fjnPXawMw4z6YVCr7P+SmnUDS04YwT
         uJcIu7mUk9nYBnGCugDDx8C+ejnfLB6gyBflE097wm6OCTU4gSe0t2Z5RO0aKKZrCIG0
         yhfBRPDDSH8p81RJIUHV4cCyB3NTwv1ibjZJQXhO+bODvNNzJV5WLqYvo0fn+CMqK17D
         EYOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710427544; x=1711032344;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N/k6WMtb7RwOB5cuqYeM7NcbURLzoglqZlXeN+xJ3W4=;
        b=sRVmRoEpN9l+Ta7D4lvbA81UHoKq/aRVqnMKV8AXvmRU96LWnf3+D8naJQkrNR7X05
         5Pnu7lKENkxlsoeLEx0Q10al6z1fPalt2sZLrtu8HyP+jEdW3ayL55uXUhXB+Kmn331H
         J3jO5WK/bmRvgBR03jMGvoT9gXjC/erRFoz8618FHMEM2Pzt7uMApaQYctLWma79YKI2
         tjnE7reku7620zqRxR8zsTzIs38CzIEdPNG3IUC5lD8kmI7MG7Wq8lrZD3itk6CxaH7d
         G/+Fm59B1Va8TiRpUQoq8jPfD3KbtR8qalUJ3fN1T6UzcIGvxMB3FkAvl5mttUKsjw8+
         U5rA==
X-Forwarded-Encrypted: i=1; AJvYcCW0fleTvWgU94YfyoeWMLaSlllPgeO6wg6eM6tTuy51BJE05EsfUmgkh6x77sbZYhpNIWqR2b7jVnDJECOTw2rwUHjl
X-Gm-Message-State: AOJu0YzFHwwbNLWf2j4yt4MD0WtzxQDERpUHWDxURknmLz0cwLFVyF8b
	maXvzAQ3JjOY3WGIRJyBsDY6tMCFi35OR0Ty0iGbEKQHfce7I3YN+ZUeWsgHtJ0a6vptHM6s4F0
	Waw==
X-Google-Smtp-Source: AGHT+IHpdqj6RcMzNjIcmD1eQX996cq7nCJZKMO6Qyf7mySaaPKB0yPHDYQWu5bD5KeDwG8rKwGqMIGgd/A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2848:b0:dcf:b5b8:f825 with SMTP id
 ee8-20020a056902284800b00dcfb5b8f825mr550085ybb.0.1710427544358; Thu, 14 Mar
 2024 07:45:44 -0700 (PDT)
Date: Thu, 14 Mar 2024 07:45:42 -0700
In-Reply-To: <985fd7f8-f8dd-4ce4-aa07-7e47728e3ebd@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <0b109bc4-ee4c-4f13-996f-b89fbee09c0b@amd.com> <ZfG801lYHRxlhZGT@google.com>
 <9e604f99-5b63-44d7-8476-00859dae1dc4@amd.com> <ZfHKoxVMcBAMqcSC@google.com>
 <93df19f9-6dab-41fc-bbcd-b108e52ff50b@amd.com> <ZfHhqzKVZeOxXMnx@google.com>
 <c84fcf0a-f944-4908-b7f6-a1b66a66a6bc@amd.com> <d2a95b5c-4c93-47b1-bb5b-ef71370be287@amd.com>
 <CAD=HUj5k+N+zrv-Yybj6K3EvfYpfGNf-Ab+ov5Jv+Zopf-LJ+g@mail.gmail.com> <985fd7f8-f8dd-4ce4-aa07-7e47728e3ebd@amd.com>
Message-ID: <ZfMNGMopN_Ncy0mf@google.com>
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

On Thu, Mar 14, 2024, Christian K=C3=B6nig wrote:
> Am 14.03.24 um 12:31 schrieb David Stevens:
> > On Thu, Mar 14, 2024 at 6:20=E2=80=AFPM Christian K=C3=B6nig <christian=
.koenig@amd.com> wrote:
> > > > > > > > Well as far as I can see Christoph rejects the complexity c=
oming with the
> > > > > > > > approach of sometimes grabbing the reference and sometimes =
not.
> > > > > > > Unless I've wildly misread multiple threads, that is not Chri=
stoph's objection.
> > > > > > >    From v9 (https://lore.kernel.org/all/ZRpiXsm7X6BFAU%2Fy@in=
fradead.org):
> > > > > > >=20
> > > > > > >      On Sun, Oct 1, 2023 at 11:25=E2=80=AFPM Christoph Hellwi=
g<hch@infradead.org>   wrote:
> > > > > > >      >
> > > > > > >      > On Fri, Sep 29, 2023 at 09:06:34AM -0700, Sean Christo=
pherson wrote:
> > > > > > >      > > KVM needs to be aware of non-refcounted struct page =
memory no matter what; see
> > > > > > >      > > CVE-2021-22543 and, commit f8be156be163 ("KVM: do no=
t allow mapping valid but
> > > > > > >      > > non-reference-counted pages").  I don't think it mak=
es any sense whatsoever to
> > > > > > >      > > remove that code and assume every driver in existenc=
e will do the right thing.
> > > > > > >      >
> > > > > > >      > Agreed.
> > > > > > >      >
> > > > > > >      > >
> > > > > > >      > > With the cleanups done, playing nice with non-refcou=
nted paged instead of outright
> > > > > > >      > > rejecting them is a wash in terms of lines of code, =
complexity, and ongoing
> > > > > > >      > > maintenance cost.
> > > > > > >      >
> > > > > > >      > I tend to strongly disagree with that, though.  We can=
't just let these
> > > > > > >      > non-refcounted pages spread everywhere and instead nee=
d to fix their
> > > > > > >      > usage.
> > > > > > And I can only repeat myself that I completely agree with Chris=
toph here.
> > > > > I am so confused.  If you agree with Christoph, why not fix the T=
TM allocations?
> > > > Because the TTM allocation isn't broken in any way.
> > > >=20
> > > > See in some configurations TTM even uses the DMA API for those
> > > > allocations and that is actually something Christoph coded.
> > > >=20
> > > > What Christoph is really pointing out is that absolutely nobody sho=
uld
> > > > put non-refcounted pages into a VMA, but again this isn't something
> > > > TTM does. What TTM does instead is to work with the PFN and puts th=
at
> > > > into a VMA.
> > > >=20
> > > > It's just that then KVM comes along and converts the PFN back into =
a
> > > > struct page again and that is essentially what causes all the
> > > > problems, including CVE-2021-22543.
> > Does Christoph's objection come from my poorly worded cover letter and
> > commit messages, then?
>=20
> Yes, that could certainly be.
>=20
> > Fundamentally, what this series is doing is
> > allowing pfns returned by follow_pte to be mapped into KVM's shadow
> > MMU without inadvertently translating them into struct pages.
>=20
> As far as I can tell that is really the right thing to do. Yes.

Christoph,

Can you please confirm that you don't object to KVM using follow_pte() to g=
et
PFNs which happen to have an associated struct page?  We've gone in enough =
circles...

