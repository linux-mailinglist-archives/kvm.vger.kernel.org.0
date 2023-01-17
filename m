Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F91466DEE8
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 14:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjAQNd5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 08:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjAQNdz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 08:33:55 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FCD65A6
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 05:33:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQAMbiaBEvYh2OIqlX4aszCyyp7xyAs2rl7XEc3HU/xn2ZL8zBvCweHp1qeQamkY7Vnn44XUbb972hTiG/6SDa9rT26wF8E8S3Rnwfq3R5yuIepV06SOPCk1P3SjGzD6FEWgGBPI+1rWm6dv+fR4adJLBWV02/QLSz2DnYPcxHUk65jsW/L8WRkcG1KlnG2Dku5YhJoMRXn22ALxT61gAd5S33Yon2AlAFj6suY9a0qSDzehMdAeUIVxNiLMUaeF6+ZEWMy707oJLyKYMpG0sIQ7U1qhOQ6X4npFSSFgBfvCUFrUZZ3WYAvry1DocHKiug4cXSYUFUZZhq1oqDN6AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O1fPA12E1Wg3A02kdOumwE84iOP1aabiYav7tBzXcCY=;
 b=FzqZxED1PWDeZkteYYeieeKJPD8qBRCttmxFPKFjRpkSUUo/esZgUtCWN0ekvxJbCstfjEQs7hKQiF6VtdNuQV/szD6adXMeL5qIFwtFkmleOYBQkGeE1q6LuNihXx5vPA5pVOH7sd74KfnfwwrifBQX1+WdbUNStoZz6eFT4QFXKutv36uRzpoXbndr9gyKEntmk4VFsIMELV7x9cC8HF47pOUKxMuUbBfQvxw75W3FlEGjEMjEsgNXi6ocaQ+iFF5PTUqm4bA+bo9z3P2hM0GE6Q4qFZkTvCE2NWEL9ShS2kdABtl6wKROD9ksVbutyBkaSujiFi6ThhHKKLBMCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1fPA12E1Wg3A02kdOumwE84iOP1aabiYav7tBzXcCY=;
 b=FLKlR3P2YrLt8vM+tf+sGvPANkyboh5zjr3BLUvNZD8QhMeAaxlr+UEV2oW5gFaUmHl6sFr4jpqkKo+Q7+4ya5ra5LpXEQZM54tAGAD15yEP7YqdJQ44Wtu0KI16gxYUzp1iBjL7VAq66cdcn6VTt4EFCY2DSuNDz/Fgi4kRpfnpWZlmZvWzCJ3IC6XcxIEUXy1lw6sNjEexuLB8/dJ+XuoufCVY5RlPRP+aRUpsjSPtikO+7PR7EggGmpS00pOc3YEkWqiqZsxLWRXizWhcZSFatrW19mTPpdnGAg6J5Ws2veVm/DHag+n2UfwSXRrhscyzxvIag71cIL/5Yd6vdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV2PR12MB5894.namprd12.prod.outlook.com (2603:10b6:408:174::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 13:33:51 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 13:33:51 +0000
Date:   Tue, 17 Jan 2023 09:33:50 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] vfio: Support VFIO_NOIOMMU with iommufd
Message-ID: <Y8ajvgYMgM+dKUWJ@nvidia.com>
References: <0-v2-568c93fef076+5a-iommufd_noiommu_jgg@nvidia.com>
 <DS0PR11MB75292238656F19908C0D0A4BC3C69@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB75292238656F19908C0D0A4BC3C69@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR02CA0104.namprd02.prod.outlook.com
 (2603:10b6:208:51::45) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV2PR12MB5894:EE_
