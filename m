Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1060B17EF70
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 04:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgCJDrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 23:47:31 -0400
Received: from mga06.intel.com ([134.134.136.31]:21693 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbgCJDrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 23:47:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Mar 2020 20:47:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,535,1574150400"; 
   d="scan'208";a="388781384"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 09 Mar 2020 20:47:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] x86: Reload SS when switching to 5-level page tables
Date:   Mon,  9 Mar 2020 20:47:29 -0700
Message-Id: <20200310034729.2941-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Load SS with a valid segment when switching to 5-level page tables to
avoid taking a #SS due to a NULL segment when making a CALL with paging
disabled.

The "access" test calls setup_5level_page_table()/switch_to_5level()
after generating and handling usermode exceptions.  Per Intel's SDM,
SS is nullified on an exception that changes CPL:

  The new SS is set to NULL if there is a change in CPL.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/cstart64.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/x86/cstart64.S b/x86/cstart64.S
index 6c1c87d..cffbb07 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -159,6 +159,9 @@ switch_to_5level:
 	bts $12, %eax
 	mov %eax, %cr4
 
+	mov $0x10, %ax
+	mov %ax, %ss
+
 	call enter_long_mode
 	jmpl $8, $lvl5
 
-- 
2.24.1

