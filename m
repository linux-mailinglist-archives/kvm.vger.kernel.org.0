Return-Path: <kvm+bounces-7766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4DA846182
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 20:54:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C364EB2B695
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 19:54:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0509885624;
	Thu,  1 Feb 2024 19:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jw64922h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE38F43AC7
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 19:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817233; cv=none; b=dNQrJtMQk1vaeWwM6Bq5HevodTNuTlJ55qK/JsAr6us0iITmFRLoklSW/ySBBt/rJKW7dusQ1wICgsmYzjGw5BGcYdac0EsmStUaYp1GSyr9gg6DD3PlZpsp0lG0FsbenwxyxD6PySeckpny7yVDwuHZqTGkiR/Gr3QuZ1OLLdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817233; c=relaxed/simple;
	bh=Nqs2JJxBm7T0P3ag+r9acwRa4/ZTnLECC4+efZ+1Euw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=okf9pqzqsGQ5WnEfYZhm+2lUHGL2PNeZETK4GnyXC8xVUxVyPrvnLg9cXZEY6WCf4BJz6zTI6LVxUV1jGStNhIxGxbSf2uFkIu27pWPHmqoGMFza1Ws0kpDtmr0/q9RVhYKjiyrBWckMDLhL6kM9dOYlR4U6vqLAYB/Zyj07ocg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jw64922h; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-dc6dd9bf348so903961276.0
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 11:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706817230; x=1707422030; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7A/HkkJDgr4qzd4kN+fexcAVt/qR1JK/qSrZDebTgSA=;
        b=Jw64922hTswu4drh8uuvxPowJPAw9BfYJS2RPmJJ/0Dul8CvaQOJ/5MPOlO+FLLlPg
         8Dyv6IQzdoj1TBnWew6oxL+6VqoOUaj4TwVX9pDuhBHPoC0MZpVmFHYT2/ZNsKP8rQdM
         13oaq8GEPC/DC+U/ODUdm1f/xrO2wIhRJGI92qhxusheGZdEcNAyanZMDEPEA7ymh6aB
         a5CYPPBBT4LJb/oEMNrjZo56WpWf0BbXu2WUQts79zq9gOCimsRUXxxF0hluwWziiCKs
         vEdAr0gw6PffxNZuGUZ3JqmFcE/QuKOilDU+X5nh20pEtCrqjUhptKQvUN41yL22IxwG
         NQbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706817230; x=1707422030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7A/HkkJDgr4qzd4kN+fexcAVt/qR1JK/qSrZDebTgSA=;
        b=mJYe8jT5oYlUrhqeNXC6QzeTd1rf0MXz6TBgYqdX+F6QHTYudKNWJ+MwSxFyBVylJO
         TEvK3knxphbs5n1aQt5B/6Qqc0TIs4k5LmdKx8/TiEzqp/kCzFH5AT20GcolLstOKtgz
         sMRM9ql7D/ZLNlwH/N2F/tGRHvm6lDsUsDJlpPYkY2wAIHBEfCP9J7F/i8lyFfjIXVKp
         RaRbq5bQwb+lGSjipX9LZ/k+R5qwCj04G02VOT7PnMnkv1OiS+y9NWC0wsVpUMOluCUQ
         3cg3qykJ/LVI6eXUL8pANkRLo3V1MpnYCv38Xscefy2apidP+cwoIndY9t1oqpp6Oe9m
         v34g==
X-Gm-Message-State: AOJu0YzNyCQtzHDa47izWmEkkvCFdAqXI0DvFsvu+q97VRCC2/tw8THU
	daS9pCRMt8I6Oxj42FDjEBO7NdGN8CvZ5A8Z01suYPHKb76Z1BP6A1SUzyAGAC3p106N1RMjDrF
	Y6fkglOGH0t1MQUx7x4zUpeupobuxzNFTZYX6
