Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80ECC64E532
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 01:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiLPAcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 19:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLPAcI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 19:32:08 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2788A5215B;
        Thu, 15 Dec 2022 16:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671150727; x=1702686727;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+Udmnq5Yl6VINCxPOHgXDICIoscBJ6tK2QG3h4vtUiU=;
  b=jQNLoCz3AAq1HVs5tBIwWXe4rPNUMa9EcgnbImMyi4vRf4nNykzk+Ad9
   /CYXdJGXaONaQZAXLYsKAdxkbMUdE7b40VUlptQo1oRSxklcsUjc9bI7A
   /7inpp31mJlqvTteYTUnoTD/oi/J936ezDpgXfXNBqGWl1BelOERkvLgx
   d71uPKNx+5kiJFmB2RdS+5KmikF4aOzNHqeZ53g+9yRllxMpc4Wqcis5S
   3VlNGeiiGX1pm1cd3uAmempisvfrupLWCmBeMJzW2il4FuB6pKrGLVJZs
   FsIF9EbRqsvfZlCcgGOQ+kUoc+nEtVXzQ+SyElwVGeVorAYuWoJVMMnF1
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="345923677"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="345923677"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 16:31:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="680289584"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="680289584"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 15 Dec 2022 16:31:58 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 16:31:57 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 16:31:57 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 16:31:57 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 16:31:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Su99p94i6cw+5pSckbAe7V2FYKTCz0ZF5dTR9OA1zfpvtbWpomVHdDBWEvyL2nNurLOnq4i6wV+/jjaqjgpbxY143K9cXtVfGHHw5i0rTn8yfDJj0RQNXo+wigAYco0tg97wAXVUwI9C81iWv4Jo/wVZEyDA8Cc6Veb/ue3bvx+d1mlPD4G8ww4KzOr11lpA6H05146ocWpAtdy/+qe6gcqxLAm2hQ2Mv0i4lixeiri2C8VroYz1D9ORLJb56AxYt+LqeOPBG+GNglKjYtKMaJLlYRdTYInNgiZVi8m+r9k3KhaHqtAmMXLEVp7+4hv8ZPcW1SD9ZP96G3F2VXUPJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Udmnq5Yl6VINCxPOHgXDICIoscBJ6tK2QG3h4vtUiU=;
 b=dkl2gJybAAmN/KTt+ecjw3SkugEiZTDsnoBQLMHL790kNPJzY+2rQc/E5sinSG1Wcf2LP7YDKlAVx2dFWAruiVOYn/omlTfeBrTnbxFgJtmb28G8rQlGzWfKLUBTBAWN0t2EKs3Md2S0dPnDkZxqz2fOudQPQhirvKcTI4nfZyI2YGbjoDKYgew7wI4FraMNh5RPqLchm1AAZwuBH35PLC4eIZpyu7C2we9jPsbZeeI7Fo1tEajpqJWDuqXYEIucCMyxTCcvmsq2QMj8zsYwLB/OpGIFd1eGcNcO7dcYxFMlZ5vltnB2Ps0CADF8REcRGmvoICYxdHY2NXJP7Tv7/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB4868.namprd11.prod.outlook.com (2603:10b6:303:90::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Fri, 16 Dec
 2022 00:31:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5880.019; Fri, 16 Dec 2022
 00:31:53 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH v10 056/108] KVM: TDX: don't request
 KVM_REQ_APIC_PAGE_RELOAD
Thread-Topic: [PATCH v10 056/108] KVM: TDX: don't request
 KVM_REQ_APIC_PAGE_RELOAD
Thread-Index: AQHY7CiYmy+NZsCui0WKLCRu9CH+ba5KMUeAgCW8bICAAAWQgA==
Date:   Fri, 16 Dec 2022 00:31:52 +0000
Message-ID: <1e5e5cb0ff43e52f630ec5c890204174be2582c5.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <f0f134dcf59f901e4b8960c7b3f242dcd42b1c40.1667110240.git.isaku.yamahata@intel.com>
         <e813c4791d3b0a6d14f344dfd881d65a2060764a.camel@intel.com>
         <20221216001157.GK3632095@ls.amr.corp.intel.com>
