Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8EE457D127
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbiGUQOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbiGUQOO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:14:14 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D8E88F34;
        Thu, 21 Jul 2022 09:14:05 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFrtrc005962;
        Thu, 21 Jul 2022 16:13:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=lbGlh/e2HFlIiLws6f9yHk5PqhE/c7Z8IoUy9OBsPzQ=;
 b=mkA0NhxxdL6f7rn5GIU+Q7a/HQ6NTkTj54noqgXaL/uDNmuZBBRLro9ANNrbGShvEbfu
 02aR1EgIP/HHpbrhSG6kq9BW4LfsZrdk7XVmsvTPrgNl7gOQtHSN6SMEgPeQov+eaOaT
 +17U1W4PhejpPzpq4rGUqrwt+UWNzEU0WjH1kU+Dqcw17qWnacSBFwYvLGGDnU6Yiy1H
 rFoK8nOulML/3AmKkGLDKBVb9QpV6XRxvKjUR7GZFHfFWu+c7E5MLMEcQ+RohMJuZ4zZ
 +UqdcYh2Ikz6tP5jyM/h4pAgXniN8j+RRhZxfXzebRu2+w5HzyoJ6kvA+7a54FnchIJv Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9um8fkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:35 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LFrwvf006078;
        Thu, 21 Jul 2022 16:13:35 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9um8fj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:35 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG7BnD012458;
        Thu, 21 Jul 2022 16:13:33 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3hbmy8y9d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:32 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGDTG516974256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:13:29 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BBECA4054;
        Thu, 21 Jul 2022 16:13:29 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2542A405B;
        Thu, 21 Jul 2022 16:13:28 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:28 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com,
        Pierre Morel <pmorel@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [GIT PULL 41/42] KVM: s390: guest support for topology function
Date:   Thu, 21 Jul 2022 18:13:01 +0200
Message-Id: <20220721161302.156182-42-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QgtC1IbjT6rta_G6uxPQqYblb7-OMa6t
X-Proofpoint-GUID: x_NP_DC5VCt2daq-1IvJHuY1VwoloX3g
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

We report a topology change to the guest for any CPU hotplug.

The reporting to the guest is done using the Multiprocessor
Topology-Change-Report (MTCR) bit of the utility entry in the guest's
SCA which will be cleared during the interpretation of PTF.

On every vCPU creation we set the MCTR bit to let the guest know the
next time it uses the PTF with command 2 instruction that the
topology changed and that it should use the STSI(15.1.x) instruction
to get the topology details.

STSI(15.1.x) gives information on the CPU configuration topology.
Let's accept the interception of STSI with the function code 15 and
let the userland part of the hypervisor handle it when userland
supports the CPU Topology facility.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20220714101824.101601-2-pmorel@linux.ibm.com
Message-Id: <20220714101824.101601-2-pmorel@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 18 +++++++++++++++---
 arch/s390/kvm/kvm-s390.c         | 31 +++++++++++++++++++++++++++++++
 arch/s390/kvm/priv.c             | 20 ++++++++++++++++----
 arch/s390/kvm/vsie.c             |  8 ++++++++
 4 files changed, 70 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 6f9fc8bb0303..f39092e0ceaa 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -95,19 +95,30 @@ union ipte_control {
 	};
 };
 
+union sca_utility {
+	__u16 val;
+	struct {
+		__u16 mtcr : 1;
+		__u16 reserved : 15;
+	};
+};
+
 struct bsca_block {
 	union ipte_control ipte_control;
 	__u64	reserved[5];
 	__u64	mcn;
-	__u64	reserved2;
+	union sca_utility utility;
+	__u8	reserved2[6];
 	struct bsca_entry cpu[KVM_S390_BSCA_CPU_SLOTS];
 };
 
 struct esca_block {
 	union ipte_control ipte_control;
-	__u64   reserved1[7];
+	__u64   reserved1[6];
+	union sca_utility utility;
+	__u8	reserved2[6];
 	__u64   mcn[4];
-	__u64   reserved2[20];
+	__u64   reserved3[20];
 	struct esca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];
 };
 
@@ -251,6 +262,7 @@ struct kvm_s390_sie_block {
 #define ECB_SPECI	0x08
 #define ECB_SRSI	0x04
 #define ECB_HOSTPROTINT	0x02
+#define ECB_PTF		0x01
 	__u8	ecb;			/* 0x0061 */
 #define ECB2_CMMA	0x80
 #define ECB2_IEP	0x20
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 5b77c43fbb01..5d18b66a08c9 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1763,6 +1763,32 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
 	return ret;
 }
 
