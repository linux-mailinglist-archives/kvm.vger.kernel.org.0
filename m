Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D8D79B903
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236558AbjIKUtu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235295AbjIKIZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 04:25:26 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB04E4;
        Mon, 11 Sep 2023 01:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694420721; x=1725956721;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S2f+IMPPXYv0XTsnrRkJhYlCu8MUTtIlzv+L+KqSOkQ=;
  b=FmoRHUjFw1+7yTqMf2cCHDOFDsJiZV5ZD9ec9Fs7kOfuNy4uSRcSk2FE
   HtlBQVa9piE47fOBmUgwpuFXkxishxqYyYmh31S1s3j6YAV6a9YeJHnh3
   84S77yScwH0uDiMTI6mqcgY2NivgFS846tAv5feiz2rEj6Gh/espX04eE
   rJdH7TWyKeGSbhrehqAWZH9YOS70e8BsrHjE4wh8bIIjGcIrYp4rt3j1L
   UsqjAU8ibioPGCCkFNINyA18zGuQDRJVitiTNlNzU6p2mCt2iaZvk+Z9D
   fdXgw6mq1bCBBouxPd0mpNUpzqiP+0mFz6iQzAyNIHR5iH1Neqg2Y98DS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="375381960"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="375381960"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 01:25:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="778306903"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="778306903"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2023 01:25:21 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 01:25:20 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 01:25:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 11 Sep 2023 01:25:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 11 Sep 2023 01:25:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OIhHAYBhifSy+MBL0wfp86SgdsVK1AmV9KguA6JRXDS+P2GfdXSdY9KfShj9YD1kGYGRTW66HuVwp3Il/v2J0psO+74E9c5dUXMNStwIndb26iUAvF+9McMWLk1Jx28E1z6H5vYAC06BGU7PTAeANgWnAH7kD8qxLE1gU2h1++DFRpfxzJKBMa6yf79jLDJP/E75PPj6MrOl2dnW8advXKV2KJ/6cqa+MTJWY4ovccde6Au/K9SfpwZgXFAaIy9Z7+I4h3z5eDMYqacLAnde8DtSzeFPgrwhQLN77qVrAkKBGv0aRkovUEQskpA7roB0rNxn5F94XI4NRWIGKG1Q8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S2f+IMPPXYv0XTsnrRkJhYlCu8MUTtIlzv+L+KqSOkQ=;
 b=nqaQjJfGRipHqv8zNTVkj3CJvbp6G1I36wtNSGkGUb2YLFyFX4BPjONFVRFLwacrfO8aYjtLNmxmTtSxJtE9af3M0GKoVbU5izPpTbBtdZ1I8Bi61F5l4wr9Pf6aRfoXZTpb6dCqdVhwyuLwKuYLJ5gvr2KOEJZuo9qKx8ZJP2gAuRXdFOgWcNa0Ntmn7iKX6VH1s6K0YIRJz3VPQgrZAYGnE+9vfDeqUi++cXMe6yFMEcwcSD9A5YHl/dEAozwF5Mn/tFni5G4Sbkr7HeM7YJ4uOREbcyGEscdU7WyDlrxe9XBZm5DMVitB9G/YW+x9ffFvZrooeiexOZX75em41g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6291.namprd11.prod.outlook.com (2603:10b6:208:3e5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.33; Mon, 11 Sep
 2023 08:25:18 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::ddda:2559:a7a6:8323%7]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 08:25:18 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     oushixiong <oushixiong@kylinos.cn>, Jason Gunthorpe <jgg@ziepe.ca>
