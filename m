Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE3D5109B0
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 22:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354601AbiDZUNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 16:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354621AbiDZUNG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 16:13:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6AD175F82;
        Tue, 26 Apr 2022 13:09:56 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QK4LGg028971;
        Tue, 26 Apr 2022 20:09:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MC7onq6vngrk+v4cFynF2//njZz2Ft69oISr7epR3/s=;
 b=C34LzsGqCi3S9+SdTKZFhKQRUzncjklhFDkUhiCVs45sYcg5WLDxGlPaddcG1hPD6e0t
 Yjdk8amL39rTmiXzfJgOemCiAXzeSz85Wj82etN+h5BgiKUmpz8zhjI8iZ/e+tQ9JnWn
 Mxcyk/oXLyEJBD0U9iA6Ho0vcvbqXAZVGzQ6dzNTZN1BGlcZLnWsxQYGegB8f/yp8Ej3
 w+FYjEbjv88hqqyGNhD8r/D/Veb4oGw8ErwsPAdxzq2wgstLZ600v22eCneb+fSatwVj
 RKJJ5W6Bp4KZczs3mNGMavHowHUnUxZF5OEz3qoVcxRv+C0if3MTGBilVpIaljF2iLV1 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpgn81whu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:09:54 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23QK61jg001180;
        Tue, 26 Apr 2022 20:09:54 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpgn81whp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:09:54 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23QK8Oek001213;
        Tue, 26 Apr 2022 20:09:53 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 3fm93anad9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 20:09:53 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23QK9qfX26280304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 20:09:52 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DD26B2068;
        Tue, 26 Apr 2022 20:09:52 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4845B205F;
        Tue, 26 Apr 2022 20:09:48 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.73.42])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 26 Apr 2022 20:09:48 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v6 13/21] KVM: s390: mechanism to enable guest zPCI Interpretation
Date:   Tue, 26 Apr 2022 16:08:34 -0400
Message-Id: <20220426200842.98655-14-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220426200842.98655-1-mjrosato@linux.ibm.com>
References: <20220426200842.98655-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oHz6bOC4wL_Q2YplcwqvdxfQ5st6ltMm
X-Proofpoint-ORIG-GUID: DrNFthrJ7oFZbtX9UHjygbU5gJN1aM3v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_06,2022-04-26_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204260127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest must have access to certain facilities in order to allow
interpretive execution of zPCI instructions and adapter event
notifications.  However, there are some cases where a guest might
disable interpretation -- provide a mechanism via which we can defer
enabling the associated zPCI interpretation facilities until the guest
indicates it wishes to use them.

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  4 ++++
 arch/s390/kvm/kvm-s390.c         | 37 ++++++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h         | 10 +++++++++
 3 files changed, 51 insertions(+)

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
index 856f55ffd98c..504f312c1c27 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1031,6 +1031,41 @@ static int kvm_s390_vm_set_crypto(struct kvm *kvm, struct kvm_device_attr *attr)
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
+/* Must be called with kvm->lock held */
+void kvm_s390_vcpu_pci_enable_interp(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+
+	/*
+	 * If host is configured for PCI and the necessary facilities are
+	 * available, turn on interpretation for the life of this guest
+	 */
+	if (!kvm_s390_pci_interp_allowed())
+		return;
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
+}
+
 static void kvm_s390_sync_request_broadcast(struct kvm *kvm, int req)
 {
 	unsigned long cx;
@@ -3331,6 +3366,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 
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
2.27.0

