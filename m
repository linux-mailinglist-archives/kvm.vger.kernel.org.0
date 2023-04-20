Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26FB6E8BA8
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 09:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbjDTHsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 03:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234145AbjDTHsd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 03:48:33 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F4349E6;
        Thu, 20 Apr 2023 00:48:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TUq/iUPtMt8vqmGddXOghBtRUP1CwaTlnTBRx/wN7aKRHKKLLmtJQMEQo9jMYptw3brYUfhPhMIpas6NTIv+Ntq3uoodYK0DXT8QCNVL2WbjlsMBnWwE6Em8Vy0BhscuTOD8+yWObzGvAWsfAkFbHUHpAZLqeZMeOqnXX3t6xgRZC4qLQ9dQt235fBdg5P9CwKVr6xWjYOmPC9AQdRQf6j6ngMi1u57gAQQoFm79tSzGi7J7VdUULQgcw+LJF6ObXoEfv0Dcjo6/3kZomur+6C/eAT8nLnK2IOfPigMSi33H5zjMS1kHBCfIj0U2lkY0ukrl3m154q0CKlgLvbDlpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3bueHgG3Gzsc9aEiaFZ+vigM5Apov14366JFLRWtVx8=;
 b=aQb+k2ZiwD8ur4l7L9Q8cPleWy3wSJjqHC7Ef4MmFY3od4N2DiuYfktrKBSETMV7z+bfYCT2MIM6TR1rEVr36t4drxS8KzFReF9CMmIKrZuiSau9EvKHX1jN057b2XCckPSn9qFKwrIjENe7YYLGf/4RwXzxMQcLIcAWY61lh2FSI97nME0oL4QW3Fstqksp8P6HVFiaDI8kurQCvdMbt+nPX0gIp4DqrOuGxa2euC9ikbCka0CjqNoKzjhnSpp4RxIgbr6vQAwHpOCejLHyFHYl2AxjLox59LUXLf4KNMGKOIZ61AvvmhfVQCo/RBE6hwAqtIhcVWlBlDFHNQssCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3bueHgG3Gzsc9aEiaFZ+vigM5Apov14366JFLRWtVx8=;
 b=ls6oJ9VqGHcTOx4q/inicZis2PElLEt+74qOc+bllNYQB3akCPzVbxSrW3y0au/ii//8EcPSEIY1UoG9JMvodFEvdqGkfINP4u3jzY/wBKf+0luKA494N1ePTO89KC7/OCIn3DhySrubwwA7/zkazsCe+PNg9ytUGZYuaWKBLma1aGX7qNhV7PSkOkArvNUgmy4VReCTBMXp8eL1wT/lG7bYBjRiuPaIJpL5ondUCCU+r+mtXxUsASqfkbmQNz0i2uAy7FYfFH1Fs+3Xaxp5XnI7Ru2azF02UyVO8qCtdH2uBbgLq3WU+zi62sQiVqwnH+RbOA7RXRKAn1Peub6BoQ==
Received: from DM6PR01CA0025.prod.exchangelabs.com (2603:10b6:5:296::30) by
 CH0PR12MB5090.namprd12.prod.outlook.com (2603:10b6:610:bd::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.22; Thu, 20 Apr 2023 07:48:27 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::49) by DM6PR01CA0025.outlook.office365.com
 (2603:10b6:5:296::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.25 via Frontend
 Transport; Thu, 20 Apr 2023 07:48:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.25 via Frontend Transport; Thu, 20 Apr 2023 07:48:26 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 20 Apr 2023
 00:48:15 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 20 Apr
 2023 00:48:15 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Thu, 20 Apr 2023 00:48:14 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <kevin.tian@intel.com>,
        <alex.williamson@redhat.com>
CC:     <robin.murphy@arm.com>, <eric.auger@redhat.com>,
        <yi.l.liu@intel.com>, <baolu.lu@linux.intel.com>,
        <will@kernel.org>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 0/3] Add set_dev_data and unset_dev_data support
