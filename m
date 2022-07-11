Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B8656FE4F
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbiGKKK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbiGKKKB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:10:01 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A8FBFAE8;
        Mon, 11 Jul 2022 02:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657531964; x=1689067964;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y7AN7Ia9WCu3XxURhv+nR2BWwjg+1aZxtMTR6oL3b4M=;
  b=maO6LBJ4cZ55Pv7V1S9tubvuRpWaa2maztrFq4ivpKPVVCJuhWU2kV9c
   3DDPr7dhcfO2mrZYRyTg6qoQSR1Xn798nKxBnwOzOtHwoC78KO67cRnt3
   h/vqzMelpYWUz7zCkztbLEd1xJuAYCubEyELfSlh1H4nZJLXrNI/S4SA1
   zqcGA5WmlUBz3aeae5OhIR0S8y4i/SQ4q6gd6eUBIw/lUFwvh9bpTP3Fr
   wua0/uTdWbES1lwUVWh+RazYU6CistngxYJQybUfzFIPoCDOureqPdGI2
   uUbA1Ni8GoDIl2PYceekY7xW0Hi/Iw3izELYS8CWnwpZf6Tcex0QuL/qj
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371512"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371512"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:32:44 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652386995"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:32:42 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 01/35] perf tools: Fix dso_id inode generation comparison
Date:   Mon, 11 Jul 2022 12:31:44 +0300
Message-Id: <20220711093218.10967-2-adrian.hunter@intel.com>
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

Synthesized MMAP events have zero ino_generation, so do not compare zero
values.

Fixes: 0e3149f86b99 ("perf dso: Move dso_id from 'struct map' to 'struct dso'")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/dsos.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dsos.c b/tools/perf/util/dsos.c
index b97366f77bbf..839a1f384733 100644
--- a/tools/perf/util/dsos.c
+++ b/tools/perf/util/dsos.c
@@ -23,8 +23,14 @@ static int __dso_id__cmp(struct dso_id *a, struct dso_id *b)
 	if (a->ino > b->ino) return -1;
 	if (a->ino < b->ino) return 1;
 
-	if (a->ino_generation > b->ino_generation) return -1;
-	if (a->ino_generation < b->ino_generation) return 1;
+	/*
+	 * Synthesized MMAP events have zero ino_generation, so do not compare
+	 * zero values.
+	 */
+	if (a->ino_generation && b->ino_generation) {
+		if (a->ino_generation > b->ino_generation) return -1;
+		if (a->ino_generation < b->ino_generation) return 1;
+	}
 
 	return 0;
 }
-- 
2.25.1

