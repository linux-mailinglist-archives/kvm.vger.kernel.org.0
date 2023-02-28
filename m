Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B406A5173
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 03:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjB1Cvy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 21:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjB1Cvx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 21:51:53 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CF226855;
        Mon, 27 Feb 2023 18:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677552711; x=1709088711;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nURuqyak6WUacSxNAuA0mshtWSpHQ+rZU7nHFdz2VSg=;
  b=hys5voks/Kvb40Dn5hTQBSOcZlDKHw80OMX7qXSnsrIpCYRdTQ35Sltt
   UN3HelDHJ+9VCKLt3IH3DMjSNDkCnUu6KcSSBfxIZyW1QbGm1aVHX/kM9
   +MLy7du151gdLrCRVhjwjpFzZ9ERFosKwXCNmou45lTo11s7i7sGUqMr8
   uVeRkl+xBH/xm1aQ79vY6+c5uey0kkUTiLbeWw/W5VlVYIz58wlir9OsC
   SLEd2eVSmG3UhVi6l4jbHHzpRa6R66sWVR45Hzc2EP4MXJ0/GQfsYlsBh
   TqlbaMGGoTKrV1rWnF+xO2txmgtmDFprR78tBeLpoN6nZlGgHgVpB8rdV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="313705900"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="313705900"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 18:51:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="919608181"
X-IronPort-AV: E=Sophos;i="5.98,220,1673942400"; 
   d="scan'208";a="919608181"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 27 Feb 2023 18:51:33 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 18:51:33 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 18:51:32 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 27 Feb 2023 18:51:32 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 27 Feb 2023 18:51:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jiYtOntH9Q4EMwAPlpihpCEBXiOhpRaf2R3S7PGe2UdBy3Bib+Gf8p+OAv1D/IoLX7sYQl+M85u3bG58euZmo+Vf2W/z02ulECGiqZ7RmD4WvR9SClzaUpduc9e4yxuEonmxdocs8L8JEKiXfC8Q9MycIr2zjWqTasRTNQbiMBp7qWeE/zkrPspcY4w3rvYhCtF5bh81CVWNtm7mTHQPs6QygUd3H/EnpXW+kNYTJIC7L/rWvSTUelbebR2LcpFJzbVrTz5W1If5BpsYEYtLniAr+hhJhjrxybikEqDV3lU9YtRrla26YZaMODYj/GHUH4CutQccRnTe8OkeHm50/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GjtOuSoIKRz0mqDRjsCwkhufLEGsTQwcA0w+XrxjMbk=;
 b=aADkcH/BqERUDckW4Xvv/3oMUoBXDaKqgV0s7k/9xfBp4XD+dV9YKQZBTaqfSXfdsd+YR4VfJhKmLqOrqwlMaUQ3h+62QiJpV0+QzA9Fu1Jj5a3BtEt+TcYWZXkUzPpD+gz2yF+ZUeTWNyu90jv1BY/r7pJnbvviN2OvKYESN5IYttYeqFXh3NHMRnNP8sBsqFZjWanafoUnegtCDoHqREon8imBGI2t4433jzgrUlOWkfuycyz7fPctOFCzv/i9QFxu8O+ibefghwmaFmRmjPHH9voI/s1p1BOeC+cUmCpF1KPL4EqM6sTIWc5tMcvqdcB4B+d5r2YdYSmDvrp8Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ1PR11MB6202.namprd11.prod.outlook.com (2603:10b6:a03:45b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Tue, 28 Feb
 2023 02:51:28 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%9]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 02:51:28 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Thread-Topic: [PATCH v5 17/19] vfio: Add VFIO_DEVICE_AT[DE]TACH_IOMMUFD_PT
