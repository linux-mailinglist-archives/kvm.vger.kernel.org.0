Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873406D938C
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 12:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236102AbjDFKDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 06:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjDFKCw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 06:02:52 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1974C37;
        Thu,  6 Apr 2023 03:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680775361; x=1712311361;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N5T6yelGk+wPHNSMDdiPStxRw9qATQ95VH2iEkL0LyY=;
  b=O1il+vdKBV7z2QbKKv6XGdwORg0+gq4wuOuTScbJgAG1zBuTHugNG2FD
   X2Iz7WurXmUVmO6k2jDKEuGDA1Uf+Gu/4KFC3WedCfsBWhIwRe/wlQAMx
   vJk6jsgTNhXkLXksEULrfXNIar6kiLaN5jvEXBXXBklyBYaGpn4PpUJkd
   U+zNJiYhKn+8/oS5kGr1B5JohgCp9b7OvzIwkyq5ZQuHSewcK4+5rsXPQ
   SvdsZlE7aJU1RAd1VsCNQ0zCKFNJ0OJo9zRhnJ+Yu0poVGs8ON73Eeqqm
   ngomvaHj+wKcl7/LdXptwmvcuI1bGCcD2kS5O+skK6xOl5m9yx+tVxBvz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="428981155"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="428981155"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2023 03:02:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="664383355"
