Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 268EFDBA51
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 01:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441842AbfJQXus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 19:50:48 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:63936 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441804AbfJQXus (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 19:50:48 -0400
X-IronPort-AV: E=Sophos;i="5.67,309,1566864000"; 
   d="scan'208";a="760065658"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 17 Oct 2019 23:50:46 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id E70DFA1C0B;
        Thu, 17 Oct 2019 23:50:45 +0000 (UTC)
Received: from EX13D30UWB001.ant.amazon.com (10.43.161.80) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 17 Oct 2019 23:50:45 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D30UWB001.ant.amazon.com (10.43.161.80) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 17 Oct 2019 23:50:45 +0000
Received: from dev-dsk-surajjs-2c-3edee245.us-west-2.amazon.com (172.19.3.110)
 by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 17 Oct 2019 23:50:45 +0000
Received: by dev-dsk-surajjs-2c-3edee245.us-west-2.amazon.com (Postfix, from userid 10505755)
        id 204DB89BAF; Thu, 17 Oct 2019 23:50:45 +0000 (UTC)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     <kvm@vger.kernel.org>
CC:     <surajjs@amazon.com>, <wanpengli@tencent.com>,
        <rkrcmar@redhat.com>,
        "Suraj Jitindar Singh" <sjitindarsingh@gmail.com>
Subject: [kvm-unit-tests PATCH] x86/apic: Skip pv ipi test if hcall not available
Date:   Thu, 17 Oct 2019 23:50:36 +0000
Message-ID: <20191017235036.25624-1-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.15.3.AMZN
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Suraj Jitindar Singh <surajjs@amazon.com>

The test in x86/apic.c named test_pv_ipi is used to test for a kernel
bug where a guest making the hcall KVM_HC_SEND_IPI can trigger an out of
bounds access.

If the host doesn't implement this hcall then the out of bounds access
cannot be triggered.

Detect the case where the host doesn't implement the KVM_HC_SEND_IPI
hcall and skip the test when this is the case, as the test doesn't
apply.

Output without patch:
FAIL: PV IPIs testing

With patch:
SKIP: PV IPIs testing: h-call not available

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 x86/apic.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/x86/apic.c b/x86/apic.c
index eb785c4..bd44b54 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -8,6 +8,8 @@
 #include "atomic.h"
 #include "fwcfg.h"
 
+#include <linux/kvm_para.h>
+
 #define MAX_TPR			0xf
 
 static void test_lapic_existence(void)
@@ -638,6 +640,15 @@ static void test_pv_ipi(void)
     unsigned long a0 = 0xFFFFFFFF, a1 = 0, a2 = 0xFFFFFFFF, a3 = 0x0;
 
     asm volatile("vmcall" : "=a"(ret) :"a"(KVM_HC_SEND_IPI), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
+    /*
+     * Detect the case where the hcall is not implemented by the hypervisor and
+     * skip this test if this is the case. Is the hcall isn't implemented then
+     * the bug that this test is trying to catch can't be triggered.
+     */
+    if (ret == -KVM_ENOSYS) {
+	    report_skip("PV IPIs testing: h-call not available");
+	    return;
+    }
     report("PV IPIs testing", !ret);
 }
 
-- 
2.15.3.AMZN

