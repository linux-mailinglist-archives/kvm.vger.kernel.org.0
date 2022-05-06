Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18AC51D440
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 11:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390449AbiEFJYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 05:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347361AbiEFJYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 05:24:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E4264718;
        Fri,  6 May 2022 02:20:37 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2467mLrg030987;
        Fri, 6 May 2022 09:20:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XwaLKDaGghh+OFdZyPXTdtaaKdWHqxP7bxBiKOkQvq8=;
 b=rdNNAFEorpc/WoKJfflX/WUTwTAVv9P8UmkOxeFK4W4bHN5ddDQO9P+fmVToNfR8nOBD
 zq3veQ0lYoM8wQO1aw1CG5q6L//lVSzpS3/MJqDdJ5IET/fwcysn+YJcoMnYKQaKZeJF
 a9pkZN0C6pdOPT0WrLhuVr+yXRS5Lf4FqXWvhNRHUXJY/H3IYwE2HODoJwdQvFF7sHJe
 XoRthuy+BJnjqUSLfgcvxcfGShSegm74v80SxD/c8/qLF4k906VWd/sXaNy/p2QBg6q4
 yRwNDIhxsAvdJvSzoAjCZjNKi2Wm0HvTgNOcEnyC2Kz0B2RsuylTG/OhC86GEt7kNrnF GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvykvssfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 09:20:36 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24695uXB005922;
        Fri, 6 May 2022 09:20:36 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvykvssfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 09:20:36 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2469CcIU032500;
        Fri, 6 May 2022 09:20:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3fscdk6494-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 May 2022 09:20:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2469KVeQ45810162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 May 2022 09:20:31 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6F7D11C04C;
        Fri,  6 May 2022 09:20:30 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 320AE11C04A;
        Fri,  6 May 2022 09:20:30 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.62.79])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 May 2022 09:20:30 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v9 2/3] s390x: KVM: guest support for topology function
Date:   Fri,  6 May 2022 11:24:02 +0200
Message-Id: <20220506092403.47406-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220506092403.47406-1-pmorel@linux.ibm.com>
References: <20220506092403.47406-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dfYkLj0XEPx-Vt0K7jOhoQn4CRzqg-qw
X-Proofpoint-GUID: U9P26UOMwl0R7GC38SjdqRXmSZb9UwgN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-06_03,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205060049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We let the userland hypervisor know if the machine support the CPU
topology facility using a new KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.

The PTF instruction will report a topology change if there is any change
with a previous STSI_15_1_2 SYSIB.
Changes inside a STSI_15_1_2 SYSIB occur if CPU bits are set or clear
inside the CPU Topology List Entry CPU mask field, which happens with
changes in CPU polarization, dedication, CPU types and adding or
removing CPUs in a socket.

The reporting to the guest is done using the Multiprocessor
Topology-Change-Report (MTCR) bit of the utility entry of the guest's
SCA which will be cleared during the interpretation of PTF.

To check if the topology has been modified we use a new field of the
arch vCPU to save the previous real CPU ID at the end of a schedule
and verify on next schedule that the CPU used is in the same socket.
We do not report polarization, CPU Type or dedication change.

STSI(15.1.x) gives information on the CPU configuration topology.
Let's accept the interception of STSI with the function code 15 and
let the userland part of the hypervisor handle it when userland
support the CPU Topology facility.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst   | 16 +++++++++++
 arch/s390/include/asm/kvm_host.h | 12 ++++++--
 arch/s390/kvm/kvm-s390.c         | 49 +++++++++++++++++++++++++++++++-
 arch/s390/kvm/kvm-s390.h         | 25 ++++++++++++++++
 arch/s390/kvm/priv.c             | 14 ++++++---
 arch/s390/kvm/vsie.c             |  3 ++
 include/uapi/linux/kvm.h         |  1 +
 7 files changed, 112 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 4a900cdbc62e..c15f5b9dafb6 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7779,3 +7779,19 @@ Ordering of KVM_GET_*/KVM_SET_* ioctls
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 TBD
+
+8.17 KVM_CAP_S390_CPU_TOPOLOGY
+------------------------------
+
+:Capability: KVM_CAP_S390_CPU_TOPOLOGY
+:Architectures: s390
+:Type: vm
+
+This capability indicates that kvm will provide the S390 CPU Topology facility
+which consist of the interpretation of the PTF instruction for the Function
+Code 2 along with interception and forwarding of both the PTF instruction
+with Function Codes 0 or 1 and the STSI(15,1,x) instruction to the userland
+hypervisor.
+
+The stfle facility 11, CPU Topology facility, should not be provided to the
+guest without this capability.
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 766028d54a3e..04653b43ccee 100644
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
@@ -750,6 +755,7 @@ struct kvm_vcpu_arch {
 	bool skey_enabled;
 	struct kvm_s390_pv_vcpu pv;
 	union diag318_info diag318_info;
+	int prev_cpu;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index da3dabda1a12..c8bdce31464f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -606,6 +606,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_PROTECTED:
 		r = is_prot_virt_host();
 		break;
+	case KVM_CAP_S390_CPU_TOPOLOGY:
+		r = test_facility(11);
+		break;
 	default:
 		r = 0;
 	}
