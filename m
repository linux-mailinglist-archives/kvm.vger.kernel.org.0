Return-Path: <kvm+bounces-49391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2061AD83F6
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 09:19:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D86717E963
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 07:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949292C3269;
	Fri, 13 Jun 2025 07:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FE9BNqw8"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2372C3250;
	Fri, 13 Jun 2025 07:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749799133; cv=none; b=eOMZUOGWkxRFPhUyp4c3H1bpjcng8P8/mw9i80jVcVDxFd4i/FMiNhye7jWbLrl+PnEg6uTewldcGWcgr8y+Y2JthDrLVEgaO+pLF4w8EEGOa6ig3UwkNjUawOlsxEUBfP8Ddv5WKJ6V/rDsWnrLO/5+6QdNA7wUIpnCpPTfLws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749799133; c=relaxed/simple;
	bh=M7EkRO7IVX8UmYnG8NR5ldDY2OALH+ByUr7WbfjmLEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XfnkkXL5Vic/mjP/4N8Wf2CoEAyhwS7Qsv7Thc8bCvLoiVd+q9ba8ljhchfSK+OI5GXbQtyIxD1lZknxTGnsz/R+DqKlzfkH5sg9kMWAb/0Sxsd+jo6YTGOpVD23OB8SKUL+Qa7ljeIpJDANutZerUlV6JB44vaEEtztYlrnXd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FE9BNqw8; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=V7JkxG9Vy1kJOBwLEP7Ot+HWce3fGBM19nyA8Vb3JDQ=; b=FE9BNqw8CyaElbDtdH5KyL32Ph
	rBhR75TipRafHBAo5oPFRWkCMU5upIY+Ce9wsDDsnaWnYvlQBfg3j76zTksl8kPGJZuKqtzjXP0uM
	XfwyLE2MyQzGOi9cIcpkWOm9e8oSEfO0bSnLv3QEwKXMk160uGy648pUInVZ+Bq5tkIQDLZrticpk
	EVSjaNp/F54OcmmhLVW8exVmoMJxpJLs1fcKBV/QiFrwJdIKqkcryPHREmJxtqPcvoMHj6E+DleGn
	v1xfwtzc5hckcwlJ89HKleZlKgvHoco8F58tcRddx8+/Th4BGfWmuLzu6ygfR/1CupuMlECbTUD/9
	gI8My4pg==;
Received: from 2001-1c00-8d82-d000-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d82:d000:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uPygX-00000002tHy-2jwr;
	Fri, 13 Jun 2025 07:18:45 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 087FE30BC46; Fri, 13 Jun 2025 09:18:43 +0200 (CEST)
Date: Fri, 13 Jun 2025 09:18:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, brgerst@gmail.com, tony.luck@intel.com,
	fenghuay@nvidia.com
Subject: Re: [PATCH v1 0/3] x86/traps: Fix DR6/DR7 inintialization
Message-ID: <20250613071842.GH2273038@noisy.programming.kicks-ass.net>
References: <20250613070118.3694407-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613070118.3694407-1-xin@zytor.com>

On Fri, Jun 13, 2025 at 12:01:14AM -0700, Xin Li (Intel) wrote:
> Sohil reported seeing a split lock warning when running a test that
> generates userspace #DB:
> 
>   x86/split lock detection: #DB: sigtrap_loop_64/4614 took a bus_lock trap at address: 0x4011ae
> 
> 
> We investigated the issue and identified how the false bus lock detected
> warning is generated under certain test conditions:
> 
>   1) The warning is a false positive.
> 
>   2) It is not caused by the test itself.
> 
>   3) It occurs even when Bus Lock Detection (BLD) is disabled.
> 
>   4) It only happens on the first #DB on a CPU.
> 
> 
> And the root cause is, at boot time, Linux zeros DR6.  This leads to
> different DR6 values depending on whether the CPU supports BLD:
> 
>   1) On CPUs with BLD support, DR6 becomes 0xFFFF07F0 (bit 11, DR6.BLD,
>      is cleared).
> 
>   2) On CPUs without BLD, DR6 becomes 0xFFFF0FF0.
> 
> Since only BLD-induced #DB exceptions clear DR6.BLD and other debug
> exceptions leave it unchanged, even if the first #DB is unrelated to
> BLD, DR6.BLD is still cleared.  As a result, such a first #DB is
> misinterpreted as a BLD #DB, and a false warning is triggerred.
> 
> 
> Fix the bug by initializing DR6 by writing its architectural reset
> value at boot time.
> 
> 
> DR7 suffers from a similar issue.  We apply the same fix.

Bah, this DR6 polarity is a pain in the behind for sure. Patches look
good, except I'm really not a fan of using those 'names'. But I'll not
object too much of others like it.

