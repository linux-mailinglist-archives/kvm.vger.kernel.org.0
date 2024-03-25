Return-Path: <kvm+bounces-12592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA98888AA05
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:49:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6577834200E
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 16:49:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF63813C8E3;
	Mon, 25 Mar 2024 15:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="K/zf+7yE";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Uto49Jc5"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD04F5CDE7;
	Mon, 25 Mar 2024 15:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711379212; cv=none; b=qpChTm7ivPjC7XwelIS662MpAjqkgdV1CaJ/mPs9yEqKhbomQRyIWxP6NZO+sPklCJvcJV9PSsUoHtos2z1IfLHQ8W8clZukgMFZd8RIwqHts2I7LRpby5maBzUJBG+kmAH0ug9iUFqLl1/C9HhxUDWomIowCr1wBd3Dd3y9SxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711379212; c=relaxed/simple;
	bh=5BTm+AGtRn0RP7HkBKn2D2EUDTxHWeNLkYOLk56BiQI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ko9Ddc391Z09uL1gg1rjmfq542MGg7d+mkImJxyxk5nrPUgtkkjFNT2xO3GqdPaUR/Zb2VyFimU5Ft0eI7Sz0JolPc2joMHVvxLtJcqVftQvbvqvc/dQZ8+D8i5kyPA5oiM8mHOSCOy8JxzOvMzuVt3GIWsSZVgwZ74F44xfZew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=K/zf+7yE; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Uto49Jc5; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1711379202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UY2viGttd52QxBSAE5FTUmjPJkhh6vniD/bPyOg5248=;
	b=K/zf+7yEttbmmljaw/cQWo9WAyKD9MR79Gt9zl4U9jYzGLa+bxe0UpmzKnUUp3jKz9/Mpd
	dHTm8hc6jnBwM59WgNaWv7Mufdv8DRyEh7JgwhYw8JOKNg6jR5E41pZm6C0AbRkbuvltFF
	pDJ6Rq/LPDtJ6VkntoKm9XVySGq+qeiHHORJcrNg3/F0q1MyVqcdnRdeu1yFO8bKQA84sz
	yoQcdYiOmqLNlUoSGFK2GN+hQZBCYMfZyfJ7Q1B/0lcLJ9hDxegaSwlw4r3enAXkTNgUuY
	mNOYYCEdmPkner/XQjmcle5QEpNKAkTMhvn6v77X8GBX8Yu3vAVM9ee4Z3fBTg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1711379202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UY2viGttd52QxBSAE5FTUmjPJkhh6vniD/bPyOg5248=;
	b=Uto49Jc52SeDUanLBSWBcfzXubKk4aZAk6vJBB2cIRUYRwuQ36qNXfGvVvNphTCt1DMPO1
	Nzp+d7ahvuFMFyDg==
To: Nipun Gupta <nipun.gupta@amd.com>, alex.williamson@redhat.com,
 gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: maz@kernel.org, git@amd.com, harpreet.anand@amd.com,
 pieter.jansen-van-vuuren@amd.com, nikhil.agarwal@amd.com,
 michal.simek@amd.com, abhijit.gangurde@amd.com, srivatsa@csail.mit.edu,
 Nipun Gupta <nipun.gupta@amd.com>
Subject: Re: [PATCH v4 1/2] genirq/msi: add wrapper msi allocation API and
 export msi functions
In-Reply-To: <20240305043040.224127-1-nipun.gupta@amd.com>
References: <20240305043040.224127-1-nipun.gupta@amd.com>
Date: Mon, 25 Mar 2024 16:06:42 +0100
Message-ID: <87edbyfj0d.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Mar 05 2024 at 10:00, Nipun Gupta wrote:

  Subject: genirq/msi: Add MSI allocation helper and export MSI functions

> MSI functions can be for allocation and free can be directly
> used by the device drivers without any wrapper provided by
> bus drivers. So export these MSI functions.

s/can be for/for/ otherwise the sentence dos not make sense.

> Also, add a wrapper API to allocate MSIs providing only the
> number of IRQ's rather than range for simpler driver usage.

s/IRQ's/interrupts/ 

> Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>

Other than that:

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Alex, feel free to pick this up with the nitpicks resolved and route it
through your tree together with the VFIO driver.

Thanks,

        tglx

