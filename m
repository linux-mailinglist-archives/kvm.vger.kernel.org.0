Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6B854BB65
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357414AbiFNUKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357875AbiFNUJl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:09:41 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A7C4F9FD
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:25 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h190-20020a636cc7000000b003fd5d5452cfso5452338pgc.8
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=h3RwRgkH3viEGiVwk/Kgcg86FthLy8sfCzc8sgc8x6g=;
        b=nW9P7nc/G0v2UnLMGl9qvPdqSulKgM4tJFUFYxG70973c4HXppFyOG+ju5TMrzEXpl
         Wi2zWgxr6qe6Ab690h7RYd8dVpmToVW7edcZv30K/gVCH0inG+XFCbsMNNf3/PQJ49vX
         iHz6c2OggoWiI52qOShJvqG8DkAIUd2D95GxE9Voh30CdJAZi3oy4WGi3pufjTlG071A
         bY3xQN5OPOhmilPp+GXPWGeq1xKj9SQYnrVJK92KiBJYm+2sePiKppv1Amwq/mfqsKXY
         mRJsLXv88LKTsg/gxXjHb7tKfKDncX9xAWZwd1jUf9xlViUKJM1hSFgGip0q4Ns1tna6
         803g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=h3RwRgkH3viEGiVwk/Kgcg86FthLy8sfCzc8sgc8x6g=;
        b=CEkBG2SH2yQFQ0N/BWR6+CGE7vu9cGm5+q9VraQRfl8WqqhsMTi8eaeGQUBxUbL44q
         S+/kAuQxH0RZYdxj+PD+fU6MnQkQTHJUMOADjWPKCfmykW+0cwOmmmu41xDDQEvrOM8v
         56nwOKAgos1EYN0D/6oXvqx/oFH7c5/m0buBJi+DugG3VYdC1KxOKtB24je50d/GkSHa
         M9bI+y0Wps7InV57EmSQdiO2/lRhpO4gY0S7xj3fPCfNAPLmqcYKOYMKJzjslxqjiwxd
         9Wnaeai04eoYID/Fr8sECHuvKVI3j4fCjkfgtPu/SP1y0/8GwbUgWctHWsZDN7a907q6
         gUMQ==
X-Gm-Message-State: AOAM532wDsjNnTmoZDTycbq76Dz9HPhPU4TDSKd5T75d98u739cLZhob
        q2DuPQBl69Ms4/ERv2mTU1dlyP9n3Ak=
X-Google-Smtp-Source: ABdhPJyFrnV1rrk/NTa+jhcmzHIM6bDAAj7JaQLfoXiXnGj8jlCJSVCAbWSCLy3A5amhaXjqwUPVHbqklrY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:248a:b0:51b:f461:8318 with SMTP id
 c10-20020a056a00248a00b0051bf4618318mr6300396pfv.47.1655237295488; Tue, 14
 Jun 2022 13:08:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:07:00 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-36-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 35/42] KVM: selftests: Drop unnecessary use of kvm_get_supported_cpuid_index()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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

Use kvm_get_supported_cpuid_entry() instead of
kvm_get_supported_cpuid_index() when passing in '0' for the index, which
just so happens to be the case in all remaining users of
kvm_get_supported_cpuid_index() except kvm_get_supported_cpuid_entry().

Keep the helper as there may be users in the future, and it's not doing
any harm.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/amx_test.c              | 2 +-
 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c | 4 ++--
 tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index a886c9e81b87..411a33cd4296 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -318,7 +318,7 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XTILEDATA));
 
 	/* Get xsave/restore max size */
-	xsave_restore_size = kvm_get_supported_cpuid_index(0xd, 0)->ecx;
+	xsave_restore_size = kvm_get_supported_cpuid_entry(0xd)->ecx;
 
 	run = vcpu->run;
 	vcpu_regs_get(vcpu, &regs1);
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 090d9c5e1c14..9179e1377bc1 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -402,7 +402,7 @@ static bool use_intel_pmu(void)
 {
 	const struct kvm_cpuid_entry2 *entry;
 
-	entry = kvm_get_supported_cpuid_index(0xa, 0);
+	entry = kvm_get_supported_cpuid_entry(0xa);
 	return is_intel_cpu() && check_intel_pmu_leaf(entry);
 }
 
@@ -434,7 +434,7 @@ static bool use_amd_pmu(void)
 {
 	const struct kvm_cpuid_entry2 *entry;
 
-	entry = kvm_get_supported_cpuid_index(1, 0);
+	entry = kvm_get_supported_cpuid_entry(1);
 	return is_amd_cpu() &&
 		(is_zen1(entry->eax) ||
 		 is_zen2(entry->eax) ||
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index 689517f2aae6..6ec901dab61e 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -69,7 +69,7 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_PDCM));
 
 	TEST_REQUIRE(kvm_get_cpuid_max_basic() >= 0xa);
-	entry_a_0 = kvm_get_supported_cpuid_index(0xa, 0);
+	entry_a_0 = kvm_get_supported_cpuid_entry(0xa);
 
 	eax.full = entry_a_0->eax;
 	__TEST_REQUIRE(eax.split.version_id, "PMU is not supported by the vCPU");
-- 
2.36.1.476.g0c4daa206d-goog

