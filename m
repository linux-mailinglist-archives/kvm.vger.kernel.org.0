Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D875967F167
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 23:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjA0WwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 17:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjA0WwB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 17:52:01 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782802365C;
        Fri, 27 Jan 2023 14:52:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DPBO46Y+IzpSdMF3AppJqhDiJzrKusUWZAeYJfd+Fx88vNV+YkVJk5dj/7KXeIStqQvm9vknjsWsbp/aRujsA5ahxwORN+yZlbGeDeBhzsupQHu6a2xej8I2udbFephn6wCiO2XUe+BWlMmPo/oxksAMaw7cSjb9j6afQeN4OPcBL6mk8kI0+BB74GlVHshbKKD+3n2Kkh9X00GnRJusYlpq+oUHYm4/pVdU55hXdiO6c5BtPItkladw98FJXXoogPZB9yyXHn5i/+llhqWksv+lMkQMeuKs+p5vuavsoCkwNrri1/Y1J27aCW9mRb/uOADLO1eV5RguCu8tr0atCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SeMy6+Yg2PGakm3qSiX1Tv0sKSod3nKYJ4AwEfDlcko=;
 b=PQbDF9soEbJQmmF1gkv3npyxYKbbxkH+C17V9MF8boNKfTi8gxdkjOWOK6P9eKFEpgQRrb7BVh3RWLimFKubSi9CME7HJJcMrQoqRrYGhhXG3gSDVVDnI6I98k5+4DZB7JiFTwrhr6ucrQd9HLqzsFtsEaWH7T7KNRXOGaePZ3uA6Tx0uM0DGRYQ7ZIWiqi+qg9o0apdoq+D9laqrVLlexC0ZYfv9eodzuolgZ34itRm2a6CZntQ5K8p9sTesFsQGEbKVM+4E37L8jgAbwlndTHNW+OSOlTmW4ptUKpw5ziKLx4T3D664TqWwqe+pHkuUWk3C7rDwH6fjtCdqaXg8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SeMy6+Yg2PGakm3qSiX1Tv0sKSod3nKYJ4AwEfDlcko=;
 b=KTCmQNFE8WENc+Pu4y63VdHQCBF/2wm1FZHt0MhtfHXyV+pOqI7PXTPnLscgM4aaIgCo/Hz27YG5Nk65eJIvr2XaC/mAYlmSL4DrFUjRPZVD1Pyoijzd2YO6kKPxT8pcACmOfQOxOPs0SAIls7JhAflNovRRVSYchLnZk/I3oPZEYpV6jXOfMKu6X1NofPvzu4SATnE8jUUm6xS6qScbXiUUQMFog/NURyuWoOreGNRheX6UW7INpy80NRYq5HM+w5NOFS+mW43z1TFVJM0VqlcgwoRPslDqhlM+Fve8z0PU/+NlslIfmHGepB6KPvq8sSneG04gydQRfkJMm1dYmg==
