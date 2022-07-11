Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D261356FE64
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbiGKKLW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234403AbiGKKKZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:10:25 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC0D78203;
        Mon, 11 Jul 2022 02:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657531983; x=1689067983;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f5C4voCgvVR8bp8zTIbCS74Eqs9Ys1LBQmXx+/5R2lg=;
  b=kkUCjC4PlgbKRYD62cploYbMeSipmdtbIiUIaXTFXMXSFz+494f7tQ0k
   mkJrfAHDwNVZOqqDzxl1Yk6k89x5YUmMpv/Cc4Z3WJGVNuqv0ZMEWgp+3
   /nqu5Zow5dPhAS94m4mrRsxpN5vGsdO+q1KMKdWSGsG8YG9ugsnJDq6+Y
   GMeFVddVNCYFAugoEWWq9NY/A7TJCfOKSz8BPSZQPgGVuJwjOm0E6RDxe
   iRd60OF2bB12RKcSI/41m0g3I3xnC0XbF1V4JEP08FILGH/rCvxG4Qcv2
   4NwXjxlEgZn4Y3u2sfZU2eEVRq+A1BnNhoYUFPpRN9qcRdvEzEXBK9KEO
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371550"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371550"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:03 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387052"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:01 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 09/35] perf buildid-cache: Do not require purge files to also be in the file system
Date:   Mon, 11 Jul 2022 12:31:52 +0300
Message-Id: <20220711093218.10967-10-adrian.hunter@intel.com>
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

realname() returns NULL if the file is not in the file system, but we can
still remove it from the build ID cache in that case, so continue and
attempt the purge with the name provided.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/build-id.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 7c9f441936ee..9e176146eb10 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -561,14 +561,11 @@ char *build_id_cache__cachedir(const char *sbuild_id, const char *name,
 	char *realname = (char *)name, *filename;
 	bool slash = is_kallsyms || is_vdso;
 
-	if (!slash) {
+	if (!slash)
 		realname = nsinfo__realpath(name, nsi);
-		if (!realname)
-			return NULL;
-	}
 
 	if (asprintf(&filename, "%s%s%s%s%s", buildid_dir, slash ? "/" : "",
-		     is_vdso ? DSO__NAME_VDSO : realname,
+		     is_vdso ? DSO__NAME_VDSO : (realname ? realname : name),
 		     sbuild_id ? "/" : "", sbuild_id ?: "") < 0)
 		filename = NULL;
 
-- 
2.25.1

