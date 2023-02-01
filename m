Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5DB685FAF
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 07:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbjBAGNm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 01:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbjBAGNf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 01:13:35 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E32A49570;
        Tue, 31 Jan 2023 22:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675231999; x=1706767999;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NOcRz6AHnf2EEpjaG75o00nAPYXD0vmkS05N2OVgszU=;
  b=LV4Tvk5R1qmuefw2SR7+7htgwxQ2UGC128p0TemnYt/kDCGlFIxybfnl
   EUY8uWz/JacqmZGEmubaLl+s53P+N6qmbjeGVPiY344ozA9/pF16FTl7H
   A9J8mKFovQuaIlZkSZa2O0OYsYWXpwnq77AgI551wpNXcURO7iI5cjldI
   BUgLFi2V2Zrv3pw76edJWRArfizZCF3oZ4WzNPCHBbOsg5+zpQ5dgNnHz
   RE1QxckQtE8v24cpiGsum2z4JQWW5sPDTIKlz6z3A3YgLdCMh+w5uNHbO
   kxyWaANNFZOgOrrvQ3WED7zHjgwNxEDD7xvChKSKkwFvK5muDUnJWTsAv
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="308399767"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="308399767"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2023 22:13:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="733435021"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="733435021"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 31 Jan 2023 22:13:18 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 31 Jan 2023 22:13:18 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 31 Jan 2023 22:13:17 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 31 Jan 2023 22:13:17 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 31 Jan 2023 22:13:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vtcw0GfXHLtylU3Bw9XnBnzH3zj7JFOv9DQ7vrn5tfXAOMa66WLtjjfMQsK4h1U+wwxVGZXdEyXAky5GGgjEenDWUdyH6cs1bgSArQpkD7CLqmwenpeJbnp/HkwmBo3ja1/QM07uZkBekx/W5e5U2o0vrxWnejJjvr25ykPWj5/8tk12BcKb54Fzjnp1BwZFqerQrsUa14RsGUr2wcuLFwd9M1M15XOLk/RLRt++cd9w8oR1o6geinNEuZcXsyvt4wyslWKYJ8embMtlHb1CzeR5HkfpmLatcS83Pgpq8tsB+6rcpPEBs9SCUpD6xdB5o87lUeq6oCatONo9YEDMFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jTZhPxTc9pQxWUPWC6wU1QqsO+psGX/pyKKKKYC5jRQ=;
 b=OIak6Rwve1sAk4U4d1SoB1snqdS38ya7DtvarEh3jFJWDmKvsjAw75evZfP2gfcdP6peZ4HGprjAclIk8rWSf9pNS9eXKwFlpxweTI+79ao1ShBGRgG3j8DiAOsvujBFzmGUsMKtfP9Keph3lNfUf/NLiz75vwckC1l5Uo0tFkBBggL7/SV4wEdK8jQ0j11ZMjrRSWXAAs/t6QoH+Nq8hPUY0jpxka2n24Lqnuuv1rkfhfUCOfqvfnIpqhdrafnYquJSjPv6nhJ+YH7rHnfVN9ILbIrsL1E1OO4y2gNWz4ZfKpRHwfmhBU3+odcp6HMp0QNf8HTMdbJoPr88iANmZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW3PR11MB4650.namprd11.prod.outlook.com (2603:10b6:303:54::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Wed, 1 Feb
 2023 06:13:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6043.038; Wed, 1 Feb 2023
 06:13:11 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio: fix deadlock between group lock and kvm lock
Thread-Topic: [PATCH] vfio: fix deadlock between group lock and kvm lock
Thread-Index: AQHZNa+R583ZmSphd0KoWT4U1RM7h665mpXw
Date:   Wed, 1 Feb 2023 06:13:11 +0000
Message-ID: <BN9PR11MB5276E39EE37A7BA2E1B896278CD19@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230131200635.44227-1-mjrosato@linux.ibm.com>
In-Reply-To: <20230131200635.44227-1-mjrosato@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW3PR11MB4650:EE_
x-ms-office365-filtering-correlation-id: 3a4318ff-3288-4025-0c9f-08db041b656e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FC80QSG4cVqVtEglNPFpHEBwZI0Awln4DrtkesL8+bwheYRIY8uMwr5aOiwt1HuZ+GfTsPXrVoKJIVF/uf0Dn+b6/DHGuT1lP2KuXux/KR7yVLzA00qUmXIYgrmG3f1JykZ9ez2Jn7T8f37+dgx+YjvQoTOXlDfU9FcbD9TDo+6vfcFWCcYEoDAPmLXimeSpTl/Pmoh1L1q0gFEkTS3W7RMUYWGuGunIbFy5/N2D0uGbyNqKgbe3VLuYws0WwrX9SH8xykN7ZVJTG21tH/5vcyFbV67D7R3w1RpNsUp+xmQQLnujbRiZXaY3rsFHSxyBTCWYN7Ldz8byH9v6ypAs6Pq7YmBLsciq9yeBWwCeVJScSv3mlhRDBLfibUr9U8fEIIL4Ou/GRFM7GyR3rHGoNqmAB0JpEHMv92LwLYWCUpv7I3r4fdcOd9Q2evsoSsjr7dkNJtS6U4m/HoyHs/3kRarU801vZHgXEhyocJ/OZDfUO4eB39IKUS18tG2msSb2rNMAyJ2GFJF6TBO0euLVGodcqeYslZjluit3dK+aD2TTo2Skf+CeXIsSWQZ6yDy8TCBHsKD4lJOmwaCZt3/y2rux9GxIsPBxRqSNWcOD5Dqo+Vg3Q13NMgbNwqH6GsrZcalEeXuI2nppJSqSP+FCr2IpSosKQsh+rmeuBBoYU3hB5jpHnF08nyqt4NXIBvxuXlxP2xr4Mn5e2B8kpVRggA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(396003)(39860400002)(346002)(136003)(451199018)(76116006)(83380400001)(82960400001)(86362001)(33656002)(55016003)(38070700005)(122000001)(4744005)(71200400001)(41300700001)(2906002)(7696005)(52536014)(8936002)(38100700002)(110136005)(54906003)(5660300002)(7416002)(316002)(66446008)(64756008)(8676002)(66946007)(66556008)(66476007)(26005)(4326008)(186003)(9686003)(6506007)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0Jd3QvKq1hLo8N1C1LU4q/FvMYvxlqz25rD9s6PCPBB5o2iNHV45wry/PjwT?=
 =?us-ascii?Q?r66qWHpmsih8+WQjdUfE7TZfWSONJbmHvY9Cy5l5phE/dUIp0ntM4PTRgwUH?=
 =?us-ascii?Q?BXwYEx+d1e4a4vBMQREGcaLm1RCVEbhuLjAA3PDl76MaOYEHEyCeDTNplRT9?=
 =?us-ascii?Q?wM6l/4EVPDPeevtoUSGzYOoQta3F4EaVDUnTEkwfnH+CN6r35P3Jwn3rbYlD?=
 =?us-ascii?Q?vccJEELZD4gX+6wRbTsLg21Y1wTA1naigFKekFbpQZsIkQylogWtvLZfgtWr?=
 =?us-ascii?Q?bVPBXpYt+yn2cYI4FcMTjQjsEptUIQ/StpkCt8EnAMw/UkWkSC/wTfmgqt9T?=
 =?us-ascii?Q?GPMNBaNwwcxpae6feZLloww4Bjvq8P4ZjRCVzO8sAnihiuotQyZfFoI9Ujeo?=
 =?us-ascii?Q?aw+va5n2XoyL9T141HAJXJY+kakVloQmE5//SUrDuja9rUNh997jN6x/uQAJ?=
 =?us-ascii?Q?p/V7DKwkB67zeI1umHqj5P684OhaIjOUDPcAN5eK7URzLEoVULSrCDN84gRZ?=
 =?us-ascii?Q?HNwy81L75L99TpRn+MG/ziLqdJIf3v4bA5IT65zoriugMD2chtr1chPwz8P6?=
 =?us-ascii?Q?7TRqaF7e4uyYnYwZw/fwlXJij3OkzxU/Sr9AX4/0s4eUHGy8cFnUaKk95QGM?=
 =?us-ascii?Q?FbzQL7YlpoFqCPy1X8woAmUS1x78OQUFBi6I+DwpfppOhKFxeKjY4IIQ/ajS?=
 =?us-ascii?Q?i0CUgU9+nwUnesePS2/SCZD2eCc/k90NptCvOGqSd1eeerxebcz/yylVzMUv?=
 =?us-ascii?Q?SCRnwEdIbueH2rWgiSiz5lmww7QvYGq+uQAEPYA00d8a5IqEY2uBna0/1igH?=
 =?us-ascii?Q?gbO4ryGomSE53iEDuxljfymw7zMtca4vA6ybZnYVM5F3Wd2KL0u8RsSFgEJu?=
 =?us-ascii?Q?P8JZIha0iIuY3nyVI1A3hdcnq7VzndTpqw8D05i5RJ0S+Mk4EE4/hY0iDoQU?=
 =?us-ascii?Q?e1hnhc0Zc31QBjr/3rrYtgZSKw+MSIGpv//wdeYBPpMQ6OPrUzsCoPRK3HNp?=
 =?us-ascii?Q?mPKamx/i46H5mhlnCQa6jJKW/P8xLeXA8m9X0bpFvGFBQHiIcmQyEhXEGjAQ?=
 =?us-ascii?Q?/QrFOYWgolfDC06JtR7UFg6OtrTwlDLDEFXmEJ1npS946V34ISBLzBnrS2m0?=
 =?us-ascii?Q?bvqTT5tXN93hCuA/SG/V72Ox+NwlbLI3e0KyDEbaYVUatKaplfrvgXyQxbCv?=
 =?us-ascii?Q?pCeGo4KJoMt4L3h2Z1WCeTiff3Pw20WMymkGLuhyzkmbZi06da1YzIitPuc0?=
 =?us-ascii?Q?r91ER6NKqXp6BuPw7Gd0eBPp+BQhh2K/qO5kkxO6xJOkCaJn330/CAJ5VMOW?=
 =?us-ascii?Q?nSeohdYQZ4/+HaOMEiXdwtJlWeFxR0uJFBxFl2kWEchBZUwfKLOKR13s/Vst?=
 =?us-ascii?Q?KfuQZBHuKjzgy71Fxs769jG/GS6Id7jSG6zmzglpfNN7tmlPkJCyGgtENeq/?=
 =?us-ascii?Q?chmjQ2N/RH1GNdBR1VzJAV3j+0PbHigxrO7uYzsNv/eLgD0DEFnq1ALkrC5u?=
 =?us-ascii?Q?oAoXkXyEWH9ogPoQTTb2qarL9Fsc99WcRfQEq+zdNjjdXNiDdxqZcRtlek9e?=
 =?us-ascii?Q?ZsA7rAR4VyWqWrJ0BKrAXzMMySMEaKQ9/06L0qNL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a4318ff-3288-4025-0c9f-08db041b656e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2023 06:13:11.5083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 45mM72OfXruzXbyChhbQvOBcQ0Wgkc3HcLcHIc5Ca1e4fsrkRhe74QEez5Dej+u87vYwWjriyZmDM5M8fa6ixA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4650
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Matthew Rosato <mjrosato@linux.ibm.com>
> Sent: Wednesday, February 1, 2023 4:07 AM
>=20
> -	device->kvm =3D kvm;
> +	/*
> +	 * Get the KVM pointer currently associated with the group, if there
> +	 * is one, and obtain a reference now that will be held until the
> +	 * open_count reaches 0.  Save the pointer in the device for use by
> +	 * drivers.
> +	 */
> +	spin_lock_irqsave(&group->kvm_ref_lock, flags);
> +	if (group->kvm && vfio_kvm_get_kvm_safe(device, group->kvm))
> +		device->kvm =3D group->kvm;
> +	spin_unlock_irqrestore(&group->kvm_ref_lock, flags);
> +

No group reference in vfio_main.c.=20

btw Yi, looks the deadlock issue also exists in your cdev work.

kvm_vfio_release() holds kvm lock and then try to acquire
device->device_set->lock in vfio_device_file_set_kvm().

vfio_device_ioctl_bind_iommufd() holds device->device_set->lock
and then call vfio_device_open() which finally hit kvm lock
acquisition in driver's open_device routine (e.g. vfio-ap).

A similar fix is required in your series.

Thanks
Kevin
