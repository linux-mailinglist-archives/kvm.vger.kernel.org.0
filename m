Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE776C127D
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 14:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjCTNAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 09:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbjCTM7p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 08:59:45 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073E810C4;
        Mon, 20 Mar 2023 05:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679317183; x=1710853183;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GXmLe9T37WQn+UocXYmbNq289cLGj3aED0/hPO5v/zk=;
  b=f11XXnN7egHV9803XdWB9wtNd8WQDBKUD/2IKDnvHdvyebI6AI78eS8K
   2V+yVeeObkeFKsL/JbDjvz0Ugl5Vs9wPoFEBwxFYg0GxvXyBVGswjjXaL
   ASAZJaBSaqDFgN2ECHUSXVMWklZsrrad7ENFYAfRDv2G5B3PCq7w9HRvV
   cuEOWm3Dz3X2YdPp5CbMUYwoLlfXN30jmWa1Z90D2kbwKpn87DbCbBsLy
   ZGrpCN0JAcS2dvDg8EKyZ/KSzQPo3RbxZSUkQVMYK5RhLUBORj8rxt6qM
   zEUK7JwZyvggCKMOkkJDiZez6YMcl3RVdwtFRUmesAFnXf+VG1lYSSU2C
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="401226331"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="401226331"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 05:59:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10654"; a="658328870"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="658328870"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 20 Mar 2023 05:59:41 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 05:59:41 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 05:59:41 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 05:59:41 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 05:59:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fY8pXxmTRoC3fd7iFPV6/bCHfYOZr2nfUmaQAJVQXLhV5rOwbkLGGRgo5TvDrfwsRI/UI40fwkviJWbFs5Ajcz59tnzOkPe8V/BbqZ0NGRP3wsTGIg1wG8Fu7l3DFVfQiBQ2TP6rR796FpC+S4+scAprde5LHd92oUhqgCw+by0lfHbnGSG3tGTGQZVYMRBcHMhUmacZlCAIs2pJtSJ/+kft/RtGQbnSqKRKxuAGQpM7Kls3c+pUG5XRkHzfjUSH7JU9/AGa84/oj9PAGMFHRPfl7zp5U9N0i4R60tJaJKR0rhVZWnGKFS5XpPBHId1P1Xb7vgp9dE1lJvfw0UZmkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GXmLe9T37WQn+UocXYmbNq289cLGj3aED0/hPO5v/zk=;
 b=ZRMEo7oiX+5qNcAVTV1XruO2HWvsfwZJf2k49/XyqhDspbQq+IG5lamRPwoZDJIa5wqhbP8BCug2vmkQ/OlLS3iJ++z6sfWfcyYoCyBIwXqEtkVF1trYD/CVhHS+3XjF4WhcjnbdR8bYlFU1H8yErQ4zZT5tdS/6ameRHHFM90azF/+FhA6M1RCCxVWw18VRONnb2OgjLCbE/JPjdfqdEFD4NXql6JchATPVscgFpslHA1wwtgxuufJrJBI0CVWPLxGNk+i+3dmRSi5vZWFzbGl9Dg8FYT8EJh2vXzmLQheKnPuD/L2/KV43FFx2v3M5sB38IjRKq9zppDmhOW+fSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7298.namprd11.prod.outlook.com (2603:10b6:610:14c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 12:59:38 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%4]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 12:59:38 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Gross, Jurgen" <jgross@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v4 03/12] x86/mtrr: support setting MTRR state for
 software defined MTRRs
Thread-Topic: [PATCH v4 03/12] x86/mtrr: support setting MTRR state for
 software defined MTRRs
Thread-Index: AQHZUEoEVz7TvG4lT0yKsCx1uIyU/q8DtxCA
Date:   Mon, 20 Mar 2023 12:59:38 +0000
Message-ID: <9c02041e7ce91752ede17b7a5232f38aadbb3a70.camel@intel.com>
References: <20230306163425.8324-1-jgross@suse.com>
         <20230306163425.8324-4-jgross@suse.com>
