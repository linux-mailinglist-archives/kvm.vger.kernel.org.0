Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9868B6D658D
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 16:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbjDDOi3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 10:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbjDDOiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 10:38:25 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BAA211C;
        Tue,  4 Apr 2023 07:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680619098; x=1712155098;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5VZf1JoUMHEF7p6sZsh7R88x2gwAASdAEWTeBTzorIU=;
  b=U7neRs0RkapDiXjLBnuiGWR8oWPfPUl83Ot5qKsHSeMQZp/DggVVpCga
   Bz5iorrTSkXHozlBZYwyqrBCfhgYHqW4FfAWlkbxfgks0hM84zMf8aIqx
   4DlzfA5IICJvPrRLOC7NzhpMXRKyXVSmTO+4g1NIBe8D2vryCYPulB//O
   JXCMigdRAA0hs3sWWsv39OF5fbJjdVDO8UZd5k/2ZLldR7zRKJ1eszeFA
   MUCxZ+oKZHblbJO0hvunYJhJbSOBmRjAH97IJDR/KdjiNu1pERpiWqkIW
   9+gClAfjNBSQANEUznaB6lpPKLE5HPzArlaPHTQ8nBDNtmUxmewfZvLoH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="330790638"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="330790638"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 07:37:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="830007321"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="830007321"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 04 Apr 2023 07:37:19 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 07:37:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 07:37:18 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 4 Apr 2023 07:37:18 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 4 Apr 2023 07:37:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RIfdjuY2jGHbbv1Lmm+Qmcvay+6DPyOCgcYK6Fn8vCZkMQ4xt1DElbUyguFvNOltrTfQnJDCBB3CKV236XhP4p7WyUGhs952C/w4Sdg8UX7JfE916X+U2mTBA2IR1tWN8vG0NBXnBPVmUpKxhohfDYILsFAK60SL3cd0AnhIr7cjeM6pm17fFS1oZJ6md5G7z0/4r01F+kp+47aizMIyGOybtCwlaDp+lDwREM34VlS0CoM7wA7mJfI4o6+XIdFjEmx0PLLXn7MAz1eKxI7K1iU8j7NEg6xY6X0qKwlFs4zdGgFAQjCFuo3r2n35nBnrkGbLcc820iFp3lWCqgzD6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5VZf1JoUMHEF7p6sZsh7R88x2gwAASdAEWTeBTzorIU=;
 b=BWnVmCQss7FJVhrq5fXq8hfH3rUMPfAIAvN/CjDE0G56RP7H3K+U5m364wLPRHOPhERLvhk4+9sE4o5QXPcvD9NmeqIu+7/26+ScUErq6Wj/gx+gFuemLErMH3h0aYoyRv/i3AE6Ks5vTS/e2jAiYnnKIzch+R87YTOvjlZxNeUJZPHQE6yA954qf9Ru5sGVZ0hfEX0Q/2SWEp1F5q5jmDCZSM4koAian1mw+mQRIIvqMJDJ/e1FXet4ovICEzF7ZnEQ9DPXHMXQMwinZFui73G1LOfr26rCcxhf7nMi0JKCGhLO0FjiFgWDMbH8ydMCDTtjTG5xieVnWy9vivyuDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ0PR11MB5662.namprd11.prod.outlook.com (2603:10b6:a03:3af::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 14:37:15 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 14:37:15 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v3 02/12] vfio/pci: Only check ownership of opened devices
 in hot reset
Thread-Topic: [PATCH v3 02/12] vfio/pci: Only check ownership of opened
 devices in hot reset
Thread-Index: AQHZZKh8/nKgsyDFPUuOsexCLs7iSK8bMgyAgAAHEvA=
Date:   Tue, 4 Apr 2023 14:37:15 +0000
Message-ID: <DS0PR11MB75290339DD0FD467146D4655C3939@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-3-yi.l.liu@intel.com>
 <844faa5c-2968-2a4f-8a70-900f359be1a0@redhat.com>
