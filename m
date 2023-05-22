Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA1070BF75
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 15:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbjEVNPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 09:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbjEVNPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 09:15:53 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F9092;
        Mon, 22 May 2023 06:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684761352; x=1716297352;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=m2XSaEQGG4Oc098jL8Imnfx/JeSiBiOieU8osURlbiU=;
  b=IopX4rCJx4zPtc966AniYbSwyyPOYhp8F2Ry8nRTB72XD55MJ676J0rf
   O91GmXFI6hg7GdTP92rQmoW1OCREu/nz00UVhFDSgZyOhhn0jaRCkpgrP
   aMbzOlOA+uyka3E6e7xRfVq/rEeRZTcsoH091Zu2+CVZf7PyZ5JdUoXM3
   T3AMV+Rt1LvLT5l+fmU6M4nBnrvYmPGxOfNmkZAseEN1zPj+jAxvYOxyz
   w2C1F0+Ye8Kd9LQJZe5+lWt8mOvDUfvxhuxcZ88i3X0seZ8O7qQ1NWq9A
   lE1uCBZp8uktDs87d5HiSzd1rVmI5zPTCbsjkYsvAfJJ/Ivs1deCpD20Z
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="333282930"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="333282930"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 06:15:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="680941707"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="680941707"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 22 May 2023 06:15:52 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 06:15:51 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 06:15:51 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 06:15:51 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 06:15:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZlHktu0w42H+0Ft+DBIks20HOsPGkmegximbY/ajdBFhAtX3jyFCTLRWYVOIyauRXjjNW5XRSJcEWQdsgvwcrLoMDTfAnzBp2J5YqsuwkNvhYCSwHce6U3PS2WQ5QMBiHRi3gUx7MA0TwYrXXP2Wg2RxiOJkgsBTsUF9c75As3xmLqBUNjpR7BEmhkf1KIa86dZ5o4o68uDlwZcoaSZxXDq4EkZH6P0hpIVZGLQnuERZcgun3LXsCYfgXKqbaq82FAsdDC3Db3FvGki1SsfnG4q3uCSsgeDwRyPJt+v3Ijc971KCX/PK7ux4ZYNgjbFbWHG6k8TD0GjXZUmVm6fZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m2XSaEQGG4Oc098jL8Imnfx/JeSiBiOieU8osURlbiU=;
 b=TBsKmX8giwf0Zrb6dcXwk32yfdBfeKxfpS//AKcZhwGniP6iSzSV19Pa966ExmpFC9ZixrEAP9OjGffJHGjVU4piVG7yYEYquRL47M+HVb3E+5dOfN8vff9wiNroL48pdxoOERGevXGG6EEmvWkbK1vlxiC9/7clvFk+anuYs/iWJZRWBVBG6wKitXpvojdufOBUSsR+FlrzPxqlXPP1ar6uk+Q/+BW4NfBWLbKOeqlHbPVAZhoujHdSp0GQquR/uy7n3lBa17/mtiQhK5Hs1UoarBw0WPA7zUk0NN/w1ndF1R6yP4b8juHdumOqP5Xy/jn1LmgUmtxDrQwnpzSYxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB6424.namprd11.prod.outlook.com (2603:10b6:8:c4::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.27; Mon, 22 May 2023 13:15:47 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 13:15:47 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 10/18] x86/virt: KVM: Move VMXOFF helpers into KVM VMX
Thread-Topic: [PATCH v3 10/18] x86/virt: KVM: Move VMXOFF helpers into KVM VMX
Thread-Index: AQHZhSyZW6joyL11ZkKnLJ9zpN/uPa9mVK4A
Date:   Mon, 22 May 2023 13:15:47 +0000
Message-ID: <79073b9c22cf60ac87896f0bbcdfd905196e1b4a.camel@intel.com>
References: <20230512235026.808058-1-seanjc@google.com>
         <20230512235026.808058-11-seanjc@google.com>
