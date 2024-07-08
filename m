Return-Path: <kvm+bounces-21136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EAAA92AB87
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 23:56:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D025B1C2158E
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 21:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC0AA14F9EC;
	Mon,  8 Jul 2024 21:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I9zY5Q/C"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5AF14D28A;
	Mon,  8 Jul 2024 21:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720475774; cv=none; b=BlUSDwA9xDbBN6WoMzp8eFEMLs/qv1jxxYfcXA58pTTJpvpUu4TECK8BDc0Asc0/UA2TDK4o24LwS+LKZO1VyvYbrL31fEggmlZjQRvC+slEN/NCF7fstxm7I3UCsT2BnsoEs9RY/DqYXU2bGbrLxb6WE8uWIQiFvmF8UE6g+II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720475774; c=relaxed/simple;
	bh=1QzH7g1WSDOqhhrq9zntalcA82I0Sb3L1MfQnJw6QxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t/U5vORvhpoCCUarM5hS8l05yZggAALHURIGoywtMOw/LqiXqUiuaorPnxchqdVj4x7MoTnaPWmpC8YUfsIdMRC254GH6esML+xZW9L/8iPI1i+LGGxEyh3TVt+IMG0m4W/MZ41TW4bQ2zxTcqcvFfPKJ1t/X21UMcCSXyAE5yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=I9zY5Q/C; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WVdQYIbU5xrJg1EpR8Xx1KJhAgJ0SPfnuQLS9S9gRVA=; b=I9zY5Q/CqRSm03vJE1+Aduz81/
	lnVXZ9N30ysmzqxO9RLB+9mnwm1xI5xIYV++BceVBBb0L00DRdb2XTnGUCAZrHxZQ1bQImUehF39/
	Iqw5YqdySdB1L7U6xWKPnA6xKnhcg6c8JqHbTHHWgaEliJh5+/zYfnNF5Z9+EUdtNGyCpdXmij/rQ
	3rlIBqIG6ANm6cmnvm0MVmy/dzHumKmjtY3lBh/oDfX/hxTlpt3qsGAbMCOy0SGS7XZAHw3IRVUnJ
	g4ly5a39HJ5TPdm6Epyyn1bNVfAk89KNEd899qFeuEOF8rFIvbvArFnalBv3sbjcuxM9gg1lCckly
	T0KEE6PA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sQwLC-00000005950-1KsD;
	Mon, 08 Jul 2024 21:56:10 +0000
Date: Mon, 8 Jul 2024 14:56:10 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org, kdevops@lists.linux.dev,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: [Bug 218980] New: [VM boot] Guest Kernel hit BUG: kernel NULL
 pointer dereference, address: 0000000000000010 and WARNING: CPU: 0 PID: 218
 at arch/x86/kernel/fpu/core.c:57 x86_task_fpu+0x17/0x20
Message-ID: <ZoxgeulJHh-4i-Kh@bombadil.infradead.org>
References: <bug-218980-28872@https.bugzilla.kernel.org/>
 <ZoHaVmNbFGcejSjK@bombadil.infradead.org>
 <ZoHgnfJpBekFoCkF@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoHgnfJpBekFoCkF@bombadil.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Sun, Jun 30, 2024 at 03:47:57PM -0700, Luis Chamberlain wrote:
> On Sun, Jun 30, 2024 at 03:21:10PM -0700, Luis Chamberlain wrote:
> >   [   16.785424]  ? fpstate_free+0x5/0x30
> 
> Bisecting leads so far to next-20240619 as good and next-20240624 as bad.

Either way, this is now fixed on next-20240703.

  Luis