Received: from BN9P223CA0014.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::19)
 by DS0PR12MB7899.namprd12.prod.outlook.com (2603:10b6:8:149::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Fri, 27 Jan
 2023 22:51:59 +0000
Received: from BL02EPF0000EE3C.namprd05.prod.outlook.com
 (2603:10b6:408:10b:cafe::92) by BN9P223CA0014.outlook.office365.com
 (2603:10b6:408:10b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 22:51:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0000EE3C.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.10 via Frontend Transport; Fri, 27 Jan 2023 22:51:58 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 14:51:45 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 14:51:45 -0800
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36 via Frontend
 Transport; Fri, 27 Jan 2023 14:51:44 -0800
Date:   Fri, 27 Jan 2023 14:51:42 -0800
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
CC:     <jgg@nvidia.com>, <kevin.tian@intel.com>, <joro@8bytes.org>,
        <will@kernel.org>, <agross@kernel.org>, <andersson@kernel.org>,
        <konrad.dybcio@linaro.org>, <yong.wu@mediatek.com>,
        <matthias.bgg@gmail.com>, <thierry.reding@gmail.com>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <vdumpa@nvidia.com>, <jonathanh@nvidia.com>,
        <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/4] iommu/dma: Do not init domain if
 broken_unmanaged_domain
Message-ID: <Y9RVftHuARKQnfN1@Asurada-Nvidia>
References: <cover.1674849118.git.nicolinc@nvidia.com>
 <451e7beb57ec6de66ee0da5b38886105436f53d7.1674849118.git.nicolinc@nvidia.com>
 <89da64c8-fef4-2cea-f15c-86264073500c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <89da64c8-fef4-2cea-f15c-86264073500c@arm.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000EE3C:EE_|DS0PR12MB7899:EE_
X-MS-Office365-Filtering-Correlation-Id: 24c33fe0-2cc5-4206-f232-08db00b918b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4KiZt/HA766sIlkz0MQ1APNL/QmVhfGWlhRp/8iEVD3BDLqqF56Z8BkR3QbRlmtw5943DqclNXxg8oztgNvD3KwmtkDWVwZ0v05uW2vTDna/Sc2KM5y1tIjJDBe87YsEZEzoos4SnBOvDGcJ7q6C/IT+/IEC6Nsu97xzC1ffROnJL/gTn6VHk+6UMmI9QFYdrp73YefhfHXH3ozYnYj50j+xOy/Gdy9aRcqHuVlEoquqaBGAjECVQwddE1tb4/Osrgl5wm5ZLQ8yWYukbQSxfFcfDPoCw0crAp3Vzv3ikdt14XyYdyk6I1lAzjDFWfw+uBBLCQ/W7JnmBuLeZNaQz/JRNgpG1l9Pyy5MaNzt/t/8T+HaY2MNaW7Th+wsKHVZgoP4idYc5QSPx/6ZP8ZsXLcuwEnWtHccQrDkkSffWEjF7Xm1zk4d1KOsUPSTMHnmaRLANPlPStKOpmViwGMo2J30J1CKK5Xayj3MhTWfPOZxwDHurSxeEB3ryyFcJ4NSTD42TVjLIIF9dsjb4qy/wLS766kp2+6p3cSfu0n8sN24s/swsJbVrbM0p9bkR7/JilZSi36L8Ym1FJ7JKk18Ka0f9Y5pOvx2JS7LWFWjiZridg2jQkM/TRIvUD5gNSsWdyi7um8g/7DqeCohV68cFGq5LVXVy8g5kDLZzrErIqHdosf+vsZTA8fhpiBEaseg/TZNI74Tcun9X2yEF9dF9w==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(346002)(376002)(451199018)(40470700004)(46966006)(36840700001)(47076005)(82310400005)(55016003)(86362001)(40480700001)(40460700003)(356005)(33716001)(36860700001)(54906003)(7416002)(82740400003)(7636003)(4744005)(2906002)(70206006)(8936002)(41300700001)(4326008)(186003)(8676002)(5660300002)(6916009)(9686003)(53546011)(70586007)(26005)(316002)(426003)(478600001)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 22:51:58.4552
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24c33fe0-2cc5-4206-f232-08db00b918b5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000EE3C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7899
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 09:59:50PM +0000, Robin Murphy wrote:
> External email: Use caution opening links or attachments
> 
> 
> On 2023-01-27 20:04, Nicolin Chen wrote:
> > Add a sanity of the broken_unmanaged_domain flag to reject the use of
> > dma-iommu in the early stage, if the flag is set by the iommu driver.
> 
> Realistically, iommu-dma will never be enabled on PPC32, let alone used.
> It will not be enabled on ARM until I've fixed any drivers which need
> fixing to work with it. We don't need to add dead code here.

OK. Sounds like I can drop this patch.

Thanks
Nicolin
