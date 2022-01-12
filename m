Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA33C48BD78
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 03:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348977AbiALCz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 21:55:27 -0500
Received: from mga07.intel.com ([134.134.136.100]:27147 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348979AbiALCz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 21:55:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641956126; x=1673492126;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZknjokQ5wJiAvIBLQY3zcdxlAc94u6ZD6qxRyPaMHqI=;
  b=VTpd5E3L18epb4YTzMdMmcjiyHuX9SyBz/ZdH70adGRJOswttZmfRWvr
   AYsl0JtqL5MQKY2PaqbavaSAFmE2ZOjZ6PiN/exYog7bbK/rc7FZ16mxJ
   0xLpB9k2vH39mtSc093NtYsoPw1ZxdftjB3jKhYbbvNKmmFFxl7NiQyWq
   22areNi6UeC+J/ChLv1WobwdV+IQFupMkgt0fu9PHkxelmGIHFcGtEWc+
   7YAYJ9CR5iJfmDxMdOiR6lzs99hXnUa258gus+cEwyv+WwSFkFgSMCzJP
   huDricKaLF/RI+2DnE7+CvKSwLhsqjDh6k6SQCfYV6xQzobGQhi94wZ42
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10224"; a="306998280"
X-IronPort-AV: E=Sophos;i="5.88,281,1635231600"; 
   d="scan'208";a="306998280"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 18:55:26 -0800
X-IronPort-AV: E=Sophos;i="5.88,281,1635231600"; 
   d="scan'208";a="528999432"
Received: from duan-client-optiplex-7080.bj.intel.com ([10.238.156.117])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 18:55:24 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH v2] x86: Assign a canonical address before execute invpcid
Date:   Wed, 12 Jan 2022 10:55:35 +0800
Message-Id: <20220112025535.430455-1-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Accidently we see pcid test falied as INVPCID_DESC[127:64] is
uninitialized before execute invpcid.

According to Intel spec: "#GP If INVPCID_TYPE is 0 and the linear
address in INVPCID_DESC[127:64] is not canonical."

By zeroing the whole invpcid_desc structure, ensure the address
canonical and reserved bit zero in desc.

Fixes: b44d84dae10c ("Add PCID/INVPCID test")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
---
 x86/pcid.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/x86/pcid.c b/x86/pcid.c
index 527a4a9..80a4611 100644
--- a/x86/pcid.c
+++ b/x86/pcid.c
@@ -5,9 +5,9 @@
 #include "desc.h"
 
 struct invpcid_desc {
-    unsigned long pcid : 12;
-    unsigned long rsv  : 52;
-    unsigned long addr : 64;
+    u64 pcid : 12;
+    u64 rsv  : 52;
+    u64 addr : 64;
 };
 
 static int write_cr0_checking(unsigned long val)
@@ -73,12 +73,12 @@ static void test_invpcid_enabled(int pcid_enabled)
     int passed = 0, i;
     ulong cr4 = read_cr4();
     struct invpcid_desc desc;
-    desc.rsv = 0;
+
+    memset(&desc, 0, sizeof(desc));
 
     /* try executing invpcid when CR4.PCIDE=0, desc.pcid=0 and type=0..3
      * no exception expected
      */
-    desc.pcid = 0;
     for (i = 0; i < 4; i++) {
         if (invpcid_checking(i, &desc) != 0)
             goto report;
-- 
2.25.1

