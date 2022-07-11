Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E2A56FE83
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbiGKKNU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiGKKMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:12:25 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5F31ADA1;
        Mon, 11 Jul 2022 02:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657532032; x=1689068032;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0PjRAq8c7ozAKryjV1wb1wkTewpQijIbzSfrTn770+0=;
  b=b+pmm2Gy+ZsHIl+mwzL7zseWNtDcpoWoeW0WBRL1WTE02neceM57NIYg
   tvL5na340URjOC3Hh36ssCNDYqJV8//QQclSrzat6YkhmQoJHcdO3rCEh
   bxSyY7T1uCUpAOOoWv1uUw6SuvZLCwSOL/WwiWtf9FUVGS4LH23al19RP
   ev9GoU1OEeIj5ZMT5fLDszGE2WPFMZro//2AfgfaBzPc6mBrf3rxhVzs6
   lkO4N9sr49/tqPQOvTEDMD77VBuwcZBvj3dAvbWP1k2x/fkrf4J9TBDVE
   GFlrVaomM3oaOJOTstGtujiKBXd1+Ye6bipiOaaz1y92kj4Gx1j07By6K
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371650"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371650"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:36 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387208"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:33 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 23/35] perf tools: Add reallocarray_as_needed()
Date:   Mon, 11 Jul 2022 12:32:06 +0300
Message-Id: <20220711093218.10967-24-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220711093218.10967-1-adrian.hunter@intel.com>
References: <20220711093218.10967-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add helper reallocarray_as_needed() to reallocate an array to a larger
size and initialize the extra entries to an arbitrary value.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/util.c | 33 +++++++++++++++++++++++++++++++++
 tools/perf/util/util.h | 15 +++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 9b02edf9311d..391c1e928bd7 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/log2.h>
 #include <linux/time64.h>
+#include <linux/overflow.h>
 #include <unistd.h>
 #include "cap.h"
 #include "strlist.h"
@@ -500,3 +501,35 @@ char *filename_with_chroot(int pid, const char *filename)
 
 	return new_name;
 }
+
+/*
+ * Reallocate an array *arr of size *arr_sz so that it is big enough to contain
+ * x elements of size msz, initializing new entries to *init_val or zero if
+ * init_val is NULL
+ */
+int do_realloc_array_as_needed(void **arr, size_t *arr_sz, size_t x, size_t msz, const void *init_val)
+{
+	size_t new_sz = *arr_sz;
+	void *new_arr;
+	size_t i;
+
+	if (!new_sz)
+		new_sz = msz >= 64 ? 1 : roundup(64, msz); /* Start with at least 64 bytes */
+	while (x >= new_sz) {
+		if (check_mul_overflow(new_sz, (size_t)2, &new_sz))
+			return -ENOMEM;
+	}
+	if (new_sz == *arr_sz)
+		return 0;
+	new_arr = calloc(new_sz, msz);
+	if (!new_arr)
+		return -ENOMEM;
+	memcpy(new_arr, *arr, *arr_sz * msz);
+	if (init_val) {
+		for (i = *arr_sz; i < new_sz; i++)
+			memcpy(new_arr + (i * msz), init_val, msz);
+	}
+	*arr = new_arr;
+	*arr_sz = new_sz;
+	return 0;
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 0f78f1e7782d..c1f2d423a9ec 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -79,4 +79,19 @@ struct perf_debuginfod {
 void perf_debuginfod_setup(struct perf_debuginfod *di);
 
 char *filename_with_chroot(int pid, const char *filename);
+
+int do_realloc_array_as_needed(void **arr, size_t *arr_sz, size_t x,
+			       size_t msz, const void *init_val);
+
+#define realloc_array_as_needed(a, n, x, v) ({			\
+	typeof(x) __x = (x);					\
+	__x >= (n) ?						\
+		do_realloc_array_as_needed((void **)&(a),	\
+					   &(n),		\
+					   __x,			\
+					   sizeof(*(a)),	\
+					   (const void *)(v)) :	\
+		0;						\
+	})
+
 #endif /* GIT_COMPAT_UTIL_H */
-- 
2.25.1

