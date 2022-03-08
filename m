Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BE94D144A
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 11:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235807AbiCHKKJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 05:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345609AbiCHKKI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 05:10:08 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6BE2251B;
        Tue,  8 Mar 2022 02:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646734150; x=1678270150;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=StJII8y0gO6S+mwNazbY5mL+uKm1dZR+Ndnmy9PObPw=;
  b=jNHOwazk5FsRRg439oFhttdr5+nLLs8Rp4Isr21kdl/WJXJ/WD3TYUsu
   IdkRn3IBfxMRIG4UBnAvka1uetzd1R1Mp6xQKUb4bNrs+IfKa9AGH7KYR
   e3GzU3zXxyT3GkbbYuDLeSXF68jh6c14DK+rSxx3jAgT+KyIGRrBvoEr/
   HTLhoNAXnefbTrxcntOE0/iU9mkx8qnfSzLgGJy6qEvA8mAQaivc2U1q5
   zZxieuK3Bv1qtwTtQIKudqGIGgGSsMcdfg+UB3B3Fk2iDqQR7gZK7MjZO
   WTW0srECirEVJb9wfbqitxN+5s5uK+CGLXj66jp9Uei99XaD+6vZnD5ms
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="279360025"
X-IronPort-AV: E=Sophos;i="5.90,164,1643702400"; 
   d="scan'208";a="279360025"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 02:09:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,164,1643702400"; 
   d="scan'208";a="780662452"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 08 Mar 2022 02:09:09 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 02:09:09 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 02:09:08 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Tue, 8 Mar 2022 02:09:08 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Tue, 8 Mar 2022 02:09:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T9020+F6ChgXDhkBfq3OJmQEoc6Cm6lU3KuX8KUFcB22ikYZN5L6+akgnKg/62eLMQEz2JCI32VD9EfSGgVQT3Kx2LbXYwukFhoZLTy1H+MfPLKXqVXxnKkdDso/QXpzJF3ZfivF4v85GkYO28J8IcHP+ObEC00TIvDaCG/EFkUs2CqQ2UB3jMXpccazHP3scPPFpNaS7QPNSuRsDAvlhAYWpXMdiauDkcVt2s37QWFLyrMJ+1m4oa8zS9ePuPtk+p9mzCt73KPCah5tJOzPkfJE0LwXPJRGB/xRPZQ8Ld5Hil+kcvjMsamDLbVw+RZsc7UzPCMUPvdNL8IAe1s4Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ll0pl5GyP81qwdmKCzKZdC+/zrTB5lpaOuDESNz4WYk=;
 b=Aa/XJOUnoo3ZbmDYrrC/tGT92sLtvCYwRatlANTMtaajrVlBXHx4T2Fbye1cm8YtjSqxA12vTTYTSmAK/ryEK9fAChbaI+ISFTY6ES92TfFMfubZHtojr5/pHYIqmT2mB7GTMlGvam00aCsBfmyvktytiinXMdOJC3zYu2IP4a2Z8+q8IzTDE+cN+0p8VXLW+A1Md7UpGxjGDjkUc4VE7LjqaZNcxYpKpoSiT643idh50gPXlcaXMLtS6kDcOgmQ+a23vBx6OgkAzAgSD7go8i8bdIWQqufTnZ8DRHk4u4T8nf/IAsCkiPs4+O4Y/vt1efoNmTSIzEtZwiaW6iKJCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH0PR11MB5538.namprd11.prod.outlook.com (2603:10b6:610:d5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 10:09:06 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%6]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 10:09:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v8 5/9] hisi_acc_vfio_pci: Restrict access to VF dev BAR2
 migration region
Thread-Topic: [PATCH v8 5/9] hisi_acc_vfio_pci: Restrict access to VF dev BAR2
 migration region
Thread-Index: AQHYL1LgK0paKWluGU+nIOk/ItMZEqy1Br3AgAAo7QCAABi7EA==
Date:   Tue, 8 Mar 2022 10:09:06 +0000
Message-ID: <BN9PR11MB527673BB7DCF28B782927E658C099@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-6-shameerali.kolothum.thodi@huawei.com>
 <BN9PR11MB527681F9F6B0906596A77A178C099@BN9PR11MB5276.namprd11.prod.outlook.com>
 <21c1ddd171df45bdb62220cf997e58e6@huawei.com>
