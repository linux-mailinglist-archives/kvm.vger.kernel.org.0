Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11FD53C1AD
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiFCArK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240116AbiFCAoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:54 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145D834640
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:39 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 92-20020a17090a09e500b001d917022847so3528877pjo.1
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/TXk1YTRDqd6XE4qU0TsZKT5BH5jUZR26Th7i6gBUIY=;
        b=nWGJfYnheUtAx43bAsTy5YZCtvTlmYUdB49GpmRkYkIE4oCZU7/JBgM7GwVYfSMQbL
         oxW/hH/d9dCYLAX/DQs7ZwrzUCdjNydUNxZel/YXexmmbDkPSLLTo265VgRgAc9DRfgR
         otW2Rzm44uhNv4P2tBSsd18ZQcmDCIqD5xWD4xJO06kRnc6ttsYzD3UClrPksYqQLLd3
         d4c6hJzA9XSewlv3Vm1N7VTTeFkyr9O6A7OT1qNMzX1GXI7uemTa0/lhEdsRx+ASOPKC
         BCpaBd2eBhH+uz3uAoRUrKvNIev3Rh8Tbclsh7wdabUvLZDGFrW9UGms82ZLAWbSqURz
         rahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/TXk1YTRDqd6XE4qU0TsZKT5BH5jUZR26Th7i6gBUIY=;
        b=GX2rrsyTC9OEF79nEoObdy20W95g17pM4+DDnvnk6eCRmAw+tytF+pP0YjC8yb3usb
         CRlOA13JxAs2bTG4gL0wZ6DRJM/otIztJBN7VwhdKTuOZ5aRwKGMpj9IAsoTvIuy+km1
         O+AKhaG9xRD2zyT0/2htazQ7oEg1zlcDjpJKl95cVGAmV/FuxP3TXXYtFDYcYd34drz1
         YB5WYbg6euM4EQ5Z6tmzKkoMy64Sf1Q9BmEAFJAEU1w16nWCLFTDOpDGNyGIz2VB/CO5
         uExvIFjNHePHxMCmJ8PhJNRzb1+wAL09n5aET2T/wH0eVt3gpit2HpbnV4Qrv3FN0Ney
         HFMg==
X-Gm-Message-State: AOAM531ELsnyT8hlwBuAgBo2dqVeNnRCjAsdMrw2CRnON6pApTNWzLta
        kkoclI3Pa6YTYJYZwb/KNz9hx+O93yI=
X-Google-Smtp-Source: ABdhPJx9Saru2iwqOGwzfMvOAQnA0xm+CesrE+6/QMr3FB0oyyBsHP7NGKTdaETxUiMOL1ir4EPYFz4ChWU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:2488:b0:163:b2c0:7efe with SMTP id
 p8-20020a170903248800b00163b2c07efemr7454231plw.164.1654217078523; Thu, 02
 Jun 2022 17:44:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:41 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-35-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 034/144] KVM: selftests: Dedup MSR index list helpers,
 simplify dedicated test
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

Consolidate the helper for retrieving the list of save/restore MSRs and
the list of feature MSRs, and use the common helpers in the related
get_msr_index_features test.  Switching to the common helpers eliminates
the testcase that KVM returns the same -E2BIG result if the input number
of MSRs is '1' versus '0', but considered that testcase isn't very
interesting, e.g. '0' and '1' are equally arbitrary, and certainly not
worth the additional code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |   1 +
 .../selftests/kvm/lib/x86_64/processor.c      |  39 ++++--
 .../kvm/x86_64/get_msr_index_features.c       | 112 +++---------------
 3 files changed, 46 insertions(+), 106 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index afc55f561a2c..e4268432cfe8 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -428,6 +428,7 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid,
 void kvm_x86_state_cleanup(struct kvm_x86_state *state);
 
 const struct kvm_msr_list *kvm_get_msr_index_list(void);
