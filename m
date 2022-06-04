Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA9253D494
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350063AbiFDBVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350014AbiFDBVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:21:19 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B958D56768
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:15 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id g129-20020a636b87000000b003fd1deac6ebso1652248pgc.23
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=BA15XsheYEg2aJwndseGbrJZhwtEML96CqjQ+kb/wmc=;
        b=pPg2GFynxJngy+MLWHKeeUywc6H75gORal2taO+4fJyiNin0QbwtyXbwOxCtAUBoiT
         dFdouR4tc8CTdLYE5TaQGK7vlQaBHmGRvsPnF7I/T4lBnYNuxyqaiP+SBTphQQD1S5M0
         5mwD6GwTgw7YD/K1VPFfxJWvKIM/lxbL+yJpFD8vw1Eo0WV6W2+HgtJqmZ/I5ux7haNB
         HtjeXhHrrKvwzAg45NoWE/hkXnFxm8zqpq9/lFlYaSHgkMi2vn9dA9d3mEySTwOzvvTN
         p7H64hKVoTF4U2CBSAKitNmz+VhW19tpBfpY8ZqBAh79MeR3B/m2Ms87vCQBQ3M00PWf
         MpWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=BA15XsheYEg2aJwndseGbrJZhwtEML96CqjQ+kb/wmc=;
        b=b74VxfIOhaAl5dA1PKDpXNQ1zmqZZy3MCn9bE/pWpDBD6lL8BFS1dL2t9z/qmlsl0X
         fgGqIyAwl5meDqyM+9Y8z32237/7vWXm3QKPYg78+JMV99lqJL56V44PWj08Q9Wsag+y
         o6Mt6C9FLgKKT4L2VnkndsMRD0LTBTGE2Qy3Gtq2kaRqX0XWKVDQaYk+TJNdn6htq0SW
         2WPNxuMdaeQ7/GHCdasxWc0HJrDgzSBzDtwEGyEVM+PD+wZpY/1zAFcuc49MIpWrG6rI
         wrYdTxMHXep2q/1GKJwjOXp53mGIP3rr4KeowMK/UG5ZLCJZd2U/HeAB/8GIPpTJfiq3
         YjqA==
X-Gm-Message-State: AOAM5319A3XxvBxqMKdSzLV7u9jPSAI6FDfrlh1X8FBqLw2qAvH7vhpF
        D1uWcG6kFS4+hIkBIjoe8TWFT01x7FE=
X-Google-Smtp-Source: ABdhPJyPZ/NncXaFRCaRVYlwKuiZebsFuq49zH3xfw/IDANHmcw54YxaqbW3ck7+4hi69zLqIeS7zAuvBV4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:178f:b0:1e3:3ba:c185 with SMTP id
 q15-20020a17090a178f00b001e303bac185mr4620pja.1.1654305674746; Fri, 03 Jun
 2022 18:21:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:24 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-9-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 08/42] KVM: selftests: Drop redundant vcpu_set_cpuid() from
 PMU selftest
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
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

Drop a redundant vcpu_set_cpuid() from the PMU test.  The vCPU's CPUID is
set to KVM's supported CPUID by vm_create_with_one_vcpu(), which was also
true back when the helper was named vm_create_default().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 667d48e8c1e0..dc3869d5aff0 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -53,7 +53,6 @@ static void guest_code(void)
 
 int main(int argc, char *argv[])
 {
-	struct kvm_cpuid2 *cpuid;
 	struct kvm_cpuid_entry2 *entry_a_0;
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
@@ -66,7 +65,6 @@ int main(int argc, char *argv[])
 
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
-	cpuid = kvm_get_supported_cpuid();
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
 
@@ -77,7 +75,6 @@ int main(int argc, char *argv[])
 	__TEST_REQUIRE(eax.split.version_id, "PMU is not supported by the vCPU");
 
 	/* testcase 1, set capabilities when we have PDCM bit */
-	vcpu_set_cpuid(vcpu, cpuid);
 	vcpu_set_msr(vcpu, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_FW_WRITES);
 
 	/* check capabilities can be retrieved with KVM_GET_MSR */
-- 
2.36.1.255.ge46751e96f-goog

