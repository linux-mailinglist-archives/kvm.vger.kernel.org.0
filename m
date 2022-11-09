Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A205623455
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 21:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiKIUPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 15:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbiKIUPA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 15:15:00 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE871DF1D
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 12:14:59 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id h16-20020a170902f55000b001871b770a83so14007159plf.9
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 12:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hE/SHj1sdYHPDY7tHphP4dEsoHCE0SjySpY1HJmYCUM=;
        b=RWEpz+DP+ByotNnlB6LMuMhfGfcCzqnA5hCVrTopblVLha47S1SWEM1zaHOH7e6kK8
         S8n4vJuRAaVKCFUlp4R9cCf85yx32rmrnzSmhalAy4r0DhMSsyxpKWly7j5UEFGpMNR6
         nuILDywSBUKwMc3FqAvw/A0p3+VHkZvXqPlW7L66eEjYJgOjXOqrMiqsx/f39ZKlABFE
         MxslKYvMqpMuNHoD1yJdDAe7Et3XRMCh5ruZQ70nA944+ngryWbm4zxZw5nfRDgydD6u
         ik/0W81cfLqEPCECo2MqUlGS5v8ijmc2BkaiPkM17JUakUk2N3iUD10Ch6sKdrVJ5l8v
         fUuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hE/SHj1sdYHPDY7tHphP4dEsoHCE0SjySpY1HJmYCUM=;
        b=L1TD5NOge36HsE/SmwhhljMRrL/UtKcvGazQ2qM6/teRhMAeq1AW4nuNvWJ708I3WV
         lBZZcA/aU86bX9DRpo6aIP5jrZ0DAyGFOcai6W22XbTH48W87ZJyGj+9fqDjipinYF/m
         PSC/fuv7wF76M4WSS1+rV2f3UKuhKIAgXt3wm+1Uxu840Nensgnb31r3lT9WA37wKOrU
         IGmFEVZwjnX0h7//nU/5k+EHsPYmCnUbGirTKXcGVQJTOZkhWx3/H2rhNqXl6bFycZ7a
         y0qgG8WMB/8qUf2tRdUasCfCl1oPi8eAWjFP/EgkRuqNXcTdrcTft4hVe8i39v2DzjLG
         Yppw==
X-Gm-Message-State: ACrzQf2+RA5GwCGcKPGsSZDE2mfX7QT2MvR6+uV7ThAZa0Rtd3uluv3N
        8LdVMaN0Af6MSHqD3UOxqmac99dN9GvqDILtEECBEuAM17S7amLlGsbab2eLnULTXgylHnVZJ8i
        m4RBP7Kglp7tvmW0Jo33yRGfW0PlXo94oZVx1mzTGFiXZr3SNvnBR2OObPn9tv7wt2cpe
X-Google-Smtp-Source: AMsMyM4DG+bju7KSlbmjDldoHqaZjpSZHr7zV5EhiGMKWAiCA4M+7141ZcbQHaspjmrHW8Aj6833QdaODtL/ijgl
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a62:ab16:0:b0:56b:b112:4a16 with SMTP
 id p22-20020a62ab16000000b0056bb1124a16mr1289834pff.66.1668024899055; Wed, 09
 Nov 2022 12:14:59 -0800 (PST)
Date:   Wed,  9 Nov 2022 20:14:43 +0000
In-Reply-To: <20221109201444.3399736-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221109201444.3399736-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221109201444.3399736-7-aaronlewis@google.com>
Subject: [PATCH v7 6/7] selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test that masked events are not using invalid bits, and if they are,
ensure the pmu event filter is not accepted by KVM_SET_PMU_EVENT_FILTER.
The only valid bits that can be used for masked events are set when
using KVM_PMU_ENCODE_MASKED_ENTRY() with one exception: If any of the
high bits (35:32) of the event select are set when using Intel, the pmu
event filter will fail.

Also, because validation was not being done prior to the introduction
of masked events, only expect validation to fail when masked events
are used.  E.g. in the first test a filter event with all its bits set
is accepted by KVM_SET_PMU_EVENT_FILTER when flags = 0.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index bd7054a53981..0750e2fa7a38 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -442,6 +442,39 @@ static bool use_amd_pmu(void)
 		 is_zen3(entry->eax));
 }
 
+static int run_filter_test(struct kvm_vcpu *vcpu, const uint64_t *events,
+			   int nevents, uint32_t flags)
+{
+	struct kvm_pmu_event_filter *f;
+	int r;
+
+	f = create_pmu_event_filter(events, nevents, KVM_PMU_EVENT_ALLOW, flags);
+	r = __vm_ioctl(vcpu->vm, KVM_SET_PMU_EVENT_FILTER, f);
+	free(f);
+
+	return r;
+}
+
+static void test_filter_ioctl(struct kvm_vcpu *vcpu)
+{
+	uint64_t e = ~0ul;
+	int r;
+
+	/*
+	 * Unfortunately having invalid bits set in event data is expected to
+	 * pass when flags == 0 (bits other than eventsel+umask).
+	 */
+	r = run_filter_test(vcpu, &e, 1, 0);
+	TEST_ASSERT(r == 0, "Valid PMU Event Filter is failing");
+
+	r = run_filter_test(vcpu, &e, 1, KVM_PMU_EVENT_FLAG_MASKED_EVENTS);
+	TEST_ASSERT(r != 0, "Invalid PMU Event Filter is expected to fail");
+
+	e = KVM_PMU_EVENT_ENCODE_MASKED_ENTRY(0xff, 0xff, 0xff, 0xf);
+	r = run_filter_test(vcpu, &e, 1, KVM_PMU_EVENT_FLAG_MASKED_EVENTS);
+	TEST_ASSERT(r == 0, "Valid PMU Event Filter is failing");
+}
+
 int main(int argc, char *argv[])
 {
 	void (*guest_code)(void);
@@ -452,6 +485,7 @@ int main(int argc, char *argv[])
 	setbuf(stdout, NULL);
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_FILTER));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_MASKED_EVENTS));
 
 	TEST_REQUIRE(use_intel_pmu() || use_amd_pmu());
 	guest_code = use_intel_pmu() ? intel_guest_code : amd_guest_code;
@@ -472,6 +506,8 @@ int main(int argc, char *argv[])
 	test_not_member_deny_list(vcpu);
 	test_not_member_allow_list(vcpu);
 
+	test_filter_ioctl(vcpu);
+
 	kvm_vm_free(vm);
 
 	test_pmu_config_disable(guest_code);
-- 
2.38.1.431.g37b22c650d-goog

