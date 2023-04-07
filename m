Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68606DB730
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjDGXdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjDGXdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:33:06 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412C4E1AF
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:33:05 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-63294d742fdso8031b3a.0
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680910384;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aiOj1F/qQQct1lZ8XuhvK+i0Mw9vSBJh2jkcfeFretc=;
        b=ZRkMTRpoMrC9Hdpa8inRWs/7begZ7CFFlAol9azLBfjJCRngGsB2a3j9Sr2Z4s0ptR
         6VxJ2Xs6bvq+xqsldOgxRepFSaCYMVv/FLGYoe3d2hPb2SNUmou+fjrXcVMmqiG/emga
         qBVdyv6WDZ6Som3B37vzNL12p7IiaXe8CLY+KeGIylh+OAaf+2+b9VS74yu7ytOEOngK
         dmoy6jkqhRKGudokmhhD+2590KWeybu9jy9VlFmuSImXIRjlEepjXKaY9yrqWMp5/+X/
         251urdxai7jlN/smwBFL2M+qYBEpOR+zKU1jwW89vl4RE2nI8p16EldtSJ5bPeNP/+eD
         ddkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680910384;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aiOj1F/qQQct1lZ8XuhvK+i0Mw9vSBJh2jkcfeFretc=;
        b=PJY88x6SrmiYyaDSY1phK2ApwBQWCjhk/y9A0Bip05RfLrqse+qKERmf/M5d9sJhO+
         B6/yKFq6+CCMtgb3R3r4AaXoOQeuNwB+TI7fZz1W38rraKH8IOvuBg3Rf9SrsdQS7smo
         Oz8/OgVNyCDxm3Rq0jszovXPvxcRi40QqJCqsC8OwJ5Kmg2ns3z8wdYOc1IXonqxsG1v
         P2VPbm+AQcWN+MCNl9hStNzqUVb3CVgkEx/mOvmEMtC2y089bJqZ1y6xO0maTGG2nxNy
         7YEa3U7gShPr+hPWHma8qeyh8drrYpoSn7ZETlo8ByHhDnhVBp5cX5VDWH6qHDOv4UgV
         FIQA==
X-Gm-Message-State: AAQBX9cQ9otCmY/7Wg702L12M7agRI5YgG9F4x25A6Pc+eFP1gtlAv3C
        mRj0sYY0IaBHBrWoZyK2bzc70pDTUo8=
X-Google-Smtp-Source: AKy350aPgAgV1JOAuyPtSRiJ5zGS5nD6D/bTqwqihHu2VYHBZhARPOJtOViZlIiGbq+rvfpJ4f0TxE92do0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2182:b0:628:123c:99be with SMTP id
 h2-20020a056a00218200b00628123c99bemr1877157pfi.2.1680910384747; Fri, 07 Apr
 2023 16:33:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  7 Apr 2023 16:32:52 -0700
In-Reply-To: <20230407233254.957013-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230407233254.957013-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230407233254.957013-5-seanjc@google.com>
Subject: [PATCH v4 4/6] KVM: selftests: Use error codes to signal errors in
 PMU event filter test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use '0' to signal success and '-errno' to signal failure in the PMU event
filter test so that the values are slightly less magical/arbitrary.  Using
'0' in the error paths is especially confusing as understanding it's an
error value requires following the breadcrumbs to the host code that
ultimately consumes the value.

Arguably there should also be a #define for "success", but 0/-errno is a
common enough pattern that defining another macro on top would likely do
more harm than good.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_event_filter_test.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index ef07aaca2168..0432ba347b22 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -77,7 +77,7 @@ static const uint64_t event_list[] = {
  */
 static void guest_gp_handler(struct ex_regs *regs)
 {
-	GUEST_SYNC(0);
+	GUEST_SYNC(-EFAULT);
 }
 
 /*
@@ -92,12 +92,12 @@ static void check_msr(uint32_t msr, uint64_t bits_to_flip)
 
 	wrmsr(msr, v);
 	if (rdmsr(msr) != v)
-		GUEST_SYNC(0);
+		GUEST_SYNC(-EIO);
 
 	v ^= bits_to_flip;
 	wrmsr(msr, v);
 	if (rdmsr(msr) != v)
-		GUEST_SYNC(0);
+		GUEST_SYNC(-EIO);
 }
 
 static uint64_t run_and_measure_loop(uint32_t msr_base)
@@ -114,7 +114,7 @@ static void intel_guest_code(void)
 	check_msr(MSR_CORE_PERF_GLOBAL_CTRL, 1);
 	check_msr(MSR_P6_EVNTSEL0, 0xffff);
 	check_msr(MSR_IA32_PMC0, 0xffff);
-	GUEST_SYNC(1);
+	GUEST_SYNC(0);
 
 	for (;;) {
 		uint64_t count;
@@ -138,7 +138,7 @@ static void amd_guest_code(void)
 {
 	check_msr(MSR_K7_EVNTSEL0, 0xffff);
 	check_msr(MSR_K7_PERFCTR0, 0xffff);
-	GUEST_SYNC(1);
+	GUEST_SYNC(0);
 
 	for (;;) {
 		uint64_t count;
@@ -178,13 +178,13 @@ static uint64_t run_vcpu_to_sync(struct kvm_vcpu *vcpu)
  */
 static bool sanity_check_pmu(struct kvm_vcpu *vcpu)
 {
-	bool success;
+	uint64_t r;
 
 	vm_install_exception_handler(vcpu->vm, GP_VECTOR, guest_gp_handler);
-	success = run_vcpu_to_sync(vcpu);
+	r = run_vcpu_to_sync(vcpu);
 	vm_install_exception_handler(vcpu->vm, GP_VECTOR, NULL);
 
-	return success;
+	return !r;
 }
 
 static struct kvm_pmu_event_filter *alloc_pmu_event_filter(uint32_t nevents)
-- 
2.40.0.577.gac1e443424-goog

