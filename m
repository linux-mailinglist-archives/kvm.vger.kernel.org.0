Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995A76CCF48
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 03:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjC2BNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 21:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjC2BNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 21:13:52 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813E899;
        Tue, 28 Mar 2023 18:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680052431; x=1711588431;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=q0UpkotgPgcoMqoMjBdYAvB6A4elms44ZdHeK8k1o/g=;
  b=miQ91j/pLqI7QgHHeu2Chra3cyVAnOOX9WsHpc02ZO7LaineXEl+zkuK
   Ll3GWg/F79mqRCRrVbpOxsmYhyJV6w568OTFEGab1sig2PIStjFGLpyMZ
   TGIoe3e3OVoxk1fT2g+/OhVhnXGH6eBcJmxDnZL+SDYopMcgUq8pibGIF
   dTZNXr/gKMly1qnZzPQmgqep5OV4c9aVZDASFh/eXtFi0+ZqOnGSevDpC
   FlhEGMCuCEMXZIe/gwl8kI6zevL3jBBfCxbLA3OC+X+5f6WD38h0MbBb6
   sxChQsmYYgGRqu65hhpynuJE+LdiLdsm/HBlwL8jfaAtlJoXH0R1Pdo3b
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="343154395"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="343154395"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 18:13:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="808015199"
X-IronPort-AV: E=Sophos;i="5.98,299,1673942400"; 
   d="scan'208";a="808015199"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 28 Mar 2023 18:13:50 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 18:13:50 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 18:13:50 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Mar 2023 18:13:50 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 28 Mar 2023 18:13:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBwEmzP7DKanmjmC2dIZdF8zCDeXkNdbaK1U9RChc8S/McqNH20s09rsr4lcYI525nQFA7PEP7tTNuVEwPB/Ssi1xXpYbkSm0xgPhEikMyJQSpsuzOOioshGnAuYaJJm54IE0BNYfJa8uyba9WaLdabAQw62g+/xuYZYcihjEXH2nPGCoo3l7xCCd0RiuHCaluX1a2vRxoywilTWskM8BwbzG8//awZYDeMoQgNXvJMp4phTUD8z5hnk+2CPIfnJQl1ygXLa94ey77i4OvYLSjF98XAV5Hx0TuKv+3vJwXmUeQN4jr/TuIl9FjBFuZW0S0p6Y3F/5ZmUVyqpLmSzPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q0UpkotgPgcoMqoMjBdYAvB6A4elms44ZdHeK8k1o/g=;
 b=BRxmkh5gRVTkM1FLQdJyNv3FcYSdpoPuYKqFtHXYZ//MhknDjWJ5jLjoUZNceefIZHz9B0WZQKQ4nBKcXbFqyxHx+Vf9mOXeWnzKTAtbXu2ScyvvmcOYj/BRzXN8s3l51M9rZUY4yRgSQXhd8MyhJW7Dt3jQd9TUc5/IhxyTJdNarFVmA3PIPGNMw5AUgzdVMCXoXN2tRAqFgpvcQyHPo04n850JqynYkcdhdJu4o1WW78P1zdCxh/NizutwqhTzxWH4IM4r0XaCXN+uMyoJKvLfr30tMZo8Qr5gkQWZ820Ie2JN8mz7fWARX8N2V07SWEogyilFA753OlLoa0Uhcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB4845.namprd11.prod.outlook.com (2603:10b6:a03:2d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 29 Mar
 2023 01:13:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%6]) with mapi id 15.20.6178.038; Wed, 29 Mar 2023
 01:13:45 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v13 003/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v13 003/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHZVQwsPOGReWj5Uka2uRq42SaKMa75keeAgAHjHYCAACbFgIAA9iwAgA0+bwCAByfygIAAFPmA
Date:   Wed, 29 Mar 2023 01:13:45 +0000
Message-ID: <5896fb851d20de4aab55307a73e2b4a4243ca155.camel@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
         <44f7fe9f235e29f2193eaac5890a4dede22c324c.1678643052.git.isaku.yamahata@intel.com>
         <20ebae70fd625f8a0fe87f98c25613a2d4dc5792.camel@intel.com>
         <20230315072711.GF3922605@ls.amr.corp.intel.com>
         <8ee89a1376babf0a5dbc2feb614890b7e2ccf2f8.camel@intel.com>
         <20230316002702.GA197448@ls.amr.corp.intel.com>
         <3ebe8d34ecf199b924f4892ce911077005526628.camel@intel.com>
         <20230328235839.GA1069687@ls.amr.corp.intel.com>
