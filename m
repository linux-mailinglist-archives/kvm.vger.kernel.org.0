Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FE33D9087
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 16:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237214AbhG1O1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 10:27:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48886 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237020AbhG1O0s (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 10:26:48 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SENOZ9021173;
        Wed, 28 Jul 2021 10:26:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=uo43aCifpSvdtWjIYu/4JCHFWOWeX2ukFlyoLQJMahg=;
 b=bXJcQX//XR/mErZkc8CeRSa/9e7Ia0MrTBy+wMc+geu1BTizkd+1/MRlLiJaB6+Mo3KT
 C7uuRGo2G1xaxiWjUvmnaUz8GwgoFkeUCW83moVOEj2bXa8qI/uFIyAJTw0vkdDfIc7L
 sWo5mNSfECfdgaQCS8i1eEex5j7nbcXm5oMVDgmcA0asF6iF0qw8zswSEqm+8OXBqAFI
 HfPtBXOrGbOmSUO6BnCRuhOJbkQOvk/w/0N3v6m/ur5x2fwX18SOTSCuQ5U/gPDR4Ldv
 hgeNuPL/AjYK8JA8qbMaxhtvBf/X20iS3q3VGE8S7FEZX5PypGXEJLy9Y4MOZR+Yd+u4 Ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a35rb6ed8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 10:26:46 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SENgxa022181;
        Wed, 28 Jul 2021 10:26:46 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a35rb6ecb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 10:26:45 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SEJWQX017901;
        Wed, 28 Jul 2021 14:26:43 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3a235krqrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 14:26:43 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SEQewZ24969480
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 14:26:40 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27636A4057;
        Wed, 28 Jul 2021 14:26:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF844A405F;
        Wed, 28 Jul 2021 14:26:39 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.9.194])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 14:26:39 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/13] KVM: s390: pv: usage counter instead of flag
Date:   Wed, 28 Jul 2021 16:26:25 +0200
Message-Id: <20210728142631.41860-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728142631.41860-1-imbrenda@linux.ibm.com>
References: <20210728142631.41860-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1TA85TTMud5t-1GtEuHy6AVbN-r4rWKS
X-Proofpoint-GUID: iblJpPzut5c0HVwZ5XsxGNS37REV-1Km
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_08:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the is_protected field as a counter instead of a flag. This will
be used in upcoming patches.

Increment the counter when a secure configuration is created, and
decrement it when it is destroyed. Previously the flag was set when the
set secure parameters UVC was performed.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index ebb1c8d7bcb3..52e7d15a6dc7 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -223,7 +223,8 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
 			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
 	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
-	atomic_set(&kvm->mm->context.is_protected, 0);
+	if (!cc)
+		atomic_dec(&kvm->mm->context.is_protected);
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
 	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
 	/* Intended memory leak on "impossible" error */
@@ -264,11 +265,14 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	/* Outputs */
 	kvm->arch.pv.handle = uvcb.guest_handle;
 
+	atomic_inc(&kvm->mm->context.is_protected);
 	if (cc) {
-		if (uvcb.header.rc & UVC_RC_NEED_DESTROY)
+		if (uvcb.header.rc & UVC_RC_NEED_DESTROY) {
 			kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
-		else
+		} else {
+			atomic_dec(&kvm->mm->context.is_protected);
 			kvm_s390_pv_dealloc_vm(kvm);
+		}
 		return -EIO;
 	}
 	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
@@ -291,8 +295,6 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
 	*rrc = uvcb.header.rrc;
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
 		     *rc, *rrc);
-	if (!cc)
-		atomic_set(&kvm->mm->context.is_protected, 1);
 	return cc ? -EINVAL : 0;
 }
 
-- 
2.31.1

