Return-Path: <kvm+bounces-14954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 803638A80F1
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 12:29:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20AFE1F21CB6
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 10:29:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F6A13BC2D;
	Wed, 17 Apr 2024 10:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XvtIceW5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B076113AD15
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 10:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713349733; cv=none; b=WRx8DG7xfbezNUWAvu+MyiSYDqGIVcHU5JE/vJFOax8uqbKDqthY6xtEaPTL+od7CpCAWA/mdYIyHy7FD/tf9eIu9N7wK9fpfqobBj3/PMQmSudOitdhSiczP7OAIaoLLYbV97XtSuIRiD2fPjrEL8hf+ikrmCKto6YFlhiJY5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713349733; c=relaxed/simple;
	bh=w9/j/Je+o73zYIJxkI4ihGGFo9ICotiVF5tQW2c+m+Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B2o6O4yd4qB05NeefrF1Zum/zCITpjZdDCwuTd+zDayhOQGxwnstvd/zI3tWriqgBphCa26Jj3BKwbb3lwW0lVYtUY/JBLhoyde2WPqoUdMCXutxcE8DckCueW6tRIRTWeA/t2OVh/VYtGLcU8lXl4sAHilrbGSiJxChCyU7GK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XvtIceW5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713349730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O85bb4GMOKWlSLPww3MfE2bfVcvNnZa2l+DfV3fmaMQ=;
	b=XvtIceW5MDN6miq6TFePW75qwYPdMhUILhK5MUGqFdFPH8irdijgHrEk6nLtEJC/Cz7vAS
	Vhgew8Pos10dYNy3X8e8Rd7jJvuSEv1ssQ+BBDWaI8h/Ahow8jPm3+Q1PiYoyFAPYC2PJA
	s/iNlPhUxfZ/EfhwKKRkDVhyOSmcVew=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-MRm8sxEEN0K6q3J2nPzvYg-1; Wed, 17 Apr 2024 06:28:49 -0400
X-MC-Unique: MRm8sxEEN0K6q3J2nPzvYg-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-518d2f112d2so2194733e87.1
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 03:28:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713349727; x=1713954527;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O85bb4GMOKWlSLPww3MfE2bfVcvNnZa2l+DfV3fmaMQ=;
        b=SsNyRprRrjBgqlFbHxEZOhr5MICOfMT8RF8zImjudR9wmfeGpD+dLgNG9NyMHiwmf2
         QXB/UEfeuEUL8KkxnIZhsie6sP1cB8foGHtbXYETj6m7mJWP6rUqJ74kcz0vipR57msl
         AS//60k4VIMcLgDLQU7xflTWO7Qjui655TLWsNMSGYjOihzCsDze9vis7+Xh6YrvKRky
         0Ul8VLlLwDi4RIg+TCsB1c7EFN5NJT//tltPvManXhLyrsraX4xM+09xKfjEt/OZ8b2r
         2prjubwHLyQS+xakB9NUXmGBTg8fm0q5jZFwUfXOLtouYzPdAad5/C9S+vFJn8yhH4iA
         6Z4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWmPWRjAque9K2dmgh479YK11PWJkiESWATXOb9+xW+uxOoJjNMmboEUj8U+CPnTZhbACh3HDj9aCR/h1vE6DAvtCOA
X-Gm-Message-State: AOJu0YwIu6BiJSDv2+4lYoCYng+PX7h/Qys0OLaxFjXLydM/HcH4t0ez
	0p7nGTmEbdJF7pgYU/Jqz0DBe8XBjkCJkNOTuN3j8Ero3IcoZ+BT4uKfYsXgwdC4yy7tfYvYqbE
	QEYkO3Y850mi/q6doBiTEigBWzJUdAQgFLvulQsr6vGoA8WkRAe6BWG1rfIeniFLx+PkrOLDkcI
	dAUJhhjlyBV1GEurXFVtyFiA6nD645Fy86
