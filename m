Return-Path: <kvm+bounces-47179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E76CDABE382
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 21:18:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9194B8A658A
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 19:18:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE23F28000C;
	Tue, 20 May 2025 19:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QVSFD4DN"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC61BA45;
	Tue, 20 May 2025 19:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747768701; cv=none; b=MhiCwXB/cph9OBz7e5/1KLJeQinob+s5Hroy5JheDQ/YqxTK8T+RftT4ZYxf3H24b6BOxdQfz+W0DUhF3qduqJbyCXHarJaDNaf2+VaImu40vy/ctFZMqnOgGG9NPFWeSrIdrEfy2XXXOQ/1xy4mKIMmdustG6X4SyG1T8u4LSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747768701; c=relaxed/simple;
	bh=oFaXc0gdTnPLTjT7AiGdHJhgJAW5FB0t4nB354tVFoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aCy0KYQb92aWSY8ZJ2O1hqX3I2XiV6e82XFpqnkUnSDwxglY1x/pdPjhbEKCWeAwEb4L6goaZ5PbEfYcZxHjcDogrKWGVgSi8R0IOa8tOdv5YEbfQN9coR18/y+JRRdIpC0gnQSLhPG5uHzH1u7Jw11D2cHEUaSUbq/JiaJP0kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QVSFD4DN; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=COSAydh429reoE4aNbcE1igiH3jcPkkYbLhSryVScJk=; b=QVSFD4DNGku4hxVzqgOTd7h1SA
	l940GeDOLM8U52ViwNfh1bhUSna+J+WxE0VfoFFVLJVNTsHGTq5K4fx0pBFEwPabOpcYB0Xq6xe09
	eO4C+WWflHoOEjOBYLUImVskrgLOI8y1OJrfbvg+0ap8qrV/kr6YTs6gu+PVQ0hdONEzQGLxlrGOW
	FTodT4PWuvOoTN1pe/BX1sQ9zOIDMnuKM5YRkVXMFCITxab1B6SOXT6S47cTzIDwOI4mzSGJHnJBr
	IcrE733soLpXYqAvTDHwC3mJIjMsGpKyp+nWjwuuw9bkwJpgBRVI0P1q0ug1Ufp8wF/bdGuN1j5kV
	JAABW/5w==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uHSTg-00000003kOT-2YEA;
	Tue, 20 May 2025 19:18:16 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 395B3300677; Tue, 20 May 2025 21:18:16 +0200 (CEST)
Date: Tue, 20 May 2025 21:18:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>,
	David Matlack <dmatlack@google.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Subject: Re: [PATCH v2 08/12] sched/wait: Drop WQ_FLAG_EXCLUSIVE from
 add_wait_queue_priority()
Message-ID: <20250520191816.GJ16434@noisy.programming.kicks-ass.net>
References: <20250519185514.2678456-1-seanjc@google.com>
 <20250519185514.2678456-9-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250519185514.2678456-9-seanjc@google.com>

On Mon, May 19, 2025 at 11:55:10AM -0700, Sean Christopherson wrote:
> Drop the setting of WQ_FLAG_EXCLUSIVE from add_wait_queue_priority() to
> differentiate it from add_wait_queue_priority_exclusive().  The one and
> only user add_wait_queue_priority(), Xen privcmd's irqfd_wakeup(),
> unconditionally returns '0', i.e. doesn't actually operate in exclusive
> mode.

I find:

drivers/hv/mshv_eventfd.c:      add_wait_queue_priority(wqh, &irqfd->irqfd_wait);
drivers/xen/privcmd.c:  add_wait_queue_priority(wqh, &kirqfd->wait);

I mean, it might still be true and all, but hyperv seems to also use
this now.

