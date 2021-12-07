Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BF046C593
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237243AbhLGVDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:03:25 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1074 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237048AbhLGVDJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:03:09 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Jei1Y031728;
        Tue, 7 Dec 2021 20:59:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=KqnYjCwgg5VlQRdEeX/AoA0TiMmXw8n0VYrf/UIT3Xc=;
 b=pU1mgoR/W9x4wlx1GGwA1XhYFdefUNXl6K4+nUk6f5N622c/vs5BnpYzccJOGFiSMC2I
 +GSvBMSkDVOAeZnZyI8l1eiCoMhX7KhYQBlAM91+EPCcCHz4rk0SKyVdm9yhF6jLGY3j
 9yFT50nho93qCQ+LsTwAPRgMt1FH9GCstogOikCHl1XPsgdyJwXrvQ8JnZ3texD7b+kz
 oB0U8hKf0BtVoRLsXOsFddaGHCI8m7uFGb+KhQPBVxN+1mp15LkfTUwlCsHziktx8Zje
 Dr4y0xD3nKnclKfMGtU5Tb++I6CviwkNGmX+J6b4F3S2eTX2M5PG/g5VMtIg/ntvEYHn Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctcdbuhf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:37 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7KnCYq029886;
        Tue, 7 Dec 2021 20:59:37 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctcdbuhet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:37 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Kvon8031438;
        Tue, 7 Dec 2021 20:59:36 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma05wdc.us.ibm.com with ESMTP id 3cqyyammwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:36 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7KxZmx19399188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 20:59:35 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25850AE064;
        Tue,  7 Dec 2021 20:59:35 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35337AE071;
        Tue,  7 Dec 2021 20:59:30 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 20:59:29 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/32] KVM: s390: mechanism to enable guest zPCI Interpretation
Date:   Tue,  7 Dec 2021 15:57:30 -0500
Message-Id: <20211207205743.150299-20-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207205743.150299-1-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YhWRzFrtjtLFQrcynYxssVdHKJlhqEch
X-Proofpoint-ORIG-GUID: jWHUr22hVYDLfYXz2VPBOTKBULDyOhYS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=999 adultscore=0 malwarescore=0 suspectscore=0 spamscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest must have access to certain facilities in order to allow
interpretive execution of zPCI instructions and adapter event
notifications.  However, there are some cases where a guest might
disable interpretation -- provide a mechanism via which we can defer
enabling the associated zPCI interpretation facilities until the guest
indicates it wishes to use them.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  4 +++
 arch/s390/kvm/kvm-s390.c         | 43 ++++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h         | 10 ++++++++
 3 files changed, 57 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 3f147b8d050b..38982c1de413 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -252,7 +252,10 @@ struct kvm_s390_sie_block {
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
@@ -938,6 +941,7 @@ struct kvm_arch{
 	int use_cmma;
 	int use_pfmfi;
 	int use_skf;
+	int use_zpci_interp;
 	int user_cpu_state_ctrl;
 	int user_sigp;
 	int user_stsi;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index a680f2a02b67..361d742cdf0d 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1023,6 +1023,47 @@ static int kvm_s390_vm_set_crypto(struct kvm *kvm, struct kvm_device_attr *attr)
 	return 0;
 }
 
+static void kvm_s390_vcpu_pci_setup(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * If the facilities aren't available for PCI interpretation and
+	 * interrupt forwarding, we shouldn't be here.
+	 */
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
+	int i;
+
+	/*
+	 * If host facilities are available, turn on interpretation for the
+	 * life of this guest
+	 */
+	if (!test_facility(69) || !test_facility(70) || !test_facility(71) ||
+	    !test_facility(72))
+		return;
+
+	mutex_lock(&kvm->lock);
+
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
+	mutex_unlock(&kvm->lock);
+}
+
 static void kvm_s390_sync_request_broadcast(struct kvm *kvm, int req)
 {
 	int cx;
@@ -3288,6 +3329,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 
 	kvm_s390_vcpu_crypto_setup(vcpu);
 
+	kvm_s390_vcpu_pci_setup(vcpu);
+
 	mutex_lock(&vcpu->kvm->lock);
 	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
 		rc = kvm_s390_pv_create_cpu(vcpu, &uvrc, &uvrrc);
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index c07a050d757d..a2eccb8b977e 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -481,6 +481,16 @@ void kvm_s390_reinject_machine_check(struct kvm_vcpu *vcpu,
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
2.27.0