X-IronPort-AV: E=Sophos;i="5.98,323,1673942400"; 
   d="scan'208";a="664383355"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 06 Apr 2023 03:02:13 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 03:02:13 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 6 Apr 2023 03:02:12 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 6 Apr 2023 03:02:12 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 6 Apr 2023 03:02:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QBX7Gl4CjFB6c3jyrOz3BHIKfrYL4gpwUwQm+WZxPentLEkPUo/B29HyJhAAsq9XzFclilcFyNmsqxtwpltHFoGTO5BDsoUhXMScbkSMafXb6iR6nuvloKa77Rk2x7tOYTy/73Yxv8u0zK7++hK0sr/dONLa6g10GqmgrF0EDsvZuOgk2MXmDvnxESJCjorBDrfqV4NQn8KSe81ZFTTfBvuPPGanM1hmBlvxd1YC+ibBLRWMJGzWV0yGHtgNdXaviTiq7ZLE4tecwC0ZUl/c/e8r/Ordhx4IJiLefm9yQQf/6q/yWQ3Sg5GmC3bOmX/mhjVFvW1130jeIqZOqNM2Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Afn4AVysyv+Tc668WxmtVihNcY64x8bwTJj6e0rIUws=;
 b=Jgoj8lWQ7jWtHgTd1u/EIwvizONut07pBM3UrWgHQBGmEk+7KTnGwAaP19NvjZmOndVSJprxw1/uCReb4dy3P5V+J3BypbgcUia2DzK/TxNU0j0e3gzc6BJp4nZ67VzHI/VnJ7GhYWL0nQKURorhSFqCTi6vjRiEza2TzNkvba10AxS68uKZXabfpYg74a3HX9Zg89dJzmhfPw92mVPqKXeVN8hIpyQNSvNUn1S2qzDeziJSKvTkTgXkV29FSiO9713hGaAad0Hb1qx8BKV6BoG4im0bGAPyYKFFXZTVJ6zUBs9OlAUa6sT2iLkYIYK+N2N18VN8qnHqPtrudaQNAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MW4PR11MB6809.namprd11.prod.outlook.com (2603:10b6:303:1e9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Thu, 6 Apr
 2023 10:02:11 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 10:02:10 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8cqG8AgAAcMGCAACibgIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAO30AgACaIeA=
Date:   Thu, 6 Apr 2023 10:02:10 +0000
Message-ID: <DS0PR11MB75292DA91ED15AE94A85EB3DC3919@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-13-yi.l.liu@intel.com>
 <a937e622-ce32-6dda-d77c-7d8d76474ee0@redhat.com>
 <DS0PR11MB7529D4E354C3B85D7698017DC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230405102545.41a61424.alex.williamson@redhat.com>
 <ZC2jsQuWiMYM6JZb@nvidia.com>
 <20230405105215.428fa9f5.alex.williamson@redhat.com>
 <ZC2un1LaTUR1OrrJ@nvidia.com>
 <20230405125621.4627ca19.alex.williamson@redhat.com>
 <ZC3KJUxJa0O0M+9O@nvidia.com>
 <20230405134945.29e967be.alex.williamson@redhat.com>
 <ZC4CwH2ouTfZ9DNN@nvidia.com>
In-Reply-To: <ZC4CwH2ouTfZ9DNN@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|MW4PR11MB6809:EE_
x-ms-office365-filtering-correlation-id: 84b37b7c-0df3-4eec-ba56-08db3685fce3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s7CSWbmHBbwLqhjVEkLE7dVukdCd+p4LFxPjjUk9kH8h3IXR96MY/Tsfp0KnaogDDxhgXwLpge5gZK+vU54nw6tYdxwkGNzr2qu8xoWuosgQu4Ej18sCa/LRVjGc3AoTkO3AawKPHiZAF1wLcklLc2ccHHGsnQpVbbM+zEy6znI2vxip+4AfIFpDfl+ObOCtwMr53v3jb2WYQcKAQ2gzWS7DYQN5bTIBJJzMX9TkIC064FMdo+LcxUZ0mzlEeHtt1BHZbX0tOZ4I1ZZZNP1E9x9y9V7JJMid0znQE1RoObG3sumFogRmhhnJwdocGB/sOKxSnKTlt+GOaU4lz39pbvZTPWwWhcOGmbWF4YdK35KLNXQ4GIR1xW29bHrLnfGQcOp/9KZnGOTXNv9eccOvaaNF3nnX34ze64WBROAqgZA5da6j0zYaIzc/gFcsUxN3MyVKK4fbm3poLaiXOpNnFBIKqxKij8jIUg8d0ZkMInOJrN1Dm6QBnB91WgbqE2OduNMBv87pBDrVT+7kiVJxKn1KstWJWc/V+dvXQlJVUbq6Q+Xa8oL+SHc2wPak9IvGdGULoT/LPQMX/9HkkhPFHDkRxdGa2Tz+MnvkSQB9/uN58gleuD/kjvAJKhbY5OrG2U60o+E6vry4RkSb9s3Cog==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199021)(316002)(4326008)(64756008)(7696005)(8676002)(66946007)(54906003)(966005)(83380400001)(66446008)(41300700001)(110136005)(76116006)(66476007)(38070700005)(86362001)(33656002)(66556008)(26005)(9686003)(8936002)(6506007)(71200400001)(7416002)(52536014)(5660300002)(478600001)(82960400001)(186003)(122000001)(2906002)(38100700002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tNwgNtkbSQpHdWnvb30UGflNChoHypEccYhhz+qGpnpM0EoqE0m+uDVJpaD6?=
 =?us-ascii?Q?voVKIPmskb8ZmahZaT6GAhE+Y/rnRbShZvQgry3bsLE+FdlxVMwK8+2uXKi4?=
 =?us-ascii?Q?qnimpQMUEraV1K+YoU3WbQ39PdLR5Y7HKw9Hw2SiYS6IoQsLnugGu0OilYJS?=
 =?us-ascii?Q?TAkunORZIx/ciX4IsuC60oQVcP7yewDO32YDjm2OCzlgXfg3qa0DG+N4Jgn+?=
 =?us-ascii?Q?M69VjsUGmBHgVdmSuvgAqIXe1ticQnFeFECBEzEO15JvLjRJKVGfTzCv3/xs?=
 =?us-ascii?Q?uu8GRlAEdfGM34dPN1s04+RJUxxoPe1cnV3rbT9HpKMAUv/2hlyD08Pw3Ty8?=
 =?us-ascii?Q?A6hD5HW/8dCzIhxS7yI4MSDPvo8oF13bhqIOElr46dqytEwzhKS9LBlFDYcc?=
 =?us-ascii?Q?K0vni10X+r4vuuBKnsUMyODm+ysczmgPjzO4+fyZWZsSwjvhEXF44TI1yRHL?=
 =?us-ascii?Q?N1iRYIZjH5wdvXOgTm2GLO/s31f29gbi0zrR759FH4a8AM1ljPoT4Tyqj0eB?=
 =?us-ascii?Q?EDpl/AL17+JSnVwQJeFonKYTkRFpD6acsz1zacpqN1H+wz/dXKecrLF5+Cgo?=
 =?us-ascii?Q?hZ7xtVF0pGC7hNWRxkjkIafiFThRiMPpoqG4IsiKGhBm+9xnQn1nnW/Vo8cy?=
 =?us-ascii?Q?EYYPvynEkZjGZtxU0iQxxO7AvfFbPRT3mkPJXF6eeyFLPSEK2uPBssMkupjj?=
 =?us-ascii?Q?w/ycloMxxSpPBPIdHFvC/QNKUrKvC8s1ipBZcVZzpryGLwzFlaqX3nfaGhZr?=
 =?us-ascii?Q?RsRFoY+3WfwAH6ZuVMbdJngwAw3w/lYAsIfx1QnVxmi/nxVPHeyXtGG9X1kE?=
 =?us-ascii?Q?+2s2ep9n7dj/4etdlXRmTe72VE8Gh7dsBn0ldD+EFeooXJQktl8uJe6GVnxp?=
 =?us-ascii?Q?I82VwIldQ4BYumy9dGmnJ7RMVmNm/iCCXyky2y/KPtQGfWXjHYuUoVygAG/7?=
 =?us-ascii?Q?Fl3yZJTHLdmOB6Y9MwtmP9HGW7FsS465pwmJXc4v0+LBg1CBevo8f2bKdUik?=
 =?us-ascii?Q?WVAifLRn1QLtp5WzHzeGPQaPgj5n/p1LxSepgxbIh4ZnCfbdxz8dFNTavaSF?=
 =?us-ascii?Q?Xd3E42IhrgqGrHPRmbfKSQAcLYrKLW4mfbr0KLLICv0nT3PreWhgwJKpPko6?=
 =?us-ascii?Q?J/BdAwMcYcJxszAy4ITlxL3vbn3SFxjHvNZbHQy7dnPICIdwLipmG4aUXTxP?=
 =?us-ascii?Q?HSB5/7O7hiMC9rLFo9kInzwT9GW0WW6h34Sms6X1eX6C0ZMQNpW/MC/7+c51?=
 =?us-ascii?Q?Rtp/ZOMlfxfAcAqwRh5Rs67odyqgxLsPuB5n2sseb9b7iDwTJKmILsmNM8dF?=
 =?us-ascii?Q?/hWHiUdGZmhn/Fcx43nTis3iOv6x236GZZVWntaV3/u6JMEjG76cZlh0KaqE?=
 =?us-ascii?Q?lFkVsUrPKGMUdxvHOvxNicaarZ/WZwhxuQCFE5AXwZUV7F3MK1Y1dVGHSTYp?=
 =?us-ascii?Q?yKtar900EfDLO8kyqs29GsLE4yM+71Y90w0o8jxR6kaflTfpSu2I+/XfmLhx?=
 =?us-ascii?Q?BnjQl6XkNMhkTfUDVjF+KNDn9L6cVRLDZt1Pe0Wf733QY5ISGYUebb4Cho+T?=
 =?us-ascii?Q?fO/3iIWlNhbitJC+iSN4dNuRppUQRFX5GSR1E8fD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84b37b7c-0df3-4eec-ba56-08db3685fce3
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2023 10:02:10.4219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3UOzJtC3GcOo47vaXNTHFub1VDhYQ83cAD1i6QFKHjZrNynqA9XLu0iT7BsL6nj0nNTcS06fo0g9cH5HuJfS3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6809
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, April 6, 2023 7:23 AM
>=20
> On Wed, Apr 05, 2023 at 01:49:45PM -0600, Alex Williamson wrote:
>=20
> > > > QEMU can make a policy decision today because the kernel provides a
> > > > sufficiently reliable interface, ie. based on the set of owned grou=
ps, a
> > > > hot-reset is all but guaranteed to work.
> > >
> > > And we don't change that with cdev. If qemu wants to make the policy
> > > decision it keeps using the exact same _INFO interface to make that
> > > decision same it has always made.
> > >
> > > We weaken the actual reset action to only consider the security side.
> > >
> > > Applications that want this exclusive reset group policy simply must
> > > check it on their own. It is a reasonable API design.
> >
> > I disagree, as I've argued before, the info ioctl becomes so weak and
> > effectively arbitrary from a user perspective at being able to predict
> > whether the hot-reset ioctl works that it becomes useless, diminishing
> > the entire hot-reset info/execute API.
>=20
> reset should be strictly more permissive than INFO. If INFO predicts
> reset is permitted then reset should succeed.
>=20
> We don't change INFO so it cannot "becomes so weak"  ??
>=20
> We don't care about the cases where INFO says it will not succeed but
> reset does (temporarily) succeed.
>=20
> I don't get what argument you are trying to make or what you think is
> diminished..
>=20
> Again, userspace calls INFO, if info says yes then reset *always
> works*, exactly just like today.
>
> Userspace will call reset with a 0 length FD list and it uses a
> security only check that is strictly more permissive than what
> get_info will return. So the new check is simple in the kernel and
> always works in the cases we need it to work.
>=20
> What is getting things into trouble is insisting that RESET have
> additional restrictions beyond the minimum checks required for
> security.
>=20
> > > I don't view it as a loophole, it is flexability to use the API in a
> > > way that is different from what qemu wants - eg an app like dpdk may
> > > be willing to tolerate a reset group that becomes unavailable after
> > > startup. Who knows, why should we force this in the kernel?
> >
> > Because look at all the problems it's causing to try to introduce these
> > loopholes without also introducing subtle bugs.
>=20
> These problems are coming from tring to do this integrated version,
> not from my approach!
>=20
> AFAICT there was nothing wrong with my original plan of using the
> empty fd list for reset. What Yi has here is some mashup of what you
> and I both suggested.

Hi Alex, Jason,

could be this reason. So let me try to gather the changes of this series
does and the impact as far as I know.

1) only check the ownership of opened devices in the dev_set
     in HOT_RESET ioctl.
     - Impact: it changes the relationship between _INFO  and HOT_RESET.
       As " Each group must have IOMMU protection established for the
       ioctl to succeed." in [1], existing design actually means userspace
       should own all the affected groups before heading to do HOT_RESET.
       With the change here, the user does not need to ensure all affected
       groups are opened and it can do hot-reset successfully as long as th=
