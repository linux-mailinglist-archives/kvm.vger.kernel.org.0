Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB6653C232
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240069AbiFCApj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240095AbiFCAox (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:53 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605CE344DF
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:35 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id c4-20020a170902d48400b001640bfb2b4fso3460231plg.20
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=GAQ5rtYY2/SIzOaV7udbyKc/0bACGVyEmjMH97mKxMg=;
        b=BQlq45lzwFoBRQriXmAnNEAhaKGIO1RR+vgdA3r1AmD7PwFn1XaVAeScOss3Wt6jD5
         9ncdMwLbcg3MEnEzWqSBZJBMy65veAAxPneVBpf/m618vECk4U9QS0VYSD/08Kl3eH+1
         0rs9/OdSGwzPev7wYbsCL+Zx02R0rVxVcrBa1Lrz1neCw7vY/RjtlnVMUBS65Kx/9X9/
         ZA2moSJYmmMkF2WuRxkaw2cO7qWNYK9GUXraquoHhbMABB9UKcFV8CNwCkB8rPQDmCBE
         Ae/0TvWLG0vH/Ks1ZcsuRb0JdXy0Ns6WPrabMX6qy2+oiHM18A8qk47qm2AmAzK0whc0
         Gryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=GAQ5rtYY2/SIzOaV7udbyKc/0bACGVyEmjMH97mKxMg=;
        b=ItxhF4Lppf8g3I7fqGwy4mDGxRfJc9FpWTLOQFwVuoVtZWe1RcwgK1WtoaJLgmHEaf
         jOxkdR1vd7s0srcF5shrEsKbbCsQnJTE/s2m4jACOgMrGYPaV1u1JdWe/tN8pRsjv2Nl
         AxKcDQBZvwadLbitTS75FAGLbHdAEweGkWRNFI3r/AlW6VVuORZ4jcbcPhGbfBLowPX8
         GIR6Mrl5RGq8+/m+6jiu95g8Szgc8fj8pJV8rm+2inzfC0ZW6zwHjgu+3ImkODY3ySK5
         1l9qmAZvc8czxLqtLcCcGdA14nk9fTCHrYwARB2MWzCDkEJdNhyZB+y5sk9aFRLiU+AK
         7gVQ==
X-Gm-Message-State: AOAM532ORwOFPChPiJiaBomXtHCBOEjJp6ZRgvG2VEZ71GGljGAlGsTz
        J5+ZmKrMR9yZOWeW07mxazNB+jdUNxg=
X-Google-Smtp-Source: ABdhPJz8NwL6LdQD4GHjiWp5kcSNph8/fOPGHUsCFHYwPKucittVsr5C/domjE+h4MH3pppfG06TuGSUlD8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:6886:0:b0:3fb:fc21:7945 with SMTP id
 d128-20020a636886000000b003fbfc217945mr6678247pgc.120.1654217074837; Thu, 02
 Jun 2022 17:44:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:39 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-33-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 032/144] KVM: selftests: Cache list of MSRs to save/restore
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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

Cache the list of MSRs to save restore, mostly to justify not freeing the
list in the caller, which simplifies consumption of the list.

Opportunistically move the XSS test's so called is_supported_msr() to
common code as kvm_msr_is_in_save_restore_list().  The XSS is "supported"
by KVM, it's simply not in the save/restore list because KVM doesn't yet
allow a non-zero value.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  4 +-
 .../selftests/kvm/lib/x86_64/processor.c      | 83 +++++++++----------
 .../selftests/kvm/x86_64/xss_msr_test.c       | 27 ++----
 3 files changed, 46 insertions(+), 68 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 6fbbe28a0f39..afc55f561a2c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -427,8 +427,10 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid,
 		     struct kvm_x86_state *state);
 void kvm_x86_state_cleanup(struct kvm_x86_state *state);
 
-struct kvm_msr_list *kvm_get_msr_index_list(void);
+const struct kvm_msr_list *kvm_get_msr_index_list(void);
+bool kvm_msr_is_in_save_restore_list(uint32_t msr_index);
 uint64_t kvm_get_feature_msr(uint64_t msr_index);
