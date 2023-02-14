Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04395696EDD
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 22:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbjBNVIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 16:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBNVIk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 16:08:40 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C97E27996;
        Tue, 14 Feb 2023 13:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676408920; x=1707944920;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ogS7SmFm3ptPm9Oe6Ja8zw865hiHioWaNMGN9pcweRc=;
  b=VWyltYXaBw9mUTpGIOCVZ7jWAG7KnuS+on4L31PES9Zec1yPKgO+87vS
   qwZ+f4TLlTNrs7O/TPat+jUuutUjWggZ0pNxnIsMvoLt0O9n08xA6ZP1T
   jjGCcU8bcnTbKcEkqoOMMkWPCsLldlDYCNTmkCBkFokHNZw1n5ToVBoGg
   gNKiJ85eyvqdQzPsDMAi9kMTJv9PMVCX3ky/B0yeX1sKcxBvCge0rVoQn
   TmcG7TSxfl1DYAjx8ZdYHu5rxUk+UxfpasJNfA96+oqojoASPBwYuJwj0
   AlDCfIglLBVdmlaKXC1uCtTB6GMq28fvNOkeEhsjLpBn+AQivBOVf877i
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="417492011"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="417492011"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 13:08:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="699679769"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="699679769"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 14 Feb 2023 13:08:20 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 13:08:19 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 13:08:19 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 13:08:19 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 13:08:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fSDkVq65WVqEVVEuxTBWlaYksPqN92vF+onAt2hwDg2ek6ItM/7+sX5etgu3IzM9rQ7+FzhNsSOzkCPD5fXtbdXju2DWgybSlPAU2O7WjyIiiHiEjuyeoBWWu8zsevGfzoiiB6HnC/LVGTQvqc7ageVIvK9xsZ4Ac0xFPxEZ2A88Jlvv+8Zbp8Ujd3w9wB/AVDYMM0JNBrRs1KEAwchmIxuTsBYKMS2+ei8TkwfQUwDtzFOCmGAcjNME1tQEnAMTjpxxDJ+j8hLcRRKVGXC0TYxdzN4DKGVtCIegQNDG8YiuG7LEqOWIpdE7W8gEshynd4paS6DNn1m1XFdLoxMvqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ogS7SmFm3ptPm9Oe6Ja8zw865hiHioWaNMGN9pcweRc=;
 b=BTFxxpZnlfqnRNSmHJj0UJEyhAl0q/WZiKgtRU5zB2UMEJVpPO64DLrCuA8f27fxXeT4uuDMRs6HUSUPlJghQdulBXurh+A0sngTKV1rezZ0i5ZOhiExOiDyB7mNkuH29L0r6kJzDksKTuoSbf5F1NST3H/yShlb5IC4TIxsng8DyVyXVO+lLNNZvp5ZUidYd+/71kJJ4+45LXyYL4gkjUAAaw6906Rxrz2wLkEbfMf7gNc3EY+h4Opu0PhhFUydMA9/PTsVTnmyBC3YEKgnLWsxyMu6mgQ8SkESUY/UF4AcOJE2+KxZ2YWKowgxTIxy5ma3C/QLwtZ5hQJEiVMv+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB6356.namprd11.prod.outlook.com (2603:10b6:510:1fc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 21:08:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%7]) with mapi id 15.20.6086.026; Tue, 14 Feb 2023
 21:08:10 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v9 04/18] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Thread-Topic: [PATCH v9 04/18] x86/virt/tdx: Add skeleton to initialize TDX on
 demand
Thread-Index: AQHZP5usbYER0k2ezkeojPWR4zvm4a7OZZKAgABNXwCAAD63AA==
Date:   Tue, 14 Feb 2023 21:08:09 +0000
Message-ID: <49f0887560ec5170761e908cb6001e4145b35e1c.camel@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
         <eb565156d84e35a846a886025513a712f2ac2f83.1676286526.git.kai.huang@intel.com>
         <Y+uCtZ7itiNsbR4j@hirez.programming.kicks-ass.net>
         <a44246e1-72de-4c9a-c602-dfc2f7df129b@intel.com>
