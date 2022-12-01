Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B1063E768
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 03:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiLACBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 21:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiLACBC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 21:01:02 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E528A2FC38;
        Wed, 30 Nov 2022 18:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669860061; x=1701396061;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W28JCLAjZffOwYvNJht/3iTu+M0JViwkpbFiqFgT7Tw=;
  b=D1nWJ+nQ1JIUy1ZtdhbEidXkWCoz7Nr2W0fomVOUop2pAYxeIsMMaOZC
   +URhn5JIqXIXBIvGzI8TxfGz4v4lcNgMSHs9rtcHjqHl1T//U33iv07/H
   VsrOKEXAvADUsqnyCkaPVwngHQo882H4R44wDTCuytJepOmtzyhUOTm+B
   4BgYg+EhjgWWr1byJ+UnprtXHfw17Hk5N4XLQEPQiUfKO5ZMpD4IcVQ6K
   5oCTpORnv5bZIbjnag6hTxCyY7lty9Dq238Pj9SrynmFN0gIVVulRCk5G
   /wPK0h2MV/H1Eup2KxUy041M8riwLE5frnQ8f853FtLnny5rM+Pd0wt66
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="316715971"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="316715971"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 18:01:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="769055015"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="769055015"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 30 Nov 2022 18:01:00 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 18:01:00 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 30 Nov 2022 18:00:59 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 30 Nov 2022 18:00:59 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 30 Nov 2022 18:00:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EIwHKvfAniYDRFCQlfnSayfxyShypHx1kEhkPktZlC1TDMNyinPIuFyfF1Q/Dr9BA5KfAAexU5sgXAHq7jkDd8ljtscmX5zAV03rfB5J9iBoxOfgUK33ymljZt24RwhBjpxmTzmykPMeHOZWxY0lAMO1xOnlXjEukqqTV+3WfHUbKphMeXvdWnYKSzvCw9yjz2RT4uGSOeZjxpB1u+cXZh9bJ119yXTF06HtZNcRfQ5EMsUZ3sKQU2pe+rMhfuvlEeAiM1+D2V8/kUXlQWYhlX1QELbSlP13Uu0lH91Csyr8ST8iL5tQ8lextpao8M8ULL0ilLLreWFKOEjFPNG9NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ak0lqi2oKwlo/Xv6KeTIDJI2cx1rYEhEhHSFH0NRM+o=;
 b=ndHwxYhW441qdXWnzSAQuHZKcAyUwReQhHxnCUpUrd5imWKtUkciY2oCtoIoudKSDeon22nZ0XuvY0v5rdzx8nz6zHfIQ1zgrkVs7363CSTlNbb7PXU6cXurg/d8r+6xmoUVxDNHL3vc4U/XUSJsj/3DwFancDoWUwKsoMJuhWbvLGoLLM9O695febBrHbXbESM+iaZs+MbqagkwBqFCsbaNvP8+8T5NUGblbOaWGQ+CWv+tNIgzK5Ht3uqOF2JJV6i8UVusyILeJSyKwxX3qFm8WDi11vw5aX5AyzyEAnI3dTDvFlUx6KiK2bvjhauEFbqi6pAKt7izl2rQRKDvTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB5914.namprd11.prod.outlook.com (2603:10b6:510:138::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 02:00:57 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb%5]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 02:00:57 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        ruanjinjie <ruanjinjie@huawei.com>
CC:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>
Subject: RE: [PATCH] vfio/mdev: fix possible memory leak in module init funcs
Thread-Topic: [PATCH] vfio/mdev: fix possible memory leak in module init funcs
Thread-Index: AQHY+v5PNbG9jfSk/kCdM8m0sVUH4a5YKr0AgAAtZtA=
Date:   Thu, 1 Dec 2022 02:00:57 +0000
Message-ID: <BN9PR11MB5276BC0B7E656465950E3A558C149@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221118032827.3725190-1-ruanjinjie@huawei.com>
 <20221130160622.0cf3e47d.alex.williamson@redhat.com>
