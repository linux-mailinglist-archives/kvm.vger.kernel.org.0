Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FD61B64CC
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 21:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgDWTux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 15:50:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:7419 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbgDWTuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 15:50:52 -0400
IronPort-SDR: wq5zjxEVCd0JGhyujKq50iXT4/xkZmv9BjGB2xLzq9VG5u/F/1oKYWt7vsZMiuk55p+TIAW9Fb
 g3e4ATBIlAUA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 12:50:51 -0700
IronPort-SDR: Xh8kGbPqu2QGcXL0fIv142/Losh1MuQrRw2dlgFfXwA1cpMFjTlJqgkNsuAGjDxMcIRl4iPwpV
 UayHOKO/kxlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="366104195"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 23 Apr 2020 12:50:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nitesh Narayan Lal <nitesh@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH] x86: ioapic: Run physical destination mode test iff cpu_count() > 1
Date:   Thu, 23 Apr 2020 12:50:50 -0700
Message-Id: <20200423195050.26310-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make test_ioapic_physical_destination_mode() depending on having at
least two CPUs as it sets ->dest_id to '1', i.e. expects CPU0 and CPU1
to exist.  This analysis is backed up by the fact that the test was
originally gated by cpu_count() > 1.

Fixes: dcf27dc5b5499 ("x86: Fix the logical destination mode test")
Cc: Nitesh Narayan Lal <nitesh@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/ioapic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/x86/ioapic.c b/x86/ioapic.c
index 3106531..f315e4b 100644
--- a/x86/ioapic.c
+++ b/x86/ioapic.c
@@ -504,7 +504,8 @@ int main(void)
 	test_ioapic_level_tmr(true);
 	test_ioapic_edge_tmr(true);
 
-	test_ioapic_physical_destination_mode();
+	if (cpu_count() > 1)
+		test_ioapic_physical_destination_mode();
 	if (cpu_count() > 3)
 		test_ioapic_logical_destination_mode();
 
-- 
2.26.0

