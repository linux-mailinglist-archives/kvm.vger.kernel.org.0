Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717C15637B7
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 18:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbiGAQVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 12:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231909AbiGAQVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 12:21:39 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56CF3F33D;
        Fri,  1 Jul 2022 09:21:38 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 261F8q0T021734;
        Fri, 1 Jul 2022 16:21:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5JF6AL+4EBIUqA2TpFmYJYvKzaNL5oQBYsGCpOpSFqE=;
 b=k9yBsLGPtjcUevCHBcyoyd/5jbjkCO9ScQ6aEx8lMWxx4F03kQEE1oOro2sRjkIlvezY
 cyEx01bkQ2wFy+6iG4C6/z308F92cNV83j6cGVDMMDA/3nJpxDgzgQmFLMupGllUPRcY
 9/yq/bHohTduFDwmewJMY+4mwg+TbUpC9XeOao0RcdR8qnP+RHJOze0SDAki+K35zrXX
 8Iv8nsWNbEnQgJuUvk5VJaXDD7hUZxEdAi2Gd/6Jk/bErqhTCAv/MY+wDaePUKZkoXzv
 FN4O15GEwHw1vYR+r7W1yjZ8fCWubQ5EYgN8sAizFEmr/lplTsgj4Uq8UOTGn6i0f0rm PQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h2329k68h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 16:21:38 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 261FsOZi037834;
        Fri, 1 Jul 2022 16:21:37 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h2329k677-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 16:21:37 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 261G7AnY002534;
        Fri, 1 Jul 2022 16:21:35 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3gwsmhyev0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Jul 2022 16:21:35 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 261GLWuO14746048
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Jul 2022 16:21:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1A23A4054;
        Fri,  1 Jul 2022 16:21:31 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 345D0A405B;
        Fri,  1 Jul 2022 16:21:31 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.92.56])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Jul 2022 16:21:31 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com
Subject: [PATCH v11 2/3] KVM: s390: guest support for topology function
Date:   Fri,  1 Jul 2022 18:25:58 +0200
Message-Id: <20220701162559.158313-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220701162559.158313-1-pmorel@linux.ibm.com>
References: <20220701162559.158313-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rrfB9Sa9WvnP9e8TJ4NE9xk0ER7yYiRd
X-Proofpoint-ORIG-GUID: trDVw3xyQ5Vx77KS6uMtRWKoQS8wXWjg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-01_08,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 spamscore=0 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2207010064
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
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 18 +++++++++++++---
 arch/s390/kvm/kvm-s390.c         | 36 ++++++++++++++++++++++++++++++++
 arch/s390/kvm/priv.c             | 16 ++++++++++----
 arch/s390/kvm/vsie.c             |  8 +++++++
 4 files changed, 71 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 766028d54a3e..ae6bd3d607de 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -93,19 +93,30 @@ union ipte_control {
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
 
@@ -249,6 +260,7 @@ struct kvm_s390_sie_block {
 #define ECB_SPECI	0x08
 #define ECB_SRSI	0x04
 #define ECB_HOSTPROTINT	0x02
+#define ECB_PTF		0x01
 	__u8	ecb;			/* 0x0061 */
 #define ECB2_CMMA	0x80
 #define ECB2_IEP	0x20
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8fcb56141689..ee59b03f2e45 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1691,6 +1691,31 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
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
+	struct bsca_block *sca = kvm->arch.sca;
+	union sca_utility new, old;
+
+	read_lock(&kvm->arch.sca_lock);
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
@@ -2877,6 +2902,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_clear_async_pf_completion_queue(vcpu);
 	if (!kvm_is_ucontrol(vcpu->kvm))
 		sca_del_vcpu(vcpu);
+	kvm_s390_update_topology_change_report(vcpu->kvm, 1);
 
 	if (kvm_is_ucontrol(vcpu->kvm))
 		gmap_remove(vcpu->arch.gmap);
@@ -3272,6 +3298,14 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 		vcpu->arch.sie_block->ecb |= ECB_HOSTPROTINT;
 	if (test_kvm_facility(vcpu->kvm, 9))
 		vcpu->arch.sie_block->ecb |= ECB_SRSI;
+	/*
+	 * CPU Topology
+	 * This facility only uses the utility field of the SCA and none
+	 * of the cpu entries that are problematic with the other
+	 * interpretation facilities so we can pass it through.
+	 */
+	if (test_kvm_facility(vcpu->kvm, 11))
+		vcpu->arch.sie_block->ecb |= ECB_PTF;
 	if (test_kvm_facility(vcpu->kvm, 73))
 		vcpu->arch.sie_block->ecb |= ECB_TE;
 	if (!kvm_is_ucontrol(vcpu->kvm))
@@ -3403,6 +3437,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	rc = kvm_s390_vcpu_setup(vcpu);
 	if (rc)
 		goto out_ucontrol_uninit;
+
+	kvm_s390_update_topology_change_report(vcpu->kvm, 1);
 	return 0;
 
 out_ucontrol_uninit:
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 12c464c7cddf..046afee1be94 100644
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
+	if (fc > 3 && (fc != 15 || kvm_s390_pv_cpu_is_protected(vcpu)))
+		goto out_no_data;
+
+	/* fc 15 is provided with PTF/CPU topology support */
+	if (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))
+		goto out_no_data;
 
 	if (vcpu->run->s.regs.gprs[0] & 0x0fffff00
 	    || vcpu->run->s.regs.gprs[1] & 0xffff0000)
@@ -910,6 +913,11 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 			goto out_no_data;
 		handle_stsi_3_2_2(vcpu, (void *) mem);
 		break;
+	case 15: /* fc 15 is fully handled in userspace */
+		if (vcpu->kvm->arch.user_stsi)
+			insert_stsi_usr_data(vcpu, operand2, ar, fc, sel1, sel2);
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
2.31.1

