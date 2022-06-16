Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1FE54EC98
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 23:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378826AbiFPVbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 17:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378548AbiFPVbQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 17:31:16 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D4761299;
        Thu, 16 Jun 2022 14:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655415076; x=1686951076;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=fbbL5YLQP0MasUHy7YV1k35vvgrXQQq2fNl3ZEoDQ3Y=;
  b=d3r6H0NyAwn1nbLnhJTw1odjqMTIikaIhyX9x5iMyQ2pYiwRLgaCXZE1
   BGkg9Z5euWw8Gw0++X2Df4HZYHy4rdmGS4CqJRqrfgOCPMjvwpx54roet
   1q0SBYKNd8JJTo5j8zPTntSs/4MRjmTkruabn5EmKeFefRjmdPdrc5KNt
   Dw5q8rQIzGNwNqZcyLHF8XyEmAQT4KPGCAcde8v+nAgJv9jJEotbYzWj5
   5XI+T+9R2uDU8FyqOGwvWbG5LPj7nJPsk4wSLGMVPHRRSPeejdXF1uu7m
   2fdeKwKaW78tYBgQzYNfFtaO/vMaUOL4LGR76yHcymktdeltwkapoPuBZ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="280389925"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="280389925"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 14:31:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="589824135"
Received: from chang-linux-3.sc.intel.com ([172.25.66.173])
  by fmsmga007.fm.intel.com with ESMTP; 16 Jun 2022 14:31:15 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     dave.hansen@intel.com, len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com
Cc:     corbet@lwn.net, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com
Subject: [PATCH 2/2] Documentation/x86: Explain guest XSTATE permission control
Date:   Thu, 16 Jun 2022 14:22:10 -0700
Message-Id: <20220616212210.3182-3-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220616212210.3182-1-chang.seok.bae@intel.com>
References: <20220616212210.3182-1-chang.seok.bae@intel.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 980fe2fddcff ("x86/fpu: Extend fpu_xstate_prctl() with guest
permissions") extends a couple of arch_prctl(2) options for VCPU threads.
Add description for them.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Thiago Macieira <thiago.macieira@intel.com>
Reviewed-by: Yang Zhong <yang.zhong@intel.com>
Cc: kvm@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/x86/xstate.rst | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/x86/xstate.rst b/Documentation/x86/xstate.rst
index 9597e6caa30e..55cbce580853 100644
--- a/Documentation/x86/xstate.rst
+++ b/Documentation/x86/xstate.rst
@@ -64,6 +64,27 @@ the handler allocates a larger xstate buffer for the task so the large
 state can be context switched. In the unlikely cases that the allocation
 fails, the kernel sends SIGSEGV.
 
+In addition, a couple of extended options are provided for a VCPU thread.
+The VCPU XSTATE permission is separately controlled.
+
+-ARCH_GET_XCOMP_GUEST_PERM
+
+ arch_prctl(ARCH_GET_XCOMP_GUEST_PERM, &features);
+
+ ARCH_GET_XCOMP_GUEST_PERM is a variant of ARCH_GET_XCOMP_PERM. So it
+ provides the same semantics and functionality but for VCPU.
+
+-ARCH_REQ_XCOMP_GUEST_PERM
+
+ arch_prctl(ARCH_REQ_XCOMP_GUEST_PERM, feature_nr);
+
+ ARCH_REQ_XCOMP_GUEST_PERM is a variant of ARCH_REQ_XCOMP_PERM. Like the
+ above, it has the same semantics for VCPU permission. It performs a
+ similar functionality but with a constraint. Permission is frozen when the
+ first VCPU is created. So any attempt to change permission after that
+ point is rejected. Thus, permission has to be requested before the first
+ VCPU creation.
+
 AMX TILE_DATA enabling example
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-- 
2.17.1

