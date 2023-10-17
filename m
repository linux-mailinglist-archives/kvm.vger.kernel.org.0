Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402747CC4F5
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 15:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343935AbjJQNnN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 09:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343910AbjJQNnL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 09:43:11 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C695FD
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 06:43:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gIeYf8cl1DhCI/MhYTPnLyW00nVGx6+v6D6NbKxyAEZwkwSkjAoHoBV6DN8rWrbalT7J8JJJxuKZ6CPp7YIdrbrWlWeteC+DIGP27e8lyYIJCdeZYbqbiKksChDewHPD6TiVqwTK1gDAgG3Arlz3fa8qkBs7W6/texAmKsh1See8YVved9VxMgtbWhHIlq18dsEu04Uw4ev/+mTEaDjCNdZnwuHZHrpIjvKURG2z+kpofR1X+UInxoB6ykE0UQa7psd76T89K+pCUhnvyax5QikvVUPRgmk2w5y9OPFq1moB5RXnmQp7YMAL6CSOZBPT6UCnev9ID5fgLv6POj2Wag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZK8oVP00vpc6UQUa3hMRt2UjQkZntth7M63FfSSA9Po=;
 b=KRBkW7m/HTNVfPDyfDJI8rmLnfKtIj72K4ix73L7G+r03QJSAT6Mv3+yEHGDa1Jrbb3+xGBAoc9MmE66uAYtz1Gstm5JxMfc3rBKaN8x9eFSUmilikW0mKBQnjVl4bTm6B+F5awiXME6HOClK6FNgqNErFlbpXeEalC4+WBX6Lfz+brXmg+KnQ0LQiq5mFV6ieum44gTe+qEnv7jofpwSw6Gec37Wdk0bZCp4YvfxmJFqd+fDkGLpO3h/N2i7atQ2nB6I3LBZJFIMNsiXp9IkRJIKoHCPaoqPaLAprNt3P4jlB3cLeDYo73sgukSMARINxnwW4JleaRucTO2955xBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZK8oVP00vpc6UQUa3hMRt2UjQkZntth7M63FfSSA9Po=;
 b=aL1mk3gm6jmFYZtE25jOYA5mSCQPWm+z9/WtMj2op4ELU0ARrw/g9hPhPyipCE4J8QG511B4It7g/9AtUuBui6fp+VoHxnY4AWsC9/ve6ZSmxEuOqLw1igGIOv/oi9KX6CxYWPWbtY3+qiNzhaCBVY2MR3UZhlmgEzw9unl6WS3Guvun1SXSRL7ay4xHRPYYWc/rpcD103e1KcQOJoSUp/VpDw+If/OvPK9H3BJw9F4HgrIQZSwOToMKlfMIxfBt+T4z1xuxB8b/uI70PPi5LdCMnXBL0ho7/dpGLMt2pp54S8jUnBJolROoyRlrS6YmU9JcA1AP3o7oxFI5oMv1aw==
Received: from SN6PR04CA0080.namprd04.prod.outlook.com (2603:10b6:805:f2::21)
 by BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Tue, 17 Oct
 2023 13:43:06 +0000
Received: from SA2PEPF0000150B.namprd04.prod.outlook.com
 (2603:10b6:805:f2:cafe::23) by SN6PR04CA0080.outlook.office365.com
 (2603:10b6:805:f2::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21 via Frontend
 Transport; Tue, 17 Oct 2023 13:43:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF0000150B.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.20 via Frontend Transport; Tue, 17 Oct 2023 13:43:05 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 17 Oct
 2023 06:42:50 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 17 Oct
 2023 06:42:49 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Tue, 17 Oct
 2023 06:42:46 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <si-wei.liu@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
        <maorg@nvidia.com>
Subject: [PATCH V1 vfio 2/9] virtio: Define feature bit for administration virtqueue
Date:   Tue, 17 Oct 2023 16:42:10 +0300
Message-ID: <20231017134217.82497-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231017134217.82497-1-yishaih@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF0000150B:EE_|BY5PR12MB4209:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a9dad0c-7a6b-4158-3929-08dbcf16fde0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UiS20Yi8RvMnrmuDMi0sVeiKyXRtytGrPfHgIYyKA40tzfKhh0aaJ++/smYA07x98zjMxSHomHc5ek9kCBC3IgNTRoUCBTnCLbRTHXlFTXvd40MoVRs/UnAOxQYJoSibZeDrOostQlu+gcdWz+oQr7XV98JoQ08HG+HsV6MZm2lz3OwFvHXg2thXcNE8+AyiVgy4UkRm3LlXf1n3lNMkq/4lQrkqCqHjpzqcI4Qcf1jDHSZAIxE3gPrvF/sSjOwFTY3d1CKfvt/J42NiCcDbxnMiCgrDOeYPmc65xNwms0zFcTDroVzcXtbnB5onyXs3u0hVRWdwOXKmlS6abZ79NC/m5iLjeuYuZoR0bM1re8esq548c6Asub5IMBW36vWb47qVsfORbnWxG+C15A65uRQePVVQGrb+f8JSVC3bi/iVgsxZB/tyY3vy1ddgW9EzBh4pFj+5wn+pl2rQSrwUrr+1a6/XZGcEHE4ED5vY9IT32rjeK3YbxTWmMFmyAjPz+uNq5ZFgriRur/DCsggpgSfhTutES4iO85nBYWTxcYJuAksxo4ElKnhqYkcNdY/+NLWKGQ10TYaRB2PapL8BCSk1NzG7drxNJEB4ESUUqB5UqwiZ18cpYiVvDHqte0D2PKaz8EJfwUt05vuAPrvUVVw0RIwxthSZaJ6FBCoPY2px5h0DfMxH/ExD8JubLuEOKZdqhljYq+IpULkw042LPlEGpVaWLmaWqzB8o7orVCUTsY48kX+LDmQt8rR8Fi6bDA1YnHxEJv4SPNtEAJw64g==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(396003)(376002)(39860400002)(230922051799003)(186009)(82310400011)(451199024)(64100799003)(1800799009)(46966006)(36840700001)(40470700004)(40480700001)(2616005)(336012)(26005)(426003)(1076003)(54906003)(107886003)(6666004)(8936002)(47076005)(8676002)(41300700001)(478600001)(4326008)(316002)(110136005)(6636002)(70206006)(5660300002)(70586007)(7636003)(356005)(36756003)(40460700003)(82740400003)(86362001)(7696005)(83380400001)(36860700001)(2906002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 13:43:05.7211
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a9dad0c-7a6b-4158-3929-08dbcf16fde0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SA2PEPF0000150B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4209
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

Introduce VIRTIO_F_ADMIN_VQ which is used for administration virtqueue
support.

Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/uapi/linux/virtio_config.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index 2c712c654165..09d694968b14 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -52,7 +52,7 @@
  * rest are per-device feature bits.
  */
 #define VIRTIO_TRANSPORT_F_START	28
-#define VIRTIO_TRANSPORT_F_END		41
+#define VIRTIO_TRANSPORT_F_END		42
 
 #ifndef VIRTIO_CONFIG_NO_LEGACY
 /* Do we get callbacks when the ring is completely used, even if we've
@@ -109,4 +109,10 @@
  * This feature indicates that the driver can reset a queue individually.
  */
 #define VIRTIO_F_RING_RESET		40
+
+/*
+ * This feature indicates that the device support administration virtqueues.
+ */
+#define VIRTIO_F_ADMIN_VQ		41
+
 #endif /* _UAPI_LINUX_VIRTIO_CONFIG_H */
-- 
2.27.0

