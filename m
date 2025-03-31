Return-Path: <kvm+bounces-42251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A821A7642C
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 12:27:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3BD267A4D21
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 10:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321DA1E0E0C;
	Mon, 31 Mar 2025 10:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SNKRTAv+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8D51DF26A;
	Mon, 31 Mar 2025 10:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743416799; cv=none; b=J4TLaoF3L0UkFJPKmddp1G75c53k2RrVgKPRaspYzzhwUcJg/f+RQzzCvnjUasq43AGJ+Ahy9cLCSft4Ek/ezYXTRtNtDWYCQmApYMKrWDTznqKcyBJ0eQdL+mdp4V2huVNfNQ+Sm8MLW+widjVdexlbAN8XvvlqQTfq7cUgj+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743416799; c=relaxed/simple;
	bh=4YXZdHVM0TkXA+0kc8GIpKW5NQU7AZ4Je/lg8aqKF/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WWV1iVhFAJ2IW4yyT6mWt+uZS49rdqf9/WN8JSh1ieIDDA2uGVEg52iXXjMkCBqQGBeAXN0V8M0rZPC5IVU1cjTZcYfcQ6G+S5XQFxZeKyjcASeHuHEnlhQOwVD56gmD14sCX6R0OaI6NCzPlBaQeyeDM0IBiWbUP3rSGnjt3as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SNKRTAv+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C478CC4CEE5;
	Mon, 31 Mar 2025 10:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743416798;
	bh=4YXZdHVM0TkXA+0kc8GIpKW5NQU7AZ4Je/lg8aqKF/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SNKRTAv+gMnEVEwVPROIdVIANRJxm8LbYKcIVbFb3ADa4Tkur5F2mIuL95LZ7LZb1
	 5fqJ0aBp2v5cFupU9A4gdGZiDQ1FWpWF3RCKNziWJG18GDcV6Jku/oKEjoRuxnV9/n
	 tqlZBxLFrIHJZzvGETM/513c/sebuShZlti7+3NBoNv5JHNxaHW/38O4XPILpzN97I
	 97iuaFpjHX7UB0m+lxE7N2TRS5XllBFMdKrljOLOTYBow7YWoYoVOY+uLAOAiLaGN5
	 pBXF5L41ks0BVBoY1cpe8K/TydBaKSrGHdJwYFT4xSUwiCnyQTV/TVlvgKRxOXMEvV
	 AeHP4P5OJqZDg==
Date: Mon, 31 Mar 2025 12:26:21 +0200
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
Subject: Re: [RFC PATCH v1 02/15] x86/msr: Replace __rdmsr() with
 native_rdmsrl()
Message-ID: <Z-ptzZBePzh05HQI@gmail.com>
References: <20250331082251.3171276-1-xin@zytor.com>
 <20250331082251.3171276-3-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250331082251.3171276-3-xin@zytor.com>


* Xin Li (Intel) <xin@zytor.com> wrote:

> __rdmsr() is the lowest level primitive MSR read API, and its direct 
> use is NOT preferred.  Use its wrapper function native_rdmsrl() 
> instead.

This description is very misleading. As of today, native_rdmsrl() 
doesn't exist in-tree, so it cannot be 'preferred' in any fashion.

We have native_read_msr(), a confusingly similar function name, and 
this changelog doesn't make it clear, at all, why the extra 
native_rdmsrl() indirection is introduced.

Please split this into two changes and explain them properly:

 - x86/msr: Add the native_rdmsrl() helper
 - x86/msr: Convert __rdmsr() uses to native_rdmsrl() uses

For the first patch you should explain why you want an extra layer of 
indirection within these APIs and how it relates to native_read_msr() 
and why there is a _read_msr() and a _rdmsr() variant...

Thanks,

	Ingo

