Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D43E7D48FC
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 09:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbjJXHvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 03:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233780AbjJXHvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 03:51:04 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9208210C1;
        Tue, 24 Oct 2023 00:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698133861; x=1729669861;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u6MzaXZPQ2+ms1NvX7VYQhNTuFQzAl/oK9iR7mXcQ0U=;
  b=a8VMyX1mIV1AQ4t1re4RhdyDbX+1wty1mjNGGFQ0LrJp1njK6tpilLvh
   Mnv1Hv7xGbSsHf2b1rrRpO69xDJFMmB4u3ZQ42oH9p2XA/kJw4/32oZDR
   x9cv8QapxGu1fSJAJNgRfpd6RODsy/jkvfFAersWEtBD2UY8LMr24gzaS
   j4OswjeImYaY9MScfYrDtMXaodClL1FXGby/z4mXn7Cw8iZgA4NQqASQX
   Y3yHaeMk3dt5aYr5ohLBxOOEni32KxK1p2P7u/HX05+zQ8eNhRvQO5lZE
   sb/tABgLSnVNHtzHJyjs1A8BcZz0daFiLUPHzLt5/zm5e8v2m4ITJGE1K
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="367235196"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="367235196"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 00:51:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="1089766271"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="1089766271"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga005.fm.intel.com with ESMTP; 24 Oct 2023 00:50:58 -0700
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
Subject: [kvm-unit-tests Patch 2/5] x86: pmu: Change the minimum value of llc_misses event to 0
Date:   Tue, 24 Oct 2023 15:57:45 +0800
Message-Id: <20231024075748.1675382-3-dapeng1.mi@linux.intel.com>
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

Along with the CPU HW's upgrade and optimization, the count of LLC
misses event for running loop() helper could be 0 just like seen on
Sapphire Rapids.

So modify the lower limit of possible count range for LLC misses
events to 0 to avoid LLC misses event test failure on Sapphire Rapids.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 0def28695c70..7443fdab5c8a 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -35,7 +35,7 @@ struct pmu_event {
 	{"instructions", 0x00c0, 10*N, 10.2*N},
 	{"ref cycles", 0x013c, 1*N, 30*N},
 	{"llc references", 0x4f2e, 1, 2*N},
-	{"llc misses", 0x412e, 1, 1*N},
+	{"llc misses", 0x412e, 0, 1*N},
 	{"branches", 0x00c4, 1*N, 1.1*N},
 	{"branch misses", 0x00c5, 0, 0.1*N},
 }, amd_gp_events[] = {
-- 
2.34.1

