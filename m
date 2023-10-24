Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B9B7D48FF
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 09:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbjJXHva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 03:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbjJXHvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 03:51:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC87910C8;
        Tue, 24 Oct 2023 00:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698133869; x=1729669869;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UbICHGnYTIwYlJEuHD00SpbTkeQ8YKitQTi1EDFv9go=;
  b=RaKhpeOYB4NmxmK6dDYdj4mUlLZqGm1QAPL6AIp1vCx+eZNgEERiuNmV
   5nQ32fKTl7aGf4Gg5NXNvUTNTLaR6OyqoCN7GNUhPtRGdBEADb+EYsY74
   CQMWE8UR+mtWaIoY3ldsYvPYZ/JBC6NvHoYZiKMk5RkTuPV1VqjvRUU57
   tJ1JiCGkGL4UrbpsGZCA9UfEvy06PyrslWlDWHkmaX5pedry9h8kCb0oM
   Qi1YFdBmEGTUM+aelWElE1YOXk1YdOK2D8v+sCV9YddeXbioivIlJ9jxK
   4Q6EvFWMbLkVoaL56Mr06CuZAzD7QRu4OzDlTcpPwgNJ+uJ0ZF8/csK0D
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="367235220"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="367235220"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 00:51:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="1089766319"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="1089766319"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga005.fm.intel.com with ESMTP; 24 Oct 2023 00:51:06 -0700
From:   Dapeng Mi <dapeng1.mi@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [kvm-unit-tests Patch 4/5] x86: pmu: Support validation for Intel PMU fixed counter 3
Date:   Tue, 24 Oct 2023 15:57:47 +0800
Message-Id: <20231024075748.1675382-5-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231024075748.1675382-1-dapeng1.mi@linux.intel.com>
References: <20231024075748.1675382-1-dapeng1.mi@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel CPUs, like Sapphire Rapids, introduces a new fixed counter
(fixed counter 3) to counter/sample topdown.slots event, but current
code still doesn't cover this new fixed counter.

So add code to validate this new fixed counter.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 1bebf493d4a4..41165e168d8e 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -46,7 +46,8 @@ struct pmu_event {
 }, fixed_events[] = {
 	{"fixed 1", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
 	{"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
-	{"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
+	{"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N},
+	{"fixed 4", MSR_CORE_PERF_FIXED_CTR0 + 3, 1*N, 100*N}
 };
 
 char *buf;
-- 
2.34.1

