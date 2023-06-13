Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4CB72E61E
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 16:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242287AbjFMOoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 10:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242098AbjFMOoe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 10:44:34 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A498E53;
        Tue, 13 Jun 2023 07:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686667473; x=1718203473;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EAcH2g7hNdMDS60DdzPX7xb6tAkWLhTJjWbOgXDwhsw=;
  b=PEWBSj5f4nIJJDBpBU5NLOH4onAsYepIoT/LAZPmzs6gF801AqrixBg9
   OO42vfYA1zefz2f/K2V8ySouuRR4SrBAJ8Q3zjEWPXOvyO+dKnJ+KZFUJ
   G2Ow8Hmjbhqn93cxjZViqTSI0atUbbq7xPT/jSrKx8YTMgsDVLTuPS8gz
   TQKbIjYBkO8P6is1ip+nBqeLzSSrFdpFlz9TwQykKJiP7tlGWi8zWE0de
   +1mf4IVlTnj9jE8O1DyVepNGeA+/ZVaGFyRmeVVI5bYd5TJLZZTqEHVdG
   62Wi15MGgyH5aCaz0G3Ie5xfKpl8nrehCBLIQLQYZfN3Qve+Luw8M765U
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="357231344"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="357231344"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 07:44:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="856121366"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="856121366"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 13 Jun 2023 07:44:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 07:44:10 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 07:44:09 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 07:44:09 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 07:44:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTA7ebO5672/9caF7JvTJPYNhUH9NwMXS8mZt7IcWMfuZYP3etAz32sXmdBjPFrgbbGIc0mC3I7BKKsI42cwrFi1NAIBCqsMUmIAhOyVyx/pBBxPT/kDiuv5C+ewCurFrObHgpFo8ZY2vMCRlBOBbeJJvmSRdCsFczgXLRIbeb+SkF9MOj6r8X1YOExUzqXIIdw2SpaDCMijO8tdNmNEvcbr9QDJ0nb8IOEzbAhxDGf/GXTsh+S6vd8iXg+iUAja03tc/L0ORQCotMNwF1iJpmwMsppnT3wb6dBwypwqobkVBI4zzPgiodErrJou67hNEUs7SgtEdJMYTRsaimGHWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EAcH2g7hNdMDS60DdzPX7xb6tAkWLhTJjWbOgXDwhsw=;
 b=lZ6Ev88QpQP4k/ypC9REQ+tCsnnlbZ6ZdjGHz4TFcUYghEGgz/m37IuO8K3EDi+CJ6itCuUJbtqfIEGf56ovMsNROdNaYXm+pXwENu05uvnceso2DmgS/nhcNHwNLb6h5B3SGPy3Vy2kD4SDVuDKAJ9Ty1NJMBUWE8a7LrlQJD9zC8v3/8NjKUqGRSZu1y3BaSyB8qC4yTaf0ocWZ6Hb0tVvepolF4/mRv9VKZs1RDK1L8a2XBSjX+jZm/5f+ehYnpGBcIYms0hEHdmcRdfdZf51LRTNqNK/kIhNN6PWdXQAqF4OSEMGGPeuUOoIH+XZA+8thcjAS9mxLJo9RdG5MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7652.namprd11.prod.outlook.com (2603:10b6:8:14e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Tue, 13 Jun
 2023 14:44:06 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6455.045; Tue, 13 Jun 2023
 14:44:06 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v12 07/24] vfio: Block device access via device fd until
 device is opened
Thread-Topic: [PATCH v12 07/24] vfio: Block device access via device fd until
 device is opened
Thread-Index: AQHZlUwrPp8CB3o9OkmAJqWvehBIwq+Hxa4AgACAbJCAAJKtgIAABJBwgAACkQCAAAAwUA==
Date:   Tue, 13 Jun 2023 14:44:06 +0000
Message-ID: <DS0PR11MB75298B3DB359C7B7D4F3364CC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-8-yi.l.liu@intel.com>
        <20230612155210.5fd3579f.alex.williamson@redhat.com>
        <DS0PR11MB75293327BDE6D268996FFFCCC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613081647.740f5217.alex.williamson@redhat.com>
        <DS0PR11MB7529B3DB059798EA474ACB3DC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230613084218.169f1c4c.alex.williamson@redhat.com>
