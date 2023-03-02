Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A3F6A7A44
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 05:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjCBEJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 23:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCBEJP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 23:09:15 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B968D23DA8;
        Wed,  1 Mar 2023 20:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677730154; x=1709266154;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gQgC0HEPLE+zgfLVOH9Ber/DJ2tp8vrLEHf/PGpVMds=;
  b=D+4Bap1FhDWcRtmh7rFO2EdnwdyJ2sE0mg2Eab33DYOrdPGGFYJGSKBI
   o9W1cgkOAAceicGAc6e6ptDV4pMUclq7SdZYqL4n4ogMM7PzQCQhQb7SU
   ozGafofzL8a9xeEBofG3BH8LAXTZIQbdjhNj0kw/W8azr7ruokUDcf+Vu
   0eIfIMW00thMEDzCiKF62KIMIiWvYEu9GcQgSmFztDIg8RZ8A/WhKNQA+
   iz1vjpw72zxYkQW1g1XnoGmZxkLQuqJmC+GIQiEyBKYfnbO3gA0ndtal9
   FGDWkiPSNlIweNvogiVu+e8XaIAxgvkxKrWomPmtn1hhpYeMf0YpCVtDF
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="399398103"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="399398103"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 20:09:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="920511051"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="920511051"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 01 Mar 2023 20:09:11 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 20:09:11 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 20:09:10 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 1 Mar 2023 20:09:10 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Mar 2023 20:09:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JRmlB5gPplFzbqM9EQGasambFJ1VGNV1Mc6clsJ7OsU+CZUpuw/KJWa3AcxyLAsr7x8XHFnLv7IUJyA7tipGcdinamPdHcRRntnggLNzAOLAeEZEIVotoMF9RADrguVgTQLQR4hQ5LZqWS2226TUsRK2YLcUFSTwSTDEXRhe6C2oGM8Y0glCyYgZIdoHYJLwnwtu/GOBi58e0RNKr7XZU7pq8CQJPowbCNht16ajZ/M2FWIpak3o6+YLTE7PMyEqY1B3gVIUpE0PeDw1iuw1O9xdEM8XIt6mqZLqQ8dUoiccyhun3sESaxwpRtrJQKXt8FmHETxKiArwSQhuqz+rdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sVFXFQbNSlgKtMPTC4Kd+1sp2lBSyVD+gjlx3+ULkKQ=;
 b=XKT62YcSoqpKSsRdhRB5JXstJJDVrZNMCMZ+mFaki4uV6s+Xt8LiMHDy+y3sKyis6+KDoN04TkfRNOmci6A/84RZdsX2mjfij5oqtJ0EIYmJoJOBg4sW4ORyLYf3+B6ZC0tP4Qk7XciQv8AOOEIepF1X02svjDIAM+CXCuTHQeADvJBaagt48N+S7v6/5zzup/Dg1DpVR9taOkukffFD3NXuEVnviwUjEBqT3Z4sRAszKzO/E0DthH/zn1Y1oT2w+oPl+B0OJ09QKHTiHv01qnC/Uwcg8jfdU/NqSpQDVrBGeUSMgiIa7eaAiG62wt0XJZqEog2vvzOsVW6n4B7UdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW4PR11MB7151.namprd11.prod.outlook.com (2603:10b6:303:220::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Thu, 2 Mar
 2023 04:09:08 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6134.030; Thu, 2 Mar 2023
 04:09:08 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: RE: [PATCH v5 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v5 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZSpxP1elsXPP8bE2Y+PYEE7Tlg67ln1gwgACXEYCAAKw5QA==
Date:   Thu, 2 Mar 2023 04:09:07 +0000
Message-ID: <DS0PR11MB752942573C00F7AE5C00C242C3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-17-yi.l.liu@intel.com>
 <DS0PR11MB752959193D5CBA2A677B1F18C3AD9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/+Pkbtr8KQmUjVp@nvidia.com>
In-Reply-To: <Y/+Pkbtr8KQmUjVp@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MW4PR11MB7151:EE_
x-ms-office365-filtering-correlation-id: de403016-3183-4352-0a69-08db1ad3de94
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: knR+8m2EO1gleagwXMIIYx2NSiGeZwim9J5uZHXE1yWeYNFwIm47uzbwJGT8rACxODuw5b0YpzqHVzoZWzIkWKIZoQaa2jSLoHmo3MdxrmtasbWV2d1PXRm2LP/KKVxTgZb4mpytzdExD4FIwfcRXwCj5sskBrzizNhahblLT/Yx/Dfj6gLyrY/ez1xwA+bLVcJPWmSQF29Dw2J0XYfldkcDO1AE3aI7a5K0AuZUNcT3EYDqfdlvDD8By0hM5v53pv5MIT8oLa4QgILqrRGhseU84O7wVIWiefKcBit9cITSWQfWifS99ye5xwLAH2/ADEazoLmr/LeZSgas72qFBsJOpTC4j2gQa2Sjhqlx0bu/xYB1lCLQKRbKD6u9MfphCr7wWSQaIR/oJvjCMnw+I2Q9+8jGgppAFfLLq341M0jR3WuTvxfIPVKZTfP+jzW0jz9V3PS+pFm3DYgCLpoR1cG94ABMUHxTYuqr49XBVk0lNABCq15g3xMYcH+nbk/Xi9fd8Tr4H9FfT7BheB0qrVyAWAsmgtMXO43q6Ck8ERJIhFgDcrLKJcv/RUur+OZOnePdfC1a/o+yiSmfqKG7qX4WLLesyNmxOZQKzF2lM5bLD+1LtycbQ+8MUeAa0vsMLp0obFxwiiZu6Jc7E02eQv4VpJAV7JYOQXPz/7fv9Xg9iopkvnq/OkSL+l7jcgW0hrxMVauNQJnAj0uBHUzljg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199018)(2906002)(33656002)(9686003)(82960400001)(5660300002)(6916009)(38070700005)(66446008)(83380400001)(52536014)(122000001)(186003)(316002)(38100700002)(7416002)(76116006)(66556008)(8676002)(8936002)(4326008)(66946007)(64756008)(66476007)(7696005)(26005)(478600001)(86362001)(41300700001)(55016003)(71200400001)(6506007)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A5gLFhJM3KUAU2KJynB44tMPlpXeTGgxfFztu4awHIMm6y+P8xzGoIKbRtKZ?=
 =?us-ascii?Q?9+ExG0W/s8Qne17G7oOQUA7RJRcnmhShf7Je8tcRYM/7Rj/+d4WRnRpKEFdR?=
 =?us-ascii?Q?lyxbQ7lPhlenY85DwFX0wLmqB8+BSZcn+1M8FZostxRFMebH79WzIiyfC98W?=
 =?us-ascii?Q?lnipejDaRFk9tlMog3qPekmQf7vK+BzLpQ4+QjQc4tv8c8OpMSLPv2HM2l5v?=
 =?us-ascii?Q?HtirkxXd1TOXiNEZVDzedO8U7VPKImPLm2yu3Hd64RMpGqm1cRY8iVqQzaVv?=
 =?us-ascii?Q?csU8P4wqKna/AQTCsjkQPKqkFP7A+dgJQJNhgHRuNgu79xIOyVvBCKUaCogh?=
 =?us-ascii?Q?+Xjzbs38pPz0mL59asMVLgQULtyefihGNl266H9nZE3BuhjgNl7XyjUz8Wc1?=
 =?us-ascii?Q?0xYUI3eKJsPURnD1L3fsM5gLFx0yu6LdW83gcrHTYxsIwAua2pl49OYyLcwp?=
 =?us-ascii?Q?yekr2QhD2UPrfg0JxXBzXdmx/Afc/x/RZLRkbMsD8HtzaCNR5zVIgniGYTS4?=
 =?us-ascii?Q?QWDrleYWn6lWNX7O5Jl6fJrsy8j22yCCpENLRnfdn49BgkuCsRyAuZ6yGMEm?=
 =?us-ascii?Q?bmX58Ffg8QFdokKwzHcUOhSCosrOVrXAe7S/jdDj7KhgspGQpG9RVSk3AQ2M?=
 =?us-ascii?Q?izXsCyhAI4fSe2Votq7sMqnyQUHj0VEU88RwStPairPW+QpJiG8WY26C66fg?=
 =?us-ascii?Q?GvnUXMI/iY0TopwBEN9P6Q1+vDRlzCn68nxZJyhU0OnPz46CwfbZlYe6aTxK?=
 =?us-ascii?Q?SOy3bNcNhAP5738DKN6J4sQvsNc9lP7BBSPHfcCfWdlBwP2ChLElE8yMHnNb?=
 =?us-ascii?Q?HT9hEh35CrvrDKKvvjLli5D7zj48dnT/70Qf93ZRBrO/HjAvnqUW41AeJoaQ?=
 =?us-ascii?Q?H/43vF9y/aTa7ERVzq6rI1FLj2V06IvPamP8mi0JB3p8RVzhptZcFdDar8z8?=
 =?us-ascii?Q?Bmggu/bj0uGHRGLajYyFCBgC2TIr/UewRfnD0OeGCyXxOHvHzGrJWahggETZ?=
 =?us-ascii?Q?BfuvC67py+Ei4rakWe7bFqycL3EHxOynVWDikaHgfyiMnWsrTJct19ERDMrd?=
 =?us-ascii?Q?YrdmUwa6SaDDTrOsXs8WbJInef8la7pRavttOVsVn3zTADtcOHzJbt1//tRY?=
 =?us-ascii?Q?qZKfKZjmsibwtjM9jCvT2IidNhVP8Yb3fGWiBqETP/kdC+z0VdrvDIZ3odL8?=
 =?us-ascii?Q?W11Ykivy7pc5dIcaaES38lNlTtq5yU+fnnTk4gGxlTaYt8t5NfCkp/zlzfCg?=
 =?us-ascii?Q?HxKzVaxj0UnUH8k9aQouxsyf9zVpXkbTgElVhvEHg6H3SCC3t86iw+pn3Y8A?=
 =?us-ascii?Q?cLjHY/uvevTUYoSN5RgH+grV8PqunglACnUfLdo5auAuKj/MqHBq8mYeEk2v?=
 =?us-ascii?Q?7uTMyu9Wr7Fy/87NbYTR7IL35VwgOz2vNNeLDt93aB4tQG8ZW9JFZRqyZPGr?=
 =?us-ascii?Q?v2/NyuRofnmDTgAjHuGU589tCYn2VINLOKt7lg0wa6gH9Bpnnp/EzC4yrrjP?=
 =?us-ascii?Q?vz89xZ73fBFdIQ6J9lDmbPsmFX95aAXXqsbkXOX/qTdRbj0LBIlo6Tr6SJz7?=
 =?us-ascii?Q?8x9agIWE20gZ9+uCVC0E3gacj1ZilEt6TmK5JZWQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de403016-3183-4352-0a69-08db1ad3de94
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2023 04:09:07.7097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pKa8HqV6c/itafFT9dNAQmRSIt7dHCnK1c0z7GImC41W7SIeks/1qwPmeFm16uUyoEYUGFedHrG0OFY8KkGYuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7151
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, March 2, 2023 1:47 AM
>=20
> On Wed, Mar 01, 2023 at 09:19:07AM +0000, Liu, Yi L wrote:
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Monday, February 27, 2023 7:12 PM
> > [...]
> > > +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> > > +				    unsigned long arg)
> > > +{
> > > +	struct vfio_device *device =3D df->device;
> > > +	struct vfio_device_bind_iommufd bind;
> > > +	struct iommufd_ctx *iommufd =3D NULL;
> > > +	unsigned long minsz;
> > > +	int ret;
> > > +
> > > +	minsz =3D offsetofend(struct vfio_device_bind_iommufd, out_devid);
> > > +
> > > +	if (copy_from_user(&bind, (void __user *)arg, minsz))
> > > +		return -EFAULT;
> > > +
> > > +	if (bind.argsz < minsz || bind.flags)
> > > +		return -EINVAL;
> > > +
> > > +	if (!device->ops->bind_iommufd)
> > > +		return -ENODEV;
> >
> > Hi Jason,
> >
> > Per the comment in vfio_iommufd_bind(), such device driver
> > won't provide .bind_iommufd(). So shall we allow this ioctl
> > to go longer to call .open_device() instead of failing it here?
> > I think we need to allow it to go further. E.g. leave the check
> > to be in vfio_iommufd_bind(). Otherwise, user may not able
> > to use such devices. Is it?
>=20
> You are thinking about the crazy mdev samples?

Yes. we don't have real devices which don't do DMA. Is it?
=20
> We should probably just change them to provide a 'no dma' set of ops.

Yes. at least generate iommufd_device I suppose.

> > > +struct vfio_device_bind_iommufd {
> > > +	__u32		argsz;
> > > +	__u32		flags;
> > > +	__aligned_u64	dev_cookie;
> > > +	__s32		iommufd;
> > > +	__u32		out_devid;
> >
> > As above, for the devices that do not do DMA, there is no .bind_iommufd
> > op, hence no iommufd_device generated. This means no good value
> > can be filled in this out_devid field. So this field is optional. Only
> > for the devices which do DMA, should this out_devid field return a
> > valid ID otherwise an invalid ID would be filled (e.g. value #0 is an
> > invalid value in the iommufd object id pool). Userspace needs to
> > check if the out_devid is valid or not before use. This ID can be furth=
er
> > used in iommufd uAPIs like IOMMU_HWPT_ALLOC,
> IOMMU_DEVICE_GET_INFO
> > and etc.
>=20
> I would say create an access and harmonize the no-DMA devices with the
> emulated devices.

In this case, iommufd_access would be created instead of iommufd_device.

> What should we return here anyhow if an access was created?

It depends on what can be done with this id and whether this field is manda=
tory.
For iommufd_device ID, the user could further use it to query iommu device =
info and
alloc hwpt. Do we have a similar usage for iommufd_access? And if we define=
 this
field as optional, then we may return iommufd_access object Id in future if=
 it is
needed.

Regards,
Yi Liu
