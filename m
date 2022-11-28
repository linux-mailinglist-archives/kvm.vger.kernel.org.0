Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF1C63A29C
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 09:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiK1IRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 03:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiK1IRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 03:17:39 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F313ACC6
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 00:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669623453; x=1701159453;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TSkO4BT8X1i+ab+CNVIjcGHs9msu1zvCLPZYT/VLXhc=;
  b=aPbroL/UXCoh6K3tnErwuKrYpJSa/eg7syALAXBmnAfox02lqhqC/NUo
   1QTT10mLeXly0FoGOMycTVtx8X/N7D+5MAMbgbwe57VR6Y8dNeTCYXO+s
   NvPPAFb1OR5iR7aq4GZOFp69ijr8hFnmgG5O0Q80aBglZFoRSpCO/RQtv
   ENAZp5jlrFYLXe1UQx7mloN3m01iHUGfk/2BVrFGQWY76beTt0yi1MtCq
   tx8PTgLd1SCCofePELIVcKxyLXC8dmhKfq+M5z6dcZiPinv9y9Y3kJvKU
   k63Kkcc2Ia49eZAUG+jJ8svhaM6z852Gl5uZ+C+27cJJ8ceK5QTsU2ZTq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="314810505"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="314810505"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 00:17:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="767953960"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="767953960"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 28 Nov 2022 00:17:32 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 00:17:32 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 00:17:30 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 00:17:30 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 00:17:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mNvMuZsJpt9GBJHbdJ7Xv+wK9wfEbizA5pg3Yrg6bzXRmEnurcYFz3N8VJgENtIyCNdc9rsyqEMg5EzxMcrYBhMXo0zOxwsUZ7IV4G6MKsPO28ViCBlI2E8Z9Vi6ADLDtFla2VAyz44AVT0zrBd8fd8CoRiyqwuhKYBuPyasMy1AOuWLwLwEi+0/akj+BfcrVo3+EC0t3RXyeF4rdW12sMNgVKGNi15GYoVmQF+kVSmposTGBNmjdZM1rabWYNZjWaCv/bpaf9uWUf9eCDyCve0I07n5BPYHzjbPeZ1n/nOqJ5/ZjjHgYl9fkZQY7saglYeEmJLGb5QTXfr60Har8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jLfZROYNabmjouDLFf6JFYU9YZMOGHjNkONDSh0TXbI=;
 b=f+gL3xsOijnmLrm1OXBY77yc3ZbO1+Cws60PJWCielCpkruuiXKWk816Vg9G9WqAG5GEdka51tO2YSC7k4t7rMOU8VxJWRBoDl/OzFjV25wkVKJwbC2ud67herg9++82GrgnjOw7e5Lq9HpUaf/AfOY8dASefSXDPM8Cz6cRSFByJ0gUFF68Iq37XxgPLNz5sYAdLZjxnjw+93UQxOU055iZWpJIujJLYzgaPPnM/9l1KF0f+xdwGcxEfj5FHyly1Ddb2rwfcb+BnDEvhQNLcSZip8+ib0LetCAIpAuk25M2VzGFU9ZKpSYOFDxOi6kUzfwBDadW1+nGCKJ9WliM0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB6501.namprd11.prod.outlook.com (2603:10b6:8:88::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.21; Mon, 28 Nov 2022 08:17:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde%9]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 08:17:28 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC v2 05/11] vfio: Make vfio_device_open() group agnostic
