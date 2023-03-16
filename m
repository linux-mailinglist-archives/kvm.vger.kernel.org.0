Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8839D6BD9C5
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 21:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjCPUDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 16:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjCPUDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 16:03:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C3BC6411
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 13:02:43 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GJmSAE015350;
        Thu, 16 Mar 2023 20:02:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=LzbRCvdWQ6nIaVs8flTpnpBZLolApjT4HemUcrFwLqQ=;
 b=D2pnLo1sP+dcUallbV3vDXT17Tj941aEsEmNIhdO639hprg0WmNlvn7+Hf+pbi4EQPTG
 0IrcupU9gnvJSjrmAmZ7iElWqklOXKUj5Ci0LuELqGyzIx1Ev8bIkc4ZgxHi7rHLIHTf
 s4fYilLT+wJq4zJYgU9+JMn9dPzApjoF7I8Um2U86HOIdZ2RNa4l8hYANgSBZ0R12uLz
 FSJKCQ16QXeFAMrJDSp2pSvnyoNkR/sGqFOVRf/iqZiE3grhnC1U5XKxUE7JsInBnTbj
 Sl0+r2uc70AHYj38I6BLIArxwF0xpzsNE1FNVL2Z7ij4xX7BmeUq2OFgTy/xJQE8i/Oo Eg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs29j62r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 20:02:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32GJtbus020464;
        Thu, 16 Mar 2023 20:02:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq46u60s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 20:02:32 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32GK2TMN028656;
        Thu, 16 Mar 2023 20:02:31 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-172-105.vpn.oracle.com [10.175.172.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pbq46u5v8-2;
        Thu, 16 Mar 2023 20:02:31 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux.dev
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v2 1/2] iommu/amd: Don't block updates to GATag if guest mode is on
Date:   Thu, 16 Mar 2023 20:02:18 +0000
Message-Id: <20230316200219.42673-2-joao.m.martins@oracle.com>
In-Reply-To: <20230316200219.42673-1-joao.m.martins@oracle.com>
References: <20230316200219.42673-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_13,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303160152
X-Proofpoint-ORIG-GUID: wZHsnGPS8thGGI2WUrxmvVYLtq7nqRbt
X-Proofpoint-GUID: wZHsnGPS8thGGI2WUrxmvVYLtq7nqRbt
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
will be unable to either VF interrupts and receive messages like this
from spuruious interrupts (e.g. from waking the wrong vCPU in GALog):

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
 drivers/iommu/amd/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 5a505ba5467e..bf3ebc9d6cde 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3485,7 +3485,7 @@ int amd_iommu_activate_guest_mode(void *data)
 	u64 valid;
 
 	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
-	    !entry || entry->lo.fields_vapic.guest_mode)
+	    !entry)
 		return 0;
 
 	valid = entry->lo.fields_vapic.valid;
-- 
2.17.2

