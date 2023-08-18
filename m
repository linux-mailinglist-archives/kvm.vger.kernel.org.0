Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCD97805C2
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 07:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357717AbjHRFoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 01:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357674AbjHRFnv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 01:43:51 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8C22727;
        Thu, 17 Aug 2023 22:43:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBn1zGmciOLrcIM9NCWlKqHgbKXyehV4XHUgMrl+o08fJxQzBJslxpF7BPl88fscvT/R/rH3tCwmzhqAmWUk/5KF2M1pOg02GWJcEDw494OOHsPXS0iKZH2Fb83STqTx9LUh4CQML1j6peg/xBFM7jwPZ5eJ3AAnFW9deEpBQpEib6q6I1vaB4rzANHfkvjX1qXHQ0dqctGH6D+m655y4pZk708dknLHrqjKdJLXnYaG4PsEWHyRXg4VC5GreXu5H01anv5Un6xmkYGEjztCERGtLNQPcpdso/0zgpaXXMfMDkd5Yov17k3+cLqWS4SVWiDOuddLF5wFs1cMYftvIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7E3oJ8O0HYP7JWHe6WXGuo7CnITTAQyZJNR/zQseFtk=;
 b=WnCTgYwKnPK9uYJ8aL6dDn3z6DnQy9317eKNJq1pJvsBnMVIPq2sGrZUwFPUS+FbEYYw1frZ9/4jt3Ivnw7nIiYnbVUDu45ql6djwu11flieNvmo17CrqPYNW4Cn8yHNiqeu4SqXPKUoDzPmRYDk8Q4eyYmJeNzh16ddS0H7HTARgviqj34dj7vLBQOQ4KJmeIpcj+qLdwHeJsxxZGPT/NmwWvfuxyV79LzQDgSWi2A0Eh8AgyLrMSFyn9OsDaL7AT19GaHGXaCYVJzPKcrhMy8e7NqXXhN4/FGNkl7ogSC7AD+VjG3RbgbAUl6RLmHNwVn7Xn55vxDgQu8RguRAkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7E3oJ8O0HYP7JWHe6WXGuo7CnITTAQyZJNR/zQseFtk=;
 b=mmuKmHgSLcpmiOC36f+Rg/i9HOguQwh1sKZjgUwuNFz+dr6Oh65mS5olSBlFNnrOTh8bQL1+kgp0QPSVSbmYBc7ii73gZevjajRbeBvoKG3QhO6P4BpT1pZkMJetPbkD9R8MEVrabate9zJoY6xHhlDsofCZKWEgkD8ZOT6U/xgLrnKkujQW/GM46E1e/rfg/iXPqpCpnHCHSHRRbvqU0BDAcQ1oNdT9pa91LpXQSKyoQSYHjVd7HVeTcb18PvezNFLgl8L5VY1YDfHPZCVUWa0RpX/1qZ1LbcsYQqa/Ftjg0GoLBHXV9PcV5SzAcJO6skjbFZafpGfN6xYZlAHFSQ==
