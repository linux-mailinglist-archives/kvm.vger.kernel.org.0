Return-Path: <kvm+bounces-14305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC98C8A1E12
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:27:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FDEC288507
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:27:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E564413328E;
	Thu, 11 Apr 2024 17:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AsuAiIEO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A806513ADC
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 17:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712857602; cv=none; b=uyprFLvjbdbqS7mYg660H33mlGlHzpoX9C5EtCtP6HPneMWvLTqjAzotsjlPqxLZ4fr+oP7nXDLelmcUwWS7X99XLJT/UFtPX8jSwB+mY3mn3bMYTOA9HduxINyTkZgCaVKyIzpM4Y1QZRl6I2LSXsWzURizfZtY2tZzlAQHNzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712857602; c=relaxed/simple;
	bh=xbyOWt7gDT90PHA8CmXecHjCn5gE8CXNTbkKxi7f40k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dt8IxpAcNVwWx9pghTi4S/V9F64k7SNh+sxkfcQi9N9FzLMdIGnUEf1besbTK2X5B66URKglVM9mdlpGM1d/gB7IBa+J9wtsFecj0/PQfBJIUe/YXUbwJU5x2YD5udkKq5VJSU+LS2I9a6kqMTyiw2bmKqwCgxO7k4oWE6RA9sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AsuAiIEO; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6ece02cfbf2so130046b3a.2
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 10:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712857600; x=1713462400; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QDrKYmJhpcZaPcrJLV+DQJE+gAVulOU19ll4D+zrZcU=;
        b=AsuAiIEOBcqOkZgTtx9qI9zxnLQwYaBFz/RUkS11cHSftsrR8KTgJzXez5NGQyC9UO
         SL+hM0UoCUD3qoAj1L3xmFHtL02VwXjdeqEskE755+hCLORuubMqwl+Jf4NV9cxtHGiV
         Rx476Z23+VPcxYz/KqDWBmjQVdAooI3p+rPSXx+lV3Y/Gb7o09oKL81Ut8+3ur7v1Dmv
         B4y+AU/LfdBmR1jY9FIFV9CPuikuuFamtI/xDPIt7fe+pXBHnWFOEl38m+wEHY2v67qc
         FYj4CtWS9plSDhWjDK7aEhPG12WFKKDMAonc+EZ/mjCNXuJEF4/0QNhKioWxqqyTsoZX
         TeHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712857600; x=1713462400;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QDrKYmJhpcZaPcrJLV+DQJE+gAVulOU19ll4D+zrZcU=;
        b=PEOcQVBbFFTxcdxjbwhkOmbxGANkACGkssIHhygrSMcMpCS1stjREjtK51A2B3WFJf
         KcadTKodOc07DxxW2u/ry533q6q4vbs7e8v2K5m0ccghtHo3W+F+GhTTp6e8nwOntcF4
         Q8q6I1FmVFf8BIv4L4bRggd0UF1JWHWlotLm5zPI32x1F33SHLxbDNuNdtEuY8MlVBUW
         rQAT52n5XseT1kOuLGVkMwqa9JuKweVe2iK0dSo4KPWnmmsjS1JvbjjugE1xtNiOtgja
         JQVysbSHnoqHaUHxu86oEQnzJtiAwDcRGfRmxWWcD9HTTu6qcNmWnBZ1kkIh9iXtx4Ht
         q73A==
X-Forwarded-Encrypted: i=1; AJvYcCVwqv0Dk70wXT3rovaBlqGblzwpyyFedCik7z9N9Rwj/gZ6+PkZZi5k5ffdLY7pQdiUxJ0o/pwD2n+velbWXzMM6Edg
X-Gm-Message-State: AOJu0YzpaUJib1gncWjjgFBsobpNMXo3lJsZ1LjYDWhTpH7TudmieXdz
	C25b85ZIxkwFmx/f1bAWtNM8nET8vxC2fthl259SFKNy9jDhG+9a7+n0t7HkSxpjjzx4bS76C24
	doA==
X-Google-Smtp-Source: AGHT+IFtoDfp5GyRetAbjF6DB8NcAHAaD2IM+hfZ0pw6BN3Rb7rwJGuZMBNHwb9J9vPhlLGRfTE9N8azeiU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d87:b0:6ec:f406:ab4b with SMTP id
 fb7-20020a056a002d8700b006ecf406ab4bmr14703pfb.4.1712857599871; Thu, 11 Apr
 2024 10:46:39 -0700 (PDT)
Date: Thu, 11 Apr 2024 10:46:38 -0700
In-Reply-To: <CALMp9eRwsyBUHRtjKZDyU6i13hr5tif3ty7tpNjfs=Zq3RA8RA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-2-xiong.y.zhang@linux.intel.com> <ZhgYD4B1szpbvlHq@google.com>
 <56a98cae-36c5-40f8-8554-77f9d9c9a1b0@linux.intel.com> <CALMp9eRwsyBUHRtjKZDyU6i13hr5tif3ty7tpNjfs=Zq3RA8RA@mail.gmail.com>
Message-ID: <Zhgh_vQYx2MCzma6@google.com>
Subject: Re: [RFC PATCH 01/41] perf: x86/intel: Support PERF_PMU_CAP_VPMU_PASSTHROUGH
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Kan Liang <kan.liang@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, 
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 11, 2024, Jim Mattson wrote:
> On Thu, Apr 11, 2024 at 10:21=E2=80=AFAM Liang, Kan <kan.liang@linux.inte=
l.com> wrote:
> > On 2024-04-11 1:04 p.m., Sean Christopherson wrote:
> > > On Fri, Jan 26, 2024, Xiong Zhang wrote:
> > >> From: Kan Liang <kan.liang@linux.intel.com>
> > >>
> > >> Define and apply the PERF_PMU_CAP_VPMU_PASSTHROUGH flag for the vers=
ion 4
> > >> and later PMUs
> > >
> > > Why?  I get that is an RFC, but it's not at all obvious to me why thi=
s needs to
> > > take a dependency on v4+.
> >
> > The IA32_PERF_GLOBAL_STATUS_RESET/SET MSRs are introduced in v4. They
> > are used in the save/restore of PMU state. Please see PATCH 23/41.
> > So it's limited to v4+ for now.
>=20
> Prior to version 4, semi-passthrough is possible, but IA32_PERF_GLOBAL_ST=
ATUS
> has to be intercepted and emulated, since it is non-trivial to set bits i=
n
> this MSR.

Ah, then this _perf_ capability should be PERF_PMU_CAP_WRITABLE_GLOBAL_STAT=
US or
so, especially since it's introduced in advance of the KVM side of things. =
 Then
whether or not to support a mediated PMU becomes a KVM decision, e.g. inter=
cepting
accesses to IA32_PERF_GLOBAL_STATUS doesn't seem like a complete deal break=
er
(or maybe it is, I now see the comment about it being used to do the contex=
t switch).

And peeking ahead, IIUC perf effectively _forces_ a passthrough model when
has_vpmu_passthrough_cap() is true, which is wrong.  There needs to be a us=
er/admin
opt-in (or opt-out) to that behavior, at a kernel/perf level, not just at a=
 KVM
level.  Hmm, or is perf relying on KVM to do that right thing?  I.e. relyin=
g on
KVM to do perf_guest_{enter,exit}() if and only if the PMU can support the
passthrough model.

If that's the case, most of the has_vpmu_passthrough_cap() checks are grati=
utous
and confusing, e.g. just WARN if KVM (or some other module) tries to trigge=
r a
PMU context switch when it's not supported by perf.