In-Reply-To: <20230306163425.8324-4-jgross@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7298:EE_
x-ms-office365-filtering-correlation-id: db83fb9c-961a-4c53-c87d-08db2942f68d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GjT6rVyqJrVi42G14ARXBR5yCnI5LOAv6xj40+N2ICFWiAnAx90C0GMKi6ucMzlL4QczfyHcR/7cZgAglUwL42uUU3HiCWGS7aE/kBB5ucMY+lfPonxh1ZOpbFBkpWPubf1LunwLuqvLFZ/rmppUroOPsAeKlGOLhooAZLJtNuIhwsPFy0ouGOrwzcFclIO8hozaQagxORCfpt4Ze/0KDAK+jhs3Yy3p37cqpauKZytJP2zBvewzm2YvgWSJKqC8RbeB2JgLeYFIyigifNjTh6HriYcvwJsQFHjtGEqkAVwGGcKhfxTxGCPg6HhTC38MJhhGvDOzoC7PUa6YqsTPKQJ4hEeQO9CqY2LfWKyJ7HMqpr8FrCf257JNwAA+Ou7urL34GEOIsPJ3AqNs0u72cPteiYyNO1v3Fn99xjDW8YfWGaw2wZ7dCF60KNTI02qKFdzzC37+TswN6A2gtRANpV7QTyiCxJT1gnhEdUQesRc/it4McQpCYrbVMCU1pqPy2OW+w1EryV3+v2s6jbBSxir82RC2avXBRx8gkQL2PNmJcke2ixwNN3kAMwMTuTbrS9ieSrBPjtDYpstBcwffH2WVTGjyCWd5JKlL/U7D6m5ZKpAHtHzsBCPVMztxBH2UtLkw9/Tg06R+taDnNIVsqi2obPaS1eU0PmDVoUrMQtGNFhbdhKPufnpF1QCzFDmcnqSkUAhN8iu9+ZEJRmZJsQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(136003)(346002)(39860400002)(376002)(451199018)(2616005)(83380400001)(86362001)(91956017)(38070700005)(38100700002)(110136005)(122000001)(82960400001)(66446008)(4326008)(8676002)(64756008)(66556008)(36756003)(66476007)(66946007)(2906002)(8936002)(76116006)(41300700001)(5660300002)(478600001)(186003)(316002)(26005)(6506007)(71200400001)(6486002)(6512007)(54906003)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHZoczdmSVMyZWhWamNDSStyNFZ5MGZQa0FtNlFQNk9NK1dmVjBmbitHejBT?=
 =?utf-8?B?MjliMGFhUDVleW9SYUQrcUFZYjkxeHpqNVBkZzFhQVFEdStDbVF1cVo1ZnBK?=
 =?utf-8?B?OW42alRaOVcxek1UQXhyM1hiRTBQRm5zRUxKdzdQQnRwajhNcDVKVEM2SDhU?=
 =?utf-8?B?d05qcTdnY3R2cHlwRjlGNjEyd2dtREx1MFlXRkMrSS9vdUVoalRoL3QxNFhV?=
 =?utf-8?B?TFptNkVSd0Y0enNHb1VTS0ZLNUx3RDZ6QXgxTmh2UVJVRFJZemQwS3JBSjB3?=
 =?utf-8?B?QTd0UU5tUFZPY1RpTUp0d2U0MlNHWWxSeFQ3dGFXRHlOZFhReDNOUUtoVjdM?=
 =?utf-8?B?UnRqYXA3azNJUmtDRldKWkZUUStyeC9Gd3g0NE1lSThReS9SdFo0L0d5NjRD?=
 =?utf-8?B?eUdvSkNUbUwzL0NNeFFtZWdGdVFwYlFVbWUwUXNLZXJEL2ZYRUtKSzNGTFRa?=
 =?utf-8?B?YkNpcFZld3JKNE0vazVlOHNZRHRQajJQcVErNGw5OFVnamVJTnR3akVaSnBy?=
 =?utf-8?B?aFNyNS9Bams5VkJndFgwQVdpbmVtMTVGV3NOTWVUcUZMbG4yd1VPSVoxNEdL?=
 =?utf-8?B?Mzc1WGN5UXp5RHRRQVZVTzBSNGRvcDFmeW9TS09uTFBkcXpmenI5NGpKRThi?=
 =?utf-8?B?a0xKNDA4clk5dmVXWW9QWGd1dGFjbU5vOWVkN3pYQmg0aXJmUzYvMXpsNDVK?=
 =?utf-8?B?Z3RWRWM4Z3J3c3NXOFk1SEZXdjc2SnRhcGhVZGpOUEJicVVZalFaMEtQeHU3?=
 =?utf-8?B?K2tYMFhoaFd1VkdEQU5QME1lOU50NUNVVDd4by9iMk93dE9UU1NLTXd1SE8r?=
 =?utf-8?B?ZWg5RXRBdjdCZVhQbmtHbHYzbGxMOWFqQXhtckhuSnJnRHVkcWxjZ3NBY0tE?=
 =?utf-8?B?MEE0NFF6NGN0M0xkRnRoNnA0cnNsSm5RaEdjMjU3ZkM3QkhTY0VybUoyOFlP?=
 =?utf-8?B?clloeUZRdTdHRVlSVFBNWFRYZ1lKSHpucE04cmY1T2JtTm9QMk1YZGFTamVx?=
 =?utf-8?B?bVFWeDdKcXN6WkhpTk5wVUo1aUhiRUh2ZldFM3IwVlNYV1NUUnhkRXIxYjhy?=
 =?utf-8?B?eW01WUVWcnFiQU45Kzg1eHNxZ0FRcy9vU1FOdVpUdWh2Z0M4YVBTOHdaRUlV?=
 =?utf-8?B?cmE0NHNSRklGTys2QmJlOW1Yb1JCSkpRRkRxVGVFaEFqWVR4V3loeFRjcFN6?=
 =?utf-8?B?cXpZaXJWaVI2eHBmRXZrb2tMb2drRmQ1OGdpbHBIeDJXeXVITzdlNGdQR3du?=
 =?utf-8?B?V3d0cWhhQmFqMzBwb25xOUNVZU16NEVCQTkwbEZaeTI5RE1QSzcwMHZRZTJM?=
 =?utf-8?B?dG4xSFBZSUlsVzdRdUM3cHFrcWlmL1c4T1V2V1VydEQzalRsbHZKMU9tbnFD?=
 =?utf-8?B?R3JRK2RIZWQ0OVlkQXZKSUZXOEFwbGRSSTJ3QkhKcElacjFlV29WakVUZXNr?=
 =?utf-8?B?K0pXcEFBTDhSVkxIMDJhVjBaaVMrVDk4SHNiU3Vmeit4UUw0Q2Nmc0RhZXQ3?=
 =?utf-8?B?Yy9IUyt4Y1c0NVZpak16RzFiWk40dG1ab1IzdTBkcHJsWTUyYXBNdGFTY3Nu?=
 =?utf-8?B?TDJTNlh3ZE9PY2grWFB6ZVRHL1p4Z3czM2MyNW9vMllRYUJUTWNNQzFqZWdl?=
 =?utf-8?B?UUc2UC9Id0tBNGsva1dqWWlSQTJRd0FIMk5SeFFXLzZEazJYZ2dZUmorZUR5?=
 =?utf-8?B?NG5pbnlNMkl3K2xOWjgvTTJCcmIzdlhOYTUwVUVNYVJpMzljc2NDRmovL00v?=
 =?utf-8?B?eitHcFRWTWo3Q25LSnU0Tk1vVk9DaDNCRU9WN0JDT1duaXc2TVROZDNaWXVN?=
 =?utf-8?B?L3N4T2ZUaXI0bzllVmkrS3VTUjhIZGJRa09UNzNOT0p2cGxsb21qRXJ3UTdh?=
 =?utf-8?B?UC80clJLUlRGN09zUElqajd3V3lzWnpvcS9sWS9sNTUvNlBod2FtSFBKNldl?=
 =?utf-8?B?Yk52Z2N1T3orUXVkSEttOTIrQ0wrS3NlM283K3ZMV1lLdm51dk04T1dJNHBx?=
 =?utf-8?B?TXY5RzR4Y2czUTA1elM3QVlPTVFpRCtnS1JON1IxMTJEWkFlR25oNGw3aXkx?=
 =?utf-8?B?UUQzaXBveEJQeVpXbTI2aHUwRHp4bFQ5TUw4ckFKUjFCdkJOQjFRRjBjM0l0?=
 =?utf-8?B?QjBiM05sRlQva1lrY2JiVjkrZUJzMlB1MytzcmZ5MHZlOXp2V051dlpUZXFX?=
 =?utf-8?B?U0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D6F62DBF57251948888857D7460D4615@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db83fb9c-961a-4c53-c87d-08db2942f68d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 12:59:38.3655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OedVGrnTkIiFoWPxIlt1bAzWRz9uDmebSHgQIbn8Ky8hkqT8xMoNIDb//uS6gUE9i718wJvPnvT/goFNN2TQrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7298
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTAzLTA2IGF0IDE3OjM0ICswMTAwLCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0K
PiBXaGVuIHJ1bm5pbmcgdmlydHVhbGl6ZWQsIE1UUlIgYWNjZXNzIGNhbiBiZSByZWR1Y2VkIChl
LmcuIGluIFhlbiBQVg0KPiBndWVzdHMgb3Igd2hlbiBydW5uaW5nIGFzIGEgU0VWLVNOUCBndWVz
dCB1bmRlciBIeXBlci1WKS4gVHlwaWNhbGx5DQo+IHRoZSBoeXBlcnZpc29yIHdpbGwgcmVzZXQg
dGhlIE1UUlIgZmVhdHVyZSBpbiBDUFVJRCBkYXRhLCByZXN1bHRpbmcNCj4gaW4gbm8gTVRSUiBt
ZW1vcnkgdHlwZSBpbmZvcm1hdGlvbiBiZWluZyBhdmFpbGFibGUgZm9yIHRoZSBrZXJuZWwuDQo+
IA0KPiBUaGlzIGhhcyB0dXJuZWQgb3V0IHRvIHJlc3VsdCBpbiBwcm9ibGVtczoNCj4gDQo+IC0g
SHlwZXItViBTRVYtU05QIGd1ZXN0cyB1c2luZyB1bmNhY2hlZCBtYXBwaW5ncyB3aGVyZSB0aGV5
IHNob3VsZG4ndA0KPiAtIFhlbiBQViBkb20wIG1hcHBpbmcgbWVtb3J5IGFzIFdCIHdoaWNoIHNo
b3VsZCBiZSBVQy0gaW5zdGVhZA0KPiANCj4gU29sdmUgdGhvc2UgcHJvYmxlbXMgYnkgc3VwcG9y
dGluZyB0byBzZXQgYSBzdGF0aWMgTVRSUiBzdGF0ZSwNCj4gb3ZlcndyaXRpbmcgdGhlIGVtcHR5
IHN0YXRlIHVzZWQgdG9kYXkuIEluIGNhc2Ugc3VjaCBhIHN0YXRlIGhhcyBiZWVuDQo+IHNldCwg
ZG9uJ3QgY2FsbCBnZXRfbXRycl9zdGF0ZSgpIGluIG10cnJfYnBfaW5pdCgpLiBUaGUgc2V0IHN0
YXRlDQo+IHdpbGwgb25seSBiZSB1c2VkIGJ5IG10cnJfdHlwZV9sb29rdXAoKSwgYXMgaW4gYWxs
IG90aGVyIGNhc2VzDQo+IG10cnJfZW5hYmxlZCgpIGlzIGJlaW5nIGNoZWNrZWQsIHdoaWNoIHdp
bGwgcmV0dXJuIGZhbHNlLiBBY2NlcHQgdGhlDQo+IG92ZXJ3cml0ZSBjYWxsIG9ubHkgZm9yIHNl
bGVjdGVkIGNhc2VzIHdoZW4gcnVubmluZyBhcyBhIGd1ZXN0Lg0KPiBEaXNhYmxlIFg4Nl9GRUFU
VVJFX01UUlIgaW4gb3JkZXIgdG8gYXZvaWQgYW55IE1UUlIgbW9kaWZpY2F0aW9ucyBieQ0KPiBq
dXN0IHJlZnVzaW5nIHRoZW0uDQo+IA0KPiANClsuLi5dDQoNCj4gZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2tlcm5lbC9jcHUvbXRyci9nZW5lcmljLmMgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L210cnIv
Z2VuZXJpYy5jDQo+IGluZGV4IGVlMDlkMzU5ZTA4Zi4uNDliNGNjOTIzMzEyIDEwMDY0NA0KPiAt
LS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L210cnIvZ2VuZXJpYy5jDQo+ICsrKyBiL2FyY2gveDg2
L2tlcm5lbC9jcHUvbXRyci9nZW5lcmljLmMNCj4gQEAgLTgsMTAgKzgsMTIgQEANCj4gICNpbmNs
dWRlIDxsaW51eC9pbml0Lmg+DQo+ICAjaW5jbHVkZSA8bGludXgvaW8uaD4NCj4gICNpbmNsdWRl
IDxsaW51eC9tbS5oPg0KPiAtDQo+ICsjaW5jbHVkZSA8bGludXgvY2NfcGxhdGZvcm0uaD4NCj4g
ICNpbmNsdWRlIDxhc20vcHJvY2Vzc29yLWZsYWdzLmg+DQo+ICAjaW5jbHVkZSA8YXNtL2NhY2hl
aW5mby5oPg0KPiAgI2luY2x1ZGUgPGFzbS9jcHVmZWF0dXJlLmg+DQo+ICsjaW5jbHVkZSA8YXNt
L2h5cGVydmlzb3IuaD4NCj4gKyNpbmNsdWRlIDxhc20vbXNoeXBlcnYuaD4NCg0KSXMgPGFzbS9t
c2h5cGVydi5oPiBuZWVkZWQgaGVyZT8NCg0KPiAgI2luY2x1ZGUgPGFzbS90bGJmbHVzaC5oPg0K
PiAgI2luY2x1ZGUgPGFzbS9tdHJyLmg+DQo+ICAjaW5jbHVkZSA8YXNtL21zci5oPg0KPiBAQCAt
MjQwLDYgKzI0Miw0OCBAQCBzdGF0aWMgdTggbXRycl90eXBlX2xvb2t1cF92YXJpYWJsZSh1NjQg
c3RhcnQsIHU2NCBlbmQsIHU2NCAqcGFydGlhbF9lbmQsDQo+ICAJcmV0dXJuIG10cnJfc3RhdGUu
ZGVmX3R5cGU7DQo+ICB9DQo+ICANCj4gKy8qKg0KPiArICogbXRycl9vdmVyd3JpdGVfc3RhdGUg
LSBzZXQgc3RhdGljIE1UUlIgc3RhdGUNCj4gKyAqDQo+ICsgKiBVc2VkIHRvIHNldCBNVFJSIHN0
YXRlIHZpYSBkaWZmZXJlbnQgbWVhbnMgKGUuZy4gd2l0aCBkYXRhIG9idGFpbmVkIGZyb20NCj4g
KyAqIGEgaHlwZXJ2aXNvcikuDQoNCitLVk0gbGlzdCBhbmQgS1ZNIG1haW50YWluZXJzLA0KDQpJ
SVVDIGluIHRoZSBuZXh0IHBhdGNoLCBTRVYtU05QIGd1ZXN0IG9ubHkgc2V0cyBhIHN5bnRoZXRp
YyBNVFJSIHcvbyB0ZWxsaW5nIHRoZQ0KaHlwZXJ2aXNvciAoaHlwZXJ2KS4gIEkgdGhpbmsgdGhp
cyB3b3JrcyBmb3IgU0VWLVNOUCBydW5uaW5nIG9uIHRvcCBvZiBoeXBlcnYNCmJlY2F1c2UgdGhl
eSBoYXZlIG11dHVhbCB1bmRlcnN0YW5kaW5nPw0KDQpXaGF0IGFib3V0IHRoZSBTTlAgZ3Vlc3Qg
cnVubmluZyBvbiBvdGhlciBoeXBlcnZpc29ycyBzdWNoIGFzIEtWTT8NCg0KU2luY2UgdGhpcyBj
b2RlIGNvdmVycyBURFggZ3Vlc3QgdG9vLCBJIHRoaW5rIGV2ZW50dWFsbHkgaXQgbWFrZXMgc2Vu
c2UgZm9yIFREWA0KZ3Vlc3QgdG8gdXNlIHRoaXMgZnVuY3Rpb24gdG9vICh0byBhdm9pZCAjVkUg
SUlVQykuICBJZiB3YW50IHRvIGRvIHRoYXQsIHRoZW4gSQ0KdGhpbmsgVERYIGd1ZXN0IHNob3Vs
ZCBoYXZlIHRoZSBzYW1lIG11dHVhbCB1bmRlcnN0YW5kaW5nIHdpdGggKkFMTCogaHlwZXJ2aXNv
ciwNCmFzIEkgYW0gbm90IHN1cmUgd2hhdCdzIHRoZSBwb2ludCBvZiBtYWtpbmcgdGhlIFREWCBn
dWVzdCdzIE1UUlIgYmVoYXZpb3VyDQpkZXBlbmRpbmcgb24gc3BlY2lmaWMgaHlwZXJ2aXNvci4N
Cg0KRm9yIG5vdyBJIGRvbid0IHNlZSB0aGVyZSdzIGFueSB1c2UgY2FzZSBmb3IgVERYIGd1ZXN0
IHRvIHVzZSBub24tV0IgbWVtb3J5IHR5cGUNCihpbiBmYWN0LCBLVk0gYWx3YXlzIG1hcHMgZ3Vl
c3QgbWVtb3J5IGFzIFdCIGlmIHRoZXJlJ3Mgbm8gbm9uLWNvaGVyZW50IERNQSB0bw0KdGhlIGd1
ZXN0IG1lbW9yeSksIHNvIHRvIG1lIGl0IHNlZW1zIGl0J3MgT0sgdG8gbWFrZSBhIHVuaXZlcnNh
bCBtdXR1YWwNCnVuZGVyc3RhbmRpbmcgdGhhdCBURFggZ3Vlc3Qgd2lsbCBhbHdheXMgaGF2ZSBX
QiBtZW1vcnkgdHlwZSBmb3IgYWxsIG1lbW9yeS4NCg0KQnV0LCBJIGFtIG5vdCBzdXJlIHdoZXRo
ZXIgaXQncyBiZXR0ZXIgdG8gaGF2ZSBhIHN0YW5kYXJkIGh5cGVyY2FsbCBiZXR3ZWVuDQpndWVz
dCAmIGh5cGVydmlzb3IgZm9yIHRoaXMgcHVycG9zZSBzbyB0aGluZ3MgY2FuIGJlIG1vcmUgZmxl
eGlibGU/DQoNCj4gKyAqIElzIGFsbG93ZWQgb25seSBmb3Igc3BlY2lhbCBjYXNlcyB3aGVuIHJ1
bm5pbmcgdmlydHVhbGl6ZWQuIE11c3QgYmUgY2FsbGVkDQo+ICsgKiBmcm9tIHRoZSB4ODZfaW5p
dC5oeXBlci5pbml0X3BsYXRmb3JtKCkgaG9vay4gWDg2X0ZFQVRVUkVfTVRSUiBtdXN0IGJlIG9m
Zi4NCj4gKyAqLw0KPiArdm9pZCBtdHJyX292ZXJ3cml0ZV9zdGF0ZShzdHJ1Y3QgbXRycl92YXJf
cmFuZ2UgKnZhciwgdW5zaWduZWQgaW50IG51bV92YXIsDQo+ICsJCQkgIG10cnJfdHlwZSBkZWZf
dHlwZSkNCj4gK3sNCj4gKwl1bnNpZ25lZCBpbnQgaTsNCj4gKw0KPiArCWlmIChXQVJOX09OKG10
cnJfc3RhdGVfc2V0IHx8DQo+ICsJCSAgICBoeXBlcnZpc29yX2lzX3R5cGUoWDg2X0hZUEVSX05B
VElWRSkgfHwNCj4gKwkJICAgICFjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFUVVJFX0hZUEVS
VklTT1IpIHx8DQo+ICsJCSAgICAoIWNjX3BsYXRmb3JtX2hhcyhDQ19BVFRSX0dVRVNUX1NFVl9T
TlApICYmDQo+ICsJCSAgICAgIWh2X2lzX2lzb2xhdGlvbl9zdXBwb3J0ZWQoKSAmJg0KPiArCQkg
ICAgICFjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFUVVJFX1hFTlBWKSAmJg0KPiArCQkgICAg
ICFjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFUVVJFX1REWF9HVUVTVCkpKSkNCj4gKwkJcmV0
dXJuOw0KPiArDQo+ICsJLyogRGlzYWJsZSBNVFJSIGluIG9yZGVyIHRvIGRpc2FibGUgTVRSUiBt
b2RpZmljYXRpb25zLiAqLw0KPiArCXNldHVwX2NsZWFyX2NwdV9jYXAoWDg2X0ZFQVRVUkVfTVRS
Uik7DQo+ICsNCj4gKwlpZiAodmFyKSB7DQo+ICsJCWlmIChudW1fdmFyID4gTVRSUl9NQVhfVkFS
X1JBTkdFUykgew0KPiArCQkJcHJfd2FybigiVHJ5aW5nIHRvIG92ZXJ3cml0ZSBNVFJSIHN0YXRl
IHdpdGggJXUgdmFyaWFibGUgZW50cmllc1xuIiwNCj4gKwkJCQludW1fdmFyKTsNCj4gKwkJCW51
bV92YXIgPSBNVFJSX01BWF9WQVJfUkFOR0VTOw0KPiArCQl9DQo+ICsJCWZvciAoaSA9IDA7IGkg
PCBudW1fdmFyOyBpKyspDQo+ICsJCQltdHJyX3N0YXRlLnZhcl9yYW5nZXNbaV0gPSB2YXJbaV07
DQo+ICsJCW51bV92YXJfcmFuZ2VzID0gbnVtX3ZhcjsNCj4gKwl9DQo+ICsNCj4gKwltdHJyX3N0
YXRlLmRlZl90eXBlID0gZGVmX3R5cGU7DQo+ICsJbXRycl9zdGF0ZS5lbmFibGVkIHw9IE1UUlJf
U1RBVEVfTVRSUl9FTkFCTEVEOw0KPiArDQo+ICsJbXRycl9zdGF0ZV9zZXQgPSAxOw0KPiArfQ0K
PiArDQo+ICAvKioNCj4gICAqIG10cnJfdHlwZV9sb29rdXAgLSBsb29rIHVwIG1lbW9yeSB0eXBl
IGluIE1UUlINCj4gICAqDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L210cnIv
bXRyci5jIGIvYXJjaC94ODYva2VybmVsL2NwdS9tdHJyL210cnIuYw0KPiBpbmRleCA3NTk2ZWJl
YWI5MjkuLjVmZTYyZWUwMzYxYiAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9t
dHJyL210cnIuYw0KPiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L210cnIvbXRyci5jDQo+IEBA
IC02NjYsNiArNjY2LDE1IEBAIHZvaWQgX19pbml0IG10cnJfYnBfaW5pdCh2b2lkKQ0KPiAgCWNv
bnN0IGNoYXIgKndoeSA9ICIobm90IGF2YWlsYWJsZSkiOw0KPiAgCXVuc2lnbmVkIGludCBwaHlz
X2FkZHI7DQo+ICANCj4gKwlpZiAobXRycl9zdGF0ZS5lbmFibGVkKSB7DQo+ICsJCS8qIFNvZnR3
YXJlIG92ZXJ3cml0ZSBvZiBNVFJSIHN0YXRlLCBvbmx5IGZvciBnZW5lcmljIGNhc2UuICovDQo+
ICsJCW10cnJfY2FsY19waHlzYml0cyh0cnVlKTsNCj4gKwkJaW5pdF90YWJsZSgpOw0KPiArCQlw
cl9pbmZvKCJNVFJScyBzZXQgdG8gcmVhZC1vbmx5XG4iKTsNCj4gKw0KPiArCQlyZXR1cm47DQo+
ICsJfQ0KPiArDQo+ICAJcGh5c19hZGRyID0gbXRycl9jYWxjX3BoeXNiaXRzKGJvb3RfY3B1X2hh
cyhYODZfRkVBVFVSRV9NVFJSKSk7DQo+ICANCj4gIAlpZiAoYm9vdF9jcHVfaGFzKFg4Nl9GRUFU
VVJFX01UUlIpKSB7DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvc2V0dXAuYyBiL2Fy
Y2gveDg2L2tlcm5lbC9zZXR1cC5jDQo+IGluZGV4IDE2YmFiZmY3NzFiZC4uMGNjY2ZlYjY3YzNh
IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rZXJuZWwvc2V0dXAuYw0KPiArKysgYi9hcmNoL3g4
Ni9rZXJuZWwvc2V0dXAuYw0KPiBAQCAtMTAzNyw2ICsxMDM3LDggQEAgdm9pZCBfX2luaXQgc2V0
dXBfYXJjaChjaGFyICoqY21kbGluZV9wKQ0KPiAgCS8qDQo+ICAJICogVk13YXJlIGRldGVjdGlv
biByZXF1aXJlcyBkbWkgdG8gYmUgYXZhaWxhYmxlLCBzbyB0aGlzDQo+ICAJICogbmVlZHMgdG8g
YmUgZG9uZSBhZnRlciBkbWlfc2V0dXAoKSwgZm9yIHRoZSBib290IENQVS4NCj4gKwkgKiBGb3Ig
c29tZSBndWVzdCB0eXBlcyAoWGVuIFBWLCBTRVYtU05QLCBURFgpIGl0IGlzIHJlcXVpcmVkIHRv
IGJlDQo+ICsJICogY2FsbGVkIGJlZm9yZSBjYWNoZV9icF9pbml0KCkgZm9yIHNldHRpbmcgdXAg
TVRSUiBzdGF0ZS4NCj4gIAkgKi8NCj4gIAlpbml0X2h5cGVydmlzb3JfcGxhdGZvcm0oKTsNCj4g
IA0KDQo=
