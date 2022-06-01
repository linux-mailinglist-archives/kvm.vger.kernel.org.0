Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0081053AA36
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 17:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347884AbiFAPhR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 11:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355657AbiFAPg7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 11:36:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8E3B866;
        Wed,  1 Jun 2022 08:36:57 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251FE54e004449;
        Wed, 1 Jun 2022 15:36:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=/O6vtaR/p5x0YkrXLokxTL9UpPhZ59eZOZ4njOPVNv0=;
 b=b/sB5MuYjHECTU3oqC1pSC7b2dYD3nBv8Xxds5BhNQrVFTesklhVRP3E5zPV0qV2B9k5
 lrghJKj8Bcxx7ieOmkyvyUqBFXhSvHWJ/36JgmBBWYfcy4zTLvgdN8Sa1GtVXEE4NXkA
 1803kyLRU6h6YRtzMgakNxvS8FhRmygqRJq+p9yqg+0ed2lkYQWsMHHuEHEEgqSNDWf6
 8OLGhyjhmeEunVO75Oytblj2VDvgPNvH5Ol8eBpuSb90MtHalXIJSOMhBdS1xjRv+7bZ
 CmNth5FZfCN/YPram/UXUP5/6i1UDM5In9cMuo8eT8fHHu2Oqm+l9IMmBv5GF5RhbcMP 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3geajsrg9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:56 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 251FFIUS007363;
        Wed, 1 Jun 2022 15:36:55 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3geajsrg8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:55 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 251FKZX9010124;
        Wed, 1 Jun 2022 15:36:54 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3gbc97vdtq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:53 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 251FaoB855247236
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Jun 2022 15:36:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB9A842041;
        Wed,  1 Jun 2022 15:36:50 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4A354203F;
        Wed,  1 Jun 2022 15:36:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  1 Jun 2022 15:36:50 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 8AA05E028C; Wed,  1 Jun 2022 17:36:50 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 10/15] Documentation/virt/kvm/api.rst: Add protvirt dump/info api descriptions
Date:   Wed,  1 Jun 2022 17:36:41 +0200
Message-Id: <20220601153646.6791-11-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601153646.6791-1-borntraeger@linux.ibm.com>
References: <20220601153646.6791-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4_xyPqQ2gGsDa3L9dm0WHiomVd8OjF4U
X-Proofpoint-ORIG-GUID: ENI7tY8onnwJKMH_Hhqs41ITzBBmrgvi
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_05,2022-06-01_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206010072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Time to add the dump API changes to the api documentation file.
Also some minor cleanup.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20220517163629.3443-11-frankja@linux.ibm.com
Message-Id: <20220517163629.3443-11-frankja@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 154 ++++++++++++++++++++++++++++++++-
 1 file changed, 152 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 28b547a9d96a..47d3064f5b79 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5127,7 +5127,7 @@ into ESA mode. This reset is a superset of the initial reset.
 	__u32 reserved[3];
   };
 
-cmd values:
+**cmd values:**
 
 KVM_PV_ENABLE
   Allocate memory and register the VM with the Ultravisor, thereby
@@ -5143,7 +5143,6 @@ KVM_PV_ENABLE
   =====      =============================
 
 KVM_PV_DISABLE
-
   Deregister the VM from the Ultravisor and reclaim the memory that
   had been donated to the Ultravisor, making it usable by the kernel
   again.  All registered VCPUs are converted back to non-protected
@@ -5160,6 +5159,117 @@ KVM_PV_VM_VERIFY
   Verify the integrity of the unpacked image. Only if this succeeds,
   KVM is allowed to start protected VCPUs.
 
