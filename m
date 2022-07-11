Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC03556FE7F
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiGKKM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbiGKKL5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:11:57 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC4455A9;
        Mon, 11 Jul 2022 02:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657532024; x=1689068024;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uv97+oKSaSLbC0t8Sjzx49zmD3D9p0QxZCe3Ik4Va4c=;
  b=CxRfHm6LOixTggnVPrTB2MAYWmmvxudcTWnDp/1yKO0rVmXYUtUszEYI
   EAj+UB/GQLw8e0aIa0Ncd93cz57mZ08h4t1uPLTAzmmDeIZZ388SshArk
   +6dADbwhg2RNpmAXFuuDy7QUr2y2pmZK59zkYfrokeEhtZESBGAjCEJMS
   iRuMXtl5lIhgw2gFyA9cgZynqoScYW1tsEIia5hzU6GoIm68K8gwUlB2w
   fn+WqYmndq5CHE+DLlaYUkVLfxjY+AUXSlaPLqmnxu9a2RrQUnLea7K9X
   uTX2BlJN9wFGspC2vrCm9yaC7b/MnG2EkzeXpyKYs+/RwrStUXo+m07qp
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371634"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371634"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:31 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387188"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:29 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 21/35] perf tools: Make has_kcore_dir() work also for guest kcore_dir
Date:   Mon, 11 Jul 2022 12:32:04 +0300
Message-Id: <20220711093218.10967-22-adrian.hunter@intel.com>
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

Copies of /proc/kallsyms, /proc/modules and an extract of /proc/kcore can
be stored in the perf.data output directory under the subdirectory named
kcore_dir. Guest machines will have their files also under subdirectories
beginning kcore_dir__ followed by the machine pid. Make has_kcore_dir()
return true also if there is a guest machine kcore_dir.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/data.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index caabeac24c69..9782ccbe595d 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -3,6 +3,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/zalloc.h>
+#include <linux/err.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <errno.h>
@@ -481,16 +482,21 @@ int perf_data__make_kcore_dir(struct perf_data *data, char *buf, size_t buf_sz)
 
 bool has_kcore_dir(const char *path)
 {
-	char *kcore_dir;
-	int ret;
-
-	if (asprintf(&kcore_dir, "%s/kcore_dir", path) < 0)
-		return false;
-
-	ret = access(kcore_dir, F_OK);
+	struct dirent *d = ERR_PTR(-EINVAL);
+	const char *name = "kcore_dir";
+	DIR *dir = opendir(path);
+	size_t n = strlen(name);
+	bool result = false;
+
+	if (dir) {
+		while (d && !result) {
+			d = readdir(dir);
+			result = d ? strncmp(d->d_name, name, n) : false;
+		}
+		closedir(dir);
+	}
 
-	free(kcore_dir);
-	return !ret;
+	return result;
 }
 
 char *perf_data__kallsyms_name(struct perf_data *data)
-- 
2.25.1

