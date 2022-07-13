Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4DF57358E
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 13:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236160AbiGMLgc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 07:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiGMLga (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 07:36:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A99EC177A;
        Wed, 13 Jul 2022 04:36:29 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DBDouf004329;
        Wed, 13 Jul 2022 11:36:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MTT+irR8dIFMPfgTG7Erp0wJ47YyeFqhk9BYcRl96TM=;
 b=nX5LqkGbzEHJOlx81SzCL+1VG81cNjRC4++8kEfy16BMZTlTjlgnY0u0FnDLtBc1elnF
 yUSah/giPZJanjOEcInkjyQg6ZxB2hRGUcQ1a+mi8lAyJkhsOibHE7nbS4i99QIdsBfV
 vBsfqoFt9CS5hv8RAlRYEPX5OFvIgUkdnei1DT9VsHn/cc39elZvOdasCtQECtJ67wRZ
 IKRxf7JqzXBtJxXNdWCsf/Tfp+8pT1pggIQOMiLAOws6/SoOId/tXV7J5OHjXikzsYaF
 hEc6o4+CeFkNw5TODcxM8J6D9oQGQCOW/pt1UxFEHoGNxPRxSInVCZ06281IusGIAOr3 nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9w028gn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 11:36:28 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26DBEC5G005131;
        Wed, 13 Jul 2022 11:36:27 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9w028gkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 11:36:27 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26DBaPPR015176;
        Wed, 13 Jul 2022 11:36:25 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3h8rrn2gf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 11:36:25 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26DBaMaq19726744
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 11:36:22 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9571811C04A;
        Wed, 13 Jul 2022 11:36:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DDDD11C050;
        Wed, 13 Jul 2022 11:36:22 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jul 2022 11:36:22 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 1/4] lib: s390x: add cleanup function for external interrupts
Date:   Wed, 13 Jul 2022 13:36:18 +0200
Message-Id: <20220713113621.14778-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220713113621.14778-1-nrb@linux.ibm.com>
References: <20220713113621.14778-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EJwtnSCu0YvlUJShk7u0vjDBGRSpnz7I
X-Proofpoint-ORIG-GUID: SYw9Rh3s8l-rR4d-qtbi3-rmzIOCyuPt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxlogscore=756 malwarescore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upcoming changes require a way to clear the wait bit in the PSW when
returning from an interrupt handler.

Similar to pgm ints, add a way to register a cleanup function which runs
in the interrupt handler.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/interrupt.h | 1 +
 lib/s390x/interrupt.c     | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
index d9ab0bd781c9..e662f0f0a190 100644
--- a/lib/s390x/asm/interrupt.h
+++ b/lib/s390x/asm/interrupt.h
@@ -38,6 +38,7 @@ union teid {
 };
 
 void register_pgm_cleanup_func(void (*f)(void));
+void register_ext_cleanup_func(void (*f)(struct stack_frame_int *));
 void handle_pgm_int(struct stack_frame_int *stack);
 void handle_ext_int(struct stack_frame_int *stack);
 void handle_mcck_int(void);
diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 6da20c4494ad..bb12ddf2d734 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -18,6 +18,7 @@
 static bool pgm_int_expected;
 static bool ext_int_expected;
 static void (*pgm_cleanup_func)(void);
+static void (*ext_cleanup_func)(struct stack_frame_int *stack);
 
 void expect_pgm_int(void)
 {
@@ -197,6 +198,11 @@ void handle_pgm_int(struct stack_frame_int *stack)
 		fixup_pgm_int(stack);
 }
 
+void register_ext_cleanup_func(void (*f)(struct stack_frame_int *))
+{
+	ext_cleanup_func = f;
+}
+
 void handle_ext_int(struct stack_frame_int *stack)
 {
 	if (!ext_int_expected &&
@@ -215,6 +221,9 @@ void handle_ext_int(struct stack_frame_int *stack)
 
 	if (!(stack->crs[0] & CR0_EXTM_MASK))
 		lowcore.ext_old_psw.mask &= ~PSW_MASK_EXT;
+
+	if (ext_cleanup_func)
+		(*ext_cleanup_func)(stack);
 }
 
 void handle_mcck_int(void)
-- 
2.35.3

