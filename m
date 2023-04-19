Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA39C6E826E
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 22:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjDSUMb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 16:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbjDSUM3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 16:12:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE93DD
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 13:12:28 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33JJnPDw009649;
        Wed, 19 Apr 2023 20:12:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=Ec3740E8d/LG1l02Dd9Gm6u3gY/JY3WLqpF2cHpTZ90=;
 b=swl2NiOxMiEqWagLa6hoeh35bEMS6VfI2rcyZxOkjoYYHpRD8Oems9V/olKLxdt56J3a
 viSjLELaPwRFIsb8cM/fYIieZZtphOwqfAm90croXHl61RoHFnDkPUeCGIpBqtNvDueR
 n1b3MFykJ3LweeRaDYErrNjwMpuFu98e2c76zBxTSKjb+Q7SsK/q92jhiQeO0an1jUit
 cupUgnYfsGGJVwwmrgoK1Nr7ZaftCBS3+EBQyYtrpOVoSozFth1LwaLhOIvbmSk0Ndqp
 4d9IRksFMnux+Ih25Xnvm44wuW/Uj3MNQauW5DiMm/6mSJtSIssnJ8rrMoIQp0PIlQly aA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pyktas72m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 20:12:12 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33JIoXq4011116;
        Wed, 19 Apr 2023 20:12:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjc6wx15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 20:12:12 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33JKC8Qi016607;
        Wed, 19 Apr 2023 20:12:11 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-164-99.vpn.oracle.com [10.175.164.99])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3pyjc6wwxu-2;
        Wed, 19 Apr 2023 20:12:11 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux.dev
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v3 1/2] iommu/amd: Don't block updates to GATag if guest mode is on
Date:   Wed, 19 Apr 2023 21:11:53 +0100
Message-Id: <20230419201154.83880-2-joao.m.martins@oracle.com>
In-Reply-To: <20230419201154.83880-1-joao.m.martins@oracle.com>
References: <20230419201154.83880-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_14,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304190174
X-Proofpoint-ORIG-GUID: kv59nWQsxfhAHfBuk5IFaUHLPLahlp2L
X-Proofpoint-GUID: kv59nWQsxfhAHfBuk5IFaUHLPLahlp2L
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On KVM GSI routing table updates, specially those where they have vIOMMUs
with interrupt remapping enabled (to boot >255vcpus setups without relying
on KVM_FEATURE_MSI_EXT_DEST_ID), a VMM may update the backing VF MSIs
with a new VCPU affinity.

On AMD with AVIC enabled, the new vcpu affinity info is updated via:
	avic_pi_update_irte()
		irq_set_vcpu_affinity()
			amd_ir_set_vcpu_affinity()
				amd_iommu_{de}activate_guest_mode()

Where the IRTE[GATag] is updated with the new vcpu affinity. The GATag
contains VM ID and VCPU ID, and is used by IOMMU hardware to signal KVM
(via GALog) when interrupt cannot be delivered due to vCPU is in
blocking state.

The issue is that amd_iommu_activate_guest_mode() will essentially
only change IRTE fields on transitions from non-guest-mode to guest-mode
and otherwise returns *with no changes to IRTE* on already configured
guest-mode interrupts. To the guest this means that the VF interrupts
remain affined to the first vCPU they were first configured, and guest
will be unable to issue VF interrupts and receive messages like this
from spurious interrupts (e.g. from waking the wrong vCPU in GALog):

[  167.759472] __common_interrupt: 3.34 No irq handler for vector
[  230.680927] mlx5_core 0000:00:02.0: mlx5_cmd_eq_recover:247:(pid
3122): Recovered 1 EQEs on cmd_eq
[  230.681799] mlx5_core 0000:00:02.0:
wait_func_handle_exec_timeout:1113:(pid 3122): cmd[0]: CREATE_CQ(0x400)
recovered after timeout
[  230.683266] __common_interrupt: 3.34 No irq handler for vector

Given the fact that amd_ir_set_vcpu_affinity() uses
amd_iommu_activate_guest_mode() underneath it essentially means that VCPU
affinity changes of IRTEs are nops. Fix it by dropping the check for
guest-mode at amd_iommu_activate_guest_mode(). Same thing is applicable to
amd_iommu_deactivate_guest_mode() although, even if the IRTE doesn't change
underlying DestID on the host, the VFIO IRQ handler will still be able to
poke at the right guest-vCPU.

Fixes: b9c6ff94e43a ("iommu/amd: Re-factor guest virtual APIC (de-)activation code")
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/iommu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 5a505ba5467e..fbe77ee2d26c 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3484,8 +3484,7 @@ int amd_iommu_activate_guest_mode(void *data)
 	struct irte_ga *entry = (struct irte_ga *) ir_data->entry;
 	u64 valid;
 
-	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
-	    !entry || entry->lo.fields_vapic.guest_mode)
+	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) || !entry)
 		return 0;
 
 	valid = entry->lo.fields_vapic.valid;
-- 
2.17.2

