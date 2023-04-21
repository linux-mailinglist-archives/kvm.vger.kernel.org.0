Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951E86EB0B3
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 19:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbjDURhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 13:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjDURhj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 13:37:39 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2061.outbound.protection.outlook.com [40.107.100.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92D940E7;
        Fri, 21 Apr 2023 10:37:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTAln3H8WKmyH4/fyc1s0mdjTi5petpMHtpcR8DhmpcPAoqH/ryLZqtMxW0zjAgH6Q9uNsGxhQg3GjwALNwlCfUTgRZYDIWnVVUkwi5COq6n2zoyOg9TEIR6hmFaUmFKOh9hx1pWzzkr8ckHUmWaQFumr1lOMNqR5DoUW9mG9GXc3bqhWnEsrO72pKauZSdOXQKu24nAV3/I4UvKAtWiQkJmDB7k6KmTVe0bqfhLZIjnsKqqw92G+tiI8CzTlQ7+ERUNQ3bPopGDPrvO4IY1LauFlz6vJvkVpRZEMIJefrmBHv0ELChxshEHQ/hkLJ06k/b6NdMhJ34sJUqoYbZpIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MOB+9ycjDK7dj5EqGIBjuF/vezbe9ZFOicmuyMSZARc=;
 b=I/ku1ug83wCcyavHHzqV5QZgxIqWH6QgooLqEAjTjsA62zRm3N940HLVSLYk7tfWR0aTjtYLAgAfvYAWU5uPRjVcVfrIhFyJ+JphIZ/wTSrc3qlB08L/4Q1GS4d1QrkM64B4TdKRubQfNAn5IgNEElilhJu9922H4foeG+NcuR2HxvxHb1sfTudrvjVz0EzG5N1cjDq9RArrEkMcovjMoOTzivb0WRtBKmE2umyHQMXSTLuZFnwdYrotK2uFbLRZrWOzm56xpb6GY3zgIgIX6iQFa83AStRrIw20tAOHyM7Ls+YOd0vZIYmhx8BkzDcVT6Gvp76TGb684F44oQ8Ydw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOB+9ycjDK7dj5EqGIBjuF/vezbe9ZFOicmuyMSZARc=;
 b=W1VllpRWqY8o088/nxE4+dZcbVX0Lyz3u44DI1p23enF5UE+vOxIZbR+a+INfHQ/LBaNReS+1eUrAwBm9Nx5Bc/NVxNLoRN8mmng5vXjPLTJyTmnasTuMECQpczsikeVLeArLnzUSGRcJRngQL8z7hi8qhZsLJmUmfOE9ypmUcMXCvl70S+11GHmQ2t3fXNvJlb7WOuiAyg04dB3uwO2mweB4OgZ5sdwDXCSazJGO6BFBLCuVPBulZtiysGRMD/CnuGuzumQgxCtJ44egYJWKyE194LJQ8L67+YyHyByBIZ0LZmsIo0xBv5XS/IDH3+sGOKCD9ywzimE82ZJFnPwKw==
Received: from BN9PR03CA0854.namprd03.prod.outlook.com (2603:10b6:408:13d::19)
 by IA1PR12MB6356.namprd12.prod.outlook.com (2603:10b6:208:3e0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 17:37:35 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::9f) by BN9PR03CA0854.outlook.office365.com
 (2603:10b6:408:13d::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.25 via Frontend
 Transport; Fri, 21 Apr 2023 17:37:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.26 via Frontend Transport; Fri, 21 Apr 2023 17:37:34 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 21 Apr 2023
 10:37:25 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 21 Apr
 2023 10:37:25 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Fri, 21 Apr 2023 10:37:24 -0700
Date:   Fri, 21 Apr 2023 10:37:22 -0700
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
Message-ID: <ZELJ0uv4gGCPrDfX@Asurada-Nvidia>
References: <cover.1681976394.git.nicolinc@nvidia.com>
 <BN9PR11MB52764ED59905104D3A5A68C08C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEI+LBkEeNZdJyTB@Asurada-Nvidia>
 <BN9PR11MB5276C39E256CD4B922435E1C8C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEJBldGXBNGEy9tV@Asurada-Nvidia>
 <BN9PR11MB527693075725A13DB9EE18678C609@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZEJHPb1E1/eI8V6A@Asurada-Nvidia>
 <ZEKLDzU8C2niNyOw@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZEKLDzU8C2niNyOw@nvidia.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT026:EE_|IA1PR12MB6356:EE_
X-MS-Office365-Filtering-Correlation-Id: 64546c55-6cb9-49fc-a938-08db428f17e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1ZZs4XpdAUWoJQnW7+aFw/yUjsr6O/B02cNa9i8TU0m9PNH1Eg9wIPRzA+T1leD+YL0ExZMZjM3IO/o1G70uKGup/cfn7ww9cVJ2ACstXD6EX8xE7YuHXyayWIagGiV8hmByCeR5e20Ed5KqVvxaCCh2LYogleBcXIWWdOJnsdPChmhlThD65AU4hQC96MpvDuD2WhOAQm3RYdwmtRqPk+M3XBB4Xres0eKRQh4M6Nc5BjZZh7juiK4IsZljqOiJgMQNbFxRsSoVjt0EKZCkzcLtfEshTYnWwoGDi3glyBEyht0CJ8kjkL3ep4DkNV2EtCu5BUSzd4+4dQt3uxARuLlXf2Kf6JbTjca2y8u0woaQG0cR71sczUhhNLp+4UVxIo0kA1NiQRvcjmAaONvXX/nSmt3IXapPLMdB08z7Ru/GdPqxGHVHny/vKnJQ8HLbbWzgrmCfGqmxzK23PP2dhmSWHTvYFHG/Cb1jmDDiPlawMbUaTyUhjjPqGgvrnhBPpXy1062P+RrxqjuYnMMQdPETsnUGpv8PkCVEojfnHLUd1mOLy+rc1KfusSNFNFeFRDOKSJmr/LQfjugRj53Y+95450DVKupknHiciJkF/vuf2xz90XtEQTeKmJfsf/RxLLxnEnKFb2OHwpyIpnlpZcQB8T/9OHH3QL7o5FRq/gJdXlqxhLtOlnd0sFTjsWJOMPym23VGNwLZ1F4zSI7bRVuuPIEvznjrNo4Vc3iVAfvHr69c4LcuqH+ecmUEeINYC1+K8JNcdWJlkYZm4C/Wnubjt037k/ugu+Y9p0QL+eA=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199021)(36840700001)(40470700004)(46966006)(82740400003)(36860700001)(316002)(70206006)(4326008)(47076005)(336012)(426003)(70586007)(34020700004)(478600001)(54906003)(6636002)(8676002)(6862004)(356005)(41300700001)(7636003)(8936002)(2906002)(5660300002)(7416002)(9686003)(26005)(186003)(86362001)(33716001)(82310400005)(40460700003)(55016003)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 17:37:34.9971
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64546c55-6cb9-49fc-a938-08db428f17e9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6356
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

On Fri, Apr 21, 2023 at 10:09:35AM -0300, Jason Gunthorpe wrote:
> On Fri, Apr 21, 2023 at 01:20:13AM -0700, Nicolin Chen wrote:
> 
> > +/**
> > + * struct iommufd_device_set_data - ioctl(IOMMU_DEVICE_SET_DATA)
> > + * @size: sizeof(struct iommufd_device_set_data)
> > + * @dev_id: The device to set a device data
> > + * @data_uptr: User pointer of the device user data.
> > + * @data_len: Length of the device user data.
> > + */
> > +struct iommufd_device_set_data {
> > +	__u32 size;
> > +	__u32 dev_id;
> > +	__aligned_u64   data_uptr;
> > +	__u32 data_len;
> > +};
> > +#define IOMMU_DEVICE_SET_DATA _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DEVICE_SET_DATA)
> > +
> > +/**
> > + * struct iommufd_device_unset_data - ioctl(IOMMU_DEVICE_UNSET_DATA)
> > + * @size: sizeof(struct iommufd_device_unset_data)
> > + * @dev_id: The device to unset its device data
> > + */
> > +struct iommufd_device_unset_data {
> > +	__u32 size;
> > +	__u32 dev_id;
> > +};
> > +#define IOMMU_DEVICE_UNSET_DATA _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DEVICE_UNSET_DATA)
> > 
> > Maybe just like this?
> 
> How would the iommu_ops backing this work?

How about the following piece? Needs a test with QEMU though..

static const size_t iommufd_device_data_size[] = {
	[IOMMU_HW_INFO_TYPE_NONE] = 0,
	[IOMMU_HW_INFO_TYPE_INTEL_VTD] = 0,
	[IOMMU_HW_INFO_TYPE_ARM_SMMUV3] =
		sizeof(struct iommu_device_data_arm_smmuv3),
};

int iommufd_device_set_data(struct iommufd_ucmd *ucmd)
{
	struct iommufd_device_set_data *cmd = ucmd->cmd;
	struct iommufd_device *idev;
	const struct iommu_ops *ops;
	void *data = NULL;
	u32 klen = 0;
	int rc;

	if (!cmd->data_uptr || !cmd->data_len)
		return -EINVAL;

	idev = iommufd_get_device(ucmd, cmd->dev_id);
	if (IS_ERR(idev))
		return PTR_ERR(idev);

	ops = dev_iommu_ops(idev->dev);
	if (!ops || !ops->set_dev_data_user || !ops->unset_dev_data_user ||
	    ops->hw_info_type >= ARRAY_SIZE(iommufd_device_data_size)) {
		rc = -EOPNOTSUPP;
		goto out_put_idev;
	}

	klen = iommufd_device_data_size[ops->hw_info_type];
	if (!klen) {
		rc = -EOPNOTSUPP;
		goto out_put_idev;
	}

	data = kzalloc(klen, GFP_KERNEL);
	if (!data) {
		rc = -ENOMEM;
		goto out_put_idev;
	}

	if (copy_struct_from_user(data, klen, u64_to_user_ptr(cmd->data_uptr),
				  cmd->data_len)) {
		rc = -EFAULT;
		goto out_free_data;
	}

	rc = ops->set_dev_data_user(idev->dev, data);
out_free_data:
	kfree(data);
out_put_idev:
	iommufd_put_object(&idev->obj);
	return rc;
}
