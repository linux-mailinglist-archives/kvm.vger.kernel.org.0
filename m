Return-Path: <kvm+bounces-41744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 214D6A6C9BD
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 11:46:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B6F51B6546B
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 10:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 191F81F8AC5;
	Sat, 22 Mar 2025 10:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lHBiBZqB"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC8A78F32
	for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 10:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742640351; cv=none; b=Y3+r0TwrvZ3gqz/O+l7px9Lfa53Y2Ds3iw50jEezywyEzhyHt+anTSCrwdhPRmwFwnNsj5FVbliWIeLgvjpSAH4a/Q9yQl1/yXD+MxtnLoruZ6NSP84Wi+o3ewEhvBi6SZhblBMxNqkT5IF3oWP1hYP6uk5oVp2oBxD6IpQYYac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742640351; c=relaxed/simple;
	bh=o5D+rT2VPefm8txaIZ0YjEdZ3Z3GdROylOtEWbEhIK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cz4Gv2/92spYOlaapx0Z2h8wHlE1pHncKTUAIvVkRJUdfqPOT054OgOtRDs+lQEUhN26v4TWsME7+SLn6psodPbr/QaRC+j/Yhl6BDcFFR4TyNO/1mYnSW7LgHS/mSebZedvbvFYmLlUGXCoHY4NZRilV1qIYtOwlSfqlOeuC/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lHBiBZqB; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 22 Mar 2025 11:45:43 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742640346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RlfTRkeU9h5jl+JeJKrx/nguPdFkJtm8wnXwGZBQusI=;
	b=lHBiBZqB6ApEGS3WDNaqTwoxP144b+LgwDKQuOEW7RpKx2Bhk90SHKv7ykuJjCpsA1BT07
	rb6so8cTeXWsoZWba3hxUbhg1Fw9+IK2BH53lRuPSF6Yc8zd/bWlHVlMSiRYMgdhAUnh3i
	88dZAgKgAT/cXIw5Mdsc6RhfQo+0eis=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Samuel Holland <samuel.holland@sifive.com>
Cc: kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 0/3] riscv: Improved bare metal support
Message-ID: <20250322-ccf99d17f15c37e1109d693e@orel>
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

Merged.

Thanks,
drew

