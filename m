Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7678156FE8C
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbiGKKOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbiGKKNQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:13:16 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C754E78DE1;
        Mon, 11 Jul 2022 02:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657532039; x=1689068039;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7AhT+PNqMolTOw2rvSOOX8l8IWfC7G90SMfb8ikqPGU=;
  b=A4X1I7P5qq673L3Lyn9oyzE2VOGyAOlUcPX89mP02aKaz5AdVnL58c+k
   O53QKP1hHeu7mp4qa9CeHw6MGS0ye5uuqTFRW0ZlBUNstm2IKPs1P+/XX
   nOzBHRKm8kVpilw4FDj+tho5NQGOeeLPfMZrIhGV+qCx45bCG5qTeVPs8
   GCXc+SuhQTO6/mEJOaztie+eNm/SVWNDWVrFH3rd1n3XZSHbTbVof68jq
   wMRbGHCrLgQuMayOF72429jhdkdw0N6jXIOyouTPCXebu5tu12lG0TAok
   pHZSSVNW1ZniGYy8CJ36e6ui3SF0K1VbCrUpkqmWaUJeF+Uvch2K4p3L9
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371674"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371674"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:43 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387238"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:41 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 26/35] perf tools: Handle injected guest kernel mmap event
Date:   Mon, 11 Jul 2022 12:32:09 +0300
Message-Id: <20220711093218.10967-27-adrian.hunter@intel.com>
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

If a kernel mmap event was recorded inside a guest and injected into a host
perf.data file, then it will match a host mmap_name not a guest mmap_name,
see machine__set_mmap_name(). So try matching a host mmap_name in that
case.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 27d1a38f44c3..8f657225fb02 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1742,6 +1742,7 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
 	struct map *map;
 	enum dso_space_type dso_space;
 	bool is_kernel_mmap;
+	const char *mmap_name = machine->mmap_name;
 
 	/* If we have maps from kcore then we do not need or want any others */
 	if (machine__uses_kcore(machine))
@@ -1752,8 +1753,16 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
 	else
 		dso_space = DSO_SPACE__KERNEL_GUEST;
 
-	is_kernel_mmap = memcmp(xm->name, machine->mmap_name,
-				strlen(machine->mmap_name) - 1) == 0;
+	is_kernel_mmap = memcmp(xm->name, mmap_name, strlen(mmap_name) - 1) == 0;
+	if (!is_kernel_mmap && !machine__is_host(machine)) {
+		/*
+		 * If the event was recorded inside the guest and injected into
+		 * the host perf.data file, then it will match a host mmap_name,
+		 * so try that - see machine__set_mmap_name().
+		 */
+		mmap_name = "[kernel.kallsyms]";
+		is_kernel_mmap = memcmp(xm->name, mmap_name, strlen(mmap_name) - 1) == 0;
+	}
 	if (xm->name[0] == '/' ||
 	    (!is_kernel_mmap && xm->name[0] == '[')) {
 		map = machine__addnew_module_map(machine, xm->start,
@@ -1767,7 +1776,7 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
 			dso__set_build_id(map->dso, bid);
 
 	} else if (is_kernel_mmap) {
-		const char *symbol_name = (xm->name + strlen(machine->mmap_name));
+		const char *symbol_name = xm->name + strlen(mmap_name);
 		/*
 		 * Should be there already, from the build-id table in
 		 * the header.
-- 
2.25.1

