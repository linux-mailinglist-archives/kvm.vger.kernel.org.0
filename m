Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8DD6AFC23
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 02:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjCHBUq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 20:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjCHBUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 20:20:44 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16AC38EA5;
        Tue,  7 Mar 2023 17:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678238442; x=1709774442;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zyxu9mjMxCnrrFf3/518PJPmg35c4xsoQ8AU3eTMxTo=;
  b=MPkiSQtpiXUwP5pf2DS8YAyPdgT0BJz/VOCsXzl7MCx9ibiAPbtt+ATX
   qz0puom3AR3L9nTHSl3jTY/H6N+XA3/kORJV+zm8PB5wxZOvYA3E4MMWz
   n970ZsJpphiP59ntARzxwhTO0260JGRzZRJ9hegSSPJAPaqd1TvfkShSW
   7tHScNbStnIAx69E+clQNYyh3AbvOoSPLQg5vTrEurvhicyzIUYvYaioP
   bnMYKvJ7kOjkbXgUdfH9HSW4NV+ern6B+w+jo+/Pd3Iz5TzMtbfeY/0f/
   hA9uPpCt5YT3WpwnssoSvaBvSex63pFYOiL/L881JiAQU3dwjpycZR1ns
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="316422171"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="316422171"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 17:20:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="850905384"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="850905384"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 07 Mar 2023 17:20:40 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 17:20:40 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 17:20:40 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 7 Mar 2023 17:20:40 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 7 Mar 2023 17:20:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNKkuHF9tEcKf2OTOLyV6mVSHt/za377nwWF6UbfAOGuxRXzAtomtHdS/yyAI+rnPjvQv7USdfPdfXQh5S8haC1coUNxg/mH59CDMklIml22sAmQZLiqqblgc9WzJF0Fj1zLAkzcJVAKzIHwJ23yp2UjBSgEe00woAlnZxIFV2CFMxkEF706TS77SxuhmFzVotdZ3EdCgTUaydCsafGc50VG5gQQWlyVldE34KX7iIY3aFXu8IATBE+/LdH3+17HJBcEgWIr3Uyyd6q1ra2l0y0c2i9bziAmhm7deHrlDwqvazErdU7usW4+dJKqYWoqaRhCltZm2T/aEx2HD1ahyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zyxu9mjMxCnrrFf3/518PJPmg35c4xsoQ8AU3eTMxTo=;
 b=nq3r66F5PtXszDKJfAKTfwPrp9AxEi8wMooVrGEqgIduvnRRt9fNYF4Ncfe0N5mG/a4CnbaAg+7o/UpRACuQSoRL+xFOkL5pWre8QBxcJCMT7M+66S+VqqUpLKck/irOaI6MaRFP8JAF9SOUN8SLu7mD5D55dGEuLIlCKpsro9Nafxhd+8c0yGrGmWlWNV30H4dhDJkGX1TgIaQOrJRUu6x9GekcuHcsbcPN6JRAWJ5HpR1G6diiYCbBcegxRhPwAIJ+FaRCJ3vQZSgLbcZFkmRT8T/ZNSz+PRhx27tcUi3SlS046deDRt+2M8WRzE3ObP5rznPN/LCAeGmvGUYV3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ1PR11MB6108.namprd11.prod.outlook.com (2603:10b6:a03:489::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Wed, 8 Mar
 2023 01:20:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 01:20:32 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH] KVM: VMX: Make setup_vmcs_config() preemption disabled
Thread-Topic: [PATCH] KVM: VMX: Make setup_vmcs_config() preemption disabled
Thread-Index: AQHZTCxXkF4K+ZZqtEaRiCI/5s8D/a7m+acAgAAzBoCACGx9gIAAhtOA
Date:   Wed, 8 Mar 2023 01:20:32 +0000
Message-ID: <d1cdbb7aed99f325355a28dbed02346f4c4d7b16.camel@intel.com>
References: <20230301105438.599196-1-kai.huang@intel.com>
         <ZAA1+EMTIkBJvdZF@gao-cwp>
         <3aec157afb6727e603d80c2232b3718033295f13.camel@intel.com>
         <ZAdxNgv0M6P63odE@google.com>
