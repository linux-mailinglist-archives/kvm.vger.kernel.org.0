Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8890C56FE53
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbiGKKKh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiGKKKP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:10:15 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AEABFAF0;
        Mon, 11 Jul 2022 02:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657531969; x=1689067969;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=peNY5Wsb9AA5sM1LjO+8sxYcFY1txqJD8C6nMA1BaP8=;
  b=PmgVEoZeVlxSfO097gNHi+9qKA1uIV4GPHnH3QVRM54dTfa8WsjZdZcU
   V7ivU/6ZjTUyjCDbLcjnqHGMT1PXr2wVc2vPPCX6z9TCfuB1j7Of3T+5B
   qyBhoVQgcxgVLBLkJnCrNT7iwWm6EgKhOp2Rj6wMymWtHFHUZAXH56Grx
   tnTxMPvClufCrG2V+dG+zOWUvFRx6CTF520EWd4Eh65kSK5RmqVR5dhkt
   pasFYj2iHDvPSqqE1Q/jMhOAPMJ9zQFk4PUn8HNWfSQE4otpL3RDBBP0r
   Z0Hn+Vi9dYU3qs4Lpr5IdrNBC2WHRcNkQ31N/8hl9nMEzZWzexaljWYyt
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371521"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371521"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:32:49 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387014"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:32:47 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 03/35] perf ordered_events: Add ordered_events__last_flush_time()
Date:   Mon, 11 Jul 2022 12:31:46 +0300
Message-Id: <20220711093218.10967-4-adrian.hunter@intel.com>
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

Allow callers to get the ordered_events last flush timestamp.

This is needed in perf inject to obey finished-round ordering when
injecting additional events (e.g. from a guest perf.data file) with
timestamps. Any additional events that have timestamps before the last
flush time must be injected before the corresponding FINISHED_ROUND event.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/ordered-events.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/ordered-events.h b/tools/perf/util/ordered-events.h
index 0b05c3c0aeaa..8febbd7c98ca 100644
--- a/tools/perf/util/ordered-events.h
+++ b/tools/perf/util/ordered-events.h
@@ -75,4 +75,10 @@ void ordered_events__set_copy_on_queue(struct ordered_events *oe, bool copy)
 {
 	oe->copy_on_queue = copy;
 }
+
+static inline u64 ordered_events__last_flush_time(struct ordered_events *oe)
+{
+	return oe->last_flush;
+}
+
 #endif /* __ORDERED_EVENTS_H */
-- 
2.25.1

