Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6455A628D
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 13:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiH3L4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 07:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiH3L4c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 07:56:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31982D0754
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 04:56:30 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27UBmhK2005153
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 11:56:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4H2eox40AZufoiWnrHpvHF2addV58EM4Y2arqUUZsXk=;
 b=CNxaKmf1U6H6jkOI0iVYvLV7FsiqXCc2Ber76wtXRNOSy27u1fC6BxppvG9dFIcpdtJQ
 VY4tq0ubuI7Qel9ygbOJMxdvo4Jx7RJFVqE2YJWao6UNK51rRYun2/wzybHwAe2Rs5j8
 22u55O90sv/BVRzXlimhPhDEerNUidbm4moIARIbjtbTsr663tL1nfKoCgNoE/6LSxMZ
 vvWEuon7nlMibRD4s/ACOb+GRStN6qjS1cLoGz6c3MDLJv/kFHXrTwgez+SJN9UE7rWc
 aOoV3bn4cSVmFvZL6Khyi5NOF1zptmC8DPZyqJRGtuDlILMDn0pXedTEIgNGM2vOTKjU OQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j9j0kg6ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 11:56:29 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27UBnNkD008244
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 11:56:29 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j9j0kg6bh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 11:56:29 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27UBpV9s005831;
        Tue, 30 Aug 2022 11:56:26 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3j7ahj3pt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 11:56:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27UBuNOn44302810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Aug 2022 11:56:23 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2FDA11C04A;
        Tue, 30 Aug 2022 11:56:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9972411C052;
        Tue, 30 Aug 2022 11:56:23 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Aug 2022 11:56:23 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 1/2] lib/s390x: time: add wrapper for stckf
Date:   Tue, 30 Aug 2022 13:56:22 +0200
Message-Id: <20220830115623.515981-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220830115623.515981-1-nrb@linux.ibm.com>
References: <20220830115623.515981-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Zmi3afD4OCfQ6TkqJMsV2p-qVLkHRN5C
X-Proofpoint-ORIG-GUID: xMedGVqldRgtTChTz10QEXKsMQboCVHz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_06,2022-08-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=822
 clxscore=1015 impostorscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208300057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Upcoming changes will do performance measurements of instructions. Since
stck is designed to return unique values even on concurrent calls, it is
unsuited for performance measurements. stckf should be used in this
case.

Hence, add a nice wrapper for stckf to the time library.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/time.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
index 7652a151e87a..d7c2bcb4f306 100644
--- a/lib/s390x/asm/time.h
+++ b/lib/s390x/asm/time.h
@@ -14,6 +14,15 @@
 #define STCK_SHIFT_US	(63 - 51)
 #define STCK_MAX	((1UL << 52) - 1)
 
+static inline uint64_t get_clock_fast(void)
+{
+	uint64_t clk;
+
+	asm volatile(" stckf %0 " : : "Q"(clk) : "memory");
+
+	return clk;
+}
+
 static inline uint64_t get_clock_us(void)
 {
 	uint64_t clk;
-- 
2.36.1

