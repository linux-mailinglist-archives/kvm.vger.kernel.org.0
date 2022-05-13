Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B70525F45
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 12:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379055AbiEMJkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 05:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379059AbiEMJkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 05:40:20 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A190E2A5E9B
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 02:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652434819; x=1683970819;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HSykOpyUZzTrM9GTVoLs0W0X1WXJSBkAlKLz+9EfbzE=;
  b=YNGJ8H6Tw6NqYJ6uCQCQMwIxTmQFUqdide/ZQd8Z49EwBqOCMk8twmNa
   LLgoZ7g+G2/MBz6+NngXrHZQxz5NJjlgl+3GRzq1UP2MB1wTx9K4/PpBa
   Teg8AE7KD3p/RMJ6PJDlv6yW3FOo0hexHsIF6foVHT0QsNCF+tWzcUNSD
   N0I9A05lIoPSfJiDXPjBVNkSqrW54dCiPuFAN+MSArmDj5msl873x6gQv
   cJQZwRNh1tatAgzV11uV9w669FjsGYAaNJdAB0czuUD6IOXdp1HdtR9Sn
   JtOrjRO2QASHGg0iH+T/TIG504WGvSPWeS7lm8twWp8di/F9tC/BfBywp
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="270200137"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="270200137"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 02:40:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="896169366"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga005.fm.intel.com with ESMTP; 13 May 2022 02:40:18 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 13 May 2022 02:40:18 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 13 May 2022 02:40:17 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 13 May 2022 02:40:17 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 13 May 2022 02:40:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KqrjI44zIGP8aUnOyw3AxBWX//aFbtVc4XWKTKcpoaJmwtc01eXDk67nf5Q6sw7/H17TSrB2fRUGvozuz6UQZmiw03adRkFtQ26ZGdNrdc7dKKx2f48gc7Tj4Zl1U9OpeMLfA3GDtSNo5lt5awnj+CXjTKKy7qKx8Okuge0ogMRPnCbNcRcPiZVBS5IzDHm6pm3beuhfMsNay1di2pZ7FTYYb4qMNERnYglbuonUzh0HcjWMLw2UfSqU73LEPzEIKxbVLuoCCjDGi/1DmI/gUt8tCu62DC95mbWxcxZ0oTIq5teIIYZSOtsnXnq/vf0Y+7AovPGU7+nxlSTmouTGew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/juF/oRL+OmQfAb1FSemRoQyjQEXNWNRa+HheDZtU2g=;
 b=ikF9fpKOJ61Ln9Uu5GDD5pHd+ajitDkYK5H/6HlA1AUfVkLuDjRLE9ksistJghxCwzzJas+SPZHT9MexJFwWNO86CHWNqAJJJPQp+yd8mhdjtjA5IcU4QNwjUYVQcHpt71Ulq+JS8+X2FkpVzVjIBPAjrD3y2HO+N33VW9ukFDMPQssPj4H3CtxNQPWkXOPJq/8QGyZNYYaPvK4Tt+wuDxNL1nK9pwf/pUmTM9zCV3rsutR18vYtrOoQnKpnl7l7btNONdNOJp8GUchCVUOyUvH0JuNpK3nzZxipqlMWorRKV4mKIc+AYYgV2IocoEXrbgdxieesQi7Y0h6OeuVvfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Fri, 13 May
 2022 09:40:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5250.013; Fri, 13 May 2022
 09:40:16 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: RE: [PATCH 3/6] vfio: Split up vfio_group_get_device_fd()
Thread-Topic: [PATCH 3/6] vfio: Split up vfio_group_get_device_fd()
Thread-Index: AQHYYN/WqbVwieRckkqQDCSukfDbna0cmHtA
Date:   Fri, 13 May 2022 09:40:16 +0000
Message-ID: <BN9PR11MB52768FA02FD4208AAAF6CDC68CCA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
 <3-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
