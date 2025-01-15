Return-Path: <kvm+bounces-35582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFB54A1296E
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 18:10:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 100A27A1776
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 17:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32AC519C569;
	Wed, 15 Jan 2025 17:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WmKGPsdz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AAA12B169
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 17:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736961025; cv=none; b=gVfI1/8iCVtUxwCVQl56Rw8R6ZD5pARKumwM2gugHv5zP7fs+whHmLz7SHN0ST+YSAB3Tb93RxFpGRtVZFV2JXjRSxua3zouKb0uQo8kkH9ec6OfhxfwVElaTAAEM/qXZ35OcGrxgOCNp+FwwAzMNbGXVGyr6Et56P7FfpW64Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736961025; c=relaxed/simple;
	bh=2vS3PF6XGvpxxXNvaNgMGsRjoFsm6mpEMO0yBQkdnMc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UIWYCeO5i/mEA7MO/xrdPONnKfcJIGDY5ZRRBRtDgSTlLs1bVuA9aUiTfMJkYRvDARb9FoYjZlb7ORYcnsaogzSq3X76B3Ye7AAk51bUebdraqGFT+fmIlU+1WIJb8EWVXWp0VCzMXLNWjXJ/qLQ4MNQA4QxsJGaCWGj3qOOQR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WmKGPsdz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736961022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2cmY9g5YtkxQ9m40qGDjrwRL16DkbBlHxENEU3jrsKo=;
	b=WmKGPsdzENNHbbbNJwil6Pk9pEpIif3zx336stTZt6sWYQpso3vJ1znOclRhnvX58FZ4HY
	tmOvshEnLWVzVJuqWcHRpYzjoOwtf++IFNqOdlc/TpOQLZFdeUwaQQT2XfpQnqKkrlUzTn
	wkn5XDTeDzL1mqewzSmmOgn794hsUvc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-idg0MrjhPAGIldjVGaWsjQ-1; Wed, 15 Jan 2025 12:10:21 -0500
X-MC-Unique: idg0MrjhPAGIldjVGaWsjQ-1
X-Mimecast-MFC-AGG-ID: idg0MrjhPAGIldjVGaWsjQ
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-385e03f54d0so21765f8f.3
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 09:10:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736961020; x=1737565820;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2cmY9g5YtkxQ9m40qGDjrwRL16DkbBlHxENEU3jrsKo=;
        b=vGu7R46syOQh/vqNflP3Y5HOap3NkkfvEPYzzjZaJcd3WZzM2/JilsQItWD8NUAniB
         DeJDQdM6tb4myIkBdC6oo8XSvqGOxzh5H76BZl+Z2yh6GGn0p0TaMqNyrwQa6HB1MIAE
         28QjI9ih+vVLvH5BbYq2btAkfYX2F9iCrga8jy9JPr1R4t71BNCmVJ8X/wXsTdUwDo7x
         O5ECxObn2sX2vH0Ei8sBBbH2mh85GN/yLPh5LYaN/2EQUMM2DsX8oUcchJKruRVnPnew
         B4UptaWjngHIchJg8lO/gMUYR4ixH1bSXC31VswLS6vDadtSwiyuZM+sb9jEk1wkESHT
         uyXg==
X-Forwarded-Encrypted: i=1; AJvYcCX8HJLVLZ11qqImxLyE6Tbkw3ZGxHChxEF49KP3OYRWhZleaLc7OD/Rzy8cyqALq97rPXk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqWDJGHfhxfkjsx6hFeOoHxwFIgFi898IXvh8y170Ct95U3saX
	1JvOCP+SsIG8GfwEwi8yV/F1oT+0ey25orhU6x7DMeymYdD0jMoEUw3so0LYFVygFywhXJ7juen
	Qkm0j8/g3GMdemzmuBr8mYftVurymDpTXXngF023uys2Y6dGoZ1OUaIHDnuO+K6A8l0JzdFRbTz
	mlBEW1fOX32KQXqh8UC6/hrZHn
X-Gm-Gg: ASbGnctZXmVp1fnn8usKJpaxzuMwOYV9f0L1snP7UN2hhNq9AJ2WnwVs6njNbNYLaR1
	qu0KDQELpplWgr0cao4TqnaLX2uGY8iXDpNEBM1Q=
X-Received: by 2002:a05:6000:719:b0:385:e879:45cc with SMTP id ffacd0b85a97d-38a873045d9mr22788766f8f.19.1736961020045;
        Wed, 15 Jan 2025 09:10:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHVLkTNEWWZtRqu4vfnNpWCTgqlsiJ26Yxmq85P9YTVzLYGXq0iCv1YnX3bPAZkRawNlZBI01OgRqCL5Z56uy4=
