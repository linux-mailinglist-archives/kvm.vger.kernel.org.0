Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3179B72FE14
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 14:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244517AbjFNMMp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 08:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbjFNMMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 08:12:21 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36DB26BA;
        Wed, 14 Jun 2023 05:12:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/M11lfRDD0K48UI5v0Qbf5GgW3HFwLGNO4Mh+Ii9gXRZsk5NlWx5kc3n2kQTNVrD1VHlDtZZpF9TDbC2nEcul0zATNdDWoETE2hyKeRm9YRUU89jQtnXQaDj3FqGbQ1U+mtoyku/UqZsBBGE2yQOjKmHRzSaC4+lWNf4gzaxoAaQTTS7Fbx+X+jP9c+qC3YW8sfymTzofTh3D2mZjBhMCTFWhmpIwJkvjZ6ODYTiotwkP7JbzKL8SKqmajMvhnFYtxYlkwnJkUF+IjfhQygaLWuIr5pMa842E6tZDxcP5EBqXBzAe+qpEz68/bMdWhQzH+bIv7ZWAFdeIc6cuxckw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n8BWqWvWDxVom9DUw8oV5oZ+fONisW171tP9Sz0HL9o=;
 b=AfHVrPYX1WgTBN6lCmtdt3PKa+6aLZcaM7Gdz93c7lSHnNfc56yV4Z3KkWXzeuOwFg7PjNzN59paPW8og2HpsU6xo7fNi7LN7WMxUVkdQN7c0bq+ehj+II3OJIFROjTM2vKDLk+8Xo2zF/8Jm9btUxymIF0PYy6itKxathwR2fFYIz6Bcay7T7PUNOP8cx/oDM/zRJ0KUQ0MG24d7ukVr5fEz6ekRPEDMwunM31iSJjkm1RWtThyo5z/ebBwBlY9znRb9J/CBRnAIKtV43GxTZf+SfG8TmnLp5le7H7GTguo1NYN/ax2S/v18z+B9f3NSunDGiDQXlW8yT6gYsFmJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8BWqWvWDxVom9DUw8oV5oZ+fONisW171tP9Sz0HL9o=;
 b=IL/R051eIAyRKa1p9i9M5r1/Zm2Z7d/+KdKiy+qQeTIWq3/o6wCoambMHMgq70UjIVdw+mDvyx7GEyatxWAL9ghqIc/GjCk6fYaV731W4WBpTU0ClpkfcSW81J/N6VTvyHEc+5Ul7cIUrVKKyZAiYxWx4PEgoetvmufhNZf2V/wlJhN+TmTPh0X+aBaaUSgYY+gAJghPpgPKlY6CA1uDloX4Fd1hjw2sAmymE+NAFzk6+IjcjP7Td4bqonVDLbGUOuGxLK1xRyWcNAb4htqr58MNiW+5CSuzrULsyXHwF/Co1qykOd+eGiLSb/xVDwyYmdhmaXUwNHqHDwEy99jo5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB6865.namprd12.prod.outlook.com (2603:10b6:510:1c8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.42; Wed, 14 Jun
 2023 12:12:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 12:12:00 +0000
Date:   Wed, 14 Jun 2023 09:11:57 -0300
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v7 6/9] vfio: Mark cdev usage in vfio_device
Message-ID: <ZImujXKfS2NP3LqU@nvidia.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
 <20230602121515.79374-7-yi.l.liu@intel.com>
 <ZIitv1rz3wg48dOW@nvidia.com>
 <DS0PR11MB752998A3AE0185BBF179F3BBC35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB752998A3AE0185BBF179F3BBC35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BYAPR02CA0071.namprd02.prod.outlook.com
 (2603:10b6:a03:54::48) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB6865:EE_
