Return-Path: <kvm+bounces-31484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C96CB9C4116
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 15:37:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 811C31F24188
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 14:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C0341A00E7;
	Mon, 11 Nov 2024 14:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZxhwRh14"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FF314EC55
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 14:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731335835; cv=none; b=TlOQFwi4VKEsIDlVFJrf7d6TnE/m6gKVDzVxDLLpRSmbKhDt61vY0ucRMNkocYLc+Sk4g7SML2atUoEbk7GRSllC6UrzjYEM9cdpupJvaIQYlzm0SSqu7dVTnAilrAlTf2BbpABVml4xWLDRxKdPBKjbaPxNSNylnZUf8NnHrJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731335835; c=relaxed/simple;
	bh=8ao0cCU3ilNsxhA6LuG1CMZaaFtXbQCXBdEdTzfN9ik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=grUOe2iFfFYuFXcoNZQzT5YttXjZfsEVZoGcbu4xY/wEnzrpQbC613cZR4Q3WT52YyArHn+c5Fp57aptVeEa0AkcPKTqwjlmi7MrmZoIM3H/On+yYMkXlaBZ/4RlwtP+kaZ+2TvmuQ95ZekAZs2Ju/XPabLPTOqebPsDyRG6U94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZxhwRh14; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 11 Nov 2024 15:37:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731335831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QyWjIB7TU79H2gnb1wFweilpij/gxuLrsbGqWRLNOiA=;
	b=ZxhwRh14ocY8H25STqe3IIsmRbF//xBG2MkAuzKBUa09SM0MtjJ5SBfDnfFlLLaNCVVE9m
	dDQJf9oAJjLts8AOVotYlnEmplyf1deoPn0SDZXHyoiEGlSkfKwCxZlC3oM2FcWs0fde2h
	6IGlqUATl/T0Y3Fn3evW9RrWJ+jXAtE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com, jamestiotio@gmail.com
Subject: Re: [kvm-unit-tests PATCH 0/4] riscv: A few SMP fixes
Message-ID: <20241111-11e36ccba55a58ab6328c12f@orel>
References: <20241023132130.118073-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023132130.118073-6-andrew.jones@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 23, 2024 at 03:21:31PM +0200, Andrew Jones wrote:
> tl;dr - these patches are improvement to the riscv framework to better
> support the SBI HSM tests.
> 
> The first patch is a simpler alternative to [1] and [2] which doesn't
> require us to decide how best to make the number configurable. The
> second patch just adds sanity checking to make sure we can expect the
> SBI implementation to accept all hartids mapped from the present mask.
> The third patch was already posted once before[3] with a slightly
> different summary. It and the last patch improve smp_boot_secondary()
> since the SBI HSM tests were attempting to make workarounds for odd
> behaviors.
> 
> [1] https://lore.kernel.org/all/20240820170150.377580-2-andrew.jones@linux.dev/
> [2] https://lore.kernel.org/all/20240903143946.834864-6-andrew.jones@linux.dev/
> [3] https://lore.kernel.org/all/20240904120812.1798715-2-andrew.jones@linux.dev/
> 
> Andrew Jones (4):
>   riscv: Bump NR_CPUS to 256
>   riscv: Filter unmanaged harts from present mask
>   riscv: Fix secondary_entry
>   riscv: Rework smp_boot_secondary
> 
>  lib/riscv/asm/processor.h |  1 +
>  lib/riscv/asm/setup.h     |  2 +-
>  lib/riscv/setup.c         | 11 ++++++---
>  lib/riscv/smp.c           | 49 +++++++++++++++++++++++++++------------
>  riscv/cstart.S            |  7 +++---
>  5 files changed, 48 insertions(+), 22 deletions(-)
> 
> -- 
> 2.47.0

Merged to master through riscv/queue.

Thanks,
drew

