Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8FCA79AD03
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 01:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbjIKUs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235814AbjIKJkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 05:40:01 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4190910C
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 02:39:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnEBe7VrS5Znqb73skArMSONRa7L1UFRsTo21ClnvwSB1OGfFLBcsS4sC3gnAPcz5btf54KCzu5Fme6EUD7k7PI4MLiKBEtGVbIrckR2gqbMJWI/6J+TA+RIH6qOq/EOhovbvRRAtnnox1KcrzeFMFffSrogJyjTTd5wZMNvCbBjgzbG9HSQ1z96XQsbykwUiP8YGPFDpcEUxY+XG91VzOs44T9VkZhrjon7ZhU60tW7fuTcLq8aXriSdfgk4I3l4CIDHBPV5bJUvaDP0UWUtpgbk9C3BOyg2KYsoqddL/3RK5cXA3Uw5oW/JW6z8NL087xwT3E8Iwq+lieBMmZI7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vE8LausPLFh5fMMZ8j0TsraGGqpk45wHR1R8uT/+T8Y=;
 b=oSHMeVMjTE9Jusns7jnvJ47NsBq3vWKWmHv1U7EysSo6NrG6RsInBcCSkCrB9RUXtfkzHDRGUn3hJ1q9168s2uaEILph7BtcZpOTfJFUevB34ToM0pdJpw3zPhzdwR4yKupqQaVY2q2dh7BI/zjz9bTaRUHrCApiPBj/ejFFVu8B24CETVNtbKmD8pRpBVPtz8WjaRgQpwBmeBKOjOvVs9EuVpWoquO9hLvJAYwtEUzypQ/tMsYfDvVl1bgOFe4YsFeN9fc2/90oeW0jeLFvbyLY7yJUCivTu8dRipZRw0/XsGUxjoYW/iwJIThHrDEDHg2IInsZP1U7+6OB97YRTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vE8LausPLFh5fMMZ8j0TsraGGqpk45wHR1R8uT/+T8Y=;
 b=aGsSb+dYIvYVRMzynp7ejqy33yZhrexWcMyhH57WomJcKV5Sj+X8+0xgaj7swV7SKyo0SK4sfSoCxw8HBvLZ+rJqVWPZaL5x9ND7X0YqlFqCgy/Y+FSgDkyrQKr41kUMESTXd9B/EOKMp5262biV+y2f1S/ll5oVZsFRV9hPVSiq3mzcrmJFKbyOM0oEVpE6II7HpqjwWMDhgblg9FWY50ABl1xA3oEg63FAJ5gwqAw09aeWWNoNZEfdRhfthpVszN+5WBbbOwtUJV62mNEY+DnPAkYJa0dkaVbAZyHnP9lGrgeFjxspGRx0LoXRfv+pGMbswBa7vnU48JBmTWyrQg==
