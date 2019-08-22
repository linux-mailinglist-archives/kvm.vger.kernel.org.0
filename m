Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AACA9A40B
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 01:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfHVXrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 19:47:47 -0400
Received: from mga17.intel.com ([192.55.52.151]:15676 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727330AbfHVXrr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 19:47:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 16:47:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,419,1559545200"; 
   d="scan'208";a="203589304"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 22 Aug 2019 16:47:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [kvm-unit-tests PATCH] x86: Skip EPT tests that involve unrestricted guest when URG is disabled
Date:   Thu, 22 Aug 2019 16:47:46 -0700
Message-Id: <20190822234746.3379-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Fixes: f749ddc19bb2d ("nVMX x86: Check enable-EPT on vmentry of L2 guests")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 x86/vmx_tests.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 9078665..f035f24 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4797,6 +4797,9 @@ static void test_ept_eptp(void)
 	test_vmx_valid_controls(false);
 	report_prefix_pop();
 
+	if (!(ctrl_cpu_rev[1].clr & CPU_URG))
+		goto skip_unrestricted_guest;
+
 	secondary |= CPU_URG;
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("Enable-EPT disabled, unrestricted-guest enabled");
@@ -4809,6 +4812,7 @@ static void test_ept_eptp(void)
 	test_vmx_valid_controls(false);
 	report_prefix_pop();
 
+skip_unrestricted_guest:
 	secondary &= ~CPU_URG;
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
 	report_prefix_pushf("Enable-EPT enabled, unrestricted-guest disabled");
-- 
2.22.0

