Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D813620F1F2
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 11:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732140AbgF3Js3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 05:48:29 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:49348 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730785AbgF3JsV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Jun 2020 05:48:21 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 30 Jun 2020 02:48:19 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 326FFB27D1;
        Tue, 30 Jun 2020 05:48:20 -0400 (EDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 4/5] x86: svm: wrong reserved bit in npt_rsvd_pfwalk_prepare
Date:   Tue, 30 Jun 2020 02:45:15 -0700
Message-ID: <20200630094516.22983-5-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200630094516.22983-1-namit@vmware.com>
References: <20200630094516.22983-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: namit@vmware.com does not
 designate permitted sender hosts)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to AMD manual bit 8 in PDPE is not reserved, but bit 7.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/svm_tests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 92cefaf..323031f 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -825,13 +825,13 @@ static void npt_rsvd_pfwalk_prepare(struct svm_test *test)
     vmcb_ident(vmcb);
 
     pdpe = npt_get_pdpe();
-    pdpe[0] |= (1ULL << 8);
+    pdpe[0] |= (1ULL << 7);
 }
 
 static bool npt_rsvd_pfwalk_check(struct svm_test *test)
 {
     u64 *pdpe = npt_get_pdpe();
-    pdpe[0] &= ~(1ULL << 8);
+    pdpe[0] &= ~(1ULL << 7);
 
     return (vmcb->control.exit_code == SVM_EXIT_NPF)
             && (vmcb->control.exit_info_1 == 0x20000000eULL);
-- 
2.25.1

