Return-Path: <kvm+bounces-15978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FF3C8B2B3F
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 23:47:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C06CF1F24782
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 21:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FD3F15697B;
	Thu, 25 Apr 2024 21:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kSkLWvbg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049A915664F
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 21:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714081566; cv=none; b=C3mvqYmBjiHwP3ZUvqarRyjT16XDYGW8inRFFbE5ve0eoEw9sJG1zOO2WYqgYeF14H/7Gk36P8jI5730Wu8hyx2Qznc4T77yAweaNIoi1902UGjwraPrYvCi7JKgdhIjYaVX21lK/zu6slKC3mnjcteDoVKXzdj4lzv3lUvs7Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714081566; c=relaxed/simple;
	bh=ddLKxs1S7s/ADJE035dpDCdlheH8Ec/EUB9hgxSWCqA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ClGWuoP0eCoTYWg5+IY90tkHAZKUCjja2AaXFUpId704kPjiSHHwENQ8wfYDrD6vIKr6iUYMDxOuSz9lSDbkKIXkygYWJa+/tptzs1naPNkh7ZgAMAESY/dos0a6UvcL68jRB7MwQ4xjCjvekUm00mkTNzWl0Does/bRnPsy44U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kSkLWvbg; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5f803c1693aso1670443a12.0
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 14:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714081564; x=1714686364; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s9g005zQ0uoPXb33P7XvBANrUcDvwGxhLLo5EvZW0qw=;
        b=kSkLWvbg9oxhLeu4v+HlAcmDuMvp/TTyiIxrPO+Km5RX/EntkNjXgZDBRuDfgwewoT
         ddYYDw0g/r1E0G1QsMEMXC7bkcQ2JNGli1QfsoCaghQhA+ZEh4YdQXiesFhgp0Fd5gGZ
         f7IopQ4+W8w0TB4+vzeoNVwMeRUmp1YQfvTcHOLogHR3kp5exTbIwZvjwPFRY/ZgMPe6
         mEU2au01Tjk2oSiqO4CHiWWQgmuSFZ3ThrhcMZBSTfjlrFVZV/Wksjb0NbkUBuYFAIUu
         HRvmQ1XECZBXWxtxxfX4usJjxSNUSmsXjoHGtnCfBtQP9xljJY21sEgKGZm8ALbWJf9e
         D3Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714081564; x=1714686364;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s9g005zQ0uoPXb33P7XvBANrUcDvwGxhLLo5EvZW0qw=;
        b=cuVevApt1j1pGRi8zmtv1L57q8mKTdapAVlsjVndJdysXBItLJpPASSmNhHSLwC1GN
         k8d4MdGmg48P7+vyHJoPjIkbdIISqtnX2XaXtuJr769vf7QFfZZEVgl6Hzhxxt82Xs1I
         8ZjO6kdPyXNsozQpqbstel09Oe5GWixCA/Y93PPe8CtmyYhSTWeojVERP6jbmH8LZ81a
         tR9bRvRWOiKs//b5oNTtMuFRH7cMILWMaLFyLMaBYHygxFHVidj7nqByQahmpj8KQac5
         ZtmN6GczBx2wP7IAkQqWoqHKxXAPTb53BVEPAqZ34nsNgQPlVxf7FcsdROeTkZyODfvL
         kadA==
X-Forwarded-Encrypted: i=1; AJvYcCUhLQEdK/hOjdtEjhfh2qizquRSnCLrHx8a8XsVkEZybgwssoheN8/SKHp0cPOlr5z/gR/A6VMDDc+9gPIx4O9IXsPl
X-Gm-Message-State: AOJu0Yz8S8i7v2dN6t9TNI4JGfU22Ya4yqBXI+O8l6YyuPZZ88dIQSDs
	hxVEJHpOox1T2hcJ44VU+ES/IWR3FYZdXw70UGLFuZ4r3cYBltgID1ZOdeRrwFbC3C2fOCMj7fH
	fFg==
