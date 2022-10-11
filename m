Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF325FB7EB
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 18:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiJKQHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 12:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiJKQHU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 12:07:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770AF5209F
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 09:07:19 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BFqmLB016376
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 16:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=BAPOnUVR0d/ukEvtYA74W2CDndmqimfvjEXx5aqDiS0=;
 b=RU4ku9EJFCDlQ+jLCuREDikugS+KKkuKjGu9rk6nTJoO/kLkPgGbKTQzJptzTdTxYSA8
 kBTkuLru/mNvoMcANpkmvxmh5Ubmbg40SOxHYoYgCMeFotlZfHAGzPpzuoNQQ0n8X2Bo
 JiA6jhve+v8PLL+cJoUJl36ne41R4bp2nn17jyHbxY9fPcxzq8TQkmdAlINoEFSyV62S
 csgKgtv2DFoI7ekW6QLrAJTWiaEgdiKaxszuCORklT3AoJRznXZeAaOcA3ehpRaSLIYB
 LS+sxn43YTN9k3+MzYzSpR66l4HlhGh745p4y6W20KTiTu47BusXbk3NReKo1bNE3lLU YQ== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3k590dep48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 16:07:18 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29BG5ej8000902
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 16:07:16 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3k30u9bhva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 16:07:16 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29BG7iTg53084646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Oct 2022 16:07:44 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DBDDA4054;
        Tue, 11 Oct 2022 16:07:13 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29906A405F;
        Tue, 11 Oct 2022 16:07:13 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Oct 2022 16:07:13 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: [PATCH v4 1/1] KVM: s390: pv: don't allow userspace to set the clock under PV
Date:   Tue, 11 Oct 2022 18:07:12 +0200
Message-Id: <20221011160712.928239-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221011160712.928239-1-nrb@linux.ibm.com>
References: <20221011160712.928239-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: biZnk9JDVde3REPKonOtjv1RnFZxTlIU
X-Proofpoint-ORIG-GUID: biZnk9JDVde3REPKonOtjv1RnFZxTlIU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_08,2022-10-11_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 bulkscore=0 impostorscore=0 spamscore=0 clxscore=1015 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210110092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running under PV, the guest's TOD clock is under control of the
ultravisor and the hypervisor isn't allowed to change it. Hence, don't
allow userspace to change the guest's TOD clock by returning
-EOPNOTSUPP.

When userspace changes the guest's TOD clock, KVM updates its
kvm.arch.epoch field and, in addition, the epoch field in all state
descriptions of all VCPUs.

But, under PV, the ultravisor will ignore the epoch field in the state
description and simply overwrite it on next SIE exit with the actual
guest epoch. This leads to KVM having an incorrect view of the guest's
TOD clock: it has updated its internal kvm.arch.epoch field, but the
ultravisor ignores the field in the state description.

Whenever a guest is now waiting for a clock comparator, KVM will
incorrectly calculate the time when the guest should wake up, possibly
causing the guest to sleep for much longer than expected.

With this change, kvm_s390_set_tod() will now take the kvm->lock to be
able to call kvm_s390_pv_is_protected(). Since kvm_s390_set_tod_clock()
also takes kvm->lock, use __kvm_s390_set_tod_clock() instead.

The function kvm_s390_set_tod_clock is now unused, hence remove it.
Update the documentation to indicate the TOD clock attr calls can now
return -EOPNOTSUPP.

Fixes: 0f3035047140 ("KVM: s390: protvirt: Do only reset registers that are accessible")
Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 Documentation/virt/kvm/devices/vm.rst |  3 +++
 arch/s390/kvm/kvm-s390.c              | 26 +++++++++++++++++---------
 arch/s390/kvm/kvm-s390.h              |  1 -
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
index 0aa5b1cfd700..60acc39e0e93 100644
--- a/Documentation/virt/kvm/devices/vm.rst
+++ b/Documentation/virt/kvm/devices/vm.rst
@@ -215,6 +215,7 @@ KVM_S390_VM_TOD_EXT).
 :Parameters: address of a buffer in user space to store the data (u8) to
 :Returns:   -EFAULT if the given address is not accessible from kernel space;
 	    -EINVAL if setting the TOD clock extension to != 0 is not supported
