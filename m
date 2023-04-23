Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDBA6EBDC0
	for <lists+kvm@lfdr.de>; Sun, 23 Apr 2023 09:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjDWHpI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Apr 2023 03:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjDWHpG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Apr 2023 03:45:06 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB2218C;
        Sun, 23 Apr 2023 00:45:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDUxx7mklww2bUIjPq/CZNtBjg1y/K6yG432Y0S7PvmhnIUQFddXcINMTNbVwzhKQXa0c/U8TfpYE1jJCsCBb7GPuMe3Iz4ZMNH+J0Livczb38h3xS1+fwFk0k5eIsLYHz91RPxvHtlFsKs7OiolY2ux7t8ttg5GFIh/SpjZ68DQscZtlWrA+nOaEL0pa1BaL+jHuQa7EdpjTK4o4eQlKml+gNlxLKm2IihLYM50CswlkwfdmSkUXbHoma6KMVADOY6edzOpEwhfvVk56kKkVTOcyY4lWXLhP8Wt/l/uZEgeQPBzYIdgKJ0SY8UGQ6mrQoIx7c4sA6M7cxeauKCLDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FddsASLZPBMRSM1t8BsY5TZ6QFD/rZaJuFrUsqJ2DeA=;
 b=DWxmRD3dROg7A9beHU0DwSkI5HVDiOjVC8+OpFUhqwz24eCB/9mQyScDE+1v+yaqtBN2K4zG10FcQiX9PlTrRnjoE6n/A2Bw2ZtBnRL5ZapkwM4fuie5SLuxuvdwyB8iSwUB+c5hCDheYQ2ANFJQUiNAGrZWJ93ziE/Uwl+cs7BurdPRmD0d3doY4bwSYWEjrSbF+i+BeFOExoMwmQuxSqmnr5ZFXnKXZnulfz9SfCOlZk4fyzK9w6JQ0K3q7wxj5GLLRpFgQruUcoNJ5CcmyZljzqTxHd6XAo7LHcR1O8FZb9NOcarrHLlLM5RaGmZAJC7d1VxviZU32/P1kvtFPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FddsASLZPBMRSM1t8BsY5TZ6QFD/rZaJuFrUsqJ2DeA=;
 b=VGNyQbyNr/t+hciCTeGqROnXgD0dKpC4Sx9xxa57vG4IGtMrZcWTAGb0CRYPxTbrtfJDwWZKqlp6WJuzgl15bO7q1yRnuMREVIM94Q3OrvUr43v+O6cdSOQh9aca5xXeSFC6vEi+rO30RS3G7d02hVeUiubmhWn5VYaNjcMCyayUybeGtPs7w8rtHRj9Ab8Esbz37Y3QS4BYQH0ldRX3DPOx1C/XWKynLaDqjH7WOd6xa4/2EHVYjpHOeaFwAcpNiYQQa6w78nsBTVE+JHD2v5i918gg2/TQELLiIJIWFrnSkXbpp5EWgQB5bKzNXIiYEdIMA2ndowMa7jaYjyUoZA==
