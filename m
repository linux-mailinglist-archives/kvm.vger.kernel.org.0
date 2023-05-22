Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E5170CEF2
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 02:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbjEWACo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 20:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235191AbjEVXar (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 19:30:47 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887A7F1;
        Mon, 22 May 2023 16:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684798244; x=1716334244;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4foQLvTvXeFvWz+kS1Ppa5oRnJY9uY7sriZpj0P1m6g=;
  b=Idw3+3sWo8S7vYHe1QCQtheguGyhl8caV8eIY/1ydp+/YLC1CIPXo3y/
   QeFMAzvQ7d6kDNuM4SRzlHxXePpeMefjDIIHQq2K133ORE8a2Xsw9LbBB
   991hq8kFtB8K8ULttOkr3gcB+elF6vJen3igvx2QrmLEirYCvGbl6hlU6
   jpRY5s9e7Oh/gFOwZIOIf5WIERzi2+uHRX0OAkrUEDVAsCQnig6eswYDe
   p6cWxGfbEWKtvVw78pZTqqTpv56eccAOtAFyBEcGefmrQdYB5/uTIxcr1
   YFmnJE73QZeQdX85XH+7rutua5PBLWD3vz+hRm+oZxQMp8VbgdSnbcJwr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="439425351"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="439425351"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 16:30:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="703721660"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="703721660"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 22 May 2023 16:30:43 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 16:30:43 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 16:30:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 16:30:43 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 16:30:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nUxpixdQq+QaElT9f6Yvcl5S6mLhHBeKX2KY18lmyPc7kQH/nURcNdYaPLCQzo+v3+HSGlZqhYo6idUWSdoM9N6a/Tx67nemiuSzRY2WVcDlGTHlOhi9rePmEluuJ+sXZibEoJCkqnmAmrkyRSvBIsaqX1zZqzIb3sVEu2owklQp6kCyp2BbEfhrgd+xo+VZFRsNKZOGsTQp4+eEo7geqiq2heLtMaPlWeT2q60wAL338djQ+sM+rJz2rRfv4MwXVP8wnXvfirh6mssxca/35Z9ESJv3DEFmTNR5O9MhHfo84FH2IrF9Pj3vRwHXs78sWCg2w6tk7CwD4kdEi/j5rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4foQLvTvXeFvWz+kS1Ppa5oRnJY9uY7sriZpj0P1m6g=;
 b=b6uKHP4Z81KLceIin6da4Z7ROPKGGHOUrirBWFUtCDl2g2FHRe/vwmuf+tlerPeEmFRpMmpYkk9Cr4J6yf6BuNhG7GXOv5Y0TJOhF0SZsCNIF9v5DrMmbeq/3hg0ZpJP4hGg/h9xt0FWpeXxK2lj1OI5Wub7MSz73T6y3UQ1/jbtYSWR6MK2Gc4PmrtdvfpzAPukYe0q6YrZ6ErC9pPQfZYEUygaFvEFx4GQdseTcR6GBZwtLdxbxof3fbaTN9GE434uj+vmaBQ/8gUaDbcWZfKvQIU2VS1uivTTJzdKG8WTg4WHkSa+D6XdDhl3b+UXm79kfOE78oMhAbYqxSmuug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB7714.namprd11.prod.outlook.com (2603:10b6:a03:4fd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 23:30:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 23:30:36 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 15/18] KVM: VMX: Ensure CPU is stable when probing
 basic VMX support
Thread-Topic: [PATCH v3 15/18] KVM: VMX: Ensure CPU is stable when probing
 basic VMX support
Thread-Index: AQHZhSydK91vrj+YiUOw7lt9ygQpeK9nAHWA
Date:   Mon, 22 May 2023 23:30:35 +0000
Message-ID: <379c16f0d81a00afdeba6916c5044c2ffee56071.camel@intel.com>
References: <20230512235026.808058-1-seanjc@google.com>
         <20230512235026.808058-16-seanjc@google.com>
In-Reply-To: <20230512235026.808058-16-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ2PR11MB7714:EE_
x-ms-office365-filtering-correlation-id: 1de84591-3d49-4231-223c-08db5b1c8b6f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wc+05YvmZYt/F+5yvk1wRy7rr1cz/IircxxkFD+C1S0H8ZFBuqbeXRH+PQHdaSZeMyOZgA/QwHElI28UwLZSIgKjDMVX5Y40KmRKoFeznuafVS2uu3kvrXbwVD0ap3HjlQwyPnPcG1/FY7J4Cn51rgq1K+SwLb9amnNUZirhLkFiSdh3eT2NnN8mUZulL8ekiDLyzT1b0JAW84o8AUvsVVTnOotWkEatVvhr+nlYspwhrJyEEiMUDrRi84DfzzJ0YX8kTKKT6YQ/2RN1XrsTkEVx8oAAsigqNJ32+G/vSiDV05DqWFJnidyDC6QAMaekvAW8hbKyWECV0mZS4tHAe4Y+uslgYk7BMx4tvOMKhKCVzitIg5x2gWhvaBkawR8H+E+9t2OctIixbe/Ql0tReDcJJXAL2JWwUE4kmfLTnTa7TkejCfj4IAYga9IQPOeD7+D8kV2m8bgi7hIHjEdGi3PiBKZNqM9qyca8ad0K4UcQfWVf+2aRtpJ2yTlm7iRz7iGU1H/h729xCLuaAMVFlnpypPMaBDdvrV4F0En3l+ajJDKEj0bvGMbRtYTc/skn5/diN/fup2bb4gkrekBKu9SQf42EajtZLFhQI0HFY3be5IyDrUlZI/KDILM2OKQW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199021)(71200400001)(2906002)(6486002)(38070700005)(91956017)(82960400001)(66446008)(64756008)(76116006)(66556008)(54906003)(66946007)(66476007)(110136005)(478600001)(2616005)(8676002)(122000001)(38100700002)(8936002)(36756003)(41300700001)(5660300002)(4326008)(86362001)(316002)(6506007)(26005)(83380400001)(186003)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dXRaMS9nWUtlQmVRMWlRU2RHZHRkdDZBMjNDSlVUVWVPcXExb0p1ZVlYNVA5?=
 =?utf-8?B?bTMxYnVUaVorZk0xWDc0R0UvNkZCWlYvWGZoVzVKRlZyc0ltY0ZLaEpYNThI?=
 =?utf-8?B?ekkxNHI0cU14aHJ3aUhLSkhEN2J6VDVFanIxS0pOOGhOTm5iYlJLeEtSTUNB?=
 =?utf-8?B?QVBvRW4rNW5pRG1PMGFKS1M2ZkpWNTNmM1ZzanJBdVRPSWxPejJLa1VRNWlK?=
 =?utf-8?B?VEdoT0FRWlRhYUlDa2prdE5iTTBGK1ppSGlZblJOTmREQ1pEeElDQ01GUW5Y?=
 =?utf-8?B?UnRzbDYrNmVKaEx0Tk5IbTlIb0FvU2g3Q04ycFlNY3Y2WVQrWGR1VjVEVnM1?=
 =?utf-8?B?OUdXZzR2MVo4S3R3bjlDZTRubUtlVVlWZEMvSG9WN2pEamZUTnFTWUtVdmJP?=
 =?utf-8?B?REdWY3hwWnNlNE1MQWlMNTJXK1NGOGpKMDdtTVMzd0ZEOXRrNUV0Y0dEdDIz?=
 =?utf-8?B?U2NCZXVwODYwRS9XYVpwVW1vUkMwdTQwb3VaQm4rMHZaYngzUGQvYzQ4ZXl2?=
 =?utf-8?B?Y0tITUNnRXRVbGhUTjZxOXdBSGtoYUtOSUh1TXhSS0xRa0hDNUE3aFYxK3hy?=
 =?utf-8?B?MEFBUldhSlhqZ2UwK1NhcXo4eTVrRzI4RWdNd2cvVXIyVktOWG4rVUtaK054?=
 =?utf-8?B?WXhwUzNMd2l3Zm1HbHpXeUx6YUpFaE81ZlRUYlB4MFQyTFphdFdMRmRIZU9u?=
 =?utf-8?B?Y3ZVSEVMRlRKVkNBMENoTE1DeUNHay9PZm01d1RyT2gvMFpzQm4rdHZMckFi?=
 =?utf-8?B?ZFoxWEdQeEVpMGp3TlJkYU5RNm1LYU9PSTVCZytqYVd0cDdTakJTYXJ5MDlt?=
 =?utf-8?B?djl2OUg1RFYyZ2dCclFJcVZZSGVMbHFpTTdWMkY4R2plR0pQOFNyeTUzSit2?=
 =?utf-8?B?OXJ3SElheGUwOW43d1owMTBxRjRvNVpvRHh5VExyKzFTQ3Zzb01qRlo1WHhN?=
 =?utf-8?B?djc3MzlmTVBWcWNOMC94RXBSZEtFZGFBUS82UGxKTGMvbVdJanpHais0Mkdk?=
 =?utf-8?B?Sm1YTFl6MjZlc1NOYVhkNDZVYzQ5V2Nsb1ppcmw1WXBIVUxpdStZM0JVQnd5?=
 =?utf-8?B?a2FFL1BML2ZJdksxRExiNFRzcG12VWJBRnd5elFVQ2RhdnRzWnBDWUNVRE9a?=
 =?utf-8?B?cGVpZERJb0FJVXFER1krT3YyWnNFOVN2eVZIV0YyakdhVDBvbTNFRWdtRFdN?=
 =?utf-8?B?elA2L2E0eS9NazFhSW9idHdzbTN4MytydGlIS0pjdE9nb3JYbmJmK0haTHh4?=
 =?utf-8?B?VE9wSS8vb2djZm0rL1Z6TlRlQ21TM0orQzJsMzJPWnlEcWFaQWtrd0lJNkl6?=
 =?utf-8?B?ME56QUM4aVQrK1pYL01PZlAyZ1pSS3ZDczJJaXBlY2JCcUljVzQ5QVlWNlRq?=
 =?utf-8?B?aVA0bjdJRnFIT05UNEg2R2IxNCtIQnNHM0FES2ZWUmlobnVJL21SMjVOMXF0?=
 =?utf-8?B?MldPVncxZVhNaHNLNFdwaGpqTVdlUmN5ZmxDL1RrWmxCbVN2c0ZUQjFpdkRN?=
 =?utf-8?B?cGQrKzIyc05USGJsKzdWMnh2ZVo3UGlNeTVua0wvclI3WGpRRjRpdzRxSCta?=
 =?utf-8?B?RzFXVFV3QnBwSkFKSXU3bVkrUFlOZFkvU2d0ajNHYWxGdkpKdW5XUXhERUl4?=
 =?utf-8?B?TThUVlFKUTJmVGY4WmNBd25FUUU0UnVxQVU3aUlUaW1ubWFCeE5lamhYRWhm?=
 =?utf-8?B?TlUya0ZTalVFZGxsSmJsWXNJRldpYjlUcVlzNUJSc1VXZmlhdlR6NDZGcmhJ?=
 =?utf-8?B?dnBldm1Fb3laVWFHQlJUZDZXQ2d4VVhqY05ya1B1SmpSU3p5dDc3VHltTEJB?=
 =?utf-8?B?RW1FZ3h6Mjlnei9iaUZUeG5xSk8zb2YxeHZnajh3STAvQlF4SndmcXZjTkJ1?=
 =?utf-8?B?YmtiY05FMlNhbXB0WEhDY2dPOVBWY2pwMDQ1a0kvd2pOWHhuTnE1Zyt4aHpx?=
 =?utf-8?B?UkVkcyt5Z0kvSEhubDcvQUNDbEdLN3kvbmJrRW43NGNZYnBVdW81MmxUcC8r?=
 =?utf-8?B?WmZCMmtTOFZZQ3dieVBkWDlTVFJVbjRhcUhyVlNicU5VT3MrS2k4ZVF5RjFJ?=
 =?utf-8?B?R2ZybVF1ZVhxYzFJWEFKR3YzelF4TjM0V2FLcm95eWVlcW0rbmRyNm1wTEho?=
 =?utf-8?B?WVhzYmRLTVdpdUhZQUZKcU00MHJwRzIvNTE2Ulp3UC9pNnc0QTV3bVJJdXV4?=
 =?utf-8?B?N2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <883F9335A8CE304AA77279DC84CB40CE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de84591-3d49-4231-223c-08db5b1c8b6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 23:30:35.9063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4gtGE3XKa02IQG1aSN1D3M+susoqDwcJlnASEX2AGSfKsJ3TsHRC8nCQKcuBq5caTFk3rAO5WnRM9THUshYW1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7714
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA1LTEyIGF0IDE2OjUwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBEaXNhYmxlIG1pZ3JhdGlvbiB3aGVuIHByb2JpbmcgVk1YIHN1cHBvcnQgZHVyaW5n
IG1vZHVsZSBsb2FkIHRvIGVuc3VyZQ0KPiB0aGUgQ1BVIGlzIHN0YWJsZSwgbW9zdGx5IHRvIG1h
dGNoIHNpbWlsYXIgU1ZNIGxvZ2ljLCB3aGVyZSBhbGxvd2luZw0KPiBtaWdyYXRpb24gZWZmZWN0
aXZlIHJlcXVpcmVzIGRlbGliZXJhdGVseSB3cml0aW5nIGJ1Z2d5IGNvZGUuICBBcyBhIGJvbnVz
LA0KPiBLVk0gd29uJ3QgcmVwb3J0IHRoZSB3cm9uZyBDUFUgdG8gdXNlcnNwYWNlIGlmIFZNWCBp
cyB1bnN1cHBvcnRlZCwgYnV0IGluDQo+IHByYWN0aWNlIHRoYXQgaXMgYSB2ZXJ5LCB2ZXJ5IG1p
bm9yIGJvbnVzIGFzIHRoZSBvbmx5IHdheSB0aGF0IHJlcG9ydGluZw0KPiB0aGUgd3JvbmcgQ1BV
IHdvdWxkIGFjdHVhbGx5IG1hdHRlciBpcyBpZiBoYXJkd2FyZSBpcyBicm9rZW4gb3IgaWYgdGhl
DQo+IHN5c3RlbSBpcyBtaXNjb25maWd1cmVkLCBpLmUuIGlmIEtWTSBnZXRzIG1pZ3JhdGVkIGZy
b20gYSBDUFUgdGhhdCBfZG9lc18NCj4gc3VwcG9ydCBWTVggdG8gYSBDUFUgdGhhdCBkb2VzIF9u
b3RfIHN1cHBvcnQgVk1YLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNv
biA8c2VhbmpjQGdvb2dsZS5jb20+DQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFu
Z0BpbnRlbC5jb20+DQoNCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0vdm14L3ZteC5jIHwgMTcgKysr
KysrKysrKysrKystLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAzIGRl
bGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMgYi9h
cmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+IGluZGV4IGUwMGRiYTE2NmE5ZS4uMDA4OTE0Mzk2MTgw
IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+ICsrKyBiL2FyY2gveDg2
L2t2bS92bXgvdm14LmMNCj4gQEAgLTI3NDAsOSArMjc0MCw5IEBAIHN0YXRpYyBpbnQgc2V0dXBf
dm1jc19jb25maWcoc3RydWN0IHZtY3NfY29uZmlnICp2bWNzX2NvbmYsDQo+ICAJcmV0dXJuIDA7
DQo+ICB9DQo+ICANCj4gLXN0YXRpYyBib29sIGt2bV9pc192bXhfc3VwcG9ydGVkKHZvaWQpDQo+
ICtzdGF0aWMgYm9vbCBfX2t2bV9pc192bXhfc3VwcG9ydGVkKHZvaWQpDQo+ICB7DQo+IC0JaW50
IGNwdSA9IHJhd19zbXBfcHJvY2Vzc29yX2lkKCk7DQo+ICsJaW50IGNwdSA9IHNtcF9wcm9jZXNz
b3JfaWQoKTsNCj4gIA0KPiAgCWlmICghKGNwdWlkX2VjeCgxKSAmIGZlYXR1cmVfYml0KFZNWCkp
KSB7DQo+ICAJCXByX2VycigiVk1YIG5vdCBzdXBwb3J0ZWQgYnkgQ1BVICVkXG4iLCBjcHUpOw0K
PiBAQCAtMjc1OCwxMyArMjc1OCwyNCBAQCBzdGF0aWMgYm9vbCBrdm1faXNfdm14X3N1cHBvcnRl
ZCh2b2lkKQ0KPiAgCXJldHVybiB0cnVlOw0KPiAgfQ0KPiAgDQo+ICtzdGF0aWMgYm9vbCBrdm1f
aXNfdm14X3N1cHBvcnRlZCh2b2lkKQ0KPiArew0KPiArCWJvb2wgc3VwcG9ydGVkOw0KPiArDQo+
ICsJbWlncmF0ZV9kaXNhYmxlKCk7DQo+ICsJc3VwcG9ydGVkID0gX19rdm1faXNfdm14X3N1cHBv
cnRlZCgpOw0KPiArCW1pZ3JhdGVfZW5hYmxlKCk7DQo+ICsNCj4gKwlyZXR1cm4gc3VwcG9ydGVk
Ow0KPiArfQ0KPiArDQo+ICBzdGF0aWMgaW50IHZteF9jaGVja19wcm9jZXNzb3JfY29tcGF0KHZv
aWQpDQo+ICB7DQo+ICAJaW50IGNwdSA9IHJhd19zbXBfcHJvY2Vzc29yX2lkKCk7DQo+ICAJc3Ry
dWN0IHZtY3NfY29uZmlnIHZtY3NfY29uZjsNCj4gIAlzdHJ1Y3Qgdm14X2NhcGFiaWxpdHkgdm14
X2NhcDsNCj4gIA0KPiAtCWlmICgha3ZtX2lzX3ZteF9zdXBwb3J0ZWQoKSkNCj4gKwlpZiAoIV9f
a3ZtX2lzX3ZteF9zdXBwb3J0ZWQoKSkNCj4gIAkJcmV0dXJuIC1FSU87DQo+ICANCj4gIAlpZiAo
c2V0dXBfdm1jc19jb25maWcoJnZtY3NfY29uZiwgJnZteF9jYXApIDwgMCkgew0KPiAtLSANCj4g
Mi40MC4xLjYwNi5nYTRiMWIxMjhkNi1nb29nDQo+IA0KDQo=
