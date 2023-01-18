Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8AF672208
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 16:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjARPuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 10:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbjARPtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 10:49:33 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8914F867
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 07:47:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSFfiTQ38pXlIdpjQYvKADRZEZwUMHq4znPWFI1OqgmTYf5xqIZHE/1UjJMP4bGw43OIJ7sdZa5uvvvMFcUuvL+atFxmzWoLeCYEXEfOZeVbjLcTTG6Cm39UFzzUUs1RMXJwVQuZh/rGq6RSozduUa6+Yxz4Mrkf0U1dE+Yg0KCmVNB61N16IpUdMBo74aP1TA7WPNDO5RsFCkERCvXkA53ffRHaYwURwufawwU2h0wFkihQ9/qTQo2AN8ZGbEn0QnA+kwSxAsbFH1iDi2TnzJGBLdexFNTUi3WTY1iQD9y3GmBqtCpJ8TQAzQQtheIFiGrbARYasOsMGzwaXzLNTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kib7FYygz4Fdu0zEJ+EIYLV6WJKC07gFBKXzXERSXew=;
 b=XnQZOMa26UKr3RsJzo+Yvj5DHiOaNGqZONg/uQfESYhNqPLvqNuqmncSuk74qu1uV9Z7RKvvgfWTp214PRA0QdairPBUgXi7AIAq57IWMfo/HDu6Ppa8tFj0Y96afzlqVozBR/tQ4k1419k7lVOhojgfMp+g4BNqeUMwfSW3IAdDmEOAMHKqIVAygYdzeEthZBU1Ou1BpzacS/t99O3Tu8UCE8EY6vhFdHqf4O0UAr94nF4rnhToupV0sgHVihxwkIchXCm1/zhVK/H3cIbp/7jcQHXryeIZ5vUZTO2pSCi8mkY2Mv5PFLq/TfezZnuFgGAMewzIilsuYBgIc0icqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kib7FYygz4Fdu0zEJ+EIYLV6WJKC07gFBKXzXERSXew=;
 b=JBf6xy/6qm3OcUvHNi6rWumCGgWcc8RrIDbNOCJWnutmjPsXkrXOfGNZIWALbI5V1Gul3tVPyPTd32CWt8wX0TTr5hJNoyZOeQ/eWfU+W2sVNhaXJ4Ov1J/LDcxOTKd9qsbnBdiyZ02A+kFjYjtJzXxzFotPn9CznU82A+I/aHnGsNnwiqJ9E2lBid7TRfoNTqmuDK4XfxWEw66ZtSPqvpjALzz9t/SwOVvyzxiNw1DCshpOpAp4Kn3XPeE+39I8gSntQfYn43n/SEt6/FjeDbyvAcb+gPlXysDmb7uNIq9rAmjZlrkPPUGtUewLU8MMZg6h41V19V6po6g7hubaKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4269.namprd12.prod.outlook.com (2603:10b6:208:1d4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 15:47:14 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 15:47:14 +0000
Date:   Wed, 18 Jan 2023 11:47:12 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v2] vfio: Support VFIO_NOIOMMU with iommufd
Message-ID: <Y8gUgL+VWaL8WOZK@nvidia.com>
References: <0-v2-568c93fef076+5a-iommufd_noiommu_jgg@nvidia.com>
 <20230117150256.1937d343.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117150256.1937d343.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0317.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4269:EE_
