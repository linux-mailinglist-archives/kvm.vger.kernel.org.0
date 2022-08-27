Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1DB5A36E4
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 12:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiH0KIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Aug 2022 06:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbiH0KIK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Aug 2022 06:08:10 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5652845049;
        Sat, 27 Aug 2022 03:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661594889; x=1693130889;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6UwZ1iJPUC2e0G4p0M5fw1zbhoKhd8HPYmeRWLkHtng=;
  b=FzQfC1YjO4RuhC7whkQ+lwJ6ZaDrfHrl8Iy+5VZLy8+/slcLiEosq8I+
   ux1yE976XFvD/mRhoSoeLEwULHgUtTUp0CqNieyp1MP33CNBTXklkfOWh
   ROy5NoBzolgRxDbqv4FuZB3EiXSyuTmm9EmulGL0zkERqT2+tsHen25xV
   Dz6Hf+98e1lUw21gcwbKDeu+CP3SF7u1z1nDhzAG73YXYcVUW7XLtad3u
   9Yj20BAQGPke9lmP7Po9zopwIadoKzhmMb9xJeGS2VGZz8FqZl/BfbFbD
   QQoa7UTyNW+Qndh/hmMBhp2Vl4yxrpQ4tc77spOIzMblRNOwSYROhsuWB
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10451"; a="275054964"
X-IronPort-AV: E=Sophos;i="5.93,267,1654585200"; 
   d="scan'208";a="275054964"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2022 03:08:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,267,1654585200"; 
   d="scan'208";a="643925985"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 27 Aug 2022 03:08:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 27 Aug 2022 03:08:05 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 27 Aug 2022 03:08:04 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sat, 27 Aug 2022 03:08:04 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sat, 27 Aug 2022 03:08:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DgNLGyKbuxxVBohNQWxceHuywt+FjxX6xRNdxq1G5QMXyFBpI5BoRcg2pLRHQnGDAMpQvmzUZaaq7p6zIL2EFTC2dGM5QpkBETNQdiOB/vt8P2JxwEfcJyGg5RC14pVZjT5Tm2VctAngjOEZg9Tu265RpdkT06gH4+YTsdOvULghwzPquyKb5w9PXlqqbLrvgY8AhmeQnetX2rZRViL6Poo5Lm0RumkE5UxWyX6//nNuzlNaA/jyU1fWIa6PWjERSor/J0RYGR54fCKVvEga9kNu2LpAEYv7LpTdrZqBZkvpYWpPyJAa9Zqtd05xmNgLwlpZmsybjqsMdb7pjiPLKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6UwZ1iJPUC2e0G4p0M5fw1zbhoKhd8HPYmeRWLkHtng=;
 b=GAqZn9zl3FxTx2eNkcWiRRS7qqdKmfrC9urLorlAoD2lCa3xUsWdihWus37ROlwE3nqdj8rXvNZQKe6an4wuyMQxkLu9PG34drin/C7FiIZWbMVTT5cRxiB6oLyEutIG+GsaI4XLa4qbzDE+5exaJ6FmPUsUE9KPNgztdTkUwG9lCJIzXUxWvq7hlytSNYENhuRHQIIn3mR+26rS9GD9otw3U/u+lKewQPZoTlYAlerFtXXFv01R1zG6PlYMrujJyzVUswY3AqL4ZnNTJ66WcwXkEJK8addIWj87neLuxkrXe9hKzidhuI1djou6KKyvAp5MlQ6ckDG0BnJ9i4ozdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL0PR11MB3121.namprd11.prod.outlook.com (2603:10b6:208:7e::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Sat, 27 Aug
 2022 10:08:02 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6%4]) with mapi id 15.20.5566.019; Sat, 27 Aug 2022
 10:08:02 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Eric Farman <farman@linux.ibm.com>, "hch@lst.de" <hch@lst.de>