Thread-Index: AQHZSpxNXWm9KiWJ2Ee0gC65QSF3Ja7jIF2AgACHHYA=
Date:   Tue, 28 Feb 2023 02:51:28 +0000
Message-ID: <DS0PR11MB75293EF02CB0F0A54A22D943C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-18-yi.l.liu@intel.com> <Y/z400uzn7Nk0CXe@nvidia.com>
In-Reply-To: <Y/z400uzn7Nk0CXe@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SJ1PR11MB6202:EE_
x-ms-office365-filtering-correlation-id: 9f46c0d3-1005-4be7-59b8-08db1936b0b8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RDJBOQYHCrQY5h8VaW7dN18J4Z2tAHscACrpYKVjjjkG7K8J2Alrr8pODcN3ilbZjs9PGaeMbgyw/+af2PQhFXep0WeKxpBzmBm7ue3YZvYWMVWou/yr3LHqDFWy3uv+XihIzNEnM6V7ViCweETRO5y4EG76+zQ8xReBG8TsNnQHou46EfBKU6avpu2puEJTvth+0nNdF9XMqoBAeFicjqaJ06xQuv6jGpl2c+GGU29M6xU5XL78uM2LXHY9YnMSUCvxDn/D+IpdbQKDL7GqtQ7GSPDqUni9VqNKKWGmLsd4lIczYx8VqGWEIUFIYzMEVrMm6w3h0FSQlth8P+jWu9kSV/4ORgnyhxGHBh28gv2437SrMKmIHRhUszkyx5Ev1wOorbmicu0nBvFAag2BKCg7/BS8ljdLwe4EOweHrXNIHFqnCLojWrPkIk3/aSrwE4X3MakjxPwdBP3e7MgqukUCHTbGG+KTZ6q2fP+5To+xxlEjz0uZCtLluuMQ3PWtDGCCcM43ipOdaNgoYy/46Ak344YyN1TmmLI62IUaWEXEfEqCTpuU+cKElSxtdOFBVQ3GqHFHzIk3QMe4BXgWWsACeQfoUSjmu0mOB1hiKzumUlxxMMl2QqOfSFZ3mUPjvWF9E/RMjFXSxvRQPJW4qfFSexeVia/AbJiIAlCGIpDvMR1nBgRkt+W2yWg0haNnlmEqhaiygmP5uepwyZcoccog87l4jZv/dMRvDzKYVGk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199018)(54906003)(83380400001)(7416002)(2906002)(71200400001)(478600001)(86362001)(55016003)(82960400001)(6506007)(9686003)(41300700001)(8936002)(7696005)(64756008)(33656002)(4326008)(8676002)(38070700005)(26005)(66556008)(66946007)(5660300002)(6916009)(316002)(52536014)(66446008)(66476007)(122000001)(76116006)(38100700002)(186003)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kBzmp3VfZrV5eqQJAwGPa9nfNVWNlsEDPFu94QyJPIPoehgti0GT4yt0uF6I?=
 =?us-ascii?Q?i8HK+GJpv14GQMEz79bH67oDHGZbTtRq3uV9yY84J2aQ1YWx1dXCqptpi0TC?=
 =?us-ascii?Q?1Fj3Y2lgf48Ir/mlh/MCwSFJ8+5vYV3XZI1ZSjU7IsA2GMm5598xnPrwAJbu?=
 =?us-ascii?Q?bI1aahFqV/R3g6ViS5jrupHEbSJFAPgg3k7vbrWQG5RLUgGCvxQxxOyZAgwk?=
 =?us-ascii?Q?boG+s0L/IJlghoIXsVzew6g3ysvxDWSeLZKCZuaxCQarbOZo5UToTV20oRng?=
 =?us-ascii?Q?/0K/hyjjp02VPYVQo5xp/Juu32xzkpxmjvI0TjosW3rwjYqr+dEuy2dkS/M8?=
 =?us-ascii?Q?8qZKiJuoLgQlVlgK3TUOhUCJ1ya7PlUVMmYMda8h7rxTcNm3c15wXzNEiDr6?=
 =?us-ascii?Q?cpzZ801MouwobJwV4ABDMPpgB4QOL4Acy9Y38fzVEA6aGcERQFmpz/q7nVIZ?=
 =?us-ascii?Q?NRDe7GzgMkdXD8AB1K8lEV9NY4mXiSL/BHJ33FAnNbMg58LO4wVr+pIrzYGM?=
 =?us-ascii?Q?z/fWU7XDR/HjVVDtzwkUusuUUK/9SmWJ+iQAWLNzV1ZgnwNTBNYfnXQITd3L?=
 =?us-ascii?Q?cmxH/wDMs7iYiSmjPAUU4RBmv4NWRc4kh/mAU2UDmcwXLed4iPyBvmNcrAFh?=
 =?us-ascii?Q?ZDkerLmyU0YlJwhGCkyMJO7sKZM31/U8G+FYf/+Defswia6CpNWjAJx4jZaP?=
 =?us-ascii?Q?Q/AV3QpbLZtmI54nR9juNgw3UNuvogLLwHOwhFSRGhnW2wkNg8cxqrGvJeXZ?=
 =?us-ascii?Q?J1pcyMZOiXeeN2d4vkvSzSTWXrU9hzfcQnhauJokBI7wD4c6JBsTMm9QBOw4?=
 =?us-ascii?Q?Ayo/cMvJ8W/m2VDTzkAvg0NBbxF+mZoO9CKwOy7y2viP9J+3WNjgomyI/oKq?=
 =?us-ascii?Q?Kp9yPrXNk8vm++J1t7RpPo+Pj1U1uKbkmi6hvXzeLxT1quVsmCWo7rSXYowU?=
 =?us-ascii?Q?J1yqaTovL9cxqq/0CmJFVVeAtsaHT20r+oKClzmRy8MIkvNpGH/wVW7FtxTb?=
 =?us-ascii?Q?vwyfcfGcC1HqoKcFgwDAbfjGiD7ECBsYWdCOyv+9sBnmRHVO7NQacTqNAxGS?=
 =?us-ascii?Q?IzBa2XFP8kg/NkfLO987MT4Go4e2pXSdF/uNBG80BWk55n4wnPLRmZCrG7Ut?=
 =?us-ascii?Q?T7jDTX7UF4pcoI39G6z2GmTg5WIHdGPWDyfjNH8pPVPU5K3d8ISGYYPp5HHF?=
 =?us-ascii?Q?VfzLoAv/u1G24O+L4K3LvkIeO+lYt5OWMef6cOjDiDvODURe7VUz4HUKeIHI?=
 =?us-ascii?Q?FuufY9X9OwvHzGH1s5wZskGwQ1JvIO2YNHcMrfFzO4cGwTxdT93CYI60mwT0?=
 =?us-ascii?Q?62oxONKQ1IU0U1Bq9avXW7fKsKPTA2GizhrrlxrmeIwb8ZBCwcBaqtiFfgse?=
 =?us-ascii?Q?jDUOTXq6iqYe05N5MWRWfiMkUnISqr5bB0sfGBWRs0rCbWZoIRLoMg0CycF5?=
 =?us-ascii?Q?avj56+G3GCaLWw/QrG7HKXrDuRhqBZtZodRNotMaCa5Gw5LQh2djr9CYq//q?=
 =?us-ascii?Q?8Oxnk6IfaOuk6Pt0m5G0nQuqHGq6mdqQOBwmW8q12YnyzB9hYPMS3DsPzqHx?=
 =?us-ascii?Q?YADC6HBbUrEtjS0AypS5E4REPstSDYcrSIAH9Dk7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f46c0d3-1005-4be7-59b8-08db1936b0b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 02:51:28.6388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u96Jg0vJejH/9Whiu5n/apLeNrX2+N4O8LtruSeapq6OiwPFL3eIcQQ03DB+OHS+wKH+ysMCHC2f1vLQfgarVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6202
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 28, 2023 2:39 AM
>=20
> On Mon, Feb 27, 2023 at 03:11:33AM -0800, Yi Liu wrote:
> > This adds ioctl for userspace to attach device cdev fd to and detach
> > from IOAS/hw_pagetable managed by iommufd.
> >
> >     VFIO_DEVICE_ATTACH_IOMMUFD_PT: attach vfio device to IOAS,
> hw_pagetable
> > 				   managed by iommufd. Attach can be
> > 				   undo by
> VFIO_DEVICE_DETACH_IOMMUFD_PT
> > 				   or device fd close.
> >     VFIO_DEVICE_DETACH_IOMMUFD_PT: detach vfio device from the
> current attached
> > 				   IOAS or hw_pagetable managed by
> iommufd.
> >
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > ---
> >  drivers/vfio/device_cdev.c | 76
> ++++++++++++++++++++++++++++++++++++++
> >  drivers/vfio/vfio.h        | 16 ++++++++
> >  drivers/vfio/vfio_main.c   |  8 ++++
> >  include/uapi/linux/vfio.h  | 52 ++++++++++++++++++++++++++
> >  4 files changed, 152 insertions(+)
> >
> > diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> > index 37f80e368551..5b5a249a6612 100644
> > --- a/drivers/vfio/device_cdev.c
> > +++ b/drivers/vfio/device_cdev.c
> > @@ -191,6 +191,82 @@ long vfio_device_ioctl_bind_iommufd(struct
> vfio_device_file *df,
> >  	return ret;
> >  }
> >
> > +int vfio_ioctl_device_attach(struct vfio_device_file *df,
> > +			     void __user *arg)
>=20
> This should be
>=20
> struct vfio_device_attach_iommufd_pt __user *arg

