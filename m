Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699D96D768D
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 10:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237387AbjDEIMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 04:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237310AbjDEIMo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 04:12:44 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986B24ECF;
        Wed,  5 Apr 2023 01:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680682337; x=1712218337;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RqrC2mQ2l/zUIpKuNIm+yj2o3akAUONNJJS6JGurkhI=;
  b=gpOlvBn5HWzUfvOOgvMlCh5D3hiVXqSlwFzW+RcRUUaxNQO+ulevW9fb
   +jVSgvZEGLn+PFoGYcRX+ywocqJNmeRTfp1wsPahk/rZVOihewO0mE4J2
   gY5Dq2YcbYov5S76EiUigOQyginZ5cIxJwSOAx/rLHpsWLAzastQw/jFU
   nB50mEDXgTZQpKsT3EHx9bjDC2991gvAf8Df/U+EMnAOMKsrH7LNZ/gSt
   RxqWgXrF4cEIA4+K9Ke4eDdgnf/UfOZVADOSmI1ZNDT2s+UORK5sOg35E
   ATt0kaFIQ8GsPH4KdlGzrLZN1sw+Tgtis4jyAa93cyldEQ3SlN7cxneCt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="322777982"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="322777982"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 01:11:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="810552780"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="810552780"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 05 Apr 2023 01:11:03 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 01:11:03 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 5 Apr 2023 01:11:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 5 Apr 2023 01:11:03 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 5 Apr 2023 01:11:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PwKF/JEHKCjUYz5iFr1t9LCKeZBQlfBwdqFOLY1EOduNmCxx1IWDmdL9nw56I2iPB1AKP8qdxIaCTLkMTzpPwc+jDQ5LhHdTrcZmbPetAKqwBZYZdRpBDDiid+2i/W8Qdc70/Avo+1WOOnb77qJyN62filez+XInVfmdzdooRnETtIm8Oj4IClpNidDfhqvXFS0iqjmHPZj8XZjYlMVi+wpX02dD4rGdFgodrcafn2Ys+FiE+xLXh44b2VJMJD8qC14vW1OMegNQMc+XmtKGLfqwe3aHkytZxKERQYQnPchruXcgRZjNB/uNN2de2/CihfXxWpm/aECSZJR1yz9MHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RqrC2mQ2l/zUIpKuNIm+yj2o3akAUONNJJS6JGurkhI=;
 b=TYSI31o7G8lmUOF+/XJpFZ+2yfiMbTys0TJwC/u6wxWMg6IzHHgzU7vsQaTTofSPPQ+CjYnFLQFHMJdkc4/CrBKhCF/pYimieXG56VCesSP/hQ2tCsHdixYViaPTnRoGYdsmpTmEUeHxqqkS+9wUVlwuB9+NCTpGYtL9k0ax/iMJ3jOrVys83xyn/ycAorm4yf30pkWf5bLUTVt8cQKLri0z7XyaYQGj9d5w3gianMeCFRIyD2XI9iGNODtVWBnXHu2ApUYXPx8X6qMhamJkFB3n/YSjjyoJpQRhBkNkVb8w+N/kNivphkQiwgFJKBDtYu2pQPyroGAaO2gPnudPrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB7711.namprd11.prod.outlook.com (2603:10b6:510:291::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Wed, 5 Apr
 2023 08:10:56 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 08:10:55 +0000
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
Subject: RE: [PATCH v3 07/12] vfio: Accpet device file from vfio PCI hot reset
 path
Thread-Topic: [PATCH v3 07/12] vfio: Accpet device file from vfio PCI hot
 reset path
Thread-Index: AQHZZKh+JmyXbsTd2EuAMkD7I6fcTa8cYhwAgAAAqFA=
Date:   Wed, 5 Apr 2023 08:10:55 +0000
Message-ID: <DS0PR11MB752943C77E29289C36880606C3909@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-8-yi.l.liu@intel.com>
 <f92c5f99-f519-e67c-71a9-476f08e4117c@redhat.com>
In-Reply-To: <f92c5f99-f519-e67c-71a9-476f08e4117c@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH0PR11MB7711:EE_
x-ms-office365-filtering-correlation-id: d5d918fd-b546-41c5-c6f3-08db35ad47fe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8TupGlXQqoeNcFs3yp35uv44heps8lNGmhJ1Mlj3nZPvzVb8ch7KaeJg9EGxuBBgBJjKFpgeaNa2c0I1MEKZjNvZwG5ZDpCy+VCE0bYp1ooB+5oBTTK0bw8jUbFyYtkAJawdNw0PW4ekqd3g3dAmFgauIvJyTudlmyYODvI6fVQgXKZI0HjhuRbrD3HdwAFswNHusLpxDq6i+94H5WznpcwHp082fDnNFKio4qiEkLRMNY59zhl1wVyFcWgvNl3m8xM0r82zHiX4I0C1ZRoSCPRBaoDhzLFdTuPt9rwh3JMJxoQt9AR/4SneGZWHd3rCNyICVJ1rRVIcf2XOex8BC4NxTbAJmuzuj3tdIz9Z9sjE/Q9qQMXnGwVx47tLejR4nWvQ5i5GQXbhhjCkvENzoQDT0VMr8B/vXfrAq2PbCJjI25yzg0H4WP6UDzywxE4l68EFG8IgBcJulLTgT4iQIOY1AfmdnL6BWk4k1oFa5gIWeDoQt60C54QR5MhUGZAP56ckex5GHpowyEHQWwFTV/U4+zbgyw3Q6GY/TWt8n2yVQs6cho9LijIvhHwAAe8mdjI/ujAuW9KNzGr6tM7+wLeiy/M+LDqa+lvNORwIpW0ho11g/nq9tY/JV+zr4Ut2nolwOKYApwA2vkzY4qWmLw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(376002)(39860400002)(396003)(451199021)(8676002)(64756008)(6636002)(66476007)(54906003)(66946007)(110136005)(66446008)(76116006)(4326008)(66556008)(316002)(33656002)(26005)(83380400001)(53546011)(122000001)(6506007)(186003)(9686003)(7416002)(71200400001)(8936002)(478600001)(55016003)(38100700002)(5660300002)(7696005)(41300700001)(2906002)(38070700005)(86362001)(52536014)(82960400001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bnJJd1dkVzhOUjJhY3E0eGtzQThqdFQ1RzdrTEQrVUFBbERDaUpNQjVuaWw3?=
 =?utf-8?B?WDVhaXNFSzhCakJxc21hakk1WUJZakR0WmZRR0FxR1hjNkRvaGpqczhrclQ5?=
 =?utf-8?B?Q21BZGpBUnozcmROQ2NSRWZpUkxpZmtsOGd0OWFxVUFuZk1WS0NyUmlMZ2RO?=
 =?utf-8?B?RlFXM1F1K1NpYWZ0bElpdEkxVzFjcVZQUkdna1AvdnEyb2llOXlVNjN2S2tw?=
 =?utf-8?B?Zk9DVSt0dzNsaEdneDZaOHJaNVN5YXNsblFSTWhmWjdhaEFQUDBYZTIyS3Bs?=
 =?utf-8?B?QXdjckxQRXIvTnZRNFc4WGhvSm90Y1hsV2xUdW5rakNIV0tLNisyUm82SGZ1?=
 =?utf-8?B?OXBudy84OCtSTlRhR1VrVjJOZjNiR0dqTWtlVTFYSzVJZXA5OUMxRTRmRVo1?=
 =?utf-8?B?Uks0eEFDaGJFZEh1RHZmZWlyeVlnVm51WG8zQ3pMdUR2dGpOWjRtVTEvTXlO?=
 =?utf-8?B?OHdzV054cEppMlY1cnkxSC95eTBXV1VFd29ENkFKMElhUGhrNWxzMEFaS3N6?=
 =?utf-8?B?TEZlZ1J6ekFUazY5YUpBbnZ3YlJ2c0tEdHI0bnoySVJzeWNIb21oc3RHb3NT?=
 =?utf-8?B?Z0FsQWpxM0M1NHZTRTNaV292aDJIZzk4c0l0SWdaQUt1ZjF5S2d6VWJMZDI1?=
 =?utf-8?B?UGlNV3NFZmQxTXZlS3F5ZVdVd01JY00xd1NQWk1HcHZpOEZWeVhyUVhxMjF6?=
 =?utf-8?B?bzQ4K1Uyb3dTS2VFMFFreWoxZDU5VHR3eGtUb1JlUFN1Rk51cHpKdDVpSU8v?=
 =?utf-8?B?eEZHQms1T1E0aG1wRjN2ZkJUQzZ2K1RsZk45dmZpRVFaOXRieGtTN1VrWkFR?=
 =?utf-8?B?Ynh6d0NYeEVhMXMxVC9ObjdZN1R2NjBUVzgwNm5vVldRQ3h5QXo2dHFoNlVT?=
 =?utf-8?B?Z0wvT1UzK2RIOStjTE05azdCRXE2R1NUb0xRRGZTb0hVM2VKTkFVdGpFY1FR?=
 =?utf-8?B?R3RoTjRqTkcvV2QwdllRREpEWEVlVzlSM1diTkVaYXRuN3J3YXA1bVgxRC80?=
 =?utf-8?B?S0hnbThyWWdHc2hESEJlTHlpSkxEUjFOR1Ayam5FTjZURXpVSXYva09xOTU3?=
 =?utf-8?B?L3BJQ1ZWc1EwQXlreVJtS3lWaHpuTitnaVNTM2JuOUJpbC9reXNXRnJTekpW?=
 =?utf-8?B?SzdkL2E4RmtPVVJjdFZYZGJLT3VQbksrckdCbE14YXBzQmp5VnA1bG04S3J0?=
 =?utf-8?B?NnB3bDFEODBUM2U2YmNtSHNqaGlhdGpJTUtwWVBjLzREMWR6WW03Z3Q3alV1?=
 =?utf-8?B?N2x1VFB1TUt3VGhIYWx5bmloTXJqaGoxUFlQTCtHNjIyU0J0TktMaHk4KzEz?=
 =?utf-8?B?WVJSUHVKY2RwSWxsaVQ1QTVYSUt0UE9TSHZtL2FHaXBVM25nZndtTUtURE9j?=
 =?utf-8?B?WGNHd0pORlo4U0UyWUtyWGlONFVWTVowYlVtZ0FHSHhPUXc5UDVPeHZ3U041?=
 =?utf-8?B?NlhycUVsRmRYT2VnWjJrczdURXlzR3YzbjBTdU0zS01ndmFUd2JTeEo3SGVU?=
 =?utf-8?B?WGJmdVlvd0V0LzVQSldqblptZEpXMXp2TkV6OWUwSkxhaEM1bE5uYzlmOUwr?=
 =?utf-8?B?R2d6YUhvR1N3Rmp0MlZDQ2dJVGI1amJhL1hnOXpGcXh2K0dhdkFRNFlGMlAz?=
 =?utf-8?B?VEFoR01PdnptRVppYW50VlcvSVdLUEVYeERadCttLzRNU2NGbFBhbUN3M0VR?=
 =?utf-8?B?TkN0VXI3WDZDeitIZFVac2Z1bStCQXZxd3EvSHp1aGpLRmVDUDVRSkhQR09M?=
 =?utf-8?B?aktSblFTTHVYYWxYVkc1eWxrTzYrSDY4TGs5a1MyalRzQm9HWldDZU83bFFt?=
 =?utf-8?B?eFlXeENBZ25HWXB1aVVDRmkyNnByMEFUTzgzSDR2eW5iTUUzYVFDemV4b0Nn?=
 =?utf-8?B?QjhXQU00Q09VQXRKcjFqSFRPZDdHbk96dE9VTXprU2huakwzc215UTZKSkkr?=
 =?utf-8?B?Nlh0Y3NOMHkwMFdiWXhFcjUwN1lOdzBtVmV1T1poMjN6R1hxQlhMRWplRkpN?=
 =?utf-8?B?VDYxd2NPSGtIZkdWWEpSZ1ZiMDU4bTU5akE1VHAxTmpJb3dwS2I3S0d4SjFj?=
 =?utf-8?B?Z2tqaWtrWGhBTkpvV0Y0TTdGMHlmS3hOdlFtRUV1KzhRUmtmajlkRWlOL1M4?=
 =?utf-8?Q?SJlWb7UfWfzIz9EqV8T6995hi?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d918fd-b546-41c5-c6f3-08db35ad47fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 08:10:55.6059
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z1LxjViiBjE0Z4ms4ULoB8/WZZQpQqf3MEkOFY5pMBBCLdJeswCTygHOg9H2sI945IqUd+ZqvD6yWf5OoHxpLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7711
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgQXByaWwgNSwgMjAyMyA0OjA4IFBNDQo+IA0KPiBIaSBZaSwNCj4gDQo+IE9uIDQvMS8y
MyAxNjo0NCwgWWkgTGl1IHdyb3RlOg0KPiA+IFRoaXMgZXh0ZW5kcyBib3RoIHZmaW9fZmlsZV9p
c192YWxpZCgpIGFuZCB2ZmlvX2ZpbGVfaGFzX2RldigpIHRvIGFjY2VwdA0KPiA+IGRldmljZSBm
aWxlIGZyb20gdGhlIHZmaW8gUENJIGhvdCByZXNldC4NCj4gdHlwbyBpbiB0aGUgdGl0bGUgcy9B
Y2NwZXQvQWNjZXB0DQoNCnRoYW5rcy4gd291bGQgY29ycmVjdCBpdC4NCg0KPiA+DQo+ID4gUmV2
aWV3ZWQtYnk6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0KPiA+IFJldmlld2Vk
LWJ5OiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiA+IFRlc3RlZC1ieTogWWFu
dGluZyBKaWFuZyA8eWFudGluZy5qaWFuZ0BpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTog
WWkgTGl1IDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvdmZpby92
ZmlvX21haW4uYyB8IDIzICsrKysrKysrKysrKysrKysrKystLS0tDQo+ID4gIDEgZmlsZSBjaGFu
Z2VkLCAxOSBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvdmZpby92ZmlvX21haW4uYyBiL2RyaXZlcnMvdmZpby92ZmlvX21haW4uYw0K
PiA+IGluZGV4IGZlNzQ0NjgwNWFmZC4uZWJiYjZiOTFhNDk4IDEwMDY0NA0KPiA+IC0tLSBhL2Ry
aXZlcnMvdmZpby92ZmlvX21haW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvdmZpby92ZmlvX21haW4u
Yw0KPiA+IEBAIC0xMTU0LDEzICsxMTU0LDIzIEBAIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlv
bnMgdmZpb19kZXZpY2VfZm9wcyA9IHsNCj4gPiAgCS5tbWFwCQk9IHZmaW9fZGV2aWNlX2ZvcHNf
bW1hcCwNCj4gPiAgfTsNCj4gPg0KPiA+ICtzdGF0aWMgc3RydWN0IHZmaW9fZGV2aWNlICp2Zmlv
X2RldmljZV9mcm9tX2ZpbGUoc3RydWN0IGZpbGUgKmZpbGUpDQo+ID4gK3sNCj4gPiArCXN0cnVj
dCB2ZmlvX2RldmljZSAqZGV2aWNlID0gZmlsZS0+cHJpdmF0ZV9kYXRhOw0KPiA+ICsNCj4gPiAr
CWlmIChmaWxlLT5mX29wICE9ICZ2ZmlvX2RldmljZV9mb3BzKQ0KPiA+ICsJCXJldHVybiBOVUxM
Ow0KPiA+ICsJcmV0dXJuIGRldmljZTsNCj4gPiArfQ0KPiA+ICsNCj4gPiAgLyoqDQo+ID4gICAq
IHZmaW9fZmlsZV9pc192YWxpZCAtIFRydWUgaWYgdGhlIGZpbGUgaXMgdmFsaWQgdmZpbyBmaWxl
DQo+ID4gICAqIEBmaWxlOiBWRklPIGdyb3VwIGZpbGUgb3IgVkZJTyBkZXZpY2UgZmlsZQ0KPiA+
ICAgKi8NCj4gPiAgYm9vbCB2ZmlvX2ZpbGVfaXNfdmFsaWQoc3RydWN0IGZpbGUgKmZpbGUpDQo+
ID4gIHsNCj4gPiAtCXJldHVybiB2ZmlvX2dyb3VwX2Zyb21fZmlsZShmaWxlKTsNCj4gPiArCXJl
dHVybiB2ZmlvX2dyb3VwX2Zyb21fZmlsZShmaWxlKSB8fA0KPiA+ICsJICAgICAgIHZmaW9fZGV2
aWNlX2Zyb21fZmlsZShmaWxlKTsNCj4gPiAgfQ0KPiA+ICBFWFBPUlRfU1lNQk9MX0dQTCh2Zmlv
X2ZpbGVfaXNfdmFsaWQpOw0KPiA+DQo+ID4gQEAgLTExNzQsMTIgKzExODQsMTcgQEAgRVhQT1JU
X1NZTUJPTF9HUEwodmZpb19maWxlX2lzX3ZhbGlkKTsNCj4gPiAgYm9vbCB2ZmlvX2ZpbGVfaGFz
X2RldihzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IHZmaW9fZGV2aWNlICpkZXZpY2UpDQo+ID4g
IHsNCj4gPiAgCXN0cnVjdCB2ZmlvX2dyb3VwICpncm91cDsNCj4gPiArCXN0cnVjdCB2ZmlvX2Rl
dmljZSAqdmRldjsNCj4gPg0KPiA+ICAJZ3JvdXAgPSB2ZmlvX2dyb3VwX2Zyb21fZmlsZShmaWxl
KTsNCj4gPiAtCWlmICghZ3JvdXApDQo+ID4gLQkJcmV0dXJuIGZhbHNlOw0KPiA+ICsJaWYgKGdy
b3VwKQ0KPiA+ICsJCXJldHVybiB2ZmlvX2dyb3VwX2hhc19kZXYoZ3JvdXAsIGRldmljZSk7DQo+
ID4gKw0KPiA+ICsJdmRldiA9IHZmaW9fZGV2aWNlX2Zyb21fZmlsZShmaWxlKTsNCj4gPiArCWlm
ICh2ZGV2KQ0KPiA+ICsJCXJldHVybiB2ZGV2ID09IGRldmljZTsNCj4gPg0KPiA+IC0JcmV0dXJu
IHZmaW9fZ3JvdXBfaGFzX2Rldihncm91cCwgZGV2aWNlKTsNCj4gPiArCXJldHVybiBmYWxzZTsN
Cj4gPiAgfQ0KPiA+ICBFWFBPUlRfU1lNQk9MX0dQTCh2ZmlvX2ZpbGVfaGFzX2Rldik7DQo+ID4N
Cj4gV2l0aCBBbGV4JyBzdWdnZXN0aW9uDQo+IFJldmlld2VkLWJ5OiBFcmljIEF1Z2VyIDxlcmlj
LmF1Z2VyQHJlZGhhdC5jb20+DQo+IA0KPiBFcmljDQoNCg==
