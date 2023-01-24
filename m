Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543AA679C83
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 15:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbjAXOuz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 09:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbjAXOuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 09:50:50 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A9049965
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 06:50:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aj08tCt/dy+ykDmRxfu74U9Mhrsd8Yp5wryw0GzGbWBC/N/xI3dnrRJaTQMHmKdoWV7mu+HaImv3cgkYilz7U211CVdn8qQFcaA4M7Z4UHqMot3ikRqXbY5OWmmfd8FkuVpShXArTeky9WBBn106SFyLKkQ4H1480JuMlhrLC/UWp54s9YGnz1NkkcpswLD5GbgWVUOX7qF4OnXVGEBHubv9FCmDAhRqkrrIOkGgoyYxn8cypYyAq6dUhfHVvOg5xgvnsCyxaRPxHBtmriGs71mZEMu3E9RmQ4nsUcpnMUUaSpTJe59qkSheYtoP6EvGxTs7Gr50rb8/WrfnW3ufBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4QwMD+/PYkocCs+KAZRQheG01wGYJldVPz6idTihu7Y=;
 b=EP6dGFnS7Kt8uNPBnFGB0H+nbqKiv0/FJYr6U2IxRHOErKlfWSbG90Io8rQQHI3MaxIdLAbVktEcVKg2cVfD6vttq6yQIaZOOV3+GeTvC0dw+6gENXqdLqtUYZGwEpKeeDcgm10mTTsowhQL3kWwFvjrLFB6Vic+5qpTOMf131pdLrMOcPq5wKNl1gGH5jMIFPGBC1m92i4nU8ESDeg1oxfjmKArgTUzjDmDUtL5yFjuXKkl3NCfwc3ctxaJR4SWI+VQXpbAF3VIyO/bbSpT1DeFHGLav4aCU1Ya8N+r+wrw43eNEuKPgbpeJJOJtMnc6G36NHvRHZBlhJcJC9Z0BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4QwMD+/PYkocCs+KAZRQheG01wGYJldVPz6idTihu7Y=;
 b=hB0eZ4AKnSYdr2DdXBh9L6KK0GWA39DS+b4g8oBrEQ8QzgW4aSJoMo3m5sKEMgQuTP+tfUK9WByZlRbj5ZJ8NJKvbfetS2xD/05CvH/RftGjKIywidVoUssGvUzKnAuSjt7UsArI1K3b0771yYGD4rx2BaROR+FmzlSW8VZn6/BplG96kG/n669OUtVj8432rSPZwm6oetHMfjdQIDZK54KOcriLYhfmA36QrNcGrvejMcR3uG8jCT3iOw9t7U3TQadBUSxQSfoQby6jS6cWFdmw1SfB+keV41NCbhWyyUlH2+2xtNG55MzovQoJEFJ9k2HQ2oATUTK2W995QOgG9g==
Received: from MW4PR03CA0053.namprd03.prod.outlook.com (2603:10b6:303:8e::28)
 by PH7PR12MB7891.namprd12.prod.outlook.com (2603:10b6:510:27a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:50:37 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::aa) by MW4PR03CA0053.outlook.office365.com
 (2603:10b6:303:8e::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 14:50:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Tue, 24 Jan 2023 14:50:36 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:50:20 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:50:19 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 24 Jan
 2023 06:50:17 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>
Subject: [PATCH vfio 0/3] Few improvements in the migration area of mlx5 driver
Date:   Tue, 24 Jan 2023 16:49:52 +0200
Message-ID: <20230124144955.139901-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT045:EE_|PH7PR12MB7891:EE_
X-MS-Office365-Filtering-Correlation-Id: 46d892ce-11d4-49fd-8d64-08dafe1a5a66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EWkn860skc9niYhz7UDoFU0I8SFp4hORHCrOlVx/n+HXSG4cFWBEP7yChPJ+vKy8tmR3Bw7pMgSGJ9UQkOa0WJOfnUEj3/WgdyL6uNqHa8h5oNgb+3cPqrL29qWiFcPVb781eGBFSnIEjWl3eNRnA8ABJkrcd1D84M7K1JB41LjIfD+9vSnD4loXvqiWw6JRgqSXJRNXl0TRvHtpCOxLdnWI7B2g+PMfK1sDRN0JfN6zfF6EhrWMExA4w/+Owlt/IdqVmWn2EX5tVdsPjY9AhK6v3ri0ts2m4PneOo3tJ2QKM/yGTUvrZ6dD+CF1xIL35KKRBAtsUavpJCDrYOsBhZIGmXYIkdJXoL3MAjooJG41xW/+mSuwqqlb1F3D67cKdvc1/V75cf5GKh80GWN7JRYqrNK/Y2rPzH5hepZ34ascKLCg8946O1GBPZVy+nqK/S4x7xz5wqhmFxcd/UOLND3i6xC4GS5HG9mLQ5YrWfe5pS78ntPGJhx8zJqttZ0IkrTOJkTyX22rPmPq29iBqjaZDmYxvlMJiZWfIhdhnpepTcpfuf5vVmB9V46CR0/uxNjQ+rLWLK3gVY9bP8rnqttlx11UA9VFwDcEKXOqjxcYzB95Id6YD06HjhotvWepJ4fqedlkyw1ZmmJAvvmeeVks7VSMb0FHqvcxjjSP3lhWaZYnGSMD/ggZrNHo20U2kWX1BAZgRH+CESsx/I+XD9JUHatULo1X98sKrtI2ckmTcOk+HlYDrXbgSFM0WOPPPCBeSMBrTgerK9OQL73o+pkq2t8GKV79P3nqZkABJI0=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199015)(40470700004)(36840700001)(46966006)(40480700001)(36756003)(40460700003)(4326008)(8676002)(426003)(70206006)(47076005)(70586007)(5660300002)(478600001)(41300700001)(83380400001)(8936002)(966005)(6666004)(107886003)(86362001)(26005)(6636002)(54906003)(336012)(316002)(110136005)(7696005)(1076003)(82310400005)(2616005)(186003)(2906002)(36860700001)(82740400003)(7636003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:50:36.4059
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46d892ce-11d4-49fd-8d64-08dafe1a5a66
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7891
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series includes few improvements for mlx5 driver in the migration
area as of below.

The first patch adds an early checking whether the VF was configured to
support migration and report this capability accordingly.

This is a complementary patch for the series [1] that was accepted in
the previous kernel cycle in the devlink/mlx5_core area which requires a
specific setting for a VF to be migratable capable.

The other two patches improve the PRE_COPY flow in both the source and
the target to prepare ahead the stuff (i.e. data buffers, MKEY) that is
needed upon STOP_COPY and as such reduce the migration downtime.

[1] https://www.spinics.net/lists/netdev/msg867066.html

Yishai

Shay Drory (1):
  vfio/mlx5: Check whether VF is migratable

Yishai Hadas (2):
  vfio/mlx5: Improve the source side flow upon pre_copy
  vfio/mlx5: Improve the target side flow to reduce downtime

 drivers/vfio/pci/mlx5/cmd.c  |  58 +++++++--
 drivers/vfio/pci/mlx5/cmd.h  |  28 +++-
 drivers/vfio/pci/mlx5/main.c | 244 ++++++++++++++++++++++++++++++-----
 3 files changed, 284 insertions(+), 46 deletions(-)

-- 
2.18.1

