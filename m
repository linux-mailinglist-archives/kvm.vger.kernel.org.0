Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAAD54BB7A
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356831AbiFNUJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357390AbiFNUIE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:08:04 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1656EE2C
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:58 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id k10-20020a170902ce0a00b0016774f4a707so5334849plg.22
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=23Eq/JZXCr5ZESFLdA8mGk7iqKBFVcqZyF81SwbEVZM=;
        b=RZjhh4TeZyIoaM2EyrlYwJRdn0z7RGpPjZ1d48u6k5pF+BR8SW75Ymt/vhe5vcJS0d
         FwITp1anv20mqLl9pwoNzTm6zLuq+1UjDOAV9MYSl9VPtXZjdIE8mnQv/F0bSLN6Xl+P
         xUJcin4+BxjllggdfSEbMpBGvfLchuLG+3BrumI23xrenipl88VhEdnGM1RfUmYeO/Yh
         Qu7MEl45nl6XTY/Ge+3hlyzpPKL9PbET8UOIXVJz/f9a20OljWw+/6zu9OCn/xEd9hmh
         ORq9OEUdpCZOEqAm7w9U9EGCTkHFLuFyTnVtiUxPxczY9DDeZWcVdhOCI2/ieTcXEf85
         pH7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=23Eq/JZXCr5ZESFLdA8mGk7iqKBFVcqZyF81SwbEVZM=;
        b=JnWk+jHpSYGJWV7T00ejx0BBLZTDdq4iAaJov7TB0jmQmP+ykNeiAQJQPMvKXQpIdN
         obPJjemMCEuBCePS+Q9AAY0FVsphVL5jVfs3ghmiTX25oOgdxdmyCd/YH6Ahrv3XWG7Y
         D/IOjK5Z9bgCxcfe4iLXGmpQ2vME2yxAWD7+squpy2j770cy9oDx6ira1PXs8xmc0ZzC
         +sBoeoVwhNNFvR7zPEnXWe8V08A17PSXT6Ov22uJ28imOrF3SzykXULUOPfsl9qRjUbC
         JWKp+s9dBCVYwVuvi60wsBIuy7fj1DTRVzG7Cxut1/5SUqgz6TuxEuIUPAeRcpeRsurD
         JHWA==
X-Gm-Message-State: AJIora864/pnOLZGTrOXhrpnbwe3FQJpenv6KqHgLjwGh9deGaWx9xcf
        yh49mX5qUlQZ1kozCkgJvUEuPAvWS2I=
X-Google-Smtp-Source: AGRyM1tYZu8naFBrPOdwNY8kQHUsmExve1u10RgmcgbOUsZASefh0dCXTNMyGlGcwSOHtj8di5Fm+kDBgc0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:178f:b0:1e3:3ba:c185 with SMTP id
 q15-20020a17090a178f00b001e303bac185mr192391pja.1.1655237277256; Tue, 14 Jun
 2022 13:07:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:50 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-26-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 25/42] KVM: selftests: Use vcpu_get_cpuid_entry() in PV
 features test (sort of)
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

Add a new helper, vcpu_clear_cpuid_entry(), to do a RMW operation on the
vCPU's CPUID model to clear a given CPUID entry, and use it to clear
KVM's paravirt feature instead of operating on kvm_get_supported_cpuid()'s
static "cpuid" variable.  This also eliminates a user of
the soon-be-defunct set_cpuid() helper.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/x86_64/processor.h |  1 +
 tools/testing/selftests/kvm/lib/x86_64/processor.c   | 11 +++++++++++
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c     | 12 +-----------
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 2097822b4b98..65f3a828c903 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -658,6 +658,7 @@ static inline void vcpu_set_cpuid(struct kvm_vcpu *vcpu)
 
 void vcpu_set_cpuid_maxphyaddr(struct kvm_vcpu *vcpu, uint8_t maxphyaddr);
 
+void vcpu_clear_cpuid_entry(struct kvm_vcpu *vcpu, uint32_t function);
 void vcpu_set_or_clear_cpuid_feature(struct kvm_vcpu *vcpu,
 				     struct kvm_x86_cpu_feature feature,
 				     bool set);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index cdc35dd765e7..99f72f3b4382 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -770,6 +770,17 @@ void vcpu_set_cpuid_maxphyaddr(struct kvm_vcpu *vcpu, uint8_t maxphyaddr)
 	vcpu_set_cpuid(vcpu);
 }
 
+void vcpu_clear_cpuid_entry(struct kvm_vcpu *vcpu, uint32_t function)
+{
+	struct kvm_cpuid_entry2 *entry = vcpu_get_cpuid_entry(vcpu, function);
+
+	entry->eax = 0;
+	entry->ebx = 0;
+	entry->ecx = 0;
+	entry->edx = 0;
+	vcpu_set_cpuid(vcpu);
+}
+
 void vcpu_set_or_clear_cpuid_feature(struct kvm_vcpu *vcpu,
 				     struct kvm_x86_cpu_feature feature,
 				     bool set)
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index e3bb9b803944..7ab61f3f2a20 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -142,15 +142,6 @@ static void guest_main(void)
 	GUEST_DONE();
 }
 
-static void clear_kvm_cpuid_features(struct kvm_cpuid2 *cpuid)
-{
-	struct kvm_cpuid_entry2 ent = {0};
-
-	ent.function = KVM_CPUID_FEATURES;
-	TEST_ASSERT(set_cpuid(cpuid, &ent),
-		    "failed to clear KVM_CPUID_FEATURES leaf");
-}
-
 static void pr_msr(struct ucall *uc)
 {
 	struct msr_data *msr = (struct msr_data *)uc->args[0];
@@ -209,8 +200,7 @@ int main(void)
 
 	vcpu_enable_cap(vcpu, KVM_CAP_ENFORCE_PV_FEATURE_CPUID, 1);
 
-	clear_kvm_cpuid_features(vcpu->cpuid);
-	vcpu_set_cpuid(vcpu);
+	vcpu_clear_cpuid_entry(vcpu, KVM_CPUID_FEATURES);
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
-- 
2.36.1.476.g0c4daa206d-goog