X-Google-Smtp-Source: AGHT+IFaFkzkIs7LVHBOA/OCdlLq/Z79yJeetWilGN9Fc+P7QVJBJBXH8HC5WJ59b/mg9Wuf8NwhG2s9YI2lXR13v8Y=
X-Received: by 2002:a25:4d86:0:b0:dbd:b081:9663 with SMTP id
 a128-20020a254d86000000b00dbdb0819663mr2952904ybb.41.1706817230435; Thu, 01
 Feb 2024 11:53:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240123221220.3911317-1-mizhang@google.com> <ZbpqoU49k44xR4zB@google.com>
 <368248d0-d379-23c8-dedf-af7e1e8d23c7@oracle.com> <CAL715WJDesggP0S0M0SWX2QaFfjBNdqD1j1tDU10Qxk6h7O0pA@mail.gmail.com>
 <ZbvUyaEypRmb2s73@google.com> <ZbvjKtsVjpuQmKE2@google.com> <ZbvyrvvZM-Tocza2@google.com>
In-Reply-To: <ZbvyrvvZM-Tocza2@google.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Thu, 1 Feb 2024 11:53:13 -0800
Message-ID: <CAL715WJ_VT2E5bjgvC89Dk0j1Mft9PcGtEBkkAxkKMF0=+Uimw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/pmu: Fix type length error when reading pmu->fixed_ctr_ctrl
To: Sean Christopherson <seanjc@google.com>
Cc: Dongli Zhang <dongli.zhang@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 1, 2024 at 11:36=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Feb 01, 2024, Mingwei Zhang wrote:
> > On Thu, Feb 01, 2024, Sean Christopherson wrote:
> > > On Wed, Jan 31, 2024, Mingwei Zhang wrote:
> > > > > The PMC is still active while the VM side handle_pmi_common() is =
not going to handle it?
> > > >
> > > > hmm, so the new value is '0', but the old value is non-zero, KVM is
> > > > supposed to zero out (stop) the fix counter), but it skips it. This
> > > > leads to the counter continuously increasing until it overflows, bu=
t
> > > > guest PMU thought it had disabled it. That's why you got this warni=
ng?
> > >
> > > No, that can't happen, and KVM would have a massive bug if that were =
the case.
> > > The truncation can _only_ cause bits to disappear, it can't magically=
 make bits
> > > appear, i.e. the _only_ way this can cause a problem is for KVM to in=
correctly
> > > think a PMC is being disabled.
> >
> > The reason why the bug does not happen is because there is global
> > control. So disabling a counter will be effectively done in the global
> > disable part, ie., when guest PMU writes to MSR 0x38f.
>
>
> > > fixed PMC is disabled. KVM will pause the counter in reprogram_counte=
r(), and
> > > then leave the perf event paused counter as pmc_event_is_allowed() wi=
ll return
> > > %false due to the PMC being locally disabled.
> > >
> > > But in this case, _if_ the counter is actually enabled, KVM will simp=
ly reprogram
> > > the PMC.  Reprogramming is unnecessary and wasteful, but it's not bro=
ken.
> >
> > no, if the counter is actually enabled, but then it is assigned to
> > old_fixed_ctr_ctrl, the value is truncated. When control goes to the
> > check at the time of disabling the counter, KVM thinks it is disabled,
> > since the value is already truncated to 0. So KVM will skip by saying
> > "oh, the counter is already disabled, why reprogram? No need!".
>
> Ooh, I had them backwards.  KVM can miss 1=3D>0, but not 0=3D>1.  I'll ap=
ply this
> for 6.8; does this changelog work for you?
>
>   Use a u64 instead of a u8 when taking a snapshot of pmu->fixed_ctr_ctrl
>   when reprogramming fixed counters, as truncating the value results in K=
VM
>   thinking all fixed counters, except counter 0, are already disabled.  A=
s
>   a result, if the guest disables a fixed counter, KVM will get a false
>   negative and fail to reprogram/disable emulation of the counter, which =
can
>   leads to spurious PMIs in the guest.

That works for me. Maybe scoping that to the guest VMs with PerfMon v1 enab=
led?

