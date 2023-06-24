Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0769D73C6B7
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 06:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjFXEPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Jun 2023 00:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjFXEPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Jun 2023 00:15:43 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF70C2705;
        Fri, 23 Jun 2023 21:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687580141; x=1719116141;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eXNT2qynzTUrrJDasNnZlMZpL5P3ZRNp//snV+yvCBY=;
  b=eTtPoclz5iZaSuzkUZHkgXRfpzB9NekLcxGatHl3caSaXaIQJjOI8qh9
   p+ISIRktTYFKPL0OtX+kAjQuxItk5JmEWYE6aGc5umJ6VH0oufaV9vfPp
   tnINNSYQonqTUzmZUx6L7ZZP6FRivJ4XZtluGnS/zdJtcpe08e/m35aQ9
   j47bCe/FKfVyMmLTyqv+mz03rat7Qct09lgtZQjPy1K5B5QU+LI0LI55l
   lPABie/wrgS5YQakTbhaC/uLDMJBoWDmNR1oAo2wlNd/daZAXXHHLRNhg
   x6SzFMDpnwCggBxCTZkzIKMDtGsv7mnkMiB/ecCdaE2m06/W5CfdlhBT3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10750"; a="340504636"
X-IronPort-AV: E=Sophos;i="6.01,154,1684825200"; 
   d="scan'208";a="340504636"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2023 21:15:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10750"; a="860085999"
