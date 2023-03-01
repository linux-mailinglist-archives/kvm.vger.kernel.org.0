Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29DAF6A6666
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 04:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjCADR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 22:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjCADRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 22:17:54 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263B737B41;
        Tue, 28 Feb 2023 19:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677640670; x=1709176670;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=evVzLItUN4/M90uAluLpynabE0KX7s69yqAcqx+HErY=;
  b=Dyaooki8HS8AafV8uh0MCbCDhu4FG3eiN5yzvri0bRuemIrbsNWuSMiK
   1NAaqur2T3XZX4hEsmWzi6aakYVnSAhPTHpveDcAaU+aq2KBY683rF+wJ
   1mYrAuajScqFw5C+H3nm6qehOgRT8hUtKyecLY7DKLBGZ3aZAwCY8KH8o
   IieVAQKtTqXkQGvVn8AfYQNjWv8PcTGLitdASnINqaO10iZ5TsXFRCRtK
   AIxA9drkQWOR3dS3P+bAGTMBPdBcpjJ4RJsVgozFCdFG2QhGspnDZdGmP
   aCwN0k4JLNyM/rZe0V7HiePXCgRB58znxBEcRKtwvBElV/Fc1gyml/QGR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="336603519"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="336603519"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 19:17:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="738463733"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="738463733"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 28 Feb 2023 19:17:49 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 19:17:49 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Feb 2023 19:17:48 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 28 Feb 2023 19:17:48 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 19:17:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5vKCGzS5pzdEP9ZjTP7gAydDofbPEeNXjzfN6yAHn9mwduNr0nXwvHPnbyDcm/N3Xxy2gxTwBseU0/tSmiohqQ8EFY0Xc93Bbc07j08zbkUKMoy26VOKBh0EjQWDmTeNvCj1K4ZkqU0fM4DW05BouggNNCryWM3LfgUEJFOmoMrkab30n71S9ZnpADGnKF6d7H8vHb4e9wmeqY9pSgk4zLcMY2/+68uifDhPBA9tgXS+CzXWOwqIN/cU99SIQEVjO1EXLaQFgkNmb8i7VjM18NrD7p4OaebTwBb3QP95sj6dM+dWvLfoTrtjQum2drZ/WTY3nWhXg8yH2zFBSNDzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=evVzLItUN4/M90uAluLpynabE0KX7s69yqAcqx+HErY=;
 b=OmCHMo+yRB4TBM49NgoUnzgpo8rR/fWvfRjiNNS4CPhJjMPMAVPEAVXvrXxtN6xHkGg/C962dOTT8rxgOSxcZPZsRX25tPGH5eBmaMis5k0zZ1soEnutam+Z+s5yA8jGSBJQ9U+7jjeKZU1Kv4hk+1jLI5kvbJfYhb3Rc5tLn0fCicrTqTUDfHDrlTwhNlxmiocf+2mXuKIarTGw6mjl2ujacwy2GSdAyWQ2IOOtss8YHLgc9K9+pDkGklc0XMxY1Cmxk2WTxzXDFaPh/eoExJnBaKLeGXjfd88Q03NAUovJ92rcA5cn6nX3KKFFZ92l81A0KVQn4oVQq9nYqVNjMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by SA2PR11MB4938.namprd11.prod.outlook.com (2603:10b6:806:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Wed, 1 Mar
 2023 03:17:45 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6134.027; Wed, 1 Mar 2023
 03:17:45 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "H. Peter Anvin" <hpa@zytor.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [RFC PATCH v3 15/32] x86/fred: make unions for the cs and ss
 fields in struct pt_regs
Thread-Topic: [RFC PATCH v3 15/32] x86/fred: make unions for the cs and ss
 fields in struct pt_regs
Thread-Index: AQHZSCGoAtP+d2NP6kO8XHsOE5TSfq7d7fwAgABcnqCABu0ZgIAAEI2w
Date:   Wed, 1 Mar 2023 03:17:45 +0000
Message-ID: <SA1PR11MB6734131B9260C07CF1DCFECFA8AD9@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230224070145.3572-1-xin3.li@intel.com>
 <20230224070145.3572-16-xin3.li@intel.com>
 <bf1ad4c3-73eb-0f8f-e627-a7e0785fe903@citrix.com>
 <SA1PR11MB673406B8B43E18F0BD11C8DBA8A89@SA1PR11MB6734.namprd11.prod.outlook.com>
 <89026D19-3E98-4D88-820B-36A29488D46D@zytor.com>
In-Reply-To: <89026D19-3E98-4D88-820B-36A29488D46D@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|SA2PR11MB4938:EE_
x-ms-office365-filtering-correlation-id: 842e450a-54f1-4501-23f2-08db1a0386cb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mc58HNrqRHIWGThW/zIlNyJzpN/cUkw2D2Cn+eyZFWyA/rwnrWHjIs5VL3E9XeLG44NFYTDamgUi1mCsLWvHSvx3oh7LUgUnPwI6kRC6dLtSNRtn68CafTzE05DzTl7YtpnvXPrq3VvMTTopDS8EPdSdmdQwvUTnuiH8eoXG2uBc4IebSVOY/49kXxhDlH9lBW/Xy/InqSMqmglXmS9nt0juDaAGgNICuTYwb5RG4xeOBl18+OXu+SWpJvT2FUsTqL9RspOG8YkYIGasDGe4htjfHPSh9wpJpe0p09jviVtOU7HfoE2onhFAws8xOX5fd8/LaOgyJ4hsGp5KV17HmrUNoRd7cv7wRTy5DtDkZdLA5X0UD6+nhp2jSlfyW56oxpCd08ad/msW9KFLBWLzG7zYP3tnKMSOi5XQ3dnwY0jfYsTGGRSpchfssvqIKB26APaWtakuDinZiksQBuW9977Z/3fPnVl4vxBeFBe5bgOkRS9LSRns5FyaVpPhEh5nZPzNk6mZbyT8/f6KmC2bSQvLmUySxjNYAxnkt87c8ZPr6bk2jAY4WwiutuULEwm+Oy+8N2pPl84ZG02WW03GE1tCiXD1VWFWrmAENm1a4B9YAzxClAIIaqMTLVwKcDhkL1R0sslO3X6irExaGfRvgOJe+lDhZTaYW4ebTVUjQiFIvUy4S1A6QYM1m7vJn7glpaF+Qh5oW/mWgQ+UwuEWsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(39860400002)(376002)(136003)(451199018)(33656002)(82960400001)(71200400001)(122000001)(6506007)(2906002)(186003)(26005)(38070700005)(5660300002)(55016003)(478600001)(9686003)(4326008)(66476007)(8676002)(41300700001)(76116006)(66556008)(4744005)(86362001)(66946007)(52536014)(7696005)(64756008)(66446008)(38100700002)(54906003)(110136005)(7416002)(8936002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MWFWUUVLUS84b0plWUhyRENMb3NPMEF1RnlMQlBpUXdLYWhiYnEvL0ZaVXhp?=
 =?utf-8?B?UmVBZHJnRVNzeGJDZHBzQ2tyNDJ6MTcvZytHeUNVd2hYQmpKYnNyNTFLS1pV?=
 =?utf-8?B?MXRJSmFyRld1eDlIU2FzdnZ5NFRMbjAvOUI2NFV6VUdVTjY0UmtIVFhNZ3pw?=
 =?utf-8?B?UWJ4TnNMWE1xM2ZhNW8ydkIxUEUzRU1vdEFpVHJyQWZBd040WTlvYTM5bzhY?=
 =?utf-8?B?aS9VNDNKUjBPUzBmdnZFVkpjcmppTDhybFBYeU5xdGdHcTlqYTlUTlhKeFlk?=
 =?utf-8?B?Q28rYmRMemRvTGIyQ1pjT0UzbnJHblBkL3d3czNaMVk2ZXVrU3EzNVdOT0Zj?=
 =?utf-8?B?bUQwaGJvNUxhRmF5LzdNUCs4Z01kbGJUUk12WGZiWndnUzB0K0w1QUpHSWx2?=
 =?utf-8?B?V1VCSkNZMkZCZzBIR25uL0NMbU9nZEpuZnFYL1MwYjVhZXdEa1dpUUhlR2NB?=
 =?utf-8?B?QWt4Z1BBdCsyaGNhaXJTYmxBQVN3cjFWdnphRnZsQXJndXZITHVPKzl2SERT?=
 =?utf-8?B?azl0dmpnbE1kMXNOZnQ5TEFqQks4MFdwOTRld2pZVFlKbFhtVmUyREhuL1Ex?=
 =?utf-8?B?QVAwWUhJWHBWMGJjTGxBSmhxRTlNazRWNmxCWnBsWFpuYWdTaFVZUWFUQlg1?=
 =?utf-8?B?YXVKNHFmYU5aQ3lyZ2ZPRFdPVjZPbWZVYnEwM0pGUmxDTkZLbS9iOVFIYlVM?=
 =?utf-8?B?N1ZnK1RPU1ZrRnYwb1o4cjJ2MzZwY1dESHdrbENzOXd2am1UZ1lwMmVVNlQx?=
 =?utf-8?B?aGpPdnhjekJMd1Y5ZUVQK3RCM2FBNlljSEZhTFRIRVg2amZjOWVlUmNqSUxH?=
 =?utf-8?B?c3M1VmdVSVRTK0ovOWtwOWdKcmdTbGp2VTU4RHBoQUU0WGI0ei9qd2tOR052?=
 =?utf-8?B?RElLczBVdWpTNnBXSllFNDBwWFdQSHExM3hkcHdVMFd4R2RZL1ZUeU54Y1Q1?=
 =?utf-8?B?MGs0NVBDam44UGx5NFVYbDVnRUk0L1M5dWtmeHMzMUthY09wUTRZTXhyQUNS?=
 =?utf-8?B?WDQvRUQwWnJ2cUtqQjNNdzR3elRJVVoxRWFVZjZyNnNQWHVmMzJQZnRZcVhK?=
 =?utf-8?B?ejVxalV5YStuL2JNZGhzTVZESUlzRXBTdzMxRzN4cW9xdjJHdGtZK0lwc0wr?=
 =?utf-8?B?dU1OUTRPdk5OdmFyRkZ5M25hbmdJTlY4S2VpWmV2UHU5bWFZMFNxaXBibVNv?=
 =?utf-8?B?V1pxbTFwOWZEeVJwN1NydmRCMlRwZUFxYVJDRVNZWEEyLzNycGxMUFdwNzRG?=
 =?utf-8?B?eW1JOFBhSG1Ud3NTRjNHeE0vcUdnZDc4a1pqcjVpRjJpMGo3K0wrRXNtbzhs?=
 =?utf-8?B?THNNUU9pYWFyQnNPR09ycUtKaTAyT0p4RXpnTGcyaDUwdkNDTXNkQUFPUzdV?=
 =?utf-8?B?cTdqS283R2JsOUpaVFNZZWRFOHE5bkZmRXQ1YitGUVFpZm56RWt0WmhMOUxV?=
 =?utf-8?B?cWlGS1BHdUsxOTZHaG1OYkZGOFd4bjhLWXlCdi9aUDZOUmJBcUNTTkJxbW5X?=
 =?utf-8?B?NW5IR2owcDQ1eGMvVCtKU3MySXpwWWRDV2Fkd0J1TzdoN1d3MW1vaGtWSTUr?=
 =?utf-8?B?R3JUR25jYWVIVEtFT1RkcDhDTjRRUVZleHlybldtYWM5WmIyQlg2N1pYNmEx?=
 =?utf-8?B?R0tRRlFFUkpoWlpEWVQ3eHg5aFJ3SFBaZHZQZklsN0E3SUtqSVJwWlBFOUNq?=
 =?utf-8?B?V0U5SjdYWmIrS0d4KzNzcVhvMDE0YTZIQzQ1RGU3alNWTm5zV1V4TEs2bnZv?=
 =?utf-8?B?QjJncGhNVUIzT3hFNWRudkErUnRkVWFpelVHdmhLVG1SNWtteFMxWFJjcHVu?=
 =?utf-8?B?TlQwQXZwdHdWSHl4WVRRUUx3TWlUSzlqRlkvcG1nR2o5QnorMVl2dld6T1VR?=
 =?utf-8?B?QXREN2RYMmFXQXdlSjZkdnlUY2pmZDVRN2JXWVl6YkpRMk5PRktuREJHZlVC?=
 =?utf-8?B?c29XWGdyZHhyb05OekZIZ3l3dVdxUTZKMWlIZHRDVzhmcGtwTFIxOFNZVFVi?=
 =?utf-8?B?dWo3SkVGSG1tajhFTnRIS3ViT3YrbHpLaUJKQWlleHE4Tmo4MUJ0enQzYlZ0?=
 =?utf-8?B?aytFV1pOd1dMSjYwSW1WNGZzNUdIUlR4WUFYa1dTakgrVmtnZkJFR1dwc0xr?=
 =?utf-8?Q?cycE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 842e450a-54f1-4501-23f2-08db1a0386cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2023 03:17:45.1272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j5opg2krvaExrUSgUn5uI4yBkRaWCB+aTZtECI43EAkrecxuckQucuX3Km6BOgWajGoYGLpu4YOOb4dJYrN41Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4938
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+PiBUaGlzIGNhdXNlcyBjaGFuZ2VzIHN1Y2ggYXMgdGhlIGZpbmFsIGh1bmsgaW4gcGF0Y2gg
MjcgdG8gcmVhZA0KPiA+PiBpbmNvcnJlY3RseSwgZGVzcGl0ZSBiZWluZyB0ZWNobmljYWxseSBj
b3JyZWN0Lg0KPiA+Pg0KPiA+PiBjc19zbG90IHdvdWxkIGJlIG11Y2ggY2xlYXJlciBpbiBjb2Rl
LCBidXQgdGJoLCBldmVuIGNzX2wgd291bGQgYmUNCj4gPj4gYmV0dGVyIHRoYW4gdGhlIHZlcnNp
b24gd2l0aG91dCBhbiB1bmRlcnNjb3JlLg0KPiA+DQo+ID5jc19zbG90IHNvdW5kcyBhIGdvb2Qg
dGVybSB1bmxlc3Mgc29tZW9uZSBjb21lcyB1cCB3aXRoIGEgYmV0dGVyIG9uZS4NCj4gPg0KPiA+
Pg0KPiA+PiBBbmQgb2J2aW91c2x5LCB3aGF0ZXZlciBpcyBkb25lIGhlcmUgc2hvdWxkIGJlIG1p
cnJvcmVkIGZvciBzcy4NCj4gPg0KPiA+UHJvYmFibHkgc3Nfc2xvdCB0aGVuLg0KPiA+ICBYaW4N
Cj4gPg0KPiANCj4gSSBjYWxsZWQgaXQgY3N4LCBmb3IgImNzIGV4dGVuZGVkIi4gImNzcSIgd291
bGQgd29yaywgdG9vLg0KDQpjc3ggYW5kIHNzeCB0aGVuLg0K
