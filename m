Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3381F56FE61
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbiGKKLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbiGKKKX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:10:23 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C70774B3;
        Mon, 11 Jul 2022 02:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657531981; x=1689067981;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=06NuWXD+A69I7tbKdaelDYf1QOfCRyX2oUN29GJhdUY=;
  b=j0xdvo5Pyef6vYTA8E4t8sXFvi6A2+Y5x2uYW+ErkTg+RZyN0UTQelj+
   EmCyYuu/FTVe2E01k0zrzwgN7C0OoIHrur67zwYm2kKFjtgFLKKfnf3d8
   b0F49X27C3cWBTz/w4DJPs3uXF2t6DgUMV4wRJnY6vgSpMyaHKHW+Lxt1
   F22q3B0wjO4TFveMTMAfRW78Otz01QHxdaTDQV6388wQNWGchT3y7pAVo
   fUAk1dnq0r3GjZZ5D3NL7GxVz2ddvAXk5vKj7azTLCIl+/J3ABFaBUtw8
   2XEej+nVGSRa/skKmj7WVshlpt9fbgKz1SbV/SfwsH0lJ8W/EQyWTIREJ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371548"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371548"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:00 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387042"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:32:58 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 08/35] perf buildid-cache: Add guestmount'd files to the build ID cache
Date:   Mon, 11 Jul 2022 12:31:51 +0300
Message-Id: <20220711093218.10967-9-adrian.hunter@intel.com>
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

When the guestmount option is used, a guest machine's file system mount
point is recorded in machine->root_dir.

perf already iterates guest machines when adding files to the build ID
cache, but does not take machine->root_dir into account.

Use machine->root_dir to find files for guest build IDs, and add them to
the build ID cache using the "proper" name i.e. relative to the guest root
directory not the host root directory.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/build-id.c | 67 +++++++++++++++++++++++++++++---------
 tools/perf/util/build-id.h | 16 ++++++---
 2 files changed, 63 insertions(+), 20 deletions(-)

diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 4c9093b64d1f..7c9f441936ee 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -625,9 +625,12 @@ static int build_id_cache__add_sdt_cache(const char *sbuild_id,
 #endif
 
 static char *build_id_cache__find_debug(const char *sbuild_id,
-					struct nsinfo *nsi)
+					struct nsinfo *nsi,
+					const char *root_dir)
 {
+	const char *dirname = "/usr/lib/debug/.build-id/";
 	char *realname = NULL;
+	char dirbuf[PATH_MAX];
 	char *debugfile;
 	struct nscookie nsc;
 	size_t len = 0;
@@ -636,8 +639,12 @@ static char *build_id_cache__find_debug(const char *sbuild_id,
 	if (!debugfile)
 		goto out;
 
-	len = __symbol__join_symfs(debugfile, PATH_MAX,
-				   "/usr/lib/debug/.build-id/");
+	if (root_dir) {
+		path__join(dirbuf, PATH_MAX, root_dir, dirname);
+		dirname = dirbuf;
+	}
+
+	len = __symbol__join_symfs(debugfile, PATH_MAX, dirname);
 	snprintf(debugfile + len, PATH_MAX - len, "%.2s/%s.debug", sbuild_id,
 		 sbuild_id + 2);
 
@@ -668,14 +675,18 @@ static char *build_id_cache__find_debug(const char *sbuild_id,
 
 int
 build_id_cache__add(const char *sbuild_id, const char *name, const char *realname,
-		    struct nsinfo *nsi, bool is_kallsyms, bool is_vdso)
+		    struct nsinfo *nsi, bool is_kallsyms, bool is_vdso,
+		    const char *proper_name, const char *root_dir)
 {
 	const size_t size = PATH_MAX;
 	char *filename = NULL, *dir_name = NULL, *linkname = zalloc(size), *tmp;
 	char *debugfile = NULL;
 	int err = -1;
 
-	dir_name = build_id_cache__cachedir(sbuild_id, name, nsi, is_kallsyms,
+	if (!proper_name)
+		proper_name = name;
+
+	dir_name = build_id_cache__cachedir(sbuild_id, proper_name, nsi, is_kallsyms,
 					    is_vdso);
 	if (!dir_name)
 		goto out_free;
@@ -715,7 +726,7 @@ build_id_cache__add(const char *sbuild_id, const char *name, const char *realnam
 	 */
 	if (!is_kallsyms && !is_vdso &&
 	    strncmp(".ko", name + strlen(name) - 3, 3)) {
-		debugfile = build_id_cache__find_debug(sbuild_id, nsi);
+		debugfile = build_id_cache__find_debug(sbuild_id, nsi, root_dir);
 		if (debugfile) {
 			zfree(&filename);
 			if (asprintf(&filename, "%s/%s", dir_name,
@@ -781,8 +792,9 @@ build_id_cache__add(const char *sbuild_id, const char *name, const char *realnam
 	return err;
 }
 
-int build_id_cache__add_s(const char *sbuild_id, const char *name,
-			  struct nsinfo *nsi, bool is_kallsyms, bool is_vdso)
+int __build_id_cache__add_s(const char *sbuild_id, const char *name,
+			    struct nsinfo *nsi, bool is_kallsyms, bool is_vdso,
+			    const char *proper_name, const char *root_dir)
 {
 	char *realname = NULL;
 	int err = -1;
@@ -796,8 +808,8 @@ int build_id_cache__add_s(const char *sbuild_id, const char *name,
 			goto out_free;
 	}
 
-	err = build_id_cache__add(sbuild_id, name, realname, nsi, is_kallsyms, is_vdso);
-
+	err = build_id_cache__add(sbuild_id, name, realname, nsi,
+				  is_kallsyms, is_vdso, proper_name, root_dir);
 out_free:
 	if (!is_kallsyms)
 		free(realname);
@@ -806,14 +818,16 @@ int build_id_cache__add_s(const char *sbuild_id, const char *name,
 
 static int build_id_cache__add_b(const struct build_id *bid,
 				 const char *name, struct nsinfo *nsi,
-				 bool is_kallsyms, bool is_vdso)
+				 bool is_kallsyms, bool is_vdso,
+				 const char *proper_name,
+				 const char *root_dir)
 {
 	char sbuild_id[SBUILD_ID_SIZE];
 
 	build_id__sprintf(bid, sbuild_id);
 
-	return build_id_cache__add_s(sbuild_id, name, nsi, is_kallsyms,
-				     is_vdso);
+	return __build_id_cache__add_s(sbuild_id, name, nsi, is_kallsyms,
+				       is_vdso, proper_name, root_dir);
 }
 
 bool build_id_cache__cached(const char *sbuild_id)
@@ -896,6 +910,10 @@ static int dso__cache_build_id(struct dso *dso, struct machine *machine,
 	bool is_kallsyms = dso__is_kallsyms(dso);
 	bool is_vdso = dso__is_vdso(dso);
 	const char *name = dso->long_name;
+	const char *proper_name = NULL;
+	const char *root_dir = NULL;
+	char *allocated_name = NULL;
+	int ret = 0;
 
 	if (!dso->has_build_id)
 		return 0;
@@ -905,11 +923,28 @@ static int dso__cache_build_id(struct dso *dso, struct machine *machine,
 		name = machine->mmap_name;
 	}
 
+	if (!machine__is_host(machine)) {
+		if (*machine->root_dir) {
+			root_dir = machine->root_dir;
+			ret = asprintf(&allocated_name, "%s/%s", root_dir, name);
+			if (ret < 0)
+				return ret;
+			proper_name = name;
+			name = allocated_name;
+		} else if (is_kallsyms) {
+			/* Cannot get guest kallsyms */
+			return 0;
+		}
+	}
+
 	if (!is_kallsyms && dso__build_id_mismatch(dso, name))
-		return 0;
+		goto out_free;
 
-	return build_id_cache__add_b(&dso->bid, name, dso->nsinfo,
-				     is_kallsyms, is_vdso);
+	ret = build_id_cache__add_b(&dso->bid, name, dso->nsinfo,
+				    is_kallsyms, is_vdso, proper_name, root_dir);
+out_free:
+	free(allocated_name);
+	return ret;
 }
 
 static int
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
index c19617151670..4e3a1169379b 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -66,10 +66,18 @@ int build_id_cache__list_build_ids(const char *pathname, struct nsinfo *nsi,
 				   struct strlist **result);
 bool build_id_cache__cached(const char *sbuild_id);
 int build_id_cache__add(const char *sbuild_id, const char *name, const char *realname,
-			struct nsinfo *nsi, bool is_kallsyms, bool is_vdso);
-int build_id_cache__add_s(const char *sbuild_id,
-			  const char *name, struct nsinfo *nsi,
-			  bool is_kallsyms, bool is_vdso);
+			struct nsinfo *nsi, bool is_kallsyms, bool is_vdso,
+			const char *proper_name, const char *root_dir);
+int __build_id_cache__add_s(const char *sbuild_id,
+			    const char *name, struct nsinfo *nsi,
+			    bool is_kallsyms, bool is_vdso,
+			    const char *proper_name, const char *root_dir);
+static inline int build_id_cache__add_s(const char *sbuild_id,
+					const char *name, struct nsinfo *nsi,
+					bool is_kallsyms, bool is_vdso)
+{
+	return __build_id_cache__add_s(sbuild_id, name, nsi, is_kallsyms, is_vdso, NULL, NULL);
+}
 int build_id_cache__remove_s(const char *sbuild_id);
 
 extern char buildid_dir[];
-- 
2.25.1