CC:     "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "vneethv@linux.ibm.com" <vneethv@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [RFC PATCH] vfio/ccw: Move mdev stuff out of struct subchannel
Thread-Topic: [RFC PATCH] vfio/ccw: Move mdev stuff out of struct subchannel
Thread-Index: AQHYoQb/SoILMwvFIUORf/veGNb9ba20VlbAgABzQQCADeyPsA==
Date:   Sat, 27 Aug 2022 10:08:02 +0000
Message-ID: <BN9PR11MB5276AAB235D64F61EFB19BB48C749@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220720050629.GA6076@lst.de>
         <20220726153725.2573294-1-farman@linux.ibm.com>
         <BN9PR11MB5276B1A7E2901A2A553D13938C6D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <0ee29bd6583f17f0ee4ec0769fa50e8ea6703623.camel@linux.ibm.com>
In-Reply-To: <0ee29bd6583f17f0ee4ec0769fa50e8ea6703623.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae691e69-3cf2-430c-7284-08da881406f2
x-ms-traffictypediagnostic: BL0PR11MB3121:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uquGe+D6bVQeVmQ+Wa0tF1fgLFhNzBjJMnFp3LHexsIKX5xddoHZlXf/h+A1/VIqXdyCCfO4k2HtzK5dIH0HU2tS5GkHT8CLzy3EEBjPOCO/Y0ao8thMWmDX7g+rG/mWo/eyweIQJTW/IYmxsgpVskaLM4PMVusXu3y5UsjroD6jndAsilFYkJ4U1CYe3pk5JfQAaDkpx0rCPkA4IhygTNnG34ZKG6owIM5F+yI8gI340CpVCuXxLVsrV9Bz7oXFDHfkqy7Cl6SuP/QA3tHNa5UuuMslgEr8WTEwu0/W82WTnHPadGMWh12tvKUvO1XIqBHyjgw0FVW35MhaRWRad+zFx1JFGj7r+D/cmh1Yl4lfHwK2z0jrUXNLlxXp0PUlImVi7/PMndkaXm0jU3ivA8kvBRKFMN74WfHlwnaJEDGGP72EuKgc5iLz5QCdd4sZHPGt6FZtD2puCiUVa6XZeOo+GLGoxPSAon/xnRGiEfNFIDwgcRiO4VatSntfv/LiIlcuVe+UDoDJ73nrdnWPU4oLR0AtxfRtFAoFgThnDf4Vz9vFfAdI024H+VFqQhcOJPEqHh1GZEgJpiGSQYv4evIuIN3AySEZ8kbFb2Jys08EiY3GtCFzy03t1o/JvM7TjZogh9Xa/8bwex54ocvx2tNgr4yypP00bi0eiMDO9qxd4GbPj4wJpMS4cJcsAB+r0ZKcGJkkICEwE7CVCCCp57nXaRsN1zki6KCUF6dODLkE4tiRaNSRiF6c8JkLXNPhbjYprr/5nBq0LUz5UR4bVjFVQaOnBL1yn6uWh/dFiDc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(136003)(376002)(366004)(396003)(83380400001)(186003)(966005)(54906003)(110136005)(8936002)(316002)(2906002)(7416002)(5660300002)(52536014)(33656002)(26005)(55016003)(86362001)(64756008)(82960400001)(66476007)(66556008)(66946007)(76116006)(66446008)(8676002)(4326008)(122000001)(38070700005)(71200400001)(478600001)(7696005)(6506007)(9686003)(41300700001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MmplcllsT2EyeFV1Qld5UEhjRHhYS2RWemtXSFBHM1ZISjdIQTRZK0JqM21P?=
 =?utf-8?B?dzdGMjBtTVB4TzJzSEdsVUhsWDBkTkRURmExTS9oUUJLZ2VwMkFVNVBIOHlH?=
 =?utf-8?B?WTlRdHg2cDRiUnRJYlFSNXVCQUpkTnBDK0UxbzNyTkFKSkJKaWQ2VEpQSmpE?=
 =?utf-8?B?dUVBVVVBVE85V29tOFZnSDVaOUNVb1NPbTEvMU1mcG9CdlRsMVQ3ampwNDlL?=
 =?utf-8?B?ZXRaUFhLdEF1ZTllVm5nQkEwYVFYQit2dWh5ampKdmFXTTY2Z1gyWTMrMEV5?=
 =?utf-8?B?b0dFRCtDK1A0Y2NpSEZ4UnJyL21kUDkrQ0hpNGUxc1dSZlI0ZEZJZWIyZGo3?=
 =?utf-8?B?eGoxZ1d6VjBPcWNySlRscHA2ay9hd2M2c0VTL2dwMHlQVzdSTkVxalFFQ1Vw?=
 =?utf-8?B?ZDdHZnBrTDVTdjZLSmduT3o1NGFZL1dPQW1Tb1o4U3R0UzVZakhpUE1vMjVJ?=
 =?utf-8?B?bTlZOGVweE5WRzJVRlc3d0F0cmFqR2FUb2FPSUY1VmdKdTZ6T3NtWXluSVhO?=
 =?utf-8?B?UEhIK0U2OTRzbmY3dWRmbDJCdmN0eGtBZ084bUEzYkpNUitXc2pRQkhvdEQv?=
 =?utf-8?B?S21vTlVkck5FMFF6TGxqcGJhQ3UwM2ROYmN3SndnVHdrM3VlZ3ZKRUErelYx?=
 =?utf-8?B?RWRmUTdSdnhDcG9ML0k3THowZ040T1BDQ1owMkxyTHZOUkdsWGJMd3lQbzN0?=
 =?utf-8?B?NmVWaXZQTjNCWTNFdTM4SkxIZ1RiWFpMSFg3M0prajA1UGJQdysrdnVZbGE0?=
 =?utf-8?B?RUE1Sk9NL3ZvazF2SFpXUkNtK3RkcmllcEdoczUwMXUzSGNMUjNPc0pxNTRZ?=
 =?utf-8?B?QXMyTmxablBVOWg4SkZpckptN1JvRmRwSDJ6TThzdm9IQngwTzUyekZ0TTVa?=
 =?utf-8?B?Um0wVng1QnNpd1ZpZm53WVVOYWl1MFZ2WmFEVlZSb2R3SDNvWklwam55QzRm?=
 =?utf-8?B?bVhTMHFTNFJPOXlSL2RHZE9lU01QajdueFBXVGlGaGhqSFdhR3kvYzZrakRK?=
 =?utf-8?B?WElLb2pYKy9pQnBzRWpmS3JLMWhLbXFUcEZuZVlxZExvMU5BT3UzYnZBNkNm?=
 =?utf-8?B?N2Z1Yzd0ZGVDNWF0aUpIYjJkQmM5a1RxOVdYSHpvWHVta3pLUXZGOTdpVjJN?=
 =?utf-8?B?anFRcW1DRmVwT0dwRHVDZmYxM2Fja203Ujg4S1pLRUZWVjFVZ09oOGY0c0d6?=
 =?utf-8?B?KzFiVGJxN292bDBaNWpjYmlDNVJGdHJHanhRY1RacXZjenZGcktjRDFyVGZZ?=
 =?utf-8?B?YXBPRngzZ0VkQ3RxQkdHK3g2MVJCeXMybnBlbzdVdkJKNGoxcVA2NXBhZWtH?=
 =?utf-8?B?SVo0K3A2N2tBaUJ4M1huZWUwZFBkdGV4UGpZOVVjK2J3ZGY0TEJseHV0Szcz?=
 =?utf-8?B?YXE0bUQwTFFHU1FwMDM4N0RlaWxwZGk5SUxldnR6dUZKZHpyMkd2bzhZcnBn?=
 =?utf-8?B?ZFNXMlg2bnFJcjN1NzBoWHpPRlI2THNvUi9wUHVUVkw4bzkwMUgramsrZkV6?=
 =?utf-8?B?NWhHeGpQUGF2NEVoRDBjVVNrdzExamtlZHFCMStDbGZLVFF2bFpDZzZhU3Vh?=
 =?utf-8?B?UGxyRGQ2QkF5TUFNdENXdjB1Z0IzMGRvdURpdjF1V1R2a2FYcmpsMDVBSkMx?=
 =?utf-8?B?bUJtVHAxUUZLWGlkNWh6QUx3bTc2Q1FxeEx1MU5LakYvc3QxMnlvK1EyR0Fn?=
 =?utf-8?B?bEVxcVZpTlcwdG9jMngvWlh5N1djOXdwQ282ZzVJdTRxelhzK2FNdS9SNGJW?=
 =?utf-8?B?ZnF0TFcxNW11djZucWRyZlNSc3E4bUNvWHF5TUxlWm1na0FLQ0tFaTZjNGJn?=
 =?utf-8?B?TmNtdGltL3pjdndGM0o1QjE1Q09oNmVpeThkR2F6Sm9vdmcrUWdTT1dEbXNH?=
 =?utf-8?B?eUVMY0tZdXRQKy8wY0gyQTlFVFU5aTRVTUN2RHpXMEhncTFlaDQvR0xUejZl?=
 =?utf-8?B?ZWRrRWlaam5SenVDcFZQdzQ5RVB5Y2xZeFFGNnQ0UFNOZHpSZFNWNy9pOEZ0?=
 =?utf-8?B?aWgyR2RJNUlUU0h4NVBQMzlLUm1XYXZjM2wveWxvTitZcmxwcTVKenNWVzBj?=
 =?utf-8?B?alJ2Q0RwcndvUkdyc2ZMTk4zZDdjQnFYelRScjVXMlZSVDJpeWpCT2REQm1C?=
 =?utf-8?Q?+aGhiin4Tv5IZYwMnQsn0b6bk?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae691e69-3cf2-430c-7284-08da881406f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2022 10:08:02.3141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l4lkoMYlPQTztuobB8+caU4tdJvzxdJ6UeYQrlww+3ZX6hWy2dC+Ef+5wF6fqt6kF3wctRT3LDrq81ZfcoGrMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3121
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBFcmljIEZhcm1hbiA8ZmFybWFuQGxpbnV4LmlibS5jb20+DQo+IFNlbnQ6IFRodXJz
ZGF5LCBBdWd1c3QgMTgsIDIwMjIgOToyNCBQTQ0KPiANCj4gT24gVGh1LCAyMDIyLTA4LTE4IGF0
IDA2OjUzICswMDAwLCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPiBIaSwgRXJpYywNCj4gPg0KPiA+
ID4gRnJvbTogRXJpYyBGYXJtYW4NCj4gPiA+IFNlbnQ6IFR1ZXNkYXksIEp1bHkgMjYsIDIwMjIg
MTE6MzcgUE0NCj4gPiA+DQo+ID4gPiAtLS0gYS9kcml2ZXJzL3MzOTAvY2lvL3ZmaW9fY2N3X3By
aXZhdGUuaA0KPiA+ID4gKysrIGIvZHJpdmVycy9zMzkwL2Npby92ZmlvX2Njd19wcml2YXRlLmgN
Cj4gPiA+IEBAIC0xMTEsNiArMTExLDEwIEBAIHN0cnVjdCB2ZmlvX2Njd19wcml2YXRlIHsNCj4g
PiA+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgZXZlbnRmZF9jdHjCoMKgwqDCoMKgwqAqcmVxX3Ry
aWdnZXI7DQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IHdvcmtfc3RydWN0wqDCoMKgwqDC
oMKgaW9fd29yazsNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qgd29ya19zdHJ1Y3TCoMKg
wqDCoMKgwqBjcndfd29yazsNCj4gPiA+ICsNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBt
ZGV2X3BhcmVudMKgwqDCoMKgwqDCoHBhcmVudDsNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVj
dCBtZGV2X3R5cGXCoMKgwqDCoMKgwqDCoMKgbWRldl90eXBlOw0KPiA+ID4gK8KgwqDCoMKgwqDC
oMKgc3RydWN0IG1kZXZfdHlwZcKgwqDCoMKgwqDCoMKgwqAqbWRldl90eXBlc1sxXTsNCj4gPiA+
IMKgfSBfX2FsaWduZWQoOCk7DQo+ID4gPg0KPiA+DQo+ID4gSU1ITyBjcmVhdGluZyBhIHNlcGFy
YXRlIHN0cnVjdHVyZSB0byBlbmNhcHN1bGF0ZSBwYXJlbnQgcmVsYXRlZA0KPiA+IGluZm9ybWF0
aW9uIGlzIGZhciBjbGVhbmVyIHRoYW4gbWl4aW5nIGJvdGggbWRldiBhbmQgcGFyZW50IGludG8N
Cj4gPiBvbmUgc3RydWN0dXJlLg0KPiA+DQo+ID4gbWRldiBhbmQgcGFyZW50IGhhdmUgZGlmZmVy
ZW50IGxpZmUgY3ljbGVzLiBtZGV2IGlzIGJldHdlZW4NCj4gPiBtZGV2IHByb2JlL3JlbW92ZSB3
aGlsZSBwYXJlbnQgaXMgYmV0d2VlbiBjc3MgcHJvYmUvcmVtb3ZlLg0KPiANCj4gSSBkb24ndCBk
aXNhZ3JlZSB3aXRoIGFueSBvZiB0aGF0LiBNeSBwb2ludCB3aXRoIHRoZSBzdWdnZXN0ZWQgcGF0
Y2gNCj4gd2FzIGEgd2F5IHRvIGdldCB0aGlzIHdvcmtpbmcgd2l0aG91dCBkaXNydXB0aW5nIHRo
ZSBjaW8ncyBzdWJjaGFubmVsDQo+ICh3aGljaCBpcyB1c2VkIGZvciBtYW55IG5vbi1tZGV2IHRo
aW5ncykuDQoNCm9rDQoNCj4gDQo+IFVuLW1peGluZyB0aGUgbWRldiBmcm9tIHRoZSBwYXJlbnQg
c3R1ZmYgd291bGRuJ3QgYmUgaW1wb3NzaWJsZSwgYnV0DQo+IHJlcXVpcmVzIGNvbnNpZGVyYXRp
b24gSSBoYXZlbid0IGhhZCB0aGUgYmFuZHdpZHRoIHRvIGRvICh3aGljaCBpcyB3aHkNCj4gdGhl
IGNsZWFudXAgeW91IHJlZmVyZW5jZSBiZWxvdyB3YXMgZHJvcHBlZCBmcm9tIGxhdGVyIHZlcnNp
b25zIG9mIHRoYXQNCj4gc2VyaWVzIFszXSkuDQo+IA0KDQpDb3VsZCB5b3UgaGVscCB0YWtlIGEg
bG9vayBhdCBbMV0gd2hpY2ggaW50cm9kdWNlcyBhIHdvcmthcm91bmQgZm9yIGNjdw0Kc28gc3Ry
dWN0IGRldmljZSBjYW4gYmUgaW50cm9kdWNlZCB0byB2ZmlvX2RldmljZSBub3cgaW5zdGVhZCBv
ZiBiZWluZw0KYmxvY2tlZCBieSB0aGlzIHVuLW1peGluZyB0YXNrPw0KDQpbMV0gaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvbGttbC8yMDIyMDgyNzE3MTAzNy4zMDI5Ny0xNC1rZXZpbi50aWFuQGlu
dGVsLmNvbS8NCg==
