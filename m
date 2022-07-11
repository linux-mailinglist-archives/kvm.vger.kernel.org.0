Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAE156FE8A
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbiGKKNu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbiGKKMp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:12:45 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2179C25C42;
        Mon, 11 Jul 2022 02:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657532037; x=1689068037;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sNOtXZ/ZqAQGHU78sN2eiVBlBE+Lr8Bl1OTmXBpdym0=;
  b=gQgnJ88vCmj5AEM7uzK5Y96WOLFiq4pmtzErD/wqaFxfNXH/tV0h5eZD
   YI0yyJvwappeSawjFrFSIUQ5gTt7uwS5glOHD4x+wA/PVZWYYwbWRyo+W
   8d0MM20EPrH4gz8kX7ZGeVIRYVfH2SIpYsoM+kRsTvDAkLOhhcOK3Bfdb
   8bRc0vTYnGtFBNDAN8Whxh7DzfkCTbwtwLTP4Fb3c2wa3sc20X09Q7Kpp
   Ux6jYA7kexp72EVpdhQNBSjdD25ZzF/hL0WEngiFRXHXUVk5yTMWpS7sd
   late51ONtB/PNypXCAY7XNQfkLBNQ4Dr4DQp8YGpeQjn0V2qPBgDWPNEO
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371666"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371666"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:40 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387226"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:38 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 25/35] perf machine: Use realloc_array_as_needed() in machine__set_current_tid()
Date:   Mon, 11 Jul 2022 12:32:08 +0300
Message-Id: <20220711093218.10967-26-adrian.hunter@intel.com>
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

Prepare machine__set_current_tid() for use with guest machines that do
not currently have a machine->env->nr_cpus_avail value by making use of
realloc_array_as_needed().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 26 +++++++-------------------
 tools/perf/util/machine.h |  1 +
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 009061852808..27d1a38f44c3 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -3174,9 +3174,7 @@ int machines__for_each_thread(struct machines *machines,
 
 pid_t machine__get_current_tid(struct machine *machine, int cpu)
 {
-	int nr_cpus = min(machine->env->nr_cpus_avail, MAX_NR_CPUS);
-
-	if (cpu < 0 || cpu >= nr_cpus || !machine->current_tid)
+	if (cpu < 0 || (size_t)cpu >= machine->current_tid_sz)
 		return -1;
 
 	return machine->current_tid[cpu];
@@ -3186,26 +3184,16 @@ int machine__set_current_tid(struct machine *machine, int cpu, pid_t pid,
 			     pid_t tid)
 {
 	struct thread *thread;
-	int nr_cpus = min(machine->env->nr_cpus_avail, MAX_NR_CPUS);
+	const pid_t init_val = -1;
 
 	if (cpu < 0)
 		return -EINVAL;
 
-	if (!machine->current_tid) {
-		int i;
-
-		machine->current_tid = calloc(nr_cpus, sizeof(pid_t));
-		if (!machine->current_tid)
-			return -ENOMEM;
-		for (i = 0; i < nr_cpus; i++)
-			machine->current_tid[i] = -1;
-	}
-
-	if (cpu >= nr_cpus) {
-		pr_err("Requested CPU %d too large. ", cpu);
-		pr_err("Consider raising MAX_NR_CPUS\n");
-		return -EINVAL;
-	}
+	if (realloc_array_as_needed(machine->current_tid,
+				    machine->current_tid_sz,
+				    (unsigned int)cpu,
+				    &init_val))
+		return -ENOMEM;
 
 	machine->current_tid[cpu] = tid;
 
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index d40b23c71420..609e24e329d1 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -57,6 +57,7 @@ struct machine {
 	struct map	  *vmlinux_map;
 	u64		  kernel_start;
 	pid_t		  *current_tid;
+	size_t		  current_tid_sz;
 	union { /* Tool specific area */
 		void	  *priv;
 		u64	  db_id;
-- 
2.25.1

