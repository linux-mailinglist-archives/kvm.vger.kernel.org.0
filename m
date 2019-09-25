Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64E1BBE29E
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 18:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389657AbfIYQiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 12:38:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39278 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728465AbfIYQiV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 12:38:21 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1F43D7FDCA;
        Wed, 25 Sep 2019 16:38:21 +0000 (UTC)
Received: from thuth.com (ovpn-116-109.ams2.redhat.com [10.36.116.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A326D60BF1;
        Wed, 25 Sep 2019 16:38:19 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 10/17] s390x: Fix stsi unaligned test and add selector tests
Date:   Wed, 25 Sep 2019 18:37:07 +0200
Message-Id: <20190925163714.27519-11-thuth@redhat.com>
In-Reply-To: <20190925163714.27519-1-thuth@redhat.com>
References: <20190925163714.27519-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 25 Sep 2019 16:38:21 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Alignment and selectors test order is not specified and so, if you
have an unaligned address and invalid selectors it's up to the
hypervisor to decide which error is presented.

Let's add valid selectors to the unalignmnet test and add selector
tests.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 s390x/stsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/s390x/stsi.c b/s390x/stsi.c
index 7232cb0..c5bd0a2 100644
--- a/s390x/stsi.c
+++ b/s390x/stsi.c
@@ -35,7 +35,7 @@ static void test_specs(void)
 
 	report_prefix_push("unaligned");
 	expect_pgm_int();
-	stsi(pagebuf + 42, 1, 0, 0);
+	stsi(pagebuf + 42, 1, 1, 1);
 	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
 	report_prefix_pop();
 
@@ -71,6 +71,8 @@ static inline unsigned long stsi_get_fc(void *addr)
 static void test_fc(void)
 {
 	report("invalid fc",  stsi(pagebuf, 7, 0, 0) == 3);
+	report("invalid selector 1", stsi(pagebuf, 1, 0, 1) == 3);
+	report("invalid selector 2", stsi(pagebuf, 1, 1, 0) == 3);
 	report("query fc >= 2",  stsi_get_fc(pagebuf) >= 2);
 }
 
-- 
2.18.1

