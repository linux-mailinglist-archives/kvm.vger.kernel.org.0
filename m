Return-Path: <kvm+bounces-4360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94C96811A24
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 17:55:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C765B1C2118B
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 16:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18E7A3A8D6;
	Wed, 13 Dec 2023 16:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Up2f3CaO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368BCB9
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 08:54:43 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5c668b87db3so3257653a12.3
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 08:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702486482; x=1703091282; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1mqXVUUXhq8GSSeklyagPBq+6/Vyg1B2TQ7WR90xXs0=;
        b=Up2f3CaOylDa/e9SOnvC4R0bPtXZyWM7uMD6CxH5ppfs6J9flriqoASNGLYiCk1xIR
         6Lt5pX/UmSuJvErpwAelhjjXkQz0jrySDA/0rI2lJEwLvSC1sAHP+b3xIE/m6ix/HMOx
         ad5TBCrwzThz9YkrT2j5rM8U2V9SWfK71mWRErXTbbdPD58nsqp0rllVQxbOXAf43Hez
         zUzUqumuZUnahcn52EFtuJu7yMGRklarOEif1RL5QsjF/doRtkGxpN0+5+Djjg8QlEcq
         Rcec1APHkUqK5zjP18FkzIj+PjMDfdQByVwTxEA9WV/6jiqg7tOoWkaE4yaBvklurvvh
         JWnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702486482; x=1703091282;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1mqXVUUXhq8GSSeklyagPBq+6/Vyg1B2TQ7WR90xXs0=;
        b=TgA1u+CTkMWsFpuaBn/08xcHSEjR47rS1xCf/lNlSvPU7SBfRAjXAAEJjKD70Sz421
         SBZhtBXLbi6CZavqrCj3wymlHHoC1yT5VTGTgti6w6SCRwapR1Rlpr3bHjVEI8coKEB7
         pVpomu4yXGFS+m+Tp9oF5f/iRjX72IkCBzHziKwlQnu/4r4RKLPKFxluLTHb8J8kDlvL
         aKTzye4S6xmMZS4NRsWsHgFCgNMA44PT7sVHboCZ8o2uad+E/wEEXJC0VtEjaf4rLj9D
         sA/98Ko9gLarhwEFjnkUsbzTzA6LXhaAlgCwwC3/RSJbDtaQVVsQWuJvdLkf0R/fiUU2
         m0iw==
X-Gm-Message-State: AOJu0YxEZfkjR7uclmwXm2JhHVe4016E7riEMAzmEU7U0TK1ktHXdIg6
	jve1f/SaGi1DTAdlDDKocaXm7624yQc=
X-Google-Smtp-Source: AGHT+IFxfGi3MY4Pfqlo3XVWi3pqisgDpRH/VNcMIvcq9x/N9HPMQHA+T23aPslrmhqPhcofNEUcCX5q2C8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4744:0:b0:5ca:3509:b5f8 with SMTP id
 w4-20020a634744000000b005ca3509b5f8mr227662pgk.11.1702486482617; Wed, 13 Dec
 2023 08:54:42 -0800 (PST)
Date: Wed, 13 Dec 2023 08:54:40 -0800
In-Reply-To: <bug-218259-28872@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-218259-28872@https.bugzilla.kernel.org/>
Message-ID: <ZXng-hPIH8bav7iU@google.com>
Subject: Re: [Bug 218259] New: High latency in KVM guests
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 12, 2023, bugzilla-daemon@kernel.org wrote:
> The affected hosts run Debian 12; until Debian 11 there was no trouble.
> I git-bisected the kernel and the commit which appears to somehow cause the
> trouble is:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f47e5bbbc92f5d234bbab317523c64a65b6ac4e2

Huh.  That commit makes it so that KVM keeps non-leaf SPTEs, i.e. upper level page
table structures, when zapping/unmapping a guest memory range.  The idea is that
preserving paging structures will allow for faster unmapping (less work) and faster
repopulation if/when the guest faults the memory back in (again, less work to create
a valid mapping).

The only downside that comes to mind is that keeping upper level paging structures
will make it more costly to handle future invalidations as KVM will have to walk
deeper into the page tables before discovering more work that needs to be done.

> Qemu command line: See below.
> Problem does *not* go away when appending "kernel_irqchip=off" to the -machine
> parameter
> Problem *does* go away with "-accel tcg", even though the guest becomes much
> slower.

Yeah, that's expected, as that completely takes KVM out of the picture.

> All affected guests run kubernetes with various workloads, mostly Java,
> databases like postgres und a few legacy 32 bit containers.
> 
> Best method to manually trigger the problem I found was to drain other
> kubernetes nodes, causing many pods to start at the same time on the affected
> guest. But even when the initial load settled, there's little I/O and the
> guest is like 80% idle, the problem still occurs.
> 
> The problem occurs whether the host runs only a single guest or lots of other
> (non-kubernetes) guests.
> 
> Other (i.e. not kubernetes) guests don't appear to be affected, but those got
> way less resources and usually less load.

The affected flows are used only for handling mmu_notifier invalidations and for
edge cases related to non-coherent DMA.  I don't see any passthrough devices in
your setup, so that rules out the non-coherent DMA side of things.

A few things to try:

 1. Disable KSM (if enabled)

        echo 0 > /sys/kernel/mm/ksm/run

 2. Disable NUMA autobalancing (if enabled):

        echo 0 > /proc/sys/kernel/numa_balancing

 3. Disable KVM's TDP MMU.  On pre-v6.3 kernels, this can be done without having
    to reload KVM (or reboot the kernel if KVM is builtin).

        echo N > /sys/module/kvm/parameters/tdp_mmu

    On v6.3 and later kernels, tdp_mmu is a read-only module param and so needs
    to be disable when loading kvm.ko or when booting the kernel.

There are plenty more things that can be tried, but the above are relatively easy
and will hopefully narrow down the search significantly.

Oh, and one question: is your host kernel preemptible?

