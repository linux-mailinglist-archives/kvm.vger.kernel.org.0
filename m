Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729586B5718
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbjCKAtE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbjCKAsI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:48:08 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1072413F195
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:47:18 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id bw25-20020a056a00409900b005a9d0e66a7aso3619797pfb.5
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678495613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=q7VAgdz7LFZdy0TwRuw+10uNxgOpC5z+66aVJ61MQCU=;
        b=iXJ2XNnkOZuwv5o644EpKaTumVCWjQTJc7L+xJgsS5JAvFsSb4kCqGNAqqu3qHbc55
         540pfekOKMEyD6rzjkGYjtZaXTADInrV/emexCgODzuGh7jgR63UV/dMz+uKu7+qYoFX
         1+clgRHynd+Y/VpEhsuWVZP1uJMIWyyiewhU4u7N37fuu9HIQOUfdyT6qqYRlTdY4EOA
         2Hp98G2dca3cBJfSW/3Z0hm9qKO8YyLQWLl+Ri4fpxJ6c1x853GMTIzy0HVkjx4Mg4Hw
         66E+WqHe6DtOL53eyMaFOwcJZRb9ylIvt1V/NTyc/gFUofeP39kjtzZIyWtoGCN7kNxO
         GKNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678495613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q7VAgdz7LFZdy0TwRuw+10uNxgOpC5z+66aVJ61MQCU=;
        b=16QGoKWO1Fd3ANVgsc0abUtl77lj6nvnsoCOxtL4qNwQXB5SEvc2vMoVqdR2+BSAFD
         C/0QHZyv6RuI3mMGPPRztoSUTpnDI4NoWW/BHIBMp/O/lJH70fAVojLyNlcPKI3gDyIn
         nUtLc3Nt9dBUEd/5UPOgI0gjYGy+jMEKNX+m10t6ngSleLXrq11xfB9ZfhBqwK27n2Ym
         CfVXfs7GKTtiFJ5O8d0kdyQKtTY0hVGKXUAwGVNpou+K+N5LeEoV/U47k3E3xf654Cm1
         rGiIPDZg6tyD95DNdZa7D9FRrshZNH+WnNyr8wZueRYzjtbZTIW9hSXtA8rufoMswBXm
         Lg7Q==
X-Gm-Message-State: AO0yUKWzHVlYdYid9mIdaDCHMDXFmbDHS5MIGi5M49veOKDjm4A7FQ24
        HTtbjwbwG5Fb0EBMp3zkOzXbm2GmQwc=
X-Google-Smtp-Source: AK7set8RBIub1ZSKgPGlxkz2aELAhnydTonTa6HLjz83OBALURYLH6cWulDiZXgIoBW8jhvrtg+r1J532qo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:c1c3:0:b0:5d6:4f73:9ad with SMTP id
 i186-20020a62c1c3000000b005d64f7309admr11096443pfg.2.1678495613533; Fri, 10
 Mar 2023 16:46:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:46:14 -0800
In-Reply-To: <20230311004618.920745-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311004618.920745-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311004618.920745-18-seanjc@google.com>
Subject: [PATCH v3 17/21] KVM: selftests: Test post-KVM_RUN writes to PERF_CAPABILITIES
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
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

Now that KVM disallows changing PERF_CAPABILITIES after KVM_RUN, expand
the host side checks to verify KVM rejects any attempts to change bits
from userspace.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c        | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 44fc6101a547..6fc86f5eba0b 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -85,6 +85,7 @@ static void test_guest_wrmsr_perf_capabilities(union perf_capabilities host_cap)
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	struct ucall uc;
+	int r, i;
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
@@ -106,6 +107,18 @@ static void test_guest_wrmsr_perf_capabilities(union perf_capabilities host_cap)
 
 	ASSERT_EQ(vcpu_get_msr(vcpu, MSR_IA32_PERF_CAPABILITIES), host_cap.capabilities);
 
+	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, host_cap.capabilities);
+
+	r = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, 0);
+	TEST_ASSERT(!r, "Post-KVM_RUN write '0' didn't fail");
+
+	for (i = 0; i < 64; i++) {
+		r = _vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES,
+				  host_cap.capabilities ^ BIT_ULL(i));
+		TEST_ASSERT(!r, "Post-KVM_RUN write '0x%llx'didn't fail",
+			    host_cap.capabilities ^ BIT_ULL(i));
+	}
+
 	kvm_vm_free(vm);
 }
 
-- 
2.40.0.rc1.284.g88254d51c5-goog

