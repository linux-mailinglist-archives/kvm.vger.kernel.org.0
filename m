Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DBA4F1B90
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380156AbiDDVVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379663AbiDDRq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 13:46:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C37817077;
        Mon,  4 Apr 2022 10:44:30 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234GXR7Q002493;
        Mon, 4 Apr 2022 17:44:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Gy1yl0bL6hxrWlYqP6IhnqV6LjI7MGPXuF4DqxDIgrk=;
 b=iy1g/XLfPxpmWa+doJPgwDDaRfVATrx2Ef9Ew/DcdnwIvOhOOBi1QLG+WucoAvnUXUuF
 EdAsvmABhkKneHCbPVPZXwmL3f7k4K/niv8PH/+fyCxDchXInK22fYFrvhfPiHQSuj0y
 fMAUcc53p+x90KVOhKqN6dlCNezgtm3yGyJiipVUKz809YaEIt3faGTe09wVyFNVtS1B
 eE/WoL2bafQT2VuTCEI5rAxQIdh1uzbSJlLewaEy7aTPgSw+F2lI0lxYveBUjv7hyi8i
 E8r3Qh8yqJPvq2EsoFG8S/ljgHZhySD2ZGyZI1vQ6VAmsB8gMW6fZUZ/beJ40d+W8v+6 vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f6yv6c95g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:44:28 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234HEgtk030568;
        Mon, 4 Apr 2022 17:44:28 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f6yv6c954-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:44:28 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234Hh3vA002370;
        Mon, 4 Apr 2022 17:44:27 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03wdc.us.ibm.com with ESMTP id 3f6e48s694-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:44:27 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234HiQH112124488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 17:44:26 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9691D136053;
        Mon,  4 Apr 2022 17:44:26 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8960C136060;
        Mon,  4 Apr 2022 17:44:24 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.125])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 17:44:24 +0000 (GMT)
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
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v5 13/21] KVM: s390: mechanism to enable guest zPCI Interpretation
Date:   Mon,  4 Apr 2022 13:43:41 -0400
Message-Id: <20220404174349.58530-14-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220404174349.58530-1-mjrosato@linux.ibm.com>
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LzANiZft-v5hrapsiHNwB1866GrR3nZ_
X-Proofpoint-GUID: knmzdSR7GD2EfFBEqxWdlxSzUpt2Jz9q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_06,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 suspectscore=0 phishscore=0 adultscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 impostorscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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

Acked-by: Pierre Morel <pmorel@linux.ibm.com>
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
index a9eb8b75af93..327649ddddce 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1029,6 +1029,41 @@ static int kvm_s390_vm_set_crypto(struct kvm *kvm, struct kvm_device_attr *attr)
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
@@ -3329,6 +3364,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 
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