Thread-Topic: [RFC v2 05/11] vfio: Make vfio_device_open() group agnostic
Thread-Index: AQHZAAAcTYVOEc01f0GRA+VMy1TxV65UAjpA
Date:   Mon, 28 Nov 2022 08:17:28 +0000
Message-ID: <BN9PR11MB5276CD3944B24228753883418C139@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-6-yi.l.liu@intel.com>
In-Reply-To: <20221124122702.26507-6-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB6501:EE_
x-ms-office365-filtering-correlation-id: 6354e197-f8cf-4d1f-f7e2-08dad118fd51
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UN6OLd956EFL4KJAh+GLRbAR/r9CCOAsD5RJQIjzDkORMsb38SenWuhIpHJPXr3IgRRZ8COFVgYpRwhnWn070klhzBXxtNKpLs5iwYC9d+JRZBHUiXk2uk8GJumQqXaHJ/Q3WjbitVz4OwEU3Fa8eh97c9HaOrzCKU+yeB1cNxNdmbwYL6L5a1UVHnYHH/fdLZc8355U9qnnqpqIEIN5LIPNQHOALfe+tM+Bxk0HAla4NtaFAmVsoM0OGUIunfdDbVvY3qOtmBl/MeMrYqc6B/yXxE+tMujZlk6TnOVRGCGT/zPQBjeYfNP9HCDjPdwkxzAJ49vawY7bnB/sziex8TmkGABwFF3UAwTNc8k4bzXHG5EzmO86AiscL95IRu95hofgr+TjZLO6sDRrcJZ3YKTmd1ytnPhdH8t0W2kg0VQqUY2V2nRHjK0bj0cIp1Op9CPy+umCOEs3xQpfeDRkU8bMicDbJIzGMJMEC/HqQAyjpA0SrWRCaAz20s9IRJeONUDb1HD+4Rwvtwblne2OoPhHYYs9s5eSgQwt693cb4hKLjNoTvjio5go+tRuoIsGLVSzEVfZWhvsk8bgxLIxmp2uIIheT+215W9A2cY+N7XX6AWdVxgsoSTO+XRz4RZ4H/R/FukGwZTTVXz2A+ONNHFaLkZ9/neYRzYildah2XMTdFlrxMyOLeP91Z5S48sTmIFqt3jL9NVMGw9F6ABpdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(39860400002)(366004)(451199015)(9686003)(7696005)(83380400001)(26005)(2906002)(6506007)(478600001)(86362001)(38100700002)(52536014)(5660300002)(54906003)(110136005)(316002)(122000001)(71200400001)(82960400001)(186003)(66556008)(64756008)(66946007)(66446008)(8936002)(66476007)(76116006)(8676002)(41300700001)(4326008)(55016003)(33656002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4A5lmHF6soGTzkO+MV//aK4cahWr9+q0Slx4zJ1s2g0rNquC6WPMBX2VvFnM?=
 =?us-ascii?Q?jp4h54TeaFoeajmqu48fMUbj+Sv0CxxIFzrlecfGROI09KugDfXn2i7vok6I?=
 =?us-ascii?Q?pAwMDamMmtJ4TMNewA7VnARv1LKVFR21s1U7RZAe2G1mMOA7aTAw8xJw8hYZ?=
 =?us-ascii?Q?Wlmx+hGyRaN1VwhBpC9MRS8FWV8iu2EdOQZh1uunw4cVbSxZf32FLZ0Hflpb?=
 =?us-ascii?Q?P9Bi9Vm2agI1NdZXcRFHjVUwmK3hgh7TJPHr+q8+FYJhIQ+W0u50z+uc0H0a?=
 =?us-ascii?Q?hhtf+CS/sjzzp0K7vbTVK6C81gIX6VqkaQ0uK5WNjneDcA1jmjn3H1kcaqtd?=
 =?us-ascii?Q?rUqWX0rPWZRuValPP7j9DmSomb9YRYSU96QyiHwQ3gkloens6Jho14Mfz6f6?=
 =?us-ascii?Q?Z6kt75Bh31CNR3gcdbO34oUefDy+EqR8I6jHC4hoMscpxYAgCEgI4h8/w4np?=
 =?us-ascii?Q?Zw6tnT/+w0io+qIC2mGXC71KI9r3tuR1fBoEhlHdrYd310Hb8M7TzQ03XLXk?=
 =?us-ascii?Q?/GcpvfuYqjzPQ0HT15HRE54bxFhYL80OXf9uwvkCCbJQ/vcysnVLTbwtbc+s?=
 =?us-ascii?Q?p4I7tu2IpoPgDbUdzOEAGmM8lEVENdF1JHPVpsBrEtDlst61U7xu5kj4X8K2?=
 =?us-ascii?Q?fgxKK5+GaCOgn9BNHc82hxbcBiJn8q505pnEkOjVLMvTLEv5MdQnD/Cmbsgm?=
 =?us-ascii?Q?2Hm5Hs+ikhyngrFIJVW1gb/t9ViO+CLbYUUAFC+KsyECM+ribzMmjw/yncN9?=
 =?us-ascii?Q?gnpcEXUirKGaf5fv17/kvNoWu1zZ8uBF+gLi9eUp0M08YWfJdVclcV7GZwSk?=
 =?us-ascii?Q?LrPx4OP0768SOvFi6SpBGZ2h8bF9+oKd+xxh783xhSUT2ZL1YjiZgKdILIm7?=
 =?us-ascii?Q?RCt4fHcRzjqAUFYmPDn8mWXZVzjhjjIGPT1C4cCb4U2hX61xdFQiVI1FwRnk?=
 =?us-ascii?Q?7cqXR0Jy1fcPSYczBSi6Fee2xNDgsIV8cRtlo1rovYTE0O14Jvh4vJzCvyVp?=
 =?us-ascii?Q?AA9WuUi2WcqznT3fne6UVvebhPecMM3BGe164/z11txTfyOG+7xTgvSdW/1i?=
 =?us-ascii?Q?zOJ0GgWNdoY4in0O2aYcSkEl6xWAVmSoATcLLJiTLkrK7snw0ogxIVlM/X2M?=
 =?us-ascii?Q?5MOcqHD0Y3dbOCY3q48Z8UVfY2p7WT/cE0h2CfAY7OPNJtBMrqcfZgJ+7r3P?=
 =?us-ascii?Q?J7ljCVCAxQiuUVy4mrXENUvIlLzPfdxa+RHNILH+eZHJkiVu46JIzX572bMS?=
 =?us-ascii?Q?qlujC1yZBNxCOenHu6HzPqBZPJuUBzwZM88b6M3cxspgfstqB6VHWO7hkGCp?=
 =?us-ascii?Q?pZZHJ3fy4WcFyOa1BoAzkVcWmJIgXfIuL13SCVeY2C3XXf6xgR+ECLXmCR7T?=
 =?us-ascii?Q?BoR9vPk3iUhPn6d6NYUY4TI3Ib8AYxA93L3bDTbrrT9gupIzIHeu4ItZg4jh?=
 =?us-ascii?Q?29JmnglQ01RgYQCve5AVuTV6lcDpHj0zB2YHXRXi7RvZhhUYB2frokIDrYAH?=
 =?us-ascii?Q?EvfaMiEIItZC9LnruhxoxjYJh7bV1Idp2gpnC9gwWEKwxXgbiatlS/1Utqxk?=
 =?us-ascii?Q?FiJ9E13E0T9vJyaVXP7lYhDgw6c9t4ux7kkA2tjK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6354e197-f8cf-4d1f-f7e2-08dad118fd51
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 08:17:28.5305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5qiEMJQ46XBkY0N0oQVx8O0Aqxgq0LkvQNiImyFZU26PH/f5B8l0ykoBwVEjIaxtGqQFAo4XnPkzlF3ZBaOlpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6501
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, November 24, 2022 8:27 PM
>=20
> This prepares for moving group specific code to separate file.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio_main.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index edcfa8a61096..fcb9f778fc9b 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -878,9 +878,6 @@ static struct file *vfio_device_open(struct vfio_devi=
ce
> *device)
>  	 */
>  	filep->f_mode |=3D (FMODE_PREAD | FMODE_PWRITE);
>=20
> -	if (device->group->type =3D=3D VFIO_NO_IOMMU)
> -		dev_warn(device->dev, "vfio-noiommu device opened by
> user "
> -			 "(%s:%d)\n", current->comm, task_pid_nr(current));
>  	/*
>  	 * On success the ref of device is moved to the file and
>  	 * put in vfio_device_fops_release()
> @@ -927,6 +924,10 @@ static int vfio_group_ioctl_get_device_fd(struct
> vfio_group *group,
>  		goto err_put_fdno;
>  	}
>=20
> +	if (group->type =3D=3D VFIO_NO_IOMMU)
> +		dev_warn(device->dev, "vfio-noiommu device opened by
> user "
> +			 "(%s:%d)\n", current->comm, task_pid_nr(current));
> +
>  	fd_install(fdno, filep);
>  	return fdno;
>=20

Do we want to support no-iommu mode in future cdev path?

If yes keeping the check in vfio_device_open() makes more sense. Just
replace direct device->group reference with a helper e.g.:

	vfio_device_group_noiommu()