In-Reply-To: <21c1ddd171df45bdb62220cf997e58e6@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 075869a6-7322-4d2c-0dc1-08da00ebae01
x-ms-traffictypediagnostic: CH0PR11MB5538:EE_
x-microsoft-antispam-prvs: <CH0PR11MB553847FC4DB27E5C1B6906408C099@CH0PR11MB5538.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QJ3u6VLDj/qdgf+NeNIgXI7K/uuEte9I+JJdhYvO4fQvZGAQxhrRvUMkQ7Aj6FF42uHHWOvYnW+S8WzIPv/Oc6baQtAlMdxtOqaWAswk17RakFL7AI4CCDaJh4QeQQ8tiFWzsLV8t7+9Z0DRcv/vPemYy6/VW3uTOAQUGwJAyoQ6YLkgUa/x82H0a9+YumWRzCr1+h8/90kmUSv75oFzcWewJpf2rgZWAU8hZ1uGzyCjF4cEmvtanXj1s9pTLU2RuAwW+2L4u5Qlvwc+Rzh+GFO/bMxe2srMnkUUhOYDf3MsLBUPXetwx6WDsiE8Ai+utQp1U0xOIFUkJqfye9wHMGnWMuB79W5M17dmcc3dVCvkLgFXnF+N75N6lgGIGYViSQB2K1hgAsE2RnUDeO3sHiUKxGefpm1vVTDOXOC/ZiJnR1tYGlol2+Ce2WFdewb90238FaLzyUtijFWcUX/e+ZxSSwP1V+sBtvQxJhY0mTROdP4qAVUqDAXfV4aJEqDUlnUBXJpm8fuUhUl3huujn4vQsDTW+XW7+H2uvHj5Z3NL6fAW+re/L2kx+yJXAqD+E64mPYwowNj7aqYMvtpscrHN0cG5Yec1sN6+rUGDAmugu10nFs1cuhi4ELX8cUoogEimQ0D9B2xqqwO1UI2Mjrk50Evi91lNcWvNOI5cYkPc21bdyTlAOUl/IOnowkJ11me6rpMzQD+8x5XgkKRPAg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66476007)(316002)(8676002)(54906003)(66946007)(66556008)(64756008)(66446008)(38100700002)(38070700005)(86362001)(52536014)(8936002)(82960400001)(122000001)(5660300002)(2906002)(7416002)(9686003)(110136005)(6506007)(26005)(186003)(7696005)(53546011)(76116006)(508600001)(71200400001)(55016003)(83380400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CMCJma4hryLoeOMnsqjvqtF+hKdjhH6KCkGacXZMQQG72TFL0rZx6cs6RWIp?=
 =?us-ascii?Q?y2qUpLRWxWtc2eLz+ST3bfCZhaR2KXoWnVMkqUtf6mKnj5oRzvpNnarOHYND?=
 =?us-ascii?Q?czawJERG8Uw/KawxLbDnSX1829dLj81areuEn8TUJs2KzwNDiP5YD0t7SVG8?=
 =?us-ascii?Q?jcjB0mqQ1EhOHJtS/Y6h1LLU9JDjMXD5wAnyrANAFcWPck1xpTPgqCg18h7h?=
 =?us-ascii?Q?Q3/qxyLBl4veIq2cSlLO/Fk9hakTDteYFoVVpdWvzY6okk2y6Ju8EfK/IVCV?=
 =?us-ascii?Q?q7xTgwKOYwSFqbKBAmYyM7jChAISWgY/yl+8QlNi5jFfEuzQsENtxTDbw1Ck?=
 =?us-ascii?Q?T1idDVGXuIDzACIO9YqQj9Ssm1fx/g6OHZYGHoKiuoku5cmgD7atnygtdN4+?=
 =?us-ascii?Q?fL9r5BS5C+TPvPaOQQvlP6t7610n42VFBFIev/ZQVcNuTWJCKdXfyV4iH4Dd?=
 =?us-ascii?Q?pnSkOZHHxfvTlNHNvf3sH3kDSW7VOHchYi3OPpXrfId5I1VNnXg7U0/pcIIQ?=
 =?us-ascii?Q?99PM7u2cxmMIRb9j6MGe13tE2rPu7Rqum4AhKHL10XZCw1RkvSMbZMZeB2Li?=
 =?us-ascii?Q?Qs9O4Xpfpx/iRoB8FuISm5UR7z9+aekRECRGmsgTHJygB7s+hlwkyXJtjiZf?=
 =?us-ascii?Q?eCU/dXOnFSA3lqUqQE0sibpX2/SZS4629XxYZyKB2p3eOorqmmgyROkL+WpH?=
 =?us-ascii?Q?J0ZaQdEiIdnTRYWnPxZSVZpJEawezLiJVDOzDCvAk78Xd5KpsvM0jct596rz?=
 =?us-ascii?Q?MMjcQHOZsTSxUxkky4fZZD8cA1/UHFD+/3PqeVEMYwVtymCQIZ0kd2pgp7lr?=
 =?us-ascii?Q?S9BcuEhU28/hBsWKCrFJuNHGsDUn76Uqf1aasK9BIQ+TGcf0fcYUs6JF/xtb?=
 =?us-ascii?Q?ktMDx/YVpyUexsv4BXOvrZC9bQZz03KQS3GKn005/Neua9TKwPo/fY2Irz5E?=
 =?us-ascii?Q?l8V4VYgha2MEcJbI45egem0h5MRaBxyUxYVZdrO4GXYimko1YLh67hWSc/4L?=
 =?us-ascii?Q?Gkds5rTUIjp+LUo3f7MEX8QJRVq69O22wz/L4Waw+VKRAfS3AIgqTsKqKqbA?=
 =?us-ascii?Q?7Wv6m2nhqY0en452SEtcqI2iikLY+Ma6f6NhRhx0Vvj/Qd3eT2wEuTJV+Pwb?=
 =?us-ascii?Q?/Yc3Zm9YGJaqfLMmgseZL1/d7kfrjVbITW72ZBiAIKRIiOF0s8UeWRaxjbyp?=
 =?us-ascii?Q?w6ZN/B4ssbyog1QCV+lVJJLpJgAVjOv4J1Ten/jSm57OOd/QXrnAZ7zJ+3GD?=
 =?us-ascii?Q?uxvu5m7K9SKKSHDdpv+ROMz3a6eCAI+T5T+3uvRHT3V0xvNODMWaCqM+QCGs?=
 =?us-ascii?Q?q4qNNrABV9Wfx07oX5txxjj2h7fRHVViSmCqsWCd27QjWPpMMTQpU8sPy3Yi?=
 =?us-ascii?Q?xY7dp14aIZ2YqzM4t42cXGQWvY0VG1jY1rXwBtlF4q2L8OcJEDslkQiTU1Pv?=
 =?us-ascii?Q?EJb178MzMHZQY5UzfrNTRda2oFVWEPXDy3D7CtrDe0veeFBvK8oi/W/XEkDt?=
 =?us-ascii?Q?ICDk07n+KxH6fcXsMuRv/7AoKnwHNSOxDS1ezIrlHdc54KoBhnPt/0aP11r2?=
 =?us-ascii?Q?06TE+FrH9IDbcht1AQKh8XfKe8tTis64eDis8B+QZ/2FfVZiTw6e0GDoxl4w?=
 =?us-ascii?Q?DA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 075869a6-7322-4d2c-0dc1-08da00ebae01
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 10:09:06.1715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TBBTBzmDpK7KGjKeGKo6wMn9yPzUtDjkzQVJG7OARhSGEygRTd5Jd8lN+F5I/+ttMz4Xt4LHg0dBvbRbh7Yfmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5538
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>
> Sent: Tuesday, March 8, 2022 4:33 PM
>=20
> Hi Kevin,
>=20
> > -----Original Message-----
> > From: Tian, Kevin [mailto:kevin.tian@intel.com]
> > Sent: 08 March 2022 06:23
> > To: Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>;
> > kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-crypto@vger.kernel.org
> > Cc: linux-pci@vger.kernel.org; alex.williamson@redhat.com;
> jgg@nvidia.com;
> > cohuck@redhat.com; mgurtovoy@nvidia.com; yishaih@nvidia.com;
> Linuxarm
> > <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>;
> Zengtao (B)
> > <prime.zeng@hisilicon.com>; Jonathan Cameron
> > <jonathan.cameron@huawei.com>; Wangzhou (B)
> <wangzhou1@hisilicon.com>
> > Subject: RE: [PATCH v8 5/9] hisi_acc_vfio_pci: Restrict access to VF de=
v
> BAR2
> > migration region
> >
> > Hi, Shameer,
> >
> > > From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > > Sent: Friday, March 4, 2022 7:01 AM
> > >
> > > HiSilicon ACC VF device BAR2 region consists of both functional
> > > register space and migration control register space. From a
> > > security point of view, it's not advisable to export the migration
> > > control region to Guest.
> > >
> > > Hence, introduce a separate struct vfio_device_ops for migration
> > > support which will override the ioctl/read/write/mmap methods to
> > > hide the migration region and limit the access only to the
> > > functional register space.
> > >
> > > This will be used in subsequent patches when we add migration
> > > support to the driver.
> >
> > As a security concern the migration control region should be always
> > disabled regardless of whether migration support is added to the
> > driver for such device... It sounds like we should first fix this secur=
ity
> > hole for acc device assignment and then add the migration support
> > atop (at least organize the series in this way).
>=20
> By exposing the migration BAR region, there is a possibility that a malic=
ious
> Guest can prevent migration from happening by manipulating the migration
> BAR region. I don't think there are any other security concerns now espec=
ially
> since we only support the STOP_COPY state.  And the approach has been
> that
> we only restrict this if migration support is enabled. I think I can chan=
ge the
> above "security concern" description to "malicious Guest can prevent
> migration"
> to make it more clear.
>=20

In concept migrated device state may include both the state directly=20
touched by the guest driver and also the one that is configured by=20
the PF driver. Unless there is guarantee that the state managed via=20
the migration control interface only touches the former (which implies
the latter managed via the PF driver) this security concern will hold
even for normal device assignment.

If the acc device has such guarantee it's worth of a clarification here.

Thanks
Kevin
