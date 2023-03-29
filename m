Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B266CF6CA
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 01:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjC2XRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 19:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjC2XRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 19:17:46 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707EF5272;
        Wed, 29 Mar 2023 16:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680131857; x=1711667857;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hzIVbXTDmI4lZDAPW14JvTFa+d0DQe1boXakn8TbpEY=;
  b=RzbN8H7d3Gtbu9eStOf9wpsW++bUA7NAcWxXq7QjMnN5hin9q7AChvlr
   V1yx3ZoiJuvwrMsXo+o2rxLCfsQxVuSrWl0lIipR6xirztvOuy+Z1TB2Q
   By1otmb/4Ow0I6oVCHh9y6xxq9qbdok9vbL7/uBsWS/9lOUxahn67HjN1
   /VUZzyQxbRWNILEBZC137kZR2CKrPLaizBtnSSL0l5J8F57ueSrybwZAB
   78ILNUf4MuQKZvCjynTQW8VFffYFE3LhWk4kPqP4rpTOxtcXCKa6g5ryc
   /l3SINrQB7VpaZEAd/gJ3M4yde6uzXSClsh0f17iH8QnBOGbVjBjuED9C
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="341039909"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="341039909"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 16:17:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="795440236"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="795440236"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 29 Mar 2023 16:17:36 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 16:17:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 16:17:35 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 29 Mar 2023 16:17:35 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 29 Mar 2023 16:17:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCY3q3PLK8BOs6HLfiVRgzvinoU8N6JQdmRW8YCkyJZ/vS9TaY9v9pgsd/O6A+g3oCFFYt9S/EYO5UUJsz4guLtGm3aQfIZyFb/DIczSaFbcLKuyS26g1r4+ZqKzeVUFVkSjWOiwCxV7o26xypUvqwwrBKdFEJUtomP8DZObQ81Y2dH+jc5A6i0A0H+TcqYPiG6XzAALdc388Kwvp5p70xQv6fC8AfV2xXRKzLhMLxAxwPgkzgkav8nSu2+aPvN3jtTPjuV7S+SlO37id3NeP1yzKLpAd2k1ESCq5zGyb/m3/Ds1esB4MS7rFnP7MyV0Mp6lDLEO5TdIahpAZJ/c0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hzIVbXTDmI4lZDAPW14JvTFa+d0DQe1boXakn8TbpEY=;
 b=AtIDIVOAUHX8WTNnE5LxIG4OMm43EZG9YlqSPjcic6k5R0SPJCbDXKSbFSrB/H1w2E6Jufl5h99ITLF7GlJ6IDdiqjs2qXPhCaxNVujnVY213NQjOGXJxHd1hnA32/+EBZSYMSwK4UqB+C2rVv+SO8RBs1oGWTyA11e6AJ+PGU8j0ZBEcmkZ0qyU/TqTwDfnt2ROHyxFas4B8dGon8y95Od1h1R6JIadwhGUoDrGO68NHPmF6h5fJB1a+r1yHlupzFVOo1JQkyoN3d36W3KQo9JxylzT54NGHBE5/h8xLQ1nV6AffyWn3zwxJBoIrCZFxaw42XykYja/LNi+SZyXoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW3PR11MB4587.namprd11.prod.outlook.com (2603:10b6:303:58::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Wed, 29 Mar
 2023 23:17:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%6]) with mapi id 15.20.6178.038; Wed, 29 Mar 2023
 23:17:32 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v13 003/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v13 003/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHZVQwsPOGReWj5Uka2uRq42SaKMa75keeAgAHjHYCAACbFgIAA9iwAgA0+bwCAByfygIAAFPmAgAFbIoCAABa5gA==
