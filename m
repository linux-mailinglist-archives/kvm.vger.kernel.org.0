Return-Path: <kvm+bounces-13766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E96E89A752
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 00:32:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4AB222882CC
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 22:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 402CC1CF8F;
	Fri,  5 Apr 2024 22:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="izV5qTxe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FB51D52B
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 22:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712356346; cv=none; b=uqSdM49v6naskiP29thWN0y94gwr2J1Dt1h5iWtJCMVvS0D6PbT2n74cwviQC7H2BDtSO5EmYN5SlBtmpaJkWJB/eAvhem47uyUlQwJ/QuJjz4eFsqcN62tz0gUkOnyAGR//G5e4e4Pzy5ldai5iroG3l6NVKHODiCMxGZvArkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712356346; c=relaxed/simple;
	bh=u+ch+RGWkPu3TyqyImYpkrOBLWE805kb2f3BhFr+QLY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ES6YpKSABeqA6TAfPF0jnpiFxGfc1rh6Www9k/x9F73bt4JumfUQn7XgqT6J80jfh2ysr7T0pDBnpKC4dgl1tMZRaqdNCBetNyDs/RURgm+UzxT2PAHfmmMiW2KXXew+HV94W2EJexbm8wAErFzY08mG4aPm2Ue/43Z549jtc2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=izV5qTxe; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5d8bff2b792so1910244a12.1
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 15:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712356344; x=1712961144; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1bdd+f3Opz1TEvBD+52nqVl8X2cPb2yZoFEeq3J07O4=;
        b=izV5qTxea1pBT6CDRH8sVTeTLhdliBIKr5h+2JofdjF6cswxnDuRVFhgD4U4QwWrY0
         HtHk0yhm3cSJEK91jUPV2KlAY1wZU1naPvVtFv2vH9HuwqTtVTmPfjxBbFCoZXCf9oTb
         lrZXTTndgiqiUi+SMO8J/tF1xWqAHNFhgAyM9kHEo9ORUx0JH8uqFkMYaALHszeMO4eJ
         gUu6zgr5bP8WA9+9tn6Jqme+s5QVwecxZkqYFKIEg7v5kkTtGqhte7wqKMZNWSwMdh6U
         AYgBMeCeC7y8MFC/BRvoMN8sMqr6Blh3fb/fnfjTK2x7wsKWgYtJPph8MrqTFRgkYAqg
         158Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712356344; x=1712961144;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1bdd+f3Opz1TEvBD+52nqVl8X2cPb2yZoFEeq3J07O4=;
        b=VSMxeDvi4rATUyjjaBE23Pt9PjFLTU0K/f02Y2yNIELmAtmuYwU/YLYi76kgCK/gWO
         AXnQxnFrfwZzy68uVC5lO7L7sveEdEsBTF0u7sg+QXjFxmeENyIOl1J06nkLUI3juTUb
         FDNIC+ZDf4LI8gwjdrq4YyjwiZfukdjPJrjO/z9V+9jvUvV3K5qEj9BU8TGHMqceis75
         R24Oj9YlM1gH2BQXflZtaVX9WoQ40qJ7dUwgK14vvs0Py1lxwUTr6wAYdtmP8Eqt94FG
         5hc+sd2PUhr1hxC5pJ3n+aumZlzevI62n8fBT81Ss4Qn2ywdiBd306UhB/z1TbYmWPjq
         v80w==
X-Gm-Message-State: AOJu0YyoNIRlx32FbcxOnx2GhG9bsG7LnH5AwMvm00gQ/+XEurTYvOuI
	BiTdFWoVBRI4IuNWyvBloBMnHGaZVKMVw6lndUyohqOrEDE1D7k6jQVufgvu6u7tmu3Ko+qUk+v
	nCw==
