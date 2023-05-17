Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D5B705F29
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 07:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbjEQFWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 01:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjEQFWd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 01:22:33 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AEEF3C0C;
        Tue, 16 May 2023 22:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684300950; x=1715836950;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=zWRRnYk08FUU9KGZJWU2D2C7ZzATp6XnctYSXRAUzu4=;
  b=EG8SJtYXqN2zfXTMD/b5agtAsqdcnBCKorWZGPxd3/XLGRs3Aalss2Pt
   yn7lt2xVd64IVcg5dsOPrApA15nPJkTxan06TO8uzQ7MnWLNtzMSuHlSU
   ihYp/g5DpuWD6109w/xc2jhcNGpbwt5zipTkm3S7Pbl+4rnSBzuCsnChk
   gggDIw/ez72Ld4MVZMFLF4Ihrx3vmVDhkYbVk2Dea5KNepw7mExwgxySY
   FK1wyiqQgbEM0ulu1i4Rlp+/ZwVbD2/bMNWkHQ+eNUERipyt0eOsCNrJ6
   sFxYuJgxnIinG8Oe6SXTq/T1Byy4RNoIgDZLVPJenB+/GpPC2LN5Kksz6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="353958453"
X-IronPort-AV: E=Sophos;i="5.99,281,1677571200"; 
   d="scan'208";a="353958453"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 22:22:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="813722842"
X-IronPort-AV: E=Sophos;i="5.99,281,1677571200"; 
   d="scan'208";a="813722842"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 16 May 2023 22:22:29 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 22:22:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 22:22:29 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 22:22:29 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 22:22:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jK47hssq5aESjFh2CHAOef12v8kuboy3cv+1pOVjQ9T7b+JeYqT0gculHs+RLdRsc8phBa5JBqdcLzaVBxZVJaEhhdTk2qh3XoQk7WLtMeUbHwYHH8YQ5SMZGjDV4DGHfz8++69Ipp8+VcgOrR/EXxPhZJiw2cuOJ1yp59Dsg+XxxTgjfgTEre4a++XgS4voWoxb90PL6/lPB9YbpzeVYtZ2apGwk1CcvQrvW8WdAh01uciX0ObBTK3qherIJE60HqNUm1vHknd0w6nyjWnKK8O1cssZGq+PqFIBFmXWJd5bpq7a0pSzOK9AP2n1vJzoMaOhxumIzxUBNe5OPzIBag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zWRRnYk08FUU9KGZJWU2D2C7ZzATp6XnctYSXRAUzu4=;
 b=Q7TNRIkdUKW1mWD21I+VAB/cM8y9R9Hmo5jiO2b1V419j55bMmEsko2GxjrqewGWmpqi+8YLRsK1roDXn3w+62ee5q1q25/CJmxfH/1zRZPG3FCq8INx0mUYY26+UpuRBT8ODrrTqO3PZW+24m0Wc3R2gMcL15qcLwGsCtih4AR6aKmqc6DIvk2sm+MIyUA/W3d7E2/PKzYOiplRueM1EDtewbDZlryXYz51aeoZ3gwUoH5z+jZ3CL/am7KjEGr3B4gSO1KPmIRlubU3NFRQkY1EOdOAuP0TgLZHJqbwxyL+rZvmPTKY3CNCZRyE4JPYblBHTMLZ06v6liUkv8awQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB6714.namprd11.prod.outlook.com (2603:10b6:303:20f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Wed, 17 May
 2023 05:22:26 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%5]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 05:22:26 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Nicolin Chen" <nicolinc@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: RE: vPASID capability for VF
Thread-Topic: vPASID capability for VF
Thread-Index: AdmCTgezzTkHY+EMTOCoyMjynB/f5ABFkrqAABzyefAAEd18AAAWEYvQAQF+OGA=
Date:   Wed, 17 May 2023 05:22:26 +0000
Message-ID: <BN9PR11MB5276DFB68957676E1D46C5E78C7E9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230510112449.4d766f6f.alex.williamson@redhat.com>
        <BN9PR11MB52769ABFE779CE1D8838A7A78C749@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230511094512.11b5bb7e.alex.williamson@redhat.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB6714:EE_
