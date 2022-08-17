Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10BE3597A42
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 01:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241595AbiHQXgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 19:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbiHQXgw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 19:36:52 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751ED53002
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 16:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660779411; x=1692315411;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=daeN1WD0ZR8pB3pTGqXVibRee2HMVaEZn042dzzPqW4=;
  b=kQvn8PwoahvuTB2noMW1tVqQj+w6Iud6/gncpHFcjHQfnT87NYdFY+/3
   sKZUSwdP9D3uCzey3ZwWd5yRMR46w4z/Md2mA8meFJmMP8YwnbUBB3JWD
   W8REsii8sk3TebTLGvX449db0Ppw0SFOrwzVAEQ4QBWtwDj3aKgnIORLs
   W6tCwSTodZrHCJazOXbYZA6OQFaLD6imuJSD73p4j5p1LeGPKM4Dv9vZi
   XwimKzEHA5Cvop41QE0MkdU1tRhvLhsuXOCvsbkywIAF1tigyN5x+4R0r
   H8NKaMjdcfpmnbtLJHmBA269P1Y6NuYyXJIK++EbgjM5/JUVgdsbVqi46
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="290193754"
X-IronPort-AV: E=Sophos;i="5.93,244,1654585200"; 
   d="scan'208";a="290193754"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 16:36:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,244,1654585200"; 
   d="scan'208";a="667840257"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 17 Aug 2022 16:36:51 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 17 Aug 2022 16:36:50 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 17 Aug 2022 16:36:50 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 17 Aug 2022 16:36:50 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 17 Aug 2022 16:36:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=URVB7lFTH0EZeMiZbhaRsbBVF0QkyP9c3Frjqz9z8/xn1F2/Dyw6moxQQtmSsl/gqA0y5lTn/tCkzAA2A3PY3KenLagzs0sCU5EqsH+kLI/Gwe2mzYkdRmc7wYkRxqpKhJDBHxjO036b90xR3NWWL+Gs/XFy98wddSKGHqGjOLZp+zVDT7TdiP0NdGrKafeXrmqdx3aaaZjW17/ELwlIWoF9kWplno0Ur3geNmKsGMQmpZbbUbrPU3Bd9B8qhB+RDhmX01msMsoBQ3xb42ND6a9lHc03b+p59rbgfMpEF/S/u9Dx7wRjylmY7SsN/38/ZlanZHg8al3BBuiqCtZt7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=daeN1WD0ZR8pB3pTGqXVibRee2HMVaEZn042dzzPqW4=;
 b=HfuQWIZ64PKFWGNHkaheG5M9DahsVorN2COtA8FVx/thRs1ohjHKtOwTXGLJFwB4gvDwxsmMiWfMWy+oVq0s0uybSNyOjy4IiPjLyh4tDIouPqxmpLbdMuktNsd7Keljk4yv59i3jhcP631dk7rSmeFwAjFedm0X6WGuXO/vcXKfi8Jpqs0A/Zaq/IJHVMoRQwxMduuTwmOYyr9IbixaUOj2SP5+QyMnsocDXn2oNeyiUZCrBwbAUiT43qm1mNS34vDHa81XE/JB0BrAvvV4qyW3bOCIZ5gXVkviCh6dSRs/NiE1ruIIfHhjStZ2Djf4BCZP7EIIG3WaCNZs1iuFTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN2PR11MB4221.namprd11.prod.outlook.com (2603:10b6:208:18d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Wed, 17 Aug
 2022 23:36:48 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::1d3c:4dc0:6155:2aee]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::1d3c:4dc0:6155:2aee%4]) with mapi id 15.20.5525.010; Wed, 17 Aug 2022
 23:36:48 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "dmatlack@google.com" <dmatlack@google.com>
CC:     "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "bp@suse.de" <bp@suse.de>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH 0/9] KVM: x86/mmu: Always enable the TDP MMU when TDP is
 enabled
Thread-Topic: [PATCH 0/9] KVM: x86/mmu: Always enable the TDP MMU when TDP is
 enabled
