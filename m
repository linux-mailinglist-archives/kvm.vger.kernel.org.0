Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB0ED490D07
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241663AbiAQRA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:00:28 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35854 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237864AbiAQRAA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 12:00:00 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20HGSe2S004826
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 17:00:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+CaEIQOp877DEr3QIrVgFZDfNht0hqb7CQvVfN2fjc8=;
 b=XJBy5L4d1x0phL2GPWfVDNcTODwerINfjiswBDCUqNV48voD551/VWWGKNc6rkSiYLy9
 SlgEShockhPrp+JmD6OHA5RklqNV8uIreROFl+giR51UUB2UFH+Hx7MxPvXaQeMDcn80
 /yv/shnlr6d+Edl1Uj4SvUlJ4jfsPN22Q++WRg2aRyqGv4iCJbi44UP2hO6/pz4UVx4a
 o+2mPxSm5cAuSEPds0jcObLVwq0SQjc2nLr3zq26ci+jMy4EHy2fEgSqop7gXY/9cLru
 8vjTjG94Z2IoEnmZZ6JydOJaeF4h616wNAB20KI+04iq9M6tfDaNY5tZt2i4XRojo6zA kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnc0v0ppn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:59 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20HGVZoU013745
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 16:59:59 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnc0v0pnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:58 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20HGkwmD018875;
        Mon, 17 Jan 2022 16:59:56 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3dknhhw8w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jan 2022 16:59:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20HGxrxk38928882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 16:59:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6977EA405F;
        Mon, 17 Jan 2022 16:59:53 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20112A4054;
        Mon, 17 Jan 2022 16:59:53 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.3.16])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jan 2022 16:59:53 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 07/13] lib: s390: sie: Add PV guest register handling
Date:   Mon, 17 Jan 2022 17:59:43 +0100
Message-Id: <20220117165949.75964-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220117165949.75964-1-imbrenda@linux.ibm.com>
References: <20220117165949.75964-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 56cEC9iZlKSkXeTihlli6RcUdsVX_Xuz
X-Proofpoint-ORIG-GUID: kLlDyHg2kiPa7oTVZvQ6snYHhn-HM-DE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-17_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxscore=0 suspectscore=0 impostorscore=0 spamscore=0
 adultscore=0 lowpriorityscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201170104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Protected guests have their registers stored to / loaded from offset 0x380
of the sie control block. So we need to copy over the GRs to/from that
offset for format 4 (PV) guests before and after we enter SIE.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/sie.h | 2 ++
 lib/s390x/sie.c | 8 ++++++++
 2 files changed, 10 insertions(+)

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
-- 
2.31.1

