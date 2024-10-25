Return-Path: <kvm+bounces-29739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 43D0E9B0BC3
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 19:38:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C6DCBB24132
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 17:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 355591D4355;
	Fri, 25 Oct 2024 17:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zN4FVv4u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5082618C344
	for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 17:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729877834; cv=none; b=QXYO7wQI+g00NdnRmBpb5t1/sdLqvUTZqd+rlfCU56afFgidhY2DjIBy1hs3ejaeNTy08A4d/MSkne8LwfBkFQCux7I3V0fg7deLtPXC7eyPW/MIoR4ng9QL1wGehN8Si/nBWZmTxQGUeFGVl2pRYrRWFQ6PK7FeGyKkU6HvMFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729877834; c=relaxed/simple;
	bh=vIBV02O+LRvHoGop9H9PTAD4+Ag8TMdrt95BD4uN0YI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CbhnmJNWEEo9cOoa1qW1qvXl8xRaNGlvKJ0K9efAPQPnC3emW0re08WTNyrCOPdMjETkW0LJXoGOKzLdiFPnfPYbP+B6O7NCUj7Uy2kyB8hCMB5pdHiRY28xWJo2trN09SktRUwadimNSxWmmZ/LWjn8deTsyiwpQSy2QOXNWoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zN4FVv4u; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4315a8cff85so20185e9.0
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 10:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729877830; x=1730482630; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JUvARlAjWtUkbpBS3b9UleGHLvABqtUp2olkNT4cfjg=;
        b=zN4FVv4uB0fSNRP2kL7L2TNOTQ3s1cs68KxkL48ruYIDSU9nQ4XYfvj4umbdFWt7/P
         /2Q5+XIS6WL7O1ejx4TlVT9RZua89/DovHpHivUJ06xt0NNUv1TaT/0D4tRADkC9/yah
         70lv+FZ78nrwIhxBLAZ8AzVDzZp5OY2CA7AZvpGoYGTMU01FLBZS2CoWa3OyFVJeyjJj
         TsJK5AhJmYWfjo6lHtGqBmlrGLgj9N0nS5T5J2IbRouuiCz5NE+xJN0HzZK0mFyEViqI
         33vDHBU6Bl61y+3HP0hexUW2wduQD8H8JVwg2PPhb8ntzYdwGTZO7qfbJuuzrpmNR/pY
         Fh5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729877830; x=1730482630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JUvARlAjWtUkbpBS3b9UleGHLvABqtUp2olkNT4cfjg=;
        b=iNhc8Lgd5+ODBiPUtafjkUFmFYHmqTaoSfvwpg0IdW2ZRwTK6iOFwAWbvzbnIoCViY
         6667VS+cefdf6lyeJy+R3MFB2/1AkRC+MjKcWtHfX0CB8gMCuq0QoXgFpAz+lX5s/RYs
         sKPQwQANINcOtSk3ID4w5ANjQl5xR2xZD/1aWTK8gpRE5DPOi4sfGSxsY01ualnIMLKS
         tzFvr45oM+BgFAN6s9cwiGM2IiSjOb3R1PumRQDK1kIiSx74N+j2Z4pC35gfeupNFHiN
         fzoKTRlfAc4LuMzts1O4poSh9JunM4BdA7WIdKRK9SihDriJb+TNT6dMzOOj2qr4VoY/
         7wdA==
X-Forwarded-Encrypted: i=1; AJvYcCU9kyZwvMHT0xXH/9k+Zz1Sbdm/noR1avdXZqs0Wxj7cAd5ZO3MR0LAxuAEHyVAgjysdDk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHEWLq82VT829yZfphjLAfBJhO62Hkv4fUZH+IHH2mxJzBzBB1
	0wl+9ByLE6EidMLYbUEPhUIyv1GC6//Be/+10+tAv5zJcPv4Cht0kPdwnPDRnr3abPD8vINncOR
	3B6/5uXXPCgyVbT+DnRgH5hNY3I46+yUYzQYa
X-Google-Smtp-Source: AGHT+IFqFsMMJ5U+cB95wgqsTu4ul7SXq9JYmE8u0H+tFP1iKJCHNDGIWIjq1RVXn0lKRu6Q6q/DVWwtBsFaO9tD9BA=
X-Received: by 2002:a05:600c:500f:b0:42c:9e35:cde6 with SMTP id
 5b1f17b1804b1-4319abf416fmr72475e9.2.1729877830499; Fri, 25 Oct 2024 10:37:10
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241004195540.210396-1-vipinsh@google.com> <20241004195540.210396-3-vipinsh@google.com>
 <ZxrXe_GWTKqQ-ch8@google.com>
In-Reply-To: <ZxrXe_GWTKqQ-ch8@google.com>
From: Vipin Sharma <vipinsh@google.com>
Date: Fri, 25 Oct 2024 10:36:32 -0700
Message-ID: <CAHVum0ebkzXecZhEVC6DJyztX-aVD7mTmY6J6qgyBHM4sqT=vg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: x86/mmu: Use MMU shrinker to shrink KVM MMU
 memory caches
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, dmatlack@google.com, zhi.wang.linux@gmail.com, 
	weijiang.yang@intel.com, mizhang@google.com, liangchen.linux@gmail.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 24, 2024 at 4:25=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Oct 04, 2024, Vipin Sharma wrote:
> > +out_mmu_memory_cache_unlock:
> > +     mutex_unlock(&vcpu->arch.mmu_memory_cache_lock);
>
> I've been thinking about this patch on and off for the past few weeks, an=
d every
> time I come back to it I can't shake the feeling that we came up with a c=
lever
> solution for a problem that doesn't exist.  I can't recall a single compl=
aint
> about KVM consuming an unreasonable amount of memory for page tables.  In=
 fact,
> the only time I can think of where the code in question caused problems w=
as when
> I unintentionally inverted the iterator and zapped the newest SPs instead=
 of the
> oldest SPs.
>
> So, I'm leaning more and more toward simply removing the shrinker integra=
tion.

One thing we can agree on is that we don't need MMU shrinker in its
current form because it is removing pages which are very well being
used by VM instead of shrinking its cache.

Regarding the current series, the biggest VM in GCE we can have 416
vCPUs, considering each thread can have 40 pages in its cache, total
cost gonna be around 65 MiB, doesn't seem much to me considering these
VMs have memory in TiB. Since caches in VMs are not unbounded, I think
it is fine to not have a MMU shrinker as its impact is miniscule in
KVM.

