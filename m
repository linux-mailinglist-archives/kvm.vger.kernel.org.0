Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 498BA6D72A2
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 05:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236799AbjDEDFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 23:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236706AbjDEDFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 23:05:22 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426DD4209;
        Tue,  4 Apr 2023 20:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680663920; x=1712199920;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gAiQ1d0+LgQrnGyCNHmTyvm02fBWwWlOyqyESM2U9QU=;
  b=CVONDQx4RYbMQO86kFVl2rZDO2lsKR7+ACVb943Qn0DgcXxtPTPZ/IG5
   WUvvvsnuRt+cXVy8djQ3bLwRXfcb4JW16Pgy2ka00f7NZyWZ2hnXu3GII
   Q+ZaqBiM45wryWy+zTk2FAU4DPqwsVFhnn2UGeXfY2EpeBY61YhqMM6EM
   3MOfeGvk2LgnB2QT2sEl3sooGqOf0WsUrfOCIHVea4HhtoXk7A8phrk3G
   pb/PfyjOgVs4fC7/959x/Pp/19WnttXAvbRk+oaXSEsa/D8+95sShEodx
   wqQ4hHZzaidn1gxBNln2Sl30+4nVTsUQOtwSeMlmSxVIpojXHa6U0Zmy7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="341081629"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="341081629"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 20:05:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="1016316741"
X-IronPort-AV: E=Sophos;i="5.98,319,1673942400"; 
   d="scan'208";a="1016316741"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 04 Apr 2023 20:05:14 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 20:05:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 4 Apr 2023 20:05:14 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 4 Apr 2023 20:05:14 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 4 Apr 2023 20:05:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VddojMZzxtoba/nPlveWWOSw3QZxYtvFM8E22+7QwmeEGoF3VAAiRoaJYNRga0Twi9f3OzbPYRuq2ddKtSVKLqEbXZOVpVJECuXCxOB3KCjE7ksdISCfG9j5neHZ9IxCxMt2TZ+EnbtbeeRg0OPFWh9mp5moZTMLw+SiCotgUBQNuELUiRTqh7RKf7X1IwxPbMmtXikdc46qYx8lWeiY4yctg0cTHJqN9NoOPAxBkwidSuEopygL8navNqo+8b/NF/oLIvJkRuzT7C1vkRGFDJO9aCr0n2wujn/IQLqsvMWzlWoQlCrtFKhFLuMd6ouCiT6Pajl4486R7A0gnYKUYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gAiQ1d0+LgQrnGyCNHmTyvm02fBWwWlOyqyESM2U9QU=;
 b=hao3wl53Um+ucoKIKr8vHbLnPwkMFix+CORIiwqTy18tkgic69j3/i7SfhQr6WmsjQlDzGco861jbB/i0LPZyb2pRuftkL4J1eVJfZZZEk7DmDshL3DdfaSxLeF+Ybn4xcgPVu8Njf/Pb4D09IHjUgpxWKCQIQoJUAdslDN+T/6UnsPD4lD+JGspwnOs4YeF/hgGvJWr6SsNaYn6FZD4RU/nlCrC9+pW5Id06RhxJtEkyYo6PgUfOfhnYRs6MNaFpXctddkn9wupFVSkQZ9V9RX0mrNuCkTtdTzkXYrjgiJ0EURwVJMgtdbbJlZQiPoSnnX7Jyatsq8oXzHArUjv9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB6003.namprd11.prod.outlook.com (2603:10b6:208:387::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 03:05:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6254.033; Wed, 5 Apr 2023
 03:05:10 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] KVM: x86: SGX vs. XCR0 cleanups
