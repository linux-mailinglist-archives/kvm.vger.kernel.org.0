Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E875980DE
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 11:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242197AbiHRJdb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 05:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241034AbiHRJda (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 05:33:30 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FCC5140D;
        Thu, 18 Aug 2022 02:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660815209; x=1692351209;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=I5dKYuDrB71KM4fEc3whMUt3eto6UsWX18hDbHqb8XM=;
  b=D9g6biUXIcrVgVCrVQ1yTcXUkPbdkWfkFRpXhkSIdLwPafnCHsbjmV+z
   l9/RrtoEg/JZMa31nQ5Ftusgeug4HvXb7Uejy+7Ymx9sLRMpjQEQ9Lddj
   4EymG3Ak3WI6NvGI/Cc1scWAC07sqGjwq8mAsq/zwK1fWjuZ+GsJuedNQ
   8Pko2rEKuLssnJ5oR+xD5X73uhMfYemr8t6L/QpBVCYHn5uJS/8GM6/FY
   H0fzAed5nb4l+sYu7kFw5UuWmuEiZbdh7S6AYOG3Ibw7YXS/uuOoOz1Ha
   LM7l99/v3H42IKBW8/5rebme98O5hESUfdkzlbE4UQark93aUV4q5efL3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="379007254"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="379007254"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 02:33:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="640792473"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 18 Aug 2022 02:33:28 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 18 Aug 2022 02:33:27 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 18 Aug 2022 02:33:27 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 18 Aug 2022 02:33:27 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 18 Aug 2022 02:33:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f6s8x+GGBR3mlgtlCIF7IrE8VGwR2SPwvT2Ac2docyerp2dHDv5B/nkIJrLeLBMYK/zwpxWMt2bDwrD/KdHq51KaS6cvj5LmtuS+sv2gwAg1qzcuz9h/eIjhScIKFYskQW/UdrXYt9WCO+qKbV0emYFHhi6eHpDOy3fqQjgbdrpNTFsNUz0s89b5ikh0D4YnVJSHuB9qdhicEmMas5oAZQqHH9dhxnGcRv1HTxCv/Hsyeo6ayGtV13IxmhHqEjYDqYNF8FeNYzzEpJYu8Q66BSWzQ4WAR9LHgHoSMpCvLczRuV7ogrjbpCi9aVf95CilgZ6wFthuvFR1L39sJrnL1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I5dKYuDrB71KM4fEc3whMUt3eto6UsWX18hDbHqb8XM=;
 b=fV7nYgRAFHt7t7QeCTOiVgat6/48a0OK6SMaWiOCbqlSpKL73kpynC1sfCuq+ZD7Rnto13UBWBRW+c7A8lfJaj2UFX8u0PjX+eD+dC69LtAnVK7PF2KlrGt+GplRiX+KDnhB+Em5F1bOyXcklhGZATPlrYXSM2UOZP/BzdNDyaLG2+KbgEBopnzMn2pdIwCR9RpfezWqEMfiBtM2GAMOtxv6MrkalAlYEGVo6M0xKNVGbWAXhVIop/oQu/ldlCsddzw2xrQMzDdr02XjH4Aofc7TzXL5NnEG8CNCx73T+jI7D5Afj6XhG/FgGIUyCBQwzhEQDGI5yNXUr2P0Ds78NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BY5PR11MB4498.namprd11.prod.outlook.com (2603:10b6:a03:1c2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 09:33:23 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::1d3c:4dc0:6155:2aee]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::1d3c:4dc0:6155:2aee%4]) with mapi id 15.20.5525.010; Thu, 18 Aug 2022
 09:33:23 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "bagasdotme@gmail.com" <bagasdotme@gmail.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 22/22] Documentation/x86: Add documentation for TDX
 host support
Thread-Topic: [PATCH v5 22/22] Documentation/x86: Add documentation for TDX
 host support
Thread-Index: AQHYhihSpwv7r1LcZ0uwUkfOuUb9Ka20Y6yAgABbIAA=
Date:   Thu, 18 Aug 2022 09:33:23 +0000
Message-ID: <b7771040f1976f8c2d168a8d74231e7915e9ae3a.camel@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
         <0712bc0b05a0c6c42437fba68f82d9268ab3113e.1655894131.git.kai.huang@intel.com>
         <Yv268Z0i+rq7r/oR@debian.me>
