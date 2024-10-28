Return-Path: <kvm+bounces-29906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C38B69B3DC1
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 23:33:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87B62281F5D
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 22:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7CDB1F429A;
	Mon, 28 Oct 2024 22:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s0IQAS6r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33AC18FDC2
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 22:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730154786; cv=none; b=cRiHldG6LQCeWYNYFTKNk9OhPYIMkG8pByFAIIeZ7PF16WNMiIBM4e01xheRnLJ1sdGI32AzC+oHO484KxpgYykE2uQlHdQrJ9SMiyEcTU8QCVAt5MGGLrqI8py8u1bKoyeod/6hhWd/Dd677bKQdcP7taknTjAWAvnIzCsHoh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730154786; c=relaxed/simple;
	bh=kNHEHMV0zY+1aYzhjiKwyR0TGgGP9KUxL3tta/OZWR4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JeKeJVZxy+Ox9ZiBFYAmupdFUITkGIQzwAQtnFaMxANTi0kAYr+eCZWFFCztogQtBHscJAOlYtlLMpQWzbCEclm8sFqQHNrRRHNRPaMvxRzuwpqeVa5CKUc1NRHudrQc4Qb1xk69UM9/eCu8tqRTjPVwXHydWguGJFjZExOkp48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s0IQAS6r; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-539e681ba70so4033e87.1
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 15:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730154781; x=1730759581; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4PXUdti5B4GGx8N5cDYO9ntXy7OHOZuPm7RsuKd7wHM=;
        b=s0IQAS6rKOf6N01eEjcXLT2LDYThHwd/oT5rWD1AhkNx8GB+fIgiLhB9D6Rv+zS8vj
         Ll9vX33ZBj2HLkdCLT5ubV1E6cIHU7prRX9kBolXdMFOKJAP/yWMh1uHJWSP0QjO9mEQ
         dNDcgSVHAFifDUnZt23WKV+82N+0EVEQqHSCfstCX3fHUvFX/Cpv61p5mVFdGXVFPZxq
         2Db6BM9MG/A/R/qO0EICNqpjHiK5ZWbACVu5oUZFDvWtv0VQLu+Uma1PHXPV7J+jTzql
         Fcy4gvxD1eMAlr9w2JnwDZFKQaKq6qZV8hTYU69UQGoK25wdPHZbVFq6qRrifEmtmDL7
         12Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730154781; x=1730759581;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4PXUdti5B4GGx8N5cDYO9ntXy7OHOZuPm7RsuKd7wHM=;
        b=RnIatwuRdcVfovG2yHB11t72uFifDV8vLhJ2Kcylr/1BFGHs2d57+6jbEUArl9hkKV
         e5thTOTrR4VsdJliB4Ug+oFLYP/SJK8PkPgaStVcrxX57v/avkFvSUq4NXoXHnxm23Zy
         Dy0OdIq9GNfcD21qyzz0Dkl7X8GX6LlERP9Lw+NpGPR46+Y+1ScSZ+lUw0/vJ8GFZbfy
         fznMHUTPwHVQwD1UI7YXO98Cr45c0nKf5xMoyNDQbkCZan5ZV5jcjlDI2WIXMeH6u1jG
         W5uM45hVipVWPT/WI+lE/PDcC83SgiaZwX/efaLEKvDM3btsN6DxtZDAuuRofDLFupy4
         n1OA==
X-Forwarded-Encrypted: i=1; AJvYcCV9WarAm23rnbTrXR16qM+cvS02C2flkDyO+jHSl2mjQSuXis2BJw2iOylpCt+GuWu0nPU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfEi7d1CShMWaurNki1E9iGkS26lec/Lk0/4BeuUtJUKb5Wf4j
	mFskUKT97z6L6f1Oz3bHuQRO3GL4OhSPY6rFbmSCzFfahPbp5BAx//7/vyxN11UscMFcAJK8tdD
	fkIqnzc3Tbdmb23WJjmlIlt/ceXnqdgYJCezt
