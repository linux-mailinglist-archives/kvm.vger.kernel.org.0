Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4EB06B38A6
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 09:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjCJIa3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 03:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbjCJIa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 03:30:26 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFFFE8400;
        Fri, 10 Mar 2023 00:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678437018; x=1709973018;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JuoZVbDo1hboXtfiatj4C2zoHrkkKcKARvicSkWd9hU=;
  b=ZWQIrKNrhcCqpEXLXWZsDMEDz3zOcWqRHImx7ulsTkQ6qV04yple+g6z
   kKxY8YWrJUdD8N2aC+W/kjE+v5qjQjrlqZAYyJ1kBoVmDzRrCB4HcQLZ5
   fFP2NKfpG4Q5CMhqNrFo3EL/6Rb3xVXLXLL41twiHDwMt+90jxyvchbPT
   VeJlq0RvIj9oQ/qmt1LyPjt04zHzxOGl7oSPqz0f4l3dJ5ixKzWkg0PG/
   IH+QMmELg2tH9GcM/nDauA3rahu8Q4U/AZZ1COaMuSy7ORGbi47T/x5uL
   ClTARZ03H1jVJUlC0Rsx/sdO9PMxBINC4LRp+98mhX2rpFq4CbnHUDfv2
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="399277777"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="399277777"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 00:30:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="766751298"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="766751298"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Mar 2023 00:30:07 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 00:30:07 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 00:30:06 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 10 Mar 2023 00:30:06 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 10 Mar 2023 00:30:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDirg34TtVmvodwXLNacrCgdUwhNPU0aP8DVzMTo/PurvnUYQ79elneX9iMHfHqlR6ohIBwsyAL4FuOrjPG5WXMjVHP3GyZ51lNlOAvwhfP57kvhAibgHbE+Ne5xx+hPqZs//0VEbzXyfIVnm2mKWRZopOMCEuN8JOfgeWWvppRkUAXHaLd25s8StLKYchXFqYTzKGaXkVjLVAVwVBNNtLuijQ1Ov/ecEEzZZ7sjE4gDsE0kWgR7Bqcyf9rjXgM2zZTNCK48c+RfU5i+DynVgxLIO8ag9Le6iPy8KX151sInCWcqco7jrlBAatpdd0z140qNCFCzBmlUwkukt618mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O4Zq0nQVvFfkMHxKAlMqEm/3TGFuiQ59RaqT8bERwFY=;
 b=iTxvqeX9OCmx1nxwcd6tU5nznkeyRYQQ7BapEN7nDOQ7fHxLXM1M698kQOpZKaaxx5FmFHxeCL9Noi7v3wRLeZjo+aIzd2egf5jDwvANuj3lBlugPmDqowKJGxyII0pVQIV4fA1hVyUT/bimAaAnGhexVW7abWHIec+pNfF9HAE/SaBDz2SKgAt3DZcQmU7YtFjKVrKZTSNqYtLiaqldrLZMrF+/G68C+bsnOm1FTORfmM+Brrlg2qZVVmefbRHjf4zwHd10qzHrJUS1YJhRMA/R+prOtJl3uT3zIr0qlIKm0rMfJb+VZveScFIsDSVSJY+AbOXSUqA3NMGd1bJ16g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB6448.namprd11.prod.outlook.com (2603:10b6:8:c3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Fri, 10 Mar
 2023 08:30:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.020; Fri, 10 Mar 2023
 08:30:04 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
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
Subject: RE: [PATCH v6 16/24] vfio: Make vfio_device_first_open() to cover the
 noiommu mode in cdev path
Thread-Topic: [PATCH v6 16/24] vfio: Make vfio_device_first_open() to cover
 the noiommu mode in cdev path
Thread-Index: AQHZUcIIaFuKBD/gRUOqTGRCW0eqx67zrA+Q
Date:   Fri, 10 Mar 2023 08:30:03 +0000
Message-ID: <BN9PR11MB527617584434C93950578FA98CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-17-yi.l.liu@intel.com>
In-Reply-To: <20230308132903.465159-17-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB6448:EE_
x-ms-office365-filtering-correlation-id: 372a332f-cba1-4add-9c4d-08db2141a593
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pG95MyYn74hTTTZfcHq8DCrqtcALQkJ78QRAUv2dhdnH33VjQ/hX1dCsd/5qHvkJMyTBqnjg/HipkkSJcXTv09BaByImgkw7A968XrDbaRU/+DNkNgxWRSgU/OJ/wLAAJdmYliBHzjGSIF23TLJ9KyJW4o8QvFyIeXpQsD037hOy1uy3vzXKMhenug71Hg4WSbvFbGwaN2rkiFxp+Pj0WL0N3AHf9iF0phmX1OPjSYKoJIr+q0Wwg9dKFSwTkBl29UnAzcFkI4ETd2+VLlZ7hNLZLclbi1S4s8lEXVrS+VKpWxA3g+m7luykb4DgYLYKvcRzSvvuyZCyPLfIUmq5YzXA3tko50BCgLpA8bNqFsqIqf40Em1HL8FhA+Y2ag6P3SyzBj8SRuS/M7V/X2txuk66ssVTBBt6adYfIFlPCFDTwtH4ctVpeu7UcXwDgiBkV5IEqONxhPBMq8hIbeTqIL58q6e1sbxBt1pwQtfh9w1Uw+Q8OU59em+2mhrpKkk5mO/keZ/c6jhrphaC7w7yvTOOah0TdKV4ah5V2o+nfayQ8RQA1GMWP6XDB04/nv2yu9Z/953OUj8wbbIXcgOHvNyR1NFSRDiagswVhqaBlM3rX4ovR0qwRfOnDcq2FXpP6lFrdssjTKh8T8p7j2F5qFXaGRHWmM9T/vlTcNxwSQpgLb+GimIj+gsdItkx0BPTGnzy1PZwD43eiBUU0uWNWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199018)(82960400001)(66476007)(86362001)(122000001)(38100700002)(33656002)(7416002)(38070700005)(66446008)(66556008)(41300700001)(5660300002)(55016003)(71200400001)(8676002)(66946007)(76116006)(64756008)(8936002)(4326008)(52536014)(7696005)(186003)(9686003)(26005)(6506007)(83380400001)(478600001)(54906003)(316002)(110136005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FexLbkVLguvTxBtMEc5CftSSR9SvIq8SgngidxFylZ3FIy0gd7se4YWvNWXq?=
 =?us-ascii?Q?p2t/Jy2jllZXJxCV5tNbGvu6qvheB4fT0y60PafgwZwifkp/muK8p720qiHO?=
 =?us-ascii?Q?Grz7h9JFUv7cFYZNLsEGBLwDWJHLaScGpkMerUuICdV/vH1zzKVkqFBxQkTC?=
 =?us-ascii?Q?rENRsSARGPfOq4GtvaN4v+inrV7u3x95DxioKDnIAaGIIS9GIQaFAWPQHp9G?=
 =?us-ascii?Q?Eukn/zkq/y3xFwtQt926FjwOOl6TXD+Hv4PQ94gcTZQCmkWTao5+65iJMQZ4?=
 =?us-ascii?Q?VNty+RvCsEr1GnklKU0xNzOCMFL8zmM6fSs4Xb4VsVxADfDbK35/+aMH/wnh?=
 =?us-ascii?Q?EhHUMGESrlKMXd3AjBhHKuYTAmbpb8twNY5kW3+pOFGlD3rv0Nx8hjaJH5bn?=
 =?us-ascii?Q?FCm317whfyXLzR/Re+1HA1kjfO3veDCDZOFJbsknWdHPytUPEyWh7zOGC1sn?=
 =?us-ascii?Q?uUhXFqtoM0yQw/BHuYC7x5+mBgQ9CMrF5Pb56Jt+dZjG2AOOTGQQj7d1uHrT?=
 =?us-ascii?Q?s2ka4IknB2f4BHVqpfDfihedj6Z51GAavBb2ZU8Bz4EA0GMdbhsuvrclNT7f?=
 =?us-ascii?Q?ZN8x4GCb402sPdi7Sp1IJYtG5zxm98l93mS6dUQMGVZWOQZxDGHNFXh15DXg?=
 =?us-ascii?Q?FCgU9JnqNcBMAOLV5CQ4QSYb3LWJbeJKgIEGU1pzVZQUhaFTpHJRAqsWHQP1?=
 =?us-ascii?Q?HdcTOQw9N8vk+d/JJL+4X0odcXF46ioKE2jar0ohrlwkmSvUM6kj+3PnLKHt?=
 =?us-ascii?Q?Ai5WivLV2RsO3DVkjcEDXK9LaqkypzUdODRuhbN/dpJBkASFFNl5Ur7EUVRb?=
 =?us-ascii?Q?Eo1YMFyweWLlszo8HIPpSoVYKz5gPr2NqUaVgJpy3NhaXQmw2NzwhBcz0aTs?=
 =?us-ascii?Q?OjKsVo8z0KsHvAnj/6AGaGh9MiLz6qS0QDPraoD0LEvCeGLRa7QeDrbGQadB?=
 =?us-ascii?Q?hm4JVopTAMxcC3uTrHnQzUDQ44forQTDVdRtgNEodqXG3/d3NrClksd948AK?=
 =?us-ascii?Q?36icfpGa+mD7clVjvxqx9RfJ/OKlnSM731hd7rjoQtkugdaJRkA5GrLCeyXZ?=
 =?us-ascii?Q?LSZ+i0axzYZ1bZMC3aYg/UNGOhJHwDcF9sk7CjyNGJlTr7z7A/dLaq/cQ16I?=
 =?us-ascii?Q?at9kAA+dGKA8vTUNRB0pucxZ5dzOumUeoyfebJYdf6v0ysfP57FtGu4FLg43?=
 =?us-ascii?Q?r058ZCjjRDK/2SGSO49PM8nu0NX0ObCHghk1A6nk3WEYrCpHPeFeWCDePIDK?=
 =?us-ascii?Q?cw0yeVSQc31s0GXgGs1kskL5g7tXu1wolH3xTnEvw0lM2m5ta0GrmXrq2usf?=
 =?us-ascii?Q?neqj3/TzbnYBBawdx0pQd0CVDB2xgQucFNq42rssUhCPNmSN9z/XDgkmrzqO?=
 =?us-ascii?Q?62wqp5JA+YlYBlxeThhqSS0KD38zDf3czOfltxVXCaNEquQ2a7vxuSLpHtrA?=
 =?us-ascii?Q?4bwjIvD0xcUSaOpv8+B6Ut48Rk2OSbkxhBZonGpBHYRPVi/J7KDgKfX0nf0g?=
 =?us-ascii?Q?ZRdxaplfNcQ0bQyyaXk4BRqD9MkKdt2PUiOxKPq2U6Mysw/Nd71ycPRoK7kS?=
 =?us-ascii?Q?gFr1Nve9MxeoTsXoafg8zpAvzhy+0jji+nmnt7dF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 372a332f-cba1-4add-9c4d-08db2141a593
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 08:30:03.7406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QqlE7vGxxL+3OCSIaQvYcwtFVserqsVew7dSGT9NK0i5oOl0W3VrswKmSSj4kf3A5+MX/C5KiTmsceqYOGRswg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6448
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

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, March 8, 2023 9:29 PM
>=20
> +/*
> + * This shall be used without group lock as group and group->container
> + * should be fixed before group is set to df->group.
> + */

/* No group lock since df->group and df->group->container cannot change */

> +bool vfio_device_group_uses_container(struct vfio_device_file *df)
> +{
> +	/*
> +	 * Use the df->group instead of the df->device->group as no
> +	 * lock is acquired here.
> +	 */

remove

>=20
> +	/*
> +	 * The handling here depends on what the user is using.
> +	 *
> +	 * If user uses iommufd in the group compat mode or the
> +	 * cdev path, call vfio_iommufd_bind().
> +	 *
> +	 * If user uses container in the group legacy mode, call
> +	 * vfio_device_group_use_iommu().

this is what code does.

> +	 *
> +	 * If user doesn't use iommufd nor container, this is
> +	 * the noiommufd mode in the cdev path, nothing needs
> +	 * to be done here just go ahead to open device.
> +	 */
>  	if (iommufd)
>  		ret =3D vfio_iommufd_bind(device, iommufd);
> -	else
> +	else if (vfio_device_group_uses_container(df))
>  		ret =3D vfio_device_group_use_iommu(device);

with earlier suggestion then iommufd=3DNULL always means
noiommu in this function.=20

Then the comment could be simple as:

/*
 * if neither iommufd nor container is used the device is in
 * noiommu mode then just go ahead to open it.
 */
