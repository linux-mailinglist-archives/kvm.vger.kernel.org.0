Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAD7672889
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 20:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjARTiz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 14:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjARTix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 14:38:53 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE235411B;
        Wed, 18 Jan 2023 11:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674070733; x=1705606733;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kNfLt70TgSAfpzBKto6CKlQ3deQIKBJkX0ylGA0YePs=;
  b=F5odWALU3RZ2RwbNHXjWhSUiAYU36kiCEvIsL1HAg5Smchq5ghpEGEg5
   yR0CeAVUzA2MY2ZsnSmd80JfC3LVytw/JBNi0bwEfY8vXCJX7FnUwiuxR
   5xGsl255EjQVH1RKsKQRw5h613k3oezJ1MxX7CnNy7CdG5hUCN7Rh0Dyd
   guCJkzGudIXoLEi4vZ+RpSBHpQUPFfxFr1wG2fxdNLgXJsY0RMxJS2FDP
   IlphwuiaU7ESTHtBsvga/Z9YVF/NdWat01vg581KZbqrNyt9YUb6anz+f
   vBQGXXRtGjaP8sWqf94F6SxMvLwurLKeTd4TL+c3Q2c9ho7OQljALI70k
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="305458712"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="305458712"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 11:38:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="728348851"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="728348851"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 18 Jan 2023 11:38:52 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 11:38:52 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 11:38:51 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 11:38:51 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 11:38:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8Qpa2WQEmIkjCxP3G4zLPdlc9FF2EfM8BKgl8eevEo/zm+NlOZBybQ1JGZiZV8MUAus9Ga7mPmDXV6sS8dxswffmYWBbA86wj73oIbm7Po2Y1+i/5eLKZVH3qlKSicoEyDAQMl69dDWBl1gTrL0W4DeUav2OssoV2f73RPOYpNHE29L2YJ5CqJEhdRGT2S5dtYFQ0Tlq60C2AqH6cK7Esjg4uOFuBgEzqZD6fKEhRPu8GBPor5HX9QwDuOWnFUwyfPd/Yna+ShpahUqk6Tqg/2TGL9KN+GW7YPnKkUU98AKb1IMv7RdqbWwe3tOvfUxskpnmYVaofO78bkuH6J0QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kNfLt70TgSAfpzBKto6CKlQ3deQIKBJkX0ylGA0YePs=;
 b=GxdscZyb74tFvSFuv/ODwKoyL6obVDLc0UnOW+9ZvPAqHdJv/uLViNrYRUtQOP3yis2YRYHKPGRf58J0KGylP7Q/MNYLtIWpux+XCXLj4bkkQ5N/7Y0/UPveZUlPd1JWXo7OIs1pn6i7BBFVq4IMK++ZXig2o1WfrN8wy+WmcP/pibevNeAE5yJgihkaVhIixDaOk1yirXq9vcMTgCXFJ1CkfXZ7kULdUljfj/RsWwclM25sLyc7SgXnhMzfDkIC+Yt+SW2MYrKI1okuBi3uCloI6Q2ehlCxSFtxVbYDVciNive3Y12Sxw6MwU2wEO8CLRpHtuKOm+X//J066wrd7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN0PR11MB5962.namprd11.prod.outlook.com (2603:10b6:208:371::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 19:38:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%8]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 19:38:45 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 07/16] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v8 07/16] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHZC5gLiOnJQQKFB0CM7X30zcZDS66kQ0wAgAAvCACAAF9sAA==
Date:   Wed, 18 Jan 2023 19:38:45 +0000
Message-ID: <482089ba1ed8d492f5128f327c2d44ac9fa67972.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <8aab33a7db7a408beb403950e21f693b0b0f1f2b.1670566861.git.kai.huang@intel.com>
         <7cdc03500a6affccac189164636427b348af2811.camel@intel.com>
         <312d9d5d-0a40-1336-7bb5-728243dd16a9@redhat.com>
