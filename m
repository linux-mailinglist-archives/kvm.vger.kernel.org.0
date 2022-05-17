Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A893A52A2D3
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 15:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346207AbiEQNKn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 09:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347243AbiEQNKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 09:10:34 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758843526C;
        Tue, 17 May 2022 06:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652793033; x=1684329033;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CLsBVlIOB1svkFU1pGIbk69WpliItNCCGs4gSAnCKVw=;
  b=FxJK/rEHk1Ecclv48dly46DX53Rq9zqqcm2foyWiyNe+sSliu7AkMVw+
   z5wzzB/qyypRmXI/5tklLWl2glOtPGCB7Fbb4ijXMzEytbm5KMzS8KUu1
   xJZK0QwkgtEAAOKt+nBM0iK6ZhqhJLaSYEMvUh6w31E/LSM2WGkn/nveb
   b/k6XcU/bacCu7Tv0u6PZByIFwdFer7VqjljFsqJWZG50BKpdTYZR7ppR
   Q/ztcZVuHa7eV9QQPJTaA7SEHVRb9tDsz04i34/fKVe6Wpd0sB8aciI6k
   mFnuKi+S8Y+cgRwULK9aA00QFbzy1FwrcjcoR9ud7zyasv8vWdB67X4NO
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="271300111"
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="271300111"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 06:10:33 -0700
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="713844280"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.52.217])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 06:10:30 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Leo Yan <leo.yan@linaro.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH V2 2/6] perf tools: Factor out thread__set_guest_comm()
Date:   Tue, 17 May 2022 16:10:07 +0300
Message-Id: <20220517131011.6117-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517131011.6117-1-adrian.hunter@intel.com>
References: <20220517131011.6117-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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