In-Reply-To: <20230613084218.169f1c4c.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS0PR11MB7652:EE_
x-ms-office365-filtering-correlation-id: c01e14bc-938d-4f30-99ab-08db6c1ca381
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Uw0GcaS1UzkL84GAx2zNTUHdzkufHRWn7BNPUfHelutKsmYkbNqbFDb8FsaRhV/Aa/EwvQ7S8rCxAYPvZOX1yoPDKvojixZGWetbYGSA7reFeN75vSmwuMxTgPWuZS6VutesQIW52ZqEfQ/j7XStK9/cJUUwRmPlkwzd92ZVyS19L/fF2SGOxSlaUOck2xUqL+640QGx3cdGNuDOQ/k1gKSy+pbmbFGiS+WKKICnpfGGbVX9RTXskM26JrIJE5IroAGQJWgeNLRoR4mOkDpf1IWeMufcWqa34NYgLfXk8pGuq0ocMw11G+3a31D2N8JUv8INJP316h5HpBwnnicQmFj8knSpUji6FCgrUTUelpiLgthyywhRu3aLKAxPbcD5C1S8oLpYmSf10+0qT8ezmD421AptOoom9HyTyiDsJd1HHhH15s4DE3YQo4nw5rpj7QrNlK3lX3Ft6A1+PHBc2rzhNnox47J6sSmKa7ZSZuQ0Lzym4o9zxaCRj2YTV3AXv0SCeW04ibH8ui2IywXk9v0jSgha+m0BAAFSHeTTv5bGe8b3UE98gNVkYCRpFXvqWex3vYpjTLiYxDbBVgk+dENwKDcSdMOXc6eXU4S9m6g3pCzGTL+OYUpNP3DPWbiT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(376002)(366004)(396003)(451199021)(55016003)(54906003)(122000001)(82960400001)(71200400001)(478600001)(5660300002)(8936002)(41300700001)(8676002)(66476007)(4326008)(76116006)(66946007)(66556008)(66446008)(6916009)(64756008)(316002)(38100700002)(83380400001)(7696005)(186003)(9686003)(6506007)(26005)(86362001)(33656002)(7416002)(52536014)(38070700005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGlYdk93b2JsNjliTFltN3FmK3lsRlRkZDJaWjMzdG1Hd1JZNmdhK2h5WDZL?=
 =?utf-8?B?cDVFYStOUHAvd0RlbEJUVXcyTGhqdWdGaE1MV1hBazVVcEhoNDVpRWR3aHpX?=
 =?utf-8?B?ZEJIT1dVeERkRFMzNm1uR1EwUnJSYndVUGxEK1RlOUNtZVY3aTY4YWtXNWJE?=
 =?utf-8?B?UVZmcU9ONVovYlBqQTVHa3NYNU1kQkVjSVU5SnF3UW02MTF2UlJ0VmwwVjFK?=
 =?utf-8?B?c2d3SlFIQVhtZmJETXJHbVRTSlV6NGJWNEl6dC9Xaks3ZGdHT1FlY0RHM2pR?=
 =?utf-8?B?eGg5cjhiNUcwbU8xM2FaSndIa3Ayazhab1FOcStrVHNxbzdYb3p0THdTZHl5?=
 =?utf-8?B?K0h4OWhEZ0dqMk5VMXJNOXZJSG0wZTVSYzUyczRnTUprUFNaK056Tis1c0hB?=
 =?utf-8?B?aXdTWkVxMGk2L1JybUx6R1lTN25CQUczcmR2VFdOUVphQTM2aGZGc1BJaURJ?=
 =?utf-8?B?aU9Za056aDVMTkRYNThjSDgyQmZwOEZSTUJWRWFzVkdpMjY3b1NSYnkydzZK?=
 =?utf-8?B?R3NGRGFhN1paUUZIaUxaWDhoamhLRUdPLzRwMzJXYjAvZFU2dmd6L2NEZDNp?=
 =?utf-8?B?OHVTVGV5bkViaUtpTjMrUzZZeXVEc3U0RmtLMEZ6T3Ixb2RuQTNlT0E5OGVa?=
 =?utf-8?B?aEorcHVIQUF5dUNkcXFWbXVMUDROaEVUdDdQQ2JESW5GeVc2QUhSYU9wYjk5?=
 =?utf-8?B?WXRpRzNETFhYQUhXc3p1Y0wybldPVzBtUTViQVJTSXMwNmxaTG1hRVhqU1FC?=
 =?utf-8?B?UHJTeXdqWFh1cDBIUzFHNFl1TVVtd2UzaldiMS9ZSW90ZFpTMzh2NEtTbkdR?=
 =?utf-8?B?c3FJWUtKZGN6Sm1IM1JYZG9KNzJESjY0b1RCbmVtZnlIWjVYWjJCVklVbWdz?=
 =?utf-8?B?YnVKZ25IdzVRRWUwcXFsOGFYdVdwKzhJVXN3UU9JUmE0MWJEZ0lrYUhyODZa?=
 =?utf-8?B?M1BPMldnYWZwZUgwUGp3M0RpZ2xxRW5kb05NUmVJTGdpSnQvSDlXWEhqMnVn?=
 =?utf-8?B?cHJmMzBwQW9lTTBwM2kwaWV3a3ZFOHBCZ1NMVElsZXJEbE5oRUg2b0hLSmxy?=
 =?utf-8?B?Tm82bFJEcVVhMlJ5Zi80alBZa3pIU20zNGE0dWw4SlJ3eC8yK29OUWJPUlhU?=
 =?utf-8?B?RXpsdm4rTkU4aFlma0labExlOXN2Q3JqSjJsZ0UzdVNwVXhRemx6c3hsSTRM?=
 =?utf-8?B?eTVSSThYYTB3TXZtZkE0UUVjODhQdXh0SWpXaE1XWHVJaFZNcmtUaitseXJU?=
 =?utf-8?B?aHJ0YTRTbG5FQkFmQTBob3o1cVdqYVBmWk5yRGU0YjlyQVNRc1NxZUgwWkhM?=
 =?utf-8?B?WSt6SXlzMnNtY3JoNjlqMkQxZXh1Q2RybDV4T0U1SVNyY1JjTHNTQXk0ZERr?=
 =?utf-8?B?OVZyYTVWOEpCbU5SUFdPenFCZ2FlRGxNcVVPZWFjVkQxa3A0dTUvdkh1YWJq?=
 =?utf-8?B?KzhOZG41UnBORldIRDlUeTR4VnEvalRuTTk4M3NvMmRMaTFWdnBPcUpiaFdR?=
 =?utf-8?B?dHU2L3dSNVZhL29MTThlTjFQMGxiVU5NRUVQNXE0Uk0zVURHUE42V0VDRWxL?=
 =?utf-8?B?UHRNUEdIYi80dHZxa0dWcTZoMmNLRC9wYVgrSmc3SjJKL0E1VHRMdUJ4RU5z?=
 =?utf-8?B?ZkYzZDlXeHdad0RJajNZWXBnNjJyMEIrbE82eU5RQnJCdEVnbTB1R2IyQ0k5?=
 =?utf-8?B?dHNiblpWTWFrUEpiWHBZNHdFZy9vL3FTdzFmQUxXeTZHSnErYWd1cDgzWm1v?=
 =?utf-8?B?UVJ0ZkVTeWRoeW9WNnpXczd5cVRYWlRYckhWaTJXRC9xSlFFTnJERlR3VlZt?=
 =?utf-8?B?dU1zQnBnSE1tUFR5bUxKNWl1THN0ZGhnQnRVL09wbjNHVmpZRTZzSlFzd2V3?=
 =?utf-8?B?T3dYdllmYllTR2VVTjFvYi9DMkJ1QWRnTnFOTFdETzhKTUlrSDFXVHA1V2to?=
 =?utf-8?B?RlZLNnREYUVLRHpjMk1yTmx0eHdqRzBnQXV3TTYxSnZPaW9oYkpUaENKTHN5?=
 =?utf-8?B?QVM2bEx5d0UyVnBpT3EwYkJHRWs0M3VUMDZWZzlUWEM4UWdDaHMzVHJaSXlN?=
 =?utf-8?B?VG9TOEVUbmNYZVB0YXlwbEFXTCtTM1hoeGF0SGI2bmhxK3RvNzFKdTdFd0o5?=
 =?utf-8?Q?ZA75vCszQW78ycNVoGM+YgpkE?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c01e14bc-938d-4f30-99ab-08db6c1ca381
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 14:44:06.1099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5KAAsj1vBzrkZCi63upaVn1hYgJMsfIlIDZBGudKwN4/pJb+pO0OPwOx7ngMUDSwNGieb0DAyHXAEPpknzO0+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7652
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUdWVzZGF5LCBKdW5lIDEzLCAyMDIzIDEwOjQyIFBNDQo+IA0KPiBPbiBUdWUsIDEzIEp1
biAyMDIzIDE0OjM2OjE0ICswMDAwDQo+ICJMaXUsIFlpIEwiIDx5aS5sLmxpdUBpbnRlbC5jb20+
IHdyb3RlOg0KDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
dmZpby92ZmlvLmggYi9kcml2ZXJzL3ZmaW8vdmZpby5oDQo+ID4gPiA+ID4gPiBpbmRleCBmOWVi
NTJlYjllZDcuLmZkZjJmYzczZjg4MCAxMDA2NDQNCj4gPiA+ID4gPiA+IC0tLSBhL2RyaXZlcnMv
dmZpby92ZmlvLmgNCj4gPiA+ID4gPiA+ICsrKyBiL2RyaXZlcnMvdmZpby92ZmlvLmgNCj4gPiA+
ID4gPiA+IEBAIC0xOCw2ICsxOCw3IEBAIHN0cnVjdCB2ZmlvX2NvbnRhaW5lcjsNCj4gPiA+ID4g
PiA+DQo+ID4gPiA+ID4gPiAgc3RydWN0IHZmaW9fZGV2aWNlX2ZpbGUgew0KPiA+ID4gPiA+ID4g
IAlzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZTsNCj4gPiA+ID4gPiA+ICsJYm9vbCBhY2Nlc3Nf
Z3JhbnRlZDsNCj4gPiA+ID4gPg0KPiA+ID4gPiA+IFNob3VsZCB3ZSBtYWtlIHRoaXMgYSBtb3Jl
IHN0cm9uZ2x5IGRlZmluZWQgZGF0YSB0eXBlIGFuZCBsYXRlciBtb3ZlDQo+ID4gPiA+ID4gZGV2
aWQgKHUzMikgaGVyZSB0byBwYXJ0aWFsbHkgZmlsbCB0aGUgaG9sZSBjcmVhdGVkPw0KPiA+ID4g
Pg0KPiA+ID4gPiBCZWZvcmUgeW91ciBxdWVzdGlvbiwgbGV0IG1lIGRlc2NyaWJlIGhvdyBJIHBs
YWNlIHRoZSBmaWVsZHMNCj4gPiA+ID4gb2YgdGhpcyBzdHJ1Y3R1cmUgdG8gc2VlIGlmIGl0IGlz
IGNvbW1vbiBwcmFjdGljZS4gVGhlIGZpcnN0IHR3bw0KPiA+ID4gPiBmaWVsZHMgYXJlIHN0YXRp
Yywgc28gdGhleSBhcmUgaW4gdGhlIGJlZ2lubmluZy4gVGhlIGFjY2Vzc19ncmFudGVkDQo+ID4g
PiA+IGlzIGxvY2tsZXNzIGFuZCBvdGhlciBmaWVsZHMgYXJlIHByb3RlY3RlZCBieSBsb2Nrcy4g
U28gSSB0cmllZCB0bw0KPiA+ID4gPiBwdXQgdGhlIGxvY2sgYW5kIHRoZSBmaWVsZHMgaXQgcHJv
dGVjdHMgY2xvc2VseS4gU28gdGhpcyBpcyB3aHkgSSBwdXQNCj4gPiA+ID4gZGV2aWQgYmVoaW5k
IGlvbW11ZmQgYXMgYm90aCBhcmUgcHJvdGVjdGVkIGJ5IHRoZSBzYW1lIGxvY2suDQo+ID4gPg0K
PiA+ID4gSSB0aGluayB0aGUgcHJpbWFyeSBjb25zaWRlcmF0aW9ucyBhcmUgbG9jYWxpdHkgYW5k
IGNvbXBhY3RuZXNzLiAgSG90DQo+ID4gPiBwYXRocyBkYXRhIHNob3VsZCBiZSB3aXRoaW4gdGhl
IGZpcnN0IGNhY2hlIGxpbmUgb2YgdGhlIHN0cnVjdHVyZSwNCj4gPiA+IHJlbGF0ZWQgZGF0YSBz
aG91bGQgc2hhcmUgYSBjYWNoZSBsaW5lLCBhbmQgd2Ugc2hvdWxkIHVzZSB0aGUgc3BhY2UNCj4g
PiA+IGVmZmljaWVudGx5LiAgV2hhdCB5b3UgZGVzY3JpYmUgc2VlbXMgbGFyZ2VseSBhbiBhZXN0
aGV0aWMgY29uY2VybiwNCj4gPiA+IHdoaWNoIHdhcyBub3QgZXZpZGVudCB0byBtZSBieSB0aGUg
c2VnbWVudGF0aW9uIGFsb25lLg0KPiA+DQo+ID4gU3VyZS4NCj4gPg0KPiA+ID4NCj4gPiA+ID4g
c3RydWN0IHZmaW9fZGV2aWNlX2ZpbGUgew0KPiA+ID4gPiAgICAgICAgIHN0cnVjdCB2ZmlvX2Rl
dmljZSAqZGV2aWNlOw0KPiA+ID4gPiAgICAgICAgIHN0cnVjdCB2ZmlvX2dyb3VwICpncm91cDsN
Cj4gPiA+ID4NCj4gPiA+ID4gICAgICAgICBib29sIGFjY2Vzc19ncmFudGVkOw0KPiA+ID4gPiAg
ICAgICAgIHNwaW5sb2NrX3Qga3ZtX3JlZl9sb2NrOyAvKiBwcm90ZWN0IGt2bSBmaWVsZCAqLw0K
PiA+ID4gPiAgICAgICAgIHN0cnVjdCBrdm0gKmt2bTsNCj4gPiA+ID4gICAgICAgICBzdHJ1Y3Qg
aW9tbXVmZF9jdHggKmlvbW11ZmQ7IC8qIHByb3RlY3RlZCBieSBzdHJ1Y3QgdmZpb19kZXZpY2Vf
c2V0Ojpsb2NrICovDQo+ID4gPiA+ICAgICAgICAgdTMyIGRldmlkOyAvKiBvbmx5IHZhbGlkIHdo
ZW4gaW9tbXVmZCBpcyB2YWxpZCAqLw0KPiA+ID4gPiB9Ow0KPiA+ID4gPg0KPiA+ID4gPiA+DQo+
ID4gPiA+ID4gSSB0aGluayB0aGlzIGlzIGJlaW5nIHBsYWNlZCB0b3dhcmRzIHRoZSBmcm9udCBv
ZiB0aGUgZGF0YSBzdHJ1Y3R1cmUNCj4gPiA+ID4gPiBmb3IgY2FjaGUgbGluZSBsb2NhbGl0eSBn
aXZlbiB0aGlzIGlzIGEgaG90IHBhdGggZm9yIGZpbGUgb3BlcmF0aW9ucy4NCj4gPiA+ID4gPiBC
dXQgYm9vbCB0eXBlcyBoYXZlIGFuIGltcGxlbWVudGF0aW9uIGRlcGVuZGVudCBzaXplLCBtYWtp
bmcgdGhlbQ0KPiA+ID4gPiA+IGRpZmZpY3VsdCB0byBwYWNrLiAgQWxzbyB0aGVyZSB3aWxsIGJl
IGEgdGVuZGVuY3kgdG8gd2FudCB0byBtYWtlIHRoaXMNCj4gPiA+ID4gPiBhIGJpdCBmaWVsZCwg
d2hpY2ggaXMgcHJvYmFibHkgbm90IGNvbXBhdGlibGUgd2l0aCB0aGUgc21wIGxvY2tsZXNzDQo+
ID4gPiA+ID4gb3BlcmF0aW9ucyBiZWluZyB1c2VkIGhlcmUuICBXZSBtaWdodCBnZXQgaW4gZnJv
bnQgb2YgdGhlc2UgaXNzdWVzIGlmDQo+ID4gPiA+ID4gd2UganVzdCBkZWZpbmUgaXQgYXMgYSB1
OCBub3cuICBUaGFua3MsDQo+ID4gPiA+DQo+ID4gPiA+IE5vdCBxdWl0ZSBnZXQgd2h5IGJpdCBm
aWVsZCBpcyBnb2luZyB0byBiZSBpbmNvbXBhdGlibGUgd2l0aCBzbXANCj4gPiA+ID4gbG9ja2xl
c3Mgb3BlcmF0aW9ucy4gQ291bGQgeW91IGVsYWJvcmF0ZSBhIGJpdD8gQW5kIHNob3VsZCBJIGRl
ZmluZQ0KPiA+ID4gPiB0aGUgYWNjZXNzX2dyYW50ZWQgYXMgdTggb3IgInU4OjEiPw0KPiA+ID4N
Cj4gPiA+IFBlcmhhcHMgRlVEIG9uIG15IHBhcnQsIGJ1dCBsb2FkLWFjcXVpcmUgdHlwZSBvcGVy
YXRpb25zIGhhdmUgc3BlY2lmaWMNCj4gPiA+IHNlbWFudGljcyBhbmQgaXQncyBub3QgY2xlYXIg
dG8gbWUgdGhhdCB0aGV5IGludGVyZXN0IHdpdGggY29tcGlsZXINCj4gPiA+IGdlbmVyYXRlZCBi
aXQgb3BlcmF0aW9ucy4gIFRoYW5rcywNCj4gPg0KPiA+IEkgc2VlLiBIb3cgYWJvdXQgYmVsb3c/
DQo+ID4NCj4gPiBzdHJ1Y3QgdmZpb19kZXZpY2VfZmlsZSB7DQo+ID4gICAgICAgICBzdHJ1Y3Qg
dmZpb19kZXZpY2UgKmRldmljZTsNCj4gPiAgICAgICAgIHN0cnVjdCB2ZmlvX2dyb3VwICpncm91
cDsNCj4gPiAgICAgICAgIHU4IGFjY2Vzc19ncmFudGVkOw0KPiA+ICAgICAgICAgdTMyIGRldmlk
OyAvKiBvbmx5IHZhbGlkIHdoZW4gaW9tbXVmZCBpcyB2YWxpZCAqLw0KPiA+ICAgICAgICAgc3Bp
bmxvY2tfdCBrdm1fcmVmX2xvY2s7IC8qIHByb3RlY3Qga3ZtIGZpZWxkICovDQo+ID4gICAgICAg
ICBzdHJ1Y3Qga3ZtICprdm07DQo+ID4gICAgICAgICBzdHJ1Y3QgaW9tbXVmZF9jdHggKmlvbW11
ZmQ7IC8qIHByb3RlY3RlZCBieSBzdHJ1Y3QgdmZpb19kZXZpY2Vfc2V0Ojpsb2NrICovDQo+ID4g
fTsNCj4gDQo+IFllcCwgdGhhdCdzIGVzc2VudGlhbGx5IHdoYXQgSSB3YXMgc3VnZ2VzdGluZy4g
IFRoYW5rcywNCg0KR290IGl0LiDwn5iKDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg==
