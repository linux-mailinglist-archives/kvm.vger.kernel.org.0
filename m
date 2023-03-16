Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86886BD9C4
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 21:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjCPUDJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 16:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjCPUDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 16:03:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4AEDE6FED
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 13:02:42 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GJcsVP007164;
        Thu, 16 Mar 2023 20:02:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=K2tTRCBTFgWKZRE+CjN2+VcYa2XGwn2b4xFiJselsG0=;
 b=09vjdVOOV0aBRLqD42WNQnkHUeiqm3K6gZdGio8OXHg46Fd3dsrUEys+0vUCxfTVgm6j
 xXiqaPLNXMkrK+Y4inf6uNPIEbjy8pR8sfKAMoYR9pNKwSivyR6eNUCoElEhwC7udJuj
 MX9RW8TeItrTOcbW6Y3zB/PahnBOwhH7FHk678ikc2pfTPuvKXvpUuc2gwIMl6HXKvcb
 Oeeeqhth7IduZvYlYb7TK0WzGmTt13+U5c0aeSG/wrJmE7SrGW5Q8kvqQj6iEDg3fsLw
 KqjfN0BgyJ+Ak3qALmrP+yZYnN4byLfskJJUU6qWQ+TAfH4d0N/+Qz5Nzgx2sAcyYwtl pA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs29t4aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 20:02:30 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32GJPNh0020511;
        Thu, 16 Mar 2023 20:02:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq46u5xd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 20:02:29 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32GK2TML028656;
        Thu, 16 Mar 2023 20:02:29 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-172-105.vpn.oracle.com [10.175.172.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pbq46u5v8-1;
        Thu, 16 Mar 2023 20:02:28 +0000
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
Subject: [PATCH v2 0/2] iommu/amd: Fix GAM IRTEs affinity and GALog restart
Date:   Thu, 16 Mar 2023 20:02:17 +0000
Message-Id: <20230316200219.42673-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_13,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=692 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303160152
X-Proofpoint-GUID: GItetolSoMqg8DIMyiq862UGiwdLBd3J
X-Proofpoint-ORIG-GUID: GItetolSoMqg8DIMyiq862UGiwdLBd3J
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey,

This small series expands from v1 with one more patch:

Patch 1) Fix affinity changes to already-in-guest-mode IRTEs which would
         otherwise be nops.

Patch 2) Handle the GALog overflow condition by restarting it

I have a follow-up 3-patch series but being an potential optimization[0]
I prefer making it separate. This series just tackles bugs.

Comments appreciated.

Thanks,
	Joao

Changes since v1[1]:
- Adjust commit message in first patch (Suravee)
- Add Rb in the first patch (Suravee)

[0] https://lore.kernel.org/linux-iommu/b39d505c-8d2b-d90b-f52d-ceabde8225cf@oracle.com/
[1] https://lore.kernel.org/linux-iommu/20230208131938.39898-1-joao.m.martins@oracle.com/

Joao Martins (2):
  iommu/amd: Don't block updates to GATag if guest mode is on
  iommu/amd: Handle GALog overflows

 drivers/iommu/amd/amd_iommu.h |  1 +
 drivers/iommu/amd/init.c      | 24 ++++++++++++++++++++++++
 drivers/iommu/amd/iommu.c     | 11 +++++++++--
 3 files changed, 34 insertions(+), 2 deletions(-)

-- 
2.17.2