Date:   Wed, 29 Mar 2023 23:17:31 +0000
Message-ID: <f02637a56848cff1a39a2c7e2350c11b180a87ea.camel@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
         <44f7fe9f235e29f2193eaac5890a4dede22c324c.1678643052.git.isaku.yamahata@intel.com>
         <20ebae70fd625f8a0fe87f98c25613a2d4dc5792.camel@intel.com>
         <20230315072711.GF3922605@ls.amr.corp.intel.com>
         <8ee89a1376babf0a5dbc2feb614890b7e2ccf2f8.camel@intel.com>
         <20230316002702.GA197448@ls.amr.corp.intel.com>
         <3ebe8d34ecf199b924f4892ce911077005526628.camel@intel.com>
         <20230328235839.GA1069687@ls.amr.corp.intel.com>
         <5896fb851d20de4aab55307a73e2b4a4243ca155.camel@intel.com>
         <20230329215609.GB1069687@ls.amr.corp.intel.com>
In-Reply-To: <20230329215609.GB1069687@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW3PR11MB4587:EE_
x-ms-office365-filtering-correlation-id: b654094c-a993-4e19-bd40-08db30abc5cc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o7wgsgxvt1R8XG9BL078/QgYT4e86vGqM7SF6V4Sg/Mn4IGA4+gFcCgL1OhRXN0Kce5ykiN8FjySFhJwA42jNdsCZ5aiLaVJrIQ4HnSWfDawOMrUSlu7pwSkXjUWjdysce4L5UZ21DAcLBh9ujrvrjU2tQ55v+SQnovEieGg6lpb6SILeF6TNDPNDXAoS45VJh60PRUj8hD58Z1px7fEOTAi0DVqgrB+B0jnR40wT0I2wbRLgEO6rf1JfYJjKAN3upxGSrAG9q1W00f716ZAJxvYerCSyR8JudCIDx9rNOA1OWJFdSQ/FSCp41fzHfqhvsOF2b/x1VDPk527S+3z8ehKr2Xk85ufORweEMqxiTfrvj4Um+kRLwMWn6bXNjCiUypF7bTfW6yWD9MieswZ0C52mCHf4o/+Ys1LSwk4gRGc28rnPMFKS93CrJYPvNEwjJwl9vtN8OpHoDTZiGwpa+h0cEkuH5hzje8cDVn+zWSbOx3eyZ+TS6n4FVhjDR9V3M11aFr64ZUetRAvr459L4gn6Zsy4PgVnxIbz/8Tq71qgPrYz3JffxQwcKYC7tSXsdwWXEfDvid0uLtLJCJkKr8ome7iyy0F407uah3MJM6l8UyS2kjtcBVK2brXY42G4vyf6ZxKrrtErz+613h9xg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(39860400002)(376002)(396003)(346002)(451199021)(186003)(2616005)(83380400001)(6512007)(107886003)(2906002)(6506007)(26005)(86362001)(38070700005)(38100700002)(36756003)(122000001)(82960400001)(66556008)(41300700001)(91956017)(5660300002)(54906003)(64756008)(66476007)(76116006)(316002)(478600001)(8936002)(71200400001)(66946007)(4326008)(6916009)(66446008)(8676002)(6486002)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?clRSNUdCekhIMThlaGZkOFdWWVorU1kxbTR0dzlVbFcvUFl1Y3A0OFRBdUVD?=
 =?utf-8?B?TnNrSDVxMGxoNzFsNURsRUdmRW9MaUthQXhqcE5heGNiWG5hTGRkd1V5d0JU?=
 =?utf-8?B?R3U2Nnl4dlBGZ09lZW1tYTZTS1pEcEY0dk5LaGJVUHZZTmxTdEczOHpyMVJG?=
 =?utf-8?B?cHRRTHhua3RrNXlUUWY1ZkdLRVpsRSthRUVhaFQ5KzhyQjBHNU9YenJJbUdJ?=
 =?utf-8?B?elRodkkyUHF4TXluTWtGY1h5R21EeGF1Vk5FRDdMd3B2TlF1cUEvSlN5OVRO?=
 =?utf-8?B?UllUMitHUlJpU0J5OTNMNkZ0Qm5udnNwR2FDNEREZWM0SGdPOWY3NlU1NnVI?=
 =?utf-8?B?amthaXBIcDV0Z3BOdnIrV1Q5VXMzd1N3bmJzZWxmcy9FU0J4QUF0S3RFQVgz?=
 =?utf-8?B?UndqZTNUVEtpN1pUdnV4bFJ3OFhtajJwa3pqcW5kQnZkWDMveHZkVnlVK3N6?=
 =?utf-8?B?N3k1ZEJDK2puMXEyY0NBUmM0WG5aU3hpOWZRMkl1SUZVZVV5VTVVNEJ4QmZQ?=
 =?utf-8?B?K3Jxa0xqTmorNVBGN3N0bzNiUGwvTTdZYU5hTzFEcGpGTkxQQmFZZkVXZ1I0?=
 =?utf-8?B?TWdITUsrRWpyUWpOK2YxcHRNamk0S2FFRXZmV0xRUTY3ZlR1VXBYREZ4d2RM?=
 =?utf-8?B?MnlCb3kzRmt4VC84U2JydnRYQWMxMGtGMUFpbzJKL0JRMmRzZ0ZLUEdZKzg4?=
 =?utf-8?B?bkRLeU9HSWI2TUNnaFVzSEFwN2VSUDlvMlZNdmVZWTZ2Ync3aVA2YkE1cUVQ?=
 =?utf-8?B?RExhaDJqQzV2MFlTU0lMeTE4QnZQWERIYW4xRG15UDMxeEhKZWk2NGNSckVh?=
 =?utf-8?B?V251cGljWlpTYnF3N0FMOGlkQTNPdDlhQ2xHWFZneWFoZDk1Y0wycUhqdDZS?=
 =?utf-8?B?MGNNd1I0TUVkWXlJUVNNSVVlTGNRWUQ5bkNKcVAzUG1jbVJoTmY1amdtQi9v?=
 =?utf-8?B?SlBQZHBjSEFjY1VKM1ArS0VOU3VMRGt4ZEpaM0JPRTFoS2xPZExyb1A0UVJE?=
 =?utf-8?B?cERORzVTbGwrdll1ZDQxcTRhR1hKODFRWW0rRHYxOHpOVEZIeEtZNCtwckNu?=
 =?utf-8?B?aU5jM25nVFhiclNiRk52bzcvOXpOVDFjaEZMaE5MUVR2aDlSNFU4SEF5djVS?=
 =?utf-8?B?RHFva2ExbkpSTWlVK0VhL2dYNFFHQ3ppTTFWV2ZwbjdQdU00TmFTU1IwcWdp?=
 =?utf-8?B?VXQyaGZDbGh3OHZaS3FidUl1T001SGhkQTdiQkxsU1p1R1FpMTVRVHNPcWlH?=
 =?utf-8?B?ZUhLTnRuSWFwa2U5K0lESFMyZm5kZjBNdXBWNktPKzJFYXVQVGllTkpkNnpY?=
 =?utf-8?B?SHBpditQajR5bHFuNkxSUGNkNzM3YWlqNXZWelhPdklBM3o2Y205U0czQVFu?=
 =?utf-8?B?b3ZkTkZvK2ZUWWJWeDlMeHcvTFl6ZkZGaWZRTlVUWjQvZG5Qak5GaFN6Zm55?=
 =?utf-8?B?VTFxNHhkQ1dic1oyTExuUzVCS0pPMjBJL04zOWVaUzNrdjNRZ0V4bWZUNzJa?=
 =?utf-8?B?MncvdFZ5UEQvanZCRW9wQlpOS2wrMVkwbjlJNWdFZ29jQWdnVGRzWDFpT0Jr?=
 =?utf-8?B?MDc4WkptVFlDQVkvOGVnajJ3SlZpVk5yR2Y3REU3alZUY084YmJYOEorQjZs?=
 =?utf-8?B?QmtYTjVqTmlkc2tYeTZkSTQvcytBcE1BMEw3czR4V2JpcTV5eFM1QTNPbjhR?=
 =?utf-8?B?a2xTMkk4SmRwN3RlbHJkeGo1c05uSFpVK0ZqSkxrWTlxU3h4Z0pXWWNuZTBW?=
 =?utf-8?B?UmRLeVRYaDFVQzFUVG9xdktURWdiS0h0U0VUNkRXUnplVTIyOWFPWXI5dVd6?=
 =?utf-8?B?R0NiNStjOHVJUHhjQWwzczA2WWFkRzlMaW9obmNJNUJ1Nkw5ZHoxOWd2K3FW?=
 =?utf-8?B?VS9GalBzMGVXa05HOFlkUzZPZytpVEFaYndKdnBWelgvTkY2NzdXTkJDR3dP?=
 =?utf-8?B?U3lQQ1JKcTllUndDYXExYVdBeWpMREpGQ2VVczVOcWV2UTl4YlBtQlY4TlI0?=
 =?utf-8?B?dUZoNVZyelJaYWkyTFFxZWxkM21rWGY5UFhLcEZpOEpKbStMYlJ3VUtXWkxB?=
 =?utf-8?B?UVBUNkU2TUgvOTRRZWNyUnhFV1dSaHdLMExBRWxMU0lRT3ZDODBXbHQ1Nkwx?=
 =?utf-8?Q?ZTa1SBAijP3ZFh6x5PMf0iXpQ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C307EF65FC72844D9F5828B98C11A139@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b654094c-a993-4e19-bd40-08db30abc5cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 23:17:31.8814
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HoawrSHsnnrA2XrGTWG0YfD+EPnn8Ovuspdj9T5mD5jpqdlYa+R0N1PJfdRJJKgTjxHZOKtsBYlxoicRcleF5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4587
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTAzLTI5IGF0IDE0OjU2IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gV2VkLCBNYXIgMjksIDIwMjMgYXQgMDE6MTM6NDVBTSArMDAwMCwNCj4gIkh1YW5nLCBL
YWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gPiANCj4gPiA+ID4gPiAg
DQo+ID4gPiA+ID4gKwkvKg0KPiA+ID4gPiA+ICsJICogVERYIHJlcXVpcmVzIHRob3NlIG1ldGhv
ZHMgdG8gZW5hYmxlIFZNWE9OIGJ5DQo+ID4gPiA+ID4gKwkgKiBrdm1faGFyZHdhcmVfZW5hYmxl
L2Rpc2FibGVfYWxsKCkNCj4gPiA+ID4gPiArCSAqLw0KPiA+ID4gPiA+ICsJc3RhdGljX2NhbGxf
dXBkYXRlKGt2bV94ODZfY2hlY2tfcHJvY2Vzc29yX2NvbXBhdGliaWxpdHksDQo+ID4gPiA+ID4g
KwkJCSAgIG9wcy0+cnVudGltZV9vcHMtPmNoZWNrX3Byb2Nlc3Nvcl9jb21wYXRpYmlsaXR5KTsN
Cj4gPiA+ID4gPiArCXN0YXRpY19jYWxsX3VwZGF0ZShrdm1feDg2X2hhcmR3YXJlX2VuYWJsZSwN
Cj4gPiA+ID4gPiArCQkJICAgb3BzLT5ydW50aW1lX29wcy0+aGFyZHdhcmVfZW5hYmxlKTsNCj4g
PiA+ID4gPiArCXN0YXRpY19jYWxsX3VwZGF0ZShrdm1feDg2X2hhcmR3YXJlX2Rpc2FibGUsDQo+
ID4gPiA+ID4gKwkJCSAgIG9wcy0+cnVudGltZV9vcHMtPmhhcmR3YXJlX2Rpc2FibGUpOw0KPiA+
ID4gPiA+ICAJciA9IG9wcy0+aGFyZHdhcmVfc2V0dXAoKTsNCj4gPiA+ID4gPiAgCWlmIChyICE9
IDApDQo+ID4gPiA+ID4gIAkJZ290byBvdXRfbW11X2V4aXQ7DQo+ID4gPiA+IA0KPiA+ID4gPiBI
bW0uLiBJIHRoaW5rIHRoaXMgaXMgdWdseS4gIFBlcmhhcHMgd2Ugc2hvdWxkIG5ldmVyIGRvIGFu
eQ0KPiA+ID4gPiBzdGF0aWNfY2FsbChrdm1feDg2X3h4eCkoKSBpbiBoYXJkd2FyZV9zZXR1cCgp
LCBiZWNhdXNlIGhhcmR3YXJlX3NldHVwKCkgaXMNCj4gPiA+ID4gY2FsbGVkIGJlZm9yZSBrdm1f
b3BzX3VwZGF0ZSgpIGFuZCBtYXkgdXBkYXRlIHZlbmRvcidzIGt2bV94ODZfb3BzLg0KPiA+ID4g
PiANCj4gPiA+ID4gU28gcHJvYmFibHkgdXNlIGhhcmR3YXJlX2VuYWJsZV9hbGwoKSBpbiBoYXJk
d2FyZV9zZXR1cCgpIGlzIGEgYmFkIGlkZWEuDQo+ID4gPiA+IA0KPiA+ID4gPiBJIHRoaW5rIHdl
IGhhdmUgYmVsb3cgb3B0aW9ucyBvbiBob3cgdG8gaGFuZGxlOg0KPiA+ID4gPiANCj4gPiA+ID4g
MSkgVXNlIFZNWCdzIGt2bV94ODZfb3BzIGRpcmVjdGx5IGluIHRkeF9oYXJkd2FyZV9zZXR1cCgp
LiAgRm9yIGluc3RhbmNlLA0KPiA+ID4gPiBzb21ldGhpbmcgbGlrZSBiZWxvdzoNCj4gPiA+ID4g
DQo+ID4gPiA+IGludCBfX2luaXQgdGR4X2hhcmR3YXJlX3NldHVwKHN0cnVjdCBrdm1feDg2X29w
cyAqeDg2X29wcykNCj4gPiA+ID4gew0KPiA+ID4gPiAJLi4uDQo+ID4gPiA+IA0KPiA+ID4gPiAJ
Y3B1c19yZWFkX2xvY2soKTsNCj4gPiA+ID4gCXIgPSBvbl9lYWNoX2NwdSh2dF94ODZfb3BzLmhh
cmR3YXJlX2VuYWJsZSwgLi4uKTsNCj4gPiA+ID4gCWlmICghcikNCj4gPiA+ID4gCQlyID0gdGR4
X21vZHVsZV9zZXR1cCgpOw0KPiA+ID4gPiAJb25fZWFjaF9jcHUodnRfeDg2X29wcy5oYXJkd2Fy
ZV9kaXNhYmxlLCAuLi4pOw0KPiA+ID4gPiAJY3B1c19yZWFkX3VubG9jaygpOw0KPiA+ID4gPiAN
Cj4gPiA+ID4gCS4uLg0KPiA+ID4gPiB9DQo+ID4gPiA+IA0KPiA+ID4gPiBCdXQgdGhpcyBkb2Vz
bid0IGNsZWFuIHVwIG5pY2VseSB3aGVuIHRoZXJlJ3Mgc29tZSBwYXJ0aWN1bGFyIGNwdXMgZmFp
bCB0byBkbw0KPiA+ID4gPiBoYXJkd2FyZV9lbmFibGUoKS4gIFRvIGNsZWFuIHVwIG5pY2VseSwg
d2UgZG8gbmVlZCBhZGRpdGlvbmFsIHRoaW5ncyBzaW1pbGFyIHRvDQo+ID4gPiA+IHRoZSBoYXJk
d2FyZV9lbmFibGVfYWxsKCkgY29kZSBwYXRoOiBhIHBlci1jcHUgdmFyaWFibGUgb3IgYSBjcHVt
YXNrX3QgKyBhDQo+ID4gPiA+IHdyYXBwZXIgb2YgdnRfeDg2X29wcy0+aGFyZHdhcmVfZW5hYmxl
KCkgdG8gdHJhY2sgd2hpY2ggY3B1cyBoYXZlIGRvbmUNCj4gPiA+ID4gaGFyZHdhcmVfZW5hYmxl
KCkgc3VjY2Vzc2Z1bGx5Lg0KPiA+ID4gPiANCj4gPiA+ID4gMikgTW92ZSB0aG9zZSBzdGF0aWNf
Y2FsbF91cGRhdGUoKSBpbnRvIHRkeF9oYXJkd2FyZV9zZXR1cCgpIHNvIHRoZXkgYXJlIFREWA0K
PiA+ID4gPiBjb2RlIHNlbGYtY29udGFpbmVkLiAgQnV0IHRoaXMgd291bGQgcmVxdWlyZSBleHBv
c2luZyBrdm1feDg2X29wcyBhcyBzeW1ib2wsDQo+ID4gPiA+IHdoaWNoIGlzbid0IG5pY2UgZWl0
aGVyLg0KPiA+ID4gPiANCj4gPiA+ID4gMykgSW50cm9kdWNlIGFub3RoZXIga3ZtX3g4Nl9pbml0
X29wcy0+aGFyZHdhcmVfcG9zdF9zZXR1cCgpLCB3aGljaCBpcyBjYWxsZWQNCj4gPiA+ID4gYWZ0
ZXIga3ZtX29wc191cGRhdGUoKS4NCj4gPiA+ID4gDQo+ID4gPiA+IFBlcnNvbmFsbHksIEkgdGhp
bmsgMykgcGVyaGFwcyBpcyB0aGUgbW9zdCBlbGVnYW50IG9uZSwgYnV0IG5vdCBzdXJlIHdoZXRo
ZXINCj4gPiA+ID4gU2Vhbi9QYW9sbyBoYXMgYW55IG9waW5pb24uDQo+ID4gPiANCj4gPiA+IEkg
dGhpbmsgd2UgY2FuIHNpbXBseSB1cGRhdGUgdGhlIG9wcyBiZWZvcmUgY2FsbGluZyBoYXJkd2Fy
ZV9lbmFibGUoKSBhbmQNCj4gPiA+IGNsZWFuIHVwIG9wcyBvbiBmYWlsdXJlLg0KPiA+ID4gDQo+
ID4gPiANCj4gPiANCj4gPiBUaGlzIGRvZXNuJ3Qgd29yayBiZWNhdXNlIGhhcmR3YXJlX3NldHVw
KCkgbWF5IHVwZGF0ZSB2ZW5kb3IncyBrdm1feDg2X29wcy4NCj4gPiANCj4gPiBJZiB5b3UgZG8g
a3ZtX29wc191cGRhdGUoKSBiZWZvcmUgaGFyZHdhcmVfc2V0dXAoKSwgeW91IG5lZWQgdG8gbWFu
dWFsbHkgdXBkYXRlDQo+ID4gdGhvc2UgdXBkYXRlZCAoaW4gaGFyZHdhcmVfc2V0dXAoKSkgY2Fs
bGJhY2tzIGFnYWluIGFmdGVyLiANCj4gDQo+IFdlIGNhbiBjYWxsIGt2bV9vcHNfdXBkYXRlKCkg
dHdpY2UgYmVmb3JlIGFuZCBhZnRlciBoYXJkd2FyZV9zZXR1cCgpLg0KPiANCg0KUGVyc29uYWxs
eSBJIHRoaW5rIGl0J3MgdG9vIHVnbHkuICANCg==
