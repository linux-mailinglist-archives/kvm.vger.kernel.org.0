Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303E06FC4B1
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 13:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbjEILMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 07:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbjEILMU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 07:12:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DC240FD;
        Tue,  9 May 2023 04:12:11 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 349AvH7d007236;
        Tue, 9 May 2023 11:12:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+3WJG0rj8LYFABzhX1lrIlXGD/ibhY8Eb7Gy+M2hMJ8=;
 b=g5FhaHi8sxgZgKDgPYy9eKqBQkkax38QCclaYv/myBYGQfeFyvEtN5WZ/EDUU7IIpr8z
 d5ZH4yHLryK6dOoFiuFwy2Wctt/ROXcagdiBndSW2a7WztHNX8i01ivrs/CLXOx0/bV8
 YQb2t7m9fYYUlFYHJci1TGXCW65gC6f8oyndDyu2YLNL4RA3HnZA5FsXhh1TIE2qpjY4
 RIbLy0eSMx+udt8nttCHCqGpWHW8qLOI6BL8WwXgN2RdgSQNzJfVXfmsN9qpuDKlx8HX
 lf8PsDpnGPRb/NHO0a0aTw8WU5tmVzFjTQ2PqvPraGxRuKKXAm08fGQHy3PvbDbSQXqb Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfeqn3fx3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 11:12:10 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 349B9t9t001582;
        Tue, 9 May 2023 11:12:09 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qfeqn3fwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 11:12:08 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3491a5ar029062;
        Tue, 9 May 2023 11:12:07 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qf896rcr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 May 2023 11:12:07 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 349BC3hn23659126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 May 2023 11:12:03 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6819E2004B;
        Tue,  9 May 2023 11:12:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FEA22004E;
        Tue,  9 May 2023 11:12:03 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  9 May 2023 11:12:03 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v1 3/3] KVM: s390: add tracepoint in gmap notifier
Date:   Tue,  9 May 2023 13:12:02 +0200
Message-Id: <20230509111202.333714-4-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230509111202.333714-1-nrb@linux.ibm.com>
References: <20230509111202.333714-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zPRlalYK79mnIhVNVTlaqAdJ2SEhWMt-
X-Proofpoint-GUID: O507UnsaQ0SCFCHBg5yeVBlOP_e0C733
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-09_06,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 mlxscore=0 impostorscore=0
 clxscore=1015 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305090083
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The gmap notifier is called whenever something in the gmap structures
changes. To diagnose performance issues, it can be useful to see what
causes certain changes in the gmap.

Hence, add a tracepoint in the gmap notifier.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c   |  2 ++
 arch/s390/kvm/trace-s390.h | 23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index b012645a5a7c..f66953bdabe4 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3981,6 +3981,8 @@ static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
 	unsigned long prefix;
 	unsigned long i;
 
+	trace_kvm_s390_gmap_notifier(start, end, gmap_is_shadow(gmap));
+
 	if (gmap_is_shadow(gmap))
 		return;
 	if (start >= 1UL << 31)
diff --git a/arch/s390/kvm/trace-s390.h b/arch/s390/kvm/trace-s390.h
index 6f0209d45164..5dabd0b64d6e 100644
--- a/arch/s390/kvm/trace-s390.h
+++ b/arch/s390/kvm/trace-s390.h
@@ -333,6 +333,29 @@ TRACE_EVENT(kvm_s390_airq_suppressed,
 		      __entry->id, __entry->isc)
 	);
 
+/*
+ * Trace point for gmap notifier calls.
+ */
+TRACE_EVENT(kvm_s390_gmap_notifier,
+		TP_PROTO(unsigned long start, unsigned long end, unsigned int shadow),
+		TP_ARGS(start, end, shadow),
+
+		TP_STRUCT__entry(
+			__field(unsigned long, start)
+			__field(unsigned long, end)
+			__field(unsigned int, shadow)
+			),
+
+		TP_fast_assign(
+			__entry->start = start;
+			__entry->end = end;
+			__entry->shadow = shadow;
+			),
+
+		TP_printk("gmap notified (start:0x%lx end:0x%lx shadow:%d)",
+			__entry->start, __entry->end, __entry->shadow)
+	);
+
 
 #endif /* _TRACE_KVMS390_H */
 
-- 
2.39.1

