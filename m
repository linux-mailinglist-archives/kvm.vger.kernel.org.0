Return-Path: <kvm+bounces-41843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 05296A6E148
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 18:44:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAC7B1737D8
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 17:42:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5086269AF3;
	Mon, 24 Mar 2025 17:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TrORQrF+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D687326A0AE
	for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 17:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742837620; cv=none; b=QQaYS6pzrLLTzc0KESYOi0Xkg3EYqpdF0amknc6L2IdjM0eAQY9rMk0ANTElSQo3FCSEBCGFHAZnddtf9q7elemXtU+FrzIOdIAW84so3Sz5GKh0NfcDL63gDiKFNx2a5tsqkSSNzvwnInaU+CmokX/s77lGXEZjZNW1oOKMIKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742837620; c=relaxed/simple;
	bh=ivxGMo1giylgI8Vx9v7Az7fbPzotpOqbVmQ+M+xadOE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WBJJrrfw1esmVg3v813TiSIahY8XQr+EmrnRCO6iWRY166vTB0Q+8HRd2nOIAOuCf+ih43ofuDK1Zv0Un/TegTUVtcifvLXlR3UzFuRlwk9Oa54q9aFcKCtYIqMOwlC9RF5HO/jvdy6TCogtlvspYThEwfKJPEuj/edln7v/s9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TrORQrF+; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff62f96b10so8547917a91.0
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 10:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742837617; x=1743442417; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7tcfTvJa2x4r0LER3JMCH4ud8u11Uq3+9z/wHx+U/XQ=;
        b=TrORQrF+eaRefoHZrSYCjtjLO2o/lp0Nei0jMVrixSOtnEW3tIajPCEqCAiJkRWJnT
         tLVSgnFBMD87H8CnXwM91VC1hces2rXC9/5FO7gXstN7v7pEweeVxumEW9BmN/dOgTXh
         SkWUsr6Z0GWfFTo4Zjzm2C5AWwJuQqgyxRJkdbvfNxikFxnZuNWiNtwA2bO8yGWBQU9U
         3qRpJEEMdNVgodWueo6DMUO8KLDM+zPDQN5dFMAHUtMxXBptJLRJ84Wx2zG/JnPq15hI
         mp+I63E7Wfwd97adcqXIXEVs1TbExi349XqrwepRK1bc7+KsjCoiFSBc153mfDgsrWDU
         AMPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742837617; x=1743442417;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7tcfTvJa2x4r0LER3JMCH4ud8u11Uq3+9z/wHx+U/XQ=;
        b=BM3bmHoK8VXHwvdGcjsNxSQ1ONIZsvegw3502Un9Rry9ALFAi36l0bx46zG+U8cgAg
         BmWcVbfGx+ntWIY4Ge9pLv+2VABdI9fkBPYpjYUwTMeILV23MTYxs34L9xRHGOyurP6v
         pF/5Bh9ZNObDlOdEcugtFawKpfgzLt2zsknC6MkZKLxhaFBV2eo+UqCNFHu70In5dOYC
         U21Da6KNkgoXhpMcPHNh4uXTA6CbmlWSmRyjk5L2i4t6Aoc8U7a9K5ibXLwkLygStL33
         e8YL3VUFRH34IiabkP1hXMwPZBDr3/9JUV1miVxX87i6NtfvoV4mBkqz8VacfTvc039G
         WlFA==
X-Forwarded-Encrypted: i=1; AJvYcCXb5UP3xJ3Zk9BwDGfS71X703u48zswf7rmKSUvFZmocILWdgUXhubHsZUVFAYjKpN6XnE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzuVEm1cZcEczLzR/q+kHX+9o3vcm4RZmam3VFWAe2aR6Jrlc87
	wB4jUp6tsVO5268A5U9GAyZamghIkVrNzB2xClOml9aFqa5Pm8gtDldfPeZnJ/iJz/yC453Z1d+
	YOyQbXQ==
X-Google-Smtp-Source: AGHT+IG8VOxNV1nd1KcRz6bwFYrN07riyfvl55OXKVLtIrvOisrrUSvNGUFvmnaAyN7tlAD9BenuAvVLWJLD
X-Received: from pjbnb5.prod.google.com ([2002:a17:90b:35c5:b0:2fa:1481:81f5])
 (user=mizhang job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:224d:b0:2fa:3174:e344
 with SMTP id 98e67ed59e1d1-301d43a21f5mr24824003a91.14.1742837617363; Mon, 24
 Mar 2025 10:33:37 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon, 24 Mar 2025 17:31:08 +0000
In-Reply-To: <20250324173121.1275209-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250324173121.1275209-29-mizhang@google.com>
Subject: [PATCH v4 28/38] KVM: x86/pmu/svm: Set GuestOnly bit and clear
 HostOnly bit when guest writes to event selectors
From: Mingwei Zhang <mizhang@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Liang@google.com, 
	Kan <kan.liang@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Mingwei Zhang <mizhang@google.com>, Yongwei Ma <yongwei.ma@intel.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>, 
	Zide Chen <zide.chen@intel.com>, Eranian Stephane <eranian@google.com>, 
	Das Sandipan <Sandipan.Das@amd.com>, Shukla Manali <Manali.Shukla@amd.com>, 
	Nikunj Dadhania <nikunj.dadhania@amd.com>
Content-Type: text/plain; charset="UTF-8"

From: Sandipan Das <sandipan.das@amd.com>

On AMD platforms, there is no way to restore PerfCntrGlobalCtl at
VM-Entry or clear it at VM-Exit. Since the register states will be
restored before entering and saved after exiting guest context, the
counters can keep ticking and even overflow leading to chaos while
still in host context.

To avoid this, intecept event selectors, which is already done by mediated
PMU. In addition, always set the GuestOnly bit and clear the HostOnly bit
for PMU selectors on AMD. Doing so allows the counters run only in guest
context even if their enable bits are still set after VM exit and before
host/guest PMU context switch.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/pmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 9feaca739b96..1a7e3a897fdf 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -165,7 +165,8 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		data &= ~pmu->reserved_bits;
 		if (data != pmc->eventsel) {
 			pmc->eventsel = data;
-			pmc->eventsel_hw = data;
+			pmc->eventsel_hw = (data & ~AMD64_EVENTSEL_HOSTONLY) |
+					   AMD64_EVENTSEL_GUESTONLY;
 			kvm_pmu_request_counter_reprogram(pmc);
 		}
 		return 0;
-- 
2.49.0.395.g12beb8f557-goog


