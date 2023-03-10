Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54076B3617
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 06:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjCJFbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 00:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCJFbT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 00:31:19 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E9EEA02D;
        Thu,  9 Mar 2023 21:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678426267; x=1709962267;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xAmVo0dHGc4YftmF9w+j8okRuHaqzzKjqZKNeYippsQ=;
  b=AmfHQ2SBw7ZB3lDjpZhEzNcQAVuE7VEoUxNHKQIeMrdQiCzSb4bRcDlG
   FngD/y6JgY2DyyqK1iNhFRLj9NSBVK+uXhA9SH/oCQUX+ejYU66sCcoG/
   C+Iug/6AYwFN8tW1mogrRzPh2f2pn63PgWtBrvPkvdY52zvwrvp0au3jg
   E3TZjh+SfFdPjeGZwrZ2EBCih7snSLjzHR7wQMMF1gohmyI0HsFGWuC06
   HfJOhO4YNIU2o3z70vPCJcz1Db0XFlIAm4P794PJF7HFxzzDSKrc0jFmj
   DfWu/1FnT3AhbwavHXM4wl0DZje9hYewEyMxEMFrqdgAe7cgErVXOig2H
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="422919352"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="422919352"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 21:31:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="627681737"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="627681737"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 09 Mar 2023 21:31:06 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 21:31:06 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 21:31:06 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 9 Mar 2023 21:31:06 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 9 Mar 2023 21:31:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dFlr+E/ik18MEYoSa8/qzRzLroi4TlsSRj/hKJKHzVW9kwkRkd68YoEtGdxZ3bOAH/xfUEnBXeBsU3kS44KBMB5PCnCyw63UrRtaFxGMThpZGOXROGSFWLSxhtE2F7Exqi+5qeP3PGkpSfNLNCjowk36R0o197G8TXNJqBHxyLtk5MiPNLF3wErzYdQVQFLc73cycp0kfS9rXgnKlaK7uXFILj/cn2+/6JM21tUS5MWwJbqAgOjAwIPeTsxdtwOfXvBBHFL3w5hwo7+/tDKvr8RXBUl60t6noYp2ovC+0fmEo6j2IRqCl1tOU8g9mcd5yxbAwu/BghxNqkjRpjkQqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/bVYpUFElEgzdNWAYFadJ9l1Kmom6dxmNcqjz7oUrq8=;
 b=msZWMfkFSrkL4QT50YncO0TO1nNjdo2jzNZuMCXv0xUV0mTmo6T7mj0pbPCEfKRblQ0Rp+0E+QV3bEygHfInu7sPaoBwVR1ykrd1oKtOQXZcn96x19LuKa91nnPLKuW/h/roPF3P9e1d+4cfx2F8NSbIty3lP5EBXoCcxyCKn0PmXF8jZpRl07gxWy5UNkxi98THMSP9oebP7MUd1Xsw4Vwsdr+YMz66HLhfGCbsBCEsKnWBFSyMv56BzW/9QGrAJ7DOL27R98JT2u8ab+aU2IED7H/UEWjUV3Bb0pab78gjXSIM/Aan6Fyey9/8j5b4ieMmasAwJBrmEoIIIZoRcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7871.namprd11.prod.outlook.com (2603:10b6:208:3f5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 05:31:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 05:31:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZUcIISo3Z1SbL8EmJASujVt/DZK7zfnug
Date:   Fri, 10 Mar 2023 05:31:01 +0000
Message-ID: <BN9PR11MB5276C4BB18EC47CD047D498A8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-13-yi.l.liu@intel.com>
In-Reply-To: <20230308132903.465159-13-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7871:EE_
x-ms-office365-filtering-correlation-id: c780a0b7-d994-4d88-fd2d-08db2128a290
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kZDh7fTsEJ7Z51NqKQjc0f2PsQbeP3fOJiF4EpiyVRgvbA2yIR6d/LXhKE06Kwd1EfuHIGPr4Aa1eYY9X1yX3nbsreqoPpl8XJ0SlONBwTnuIrcPZVDqmzf+kz9hlErRqTUgcBc5sD9P/ocAU/cvkn2vBUKZ6pjVcwpHj7C8/Ewhbrz3vHuyA3qhJZy2TAqVmFMeC3UVHaMx0A4agbHmEIUpsuF36gfJPFuJAu7MkNCFDvh9T23FWL/WkTtHCxDAVC5OhcKGAEwlnv2fY869lF6uxjB6pvGugNCTavuVAndQCVMnXig9DMqsrgCJFoUORatZa1rKrCZIDgyCpEMePTqkMWlGwehytLG904rA9mS3CHn7Zkk5fbsYuVDr4VEK911VUvXlrr49oR2zknWRf8YvozQk3qpWjKDQoGkCBou0ojMm7Av6rqQl6gYGp17VXKp+qzZFQEqY1aN3bZNB0FmuiolRfjw41bLdHnPcfXX35pbJszCuQlvS/oS9019mNaKDEqu4yGdQib7sdhTux/tRq1HWIejVEYqdV+hJtM1kX8ZTXioJbUKScpQpGfG27leiOOWen2EglWZtlpv/ynSMQ+72in27f3OkD241LoK1aAjMqjirZqFmEoSmchcFVCQg+r1OXi1mcUzLaw2wLWT8keSzbS5tSij3JR9zdj0KrM2/fGd7dotoySEcFJzdeulBh209oKnHCNfSaQj/wQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(346002)(396003)(39860400002)(376002)(451199018)(38070700005)(33656002)(55016003)(86362001)(478600001)(7696005)(71200400001)(66556008)(66476007)(66446008)(64756008)(8676002)(66946007)(76116006)(110136005)(186003)(54906003)(316002)(9686003)(6506007)(26005)(2906002)(7416002)(38100700002)(122000001)(82960400001)(52536014)(8936002)(4326008)(41300700001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GFpmm9guqmrTw1uCrIq+blhRrUfrLHHOIlqkBEMPXw+Qcsaiw+Q+OWMqvOfX?=
 =?us-ascii?Q?sJM4GyaLM1HiBXdVrsDmoXUpebErVVUzlk1zipxsvuRtaJhI4zTTRvJ/UR1d?=
 =?us-ascii?Q?sbXG4rXNplCoX5qWM3Bx7r6R1hMkZmO+3TQPNHT7R/37pjPvNS24dw3dQfAo?=
 =?us-ascii?Q?iIVq4iIh0//joksF6w7jd32G/wSCn+m87UgSVd6BFcItDFNUnp/kNwTNx8tr?=
 =?us-ascii?Q?F7wYzoySJWLOAngp5DYRn/G6yfh59pglI/hSHLQEI1y/6iaC1vRzY+zVfhY6?=
 =?us-ascii?Q?i87TAYdBhHvO6ssdkojTCiZ54G1X59XFJgfVwoRpYJAvW8WvadOF80PRKm9e?=
 =?us-ascii?Q?2BwkhaPt54z/WfsMnDQ7LX1RN+Mzm+iLdwjHwzduMgGheyFyaMGxm97q7K73?=
 =?us-ascii?Q?FF543uUqTj2UMuOHx6iejEY/or0bBQu3S4Jc2TxIIpxZYSF2DLARv5M4jA6L?=
 =?us-ascii?Q?BXKRS95OgT3dgu00od7iGF9/yw0A/wLZaFy/pVzUcapo0uCfGK95z+6/84GD?=
 =?us-ascii?Q?/6WOM7TKBQQOZ5qMcbPJRLZvAETIU/0kXTphP4dEXS5ESjjbCMRPE/qOkBBI?=
 =?us-ascii?Q?YVBKWFc39HImbh9rTqg7weirr4roDdWX0gxPSIfycKlSUvx5d6eT8UeXx0BM?=
 =?us-ascii?Q?iUnv+1i3PdlPRtxImLAl3mXlFIAgh0YbWGOPrN2W5Ymo4UTXC5I6eYwfLsiX?=
 =?us-ascii?Q?iKvcTLON3bIkD/TGNSUpQ1eqHn1CrVgdOs5ZvDzd0AJHMoROWhPS00uXLDai?=
 =?us-ascii?Q?XQPtwjYgszDcKWuuy91Tg0qbKm9d3cXV/hP8KubIgsYCIuGJmZJx2C8ONbY7?=
 =?us-ascii?Q?GqfR6YYwJ12coEiRY8+HY/s0duuJJuCUWyYe1AfbTHD+DmJIbF6kaA8VpeqU?=
 =?us-ascii?Q?zRn+t54OsphFCkAHvcSPhC3uVRbRnO+YztvotRKIcMHy0o+qW8jJXMU2Hk9i?=
 =?us-ascii?Q?zUHhwI8orMw0HTIuNZuVWYIU2fbxiOuSsIely5dYptQ2uF8J4g42MfVph1dr?=
 =?us-ascii?Q?3yJslK5LmucaCAFSXOFmcJW/TWL0UTxSxeCOA8GeFU+DqihU/YavXw6ix5+I?=
 =?us-ascii?Q?GwhRu7K3JKFpD0E+mmnvADl/fM7wvGUgZclfKNClwOypBqQF8BbQChPiiwKP?=
 =?us-ascii?Q?krT7xgN5hPDb6G77K8F18TLsCXpssnjde3ECmmpdFZlsHwxJ6+xvXT1brzDe?=
 =?us-ascii?Q?4wT75YfVlOfwA8tZca+3xvKQV7B8hx79PYgMHylRYB1Q4P1Z2mf8NE82HwdL?=
 =?us-ascii?Q?QqWRSMP5MtYVEvmiZ/b+Qe9U8lM+K2M8lXwd3216/FQ90lmnaua2wTHz0I+s?=
 =?us-ascii?Q?OCktLVH5ul+QUPm2sMccfsKDFG1umslm3G6DCIL1eWpuobbPlA2qDt+DMpiM?=
 =?us-ascii?Q?RBRikK3T5eAox3THAXzC4qrJMd6qJAnGMHWpyPtvd+CLUjKsQjaeU3EufWHz?=
 =?us-ascii?Q?Bi37BHFD5q3GFWwlz3csMV5Z+d1z8zQpJn5VemYCBBvNUPXmGybOicbfdOkR?=
 =?us-ascii?Q?r62EIeT0h7nN/3SJHq8cmOALYa0LlXZzqtRZShtuk4V6Vicf96M6AsOlcvIA?=
 =?us-ascii?Q?dmtX8Eizs5RfYxYy8wWi+4YkfmUQBcrksddp0wXr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c780a0b7-d994-4d88-fd2d-08db2128a290
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 05:31:01.2720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: im92GGfkBLp7xzFrq6lKj6tkjcpu6CoraYaHDd6qGxT5Vf2AMNkocOpu6yVWdrNV4oS+vg6Yq/s2Evq+XJpyOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7871
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Yi Liu
> Sent: Wednesday, March 8, 2023 9:29 PM
>=20
> This is another method to issue PCI hot reset for the users that bounds
> device to a positive iommufd value. In such case, iommufd is a proof of
> device ownership. By passing a zero-length fd array, user indicates kerne=
l
> to do ownership check with the bound iommufd. All the opened devices
> within
> the affected dev_set should have been bound to the same iommufd. This is
> simpler and faster as user does not need to pass a set of fds and kernel
> no need to search the device within the given fds.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

I think you also need a s-o-b from Jason since he wrote most of the
code here.

> +struct iommufd_ctx *vfio_iommufd_physical_ctx(struct vfio_device *vdev)
> +{
> +	/* Only serve for physical device */
> +	if (!vdev->iommufd_device)
> +		return NULL;

pointless comment

> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -682,6 +682,11 @@ struct vfio_pci_hot_reset_info {
>   * The ownership can be proved by:
>   *   - An array of group fds
>   *   - An array of device fds
> + *   - A zero-length array
> + *
> + * In the last case all affected devices which are opened by this user
> + * must have been bound to a same iommufd_ctx.  This approach is only
> + * available for devices bound to positive iommufd.

As we chatted before I still think the last sentence is pointless. If a dev=
ice
is bound to negative iommufd value (i.e. noiommu) it doesn't have a
valid iommufd_ctx so won't meet "bound to a same iommufd_ctx".=20
