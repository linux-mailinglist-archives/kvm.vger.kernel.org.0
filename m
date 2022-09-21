Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AECD85C04A8
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 18:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbiIUQun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 12:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiIUQuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 12:50:17 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C92851425;
        Wed, 21 Sep 2022 09:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663778732; x=1695314732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9Rh9QI5021plHVnKQ/4sO96yjSHLmYjQeIDsxL6/qIg=;
  b=N2bg2b5z8Q+pTVO5IGXSgMvzrqOhGDw/WxwzPQqvi/BIFK2UGNBoDz/c
   a9SUXZGQx9++EaQ2JiwkHHu3cpLw5XRrnINy/spVuxxEP3/M5I3iJ9GKS
   TgqPeIImQOrQ85H02NBoKanu6yBb1jAP43xtltuV7QAJ4ZzUqGOosPCpt
   hPPQyT/qaMuEEE1DfkeP9v3QE7WhPc70TKwEybPAa+BEOQFXWIeBMMvVe
   6umASJYVRbx+VnOyUWVnEvsKa/COd5uqeJ6ONmFJQvc6WNG8gBcDvRdxH
   vC7C7Jk3IW9XgYtuFUvssROzredkCK+bJjT22s6TyXJ5LimYZtqXvHwVS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="300044923"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="300044923"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 09:45:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="948227915"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by fmsmga005.fm.intel.com with ESMTP; 21 Sep 2022 09:45:25 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, wei.w.wang@intel.com,
        kan.liang@linux.intel.com
Cc:     xiaoyao.li@intel.com, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [RFC PATCH v2 1/3] perf/core: Expose perf_event_{en,dis}able_local()
Date:   Thu, 22 Sep 2022 00:45:19 +0800
Message-Id: <20220921164521.2858932-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220921164521.2858932-1-xiaoyao.li@intel.com>
References: <20220921164521.2858932-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM needs them to disable/enable an Intel PT perf event before
vm-entry/after vm-exit.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 include/linux/perf_event.h | 1 +
 kernel/events/core.c       | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ee8b9ecdc03b..fc5f3952d6a2 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1472,6 +1472,7 @@ extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern u64 perf_swevent_set_period(struct perf_event *event);
 extern void perf_event_enable(struct perf_event *event);
+extern void perf_event_enable_local(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_disable_local(struct perf_event *event);
 extern void perf_event_disable_inatomic(struct perf_event *event);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2621fd24ad26..8324bb99c6bf 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2446,6 +2446,7 @@ void perf_event_disable_local(struct perf_event *event)
 {
 	event_function_local(event, __perf_event_disable, NULL);
 }
+EXPORT_SYMBOL_GPL(perf_event_disable_local);
 
 /*
  * Strictly speaking kernel users cannot create groups and therefore this
@@ -2984,6 +2985,12 @@ static void _perf_event_enable(struct perf_event *event)
 	event_function_call(event, __perf_event_enable, NULL);
 }
 
+void perf_event_enable_local(struct perf_event *event)
+{
+	event_function_local(event, __perf_event_enable, NULL);
+}
+EXPORT_SYMBOL_GPL(perf_event_enable_local);
+
 /*
  * See perf_event_disable();
  */
-- 
2.27.0

