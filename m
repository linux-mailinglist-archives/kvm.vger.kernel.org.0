Return-Path: <kvm+bounces-15939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB4D28B25D8
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:00:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEB8E1C20D59
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BD2014C5B5;
	Thu, 25 Apr 2024 16:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XztRmQom"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E951494BF
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 16:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714060842; cv=none; b=ekESb9EoPNXRKW0ZoL+i/S47fd6q+1jZcZLLu4KgJNzyzNgc/Kc62SfAdTeazpp9bn3xToGb0gXrClo47zamswvrjJUtJc/BFRxqADdvStbknQLkIKOtFye6ERBFrMh9B+1fe0G2fzoq1MXIcCERWc2QKLneZo4NuHqVZAI6cho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714060842; c=relaxed/simple;
	bh=TyFNiOzpJkee86PpIaQDpYHskqlORooXQOsazACOFv0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SmS9zpdDC94bXyVAUJGG0AQ5Twq80vDuohXzq0QQyJ2LGiMANs3X47q3F8pMc82MtJGTvA01cg3xdKA2M1y2NT6N87r9PaRlCN2CpQwqwFrNcBnOJfT4k0eH0BzANxYXUJbi4N9TzLB0FMMx7Cf2jRbVjFk/loUVVLxm3Y7gsbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XztRmQom; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbf618042daso2232072276.0
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 09:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714060840; x=1714665640; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ba3XABiR5s6F7bFSfuNWf5cWBbIWDKx8aeb84AVeo1s=;
        b=XztRmQomdoFyW4Mb75MJyNXdo+WF7houoN0u7ZRS0JCjy94MjKD2Nt4tKub9tsRZV6
         gj9n/oqAJiCld+HASberzKF8+WI8Aa4IO4P3KSW+8JiuwhSarTp8c2XASTSa6tnqrgzR
         Sj4BSG4wn9Q+ePJaKrfpcFEwXjqTln/E4IKjshDMDmHRe21CTUhZcwvQVLG+F/fjSbN4
         Of1DDRt8VDeCOypR7lF45pgaYXW39drHm//SAX8pVhx/UHOLSMAzg3RH+Ar41TwzRmaI
         Dy+KX4J5XJuVW6ormaghOL/WuhfVJiFmBGPkL3AkV+p2pcI1AbCqQ20MWpMLPw1b2CLs
         8wRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714060840; x=1714665640;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ba3XABiR5s6F7bFSfuNWf5cWBbIWDKx8aeb84AVeo1s=;
        b=JC0LjuUi7CQALVrE96zOAtS6tHh1Mn2RYgXLAgWF321NX57FcOvDc8DF+W+wH0rVEw
         XxfURRCphuWTVBGBtIoBPxeEhCk5hehHYvcVCduh8+qaAkUW88RSWG5oUmLNcsYTBfpF
         kpD2vV3Xqq039ylQLs19MYBfqDvJI0zJV72L1Y8+0aZ2OOKnM6xMwcaZDBCISE8cE2Tv
         l2d79f3F8SIZJIEomz8jwr4s6gtWZf36rOlc+M1PqGCWG3nRyw+mFOPdt3Hl601tadpS
         45cjnwgXHyoxTPYcb1uno8DcCyQChRD87+m4Xw26eih4XlG1rshsU4/sKOoB5IRRcBUL
         IQkw==
X-Forwarded-Encrypted: i=1; AJvYcCU8LNEt5B3kQq0dLy5GIruyTKAPA32/pDeVIYTEZJvjdgtm4bnCNCjDe7F86apmRNIiqmcjdAWVGcf/GCYEuv9LTdrh
X-Gm-Message-State: AOJu0Yw/8h+tVjN7EpDUhQTZmeM9/8yd8aQXPkZJM8Q24zaurUk3e4k8
	Jdn+a/enfsS1xMSMRvIkgWGorU+OvMr/PpMSG/zm5Xs5e5pCYBEMF/GsPQDP8YZeVeaiOx9Ma08
	nyA==
