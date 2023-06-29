Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FB0741ECB
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 05:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbjF2DlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 23:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbjF2Dk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 23:40:56 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BF4113;
        Wed, 28 Jun 2023 20:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688010055; x=1719546055;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cWGT8wZOJd4+s79dAk+dBgg4rR00KJ/cHqvY6LvbAbE=;
  b=aFHk6iKzxFDZtxP3YZQYx+GELSJMkIOV8liFpA11OkwrbnY+C5NvJ1GH
   mM40+iib5ZOa31j99DboMEGR2mpcE5+uej2s6i/olGzcQg2q9UHv5fdut
   o0SJNxOrQtQMHeLX6ElQZlQMx6J9CVoC1jv/b34pUstQTAIIDxFGn1OoD
   LiLOqucZ73AZe3OziF0XRccxDF+PQ+y4ReRqc+TZo51rsfVBMVLJe4ka5
   ZxnenTJI5L5Xazb4AWowaodXAwkWsyTGQ88NsscrL6OtCPjkMlPGsFbf+
   CDJtNEJ3XHMy+Hh2kZzTSm/FfEP9vpIYzcoFE9CWiQVbWa+rLE6COhBGC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="360864867"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="360864867"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 20:40:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="841316356"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="841316356"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 28 Jun 2023 20:40:53 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 20:40:53 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 20:40:52 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 20:40:52 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 20:40:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPhg9Mz+B9Zh7RghTymGwVWftufkN8zVC81/VHXTJ3AzShqe0AeiakqASXJ4ZEGMnpN0fV8bF5J7sCILdtfPPGjjd46gokcUdMTvbtY+CBpROIsIeVeVg6/2wqSnX5Ai3hJmC1cx6yr4cRRm5tHo6yPGxfwieJ41Eo8dDKWjedYHulWjl7IblbchjMh1so1YTylzLBsy++XwXuvfaKohO2ZzbkbLT91d7NoIblO5gxfGlQgfgDgf0t0kMqJiD179/y6Pc+1kq+HZEJPK9XDYxk9fY7av+11zFO/SUosE668X2ABSrgN8HGphtvtlkChnmufNO3AV3z5Jc+YjFm5cdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cWGT8wZOJd4+s79dAk+dBgg4rR00KJ/cHqvY6LvbAbE=;
 b=QU2Th/rD+ZG7NiLhp/hDx7lV/ANlKFslHJ+ESXtSNcNUjS4PBdBBQ0OehmyYHlm7xddOkJvn8dNOl8tTzCXSoH39z5cfMH8rY1XEvlRFA++H9X4OHfne3lC3nAP+1vAIb9gV9hUqDxq9W4nmNW/tlYY1NGuIK2EXq3fsmv5LDmTJb4OIE2BpE+OnKpsYnyn7RO9k6xcbt2vK6AAA40ffQ1XTxr84kqAAzqjj442M5508UNdpE70uCzynDDuh0IANzcbYPo0sa0qnqkhLeZCePG0Dt2SAxT5ijsq46+imyzGaUdh+NVXHdlVwG0jYeQIWEh0eauhIrRW++g4vTeq3tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6263.namprd11.prod.outlook.com (2603:10b6:8:a6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Thu, 29 Jun
 2023 03:40:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 03:40:45 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 05/22] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Topic: [PATCH v12 05/22] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Index: AQHZqDWtRkTpkzZfa0qfwqSEOzdd8q+gL/mAgACuGQCAAEh3AA==
Date:   Thu, 29 Jun 2023 03:40:45 +0000
Message-ID: <d8f31af975aaba74828f7aeca5532712c9e0e0eb.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <b2a875fd855145728744617ac4425a06d8b46c90.1687784645.git.kai.huang@intel.com>
         <20230628125813.GA2438817@hirez.programming.kicks-ass.net>
         <84f0acd416aef0796317e76edcf0b63622583436.camel@intel.com>