+/**
+ * kvm_s390_update_topology_change_report - update CPU topology change report
+ * @kvm: guest KVM description
+ * @val: set or clear the MTCR bit
+ *
+ * Updates the Multiprocessor Topology-Change-Report bit to signal
+ * the guest with a topology change.
+ * This is only relevant if the topology facility is present.
+ *
+ * The SCA version, bsca or esca, doesn't matter as offset is the same.
+ */
+static void kvm_s390_update_topology_change_report(struct kvm *kvm, bool val)
+{
+	union sca_utility new, old;
+	struct bsca_block *sca;
+
+	read_lock(&kvm->arch.sca_lock);
+	sca = kvm->arch.sca;
+	do {
+		old = READ_ONCE(sca->utility);
+		new = old;
+		new.mtcr = val;
+	} while (cmpxchg(&sca->utility.val, old.val, new.val) != old.val);
+	read_unlock(&kvm->arch.sca_lock);
+}
+
 static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	int ret;
@@ -3172,6 +3198,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_clear_async_pf_completion_queue(vcpu);
 	if (!kvm_is_ucontrol(vcpu->kvm))
 		sca_del_vcpu(vcpu);
+	kvm_s390_update_topology_change_report(vcpu->kvm, 1);
 
 	if (kvm_is_ucontrol(vcpu->kvm))
 		gmap_remove(vcpu->arch.gmap);
@@ -3574,6 +3601,8 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 		vcpu->arch.sie_block->ecb |= ECB_HOSTPROTINT;
 	if (test_kvm_facility(vcpu->kvm, 9))
 		vcpu->arch.sie_block->ecb |= ECB_SRSI;
+	if (test_kvm_facility(vcpu->kvm, 11))
+		vcpu->arch.sie_block->ecb |= ECB_PTF;
 	if (test_kvm_facility(vcpu->kvm, 73))
 		vcpu->arch.sie_block->ecb |= ECB_TE;
 	if (!kvm_is_ucontrol(vcpu->kvm))
@@ -3707,6 +3736,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	rc = kvm_s390_vcpu_setup(vcpu);
 	if (rc)
 		goto out_ucontrol_uninit;
+
+	kvm_s390_update_topology_change_report(vcpu->kvm, 1);
 	return 0;
 
 out_ucontrol_uninit:
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 12c464c7cddf..3335fa09b6f1 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -873,10 +873,18 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 
-	if (fc > 3) {
-		kvm_s390_set_psw_cc(vcpu, 3);
-		return 0;
-	}
+	/* Bailout forbidden function codes */
+	if (fc > 3 && fc != 15)
+		goto out_no_data;
+
+	/*
+	 * fc 15 is provided only with
+	 *   - PTF/CPU topology support through facility 15
+	 *   - KVM_CAP_S390_USER_STSI
+	 */
+	if (fc == 15 && (!test_kvm_facility(vcpu->kvm, 11) ||
+			 !vcpu->kvm->arch.user_stsi))
+		goto out_no_data;
 
 	if (vcpu->run->s.regs.gprs[0] & 0x0fffff00
 	    || vcpu->run->s.regs.gprs[1] & 0xffff0000)
@@ -910,6 +918,10 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 			goto out_no_data;
 		handle_stsi_3_2_2(vcpu, (void *) mem);
 		break;
+	case 15: /* fc 15 is fully handled in userspace */
+		insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
+		trace_kvm_s390_handle_stsi(vcpu, fc, sel1, sel2, operand2);
+		return -EREMOTE;
 	}
 	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 		memcpy((void *)sida_origin(vcpu->arch.sie_block), (void *)mem,
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index dada78b92691..94138f8f0c1c 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -503,6 +503,14 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	/* Host-protection-interruption introduced with ESOP */
 	if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_ESOP))
 		scb_s->ecb |= scb_o->ecb & ECB_HOSTPROTINT;
+	/*
+	 * CPU Topology
+	 * This facility only uses the utility field of the SCA and none of
+	 * the cpu entries that are problematic with the other interpretation
+	 * facilities so we can pass it through
+	 */
+	if (test_kvm_facility(vcpu->kvm, 11))
+		scb_s->ecb |= scb_o->ecb & ECB_PTF;
 	/* transactional execution */
 	if (test_kvm_facility(vcpu->kvm, 73) && wants_tx) {
 		/* remap the prefix is tx is toggled on */
-- 
2.36.1

