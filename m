Return-Path: <kvm+bounces-41585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D5D1A6ABE1
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 18:25:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 716D9886BBF
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 17:23:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E800224231;
	Thu, 20 Mar 2025 17:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="StJoeZQS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1935021CC55
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 17:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742491419; cv=none; b=FhsAldRoLy7jaj8HTPX1zkenG3ESbcpGuWAe3aje/c5Ip4bZE0WLM/6ldEgYcSNc4RCH6k6gtN6kQ2IS0tuq/k42KwfQVSF9Z8hro8vpxgxSO8ldWCHu0z7dhW80iDZifWWAbhNnWBfOZd7kkZXNXWVRYC3Coq20lxWpZ1Nzaps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742491419; c=relaxed/simple;
	bh=dbLH2bKRPbpvhbDhyJijYnxIQOvnm4I3EdH+g7kA1QI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rZzpA214aT32xNsv2j0aWJeh8YMtMhqE0ZNb9aYQE0MxHRsfr5qs9vikPk++uj/arR3xBy316SIkvQH6bJ6ma/ZwKdIQAfhvbDSmbyy1BSSpu0nGDctCXkG4SxSioXyx4xghVv95GG6/K0gAqGt+KGHXKpFVQhT67wCypOknmk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=StJoeZQS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742491417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uUFR6AsD7gUx8Px4BvBzkVDxZQ1SsnbGA0GFylA0Z7k=;
	b=StJoeZQSvQXJvkcx3l3beieMUx8y6Bh4ywAkW/E/a0lYNpMsxJYbftjJGEZjiOL/bRdidu
	b2WPlv7KNJxdKtoqKbEAe0eVJepqYguWpYTV2HSk+BIWYbjrAEkRuiSRK02/7F9PCtF/xH
	J7iErm8Jm33CF0hEYnYLBqTJJ2jvje0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-jJcILRFYOUCdGF2uvdpO2g-1; Thu, 20 Mar 2025 13:23:35 -0400
X-MC-Unique: jJcILRFYOUCdGF2uvdpO2g-1
X-Mimecast-MFC-AGG-ID: jJcILRFYOUCdGF2uvdpO2g_1742491414
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3912fc9861cso453388f8f.1
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 10:23:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742491414; x=1743096214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uUFR6AsD7gUx8Px4BvBzkVDxZQ1SsnbGA0GFylA0Z7k=;
        b=IUpPayylyCqapDEFbhEgpx0mGBxfhtFpwVqjJe4gCIkShyoSB9pSM3iWm9Zd7+Enb9
         ySfBiMny5C4BRiP11+s6EDbLuHwwtAGPXDGBkJyivC6XIL4kb8RV8lkDvPZTyuA5ABnN
         92UpK+5qDmkSe7wfBV21fO34pMkGxeomIkZxO3DHtWEfbAxWGswFpTbjYumGFmhIgR8B
         vuNzq3IhCyiGw9sgMwgqzPL1aAAx15KXf9+nbDMY41kjl7yxBqnzitfWd5b7AGd82PMH
         /h05mWV+OfjDM+jE8AFaoh3TibnoE/4qJ57xwA3Cutx9K7Z+KoWBQESMOOF2KOQa+HF0
         AxhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQfg3SI9CI6HzMS7bELDSy5QeL2doAr1C+Ja3WbVbtBn5npCYLJMSQCbV+UFoebTuFBHU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSzzYz6MMTn4yGxCMlFbO5mdesy/gyyngmPdvvl3m6rgqxyNFJ
	vD/mEI7LrX2XNBz6moZIo45yAVTWuffkTe1OcGsLmsz6Qlo3ZnXx+EW2yVSN6fMg/RkzkS9lelU
	MQ7jwgkSOW+f51+9sQR33g1wQgzQJ41T5tbls+UhU3H+HpFLiCxHW87kgJxn6Q3gL8f7u8V594B
	5UxhrJcjnPojPfUa9ZSciHDjkE
X-Gm-Gg: ASbGncuT5xMYtFyX9zy2yNpGULfeMVtNUhMgmPMEb/N4qIfaUIwlzYf7fMlGZ5fuG4U
	1CJXMF0+MLzeizHP1ZAhene09UcTcwZmBzbUI3Dj46PIMJFalEp3Gkjf4i2C6j9xtpHLghuJHuA
	==
X-Received: by 2002:a5d:6c61:0:b0:38f:2856:7d96 with SMTP id ffacd0b85a97d-3997f8f605cmr421246f8f.1.1742491414231;
        Thu, 20 Mar 2025 10:23:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0Iy3+ELXSOcGKqjjNcijqtjRKyZWH2Uy/EbnYOYdMFiTRlvTKJiFQxtAtj3dChuBu4/j+YNjTHeSa0Li9mH4=
X-Received: by 2002:a5d:6c61:0:b0:38f:2856:7d96 with SMTP id
 ffacd0b85a97d-3997f8f605cmr421220f8f.1.1742491413842; Thu, 20 Mar 2025
 10:23:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z9uZpZKfqWP8ZwH8@linux.dev> <86ecyrn9hf.wl-maz@kernel.org> <Z9wZ8EuChPyJ6PiK@linux.dev>
In-Reply-To: <Z9wZ8EuChPyJ6PiK@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 20 Mar 2025 18:23:22 +0100
X-Gm-Features: AQ5f1Jro3DCd-dTgCxYhklGF6-TcO4Lalc6LpGkXTh7aC2K02ARegu6zlLFUsOI
Message-ID: <CABgObfbHz1iyrH69JiF19RC4SSiYVbRN1P2+KRkFWSEg_2mjbQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.15
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Akihiko Odaki <akihiko.odaki@daynix.com>, Will Deacon <will@kernel.org>, 
	Vincent Donnefort <vdonnefort@google.com>, Sebastian Ott <sebott@redhat.com>, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 20, 2025 at 2:37=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hey,
>
> On Thu, Mar 20, 2025 at 12:59:40PM +0000, Marc Zyngier wrote:
> > Paolo,
> >
> > On Thu, 20 Mar 2025 04:29:25 +0000,
> > Oliver Upton <oliver.upton@linux.dev> wrote:
> > >
> > > Hi Paolo,
> > >
> > > Here's the latest pile o' patches for 6.15. The pull is based on a la=
ter
> > > -rc than I usually aim for to handle some conflicts with fixes that w=
ent
> > > in 6.14, but all of these patches have had exposure in -next for a go=
od
> > > while.
> > >
> > > There was a small conflict with the arm perf tree, which was addresse=
d
> > > by Will pulling a prefix of the M1 PMU branch:
> > >
> > >   https://lore.kernel.org/linux-next/20250312201853.0d75d9fe@canb.auu=
g.org.au/
> >
> > When you merge this, please also apply the patch below to address a
> > mismerge issue caught by Stephen, which causes a build breakage.
>
> The kvmarm-6.15 tag is fine, I caught this immediately when I was doing
> testing for the pull request but forgot to push the fix to /next in
> addition to the tag.

Great, pulled now. Thanks!

Paolo

> Fixing that right now.
>
> Thanks,
> Oliver
>


