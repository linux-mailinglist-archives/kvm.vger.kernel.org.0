Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F76B183D4C
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 00:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgCLX1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 19:27:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:14955 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbgCLX1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 19:27:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 16:27:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="261705936"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 12 Mar 2020 16:27:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 4/8] nVMX: Drop redundant check for guest termination
Date:   Thu, 12 Mar 2020 16:27:41 -0700
Message-Id: <20200312232745.884-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312232745.884-1-sean.j.christopherson@intel.com>
References: <20200312232745.884-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the check_for_guest_termination() call in
enter_guest_with_bad_controls() as __enter_guest() unconditionally
performs the check if VM-Enter is successful (and aborts on failed
VM-Entry for the ...bad_controls() variant).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/vmx.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index da17807..d92350d 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1895,16 +1895,6 @@ void enter_guest_with_bad_controls(void)
 	report(vmcs_read(VMX_INST_ERROR) == VMXERR_ENTRY_INVALID_CONTROL_FIELD,
 	       "VM-Inst Error # is %d (VM entry with invalid control field(s))",
 	       VMXERR_ENTRY_INVALID_CONTROL_FIELD);
-
-	/*
-	 * This if statement shouldn't fire, as the entire premise of this
-	 * function is that VM entry is expected to fail, rather than succeed
-	 * and execute to termination. However, if the VM entry does
-	 * unexpectedly succeed, it's nice to check whether the guest has
-	 * terminated, to reduce the number of error messages.
-	 */
-	if (!result.vm_fail)
-		check_for_guest_termination();
 }
 
 void enter_guest(void)
-- 
2.24.1