X-MS-Office365-Filtering-Correlation-Id: 2de37a29-e778-49b3-c9c0-08db6cd08e9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G7OaIIVkmu9UuleH/wzElBunkDFzJa4gO4nHeEu3K1bF2sNShO2GewhKGlFtonBPFJLLwNtIph5vFYtd1wqRFUHktExeOWATxUH7QhEdtc3R1bIea9JcNBHV0dlMZBJeUO6XxgR8yz0PxKYvSBIKh9ZZcaCm/wRcStZESsB7XTHQEK5ZnuIOkjYKZep8RhF7LmHqMt1XweUquIbkUWyB07g2BMslrnVUODukwXAJLxmhXFpIsmgL+lpXLmPqNwZ3WTkXBiOgLoHu6oxHdxJWSxb499it5wn19awsKacNGF6aGd0SocOlsxFdopwn9LNbjCd7Z5fZlS5XTT/s4Bx5fnnJHOO8ohEdDN0hFMbhcDexhFFxrR2OMOBz05ZTou3AX5pc72kIQiORlbfpjifI1N4yf9NhYCXS/s8d6t6Pp0DYwLnfNv3tlKHBjFXlExVwef3jdV6fk4+6w2reAnBl+eJmA79KuUVQefpsiWmCAw4Jkewoo4VOQcAzkmDQZPcddNRz7In09PMQoFFVrL+bCKpoNewG8++AOxDW4RoHsk2NMf5eJZBNdKlR9RUyxr7v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(451199021)(8936002)(8676002)(5660300002)(7416002)(66556008)(6916009)(4326008)(66946007)(66476007)(316002)(54906003)(2906002)(41300700001)(6666004)(478600001)(6486002)(6512007)(36756003)(186003)(26005)(6506007)(2616005)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PCS6sdrYlyK4YGGEihUNq03Um3UlkLJQdwb4JsRXTstBbB1tlcSM2t7IMnU4?=
 =?us-ascii?Q?5dzrjWdXdLS7tI0C7V3kP1qkKXtrpm0pMYDDIPR0+jgCXCqrwHwZTKXPcRbr?=
 =?us-ascii?Q?+4t/yAuY69Tw/caA+3zKQlnKX3tlnjhtZxHqtXop2nK1tO0yA6m78wuQAhmn?=
 =?us-ascii?Q?2WezbZ2/iKL/EZBypolm9Kg1xxoxAQsdyTPTiTHe1FqhZO3R7CoKCVaMYQw7?=
 =?us-ascii?Q?78aJ6MT1ip6SyiAxfxR1Wgq2uNr6aKFKjQc9mOY/Z4TPJIySr3S2hLIyAa0u?=
 =?us-ascii?Q?HnsIbUY6QRN83YqyW3YpX8ge8paZPRN0fDQnL5dK6/oLg/5JdIWr01hahIye?=
 =?us-ascii?Q?Dk+qjcBS7CHf4NdZMF4XUraZvrSrgb+SOBqqasn2zuWoEjgm7S3hqspAwxGk?=
 =?us-ascii?Q?WPdcphf1VbReqYC2eSeVEDNvfNQprfVPaRgZFSCeffhg2F4M8/+olCXx2jVc?=
 =?us-ascii?Q?aFb8c9piNiCLUELbMurNmZZuSDZqUf17p99xDMaCWvBowPwRhQnpQwDalTSh?=
 =?us-ascii?Q?+mROmlKSOwGPYxNP9z6ndRIaLp1DZmXO9KK2Nsaen+W8t7tMYAnzkDJJxxOg?=
 =?us-ascii?Q?lOfEmLHA4wLOWfSZl8zQvCll7VhrCozomgc7tAUvp/j7OWXHaDfAiYm7lAEK?=
 =?us-ascii?Q?DUVCVjupoOqFaqGIgLIjnDWTcC3HzEAueS8A1ILfZN5Lr7GWEG1+HRj/x8Rs?=
 =?us-ascii?Q?gyEQ5ZyqiRNGwBDBzhAKtZa4YlyD8gEuWPguPV+TiLxK4qWOgO63FEfd+mtT?=
 =?us-ascii?Q?3Mf0HGHKrmJVNmjUJzKHd+16zBDeSRBjhw6K5VZ48KKzhjGAPYhpG8Rq//ap?=
 =?us-ascii?Q?5z9lfMLTK1hsXpGUXJ8pJ0eg9pEDotq/FHaEa5/K4B5I8xk35VPJ+Ax/kqbM?=
 =?us-ascii?Q?No0HvMrsBlHe0DMAKyqG4ScpM+RpdEKM2CyWlL1oeJA3BATK5si84fCuybZA?=
 =?us-ascii?Q?NAjNW9iREAOjlHnCDoOLl+wn75mmnpvtuI0vjz1MO0vB+/kPXKbZMBzsqHcp?=
 =?us-ascii?Q?JaK1lhbSegC/OB1UGEQDt4gPJaY9sflrP3ErXay78UICDQVtMb7QoGZ6wnwY?=
 =?us-ascii?Q?ImZ0OI21lqMmg5LFsJWwO9P6vhlxZOb06YmoejRDx22+ykPDxbKDqJLE816W?=
 =?us-ascii?Q?i8qFJcFzW8vvuMGVUhKbFMTvecV+REL93FeytPyTdCeRg3A4hHL1XmQVOu3e?=
 =?us-ascii?Q?586/BdDbOz3YgiyYty+VEGdSRkrilF8tpDpwpARFbXP2IjvZFsrDIELJSJ89?=
 =?us-ascii?Q?XjG3/MezdtoHT5EwyrqViThX8RoLaERprAEMyxvLF133wOAkgJsVSEpAKy3q?=
 =?us-ascii?Q?CX5txaWhJdmtvZP9rO85rOvJRMUCAjsu31ROkYOkyWQ1uaUT6OIBjD7VHxpo?=
 =?us-ascii?Q?NhThhseMVZ9WTXaOm07LRxs/chVg5OEjFzMvd6C6rOxzZdVUlu8by9vWwYqL?=
 =?us-ascii?Q?oi8bfWbbho02Y2ufwzvYIiAROW5B3xnilrV3VBImcFriN4XULw13vkgAumcA?=
 =?us-ascii?Q?plZTrfiw4avRwNDBrb0PA+xTPR2cxZnfmLw7qZLtKvvE37Afwetp+VeQA9Ad?=
 =?us-ascii?Q?vDokQzzHF4dTjUhr6sPRwOPm8iLsu+0lVjXCNEKV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2de37a29-e778-49b3-c9c0-08db6cd08e9a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 12:12:00.6016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9gcJv2BByB1spf9jFSE8dM93kd/imF5nn577tiUepCfat822fS8CDxMLV0+seQFo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6865
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