X-Gm-Gg: ASbGncsOi7eMhqIV8mzxoCxDaCFFhQ9WwW0q+LSqPYKTzYrpjIDzTnjhnFEroh9WH0h
	uGu1k4PCGutL8ncQuy2VsoRIv6jVnLPkMDIYYHyk+SeUCOLgcm9o+mT1iYl7uPg==
X-Google-Smtp-Source: AGHT+IFRClGAbqzMEgpB5HFrgsld+skZharIDl6h4zzXmGC+APYDTqAblfanhlkNcbb8hQiK1ZC37WX2geMLM7RCpFE=
X-Received: by 2002:a05:6512:158e:b0:52e:8475:7c23 with SMTP id
 2adb3069b0e04-53b48c0935cmr69374e87.7.1730154780695; Mon, 28 Oct 2024
 15:33:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241004195540.210396-1-vipinsh@google.com> <20241004195540.210396-3-vipinsh@google.com>
 <ZxrXe_GWTKqQ-ch8@google.com> <CAHVum0ebkzXecZhEVC6DJyztX-aVD7mTmY6J6qgyBHM4sqT=vg@mail.gmail.com>
 <CALzav=e7utP8wT_0t2bnVjyezyde7q86F3BHTsSpR1=qVbexQg@mail.gmail.com> <Zx_45FUW1QddzqOU@google.com>
In-Reply-To: <Zx_45FUW1QddzqOU@google.com>
From: Vipin Sharma <vipinsh@google.com>
Date: Mon, 28 Oct 2024 15:32:23 -0700
Message-ID: <CAHVum0eNy-4nnv-9vPmG7cVM4JO0L_v-s4V6-NFWxYRumt5a=Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: x86/mmu: Use MMU shrinker to shrink KVM MMU
 memory caches
To: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>, pbonzini@redhat.com, zhi.wang.linux@gmail.com, 
	weijiang.yang@intel.com, mizhang@google.com, liangchen.linux@gmail.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 28, 2024 at 1:49=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Oct 28, 2024, David Matlack wrote:
> > On Fri, Oct 25, 2024 at 10:37=E2=80=AFAM Vipin Sharma <vipinsh@google.c=
om> wrote:
> > >
> > > On Thu, Oct 24, 2024 at 4:25=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > >
> > > > On Fri, Oct 04, 2024, Vipin Sharma wrote:
> > > > > +out_mmu_memory_cache_unlock:
> > > > > +     mutex_unlock(&vcpu->arch.mmu_memory_cache_lock);
> > > >
> > > > I've been thinking about this patch on and off for the past few wee=
ks, and every
> > > > time I come back to it I can't shake the feeling that we came up wi=
th a clever
> > > > solution for a problem that doesn't exist.  I can't recall a single=
 complaint
> > > > about KVM consuming an unreasonable amount of memory for page table=
s.  In fact,
> > > > the only time I can think of where the code in question caused prob=
lems was when
> > > > I unintentionally inverted the iterator and zapped the newest SPs i=
nstead of the
> > > > oldest SPs.
> > > >
> > > > So, I'm leaning more and more toward simply removing the shrinker i=
ntegration.
> > >
> > > One thing we can agree on is that we don't need MMU shrinker in its
> > > current form because it is removing pages which are very well being
> > > used by VM instead of shrinking its cache.
> > >
> > > Regarding the current series, the biggest VM in GCE we can have 416
> > > vCPUs, considering each thread can have 40 pages in its cache, total
> > > cost gonna be around 65 MiB, doesn't seem much to me considering thes=
e
> > > VMs have memory in TiB. Since caches in VMs are not unbounded, I thin=
k
> > > it is fine to not have a MMU shrinker as its impact is miniscule in
> > > KVM.
> >
> > I have no objection to removing the shrinker entirely.
>
> Let's do that.  In the unlikely scenario someone comes along with a stron=
g use
> case for purging the vCPU caches, we can always resurrect this approach.
>
> Vipin, can you send a v3?

Okay, I will send a v3.

Thanks

