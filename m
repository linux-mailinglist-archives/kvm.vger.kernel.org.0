Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376D37CC4F4
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 15:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbjJQNnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 09:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343667AbjJQNnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 09:43:11 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D32F9
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 06:43:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IpFmKXzdX4HWd7icPj0fHz3cncm33lneQ80+Pa2qZjaQtdpf4kY1RUdiY36BZ20OLZyO0bdQ3Tw2NnPaq5LCcarXXUhMt+DtFvd1PLJZMNO/3TZsg4ev85hfbJXKJs6XbIlUca6mKZA3bANVz9r32GTO6p2dx5xmlnYX7+rFnUFBmGJq2K5138CymgMXVKTLtkFwwkT4USl4A/E6GrSpjljjydlq7fuVT/grc1E8YKy03ALo1tFHfwhlRdWwBWpfzuzcORd1HknPP5stiNydr2mKgEF4UwQOgcye8F4F6R/RMJD/JxunGzAqtZZ4kAozMyDUYS/yu4Nv91anu7NQ6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OEvrPSQf+U4XaJyHIss93E4xxxdA4cdf3/34u+GHgiU=;
 b=ZwJASs6GP0AFVB8iQPPs+H6CCX5AdXau5CnuAbV5g/Y+7pRvT768A+fIz7heOytsk3I0xGRVv9L6FVdoe7WfRflqXjYqjoan2xT3g/kpjN1JEycfotzjPzfZycuDdx2ppi4BqIei9EBwrdy5Y1/3Mw14mB7avLQsPSCCOl+ttn03/DBSyDVj7n8QhOPe8IIQ5fNkFpM6aev/WTeKJrPmKee2Nd4iohsAYvlmE4JyoGmXQharwHEW6+4ytDWI93DSlAL/yVO50kn2wZfeejoVKRPGXp6gylMnsW5Cfc4LSivhOMMaUC36oS8nYfviLnnPjvMij0UKX2JK8YkAf9rTYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OEvrPSQf+U4XaJyHIss93E4xxxdA4cdf3/34u+GHgiU=;
 b=SIPSxRWryDKApiW8IG58KSSzsY9zsT5xoubBcUhIr0WJ2Dt1qMqblh93bNTiKGQrc90REPtCBdLYgOpsPPRWeXWlF9RNRgTgXROlEJMWUFwwb9n07Git3v6f8+at20yu6S2iQXkDAhtxgD0MVt9OGiGLVDXMJkmUjpRY71lV4UFBPUPRuxixXntS+BBWf8c8meGcspxynWygQtvvqEStEB6v/PG8Mn7ET/Ck186WfqJfYyrdCHl3N/1bm2hdF7QGgFUKnzlThiNz3auLQSh/O+AuKBm3JUJ0+2L6Sp7YsBqOh+HH2RhtI05O+RpySQnnL+Mneu5F39fokmE4xUN9MA==
