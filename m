Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1656B340C
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 03:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjCJCKn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 21:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjCJCKl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 21:10:41 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B790FE0B6;
        Thu,  9 Mar 2023 18:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678414240; x=1709950240;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l0FSaRXz6Iw84RUioUxY+hV77JUVVxOYoTqwg7PnKNs=;
  b=lWi/kG4xrkZlWS2GFoBfMJawL27MXLSd0YZnJ+5QWCJwW9fYHGc7ofgs
   qIciR5qcilmSkkU5ca5Hy3ffNCuwxPkFCamIAHWGfkOAXRGbWrtRZ8ZBA
   Io8HCd6hOFhg6yckmlWyAwDmYClrs6lmXQn+r+nIM8EbbMOjveI1ylXWJ
   q08XsVvguOacWM7xOu2Lj4cJN7hRnvSzc3B84sjetFBXfUr1cW8moSHmt
   8l5AjY3BZ1wMcJmqKIGTw/3bmGqjPPg2RRaeLSbIn2sBZItKBd3yHdNEc
   D5c8dviGcrvRYC2yPvD2r501Z6OjRU7m753GGjHaAqEn/1yg/YaYIuspl
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="334101110"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="334101110"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 18:10:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="707847101"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="707847101"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 09 Mar 2023 18:10:38 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 18:10:38 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 18:10:38 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 9 Mar 2023 18:10:38 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 9 Mar 2023 18:10:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KzMDEXeeoADmpCVgaL71i/ubEDef5qQMTqmY4AgVGBgeLNvoUr57/Xi7ridNZO+d5/y6K+mGpUzZNkkybs718nbyVrywNMbVdasXbAsAkV0WtGq2x7a8KXNltNp4gzthunwcRchXncltfk36baHSqJOPNaWnoKK52tXhtOtu6AC/HIRWPD96RP5YO7iGPxgjgyUXlQ5dtPcq5E0JQe2SXG0rO7ICr2icKoIRPz5/wOm2FYCXVaCKAWRdCIzYrOT7Gd6lX34tv5zcZl5R/sOBgZ1JM/A0jQ73avo/3PH0bjaduQoqoHax/83bQppNFV8IrwEFTYqhh9rsDpr2ddh4eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7Uo92lkcKAfa0+jxH6ULkxAs53LATvrzHIKL+pqBKg=;
 b=BqofD9IibXP693kDN6UJyknSaEN9g7f31vgrfwDdyGvMfbdiT2EkusFp8Jru8pTqALKf4sk092XDu+FBgU4D/ZmUbdcEn2b8IapjKJOCfbKMsAxlaA1ybCLZgECXdynK2/nounVTet2u4CVePh7ioKYOkDOMNFvgnpSP+M0gumqytCckQP23/2tDoibsPDouBfSsztgHUMIfaIzSwY5r7tLKMsD29nATau+qy/ko7mTALB6U3edrdzS+7hQQqtnE4FqHsA6iyq1u+JerXKiDD6pE3go0WQF0Wa2AOASW1FKids/jUXE+IdepE/JwEEaKdkjxPr36FdlOpdDETAfJsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB7778.namprd11.prod.outlook.com (2603:10b6:930:76::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 02:10:35 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 02:10:33 +0000
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
Subject: RE: [PATCH v1 4/5] Samples/mdev: Uses the vfio emulated iommufd ops
 set in the mdev sample drivers
Thread-Topic: [PATCH v1 4/5] Samples/mdev: Uses the vfio emulated iommufd ops
 set in the mdev sample drivers
Thread-Index: AQHZUb/WBbNwEUi+6EGM5Z4iWmAH/a7zRwDA
Date:   Fri, 10 Mar 2023 02:10:33 +0000
Message-ID: <BN9PR11MB5276C37386EC3A591A50603B8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-5-yi.l.liu@intel.com>
In-Reply-To: <20230308131340.459224-5-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB7778:EE_
x-ms-office365-filtering-correlation-id: 3c4a482b-8a6e-4b7d-85ec-08db210ca140
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CmK/XFwA1Estx9yZu6LVyAwk6T+kXu6fQImI6FjEe0ejq/ok00LEPmICrB7lpuf7VVTzWV8jOc9PE4lD0ezwPx09O/AvcIKxBH0w7HjId2wF4t3xMQtFfJ1Icm7APIeuP2cEDq13iUhMQaxbuEzPhCH3Bafq+QVOVhzEG6yUV8nN2aqDu+zqsLY6b8Rj4O1+BObZrPK7/qh/D0azgJqk/TE+4TvRTWsbkNBsjxPtnXru3xMVBTKrvOjKZGtgwNImUtgEzC63uJHNJbEA/PyjxcpwSpdivbCQZxlK+tkpAcefXtNZs+8yzjAmuipLfIzDj0ERFGpCEd0urjS0t/kQY0qLECjLDFpu7Ba5eTcJRsdDeukzbHfdRRhZxsAbML1lM8S9iLts3Ccc/QoVImKpdK1IqTpp8pPEhgmKVuu4xIWiX8WbACvY4uulHPyTwAPo/Gm0V1rgAm8Z6Zt5/VGfLrwxHJSYBLlyQIj0n9oDJPJOUdfLn1UCwq073D+Xu83fG77kfD8RR0TBXIttv9WKxSZ7WRHmG3eprvCsSQWAKfQgZ3LWb4/WCyZjInGTKHOW64LTog17iaZYnX0Da8YuXqXczr2kvbkA+i4Ejt1vhYsmdsqo2lj64LcmjONIUp4rwZeKneLrG1tnQWnHJhJlpMSnA04i8jHbbwAh1xyOY6pOeDrhk1R49nC+qyTyRM3RbXdbAYIw6Rn4lS/zwA2zpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(376002)(39860400002)(366004)(346002)(451199018)(38070700005)(33656002)(55016003)(86362001)(478600001)(7696005)(71200400001)(66556008)(66476007)(66446008)(64756008)(8676002)(66946007)(76116006)(110136005)(54906003)(186003)(316002)(9686003)(6506007)(26005)(2906002)(7416002)(4744005)(38100700002)(82960400001)(122000001)(52536014)(8936002)(4326008)(41300700001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?r0MKF+GCPxJYCJCSy9vPtJ+RUmlboIyTBw8Vatca7DaDhg5zlIpqrmTfPH+4?=
 =?us-ascii?Q?ZYzy7tDudVgPjYuZlkQqFcgL7xE5PTcZ8igbp/S+/x5LGeSXIIe15nLbxW6A?=
 =?us-ascii?Q?t6KfTBE8zMOfx+FnTBoEHmVbZw8zIko3r5wSzFj3V75SyCTuZT7emMAjMbPC?=
 =?us-ascii?Q?L/X/K9njJv82nWZi5NH3kadI9r/GHlU+6MVwCrx1E+wUSd99OBoWNeRNiTUz?=
 =?us-ascii?Q?3q+QYonR2VYe8bmi1DOAp24ThZWi8sbiAjMH+t+NB1jgBd7HbR5dsQw482Ev?=
 =?us-ascii?Q?OP5acsaWgDWitOjRzDeSQsd8yFyoHiM8ufMYDCT6muAFNIkNmIlzRcFWOSv/?=
 =?us-ascii?Q?9aGAvH1TJMcnKuFDs5a7OzBMt18doKg8ptYZbEyCmiHwF5MKQErt0egmox9H?=
 =?us-ascii?Q?iG6RS7AJw2Aiax1Y1GoeQUC8GvuhLcO4vzEJU4WDu9gj7ZftbCzoSJd2kdnK?=
 =?us-ascii?Q?G8tcmRExhf9MAySS21zx9vge34XiJ19jOLt8YFvN4UjX3rmlGBfhgqaM+2xb?=
 =?us-ascii?Q?N2oh7CImRIyd8No/SVIU3vu+iBz1h2J7atf6ei1riPwCsnJE99HNS/K3S9K2?=
 =?us-ascii?Q?clPuPUfwFOYpWtZ6c2fQdOAAHc4mZQljOqo7XZKn7Q1QlNyyWa+QkeodFpJD?=
 =?us-ascii?Q?VK4RQrPueKBlHgF4paH/TYYrMBXuv/Z3hLCuPxVcbmSNXZBVnQX5t7/1Mwwi?=
 =?us-ascii?Q?2ihK0rGdrfZT6f8QYa2rM8rdDM7ibpZW4jT5CSdyA54Am1qqbMZYhOwNwb3V?=
 =?us-ascii?Q?oP3JKOG3i8ZNOidHuohseLzwD370lYExFSOFJlV1Jg3s1IbJVuTRbx+No91H?=
 =?us-ascii?Q?7Lkcv4CHkqKqVzKAS2ibefWsbaABi3pjjN4/bqzlRzstM2PYIDT19KXrNSdK?=
 =?us-ascii?Q?XJb4q+IET0QRpz8QFRuf5K7jcP4qsPiO9suBmsXtNKGIO8/1q4xxk4cGBvVy?=
 =?us-ascii?Q?Y8KwBWWy6e51dbL2NigAyFekx29g1Y8Zp8Nc2nK0ATwUY8KgWhE5f2qneVLn?=
 =?us-ascii?Q?rnFpNqu0Nng5W1IPVlW6LoiwuRUFuNEyPjWYLdR72o0muS6pidnmL98seb+R?=
 =?us-ascii?Q?8JcZkZQkGw+2hd0Qk9hU2/tOWTbP2+aJ2Q+J2YRKw722SWsQpPN6jecBh0FT?=
 =?us-ascii?Q?fFPLOWlFkzJ6hG/5ClZElSpAjDAFl3RkxuWpdEn2YjXTzoHLq1w4dGbcFu3M?=
 =?us-ascii?Q?fduyTy8v9DZSZpJnOUf1QpXWq4absAKiyg1W2bqIINwDQKA4V3ZWjVOGVOI7?=
 =?us-ascii?Q?BHkHlgp0S4VI3+A0FQGBcUoUIwO+yxZVKMIHJ/5Tj2XoX7I8MCKeXNiSMMcS?=
 =?us-ascii?Q?KObi6Nglhpy0wsxfqbFVb1ccSrSuXAUZTv2a7AcKSXRTlQFMIyDDBiQKSRSI?=
 =?us-ascii?Q?eLJBksIl27gTMkQgIMAym9QMv7uHlvGhjdrotFpWdnUyIM2iJN0dn4BzlhUf?=
 =?us-ascii?Q?5lWxX8m+J66hVtI+50JO5QxgIOcpcgkbkVup9JaR23p5NKKrO6LlBDpyX09s?=
 =?us-ascii?Q?BsQMTJBfd6O/JLAC+xcqVeNQZxWtzjNbKyuS3vy5MCacn83ip3rIHVgQl2o7?=
 =?us-ascii?Q?FJdxut/z1J3xQR1EB4lb5WM6hEgEaVycZYpX9/vl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c4a482b-8a6e-4b7d-85ec-08db210ca140
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 02:10:33.1116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3ABtLtd+OgvDCu/u2ciXzHopkFkra49fRLRK6Py6yLYzHwbf9VxmNw+AHo4g9reK5rUX0tQZcSTXO3+sulO8hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7778
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
> Sent: Wednesday, March 8, 2023 9:14 PM
>=20
> @@ -32,12 +32,8 @@ int vfio_iommufd_bind(struct vfio_device *vdev,
> struct iommufd_ctx *ictx)
>  		return 0;
>  	}
>=20
> -	/*
> -	 * If the driver doesn't provide this op then it means the device does
> -	 * not do DMA at all. So nothing to do.
> -	 */
> -	if (!vdev->ops->bind_iommufd)
> -		return 0;
> +	if (WARN_ON(!vdev->ops->bind_iommufd))
> +		return -ENODEV;
>=20

this is not required given next patch adds the WARN_ON() at device
registration.

let's just remove the check (together in next patch).
