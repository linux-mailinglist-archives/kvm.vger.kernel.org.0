Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B3F48F13F
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244383AbiANUcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:32:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13730 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244531AbiANUca (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:32:30 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EIQYdj014116;
        Fri, 14 Jan 2022 20:32:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MKoIVn31QV9TkKgvw3aUOwQChKaA4pHeHa0Th31+6vQ=;
 b=mY+2DMw3skwPUE6imlv5H9TslMeZCqari845NxTC3jm1xH+MFNnBXTrRHQIkFVQe7mbt
 hcS9vaGjb+IxaVLJZujMl5vxMECeG79HykocQWWFrcqnnGePy7caCqO9j57XW9tOvO/d
 dk25gQrZ3MevMvywVShD9aDrlRlFT5RuLf6HEK0bxR7MkeAMkLgxzFoibvUDZi5+FasB
 xN5fOaaerbOqll3CkmCw6p/yPjD5CQBYgU4I1YNcH+Wk1qzoTESLhDHamTifjZykxiSr
 0wYzXyo0/SahuM30aSB41ST5pEB0hGr6Gj4i6mPDCwbIX/l5G/jkfCwjE7fG7M/CY3hm eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkef5a924-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:29 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EJVMDC011482;
        Fri, 14 Jan 2022 20:32:29 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkef5a91p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:29 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKMZPZ018433;
        Fri, 14 Jan 2022 20:32:27 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02wdc.us.ibm.com with ESMTP id 3df28cqdm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:27 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKWOQe13304506
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:32:24 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 803AEC606E;
        Fri, 14 Jan 2022 20:32:24 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B62D0C6069;
        Fri, 14 Jan 2022 20:32:22 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:32:22 +0000 (GMT)
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
Subject: [PATCH v2 17/30] KVM: s390: mechanism to enable guest zPCI Interpretation
Date:   Fri, 14 Jan 2022 15:31:32 -0500
Message-Id: <20220114203145.242984-18-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203145.242984-1-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WCyBnLqxd0aIqBc44buPfCPbHvC-iSK6
X-Proofpoint-ORIG-GUID: PfLe0w5WcJLiCpCzA5DtRkMOG1SVbG35
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
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
 arch/s390/include/asm/kvm_host.h |  4 ++++
 arch/s390/kvm/kvm-s390.c         | 40 ++++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h         | 10 ++++++++
 3 files changed, 54 insertions(+)

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
index ab8b56deed11..b6c32fc3b272 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1029,6 +1029,44 @@ static int kvm_s390_vm_set_crypto(struct kvm *kvm, struct kvm_device_attr *attr)
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
+	int i;
+
+	/*
+	 * If host is configured for PCI and the necessary facilities are
+	 * available, turn on interpretation for the life of this guest
+	 */
+	if (!IS_ENABLED(CONFIG_PCI) || !sclp.has_zpci_lsi || !sclp.has_aisii ||
+	    !sclp.has_aeni || !sclp.has_aisi)
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
@@ -3282,6 +3320,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 
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

