Return-Path: <kvm+bounces-49687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7123DADC5A8
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 11:05:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AE02189759C
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 09:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 129EA290D8E;
	Tue, 17 Jun 2025 09:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hNNiWqPq"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B944D156CA;
	Tue, 17 Jun 2025 09:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750151145; cv=none; b=EAT4GA8uqfOdKzVJvmDDpe5ZvhVC46Jg8Mpw29f8pIZGBNF4L1jWS5sd/v8jjj77WARKPJE7czM31q74DQ26bRU2IHDOHP/2jYlqYhlprRJsSt5SWYr8bjXluNwDOlBG1Bj2B6uhi/aOymTueiIrkMD0LDvMRQHe4bCu2jSh3Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750151145; c=relaxed/simple;
	bh=8da1TRxkMgVAo0kmpRtI3ex4ZqRX5X/eG9gBp1o5rhg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rcztpYJks5SRmN/2WxKWkFAK0tUGUzBoNJ2LDKY7v0CCQ3buhUs8JAIARC6ZFBAyNcQTEPB4l6k1K0C5sLXPXFyxf/aMnYNrlv9iXDPUWN0yRvHeOmt5xfg2Z1CqA4WquVwfVvHjqC/G6AWeKT42fmaaBA9elkuFxs2vb0yaokQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hNNiWqPq; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=63j3fcj9UpKNOBC/DPSuCtE20LZ8w607u1fyl0JWS5k=; b=hNNiWqPqlHbflyg2Db0bM+m6cr
	IevFUk6QEShkDJ7hbvy0yy6DOBefnP9WRo7+BLd+gafesoQnLZevst6SBDryZcaohgEfMXtQjRbWh
	3RTU9Pw+xPopGz4G+4VTR7WLiSoRHvD65QgiMesDQi3KjqFsoGbDdfhGRQheJFro2/PuZlJ/5feNt
	qQCXj6zP0Z8e/pfZh8l3p7y0gduDLVgHApKdhuhsBuVqewZHF/aGbhXgsQ4qSWi2oQUjSES0H8SKp
	D0GhTR7Zmr4N0hC1Llmt9tTfOimzq0UoMXfSPh8mwHPRzAiZOUkX/lDdj6bp32t99uePMvjbgDDE3
	98ypmwYQ==;
Received: from 2001-1c00-8d82-d000-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d82:d000:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uRSG2-00000003kiW-26mK;
	Tue, 17 Jun 2025 09:05:30 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 77A45308523; Tue, 17 Jun 2025 11:05:28 +0200 (CEST)
Date: Tue, 17 Jun 2025 11:05:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, sohil.mehta@intel.com, brgerst@gmail.com,
	tony.luck@intel.com, fenghuay@nvidia.com
Subject: Re: [PATCH v2 0/2] x86/traps: Fix DR6/DR7 initialization
Message-ID: <20250617090528.GP1613376@noisy.programming.kicks-ass.net>
References: <20250617073234.1020644-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617073234.1020644-1-xin@zytor.com>

On Tue, Jun 17, 2025 at 12:32:32AM -0700, Xin Li (Intel) wrote:
> Xin Li (Intel) (2):
>   x86/traps: Initialize DR6 by writing its architectural reset value
>   x86/traps: Initialize DR7 by writing its architectural reset value
> 
>  arch/x86/include/asm/debugreg.h      | 14 ++++++++----
>  arch/x86/include/asm/kvm_host.h      |  2 +-
>  arch/x86/include/uapi/asm/debugreg.h |  7 +++++-
>  arch/x86/kernel/cpu/common.c         | 17 ++++++--------
>  arch/x86/kernel/kgdb.c               |  2 +-
>  arch/x86/kernel/process_32.c         |  2 +-
>  arch/x86/kernel/process_64.c         |  2 +-
>  arch/x86/kernel/traps.c              | 34 +++++++++++++++++-----------
>  arch/x86/kvm/x86.c                   |  4 ++--
>  9 files changed, 50 insertions(+), 34 deletions(-)

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

