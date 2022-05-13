Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F14C525E5D
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 11:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378846AbiEMJDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 05:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378828AbiEMJDG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 05:03:06 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C315994E9;
        Fri, 13 May 2022 02:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652432584; x=1683968584;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4u7kPxkI+qIYW7/lB1AUNG4A0JsQhATwJmmL079dvs4=;
  b=B9N4j/68B6/aArFPSvwQlqTRgPbQ4qgpuhJU8fj1Dy/YI2VUIEZlBz7h
   UkO1+izhodQddLhvlYMWg6a1yffrnVBPWpmpRuCc3haPmXS1U/hUF39u2
   QpgpoqfXgNNH0p2rMDONWlKLRR5oEAd+oz+TkbYMhoY6E27aMwf8zBNAv
   s1XKAbfhPuYuqK7jscSjv/Oee25VQ7xHDQIQtogYemc/DQfvgcoToDHPY
   o9dQDli9/8SNafjKEK8ZyjaB7C0AuiyUqIDZ+4xmai4abD+Wu+/7UVxba
   plLv95LN4tQbjhKN956xVSZpoZAJpAXFY3lGw23wuXpZQhaLmDtoFqDKa
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="330856492"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="330856492"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 02:03:04 -0700
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="595129665"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.36.190])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 02:03:01 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Leo Yan <leo.yan@linaro.org>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 4/6] perf script: Add guest_code support
Date:   Fri, 13 May 2022 12:02:35 +0300
Message-Id: <20220513090237.10444-5-adrian.hunter@intel.com>
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

