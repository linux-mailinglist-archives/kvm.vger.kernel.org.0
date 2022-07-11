Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A9356FE6C
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbiGKKLo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234578AbiGKKKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:10:32 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70E578222;
        Mon, 11 Jul 2022 02:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657531994; x=1689067994;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/XMNx68flhNUFZWIfR1uqdJgwP7vZetAfA4HOwuX0ac=;
  b=j941F69Ri2hH88HXMZ94KM4ELsXkf5WvnLPcCCTJHa2Hrb06pwqQN9IN
   p1gl27lTO/yn35u9dhJoXXfcLewm+/qOOwMJBPH3qt/sxlyL2aLjN1DCV
   81ZiWi4pLe0V+mIqdJg04T3+4glPIZ9NNMXL68OOrS/4AXX/ayNJZpJHG
   IeWEtjjGWAZ0Ki6Co3D2vs6MTXMrfojtquHZ06y7q8TTjXHD6B9/mSGXh
   fRpoyYXtgKV/F4avhtaT4Jt4NFXNw87+zuLkz74jYTB1BLiRTJlAldqld
   TfQBaFE1WAA+3YjuVdXubySRQwxGmCl2ckrfAEmi6rGUCEUFgXKXQ/1hh
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371577"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371577"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:14 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387102"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:12 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 14/35] perf tools: Use sample->machine_pid to find guest machine
Date:   Mon, 11 Jul 2022 12:31:57 +0300
Message-Id: <20220711093218.10967-15-adrian.hunter@intel.com>
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

If machine_pid is set, use it to find the guest machine.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/session.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 91a091c35945..f3e9fa557bc9 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1418,7 +1418,9 @@ static struct machine *machines__find_for_cpumode(struct machines *machines,
 	     (sample->cpumode == PERF_RECORD_MISC_GUEST_USER))) {
 		u32 pid;
 
-		if (event->header.type == PERF_RECORD_MMAP
+		if (sample->machine_pid)
+			pid = sample->machine_pid;
+		else if (event->header.type == PERF_RECORD_MMAP
 		    || event->header.type == PERF_RECORD_MMAP2)
 			pid = event->mmap.pid;
 		else
-- 
2.25.1

