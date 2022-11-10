Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3F562483D
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 18:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiKJRVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 12:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbiKJRUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 12:20:51 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2059.outbound.protection.outlook.com [40.107.95.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0702B25B;
        Thu, 10 Nov 2022 09:20:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2HD77uYzkK81P3qu1uThCybw/XqcPog1lckAJ6nd70bP6TO7sY8nrlQ0OY481UvylUHLJkXNITzP+pkSCODeBPMn17F58IwyPRPRXBgiTXgai2Ch0M74SFebPbLi4TGybDSAR/HqAA67qOtgJLboyzrEP5RERvSZfQQzLHd3vFWMsENuyw/9TOX4ImP32XJYpf4tLxNJFQGisQhtpSYivoZaLTF/NsiND4UQAfQ7QHptkEd9qkr8xzAesWrxMycU3/aF3wPTWwdH6f7t0ortgwGtpGOV7AkNNW/ju5/DHOYL5cvI8eUqO0YXgq7n7sE8H5aSsRWB0XrZbnZFzSryw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nbuJN9ezHrXaDBij/bSRX/rZWnZS2S8MSW+xB6Nyz18=;
 b=RIFpVOGYWRPFVDCaV8v/9mCOcLsOW1Enw1AFVeTM0VMEL7OzqhZwX95wfwK1litJp9VRiW6igQmU+aG5FOk8w3rrDnPfjS43AYk9n/NQCIfQEqgoPKiIBOxuDlsbxbciMwoAcRgN0VjIJiEfPeBhHaOEhUs2LpXU/08Oe/LDZKX/K3PtcPeg1IT6U1jweFk73XMsQoYQYbmyUALW8A4XnTsfZD2QVWI/nV3ettPqemsmIAezf/7SCg/3y2n8O9XZHEPyMcsFbLkqS5zs6kDjFfggO21b57zRayrPNNhukwBEHjqHuVUjXhImIusG5W0Cnn7nzRq5R5dZ83p1uoaIGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbuJN9ezHrXaDBij/bSRX/rZWnZS2S8MSW+xB6Nyz18=;
 b=uDTbdgjvbTIvgrF236jpPY+AQwdOSCPw1pN1RlPcamsEVdiGsfd6w4c4rJJu0rComFmOzAJbQbZEukEBZKstGg79EBaAoCMfx3dpCR+pGug66IhQ4kqt5gHyn0JMj6J+iOkN9YHzYKzV8V00E6xrYA2pU+ps/8gc92NQJJPIZkBhNx2P41sPWJ2T5PncqDRVDN6AmLFV2th6VhnLm+E0uaTIYPsVL4VSYIxjkcMBpIUnG5i5N4yHmQl8AzTk2QxDQfANZva+zPXGrLBIroNZF5jInoKykRtOOGG8vBZPGe0mg3XpFd599gRW7GkI2HFXfhiZNp6W10RXeJTJmIFQiw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW3PR12MB4524.namprd12.prod.outlook.com (2603:10b6:303:2d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 17:20:41 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%7]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 17:20:41 +0000
Date:   Thu, 10 Nov 2022 13:20:40 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        David Airlie <airlied@gmail.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Longfang Liu <liulongfang@huawei.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 07/11] vfio-iommufd: Support iommufd for physical VFIO
 devices
Message-ID: <Y20y6MnCn+pqXcnI@nvidia.com>
References: <0-v2-65016290f146+33e-vfio_iommufd_jgg@nvidia.com>
 <7-v2-65016290f146+33e-vfio_iommufd_jgg@nvidia.com>
 <BN9PR11MB52766AA1ABD4EEDA30B696C98C019@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52766AA1ABD4EEDA30B696C98C019@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR02CA0025.namprd02.prod.outlook.com
 (2603:10b6:208:fc::38) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW3PR12MB4524:EE_
