Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8042D634CE5
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 02:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235164AbiKWBYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 20:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235335AbiKWBYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 20:24:10 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E19B769C6;
        Tue, 22 Nov 2022 17:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669166650; x=1700702650;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZPOlA/s9jR/84JCLFbwOHQPdJUE46G7EzJ5H+hToERo=;
  b=luundiDw45dKwFYT7oE+CRONRiThl45yj9qDNFN0fjhMQ4xZZUTwBlZR
   oVxFVSWtx6FeNt5Zq7TyAdxnsXl/w0hLjHk8Aph+ADHauJR/q2V9aWn5g
   oE6dsli0W0iohaY/Ra7x1dgQtue0AjhCUuSPYEgujR4sMhQ2BvkcX1mM3
   XPai5z/pWHXoxPJ5ISMn7gy98DrRFIlDUcU+U53EbwypxJw10gGEfummG
   +XHxyK140lVao0+YR8LJeKIu9O/O7YRbMy8fmZh/RKcnw+AvKjG/yqFtR
   dZE0I6vukwKTNaRWQNol5L990ab7zhnQOhl6rLzm4l7IM0gP1rn2PWQAT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="293663054"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="293663054"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 17:24:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="710403460"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="710403460"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 22 Nov 2022 17:24:09 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 17:24:09 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 17:24:09 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 17:24:09 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 17:24:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBDXoou+0mM6Hyh8uDIjkQUsMz95hU9TB9FYcrYv0PGeeFBvw7q5MwYDpnjEyReT+qzfeQ+fs5hnY738CGNzs9IdLgvWNuiTt0tGItWFEeNyAZ5oQMV2jjeBUuaqbOi5VY75ixD9H/+NJ3hJX5GeBJO3ManWnTmitDRxnrq4rRMFjUnF/rVs5GeqMtZgUweTseEQFhXvn0tQCLeFveLPxaJAwHzwGGoE2wxMeHxkE5XPSMJSknkkzzw8vc/cm2jNRsMDCDquwyyJ4njK18iah0zwGbumm3BTYJVQYrqRcImCltzeyQT+NXqR05rfU9WQqSoPVRxeoh6I5yttAi+cdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZPOlA/s9jR/84JCLFbwOHQPdJUE46G7EzJ5H+hToERo=;
 b=GnRmvpZzxzx1jFzpqnCVxOA6ZJeAWCnkkRdsKRrAV5dfXefyoKVjjbPTbzNEDVID/yFhiHvfap7ljPzxix9PBiMOjmisMQLDom3AMmbSPx0Rb05xhN2EFriKV2oFvcxPHQ03Ccd1Pm81WidqHdBw2Nyxi0MPA8veb6mSmusAYWRtfarB7HcK8VgIJXLQcTJOfU5IUgoMPsx062WTXf0veNKVrpAoNEEKwRjlLz1x9+mrU1OFM6Iy2qCSk/VLGNrL/2VEupfZKf/IAJAjlgTJVhHmd2WgDMHHzkwyCLE3Yc8GBCu3sXhYpAGtAelV3Lt1B/S6qP7/Klh/FlUlPjmGfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB6957.namprd11.prod.outlook.com (2603:10b6:303:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 01:24:05 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 01:24:04 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Thread-Topic: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Thread-Index: AQHY/T2+AlEdwutNGkW7IAmyyjQDW65LTikAgAAEm4CAAGdLgA==
Date:   Wed, 23 Nov 2022 01:24:04 +0000
Message-ID: <7cc696d9ac0fafb54381feba2ad939342c60fdb4.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
         <bea49f7f-8411-662f-9fa8-97c98f61ce8b@intel.com>
         <Y30fjcRlXiWFhnym@hirez.programming.kicks-ass.net>
In-Reply-To: <Y30fjcRlXiWFhnym@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB6957:EE_
x-ms-office365-filtering-correlation-id: f01ef3dd-af80-45b1-f398-08daccf16904
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ISIFhSHijf2r1fxiuGY/+8TrF+zHUFmndMI063HwQS/oclYNSWhLhN583XCAl6HtJso49VvULLl7sQ+BoqJeBO0kXq8EYaBoUsRu0vRgZcj/EDl5blf0ZbXysFppO5QfIm2fdLObdIb1hFH3ybYW7trUtvby/DdHm8W/RpBKePyf2iJtu82Pw3aIP9PV/HoVHuS2Jf5u4LHF5GtzDWunnCl0TZ7UrK59I8Nn2iP0OQuwUM6IJBAl5m7nQTeEyPlq0NX1JWXLaUVNELDNFkBbVG979JNGT1wjAsfweyml8CpvLEigHGKo05pByaf0JEX3TahM5QiGS1SruYScr3FyHV+Fnz3le9Ckht0fVeaQtU8c1gOyiamMtupT8DNgoarXVbcKzHKs4czD8OljBW2Iuov8mG4mXAw4YT9Aw2NEgIEge4HTIr5lCBU6zI6iDANwqRNDbgyZUgOnexlsh9B6rNM2/dpcTbEfkeXC+4KNUfySkIojyyhxhZX+yjGfpuHOb+WeudduMk8U+aQXeY+VgWKVQ8yGayJuYYzIy0tOVaDIBOyPjPQH4aB3XTxULeeH+tMU0rTn8eOk7akQ+mlGUkXgnj43ernjTfHBEP5X6OHRUue3GelTXxByzZV/vC6+u3MD0bxXt2yp890Z3mib1+JApVEVuzUtnnvbBb8o1R/LuihYg0v3qUYySCc6VtLaQNRpcafMbpTZhSY1iBgQ3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(136003)(346002)(366004)(39860400002)(451199015)(122000001)(38100700002)(66446008)(83380400001)(76116006)(2906002)(66476007)(38070700005)(64756008)(8676002)(316002)(66946007)(41300700001)(82960400001)(66556008)(4326008)(26005)(91956017)(5660300002)(6512007)(4744005)(8936002)(7416002)(6506007)(186003)(2616005)(6636002)(110136005)(71200400001)(54906003)(6486002)(478600001)(4001150100001)(86362001)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YWh4ekI5cXZLMGg2dGJ4MFEzenNFSFNsYTc1c05nc21BQkszVXdXQ0gycU5X?=
 =?utf-8?B?bzY4MXpsbXJTRHQxeUFLOTgydi9zRnIrS21OdWVYZVp4SXI0L2NOVXpCWFBN?=
 =?utf-8?B?RGphSTlOek5rZW94M0s0cVlSdkxnT2huVGxWOFREdWswUmY5bVl3d1VDSXdK?=
 =?utf-8?B?MHFPdFpRd0NDd3pJK2JDM091ZnQ4SzVIYVVnelVyYlYzWDB6dHRSMTNsTG9s?=
 =?utf-8?B?MXpuYjhoRlhDSS9QMFNOTW1tYTRCeWpueDVnOHp1aUlEaS9xT0JqbkxaYTBK?=
 =?utf-8?B?RXRkc2k3WndyMXdzVG0vb2RJU0VIN2NYR2ZhSlFZL0U5K1pzaXJHc09BSjRF?=
 =?utf-8?B?M3lVSkx6T2FkemQzY3VRWVRPRk82STl4a3dBZ0d6di9jcWJpUjRLUXYzMnhl?=
 =?utf-8?B?THpMdWhvTG9EcXBaQUw2V2N3UFJGa3h0dmVFWVdHTjZOQkNWTmVvd00xN0Ux?=
 =?utf-8?B?ejdmUFplbnhEMkxCYUgrUEo0eTA1cEJXTzBzbFhNUVZac1lrQUdzRXVtQlFP?=
 =?utf-8?B?L3UvUWNaUEpFSXZqay9MUU9PbjdIKzhKN2RDVHUwd1VvYW5ud0N6dVdWQlRk?=
 =?utf-8?B?TTkvbVZCV3V1OThvZWkxWnl1ZHBIaXJXWEhYL3FEaXFnbTViZWhqa0F2Sk95?=
 =?utf-8?B?dmQ3ZzByampQbEozcjExMkdaa0o1QjQzdlI5eWQ5RitKUm85MXhNdXJySTlD?=
 =?utf-8?B?bWRhekxKMjArWnhUK2VGZnIreEp5a3o3RkdkMGhYWXpVQ3B3ckxrSkFyV2lR?=
 =?utf-8?B?S3ZqQm91SEVXUlFGV3pTYVJab1VLTmwzZERnbmIxa0pZQzdCT3BKNnhtTHBL?=
 =?utf-8?B?c2F0T3IxTVExUCtpSGZzUldCenI3anllMko3UFozNDNWb0twK1hBY09KTy9H?=
 =?utf-8?B?eXdrTDB1MFpHbEFvWVovUDhOSTNSa1I1VUgwb0kyV1NNV3VBc3NSVXJHOTcv?=
 =?utf-8?B?RTF4RWJaK3htWDRtaWVnMk5PVFlBUnNWSFdjclFJRmtMcXkyYXlhVU92WVBi?=
 =?utf-8?B?bE5SQWdtMGFGNnUyVC9UenlZc1RibjZ4U2gyWXFNbSszejZuVjczRkNaaFdC?=
 =?utf-8?B?NHJaakMvLzlYWnoyRmhKR0gzWnBucFFhR3gyMWx0MFVtUXV3SG0zaGk2Rklt?=
 =?utf-8?B?dUNtSWwxN09tVWFkYktPRVNEQzFzYzY1b3pWYitZZk52MTZDeHhiWXpzN2o3?=
 =?utf-8?B?RDFZZXRrazlpNmUzMlpwWERNLzUxZHRYOGFFam9mMFQ1VnVseHFRc1BNMkxH?=
 =?utf-8?B?QUxkK2xIblpGbjMvL2Q2SkUxMVdqMzdnakU3UVBkMG5PdDhkbytBd2ppRHZs?=
 =?utf-8?B?REtTM3RITFdmK0RxaUFiRnlWS0cxK1k1aW11V3ZaQm1ZSTB4WFhYSWJNVUU2?=
 =?utf-8?B?WDZ3RExZTGxucU4xeUVDOXIrdDhLYStIZkpMSUdUaWlPdDlZakQwZkExTDlW?=
 =?utf-8?B?WHgvaHFUc0N6TUhQMzBIL25OMEx4ZGw3cDc3eUw0RERtSExMMUl1NHJ3VkND?=
 =?utf-8?B?WFFaMUFadTJtT040cUxsZlE1VWplSHZlMGtFSElqV1kyd3pUOHJLZm5zeXBy?=
 =?utf-8?B?YzRPcE1yTWdyVUVNM3Bxd1I0RThYd0pmR2hKR1RIK2lXc1hCc1llQStCVFFr?=
 =?utf-8?B?Ui81Rk1xTmxVZ3RJcnlSMGVTcDZsc0JQeVFuSXlWZGpiMWVnVEd0bGRRTGoy?=
 =?utf-8?B?ZUpGMEkweEdJeVFtUTd0QkN1SXF5YzlSYzFSK09PK3pQSEd4OE05eEw0TzVX?=
 =?utf-8?B?QmN4ZHo4dTNQS0JQbGdmd3pCU2dCSklMTDJKdXZVMTFFK3lvUmJDTDZCMjNV?=
 =?utf-8?B?bnZ2cUJpUWhPbEp6SkNObDJ0WjROZUh5bWZHclRvWndTVTlmelhFUTFMS3U2?=
 =?utf-8?B?MEtNVVJ1YTBYSE9vanV6Y1FLWGpOWU05am5URGFyV2ZRQWZlcjJIL29aa2li?=
 =?utf-8?B?WnRnaE93RjFVMUM4T2pPdmFUZ0dROUJEdGlXdTVnMWc5R1U2a09ERkJsUkFQ?=
 =?utf-8?B?UXY2ZzNmV1FZVXh2cXZCaXN2MXdsc0gxcEFBV1NSUm1yTFlxeVFUSitEV3JL?=
 =?utf-8?B?dGkzdGVUK3k3L0xBaGpjZG9OZEtVem5IcTZUenVXSGNxWkUxSmNDOUxHaG1k?=
 =?utf-8?B?aXhCYjNITkd6eGxNVExTMS8zRWNuV1JSMmNXUWJRZVp3QktaZVdXbURvOUhK?=
 =?utf-8?B?d2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <65CBB21EFD5E6947AF01293E40885E83@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f01ef3dd-af80-45b1-f398-08daccf16904
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 01:24:04.7150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7XhDNJyt/PwJHECvcvwU7u84yj45kpaA5lO9LEr2ibEpeoKUGPSGeAeMXMSIFZpcilEIfQny2ZlPJso5rkI4gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6957
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTIyIGF0IDIwOjE0ICswMTAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVHVlLCBOb3YgMjIsIDIwMjIgYXQgMTA6NTc6NTJBTSAtMDgwMCwgRGF2ZSBIYW5zZW4g
d3JvdGU6DQo+IA0KPiA+IFRvIG1lLCB0aGlzIHN0YXJ0cyB0byB2ZWVyIHdheSB0b28gZmFyIGlu
dG8gaW50ZXJuYWwgaW1wbGVtZW50YXRpb24gZGV0YWlscy4NCj4gPiANCj4gPiAJSXNzdWUgdGhl
IFRESC5TWVMuTFAuU0hVVERPV04gU0VBTUNBTEwgb24gYWxsIEJJT1MtZW5hYmxlZCBDUFVzDQo+
ID4gCXRvIHNodXQgZG93biB0aGUgVERYIG1vZHVsZS4NCj4gDQo+IFdlIHJlYWxseSBuZWVkIHRv
IGxldCBnbyBvZiB0aGUgd2hvbGUgJ2FsbCBCSU9TLWVuYWJsZWQgQ1BVcycgdGhpbmcuDQoNCkFz
IHJlcGxpZWQgaW4gYW5vdGhlciBlbWFpbCBJJ2xsIGZvbGxvdyB1cCB3aXRoIFREWCBtb2R1bGUg
Z3V5cyB0byBzZWUgd2hldGhlcg0Kd2UgY2FuIHJlbW92ZS9lYXNlIHN1Y2ggbGltaXRhdGlvbi4N
Cg0KVGhhbmtzIQ0K
