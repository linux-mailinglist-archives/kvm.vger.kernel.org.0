Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4C6605A6C
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiJTJBR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiJTJBN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:01:13 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BD8186D7E
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:01:11 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K88PbM030506
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:01:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XcLqTkx/3HhjHwUli8dPYx3iooAzP3ptN7mqnxSkkCI=;
 b=Y0fSxtu3WBDCCJHJunnWX8TxsOJklcY56h54wb1Pm91EKogkVQVzPP3ytMQfZN5dFq1q
 AlTKVcte6hTvXQOCJxal/08avChNf3yozP51Mcgvm2A2gaKgE5wI4XMLVQduqiYMfFFi
 r3iSiyPZQcQA+tiJTbzJWqQKqwQqlPr3VCL8DApvbaoQ1pCzmiONyE4jn0uq5jQQ6a1X
 4CxsdHwXjfgCCchW3sTNs4gc9bnAvbcy//SvUD9kAzukx6EMdqBexM3/Y3kiGpS760BO
 4kgURv6jc73WpSjm7EKjTlJBiIUxIQix4h0aiP5mbe/aFDlJCH5oP0dIPueUikawWAyt zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb1rpb9te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:01:10 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29K88aW8031496
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:01:10 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb1rpb9sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:01:10 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29K8pEvl005033;
        Thu, 20 Oct 2022 09:01:08 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3k7mg98mh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:01:08 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29K915WJ66584890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 09:01:05 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BFCA42042;
        Thu, 20 Oct 2022 09:01:05 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5C9D64203F;
        Thu, 20 Oct 2022 09:01:04 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 09:01:04 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 7/7] lib: s390x: sie: Properly populate SCA
Date:   Thu, 20 Oct 2022 09:00:09 +0000
Message-Id: <20221020090009.2189-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090009.2189-1-frankja@linux.ibm.com>
References: <20221020090009.2189-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: r9cRYLFdnUIcjPgbRGAPDXJnNPBA2wN2
X-Proofpoint-ORIG-GUID: H5n--QBLRkgVRgfI8g-FSQmHp_Nc7y54
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_02,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxlogscore=678 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210200049
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

