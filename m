Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3758B69EFC1
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 08:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjBVH7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 02:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbjBVH7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 02:59:17 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D89EC654;
        Tue, 21 Feb 2023 23:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677052752; x=1708588752;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9wv1zYa3wl8IfgD/Lc9P05r91xCRy+gZlpw2kM1g3js=;
  b=MOiBbLefxyCcxXaimldClLOIT5dUbwzKzyrNnmcWaBrNo7xrRirc4TWf
   B9uV/A/4Pi7hGLc2oq9bvVKwyay5tqAiMI9NCh6ma6logo4e2xNAkAbtB
   XfdbJEF2eGulcJiHe1tSij3cbhKVq2avVJWldZ+s4SBu/PHcP34D4K1xm
   HULM+4i55SYe7WWwdGCMV1Oqf//uWoeRM8L+vDgFy1AvRXMaLZRwUlbEw
   Nmatx6c8h2+1itFYwuK2sR/PJ/Ii99Fk0pK39CLRfO0Wc8ENcWEpMoNwf
   I0qc69z7QlxWK0Yn8uMsDMRIX1UdTCYddpGGBxO//sP8DCW0yNzVIyZ5Q
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="330585974"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="330585974"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 23:59:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="671992223"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="671992223"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 21 Feb 2023 23:59:11 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 23:59:10 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 23:59:10 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 23:59:10 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 23:59:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R2XvXQ8z+A36729quIGHllCvkGGRrL9r0TDeUjm4KcvKfM/hrVh/5Z6+w7csoQivXf8malO1of4AvNAsJlYJVZU05ZAVf17smayr6dYliGTlPFobIkbTME4Ojs6MNmkZlcYp9AJKpiORFZog0QsUBlWH/oXOaxrK4MjuOfFHEO16J7wIxTWKWon48bFcZXUa/74cLxYwy6z+ra93+uJhfd0UPMkps1kBxwDzseEf9CKpaomXufbnAObk3uuQU/u1kgJC2BEtt+LcQ254aSS6zcXhZL/jNGy1ukbSP5PUA2AWnNPnXgEVQMAeJtZDfY2Qm7dRlvnnXkXeLUobRLrjog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qNPQ7qThVPfJM9cNEuP8BIZH5vFgVQXI+UTMBiut/BU=;
 b=SPAJf44Uq6+8CR5U2usWySRdlsfZB1KaE1VmS457IUlQr71gUiI8aCdX6RSf4Qa0lnDf4lYZkpXvx6OYjxOQ+dYzjMKnnhqlNxjWuDkN58+ColGoq3w9AQH8Cv9v+Z5BR3bP9F4gFlptIwqcTz+Tc1SMPnI+AHjbCFb1lWC4UmXVPcnfCo8Gg5EvNrwJPbUY1jOlOQlGKLTULMpHawDeg8bPuhT2IwVcnQ8QrViS/CjHzovrZgfrrryxl32CXRJ5+QNmN7gHcBICPGPrf5kiuSfS8CUte/99EAGk9XHN318a0LtBsS4jieCkzQ0CmixzkVCS5Mh46w3q1BXVaN5UVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by DM4PR11MB8091.namprd11.prod.outlook.com (2603:10b6:8:182::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 07:59:08 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f%8]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 07:59:08 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v4 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v4 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZRadl/ZvSXgcxQUO7N/jWnT1di67alMhAgAAC0QCAAAOtwA==
Date:   Wed, 22 Feb 2023 07:59:08 +0000
Message-ID: <BL1PR11MB5271631855658234CB149F0E8CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-17-yi.l.liu@intel.com>
 <BL1PR11MB5271AB3735F7A783C2871DB88CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <DS0PR11MB7529D04D2EB9B5C69C306C16C3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529D04D2EB9B5C69C306C16C3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|DM4PR11MB8091:EE_