In-Reply-To: <Yv268Z0i+rq7r/oR@debian.me>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b01db78-e2e6-4b5a-76d2-08da80fcb1f1
x-ms-traffictypediagnostic: BY5PR11MB4498:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1tomBsIpUQogT/s++x4gR/8qury7i1eA2rf6WvVCnyHz/cij80VXEuWsIDgRBeG4sWqpyQ68sn6B8jBdnd+0LoZ1EOc31qt4q3lqJOz7719bO10j5FKE02Y2nquUc7xqK0syqpPCB1ZLmqW+me1Vr6MYcv2z9z/pvC19WQGksgRnnUgwxAWYtE34G4g55gU2g9vLH0NhbWY0YfmGsNaYYtjVEyvNLFobaka4qry+TLVb1ixdbzcoQ1lDCrsJZR+7SWkJIZ7xPCYxstLpseLYm9TArrmF40A0YVNpZIhPXd6qrfb3EygapvVZCanhESiSuA3xXsOWmezB8WOW+McTc7F+D6aqQzF2zIiCkKjMbs+PJCjheuYsnFQ88rUVjt207eKBkc9P5wiuB747q3+8M7SsUswlV5Vkrp7dSIQowB1pI8ERz1KIzGczYg2ryyG1nnANIJbXlUyrKZYw32IjVn26UdHd6WDolj4riRx65KQ6QGtzx0LlkPVqiI3lT2jeSrIjXWltg3B3iIkTxwPM4bwJmGGEVgdJHnZQkVlZsu0ST9AGgtzPsJqARwkxDYm0zcVp636eXlnPW7ocoht+kyVZGdgM4jmhYcXggDy2b/MpBmjjV5j1VxnbifaE0IqIxz8kfJ8XvZ2NiaeBGHSSXa441h5pG2HV7CqgZo/nYjmt1XXHkWeBxXLuTJ6Bgu5kqG04dTnLQ5wCdo5lPYjZCiOgVYyM/AGdR9Tiqo6BFNfM7EfsQJq6s7WiAQ741Q3oeKi/+09jM4fUT7EEKWvjOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(346002)(376002)(366004)(396003)(86362001)(38100700002)(66556008)(4326008)(76116006)(64756008)(6486002)(122000001)(2906002)(71200400001)(66446008)(8936002)(91956017)(5660300002)(66476007)(38070700005)(83380400001)(82960400001)(54906003)(6916009)(66946007)(8676002)(7416002)(6506007)(36756003)(186003)(2616005)(41300700001)(316002)(478600001)(26005)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cm1HM0o4NjlaOFFsRmVHYkJkSmJLTXlBaklyVnVPVGxrQWkzK1dkWThKanF1?=
 =?utf-8?B?MGdHemZPeTFHOVh1TVJZRHM0Z3EvTWhZUElIZ2N4UkVBVkZVUzBjZmpkSGJq?=
 =?utf-8?B?WnJ3TGxBeGlKNTFKRmFucVY0aVJEVy9IVzhtT1MvTUdXRkdqMlk0M2c0UzVR?=
 =?utf-8?B?MWVYRkh3M0d6dEIvaTBmTkNBQ0F1Vk53NTdjUVM1R0ZQNFE0VklwSGZVdGlN?=
 =?utf-8?B?NmdMZ3p0bWdlYldoY0V0NDRNQ3FkUUFFaTR4cVpRNlZxMUV6OE9BdmtsbUVm?=
 =?utf-8?B?TndmYU5rZC85ZnNPR0M3NmdrM2pGdncyRjI3enZORkRFZnR1Qy95SEkrSk1J?=
 =?utf-8?B?N1lhNTRHTkFZRXBFM21zcVB2Vk9TcGo3czNLaXd5SER4ejRPSDRQalZsbVpr?=
 =?utf-8?B?K3l0QkZQSVFBRk1DS2dXeThDaDRjdXFtMHVyVWhwdFFyRkpxb2ozOUhNYksy?=
 =?utf-8?B?c3VuRHJnS0FVRkM0OW8rVjRXcVZvN2wxd1Y2OUlHd3VQN0krT1ZFQ2hGOGRK?=
 =?utf-8?B?cWkzOG1jYTgzbkE0dWNXcEMzaVNhQWFGNkF5Nkt3U1d0THBOUEg2dm0zd3JT?=
 =?utf-8?B?Z3lFdFJQejlJeHFhZ080M0p4WEkrTFlCWkxleDgvVU9JZEdxTW11UnRYbUw0?=
 =?utf-8?B?bjM5Vmlkd0dWVWFNcFpUN2JlVDhyVUNsY29ITVErV0YwaU05RDg2VXdZb1By?=
 =?utf-8?B?RE9Xd1VLb3puWnFWcUNWZ1dCTzlHUjhGMW81OU9vUmZqYzkrYTd4azMyV1kx?=
 =?utf-8?B?bXJ3UU9NQks5a2pDMTRtekJtSVd2SVFQdjl1dXlUTHVHL2VjYlZEMGYxQW9Y?=
 =?utf-8?B?RWt0MkVya0ZHUzdOdHlPTXdTbmtwTXdYbEgzM2E4cFhhRjZBSEdCV3JrVk4v?=
 =?utf-8?B?Vk1xa2VDTHRDTG8wTk9KMGo5SGZwQXIvQzhGeldaVjNIcDVGandmWlMyeFpY?=
 =?utf-8?B?NUtpZHBqUFlydzRjNWNFQThGZkhOZTNtSWFkNEhDdVY2TVc0OFhGakdKclRj?=
 =?utf-8?B?emdqODlCaFlnZHo4L01YSXIxZy9YWnpzb2ZIOXNNUm1nWm9rZ0FZN1RaQ1V6?=
 =?utf-8?B?QkhVdUJ2a0xLWjh2SWlYMFhVNSsyUUtsTnhUNWdXTHFpbVRWRFpodHg3MFpi?=
 =?utf-8?B?TzhRdVZGdkFhMFl1bWdRQU92S1F1UGV5QkVWYlovTnNwUHNLUmx4b2hzd0tQ?=
 =?utf-8?B?WmVFTk1FT2RSRGlsdFloeFRKRU5vRXRCVFBQaU9MOVNETWh3WUN1aThPNzBa?=
 =?utf-8?B?K2dmeWlpRzBFajNuSUFTTGRCZHhSdGk5SExVTWdxb1RFclF4Zy92YmJiUFFt?=
 =?utf-8?B?OTlsdUNLdG0zUzNhM1Q2N0RNVHpmblJxbEJIK0JPZUVhREg5VDJ6dUNrUTdN?=
 =?utf-8?B?UHl6Ry9rNjNsZzh4OWNaQW1jTFpFWEhCYWYyZlJiVWFXZkg3V0lkdjRtV05M?=
 =?utf-8?B?emNBUFFvWlQrR2JwdU94ODFkbkh4aXBqaUo1ZWVvOWVMdUlmOEVHUThxZ0x1?=
 =?utf-8?B?TDc3bDZZbEtkWnMweVRPMWY5MW52UWxuUll6RmRlQzRkRjVBbldWVDY3WEhF?=
 =?utf-8?B?OTM5ZG5vZVRnd2RWSzV3YW1lSWFQcHdreXBYK1RTUG9MZEFad3ZWY1Jzb21L?=
 =?utf-8?B?ZWxJUHZQejlpWUpzUGRpdDB3d2xJZWl0MWpkUFkyalJIc1J2TmFQb2VkQVha?=
 =?utf-8?B?a09jNE95Mm5UUHNEOTlhNHg0TE5yR0RlamlmblA2Q01jdDVoN2l1NU94SmFz?=
 =?utf-8?B?YUZIVDdyUWpZeitHZ0cvaDFxOEVPSzZCZ2h2NitpV2RJSGxnNzkwcDlyam9m?=
 =?utf-8?B?UktzdytRczlOc2pGTGhtSmhnUzNjWDZBNDRuYTdoYlE0bVNIN2NaZE1NT05m?=
 =?utf-8?B?YWFOcUU2c2kxbXgyR28zdDRiNGtNTWlNQi9LRzVqd2d2bGtMUUoxVzdjNHNa?=
 =?utf-8?B?M3lQTVllR3J2aFRIMXVrMFdrRDFNcEYzL0Z2UkFFbHFBOVZUYllpZ0tpZDV6?=
 =?utf-8?B?blVhQzJyK0NiekdqNkxvSExrNU1WeUIyL1FtNjM5MEZDOVhqYkhEQllBQ1Bl?=
 =?utf-8?B?b2NpUTIzd3h4eWVQeFp5UGVtY3pyWFpqZllpRHZkQ1dEZWZHeWtOSFBXaGda?=
 =?utf-8?B?QzJMT0d6ai9ZTXQxOEJ4bHpLYkxCSTNuWGNRcEswcFVKbGl1VUMwVFdQdU5h?=
 =?utf-8?B?bXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D7B07D60EC7B9C4B9DA0BD19363A9FEA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b01db78-e2e6-4b5a-76d2-08da80fcb1f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 09:33:23.1539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aYliNlEJhilbAQhnZ4fCFIjuewXM4xRLaR0OVp+6vsN0GErG6ro2d3IGcmCqS+3G7WjFRfYMJAYOMg9xJFe9BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4498
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

