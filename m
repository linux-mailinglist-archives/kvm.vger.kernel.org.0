Return-Path: <kvm+bounces-59-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9559D7DB609
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 10:22:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E1AF281457
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 09:22:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F700DDAE;
	Mon, 30 Oct 2023 09:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ww1+dYOu"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9DBD273
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 09:22:32 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C809B7;
	Mon, 30 Oct 2023 02:22:31 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39U9EAnx001214;
	Mon, 30 Oct 2023 09:22:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=7cQ1XKmOyULFwtMyGL/OA0Nq4rIkBR5sHXe1NuRjNd4=;
 b=Ww1+dYOu0yZN6K/Wj5d80+/7DfWgZoarpntBC6QvOLkHcUoZ50ooAxiBELPDMIlLWr1R
 KxKMHdxXbswv18evcgkpsuL7JNzlp521sxrta9RbOR5u1KCQYlEpc3ntxVQhv/YjCJTs
 xq8oXULTCPwUgAoHfwqgFiQCo8AuPwxTZFuhQq2KWztc0oP1UwYcLA1H1swSohjSDAsO
 hiWgBA4IH2Bbtg9+/VbYO+xhv93JA76f/TVYkkjzmYSIjPiz10yIMIdeeEv15DSVZoy4
 jchIlJK+7rp8C3DfirfEx93PjCY9CIRlCsVZ27t6cd/7AbJopZ43fNUdb8XMFoGyoCFx Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u29p4r700-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 09:22:30 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39U9FXS4006049;
	Mon, 30 Oct 2023 09:22:29 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u29p4r6yn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 09:22:29 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39U7FEcW011300;
	Mon, 30 Oct 2023 09:22:29 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1eujqmfu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Oct 2023 09:22:29 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39U9MQ3r45351196
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Oct 2023 09:22:26 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 37DC320043;
	Mon, 30 Oct 2023 09:22:26 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC3C020040;
	Mon, 30 Oct 2023 09:22:25 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.67.230])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 30 Oct 2023 09:22:25 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, nrb@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [GIT PULL 2/2] KVM: s390: add tracepoint in gmap notifier
Date: Mon, 30 Oct 2023 10:08:39 +0100
Message-ID: <20231030092101.66014-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231030092101.66014-1-frankja@linux.ibm.com>
References: <20231030092101.66014-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1hSXPOqPXk4x987oORQyzFbWydRq8Hg1
X-Proofpoint-ORIG-GUID: cDWTvYXn6Un2tFTiIs3-R2VHHp-SOD2C
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_08,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 bulkscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310300070

From: Nico Boehr <nrb@linux.ibm.com>

The gmap notifier is called for changes in table entries with the
notifier bit set. To diagnose performance issues, it can be useful to
see what causes certain changes in the gmap.

Hence, add a tracepoint in the gmap notifier.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20231009093304.2555344-3-nrb@linux.ibm.com
Message-Id: <20231009093304.2555344-3-nrb@linux.ibm.com>
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