X-MS-Office365-Filtering-Correlation-Id: d87d598a-6492-4cc6-223c-08dac33fe477
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iVRm69Sf2lF2bQprFMpWcY/IwZFUOH4mf6Fz5dvULtwY8yCmBOd3puQfqYO6+jCCiwAhdij0jto8o+Xtu2a4ZH1qNH2AslcqKoAOU+lFoIeJ7UiBUp7BSkrLTVrclwLCs/TxA3Tc2PYUmypCoE38jzXZZrbU6t/mh2K2KB+rI/5ePDQk0ScYZ1N1awqQkoEN+kxpILKkMfmEKnxAbmS4t/PjfpQUi4wuBjXjDwRQVf6YPZHHX441paydC15d3M0fS3g83edbCf3LMkPheFs39eGD7wz4ugC7OTLX/BA4h3EIuJb6pIAiqm0ZravmdDw2lmtq5ZzvCHalofbIV0eQBtB90USZU+2tkkPY3LBvNDw4cnTaCvzKBBZch7KyuIgK+X0pH2P0L1F44JZDRVyEcOs0Itkz3/fqUwhNuWSsYoR4QiPq6FdvV+xJ+bKzoNMgkZYJCIzZS8GrXPOYT9JwJn/fZwbDA2olejES6Xjql0miEyTW2KJXlC6XqCDTIcA4qTdv8YbwjQX2vjh2kJJnud+uty2aGgRU7cjUWAQ5RAeOx4Jg8cHtLkCSveZVivoo0Kesvh/o3FRBew2vmRST1yc8D2ZklBlhPc7/KXu5A/smPeOcmlMGMcgzt1TpsHYi7dsOepqc6cZeVXtng0CIVObPeM5jZH7h0axjwEKvYEfQEkiUhjHGY4+jjpOOJ0KL4++HAT1n6oRv0ocQgxGXsGuULragXHyQl0nH0exIEl58IimFd2q1+ciKg63cGjlDcNn52rKlYr7qKGLsUk6+GLc6ZWI0Y0sOdeXDUmLK6v8yNan6TAfKvDceIbSrtFXK16SEr+Qdn2aHi3uqdHCm4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(346002)(396003)(366004)(451199015)(6512007)(26005)(86362001)(36756003)(38100700002)(186003)(316002)(8676002)(6916009)(4326008)(83380400001)(54906003)(66946007)(66556008)(66476007)(8936002)(2616005)(2906002)(6486002)(7406005)(7416002)(966005)(5660300002)(478600001)(6506007)(41300700001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2YP/1XsZZkJUihQIXPF5WxTgbdHgO+LRPWOtMChcJ7kE1XMXDrt/Vbdf42mr?=
 =?us-ascii?Q?yj4Gw9x6Xa42TgDTnqtdJkYqkg1wsHlkOj206xAZQo2PkFpoX0nA3zIKXXZl?=
 =?us-ascii?Q?x/ruQay3KD4uQXAWsSMr13PEwjWF7EcmMgdXTziyCaMwl8n4O87qXbwdkV5+?=
 =?us-ascii?Q?DZCM7rbnuYSeO1Z/dwEwJIdgjxCYbgj+6fpo8zFxvSR2MSWRXqNH7AXs9syT?=
 =?us-ascii?Q?NKwtOx5Mu4lWuTzQ7oyezoPgaTRNPDDQH2hIobhriLKdrH0vqtrhk/HDvHNR?=
 =?us-ascii?Q?7GNK/BM0xko1D87pyQAUwMw/gxWR6a1SmI6hChTatOXCsFtrM7HMz2wjvUg+?=
 =?us-ascii?Q?5htYgzZv2owkA7hyX9S2MBRpJccOzE6ckW/oK73eR9j/iCm/byfLuFZMCh6W?=
 =?us-ascii?Q?OYad1z6OunM39OlZvOMWa048BWmM5iBINJNwOaCc3BufSBYuvFSzV5IPdpNk?=
 =?us-ascii?Q?XZtPB/stpGWPjF5uKOUNhJPCl5fu+HLzQuH4gDE9ebLvoKb7qCzBOLU5SkcZ?=
 =?us-ascii?Q?Ol1nfPM/Sdg6JqWJDF1n6hv1Gf9sel6cMb5Eh6eUkq4AMe8pYFdeJDgkESMB?=
 =?us-ascii?Q?HEc37Q5dxPdrWbgripv2fN87N1BtU/ek5Ugbr8YO1sxsqnNUWlffZNZaglnZ?=
 =?us-ascii?Q?XiZEb/LeHKB1OSOWf0oZLnwiwGICt0DVtTbLdks7NrMmGO471kYitQFuK7QH?=
 =?us-ascii?Q?pytSGwDarFHBTKLQ6S+TqQGYzDyd74bPzG8tPzL/MbJf8X+X8wUclEV0kYTI?=
 =?us-ascii?Q?Qv9vsYp2voVrZ4HgMeUrGPnJXS2PCVJrF026LbKofe42SEQw3rRtC74ozMUV?=
 =?us-ascii?Q?z5EAshYojTpj44zQMwGCYs5cTWflK6EpG5TWyXrWKbePFspPvW9Zum8UQPzx?=
 =?us-ascii?Q?Z+uNnHUOpY3Nq3AALXsZXSMQ4gupnpxTJC3s4sgMF/zoRIvvRpnz1mroPVkM?=
 =?us-ascii?Q?8iP+D+fFTHSl94AgWQVcLx4wTt2Ahb58265uxl+X6v6PkAoyiIt9pfV2onjY?=
 =?us-ascii?Q?2D71tZDy8N+J8WHdXYWgq4fCKJkGTaxALkhnl8p5LLGcMo2IVMsSItIHzEJQ?=
 =?us-ascii?Q?6if/XsCztUL2qBymxjNjXobpNkDS040hJnmg6iTFoevLKof7Cpzaziz/yY4A?=
 =?us-ascii?Q?ZQiscMuBTZOORR9FGRgOXPOo6b5wcMtGaKZJX1ZKbiUe35dVWYNwNQK61cWI?=
 =?us-ascii?Q?OQFp+vMvU5nt8rAE/QOGD5gq+iPMsAD2BGdvxmjUBquW5401wkcslaVdaJXp?=
 =?us-ascii?Q?FogjUBTB/lYQL+96uZHE9lwp9jfoGajg4ymxigKMNLMcLk5tLNLu0msKsX+K?=
 =?us-ascii?Q?ksNmHDVUBS/ftJ3Nmv9V38GxpqSoxFOq6wxl+OiGnvOgQv4/KyQYen5nq7xO?=
 =?us-ascii?Q?+7Ov5qF07TCtTvzm7kvZdaHN4iKWc89V1luF9OR+7HfcluyI1T4J0DdGj8iv?=
 =?us-ascii?Q?m67f4q/F/crtlpXBCFwOgaD9pgS3ul/uquHVbPcXkcCrccrh/pslGGk8Jcfc?=
 =?us-ascii?Q?pRgBLsWTgyFNqcUFVV0J9mZ03ivWIGgxfpwPbgE6ykdJ6SNeqVDuhjET1Vjm?=
 =?us-ascii?Q?d57mU/8AQTzx4xg7yvU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d87d598a-6492-4cc6-223c-08dac33fe477
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 17:20:41.0965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YkNJF1WYwuNMPvvVeQIllu6UaEOJ10kM00nRj71x1ew1dNlxVeO6cVWO7ENGQEAy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4524
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 10, 2022 at 03:11:16AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, November 8, 2022 8:53 AM
> > 
> > +
> > +int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
> > +{
> > +	u32 ioas_id;
> > +	u32 device_id;
> > +	int ret;
> > +
> > +	lockdep_assert_held(&vdev->dev_set->lock);
> > +
> > +	/*
> > +	 * If the driver doesn't provide this op then it means the device does
> > +	 * not do DMA at all. So nothing to do.
> > +	 */
> > +	if (!vdev->ops->bind_iommufd)
> > +		return 0;
> > +
> > +	ret = vdev->ops->bind_iommufd(vdev, ictx, &device_id);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = iommufd_vfio_compat_ioas_id(ictx, &ioas_id);
> > +	if (ret)
> > +		goto err_unbind;
> > +	ret = vdev->ops->attach_ioas(vdev, &ioas_id);
> > +	if (ret)
> > +		goto err_unbind;
> 
> with our discussion in v1:
> 
> https://lore.kernel.org/all/Y2mgJqz8fvm54C+f@nvidia.com/
> 
> I got the rationale on iommufd part which doesn't have the concept
> of container hence not necessarily to impose restriction on when
> an user can change a compat ioas.
> 
> But from vfio side I wonder whether we should cache the compat
> ioas id when it's attached by the first device and then use it all the
> way for other device attachments coming after. implying IOAS_SET
> only affects containers which haven't been attached.

I can't see a reason to do this. IOAS_SET is a new ioctl and it has
new semantics beyond what original vfio container could do. In this
case having an impact on the next vfio_device that is opened.

This seems generally useful enough I wouldn't want to block it.

In any case, we can't *really* change this because the vfio layer is
working on IDs and the IDs can be destroyed/recreated from under
it. So if we try to hold the ID we could still end up getting it
changed anyhow.

Jason