In-Reply-To: <84f0acd416aef0796317e76edcf0b63622583436.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB6263:EE_
x-ms-office365-filtering-correlation-id: d372d056-ce17-4f09-3bf7-08db78529ed4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: odPGaVtU+7NRkKuilcUX4d3HGVudmMCww9hE0/ebZGSh94kv4chxYm84YDL8fsBFR/qBuRdscgTzCYHbVphY4hbYPCGLd/bqarN3VGQ6H/lO0Jn9zM1OS6IoRLUrQumjva2Z7y/RhHCjDP5/RFQqskah9Jx1t2oyi9JmxOlG9iJY8x5wkA6yMaWcWHr1L9N8vwfxPM3KgeYel6IvBy/BAAe/wdxS9LkKaiHAX35yWjx4tWof28Jb7BC06fW/ge6q2rfcZB5naSkc8pa98l41uUlTo2LQb13WsV7Wy4P6CkMtm+1Wp+STA3WQ9sV4zriUSzGniTblq5za0/WKS1bA45eXgr2fqx+TD9X9sRCgDfDUodMbYFWywllTTEggonUhab4jDzSKj+zijFNfPS2OzK0ev6J+CmqrdMovt7AxEzv6kZTLhpRrJDJSLSF2U1JFEYxsfS1Yg3GJ3E+cg7UaBfW39kz0NEEy0OeaPa9kk78a0oOUcguDwouSJv/1xrAJqpOzd8ur65j80AWwfB1qcYPE6/RKgpdt7BZm5XuW2ZLf6qt6HuXSelov7vHk7+xx4a/wJDCCKAqoXO5IYuXACqU6P1F0VWe0Dps7HledtxTQro3cIF/ui5sO6ypJK6nP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(376002)(366004)(396003)(451199021)(6512007)(66446008)(38070700005)(26005)(66556008)(66476007)(4326008)(66946007)(36756003)(122000001)(7416002)(86362001)(6916009)(8936002)(41300700001)(316002)(8676002)(82960400001)(5660300002)(91956017)(64756008)(38100700002)(76116006)(6506007)(6486002)(186003)(2906002)(83380400001)(4744005)(71200400001)(54906003)(478600001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bzBWYlVVWFFmOTVBYlI1bG9NbHRZckJMaEJQRnFjYUs0ZkpUZXFwZ0ZOWEJn?=
 =?utf-8?B?OXNvenFEYVA0VVBzNTAvbGdnYVlDS0tPYW5DWmRxd2VFajMvTVpGUVpHUVRn?=
 =?utf-8?B?c0RyMlFKNkZqRFYxWUh2elh0cGxwMTF3b2JLWnVmQXRFblZJckFwcUlKeW02?=
 =?utf-8?B?cjFaNk9WL2QvRFZWeXE4MHBWN2pnT01BOSsxOFFId0IzenVFcWZteFE1ajhZ?=
 =?utf-8?B?WWdyR1hERXJadmp3Z2l1RkR5YlJxaEJ5dU1zcmxDSzd5VFA1ZFgwWFNDbE9u?=
 =?utf-8?B?YzRkNFBIL0lBQ0dpYldackYvYjQxM0l4RU1LOFpOYnA2TEhzY0NRZU1nV05r?=
 =?utf-8?B?N0RmQnNQdGltVHhDNlBaS1RyOXM5aFFNZDY4MHVPMXNKbzEvWE9ENUdDVTZp?=
 =?utf-8?B?MDNucjdPV2Jvdnd0elF4MzhwVXpnVnc0VFBBNUcvSW9xbFFDZzA1UDQwQU0z?=
 =?utf-8?B?WTF3M2NEVzhpMWwzWU9SK0NUYy9ZNkVLelRwT056SFIyVFI0bUFpQVQvVWtm?=
 =?utf-8?B?dDBiOUQ4eTBWZUFIL2R2VFFjc1dlbEpSNDJYRWoweWtFTEZ4YWxqMFhqUnFK?=
 =?utf-8?B?UGVzMG1iTGtSSThZdk0rdmlKa2wyTzRDQjBXakJVSnE5TVpGVDBQSU40djlB?=
 =?utf-8?B?aVIzVDcrMURHTHYxV2JCakpZenIwL1NnSC9CNlJ5OC84eU4xVWI5cVNNcCsw?=
 =?utf-8?B?Q2RaNi96aFFneHlnMk15N2VyaVFNeXQ1RkJhd056NHBvdExVaTA1SVlDTVFQ?=
 =?utf-8?B?V05WR2lwUElVcGJsY2UvM2VwQVpwTUdZQWovNFRBektzWTl6eCswT052cVVi?=
 =?utf-8?B?NUdGZVRha0F3OWpkQWs0bitjNjFkUnprOVRiV3JTSXVOUmFnc1BmWHBiNnBu?=
 =?utf-8?B?bkFOM1RWc0MvamFFTURYV0Q5YzB4RFRaS0RXbVRTMFo4STFndmpsOStXL3VJ?=
 =?utf-8?B?UHQ3d1QzaHRjcjExSitjdWhmV054aHp0VnJSZE1MTjhKdjUvQWswQWN3a1lZ?=
 =?utf-8?B?QVBzUk5ITllpajY4c1AvV1pKYWVJRVhVSmpsK3ZiOW5MejF2cDJRenZpUVdP?=
 =?utf-8?B?V01iaGdRek55K0pkOGIwY2tZRk9kTExiMm1jWVV3TVlzN3lPbE51dWsvZTFt?=
 =?utf-8?B?Y1B4NFFQbkEzYnlRV1YyV2V2V2ovK0VBQjVxYloxckxKQlJ4d3cvWUJCNm16?=
 =?utf-8?B?TXJpRnFNSWdmZWoxUEpqT2FBSjZYVmlHMjBGRjBwTWc1OXlad1dVRW4rOG1B?=
 =?utf-8?B?Y2FyUklPUnBJR091UktweklvNFJCY29GeDhWMy9uM09PRXR6Q3JTdWRKUVpF?=
 =?utf-8?B?em5HRVV5SGZWRG9aN0pqdFU4NkVYNEF3ZjRyMGo1N3VUczFhenVUY1cwQmRF?=
 =?utf-8?B?VXMwZHZ4UEtMQUltNjk1NExuZTkwNVJES2hYN2hEbXpiSXdITEhwVTFlTXBK?=
 =?utf-8?B?dzJBT2hhdG44WkprTTZUUkRLNmh5MzNwYUhiMmEzWjRFKzVwNWQvekNmSXFD?=
 =?utf-8?B?b1VrdXYrSGxKWEZYS3VCamFRMFdySnpNWWtOUFNqZnB5UDdBK1QwNmY3RTZU?=
 =?utf-8?B?dENQT1hSUVJSaDR4blNHZXZLSllqODlPcTMvNjgyc3lrdlYwcmY2WU5RNWE5?=
 =?utf-8?B?TmRiUWdqZm5wbjFFWnVPQnF2ZlFtcGwweFdRNDZPWG1SaGlGVmRqdWVlblFV?=
 =?utf-8?B?ZkhiWG9SL1BxR2VZTkFEVkRqQXUxRDArVXhGY1htTkVMT095RHFCVEpDaysr?=
 =?utf-8?B?SDVrZTJCckZCbk1Ud20wNVBqK3ZxeFlhVVZMQlpwM28rQk9jcmEyTDZhQmtL?=
 =?utf-8?B?V1o0TEtFSzVybG5jN3BCVVNzT01hLzFsSXFDRUVjR2VyQjJlOGdmL2JYUlF3?=
 =?utf-8?B?WFlZaGlKQWwwSDNKK25FblV4eHpBampGbVEwSnFoN1UrYWJrYkZndDB4Vjl0?=
 =?utf-8?B?OHRBbnFHOVdHd1VvcUk0cnppd0syNVhJRXhyUUdnd2Y3K1pjSnZPc1NtZEdB?=
 =?utf-8?B?amNMb2o3ckJSQ2JDVmNlQjExNkdwZEIwV2RzOXc5NS9uZnFEN1FOY0F2T1VM?=
 =?utf-8?B?ZURNblQzTDU2TXhYWGJPNFlNNVEwbVA0ZUg5dklMLzRBVHNrUS9tRzM1TStj?=
 =?utf-8?B?ZXlhQzRsRzNhcjhzbmV4Z2M3cXJaRlJiVVlCdXI2KzVlNFN1cS81WXQ2dHpt?=
 =?utf-8?B?a3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1934397466D1C4282E7166438BA996F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d372d056-ce17-4f09-3bf7-08db78529ed4
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2023 03:40:45.0386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w6BUvovp84BlTympObhY1naZZHAQPavRnfSIQiIZR9IBhSW2Ivwieso9gsipksUMcS+jkbPLqszZ2KkS+0klyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6263
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

T24gV2VkLCAyMDIzLTA2LTI4IGF0IDIzOjIxICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
ID4gKwkvKiBOZWVkIGEgc3RhYmxlIENQVSBpZCBmb3IgcHJpbnRpbmcgZXJyb3IgbWVzc2FnZSAq
Lw0KPiA+ID4gKwljcHUgPSBnZXRfY3B1KCk7DQo+ID4gDQo+ID4gQW5kIHRoYXQncyBpbXBvcnRh
bnQgYmVjYXVzZT/CoA0KPiA+IA0KPiANCj4gSSB3YW50IHRvIGhhdmUgYSBzdGFibGUgY3B1IGZv
ciBlcnJvciBtZXNzYWdlIHByaW50aW5nLg0KDQpTb3JyeSBtaXN1bmRlcnN0b29kIHlvdXIgcXVl
c3Rpb24uDQoNCkkgdGhpbmsgaGF2aW5nIHRoZSBDUFUgaWQgb24gd2hpY2ggdGhlIFNFQU1DQUxM
IGZhaWxlZCBpbiB0aGUgZG1lc2cgd291bGQgYmUNCmJldHRlcj8gIEJ1dCBpdCdzIG5vdCBhYnNv
bHV0ZWx5IG5lZWRlZC4gIEkgY2FuIHJlbW92ZSBpdCAodGh1cyByZW1vdmUNCntnZXR8cHV0fV9j
cHUoKSkgaWYgeW91IHByZWZlciBub3QgdG8gcHJpbnQ/DQo=
