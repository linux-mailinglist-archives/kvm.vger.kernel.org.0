Return-Path: <kvm+bounces-22127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FEE593A79B
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 21:13:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D39E91F232D3
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 19:13:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DFC4140384;
	Tue, 23 Jul 2024 19:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hZpIbGLy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF2513F439
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 19:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721761988; cv=none; b=LaIl7ht2J9eD9PBpP+E+K6fU2I/7BPwl/jT3ElL3/b8IhU77FFnW5TFuNdg6FsF//EvxgxSG4WMmvPkbXO0UcsEKxn32Hm6otegewEXmxAyDsn5OiQJNhXonGy9OfythnnnPLIWvhxzUHDbAmRwAq/LBCjn14C+7E9s+AYwBxlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721761988; c=relaxed/simple;
	bh=B8HOWhd85PkHC5Ntt/I5N3/zYDl44mtO565iRhg/if8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eyedW9AsbhSnsmmdiQgbQV5r5sTOO8Q8TO6Uz81HPTOV9PLQw5mj2n8m0/xc2AlD9PZ58KMjQo+KS8hSUV+hyoVixXQ+haBsyOfU5Nq9IQ2i2xBI0dIUeNJ8Pu2ST+E9V8HoOaqqIBIjaiqN3ZmMDl0pGN0sOO2HnYZRkHBsvfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hZpIbGLy; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70e956c9dacso419250b3a.2
        for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 12:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721761986; x=1722366786; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cj6s5l/prGyXQP/tqeXQtb4LQpnc68VJaJh8DQFKR7Y=;
        b=hZpIbGLyJWpSfiBiXzOFSS5dAUaHbDujBF3EG+YQC7mgTkW4eFluQu+zpQZ27nZaea
         Ul+NseVbyfvLPcQkhaM+BSJvP9nsjsE4Q5pnJsb+rYjH48yg14T9nwy26Ns/RATphQNN
         HFkKLnN1uQlEBj7jUAy25L2ZOPkvy2rImRAYnESDUBP7r5IzuQXY9QCI9blqkmYLvJ9x
         WFGG/ZflWqNzUf9Asz/5hk4xtTN9lLMqlmTas4RauO81Gu23brS2ykj5VQo8hAA5E/Fi
         suok2cj4EWMugN8QjU+tp7HxzdZAeHzbBxifZwDtK9lb92apFMZ3Bogb4ZJmxoip4yqs
         Urmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721761986; x=1722366786;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cj6s5l/prGyXQP/tqeXQtb4LQpnc68VJaJh8DQFKR7Y=;
        b=soK2MlMYGuH42xbSyIORaCiAtV11wmcs745Vr4FGXrXozNcvfHKXlQehNJvhv719v4
         Pt6/HGhWITC1SiFsteYqeg9Qqz8EHPrcQV4czUQy40iFRwAbQRm+fI7Xnt6eigQqrjk8
         GPi+OVRfWsqSizOjQAEuaAgRUQ1XtmrKQFpCe1sUj+2rhI7vDbg+8FOMep3V9rOMwKi0
         kLnmBk9ObLCFdw7qaHb/afkdFKKPhV7m/cnlANJycf+mP0hQr/lWJRTmJdxBzS+vRPvN
         BmnLSo8MGMBiWixdCjsWgonquT4cPmmgAnDuG1IBiYoWE5qbZuY7FUGZy3hdF1oGCLpA
         ZphQ==
X-Gm-Message-State: AOJu0YyX9N8HocYRKFT//lG23DHGYTyNeod0Ta6w4HEK/OMzeyOQ1Pxu
	km2z64cglUoJ/rJHqdFJVpC3c1l57GG41ZJIu5oP4/asPRIxlSXgI+I0NHYstt0KjuCxV5U++Sl
	EOA==
X-Google-Smtp-Source: AGHT+IEMzSXgKZmBR4WK8EtmJMi+U+rDKQhyFswWmKuDEraKWzqG8/Rm3+XvJlskDSICjG2piBRUffAzSaw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:230d:b0:70a:ffa2:bb14 with SMTP id
 d2e1a72fcca58-70d3a88f348mr212887b3a.2.1721761986022; Tue, 23 Jul 2024
 12:13:06 -0700 (PDT)
Date: Tue, 23 Jul 2024 12:13:04 -0700
In-Reply-To: <bug-219085-28872-QBm5HWk6wX@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-219085-28872@https.bugzilla.kernel.org/> <bug-219085-28872-QBm5HWk6wX@https.bugzilla.kernel.org/>
Message-ID: <ZqAAwP0Q_ZaMM9Ac@google.com>
Subject: Re: [Bug 219085] kvm_spurious_fault in L1 when running a nested kvm
 instance on AMD Opteron_G5_qemu L0
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 23, 2024, bugzilla-daemon@kernel.org wrote:
> I also saw a claim from Peter Maydell, qemu developer, who had said this about
> qemu command line parameter `-cpu _processor_type_`:
> > using a specific cpu type will only work with KVM if the host CPU really is
> > that exact CPU type, otherwise, use "-cpu host" or "-cpu max".

This generally isn't true.  KVM is very capable of running older vCPU models on
newer hardware.  What won't work (at least, not well) is cross-vendor virtualization,
i.e. advertising AMD on Intel and vice versa, but that's not what you're doing.

> > This is a restriction in the kernel's KVM handling, and not something that
> > can be worked around in the QEMU side.
> Per https://gitlab.com/qemu-project/qemu/-/issues/239
> 
> I was somewhat confused by this claim because 
> > --- Comment #1 from ununpta@mailto.plus ---
> > Command I used on L0 AMD Ryzen:
> > qemu-system-x86_64.exe -m 4096 -machine q35 -accel whpx -smp 1 -cpu
> > Opteron_G5
> 
> Let me ask you a few questions.
> Q1: Can one use an older cpu (but still supporting SVM), not the actual bare
> one in qemu command line for nested virtualization or KVM will crash due to
> restriction in the kernel's KVM handling?

Yes.  There might be caveats, but AFAIK, QEMU's predefined vCPU models should
always work.  If it doesn't work, and you have decent evidence that it's a KVM
problem, definitely feel free to file a KVM bug.

> Q2: Is there a command in bare Kernel/KVM console to figure out if EFER.SVME
> register/bit is writeable? If not,

grep -q svm /proc/cpuinfo

SVM can be disabled by firmware via MSR_VM_CR (0xc0010114) even if SVM is reported
in raw CPUID, but the kernel accounts for that and clears the "svm" flag from the
CPU data that's reported in /proc/cpuinfo.

> Q3: Can you recommend any package to figure out it?

Sorry, I don't follow this question.