On Wed, Jun 14, 2023 at 05:56:08AM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, June 14, 2023 1:56 AM
> > 
> > On Fri, Jun 02, 2023 at 05:15:12AM -0700, Yi Liu wrote:
> > > This can be used to differentiate whether to report group_id or devid in
> > > the revised VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl. At this moment, no
> > > cdev path yet, so the vfio_device_cdev_opened() helper always returns false.
> > >
> > > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >  include/linux/vfio.h | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > > index 2c137ea94a3e..2a45853773a6 100644
> > > --- a/include/linux/vfio.h
> > > +++ b/include/linux/vfio.h
> > > @@ -139,6 +139,11 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device
> > *vdev, u32 *pt_id);
> > >  	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
> > >  #endif
> > >
> > > +static inline bool vfio_device_cdev_opened(struct vfio_device *device)
> > > +{
> > > +	return false;
> > > +}
> > 
> > This and the two hunks in the other two patches that use this function
> > should be folded into the cdev series, probably just flattened to one
> > patch
> 
> Hmmm. I have a doubt about the rule. I think the reason to have this
> sub-series is to avoid bumping the cdev series. So perhaps we can still
> put this and the patch 9 in this series? Otherwise, most of the series
> needs to be in the cdev series.

Well, then Alex should apply them at the same time..

Jason
