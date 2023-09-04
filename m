Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2018F7917CA
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 15:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbjIDNJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 09:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbjIDNJF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 09:09:05 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB741136;
        Mon,  4 Sep 2023 06:09:02 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 384D61K8031150;
        Mon, 4 Sep 2023 13:09:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=RLD9GqoCg1AdkNM5rdK5gAmMqCUHrZqP+TXfNLNfCfM=;
 b=CuR4qqH0DAG2GqTvi/hdL9YCW3tOmtuUVdB/eCxCJnf2/z9jIbW3WhffJwS+sVITt+QJ
 +KDLmdAL2SnJsmqbZti9SHKqom9ObcOQCMZMI1tur/I0jKi2pi3mH0hPisOvg2MzgwLk
 TRYfTzpdbOClYmXH94lvdvk/v0OBNiyTC3EQPMipp0wdPL4bRiaDJQgO69OpfjXSsvHF
 exEVnnOMBvqeWIXmlw3FXd+BhNy6Wj4YiisYjB4p0ia6/AUBOODGyZVVeRTnwC1rId1K
 +nLHHtKaI6H/jGQOXvHyf0SEyyU3SkSsSg0DxTGzkIae/wFQ+BexnLXVWQRFszUeuRbk Dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sw82akfsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 13:08:59 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 384D635c031322;
        Mon, 4 Sep 2023 13:07:12 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sw82akdk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 13:07:11 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 384C4rdc021360;
        Mon, 4 Sep 2023 13:01:45 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3svfry2ymj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 13:01:45 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 384D1fCW6554176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Sep 2023 13:01:42 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAADD20040;
        Mon,  4 Sep 2023 13:01:41 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90BE02004F;
        Mon,  4 Sep 2023 13:01:41 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  4 Sep 2023 13:01:41 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v3 2/2] KVM: s390: add tracepoint in gmap notifier
Date:   Mon,  4 Sep 2023 15:01:39 +0200
Message-ID: <20230904130140.22006-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230904130140.22006-1-nrb@linux.ibm.com>
References: <20230904130140.22006-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ooIH4DTRIzRyK6khqjDdZD3IJDh40YpX
X-Proofpoint-GUID: kLj69QVwWykzc3KzfP427KBy5L4ry2_w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-04_07,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 impostorscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309040117
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
index 9379471081fa..f643c9b9f2f3 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3987,6 +3987,8 @@ static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
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
2.41.0

