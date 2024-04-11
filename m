Return-Path: <kvm+bounces-14324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA9428A1F88
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:32:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6049C287847
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 19:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A9B91758D;
	Thu, 11 Apr 2024 19:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r+2tMixD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424EE205E34
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 19:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712863930; cv=none; b=WbSBtKnd2ew+anuiWFG8LazMZqALEU5sVNYL2iSGQYijycyfVgNRuOhXX7Nrg3Zuar5x4WnZFVOqMfg+137fiKNWVvaldBb84+GR9snNZxD2NlTtATAZxt7V4D+HrAvgPPz4fGrbwK+0st1pz364MMEJJBGRoPnB29A7YlNL7BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712863930; c=relaxed/simple;
	bh=1yU/kPa98UhjQAO/mISuRqsc8cngmTEg4cn2oa0bI98=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XrNJu3mVbWICJGGPPrqw3TiFKb/JSpGRhEsFw4VaBX/xcj6o9W0HeV2qcc4Whjgtpw+ATuK10QE9APUXhHva1hafCSJKECXhuovGFV2FExOIlKo+gYLaH0AXeTChr7UWnCxOZ9jbflvuYm9dCMQK51Dt18je0KzALyt71/V1vyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r+2tMixD; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5dbddee3694so94005a12.1
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 12:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712863928; x=1713468728; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JxiGI4jPhKPJt33E2rX2XkxPrGB9QhLEWHybdPq8HoY=;
        b=r+2tMixD3+3dsl4h3/gV3do6LlJqSfuLtNqIndf3hh6YxgLOXLgfm+urpVbm45TArc
         ATmJVuRNWXi9rdIF42ESF7IfjYXX0JhOQsw1LEj6h/NwRuRs6SPPKjHVixNCIl4rBNSy
         V/Mb1KXHF5Fn98Thit1ykSqY4/M/qNUu4IVL3P2YNbjKMkstCZPp5t2EpQDn89s109PC
         bkmHAbxFzmICTXVjFDlV37AsU9a9OwXzSC8LsJGz8uZ747Xg6Zlw7wLupPmgz6tpK0gM
         deTgLlg6dKuh+MWOk8BilrwOvRKcXlD0Nu1UGTbbIegFYvsHmX1o2PSz33SyvyjT8e5V
         KSXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712863928; x=1713468728;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JxiGI4jPhKPJt33E2rX2XkxPrGB9QhLEWHybdPq8HoY=;
        b=JY0WnVbMdYerUjW7wwRt7BhKJ2ZUqlrsiI6A+0KhpiwpZEYBnokHwurCjgWTEF+XXP
         Knw1BkuxI+dIg1KMarXIEze1vYX5g3Psew0Rw/1rV4g2DId51syB2+rzJbyVh8h7xloi
         Y1RkpgpN/FgcZjLAvyfOn821d84F92vXAk3hoWvfJElRegAIX8svaacoGRPO5lOd/Xd2
         PL/JtxmSNcqhRWfhEL4u1o7jxHITuhl0oNwFfWcIMpAPJEIpHrsy5TN5/NIlDhEL5pVv
         whFA1ZBZmSlIGy6S833VcYLGVeHTyeBC3/F1RiGUHqpk92b7Q46X3zTRCwEf1A186Mvh
         WwoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhfo+2VGBPin3pcjfoU9u6DOimBKYGOq+cs7+4icPj/ot1DUt++sfGHRPug9YRma7yu9O1OD5ojsntj1pjLy1NYRpf
X-Gm-Message-State: AOJu0Yxr75FK5/gO6811I9PUS4stvL37xKGFGKzsnr4bQ78spSlxohGt
	nlL0iSX5payPJkNdr4/2BQgdUcJGE3dJ5fYmkl5VpqW8thOff/7xy8AkwQ/q1uojMFghJidH1QR
	UqA==
X-Google-Smtp-Source: AGHT+IGTwogz395YcDpJ8vsW5oF/ZJs17z0JztTRaWHGTPCZjGfXEKc3xTuRKSaj6FoxAkqRPGfrkPX7DW4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:fc07:0:b0:5dc:4a5f:a5ee with SMTP id
 j7-20020a63fc07000000b005dc4a5fa5eemr19333pgi.1.1712863928433; Thu, 11 Apr
 2024 12:32:08 -0700 (PDT)
Date: Thu, 11 Apr 2024 12:32:06 -0700
In-Reply-To: <Zhgh_vQYx2MCzma6@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-2-xiong.y.zhang@linux.intel.com> <ZhgYD4B1szpbvlHq@google.com>
 <56a98cae-36c5-40f8-8554-77f9d9c9a1b0@linux.intel.com> <CALMp9eRwsyBUHRtjKZDyU6i13hr5tif3ty7tpNjfs=Zq3RA8RA@mail.gmail.com>
 <Zhgh_vQYx2MCzma6@google.com>
Message-ID: <Zhg6th5ye-LPynY3@google.com>
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

On Thu, Apr 11, 2024, Sean Christopherson wrote:
> On Thu, Apr 11, 2024, Jim Mattson wrote:
> > On Thu, Apr 11, 2024 at 10:21=E2=80=AFAM Liang, Kan <kan.liang@linux.in=
tel.com> wrote:
> > > On 2024-04-11 1:04 p.m., Sean Christopherson wrote:
> > > > On Fri, Jan 26, 2024, Xiong Zhang wrote:
> > > >> From: Kan Liang <kan.liang@linux.intel.com>
> > > >>
> > > >> Define and apply the PERF_PMU_CAP_VPMU_PASSTHROUGH flag for the ve=
rsion 4
> > > >> and later PMUs
> > > >
> > > > Why?  I get that is an RFC, but it's not at all obvious to me why t=
his needs to
> > > > take a dependency on v4+.
> > >
> > > The IA32_PERF_GLOBAL_STATUS_RESET/SET MSRs are introduced in v4. They
> > > are used in the save/restore of PMU state. Please see PATCH 23/41.
> > > So it's limited to v4+ for now.
> >=20
> > Prior to version 4, semi-passthrough is possible, but IA32_PERF_GLOBAL_=
STATUS
> > has to be intercepted and emulated, since it is non-trivial to set bits=
 in
> > this MSR.
>=20
> Ah, then this _perf_ capability should be PERF_PMU_CAP_WRITABLE_GLOBAL_ST=
ATUS or

And now I see that the capabilities are arch agnostic, whereas GLOBAL_STATU=
S
obviously is not.  Unless a writable GLOBAL_STATUS is a hard requirement fo=
r perf
to be able to support a mediated PMU, this capability probably doesn't need=
 to
exist, e.g. KVM can check for a writable GLOBAL_STATUS just as easily as pe=
rf
(or perf can stuff x86_pmu_capability.writable_global_status directly).