In-Reply-To: <20221216001157.GK3632095@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB4868:EE_
x-ms-office365-filtering-correlation-id: 954e5bcc-2b9b-4334-95af-08dadefcedaa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R6k81G3g5rmRYgFF5Rmw2kzkxfYO5V7CtqqSEkssSOORAWNaVSf0Mk0AGDFI1Za4sK40j87czKuTr5FZMs9Bq5/faXQnggLavInxkae1d/jEdBtp/AVD4xGPolcxDfw8IJzrinoMA3zdGxUe03icLFi63QkzydOVTbn6/vazKW40HPtK9J/aHQeikvq1B36KwpHv7icy6t/Yf8L0ImbTIwd4mgV1EUC5uPJ6kn/m+wpQYvYepolmaR175Wt9MtZdoQw5+rZ81PuOctQ4OM7KAC56yk51kvYB4XFC4FCbgy5TwHW3R2HrYzC3bA77PiNa9hvJJZtrH9iBDXA/EMVFUwouHRfMr/kKDsbP62bU/7QiMsJ9gRdiB6tHCFvUA23ny5+BaiKQjxusD+tYWOtcor4eMc9KietqwcMXJoz+1dqAaW0DMcqoks4qegqJ52cfcqFswYc+S+ac0TOHL53ptYQ74ilQWJ18nZctSD5cS6LHZvDcN4otkq800vt32bLxph6QI4JMJJTMLFDeiJIn4/hM9HZRRbEaMfn9IzPdr9/YkFuClJC3dQ3nCvF+ix5JyByreN35nx+4J8OLBbsGgnTYAe9hEE2lmBw4EHCBtyqUmFxaJ+lXMaMpOZKz0xQjoyWgVvW3KVH810WcMrBZQgrtG4kQc+NUjv6bUNk+RSZnt9fDFqMphtbTQzAIbr1Ql8SweobJeTm7hGVMFZpIFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199015)(4001150100001)(316002)(38070700005)(2906002)(6486002)(478600001)(82960400001)(6916009)(54906003)(122000001)(41300700001)(86362001)(38100700002)(66946007)(64756008)(66446008)(66476007)(76116006)(6506007)(5660300002)(6512007)(186003)(26005)(66556008)(71200400001)(8936002)(36756003)(2616005)(4326008)(8676002)(91956017)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWlvR09maXA5c21ZL3ZXcUVxYjExMzJyUC8yRVJQREczc2cxQkV3Q0ErWWNU?=
 =?utf-8?B?bmtpMlFDSFV6YklOQnYrNjhiR0hadmt3cFd3VlR3K1lLL01iMHRKUENPTVBK?=
 =?utf-8?B?MjNCSjFhMTBDOUFVaEhNYnB0clhWZjN2dWhrS2VJektlK2lmYnFVRjhORTYw?=
 =?utf-8?B?M0Y2UmxNbW9pMTE0Wk05Q2VjZCtkVFZkOTJBRTRRa1FUT1RyNFNCd2YwcWhK?=
 =?utf-8?B?U3EwbTRnSlIxMFRtejNPdTFWb2ZUYmlnUU9wMmhlTHF4cHQ4Z25VMzNocmhC?=
 =?utf-8?B?YTlkRFRuVmc3cUlWZWxNWGQvdXcyNzNLNDQwaXdodmdxQk9QZ0RNT3hxZ21h?=
 =?utf-8?B?d0x2N3JBM2MvcE54Nlc3NnBvVTRjUm1Belh4N3ZUdk5TWXdxbFRDYzZoN1BV?=
 =?utf-8?B?SFVCL0ZwcHlyUGFWN29hSS9WSitXWk9uMVFmRUZmVkdoQStTeXNNK0FZdVJP?=
 =?utf-8?B?SVZBZ2lSQ0hBSzFHMmFoSkdqVUMra0hPOXlSWEJPRFBHM0JNNGlIRkxLRDBK?=
 =?utf-8?B?QzFQeGcyNzJ0UDJQMXAwdWI4RzB6eGVoOS9YQ3ZlR0dCWTJxZlFKQW9pamww?=
 =?utf-8?B?KzRTVGxXOCsxYTQyZUVHVlNNOUFvN09nSEpoSjVuWlAxL3YwVG15TGlFdWl0?=
 =?utf-8?B?cFN5SUFlOVhrQnljMXV3UlFxN1BsSjZvV3c3SEtjMkZrSDlWSWxzU0tEc1pQ?=
 =?utf-8?B?RmQxZ3VtLzF4M1kyYmtoMktQUlQxa0NPNk4xTWJhYkhSeXZuTCthMlJtZGNo?=
 =?utf-8?B?MnVVbFdIN2Q1ZzVyVFRWVUhQVmhqOEd4ZEtiVmtGOGxxczZEK0cyMXBvNC9u?=
 =?utf-8?B?L3VhbUdvdGVvenU3dmZyMFVKZ0FBeDFucWd3UEZYQ0h6Ynh3L3o4d3U0bVRx?=
 =?utf-8?B?ZGhwSk9mb2oyOW9tRGhuVTZna1BIdmNOS1NnZjRNclByYTBsT3RzQTd5UDlR?=
 =?utf-8?B?UWYxdFNFZGRpSVFGc1AyVFBhdndTNWs4MnVwMTc4TFBRLzNrMWZSQmJnK1V6?=
 =?utf-8?B?ZTVjTmFRSnBXQWdoM3VsVEtPclgwcmIwUG91V2tTWWYzdUFUd3lCKzBIbHNm?=
 =?utf-8?B?RWtFRW5rK1pRZUJHWXkvZ3dKQVRUQmJ6b1pla0xhRExzOFo2dCsxWThPZ1V6?=
 =?utf-8?B?WFpGT041UXl0bjBON2MrVFJsZS96eUJ6MjZyVlIzYXl2c0JFUldDelJwTVlJ?=
 =?utf-8?B?cmpvUGlKYnpLK3Avc3NqcmJ2djZMNFI0K05LS3FVcy9icForWERZOFU4aUI3?=
 =?utf-8?B?TWxyR2p5TndIVE1vdVpEZTFwS3U5cm9OQTJUWWpoNlpmQThNZjdOa0ZUS2Nn?=
 =?utf-8?B?bGVHL3UrbDY4elJkY1NKdDFLVFhqRzRjVjBBc0swQkl2MDBlUkxKOHRtYjcy?=
 =?utf-8?B?UTFsUUkweWEwbUtxRjI1aHNxTGRPSTBXeVNtS0owRSs0TFU2YmNKems3ckJm?=
 =?utf-8?B?SDRSYXVpQnZTYWl1OEVQVGZERWllT3ZINzJpMXVKYmtZclc5TnVrZFhpQzk5?=
 =?utf-8?B?QUhLd0lDUVBXaWlzNkdvNUJnZ2NZUjBFdkJCNUM3TnlhamZybGNTdy9sdk1E?=
 =?utf-8?B?ekVkNXMwdU5NRllOQkNGNUtRWHJreHBBRE5BaEtuYXJJT2ZqNUFPaFYzODR1?=
 =?utf-8?B?Yzc0K2JRYU9ZWnJHOEJwZXpZQW03bW55VHRmRS9CTkNmejI3QnIwS0U1VHFS?=
 =?utf-8?B?YmhYajB4Sk9tSEpuRVFnaEhBU3Y0SHYrY2Noc3FwbElJS1dZeS9CVVBNN2tv?=
 =?utf-8?B?V3JIYVUwZ0dqcFhTaDBPUllVNk5aaUVIVHY3cUcwbFp6UlpIYk0ycjZrdDFW?=
 =?utf-8?B?YldSTExvcGk5dW1sTTIyRjF5YUNXNGFCT0FCcUR2Vmt2MUdKQ21KYlA4Mnk3?=
 =?utf-8?B?RGtFcFBseXFwZ1BJOUE4Rm5VbkdTT2NaaERiWVVPdDJKK3dHSnNmSjNtT2p2?=
 =?utf-8?B?MnhjdnA2a1NWWW45bTV4U1J2bmdQKzVVM2lOM1hPR1RYTEVRV3FHWXNOeWtw?=
 =?utf-8?B?em9oWWRZZkJNZ2tHYWVwQWNVbHpLOXJrQlpGaTlWVmJ3SDE3RzMraVcyaVV1?=
 =?utf-8?B?TC9Gamx1UEtWS2FSdU8zc04zMUp2MlM2OEV2T3pmRU83citsK3BGbXBvK1J1?=
 =?utf-8?B?cUNnc244VjRmeHU2YnZkOE14bFpBVUNPZ2I0VEpIa0Y2dnFETDcxNnE4UWFq?=
 =?utf-8?B?aFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE45B81CC0A82A498EB4E448E53CFD4F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 954e5bcc-2b9b-4334-95af-08dadefcedaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2022 00:31:52.6069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t4CXinxjoknOL1JisXB31YcWyGHHHrvpyuWw+ZUavh90dTcecRvduTKMfDIO5T0keHaHD8VLAJEfWsE8O+Ikcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4868
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTEyLTE1IGF0IDE2OjExIC0wODAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiBCdHcyLCBieSBzYXlpbmcgYWJvdmUsIGRvZXMgaXQgbWFrZSBzZW5zZSB0byBzcGxpdCBw
YXRjaCAiW1BBVENIIHYxMA0KPiA+IDEwNS8xMDhdDQo+ID4gS1ZNOiBURFg6IEFkZCBtZXRob2Rz
IHRvIGlnbm9yZSBhY2Nlc3NlcyB0byBDUFUgc3RhdGUiIGJhc2VkIG9uIGNhdGVnb3J5DQo+ID4g
c3VjaCBhcw0KPiA+IE1NVS9pbnRlcnJ1cHQsIGV0Yz/CoCBQYXJ0aWN1bGFybHksIGluIHRoYXQg
cGF0Y2gsIHNvbWUgY2FsbGJhY2tzIGhhdmUgV0FSTigpDQo+ID4gb3INCj4gPiBLVk1fQlVHX09O
KCkgYWdhaW5zdCBURCBndWVzdCwgYnV0IHNvbWUgZG9uJ3QuwqAgVGhlIGxvZ2ljIGJlaGluZCB0
aG9zZQ0KPiA+IGRlY2lzaW9ucw0KPiA+IGhpZ2hseSBkZXBlbmQgb24gcHJldmlvdXMgcGF0Y2hl
cy7CoCBUbyBtZSwgaXQgbWFrZXMgbW9yZSBzZW5zZSB0byBqdXN0IG1vdmUNCj4gPiBsb2dpYyBy
ZWxhdGVkIHRoaW5ncyB0b2dldGhlci4NCj4gDQo+IE9rLCBJJ2xsIHNwbGl0IGl0IHVwIHRvIGNw
dSBzdGF0ZXMvS1ZNIE1NVS9pbnRlcnJ1cHQgcGFydHMuDQoNCklmIEkgcmVjYWxsIGNvcnJlY3Rs
eSwgb3JpZ2luYWxseSAobG9uZyB0aW1lIGFnbyBiZWZvcmUgc3RhcnRpbmcgdG8gdXBzdHJlYW0p
LA0Kd2hhdCB3ZSBkaWQgd2FzIHdlIGhhdmUgYSBwYXRjaCB0byBtYWtlIGFsbCBrdm1feDg2X29w
cyBjYWxsYmFjayBLVk1fQlVHX09OKCkNCmZvciBURFggZ3Vlc3QsIHRoZW4gd2UgZml4IHRob3Nl
IEtWTV9CVUdfT04oKSBpbiBsYXRlciBwYXRjaGVzIGluIHNlcGFyYXRlDQpwYXRjaGVzLg0KDQpX
ZSBkb24ndCBuZWVkIHRvIGRvIHRoZSBleGFjdCBzYW1lIHdheSwgYnV0IHRoaXMgYWxzbyBzZWVt
cyByZWFzb25hYmxlIHRvIG1lLiANCkZvciBpbnN0YW5jZSwgYXQgdGhlIGJlZ2lubmluZyB3ZSBj
YW4gbWFyayBLVk1fQlVHX09OKCkgZm9yIGFsbCBjYWxsYmFja3Mgd2hpY2gNCnJlYWRzL3dyaXRl
cyBDUFUgc3RhdGVzICh3aGljaCBpcyByZWFzb25hYmxlIGFueXdheSksIGFuZCBpbiBsYXRlciBw
YXRjaGVzIHdlDQpyZW1vdmUgdGhlIEtWTV9CVUdfT04oKSBpZiBuZWVkZWQgd2hlbiBoYW5kbGlu
ZyBzcGVjaWZpYyBsb2dpYy4NCg0KU2ltcGx5IG15IDJjZW50cyBhYm92ZS4gIEp1c3QgZm9yIHlv
dXIgcmVmZXJlbmNlLiAgTXkgcmVhbCBjb21tZW50IGlzIHdlIHNob3VsZA0KcHV0IHJlbGV2YW50
IHBhcnRzIHRvZ2V0aGVyIHNvIGl0J3MgZWFzeSB0byByZXZpZXcuDQo=
