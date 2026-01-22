Return-Path: <kvm+bounces-68916-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OMw2JLdccmn5iwAAu9opvQ
	(envelope-from <kvm+bounces-68916-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:21:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FD206B231
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 18:21:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BB7E331473F8
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 17:10:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A38673859C2;
	Thu, 22 Jan 2026 16:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NxvW/Fz5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FB932D45C
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 16:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769100604; cv=none; b=VbB1ZVMzt5ZKPgaGBFzppySE4bDB6l9sukAa+WA98swNxXwFAkzlowca7PvgSF/6fTwFCm1My2uS3tM0g1I6+SeY8WQ4tvlvvEQuBYAjzDbREdpMPpYU0SyFTTEkm/8OMYZzMO6txTilxWDdT1MeDtxRQgHvUo/pqnRbsVGCJJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769100604; c=relaxed/simple;
	bh=w3tyOVuN8FQUsemqueqs7+KcZYp9hKV/p0FncAPIIMs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L/v0qmjqnDDDVe6I6qXNchm42h4W7Q9BlIEfaAkae2XFH3iwCh+658/0kHXlsb23e89TRnkyuAKSanbFWVWGF72Col1TbTKfRe7ZtJPwktaDuKNnBYrVap5reMW2DdDcY/j6Hvxi3O8dkJeRjH1xekbBK+VWOMQxbrk+3qf4FJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NxvW/Fz5; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34cc8bf226cso1377204a91.3
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 08:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769100593; x=1769705393; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BWFocFVTKOU7XXlm8Mgwvdw60IDe+g00em82J1zaTlc=;
        b=NxvW/Fz5eNMTIBrHtTudISubFlf9ClQ0hiLKefYQ3+s69HC12o3NBFmEPxzYR0ZY0Y
         31YDqv2iNd5rVtnzcq/0IxEVTnrkZcu1aXT/0+glS/g4HwPISM/84RGuVbtF/gSFzdEJ
         L5X2cRXPviwCxV4dA4tZZMnlYSYUx2c0OcZ2OByfvoye0NrbVB6iUcCqhF3/OegBTU22
         ja5HZDciQGZpQHalV08hlUPQ74WAf2FmlTaazJv5E2JuGGXxFyuHkZo6FRNCrDhzL00T
         hXsGNtOKyovIQStaY3uRT6NKvmQeaTCHFObElU+m/aEhBuVbPVDC4hO4dB7B9BXpYMeE
         6KsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769100593; x=1769705393;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BWFocFVTKOU7XXlm8Mgwvdw60IDe+g00em82J1zaTlc=;
        b=ACYu0zlmA+FP1Q2hHpnPff8W7dl33/nXRbI7FCkv9pRzaD//ytACt/85MKPdr9UUop
         awYCRz67Nuga9Vn+SrFSZs2IvwE5wO8fNxsbuTY4qwVMVsKKOvMG7SythjAqDjMNj/FF
         wppDEE/WooL5vLJ1pX9grkUiP3gapGDZxKyZa6+ZgaHre0zZ68QaeP39MSdo1ZR9ZiH3
         KUnfamYCbySH4IRT24P/U9aJVLXZU9QBpdtVLJr5/lS+GemG/WbrJTpPQHUFWpAGaYw5
         2Fy0dwVLX8tCMtg+B98yQ72hhmo4TbG2AS7AdHULX7QIQ7VWP+CWedNeq1EPAjvoqZ0u
         1bgQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9NRZMtBJ5AYHf/e9EQKjSxDlGab97PKDnZGDIBbqLVEkawtC2w0RSBDnS6JXaE4VyFGI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1rGXsxlEqZcFnqzXWUs/ca0wOyN0sBDQh7pbCRxeZPUaXjPhK
	LTj0fbRJkgu7uMhVk5PIL8CXLovHK/47GP8UBBUG5ycNrwEsDVGAGlb6jAnSVp931fKE16ysOny
	n3hcXnA==
X-Received: from pjbbg10.prod.google.com ([2002:a17:90b:d8a:b0:34c:1d76:2fe9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:582f:b0:343:e461:9022
 with SMTP id 98e67ed59e1d1-353688502bemr107887a91.24.1769100592593; Thu, 22
 Jan 2026 08:49:52 -0800 (PST)
Date: Thu, 22 Jan 2026 08:49:44 -0800
In-Reply-To: <20260121225438.3908422-4-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260121225438.3908422-1-jmattson@google.com> <20260121225438.3908422-4-jmattson@google.com>
Message-ID: <aXJVKFs54eVI1Mjo@google.com>
Subject: Re: [PATCH 3/6] KVM: x86/pmu: Track enabled AMD PMCs with Host-Only
 xor Guest-Only bits set
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68916-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6FD206B231
X-Rspamd-Action: no action

On Wed, Jan 21, 2026, Jim Mattson wrote:
> Add pmc_hostonly and pmc_guestonly bitmaps to struct kvm_pmu to track which
> guest-enabled performance counters have just one of the Host-Only and
> Guest-Only event selector bits set. PMCs that are disabled, have neither
> HG_ONLY bit set, or have both HG_ONLY bits set are not tracked, because
> they don't require special handling at vCPU state transitions.

Why bother with bitmaps?  The bitmaps are basically just eliding the checks in
amd_pmc_is_active() (my name), and those checks are super fast compared to
emulating transitions between L1 and L2.

Can't we simply do:

  void amd_pmu_refresh_host_guest_eventsels(struct kvm_vcpu *vcpu)
  {
	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
	struct kvm_pmc *pmc;
	int i;

	kvm_for_each_pmc(pmu, pmc, i, pmu->all_valid_pmc_idx)
		amd_pmu_set_eventsel_hw(pmc);

  }

And then call that helper on all transitions?

> +static void amd_pmu_update_hg_bitmaps(struct kvm_pmc *pmc)
> +{
> +	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> +	u64 eventsel = pmc->eventsel;
> +
> +	if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE)) {
> +		bitmap_clear(pmu->pmc_hostonly, pmc->idx, 1);
> +		bitmap_clear(pmu->pmc_guestonly, pmc->idx, 1);
> +		return;
> +	}
> +
> +	switch (eventsel & AMD64_EVENTSEL_HG_ONLY) {
> +	case AMD64_EVENTSEL_HOSTONLY:
> +		bitmap_set(pmu->pmc_hostonly, pmc->idx, 1);
> +		bitmap_clear(pmu->pmc_guestonly, pmc->idx, 1);
> +		break;
> +	case AMD64_EVENTSEL_GUESTONLY:
> +		bitmap_clear(pmu->pmc_hostonly, pmc->idx, 1);
> +		bitmap_set(pmu->pmc_guestonly, pmc->idx, 1);
> +		break;
> +	default:
> +		bitmap_clear(pmu->pmc_hostonly, pmc->idx, 1);
> +		bitmap_clear(pmu->pmc_guestonly, pmc->idx, 1);
> +		break;
> +	}
> +}
> +
>  static bool amd_pmu_dormant_hg_event(struct kvm_pmc *pmc)
>  {
>  	u64 hg_only = pmc->eventsel & AMD64_EVENTSEL_HG_ONLY;
> @@ -196,6 +223,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (data != pmc->eventsel) {
>  			pmc->eventsel = data;
>  			amd_pmu_set_eventsel_hw(pmc);
> +			amd_pmu_update_hg_bitmaps(pmc);

If we're going to bother adding amd_pmu_set_eventsel_hw(), and not reuse it as
suggested above, then it amd_pmu_set_eventsel_hw() should be renamed to just
amd_pmu_set_eventsel() and it should be the one configuring the bitmaps.  Because
KVM should never write to an eventsel without updating the bitmaps.  That would
also better capture the relationship between the bitmaps and eventsel_hw, e.g.

	pmc->eventsel_hw = (pmc->eventsel & ~AMD64_EVENTSEL_HOSTONLY) |
			   AMD64_EVENTSEL_GUESTONLY;

	if (!amd_pmc_is_active(pmc))
		pmc->eventsel_hw &= ~ARCH_PERFMON_EVENTSEL_ENABLE;

	/*
	 * Update the host/guest bitmaps used to reconfigure eventsel_hw on
	 * transitions to/from an L2 guest, so that KVM can quickly refresh
	 * the event selectors programmed into hardware, e.g. without having
	 * to 
	 */
	if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE)) {
		bitmap_clear(pmu->pmc_hostonly, pmc->idx, 1);
		bitmap_clear(pmu->pmc_guestonly, pmc->idx, 1);
		return;
	}

	switch (eventsel & AMD64_EVENTSEL_HG_ONLY) {
	case AMD64_EVENTSEL_HOSTONLY:
		bitmap_set(pmu->pmc_hostonly, pmc->idx, 1);
		bitmap_clear(pmu->pmc_guestonly, pmc->idx, 1);
		break;
	case AMD64_EVENTSEL_GUESTONLY:
		bitmap_clear(pmu->pmc_hostonly, pmc->idx, 1);
		bitmap_set(pmu->pmc_guestonly, pmc->idx, 1);
		break;
	default:
		bitmap_clear(pmu->pmc_hostonly, pmc->idx, 1);
		bitmap_clear(pmu->pmc_guestonly, pmc->idx, 1);
		break;
	}

But I still don't see any point in the bitmaps.

>  			kvm_pmu_request_counter_reprogram(pmc);
>  		}
>  		return 0;
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