+
 struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
 struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 1e3d68bdfc7d..5d161d0b8a0c 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -720,18 +720,6 @@ struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
 	return cpuid;
 }
 
-/*
- * KVM Get MSR
- *
- * Input Args:
- *   msr_index - Index of MSR
- *
- * Output Args: None
- *
- * Return: On success, value of the MSR. On failure a TEST_ASSERT is produced.
- *
- * Get value of MSR for VCPU.
- */
 uint64_t kvm_get_feature_msr(uint64_t msr_index)
 {
 	struct {
@@ -904,40 +892,49 @@ void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
 	sregs_dump(stream, &sregs, indent + 4);
 }
 
-static int kvm_get_num_msrs_fd(int kvm_fd)
+const struct kvm_msr_list *kvm_get_msr_index_list(void)
 {
+	static struct kvm_msr_list *list;
 	struct kvm_msr_list nmsrs;
-	int r;
+	int kvm_fd, r;
+
+	if (list)
+		return list;
+
+	kvm_fd = open_kvm_dev_path_or_exit();
 
 	nmsrs.nmsrs = 0;
 	r = __kvm_ioctl(kvm_fd, KVM_GET_MSR_INDEX_LIST, &nmsrs);
 	TEST_ASSERT(r == -1 && errno == E2BIG,
-		    "Unexpected result from KVM_GET_MSR_INDEX_LIST probe, r: %i", r);
+		    "Expected -E2BIG, got rc: %i errno: %i (%s)",
+		    r, errno, strerror(errno));
 
-	return nmsrs.nmsrs;
-}
+	list = malloc(sizeof(*list) + nmsrs.nmsrs * sizeof(list->indices[0]));
+	TEST_ASSERT(list, "-ENOMEM when allocating MSR index list");
+	list->nmsrs = nmsrs.nmsrs;
 
-static int kvm_get_num_msrs(struct kvm_vm *vm)
-{
-	return kvm_get_num_msrs_fd(vm->kvm_fd);
-}
-
-struct kvm_msr_list *kvm_get_msr_index_list(void)
-{
-	struct kvm_msr_list *list;
-	int nmsrs, kvm_fd;
-
-	kvm_fd = open_kvm_dev_path_or_exit();
-
-	nmsrs = kvm_get_num_msrs_fd(kvm_fd);
-	list = malloc(sizeof(*list) + nmsrs * sizeof(list->indices[0]));
-	list->nmsrs = nmsrs;
 	kvm_ioctl(kvm_fd, KVM_GET_MSR_INDEX_LIST, list);
 	close(kvm_fd);
 
+	TEST_ASSERT(list->nmsrs == nmsrs.nmsrs,
+		    "Number of save/restore MSRs changed, was %d, now %d",
+		    nmsrs.nmsrs, list->nmsrs);
 	return list;
 }
 
