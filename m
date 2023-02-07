Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F5568CF42
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 07:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjBGGHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 01:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjBGGHS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 01:07:18 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE8130B37;
        Mon,  6 Feb 2023 22:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675750034; x=1707286034;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G3d3RGVJbbp8I6Sk0Ta+fhm810F43S6iwGpSHw1K8oA=;
  b=dUgCEzHtbWYSJ+3MTz7EeQ6QYW5UTBCPxX8775beNp9LShalPVC22ZA2
   6NzPiYb83IB7e3Tvv3jTwxbQpGFpPV6s6N/IE2WuJI7GBvuen7fZT8hUo
   kKycGfB8V4EU5ozEKWFLc8F5BW60Rmazb40WdjtOH9A9oshTWPs/EE3yW
   daZkDmBiwsSBSc5345U6wHrcS8OaCq0iGU38zcN2dzPpaGkUMUpSwuY69
   cY7kJegtgo07Aiuz5X5OTJKDz/0Jc1rV3D2s2rTdKtReigu0fTE/yhZbg
   I7eko04oML0bvyFVSDSCTJDMSuB26eV+fmuDXa6LZBFqR0te10onlDw2j
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="309749815"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="309749815"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 22:06:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="644321635"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="644321635"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 06 Feb 2023 22:06:58 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 22:06:58 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 22:06:57 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 22:06:57 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 22:06:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SdZXeB8AojgBmFjZUa1vusdB70YdbZ0tjkgptfPX7WexaDUDsi9HGQiBNxZJnadquIOQ2WeRS7PG8kcjHf5RRw579KT5LJyZBsPZAhZ0Zs3zq9YPWa2Pr6XLXdMlFakY+YZiWfBQtcZlVjwu1fWozOLYJkH+zyjM0M9Ekr3rzCWIKq+NKZwPML/LyBtBQphwXz9/i8xniuRqXXrO9P0zHxloU+6gP5MmSxeVvmTPe7WZn7PiVPK1c9vzSVX0pQdsW5Ket2eYS78SGY9eIL7n6dRScCiXaFGwFbgOEiV14oIwjQDuGyWJf+0gu2N/T8Ik+Da1hum37SZE3expE8CvPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EWtsZz/aGc3Onaj9O9KaShYWibQ6POpjKnNztkEq31o=;
 b=EIFpOG6coZMt2J9YQwCvrmyH2EW8ev0gtJ0ZlG1ZWs9r2kk5Hz3je6PsvqkLbGVyXn/3ObNHJKz5p2jDxzmWtwGTX4E3Oy1UoJ5jEZAA4hgACWZGFGdnoEGYy14jGCXq9gWqkqutxvWcc+uVe2ptX2Cur2s4WDOc4SryCuaHtQxMXvsNA6XCjrOHPCvUb5yjtmJrwXErdCasP02/cIC1/WlVpwxqjW9dwFmNKl6OItht5aQRxdeJHllk/h5WmE1EV2wtUS5tovMtuiTu973aBUKh3IlRHlFCF0+P0kwn4F6z79zTneN8sSdTrYiII6Qg2xKtUsKNLjp1l9ZDYPhx3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7509.namprd11.prod.outlook.com (2603:10b6:806:346::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 06:06:56 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 06:06:56 +0000
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
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v2 09/14] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Thread-Topic: [PATCH v2 09/14] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Thread-Index: AQHZOgo/9nXrPVpMVEaNI/w6kla4hK7C/y4g
Date:   Tue, 7 Feb 2023 06:06:55 +0000
Message-ID: <BN9PR11MB5276E166F8BB56049A5CFEC48CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230206090532.95598-1-yi.l.liu@intel.com>
 <20230206090532.95598-10-yi.l.liu@intel.com>
