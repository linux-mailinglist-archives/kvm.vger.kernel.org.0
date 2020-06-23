Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B86204C56
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 10:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731885AbgFWI1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 04:27:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54409 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731718AbgFWI1S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 04:27:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592900837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=d9HjsnlPG7d2lI7SP6pinbDLKBTZckBRqaBaiNwA4Is=;
        b=K4+8qw0bnMOcXn3eV2Xcj7xfKjUTTpRv5euXV5I9dAe/b0IGcYtdXgmJCepW9cQJB4ERgC
        NUoJfzTNKUhwwXoH3dCwvp3H65HLCJFuoSBrMqVBU2SrF2uYD3hvFxdQTKkKng+D15BZN9
        sB8g8RFxxXBrnHJl/5YyGtxnNJ6v1N8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-3w0UAWawMh-7EOKBLPfsXQ-1; Tue, 23 Jun 2020 04:27:15 -0400
X-MC-Unique: 3w0UAWawMh-7EOKBLPfsXQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 708A6800597
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 08:27:14 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D93519D82;
        Tue, 23 Jun 2020 08:27:13 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests RFC] Revert "SVM: move guest past HLT"
Date:   Tue, 23 Jun 2020 10:27:11 +0200
Message-Id: <20200623082711.803916-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'nmi_hlt' test returns somewhat weird result:

...
PASS: direct NMI + hlt
PASS: NMI intercept while running guest
PASS: intercepted NMI + hlt
PASS: nmi_hlt
SUMMARY: 4 tests, 1 unexpected failures

Trying to investigate where the failure is coming from I was tweaking
the code around and with tiny meaningless changes I was able to observe
 #PF, #GP, #UD and other 'interesting' results. Compiler optimization
flags also change the outcome so there's obviously a corruption somewhere.
Adding a meaningless 'nop' to the second 'asm volatile ("hlt");' in
nmi_hlt_test() saves the day so it seems we erroneously advance RIP
twice, the advancement in nmi_hlt_finished() is not needed.

The outcome, however, contradicts with the commit message in 7e7aa86f74
("SVM: move guest past HLT"). With that commit reverted, all tests seem
to pass but I'm not sure what issue the commit was trying to fix, thus
RFC.

This reverts commit 7e7aa86f7418a8343de46583977f631e55fd02ed.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/svm_tests.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index c1abd55646f2..977ead5235b8 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1362,11 +1362,6 @@ static bool interrupt_finished(struct svm_test *test)
             return true;
         }
 
-        /* The guest is not woken up from HLT and RIP still points to it.  */
-        if (get_test_stage(test) == 3) {
-            vmcb->save.rip++;
-        }
-
         irq_enable();
         asm volatile ("nop");
         irq_disable();
@@ -1553,9 +1548,6 @@ static bool nmi_hlt_finished(struct svm_test *test)
             return true;
         }
 
-        /* The guest is not woken up from HLT and RIP still points to it.  */
-        vmcb->save.rip++;
-
         report(true, "NMI intercept while running guest");
         break;
 
-- 
2.25.4

