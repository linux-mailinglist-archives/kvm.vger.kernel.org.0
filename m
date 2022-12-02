Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAAC164002C
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 07:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbiLBGQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 01:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbiLBGQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 01:16:03 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9C6DC871
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 22:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669961763; x=1701497763;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wK3Hp4KEwS0ZcsXQN265uNcoE0Zaq5LH/unPEz8tG4w=;
  b=fofVI66qKgfsG6YMuxDpcSVOFVyL57k/Yn+zLcdonqn6R0LkeWogiVes
   gDUmDlpd96UUfO/Zem4bcZnvtvLdg/fqE/tmPLB7ONamFZTY7v33hOrve
   hCeEGY1qtNHPRdS3au7LjxUm3i9hesNNew/wwYOXvOG08JAgMsHDo7TTT
   6sGy/S9zVUgMLv4AOEQb0ozSfC8MWvlqj/ziDpIQtyal7OB25XohMUCul
   Z/gGBmp/Y7uvb7FON9sSqgXq36E8QyeBbk8b0vQiWoaKZCmmbk+TXV1lw
   8dtyWoNQD2++sLSL51O+phipKezDzCZlD6TS721CiUOrIbsBePVwbWw5t
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="296235795"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="296235795"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 22:16:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="647046789"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="647046789"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 01 Dec 2022 22:16:02 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 1 Dec 2022 22:16:02 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 1 Dec 2022 22:16:01 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 1 Dec 2022 22:16:01 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 1 Dec 2022 22:16:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gL3uDwJPtglUl8268AIegNCWCcTRPx+WgS26WA8y5aFoix1sjWC33sAZ3XM0iu7/1ZsYl6lH7fcjFNtmJFTXu2zK60qLV0/TukQQukgNBYIjfMsdalmsjwwzRthACKI22vRFJvmUeexHJ7P8jFY/epQUbrT1DNrmWjJprSV5Wk8BtkEG/knJ/eb0eYnWUUDO7QYtQQzkSjT2aBvxaQW5niUeNQvqmPCvEMmCp07NSpJXTki/V1Xm9B2eazwSEVL/geP2/djWPjnNBHoMZ+UnssQnPbTnDubkCCD7G42TCMJn9XC2oA9jtnPm5Utx1ylRrOi2uhSmEC1Wb7LFdooxtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z/zss2t3kNL1gop58iM5gHqiFmjGGi80c7DSlfHwNtc=;
 b=VKv0zslPjx5qYgDLgCPe5eTqkNfi5WwG7iNTxJM/HVLiRm3GBzhymQpNKPeiEfAJZnEgKn+xSRCFMNbK4WlETqUv81TpitwCb/SmdPtEjmrQmG8dsM4+ajfvOtHFewY9zLs5o90Dg7DRTFI52qMW+mVNjA3bdOirLxNE0wyafrn4nqJ13NNCLQ9cLFY5YVscnJExO82UADuqFIWsJFvImUhqWuMBVm350T3poqgKm9AaV+nulrCbL9e8GL8NLZfVE6HEmEOaElu//CN353koLjWyigD65etG4uH4tzQsjysHPO2UMlsuiq4P4DPNCV8EHxLvP6oQ5DXR2+EUQeT/RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB5935.namprd11.prod.outlook.com (2603:10b6:303:18a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 06:15:59 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb%5]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 06:15:59 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>
Subject: RE: [PATCH 07/10] vfio: Refactor vfio_device open and close
Thread-Topic: [PATCH 07/10] vfio: Refactor vfio_device open and close
Thread-Index: AQHZBZUPwk5v0lRJb0Sl2t4p/mV0865aHjSA
Date:   Fri, 2 Dec 2022 06:15:59 +0000
Message-ID: <BN9PR11MB5276C2D8E5AD051D0DF0F29A8C179@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
 <20221201145535.589687-8-yi.l.liu@intel.com>