Received: from CY5PR15CA0209.namprd15.prod.outlook.com (2603:10b6:930:82::27)
 by SA3PR12MB8803.namprd12.prod.outlook.com (2603:10b6:806:317::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Fri, 18 Aug
 2023 05:43:43 +0000
Received: from CY4PEPF0000EE3C.namprd03.prod.outlook.com
 (2603:10b6:930:82:cafe::a3) by CY5PR15CA0209.outlook.office365.com
 (2603:10b6:930:82::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.20 via Frontend
 Transport; Fri, 18 Aug 2023 05:43:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE3C.mail.protection.outlook.com (10.167.242.16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6699.14 via Frontend Transport; Fri, 18 Aug 2023 05:43:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 17 Aug 2023
 22:43:31 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 17 Aug
 2023 22:43:31 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Thu, 17 Aug 2023 22:43:30 -0700
Date:   Thu, 17 Aug 2023 22:43:28 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
CC:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Yi Liu" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        <iommu@lists.linux.dev>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] iommu: Consolidate pasid dma ownership check
Message-ID: <ZN8FAKHCzWODGRmC@Asurada-Nvidia>
References: <20230814011759.102089-1-baolu.lu@linux.intel.com>
 <20230814011759.102089-3-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230814011759.102089-3-baolu.lu@linux.intel.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3C:EE_|SA3PR12MB8803:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f6c20b5-8d51-4fb7-9694-08db9fae1553
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PInNb/OAQGbAb8/7i+22twYHXEyRY0HCOHL2H46udrOZG5oCGsVCsbWti4RwRnExJ7C5nz6i5pYieM5Ku3aWa65hp/ANGfur0i9JrPiVdoA5wJUuBuHYxIvy50S/7pBPl9dWpoMwb67y+P3ZHHALJQ7i9CgkMPFxOwyUgpI6LtsUCBGy1z0bEvVpqTxCm/AbC1CUi4T/6Jn0fGuXFdhlB84u3D7e79DzKI9f1inBHJOElZp7hP5LeN5FU7Hnh86K6XZL0Kk1eGuHol7/jVF4O8wJ1gUGGgbDpfSzI14wm67H7rmh6C06s20BIwdEdFOeIrGWDfOg16kiMauVekNMtcRaX1Y0DGmNMUN9CjND3ptQDagRF+qOkQ9vw/93QqsdwM+0c6GcDu9WZYp3Jm2XK5YYyRxCX7mPXRvKA9mdzw90oQ7mHY6Uqy4Fx+0uSqfSOgG8V8TVjg+PhdAOYwCmANTSqsv/zEWAbbGaMfFgjUgPNzTzQRn13b+emcvcXYbWONdK3DkBcJhg5FbL4Qs+C/GZUXe6kRdgU6FLuLwKuJUo1fRO1AKb8hyOV7e+sfDmVYDU8mOzsNQbF7wmk9JMoEv6ZfH7wCPMUxkLAx+7YqjldUgoE9scST9C2b+qyZdRu0TYi7bbGcNFx+HBYkTPznfhSIvqqA/3tYxzD10Eno0i6RkFSklncpR8wCFpoGkAVXyKFbzNR8E3TbvKcDiVIpcZ2a71v+bunUQnch+8/wQerjooX/X2w1LMVJlRS5W1
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(39860400002)(396003)(186009)(451199024)(1800799009)(82310400011)(46966006)(40470700004)(36840700001)(2906002)(40460700003)(83380400001)(26005)(86362001)(7416002)(336012)(40480700001)(478600001)(426003)(9686003)(55016003)(5660300002)(36860700001)(41300700001)(70586007)(82740400003)(356005)(54906003)(7636003)(70206006)(316002)(6916009)(4326008)(8936002)(8676002)(33716001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2023 05:43:43.2576
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f6c20b5-8d51-4fb7-9694-08db9fae1553
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EE3C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8803
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 14, 2023 at 09:17:58AM +0800, Lu Baolu wrote:

> When switching device DMA ownership, it is required that all the device's
> pasid DMA be disabled. This is done by checking if the pasid array of the
> group is empty. Consolidate all the open code into a single helper. No
> intentional functionality change.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/iommu.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index f1eba60e573f..d4a06a37ce39 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -3127,6 +3127,19 @@ static bool iommu_is_default_domain(struct iommu_group *group)
>         return false;
>  }
> 
> +/*
> + * Assert no PASID DMA when claiming or releasing group's DMA ownership.
             ^
	     |...

> + * The device pasid interfaces are only for device drivers that have
> + * claimed the DMA ownership. Return true if no pasid DMA setup, otherwise
> + * return false with a WARN().
> + */
> +static bool assert_pasid_dma_ownership(struct iommu_group *group)

... should it be assert_no_pasid_dma_ownership?

Nic
