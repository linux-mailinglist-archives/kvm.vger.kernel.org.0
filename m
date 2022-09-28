Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADDD5EE49B
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 20:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbiI1StH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 14:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbiI1StD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 14:49:03 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E77EE64A
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 11:49:03 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-348608c1cd3so129694417b3.10
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 11:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=kNivHvkTfJ+yPNbnCQHmVT7RJoeYMuelFjHCvwGl40k=;
        b=p3C7inZehvDCabcc/FNC093HNyhGdwesyAZmYdGvzDVfDkxlPY8nwxujCoCP/6gB6/
         Wi8GyCxzFQGyx1R85Dz3ceK6qJZCT1Sn1fWWWBJwBlRjFsT6/Lu2a8c07BUWysK2cWQE
         kn0izqTltfcp1gYfYXkE7MLJIR2IsMyd2yq4m2AZBGsIFGwAHhNYWrvuhJe7Y+imwQ4g
         zfzftdfOIIz31MDiz6rpmvbZzSti+aXdkpCOlVFFc/kACdismRgQYjT0TTTbWHdC53El
         ucXy41P1RYP59Uc8U6XGKHJQ/Z9+j5Jt+0BnYqKbwQW4NDAKh5VrJLWElyg3esK0giIH
         XiXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=kNivHvkTfJ+yPNbnCQHmVT7RJoeYMuelFjHCvwGl40k=;
        b=6Uy4z9GXbgAkdCrfaHYtXoykxi4yJJH9QNphDrsRV7XAC2kRvdxELrTjZ7gN6dmy8E
         HjHLmQSJZdDDQ0/EFVs4scjcYT1Pa29OGJ2c/+rQ9UXCXMirsfPHOSzjojxqJZVOFRtf
         3sPqkzbVmkOVylkrEViPz2tVnryhLO3WDoPjA7y2ltlMzGiptrM29K3iT4suLMiiubVo
         yLuwGag+Bu/JIfdP35rBN0EhSj0SAKpXdhB+v2ztgdxarkdVdQWLltUvZDoT4DrvYnEb
         dR+8c//F+vV0nuSg+LPBzG5AcnmbiVPsE/oGCjuxpmELlBHXjp/nAtTPQFhOCTKTHz8P
         lI/Q==
X-Gm-Message-State: ACrzQf0epynFOqPxzCElpms8PsiSBWBTQ5/U8/2kNSq0rGVplcK4aW0G
        CQNZ72NID1i/28vyte0F6HOD5gxoDTd2Ow==
X-Google-Smtp-Source: AMsMyM5mqcPv3vMEsQnQF8EvSOfSZ4Pt5YMWRPDsByPEb5hbG/tfKlx4TQwhJBt4sb8WQCXfP8dGkyUKPuq4qQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:86c1:0:b0:6bc:9ad2:fb64 with SMTP id
 y1-20020a2586c1000000b006bc9ad2fb64mr1352381ybm.228.1664390942403; Wed, 28
 Sep 2022 11:49:02 -0700 (PDT)
Date:   Wed, 28 Sep 2022 11:48:52 -0700
In-Reply-To: <20220928184853.1681781-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220928184853.1681781-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220928184853.1681781-3-dmatlack@google.com>
Subject: [PATCH v2 2/3] KVM: selftests: Add helper to read boolean module parameters
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>, kvm@vger.kernel.org
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

Add a common helper function for reading boolean module parameters and
use it in vm_is_unrestricted_guest() to check the value of
kvm_intel.unrestricted_guest.

Note that vm_is_unrestricted_guest() will now fail with a TEST_ASSERT()
if called on AMD instead of just returning false. However this should
not cause any functional change since all of the callers of
vm_is_unrestricted_guest() first check is_intel_cpu().

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../testing/selftests/kvm/include/test_util.h |  1 +
 tools/testing/selftests/kvm/lib/test_util.c   | 31 +++++++++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 13 +-------
 3 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index befc754ce9b3..4f119fd84ae5 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -108,6 +108,7 @@ struct vm_mem_backing_src_alias {
 
 #define MIN_RUN_DELAY_NS	200000UL
 
+bool get_module_param_bool(const char *module_name, const char *param);
 bool thp_configured(void);
 size_t get_trans_hugepagesz(void);
 size_t get_def_hugetlb_pagesz(void);
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 6d23878bbfe1..479e482d3202 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -9,6 +9,7 @@
 #include <ctype.h>
 #include <limits.h>
 #include <stdlib.h>
+#include <stdio.h>
 #include <time.h>
 #include <sys/stat.h>
 #include <sys/syscall.h>
@@ -114,6 +115,36 @@ void print_skip(const char *fmt, ...)
 	puts(", skipping test");
 }
 
+bool get_module_param_bool(const char *module_name, const char *param)
+{
+	const int path_size = 1024;
+	char path[path_size];
+	char value;
+	FILE *f;
+	int r;
+
+	r = snprintf(path, path_size, "/sys/module/%s/parameters/%s",
+		     module_name, param);
+	TEST_ASSERT(r < path_size,
+		    "Failed to construct sysfs path in %d bytes.", path_size);
+
+	f = fopen(path, "r");
+	TEST_ASSERT(f, "fopen(%s) failed", path);
+
+	r = fread(&value, 1, 1, f);
+	TEST_ASSERT(r == 1, "fread(%s) failed", path);
+
+	r = fclose(f);
+	TEST_ASSERT(!r, "fclose(%s) failed", path);
+
+	if (value == 'Y')
+		return true;
+	else if (value == 'N')
+		return false;
+
+	TEST_FAIL("Unrecognized value: %c", value);
+}
+
 bool thp_configured(void)
 {
 	int ret;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 2e6e61bbe81b..522d3e2009fb 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1294,20 +1294,9 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 /* Returns true if kvm_intel was loaded with unrestricted_guest=1. */
 bool vm_is_unrestricted_guest(struct kvm_vm *vm)
 {
-	char val = 'N';
-	size_t count;
-	FILE *f;
-
 	/* Ensure that a KVM vendor-specific module is loaded. */
 	if (vm == NULL)
 		close(open_kvm_dev_path_or_exit());
 
-	f = fopen("/sys/module/kvm_intel/parameters/unrestricted_guest", "r");
-	if (f) {
-		count = fread(&val, sizeof(char), 1, f);
-		TEST_ASSERT(count == 1, "Unable to read from param file.");
-		fclose(f);
-	}
-
-	return val == 'Y';
+	return get_module_param_bool("kvm_intel", "unrestricted_guest");
 }
-- 
2.37.3.998.g577e59143f-goog

