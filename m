Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32CF551F23
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 16:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241907AbiFTOkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 10:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244974AbiFTOj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 10:39:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C21F2603
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 06:59:45 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25KCHIS7000308;
        Mon, 20 Jun 2022 13:59:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5YoWqvZJzhkWFO2eqf21yfC8nT5YR3vvQBjB93nkXP4=;
 b=lYYwhj2niWgq8N9HX/Ofy8L3UffyVLfYRo760ch/QDQtE/nOhkx207bb69Y9MxdZH6e+
 DekwsBqwz9cC8qsUKWOetz/aVKCx27bD/RrgG9590gK9xrcivStLv+AyViO8wqS8x/le
 f+qnP9J/UN00NKe7hdrWeGGMo9f7PS1P2I/mISBuiVdIyUXGFbcapWfqPw6pU6xYidTZ
 +fR/EcU9GDlsx/HdmPorboaY6g0o4ej4B4F7pq1P3AwV7gm1MXnCwi5TX1uCx3u07Qxu
 F2WFUGerfEpGZc0/K0dNYDP4rTzWKTucNPSkvjBdJ8B3s+tG2zmymG09JgT9eW4J9d38 rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrmhuatj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:38 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25KCSxj4008635;
        Mon, 20 Jun 2022 13:59:38 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gsrmhuasb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:37 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25KDp14T019009;
        Mon, 20 Jun 2022 13:59:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3gs6b8t1mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 13:59:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25KDxV3c17564016
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jun 2022 13:59:31 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2F6E11C04C;
        Mon, 20 Jun 2022 13:59:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E10FF11C050;
        Mon, 20 Jun 2022 13:59:30 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.62.140])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Jun 2022 13:59:30 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Subject: [PATCH v8 01/12] Update Linux Headers
Date:   Mon, 20 Jun 2022 16:03:41 +0200
Message-Id: <20220620140352.39398-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220620140352.39398-1-pmorel@linux.ibm.com>
References: <20220620140352.39398-1-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: p2AZWdvDdde9i9VTG30-vqgIH4RszMkS
X-Proofpoint-ORIG-GUID: cogrF6BUXcyXkPvfDu2cQRa5RX_NlwN1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 mlxlogscore=842 suspectscore=0 malwarescore=0
 bulkscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206200063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This does not belong to the serie.
It is only there to facilitate review with the coresponding
linux series: [PATCH v10 0/3] s390x: KVM: CPU Topology

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 linux-headers/asm-s390/kvm.h | 9 +++++++++
 linux-headers/linux/kvm.h    | 1 +
 2 files changed, 10 insertions(+)

diff --git a/linux-headers/asm-s390/kvm.h b/linux-headers/asm-s390/kvm.h
index f053b8304a..2bad030b8c 100644
--- a/linux-headers/asm-s390/kvm.h
+++ b/linux-headers/asm-s390/kvm.h
@@ -74,6 +74,7 @@ struct kvm_s390_io_adapter_req {
 #define KVM_S390_VM_CRYPTO		2
 #define KVM_S390_VM_CPU_MODEL		3
 #define KVM_S390_VM_MIGRATION		4
+#define KVM_S390_VM_CPU_TOPOLOGY       5
 
 /* kvm attributes for mem_ctrl */
 #define KVM_S390_VM_MEM_ENABLE_CMMA	0
@@ -171,6 +172,14 @@ struct kvm_s390_vm_cpu_subfunc {
 #define KVM_S390_VM_MIGRATION_START	1
 #define KVM_S390_VM_MIGRATION_STATUS	2
 
+/* kvm attributes for cpu topology */
+#define KVM_S390_VM_CPU_TOPO_MTR_CLEAR 0
+#define KVM_S390_VM_CPU_TOPO_MTR_SET   1
+
+struct kvm_s390_cpu_topology {
+	__u16 mtcr;
+};
+
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
 	/* general purpose regs for s390 */
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 0d05d02ee4..83f7a49a30 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1150,6 +1150,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DISABLE_QUIRKS2 213
 /* #define KVM_CAP_VM_TSC_CONTROL 214 */
 #define KVM_CAP_SYSTEM_EVENT_DATA 215
+#define KVM_CAP_S390_CPU_TOPOLOGY 217
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.31.1

