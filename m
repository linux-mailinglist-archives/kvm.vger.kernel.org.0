Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE9921BD13
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 20:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgGJSfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 14:35:43 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:7518 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726872AbgGJSfn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 14:35:43 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 10 Jul 2020 11:35:38 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id DB23F40CB7;
        Fri, 10 Jul 2020 11:35:42 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 2/4] x86: svm: present bit is set on nested page-faults
Date:   Fri, 10 Jul 2020 11:33:18 -0700
Message-ID: <20200710183320.27266-3-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200710183320.27266-1-namit@vmware.com>
References: <20200710183320.27266-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: namit@vmware.com does not
 designate permitted sender hosts)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On nested page-faults due to write-protect or reserved bits, the
present-bit in EXITINFO1 is set, as confirmed on bare-metal.  Set the
expected result accordingly.

This indicates that KVM has a bug.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/svm_tests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 9adee23..7069e0b 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -816,7 +816,7 @@ static bool npt_rw_pfwalk_check(struct svm_test *test)
     *pte |= (1ULL << 1);
 
     return (vmcb->control.exit_code == SVM_EXIT_NPF)
-           && (vmcb->control.exit_info_1 == 0x200000006ULL)
+           && (vmcb->control.exit_info_1 == 0x200000007ULL)
 	   && (vmcb->control.exit_info_2 == read_cr3());
 }
 
@@ -835,7 +835,7 @@ static bool npt_rsvd_pfwalk_check(struct svm_test *test)
     pdpe[0] &= ~(1ULL << 8);
 
     return (vmcb->control.exit_code == SVM_EXIT_NPF)
-            && (vmcb->control.exit_info_1 == 0x20000000eULL);
+            && (vmcb->control.exit_info_1 == 0x20000000fULL);
 }
 
 static void npt_l1mmio_prepare(struct svm_test *test)
-- 
2.25.1

