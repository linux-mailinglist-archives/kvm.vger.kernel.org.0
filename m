Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB3158FB78
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 13:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbiHKLiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 07:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234404AbiHKLiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 07:38:13 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8A5326C4;
        Thu, 11 Aug 2022 04:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660217892; x=1691753892;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QWHg/eFUBK0Y8ChsuKKSOcqQrfBMjKn0L5xn46sC194=;
  b=hU2CGH3yb8TGT2RXBD0xhR8MaCcLnoUHr8bF+cpF6wDzSdNNYA656/Fl
   3KI52N4nCgYq3823ENHr7wOrofgc5QLgLNPW3gmujK5QleEny76F9+3Q5
   PjIOsR7d3p8L6HvwUzJBFdlAjxKCCHN/9KyeJeXf2Nay0Qrb6RhYJ5oCO
   yLfjSGRl2OQb/XG2OnID6JeFuz9lVqR34rEbhILPj4GubiI6vXKZRAhbW
   7G6DtT8dyQOc8RlbErXViyMZ6+THo4f8RePNgBnpyqLmVFp5eRpuffy8c
   b+XdSC9sWschWXWx6kkLqRveWsxFFptzIdh0h34zHU4DimYFI6lw8e4+6
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="271100133"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="271100133"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 04:38:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="781572989"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 11 Aug 2022 04:38:11 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 04:38:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 04:38:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 11 Aug 2022 04:38:10 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 11 Aug 2022 04:38:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QfVBOa9b/ohPHMUb8kAO2NCQO6NRjWzH5Zb+1EFHeD6FLhXiOVM9k+ixM2ExVctOH2z1wUlJ9ypvuuhiaKoGUm+JkkxOc0kxtj+89r1J8P0gSBjNZPWemDEGGOnr4l6fx0DbBm1JPxZML23JCjkjAiqhyte3pDjOYQMOZdDdwa76L1r7I24Ed6K3HDARY6P6vdo12CcfwujnYMvzbP6+cDyUEp+n6wg4DZLAGRRZJmTt89AC3vvlyrnxlJBDPI0G2KQ2TiomaIlLmJsepnmeQO4LGgWehEyXDQbVB9NnjWDZLGkTT8b4R3A8Hmg2m6YFh//PyrSsTmMrU2lqDbXJWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QWHg/eFUBK0Y8ChsuKKSOcqQrfBMjKn0L5xn46sC194=;
 b=ACrBZqMsxDci96l8VMn6V7IArw9mNwtiNEgLECNS2MRv3ntlVZLXexpL3ooCn/azdxOsARz000lUjAVMRwTWFUujxM91sIGNtn7UdZPfdX83fj0iwqtiw9lws7HqUnMoV9QfvMsJSpEFo/OcEfBSiB80RGNimm0YHw8k1jjUi4b0vp9k5f3qRG5OmXC/g36+4Y1yRi3IHy5CIhp9RulZ418XY5haUZO9T8uY22/1gENV7WFTrhLjbTcTL+eBjZLl4TwPV5y/dPs8XN81Sa8HTGqKOC3cFpqv4TkGyxa1eiWGKX1oMvvBMz/Pm2QkxYwLRT5FTtj11BM1RVl4VooM1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB5075.namprd11.prod.outlook.com (2603:10b6:303:9e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 11 Aug
 2022 11:38:06 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::1d3c:4dc0:6155:2aee]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::1d3c:4dc0:6155:2aee%4]) with mapi id 15.20.5525.010; Thu, 11 Aug 2022
 11:38:06 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v8 004/103] KVM: VMX: Move out vmx_x86_ops to 'main.c' to
 wrap VMX and TDX
Thread-Topic: [PATCH v8 004/103] KVM: VMX: Move out vmx_x86_ops to 'main.c' to
 wrap VMX and TDX
Thread-Index: AQHYqql60qemzfpZ7UGJn9NLnW9zA62pmFGA
Date:   Thu, 11 Aug 2022 11:38:06 +0000
Message-ID: <3a725ec4ed4e4f97b8c425532f76f37451d01fac.camel@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
         <005b92abc8b8ada2896af662d4459323ee6b7e36.1659854790.git.isaku.yamahata@intel.com>