X-Google-Smtp-Source: AGHT+IF/LRU+EJ/onrc6UqwR3rdQDKd/KzJxGXef0/+6lFJNaOGOLGDyuSBxzSg57E/OPctPDy+9bf178I4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2005:0:b0:5f7:fca4:6d2f with SMTP id
 g5-20020a632005000000b005f7fca46d2fmr25355pgg.7.1714081564026; Thu, 25 Apr
 2024 14:46:04 -0700 (PDT)
Date: Thu, 25 Apr 2024 14:46:02 -0700
In-Reply-To: <42acf1fc-1603-4ac5-8a09-edae2d85963d@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CAL715WJK893gQd1m9CCAjz5OkxsRc5C4ZR7yJWJXbaGvCeZxQA@mail.gmail.com>
 <b3868bf5-4e16-3435-c807-f484821fccc6@loongson.cn> <CAL715W++maAt2Ujfvmu1pZKS4R5EmAPebTU_h9AB8aFbdLFrTQ@mail.gmail.com>
 <f843298c-db08-4fde-9887-13de18d960ac@linux.intel.com> <Zikeh2eGjwzDbytu@google.com>
 <7834a811-4764-42aa-8198-55c4556d947b@linux.intel.com> <CAL715WKh8VBJ-O50oqSnCqKPQo4Bor_aMnRZeS_TzJP3ja8-YQ@mail.gmail.com>
 <6af2da05-cb47-46f7-b129-08463bc9469b@linux.intel.com> <CAL715W+zeqKenPLP2Fm9u_BkGRKAk-mncsOxrg=EKs74qK5f1Q@mail.gmail.com>
 <42acf1fc-1603-4ac5-8a09-edae2d85963d@linux.intel.com>
Message-ID: <ZirPGnSDUzD-iWwc@google.com>
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
From: Sean Christopherson <seanjc@google.com>
To: Kan Liang <kan.liang@linux.intel.com>
Cc: Mingwei Zhang <mizhang@google.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	maobibo <maobibo@loongson.cn>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com, 
	peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024, Kan Liang wrote:
> On 2024-04-25 4:16 p.m., Mingwei Zhang wrote:
> > On Thu, Apr 25, 2024 at 9:13=E2=80=AFAM Liang, Kan <kan.liang@linux.int=
el.com> wrote:
> >> It should not happen. For the current implementation, perf rejects all
> >> the !exclude_guest system-wide event creation if a guest with the vPMU
> >> is running.
> >> However, it's possible to create an exclude_guest system-wide event at
> >> any time. KVM cannot use the information from the VM-entry to decide i=
f
> >> there will be active perf events in the VM-exit.
> >=20
> > Hmm, why not? If there is any exclude_guest system-wide event,
> > perf_guest_enter() can return something to tell KVM "hey, some active
> > host events are swapped out. they are originally in counter #2 and
> > #3". If so, at the time when perf_guest_enter() returns, KVM will ack
> > that and keep it in its pmu data structure.
>=20
> I think it's possible that someone creates !exclude_guest event after

I assume you mean an exclude_guest=3D1 event?  Because perf should be in a =
state
where it rejects exclude_guest=3D0 events.

> the perf_guest_enter(). The stale information is saved in the KVM. Perf
> will schedule the event in the next perf_guest_exit(). KVM will not know =
it.

Ya, the creation of an event on a CPU that currently has guest PMU state lo=
aded
is what I had in mind when I suggested a callback in my sketch:

 :  D. Add a perf callback that is invoked from IRQ context when perf wants=
 to
 :     configure a new PMU-based events, *before* actually programming the =
MSRs,
 :     and have KVM's callback put the guest PMU state

It's a similar idea to TIF_NEED_FPU_LOAD, just that instead of a common chu=
nk of
kernel code swapping out the guest state (kernel_fpu_begin()), it's a callb=
ack
into KVM.