X-IronPort-AV: E=Sophos;i="6.01,154,1684825200"; 
   d="scan'208";a="860085999"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 23 Jun 2023 21:15:41 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 23 Jun 2023 21:15:40 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 23 Jun 2023 21:15:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 23 Jun 2023 21:15:40 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 23 Jun 2023 21:15:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNyajLlnWvzULWEB4ykFWpYsX12aCdMJj2xqV08waquC7kKDBogi94hVPWWhMnIShGiA4NEruAwo/xi7WeMRhSSPbsKU3uOQU+MPnyatXqQDK+CKSQWQw/xal4slkRUJPjoQ5bWKAKM9lqmRlYcn2NEogs4q6ZyFTmXpyq3UFX7nwJ9jOqELI8hAki810OkISHwhqsFjm/huCK60hQqDslS4UU4htUEHPJifDABJgb8/DlwMPWSXWzH4bMAFbKFN7tTHoF2MDrd6dkqc75cYW96t1lGbkQaVZkoe/xWLV1vHZd0nCxs3JGh07L8lsa6IuYLGEZjqdexntX2ft/lgeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eXNT2qynzTUrrJDasNnZlMZpL5P3ZRNp//snV+yvCBY=;
 b=Isz5RbO8EgYJRYgYbxJiRAeIyMr+1q3bFb4QxEs4XChOwmH9D03ue6kNvE9GeSmtBYgm016v1vMqA7tfDdjFfihYo3u/wYS0Mu9HL1AT6WT+LApRROgvKdhrKyj1tQuPbP+xcNNf/7/J0hdTToY0v0f5BPTob/YYs5g/ZKrUMnfJYlHnHPiKVB6VNqVQKqsqzRdfbLahuXMGOze/JL3MesClsaSjQBCBfiQG6OivxEkCIr4rzMge0hxmMbRhgxOHmso1DaDYAQhSliLCygCUKvu9yyRQzmlN8m1PT8KPw2KVZb1arS4YF3accroAcp/R/qQCZEnSR8p0FBsIlxhpVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM8PR11MB5672.namprd11.prod.outlook.com (2603:10b6:8:26::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Sat, 24 Jun
 2023 04:15:35 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Sat, 24 Jun 2023
 04:15:34 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
CC:     "dmatlack@google.com" <dmatlack@google.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "ackerleytng@google.com" <ackerleytng@google.com>,
        "Chen, Bo2" <chen.bo@intel.com>, "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Annapurve, Vishal" <vannapurve@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "michael.roth@amd.com" <michael.roth@amd.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>
Subject: Re: [RFC PATCH v2 3/6] KVM: x86/mmu: Pass round full 64-bit error
 code for the KVM page fault
Thread-Topic: [RFC PATCH v2 3/6] KVM: x86/mmu: Pass round full 64-bit error
 code for the KVM page fault
Thread-Index: AQHZpV+yhpnTip1UUUaNzYvoReaLo6+Xd7YAgAA5mYCAAPFOgIAAt6qA
Date:   Sat, 24 Jun 2023 04:15:34 +0000
Message-ID: <93404a98324f1a4e93a6b6e711b209bc57c831de.camel@intel.com>
References: <cover.1687474039.git.isaku.yamahata@intel.com>
         <b659f86ac7128965e05a7a660c38734667530fc0.1687474039.git.isaku.yamahata@intel.com>
         <37b868c53c9f35e8ec051573562a4598df38d72d.camel@intel.com>
         <20230623025429.GB3436214@ls.amr.corp.intel.com>
         <ZJXS7tU6iukBXSuv@google.com>
In-Reply-To: <ZJXS7tU6iukBXSuv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM8PR11MB5672:EE_
x-ms-office365-filtering-correlation-id: 576f1945-af7e-4b12-dbc2-08db7469a85e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xTQAiMDlJCQQy0exliQQ/vWAikipsZpq6cIXVpAFTrCiup/iLUx1bPzMvGkP9OPe94n/koop0zgRHHrO9G69yQCyqEcpfjXusfkhIqlIlctpo5qFeojeOt51967G15v3AIoY+2prKqVeIaEBNs07EcwBG+k++t2i1DExrt5+qcvOIigW3Eu7mrAkAR4r+Z/b3yaDkmdx08/yQZvdbZcUdCU3B2crOkjHizZh0GWrFVRfjYHEZhoZvOXLdsUtDlB5HAge0KCCKgbwT5jOs2gsbYVj4s0igqxUWG06X0W1z9szEsIK+yHa0tsaVTcUlx+3Q7/CwgVit796BFpVzcMzQg+GLAduZ/WIRFXC19OloiO2u8qD69OfJip4fKqcP0rOoacEiREHNFP5bkrs8h2b8/3pmsnXtfHUJzNUpuNHhHtGd1K3DHSY2fmoghs87MEtVFRA53PgjW7sog7dSK6lRTse8yuaC0gQ1p1HmRZQ6t+HRjhzKqGBH2vSdjPilG0WbNAjXKA664tP6Thj/j990GwA2yC1N3Q9q1y9QOjUgkwiOZsyredGj7GhN/bECBr83ImAqVHGsDJETfrwLfYvnfETixVoAEflB0ciu4L1h3gCGORXjLEcIN2XSQC+NnTe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199021)(38070700005)(82960400001)(38100700002)(122000001)(2616005)(86362001)(316002)(66476007)(66446008)(66556008)(64756008)(8936002)(41300700001)(66946007)(8676002)(91956017)(4326008)(76116006)(7416002)(83380400001)(53546011)(6486002)(54906003)(478600001)(71200400001)(110136005)(5660300002)(6506007)(6512007)(186003)(2906002)(36756003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RE1DVGVtTnRyaWVpanA4WjNkcjd2TnlCbG5CZms5YXBOZ0xyMFdsSm81UnFu?=
 =?utf-8?B?MmVoRHg5dU9hRnZrTkJlcldsRExhRm1pa2NSOHludHZzN0JQQVlQMkEzZEU5?=
 =?utf-8?B?SDVDWFBDYTZJRXgvdGFIRmYrTFIrS2NnRGEvWDJONkMyV2dOSTRWcmJCVXFp?=
 =?utf-8?B?QVBtNlhVdEJ1MTBDajY4TTFQWm9tTzhtUVlzSmtaOHlPd2I5QXRjK2ZJQjRK?=
 =?utf-8?B?T0JZOVJGbTlNQWVBRTRXYjJXU3Jad3FFZmpYMTBzSVlocHdOWEU2SjNsUWxB?=
 =?utf-8?B?WWxUbkNFWFNEN1F0WFZuNTFockFYcml4dWxMSDNOalZaelljTkZvK2Ryd1NJ?=
 =?utf-8?B?T1FvU2Z5TWRYZ3JiMmJmVUl6bWY5MGVCVkdMK25SM21uWXJsTURzMFd0dVBI?=
 =?utf-8?B?WnR6ME5IZ2habzlKdnZ5Y1d3MkRsTG9ISlFnY2lHSTFBMkxCMHZhKzdNWTI1?=
 =?utf-8?B?LytUNVI1ZjIzZERseUVFVDJ3LzdZVVZNQ0V0SmtQTTkvK2JjYjdrSVdGQUhZ?=
 =?utf-8?B?RlBSazhvQkpLR2g0akxhakxUdFJpbGRvQkJCV2pKTjNDcjVvVTNpZFExV25Q?=
 =?utf-8?B?UDdwZkY1bWl1S1FPMkFlUjBqbmZ3ZDRRZGFqTnNVZ2RJQWlaL3hab2xhMDJ0?=
 =?utf-8?B?bFZaS1pCTHJHeVJJQWhqM3o2bEZRcmw0VEdTRVl3WXI0QTFTUXZtdlhXS0JJ?=
 =?utf-8?B?V2F2OElXdnVHUUhrakY1V1lwLy9QY0hVMkcvdFNBdWhmeFNEZjNCTEpDS05j?=
 =?utf-8?B?WWpTbmZMQktubEZmRWt1RFFJSTMrOXo5REYzQUliNmFQdGdadU9lcEI5TlV2?=
 =?utf-8?B?UWtwSTVZM2J4UHJsb3ZVNVUyeTBmaWFZWUpDUlMrL2ViV2dPdXZwQTRNb0VK?=
 =?utf-8?B?VzhXSkhOMytwSXpGdi9GLzNjMUhmdXhjVkxqdi8vL2FUd2VIeFJ6akNtaWRo?=
 =?utf-8?B?M1dKNkJZTnUxcEFrbEtxM28wdVMyYlJ3dnNuU0I2Z1ZiVDMzNk5veUtHY3Na?=
 =?utf-8?B?Qk5PdjBPY0d6U3FEdTFkcVZrK3VoZFJNZDZmV2FJRU45dXVQOVhjd21ZMko1?=
 =?utf-8?B?bkVDZmIrdGEra0NaM2MraG9FcFU4aTBtK0RrMkNKc2VQVDZuV1g4dno3YzFr?=
 =?utf-8?B?OTN1bkFHTXFaVmVteE9VOVpKTG1HdWMzRDk2YjU5QVh3UGF2WDQ4L29mTTBJ?=
 =?utf-8?B?WkJqRXgwTGVhdUJpdkxnRWVRL2d4S1JRU205RXFGQSsxYS9GdGpnbXozQlVk?=
 =?utf-8?B?c1doNUFjcThITkUyU09USm5GOEVRdTVFNW9FcW9UR0JUMnlvNXJscHRkdVpv?=
 =?utf-8?B?Tzk0N2IzOXhWalZpVmhiMUIyRHkzbWxPMU9jKzJ0cTVFTUlLQzlKL1FtWURu?=
 =?utf-8?B?aG9ZNVRRd3JHczlSTk9iTFMveW9sU3Bqdm9nTWttcUgwL3VaNS8rQlpUdktX?=
 =?utf-8?B?TVlpNEZHN1NBRUpDZ2RTOGNiUlZmRld1Q0k4ZktxZDBRVk1LL1dDUFAvRVRO?=
 =?utf-8?B?aDB4ZWJyZmZaNHNSeWdXSVFaMTV0V01tM1dRZ2hDbmZzRUdYbk85Sm1qbnZx?=
 =?utf-8?B?S0RrQzlvTHo3eWpSM1R6b2EwekR0Tmt0WHZQUDVhSWF1SFNhV1pQOVZiUi81?=
 =?utf-8?B?QzRmWWFMUENya2NXM3o5bm5PczlicW50ZSttdEd4VFZSUjhpa0t1c1JvcDl5?=
 =?utf-8?B?cUxEV1V5U1BrMVJ6SjBMemExSXJOYzdWUU9vOHJpQk9jWkgzdmZ4NE9pVWZz?=
 =?utf-8?B?ODZjOGt4L0xqalZQQTViZ0FTQ1FuNnduUEJHUHVoZExYRTlRVkZFTXl4bmM1?=
 =?utf-8?B?a0Q0MWg3eGN4R0lBY2szZ0VidjZ0RFZrdDgrV3k5Y05GS0xWYzRhTzNVS3p6?=
 =?utf-8?B?cXNaVFNjQXkxcGxKSnpqVnZESE92bVNLWWRGa0pmaTZNeXY5d0ZxaFo4TnRW?=
 =?utf-8?B?c09QcU1VTFVaM1lkanJQOGdnM21hWEoyZy9XblBtQ2FGRjBmRmJGZCtRRktE?=
 =?utf-8?B?VVd5WWkwZGNRcGlEK09abWtVSVhTZmZ1YTVSTGo1M0l1WG1ZakRsTitkR0xv?=
 =?utf-8?B?cy9SVld6bTV2RVJnQis1RDY3RmpqQzdRT0dYamRNc21TeEpsS0JYcU1CRWVv?=
 =?utf-8?Q?fqkQ+cdDwdEnWQGs3UMjSpUiq?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <48B2294D5E171D42985B0013803FECE8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 576f1945-af7e-4b12-dbc2-08db7469a85e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2023 04:15:34.8222
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qcAimpkSE7k47t1vIlooZOCAs3QZc/vmjDtCVDFEkXQnxwD9zVSA7x3ewLUzSkcJ4JLOHW4qUUbkDtoRlWS5iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5672
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IEZyb206IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiBEYXRl
OiBGcmksIDIzIEp1biAyMDIzIDA5OjQ2OjM4IC0wNzAwDQo+IFN1YmplY3Q6IFtQQVRDSF0gS1ZN
OiB4ODYvbW11OiBHdWFyZCBhZ2FpbnN0IGNvbGxpc2lvbiB3aXRoIEtWTS1kZWZpbmVkDQo+ICBQ
RkVSUl9JTVBMSUNJVF9BQ0NFU1MNCj4gDQo+IEFkZCBhbiBhc3NlcnRpb24gaW4ga3ZtX21tdV9w
YWdlX2ZhdWx0KCkgdG8gZW5zdXJlIHRoZSBlcnJvciBjb2RlIHByb3ZpZGVkDQo+IGJ5IGhhcmR3
YXJlIGRvZXNuJ3QgY29uZmxpY3Qgd2l0aCBLVk0ncyBzb2Z0d2FyZS1kZWZpbmVkIElNUExJQ0lU
X0FDQ0VTUw0KPiBmbGFnLiAgSW4gdGhlIHVubGlrZWx5IHNjZW5hcmlvIHRoYXQgZnV0dXJlIGhh
cmR3YXJlIHN0YXJ0cyB1c2luZyBiaXQgNDgNCj4gZm9yIGEgaGFyZHdhcmUtZGVmaW5lZCBmbGFn
LCBwcmVzZXJ2aW5nIHRoZSBiaXQgY291bGQgcmVzdWx0IGluIEtWTQ0KPiBpbmNvcnJlY3RseSBp
bnRlcnByZXRpbmcgdGhlIHVua25vd24gZmxhZyBhcyBLVk0ncyBJTVBMSUNJVF9BQ0NFU1MgZmxh
Zy4NCj4gDQo+IFdBUk4gc28gdGhhdCBhbnkgc3VjaCBjb25mbGljdCBjYW4gYmUgc3VyZmFjZWQg
dG8gS1ZNIGRldmVsb3BlcnMgYW5kDQo+IHJlc29sdmVkLCBidXQgb3RoZXJ3aXNlIGlnbm9yZSB0
aGUgYml0IGFzIEtWTSBjYW4ndCBwb3NzaWJseSByZWx5IG9uIGENCj4gZmxhZyBpdCBrbm93cyBu
b3RoaW5nIGFib3V0Lg0KDQpJIHRoaW5rIHRoZSBmdW5kYW1lbnRhbCBwcm9ibGVtIGlzIHdlIG1p
eCBzeW50aGV0aWMgYml0KHMpIHdpdGggdGhlIGhhcmR3YXJlDQplcnJvciBjb2RlIHRvZ2V0aGVy
IGludG8gYSBzaW5nbGUgJ3U2NCcuICBHaXZlbiB0aGVyZSdzIG5vIGd1YXJhbnRlZSBmcm9tDQpo
YXJkd2FyZSB2ZW5kb3JzIChJbnRlbC9BTUQpIHRoYXQgc29tZSBiaXRzIHdpbGwgYmUgYWx3YXlz
IHJlc2VydmVkIGZvciBzb2Z0d2FyZQ0KdXNlLCB0aGVyZSdzIG5vIGd1YXJhbnRlZSB0aGUgc3lu
dGhldGljIGJpdChzKSB3b24ndCBjb25mbGljdCB3aXRoIHRob3NlDQpoYXJkd2FyZSBkZWZpbmVk
IGJpdHMuDQoNClBlcmhhcHMgYSBmdW5kYW1lbnRhbCBmaXggaXMgdG8gdXNlIGEgbmV3ICd1NjQn
IGFzIHBhcmFtZXRlciBmb3Igc29mdHdhcmUtDQpkZWZpbmVkIGVycm9yIGNvZGUgcGFzc2luZyB0
byBhbGwgcmVsZXZhbnQgY29kZSBwYXRocy4NCg0KQnV0IEkgdGhpbmsgeW91ciBmaXggKG9yIGRl
dGVjdGlvbikgYmVsb3cgc2hvdWxkIGJlIGdvb2QgZW5vdWdoIHBlcmhhcHMgZm9yIGENCmxvbmcg
dGltZSwgYW5kIGV2ZW4gaW4gdGhlIGZ1dHVyZSB3aGVuIHN1Y2ggY29uZmxpY3QgbWVyZ2VzLCB3
ZSBjYW4gbW92ZSB0aGUNCnN5bnRoZXRpYyBiaXQgdG8gYW5vdGhlciBiaXQuICBUaGUgb25seSBw
cm9ibGVtIGlzIHByb2JhYmx5IHdlIHdpbGwgbmVlZA0KcmVsZXZhbnQgcGF0Y2goZXMpIGJhY2st
cG9ydGVkIHRvIHN0YWJsZSBrZXJuZWxzLg0KDQo+IA0KPiBGaXhlczogNGY0YWE4MGUzYjg4ICgi
S1ZNOiBYODY6IEhhbmRsZSBpbXBsaWNpdCBzdXBlcnZpc29yIGFjY2VzcyB3aXRoIFNNQVAiKQ0K
PiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4N
Cj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0vbW11L21tdS5jIHwgMTEgKysrKysrKysrKysNCj4gIDEg
ZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94
ODYva3ZtL21tdS9tbXUuYyBiL2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCj4gaW5kZXggNjAzOTdh
MWJlZGEzLi4yMjhhNDgzZDM3NDYgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9tbXUvbW11
LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL21tdS9tbXUuYw0KPiBAQCAtNTc0Miw2ICs1NzQyLDE3
IEBAIGludCBub2lubGluZSBrdm1fbW11X3BhZ2VfZmF1bHQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1
LCBncGFfdCBjcjJfb3JfZ3BhLCB1NjQgZXJyDQo+ICAJaW50IHIsIGVtdWxhdGlvbl90eXBlID0g
RU1VTFRZUEVfUEY7DQo+ICAJYm9vbCBkaXJlY3QgPSB2Y3B1LT5hcmNoLm1tdS0+cm9vdF9yb2xl
LmRpcmVjdDsNCj4gIA0KPiArCS8qDQo+ICsJICogSU1QTElDSVRfQUNDRVNTIGlzIGEgS1ZNLWRl
ZmluZWQgZmxhZyB1c2VkIHRvIGNvcnJlY3RseSBwZXJmb3JtIFNNQVANCj4gKwkgKiBjaGVja3Mg
d2hlbiBlbXVsYXRpbmcgaW5zdHJ1Y3Rpb25zIHRoYXQgdHJpZ2dlcnMgaW1wbGljaXQgYWNjZXNz
Lg0KPiArCSAqIFdBUk4gaWYgaGFyZHdhcmUgZ2VuZXJhdGVzIGEgZmF1bHQgd2l0aCBhbiBlcnJv
ciBjb2RlIHRoYXQgY29sbGlkZXMNCj4gKwkgKiB3aXRoIHRoZSBLVk0tZGVmaW5lZCB2YWx1ZS4g
IENsZWFyIHRoZSBmbGFnIGFuZCBjb250aW51ZSBvbiwgaS5lLg0KPiArCSAqIGRvbid0IHRlcm1p
bmF0ZSB0aGUgVk0sIGFzIEtWTSBjYW4ndCBwb3NzaWJseSBiZSByZWx5aW5nIG9uIGEgZmxhZw0K
PiArCSAqIHRoYXQgS1ZNIGRvZXNuJ3Qga25vdyBhYm91dC4NCj4gKwkgKi8NCj4gKwlpZiAoV0FS
Tl9PTl9PTkNFKGVycm9yX2NvZGUgJiBQRkVSUl9JTVBMSUNJVF9BQ0NFU1MpKQ0KPiArCQllcnJv
cl9jb2RlICY9IH5QRkVSUl9JTVBMSUNJVF9BQ0NFU1M7DQo+ICsNCj4gIAlpZiAoV0FSTl9PTigh
VkFMSURfUEFHRSh2Y3B1LT5hcmNoLm1tdS0+cm9vdC5ocGEpKSkNCj4gIAkJcmV0dXJuIFJFVF9Q
Rl9SRVRSWTsNCj4gIA0KPiANCj4gYmFzZS1jb21taXQ6IDI5MzM3NWJmMmZkMzMzZTU1NjNkZDgw
Yjg5NDcyNWI5MGNkODRjNWQNCj4gLS0NCg0K
