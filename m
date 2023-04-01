Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93B86D2F03
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 10:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233621AbjDAIM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 04:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjDAIM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 04:12:56 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1EDCC3E;
        Sat,  1 Apr 2023 01:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680336771; x=1711872771;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lP+MAiDr5y4wfL/nWA2MNff1rmtOYwBMES+/I+SkZ8g=;
  b=lQMaC+BiauO0L68Sy5w2lP1V/Cr6RSTAJeqOXoa97oN4Ht2aERgMxYc4
   xhTIXITDolDlLDIoAwXYiNAONkAK4n4uLgaLksZj9Iv94jaGsqklAee8m
   pNqTkMByPQw0lc5LuKtSLg8uKnQOieX4O+kYx1jIhpZlyZPqbIOqAJGZ/
   vV/C+GfCdMe+/W1zUKTHxcjH0mw16s1h7qBz8aqD8p9Kq446e4HmORaRI
   az00/2Sa/FZPJxULzRhnixn56oAeSak/th5JE/wICIMXE28xg3tHbuaVZ
   eEe2gwgdUywuDM5ak00nA6j9RMMe+HP+kGsYyiMsQnydio3UhCV7l05hn
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10666"; a="404375619"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="404375619"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 01:12:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10666"; a="828986105"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="828986105"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 01 Apr 2023 01:12:49 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 1 Apr 2023 01:12:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 1 Apr 2023 01:12:48 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sat, 1 Apr 2023 01:12:48 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sat, 1 Apr 2023 01:12:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=np4j0BwAQwNuZQlUM7/lhBGaOp0jb86ih2TwH6RjO06ssqjTvI0VHqtQnNNWehIPXEmbZJ4yTmQr9EoKXnLPhBiXwNh4fHB5AYp2IIu5fgjIWGMq9pya5XVmzTtPWKV9+pjBYtwkTF5znc9exFynrNJ901nO4H6whWmofj+KP4Esal5XhrFX9IxX5tddwEnUS5pzCNTxTsuGgYPc35VokT3B9/o4LHuRd8iM5kfgXz/DUKh85yL1GaXgkPJlOXoKPznE+AIenETrVdZLDDD/TyiU8LugrohzrZ6zHP0lYDaUigFftQ7Msjn2mRuQvi04aJiCaY1KcfHo3coAjyxTQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lP+MAiDr5y4wfL/nWA2MNff1rmtOYwBMES+/I+SkZ8g=;
 b=AkDrZgaaW98WgKx6cwQ/6TdZ7yzQWfCf8g7mbwplqH8qDGzWzwwyrwmFmxko3Mcq+xcYDVnfGQRu7Q1Q//2XkZH3ypuTMTILf5DFbENh68oqcXEDKkt6Y++CSpUqFzsPiLe6sziFW2cFBvEwUtGPpKjo3OEAwC8cItFlvanEJakN6mvhEAonWOqT1dxIWCfLsIfffs0wWys+1qRq/2QhNlHhl22td75Ororqr9E9TKX4vo3LoJbf/YL75tpSwDRtxhDnb6Hj6ZJl3DLkwN+ytwQjnUl59bb2Iz7Ih4s4ccVNEMpFuwwkCcaGGs22KO8I9D3eQf9sWsEQeZl3E2IIZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CH0PR11MB8168.namprd11.prod.outlook.com (2603:10b6:610:186::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.23; Sat, 1 Apr
 2023 08:12:46 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948%4]) with mapi id 15.20.6254.022; Sat, 1 Apr 2023
 08:12:45 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v6 27/33] x86/fred: fixup fault on ERETU by jumping to
 fred_entrypoint_user
Thread-Topic: [PATCH v6 27/33] x86/fred: fixup fault on ERETU by jumping to
 fred_entrypoint_user
