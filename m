Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DDC661EDA
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 07:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbjAIGyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 01:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjAIGyf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 01:54:35 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0525CFD00
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 22:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673247274; x=1704783274;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d01EJKF+MArvpcdN83TTo7ZXrQ2gTSt82q6tiO1nsEQ=;
  b=iC0IxuNjVJbrpzvzzQCSO+zO0gHucH4Zi6vGkWMgTSkDHji+P/oDfHnr
   4gLVUkctGQjUI4lpXNuqZhIaNzKBwffGgGRi9xEZud2fgmpVa2WIzR+kk
   Cs0pXra4mZyJgcrqRlpdifTRQykNXHv56yktciozXYjwOJ2utEQNUIIa9
   myl6oPMMS2wobwHQWxU2MFa5F3A6BX7HaknMX/tHajfysyi0T8hDvhrkQ
   p8/Atk1+05kzlJg/K1I0SP7tzbm87VDxfwLnF8GwXwtcLP5vYsKIjtxfN
   qBFANfWVf25ZaX15T3D0U1Wq1Jko0LoLxRyB4g8TpjTiWKOgsNceWN4mM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="302506326"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="302506326"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 22:54:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="658488295"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="658488295"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 08 Jan 2023 22:54:33 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 8 Jan 2023 22:54:32 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 8 Jan 2023 22:54:32 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 8 Jan 2023 22:54:32 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 8 Jan 2023 22:54:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iyofhlLGMxyJm2kL0+zXVwrRrm0GYIncc0KjoC+hoyN7gUSjOvm4JC3+DTxfM3EaGsF/aYuydK/b8xU1TaNC/KETAe124dB+aPLun7TNyARBJrIsqsUo6y97ADYx/+nuZPiQ+sN3c2Z/GUhXIBMKPeXGqzEMKD28mhuPXitKKrWDe+40KP0QDK6Y4boyqb6A3YevE5lY3vjL8cDWVbDlKWP0QHIZASa3NUVIxlIibEtzbv7YHzHrep33l+EztNZ/9fBCVM5bQVuS/k7nlyyJx4UhOaYk0Aleif6MAMCya8ig91S2MPiksv1spX7OA9bbaq189LUGgA9OveZiLroG1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3J83KbH75ScCokx3DLMAovEm+JIFuph4BPGwr2WlIfc=;
 b=gglrqZ7BAJIbDMD5FEZZXDdNo7LwIT1wDbxY6zzQ/dqH2EAHtlUz0ploijO5jCdIngN6im/nl01w6GyZFfc3crM6aIff6LEgXMbxRLBdQwj1BoYHrypjelBkm+ZM3nwFUnI8kKMZmIJM68t/q0zFFjlNaZXhfJwk9G/eMROQ7RNh/7bRxh9OvQABvnCOxkaoBerJEILyBhZqeI3f6b6uIE0kIexwGm5ud/Ck66PHNgtGj1TlquXh2Gl2Z23bYJedHeTenvQn3njoRf9FEOaX4fDZ5xpDMZFmJCI4K4Cm550ZNCV4Xh6qPDKJ35z5iMUmD6cHTdDw9BpbJKQnmZ9SRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB7037.namprd11.prod.outlook.com (2603:10b6:806:2ba::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 06:54:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%7]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 06:54:27 +0000
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
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Martins, Joao" <joao.m.martins@oracle.com>
Subject: RE: [RFC 10/12] vfio: Add cdev for vfio_device
Thread-Topic: [RFC 10/12] vfio: Add cdev for vfio_device
Thread-Index: AQHZE4aVB/ZZCYxf9kuvaREcBHBVQ66VxPMw
Date:   Mon, 9 Jan 2023 06:54:27 +0000
Message-ID: <BN9PR11MB5276B2E09520480C165BD46B8CFE9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-11-yi.l.liu@intel.com>
In-Reply-To: <20221219084718.9342-11-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB7037:EE_
x-ms-office365-filtering-correlation-id: 3fb4bb15-587f-43f6-bb0b-08daf20e59ed
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: grbKls6XAG1ElnMP0ZRv9L82FCk/vO2j/Ptd2OAu710EIs6cxY1rrO7kblykZHY/JgORtYQZZLyUAmZwNyErkny+0CT48y0wvQpFSRNNNcACF2ozJjp5vlL8MrSXl5X1rHKRrnbleKUFnuPSXzUmIOEtIRXm2HfDOgEMZtuQmNT5SsMKzfgrrLWcBsNTRsGubQIKolv/a29xs4FefouEJHYORgWrHCzFUjx/7wE/wg44CCYROmJXBR7flHDjfwoMy33nJKjCqHL6Px0niWzfayCzA7CVvXlNEWE4xz7OZcCyQoJ1yZ73tNr6i4JyherlgcDZDauTU2XE1fOtf+/e7eQiN0aO+XYTL4nXbK0UpwSydXxeXsUvFU9RDxMwSHuF0zgT/xLjaumzvOMiUXH817bi1VhT5qKfsTHagzUy/ZFn2b7xoDSEu3QQatQ5VgGLiouBh83Q3H6X5/KKDZmYcN2YnvSgDuzk4br4G4Rx1Z5PpdcHdT4mj2m7XswTJHa06UEICYUSQcnvxHpyo+dRy7JjuOa5EWaJqSzSQN6uiF0E1tpBOTonC1W98JVNSvKViI8lqnFUQ0396fpiw96X7JiOAYzoZU0SwaroOreFGZrylypeAbC5POGfPstwVwHBD79Pw8zY1dFayheRvJ2vJ/71I/hyoQ8DPaI7DmgmD6r1FWGfm/9Zpz2160yXu5LwbIPPInmHA6Z2ETitBw3ztA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(39860400002)(346002)(376002)(451199015)(122000001)(38100700002)(82960400001)(38070700005)(33656002)(86362001)(66946007)(66446008)(66476007)(8676002)(4326008)(66556008)(64756008)(83380400001)(76116006)(41300700001)(54906003)(110136005)(316002)(55016003)(2906002)(5660300002)(7416002)(52536014)(8936002)(9686003)(478600001)(26005)(186003)(71200400001)(6506007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?L6waRC7k1lns3r0KyUhBIAesttGv/dw+Ju1mAnv0lO99aEtgwqTBxRAYRG3E?=
 =?us-ascii?Q?mS4EaG5UEL0vDZRiCikzZc7rlSUkIum0sbiwmOdz1TQMb5lQ7+a9LK5Ej+mY?=
 =?us-ascii?Q?8ME880JBlvb/X67zEkooC75HCqH6Zt15UpyaF8sTymzYfNtkQS+Jz0JH3xCr?=
 =?us-ascii?Q?cKgCnDJVluJIPYg9B4DXlZdGTfs6j/19lxa6gpzT9+z9/zIdAfhcpcvyBlkW?=
 =?us-ascii?Q?ebJ2sEuubx1wMrAWLILdxpDQ+T4WE0Fe26GvTIsIdYcOAOns0aRa7c8jMVzQ?=
 =?us-ascii?Q?GBfaQ7R4bMyIfb+UY7Z5gn7lDwZI4A2g3JpeWrhRtUNBzbXqsQTvsLa568JL?=
 =?us-ascii?Q?U5Wr4d0RWJnj/WFxuYn9ZtpI7iTIJE6xwd8VNzseBwEkEdlL7x9YpPcFOTw5?=
 =?us-ascii?Q?Hule3CAxA7YgEmKawMagBegJaQHY13CLJCkZCDcj15wGm3HKeBT6p3h/zUS0?=
 =?us-ascii?Q?1r2LhotJKiWU+m3JWSVi4GAbTLpL/VYgV4ISMgjn+pcNZnUNi9P7DxsTBsTh?=
 =?us-ascii?Q?P30JIuVyomP2xVyQbcjEjAfdGKk3RLAaNQl6+2ycrcOd8xX/Xzm21255F3Ge?=
 =?us-ascii?Q?VIY+Cmd9oU0yzgOe7b9LRlsJv0Xny/shbso1yafMFWIYyLuTXZh0fgeFTVY8?=
 =?us-ascii?Q?7C7/esVpsGIzqKwByvc0R6xc+Vlw9cc2W4zMH8Qk3pNB0fhLWGnRz0UU5dEC?=
 =?us-ascii?Q?quYWONAG4GLRcyKhqU7q9su1UxMsvJ4bcvFZhMFWVrfcC3te/9SGvndOleRi?=
 =?us-ascii?Q?rNAx9j/AutyzFgiI9Pw6cOVRbwPr6CiNOpJOP5muZ1RachhSlP+7InnvRh5t?=
 =?us-ascii?Q?Fr8mmvYfCje7hJI0rlacsBUdjveLD9BxFLDyTw0KTGDd8aSlGV2w1qhqQIcq?=
 =?us-ascii?Q?DCyrd/Z/eThfZEkwKmi4PiwVZXfFloZxf54d+WXOTxaM2skkhKnkKkAvhrPf?=
 =?us-ascii?Q?f2XXtjc7Pu/MBZKRLkXVA2esLyTuYewvNbEFl4wvnySOBbATvbm/KyjjW9NW?=
 =?us-ascii?Q?Ya86u55JKG/43FHsfQABWQQhwYEUgpwHsRPjPxDBEocREXzsdzxJItWVxvqO?=
 =?us-ascii?Q?ImlTr9Wo8lkj08BPxJOxdI0TLQFZtZAvtvqSLFq0wCKDSdkbsVTxOd3Z+l9y?=
 =?us-ascii?Q?SYkqTuV8X2UDyrfjljdu4xB7pnMneqX8PnJMIm+csEC5ETJYwaW6LJTBUIc6?=
 =?us-ascii?Q?PAX+v1vJlm8WbwFh2cj0JZbsM4Davg5n1zr2oUBhK4zAuudfLnVcR3yecCN8?=
 =?us-ascii?Q?ujaVuDSnBpXBTM1C0p9Xpn1uPImsPxSxgcIp8KXrwUs5a8Z8Dc3hG7+OkLpY?=
 =?us-ascii?Q?2WACy657b0MtoukAnEtZSL+Ije8SbgAz9S+1MT0OpNbUC09yPTurYiGkrp4c?=
 =?us-ascii?Q?nWx4aFhJfgI+xA5jE/2Xe4Iss+F+ejPcur6tIFhkZdpz/Xc3/pVfymCtiODN?=
 =?us-ascii?Q?ck8ACv327Zk4nZIebWV9clpMjFC7wDAuQm6xjDmFWijFYtXrp15H+HYMvHWa?=
 =?us-ascii?Q?2BCEqyQoL8tDcLSK4nd/TBCbwza3xwMggQCSWBQe+sfZox+1y5jn0lkzOYpp?=
 =?us-ascii?Q?SRSztZJOpe02Z1UTdgmHVR6fsYWL0gu/CRwzyf4a?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fb4bb15-587f-43f6-bb0b-08daf20e59ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 06:54:27.7938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DOXR8fsUSrEslE1hggiGAxVBWoWTVpK1FrpnV0SHOcpPhop55yk2kIiMjREvtOSpx2DotXpZWgupLGDF58/WmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7037
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, December 19, 2022 4:47 PM
> @@ -156,7 +159,7 @@ static void vfio_device_release(struct device *dev)
>  			container_of(dev, struct vfio_device, device);
>=20
>  	vfio_release_device_set(device);
> -	ida_free(&vfio.device_ida, device->index);
> +	ida_free(&vfio.device_ida, MINOR(device->device.devt));

device->index is required if !CONFIG_IOMMUFD.

> @@ -234,11 +238,18 @@ int vfio_init_device(struct vfio_device *device,
> struct device *dev,
>  	device->device.release =3D vfio_device_release;
>  	device->device.class =3D vfio.device_class;
>  	device->device.parent =3D device->dev;
> +#if IS_ENABLED(CONFIG_IOMMUFD)
> +	device->device.devt =3D MKDEV(MAJOR(vfio.device_devt), minor);
> +	cdev_init(&device->cdev, &vfio_device_fops);
> +	device->cdev.owner =3D THIS_MODULE;
> +#else
> +	device->index =3D ret;

this should be 'minor' since 'ret' has been overwritten by ops->init().

> +	/*
> +	 * vfio device open is done in BIND_IOMMUFD for cdev, before
> +	 * that, device access is blocked for this cdev open.
> +	 */

/* device access is blocked until .open_device() is called in BIND_IOMMUFD =
*/

