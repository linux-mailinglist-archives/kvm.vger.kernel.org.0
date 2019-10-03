Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B493C9EA8
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 14:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729704AbfJCMir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 08:38:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56014 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729048AbfJCMir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 08:38:47 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 270E830622EA
        for <kvm@vger.kernel.org>; Thu,  3 Oct 2019 12:38:47 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-121-204.rdu2.redhat.com [10.10.121.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A25265D6A9;
        Thu,  3 Oct 2019 12:38:46 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests] svm: Fixed error code comparison in test npt_rsvd_pfwalk
Date:   Thu,  3 Oct 2019 08:38:45 -0400
Message-Id: <20191003123845.2895-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 03 Oct 2019 12:38:47 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the AMD64 spec Bit 3 (RSV) in exitinfo1 should be set
to 1 if reserved bits were set in the corresponding nested page
table entry. Exitinfo1 should be checking against error code
0x20000000eULL not 0x200000006ULL.

Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 x86/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/svm.c b/x86/svm.c
index bc74e7c..bb39934 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -1066,7 +1066,7 @@ static bool npt_rsvd_pfwalk_check(struct test *test)
     pdpe[0] &= ~(1ULL << 8);
 
     return (test->vmcb->control.exit_code == SVM_EXIT_NPF)
-            && (test->vmcb->control.exit_info_1 == 0x200000006ULL);
+            && (test->vmcb->control.exit_info_1 == 0x20000000eULL);
 }
 
 static void npt_l1mmio_prepare(struct test *test)
-- 
2.20.1