X-MS-Office365-Filtering-Correlation-Id: d4eb98f1-6a5c-45dd-17b5-08daf96b44f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nI1VGMiR8A+Mm6jTLIC67sU1O+IBK/j67O5tocJ/KFs+YnqqlPCYDRwSM/0Z3vA2McDUd5iBdWNOn757PpjdgA88iv2LI3Guzmir1YFcFDzJAd9k+KyzGnS3nYA47zhJUS1sbo95wbMkYaXc2yGWtiYP7A8iB0xAqiLNge4zKeykZvIgi+F+NLjpvBH9rrZP8MMu52ZIvh6QHsqLmJwj9UbZWA4Ky6pmpuEtbJ+/lwODbDeYip7q5MSxCUOWzMguv9gX7WRsErAVoVRJG/8sRVLpFGzUP6iK6WAndj0XHD5Jd2xKB8dTVqqyq0DHYt8eedk27487S/jL2fWgXMhesl9uizcBUJNBbYMblfGH6ev+ilGhT5709yitBPeBitO28p4hkt5Fi/YsXFhYQG2yPFKf7aJMdQp7JWvqC0U4ZAFnXZOtfbC5nlLpsiKpPBElWWuBgXeiza3QCapmm0KPNSPhhXKXnuOz2MgNACZV+DCXJurQy4kN4aVu96v6UiQ2khCLCVFPmiFCUPDUXUcgHgyDm4fzHb/QdEts5B2o9N++q6luXKP6FBgeJgesIC1XRS053WwJvVaCfJ/QaClrnunGCj7ySf4g0BoUEsXTr6wsuiZ9jEOPb3+d33Bb5yhM1Uqpe47SPyMG2trDHf053h8s3FoSdDCX09tU5lmZu/LMAyNQDJHqK/1ZnhFlQ3Es
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199015)(2906002)(38100700002)(36756003)(316002)(2616005)(54906003)(66556008)(4744005)(8676002)(4326008)(66946007)(86362001)(41300700001)(6916009)(5660300002)(66476007)(6506007)(478600001)(6512007)(6486002)(26005)(186003)(8936002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?THuXHANMtJXo1oYiYqWem/KDX7MNmyRaPpa+9sFps+wYNnJPiimGuzL40VQt?=
 =?us-ascii?Q?hFF8+owz4LCAslddSQrBpo6d1gGQkUCvxrGJEl5hzD/IE4WPpbYRYUgT0Qic?=
 =?us-ascii?Q?xNs1MIN0YjKDqsPZRvxjCyYhanYXL7jdXxPA8lmHEf6BfiaAyMouWC+1bz4T?=
 =?us-ascii?Q?9LmquKc48rQnrBiYKWfbPyKjn+5BeQfbAGdvCaFgWaw80Z/2hm0CKTMP2L5J?=
 =?us-ascii?Q?5uyNT9QmkgblU6WjXPBTEU+jB6RBkxSVvHfojKkmPSZ/CPBm5qAge0Md8Ash?=
 =?us-ascii?Q?MUvqmTpkXUgVVBQN/s2bns0bYQenHtKNxH0O3CYdzcPxy67Mm0A2mhQg27Ka?=
 =?us-ascii?Q?xGVg2GK9M2B5IGgFRcaAINPfRuQ/Dw8P7djNHufUAE5dXJkQTl95xlw4/ADv?=
 =?us-ascii?Q?JHZkO0OECCFun3pXTx+zNzuuqQ9QioVMrGCYMSvnSLRrf6Lr7mgPeZnz8WbW?=
 =?us-ascii?Q?5BFj+S9txWg3iy8zYdbYs8sDiMMOfg9uDCqioh4+lwHvtnguJu7mAQcXdP0e?=
 =?us-ascii?Q?uqxBsylcoKBtuw5h3wq+8P+OvSx07Wcc6fN9oJ0B5I2D/KXpHVTzOTZDxtGe?=
 =?us-ascii?Q?qJtJGnhzBAOO8iW51+OLnoX4TWOVX7aV9RMidAwko4SlvOMdvRJo6bq23zTP?=
 =?us-ascii?Q?ZRkovDgM1lhTf4wCEDjulwcLzlqMu1AGfvJSqycJIXqCyR/CamjTnCb1V9W7?=
 =?us-ascii?Q?QUdoQLjsBFUwUASs0zc4COK7hlAIsU3PYoEFHuAl2nq8Rcthg8g593SpwwJL?=
 =?us-ascii?Q?A4YtKfLupczHSo0MSc+awq3mI9Ai4oOeSOv1sfzjLcIZGnanpHcfEPcydWE8?=
 =?us-ascii?Q?yKSra7HyBUJRZC/KwUQRo3DUCZ+OU9IbaSegUf7vuqFLhMctcELpPpy1A8uu?=
 =?us-ascii?Q?gQvHoO2r+yPuvG+DSy+V/aRIBY3o6bKCx9eVCjmCFS7OSCWBvNCNKcQQqlpb?=
 =?us-ascii?Q?REOKCBlJw8aQZ1xZqFGVHvDS0ZcvxskvMZYSoJI9T/Vk60KxFduPc7l14F6T?=
 =?us-ascii?Q?X1LlOkZeMdmfJ5F8ZcKEFpaHDEffKpebAyMoZv+bqBObrGwZMCr9PwlgLWyV?=
 =?us-ascii?Q?pf/zwPkT2NJUhADY/AYwPtA3THMxpmTb29tR7XFA2W0DUnkZLcnpy8XO8rrn?=
 =?us-ascii?Q?WuFKYUjUxT7Ce49aW7NnObO9pSpEW6brdHDXgrJowQRtMU4f1XzfV8ppKPnd?=
 =?us-ascii?Q?SbCiLeZF8Fy2U+AJ1+/CGp6JdSYvaqj+NvHvtta2ANufZ4kIoZV9RQ7LD6PR?=
 =?us-ascii?Q?TppFk6Y/1iAKconmNtarRdWDw6gH1/KCGSgYE3qpV8ChhfJCGCUfoqQlq0rI?=
 =?us-ascii?Q?zAJ9TXDtW21pinjWJ09aFbEnik+gSyzuzN0mB60N/aezyvGHwszCn5IWEGL4?=
 =?us-ascii?Q?zZF3HgFyCmy249+xnEJE2U5me3orYiUnrOFb6DO8Ijehr64kOOb4krkBDZww?=
 =?us-ascii?Q?MvUYSKW28+AjzI7RZH/kLXLAsufNUH25eGjxYf/uPD1tJaIncNUY1H79ITDo?=
 =?us-ascii?Q?cTpg3s+iynkRRs4DbP9OaxQiS18V86w9eac1/boiRQ5NrjoknEIFQid+NfpM?=
 =?us-ascii?Q?3NA3ApyS/fMbHjYiSSelwBsxTLSVJ1eCC1rbuSzy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4eb98f1-6a5c-45dd-17b5-08daf96b44f0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 15:47:14.2092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gXopjc3W5fGxh6z9DNPl0NCx0j/5tJ1RLtJR2taP1UwkB3JYoxla2aKjlwBDEI/F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4269
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 17, 2023 at 03:02:56PM -0700, Alex Williamson wrote:
> > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > index bb24b2f0271e03..e166ad7ce6e755 100644
> > --- a/drivers/vfio/group.c
> > +++ b/drivers/vfio/group.c
> > @@ -133,9 +133,12 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
> >  
> >  	iommufd = iommufd_ctx_from_file(f.file);
> >  	if (!IS_ERR(iommufd)) {
> > -		u32 ioas_id;
> > +		if (IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> > +		    group->type == VFIO_NO_IOMMU)
> 
> 
> We can't have type == VFIO_NO_IOMMU without CONFIG_VFIO_NOIOMMU in any
> of these cases, so I'm assuming the IS_ENABLED() is just a
> micro-optimization for the compiler here.  It's repeated enough that
> maybe it deserves a macro though.  Thanks,

Yes, I put it in an inline for Yi

And did the other stuff

Thanks,
Jason