+KVM_PV_INFO
+  :Capability: KVM_CAP_S390_PROTECTED_DUMP
+
+  Presents an API that provides Ultravisor related data to userspace
+  via subcommands. len_max is the size of the user space buffer,
+  len_written is KVM's indication of how much bytes of that buffer
+  were actually written to. len_written can be used to determine the
+  valid fields if more response fields are added in the future.
+
+  ::
+
+     enum pv_cmd_info_id {
+	KVM_PV_INFO_VM,
+	KVM_PV_INFO_DUMP,
+     };
+
+     struct kvm_s390_pv_info_header {
+	__u32 id;
+	__u32 len_max;
+	__u32 len_written;
+	__u32 reserved;
+     };
+
+     struct kvm_s390_pv_info {
+	struct kvm_s390_pv_info_header header;
+	struct kvm_s390_pv_info_dump dump;
+	struct kvm_s390_pv_info_vm vm;
+     };
+
+**subcommands:**
+
+  KVM_PV_INFO_VM
+    This subcommand provides basic Ultravisor information for PV
+    hosts. These values are likely also exported as files in the sysfs
+    firmware UV query interface but they are more easily available to
+    programs in this API.
+
+    The installed calls and feature_indication members provide the
+    installed UV calls and the UV's other feature indications.
+
+    The max_* members provide information about the maximum number of PV
+    vcpus, PV guests and PV guest memory size.
+
+    ::
+
+      struct kvm_s390_pv_info_vm {
+	__u64 inst_calls_list[4];
+	__u64 max_cpus;
+	__u64 max_guests;
+	__u64 max_guest_addr;
+	__u64 feature_indication;
+      };
+
+
+  KVM_PV_INFO_DUMP
+    This subcommand provides information related to dumping PV guests.
+
+    ::
+
+      struct kvm_s390_pv_info_dump {
+	__u64 dump_cpu_buffer_len;
+	__u64 dump_config_mem_buffer_per_1m;
+	__u64 dump_config_finalize_len;
+      };
+
+KVM_PV_DUMP
+  :Capability: KVM_CAP_S390_PROTECTED_DUMP
+
+  Presents an API that provides calls which facilitate dumping a
+  protected VM.
+
+  ::
+
+    struct kvm_s390_pv_dmp {
+      __u64 subcmd;
+      __u64 buff_addr;
+      __u64 buff_len;
+      __u64 gaddr;		/* For dump storage state */
+    };
+
+  **subcommands:**
+
+  KVM_PV_DUMP_INIT
+    Initializes the dump process of a protected VM. If this call does
+    not succeed all other subcommands will fail with -EINVAL. This
+    subcommand will return -EINVAL if a dump process has not yet been
+    completed.
+
+    Not all PV vms can be dumped, the owner needs to set `dump
+    allowed` PCF bit 34 in the SE header to allow dumping.
+
+  KVM_PV_DUMP_CONFIG_STOR_STATE
+     Stores `buff_len` bytes of tweak component values starting with
+     the 1MB block specified by the absolute guest address
+     (`gaddr`). `buff_len` needs to be `conf_dump_storage_state_len`
+     aligned and at least >= the `conf_dump_storage_state_len` value
+     provided by the dump uv_info data. buff_user might be written to
+     even if an error rc is returned. For instance if we encounter a
+     fault after writing the first page of data.
+
+  KVM_PV_DUMP_COMPLETE
+    If the subcommand succeeds it completes the dump process and lets
+    KVM_PV_DUMP_INIT be called again.
+
+    On success `conf_dump_finalize_len` bytes of completion data will be
+    stored to the `buff_addr`. The completion data contains a key
+    derivation seed, IV, tweak nonce and encryption keys as well as an
+    authentication tag all of which are needed to decrypt the dump at a
+    later time.
+
+
 4.126 KVM_X86_SET_MSR_FILTER
 ----------------------------
 
@@ -5802,6 +5912,32 @@ of CPUID leaf 0xD on the host.
 
 This ioctl injects an event channel interrupt directly to the guest vCPU.
 
+4.136 KVM_S390_PV_CPU_COMMAND
+-----------------------------
+
+:Capability: KVM_CAP_S390_PROTECTED_DUMP
+:Architectures: s390
+:Type: vcpu ioctl
+:Parameters: none
+:Returns: 0 on success, < 0 on error
+
+This ioctl closely mirrors `KVM_S390_PV_COMMAND` but handles requests
+for vcpus. It re-uses the kvm_s390_pv_dmp struct and hence also shares
+the command ids.
+
+**command:**
+
+KVM_PV_DUMP
+  Presents an API that provides calls which facilitate dumping a vcpu
+  of a protected VM.
+
+**subcommand:**
+
+KVM_PV_DUMP_CPU
+  Provides encrypted dump data like register values.
+  The length of the returned data is provided by uv_info.guest_cpu_stor_len.
+
+
 5. The kvm_run structure
 ========================
 
@@ -7954,6 +8090,20 @@ should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
 When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
 type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
 
+8.37 KVM_CAP_S390_PROTECTED_DUMP
+--------------------------------
+
+:Capability: KVM_CAP_S390_PROTECTED_DUMP
+:Architectures: s390
+:Type: vm
+
+This capability indicates that KVM and the Ultravisor support dumping
+PV guests. The `KVM_PV_DUMP` command is available for the
+`KVM_S390_PV_COMMAND` ioctl and the `KVM_PV_INFO` command provides
+dump related UV data. Also the vcpu ioctl `KVM_S390_PV_CPU_COMMAND` is
+available and supports the `KVM_PV_DUMP_CPU` subcommand.
+
+
 9. Known KVM API problems
 =========================
 
-- 
2.35.1