In-Reply-To: <844faa5c-2968-2a4f-8a70-900f359be1a0@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SJ0PR11MB5662:EE_
x-ms-office365-filtering-correlation-id: 1f689e52-bcae-4a95-edc5-08db351a15e0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dr/tCu0twY+YX9XkuIHX4c2P1bv8V4BbGEBBj7c3ZjtWIuYtVfSbLOlMGcIWw+r8qnsiYFI3CyzZe1vTouZxusA6qZWyfQbacAZQimoe1xFa5xc229sUshy3+jq6bb1fUtxfFEMKp9iA4snsAk7uucTa/Q1/pNSJzk6RV7cfjLRk84HageWia/ad+ExXxU0W7hmGyhYxssabVjTidyje//yhKqZSPs4m3KxitULjoSQy0iFB22kCFtNqoCIlb3EAGuu3XvVhcfvjT/05a/fUMaRRqKDt3Aa3vY38/BbHh+4zpxNbLmPTAklQVdI0aDXHiN33p/gr0cseoLwxLQReVsPnOLt5qythdcSnEGJIDfSnFF/HMlJcD4021iwWe0y9H5kkGFogtWsXa55vj7Q2Db7zvert2g/uQRN+NuSDrDxCymYuye335/rw6gwEab/4OevGRp7Hl8XYDYMowSn3IqP2UrfnBRc8bI8gPKPeU4ApAc/fhV4so2qps2NNuM5zTGDEJfvyOakpXo1zk60heUwyDEHgYIpGd6aqG1tpLMHe/YJjBFEaaEI9gljIJWI4PS5ZtaQAUjJKH1m6XHyrq2LOFpt59Z8w/juafjfqv24SyexOb3V8iZzMa60OaU9b0gQitEJQ5bWkacPhYIs74g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(39860400002)(136003)(346002)(451199021)(55016003)(186003)(26005)(53546011)(83380400001)(6506007)(41300700001)(52536014)(54906003)(6636002)(76116006)(478600001)(66946007)(110136005)(316002)(4326008)(9686003)(7696005)(71200400001)(66476007)(66556008)(66446008)(64756008)(38100700002)(82960400001)(8676002)(122000001)(38070700005)(33656002)(7416002)(86362001)(2906002)(8936002)(5660300002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bmtDb0FuMXJFcElHaU9XN1pJSGMwQm9OK2pnbDdRb2pDbE1UZlc1YXEwdWpF?=
 =?utf-8?B?QkVpb3FHejZZaGFDVUJGZDFtWUxQMzRJSFpMS2JETS85UWtsa0xqT1JqQm1S?=
 =?utf-8?B?MVgzb0MxT0ZpWm1QWXFOVmM5QlV1cGVaSWpaWXVCaWQ4cVcvdVZDZ3AvNXJa?=
 =?utf-8?B?c3ZFaWJ5eWVOUDNvMFdVbWc0dlN5KzBncTZlTjB1dHVjZytKVzJHR29LMG94?=
 =?utf-8?B?S2VzU21PVlVtVkc3VFlMSCtpdEh4cG1UblczQ1JGWXBOcXdLTysrYUhpVVIw?=
 =?utf-8?B?MklEaUovMkNIUHRRR25JVW1aNEVuZmIvZys1bUpZckZ4VDJrVEwzZDhZaFVa?=
 =?utf-8?B?QjJzalVZbWFtK2hzVlZjeFhpNnA2blRPSTNXTGozV05YU0FnT2prNTMzN09u?=
 =?utf-8?B?VE51ckE2cU15c2xCc0xROE5maHpwMWZaNjVFT0NYK3N2QUp1RG1nT1VoWkhx?=
 =?utf-8?B?TFduTVNNRHpGMUpyczMvcGtUVjlGc0I4RVVReS9tNW9Pci92TjM2czROTnVj?=
 =?utf-8?B?aXc4Vms2K0h6TlVqUVdqdVo4Y1ZxYkZlWXVlSlEyUzZ0aTYwSXZHeGhiRlhv?=
 =?utf-8?B?Y3lCSTE4bGdsWGVybU9rL0ZuQ3cxQXk0RjMwWEZ4eDRzSytKWWdvd0NndHU1?=
 =?utf-8?B?ZFdWQkdxN1p4eHZ2V3lpRnN6TnhQeWVEbDlQUE1pckIzYkdSaCsxMnBuMUJi?=
 =?utf-8?B?OEc1S3BnNERDb1QwMjJibmxyY1pEaEoyWTIwdTFFM2NuVXFFNGlsZmVxQ2li?=
 =?utf-8?B?Q2Z3TmQrNmpmY0xncVhhdmtvQzU2eXZaL2E2K1ZISmFQQUdCWXpuSlQzbjY2?=
 =?utf-8?B?aVFEQmNxYU1keVBVN3pqWm5sRGpUYUcwQkhVa3FzS0pabVlGektncCtsWUVu?=
 =?utf-8?B?eVlQWlJQNXhWazBZRDZDdExTTjlFLzEyb0p5WmdnWkZjWUdQWTV4bXJWWDVp?=
 =?utf-8?B?N2g0Mno2OGc4djVQM2FxNjQva0J5eWl4YzlTWXRqMGF1WG4rVlRKS1p4SUhT?=
 =?utf-8?B?OHRja0ZWdW1FY0FhT2ZLN1Jqb1VGZFMyWVkwOWg2R3V0ZVZYRnpid2hXZXpX?=
 =?utf-8?B?VEtHNkdJdG9JTzJ3anhZUU1TQUlpS0t5WFZZWTBMNU5VRC9CcVVoL2gzQ2ZO?=
 =?utf-8?B?c2tCWkZBc2lhU0FKM3kyT1M2a1EzMnk3RUxIWU5NUXR0QXpKZEFRTGQyU0lt?=
 =?utf-8?B?V09TTGMzMjdlajlSUTZQSnJRdGUyMHJTdEhYekFjK0s5Mnk5enhQMjJpQUZL?=
 =?utf-8?B?L2Y5SVRQVXBnUzAxNGlkSzJLK3pRUnpGODI2aGVtRGFwMjFOcGJLaTVrUTdG?=
 =?utf-8?B?OFZPQ0pXUFdHTVBzQnlITlozdEFxM25selpBbXpqSjE3OWMyaWRMdnVPUDVo?=
 =?utf-8?B?Y2dHVTRzWkpLeTNOUkZBSTJ2cWQ4d3diTUdzbHRnUWtPajNUVzJEZmx3UEh1?=
 =?utf-8?B?ck5rUzFKTW93dHVOWDlHdHdMTXV6S09VMDg5dWo4ZGFHVTU3RXpwS0trNUdr?=
 =?utf-8?B?Zk12SzNrSjFWQWU1cW5uSVNXN0w0bzNXb2h6R2s3eThsYWQyUGhLNnhkNW94?=
 =?utf-8?B?SzJpVEE2KytFcDQ5OVBrajJ6YWJ0M2FuRllldTlRVENrTmNlM3g0MXBhYmV3?=
 =?utf-8?B?ZFB6MWc3S0tLeit4Q0RnTUo4OVlMSDRxUnQ1RGMvcGtHeEE1SXRwNTYrOFhB?=
 =?utf-8?B?eVNKcTJnZUVFT1l2em01V1NHYXhSQmhHaVU2V2Q4NWRlK0pEREpsbmFqeUs0?=
 =?utf-8?B?MW9nUHdHWjEyc004cUl4WkZVREJpRFhLMHBtcy8wYk90Tmg0YTU4b0xHNGty?=
 =?utf-8?B?VzhiZjVEY3BBNGRkN0Z3bVEzMlJKZW51TUczaWtZZHFjNWhnYjBHblh3bGR1?=
 =?utf-8?B?aStZVTRjenNBd2JLNFU5WXZaRVR0MXUxbDVLOXlTa1JFZlFGbTZjMi9VOVAz?=
 =?utf-8?B?RzdBUHZjT0I0RmxiakNleWs5VWRlVUYvYXIyYjBoUDNVQUd5NmZJZnR2YmJJ?=
 =?utf-8?B?eStOYi9KdWlnSzJqWjdsSkc2UDFZQ1VIZXlMUTh5cTJKajBoU3Y4eW1QNUZW?=
 =?utf-8?B?bXdqdnJlcW9LS1hTNS9PSHc4dWdLRlBoRTBhR1QzeGNwb1ltZFhUYTJvRlNy?=
 =?utf-8?Q?dEfM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f689e52-bcae-4a95-edc5-08db351a15e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 14:37:15.5048
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dncr/BBRTiXwHrFVZKR+DYHoGYTWGs5zK0MedtYIXHXfYUv9C2bfaLMG5yMAXJm3vct9QxPBR6U/BOjFwY58sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5662
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFR1ZXNkYXksIEFwcmlsIDQsIDIwMjMgMTA6MDAgUE0NCj4gDQo+IEhpIFlJLA0KPiAN
Cj4gT24gNC8xLzIzIDE2OjQ0LCBZaSBMaXUgd3JvdGU6DQo+ID4gSWYgdGhlIGFmZmVjdGVkIGRl
dmljZSBpcyBub3Qgb3BlbmVkIGJ5IGFueSB1c2VyLCBpdCdzIHNhZmUgdG8gcmVzZXQgaXQNCj4g
PiBnaXZlbiBpdCdzIG5vdCBpbiB1c2UuDQo+ID4NCj4gPiBSZXZpZXdlZC1ieTogS2V2aW4gVGlh
biA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IEphc29uIEd1bnRob3Jw
ZSA8amdnQG52aWRpYS5jb20+DQo+ID4gVGVzdGVkLWJ5OiBZYW50aW5nIEppYW5nIDx5YW50aW5n
LmppYW5nQGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBZaSBMaXUgPHlpLmwubGl1QGlu
dGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy92ZmlvL3BjaS92ZmlvX3BjaV9jb3JlLmMg
fCAxNCArKysrKysrKysrKy0tLQ0KPiA+ICBpbmNsdWRlL3VhcGkvbGludXgvdmZpby5oICAgICAg
ICB8ICA4ICsrKysrKysrDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwg
MyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8vcGNpL3Zm
aW9fcGNpX2NvcmUuYyBiL2RyaXZlcnMvdmZpby9wY2kvdmZpb19wY2lfY29yZS5jDQo+ID4gaW5k
ZXggNjViYmVmNTYyMjY4Li41ZDc0NWM5YWJmMDUgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy92
ZmlvL3BjaS92ZmlvX3BjaV9jb3JlLmMNCj4gPiArKysgYi9kcml2ZXJzL3ZmaW8vcGNpL3ZmaW9f
cGNpX2NvcmUuYw0KPiA+IEBAIC0yNDI5LDEwICsyNDI5LDE4IEBAIHN0YXRpYyBpbnQgdmZpb19w
Y2lfZGV2X3NldF9ob3RfcmVzZXQoc3RydWN0DQo+IHZmaW9fZGV2aWNlX3NldCAqZGV2X3NldCwN
Cj4gPg0KPiA+ICAJbGlzdF9mb3JfZWFjaF9lbnRyeShjdXJfdm1hLCAmZGV2X3NldC0+ZGV2aWNl
X2xpc3QsIHZkZXYuZGV2X3NldF9saXN0KSB7DQo+ID4gIAkJLyoNCj4gPiAtCQkgKiBUZXN0IHdo
ZXRoZXIgYWxsIHRoZSBhZmZlY3RlZCBkZXZpY2VzIGFyZSBjb250YWluZWQgYnkgdGhlDQo+ID4g
LQkJICogc2V0IG9mIGdyb3VwcyBwcm92aWRlZCBieSB0aGUgdXNlci4NCj4gPiArCQkgKiBUZXN0
IHdoZXRoZXIgYWxsIHRoZSBhZmZlY3RlZCBkZXZpY2VzIGNhbiBiZSByZXNldCBieSB0aGUNCj4g
PiArCQkgKiB1c2VyLg0KPiA+ICsJCSAqDQo+ID4gKwkJICogUmVzZXR0aW5nIGFuIHVudXNlZCBk
ZXZpY2UgKG5vdCBvcGVuZWQpIGlzIHNhZmUsIGJlY2F1c2UNCj4gPiArCQkgKiBkZXZfc2V0LT5s
b2NrIGlzIGhlbGQgaW4gaG90IHJlc2V0IHBhdGggc28gdGhpcyBkZXZpY2UNCj4gPiArCQkgKiBj
YW5ub3QgcmFjZSBiZWluZyBvcGVuZWQgYnkgYW5vdGhlciB1c2VyIHNpbXVsdGFuZW91c2x5Lg0K
PiA+ICsJCSAqDQo+ID4gKwkJICogT3RoZXJ3aXNlIGFsbCBvcGVuZWQgZGV2aWNlcyBpbiB0aGUg
ZGV2X3NldCBtdXN0IGJlDQo+ID4gKwkJICogY29udGFpbmVkIGJ5IHRoZSBzZXQgb2YgZ3JvdXBz
IHByb3ZpZGVkIGJ5IHRoZSB1c2VyLg0KPiA+ICAJCSAqLw0KPiA+IC0JCWlmICghdmZpb19kZXZf
aW5fZ3JvdXBzKGN1cl92bWEsIGdyb3VwcykpIHsNCj4gPiArCQlpZiAoY3VyX3ZtYS0+dmRldi5v
cGVuX2NvdW50ICYmDQo+ID4gKwkJICAgICF2ZmlvX2Rldl9pbl9ncm91cHMoY3VyX3ZtYSwgZ3Jv
dXBzKSkgew0KPiA+ICAJCQlyZXQgPSAtRUlOVkFMOw0KPiA+ICAJCQlnb3RvIGVycl91bmRvOw0K
PiA+ICAJCX0NCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L3ZmaW8uaCBiL2lu
Y2x1ZGUvdWFwaS9saW51eC92ZmlvLmgNCj4gPiBpbmRleCAwNTUyZThkY2YwY2IuLmY5NmU1Njg5
Y2ZmYyAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL3VhcGkvbGludXgvdmZpby5oDQo+ID4gKysr
IGIvaW5jbHVkZS91YXBpL2xpbnV4L3ZmaW8uaA0KPiA+IEBAIC02NzMsNiArNjczLDE0IEBAIHN0
cnVjdCB2ZmlvX3BjaV9ob3RfcmVzZXRfaW5mbyB7DQo+ID4gICAqIFZGSU9fREVWSUNFX1BDSV9I
T1RfUkVTRVQgLSBfSU9XKFZGSU9fVFlQRSwgVkZJT19CQVNFICsgMTMsDQo+ID4gICAqCQkJCSAg
ICBzdHJ1Y3QgdmZpb19wY2lfaG90X3Jlc2V0KQ0KPiA+ICAgKg0KPiA+ICsgKiBVc2Vyc3BhY2Ug
cmVxdWVzdHMgaG90IHJlc2V0IGZvciB0aGUgZGV2aWNlcyBpdCB1c2VzLiAgRHVlIHRvIHRoZQ0K
PiA+ICsgKiB1bmRlcmx5aW5nIHRvcG9sb2d5LCBtdWx0aXBsZSBkZXZpY2VzIGNhbiBiZSBhZmZl
Y3RlZCBpbiB0aGUgcmVzZXQNCj4gYnkgdGhlIHJlc2V0DQo+ID4gKyAqIHdoaWxlIHNvbWUgbWln
aHQgYmUgb3BlbmVkIGJ5IGFub3RoZXIgdXNlci4gIFRvIGF2b2lkIGludGVyZmVyZW5jZQ0KPiBz
L2ludGVyZmVyZW5jZS9ob3QgcmVzZXQgZmFpbHVyZT8NCg0KSSBkb27igJl0IHRoaW5rIHVzZXIg
Y2FuIHJlYWxseSBhdm9pZCBob3QgcmVzZXQgZmFpbHVyZSBzaW5jZSB0aGVyZSBtYXkNCmJlIG5l
dyBkZXZpY2VzIHBsdWdnZWQgaW50byB0aGUgYWZmZWN0ZWQgc2xvdC4gRXZlbiB1c2VyIGhhcyBv
cGVuZWQNCmFsbCB0aGUgZ3JvdXBzL2RldmljZXMgcmVwb3J0ZWQgYnkgVkZJT19ERVZJQ0VfR0VU
X1BDSV9IT1RfUkVTRVRfSU5GTywNCnRoZSBob3QgcmVzZXQgY2FuIGZhaWwgaWYgbmV3IGRldmlj
ZSBpcyBwbHVnZ2VkIGluIGFuZCBoYXMgbm90IGJlZW4NCmJvdW5kIHRvIHZmaW8gb3Igb3BlbmVk
IGJ5IGFub3RoZXIgdXNlciBkdXJpbmcgdGhlIHdpbmRvdyBvZg0KX0lORk8gYW5kIEhPVF9SRVNF
VC4NCg0KbWF5YmUgdGhlIHdob2xlIHN0YXRlbWVudCBzaG91bGQgYmUgYXMgYmVsb3c6DQoNClRv
IGF2b2lkIGludGVyZmVyZW5jZSwgdGhlIGhvdCByZXNldCBjYW4gb25seSBiZSBjb25kdWN0ZWQg
d2hlbiBhbGwNCnRoZSBhZmZlY3RlZCBkZXZpY2VzIGFyZSBlaXRoZXIgb3BlbmVkIGJ5IHRoZSBj
YWxsaW5nIHVzZXIgb3Igbm90DQpvcGVuZWQgeWV0IGF0IHRoZSBtb21lbnQgb2YgdGhlIGhvdCBy
ZXNldCBhdHRlbXB0Lg0KDQo+ID4gKyAqIHRoZSBjYWxsaW5nIHVzZXIgbXVzdCBlbnN1cmUgYWxs
IGFmZmVjdGVkIGRldmljZXMsIGlmIG9wZW5lZCwgYXJlDQo+ID4gKyAqIG93bmVkIGJ5IGl0c2Vs
Zi4NCj4gPiArICoNCj4gPiArICogVGhlIG93bmVyc2hpcCBpcyBwcm92ZWQgYnkgYW4gYXJyYXkg
b2YgZ3JvdXAgZmRzLg0KPiA+ICsgKg0KPiA+ICAgKiBSZXR1cm46IDAgb24gc3VjY2VzcywgLWVy
cm5vIG9uIGZhaWx1cmUuDQo+ID4gICAqLw0KPiA+ICBzdHJ1Y3QgdmZpb19wY2lfaG90X3Jlc2V0
IHsNCg0KUmVnYXJkcywNCllpIExpdQ0K
