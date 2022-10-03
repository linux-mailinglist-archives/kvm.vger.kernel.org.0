Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E705F3661
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 21:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiJCTfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 15:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiJCTfb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 15:35:31 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59D31B795
        for <kvm@vger.kernel.org>; Mon,  3 Oct 2022 12:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664825728; x=1696361728;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ISmMLu0fq/M231Ide+0PranDDPjqk4z6QvYqRIRqygg=;
  b=Tdv0Rnm9dMs/rWiWPNbQJzQzQiEOolfz21f89z1rraUwUPQuqnk8CCrm
   FdUFEDPs57jxUnQvXLueHUgt/SoPk3uuj0dWFgvjglOtfKlV+wxqCWvnR
   EP3Ugg+/njdHAQ9JNIGsl+ISjBuU/tlBMbeZykFuP9+QSvU7FKSTe3dwZ
   QHuVKW6woZTQdMKCYd5abTRO09aLz5F0lUebQ7WY2lIYj8j6WfIPKJg68
   lK6cbeaBjvoOgptxDv8YKBTu692lz0VTaD5M7vtGpZBPIoXi7KticA1+V
   fWI4zHzRzKCMjzGBEeETfSUugPPvn7O/cEfAhRNn3MmwXDWws38NtLhPN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="300344414"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="300344414"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 12:35:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="712750053"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="712750053"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Oct 2022 12:35:17 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 12:35:17 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 12:35:17 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 3 Oct 2022 12:35:17 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 3 Oct 2022 12:35:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8kHHiCcFpxA2Sbm6CRYrJlG2SMie3os30gyamlm2kn3IxGlmvklrbmro3/2B1dMqYuOfBZAkqigKauLT1x1a1AbH4iVfTeBixJQEmVtr43h5dkqPaV1XshphYLmFp5sGmuDdC0FBbJcng/e1sQKtl8DUFMvqGUznX5TGANu5meJhKYZhPtujt74nVdJ1oyi833hrcNBy1E2m9mZ5QJVNTE+43P03XKWvbfCudjZnu9q68GjOBrrv4O5qEIml7OxM7pKCrJo8y0Ct97b13FqBT7Zko2EWJny2AVwi6Y5+yzfOEUB7Xx0o76LeB4DfGJN+P2TmQEUhwyR/YmhZZk2jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISmMLu0fq/M231Ide+0PranDDPjqk4z6QvYqRIRqygg=;
 b=D4NJR6THhPXdl4VKV8S5Wei0HbVO9dZ2DlMCjy83xkr57UL/nKfJZ9rJ4jpKY/O5Itsw3oqZ1qdEcaz0KRTcHmDGrTQd10wRG0Eg6GCjt/NUlZzFrENqw5jiVN1eO9QkQdRLtjiIBAsV7KS/q3UO1J0W8dz80FG1XhXCm3nW6yiz3qlvKyyRoPnZeGWTCeVWcrr5bZBz2Rwpa1YRt4VwuydHnr/NM/ASEFQrlvI89g2dHOASq/ZLbEei27Kd2fGtD9iLEh7rG6t68dQTOSlozC3q4F5Ye1mhlOfnh2XqB7p9YIV8ETYSJEuMUDlp3ithWEnT21zjOtHuKeUOnBqZ5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3042.namprd11.prod.outlook.com (2603:10b6:208:78::17)
 by PH0PR11MB4984.namprd11.prod.outlook.com (2603:10b6:510:34::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Mon, 3 Oct
 2022 19:35:13 +0000
Received: from BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::b52e:e73e:ac99:8a5]) by BL0PR11MB3042.namprd11.prod.outlook.com
 ([fe80::b52e:e73e:ac99:8a5%3]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 19:35:13 +0000
From:   "Dong, Eddie" <eddie.dong@intel.com>
To:     Jim Mattson <jmattson@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: RE: [PATCH 2/6] KVM: x86: Mask off reserved bits in CPUID.80000006H
Thread-Topic: [PATCH 2/6] KVM: x86: Mask off reserved bits in CPUID.80000006H
Thread-Index: AQHY1FYuEs8BAKsu5UCBOzB/nmNIY634etfwgAAg0oCAAAmBoIAADbaAgARdgAA=
Date:   Mon, 3 Oct 2022 19:35:13 +0000
Message-ID: <BL0PR11MB3042784D7E66686207D679268A5B9@BL0PR11MB3042.namprd11.prod.outlook.com>
References: <20220929225203.2234702-1-jmattson@google.com>
 <20220929225203.2234702-2-jmattson@google.com>
 <BL0PR11MB304234A34209F12E03F746198A569@BL0PR11MB3042.namprd11.prod.outlook.com>
 <CALMp9eSMbLy8mETM6SRCbMVQFcKQRm=+qfcH_s1EhV=oF656eQ@mail.gmail.com>
 <BL0PR11MB30421511435BFEF36E482AC28A569@BL0PR11MB3042.namprd11.prod.outlook.com>
 <CALMp9eTNeeCNt=xMFBKSnXV+ReSXR=D11BQACS3Gwm7my+6sHA@mail.gmail.com>
In-Reply-To: <CALMp9eTNeeCNt=xMFBKSnXV+ReSXR=D11BQACS3Gwm7my+6sHA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3042:EE_|PH0PR11MB4984:EE_
x-ms-office365-filtering-correlation-id: c573a5ae-ec49-4d15-1055-08daa576642b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gMq90E3c5tE182gmgEjvuUsrbckVUeDCKasMtILEoIjzM0HELNT/vCDdcG+sLhZ95eH+yFU/2Cxcovv8ftfrO80o322vy9N0Rao3CWNTZpwA5CkIHSpz9BonvXvIxrlyuQgJZYPjE+aGDbeeXY1w6Hgc0jGMwhZTqdvxbjEyIlTJRCCUu7XhhisJ4N2atFVZE7bZoYn9ebEUbu+6xInXLsRLwpA160qWkbeW5BshzHYC2u7e4U9FxLX+DMY2c7+tUpjSv0DBMHiMKT4XK3s8AQVXFsLltaE3cYVd4n99IiGHvPonzxtanmN04E0GUyAspf/95yoEFqTxxBbUh8PAGpGOEgaPrU4tc8/XJ5rRJzMBDZE6LnyUVURR6Q5quh14Pd0ZW3Lz/t6Dk8dCDgaViqXWAXVXTDv4zwMWntUnH3+fyjtPAiNo3IeF/iq0XADObpjwl2wFwB6I5W0ufMgsPqmkbgYovwGBkJ7a7eq1wBDYMyiMkK2pYarByRns9EAd5dnxuywggSMmrT0RbrzCUt4McRw6ubXeyOInsOfRijw1+GdGWMg5qgJt1smoz9iMvocgljp0+2q4sXUE2+ZEvSkBoGUvh8L4zUgodUT4lXh5/ufnU+88ojo2c23NrNiIRypcnH9wLED0h7jYsacjoopMq2gK6qKE9Sr0nLWaD5RaoGJuOvnU9YsjRzL77YpsKsSMypy5+2DXgN0NJ21MdQZJhZ8y8MHFV2CUV3vtsIyqRLGUjTnR3gl5xb645ZNLIH5fxo6q2z90Fnfgbpk28bU+LaIw5Q8Zbh4x4FFKAUw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3042.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(396003)(346002)(366004)(376002)(451199015)(4326008)(66946007)(66446008)(66476007)(76116006)(8676002)(64756008)(66556008)(54906003)(6916009)(26005)(7696005)(9686003)(6506007)(186003)(33656002)(316002)(122000001)(38070700005)(2906002)(5660300002)(8936002)(82960400001)(38100700002)(41300700001)(86362001)(83380400001)(52536014)(55016003)(966005)(71200400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TmlqV1dFYUhiclpweCsyV21JZG5mTHQxWXoxZXN6Zk9pUUoyejZsdzQ2SDhZ?=
 =?utf-8?B?Mm9zTHBhR3YvTEpIbkVScTJDTE81VnZ5MXN5S2FybUpoMEdqSTBhazNyZzdM?=
 =?utf-8?B?SHplTzRTUHpsMTRvRWt6N3liUmVxRDlHQTZHOUNZQkxTN1VyZ0dQNzhuSkIr?=
 =?utf-8?B?ZjlNK1E1OVFJU2t4UXBHczJwUHZmL1M5anBQZnlPWE5VemdyRHA2ajRDYld2?=
 =?utf-8?B?VXpjemJ3VkZEV0lpeWp3cWU0dWpyZXlIUmdHYXlFcFJwbDRXWXozeUhsdEw5?=
 =?utf-8?B?R0FQTDhOVXgxODZFR0JLY0o4enpMQmZSUExhVUFVWHBJbG5CMlIweUsvNHBV?=
 =?utf-8?B?cGJ1ZXp3MXhhUjN4d0djVWltS3lxWkhUMHpETm1aT0w0V3ZkRnlVdzNFWjBv?=
 =?utf-8?B?Y3hUUHJPQ3pWNk96TmovRVlCQ3dOaXE3cDE3THk1b0VlcFZtYmhmM1RjMnZO?=
 =?utf-8?B?YzlYdTZFTk9Pb3RWR3RCanQ0V1pDd3pDRGJ0cTBueFFWTGFySC9KeUFZclNH?=
 =?utf-8?B?OGppTnJPZ1hvcXcrUlpSeGJIeGlKa1R3aHdIOWRGWi9lT3pOakRjQi9RYm5v?=
 =?utf-8?B?ZlZYZGZra0NTR0tZV1FJZGdlckxiWmNYSUZOL0doMk1rYWtQUzFMdmFZRnpC?=
 =?utf-8?B?N0tGZGR3T1ozeklyaUxtNWhwOVhQNjBoNnIrbTJQK09tbHd6TlQydmFhOVdJ?=
 =?utf-8?B?YmtzTVExdE5HREorVTU3ZmVDS2xreWdKVnlvTk5CUVZKanpoUXBLVlcwTjNY?=
 =?utf-8?B?WnJMcjcxa1NWaFJSUHR0MHZjYUNKS2Vad0YvOXZmTENUN1p0T0FuVWZjVlND?=
 =?utf-8?B?UDkwYzlZU1o5dlNKazFkMjc2ZXNGS0RTeUcrc2pSNk1NWFJVbm1BMUliSUNs?=
 =?utf-8?B?Q1VweFVYZXZ6K2VzeHU2OU1oMStXMjRXb3BKSFgxSTBqSVI4Z2hnNWJTRmRG?=
 =?utf-8?B?MjZVUC9wSUU4cXI1aCt2akthaUt3MkYrR0pMdjBVOGk0ZnhPdlBsaTczWVV0?=
 =?utf-8?B?TkhtSFV6T04yaUFzSENaZ1MrWFNIRCt5NStRcU4wNE9xa1BqZENRL0NJUHp1?=
 =?utf-8?B?STRzVGgyOVVhMHdOVWoxY0Z2UHRFRWdxZmovQVZ6VURBNTNUb1g2MzVuOUlN?=
 =?utf-8?B?d2VhSHhPSTRtVUJNbS9wKzVhWWtTOHI0RTVIZUJ3bnN2clMzWVFNQTVZRWtP?=
 =?utf-8?B?TGF2ZldJelJ4Ri9pODhwQVJJb2o4SXhlVnQvSkF4ZDB5ek83eldsWWcrSHZs?=
 =?utf-8?B?YWVuL3NDaThUdUhsL1ZRUGlRSWhJUXZrRDdkNEsrOUw5d3dLLzc2YW4xZ2Y2?=
 =?utf-8?B?ZVlIdzVUVDl0RnJiTzhzNlVqVmNETlF0R0ZDTXRsNGxKTURPVWhjVytwSEEx?=
 =?utf-8?B?WkFpZEVsSzBUTTh5Y2VpTTRpRFJDMFZtTDEvQ1pTRWxkZm0wMmtjNFRrVHdE?=
 =?utf-8?B?cWRwZlUyZkNlbTFWTTRZSmFJYS9UK3NaOFIzSk5FWWpwa2FUclBFU0U3WVho?=
 =?utf-8?B?UFRnRTI5QzJyczRERkxHMldkRHBHc2wxNlloV3NQUzFRQ3IzeE5tR0xnbmRr?=
 =?utf-8?B?cXEzQ0E2RVNoMUFFUG1WSFNCbS9McmhhMEZncTJTb2ZhWlJpM1VpdUJQQncr?=
 =?utf-8?B?NTAyVjJhellWdGNuNW53dTFqb0RjZEYyVnpmZ2IxQVV3TFFoQ2lhbEEvZ29R?=
 =?utf-8?B?NDcwTHZFTWVVYjBWbmFlTGJsV1dsU0lja01GSGU4R01Jd2JmbUJQQXZ6UmFL?=
 =?utf-8?B?akFmWmVtUHY4TDdIZnpqWUZoaVZnL0lid0ZlSHluYlgzYkswbGEyWk9mWW5a?=
 =?utf-8?B?MnQ5NmNiOU4wN1VxOWM5eTBrWmJiclhYc1ZGVGM1QTI0OG1xQUE3Skl1QzlC?=
 =?utf-8?B?SVlNanRUSHpVdEhlVkltaUppTlMrWVJUNk5pL3pjRjErTzB2bzVhd0FYVWV6?=
 =?utf-8?B?c2JwTWhaQnBJbWRIMEp2M1h1SzBhR1B0MHhUS3lUYTBUdFZVWHpIOHdMdkhY?=
 =?utf-8?B?MnFDOFowTXNvTytsU3NmZXM0ZllrckhocGN2a2VNZ0xHSjk1eDY2cG9UamJS?=
 =?utf-8?B?Q1pFc3R4b0dyTUQrb0xqWER1cWpEWTYwMDU4YXNHUUUzRUtvUmRkaUt5N20v?=
 =?utf-8?Q?YuHuzlytDS9/lAwF1GNA8NzB1?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3042.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c573a5ae-ec49-4d15-1055-08daa576642b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 19:35:13.1301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QMPINoEY0tpiJb64lCi3QkiJjfqmLrRFJlp+QuVbS8RkthbCx29TMa0+rq9yZ+sCCj445JtAoszf3vMKxKLa4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4984
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+DQo+ID4gSW4gdGhpcyBjYXNlLCBnaXZlbiB0aGlzIGlzIHRoZSBjb21tb24gcGxhY2UsICBp
ZiB3ZSBkb24ndCB3YW50IHRvIGRvDQo+IGNvbmRpdGlvbmFsbHkgZm9yIGRpZmZlcmVudCBYODYg
YXJjaGl0ZWN0dXJlIChtYXkgYmUgbm90IG5lY2Vzc2FyeSksIGNhbiB5b3UNCj4gcHV0IGNvbW1l
bnRzIHRvIGNsYXJpZnk/DQo+ID4gVGhpcyB3YXksIHJlYWRlcnMgd29uJ3QgYmUgY29uZnVzZWQu
DQo+IA0KPiBXaWxsIGEgc2luZ2xlIGNvbW1lbnQgYXQgdGhlIHRvcCBvZiB0aGUgZnVuY3Rpb24g
c3VmZmljZT8NCg0KU28sIHdlIGFyZSBoYW5kbGluZyBhcmNoaXRlY3R1cmUtc3BlY2lmaWMgY29k
ZSBpbiBhcmNoaXRlY3R1cmUtY29tbW9uIHBhdGguDQpOb3Qgc3VyZSBob3cgaXQgd2lsbCBpbXBh
Y3Qgb3RoZXJzLg0KDQpUaGUgaWRlYSBzb2x1dGlvbiB3aWxsIGhhdmUgdG8gcmVzaHVmZmxlIGl0
IGZvciBkaWZmZXJlbnQgYXJjaGl0ZWN0dXJlIHRvIGJlIHByb2Nlc3NlZCBkaWZmZXJlbnRseS4N
Cg0KDQo+IA0KPiA+DQo+ID4gPg0KPiA+ID4gPiBCVFcsIGZvciB0aG9zZSByZXNlcnZlZCBiaXRz
LCB0aGVpciBtZWFuaW5nIGlzIG5vdCBkZWZpbmVkLCBhbmQNCj4gPiA+ID4gdGhlIFZNTQ0KPiA+
ID4gc2hvdWxkIG5vdCBkZXBlbmQgb24gdGhlbSBJTU8uDQo+ID4gPiA+IFdoYXQgaXMgdGhlIHBy
b2JsZW0gaWYgaHlwZXJ2aXNvciByZXR1cm5zIG5vbmUtemVybyB2YWx1ZT8NCj4gPiA+DQo+ID4g
PiBUaGUgcHJvYmxlbSBhcmlzZXMgaWYvd2hlbiB0aGUgYml0cyBiZWNvbWUgZGVmaW5lZCBpbiB0
aGUgZnV0dXJlLA0KPiA+ID4gYW5kIHRoZSBmdW5jdGlvbmFsaXR5IGlzIG5vdCB0cml2aWFsbHkg
dmlydHVhbGl6ZWQuDQo+ID4NCj4gPiBBc3N1bWUgdGhlIGhhcmR3YXJlIGRlZmluZXMgdGhlIGJp
dCBvbmUgZGF5IGluIGZ1dHVyZSwgaWYgd2UgYXJlIHVzaW5nIG9sZA0KPiBWTU0sIHRoZSBWTU0g
d2lsbCB2aWV3IHRoZSBoYXJkd2FyZSBhcyBpZiB0aGUgZmVhdHVyZSBkb2Vzbid0IGV4aXN0LCBz
aW5jZQ0KPiBWTU0gZG9lcyBub3Qga25vdyB0aGUgZmVhdHVyZSBhbmQgdmlldyB0aGUgYml0IGFz
IHJlc2VydmVkLiBUaGlzIGNhc2Ugc2hvdWxkDQo+IHdvcmsuDQo+IA0KPiBUaGUgVk1NIHNob3Vs
ZCBiZSBhYmxlIHRvIHNpbXBseSBwYXNzIHRoZSByZXN1bHRzIG9mDQo+IEtWTV9HRVRfU1VQUE9S
VEVEX0NQVUlEIHRvIEtWTV9TRVRfQ1BVSUQyLCB3aXRob3V0IG1hc2tpbmcgb2ZmIGJpdHMNCj4g
dGhhdCBpdCBkb2Vzbid0IGtub3cgYWJvdXQuDQoNCkF0IGxlYXN0IGluIEludGVsIGFyY2hpdGVj
dHVyZSwgYSByZXNlcnZlZCBiaXQgKGhhcmR3YXJlIHJldHVybiAiMSIpIHJlcG9ydGVkIGJ5IEtW
TV9HRVRfU1VQUE9SVEVEX0NQVUlEIGNhbiBiZSBzZXQgaW4gS1ZNX1NFVF9DUFVJRDIuIA0KRnJv
bSBLVk0gcC5vLnYuLCBJIHRoaW5rIHdlIGRvbid0IGFzc3VtZSB0aGUgcmVzZXJ2ZWQgYml0IChz
ZXQgYnkgS1ZNX1NFVF9DUFVJRDIpIG11c3QgYmUgMC4gIE9yIEkgbWlzc2VkIHNvbWV0aGluZz8N
Cg0KPiANCj4gTm9uZXRoZWxlc3MsIGEgZnV0dXJlIFZNTSB0aGF0IGRvZXMga25vdyBhYm91dCB0
aGUgbmV3IGhhcmR3YXJlIGZlYXR1cmUNCj4gY2FuIGNlcnRhaW5seSBleHBlY3QgdGhhdCBhIEtW
TSB0aGF0IGVudW1lcmF0ZXMgdGhlIGZlYXR1cmUgaW4NCj4gS1ZNX0dFVF9TVVBQT1JURURfQ1BV
SUQgaGFzIHRoZSBhYmlsaXR5IHRvIHN1cHBvcnQgdGhlIGZlYXR1cmUuDQoNClRha2luZyBuYXRp
dmUgYXMgZXhhbXBsZSwgYSBuZXcgYXBwbGljYXRpb24ga25vd3MgYWJvdXQgdGhlIG5ldyBoYXJk
d2FyZSBmZWF0dXJlLCBzaG91bGQgYmUgYWJsZSB0byBydW4gb24gb2xkIGhhcmR3YXJlIHdpdGhv
dXQgdGhlIGZlYXR1cmUsIGV2ZW4gaWYgdGhlIG9sZCBoYXJkd2FyZSByZXBvcnQgdGhlIHJlc2Vy
dmVkIGJpdCBhcyAiMSIuDQpUaGlzIGlzIHVzdWFsbHkgZ3VhcmFudGVlZCBieSB0aGUgaGFyZHdh
cmUgdmVuZG9yIGluIHNwZWNpZmljYXRpb24gZGVzaWduLiAgSSB3aWxsIGRvdWJsZSBjaGVjayB3
aXRoIEludGVsIGhhcmR3YXJlIGd1eXMgdG8gc2VlIGlmIGFueSAicmVzZXJ2ZWQgYml0cyIgb2Yg
Q1BVSUQgbWF5IHJlcG9ydCAiMSIuDQoNClZNTSBpbiB0aGlzIGNvbnRleHQgc2hvdWxkIGJlIGFi
bGUgdG8gZm9sbG93IHRoZSBwcmluY2lwbGUgdG9vLg0KDQo+IA0KPiA+IElmIHdlIHJ1biB3aXRo
IHRoZSBmdXR1cmUgVk1NLCB3aGljaCByZWNvZ25pemVzIGFuZCBoYW5kbGVzIHRoZQ0KPiBiaXQv
ZmVhdHVyZS4gVGhlIFZNTSBjb3VsZCB2aWV3IHRoZSBoYXJkd2FyZSBmZWF0dXJlIHRvIGJlIGRp
c2FibGVkIC8gbm90DQo+IGV4aXN0ZWQgKGlmICIxIiBpcyB1c2VkIHRvIGVuYWJsZSBvciBzdGFu
ZCBmb3IgImhhdmluZyB0aGUgY2FwYWJpbGl0eSIpLCBvciB2aWV3DQo+IHRoZSBoYXJkd2FyZSBm
ZWF0dXJlIGFzIGVuYWJsZWQvIGV4aXN0ZWQgKGlmICIwIiBpcyB1c2VkIHRvIGVuYWJsZSBvciBz
dGFuZCBmb3INCj4gImhhdmluZyB0aGUgY2FwYWJpbGl0eSIpLg0KPiA+DQo+ID4gSW4gdGhpcyBj
YXNlLCB3aGV0aGVyIHdlIGhhdmUgdGhpcyBwYXRjaCBkb2VzbuKAmXQgZ2l2ZSB1cyBkZWZpbml0
ZSBhbnN3ZXIuIEFtDQo+IEkgcmlnaHQ/DQo+IA0KPiBBcmUgeW91IGFza2luZyBhYm91dCB0aGUg
cG9sYXJpdHkgb2YgdGhlIENQVUlEIGJpdD8NCj4gDQo+IEl0IGlzIHVuZm9ydHVuYXRlIHRoYXQg
Ym90aCBJbnRlbCBhbmQgQU1EIGhhdmUgc3RhcnRlZCB0byBkZWZpbmUgcmV2ZXJzZQ0KPiBwb2xh
cml0eSBDUFVJRCBiaXRzLCBiZWNhdXNlIHRoZXNlIGRvLCBpbiBmYWN0LCBjYXVzZSBhIGZvcndh
cmQgY29tcGF0aWJpbGl0eQ0KPiBpc3N1ZS4gVGFrZSwgZm9yIGV4YW1wbGUsIEFNRCdzIHJlY2Vu
dCBpbnRyb2R1Y3Rpb24gb2YNCj4gQ1BVSUQuODAwMDAwMDhIOkVCWC5FZmVyTG1zbGVVbnN1cHBv
cnRlZFtiaXQgMjBdLiBXaGVuIHRoZSBiaXQgaXMgc2V0LA0KPiBFRkVSLkxNU0xFIGlzIG5vdCBh
dmFpbGFibGUuIEZvciBxdWl0ZSBzb21lIHRpbWUsIEtWTSBoYXMgYmVlbiByZXBvcnRpbmcNCj4g
dGhhdCB0aGlzIGZlYXR1cmUgKmlzKiBhdmFpbGFibGUgb24gQ1BVcyB3aGVyZSBpdCBpc24ndCwg
YmVjYXVzZSBLVk0gY2xlYXJlZA0KPiB0aGUgQ1BVSUQgYml0IGJhc2VkIG9uIGl0cyBwcmV2aW91
cyAncmVzZXJ2ZWQnIGRlZmluaXRpb24uIEkgaGF2ZSBhIHNlcmllcyBvdXQgdG8NCj4gYWRkcmVz
cyB0aGF0IGlzc3VlOg0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vQ0FMTXA5ZVEtDQo+
IHFrakJtOHFQaE9hTXpaTFdlSEpjcndrc1YrWExROURmT1FfaTFheWtxUUBtYWlsLmdtYWlsLmNv
bS8uDQoNClRoaXMgY2FzZSBpcyBkaWZmZXJlbnQuIEl0IGlzIGJlY2F1c2UgdGhlIG5ldyBoYXJk
d2FyZSBjb252ZXJ0cyBhIGRlZmluZWQgYml0IHRvIGJlIHJlc2VydmVkLiAgV2hhdCB3ZSBhcmUg
dGFsa2luZyBoZXJlIGlzIHRvIGNvbnZlcnQgYSByZXNlcnZlZCBiaXQgdG8gZGVmaW5lZCBiaXQu
DQoNCkluIHRoaXMgY2FzZSwgaWYgb25lIHdhbnRzIHRvIHJlbW92ZSB0aGUgY2FwYWJpbGl0eSAo
aWYgaXQgaXMgcHJlc2VudGVkIGFuZCBydW4gb24gb2xkIHBsYXRmb3JtKSwgdG8gTDEgVk0uIFRo
YXQgaXMgZGVmaW5pdGVseSBmaW5lLg0KQnV0IGV4dGVuZGluZyB0aGlzIHRvIHZhc3RseSBjb3Zl
ciBhbGwgcmVzZXJ2ZWQgYml0cyBvZiBDUFVJRCBsZWFmIG1heSBiZSB0b28gYWdncmVzc2l2ZSwg
YW5kIGNhdXNlIHRoZSBmdXR1cmUgaXNzdWVzLg0KDQpJIHdpbGwgbGV0IHlvdSBrbm93IGlmIHRo
ZSByZXNlcnZlZCBiaXRzIG9mIENQVUlEIGluIEludGVsIGFyY2hpdGVjdHVyZSBtYXkgcmVwb3J0
ICIxIi4gSWYgdGhpcyBpcyB0cnVlLCB3ZSBtYXkgaGF2ZSB0byBoYW5kbGUgdGhlbSBkaWZmZXJl
bnRseSBmb3IgZGlmZmVyZW50IGFyY2hpdGVjdHVyZSwgaS5lLiBJbnRlbCB2cy4gQU1ELg0KDQpX
aWxsIHRoYXQgbWFrZSBzZW5zZT8NCg0KPiANCj4gSW50ZWwgZGlkIHRoZSBzYW1lIHRoaW5nIHdp
dGgNCj4gQ1BVSUQuKEVBWD03SCxFQ1g9MCk6RUJYLkZEUF9FWENQVE5fT05MWVtiaXQgNl0gYW5k
DQo+IENQVUlELihFQVg9N0gsRUNYPTApOkVCWC5aRVJPX0ZDU19GRFNbYml0IDEzXS4NCj4gDQo+
IEluIHRoZSB2YXN0IG1ham9yaXR5IG9mIGNhc2VzLCBob3dldmVyLCAnMCcgaXMgdGhlIHJpZ2h0
IHZhbHVlIHRvIHJlcG9ydCBmb3IgYQ0KPiByZXNlcnZlZCBiaXQgdG8gZW5zdXJlIGZvcndhcmQg
Y29tcGF0aWJpbGl0eS4NCg0KVGhhbmtzIEVkZGllDQo=
