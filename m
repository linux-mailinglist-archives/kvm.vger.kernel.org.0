Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54FA4AF881
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238321AbiBIR35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238324AbiBIR3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:29:55 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38195C0613C9
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:29:59 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id a15-20020a17090ad80f00b001b8a1e1da50so2247241pjv.6
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 09:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8OBoX65iKSlGteJ8KRsRO0AoOHBHi+mvW0Rr+JlImC4=;
        b=ZCL0lDmM040QdQ7x5ueHQEvbksPd0C2lX+TdG+eFbCZ5IUcF3N4Ret02g6XWp3235w
         T4EjHtjZfojCMqHj1BAxziiH3bjfWrh5ldjhXGmC0JdCZg1i5LfF4mfusyz+wwICbq4s
         7rT4v1P3LqHzpojuXgM5ZSZ2A87suns5c8Ui5ywNvx6AxBiuU+UO/X+Wn+UCCOAW7CI7
         JNR1dPAcd45MmZA/mDR5q6qS/F3cj7YQBej/qJqF1fA17D4D+xnQB8DbBwDulmV/saSa
         caYQ2Q7Q0cw+Q8ZCSA2W6qYVg0vw64q0O5J3kQ8mP5HJlW2ufhp+F+0B1TA8M8gKekbd
         bhpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8OBoX65iKSlGteJ8KRsRO0AoOHBHi+mvW0Rr+JlImC4=;
        b=kPYxeiLhCPp4opWbNiYamdNnGy0v/BictLCCR7oP+cbK/A/TiVCWMsU1Xgm1zZDfRj
         G7CcYM6pe/AEuZXgjX1dBIS1DcKhfdzOBr9aFOGXaopTBjW8C8SUk1YkOmgpx4MOZyCc
         Wabu999TrNtC1UGI1uY7mh4uoxKgSJfNsSudjafwcQnmsLvtrns99xsjgLCPjaQhQG8+
         /SZjKySzmc+uR4CTPq/2UbdISkQ8tOoyCt+Wz7VFx5dD6kkHrcC+34f1zAbx0TWSqFuS
         1oZNF1DSqUtvvGsOpzAZ48tBksKZpLKJRgu2RfVnVm2M+HuCrlhQs+pOBzMsuLAUm1ye
         9Nnw==
X-Gm-Message-State: AOAM531hTyLRRN3/HHwJKAUTzpMVyt/9E9BpRbgk1ozr3/9BOx1DaGKU
        pInWM2ZDTsrb/tVi7xpUXKFGzyGSRi/5mgg=
X-Google-Smtp-Source: ABdhPJyOqWL9wvZd7gKHbxQ4sw4iacst1JTwmFMj1U2lPBHujiT31uwKyrJN5ab+OUD2GFl1XFC303JBYwGWHJE=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a17:902:f786:: with SMTP id
 q6mr3101390pln.64.1644427798725; Wed, 09 Feb 2022 09:29:58 -0800 (PST)
Date:   Wed,  9 Feb 2022 17:29:45 +0000
In-Reply-To: <20220209172945.1495014-1-daviddunn@google.com>
Message-Id: <20220209172945.1495014-4-daviddunn@google.com>
Mime-Version: 1.0
References: <20220209172945.1495014-1-daviddunn@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v6 3/3] KVM: selftests: Verify disabling PMU virtualization
 via KVM_CAP_CONFIG_PMU
From:   David Dunn <daviddunn@google.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, jmattson@google.com, like.xu.linux@gmail.com,
        kvm@vger.kernel.org, David Dunn <daviddunn@google.com>
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
2.35.0.263.gb82422642f-goog

