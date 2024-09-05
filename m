Return-Path: <kvm+bounces-25962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 210EA96DF68
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 18:20:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0E18284006
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 16:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D89E1A01B9;
	Thu,  5 Sep 2024 16:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EW38wY36"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB31F1A01B6
	for <kvm@vger.kernel.org>; Thu,  5 Sep 2024 16:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725553237; cv=none; b=ERgqTXuv3O9G6dBf+yq+wy2txi69gNlDKmdXaVGVy5vYdmMEV2R0Eo6cjGp+AKkUNVitmltOtqqj+9YbozJ8p9pB7gRvJMm1c5uzP2zJxd4yONkf8UIt1Rn7AN76AzfCBpd6yQokO4zxf4ZAp9CRFV5xjLmAA/rpfnKucdVBJ64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725553237; c=relaxed/simple;
	bh=n04gPQHvDkHClWZLlSJYgzA0AjqGslLWpNik4Jq1KMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5T2/0ae0my4MirENdEbCu9TXgGs2X8bLQWEt/05rRpDA19V550BDvGqli0rMCRikhkJ2mMhuQrcy1Z2iTqbJb2U06s87mG6/aXoyboOw7zWT4Eehpnn/G1l8scLYtUyesH4gz676bBIkoZFy989fg+EE2reug/YeARmnZB+fxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EW38wY36; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725553234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9TyHzQXM3uFT+3nz9MywkA1E5XwrT2IxpHMEhawq1JI=;
	b=EW38wY36wJ1UYHk3FdyRmaoSgE9fgd6Wd1DEASnRxe9dfbp1Xcj0Y5qgzbUiPZwdt/L43H
	QyZU6BC9TUVjBIzEdaKiQT/dF/tGupQXVwq+TOlnHph+LW9H7VKZUhRt5sLfarJFnoZDvp
	uMWnw6Vw1Fy97xy89NjDxhRBO2HvAcw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-15-W8ivkgECOSuplGP9zlYeWA-1; Thu,
 05 Sep 2024 12:20:32 -0400
X-MC-Unique: W8ivkgECOSuplGP9zlYeWA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5F77181E042;
	Thu,  5 Sep 2024 16:20:00 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E6A131956056;
	Thu,  5 Sep 2024 16:19:57 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	x86@kernel.org,
	Joel Fernandes <joel@joelfernandes.org>,
	Suleiman Souhlal <ssouhlal@freebsd.org>,
	Vineeth Pillai <vineeth@bitbyteword.org>,
	Borislav Petkov <bp@alien8.de>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC][PATCH] KVM: Remove HIGH_RES_TIMERS dependency
Date: Thu,  5 Sep 2024 12:19:27 -0400
Message-ID: <20240905161926.186090-2-pbonzini@redhat.com>
In-Reply-To: <20240821095127.45d17b19@gandalf.local.home>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

> Commit 92b5265d38f6a ("KVM: Depend on HIGH_RES_TIMERS") added a dependency
> to high resolution timers with the comment:
> 
>     KVM lapic timer and tsc deadline timer based on hrtimer,
>     setting a leftmost node to rb tree and then do hrtimer reprogram.
>     If hrtimer not configured as high resolution, hrtimer_enqueue_reprogram
>     do nothing and then make kvm lapic timer and tsc deadline timer fail.
> 
> That was back in 2012, where hrtimer_start_range_ns() would do the
> reprogramming with hrtimer_enqueue_reprogram(). But as that was a nop with
> high resolution timers disabled, this did not work. But a lot has changed
> in the last 12 years.
> 
> For example, commit 49a2a07514a3a ("hrtimer: Kick lowres dynticks targets on
> timer enqueue") modifies __hrtimer_start_range_ns() to work with low res
> timers. There's been lots of other changes that make low res work.
> 
> I added this change to my main server that runs all my VMs (my mail
> server, my web server, my ssh server) and disabled HIGH_RES_TIMERS and the
> system has been running just fine for over a month.
> 
> ChromeOS has tested this before as well, and it hasn't seen any issues with
> running KVM with high res timers disabled.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Queued, thanks.

Paolo



