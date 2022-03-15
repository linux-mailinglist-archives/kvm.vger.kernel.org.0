Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054484D9D19
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 15:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349033AbiCOONL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 10:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349035AbiCOOM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 10:12:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0692E546B8;
        Tue, 15 Mar 2022 07:11:45 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FCiUqt010657;
        Tue, 15 Mar 2022 14:11:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=8f22+OALsNAkpqF/krJV+8RdsVd0gmS6s4o79r5zrlc=;
 b=r1amNqqOiumAseXHpR9RRCNuhWrpCffRabzqm+mX84kfe9S9hcUTJ4PH7lZc9d9YXuU1
 W12+f4B95xqF4qtNXXhYP7O5VOkSjVU/O+3YYqaFQr982eB9HjprndZ2T4quoVgIzgKa
 BhBo+ZZBQwh+DgqLeQmclaWmJ9lxOIkXhRaHUWdJa7JX1PWDHi8g8eRhUZUaQcDnMlB4
 a78FjHAVjjZ8C7QwC8/9iTDAE4wAe4fQGgoKxtPlCcZz5Q1ikmDmuddLZf6QsShKsxJW
 zVjBiuZVkEmIf5GZEICDDnvnhwv1GqspNG/oX7coeImYxppyoNqxpPfLmo1Ba6H23FD/ Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3etu2st0s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:43 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22FDtr8u018282;
        Tue, 15 Mar 2022 14:11:43 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3etu2st0rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:43 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FE9Msw013300;
        Tue, 15 Mar 2022 14:11:41 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3erjshptbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FEBcXE51511706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 14:11:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C95D42047;
        Tue, 15 Mar 2022 14:11:38 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8537042042;
        Tue, 15 Mar 2022 14:11:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 15 Mar 2022 14:11:38 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 43ABFE127A; Tue, 15 Mar 2022 15:11:38 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 1/7] KVM: s390: pv: make use of ultravisor AIV support
Date:   Tue, 15 Mar 2022 15:11:31 +0100
Message-Id: <20220315141137.357923-2-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220315141137.357923-1-borntraeger@linux.ibm.com>
References: <20220315141137.357923-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gKjHUStmX51uPySKu5FI7UMFefG6NDXT
X-Proofpoint-ORIG-GUID: JaFRnC_p-jiPViZWJaAooyhfCOB37AdB
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 bulkscore=0 phishscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=885 adultscore=0 mlxscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Mueller <mimu@linux.ibm.com>

This patch enables the ultravisor adapter interruption vitualization
support indicated by UV feature BIT_UV_FEAT_AIV. This allows ISC
interruption injection directly into the GISA IPM for PV kvm guests.

Hardware that does not support this feature will continue to use the
UV interruption interception method to deliver ISC interruptions to
PV kvm guests. For this purpose, the ECA_AIV bit for all guest cpus
will be cleared and the GISA will be disabled during PV CPU setup.

