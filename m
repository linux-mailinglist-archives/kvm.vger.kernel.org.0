Return-Path: <kvm+bounces-34040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45EF09F625C
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 11:06:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3ED147A278E
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 10:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B59B7198E75;
	Wed, 18 Dec 2024 10:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nSZEZQKF"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2319218858A
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 10:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734516398; cv=none; b=ETNwKwvpUS46tV6bIhTK3tTGeIAUh/AHxj8srbzaRGWeEG6o9R8yXqMvEOFZ838l2soCcbAn7BvOIvkp8lTYQ1CzCDGauXt4d/VnV8E4FInWwLpnjzvelOrz28e8/FqOYVQSxtzwzjlh3mqelY9bN999kzLU4YnFyPtCQuR/jMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734516398; c=relaxed/simple;
	bh=hfD3kmRyuax8xJLp8NqIP0Y5tuvXps7hbaBTkDRs9EQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WVodsuInKuncNLnwMrwxfU1Yq9CV8M8GsFl7OasgzPBAos2SmWjR6b6/R3Z5PGHFq5M76kke1znrszeAky3WsoR+kFTj2D1S9YVjS9iPggcU0EE/SjT5k1lGokdi88qu3VRP1vJKEYlFv7hwtNztu4vJh/NPbw7jshShFsiSbuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nSZEZQKF; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 18 Dec 2024 11:06:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734516394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KnngD40dQ35Z+gJ9lbSvH/eVndtQgjAc/aMCMSI2GSM=;
	b=nSZEZQKFCxGmXV5wZpAKWHxNIXNoyNAJ8uethmj9uCJ5tIP+QPDtzopsdOTnK7Z/PdHG25
	wtfaYOa5/DepHUi7CR7FgrLazCUrorMaVRf0GsQMP1+K9B8oPgWrDW6Yztk5ZcGkTFtA3t
	2Z9wKmRmloKOUDdgyitzd4Fo/VuAb/A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Samuel Holland <samuel.holland@sifive.com>
Cc: kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 0/3] riscv: Improved bare metal support
Message-ID: <20241218-c16216dff9f5c43bc76711b4@orel>
References: <20241210044442.91736-1-samuel.holland@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241210044442.91736-1-samuel.holland@sifive.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Dec 09, 2024 at 10:44:39PM -0600, Samuel Holland wrote:
> Here are a few patches which are just enough to run the SBI unit tests
> in a bare metal environment, under U-Boot on boards with a UART needing
> 32-bit MMIO (which is a rather common configuration in my experience).
> Though I wonder if we should prefer the SBI debug console extension for
> puts() output when available.

Hi Samuel,

Thanks for this! I think using SBI debug console is probably the best
choice. That's what I decided to do for booting on the bananapi. We
can keep the uart improvements though for a best effort fallback
when DBCN isn't available.

Thanks,
drew

> 
> Samuel Holland (3):
>   riscv: Add Image header to flat binaries
>   riscv: Rate limit UART output to avoid FIFO overflows
>   riscv: Support UARTs with different I/O widths
> 
>  lib/riscv/io.c | 47 +++++++++++++++++++++++++++++++++++++++++++++--
>  riscv/cstart.S | 16 +++++++++++++++-
>  2 files changed, 60 insertions(+), 3 deletions(-)
> 
> -- 
> 2.39.3 (Apple Git-146)
> 

