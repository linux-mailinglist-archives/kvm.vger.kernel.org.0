Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5445C3D908A
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 16:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbhG1O1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 10:27:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6126 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236895AbhG1O0u (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 10:26:50 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SENPYV120145;
        Wed, 28 Jul 2021 10:26:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=/aS2l8y2q/t7/+xrlVjp94ibyZ8SszOLcOkdVrmwUW8=;
 b=rwuxET30sI6iRgmmJ+TnyovsIrEOjAk6bTwltORMrFEEvSFhIU7CsetPyvzSsS3zRifA
 chdjxca7n8bqPwmw2TeymS9toShouOAW4pLuK3zL5PU3fb5CUxDYlQrVDfI9QXpSuWBW
 7EE2FgZ+5a6BHMq+juvVtsQjLU4dinDS1EQfXwuw+C4eoQCP4Z8SyAjWvROql5upDDMW
 j21+NYJ2qNqYuxQNgqnQz3F8JAfjijj19qcURUgj7vMHvPxGcQvJ50Fbzw56L5E+wRTJ
 DlxjI5zwv+6m0f2ZiHkEoL4gj3MVa3aOsgQPbJKr8jaAMTUmKwMegAK6rkanucIjEn5x 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a37xmtgd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 10:26:48 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SENW7C120857;
        Wed, 28 Jul 2021 10:26:48 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a37xmtgcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 10:26:47 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SEJQPE005631;
        Wed, 28 Jul 2021 14:26:45 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3a235prqkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 14:26:45 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SEQgrC16449884
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 14:26:42 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 198A7A4053;
        Wed, 28 Jul 2021 14:26:42 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABC0DA4057;
        Wed, 28 Jul 2021 14:26:41 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.9.194])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 14:26:41 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 11/13] KVM: s390: pv: module parameter to fence lazy destroy
Date:   Wed, 28 Jul 2021 16:26:29 +0200
Message-Id: <20210728142631.41860-12-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728142631.41860-1-imbrenda@linux.ibm.com>
References: <20210728142631.41860-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7Fsr8SeHzOBikC7tmU0CQZt2JMXU-9T8
X-Proofpoint-GUID: Da8XaiUInG2OnUv-Cz_SapG2dsuv1a1u
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_08:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 impostorscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107280079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the module parameter "lazy_destroy", to allow the lazy destroy
mechanism to be switched off. This might be useful for debugging
purposes.

The parameter is enabled by default.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 950053a4efeb..088b94512af3 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -26,6 +26,10 @@ struct deferred_priv {
 	unsigned long stor_base;
 };
 
+static int lazy_destroy = 1;
+module_param(lazy_destroy, int, 0444);
+MODULE_PARM_DESC(lazy_destroy, "Deferred destroy for protected guests");
+
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 {
 	int cc = 0;
@@ -361,6 +365,9 @@ int kvm_s390_pv_deinit_vm_deferred(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	struct deferred_priv *priv;
 
+	if (!lazy_destroy)
+		return kvm_s390_pv_deinit_vm_now(kvm, rc, rrc);
+
 	priv = kmalloc(sizeof(*priv), GFP_KERNEL | __GFP_ZERO);
 	if (!priv)
 		return kvm_s390_pv_deinit_vm_now(kvm, rc, rrc);
@@ -409,6 +416,12 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	/* Outputs */
 	kvm->arch.pv.handle = uvcb.guest_handle;
 
+	if (!lazy_destroy) {
+		mmap_write_lock(kvm->mm);
+		kvm->mm->context.pv_sync_destroy = 1;
+		mmap_write_unlock(kvm->mm);
+	}
+
 	atomic_inc(&kvm->mm->context.is_protected);
 	if (cc) {
 		if (uvcb.header.rc & UVC_RC_NEED_DESTROY) {
-- 
2.31.1

