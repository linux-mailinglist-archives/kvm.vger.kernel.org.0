Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C87A642CCE
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 17:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiLEQ36 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 11:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiLEQ35 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 11:29:57 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2058.outbound.protection.outlook.com [40.107.243.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EB6CE1A
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 08:29:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ExS+I2u7sHX5uK4rNeKRLavvCiNrMne7L4MJYPAs5YnRcM+amowxSb4ZIVoX5raFWBs2HfJIrjbemSpiGdOcRP1xDRYM3HIUODeY10MdgG8mKD/VNncVLm+IhNXUVb+Ap9jXpgKlf6rPvWQGovcrPOLbPgG5lEKUayLdizZI3S+fpgu8b42gWdVe08FQq+kFIrH0Fc6b78noZeFIPjcyeFirrZFCf//o2Qs0PNZ1yNBV7xVI3IoLvicPJVURbrvpb+zRcaSHwI3E1nt8L5PtedAOmxD34/J4bes1HbHPfCKennwBpSfbeTv7AfcY4zlmUmOCT3+d3C7AIWHwRTKzcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F/zJTi0eWI0chXrQgNNSe9W3k/kkNdUmZrJ624pu9Bc=;
 b=C2nvy/Ct5/LthBDTk8L6Ln1GJl5gJ68Yq3Wf2rm2pVJLVW5Wn2UGA1arI+LsvDGwqnVXY92BYJcQ/A7UbPiO3DDHn5WpMeFnRj+C1aTkrFXHum96SMcqzj60XRBrqY91ovI9IQOy+PLp7k5Tj6jCW+gd07u0Mh4kYNDPcKiIhIfZKNANLI7JOM/5oDYDlxc7BinwPNY16eXtHboSGH+XzF45uV2YVUDSIEQjrNiHuvtJd4lT3o4MWkmVsbZ56cMLt/cgD4pFt7NYtyGMac2HVcUH1FsmaKeI4gbhvYqy2Cxe2SZ7cJOX1P/d8rswe0U/5AJqCZPQH7dIWse5wap+3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/zJTi0eWI0chXrQgNNSe9W3k/kkNdUmZrJ624pu9Bc=;
 b=M/ssk6+c4Ebg3iMiXIdphcOJzGwuE+uEvudkaZcrmLvOZkE+TF7xJb5qvxNJGT5FumQfl9neCtrECm8lWbVIVMBv71dYLxuFxmreBybklukJ0oJkm+yhUmLm4xdlYm+C4Yb8QLmUz3CkVYasjGxFUhFIh+wX3ROFCTh+mbI6nFxN+RTJDjFYjHVHDpmmDDvGlhwtpnGfSQDBNrkgxMzJdx4cIGLfcwrBYmWua8aPQUxdNAs2jVUr3/kSFcCA1x3L7r9pfLAbfNmdz6PccFK08xlHPS1KuqIHbqD5VYH09P3jzbbh6qPBr8NDqTi8j77fZp1WHnV7WiLHpuTP9fOYIQ==
Received: from DS7PR07CA0013.namprd07.prod.outlook.com (2603:10b6:5:3af::19)
 by PH8PR12MB7280.namprd12.prod.outlook.com (2603:10b6:510:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 16:29:55 +0000
Received: from DM6NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3af:cafe::a7) by DS7PR07CA0013.outlook.office365.com
 (2603:10b6:5:3af::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Mon, 5 Dec 2022 16:29:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT110.mail.protection.outlook.com (10.13.173.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14 via Frontend Transport; Mon, 5 Dec 2022 16:29:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 08:29:46 -0800
Received: from localhost (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 08:29:45 -0800
Date:   Mon, 5 Dec 2022 18:29:42 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <shayd@nvidia.com>,
        <maorg@nvidia.com>, <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH V3 vfio 01/14] net/mlx5: Introduce ifc bits for pre_copy
Message-ID: <Y44cdgIO6F8hEL2F@unreal>
References: <20221205144838.245287-1-yishaih@nvidia.com>
 <20221205144838.245287-2-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221205144838.245287-2-yishaih@nvidia.com>
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT110:EE_|PH8PR12MB7280:EE_
X-MS-Office365-Filtering-Correlation-Id: 554d6113-35bc-4b01-da27-08dad6ddf146
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w3Qc7yCp9JAl69hIoeQ2G3Ilg0JeRtOZMF1ozhH2pE9jyiB42VyOD+ZfT0gb8xW0n3uyWhX7iOQ0IO8KDLnf6Q/YFYp1CapWCTfT5ZCFJeZ1REYQBWXCIqb9asB69s6uxfXF2nMYFJHKm2x3t0hoqVP4OcqCdlyVcKM7okhcK8B3wbACxNN4isL79RvdrGNuchPFkSoQ14OMmJTBvSyLurauLBBghoITssmJ9BnxV2NEsclV/n/3qk+w7Oii53zh7e3S/MNK5sst7uwWYUaAzS9z1M9AW8ad4smchAqUbTlw9Yg/3Oh26vCUC+AOtTxsgBjQtZ3/J+YTgBu2CpvgyhQFNeBJe0Feksz5w+oWA+hrQOatI5Ae/YtT6ZzE8wq76M8KmRtOSiwmJlSijP9gR8mnNIIiX8qGGWJdM1db1M7C+gACiU+6BshDGFBurFaSq1kzMUluTmJxau1UEa8FGi5uNesQzCRC20WeXMekjdlaqo64LO8YGWfcZdBKw3y0HKmP79elQURYpBH5rEGAPrhx+K2isX7QCwnvnzyg+KErYv8Yw84gbzioQGOV1r3Ep5xNyL7/59qfKyfQ4dyBVmZ4GqT1YTTa1+qWMDNEVjCTN0e1QZFAUzvOsySh6Znrk68WGywowQ8sw+PR4DSSb7KNaWO1uWK7U8HKmPYj8CRBuhhehG90u5R8hmCh/nvu5TmuTHvmi5ticF7OfpBWkg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199015)(46966006)(40470700004)(36840700001)(2906002)(4326008)(8676002)(4744005)(70586007)(70206006)(33716001)(316002)(40460700003)(6636002)(5660300002)(54906003)(86362001)(6666004)(40480700001)(6862004)(9686003)(186003)(8936002)(26005)(336012)(478600001)(16526019)(83380400001)(7636003)(356005)(47076005)(426003)(41300700001)(82740400003)(36860700001)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 16:29:54.8852
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 554d6113-35bc-4b01-da27-08dad6ddf146
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7280
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 05, 2022 at 04:48:25PM +0200, Yishai Hadas wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> Introduce ifc related stuff to enable PRE_COPY of VF during migration.
> 
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  include/linux/mlx5/mlx5_ifc.h | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 

Please take it through vfio tree.

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>
