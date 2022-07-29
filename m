Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD3A584D5A
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 10:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbiG2I21 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 04:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235494AbiG2I2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 04:28:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD7A8320B
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 01:27:22 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26T8Iirw027644
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:27:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=f11gVDeTsmG6afoL+ivYXjEZ8NaliiWL629KbqF9MAw=;
 b=cFBNfF8vfNLZtqjduDvI9hTikMhvezsTmhJWeY/XCMLlOdfBgmDpIkttZ3UfAvXvUGod
 xn1whm71r5vaHeuH3gLlMZgHxCxU8ltzB0HcOHJy2bPqoVTjIiQJSzhY4Yl1VTYiCcc4
 mb4iOFAWRBI7+adKr6ti51oqs+05ztji90o3YIbbs1wzvFISugsmt8ZCG43IBfj8+3F4
 ISh1lPzumaZzcwHkKCS4mgEbffi6jAnVnc+eeplkeXrrmf5VrWdPuCS4MnNNl1bDmQr3
 TPUnT+NZelKH6luYU8wQZpCEXL7GWrYr5dekIxMZvzWsz5vtDAdrjM1HO0AG1T0N4zcf kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hmbx7g63u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:27:21 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26T8Jd6E029422
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 08:27:21 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hmbx7g62e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 08:27:21 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26T8K5H9021085;
        Fri, 29 Jul 2022 08:27:19 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3hg95ydj0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Jul 2022 08:27:19 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26T8RULR30736730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 08:27:30 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE3E452051;
        Fri, 29 Jul 2022 08:27:15 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0B91A5204E;
        Fri, 29 Jul 2022 08:27:14 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 6/6] lib: s390x: sie: Properly populate SCA
Date:   Fri, 29 Jul 2022 08:26:33 +0000
Message-Id: <20220729082633.277240-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220729082633.277240-1-frankja@linux.ibm.com>
References: <20220729082633.277240-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PDuA_l0NWv2X6qDyNelSJ-tBn4-Z1KRD
X-Proofpoint-ORIG-GUID: t0ZGbiF6cxi-eaYZKJ_rA4EvFv4-cS3A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 spamscore=0 malwarescore=0 clxscore=1015
 mlxscore=0 priorityscore=1501 adultscore=0 impostorscore=0 mlxlogscore=674
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207290032
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
---
 lib/s390x/sie.c |  8 ++++++++
 lib/s390x/sie.h | 35 ++++++++++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 5ba669f1..acfdff99 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -9,6 +9,7 @@
  */
 
 #include <asm/barrier.h>
+#include <bitops.h>
 #include <libcflat.h>
 #include <sie.h>
 #include <asm/page.h>
@@ -71,6 +72,13 @@ void sie_guest_sca_create(struct vm *vm)
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

