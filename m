Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8566FDD92
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 14:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236476AbjEJMSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 May 2023 08:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbjEJMSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 May 2023 08:18:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5441BFE;
        Wed, 10 May 2023 05:18:31 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34ABsGGc009362;
        Wed, 10 May 2023 12:18:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rFtdxM5wh8F+niGGBbt2eXCPP2Ny+n/Z9JmbUoTdo8E=;
 b=SVvd2yMdogBzrCRTKwe8ajD7DETo+ZuGrDXq+RBbGJHNos7JaEf0MaGucwTDcKFAhdcZ
 0Oou+Kh5oQSyuDY3hYnigznDxcNUqIjM3Jt/YM0fR8zt6fi8cs0IQGQnGMqsTIbg8Fds
 wyaDVg5oaP5GGkWLqwT9rFFJwKmU4tyMZrl+XIUk24OVYw51mOklhkFmPBIYDDjlaVds
 c78MpMo0lZ5LuoTV8UGaTjP4jqcXAKO/9EhUD+UuJ+QGxNb1vOZRZw5fpSUlmFahOHWk
 4BDM9f1TgqrCgdiqIcsqF4QmMANlsEQMn8ACAP/FeI5EzcOguERnTFNhPgolnT7EfyAf VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg8h0vv59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 12:18:30 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34ABkdYY014629;
        Wed, 10 May 2023 12:18:30 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qg8h0vv45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 12:18:29 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34A9Fqrk024133;
        Wed, 10 May 2023 12:18:27 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3qf7mhgusf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 May 2023 12:18:27 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34ACINLI25559704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 May 2023 12:18:24 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC6D42004B;
        Wed, 10 May 2023 12:18:23 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D13C20043;
        Wed, 10 May 2023 12:18:23 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 10 May 2023 12:18:23 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: s390: add tracepoint in gmap notifier
Date:   Wed, 10 May 2023 14:18:22 +0200
Message-Id: <20230510121822.546629-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230510121822.546629-1-nrb@linux.ibm.com>
References: <20230510121822.546629-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Z_tImuWbdeLoTYxXj72wKBrW2xzXQuLo
X-Proofpoint-GUID: IyS2mfRU6b8QmL2heQEDkSt8kYbXUjzr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-10_04,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305100095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The gmap notifier is called for changes in table entries with the
notifier bit set. To diagnose performance issues, it can be useful to
see what causes certain changes in the gmap.

Hence, add a tracepoint in the gmap notifier.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c   |  2 ++
 arch/s390/kvm/trace-s390.h | 23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index ded4149e145b..e8476c023b07 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3982,6 +3982,8 @@ static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
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