+bool kvm_msr_is_in_save_restore_list(uint32_t msr_index)
+{
+	const struct kvm_msr_list *list = kvm_get_msr_index_list();
+	int i;
+
+	for (i = 0; i < list->nmsrs; ++i) {
+		if (list->indices[i] == msr_index)
+			return true;
+	}
+
+	return false;
+}
+
 static int vcpu_save_xsave_state(struct kvm_vm *vm, struct vcpu *vcpu,
 				 struct kvm_x86_state *state)
 {
@@ -956,10 +953,10 @@ static int vcpu_save_xsave_state(struct kvm_vm *vm, struct vcpu *vcpu,
 
 struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
 {
+	const struct kvm_msr_list *msr_list = kvm_get_msr_index_list();
 	struct vcpu *vcpu = vcpu_get(vm, vcpuid);
-	struct kvm_msr_list *list;
 	struct kvm_x86_state *state;
-	int nmsrs, r, i;
+	int r, i;
 	static int nested_size = -1;
 
 	if (nested_size == -1) {
@@ -977,12 +974,7 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
 	 */
 	vcpu_run_complete_io(vm, vcpuid);
 
-	nmsrs = kvm_get_num_msrs(vm);
-	list = malloc(sizeof(*list) + nmsrs * sizeof(list->indices[0]));
-	list->nmsrs = nmsrs;
-	kvm_ioctl(vm->kvm_fd, KVM_GET_MSR_INDEX_LIST, list);
-
-	state = malloc(sizeof(*state) + nmsrs * sizeof(state->msrs.entries[0]));
+	state = malloc(sizeof(*state) + msr_list->nmsrs * sizeof(state->msrs.entries[0]));
 	r = ioctl(vcpu->fd, KVM_GET_VCPU_EVENTS, &state->events);
 	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_VCPU_EVENTS, r: %i",
 		    r);
@@ -1020,18 +1012,17 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
 	} else
 		state->nested.size = 0;
 
-	state->msrs.nmsrs = nmsrs;
-	for (i = 0; i < nmsrs; i++)
-		state->msrs.entries[i].index = list->indices[i];
+	state->msrs.nmsrs = msr_list->nmsrs;
+	for (i = 0; i < msr_list->nmsrs; i++)
+		state->msrs.entries[i].index = msr_list->indices[i];
 	r = ioctl(vcpu->fd, KVM_GET_MSRS, &state->msrs);
-	TEST_ASSERT(r == nmsrs, "Unexpected result from KVM_GET_MSRS, r: %i (failed MSR was 0x%x)",
-		    r, r == nmsrs ? -1 : list->indices[r]);
+	TEST_ASSERT(r == msr_list->nmsrs, "Unexpected result from KVM_GET_MSRS, r: %i (failed MSR was 0x%x)",
+		    r, r == msr_list->nmsrs ? -1 : msr_list->indices[r]);
 
 	r = ioctl(vcpu->fd, KVM_GET_DEBUGREGS, &state->debugregs);
 	TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_DEBUGREGS, r: %i",
 		    r);
 
-	free(list);
 	return state;
 }
 
diff --git a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
index 3529376747c2..7bd15f8a805c 100644
--- a/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xss_msr_test.c
@@ -17,28 +17,11 @@
 
 #define X86_FEATURE_XSAVES	(1<<3)
 
-bool is_supported_msr(u32 msr_index)
-{
-	struct kvm_msr_list *list;
-	bool found = false;
-	int i;
-
-	list = kvm_get_msr_index_list();
-	for (i = 0; i < list->nmsrs; ++i) {
-		if (list->indices[i] == msr_index) {
-			found = true;
-			break;
-		}
-	}
-
-	free(list);
-	return found;
-}
-
 int main(int argc, char *argv[])
 {
 	struct kvm_cpuid_entry2 *entry;
 	bool xss_supported = false;
+	bool xss_in_msr_list;
 	struct kvm_vm *vm;
 	uint64_t xss_val;
 	int i, r;
@@ -64,12 +47,14 @@ int main(int argc, char *argv[])
 	 * At present, KVM only supports a guest IA32_XSS value of 0. Verify
 	 * that trying to set the guest IA32_XSS to an unsupported value fails.
 	 * Also, in the future when a non-zero value succeeds check that
-	 * IA32_XSS is in the KVM_GET_MSR_INDEX_LIST.
+	 * IA32_XSS is in the list of MSRs to save/restore.
 	 */
+	xss_in_msr_list = kvm_msr_is_in_save_restore_list(MSR_IA32_XSS);
 	for (i = 0; i < MSR_BITS; ++i) {
 		r = _vcpu_set_msr(vm, VCPU_ID, MSR_IA32_XSS, 1ull << i);
-		TEST_ASSERT(r == 0 || is_supported_msr(MSR_IA32_XSS),
-			    "IA32_XSS was able to be set, but was not found in KVM_GET_MSR_INDEX_LIST.\n");
+
+		TEST_ASSERT(r == 0 || xss_in_msr_list,
+			    "IA32_XSS was able to be set, but was not in save/restore list");
 	}
 
 	kvm_vm_free(vm);
-- 
2.36.1.255.ge46751e96f-goog

