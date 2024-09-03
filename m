Return-Path: <kvm+bounces-25739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D477969F3C
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:40:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E28FBB232B7
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 13:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FC359476;
	Tue,  3 Sep 2024 13:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TtXmcfk7"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF38EB647
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 13:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725370723; cv=none; b=JP0ysDSRUut9aHYYLzzkKkdvV79M6N/5kUDJ/+xBsgPxIr+qJqeuTyHzrvlM8VbDE4PxPVIGt9+gqJ5UBePqvCCZjUYkhyi3kTbaaFAWixUtH/fhYlqQ+3qdU/y1cy1dC+B0zfqZFSqvXjogb0zjkXjNC84b5lTODcuXoCiSXbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725370723; c=relaxed/simple;
	bh=+hc8nqYmw6Q0LhUvMkMolHWpEIbYUk9ZFKEIRxACelw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jB5XGq/d5mnP6RxwkGVM2CuCsJa/4MfbqAh98aM4IUfDg2eU4rYWyRVcRxwKfTMp1K1/mMe11cCH58w/vDmrlIJasQL/kAKThNYNjmAYIC66B+Q/s8S26mAjPiREeFz6xL02oE7wpOJTQEHZwy2CTazBGw0yt/MZHWIh7HheCSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TtXmcfk7; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 3 Sep 2024 15:38:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725370718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xmh6ypDCL/Kk05bhoJMovnM8ovwnhIrpAIfxzuZPOQI=;
	b=TtXmcfk78O3IBZfDrCvVcbw+d2vhfONXM6k0AE6+wDT+Qc2B29bEez1G/BZYZ7PgaWXK2w
	454L9JlTnwdSV6slkvd5GZ6seAYHojxZwjphT745doSKE7zD6zkkwMxUwc88kiNDPyGNnl
	yaSPRcnCYGGMYffMPVmtlljsQ4iLzH8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com, cade.richard@berkeley.edu, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH 0/3] riscv: Timer support
Message-ID: <20240903-078ba979dcef1f429b8c0a5c@orel>
References: <20240828162200.1384696-5-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828162200.1384696-5-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 28, 2024 at 06:22:01PM GMT, Andrew Jones wrote:
> We already have some timer / delay support but we leave a lot to
> the unit test authors for deciding what timer to use (SBI vs. Sstc)
> and setting it. Provide an API that prefers Sstc and falls back to
> SBI.
> 
> This found a bug in QEMU's Sstc that I'll try to find time to fix.
> If we start a timer with a long delay and then stop it before it has
> expired, QEMU still delivers the interrupt. The only way to avoid
> getting it on QEMU is to disable the timer irq. The BPI, which also
> has Sstc, behaves as expected though, i.e. even with the timer irq
> always enabled we won't get a timer irq if we stop it before it had
> a chance to expire. Disabling Sstc on QEMU, which falls back to SBI
> TIME, also behaves as expected.
> 
> Andrew Jones (3):
>   riscv: Introduce local_timer_init
>   riscv: Share sbi_time_ecall with framework
>   riscv: Provide timer_start and timer_stop
> 
>  lib/riscv/asm/sbi.h   |  1 +
>  lib/riscv/asm/timer.h |  3 +++
>  lib/riscv/sbi.c       |  5 +++++
>  lib/riscv/setup.c     |  2 ++
>  lib/riscv/smp.c       |  2 ++
>  lib/riscv/timer.c     | 46 +++++++++++++++++++++++++++++++++++++++++++
>  riscv/sbi.c           | 18 ++++-------------
>  7 files changed, 63 insertions(+), 14 deletions(-)
> 
> -- 
> 2.45.2
>

Queued on riscv/sbi, https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv%2Fsbi

