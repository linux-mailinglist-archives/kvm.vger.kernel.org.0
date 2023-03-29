Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7E06CF6EC
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 01:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbjC2XWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 19:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjC2XWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 19:22:18 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E06D3;
        Wed, 29 Mar 2023 16:22:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FkSjE+Ewj2C6ktCbDVu4QNKDMhnRUTR/HqwscKFv6VOyqSR8FIHUf5OfghzRSgeqLqZYjf54BW0Zr18Zbd+aKbOC3a9iCIM7LbI+rtcVlUovNX5+LVAvDXCVWk2bdGv2S7kvDQ3ycDyPyy8wRDII1R5azgg5NYdR79AVMWehdRMcAuo2wO7PkZOij27jNGtJGMSW8PUocPxEVl2swmPI+7Gwxce/mzrsCqhgGPuSBEPZmF2mzh32K7B3i+58H33KwGeH8vNfbgzsewapp5IlpaxGq4iETeSo8XYV1lHVlnXG5GmhroB0A+p2r+mueNPTcomJ1aejQtO8ZaVChwQmWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kguGaB2QFHRP13PzFvKdKGnhzYeheAPDHMobZNVhXuE=;
 b=MDg767XtOExed8ZKOScVdy4rKIGTLfiQaWXLnV9oTWK7f6934VQhCQkldqkiZQ2k6UySd6wXi/fQs8WKkInluvUg/hSseFY6qOSkFb+ivFYniaf27G6KLaNwqVsOTRTn8dBomOhmqfak1SwEqPGxJ2xrCe4fbOfAVWMuyu2LzqsywIZmuIwCftb6snBXQ9e9IiB+LRGvrQCFJR9ZwUdzEcPHn6zV2SsvR77uBu/kxRa5o5AtaF55CrBkAH+mggMgN5bf0jCM1DFkQ6ao7V8ENCLjHOnJk5qgS777m8VfDcqHvS+HVr0BDerVlpDYAqlnXsHgFJs0ebEdvMT5Ngv31g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kguGaB2QFHRP13PzFvKdKGnhzYeheAPDHMobZNVhXuE=;
 b=qcIVwvvGz03KhYl3lHW+iMWjRdXqZ1MPrsS/96JW68uJfxbONKe2ZpmmEhjncQSrBLv1nQqDq7BqvjB0VFliCzLGiJ1rmUxDG7IO3ZjK4NAwLa3L9WQrYWT4p84RljwBC0t+RPf1oCtk4msoU3aqyn6fFshF9cU+kUADXl9K0J3kELC1VosyAzFSxE9yLx/PZLyGvlD5ZbycVmia2BD1tAGfL+dy+UqWpyufm06TOE+0+P/ONPlX1v4mhwKw6Cj/DxWwxmIqXeHKdPs0Kj1DMs0dal7W+bTancZ/iE3mbVzdiEyVp+ZZFysIYIMz7GlXbMRyPoZD2Y0WFavjyVrXKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CO6PR12MB5443.namprd12.prod.outlook.com (2603:10b6:303:13a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20; Wed, 29 Mar
 2023 23:22:14 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Wed, 29 Mar 2023
 23:22:14 +0000
Date:   Wed, 29 Mar 2023 20:22:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: Re: [PATCH v8 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <ZCTIJScfgbWWguD5@nvidia.com>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
 <20230327094047.47215-22-yi.l.liu@intel.com>
 <20230329150055.3dee2476.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329150055.3dee2476.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:208:2d::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CO6PR12MB5443:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a1cf86f-ac7b-41ea-5259-08db30ac6e4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eUALv66JFT/jtwEIRqCE4AET6QcFOD/Zm0ABUr+Qx67jFlces50paBpeKM9UiltyHJ5zbs4c1dBLVqXS4uyDx5VPoQcVptnT+DtzElbD+HnRsNFQgsBM3AtyDjNj5JpXSglPtdUyS4k0aPQe6WxoLh/Zlvd+BqsWkKJ+shtpl7Dxf5SgHN1ndmEWqdq07uWpzLFg0FGT+hR2KswZr9VTV5N73iNwgMNOOAXUB9J8lePVVLoFtjNmueJ1bojawpt8kDdohbNW2Y94REznbubrlGta/Tm5dXIz4gxUap7ZLCIAJ0c9IAfrOWpIvion4zl4wUybaugXyVgTgP2du6CDUZ5fZmCUccWrhfSFEzQ1iwNMusL5Nc7j8NOBRDQFaMDWKY/2umRznLp4Zc1s1CeSD1B/dZeqMH1ZKn3xLvLkLA2dFa2jBrNU4OdLLPJzMfdcUzFNSALO47YynfWyLzzwjgYjN1vkcJj6JXE0F40zI+dL+UE2VfiiCcyHcMwrUDFo28IWZxKtW1nesrOLaG1pXo/e7cX9S3JWn5iWEeExDnn2DBhPTgof81NMtbRHN9iN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(451199021)(2906002)(8936002)(86362001)(66556008)(41300700001)(8676002)(66946007)(4326008)(6916009)(66476007)(316002)(36756003)(478600001)(5660300002)(6512007)(6506007)(26005)(6486002)(7416002)(2616005)(186003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RJ/6X4bBfgSwqdzZ+JK/wmaYAD6mk6QBWnWImU1r4ho6ZFbWlrbTWiLFSkmB?=
 =?us-ascii?Q?W2TEO8dCE+PK/fTh08yzs0yfxpUhWrdJZr4d62/YiIb+qEax7WEJMAszMIGr?=
 =?us-ascii?Q?Q5EDRRGoT5bqtBuT972LQkPg5ndfe7hjzdlM2iyUVBY6IYP773/xvNjZXPKv?=
 =?us-ascii?Q?2HPOR82GB63IkRnF1uNB67lFmzJkpglE438WULPPTSvwn2Hzjz8aJ/B8VcBC?=
 =?us-ascii?Q?Tsz2UwIO2datc3gW8/XKIR7Ky27dbeX2+t/sVE5Cy1oB/rHJt24Xxsga0dtI?=
 =?us-ascii?Q?JfkS8j6URHclRKc79O12iLdqqPM3yNfxodc4QdupA7WPr9aVo46kYdy9hw8V?=
 =?us-ascii?Q?ECSnimvEEbv9KJqfFdgM8WsmjVte75STOGyY/wr6+l5+bcru5CoyUlCLxTJN?=
 =?us-ascii?Q?GIKsXULTdUPZnakdGpAHqUdYGsSEC9cE/yRwV9aNBFhCj9J2Tt9q1G/6jTkl?=
 =?us-ascii?Q?wFpZyKWjpnts4+sTMMIYAj5OZD3614QusHWHotACeRIG8gj8TYSdYvjyK0Bj?=
 =?us-ascii?Q?XzvzOJ2pV9ss+gRh5wAWzCfe8akxRW2GrBkJOiaFUucdoOOOx7q5DUiyA4Lq?=
 =?us-ascii?Q?1qk8d3GtdcPsHXZylW8iqVLdtZYk6Tou1ZVd9QE+hxJZpEQMpzev7c1ubIx9?=
 =?us-ascii?Q?YoiQqD7qIbqe0QqQ5hTw88PXMiD5KA7sxtc24wAK9wojZcyK1fCDJBs07LDt?=
 =?us-ascii?Q?wRLYyPEsep+8nmRxgGRJO0Gr0ppDYAWAU0fyVFzdP3atoea7ZRQPH2zp3Abi?=
 =?us-ascii?Q?27xWlIBAjDk3WPVtTa5Oqk9L0E0wnnrtrtKwHHBrk0LuXWPmCJx3Who9gdlA?=
 =?us-ascii?Q?uiwvhWTU0hf1yMjou6MumYLxFFNvCP6otDCH5XndzDTV8bd5eOsfozh61y9W?=
 =?us-ascii?Q?efflcy6QvxsHEa6HRejoVIz1Ln0bDQiD3arDu5MmGmT31MnC2uPKQFTwbfcO?=
 =?us-ascii?Q?Zg/z0tHhoz7dhEEy/CEokAVgtMnkC3AHIlSDHu3wOW0Skq+buUfih917rim6?=
 =?us-ascii?Q?qDGI0yjH/kL6Wo/fs69ZVFEIofS/4BwHs1KQz+bugytZhQR/yO5uJGGJmKo3?=
 =?us-ascii?Q?rrOWhDz/JGrD59TEzi0L5SsStdlPSWrxddzzuX/SKY6xvfPyGndTZ3XxufRl?=
 =?us-ascii?Q?3WzAIEhYLQdQnpDFkuKmNNLGOakdkX72fxWfSn2vLJZxM9yBUdCPil8B2KzZ?=
 =?us-ascii?Q?IdEXnkS1MHqPKi9nuLkPhASb95yKFDm8nQTx9iVIltGAhhj0Aqs10+ExWJhD?=
 =?us-ascii?Q?G/Qc45+At2OQgfZBKpoVjbqsN5NawKuidTeSx8gCnF5EXOlZsn3f89WcNEj2?=
 =?us-ascii?Q?gxBX5k6NyKMYJGAfGde+SqSoEZRpS2qDiRKAJAzVjjnNIbEzlEKyotPNDdFb?=
 =?us-ascii?Q?wifTx/Us2eQHwNjkqdbn/Pl9eNvmaoyRQkd1iWj+f/NUq5ngVkPjpM9WeTMV?=
 =?us-ascii?Q?n03XEZLOCTG8zCezW8H5t6u+sBCRwuIA8ws/LtUSDxvnALShQJcdQxE9L1ws?=
 =?us-ascii?Q?61l6IT+h0pI2oyRBeey5c6yVhO736zBuEnNgcRsDq7pbCWR/0GFSUEoW4aaV?=
 =?us-ascii?Q?X6zov5mH+2veDJXV1bwXg9+nouXRe7h1bCJK3lOt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a1cf86f-ac7b-41ea-5259-08db30ac6e4f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 23:22:14.7351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p+X5xlRp6sTOxHud3BiMGO7xOOQFffphEVlWFkPfdwQ52lI86UskkaTcMwa5b7wO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5443
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 29, 2023 at 03:00:55PM -0600, Alex Williamson wrote:

> > + * The user should provide a device cookie when calling this ioctl. The
> > + * cookie is carried only in event e.g. I/O fault reported to userspace
> > + * via iommufd. The user should use devid returned by this ioctl to mark
> > + * the target device in other ioctls (e.g. iommu hardware infomration query
> > + * via iommufd, and etc.).
> 
> AFAICT, the whole concept of this dev_cookie is a fantasy.  It only
> exists in this series in these comments and the structure below.  It's
> not even defined whether it needs to be unique within an iommufd
> context, and clearly nothing here validates that.  There's not enough
> implementation for it to exist in this series.  Maybe dev_cookie is
> appended to the end of the structure and indicated with a flag when it
> has some meaning.

Yes, I've asked for this to be punted to the PRI series enough times
already, why does it keep coming back ??

> > + * @argsz:	 user filled size of this data.
> > + * @flags:	 reserved for future extension.
> > + * @dev_cookie:	 a per device cookie provided by userspace.
> > + * @iommufd:	 iommufd to bind. a negative value means noiommu.
> 
> "Use a negative value for no-iommu, where supported", or better, should
> we define this explicitly as -1, or why not use a flag bit to specify
> no-iommu?  Maybe minsz is only through flags for the noiommu use case.

I was happy enough for this to be defined as -1. We could give it a
formal sounding constant too

Jason