x-ms-office365-filtering-correlation-id: fe2f3e31-0b4e-42fa-3783-08db14aaad27
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a3nF9+FybwXy8C55g2YZtbCLP/1kw3OJ2gDIlLa1GjdZWeWshQaFEcZJNV2jtOoOLmRFiXKm/apSLDPYqE+WB8IMdmuApTwLleETB6wEBMLCexqDvk5RMtOIyuth/7jrIRGwdi/UxalmeTpZ9DNNYXqBCqf41bz8flBkmhwbZTpjK/HgvAljNegdqTz5tcljkWWhXgPm9J+O3Pq3+XrU4QUwx5sLNP+vVb8PzZ6R4V3ZjB9RnKk9vYQ25KXfYYKGWDE4BWt3cgi38aw1v9TjTjCGMDZFk0uNOjeY+gD1Qv0gK72Ux/9FUzD8GEuOR7gZq+8i/0iedkHmzj2/OC7izKF116D9LGPfI3N1VgVa2wP/Fx73KO5apI3OnRcsDdLTBNSU/+BtOgGuX65EdKtXVn3NqBQ2Gms73LpW8jLFBN604j82qkc4r+4uppECAeY1ZHg3gEbQCTt4iLbmO4wWQ4IJEjbcI7WcCvcm/25xEn54PGGkvRrUs4Rmmbi1Yxg5uEudrLQ1OoV6svg9k5SQF0ekNtvByQOQdGeS8NYJ4TYLx9eGhA96LCbhuaESmOSvEgF4ntzubmrr7U2eKCLVOdpsk1zO/gRHtxy+j4g/Uzx+xUobID2paQSFUo/RHzcSHXhlnOn+Y2QeAAbhMyztm3FBPwV9uOq/g7S1PKsxGXc92V2DjDAeK3t2NISUYakofN1lSsXgRyciPOmZshThhw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(39860400002)(396003)(346002)(366004)(451199018)(83380400001)(41300700001)(186003)(66446008)(9686003)(26005)(54906003)(33656002)(316002)(86362001)(7696005)(6506007)(478600001)(71200400001)(38070700005)(55016003)(110136005)(66476007)(8676002)(66946007)(4326008)(64756008)(76116006)(66556008)(2906002)(82960400001)(122000001)(38100700002)(5660300002)(7416002)(8936002)(52536014)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?szAv+8HSSytym7qOciZRLRnQXHr+5vKG6PUGc5B1cjId9e1r2mRpYlSeI7+R?=
 =?us-ascii?Q?RdRe78OucXc1orcIiXAF0x9CrlFy3n9tF9ZPU9rPO8iDgnc+mokzaqrhnW0K?=
 =?us-ascii?Q?P2r0flgkur4+IRJjzfRnQs1Wl5ZfAbwQKEdk0UkFtnLAmRE0qFaONzaMCegb?=
 =?us-ascii?Q?NWgECN0k+XN5E5GZWnQl/LBttUKXoZ6P8AvuECcKbZTFvEP8AR7zk4EymoH2?=
 =?us-ascii?Q?/l2D5obwFrNwRWg61Ktek19nmEAm8jOPUfgAP/by+1mtGdTwXSqvk+BXj+V1?=
 =?us-ascii?Q?NfpEzIhGG4/cFfqz/jRHMzSBYI3ag/rUqEk5+lUj+8Y93ZNhVlcX5wdcEQbk?=
 =?us-ascii?Q?lg+KCJ5MLaRkfMtytvtJmVRa+Ym1SseznEOBdPoDS2egl1qqioVRqIOosq6Q?=
 =?us-ascii?Q?31qJ4vg6DAQZf8AWXEYXXmgzL2D6uEm2GSa5XmvUlJvKD+VPbY1VQ2dqZFyl?=
 =?us-ascii?Q?dWQVYLbhFG7LaAusZCEPSaNZYbMCw5PjQXKQmNqOWX4yIEnYSa7bA3gaMsq7?=
 =?us-ascii?Q?QrcQ+YWBqAHww/GgI1zD8O/3wpVyKo/+YSYDuCiSk3+O5+Vy6gGb/6V/r3yO?=
 =?us-ascii?Q?XVQkJTg4yM8xeF9ms7hWTnQia2UplDQz4wj2BxlM1lzghEcuXKRNg3mm+SwY?=
 =?us-ascii?Q?fZ6hmaNkEvGmLJC5UDlUFjuOb+gEHJXkdrqiYbJHyAFYePbJcYCGWCVNpwCr?=
 =?us-ascii?Q?1SniOp9o0tFDNX6hvRqGFj4YAA26lmPTfzaC5ofUdp8mbvGbMcvpNEXo7TFv?=
 =?us-ascii?Q?iHku7iOs6eNf3yeboV6xxa7CvQUyAPLL0Iq0rq1A+Gzq/6AnDXjtzHh34Bex?=
 =?us-ascii?Q?zcy23DYSc6Vs/wMLk3VpbVtB5tgxrdcQ1oqs+X3VvJwiwIb0vo5q5Wp1AdIO?=
 =?us-ascii?Q?DU95LOpxs0n7FXSabY4Ctt+su93LRFvApfhx4h9kOUqq0OFaUB5xmNCJr0mN?=
 =?us-ascii?Q?NOqxiiO66E1zxPC3pzmNgGAQ4Oax/9a8TOsBfVA+uoCOTvVw9Fz0hfR92zGV?=
 =?us-ascii?Q?srTOEd1fpYnAPHZ5OBfiyOYjsvGLb10lxM+pAEuLOLWgRQnaxsJOjhWuJ92l?=
 =?us-ascii?Q?KMMC3MkOMn69uhOHIWYS3Qu2lsNkn6dMKcb3mt3YaBtcM1KH9Yg+p1fIS44v?=
 =?us-ascii?Q?b31Vc4W3pUjW96wsxkZzhCr4tf3JvkhiGWbgMr5Ln+efdd9yVm0yQPyz92if?=
 =?us-ascii?Q?FSnEgEhNgWpg8jwMvuDLRVqFryWs4pJ72VQ85ql2ZlgYmefFnn7/68UJcXLt?=
 =?us-ascii?Q?MsDR8ZwoLs40OzvLp3lVfIGi7C/UTrQvxW0NQ1xSbmVv2d4sS3pqd9LokGww?=
 =?us-ascii?Q?Ck/qLpOGIbvid2+g6Q4mql8sZaak9j2hyhXA7qo+CKjY1DzFiMoB0Xz/TVY+?=
 =?us-ascii?Q?4f4HD3Y0Yo/wuPIpo6wafMU8MyanVJwFY4pJwQOgK4xaoTdZoDapiWlpyzBO?=
 =?us-ascii?Q?nCJn/dZoaLJOYwxSU5ARDwdv43NbCmkGOmbcmJ8fW0C1ixHMjscniJebiwLp?=
 =?us-ascii?Q?4mEqvrr0vVSbtNvxHxhx2Ajqb9LWaR+mOEXbITfz61AeVmJnaBUJHDl2Jk84?=
 =?us-ascii?Q?O/xMsyuCVDhjtu0c5Jef5Y/uNvxuV+WWmp6U2Dwp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe2f3e31-0b4e-42fa-3783-08db14aaad27
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 07:59:08.4456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t4Fox2seVqvaUgWKYr4chfABg3AYrKz1RyL0WNMfBgfr3c68riz6AI7utFmZTiCC8TQ6qcXEQoC74TcHyffo7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8091
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
> Sent: Wednesday, February 22, 2023 3:44 PM
>=20
> > From: Tian, Kevin <kevin.tian@intel.com>
> > Sent: Wednesday, February 22, 2023 3:40 PM
> >
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Tuesday, February 21, 2023 11:48 AM
> > >
> > > +
> > > +void vfio_device_cdev_close(struct vfio_device_file *df)
> > > +{
> > > +	struct vfio_device *device =3D df->device;
> > > +
> > > +	mutex_lock(&device->dev_set->lock);
> > > +	if (!smp_load_acquire(&df->access_granted)) {
> >
> > there is no contention with another one changing this flag at this
> > point so directly accessing it is fine.
>=20
> make sense.
>=20
> > but actually should check device->open_count as v3 does. Otherwise
> > the last error on copy_to_user() in ioctl_bind_iommufd() simply returns
> > here given df->access_granted hasn't been set but .open_device()
> > has been completed.
>=20
> If copy_to_user() failed, vfio_device_close() would be called in the
> error path. Then this close function just returns.
>=20

yeah, I misread it.
