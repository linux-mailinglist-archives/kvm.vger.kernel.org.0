Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F0E49575E
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 01:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378408AbiAUAab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 19:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378402AbiAUAaa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 19:30:30 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6D8C061574
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 16:30:29 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id b141-20020a376793000000b0047910c74c9dso5514717qkc.4
        for <kvm@vger.kernel.org>; Thu, 20 Jan 2022 16:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=q/IAOHN4sH5IHagVn8dkrSpgnhYRJyTC5Xd3XT8xJb8=;
        b=HWm9tHoOK5Sxkc0pwiMzjeHFtqcLQo2o/ZlOpfyFIOzEoNQenIgIJEY/0aP0MM4COH
         tC90fKnehsoBojGM6DPJJoluL09XFBMBGtfahi5HJdBEFRwEFeOY5H+SiPl9R7PzxXAG
         9Vegqxm9CiHstHi7xV4NzpQayMWGKoE/yEJBA9lGFjYpBTl81BsABZrBeO8t9SM9Xda/
         qgUTVRNokcIKzNiJJZTmxDjC/KG9IJTsuuMrXOK4+wq2O+PAtX/jExbpkelPUk6V6THh
         XlB8lNDMv8hZRASJ5RHo6gC/NPgkZzHlEqkbwBWUh41sYVFlcJdqw9myBgvBqOIejaiY
         UxXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=q/IAOHN4sH5IHagVn8dkrSpgnhYRJyTC5Xd3XT8xJb8=;
        b=662GipFO0fOdHUEf2KV87Fttg1RLauq4ECf3BeC+24L+5G4YgxyoQrDokeHmY+RAZb
         nqnO6/0fX3j38kVOaxv9NxRALaE8qKrnNYCYryuX09fX6AxPzY5xMEyutCaGz+xmm7nB
         K5bpCUjDZzxPOygvnHiUF4ZhRkARNRGx0qpAexqziWWQLr3HFqqC3CGj+qDAIcMiORS2
         Lfo6fCFQegdIHzZgzgt4nwtGZzwr8Y0TS2/nwYXkGobwfmQ3XuViOFnVFJjyv1DVQIUs
         BjgOHCWHfGalYZATyDYeHSoCr99USFKMuVKIB2vkqU23yv9p84YIQ4tOuO0ZfoIex7h7
         iAxw==
X-Gm-Message-State: AOAM5303wlhmlGy+Ou9IrdwnPZckE5mGinbit+5xaRBCZz+kUe9JAW+1
        n6LaXyf9vTglCvSEM1I/mWrN1hPzHkvyR2gP7bU1rHodUUyawgp5ni/Qbfub8aHliBHCPpf3XH/
        xUclsT7d5iu9Vh5c24YnH3gPXT50wsfr/mGrKoGn40HOjhNk5usQ5MXVKvFg3mXGXFg==
X-Google-Smtp-Source: ABdhPJwCNyM8n/5wunHDtnKFo3aEmYpOTJpLZ1aY2mHjNX+sGJPJ8KevzsOjUDOHMj8VzXN/9bCxOHM2speh62Y=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:ac8:5802:: with SMTP id
 g2mr1511554qtg.100.1642725028811; Thu, 20 Jan 2022 16:30:28 -0800 (PST)
Date:   Fri, 21 Jan 2022 00:29:52 +0000
In-Reply-To: <20220121002952.241015-1-daviddunn@google.com>
Message-Id: <20220121002952.241015-4-daviddunn@google.com>
Mime-Version: 1.0
References: <20220121002952.241015-1-daviddunn@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 3/3] selftests: Verify disabling PMU via KVM_CAP_CONFIG_PMU
From:   David Dunn <daviddunn@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        jmattson@google.com, cloudliang@tencent.com
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
index c715adcbd487..40fecaa4ea9f 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -325,6 +325,39 @@ static void test_not_member_allow_list(struct kvm_vm *vm)
 	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
 }
 
+/*
+ * Verify KVM_PMU_CONFIG_DISABLE prevents the use of the PMU.
+ *
+ * Note that KVM_CAP_PMU_CONFIG must be invoked prior to creating VCPUs.
+ */
+static void test_pmu_config_disable(void (*guest_code)(void))
+{
+	int r;
+	struct kvm_vm *vm;
+	struct kvm_enable_cap cap = { 0 };
+	bool sane;
+
+	r = kvm_check_cap(KVM_CAP_PMU_CONFIG);
+	if ((r & KVM_PMU_CONFIG_DISABLE) == 0)
+		return;
+
+	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+
+	cap.cap = KVM_CAP_PMU_CONFIG;
+	cap.args[0] = KVM_PMU_CONFIG_DISABLE;
+	r = vm_enable_cap(vm, &cap);
+	TEST_ASSERT(r == 0, "Failed KVM_PMU_CONFIG_DISABLE.");
+
+	vm_vcpu_add_default(vm, VCPU_ID, guest_code);
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+
+	sane = sanity_check_pmu(vm);
+	TEST_ASSERT(!sane, "Guest should not see PMU when disabled.");
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