In-Reply-To: <005b92abc8b8ada2896af662d4459323ee6b7e36.1659854790.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.3 (3.44.3-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d0b3a3a-0876-4a9e-786c-08da7b8df57b
x-ms-traffictypediagnostic: CO1PR11MB5075:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ziR16/TZQ2TnrJNV+qyuvbjMU8MsDf5EwE5rvhNWdodbbAO4fPTzfvC7Kzj5MFlZ/KrzvkDsLCw3QWfjnNEodRdfDDBjfUDZf/VU1JE999HUKu0W3ZWyDBfbln71urd/SsTDqwnRLQItQJMu5oAHfFAupQMZMUnRsNak2+lTAgwasunpDOfViUIMU95wTAms8XRpnp16d4RBZC50GOlgl6allpUGJL9ZDzOkwtSXYMy/83PZ2X5jpceZwNDgAZ1cyPE8Ws/rqWBqPwAq3W5NkYEpZB89KYzUzI5uVGw7fgngInvLtY2hSGbD7uwGwEO5aaOKCJwj+FaLL1UjVq+0qll58FotQbzb9gF6pRkypodS+5EpflIm1pdS1f1l1Qkb+C+aJG/FQcZ+SnLw/Un+c9hnPpcbe7YRhY9ID0K0ZltwaUUOYg2TbdrL//SyTglGH6WAFkxxM5/fSrhr9NJXMOtMksa8VqJWalnstkTXVuGmx2vp9hb0I4zhatMOc5EdioFzXQNkM4Ed2BtTUXn9vTcuDriruywdjV9XCUYr4L+oqpDf1oqy7cxpnGH74nbnu8unRXpDtdKd+izZ83Cojf0pwEv9fnH3pgQZWBYAIiwlVl1Kl6q07tXKF96GH3X/3bAJL2gz+PjpFxwm5dH6o6eyrDpKf7hv/FDEqWx4Oo8LFkIRXb8A4nGwDD+IhCGH7B5Me8UudAdM1hmK1HM+m2Ubudghnq/Kb45EDwfi9XvyDOu+FsO+WMdLVFqDZaH7jQkL5ma7fiTfd378RqDrTugrBq0TVq7UI9a0BYJCLLJ385qCoVvxr8p9NNkNZW+i
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(366004)(346002)(136003)(396003)(8676002)(2906002)(4326008)(8936002)(83380400001)(6506007)(6512007)(82960400001)(91956017)(66476007)(66556008)(5660300002)(66946007)(64756008)(76116006)(66446008)(36756003)(41300700001)(478600001)(6636002)(6486002)(186003)(38070700005)(2616005)(316002)(54906003)(38100700002)(71200400001)(26005)(110136005)(86362001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0ZsN1p2Q3R0OHpuYTZGZ0gzRmFMOWN3OUFxeEZtRXJadDVpMDAyclVSRytZ?=
 =?utf-8?B?QjVRYzlTd3FlOXRPYWlva0p2THB6dkpWWVVPTzFDNmcyMm1UQzVRWkhnQ215?=
 =?utf-8?B?ZncyRUZ6by9GcTdtRGxKemtOOHV5Y2lhcEp2YkZQVXVVMkw4TTh5TlorOFBQ?=
 =?utf-8?B?OXFvUmZnSDNqMDN2SVU4ckxFWDI5TDF6M3pXVlNSTXVkQ3RlUnVkeVJzOGNp?=
 =?utf-8?B?akt1dWROT1ZBT0ptN2h3ZW1hYmhxS1pjM0ZqZjBpWHRYaDgyTWJpaDJORmVu?=
 =?utf-8?B?YXhzeExad0FDLzRSeitiN282d3l3bXRlNFFKR2JUTmhKZW9DeUFTNlVoa0Er?=
 =?utf-8?B?MnVTVlQvdFVnNXBMbFh3TnBlczJYckY4SFNUTVM3Z0pMZ2FxcVhWdUlCLzlj?=
 =?utf-8?B?bWhwbG1CMFBQVktBYWc0SitHZS9RUlhVcWdKRVk0VERaU1E1NVVnMlBTUkJL?=
 =?utf-8?B?a0wvbGZpWGNrTGdMOUlKTTFPSTBaUEVtb1dJYmo4SlovRUNFQnJGeXJuckZj?=
 =?utf-8?B?OWxDMjNHN0RxazFlMmx2UTMrQVpuWUZQZ0hBZGlRakxhZk14RTI5RkwxWVdW?=
 =?utf-8?B?cVNCbVk3RjVwUkdHTTcyeFp3VlFuTXJGa3BnYnE2Q3hVcDZEeHdyUGh3S2Vh?=
 =?utf-8?B?SCs4OHRNMDc1a2FuUDJRWWtMbG9OcGdBeGJENzBLZkt3WmxZWmhFMG5XUXJP?=
 =?utf-8?B?bFRwMExQM0lTaE5RU3lpT2RucTJXN09FRFFtSFI3L1BOeU15a012S1FkK3g4?=
 =?utf-8?B?bnZIZjYrOTZjODFURHptYVQzdmdhZkFHS1RQbWFmTTlmN2p5U2JSdnlYV2dJ?=
 =?utf-8?B?eHpMVEhhOHBDcVYyek5ESklrWktBcGhGWFlack92TzZkSElIMndPMHF2MXpm?=
 =?utf-8?B?eDlOOURPeU4vYWkzYTVHMFE4djlPT09NalNmQS9yMkhmMzc0eDc3N1FlNXpz?=
 =?utf-8?B?UzYzZ2pqVGNhMStORHdDQUREcXNxN3Y4cXZjcmc1UllFNGtTS1UvTTFRK0cx?=
 =?utf-8?B?VzFtVXBXMUpWNzdqWUpJbDJudlVoSmQwMitoZnNwaDd1V3pQL0VEalVjalU5?=
 =?utf-8?B?bTFQTVVXYUwraGRQd0RUTzJDQys5VkoyQ1pFZXd0c2JTd2ltbjNXR1VHb1ZN?=
 =?utf-8?B?cjQyUlc3MEZ2cStreGc4ck5ZQTJzZy9MTWx1eXlpanpjSGVXelA0YmNFVmNZ?=
 =?utf-8?B?MGhyWUhtbFRHZzd2MnZQWmkrdXpXZ0NSZW1QWWgvM2ZxcmZsZURuOWZBQkcw?=
 =?utf-8?B?YWU4dTZFUjJ3R3NUbkVXeEtCSmovcEhMaVRnZ2ZwRHFrbE9Od3RsODJGb013?=
 =?utf-8?B?aGpQNTBra2V4V0xnUjdoOVZIeG1QYmYwOHpIOEZlTmJSbXhuY2lyUklMNHo2?=
 =?utf-8?B?MkNDZCtkUmtBSHo4Q1ExT2xtRzNBUFliWjZ3M3NKR3IyVm42b1BBUlVkNkhX?=
 =?utf-8?B?S0VlSGRTZHVUcWVSRWpRcnFBS0hvajRzdWF6TmhUME1JL3pVSmY1OTNzVUEz?=
 =?utf-8?B?RzE3R080SThLVDBmdkJxeElxa2ovWUpnVGJDZjhqbkY5a05WaTNhdHV3aDZG?=
 =?utf-8?B?T1V2eS8vS0k2MmlXNjJrSWRzSUZSU3hWZU56d204SEdUOGcxMUxaMC92Wmg0?=
 =?utf-8?B?TExCcmdaU1NpZ2hBUzJhUWFDcWNObzZCa1FtY002aVVScWlBcGtiTmlFcUl4?=
 =?utf-8?B?b1pGWXk5aTBUK0tqenFaZ2NMKzhmSlFoWENtK3BuSVJnUTFxSjFOY0R4bGJu?=
 =?utf-8?B?WDlwRG9VSlBjSE80M3E1bi9TQjR1T084MStOM21kYkZKMUVEaStkTkZObUhq?=
 =?utf-8?B?QkkrTmJKVSsyRDh3Q1pFQXl6QjVMQUVMYmNJbzlFdWVWZ1ZoYnIzaTd0eFZs?=
 =?utf-8?B?UTNiRmEvbzFIZ1phWlBtRmxJU1VpeWJjT2s3R2x6amxwMHR1Qld3TEhzRlh2?=
 =?utf-8?B?RG9Gb3NVcXVIbzVDdHRGYVR3cERXWnRRRlRMNW5uMkN5dUcycElQT0pJajB6?=
 =?utf-8?B?Yzd6WmlVT0wyVGFmMksxZkNwMitoL2R1U3FZVmFmdUZQOTliM1hUN1BQWGlX?=
 =?utf-8?B?K25KNW8raHJRaUxDQ2l1cVBsK2lKLzRvdkpWVXRnSFFxeHlvcWRta0VPVUVM?=
 =?utf-8?B?TWlhYVlaamJ1RjU1WjhhdHFoRnIyUFBtWTBxYmI0MTVEb0FISEV2NUhLZ1ha?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <260727569A684A43B6127EEB91E31967@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d0b3a3a-0876-4a9e-786c-08da7b8df57b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2022 11:38:06.5305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VKP6AIwcxz74KviZPvWvtCkWflmRm5+CE5wjjuYlhZAJMkMXa0VXusx0TkYBpTXBKK29q6OXBZh6a0Kraqyk0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5075
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU3VuLCAyMDIyLTA4LTA3IGF0IDE1OjAwIC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW4uai5jaHJpc3RvcGhl
cnNvbkBpbnRlbC5jb20+DQo+IA0KPiBLVk0gYWNjZXNzZXMgVmlydHVhbCBNYWNoaW5lIENvbnRy
b2wgU3RydWN0dXJlIChWTUNTKSB3aXRoIFZNWCBpbnN0cnVjdGlvbnMNCj4gdG8gb3BlcmF0ZSBv
biBWTS4gIFREWCBkZWZpbmVzIGl0cyBkYXRhIHN0cnVjdHVyZSBhbmQgVERYIFNFQU1DQUxMIEFQ
SXMgZm9yDQoNCgkJCQkgaXRzIG93biBkYXRhIHN0cnVjdHVyZXMNCg0KPiBWTU0gdG8gb3BlcmF0
ZSBvbiBUcnVzdCBEb21haW4gKFREKSBpbnN0ZWFkLg0KDQpBbmQgc29ycnkgSSBkb24ndCBzZWUg
aG93IGJlbG93IHBhcmFncmFwaHMgZnJvbSBoZXJlIC4uLg0KDQo+IA0KPiBUcnVzdCBEb21haW4g
VmlydHVhbCBQcm9jZXNzb3IgU3RhdGUgKFREVlBTKSBpcyB0aGUgcm9vdCBjb250cm9sIHN0cnVj
dHVyZQ0KPiBvZiBhIFREIFZDUFUuICBJdCBoZWxwcyB0aGUgVERYIG1vZHVsZSBjb250cm9sIHRo
ZSBvcGVyYXRpb24gb2YgdGhlIFZDUFUsDQo+IGFuZCBob2xkcyB0aGUgVkNQVSBzdGF0ZSB3aGls
ZSB0aGUgVkNQVSBpcyBub3QgcnVubmluZy4gVERWUFMgaXMgb3BhcXVlIHRvDQo+IHNvZnR3YXJl
IGFuZCBETUEgYWNjZXNzLCBhY2Nlc3NpYmxlIG9ubHkgYnkgdXNpbmcgdGhlIFREWCBtb2R1bGUg
aW50ZXJmYWNlDQo+IGZ1bmN0aW9ucyAoc3VjaCBhcyBUREguVlAuUkQsIFRESC5WUC5XUiAsLi4p
LiAgVERWUFMgaW5jbHVkZXMgVEQgVk1DUywgYW5kDQo+IFREIFZNQ1MgYXV4aWxpYXJ5IHN0cnVj
dHVyZXMsIHN1Y2ggYXMgdmlydHVhbCBBUElDIHBhZ2UsIHZpcnR1YWxpemF0aW9uDQo+IGV4Y2Vw
dGlvbiBpbmZvcm1hdGlvbiwgZXRjLiAgVERWUFMgaXMgY29tcG9zZWQgb2YgVHJ1c3QgRG9tYWlu
IFZpcnR1YWwNCj4gUHJvY2Vzc29yIFJvb3QgKFREVlBSKSB3aGljaCBpcyB0aGUgcm9vdCBwYWdl
IG9mIFREVlBTIGFuZCBUcnVzdCBEb21haW4NCj4gVmlydHVhbCBQcm9jZXNzb3IgZVh0ZW5zaW9u
IChURFZQWCkgcGFnZXMgd2hpY2ggZXh0ZW5kIFREVlBSIHRvIGhlbHANCj4gcHJvdmlkZSBlbm91
Z2ggcGh5c2ljYWwgc3BhY2UgZm9yIHRoZSBsb2dpY2FsIFREVlBTIHN0cnVjdHVyZS4NCj4gDQo+
IEFsc28sIHdlIGhhdmUgYSBuZXcgc3RydWN0dXJlLCBUcnVzdCBEb21haW4gQ29udHJvbCBTdHJ1
Y3R1cmUgKFREQ1MpIGlzIHRoZQ0KPiBtYWluIGNvbnRyb2wgc3RydWN0dXJlIG9mIGEgZ3Vlc3Qg
VEQsIGFuZCBlbmNyeXB0ZWQgKHVzaW5nIHRoZSBndWVzdCBURCdzDQo+IGVwaGVtZXJhbCBwcml2
YXRlIGtleSkuICBBdCBhIGhpZ2ggbGV2ZWwsIFREQ1MgaG9sZHMgaW5mb3JtYXRpb24gZm9yDQo+
IGNvbnRyb2xsaW5nIFREIG9wZXJhdGlvbiBhcyBhIHdob2xlLCBleGVjdXRpb24sIEVQVFAsIE1T
UiBiaXRtYXBzLCBldGMuIEtWTQ0KPiBuZWVkcyB0byBzZXQgaXQgdXAuICBOb3RlIHRoYXQgTVNS
IGJpdG1hcHMgYXJlIGhlbGQgYXMgcGFydCBvZiBURENTICh1bmxpa2UNCj4gVk1YKSBiZWNhdXNl
IHRoZXkgYXJlIG1lYW50IHRvIGhhdmUgdGhlIHNhbWUgdmFsdWUgZm9yIGFsbCBWQ1BVcyBvZiB0
aGUNCj4gc2FtZSBURC4gIFREQ1MgaXMgYSBtdWx0aS1wYWdlIGxvZ2ljYWwgc3RydWN0dXJlIGNv
bXBvc2VkIG9mIG11bHRpcGxlIFRydXN0DQo+IERvbWFpbiBDb250cm9sIEV4dGVuc2lvbiAoVERD
WCkgcGh5c2ljYWwgcGFnZXMuICBUcnVzdCBEb21haW4gUm9vdCAoVERSKSBpcw0KPiB0aGUgcm9v
dCBjb250cm9sIHN0cnVjdHVyZSBvZiBhIGd1ZXN0IFREIGFuZCBpcyBlbmNyeXB0ZWQgdXNpbmcg
dGhlIFREWA0KPiBnbG9iYWwgcHJpdmF0ZSBrZXkuIEl0IGhvbGRzIGEgbWluaW1hbCBzZXQgb2Yg
c3RhdGUgdmFyaWFibGVzIHRoYXQgZW5hYmxlDQo+IGd1ZXN0IFREIGNvbnRyb2wgZXZlbiBkdXJp
bmcgdGltZXMgd2hlbiB0aGUgVEQncyBwcml2YXRlIGtleSBpcyBub3Qga25vd24sDQo+IG9yIHdo
ZW4gdGhlIFREJ3Mga2V5IG1hbmFnZW1lbnQgc3RhdGUgZG9lcyBub3QgcGVybWl0IGFjY2VzcyB0
byBtZW1vcnkNCj4gZW5jcnlwdGVkIHVzaW5nIHRoZSBURCdzIHByaXZhdGUga2V5Lg0KPiANCj4g
VGhlIGZvbGxvd2luZyBzaG93cyB0aGUgcmVsYXRpb25zaGlwIGJldHdlZW4gdGhvc2Ugc3RydWN0
dXJlcy4NCj4gDQo+ICAgICAgICAgVERSLS0+IFREQ1MgICAgICAgICAgICAgICAgICAgICBwZXIt
VEQNCj4gICAgICAgICAgfCAgICAgICBcLS0+IFREQ1gNCj4gICAgICAgICAgXA0KPiAgICAgICAg
ICAgXC0tPiBURFZQUyAgICAgICAgICAgICAgICAgICAgcGVyLVREIFZDUFUNCj4gICAgICAgICAg
ICAgICAgICBcLS0+IFREVlBSIGFuZCBURFZQWA0KPiANCg0KLi4uIHRvIGhlcmUgYXJlIGRpcmVj
dGx5IHJlbGF0ZWQgdG8gdGhpcyBwYXRjaC4gIFRoZXkgYmVsb25nIHRvIHRoZSBwYXRjaChlcykN
CndoaWNoIGFjdHVhbGx5IGltcGxlbWVudHMgdGhlbS4NCg0KRm9yIGluc3RhbmNlLCBJIGRvbid0
IHRoaW5rIGRldGFpbHMgbGlrZSAiTVNSIGJpdG1hcHMgYXJlIGhlbGQgYXMgcGFydCBvZiBURENT
DQoodW5saWtlIFZNWCkgYmVjYXVzZSB0aGV5IGFyZSBtZWFudCB0byBoYXZlIHRoZSBzYW1lIHZh
bHVlIGZvciBhbGwgVkNQVXMgb2YgdGhlDQpzYW1lIFREIiBhcmUgcmVsYXRlZCB0byB0aGlzIHBh
dGNoLg0KDQpXaGF0IHdlIG5lZWQgdG8ganVzdGlmeSB0aGUgY2hhbmdlIGhlcmUgaXMgc2ltcGxl
OsKgDQoNClREWCBkb2Vzbid0IGFsbG93IFZNTSB0byBvcGVyYXRlIFZNQ1MgZGlyZWN0bHkuICBJ
bnN0ZWFkLCBURFggaGFzIGl0cyBvd24gZGF0YQ0Kc3RydWN0dXJlcywgYW5kIHVzZXMgU0VBTUNB
TExzIHRvIG9wZXJhdGUgdGhvc2UgZGF0YSBzdHJ1Y3R1cmVzLiAgVGhpcyBtZWFucyB3ZQ0KbXVz
dCBoYXZlIGEgVERYIHZlcnNpb24gb2Yga3ZtX3g4Nl9vcHMuDQoNCkkgdGhpbmsgeW91ciBmaXJz
dCBwYXJhZ3JhcGgga2luZGEgYWxyZWFkeSBkb2VzIHRoaXMuDQoNClRoZW4geW91IGNhbiBiYWxh
YmFsYSBiZWxvdyAuLi4NCg0KDQo+IFRoZSBleGlzdGluZyBnbG9iYWwgc3RydWN0IGt2bV94ODZf
b3BzIGFscmVhZHkgZGVmaW5lcyBhbiBpbnRlcmZhY2Ugd2hpY2gNCj4gZml0cyB3aXRoIFREWC4g
IEJ1dCBrdm1feDg2X29wcyBpcyBzeXN0ZW0td2lkZSwgbm90IHBlci1WTSBzdHJ1Y3R1cmUuICBU
bw0KPiBhbGxvdyBWTVggdG8gY29leGlzdCB3aXRoIFREcywgdGhlIGt2bV94ODZfb3BzIGNhbGxi
YWNrcyB3aWxsIGhhdmUgd3JhcHBlcnMNCj4gImlmICh0ZHgpIHRkeF9vcCgpIGVsc2Ugdm14X29w
KCkiIHRvIHN3aXRjaCBWTVggb3IgVERYIGF0IHJ1biB0aW1lLg0KPiANCj4gVG8gc3BsaXQgdGhl
IHJ1bnRpbWUgc3dpdGNoLCB0aGUgVk1YIGltcGxlbWVudGF0aW9uLCBhbmQgdGhlIFREWA0KPiBp
bXBsZW1lbnRhdGlvbiwgYWRkIG1haW4uYywgYW5kIG1vdmUgb3V0IHRoZSB2bXhfeDg2X29wcyBo
b29rcyBpbg0KPiBwcmVwYXJhdGlvbiBmb3IgYWRkaW5nIFREWCwgd2hpY2ggY2FuIGNvZXhpc3Qg
d2l0aCBWTVgsIGkuZS4gS1ZNIGNhbiBydW4NCj4gYm90aCBWTXMgYW5kIFREcy4gIFVzZSAndnQn
IGZvciB0aGUgbmFtaW5nIHNjaGVtZSBhcyBhIG5vZCB0byBWVC14IGFuZCBhcyBhDQo+IGNvbmNh
dGVuYXRpb24gb2YgVm14VGR4Lg0KPiANCj4gVGhlIGN1cnJlbnQgY29kZSBsb29rcyBhcyBmb2xs
b3dzLg0KPiBJbiB2bXguYw0KPiAgIHN0YXRpYyB2bXhfb3AoKSB7IC4uLiB9DQo+ICAgc3RhdGlj
IHN0cnVjdCBrdm1feDg2X29wcyB2bXhfeDg2X29wcyA9IHsNCj4gICAgICAgICAub3AgPSB2bXhf
b3AsDQo+ICAgaW5pdGlhbGl6YXRpb24gY29kZQ0KPiANCj4gVGhlIGV2ZW50dWFsbHkgY29udmVy
dGVkIGNvZGUgd2lsbCBsb29rIGxpa2UNCj4gSW4gdm14LmMsIGtlZXAgdGhlIFZNWCBvcGVyYXRp
b25zLg0KPiAgIHZteF9vcCgpIHsgLi4uIH0NCj4gICBWTVggaW5pdGlhbGl6YXRpb24NCj4gSW4g
dGR4LmMsIGRlZmluZSB0aGUgVERYIG9wZXJhdGlvbnMuDQo+ICAgdGR4X29wKCkgeyAuLi4gfQ0K
PiAgIFREWCBpbml0aWFsaXphdGlvbg0KPiBJbiB4ODZfb3BzLmgsIGRlY2xhcmUgdGhlIFZNWCBh
bmQgVERYIG9wZXJhdGlvbnMuDQo+ICAgdm14X29wKCk7DQo+ICAgdGR4X29wKCk7DQo+IEluIG1h
aW4uYywgZGVmaW5lIGNvbW1vbiB3cmFwcGVycyBmb3IgVk1YIGFuZCBWTVguDQo+ICAgc3RhdGlj
IHZ0X29wcygpIHsgaWYgKHRkeCkgdGR4X29wcygpIGVsc2Ugdm14X29wcygpIH0NCj4gICBzdGF0
aWMgc3RydWN0IGt2bV94ODZfb3BzIHZ0X3g4Nl9vcHMgPSB7DQo+ICAgICAgICAgLm9wID0gdnRf
b3AsDQo+ICAgaW5pdGlhbGl6YXRpb24gdG8gY2FsbCBWTVggYW5kIFREWCBpbml0aWFsaXphdGlv
bg0KPiANCj4gT3Bwb3J0dW5pc3RpY2FsbHksIGZpeCB0aGUgbmFtZSBpbmNvbnNpc3RlbmN5IGZy
b20gdm14X2NyZWF0ZV92Y3B1KCkgYW5kDQo+IHZteF9mcmVlX3ZjcHUoKSB0byB2bXhfdmNwdV9j
cmVhdGUoKSBhbmQgdnhtX3ZjcHVfZnJlZSgpLg0KPiANCj4gQ28tZGV2ZWxvcGVkLWJ5OiBYaWFv
eWFvIExpIDx4aWFveWFvLmxpQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogWGlhb3lhbyBM
aSA8eGlhb3lhby5saUBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3Bo
ZXJzb24gPHNlYW4uai5jaHJpc3RvcGhlcnNvbkBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6
IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+IFJldmlld2VkLWJ5
OiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2
L2t2bS9NYWtlZmlsZSAgICAgIHwgICAyICstDQo+ICBhcmNoL3g4Ni9rdm0vdm14L21haW4uYyAg
ICB8IDE1NSArKysrKysrKysrKysrKysrDQo+ICBhcmNoL3g4Ni9rdm0vdm14L3ZteC5jICAgICB8
IDM2MyArKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICBhcmNoL3g4Ni9r
dm0vdm14L3g4Nl9vcHMuaCB8IDEyNSArKysrKysrKysrKysrDQo+ICA0IGZpbGVzIGNoYW5nZWQs
IDM4NiBpbnNlcnRpb25zKCspLCAyNTkgZGVsZXRpb25zKC0pDQo+ICBjcmVhdGUgbW9kZSAxMDA2
NDQgYXJjaC94ODYva3ZtL3ZteC9tYWluLmMNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBhcmNoL3g4
Ni9rdm0vdm14L3g4Nl9vcHMuaA0KDQo=
