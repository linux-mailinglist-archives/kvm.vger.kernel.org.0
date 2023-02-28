Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220AE6A5916
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 13:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjB1MdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 07:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjB1MdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 07:33:06 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CC686B5;
        Tue, 28 Feb 2023 04:33:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RVNd3AD5wdWO8Qly220K3zZFfSR0YCLnVeIvoo+rVe+oilgarmZModK4+wFaOowoOlQ2Oyhorws2k02dfgu7awVX77T8Op5aTEIloE4bUdc480n+NHYrsjkk9sF9Xrb57Dnc7gqLcw0HzTdyR+AZ6vOTpHUzZD2hcz90G3EAAMloGGZ7xyFvx+PwzMPRAGWOJX2ckveIrIz0eL0OwCiLb3zRMhN/TRzOa9+tsQpUekf924xpN5L99RB/MAqy3/2flSP017A6uWzif14z3nMUlSy57Xwd+RkiRMGBNVkPk2r5QHDc3MDqJ2yhWXvfq+9yc0mUbenWTmoxcYpRb4gcBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/1Fp3zmPv2dhnL4sSd4Jjh9mNs8yENx76+w///J+z48=;
 b=X7cMp0g4WwbYyyYkAwAepCWz3wfcQVPJI0Wb+FEpGNJ7LxCbqZ4tARDtqxW92uwCFYJxgxl3ZcCnPSHVEEXC6nQvIAYWD+YaSeidGYtTyabFGGcrrmhVa1JO+L9lKVXUu1VZ9guQOp30InoHF/TPwrd0KVOe5I7kQkvDWJ7deJ5ab2jb6Pvq+/v50cj1ntoYAd6GPyr8sJX4GqRcFUK8FAgu/HCzx54BY4A/kRBCm0qBbEvuxznft6E4r6N4WS+H0bf1iElYaaFEZnJgr1SRhxGNLGdNdEqPtwOTyIY9W+MisRRMkD/vMK65yrn97vgoCd91zQLSuw2/SFWf8CeW9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/1Fp3zmPv2dhnL4sSd4Jjh9mNs8yENx76+w///J+z48=;
 b=eTgVxoXDdDL+HjRPLxOjIcHUsCPgTSLBOXgzV6vngpavmofWzD0SJzzoMq0GFNw9E0bzY4Imnj8y1rRi5cF9EfgeQINnUhL8+eBArT8+mbYu1R+vuRhFTowhjxJtGtXJET0irCPEvdgL5prd7jSF8Cy1tYtpdCb2daePvWRFswV6g1y0YKe89NZv6mfXsTg2PZpVxNLmFyCq0C77rcPGG4ip2szuHORyfhzUAy8N1UWKfCmF0zDcYMEKujYCu800GHhNJJK4QPyj8Q41YCDUE7yfofyjnbQkJsAUgHl/QsR/onShQSK0G69ptVm0vtpgCbDMqK2PSzU8i926nEHSuw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5069.namprd12.prod.outlook.com (2603:10b6:5:388::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 12:33:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 12:33:01 +0000
Date:   Tue, 28 Feb 2023 08:33:00 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: Re: [PATCH v5 11/19] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Message-ID: <Y/30fBnUA/PBJ1DR@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-12-yi.l.liu@intel.com>
 <Y/z6GwZPfh2nFjpn@nvidia.com>
 <DS0PR11MB7529DC05F80083E426CC6443C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529DC05F80083E426CC6443C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR07CA0027.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::37) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5069:EE_
