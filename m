Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2339869F5B3
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 14:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbjBVNfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 08:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjBVNfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 08:35:12 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571403ABE;
        Wed, 22 Feb 2023 05:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677072911; x=1708608911;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Yhn/LMyuR5X+cSN2+Z5IlLMiY6DFm8KOvLQyIJ2pnZk=;
  b=MGiUUOBHbgxCCnEi0yWqp3zeRAsironTqR4V998IWI31al3+NsOS3slf
   F8e5X9zCL29yW9h8z0cgqvgjqQUUvOSCm58P/6h7Fjz82FpTRK96SD+gj
   nNnUfOl4dCD1GkVKO/QqqRnJV1/Q7jHm/Jln99fPID+ZVxBfHBjhtfuzs
   AoLID8opZiYhG+pr7W9aPWFU6hET7T4x91aNqQWiwLL5WiumFiBwb0Lqj
   KBHqDiEmduT7fLs3LQvM22SAiJZkGqTFI5JscmuYRPiFFECgcX20H3TsR
   dIxj5EHlonuCpG+CpC2ifa5pavTZ4oKXPhjJ/psO4ozyGV8tfyC83FcJM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="316648270"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="316648270"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 05:35:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="674099454"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="674099454"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 22 Feb 2023 05:35:09 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 22 Feb 2023 05:35:09 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 22 Feb 2023 05:35:08 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 22 Feb 2023 05:35:08 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 22 Feb 2023 05:35:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7Xe9vfCwwd67EFt4nEKDyH+Kk15qNJP74kCIxeHb9OWViH0ffGSA0cW4e1zUXPxjcSa3ahk27qIanCvlqjEooV/WzGUkZEJhhy+BC6bzmnmxaE+4sFNceAVhYvb2duhtRquzdHbrYtGEdERDDm0BHdpiQVv08pdEzHi9ugTeD3eLW/bfwrDlOM5tZhUahwC+GiO49mM3m+/lwnXGexMFGOGHIIAMcpO/JoNT3vocFOgmXr3vSfZrQ1TaDF4eCu4pPS2Rluq7Yh0VVq8qiSl9aTWRJfLw9dTRDUbH+OPwZl9er2ZNaEnG/4pyOOE6F0AkHdeQDNcRG8lTMIsj/GfVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yhn/LMyuR5X+cSN2+Z5IlLMiY6DFm8KOvLQyIJ2pnZk=;
 b=acD9QZtl0F0Hjw+JOdtfOaY1UZBFY1hAKC18/zK++0n+o3XI3jyH8yIMxA5Fe+9XIQ1GS2mR3SeQ9QTRa+MELeq9kFc0yJvy3qLzhVNrm9j2nT8Sw1J+hy2jh5XqWuwx/8iptQJyn//LhEvbmhYqQv2He998APumVO6XybTayioZQcyxcd5pjl44Yk7wIf6kxBj2xi1g1ow5ZbcQbRyLsZIm2PSYZ8i6VM3qVK/lw21ZgpCBzj2mbhxOaD/l9nFnu7nmE/gjDgsvYBqJu2HwDaK4mn3akwDI+jFKyaeLgbuhpUtj01er5wpn4eZ0YJ7fY+vVAoSpNrKGsmIIS7AZnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ0PR11MB4815.namprd11.prod.outlook.com (2603:10b6:a03:2dd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Wed, 22 Feb
 2023 13:35:06 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%6]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 13:35:06 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Thread-Topic: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Thread-Index: AQHZRadeNlgrDl2wokCstlukf6hiCq7akpcAgABgJDA=
Date:   Wed, 22 Feb 2023 13:35:06 +0000
Message-ID: <DS0PR11MB7529B33D098225CFAAA7D63FC3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-10-yi.l.liu@intel.com>
 <BL1PR11MB5271D122329B6908BDE1F8328CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
