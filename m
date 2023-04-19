Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D354A6E826D
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 22:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbjDSUMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 16:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjDSUM2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 16:12:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B93AEC
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 13:12:27 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33JJoW0q010120;
        Wed, 19 Apr 2023 20:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-03-30; bh=IcRBhNzpOujf9lRsRbXp54jzNtmUxC1J7zBRJIQtbm8=;
 b=T3MRKi0Am7fs0o+skfthGnoeSDC19VX5Cxwy47S/Uy0r/pq5UAh9/+ywlEgNHZwB+diR
 VczTqazMwDkMpveTJ82OkknIoV22AZbdCJRA2u8S//Tno7anBKtFqtjjhQxu2JyP6rZV
 /AahWZTSbV4Bqosx+Lbgva+50JSk7Ok0dYS7Bq9r9C74VQFciB3ry8Ac0piz7+eaHNJv
 mZjsydlQgUQVQ9f8MX53absT9RviwOJ//pEekQ+mdnGpSfC4KyEVAyNzUx3FelYEL2Zq
 OkcSt8q2JxoiSvyWFwVgeC4RRW5m7ultEhmWvsY4FzSdCwyCMynGZ4xPvCRzmDIkhriW Rg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pymfuh857-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 20:12:10 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33JIoXq1011116;
        Wed, 19 Apr 2023 20:12:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjc6wx01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 20:12:09 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33JKC8Qg016607;
        Wed, 19 Apr 2023 20:12:08 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-164-99.vpn.oracle.com [10.175.164.99])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3pyjc6wwxu-1;
        Wed, 19 Apr 2023 20:12:08 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     iommu@lists.linux.dev
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v3 0/2] iommu/amd: Fix GAM IRTEs affinity and GALog restart
Date:   Wed, 19 Apr 2023 21:11:52 +0100
Message-Id: <20230419201154.83880-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_14,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxlogscore=712 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304190174
X-Proofpoint-GUID: iTDeIBDvBXc8c_vNkfJPHttZSgmXFZjD
X-Proofpoint-ORIG-GUID: iTDeIBDvBXc8c_vNkfJPHttZSgmXFZjD
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey,

This small series fixes a couple bugs:

Patch 1) Fix affinity changes to already-in-guest-mode IRTEs which would
         otherwise be nops.

Patch 2) Handle the GALog overflow condition by restarting it, similar
         to how we do with the event log.

Comments appreciated.

Thanks,
	Joao

Changes since v2[2]:
- Fixes commit message spelling issues  (Alexey, patch 1)
- Consolidate the modified check into one line (Sean, patch 1)
- Add Rb in patch 2 (Vasant Hegde)

Changes since v1[1]:
- Adjust commit message in first patch (Suravee)
- Add Rb in the first patch (Suravee)
- Add new patch 2 for handling GALog overflows

[0] https://lore.kernel.org/linux-iommu/b39d505c-8d2b-d90b-f52d-ceabde8225cf@oracle.com/
[1] https://lore.kernel.org/linux-iommu/20230208131938.39898-1-joao.m.martins@oracle.com/
[2] https://lore.kernel.org/linux-iommu/20230316200219.42673-1-joao.m.martins@oracle.com/

Joao Martins (2):
  iommu/amd: Don't block updates to GATag if guest mode is on
  iommu/amd: Handle GALog overflows

 drivers/iommu/amd/amd_iommu.h |  1 +
 drivers/iommu/amd/init.c      | 24 ++++++++++++++++++++++++
 drivers/iommu/amd/iommu.c     | 12 +++++++++---
 3 files changed, 34 insertions(+), 3 deletions(-)

-- 
2.17.2