Received: from BN9PR03CA0740.namprd03.prod.outlook.com (2603:10b6:408:110::25)
 by MW4PR12MB7439.namprd12.prod.outlook.com (2603:10b6:303:22b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Tue, 17 Oct
 2023 13:43:04 +0000
Received: from SA2PEPF00001507.namprd04.prod.outlook.com
 (2603:10b6:408:110:cafe::61) by BN9PR03CA0740.outlook.office365.com
 (2603:10b6:408:110::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35 via Frontend
 Transport; Tue, 17 Oct 2023 13:43:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00001507.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.20 via Frontend Transport; Tue, 17 Oct 2023 13:43:02 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 17 Oct
 2023 06:42:46 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 17 Oct
 2023 06:42:45 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Tue, 17 Oct
 2023 06:42:42 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <si-wei.liu@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
        <maorg@nvidia.com>
Subject: [PATCH V1 vfio 1/9] virtio-pci: Fix common config map for modern device
Date:   Tue, 17 Oct 2023 16:42:09 +0300
Message-ID: <20231017134217.82497-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231017134217.82497-1-yishaih@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001507:EE_|MW4PR12MB7439:EE_
X-MS-Office365-Filtering-Correlation-Id: a203440c-1c07-49e5-2ab9-08dbcf16fbe0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0n1XQwx98rOS3r3rk25rnrwfmAiOuqgNt1LqiOqyishpClZAeQkZohhUKqYfs0iw4WPN/JhXB+CcgE2ONJcNAaBfngd4aCb050VOvCEm9WLW8YvKL8gn1UaKxKJwZivtBC8BGsinRbu5+3CrAYDIhnZcnm9+A6XV48FYeczjU6xezgviMHZHhzho17eFpc3tB1Dsu3m7OKbi+K6apwKRf+UhSj9XSDcj6FggXSEWEe0l+9g6C3uc556xmnrtyvxKQvIBvewx924dy1xrQ6zFbvNL1LX8CJUGffEtk9mg99Wmp4zGxyBWguFuphfIiV9Le1ltNFDSjI9btWX4myaOj8cCoO06ysQFY/rwFLnUuqaUE6BoK/pGR38BOEq6/L1LwwP013T+TlCbWlWHltsRk29YdNCdJEGDxvMaGtPISttqL5wL2xPmWN9jfXHrNE6PR4AT/u2GQQ3Q5bAIRi/yHvFMzK1FGWsWbgUomPqlVAbpLb8L4udi66r6tbr/K2d3tguzHXlgJWw1D7nBv9izBfjRr66uD+iSj3dnIK/7WJF5wAk1iV4/OGWRDHg0JAl7ZGK9nhoDgPrmlRmWGIocChyQbzxgUMsVcCSjkghD7ghc+B7WJoHy2iZm6sVk1K/ugJtF+c9HFd0X92Gc42kUCEVP9eAEWITK1tZYovfC5EZYDwrPH0YNDYFmbBq2ZkdA2X1+ojLWgQws4XR6bRMIJOSJUFe6BS1VphzaG+RQ9eH9wKVFdS4s78emrLDj7e4jSdOd31rjAROqNkJ17LzM9Acj9vXvuJBxKmOVzlnIKZE=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(136003)(346002)(39860400002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(82310400011)(40470700004)(46966006)(36840700001)(336012)(26005)(2906002)(5660300002)(41300700001)(8936002)(8676002)(4326008)(66899024)(40460700003)(70586007)(6636002)(316002)(70206006)(110136005)(478600001)(966005)(6666004)(7696005)(426003)(36756003)(83380400001)(40480700001)(1076003)(54906003)(86362001)(107886003)(2616005)(36860700001)(356005)(82740400003)(47076005)(7636003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 13:43:02.3653
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a203440c-1c07-49e5-2ab9-08dbcf16fbe0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SA2PEPF00001507.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7439
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Feng Liu <feliu@nvidia.com>

Currently vp_modern_probe() missed out to map config space structure
starting from notify_data offset. Due to this when such structure
elements are accessed it can result in an error.

Fix it by considering the minimum size of what device has offered and
what driver will access.

Fixes: ea024594b1dc ("virtio_pci: struct virtio_pci_common_cfg add queue_notify_data")
Fixes: 0cdd450e7051 ("virtio_pci: struct virtio_pci_common_cfg add queue_reset")
Signed-off-by: Feng Liu <feliu@nvidia.com>
Reported-by: Michael S . Tsirkin <mst@redhat.com>
Closes: https://lkml.kernel.org/kvm/20230927172553-mutt-send-email-mst@kernel.org/
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio_pci_modern_dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
index aad7d9296e77..7fa70d7c8146 100644
--- a/drivers/virtio/virtio_pci_modern_dev.c
+++ b/drivers/virtio/virtio_pci_modern_dev.c
@@ -290,9 +290,9 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
 
 	err = -EINVAL;
 	mdev->common = vp_modern_map_capability(mdev, common,
-				      sizeof(struct virtio_pci_common_cfg), 4,
-				      0, sizeof(struct virtio_pci_common_cfg),
-				      NULL, NULL);
+				sizeof(struct virtio_pci_common_cfg), 4,
+				0, sizeof(struct virtio_pci_modern_common_cfg),
+				NULL, NULL);
 	if (!mdev->common)
 		goto err_map_common;
 	mdev->isr = vp_modern_map_capability(mdev, isr, sizeof(u8), 1,
-- 
2.27.0