In-Reply-To: <20221201145535.589687-8-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB5935:EE_
x-ms-office365-filtering-correlation-id: 1ff8a085-7195-4856-93d3-08dad42cae7d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /L4bnf6ZOmJOawc+xX1xKt6PPNVhdRw3rswiiw7/CVVaXtvUNqbrg/9z8je+vdvb4E2++ZhS/Yar7iCdMAI6OwHXoNvKgadClmVqzvuBOI+SZMd1bMtzK0TVOGMXMbSX0zeA5iJnc+Cq05nbDm/8GHYo1mZJuAumfT2duPNmM5POggR1Ul103AqklY4QZjp5tY+dO8VxJPK+COZM+uL2mY1LM1o71EzJc6eUhRFTGImC5aMtwH8xGpbyQGV/SnuHk4ZKK45szz74b927DXVtQkipZ2S2J6uoELgsToiNTMlvagoBoiQ3VOIe7s8p7gmG9ZzdWvoW2Qy5C5WbjRn4s5AOU/TKSzU6iU+oKgCJ65fZpo7nltwAabwkSk1F4MOdo9BwUpLibFjhfv6LMbF6wdPfysvXd/JlVmGQype2E3fomvJcazBfojMM+U6lQGyLJKh9gQ/wByf8cWHpOfxhFju2k1G2Oq8tzZmGHvYc/1FLEBsDuL90HylwAbb4hpf+OBl1tzdQnplJOfvyanjCVjAr/gScs1AwqVTwKhIxtT2goxZiQebVtXMIrJHg0082VUIwHi1bp40lvsOVT3J9JxCCkgviD60o3P+N/QCOMzZ+amN7KOKGEZ3oYCIzOt/mutDoO3enteagEOv36yuFlqyizLjUPvDIZxfCp1DMdwiaCjJ6v47V8yXZY50Ja0y/a/KcEkrT1ItfiBMfSuFvaA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(346002)(396003)(376002)(366004)(451199015)(55016003)(38070700005)(33656002)(86362001)(9686003)(6506007)(110136005)(7696005)(71200400001)(82960400001)(478600001)(5660300002)(41300700001)(52536014)(316002)(8936002)(54906003)(66556008)(2906002)(64756008)(4326008)(66476007)(66946007)(8676002)(66446008)(76116006)(38100700002)(26005)(83380400001)(186003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IVkyx+C60ZxX8cZ1raSAvESUvOcIbB2cJR08vE3kEfgQ6JF3sWsW/FnjdE2q?=
 =?us-ascii?Q?7WAVUCxUrVHZnMK6Zbw7oYAX0ZwoO1ZdnWgh0mcu0bfgTMQFL/s+TM+rXelS?=
 =?us-ascii?Q?L6GRRSW+mrnztaOKztwbqGmeXJXZchce2KHB1PvYI4Yo4siajnYALK8V7cOM?=
 =?us-ascii?Q?MSdQTVGDfpohyVjDqHeQINU5Rn2XjsKkj78HWZ6zErBtGK/OXboxhfkOj2Ai?=
 =?us-ascii?Q?cziElyIYvngwmoF1cxyRogl4TZIVhM993rVKWZFVocmF0dWca9Q0Z1m5j5qk?=
 =?us-ascii?Q?ixvgg5l4QhiTHL+3HO4CzdudD7tNyXL6Qb37ldpTHUuwQG3UaHH7Vs9L3peE?=
 =?us-ascii?Q?Zh5EZCqieqK8Kgf7o46kkh7d3Sd3BQp4r1V1/qtzPfNc4T5lBotw12Vx3ifq?=
 =?us-ascii?Q?U1L5ZFXO1BpvfU+SmbIosCpitKmHMOqtJquUQQFNZlGOlZVLUqm76gqxD0bk?=
 =?us-ascii?Q?5dx/Bxt/ULZD1rdZKJxEgd+NbDA58fX8DDumobnuNkGdQ/rYJBbSzTetQ2xN?=
 =?us-ascii?Q?XwMVCpay8CJ9nKEapXjP/vzLABYuWWeFtOX2iixGMIZilHlcOVIJz+RxI6Kr?=
 =?us-ascii?Q?46ci+9hPk7mM7Gj4MjwhPzYK1KjQ3Nl8MNIkFuKbKS6c6r78K5iLLECVjxum?=
 =?us-ascii?Q?9knsz+9eGR/tmbEl9gOOeRxg5Wlcecn32ryyQ4BCPvvmVSyl05s33jZOfnug?=
 =?us-ascii?Q?IhB1Y6EPuAnB+3yzxvxvQyfReesOJs9ji7GqrOncD7JnMXtCS5nCXdH5ypNk?=
 =?us-ascii?Q?wnNOE/GRNFIARfvLuZLw+2c3vRIoE3blTpsyRHey1x10PHgPe52VrcjZvKsF?=
 =?us-ascii?Q?NBkK4czPsu01RELsl1mdxo83Q1Qr4fuJ9RvMFFBOhGhIycvzwkcJmnFEYCLW?=
 =?us-ascii?Q?+oLt+nZcQHIBWL5aXNLSpxN1IHDVflwu+L14VqZrfoYJmM4huwO6DZDvd7Lz?=
 =?us-ascii?Q?3wDcAT18x2MY1mP+jcwdEBvy80+HyUAqy7b34e41vzaAYEyF/ftVhBCQVX14?=
 =?us-ascii?Q?qScwISfWQdRmCig4zC03PLedhtzGLgwXzVIha3VhlPy/Im+s6DhtTnNFUUHz?=
 =?us-ascii?Q?AqpOJOzIjAkfaiMLdDNWYXl/qzT+DK3ehYPrfYeEKSjHvkxYQ/2vSZhsQitG?=
 =?us-ascii?Q?Zxc9lmCA9n856wzDPiHdfSLL50vQaySHrKMTpzIQl2Iy3gYI8U2gfMnAq3kM?=
 =?us-ascii?Q?YntQpLiAndN+AJVGIL/i7vU4zLOV2rCIcnlbGweVHaxZKUa2iuo9sM0d7jbp?=
 =?us-ascii?Q?Et7QHBMtxIPcM9bVEc7DFpM7A+X0szFaLhltWeVBtp/bo7FeOLKxQ38EgCB8?=
 =?us-ascii?Q?5qbc6igh65PJxa8p6og4zejT4Qghs7JXtkvygmJTAs2Op7mpzzlVwbrOltPw?=
 =?us-ascii?Q?YABmUbjm2evafrUf+5Eg7yDEugSvvlk/kPQEzrWudXr4+2XrBwtKv9HaAByX?=
 =?us-ascii?Q?tkxYQ3miGep+i/VTxUNjOWYKLfc0H353wsTPZLgjlIMLokWFiTGBC7eYiAbL?=
 =?us-ascii?Q?2Wb9m+L49xYGbUPIH5p6Ri7uJotXcH4/tBfiJbRFkJhAa7vTST51Yb9Op2rE?=
 =?us-ascii?Q?AW/+4RuZx251Iv6PggAjeSztpDKENjKkyAi4VSlH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ff8a085-7195-4856-93d3-08dad42cae7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 06:15:59.6992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IRUO5rx+h5E/UFl0wc+2QZEK3wksC10nB5n4uzinLB6vMCw+w/PD486K2myMDRWSqK4OooOQh50M+UyDkceEEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5935
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, December 1, 2022 10:56 PM
>=20
> This refactor makes the vfio_device_open() to accept device, iommufd_ctx
> pointer and kvm pointer. These parameters are generic items in today's
> group path and furute device cdev path. Caller of vfio_device_open() shou=
ld
> take care the necessary protections. e.g. the current group path need to
> hold the group_lock to ensure the iommufd_ctx and kvm pointer are valid.
>=20
> This refactor also wraps the group spefcific codes in the device open and
> close paths to be paired helpers like:
>=20
> - vfio_device_group_open/close(): call vfio_device_open/close()
> - vfio_device_group_use/unuse_iommu(): call iommufd or container
> use/unuse

this pair is container specific. iommufd vs. container is selected
in vfio_device_first_open().

> @@ -765,77 +796,56 @@ static int vfio_device_first_open(struct vfio_devic=
e
> *device)
>  	if (!try_module_get(device->dev->driver->owner))
>  		return -ENODEV;
>=20
> -	/*
> -	 * Here we pass the KVM pointer with the group under the lock.  If
> the
> -	 * device driver will use it, it must obtain a reference and release it
> -	 * during close_device.
> -	 */
> -	mutex_lock(&device->group->group_lock);
> -	if (!vfio_group_has_iommu(device->group)) {
> -		ret =3D -EINVAL;
> +	if (iommufd)
> +		ret =3D vfio_iommufd_bind(device, iommufd);

This probably should be renamed to vfio_device_iommufd_bind().

> +	else
> +		ret =3D vfio_device_group_use_iommu(device);

what about vfio_device_container_bind()?

Apart from those nits:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