X-Received: by 2002:a05:6512:ad5:b0:515:ab7f:b13e with SMTP id n21-20020a0565120ad500b00515ab7fb13emr15605115lfu.33.1713349727160;
        Wed, 17 Apr 2024 03:28:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2PEEkflUhPutOPlvakp0mNMrz5x9jX77kM+J7Wf/TGaRQaWFZLDemYgspwVl/1Bu5SKeZowYgQMhGHAMyeu8=
X-Received: by 2002:a05:6512:ad5:b0:515:ab7f:b13e with SMTP id
 n21-20020a0565120ad500b00515ab7fb13emr15605089lfu.33.1713349726809; Wed, 17
 Apr 2024 03:28:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1712785629.git.isaku.yamahata@intel.com>
 <2f1de1b7b6512280fae4ac05e77ced80a585971b.1712785629.git.isaku.yamahata@intel.com>
 <116179545fafbf39ed01e1f0f5ac76e0467fc09a.camel@intel.com>
 <Zh2ZTt4tXXg0f0d9@google.com> <CABgObfZq9dzvq3tsPMM3D+Zn-c77QrVd2Z1gW5ZKfb5fPu_8WA@mail.gmail.com>
 <Zh8DHbb8FzoVErgX@google.com>
In-Reply-To: <Zh8DHbb8FzoVErgX@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 17 Apr 2024 12:28:34 +0200
Message-ID: <CABgObfbPXSFnupedTw56CXSOe74W_Z=dT+RJoPVebMtQ8HfojQ@mail.gmail.com>
Subject: Re: [PATCH v2 07/10] KVM: x86: Always populate L1 GPA for KVM_MAP_MEMORY
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>, 
	"federico.parola@polito.it" <federico.parola@polito.it>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2024 at 1:00=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> > > > Hmm... For the non-TDX use cases this is just an optimization, righ=
t? For TDX
> > > > there shouldn't be an issue. If so, maybe this last one is not so h=
orrible.
> >
> > It doesn't even have to be ABI that it gives an error. As you say,
> > this ioctl can just be advisory only for !confidential machines. Even
> > if it were implemented, the shadow MMU can drop roots at any moment
>
> Sure, but there's a difference between KVM _potentially_ dropping roots a=
nd
> guaranteed failure because userspace is trying to do something that's uns=
upported.
> But I think this is a non-issue, because it should really just be as simp=
le as:
>
>         if (!mmu->pre_map_memory)
>                 return -EOPNOTSUPP;
>
> Hmm, or probably this to avoid adding an MMU hook for a single MMU flavor=
:
>
>         if (!tdp_mmu_enabled || !mmu->root_role.direct)
>                 return -EOPNOTSUPP;
>
> > and/or kill the mapping via the shrinker.
>
> Ugh, we really need to kill that code.

Ok, so let's add a KVM_CHECK_EXTENSION so that people can check if
it's supported.

> > That said, I can't fully shake the feeling that this ioctl should be
> > an error for !TDX and that TDX_INIT_MEM_REGION wasn't that bad. The
> > implementation was ugly but the API was fine.
>
> Hmm, but IMO the implementation was ugly in no small part because of the =
contraints
> put on KVM by the API.  Mapping S-EPT *and* doing TDH.MEM.PAGE.ADD in the=
 same
> ioctl() forced KVM to operate on vcpu0, and necessitated shoving temporar=
y data
> into a per-VM structure in order to get the source contents into TDH.MEM.=
PAGE.ADD.

That's because it was trying to do two things with a single loop. It's
not needed - and in fact KVM_CAP_MEMORY_MAPPING forces userspace to do
it in two passes.

> And stating the obvious, TDX_INIT_MEM_REGION also doesn't allow pre-mappi=
ng memory,
> which is generally useful, and can be especially beneficial for confident=
ial VMs
> (and TDX in particular) due to the added cost of a page fault VM-Exit.
>
> I'm not dead set on this generic ioctl(), but unless it ends up being a t=
rain wreck
> for userspace, I think it will allow for cleaner and more reusable code i=
n KVM.

Yes, this ioctl() can stay. Forcing it before adding memory to TDX is
ugly, but it's not a blocker. I'll look at it closely and see how far
it is from being committable to kvm-coco-queue.

Paolo


