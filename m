Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0CCD56FEAA
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 12:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbiGKKPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 06:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234781AbiGKKOF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 06:14:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43ED6F7D9;
        Mon, 11 Jul 2022 02:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657532059; x=1689068059;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yEt0I/FFUguNvKkJOIvDFgd89TpVan3ZgvsnVogUxPk=;
  b=BJ9F/PSVnR8dIlSMqp2R6sQ9Wj82Ort9Li/1VhcGQIbwnjm2XHEm29mG
   U1Bv6Ygw/PEXIN1C4rCAbCA/vsT5GIKPJx8YmGoObpwzpUWKpGfkIorq+
   t6Zl+6TKJiP+CQRoJXlqWX99IvDO1utWpkpNWC/m3gJlhRH0lzotgt8B2
   MCiu1Y7J2/ZJrAleoT8EmZCtj3I1BfI5xKkKUmdM73vCUYMqZO6/ZGStr
   AHpnbQX/Z8OHXfIGsxNmN/BE4dF6R8/SWEKTEzhl9k9h9ANb5ntBN++F+
   lSyrES7avli0OjDOCnYRZPAba33EWhN12iipy0jNP8t7PxYZaE1xJo1r/
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10404"; a="283371752"
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="283371752"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:34:01 -0700
X-IronPort-AV: E=Sophos;i="5.92,262,1650956400"; 
   d="scan'208";a="652387301"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO ahunter-VirtualBox.home\044ger.corp.intel.com) ([10.252.51.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 02:33:59 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 34/35] perf intel-pt: Use guest pid/tid etc in guest samples
Date:   Mon, 11 Jul 2022 12:32:17 +0300
Message-Id: <20220711093218.10967-35-adrian.hunter@intel.com>
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

When decoding with guest sideband information, for VMX non-root (NR)
i.e. guest events, replace the host (hypervisor) pid/tid with guest values,
and provide also the new machine_pid and vcpu values.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/intel-pt.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index 143a096b567b..d5e9fc8106dd 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -1657,6 +1657,17 @@ static void intel_pt_prep_a_sample(struct intel_pt_queue *ptq,
 
 	sample->pid = ptq->pid;
 	sample->tid = ptq->tid;
+
+	if (ptq->pt->have_guest_sideband) {
+		if ((ptq->state->from_ip && ptq->state->from_nr) ||
+		    (ptq->state->to_ip && ptq->state->to_nr)) {
+			sample->pid = ptq->guest_pid;
+			sample->tid = ptq->guest_tid;
+			sample->machine_pid = ptq->guest_machine_pid;
+			sample->vcpu = ptq->vcpu;
+		}
+	}
+
 	sample->cpu = ptq->cpu;
 	sample->insn_len = ptq->insn_len;
 	memcpy(sample->insn, ptq->insn, INTEL_PT_INSN_BUF_SZ);
-- 
2.25.1

