Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F72C531E1D
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 23:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiEWVlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 17:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbiEWVla (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 17:41:30 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEBC11C01
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 14:41:27 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id p16-20020a170902e75000b00161d96620c4so7303898plf.14
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 14:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VU7bPAhX/r0weRFhbREr5P1IddEmW8HdNVHkdTEqOfQ=;
        b=VfQ2pewNeOMr4hdqxSjZaEIgmjWUg4f1QwcxPet0P9N0rdzAIr2FWOkTHZl3kdhTpB
         ssNfAxmaYNVYb4JZzQp4IGNQP+6p7yiRf4OSXD2NZn054zRj9F9j8h5TFljO9iFuw4Oc
         rQYWtMRXv4zHY/Hk3mBepjwcgCq8oE3Bw1u0PoiZz62rrtaPvRexN8kf8IZ4wo3uHNAo
         +q8CmfsSBwA0Ir9SB3JZSNob1wDfsnVv3aLB/vgY2pbQt9Xr7nf8IeQnjgnBo+IYNhJe
         gZBMP93gy05HF4Se0wfUdlF23lOGNBTimPbl8r2qxfiWWbXxEvjaxmJGjp6czzsdrZsL
         p22w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VU7bPAhX/r0weRFhbREr5P1IddEmW8HdNVHkdTEqOfQ=;
        b=MufgdO3GLtj5judRz6a68koWo/znP24H2TVGaUJNStOM4VPpZhPUASnCLsYaH8fFo7
         QTGFFBQvXy/zjNElZ0pdM1b0snHWnEVia9izbw4qrLnu+IcnYTEas9w49w06uM0c9xZs
         +qLQdiqZ9gyyWiuSCjbWri9R9eYjToWmy+IeEmS04zLduuz4tFELR5rBeXg4aohqsLHj
         FbgOxw8H/nP8HeBjS10KyeJ4g6M9cdis8CsAyhGx4dftNrfCsli0n5Kc9FEsHNpSoz1Q
         y93azGQCZIvIasKxEMdRakietP96INUYF14WYU44y5RjJaeoHeFQzAUyS8CdVSaR87kj
         /9ig==
X-Gm-Message-State: AOAM533XnlwnT9QvGQ6uwdm6NtMLnvmx2Ie0NH/nYNFO6N37vP0NKM+U
        vYt72Ch9Eo6qsHEy4guNlFHLV4+ZXk1kjlOhead6VaQfWo7HWM+1DEldZJBQczwlIHFJjoh+zjF
        8epb9anh2E7QGPLUiOBoWK/ERvJNYS+7xJ1jJSxv3DH6vlrhKOXV12rGAYF02L93fI/2H
X-Google-Smtp-Source: ABdhPJyTclnu9AsQMaoDbrjzl42lyBFiCn1zKhVMpABiSVfpusyaxosLQF9YVgk3HGiEpQBpyGgKKYC97JmBfaWi
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a62:484:0:b0:50d:a020:88e5 with SMTP id
 126-20020a620484000000b0050da02088e5mr25245954pfe.51.1653342086556; Mon, 23
 May 2022 14:41:26 -0700 (PDT)
Date:   Mon, 23 May 2022 21:41:10 +0000
In-Reply-To: <20220523214110.1282480-1-aaronlewis@google.com>
Message-Id: <20220523214110.1282480-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220523214110.1282480-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 4/4] selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test that masked events are not using invalid bits, and if they are,
ensure the pmu event filter is not accepted by KVM_SET_PMU_EVENT_FILTER.
The only valid bits that can be used for masked events are set when
using KVM_PMU_EVENT_ENCODE_MASKED_EVENT() with one caveat.  If any bits
in the high nybble[1] of the eventsel for AMD are used on Intel setting
the pmu event filter with KVM_SET_PMU_EVENT_FILTER will fail.

Also, because no validation was being done on the event list prior to
the introduction of masked events, verify that this continues for the
original event type (flags == 0).  If invalid bits are set (bits other
than eventsel+umask) the pmu event filter will be accepted by
KVM_SET_PMU_EVENT_FILTER.

[1] bits 35:32 in the event and bits 11:8 in the eventsel.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 4071043bbe26..403143ee0b6d 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -550,6 +550,36 @@ static void test_masked_filters(struct kvm_vm *vm)
 	run_masked_filter_tests(vm, masked_events, nmasked_events, event);
 }
 
+static void test_filter_ioctl(struct kvm_vm *vm)
+{
+	struct kvm_pmu_event_filter *f;
+	uint64_t e = ~0ul;
+	int r;
+
+	/*
+	 * Unfortunately having invalid bits set in event data is expected to
+	 * pass when flags == 0 (bits other than eventsel+umask).
+	 */
+	f = create_pmu_event_filter(&e, 1, KVM_PMU_EVENT_ALLOW, 0);
+	r = _vm_ioctl(vm, KVM_SET_PMU_EVENT_FILTER, (void *)f);
+	TEST_ASSERT(r == 0, "Valid PMU Event Filter is failing");
+	free(f);
+
+	f = create_pmu_event_filter(&e, 1, KVM_PMU_EVENT_ALLOW,
+				    KVM_PMU_EVENT_FLAG_MASKED_EVENTS);
+	r = _vm_ioctl(vm, KVM_SET_PMU_EVENT_FILTER, (void *)f);
+	TEST_ASSERT(r != 0, "Invalid PMU Event Filter is expected to fail");
+	free(f);
+
+	e = ENCODE_MASKED_EVENT(0xff, 0xff, 0xff, 0xf);
+
+	f = create_pmu_event_filter(&e, 1, KVM_PMU_EVENT_ALLOW,
+				    KVM_PMU_EVENT_FLAG_MASKED_EVENTS);
+	r = _vm_ioctl(vm, KVM_SET_PMU_EVENT_FILTER, (void *)f);
+	TEST_ASSERT(r == 0, "Valid PMU Event Filter is failing");
+	free(f);
+}
+
 int main(int argc, char *argv[])
 {
 	void (*guest_code)(void) = NULL;
@@ -595,6 +625,7 @@ int main(int argc, char *argv[])
 	test_not_member_allow_list(vm);
 
 	test_masked_filters(vm);
+	test_filter_ioctl(vm);
 
 	kvm_vm_free(vm);
 
-- 
2.36.1.124.g0e6072fb45-goog

