Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3DF549C92
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 21:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241927AbiFMTA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 15:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345596AbiFMTAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 15:00:21 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FC0996A1
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 09:19:52 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s205-20020a632cd6000000b003fdb97e6951so3617002pgs.7
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 09:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9I7uKltHXpoc1RbLfcPLJVsVfHZ0eCsgaFUexrTgf3o=;
        b=leF5nhpioM8/CvtViFOo+grXyz0OsGK1bY6iZu/BgiX3CYsUWq/uconuCVaEyVjYr5
         EjeWA7/uDmZOGHXjUrKh3yixhtBbyll86EkMjZNqa1MyiauusB2D9llB6uEATIyavsVK
         xQjQwQiuA51TaMzyY9TQQ86zjsPN/1hjSWtI6TWwKWZ0taUoUwpSZwrP8ovBgnyQX6AC
         aQzAYM1ZGN1/9uJmgKkgId/GOf/HIcAAIqbu3bLYph3iYAWSBkhr96IWme6uyYQpKAi+
         2eeO8Rrz/btlnjF8/hGbnJNBQk5kLysMGlgVNW1J2TMddBUG2VG4ciZEtn8n5kpiuvv+
         hSFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9I7uKltHXpoc1RbLfcPLJVsVfHZ0eCsgaFUexrTgf3o=;
        b=KQAucFgO7312PnkNQ2IucTYBuMrQ2fy8jfdurxZzOd2l/ztvtdT9J6ZanZpEAsXzKl
         80fbigN2Rb/T1rDV+uEFOb5JfYBoFKdKhQUJtVfq8O12P+LSxv8GkwgIoEsrIZ+ctgKf
         7oGNeN2hMMIaxtxhrtLTQshK9sGx2ZOJnNQJden1ier+uIDQUkpzcGZjlyIpB61gfSZQ
         AtkKhMOC3MfQTmzy1QUnT3JCCOwPVpoFbJ5Q0+AGGAcHVUnHii/NgQM9R+mhP0oXhVvT
         xkIw5w5m9E9ZGNOREIbGNDQIV/DNHaFPnkOdCvQSu//3tgmiNBI8V4kqI4xT4IlIcmeh
         XUWw==
X-Gm-Message-State: AOAM532N6efvWPIAlUHYejuIHX1/RzfSytYmv3VoKwYpHTkZdRVtfiFP
        jic02dpyJDpCWg8Fw0H4kTC/5bOyb2I=
X-Google-Smtp-Source: ABdhPJz8x1yIAtSxTa0tDxdlfCIfJiE7WTFroIqwwhK+N/PnOZQuD+1B2/qyzYmUbBAqlYazonHvQR7eY8w=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:c5:b0:51b:c452:47ce with SMTP id
 e5-20020a056a0000c500b0051bc45247cemr122700pfj.52.1655137192373; Mon, 13 Jun
 2022 09:19:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 13 Jun 2022 16:19:42 +0000
In-Reply-To: <20220613161942.1586791-1-seanjc@google.com>
Message-Id: <20220613161942.1586791-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220613161942.1586791-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH 4/4] KVM: selftests: Use kvm_has_cap(), not kvm_check_cap(),
 where possible
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Replace calls to kvm_check_cap() that treat its return as a boolean with
calls to kvm_has_cap().  Several instances of kvm_check_cap() were missed
when kvm_has_cap() was introduced.

Reported-by: Andrew Jones <drjones@redhat.com>
Fixes: 3ea9b809650b ("KVM: selftests: Add kvm_has_cap() to provide syntactic sugar")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/psci_test.c            | 2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c         | 4 ++--
 tools/testing/selftests/kvm/s390x/sync_regs_test.c         | 2 +-
 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c | 2 +-
 tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c     | 6 +++---
 tools/testing/selftests/kvm/x86_64/smm_test.c              | 2 +-
 tools/testing/selftests/kvm/x86_64/state_test.c            | 2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index a889e1cf5e4d..b665b534cb78 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -192,7 +192,7 @@ static void host_test_system_suspend(void)
 
 int main(void)
 {
-	TEST_REQUIRE(kvm_check_cap(KVM_CAP_ARM_SYSTEM_SUSPEND));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_SYSTEM_SUSPEND));
 
 	host_test_cpu_on();
 	host_test_system_suspend();
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 4a7de11d6f37..906132e70fa4 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -991,7 +991,7 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vcpu *vcpu)
 	vcpu_regs_get(vcpu, &state->regs);
 	vcpu_save_xsave_state(vcpu, state);
 
