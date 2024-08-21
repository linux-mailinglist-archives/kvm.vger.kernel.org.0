Return-Path: <kvm+bounces-24687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DAD2959450
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 08:01:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 018E81F2428D
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 06:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F56316BE28;
	Wed, 21 Aug 2024 06:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UXT+VfQ4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6620C168492
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 06:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724220079; cv=none; b=maJLuPAHAIizCkE/aEqQ9ZVXsG1VNiSOzl/HNJWgomz1Frjj33NZFC6y9lW5dt6Yea1uShAouB+pCaY7iDXZnQCF950dC5k++prvvurpzhVYkqPzJLcCjkcWNFqolc+lDzpyevCDAFOEbskXsx2UAUdh6kYX43RqF8QSBqXmYxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724220079; c=relaxed/simple;
	bh=irOyT/hJhdlweiymfosrNsuEHfg6Fy5diBIBgYoVbXs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PSAtr0mTtCoa08aW9tmIJNiIOeccWYhi4CGTdDOdRoJlaZ6iH6gH4+aB+PVv4JdUCcUYY/0ujtaS7lxMtIdM16rdZaDpgDeS5rCj7eqGEayHno4IzL3J/mb8Yj08yFT8qOCX9ApUdTULoUT4+6JCtxdsztSwwlFo1otBkthxp10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UXT+VfQ4; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-44ff99fcd42so36711911cf.0
        for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 23:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724220077; x=1724824877; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nVpwwTneVXAqz7BYaGRl3oriMB37pJVMzaqxHAQHEgc=;
        b=UXT+VfQ4q5cUH9gh5pG64nGaXYuwMKlJnXWeAmw7HLUB4jTEcbroilMLI28P5G4kfU
         QkBuOwy6L/i/oX/0MdY2V+wSB7l/oVJHAuSEUvuA9tr6JcukixFJRANJyjfwnQseo5uQ
         prpz1uWbAYtbevMARk71FQ079h3n0HNs9n/3pPAuY9zGbPdzMwhalCITGkP+LYbUMNbx
         7cgHuRG+iaDyYW0hyA0+Migb9I3U3/jzF6TgqDj+fEPwX3mqXfiZ/FMV1HzaJ5bKO0A/
         6LWr206ircLsOg7er55rcAxbmGAA4C4b8TRr20vvJVo7bU0Sx/DV4HxXGXqUFGB9A+JS
         UNeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724220077; x=1724824877;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nVpwwTneVXAqz7BYaGRl3oriMB37pJVMzaqxHAQHEgc=;
        b=bRndOB2McBbbsmrn4HLoPTHcH7lStXgsIHjVVCsUwJzkBqR+tGhiqZmn1fu+KLeSCS
         x4rlaIqyYYJKBYfRpGO+8pckvSVM42AsiGod9svLH716e8u47yjF5gXJyp5adk6RVq3O
         n83AehIAg9yqCgj3f4VDB7V0m+Qviqx79mtj6vsuk+RHNwz3CQimI53ULMavM+kRW0yC
         M2zPDHGsABewSA/3o+KK8FoAm4wYDAeF06kF4TKs3spIlyxIGyuXMGMVDr1ruDSg0CMl
         vnal5D+pbOQnTNQTpDkx9DPmNLf3LfASeWkNcjkJ7me+Y1W40/cRhni/Jo9+usnR5xq9
         8AGA==
X-Forwarded-Encrypted: i=1; AJvYcCW2Dbl3rIRO9sVE7mv4RUT09fn8lsHm3bgB9n50rkzki+Et6XSYWRmO/fvVkhd6FBTGbMk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNIf/vgUM9wRC/Bjd0e3C6uy4gsRhCFy1wFCSkyj29UEnim1xI
	V3wyGT0s8jtI47Qqe27fobMD7XE5igw+Pdj83PJEM9SAS28DxO6/pkw2xn6F2vtUZJSWX2iS2GW
	RgtGhRWj71QmUiFqx2knP6NkdJfR86IFKjmy7
X-Google-Smtp-Source: AGHT+IFX3t5IPuvAF0MPCsrJwMQrt5HvH13DUI4O25PHyUj+5uNvmgVipSNk9q33J/RiUaJde/7P97x+Xek8lOrlS+I=
X-Received: by 2002:a05:622a:99a:b0:446:4968:45 with SMTP id
 d75a77b69052e-454f256459cmr13778241cf.42.1724220077096; Tue, 20 Aug 2024
 23:01:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240820043543.837914-1-suleiman@google.com> <20240820043543.837914-2-suleiman@google.com>
 <ZsV9wDXDoUMSNWgm@intel.com>
In-Reply-To: <ZsV9wDXDoUMSNWgm@intel.com>
From: Suleiman Souhlal <suleiman@google.com>
Date: Wed, 21 Aug 2024 15:01:05 +0900
Message-ID: <CABCjUKD__KOtOPH4amue2O4MkBbaQ-5O2v=55kyqVp_X53cqzQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: Introduce kvm_total_suspend_ns().
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 21, 2024 at 2:40=E2=80=AFPM Chao Gao <chao.gao@intel.com> wrote=
:
>
> On Tue, Aug 20, 2024 at 01:35:41PM +0900, Suleiman Souhlal wrote:
> >It returns the cumulative nanoseconds that the host has been suspended.
> >It is intended to be used for reporting host suspend time to the guest.
> >
> >Signed-off-by: Suleiman Souhlal <suleiman@google.com>
>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
>
> one nit below
>
> >---
> > include/linux/kvm_host.h |  2 ++
> > virt/kvm/kvm_main.c      | 13 +++++++++++++
> > 2 files changed, 15 insertions(+)
> >
> >diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >index b23c6d48392f7c..8fec37b372d8c0 100644
> >--- a/include/linux/kvm_host.h
> >+++ b/include/linux/kvm_host.h
> >@@ -2494,4 +2494,6 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcp=
u *vcpu,
> >                                   struct kvm_pre_fault_memory *range);
> > #endif
> >
> >+u64 kvm_total_suspend_ns(void);
> >+
> > #endif
> >diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> >index cb2b78e92910fb..2235933d9247bc 100644
> >--- a/virt/kvm/kvm_main.c
> >+++ b/virt/kvm/kvm_main.c
> >@@ -5720,6 +5720,15 @@ static void kvm_shutdown(void)
> >       on_each_cpu(hardware_disable_nolock, NULL, 1);
> > }
> >
> >+static u64 last_suspend;
> >+static u64 total_suspend_ns;
> >+
> >+u64
> >+kvm_total_suspend_ns(void)
>
> nit: don't wrap before the function name.

Sorry, I completely missed that, even after Sean told me.
Force of habit (FreeBSD style(9) says you have to do it).

If I send another version I will fix that.

-- Suleiman

