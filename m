Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CDD6A5A0B
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 14:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjB1Ngn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 08:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjB1Ngl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 08:36:41 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2A126847;
        Tue, 28 Feb 2023 05:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677591400; x=1709127400;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=P3OVVosbfgWnBfOSHhzM5Zrl0L5ugRIfZ2lX6qOFdnM=;
  b=gcKxdCcHCcqD/NAdaRlxd/eeRqUdV811gICKfPRJnEmmtLbea/QcIxEN
   GFswfrrWThzIVAClDbAm7dAqkIrVvg2fNYnwrf2X2QSMISyKhcUFgPXAC
   j4T5gNsUAOOTQ/MMMqFnCIbhmB1gXe700YWykWqCcbEEC4kMYqy6GY6Di
   fdDDkPS6Nn92mGgRKEr/mivMKnLzIigdfBBnk+/2cRbzSFbnbASu9UVQY
   fHRsFP4Yz1+CPzG4/VLUQwNFEi3cCrW9o43sn42pZizlVXq7Ru1pq02SW
   W1F6CuAz+kfl3Q/wSDGLZjAfv3E2quAwYbANtUpaGsuYD4zkfAcFQ1is8
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="396702165"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="396702165"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 05:36:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="763175060"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="763175060"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Feb 2023 05:36:27 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 05:36:26 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 05:36:26 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 28 Feb 2023 05:36:26 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 05:36:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgibbbgDTa816bPHbcnzOcZ6GSAhD9lGLLL/a9TSWMIgMV7JQ/j13Yn8NN3exM2XkuJz4zbyJMSjeQ1mg1DnKfVaEP42nI3udyRvbT8mN5jl6E669a8oYIMJUb3APFzIL750lgwikzm/6EIQjQpAuanXfwVrrJ+3DH3n7FGBBqAkhK0Dvuyn1WxdLBAPAjuu6v5eJ83dpMCXimghm8rCLH8VH/M+V2WlPYF+LDiTVbm0fhsld4Pc81sZ6rgHuJtLb63xj3E7EWMLcYWfNo8bJfS83uo3t/bfrK8sI9V5tvSnEw8DyNmJ2/7k0+YZ76ELn86Qn3EvESb84fbElljgKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8a8KQBXlM8ndG8lvT6Yzrrcc2yWaeZm1H9GKNixktrI=;
 b=WYDdtxpttSGFHFoe7i7IH2503IKw5pB+Z1vh82ieNQ+VNHm6vqFTBbkh3o5wGnA8e+ous1cLrPfPV1ozT1G5ed9xUop7KL991S4Z9g8Uf0IMurI52RZ3tATbqgwIthAEoDK2cJ+Tmr33Z/d5pu8SWwPriZSu9XC0vJB89m2i53ka4L7qWGGEedIXgFqQEK8ZRikFzYbDMR4sjMTGRuYA9T8jXSsvCLd4tiboXxChvdyjAQnSRvaGEkGWO7btN8RY4exdsUVUUe6dIbKJsNP7H58dkhWoKpTE298o+ZGHy0ywgh+ryvITRRZGIL+xjh2ms3ZxPdGnUyw+pqYuCtWKkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SN7PR11MB6993.namprd11.prod.outlook.com (2603:10b6:806:2ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 13:36:24 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 13:36:24 +0000
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
Thread-Index: AQHZSpxNXWm9KiWJ2Ee0gC65QSF3Ja7jIF2AgACHHYCAAKSqAIAAATZAgAAE3oCAAAG0UIAABx8AgAAA9gA=
Date:   Tue, 28 Feb 2023 13:36:24 +0000
Message-ID: <DS0PR11MB7529175CF279A820C5E5E091C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-18-yi.l.liu@intel.com> <Y/z400uzn7Nk0CXe@nvidia.com>
 <DS0PR11MB75293EF02CB0F0A54A22D943C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/30TEk3t7q/D0Ho@nvidia.com>
 <DS0PR11MB752931AD2B92DE9A1A574375C3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/35ZTi69p9cCuPn@nvidia.com>
 <DS0PR11MB7529B6647B5F4B7691FFFBEBC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/4AzJbjeR4R2rcO@nvidia.com>
In-Reply-To: <Y/4AzJbjeR4R2rcO@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SN7PR11MB6993:EE_
x-ms-office365-filtering-correlation-id: bf5f98fd-2154-4054-95c2-08db1990c8fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NVSmaOtF8UCikoAbmdUnIXTQ9FFCcPEfER7g8kHFAxP3NSu4rH6a1oZ01zw5s+EQwB7zBdqk+PzBTjtUe3qz17GHJG3QPvb5xeG9zGrWo0txNqU5XsL2G278ydSW2xMQtdjERL85MC2tL6UKPel4VFSqBeGXWLAZdX3460qxq2rrZRjp7L60sRO+bxjeq8cQefCm96M8dcRbzrR2zmyjvcFxqPIb2lg9RueRU3a1lzGLMAGTL4tLFYItoJYJSJU38OrXF7e/C9U1lqvM1Od4cI4LOP4z39PX3JinOXMeK+pzwqZ6z6DvmqtNf/Mkcl49IE7rroF6lOHM1ZCZ6bMocVLF/dGSh6uT0fkU4G6xwqPsdXDwVIfkrkQKI5lViBzKkkJG6qeHt2c1x3dQwQDB2OnE2TumR6hfL/2IiMvxrnHiHoLb3aAequfGDQBmrMvq3WrSnMvOx22s+O7coi1tYGHFhs44x8PYrCNvppnNl/YfwqdMrtBAn3lcws9wu/KjBtmTYNIq6tGOHCfUQBPiL5rcIbvty2/tb+41P+hlFsZXKkwsb9IOIJq4G4BtsAzbYfiLzA3W0Z98JS4an2jvEJQO62gAXZOK+fHulwBcu6kGaiG8Q61wn57ksBhmg2FsyMtImxSO1xeMHAdlGyARkbsKWf90UjX8aSqI29Rsm6tu0uaxCDYiRpFRvC/xabJwkZe13p5dx7BSK5RRlRTTqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199018)(86362001)(33656002)(55016003)(66946007)(66556008)(66446008)(66476007)(64756008)(8676002)(5660300002)(7416002)(6916009)(4326008)(41300700001)(8936002)(2906002)(4744005)(38100700002)(82960400001)(38070700005)(122000001)(7696005)(71200400001)(52536014)(478600001)(54906003)(316002)(76116006)(83380400001)(186003)(6506007)(9686003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?msLUF4VgaZ0KNYZA4GpYllX6FbQbNx3V+Lgyjn59fuWI9kN98bqN2BrsyXg1?=
 =?us-ascii?Q?mwYE2wBJ969by8XYG8lYJpsoOhpbVaqNQzweAfN+EPDXPrDvisslYL+b5hRi?=
 =?us-ascii?Q?X/cJI93JGVV02kXdi0zii0/lfnnuChElL/inhsQQlzTbsXpGh1SZ6rd9P74s?=
 =?us-ascii?Q?Gab36umf+1AzhgLXGTW0q9NMTU5qzw5ki77cnmorFrPbFyaEcMFSGXyZ6NST?=
 =?us-ascii?Q?nu3qtuJCU4lOwbh3ulqVMH3bAJxniZxNI46/ES6YJDahChYVwe38PFtoeKJ0?=
 =?us-ascii?Q?qySG5V8oc0M510CUqsUOVJdGukZh12tLg6cXS+u9LxawjJT7gV0PlZRRjMXJ?=
 =?us-ascii?Q?sXCotw18+m5p8FC3BtJrdqSbtJQaRG+5OoIezLgD3KAHtWou1h+dxf/4QVnm?=
 =?us-ascii?Q?Hl6wbYZzPS1lA/inalNx3YWwKUakqMZ7k3pemmoSDgCDWP+5sw+9ZB/3pz7v?=
 =?us-ascii?Q?g116WCGULb/luvNuDIcTdXSkHgh6LVSYq6RNCYLZNWRsUZ5AcVzgewVRv/VG?=
 =?us-ascii?Q?j8iQansNHmisMk13PQQsz8PzwaoXMiy1u4hJtSbdVs2jPU4JYxNJHeLrWn7e?=
 =?us-ascii?Q?BTzLKKfcFMd+HXbwkaL0dZXK+HA8yHVhn1PJBBAH9fxq1itpvNo07ifIBTlY?=
 =?us-ascii?Q?tPQCFvaEIgjgW8/JEjeLcXsjyh8CbLPrDHiD9soC9PZfYfLqeDeZR58w77PG?=
 =?us-ascii?Q?IlzVbtAFu9ydsT9of8DTQs54BykqEvPkmmAOCB4bJKtB7YsrRkyEHpAQc0KK?=
 =?us-ascii?Q?0zCkT9ZTOy1yW8v+ZkMh9gn0YUCLkEqt8jBzniMx+Lih7VOaP86Z+OAc8vbF?=
 =?us-ascii?Q?ZBUAaSX/XUos0WeEVy0/nj1jbiFEHLFIcZPeTsqVSVWT++6zQPFtNWr5bbSa?=
 =?us-ascii?Q?P0qR5AZ/iltV2psu0+1Iv9fNrzXoiQtUGmgorkG01jZ4avFVVH8LAWbJ6mnE?=
 =?us-ascii?Q?C+FOM6Vz6Sb2MhknnSxT67T9k4QsarmMLxMZCH/KQIp2AW7MA8OkLjEtaXyL?=
 =?us-ascii?Q?6Zh6Db9zuP0FPg7ZaS067eNG4VDDS+Rj0GGIelwPlqWxLgvJgQe9htkifziK?=
 =?us-ascii?Q?7WcRDXE5tE3qKwAllNpMXyZePSGUSn/p5jRE9tmLrEuyupYIwB9uUJrdZwpr?=
 =?us-ascii?Q?KJfAypGHx5eqNKsCJgYcObZX2Fal/nesbfAQWa4zQNuEGXacRk51jm5orhcw?=
 =?us-ascii?Q?O8X4z2VvVTPoGxIT7liMAVsvyWye8era0BP+cFhG0M4CRmeNLb+MPz94f2CY?=
 =?us-ascii?Q?jWVVf33pV/ghU3GNwFMtZcuAmoSmDDQQuTnuhUJVA4u1DHBlPjUu7rb7u6uW?=
 =?us-ascii?Q?9kzZOy8mXvfwlZu+83WiBhwuQUtspU0b/j3/3cI9HKk+4aI0sa6LqGPmow80?=
 =?us-ascii?Q?1yG721axjfBY+5SPAs9VTYnhUvYjallAswsNbaLHdjtAHubIFage5ii4AZJ9?=
 =?us-ascii?Q?KTd4FbmcXizKxAAnwPhHEE8G4IiOFt4X9nKjwKrKiFsiWRxeZstyIZwt3xDA?=
 =?us-ascii?Q?7EPcGXPJCl0mkUJlOkYJ1kQAPHzpVNdqRXxHGDhRi9M5J9k0ot9s3NRMumFa?=
 =?us-ascii?Q?/YJVeduYxpZrdj2Y7u9iH3t7Y7RhT8te1xPGyzgm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf5f98fd-2154-4054-95c2-08db1990c8fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 13:36:24.0660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o69r9D+B2oD0GKm2Rot0foHSoAXpeILb3hxEeUSGpp88KRreEXSKBCZf/m1ipHZGquSHx3dH+JVwHLNyo7R3XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6993
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 28, 2023 9:26 PM
>=20
> On Tue, Feb 28, 2023 at 01:22:50PM +0000, Liu, Yi L wrote:
>=20
> > > A null iommufd pointer and a bound df flag is sufficient to see that
> > > it is compat mode.
> >
> > Hope df->is_cdev_device suits your expectation.:-) The code will look
> > like below:
>=20
> Yes, this is better.. However I'd suggest 'uses_container' as it is
> clearer what the special case is

Surely doable. Need to add a helper like below:

bool vfio_device_group_uses_container()
{
	lockdep_assert_held(&device->group->group_lock);
	return device->group->container;
}

But I'm poor at naming it. If it is true, the code would call
vfio_device_group_use_iommu(). If doing it in this way,
I think it's better to rename vfio_device_group_use_iommu()
as well.

Regards,
Yi Liu


