Return-Path: <kvm+bounces-58207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 214EDB8B64A
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 23:47:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9EF80A028F3
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EADFC2D7381;
	Fri, 19 Sep 2025 21:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TkLxB4of"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C72A2D5426
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758318421; cv=none; b=esasVMvoo1CZ7ndB5uIzSFk1ufzvaD+cidIIY37eTllLdSTN2RI9YMPn6MbxcE2u8Cu2qHn+MYVqZ7Ael+BAjRZbXfTvm+i4ci++LlHveNJXYmm9pq5qDsoJDr2oha7tfUHtkjkUUy6xjiMzv/G0cE+ijhg2fUUjNQy6SgHzLRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758318421; c=relaxed/simple;
	bh=NddpnuKAkAmk4MRD6KjS6LY4WcUZVoPMjThIO83KgT4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dffAksLk/wiya9PHes5CWTGxJiFCfDUMBdfoRFoBRqIi4BdsA8c7o9fM6W3yyl1Ks4yAzOluthfveLOkSEBhlafwIQicp2ZKpOYprtHRFWPZSsUvwmoeWVVU9hJAErO5+tKUaXXwxSeC3lhzXoMU7CR96tiuCJBuWoHDQuPJ/Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TkLxB4of; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eaeba9abaso3397737a91.3
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 14:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758318419; x=1758923219; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AhTNYhBvmR83TcB5Eza06EfqGOvKS3T4kCXPtcIUOWM=;
        b=TkLxB4ofmQOsDqn0LXiFVo5v+KcSpVBC2XV+lSBV7xeTJn7wlORuDVyp8OaKLwy4Rv
         u/0nwJYDSZemjDMA3NNfuw2czThn24miTqX0vnyx+eJ5Zg+AXtYqJ6xmcaIrLvlKUPHd
         cizt6EEO82sduV/fhOhdkcEvSjOi2a57AicdKHvtLxUV8Hm8cM/PwXnSiN3iz4BBAolj
         rVBXAE490Y8deTjAKRnBU7l4BBAzizSnLDatF+qL7NnVSTxn+c4em/unvF+68If0Nc7j
         mcxkw11T9uEgpHp5MAlK6MdVMvGuzhqu2qn5dYhAZNGcRaROR2ZQtzxhNSjj37p7Ncvg
         83vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758318419; x=1758923219;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AhTNYhBvmR83TcB5Eza06EfqGOvKS3T4kCXPtcIUOWM=;
        b=ciqYLNRR2WxZtWON8Fze/3fuB9cV0FhePn9aRDBui2Bb5wEdhRZKIb/ZlmxklRBkJy
         YNLo3UKoCo9LgoyURqkHBbqK70YqoualNlS+vLgb88lQjQWCu1OuiC1OpwcBiy38Zk50
         uaUwdF7LfpGh52t/toGqoZnStqQiDawoFsuf67vf3zPUZYOm/pTWaJFF9hlrLE2jSWkF
         FotdkU0iT7AlcAgpT19UQaX8vuJSY3CoBMtygX6E5IrPx+tjhltTACoDc7WvG8kB0PhD
         aIS2GQ1QY7OhteJsJn2k4gXf+47wgAPRcS6wvLKms6JQI0E+v3KsspzjzOhVcLuTk//1
         vOvA==
X-Gm-Message-State: AOJu0YzHrFO0Mqd1yO/h4F4l6havNmxZMzhNtDOv1O8+6DUk5Ap8onvG
	NEd9bfYpQhE4qP8/arnWHksUimz/wpHjYMrTBSV4Ixl95nyN2kD28kGudqWsSpuKGsLzumgqzj8
	qUGmUNQ==
X-Google-Smtp-Source: AGHT+IHmKkAcRujSaa/deGElAZSnSbNr626XHKP7okVTyvwJsPrhF/HPMRr/4yIOYDoc1jwhfznVT0Y/13E=
X-Received: from pjff14.prod.google.com ([2002:a17:90b:562e:b0:32e:c4a9:abe0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d604:b0:32e:4849:78b
 with SMTP id 98e67ed59e1d1-33097ff67b9mr6075438a91.16.1758318419110; Fri, 19
 Sep 2025 14:46:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 14:46:45 -0700
In-Reply-To: <20250919214648.1585683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919214648.1585683-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919214648.1585683-3-seanjc@google.com>
Subject: [PATCH v4 2/5] KVM: selftests: Track unavailable_mask for PMU events
 as 32-bit value
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Yi Lai <yi1.lai@intel.com>
Content-Type: text/plain; charset="UTF-8"

Track the mask of "unavailable" PMU events as a 32-bit value.  While bits
31:9 are currently reserved, silently truncating those bits is unnecessary
and asking for missed coverage.  To avoid running afoul of the sanity check
in vcpu_set_cpuid_property(), explicitly adjust the mask based on the
non-reserved bits as reported by KVM's supported CPUID.

Opportunistically update the "all ones" testcase to pass -1u instead of
0xff.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/pmu_counters_test.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index 8aaaf25b6111..1ef038c4c73f 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -311,7 +311,7 @@ static void guest_test_arch_events(void)
 }
 
 static void test_arch_events(uint8_t pmu_version, uint64_t perf_capabilities,
-			     uint8_t length, uint8_t unavailable_mask)
+			     uint8_t length, uint32_t unavailable_mask)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -320,6 +320,9 @@ static void test_arch_events(uint8_t pmu_version, uint64_t perf_capabilities,
 	if (!pmu_version)
 		return;
 
+	unavailable_mask &= GENMASK(X86_PROPERTY_PMU_EVENTS_MASK.hi_bit,
+				    X86_PROPERTY_PMU_EVENTS_MASK.lo_bit);
+
 	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_test_arch_events,
 					 pmu_version, perf_capabilities);
 
@@ -630,7 +633,7 @@ static void test_intel_counters(void)
 			 */
 			for (j = 0; j <= NR_INTEL_ARCH_EVENTS + 1; j++) {
 				test_arch_events(v, perf_caps[i], j, 0);
-				test_arch_events(v, perf_caps[i], j, 0xff);
+				test_arch_events(v, perf_caps[i], j, -1u);
 
 				for (k = 0; k < NR_INTEL_ARCH_EVENTS; k++)
 					test_arch_events(v, perf_caps[i], j, BIT(k));
-- 
2.51.0.470.ga7dc726c21-goog