-	if (kvm_check_cap(KVM_CAP_XCRS))
+	if (kvm_has_cap(KVM_CAP_XCRS))
 		vcpu_xcrs_get(vcpu, &state->xcrs);
 
 	vcpu_sregs_get(vcpu, &state->sregs);
@@ -1022,7 +1022,7 @@ void vcpu_load_state(struct kvm_vcpu *vcpu, struct kvm_x86_state *state)
 	vcpu_sregs_set(vcpu, &state->sregs);
 	vcpu_msrs_set(vcpu, &state->msrs);
 
-	if (kvm_check_cap(KVM_CAP_XCRS))
+	if (kvm_has_cap(KVM_CAP_XCRS))
 		vcpu_xcrs_set(vcpu, &state->xcrs);
 
 	vcpu_xsave_set(vcpu,  state->xsave);
diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
index b69710822c47..3fdb6e2598eb 100644
--- a/tools/testing/selftests/kvm/s390x/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
@@ -229,7 +229,7 @@ int main(int argc, char *argv[])
 	struct kvm_vm *vm;
 	int idx;
 
-	TEST_REQUIRE(kvm_check_cap(KVM_CAP_SYNC_REGS));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_SYNC_REGS));
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 786b3a794f84..530a75fee92c 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -450,7 +450,7 @@ int main(int argc, char *argv[])
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	TEST_REQUIRE(kvm_check_cap(KVM_CAP_PMU_EVENT_FILTER));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_PMU_EVENT_FILTER));
 
 	TEST_REQUIRE(use_intel_pmu() || use_amd_pmu());
 	guest_code = use_intel_pmu() ? intel_guest_code : amd_guest_code;
diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index 76ba6fc80e37..46018b247a04 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -411,16 +411,16 @@ int main(int argc, char *argv[])
 
 	have_sev_es = !!(cpuid->eax & X86_FEATURE_SEV_ES);
 
-	if (kvm_check_cap(KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM)) {
+	if (kvm_has_cap(KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM)) {
 		test_sev_migrate_from(/* es= */ false);
 		if (have_sev_es)
 			test_sev_migrate_from(/* es= */ true);
 		test_sev_migrate_locking();
 		test_sev_migrate_parameters();
-		if (kvm_check_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM))
+		if (kvm_has_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM))
 			test_sev_move_copy();
 	}
-	if (kvm_check_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM)) {
+	if (kvm_has_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM)) {
 		test_sev_mirror(/* es= */ false);
 		if (have_sev_es)
 			test_sev_mirror(/* es= */ true);
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index 3cd1da388b52..921cbf117329 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -153,7 +153,7 @@ int main(int argc, char *argv[])
 
 	vcpu_set_msr(vcpu, MSR_IA32_SMBASE, SMRAM_GPA);
 
-	if (kvm_check_cap(KVM_CAP_NESTED_STATE)) {
+	if (kvm_has_cap(KVM_CAP_NESTED_STATE)) {
 		if (nested_svm_supported())
 			vcpu_alloc_svm(vm, &nested_gva);
 		else if (nested_vmx_supported())
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index 0bcd78cf7c79..e2f1f35e51ff 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -169,7 +169,7 @@ int main(int argc, char *argv[])
 
 	vcpu_regs_get(vcpu, &regs1);
 
-	if (kvm_check_cap(KVM_CAP_NESTED_STATE)) {
+	if (kvm_has_cap(KVM_CAP_NESTED_STATE)) {
 		if (nested_svm_supported())
 			vcpu_alloc_svm(vm, &nested_gva);
 		else if (nested_vmx_supported())
-- 
2.36.1.476.g0c4daa206d-goog