X-Received: by 2002:a05:6000:719:b0:385:e879:45cc with SMTP id
 ffacd0b85a97d-38a873045d9mr22788744f8f.19.1736961019683; Wed, 15 Jan 2025
 09:10:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241108130737.126567-1-pbonzini@redhat.com> <Z2RYyagu3phDFIac@kbusch-mbp.dhcp.thefacebook.com>
 <fdb5aac8-a657-40ec-9e0b-5340bc144b7b@redhat.com> <Z2RhNcJbP67CRqaM@kbusch-mbp.dhcp.thefacebook.com>
 <CABgObfYUztpGfBep4ewQXUVJ2vqG_BLrn7c19srBoiXbV+O3+w@mail.gmail.com>
 <Z4Uy1beVh78KoBqN@kbusch-mbp> <0862979d-cb85-44a8-904b-7318a5be0460@redhat.com>
 <Z4cmLAu4kdb3cCKo@google.com> <Z4fnkL5-clssIKc-@kbusch-mbp>
In-Reply-To: <Z4fnkL5-clssIKc-@kbusch-mbp>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 15 Jan 2025 18:10:05 +0100
X-Gm-Features: AbW1kvbOLvaxHPo6MZldvIkH3kONiF_lH6xON6iaI-QmrKNVX7x6j4WsBQhb1oE
Message-ID: <CABgObfZWdwsmfT-Y5pzcOKwhjkAdy99KB9OUiMCKDe7UPybkUQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
To: Keith Busch <kbusch@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	michael.christie@oracle.com, Tejun Heo <tj@kernel.org>, 
	Luca Boccassi <bluca@debian.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 15, 2025 at 5:51=E2=80=AFPM Keith Busch <kbusch@kernel.org> wro=
te:
>
> On Tue, Jan 14, 2025 at 07:06:20PM -0800, Sean Christopherson wrote:
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index 2401606db2604..422b6b06de4fe 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -7415,6 +7415,8 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
> > > >   {
> > > >           if (nx_hugepage_mitigation_hard_disabled)
> > > >                   return 0;
> > > > + if (kvm->arch.nx_huge_page_recovery_thread)
> > > > +         return 0;
> >
> > ...
> >
> > > >           kvm->arch.nx_huge_page_last =3D get_jiffies_64();
> > > >           kvm->arch.nx_huge_page_recovery_thread =3D vhost_task_cre=
ate(
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index c79a8cc57ba42..263363c46626b 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -11463,6 +11463,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcp=
u *vcpu)
> > > >           struct kvm_run *kvm_run =3D vcpu->run;
> > > >           int r;
> > > > + r =3D kvm_mmu_post_init_vm(vcpu->kvm);
> > > > + if (r)
> > > > +         return r;
> >
> > The only lock held at this point is vcpu->mutex, the obvious choices fo=
r guarding
> > the per-VM task creation are kvm->lock or kvm->mmu_lock, but we definit=
ely don't
> > want to blindly take either lock in KVM_RUN.
>
> Thanks for the feedback. Would this otherwise be okay if I use a
> different mechanism to ensure the vhost task creation happens only once
> per kvm instance? Or are you suggesting the task creation needs to be
> somewhere other than KVM_RUN?

You can implement something like pthread_once():

#define ONCE_NOT_STARTED 0
#define ONCE_RUNNING     1
#define ONCE_COMPLETED   2

struct once {
        atomic_t state;
        struct mutex lock;
}

static inline void __once_init(struct once *once,
    const char *name, struct lock_class_key *key)
{
        atomic_set(&once->state, ONCE_NOT_STARTED);
        __mutex_init(&once->lock, name, key);
}

#define once_init(once)                                               \
do {                                                                  \
        static struct lock_class_key __key;                           \
                                                                      \
       __once_init((once), #once, &__key);                            \
} while (0)

static inline void call_once(struct once *once, void (*cb)(struct once *))
{
        /* Pairs with atomic_set_release() below.  */
        if (atomic_read_acquire(&once->state) =3D=3D ONCE_COMPLETED)
                return;

        guard(mutex)(&once->lock);
        WARN_ON(atomic_read(&once->state) =3D=3D ONCE_RUNNING);
        if (atomic_read(&once->state) !=3D ONCE_NOT_STARTED)
                return;

        atomic_set(&once->state, ONCE_RUNNING);
        cb(once);
        atomic_set_release(&once->state, ONCE_COMPLETED);
}

Where to put it I don't know.  It doesn't belong in
include/linux/once.h.  I'm okay with arch/x86/kvm/call_once.h and just
pull it with #include "call_once.h".

Paolo


