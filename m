Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37D7172FD46
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 13:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244279AbjFNLqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 07:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244272AbjFNLp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 07:45:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9B11BF9;
        Wed, 14 Jun 2023 04:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686743156; x=1718279156;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lMSuJVJD0SCHn4JWyBQcxn/9RFX5AUmlaPNs0aF81T8=;
  b=Jnh9Q1hMHJIWUCvq6hfZo6KoFuhi7AetwHrk9b6VztPgGHF+RzE8mxVa
   r1zv9gnnLbLYjm+ghZClcJrkCkLlXmEaTYHY6S2l1g6IHYL7aQhlE8lMf
   +WRYmz0UXv7KUWpasO+aCfusQUi1HDrzo1srdBCnLumkvPmzJmw98P0HB
   qIafH++VXIvXebBCQd3s62tswi/WFbbtFbB4KpIkmekf85neK5H+fRTBH
   KKPA/NsBY/jqE8OxHEptcYufHjTINxJyPdsgOTTfkiJYVNGvm5c/mafGP
   xef8bRSP2k1XTDIUov0dzdaqRz1l5y/0l9mTtx1BeQOK7/7898m+bVi5G
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="361961144"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="361961144"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 04:45:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="801880229"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="801880229"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Jun 2023 04:45:55 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 04:45:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 04:45:54 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 04:45:54 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 04:45:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zto0gQAyYn/5Bp3MnBaKBX3/MxHO/0coklksJpyHhwLkTC0cJyXuCyNIsFlAyfXZFEhMrFEmT64NrWDvcIM5Wu73vGyxJBd+qIeos61a4CU3XaQUd6zI2TRFdn3ZLXlzpvA15TDvm/feO9li9vAKETgZgYXjmVvr9b+U/DKwst6u2mj50BbMLbO83tJVhNz5wYaKU+zP6cdo+yYAdOXd55/F9aNUHD/j/G2KvHKOP580U5b1hiKA/fXOGadFoTayhs1u7oTDQq3ts3g2dM6ia/KHsQ/Vc2iSW0ol5NPehybaVj4VbSSMjx09efROKgx9jM2ZSvx/sIKCYRAfa/TptA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lMSuJVJD0SCHn4JWyBQcxn/9RFX5AUmlaPNs0aF81T8=;
 b=b4vEtuEE5ucejQtt0luF71A2eK+D9H49IDYvt43CgWxziOrlPwJiu35sBYkXFQazjITT4sKF4sQ4dw+yABe07t7hwm66KqnJqxhf5C2yldHWeTndq6BjzyxD29X/HtPFNaisb5FuNJfqK0L7sVNvI7H9HKmCG4xM3ydpR/8ULI5Z5/7kNEzwUV7i6bHf2z3iFLHxqyTPCJ52HZSORxOZHrNQ3uTi9+h5n8xQANx/mleLxuygMBQQOK1hUgafK89aJioBZHAaiuSrdooTdBj0uHirjgH/3s6bMVWfSvxqg+hB5kcUYeUvJpcfTRsEAQ9zUwW5H7iy/hiN/EkjOdj3NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 MW4PR11MB6691.namprd11.prod.outlook.com (2603:10b6:303:20f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 11:45:50 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::e8f3:851f:3ddc:fdeb]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::e8f3:851f:3ddc:fdeb%7]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 11:45:50 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
CC:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        "Chen, Bo2" <chen.bo@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: RE: [PATCH v14 011/113] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Thread-Topic: [PATCH v14 011/113] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Thread-Index: AQHZkeUO9CJK5Ein70KPqCCkDQrVv697abhQgARKm4CAAHDfsIABQawAgAgyIHA=
Date:   Wed, 14 Jun 2023 11:45:49 +0000
Message-ID: <DS0PR11MB6373FA1820DDC8804BAF6BD6DC5AA@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <37b118268ccf73d8e9cc1ef8f9fb7376fb732d60.1685333727.git.isaku.yamahata@intel.com>
 <DS0PR11MB6373872D1536D6469B29159CDC4DA@DS0PR11MB6373.namprd11.prod.outlook.com>
 <20230607181537.GG2244082@ls.amr.corp.intel.com>
 <DS0PR11MB63733FFA02B4A5C04561A1BFDC50A@DS0PR11MB6373.namprd11.prod.outlook.com>
 <20230608201054.GK2244082@ls.amr.corp.intel.com>
