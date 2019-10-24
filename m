Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E611E30D9
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 13:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409280AbfJXLmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 07:42:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16008 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2409275AbfJXLma (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 07:42:30 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9OBb9RS088853
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:29 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vuapnhfrx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:29 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 24 Oct 2019 12:42:27 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 24 Oct 2019 12:42:24 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9OBgMhZ52560098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 11:42:22 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51CDF5205A;
        Thu, 24 Oct 2019 11:42:22 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D0DBF5204E;
        Thu, 24 Oct 2019 11:42:20 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com, frankja@linux.ibm.com
Subject: [RFC 22/37] KVM: s390: protvirt: Add SCLP handling
Date:   Thu, 24 Oct 2019 07:40:44 -0400
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024114059.102802-1-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102411-0008-0000-0000-00000326C827
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102411-0009-0000-0000-00004A45FB31
Message-Id: <20191024114059.102802-23-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=534 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910240115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

Unmask the SCLP IRQ once we get the notification intercept on SCLP.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/intercept.c | 25 +++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.c  |  2 ++
 2 files changed, 27 insertions(+)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index a1df8a43c88b..510b1dee3320 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -460,11 +460,36 @@ static int handle_pv_spx(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int handle_pv_sclp(struct kvm_vcpu *vcpu)
+{
+	struct kvm_s390_float_interrupt *fi = &vcpu->kvm->arch.float_int;
+
+	spin_lock(&fi->lock);
+	/*
+	 * 2 cases:
+	 * a: an sccb answering interrupt was already pending or in flight.
+	 *    As the sccb value is not used we can simply set some more bits
+	 *    and make sure that we deliver something
+	 * b: an error sccb interrupt needs to be injected so we also inject
+	 *    something and let firmware do the right thing.
+	 * This makes sure, that both errors and real sccb returns will only
+	 * be delivered when we are unmasked.
+	 */
+	fi->srv_signal.ext_params |= 0x43000;
+	set_bit(IRQ_PEND_EXT_SERVICE, &fi->pending_irqs);
+	clear_bit(IRQ_PEND_EXT_SERVICE, &fi->masked_irqs);
+	spin_unlock(&fi->lock);
+	return 0;
+}
+
 static int handle_pv_not(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.sie_block->ipa == 0xb210)
 		return handle_pv_spx(vcpu);
 
+	if (vcpu->arch.sie_block->ipa == 0xb220)
+		return handle_pv_sclp(vcpu);
+
 	return handle_instruction(vcpu);
 }
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6747cb6cf062..eddc9508c1b1 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2189,6 +2189,8 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		if (!r)
 			r = kvm_s390_pv_create_vm(kvm);
 		kvm_s390_vcpu_unblock_all(kvm);
+		/* we need to block service interrupts from now on */
+		set_bit(IRQ_PEND_EXT_SERVICE,&kvm->arch.float_int.masked_irqs);
 		mutex_unlock(&kvm->lock);
 		break;
 	}
-- 
2.20.1

