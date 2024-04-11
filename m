Return-Path: <kvm+bounces-14329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FFF28A2059
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 22:43:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16F5E284E14
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:43:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91F3C2BD06;
	Thu, 11 Apr 2024 20:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="soWsNjVV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771482942C
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 20:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712868199; cv=none; b=UpCOaZAAbshZk9XQDmnN0u9jvmxII8XWGqqkPtX5J3wCPyQ+o5OJgxH0xr2MFabxjZoKn2S+ble1+uN3C2yiC5PtHnVRINsLZ4BuCeFfCchwuFG2KTguScIwhqKg8GXgHy8+i95o7BS/Af8Ckc3IzPwLlhFDS1D0kRazk9eFN70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712868199; c=relaxed/simple;
	bh=weomEscsKp+dv8w551tTrVJuaEiedKNRqyWw8eUBHo0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZN116tXi6W5P6yj/XUH82wh240z6iwawben9kcl0hktspRqRxnVoijXBg4idZJo14iVbP61ECL2f1rNnaIRM1MsSne4Nb7AIaJUM4GPFrdFu7H/r1XvXvqI9OFsyCWa6QnY9bMeEiylTduwxNFpScypfL+m53ygfg1ubRpmiSZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=soWsNjVV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2a4f128896aso969663a91.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 13:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712868198; x=1713472998; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8TxHX0PcxuES+Tf5l7zk1AZum/uiKOve5mEHI8s5roo=;
        b=soWsNjVVIYGHHPpl9e8EJvIUcxnY+50xML3ljTrG2X7KUFgQqnieySu+Erihy+zy0w
         Oo0/uNoKBIVdJ6Cv4/iHe00Tib7G1AUHRxaRK3iIyRrkGNq/nuF8Wk3GSbuxD34ZtFBe
         tdQkMy6Yx2M3cmNoLiAHizYQIY1cflnPmbJCOBEJhewoC1U1Mtp1Idlfpgg9AMaawktS
         4XQ9D06Kgs7njbEpwYYeYQBSzvN+TQ2wXPbNJOC2wggVm5W9A0b0JqEXYHwzBUGl9VQA
         8jocbchzxb8ptOkAdZtRy09cm9G4fulk/tVgkXcJ8s/p3XTc7ZcY+Uc2oeNK+QuNUj/w
         KFuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712868198; x=1713472998;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8TxHX0PcxuES+Tf5l7zk1AZum/uiKOve5mEHI8s5roo=;
        b=GrSShPugA++BuHe4AwXb6chufMTeBNEXjzXn7gGyOZeqxom+L/2b3TJSRGnqluIEPI
         LBJbO2aIjAUP26p/3Cj0SvhCGUE4sd2ezs9am5z/UGOYgqnBa/9Cv1v6l2FP3ewKTHn2
         djubLkFzUeXO4ZjjuVJ7FPLSjFdKHw3TvLEEB4VSTUHjM3ajeuSzmdJHMK1k9TlBLlZj
         02Y64jDCdE2X4/4gJ2mMrFHtpJjqEMK1muv0dK7X6IXVvQFC1KHcWNOXYyh5QrKdklvp
         laKKC/c2Yd0l2/+6gKGuhtsuJEM4/k9bGerjZm3KMp5sgequoEGzBmaw+3ANUDivwxXw
         Ot6A==
X-Forwarded-Encrypted: i=1; AJvYcCVKxSkey1BUfoVRiy2K1TdLE+0NIf+F7cETK6HdXTZ8txIbVXVnzPOkplfMQGTqQGOnXz1o62Q0ViiGdftkJs/PrzlY
X-Gm-Message-State: AOJu0YyDnZ5Sy2YPmRqghQg7dEseoMAJBM83IMEGsq0VPiJmIKKCUHPk
	1a6/404Fg5HtC0Z0z0Qq6iEV7DjoFfDErDZIxr6KYI8bBfRriuup69NvICAJlDnKkkgZbP/8xSR
	u8g==
X-Google-Smtp-Source: AGHT+IF9gQW307iRIwllAMeb8K+vW4ZNtz0Vi4FocOSLvdeP6CfVMnng39hq/BWdmyR6gUO9iEtI2g5G7cY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:90:b0:2a6:dbca:b80f with SMTP id
 bb16-20020a17090b009000b002a6dbcab80fmr689pjb.0.1712868197645; Thu, 11 Apr
 2024 13:43:17 -0700 (PDT)
Date: Thu, 11 Apr 2024 13:43:16 -0700
In-Reply-To: <afb9faeb-11f4-47a2-a77b-4f2496182952@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-2-xiong.y.zhang@linux.intel.com> <ZhgYD4B1szpbvlHq@google.com>
 <56a98cae-36c5-40f8-8554-77f9d9c9a1b0@linux.intel.com> <CALMp9eRwsyBUHRtjKZDyU6i13hr5tif3ty7tpNjfs=Zq3RA8RA@mail.gmail.com>
 <Zhgh_vQYx2MCzma6@google.com> <afb9faeb-11f4-47a2-a77b-4f2496182952@linux.intel.com>