In-Reply-To: <20230206090532.95598-10-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7509:EE_
x-ms-office365-filtering-correlation-id: f2ec3b93-e531-4946-067d-08db08d1840f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: My8Rey8RH8eZMO3hJrlEoX5Ie+dJ/ilJ93lsuPOF5E+ZtwEEQuozsPGfmqygel4m3lRdL6Z12JdE7pYwZc8VGBTFcIIHnDP9XFl/bElgoiDCni/vKrx++p8DZphzn4lAd5ccT7x8BWSGSi/tYY8GJqfvk3LdRr2o/OvuNHVzptnDnOa2ChfjquLoD7Ue0s/hYS8bXY4QthYVGYVZkJOwzkxu9i6zN8DTk/ER5LC5srHwVkSwaLFHLUKnjwyKCyJVCtdn6fPJOVCJQMSnnfMib8LqJ7HJQ1CmHnEkO9PMTUTvT50rIeCT/G+UanQNuR8oBrzPg1m8JMtMTzMsxqMsXkYzKcsCu/kvsRVz6ZDJUIzxJSzGUcmhkthHPC7NHWhzhyy0oh890Zymqpu++xJ/7UOTETXsNrWUUR4GF0egY1Ta7FHGbw+VhGffRuj8vYLXIwx7Cirj9j2jvnSAv23HX0rhMfeXdmeL0eSmGqhiqIXPDH70bDWF5soPqWyj2vOlLNrg2ksXEUappFss1cS4fdGwx6RY76eSG35DmO4tpO1cOMQ4QaZlL+lYkT/KaMYnlJb0XsfhVPLVWvDCk/0di3gQD07mvm4ZBJVYc6SlkklLUGC7ob57aJ5FvWL2MtweWBiHVH1nPOShr2p7Psq8YnDzxG8h+GbCMCy6anVFcG23sNBQCxJs5dj9UNqsxXe7Pvi1CAF1j4ApRTphhBbzmw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(396003)(136003)(39860400002)(366004)(451199018)(38070700005)(122000001)(82960400001)(2906002)(83380400001)(38100700002)(55016003)(41300700001)(66446008)(66476007)(66556008)(64756008)(8936002)(4326008)(8676002)(66946007)(76116006)(52536014)(6506007)(7416002)(9686003)(186003)(26005)(71200400001)(316002)(478600001)(110136005)(54906003)(7696005)(86362001)(33656002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OiHscPtb8R7L/Hy0iZ3KPf5a7Fz6flFgJz7KARnSe3p8sbaz3AqUIneQLqJt?=
 =?us-ascii?Q?q9p7+pIB6aiL0O3MneOhDJ7jYSXcYoKhbXVEgWqHd+1Q49oMR0nRu0WMYD/D?=
 =?us-ascii?Q?OV1dbcwcAkZbjzalz6dYI48ksrmpOL6wZEczNglwzJzC3a+WtpNgeEzliua0?=
 =?us-ascii?Q?4lSp4GTJKocqb4QeVdOWjRjpsewDa0pqAfIWxYKgGdSZLuUMvOE32qnocP/h?=
 =?us-ascii?Q?ZQfyfmFlgYVueH2GCkJSzvIyPqZpEZhqpNhexE5fgnZhRDGFjRYrPkWXpaCT?=
 =?us-ascii?Q?4EUntMZzA6dz3BYYLeXfZklyUTB9gVTDUW8NZ75WUSFoAHIBxZjVH5o9PcSD?=
 =?us-ascii?Q?vl+CnnfqDVnTEZWWAkDodsD+V2nZTL1FsBVEAK1VKe2azGh12YuHCstVfNtG?=
 =?us-ascii?Q?9o5YfeUcaX6ZmfLd9N/CUqSao2yrXTqIbTrpSTw7GKbWMsdNh23I2f6LA/Hq?=
 =?us-ascii?Q?6n8I0drF2i1XQQg3vr8b3TR2SORdGPBgparUJeZTFW8AfK9fipOMf6uN9zgN?=
 =?us-ascii?Q?Wc+n22/cUKcD1CIC0PRSCXbnrdE53hI6YypZVe0BoFJNsjqVk2pZiG1h/1MS?=
 =?us-ascii?Q?M45mxqFTNJNqyktnMz+0EmH62FNWp02m6PXDuuuHlZ48k9jnLiqlMFDDpTc8?=
 =?us-ascii?Q?EhSaCCvvWHaWVbZ4DMcdH2T60bOwTzKQeh+4iApQC1BB7/o5wWhhW6eiuIH1?=
 =?us-ascii?Q?MXh0mIxI6ap0OVOQal+liIijhORaJiKDqxyCFLI1MIuqeFm3UkxeZsChzO9V?=
 =?us-ascii?Q?g6neA8vVwvFAllfusxr8MeCpqUTd65sOxF+KDtLSnOiVc/O0Jld6jGeJF0eQ?=
 =?us-ascii?Q?5S/sQsKfF0x13dL60O82HnoTEhx7gYtmzWV5ZlH+UOCW5nmMVorOZG0ogMmj?=
 =?us-ascii?Q?TVjZanZlkrTo91hKA7wV/rCSVDYViFHDj53EMPGwBdSloWl/bfGqbwAMSZo2?=
 =?us-ascii?Q?vUdnUXyqvQwt3EwuDl2Q6QRHcm46P1bnioQNA2AS9Xhl2/i5q7Nid09i0yGc?=
 =?us-ascii?Q?rBwYhpApufJCLdC54LIezKd1FxUXleu/p/aBB0Q2tExRmHfkCsPvfqMJE5jg?=
 =?us-ascii?Q?dDYoNtVgpPyv9Y4zLwAAPBc0Slef7fu2zgwhbUZU5jbGZEhDGII0dQFaqeep?=
 =?us-ascii?Q?KnCicar6r5DKXiGWmOi6kavLa9rdfRjkmPJP2Ki1eozCC4p/spJXt4TyzKMd?=
 =?us-ascii?Q?X58tXyMvgCKIdPrdzlHVoVhizEOgBUV26aMZm4ycEA637Eusp3Nh6p7dYycA?=
 =?us-ascii?Q?YAImaeVIWFdoyePCOCJJqLFo2g7dpB0cY3i5mM083No4CmVeQH8q7EbG5ejF?=
 =?us-ascii?Q?KEB7roY+AGTAySmAY6yUQ9pEjsDhUBNLWxaz3up4m+6yA4iXJRu2pU+9NHIc?=
 =?us-ascii?Q?KD9BQnnYWKfAS5XkDLqBGIQDGlmLL3i34bBPROVK1DRjz8YO/eWca7xluK8i?=
 =?us-ascii?Q?zNFBqQEmg7XV3v3lwm1IRiaoGLWaI0MhueMYmxTkB1HLsGtmODHW7DBEV+/v?=
 =?us-ascii?Q?sZtqexVh4eBU8m2GxdCWAJAop11eiWD7LLJFBChzSkH6diIYtCq7wBhKTvYx?=
 =?us-ascii?Q?G1SKATbKrx2oEAqossq/GjVQ/yzQxxaVD3TldInK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2ec3b93-e531-4946-067d-08db08d1840f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 06:06:55.9196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AjCu//Yd605fH6l52G5tq2B1KbpsCf9xa8y+cVc5kFv+FsrQlcBdsav27zs70U4bShatRiSTrofvcbogVhTpQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7509
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
> Sent: Monday, February 6, 2023 5:05 PM
>=20
> +static void __vfio_iommufd_detach(struct vfio_device *vdev)
> +{
> +	iommufd_device_detach(vdev->iommufd_device);
> +	vdev->iommufd_attached =3D false;
> +}
> +
>  void vfio_iommufd_physical_unbind(struct vfio_device *vdev)
>  {
>  	lockdep_assert_held(&vdev->dev_set->lock);
>=20
> -	if (vdev->iommufd_attached) {
> -		iommufd_device_detach(vdev->iommufd_device);
> -		vdev->iommufd_attached =3D false;
> -	}
> +	if (vdev->iommufd_attached)
> +		__vfio_iommufd_detach(vdev);

I'm not sure whether this abstraction really improves things.

Just two callers. and the old code reads clearer to me which
checks a flag, does something and then clear the flag.

> @@ -74,6 +74,7 @@ struct vfio_device {
>   * @unbind_iommufd: Opposite of bind_iommufd
>   * @attach_ioas: Called when attaching device to an IOAS/HWPT managed
> by the
>   *		 bound iommufd. Undo in unbind_iommufd.

"Undo in unbind_iommufd if @detach_ioas is not called".

> + * @detach_ioas: Opposite of attach_ioas, this is for runtime undo.

remove "this is for runtime undo" which is confusing.
