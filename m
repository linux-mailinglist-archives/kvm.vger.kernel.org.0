Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D80F7436
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 13:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfKKMmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 07:42:49 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58172 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfKKMmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 07:42:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABCdMVC041136;
        Mon, 11 Nov 2019 12:42:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=YqBAOEZMh3KGZ+O3/laMDeTAk2++y7gLpfILzynibmU=;
 b=AaQTgIqUO5mtblH9H/2BiWbHlIb2nAKpP8WccRStD2sqM3RFACjsbJalZhdiujBEYcKb
 b/TgFz26qQRO9xcVY7wp7WzNGmWDLcdAkgGU4tOjQ0Bw0jXXBbTxFyoEG017YcIo+h5T
 zey4AF4eKatNCKnmjQYlm2h1SUAi52ToALwiDMI+Fbi9eJmrWAs79j3zmhqPbYJmos/s
 YvymxYt2lkuNJtkYIVfRF95Tp4fm4PXntRWvl/yc5H4wEhR+DdQTZXxmuHjdTab7xrjx
 Dmz2keRlqzYBb93VcEpDO3lJk5o2pLAOgRnXOk73yBbczu7DCJWlv7w3koFjXTwiU7OW ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w5mvteubd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 12:42:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABCcriQ036332;
        Mon, 11 Nov 2019 12:40:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2w66yx9mgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 12:40:38 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xABCeamf031449;
        Mon, 11 Nov 2019 12:40:36 GMT
Received: from Lirans-MBP.Home (/79.182.207.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 04:40:36 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Mihai Carabas <mihai.carabas@oracle.com>
Subject: [PATCH] x86: vmx: Verify pending LAPIC INIT event consume when exit on VMX_INIT
Date:   Mon, 11 Nov 2019 14:40:23 +0200
Message-Id: <20191111124023.93449-1-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110121
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel SDM section 25.2 OTHER CAUSES OF VM EXITS specifies the following
on INIT signals: "Such exits do not modify register state or clear pending
events as they would outside of VMX operation."

When commit 48adfb0f2e8e ("x86: vmx: Test INIT processing during various CPU VMX states")
was applied, I interepted above Intel SDM statement such that
VMX_INIT exit don’t consume the pending LAPIC INIT event.

However, when Nadav Amit run the unit-test on a bare-metal
machine, it turned out my interpetation was wrong. i.e. VMX_INIT
exit does consume the pending LAPIC INIT event.
(See: https://www.spinics.net/lists/kvm/msg196757.html)

Therefore, fix unit-test code to behave as observed on bare-metal.
i.e. End unit-test with the following steps:
1) Exit VMX operation and verify it still continues to run properly
as pending LAPIC INIT event should have been already consumed by
VMX_INIT exit.
2) Re-enter VMX operation and send another INIT signal to keep it
blocked until exit from VMX operation.
3) Exit VMX operation and verify that pending LAPIC INIT signal
is processed when exiting VMX operation.

Fixes: 48adfb0f2e8e ("x86: vmx: Test INIT processing during various CPU VMX states")
Reported-by: Nadav Amit <nadav.amit@gmail.com>
Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 x86/vmx_tests.c | 45 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index b137fc5456b8..a63dc2fafb49 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8427,13 +8427,34 @@ static void init_signal_test_thread(void *data)
 	/* Signal that CPU exited to VMX root mode */
 	vmx_set_test_stage(5);
 
-	/* Wait for signal to exit VMX operation */
+	/* Wait for BSP CPU to signal to exit VMX operation */
 	while (vmx_get_test_stage() != 6)
 		;
 
 	/* Exit VMX operation (i.e. exec VMXOFF) */
 	vmx_off();
 
+	/*
+	 * Signal to BSP CPU that we continue as usual as INIT signal
+	 * should have been consumed by VMX_INIT exit from guest
+	 */
+	vmx_set_test_stage(7);
+
+	/* Wait for BSP CPU to signal to enter VMX operation */
+	while (vmx_get_test_stage() != 8)
+		;
+	/* Enter VMX operation (i.e. exec VMXON) */
+	_vmx_on(ap_vmxon_region);
+	/* Signal to BSP we are in VMX operation */
+	vmx_set_test_stage(9);
+
+	/* Wait for BSP CPU to send INIT signal */
+	while (vmx_get_test_stage() != 10)
+		;
+
+	/* Exit VMX operation (i.e. exec VMXOFF) */
+	vmx_off();
+
 	/*
 	 * Exiting VMX operation should result in latched
 	 * INIT signal being processed. Therefore, we should
@@ -8511,9 +8532,29 @@ static void vmx_init_signal_test(void)
 	init_signal_test_thread_continued = false;
 	vmx_set_test_stage(6);
 
+	/* Wait reasonable amount of time for other CPU to exit VMX operation */
+	delay(INIT_SIGNAL_TEST_DELAY);
+	report("INIT signal consumed on VMX_INIT exit",
+		   vmx_get_test_stage() == 7);
+	/* No point to continue if we failed at this point */
+	if (vmx_get_test_stage() != 7)
+		return;
+
+	/* Signal other CPU to enter VMX operation */
+	vmx_set_test_stage(8);
+	/* Wait for other CPU to enter VMX operation */
+	while (vmx_get_test_stage() != 9)
+		;
+
+	/* Send INIT signal to other CPU */
+	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT,
+				   id_map[1]);
+	/* Signal other CPU we have sent INIT signal */
+	vmx_set_test_stage(10);
+
 	/*
 	 * Wait reasonable amount of time for other CPU
-	 * to run after INIT signal was processed
+	 * to exit VMX operation and process INIT signal
 	 */
 	delay(INIT_SIGNAL_TEST_DELAY);
 	report("INIT signal processed after exit VMX operation",
-- 
2.20.1

