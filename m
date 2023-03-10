Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260E56B4366
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 15:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbjCJOOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 09:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231937AbjCJON7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 09:13:59 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D58311A980;
        Fri, 10 Mar 2023 06:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678457569; x=1709993569;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0j77W5jPj2o/moI8VJu4k3rnOQ7a3UyuxIDYc2r8lYg=;
  b=c6lBIqhiCq6lyF4FwK4+eMul4bqi82qRlfaCodk6lYi1RlBYz525m93a
   mwwY4HTxLax067lXYSIgFILCNWpf4NH6/1hfmx30ezFTXTScFvBrUZgZf
   fHFOJkUWhBRAuUlC6Y8Bf/cSdCXB1qdzuo/8Z0WJAc0RW77J+P8sj1B07
   KavcXKy9gA57rD6jBX0N1bwhJSiEeM4uKjMsdFZfTetQMFe7icSN+4zex
   PpnwT8w0OAdeWTVKpLVPK8Q8FAM87GHynrcJPlLrHMeppZBtEIKoHBzNc
   Ow+x48IyVdG2unxxYtjurBAVesqlR0PYRYyJL7QKBVjEXJkbIdL0QeKUt
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="336753802"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="336753802"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 06:12:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="708016928"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="708016928"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 10 Mar 2023 06:12:31 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 06:12:30 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 06:12:30 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 10 Mar 2023 06:12:30 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 10 Mar 2023 06:12:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFJrfWD5xHfWcp2/X+mTE/P0dTm4GhWxgP+7LzZ1Iy8t2Xf68te6S2n+CbCez8ySta7+8oooMr+rl3RY5KnEMvNrUbOq3x1gpzejXQple7/1xUuDxIfQviD3v2OIVE2ESzUaQ135kIiu2ud6BPTau2gjOx4blyZEgKcjC/Dqa7nynvK8ChhXDKhmpvJDkced58QDLtn24UjQjCX+VcmIxvXZddr6j+HCkX3qOFoOa0ipVJfVaBaWY8H2VO+LeYHOHoqyDvkEhQ93QKFHSkOciD73pydBB8zeQsjP+2FvKabb3kGcahwy4L+C1vptY1WEuq5RhB8k+gGx0BxdgGWeGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bkhQT4t6cHpZsHrOq3p8AsNC0tF3EBGBw71dpjjoNM0=;
 b=XqmWNDIN9rGiTamWd5uLogI29rkgbpOF0N8Kyh7TZH5xSbW5dMfblfvaFoD4nL8omRx93stNduVJPvQxxK+KMkuC1gJ0fXfDaRmWh2PN+PlLFor9+2j4zWXRyvkc3JlW/P7Q3FNnbb5cRp3cpWewAMU2vGbXJy4u7yr/f+fWMrXETLrckKntCqSRHOfZ50oXG0MExraO33Y+yk5YEAcdy4IYLNPcn6MK6Y3U1ckGi6qxjxEJg7BkpozeHG16yC5WfzsW6VoXJkUNLzCek3KJk/E8lAJkY8dyfKD0rmZN7M1AFBrXoRRpBkKTHLhvSsBeCOavYYkLbf1Eyds6FGi3RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20; Fri, 10 Mar
 2023 14:12:22 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 14:12:21 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: RE: [PATCH v1 5/5] vfio: Check the presence for iommufd callbacks in
 __vfio_register_dev()
Thread-Topic: [PATCH v1 5/5] vfio: Check the presence for iommufd callbacks in
 __vfio_register_dev()
Thread-Index: AQHZUb/ZXIdaaei2nkeVnEly49jVo67zSOIAgADF+YCAAACPsA==
Date:   Fri, 10 Mar 2023 14:12:21 +0000
Message-ID: <DS0PR11MB75299B3370F1AA71D7993895C3BA9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-6-yi.l.liu@intel.com>
 <BN9PR11MB5276BA4E1FF1345433FB8D338CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZAs419G/RNoEgPxq@nvidia.com>