In-Reply-To: <BL1PR11MB5271D122329B6908BDE1F8328CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SJ0PR11MB4815:EE_
x-ms-office365-filtering-correlation-id: 9279ab16-cda2-4229-46bd-08db14d99c09
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VQhA9dwHGtR6FYodOjDFa/I22Ucv77DD/KJUM+hy1k33RogfnwY1zcj71WNcpJsQRqq9phsJmVYNB+G++WQrI1ncEypoUiE+0zbMSExR0T4qYnv0Cei14oJBDdXlhAIg9a4IgjE+eN14HehmXKRS8MXUJTV4jPNbiPfcHY6hj6uHjPx2bSbzQ7WPVWBzL7KVNHyU9gwe45QnnDxKSexHpN4Wn0zYMc9XC6/NfCoQ62KwVQg49Ca94ag4gbOhXQFRegw/p5oJbisalca9krq6SqrPQDm8m/S0xhJeY5D+Kgtt6hkpTi9UPS4YqJKToy8rcdY5ULBo6oBjkS8FbGdtehZ9OEwEeznf/1OZYsOXvhVVUy0ZjHFvQtmiFN52kc1tQvQLpgPDvpXzkulPJUhrdZdprxWQoaggHhgYs828rF6uCyiRyTzjK2S/SRePgihXQfkbbnw6GGpKpELtAAH1nAx9EpCzuL6IkvSxQZ/Yn1qRtIU4IgnVAH7MmJA3hYWkgp++zjKxp5yMTL1h2lJpQ4WAvdbgn07XeQpKEc3L5phW10IfSNI3Vjdvpy9imZlvZmVCzhQHAMpYoG6XnOSaY0+btfW5MJ/fvrPYV9x6SZ+zKaU6QgyDmbJM7nj8RTnkzfjuIF83uw3OcRVypb9LCD1RnnFmUTy2lYMlv56X+LEBFdVN21u8cJHgCeDn+8bXQamfByBdN2k3yAYA5cvuoA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(136003)(39860400002)(346002)(376002)(451199018)(186003)(6506007)(9686003)(26005)(71200400001)(7696005)(54906003)(316002)(83380400001)(478600001)(110136005)(64756008)(66946007)(76116006)(122000001)(66556008)(66476007)(41300700001)(66446008)(8676002)(4326008)(38100700002)(52536014)(5660300002)(7416002)(8936002)(2906002)(38070700005)(82960400001)(55016003)(33656002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?alRXSFhZSHo4R1BzQ2JZV2h4SWdsK2dHb2VzYzVzbWROVUpoMHpML1hIMEMr?=
 =?utf-8?B?YkFpWi9NcnZJcU9BU21NbmJMU2VqNi9uZUVSL0xxWTg2ZU5xZmp3Zk92VEI4?=
 =?utf-8?B?VmJiT3d2ckdJV21odEJaZGQrS0R3TmttVzVmSGxwb1A2VE1QMGt3SUl1TkRI?=
 =?utf-8?B?TlMrbTR4aWJxWjBIOWxnYnZ4ZnlPUEFjZHIyMVBjZDlPYVZ5MXZBMjl2aExT?=
 =?utf-8?B?eXNhYndXWHp4N1d3WHBXcXB0V2V0dWNQNmRrTFNFL0VlTnRYU3JUUytWWkRD?=
 =?utf-8?B?eHltVmhRL21PU2NpQ2pWTisxNW1zK2JjNmt5czNxT2tVeDV0Vi9jQVhqemRU?=
 =?utf-8?B?eVhDT1Y2a1ZXaEVQb2ZBemloQ1JJM2s4SWU4cGdUU1dlenBWVXUzQlhCUHBQ?=
 =?utf-8?B?eG9wd0VmRjdXczhZdWZLSXVhK1VkTkNRWWFVVnEvNE1NMWl2b3NXNWRUdzlS?=
 =?utf-8?B?NDhEbXR0VmtkUXNlbXBGMjRxVVptWnhlLzZXdnZtWWVqb09jRStIcUd6NXlk?=
 =?utf-8?B?M1hyWStNeEk3SC9OM0JvMG93bUtwQ3hIZTRqL0thM3FkWGs5KzdFOHlrUU5W?=
 =?utf-8?B?SHZBN1BuZlorcndwZW1ZZGF1L3EwYzRyZnprRnpra3o3U21KM252Ry9WNDJB?=
 =?utf-8?B?Zlc5Y3JJNWw5Tm96SzZndDRLaVo4WGFJWkNQOUJXM2tYMGVsL2drb0FneXQx?=
 =?utf-8?B?VkRNMmk1TEl2RTJEVE5hOTZRVXNlVmlyODVBWkN3Y2FlcHJicXliRlRoNENl?=
 =?utf-8?B?ekkwK0VSbkdDK2E5cmZxTkVaQlRwblB0TGRrWjg1aGhMNlhsYk5nS052engw?=
 =?utf-8?B?OTlGYW5DMDFETmRIb3M5MkNibUxqM1JMTTB4MFgwWUhjRE9UVk5Oa0R1NFlP?=
 =?utf-8?B?N09TeTU3YU5zaVlqZUJhMVVqQVlyVlI4UFM1cXBEU2h5cC9QWW5Tek1PNzVU?=
 =?utf-8?B?Vk0zdnBFNmdwdGp3NGV5b3Vjc0RvZXA4MjJnRGQydHhkWFgxWWNNdkRlWWVj?=
 =?utf-8?B?OFdlT1ZDYS82M3NzTTNHbTB6U2pkWVZDeGdhTmdYN0RRbVc1L3dvWnZmaGhQ?=
 =?utf-8?B?eG1HVmVJQktERHBubk52QVc2Rmt6SU9KQStoclhSZzZJcXoyYlhqR2loTzJ3?=
 =?utf-8?B?RFlkQSs1TFowKzF4bDBCSytnTVc2ZzVrWXhPaWRGb0JhU1MyUlVwSnlTQ2J4?=
 =?utf-8?B?NXhZUFVzNUJUVGRSM0tVVWVjaEZwQjRORWIzU2lrSjFpNEtoUjB6cHRoMUFs?=
 =?utf-8?B?TGJVRE1DMnpveHVTNDBBb3dicGJrM1J2bkdRTlRiWUtta0ZNYkE4bTYzT3Vu?=
 =?utf-8?B?UDMwaUkyY1ZTL1Q2VG4xUHhsY25uT1N1TFN4WHlUdGdrQ2QwTmI4ZEVwWGI1?=
 =?utf-8?B?NUk3VWp0MXNBYjBkMlNKQS92TmdqSlhzMVpVL2pSQ2JwbkRaZXhYcFZjWjRE?=
 =?utf-8?B?T1p2VGY1Y1MvNGszbHp1SEpza1RkRnZwNDV0TlVEQ3AxQnFnWjRHVGJZRUtV?=
 =?utf-8?B?TGtZTCsxdkYvUThiZGQrVmVkVmdZQXF1L1E0WFZ5UWpQb2FmWHljbTY1bFRr?=
 =?utf-8?B?aTlRK0lhRHF4R3JlQWtjZlhMeWF2UmVTUXFnUUY4VkxiM0hSdm4xYk8wdXlH?=
 =?utf-8?B?NkRnVmVtSGNnZW5KN1NqWTh5UVdzSG8ybHJ3YUN3SUJxM0VVWlNSOFJoWWo2?=
 =?utf-8?B?MG11a2NYdUp5Ny91VjFBY1F6akdFOGJVY0dtS2xuR1VzQi9JOXNjZGNzK216?=
 =?utf-8?B?b3VPSFZyUG5JN1hqTWlzeUtCbXl4MXo5T21qRDk1amo0K0MzcTYrNDg0VW5q?=
 =?utf-8?B?QTNEcTVGeVBLUEJFMmxlZXhtWHljVEJ0WXlUMmY0SnFBMUcxWGFYK2phSDMr?=
 =?utf-8?B?N2ltZmhXM3FKaG41SlFUaHZXSDhUUkZWUWVvMGd5L2I2QmgrMzdDajFWQkth?=
 =?utf-8?B?endJRmxSZW9FK3VodmNpQkZjZTdUVjJNNmI5eVpTMW9ZNjdibWJ0TStWZGR4?=
 =?utf-8?B?aFhleHphOFRMSWh0bWRjUkZFWE03cVBLeFVFazJqZkVIY2tTOGRjVmNjUGlP?=
 =?utf-8?B?NGV2L1NDL2JTVC9nT29VWUFIYjNFbzR4TktFYWk4UEdtc2ozeFNZSm1OeTJl?=
 =?utf-8?Q?39HFgC7UoxP6pFZqicl1GbF4k?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9279ab16-cda2-4229-46bd-08db14d99c09
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 13:35:06.1057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BPv98HbFxz5Q5AFuG/7mIcXUV9Gihh5MdlKgVM0enWMCWS4uKyiCg6tEf9QVCEb2Pr8ykpEh00snNpLb5GSesA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4815
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo+IFNlbnQ6IFdlZG5l
c2RheSwgRmVicnVhcnkgMjIsIDIwMjMgMzoyNiBQTQ0KPiANCj4gPiBGcm9tOiBMaXUsIFlpIEwg
PHlpLmwubGl1QGludGVsLmNvbT4NCj4gPiBTZW50OiBUdWVzZGF5LCBGZWJydWFyeSAyMSwgMjAy
MyAxMTo0OCBBTQ0KPiA+DQo+ID4gIAkvKg0KPiA+ICAJICogV2UgY2FuJ3QgbGV0IHVzZXJzcGFj
ZSBnaXZlIHVzIGFuIGFyYml0cmFyaWx5IGxhcmdlIGJ1ZmZlciB0byBjb3B5LA0KPiA+IC0JICog
c28gdmVyaWZ5IGhvdyBtYW55IHdlIHRoaW5rIHRoZXJlIGNvdWxkIGJlLiAgTm90ZSBncm91cHMg
Y2FuDQo+IGhhdmUNCj4gPiAtCSAqIG11bHRpcGxlIGRldmljZXMgc28gb25lIGdyb3VwIHBlciBk
ZXZpY2UgaXMgdGhlIG1heC4NCj4gPiArCSAqIHNvIHZlcmlmeSBob3cgbWFueSB3ZSB0aGluayB0
aGVyZSBjb3VsZCBiZS4gIE5vdGUgdXNlciBtYXkNCj4gPiBwcm92aWRlDQo+ID4gKwkgKiBhIHNl
dCBvZiBncm91cHMsIGdyb3VwIGNhbiBoYXZlIG11bHRpcGxlIGRldmljZXMgc28gb25lIGdyb3Vw
IHBlcg0KPiA+ICsJICogZGV2aWNlIGlzIHRoZSBtYXguDQo+IA0KPiB3ZWxsIHRoaXMgY2hhbmdl
IGRvZXNuJ3QgaW5jbHVkZSBjZGV2DQoNCkZvciBjZGV2LCBpdCBzaG91bGQgYmUgdGhlIG51bWJl
ciBvZiBkZXZpY2VzLiDwn5iKDQoNCj4gDQo+ID4gQEAgLTEzMjAsNyArMTMyMSw3IEBAIHN0YXRp
YyBpbnQgdmZpb19wY2lfaW9jdGxfcGNpX2hvdF9yZXNldChzdHJ1Y3QNCj4gPiB2ZmlvX3BjaV9j
b3JlX2RldmljZSAqdmRldiwNCj4gPiAgCQl9DQo+ID4NCj4gPiAgCQkvKiBFbnN1cmUgdGhlIEZE
IGlzIGEgdmZpbyBGRC4qLw0KPiA+IC0JCWlmICghdmZpb19maWxlX2lzX3ZhbGlkKGZpbGUpKSB7
DQo+ID4gKwkJaWYgKCF2ZmlvX2ZpbGVfaXNfZGV2aWNlX29wZW5lZChmaWxlKSkgew0KPiA+ICAJ
CQlmcHV0KGZpbGUpOw0KPiA+ICAJCQlyZXQgPSAtRUlOVkFMOw0KPiA+ICAJCQlicmVhazsNCj4g
DQo+IHRoYXQgZnVuY3Rpb24gaXMgbm90IGp1c3QgZm9yIGNoZWNraW5nIGRldmljZS4NCj4gDQo+
IFByb2JhYmx5IHJlbmFtZSBpdCB0byB2ZmlvX2ZpbGVfaXNfcmVzZXRfdmFsaWQoKS4NCg0KSG93
IGFib3V0IHZmaW9fZmlsZV9pc19yZXNldHRhYmxlKCk/DQoNCj4gYnR3IHRoaXMgcGF0Y2ggaXMg
aW5zdWZmaWNpZW50IHRvIGhhbmRsZSBkZXZpY2UgZmQuIFRoZSBjdXJyZW50IGxvZ2ljDQo+IHJl
cXVpcmVzIGV2ZXJ5IGRldmljZSBpbiB0aGUgZGV2X3NldCBjb3ZlcmVkIGJ5IHByb3ZpZGVkIGZk
J3M6DQo+IA0KPiBzdGF0aWMgYm9vbCB2ZmlvX2Rldl9pbl9ncm91cHMoc3RydWN0IHZmaW9fcGNp
X2NvcmVfZGV2aWNlICp2ZGV2LA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3Ry
dWN0IHZmaW9fcGNpX2dyb3VwX2luZm8gKmdyb3VwcykNCj4gew0KPiAgCXVuc2lnbmVkIGludCBp
Ow0KPiANCj4gCWZvciAoaSA9IDA7IGkgPCBncm91cHMtPmNvdW50OyBpKyspDQo+IAkJaWYgKHZm
aW9fZmlsZV9oYXNfZGV2KGdyb3Vwcy0+ZmlsZXNbaV0sICZ2ZGV2LT52ZGV2KSkNCj4gCQkJcmV0
dXJuIHRydWU7DQo+IAlyZXR1cm4gZmFsc2U7DQo+IH0NCj4gDQo+IFByZXN1bWFibHkgd2hlbiBj
ZGV2IGZkIGlzIHByb3ZpZGVkIGFib3ZlIHNob3VsZCBjb21wYXJlIGlvbW11DQo+IGdyb3VwIG9m
IHRoZSBmZCBhbmQgdGhhdCBvZiB0aGUgdmRldi4gT3RoZXJ3aXNlIGl0IGV4cGVjdHMgdGhlIHVz
ZXINCj4gdG8gaGF2ZSBmdWxsIGFjY2VzcyB0byBldmVyeSBkZXZpY2UgaW4gdGhlIHNldCB3aGlj
aCBpcyBpbXByYWN0aWNhbC4NCg0KWWVzLiBUaGlzIGNhbiBiZSBkb25lIGJ5IGNoZWNraW5nIHRo
ZSBkZXZpY2UtPnZmaW9fZ3JvdXAtPmlvbW11X2dyb3VwLg0KQnV0IGdyb3VwIGNvZGUgbWF5IGJl
IGNvbXBpbGVkIG91dCBldmVudHVhbGx5LiBJZiBDT05GSUdfVkZJT19HUk9VUD09bi4NCm5lZWRz
IHRvIHVzZSBpb21tdV9ncm91cF9nZXQoKSB0byBnZXQgaW9tbXVfZ3JvdXAgYW5kIGNvbXBhcmUu
DQoNCmJ0dy4gSSBoYXZlIGEgZG91YnQgYWJvdXQgaWYgaXQgaXMgcG9zc2libGUgdGhhdCB0aGUg
aW9tbXVfZ3JvdXANCmNhbiBkaXNhcHBlYXIgZHVyaW5nIHRoZSByZXNldC4gSWYgeWVzLCBtYXli
ZSBiZXR0ZXIgc3RvcmUgaW9tbXVfZ3JvdXANCmluIHZmaW9fZGV2aWNlIGluIHRoZSB2ZmlvX3Jl
Z2lzdGVyX2dyb3VwX2RldigpIHBhdGggaWYgQ09ORklHX1ZGSU9fR1JPVVANCmlzIG5vdCBlbmFi
bGVkLg0KDQpSZWdhcmRzLA0KWWkgTGl1IA0K
