Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4152160703F
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 08:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiJUGnu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 02:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiJUGnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 02:43:41 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0A0242C8E
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 23:43:39 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29L6agaD002671
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 06:43:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LdX3gXhB9QFVncuE0N5qg3AwlqTg6+aO/YOopmEuXck=;
 b=TGDAkXMfXmRXXGbIQPbJBR5Csqp+MIhOMAqoT2TE7NTlqzl5FY2tVaPVc7UVaVLrBabk
 /jZ0tlbRs2KqRIP8tu97vPhhiinsQm8nWCQDMs/eMGlwYmQZz9tLBhapKiCuhOK8+vXb
 mQmdP+Az9awlFQDpSnENpeZzGldF334V27gSRQQEDuK7ORp2MNbyqLGnokefgZAbtlBA
 Ee4ENIUP79cSrdq/l9pLvPfP1v1jgi9KE/EuR9EtCuqRvCx0y1zQEpd4U9rQQjwJ5I/M
 pJ7ZVjpRP2L1BDlW+vkpwGdndLK/fl6o918mcfg6+MskYsEh5kqz6EXrOlWz9f06+Ohz tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbn6pt283-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 06:43:37 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29L6axEC005011
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 06:43:37 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbn6pt27g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 06:43:37 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29L6ajfn029318;
        Fri, 21 Oct 2022 06:43:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3k99fn52xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 06:43:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29L6hWsc63832490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Oct 2022 06:43:32 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5625D11C04C;
        Fri, 21 Oct 2022 06:43:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6B7F11C04A;
        Fri, 21 Oct 2022 06:43:31 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Oct 2022 06:43:31 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 6/6] lib: s390x: sie: Properly populate SCA
Date:   Fri, 21 Oct 2022 06:39:02 +0000
Message-Id: <20221021063902.10878-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221021063902.10878-1-frankja@linux.ibm.com>
References: <20221021063902.10878-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9_c1Djw9yzT-78a2NPixsuyPzNIS06g8
X-Proofpoint-GUID: YUI9FOjkKmVcsPlrrASzyzPZTPjFxolX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_01,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=732 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210038
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPU0 is the only cpu that's being used but we should still mark it as
online and set the SDA in the SCA.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/sie.c |  8 ++++++++
 lib/s390x/sie.h | 35 ++++++++++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 6efad965..a71985b6 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -9,6 +9,7 @@
  */
 
 #include <asm/barrier.h>
+#include <bitops.h>
 #include <libcflat.h>
 #include <sie.h>
 #include <asm/page.h>
@@ -72,6 +73,13 @@ void sie_guest_sca_create(struct vm *vm)
 	vm->sblk->scaoh = ((uint64_t)vm->sca >> 32);
 	vm->sblk->scaol = (uint64_t)vm->sca & ~0x3fU;
 	vm->sblk->ecb2 |= ECB2_ESCA;
+
+	/* Enable SIGP sense running interpretation */
+	vm->sblk->ecb |= ECB_SRSI;
+
+	/* We assume that cpu 0 is always part of the vm */
+	vm->sca->mcn[0] = BIT(63);
+	vm->sca->cpu[0].sda = (uint64_t)vm->sblk;
 }
 
 /* Initializes the struct vm members like the SIE control block. */
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 3e3605c9..a27a8401 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -202,6 +202,39 @@ union {
 	uint64_t	pv_grregs[16];		/* 0x0380 */
 } __attribute__((packed));
 
+union esca_sigp_ctrl {
+	uint16_t value;
+	struct {
+		uint8_t c : 1;
+		uint8_t reserved: 7;
+		uint8_t scn;
+	};
+};
+
+struct esca_entry {
+	union esca_sigp_ctrl sigp_ctrl;
+	uint16_t   reserved1[3];
+	uint64_t   sda;
+	uint64_t   reserved2[6];
+};
+
+union ipte_control {
+	unsigned long val;
+	struct {
+		unsigned long k  : 1;
+		unsigned long kh : 31;
+		unsigned long kg : 32;
+	};
+};
+
+struct esca_block {
+	union ipte_control ipte_control;
+	uint64_t   reserved1[7];
+	uint64_t   mcn[4];
+	uint64_t   reserved2[20];
+	struct esca_entry cpu[256];
+};
+
 struct vm_uv {
 	uint64_t vm_handle;
 	uint64_t vcpu_handle;
@@ -230,7 +263,7 @@ struct vm_save_area {
 struct vm {
 	struct kvm_s390_sie_block *sblk;
 	struct vm_save_area save_area;
-	void *sca;				/* System Control Area */
+	struct esca_block *sca;			/* System Control Area */
 	uint8_t *crycb;				/* Crypto Control Block */
 	struct vm_uv uv;			/* PV UV information */
 	/* Ptr to first guest page */
-- 
2.34.1

