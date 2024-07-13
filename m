Return-Path: <kvm+bounces-21600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E6E59304E7
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 12:10:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38E1C281681
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 10:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD8E15A0FE;
	Sat, 13 Jul 2024 10:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cges/GOI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1066B1EB3D
	for <kvm@vger.kernel.org>; Sat, 13 Jul 2024 10:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720865448; cv=none; b=E5WliOzS+m6YiztnjK4I+1eu5Kpc3Yl3j6FfYn4YctGeiT6b4b3ywkWD4W8hFzzL+MLRuW5R+4SMPBg+qs15+svKm4HUe057NNIzGh71AZTfCD/zwGqS7DCprU2VDS9IU5A1BZbYfYUz40irj0YMiarKwy3rWHRHuVGGTiRPFoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720865448; c=relaxed/simple;
	bh=qZCU07LwG1y/QxqvDN+bbU9f40dznEGTgZbhCkej5+c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EAdhg7McrVlvMgEKRjMsB5XRnG7XIn/rV87leUV+2gYYKsHFZRNnRud1lWZokVz60l5mlToV0sY77fN8xfSOig+iQLAAqdQnA/uNyYYaJE1KHbKYumRBDOR4iuIidpKjNBlTmIjaZZFxTDIItjjyqEhu+5e3yCF6GdLWd/jGCjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cges/GOI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720865444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZPOxRQTAuOacVTi+37gbzjSwTfPPQBNHpeu0Esbbzm0=;
	b=Cges/GOIjAH24lOVytuFI7rbasfKSdjGXAkt6szGRHY4AVmmvdjZPElvwthxYRm9OQk6dV
	g8UMOU2H/AVAnWHKpjIrRBkdDeYJOnHUAfOMUQchtjXU0oHk1EOXP4yeZrP2RHYFvPg6iC
	fMVF4d/6jVSfSN/gYh4zsB6qGKqZKvs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-3UTGFODkOECILDTkvcVtYQ-1; Sat, 13 Jul 2024 06:10:43 -0400
X-MC-Unique: 3UTGFODkOECILDTkvcVtYQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42725ef39e2so20962435e9.0
        for <kvm@vger.kernel.org>; Sat, 13 Jul 2024 03:10:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720865442; x=1721470242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZPOxRQTAuOacVTi+37gbzjSwTfPPQBNHpeu0Esbbzm0=;
        b=nK/h4fXgYkXIuPgTAryPdNUPNuv6Zl7lFO9zS+Lzwt0NR7qjpvGAGEPoUeUppRqFEV
         9IA2xsOtVD21X0grG8+yYIKuc0eVunJ8IZZmezVB+6umlP5frevYbrUCILynzYlCJcWc
         DPoGOxpzRRUfyiG1NAkG5X0UcjUFlLDkpr4bktI7CaIS/Qbm1/RyU+X59Zu67lXOq35r
         NS4uUHDr6vgY61TrHDlC8enZTMQzjwzGsOKjUUSnB7tSW4UzgZX1AoPF/JHgm0W5IXUB
         mLT/c9CQg+RHVDxzZHyd0hs8mXDeUUD3eYfCWmagY/6fhmKNBz5JaAHCi9Zb130VOT0M
         tfdQ==
X-Gm-Message-State: AOJu0YwLpgBEsnQ4SfTNWwm1NCmIZHhFnYE+Ho3FnXzNRm8lIRhHMXx1
	52b47sWVfH51pY/0uHirf+YDMTo5DrZRdEnbbA51gfmokS/Hdn5UmuAacI4vz7U6vT8ooP+wmlV
	CEjEtvmzItuWvo9tFsTi9Qw+hJMGJOy5EBLweQO7rCWExtAccQKlw6Z2YHZKX7BpXUyuoYm86WV
	56y6t7u945RoXbTkMFpIglaLWb
X-Received: by 2002:a05:6000:1fae:b0:367:f281:260d with SMTP id ffacd0b85a97d-367f2812aecmr7034510f8f.1.1720865442043;
        Sat, 13 Jul 2024 03:10:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHB44G62KX/dILIjA2hXQolsbTtw+jRZeMNyH3DC7rg8PhDl8P2sXm1oJvu/5dqgeCXkwWU9NJjrXt0HG+5Ht0=
X-Received: by 2002:a05:6000:1fae:b0:367:f281:260d with SMTP id
 ffacd0b85a97d-367f2812aecmr7034502f8f.1.1720865441737; Sat, 13 Jul 2024
 03:10:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240711222755.57476-1-pbonzini@redhat.com> <20240711222755.57476-10-pbonzini@redhat.com>
 <73c62e76d83fe4e5990b640582da933ff3862cb1.camel@intel.com>
In-Reply-To: <73c62e76d83fe4e5990b640582da933ff3862cb1.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 13 Jul 2024 12:10:30 +0200
Message-ID: <CABgObfbhTYDcVWwB5G=aYpFhAW1FZ5i665VFbbGC0UC=4GgEqQ@mail.gmail.com>
Subject: Re: [PATCH 09/12] KVM: guest_memfd: move check for already-populated
 page to common code
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 13, 2024 at 3:28=E2=80=AFAM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
> On Thu, 2024-07-11 at 18:27 -0400, Paolo Bonzini wrote:
> > Do not allow populating the same page twice with startup data.  In the
> > case of SEV-SNP, for example, the firmware does not allow it anyway,
> > since the launch-update operation is only possible on pages that are
> > still shared in the RMP.
> >
> > Even if it worked, kvm_gmem_populate()'s callback is meant to have side
> > effects such as updating launch measurements, and updating the same
> > page twice is unlikely to have the desired results.
> >
> > Races between calls to the ioctl are not possible because kvm_gmem_popu=
late()
> > holds slots_lock and the VM should not be running.  But again, even if
> > this worked on other confidential computing technology, it doesn't matt=
er
> > to guest_memfd.c whether this is an intentional attempt to do something
> > fishy, or missing synchronization in userspace, or even something
> > intentional.  One of the racers wins, and the page is initialized by
> > either kvm_gmem_prepare_folio() or kvm_gmem_populate().
> >
> > Anyway, out of paranoia, adjust sev_gmem_post_populate() anyway to use
> > the same errno that kvm_gmem_populate() is using.
>
> This patch breaks our rebased TDX development tree. First
> kvm_gmem_prepare_folio() is called during the KVM_PRE_FAULT_MEMORY operat=
ion,
> then next kvm_gmem_populate() is called during the KVM_TDX_INIT_MEM_REGIO=
N ioctl
> to actually populate the memory, which hits the new -EEXIST error path.

It's not a problem to only keep patches 1-8 for 6.11, and move the
rest to 6.12 (except for the bit that returns -EEXIST in sev.c).

Could you push a branch for me to take a look? I've never liked that
you have to do the explicit prefault before the VM setup is finished;
it's a TDX-specific detail that is transpiring into the API.

> Given we are not actually populating during KVM_PRE_FAULT_MEMORY and try =
to
> avoid booting a TD until we've done so, maybe setting folio_mark_uptodate=
() in
> kvm_gmem_prepare_folio() is not appropriate in that case? But it may not =
be easy
> to separate.

It would be easy (just return a boolean value from
kvm_arch_gmem_prepare() to skip folio_mark_uptodate() before the VM is
ready, and implement it for TDX) but it's ugly. You're also clearing
the memory unnecessarily before overwriting it.

Paolo


