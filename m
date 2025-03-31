Return-Path: <kvm+bounces-42265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9764A76F77
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 22:39:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8FEE3AAFDC
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 20:39:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577F521B9C4;
	Mon, 31 Mar 2025 20:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="F8o5RaNF"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58FC1E0E14;
	Mon, 31 Mar 2025 20:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743453556; cv=none; b=iSRV/IN6nQxHuPiGgGT4ppH0VZXPc5ZKRuGw6Or73XDnFdVA084HjKs7MFDuBM3TAjPhfoKmJkR0uxvInXbCfqoD4u/7pTFDUQJEXdNy1Jy0wsXWcSA8b2DtmmBqGNOVRHpmFpbmeqoxOE3g4op9jgug4qNoQNXuXy6ZmAlGaDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743453556; c=relaxed/simple;
	bh=zeVINXMb/01mGZrBfhpTJgMRXJBpTOtPkCDCxl2+D44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=llh28Rac8T1PmaYtI5kn9lbIp7ARAqI2TmNNpCzU5/Aesu2OlGWtueLfgCUPT7FKKVdZu1KnF5zXFmGTo2wItGPEqVIbZLOnR50M6RrCZh58SiGd0GoRHE94+TfpFMPZ1ayhUr9UBy+i7fjIu2iVzB3R2cPkenozbE0mV8S9y28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=F8o5RaNF; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8E35D40E0219;
	Mon, 31 Mar 2025 20:39:04 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id hCZ-tIlyS7we; Mon, 31 Mar 2025 20:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1743453540; bh=/G/aKVJEvh+BK78jU3R26aPND/GQH52x97woE6DFwhw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F8o5RaNF3wWAqRLnTqi/8tHi7xkMgpKiN8syntrCDDi2HsW0ZteAq1vHxftuVDtEM
	 cGldDTW3HAyOII383lFtqZ8kjPjJ4cSMMQfZiMs2i75K92ljQxK+B976L1H8wpzDw3
	 qBq06saJEtD83EHlZGDTbn2Zrkjdn/pwU8XSUo89HvNJ5HrM4jKMmVBY/vqWzOGZAs
	 YMW9m5mTnDMA2/H7Mc2kS6IohGQx9CIGf8UFDrLzc7i1zbdiFLx+LurM0lT0p+r++K
	 xEE/rCcJDi/j7xqbBgk5XLjKmFoXPTIY8xiaG6nY2M2HoVZUHdlffKXc5AXjOsjk3h
	 bXWm4T/N6Gzr7tBdHvVBTC9fABhXTGLNWEaMUMRerH2SrcucWBS7Q76YE/0gGMLqzP
	 CqnJj5s+MxEXI5KS+enCYMAbhBo+MWFpsW8Kykxy0tXn0BVbIXqfGDdwlFwzMacC8O
	 wk0mK5nC05VUHquiE5jhJgdoZX9HEiHuFW4xPMnCFYz2SfZ/QITV5Kj74oo3FyeTUi
	 lHFVgGPccdky6om9VHQjHwlCkorANK8owgOFCwgm7tlqdg27yNAxCe8hVJ6wqynD9T
	 GmKhQh3WsSnbfRxcHEl1wAa+FmSiCk8yZbj+eB5Ssk9ytAfGykALiBs591qReXfIrj
	 SZqE/RALHdS8Q8yfLauzWt/Q=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A5FD540E0215;
	Mon, 31 Mar 2025 20:38:17 +0000 (UTC)
Date: Mon, 31 Mar 2025 22:38:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "Xin Li (Intel)" <xin@zytor.com>, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
	virtualization@lists.linux.dev, linux-edac@vger.kernel.org,
	kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-ide@vger.kernel.org, linux-pm@vger.kernel.org,
	bpf@vger.kernel.org, llvm@lists.linux.dev, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, jgross@suse.com, andrew.cooper3@citrix.com,
	peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, wei.liu@kernel.org,
	ajay.kaher@broadcom.com, alexey.amakhalov@broadcom.com,
	bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
	pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
	luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
	haiyangz@microsoft.com, decui@microsoft.com
Subject: Re: [RFC PATCH v1 10/15] KVM: VMX: Use WRMSRNS or its immediate form
 when available
Message-ID: <20250331203811.GCZ-r9M9Zrww_b7IjJ@fat_crate.local>
References: <20250331082251.3171276-1-xin@zytor.com>
 <20250331082251.3171276-11-xin@zytor.com>
 <Z-r6qxmk7niRssee@char.us.oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z-r6qxmk7niRssee@char.us.oracle.com>

On Mon, Mar 31, 2025 at 04:27:23PM -0400, Konrad Rzeszutek Wilk wrote:
> Is that the right path forward?
> 
> That is replace the MSR write to disable speculative execution with a
> non-serialized WRMSR? Doesn't that mean the WRMSRNS is speculative?

Ha, interesting question.

If the WRMSR is non-serializing, when do speculative things like indirect
branches and the like get *actually* cleared and can such a speculation window
be used to leak branch data even if IBRS is actually enabled for example...

Fun.

This change needs to be run by hw folks and I guess until then WRMSRNS should
not get anywhere near mitigation MSRs like SPEC_CTRL or PRED_CMD...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

