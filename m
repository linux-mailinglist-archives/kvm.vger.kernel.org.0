Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1377D48FE
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 09:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbjJXHvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 03:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbjJXHvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 03:51:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACB210C0;
        Tue, 24 Oct 2023 00:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698133866; x=1729669866;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+AbwY0EJ42oSmqGLiVvQ29v7o8KNMXXfoBc4PPnmCiI=;
  b=kISNShtqH1NKYVqoeMA/X3Nys0ayQ5vRgzaKmt+ISwAL4KyMaHguRu/s
   pIcciA8HuQekBNSTwwFeixR0BA1yTXix9x219snIskl5E8NmsQ76ezyWc
   fRkGggtQP+Xp0Ihd2ObUZKzfiQj2Jv1fBs1iZq40O3JqHGTTYH+fe453H
   GZZWCJtnSKodehBrlcKgUapz2xP4ZaOT/0UjbSzHVANN0lyL34l2soTnX
   teNDfP65ePPrZJFVh0mzDrSe/Q2+VFYRHE/4+sAzgpM2NeIjYgXRUYFtG
   JYN22qVssrtM6izjsA6VkhSZI9QbN/YZ0qu6dHWoqbkVN+HE7vjA8nC9v
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="367235211"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="367235211"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 00:51:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="1089766298"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="1089766298"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga005.fm.intel.com with ESMTP; 24 Oct 2023 00:51:02 -0700
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
Subject: [kvm-unit-tests Patch 3/5] x86: pmu: Enlarge cnt array length to 64 in check_counters_many()
Date:   Tue, 24 Oct 2023 15:57:46 +0800
Message-Id: <20231024075748.1675382-4-dapeng1.mi@linux.intel.com>
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

Considering there are already 8 GP counters and 4 fixed counters on
latest Intel CPUs, like Sapphire Rapids. The original cnt array length
10 is definitely not enough to cover all supported PMU counters on these
new CPUs and it would cause PMU counter validation failures.

It's probably more and more GP and fixed counters are introduced in the
future and then directly extends the cnt array length to 64.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 x86/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 7443fdab5c8a..1bebf493d4a4 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -254,7 +254,7 @@ static void check_fixed_counters(void)
 
 static void check_counters_many(void)
 {
-	pmu_counter_t cnt[10];
+	pmu_counter_t cnt[64];
 	int i, n;
 
 	for (i = 0, n = 0; n < pmu.nr_gp_counters; i++) {
-- 
2.34.1