Received: from MN2PR11CA0027.namprd11.prod.outlook.com (2603:10b6:208:23b::32)
 by PH7PR12MB9222.namprd12.prod.outlook.com (2603:10b6:510:2ef::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Mon, 11 Sep
 2023 09:39:54 +0000
Received: from BL6PEPF0001AB58.namprd02.prod.outlook.com
 (2603:10b6:208:23b:cafe::81) by MN2PR11CA0027.outlook.office365.com
 (2603:10b6:208:23b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35 via Frontend
 Transport; Mon, 11 Sep 2023 09:39:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB58.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.16 via Frontend Transport; Mon, 11 Sep 2023 09:39:53 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 11 Sep 2023
 02:39:42 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 11 Sep
 2023 02:39:42 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 11 Sep
 2023 02:39:40 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH vfio 0/9] Add chunk mode support for mlx5 driver
Date:   Mon, 11 Sep 2023 12:38:47 +0300
Message-ID: <20230911093856.81910-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB58:EE_|PH7PR12MB9222:EE_
X-MS-Office365-Filtering-Correlation-Id: a6caacd2-27c0-415d-02e9-08dbb2ab0db0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UMjRH8pD3jU0vPKw2nA67tBozKdrobDP7D+1QtcPbx085AUreqLDvWtzPaZoqS0VIAP6daa47fWfQ0T6SWFD0FhxpGVfd/Dzvxoy0ozH9FCrVDVBamnPElTIhKnAte6lnZasorIoqoATxTF2/lcu/9SxM/pao4mgabQKRDfWmPl2WriaekM/kF7p9MU60lJbHYQbRtbaGvmJyP+B2M052VEWa/XbHWlLpDmlmsIHHdYc9dBe4+ux5k6DvXO8e4uGLRBE4eXSIdB0XSt9dGBK7yFYnNeKVyOA+vki4ORLCbWCN6JFR5/VXwia/7v5KSYK2EHyVPVs0NNze8YgydD8xLy6UTzs7XD4KORCMVRMfc2LMIEHdjA7OtSqsttxUZPbR8HPOHedtd8nOvtN4KY8raPOFnpFTQJh1w8Jbex8as+HPEpoA4c9IU9CRIjbIxwmYy+VpM4puHsKnkwc1VHO3AZJxpDvbrwlCimthhhP5OrDb6YaMkDYqGs8Ym+mGdDec/JSVncL2VTxGRqTaDtSt1YTGEkkc8lDqQI2nCVIsWnj9CI6/XJFO74EuuyBYdYmSThuKN6iqHGKG9kznID5F845Ng6bs8KocTPp1/4K1Dkyybs+2bu7QlCzSqGhQwoRZ4Vo00KEgKujc3zGu0m9I8R/6jqHH0CEySvWuWWekMqeWXX9JMrj3I7SEJFsrkzcw8XSyKrFEd4HsVib5vkCBh6cvdKpyOsNTYDA1ml2cdkJJVTK1mjmkq7wArVG5Ndv
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(376002)(346002)(136003)(82310400011)(451199024)(186009)(1800799009)(36840700001)(40470700004)(46966006)(7696005)(83380400001)(426003)(2616005)(26005)(478600001)(336012)(110136005)(2906002)(316002)(41300700001)(6636002)(54906003)(107886003)(70586007)(8676002)(70206006)(8936002)(5660300002)(1076003)(40460700003)(82740400003)(40480700001)(47076005)(36756003)(86362001)(36860700001)(4326008)(7636003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2023 09:39:53.9972
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6caacd2-27c0-415d-02e9-08dbb2ab0db0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL6PEPF0001AB58.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9222
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds 'chunk mode' support for mlx5 driver upon the migration
flow.

Before this series, we were limited to 4GB state size, as of the 4 bytes
max value based on the device specification for the query/save/load
commands.

Once the device supports 'chunk mode' the driver can support state size
which is larger than 4GB.

In that case, the device has the capability to split a single image to
multiple chunks as long as the software provides a buffer in the minimum
size reported by the device.

The driver should query for the minimum buffer size required using
QUERY_VHCA_MIGRATION_STATE command with the 'chunk' bit set in its
input, in that case, the output will include both the minimum buffer
size and also the remaining total size to be reported/used where it will
be applicable.

Upon chunk mode, there may be multiple images that will be read from the
device upon STOP_COPY. The driver will read ahead from the firmware the
full state in small/optimized chunks while letting QEMU/user space read
in parallel the available data.

The chunk buffer size is picked up based on the minimum size that
firmware requires, the total full size and some max value in the driver
code which was set to 8MB to achieve some optimized downtime in the
general case.

With that series in place, we could migrate successfully a device state
with a larger size than 4GB, while even improving the downtime in some
scenarios.

Note:
As the first patch should go to net/mlx5 we may need to send it as a
pull request format to VFIO to avoid conflicts before acceptance.

Yishai

Yishai Hadas (9):
  net/mlx5: Introduce ifc bits for migration in a chunk mode
  vfio/mlx5: Wake up the reader post of disabling the SAVING migration
    file
  vfio/mlx5: Refactor the SAVE callback to activate a work only upon an
    error
  vfio/mlx5: Enable querying state size which is > 4GB
  vfio/mlx5: Rename some stuff to match chunk mode
  vfio/mlx5: Pre-allocate chunks for the STOP_COPY phase
  vfio/mlx5: Add support for SAVING in chunk mode
  vfio/mlx5: Add support for READING in chunk mode
  vfio/mlx5: Activate the chunk mode functionality

 drivers/vfio/pci/mlx5/cmd.c   | 103 +++++++++----
 drivers/vfio/pci/mlx5/cmd.h   |  28 +++-
 drivers/vfio/pci/mlx5/main.c  | 283 +++++++++++++++++++++++++---------
 include/linux/mlx5/mlx5_ifc.h |  15 +-
 4 files changed, 322 insertions(+), 107 deletions(-)

-- 
2.18.1

