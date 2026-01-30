Return-Path: <kvm+bounces-69732-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AL9UBdDNfGlHOwIAu9opvQ
	(envelope-from <kvm+bounces-69732-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 16:27:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C1357BC032
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 16:27:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 207FE300D375
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 15:27:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B73637D12D;
	Fri, 30 Jan 2026 15:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EfBMc1L3"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E1E37C10B
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 15:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769786825; cv=none; b=sNNnI+xEV5JajsGnK02sNgjLm6i+vPHjlrDrZJN2++9qQufiaPNr6AyyGxKeRXHmXcZF20Xvm7WpQPz8bentLH6E7oXWpevJKwHV6pxNUXtqjqBPjogT+nyT65mfgakdrj8tfVki0qSOhU0RyyOQy8SHGFA16W+ivL+3EStNX1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769786825; c=relaxed/simple;
	bh=WKbgIjvqYsLnhI8lLynWC+gpwRwjqUOcqoGqHgkaXhE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aCGtpw6EoHMO/Rxas3M8lopEY0RH3ByOAYur4CApexojxcN6avjhgJSOyDeadRdrR41u714dr7spYxPyEqa5eYKwggLCFmod2Dg+jIjDOyl2KKICEI6WtAiQc0gT6BISguoEq4WomTPu718DhohvyIcVOUHsjExmYsyuEUjiX8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EfBMc1L3; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 30 Jan 2026 15:26:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769786808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jnluWOJvX1pbBkYtIrk0e2TYXTHoU6kY5S2rGU4X2jU=;
	b=EfBMc1L343Kx6i2tvM/2pzmneB0CHfg31wKiPXSm4XuiAJ51giqKIPr6B9H+r03eyfu2su
	QCsABahe3heQOdfXC3xJ3UY72b5VBj4BTVLmSFjWdWgz8xlOTMnye9D12Oqtc7wG9CTNxp
	fvlCwm7mEWVycugXwOh7zyKJ0fbFDVA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, mizhang@google.com, 
	sandipan.das@amd.com
Subject: Re: [PATCH v2 3/5] KVM: x86/pmu: Refresh Host-Only/Guest-Only
 eventsel at nested transitions
Message-ID: <zzgnirkreq5r57favstiuxuc66ep3npassqgcymntrttgttt3c@g4pi4l2bvi6q>
References: <20260129232835.3710773-1-jmattson@google.com>
 <20260129232835.3710773-4-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129232835.3710773-4-jmattson@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69732-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C1357BC032
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 03:28:08PM -0800, Jim Mattson wrote:
> Add amd_pmu_refresh_host_guest_eventsel_hw() to recalculate eventsel_hw for
> all PMCs based on the current vCPU state. This is needed because Host-Only
> and Guest-Only counters must be enabled/disabled at:
> 
>   - SVME changes: When EFER.SVME is modified, counters with Guest-Only bits
>     need their hardware enable state updated.
> 
>   - Nested transitions: When entering or leaving guest mode, Host-Only
>     counters should be disabled/enabled and Guest-Only counters should be
>     enabled/disabled accordingly.
> 
> Introduce svm_enter_guest_mode() and svm_leave_guest_mode() wrappers that
> call enter_guest_mode()/leave_guest_mode() followed by the PMU refresh,
> ensuring the PMU state stays synchronized with guest mode transitions.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/svm/nested.c |  6 +++---
>  arch/x86/kvm/svm/pmu.c    | 12 ++++++++++++
>  arch/x86/kvm/svm/svm.c    |  2 ++
>  arch/x86/kvm/svm/svm.h    | 17 +++++++++++++++++
>  4 files changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index de90b104a0dd..a7d1901f256b 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -757,7 +757,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	nested_svm_transition_tlb_flush(vcpu);
>  
>  	/* Enter Guest-Mode */
> -	enter_guest_mode(vcpu);
> +	svm_enter_guest_mode(vcpu);

FWIW, I think this name is a bit confusing because we also have
enter_svm_guest_mode(). So we end up with:

enter_svm_guest_mode() -> nested_vmcb02_prepare_control() ->
svm_enter_guest_mode() -> enter_guest_mode()

I actually have another proposed change [1] that moves
enter_guest_mode() directly into enter_svm_guest_mode(), so the sequence
would end up being:

enter_svm_guest_mode() -> svm_enter_guest_mode() -> enter_guest_mode()

[1] https://lore.kernel.org/kvm/20260115011312.3675857-9-yosry.ahmed@linux.dev/