In-Reply-To: <20230608201054.GK2244082@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|MW4PR11MB6691:EE_
x-ms-office365-filtering-correlation-id: 1763c480-7b4e-4cb8-8d2f-08db6ccce65d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CQdmQWdl4I6o/2WbUS6zZBsuSt+IHM3FK0SJPIG2g4iDMfnfcZ/UZXGZUeHdR0cb3osKnCwBO6hhb0oia95vQZLuJN2B7RCRcwazhmWgxXvFTP9fHirhHIzsEULFllIsgTqZJqQzsLr6mxRgMmVIdKz1+9h8EFIT/YRQyeViCmKhDuh0cRKY2x04g4yu4zpwl9Wumzz/BF3opVwauwOHKJvSaNxy+4hzy77iGXsQ0Y7P1qvUIxJP7uR5BeWRee//VDgiMfGYLV4dNEZaEqGj94XFX1TCV9Wyj3lOm9hJnCTRrPiYJTGsBZbmA7MxRPhd15q9W35zfLqQYZYfXTKfwGaSsBCVQHh3PM5N3qVRm8qMUkVsOxLXEA5cY31CRH/7bMh96HiJmzRgDJSzDAONkK0WO9+9lyhs8crrQZ7EQqfItW71Dnk7xxHVmKUW/ag8eZSWFtDPdOnucs4TxYz1T0P0VGG1XXIzSkadFxAN8AFiuNEUPHmJDlA5xkxbZtyTWtp+x+u6w24x1Vu3+X6hiC6u5j7vIvU0qayVQveIYTHR+WEtDGgV0ikQRmygTD9EfQOUFUWct2dL3GX4QCqi92r4n5zUrSTVfRj1a5nLuEGAnxl6sMhUpPA/n+iWww7/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(346002)(366004)(136003)(396003)(451199021)(26005)(9686003)(83380400001)(52536014)(53546011)(107886003)(6506007)(5660300002)(2906002)(186003)(71200400001)(7696005)(8676002)(8936002)(41300700001)(55016003)(66446008)(66946007)(82960400001)(122000001)(478600001)(316002)(54906003)(38100700002)(6916009)(66556008)(64756008)(66476007)(33656002)(38070700005)(4326008)(86362001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmxYZmxvWm9KQkhUMjVSNWxXUXNQRWJBVjd4VjR0djNSMjR2Q1k5N2hNVnB2?=
 =?utf-8?B?NXBrcmxWQmlZTWsrSnZtYmV2WkJCOFAvYUZxWjdmMXNyUTdOUUkrUHlmTXNy?=
 =?utf-8?B?cWgrcjB6RE5YSmZ1N1V0TytEd00wSVhMdDJXSU5rbGszMWVmWStaRnd4b2Rq?=
 =?utf-8?B?U1hZV0xpVkJNU1Vjc1hKb3pYSTByNXpmOXVFWERPRU1mZzVPQVdURW5UTUNV?=
 =?utf-8?B?UTIwR3JPcWlHS1hqelBERy83aTR5UUhyRXN1dFRHbytRbEw2SFc5bS9uZE1M?=
 =?utf-8?B?a3NLejQxY0ZBS1VwQm8xdC9Uc2JDYllzVk9EWFBmZE9OSUFmcjdadDkxRkt2?=
 =?utf-8?B?MkR2V2t6MUxRc21Ld1c3ckIva1h0dnFPcGQvMmJQMmpEeTFBd1pzaGRBTkpK?=
 =?utf-8?B?S0ozQTc0bjJpZ0VLVzY5ZGVkeDZIcnB6c2RLenRqdkZoUUZ2Z1dEOFFtNHlB?=
 =?utf-8?B?TWtVZkdQZVFWZXNwNU9oaXNIejQ5S0JFOVZwREFKbDlzeDA5K2taMzlNN3pF?=
 =?utf-8?B?RGdHaEVSWGdnNVhhUWdRZWQxbWd6cFExRkZsU0k3dk93R2gzQ3NJS1ZkT1dr?=
 =?utf-8?B?aEJZZ2c1WXAzNXk2YlhYeVE3anc5YnhYSlRod2FiRTVGOHZHd0lMOEtVWDds?=
 =?utf-8?B?ZlI5MVJmREM1WG83NEd0WW1NMGdTZ29yRXYyZDlsQ3FxMVQzdVZCYmV5U0xH?=
 =?utf-8?B?b2lyRFRSNTIvK0NKajZLREVaemJVbGM1QUNMemN4cHlNYmt3ZWF1TGFzY3lX?=
 =?utf-8?B?T3lweVNCWmcvYTlFZkYzcjNIOXpibTNOdmNicTJ0bmJRY1BRLzJNZGlYSEVE?=
 =?utf-8?B?RGxrT3Y2R1VabHR4d3VhOE90VEhIY0lVaWJnV1lkbDR3MktxSTZqWmVVMUp2?=
 =?utf-8?B?M0pCQXdCdWFjUUNUdlNtaVBaSGRtbWl6VUpiSHpLeG50OG43LzhYM3A1TFNl?=
 =?utf-8?B?akVzbU15RjF5VE9HRGI2VlhUR2p6cE1UbzRzRWhBZ2lHVTA3ZE0xbFFwWVhU?=
 =?utf-8?B?VnBjVnpuOTRWa3NsQnFqZGZNVFA0K3hEdHNmeDVXTkppejdGQWp1RTlxR0Zm?=
 =?utf-8?B?cmprZ0d1dzhyc2Q4cXFNMGdPTk03YWNyZmRrdnNJOE9wV0pLdXQwVnVCSkMz?=
 =?utf-8?B?WWJJN0x5cWsxdnUvd0lJVGUxVUk0bkRLQ2NPc1c4dlZseUdYQzIwdk1kMmJn?=
 =?utf-8?B?K2FpQlVLeGhlWjlhZWN3YmZtL2ZZdXNlbzZSL0RCSU45a2toUUxIYzB4YXpD?=
 =?utf-8?B?SHBLV0pTUzRKSkl1QWllcVFLWk1McnBsZnpmWmdDQ1F0OG5ZRVkvMUpTR08x?=
 =?utf-8?B?NzRVVEM4UzQ5MkdUVEw4d0RKZkNwV0VBblpJaUphalFoa3ZSa1pqVXhlNXMw?=
 =?utf-8?B?eGxmUVZKOXhzaG9pVlFldDlRSlQ1N0M5S2k3OHd1blIvSzZ3ZVFmTi9IZnRt?=
 =?utf-8?B?VFBsVk5kTlNZOVZ6Z3B0cklGSjgxNFNaNm5pbDdhT2FOeWlzYXJGNEpHMG1B?=
 =?utf-8?B?R0t5b3dNRUZTbldYL0JGVnpjaE9odDV3Z1hQZC8yc2YzWFI5ZnBnK1RLeFl1?=
 =?utf-8?B?SVRzaUNFRnYvWkxEZ3pXRVFvY3QxTW1JYXZVd3c2VkQ2dXI0ZFhQdjNTaDJa?=
 =?utf-8?B?aXdWZkhOdC9zYWRPdGFCakZBandSZE9URFlvUGNINmh4Yk02Q1NJeFZ1L0tU?=
 =?utf-8?B?NjhjcjJyYmw0M3N5WEhGd1krV1lHNCttaUp5RmVzM2dveWtpWjM3dGFCT0lw?=
 =?utf-8?B?Q1MvTU1wOTIwY2NzNjBhZ2lwV2tVTFQ4a29xNXIxUllpMmdLTVozRmJmM2xa?=
 =?utf-8?B?WDBlR1puM3kvVHIxalJ1cDg1NWhXSU9QRmt0RjNwb3IvcGsweW5BVjZqdXNT?=
 =?utf-8?B?aU04NGZBclBxTFBFV0h4eUg2SHJkUTlSVGlybkZOWndROUlRc2tiMnd5empL?=
 =?utf-8?B?MExrNWdVVGRGSzljeGFyRXFBWUR2dkFRcmcxYVUzVlV0NllrZXU2Wmg5WlU4?=
 =?utf-8?B?UlRTK2p5ZW5SamNCemJpOVJBc3NxZlNUcVIrWjRyeG5EZ1VEajJIekJIY0N5?=
 =?utf-8?B?NFdWQUhLMXZELzVEd2F6ZHNLMFZrVS9HRkNETy9BdUtIYzdST1ZUL2R4ZCtk?=
 =?utf-8?Q?QdgQKH8rmmJo5RX+HsMJTD63j?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1763c480-7b4e-4cb8-8d2f-08db6ccce65d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 11:45:49.7005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rLlXckX1MQKKp7eg2melpddqlir0X5wq5xvqRRtBd5HVyFlpe6TGgW+5bP3bQ/5aAyst1+d88ae8zbBYQkAstw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6691
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpZGF5LCBKdW5lIDksIDIwMjMgNDoxMSBBTSwgSXNha3UgWWFtYWhhdGEgd3JvdGU6DQo+
IEhvdyBhYm91dCB0aGlzIGNvbW1lbnQ/DQo+IA0KPiAJaWYgKHVubGlrZWx5KHJldCA9PSBURFhf
U0VBTUNBTExfVUQpKSB7DQoNCldoZXJlIGlzIHRoZSBURFhfU0VBTUNBTExfVUQgZXJyb3IgY29k
ZSBkb2N1bWVudGVkIGluIHRoZSBzcGVjPw0KSSBmYWlsZWQgdG8gZmluZCBpdC4NCg0KPiAJCS8q
DQo+IAkJICogVERYIHJlcXVpcmVzIFZNWE9OIG9yICNVRC4gIA0KDQpURFggcmVxdWlyZXMgI1VE
PyBTZWVtcyBhIGJpdCBhbWJpZ3VvdXMuDQoNCj4gSW4gdGhlIGNhc2Ugb2YgcmVib290IG9yIGtl
eGVjLA0KPiAJCSAqIGt2bSBzaHV0ZG93biBub3RpZmllciwga3ZtX3NodXRkb3duKCksIG1ha2Vz
IFZNWCBvZmYNCj4gKFZNWE9GRikNCj4gCQkgKiB3aGlsZSBURHMgY2FuIGJlIHN0aWxsIHJ1bm5p
bmcgdG8gaW52b2tlIFNFQU1DQUxMLiAgSXQNCj4gCQkgKiByZXN1bHRzIGluIHN1cGVyZmx1b3Vz
IGVycm9ycyBvciB3YXJuaW5ncy4NCj4gCQkgKiBJZiByZWJvb3RpbmcsIHJldHVybiAwIHRvIHN1
cHByZXNzIHN1cGVyZmx1b3VzIG1lc3NhZ2VzLg0KPiAJCSAqIElmIG5vdCByZWJvb3RpbmcsIHBh
bmljIGJ5IGt2bV9zcHVyaW91c19mYXVsdCgpLg0KPiAJCSAqLw0KPiAJCWt2bV9zcHVyaW91c19m
YXVsdCgpOw0KDQpJIHdvdWxkIHB1dCBpdCB0aGlzIHdheToNClNFQU1DQUxMcyBmYWlsIHdpdGgg
VERYX1NFQU1DQUxMX1VEIHJldHVybmVkIHdoZW4gVk1YIGlzIG9mZi4NClRoaXMgY2FuIGhhcHBl
biB3aGVuIGhvc3QgZ2V0cyByZWJvb3RlZCBvciBsaXZlIHVwZGF0ZWQuIEluIHRoaXMgY2FzZSwN
CnRoZSBpbnN0cnVjdGlvbiBleGVjdXRpb24gaXMgYWN0dWFsbHkgaWdub3JlZCBhcyBLVk0gaXMg
c2h1dCBkb3duLCBzbw0KdGhlIGVycm9yIGNvZGUgaXMgc3VwcHJlc3NlZC4gT3RoZXIgdGhhbiB0
aGlzLCB0aGUgZXJyb3IgaXMgdW5leHBlY3RlZA0KYW5kIHRoZSBleGVjdXRpb24gY2FuJ3QgY29u
dGludWUgYXMgdGhlIFREWCBmZWF0dXJlcyByZXBseSBvbiBWTVggdG8NCmJlIG9uLg0K