X-Google-Smtp-Source: AGHT+IE8ODkDs+l28UchQFsn++eCooKhKNZ5K3IwDWhfWqy4pDIKM5hL88Sb9PX1fuKuJ20ayPMeSd4VNuQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1651:0:b0:5d8:af18:eee0 with SMTP id
 17-20020a631651000000b005d8af18eee0mr9943pgw.12.1712356344123; Fri, 05 Apr
 2024 15:32:24 -0700 (PDT)
Date: Fri, 5 Apr 2024 15:32:22 -0700
In-Reply-To: <bug-218684-28872@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-218684-28872@https.bugzilla.kernel.org/>
Message-ID: <ZhB79jBuwlRQykxV@google.com>
Subject: Re: [Bug 218684] New: CPU soft lockups in KVM VMs on kernel 6.x after
 switching hypervisor from C8S to C9S
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 05, 2024, bugzilla-daemon@kernel.org wrote:
> I'm currently in the middle of moving some of our hypervisors for upstream
> systemd CI from CentOS Stream 8 to CentOS Stream 9 (as the former will go EOL
> soon), and started hitting soft lockups on the guest machines (Arch Linux, both
> with "stock" kernel and mainline one).
> 
> The hypervisors are AWS EC2 C5n Metal instances [0] running CentOS Stream,
> which then run Arch Linux (KVM) VMs (using libvirt via Vagrant) - cpuinfo from
> one of the guests is at [1].
> 
> The "production" hypervisors currently run CentOS Stream 8 (kernel
> 4.18.0-548.el8.x86_64) and everything is fine. However, after trying to upgrade
> a couple of them to CentOS Stream 9 (kernel 5.14.0-432.el9.x86_64) the guests
> started exhibiting frequent soft lockups when running just the systemd unit
> test suite.

...

> [   75.796414] kernel: RIP: 0010:pv_native_safe_halt+0xf/0x20
v> [   75.796421] kernel: Code: 22 d7 c3 cc cc cc cc 0f 1f 40 00 90 90 90 90 90 90
> 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 23 db 24 00 fb f4 <c3>

...

> [   75.796447] kernel: Call Trace:
> [   75.796450] kernel:  <IRQ>
> [   75.800549] kernel:  ? watchdog_timer_fn+0x1dd/0x260
> [   75.800553] kernel:  ? __pfx_watchdog_timer_fn+0x10/0x10
> [   75.800556] kernel:  ? __hrtimer_run_queues+0x10f/0x2a0
> [   75.800560] kernel:  ? hrtimer_interrupt+0xfa/0x230
> [   75.800563] kernel:  ? __sysvec_apic_timer_interrupt+0x55/0x150
> [   75.800567] kernel:  ? sysvec_apic_timer_interrupt+0x6c/0x90
> [   75.800569] kernel:  </IRQ>
> [   75.800569] kernel:  <TASK>
> [   75.800571] kernel:  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
> [   75.800590] kernel:  ? pv_native_safe_halt+0xf/0x20
> [   75.800593] kernel:  default_idle+0x9/0x20
> [   75.800596] kernel:  default_idle_call+0x30/0x100
> [   75.800598] kernel:  do_idle+0x1cb/0x210
> [   75.800603] kernel:  cpu_startup_entry+0x29/0x30
> [   75.800606] kernel:  start_secondary+0x11c/0x140
> [   75.800610] kernel:  common_startup_64+0x13e/0x141
> [   75.800616] kernel:  </TASK>

Hmm, the vCPU is stuck in the idle HLT loop, which suggests that the vCPU isn't
waking up when it should.  But it does obviously get the hrtimer interrupt, so
it's not completely hosed.

Are you able to test custom kernels?  If so, bisecting the host kernel is likely
the easiest way to figure out what's going on.  It might not be the _fastest_,
but it should be straightforward, and shouldn't require much KVM expertise, i.e.
won't require lengthy back-and-forth discussions if no one immediately spots a
bug.

And before bisecting, it'd be worth seeing if an upstream host kernel has the
same problem, e.g. if upstream works, it might be easier/faster to bisect to a
fix, than to bisect to a bug.

