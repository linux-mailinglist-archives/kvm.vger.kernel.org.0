Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC95525E99
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 11:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378829AbiEMJDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 05:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378816AbiEMJDA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 05:03:00 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A2895DDC;
        Fri, 13 May 2022 02:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652432578; x=1683968578;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CLsBVlIOB1svkFU1pGIbk69WpliItNCCGs4gSAnCKVw=;
  b=MoFydcRTBqVGiMF7bU3521mBKW5Zt03JSkvHF2cJFveQHUkGLQjq8io9
   f2YxRX+Ld6BFmuBWjCYD7xDq0tHHCNimhmPmRVJhZBiyS1ukP/iRlcWYi
   irL+LNbmcm2EePAYmpe6nzKIwLH56BVyLLT8il42ZXrh1Y4KB980+/3r0
   cJaSwIMCYUKX7ta3QKbJhz75Yd04BEE2C2LJu1nn0KD6AiUyeWeP4dW3J
   JHi69B4KmQh8ExZEPs5AH/EXBFI/FHpGk1HFU0x1/0o++fQywJz+8Ump0
   m/oYW4a59IUcMLOJIJNgcMe6Q6rLKRdj1G+fN1zWjE/p/WjWPQTD6Rl5T
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="330856476"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="330856476"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 02:02:58 -0700
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="595129601"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.36.190])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 02:02:55 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Leo Yan <leo.yan@linaro.org>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 2/6] perf tools: Factor out thread__set_guest_comm()
Date:   Fri, 13 May 2022 12:02:33 +0300
Message-Id: <20220513090237.10444-3-adrian.hunter@intel.com>
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

Factor out thread__set_guest_comm() so it can be reused.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index e96f6ea4fd82..e67b5a7670f3 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -84,6 +84,14 @@ static int machine__set_mmap_name(struct machine *machine)
 	return machine->mmap_name ? 0 : -ENOMEM;
 }
 
+static void thread__set_guest_comm(struct thread *thread, pid_t pid)
+{
+	char comm[64];
+
+	snprintf(comm, sizeof(comm), "[guest/%d]", pid);
+	thread__set_comm(thread, comm, 0);
+}
+
 int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 {
 	int err = -ENOMEM;
@@ -119,13 +127,11 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 	if (pid != HOST_KERNEL_ID) {
 		struct thread *thread = machine__findnew_thread(machine, -1,
 								pid);
-		char comm[64];
 
 		if (thread == NULL)
 			goto out;
 
-		snprintf(comm, sizeof(comm), "[guest/%d]", pid);
-		thread__set_comm(thread, comm, 0);
+		thread__set_guest_comm(thread, pid);
 		thread__put(thread);
 	}
 
-- 
2.25.1