X-Google-Smtp-Source: AGHT+IHqX/ZZ1I3GhIuDJZBMZ+jXBeWQwE/NV3sQPtCMJ0iOX9jIke2/rXn1sSESiypAZ8q8w7hJc1K4W7k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:188a:b0:de4:67d9:a2c6 with SMTP id
 cj10-20020a056902188a00b00de467d9a2c6mr1100ybb.2.1714060840104; Thu, 25 Apr
 2024 09:00:40 -0700 (PDT)
Date: Thu, 25 Apr 2024 09:00:38 -0700
In-Reply-To: <CABgObfY2TOb6cJnFkpxWjkAmbYSRGkXGx=+-241tRx=OG-yAZQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240404185034.3184582-1-pbonzini@redhat.com> <20240404185034.3184582-10-pbonzini@redhat.com>
 <20240423235013.GO3596705@ls.amr.corp.intel.com> <ZimGulY6qyxt6ylO@google.com>
 <20240425011248.GP3596705@ls.amr.corp.intel.com> <CABgObfY2TOb6cJnFkpxWjkAmbYSRGkXGx=+-241tRx=OG-yAZQ@mail.gmail.com>
Message-ID: <Zip-JsAB5TIRDJVl@google.com>
Subject: Re: [PATCH 09/11] KVM: guest_memfd: Add interface for populating gmem
 pages with user data
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, michael.roth@amd.com, isaku.yamahata@linux.intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024, Paolo Bonzini wrote:
> On Thu, Apr 25, 2024 at 3:12=E2=80=AFAM Isaku Yamahata <isaku.yamahata@in=
tel.com> wrote:
> > > >   get_user_pages_fast(source addr)
> > > >   read_lock(mmu_lock)
> > > >   kvm_tdp_mmu_get_walk_private_pfn(vcpu, gpa, &pfn);
> > > >   if the page table doesn't map gpa, error.
> > > >   TDH.MEM.PAGE.ADD()
> > > >   TDH.MR.EXTEND()
> > > >   read_unlock(mmu_lock)
> > > >   put_page()
> > >
> > > Hmm, KVM doesn't _need_ to use invalidate_lock to protect against gue=
st_memfd
> > > invalidation, but I also don't see why it would cause problems.
>=20
> The invalidate_lock is only needed to operate on the guest_memfd, but
> it's a rwsem so there are no risks of lock inversion.
>=20
> > > I.e. why not
> > > take mmu_lock() in TDX's post_populate() implementation?
> >
> > We can take the lock.  Because we have already populated the GFN of gue=
st_memfd,
> > we need to make kvm_gmem_populate() not pass FGP_CREAT_ONLY.  Otherwise=
 we'll
> > get -EEXIST.
>=20
> I don't understand why TDH.MEM.PAGE.ADD() cannot be called from the
> post-populate hook. Can the code for TDH.MEM.PAGE.ADD be shared
> between the memory initialization ioctl and the page fault hook in
> kvm_x86_ops?

Ah, because TDX is required to pre-fault the memory to establish the S-EPT =
walk,
and pre-faulting means guest_memfd()=20

Requiring that guest_memfd not have a page when initializing the guest imag=
e
seems wrong, i.e. I don't think we want FGP_CREAT_ONLY.  And not just becau=
se I
am a fan of pre-faulting, I think the semantics are bad.

E.g. IIUC, doing fallocate() to ensure memory is available would cause LAUN=
CH_UPDATE
to fail.  That's weird and has nothing to do with KVM_PRE_FAULT.

I don't understand why we want FGP_CREAT_ONLY semantics.  Who cares if ther=
e's a
page allocated?  KVM already checks that the page is unassigned in the RMP,=
 so
why does guest_memfd care whether or not the page was _just_ allocated?

AFAIK, unwinding on failure is completely uninteresting, and arguably undes=
irable,
because undoing LAUNCH_UPDATE or PAGE.ADD will affect the measurement, i.e.=
 there
is no scenario where deleting pages from guest_memfd would allow a restart/=
resume
of the build process to truly succeed.

