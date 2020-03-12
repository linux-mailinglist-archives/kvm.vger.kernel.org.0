Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57DF0183D50
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 00:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgCLX1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 19:27:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:14954 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbgCLX1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 19:27:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 16:27:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="261705927"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 12 Mar 2020 16:27:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 1/8] nVMX: Eliminate superfluous entry_failure_handler() wrapper
Date:   Thu, 12 Mar 2020 16:27:38 -0700
Message-Id: <20200312232745.884-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312232745.884-1-sean.j.christopherson@intel.com>
References: <20200312232745.884-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check and invoke the current entry failure handler directly from
vmx_run() to eliminate an unnecessary layer and its stale comment.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/vmx.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 0f2521b..99c3791 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1631,21 +1631,6 @@ static int exit_handler(void)
 	return ret;
 }
 
-/*
- * Called if vmlaunch or vmresume fails.
- *	@early    - failure due to "VMX controls and host-state area" (26.2)
- *	@vmlaunch - was this a vmlaunch or vmresume
- *	@rflags   - host rflags
- */
-static int
-entry_failure_handler(struct vmentry_failure *failure)
-{
-	if (current->entry_failure_handler)
-		return current->entry_failure_handler(failure);
-	else
-		return VMX_TEST_EXIT;
-}
-
 /*
  * Tries to enter the guest. Returns true if entry succeeded. Otherwise,
  * populates @failure.
@@ -1704,8 +1689,10 @@ static int vmx_run(void)
 			 */
 			launched = 1;
 			ret = exit_handler();
+		} else if (current->entry_failure_handler) {
+			ret = current->entry_failure_handler(failure);
 		} else {
-			ret = entry_failure_handler(&failure);
+			ret = VMX_TEST_EXIT;
 		}
 
 		switch (ret) {
-- 
2.24.1