In-Reply-To: <ZAs419G/RNoEgPxq@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MW5PR11MB5811:EE_
x-ms-office365-filtering-correlation-id: 2b5faed2-cbd4-4236-de66-08db217176ee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ke2dofN16N20Rg9FmHwDhXN9jfmbdMDy8Kh0yPPdFYU2F2UGriO0wg/NoI4HdQp2YvSBCxPiOpagYwe78XfJz+YsbaZvdPcfa0dcneVwzP3+tejOvF8Xa7kGqMLs3S7BFRFbcZ3aI2jGSvSN73hM5KNiHx7JDyY6PUSoKsSn1wWq28zw6eCO86T8BN8LLAQFlC/pA7l4pwUvkCmbyORQZsWlZu9SEpLvKims87/JKC/65fqB7u1mV3U+L+qH3kVwvvZH929sfYXb/oJctchHsworMZum3e3ZEHhjlplsGBvJFtKHJgP5HeB249BjmBGoGFzHR4+InLFIYUh5WlrzeCmJFiawpfcfjtcxuw2E14DoVo+oroMrgqCeaLkqIfj4pD55Kbg0QsIV88g0Oc0jQWMEAO2141oWL4bVB2+SN35ctc7udJ6qcxBIipIbsI1aKFL2p9xu6TZCDMbbQ8aDcPXrAMB5OofiFywf8ogg/yuh7bUn1Nfy7/Cr4J2ExfZRMSYsG3MvR3aiDgEHet2qnmJE0GbZd3CYRcojjlDa9p8OIXEBlZsPXC7HR3DtUfS4TZxVv8tTLRTJg5OJEtXHRfyZ+zTMwOcUv9xfTkrgfErMAj+ilL6TuDi3ZRYiayHVQ1h157t4PniiNcIto9YQjB1s4PTadFiBj9qm4Oy2Nr7PqVxW32qHh4NopnUz+6PGkvxZ4uGzJ+xaRhLdMxhkJgUha4zkNN+TU5ziBMTup8g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(376002)(366004)(396003)(136003)(451199018)(5660300002)(7416002)(110136005)(83380400001)(76116006)(478600001)(7696005)(6506007)(26005)(71200400001)(9686003)(186003)(38070700005)(8676002)(4326008)(66446008)(52536014)(64756008)(66556008)(66946007)(55016003)(8936002)(33656002)(66476007)(41300700001)(86362001)(54906003)(6636002)(38100700002)(316002)(122000001)(82960400001)(2906002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EOESygtfDIUwXYkZmzIiO/P+gaXPC1EdmJhAvxB/i2KmaZFnrPvTkfx6E/o7?=
 =?us-ascii?Q?ZcvSeBifb2POGk7CwJFxpSA7NptTIGkZ11wlUC+tKnG5rPpsAQ50eTCYQ8Zx?=
 =?us-ascii?Q?G4AarGu9kG+Akb5ZbMVO1paejrFzf7qBaRHVSOa04D/NaEQ7uea5rkBk/yhI?=
 =?us-ascii?Q?94o6ZMvH/6s7pSIyVAI82K5pZkum9Of9OhEjnn5eYylKnfClp2qUHrsTHTkd?=
 =?us-ascii?Q?xJaJRHeiW09p2WH/ISbNV81/5Gs7cbTesIrtH418Zgvvur79Hyjy3082ZKRr?=
 =?us-ascii?Q?oaf+JzGqvEik6/Ho4OtOzGXAg/tRjbQs0IJ8fOnUS30ulBHhf4ZJSqavF+3Y?=
 =?us-ascii?Q?XfJgFp++cYswMvZHDdbVsCfBqJtFiq1TsAydzNts8GmW7sk96C/Edx3zrq1R?=
 =?us-ascii?Q?+DyNEbUwkv2Xt2DrjbcDDir/7ojGLoPS+TN0ILuLTW/J2U9/4Lkx9y3KDzmd?=
 =?us-ascii?Q?cWzSNqocnF0uv3NkEVTDWcq3D3U7WpCSTXaluvP28Z8FZXVF9PvjXZ4n4pIi?=
 =?us-ascii?Q?mu1tdZr0IQNVDmD9bTQD+yfbS+pC4Q/OjKCg4dMlqQLdQ8KQIVVSauCFxh3W?=
 =?us-ascii?Q?zRg0vrDKlJrzQWE3JYRsnu9M7otKrLtUEUVAH9UyFa+VObDOd+t/gha8li64?=
 =?us-ascii?Q?etWangBtpImzF4IoC8IjekUQAE0KdlG4A86uuGxjFHIBGjB3nAvFgK+2CE0E?=
 =?us-ascii?Q?orKDH8XppwkXJ5gTgAasTVcsBRmSdB+I0gFB0w6MT/H6B2aeBTRhy5i2MbrR?=
 =?us-ascii?Q?kgYm8CbC7fm/eLi/3YDvu0fUz5JovfkJo6asRFgEnW3Ge3DOkp7nssxnDItC?=
 =?us-ascii?Q?KNOtPNB2UnU4aB1NBXkUozp+x35qvjUtmrZ5viXJO8h8vmhDqyqRpZilO/F5?=
 =?us-ascii?Q?8jpoBM+uVh8Bh+IFvW/tElJS3I7kNfzUNbLnqJ3cFqdM9a47UQdCG/fXJfrX?=
 =?us-ascii?Q?YWFDt59bQddioH/9FQl3uq5hXMWx8w9V8TEZz3QFjFBVWcIcJ0obd4NlBfOB?=
 =?us-ascii?Q?qBoNEOHAWCkh26yX4TvhGj3Zif2H+1e8rxijOmyyrVxTcWxD7H07OK5X5VUW?=
 =?us-ascii?Q?qM3dQB0Fq167CWMhJHnu33C2glbTPwA5jaAaipYVYDzsImJtvymaJNVcZaNn?=
 =?us-ascii?Q?ZJ00Q/otPct4uk3SOlE+8Lihcpm+0hSEUcVg9dXR7AtXXkqbXoHdZptAXhiY?=
 =?us-ascii?Q?kuyJm8Zq7ZuhRZmpocwHRfEv5xhxXWmW0ZlZK0foRxklo90eFc0homPbpyOI?=
 =?us-ascii?Q?s7Od1mgbOrs8RPKN1oI2Qo+ml3OtqJLMFu/QjuGROBzWVcQh1ThV0L1YS7iU?=
 =?us-ascii?Q?O0aSSH5wKasafzlIse6jsMbayGgf5oFa76opbPr0UMqJVTpfz6MtZFINQYvV?=
 =?us-ascii?Q?TMIAxdaxLImPI3E8eOze+Js20C5lHF06I1zJq06xR3+RgGhF9/LtTyREvusd?=
 =?us-ascii?Q?QO9ld20jz/Nb732LFInmNzkoxu0iHaJna+TK5xB2oF80/P7PEnkWmeWa6XFy?=
 =?us-ascii?Q?1gPu3WZEDE7L07XwBWNXhYZwEE4MXhGOUXVL6Z6b7tDqxzRqxTCyIPnLlfZi?=
 =?us-ascii?Q?re7pXsbijXMj5+DrN2IrL4rFHbQvk56I4kvnFFV7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b5faed2-cbd4-4236-de66-08db217176ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 14:12:21.3288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b2bAsQUKcEXwGWRyFBQ7KQiU6rnB7fJ+Wtc61YAlewLBRKOiMQTqaJ7NBeFmKUnnlcyhfOM3ZfyS+744FgYnbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5811
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

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, March 10, 2023 10:04 PM
>=20
> On Fri, Mar 10, 2023 at 02:15:32AM +0000, Tian, Kevin wrote:
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Wednesday, March 8, 2023 9:14 PM
> > >
> > > After making the no-DMA drivers (samples/vfio-mdev) providing
> iommufd
> > > callbacks, __vfio_register_dev() should check the presence of the
> iommufd
> > > callbacks if CONFIG_IOMMUFD is enabled.
> > >
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >  drivers/vfio/vfio_main.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > > index 43bd6b76e2b6..89497c933490 100644
> > > --- a/drivers/vfio/vfio_main.c
> > > +++ b/drivers/vfio/vfio_main.c
> > > @@ -255,8 +255,9 @@ static int __vfio_register_dev(struct vfio_device
> > > *device,
> > >  {
> > >  	int ret;
> > >
> > > -	if (WARN_ON(device->ops->bind_iommufd &&
> > > -		    (!device->ops->unbind_iommufd ||
> > > +	if (WARN_ON(IS_ENABLED(CONFIG_IOMMUFD) &&
> > > +		    (!device->ops->bind_iommufd ||
> > > +		     !device->ops->unbind_iommufd ||
> > >  		     !device->ops->attach_ioas)))
> > >  		return -EINVAL;
> > >
> >
> > I don't think IS_ENABLED() check is necessary. those ops are
> > defined in the driver side w/o a conditional CONFIG_IOMMUFD.
> >
> > We should warn out lacking of those ops to the driver developer
> > as early as possible, instead of postponing it until someone
> > starts to build kernel with CONFIG_IOMMUFD.
>=20
> The ops are NULL if !CONFIG_IOMMUFD. The previous code was OK
> because
> it checked for non-null bind before demanding the others be non-null.

Now we want the no-dma drivers to reuse the emulated iommu op set,
so if CONFIG_IOMMUFD=3D=3Dy, bind_iommufd/unbind_iommufd/attach_ioas
should be non-null for all the drivers registered to vfio. Is it?

Regards,
Yi Liu