Got it.

> > +{
> > +	struct vfio_device *device =3D df->device;
> > +	struct vfio_device_attach_iommufd_pt attach;
> > +	unsigned long minsz;
> > +	int ret;
> > +
> > +	minsz =3D offsetofend(struct vfio_device_attach_iommufd_pt, pt_id);
> > +
> > +	if (copy_from_user(&attach, (void __user *)arg, minsz))
>=20
> No cast

Yes.

> > +		return -EFAULT;
> > +
> > +	if (attach.argsz < minsz || attach.flags ||
> > +	    attach.pt_id =3D=3D IOMMUFD_INVALID_ID)
> > +		return -EINVAL;
> > +
> > +	if (!device->ops->bind_iommufd)
> > +		return -ENODEV;
> > +
> > +	mutex_lock(&device->dev_set->lock);
> > +	if (df->noiommu) {
> > +		ret =3D -EINVAL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	ret =3D device->ops->attach_ioas(device, &attach.pt_id);
> > +	if (ret)
> > +		goto out_unlock;
> > +
> > +	ret =3D copy_to_user((void __user *)arg +
> > +			   offsetofend(struct
> vfio_device_attach_iommufd_pt, flags),
>=20
> This should just be &arg->flags

Yes, can use arg->xxx here. I guess you mean &arg->pt_id.

>=20
> > +			   &attach.pt_id,
> > +			   sizeof(attach.pt_id)) ? -EFAULT : 0;
>=20
> Also:
>=20
> static_assert(__same_type(arg->flags), attach.pt_id);

Got it. but s/arg->flags/arg->pt_id/

> > +	if (ret)
> > +		goto out_detach;
> > +	mutex_unlock(&device->dev_set->lock);
> > +
> > +	return 0;
> > +
> > +out_detach:
> > +	device->ops->detach_ioas(device);
>=20
>=20
> > +out_unlock:
> > +	mutex_unlock(&device->dev_set->lock);
> > +	return ret;
> > +}
> > +
> > +int vfio_ioctl_device_detach(struct vfio_device_file *df,
> > +			     void __user *arg)
> > +{
> > +	struct vfio_device *device =3D df->device;
> > +	struct vfio_device_detach_iommufd_pt detach;
> > +	unsigned long minsz;
> > +
> > +	minsz =3D offsetofend(struct vfio_device_detach_iommufd_pt, flags);
> > +
> > +	if (copy_from_user(&detach, (void __user *)arg, minsz))
> > +		return -EFAULT;
>=20
> Same comments here

Sure.
=20
> > +
> > +	if (detach.argsz < minsz || detach.flags)
> > +		return -EINVAL;
> > +
> > +	if (!device->ops->bind_iommufd)
> > +		return -ENODEV;
> > +
> > +	mutex_lock(&device->dev_set->lock);
> > +	if (df->noiommu) {
> > +		mutex_unlock(&device->dev_set->lock);
> > +		return -EINVAL;
> > +	}
>=20
> This seems strange. no iommu mode should have a NULL dev->iommufctx.
> Why do we have a df->noiommu at all?

This is due to the vfio_device_first_open(). Detail as below comment (part =
of
patch 0016).

+	/*
+	 * For group/container path, iommufd pointer is NULL when comes
+	 * into this helper. Its noiommu support is handled by
+	 * vfio_device_group_use_iommu()
+	 *
+	 * For iommufd compat mode, iommufd pointer here is a valid value.
+	 * Its noiommu support is in vfio_iommufd_bind().
+	 *
+	 * For device cdev path, iommufd pointer here is a valid value for
+	 * normal cases, but it is NULL if it's noiommu. Check df->noiommu
+	 * to differentiate cdev noiommu from the group/container path which
+	 * also passes NULL iommufd pointer in. If set then do nothing.
+	 */
 	if (iommufd)
 		ret =3D vfio_iommufd_bind(device, iommufd, dev_id, pt_id);
-	else
+	else if (!df->noiommu)
 		ret =3D vfio_device_group_use_iommu(device);
 	if (ret)
 		goto err_module_put;

Regards,
Yi Liu
