Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4AF6C1DB3
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 18:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbjCTRWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 13:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbjCTRVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 13:21:44 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6D949F3;
        Mon, 20 Mar 2023 10:17:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gWkbN0q72H7+P52slGCvet4sjesNGk9sI9UvzyvAKnn/OtCB/Z9KOUEhIDCOWL3NNMuREtCkKyQiyw+n+uPmLFmL5nUyijCNtzNF4LsYyGv84Ri32rWatTIzYUyF2CJsNq4/PTcTCKMWsxIc2ktCYu97/d0v4AMrAjWeKHtw/4vhnweOgQD9wAKkWTKhJTt9XsstNrN+QrHSDFHY8FWYeGLlG1Fs+forlK9xMsrm562GKh1GSPd/gtI4xdMaqge6nr7/b+ESUsd6xi0VD2kGK6b6d4xtM11635sKSpPPpd5+gVqvOUdUpUpsqa3ODglWtAr+rrHVcS2KK/iDNQDVKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UDOQP2vo8kuV9gIuxqbO0pVTYF6Px7o8KIIrZkX9xzA=;
 b=FhtSrqSnYbxXXc2xMtI/cW2HSlXQu8aWRObuhcn5hcQV3dqn5Y72lrK58XXgWfm53s6XjOx/GjNWGsleVqZFVx77Wt74dl5SlJnNRlPdyDM2jeSV6/1qhMN44YQaB30dUaJi+4CpZcIzB27fFbBVWMb0KkWt0iw4hqTagB/H4o0wxD6aHhvozJPVeA9aOhUUwpUZBoOlImru5U8f/eSNwaa887Zr5l1FuhBuiqu1QeqwjJgFEm0aU8DTYpNtQDEk6jsui0jf8BfNBcz353JVaNTyDyZd40g4sO7mLENvW3ZE3/sM2GbLe6Zle8MeI+kRXvufiBoT2VTNycjdhmk5fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDOQP2vo8kuV9gIuxqbO0pVTYF6Px7o8KIIrZkX9xzA=;
 b=oV5AtEBrSDcjYnuILeWH+Cfdiog8vw3XP6rXne8l+Bq3pqJRROoQtoRG0delMc9lA4AaU7zTs9ELJ940tWktYdviqzqQvEQaM51XMcxOY567AsM23VRxh9mrbQJMfCnyrUTs1XmGpbPhnpDALu9YmciKvpDVo2J19KmnMcujMJPbuwY3ByWYOabrYm/D02cUz+/DvYz76Qo19RgGRULtLrvWA7G0PxVgnHWb7rlqWYI14Ty4c4d7D13eA87bIoVXklN5OzgcDzwxDlsDrVquoORKkEfiwH8lsZO6tfajFCcRVfHgZ9IUeSUUessXuPT6Uy7dSf/+8ACroiX32krD2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BN9PR12MB5367.namprd12.prod.outlook.com (2603:10b6:408:104::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 17:16:33 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 17:16:33 +0000
Date:   Mon, 20 Mar 2023 14:16:32 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v6 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <ZBiU8KoSmiM+JkAw@nvidia.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-22-yi.l.liu@intel.com>
 <BN9PR11MB527665CA5753E413CB4291AE8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529B3BFD999C9720836F049C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276684B2C0CD076FA3CD0938CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752922A0C9058583F677369EC3BF9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBhpNyrBr9nm5Ae+@nvidia.com>
 <9875e60c-68a7-b360-9d52-66d4915808a0@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9875e60c-68a7-b360-9d52-66d4915808a0@intel.com>
X-ClientProxiedBy: BL1PR13CA0284.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BN9PR12MB5367:EE_
X-MS-Office365-Filtering-Correlation-Id: 4adee45e-8cc1-4b48-08ff-08db2966da39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wx8xARQFLKCD2QdHQ+d8urj85INzMi5atZcnf0tig/x3SKeWYzAgKv/2irsEeSMPArVkL91y8XisyouN9js78/HhWf+G78JMn/CUqOGg4WDz5xeUm7bziElKfEae557X46V25CzsTdVAIdJh5ETzWZ08oLNgRWHRyn2T1VBOJviI3/jzYakekE2LsP1R8o/NcXSH1hy7e+7EE91oH5Kq+PAiQKWBOgU0w1k1HR+AY89PwD+azWmiM7VY10wzAWKgzZAtYOzR2qaWsinyhrjxF7t+hs2ktZzVKQsUlzgrnxVifVyNdSMjAWV3pDcpGxMEodXDUmu2CgkpsfYqGZmKYJwFO+E6pLWOoijISo61UyaAU4gkczrGQ8p+jrHy02iAsejtWpzCcUJjL4HT43ttm7n2FhZUsWV3A+dgnH0aS1l5VWEf0W9LCeKmOtMJG85z+C2TG8X7Bpf8RZuef7TWJMDS89zxwAooogHYLbgLYY8FrtZzqmfyLRwa98QonHpjEmnxv8SwOFTvzwmhbgBjl/8HrpHdCzp2LQYtZR4DVIAtTsD83v9f1T5buowE5ppAVwI7/vo/hU0TEHu6s30+bUC5HNjWN5fK4b2cwXoJakrNw5wZQQtDOapIe/fpBGKzACgY9rz+JDyvo1hGl3PyKHeg4bWOyuSFkrKdx5lqYbhMcMYFMyPZ2kNyRwrZQqt6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(366004)(136003)(376002)(451199018)(83380400001)(2616005)(86362001)(38100700002)(4326008)(41300700001)(36756003)(8676002)(66556008)(2906002)(5660300002)(66946007)(6916009)(8936002)(66476007)(478600001)(186003)(7416002)(53546011)(6512007)(54906003)(316002)(6506007)(6486002)(26005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yC5+sPMGJ5e0vRlIfIrezyGzy4b6vuxQttkLC1Asj1f/9tz8EsEOZaU/P5LM?=
 =?us-ascii?Q?Vy2MQx2jK3/ACK50d8flFAwAd2kutY9Sq/aD9qXLFfhtxT7YF+0dOosi/lhu?=
 =?us-ascii?Q?YqL4N48jmKzhSPUG7PEdLPumgzNq0FGf3h6C8HluDsSYY1WOjXsC4owAwaVf?=
 =?us-ascii?Q?hDdskMKBIdn6+nTUm8QD3h7+CETjWDiqWD9yAnp5of/7rhaaw4mgBFb6gLed?=
 =?us-ascii?Q?qt+MeXe2G8KgZyuK/FgtrHILRTi+Hxaimjisw8bT6xY1JxpcxNbBBwwYfJPV?=
 =?us-ascii?Q?VJsYh9oz/ZVVjEmQquvAKYwNemljMQrTxkIY6pUpsjYmte8dtA+PazfuiSXG?=
 =?us-ascii?Q?+NyPHu92R9zmJU93IJcpe1jvdr+BGiVtC8V5QUM+VrQXcr1VZidog/9rdib7?=
 =?us-ascii?Q?sa1+Q+WrxgINKSrRVwAuga8RB6DeBup9hJimd/Wu3PkGgRQNGDVqTLLM+Jdc?=
 =?us-ascii?Q?u4hVKAsE67mz81rZoy9dnS+WiNHaYPQSaCq+J2mzp8SktmCCz++EFGjRjBTB?=
 =?us-ascii?Q?jLj5Zbg54qIR17dw5EYQM6gB7M3VS5p00KdogOVuf/EtNYuqCzCHKBoFC4V+?=
 =?us-ascii?Q?tWMGBTaqA8nKAoCXxYw15GEMHcf4Kn7z0iN1mwrJHKKNkHnyzJzEupJ2Ycdh?=
 =?us-ascii?Q?LIJbI8CFkX6jklJyubMLl/eEegwo6OFQxUpwAKYB5j42UbRxm/jBEgeZYX34?=
 =?us-ascii?Q?N9EozFh6oiWmtwNk2UC35aHZh8QhdsNAFSCckqI04vS3xPRuS8Ms6PJ6Bn6o?=
 =?us-ascii?Q?vbXTtmCJNA4dLJYko63XY5PtCTvK62yO95x/cUwPUahJL1PgCDRwGA6uZbr7?=
 =?us-ascii?Q?4TQOtCSjY0AlszLD/Vx57MysibxHQ73YPm8xmA0w1CoUjI9owMqd4gKZ1jd6?=
 =?us-ascii?Q?VGK1rzfVpXD1WsDkvnIZ0lO///hKySPyokzgXI6sU7e9m0vpiIuwkloFgsCl?=
 =?us-ascii?Q?PjLy1PEQlY7vaEU9UqZ4igd356HPoa2uQZ1N+UnUk4VtpW39vE/nlgLlRiKO?=
 =?us-ascii?Q?r2PiOPI03DkLGW4pnFZ8OkAvrCPu6ACVT/9lfOu29ciSR8Cf4IxMyw7stZp8?=
 =?us-ascii?Q?2yD50KL7KNscWGCwvzSPVnxSEiucpPmQHAIhjSvLid6dcNLmSWwGZAaPeyQK?=
 =?us-ascii?Q?3AxJfkQL4Sspm/+GZbsy+anhUD2Br9KCqD+vIfIDV+NBwm1uf42jwg4S1AhV?=
 =?us-ascii?Q?9HnvT11mFy5NsyMab0r6rdF/RO+hvfBRObF+c1D6TC2AXA30SIHafaV3hiRD?=
 =?us-ascii?Q?n0h4qpTJ4AwSdZjaNIrLKSKhxEdKwqTbA4I33WvNmz/wf2diT2ZA4KUf2oL8?=
 =?us-ascii?Q?xanqXjilsmyY/YujJ0xK0xLOMeMWnuLyPgDQp+sAE0IhtUakEA10Ju1yWVI2?=
 =?us-ascii?Q?SjbUNBSR//afYzhhwiPmbPuLjJubxj+rvsgOSOMHsg1bPQmjihGGMvnR3IRd?=
 =?us-ascii?Q?9ATGk6D072yOUxU2WujhylhblCuya7PRsySpotBU2X0+eWOQQcDnPwRbVz0H?=
 =?us-ascii?Q?7tVx7kSedduQvQvvHwP32jpfPJrZVikktapc4FLC0vXUtQ1ZORIZIWsdnObA?=
 =?us-ascii?Q?lEblwPbPtbsF9A9fHDnmdFHL+W8CsXGmjPf0OHN9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4adee45e-8cc1-4b48-08ff-08db2966da39
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 17:16:32.9505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tj/iIJc/AT4Pg4JAKZqQRHNmw9DjkIjiuR+ozf8M7yERbbABXCaCSrxqE5Gqzzaq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5367
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 20, 2023 at 10:31:53PM +0800, Yi Liu wrote:
> On 2023/3/20 22:09, Jason Gunthorpe wrote:
> > On Wed, Mar 15, 2023 at 04:40:19AM +0000, Liu, Yi L wrote:
> > 
> > > # if IS_ENABLED(CONFIG_VFIO_GROUP)
> > > static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> > > {
> > >          return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> > >                 vdev->group->type == VFIO_NO_IOMMU;
> > > }
> > > #else
> > > static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> > > {
> > >          struct iommu_group *iommu_group;
> > > 
> > >          if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU) || !vfio_noiommu)
> > >                  return -EINVAL;
> > > 
> > >          iommu_group = iommu_group_get(vdev->dev);
> > >          if (iommu_group)
> > >                  iommu_group_put(iommu_group);
> > > 
> > >          return !iommu_group;
> > 
> > If we don't have VFIO_GROUP then no-iommu is signaled by a NULL
> > iommu_ctx pointer in the vdev, don't mess with groups
> 
> yes, NULL iommufd_ctx pointer would be set in vdev and passed to the
> vfio_device_open(). But here, we want to use this helper to check if
> user can use noiommu mode. This is before calling vfio_device_open().
> e.g. if the device is protected by iommu, then user cannot use noiommu
> mode on it.

Why not allow it?

If the admin has enabled this mode we may as well let it be used.

You explicitly ask for no-iommu mode by passing -1 for the iommufd
parameter. If the module parameter says it is allowed then that is all
you need.

Jason