T24gVGh1LCAyMDIyLTA4LTE4IGF0IDExOjA3ICswNzAwLCBCYWdhcyBTYW5qYXlhIHdyb3RlOg0K
PiBPbiBXZWQsIEp1biAyMiwgMjAyMiBhdCAxMToxNzo1MFBNICsxMjAwLCBLYWkgSHVhbmcgd3Jv
dGU6DQo+ID4gK0tlcm5lbCBkZXRlY3RzIFREWCBhbmQgdGhlIFREWCBwcml2YXRlIEtleUlEcyBk
dXJpbmcga2VybmVsIGJvb3QuICBVc2VyDQo+ID4gK2NhbiBzZWUgYmVsb3cgZG1lc2cgaWYgVERY
IGlzIGVuYWJsZWQgYnkgQklPUzoNCj4gPiArDQo+ID4gK3wgIFsuLl0gdGR4OiBTRUFNUlIgZW5h
YmxlZC4NCj4gPiArfCAgWy4uXSB0ZHg6IFREWCBwcml2YXRlIEtleUlEIHJhbmdlOiBbMTYsIDY0
KS4NCj4gPiArfCAgWy4uXSB0ZHg6IFREWCBlbmFibGVkIGJ5IEJJT1MuDQo+ID4gKw0KPiA8c25p
cHBlZD4NCj4gPiArSW5pdGlhbGl6aW5nIHRoZSBURFggbW9kdWxlIGNvbnN1bWVzIHJvdWdobHkg
fjEvMjU2dGggc3lzdGVtIFJBTSBzaXplIHRvDQo+ID4gK3VzZSBpdCBhcyAnbWV0YWRhdGEnIGZv
ciB0aGUgVERYIG1lbW9yeS4gIEl0IGFsc28gdGFrZXMgYWRkaXRpb25hbCBDUFUNCj4gPiArdGlt
ZSB0byBpbml0aWFsaXplIHRob3NlIG1ldGFkYXRhIGFsb25nIHdpdGggdGhlIFREWCBtb2R1bGUg
aXRzZWxmLiAgQm90aA0KPiA+ICthcmUgbm90IHRyaXZpYWwuICBDdXJyZW50IGtlcm5lbCBkb2Vz
bid0IGNob29zZSB0byBhbHdheXMgaW5pdGlhbGl6ZSB0aGUNCj4gPiArVERYIG1vZHVsZSBkdXJp
bmcga2VybmVsIGJvb3QsIGJ1dCBwcm92aWRlcyBhIGZ1bmN0aW9uIHRkeF9pbml0KCkgdG8NCj4g
PiArYWxsb3cgdGhlIGNhbGxlciB0byBpbml0aWFsaXplIFREWCB3aGVuIGl0IHRydWx5IHdhbnRz
IHRvIHVzZSBURFg6DQo+ID4gKw0KPiA+ICsgICAgICAgIHJldCA9IHRkeF9pbml0KCk7DQo+ID4g
KyAgICAgICAgaWYgKHJldCkNCj4gPiArICAgICAgICAgICAgICAgIGdvdG8gbm9fdGR4Ow0KPiA+
ICsgICAgICAgIC8vIFREWCBpcyByZWFkeSB0byB1c2UNCj4gPiArDQo+IA0KPiBIaSwNCj4gDQo+
IFRoZSBjb2RlIGJsb2NrIGFib3ZlIHByb2R1Y2VzIFNwaGlueCB3YXJuaW5nczoNCj4gDQo+IERv
Y3VtZW50YXRpb24veDg2L3RkeC5yc3Q6Njk6IFdBUk5JTkc6IFVuZXhwZWN0ZWQgaW5kZW50YXRp
b24uDQo+IERvY3VtZW50YXRpb24veDg2L3RkeC5yc3Q6NzA6IFdBUk5JTkc6IEJsb2NrIHF1b3Rl
IGVuZHMgd2l0aG91dCBhIGJsYW5rIGxpbmU7IHVuZXhwZWN0ZWQgdW5pbmRlbnQuDQo+IA0KPiBJ
IGhhdmUgYXBwbGllZCB0aGUgZml4dXA6DQo+IA0KDQpUaGFuayB5b3UhIHdpbGwgZml4IGluIG5l
eHQgdmVyc2lvbi4NCg0KDQotLSANClRoYW5rcywNCi1LYWkNCg0KDQo=
