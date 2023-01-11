Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59CC665888
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 11:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbjAKKEj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 05:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239174AbjAKKDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 05:03:39 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F6512D16;
        Wed, 11 Jan 2023 02:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673431219; x=1704967219;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1I8u0upLP7fTrhG0MiEBSCH2/sXNLkZ60ZTuhjuham8=;
  b=Vim6bCsQxv3rD2DLPlyKmEHYpL+jp2aSK9kot0X4XilLYE/DHb3NVacR
   TAtkZEvlPOTEc4UbWi89jTOwm3gkaxRxwk+FMEWLSyHBR8e50Oc99qV3x
   2CDhKm4tXEfmxLP2S53ckD4Dk9X7vRupE9t1ksZadsWopWnY97nA/xZje
   Qi0/onVX15w0iBrb3dD2tNXtOFm8yLBaBQI9BOpQW9Z90X3Qf6VwmtIwn
   hlix0AGd+lrUUzPQHVYMbhQoci3oLw7WNigGgu/42ilpfBER96kQFIWUU
   UwGH52UNNBBitoZdZnvp9lyV6JXM6q9fu+r6yoN7vRk8fZrkH2SQYtwmW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="387837484"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="387837484"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 02:00:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="659310791"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="659310791"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 11 Jan 2023 02:00:13 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 02:00:13 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 02:00:12 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 11 Jan 2023 02:00:12 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 11 Jan 2023 02:00:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WknDZfFuB60Kz5311Fb304NLT1AG7aZLhxjodx4N2RalvSgJV3lx0gZlmR2qj0HKKNH6eK41QGoIfCptdcYq08hkFvq+03SZmgLgXStGdqqNTShzXcXPdN2kkDtNUFHj5eSJGoMfT7C2kx43/u0DAlKkXN4/+fqusaDt+UdOAnfufx+G8EjWUYwqik7R4797+wyqmduZEQCmIE70u+ifPDJ0ANzEQ+8AxuIpM27iJyjGqEAMR7XXKPXIBWrzVhcPhlCI0SSzul7lENqlQjLCZhXajq3c0SqCj/yi0pHCiCD4G8Dk72gnpU34f8q5n9C3oAHkvacFhsuArgsvO+VwxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1I8u0upLP7fTrhG0MiEBSCH2/sXNLkZ60ZTuhjuham8=;
 b=l5Ri+dNXPXhXrStc9Wynwv6ZNwwPir6pUw9gr6zOzZjWLuL/mZLh7rb1cmD5buCvJtiCE0R8ygZLEr5gOKJINhmHPJIDW13cc5oMRi1ph3c02YYqtPSkITCW6gfsV1ubEm821lsbGhPa44rANhTGiY1KV32+XqYq4o7PC5eof03mfTP9oS7G3M/XHdVRuCB9OyZgHTZITVLfm5NGLa1S96ohjjo5RKFaX8BH7p5OFy7dkOSSk3LXnWlL35h2aCbH5t1em51ERGLtzVi2jfTbQ3A4zLmaqXn+Pp0H9er4buECOXRomwwriUsO9t2Codu0X7UriAf1vQaCSLqedA9TtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by BL1PR11MB6001.namprd11.prod.outlook.com (2603:10b6:208:385::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 10:00:08 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::ed5d:ddf5:d289:3076]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::ed5d:ddf5:d289:3076%9]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 10:00:08 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 07/16] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v8 07/16] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHZC5gLiOnJQQKFB0CM7X30zcZDS66R31QAgARKC4CAAFSjAIABQ4mAgABFsgCAASiJAA==
Date:   Wed, 11 Jan 2023 10:00:07 +0000
Message-ID: <13096e4e39801806270c3a6a641102a8151aa5fc.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <8aab33a7db7a408beb403950e21f693b0b0f1f2b.1670566861.git.kai.huang@intel.com>
         <e7b682a1-abdf-ce73-f262-8b7ce946e78e@intel.com>
         <bc11552572428c3b29b67852b062c387ecd7be45.camel@intel.com>
         <e02fd75d-e9d4-15f1-eb9c-31cf3cc9ddc1@intel.com>
         <a5d4de8b074b6d1a34bd3d424c5c4f0d677ec15f.camel@intel.com>
         <16f23950-2a27-29de-c0b4-e5f2d927c8b4@intel.com>
