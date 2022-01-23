Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27C74974CD
	for <lists+kvm@lfdr.de>; Sun, 23 Jan 2022 19:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbiAWSp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Jan 2022 13:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiAWSp4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Jan 2022 13:45:56 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5CFC06173D
        for <kvm@vger.kernel.org>; Sun, 23 Jan 2022 10:45:56 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id g12-20020a63200c000000b00342cd03227aso8440899pgg.19
        for <kvm@vger.kernel.org>; Sun, 23 Jan 2022 10:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kE8JA9e/slHJiQqqHLM5pCFB077+Vtk/p6OHU/32KRA=;
        b=Xy0TxNtxxJW7ToJ0JJ/iU97fDKQbxZFvz11wq37ALBlrSia5mD+GHCVX5I8lksarAh
         W5Hy/GEpMKyI1eoeBX0wbGQNk3esNHP2/qwYKKv+a6gzrf2Q607dILdgaenEJmnXDddU
         tCx0EqEV3w7gk9cqsDzf4Rt7oHKjxdOYHyarCvBFXDztbPrvtd7akT71WFFxX+SBRNYs
         jALvQqx2R+n/EVO8Y51vwN1sWmvaUlyKskxVGCBzYvJIdiHkOHHqfc8nQXg+1rmFJVzO
         h7iM94tOsYhQVHU9Rn/7hEliaFwJ/Y1VP2gaGpXSaZtxCLvCe9VfWsZP0eEuKOJbBkK6
         PGAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kE8JA9e/slHJiQqqHLM5pCFB077+Vtk/p6OHU/32KRA=;
        b=dvvLk3PkbKbsQ9CdbKYi2H8gBLW9/sdRKexZUDZWw8062XOeNMimMEb6QAbUSyGSZW
         edccy0CINfNdwh1lrgzc7cPiTRuWBSnxYOORcU/FImDA3dciEP413c6uFaaCf31EM7Sk
         GyEgoLW779YXyJEaL6ofVfXyrvIkGPMOgFcsbMsKcOB5ym3DxNEhS5mQx/kEJki8vbsB
         6QqVe38Sh42Z+dfjku6P1X3b2gzQnVYXpiXpDB6lOFCpLB1nSNFSUqAFbYoyvXGWCMBe
         4/U7Zoe7j4Bbf0ARLYvGlNqJvs9eWGFKxPptI8L2dqX4iqzC5cmMR2FHL5VtVFQtd7w6
         +X/w==
X-Gm-Message-State: AOAM530dvGY1s/T9++3JjjHDpbn+0itLAyzihZrACXpUQTGsgSW4BM9k
        5J5Ca6uC/4l2eEgyBqTFYBna4HFA5thRkElsKk5sphVL3CPZWph0VJA1bzCF7ATWDMLDYO56DM7
        SdtgbYMSQTJB8UnszynImXoZzWlauGN2TE3sN/grUyE3lDglQXcrqnxj3wqHNp/9tWw==
X-Google-Smtp-Source: ABdhPJzPp20fsCS0q2290sQzHJ8qkeEQBrekvywVp7hMn4M57lvemhgRi7Kg+6RH8F/5X0FTcfgGz6tSmZiwS4I=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a17:902:6b83:b0:149:7cb1:9582 with SMTP
 id p3-20020a1709026b8300b001497cb19582mr11488826plk.29.1642963555823; Sun, 23
 Jan 2022 10:45:55 -0800 (PST)
Date:   Sun, 23 Jan 2022 18:45:41 +0000
In-Reply-To: <20220123184541.993212-1-daviddunn@google.com>
Message-Id: <20220123184541.993212-4-daviddunn@google.com>
Mime-Version: 1.0
References: <20220123184541.993212-1-daviddunn@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v5 3/3] KVM: selftests: Verify disabling PMU virtualization
 via KVM_CAP_CONFIG_PMU
From:   David Dunn <daviddunn@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        jmattson@google.com, cloudliang@tencent.com, seanjc@google.com
Cc:     daviddunn@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On a VM with PMU disabled via KVM_CAP_PMU_CONFIG, the PMU will not be
usable by the guest.  On Intel, this causes a #GP.  And on AMD, the
counters no longer increment.

KVM_CAP_PMU_CONFIG must be invoked on a VM prior to creating VCPUs.

Signed-off-by: David Dunn <daviddunn@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index c715adcbd487..7a4b99684d9d 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -325,6 +325,39 @@ static void test_not_member_allow_list(struct kvm_vm *vm)
 	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
 }
 
+/*
+ * Verify KVM_CAP_PMU_DISABLE prevents the use of the PMU.
+ *
+ * Note that KVM_CAP_PMU_CAPABILITY must be invoked prior to creating VCPUs.
+ */
+static void test_pmu_config_disable(void (*guest_code)(void))
+{
+	int r;
+	struct kvm_vm *vm;
+	struct kvm_enable_cap cap = { 0 };
+	bool sane;
+
+	r = kvm_check_cap(KVM_CAP_PMU_CAPABILITY);
+	if ((r & KVM_CAP_PMU_DISABLE) == 0)
+		return;
+
+	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+
+	cap.cap = KVM_CAP_PMU_CAPABILITY;
+	cap.args[0] = KVM_CAP_PMU_DISABLE;
+	r = vm_enable_cap(vm, &cap);
+	TEST_ASSERT(r == 0, "Failed KVM_CAP_PMU_DISABLE.");
+
+	vm_vcpu_add_default(vm, VCPU_ID, guest_code);
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+
+	sane = sanity_check_pmu(vm);
+	TEST_ASSERT(!sane, "Guest should not be able to use disabled PMU.");
+
+	kvm_vm_free(vm);
+}
+
 /*
  * Check for a non-zero PMU version, at least one general-purpose
  * counter per logical processor, an EBX bit vector of length greater
@@ -430,5 +463,7 @@ int main(int argc, char *argv[])
 
 	kvm_vm_free(vm);
 
+	test_pmu_config_disable(guest_code);
+
 	return 0;
 }
-- 
2.35.0.rc0.227.g00780c9af4-goog

