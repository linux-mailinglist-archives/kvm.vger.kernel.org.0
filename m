Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C38E6FD452
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 05:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbjEJDee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 23:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjEJDe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 23:34:28 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765BF2106;
        Tue,  9 May 2023 20:34:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RU05401MY08BiS6xiy1FcOla3aAyiHL5xbJuZUzZ3T83pK8jKLo9orTcQNWl4v1+FYTfCrViLudfZSFSCkHWXclsBXciTpF1LfVTCAPCq6t81qeMXJ+fWUdRCg/yPiNqN1QuXL78dT7nPSbPKQC+rWqg4ghYJzDH1afa7L2oGSmBzLXq8mdNwBxdK20xLkaLrx/yJNjfM7M1oGvZ7WhzgvKYT29S6BbM1ePxcuCgIRKraE08hST6b2XYvBQT7F4wRyhN8X0QfQ/5a9nhHva7Y77AzSfZZEJEZF3YjQnf+2M7wNmyjFwOEPhtPuq1eJZZmaN2C06OF+aSVdXuMPrghQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ykmkw5RtWsKK04pdCG62YjB2lEQt4XEWrgruyTEakjg=;
 b=ju02c9p8SVmp6KtzGQ9V2lh96OCEMdvP7w/a1rp7+0kX4M52e6HDtnmNCysKsWYOQ3ufNYPFNPVIhgXTBtmeJ0nlcdqURIEgyXmbnNgbOlf4dTCJPbomwBuONdKoItkFyPK1nE6yTTdaxVxZYTwjezXM3NYDYQ7i779lqo97z5S7o48CRNOa9TFTtiWnsb4U/4NfpN/yzq/vMft+KsBPHci91R7YiSEUxgi0+0uxxgBHbO3Ab/WzEBIDy3HqwICInLaQMfiWVvNm4otZte43bFFV+TfMFK2HWm/CukIo1aEiRhYmx1R5uOd+lfyHAMy9SUBp+fohh68YWGGZDuwg1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ykmkw5RtWsKK04pdCG62YjB2lEQt4XEWrgruyTEakjg=;
 b=ZRLPY+KPFSI9GqHMJtr37x/zX22E+vhyNKq2+bGv4vwZCkTrVE9SZxQTvxzONWOMifbcC5ismhiS7DRsce+X5rRuLx+evoO1RxdbYEIOeYZwmIjFht5p5sEGAKNoYJtYeOJ2bEMiNEipuc+rADjMpAXL6kWEsVnQrZnCxv4zSJ90IDRSrKuLt1J6CCDeiUzuRogVKHaFjZhaYZtZs9q1GiUlNyw0aqYvrZizAPHFwQCx2So7025IWxnp9451M2FtfOYSpLeoV7YhNNytazxZwEhHtQzsK65SROjQFU2Vqh8pWDKUqrwhEw7uH9lxle6iMSaFKZZByv26g1sD1T+ocw==
