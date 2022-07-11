Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B1A56FE8D
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbiGKKOG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234239AbiGKKNR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:13:17 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E261C7A500;
        Mon, 11 Jul 2022 02:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657532041; x=1689068041;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=astg8L4UobIXZ7MFmsk0QzRFVbb6/CsBvdt3zjcGCvU=;
  b=CZNC+tcyMDFXkVwYgNkz44xQ/KPk8G3A1DyjBLNvruG5ALn04dKJ4/9A
   Gdh331VG/8/wprgkYPuSBkaN17wODZg9f0fo84H7qG07znGhlLTJOahJ8
   s93gekfygqCrP9jZkBv+Okv3ZdfsKPM3dgydSxCmKYjwZ6QTwO2j5XJlk
   WShrS3mOJF2OG50Eee9VAEhuOTxaQMHBbFl0qYFWeTUPyPBdKVCGCih+y
   y1wvsLLhxjU2mazowbDAqjXLVL42EfWFXl2K8Zc3c9gEG55ps35IqYT74
   O9Jy7MarclNnQ1VPx8kPqcqLmozuUC27sKQWPrg0/jjv0naV+SFEyA84q
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371679"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371679"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:45 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387245"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:43 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 27/35] perf tools: Add perf_event__is_guest()
Date:   Mon, 11 Jul 2022 12:32:10 +0300
Message-Id: <20220711093218.10967-28-adrian.hunter@intel.com>
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

Add a helper function to determine if an event is a guest event.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/event.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index a660f304f83c..a7b0931d5137 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -484,4 +484,25 @@ void arch_perf_synthesize_sample_weight(const struct perf_sample *data, __u64 *a
 const char *arch_perf_header_entry(const char *se_header);
 int arch_support_sort_key(const char *sort_key);
 
+static inline bool perf_event_header__cpumode_is_guest(u8 cpumode)
+{
+	return cpumode == PERF_RECORD_MISC_GUEST_KERNEL ||
+	       cpumode == PERF_RECORD_MISC_GUEST_USER;
+}
+
+static inline bool perf_event_header__misc_is_guest(u16 misc)
+{
+	return perf_event_header__cpumode_is_guest(misc & PERF_RECORD_MISC_CPUMODE_MASK);
+}
+
+static inline bool perf_event_header__is_guest(const struct perf_event_header *header)
+{
+	return perf_event_header__misc_is_guest(header->misc);
+}
+
+static inline bool perf_event__is_guest(const union perf_event *event)
+{
+	return perf_event_header__is_guest(&event->header);
+}
+
 #endif /* __PERF_RECORD_H */
-- 
2.25.1

