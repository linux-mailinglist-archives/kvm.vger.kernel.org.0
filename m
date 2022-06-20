Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBC2551955
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 14:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiFTMu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 08:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241653AbiFTMuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 08:50:24 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6F613E2C;
        Mon, 20 Jun 2022 05:50:23 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KC0to6016865;
        Mon, 20 Jun 2022 12:50:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=k0pJJB4jppyzlH2e+ddq8FYKh47CY3QjoO+NSQKnZ2g=;
 b=Y1QkvmhkVdDXaVu+JWreWbQ7jwQY/JTCfcNEeF/H6VX1xZ//huwa+762f8aYzvJBUo+f
 y/RnVWrO/8EFco1bzuDq3yFu7wnu6Er8rHCz45cIBdfExkWgFUj26L9R94DST0Tw+BuG
 BOo4k9LMnT0l9WMxQ9nfLlP7VS34a33DvuqpA6biKvKzeBrSGDt8JErTMjoPBCG1ZUAl
 6dXQBQJMgXElcQ77InnJajYWrmAo5bJ4ifjdTCyWKrGs2Hr9KuoFJEnITrx/W1BzGykG
 MYfLT3CwMsibexp9cYSd3vp2QP83O6fds6tmyJ2cYyUyhH55JTZLGYaaOXrPBQ+31Iml sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrqt8v8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 12:50:23 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25KCmG1w015750;
        Mon, 20 Jun 2022 12:50:22 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrqt8v7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 12:50:22 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25KCYpHK024818;
        Mon, 20 Jun 2022 12:50:21 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3gs6b91yw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 12:50:20 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25KCoHl821496120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jun 2022 12:50:17 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0381A4057;
        Mon, 20 Jun 2022 12:50:17 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11D56A4051;
        Mon, 20 Jun 2022 12:50:17 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.62.140])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jun 2022 12:50:16 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v10 2/3] KVM: s390: guest support for topology function
Date:   Mon, 20 Jun 2022 14:54:36 +0200
Message-Id: <20220620125437.37122-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220620125437.37122-1-pmorel@linux.ibm.com>
References: <20220620125437.37122-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pzznXqVcSflseGZk6HLlXNV94PenBWjG
X-Proofpoint-ORIG-GUID: 52EwdNP6EJoXnj0LKDgO3EIYyNz1pPK5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 mlxscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206200059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We report a topology change to the guest for any CPU hotplug.

The reporting to the guest is done using the Multiprocessor
Topology-Change-Report (MTCR) bit of the utility entry in the guest's
SCA which will be cleared during the interpretation of PTF.

On every vCPU creation we set the MCTR bit to let the guest know the
next time he uses the PTF with command 2 instruction that the
topology changed and that he should use the STSI(15.1.x) instruction
to get the topology details.

STSI(15.1.x) gives information on the CPU configuration topology.
Let's accept the interception of STSI with the function code 15 and
let the userland part of the hypervisor handle it when userland
support the CPU Topology facility.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 11 ++++++++---
 arch/s390/kvm/kvm-s390.c         | 27 ++++++++++++++++++++++++++-
 arch/s390/kvm/priv.c             | 15 +++++++++++----
 arch/s390/kvm/vsie.c             |  3 +++
 4 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 766028d54a3e..bb54196d4ed6 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -97,15 +97,19 @@ struct bsca_block {
 	union ipte_control ipte_control;
 	__u64	reserved[5];
 	__u64	mcn;
-	__u64	reserved2;
+#define SCA_UTILITY_MTCR	0x8000
+	__u16	utility;
+	__u8	reserved2[6];
 	struct bsca_entry cpu[KVM_S390_BSCA_CPU_SLOTS];
 };
 
 struct esca_block {
 	union ipte_control ipte_control;
-	__u64   reserved1[7];
+	__u64   reserved1[6];
+	__u16	utility;
+	__u8	reserved2[6];
 	__u64   mcn[4];
-	__u64   reserved2[20];
+	__u64   reserved3[20];
 	struct esca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];
 };
 
@@ -249,6 +253,7 @@ struct kvm_s390_sie_block {
 #define ECB_SPECI	0x08
 #define ECB_SRSI	0x04
 #define ECB_HOSTPROTINT	0x02
+#define ECB_PTF		0x01
 	__u8	ecb;			/* 0x0061 */
 #define ECB2_CMMA	0x80
 #define ECB2_IEP	0x20
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8fcb56141689..95b96019ca8e 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1691,6 +1691,25 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
 	return ret;
 }
 
+/**
+ * kvm_s390_sca_set_mtcr
+ * @kvm: guest KVM description
+ *
+ * Is only relevant if the topology facility is present,
+ * the caller should check KVM facility 11
+ *
+ * Updates the Multiprocessor Topology-Change-Report to signal
+ * the guest with a topology change.
+ */
+static void kvm_s390_sca_set_mtcr(struct kvm *kvm)
+{
+	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
+
+	ipte_lock(kvm);
+	sca->utility |= SCA_UTILITY_MTCR;
+	ipte_unlock(kvm);
+}
+
 static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	int ret;
@@ -3143,7 +3162,6 @@ __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-
 	gmap_enable(vcpu->arch.enabled_gmap);
 	kvm_s390_set_cpuflags(vcpu, CPUSTAT_RUNNING);
 	if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
@@ -3272,6 +3290,11 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 		vcpu->arch.sie_block->ecb |= ECB_HOSTPROTINT;
 	if (test_kvm_facility(vcpu->kvm, 9))
 		vcpu->arch.sie_block->ecb |= ECB_SRSI;
+
+	/* PTF needs guest facilities to enable interpretation */
+	if (test_kvm_facility(vcpu->kvm, 11))
+		vcpu->arch.sie_block->ecb |= ECB_PTF;
+
 	if (test_kvm_facility(vcpu->kvm, 73))
 		vcpu->arch.sie_block->ecb |= ECB_TE;
 	if (!kvm_is_ucontrol(vcpu->kvm))
@@ -3403,6 +3426,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	rc = kvm_s390_vcpu_setup(vcpu);
 	if (rc)
 		goto out_ucontrol_uninit;
+
+	kvm_s390_sca_set_mtcr(vcpu->kvm);
 	return 0;
 
 out_ucontrol_uninit:
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 12c464c7cddf..77a692238585 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -873,10 +873,13 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
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
+	/* fc 15 is provided with PTF/CPU topology support */
+	if (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))
+		goto out_no_data;
 
 	if (vcpu->run->s.regs.gprs[0] & 0x0fffff00
 	    || vcpu->run->s.regs.gprs[1] & 0xffff0000)
@@ -910,6 +913,10 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 			goto out_no_data;
 		handle_stsi_3_2_2(vcpu, (void *) mem);
 		break;
+	case 15:
+		trace_kvm_s390_handle_stsi(vcpu, fc, sel1, sel2, operand2);
+		insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
+		return -EREMOTE;
 	}
 	if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 		memcpy((void *)sida_origin(vcpu->arch.sie_block), (void *)mem,
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index dada78b92691..4f4fee697550 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -503,6 +503,9 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	/* Host-protection-interruption introduced with ESOP */
 	if (test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_ESOP))
 		scb_s->ecb |= scb_o->ecb & ECB_HOSTPROTINT;
+	/* CPU Topology */
+	if (test_kvm_facility(vcpu->kvm, 11))
+		scb_s->ecb |= scb_o->ecb & ECB_PTF;
 	/* transactional execution */
 	if (test_kvm_facility(vcpu->kvm, 73) && wants_tx) {
 		/* remap the prefix is tx is toggled on */
-- 
2.31.1

