Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A8F493FE1
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 19:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356751AbiASS2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 13:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356737AbiASS2h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 13:28:37 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA12C061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 10:28:36 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id f18-20020a63dc52000000b0034d062c66a0so1129930pgj.17
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 10:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UOgaPad6+1+/B3WL1oX/XHSwIBpKnbyM6W50JYa52vE=;
        b=Q//Zw3KmqKY5MnBtXKmdT5hqbqO4HDCduHOiUkz1x+9yDfZEu3cBdDOybEBOQ1FIfR
         ZansvSYzahNUsY+MkDEnATbQ8Xxb9/auUAIr6LjjoFX3fMpqaYTGyebdGjNyC/fTyoKo
         o+EhELXnh0hhqSlZYc3VkKbw802U742X0EoBoRXo5l/Vw+lz6xffjEjHRAeyblJ6U+Fj
         qsxZTxJPSTcqOnPXZlDgp0kiie66DkTSUYCQdejQY1cGi8kmqfRR6FjlOWOhxXIdX8aJ
         +eyB+mBnkE2iRiLqQoO5folfvAm2wKX21I2x56+5vkpv1VsAxd6K8Sw+Rr0xhCwENixw
         Lcgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UOgaPad6+1+/B3WL1oX/XHSwIBpKnbyM6W50JYa52vE=;
        b=vgeRpHmcYu6sD4l24oxEaWzMDyBF7kpSxWhWV1DSmO4o2djXk4p3xIk+KGhF9ZOTrI
         TqcMUZtbe7WyEo2A+2Qj3aog0gLk77T5IGYsjQRhcrTLFeK7nUBJY++DjBQJlDWGc/C4
         8ty+VPYWIx2Bou5D1kIqI6ZHrqOuL6hBIFfv3n1Br13L/w64gEDppTRvMcggtJTJOs5v
         KjhgUA6OauGUWPy0qmGloM+IOEkm/CWDRf4uzoeUx2YamCzfnfCdXreCDj/GnTdRHAf4
         GkveJOGxlFyv4ad0o0cTn5bjD42/keA6inReyTVG+qzHAEE+7cd0Zw2H5sMLhYElJ9cj
         /Npw==
X-Gm-Message-State: AOAM5323w1fwahHuJJp5LLQiX3DNTfifDuL1pdHsbmiuLgpRC1NiJ8q2
        I8P3HKMTLvZB/D/lQYBEUhlebSueDvd+YYZwlJayp7rG6WgLIEvhUYdGSTlbs6MlC6Pu2t6eatz
        t1OEckN0aJAFGFZ3CXr7MJxbdqQPlnMoY53OICf6PG79ZjsnetLaCE2lBo9N5dK8PGQ==
X-Google-Smtp-Source: ABdhPJyj9BIoGkJvuUB7aK8rYIajgJAnJ14N7Wuqn8En+M0BVmXa0mjmxGr64VXHwjZEopNV0bhq33T5dqVq5pY=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a05:6a00:21ca:b0:4c1:eb90:1267 with SMTP
 id t10-20020a056a0021ca00b004c1eb901267mr29963408pfj.23.1642616916146; Wed,
 19 Jan 2022 10:28:36 -0800 (PST)
Date:   Wed, 19 Jan 2022 18:28:18 +0000
In-Reply-To: <20220119182818.3641304-1-daviddunn@google.com>
Message-Id: <20220119182818.3641304-3-daviddunn@google.com>
Mime-Version: 1.0
References: <20220119182818.3641304-1-daviddunn@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH 3/3] Verify KVM_CAP_ENABLE_PMU in kvm pmu_event_filter_test selftest.
From:   David Dunn <daviddunn@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        jmattson@google.com, cloudliang@tencent.com
Cc:     daviddunn@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After disabling PMU using KVM_CAP_ENABLE_PMU, the PMU should no longer
be visible to the guest.  On Intel, this causes a #GP and on AMD the
counters are no longer functional.

Signed-off-by: David Dunn <daviddunn@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 29 +++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index aa104946e6e0..0bd502d3055c 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -325,6 +325,34 @@ static void test_not_member_allow_list(struct kvm_vm *vm)
 	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
 }
 
+/*
+ * Verify that disabling PMU using KVM_CAP_ENABLE_PMU does not allow PMU.
+ *
+ * After every change to CAP_ENABLE_PMU, SET_CPUID2 is required to refresh
+ * KVM PMU state on existing VCPU.
+ */
+static void test_cap_enable_pmu(struct kvm_vm *vm)
+{
+	int r;
+	struct kvm_cpuid2 *cpuid2;
+	struct kvm_enable_cap cap = { .cap = KVM_CAP_ENABLE_PMU };
+	bool sane;
+
+	r = kvm_check_cap(KVM_CAP_ENABLE_PMU);
+	if (!r)
+		return;
+
+	cpuid2 = vcpu_get_cpuid(vm, VCPU_ID);
+
+	cap.args[0] = 0;
+	r = vm_enable_cap(vm, &cap);
+	vcpu_set_cpuid(vm, VCPU_ID, cpuid2);
+
+	sane = sanity_check_pmu(vm);
+
+	TEST_ASSERT(!sane, "Guest should not see PMU when disabled.");
+}
+
 /*
  * Check for a non-zero PMU version, at least one general-purpose
  * counter per logical processor, an EBX bit vector of length greater
@@ -431,6 +459,7 @@ int main(int argc, char *argv[])
 	test_member_allow_list(vm);
 	test_not_member_deny_list(vm);
 	test_not_member_allow_list(vm);
+	test_cap_enable_pmu(vm);
 
 	kvm_vm_free(vm);
 
-- 
2.34.1.703.g22d0c6ccf7-goog