Received: from BN9PR03CA0197.namprd03.prod.outlook.com (2603:10b6:408:f9::22)
 by DM4PR12MB5392.namprd12.prod.outlook.com (2603:10b6:5:39f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Wed, 10 May
 2023 03:34:25 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::76) by BN9PR03CA0197.outlook.office365.com
 (2603:10b6:408:f9::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33 via Frontend
 Transport; Wed, 10 May 2023 03:34:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.19 via Frontend Transport; Wed, 10 May 2023 03:34:24 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 20:34:13 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 9 May 2023
 20:34:13 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Tue, 9 May 2023 20:34:12 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <robin.murphy@arm.com>, <will@kernel.org>
CC:     <eric.auger@redhat.com>, <kevin.tian@intel.com>,
        <baolu.lu@linux.intel.com>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>, <yi.l.liu@intel.com>
Subject: [PATCH v2 04/17] iommufd/device: Setup MSI on kernel-managed domains
Date:   Tue, 9 May 2023 20:33:24 -0700
Message-ID: <4e70a7985a2921db3a91539c690a9a86c4e1a184.1683688960.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1683688960.git.nicolinc@nvidia.com>
References: <cover.1683688960.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT009:EE_|DM4PR12MB5392:EE_
X-MS-Office365-Filtering-Correlation-Id: 4241ab29-525e-485f-d4a2-08db510773a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /TQvlcdFER7jTdnoZZ6x31g26uR4mJVOMmllGXwcaNepKQlYFoQ/4MiSbLcX/ue/N4PtpvGFBfYdeEPwaxMZAIrS19e4T8d4OmpDf6J1VKQfYqlU0s5JdV04a8CUldHzXxv+DlbpEcyNSWN4irB5KodH8gR8Mui4wn6t4nQY7aL+D8/NGS0lQ5ckNQsZgAXFM3YEfxUY02xK5dTpg44lH+8hr170/vmmGNyykSm5GVIUqBPm481SpmCXlFWZDmoyzj/mkEl9pgpJUlPoYZUrjrnl+CC+EDbcCYINlzx56kc6su7GDLF1JasvWeyHtGzJd7INL2NP2Ufuwpp4eCFQUTPL9WEu6ShQeay3RQN0yDS2bCQmydK/3ty5n28ZKLccCJ9vdyxI3RUFcUwksfxp8WmxrCit7/H/pn0wt828J5gyJ+l1ML93SmkOrGvGbHWyXcBk7FRFJM1Fu02nZQm8+VIyr8GoUcEgV50F1sgoxjWZfFGnDMD5JaaX3RZiLV7JWY7BNCQ0TT6LjuHURCYOHHWlvt/sHMyuC/Dz1h864JxpLC4ln23fHmSmQv7m/cK5brFrcUZPPziFSXwWYMFoyHygwCOg7C/C5uW0C7QVVhvm70WRwX5qzgJagIFH+Jk2qjbLQ3DvOFk7UrEMNv8XVPXvbj4YzXlaWhc+NZHxOW+oqCR1h7XToPWlvvy7JWkMRuzKH+2E5VlHRpQJvC4pZg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199021)(46966006)(40470700004)(36840700001)(86362001)(36756003)(6666004)(316002)(54906003)(70586007)(478600001)(4326008)(7696005)(70206006)(110136005)(40480700001)(82310400005)(5660300002)(8936002)(8676002)(47076005)(7416002)(356005)(41300700001)(2906002)(82740400003)(7636003)(186003)(36860700001)(26005)(336012)(83380400001)(426003)(2616005)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 03:34:24.8076
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4241ab29-525e-485f-d4a2-08db510773a3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5392
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The IOMMU_RESV_SW_MSI is a kernel-managed domain thing. So, it should be
only setup on a kernel-managed domain only. If the attaching domain is a
user-managed domain, redirect the hwpt to hwpt->parent to do it correctly.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/device.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index e40f576fdf0e..e403cf6c336d 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -351,7 +351,8 @@ static int iommufd_group_setup_msi(struct iommufd_group *igroup,
 	 * call iommu_get_msi_cookie() on its behalf. This is necessary to setup
 	 * the MSI window so iommu_dma_prepare_msi() can install pages into our
 	 * domain after request_irq(). If it is not done interrupts will not
-	 * work on this domain.
+	 * work on this domain. The msi_cookie should be always set into the
+	 * kernel-managed (parent) domain.
 	 *
 	 * FIXME: This is conceptually broken for iommufd since we want to allow
 	 * userspace to change the domains, eg switch from an identity IOAS to a
@@ -359,6 +360,8 @@ static int iommufd_group_setup_msi(struct iommufd_group *igroup,
 	 * matches what the IRQ layer actually expects in a newly created
 	 * domain.
 	 */
+	if (hwpt->parent)
+		hwpt = hwpt->parent;
 	if (sw_msi_start != PHYS_ADDR_MAX && !hwpt->msi_cookie) {
 		rc = iommu_get_msi_cookie(hwpt->domain, sw_msi_start);
 		if (rc)
-- 
2.40.1

