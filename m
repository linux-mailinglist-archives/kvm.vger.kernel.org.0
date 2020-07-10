Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D4721BD12
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 20:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgGJSfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 14:35:43 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:7518 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727085AbgGJSfn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 14:35:43 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 10 Jul 2020 11:35:38 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id CF6EE40CA9;
        Fri, 10 Jul 2020 11:35:42 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 1/4] x86: svm: clear CR4.DE on DR intercept test
Date:   Fri, 10 Jul 2020 11:33:17 -0700
Message-ID: <20200710183320.27266-2-namit@vmware.com>
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

DR4/DR5 can only be written when CR4.DE is clear, and otherwise trigger
a #GP exception. The BIOS might not clear CR4.DE so update the tests not
to make this assumption.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/svm_tests.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index d4d130f..9adee23 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -171,6 +171,7 @@ static void prepare_dr_intercept(struct svm_test *test)
     default_prepare(test);
     vmcb->control.intercept_dr_read = 0xff;
     vmcb->control.intercept_dr_write = 0xff;
+    vmcb->save.cr4 &= ~X86_CR4_DE;
 }
 
 static void test_dr_intercept(struct svm_test *test)
-- 
2.25.1