Thread-Index: AQHZYIXGi/xSJ0UMykKUeN9FhmRno68UjXwAgAE5xtA=
Date:   Sat, 1 Apr 2023 08:12:45 +0000
Message-ID: <SA1PR11MB673435C03F7245425DEB36E7A88C9@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230327075838.5403-1-xin3.li@intel.com>
 <20230327075838.5403-28-xin3.li@intel.com>
 <CAJhGHyDQSHkfxVS1o+rqA4JaaOpvyVH0C5JNLKdDuzNtncQiTw@mail.gmail.com>
In-Reply-To: <CAJhGHyDQSHkfxVS1o+rqA4JaaOpvyVH0C5JNLKdDuzNtncQiTw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CH0PR11MB8168:EE_
x-ms-office365-filtering-correlation-id: 62f4cfd3-5f8b-4716-f8bb-08db3288df8f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QzIzTpV4P0Fz0MxUyF9xX90S/QXdyQO//zK1tpReBBgNOfjEhz/GZA8tkk397VJ6/GTxUx/zthyl5HyiFPmgLl+PCtuW6ZFmFlc9NNEf8m5bYdTAZQof/hvbeAWrJIlA0ph2t5hJZbqAup5hrLv+/H6O1lDMyiKRkoyVErV9tdeC4bASDHtyITJsIf/6Hi3od7xDRXujC88J2C9nmg43gur6Ix5Syelf7bkMKx4ZEg/XEE1U69ti1m+UVDkwsl4y+d3RaD0d2SKBThAg+h72MqJF3brOBnGNdlLVFLsxMyAl2LqIdYkryuLxwAcH+OyR4tZF9r/7fiwcfs4WMWavrN2w6y+wzNoA6F13WSkjozxsF4dI6T2MpYFeTXblKn+RSBXvnhzJvLFdcRlWZkMV8lJyFlX9MU/02yNfrLkFw358Qgm07I+Y1XCkPvkC8SvnncFyIibDsdj49JNiqXthQstZIQrOjFONGeEv5iUpeMkxIo0PVZtD4xldG9Zjf16Dm0oq5eXTI+ezSVTWSeGeGQIJ/LrnJrpuXSK00o1bllCcluYTj1KkGVnWjS5N7F41rhSoZZV4z+x2SalksnaoNyy1NQZA7SP512/NjDHstSUYSZtWNmOLVZctNHPdsA/T
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199021)(5660300002)(38100700002)(52536014)(41300700001)(8676002)(122000001)(8936002)(82960400001)(55016003)(38070700005)(86362001)(7416002)(6506007)(26005)(7696005)(71200400001)(9686003)(33656002)(186003)(6916009)(66476007)(316002)(4326008)(64756008)(76116006)(66446008)(2906002)(66946007)(66556008)(478600001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UU1xZTFSalBuVXFvckNmZTlYYlM0VXBKNit1S29CUGZwZDdxcDNWMm9TN09w?=
 =?utf-8?B?OGs1aXhOTnFwQkh2Y1FZbyszMXlTQUJOVXZjVkF6RUxOa0V1TTFndjlWTTBV?=
 =?utf-8?B?b2lMNGFmR1AxUE03WlNhUEs1cm43K1I2cWh1bHpiQlRNSDdZZzQxMUlPNnNW?=
 =?utf-8?B?alpVRUN5Zjl1UUcrSmUrd2s2enViYS80RVhKZ2UyaWY4WG1qaFZTKzZtcHV3?=
 =?utf-8?B?UkdBMnlLblh6SDlGa3ZXNDZnclZYWGcrRWRKaHA2aVRmN2Q1T0tib2gyemYx?=
 =?utf-8?B?Zk5wWUpTbEFEMTZpNTNCVTF3QjN2R2hjTWF0VHIvUW1lUktZV1hkV2NFa2E3?=
 =?utf-8?B?WG44NlF5THZtY3JHQkJySFNWeFR4QllCYm5LK0p5a1NXckVpdnpDOUdQT2FO?=
 =?utf-8?B?ZDhSMmV0WEt5UDNGeGdPNVNUNStQTFFpbzlzVzhDK2xjN0VHV2NMd2dSZFFu?=
 =?utf-8?B?c0tTayszZElVd3UvL05hUHFCYWdlZGRmSjh1SEc0Q2lOclpUbXJ1SE8rNUtp?=
 =?utf-8?B?RnNaOGpNWWVDSEFyUkh3TG5TUkQrTG41TlZzL3l5SlVMRUhJbkhnbldwTmhR?=
 =?utf-8?B?NTRJS0NHdUtjV0F1bUVmNzBJcXhFOUNIZ2FEN0dHL1NiYzB0Z2FSMjNBanpo?=
 =?utf-8?B?MGR3YkhqMFFwcG0vODdRbFNEcVl4OXc0SFdpWVArNUlZN0MyS1R1K1ZEK2pI?=
 =?utf-8?B?YldBV3lMSmZxNndYV1g4cWhMZHlqL05LZGx6VkkvaE1DZ0d1ZEJPOS81azA5?=
 =?utf-8?B?WnRIYzc1cWd1UkVIUlZvaXJVMVo2ak5aZjZiN1Q1bnN6dXBoTWlNMkUwdGZH?=
 =?utf-8?B?QWNvSk8vanZRS0dFMHdIRDNMYyt1cUdzWW5wc1BsT3RYejkya1hRZk9uKzgy?=
 =?utf-8?B?VFlQOFRUVWl0dFk1ZElDS25uWnF4WGJ6SngxQmRzMUdXUWdNWUt5K0RTNWQ2?=
 =?utf-8?B?WUtqK3FHd3Y3dHIxdVRhaXBTTXdEeDJoM3ZRKytZNGhrY1FCUEdTMlQ1VDFR?=
 =?utf-8?B?ZGJLa0dZTGt0TWRzOXBNSWpTNGN0TVNqRFBuN3J4ZDVqWGNlN1hIc2NmbmJO?=
 =?utf-8?B?T1lPaHZTZStSWjJCN215N3NlalBLVWJGODdNbzRTUy8vSFRLRURueWVLdkdL?=
 =?utf-8?B?ZVBUVlBHb1FCbmZxN3hKamVXbDBsL2NrSGNLZTVDbjhjOHZ2aFkwSVY2RlZQ?=
 =?utf-8?B?ZytVNWpDMnAwcEhESmRDaGhuVWlQbjBGK2dWcXkzSFYxaVJVYlhGcGFDS2RB?=
 =?utf-8?B?THY0b1ZXT1FPMnRyb0cwVDExb3lZTTJIT0VydWM4SkNIK1Jaay9tVHJrZkIr?=
 =?utf-8?B?SkRUb2pzT0R1V1RuTitiQzR4NmdPaHl2YjRhNlJvbGg2enJPajlxeWRiMEFJ?=
 =?utf-8?B?TGc0eXBDYzJVTzB0clA1WmdXTXJQdDZKejlFUmpFUWwreThtUTNKNk5CNjI2?=
 =?utf-8?B?VDU2QXpJZkxKYmJNUlB3aUVaWjZCZGJkS2pBdW4zZi9OcHh1ZUVaZld2MFh0?=
 =?utf-8?B?MVF2TEJadGhVd3pNZXd6RTZieUgrVmR5R0psSHZSeVdLeUxMTHV1Nko1VzRq?=
 =?utf-8?B?bTdUU04xenora3ZDZWcwMDU4S3lieFMzRmc2aVU5b1EwYVUzZGl0NEQvYno4?=
 =?utf-8?B?TUVGT3FYMlU1cUtkdE9od0hjVEtSZFE0TE4zenRGblVkRDQwOTJUQzhGYlRO?=
 =?utf-8?B?Yy9TUGJOcXRRZ3BKbXZNNjBIVElsbDNGcHNHZmZORk4wVVZzWVFnTmNRcGta?=
 =?utf-8?B?a09MQmc2MVpyNkxjeWNRWXV0ODkxQXJNTUtKUHJOTG9vMUZ1ZGNMWXhZeTF4?=
 =?utf-8?B?bjdDTS80K3VuQVVOMEtwVkplL1B2eS9iZlA5dFFmWUpCNEE3cnlWTDV6cWdG?=
 =?utf-8?B?R25wbk9XVGR1bXJtdElMSzR4b1gxSHN2dkRiTEkzZnNMb04zME9WaUJETFZL?=
 =?utf-8?B?UUNqeHgxeUMzT1NNNXJldDN6eEo0U1BaL3lYblJ1RGRCMkFkL1hVR2tWNjNB?=
 =?utf-8?B?Wk5nYmhuV0V2RG12OVlYWk53eEVZM09CdjJhczJMdk50WG4zWFFQaDNYZUNO?=
 =?utf-8?B?ZlZnVms5NFRFVTJTK2prSjlrU2hPNlZMNTZFTHZwZzRYVHJOaXh4c05kQStt?=
 =?utf-8?Q?QYxg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62f4cfd3-5f8b-4716-f8bb-08db3288df8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2023 08:12:45.0355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qemzdNFmdmfC8ZsT+ABESzo+sI2LzfM/HZUo7knKqQVLqDf8aA9wW2Zf9sAD4w3DTMIZKCkkKUlNBH20XPVKRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8168
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+ICsgICAgICAgLyogQ29weSBlcnJvciBjb2RlIHRvIHVyZWdzIGFuZCBhZGp1c3Qgc3RhY2sg
cG9pbnRlciBhY2NvcmRpbmdseSAqLw0KPiA+ICsgICAgICAgdXJlZ3MtPm9yaWdfYXggPSBlcnJv
cl9jb2RlOw0KPiANCj4gVGhlIGFkZHJlc3Mgb2YgdXJlZ3MtPm9yaWdfYXggaXMgYmVsb3cgcmVn
cy0+c3AsIHNvIEkgdGhpbmsgc29tZSBjb21tZW50cyBhcmUNCj4gbmVlZGVkIGhlcmUgdG8gc3Rh
dGUgd2h5IGl0IGlzIHNhZmUgdG8gd3JpdGUgdG8gdXJlZ3MtPm9yaWdfYXggKGEuay5hIGl0IGlz
IG5vdA0KPiB2ZXJsYXBwZWQgd2l0aCByZWdzKS4NCg0KR29vZCBwb2ludCwgYmVjYXVzZSBpdCdz
IG9uZSBvZiB0aGUgbmljZSBGUkVEIGZlYXR1cmVzLg0KDQpUaGUgUlNQIHVzZWQgYnkgRlJFRCB0
byBwdXNoIGEgc3RhY2sgZnJhbWUgaXMgbm90IHRoZSB2YWx1ZSBpbiAlcnNwLCBpdCBpcw0KY2Fs
Y3VsYXRlZCBmcm9tICVyc3Agd2l0aCB0aGUgZm9sbG93aW5nIDIgc3RlcHM6DQogIDEpIFJTUCA9
ICVyc3AgLSAoSUEzMl9GUkVEX0NPTkZJRyAmIDB4MWMwKSAvLyBSRURaT05FIG9mIChOICogNjQp
IGJ5dGVzDQogIDIpIFJTUCA9IFJTUCAmIH4weDNmIC8vIENsZWFyaW5nIFJTUFs1OjBdIHRvIGFs
aWduIHRvIGEgNjQtYnl0ZSBjYWNoZSBsaW5lDQp3aGVuIHRoZSBldmVudCBkZWxpdmVyeSBkb2Vz
bid0IHRyaWdnZXIgYSBzdGFjayBsZXZlbCBjaGFuZ2UuDQoNClRodXMgdGhlIEZSRUQgc3RhY2sg
ZnJhbWUgZXJyb3IgY29kZSwgaS5lLiwgb3JpZ19heCwgaXMgX2Fsd2F5c18gb24gYSA2NC1ieXRl
DQpjYWNoZSBsaW5lIGJvdW5kYXJ5LCBhbmQgYSBuZXcgc3RhY2sgZnJhbWUgaXMgZ3VhcmFudGVl
ZCB0byBzdGFydCBiZWxvdyB0aGUNCmVycm9yIGNvZGUgKEFuIGV4dHJhIFJFRFpPTkUgb2YgKE4g
KiA2NCkgYnl0ZXMgbWF5IGJlIHB1c2hlZCBiZXR3ZWVuKSwgYW5kDQppdCBpcyBzYWZlIHRvIHdy
aXRlIHRvIHVyZWdzLT5vcmlnX2F4Lg0KDQpIZXJlIGlzIGFuIGV4YW1wbGUgd2l0aCBhIE49MSBS
RURaT05FOg0KDQogIDY0LWJ5dGUgY2FjaGUgbGluZSA9PT4gIF9fX19fX19fX19fX19fDQogICAg
ICAgICAgICAgICAgICAgICAgICAgfF9fX1Jlc2VydmVkX19ffA0KICAgICAgICAgICAgICAgICAg
ICAgICAgIHxfX0V2ZW50X2RhdGFfX3wNCiAgICAgICAgICAgICAgICAgICAgICAgICB8X19fX19T
U19fX19fX198DQogICAgICAgICAgICAgICAgICAgICAgICAgfF9fX19fUlNQX19fX19ffA0KICAg
ICAgICAgICAgICAgICAgICAgICAgIHxfX19fX0ZMQUdTX19fX3wNCiAgICAgICAgICAgICAgICAg
ICAgICAgICB8X19fX19DU19fX19fX198DQogICAgICAgICAgICAgICAgICAgICAgICAgfF9fX19f
SVBfX19fX19ffCAgPD09IEVSRVRVIHN0YWNrIGZyYW1lDQogIDY0LWJ5dGUgY2FjaGUgbGluZSA9
PT4gfF9fRXJyb3JfY29kZV9ffA0KICAgICAgICAgICAgICAgICAgICAgICAgIHxfX19fX19fX19f
X19fX3wNCiAgICAgICAgICAgICAgICAgICAgICAgICB8X19fX19fX19fX19fX198DQogICAgICAg
ICAgICAgICAgICAgICAgICAgfF9fX19fX19fX19fX19ffA0KICAgICAgICAgICAgICAgICAgICAg
ICAgIHxfX19fX19fX19fX19fX3wNCiAgICAgICAgICAgICAgICAgICAgICAgICB8X19fX19fX19f
X19fX198DQogICAgICAgICAgICAgICAgICAgICAgICAgfF9fX19fX19fX19fX19ffA0KICAgICAg
ICAgICAgICAgICAgICAgICAgIHxfX19fX19fX19fX19fX3wgIDw9PSBSU1AgYWZ0ZXIgc3RlcCAx
KQ0KICA2NC1ieXRlIGNhY2hlIGxpbmUgPT0+IHxfX19fX19fX19fX19fX3wgIDw9PSBSU1AgYWZ0
ZXIgc3RlcCAyKQ0KICAgICAgICAgICAgICAgICAgICAgICAgIHxfX19SZXNlcnZlZF9fX3wNCiAg
ICAgICAgICAgICAgICAgICAgICAgICB8X19FdmVudF9kYXRhX198DQogICAgICAgICAgICAgICAg
ICAgICAgICAgfF9fX19fU1NfX19fX19ffA0KICAgICAgICAgICAgICAgICAgICAgICAgIHxfX19f
X1JTUF9fX19fX3wNCiAgICAgICAgICAgICAgICAgICAgICAgICB8X19fX19GTEFHU19fX198DQog
ICAgICAgICAgICAgICAgICAgICAgICAgfF9fX19fQ1NfX19fX19ffA0KICAgICAgICAgICAgICAg
ICAgICAgICAgIHxfX19fX0lQX19fX19fX3wgIDw9PSBFUkVUUyBzdGFjayBmcmFtZQ0KICA2NC1i
eXRlIGNhY2hlIGxpbmUgPT0+IHxfX0Vycm9yX2NvZGVfX3wNCg0KICAgIFhpbg0K
