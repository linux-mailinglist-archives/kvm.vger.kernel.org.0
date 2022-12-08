Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0D36474D5
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 18:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiLHRG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 12:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiLHRG1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 12:06:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC68085D00
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 09:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670519127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=asW2vy461e0rSdotWn0NTs/7xLf9pA0Y4lAnlw3dKwM=;
        b=LBaNMV4HsBCCZx0KqKyQEV06co1wHrvUrkFh8WxX/fP8NiV37jYLI5RQoKy3/J6/rt+1Kq
        xZRYi+u8jNPcDrzzmPWindSUdh7U3LcFTExuQc1ut5ax6o2cufnsPlLQbl2/PHiizwEraI
        73li8aYbrJ+MyA2hETDPxyxVwB7EB3M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-Iy2TNGiSPjS-tC2gbk2xew-1; Thu, 08 Dec 2022 12:05:08 -0500
X-MC-Unique: Iy2TNGiSPjS-tC2gbk2xew-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0097A3817963;
        Thu,  8 Dec 2022 17:05:08 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A23AC40C206B;
        Thu,  8 Dec 2022 17:05:06 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests v2 PATCH] s390x: sie: Test whether the epoch extension field is working as expected
Date:   Thu,  8 Dec 2022 18:05:02 +0100
Message-Id: <20221208170502.17984-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We recently discovered a bug with the time management in nested scenarios
which got fixed by kernel commit "KVM: s390: vsie: Fix the initialization
of the epoch extension (epdx) field". This adds a simple test for this
bug so that it is easier to determine whether the host kernel of a machine
has already been fixed or not.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 v2: Remove the spurious "2" from the diag 44 opcode

 s390x/sie.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/s390x/sie.c b/s390x/sie.c
index 87575b29..cd3cea10 100644
--- a/s390x/sie.c
+++ b/s390x/sie.c
@@ -58,6 +58,33 @@ static void test_diags(void)
 	}
 }
 
+static void test_epoch_ext(void)
+{
+	u32 instr[] = {
+		0xb2780000,	/* STCKE 0 */
+		0x83000044	/* DIAG 0x44 to intercept */
+	};
+
+	if (!test_facility(139)) {
+		report_skip("epdx: Multiple Epoch Facility is not available");
+		return;
+	}
+
+	guest[0] = 0x00;
+	memcpy(guest_instr, instr, sizeof(instr));
+
+	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
+	vm.sblk->gpsw.mask = PSW_MASK_64;
+
+	vm.sblk->ecd |= ECD_MEF;
+	vm.sblk->epdx = 0x47;	/* Setting the epoch extension here ... */
+
+	sie(&vm);
+
+	/* ... should result in the same epoch extension here: */
+	report(guest[0] == 0x47, "epdx: different epoch is visible in the guest");
+}
+
 static void setup_guest(void)
 {
 	setup_vm();
@@ -80,6 +107,7 @@ int main(void)
 
 	setup_guest();
 	test_diags();
+	test_epoch_ext();
 	sie_guest_destroy(&vm);
 
 done:
-- 
2.31.1

