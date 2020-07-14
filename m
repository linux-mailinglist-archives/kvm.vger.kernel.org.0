Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD54321E476
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 02:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgGNAX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 20:23:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:36936 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgGNAX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 20:23:57 -0400
IronPort-SDR: pahcKXbuCuu+gK2/YkwLG5SOE/RYdF4szZt4BAT4hg7t2r2J1KOwBVQeeglApbP+eYgo457oTC
 cAAQeoJhawyQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="136910634"
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="136910634"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 17:23:56 -0700
IronPort-SDR: jivkYAxrhZj2/1arEnDkQf/ghX/sfo78AkQA/TXkPLXkpQ9rqYysl07HrvMernpJnLnKhVAuKT
 n5TaiyD2QT6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="268505774"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jul 2020 17:23:56 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Karl Heubaum <karl.heubaum@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: [kvm-unit-tests PATCH 1/2] nVMX: Restore active host RIP/CR4 after test_host_addr_size()
Date:   Mon, 13 Jul 2020 17:23:54 -0700
Message-Id: <20200714002355.538-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200714002355.538-1-sean.j.christopherson@intel.com>
References: <20200714002355.538-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Perform one last VMX transition to actually load the host's RIP and CR4
at the end of test_host_addr_size().  Simply writing the VMCS doesn't
restore the values in hardware, e.g. as is, CR4.PCIDE can be left set,
which causes spectacularly confusing explosions when other misguided
tests assume setting bit 63 in CR3 will cause a non-canonical #GP.

Fixes: 0786c0316ac05 ("kvm-unit-test: nVMX: Check Host Address Space Size on vmentry of nested guests")
Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc: Karl Heubaum <karl.heubaum@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/vmx_tests.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 29f3d0e..cb42a2d 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7673,6 +7673,11 @@ static void test_host_addr_size(void)
 		vmcs_write(ENT_CONTROLS, entry_ctrl_saved | ENT_GUEST_64);
 		vmcs_write(HOST_RIP, rip_saved);
 		vmcs_write(HOST_CR4, cr4_saved);
+
+		/* Restore host's active RIP and CR4 values. */
+		report_prefix_pushf("restore host state");
+		test_vmx_vmlaunch(0);
+		report_prefix_pop();
 	}
 }
 
-- 
2.26.0

