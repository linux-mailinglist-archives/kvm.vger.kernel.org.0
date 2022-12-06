Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB715643DA4
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 08:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbiLFHbi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 02:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiLFHbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 02:31:35 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1C214006
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 23:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670311895; x=1701847895;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BboxWF4aTWjsKo+4QoUcL+sQOuzUJWPhBJvH2DenhwQ=;
  b=OQD/w8JRIyM9rkS9Fm1uuCoOQN9YT/dn8fBT+UllSjOYbMBG4A1PoZFc
   cSkk2pNqjv10+ocFQEvFaSxEhZ7E+endqdhEBkbAhdrnX2V4OAIPYHQsS
   OOgVS8ecodGxfnwyH5ZbwajEnyyuWGY0CUDYL33/y8wDiGb5B2ly9zCUl
   +zlq8nLdFWDbckP1de+wbzS7Deb6g5cZ2CkY6nPiK8qw/AIb7E8mFMEgp
   VZgNvVidXmIC9OSja6YkMZldsr8LN4KIUxcKa5fvmnJtvpNDhkfOPNbyh
   TPF3WoFusMQNImMZFeQijqJtUsaBaeXSe1fO+AxsfjbSWAXh7yXhUFsc+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="296912423"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="296912423"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 23:31:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="648235061"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="648235061"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 05 Dec 2022 23:31:34 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 5 Dec 2022 23:31:34 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 5 Dec 2022 23:31:33 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 5 Dec 2022 23:31:33 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 5 Dec 2022 23:31:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGzJyqaeihVM15VI0yqIrro980oEhUScXarIRKxdvf2xp4LJcZrhs6ClgJ3gX4dYITZOAuNfoOyn4bzT8TjVqLiDzG94IAjs1k/0hDu06LOBhqbkl57r+nfILa3SZlpB1PCJbeb4HWl3DFT+vj7Fsw3G6eO0Z+D2WVezYviNBM9u6+8Z7o3NVZu3OJnL1Uvn0irWT1eI0u91z87kmuQHWlSS7Ff+dt0YF7PWNienxd6ES2S2pbaS+5T11ytk5E5rIo4gmXep9Cc67+Ya+VK+ljBySw3bDvi7AyW2akbysQ/w6UBGHX0xcZO1+AP069hzsuLCb0Fc/CRUMusTfYMP0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BboxWF4aTWjsKo+4QoUcL+sQOuzUJWPhBJvH2DenhwQ=;
 b=eqFFegYdtQQsSEMi3dVEXORCoz699OK5RcNbVMleYpPzGsec9JuUgB9vOwAsQ3bGO5IyTMnedjO6ul+kfkDx/JusxZujlFbGHLJEskjYsb9Xet+gpGAl0M5EBjcJqqrqaj6tuFT2tDgaqi8ndl5oVVxv0330udYA0KkGe713uKBzuCq2ssVvGI5Uh7z7gy+PVzL1b8IYR5/cnpBRLawPO3AcviGbudESZLNwK+olQft+ZAct30RArJZN4nXSSL+zFvqGoshusQr5c6X4lTqblYL7k5NtoONNy/UOCLNjvvyJP7XJL13rV6LvlCr54WiVBVjJ7F3AkbnsjK7gkhybSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY4PR1101MB2230.namprd11.prod.outlook.com
 (2603:10b6:910:1c::20) by CY8PR11MB7243.namprd11.prod.outlook.com
 (2603:10b6:930:96::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 07:31:31 +0000
Received: from CY4PR1101MB2230.namprd11.prod.outlook.com
 ([fe80::ad68:be1e:85a2:1859]) by CY4PR1101MB2230.namprd11.prod.outlook.com
 ([fe80::ad68:be1e:85a2:1859%10]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 07:31:31 +0000
From:   "Yang, Lixiao" <lixiao.yang@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "He, Yu" <yu.he@intel.com>
Subject: RE: [PATCH 00/10] Move group specific code into group.c
Thread-Topic: [PATCH 00/10] Move group specific code into group.c
Thread-Index: AQHZBZUCjeDf/vdV5kaD+SeFYgaWwq5ZfuaAgAEiC4CAAA0QAIAAjemAgAD2HQCABEr6YA==
Date:   Tue, 6 Dec 2022 07:31:31 +0000
Message-ID: <CY4PR1101MB223078550837BB1EAE608C17EA1B9@CY4PR1101MB2230.namprd11.prod.outlook.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
 <Y4kRC0SRD9kpKFWS@nvidia.com>
 <86c4f504-a0b2-969c-c2c6-5fd43deb6627@intel.com>
 <Y4oPTjCTlQ/ozjoZ@nvidia.com>
 <20221202161225.3144305f.alex.williamson@redhat.com>
 <fecfc22d-cb9e-cac9-95ff-21df13f257c2@intel.com>
In-Reply-To: <fecfc22d-cb9e-cac9-95ff-21df13f257c2@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY4PR1101MB2230:EE_|CY8PR11MB7243:EE_
x-ms-office365-filtering-correlation-id: 9d3a30c7-5f55-4e84-c781-08dad75be562
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YodQrnt3iCwSP8RqYJhtymUUX11PuoEqyy4FCe7jh7tkyI5GHVRoTIvNfxSobrMDg4z1uB77gSIFIihNJ53RWAl5gU6ZxtSBAfLN9ps7SVcOW8Eihwp5/rI7B+6Y2O3BcS/UvDlj2XmSZ86L4UvtV+M+1mvlgiJN9vLWG54GYpz4zi+x2e1xFCV7vipG1y7hMRtEVBUgRMQL5U3bzQ1vPzm9IjY65R1gyPiCZtp5bja7upq2YFY9w+xKTJAoOSZ/pq4AlXzKfpO2Io0tsWO/1VnMdkTdRqS0zPcvY47sR5gi/WcwBn3GlKG4/n5fRSI5Ev67yc/mN4Qcxv48WhzNK1q0+9CrTsa0UASIh4Cx71IVyhNPlB1/EOMZGPmFhYQhAOkJguk44PiTrIwZKjE8R3+uMM+Lt0+YwEogZni1qIFwztPkCjRAkfUjyalUJAD/1qbhawC6c7AF5OqhW82OVNNZmhYa8BKvHoBjKDAbjxLtTDU6eca6iStbHf8VUgPeC/jshcBcJryaEBLFrjPyLp353IhxV04uS0DznsLZSyZxUqaiv27Y16T7gol3e2UKOnpxpCBpIX2FhyC7zVm2tIv8WSKX03zp20+Q0lXxqDXV5oi1sZNsO0f2n8RVc9VUlFsXyRckAnT71zN4spmy9fJv1ABrABgz8icqdcj5z9WpklPEtbQ+DVEBfoILsuxalXK0YhLkPd1Wy5nQmdFrsOX3hbW7oxE0g4LliCchfk5uCh8c4nJ924xinkfF4XsxjRv75slu++mXtosKVof7AA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2230.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199015)(6506007)(7696005)(83380400001)(38070700005)(2906002)(71200400001)(86362001)(110136005)(54906003)(186003)(26005)(9686003)(316002)(41300700001)(53546011)(5660300002)(52536014)(8936002)(76116006)(64756008)(66446008)(122000001)(66946007)(33656002)(66476007)(66556008)(55016003)(82960400001)(966005)(478600001)(8676002)(4326008)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?akloU1RtTFJybnZreFFzRXEzdldXSkU0TFEzeW90eVQ4NGx2OXBra1V6cm9L?=
 =?utf-8?B?RFFvbTAzR1dtQ2ZWeUpDMHlpNGNSajdxSXdabmQySXl0UWl6VU9SbGVCZ0J3?=
 =?utf-8?B?bzc0OWc1dHErcmdlQzVoNXR4YlYrRUEramNGNHBmK3ROM2NzcFhNSkpqcGZC?=
 =?utf-8?B?aXZHZ05ZaGEzUzFCOHM0YlhORnZ0bms1OHoray9VNytPeHM2RGJLMm92end2?=
 =?utf-8?B?YjNWM2hHRlB6Z2NLOTF5TDM3OWFIWlh1dmYxZEQ1VUJ0ZVcwSURSZk8vUGIz?=
 =?utf-8?B?aFI2QzVBa3hjcEhhbGpvdldlOG1IN3NFMGZpbzh5NkpjbjJaWm1qcVY5bDA5?=
 =?utf-8?B?TkV0ZWhQRC9NY0ptK1lPYXJrY3JNaUxqeHBYWkdMaTNLeWNLWFJYK2JDTHl4?=
 =?utf-8?B?ZGlwR1NuYW8zczFFR2w4aFZjeXdGOXEwQzByTUMxelM5SkZlWVgyK1dDVkJR?=
 =?utf-8?B?dG5vbXcyK0hDV01seS9teGptdG9VVkcwNStMTlBJbE1mdzg1WFZ2WTd6QnIv?=
 =?utf-8?B?bWx2azJXNVRlaXgxU3RzREdxaFVuaWh5WTNUU2tiOEVRdmlqaEsvNGVKZlV0?=
 =?utf-8?B?WG05YmtiUm9VTzUvNmxtQ29xYU9KOUtNc0NnZTVoYlRNbHRreGJycDF5andl?=
 =?utf-8?B?SUY0eXVTM2UvcnFnK1gwT0JRSXpkV20rTndOZzRYWGxRM0VIWlpNWDQzODZk?=
 =?utf-8?B?aHl0ZWtQOUZndWFsSXRWNGlzRWpiUSttU0xsMVBYSSs1OVozNkNZd09tY3dr?=
 =?utf-8?B?bHhYa0dDekRoVTQrazNaMGYvN0Faa2oxSUxzS2k5ZHMwR01JQTFMdjNtZUQ5?=
 =?utf-8?B?cUJCSHRTTFhYYzNpNUUrbDhHOERFQTBzd2d6MmFTTDA0VVJjc3Qxa0s3eXF2?=
 =?utf-8?B?OWNsY0pLQTBjdVg1OHhzWHpENzQ0emdObFFLSVJrU0VSL3dXWWRpRTd0ajMw?=
 =?utf-8?B?dmxaQjhpRjEySFRhbzBYSXdGdDRRSUY0ZmdybjdNQTNvOHlsanozZkI5U0x3?=
 =?utf-8?B?elBiSVNGeCtkY0VUWm9idFVyeXR3V0hyZ1pOaGRnTStIVmE0SDFJWURETEZz?=
 =?utf-8?B?Y0JESjk0TGJZNHR1ME1zaUIxS0tucEtPMEFaMnloaDhuY3M4T3FpWkR6VWlU?=
 =?utf-8?B?UXRzeUt6WGlqUWpqalAwT2p5SVJmajlLRkRVMWljbGhuNzMwS3M2MTlNRFA2?=
 =?utf-8?B?V2laOEJmaTZFYkdxNisrQVV0MURicGFDR2RSZDZManVlbWprQmhXdHREbWZv?=
 =?utf-8?B?ODN3eWVTby9GT0RkVVM2Y250OWJPa3c3SHNSSGRCRU9SMWlBUUxYWEpjT05Q?=
 =?utf-8?B?TDJDM2hrbjBBbGI1b2NzOHh5cE1Ienc1bjVubm5sdkx0WVhTK2hlZC9TK2Ja?=
 =?utf-8?B?M3dyUzYrSnc4VmFLVEk3dDJUL0d0Qm5oZHVnM0Q1VjM5SHRyQi9CTmFPZ0hH?=
 =?utf-8?B?bHJjRFBndE8vbkVucW9tcUl2YkI3b2srd0w3MnhneTFtYlI5UWxGckVZblZJ?=
 =?utf-8?B?QjFSSG9mM3ZuOXptVzU1S0ZPOGcvWVVEeWo4clRMSWhMcXFlTm5lQ2Y0a0dK?=
 =?utf-8?B?Y0EwRTF2S1lwemJoRHpwcUI0aDZWQmNNU00wcDhsaktvcWlFYTJTWjlBN0NZ?=
 =?utf-8?B?TTNldFArOUxYRGpLU3pYNkxZak1HbGU2NkJYZWZ5OUtWbDh0VGlra3FzNzZs?=
 =?utf-8?B?eVZqUm5iOE50V3gxU3NMWnZjZDhqbmpRWmRhLzhRZ3R2L0hhRU9vMzAwVE8v?=
 =?utf-8?B?b09SYWpUcVRyMWdBVkgzQm5rWm01bGNRR0lnZFErWTdMbWpnSGNwOExMMEt6?=
 =?utf-8?B?ZWtsejl0eTBmamUzWUVlYnN6aExTb2ZmTTgyR044aytoR1VLNjVYU3lpNVlq?=
 =?utf-8?B?alphcFFHR1I1Yzl4d0drb29MbnpUZWpFQngyOFZrQWhtQnoxclU5aThWaTZ5?=
 =?utf-8?B?MUJpbXZDYzhJYmsvc01pU3V0dC9Xa2JtTEVwOW5CdGhRUStyZHJuUGFmaWZn?=
 =?utf-8?B?S0NCMTIrSzczb2lPT29SVGZxM2Jra1I4M1RuNjlFUTdPb25lQnJqK1laMFdh?=
 =?utf-8?B?NG9YM0gyTTVySkptdlVZU21USzRBQUdqSkJjSE9MaWJObER5TlpvcnRCai9k?=
 =?utf-8?Q?fClFvnsgmSXCMGWAZj4YYQU1r?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2230.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d3a30c7-5f55-4e84-c781-08dad75be562
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2022 07:31:31.6485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 45g64Mxznry/JPQ9NjfaG0oReBCrGRBbbaGxWaLaMaro5TxGUpQOFf6x7wnOowMlHdfxLyQJs9W8pW2XP1NS2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7243
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMjAyMi8xMi8zIDIxOjUzLCBZaSBMaXUgd3JvdGU6DQo+IE9uIDIwMjIvMTIvMyAwNzoxMiwg
QWxleCBXaWxsaWFtc29uIHdyb3RlOg0KPj4gT24gRnJpLCAyIERlYyAyMDIyIDEwOjQ0OjMwIC0w
NDAwDQo+PiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPiB3cm90ZToNCj4+DQo+Pj4g
T24gRnJpLCBEZWMgMDIsIDIwMjIgYXQgMDk6NTc6NDVQTSArMDgwMCwgWWkgTGl1IHdyb3RlOg0K
Pj4+PiBPbiAyMDIyLzEyLzIgMDQ6MzksIEphc29uIEd1bnRob3JwZSB3cm90ZToNCj4+Pj4+IE9u
IFRodSwgRGVjIDAxLCAyMDIyIGF0IDA2OjU1OjI1QU0gLTA4MDAsIFlpIExpdSB3cm90ZToNCj4+
Pj4+PiBXaXRoIHRoZSBpbnRyb2R1Y3Rpb24gb2YgaW9tbXVmZFsxXSwgVkZJTyBpcyB0b3dhcmRp
bmcgdG8gcHJvdmlkZSANCj4+Pj4+PiBkZXZpY2UgY2VudHJpYyB1QVBJIGFmdGVyIGFkYXB0aW5n
IHRvIGlvbW11ZmQuIFdpdGggdGhpcyB0cmVuZCwgDQo+Pj4+Pj4gZXhpc3RpbmcgVkZJTyBncm91
cCBpbmZyYXN0cnVjdHVyZSBpcyBvcHRpb25hbCBvbmNlIFZGSU8gY29udmVydGVkIHRvIGRldmlj
ZSBjZW50cmljLg0KPj4+Pj4+DQo+Pj4+Pj4gVGhpcyBzZXJpZXMgbW92ZXMgdGhlIGdyb3VwIHNw
ZWNpZmljIGNvZGUgb3V0IG9mIHZmaW9fbWFpbi5jLCANCj4+Pj4+PiBwcmVwYXJlcyBmb3IgY29t
cGlsaW5nIGdyb3VwIGluZnJhc3RydWN0dXJlIG91dCBhZnRlciBhZGRpbmcgdmZpbyANCj4+Pj4+
PiBkZXZpY2UgY2RldlsyXQ0KPj4+Pj4+DQo+Pj4+Pj4gQ29tcGxldGUgY29kZSBpbiBiZWxvdyBi
cmFuY2g6DQo+Pj4+Pj4NCj4+Pj4+PiBodHRwczovL2dpdGh1Yi5jb20veWlsaXUxNzY1L2lvbW11
ZmQvY29tbWl0cy92ZmlvX2dyb3VwX3NwbGl0X3YxDQo+Pj4+Pj4NCj4+Pj4+PiBUaGlzIGlzIGJh
c2VkIG9uIEphc29uJ3MgIkNvbm5lY3QgVkZJTyB0byBJT01NVUZEIlszXSBhbmQgbXkgDQo+Pj4+
Pj4gIk1ha2UgbWRldiBkcml2ZXIgZG1hX3VubWFwIGNhbGxiYWNrIHRvbGVyYW50IHRvIHVubWFw
cyBjb21lIA0KPj4+Pj4+IGJlZm9yZSBkZXZpY2Ugb3BlbiJbNF0NCj4+Pj4+Pg0KPj4+Pj4+IFsx
XQ0KPj4+Pj4+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8wLXY1LTQwMDFjMjk5N2JkMCsz
MGMtaW9tbXVmZF9qZ2dAbnZpDQo+Pj4+Pj4gZGlhLmNvbS8NCj4+Pj4+Pg0KPj4+Pj4+IFsyXSAN
Cj4+Pj4+PiBodHRwczovL2dpdGh1Yi5jb20veWlsaXUxNzY1L2lvbW11ZmQvdHJlZS93aXAvdmZp
b19kZXZpY2VfY2Rldg0KPj4+Pj4+IFszXQ0KPj4+Pj4+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L2t2bS8wLXY0LTQyY2QyZWIwZTNlYiszMzVhLXZmaW9faW9tbXVmZF9qDQo+Pj4+Pj4gZ2dAbnZp
ZGlhLmNvbS8NCj4+Pj4+Pg0KPj4+Pj4+IFs0XQ0KPj4+Pj4+IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2t2bS8yMDIyMTEyOTEwNTgzMS40NjY5NTQtMS15aS5sLmxpdUBpbnRlDQo+Pj4+Pj4gbC5j
b20vDQo+Pj4+Pg0KPj4+Pj4gVGhpcyBsb29rcyBnb29kIHRvIG1lLCBhbmQgaXQgYXBwbGllcyBP
SyB0byBteSBicmFuY2ggaGVyZToNCj4+Pj4+DQo+Pj4+PiBodHRwczovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9qZ2cvaW9tbXVmZC5naXQvDQo+Pj4+Pg0KPj4+Pj4g
QWxleCwgaWYgeW91IGFjayB0aGlzIGluIHRoZSBuZXh0IGZldyBkYXlzIEkgY2FuIGluY2x1ZGUg
aXQgaW4gdGhlIA0KPj4+Pj4gaW9tbXVmZCBQUiwgb3RoZXJ3aXNlIGl0IGNhbiBnbyBpbnRvIHRo
ZSB2ZmlvIHRyZWUgaW4gSmFudWFyeQ0KPj4+Pj4NCj4+Pj4+IFJldmlld2VkLWJ5OiBKYXNvbiBH
dW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPj4+Pg0KPj4+PiB0aGFua3MuIGJ0dy4gSSd2ZSB1
cGRhdGVkIG15IGdpdGh1YiB0byBpbmNvcnBvcmF0ZSBLZXZpbidzIG5pdCBhbmQgDQo+Pj4+IGFs
c28gci1iIGZyb20geW91IGFuZCBLZXZpbi4NCj4+Pg0KPj4+IFBsZWFzZSByZWJhc2UgaXQgb24g
dGhlIGFib3ZlIGJyYW5jaCBhbHNvDQo+DQo+IFRvIEphc29uOiBkb25lLiBQbGVhc2UgZmV0Y2gg
ZnJvbSBiZWxvdyBicmFuY2guDQo+DQo+IGh0dHBzOi8vZ2l0aHViLmNvbS95aWxpdTE3NjUvaW9t
bXVmZC9jb21taXRzL2Zvci1qYXNvbi92ZmlvX2dyb3VwX3NwbGkNCj4gdA0KDQpUZXN0ZWQgTklD
IHBhc3N0aHJvdWdoIG9uIEludGVsIHBsYXRmb3JtIHdpdGggYWJvdmUgYnJhbmNoIChDb21taXQg
aWQ6IGJmNDQ1ZTY3NDdiNTg4YTc3NGY1ZTQ1ZjJjOWUwY2RhYTMxNDBkN2MpLiANClJlc3VsdCBs
b29rcyBnb29kIGhlbmNlLA0KVGVzdGVkLWJ5OiBMaXhpYW8gWWFuZyA8bGl4aWFvLnlhbmdAaW50
ZWwuY29tPg0KDQoNCj4+IEl0IGxvb2tzIGZpbmUgdG8gbWUgYXNpZGUgZnJvbSB0aGUgcHJldmlv
dXMgcmV2aWV3IGNvbW1lbnRzIGFuZCBteSANCj4+IG93biBzcGVsbGluZyBuaXQuICBJIGFsc28g
ZG9uJ3Qgc2VlIHRoYXQgdGhpcyBhZGRzIGFueSBhZGRpdGlvbmFsIA0KPj4gY29uZmxpY3RzIHZz
IHRoZSBleGlzdGluZyBpb21tdWZkIGludGVncmF0aW9uIGZvciBhbnkgb3V0c3RhbmRpbmcgDQo+
PiB2ZmlvIHBhdGNoZXMgb24gdGhlIGxpc3QsIHRoZXJlZm9yZSwgd2hlcmUgdGhlcmUncyBub3Qg
YWxyZWFkeSBhIHNpZ24tb2ZmIGZyb20gbWU6DQo+Pg0KPj4gUmV2aWV3ZWQtYnk6IEFsZXggV2ls
bGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+DQo+IFRvIEFsZXg6IHRoYW5r
cy4gYWJvdmUgYnJhbmNoIGlzIGJhc2VkIG9uIEphc29uJ3MgZm9yLW5leHQuIFNvIG1heSANCj4g
aGF2ZSBvbmUgbWlub3IgY29uZmxpY3Qgd2l0aCBiZWxvdyBjb21taXQgaW4geW91ciBuZXh0IGJy
YW5jaC4NCj4NCj4gdmZpbzogUmVtb3ZlIHZmaW9fZnJlZV9kZXZpY2UNCg0KQmVzdCByZWdhcmRz
LA0KTGl4aWFvIFlhbmcNCg==
