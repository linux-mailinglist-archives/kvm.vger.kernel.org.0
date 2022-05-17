Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7A552A2C4
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 15:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347251AbiEQNKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 09:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347218AbiEQNKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 09:10:30 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3573526B;
        Tue, 17 May 2022 06:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652793030; x=1684329030;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/iND+4oDvVkD/6SGZOA2dZZ9Z7Of4oGc/qJILLKB+gA=;
  b=gDA7U7gyoyebxXi5C/SYs7WOMvA3MwLtWyh2QDlSimcY0CAMkjNj/dBx
   8mjdVKUdZwK82bIkRAAJRO9vjlk3ZuLLEc6AlXxJ27RJU7Lg70uMFj8An
   eSi5WI+9XbFmf6LVnfqEDHikv1NHjLR6CKfD7V+NHnW6giAJEoy/xsn1f
   29wi3SwFq+p74kgBFo3+Us2tXBXfi1ajvZ9zhffzT0EOCv7bSSP5S/yc+
   /LuP7xzuOnHDXu40yVIpouy5jY37MIoBOdrBEDiUTmSKQVCNgPc4X2ZDV
   7QO/VwVhVFT2aFlfsgZabliH2nl5i0o+V7ZMrn7zG1MdajDAwryi4ccQ8
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="271300104"
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="271300104"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 06:10:30 -0700
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="713844253"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.52.217])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 06:10:27 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Leo Yan <leo.yan@linaro.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH V2 1/6] perf tools: Add machine to machines back pointer
Date:   Tue, 17 May 2022 16:10:06 +0300
Message-Id: <20220517131011.6117-2-adrian.hunter@intel.com>
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