+const struct kvm_msr_list *kvm_get_feature_msr_index_list(void);
 bool kvm_msr_is_in_save_restore_list(uint32_t msr_index);
 uint64_t kvm_get_feature_msr(uint64_t msr_index);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 5d161d0b8a0c..a6c35f269013 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -892,19 +892,20 @@ void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
 	sregs_dump(stream, &sregs, indent + 4);
 }
 
-const struct kvm_msr_list *kvm_get_msr_index_list(void)
+static struct kvm_msr_list *__kvm_get_msr_index_list(bool feature_msrs)
 {
-	static struct kvm_msr_list *list;
+	struct kvm_msr_list *list;
 	struct kvm_msr_list nmsrs;
 	int kvm_fd, r;
 
-	if (list)
-		return list;
-
 	kvm_fd = open_kvm_dev_path_or_exit();
 
 	nmsrs.nmsrs = 0;
-	r = __kvm_ioctl(kvm_fd, KVM_GET_MSR_INDEX_LIST, &nmsrs);
+	if (!feature_msrs)
+		r = __kvm_ioctl(kvm_fd, KVM_GET_MSR_INDEX_LIST, &nmsrs);
+	else
+		r = __kvm_ioctl(kvm_fd, KVM_GET_MSR_FEATURE_INDEX_LIST, &nmsrs);
+
 	TEST_ASSERT(r == -1 && errno == E2BIG,
 		    "Expected -E2BIG, got rc: %i errno: %i (%s)",
 		    r, errno, strerror(errno));
@@ -913,15 +914,37 @@ const struct kvm_msr_list *kvm_get_msr_index_list(void)
 	TEST_ASSERT(list, "-ENOMEM when allocating MSR index list");
 	list->nmsrs = nmsrs.nmsrs;
 
-	kvm_ioctl(kvm_fd, KVM_GET_MSR_INDEX_LIST, list);
+	if (!feature_msrs)
+		kvm_ioctl(kvm_fd, KVM_GET_MSR_INDEX_LIST, list);
+	else
+		kvm_ioctl(kvm_fd, KVM_GET_MSR_FEATURE_INDEX_LIST, list);
 	close(kvm_fd);
 
 	TEST_ASSERT(list->nmsrs == nmsrs.nmsrs,
-		    "Number of save/restore MSRs changed, was %d, now %d",
+		    "Number of MSRs in list changed, was %d, now %d",
 		    nmsrs.nmsrs, list->nmsrs);
 	return list;
 }
 
