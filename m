Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BD756FE82
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbiGKKNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbiGKKML (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:12:11 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B72E1A82C;
        Mon, 11 Jul 2022 02:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657532032; x=1689068032;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jRr+7NI/zfQcj5nU1mVzJyO/+NhSDeVlZPAKmSQ7DEE=;
  b=Nlx5XAOesV2AAf8Z9zwg/6FRYtjHplhqCwMvj3SFir1aM2vbABPZrKGp
   q3G9mAjGyl9UdXtThAQ6q+Z7Ui/3RXpzrYbSPFcdmNZBmZjwIglyrVAwB
   e6urdgZWbEbmCroKXhaFcZRTEkPUVX18uIW/nszCHw34jaON6jx2evSEP
   xARgmTGDUO2coj7gS1fDeQ5IuJd+/O0LeSrJcOqriQ6sJgPKoDEW/lYef
   yDQUsAnq+0emA2xWn33TsI1goXiZwOj1tvCQIT5QTqPI5DVBw34W1RIru
   7+FxEwMbvFybPqPN2KArhbIkZMvsvePHwdkMVJw/yr80Hsgzb3DFRXunD
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371642"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371642"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:33 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387201"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:31 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 22/35] perf tools: Automatically use guest kcore_dir if present
Date:   Mon, 11 Jul 2022 12:32:05 +0300
Message-Id: <20220711093218.10967-23-adrian.hunter@intel.com>
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

When registering a guest machine using machine_pid from the id index,
check perf.data for a matching kcore_dir subdirectory and set the
kallsyms file name accordingly. If set, use it to find the machine's
kernel symbols and object code (from kcore).

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/data.c    | 19 +++++++++++++++++++
 tools/perf/util/data.h    |  1 +
 tools/perf/util/machine.h |  1 +
 tools/perf/util/session.c |  2 ++
 tools/perf/util/symbol.c  |  6 ++++--
 5 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index 9782ccbe595d..a7f68c309545 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -518,6 +518,25 @@ char *perf_data__kallsyms_name(struct perf_data *data)
 	return kallsyms_name;
 }
 
+char *perf_data__guest_kallsyms_name(struct perf_data *data, pid_t machine_pid)
+{
+	char *kallsyms_name;
+	struct stat st;
+
+	if (!data->is_dir)
+		return NULL;
+
+	if (asprintf(&kallsyms_name, "%s/kcore_dir__%d/kallsyms", data->path, machine_pid) < 0)
+		return NULL;
+
+	if (stat(kallsyms_name, &st)) {
+		free(kallsyms_name);
+		return NULL;
+	}
+
+	return kallsyms_name;
+}
+
 bool is_perf_data(const char *path)
 {
 	bool ret = false;
diff --git a/tools/perf/util/data.h b/tools/perf/util/data.h
index 7de53d6e2d7f..173132d502f5 100644
--- a/tools/perf/util/data.h
+++ b/tools/perf/util/data.h
@@ -101,5 +101,6 @@ unsigned long perf_data__size(struct perf_data *data);
 int perf_data__make_kcore_dir(struct perf_data *data, char *buf, size_t buf_sz);
 bool has_kcore_dir(const char *path);
 char *perf_data__kallsyms_name(struct perf_data *data);
+char *perf_data__guest_kallsyms_name(struct perf_data *data, pid_t machine_pid);
 bool is_perf_data(const char *path);
 #endif /* __PERF_DATA_H */
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 5d7daf7cb7bc..d40b23c71420 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -48,6 +48,7 @@ struct machine {
 	bool		  single_address_space;
 	char		  *root_dir;
 	char		  *mmap_name;
+	char		  *kallsyms_filename;
 	struct threads    threads[THREADS__TABLE_SIZE];
 	struct vdso_info  *vdso_info;
 	struct perf_env   *env;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7ea0b91013ea..98e16659a149 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -2772,6 +2772,8 @@ static int perf_session__register_guest(struct perf_session *session, pid_t mach
 		return -ENOMEM;
 	thread__put(thread);
 
+	machine->kallsyms_filename = perf_data__guest_kallsyms_name(session->data, machine_pid);
+
 	return 0;
 }
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f72baf636724..a4b22caa7c24 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2300,11 +2300,13 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map)
 static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map)
 {
 	int err;
-	const char *kallsyms_filename = NULL;
+	const char *kallsyms_filename;
 	struct machine *machine = map__kmaps(map)->machine;
 	char path[PATH_MAX];
 
-	if (machine__is_default_guest(machine)) {
+	if (machine->kallsyms_filename) {
+		kallsyms_filename = machine->kallsyms_filename;
+	} else if (machine__is_default_guest(machine)) {
 		/*
 		 * if the user specified a vmlinux filename, use it and only
 		 * it, reporting errors to the user if it cannot be used.
-- 
2.25.1

