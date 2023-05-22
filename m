Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFD970BEA5
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 14:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbjEVMrE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 08:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbjEVMrC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 08:47:02 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8888E;
        Mon, 22 May 2023 05:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684759621; x=1716295621;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1O73q5KQJkW7IdDQGpTfA4zUAGaml6Bke1YkZuH3yB0=;
  b=J3SKdZFbioLVgcO6ubqB8PlVan7aRwAJJW9g5z/OXgEta+w9ewgNfWoV
   au9FSz5Y2use1Y8jkPhqWnxRtmWlOvLtGrmKWzaRrIOlG5y5HB2M14/K5
   lNyLKO3o8F7sltTSIGKeV1FiLmaBDBvsKw94/6mxb6yCat9LB32/5L1Kt
   T6HaDwl0hjL2S+brKRKFnxncG5bdDvYcoG+2k1ZaPvpW500zduEbAEHPJ
   MjhqQLNdycC+zNsfZk/92XNnDJbssofmN/3oZeovB4nyzvaydgpiZUXZd
   IuflPuyteF7NN4DccXr/kYBQS6g4j8JpRVmjGenlQGu9TnnGVrEjJmYZ/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="333273167"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="333273167"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 05:47:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="1033615277"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="1033615277"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 22 May 2023 05:47:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 05:47:00 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 05:47:00 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 05:47:00 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 05:46:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ex3vkRfaR5hO5+NFK24eGHR4g5nKaCQuM1ZUhmb4SqI0jCKjJ04zqy1lPqfcmnFUfkqfRGqvFeca9lXIsYx8ppnn+KDPCvdEE9nrHDaMAMsd5jLPT2S5iLjcsdiqWfm24diwWaeffrSlgNlT0AMjOAhxL064c7pFBfaLSUwcF0uWuAH1c8vqwIPy/TW4BFxyhbAoDjw2YQR6It9Ezaq+EbPUndpJYx3psotpdQauHmF7YxWlZmQQeM0rKy59xP1PMXOaXxtKTzx6RdJStRJ6DdDEcBO6xfxxwPLqKLs3iCzi2XTDQDhGVuAfO0vPYY5hPZdF2yBjy7EKniLn7KH0bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1O73q5KQJkW7IdDQGpTfA4zUAGaml6Bke1YkZuH3yB0=;
 b=ekVPNxMmZrcCIb9kQvUn7dHewNuZ5YYvI8VnCDBfqTj/TOAAMW87+3JbIrFr1dpVEmL4jp6PNQDRyDHQikymth9bBRD3Rk571cPtvz7C8qJJm4Uu69MiFWSOoFt5Wbh0C6O7GZvgKzSXGj68qpvOZh/lBaA8JMMgsG6neYz5VZI1YizNk5Kd4ZkUQDTTJ6FNx8OTvIEUaoBAkEuKQBOqX9XMVkD0gb0sQvwQvEeL+Us/jrWw7eFczZ7UgJcAJ42+aDC/O9f9nj5Zc46FWrpdBlpnkw3whXJCtX9IdWESb5dAzV2aL8A2VDkNUIyVfzkuML+1hCVuI2gilTKCklL6OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6870.namprd11.prod.outlook.com (2603:10b6:806:2b4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 12:46:52 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 12:46:52 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 02/18] x86/reboot: Harden virtualization hooks for
 emergency reboot
Thread-Topic: [PATCH v3 02/18] x86/reboot: Harden virtualization hooks for
 emergency reboot
Thread-Index: AQHZhSySfrwLB0MsSkGgkmqyWzvIM69mTJmA
Date:   Mon, 22 May 2023 12:46:51 +0000
Message-ID: <820ca676ad2c0b482be91e484ae55e58a38cfca4.camel@intel.com>
References: <20230512235026.808058-1-seanjc@google.com>
         <20230512235026.808058-3-seanjc@google.com>