X-MS-Office365-Filtering-Correlation-Id: db71f04c-6690-4f60-d419-08daf88f7871
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dSs9dS0BcnRWjQm/5GlKY5R2cQ+4mHUpkhwx+IxVD/ol/dyJVyN19sXvdyt9uXM0662gHZVFAi6SsUGiX45ogtfXX8j+FPeZ2sTzpHdaDnp5iUz3HtVwPhVuxbLK5nBHnz2RIO6zGivWvaEbhel7j7SVnbj7MdrZ/HkVJgUUu/c4Qx2GLAVnCL8dNVrXHn1jdqByUtqua2I/XGHxI2QGz18dXVD82pE5W3XuE54b6w3As71zLW5NPLs1N/rAjjflfhf2mvDKqtpNSk0NQ0lhYleUOhvxz0yVjuxQqZGbUYfqO463W+FgsguA7h6Ub1u9ahDUm05WfuY9BDzKiKbavJvLxEJi6q6Ute+3qTRbV0L9XtXosHrVWlbJf4uBdXI4hMpTUtC7ZlvifHaYCfBKPKAcCjzu6fjYFM6LhtUdFlGuQNsLbE7zCoi54hCZoTXuQCpW1UR4XwLrxkcOu2fmfk+UBA+dSSbnV+tH6USV1t3xoTT+ZFY9vY1diSOa21b1prJAvJnhOYQSEPnh+qp1144yDOzrCEzTwZG2WBvhDTbVGn0WN+jyaBbueUtgoldL21IWw9MsA62aDiLxDIgkx3pVcJgOHVBNoEXl6QgAdYGu5sHjwdHm7U66vbqXBxmXU4EV1ep1+GmmBg5yOVOgNA+54FV3hotpxRG0RmGAqre09xq3hQ/5TwYJzGNoVMpW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(136003)(346002)(396003)(39860400002)(451199015)(36756003)(54906003)(186003)(478600001)(6486002)(6512007)(6506007)(41300700001)(2906002)(4744005)(8936002)(4326008)(6916009)(316002)(5660300002)(66556008)(66476007)(66946007)(8676002)(38100700002)(86362001)(2616005)(26005)(83380400001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EKzNE4sZRTNTwUP3E+spKN7p136EzQY0TVlAxozL2BsPnEXc2/BRDdN17+Oo?=
 =?us-ascii?Q?CbAFpInCCdmZE1Y5JG+wVnCCYK95BMdKz5ksNBsgwDsxMM4E+Atsa7W9EX7f?=
 =?us-ascii?Q?dZ1gEkBQCYmsti0mxJ3WS5gAPJ2i1TE+p6JV9tYFPN/ZrUPSKkWTJwUs6uln?=
 =?us-ascii?Q?wplFCnol19Apn55pKvHjK8Azy1TCsPWatNi2n98cu48wdFytgDVhpBdL4APb?=
 =?us-ascii?Q?oKW0HRtmkA2jXB2PUvJIy+heOrCmbePKC19BPFebI9G25RIJZCZy8v8WF5yK?=
 =?us-ascii?Q?t1Jj0CuaGIeC9kAsHolde8SeFMmc4zxjF434gp3roChwjPXcXB1A+ehXnTIO?=
 =?us-ascii?Q?KIWRh+QyTtqa08BTM3PC9Cqw6Txanh1JzclLIZCOhz5qxpPLbSdHUo+KEY4v?=
 =?us-ascii?Q?dqOsaHRhJGc57fWI1ZoGch7DjsbvdVaddQlqCESVaWX0XK2JjMk/GpWo8AXl?=
 =?us-ascii?Q?q/EKsAlfw2DgK/QL2B7DDV1AQFHIAu4CAhvFM0y5rYLT4rQCn/ALBbEdY00E?=
 =?us-ascii?Q?Klc4HvYg4R9INRi25D+6N/XI+8pFVTBe3WxI+8ymrFx3QhQAPSVceMSxpS1z?=
 =?us-ascii?Q?FpcPz9r+I0T4F4CT97qFBOWDvQ6EtDZLJoCPb5QGHvU7THzMkfOy+s63eUkC?=
 =?us-ascii?Q?AXlbXBoFgJXCdjonuhhB8kNqrEui4CQpHwXubwpYLm1FTCaZBGl2TwlGe4/0?=
 =?us-ascii?Q?XIVXyUlyLNxj+9icBGiB8dHj05lOUIuDfD7SN6YUZraR2V2dwSsTltWvrUQ2?=
 =?us-ascii?Q?I+LibyR1wpEuB854b/PO+ALif1Ed/aY2iqJbM6OHadrlp1yIjTMYmUOSmhtJ?=
 =?us-ascii?Q?9h/jn0WHclQvKWVZZMrBwf2L4mX9mBvg6XgAc5lcw0EkPte3iWdNFbGRHt3T?=
 =?us-ascii?Q?HgPDYZn1no94khhRHBy7nse7qI0ad94s9nkKLYE9ecIx06fLDcMYLFANTAkR?=
 =?us-ascii?Q?bGCc3unDS7OUArRTB9agNr5FtqzsnAVg2MoFGJpVJQn5ssRD0SZLj3U0nuHn?=
 =?us-ascii?Q?f8BtF6IxBVhdk2CtrJfQey1hMWFxcvUFVLKCLsHNv5tLGQFm7CnFCv705JwI?=
 =?us-ascii?Q?1aPgvuFabliynz3AKVHUzelvKFG1mXnzGi5qxWdARTDnWIbQ3C5WbYAxTmHL?=
 =?us-ascii?Q?8IB8hJW+dLmuqGKBSaYECgkjrajE55DR3U7UKMcEpWeZa4UfyQE/oz2tLF5B?=
 =?us-ascii?Q?Wj1SlzjdJK7TMAx0MXQeLiTpNS0kLpFqYlODPv4sM3iGJEBEye6B7h5Hk1mk?=
 =?us-ascii?Q?UcwrlCLk0+e7gz4LN9txF+RuWgujhglfOhXAzcjdQa/MDWU5H4cFRXxOEpZZ?=
 =?us-ascii?Q?0vmQmJB8YgEI11vJwm6Em53wMOuaa16fjkQP54ADpLtU9/AZZa6c8JORLHry?=
 =?us-ascii?Q?Vzw4cqtfUDYbdk+g5ij1OmBITIyw95GBvF0wOW8BXjn+yYGPt4pbFG9e/GQK?=
 =?us-ascii?Q?4sYHiHAubzcD0HoiwlqHmm8luMZBm1+5KRmDQZVr9fC/ktalECQan2smtnyj?=
 =?us-ascii?Q?cjEQZMQA4srF+0vkYkoyJaO1286FORjJiU6dnfmFphhQw9FmvHUvIWvWw4hV?=
 =?us-ascii?Q?/wfVnNN0Sv1cOm1luPzIaJkW54WWYB3TkaCOImtO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db71f04c-6690-4f60-d419-08daf88f7871
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 13:33:51.2490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: atzgFbOPDLolzQjGEBzHhMuDR6YtIhjgHBzhuDLGm6hz61Vxb+4bIvAgwdUDk2Qe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5894
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 17, 2023 at 05:14:12AM +0000, Liu, Yi L wrote:
> Hi Jason,
> 
> > diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> > index 4f82a6fa7c6c7f..79a781a4e74c09 100644
> > --- a/drivers/vfio/iommufd.c
> > +++ b/drivers/vfio/iommufd.c
> > @@ -18,6 +18,21 @@ int vfio_iommufd_bind(struct vfio_device *vdev,
> > struct iommufd_ctx *ictx)
> > 
> >  	lockdep_assert_held(&vdev->dev_set->lock);
> > 
> > +	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> > +	    vdev->group->type == VFIO_NO_IOMMU) {
> 
> This should be done with a helper provided by group.c as it tries
> to decode the group fields. Is it?

It will make your cdev series easier

Jason
