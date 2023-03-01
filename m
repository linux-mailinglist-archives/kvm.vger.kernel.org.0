Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F00526A69A5
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 10:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjCAJT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 04:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCAJT0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 04:19:26 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C902DE74;
        Wed,  1 Mar 2023 01:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677662365; x=1709198365;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZnVvM853yLuvL67va4zjiLoXxEbUtIBdhgkBFTfrG5E=;
  b=CKDefglHvnH8SadBXs3dJpnP5x2xElWlCIzUHrL8X0y49+x/nxfqmmZM
   txnsYcLkipzg0xs0r36prI1FRU3ANdMwBmgpQaeHah5YmIBKZkx3f6pP0
   zMbZlm/MhYmTUFL4JxKLECmeldcZRpUogfPILAgHUQmGuj1ANiEJoSK83
   r//KbWKPUdh8rv5DmbcnLVmJVOWWFWJ5SMK3UXNLBtAkuUUFo7KE6uMdl
   OEl4WxUGqYKwjQvVo1duj80wGdBV48xfuOiNmJlIRwK04D5LCn3VapRMG
   pg5x9RSdB5MeA5bz5EOBhTC7mEj+u7P4tzpcJDhZ9n0c+MT9yWaeAkwzy
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="361940334"
X-IronPort-AV: E=Sophos;i="5.98,224,1673942400"; 
   d="scan'208";a="361940334"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 01:19:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="674485752"