e
       devices in the affected group are just un-opened and can be reset.
   =20
       [1] https://patchwork.kernel.org/project/linux-pci/patch/20130814200=
845.21923.64284.stgit@bling.home/

2) Allow passing zero-length fd array to do hot reset
    - Impact: this uses the iommufd as ownership check in the kernel side.
      It is only supposed to be used by the users that open cdev instead of
      users that open group. The drawback is that it cannot cover the noiom=
mu
      devices as noiommu does not use iommufd at all. But it works well for
      most cases.

3) Allow hot reset be successful when the dev_set is singleton
     - Impact: this makes sense but it seems to mess up the boundary betwee=
n
     the group path and cdev path w.r.t. the usage of zero-length fd approa=
ch.
     The group path can succeed to do hot reset even if it is passing an em=
pty
     fd array if the dev_set happens to be singleton.

4) Allow passing device fd to do hot reset
    - Impact: this is a new way for hot reset. should have no impact.

5) Extend the _INFO to report devid
    - Impact: this changes the way user to decode the info reported back.
    devid and groupid are returned per the way the queried device is opened=
.
    Since it was suggested to support the scenario in which some devices
    are opened via cdev while some devices are opened via group. This makes
    us to return invalid_devid for the device that is opened via group if
    it is affected by the hot reset of a device that is opened via cdev.
   =20
    This was proposed to support the future device fd passing usage which i=