Date:   Thu, 20 Apr 2023 00:47:44 -0700
Message-ID: <cover.1681976394.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT017:EE_|CH0PR12MB5090:EE_
X-MS-Office365-Filtering-Correlation-Id: 0db6a907-8056-446a-086e-08db4173a060
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7srQVDUMVmLmZihm5dGQQZyDS31Xk4lzbqT0NL98k2G0Che/i6UR7hBYpMOvKv74jh5aJziYYUm47N4BMO7w7dZaaUKAxLx5EoVzgTWghrO9SyKuJfFDd6RxtS2j7IjB25JYK2l33v/EnOToWkme/yt6mX99kDatWRoKXXsO36Y1+QeONS9L1UiBjV1i3dRJRjx3DkwCxXxKPzNZ17X4syKi2X1Gp/gcR1AJ6PMSMasEYZiNqD7E7t9+nZfLLijSjLdejZ2+UEaGOJwe8WnkYCRw/7eYUDzITgEp+2STlafW4Q7Vl614LNOXDJKFHrv8ddXA8b0pum311ORW1nlR9xI5p0ORSo1fS/bvlL0bfeiKuas9P3I8zu/ALvh7JUJgfLsG/k7xfqzwg0g+88If061xMND0jEyNuw95mrG4TwPaDYxukl6auS2y4FqJwFW3qRgl9cCAS1JWQqJysVZv2/dYyMHfAa9e/2bfqpqpSYVz+5/pUM0LoJWjJ+NCw9AvELebKg9Epjjm1mSA0OuGiIkTmvEDhPDHx8p4BOdk/VDqcxIIZ6j7i23BL2fhJz3E4pR3qaF/MHWDXoYdS5vG78QUQ/xhLRuo1Tzk1cGF4YzrhEOZfcX18dd7d9KHr9Htz0NFyGeyvfIQCyk8Rz6pYB2TgSs8dabpD8v6tSkqccyEa9kw5nPqE7/vE8OX8yt17Y90pIEmsQIjIMNPw236vnb/j912tq2zdEzZZudmz/RQMmjCcQVbPIZCM9cy7WqNzpMpT1Iqdddiig5RluokwbfOj3N2JKr51Ic6KkehieNyqpem/XCBPNfJ2bVJ0gq8
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199021)(46966006)(36840700001)(40470700004)(4326008)(316002)(54906003)(110136005)(966005)(70586007)(70206006)(186003)(40460700003)(26005)(36860700001)(47076005)(426003)(336012)(2616005)(83380400001)(40480700001)(5660300002)(41300700001)(8676002)(8936002)(82310400005)(478600001)(7696005)(6666004)(82740400003)(34020700004)(36756003)(86362001)(2906002)(7416002)(7636003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 07:48:26.9343
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0db6a907-8056-446a-086e-08db4173a060
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5090
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a pair of new uAPI/ops for user space to set an iommu specific
device data for a passthrough device. This is primarily used by SMMUv3
driver for now, to link the vSID and the pSID of a device that's behind
the SMMU. The link (lookup table) will be used to verify any ATC_INV
command from the user space for that device, and then replace the SID
field (virtual SID) with the corresponding physical SID.

This series is available on Github:
https://github.com/nicolinc/iommufd/commits/set_dev_data-rfc-v2

Thanks!
Nicolin

Nicolin Chen (3):
  iommu: Add set/unset_dev_data_user ops
  iommufd: Add iommufd_device_set_data and iommufd_device_unset_data
    APIs
  vfio: Add dev_data_len/uptr in struct vfio_device_bind_iommufd

 drivers/iommu/iommufd/device.c | 65 ++++++++++++++++++++++++++++++++++
 drivers/vfio/device_cdev.c     | 19 ++++++++--
 drivers/vfio/iommufd.c         | 13 +++++++
 include/linux/iommu.h          |  6 ++++
 include/linux/iommufd.h        |  4 +++
 include/linux/vfio.h           |  2 ++
 include/uapi/linux/vfio.h      | 13 +++++++
 7 files changed, 120 insertions(+), 2 deletions(-)

-- 
2.40.0

