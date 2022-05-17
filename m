Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2AC452A2D6
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 15:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347345AbiEQNMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 09:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347378AbiEQNLB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 09:11:01 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB49635DD0;
        Tue, 17 May 2022 06:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652793041; x=1684329041;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UGgiD+lsZ3LQDZgfT13E23wHzHRHsuBkOFD7vqgyL6k=;
  b=Cion5VUwW2qjedAu3N2lx1P4QVAEsa5I3nJUaeSG6OgeJSARW+wGw5st
   iILscKkcG13RrSfOj1KCfzbwICcO3aeG3nhN7eGJCBheAjXJO6R2MzMU3
   FuPvyngI3dAwKGUrgCNh8NhOOHbI8WDSm5TyjFtCTHiF+FxEhcGMkO0FL
   mIwr0qmkmnSJXD+OZIeVbnqjXXAEuZxJ4H3zo2okrrI4KkuA1jL+8oDea
   ioNU3qS9FQGea//WPUbWMPup7FpT+sN1P63ZJNZF5WOBSrDLEXylKLxwj
   xUZOcvu4J8CbwdeFPf46K7EXkzoxO+K/hF+KyQE9NehFy3xmocgbiBQT3
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="357588667"
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="357588667"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 06:10:41 -0700
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="713844355"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.52.217])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 06:10:38 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Leo Yan <leo.yan@linaro.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH V2 5/6] perf kvm report: Add guest_code support
Date:   Tue, 17 May 2022 16:10:10 +0300
Message-Id: <20220517131011.6117-6-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517131011.6117-1-adrian.hunter@intel.com>
References: <20220517131011.6117-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an option to indicate that guest code can be found in the hypervisor
process.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-kvm.txt | 3 +++
 tools/perf/builtin-kvm.c              | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index cf95baef7b61..83c742adf86e 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -94,6 +94,9 @@ OPTIONS
 	kernel module information. Users copy it out from guest os.
 --guestvmlinux=<path>::
 	Guest os kernel vmlinux.
+--guest-code::
+	Indicate that guest code can be found in the hypervisor process,
+	which is a common case for KVM test programs.
 -v::
 --verbose::
 	Be more verbose (show counter open errors, etc).
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 2fa687f73e5e..3696ae97f149 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1603,6 +1603,8 @@ int cmd_kvm(int argc, const char **argv)
 			   "file", "file saving guest os /proc/kallsyms"),
 		OPT_STRING(0, "guestmodules", &symbol_conf.default_guest_modules,
 			   "file", "file saving guest os /proc/modules"),
+		OPT_BOOLEAN(0, "guest-code", &symbol_conf.guest_code,
+			    "Guest code can be found in hypervisor process"),
 		OPT_INCR('v', "verbose", &verbose,
 			    "be more verbose (show counter open errors, etc)"),
 		OPT_END()
-- 
2.25.1