In addition a check in __inject_io() has been removed. That reduces the
required instructions for interruption handling for PV and traditional
kvm guests.

Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20220209152217.1793281-2-mimu@linux.ibm.com
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/include/asm/uv.h |  1 +
 arch/s390/kvm/interrupt.c  | 54 +++++++++++++++++++++++++++++++++-----
 arch/s390/kvm/kvm-s390.c   | 11 +++++---
 arch/s390/kvm/kvm-s390.h   | 11 ++++++++
 4 files changed, 68 insertions(+), 9 deletions(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 86218382d29c..a2d376b8bce3 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -80,6 +80,7 @@ enum uv_cmds_inst {
 
 enum uv_feat_ind {
 	BIT_UV_FEAT_MISC = 0,
+	BIT_UV_FEAT_AIV = 1,
 };
 
 struct uv_cb_header {
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index db933c252dbc..9b30beac904d 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1901,13 +1901,12 @@ static int __inject_io(struct kvm *kvm, struct kvm_s390_interrupt_info *inti)
 	isc = int_word_to_isc(inti->io.io_int_word);
 
 	/*
-	 * Do not make use of gisa in protected mode. We do not use the lock
-	 * checking variant as this is just a performance optimization and we
-	 * do not hold the lock here. This is ok as the code will pick
-	 * interrupts from both "lists" for delivery.
+	 * We do not use the lock checking variant as this is just a
+	 * performance optimization and we do not hold the lock here.
+	 * This is ok as the code will pick interrupts from both "lists"
+	 * for delivery.
 	 */
-	if (!kvm_s390_pv_get_handle(kvm) &&
-	    gi->origin && inti->type & KVM_S390_INT_IO_AI_MASK) {
+	if (gi->origin && inti->type & KVM_S390_INT_IO_AI_MASK) {
 		VM_EVENT(kvm, 4, "%s isc %1u", "inject: I/O (AI/gisa)", isc);
 		gisa_set_ipm_gisc(gi->origin, isc);
 		kfree(inti);
@@ -3171,9 +3170,33 @@ void kvm_s390_gisa_init(struct kvm *kvm)
 	VM_EVENT(kvm, 3, "gisa 0x%pK initialized", gi->origin);
 }
 
+void kvm_s390_gisa_enable(struct kvm *kvm)
+{
+	struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+	u32 gisa_desc;
+
+	if (gi->origin)
+		return;
+	kvm_s390_gisa_init(kvm);
+	gisa_desc = kvm_s390_get_gisa_desc(kvm);
+	if (!gisa_desc)
+		return;
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		mutex_lock(&vcpu->mutex);
+		vcpu->arch.sie_block->gd = gisa_desc;
+		vcpu->arch.sie_block->eca |= ECA_AIV;
+		VCPU_EVENT(vcpu, 3, "AIV gisa format-%u enabled for cpu %03u",
+			   vcpu->arch.sie_block->gd & 0x3, vcpu->vcpu_id);
+		mutex_unlock(&vcpu->mutex);
+	}
+}
+
 void kvm_s390_gisa_destroy(struct kvm *kvm)
 {
 	struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
+	struct kvm_s390_gisa *gisa = gi->origin;
 
 	if (!gi->origin)
 		return;
@@ -3184,6 +3207,25 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
 		cpu_relax();
 	hrtimer_cancel(&gi->timer);
 	gi->origin = NULL;
+	VM_EVENT(kvm, 3, "gisa 0x%pK destroyed", gisa);
+}
+
+void kvm_s390_gisa_disable(struct kvm *kvm)
+{
+	struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+
+	if (!gi->origin)
+		return;
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		mutex_lock(&vcpu->mutex);
+		vcpu->arch.sie_block->eca &= ~ECA_AIV;
+		vcpu->arch.sie_block->gd = 0U;
+		mutex_unlock(&vcpu->mutex);
+		VCPU_EVENT(vcpu, 3, "AIV disabled for cpu %03u", vcpu->vcpu_id);
+	}
+	kvm_s390_gisa_destroy(kvm);
 }
 
 /**
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e056ad86ccd2..b5ea95cf8686 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2195,6 +2195,9 @@ static int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
 		}
 		mutex_unlock(&vcpu->mutex);
 	}
+	/* Ensure that we re-enable gisa if the non-PV guest used it but the PV guest did not. */
+	if (use_gisa)
+		kvm_s390_gisa_enable(kvm);
 	return ret;
 }
 
@@ -2206,6 +2209,10 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
 
 	struct kvm_vcpu *vcpu;
 
+	/* Disable the GISA if the ultravisor does not support AIV. */
+	if (!test_bit_inv(BIT_UV_FEAT_AIV, &uv_info.uv_feature_indications))
+		kvm_s390_gisa_disable(kvm);
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		mutex_lock(&vcpu->mutex);
 		r = kvm_s390_pv_create_cpu(vcpu, rc, rrc);
@@ -3350,9 +3357,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.sie_block->icpua = vcpu->vcpu_id;
 	spin_lock_init(&vcpu->arch.local_int.lock);
-	vcpu->arch.sie_block->gd = (u32)(u64)vcpu->kvm->arch.gisa_int.origin;
-	if (vcpu->arch.sie_block->gd && sclp.has_gisaf)
-		vcpu->arch.sie_block->gd |= GISA_FORMAT1;
+	vcpu->arch.sie_block->gd = kvm_s390_get_gisa_desc(vcpu->kvm);
 	seqcount_init(&vcpu->arch.cputm_seqcount);
 
 	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 098831e815e6..4ba8fc30d87a 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -231,6 +231,15 @@ static inline unsigned long kvm_s390_get_gfn_end(struct kvm_memslots *slots)
 	return ms->base_gfn + ms->npages;
 }
 
+static inline u32 kvm_s390_get_gisa_desc(struct kvm *kvm)
+{
+	u32 gd = (u32)(u64)kvm->arch.gisa_int.origin;
+
+	if (gd && sclp.has_gisaf)
+		gd |= GISA_FORMAT1;
+	return gd;
+}
+
 /* implemented in pv.c */
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
 int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
@@ -450,6 +459,8 @@ int kvm_s390_get_irq_state(struct kvm_vcpu *vcpu,
 void kvm_s390_gisa_init(struct kvm *kvm);
 void kvm_s390_gisa_clear(struct kvm *kvm);
 void kvm_s390_gisa_destroy(struct kvm *kvm);
+void kvm_s390_gisa_disable(struct kvm *kvm);
+void kvm_s390_gisa_enable(struct kvm *kvm);
 int kvm_s390_gib_init(u8 nisc);
 void kvm_s390_gib_destroy(void);
 
-- 
2.35.1

