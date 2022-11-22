Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDBFC633822
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 10:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbiKVJRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 04:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbiKVJRD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 04:17:03 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B226466;
        Tue, 22 Nov 2022 01:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669108622; x=1700644622;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cUtHtHXDze6NrPed/BCi9TmsiMdWOFKrEsHg3e4T9MI=;
  b=mQWAnfPPb02YwV1r+Gh7NfY4yt1TfGnfQzwlvjjTBlCYwshMe73g697g
   aOpkqzmhjy/oYnoPsgyQFx+tXAv7LRdpjOq8bUbPKucToRds4/UZiSEGS
   U7PqzjEErOM1o9ZsDRqsP6zyM+4HTCYYjYKFEVmG0obhVam8ITUTml7hm
   mA2IWm+XDvnAO3bTWGx+eM/TwsrevMsNKDRbU+Wr1DVCL0al3xDUFFNMv
   XyuAeUY2bnW3cSVJ1DLrS0e+f/+JOmpV5zqIDGQDwvTe6D0yhaRz7MEmY
   4+tGLFtfqVcUYfzdlEK7pmXkGErlU0vtHUA3RckWdIas/I6zWXHV5wk3s
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="294162967"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="294162967"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 01:17:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="674287393"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="674287393"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 22 Nov 2022 01:17:00 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 01:16:14 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 01:16:14 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 01:16:14 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 01:16:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfZR0f9cYJMV8SCA/7J2pv4ar3gj5pIxGL9u1Os7iTfGHsbWbVOP4zP13JHuKUKWVxtuRqj9HVhX3eHcDKvNWKxTBDAf2Y8q6KTjjp4U6eys/uRfZ0LpbY+6t9eiMzC7i7V0tdOP9jFcYS70qjqWh5K7KHfVUYaW89Y++ZUDxz5ywDP7ct88sj/8kWEQg1yqPVW9tVEEH8+BFCMoU82OfahOM61mV2PHWQQR1C2YBBEQmhK17+/W2gN9BAPUlGTbLyfIlu4rmGJ9l5hixdWkN6F5uyGv78wvRTy/3/Qeiwj4nUJLAEbadOzNnNvekAwISaJohXHOIDSIcGwGfNm79Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cUtHtHXDze6NrPed/BCi9TmsiMdWOFKrEsHg3e4T9MI=;
 b=X7uVk6tbGJUfwmNhBguPfnvRecaZQfz4HCbNamimCLwlCJlqVWKokilAzG0FXrYyo5g4+F8wtVsneabik5Uy6T/oRkb2iP4ZtG4ym2l+xskHZoUeysPT22tHYZ37gnzE3usky5iqVpH9fxOLQZHgPLHvFAJkdR+pgIjj8g/PrwWOTkvlIrAh7mBFQSaePwCNlwE+Z83CkQN5Y8fuZGvTfIPJCbehbsIXWfplcua5FsO5cLP8TIF9W1VJ5CpSdggJHuFCPeNZZdjxq1Zo98qTqSgIn7gu21E1gayDeBk/cPi4PF4OC2JRm76mve/XO53tbIoAIZ6VbIIngPgi2JdMBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5120.namprd11.prod.outlook.com (2603:10b6:a03:2d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 09:16:11 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 09:16:11 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Huang, Ying" <ying.huang@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
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
        "peterz@infradead.org" <peterz@infradead.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHY/T3KCI/2IUKL7kSgXbHXnV3Az65I3JTQgAA63oCAARkUfIAAex0A
Date:   Tue, 22 Nov 2022 09:16:11 +0000
Message-ID: <973ca04b3323d28a31dbc1cfeb52bd10bd9d9bf3.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
         <87cz9gvpej.fsf@yhuang6-desk2.ccr.corp.intel.com>
         <a6ecf5f1a1202f428961a5f8422d5fff61ce1d9a.camel@intel.com>
         <87sfibpxda.fsf@yhuang6-desk2.ccr.corp.intel.com>
In-Reply-To: <87sfibpxda.fsf@yhuang6-desk2.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5120:EE_
x-ms-office365-filtering-correlation-id: b74717ec-5050-45c4-aaf9-08dacc6a3296
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pMK2JQOA8bO6tvlbNt/uJ5/gfk6eSSKMEoxHCDrBmVDyiNXJzRZ0+wraKn3CWQ3IQE3lqLw9GbnComrF88113vsV9PZH0d3yrNuVWptOndB+UcRfaAq2Pa7ZekLPhKaKbCS0monT0HH6kiCcTCtyF0mFo+S6vPaROBkyK4b3uCCVbzsUK5tHC1iwwC/Xu2JCc2FBMHLHgmmRlumfMscj/QdQ+JKHFDtr2UbcYXl8Hk8zRQyGjsrtFgbuCSNNG7ICkwsbHgDUbwkQKCPIjAPqCqI8dw5oUSsopMBM5exR4mFlvKYhfvkjJdcX5sBX2KGYWUsYqAyidmQE4zD6WSMcU0LSncKqD8Y8CYHPQdgVzZf2WyeW+KmmtMgd9SmLqOz4mVHFCKuXAFzjDeQYFkzZ1KNmmY9YO8Nc7e2TWyy7v5Jb7fL07uebiVN/HQ1UP7Z4nFI9MhCA0AgG2URWzfKzttP2vyM2dbrDrhyw2ErZuMxwVCm+vSk2uOEi8Li934rVgmRI4jPZYe3klQTjEDxK65WrO+7E8WEV/IIH3jGoJesb/vsFMGB8kIbVg9w1GTn2rBQm6ipM5gJXtU49bcIFs3S+ft9Xuccc8cLsEGDrt9sGMKnp8kUpgtCo86KdMsONng8ClIWkE0zdjy9Xuf6jY418qVlAqw29LkmfI4sQPcB8BCxHj76QdVuOtITPE6WKCZvbXdScuZD7+HQwRUMzhw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(136003)(376002)(346002)(366004)(451199015)(6862004)(8936002)(38070700005)(2616005)(6512007)(186003)(26005)(82960400001)(7416002)(5660300002)(316002)(36756003)(6506007)(86362001)(6486002)(478600001)(6636002)(37006003)(54906003)(122000001)(66446008)(41300700001)(8676002)(76116006)(64756008)(66476007)(91956017)(66556008)(4326008)(71200400001)(38100700002)(66946007)(83380400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWFYSHJ0U09yd2d3VDFHT0I5SFNibVJqVVpDTE00NnUzSkwrakU1YmU5aC9S?=
 =?utf-8?B?Nm55QWJjQVhDS0VuOUhWRFVIdFc3VlAvQXMwNFYreGNQeGcyekdxb0FaV2tI?=
 =?utf-8?B?by9qVWxoT0VuSzlSRmVJYWlDL3J6WXNkSDJJNm02c3B3V016Y2Zjdk9vUVVB?=
 =?utf-8?B?V3RCQXhKWS9FQmZ0ZXJjd2psN3ZxRDBzV2EraVc0YlhZT2hidUdFUVBwbW4x?=
 =?utf-8?B?R2JCM2RKdTRrRkhncTUweXNjcFZmWE1rNWNWY3NHSDladXZyaEYvT0xmM1lW?=
 =?utf-8?B?aUpEMDlMRWFiSnFzaFEyV0VSR2IzbkVZQ2RnbmJXUUJTbHNXQ2VTTkRLb1dp?=
 =?utf-8?B?QThDWmxKQ3Z0OTdnRnh3SHNQUGdIMThpS0kzWXlwT2pKNUZzdDQwU05BYVhm?=
 =?utf-8?B?cDQxbnN2N2dkTmVhaGp0NnNES3FtaDE4NFZheHpMOTJkTXZ0cTBSOE1tSlh1?=
 =?utf-8?B?SmhjY1BSNEtMay9EdHMzb3owWThMMko5WXF0NTVTYzNXZitYM2NMUTU1NG5y?=
 =?utf-8?B?ODBYdUdtYUwxTEpQSmhaOHYvTDhCUDRmS01qWVdqWFNhbEw1LzNNTkFOeXo3?=
 =?utf-8?B?TmFnb21JbHBZM3piK2xkSXd4RWdqUEM2YzJIQlBHeURxbGo1d0NoN3FzRUdp?=
 =?utf-8?B?dzVJbjhIRy9rVGtNVzdFbkJWZHh2NW9hOWV2L3RMY0JaY085ckFQNFZZdGsw?=
 =?utf-8?B?VUpnaHE0Y2VZRFYycStReERrN2J4UWMxUUZyTVdmVWpCMUpmUnFWVDkvWnNh?=
 =?utf-8?B?VHFMWURXVVN6VnRCcXBlZ1FKaVVJZk5wZk9ZWkNCZlBxT1I1VzJQZWRNV2Rv?=
 =?utf-8?B?c3kxRitXL3dKYWtBQW8wUFhqcXB3aVV4bUhtT3VsTjZ5WWZzZWtaazhISktz?=
 =?utf-8?B?QkNoMGJQOGUzeVU2bzgrdzFGV05Ic3R6WW5jTEhyRXdMa1JvLy95dnNVbTdS?=
 =?utf-8?B?d2piLytaazFYdzV0dkFMVjBWS3hqbjFmRVcvTEFEbkxCRHJrZ3NReVpFMTIv?=
 =?utf-8?B?NnpGM0xPM09jbmdrbGNEZFJBSFN0SjQwaVpBd1JGMnNKNFJhWUNVbi9MUC9E?=
 =?utf-8?B?RHhWMmYvTllGeUJ0Wndyc1NPdTB1d000TEo5aVVFSGtGMkhLSzVGWTQ2NTJ6?=
 =?utf-8?B?b2F1T1YxU0pkVlpRa1RGcUNSeGNSY2hSWW9Ca3QxOFdZQTV3ODlLQmp0UERt?=
 =?utf-8?B?Zk1USThIeGNvSGxyYmNmSEQ5M2NESzlTZWdETnprY1E1THdGMXlqa2ZWQ3FM?=
 =?utf-8?B?UTNibzBKT0JtY0RJdE5lUlhhUGgyd0UyaVBCbUlXTGJ0RkJHeEZSMGdNSmZQ?=
 =?utf-8?B?a0JLZWJNdGtLY01LdkkwWU1JWUhNRHUwWkdxVnlybzhFNGM5NXAyTGw5TFo2?=
 =?utf-8?B?TzJDUXgwb0Y4VmRnOTI0M3NmSkg1Y21YdUNzMGkrSEN1RTdaOUhuR3FMWi9M?=
 =?utf-8?B?RHdhRGdXMWVIOWpGelFmN1FiTjNySG9KMHFRZHZKb1NUb2ZWZ2ZyUllEQnk2?=
 =?utf-8?B?N0V4SUlYRWhhcHZnN1hKWTQ0RzBqSTZIRGc0N2p4QUtxdG00UDgrNkFZL3pq?=
 =?utf-8?B?eDEwam5qMDZtZ0RRSysvQVY2UzVsdXJzZ0xMNDlXRU83WEU4L1pvR1dZOTAy?=
 =?utf-8?B?NFpwaXJndU5ZN3UyVW5HWXpUSE52aEZTcEFHNktBNGRTaW1UaUJoRmZYcnVV?=
 =?utf-8?B?d2xVdHZHWER6enRMK1owS3ZLSC9pQVFHVWZDbGJibUZ2OE1BNnlBbUhIeDcy?=
 =?utf-8?B?cjdnVUt5K05ZckROY1FGOWJreGVrRy93dmhROGorSWIxcjRVVmdNb0lSeGxS?=
 =?utf-8?B?RW9wU09SbjBzem9ka0RQa0Z2WGd1WWFxdGZ3NnVJQnIzY0VESmVhcHpSK0tl?=
 =?utf-8?B?WjBnaGk2d1piUkxvMkI3NDcybmttQzJnMi9YYzVWYjJTeERUNUV3OUNwTGZW?=
 =?utf-8?B?ZXBPaWlPYVRwSW9QNHhHaFdMTVRTK1htSmxhSXY0Y2xhUk9HNnNJZFhqekV6?=
 =?utf-8?B?Ukh6SEQ3S2E0T3RTM1RyVGVxWnV4TEhwdjEwNHlUSDkycFRqNmhwaDlsOWtl?=
 =?utf-8?B?SFlBMjJMdWM4NHRXcUZ0bU5Zdlh5M1Nja0ZmUGd6ZExZMVJ0c2Z3M2pmZ0JH?=
 =?utf-8?B?ZG9CdnhoZzl2Q25kWlNaenZ4aDQ3cmxqMTM0aHVFSWMzYnk0a3l6MGJiNiti?=
 =?utf-8?B?ekE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD58EDC0C36F524D9A84711839D713F0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b74717ec-5050-45c4-aaf9-08dacc6a3296
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2022 09:16:11.3525
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x9LhVXrV7Ib1i64ZGkbnVtScAiwLQawOSKGga00fP6txm7E8g8b47tA8cmUkTNwLG2qiYxrRRtuzopeVoBP0Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5120
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+ID4gPiA+ICsvKg0KPiA+ID4gPiArICogQWRkIGFsbCBtZW1ibG9jayBtZW1vcnkgcmVnaW9u
cyB0byB0aGUgQHRkeF9tZW1saXN0IGFzIFREWCBtZW1vcnkuDQo+ID4gPiA+ICsgKiBNdXN0IGJl
IGNhbGxlZCB3aGVuIGdldF9vbmxpbmVfbWVtcygpIGlzIGNhbGxlZCBieSB0aGUgY2FsbGVyLg0K
PiA+ID4gPiArICovDQo+ID4gPiA+ICtzdGF0aWMgaW50IGJ1aWxkX3RkeF9tZW1vcnkodm9pZCkN
Cj4gPiA+ID4gK3sNCj4gPiA+ID4gKyAgIHVuc2lnbmVkIGxvbmcgc3RhcnRfcGZuLCBlbmRfcGZu
Ow0KPiA+ID4gPiArICAgaW50IGksIG5pZCwgcmV0Ow0KPiA+ID4gPiArDQo+ID4gPiA+ICsgICBm
b3JfZWFjaF9tZW1fcGZuX3JhbmdlKGksIE1BWF9OVU1OT0RFUywgJnN0YXJ0X3BmbiwgJmVuZF9w
Zm4sICZuaWQpIHsNCj4gPiA+ID4gKyAgICAgICAgICAgLyoNCj4gPiA+ID4gKyAgICAgICAgICAg
ICogVGhlIGZpcnN0IDFNQiBtYXkgbm90IGJlIHJlcG9ydGVkIGFzIFREWCBjb252ZXJ0aWJsZQ0K
PiA+ID4gPiArICAgICAgICAgICAgKiBtZW1vcnkuICBNYW51YWxseSBleGNsdWRlIHRoZW0gYXMg
VERYIG1lbW9yeS4NCj4gPiA+ID4gKyAgICAgICAgICAgICoNCj4gPiA+ID4gKyAgICAgICAgICAg
ICogVGhpcyBpcyBmaW5lIGFzIHRoZSBmaXJzdCAxTUIgaXMgYWxyZWFkeSByZXNlcnZlZCBpbg0K
PiA+ID4gPiArICAgICAgICAgICAgKiByZXNlcnZlX3JlYWxfbW9kZSgpIGFuZCB3b24ndCBlbmQg
dXAgdG8gWk9ORV9ETUEgYXMNCj4gPiA+ID4gKyAgICAgICAgICAgICogZnJlZSBwYWdlIGFueXdh
eS4NCj4gPiA+ID4gKyAgICAgICAgICAgICovDQo+ID4gPiA+ICsgICAgICAgICAgIHN0YXJ0X3Bm
biA9IG1heChzdGFydF9wZm4sICh1bnNpZ25lZCBsb25nKVNaXzFNID4+IFBBR0VfU0hJRlQpOw0K
PiA+ID4gPiArICAgICAgICAgICBpZiAoc3RhcnRfcGZuID49IGVuZF9wZm4pDQo+ID4gPiA+ICsg
ICAgICAgICAgICAgICAgICAgY29udGludWU7DQo+ID4gPiANCj4gPiA+IEhvdyBhYm91dCBjaGVj
ayB3aGV0aGVyIGZpcnN0IDFNQiBpcyByZXNlcnZlZCBpbnN0ZWFkIG9mIGRlcGVuZGluZyBvbg0K
PiA+ID4gdGhlIGNvcnJlc3BvbmRpbmcgY29kZSBpc24ndCBjaGFuZ2VkPyAgVmlhIGZvcl9lYWNo
X3Jlc2VydmVkX21lbV9yYW5nZSgpPw0KPiA+IA0KPiA+IElJVUMsIHNvbWUgcmVzZXJ2ZWQgbWVt
b3J5IGNhbiBiZSBmcmVlZCB0byBwYWdlIGFsbG9jYXRvciBkaXJlY3RseSwgaS5lLiBrZXJuZWwN
Cj4gPiBpbml0IGNvZGUvZGF0YS4gIEkgZmVlbCBpdCdzIG5vdCBzYWZlIHRvIGp1c3QgdHJlYXQg
cmVzZXJ2ZWQgbWVtb3J5IHdpbGwgbmV2ZXINCj4gPiBiZSBpbiBwYWdlIGFsbG9jYXRvci4gIE90
aGVyd2lzZSB3ZSBoYXZlIGZvcl9lYWNoX2ZyZWVfbWVtX3JhbmdlKCkgY2FuIHVzZS4NCj4gDQo+
IFllcy4gIG1lbWJsb2NrIHJldmVyc2UgaW5mb3JtYXRpb24gaXNuJ3QgcGVyZmVjdC4gIEJ1dCBJ
IHN0aWxsIHRoaW5rDQo+IHRoYXQgaXQgaXMgc3RpbGwgYmV0dGVyIHRoYW4ganVzdCBhc3N1bXB0
aW9uIHRvIGNoZWNrIHdoZXRoZXIgdGhlIGZyaXN0DQo+IDFNQiBpcyByZXNlcnZlZCBpbiBtZW1i
bG9jay4gIE9yLCB3ZSBjYW4gY2hlY2sgd2hldGhlciB0aGUgcGFnZXMgb2YgdGhlDQo+IGZpcnN0
IDFNQiBpcyByZXZlcnNlZCB2aWEgY2hlY2tpbmcgc3RydWN0IHBhZ2UgZGlyZWN0bHk/DQo+IA0K
DQpTb3JyeSBJIGFtIGEgbGl0dGxlIGJpdCBjb25mdXNlZCB3aGF0IHlvdSB3YW50IHRvIGFjaGll
dmUgaGVyZS4gIERvIHlvdSB3YW50IHRvDQptYWtlIHNvbWUgc2FuaXR5IGNoZWNrIHRvIG1ha2Ug
c3VyZSB0aGUgZmlyc3QgMU1CIGlzIGluZGVlZCBub3QgaW4gdGhlIHBhZ2UNCmFsbG9jYXRvcj8N
Cg0KSUlVQywgaXQgaXMgaW5kZWVkIHRydWUuICBQbGVhc2Ugc2VlIHRoZSBjb21tZW50IG9mIGNh
bGxpbmcgcmVzZXJ2ZV9yZWFsX21vZGUoKQ0KaW4gc2V0dXBfYXJjaCgpLiAgQWxzbyBwbGVhc2Ug
c2VlIGVmaV9mcmVlX2Jvb3Rfc2VydmljZXMoKSwgd2hpY2ggZG9lc24ndCBmcmVlDQp0aGUgYm9v
dCBzZXJ2aWNlIGlmIGl0IGlzIGJlbG93IDFNQi4NCg0KQWxzbywgbXkgdW5kZXJzdGFuZGluZyBp
cyBrZXJuZWwncyBpbnRlbnRpb24gaXMgdG8gYWx3YXlzIHJlc2VydmUgdGhlIGZpcnN0IDFNQjoN
Cg0KICAgICAgICAgICAgICAgIC8qDQogICAgICAgICAgICAgICAgICogRG9uJ3QgZnJlZSBtZW1v
cnkgdW5kZXIgMU0gZm9yIHR3byByZWFzb25zOiAgICAgICAgICAgICAgICAgDQogICAgICAgICAg
ICAgICAgICogLSBCSU9TIG1pZ2h0IGNsb2JiZXIgaXQgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgDQogICAgICAgICAgICAgICAgICogLSBDcmFzaCBrZXJuZWwgbmVlZHMgaXQg
dG8gYmUgcmVzZXJ2ZWQgICAgICAgICAgICAgICAgICAgICAgDQogICAgICAgICAgICAgICAgICov
ICAgICAgICANCg0KU28gaWYgYW55IHBhZ2UgaW4gZmlyc3QgMU1CIGVuZGVkIHVwIHRvIHRoZSBw
YWdlIGFsbG9jYXRvciwgaXQgc2hvdWxkIGJlIHRoZQ0Ka2VybmVsIGJ1ZyB3aGljaCBpcyBub3Qg
cmVsYXRlZCB0byBURFgsIGNvcnJlY3Q/DQoNCg0K
