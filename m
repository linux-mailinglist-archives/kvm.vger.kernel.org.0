Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B18156FE94
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiGKKOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234777AbiGKKNb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:13:31 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84C47A53B;
        Mon, 11 Jul 2022 02:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657532044; x=1689068044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pV0VumJ3s6uLN9qCerb/hN2mohoe/BvrNQXkYE6cXzU=;
  b=RwJ+PRj6CQXwQZKM2xjZw/ZEAZjQODyj3djzTokkbXjiQhiTkODR+ZVd
   7U+zZkikmP6iCF1JoBfRg7+QholnDTQqxkdEAO2yfLk195kdW0kczjkf2
   HKQZ/r2X5yrk4QWxVZmik747+lI6UxEgArmKYYN66UtfqlNl5HoWuaplV
   YF9/LQ9U7EBK3QZYd+mnZ1FtDFVgxixI+3QMxEpQhw1ywO55RXegBkNNG
   oz868Iao9v8+5yiZ4dUPDWBELHA4cibWn/p2X2AXk3vrw5YiiWIhDj/6P
   rl4NZe6vRjBZ8rHREoQEKsOFglAJnCUYBnzEqdhCPvx707LMXHf7aUpwO
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371694"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371694"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:47 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387254"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:45 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 28/35] perf intel-pt: Remove guest_machine_pid
Date:   Mon, 11 Jul 2022 12:32:11 +0300
Message-Id: <20220711093218.10967-29-adrian.hunter@intel.com>
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

Remove guest_machine_pid because it is not needed.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/intel-pt.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index 62b2f375a94d..014f9f73cc49 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -194,7 +194,6 @@ struct intel_pt_queue {
 	struct machine *guest_machine;
 	struct thread *guest_thread;
 	struct thread *unknown_guest_thread;
-	pid_t guest_machine_pid;
 	bool exclude_kernel;
 	bool have_sample;
 	u64 time;
@@ -685,7 +684,7 @@ static int intel_pt_get_guest(struct intel_pt_queue *ptq)
 	struct machine *machine;
 	pid_t pid = ptq->pid <= 0 ? DEFAULT_GUEST_KERNEL_ID : ptq->pid;
 
-	if (ptq->guest_machine && pid == ptq->guest_machine_pid)
+	if (ptq->guest_machine && pid == ptq->guest_machine->pid)
 		return 0;
 
 	ptq->guest_machine = NULL;
@@ -705,7 +704,6 @@ static int intel_pt_get_guest(struct intel_pt_queue *ptq)
 		return -1;
 
 	ptq->guest_machine = machine;
-	ptq->guest_machine_pid = pid;
 
 	return 0;
 }
-- 
2.25.1

