Return-Path: <kvm+bounces-58274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F951B8B8AB
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:45:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AB885C0342
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0868B326D69;
	Fri, 19 Sep 2025 22:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HEsY+tG3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B12323F65
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321269; cv=none; b=PXGQkzWqmPhi2pj4RxCiLxsfSiycGalDurlZBEO9QQEc1cwCDjTn3/Y/xOgfF3OkW2SycVRYLLEabTOuZP+7M0AhJ77KL3yYMJd1rBktmAn//iU3oDwf9g4p4WxC/WbNAF/zTeAE4fF9yxlVV/pX81Y2vzvNYTCUCXy2YbIu16A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321269; c=relaxed/simple;
	bh=7F8fN07uyjWFGboVpo4jm1M7dMFGNTEcptEI2FyoK3A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jSvCahDxGYJwnMgWyIRnnN+VWSh8pfwSKYoGneAP9gciZ3y6uxoXCj4urL6FMr6lkd2gw7nxY4UQ2k1hffA/zRn7/V3nc8jHrsNu9ZmrApWLXBUp+/1kNiASUw9jlvT6H+RtiXdaNY1z7BhJ8JBruG2165Edqf8f/rxAj0rFXjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HEsY+tG3; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eddb7e714so2482280a91.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321267; x=1758926067; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=B1JPKZr/jTuAErNJp4ougx6N14MoHm3l7BWFYlNmRME=;
        b=HEsY+tG325u7pbsrruBzKIQvAU7qdYBysdTWefGktBzN9QjLmbqxgRI9bMN4pJS8l5
         18YAkuS1bz1o/YG3c4/5i7aIj46rIZ0Ali527cczNydS5XjEgle9XZa6GCSMmKY8e4Be
         fi1YAY9NlXwpfG87qJbOwk/4DkGoUAqoZUOmJlzpevDAJ6hUGwFNrYj9MkSG+lRZVGps
         P6fENV/9qgNPN+TBqKepzAPntQwbubhd5LdKnBUCTTcp64qNoj6GqoP58XI49MdyS2Dh
         anXY2T7ACAsTimXDjLZ/BPZhQNIZS8ujC3h1/dyW/1hSOsdn3xOZV7xfmBrN3LmUtNye
         aYTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321267; x=1758926067;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B1JPKZr/jTuAErNJp4ougx6N14MoHm3l7BWFYlNmRME=;
        b=ZsUmGGvpdu66x6LgwxpUku636TmMtXn1ktBvcoWUMli55A8H2RdG+nfRTMaBiR/vuQ
         CsOFDTgVTb+Up3H68+reU34YvyQVB+npLJDhIgxLVaHKod6jWV8MkuJiggbo2CA38yms
         xTSNd6dQzSH4eSB9UoNMTIKaP7N1pRYGqTSSrKWJJpUPGT5HV4LbRfhffJdWSnuQA6SG
         eMFff4PsFzL3MsDG9sbRGl78xSA1lDjOpf9FDd68dmtDgjf6q1SvLWvRla7nc3Ak88rv
         pI7kRCxhbNcJGbWjWH1/aUjEBDVb9ij638mINld2dZV0p1aNhBBoGnZGrcSWlWEEAU1P
         HW6g==
X-Gm-Message-State: AOJu0YwMZzxp3CODleLbMvN5uedsMgG2ksRLlLG3GayhwOJAgkTmtb+P
	plP+er9h9CApI7QeWc4jc7CVBUeBB7FqEDAPQx/vhfQsDr7ElOyVIWh8HSkwlEPgmsPdiXbXlgq
	UA4vVlQ==
X-Google-Smtp-Source: AGHT+IEovExhDx5hnbXORvzp1QLyu6LtfldPEwLB0DBYtoIAmSkBGzXcV/s/m8mBz72RwM/ijt8PskoZ3Ew=
X-Received: from pjbpw13.prod.google.com ([2002:a17:90b:278d:b0:327:50fa:eff9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e703:b0:32e:7270:94a1
 with SMTP id 98e67ed59e1d1-33098356f85mr6790607a91.17.1758321267159; Fri, 19
 Sep 2025 15:34:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:53 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-47-seanjc@google.com>
Subject: [PATCH v16 46/51] KVM: selftests: Add support for MSR_IA32_{S,U}_CET
 to MSRs test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Extend the MSRs test to support {S,U}_CET, which are a bit of a pain to
handled due to the MSRs existing if IBT *or* SHSTK is supported.  To deal
with Intel's wonderful decision to bundle IBT and SHSTK under CET, track
the second feature, but skip only RDMSR #GP tests to avoid false failures
when running on a CPU with only one of IBT or SHSTK (the WRMSR #GP tests
are still valid since the enable bits are per-feature).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/msrs_test.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/selftests/kvm/x86/msrs_test.c
index 9285cf51ef75..952439e0c754 100644
--- a/tools/testing/selftests/kvm/x86/msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
@@ -125,13 +125,26 @@ static void guest_test_unsupported_msr(const struct kvm_msr *msr)
 	if (ignore_unsupported_msrs)
 		goto skip_wrmsr_gp;
 
-	if (this_cpu_has(msr->feature2))
-		goto skip_wrmsr_gp;
+	/*
+	 * {S,U}_CET exist if IBT or SHSTK is supported, but with bits that are
+	 * writable only if their associated feature is supported.  Skip the
+	 * RDMSR #GP test if the secondary feature is supported, but perform
+	 * the WRMSR #GP test as the to-be-written value is tied to the primary
+	 * feature.  For all other MSRs, simply do nothing.
+	 */
+	if (this_cpu_has(msr->feature2)) {
+		if  (msr->index != MSR_IA32_U_CET &&
+		     msr->index != MSR_IA32_S_CET)
+			goto skip_wrmsr_gp;
+
+		goto skip_rdmsr_gp;
+	}
 
 	vec = rdmsr_safe(msr->index, &val);
 	__GUEST_ASSERT(vec == GP_VECTOR, "Wanted #GP on RDMSR(0x%x), got %s",
 		       msr->index, ex_str(vec));
 
+skip_rdmsr_gp:
 	vec = wrmsr_safe(msr->index, msr->write_val);
 	__GUEST_ASSERT(vec == GP_VECTOR, "Wanted #GP on WRMSR(0x%x, 0x%lx), got %s",
 		       msr->index, msr->write_val, ex_str(vec));
@@ -269,6 +282,10 @@ static void test_msrs(void)
 		MSR_TEST_CANONICAL(MSR_CSTAR, LM),
 		MSR_TEST(MSR_SYSCALL_MASK, 0xffffffff, 0, LM),
 
+		MSR_TEST2(MSR_IA32_S_CET, CET_SHSTK_EN, CET_RESERVED, SHSTK, IBT),
+		MSR_TEST2(MSR_IA32_S_CET, CET_ENDBR_EN, CET_RESERVED, IBT, SHSTK),
+		MSR_TEST2(MSR_IA32_U_CET, CET_SHSTK_EN, CET_RESERVED, SHSTK, IBT),
+		MSR_TEST2(MSR_IA32_U_CET, CET_ENDBR_EN, CET_RESERVED, IBT, SHSTK),
 		MSR_TEST_CANONICAL(MSR_IA32_PL0_SSP, SHSTK),
 		MSR_TEST(MSR_IA32_PL0_SSP, canonical_val, canonical_val | 1, SHSTK),
 		MSR_TEST_CANONICAL(MSR_IA32_PL1_SSP, SHSTK),
-- 
2.51.0.470.ga7dc726c21-goog


