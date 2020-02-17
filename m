Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F14F161523
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 15:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgBQOxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 09:53:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40464 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729304AbgBQOxM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Feb 2020 09:53:12 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01HEoHo6130178;
        Mon, 17 Feb 2020 09:53:07 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y6dq5ywur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Feb 2020 09:53:07 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01HEok86132311;
        Mon, 17 Feb 2020 09:53:06 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y6dq5ywud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Feb 2020 09:53:06 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01HEixQ7006012;
        Mon, 17 Feb 2020 14:53:05 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04wdc.us.ibm.com with ESMTP id 2y68962ec4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Feb 2020 14:53:05 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01HEr3Fv10683354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Feb 2020 14:53:03 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0EA9AE062;
        Mon, 17 Feb 2020 14:53:03 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2DB5AE05C;
        Mon, 17 Feb 2020 14:53:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 17 Feb 2020 14:53:03 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     david@redhat.com
Cc:     Ulrich.Weigand@de.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, frankja@linux.ibm.com,
        frankja@linux.vnet.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com, thuth@redhat.com
Subject: [PATCH 2/2] merge vm/cpu create
Date:   Mon, 17 Feb 2020 09:53:02 -0500
Message-Id: <20200217145302.19085-3-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200217145302.19085-1-borntraeger@de.ibm.com>
References: <c77dbb1b-0f4b-e40a-52a4-7110aec75e32@redhat.com>
 <20200217145302.19085-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-17_08:2020-02-17,2020-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=1 impostorscore=0
 spamscore=0 mlxlogscore=619 bulkscore=0 phishscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002170123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 55 +++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 15 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index a095d9695f18..10b20e17a7fe 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2171,9 +2171,41 @@ static int kvm_s390_set_cmma_bits(struct kvm *kvm,
 	return r;
 }
 
+static int kvm_s390_switch_from_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
+{
+	int i, r = 0;
+
+	struct kvm_vcpu *vcpu;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		r = kvm_s390_pv_destroy_cpu(vcpu, rc, rrc);
+		if (r)
+			break;
+	}
+	return r;
+}
+
+static int kvm_s390_switch_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
+{
+	int i, r = 0;
+	u16 dummy;
+
+	struct kvm_vcpu *vcpu;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		r = kvm_s390_pv_create_cpu(vcpu, rc, rrc);
+		if (r)
+			break;
+	}
+	if (r)
+		kvm_s390_switch_from_pv(kvm,&dummy, &dummy);
+	return r;
+}
+
 static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 {
 	int r = 0;
+	u16 dummy;
 	void __user *argp = (void __user *)cmd->data;
 
 	switch (cmd->cmd) {
@@ -2204,6 +2236,11 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 			break;
 		}
 		r = kvm_s390_pv_create_vm(kvm, &cmd->rc, &cmd->rrc);
+		if (!r)
+			r = kvm_s390_switch_to_pv(kvm, &cmd->rc, &cmd->rrc);
+		if (r)
+			kvm_s390_pv_destroy_vm(kvm, &dummy, &dummy);
+
 		kvm_s390_vcpu_unblock_all(kvm);
 		/* we need to block service interrupts from now on */
 		set_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
@@ -2215,7 +2252,9 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 			break;
 
 		kvm_s390_vcpu_block_all(kvm);
-		r = kvm_s390_pv_destroy_vm(kvm, &cmd->rc, &cmd->rrc);
+		r = kvm_s390_switch_from_pv(kvm, &cmd->rc, &cmd->rrc);
+		if (!r)
+			r = kvm_s390_pv_destroy_vm(kvm, &cmd->rc, &cmd->rrc);
 		if (!r)
 			kvm_s390_pv_dealloc_vm(kvm);
 		kvm_s390_vcpu_unblock_all(kvm);
@@ -4660,20 +4699,6 @@ static int kvm_s390_handle_pv_vcpu(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	switch (cmd->cmd) {
-	case KVM_PV_VCPU_CREATE: {
-		if (kvm_s390_pv_handle_cpu(vcpu))
-			return -EINVAL;
-
-		r = kvm_s390_pv_create_cpu(vcpu, &cmd->rc, &cmd->rrc);
-		break;
-	}
-	case KVM_PV_VCPU_DESTROY: {
-		if (!kvm_s390_pv_handle_cpu(vcpu))
-			return -EINVAL;
-
-		r = kvm_s390_pv_destroy_cpu(vcpu, &cmd->rc, &cmd->rrc);
-		break;
-	}
 	case KVM_PV_VCPU_SET_IPL_PSW: {
 		if (!kvm_s390_pv_handle_cpu(vcpu))
 			return -EINVAL;
-- 
2.25.0

