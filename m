Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7923D35969C
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 09:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhDIHnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 03:43:17 -0400
Received: from mga04.intel.com ([192.55.52.120]:30006 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229751AbhDIHnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 03:43:17 -0400
IronPort-SDR: RcEna5pu8xMIp21wMNJ/mHFn77sWn44h0N8q2S/Z0IErMaVyORr5uU4BEJ7QyAHYhjOj0T1x0A
 hRsQDxIrkPig==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="191560039"
X-IronPort-AV: E=Sophos;i="5.82,208,1613462400"; 
   d="scan'208";a="191560039"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 00:43:05 -0700
IronPort-SDR: jAS780YL7WolSpmM2cAADVzf3M3ZmGn94XGB6Smo+hTMF8fFnTiBCOdOWC0l6u6OCQYHfazZJD
 0nbuHAJv3Z5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,208,1613462400"; 
   d="scan'208";a="450104302"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.166])
  by fmsmga002.fm.intel.com with ESMTP; 09 Apr 2021 00:43:03 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH] [kvm-unit-tests PATCH] x86/access: Fix intermittent test failure
Date:   Fri,  9 Apr 2021 15:55:18 +0800
Message-Id: <20210409075518.32065-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During kvm-unit-test, below failure pattern is observed, this is due to testing thread
migration + cache "lazy" flush during test, so forcely flush the cache to avoid the issue.
Pin the test app to certain physical CPU can fix the issue as well. The error report is
misleading, pke is the victim of the issue.

test user cr4.pke: FAIL: error code 5 expected 4
Dump mapping: address: 0x123400000000
------L4: 21ea007
------L3: 21eb007
------L2: 21ec000
------L1: 2000000

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 x86/access.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/x86/access.c b/x86/access.c
index 7dc9eb6..379d533 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -211,6 +211,8 @@ static unsigned set_cr4_smep(int smep)
         ptl2[2] |= PT_USER_MASK;
     if (!r)
         shadow_cr4 = cr4;
+
+    invlpg((void *)(ptl2[2] & ~PAGE_SIZE));
     return r;
 }
 
-- 
2.26.2