s
    only available in cdev path.

To me the major confusion is from 1) and 3). 1) changes the meaning of
_INFO and HOT_RESET, while 3) messes up the boundary.

Here is my thought:

For 1), it was proposed due to below reason[2]. We'd like to make a scenari=
o
that works in the group path be workable in cdev path as well. But IMHO, we
may just accept that cdev path cannot work for such scenario to avoid sublt=
e
change to uapi. Otherwise, we need to have another HOT_RESET ioctl or a
hint in HOT_RESET ioctl to tell the kernel  whether relaxed ownership check
is expected. Maybe this is awkward. But if we want to keep it, we'd do it
with the awareness by user.

[2] https://lore.kernel.org/kvm/Y%2FdobS6gdSkxnPH7@nvidia.com/

For 3), it was proposed when discussing the hot reset for noiommu[3]. But
it does not make hot reset always workable for noiommu in cdev, just in
case dev_set is singleton. So it is more of a general optimization that can
make the kernel skip the ownership check. But to make use of it, we may
need to test it before sanitizing the group fds from user or the iommufd
check. Maybe the dev_set singleton test in this series is not well placed.
If so, I can further modify it.

[3] https://lore.kernel.org/kvm/ZACX+Np%2FIY7ygqL5@nvidia.com/

Regards,
Yi Liu

