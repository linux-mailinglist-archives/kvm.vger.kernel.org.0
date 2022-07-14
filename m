Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607C6574A3D
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 12:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238176AbiGNKOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 06:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiGNKNx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 06:13:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B86140F9;
        Thu, 14 Jul 2022 03:13:51 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26EA9WnH035082;
        Thu, 14 Jul 2022 10:13:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=nExCuTzVjei4d6bEIJ/imT4m/tp/Rsul+6KvOf2fYsc=;
 b=Yd21OSjnogeGOXqJoU7Zm/WDAxrFWs6wmmJB46Xnqp3gi3eS9Rr0VkAzcYr/4NPl808G
 oe7ipF1vyO/w3zoJFUafMhnxbR5EF6QN+6UAUtegE1gKnhWL4ijWGikGQSms5VIwji10
 svT53i+qqyXQTc3M27oBxnr8G7Il+m2dGkLJGalE9fUQbI2v7piWXowS2mWOcJ3r76O6
 cjJnAWn0jVjNW/T80b1we3sX4sttqGoDpo6q7NYcIUkt8D1vDRYvIoIQBZvkyd4XAz2Q
 MQh3FCwJLNovowlHZ3jx4UG0LVGdtYWjq6iVrF6sd6sO4rxI2GUtjeN6qZDGdavDCtr4 sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hagxs8ahs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 10:13:51 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26EAA9PW039161;
        Thu, 14 Jul 2022 10:13:50 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hagxs8agy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 10:13:50 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26EA8W31017234;
        Thu, 14 Jul 2022 10:13:48 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3h71a8x7ms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Jul 2022 10:13:47 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26EACBdL12190152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 10:12:11 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABAA2A405B;
        Thu, 14 Jul 2022 10:13:44 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9202A4054;
        Thu, 14 Jul 2022 10:13:43 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.80.107])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Jul 2022 10:13:43 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com
Subject: [PATCH v13 2/2] KVM: s390: resetting the Topology-Change-Report
Date:   Thu, 14 Jul 2022 12:18:24 +0200
Message-Id: <20220714101824.101601-3-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220714101824.101601-1-pmorel@linux.ibm.com>
References: <20220714101824.101601-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: a06oDDYybEg-k4C5KVKlFo1SO51bxbGp
X-Proofpoint-GUID: Av12YoAQdqU_1yD7DfCUkbf-uiE_CfL7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-14_08,2022-07-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207140042
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During a subsystem reset the Topology-Change-Report is cleared.

Let's give userland the possibility to clear the MTCR in the case
of a subsystem reset.

To migrate the MTCR, we give userland the possibility to
query the MTCR state.

We indicate KVM support for the CPU topology facility with a new
KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst   | 25 ++++++++++++++++
 arch/s390/include/uapi/asm/kvm.h |  1 +
 arch/s390/kvm/kvm-s390.c         | 51 ++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h         |  1 +
 4 files changed, 78 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 82baa7682829..892fc2e470d7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8159,6 +8159,31 @@ PV guests. The `KVM_PV_DUMP` command is available for the
 dump related UV data. Also the vcpu ioctl `KVM_S390_PV_CPU_COMMAND` is
 available and supports the `KVM_PV_DUMP_CPU` subcommand.
 
+8.38 KVM_CAP_S390_CPU_TOPOLOGY
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
index 330a0cd4b8c8..b2cb13d1c0cd 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -647,6 +647,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_ZPCI_OP:
 		r = kvm_s390_pci_interp_allowed();
 		break;
+	case KVM_CAP_S390_CPU_TOPOLOGY:
+		r = test_facility(11);
+		break;
 	default:
 		r = 0;
 	}
@@ -858,6 +861,20 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
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
@@ -1794,6 +1811,31 @@ static void kvm_s390_update_topology_change_report(struct kvm *kvm, bool val)
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
@@ -1814,6 +1856,9 @@ static int kvm_s390_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = kvm_s390_vm_set_migration(kvm, attr);
 		break;
+	case KVM_S390_VM_CPU_TOPOLOGY:
+		ret = kvm_s390_set_topo_change_indication(kvm, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -1839,6 +1884,9 @@ static int kvm_s390_vm_get_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 	case KVM_S390_VM_MIGRATION:
 		ret = kvm_s390_vm_get_migration(kvm, attr);
 		break;
+	case KVM_S390_VM_CPU_TOPOLOGY:
+		ret = kvm_s390_get_topo_change_indication(kvm, attr);
+		break;
 	default:
 		ret = -ENXIO;
 		break;
@@ -1912,6 +1960,9 @@ static int kvm_s390_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
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
index 80216c6cece1..16ce54d6a868 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1158,6 +1158,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_SYSTEM_EVENT_DATA 215
 #define KVM_CAP_ARM_SYSTEM_SUSPEND 216
 #define KVM_CAP_S390_PROTECTED_DUMP 217
+#define KVM_CAP_S390_CPU_TOPOLOGY 218
 #define KVM_CAP_S390_ZPCI_OP 221
 
 #ifdef KVM_CAP_IRQ_ROUTING
-- 
2.31.1