In-Reply-To: <a44246e1-72de-4c9a-c602-dfc2f7df129b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB6356:EE_
x-ms-office365-filtering-correlation-id: 0384ef6a-b1ea-41b7-324d-08db0ecf93ae
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HREjakRqBPZPr9fox8eHPzgWtECBwZzWgGtRXHEw5eKLFyDHvQS3Sj5yfR41vKqdhoy1NRAzU2pU+dLK2f1KhBAGaIUa4GER8V0L4KSVCtuGdomK5toF8+vW3hmr5ACXLLt4VmU0NXhRRRjmAkFU8GhGTfozYMaP7/5RmnF4LcL/aV6EcsCJi1/SJkvDv/dyBUsQ7vhASsK4eWyaFRQ+TVq/h0is5WRFpfv05RVuo5ByrWlA8k1kGM29hXTsj7lPcUKfKlFoJHhRo1HUPhXdpt1EhSBkTcoZVgoH7y63+Q3vETD/XfYKGyPRTygaG8bOIgin2fxUunJfU5gqvRUDl/uLTrcWpnxreSttXZNfeR1rApG+8jq01Ocuwk63YKBO8dhQvq4O8G2afiSiaVcnw7sse+4TkkRzLuBw5b5zizNyR+IhNd6sopDb6/FfY/dzZxnUDPdc/aIiiZr3zGKHO1KjPEORbJ6ujUSg33XTMsMlZJyOKq7UnA9Jg0p0VdTSdGMCgD+6RWJ3dHDLwNYpG3d5ODVelkdv5uAaHTN95DCUo5xsdlKNsZ/OkKwXKl/8mhOCIa9E/OW3vcVlh3x5i/a8oXAOkzflnngmwNciJNuDKIExs+/yNYWQ6VQW/YRDbrvkP5hqWJJso/6UERtqQmC8QpY8MDy+N8r6vrqNUFR9oGJztsVNMRgpBjNgAdbtSQHh+11ZzpxeSq6wcMvFVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199018)(82960400001)(66556008)(66946007)(66476007)(66446008)(76116006)(4326008)(64756008)(316002)(8676002)(38100700002)(8936002)(54906003)(6636002)(110136005)(122000001)(5660300002)(6486002)(36756003)(2616005)(38070700005)(91956017)(7416002)(41300700001)(26005)(6512007)(6506007)(186003)(53546011)(71200400001)(2906002)(83380400001)(478600001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?czV6MnZwYXV3MTFOVzJkTzVoeFYvREt5ekFrVFMxcVBac3dsQUY0WUo4eDZD?=
 =?utf-8?B?MHdVTEVUaERtemcvaWNRRzBVd0VjbzIxaG9ETHRuMXlHbEN3OERJeHRucHFG?=
 =?utf-8?B?RzR3N0pLTERZTjh4ZnRmVHA1ZmFPL01haHJVZEpFMkU5UWhwSUVRckwvMGx5?=
 =?utf-8?B?MW9aSldNdzhBSEJEM29oN29Ba01IRFUxMGU2RlVQMW5SUHI1cUEzMXdUOEg2?=
 =?utf-8?B?MUc5cG1LOGYxSDczUzgvamEyQjVUU0s4K0x4RzArN1I4NVRqdlJUSW0rSkx5?=
 =?utf-8?B?UGgyaGR5UDhXbGc4bFpndTdqb1owckpxbUpraWxVbnhod3hPeEp5dmR2a3lI?=
 =?utf-8?B?bDFhNCtJM3BpSGdUa1ZjK2VVUTVxdlVkM3NySUdFWG9lazdMY3M2Y3NYb0dY?=
 =?utf-8?B?MG1HdFMvMTQybENiS01VS3ZabjFPZDZJOExKQUV5aVFmNjI0ZmF6RWJnZjBr?=
 =?utf-8?B?VWo0ckViS2ZjZGQzaEZQaTBiN1dWak1naXZQTU9oYzlJa2d5NEovZ2dmaGh6?=
 =?utf-8?B?clJPMmNwOFRWQjRiZ2NpL0Q2a2laL2dHVElUOUlqZExwTG1IV1pveUdPYnM5?=
 =?utf-8?B?TTFoYllYaEVKWmRMQjBDQzhpNDE5Y0ZYZEJadDIxS3FSOUF6RGNKa0xkTnht?=
 =?utf-8?B?Z3c2eFR4LzdYRlRqSnQ1UnFVdEZGNHQ3aW9vZm0rNFFsVWwvMjNSTVF3cWMw?=
 =?utf-8?B?TWNhTTFHYmJnSlR2ZzlkcTlzTUk1bU5YT2hPaEtqb3IyUFIzejAvUkJ5UHFz?=
 =?utf-8?B?dmVpMzhTTkVTaVh4YllIejAwK3BHTVV6elpJMXNOUS8zYjhFMWxud0QyRnBU?=
 =?utf-8?B?QjR1MUdBYmxWQnFQcFEzZGZISjc4clVCbUloU0tZdjI2QVVUUDE2NUg5NkRz?=
 =?utf-8?B?aTRjaDNqNUc2UnAxVnFuTG13L3NhTkRXVTVjTGkwYTZVS2NOTkc2OWM5UDd6?=
 =?utf-8?B?ODhmM0JWYjUyNVN4akpTaDI0MXFSWXhadUtmTS9QeHM0bUxtUDVNekVJbFBT?=
 =?utf-8?B?ajdrRzBKci9wd1hWMHo3YkdZbC84d1cySmVHNmZuZWNlRWtYMm5IUHFSWmJI?=
 =?utf-8?B?eEFsN0FrazRHS01aSkZUUmdDL1dtd2NLejFSZ25UYXFPUE9LYXFnbWlUN1J4?=
 =?utf-8?B?WTNDMytJYzkxOHBTUDJSRmlpNFlzL0lzbmQvbHhvcGQ2aGhWZ3ZRL28xY0py?=
 =?utf-8?B?eWk4c0pEcFpqQWQrbjc0SVgvRjV5ZHJ0cDV6cmpndkNRMVlJUWtHTk9HU1dT?=
 =?utf-8?B?ck9jWGNNQjJSRjJEMWE0NTZKbE9TVmoraXVwODZIeTdFMk84OEZRQTF1ZG1T?=
 =?utf-8?B?QlgzOEd3cDZoS1JaWkEvTlVHR1JFY2E1ZVpHVkJaYi8rdnkxTzBhK1BnZGJi?=
 =?utf-8?B?WU9rYS9iQ0pmdmhyWGJrdHJ1TUtpdmRWRERqb05MQmloL1hacEFFcEpSMFJZ?=
 =?utf-8?B?bjRycXpjT0JoelBhR3BSUEo2NGVXbGRPK1BzVDI5RDdEanJJRkZ0MXFLdG1U?=
 =?utf-8?B?SnJ3SHdoOUZ6ZnV0dXN4MTNJaStubE8zSmhyMXBBRnl4VnFGM01WbUVTTTRS?=
 =?utf-8?B?YlRYelA1WXdLVUkvbjRHeTV3bmxIcWU5TEtFb0N0aHVHRjlFTEtRaXlnQmhO?=
 =?utf-8?B?YkMzRmtUdHZFWUJnd05wc01LbWFIeGs2ZTFrcVJnd0NEdDJTcEhRVDV1Nlo0?=
 =?utf-8?B?amFBeTFMcENCRnlUczV2QkNYWHk3cFB4MCttaEtGRy9JWFh3SVBha2c4akY4?=
 =?utf-8?B?YlR0czNYbFdoMGRXV05UUHRHK1hxQWR3ZGg5TC9BSy9iVzVncGNkejBySTRn?=
 =?utf-8?B?MVV6MDR3WjJPZTExcENuek9McytIR29sRlJDaFlQU3oyMG4zcG5ZVEEvK0Fh?=
 =?utf-8?B?cDA0T0JjMUJIcUUxTVZpeEFiRzg4dk5QVWd6dUJRb2lLRWRnbVVDUHNqTVVV?=
 =?utf-8?B?QUFXbFAvaHB4TVkzWFZ0ZEM5VlZ6QmExNXRtNjMwY0kvdXk2WmJJYWNqUXU5?=
 =?utf-8?B?LzRiMU5ZbU1lR29SQmQvazdPYTU5WTBrTDBlelhSbFRUQUpESzJlQS9uUTF1?=
 =?utf-8?B?YWc5MzkvZDdhbXRTWTcxWHlVYkZPQ1ZWL3hTaGhJVEJ0SjMvQUZTREEvTUZy?=
 =?utf-8?B?eTl2V3lsZFZJaUJmcXA1cVRkeUhXbklvcmluZVNrS2F3dVdIUW12aUEwcmI0?=
 =?utf-8?B?RFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4B6B9A09AD592E4CAF7DD8530665B463@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0384ef6a-b1ea-41b7-324d-08db0ecf93ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 21:08:10.1118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gdPbvgRlS3KdKJDizB1XwStC3VRHvvcmNEQMj+FQVHpXsXM5DziwxkJ0Sg36gHuYAQ0oB1xWVR+vJtr6AL5KKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6356
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAyLTE0IGF0IDA5OjIzIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMi8xNC8yMyAwNDo0NiwgUGV0ZXIgWmlqbHN0cmEgd3JvdGU6DQo+ID4gT24gVHVlLCBGZWIg
MTQsIDIwMjMgYXQgMTI6NTk6MTFBTSArMTMwMCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ID4gVXNl
IGEgc3RhdGUgbWFjaGluZSBwcm90ZWN0ZWQgYnkgbXV0ZXggdG8gbWFrZSBzdXJlIHRoZSBpbml0
aWFsaXphdGlvbg0KPiA+ID4gd2lsbCBvbmx5IGJlIGRvbmUgb25jZSwgYXMgdGR4X2VuYWJsZSgp
IGNhbiBiZSBjYWxsZWQgbXVsdGlwbGUgdGltZXMNCj4gPiA+IChpLmUuIEtWTSBtb2R1bGUgY2Fu
IGJlIHJlbG9hZGVkKSBhbmQgYmUgY2FsbGVkIGNvbmN1cnJlbnRseSBieSBvdGhlcg0KPiA+ID4g
a2VybmVsIGNvbXBvbmVudHMgaW4gdGhlIGZ1dHVyZS4NCj4gPiBJIHN0aWxsIG9iamVjdCB0byBk
b2luZyB0ZHhfZW5hYmxlKCkgYXQga3ZtIG1vZHVsZSBsb2FkLg0KPiA+IA0KPiA+IGt2bS5rbyBn
ZXRzIGxvYWRlZCB1bmNvbmRpdGlvbmFsbHkgb24gYm9vdCwgZXZlbiBpZiBJIHRoZW4gbmV2ZXIg
dXNlDQo+ID4ga3ZtLg0KPiA+IA0KPiA+IFRoaXMgc3R1ZmYgbmVlZHMgdG8gYmUgZG9uZSB3aGVu
IGFuIGFjdHVhbCBWTSBpcyBjcmVhdGVkLCBub3QgYmVmb3JlLg0KPiANCj4gVGhlIGFjdHVhbGx5
IGltcGxlbWVudGF0aW9uIG9mIHRoaXMgaXMgaGlkZGVuIG92ZXIgaW4gdGhlIEtWTSBzaWRlIG9m
DQo+IHRoaXMuICBCdXQsIHRkeF9lbmFibGUoKSBhbmQgYWxsIG9mIHRoaXMgamF6eiBzaG91bGQg
bm90IGJlIGNhbGxlZCBvbg0KPiBrdm0ua28gbG9hZC4gIEl0J2xsIGhhcHBlbiB3aGVuIHRoZSBL
Vk0gdHJpZXMgdG8gc3RhcnQgdGhlIGZpcnN0IFREWCBWTS4NCj4gDQo+IEkgdGhpbmsgd2hhdCBL
YWkgd2FzIHRoaW5raW5nIG9mIHdhcyAqdGhpcyogc2VxdWVuY2U6DQo+IA0KPiAgMS4gaW5zbW9k
IGt2bS5rbw0KPiAgMi4gU3RhcnQgYSBURFggZ3Vlc3QsIHRkeF9lbmFibGUoKSBnZXRzIHJ1bg0K
PiAgMy4gcm1tb2Qga3ZtDQo+ICA0LiBpbnNtb2Qga3ZtLmtvIChhZ2FpbikNCj4gIDUuIFN0YXJ0
IGFub3RoZXIgVERYIGd1ZXN0LCBydW4gdGR4X2VuYWJsZSgpIChhZ2FpbikNCj4gDQo+IFRoZSBy
bW1vZC9pbnNtb2QgcGFpciBpcyB3aGF0IHRyaWdnZXJzIHRoZSBzZWNvbmQgY2FsbCBvZiB0ZHhf
ZW5hYmxlKCkuDQoNClllcy4gIFRoZSBwb2ludCBpcyB0ZHhfZW5hYmxlKCkgY2FuIGdldCBjYWxs
ZWQgbXVsdGkgdGltZXMuDQoNCldlIGNhbiBkaXNjdXNzIG1vcmUgd2hlbiB0byBlbmFibGUgVERY
IGF0IEtWTSBzaWRlLCBhbmQgSSBkb24ndCB3YW50IHRvIHNwZWFrDQpmb3IgS1ZNIG1haW50YWlu
ZXJzLCBidXQgdGhpcyBpcyBhY3R1YWxseSBub3QgdGhhdCByZWxldmFudCB0byB0aGlzIHNlcmll
cy4NCg0KSW4gdGhlIGNoYW5nZWxvZywgSSBqdXN0IHNhaWQ6wqANCg0KIi4uLmluaXRpYWxpemUg
VERYIHVudGlsIHRoZXJlIGlzIGEgcmVhbCBuZWVkIChlLmcgd2hlbiByZXF1ZXN0ZWQgYnkgS1ZN
KSIuIMKgDQoNCkkgZGlkbid0IHNheSBleGFjdGx5IHdoZW4gS1ZNIHdpbGwgY2FsbCB0aGlzLg0K
