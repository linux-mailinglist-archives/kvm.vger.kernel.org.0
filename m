Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707F857D0F1
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbiGUQN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbiGUQNV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:13:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9983A87369;
        Thu, 21 Jul 2022 09:13:19 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFmbHt020184;
        Thu, 21 Jul 2022 16:13:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=/h74ft4NCgyq8K/TQ9Zym+qoOLJesx1cuJiSQUOafec=;
 b=eV10J66vY2F1P+qUSEmO0EBDD81mtIy6n3551GiIJs9dnU/y0etGxP9OEs1QXHbmroOI
 BTugHLZk85gucQCYFCbc5MuLKarFqSGkj4koUSRFy6I7ZOmx+yaxtD6vHPuGJWEgP+we
 vU4xgIMFxQ7x1UpScAP3T/qjd0rShpw19YJmjvVeAoOYsuesSqp9tg8GOMxHp3f6l+Vq
 6CmsqGFMb7kXNRDdOOyWhNz0Xe95ldP0UZC680R3Lh+Os9JXx8zSeYAr1SVyhUsF4v86
 wjgLyz5SjbaPQrAnpBRBmRpUC5qPUk0Pg4AEIepvHE4e9S69fpfRjQuJ1Y0BMRnbvpCl Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9s4rsjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:19 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LFmkMI020890;
        Thu, 21 Jul 2022 16:13:18 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9s4rsh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:18 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG6vnK002733;
        Thu, 21 Jul 2022 16:13:16 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3hbmy8nf1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:15 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGDCct10289466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:13:12 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0EAEA405B;
        Thu, 21 Jul 2022 16:13:12 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C1FCA4054;
        Thu, 21 Jul 2022 16:13:12 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:12 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [GIT PULL 14/42] KVM: s390: mechanism to enable guest zPCI Interpretation
Date:   Thu, 21 Jul 2022 18:12:34 +0200
Message-Id: <20220721161302.156182-15-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4v4uQpn1AKOdoNSYWaUbEkCBF30lFaxN
X-Proofpoint-GUID: 8-vUS_Ak7Puzo5-yNY_vEmnRZjm1h7aV
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 impostorscore=0 phishscore=0 suspectscore=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207210061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Matthew Rosato <mjrosato@linux.ibm.com>

The guest must have access to certain facilities in order to allow
interpretive execution of zPCI instructions and adapter event
notifications.  However, there are some cases where a guest might
disable interpretation -- provide a mechanism via which we can defer
enabling the associated zPCI interpretation facilities until the guest
indicates it wishes to use them.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Link: https://lore.kernel.org/r/20220606203325.110625-15-mjrosato@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  4 ++++
 arch/s390/kvm/kvm-s390.c         | 38 ++++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h         | 10 +++++++++
 3 files changed, 52 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index c1518a505060..8e381603b6a7 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -254,7 +254,10 @@ struct kvm_s390_sie_block {
 #define ECB2_IEP	0x20
 #define ECB2_PFMFI	0x08
 #define ECB2_ESCA	0x04
+#define ECB2_ZPCI_LSI	0x02
 	__u8    ecb2;                   /* 0x0062 */
+#define ECB3_AISI	0x20
+#define ECB3_AISII	0x10
 #define ECB3_DEA 0x08
 #define ECB3_AES 0x04
 #define ECB3_RI  0x01
@@ -940,6 +943,7 @@ struct kvm_arch{
 	int use_cmma;
 	int use_pfmfi;
 	int use_skf;
+	int use_zpci_interp;
 	int user_cpu_state_ctrl;
 	int user_sigp;
 	int user_stsi;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d96c9be0480b..a66da3f66114 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1031,6 +1031,42 @@ static int kvm_s390_vm_set_crypto(struct kvm *kvm, struct kvm_device_attr *attr)
 	return 0;
 }
 
+static void kvm_s390_vcpu_pci_setup(struct kvm_vcpu *vcpu)
+{
+	/* Only set the ECB bits after guest requests zPCI interpretation */
+	if (!vcpu->kvm->arch.use_zpci_interp)
+		return;
+
+	vcpu->arch.sie_block->ecb2 |= ECB2_ZPCI_LSI;
+	vcpu->arch.sie_block->ecb3 |= ECB3_AISII + ECB3_AISI;
+}
+
+void kvm_s390_vcpu_pci_enable_interp(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+
+	lockdep_assert_held(&kvm->lock);
+
+	if (!kvm_s390_pci_interp_allowed())
+		return;
+
+	/*
+	 * If host is configured for PCI and the necessary facilities are
+	 * available, turn on interpretation for the life of this guest
+	 */
+	kvm->arch.use_zpci_interp = 1;
+
+	kvm_s390_vcpu_block_all(kvm);
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		kvm_s390_vcpu_pci_setup(vcpu);
+		kvm_s390_sync_request(KVM_REQ_VSIE_RESTART, vcpu);
+	}
+
+	kvm_s390_vcpu_unblock_all(kvm);
+}
+
 static void kvm_s390_sync_request_broadcast(struct kvm *kvm, int req)
 {
 	unsigned long cx;
@@ -3336,6 +3372,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 
 	kvm_s390_vcpu_crypto_setup(vcpu);
 
+	kvm_s390_vcpu_pci_setup(vcpu);
+
 	mutex_lock(&vcpu->kvm->lock);
 	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
 		rc = kvm_s390_pv_create_cpu(vcpu, &uvrc, &uvrrc);
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 497d52a83c78..975cffaf13de 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -507,6 +507,16 @@ void kvm_s390_reinject_machine_check(struct kvm_vcpu *vcpu,
  */
 void kvm_s390_vcpu_crypto_reset_all(struct kvm *kvm);
 
+/**
+ * kvm_s390_vcpu_pci_enable_interp
+ *
+ * Set the associated PCI attributes for each vcpu to allow for zPCI Load/Store
+ * interpretation as well as adapter interruption forwarding.
+ *
+ * @kvm: the KVM guest
+ */
+void kvm_s390_vcpu_pci_enable_interp(struct kvm *kvm);
+
 /**
  * diag9c_forwarding_hz
  *
-- 
2.36.1

