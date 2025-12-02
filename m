Return-Path: <kvm+bounces-65097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07312C9B02A
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 11:00:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C17023A3FC9
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 10:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD96430E831;
	Tue,  2 Dec 2025 10:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="O2jNI5f1"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDF0309F01;
	Tue,  2 Dec 2025 10:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.28.197.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764669615; cv=none; b=ZUpmnO12qAjyaISzMcp0j3qzhqEa+xfViGO+/iBpPe8dXhnEy2zj4cOMnYtncqT9Xszp47Qv9ho3ptlZihtTuz2+QYn046oXikI+5rEOvKmgSUDkvzBg66h2h7TUoI2aLfRSx1W3uHkD6L4jDjT2LLChTGutxSomW5X99o1Nr6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764669615; c=relaxed/simple;
	bh=mrMxCvwHiLc5M4YFoOv3eeDE1wvnA569YYxkl2xFLHw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SS1J7u2rP3tcKyqbtfz5fMcuUk7K1erdMo6XEdcAsBrWizt7uKZBCtaUKuedT1hhsX/NKLoUEXDGpyiGgxVYI0z5gVdr9Tg3rwcXqhAgjqqx1BSiLevb5bgaQ4+dlhXKDStbGZRZJKv4iOsrUHY+bUSUPtNfPYFVlPTU+iIaHqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=O2jNI5f1; arc=none smtp.client-ip=52.28.197.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1764669614; x=1796205614;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mrMxCvwHiLc5M4YFoOv3eeDE1wvnA569YYxkl2xFLHw=;
  b=O2jNI5f1QjQJt7ROpwSMSAGiiOUq+BvA8NO9Bza76GNww4rjNtWXxgJO
   QUCTcC8EEI/JXY8fDNJz2XLvBxj/tIQZbSlVwY0prASsUC8Se1OnaQzUa
   w4fMioyxfwoyi/GrGtww1ZUQx3y7ptDt+f/nlD/foEC8dXe6nD+8IHwlj
   oqL5fwGXGavWjJ8qEMGLFbOBbwlcA5CP/jswdcDitcJl+sAuzSvcVW0nG
   QPKA30vjvxa71C99XO7aNjSCZiO3wCBhSjkrfv1I3p765kQeamWj4Iqd+
   n1bUVVvupV+81sEw8JuOLRGYtRo0SYPxh1UqZNDo9hYx7n//uw+/2p/pu
   g==;
X-CSE-ConnectionGUID: qYxM1I5MREOXQzbe1VP1vA==
X-CSE-MsgGUID: gmjCiSW4R2KWoNkQF2I72w==
X-IronPort-AV: E=Sophos;i="6.20,242,1758585600"; 
   d="scan'208";a="5992816"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 09:59:56 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:3241]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.31.35:2525] with esmtp (Farcaster)
 id eda82a29-4bd3-4a19-b2fb-c2fefee7d9bc; Tue, 2 Dec 2025 09:59:55 +0000 (UTC)
X-Farcaster-Flow-ID: eda82a29-4bd3-4a19-b2fb-c2fefee7d9bc
Received: from EX19D003EUB001.ant.amazon.com (10.252.51.97) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Tue, 2 Dec 2025 09:59:55 +0000
Received: from u5934974a1cdd59.ant.amazon.com (10.146.13.110) by
 EX19D003EUB001.ant.amazon.com (10.252.51.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Tue, 2 Dec 2025 09:59:46 +0000
From: Fernand Sieber <sieberf@amazon.com>
To: <peterz@infradead.org>
CC: <abusse@amazon.de>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<dwmw@amazon.co.uk>, <hborghor@amazon.de>, <hpa@zytor.com>,
	<jschoenh@amazon.de>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<mingo@redhat.com>, <nh-open-source@amazon.com>, <nsaenz@amazon.es>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <sieberf@amazon.com>,
	<stable@vger.kernel.org>, <tglx@linutronix.de>, <x86@kernel.org>
Subject: Re: [PATCH] KVM: x86/pmu: Do not accidentally create BTS events
Date: Tue, 2 Dec 2025 11:59:30 +0200
Message-ID: <20251202095930.166761-1-sieberf@amazon.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251202093534.GA2458571@noisy.programming.kicks-ass.net>
References: <20251202093534.GA2458571@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D040UWA003.ant.amazon.com (10.13.139.6) To
 EX19D003EUB001.ant.amazon.com (10.252.51.97)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Dec 02, 2025 at 10:35:34AM +0100, Peter Zijlstra wrote:
> On Mon, Dec 01, 2025 at 02:45:01PM +0000, Woodhouse, David wrote:
> > On Mon, 2025-12-01 at 16:23 +0200, Fernand Sieber wrote
> > > Perf considers the combination of PERF_COUNT_HW_BRANCH_INSTRUCTIONS with
> > > a sample_period of 1 a special case and handles this as a BTS event (see
> > > intel_pmu_has_bts_period()) -- a deviation from the usual semantic,
> > > where the sample_period represents the amount of branch instructions to
> > > encounter before the overflow handler is invoked.
> >
> > That's kind of awful, and seems to be the real underlying cause of the KVM
> > issue. Can we kill it with fire? Peter?
>
> Well, IIRC it gives the same information and was actually less expensive
> to run, seeing how BTS can buffer the data rather than having to take an
> interrupt on every event.
>
> But its been ages since this was done.
>
> Now arguably it should not be done for this kvm stuff, because the
> data-store buffers don't virtualize (just like old PEBS).

This. The current logic bypasses what the guest should actually be allowed
to do. See `vmx_get_supported_debugctl`, specifically the guest should not
be allowed to enable BTS.

Also semi related to this thread, but the auto enablement of BTS for
sample_period = 1 seems to yield undesirable behavior on the guest OS. The
guest OS will try to enable BTS and guest a wrmsr failure because the host
KVM rejects it, which leads to incorrect behavior (no tracing at all
happening).



Amazon Development Centre (South Africa) (Proprietary) Limited
29 Gogosoa Street, Observatory, Cape Town, Western Cape, 7925, South Africa
Registration Number: 2004 / 034463 / 07


