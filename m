Return-Path: <kvm+bounces-9166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A9DE85B7A5
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 10:36:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9019284347
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E145860BA5;
	Tue, 20 Feb 2024 09:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="cCLwgIeV";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="OrKtuVM5"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58865FDAE;
	Tue, 20 Feb 2024 09:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708421750; cv=none; b=hbSqRxyxRlupRmR7xIHZwaQfe3sx8jjljpJtJZLTue5d2EMn6PdCq9QEO07xsgK0xvK3+R7WmDnq+w/fMgBscD6ivdzFmS36TZM1D06jeUuvj8d85iq/mVtFuqDC+YHeUdyPNb6VNIEisfzRcbkLQPP54vvzoBd/igtSDuq4umo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708421750; c=relaxed/simple;
	bh=KqF6uxKdacXplU8Vz1sWgc9oRiAGeMKimEFB9Pys8ZY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HhYrNMlpOKBXw7dqelZZ5ieglGhZxF1vZKnn+2sTvtayWzf9bPldKQJBdzCEnjbLql9h+f0UiOt5EbuzvLsItyMQvlNGzQncYjeGGsEai3pBVKD/kmXCFADpDow8ACF5REpTOt7luFMZzju2655EZgdov4pciDLvAQKkpbfZM/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=cCLwgIeV; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=OrKtuVM5; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1708421746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qMQgNxW/cq/W95W6944hYW0g2WX+zW1/CtYeKCgciio=;
	b=cCLwgIeVqk4CouvgCnTPalK72eB/TqNV+rcqZKi6Ty6+dSv9T3Y/NAgPG2522nRuY/tDEN
	Lf/1TIRYn7YE/IbOrGaA5JltxJnzsSfdcwCXhPDlxxjsBRKe1uqbFVGNpa3XIGPVbbOrrT
	gTSHZymZCXWEmI0fqbfMSbt1Clud/UllJflFtwc2RbZlq9wxsfiFi3pCDlDliXWpiXYPMs
	ygBf7TsBGhhk1YMmn/RZV0akQ6yS4c/JRA3IicgsaS3R1vpsQV5D7wmUv7LlJbhbPiYGaX
	TN6gflLlkdc611Xe6p8vEcSKk1dxclpf4+NikcliEABItbEktKtZH98KNvsWqg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1708421746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qMQgNxW/cq/W95W6944hYW0g2WX+zW1/CtYeKCgciio=;
	b=OrKtuVM5z5R2D1L6JMmFtnZECQzcxYfqQM8regq0BxlYfBaFai9vdE41U1mrkjSj3F6yV4
	OC6dgfeJgjmh0XCA==
To: Bitao Hu <yaoma@linux.alibaba.com>, dianders@chromium.org,
 pmladek@suse.com, akpm@linux-foundation.org, kernelfans@gmail.com,
 liusong@linux.alibaba.com, deller@gmx.de, npiggin@gmail.com,
 jan.kiszka@siemens.com, kbingham@kernel.org
Cc: linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, Bitao Hu <yaoma@linux.alibaba.com>
Subject: Re: [PATCHv8 2/2] watchdog/softlockup: report the most frequent
 interrupts
In-Reply-To: <20240219161920.15752-3-yaoma@linux.alibaba.com>
References: <20240219161920.15752-1-yaoma@linux.alibaba.com>
 <20240219161920.15752-3-yaoma@linux.alibaba.com>
Date: Tue, 20 Feb 2024 10:35:45 +0100
Message-ID: <87le7fiiku.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Feb 20 2024 at 00:19, Bitao Hu wrote:
>  arch/mips/dec/setup.c                |   2 +-
>  arch/parisc/kernel/smp.c             |   2 +-
>  arch/powerpc/kvm/book3s_hv_rm_xics.c |   2 +-
>  include/linux/irqdesc.h              |   9 ++-
>  include/linux/kernel_stat.h          |   4 +
>  kernel/irq/internals.h               |   2 +-
>  kernel/irq/irqdesc.c                 |  34 ++++++--
>  kernel/irq/proc.c                    |   9 +--

This really wants to be split into two patches. Interrupt infrastructure
first and then the actual usage site in the watchdog code.

Thanks,

        tglx