+const struct kvm_msr_list *kvm_get_msr_index_list(void)
+{
+	static const struct kvm_msr_list *list;
+
+	if (!list)
+		list = __kvm_get_msr_index_list(false);
+	return list;
+}
+
+
+const struct kvm_msr_list *kvm_get_feature_msr_index_list(void)
+{
+	static const struct kvm_msr_list *list;
+
+	if (!list)
+		list = __kvm_get_msr_index_list(true);
+	return list;
+}
+
 bool kvm_msr_is_in_save_restore_list(uint32_t msr_index)
 {
 	const struct kvm_msr_list *list = kvm_get_msr_index_list();
diff --git a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
index 4ef60adbe108..1e366fdfe7be 100644
--- a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
+++ b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
@@ -15,108 +15,24 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-static int kvm_num_index_msrs(int kvm_fd, int nmsrs)
+int main(int argc, char *argv[])
 {
-	struct kvm_msr_list *list;
-	int r;
-
-	list = malloc(sizeof(*list) + nmsrs * sizeof(list->indices[0]));
-	list->nmsrs = nmsrs;
-	r = ioctl(kvm_fd, KVM_GET_MSR_INDEX_LIST, list);
-	TEST_ASSERT(r == -1 && errno == E2BIG,
-				"Unexpected result from KVM_GET_MSR_INDEX_LIST probe, r: %i",
-				r);
-
-	r = list->nmsrs;
-	free(list);
-	return r;
-}
-
-static void test_get_msr_index(void)
-{
-	int old_res, res, kvm_fd;
-	struct kvm_msr_list *list;
-
-	kvm_fd = open_kvm_dev_path_or_exit();
-
-	old_res = kvm_num_index_msrs(kvm_fd, 0);
-	TEST_ASSERT(old_res != 0, "Expecting nmsrs to be > 0");
-
-	if (old_res != 1) {
-		res = kvm_num_index_msrs(kvm_fd, 1);
-		TEST_ASSERT(res > 1, "Expecting nmsrs to be > 1");
-		TEST_ASSERT(res == old_res, "Expecting nmsrs to be identical");
-	}
-
-	list = malloc(sizeof(*list) + old_res * sizeof(list->indices[0]));
-	list->nmsrs = old_res;
-	kvm_ioctl(kvm_fd, KVM_GET_MSR_INDEX_LIST, list);
-
-	TEST_ASSERT(list->nmsrs == old_res, "Expecting nmsrs to be identical");
-	free(list);
-
-	close(kvm_fd);
-}
-
-static int kvm_num_feature_msrs(int kvm_fd, int nmsrs)
-{
-	struct kvm_msr_list *list;
-	int r;
-
-	list = malloc(sizeof(*list) + nmsrs * sizeof(list->indices[0]));
-	list->nmsrs = nmsrs;
-	r = __kvm_ioctl(kvm_fd, KVM_GET_MSR_FEATURE_INDEX_LIST, list);
-	TEST_ASSERT(r == -1 && errno == E2BIG,
-		"Unexpected result from KVM_GET_MSR_FEATURE_INDEX_LIST probe, r: %i",
-				r);
-
-	r = list->nmsrs;
-	free(list);
-	return r;
-}
-
-struct kvm_msr_list *kvm_get_msr_feature_list(int kvm_fd, int nmsrs)
-{
-	struct kvm_msr_list *list;
-
-	list = malloc(sizeof(*list) + nmsrs * sizeof(list->indices[0]));
-	list->nmsrs = nmsrs;
-	kvm_ioctl(kvm_fd, KVM_GET_MSR_FEATURE_INDEX_LIST, list);
-
-	return list;
-}
-
-static void test_get_msr_feature(void)
-{
-	int res, old_res, i, kvm_fd;
-	struct kvm_msr_list *feature_list;
-
-	kvm_fd = open_kvm_dev_path_or_exit();
-
-	old_res = kvm_num_feature_msrs(kvm_fd, 0);
-	TEST_ASSERT(old_res != 0, "Expecting nmsrs to be > 0");
-
-	if (old_res != 1) {
-		res = kvm_num_feature_msrs(kvm_fd, 1);
-		TEST_ASSERT(res > 1, "Expecting nmsrs to be > 1");
-		TEST_ASSERT(res == old_res, "Expecting nmsrs to be identical");
+	const struct kvm_msr_list *feature_list;
+	int i;
+
+	/*
+	 * Skip the entire test if MSR_FEATURES isn't supported, other tests
+	 * will cover the "regular" list of MSRs, the coverage here is purely
+	 * opportunistic and not interesting on its own.
+	 */
+	if (!kvm_check_cap(KVM_CAP_GET_MSR_FEATURES)) {
+		print_skip("KVM_CAP_GET_MSR_FEATURES not supported");
+		exit(KSFT_SKIP);
 	}
 
-	feature_list = kvm_get_msr_feature_list(kvm_fd, old_res);
-	TEST_ASSERT(old_res == feature_list->nmsrs,
-				"Unmatching number of msr indexes");
+	(void)kvm_get_msr_index_list();
 
+	feature_list = kvm_get_feature_msr_index_list();
 	for (i = 0; i < feature_list->nmsrs; i++)
 		kvm_get_feature_msr(feature_list->indices[i]);
-
-	free(feature_list);
-	close(kvm_fd);
-}
-
-int main(int argc, char *argv[])
-{
-	if (kvm_check_cap(KVM_CAP_GET_MSR_FEATURES))
-		test_get_msr_feature();
-
-	test_get_msr_index();
 }
-- 
2.36.1.255.ge46751e96f-goog

