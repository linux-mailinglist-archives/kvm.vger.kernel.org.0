Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF2D60CB30
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 13:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbiJYLoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 07:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbiJYLoB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 07:44:01 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A1317535B
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 04:43:57 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PB8hA7031332
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=G6+jZGVsQjStF9+2xgC1/SIsSgyowEKjlkJgxMvl890=;
 b=Di4MxptpMDzkScyefW99NGd3FdWHRLlTH5BgYE0OBhVJ5DzkXbc5hcRr+FH6WIYkqAQx
 KLTrCq01J+zhlRIpu25j2QMFde+GyKpufWrZXrEiyl90k/hoG5H2S5/uqdZPnlOgitJR
 5xr+nc3WQoftQedIVLlWOgi6tXuu0cLPEV3jOFtbIfgJnwIe4JHpYflxdGoa8QNNkKmg
 EJgceQUfhmiuczQVzk61Is3dtJePfNxCpgoXuKvpvJ+7pcQj9W14PDwpMjRIBmQYDoZW
 4EdJyJbRFidJTq6KdW/VWJGmRZVagBKQM6ORgpykBIGgOuGI7W/7oc2JKEVMPBwCCH0X ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kecrqw821-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:56 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29PBQ1Fb011775
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:56 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kecrqw818-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:56 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PBdQcd014327;
        Tue, 25 Oct 2022 11:43:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3kc7sj5h76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:54 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PBhp9M2228916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 11:43:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84261AE045;
        Tue, 25 Oct 2022 11:43:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 507CCAE04D;
        Tue, 25 Oct 2022 11:43:51 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 11:43:51 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 22/22] lib: s390x: sie: Properly populate SCA
Date:   Tue, 25 Oct 2022 13:43:45 +0200
Message-Id: <20221025114345.28003-23-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025114345.28003-1-imbrenda@linux.ibm.com>
References: <20221025114345.28003-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5JP1tomiRpv1M58cpVaHwWQNL_n3zMTO
X-Proofpoint-ORIG-GUID: jIzBO9VqUvOwCyfrSFOP98Q0CiP_9c8Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 phishscore=0 impostorscore=0 spamscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxlogscore=695
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

CPU0 is the only cpu that's being used but we should still mark it as
online and set the SDA in the SCA.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20221021063902.10878-7-frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/sie.h | 35 ++++++++++++++++++++++++++++++++++-
 lib/s390x/sie.c |  8 ++++++++
 2 files changed, 42 insertions(+), 1 deletion(-)

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
-- 
2.37.3

