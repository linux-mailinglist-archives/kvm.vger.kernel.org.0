Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210ED20F1EC
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 11:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732131AbgF3JsW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 05:48:22 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:49348 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732117AbgF3JsV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Jun 2020 05:48:21 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 30 Jun 2020 02:48:19 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 3F86BB27D6;
        Tue, 30 Jun 2020 05:48:20 -0400 (EDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 5/5] x86: svm: avoid advancing rip incorrectly on exc_inject
Date:   Tue, 30 Jun 2020 02:45:16 -0700
Message-ID: <20200630094516.22983-6-namit@vmware.com>
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

exc_inject advances the ripon every stage, so it can do so 3 times, but
there are only 2 vmmcall instructions that the guest runs. So, if a
failure happens on the last test, there is no vmmcall instruction to
trigger an exit.

Advance the rip only in the two stages in which vmmcall is expected to
run.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/svm_tests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 323031f..a20aa37 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1593,8 +1593,6 @@ static void exc_inject_test(struct svm_test *test)
 
 static bool exc_inject_finished(struct svm_test *test)
 {
-    vmcb->save.rip += 3;
-
     switch (get_test_stage(test)) {
     case 0:
         if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
@@ -1602,6 +1600,7 @@ static bool exc_inject_finished(struct svm_test *test)
                    vmcb->control.exit_code);
             return true;
         }
+        vmcb->save.rip += 3;
         vmcb->control.event_inj = NMI_VECTOR | SVM_EVTINJ_TYPE_EXEPT | SVM_EVTINJ_VALID;
         break;
 
@@ -1621,6 +1620,7 @@ static bool exc_inject_finished(struct svm_test *test)
                    vmcb->control.exit_code);
             return true;
         }
+        vmcb->save.rip += 3;
         report(count_exc == 1, "divide overflow exception injected");
         report(!(vmcb->control.event_inj & SVM_EVTINJ_VALID), "eventinj.VALID cleared");
         break;
-- 
2.25.1

