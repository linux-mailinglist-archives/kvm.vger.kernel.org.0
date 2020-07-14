Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E85F21E6C6
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 06:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgGNETH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 00:19:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:57766 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbgGNETG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 00:19:06 -0400
IronPort-SDR: inhvhqZL3mTaf6/WCnU0Fgm/JIuUXJZYHa9BWXsx/5Bd8JdaVqwH8apx6/1MugNTCFfTttg6fJ
 Iam81+tNKOzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="136946947"
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="136946947"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 21:19:06 -0700
IronPort-SDR: 2+tugN3/UebKnAOuXoR26kZzyBzvvT7js/ZgQpQjrGtrPVEkNEaefQj5GxesSKFeuE+XsZaRWP
 jEC6kuoLb5TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,350,1589266800"; 
   d="scan'208";a="307712916"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 13 Jul 2020 21:19:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH] cstart: Fix typo in i386's cstart assembly
Date:   Mon, 13 Jul 2020 21:19:05 -0700
Message-Id: <20200714041905.12848-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace a '%' with a '$' to encode a literal in when initializing CR4.
This fixes the build on i386 as gcc complains about a non-existent
register.

  x86/cstart.S: Assembler messages:
  x86/cstart.S:128: Error: bad register name `%(1<<4)'
  Makefile:101: recipe for target 'x86/cstart.o' failed

Fixes: d86ef58519645 ("cstart: do not assume CR4 starts as zero")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/cstart.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/cstart.S b/x86/cstart.S
index e63e4e2..c0efc5f 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -125,7 +125,7 @@ start:
         jmpl $8, $start32
 
 prepare_32:
-	mov %(1 << 4), %eax // pse
+	mov $(1 << 4), %eax // pse
 	mov %eax, %cr4
 
 	mov $pt, %eax
-- 
2.26.0