+	    -EOPNOTSUPP for a PV guest (TOD managed by the ultravisor)
 
 3.2. ATTRIBUTE: KVM_S390_VM_TOD_LOW
 -----------------------------------
@@ -224,6 +225,7 @@ the POP (u64).
 
 :Parameters: address of a buffer in user space to store the data (u64) to
 :Returns:    -EFAULT if the given address is not accessible from kernel space
+	     -EOPNOTSUPP for a PV guest (TOD managed by the ultravisor)
 
 3.3. ATTRIBUTE: KVM_S390_VM_TOD_EXT
 -----------------------------------
@@ -237,6 +239,7 @@ it, it is stored as 0 and not allowed to be set to a value != 0.
 	     (kvm_s390_vm_tod_clock) to
 :Returns:   -EFAULT if the given address is not accessible from kernel space;
 	    -EINVAL if setting the TOD clock extension to != 0 is not supported
+	    -EOPNOTSUPP for a PV guest (TOD managed by the ultravisor)
 
 4. GROUP: KVM_S390_VM_CRYPTO
 ============================
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index b7ef0b71014d..2486281027c0 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1207,6 +1207,8 @@ static int kvm_s390_vm_get_migration(struct kvm *kvm,
 	return 0;
 }
 
+static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
+
 static int kvm_s390_set_tod_ext(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	struct kvm_s390_vm_tod_clock gtod;
@@ -1216,7 +1218,7 @@ static int kvm_s390_set_tod_ext(struct kvm *kvm, struct kvm_device_attr *attr)
 
 	if (!test_kvm_facility(kvm, 139) && gtod.epoch_idx)
 		return -EINVAL;
-	kvm_s390_set_tod_clock(kvm, &gtod);
+	__kvm_s390_set_tod_clock(kvm, &gtod);
 
 	VM_EVENT(kvm, 3, "SET: TOD extension: 0x%x, TOD base: 0x%llx",
 		gtod.epoch_idx, gtod.tod);
@@ -1247,7 +1249,7 @@ static int kvm_s390_set_tod_low(struct kvm *kvm, struct kvm_device_attr *attr)
 			   sizeof(gtod.tod)))
 		return -EFAULT;
 
-	kvm_s390_set_tod_clock(kvm, &gtod);
+	__kvm_s390_set_tod_clock(kvm, &gtod);
 	VM_EVENT(kvm, 3, "SET: TOD base: 0x%llx", gtod.tod);
 	return 0;
 }
@@ -1259,6 +1261,16 @@ static int kvm_s390_set_tod(struct kvm *kvm, struct kvm_device_attr *attr)
 	if (attr->flags)
 		return -EINVAL;
 
+	mutex_lock(&kvm->lock);
+	/*
+	 * For protected guests, the TOD is managed by the ultravisor, so trying
+	 * to change it will never bring the expected results.
+	 */
+	if (kvm_s390_pv_is_protected(kvm)) {
+		ret = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
 	switch (attr->attr) {
 	case KVM_S390_VM_TOD_EXT:
 		ret = kvm_s390_set_tod_ext(kvm, attr);
@@ -1273,6 +1285,9 @@ static int kvm_s390_set_tod(struct kvm *kvm, struct kvm_device_attr *attr)
 		ret = -ENXIO;
 		break;
 	}
+
+out_unlock:
+	mutex_unlock(&kvm->lock);
 	return ret;
 }
 
@@ -4379,13 +4394,6 @@ static void __kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_t
 	preempt_enable();
 }
 
-void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
-{
-	mutex_lock(&kvm->lock);
-	__kvm_s390_set_tod_clock(kvm, gtod);
-	mutex_unlock(&kvm->lock);
-}
-
 int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod)
 {
 	if (!mutex_trylock(&kvm->lock))
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index f6fd668f887e..4755492dfabc 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -363,7 +363,6 @@ int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
 int kvm_s390_handle_sigp_pei(struct kvm_vcpu *vcpu);
 
 /* implemented in kvm-s390.c */
-void kvm_s390_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
 int kvm_s390_try_set_tod_clock(struct kvm *kvm, const struct kvm_s390_vm_tod_clock *gtod);
 long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable);
 int kvm_s390_store_status_unloaded(struct kvm_vcpu *vcpu, unsigned long addr);
-- 
2.36.1

