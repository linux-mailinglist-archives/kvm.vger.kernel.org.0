Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB73479134C
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 10:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352560AbjIDIXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 04:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235801AbjIDIXi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 04:23:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F270713D;
        Mon,  4 Sep 2023 01:23:24 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38488vrx006632;
        Mon, 4 Sep 2023 08:23:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=QGQC46dD6m/Ii7LXn75uYt1MDK+xs3ebc7a/J8ydzIs=;
 b=W7oI6WBZdQ0rEuOSQLnvEKmP16xJ2ObMqVKxGdo6TOA5D21H4S6nx4LrBwzWkLRKdxCL
 buhCfPwFjmDv0F6dOos8xCfG2H4RrH1yJct3mXQwul5LJTG9UZgeGxVwml/lmdShrLCM
 2dUmSgYyZKmQ6LtQcm1djwJPfnUtpLVsF+1qN2G6ftpb7nK9YjRDz6eVygGYaHSCcYyG
 7Vaaf4hB804xb9YnM1nIASJPvqSJfR86LEAXxHkQYBGyaCRCkOqz9dYGR1l63ZP85oXT
 FLlwa7UvY7W4CgS28kWGw2PsW3SR51Y35CUjuzSERnQ02+/hhcmc+id7CGKXYEl5+v+Q RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sw80j4jc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 08:23:24 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38489Kgn008211;
        Mon, 4 Sep 2023 08:23:23 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sw80j4jbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 08:23:23 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 384709Vl011154;
        Mon, 4 Sep 2023 08:23:22 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3svj318ege-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 08:23:22 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3848NJA023266024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Sep 2023 08:23:19 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C6ED620040;
        Mon,  4 Sep 2023 08:23:19 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 915932004D;
        Mon,  4 Sep 2023 08:23:19 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  4 Sep 2023 08:23:19 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v6 3/8] s390x: sie: switch to home space mode before entering SIE
Date:   Mon,  4 Sep 2023 10:22:21 +0200
Message-ID: <20230904082318.1465055-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230904082318.1465055-1-nrb@linux.ibm.com>
References: <20230904082318.1465055-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rX8Y40-1OuDdvpAYpXYsPNipK2hmpFG6
X-Proofpoint-ORIG-GUID: xYs87riR1EotmAX9jx07846fhmmyIlLB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-04_05,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 mlxscore=0 impostorscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309040072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is to prepare for running guests without MSO/MSL, which is
currently not possible.

We already have code in sie64a to setup a guest primary ASCE before
entering SIE, so we can in theory switch to the page tables which
translate gpa to hpa.

But the host is running in primary space mode already, so changing the
primary ASCE before entering SIE will also affect the host's code and
data.

To make this switch useful, the host should run in a different address
space mode. Hence, set up and change to home address space mode before
installing the guest ASCE.

The home space ASCE is just copied over from the primary space ASCE, so
no functional change is intended, also for tests that want to use
MSO/MSL. If a test intends to use a different primary space ASCE, it can
now just set the guest.asce in the save_area.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h |  1 +
 lib/s390x/sie.c          | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 5638fd01fd85..90a178ca0351 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -93,6 +93,7 @@ enum address_space {
 };
 
 #define PSW_MASK_DAT			0x0400000000000000UL
+#define PSW_MASK_HOME			0x0000C00000000000UL
 #define PSW_MASK_IO			0x0200000000000000UL
 #define PSW_MASK_EXT			0x0100000000000000UL
 #define PSW_MASK_KEY			0x00F0000000000000UL
diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index b44febdeaaac..7f4474555ff7 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -52,6 +52,8 @@ void sie_handle_validity(struct vm *vm)
 
 void sie(struct vm *vm)
 {
+	uint64_t old_cr13;
+
 	if (vm->sblk->sdf == 2)
 		memcpy(vm->sblk->pv_grregs, vm->save_area.guest.grs,
 		       sizeof(vm->save_area.guest.grs));
@@ -59,6 +61,24 @@ void sie(struct vm *vm)
 	/* Reset icptcode so we don't trip over it below */
 	vm->sblk->icptcode = 0;
 
+	/*
+	 * Set up home address space to match primary space. Instead of running
+	 * in home space all the time, we switch every time in sie() because:
+	 * - tests that depend on running in primary space mode don't need to be
+	 *   touched
+	 * - it avoids regressions in tests
+	 * - switching every time makes it easier to extend this in the future,
+	 *   for example to allow tests to run in whatever space they want
+	 */
+	old_cr13 = stctg(13);
+	lctlg(13, stctg(1));
+
+	/* switch to home space so guest tables can be different from host */
+	psw_mask_set_bits(PSW_MASK_HOME);
+
+	/* also handle all interruptions in home space while in SIE */
+	irq_set_dat_mode(true, AS_HOME);
+
 	while (vm->sblk->icptcode == 0) {
 		sie64a(vm->sblk, &vm->save_area);
 		sie_handle_validity(vm);
@@ -66,6 +86,12 @@ void sie(struct vm *vm)
 	vm->save_area.guest.grs[14] = vm->sblk->gg14;
 	vm->save_area.guest.grs[15] = vm->sblk->gg15;
 
+	irq_set_dat_mode(true, AS_PRIM);
+	psw_mask_clear_bits(PSW_MASK_HOME);
+
+	/* restore the old CR 13 */
+	lctlg(13, old_cr13);
+
 	if (vm->sblk->sdf == 2)
 		memcpy(vm->save_area.guest.grs, vm->sblk->pv_grregs,
 		       sizeof(vm->save_area.guest.grs));
-- 
2.41.0