CC:     Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Brett Creeley <brett.creeley@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] vfio/pds: Using pci_physfn() to fix a compilation issue
Thread-Topic: [PATCH] vfio/pds: Using pci_physfn() to fix a compilation issue
Thread-Index: AQHZ5IdGUzbksBCVkUmY6jRmtcIIs7AVSdBA
Date:   Mon, 11 Sep 2023 08:25:18 +0000
Message-ID: <BN9PR11MB527657CA940184579FD31CAC8CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230911080828.635184-1-oushixiong@kylinos.cn>
In-Reply-To: <20230911080828.635184-1-oushixiong@kylinos.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6291:EE_
x-ms-office365-filtering-correlation-id: 4bd06791-94b0-43cd-8f57-08dbb2a0a1fe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7Y8UsIi/ox+vCpE5OxCWazhWN6E9Y8HpHI8WbR/TnXihtae5TlkLBI/o6wgf75QOF/ErkUHLnagyWVOhjnomVZSLfBH00ivsTZqt7iJ7Jl/H80QIJ7SzDCyW1dtFgYBbBb7lNVu5fWIp31KS2RfeGkWXiCOH0onh8hlEOPDh78HdzCeHbRA5RhqMtMI/WqEc+LatRITFLc4BIj2xxB413tTCg5//MBy5e06oNJ7jzc1Xxpj/HK5KRKHTw+ZjpEgPN9hlMV3N46R5JfaYes9lQrvywHYnlhJlz6+h5MKHk2evY1dP0zrFVm2oCBC2FH5ffs5hcDd7z1GK/RE97ETl9XOzx/B4dKN36bmO7ilBy6VokbrdZ9cLYF4Ve7kdLTO3s2CdJPBz8N+ZFPYSSHhn3BCSUrS/doGMj9mXf/eiOyRE1MUpNWjPWQEdoAbW+MoYWEeP5Ko4cSAnJgwZeAyvY1xn8fvivg8Vl5GGTzLf+TubYtlqFKU4SQ5pYUWF31Ba+Kg9kHExAMCplTCQlZD+GYoKVl+57Zn9eS6PBWx5bZwbToXFk3AGas80VTBAQa1AGxSofusV7al7VFMK1RyPMWvYMdM3XhQClp0RP6iwcz5WW3hI7ZzXc8sUe4IGUV3Z
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(346002)(396003)(136003)(376002)(186009)(451199024)(1800799009)(4744005)(2906002)(38070700005)(38100700002)(33656002)(82960400001)(86362001)(110136005)(55016003)(9686003)(6506007)(7696005)(64756008)(66476007)(316002)(66946007)(76116006)(66446008)(52536014)(4326008)(8676002)(8936002)(41300700001)(66556008)(71200400001)(122000001)(54906003)(478600001)(5660300002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SEhFOWNuSmVwdDVZcjBlNjZtME9PWFBoV1ljK21vM0hlNG5mTW9sWnV3VExt?=
 =?utf-8?B?bDJQQkRKQ0RBbWVTK2lxMVFJY0JLRElwdWRCRUdSL011S1FhWVlFbkY2dnl3?=
 =?utf-8?B?MWpwdVcvZCtZYkFEUGdjQnZ1bWJ1Smh6cVF4bEFlVGE4Q1BjZEhRM2FlZ0RN?=
 =?utf-8?B?ZzJNY2VXNm5DQVhSWVczKzFOYUlmRW1nNndRbUpCZXZpdXBFUk83Wkg0bE9o?=
 =?utf-8?B?c0I5TGFpL1p3TFNOV2NieWt6QVdYSWVIN21IRmg0TnpzSWx1cFZySUQ0WlMz?=
 =?utf-8?B?a1UxNVBnOVl0NU1oWVc1L2N1S1lJM1pTajUwQWk1Mi83Slhaa3FFckUzRldL?=
 =?utf-8?B?Q0tmZGlTYW9DMGF2eHZqYkNHNU8zbFdnREg4NzBjQkYvbUZBQ0dIdjQ0K1M0?=
 =?utf-8?B?Y2Fib3VIbitFRXBhRHVyTjFteGU5OS80QTJiSjIrMHk0MHpHc2ZaaUJwZVE3?=
 =?utf-8?B?NjE4THdxV1UyMHJQRUxmam9SRDlxenhQWUdDdFpZN2hDY3NaYjcyYXh1aHVD?=
 =?utf-8?B?djBaRXVybVJCdUlZTzNvUUpPaDhHY2lsR0xGZTIyK0pmNVBvU25qcFlhclhG?=
 =?utf-8?B?djBYOTA0dWFYbXBGZkdnYVQzZGtTKzJpdER4NmpCa0hoeDRndSttNnhQS1FQ?=
 =?utf-8?B?VE1PZHhPKzk4YmlZSnJSKy9TL05iSTZud0llck5VYWptU2ZEYitiYkl5ZlU2?=
 =?utf-8?B?TU5CcytqVlB0cDZLWVJFeTNGbmR6OTJ0dHNHOUZaSW0wckhnYVJiMzBJQ3Yy?=
 =?utf-8?B?UEo3d2hJYVEza1phV2JaMUhtbkNrRnhQQ25vY0pGZzMxTXcyYmczY3RTNHho?=
 =?utf-8?B?WUh4WUNBRERuL0ZWUTV6RDQ2N1JCVm9pUTdEUVhyN0kvTHFDQWdENG1pT1lR?=
 =?utf-8?B?N25LVFpmUnF4TVVJK3pqalFiSE4yWXRRejJJZTVpcTZpbGttUXdiZjRLQndz?=
 =?utf-8?B?eG9TbEJ3dmppOFFZeko4U2RvQUcvaXdNUWhGNnIrdDFWRUU1Vk9pRTJCcjVH?=
 =?utf-8?B?MG02L0xIN3NmSmNPa21GdDg5L1d3V01UYmwwZnMxd1RZd2pYdUUyQVpVRFF3?=
 =?utf-8?B?b2wyTHZ3cUFtcTB0azVMaXBFZlkzdmRMcDRicE1rUXJ2aThLTk1RcHRMQzVC?=
 =?utf-8?B?V0VwMEp5RlFxYjVOSjcvcmMvL3JQTzlrY0dtMEZMU3lqNFlWNGNFbmIwNHdR?=
 =?utf-8?B?QS9lWDRpQUpzTXdjRHAvSW9HQ1Y2alNwNjlXM1ZtYWV6MGNMeGsvOHpUZXpE?=
 =?utf-8?B?QjhRd3YrMFZndG1GWHpDeHEveWIva3BHanN4dC9xakVZRVNvUURVZGVuSXNJ?=
 =?utf-8?B?S0tKRTZhaHMxYkFQbFUwQmg3NEVrOTJwWjk2ejRuTmhScnNaRmVoczdsU1lT?=
 =?utf-8?B?TnJpMUlSYU5BNFV6dEEzUVFYVDBuYWpKbXhvSHdIYnorTCs5MGh3dDlvWkJD?=
 =?utf-8?B?SExFS3FHMHY5SktJT1hZY0Z3Y2xuR1VDWDBwQjdRV0toVHlEaWdHd1pUL2o1?=
 =?utf-8?B?dVZSNGlna1hnQVp6YmxLbHhSUGpoc1hMeW1TZjkzMEpYK2x5clhwV2o1WTNy?=
 =?utf-8?B?cytRWVBkaUJUbWJRQ1hvaC84VFYzbCtCYmQycDBDWmJobGlsTXFBZzNmazVQ?=
 =?utf-8?B?elBQSTA1dERkdStSQldJbG1oOWtoQXhzNDFORUhvOHJzMnpQZzRCdFZaUjFy?=
 =?utf-8?B?YmlUbHB5VVJERTg1ajZ2elVIQUF1eHNoVHdmU2RWMnQ5dUQ3RGhhRTcyUlkz?=
 =?utf-8?B?M0Q1RXplL0JOWHpJV2ZraDRSTzBVOENIR2hjbDRiWDVjbW5oaTl3Zy9NbVJD?=
 =?utf-8?B?TGNjaUR6S0U2V3VoUkJxNWc3aU1haU1nSWJ6bEIybk1qaWNTUVRsRnF0Z3Iz?=
 =?utf-8?B?VjBtbzh2YWdOWDU3My9UVURab0pDTWxjZ2hMNitVUnplVXRqL0pkQmg3aFRr?=
 =?utf-8?B?bjdHbkl5dHl3Z1RWaHJCd2hobjdSZ2R4ajlVVXppOVhCc25oWEtVQzBta0Ni?=
 =?utf-8?B?QXJWZVNOVmpqMkxjalo0RThkNDU2Y0NiV0F1OEs4bGlYWUdBVFljUnpBbUJ3?=
 =?utf-8?B?b2V2NXRpb013V1p0eCtEK0JyOWl3WGNDOERsTVRqNTN3b1VGcmU3TkVkNUVV?=
 =?utf-8?Q?gWiHTEC0AI8loG4sRXEu9FuPa?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bd06791-94b0-43cd-8f57-08dbb2a0a1fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2023 08:25:18.4845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W3mWGomhOFQOCO2Wg/XG6hfarQQiHF4duJoAPOcE4I26O6sKoo3rMS6TTnSoTFHHuauI/UzXY5wNHTW8oOxHpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6291
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBvdXNoaXhpb25nIDxvdXNoaXhpb25nQGt5bGlub3MuY24+DQo+IFNlbnQ6IE1vbmRh
eSwgU2VwdGVtYmVyIDExLCAyMDIzIDQ6MDggUE0NCj4gDQo+IEZyb206IFNoaXhpb25nIE91IDxv
dXNoaXhpb25nQGt5bGlub3MuY24+DQo+IA0KPiBJZiBQQ0lfQVRTIGlzbid0IHNldCwgdGhlbiBw
ZGV2LT5waHlzZm4gaXMgbm90IGRlZmluZWQuDQo+IGl0IGNhdXNlcyBhIGNvbXBpbGF0aW9uIGlz
c3VlOg0KPiANCj4gLi4vZHJpdmVycy92ZmlvL3BjaS9wZHMvdmZpb19kZXYuYzoxNjU6MzA6IGVy
cm9yOiDigJhzdHJ1Y3QgcGNpX2RlduKAmSBoYXMgbm8NCj4gbWVtYmVyIG5hbWVkIOKAmHBoeXNm
buKAmTsgZGlkIHlvdSBtZWFuIOKAmGlzX3BoeXNmbuKAmT8NCj4gICAxNjUgfCAgIF9fZnVuY19f
LCBwY2lfZGV2X2lkKHBkZXYtPnBoeXNmbiksIHBjaV9pZCwgdmZfaWQsDQo+ICAgICAgIHwgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fn4NCj4gDQo+IFNvIHVzaW5nIHBjaV9waHlz
Zm4oKSByYXRoZXIgdGhhbiB1c2luZyBwZGV2LT5waHlzZm4gZGlyZWN0bHkuDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBTaGl4aW9uZyBPdSA8b3VzaGl4aW9uZ0BreWxpbm9zLmNuPg0KDQpSZXZpZXdl
ZC1ieTogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo=
