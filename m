Return-Path: <kvm+bounces-27175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3603C97C7D6
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 12:17:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67CAD1C24E34
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 10:17:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB3B19ABCB;
	Thu, 19 Sep 2024 10:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D6x6BKht"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B831991A0;
	Thu, 19 Sep 2024 10:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726741068; cv=none; b=jmo0Nd5xib/eU6Phj8xtg7WDbQbumr+qH0QmIVBOYEQXorAGU9FOkFoCwPyzms6tqFb2fLIS5l2VjFN3wjCNd3PJYWncOxiJGYerrya20ZwxGtVbXcNdLiK2WvXYA6JfCe5pc2LK8cv+k7Pqyfy/WdAp8jf2HyWtL95k3kcLHQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726741068; c=relaxed/simple;
	bh=JRE51gP5UxLcgAGuT2g5r97Z6STrbAowK6q6kqli0ZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F541x9B4/tsgYQy9e8MMwsz61uJQH1DC4QpYOHM5ewtz0AZejP2qUiPq4XOXOYLEXaRBKwXJzeroBt9rV/Lwe9P0ZbgtlRtdj5ZNhrunZT6+19RVGgvoS9xSAPwvaOT02fJx/74H3n0L0nWpXKh/fIoTOkHqZ2N5+zX5/Ej/56g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D6x6BKht; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 19 Sep 2024 03:17:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726741064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I1mckTS2FV38bbZ879rd+/BowKPTlDKekDspILq4S7U=;
	b=D6x6BKhtU1AsDKi/4KqvcONlUrTfddheLB6mjS/liWOZikXBBbl320OPz8mgGIKM4WllXD
	+wY9aYHdLlkmHh4egDXFCzDa+mmurZ3C2W/5Yn9b7oeoiOBTG25PlxVj4C73Kx3idnOFp+
	Vxq68Xs1nMkSJWGZkP3uhgfHcFJ6DPg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Will Deacon <will@kernel.org>, Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 0/5] Correct perf sampling with Guest VMs
Message-ID: <Zuv6QveQAHZ9H0HP@linux.dev>
References: <20240912205133.4171576-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240912205133.4171576-1-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Sep 12, 2024 at 08:51:28PM +0000, Colton Lewis wrote:
> v3:
>   * Clarify final commit message further
>   * Remove an unused variable in perf_arch_misc_flags()
> 
> v2:
> https://lore.kernel.org/kvm/20240911222433.3415301-1-coltonlewis@google.com/
> 
> v1:
> https://lore.kernel.org/kvm/20240904204133.1442132-1-coltonlewis@google.com/
> 
> This series cleans up perf recording around guest events and improves
> the accuracy of the resulting perf reports.

Please fix the intermediate build issue, and also test that each patch
in the series compiles. With that corrected, for the series:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

A nice follow-up on the arm64 side would be to further constrain
kvm_arch_pmi_in_guest() to return true iff we exited the guest due to an
IRQ.

-- 
Thanks,
Oliver

