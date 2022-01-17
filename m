Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CF2490439
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 09:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiAQIpI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 03:45:08 -0500
Received: from mga05.intel.com ([192.55.52.43]:7368 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbiAQIpH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 03:45:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642409107; x=1673945107;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BDnnfOwwMVXfAb1fsMRdFW0YajTnPjDc8ft+CxWRSZ4=;
  b=CD6QKsorZqtNWFNlDDHxBOsZu5ZC/MTjl5KQmYIE81JCCVv7biusiQS/
   rX/zrQROkz9kgThd+4KEdbXYz+Uq4dyfy1o/1i4pLxDOAyZ/hqVwf6BcG
   gWg0nqiTtakOYYPVVk6jxl3BN2XnOMM00KgBjRmVfCdxoDAmLvcbLE/JG
   KycNL8VLjw0yqnA4G06Ga946Utc16IYb6fSmyle/hG8K53VZaCC1Q9kyY
   jsUB5pQD3y7zbKIsH99cXY64aBwhYh5Ni+leEYfBx5QstWuCSlOIDk3bd
   TWZ7XV9cK8HwWn7sdbMrEq+hYughngnkBKQtTcMBNvrlKpmhncLFbW3a7
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10229"; a="330932136"
X-IronPort-AV: E=Sophos;i="5.88,295,1635231600"; 
   d="scan'208";a="330932136"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 00:45:06 -0800
X-IronPort-AV: E=Sophos;i="5.88,295,1635231600"; 
   d="scan'208";a="476567732"
Received: from duan-client-optiplex-7080.bj.intel.com ([10.238.156.117])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 00:45:04 -0800
From:   Zhenzhong Duan <zhenzhong.duan@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH v3] x86: Assign a canonical address before execute invpcid
Date:   Mon, 17 Jan 2022 16:46:18 +0800
Message-Id: <20220117084618.442906-1-zhenzhong.duan@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Accidently we see pcid test failed as INVPCID_DESC[127:64] is
uninitialized before execute invpcid.

According to Intel spec: "#GP If INVPCID_TYPE is 0 and the linear
address in INVPCID_DESC[127:64] is not canonical."

By zeroing the whole invpcid_desc structure, ensure the address
canonical and reserved bit zero in desc.

By this chance change invpcid_desc to be 128bit in size no matter
in 64bit or 32bit mode to match the description in spec, even
though this test case is 64bit only.

Fixes: b44d84dae10c ("Add PCID/INVPCID test")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
v3: update patch description

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

