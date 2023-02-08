Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72CC68EFAB
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 14:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbjBHNUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 08:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjBHNUE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 08:20:04 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02C65594
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 05:20:03 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 318CxOJG029158;
        Wed, 8 Feb 2023 13:19:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=mE+9p3YOZ5A2VnmUTTG1XvVYzuf+jVwVnx+IylGjcZI=;
 b=wLNLK21dMcl5prV2+auMhB9iFDEME5ra0N8xXHZfFAZ+IEitX9Uz25FXY841bCXTf2bE
 W5+1bxf/2Ar9IR1kDm4IeUlWcvMGY5sGxgXtwobh0LDIm46M0wadqcYfhbA4P0r3WX70
 +t8Ba8/1jTCuwQowLYISiCZ2TAQ21yi4hAnTe9hWnlGFdTYETf/aArI9jSGh2/6xBbnv
 xCzXLRWJTauqlT8nPHVcCiyz3bWxe/NGx4allWND4gBAXTlXckSe79zefhETUrqvi4Pj
 Ay72RFTTa2xDNoUQJ6Z5thq7lQaccSkKOqA7Zh8zFKjBQP20dRNjERFt+2cU316o0iKw Bw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhfwu821s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Feb 2023 13:19:46 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 318DFGNI015917;
        Wed, 8 Feb 2023 13:19:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3njrbbp7nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Feb 2023 13:19:45 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 318DG6gu023485;
        Wed, 8 Feb 2023 13:19:44 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-178-235.vpn.oracle.com [10.175.178.235])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3njrbbp7ma-1;
        Wed, 08 Feb 2023 13:19:44 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux.dev
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v1] iommu/amd: Don't block updates to GATag if guest mode is already on
Date:   Wed,  8 Feb 2023 13:19:38 +0000
Message-Id: <20230208131938.39898-1-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-08_04,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302080118
X-Proofpoint-GUID: hwaleoxYoRRRKzJj6w82_rFKs_HG8klt
X-Proofpoint-ORIG-GUID: hwaleoxYoRRRKzJj6w82_rFKs_HG8klt
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On KVM GSI routing table updates, specially those where they have vIOMMUs
with interrupt remapping enabled (e.g. to boot >255vcpus guests without
relying on KVM_FEATURE_MSI_EXT_DEST_ID), a VMM may update the backing VF
MSIs with new VCPU affinities.

On AMD this translates to calls to amd_ir_set_vcpu_affinity() and
eventually to amd_iommu_{de}activate_guest_mode() with a new GATag
outlining the VM ID and (new) VCPU ID. On vCPU blocking and unblocking
paths it disables AVIC, and rely on GALog to convey the wakeups to any
sleeping vCPUs. KVM will store a list of GA-mode IR entries to each
running/blocked vCPU. So any vCPU Affinity update to a VF interrupt happen
via KVM, and it will change already-configured-guest-mode IRTEs with a new
GATag.

The issue is that amd_iommu_activate_guest_mode() will essentially only
change IRTE fields on transitions from non-guest-mode to guest-mode and
otherwise returns *with no changes to IRTE* on already configured
guest-mode interrupts. To the guest this means that the VF interrupts
remain affined to the first vCPU these were first configured, and guest
will be unable to either VF interrupts and receive messages like this from
spurious interrupts (e.g. from waking the wrong vCPU in GALog):

[  167.759472] __common_interrupt: 3.34 No irq handler for vector
[  230.680927] mlx5_core 0000:00:02.0: mlx5_cmd_eq_recover:247:(pid
3122): Recovered 1 EQEs on cmd_eq
[  230.681799] mlx5_core 0000:00:02.0:
wait_func_handle_exec_timeout:1113:(pid 3122): cmd[0]: CREATE_CQ(0x400)
recovered after timeout
[  230.683266] __common_interrupt: 3.34 No irq handler for vector

Given that amd_ir_set_vcpu_affinity() uses amd_iommu_activate_guest_mode()
underneath it essentially means that VCPU affinity changes of IRTEs are
nops if it was called once for the IRTE already (on VMENTER). Fix it by
dropping the check for guest-mode at amd_iommu_activate_guest_mode().  Same
thing is applicable to amd_iommu_deactivate_guest_mode() although, even if
the IRTE doesn't change underlying DestID on the host, the VFIO IRQ handler
will still be able to poke at the right guest-vCPU.

Fixes: b9c6ff94e43a ("iommu/amd: Re-factor guest virtual APIC (de-)activation code")
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
Some notes in other related flaws as I looked at this:

1) amd_iommu_deactivate_guest_mode() suffers from the same issue as this patch,
but it should only matter for the case where you rely on irqbalance-like
daemons balancing VFIO IRQs in the hypervisor. Though, it doesn't translate
into guest failures, more like performance "misdirection". Happy to fix it, if
folks also deem it as a problem.

2) This patch doesn't attempt at changing semantics around what
amd_iommu_activate_guest_mode() has been doing for a long time [since v5.4]
(i.e. clear the whole IRTE and then changes its fields). As such when
updating the IRTEs the interrupts get isRunning and DestId cleared, thus
we rely on the GALog to inject IRQs into vCPUs /until/ the vCPUs block
and unblock again (which is when they update the IOMMU affinity), or the
AVIC gets momentarily disabled. I have patches that improve this part as a
follow-up, but I thought that this patch had value on its own onto fixing
what has been broken since v5.4 ... and that it could be easily carried
to stable trees.

---
 drivers/iommu/amd/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index cbeaab55c0db..afe1f35a4dd9 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3476,7 +3476,7 @@ int amd_iommu_activate_guest_mode(void *data)
 	u64 valid;
 
 	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
-	    !entry || entry->lo.fields_vapic.guest_mode)
+	    !entry)
 		return 0;
 
 	valid = entry->lo.fields_vapic.valid;
-- 
2.17.2

