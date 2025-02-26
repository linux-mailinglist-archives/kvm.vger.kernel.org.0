Return-Path: <kvm+bounces-39407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC97AA46CD9
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 22:00:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D46A7A57CA
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31512580EC;
	Wed, 26 Feb 2025 21:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zca5T0Bw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD9914D2BB
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 21:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740603635; cv=none; b=DJpQr50S1T9125EyACFBnFbUQG/0FYSuL+jh4L8OPVI5X1anosq2TmRpFjOFe55ofix8palU9MdvZAGKPUC3iN/0gcXKQMsLfFSrXsr9BVdIVq76XVAF6RONgC3FWQLb+Ix0fJ5n9L5cjK9eFbxsiDA3twPenV2aSCTVZcMMLvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740603635; c=relaxed/simple;
	bh=7SNSW21a/ek+7uv3YZtZF5knX4fa6jrBafX53dSSz5A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kKOqaZEsqX/qRSuCzRI1aGbXXWHcTFlP1HXmuRZfjS1fXWRCNOmqY+UIA1S4ooQ0/sddb/20nLDMb1VBbcRQIcPJszDT49CYBdIxj5LadGKaqABZQtj8TOtbbBuKZBY151eNBOw88qWv4ZsDm5N8lspNkivgiXcf/pewQYtqKUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zca5T0Bw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f83e54432dso764938a91.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 13:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740603633; x=1741208433; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7SNSW21a/ek+7uv3YZtZF5knX4fa6jrBafX53dSSz5A=;
        b=zca5T0BwK+ke4wRiImunYF0pMI6yAkZn5L/iSuBIwUaXv4GUUjgbsBI8tncRbNsVdR
         mivuDOph51kfVlqd1il2bnAs3qusAMHAbhMJwNBTSRVHsDUobn5s0Amn8WE9KaVZOzfT
         D4ABdh1bzy8nGT3EUHNgdSvJFOCfW5h9ACEy/8hJDrzzxhgyNVChBYjcd1vu3IhEdZg6
         27XQq0GGWNujWTetR4iX61PIYZ0vDlw8BAb+mxsmssyj8poAGxL6rJjd/FRoM4Tyf/Bf
         o5JI94/4cLbdIHN4jLzVrOznDsUzKoOdqdtn8Jm+F8MiiTCgdpVIEiY/JV+WXhXQHUz+
         CTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740603633; x=1741208433;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7SNSW21a/ek+7uv3YZtZF5knX4fa6jrBafX53dSSz5A=;
        b=Sw5+YCHfAv67JUBTndo/325kpe6JeKrEmvsm7RfyG2paaOd9+o84xTin/VNtXgUMhi
         RhXd0DuEJgPh5Wd5LaPfl9QACXZMzlv0L26VqM+9i3oL5irHwZQSRXdNZiVmoHa7z1BQ
         C/c/OhG11yNV3bVM+ooPj4QZ13sT2xnKPEO3HHkEn+5sfjiV9GrV1gZD+trK+Yxi/o2r
         XmZ2NQl+eFpxFk3H28SmugvfukqNeK1Ond/PxioHJu/mghTJ3E7xqULvZ4YdwoC90EFw
         oICa9AS5mbmeAtvZVIanBWi4FnWJSyVtrl/3DMWmIFUWGlfdX83hX7sGhcuv6sTBINBV
         5Tmg==
X-Forwarded-Encrypted: i=1; AJvYcCXAfzbphweh38TBhXwU/xDGBkWO50AnQwSqmNso5N2ScoxIRxJjX8pljgcQxdDv3BVISfQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YybDpGDnqgd+uROz9VudeFowtXrYbMOahgy2skubkZOwNlmh4Ub
	4+Qmet9/JPT5M0QdlfDPu3AL9U9wUanZMJjri215fitzCJGyo5FRLety6BhKIOCFG68wuBAlex7
	5nA==
X-Google-Smtp-Source: AGHT+IH7m6qi/77wBus+xiJc2WZWUUiZwJ67cH3PlD/10eBY4F6ImmSl6igipQU5wBdKgTZ4ndmuB6us57Q=
X-Received: from pjbdb16.prod.google.com ([2002:a17:90a:d650:b0:2fa:15aa:4d1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:540e:b0:2ee:d193:f3d5
 with SMTP id 98e67ed59e1d1-2fe7e2ed9e1mr8424364a91.7.1740603633142; Wed, 26
 Feb 2025 13:00:33 -0800 (PST)
Date: Wed, 26 Feb 2025 13:00:31 -0800
In-Reply-To: <e8cd99b4c4f93a581203449db9caee29b9751373.camel@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250218202618.567363-1-sieberf@amazon.com> <Z755r4S_7BLbHlWa@google.com>
 <e8cd99b4c4f93a581203449db9caee29b9751373.camel@amazon.com>
Message-ID: <Z7-A76KjcYB8HAP8@google.com>
Subject: Re: [RFC PATCH 0/3] kvm,sched: Add gtime halted
From: Sean Christopherson <seanjc@google.com>
To: Fernand Sieber <sieberf@amazon.com>
Cc: "x86@kernel.org" <x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 26, 2025, Fernand Sieber wrote:
> On Tue, 2025-02-25 at 18:17 -0800, Sean Christopherson wrote:
> > > In this RFC we introduce the concept of guest halted time to address
> > > these concerns. Guest halted time (gtime_halted) accounts for cycles
> > > spent in guest mode while the cpu is halted. gtime_halted relies on
> > > measuring the mperf msr register (x86) around VM enter/exits to compu=
te
> > > the number of unhalted cycles; halted cycles are then derived from th=
e
> > > tsc difference minus the mperf difference.
> >=20
> > IMO, there are better ways to solve this than having KVM sample MPERF o=
n
> > every entry and exit.
> >=20
> > The kernel already samples APERF/MPREF on every tick and provides that
> > information via /proc/cpuinfo, just use that.=C2=A0 If your userspace i=
s unable
> > to use /proc/cpuinfo or similar, that needs to be explained.
>=20
> If I understand correctly what you are suggesting is to have userspace
> regularly sampling these values to detect the most idle CPUs and then
> use CPU affinity to repin housekeeping tasks to these. While it's
> possible this essentially requires to implement another scheduling
> layer in userspace through constant re-pinning of tasks. This also
> requires to constantly identify the full set of tasks that can induce
> undesirable overhead so that they can be pinned accordingly. For these
> reasons we would rather want the logic to be implemented directly in
> the scheduler.
>=20
> > And if you're running vCPUs on tickless CPUs, and you're doing HLT/MWAI=
T
> > passthrough, *and* you want to schedule other tasks on those CPUs, then=
 IMO
> > you're abusing all of those things and it's not KVM's problem to solve,
> > especially now that sched_ext is a thing.
>=20
> We are running vCPUs with ticks, the rest of your observations are
> correct.

If there's a host tick, why do you need KVM's help to make scheduling decis=
ions?
It sounds like what you want is a scheduler that is primarily driven by MPE=
RF
(and APERF?), and sched_tick() =3D> arch_scale_freq_tick() already knows ab=
out MPERF.

