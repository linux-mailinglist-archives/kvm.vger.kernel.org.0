Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C1E52A2DF
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 15:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347442AbiEQNMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 09:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347327AbiEQNKp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 09:10:45 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E9D3587F;
        Tue, 17 May 2022 06:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652793038; x=1684329038;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4u7kPxkI+qIYW7/lB1AUNG4A0JsQhATwJmmL079dvs4=;
  b=CynHTmnY+Z3oz3ltoB5aXEWOZt/0EPZHUn6fEE1cPIgJuJKM6R5BKsTe
   C+Crq+OUJewDNzZy1QbOMhV56V9Sb5hTaPnXJCgJkRcEPWO61Jt6XbDqy
   odTdwEqfIFkKxCoLISKbuW2RdXaXM0kt9TR751v+s3AwxyuwkMjpL1WQh
   LVEwR9J6oTtkdFW6PLUBGbJE7WnJ1xzQ/yYOE72YqITB6sN+ZRgdG4AFy
   Vl1mS3vuoLLy3JA36IQkheu8fTNYEPDNR/Dgvvwb0CkjqCLfBfd1fAZdV
   uBuK8fAaYDVANqNhqWqO3J9RXBT81qRturgcako1809pvYCqbUDuJrpcT
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="271300120"
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="271300120"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 06:10:38 -0700
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="713844330"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.52.217])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 06:10:36 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Leo Yan <leo.yan@linaro.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH V2 4/6] perf script: Add guest_code support
Date:   Tue, 17 May 2022 16:10:09 +0300
Message-Id: <20220517131011.6117-5-adrian.hunter@intel.com>
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

Add an option to indicate that guest code can be found in the hypervisor
process.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-script.txt | 4 ++++
 tools/perf/builtin-script.c              | 5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 2012a8e6c90b..1a557ff8f210 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -499,6 +499,10 @@ include::itrace.txt[]
 	The known limitations include exception handing such as
 	setjmp/longjmp will have calls/returns not match.
 
+--guest-code::
+	Indicate that guest code can be found in the hypervisor process,
+	which is a common case for KVM test programs.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index cf5eab5431b4..96a2106a3dac 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -3884,6 +3884,8 @@ int cmd_script(int argc, const char **argv)
 		   "file", "file saving guest os /proc/kallsyms"),
 	OPT_STRING(0, "guestmodules", &symbol_conf.default_guest_modules,
 		   "file", "file saving guest os /proc/modules"),
+	OPT_BOOLEAN(0, "guest-code", &symbol_conf.guest_code,
+		    "Guest code can be found in hypervisor process"),
 	OPT_BOOLEAN('\0', "stitch-lbr", &script.stitch_lbr,
 		    "Enable LBR callgraph stitching approach"),
 	OPTS_EVSWITCH(&script.evswitch),
@@ -3909,7 +3911,8 @@ int cmd_script(int argc, const char **argv)
 	if (symbol_conf.guestmount ||
 	    symbol_conf.default_guest_vmlinux_name ||
 	    symbol_conf.default_guest_kallsyms ||
-	    symbol_conf.default_guest_modules) {
+	    symbol_conf.default_guest_modules ||
+	    symbol_conf.guest_code) {
 		/*
 		 * Enable guest sample processing.
 		 */
-- 
2.25.1

