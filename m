Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7A5695D0B
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 09:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbjBNIfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 03:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbjBNIfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 03:35:42 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8C8974D;
        Tue, 14 Feb 2023 00:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676363741; x=1707899741;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=u6p41gUK59NgYqy9BH8axoifPSdeuB4l56/WjRQSQKM=;
  b=bYuRs/WDouQem4KKqg90C0DztWgB39nSDZQZZd4944/BT1sd2QwsqZJw
   Dhb/7WbOq7KA1Wqi+GTMbno1Ul0AOcGozsuQuQwS06/stQ8/3UM7Vg4Dr
   +Edw8GMFyE97D6psGJvW6RaGD9T3nXovUkJKtoLu8HVKdPFDJKQCV3quY
   R4dt2NBVNb2CRNnxyX9EmjnmNP0sa1pzrYHY/VERRyjfPsjh1/xOWkS1+
   K9So/sVTHMDwMpInf69LZm1nUj4xvkxoiR1A0LRACW/aOjtn2KhV1/KGU
   Bw27bOqXFL1yqSQVe0bcpR7EP/Z2fbTK0QZLo8gIFQdZ1jVIGdtRDS38y
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="328820297"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="328820297"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 00:35:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="811937817"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="811937817"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 14 Feb 2023 00:35:37 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 00:35:37 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 00:35:36 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 00:35:36 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 00:35:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnOyxdw5VMSvCMXgtBX4zcuKL4bZY+YRXzOgHg43TIcDVwmbr+SIh5MarPw+bmENRU98930JGu5yJCPjJUhnlSocTXd2e4BnBseI+6td2vknYrWSXeZo0woDN7+yvtmx69lQnzv4A+j05PA1/gyNVbYzUmvFpCs4Jh7YH4R46tb7DDPlJWJ9qwBYIhude0n8/KyBO+vuHFpw8dhZHKDdHLHnI0bYJGktwMxVfoDHRHFL965bFLzsZG2pxGqFKHZ/hpkLFqSO94r5/9ozI290XWiZzxebtaBtMRFvszQWZnmTi3rJgBVU6YKPOvP+dN9xXk9ibRrMKJIgAscPPTlTrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1mCx+yXvnb6g5vnDC88YS6VKSdDkCpaKFNlln6DdKE=;
 b=C+j2DkpglTDRO1fIDhFhHmUXfp4JapV/+g241enf6xP5UcszxwAwoIwJpNdrAzoRA6tvzU40AaDB/rnKrgaHPwObKbfVKn4taTidm+8xxc+urqn4y0FsONbM4Lg5e6+wAZknylPIaBJ2LGWsGz0OfU5ISK00kG4hiGF+W5IqwzTUvhDkJz+ncaR95A0EeQqnJDsaojiDocxDnYENtTZesLbyTLQ/jUd4RMq02hYpHhYFtzItoWOmix9lJi7/JDJ9ZjugmImvTk91lkVOg3wU3cQo1wZ1oqvAilWasRsHWXUxKvbs1Rn16j5ZFFf53kXSQvJCrJBrhcZ8/K4Lt9PU/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL1PR11MB5381.namprd11.prod.outlook.com (2603:10b6:208:308::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Tue, 14 Feb
 2023 08:35:33 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 08:35:33 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v3 13/15] vfio: Add cdev for vfio_device
Thread-Topic: [PATCH v3 13/15] vfio: Add cdev for vfio_device
Thread-Index: AQHZP73S7SZOS6Dyzk6tKKIHCMIkWq7OHjkAgAAAs3A=
Date:   Tue, 14 Feb 2023 08:35:33 +0000
Message-ID: <DS0PR11MB7529453A0D13233F96E00943C3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-14-yi.l.liu@intel.com>
 <BN9PR11MB5276BEEE8F501E2B88F4D3238CA29@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276BEEE8F501E2B88F4D3238CA29@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BL1PR11MB5381:EE_
