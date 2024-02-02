Return-Path: <kvm+bounces-7865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B195847606
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 18:24:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8818E1F25617
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 17:24:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8603F14A4E2;
	Fri,  2 Feb 2024 17:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dz87J7uG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BA613F001
	for <kvm@vger.kernel.org>; Fri,  2 Feb 2024 17:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706894657; cv=none; b=rwG2U46RnfdOOzkF7lRJSIut3tktMxoSKHquV089wa5dMfjRjzWB5BtXpdlhEtCI/kO9fFJ31HI7UKDWa2/8HnNAGfwHLJr7z4eI+M88h/1+g1tuQclzRomnRFzOkS9OIBa5MXVZF9P40BH87xJ5OBzkH1ij6m7LTHcSgQvnEMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706894657; c=relaxed/simple;
	bh=f4w3yfckQ6AIGjZw7uQb+qgVSH6aBp1dXcAlQ6VCmsU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dMWXM1FJ4NwwksZi3lXGlMTSJBUX1zw+cZyBKssLzjyUok9ivwFynXKqQSyk7NEacP1B34WVSa0YahmWwf8iZCAcqL5iOa91mhJyA3TLJafOxF4WzE5qMXi9xhmEWTjmIKWEPta/zrgX0Dg8vULF5cSNjbPz8AdcFVY4BaNg6uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dz87J7uG; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6040ffa60ddso45911917b3.2
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 09:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706894655; x=1707499455; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jh8tPI6zDKBJW5XNFKGiR3+xJf/t/qaa3P1NxbupNfc=;
        b=dz87J7uGkmnmxHC2AnQ3HtNip0UaCBr7GjH6znlI+p7a9KTR1/Wpc4yqszeMlVUMXy
         Wg/l+g/iYttu3F38uZJAqxsx4UHMeu8Tilan6pfa8yYUB5j2SUapdP4gzrWQI2nPcenr
         +NB5yzxv6sz17S5hrlrASkwhtXrl8v6PRPWhuBkF+vDzoHl54tkiQztiVIEeVZwO9fPb
         7C/FMVoeKM2DJZuwSXws/kwxMUdLrYIYHRshb9GKdXPAOXxuPRHi94a9IycFjBCmPQjp
         YGPuxcShR+RD2DlXDpx5POg2NJxbpzO6jfImbkZZiDozv0VeFNtRhQBg8SR24CGgJqyu
         46Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706894655; x=1707499455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jh8tPI6zDKBJW5XNFKGiR3+xJf/t/qaa3P1NxbupNfc=;
        b=SPjJjqLBQ9jle5Y25C02y1IB9wQRW/UtZUNVGPV/bp0oPS+KwHnDUVDHWHx6sJEFau
         AnviXtQ8qpJw+zeE+3MfD2WQNIWKrhaofi20GMlTCSGViwkS2ont4qGT8SZsIZizWzJI
         erGfhSiZNzmokZBv4sCiYly9qoBJriAkMFrt8mctlKX0lrcYeB5HAMmbHd1Z0l6oUSKf
         Nb+6Bd2HZCn5/7h9M/82ncdQiFTJjDnN81/vA+Rnk4QrFAvCdf7XdkIUOLEdG91+3t0q
         1icstKq0d5dlZhEAnhNkfL30Y3iUIcSoyD9KtPs7QfHkSo2pG/TYoMoSV/ZOFzWF+M7i
         tokg==
X-Gm-Message-State: AOJu0YwbagVgqnYqxdK/dyhQzb7KR4OVP+vrfDfxk+bg5CnIqPnhZmRa
	t8np8BrTiSnCTDrqeN46/A66YGFcfFHVp+MXlMlmDLH1dCYfu7nudmUVQozKr+eiLFMk7SgXGwL
	BoQ==
X-Google-Smtp-Source: AGHT+IFYznk7JpLxuRok8AtJlpZ2llmKQpQE42vIimTuUoL3PWXT0NTUQQ7owcgwAoNNjSDys4Q9Eh7vX8A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:200a:b0:dc2:3441:897f with SMTP id
 dh10-20020a056902200a00b00dc23441897fmr748244ybb.6.1706894655216; Fri, 02 Feb
 2024 09:24:15 -0800 (PST)