In-Reply-To: <16f23950-2a27-29de-c0b4-e5f2d927c8b4@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|BL1PR11MB6001:EE_
x-ms-office365-filtering-correlation-id: e5667cfa-1c90-42e5-07e3-08daf3ba9ebc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T1+qeKga3zA2VFFAd4dOrKkZ/DipFwmn4uHI9uHlKJS/V+A9TGP/WQHKkTNQ3hWeQKCxp7lhT5w1gWAGiAUjzTNe00iMdh+3ciRD/yh0Fydx4MaYudCLjHonYaJkIlWinB2RL9v2OM2ItUP1wwyj1x9UFq+AOm6xJ1ZF3RYQNVcXOckHbglUMQxff0FSKUd2elk84sNohZtFqqadI1ibrCOT/cJt10gFTzG85QfRHlrNReacfXJ1za5cECJWn9JV/UqPIwRN8r83U+HU70dtM7Kjc3VhnmauMqMLDGEpaR6k/Ay7NA424FsPPVydMRyzwaM7L/fCKf1J5aSwIc+PaL591Mn1TO8RNgwSLvXPBaF3UdpB4Nw9T5271Libh5HtyyfP4SDw5gv09rXqXOdC+Yd4f4b7d3+rAxAfIVmHFAIKmJKckQFEp0vphM9HzwFX0DCTYCXUr6mmvD0WoblEC7ZUWG0QwGOd014Z2xHUBhSvBfxQDsuCC721JqQ5n54vT/ZZ/2H1LgwMTyLaftuX6OI3zpNh7jRxTF1OgTxgYfkM5165QLX5sF1/PBnrEdNpSbmw1Zp3564tXGD3qM/ddiTRmW9P67pFx0K67kyU+cJ7/Q9duGsCEcev4pRChG2uLV55R5Vg7FavWQ4z3nQHPXtFrgQGQP53tkZU+chXaWuujsrcYWkxD669Vks8QBCTtCXxZqZtE+GTGb8subyCrg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(39860400002)(366004)(136003)(346002)(451199015)(6506007)(26005)(6486002)(478600001)(6512007)(186003)(66476007)(76116006)(64756008)(2616005)(71200400001)(66946007)(8676002)(41300700001)(66446008)(54906003)(53546011)(110136005)(316002)(4326008)(83380400001)(82960400001)(86362001)(38070700005)(38100700002)(122000001)(66899015)(66556008)(7416002)(8936002)(36756003)(5660300002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SWtNNFlRREVIYTRUTWNlL2VweG0xZzVBMk9LWmFic25LM2UwUVJwcGVtL2xC?=
 =?utf-8?B?SGtvQWxDa1RIZUY3Q01nUk4xREVmZ0R6dmFFNVNuaERBdTVDd3dVWEhOVFRh?=
 =?utf-8?B?MENveC9MckpoN09yT3l4RU1JVUtUVFJ3b1JTWm9FbXFlRHJtOGZxaTNCKzI2?=
 =?utf-8?B?aVBENXBwdkdKY2FoOXQxSTNFbUUyOFhpa3BJN2owR2ltR0VBYXlhY2tZRU9H?=
 =?utf-8?B?K0JLZnBiUmF3bFJaVUE4NGtrejdOZmdHQkdUOG10bnQ4UGNFWjUvV05MNGlK?=
 =?utf-8?B?MkdKVEZsZXlQcm5ldlBSNE9DNFhzaUtDZW1RS1grbWRycmZlUDAvbnY1L1Vp?=
 =?utf-8?B?akljVWZjNHY5bzZwREFGUE13ZkpFKzdXbER4dGtYSG1lSU5qZis5b1FwUFpN?=
 =?utf-8?B?cWxjcGZVcnd2dGN2RGRjc2lVbU5TazZRWVg1dVMzK3BhVmROTW9wWHlGU3Fs?=
 =?utf-8?B?Zm04ajdMMmxBamN5YXl3b3Qrais2Yys3SWV0cDMvRjVodzNLSjhBMlRQMW5K?=
 =?utf-8?B?N0lzWE5YMHdpVzZGU292NHRqNklPaCt5ajg1N1pLcldDWFZIQlhJRU9KVmlj?=
 =?utf-8?B?S0JTNHpVNWJhZVZWZmFmcmR0Wk5sd0QwUnY0bWpTSWVnVmo1UkordDdrZ3hr?=
 =?utf-8?B?MXdhSHZyVk1hWHRNaEYvNGpZUnowcXZJRktyZTBMY1hVSllXY0V2bTB4UW9B?=
 =?utf-8?B?OWkwWFAvQ0VxSC9ScEtjZFgvdEZ6dW1kM1FzSituSlFSWDNndlRkdGdveFJp?=
 =?utf-8?B?S09JWE56QVZKTDRDUWM3U2JUNDgrdG9wYzJnb0traGFxNWJyQzlrNXk2Mk9q?=
 =?utf-8?B?dlc3VXlKa29KaGdiTkxFVUtSMityQXlDNHloMEUwbXhzOStLY2xTU3kvWHN0?=
 =?utf-8?B?d3FocVN6OVVzT1VzMExyaXNFaGRsSjlzb2lNc0prMlIrcENZYXVCNlh5dXM3?=
 =?utf-8?B?WnYzcXp2MzR5RXJHTStRcFErd0YvMzFWUGZyZ2w0dldlWC9WdlFnWFZFODhV?=
 =?utf-8?B?YlVnLzlzRUNzN3JWYTc3SGNIeWs1cmV0SzZRc2JHbnkwUXh5VHRCcjhyWnlk?=
 =?utf-8?B?YkJkUk9SU1NzVUdDUm81RUNLMEFoWTVwWDFrR3JzdUZ5QXF5T2JET1JQaUJS?=
 =?utf-8?B?YWRWa2RXdDJ2eUtOSERYenE3bm4zVlloMkdWQzUzcmRJMzM1MjhSZmxYcmk2?=
 =?utf-8?B?M2xMbTc0L3VEVUtQTjFFTVV4NTRZZ3VHYXNKWDBYVHlwNzNoSEZzbHJOa0pM?=
 =?utf-8?B?UXhtT0JQemE1RlIrdTF0bFV5UzlnUXV4d2I3R29iVzZhaDJQU2hwKzlua1VJ?=
 =?utf-8?B?NEhJSHJxNzZybmpzckhiQWVYOTZ2SGZlK1lTV2hXL3NaQ1VOME1sQlpZdW5w?=
 =?utf-8?B?L0ZCd1lLa2NFZWMrYUxldjliVC8yaExzWXoyajgvb3BrN3RINmgxbFY4U1Vr?=
 =?utf-8?B?aXhZY2puUTZodEpTTGltNU5QTG4wei95QmFIaHJ2L0cvRFUwSWZKMldwdWp2?=
 =?utf-8?B?NzNxYmkrb1dRWjM5UFg4REkxd09TQTR1aHNObjNUcFFvRW1xaSt5TEo1d2RF?=
 =?utf-8?B?cjFmc1NOMEQvYWVwYTZlVVRtR0FDTUNBVURQWW9kMWVLejFQbGZHY0d4eXJN?=
 =?utf-8?B?emp5N0tZdk5VbWhDMytpbEEva0hHclcrWUc4NG5KNHVFY0M0S0NYTlp1MFRn?=
 =?utf-8?B?ZkxiRkVSeGlQL0s2ZHk5cTA2TTlpeGc1a1lqTmZYL2tGTjYwRmFnOVI1UVRy?=
 =?utf-8?B?MWxmNG1rN1pPNURTemVhbjc2L2JSQ2hXVHlhOTQ2Q0p3OG9lQjFaTnBLSlhm?=
 =?utf-8?B?eTFDUjdYNnRvNlh6b1U2MXBlSW1kTG1hdDBhUmp4dkxQdG9LSWRESzBla1Vr?=
 =?utf-8?B?K2pocWw4SFpmNVBpc2RkNmNQUjlFdy9kQnhadjY1dDRrN2wrMnViYTVBa3Vt?=
 =?utf-8?B?aHY2RnByclJnM1Nnc2FwMFpIVS9CVytrd3RFbmtXeVFwaHNISi93VUhoRFpI?=
 =?utf-8?B?SzhMS3NnRDluRVp6QVlnWERud0JzM3dlN3pHWTBsZ0JLWTF3cGR6bENYdkRw?=
 =?utf-8?B?UHI1QktUZG1rcU8ybHNob3gwaCswL3VxT2FjaVg0Tk1MQmN5ZHBMTDFkdzk4?=
 =?utf-8?B?dTZQOGhKdzdSWU5ZRUlMRWJuZERzdXlBN2ZmMUZxT1pBSWJjdWdBV3J0RTUv?=
 =?utf-8?B?L2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <68C4103A6C69CA4DA2ECD976246DDD66@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5667cfa-1c90-42e5-07e3-08daf3ba9ebc
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2023 10:00:07.8623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i9Zv6/jZlopd6YHpQozdumwG1IKjXOWid3Epe0I+Oa6xt5iX2mqAvZsMtzxHOH4MtBFAabHDBKv9Cg2uG0AxuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6001
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAxLTEwIGF0IDA4OjE4IC0wODAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDEvMTAvMjMgMDQ6MDksIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gT24gTW9uLCAyMDIzLTAx
LTA5IGF0IDA4OjUxIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4gPiA+IE9uIDEvOS8yMyAw
Mzo0OCwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+ID4gPiA+ID4gPiBUaGlzIGNhbiBhbHNvIGJl
IGVuaGFuY2VkIGluIHRoZSBmdXR1cmUsIGkuZS4gYnkgYWxsb3dpbmcgYWRkaW5nIG5vbi1URFgN
Cj4gPiA+ID4gPiA+ID4gPiBtZW1vcnkgdG8gYSBzZXBhcmF0ZSBOVU1BIG5vZGUuICBJbiB0aGlz
IGNhc2UsIHRoZSAiVERYLWNhcGFibGUiIG5vZGVzDQo+ID4gPiA+ID4gPiA+ID4gYW5kIHRoZSAi
bm9uLVREWC1jYXBhYmxlIiBub2RlcyBjYW4gY28tZXhpc3QsIGJ1dCB0aGUga2VybmVsL3VzZXJz
cGFjZQ0KPiA+ID4gPiA+ID4gPiA+IG5lZWRzIHRvIGd1YXJhbnRlZSBtZW1vcnkgcGFnZXMgZm9y
IFREWCBndWVzdHMgYXJlIGFsd2F5cyBhbGxvY2F0ZWQgZnJvbQ0KPiA+ID4gPiA+ID4gPiA+IHRo
ZSAiVERYLWNhcGFibGUiIG5vZGVzLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBXaHkgZG9l
cyBpdCBuZWVkIHRvIGJlIGVuaGFuY2VkPyAgV2hhdCdzIHRoZSBwcm9ibGVtPw0KPiA+ID4gPiAN
Cj4gPiA+ID4gVGhlIHByb2JsZW0gaXMgYWZ0ZXIgVERYIG1vZHVsZSBpbml0aWFsaXphdGlvbiwg
bm8gbW9yZSBtZW1vcnkgY2FuIGJlIGhvdC1hZGRlZA0KPiA+ID4gPiB0byB0aGUgcGFnZSBhbGxv
Y2F0b3IuDQo+ID4gPiA+IA0KPiA+ID4gPiBLaXJpbGwgc3VnZ2VzdGVkIHRoaXMgbWF5IG5vdCBi
ZSBpZGVhbC4gV2l0aCB0aGUgZXhpc3RpbmcgTlVNQSBBQklzIHdlIGNhbg0KPiA+ID4gPiBhY3R1
YWxseSBoYXZlIGJvdGggVERYLWNhcGFibGUgYW5kIG5vbi1URFgtY2FwYWJsZSBOVU1BIG5vZGVz
IG9ubGluZS4gV2UgY2FuDQo+ID4gPiA+IGJpbmQgVERYIHdvcmtsb2FkcyB0byBURFgtY2FwYWJs
ZSBub2RlcyB3aGlsZSBvdGhlciBub24tVERYIHdvcmtsb2FkcyBjYW4NCj4gPiA+ID4gdXRpbGl6
ZSBhbGwgbWVtb3J5Lg0KPiA+ID4gPiANCj4gPiA+ID4gQnV0IHByb2JhYmx5IGl0IGlzIG5vdCBu
ZWNlc3NhcmlseSB0byBjYWxsIG91dCBpbiB0aGUgY2hhbmdlbG9nPw0KPiA+ID4gDQo+ID4gPiBM
ZXQncyBzYXkgdGhhdCB3ZSBhZGQgdGhpcyBURFgtY29tcGF0aWJsZS1ub2RlIEFCSSBpbiB0aGUg
ZnV0dXJlLiAgV2hhdA0KPiA+ID4gd2lsbCBvbGQgY29kZSBkbyB0aGF0IGRvZXNuJ3Qga25vdyBh
Ym91dCB0aGlzIEFCST8NCj4gPiANCj4gPiBSaWdodC4gIFRoZSBvbGQgYXBwIHdpbGwgYnJlYWsg
dy9vIGtub3dpbmcgdGhlIG5ldyBBQkkuICBPbmUgcmVzb2x1dGlvbiwgSQ0KPiA+IHRoaW5rLCBp
cyB3ZSBkb24ndCBpbnRyb2R1Y2UgbmV3IHVzZXJzcGFjZSBBQkksIGJ1dCBoaWRlICJURFgtY2Fw
YWJsZSIgYW5kICJub24tDQo+ID4gVERYLWNhcGFibGUiIG5vZGVzIGluIHRoZSBrZXJuZWwsIGFu
ZCBsZXQga2VybmVsIHRvIGVuZm9yY2UgYWx3YXlzIGFsbG9jYXRpbmcNCj4gPiBURFggZ3Vlc3Qg
bWVtb3J5IGZyb20gdGhvc2UgIlREWC1jYXBhYmxlIiBub2Rlcy4NCj4gDQo+IFRoYXQgZG9lc24n
dCBhY3R1YWxseSBoaWRlIGFsbCBvZiB0aGUgYmVoYXZpb3IgZnJvbSB1c2Vycy4gIExldCdzIHNh
eQ0KPiB0aGV5IGRvOg0KPiANCj4gCW51bWFjdGwgLS1tZW1iaW5kPTYgcWVtdS1rdm0gLi4uDQo+
IA0KPiBJbiBvdGhlciB3b3JkcywgdGFrZSBhbGwgb2YgdGhpcyBndWVzdCdzIG1lbW9yeSBhbmQg
cHV0IGl0IG9uIG5vZGUgNi4NCj4gVGhlcmUgbG90cyBvZiBmcmVlIG1lbW9yeSBvbiBub2RlIDYg
d2hpY2ggaXMgVERYLSpJTipjb21wYXRpYmxlLiAgVGhlbiwNCj4gdGhleSBtYWtlIGl0IGEgVERY
IGd1ZXN0Og0KPiANCj4gCW51bWFjdGwgLS1tZW1iaW5kPTYgcWVtdS1rdm0gLXRkeCAuLi4NCj4g
DQo+IFdoYXQgaGFwcGVucz8gIERvZXMgdGhlIGtlcm5lbCBzaWxlbnRseSBpZ25vcmUgdGhlIC0t
bWVtYmluZD02PyAgT3IgZG9lcw0KPiBpdCByZXR1cm4gLUVOT01FTSBzb21ld2hlcmUgYW5kIGNv
bmZ1c2UgdGhlIHVzZXIgd2hvIGhhcyAqTE9UUyogb2YgZnJlZQ0KPiBtZW1vcnkgb24gbm9kZSA2
Lg0KPiANCj4gSW4gb3RoZXIgd29yZHMsIEkgZG9uJ3QgdGhpbmsgdGhlIGtlcm5lbCBjYW4ganVz
dCBlbmZvcmNlIHRoaXMNCj4gaW50ZXJuYWxseSBhbmQgaGlkZSBpdCBmcm9tIHVzZXJzcGFjZS4N
Cg0KSUlVQywgdGhlIGtlcm5lbCwgZm9yIGluc3RhbmNlIEtWTSB3aG8gaGFzIGtub3dsZWRnZSB0
aGUgJ3Rhc2tfc3RydWN0JyBpcyBhIFREWA0KZ3Vlc3QsIGNhbiBtYW51YWxseSBBTkQgIlREWC1j
YXBhYmxlIiBub2RlIG1hc2tzIHRvIHRhc2sncyBtZW1wb2xpY3ksIHNvIHRoYXQNCnRoZSBtZW1v
cnkgd2lsbCBhbHdheXMgYmUgYWxsb2NhdGVkIGZyb20gdGhvc2UgIlREWC1jYXBhYmxlIiBub2Rl
cy4gIEtWTSBjYW4NCnJlZnVzZSB0byBjcmVhdGUgdGhlIFREWCBndWVzdCBpZiBpdCBmb3VuZCB0
YXNrJ3MgbWVtcG9saWN5IGRvZXNuJ3QgaGF2ZSBhbnkNCiJURFgtY2FwYWJsZSIgbm9kZSwgYW5k
IHByaW50IG91dCBhIGNsZWFyIG1lc3NhZ2UgdG8gdGhlIHVzZXJzcGFjZS4NCg0KQnV0IEkgYW0g
bmV3IHRvIHRoZSBjb3JlLW1tLCBzbyBJIG1pZ2h0IGhhdmUgc29tZSBtaXN1bmRlcnN0YW5kaW5n
Lg0KDQo+IA0KPiA+ID4gSXMgdGhlcmUgc29tZXRoaW5nIGZ1bmRhbWVudGFsIHRoYXQga2VlcHMg
YSBtZW1vcnkgYXJlYSB0aGF0IHNwYW5zIHR3bw0KPiA+ID4gbm9kZXMgZnJvbSBiZWluZyByZW1v
dmVkIGFuZCB0aGVuIGEgbmV3IGFyZWEgYWRkZWQgdGhhdCBpcyBjb21wcmlzZWQgb2YNCj4gPiA+
IGEgc2luZ2xlIG5vZGU/DQo+ID4gPiBCb290IHRpbWU6DQo+ID4gPiANCj4gPiA+IAl8IG1lbWJs
b2NrICB8ICBtZW1ibG9jayB8DQo+ID4gPiAJPC0tTm9kZT0wLS0+IDwtLU5vZGU9MS0tPg0KPiA+
ID4gDQo+ID4gPiBGdW5reSBob3RwbHVnLi4uIG5vdGhpbmcgdG8gc2VlIGhlcmUsIHRoZW46DQo+
ID4gPiANCj4gPiA+IAk8LS0tLS0tLS1Ob2RlPTItLS0tLS0tLT4NCj4gPiANCj4gPiBJIG11c3Qg
aGF2ZSBtaXNzZWQgc29tZXRoaW5nLCBidXQgaG93IGNhbiB0aGlzIGhhcHBlbj8NCj4gPiANCj4g
PiBJIGhhZCBtZW1vcnkgdGhhdCB0aGlzIGNhbm5vdCBoYXBwZW4gYmVjYXVzZSB0aGUgQklPUyBh
bHdheXMgYWxsb2NhdGVzIGFkZHJlc3MNCj4gPiByYW5nZXMgZm9yIGFsbCBOVU1BIG5vZGVzIGR1
cmluZyBtYWNoaW5lIGJvb3QuICBUaG9zZSBhZGRyZXNzIHJhbmdlcyBkb24ndA0KPiA+IG5lY2Vz
c2FyaWx5IG5lZWQgdG8gaGF2ZSBESU1NIGZ1bGx5IHBvcHVsYXRlZCBidXQgdGhleSBkb24ndCBj
aGFuZ2UgZHVyaW5nDQo+ID4gbWFjaGluZSdzIHJ1bnRpbWUuDQo+IA0KPiBJcyB5b3VyIG1lbW9y
eSBjb3JyZWN0PyAgSXMgdGhlcmUgZXZpZGVuY2UsIG9yIHJlcXVpcmVtZW50cyBpbiBhbnkNCj4g
c3BlY2lmaWNhdGlvbiB0byBzdXBwb3J0IHlvdXIgbWVtb3J5Pw0KPiANCg0KSSB0cmllZCB0byBm
aW5kIHdoZXRoZXIgdGhlcmUncyBhbnkgc3BlYyBtZW50aW9uaW5nIHRoaXMsIGJ1dCBzbyBmYXIg
ZGlkbid0IGZpbmQNCmFueS4gIEknbGwgYXNrIGFyb3VuZCB0byBzZWUgd2hldGhlciB0aGlzIGNh
c2UgY2FuIGhhcHBlbi4NCg0KQXQgdGhlIG1lYW50aW1lLCBJIGFsc28gc3BlbnQgc29tZSB0aW1l
IGxvb2tpbmcgaW50byB0aGUgbWVtb3J5IGhvdHBsdWcgY29kZQ0KbW9yZSBkZWVwbHkuICBCZWxv
dyBpcyBteSB0aGlua2luZzoNCg0KRm9yIFREWCBzeXN0ZW0sIEFGQUlDVCBhIG5vbi1idWdneSBC
SU9TIHdvbid0IHN1cHBvcnQgcGh5c2ljYWxseSBob3QtcmVtb3ZpbmcNCkNNUiBtZW1vcnkgKHRo
dXMgbm8gaG90LWFkZCBvZiBDTVIgbWVtb3J5IGVpdGhlcikuICBTbyB3ZSBhcmUgZWl0aGVyIHRh
bGtpbmcNCmFib3V0IGhvdC1hZGRpbmcgb2Ygbm9uLVREWC11c2FibGUgbWVtb3J5ICh0aG9zZSBh
cmUgbm90IGNvbmZpZ3VyZWQgdG8gVERYDQptb2R1bGUpLCBvciBrZXJuZWwgc29mdCBvZmZsaW5l
IC0+IChvcHRpb25hbCByZW1vdmUgLT4gYWRkIC0+KSBvbmxpbmUgYW55IFREWC0NCnVzYWJsZSBt
ZW1vcnkuDQoNCkZvciB0aGUgZm9ybWVyIHdlIGRvbid0IG5lZWQgdG8gY2FyZSBhYm91dCB3aGV0
aGVyIHRoZSBuZXcgcmFuZ2UgY2FuIGNyb3NzDQptdWx0aXBsZSB0ZHhfbWVtbGlzdCBlbnRyaWVz
LiAgRm9yIHRoZSBsYXR0ZXIsIHRoZSBvZmZsaW5lIGdyYW51bGFyaXR5IGlzDQonc3RydWN0IG1l
bW9yeV9ibG9jaycsIHdoaWNoIGlzIGEgZml4ZWQgc2l6ZSBhZnRlciBib290IElJVUMuIMKgDQoN
CkFuZCB3ZSBjYW4gb25seSBvZmZsaW5lIG9uZSBtZW1vcnlfYmxvY2sgd2hlbiBpdCBtZWV0czog
MSkgbm8gbWVtb3J5IGhvbGUsIGFuZDsNCjIpIGFsbCBwYWdlcyBhcmUgaW4gc2luZ2xlIHpvbmUu
ICBJSVVDIHRoaXMgbWVhbnMgaXQncyBub3QgcG9zc2libGUgdGhhdCB3ZQ0Kb2ZmbGluZSB0d28g
YWRqYWNlbnQgY29udGlndW91cyB0ZHhfbWVtbGlzdCBlbnRyaWVzIGFuZCB0aGVuIG9ubGluZSB0
aGVtDQp0b2dldGhlciBhcyBhIHNpbmdsZSBvbmUuDQo=
