Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818485EFCC1
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 20:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235024AbiI2SMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 14:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234990AbiI2SMS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 14:12:18 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49871F495A
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 11:12:17 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h4-20020a5b02c4000000b006bc192d672bso1778084ybp.22
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 11:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=WdOhHa7+GA5s0KZZ8XCKCE1bphG4OAXLOkA0pJgE3Os=;
        b=stjYVUwzQIbd/qgTXMD6yVI4oxEVUDDoi64OB50zDr64OYNLsqXdI1H0tAiA+WXtzL
         Q/FNKP4aJT6FdjXtVZrgwyHj585ghCU/XlXTOy/QYXLhG22XUR3iAhl2I20qFI/NcAGN
         /A4uzLyYVxHlQfPURb4pF0fVUGql48YfH+I3LHPSyZ8pJrDKJgXQF8Luo9jywb6cetHz
         szaQiIFXSpDhxvskjYH3G3r4i6FQOb0v01pVYLfztMrG3q1UqkwQ+LnqJvuAI3vXv7Mf
         xU8+6TL6anL45leN+QHNgH7aSPCs/wPFAQ5sbHsF2VZ1AJ+e6Ka/sOrkyVyqXrWZLiNt
         t8xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=WdOhHa7+GA5s0KZZ8XCKCE1bphG4OAXLOkA0pJgE3Os=;
        b=4cJcQ7MOKXHXdaPZWdFDkj3zyKZG7XdHvF2Vruca86YddSU42qJ+Fu3nhOEZNmtZzk
         YxR/zBOZ76++22f62D3Ku5dc/3tF8GeKM6PyG2d1ekRayZ4HWyGh62g1wQfpTj+REC7H
         N3S1Oj0lXMpjJaYFmvi4HbqoY1VQHu77bssAn1EiovN0/lXfWcBozd9Zr8Kmw07CA6l4
         8hCm7AQY+8djNZrYmq1oJwX+yF+MlLEJvPdYL1fDErhjZ/CEE6YJkx/WzxDVoX2qh9hw
         GxN9TQjq42SOYU6fFdP+8JV1/NNCRtwAC+iSw3vsBrd5kwd7CJkyE++n6bn5YMZ99mIZ
         sq8g==
X-Gm-Message-State: ACrzQf0Vw1hoFUXOak7AN/eR4XQlhctJp1PsfSb/Bp8MGVlcDTMeUolA
        1KthTrBrpmYuf6mjfqegk0g5JVMqWSOERQ==
X-Google-Smtp-Source: AMsMyM5kFrw+QbXItleB5dC02orYJ5kTE8unPYNGJKaAzAwpmYLSLYo3Qrd3HTSmAxcN1vI+x5DvTd7Zh2OETg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:73d7:0:b0:352:90cc:c939 with SMTP id
 o206-20020a8173d7000000b0035290ccc939mr4517053ywc.150.1664475136900; Thu, 29
 Sep 2022 11:12:16 -0700 (PDT)
Date:   Thu, 29 Sep 2022 11:12:06 -0700
In-Reply-To: <20220929181207.2281449-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220929181207.2281449-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220929181207.2281449-3-dmatlack@google.com>
Subject: [PATCH v3 2/3] KVM: selftests: Add helpers to read kvm_{intel,amd}
 boolean module parameters
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Ricardo Koller <ricarkol@google.com>,
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

Add helper functions for reading the value of kvm_intel and kvm_amd
boolean module parameters. Use the kvm_intel variant in
vm_is_unrestricted_guest() to simplify the check for
kvm_intel.unrestricted_guest.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  4 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 39 +++++++++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 13 +------
 3 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 24fde97f6121..e42a09cd24a0 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -175,6 +175,10 @@ extern const struct vm_guest_mode_params vm_guest_mode_params[];
 
 int open_path_or_exit(const char *path, int flags);
 int open_kvm_dev_path_or_exit(void);
+
+bool get_kvm_intel_param_bool(const char *param);
+bool get_kvm_amd_param_bool(const char *param);
+
 unsigned int kvm_check_cap(long cap);
 
 static inline bool kvm_has_cap(long cap)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9889fe0d8919..504c1e1355c3 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -50,6 +50,45 @@ int open_kvm_dev_path_or_exit(void)
 	return _open_kvm_dev_path_or_exit(O_RDONLY);
 }
 
+static bool get_module_param_bool(const char *module_name, const char *param)
+{
+	const int path_size = 128;
+	char path[path_size];
+	char value;
+	ssize_t r;
+	int fd;
+
+	r = snprintf(path, path_size, "/sys/module/%s/parameters/%s",
+		     module_name, param);
+	TEST_ASSERT(r < path_size,
+		    "Failed to construct sysfs path in %d bytes.", path_size);
+
+	fd = open_path_or_exit(path, O_RDONLY);
+
+	r = read(fd, &value, 1);
+	TEST_ASSERT(r == 1, "read(%s) failed", path);
+
+	r = close(fd);
+	TEST_ASSERT(!r, "close(%s) failed", path);
+
+	if (value == 'Y')
+		return true;
+	else if (value == 'N')
+		return false;
+
+	TEST_FAIL("Unrecognized value '%c' for boolean module param", value);
+}
+
+bool get_kvm_intel_param_bool(const char *param)
+{
+	return get_module_param_bool("kvm_intel", param);
+}
+
+bool get_kvm_amd_param_bool(const char *param)
+{
+	return get_module_param_bool("kvm_amd", param);
+}
+
 /*
  * Capability
  *
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 2e6e61bbe81b..fab0f526fb81 100644
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
+	return get_kvm_intel_param_bool("unrestricted_guest");
 }
-- 
2.38.0.rc1.362.ged0d419d3c-goog