Thread-Index: AQHYsRl143Sp+fyEHkmbsD65QcPNj62xLuCAgACKCQCAASV5gIAAcDCAgABzqYA=
Date:   Wed, 17 Aug 2022 23:36:47 +0000
Message-ID: <80e120a87ab513b3e602313dcb60a6403e9e6265.camel@intel.com>
References: <20220815230110.2266741-1-dmatlack@google.com>
         <YvtSc9ofTg1z8tt7@worktop.programming.kicks-ass.net>
         <CALzav=eWhg=ZMxVcGf9w_svn1XaTZABN5VoFP3fgxPiHohaMFQ@mail.gmail.com>
         <97103b92b9dc1723b1cbfe67ce529a0f065a76ed.camel@intel.com>
         <CALzav=ceSoMWooLu=riCn9WtKes7Jt3L0BaMb9uyA_D4=dvZEw@mail.gmail.com>
In-Reply-To: <CALzav=ceSoMWooLu=riCn9WtKes7Jt3L0BaMb9uyA_D4=dvZEw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb6759b8-8cfa-4c54-361b-08da80a95a59
x-ms-traffictypediagnostic: MN2PR11MB4221:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rC/yYdFZp0K+hcVL5Fj+ZGxhwAZXD5hqDsMs6PWyYh2o34YVLweVfnKdI2jf9ZJKBWIUGBdeDX+8v8uxbEv3kmJnd8a0ZOubMssbSGbsKoPfgh/RB/J8tm+fzwc+j3YR9vSFcW1u+XSEUdJimT1+u0621daPI3sMpOge6wK/BOGqhjRBXlEjKoQ8ZoI102CwxoKVy8c2aAoNFD8laYISZwXuVwyUhCopYPqxncOLE5FuzkZzb9wC+SrFssSSSHSWBrj0uTNlbYFHft0wRUi0RhqO9nkVrsSN92ydN59HklWz0yV7jj5W3QrVxDXt7tRR7nxC0Mg702o6CtLK8bc3lXvlU8NBvScjTt51Mue0Mnwmc4pvEO4C8W5b0fNMDYQtYFzU7sXTLNc43WlULC7L3iegmsfB/0S474SxDObzS0Nqouq6DvnAPcGQ90WMuLgEjl7KtumT/DD4v2lYCPiYIIjv5RP2r9Ln5oocWW/xlCslXGUXe9IW4dQb/XKU1vgiJcZl7yvsJ9+41NwW1fgnAGpkuQsGG3mscnq3w3lKlpBWF7Tfts2tkSPrr3Ipb1UZTQE0ccCNCXGbPIdopLnoKXbEw+b2CfnTEJRsmVKeqfdWCDuxcqtmowJpVvvAMlf0M8jMxvD0Koeh3Kpjq7+njMdKEV7U+21PK25CYKd9iimEVEtwb4fgdcm8cvm8ENAzhBH0Fl8BYKHk96Wz2FfOPPevbvS7S2VeGlyG3YcEBAkqefXmluw2lAaGiLFqGjZNR69WN1Kn2peXf7qW9fUbcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(366004)(346002)(376002)(396003)(26005)(6512007)(186003)(54906003)(478600001)(83380400001)(71200400001)(2616005)(6486002)(66446008)(66476007)(64756008)(8936002)(91956017)(4326008)(6916009)(66946007)(8676002)(316002)(66556008)(36756003)(76116006)(38100700002)(5660300002)(82960400001)(2906002)(122000001)(7416002)(41300700001)(86362001)(53546011)(38070700005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bHV2L2xrTmVCU2YwS3FWWXJPeXBRUzdtVUtPWjk4ZEtkUXV6ZkhWRUw2ZTEz?=
 =?utf-8?B?dGJMRXdwSkhkZ1JsLy82WXNpcjBCTTJWZ1BWa3lJcmtmUk9tV3pGdHZJVjVE?=
 =?utf-8?B?UFkzaTF0SkNyT0pLTW5tMEQzSmtheHJId3JjeU5sWk1nM2EwMDBVMnBPRFZ5?=
 =?utf-8?B?V1lWQU5IMldibEd6NytHL0VZTTFkZERiUzFLYkl6OU1hMnZTMmhGOGpzM2Ex?=
 =?utf-8?B?dGl4K1o5T3VoU0VlOVUyc1FMQm9pWldVb01EL0hnSVdKeXdudlBQTkpQUXhv?=
 =?utf-8?B?eExzTmpqallYT2tkWWs0bUtCVFcyZy9KcExhc2tTcy81Qlc3QisyS04xOVhB?=
 =?utf-8?B?WGVtSnVwd28zaHpBanBFYUkwZVF2bFBWallKWHpnNk1yRW12S0d5VzJIZlpa?=
 =?utf-8?B?cUdBbXlOMEZVRFlVbytab1IwbHV6N2tERGh3QVd1ckh2di9STG5XWFArc21q?=
 =?utf-8?B?WGR4Z1huME1OYW8wMFpNLzBNeDVDSUl0Z3QyKzd0RE54ajRPWmxnbm1WdEtD?=
 =?utf-8?B?anFJVHJQTmhVcnlXTktlSENma0hpbGxtaW1ZVHhqdTJQcVdaNHg0aDZ5U2po?=
 =?utf-8?B?YWZnU3draEV4UElVM1VjM2YrYk43NDFlZTV3MGEzNnh3ZDBEL1BGS1JuS3pT?=
 =?utf-8?B?bGI1cUFaTUhnamZuSlhWMlg5UEtxbmZVRk9Td2ttRWpwWkcvMGhSWG9FTkl2?=
 =?utf-8?B?b2xsZFhHWVJtR0VKbUtNUi96VzIwWThtb21XVkRZeGROQ1ltMHdZeHV2Nmdt?=
 =?utf-8?B?UDhBaDVXZ21CQU1aYWQwK016eElvL0ZhOWZ1QklzLzJBOWw2Q2t1Mm9PajJy?=
 =?utf-8?B?NmhtOVVBZjdiamtEMEFqL2Y2SzNTTnROZVdETnBocnRHRWRSY2xSL2ZYQVc4?=
 =?utf-8?B?MGZIdHZGTzIzclpqRUlCSHl4T1BzdDRDMlBjRWV2ZUtqUjR0OTlvb3d1R3JM?=
 =?utf-8?B?d2JpQW96THBoWWlqRC9wZDJ2UWk4enJzUWFEWFNyUkd1QUsxUEJBWWp0dDBK?=
 =?utf-8?B?K3RueWJpWUJ2WGpPL29LV0Fvck1TNFpZOWpQZGNZeGZYMmJsTHlEL1FhRnQ3?=
 =?utf-8?B?MTJpYmIzbmJDOGt1WDBoZXRZeHJnbitGN1RyeDFRaEZFU2tyZi9TRVYwUVN1?=
 =?utf-8?B?UjNWdDBJQ1AxWDkreEdaMGd4M1RzTWM2NlVwSVFLUDMxT0pqWEdGUjNVMlJv?=
 =?utf-8?B?cXBjbVdRQW0yK3ZuUEVrcElLTzN6RGx5aXFHdlZLYmJPdmNMZ0t0bmJLa2tN?=
 =?utf-8?B?TVZySW9wcGZwTmZBTjJ0eEtkb0pFRnVWYWlQeDA2WWd2ajdJRkRaMnJqNmYx?=
 =?utf-8?B?T1c1eFlucHROOWNEckprK1B6clJIWjhXak5nN1VqcFdkZHhhOCttTEZXQitS?=
 =?utf-8?B?L0FrOUZLRDZzZG1qS0U2VWs2SCtYWXROWTVkVStrRXpiOE5CVlJBY2lmWlJk?=
 =?utf-8?B?U1laNUVVeGRpSitITURhRmF6LzRJcFBYcEZSMGJnOGIrdGN0cW9RemlVZlJx?=
 =?utf-8?B?ME5yeHdmazRVWlZ6Y0NaL0htRVo2MmN2R2FRWkhXUDUrZTBTTWJpbExrRjk4?=
 =?utf-8?B?UkUrYk45V3ZTcG14SXZMWlU1RlZUZUIxLzV0RVhHaXIzZmlOQXgwRWFReGI5?=
 =?utf-8?B?VkVBbkJjUWp0R2tSTEpwN1kyMTl6VFNXUDJhQlRjNlRwYyszcDhmN1p4aHp6?=
 =?utf-8?B?bjd6Y2NiYjczOHlPcnFoMTMwVngzYWpHZWk0clhrRXpMYXVvY2lSakIrWWNY?=
 =?utf-8?B?SUV0RFpwaDdEcGNiMlhGMEhhWjFEckxJT200VjVvQkdhaVNYTEcvWjFQa1pE?=
 =?utf-8?B?NXkrT2YzNERycUZvc1VFSW1GK1RTZXlBQXRWb29zeFpxVVpmM2pPSjlpNVoz?=
 =?utf-8?B?Zm52Zi84c1VsUDNTcklTMzkyT1ovRzB6SFFJNGxHTm1BalpiOGNCVzk4cG9r?=
 =?utf-8?B?bzlkbFBsVWNLNGtIRG4vQnk2VW5Qbm5kQWxQbjY4U2wwVWlqbWNHdk1IeXdI?=
 =?utf-8?B?ME9HNk44RlZmaTBodE5SVFV4WkYwaThsa3RIVE93d0JnOVBncDlTUVlGT2p0?=
 =?utf-8?B?RmxZcWVIVFpLUFpNR21BMjZGdXFWa0hQTEFXQXRXdW5NQWdmMkdoQW5wVmcv?=
 =?utf-8?B?TGJVUzB2eFY0SXo5NWhXSjZydWxTS3Y1bHJNZnQ0UlFYdmFxa3lQNTNFd0FV?=
 =?utf-8?B?eFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4A731BF150309446BC0C9C98364A8DC0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb6759b8-8cfa-4c54-361b-08da80a95a59
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2022 23:36:47.9345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FduSPfZTCs/UyJGUPWhcB8AMup6N68H6td5v3jZ/6mpCo5QRexvO/zt5MByDHaPxm3c4ZlbxMJCpVpMw5k6V6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4221
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIyLTA4LTE3IGF0IDA5OjQyIC0wNzAwLCBEYXZpZCBNYXRsYWNrIHdyb3RlOg0K
PiBPbiBXZWQsIEF1ZyAxNywgMjAyMiBhdCAzOjAxIEFNIEh1YW5nLCBLYWkgPGthaS5odWFuZ0Bp
bnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIFR1ZSwgMjAyMi0wOC0xNiBhdCAwOTozMCAt
MDcwMCwgRGF2aWQgTWF0bGFjayB3cm90ZToNCj4gPiA+IE9uIFR1ZSwgQXVnIDE2LCAyMDIyIGF0
IDE6MTcgQU0gUGV0ZXIgWmlqbHN0cmEgPHBldGVyekBpbmZyYWRlYWQub3JnPiB3cm90ZToNCj4g
PiA+ID4gDQo+ID4gPiA+IE9uIE1vbiwgQXVnIDE1LCAyMDIyIGF0IDA0OjAxOjAxUE0gLTA3MDAs
IERhdmlkIE1hdGxhY2sgd3JvdGU6DQo+ID4gPiA+ID4gUGF0Y2ggMSBkZWxldGVzIHRoZSBtb2R1
bGUgcGFyYW1ldGVyIHRkcF9tbXUgYW5kIGZvcmNlcyBLVk0gdG8gYWx3YXlzDQo+ID4gPiA+ID4g
dXNlIHRoZSBURFAgTU1VIHdoZW4gVERQIGhhcmR3YXJlIHN1cHBvcnQgaXMgZW5hYmxlZC4gIFRo
ZSByZXN0IG9mIHRoZQ0KPiA+ID4gPiA+IHBhdGNoZXMgYXJlIHJlbGF0ZWQgY2xlYW51cHMgdGhh
dCBmb2xsb3cgKGFsdGhvdWdoIHRoZSBrdm1fZmF1bHRpbl9wZm4oKQ0KPiA+ID4gPiA+IGNsZWFu
dXBzIGF0IHRoZSBlbmQgYXJlIG9ubHkgdGFuZ2VudGlhbGx5IHJlbGF0ZWQgYXQgYmVzdCkuDQo+
ID4gPiA+ID4gDQo+ID4gPiA+ID4gVGhlIFREUCBNTVUgd2FzIGludHJvZHVjZWQgaW4gNS4xMCBh
bmQgaGFzIGJlZW4gZW5hYmxlZCBieSBkZWZhdWx0IHNpbmNlDQo+ID4gPiA+ID4gNS4xNS4gQXQg
dGhpcyBwb2ludCB0aGVyZSBhcmUgbm8ga25vd24gZnVuY3Rpb25hbGl0eSBnYXBzIGJldHdlZW4g
dGhlDQo+ID4gPiA+ID4gVERQIE1NVSBhbmQgdGhlIHNoYWRvdyBNTVUsIGFuZCB0aGUgVERQIE1N
VSB1c2VzIGxlc3MgbWVtb3J5IGFuZCBzY2FsZXMNCj4gPiA+ID4gPiBiZXR0ZXIgd2l0aCB0aGUg
bnVtYmVyIG9mIHZDUFVzLiBJbiBvdGhlciB3b3JkcywgdGhlcmUgaXMgbm8gZ29vZCByZWFzb24N
Cj4gPiA+ID4gPiB0byBkaXNhYmxlIHRoZSBURFAgTU1VLg0KPiA+ID4gPiANCj4gPiA+ID4gVGhl
biBob3cgYXJlIHlvdSBnb2luZyB0byB0ZXN0IHRoZSBzaGFkb3cgbW11IGNvZGUgLS0gd2hpY2gg
SSBhc3N1bWUgaXMNCj4gPiA+ID4gc3RpbGwgcmVsZXZhbnQgZm9yIHRoZSBwbGF0Zm9ybXMgdGhh
dCBkb24ndCBoYXZlIHRoaXMgaGFyZHdhcmUgc3VwcG9ydA0KPiA+ID4gPiB5b3Ugc3BlYWsgb2Y/
DQo+ID4gPiANCj4gPiA+IFREUCBoYXJkd2FyZSBzdXBwb3J0IGNhbiBzdGlsbCBiZSBkaXNhYmxl
ZCB3aXRoIG1vZHVsZSBwYXJhbWV0ZXJzDQo+ID4gPiAoa3ZtX2ludGVsLmVwdD1OIGFuZCBrdm1f
YW1kLm5wdD1OKS4NCj4gPiA+IA0KPiA+ID4gVGhlIHRkcF9tbXUgbW9kdWxlIHBhcmFtZXRlciBv
bmx5IGNvbnRyb2xzIHdoZXRoZXIgS1ZNIHVzZXMgdGhlIFREUA0KPiA+ID4gTU1VIG9yIHNoYWRv
dyBNTVUgKndoZW4gVERQIGhhcmR3YXJlIGlzIGVuYWJsZWQqLg0KPiA+IA0KPiA+IFdpdGggdGhl
IHRkcF9tbXUgbW9kdWxlIHBhcmFtZXRlciwgd2hlbiB3ZSBkZXZlbG9wIHNvbWUgY29kZSwgd2Ug
Y2FuIGF0IGxlYXN0DQo+ID4gZWFzaWx5IHRlc3QgbGVnYWN5IE1NVSBjb2RlICh0aGF0IGl0IGlz
IHN0aWxsIHdvcmtpbmcpIHdoZW4gKlREUCBoYXJkd2FyZSBpcw0KPiA+IGVuYWJsZWQqIGJ5IHR1
cm5pbmcgdGhlIHBhcmFtZXRlciBvZmYuDQo+IA0KPiBJIGFtIHByb3Bvc2luZyB0aGF0IEtWTSBz
dG9wcyBzdXBwb3J0aW5nIHRoaXMgdXNlLWNhc2UsIHNvIHRlc3RpbmcgaXQNCj4gd291bGQgbm8g
bG9uZ2VyIGJlIG5lY2Vzc2FyeS4gSG93ZXZlciwgYmFzZWQgb24gUGFvbG8ncyByZXBseSB0aGVy
ZQ0KPiBtaWdodCBiZSBhIHNuYWcgd2l0aCAzMi1iaXQgc3lzdGVtcy4NCj4gDQo+ID4gT3Igd2hl
biB0aGVyZSdzIHNvbWUgcHJvYmxlbSB3aXRoIFREUA0KPiA+IE1NVSBjb2RlLCB3ZSBjYW4gZWFz
aWx5IHN3aXRjaCB0byB1c2UgbGVnYWN5IE1NVS4NCj4gDQo+IFdobyBpcyAid2UiIGluIHRoaXMg
Y29udGV4dD8gRm9yIGNsb3VkIHByb3ZpZGVycywgc3dpdGNoaW5nIGEgY3VzdG9tZXINCj4gVk0g
ZnJvbSB0aGUgVERQIE1NVSBiYWNrIHRvIHRoZSBzaGFkb3cgTU1VIHRvIGZpeCBhbiBpc3N1ZSBp
cyBub3QNCj4gZmVhc2libGUuIFRoZSBzaGFkb3cgTU1VIHVzZXMgbW9yZSBtZW1vcnkgYW5kIGhh
cyB3b3JzZSBwZXJmb3JtYW5jZQ0KPiBmb3IgbGFyZ2VyIFZNcywgaS5lLiBzd2l0Y2hpbmcgY29t
ZXMgd2l0aCBzaWduaWZpY2FudCBkb3duc2lkZXMgdGhhdA0KPiBhcmUgdW5saWtlbHkgdG8gYmUg
bG93ZXIgcmlzayB0aGFuIHNpbXBseSByb2xsaW5nIG91dCBhIGZpeCBmb3IgdGhlDQo+IFREUCBN
TVUuDQo+IA0KPiBBbHNvLCBvdmVyIHRpbWUsIHRoZSBURFAgTU1VIHdpbGwgYmUgbGVzcyBhbmQg
bGVzcyBsaWtlbHkgdG8gaGF2ZSBidWdzDQo+IHRoYW4gdGhlIHNoYWRvdyBNTVUgZm9yIFREUC1l
bmFibGVkIHVzZS1jYXNlcy4gZS5nLiBUaGUgVERQIE1NVSBoYXMNCj4gYmVlbiBkZWZhdWx0IGVu
YWJsZWQgc2luY2UgNS4xNSwgc28gaXQgaGFzIGxpa2VseSByZWNlaXZlZA0KPiBzaWduaWZpY2Fu
dGx5IG1vcmUgdGVzdCBjeWNsZXMgdGhhbiB0aGUgc2hhZG93IE1NVSBpbiB0aGUgcGFzdCA1DQo+
IHJlbGVhc2VzLg0KDQoiV2UiIG1lYW5zIG5vcm1hbCBLVk0gcGF0Y2ggZGV2ZWxvcGVycy4gIFll
cyBJIGFncmVlICJzd2l0Y2hpbmcgdG8gdXNlIGxlZ2FjeQ0KTU1VIiBpc24ndCBhIGdvb2QgYXJn
dW1lbnQgZnJvbSBjbG91ZCBwcm92aWRlcnMnIHBvaW50IG9mIHZpZXcuDQoNCg0KLS0gDQpUaGFu
a3MsDQotS2FpDQoNCg0K