In-Reply-To: <ZAdxNgv0M6P63odE@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ1PR11MB6108:EE_
x-ms-office365-filtering-correlation-id: 78447fe2-fbcf-4466-a1c6-08db1f734fda
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8ltxCx31H0iSdVMzvLHY5KF9Q8xpLV/vjD4fZIZW0/+VEogmr2hFNA3J+3o+3zyDe7cSikm3F5eyeZnSxZGt86990rGWF5K2c9SMZU5phjlm+BNySnSDCpq4zKr+Gzz9IFiYYkSvt8HUg/W/N51A1YQTXA0c7Dbw8dg5qTT8b3wQ+gjaRZIhwVtfw8+cm0FadXOIrKo8BQZQTPZb3kB+D5r3dwa+YSkK9L1oeL00Dj9mAIoRWFWz7BvS7IdmxDRjEDltd9NE1QJxbIwPEUIZ/TR3L09pagtA3DUJ87Q8DLsrgTaQRnYFy3bC7vfNvv7bAaALrtrrMQl/xCclod55K70Q6iFIzyrhX+NXIipuX9Fyn/Kx07QHfb0QpEzv5NisC5yRzSRvAZgpmu7Goa9JQ6RPpOrSvuI2XBEbsVDpONno2YL6HU6h9yzcJ3xNanjjnj2O1VU+JdaIHpBlbw2quQQ41eBB3bfHS0quA8FzI0zqCA7kKA7bkTxdTJS20b44RdV32eeRo0n+FljueCdvRIfm5VQJZnKuTp71hWpAJA6w5taGSiheC6uiworkw5Xh+2HVpPLuvVqgUrX+9L6lBVo1sBW1Kc//zukNKwwKebSHQaMp5ddjYqejTLUO8hsoybgGXIE9dZnjz1zB3wHN1bUtbg+nrssAy5Pe5QSXNpYEjUvl20yBsTSzT7rpvVWDL4/VvawRJkoXl9TgvTgA1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199018)(64756008)(186003)(91956017)(122000001)(38100700002)(38070700005)(4326008)(8676002)(66946007)(66476007)(478600001)(66556008)(2906002)(76116006)(41300700001)(82960400001)(5660300002)(26005)(8936002)(6916009)(71200400001)(107886003)(6506007)(66446008)(6512007)(2616005)(36756003)(316002)(86362001)(83380400001)(54906003)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QnNvNnJjaVRjZzJjUldtbmNVWDNxWTA1bzQ1dzFBT25PYURvc253WjdzQlpS?=
 =?utf-8?B?aWRHanRvd08xbEhlSysweGpJUU5NcGJMMWFRRm15NXZpUzdodEJBb09HMlIz?=
 =?utf-8?B?T3hZcjBIUEhDUldYc21TVjNMY3RVKzh2VXMvdHp3dlo2MWhBMzI4cEpnemdI?=
 =?utf-8?B?UU1ibnFYUUpGbisweTREUmJjc3BySGk5L3VsMnFjb3pBWkFsWFlaWithOWZr?=
 =?utf-8?B?NzZ6WE1zWW5VbkdYVDd4WTF1T01IRVl1VEtPWXFHTUt1eXI0WjEvMkh2aXVW?=
 =?utf-8?B?VDdVWjNOcTlXYWZ3b1o1MVVhbW96alJ3anlXNGNkVSsyNXhxNXAvNGVDcmV2?=
 =?utf-8?B?NkVDTEdtclJDdENxRHE0a2pVQ01Ud08yTXdUbC9DcUo5ZDdCOGJadVNhNHhH?=
 =?utf-8?B?elhGVVdrbzA4aFBMOXFGbWVUamVLVWFxYU9iVmlXaDBzdVZVQkNsd0FzYWRV?=
 =?utf-8?B?Mmo5MkJMOTE3NUFDN25WM0dkOHlnL0twWDFIS2dHYWpJMlBCdDRmdFQzWFJw?=
 =?utf-8?B?VC94blNyaWJGQld6Zk56U2JhQ0QxQnppbTYxR3VTQndqU0dQdGZKWDlxQXA4?=
 =?utf-8?B?RmMzUktEeVpaQk1tYXBycDZHTDBEZlk1S1F5SDE0dWJoRFRRZStwSWdNR1Qr?=
 =?utf-8?B?ZTRLVWdOYWFsQjJYZ2VPbzk5QjMybDdhTk1RckpucXlWckV6UXJDd1NORXA5?=
 =?utf-8?B?bE1vbUVhMGdxUEREdCtLWkwyK25CNTh2N3VPNXlwb3lzOXpBdnE4ZVJYcVNI?=
 =?utf-8?B?V1RwdnZwZWJrbklxaFljZVViYXJQUTdFaFlOcGppQkZUTmJuMWl5aThMb2RQ?=
 =?utf-8?B?RGN6dmZYRzd5QUhCZ0hPMFJPTzJ5V201YmxZTkkxWEowODRLZEdHanZsMUhN?=
 =?utf-8?B?U0Zrc0hKQnRtcFIwVGxHdklMVE50MnAxWnVRbUc0eDVwdEp5VmV5b29EVlp3?=
 =?utf-8?B?NlE4UVdYMkgrcUR6NmlVc2FBamVheHYyeHdBZjZ6dXFNZjNTOVZMc0N3VHVL?=
 =?utf-8?B?SUp1dlJlTDBWNWpKemtjdy9JN3gycm9hSkJRMHRtYUVRTE5Vem1INHdMbXg0?=
 =?utf-8?B?Q05XYjRvTytBbXpWcU5HT3FIV1l6WGJ2UnB1cDEyYmc3RlZHbVIyNEx0dkRx?=
 =?utf-8?B?UXc1THZSSWJ0ajM0SkoyQzFtWWlqaTRlZkNDZ2NMSnUyd3NMcXI5TzBHYTNB?=
 =?utf-8?B?RmVtTm9reVBaTGlrODlKRHZXZFdJM2F3dTA0K3psWitqelBKWU1tWE8rbWlm?=
 =?utf-8?B?bm5wb01nVEx6RnZUMG5OSmxBelV5VWlQOGJMc25Za29GamVTRGllZDRQdnVk?=
 =?utf-8?B?d0tXT25QZ2FqNERJUytDMm8wMUJhRzlZS1JJeUpIV1BYRjB1SWZ3a3ppTzE0?=
 =?utf-8?B?aStOWFNQcnNPYTA5MHR6VWl4ZW11NFJrR0pFT0xJK1RnQTh6RHZJNFJkQmxJ?=
 =?utf-8?B?bkxkeDM3WDkzdEtwOW9vSjVWNVVEMlFac3E2NlhpZk43T2VQblRqVHBldmt1?=
 =?utf-8?B?WkY4cnBZdVk1QXhDSmdRUi80M0I1SXZLV0FWWllLaXpBNThwN3lxcDlXZ29Z?=
 =?utf-8?B?NlNoSDIrRXZCNXZ3WVdsai9JUEZPdzRKbFdsQzArMUVoRlh1UzhzUDRUdTR4?=
 =?utf-8?B?ZXhOaEprdVQraERLSEYxcm5RUHlCdFRRK0Fhb3RKam0vWDQwakZpcHgrbkpH?=
 =?utf-8?B?bkhmamNFUzQrMmJSNnk1d0YrNGFrOC9UL1A5R01GOUtyd3lvQmRjenoxOENW?=
 =?utf-8?B?cmg3clR1RHhhQTU5b3g0eGNLVUJtSHQxS01wTjhmakFRaHFmZTNQT05iWEdv?=
 =?utf-8?B?bER6MnFlb05McmtCRG85WGVjcmJVY0k0a1RLcE5LOGZ3UHlrOHBwTWJaUnFR?=
 =?utf-8?B?bTRWVXUzY1V1VWRtWTF2blY2WnhHNitWQVZJOEh3Z01UZ1NCZDg2cGtRVFdE?=
 =?utf-8?B?eXFZaVRyNVRIbmVSQndQaWMxbnptY29yUDlnK3gzWGV2cFFBcUxYdkd1SVZx?=
 =?utf-8?B?cWlzZlVUZ2dyWTh3MlBTK1BqWDBtK3JuZG1rL3p2M25OVUVJbmdvOWhtNjBz?=
 =?utf-8?B?dkhTdkRyVGVZS0t5ZXUycFpwT215aENjWnpwQVdUbUpMS3ZkWWlCQUsyZDFw?=
 =?utf-8?B?dm1YdytOQ3N0RjN1UUw0anRvcTZDNDZTbXFyc3pqSXNqbXlOdURkNjl0M0pa?=
 =?utf-8?B?S2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A59D61667FF60143B5D99ED9EAB786E5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78447fe2-fbcf-4466-a1c6-08db1f734fda
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2023 01:20:32.4017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zGaALl7Kj8jyu/MHzFCO/Vjq5G5B9922v765UWxlyGz5dKUz9muBcV8Vux53vqICmo2g8ERwdI8pkpVv1mMmvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6108
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAzLTA3IGF0IDA5OjE3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIE1hciAwMiwgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBU
aHUsIDIwMjMtMDMtMDIgYXQgMTM6MzYgKzA4MDAsIEdhbywgQ2hhbyB3cm90ZToNCj4gPiA+IE9u
IFdlZCwgTWFyIDAxLCAyMDIzIGF0IDExOjU0OjM4UE0gKzEzMDAsIEthaSBIdWFuZyB3cm90ZToN
Cj4gPiA+ID4gTWFrZSBzZXR1cF92bWNzX2NvbmZpZygpIHByZWVtcHRpb24gZGlzYWJsZWQgc28g
aXQgYWx3YXlzIHBlcmZvcm1zIG9uDQo+ID4gPiA+IHRoZSBzYW1lIGxvY2FsIGNwdS4NCj4gPiA+
ID4gDQo+ID4gPiA+IER1cmluZyBtb2R1bGUgbG9hZGluZyB0aW1lLCBLVk0gaW50ZW5kcyB0byBj
YWxsIHNldHVwX3ZtY3NfY29uZmlnKCkgdG8NCj4gPiA+ID4gc2V0IHVwIHRoZSBnbG9iYWwgVk1D
UyBjb25maWd1cmF0aW9ucyBvbiBfb25lXyBjcHUgaW4gaGFyZHdhcmVfc2V0dXAoKSwNCj4gDQo+
IFRoYXQgbWF5IGhhdmUgYmVlbiB0aGUgdmVyeSBvcmlnaW5hbCBpbnRlbnRpb24sIGJ1dCBJIGRv
bid0IHRoaW5rIGl0IGhhcyBiZWVuIHRoZQ0KPiB0cnVlIGludGVudGlvbiBmb3IgYSB2ZXJ5IGxv
bmcgdGltZS4NCg0KV29uZGVyaW5nIHdoYXQncyB0aGUgY3VycmVudCBpbnRlbnRpb24/DQoNCj4g
DQo+ID4gPiA+IENoYW5nZSB0aGUgZXhpc3Rpbmcgc2V0dXBfdm1jc19jb25maWcoKSB0byBfX3Nl
dHVwX3ZtY3NfY29uZmlnKCkgYW5kDQo+ID4gPiA+IGNhbGwgdGhlIGxhdHRlciBkaXJlY3RseSBp
biB0aGUgY29tcGF0aWJpbGl0eSBjaGVjayBjb2RlIHBhdGguICBDaGFuZ2UNCj4gPiA+ID4gc2V0
dXBfdm1jc19jb25maWcoKSB0byBjYWxsIF9fc2V0dXBfdm1jc19jb25maWcoKSB3aXRoIHByZWVt
cHRpb24NCj4gPiA+ID4gZGlzYWJsZWQgc28gX19zZXR1cF92bWNzX2NvbmZpZygpIGlzIGFsd2F5
cyBkb25lIG9uIHRoZSBzYW1lIGNwdS4NCj4gPiA+IA0KPiA+ID4gTWF5YmUgeW91IGNhbiBzaW1w
bHkgZGlzYWJsZSBwcmVlbXB0aW9uIGluIGhhcmR3YXJlX3NldHVwKCkgYWx0aG91Z2ggSQ0KPiA+
ID4gZG9uJ3QgaGF2ZSBhIHN0cm9uZyBwcmVmZXJlbmNlLg0KPiA+ID4gDQo+ID4gPiBuZXN0ZWRf
dm14X3NldHVwX2N0bHNfbXNycygpIGFsc28gcmVhZHMgc29tZSBNU1JzIGFuZCBzZXRzIHVwIHBh
cnQgb2YNCj4gPiA+IHZtY3NfY29uZiwgc2hvdWxkIGl0IGJlIGNhbGxlZCBvbiB0aGUgc2FtZSBD
UFUgYXMgc2V0dXBfdm1jc19jb25maWcoKT8NCj4gPiANCj4gPiBZZXMgSSB0aGluayBzby4gIEkg
bWlzc2VkIHRoaXMgOikNCj4gPiANCj4gPiBOb3Qgc3VyZSB3aGV0aGVyIHRoZXJlIGFyZSBvdGhl
ciBzaW1pbGFyIHBsYWNlcyB0b28gZXZlbiBvdXRzaWRlIG9mDQo+ID4gaGFyZHdhcmVfc2V0dXAo
KS4NCj4gPiANCj4gPiBCdXQgY29tcGF0aWJpbGl0eSBjaGVjayBvbmx5IGNoZWNrcyB0aGluZ3Mg
Y2FsY3VsYXRlZCB2aWEgc2V0dXBfdm1jc19jb25maWcoKQ0KPiA+IGFuZCBuZXN0ZWRfdm14X3Nl
dHVwX2N0bHNfbXNycygpLCBzbyBJIHRoaW5rIGl0J3MgZmFpciB0byBvbmx5IHB1dA0KPiA+IGhh
cmR3YXJlX3NldHVwKCkgaW5zaWRlIHByZWVtcHRpb24gZGlzYWJsZWQuDQo+IA0KPiBEaXNhYmxp
bmcgcHJlZW1wdGlvbiBhY3Jvc3MgaGFyZHdhcmVfc2V0dXAoKSBpc24ndCBmZWFzaWJsZSBhcyB0
aGVyZSBhcmUgYSBudW1iZXINCj4gb2YgYWxsb2NhdGlvbnMgdGhhdCBtaWdodCBzbGVlcC4gIEJ1
dCBkaXNhYmxpbmcgcHJlZW1wdGlvbiBpc24ndCBuZWNlc3NhcnkgdG8NCj4gZW5zdXJlIHNldHVw
IHJ1bnMgb24gb25lIENQVSwgdGhhdCBvbmx5IHJlcXVpcmVzIGRpc2FibGluZyBfbWlncmF0aW9u
Xy4gIFNvIF9pZl8NCj4gd2Ugd2FudCB0byBoYW5kbGUgdGhpcyBpbiB0aGUga2VybmVsLCB3ZSBj
b3VsZCBzaW1wbHkgZG86DQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4Ni5jIGIv
YXJjaC94ODYva3ZtL3g4Ni5jDQo+IGluZGV4IDU0MTk4MmRlNTc2Mi4uOTEyNmZkZjAyNjQ5IDEw
MDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3g4
Ni5jDQo+IEBAIC05NDcwLDcgKzk0NzAsOSBAQCBpbnQga3ZtX3g4Nl92ZW5kb3JfaW5pdChzdHJ1
Y3Qga3ZtX3g4Nl9pbml0X29wcyAqb3BzKQ0KPiAgICAgICAgIGludCByOw0KPiAgDQo+ICAgICAg
ICAgbXV0ZXhfbG9jaygmdmVuZG9yX21vZHVsZV9sb2NrKTsNCj4gKyAgICAgICBtaWdyYXRlX2Rp
c2FibGUoKTsNCj4gICAgICAgICByID0gX19rdm1feDg2X3ZlbmRvcl9pbml0KG9wcyk7DQo+ICsg
ICAgICAgbWlncmF0ZV9lbmFibGUoKTsNCj4gICAgICAgICBtdXRleF91bmxvY2soJnZlbmRvcl9t
b2R1bGVfbG9jayk7DQo+ICANCj4gICAgICAgICByZXR1cm4gcjsNCj4gDQo+IA0KPiBCdXQgSSdt
IG5vdCBjb252aW5jZWQgd2Ugc2hvdWxkIGhhbmRsZSB0aGlzIGluIHRoZSBrZXJuZWwuICBNYW55
IG9mIHRoZSBjaGVja3MsDQo+IGVzcGVjaWFsbHkgaW4gU1ZNLCBxdWVyeSBib290X2NwdV9oYXMo
KSwgbm90IHRoaXNfY3B1X2hhcygpLCBpLmUuIHRvIHRydWx5IHBlcmZvcm0NCj4gc2V0dXAgb24g
YSBzaW5nbGUgQ1BVLCBhbGwgb2YgdGhvc2Ugd291bGQgbmVlZCB0byBiZSBjb252ZXJ0ZWQgdG8g
dGhpc19jcHVfaGFzKCkuDQo+IA0KPiBTb21lIG9mIHRob3NlIGJvb3RfY3B1X2hhcygpIGNhbGxz
IHNob3VsZCBiZSBjaGFuZ2VkIHJlZ2FyZGxlc3Mgb2Ygd2hldGhlciBvciBub3QNCj4gbWlncmF0
aW9uIGlzIGRpc2FibGVkLCBlLmcuIGt2bV9pc19zdm1fc3VwcG9ydGVkKCkgaXMgYXJndWFibHkg
c3RyYWlnaHQgdXAgYnVnZ3kNCj4gZHVlIHRvIGNwdV9oYXNfc3ZtKCkgY2hlY2tpbmcgdGhlIGJv
b3QgQ1BVIChJJ2xsIGZpeCB0aGF0IGJ5IGFkZGluZyBhIHBhdGNoIGFmdGVyDQo+IG9wZW4gY29k
aW5nIGNwdV9oYXNfc3ZtKCkgaW50byBrdm1faXNfc3ZtX3N1cHBvcnRlZCgpWypdKS4NCj4gDQo+
IEJ1dCB0aGluZ3MgbGlrZSBrdm1fdGltZXJfaW5pdCgpIHNob3VsZCBOT1QgYmUgYmxpbmRsZ2x5
IGNvbnZlcnRlZCB0byB0aGlzX2NwdV9oYXMoKSwNCj4gYmVjYXVzZSB0aGUgdGVhcmRvd24gcGF0
aCBuZWVkcyB0byBtaXJyb3IgdGhlIHNldHVwIHBhdGgsIGUuZy4gaWYgS1ZNIGVuZGVkIHVwDQo+
IHJ1bm5pbmcgb24gZnJhbmtlbnN0ZWluIGhhcmR3YXJlIHdoZXJlIG5vdCBhbGwgQ1BVcyBoYXZl
IGEgY29uc3RhbnQgVFNDLCBLVk0gY291bGQNCj4gbGVhdmUgYSBjYWxsYmFjayBkYW5nbGluZyBh
bmQgaG9zZSB0aGUga2VybmVsLiAgT2J2aW91c2x5IHN1Y2ggaGFyZHdhcmUgd291bGRuJ3QNCj4g
Y29ycmVjdGx5IHJ1biBWTXMsIGJ1dCBjcmFzaGluZyB0aGUga2VybmVsIGlzIGEgdG91Y2ggd29y
c2UgdGhhbiBLVk0gbm90IHdvcmtpbmcNCj4gY29ycmVjdGx5Lg0KPiANCj4gSSdtIG5vdCB0b3Rh
bGx5IGFnYWluc3QgY29udmVydGluZyB0byB0aGlzX2NwdV9oYXMoKSBmb3IgdGhlIHNldHVwLCBh
cyBpdCB3b3VsZCBiZQ0KPiBtb3JlIGludHVpdGl2ZSBpbiBhIGxvdCBvZiB3YXlzLiAgQnV0LCBJ
IGRvbid0IHRoaW5rIHBpbm5pbmcgdGhlIHRhc2sgYWN0dWFsbHkNCj4gaGFyZGVucyBLVk0gaW4g
YSBtZWFuaW5nZnVsIHdheS4gIElmIHRoZXJlIGFyZSBhbnkgZGl2ZXJnZW5jZXMgYmV0d2VlbiBD
UFVzLCB0aGVuDQo+IGVpdGhlciBLVk0gd2lsbCBub3RpY2UgYmVmb3JlIHJ1bm5pbmcgVk1zLCBl
LmcuIHRoZSBWTUNTIHNhbml0eSBjaGVja3MsIG9yIEtWTSB3aWxsDQo+IG5ldmVyIG5vdGljZSwg
ZS5nLiB0aGUgbXlyaWFkIHJ1bnRpbWUgcGF0aHMgdGhhdCBjaGVjayBib290X2NwdV9oYXMoKSAo
b3IgdmFyaWFudHMNCj4gdGhlcmVvZikgd2l0aG91dCBzYW5pdHkgY2hlY2tpbmcgYWNyb3NzIENQ
VXMuICBBbmQgaWYgdXNlcnNwYWNlIF9yZWFsbHlfIHdhbnRzIHRvDQo+IGhhdmUgZ3VhcmFudGVl
cyBhYm91dCBob3cgc2V0dXAgaXMgcGVyZm9ybWVkLCBlLmcuIGZvciByZXBlYXRhYmxlLCBkZXRl
cm1pbmlzdGljDQo+IGJlaGF2aW9yLCB0aGVuIHVzZXJzcGFjZSBzaG91bGQgZm9yY2UgbG9hZGlu
ZyBvZiBLVk0gdG8gYmUgZG9uZSBvbiBDUFUwLg0KDQpNeSBpbnRlbnRpb24gaXMgbmV2ZXIgZm9y
IHVzZXJzcGFjZSwgYnV0IHNpbXBseS9wdXJlbHkgZnJvbSBjb21wYXRpYmlsaXR5DQpjaGVjaydz
IHBvaW50IG9mIHZpZXcgKHNlZSBiZWxvdykuICBBbHNvLCBJIGRvbid0IHRoaW5rIHVzZXJzcGFj
ZSB3YW50cyB0bw0KZ3VhcmFudGVlIGFueXRoaW5nICAtLSBpdCBqdXN0IHdhbnRzIHRvIGxvYWQg
dGhlIEtWTSBtb2R1bGUuICBJdCdzIGV2ZW4gYXJndWFibGUNCnRoYXQgaXQgbWF5IGJlIGFuIGFj
Y2VwdGFibGUgYmVoYXZpb3VyIHRvIGZhaWwgdG8gcnVuIGFueSBWTSBldmVuIGxvYWRpbmcgbW9k
dWxlDQp3YXMgc3VjY2Vzc2Z1bC4NCg0KPiANCj4gU28gbXkgdm90ZSBpcyB0byBsZWF2ZSB0aGlu
Z3MgYXMtaXMgKG1vZHVsbyB0aGUgY3B1X2hhc19zdm0oKSBtZXNzKS4gIEJ1dCBtYXliZSBhZGQN
Cj4gZG9jdW1lbnRhdGlvbiB0byBleHBsYWluIHRoZSBjYXZlYXRzIGFib3V0IGxvYWRpbmcgS1ZN
LCBhbmQgaG93IHVzZXJzcGFjZSBjYW4NCj4gbWl0aWdhdGUgdGhvc2UgY2F2ZWF0cz8NCg0KSSBt
YWRlIHRoaXMgcGF0Y2ggYmVjYXVzZSBJIGhhdmUgc29tZSBvdGhlciBwYXRjaGVzIHRvIG1vdmUg
Vk1YT04gc3VwcG9ydCBvdXQgb2YNCktWTSBpbiBvcmRlciB0byBzdXBwb3J0IFREWCwgYnV0IHNv
IGZhciB0aG9zZSBwYXRjaGVzIGFyZSBub3QgaW5jbHVkZWQgaW4gdGhhdA0Kc2VyaWVzIChhbmQg
SSdkIGxpa2UgdG8gbGVhdmUgaXQgb3V0IGlmIHdlIHJlYWxseSBkb24ndCBuZWVkIGl0KS4NCg0K
SW4gdGhlIHBhdGNoIHRvIG1vdmUgVk1YT04gb3V0IG9mIEtWTSwgSSBjaGFuZ2VkIHRvIHVzZSBw
ZXItY3B1IHZhcmlhYmxlIHRvDQpjYWNoZSB0aGUgTVNSX0lBMzJfVk1YX0JBU0lDIHZhbHVlIGFu
ZCBzZXR1cCB0aGUgVk1YT04gcmVnaW9uIHdoZW4gb25lIENQVSBpcw0KYmVjb21pbmcgb25saW5l
LiAgQW5kIHNldHVwX3ZtY3NfY29uZmlnKCkgaXMgY2hhbmdlZCB0byB1c2UgX190aGlzX2NwdV9y
ZWFkKCkgdG8NCnJlYWQgdGhlIHBlci1jcHUgTVNSIHZhbHVlIGluc3RlYWQgb2YgcmVhZGluZyBm
cm9tIGhhcmR3YXJlLiAgT2J2aW91c2x5IHcvbw0KcHJlZW1wdF9kaXNhYmxlKCkgb3Igc2ltaWxh
ciBfX3RoaXNfY3B1X3JlYWQoKSBjYW4gcmVwb3J0IGtlcm5lbCBidWc6DQoNCiAgICAgICAgcHJp
bnRrKEtFUk5fRVJSICJCVUc6IHVzaW5nICVzJXMoKSBpbiBwcmVlbXB0aWJsZSBbJTA4eF0gY29k
ZTogJXMvJWRcbiIsDQogICAgICAgICAgICAgICAgd2hhdDEsIHdoYXQyLCBwcmVlbXB0X2NvdW50
KCkgLSAxLCBjdXJyZW50LT5jb21tLCBjdXJyZW50LT5waWQpOw0KDQpUaGF0IGJlaW5nIHNhaWQs
IEkgYW0gZmluZSB0byBrZWVwIGV4aXN0aW5nIGNvZGUsIGV2ZW4gdy9vIGRvY3VtZW50aW5nLiAg
V2UgY2FuDQpkaXNjdXNzIG1vcmUgaG93IHRvIGhhbmRsZSB3aGVuIHdlIHJlYWxseSB3YW50IHRv
IG1vdmUgVk1YT04gb3V0IG9mIEtWTSAoaS5lLg0Kc3VwcG9ydGluZyBURFggSU8/KS4NCg0KT3Ig
d2UgY2FuIGp1c3QgZml4IGNvbXBhdGliaWxpdHkgY2hlY2sgcGFydD8gIEZvciBpbnN0YW5jZSwg
bW92ZQ0Kc2V0dXBfdm1jc19jb25maWcoKSBhbmQgbmVzdGVkX3ZteF9zZXR1cF9jdGxzX21zcnMo
KSB0b2dldGhlciBpbg0KaGFyZHdhcmVfc2V0dXAoKSBhbmQgY2FsbCBwcmVlbXB0X2Rpc2FibGUo
KSBhcm91bmQgdGhlbT8NCg0KDQo=
