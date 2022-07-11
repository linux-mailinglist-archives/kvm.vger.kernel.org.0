Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1712056FE7D
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbiGKKMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiGKKLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:11:36 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DB32733;
        Mon, 11 Jul 2022 02:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657532021; x=1689068021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u/lZbP19TfSiTGeORdm6GBpFVMQbLNARmuyPv6JLXdE=;
  b=jKE5/UYUPDbfLhF3ZottgDnCSgL3e3kigs/BcD51blpZvV2FZxRZ4Z5s
   MPmd/gNKbaD0Qwq4bjzsGXY3r0atSSF0xjeuuHAzGLhU8ihUpQ9jHxGCw
   0iZOaHRNj+h1+muBSjaolAP0lS0F2O86pqYwUCVycEfax1DpwROP4/ifN
   g070n7bN9XOZZs12lqiO/NCrY7sbmKQMmWV6QPUIKHxVSLuhSR84J7iQN
   SlXoCIs/tMdD7gAYrWZjFVPiJw+vblYjdKahGb1ou4o4CMeM1ZCkGehNR
   koAX7w4i8Ka31A9KZxrE3prCRElIswfv/BFi9ii/qQAjw1ab0GEKi1z1K
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371628"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371628"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:29 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387172"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:26 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 20/35] perf tools: Remove also guest kcore_dir with host kcore_dir
Date:   Mon, 11 Jul 2022 12:32:03 +0300
Message-Id: <20220711093218.10967-21-adrian.hunter@intel.com>
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
beginning kcore_dir__ followed by the machine pid. Remove these also when
removing kcore_dir.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/util.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index eeb83c80f458..9b02edf9311d 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -200,7 +200,7 @@ static int rm_rf_depth_pat(const char *path, int depth, const char **pat)
 	return rmdir(path);
 }
 
-static int rm_rf_kcore_dir(const char *path)
+static int rm_rf_a_kcore_dir(const char *path, const char *name)
 {
 	char kcore_dir_path[PATH_MAX];
 	const char *pat[] = {
@@ -210,11 +210,44 @@ static int rm_rf_kcore_dir(const char *path)
 		NULL,
 	};
 
-	snprintf(kcore_dir_path, sizeof(kcore_dir_path), "%s/kcore_dir", path);
+	snprintf(kcore_dir_path, sizeof(kcore_dir_path), "%s/%s", path, name);
 
 	return rm_rf_depth_pat(kcore_dir_path, 0, pat);
 }
 
+static bool kcore_dir_filter(const char *name __maybe_unused, struct dirent *d)
+{
+	const char *pat[] = {
+		"kcore_dir",
+		"kcore_dir__[1-9]*",
+		NULL,
+	};
+
+	return match_pat(d->d_name, pat);
+}
+
+static int rm_rf_kcore_dir(const char *path)
+{
+	struct strlist *kcore_dirs;
+	struct str_node *nd;
+	int ret;
+
+	kcore_dirs = lsdir(path, kcore_dir_filter);
+
+	if (!kcore_dirs)
+		return 0;
+
+	strlist__for_each_entry(nd, kcore_dirs) {
+		ret = rm_rf_a_kcore_dir(path, nd->s);
+		if (ret)
+			return ret;
+	}
+
+	strlist__delete(kcore_dirs);
+
+	return 0;
+}
+
 int rm_rf_perf_data(const char *path)
 {
 	const char *pat[] = {
-- 
2.25.1