Thread-Topic: [PATCH 0/3] KVM: x86: SGX vs. XCR0 cleanups
Thread-Index: AQHZZ1neAPY41R6lzkG8Mkf04T1Dpq8cCB6A
Date:   Wed, 5 Apr 2023 03:05:10 +0000
Message-ID: <40904e94edbb5af41d21ec9fe1d32b6bfb118b0f.camel@intel.com>
References: <20230405005911.423699-1-seanjc@google.com>
In-Reply-To: <20230405005911.423699-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB6003:EE_
x-ms-office365-filtering-correlation-id: 99ebe8e3-5e96-4aef-a86e-08db3582916e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AI40F/W0Im/P37frMv8XphnRoGUX3dtSJCYL1JRIH7mrJ7wFVP/ofOui5O2RJGvnsx6h/cV76OlpFgb6mYUCM0SLmQF6BSHSnsWYBM+jop/x007yQiKHNrJa5oGTAWpOjJAfXpEo0eSPkMyj4Gl4J40Zzq0kT4tPNsZM7JmnRoZv3KyJ3xbRBJ6i3FfzJsM652EWactPCwUZ3cxjCef9OBVQZQeiQppX4HNIkE2l0zPVHdsy2SGgOspYdCSDG874/8+o7a/iwoj6zMwjMT3uXjzrf7/R/Y78s6JLzqlIlGaQlZB+hEcY/B41wI2+V2J5RiOotKbUL7bjIM9F77rdHGbvHISxUCN0B/NJKCOpe6xf04YYJpSdr9UziWQ694K4IZ1coouGlw/oynFrWgWDXaft+QOla4lwUsOYyTy0OWh3IeGSJH9jRKGOFCp5yIztIHqh74RH9YuXk/NHF899uCQPce1H314+mQIpQVkJWZPD+EDtVpINcJpPrPOpWiOaPbLwMMQqpLr+nGbKxy+zId7bU2SSivXJ+Jtj3aCxVyrXGeJc0S7iSRzKLpjMiTFWM75rJvxyq8IjDc5tYHWScKxhkibF9robjAMhUold23LosLy39+T263hPvNIemKA4bbyjmujX5TVnZA5CFVxqWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(136003)(376002)(396003)(451199021)(86362001)(38070700005)(36756003)(2906002)(966005)(2616005)(71200400001)(6486002)(186003)(83380400001)(6506007)(26005)(6512007)(91956017)(76116006)(66946007)(66476007)(66556008)(8676002)(4326008)(478600001)(66446008)(64756008)(122000001)(41300700001)(82960400001)(38100700002)(54906003)(316002)(5660300002)(110136005)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTlwRXZrcjBJK0dlZ25vcjBweTNUaTNvMnNDMG93ZTduSCtTRFBzOXdQM0hn?=
 =?utf-8?B?UkFUM0FIV1ZDTjBXckM1TXZEMHpwWXlMcHZ2Y2duanVmYlFSRHpMb0NOVWlx?=
 =?utf-8?B?TzZzaVdCS1FUeWU4TWVTWDNENmZBdUhVZ1F6Rm1IempzNllGOGZ1ZDZReXVS?=
 =?utf-8?B?OXIxSE5Yc21GdjM0V0RYSlNzTzhmU0tXM3ZNemtXS3VPaEJEeUMxMGFXUnFt?=
 =?utf-8?B?eWRZaittNG9UYzNSL2IyVU1KKzBSNWMvZlhMTm1MZjk4T2t1RVhZQjh3MlRj?=
 =?utf-8?B?Wlg1bUpHMUFVQkNHTkYyZlR3UkVZWE0wMnFTWnh6VUtMZXdnbTVzaTF3RlIx?=
 =?utf-8?B?ZkYwUWVOdFNJam1wcTZDTmxjS3JQQ1pZZkpZOXE1TjVldXdkVVZnOGtvbXdE?=
 =?utf-8?B?RWxsWENBMUoxUVhnOGlJR3Z0VWRiQmRzNXpNcjhlSFNmNy9kVjFEckt0OHVP?=
 =?utf-8?B?a2g0Z0hMVkZDY21wOHVmd2JYY0NVUjVicW1xQVZabFA2V3RlMmtwT2NES25G?=
 =?utf-8?B?cHJ3S3JwRENUaXB5VXQ1L0JNWXNYdjdrcDdYY2VhemxOdzBmWlp2R0Z6dzA1?=
 =?utf-8?B?Tk0vdUZNNjBiTmVOWkpkS2krQ0dsSU1lTTZ3QWFtUDJNUnFiSWdMR3hiRUl0?=
 =?utf-8?B?K29sU1g2Tzk1MTYwT05nZytkUzNYdDlwTGRBTFZUM285b25JNnRyUzYvMlNE?=
 =?utf-8?B?NUZFRnBRbXJLTXIvM2laQ3dKcEJIN0FHbzVUdUlBR1ozVTlYWmlSUUxVZEpY?=
 =?utf-8?B?NE40QzZ2UTErbmNoU1ZRSzRuUXQyRUkyS3RtUFdOeDRUeDQ3b1R6VjVQejNV?=
 =?utf-8?B?ZTNPWHZzVlE3TElNZTdGUTFyRTJ4ODdDNitOZHY1Ynh5RHBpZ0FJMmdPK1BE?=
 =?utf-8?B?Kyt0eW1jRUFZZXB5S2w4eGdNSmNqbTZUdW1RUXBUZWw2ck1JMjNweldiN3lH?=
 =?utf-8?B?a3YvMVI4SWN0b2VwY2NndXRYelN0UFYwaVFnYlBxeVUyVGplcVpoN20vV2pu?=
 =?utf-8?B?aHd4dFZKaUdEUGIvVkFjb1pJR0dkdHg3TEZ5Z29OV2VvamkwVzlLcTgzNzdm?=
 =?utf-8?B?Mmg4dEcwdXVHeVB1bUJyamRnS0FxYVVoYjMvNFBzdlI4ZnVWY2doTzdwZ0tF?=
 =?utf-8?B?WGxxSldJVWZkQk0rMkt5cC91cGZyNXB6ZW96Si8yUUM1cGV6T2x0VjlQQWZF?=
 =?utf-8?B?Unp4cndBQUZJd1l1QXUyQzhLS2pJSVR4M2dqT1JVaG1zdmwyU1l6ZUlkZ2dT?=
 =?utf-8?B?RjFmVUk5TithcExZM2lkZFg1ZFVmeG1Jc0RGNGg5VU9xN0Q3clpNeHRpeXEz?=
 =?utf-8?B?Q3YwY3Vha2wwT3pUM1NpS2kwSGdZamZWdGJIcHBQV0hhUGhMYWZqODV3RmM3?=
 =?utf-8?B?bmRSRFltb2FWWVNCeUo0ek1OTzhuREFmQXIzVVFhcGVTdFdpQW5GeFFFRWpH?=
 =?utf-8?B?TStVRDlUSDYzL3RFS1hpdDRsSWF2bE1WU3Z2Z2hrN3dyb1BjbHpPczZzVkVY?=
 =?utf-8?B?U3JHaXRiU3BMTE1Pa2svUXFBTThQZ3A4T2NVckpUQkVmL3NDYytFOVpNcTUy?=
 =?utf-8?B?bU1vTVNuWFhhRkI0c3VEQmZrSmhYWEpadWNtR2h2RFFpaWVEVCt2V2NVVUVi?=
 =?utf-8?B?VUE5ejdST2Nubks5NHhZMGxBMEltN3Aza3Q3b0d4b1BFVkZQbE90Z2FGdVRY?=
 =?utf-8?B?ZTZ3a2pjVm11OUFDSXZzOHQwcDhhSWp1WW8vMDN0eFpDdkVoWGVBWVI3bDJk?=
 =?utf-8?B?S0ZzT05tN01RdzQxRCt1YVF0YndtZ0ZKQXlFRkc2bElaMVZxWlNiOVNMVXVH?=
 =?utf-8?B?cTI2cHlaZjlhMU9DNnlQbkw1L29jK0txWHJoWHFNakJHUnJYQUJIZTlxeWtt?=
 =?utf-8?B?eVNSbjdpZ0tWRG1lNFF2OEV0NGk5dWd2QVFpQWJJZW51bVljVnR5YlVVZTJT?=
 =?utf-8?B?eVZRRm5mRUh6WG1VS0YreERSTVJycjY1bmptSFpSK2Z2S0FlNEJPWDh6cVov?=
 =?utf-8?B?b3VzcitJYXFSZ1o0Uk11dDUwSGZCSkhFTUIzeFp1cDZWME1KRU9oeWI1N09v?=
 =?utf-8?B?MHRkSWcyeGVBRmZQMkhPbDhSQWwyOWM1S3o0V3A0bk9DUTBUVklGVzNxdldu?=
 =?utf-8?Q?sWVgGrH9yhLpacNby47as2Hpu?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <005C1351D0AF0D43BBD625DA284800E2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99ebe8e3-5e96-4aef-a86e-08db3582916e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 03:05:10.4520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v4hPgG0J2uSIyhKd1UikB6ofOwD/MX5pa2EAvlslUUcZUpLebZ5o7rMHpBCM+/DQjvfFeaAOBSBRqk978DUVcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6003
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA0LTA0IGF0IDE3OjU5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiAqKiogV0FSTklORyAqKiogQUJJIGJyZWFrYWdlLg0KPiANCj4gU3RvcCBhZGp1c3Rp
bmcgdGhlIGd1ZXN0J3MgQ1BVSUQgaW5mbyBmb3IgdGhlIGFsbG93ZWQgWEZSTSAoYS5rLmEuIFhD
UjApDQo+IGZvciBTR1ggZW5jbGF2ZXMuICBQYXN0IG1lIGRpZG4ndCB1bmRlcnN0YW5kIHRoZSBy
b2xlcyBhbmQgcmVzcG9uc2liaWxpdGllcw0KPiBiZXR3ZWVuIHVzZXJzcGFjZSBhbmQgS1ZNIHdp
dGggcmVzcGVjdCB0byBDUFVJRCBsZWFmcywgaS5lLiBJIHRob3VnaHQgSSB3YXMNCj4gYmVpbmcg
aGVscGZ1bCBieSBoYXZpbmcgS1ZNIGFkanVzdCB0aGUgZW50cmllcy4NCj4gDQo+IFRoaXMgaXMg
Y2xlYXJseSBhbiBBQkkgYnJlYWthZ2UsIGJ1dCBRRU1VICh0cmllcyB0bykgZG8gdGhlIHJpZ2h0
IHRoaW5nLA0KPiBhbmQgQUZBSUsgbm8gb3RoZXIgVk1NcyBzdXBwb3J0IFNHWCAoeWV0KSwgc28g
SSdtIGhvcGluZyB3ZSBjYW4gZXhjaXNlIHRoZQ0KPiB1Z2x5IGJlZm9yZSB1c2Vyc3BhY2Ugc3Rh
cnRzIGRlcGVuZGluZyBvbiB0aGUgYmFkIGJlaGF2aW9yLg0KPiANCj4gQ29tcGlsZSB0ZXN0ZWQg
b25seSAoZG9uJ3QgaGF2ZSBhbiBTR1ggc3lzdGVtIHRoZXNlIGRheXMpLg0KDQpJJ2xsIGxvb2sg
aW50byB0aGlzLCBhbmQgYXQgdGhlIG1lYW50aW1lIC4uLg0KDQo+IA0KPiBOb3RlLCBRRU1VIGNv
bW1pdCAzMDFlOTA2NzVjICgidGFyZ2V0L2kzODY6IEVuYWJsZSBzdXBwb3J0IGZvciBYU0FWRVMN
Cj4gYmFzZWQgZmVhdHVyZXMiKSBjb21wbGV0ZWx5IGJyb2tlIFNHWCBieSB1c2luZyBhbGxvd2Vk
IFhTUyBpbnN0ZWFkIG9mDQo+IFhDUjAsIGFuZCBubyBvbmUgaGFzIGNvbXBsYWluZWQuICBUaGF0
IGdpdmVzIG1lIGhvcGUgdGhhdCB0aGlzIG9uZSB3aWxsDQo+IGdvIHRocm91Z2ggYXMgd2VsbC4N
Cg0KLi4uDQoNCkFjdHVhbGx5IHdlIGdvdCBjb21wbGFpbiBhcm91bmQgaGFsZiB5ZWFyIGFnbzoN
Cg0KaHR0cHM6Ly9naXRodWIuY29tL2dyYW1pbmVwcm9qZWN0L2dyYW1pbmUvaXNzdWVzLzk1NSNp
c3N1ZWNvbW1lbnQtMTI3MjgyOTUxMA0KDQo+IA0KPiBJIGJlbGl2ZSB0aGUgUUVNVSBmaXggaXMg
YmVsb3cuICBJJ2xsIHBvc3QgYSBwYXRjaCBhdCBzb21lIHBvaW50IHVubGVzcw0KPiBzb21lb25l
IHdhbnRzIHRvIGRvIHRoZSBkaXJ0eSB3b3JrIGFuZCBjbGFpbSB0aGUgcGF0Y2ggYXMgdGhlaXIg
b3duLg0KPiANCj4gZGlmZiAtLWdpdCBhL3RhcmdldC9pMzg2L2NwdS5jIGIvdGFyZ2V0L2kzODYv
Y3B1LmMNCj4gaW5kZXggNjU3NjI4N2U1Yi4uZjA4M2ZmNDMzNSAxMDA2NDQNCj4gLS0tIGEvdGFy
Z2V0L2kzODYvY3B1LmMNCj4gKysrIGIvdGFyZ2V0L2kzODYvY3B1LmMNCj4gQEAgLTU3MTgsOCAr
NTcxOCw4IEBAIHZvaWQgY3B1X3g4Nl9jcHVpZChDUFVYODZTdGF0ZSAqZW52LCB1aW50MzJfdCBp
bmRleCwgdWludDMyX3QgY291bnQsDQo+ICAgICAgICAgIH0gZWxzZSB7DQo+ICAgICAgICAgICAg
ICAqZWF4ICY9IGVudi0+ZmVhdHVyZXNbRkVBVF9TR1hfMTJfMV9FQVhdOw0KPiAgICAgICAgICAg
ICAgKmVieCAmPSAwOyAvKiBlYnggcmVzZXJ2ZSAqLw0KPiAtICAgICAgICAgICAgKmVjeCAmPSBl
bnYtPmZlYXR1cmVzW0ZFQVRfWFNBVkVfWFNTX0xPXTsNCj4gLSAgICAgICAgICAgICplZHggJj0g
ZW52LT5mZWF0dXJlc1tGRUFUX1hTQVZFX1hTU19ISV07DQo+ICsgICAgICAgICAgICAqZWN4ICY9
IGVudi0+ZmVhdHVyZXNbRkVBVF9YU0FWRV9YQ1IwX0xPXTsNCj4gKyAgICAgICAgICAgICplZHgg
Jj0gZW52LT5mZWF0dXJlc1tGRUFUX1hTQVZFX1hDUjBfSEldOw0KPiAgDQo+ICAgICAgICAgICAg
ICAvKiBGUCBhbmQgU1NFIGFyZSBhbHdheXMgYWxsb3dlZCByZWdhcmRsZXNzIG9mIFhTQVZFL1hD
UjAuICovDQo+ICAgICAgICAgICAgICAqZWN4IHw9IFhTVEFURV9GUF9NQVNLIHwgWFNUQVRFX1NT
RV9NQVNLOw0KDQpBbmQgc2luY2UgdGhlbiBZYW5nIHBvc3RlZCBhIHBhdGNoIHRvIFFlbXUgbWFp
bGluZyBsaXN0IHRvIGZpeDoNCg0KaHR0cHM6Ly9saXN0cy5ub25nbnUub3JnL2FyY2hpdmUvaHRt
bC9xZW11LWRldmVsLzIwMjItMTAvbXNnMDQ5OTAuaHRtbA0KDQpJIHRob3VnaHQgaXQgaGFkIGJl
ZW4gbWVyZ2VkLCBidXQgaXQgc2VlbXMgaXQgaGFzbid0IDopDQoNCj4gDQo+IFNlYW4gQ2hyaXN0
b3BoZXJzb24gKDMpOg0KPiAgIEtWTTogVk1YOiBEb24ndCByZWx5IF9vbmx5XyBvbiBDUFVJRCB0
byBlbmZvcmNlIFhDUjAgcmVzdHJpY3Rpb25zIGZvcg0KPiAgICAgRUNSRUFURQ0KPiAgIEtWTTog
eDg2OiBEb24ndCBhZGp1c3QgZ3Vlc3QncyBDUFVJRC4weDEyLjEgKGFsbG93ZWQgU0dYIGVuY2xh
dmUgWEZSTSkNCj4gICBLVk06IHg4NjogT3BlbiBjb2RlIHN1cHBvcnRlZCBYQ1IwIGNhbGN1bGF0
aW9uIGluDQo+ICAgICBrdm1fdmNwdV9hZnRlcl9zZXRfY3B1aWQoKQ0KPiANCj4gIGFyY2gveDg2
L2t2bS9jcHVpZC5jICAgfCA0MyArKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0NCj4gIGFyY2gveDg2L2t2bS92bXgvc2d4LmMgfCAgMyArKy0NCj4gIDIgZmlsZXMgY2hh
bmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMzQgZGVsZXRpb25zKC0pDQo+IA0KPiANCj4gYmFzZS1j
b21taXQ6IDI3ZDY4NDVkMjU4YjY3ZjRlYjNkZWJlMDYyYjdkYWNjNjdlMGMzOTMNCj4gLS0gDQo+
IDIuNDAuMC4zNDguZ2Y5MzhiMDkzNjYtZ29vZw0KPiANCg0K