In-Reply-To: <3-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 126df787-c959-49f5-107b-08da34c4960f
x-ms-traffictypediagnostic: MN0PR11MB6059:EE_
x-microsoft-antispam-prvs: <MN0PR11MB6059DF8A3C7F023AD2B75AE68CCA9@MN0PR11MB6059.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Geqky55yGDR6BgIpyei57E742TEq+xsCmqrRORobLLI7f9jMAFAKZkdlEgAHMBhtp8wgsNqzIHq4EWmSKEPaym7HN0L1gVez52inTQT5adAgsG/ykgZZ7LpImiD+fab9Mo4QF8eT7cc9/DrPrOwHNDhRUHBi7EO+aE9purFpT7aNN+8HN4RxAl2S2zV4T8iou+COC0MBPh4/eQTf4spwU90TeFjlyQUD5v7zkyZ5Qv57roScpXqqfpDDdU1NbToM0Ak1LqCiZXCZZWpeortMAnNa/2rR+oWqL6nqJBa4r3b7tAPIzcXjNe7kMx8mOKetji1LmrszAP9pKptw6h6yS77rh3fpG1v0gzSOjE/NSG232gN72gRyMx5GrKnMp1IeDtNoUNZ/VYiWAAtDiFDsX7w9w6nmCvxb7hE40mry3+hEXVwW/gLT4J6nXA5tqCoN83xZX0Gp0iDTXB5M7dMFSGGPQLkuLgjFYUXJM3tSZBQWD1KhlV93mT73cJg47DplOhr64g/Jj8R7I2TFREwmA6TpNbHcU6g6V1nyElJCDxJ/kVifJAT1PrDPYnYe4UUSSXQ/Xk46Ex/tqXtpfJLwuVr8e8aAr/oOaqoqw8vWuR0U7NesGW4n1X+K749pRRRSDkdkSJ7CfDI4RoKQnp+p6R3i7h4SrCGF+nIllxTBkiMGsBYv/W+oRRw30RME2i4sLafYsKdgbibD1LuPYqeBkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52536014)(8676002)(8936002)(5660300002)(66446008)(66556008)(66476007)(33656002)(38070700005)(38100700002)(508600001)(64756008)(122000001)(55016003)(76116006)(4326008)(66946007)(71200400001)(86362001)(26005)(82960400001)(9686003)(83380400001)(4744005)(6506007)(186003)(316002)(2906002)(110136005)(54906003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?04N+bkiup9swsEjn5I60kS+F3yifRFzC/mAvDtewHSmc61qbj+U8pn6glr8h?=
 =?us-ascii?Q?e/7kj95olifabCaziIsal4378+lla07+sxmz14UN5Ivh5xyxkGFwUN1cyxtN?=
 =?us-ascii?Q?UOa8QiB552RhvY/To/cCO3gJJwz5MMHeeqkPovLHu8CwxubXgslRf007QTd0?=
 =?us-ascii?Q?i41q6KG0vE5SYFjOanP3NdG/SE+bs2xVL9wCbbNDci0g/rPX0rl9w0EHozm9?=
 =?us-ascii?Q?10bqdcZ+UOMZF2E6m5BtDioZYQQd/wIdoQMXLSkwqpDXY2+FgD5w5w5lGkYV?=
 =?us-ascii?Q?uN8lAvEHmEjE/zn6ZxZEGlijbH4xSvj38A+07FJkkZH+RWvp9UdWZG8Nr4ta?=
 =?us-ascii?Q?QNu3dU0vbO+v14duzimFikXhV6X5Cy9crqtBi05z4BnXDMmatKSCyy2xNRwF?=
 =?us-ascii?Q?60yG9DD0eBYIkzpbt5nOIBJlI89yTkXbi85U2gf0DEc6pGMmpnPRinkhSjZq?=
 =?us-ascii?Q?QD4QXO8iocVB5fgp2l60SNsjM/V6DKSAkNKk4jCtPT6nguOBh2gOUU5SngOO?=
 =?us-ascii?Q?YULKkZfPJsDqzNDkWki/FtNUELBhd9KsJrMRFkH9365tH+s9G5l8ix7rdnLq?=
 =?us-ascii?Q?P462CjGaIlKyHKThBhr35vJReHXWWhEZGo8zGSBMaHqKludubT7ttGthWD07?=
 =?us-ascii?Q?utZV+2cfUsL4JurMTq3sKqYJuxe6SjmLbw0Ti/QcfUlCULCau0fIuhKqk75u?=
 =?us-ascii?Q?HpXgeD6Gdgtp9U2jQFib5Q7yMj5WcpVCwMCTpfWIrVmNPceGLhFEm9eAkHGK?=
 =?us-ascii?Q?Tfx5BIIUscyVr6JOHGhQOv61iPVNoTfOcrDWQ7YyA23UZTwYvOyHetPCkAu8?=
 =?us-ascii?Q?zs1XhQNZg10+JBU/mCzP3Ysj6LOB1183cSyE2UVXsv6v4/hI9fOo9HQMntWC?=
 =?us-ascii?Q?E/cfDyl5g2OqJmQbaDB8SuttrRF+T3nxtu1Aabqlq5z+o2Hx6e3vQKyrrf/8?=
 =?us-ascii?Q?QK6p9mQWBypoyJQvZfkVpV4XCrskkap2PU3tEz1VaetJrMhQ1zWXxw6lMSbi?=
 =?us-ascii?Q?OQXyJdLxVfhMp60GUnAP6rXhV9RHXt7NtOU75ldJyNUaAM5ZBMEv/hGaWVYB?=
 =?us-ascii?Q?HArojYzjHhmr7y8rNc6awoR9g1lNz16UQi9qkpRXrP5Eit2xa/FXmKlHABwa?=
 =?us-ascii?Q?NuIZWAj+YDoJP6141hsesymYuYHkDgD/oUVpQ2hXei03ZZXWIi0Pa8G6TzgF?=
 =?us-ascii?Q?YEAGonHob7VLZp7/QM69LWvTNgtMsnmWaEDB+XBeszQpogBHyXFDsYTvM4Z2?=
 =?us-ascii?Q?vznfnNs8ozLqxz+9/EdyUOuJAtp+4gFztwgbYfmx5waJr6+Wb2L0DsGUgXoH?=
 =?us-ascii?Q?40at7I2uhNl/l+k+G6+1efsd7t1Mfrh4RnaD079EIZpfbp5vmXi10Ts4Q75c?=
 =?us-ascii?Q?1X7FUeKn1vAtck8uCS1SHfX6u0IfjPg5VAFblcu3GDUCiclztqYiwHcDxk4m?=
 =?us-ascii?Q?uajycE3WCqTx4KZvU9OI3MjoJAA6uphdWe+93VA/PF0SgiKmxLU4TA7X8nQC?=
 =?us-ascii?Q?UXa16m6KEMRc3twlfF08YRGx0rV+THWj9zTF+EAHo7j8yl4HlDjyVfvRsfs5?=
 =?us-ascii?Q?aOJMeTrsteCtrHoZrf8uMbT3pEn0u6bdomEF3YdYTyoIhiuxJeSU6Al3TSDX?=
 =?us-ascii?Q?vn8UgS6CykKy9uw4QRcKc6YpnPQxLOglNlKVCZ4j6FMEb+QxlDA2DwwfJ9T2?=
 =?us-ascii?Q?dDlcSf+xllqmdwrABRFVzmeO9OiEzegTVxL/BAnGG/aq9zU3tftlJxajypBQ?=
 =?us-ascii?Q?Ip3xGn5QbA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 126df787-c959-49f5-107b-08da34c4960f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2022 09:40:16.1995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tn2W9JoFiq5dFfUKItkN9xwuj7jGNU7yDhcnh7GX4TEVWZDDdnsZ5LLb5UQhZHCx/KpQqI0KJodKxKRYeBf32A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6059
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, May 6, 2022 8:25 AM
>=20
> The split follows the pairing with the destroy functions:
>=20
>  - vfio_group_get_device_fd() destroyed by close()
>=20
>  - vfio_device_open() destroyed by vfio_device_fops_release()
>=20
>  - vfio_device_assign_container() destroyed by
>    vfio_group_try_dissolve_container()
>=20
> The next patch will put a lock around vfio_device_assign_container().
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> -	if (group->type =3D=3D VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
> -		return -EPERM;
> +	if (group->type =3D=3D VFIO_NO_IOMMU) {
> +		if (!capable(CAP_SYS_RAWIO))
> +			return -EPERM;
> +		dev_warn(device->dev,
> +			 "vfio-noiommu device opened by user (%s:%d)\n",
> +			 current->comm, task_pid_nr(current));
> +	}

after this move is 'opened' the right status? Probably clearer to
say that the user is attempting to open a vfio-noiommu device
at this point...