In-Reply-To: <20221130160622.0cf3e47d.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB5914:EE_
x-ms-office365-filtering-correlation-id: 71e956f9-cdd1-4c19-48b1-08dad33fe30a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LJpgILStvv4ORWFwY/mKxPwRS72kTYIEopUUDP9dNXVwAk8ksib/a/WNbCEs3pvYNVep4b0RbFOwGQjaCJ699Yxi8XluNJFcYLKow2jY8Pi2aBVfJGcz9k+5oYpoqH8iXol+Yrrdrb7+7KtjGAvgxCjBPgoNvnld1cA4eS4pUY+L4n1jGbdQQZOJY9NxopjZCS7bapAPvI1FDQFJnFQjrsNAvjyNp5MNVn2N1Draoe6INMUiakYzEKAYU6XiUdG2Jj3pd+6aezsiPBm5lo3HwxNaRbahUMAVxdVTR/GIE8qTikqmDcUi6KKYQccYxn1V5g69hG8EDcL6SlOCkFdEC1fcYNft6/FyyXl0FrVs8Q6aYamAaz2zvW1Ew3jo7yVjfJXdu4Tdx8PoNmVV0GorkV8v9BQEpz86EEPvu6NriR0GOm0U2jElN97pkAJ7sFZy7HLnOIecRPPC9em75lYt3hryGaXIKICq0V7i7oxYjYxJb9IB6sU+wuzDrtyn4RGyQpdTJQTxvNnBZsf+kTQnxjkVNRcyMgiyfUjdpLmdhO5LBK4x3qFSoH04Wctb6UqZLwZLw4K2xIzt1U+GRTETlYrCjlUuJjzJnuGEstWAqX3YVko6jPPcaFX4toh8aOIpMcwwSEdZUmI+9JnrBpHRONIEBcIZJJXqfSso+dPsyRqyWxj4iBuxQKggGi9T2x+VFOQO07U2OlTpTkmKrVPKSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(396003)(376002)(366004)(346002)(451199015)(9686003)(71200400001)(122000001)(478600001)(6506007)(7696005)(82960400001)(66946007)(41300700001)(26005)(33656002)(66446008)(8676002)(64756008)(66476007)(66556008)(76116006)(4326008)(316002)(54906003)(38070700005)(110136005)(7416002)(52536014)(55016003)(86362001)(8936002)(5660300002)(186003)(38100700002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?srszEgWpSOoR4g6/xY7+blzRRjQ+qD/qFjiyB6u5IMEQrC4i7OwyZhKS6OW7?=
 =?us-ascii?Q?qhOC8nF5OYT3t2VmMDfd9mHytVWs69ecWC1U7IoDONqwEkOgUNG7QEBzr9U8?=
 =?us-ascii?Q?ju/Lg+nsfX9Lt+QmvkprGyPM70+e1LHcTNZRpUVSXkO9vDadFQ4KqKkMbHYJ?=
 =?us-ascii?Q?wGyUNDPspHZD2ZvJHzaE3HYT7llcgERQpIlr3RE4k6H4UhQEndBLZ34GuiPT?=
 =?us-ascii?Q?FtVFcED2mFlyQj95Pm/W2+X4H4jcPkSwGzzfan8H6ay/07K3P2Kf+hM5vj5t?=
 =?us-ascii?Q?c7wpQqhY/oUDvHRP8gTG3XZw8fINh1MQnTxeIu9EPgGVPGUfXIgv9B68G8Lf?=
 =?us-ascii?Q?vHVheaFOQ/memo7yN5Oy+9iHP2VMCEBPnE/DG3CL3d8g8cE4c05EplqQmeEE?=
 =?us-ascii?Q?vzvrvGaVMEec0iGuco0JSl3F/nwmUqhy+j7KmPbUuU3Gi/30b1D+dVHp19Aw?=
 =?us-ascii?Q?Elc9cdk0hgpLYVlRHOjaHNHjCvR1/ddkfQCc6n7XnYQNj/CMP9jtjzzt9hca?=
 =?us-ascii?Q?wLhhOyQLtKhIjNPJ7OL8Z7s23lQh6fDAkwb4AOADwLPXuWvmuQjfrkVVNDkC?=
 =?us-ascii?Q?uzSEbBBeR2RnTAQjL8pqauqZ6mG/ULRmeWT+DIY3fYIFILYjJkb4e5DxLroc?=
 =?us-ascii?Q?tIGMmqdzZuuku2elhS6tcUj8YnWXwTpV7YJkP6LgDIP+tIv1OBFw7SQNsDWo?=
 =?us-ascii?Q?miPaCRIROCEHVkY1pkMC0BpSWoH2qdxjEvOkhSqICySmp8iISwS0gb/JxUZd?=
 =?us-ascii?Q?0sgF9c/IRwLs9ytBQK8eZV7q+izgnsOOgUa4DrEFg/WkQz++SaEHhmSR+AxD?=
 =?us-ascii?Q?aOWjURdOANpu/79j+gSYQnH2oW+E8VPYqtCm3BvOEr+aYV6r5fd0iJUW77p2?=
 =?us-ascii?Q?xi+Fhp+xeQJ9bCYUTk+xw92E09MnNLq09eppzCbIMt2Rpz4Ne6U1e9ktC6WA?=
 =?us-ascii?Q?dB9W6L11gcRsnUSD1ikhW8WrUjZX5awNLKpG88ns9FOczyYKUAS9Xtnvm0+H?=
 =?us-ascii?Q?WgHkWZTMXzNnn7GRiVRxgyOmTNttyJpoFuGmHL4kAJOsVcjDgReZXOgt4xJJ?=
 =?us-ascii?Q?Xl2d339/cfBF9QttIL4XPC1orJwlAkKo9xtPBnUu4/wup/7KYgLHIw5SVvgZ?=
 =?us-ascii?Q?GL6k8qmHRHzNyoATrvugzVw0dWGOL5eoSerea/KZWwND/MXTpHHTEYCkvcro?=
 =?us-ascii?Q?2e1nPko4JahDaKEv47zrVAK1I77UZTaHG147jF848gP0Pgml+RW7btTDZkVN?=
 =?us-ascii?Q?w2D3VMHPvbkofz1QJZujvDeiSdxy+D5kxMOalwH1cIFDECoxsAaFeCQnJ5gT?=
 =?us-ascii?Q?IMb+ZZeOai186q9292rCDFzypvj2YnRPpo7borHoU4a1iu17YRqIFqxSd3uQ?=
 =?us-ascii?Q?hUmUd1I/cyW+uwSMM++f0hH7o3gDhDfdHNTbgHUpTcm2AdSw+cCIvahbSzAf?=
 =?us-ascii?Q?+65Fz5jUqIE8oqLZo3YuAcXDDco4k8bHMnFnhAKqcMxFu+sGGX0SWLylAwRP?=
 =?us-ascii?Q?PA9iiUtb6hROqlMD5/5Xe3/iZHXzJsZOdh4JLysTIF0YT0ipkoDj0ZTnVAfM?=
 =?us-ascii?Q?gAOodAk33V/USDylc7MxNGHGmHah8JkzEWF+tLXu?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71e956f9-cdd1-4c19-48b1-08dad33fe30a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2022 02:00:57.1693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /pebHyhWdyVD3j9baF89bcJhyViRr6WfHUxiY1lRudxIjANmu+lM+S/oMs1nrxL7HM0r/5ZsPaIWh/TH7dEkhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5914
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

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, December 1, 2022 7:06 AM
>=20
> [Cc +vfio-ap, vfio-ccw]
>=20
> On Fri, 18 Nov 2022 11:28:27 +0800
> ruanjinjie <ruanjinjie@huawei.com> wrote:
>=20
> > Inject fault while probing module, if device_register() fails,
> > but the refcount of kobject is not decreased to 0, the name
> > allocated in dev_set_name() is leaked. Fix this by calling
> > put_device(), so that name can be freed in callback function
> > kobject_cleanup().

It's not just about the name. The problem of kboject not being
released is a bigger one.

put_device() is always required no matter device_register()
succeeds or not:

* NOTE: _Never_ directly free @dev after calling this function, even
 * if it returned an error! Always use put_device() to give up the
 * reference initialized in this function instead.
 */
int device_register(struct device *dev)

> > @@ -1430,8 +1430,10 @@ static int __init mbochs_dev_init(void)
> >  	dev_set_name(&mbochs_dev, "%s", MBOCHS_NAME);
> >
> >  	ret =3D device_register(&mbochs_dev);
> > -	if (ret)
> > +	if (ret) {
> > +		put_device(&mbochs_dev);
> >  		goto err_class;
> > +	}
> >
> >  	ret =3D mdev_register_parent(&mbochs_parent, &mbochs_dev,
> &mbochs_driver,
> >  				   mbochs_mdev_types,
>=20
>=20
> vfio-ap has a similar unwind as the sample drivers, but actually makes
> an attempt to catch this ex:
>=20
> 	...
>         ret =3D device_register(&matrix_dev->device);
>         if (ret)
>                 goto matrix_reg_err;
>=20
>         ret =3D driver_register(&matrix_driver);
>         if (ret)
>                 goto matrix_drv_err;
>=20
>         return 0;
>=20
> matrix_drv_err:
>         device_unregister(&matrix_dev->device);
> matrix_reg_err:
>         put_device(&matrix_dev->device);
> 	...
>=20
> So of the vfio drivers calling device_register(), vfio-ap is the only
> one that does a put_device() if device_register() fails, but it also
> seems sketchy to call both device_unregister() and put_device() in the
> case that we exit via matrix_drv_err.
>=20
> I wonder if all of these shouldn't adopt a flow like:
>=20
> 	ret =3D device_register(&dev);
> 	if (ret)
> 		goto err1;
>=20
> 	....
>=20
> 	return 0;
>=20
> err2:
> 	device_del(&dev);
> err1:
> 	put_device(&dev);
>=20

It's kind of a mixed model.

With above unwind it's clearer to use device_initialize() and device_add() =
instead.

Otherwise what this patch does looks better IMHO:

	ret =3D device_register(&dev);
	if (ret) {
		put_device(&dev);
		goto err1;
	}

	...

	return 0;

err2:
	device_unregister(&dev);
err1:
	earlier_unwind();
