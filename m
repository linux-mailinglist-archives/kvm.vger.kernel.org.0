Return-Path: <kvm+bounces-42250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D26A76401
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 12:18:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A361169495
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 10:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C18421E0E0B;
	Mon, 31 Mar 2025 10:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N1su6Ole"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C768D17A2E2;
	Mon, 31 Mar 2025 10:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743416263; cv=none; b=eoujVJbWPGc9FDPrwDyKKuc6JS+Xetx59j611uvhKoroq+76o348E6pm0eQAGue5S6mLtv/A9woZhgrkz5ZmCmByLi+7qSo90pZQN7r/ezwJbhrOjsajPqRxOydE2yGBfKK7+ctzcptS5BzbKKHYj9d3qgG+xHOjeHVhULRb7zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743416263; c=relaxed/simple;
	bh=OnEcQ86N1b/nWwzloNbMBTvRyH+I2tQtz+Iwgl9ovf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aK3aFgHojCtVzcELId59Jyl7HUtlpN/G3L4HVZCR3MmOtzpGit415e+07D3Si5/yN0a2Rg1bSSg0mBf/VYY0NAyhmpQBZLDI+KIQbkGTMrs7p8e5j9bcIP5YHkOGwNfPeO6yc8QGMGYyDVBBpc1W3Zn9ES6ljLdAA5oBSXwtvY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N1su6Ole; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515D5C4CEE3;
	Mon, 31 Mar 2025 10:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743416262;
	bh=OnEcQ86N1b/nWwzloNbMBTvRyH+I2tQtz+Iwgl9ovf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N1su6OlesOh1iys2BALYaqexBKG7IcFqHgPaafBKTCbyQo6geGjhLQKz7O0OcoXvT
	 YQIpzmw1tQSWTsF9vwtzrlcdIcF7KcjPFAwykaVs903WQhoAu/+qZ7Ggeiwe7IRAvi
	 Y8aEbjENC3F1wRSXqHhXFrzi6g01c1oFTHI0YEi4v3pDcQrlIYk7ErbPRAXMN1Gvnt
	 gSg2xKJSTtBhyue1C7dnSzI120JEcG6dtEm9tY06MaoOdl/kTFn/fkjNUhbHm5WCdt
	 7HMZ5EnAV1JEKUK7IsVxDNhULSyJAaVCFvsuIggC5RwuFJb0eGVdW8LT9vTHsipJF2
	 GZDbcKOlstJLA==
Date: Mon, 31 Mar 2025 12:17:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
	linux-edac@vger.kernel.org, kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-ide@vger.kernel.org,
	linux-pm@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	jgross@suse.com, andrew.cooper3@citrix.com, peterz@infradead.org,
	acme@kernel.org, namhyung@kernel.org, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, wei.liu@kernel.org,
	ajay.kaher@broadcom.com, alexey.amakhalov@broadcom.com,
	bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
	pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
	luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
	haiyangz@microsoft.com, decui@microsoft.com
Subject: Re: [RFC PATCH v1 01/15] x86/msr: Replace __wrmsr() with
 native_wrmsrl()
Message-ID: <Z-pruogreCuU66wm@gmail.com>
References: <20250331082251.3171276-1-xin@zytor.com>
 <20250331082251.3171276-2-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250331082251.3171276-2-xin@zytor.com>


* Xin Li (Intel) <xin@zytor.com> wrote:

> -	__wrmsr      (MSR_AMD_DBG_EXTN_CFG, val | 3ULL << 3, val >> 32);
> +	native_wrmsrl(MSR_AMD_DBG_EXTN_CFG, val | 3ULL << 3);

This is an improvement.

> -	__wrmsr      (MSR_IA32_PQR_ASSOC, rmid_p, plr->closid);
> +	native_wrmsrl(MSR_IA32_PQR_ASSOC, (u64)plr->closid << 32 | rmid_p);

> -	__wrmsr      (MSR_IA32_PQR_ASSOC, rmid_p, closid_p);
> +	native_wrmsrl(MSR_IA32_PQR_ASSOC, (u64)closid_p << 32 | rmid_p);

This is not an improvement.

Please provide a native_wrmsrl() API variant where natural [rmid_p, closid_p]
high/lo parameters can be used, without the shift-uglification...

Thanks,

	Ingo

