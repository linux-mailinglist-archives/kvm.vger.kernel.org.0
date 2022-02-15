Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0105B4B6026
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 02:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbiBOBtb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 20:49:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbiBOBtb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 20:49:31 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5A3B0C6E
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 17:49:22 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id j23-20020a17090a7e9700b001b8626c9170so874789pjl.1
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 17:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uT57Pwggn8J8V969qJ6Qpjnbi+GZqW2bc8pBgCFI8W4=;
        b=UYeH2yRBiAoR9DydIPRapA1tL4iB0sMC5zkWkSVwFJzZs7qZtnMVIxrynrV1/K1o2y
         L/HRVSN2xkau7+QPONz0CWvzocC+n7COGrvG48V9bB6Txug8UUrmkUQ1otMnGhJWDgrX
         G+WOcJuRIjSWnVe2ZFJPpp0JQQpJsT5/HFEWfdj3vCLkMjZdR97rp367oh3ULBC0HbwF
         SOQvexVwQRrHQN3+oJPXJGYe6e/YO6OblYZ5e1gwShCYK3hhDEjtg5sfTKkShZkfqiJz
         W3bhnvnRxLfBOeusI7UaynNaVPdD2SM7lOKsWhVWEzjBGZdEwogi0aZ3oJlmSwDwFOjW
         CWqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uT57Pwggn8J8V969qJ6Qpjnbi+GZqW2bc8pBgCFI8W4=;
        b=GMtYVAb0NO7mqPyCbVxS2917sb5kOuf8DxtybJSShwcrPNhBGxQbUo0yGEyckMpz09
         lq/AZhFHwbrF0L/GVvliZPfZdStVWqj/lvxmP/SwVe6FaYXDJqpfuLVvB32TkQvKbXpj
         uR5zN/09E4EHBig4Z26dcRlJlYt6Dh8bhrDTfL5KRm6xG2E+/nsWJ1Y1dZm3AE76q7pD
         kvc2L1E+6mjUbtV7ZObxifTsvvHJCVlA1n2iyvS/D7+/lhr7aySR3kmkSdB60fDJ9H/f
         tY8EbhMwxMrxvLEcSpj5SBtDxEuq6zzkQ6YhpEy6V6uEZuDH8pgb+13fLgpXlfl46ROh
         YcIg==
X-Gm-Message-State: AOAM532wcHIM0MySSMweQlSxN8O6NcWR2KYHKDAsQQ/hAgyv99OvYOBS
        4jK5CpujrtFSGOCAw2bLu1jD9fsXNQdhtQ0=
X-Google-Smtp-Source: ABdhPJzasUiP7HyI5krnMMptqQpE47/UGsj5US8grtUSWFe5rdS1fSbhG3etH43dmNBhCNp5GIj6nVNHgAPsVg8=
X-Received: from daviddunn-glinux.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:782])
 (user=daviddunn job=sendgmr) by 2002:a62:4d43:: with SMTP id
 a64mr1566949pfb.73.1644889762097; Mon, 14 Feb 2022 17:49:22 -0800 (PST)
Date:   Tue, 15 Feb 2022 01:48:06 +0000
In-Reply-To: <20220215014806.4102669-1-daviddunn@google.com>
Message-Id: <20220215014806.4102669-4-daviddunn@google.com>
Mime-Version: 1.0
References: <20220215014806.4102669-1-daviddunn@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v7 3/3] KVM: selftests: Verify disabling PMU virtualization
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

On a VM with PMU disabled via KVM_CAP_PMU_CONFIG, the PMU should not be
usable by the guest.

Signed-off-by: David Dunn <daviddunn@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index c715adcbd487..dc04a266b3ed 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -325,6 +325,37 @@ static void test_not_member_allow_list(struct kvm_vm *vm)
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
+
+	r = kvm_check_cap(KVM_CAP_PMU_CAPABILITY);
+	if (!(r & KVM_CAP_PMU_DISABLE))
+		return;
+
+	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+
+	cap.cap = KVM_CAP_PMU_CAPABILITY;
+	cap.args[0] = KVM_CAP_PMU_DISABLE;
+	TEST_ASSERT(!vm_enable_cap(vm, &cap), "Failed KVM_CAP_PMU_DISABLE.");
+
+	vm_vcpu_add_default(vm, VCPU_ID, guest_code);
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+
+	TEST_ASSERT(!sanity_check_pmu(vm),
+		    "Guest should not be able to use disabled PMU.");
+
+	kvm_vm_free(vm);
+}
+
 /*
  * Check for a non-zero PMU version, at least one general-purpose
  * counter per logical processor, an EBX bit vector of length greater
@@ -430,5 +461,7 @@ int main(int argc, char *argv[])
 
 	kvm_vm_free(vm);
 
+	test_pmu_config_disable(guest_code);
+
 	return 0;
 }
-- 
2.35.1.265.g69c8d7142f-goog

