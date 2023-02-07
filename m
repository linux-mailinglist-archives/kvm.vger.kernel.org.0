Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5003168D1D6
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 09:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjBGIym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 03:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjBGIyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 03:54:41 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B5034C03;
        Tue,  7 Feb 2023 00:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675760079; x=1707296079;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PAmStPmfnYXnVqJoiukGRBt/x7QdyeEkjQpN8+ZLoRI=;
  b=NCE+ujDfbPNDNyMij8h/7j3wmRx7Lx1dLwtQMvGVHxt1WQiqhneJOi3l
   VlIAsZ3+d5nrl0LFy/CBqZQc3SC51//BH7yaDMDq+8ckU/4t6gDTKWQTK
   pL/2+iaxYvnWvFTfPeNJjwagpf/7Bd/sp1Mh8snMBdSuX34SmibfgtTYb
   zuFFI3BGimhT6dWDXhiBBYUhIDVwjqRVDQdxD82FN3+Gkdc7jPhCOQTMh
   0M1O5tT1YOpU/msIKUFnY2i1aDVFsQbGzUzIvbcjCp95CQeyMohmxkNzW
   dwWe5+SfBh0osUS8qnhgPnt42iLlBgyxmR+I80Pqh7k134g/W18PHmqZX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="415673548"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="415673548"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 00:54:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="809447277"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="809447277"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 07 Feb 2023 00:54:37 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 00:54:36 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 00:54:36 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 00:54:36 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 00:54:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUWVl1fhPUyuUgk4l1SkqDEJK4p2Pedc8vDLanZZ4MlFzU84Yagg92SNnaw+BgLzcnaG0TUMLgdF7UpXc3iaDZNcD4+5QATBEM9q8Hxulaa+uoXQ6G+FgErikEXH0wF5j9UWbnnE3E67V8GoKSv0wNk/S9FtjNQgry8gXDY1XkTTtWTCuhFQ05E71NxXuRjUZTm7xbjQzqH0GKSSw+6ii3koUDTwXUKSIn3tLEuRfTz2FziuglyIm3prKqBm3aqRVqYLqyrydl75fM5CEHJnQT6ogFD43egGI7fpfYZKfdG2U3sOjyU6lLOqYtcMQDawOzRHVkWR9GLfwhLoPalQMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I0obsrwdpDyZ+UsO7i2PHXCZBrvqwa8pgLKT/THh9hc=;
 b=OcYyj8YmnVJ6wV3MYFCCPLtK32asKlLgmMZUpAjE46nagRE0gdDvUnX5rf1zLOac0iLSx3wYrvQMQNcxgBaEujLeLUT/ZXMNFlc+l7HYRDkAPRWPN6ASv+tNMj1JFRrA3YAc6pcWA7kTDGi7gevsoRWt498qA3hu5nv/XjF3OZpzMoXghxq/Tt/sFp98XQ7j5C2+01RTQFBCx5aK79rCy36fRTYpCvaOgx+2iOUOKCOrOoMSgGSY3I7lQ9C775LLwtI9mtS+ww1y+HlLJ+8VL3snLbuh8kDkhl+6t2HC3VJJPpWgGZ2rcYlV9O0pqoWtmcBB0cxESXFT9JRkQiWMSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB6868.namprd11.prod.outlook.com (2603:10b6:930:5c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 08:54:33 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 08:54:33 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
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
Subject: RE: [PATCH v2 11/14] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Topic: [PATCH v2 11/14] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Index: AQHZOgpBwImAS0LRl0mKfU0T5wA5rK7DBbMAgAApJqA=
Date:   Tue, 7 Feb 2023 08:54:33 +0000
Message-ID: <DS0PR11MB75299599F5DCFA79D894536AC3DB9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230206090532.95598-1-yi.l.liu@intel.com>
 <20230206090532.95598-12-yi.l.liu@intel.com>
 <BN9PR11MB52764ED1F43F717E04B8E3588CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52764ED1F43F717E04B8E3588CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CY8PR11MB6868:EE_
x-ms-office365-filtering-correlation-id: 142be129-1b52-40da-cd40-08db08e8eec4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xj4qIq5iVSjbqBnec6gPiE4uNnB58bRUBYOdZH0e1jW2ZHFg6GyvV+cpNJ7mVTH/xYaNqbiZIbFyBATel6NCX8Tdranfzywj+yyzuXYkknG5QdwViEcp4vS6J7T9jeUXGwjOj/4seqrcJ0gcl83rhbI4CxWe83KhibwWax8lr0Admpf/yi+OEh3wpkzrPtHWzMPKAlarISlTfdmpF1CbTDNUEIb1j2L6lRVgRMp3raf/h4rfr3ocEi+IbdeEAx8CqChN8bDKu4GNuNICwCxMgKmQFzg72IhWBToig5aleu4pWtkB6cScYPlBsJiZnioZx+YBhX7qiN7ks04bii06eWdmh9LtA0HfjgWHISIa+jeo+A4/tmQNdyOBxRBXdNRz1M6EGWplfOdVsFJERXf2GMXs407Q6iLA4MzjYuF/7LW6zO255TbuJumogqf3JC3Ebbo8AahlFDo+mtQs0pv38gIpHJAdjhSbS/ifj2XjJ8GWFqqQR05LmuXFdahVjxqTZEUI8lTe3XOzlZHG2Me6MS+DDc4ye6izNSuXqIUtdNSgVheeEoWixGrVaMc53Qq3pxSvpwWIUps7SUa8KkGLcoVNhJEDpZO7kEVaACRtxbpjbTnMVvD2ntrxTDzFuFxHjX76WTBtllNaH4cN2+sKdJeCFBXvRYN203oUeRuAhOcfDjPVwkjyzSFIiDmXNgA8XXjatrL970HpW+MUtIm3R4KcPXHHA9dO7dnwSma5fbE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(396003)(136003)(39860400002)(366004)(451199018)(86362001)(54906003)(110136005)(186003)(33656002)(45080400002)(7696005)(71200400001)(55016003)(4326008)(2906002)(66946007)(76116006)(7416002)(5660300002)(64756008)(8676002)(8936002)(66556008)(66446008)(66476007)(41300700001)(26005)(478600001)(9686003)(966005)(6506007)(38100700002)(82960400001)(52536014)(316002)(38070700005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?t1s2RA9vrTw3h1eFDmlM3OieoA0ahBSS1IVo6Av+52c5ofwqbJLO7K4eSPA8?=
 =?us-ascii?Q?G6bFgJcGQoW8MJYNWiU/oMIaIZGepIXrCRn4nEHftg5ZZ69k7is1rH7mXhtE?=
 =?us-ascii?Q?ofddUsE1H6AaJ1mg/s/uMM7X/sOlrdlB9poPQq4UrfKn/nSVUcpV80Z/4ih5?=
 =?us-ascii?Q?5D0Lvk2RQ3Aua3dI8bMHUaaSuSGkzQ3sQ/RLyN9kMIQLUOLZvune+nUh1EgA?=
 =?us-ascii?Q?XWF36Qlqrj2O0QZLUwXhyyH9OTHHRYmLU3AwGKc/kSDBIQ2DNyZd9aD9SVQF?=
 =?us-ascii?Q?GksZoPWETJZczZU1exCYNNzfq7D68eBoOQOOewoyaxeESKSZwhzMjaOOj5if?=
 =?us-ascii?Q?IwVbe8DEI1+NTR+jlbm3TwjqtTmLyqMFDCmprfv20sv7cKxLGJVXPWeuehwi?=
 =?us-ascii?Q?/CIuZQ2trQPkD6CS/hjM6PEPwO2Xb3oheOLVSPoFxUwMq2DtOv3i2gEhxbu4?=
 =?us-ascii?Q?LQekq+hwjto74yKBWCwGMUz1/VBG2cj3XxSAvG6AxhDLyK2RQSj4C6QTEnrc?=
 =?us-ascii?Q?sf+7kcCQTPDSaWpcMw3Ko+IuL49tPRW/vhJXMOdI6+nu2SSBiXIZXiiEyKF8?=
 =?us-ascii?Q?6A4JflpC1/6gtIlM+1PUlLITAyGGrSRHEFEVtaf4WU5LlTJx3V5UqqigLx5j?=
 =?us-ascii?Q?lqWEgpbWU7AE56MNc6UQA739b2MU/YzuSO5XihfsNaGXyVSHYvw+j4eJDx/O?=
 =?us-ascii?Q?wLBaK6YEQVQcqe5DscC34QCEwm4KIL3Te/74janbUH6ZS8kp9bqEmpSt8vu8?=
 =?us-ascii?Q?tMIA+rsKbh5hLpw+WZuteng1P0OXrsP2b5qQ8ieXkNlvRSuP7W7Mk7jerS5o?=
 =?us-ascii?Q?8nhPRghYgMSSWcnSOE6fQNNPIrecx5sSIzKwZ10pO0RL2vBDaMKhiyZEfQ97?=
 =?us-ascii?Q?Xx2C3RbUfOqi/3ZTgjXkzwJW9saVRgbz4Uoz3PpuJVFkCbQyjv4VO/UdCqXm?=
 =?us-ascii?Q?gKlwjWZNrjHz9l20KxyI375yeqw9VzLfF1PVXHg5557vtndbQ9H6Qumji6Kf?=
 =?us-ascii?Q?LXJSz/JYllZg3CJ3WaXijFOrWwHCg54XmU9aD52eLn5W5WBWJGCdZ5Y/HX+0?=
 =?us-ascii?Q?U9NzE58d0yi8vw+R/fh+WclSVKvSRhIPuslTKY2Z+sjNI3pxG0z/Tzuig8P1?=
 =?us-ascii?Q?opEeEtSvA5X7pumLS6UxukXmZhSm70pZcnczsortilHOcKL1qAxJNamhrvwa?=
 =?us-ascii?Q?6Dx6BvEtatm7WIncFr3dNbEnTeMVPNJGYPba0k9R8tqxgyk6TqXj6IMfPtmo?=
 =?us-ascii?Q?GSxB/kyklzsStYdA40brPCEvdh8jOcaudz4G7+DIfI6EO6M37ri3nEJeCz5f?=
 =?us-ascii?Q?V/rJRCFWJFqTU3vI5uEa0nWeEYKOcJzO35uFPmjtfrVw0TG3zgxAOuoYag6h?=
 =?us-ascii?Q?LItjWxdcQpXXTgRo8Lsc56YT/3LNWKPPg8AbYVudO/aN5iJlvZw/UTmBsdR6?=
 =?us-ascii?Q?1OYvmcy4oZPxd55wyI2Msgdpt8lQNklK6X7mXuKUg6lgNb+Q9k8aVuKC2CjJ?=
 =?us-ascii?Q?+lqlVFu2mhf6EPQ141KtZ3LDYbENt74U6nWtxc5PBm/nvJEiFnU5GOlDyKEI?=
 =?us-ascii?Q?sRN4KeqM9AyQAtd/umSIRY7ynrZ5hAoXbQaiSayd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 142be129-1b52-40da-cd40-08db08e8eec4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 08:54:33.3741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fRpKoSmpQ/54FOgMDC6jtnllLoQGtQ2xWIbJerYL04XSRtp1nCRNI0P5nlwQYJP7vQtOCPfSdZmycEMMkQ0Myw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6868
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
> Sent: Tuesday, February 7, 2023 2:25 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Monday, February 6, 2023 5:05 PM
> >
> >  struct vfio_device_file *
> > -vfio_allocate_device_file(struct vfio_device *device)
> > +vfio_allocate_device_file(struct vfio_device *device, bool
> is_cdev_device)
> >  {
> >  	struct vfio_device_file *df;
> >
> > @@ -407,6 +407,7 @@ vfio_allocate_device_file(struct vfio_device
> *device)
> >  		return ERR_PTR(-ENOMEM);
> >
> >  	df->device =3D device;
> > +	df->is_cdev_device =3D is_cdev_device;
>=20
> You missed Alex's comment that the one caller can open code the
> assignment instead of introducing an unmemorable Boolean arg here.

Oh, yes. will open code to set it in cdev path.

> >
> > +	/*
> > +	 * Device cdev path cannot support multiple device open since
> > +	 * it doesn't have a secure way for it. So a second device
> > +	 * open attempt should be failed if the caller is from a cdev
> > +	 * path or the device has already been opened by a cdev path.
> > +	 */
> > +	if (device->open_count !=3D 0 &&
> > +	    (df->is_cdev_device || device->single_open))
> > +		return -EINVAL;
> > +
>=20
> If we are gonna handle the exclusive open via dma ownership, then
> here we don't need a new single_open flag inside vfio_device since
> only one interface (cdev or group) could be used to open this device.
>=20
> Just preventing multi-open in cdev is sufficient here.

I see. Per below discussion, just need to make group path always
use vfio_group pointer as DMA marker.

https://lore.kernel.org/kvm/BN9PR11MB5276FA68E8CAD6394A8887848CDB9@BN9PR11M=
B5276.namprd11.prod.outlook.com/

Regards,
Yi Liu