In-Reply-To: <20230512235026.808058-11-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB6424:EE_
x-ms-office365-filtering-correlation-id: 97eb850b-d696-4369-53cc-08db5ac6a810
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JOwh3z4DaX3beFQeNC91Cwr01Y+cTSXO9MbHNNa6tb1wdx2Hpl0lIl1OoFinz5LyHZUfWbV6zKbJlNiyQ8x2ULitUPcJH0Hq//BxgqSnfKt0X6S9ZURvunqv7IAem1F4JBmpbPE6K9fzRx5UawHFaus4IWlfpoYDq+a4ZYBiDqkI6p7s/c8HllkhyYWoyslRTCGQjt48r/NEpFXJ0q83cBlnxdqdI0QCkkiceIk9GG2I9RRkw0K4UrG10UxWyvMTKh5VXpkiUJZo7SmmARa39RfubGBEfhIRjsQtr2PCFGikJLqUChkJP3Nbub3h879Azrp4dhJbS1m2qb+SCTr4XPOADFprin5Mvcxt3bKbQS5mibWLVbO4EUKwFZQQ+FrtzDJ66wkijNSntMZYMFl6nUdpHkpVuBIk0LqJxo6e1XzPshdeqAT+p9DXdVV6ITB1ZFRAM/1XKvvLxP2GEl8vuON1DQbz97iNkFT519dSukTPsDDfPcLE5Ya7DiDhznISRc9dpM6f+oZxKWVqNyd5jbCxZbZ7/mVZEXrDDJ0S1hkO00tRAD+bAvoc0Yp9YRMI4NadpMw5KR13un+y887J7IciCXscqiuwEDzR43q1se/CrD43kVuahlbEQjI+UB6R
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(136003)(39850400004)(346002)(396003)(451199021)(110136005)(54906003)(82960400001)(38100700002)(478600001)(4326008)(66476007)(66446008)(66556008)(64756008)(91956017)(76116006)(66946007)(38070700005)(83380400001)(122000001)(2616005)(71200400001)(2906002)(4744005)(316002)(186003)(86362001)(26005)(6512007)(6506007)(41300700001)(6486002)(5660300002)(8676002)(8936002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T0Z5Wit4T0VoK3dSSWtqUmVvWjFzcGVKYjEvL1pHRzg1UFhmVjBnTlBNclNH?=
 =?utf-8?B?Y0NhKzVNd0hBaWVpSGUycTJCY3RydHBzK25QdGJmRVpKOEVMQ3ExSitFTm5F?=
 =?utf-8?B?cnJyUlhrbEh1ZDU3WWM2aVV4NE9hM1RXMVRxR2F3ZXpYbnZxTUI2S3hOOVdL?=
 =?utf-8?B?YXBKVUkxdE10WFZscEMyZWhzYlVmRmpqOFFiOWM0ZERiclJGL3FpZFp3TEVa?=
 =?utf-8?B?c0FGa3Nyek1qWGpKNGo3b2kvZlRTQUxoT29kTWhFbVZRWldJV0tQdGJKNGxC?=
 =?utf-8?B?Ti9aR1VyYytqTnJERE5kNkgyb3Iwc1BKR3ZrTlZGYVpkNzIraTVRTzlIUDM1?=
 =?utf-8?B?VlNOdCszTjlTYWlEcFB2bnZKeWdVUjdIdGJFeTJlS2NQTG5hVU1BWDh3cHUy?=
 =?utf-8?B?UkxMNDFBQzlHSlFQQnZIRm5hVEttbDluWFppbDNCWkk2N1dmNU43YWpoWUtj?=
 =?utf-8?B?N0RYWlhhSFpkK3BJUE96YkNvM1FBRnlNcUFVWEFIdW1MaUpSZzVXVUxLNW5v?=
 =?utf-8?B?dXR1MS9IU1p2eVF3UklBVHNQays2eXNScSs2dU5UdWlFNmJFM1Y5bUg1VnA0?=
 =?utf-8?B?azkxc01LaVhVOU45ejlOSXc4L3orS0pFWXE4Uk9TYnpxWHNjeDh4cTRqSnpP?=
 =?utf-8?B?MEgxQ2xjNjBNbE05R2NhQjFzbDY0VXJLRlVYQlV6aVpRS3hPcklTMnRweXdM?=
 =?utf-8?B?cnBJOHBub08rd1dGOWU1RlJCcGFjYUVFM0JhKzI3bFRuR3BkbXFJRmp3TVFE?=
 =?utf-8?B?Q1lvcGlRS0xwNVpMZk1KRUhTdEMwN2ZZNkEwZkdKNVNzNWFYOWxQOVlTR09z?=
 =?utf-8?B?T3BLN29tZnJobmlLbmdLWk8wclQydEFzODVGbmVEbk9ldisyUkV5SlVSUldn?=
 =?utf-8?B?S3BXZGtCQXljNUptc2EyMHFTTmF5OFdWMjloRHhpbUxjSGlJang2UXNURXVJ?=
 =?utf-8?B?N3Blc1p4RmlzME56TlNKdGw3WEdjcW9nOUt1VmpXU1dzanYvT1V5KytVSkE2?=
 =?utf-8?B?M1FDdGxtakxvTitiZW1LWi9mQ2FtMkRiVHBzVFhEMUxFL1RGeGpwT0N0OE1k?=
 =?utf-8?B?SmZyL3J4NUZack9EWlJuaUloYk5ZMlYyYmNLSEZ5NXZjWnIvNXBmNzl1WFVr?=
 =?utf-8?B?dGo3WDJsQjRKcEtvRWdweTRQbmFYaEZnRjkrYUpYTHVOcXk2QXI5MUdtb0px?=
 =?utf-8?B?dGZpOHB6NkxKNzg3WlVyVWxkeDl3LzBTVURYajU3R0FmLzdvVTViZU9Nc2NO?=
 =?utf-8?B?SFNwb3VOWS9NeTkveGNYbEMxUnRpVTdya3JRV3BheVphUSt3WURWZ25Cd25Z?=
 =?utf-8?B?NkxMVkZHS08rZmZ0VFg3N0c5WVg0cC9TeGdGQ3cwdElzOFh0NldhQlNFRWtT?=
 =?utf-8?B?SUkvNWlNL2hEN040dGQ0cFlwYUJIOENGSEZtNzRtcFQ3ZWRJSXV1MG11ZnIz?=
 =?utf-8?B?NzNEWitjV0JsZnErSmY2Zit0eEJ6MmFYVmthOG55Tk54RjBCWlJncVFra0V1?=
 =?utf-8?B?MitpRFdpWmx4UThwd2JOcHBabnppbTBZNE5tMEVubTVGOVQ4ZEJlRytFVGIv?=
 =?utf-8?B?TDNzN0NpSHUrMTA3eUFPNngwZ1MxVmpoWVUrWVhxdnI5WUpCclVzamJBNC9m?=
 =?utf-8?B?ZU1CKzVwMkx5cS8rU3RyZExNQXlENmw3UFFUQVh4Q05mUzJrOVVLbmd4eDdk?=
 =?utf-8?B?U3lIRzhNZDRlM1dkRlRpN21kUU9UQ3dHYjVvUG5OamQ3VHlMODl1M0VMaGJR?=
 =?utf-8?B?MVhYbE9USDVBSUYrbDJ0bmRvRk52bXh1M3psdEh4SlRYMCtoRkxsMmhteUlW?=
 =?utf-8?B?MFJUaVQyUkRXL1hrWnpZcm9MS0EwTjlRK3pJcmdXTW1EWkJFazNyMmNFZjBE?=
 =?utf-8?B?OUQ2SXA2cm5iUXJpVU9FZWREb3NGOHJacTFhdGJ1ZTRFcTRFK3M3NEtXK1ls?=
 =?utf-8?B?NHh2dFgvYk8rdk52ZjVzelZ3R3pnYXRpeEh1Q0FYUHcvSlN0OGdKSmxJVWNz?=
 =?utf-8?B?ZW51ZGZVVy9iM1BxY3l3SndDbG44cDQ0aHhhSGNhZ1RXQ25ZU1ZJMlNVQ3dP?=
 =?utf-8?B?Vm4yUW1oYitITjVQUmJzYnh6cmhPRDd3S3g1WEtLKytLRmpNc2RqVjFRMnBx?=
 =?utf-8?B?dGhhOS81SVVGWUZFeWlrSnppTWd6UStHZXNvem9PeHJSMWlRdXZTelJJd3pK?=
 =?utf-8?B?Y3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <418233C6E53D29459D40339E9B0598AF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97eb850b-d696-4369-53cc-08db5ac6a810
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 13:15:47.2644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rNu7ZygP2W0lYNvFQkiWqRpCupSMvy6QDuhzO8VZ7krVGvsKj7Pbu0JVjrZk8+9SgCoacft1nokP8bGmzAHw2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6424
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

T24gRnJpLCAyMDIzLTA1LTEyIGF0IDE2OjUwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBOb3cgdGhhdCBWTVggaXMgZGlzYWJsZWQgaW4gZW1lcmdlbmNpZXMgdmlhIHRoZSB2
aXJ0IGNhbGxiYWNrcywgbW92ZSB0aGUNCj4gVk1YT0ZGIGhlbHBlcnMgaW50byBLVk0sIHRoZSBv
bmx5IHJlbWFpbmluZyB1c2VyLg0KPiANCj4gTm8gZnVuY3Rpb25hbCBjaGFuZ2UgaW50ZW5kZWQu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xl
LmNvbT4NCg0KUmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg0K
T25lIG5pdCAuLi4NCg0KWy4uLl0NCg0KDQo+ICBzdGF0aWMgdm9pZCB2bXhfZW1lcmdlbmN5X2Rp
c2FibGUodm9pZCkNCj4gIHsNCj4gIAlpbnQgY3B1ID0gcmF3X3NtcF9wcm9jZXNzb3JfaWQoKTsN
Cj4gQEAgLTc1Myw3ICs3NzUsOCBAQCBzdGF0aWMgdm9pZCB2bXhfZW1lcmdlbmN5X2Rpc2FibGUo
dm9pZCkNCj4gIAkJCSAgICBsb2FkZWRfdm1jc3Nfb25fY3B1X2xpbmspDQo+ICAJCXZtY3NfY2xl
YXIodi0+dm1jcyk7DQo+ICANCj4gLQlfX2NwdV9lbWVyZ2VuY3lfdm14b2ZmKCk7DQo+ICsJaWYg
KF9fcmVhZF9jcjQoKSAmIFg4Nl9DUjRfVk1YRSkNCj4gKwkJa3ZtX2NwdV92bXhvZmYoKTsNCj4g
IH0NCg0KQXMgcmVwbGllZCB0byBwYXRjaCAzLCBpcyBpdCBiZXR0ZXIgdG8gbW92ZSBDUjQuVk1Y
RSBiaXQgY2hlY2sgYmVmb3JlIFZNQ0xFQVINCihjYW4gYmUgZG9uZSBpbiBlaXRoZXIgcGF0Y2gg
Mywgb3IgaGVyZSk/DQoNCg0K