In-Reply-To: <312d9d5d-0a40-1336-7bb5-728243dd16a9@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN0PR11MB5962:EE_
x-ms-office365-filtering-correlation-id: c563c58e-b5c0-4a29-0133-08daf98b9cd8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: au0lDsGevbUjSTNmxAxDA/x0HtyjcYn9BlkVULv8CGTGODgpiMnDSXZUeyzieH8mMLr9or16t7KYrQER7ovt+3krEwV17PwJpUHi5ETTF7M3pHJQEaW85A8UFrJOy+hFPkFpHb8r7Np7+RN7p1GwDi0Z6f4tmyTBYp6Ee8sV6Hh8TtCNCBsTS6HL48nwzrLTMHTFv0IwXJ0WEn7TBuP7aAm7AeSVsohEJOJudrlFo747TtHVulfocj5VD9Ch15vLPQTVTWXwcvWy8HBqQRtNsjIwRmi1ypxsd/48ntbQR+BP78Jc6AeMcHadmZCekgK8i45NIf96VCEtysB3Vq4191YoxZDnv5QY+Ro4wLmkU+RYs4KhOjE/2zHsoU0ZZE5rqW3jniVGAuYOy5iZH28NBLj/7gjgB1m8BLtsmUK8VAgVpCodK3HrZIA18DOkOfkmEZy+LN2gDx2LkeInRumoAzfivNyG0QRisfPkKr5WOGFwX+cLOQmOf47icy0ozHvgx1PZNga+xm8k18ThXMtxERzOojm3girIcrM+y0ZkCi7k4QGTjn5ILRIlTLscqWqPzW2PIkR0FRqXBt8NgBIp77VpQD/EuJATxbQFc3GkjG8rt9uYB+VBYFShSpyJtDgrevx3pHdPg1Q/tBhPlYjvJ+SUo9+TZ/1Py4k07xQ1XHUz3ss8rjqfn0PMYsfx1GI8rDEAehn7YBA2oqSG2NR2Rg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(136003)(39860400002)(376002)(451199015)(38070700005)(66946007)(76116006)(2906002)(66556008)(4744005)(91956017)(7416002)(8936002)(5660300002)(66476007)(82960400001)(122000001)(38100700002)(71200400001)(54906003)(110136005)(53546011)(316002)(6506007)(6486002)(86362001)(36756003)(478600001)(41300700001)(8676002)(4326008)(66446008)(64756008)(186003)(6512007)(2616005)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M1pvRTE0cGdMWTV5NmNaakJQN3JURFV6Y3pSSXlWMzZTN0x1V3NNajhTSjkw?=
 =?utf-8?B?TEg5RWNyTWdGb0w2MFNZUnhJM3dpZ2NOYTlBME5qc3ZPVlIxWlVZeW9KZ1lY?=
 =?utf-8?B?THA2eGRxVWNxcURkdGZ5ZG9kdm5aRkQ4MVl4VGh2RUp2RjdJTGpCWWk2VVlP?=
 =?utf-8?B?bXh5OW94OTY3N0V5R0t6cGp4L1JQc1hkRloxRGNJR25zUytzc2hEMEx4RDBC?=
 =?utf-8?B?Z3c0YWdvVzF2V2ozQktFbXBSVWdSeTJKaUpTZ2ROOCtuWWVzUzNNN0tHSGJQ?=
 =?utf-8?B?SjRzWGFUUUFrMUZWMkZMUFlFUWJkYlMyQnR0Zy8rSzYwRHd5TDFjUTJQMXhy?=
 =?utf-8?B?WTFNV1JMMjZOd2NtbFR2UXpJMVRHVUJyVmt0WW80d1VmMVZ5b25SYzVDVjBz?=
 =?utf-8?B?MDJHWUg1RGxZT2tvRzU4UG9ZZzAxaHpOZ3pTT1AxWEp6RFJzaUlvOFEyU3l1?=
 =?utf-8?B?OVZVNktTSkp4REZPY3orZ2J5QThZK3NnZnRlZlYraTArTHZZWUZLWkVKR012?=
 =?utf-8?B?NGZhc3lOWVh3RjFwS1JHb3pSUVF4NGc1TVNINDE4RnhHQURicGsxTVBGVVJs?=
 =?utf-8?B?cUFVN0FRZzVrTmRJQXM1K01Edjl4ZDBHS1ZFQnhaR1JDQnBZc1VXK1B5Q2xI?=
 =?utf-8?B?UjZzOWxTUXJaUXBkbzF4MHpLMW5jNlNubCt1NDFycUZZOExuT1BhNUdtMGpW?=
 =?utf-8?B?cXRIcWlGSEZ3N0hNN3VrTXhteW8vQ2xUMW9HSWZNWjFwa2N2T1ZhejAxVzhw?=
 =?utf-8?B?SEY2VUF0eFo0cnJNNDkvbU5nbldFYUtLVkIvSU1hWkZwYVNRM05Tc0sxNnVQ?=
 =?utf-8?B?Q1U0RTZjSDFJNDIrN3duZmhHb3E5SHF2ZlFodHFBWmFBUGNuUjk0eHFhWHdz?=
 =?utf-8?B?b1QweFFWSXMwVjEvUm10NGFpUnVSOHpVdWptNDVISnJPUEk0NjM2eHQ1bmFU?=
 =?utf-8?B?ZStIbUNmTWZYcGFUUlpGNElsRUJpNXdQWUhYZ0tWajBhbENiTGh5Ritaa0tC?=
 =?utf-8?B?b2h6N2hMODdsK2FSOFdBMG52Q0k0b1VHU0N3YjdCOUYzN0k3TDJDYkFFL29N?=
 =?utf-8?B?TU5mNTErdDBtOUxGT29NTDJIK0FkYTZJWjVaUmo4U2NtTzNFU1NqRXRWcWlj?=
 =?utf-8?B?QWNTTjBpS3R4cGpxTzFwbWJHaitCRGE5RFB6VjkzekxOSUlGSDdha3huRlFh?=
 =?utf-8?B?RGtyTk84bjZkbFNvUUM5R1dEYjJ0RWkwb1doNnN3U0lQUXBJN2dpL2xPcTJQ?=
 =?utf-8?B?NzhEU3FxTnNKcmgrdE5vYUFZSkp1QjhmNHJ4d2wzV1FGY2JsQlAvN1k2d01G?=
 =?utf-8?B?WldKMVVYZFVMWm02VXhQaEZpY0hnZ0NKUHNnZ1ZUcWJLcitkbVk3TTljdThq?=
 =?utf-8?B?WU5TLzY4ZEsxdkRCNU1KRTBxNEJRNGxNYjN6LzhDZEFrYTJnamFuemd4Nnly?=
 =?utf-8?B?a3ZMQW5tLzlINjJ5bTNmRUNnWDJFZ2JERXMzSVduRHhjTzZvdFZPaENlTlhM?=
 =?utf-8?B?aXB4MmlxN1RNd3dIdFpDWDBPM2dzZ01ZZ3AwRHFTY3ZaQ1h2RUZmbFZrSU55?=
 =?utf-8?B?SHRFd2l4WW5rRHZNUHNpUGdoNmdTWGdHRWlMMWpVUUZQWFV3Y3JkaFIxd0ZK?=
 =?utf-8?B?cGhSQnplOGNmZGJSZjBiK3ZmRXZnOG9UYjRXMllDQTJWVmJ3M2szazljZGl1?=
 =?utf-8?B?UFBMcDRWalBZd21lQ1VZQUpNWHg0dnI5d3FsU2Z4bUVjZk5vMEl0a3JVVzlE?=
 =?utf-8?B?TWZhR1g4enpucGlHRHg0WTU0OUZNQ3FyRDh2SU5Vdnp5YTMxbjhWaHl4c0du?=
 =?utf-8?B?TUVyUm1JNGM4azhDaEhIZnJDb2dmcUZsWkFKS0dwTmlvVEprcDhUbUNTcTk4?=
 =?utf-8?B?SHBBNHF1RXYrdStrQlJHSE4vWGNHa0RsNmNvWHVWK1F5UndGNEZweGRIS2I3?=
 =?utf-8?B?cklKNVZlbmw2VytUL3Q5UGYvSFloUkpQS2E0L2JTcXEyS1hGMjBWNkt6T3NG?=
 =?utf-8?B?V2s0NGhzdit0aVZyZGJpb0UrODZDT3hyOHZoZTJoYUZGZFR6ZisyOUpYU0M0?=
 =?utf-8?B?WUE3WTdMQVkycExmVlVkbmIvditxV0dRemxSZTBGWFdQOFNPa2tYTUpJdEpC?=
 =?utf-8?B?MXNBL2dSdXJoWEJuSXBFSGhtQlVCNnVLNVZJZjMzMHRxekV2R0pyRldSOWJ3?=
 =?utf-8?B?S0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <38710FCA0F38C9499B1467ED3C5E44FD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c563c58e-b5c0-4a29-0133-08daf98b9cd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 19:38:45.3050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7FnNV4MZlbj/gsUE9Y84P9+smzzxagATHJZ7/fAzeWJoUwPdu9anbVF/fshsGxDHH8wOkfq6NzVP/NM26ljh/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5962
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIzLTAxLTE4IGF0IDE0OjU3ICswMTAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90
ZToNCj4gT24gMTguMDEuMjMgMTI6MDgsIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4gK0RhdmUsIE9z
Y2FyIGFuZCBBbmRyZXcuDQo+ID4gDQo+ID4gSGkgTWVtb3J5IGhvdHBsdWcgbWFpbnRhaW5lcnMs
DQo+ID4gDQo+ID4gU29ycnkgdG8gQ0MsIGJ1dCBjb3VsZCB5b3UgaGVscCB0byByZXZpZXcgdGhp
cyBJbnRlbCBURFggKFRydXN0ZWQgRG9tYWluDQo+ID4gRXh0ZW5zaW9ucykgcGF0Y2gsIHNpbmNl
IGl0IGlzIHJlbGF0ZWQgdG8gbWVtb3J5IGhvdHBsdWcgKG5vdCBtb2RpZnlpbmcgYW55DQo+ID4g
Y29tbW9uIG1lbW9yeSBob3RwbHVnIGRpcmVjdGx5LCB0aG91Z2gpPyAgRGF2ZSBzdWdnZXN0ZWQg
aXQncyBiZXR0ZXIgdG8gZ2V0DQo+ID4gbWVtb3J5IGhvdHBsdWcgZ3V5cyB0byBoZWxwIHRvIHJl
dmlldyBzb29uZXIgdGhhbiBsYXRlci4NCj4gPiANCj4gPiBUaGlzIHdob2xlIHNlcmllcyBhbHJl
YWR5IGhhcyBsaW51eC1tbUBrdmFjay5vcmcgaW4gdGhlIENDIGxpc3QuICBUaGFua3MgZm9yDQo+
ID4geW91ciB0aW1lLg0KPiANCj4gSGksDQo+IA0KPiBJIHJlbWVtYmVyIGRpc2N1c3NpbmcgdGhh
dCBwYXJ0IChub3RpZmllcikgYWxyZWFkeSBhbmQgaXQgbG9va2VkIGdvb2QgdG8gDQo+IG1lLiBO
byBvYmplY3Rpb24gZnJvbSBteSBzaWRlLg0KPiANCg0KWWVzLiAgVGhhbmtzIQ0K