x-ms-office365-filtering-correlation-id: df2d8648-4793-4097-9c38-08db0e66703a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SQ7kd7OrmfHdBh7O0MfswvJJM6klrJ7omO8iY6edKqJAzdvjvjUp1nsMxcpNjMY8g+OMy0+AntsjUjmUwfP2ar0EHfYl9okAcrrSmJUmRIl+vV5+bN21kEefQBByO4UGiKpMP1siS6xyGCOV8MaskX2tGBGDhvnzb3wZrLW/Y38c8s4iuJAL0U3X7Jgrx9gZxgQPexEEdVAMiDjz/ryat0BXm0OH+YWup/6tQwNZAkqtdK8ciJ+5/eXbTlwIuktU2ZraJw1DKrddCSOYxqyQabTev83V9uGfba0J6FTD5JNQb8j0xCcfgF/3DwiLU6v9QHyUbvZzZYtDGS9OYSyWD+i3HNOZuYWzgonhpZ2GUJVhFEN6cirw0udplpLvHqOK/FYT8LLgcRpME4S0lu/wA2tCgghjyjbi5RnGtOyzEi+ClKR3p1/19V/+8Sg/EH2Jvjj5Ha6hsnrW1Xn+fT+SdY4WnSThheUDG42fhzLFYNdiuA0WXyB2Rx/cSCXmhpozHLOP28INf8y3sw/LNsAA8nYxI6kDjznd7OSVuGLnSdIzA+NQ79oX9loTONvKUQG5GR08d3kc7mTSKwjQDbAipJVLSxHVm4LCmAJrXWU4gd9dFnQMzHYJoxAojUxX2F82axvKQKfiMvUTyrW+wixez0/Puk7tUakikTNPetvc7ZS6br9DranfoCrhBnXeb7G1n4IvO2tYJ7+0+F/+unqfC+/RzrrRshqwDUoEl/UNUVI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199018)(38070700005)(82960400001)(55016003)(33656002)(86362001)(186003)(110136005)(54906003)(26005)(76116006)(83380400001)(316002)(9686003)(478600001)(6506007)(7696005)(71200400001)(122000001)(2906002)(41300700001)(64756008)(8676002)(66946007)(66446008)(66556008)(66476007)(38100700002)(5660300002)(52536014)(4326008)(8936002)(7416002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mQBUFp+m3Z3kOQHg2kekETlZ5B2Jgxou7hXotZ/8vXgRITEcqMUMABCFfv5F?=
 =?us-ascii?Q?umJyoDGhvoHIEsSG2jMabU4eHmYDHOYSfdGR1TFaluBjrvtEqdfgbqmwn21S?=
 =?us-ascii?Q?Cq03dGbXJAAM6s7OU0LwkIm/2x5KNrpRY4IWSmRjTNc13FSkpJVkqjthyRNH?=
 =?us-ascii?Q?rCqWUIxtY++Eq2V/6wLh5tnvyKdR1l+EOPp8W8/lq/EFswSrf/UQiVvRSIFC?=
 =?us-ascii?Q?mwJupbUTtIaqjYLZg19pzqXSDMOXtJ6uSco/EH4aB1Db1wP9XAHNZHlQufxC?=
 =?us-ascii?Q?2geSIfKo6ipFVf39MwM//wEFzNOvu1rJXaF5kVrdamZ+Tv/tRRI5VDVLfho2?=
 =?us-ascii?Q?8g5D/+SZ67AmuUpnrarypvn04yjQDS2coJ53CsTmdNX9/99JEe3PIpQVdyV1?=
 =?us-ascii?Q?0VLghQVAQ7+XbzV3nXlV4cCN1xfqvrSCPcYDyWKVWq/lgRulaFnFLdDGuqJ8?=
 =?us-ascii?Q?FmcwI3EhssNvbr80a9lzSiLJooAAYGKvI5P3MDs8leLxzzdERLA30zXp53Yw?=
 =?us-ascii?Q?Cn744bz41h/oQlF9RZ8R5gduRdrhllOXG7cX/eBTA6qrw4WCIsUpAoUxQQ8U?=
 =?us-ascii?Q?//TD2PYz8/oL4ZXrLv1mgnmgHZtHKGSJgr8NMiHUpBLFFInaGVsWgApNSmGT?=
 =?us-ascii?Q?BRFNBEEVivbcLIsw7OH14N3fQXRdRlQlxz06cZ+G8N7EcStDcculs5XLntTT?=
 =?us-ascii?Q?xOyPHzzJ9iNozuV7fn6jPC0or2moWq9F1tPbhl6/mSFDczMeTXpS1nlzxiQY?=
 =?us-ascii?Q?Sj104XmjOFjoQgRgTICevgbF6WRsF9brKpYvkPqgjaGfEVeDye5zu91F/9qo?=
 =?us-ascii?Q?3yh7VZVmT/xo28uXH26NZsVXggBBvfQRy8gyOLx+TGkQN6m4ga1iG9VvB6/8?=
 =?us-ascii?Q?MDYDocTY802pGOIgVq6eMRE9Dh1gzNmAxVxldvGcsjFnBZEzJdfllp+CocOS?=
 =?us-ascii?Q?0TnLGBfl00ULPxcWqDMiXY7YEZ6qEf74RWqZsyLrMTrP42SDfA29xTokssL7?=
 =?us-ascii?Q?CWV/gmzbnMOfg2es4ACTZAxDU3A5HPHzAE4cP4PIwHgSas1eB0ALhOJcPCNR?=
 =?us-ascii?Q?dE+y2B2YbFMMp7rSYkHxoRSQ6hCGGle0A4yzR9xAvmcv3kkDYaOtoWKctKeL?=
 =?us-ascii?Q?KOiaTJU4jpJpEb4NJ4RGXKLDR9t0s+Jr2PPpnGI9fOnPzrMOMxV1/1aJzQqA?=
 =?us-ascii?Q?CMT2C1diMYaKlfDURltUww9ZC2vewpj7ef+68U14ly9f3YO0cuHvCuCEfDbV?=
 =?us-ascii?Q?7vgccvWj1fWEbxOthhdZ7SfEDS8B0M/+GZqOE3Of4rdVRXoNXnUYtoEwbJAk?=
 =?us-ascii?Q?byqu+X5+EfM8XfuWQOUHrn8737nKqmgF6E3omzsPoRZiu6s7HoMuQw0HkfG3?=
 =?us-ascii?Q?zjTzPSkR65gbY94Zi//GeWkAbeuzhQ1srLo7NU1jWNg8mc+Jo7gn5C9BvYU6?=
 =?us-ascii?Q?DCqOFM5cZuVY/g8/axT9oR11WzHSf1/5WIGWx5tX8CGMhhQC7nspY0FTACt+?=
 =?us-ascii?Q?t2k5/Kl3xxKey/ViHh4+B8hXaL58L5gzNVGaR/8CIJrdjleK+DLCFEBb1OTX?=
 =?us-ascii?Q?xzjmSylvNvUddjI9zOD02+Vj5WMd0PZ0eUarKtR4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df2d8648-4793-4097-9c38-08db0e66703a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 08:35:33.4774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HZQ0J4fya7OFv6i3j5CBeZfgd6Yq5WB5Y391RiEkYqB/GFIgJorZPfNumP3axCBhiH0fS2QJnldR5iTh2QtUlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5381
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Tuesday, February 14, 2023 4:32 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Monday, February 13, 2023 11:14 PM
> >
> > +/*
> > + * cdev open op. device access via the fd opened by this function
> > + * is blocked until .open_device() is called successfully during
> > + * BIND_IOMMUFD.
> > + */
>=20
> remove "cdev open op"
>=20
> > +int vfio_device_fops_open(struct inode *inode, struct file *filep)
>=20
> vfio_device_fops_cdev_open()
>=20
> >
> > +static int vfio_device_add(struct vfio_device *device)
> > +{
> > +	int ret;
> > +
> > +	if (IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV))
> > +		ret =3D cdev_device_add(&device->cdev, &device->device);
> > +	else
> > +		ret =3D device_add(&device->device);
> > +	return ret;
> > +}
> > +
> > +static void vfio_device_del(struct vfio_device *device)
> > +{
> > +	if (IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV))
> > +		cdev_device_del(&device->cdev, &device->device);
> > +	else
> > +		device_del(&device->device);
> > +}
> > +
>=20
> move to header file and have CONFIG_VFIO_DEVICE_CDEV
> wrapping vfio_device_add/del() directly.

Ok.=20
