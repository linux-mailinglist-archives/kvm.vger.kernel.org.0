Return-Path: <kvm+bounces-67914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D1D6ED16EB8
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 07:56:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 927483035313
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 06:56:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 375BD369972;
	Tue, 13 Jan 2026 06:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lGNrts5O"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6831425F98B;
	Tue, 13 Jan 2026 06:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768287393; cv=none; b=gRT0IhGxykoFHdU2FrOTsAjOWFCAUT8EXu1nPM+CLGqYIETmrm7Y9ZF04zYvqkMlrlDiBuy9AHW7Owszi+OtLQ8nf3ha2w6HkCmsqM2FO6O8LvBiYh6oWllwkqJ2aPuLvW0U4T1bNZ4LHzkVDjvtCyzki+IsT2qTGHX1L4gXQLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768287393; c=relaxed/simple;
	bh=B5TuD3XfjPDj4HUep1TvfY2MvFwdAw7YS2657wMNiSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=snzaQneHLTRmy3Z9M3hF9Fcd5NdFZb7PUybChw850m3g4abq3U3PBaVJp/Py2MKdfGXalLxxarygJIKIbeand8XW4HV0SLgO1ns+lEWoUefbvBPAd/+oebmy8EhIOj+HoqoYyu6USoZdPIz+5TvQM3K57vh/LoQsIsnmfSn97xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lGNrts5O; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A50C116C6;
	Tue, 13 Jan 2026 06:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768287393;
	bh=B5TuD3XfjPDj4HUep1TvfY2MvFwdAw7YS2657wMNiSg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lGNrts5Oca/aw3q0q5G9mJdI79ntZnSFN2BEgu1O0ms5lYmLwwJ1YPIF6EEPklpgr
	 +QQ4skyvnbzmXZBmahvdwsqPKH3rNyzL5ZXy/cZIkrjxX/X+KO9w1Guwm1Of66iU72
	 O97Ftehsqk1saj9YHIGjyC9rUQ41F78egDvfrJsbtPoJM26zsxHw98M7bGffFWX/CA
	 PVTrJ3e0syJtu51Wd+9bLX0sh+2qqE0Rtrx0EHeNcwFL4xaTEvxP+RfG2fMIatb1st
	 IJ8L1u4eL2DtzrQhSUwXWuhgnaDmoNxrvgE7+PaHJvxYfcV/LVsWTLMo138SZvJ6lM
	 sq8Tg4Nhe5Trw==
Date: Tue, 13 Jan 2026 06:56:31 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-hyperv@vger.kernel.org, Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	xen-devel@lists.xenproject.org,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: Re: [PATCH v5 12/21] x86/paravirt: Move paravirt_sched_clock()
 related code into tsc.c
Message-ID: <20260113065631.GC3099059@liuwe-devbox-debian-v2.local>
References: <20260105110520.21356-1-jgross@suse.com>
 <20260105110520.21356-13-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105110520.21356-13-jgross@suse.com>

On Mon, Jan 05, 2026 at 12:05:11PM +0100, Juergen Gross wrote:
> The only user of paravirt_sched_clock() is in tsc.c, so move the code
> from paravirt.c and paravirt.h to tsc.c.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  arch/x86/include/asm/paravirt.h    | 12 ------------
>  arch/x86/include/asm/timer.h       |  1 +
>  arch/x86/kernel/kvmclock.c         |  1 +
>  arch/x86/kernel/paravirt.c         |  7 -------
>  arch/x86/kernel/tsc.c              | 10 +++++++++-
>  arch/x86/xen/time.c                |  1 +
>  drivers/clocksource/hyperv_timer.c |  2 ++

Acked-by: Wei Liu (Microsoft) <wei.liu@kernel.org>