@@ -817,6 +820,20 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 		icpt_operexc_on_all_vcpus(kvm);
 		r = 0;
 		break;
+	case KVM_CAP_S390_CPU_TOPOLOGY:
+		r = -EINVAL;
+		mutex_lock(&kvm->lock);
+		if (kvm->created_vcpus) {
+			r = -EBUSY;
+		} else if (test_facility(11)) {
+			set_kvm_facility(kvm->arch.model.fac_mask, 11);
+			set_kvm_facility(kvm->arch.model.fac_list, 11);
+			r = 0;
+		}
+		mutex_unlock(&kvm->lock);
+		VM_EVENT(kvm, 3, "ENABLE: CPU TOPOLOGY %s",
+			 r ? "(not available)" : "(success)");
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -1695,6 +1712,25 @@ static int kvm_s390_get_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
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
@@ -3138,16 +3174,20 @@ __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-
 	gmap_enable(vcpu->arch.enabled_gmap);
 	kvm_s390_set_cpuflags(vcpu, CPUSTAT_RUNNING);
 	if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
 		__start_cpu_timer_accounting(vcpu);
 	vcpu->cpu = cpu;
+
+	if (kvm_s390_topology_changed(vcpu))
+		kvm_s390_sca_set_mtcr(vcpu->kvm);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	/* Remember which CPU was backing the vCPU */
+	vcpu->arch.prev_cpu = vcpu->cpu;
 	vcpu->cpu = -1;
 	if (vcpu->arch.cputm_enabled && !is_vcpu_idle(vcpu))
 		__stop_cpu_timer_accounting(vcpu);
@@ -3267,6 +3307,13 @@ static int kvm_s390_vcpu_setup(struct kvm_vcpu *vcpu)
 		vcpu->arch.sie_block->ecb |= ECB_HOSTPROTINT;
 	if (test_kvm_facility(vcpu->kvm, 9))
 		vcpu->arch.sie_block->ecb |= ECB_SRSI;
+
+	/* PTF needs guest facilities to enable interpretation */
+	if (test_kvm_facility(vcpu->kvm, 11))
+		vcpu->arch.sie_block->ecb |= ECB_PTF;
+	/* Indicate this is a new vcpu */
+	vcpu->arch.prev_cpu = S390_KVM_TOPOLOGY_NEW_CPU;
+
 	if (test_kvm_facility(vcpu->kvm, 73))
 		vcpu->arch.sie_block->ecb |= ECB_TE;
 	if (!kvm_is_ucontrol(vcpu->kvm))
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 497d52a83c78..5fd5e635a611 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -514,4 +514,29 @@ void kvm_s390_vcpu_crypto_reset_all(struct kvm *kvm);
  */
 extern unsigned int diag9c_forwarding_hz;
 
+#define S390_KVM_TOPOLOGY_NEW_CPU -1
+/**
+ * kvm_s390_topology_changed
+ * @vcpu: the virtual CPU
+ *
+ * If the topology facility is present, checks if the CPU toplogy
+ * viewed by the guest changed due to load balancing or CPU hotplug.
+ */
+static inline bool kvm_s390_topology_changed(struct kvm_vcpu *vcpu)
+{
+	if (!test_kvm_facility(vcpu->kvm, 11))
+		return false;
+
+	/* A new vCPU has been hotplugged */
+	if (vcpu->arch.prev_cpu == S390_KVM_TOPOLOGY_NEW_CPU)
+		return true;
+
+	/* The real CPU backing up the vCPU is still on same socket */
+	if (cpumask_test_cpu(vcpu->cpu,
+			     topology_core_cpumask(vcpu->arch.prev_cpu)))
+		return false;
+
+	return true;
+}
+
 #endif
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 0e8603acc105..d9e16b09c8bf 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -874,10 +874,12 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
 		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
 
-	if (fc > 3) {
-		kvm_s390_set_psw_cc(vcpu, 3);
-		return 0;
-	}
+	if (fc > 3 && fc != 15)
+		goto out_no_data;
+
+	/* fc 15 is provided with PTF/CPU topology support */
+	if (fc == 15 && !test_kvm_facility(vcpu->kvm, 11))
+		goto out_no_data;
 
 	if (vcpu->run->s.regs.gprs[0] & 0x0fffff00
 	    || vcpu->run->s.regs.gprs[1] & 0xffff0000)
@@ -911,6 +913,10 @@ static int handle_stsi(struct kvm_vcpu *vcpu)
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
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6a184d260c7f..538a2f9cf42d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1152,6 +1152,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DISABLE_QUIRKS2 213
 /* #define KVM_CAP_VM_TSC_CONTROL 214 */
 #define KVM_CAP_SYSTEM_EVENT_DATA 215
+#define KVM_CAP_S390_CPU_TOPOLOGY 216
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.27.0

