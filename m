Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82B16EB176
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 20:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbjDUSTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 14:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjDUSTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 14:19:38 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2085.outbound.protection.outlook.com [40.107.96.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9D213E;
        Fri, 21 Apr 2023 11:19:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sjxw0uOF+AfsXhtAn27cYU0UPGMSr1KgN7/8wYGuxF+9yneSoXXiFYO7F686uPM7M6FlIZHGhZYrqgTdiprUmX9/DuhiJFzMMpP+p+KD1Zfaaqv8IRk2eLhyh7Rd5baqfTo7b+Rj6MkWVOgRLmV1braZBqZO55jzWjbnWIYIGgsI9mTUJi3gKHazanBzDgG/FEUWUE3+7eQh8yG3PrCO2isdPCi9maXyUUcb1sesxHa0FH8vZMU6LFALqnSlXSeY5qMmobsLOsNFV7aLffJAopIDoRzorjz/kARlLrjpA/nhTSoweGQ1odc8deuI9fUKYd3KcmAv3a0IGTSekwbYKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y+ZpcL1q4SwHovqsKcprIkzuyA/YAw/or75QEK2nbMA=;
 b=F3bA0W4kagMf/61fXSrS+uBoj1zgV3B8K8YWvKO7pTM4YMFah2iDOTy9jk6jt5tQhyeBFInaP1Rz8ZWCiUXnYQsHxW8t5YzRk3QkfdP3NgbdmN/RoLjMtWJtigdudLGXVoYrwl5u4wj0A3BqUuB5nVOVTwHmT9qs4bXhUdQef6tGOeVrhdGIFR88DFUH97B962xSDuDbV27DIAS+70rsZjcMdQkWghjXlMwY8ShDEzT3NPnv89A8CGHuiPIsUZCFyCX/YiIb6KPNx3R+Fup4Z/oYPxIVa5x4v/XOTdTbMT9wVJWXrJgfipQOTuqFfSlGOwRivwT+Dtb0YutywNToWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+ZpcL1q4SwHovqsKcprIkzuyA/YAw/or75QEK2nbMA=;
 b=MCLYtZeqIoq61fL1myLJGn/TKttW/t6FkkeXHVa9d5NKAtHoNe6SFQ6FiUhII/2Kq5tk28QHwUp6YzcDYTk7oFKDL5jW8Lv5+TYGtXb2CHJON5ySb8NYUain2yxOA74Fp+ec6zkfeoxk2Kbskdki2hORqX3FuVDofkuscioGdXNpkexl+kYs0H7UryXcpgOgn+GRKbZz8IQD5egsexOF+Lqu2eCJ0DXyvZ2KdBbZ+X5usUTFYQD3HLAb2P8nPJSX87G+FSsz3wLyjWpcHrCbAgvvq8Fqi2MfwlVDSZ/BqSzLgyWROmAO+QEgSeP0AuW8cQ3CBXOEx+6GzHwqQTJ7jA==
Received: from MW4PR03CA0278.namprd03.prod.outlook.com (2603:10b6:303:b5::13)
 by DM4PR12MB7718.namprd12.prod.outlook.com (2603:10b6:8:102::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 18:19:34 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::e2) by MW4PR03CA0278.outlook.office365.com
 (2603:10b6:303:b5::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.23 via Frontend
 Transport; Fri, 21 Apr 2023 18:19:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.26 via Frontend Transport; Fri, 21 Apr 2023 18:19:34 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 21 Apr 2023
 11:19:23 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 21 Apr
 2023 11:19:23 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Fri, 21 Apr 2023 11:19:22 -0700
Date:   Fri, 21 Apr 2023 11:19:20 -0700
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
Message-ID: <ZELTqCK4lcAkf/ti@Asurada-Nvidia>
References: <cover.1681976394.git.nicolinc@nvidia.com>
 <BN9PR11MB52764ED59905104D3A5A68C08C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEI+LBkEeNZdJyTB@Asurada-Nvidia>
 <BN9PR11MB5276C39E256CD4B922435E1C8C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEJBldGXBNGEy9tV@Asurada-Nvidia>
 <BN9PR11MB527693075725A13DB9EE18678C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEJHPb1E1/eI8V6A@Asurada-Nvidia>
 <ZEKLDzU8C2niNyOw@nvidia.com>
 <ZELJ0uv4gGCPrDfX@Asurada-Nvidia>
 <ZELPCTOEgU8XlhFh@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZELPCTOEgU8XlhFh@nvidia.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT053:EE_|DM4PR12MB7718:EE_
X-MS-Office365-Filtering-Correlation-Id: f7706c83-19c5-4eb0-bdbe-08db4294f55f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RmQaQC0csxwRRgTd4QyCIkHS5H37RSmfTSYrX0iWOBE4gMiqzfT6Uqnl2Up4NB1ZInTb4lTzZSCClBFBMcWwZcxZTAXeL4kH9ENagHJRlodrK8x3vwfvT2+UhzF87SPYlJvPVxdvYvWGwEQChn/KkfoJFOLI+pzToKmwG73ekbaqCvAtNa02tJDgyNhmw9hcSOn4sKL/u4Q9khzxZr5MII3LUQd9sAwd0QXPDiqp8WXsrjS4uN9SvqZdL5s+uAZtpU1Cw5FHzeUOis29Kwa1P9Mw957bqFgJPr6q6HlGIOqwSHDjcMMXO9xMVWrYDKYwV+c9JSa/p7H/lCFrhCjNx/mbM8vHZ3bN8Ur+ksyl6R3qj+79FKdVnBvdzOVIR20O2M+nW2qo5cJouSl3BxTNRz/fVnv7lpHhYVUKtPcnFYD55qScm9BocKJAkN1dCywOoZE1xjpkzyTyxXnolkzt7spshjyX1boakYuyDMdfLWc3M1PMBMuFGeTZ7EcHpJpv1P/AQWcWPG4RQU5kJQVKsF/DjhwpY3jU5EVEPAvGDROXqi510EcQrcFxKxLSLrVnfcqgBDCSQRxO51lZZIm9gsc5G3xkUlDzt7UNBQ9YdWYC53NMJ9TTevnDU/PBU3PyykZIIf49a8ZrZfJ64qV797BvhZuyIZOvVIELQuh+RQ8Gc0GiSVUUZn51donnA5C/EVi+mCUNevUCJNLgOygytN2jcqsFC97peWnLgU/Hpfptpqfg0AvnnXKgc3k4CKQ+RBEhewUFljRXBHA7vSLtA+GnFr4EOI1qpXcWUgJe/RMP0fOFd7cVx1JJAZF0axjL
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199021)(40470700004)(36840700001)(46966006)(40460700003)(2906002)(8936002)(8676002)(6862004)(7636003)(7416002)(86362001)(356005)(5660300002)(82310400005)(33716001)(41300700001)(40480700001)(55016003)(9686003)(26005)(54906003)(6636002)(34020700004)(36860700001)(478600001)(47076005)(83380400001)(426003)(82740400003)(336012)(186003)(316002)(70586007)(4326008)(70206006)(21314003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 18:19:34.1405
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7706c83-19c5-4eb0-bdbe-08db4294f55f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7718
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

On Fri, Apr 21, 2023 at 02:59:37PM -0300, Jason Gunthorpe wrote:
> On Fri, Apr 21, 2023 at 10:37:22AM -0700, Nicolin Chen wrote:
> 
> > How about the following piece? Needs a test with QEMU though..
> > 
> > static const size_t iommufd_device_data_size[] = {
> > 	[IOMMU_HW_INFO_TYPE_NONE] = 0,
> > 	[IOMMU_HW_INFO_TYPE_INTEL_VTD] = 0,
> > 	[IOMMU_HW_INFO_TYPE_ARM_SMMUV3] =
> > 		sizeof(struct iommu_device_data_arm_smmuv3),
> > };
> 
> If we need more than one of these things we'll need a better
> solution..

How about adding ops->device_data_size to store the value?

And, since we have a few size arrays in hw_pagetable.c too,
perhaps a new structure in ops packing all these sizes can
clean up a bit things too? For example,

static struct iommu_user_data_size arm_smmu_user_data_size = {
	.device_data_size = sizeof(iommu_device_data_arm_smmuv3),
	.hwpt_alloc_data_size = sizeof(iommu_hwpt_alloc_arm_smmuv3),
	.hwpt_invalidate_data_size = sizeof(iommu_hwpt_invalidate_arm_smmuv3),
}

The hwpt_xxx_data_size might be in form of arrays for multi-
HWPT_TYPE support.

> > 	rc = ops->set_dev_data_user(idev->dev, data);
> 
> Where will the iommu driver store the vsid to sid xarray from these
> arguments?

The ARM structure packs a vsid. For example:

static int arm_smmu_set_data(struct device *dev, const void *user_data)
{
	const struct iommufd_device_data_arm_smmuv3 *data = user_data;
	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
	struct arm_smmu_stream *stream = &master->streams[0];
	struct arm_smmu_device *smmu = master->smmu;
	u32 sid_user = data->sid;
	int ret = 0;

	if (!sid_user)
		return -EINVAL;

	ret = xa_alloc(&smmu->streams_user, &sid_user, stream,
			XA_LIMIT(sid_user, sid_user), GFP_KERNEL_ACCOUNT);
	if (ret)
		return ret;
	stream->id_user = sid_user;
	return 0;
}

Thanks
Nic