In-Reply-To: <20230328235839.GA1069687@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB4845:EE_
x-ms-office365-filtering-correlation-id: 8f68b050-f47e-411b-0f7a-08db2ff2d81b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JQrfkZ75jzSSd06TnGmB4qxRD2HiU0lDQGVsH9Rsw1QQZaEcIzDQGEznAgByjghzR+BgwWvwxNRtNe0h2VXAUa43K25e254Fs0vJqwfojSIymLweb8NHYSPVcUIcrQsjjDwScDMGYNDnJF5AeHjhR0GJTqYApJpmQ5U20q9WHaV7mTXRlB25UfaPrtqPlO49ea5NuW0ep8GaaVcYW5yi7aQEn9Bd4CpTcsDEqnM4MORFQ7PME13kXh7rq5NVFwfgHNtQsvEFrpuqrKSucH4NZtUbAFdozI7GZN7eEPwf5eufTr12fkayC8JaYHUOAJdTS5Akxu6ZTFOOYlToFE8AvEJ0Qbjdg4YJLjAPejXCdei7zyW7FUL0gOa1Kwc1KZN9qzYgfFKtiVK8urHy1vl8BZq6H3Vo63DQ5i+FDsTUVehb5oMFpZfDPl5AKBAhpCS0Qvm5+u5PCN2bjUiYCpxw8X6o4gPPuzWmb1aFiSiQaGdjjLMVVoeJPocF9AUuz9UTFNrU+bLXnb4STzEKK8WUP9Nx2jEkQFWTxq1T2DcRzbzEhOZK34cGljxJmDyYx8b7GoSmYh2nwsg77GAKrv6bEMJeQf37VopCUZPpcvSMsO8N5lDNC4G7heEJ0Grrd75I2h/vLIvMYfRqRgR7KMTmaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(376002)(396003)(136003)(451199021)(6486002)(54906003)(107886003)(478600001)(8936002)(316002)(6506007)(6512007)(71200400001)(26005)(2616005)(64756008)(91956017)(66446008)(66946007)(8676002)(66476007)(6916009)(186003)(76116006)(4326008)(66556008)(41300700001)(122000001)(82960400001)(2906002)(36756003)(38070700005)(38100700002)(5660300002)(86362001)(83380400001)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vkd5MTRrMXpOczd3aEFyanlYUUtFTUJJNExFOTBrUnhYcVhadStqbVoyTnc0?=
 =?utf-8?B?dmx4YURyaURwQWRvMWVCazdNc0R3SDlQdU5ZeGF5c0ZEOXc5SzNuR0ZJclUv?=
 =?utf-8?B?YSsycVh0dkM4cFNwQVVJclBuNCs0bVRIMGdtV1BYeWVQcGorMmpGTkt1QVNz?=
 =?utf-8?B?YytZMXB5M3lyZ1RMM2lQR0hFRjJuSDdlY3I0NkppUXh2TjcvdnFrSXlHL3Nu?=
 =?utf-8?B?SWsxbGkyNVNTamJBbUM4akN6MDZ4SlBGaW5WakNNUVNXZGpDV1p2eFBxNm01?=
 =?utf-8?B?bi94dWRvUzFoWjV6cnpCZHdrZ3R1SnBEK1htbVc0ZDJsbGdqSXNMdU1lNzgx?=
 =?utf-8?B?NktERCtweVVZN3ViZXJqZXZFR05JRERzT1B6NlludkRHb3NXQ3FmRmF2YkMx?=
 =?utf-8?B?ejJqMDRjUHVQRnFNTThmSUpaeGtCSDJ3QldwbHljSU9CcHRrWDQzVnNpS0Vj?=
 =?utf-8?B?YS9Ga0lNWTZjM3Rja25KQkorWS9GRW8zV0Q3SGsySCt6dkdacFYwWjh3bTdG?=
 =?utf-8?B?L25YMTBodWVaS0JaNmRNV1htUmVqOHIrVFJLYjUwMU0wQ0hUZE1Mamc2ZUxt?=
 =?utf-8?B?R0hOYXZuSUtaOFAvS2F3QnA0RU1nNzNYcXp1QWt0RXVDU0lianY5a0ZxRkQr?=
 =?utf-8?B?L2V1TVlVT3FkbFVvRmhRdzFDSVRmcURIRXczY2pVRFVRR2NSRW1RSFBVU09x?=
 =?utf-8?B?SWJyNnhqQjFtMnUyZVMzdkNMUEJYYVlSYnFybXNLMUZBNnhtM2JtdDFYYkxG?=
 =?utf-8?B?TThTMWQ0c2doTVFkVnRyZFZCaXVXTUhFMlhiRUdueityNDFXYXBDT21ZcjZJ?=
 =?utf-8?B?VDhaQTZUd0J1Q284M1ZnbFdqV014TG1iZU9UUFhDdGp3SGVnZG9OVDk0cmVu?=
 =?utf-8?B?NGhzNDRUSXlIelREVktJNVJOdjFYNFd3SmtMelh3NDlkRWI5WEU5VENpMEUw?=
 =?utf-8?B?ZldXZmpvdXdGWXB5TTgwRzEzWEpkbDZxY3I3eTJCK3IxM1JDVDBKWVVNb09q?=
 =?utf-8?B?c2l4TktjYlN6TTVXVWxTak01ZTFLWlQ0YWg2emIvdGZWd0dmZDhyTVlPUTMx?=
 =?utf-8?B?Q0lkNTBrZmZDS2dCbEN0OUxtZWdncW5BeWxKYWwrMzU1SHM5ck9GOEZwMkFR?=
 =?utf-8?B?akd1eDJsZ0xXL1BYcmJOZFBTMkM5T1pzSjB5Vm1XbGRWaG5PeVhIT1hZZTQw?=
 =?utf-8?B?NzRwQVkvcnhGSk51UHFDbHJxTFltc1Bib2psTkV3c1FIZldRRGsyWmFiT2d2?=
 =?utf-8?B?WGhpQUlLUXlCSUdDQkZNUGZVUEdaU2JUTGlJekNHRjJLbmkwV1l0RDcrQXd0?=
 =?utf-8?B?L3BIeWZkeU5EaWU5K3pMMUUzeUd3dzlXM094M1NEdUtGTUlVdkZRMTFnVlFX?=
 =?utf-8?B?emlyZTh6cFRtbktBNnhkcXhRZENiNDJCNzk2aEZGS1Y4QkdaSllMeDlMcXJD?=
 =?utf-8?B?N2I5YXFHY0FTZWNmZU91M0dUYzA2QWhNU3lDY3ZWUVQ5S3dvUGFadGhCMnZn?=
 =?utf-8?B?bUdZc1M5RGJmWVQrOE51cGcyNjFkREJBSC8rVDRWWENtSnNmdGdJVnVTVGRX?=
 =?utf-8?B?dGxDc2tkZnVsSUtTeW4zNlM1akN2dmV1QWZQY0sxb25NZG1tNmx3aEFWWDNk?=
 =?utf-8?B?YVlJdzRwSjhZejZOOVgrNldpOFNQT0s5eWdXWURxOWJTUk4vRDhVenlXZnBx?=
 =?utf-8?B?VXB6RmpZTFZvdHg5MUpoYWhNcWlIc0FZOHd1Q052VitsbnN4NjVuT3hyUys2?=
 =?utf-8?B?dXVPQyttN1ExTXU2UzVEbENQY1M3STVMRkhxM2xLLzhiL1hqL0ViRjZQRWVi?=
 =?utf-8?B?OHBMREU5VDE2M3RBd3d3NFQzVTROZzJ5OTlxaHZJQ3JoRDY2S0ZZaTRGYjJQ?=
 =?utf-8?B?SFNTaFdETTBJTlZxQy9PcjVncnFheDVoVlFmYUlnWldPc2FxQ3gzczVEZ3pE?=
 =?utf-8?B?Mit6U3JPdTJKWWJ0TEQxbk0zR3VycHVhUnFMS29VZjdGWkdIVFc3anZ5UDhz?=
 =?utf-8?B?ekpHaWRBcUJjTGhyQlNueDZpSXU3dEUrMTNjWXpzdGE1Z3ZQYW5sK0JDRkdr?=
 =?utf-8?B?c0dVbTFITFE0UlhhNkY2Q2U4NDlzMHMrWU9id2w0V1VoQVpJV2ZmeEdFVVRx?=
 =?utf-8?Q?63CyQtJfCurxySZ6Nqihhzo0T?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <71305FFCF29C834F8A9716CBD1B0F3A5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f68b050-f47e-411b-0f7a-08db2ff2d81b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 01:13:45.6831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FB4b0cGymSiESuZ+GZ/7zSwcCd39X5dwmnb0xB9GkCuZrHsN3WYnfJRh7N3jaIXAwyO5H0gliiDNg09M86/eiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4845
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiANCj4gPiA+ICANCj4gPiA+ICsJLyoNCj4gPiA+ICsJICogVERYIHJlcXVpcmVzIHRob3NlIG1l
dGhvZHMgdG8gZW5hYmxlIFZNWE9OIGJ5DQo+ID4gPiArCSAqIGt2bV9oYXJkd2FyZV9lbmFibGUv
ZGlzYWJsZV9hbGwoKQ0KPiA+ID4gKwkgKi8NCj4gPiA+ICsJc3RhdGljX2NhbGxfdXBkYXRlKGt2
bV94ODZfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdGliaWxpdHksDQo+ID4gPiArCQkJICAgb3BzLT5y
dW50aW1lX29wcy0+Y2hlY2tfcHJvY2Vzc29yX2NvbXBhdGliaWxpdHkpOw0KPiA+ID4gKwlzdGF0
aWNfY2FsbF91cGRhdGUoa3ZtX3g4Nl9oYXJkd2FyZV9lbmFibGUsDQo+ID4gPiArCQkJICAgb3Bz
LT5ydW50aW1lX29wcy0+aGFyZHdhcmVfZW5hYmxlKTsNCj4gPiA+ICsJc3RhdGljX2NhbGxfdXBk
YXRlKGt2bV94ODZfaGFyZHdhcmVfZGlzYWJsZSwNCj4gPiA+ICsJCQkgICBvcHMtPnJ1bnRpbWVf
b3BzLT5oYXJkd2FyZV9kaXNhYmxlKTsNCj4gPiA+ICAJciA9IG9wcy0+aGFyZHdhcmVfc2V0dXAo
KTsNCj4gPiA+ICAJaWYgKHIgIT0gMCkNCj4gPiA+ICAJCWdvdG8gb3V0X21tdV9leGl0Ow0KPiA+
IA0KPiA+IEhtbS4uIEkgdGhpbmsgdGhpcyBpcyB1Z2x5LiAgUGVyaGFwcyB3ZSBzaG91bGQgbmV2
ZXIgZG8gYW55DQo+ID4gc3RhdGljX2NhbGwoa3ZtX3g4Nl94eHgpKCkgaW4gaGFyZHdhcmVfc2V0
dXAoKSwgYmVjYXVzZSBoYXJkd2FyZV9zZXR1cCgpIGlzDQo+ID4gY2FsbGVkIGJlZm9yZSBrdm1f
b3BzX3VwZGF0ZSgpIGFuZCBtYXkgdXBkYXRlIHZlbmRvcidzIGt2bV94ODZfb3BzLg0KPiA+IA0K
PiA+IFNvIHByb2JhYmx5IHVzZSBoYXJkd2FyZV9lbmFibGVfYWxsKCkgaW4gaGFyZHdhcmVfc2V0
dXAoKSBpcyBhIGJhZCBpZGVhLg0KPiA+IA0KPiA+IEkgdGhpbmsgd2UgaGF2ZSBiZWxvdyBvcHRp
b25zIG9uIGhvdyB0byBoYW5kbGU6DQo+ID4gDQo+ID4gMSkgVXNlIFZNWCdzIGt2bV94ODZfb3Bz
IGRpcmVjdGx5IGluIHRkeF9oYXJkd2FyZV9zZXR1cCgpLiAgRm9yIGluc3RhbmNlLA0KPiA+IHNv
bWV0aGluZyBsaWtlIGJlbG93Og0KPiA+IA0KPiA+IGludCBfX2luaXQgdGR4X2hhcmR3YXJlX3Nl
dHVwKHN0cnVjdCBrdm1feDg2X29wcyAqeDg2X29wcykNCj4gPiB7DQo+ID4gCS4uLg0KPiA+IA0K
PiA+IAljcHVzX3JlYWRfbG9jaygpOw0KPiA+IAlyID0gb25fZWFjaF9jcHUodnRfeDg2X29wcy5o
YXJkd2FyZV9lbmFibGUsIC4uLik7DQo+ID4gCWlmICghcikNCj4gPiAJCXIgPSB0ZHhfbW9kdWxl
X3NldHVwKCk7DQo+ID4gCW9uX2VhY2hfY3B1KHZ0X3g4Nl9vcHMuaGFyZHdhcmVfZGlzYWJsZSwg
Li4uKTsNCj4gPiAJY3B1c19yZWFkX3VubG9jaygpOw0KPiA+IA0KPiA+IAkuLi4NCj4gPiB9DQo+
ID4gDQo+ID4gQnV0IHRoaXMgZG9lc24ndCBjbGVhbiB1cCBuaWNlbHkgd2hlbiB0aGVyZSdzIHNv
bWUgcGFydGljdWxhciBjcHVzIGZhaWwgdG8gZG8NCj4gPiBoYXJkd2FyZV9lbmFibGUoKS4gIFRv
IGNsZWFuIHVwIG5pY2VseSwgd2UgZG8gbmVlZCBhZGRpdGlvbmFsIHRoaW5ncyBzaW1pbGFyIHRv
DQo+ID4gdGhlIGhhcmR3YXJlX2VuYWJsZV9hbGwoKSBjb2RlIHBhdGg6IGEgcGVyLWNwdSB2YXJp
YWJsZSBvciBhIGNwdW1hc2tfdCArIGENCj4gPiB3cmFwcGVyIG9mIHZ0X3g4Nl9vcHMtPmhhcmR3
YXJlX2VuYWJsZSgpIHRvIHRyYWNrIHdoaWNoIGNwdXMgaGF2ZSBkb25lDQo+ID4gaGFyZHdhcmVf
ZW5hYmxlKCkgc3VjY2Vzc2Z1bGx5Lg0KPiA+IA0KPiA+IDIpIE1vdmUgdGhvc2Ugc3RhdGljX2Nh
bGxfdXBkYXRlKCkgaW50byB0ZHhfaGFyZHdhcmVfc2V0dXAoKSBzbyB0aGV5IGFyZSBURFgNCj4g
PiBjb2RlIHNlbGYtY29udGFpbmVkLiAgQnV0IHRoaXMgd291bGQgcmVxdWlyZSBleHBvc2luZyBr
dm1feDg2X29wcyBhcyBzeW1ib2wsDQo+ID4gd2hpY2ggaXNuJ3QgbmljZSBlaXRoZXIuDQo+ID4g
DQo+ID4gMykgSW50cm9kdWNlIGFub3RoZXIga3ZtX3g4Nl9pbml0X29wcy0+aGFyZHdhcmVfcG9z
dF9zZXR1cCgpLCB3aGljaCBpcyBjYWxsZWQNCj4gPiBhZnRlciBrdm1fb3BzX3VwZGF0ZSgpLg0K
PiA+IA0KPiA+IFBlcnNvbmFsbHksIEkgdGhpbmsgMykgcGVyaGFwcyBpcyB0aGUgbW9zdCBlbGVn
YW50IG9uZSwgYnV0IG5vdCBzdXJlIHdoZXRoZXINCj4gPiBTZWFuL1Bhb2xvIGhhcyBhbnkgb3Bp
bmlvbi4NCj4gDQo+IEkgdGhpbmsgd2UgY2FuIHNpbXBseSB1cGRhdGUgdGhlIG9wcyBiZWZvcmUg
Y2FsbGluZyBoYXJkd2FyZV9lbmFibGUoKSBhbmQNCj4gY2xlYW4gdXAgb3BzIG9uIGZhaWx1cmUu
DQo+IA0KPiANCg0KVGhpcyBkb2Vzbid0IHdvcmsgYmVjYXVzZSBoYXJkd2FyZV9zZXR1cCgpIG1h
eSB1cGRhdGUgdmVuZG9yJ3Mga3ZtX3g4Nl9vcHMuDQoNCklmIHlvdSBkbyBrdm1fb3BzX3VwZGF0
ZSgpIGJlZm9yZSBoYXJkd2FyZV9zZXR1cCgpLCB5b3UgbmVlZCB0byBtYW51YWxseSB1cGRhdGUN
CnRob3NlIHVwZGF0ZWQgKGluIGhhcmR3YXJlX3NldHVwKCkpIGNhbGxiYWNrcyBhZ2FpbiBhZnRl
ci4gDQo=
