Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C0746C03B
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 17:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239416AbhLGQFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 11:05:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9432 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239394AbhLGQFm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 11:05:42 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7FmIaA004593;
        Tue, 7 Dec 2021 16:02:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CVozEg4jr8AI5077zC1HKKlan6xbhHuj8n7iG/jEWow=;
 b=W8cSVRGwz1FPt+tZJWmznhAfWlIWV0u0wKkLKZ+TuyLgW3/ZtDBf/7NRPkzo/IpuMd5q
 Z5khnUPVfTOU2OXEcRq9A7NORm/4rkm6EUBdow1+t61BZr/RCPcsugoAU/yhGy6wuJQf
 BWMLiS7FpUjbSBpUSjy19BzXtfDUAfcMpL0UciAYLUUislHcyO3oGOhLxFgzVurKEqOw
 EbwxOus4EksclE5OR+UmJG7gC5J9xpUIMKsFYly+MPUFohl+/AZswa+PuQvFJQBXIT8X
 Zl8ufWg4R2UQ+PwAWJDSOVmVv4+mdvpOelbr+iXg5JG+Yxms7ozXCxj2bci8RThZVxhF Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctajy09a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:12 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7FwW2h007793;
        Tue, 7 Dec 2021 16:02:11 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctajy0990-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:11 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Frm6b008363;
        Tue, 7 Dec 2021 16:02:09 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3cqykfq3ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 16:02:09 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7FsPST18153794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 15:54:25 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02DB14C05E;
        Tue,  7 Dec 2021 16:02:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D795F4C064;
        Tue,  7 Dec 2021 16:02:04 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 16:02:04 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 06/10] lib: s390: sie: Add PV guest register handling
Date:   Tue,  7 Dec 2021 16:00:01 +0000
Message-Id: <20211207160005.1586-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207160005.1586-1-frankja@linux.ibm.com>
References: <20211207160005.1586-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: A95mtW9rW2wigQrmnknrS2jV2PYHyVf7
X-Proofpoint-GUID: cIQ7OeOPb3pXKQ-55Dad6eNFYhy-yow7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_06,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 malwarescore=0
 suspectscore=0 impostorscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Protected guests have their registers stored to / loaded from offset 0x380
of the sie control block. So we need to copy over the GRs to/from that
offset for format 4 (PV) guests before and after we enter SIE.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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

