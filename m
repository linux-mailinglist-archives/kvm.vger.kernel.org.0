Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31CC254BB53
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238684AbiFNUHd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350914AbiFNUHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:07:21 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82414D9C9
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:20 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id b9-20020a656689000000b003f672946300so5427916pgw.16
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=yVOVbpSs8meRSwOuAAzFlzcoWe8mEuzABJ9vClZbdV8=;
        b=b0vt+aJdZXu3gcnC37y/5e+nUMyiMnti+YljfyQH7TKjOBYB1863wGkYlxkdqIHY0p
         SRxHhk8DMTFh8GIqpZ+eIz1bRFutZOG1j82+Klk06fpYOOjg2oO5ZSfk5KSxBxHcRii2
         0aXtbkoHXjEFRv8GX8S0m82cwgVu9harL1y/CvD0WfoojpZKfXuL4KWJskjLxsIodbo3
         MAtZpOKYSpGv9aD4eguoGr4VMqbckuV3n8jGm2StS/gZuRZ5Csv4oaSSD3yOJirNbiuL
         M3HlbA72vsbMsYtL2E2yK6NLYAgkOuBRoVMfQw6ZRu9h7LN9zAW0xBl2bFAyMKYeCA5P
         gV7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=yVOVbpSs8meRSwOuAAzFlzcoWe8mEuzABJ9vClZbdV8=;
        b=BE3T+82Q+iefmKS8CBkHzpswK5e9ZKnkebXMGjQNaPcWSpUgLjhlgREmtvTQFF1QW1
         HVGlSWlRT1dQvTtpdCK8zuXe3qR8cGua73iVHGyu02QZ7GvxoBVpzk7PFOMzZtg2aRN9
         o/a0yqj9dX4Kudg5IlDVSuk10QrriiiF2Jv1qtU7aGdmFIB8R9kk56FIn3ZXNfECn1Nt
         Fa5eafQOgECdhnS1EEpEPQiDbIrRutWMmqTEcPV/6wUBW0XNmqcy/zRx0j/6dKoHBp1I
         tIYl/NF+fyt6H025N/lieAi7zt2sBfGOhOEEfDoiRxP+OfSP3l7eSO8EHLyfWRYiMPYt
         9HXQ==
X-Gm-Message-State: AJIora9E9s5bF89GzsOvPgQyTQlznD4Grjcwd+mjU2mojui0iLseAEgQ
        vw0XNFggNkCPTVqSIG/tv++UUrdRqlI=
X-Google-Smtp-Source: AGRyM1tteAYoZg835mQqJ4PAc0QqFzsuk2Zip7QKmP5O7OvvtmePboUPr90NwUfweM2Iv43VIwG1mUjxaPc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:b407:b0:168:e554:33be with SMTP id
 x7-20020a170902b40700b00168e55433bemr5948707plr.130.1655237240171; Tue, 14
 Jun 2022 13:07:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:29 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 04/42] KVM: selftests: Use kvm_cpu_has() in the SEV
 migration test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use kvm_cpu_has() in the SEV migration test instead of open coding
equivalent functionality using kvm_get_supported_cpuid_entry().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h        |  2 ++
 .../selftests/kvm/x86_64/sev_migrate_tests.c        | 13 ++-----------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index ee3f7239cea7..e1f9aa34f90a 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -127,6 +127,8 @@ struct kvm_x86_cpu_feature {
 #define X86_FEATURE_PAUSEFILTER         KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 10)
 #define X86_FEATURE_PFTHRESHOLD         KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 12)
 #define	X86_FEATURE_VGIF		KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 16)
+#define X86_FEATURE_SEV			KVM_X86_CPU_FEATURE(0x8000001F, 0, EAX, 1)
+#define X86_FEATURE_SEV_ES		KVM_X86_CPU_FEATURE(0x8000001F, 0, EAX, 3)
 
 /* CPUID.1.ECX */
 #define CPUID_VMX		(1ul << 5)
diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index 76ba6fc80e37..56a5932165ce 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -393,23 +393,14 @@ static void test_sev_move_copy(void)
 	kvm_vm_free(sev_vm);
 }
 
-#define X86_FEATURE_SEV (1 << 1)
-#define X86_FEATURE_SEV_ES (1 << 3)
-
 int main(int argc, char *argv[])
 {
-	struct kvm_cpuid_entry2 *cpuid;
-
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM));
 
-	cpuid = kvm_get_supported_cpuid_entry(0x80000000);
-	TEST_REQUIRE(cpuid->eax >= 0x8000001f);
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV));
 
-	cpuid = kvm_get_supported_cpuid_entry(0x8000001f);
-	TEST_REQUIRE(cpuid->eax & X86_FEATURE_SEV);
-
-	have_sev_es = !!(cpuid->eax & X86_FEATURE_SEV_ES);
+	have_sev_es = kvm_cpu_has(X86_FEATURE_SEV_ES);
 
 	if (kvm_check_cap(KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM)) {
 		test_sev_migrate_from(/* es= */ false);
-- 
2.36.1.476.g0c4daa206d-goog