X-MS-Office365-Filtering-Correlation-Id: bf18933e-5d14-4a08-ebc4-08db1987ee60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IyV88NPXFEm1FKp0+VIT1EL0yo6axHfIx3cORpAzVlcJrg1NXbjkC1i4rrzvIGB7fDOxwy5Js8QTZsA2ucKKK0Dx7fReZxuyOsrvx/sj4c32pqNdF17aAhOh67kVSk0iLwGm6ilwEexqHUyt/X/hEy5E5ceiefXIGuc9nIzwOc0Om76z6D941/r9dIniNW/meGe2bQTdds9amBi4/3mLQPfS97Ucylr+WkjFdbA/8xNCkBloJbC0ao/nDG6ZUF1iDw2apV0uiVfDRMLwraNpGPyC80WXjIHgz1cB42ON/2mtj3U4awYlJsIBBMJd8ljHMDyGySMqusBizdyFNIRxIEkZ2qhi7qVYy3oKuirkO24dN/IU/l8OamHWVO0vEi29o1+ma2xJNTRFH6iK8QqYX54L7FoKxpcAg3yZH/Kq6+bxdp8fjLEbRt2VzErrsfmGiG54VvP5EVfiqED6Fyyo7uociIZgTHuxrRx8qr57qgS0H0vHzMKwf9XhKe9wd+x/Q7cdxLCi1u7DBMBS395t2js81PeEvMVGCzK6ah39d0Qjv/HHcn8gVeItaZ64rH7RE6a9bMQGERU/FCQxga/5UiTzliNGbVUEQwDhSyVmjJ0MV0/vuNRwT6IoEcv+zG776gNtykiUYNINtVrgKBK7Xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199018)(38100700002)(86362001)(36756003)(2906002)(66476007)(7416002)(8676002)(6916009)(66556008)(4326008)(8936002)(66946007)(41300700001)(5660300002)(2616005)(26005)(6506007)(83380400001)(6512007)(186003)(54906003)(316002)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OaFUfVb4b8lHPGGn8XeyB2Oa663w0OPzwlV8h0I8j4szVavFegDsnR8HWC54?=
 =?us-ascii?Q?FxUGsPUg4vpoyozdNL1HzcTprlu9yFPKvaqtDUJARRAmlcxKvDi+vDhjaVT8?=
 =?us-ascii?Q?v8MBuyZg9MsnJPJyGg8wFkz3NrVY3TVvSKdyvN0VxWHVuG8+XgUkRXaBWPyC?=
 =?us-ascii?Q?VXMuUqMrwxgR8QTHX7CkYAN1UhPWmX1/dP18ljTNiVQ6+qt8Rl1FhE+TEo3I?=
 =?us-ascii?Q?ckxq4DVtZTTMiQJtVustogQuQ72pS97egtbsi9j78LO8qhTnebG28NXylpzy?=
 =?us-ascii?Q?wIlh3Sl0YnrNbRFSfriiyxRA00Chhfq09hMioirnZD9K2DPjR9uEJOUeSrJq?=
 =?us-ascii?Q?IoGliGqzr+KLzDDX55TOei5fNAAs+VmDMPvJzZTLvpS23bEQTeUqOMU4KvWi?=
 =?us-ascii?Q?gPdTOvqmkH3zQvcUeWd7IERhdyQRODs48jQQKreW8Hut+LMGwKlK+TFWVjzE?=
 =?us-ascii?Q?Z//Dux2naJImo/dTCK4B4LUGxSZuR7KikT4r8ZssDA3aSs8k3BLmK9YFD6lu?=
 =?us-ascii?Q?zr5jBfYcWMqbyvO814mPpvqgWKXpsBGpP3KwAQ3uj/CYkFTSUmPiyyWEgmXU?=
 =?us-ascii?Q?UTpRhI2jYYuk0kIyAK69AG/lsQgXBLyQj+9fRPrd+CcOZNDTBV2QhM1m/UhQ?=
 =?us-ascii?Q?0hh2wDsgZXCZ/xVnCKXC24Bl95t4CHZN5eHb9cLM9KplL5Q0hnC2Mbh0vC+G?=
 =?us-ascii?Q?Lxor7x3WHGAVcOHxE6EWfPVuqH9VtgyIA4jlm+5QBuSY6srf9bWots8e5BOj?=
 =?us-ascii?Q?rHZl57oILzD+pj0Ii+3ObhwISV2YZfszgt5pSsg8c9dCkcL76TsLjC/Adlkj?=
 =?us-ascii?Q?UKNEOCKlADJLkjWwkCXCMfYUJCSMwRaH+F2X67yBf3MuUbksIaaxa15JBNv/?=
 =?us-ascii?Q?ir0dBFmdM88/Vhc08xSRiFHexRfkYhIGdGF6PJRXQ/xz5+RDLgZrXUYGlhKZ?=
 =?us-ascii?Q?ucEcmqB8GXnsGzMG23Ajpv/jzPfiK4a4Qwe31a7Ce3Np+TiLNi7X8fxWrzbt?=
 =?us-ascii?Q?j/4H61jJbJ9Pv98qrZVK9CGbEXhMCLPTsezI3P3icvqOFMrlTsH/NvjSWQbk?=
 =?us-ascii?Q?5LaiFLS/CMNnnrFYOLXRIeP6NQEw8qJ6xCUqBjEBEs+jpYhDbdbm0sTF2zDh?=
 =?us-ascii?Q?aTqnNoOojkrCiPghAtxdxzebfmaAakLsqs70JSWAjUoBgKRr16KoLaaEQ3+e?=
 =?us-ascii?Q?9oEazcCQhpdhsCIoGZ0qzcU7xKn6QgYDKJzJU1lqQ4lKK1PmPEUAlmG3EXV+?=
 =?us-ascii?Q?fNzxjSKumlNXCSHdS+uzKou4sTx6IaSf26A4AhfkCkcJ437J5giFLGJFw8Z+?=
 =?us-ascii?Q?qojO+oKUbjW2x61bM77E/mXaAGJxKz6arVhR02FuFOP8FP5gbmHjFZbpUZ5M?=
 =?us-ascii?Q?Ehv7nnkeanuUu39sHlVH25B7cVIIaltlADNmCr8LE4JFACW/Q1SCPwik/AVW?=
 =?us-ascii?Q?r7B4a3B6c7vMhGG5r6dM+GwSgiorRekRFtl2Fo6tXaD7ekKWzhw0LdK2283M?=
 =?us-ascii?Q?Hra0L4PZZH+R6oWc9aaDdgNFqug+NdKbKABSHgOaLmc2DjN1OLO/dInemr4x?=
 =?us-ascii?Q?ocr31wR50mQuD/Ie09hSUdC/PcQA/OFLcAqNURwv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf18933e-5d14-4a08-ebc4-08db1987ee60
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 12:33:01.6321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z3jQ+HGnAqGRbQoewMlKhqippFZVbt45EX0mxmcE2hbEuUk8Zpbj27kE2CSVPkCr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5069
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 02:57:42AM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, February 28, 2023 2:45 AM
> > 
> > On Mon, Feb 27, 2023 at 03:11:27AM -0800, Yi Liu wrote:
> > > diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-
> > mc/vfio_fsl_mc.c
> > > index c89a047a4cd8..d540cf683d93 100644
> > > --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> > > +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> > > @@ -594,6 +594,7 @@ static const struct vfio_device_ops
> > vfio_fsl_mc_ops = {
> > >  	.bind_iommufd	= vfio_iommufd_physical_bind,
> > >  	.unbind_iommufd	= vfio_iommufd_physical_unbind,
> > >  	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
> > > +	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
> > >  };
> > >
> > >  static struct fsl_mc_driver vfio_fsl_mc_driver = {
> > > diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> > > index beef6ca21107..bfaa9876499b 100644
> > > --- a/drivers/vfio/iommufd.c
> > > +++ b/drivers/vfio/iommufd.c
> > > @@ -88,6 +88,14 @@ int vfio_iommufd_physical_attach_ioas(struct
> > vfio_device *vdev, u32 *pt_id)
> > >  {
> > >  	int rc;
> > >
> > > +	lockdep_assert_held(&vdev->dev_set->lock);
> > > +
> > > +	if (!vdev->iommufd_device)
> > > +		return -EINVAL;
> > 
> > This should be a WARN_ON. The vdev->iommufd_ctx should be NULL if it
> > hasn't been bound, and it can't be bound unless the
> > iommufd_device/attach was created.
> 
> sure. But it is a user-triggerable warn. If userspace triggers it on
> purpose, will it be a bad thing for kernel? Maybe use
> dev_warn_ratelimited()?

How can it be user triggerable? You shouldn't be able to reach this
function until the device is bound because the ioctl should be after
the is it bound check

Jason
