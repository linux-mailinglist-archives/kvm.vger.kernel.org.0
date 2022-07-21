Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E8E57D129
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbiGUQOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233499AbiGUQOS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:14:18 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D8689662;
        Thu, 21 Jul 2022 09:14:06 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFs0mg006175;
        Thu, 21 Jul 2022 16:13:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=L5+lu9PnLTS52Xj3+U2iqNoRACm4yer8cO647T8wkuY=;
 b=WVGnuCkCzic8wNH4F6YT4XkqOxmDA7dFGyK1kWVvf6eZzOnGOSsuRQrfwJ2QrjfN3/eW
 05+fWmo9YbaNZa4Kr5qdbuivIkmLg9YVLKuWpegcnIZWQvWy71Hz4dtE/bHFTNzbnlFw
 mkyn12GolA2yhJUoQfNLPz+YASN2Hf/gHsiKtWXLCZEUg0oBZjrP1EaeWZlzPwI54k44
 dB6J4PH2qK2zAMgn0ChpSm53EYdfNK+OA2wqS61UweU1ondpGCIQ55oxb84LkMyfFKKZ
 p2Tffv8yWISm3+azvlavDQyKJahb06Mh/I1w78Jhfx6qJjiCBey4oJGxJthyxJ44fKZX ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9um8fkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:35 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LFuB2P017603;
        Thu, 21 Jul 2022 16:13:35 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf9um8fjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:35 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LGDB8v004192;
        Thu, 21 Jul 2022 16:13:33 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3hbmy8y54b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:33 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGDUIr15401408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:13:30 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27C25A4054;
        Thu, 21 Jul 2022 16:13:30 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92D20A405B;
        Thu, 21 Jul 2022 16:13:29 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:29 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com,
        Pierre Morel <pmorel@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: [GIT PULL 42/42] KVM: s390: resetting the Topology-Change-Report
Date:   Thu, 21 Jul 2022 18:13:02 +0200
Message-Id: <20220721161302.156182-43-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gOVAdRUJfBYCFNlXMiTBT0Z5DV_E2Ou3
X-Proofpoint-GUID: zBJGP0isZRDgODCsa0NGQSyRgiYp6Q-I
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

During a subsystem reset the Topology-Change-Report is cleared.

Let's give userland the possibility to clear the MTCR in the case
of a subsystem reset.

To migrate the MTCR, we give userland the possibility to
query the MTCR state.

We indicate KVM support for the CPU topology facility with a new
KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20220714194334.127812-1-pmorel@linux.ibm.com>
Link: https://lore.kernel.org/all/20220714194334.127812-1-pmorel@linux.ibm.com/
[frankja@linux.ibm.com: Simple conflict resolution in Documentation/virt/kvm/api.rst]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst   | 25 ++++++++++++++++
 arch/s390/include/uapi/asm/kvm.h |  1 +
 arch/s390/kvm/kvm-s390.c         | 51 ++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h         |  1 +
 4 files changed, 78 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 5be5cc59869d..3c4551a2f6d0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8269,6 +8269,31 @@ The capability has no effect if the nx_huge_pages module parameter is not set.
 
 This capability may only be set before any vCPUs are created.
 
+8.39 KVM_CAP_S390_CPU_TOPOLOGY
+------------------------------
+
+:Capability: KVM_CAP_S390_CPU_TOPOLOGY
+:Architectures: s390
+:Type: vm
+
+This capability indicates that KVM will provide the S390 CPU Topology
+facility which consist of the interpretation of the PTF instruction for
+the function code 2 along with interception and forwarding of both the
+PTF instruction with function codes 0 or 1 and the STSI(15,1,x)
+instruction to the userland hypervisor.
+
+The stfle facility 11, CPU Topology facility, should not be indicated
+to the guest without this capability.
+
+When this capability is present, KVM provides a new attribute group
+on vm fd, KVM_S390_VM_CPU_TOPOLOGY.
+This new attribute allows to get, set or clear the Modified Change
+Topology Report (MTCR) bit of the SCA through the kvm_device_attr
+structure.
+
+When getting the Modified Change Topology Report value, the attr->addr
+must point to a byte where the value will be stored or retrieved from.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
index 7a6b14874d65..a73cf01a1606 100644
--- a/arch/s390/include/uapi/asm/kvm.h
+++ b/arch/s390/include/uapi/asm/kvm.h
@@ -74,6 +74,7 @@ struct kvm_s390_io_adapter_req {
 #define KVM_S390_VM_CRYPTO		2
 #define KVM_S390_VM_CPU_MODEL		3
 #define KVM_S390_VM_MIGRATION		4
+#define KVM_S390_VM_CPU_TOPOLOGY	5
 
 /* kvm attributes for mem_ctrl */
 #define KVM_S390_VM_MEM_ENABLE_CMMA	0
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 5d18b66a08c9..edfd4bbd0cba 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -642,6 +642,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_ZPCI_OP:
 		r = kvm_s390_pci_interp_allowed();
 		break;
+	case KVM_CAP_S390_CPU_TOPOLOGY:
+		r = test_facility(11);
+		break;
 	default:
 		r = 0;
 	}
@@ -853,6 +856,20 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
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
+		VM_EVENT(kvm, 3, "ENABLE: CAP_S390_CPU_TOPOLOGY %s",
+			 r ? "(not available)" : "(success)");
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -1789,6 +1806,31 @@ static void kvm_s390_update_topology_change_report(struct kvm *kvm, bool val)
 	read_unlock(&kvm->arch.sca_lock);
 }
 
+static int kvm_s390_set_topo_change_indication(struct kvm *kvm,
+					       struct kvm_device_attr *attr)
+{
+	if (!test_kvm_facility(kvm, 11))
+		return -ENXIO;
+
+	kvm_s390_update_topology_change_report(kvm, !!attr->attr);
+	return 0;
+}
+
+static int kvm_s390_get_topo_change_indication(struct kvm *kvm,
+					       struct kvm_device_attr *attr)
+{
+	u8 topo;
+
+	if (!test_kvm_facility(kvm, 11))
+		return -ENXIO;
+
+	read_lock(&kvm->arch.sca_lock);
+	topo = ((struct bsca_block *)kvm->arch.sca)->utility.mtcr;
+	read_unlock(&kvm->arch.sca_lock);
+
+	return put_user(topo, (u8 __user *)attr->addr);
+}
+
 static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	int ret;
@@ -1809,6 +1851,9 @@ static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = kvm_s390_vm_set_migration(kvm, attr);
 		break;
+	case KVM_S390_VM_CPU_TOPOLOGY:
+		ret = kvm_s390_set_topo_change_indication(kvm, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -1834,6 +1879,9 @@ static int kvm_s390_vm_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = kvm_s390_vm_get_migration(kvm, attr);
 		break;
+	case KVM_S390_VM_CPU_TOPOLOGY:
+		ret = kvm_s390_get_topo_change_indication(kvm, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -1907,6 +1955,9 @@ static int kvm_s390_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = 0;
 		break;
+	case KVM_S390_VM_CPU_TOPOLOGY:
+		ret = test_kvm_facility(kvm, 11) ? 0 : -ENXIO;
+		break;
 	default:
 		ret = -ENXIO;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 20817dd7f2f1..7e06194129e3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1168,6 +1168,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_X86_NOTIFY_VMEXIT 219
 #define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 220
 #define KVM_CAP_S390_ZPCI_OP 221
+#define KVM_CAP_S390_CPU_TOPOLOGY 222
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.36.1

