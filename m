Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C087BD71F
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 11:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345758AbjJIJdQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 05:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345796AbjJIJdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 05:33:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F338CF;
        Mon,  9 Oct 2023 02:33:10 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3999WPPC004164;
        Mon, 9 Oct 2023 09:33:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MIIxPCCWfpPmbj2qaEwjC2LszalGS6yonNVNcKHMRZ0=;
 b=HPIl/9Ad3iCr1qLrb598p1tY03nrLl3KnKG+1JW9ur6QEJHr/FPbUEiG8CMbNlQu7jZD
 QV2Xoqf1FWavLOxPrAQ+wGrTO1Q2qBnzYpkbFKJ+DletBER2v9+ee8P7Tm5bdHzKMsVL
 /lXKTIQTZLdae3EVIqYl+xZiAWpuW+f211xEU/ho2j0KbD/+YLelpkwNZAHOTcVGBBG6
 1DMAYi4mwfStJHQS+kJy1cuOmcIJLJ4cAcaUQAIV4bIr/Br+cIPseXgZ9XhwK18bq33m
 0eWpI8zSJWr/saeDgnEDOFRnsgvLQueZIot4K3gDg3UDH/qpgtH00vMhgBNWpYj/dQyd Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tmeyq00fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Oct 2023 09:33:10 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3999X9Ql007118;
        Mon, 9 Oct 2023 09:33:09 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tmeyq00eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Oct 2023 09:33:09 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3998Mp7v024439;
        Mon, 9 Oct 2023 09:33:08 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkhns89sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Oct 2023 09:33:08 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3999X5pt12911210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Oct 2023 09:33:05 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43A3B20040;
        Mon,  9 Oct 2023 09:33:05 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1077E2004B;
        Mon,  9 Oct 2023 09:33:05 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  9 Oct 2023 09:33:05 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v4 2/2] KVM: s390: add tracepoint in gmap notifier
Date:   Mon,  9 Oct 2023 11:32:53 +0200
Message-ID: <20231009093304.2555344-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231009093304.2555344-1-nrb@linux.ibm.com>
References: <20231009093304.2555344-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3hWL12800w8jfsjdKOvHLN8oQmujlQ-Y
X-Proofpoint-ORIG-GUID: 9IDC1caccdzj98aHUUGMzeh7oBlaRA2Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-09_07,2023-10-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 mlxscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310090078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Acked-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/kvm/kvm-s390.c   |  2 ++
 arch/s390/kvm/trace-s390.h | 23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index b42493110d76..11676b81e6bf 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4060,6 +4060,8 @@ static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
 	unsigned long prefix;
 	unsigned long i;
 
+	trace_kvm_s390_gmap_notifier(start, end, gmap_is_shadow(gmap));
+
 	if (gmap_is_shadow(gmap))
 		return;
 	if (start >= 1UL << 31)
diff --git a/arch/s390/kvm/trace-s390.h b/arch/s390/kvm/trace-s390.h
index 6f0209d45164..9ac92dbf680d 100644
--- a/arch/s390/kvm/trace-s390.h
+++ b/arch/s390/kvm/trace-s390.h
@@ -333,6 +333,29 @@ TRACE_EVENT(kvm_s390_airq_suppressed,
 		      __entry->id, __entry->isc)
 	);
 
+/*
+ * Trace point for gmap notifier calls.
+ */
+TRACE_EVENT(kvm_s390_gmap_notifier,
+	    TP_PROTO(unsigned long start, unsigned long end, unsigned int shadow),
+	    TP_ARGS(start, end, shadow),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned long, start)
+		    __field(unsigned long, end)
+		    __field(unsigned int, shadow)
+		    ),
+
+	    TP_fast_assign(
+		    __entry->start = start;
+		    __entry->end = end;
+		    __entry->shadow = shadow;
+		    ),
+
+	    TP_printk("gmap notified (start:0x%lx end:0x%lx shadow:%d)",
+		      __entry->start, __entry->end, __entry->shadow)
+	);
+
 
 #endif /* _TRACE_KVMS390_H */
 
-- 
2.41.0