Message-ID: <ZhhLZFcNhTIidGRy@google.com>
Subject: Re: [RFC PATCH 01/41] perf: x86/intel: Support PERF_PMU_CAP_VPMU_PASSTHROUGH
From: Sean Christopherson <seanjc@google.com>
To: Kan Liang <kan.liang@linux.intel.com>
Cc: Jim Mattson <jmattson@google.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, 
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024, Kan Liang wrote:
> On 2024-04-11 1:46 p.m., Sean Christopherson wrote:
> > On Thu, Apr 11, 2024, Jim Mattson wrote:
> >> On Thu, Apr 11, 2024 at 10:21=E2=80=AFAM Liang, Kan <kan.liang@linux.i=
ntel.com> wrote:
> >>> On 2024-04-11 1:04 p.m., Sean Christopherson wrote:
> >>>> On Fri, Jan 26, 2024, Xiong Zhang wrote:
> >>>>> From: Kan Liang <kan.liang@linux.intel.com>
> >>>>>
> >>>>> Define and apply the PERF_PMU_CAP_VPMU_PASSTHROUGH flag for the ver=
sion 4
> >>>>> and later PMUs
> >>>>
> >>>> Why?  I get that is an RFC, but it's not at all obvious to me why th=
is needs to
> >>>> take a dependency on v4+.
> >>>
> >>> The IA32_PERF_GLOBAL_STATUS_RESET/SET MSRs are introduced in v4. They
> >>> are used in the save/restore of PMU state. Please see PATCH 23/41.
> >>> So it's limited to v4+ for now.
> >>
> >> Prior to version 4, semi-passthrough is possible, but IA32_PERF_GLOBAL=
_STATUS
> >> has to be intercepted and emulated, since it is non-trivial to set bit=
s in
> >> this MSR.
> >=20
> > Ah, then this _perf_ capability should be PERF_PMU_CAP_WRITABLE_GLOBAL_=
STATUS or
> > so, especially since it's introduced in advance of the KVM side of thin=
gs.  Then
> > whether or not to support a mediated PMU becomes a KVM decision, e.g. i=
ntercepting
> > accesses to IA32_PERF_GLOBAL_STATUS doesn't seem like a complete deal b=
reaker
> > (or maybe it is, I now see the comment about it being used to do the co=
ntext switch).
>=20
> The PERF_PMU_CAP_VPMU_PASSTHROUGH is to indicate whether the PMU has the
> capability to support passthrough mode. It's used to distinguish the
> other PMUs, e.g., uncore PMU.

Ah, the changelog blurb about SW/uncore PMUs finally clicked.

> Regarding the PERF_PMU_CAP_WRITABLE_GLOBAL_STATUS, I think perf already
> passes the x86_pmu.version to KVM. Maybe KVM can add an internal flag to
> track it, so a PERF_PMU_CAP_ bit can be saved?

Yeah, I think that's totally fine.  At some point, KVM is going to need to =
know
that GLOBAL_STATUS is writable if PMU.version >=3D 4, e.g. to correctly emu=
late
guest accesses, so I don't see any reason to bury that logic in perf.

> > And peeking ahead, IIUC perf effectively _forces_ a passthrough model w=
hen
> > has_vpmu_passthrough_cap() is true, which is wrong.  There needs to be =
a user/admin
> > opt-in (or opt-out) to that behavior, at a kernel/perf level, not just =
at a KVM
> > level.  Hmm, or is perf relying on KVM to do that right thing?  I.e. re=
lying on
> > KVM to do perf_guest_{enter,exit}() if and only if the PMU can support =
the
> > passthrough model.
> >
>=20
> Yes, perf relies on KVM to tell if a guest is entering the passthrough mo=
de.
>=20
> > If that's the case, most of the has_vpmu_passthrough_cap() checks are g=
ratiutous
> > and confusing, e.g. just WARN if KVM (or some other module) tries to tr=
igger a
> > PMU context switch when it's not supported by perf.
>=20
> If there is only non supported PMUs running in the host, perf wouldn't
> do any context switch. The guest can feel free to use the core PMU. We
> should not WARN for this case.

I'm struggling to wrap my head around this.  If there is no supported PMU i=
n the
host, how can there be a core PMU for the guest to use?  KVM virtualizes a =
PMU
if and only if kvm_init_pmu_capability() reports a compatible PMU, and IIUC=
 that
reporting is done based on the core PMU.

Specifically, I want to ensure we don't screw is passing through PMU MSR ac=
cess,
e.g. because KVM thinks perf will context switch those MSRs, but perf doesn=
't
because perf doesn't think the relevant PMU supports a mediate/passthrough =
mode.