>=20
> > > Remember the reason we started doing this is because we don't
> > > have easy access to the BDF anymore.
> >
> > We don't need it, the info ioctl provides the groups, the group
> > association can be learned from the DEVICE_GET_INFO ioctl, the
> > hot-reset ioctl only requires a single representative fd per affected
> > group.  dev-ids not required.
>=20
> I'm not talking about triggering the ioctl.
>=20
> I'm talking about whatever else qemu needs to do so that the VM is
> aware of the reset groups device-by-device on it's side so nested VFIO
> in the VM reflects the same data as the hypervisor. Maybe it doesn't
> do this right now, but the kernel API should continue to provide the
> data.
>=20
> > > I like leaving this ioctl alone, lets go back to a dedicated ioctl to
> > > return the dev_ids.
> >
> > I don't see any justification for this.  We could add another PCI
> > specific DEVICE_GET_INFO capability to report the bdf if we really need
> > it, but reporting the group seems sufficient for this use case.
>=20
> What I imagine is a single new ioctl 'get reset group 2' or something.
> It returns a list of dev_ids in the reset group. It has an output flag
> if the reset is reliable. This is the only ioctl user space needs to
> call.
>=20
> The reliable test is done by simply calling the ioctl and throwing
> away the dev ids. The mapping of the VM's reset groups is done by
> processing the dev_ids to vRIDs and flowing that into the VM somehow.
>=20
> We don't expose group_ids, and we don't expose BDF. It is much simpler
> and cleaner to use.
>=20
> A BDF DEVICE_GET_INFO and the existing reset INFO will encode the same
> data too, it is just not as elegant and requires userspace to do a lot
> more work to keep track of the 3 different identifiers.
>=20
> > > This looks like a very complex uapi compared to the empty list option=
,
> > > but it seems like it would work.
> >
> > It's the same API that we have now.  What's complex is trying to figure
> > out all the subtle side-effects from the loopholes that are being
> > proposed in this series.  Thanks,
>=20
> I might agree with you if we weren't now going backwards -
> ideas didn't work out and Yi has to throw stuff away. :(
>=20
> Jason
