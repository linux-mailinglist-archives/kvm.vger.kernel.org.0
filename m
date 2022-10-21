Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B829660804E
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 22:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiJUUvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 16:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiJUUve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 16:51:34 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DF627E067
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:51:32 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id s2-20020aa78282000000b00561ba8f77b4so1869760pfm.1
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d0XEPnbI3503AWDt9XzGyqaMgJgSF6P70gHQJDooX+Q=;
        b=d0ZdOeRtGePIg6QDyBAZVp/qKhG7uMKtttQI0vbMIDjQ+HTiB+1JVLVSAnPtYe6JxV
         8XW3IuHrlEyK/A9FVgL5R+cAIGplQ+GoYXY7xuMB1xH/n3ggPZOeCprLkjkwignNcwEE
         Jw9BtikSEtA3ahuEutebBUpk1j+VgEzvTSXUlTz1AgGglWF2FfgDiHBHuSHzCquDsOU1
         khj4JVkPfgXjyavJUyYZDTbrpCUEzRMRQjB9nYW1r4y1l9TDrkDiWprxdfpZ7NOjcpN+
         Lw5rFeIQYQMEE7y1QfjP2X6BG3IqMDP671/9xi5cf9SzHSCHdJR/yUK1S0xnk5UgYMWF
         xLUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d0XEPnbI3503AWDt9XzGyqaMgJgSF6P70gHQJDooX+Q=;
        b=mx1isDrMxPc5IPJ4pgwx6hALA+O2QFo7DjefPTdjg+CfZyCQGfid/1ENYjvEdJuUIw
         YesjGvqb9gI+EGU7/MMfFUa2MxmdeTwwgMDM6GlJFZlq8m7ZlXhGDGT9sDysLhknhEzT
         SrLcTX7a62X8ynAyYloo2HHqEMd7s8gXvIKxJPSJQ0hDA0HvrLo2rw/CirVeMEruDXeV
         W1/VYM/5mLMP34ij4c5BXS6aDpF02Z9KoKBD3W+2Y5J+iogUw6wfIQvh3DKHnIpzLpBG
         4IOwsq6B/rSAyE8EKAEfsDDV6IP0VCDPGv5VqR7tbUZbCXtrXhuTIy/uAJMq1PVQ07vR
         MUBQ==
X-Gm-Message-State: ACrzQf2Fx98XZqXV+pg4YnQ8aI7MNcqAN5ttdkkwnfmZ/7vz2vPmwdfd
        OjQGSDIFqiukC3G5tBM4w1yTsR6VJKDPJbxyE/HYyRc7TabrgJPUnT62+2N7i8ZZSsK4IOada14
        k9vnFCZ3wedOccloWOMbjroHZFS4CPGeppp3ZTLwfHpDdp6KDekeu33CInciZfv3OfYxd
X-Google-Smtp-Source: AMsMyM7a9+yQIodcJRvBZOTagZvAFFmdkSER7atciFOqztNTIYmy5qBIdsdLL+UgXzZxGCq2b6oTRfrJLcUVBU96
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:903:3011:b0:186:892d:1c4c with SMTP
 id o17-20020a170903301100b00186892d1c4cmr307715pla.152.1666385491495; Fri, 21
 Oct 2022 13:51:31 -0700 (PDT)
Date:   Fri, 21 Oct 2022 20:51:04 +0000
In-Reply-To: <20221021205105.1621014-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221021205105.1621014-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221021205105.1621014-7-aaronlewis@google.com>
Subject: [PATCH v6 6/7] selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER
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
2.38.0.135.g90850a2211-goog

