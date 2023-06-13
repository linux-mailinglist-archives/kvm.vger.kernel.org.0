Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E01972E60F
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 16:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240551AbjFMOmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 10:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241113AbjFMOmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 10:42:51 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A713173C;
        Tue, 13 Jun 2023 07:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686667370; x=1718203370;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4MxBP5jIr0yIHxthfDyDFrxj5c7USGM6wrvfGZczAgA=;
  b=NzsN+JchNuLimIqdzVGWccMdkhw74a7UHDxWLTHVRJ/jca+4WDFSYV/M
   BLi0BGE51JmiL52/KJz7PDguVV9ZjzCgeffUt6gDt3OYyeNoi6xxxOQpj
   bNdTOKOyYaBT2y7jp2P0+kdTOxP2wEqELL9LYLNkVDQ1QK7iFQHIa1z6d
   sIVfZLBlVeDAsItobVTfarEllbQVRrO5558ETRMNgxlfuw2mOmo+/y3LE
   hAMZ0fL2TK9Cf4GDYZwmK9SH7i4IEgNW/PVvxkOLpBIso9rs7gMFf0cah
   fFTHS2A5uaJp4+18jo0UeQ/V8l9mWVtfVVEEnHibr1hvtytqsq/9z3UQl
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="424237840"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="424237840"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 07:42:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="835913124"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="835913124"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 13 Jun 2023 07:42:49 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 07:42:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 07:42:48 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 07:42:48 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 07:42:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/XDsvrm0YMTF4jzg7fiXQBhtkb3iQuk3V4XhESX9oiN6guSg/0XIgAe2ZrNIDIg6vyM9WZLIxZT9O7+QJxKX6hIsV57sExQcNQ2ft5OacwefZ0bqavVk5RnUW7cQTZiUGobmiyyq2aLMRtJb5lC6nBBJOZCba8BUedcxePBv75h/swj+gBK8ytB+qaipNXEJzsjXbEZTTHJ4z2/NyZ9rrP/hROlPutCq8cNlN/wVLtXVGmCSioBdmZ6qNVu8PwlI4Az1YisVusTqvJ5zjevXflxd7aO0m7u4/nZhHvImtLCCxs7y5i/+ZWpmV5W3JHU/GCmUMbv9tADXq1i3w8rtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2dSYaR+vSB/TCcYnt5kmWy90xzpJYcI7TMfxrdF2jbE=;
 b=IzhoEknEw+4QHQb27hDdTzKBLEKjGtl5F7IfN9XMmYIBN+WIpfPXM+evoFff/LzbTqV6iR+bU/TjAl/m6SIYJhG1oEDUVik6VpkdpbTfMsiE9rPkAV40rutwglTwJ0X1XBaAId7Fz3s4MixTS/KEQFr0LmObkeNLI/ey32K+wimLDjwTaTfhuw6AsDhTVXxX1j0LScRghUGexycKdPR4IK97jkJkyIUQCYHCGva0smLyHihjNklHpH1DqtebuWrFkEkA5lruY5VN5QEsbqtOJtN1fbF1r5bY1qmFGEsm54ytLHM4V59KxfP5AgUSlJCfDu4deBLKlCkcTeG0HtgdJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7652.namprd11.prod.outlook.com (2603:10b6:8:14e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Tue, 13 Jun
 2023 14:42:46 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 14:42:46 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v12 18/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v12 18/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZlUw0PINbjPidUkeXtdGCTAzTl6+Hz4gAgAB6suCAAI7uAIAAAkAQgAADvoCAAABKUA==
Date:   Tue, 13 Jun 2023 14:42:46 +0000
Message-ID: <DS0PR11MB7529E63E24335F6DF655E1A8C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-19-yi.l.liu@intel.com>
        <20230612162726.16f58ea4.alex.williamson@redhat.com>
        <DS0PR11MB752985BA514AFF36CA3A2785C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613081808.049b9e6d.alex.williamson@redhat.com>
        <DS0PR11MB7529F0A41AA58AE37BCF8458C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230613083935.753430ed.alex.williamson@redhat.com>
In-Reply-To: <20230613083935.753430ed.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS0PR11MB7652:EE_
x-ms-office365-filtering-correlation-id: 2128c26e-f003-4b24-e7c8-08db6c1c73d4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fMdlgWbSN8ZGCoIaQcOXXoQWg1SrjmSUZbegceVVuiuq2krBRQPMUftrLnlB2i6NC+tYTKHBKk0uSac37O7ppseGdOkT+bJ3Eb0J1N/XdazbjhpP25EGekJgjU26vOk+2MjjIRWOgBraG+7KSGZrLIqxTTA+WzgqW3W7ciwuAQziMRG/NPsZ+LDzZBZ0p37ixZZAHhU0HnrzZo6veAlfrKZh6yAQjvIIW7sRS9cmafcjaxe7NQcT1JsqYZi/3PW5kCAiChG+LNDqOSFe4i+nLahhu7u/DLHG//YuAU792LK4PXbeAegLjmGeGTl2ekY9GFgncNM6nKeI0y8pXdO0UutSDHr2DNGvx1+h6ccSbNVtAaX9Ffreguen8MjPIxRfKJTBaGCmMozmVSMssJC3vu56fq3gH+GbKlYo+Vonlom0D8GINoHZjsjCZ4e7a1rhIDRWLJUpXJoVGy6t9nUnAbTf6auEWL04e20bn3nHVTF7HTMoBfelSVdS+rz6t/vXZHYFGDjIW31eahc/u+hkHcw2xaXDLUrXVr1i57XJNZ+4Ka0p61wtkiEnFnT99bdfmjqcQQua5m8cUS6t4qQEQK98uYsFuwjs9euuMVD46OxuUt+9q+ELXd51H4Ps6hLt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(376002)(366004)(396003)(451199021)(55016003)(54906003)(122000001)(82960400001)(71200400001)(478600001)(5660300002)(8936002)(41300700001)(8676002)(66476007)(4326008)(76116006)(66946007)(66556008)(66446008)(6916009)(64756008)(316002)(38100700002)(7696005)(186003)(9686003)(6506007)(26005)(86362001)(33656002)(7416002)(52536014)(38070700005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PgHJ0tPYU8gWo4LevuWkZSKJB1J6BC79WqNmywSWmxzqjauYYYEznQxkv0Qi?=
 =?us-ascii?Q?HtsMQCuyCBeFtKdBa3vGuWqK0TI07jQRRexiuEb0IaUv1UIbOOZPnzDN5rR7?=
 =?us-ascii?Q?jwWvsSzvqJA30R6mo5Qtmkgkx8uYFhoO3D90qWVyS+YuESOmO1w9TkF2EQ5z?=
 =?us-ascii?Q?3n+VZIodGOymu7vRDVjI6dXzIo6+yqfXZyUP+dkfPiFvg8uzB1AthN3zBYdS?=
 =?us-ascii?Q?TQFEA9TfrdrgNAiDPiRmeJhYasm58gtOJOTuV+CUBi/9mysV9ZdZRiH5uB3h?=
 =?us-ascii?Q?3HH/uiZmhp5RfwiO+RKtudcQ18ZHR6Q+xRr04FD0SxQlZwSETdGhnowiv9Z3?=
 =?us-ascii?Q?D38TRlLww4/t6UDbuHb0eX6V2vN7oig+HSXJIqe6KT4YuA/aDub1XSiXdQO0?=
 =?us-ascii?Q?FIPJwxzDR10LzFTykn7zCtE6vp9JStHgnuWP9Gu4amabWmQSoVjUisGPBSHp?=
 =?us-ascii?Q?NkLQ4pqmA0+eYimONeE1QSIIuAyQ8DJ1kv0SoeDYO4TXgDNoqrJlvtMMD8qM?=
 =?us-ascii?Q?II+kTUafBAPc2LMAbribD4f0Kts/iKmHMzoghc1sXr4b1EU8l57P9A67YRaB?=
 =?us-ascii?Q?uzl8gQp+gHFjb1UP4p9DjUue9nzACVG14Ev0F6Am4RjN2cEVD0XAsjq3yGms?=
 =?us-ascii?Q?2tRJUobuG9BEdCp/XuesoxxUxLTd6TsIoeJGsiRcGoo+CyowsYj2QnzIwp+3?=
 =?us-ascii?Q?0p5DnA3C3+unlpmU80/+KoSyccXXJt1PUP5g523PZJPnJDngbiFYGU4cU+G/?=
 =?us-ascii?Q?SrTRcLOsvQVA/4HWv1DrrJjpslGQvM7SHxACdsQFM8l6V0if9Jy1wnCzOULo?=
 =?us-ascii?Q?al6YEMRMW68OzC/Ww2q3QoCKN1pmYoi/mSFg6IxYFPiWexZFpKEtCoPU8u/1?=
 =?us-ascii?Q?AY+Aep3gw/shS2CR7m7kwl/hiKg8MyaOrWuJbDznEoyDk165MwgIO8Hx38xf?=
 =?us-ascii?Q?B2Z3OFMI+jKDtks14YQGqa6XVFquyh8uUhCuPyDEwwlkWh6aKEx+YTIt/ha7?=
 =?us-ascii?Q?4tK/Kh3uGzZ5UlqBKwmacvRSmx7vH9qubx7EtwinzQEbqk1lXz6pGTKSjXXK?=
 =?us-ascii?Q?uPzC37i4pqzOgYSEwyV/kJA67s60kiQnp13ONQG0z9JFOwezk2pZa4SfCEJT?=
 =?us-ascii?Q?Tu7y4fvo3E0p2V8MXT1ijx16byOTzrzd+4Gpf35006yPSOY03n+AtyXzof3m?=
 =?us-ascii?Q?TauEmSxjFz+Y32Z+FZzY+ueESYm2zsiqIwd6yfmT2Zi97EPFjMnUO+YQ3lz8?=
 =?us-ascii?Q?gKXsH6JDLMVm4iuXk4EqcHGCKVoLt6mDWz2oKkdBSjJcYnt7fy7Gfva1gSzV?=
 =?us-ascii?Q?g5sSTJNTTTSJBSvCrNPoN9nvZPBanEI4wt49S13jpua2wHxcfp4r2XqGHLfo?=
 =?us-ascii?Q?56217cmRLQzzhD0TbT3A3uT/SA97MZof6w3JlHdEfjvOvdeXyqTT87OKt2FS?=
 =?us-ascii?Q?AIvteMr+YQQXvLgq2BXh+wOjcprmQusEttFPZeqmOz/6/a9YKef0motKvaVt?=
 =?us-ascii?Q?dukr7p5oH+OZpyeODeyZExExe8bvAFzHBGcTgZRjQsWCd4wHM+0ROlXPgaBh?=
 =?us-ascii?Q?0gq53dfDOlp/vxPAhrIMEG2rIOnosXOVQWuM7OjW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2128c26e-f003-4b24-e7c8-08db6c1c73d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 14:42:46.0979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HaB8Z6XeO0I7KipbciUoBdpe+Tz3GqSAsKz7b/qRoD1WyO/UuQzkAcYrLmf2ZVwRmgqetE5Uq0Fx9vMM2Dmicg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7652
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, June 13, 2023 10:40 PM
>=20
> On Tue, 13 Jun 2023 14:28:43 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Tuesday, June 13, 2023 10:18 PM
> >
> > > > > > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > > > > > index 83cc5dc28b7a..e80a8ac86e46 100644
> > > > > > --- a/include/linux/vfio.h
> > > > > > +++ b/include/linux/vfio.h
> > > > > > @@ -66,6 +66,7 @@ struct vfio_device {
> > > > > >  	struct iommufd_device *iommufd_device;
> > > > > >  	bool iommufd_attached;
> > > > > >  #endif
> > > > > > +	bool cdev_opened:1;
> > > > >
> > > > > Perhaps a more strongly defined data type here as well and roll
> > > > > iommufd_attached into the same bit field scheme.
> > > >
> > > > Ok, then needs to make iommufd_attached always defined.
> > >
> > > That does not follow.  Thanks,
> >
> > Well, I meant the iommufd_attached now is defined only when
> > CONFIG_IOMMUFD is enabled. To toll it with cdev_opened, needs
> > to change this.
>=20
> Understood, but I don't think it's true.  If defined we use one more
> bit of the bit field, which is a consideration when we approach filling
> it, but we're not using bit-shift operations to address these bits, so
> why does it matter if one has compiler conditional usage?  Thanks,

Aha, I see. So you are suggesting something like the below. Is it?

#if IS_ENABLED(CONFIG_IOMMUFD)
	struct iommufd_device *iommufd_device;
	u8 iommufd_attached:1;
#endif
	u8 cdev_opened:1;

Regards,
Yi Liu
