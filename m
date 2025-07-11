Return-Path: <kvm+bounces-52188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB981B022B0
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 19:38:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA02F17ABE5
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 17:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B94A2F0059;
	Fri, 11 Jul 2025 17:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mn46eXaz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C062D3754
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 17:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752255484; cv=none; b=TT4EsRdrhhDkZzXi3wimxklml2l4CFedB51qhX3YernR+RY9vihU9HHa/OzBCPy0ILFKhH/tHT/ANvSSuMDXPPOKMCQwXVfUyGUH01BkoNVV66LNqBFaQH5dHcJ5RdswVIoDE6+Fg6N4WTof+QG+l+4iQBWmTdt1vepxxxiiVDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752255484; c=relaxed/simple;
	bh=27qRB0esI060a4/jw1Adcpqa0B9pgnupwADBMBp8Ayg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=N0o8t0qUCFAhnvLQQZL8/gSEFxwccmodj1E0V5sW9hdiGTrT32Uyd2v9HXJln1rF/GeaWfcJBTu5EbMq8ysO2dcxJpLNC4oZEc9Dhk4SJiIngDhCKPzSiehGokWGuwhSDpYCVv0t7isuOgdyEsqyuOZcshPZIE378aS8aSjq8eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mn46eXaz; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-234a102faa3so17990725ad.0
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 10:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752255483; x=1752860283; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sbuIKyi+MfgvMKfyXYj7WNH0ie5ZWZEBBT5ECwepWTY=;
        b=mn46eXazLUgjmze51M2qudTezy4cV/vBMpkd9nLPCSReZK6hAKn1qd4TIjBaU26zo7
         fM5BbJYUU8Ewg1pJnx104cGyQyUhutyO+kTopkbb7SNuz6ksdqhF6g3Jih3m4b7Q0U2a
         bkBLBahSASGx7vT3kLz9gks3jdNFp6TvGkb0rAdeCGkbDi/3NppC7PXbNmxGZNcEP24B
         GArxpPgknkAg8et3G5/zuUm6862XCq5F8Ia/Cyr8VcUp9+ADIA68PoA74dR4r3LxHCuw
         9T747zzv8BxzbRzLHN0tlTct8WfN9Qjr4SyLuV0snLg/SGv4KllzaAJ3SawPyzakpGXR
         RYGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752255483; x=1752860283;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sbuIKyi+MfgvMKfyXYj7WNH0ie5ZWZEBBT5ECwepWTY=;
        b=rZR30RRHci1gGFYkvZ4u6tp/3AI0pFNjXrQajTqd8x4Ut0T3VtCi1K0tabF7usDUAi
         wa3hWoAGgfDcZhFX+r3I+n/febob1ubC0wpwZqKcemtWNTXr1CqPAPAk0tNgxQLh1MIh
         FqJUPTl6noSEsoV4DSSoNDJw4thjL4U4CVAlUBJk/rP91q6mH+0OPx7WppfLqp5T6Ddq
         tqhyrnJNVH6qI0v/ydWHrRI1Hw/e1DPiCK6e0IKtCKOcVSeqIcftPPk6RBFsGbscLoiI
         YkPo1fmeB9bAXjannK8tkoGJuRV0Jk0AQndwVuf/QGzz9IXluna8xYfq+XuMUo/i6h+6
         tvIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWq21RuCbmZr4sMHdNfLNXgRNZfMYmmuDGd7+w1vW1UNsGHCdo65pcgFyJlvZ2GealBAAQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoXk4qCBPU6kN7uCKT936pitbEQUiQVarQc3Hh8+TalXU7hWjz
	3curSYViPPHf68pt25aLz5SLFKNT8+XiASKuPRAusz0SV1w0ijCUtyEFuE2WIgqWa/TNrkZafqL
	sN57Q5A==
X-Google-Smtp-Source: AGHT+IHPZf2sNFkisUa9X3++bUjxOogTN/IzAXZHWztCupoH08hlXsip0gsryYc3EdrVWikP1DkEvsEbOgU=
X-Received: from pjtu13.prod.google.com ([2002:a17:90a:c88d:b0:312:1e70:e233])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:244a:b0:232:1daf:6f06
 with SMTP id d9443c01a7336-23dede94c3fmr61666755ad.47.1752255482578; Fri, 11
 Jul 2025 10:38:02 -0700 (PDT)
Date: Fri, 11 Jul 2025 10:38:01 -0700
In-Reply-To: <20250711172746.1579423-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250711172746.1579423-1-seanjc@google.com>
Message-ID: <aHFL-QjqG4hDVV4I@google.com>
Subject: Re: [PATCH] KVM: SVM: Emulate PERF_CNTR_GLOBAL_STATUS_SET for PerfMonV2
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 11, 2025, Sean Christopherson wrote:
> Emulate PERF_CNTR_GLOBAL_STATUS_SET when PerfMonV2 is enumerated to the
> guest, as the MSR is supposed to exist in all AMD v2 PMUs.
> 
> Fixes: 4a2771895ca6 ("KVM: x86/svm/pmu: Add AMD PerfMonV2 support")
> Cc: stable@vger.kernel.org
> Cc: Sandipan Das <sandipan.das@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

...

> @@ -711,6 +712,10 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (!msr_info->host_initiated)
>  			pmu->global_status &= ~data;
>  		break;
> +	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET:
> +		if (!msr_info->host_initiated)
> +			pmu->global_status |= data & ~pmu->global_status_rsvd;
> +		break;
>  	default:
>  		kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
>  		return kvm_pmu_call(set_msr)(vcpu, msr_info);

Tested with a hacky KUT test to verify I got the semantics correct.  I think I did?

  static void test_pmu_msrs(void)
  {
	const unsigned long long rsvd = GENMASK_ULL(63, 6);

	wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, -1ull);
	report(!rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS),
	       "Wanted '0', got 0x%" PRIx64, rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS));

	wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET, -1ull);
	report(rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS) == ~rsvd,
	       "Wanted '0x%llx', got 0x%" PRIx64,
	       ~rsvd, rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS));

	wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, -1ull);
	report(!rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS),
	       "Wanted '0', got 0x%" PRIx64, rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS));

	wrmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET, 0);
	report(!rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS),
	       "Wanted '0', got 0x%" PRIx64, rdmsr(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS));
  }

One oddity is that the test fails when run on the mediated PMU on Turin, i.e. when
the guest can write MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET directly.

  FAIL: Wanted '0x3f', got 0xc000000000000ff

Bits 59:58 failing is expected, because lack of KVM support for DebugCtl[FPCI]
and DebugCtl[FLBRI] doesn't remove them from hardware.  Disabling interception
of MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_SET creates a virtualization hole on that
front, but I don't know that it's worth closing.  Letting the guest manually
freeze its counters doesn't seem terribly interesting.

Bits 7:6 being set is _much_ more interesting, at least to me.  They're allegedly
reserved per the APM, and CPUID 0x80000022 says there are only 6 counters, so...