Date: Fri, 2 Feb 2024 09:24:13 -0800
In-Reply-To: <95c3dc22-2d40-46fc-bc4d-8206b002e0a1@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240201061505.2027804-1-dapeng1.mi@linux.intel.com>
 <Zbvcx0A-Ln2sP6XA@google.com> <95c3dc22-2d40-46fc-bc4d-8206b002e0a1@linux.intel.com>
Message-ID: <Zb0lPSBI_GFGuVex@google.com>
Subject: Re: [PATCH] KVM: selftests: Test top-down slots event
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Jim Mattson <jmattson@google.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 02, 2024, Dapeng Mi wrote:
> 
> On 2/2/2024 2:02 AM, Sean Christopherson wrote:
> > On Thu, Feb 01, 2024, Dapeng Mi wrote:
> > > Although the fixed counter 3 and the exclusive pseudo slots events is
> > > not supported by KVM yet, the architectural slots event is supported by
> > > KVM and can be programed on any GP counter. Thus add validation for this
> > > architectural slots event.
> > > 
> > > Top-down slots event "counts the total number of available slots for an
> > > unhalted logical processor, and increments by machine-width of the
> > > narrowest pipeline as employed by the Top-down Microarchitecture
> > > Analysis method." So suppose the measured count of slots event would be
> > > always larger than 0.
> > Please translate that into something non-perf folks can understand.  I know what
> > a pipeline slot is, and I know a dictionary's definition of "available" is, but I
> > still have no idea what this event actually counts.  In other words, I want a
> > precise definition of exactly what constitutes an "available slot", in verbiage
> > that anyone with basic understanding of x86 architectures can follow after reading
> > the whitepaper[*], which is helpful for understanding the concepts, but doesn't
> > crisply explain what this event counts.
> > 
> > Examples of when a slot is available vs. unavailable would be extremely helpful.
> > 
> > [*] https://www.intel.com/content/www/us/en/docs/vtune-profiler/cookbook/2023-0/top-down-microarchitecture-analysis-method.html
> 
> Yeah, indeed, 'slots' is not easily understood from its literal meaning. I
> also took some time to understand it when I look at this event for the first
> time. Simply speaking, slots is an abstract concept which indicates how many
> uops (decoded from instructions) can be processed simultaneously (per cycle)
> on HW. we assume there is a classic 5-stage pipeline, fetch, decode,
> execute, memory access and register writeback. In topdown
> micro-architectural analysis method, the former two stages (fetch/decode) is
> called front-end and the last three stages are called back-end.
> 
> In modern Intel processors, a complicated instruction could be decoded into
> several uops (micro-operations) and so these uops can be processed
> simultaneously and then improve the performance. Thus, assume a processor
> can decode and dispatch 4 uops in front-end and execute 4 uops in back-end
> simultaneously (per-cycle), so we would say this processor has 4 topdown
> slots per-cycle. If a slot is spare and can be used to process new uop, we
> say it's available, but if a slot is occupied by a uop for several cycles
> and not retired (maybe blocked by memory access), we say this slot is stall
> and unavailable.

In that case, can't the test assert that the count is at least NUM_INSNS_RETIRED?
AFAIK, none of the sequences in the measured code can be fused, i.e. the test can
assert that every instruction requires at least one uop, and IIUC, actually
executing a uop requires an available slot at _some_ time.

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index ae5f6042f1e8..29609b52f8fa 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -119,6 +119,9 @@ static void guest_assert_event_count(uint8_t idx,
        case INTEL_ARCH_REFERENCE_CYCLES_INDEX:
                GUEST_ASSERT_NE(count, 0);
                break;
+       case INTEL_ARCH_TOPDOWN_SLOTS_INDEX:
+               GUEST_ASSERT(count >= NUM_INSNS_RETIRED);
+               break;
        default:
                break;
        }

