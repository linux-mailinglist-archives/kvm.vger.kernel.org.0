Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC166BDF80
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 04:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjCQDUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 23:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjCQDTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 23:19:15 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EC3A9098;
        Thu, 16 Mar 2023 20:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679023077; x=1710559077;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OsoEYw5zbAxz9/1MBxu2aRwyUgpPBsteqRJm4rrmFys=;
  b=U+KczehnENdbvgzi6JZqT766pBjdWZ7ZXWgn+nDJu/hT9z1yN8xMWIEn
   CSSLVc8Yl0N7LN7kSE6bW5NurovzX754dSTYzObTNtq/JiCFcArfXDxzl
   jslmh0gslsfY0Cj1a1A8zW4gcnrsGA5hX998jznUvFqaSLSFRqtoj1PYF
   wR1PwJ6iTkQ21gZX7kWOAV2ITWXO9XwDW5NEE+PFfuH5rgzWS75WJbaAf
   9oK7ob7pHxFGt9lYFnKIJ95XREM8fgjJAWVPmaLsFcDVgz9y2aoOKAAik
   u4/LqLupDkQCY7weRcv4BD3clNKu/JPtt3Ri4dmoNvmmo44O43y3zQP9x
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="317827140"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="317827140"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 20:17:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="744402838"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="744402838"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 16 Mar 2023 20:17:27 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 20:17:27 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 20:17:26 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 20:17:26 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 20:17:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WuCxeV/u/JewSxbW4F8XhtqukK2xx4ea6zEVn9RpFPOk+nMYyzBLWvMF55m4oFPYTvHCzu585EHaXDDbuTfckOjpPp49UQoNLD+Uny+cuxVR/ZWZcP/aL5xG0+oogC85C5J0F7LoYSv7qegl4lTxtfoU/NjZsQXBUDzatM0qqCglCZymVu83rQE7X2Ao4QrEywiXVZpsvOgr71qVIUm5CGdvZRRqkW2wWcdYpC+bDzBrxeANGEN0aEzjmhycA+QiTKeN9DPYtHAbvExaNemKPgSThAJDjU8M83gkQRxVXOVYs7Cj33ARzcpy7dF81xt2CaDSDHnr377qxz4Q+IkgvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OsoEYw5zbAxz9/1MBxu2aRwyUgpPBsteqRJm4rrmFys=;
 b=JIGMjMhxznCT3Dv9rmI6DpK0WjrkZgecRK6ghJFHecdnZLmC4Al7W6miWKj26vydOFLDxRlAXvWWyh/4eR56YGIUQwzd9UutmCzBVNUUYnYwaC1U0yAn7oXbTrEI3DuQ586Kz+r49VnQnTNim6m2dHXiScd5jfId1SxyyK076sNbaODrphRgtdq7VKPlWM6J/Y7V82gMVNoyfU7xVOpSpUhD3MzVhDzl54N9F6WfkpMd5b0vXuXghccvAhzqfm/ckHLzg4dByQuqBeInhmJSemFzi9Hxrh0d72tVpn9EF4JGfEp4L+wgxSS9yjuidk5bPrJ7uHKOYjKTVUM3NtqIyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB7373.namprd11.prod.outlook.com (2603:10b6:8:103::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Fri, 17 Mar
 2023 03:17:24 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 03:17:24 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
Subject: RE: [PATCH v7 15/22] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Thread-Topic: [PATCH v7 15/22] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Thread-Index: AQHZWAax3HHdmgaIcka42QBoWIvZ1K7+O3vwgAAPbQCAAALXYA==
Date:   Fri, 17 Mar 2023 03:17:23 +0000
Message-ID: <BN9PR11MB5276F40C9C448101616CF11F8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230316125534.17216-1-yi.l.liu@intel.com>
 <20230316125534.17216-16-yi.l.liu@intel.com>
 <BN9PR11MB5276399B61F4E2E260BFFEBA8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB75291C8343E91ACF2401AB3CC3BD9@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB75291C8343E91ACF2401AB3CC3BD9@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB7373:EE_
x-ms-office365-filtering-correlation-id: b5a9a50a-b5de-4bee-985e-08db269620d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tt9JS+fIYQNsTAmTBlQbm/fJIgHQZI55QauQer957jDfXL7LLJwCmfSCWyOx0xDZaDWrECQVQymXUAPyRWIggXVlD0MrvC39NK2lG1GNCT1WrzzQ2ZxbQQba7KzsUoVchTKCQY9zj1YI448pmM0cJq19pbBnCbwLFRhWaOAbOYH6xKNkBqKDBjMH4x/jWIv4PteNSSCA6xdT4aJ7Jo2Qyd4N0shT0tSmRFpITAWTii2DkbRfS1WqfkiAE4eKOBy16dh2dMQj5sYD/VwQ7kC27ja1UjOCsAL4eevi3s3uVPAGUK2TLTj+8WzbcXCUqhsvatEIU8vvTYWSwmpa1WGtcJPoXyM/gblwNFU30bos4krMdtOufVNJBW4nNMO6Y7K4nOsoWhv4dOWWx2C5HljFquuayzDhVkwUmJw+Lk41GjOBOR1ifIv9wQovtukbXwtakY5vL3N6TvNTP+ible5/DvHa3jsrMDhBXtDSDdcgEiPcqKIbTKE/XhQu33OphVqvsEaO9P5FrUcBOjmO1hBP1jmhtfqBbkixzYXlQCgPR5+KwKcramcnR4Um7DTiZ8sgKnSpycO4ug4q7da3NELPXyMxG1ZIicKCpL/wbKok/rlA3ijvJSon64KVUGYvNO9r6oYA+t4gBMMUY1aVpeiWSI7+Tu6XgdPdI3WTpMrYk1xm5pSrcHz9V8MDCgWfonNg8AhAK7qj7XVM9rSL+cvDjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(396003)(376002)(136003)(451199018)(83380400001)(38070700005)(55016003)(33656002)(122000001)(82960400001)(6506007)(26005)(186003)(9686003)(38100700002)(66476007)(86362001)(478600001)(7696005)(71200400001)(316002)(8936002)(66556008)(64756008)(4326008)(8676002)(76116006)(66446008)(110136005)(66946007)(54906003)(2906002)(41300700001)(7416002)(52536014)(5660300002)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eEdXWGpxam53SURWY3ZLTnJpUSs4cElRZ1ppKzRWSEl6OFpIcnFlbVQ3K05w?=
 =?utf-8?B?Z3dBUWl4UEF0VDY0Y3lIRDhZY2k3MmtQS01oZ01rNnQ4L1RPcGJVQzE0ZVUw?=
 =?utf-8?B?Q0ozSEpMemtSbjMrNmd1RnQ0SHZiWWIrZ3VVcDlHRjJSZ0tpOUZLeDhqYTdZ?=
 =?utf-8?B?QmR0MDlMNTRLd1VwNlNzZ0hacmRKbjNGMzlXS1JSaXgzMWNFT1FVajlVcVRm?=
 =?utf-8?B?SnpqdDFLd2FpRUR4bDFodCt6S3FhaFphYkVpajhsL0w1dzFoQjlSc3ZJWjdV?=
 =?utf-8?B?d3l0UXNnUFhBMlVPdllmR2JRclBzNnlXbVUzMUtjMUFVaURkMlI3b083RzBp?=
 =?utf-8?B?eEdRbllLcnpNVHN6UkRPeENhU2ZpWmIvQ0FhQ2VHK2JYNHJlOXhhSmI4dmhZ?=
 =?utf-8?B?VFgrVTFsN1kva3dONXpIWDVwZnl4Q3ZFaDVJYTBmSjVBcEVPL0lJcGl1UFdH?=
 =?utf-8?B?RDdNaUgvcFBHSE15bkNxMjlxUG9lUUsvcW9kNzJXbHpJUmMyb3Zaam12dGkw?=
 =?utf-8?B?bnUvRXFLZEpKRFZ4SThmMW5sU0U0VlNJMlBnK0ZOa0ljN2lheXkxM3hzK2tu?=
 =?utf-8?B?QWJnVGg3UytDSDRNb3lpWnJ2RW5GQ0JhTFJOd1paNk8xcUpueFZCWkpFU3h2?=
 =?utf-8?B?WitpTWM0T09Ia2xIbm5xZno3VGkvd2oxVVZUSjVTTytxTTJTQ3Y3NkdVaC8r?=
 =?utf-8?B?VTdYWkw0YVNBbGZYbnBwUzI2M2dWZGh2cVYyK2hMUVY2WEJoRWdQREIrUFYy?=
 =?utf-8?B?d3dqVSs3MUZzVG1PNGtJKzlYdEVGZ1JBSXhPOWRnRFJXS2pNcTlFbldvQmFn?=
 =?utf-8?B?K2hwWTZIYkltT1hXS3YrbTE1Wit0dUJXSml3cUVaQ2RJWHcra3A0eUM4VTJB?=
 =?utf-8?B?Rk51VW1YVUI1N1VNc2JVemZsS1NyL2xFWDVVbzM5UUhxU05kbmZHY2tlTkRn?=
 =?utf-8?B?eHZ0SytoM2tZeFhHK3JNK2lUd2dHb2dWZHlXTDh2VUR4dkhidTJ4dXhkbGh4?=
 =?utf-8?B?dStBdnRUWlNzQlV3RmtDVnEwUllMQnoxUXcrTUFHWDBuQVZSNXFoRkVZTFdo?=
 =?utf-8?B?Q1NUeU5idWlncjgvUHNkRlRDcUd2L3BQYW8yZHJrTm8xWTJXZVgzTFpubzdR?=
 =?utf-8?B?N3ZkbDBvbG80UjV6V2IxK0Ywc001cTVGK09aT244Q3V0dk5zYURlUzUxZ3pK?=
 =?utf-8?B?cmJZRmZiQ1czTEZLNm1MNDJEcEwyOTZ4K2tGaHVSV0c0cGZXbTNDQ1lMMU1x?=
 =?utf-8?B?SElFeHBsaHg3V3YxcVRZRnlVVUpzVjZnZ0pueXRmdlQ1M0NxeWtOd3pucDlG?=
 =?utf-8?B?N2tpOGEwVDViTlQ4L3habUhYckZpQ3JrOCtuck8xK0ZqUjA3M2NwS3FOVkNJ?=
 =?utf-8?B?NGEwR2VYNEtuTlY3UHNpWm1GUEs1bjRqdFdnQWM1eG1RUVZndXNQYUhIRnZa?=
 =?utf-8?B?WkQ0cnBBVUIxLzBwczFCbnlnekY1MkRWa3NadHlZTTZuR0JkVHBML3ExamVT?=
 =?utf-8?B?UmVmak16ajE1NmFPNnk5RDFnd2l5ZnFZTlAyamlkQXpvLzU0VTk5cVdXdjQ1?=
 =?utf-8?B?VEp5aWRTYVBKUVBMbm1oY2VuUzlYT0ZXbVJrb2Z6cWxKdFVSbDczOXZERmh3?=
 =?utf-8?B?K3hBNTRvVEFWNXlyUEhUR21xNHFrSmhEM2hMMWFsYU9CcCs0SU4xZEZFZ0lQ?=
 =?utf-8?B?a1o0NEF4dnFmZmtsUTM1YWVqRGRMTmtvbk5tbW5hVVZSWndoanRKZ1lEN3hK?=
 =?utf-8?B?Qnh1b1FFYzRnaHBRbU5LMTJXRDB4dzJKNlJXYkkzZGxEU1VuWG51QkhUNXV2?=
 =?utf-8?B?bDBVZ1NoVnJDeHU1QXkzZWxEclAvRXVuNHhsekkzM3p3QmNybE1BZHAzSzRa?=
 =?utf-8?B?eTRsL2xsWStPeHIvY01Mc1Ric1lPUTRwS1YzeEx5dU5lS2VKNW9CWERERU1j?=
 =?utf-8?B?K1IyRys1TDhXQy9qYVRWSkhSTDhyYXAwM2RJOG1QMHpVQ0xsbERTZzNNT1hx?=
 =?utf-8?B?Z3BreFZxYzRUNmdZVGJrUTM3cEdsdHdnd0dzaUd4UmMyQVBkTWh5Zm0wSjNP?=
 =?utf-8?B?SFQ5ai80T2FyNGtCUlA5TCtYZjZGTnpGOEc1TEJEUXI2Q1ROdFBzc0RIbmxR?=
 =?utf-8?Q?+H1PwaxmhFhvICSFGrl25NMvg?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a9a50a-b5de-4bee-985e-08db269620d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 03:17:23.9923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o5PpXBsp2kw+Y8k073vtZ41BapMDJmnn9BpL7UJvC9Thuu+HWdzfS+xi05ygL5eZBoUjqGS+peOzrV7PX7Qiaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7373
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBN
YXJjaCAxNywgMjAyMyAxMTowNyBBTQ0KPiANCj4gPiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4u
dGlhbkBpbnRlbC5jb20+DQo+ID4gU2VudDogRnJpZGF5LCBNYXJjaCAxNywgMjAyMyAxMDoxNCBB
TQ0KPiA+DQo+ID4gPiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiA+
IFNlbnQ6IFRodXJzZGF5LCBNYXJjaCAxNiwgMjAyMyA4OjU1IFBNDQo+ID4gPg0KPiA+ID4gK3Zv
aWQgdmZpb19pb21tdWZkX3BoeXNpY2FsX2RldGFjaF9pb2FzKHN0cnVjdCB2ZmlvX2RldmljZSAq
dmRldikNCj4gPiA+ICt7DQo+ID4gPiArCWxvY2tkZXBfYXNzZXJ0X2hlbGQoJnZkZXYtPmRldl9z
ZXQtPmxvY2spOw0KPiA+ID4gKw0KPiA+ID4gKwlpZiAoV0FSTl9PTighdmRldi0+aW9tbXVmZF9k
ZXZpY2UpIHx8ICF2ZGV2LT5pb21tdWZkX2F0dGFjaGVkKQ0KPiA+ID4gKwkJcmV0dXJuOw0KPiA+
ID4gKw0KPiA+DQo+ID4gdGhlIDJuZCBjaGVjayBzaG91bGRuJ3QgYmUgYSBXQVJOX09OLiBJdCdz
IHVzZXItdHJpZ2dlcmFibGUuDQo+IA0KPiBZZXMuIGl0IGhhcyBhbHJlYWR5IGJlZW4gcmVtb3Zl
ZCBpbiB0aGlzIHZlcnNpb24uOikNCg0KSHVoLCBiYWQgZXllcy4g8J+Yig0K