In-Reply-To: <20230512235026.808058-3-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6870:EE_
x-ms-office365-filtering-correlation-id: d1a76684-05ad-44fe-28c4-08db5ac29db7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UgxWknIVBJYzqvm6neUppNRJ9wjQsuyFYrqYKunXobVdyp+oDfsO4XkyxyT8lYuakXaDxmmsFK/2uBpbJS3HFY6N3mreXivukywaR8ArLySeAZGIbw7/EtlVInGvyLp77r3nIyKimqfJN8eToqbJ58Tk3H8/0GfCeqspM/g+mbO3s9Dvu2aD5rxypeOPTrK9AoRUrIEzuka0Ce2daKRfPDSlHcskpH8vCNHTQRJb6TuTjEXURqh1NndqyfqTMVguMOW7Zr/Oqd5HJ0W45iRg0MtmULsRdM+GeHgvruJxw3AQXXDKR87WZONkGJYx1XZcVYU9WJpEURJsiN71pkWp+EJbRohb+LC6CtmPw7GRquws/JP7dmCCYVX8aDhliyUdjujkete/aVR3RqL4ybFzbXT811OCYq1JWdGIdfj9v0OJimEn6V3ppKbBZKMbLrtuya4bS+Y3k9N8/R9/mDDDJZadfFlfA/Ak5YPc1nQBSRpbfauwpqtelDcg3dgp9412PJhcaWZbrxnkyTOqJ+Wr7ZzNhVawu8Cfcfqouh8CbGM+gDCyWxoKg+x0BrheVyX2mDjdqWMwyU1xfBfhautPinw2OyR5MSmS2nFPJFkW6QL5CVDspTl2dq0dx0NbuTRZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(376002)(346002)(396003)(39860400002)(451199021)(86362001)(316002)(71200400001)(54906003)(110136005)(478600001)(41300700001)(6486002)(66946007)(91956017)(76116006)(4326008)(66556008)(66476007)(66446008)(64756008)(38100700002)(8676002)(8936002)(122000001)(5660300002)(82960400001)(38070700005)(83380400001)(2616005)(36756003)(26005)(2906002)(186003)(6512007)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bDkzMllueXg0Ni9aRG9vaERjYzVWMGxWZldEMEtiaXVTb1dlT2FmYzIvN1F5?=
 =?utf-8?B?R2JmMTNLL3l6d05wYkd1L3h6aHo4U3l1UGRwSit6V2V2WjNDYTF4cGtTdnNE?=
 =?utf-8?B?dlM2VU44dHQ2T2oxZ3IxOVhpRWZZYWpNTkM3YUR4U3A5a1R2YkZqRTBNWGs0?=
 =?utf-8?B?SFgwZ3dGUFVWWkttOVZ0UmF0ZmRpODVscjFQK0htZ1UwK0JaYmY0MlRiREd1?=
 =?utf-8?B?VVZOK0VFbjcrZUZmRVlQR25zTWFxVlZsQkNSSjR1VkZOVFhwa3NhWlBIUVda?=
 =?utf-8?B?UXRpNk5qdGlIY093dGxqTUZlaTZ4NUM2NEZKQVdsYUxoRTNnRjJ4bDhaeWpu?=
 =?utf-8?B?QmgwUkU3c2FBMk83UlZiSEdyakFKQyt0UHBnRFFMWWNqRVJadHZjem4wVU9R?=
 =?utf-8?B?YlJ1R3Q3UmRSRFdqT1Q4aWFsRTRaMnJQNnorMnVFZmFFb2srdEJqdmQwVlBG?=
 =?utf-8?B?cWpocllZM0xmSE0vRkEyb1kyTElkNEhRbjBqcGVDVTNYREVDR0Z4M2VFdldB?=
 =?utf-8?B?UlVXNTRMbDlnS3JPNXNkNDYyMlZvRXZ0Ky9IaXM5b3VoK3Z0bjNiVW5pbUty?=
 =?utf-8?B?eFU2TWVrT0YrQTFmeU9BZytzQ3ViZnAzZUs3WVRRdFd4alE2TGVWUFpqckVx?=
 =?utf-8?B?V2huYzlIUGFYeTF0N2Q0aTVjemlCc3RKK1Ard3dra3lSK3lhdmtOenVZVWdr?=
 =?utf-8?B?QU5OdnRWVDNCNGpsazY3V3JPTnNNd2dNVnJVbUw3WlRBbUkza1hTQ3JGcGow?=
 =?utf-8?B?QzZLUzRNQlA2UUVNeTh0RmZybUYrRDY4QmFmVjVSZG1aYnJqUmlmNlF6OE53?=
 =?utf-8?B?R0RmR1A4VjN2R2h5V2V1Wm1Xb2Q2dlR5aXR3aWNFdWJaN2d2aUkyZXhsRFRN?=
 =?utf-8?B?ZUQ0MHFYZW1IYXQxamtWVEdQNjRnSktHb2NUQTRnNHc2MnhOSjZRdW52MzVo?=
 =?utf-8?B?ZjUwSWhFM2lkVGJrVUc5ZlFxNEhubGxJZTk3S2NCcE5IekxJME8yZnJXeWE2?=
 =?utf-8?B?QTd1YUtvVDF4eXFCWVJ5ZlJWNUxqUTh3Nm5nUWNzNGlnTXNua1hsSEVmMlRk?=
 =?utf-8?B?RW5LOTI4dWs3dHZtblkwWVQyQld3dzBMYmo1QVNmRmVMUEw0MmtvaVdVRkpY?=
 =?utf-8?B?M2gvVG1VdjczamNwN0pFeXVLcEx1b1ovS04yUlcxb0ZFdmNFYlk4RDd5bDVX?=
 =?utf-8?B?eExBNUpMSE5qME5RbFZET09ERmJWOE1LUGdjSVo2Z3VWR2tpRWRadmtIZHF6?=
 =?utf-8?B?dG5CdHpmK3l1U3hoMlNxbkp3WHVlaGpNbVBDdDZLaEdZOXRzeGR2b3pWNExV?=
 =?utf-8?B?cWlMcG0rcHV0SXpNZjBGNWMzK000R0VCbkxndlRvL01mb3gycVlFS0dzakRW?=
 =?utf-8?B?eFBrVithNnJLUlR6SHI5ZENaRWpkZHM5by9PYUpLWWJ1NDltWmZabEZJelF4?=
 =?utf-8?B?SlVvTzZYQ0dFNVJZaisvSjRaa1hFMDlJaWdaQnRmRFdPVUd4ZUFDLyt4Y2F4?=
 =?utf-8?B?V21aTXVzVG4zanhDbU9YaUI1OFdIa3FzNElJdExvUlU3b1dtMWlQZEl1bHE0?=
 =?utf-8?B?OEdkc0l5ZFFVYk9XNE8xUjhldENsQ01Ha2IycG90UGZ1SmRvcVh6bGFUN2xy?=
 =?utf-8?B?WEtvbUxRQTV6OFBpdHJjaWhhK1lTdUZJMGY5alc5WnJZbXNIWVEvWkJNSlRN?=
 =?utf-8?B?TlhFWVcySTFWUWh2UHAwRXBPQ3VJVnFGUXRTb1dpL2tFQ3VmY3ArUXk2N2p3?=
 =?utf-8?B?dzhKY2tNT0NBdnVGbTBTZHpSYW9MR3pFa0RtZjNJYW01SG40Ukp6bk9RT2xv?=
 =?utf-8?B?WUpkRm5UeCtsS082UFVZSm0wQkJ2UkFCbjd3V3JTRXhLRkF0cFRpL1FmaVA1?=
 =?utf-8?B?Zno5YlpkQVpiM0N5Ky9sbjc5L3Z5MVI4UDlLRENDVTVWUHZZdmd4L2laUlAv?=
 =?utf-8?B?KzVtQ2tiYWNpSWNnVTJkVDNRSlVua1NydXpORzJ0RENCcEdEVmhlVU80Zktm?=
 =?utf-8?B?YmxuWHJsSnI4ZGs3KzhoZkFKaDBjUURPaFNvR1RtVGVnRVZLMWdVRlFYWmdw?=
 =?utf-8?B?NEdKb0hhVWU3QXRqeHJTeGFyOWJBdGhqdG9Ib3Mva2ZETnl2a01yS1NtMnlu?=
 =?utf-8?Q?uw+t4VUtQpnMFlK8JTs2KRfsF?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA4F74C824110741A4D4461AC78802A0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1a76684-05ad-44fe-28c4-08db5ac29db7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 12:46:51.8947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ivWX0XxDsWH3y62YrB65MX5XS1FAjy/tfFoR3jN5bIknDgRcWLDYDRCFwpULB+bmFPu+Z7A+yxB1Aq36ANbsYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6870
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
b3RlOg0KPiBQcm92aWRlIGRlZGljYXRlZCBoZWxwZXJzIHRvICh1bilyZWdpc3RlciB2aXJ0IGhv
b2tzIHVzZWQgZHVyaW5nIGFuDQo+IGVtZXJnZW5jeSBjcmFzaC9yZWJvb3QsIGFuZCBXQVJOIGlm
IHRoZXJlIGlzIGFuIGF0dGVtcHQgdG8gb3ZlcndyaXRlDQo+IHRoZSByZWdpc3RlcmVkIGNhbGxi
YWNrLCBvciBhbiBhdHRlbXB0IHRvIGRvIGFuIHVucGFpcmVkIHVucmVnaXN0ZXIuDQo+IA0KPiBP
cHBvcnR1bnNpdGljYWxseSB1c2UgcmN1X2Fzc2lnbl9wb2ludGVyKCkgaW5zdGVhZCBvZiBSQ1Vf
SU5JVF9QT0lOVEVSKCksDQo+IG1haW5seSBzbyB0aGF0IHRoZSBzZXQvdW5zZXQgcGF0aHMgYXJl
IG1vcmUgc3ltbWV0cmljYWwsIGJ1dCBhbHNvIGJlY2F1c2UNCj4gYW55IHBlcmZvcm1hbmNlIGdh
aW5zIGZyb20gdXNpbmcgUkNVX0lOSVRfUE9JTlRFUigpIGFyZSBtZWFuaW5nbGVzcyBmb3INCj4g
dGhpcyBjb2RlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vh
bmpjQGdvb2dsZS5jb20+DQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRl
bC5jb20+DQoNCj4gLS0tDQo+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9yZWJvb3QuaCB8ICA1ICsr
Ky0tDQo+ICBhcmNoL3g4Ni9rZXJuZWwvcmVib290LmMgICAgICB8IDMwICsrKysrKysrKysrKysr
KysrKysrKysrKy0tLS0tLQ0KPiAgYXJjaC94ODYva3ZtL3ZteC92bXguYyAgICAgICAgfCAgNiAr
Ky0tLS0NCj4gIDMgZmlsZXMgY2hhbmdlZCwgMjkgaW5zZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25z
KC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vcmVib290LmggYi9h
cmNoL3g4Ni9pbmNsdWRlL2FzbS9yZWJvb3QuaA0KPiBpbmRleCAyNTUxYmFlYzkyN2QuLmQ5YTM4
ZDM3OWQxOCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vcmVib290LmgNCj4g
KysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcmVib290LmgNCj4gQEAgLTI1LDggKzI1LDkgQEAg
dm9pZCBfX25vcmV0dXJuIG1hY2hpbmVfcmVhbF9yZXN0YXJ0KHVuc2lnbmVkIGludCB0eXBlKTsN
Cj4gICNkZWZpbmUgTVJSX0JJT1MJMA0KPiAgI2RlZmluZSBNUlJfQVBNCQkxDQo+ICANCj4gLXR5
cGVkZWYgdm9pZCBjcmFzaF92bWNsZWFyX2ZuKHZvaWQpOw0KPiAtZXh0ZXJuIGNyYXNoX3ZtY2xl
YXJfZm4gX19yY3UgKmNyYXNoX3ZtY2xlYXJfbG9hZGVkX3ZtY3NzOw0KPiArdHlwZWRlZiB2b2lk
IChjcHVfZW1lcmdlbmN5X3ZpcnRfY2IpKHZvaWQpOw0KPiArdm9pZCBjcHVfZW1lcmdlbmN5X3Jl
Z2lzdGVyX3ZpcnRfY2FsbGJhY2soY3B1X2VtZXJnZW5jeV92aXJ0X2NiICpjYWxsYmFjayk7DQo+
ICt2b2lkIGNwdV9lbWVyZ2VuY3lfdW5yZWdpc3Rlcl92aXJ0X2NhbGxiYWNrKGNwdV9lbWVyZ2Vu
Y3lfdmlydF9jYiAqY2FsbGJhY2spOw0KPiAgdm9pZCBjcHVfZW1lcmdlbmN5X2Rpc2FibGVfdmly
dHVhbGl6YXRpb24odm9pZCk7DQo+ICANCj4gIHR5cGVkZWYgdm9pZCAoKm5taV9zaG9vdGRvd25f
Y2IpKGludCwgc3RydWN0IHB0X3JlZ3MqKTsNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5l
bC9yZWJvb3QuYyBiL2FyY2gveDg2L2tlcm5lbC9yZWJvb3QuYw0KPiBpbmRleCAyOTliOTcwZTVm
ODIuLjczOWUwOTUyN2RiYiAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva2VybmVsL3JlYm9vdC5j
DQo+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9yZWJvb3QuYw0KPiBAQCAtNzk0LDE3ICs3OTQsMzUg
QEAgdm9pZCBtYWNoaW5lX2NyYXNoX3NodXRkb3duKHN0cnVjdCBwdF9yZWdzICpyZWdzKQ0KPiAg
ICoNCj4gICAqIHByb3RlY3RlZCBieSByY3UuDQo+ICAgKi8NCj4gLWNyYXNoX3ZtY2xlYXJfZm4g
X19yY3UgKmNyYXNoX3ZtY2xlYXJfbG9hZGVkX3ZtY3NzOw0KPiAtRVhQT1JUX1NZTUJPTF9HUEwo
Y3Jhc2hfdm1jbGVhcl9sb2FkZWRfdm1jc3MpOw0KPiArc3RhdGljIGNwdV9lbWVyZ2VuY3lfdmly
dF9jYiBfX3JjdSAqY3B1X2VtZXJnZW5jeV92aXJ0X2NhbGxiYWNrOw0KPiArDQo+ICt2b2lkIGNw
dV9lbWVyZ2VuY3lfcmVnaXN0ZXJfdmlydF9jYWxsYmFjayhjcHVfZW1lcmdlbmN5X3ZpcnRfY2Ig
KmNhbGxiYWNrKQ0KPiArew0KPiArCWlmIChXQVJOX09OX09OQ0UocmN1X2FjY2Vzc19wb2ludGVy
KGNwdV9lbWVyZ2VuY3lfdmlydF9jYWxsYmFjaykpKQ0KPiArCQlyZXR1cm47DQo+ICsNCj4gKwly
Y3VfYXNzaWduX3BvaW50ZXIoY3B1X2VtZXJnZW5jeV92aXJ0X2NhbGxiYWNrLCBjYWxsYmFjayk7
DQo+ICt9DQo+ICtFWFBPUlRfU1lNQk9MX0dQTChjcHVfZW1lcmdlbmN5X3JlZ2lzdGVyX3ZpcnRf
Y2FsbGJhY2spOw0KPiArDQo+ICt2b2lkIGNwdV9lbWVyZ2VuY3lfdW5yZWdpc3Rlcl92aXJ0X2Nh
bGxiYWNrKGNwdV9lbWVyZ2VuY3lfdmlydF9jYiAqY2FsbGJhY2spDQo+ICt7DQo+ICsJaWYgKFdB
Uk5fT05fT05DRShyY3VfYWNjZXNzX3BvaW50ZXIoY3B1X2VtZXJnZW5jeV92aXJ0X2NhbGxiYWNr
KSAhPSBjYWxsYmFjaykpDQo+ICsJCXJldHVybjsNCj4gKw0KPiArCXJjdV9hc3NpZ25fcG9pbnRl
cihjcHVfZW1lcmdlbmN5X3ZpcnRfY2FsbGJhY2ssIE5VTEwpOw0KPiArCXN5bmNocm9uaXplX3Jj
dSgpOw0KPiArfQ0KPiArRVhQT1JUX1NZTUJPTF9HUEwoY3B1X2VtZXJnZW5jeV91bnJlZ2lzdGVy
X3ZpcnRfY2FsbGJhY2spOw0KPiAgDQo+ICBzdGF0aWMgaW5saW5lIHZvaWQgY3B1X2NyYXNoX3Zt
Y2xlYXJfbG9hZGVkX3ZtY3NzKHZvaWQpDQo+ICB7DQo+IC0JY3Jhc2hfdm1jbGVhcl9mbiAqZG9f
dm1jbGVhcl9vcGVyYXRpb24gPSBOVUxMOw0KPiArCWNwdV9lbWVyZ2VuY3lfdmlydF9jYiAqY2Fs
bGJhY2s7DQo+ICANCj4gIAlyY3VfcmVhZF9sb2NrKCk7DQo+IC0JZG9fdm1jbGVhcl9vcGVyYXRp
b24gPSByY3VfZGVyZWZlcmVuY2UoY3Jhc2hfdm1jbGVhcl9sb2FkZWRfdm1jc3MpOw0KPiAtCWlm
IChkb192bWNsZWFyX29wZXJhdGlvbikNCj4gLQkJZG9fdm1jbGVhcl9vcGVyYXRpb24oKTsNCj4g
KwljYWxsYmFjayA9IHJjdV9kZXJlZmVyZW5jZShjcHVfZW1lcmdlbmN5X3ZpcnRfY2FsbGJhY2sp
Ow0KPiArCWlmIChjYWxsYmFjaykNCj4gKwkJY2FsbGJhY2soKTsNCj4gIAlyY3VfcmVhZF91bmxv
Y2soKTsNCj4gIH0NCj4gIA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC92bXguYyBi
L2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gaW5kZXggMzE3ZjcyYmFmMGMzLi5mYzljZGI0MTE0
Y2MgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gKysrIGIvYXJjaC94
ODYva3ZtL3ZteC92bXguYw0KPiBAQCAtODU0Nyw4ICs4NTQ3LDcgQEAgc3RhdGljIHZvaWQgX192
bXhfZXhpdCh2b2lkKQ0KPiAgew0KPiAgCWFsbG93X3NtYWxsZXJfbWF4cGh5YWRkciA9IGZhbHNl
Ow0KPiAgDQo+IC0JUkNVX0lOSVRfUE9JTlRFUihjcmFzaF92bWNsZWFyX2xvYWRlZF92bWNzcywg
TlVMTCk7DQo+IC0Jc3luY2hyb25pemVfcmN1KCk7DQo+ICsJY3B1X2VtZXJnZW5jeV91bnJlZ2lz
dGVyX3ZpcnRfY2FsbGJhY2soY3Jhc2hfdm1jbGVhcl9sb2NhbF9sb2FkZWRfdm1jc3MpOw0KPiAg
DQo+ICAJdm14X2NsZWFudXBfbDFkX2ZsdXNoKCk7DQo+ICB9DQo+IEBAIC04NTk4LDggKzg1OTcs
NyBAQCBzdGF0aWMgaW50IF9faW5pdCB2bXhfaW5pdCh2b2lkKQ0KPiAgCQlwaV9pbml0X2NwdShj
cHUpOw0KPiAgCX0NCj4gIA0KPiAtCXJjdV9hc3NpZ25fcG9pbnRlcihjcmFzaF92bWNsZWFyX2xv
YWRlZF92bWNzcywNCj4gLQkJCSAgIGNyYXNoX3ZtY2xlYXJfbG9jYWxfbG9hZGVkX3ZtY3NzKTsN
Cj4gKwljcHVfZW1lcmdlbmN5X3JlZ2lzdGVyX3ZpcnRfY2FsbGJhY2soY3Jhc2hfdm1jbGVhcl9s
b2NhbF9sb2FkZWRfdm1jc3MpOw0KPiAgDQo+ICAJdm14X2NoZWNrX3ZtY3MxMl9vZmZzZXRzKCk7
DQo+ICANCj4gLS0gDQo+IDIuNDAuMS42MDYuZ2E0YjFiMTI4ZDYtZ29vZw0KPiANCg0K
