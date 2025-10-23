Return-Path: <kvm+bounces-60874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB177BFFC61
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 10:06:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50BCD19A3717
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 08:07:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E515229B38;
	Thu, 23 Oct 2025 08:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VXF5hsmg"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B636F2EA726;
	Thu, 23 Oct 2025 08:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761206799; cv=none; b=IiKt5mttlc+prQ5Co2RprzC6hmOmT3SvoUzysyYATmBlUlFuoWZV5alPIzsLm41l7c3dabsb8DOrSNLagEsLmoQwou+Axt7TTM+9V9cAA1cKKWS62cW8BsQnJd07MLFQwwJqjgIt/6k89n4hxLgnopFm4x09A0ii0qyBD140pEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761206799; c=relaxed/simple;
	bh=yS2cNc2lSf1U32xQcS3l1qxWUN4/5v2Uv+icT2OgTBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oCmCGU7taxyqS1XVQorfUMclWMlMkkjdGIVa76XDv4YpImRHaZ0EZjZTkDi+vY6uth6M8kz+LSJCm9b/s0cHmACxFfJq5ClKogIW5w1vTmqMlrgpB9iyrFNMX1KjzxQxfKpuGMOX1U6CGWjG0Z3Z5F+5buP0PAY7Oz5QdEmK3kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VXF5hsmg; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=242WgqH1G7RN+Sb7WlH6cuKtkC+Sz9tXdy9IiSQ4nMw=; b=VXF5hsmgoKnX71LCCRK1VTH/qB
	5Iw74PJQ9MB0sUkYBc60AIA9ycHfGe0KzUbpgT0UoPTfh8pqAMhEHasMXSAyPbnh/FW1YHv/sDt91
	RagjJyW0JX7fj/kTWjKgbiMHpi0zuZyoV+HpTkHHDSWuSdMqj9DeZsG1rGZqlXJAcifb8YthNYkVS
	orFlbwvRwvDgsgkQ7WZfR185AgtE4GEQvxG/eiGK/yaH2HyXEEMsKOrTwZSIwjLfZxSyunzdUxplY
	g3wKEcMFfBFWGeDZodzpF1Le2p8iKXcUDLRd+6G+L3nUlJUAZ1sHkLtBA1GLhAJsR3nKa0mv3hL/Q
	eYjkpl3Q==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBpTR-00000001Aqd-05Md;
	Thu, 23 Oct 2025 07:11:01 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B9D0A300289; Thu, 23 Oct 2025 10:06:27 +0200 (CEST)
Date: Thu, 23 Oct 2025 10:06:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
	corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	luto@kernel.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
	hch@infradead.org
Subject: Re: [PATCH v8 05/21] x86/cea: Export API for per-CPU exception
 stacks for KVM
Message-ID: <20251023080627.GV3245006@noisy.programming.kicks-ass.net>
References: <20251014010950.1568389-1-xin@zytor.com>
 <20251014010950.1568389-6-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014010950.1568389-6-xin@zytor.com>

On Mon, Oct 13, 2025 at 06:09:34PM -0700, Xin Li (Intel) wrote:

> FRED introduced new fields in the host-state area of the VMCS for stack
> levels 1->3 (HOST_IA32_FRED_RSP[123]), each respectively corresponding to
> per-CPU exception stacks for #DB, NMI and #DF.  KVM must populate these
> fields each time a vCPU is loaded onto a CPU.

> +noinstr unsigned long __this_cpu_ist_top_va(enum exception_stack_ordering stack)
> +{
> +	return __this_cpu_ist_bottom_va(stack) + EXCEPTION_STKSZ;
> +}
> +EXPORT_SYMBOL(__this_cpu_ist_top_va);

This has no business being a !GPL export. But please use:

EXPORT_SYMBOL_FOR_MODULES(__this_cpu_ist_top_val, "kvm");

(or "kvm-intel", depending on which actual module ends up needing this
symbol).

