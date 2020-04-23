Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA8D1B618C
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 19:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729839AbgDWRG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 13:06:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58875 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729673AbgDWRG6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 13:06:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587661617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=QjZsnx3jt2OdJuj/4lT+uCrev8ojTUdpopzswbz36Cs=;
        b=D6sk/dmyHI0awK73ARccaGyloRjkL6DG2BcnFazu/CgTcxWKGErVOxrjxHCoc1nE4Es+lx
        XlrrmhdHMCjyXKY3Wp/IIBDkzCYs24pRVO08QCFjcwaPlR5OrwtHio53GyuqKxmE7+3f9c
        Qt+LPicGt5aI/nOkEArzOJgb5XhBtZg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-g9gqxTCIPJer6RjAnvLKJg-1; Thu, 23 Apr 2020 13:06:55 -0400
X-MC-Unique: g9gqxTCIPJer6RjAnvLKJg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8373180B709;
        Thu, 23 Apr 2020 17:06:54 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D438C6109F;
        Thu, 23 Apr 2020 17:06:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     wei.huang2@amd.com, cavery@redhat.com
Subject: [PATCH kvm-unit-tests] SVM: move guest past HLT
Date:   Thu, 23 Apr 2020 13:06:53 -0400
Message-Id: <20200423170653.191992-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On AMD, the guest is not woken up from HLT by the interrupt or NMI vmexits.
Therefore we have to fix up the RIP manually.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/svm_tests.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index c2725af..1f2975c 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1316,6 +1316,11 @@ static bool interrupt_finished(struct svm_test *test)
             return true;
         }
 
+        /* The guest is not woken up from HLT, unlike Intel.  Fix that up.  */
+        if (get_test_stage(test) == 3) {
+            vmcb->save.rip++;
+        }
+
         irq_enable();
         asm volatile ("nop");
         irq_disable();
@@ -1501,6 +1506,9 @@ static bool nmi_hlt_finished(struct svm_test *test)
             return true;
         }
 
+        /* The guest is not woken up from HLT, unlike Intel.  Fix that up.  */
+        vmcb->save.rip++;
+
         report(true, "NMI intercept while running guest");
         break;
 
-- 
2.18.2