X-IronPort-AV: E=Sophos;i="5.98,224,1673942400"; 
   d="scan'208";a="674485752"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 01 Mar 2023 01:19:16 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 01:19:16 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 01:19:15 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 1 Mar 2023 01:19:15 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Mar 2023 01:19:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QdjdpZ05A4V2QpEuaDLZ6hPJNa3XZFYDm/UifBITzcLCEw1A9inChHLFwHoVgTMr8mh3nqqlYqLh/Syu4qkYaf3AOSSQjvo2QXXdw/yni66HLCNad7LbF4B013QfPquRr2rqGScopUsu8LypbkmBfBDtEkwkV5TbGLF6R+L9Q0w3SvaNVKO3kEwRZl7oO0SMcu6gDoJpGifwJW5kLyDLJwkBaA4GqeKx7o158SXQ4HcF1LKMpBdSbiA9zmYU32dWFJ6z14JzDbjTwts2wBnKFbNwfIbiq7n/NDqqBuqQvi4cLJB/0gidBQxD7R/1srPv6dt///HubrNiUgeK/7UI1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fwEnqp1pBcHVM5YAxfk03PLRBgun14DnPXaDEodNF20=;
 b=NJoAuUP4sWY8qj4Ia4j/hwgKqAZcVRjRILyvYQb8sp4H1/onENJ3ZxgQHLL35CiK+aAAyRZN3tPZ5Hxi4BfT8IXhu52XASHdSwZQURJpv4bOXvXlmj8Fj690kJY/GeqTiBlwMC06Upwj6Pz0MtxXYz/MVcostheg0G59Kel8uhhtFio7qlqgvn0SN8VPyDTGuLTlPWcQrn3CEjju+2KRl9/zt9ZAxquf3a/LdVaxMElkcEwcEpcMC6hTqfEOse69hsnYPAsTqmtJQ2bgPIN7+j8pESsJB9KteCXFdK4eE00DwLx4uxk4tcaCT5q/KTTZ4WgGO8myB1qSnk2GLjE5zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7311.namprd11.prod.outlook.com (2603:10b6:8:11e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Wed, 1 Mar
 2023 09:19:08 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 09:19:08 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
Subject: RE: [PATCH v5 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v5 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZSpxP1elsXPP8bE2Y+PYEE7Tlg67ln1gw
Date:   Wed, 1 Mar 2023 09:19:07 +0000
Message-ID: <DS0PR11MB752959193D5CBA2A677B1F18C3AD9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-17-yi.l.liu@intel.com>
In-Reply-To: <20230227111135.61728-17-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS0PR11MB7311:EE_
x-ms-office365-filtering-correlation-id: bb479986-d4bb-40e6-8c21-08db1a3602c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XHjG+0EQ2FhR5g/J3NLjvrf6djNtIKWrTWJLG3cL+4l8ywMqs9sopa/NzGkxHtjtPlveOlyFTAKh61rhLfKkGYsrFnIM9A8eMzXdM802r/Faz+HGix3TezuDeEbeEXsVmBwCBQAO0j2rEKrPky7KqjJQMOyT1NsmLyVGGkUW8kURCsPsVOMFsiwgL+hgGCpnVt/n/m0QZg2c7mcBVZVa+tKDNik2zFZRM8CNo11fFU21sK+xN1x+KESnlxbUkFcoqob0brQTCX2bm4YYjQXgFRT2zp8qYmmdsf+zoKBZdcmCYKNY1xWd3UcsjwJD04tYFJAuwyh7XKs2A6RsdC1QleBWhYM9pYUpbrWh20rIJKpDHac3EtJmXOzgx4n9H2z76TDaXH6UOjz3P7sd2XOzF5Cumo6PpXFaSyZRrcQIIUeQOpPidUxhz0qpaRWUDdFLr9cf3Hn72QQvxJEKfulRsg9JA0UiH1z15NaZZ1I0JiU7cobNM1t6SkCjvLIdVVq/5MAQNDvhD+ou9mwf2Uui9x7t0rSz+nqul7D79ztEGvJXraqMtC+FnxW97JtYjDb2wt5FE9Mp/UcSMdIuTnP/W4888rTDWC1+UjVlt2ovUtYOsHG3mc37CVBWbDLMvVdDWjc5KlfcOo7ZM9hP19lsXudb6/0A0Q7aXfQCNEvOdsbW6lxAMNYzcpWn9ROh90Ooz4+roiCaur2aWQte6fMBZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199018)(122000001)(83380400001)(316002)(110136005)(54906003)(6636002)(33656002)(82960400001)(64756008)(8676002)(4326008)(38100700002)(66446008)(55016003)(66476007)(478600001)(26005)(9686003)(6506007)(71200400001)(7696005)(7416002)(66946007)(41300700001)(2906002)(76116006)(5660300002)(66556008)(86362001)(186003)(52536014)(8936002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Yk6BVcdxwJnPaW0jPAfAqDfdoaEcc5LO4IoCl49YVjBXelY05LaKSU1YoeI7?=
 =?us-ascii?Q?CUm2/HodzLk53XgKa5QzRSKg+7MIpXcFSzK4c+zzxYdt4XnOYvisF1aE4t+b?=
 =?us-ascii?Q?rkZoVB8ROuXW4GLhZD6oFn171+NaFKirkFB0oZG2BQKBSIyXZ5o1gUwGUMR5?=
 =?us-ascii?Q?teT+7toe+MLrb1BoDimEyxQ/ed/x58VEKV4BKb11T/4DbSQFg7F+UB/ghAL3?=
 =?us-ascii?Q?B/D5uHYu6i02vo0mGkVuAzwlSSSb8dN1nyftu0HcWrfVWmrHBjCwB9uuTnJT?=
 =?us-ascii?Q?H1FR9vWTZfj2NROTYhh4xGfMqDKkzoBB5b4U2iQFoMrlCNCySZ54ETL0Qinj?=
 =?us-ascii?Q?TfjNY9S81yJwOXkQAuGCNxQHPWZM8pX9xih26PwgryI1owoJ7Cr4k+8RUU2V?=
 =?us-ascii?Q?ILZ+VXUiKxklcYot2ui97E7umSbFkG7qqdkJliPwb4/gcstSMTYi4rWMaH4R?=
 =?us-ascii?Q?EFP8lFyM+kCbDENrqRcOd3L5lAITRiEE/iWclNFpx+9NtfYBUyi3HUrPNoPY?=
 =?us-ascii?Q?rR7gqvnRmNo96zJ3f/Pe6ZDwcGm1TztV/8OwVV45pYzudvL3Z2baboXINOH0?=
 =?us-ascii?Q?YX8ml+8RYYGXtjm0HW0K0OVw5fS3yPpMxNm6NA3ULtBtbOOvR9WNqImzM0Rv?=
 =?us-ascii?Q?hQigzWizxzBsVMgCNq8cL1rfDyfjya13685MDV455zfjkBR7j6ZZOsw4DYg5?=
 =?us-ascii?Q?CFxfZtRIhfiFGaMnq9kbJqv9T6KagUS6K2bjv9nng5rEWK0wP8rmVewpxXmV?=
 =?us-ascii?Q?IXuRGPdOuMGSfs63hzV4LIjPLWrmEV8T9T3Rs7rx4FC3bHdFiLlicNHw1Dw8?=
 =?us-ascii?Q?Z+CiKxHs/x7/ugsKLIWQ10efRyIoL3qq8eQTIRwz3KKFkaCArKFKJUKm4nFA?=
 =?us-ascii?Q?aTGq1tYjf5vb3GqTEYYoddNTNR6i0Ls4HKYsQxT/8n7Y7vYhcArHgwHrliFH?=
 =?us-ascii?Q?gy5DeZC1se60SWsywiqIuVr4e4hl5y5yKArqiVe8Rc6m9TFWdEoLvS88C1o5?=
 =?us-ascii?Q?MxH/Vqa3CSKZFYGDNqxO1znaOTUeAeIal/2DgwI43xR8p/ICEnpJdciB876e?=
 =?us-ascii?Q?eD8oIcyWp7LQNdhs0D1tbgwlDT/ydxGB4EKn+C3NY7vBn4E9nbq6mSU65oyG?=
 =?us-ascii?Q?aVHojROCNEyePxUFVZlrCpGo0rP/rXjfxKKyvpYykBahf+eThXyjIhL7Rout?=
 =?us-ascii?Q?+bcx+a+LH68zUBx3Xtvv3wiDRwBo2wDH2NB61aMVXthu2wqssnK3eoBlfKdC?=
 =?us-ascii?Q?SsTWK45TjPsw3AgRD/a6AbyB1PeMryVu5gSLpguDBAa8AsEskbXWNlcvfRMH?=
 =?us-ascii?Q?BdHQTfeOEtDobm8fhOLL1hcwqNTPeq2z8t901FMxqdv2BBdjXCievLHxxPSC?=
 =?us-ascii?Q?kOzNfp4vhDjAJY5W9ScvOPisekSYuiUHRj452NNRAcyLkRaTbYvc8A0134In?=
 =?us-ascii?Q?QN77F3UslijgonsPNg8WWqtDw1b2kCmYJhrvayHxU1pdBTukTCxfWEiQlO4x?=
 =?us-ascii?Q?9pfmfcnqN1tuiXYtIzxg/4kidP2jPPP6VXAMSjWrMnfVQ7QTdels/zLlE/WI?=
 =?us-ascii?Q?/QrSlZZjHREQAyIF58xw2XStzTon3/HHcZ9tE6fU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb479986-d4bb-40e6-8c21-08db1a3602c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2023 09:19:08.0023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RR1kfOi0DowcH2OivTaLQ+Zu+HfYTxrRGaTpOeBW+69NXv7Gz/MBz40NhI+h2EZ5kZF2yZLG0WsGQXNqlC2r+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7311
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, February 27, 2023 7:12 PM
[...]
> +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> +				    unsigned long arg)
> +{
> +	struct vfio_device *device =3D df->device;
> +	struct vfio_device_bind_iommufd bind;
> +	struct iommufd_ctx *iommufd =3D NULL;
> +	unsigned long minsz;
> +	int ret;
> +
> +	minsz =3D offsetofend(struct vfio_device_bind_iommufd, out_devid);
> +
> +	if (copy_from_user(&bind, (void __user *)arg, minsz))
> +		return -EFAULT;
> +
> +	if (bind.argsz < minsz || bind.flags)
> +		return -EINVAL;
> +
> +	if (!device->ops->bind_iommufd)
> +		return -ENODEV;

Hi Jason,

Per the comment in vfio_iommufd_bind(), such device driver
won't provide .bind_iommufd(). So shall we allow this ioctl
to go longer to call .open_device() instead of failing it here?
I think we need to allow it to go further. E.g. leave the check
to be in vfio_iommufd_bind(). Otherwise, user may not able
to use such devices. Is it?

> +
> +	ret =3D vfio_device_block_group(device);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&device->dev_set->lock);
> +	/*
> +	 * If already been bound to an iommufd, or already set noiommu
> +	 * then fail it.
> +	 */
> +	if (df->iommufd || df->noiommu) {
> +		ret =3D -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	/* iommufd < 0 means noiommu mode */
> +	if (bind.iommufd < 0) {
> +		if (!capable(CAP_SYS_RAWIO)) {
> +			ret =3D -EPERM;
> +			goto out_unlock;
> +		}
> +		df->noiommu =3D true;
> +	} else {
> +		iommufd =3D vfio_get_iommufd_from_fd(bind.iommufd);
> +		if (IS_ERR(iommufd)) {
> +			ret =3D PTR_ERR(iommufd);
> +			goto out_unlock;
> +		}
> +	}
> +
> +	/*
> +	 * Before the device open, get the KVM pointer currently
> +	 * associated with the device file (if there is) and obtain
> +	 * a reference.  This reference is held until device closed.
> +	 * Save the pointer in the device for use by drivers.
> +	 */
> +	vfio_device_get_kvm_safe(df);
> +
> +	df->iommufd =3D iommufd;
> +	ret =3D vfio_device_open(df, &bind.out_devid, NULL);
> +	if (ret)
> +		goto out_put_kvm;
[...]
>=20
>  /* --------------- IOCTLs for DEVICE file descriptors --------------- */
>=20
> +/*
> + * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 19,
> + *				   struct vfio_device_bind_iommufd)
> + *
> + * Bind a vfio_device to the specified iommufd.
> + *
> + * The user should provide a device cookie when calling this ioctl. The
> + * cookie is carried only in event e.g. I/O fault reported to userspace
> + * via iommufd. The user should use devid returned by this ioctl to mark
> + * the target device in other ioctls (e.g. capability query via iommufd)=
.
> + *
> + * User is not allowed to access the device before the binding operation
> + * is completed.
> + *
> + * Unbind is automatically conducted when device fd is closed.
> + *
> + * @argsz:	 user filled size of this data.
> + * @flags:	 reserved for future extension.
> + * @dev_cookie:	 a per device cookie provided by userspace.
> + * @iommufd:	 iommufd to bind. a negative value means noiommu.
> + * @out_devid:	 the device id generated by this bind.
> + *
> + * Return: 0 on success, -errno on failure.
> + */
> +struct vfio_device_bind_iommufd {
> +	__u32		argsz;
> +	__u32		flags;
> +	__aligned_u64	dev_cookie;
> +	__s32		iommufd;
> +	__u32		out_devid;

As above, for the devices that do not do DMA, there is no .bind_iommufd
op, hence no iommufd_device generated. This means no good value
can be filled in this out_devid field. So this field is optional. Only
for the devices which do DMA, should this out_devid field return a
valid ID otherwise an invalid ID would be filled (e.g. value #0 is an
invalid value in the iommufd object id pool). Userspace needs to
check if the out_devid is valid or not before use. This ID can be further
used in iommufd uAPIs like IOMMU_HWPT_ALLOC, IOMMU_DEVICE_GET_INFO
and etc.

> +};
> +
> +#define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE
> + 19)
> +
>  /**
>   * VFIO_DEVICE_GET_INFO - _IOR(VFIO_TYPE, VFIO_BASE + 7,
>   *						struct vfio_device_info)
> --
> 2.34.1

Regards,
Yi Liu
