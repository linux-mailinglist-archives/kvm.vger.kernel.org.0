Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408D756FE52
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbiGKKKd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiGKKKM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:10:12 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D3FBFADE;
        Mon, 11 Jul 2022 02:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657531967; x=1689067967;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ibfm1AW6+ERdLJFJaC+jfaM1CrmGAD8hN89rymrkIZ8=;
  b=LjloBicYaYsyq1cu8X9xMyvxijV4Cc+51a2RcdGF2rQESWjqEPYffoPN
   wuFiE6sO/eowfSYPjEMfxNHO7wasE30lW1pD+eYK0c6yCJQTO+GLhmrqN
   OVfUQmgR3ii5+mp6hRqFk1B64znkjo8cDWNvyt/ipwBeBJ1n4B9q/q92e
   t17bvZOPL1xcwesRtoeRnliYk/PD7BqBuacDzQ6GPbkHBwCbnEWoYm+uC
   alBotV+y4SPnhOW0fEcripDbahuAH2NBqQ7bBlKIMlr5A8s+oG4aR/WFA
   hvfPs+RYNCEI4ntn8ka7I5nFvG3wnotcfR1af/xVUQXJkciy4O92hBEO5
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371514"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371514"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:32:46 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387004"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:32:44 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 02/35] perf tools: Export dsos__for_each_with_build_id()
Date:   Mon, 11 Jul 2022 12:31:45 +0300
Message-Id: <20220711093218.10967-3-adrian.hunter@intel.com>
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

Export dsos__for_each_with_build_id() so it can be used elsewhere.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/build-id.c | 6 ------
 tools/perf/util/dso.h      | 6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 328668f38c69..4c9093b64d1f 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -300,12 +300,6 @@ char *dso__build_id_filename(const struct dso *dso, char *bf, size_t size,
 	return __dso__build_id_filename(dso, bf, size, is_debug, is_kallsyms);
 }
 
-#define dsos__for_each_with_build_id(pos, head)	\
-	list_for_each_entry(pos, head, node)	\
-		if (!pos->has_build_id)		\
-			continue;		\
-		else
-
 static int write_buildid(const char *name, size_t name_len, struct build_id *bid,
 			 pid_t pid, u16 misc, struct feat_fd *fd)
 {
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 97047a11282b..66981c7a9a18 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -227,6 +227,12 @@ struct dso {
 #define dso__for_each_symbol(dso, pos, n)	\
 	symbols__for_each_entry(&(dso)->symbols, pos, n)
 
+#define dsos__for_each_with_build_id(pos, head)	\
+	list_for_each_entry(pos, head, node)	\
+		if (!pos->has_build_id)		\
+			continue;		\
+		else
+
 static inline void dso__set_loaded(struct dso *dso)
 {
 	dso->loaded = true;
-- 
2.25.1

