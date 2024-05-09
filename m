Return-Path: <kvm+bounces-17072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C56A08C0855
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 02:14:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 666E41F221C6
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 00:14:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB19910E5;
	Thu,  9 May 2024 00:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aUzA9T5L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5902010E4
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 00:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715213648; cv=none; b=TG4JsYacpXi0a/n9NhdRwRG9bwMZBYfCTkkpY2x7QppBhQNnCrdA8OwhK76ip5Ngsf/KEW5BHbmTP5lmrLJT7YkcI8bG087xaJ2ZuQ9lLfpF7dQcJBM3coJhyohGU+H+jdcRTCPIRWwGhdFvxZBkZ65BGnnDLgWsP/lTRWeuO+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715213648; c=relaxed/simple;
	bh=/KkMnRwuz+l55lhU9dM+hdqIe9xqwcIh9uTzOkJpltY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nDd1GqIA1CCphl04rIqCpzqFl7bYAWHpE2CYBDquP4s9/bzfCIsLgeSxCV4hWTPsMWGeXwZjIlnnghIT/GWsQO3ZqPhf5DwAofQYOkshiA8rxcJrFR6ahgwkc30o9gcpzOobnI/ml9Ks2N5UK+Ve2+CteIjKXzNRrF1AgRDafYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aUzA9T5L; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-51fdc9af005so374186e87.3
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 17:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715213645; x=1715818445; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bD6lUi8SG73xbLOFxo5AJaBVzp1RIH6Hedt4OaGzUw0=;
        b=aUzA9T5LA+uaSWxhsIP3gqpswL09jQw4M4fr3OprTEWtVtIXFecU4I5iTYOA6hlZfm
         UaelFKNlsw9+r2sNWy4HQdlg/bbGtx83ngdGUQhWlpqTTopPL3KGel8o7bNpv6+6og+T
         bcIovOf0CWi/PKumU7DY35je97SAmJlUX6o/ozOu8MPAUjsOe8+PQ7M/j/qybtIQ4hav
         OCoRDslOE1fQ6zWvs7NZCfCHgWrH3aoKx/6iOu37CHlyWqPe+gUrw2NgrrFM8gzeP/Aa
         t/1mKDKbH/8mOGO1AzVdz5TbxF4kq2WrdOj+BPCaBfuxHMTYBpWOqJNzdtkFsAL27G7+
         J6fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715213645; x=1715818445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bD6lUi8SG73xbLOFxo5AJaBVzp1RIH6Hedt4OaGzUw0=;
        b=vhvr+rlYfCdXPTo1nLi+YHb6zRpAy2ucr3vVUDDDKmT/mMqvoLjCOG2pX8vRcclAwn
         qIcI+8JtL+rZmbw+qE8qIZez5/DCaNYgirQ8mZUlX25l/rAwlGUm6auZePck55KAx2a8
         RCOPXhKBImJ3bNZFTcxyQpvsewqhol5YzHis7vA2KsGI2/qzcxLKKsHTkC7Kw6ch/ihb
         dcSf44o6vZ7LkeAqOKV98lQybS7XAigOnYMuEd4XxvAZ57IkhpvpMUgjXT2iDP2bVYJZ
         mlYGqhs2ACkVchMrEcmyI7ORP5zOw1nxOZzC0IDgyKNA9d2kYl4SwkK+QkxybcgeM+r6
         xQaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXONwRZFJG4WFIFgIhso+4l9ExgdTZXAJFPgrq+bJK5SX3tTB83lCyjgrgsOQBk/XR2q3/Rh7ovQEvZ22RBeTP6YpVu
X-Gm-Message-State: AOJu0YzotNCmgeG8UMAJ0AKOg/QujgdGAw+UI6oB9ky8pcYBl0NgnZ8t
	QAecvqJCL97vIrvdK767UHslSRyYUAbnZ6zAP4kZ1WWSqyX965M8k9fJgzmTU9nLH57NkrFsNAr
	SiSx/iwI1LhMEEvzbSMxS8YOVkQOsN20zbim0
X-Google-Smtp-Source: AGHT+IHxLy+/Yz3kCV2cQdiakGf5bXR4LBAPmGIUJilyj3ZlVYQPDqd4Ls6z46ei2t3Mp+gZ+KSnAY7jB9iVDLNK56Q=
X-Received: by 2002:ac2:52bc:0:b0:51a:f11c:81db with SMTP id
 2adb3069b0e04-5217c76046fmr3722169e87.30.1715213645409; Wed, 08 May 2024
 17:14:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com> <20240506053020.3911940-18-mizhang@google.com>
 <3eb01add-3776-46a8-87f7-54144692d7d7@linux.intel.com> <CAL715WL80ZOtAo2mT95_zW9Xhv-qOqnPjLGPMp1bJKZ1dOxhTg@mail.gmail.com>
 <fbb8306c-775b-4f00-a2a6-a0b17c8f038e@linux.intel.com> <ZjuIiDwbrWL7OD86@google.com>
In-Reply-To: <ZjuIiDwbrWL7OD86@google.com>
From: Mingwei Zhang <mizhang@google.com>
Date: Wed, 8 May 2024 17:13:28 -0700
Message-ID: <CAL715W+qV6D1WfTOMLv2ZgKZnJM-hDnBL-iiVr2m1_SK1rVpjA@mail.gmail.com>
Subject: Re: [PATCH v2 17/54] KVM: x86/pmu: Always set global enable bits in
 passthrough mode
To: Sean Christopherson <seanjc@google.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Stephane Eranian <eranian@google.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, maobibo <maobibo@loongson.cn>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 8, 2024 at 7:13=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, May 08, 2024, Dapeng Mi wrote:
> >
> > On 5/8/2024 12:36 PM, Mingwei Zhang wrote:
> > > if (pmu->passthrough && pmu->nr_arch_gp_counters)
> > >
> > > Since mediated passthrough PMU requires PerfMon v4 in Intel (PerfMon
> > > v2 in AMD), once it is enabled (pmu->passthrough =3D true), then glob=
al
> > > ctrl _must_ exist phyiscally. Regardless of whether we expose it to
> > > the guest VM, at reset time, we need to ensure enabling bits for GP
> > > counters are set (behind the screen). This is critical for AMD, since
> > > most of the guests are usually in (AMD) PerfMon v1 in which global
> > > ctrl MSR is inaccessible, but does exist and is operating in HW.
> > >
> > > Yes, if we eliminate that requirement (pmu->passthrough -> Perfmon v4
> > > Intel / Perfmon v2 AMD), then this code will have to change. However,
> > Yeah, that's what I'm worrying about. We ever discussed to support medi=
ated
> > vPMU on HW below perfmon v4. When someone implements this, he may not
> > notice this place needs to be changed as well, this introduces a potent=
ial
> > bug and we should avoid this.

I think you might have worried too much about future problems, but
yes, things are under the radar. For Intel, this version constraint
might be ok as Perfmon v4 is skylake, which is already pretty early.

For AMD, things are slightly different, PerfMon v2 in AMD requires
Genoa, which is pretty new. So, this problem probably could be
something for AMD if they want to extend the new vPMU design to Milan,
but we will see how people think. So one potential (easy) extension
for AMD is host PerfMon v1 + guest PerfMon v1 support for mediated
passthrough vPMU.

>
> Just add a WARN on the PMU version.  I haven't thought much about whether=
 or not
> KVM should support mediated PMU for earlier hardware, but having a sanity=
 check
> on the assumptions of this code is reasonable even if we don't _plan_ on =
supporting
> earlier hardware.

Sure. That sounds pretty reasonable.

Thanks.
-Mingwei

