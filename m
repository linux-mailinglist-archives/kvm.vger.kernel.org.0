Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9BDA45A082
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 11:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbhKWKn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 05:43:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8134 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234499AbhKWKn1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Nov 2021 05:43:27 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN8mcAB027852;
        Tue, 23 Nov 2021 10:40:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3SRnOQutGWcM7+x7k+N8fe4b0olytEbFLNPrpqXO1CA=;
 b=euKT12y4trIh9HPcYAH9yTXsyhtVQttLjLM9Fsay7UlNEhlBsh1Y1dEKyC/mQ0fgMr3K
 k85KvNOE5ICRtExjugevuEceazAoesw8rUoc3lqLU2qWqH2IqlYhK0pUwxWZsyfAg4I1
 FlUQuzpD4tNwt7jvK25/7cx1zCoxOvZ4SK25H7hrC0C7R6eO/AgSRkpYkoigIhmx25gq
 wncA0X3Wp9FEVX5ruJKz/+U90q+nu8qaDCRjvLVJSE2OHoP7HJ5Jdum9oTV65DMy2JKc
 dMATNGP9rfe0gVMNzk2cHueO2LFk63Dsut3Jw2MNPShT1Oom4m5ROFLwxhhmGFVawLqd Pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgsn2nybc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:19 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ANACDAS040621;
        Tue, 23 Nov 2021 10:40:18 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgsn2nyan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:18 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ANAcDMA007107;
        Tue, 23 Nov 2021 10:40:16 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3cern9nknf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 10:40:16 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ANAeDDH33358252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 10:40:13 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17000A405E;
        Tue, 23 Nov 2021 10:40:13 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8032A4040;
        Tue, 23 Nov 2021 10:40:11 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Nov 2021 10:40:11 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        mhartmay@linux.ibm.com
Subject: [kvm-unit-tests PATCH 6/8] lib: s390: sie: Add PV guest register handling
Date:   Tue, 23 Nov 2021 10:39:54 +0000
Message-Id: <20211123103956.2170-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123103956.2170-1-frankja@linux.ibm.com>
References: <20211123103956.2170-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -uof_XUaok7QqHVgCtUr539cvMETP1Xj
X-Proofpoint-ORIG-GUID: xIEZAnucsR9ycG9kV09UtvmA6Hsft2-Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_03,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Protected guests have their registers stored to / loaded from offset 0x380
of the sie control block. So we need to copy over the GRs to/from that
offset for format 4 (PV) guests before and after we enter SIE.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sie.c | 8 ++++++++
 lib/s390x/sie.h | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
index 51d3b94e..00aff713 100644
--- a/lib/s390x/sie.c
+++ b/lib/s390x/sie.c
@@ -44,6 +44,10 @@ void sie_handle_validity(struct vm *vm)
 
 void sie(struct vm *vm)
 {
+	if (vm->sblk->sdf == 2)
+		memcpy(vm->sblk->pv_grregs, vm->save_area.guest.grs,
+		       sizeof(vm->save_area.guest.grs));
+
 	/* Reset icptcode so we don't trip over it below */
 	vm->sblk->icptcode = 0;
 
@@ -53,6 +57,10 @@ void sie(struct vm *vm)
 	}
 	vm->save_area.guest.grs[14] = vm->sblk->gg14;
 	vm->save_area.guest.grs[15] = vm->sblk->gg15;
+
+	if (vm->sblk->sdf == 2)
+		memcpy(vm->save_area.guest.grs, vm->sblk->pv_grregs,
+		       sizeof(vm->save_area.guest.grs));
 }
 
 void sie_guest_sca_create(struct vm *vm)
diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
index 6d209793..de91ea5a 100644
--- a/lib/s390x/sie.h
+++ b/lib/s390x/sie.h
@@ -198,6 +198,8 @@ union {
 	uint64_t	itdba;			/* 0x01e8 */
 	uint64_t   	riccbd;			/* 0x01f0 */
 	uint64_t	gvrd;			/* 0x01f8 */
+	uint64_t	reserved200[48];	/* 0x0200 */
+	uint64_t	pv_grregs[16];		/* 0x0380 */
 } __attribute__((packed));
 
 struct vm_uv {
-- 
2.32.0

