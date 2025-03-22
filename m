Return-Path: <kvm+bounces-41742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DBE2A6C899
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 10:19:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00ACA3BDE9F
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 09:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5465D1DED72;
	Sat, 22 Mar 2025 09:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ghU/WLTs"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536F1BA53
	for <kvm@vger.kernel.org>; Sat, 22 Mar 2025 09:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742635162; cv=none; b=np/BqO3/F+a1wMcNUDAWtahvKy/iikzWWCnaNCKJmD+sWShzL9XVmoZhHuQh23TBMQMPmQWMfbYNxqgqvI1NTBNYGEk8Ig3vyveXDih+/XBsTVMEYQImG9I+qNZuhxy9TRJGyBEylO34qKMvVyOEmrBpuA9snJpODsXh36cFaAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742635162; c=relaxed/simple;
	bh=uRdwJqeB4Fsuo8jF+ZHVQL5MJExsADgq8ORl9q5GvtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WVGAcRRMAMxwbekcrR3zadrddnYrzU9jFGxmgYWM2UvTf0vgXGuX4X7LfeE7wHQaN8F4XNySHl7TO8IajjlwLHLC8DSB8zbX/4Xo+Xsodajh4QKmRY2orKxJv9z6LDnBkih0UrIvmBDqg930/eOjjs7OiB/BjsgzbYGlrk/PVQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ghU/WLTs; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 22 Mar 2025 10:19:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742635158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uw0dDTpovXJjk5Ca5a4v7MZAZRkzIQMmg9Z/pXz0qd8=;
	b=ghU/WLTsl9Bl0gBgWPyn48IZ7qESvpTUEC0uWPN9LfxbLGt9AjbyoarMJwbihU2mauJi7c
	v23PZEFtyPMnTY73WfLR8daFVEmiGPklUUnYqvc28DefHPPVFfAceTQPuRA5Kj8Ht7YlZi
	izc6ldJ/cWeqnemXIFxmYtaE9C9ygGo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Samuel Holland <samuel.holland@sifive.com>
Cc: kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 0/3] riscv: Improved bare metal support
Message-ID: <20250322-d3217c83c59d16cd91984902@orel>
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

Added patch 4/3 to allow SBI DBCN to be used for the console and applied
to riscv/sbi

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/riscv/sbi

Thanks,
drew