Received: from BN7PR06CA0053.namprd06.prod.outlook.com (2603:10b6:408:34::30)
 by SJ0PR12MB5421.namprd12.prod.outlook.com (2603:10b6:a03:3bb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Sun, 23 Apr
 2023 07:45:02 +0000
Received: from BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::e1) by BN7PR06CA0053.outlook.office365.com
 (2603:10b6:408:34::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32 via Frontend
 Transport; Sun, 23 Apr 2023 07:45:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT004.mail.protection.outlook.com (10.13.176.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.18 via Frontend Transport; Sun, 23 Apr 2023 07:45:01 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 23 Apr 2023
 00:44:51 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Sun, 23 Apr
 2023 00:44:51 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Sun, 23 Apr 2023 00:44:50 -0700
Date:   Sun, 23 Apr 2023 00:44:49 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC v2 0/3] Add set_dev_data and unset_dev_data support
Message-ID: <ZETh8ZBMtjUp7C9/@Asurada-Nvidia>
References: <BN9PR11MB52764ED59905104D3A5A68C08C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEI+LBkEeNZdJyTB@Asurada-Nvidia>
 <BN9PR11MB5276C39E256CD4B922435E1C8C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEJBldGXBNGEy9tV@Asurada-Nvidia>
 <BN9PR11MB527693075725A13DB9EE18678C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEJHPb1E1/eI8V6A@Asurada-Nvidia>
 <ZEKLDzU8C2niNyOw@nvidia.com>
 <ZELJ0uv4gGCPrDfX@Asurada-Nvidia>
 <ZELPCTOEgU8XlhFh@nvidia.com>
 <ZELTqCK4lcAkf/ti@Asurada-Nvidia>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZELTqCK4lcAkf/ti@Asurada-Nvidia>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT004:EE_|SJ0PR12MB5421:EE_
X-MS-Office365-Filtering-Correlation-Id: 43f628b6-eeb3-4537-db60-08db43cea53e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 40d8H1k8zb2VRkIIz1kPe2fLgNGsmV4YFrDtKRRG7xxxRs99wHVGFkpzMSft8PA+LWpzOQdxJcG4wGoT2MgVJMCvB/EPjcYFOdGSzflNk/x306V177JkNiYgLZTcqFE0u7UmlNvSoysw3s7moC9HXTXxyq5J6bkqBPhULBwNxVgYFsr6QsE1ipHw7TM3X1se9dm7BTKdDIcV3ze7QgwX5zuijiuFnEUYnXITCcKzCXA4QMGkYB9SdD+VBkRChP6cM7DLbtmNCH5EmVe9dPW0xNlaUsxpy6pR3gZozQNboAnSeCHxtpx5II+oVnw8uLXRpRdpQtMBRyJ5WTo2kZndD2VSiXGv7QD1D03e6SiIA5z75rfweSOWBXHeQAp1ybMw7KQOqjgk8/7FrAs3Z0TrmtQuvBY7gZWNnse8k/me9sOBV9h9C0RiZDmG/5kE9oSS1FOWNZNtppjCNACkWQIjdXf85509tS9DQMtXpdqS2xCVZSFllvxCxyupgyT+pGXByOsHfrFSJx165xfV/1xc30TLM+9SCMhyfwK/Bm7gs47PhKB8lTGeOv0riIzxi6eaTtY1SyydcFv3P8fbX5TsUIInNgtqY8XOnc/Sb0dP4j5NqoZuBUeKHLGixj223Pc2flRUbqv308BLgPiJJFdtALXwMvhFNgHQqPrrY5tioto+PxuV78g4vqkvSqNFcXoewJaOp2o2d7nNkZVR1ZNzfaOufiqDI6YRNuxWbiaie+WyJr3Itv+mTWJ34maRB7QYPHFXy5IIyAqstV20B9zeBA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199021)(36840700001)(46966006)(40470700004)(478600001)(40460700003)(54906003)(6636002)(86362001)(966005)(34020700004)(186003)(26005)(82310400005)(9686003)(33716001)(55016003)(40480700001)(4326008)(316002)(82740400003)(70206006)(70586007)(36860700001)(2906002)(4744005)(7636003)(336012)(356005)(426003)(41300700001)(8676002)(6862004)(8936002)(5660300002)(47076005)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2023 07:45:01.5553
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43f628b6-eeb3-4537-db60-08db43cea53e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5421
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 11:19:23AM -0700, Nicolin Chen wrote:
> On Fri, Apr 21, 2023 at 02:59:37PM -0300, Jason Gunthorpe wrote:
> > On Fri, Apr 21, 2023 at 10:37:22AM -0700, Nicolin Chen wrote:
> > 
> > > How about the following piece? Needs a test with QEMU though..
> > > 
> > > static const size_t iommufd_device_data_size[] = {
> > > 	[IOMMU_HW_INFO_TYPE_NONE] = 0,
> > > 	[IOMMU_HW_INFO_TYPE_INTEL_VTD] = 0,
> > > 	[IOMMU_HW_INFO_TYPE_ARM_SMMUV3] =
> > > 		sizeof(struct iommu_device_data_arm_smmuv3),
> > > };
> > 
> > If we need more than one of these things we'll need a better
> > solution..
> 
> How about adding ops->device_data_size to store the value?

https://lore.kernel.org/linux-iommu/cover.1682234302.git.nicolinc@nvidia.com/

I sent a v3 that includes this replacing the data_size array.
If it looks good, we can drop the other two data_size arrays
for hwpt in the nesting series too.

Thanks
Nic