x-ms-office365-filtering-correlation-id: 7d5979a2-f4a2-4968-88c5-08db5696b3fe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cxD7MRcsJUcpYczwZ78lHabxMosfcoVg49tgq4J8mdub9Lk4HDP9eOp4MvJobjnjdL1bOkaVLz/lc3Sb0g4hHeEMWTiEa867+r29WxvK0q+kvxAcTK4JxlSVIFrZgZez+SmNkOoeIxirxT/ceGeLZj5Vl2z/1DgGhFRIn7F8m1Q+gibu+xv5c3wYEhKR74mH1LDzetMRNeMMyz1rN+aD2EXB2Q0avV6adGx9XO3N8pCsjdy6FaPMu5bGWvwIB7eJqoqHFi+Ri5deaW2+14ENYrcS5gZjGy9uppZrEhJfB9CyUosoBQ3cLmdBS2aREa0OdyGXM/Czs5D8lgZDF/dFmBp0O30WOBssqD0mTiPWjSoE3GWESThETlUddWiSaDw42JwhhYxn+mxYBaneS4woQLHUtlEguvDS4mrpArgwwytOoriIi1A/1I5CHdnEQMY9CVj3G6jUSmXqo4CRTG1YCpaPLCW9R6/hyr5p6u6HHgXVcGBbuCTs4CnISm/sa5bsD5DGouL/cDRFtBY/yfh3BG6CHVJi+Um9NUw5wgpj0PBCkXuzm8AHmD9J4v7rNq7ww3BWyqHH8VVVan+LKt3opbiaYHOtcC8+lxXBuENXZM0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(376002)(39860400002)(366004)(346002)(451199021)(83380400001)(3480700007)(966005)(45080400002)(478600001)(7696005)(71200400001)(54906003)(9686003)(6506007)(26005)(107886003)(186003)(2906002)(8936002)(8676002)(52536014)(5660300002)(33656002)(41300700001)(122000001)(82960400001)(6916009)(38100700002)(4326008)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(316002)(86362001)(55016003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGpBNitUaGpSMFJ4UXg3RVJMOUt3NVJ3a1p4NGhDNUZIUXdnRDhhYVhYK3FJ?=
 =?utf-8?B?bzVma1MycUIzWUVieWY2S0YwZFIwdXJ1a0VaVXFHL2lRRy83UFNnay9IaXln?=
 =?utf-8?B?dGRZckI1VXhnU1QvTHlQbFJZWmdtWTVJNndQWG5CWlc1QlRuZ1kvRkZTSlF6?=
 =?utf-8?B?bCtTeE5lUXpRRGRFN1l4VGFuYStCNE9hZDA1NWJtQmszSmFSOTVoSWNBaXM4?=
 =?utf-8?B?ZGpMQVZ0RklaaGhpK0toeUtMMFBRaFFyd1JRSzZRZ0taMExnZkkrbWNvZWpX?=
 =?utf-8?B?ZkRnUityK09oZUYzdGlZa1R3T3dURFowS290UTRjNFgrVC95Q3ZaRDg1M3d6?=
 =?utf-8?B?UHFyZUp3b3FrdHVuaXpGemp1VVN6WXpPdGZ3dVlXTTIxNUE2RWZFQXdIekdl?=
 =?utf-8?B?SEIyN0gyeG1CcHNqdmNxNG4yTGd6ZEhZbnlTTWQ2eGx3WlUyQXdkMmdUNk1s?=
 =?utf-8?B?L2JsTVVQZU12YWhzb0tiNWdrUjBXQytZRWVaY1R3M1pJZW9JeURnK2J6LzZh?=
 =?utf-8?B?Mm14ZXMxbjFYUTh6eTh6UzlsSUR6ckY4b2dPQUNUSmo4cGhtNFZ5M1oxQ3pj?=
 =?utf-8?B?RjRHemhNRnRKOEpnVGhLMFBjcnBLaEpiaVhXb3hxZHZvUTFjWnlKcVhPbDd4?=
 =?utf-8?B?b3oxZFF0RTh1M1BXc2JueVJzVjRKbms4NEk5QlVwMGtLM21yN0ZJem1TZlEy?=
 =?utf-8?B?SGtNYWJtNmhtMTU0dVhta1NJRXk3alhRVldPeGZxbG53UElsUllYT05zbXBm?=
 =?utf-8?B?MjJxMG5ma0xYVnVjcVkyQU94aTNncmdNYVlkSVNIOWpsZ1diMGdTOVpvOERs?=
 =?utf-8?B?WFUrbERUaldRS3pQM0xLOUI4NE9hOUc4WFc5cjl6K012ZHpZQVptWW9nM3Uz?=
 =?utf-8?B?MEJSL1UyNjlxOWhRckpGVnZVK2dmYzlTV0xVeXIxT09FRHlKS0w2YWJ5N3Yz?=
 =?utf-8?B?QzFTanYrQTdWb3FtUWIyVkNSelB5cGluNHVCcWV0N3lUK1p2bk1LREZrTUdk?=
 =?utf-8?B?S1VqUjJtUVBPUmpjdTNyTXFQZ1YyUGpBaXBuWFVML3NKWEFSeXJIb055ZjQy?=
 =?utf-8?B?SmdUODg3NVp0NEI2cHBRY0VpK2ZVdWQ4cnJhVEF4cXFSbzVLYVQzZ1VHUFZu?=
 =?utf-8?B?K2lRS014bGRac1k5eTY1QU5KVTVRakNEeFJ5cmFZamFod3kvdDQ1R0tQR0l2?=
 =?utf-8?B?Ynh5REJrZytyTmxzb0RTTlFuUTZEQXd0OURjbGx2SEMzSnJGOEFoTzZOZzZa?=
 =?utf-8?B?a1V5NXpXa3RVcVU4OHFONW9BUVg5Zk5wYWtmUzRsTVRSVjdMek9peE0rZ1Ro?=
 =?utf-8?B?MTlURXhlZUJpdng3RWJXekZZOEdyWWNaMThneWQrNmM1b1JwT1BOZkF1eVY2?=
 =?utf-8?B?NU13SWdTcHJSNjg1ZHkvZS9jMFdzdHpISzhKZk9ObHYxQmxuUzFwYXpBRFI0?=
 =?utf-8?B?UFJDSnFka2lsd0xaNXhucWNUWEkzUm5MK3JtK3hRRGdlUGZEeGlNQ3F6VkQ3?=
 =?utf-8?B?Z01SK1lnWXFab0VvT3k0enJTelpqTkdvTldSQVdMSWUxNTJSK1Q4cHkyV2l3?=
 =?utf-8?B?eThCRDJZWnM0YzMwTUlEYzVuU0FTR0FFVm8wb3JMbVBnNzRTaVNmQTRlZzZC?=
 =?utf-8?B?cU93QXdGVVptQ0J0YXFjQTQ1TkdwU1FSMmlKZmtnZXFuOFBMNDVjTnZPamJI?=
 =?utf-8?B?MkZQbmR3TXVkVEpzSnJDaEFnemx5ZDJ0ZXRtYVhyOU5hdUFMbC9KZ01wOVI4?=
 =?utf-8?B?TkppKzBvWm5LdUxOYUMvQXpkVTJMZzRsSFR3SXY2VTdUdHNkTXRqRXZicmx6?=
 =?utf-8?B?cnRkRFBiVjZpWTN4YzVHL1hxU2NCVnJEdndyOWhxcjUxSTRZU3ZoWnZUWm05?=
 =?utf-8?B?R2hhUzBmMEhkUi90QlBITy8xemxKMHdyU1ZQOHdFQmVXa2dQNVFidEJGNHZZ?=
 =?utf-8?B?MkhKb2IwUmpQaHJYY0xFZmJrWnRxdXNRMzR0UmtqRW5aTXpNc2ZMUzFndXJK?=
 =?utf-8?B?NGNBanRWNVE1TEVVUXJ4L0tJOUt4MlJmdG80K0h1S29TYk9leDhmcXRPMElx?=
 =?utf-8?B?amdLMDNSTytKV1hCeC9lWi96NzBsRTZrbWhxTTMyOUE1QncwTjdOMEl4dmdD?=
 =?utf-8?Q?h64nfA8Kn4CnQNF0u9RiYDyUm?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d5979a2-f4a2-4968-88c5-08db5696b3fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2023 05:22:26.7474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9+VPvl58D5QTKhSJMNacEkh1MbPufTnLDZngXM5V19B7ytn+4f7D+DviyZqsOJEvqXtp/hJWe9z0Dz+v7gtZLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6714
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaWFuLCBLZXZpbg0KPiBTZW50OiBGcmlkYXksIE1heSAxMiwgMjAyMyAxMDo1MyBB
TQ0KPiANCj4gPiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQu
Y29tPg0KPiA+IFNlbnQ6IFRodXJzZGF5LCBNYXkgMTEsIDIwMjMgMTE6NDUgUE0NCj4gPg0KPiA+
IE9uIFRodSwgMTEgTWF5IDIwMjMgMDc6Mjc6MjcgKzAwMDANCj4gPiAiVGlhbiwgS2V2aW4iIDxr
ZXZpbi50aWFuQGludGVsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiA+ID4gRnJvbTogQWxleCBXaWxs
aWFtc29uIDxhbGV4LndpbGxpYW1zb25AcmVkaGF0LmNvbT4NCj4gPiA+ID4gU2VudDogVGh1cnNk
YXksIE1heSAxMSwgMjAyMyAxOjI1IEFNDQo+ID4gPiA+DQo+ID4gPiA+IE9uIFR1ZSwgOSBNYXkg
MjAyMyAwODozNDo1MyArMDAwMA0KPiA+ID4gPiAiVGlhbiwgS2V2aW4iIDxrZXZpbi50aWFuQGlu
dGVsLmNvbT4gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+ID4gQWNjb3JkaW5nIHRvIFBDSWUgc3Bl
YyAoNy44LjkgUEFTSUQgRXh0ZW5kZWQgQ2FwYWJpbGl0eSBTdHJ1Y3R1cmUpOg0KPiA+ID4gPiA+
DQo+ID4gPiA+ID4gICBUaGUgUEFTSUQgY29uZmlndXJhdGlvbiBvZiB0aGUgc2luZ2xlIG5vbi1W
RiBGdW5jdGlvbiByZXByZXNlbnRpbmcNCj4gPiA+ID4gPiAgIHRoZSBkZXZpY2UgaXMgYWxzbyB1
c2VkIGJ5IGFsbCBWRnMgaW4gdGhlIGRldmljZS4gQSBQRiBpcyBwZXJtaXR0ZWQNCj4gPiA+ID4g
PiAgIHRvIGltcGxlbWVudCB0aGUgUEFTSUQgY2FwYWJpbGl0eSwgYnV0IFZGcyBtdXN0IG5vdCBp
bXBsZW1lbnQgaXQuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBUbyBlbmFibGUgUEFTSUQgb24gVkYg
dGhlbiBvbmUgb3BlbiBpcyB3aGVyZSB0byBsb2NhdGUgdGhlIFBBU0lEDQo+ID4gPiA+ID4gY2Fw
YWJpbGl0eSBpbiBWRidzIHZjb25maWcgc3BhY2UuIHZmaW8tcGNpIGRvZXNuJ3Qga25vdyB3aGlj
aCBvZmZzZXQNCj4gPiA+ID4gPiBtYXkgY29udGFpbiBWRiBzcGVjaWZpYyBjb25maWcgcmVnaXN0
ZXJzLiBGaW5kaW5nIHN1Y2ggb2Zmc2V0IG11c3QNCj4gPiA+ID4gPiBjb21lIGZyb20gYSBkZXZp
Y2Ugc3BlY2lmaWMga25vd2xlZGdlLg0KPiA+ID4gPg0KPiA+ID4gPiBCYWNrdXAgZm9yIGEgbW9t
ZW50LCBWRnMgYXJlIGdvdmVybmVkIGJ5IHRoZSBQQVNJRCBjYXBhYmlsaXR5IG9uIHRoZQ0KPiA+
ID4gPiBQRi4gIFRoZSBQQVNJRCBjYXBhYmlsaXR5IGV4cG9zZXMgY29udHJvbCByZWdpc3RlcnMg
dGhhdCBpbXBseSB0aGUNCj4gPiA+ID4gYWJpbGl0eSB0byBtYW5hZ2UgdmFyaW91cyBmZWF0dXJl
IGVuYWJsZSBiaXRzLiAgVGhlIFZGIG93bmVyIGRvZXMgbm90DQo+ID4gPiA+IGhhdmUgcHJpdmls
ZWdlcyB0byBtYW5pcHVsYXRlIHRob3NlIGJpdHMuICBGb3IgZXhhbXBsZSwgdGhlIFBBU0lEDQo+
IEVuYWJsZQ0KPiA+ID4gPiBiaXQgc2hvdWxkIHJlc3RyaWN0IHRoZSBlbmRwb2ludCBmcm9tIHNl
bmRpbmcgVExQcyB3aXRoIGEgUEFTSUQgcHJlZml4LA0KPiA+ID4gPiBidXQgdGhpcyBjYW4gb25s
eSBiZSBjaGFuZ2VkIGF0IHRoZSBQRiBsZXZlbCBmb3IgYWxsIGFzc29jaWF0ZWQgVkZzLg0KPiA+
ID4gPg0KPiA+ID4gPiBUaGUgcHJvdG9jb2wgc3BlY2lmaWVkIGluIDcuOC45LjMgZGVmaW5lcyB0
aGlzIGVuYWJsZSBiaXQgYXMgUlcuICBIb3cgZG8NCj4gPiA+ID4gd2UgdmlydHVhbGl6ZSB0aGF0
PyAgRWl0aGVyIGl0J3MgdmlydHVhbGl6ZWQgdG8gYmUgcmVhZC1vbmx5IGFuZCB3ZQ0KPiA+ID4g
PiB2aW9sYXRlIHRoZSBzcGVjIG9yIHdlIGFsbG93IGl0IHRvIGJlIHJlYWQtd3JpdGUgYW5kIGl0
IGhhcyBubyBlZmZlY3QsDQo+ID4gPiA+IHdoaWNoIHZpb2xhdGVzIHRoZSBzcGVjLg0KPiA+ID4g
Pg0KPiA+ID4NCj4gPiA+IEN1cnJlbnRseSB0aGUgUEFTSUQgY2FwIGlzIGVuYWJsZWQgYnkgZGVm
YXVsdCB3aGVuIGEgZGV2aWNlIGlzIHByb2JlZA0KPiA+ID4gYnkgaW9tbXUgZHJpdmVyLiBMZWF2
aW5nIGl0IGVuYWJsZWQgaW4gUEYgd2hpbGUgZ3Vlc3Qgd2FudHMgaXQgZGlzYWJsZWQNCj4gPiA+
IGluIFZGIGlzIGhhcm1sZXNzLiBXL28gcHJvcGVyIHNldHVwIGluIGlvbW11IHNpZGUgdGhlIFZG
IGNhbm5vdA0KPiA+ID4gZG8gcmVhbCB3b3JrIHdpdGggUEFTSUQuDQo+ID4gPg0KPiA+ID4gRnJv
bSB0aGlzIGFuZ2xlIGZ1bGx5IHZpcnR1YWxpemluZyBpdCBpbiBzb2Z0d2FyZSBsb29rcyBnb29k
IHRvIG1lLg0KPiA+DQo+ID4gU28geW91J3JlIHN1Z2dlc3RpbmcgdGhhdCB0aGUgSU9NTVUgc2V0
dXAgZm9yIHRoZSBWRiB0byBtYWtlIHVzZSBvZg0KPiA+IFBBU0lEIHdvdWxkIG5vdCBvY2N1ciB1
bnRpbCBvciB1bmxlc3MgUEFTSUQgRW5hYmxlIGlzIHNldCBpbiB0aGUNCj4gPiB2aXJ0dWFsaXpl
ZCBWRiBQQVNJRCBjYXBhYmlsaXR5IGFuZCB0aGF0IHN1cHBvcnQgd291bGQgYmUgdG9ybiBkb3du
DQo+ID4gd2hlbiBQQVNJRCBFbmFibGUgaXMgY2xlYXJlZD8NCj4gDQo+IE5vIHRoYXQgaXMgbm90
IHRoZSBjYXNlLiBUaGUgSU9NTVUgc2V0dXAgaXMgaW5pdGlhdGVkIGJ5IHZJT01NVQ0KPiBhbmQg
b3J0aG9nb25hbCB0byB0aGUgUEFTSUQgY2FwIHZpcnR1YWxpemF0aW9uLg0KPiANCj4gRm9sbG93
aW5nIHRoZSBjdXJyZW50IElPTU1VIGJlaGF2aW9yIGFzIEJhb2x1IGRlc2NyaWJlZCB0aGUgZ3Vl
c3QNCj4gd2lsbCBhbHdheXMgZW5hYmxlIHZQQVNJRCBpbiB0aGUgdklPTU1VIGRyaXZlci4NCj4g
DQo+IEV2ZW4gaWYgdGhlIGd1ZXN0IGltcGxlbWVudHMgYW4gZHJpdmVyLW9wdCBtb2RlbCBmb3Ig
dlBBU0lEIGVuYWJsaW5nLA0KPiBpbiB0eXBpY2FsIGNhc2UgdGhlIGd1ZXN0IGRyaXZlciB3aWxs
IG5vdCByZXF1ZXN0IHZJT01NVSBzZXR1cCBmb3IgVkYNCj4gUEFTSURzIGlmIGl0IGRvZXNuJ3Qg
aW50ZW5kIHRvIGVuYWJsZSB2UEFTSUQgY2FwLiBJbiB0aGlzIGNhc2UgdGhlDQo+IHBoeXNpY2Fs
IElPTU1VIGlzIGxlZnQgYmxvY2tpbmcgVkYgUEFTSURzIGhlbmNlIGxlYXZpbmcgUEYgUEFTSUQg
ZW5hYmxlZA0KPiBkb2Vzbid0IGh1cnQuDQo+IA0KPiBJZiBhbiBpbnNhbmUgZ3Vlc3QgZHJpdmVy
IGRvZXMgdHJ5IHRvIGVuYWJsZSB2SU9NTVUgUEFTSUQgKHNvIFZGIFBBU0lEcw0KPiBhcmUgYWxs
b3dlZCBpbiBwaHlzaWNhbCBJT01NVSkgd2hpbGUgbGVhdmluZyB2UEFTSUQgZGlzYWJsZWQgaW4g
VkYsDQo+IEknbSBub3Qgc3VyZSB3aGF0IHdvdWxkIGJlIHRoZSBhY3R1YWwgcHJvYmxlbSBsZWF2
aW5nIFBGIFBBU0lEIGVuYWJsZWQuDQo+IFRoZSBndWVzdCBkcml2ZXIga2luZCBvZiB3YW50cyB0
byBmb29sIGl0c2VsZiBieSBhbHJlYWR5IHNldHRpbmcgdXAgdGhlDQo+IGZhYnJpYyB0byBhbGxv
dyBWRiBQQVNJRCBidXQgdGhlbiBibG9jayBQQVNJRCBpbiBWRiBpdHNlbGY/DQo+IA0KPiA+DQo+
ID4gVGhpcyBpcyBzdGlsbCBub3Qgc3RyaWN0bHkgaW4gYWRoZXJlbmNlIHdpdGggdGhlIGRlZmlu
aXRpb24gb2YgdGhlDQo+ID4gUEFTSUQgRW5hYmxlIGJpdCB3aGljaCBzcGVjaWZpZXMgdGhhdCB0
aGlzIGJpdCBjb250cm9scyB3aGV0aGVyIHRoZQ0KPiA+IGVuZHBvaW50IGlzIGFibGUgdG8gc2Vu
ZCBvciByZWNlaXZlIFRMUHMgd2l0aCB0aGUgUEFTSUQgcHJlZml4LCB3aGljaA0KPiA+IGNsZWFy
bHkgdmlydHVhbGl6YXRpb24gaW50ZXJhY3Rpbmcgd2l0aCB0aGUgSU9NTVUgdG8gYmxvY2sgb3Ig
YWxsb3cNCj4gPiBQQVNJRHMgZnJvbSB0aGUgVkYgUklEIGNhbm5vdCBjaGFuZ2UuICBJcyBpdCBz
dWZmaWNpZW50Pw0KPiA+DQo+ID4gRm9yIGV4YW1wbGUgd2UgY2FuJ3QgdXNlIHRoZSB2UEFTSUQg
Y2FwYWJpbGl0eSB0byBtYWtlIGFueSBndWFyYW50ZWVzDQo+ID4gYWJvdXQgaW4tZmxpZ2h0IFBB
U0lEIFRMUHMgd2hlbiBzZXF1ZW5jaW5nIElPTU1VIG9wZXJhdGlvbnMgc2luY2Ugd2UNCj4gPiBj
YW4ndCBhY3R1YWxseSBwcmV2ZW50IFZGcyB1c2luZyBQQVNJRCBzbyBsb25nIGFzIFBBU0lEIEVu
YWJsZSBpcyBzZXQNCj4gPiBvbiB0aGUgUEYuDQo+IA0KPiBJT01NVSBjYXJlcyBhYm91dCBpbi1m
bGlnaHQgUEFTSUQgVExQcyBvbmx5IHdoZW4gaXQncyB1bmJsb2NrZWQuDQo+IA0KPiBJZiBpdCdz
IGFscmVhZHkgYmxvY2tlZCB0aGVuIGl0IGRvZXNuJ3QgbWF0dGVyIHdoZXRoZXIgVkYgaXMgc2Vu
ZGluZyBQQVNJRA0KPiBUTFAgb3Igbm90Lg0KPiANCj4gYnR3IHRoaW5rIGFib3V0IHRoZSBjdXJy
ZW50IHNpdHVhdGlvbi4gRXZlbiBpZiB2ZmlvLXBjaSBkb2Vzbid0IGV4cG9zZQ0KPiBQQVNJRCBj
YXAgdG9kYXksIGl0J3MgcGh5c2ljYWxseSBlbmFibGVkIGJ5IGlvbW11IGRyaXZlciBhbHJlYWR5
LiBUaGVuDQo+IHRoZSBndWVzdCBpcyBhbHJlYWR5IGFibGUgdG8gcHJvZ3JhbSB0aGUgZGV2aWNl
IHRvIHNlbmQgUEFTSUQgVExQJ3MuDQo+IA0KPiBmdWxseSB2aXJ0dWFsaXppbmcgdlBBU0lEIGNh
cCBqdXN0IGFsaWducyB3aXRoIHRoaXMgZmFjdC4g8J+Yig0KPiANCg0KSGksIEFsZXgsDQoNCklm
IHlvdSBhcmUgT0sgd2l0aCBhYm92ZSBleHBsYW5hdGlvbiB3ZSBjYW4gY29udGludWUgZGlzY3Vz
c2luZyBob3cNCnRvIGV4cG9zZSB0aGUgUEFTSUQgY2FwIGZvciBWRi4NCg0KQXQgdGhlIHN0YXJ0
IEkgbGlzdGVkIHNldmVyYWwgb3B0aW9ucyB0byBxdWlyayB0aGUgb2Zmc2V0IGluIHRoZSBrZXJu
ZWwuDQoNCkphc29uIHN1Z2dlc3RlZCB0aGF0IHRoZSBrZXJuZWwgc2hvdWxkIG5vdCBleHBvc2Ug
dGhlIGNhcCB1bmNvbmRpdGlvbmFsbHkuDQoNClRoZW4gSSBwcm9wb3NlZCBpdCBjb3VsZCBiZSBk
b25lIHZpYSBhIGRldmljZSBmZWF0dXJlIGFuZCBsZWF2ZSB0aGUNCm9mZnNldCB0byBiZSBxdWly
a2VkIGluIFZNTS4gWzFdIElzIGl0IGEgcmVhc29uYWJsZSB3YXkgdG8gZ28/DQoNClRoYW5rcw0K
S2V2aW4NCg0KWzFdICBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sL0JOOVBSMTFNQjUyNzZB
RTQzMTgzQTNBQTZBQjgwNkEzOThDNzQ5QEJOOVBSMTFNQjUyNzYubmFtcHJkMTEucHJvZC5vdXRs
b29rLmNvbS8NCg==
