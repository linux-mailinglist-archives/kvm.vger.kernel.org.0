Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71609525E2D
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 11:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378813AbiEMJC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 05:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378744AbiEMJC5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 05:02:57 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BEA939EE;
        Fri, 13 May 2022 02:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652432576; x=1683968576;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/iND+4oDvVkD/6SGZOA2dZZ9Z7Of4oGc/qJILLKB+gA=;
  b=FXfx3lJ25MJqpjdWHTplC8jVRujINmMeLSbw4q582lylUIxRBOchFU1i
   Jfb9jYCLdeO+N91fQdiBZ7G7YbkkrOYIKY2okZVb7lBUIq/9Wu4K2HFzU
   Ihw8/BSLSlExZdiTy40gLqWdBAjh8KbG8tw7bxdh5eaHiXJQOylM9xp9Z
   gikvOE341wm3jWvp4tnI6k/QU2oLED4bUNT0lvpVEE7KgErptFJvnM6uV
   8tVyJ4mlfp3RN6swobABWSIuWtJA/5/4jqvU1w12PVfmUWkEjgiV800JJ
   z0FQb8+/O3DCwfMr8tLf65MDxEVMELZoizwXDMrtXRbk6K2iV0akO7wcB
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="330856465"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="330856465"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 02:02:55 -0700
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="595129559"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.36.190])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 02:02:52 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Leo Yan <leo.yan@linaro.org>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 1/6] perf tools: Add machine to machines back pointer
Date:   Fri, 13 May 2022 12:02:32 +0300
Message-Id: <20220513090237.10444-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220513090237.10444-1-adrian.hunter@intel.com>
References: <20220513090237.10444-1-adrian.hunter@intel.com>
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

When dealing with guest machines, it can be necessary to get a reference
to the host machine. Add a machines pointer to struct machine to make that
possible.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 2 ++
 tools/perf/util/machine.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 95391236f5f6..e96f6ea4fd82 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -299,6 +299,8 @@ struct machine *machines__add(struct machines *machines, pid_t pid,
 	rb_link_node(&machine->rb_node, parent, p);
 	rb_insert_color_cached(&machine->rb_node, &machines->guests, leftmost);
 
+	machine->machines = machines;
+
 	return machine;
 }
 
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 0023165422aa..0d113771e8c8 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -18,6 +18,7 @@ struct symbol;
 struct target;
 struct thread;
 union perf_event;
+struct machines;
 
 /* Native host kernel uses -1 as pid index in machine */
 #define	HOST_KERNEL_ID			(-1)
@@ -59,6 +60,7 @@ struct machine {
 		void	  *priv;
 		u64	  db_id;
 	};
+	struct machines   *machines;
 	bool		  trampolines_mapped;
 };
 
-- 
2.25.1

