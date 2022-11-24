Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F54E6375CE
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 11:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiKXKCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 05:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiKXKCi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 05:02:38 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8009C13D32;
        Thu, 24 Nov 2022 02:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669284157; x=1700820157;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bKMIdjWzADOAlT9CqCoi6lU4zl59U7Q552dBIzu61j0=;
  b=Yx4yRgjQi4U/svXYeCUsJpI7e8xfzRkT6wvC1tr3GpjHtprsmAz2s7YJ
   /b8N7CdreUmohp88TBEUQ6xbM6jMIXzesNDfPfl2PoLqYKd1EnDeO8btH
   NFgsXKxdmAocuN6yawK3rICyu+ypr3MZgKRh+wJnekrbNXY/sbb1Kxf6L
   X493+xVpr98KrAEwAJ78q0HdAbysGAsTL3CpOKs2tG4PdgOb/7bhRhNIA
   LKtzSQ4YkEkbnNE6RwgaI/2DFZFxZSDi9iTSvIivgnqeUe0J1PJ04xGPy
   rIVia/O8zWD2JaeuvAdeMz8gP6sXWJX5yXnBeGznPmZONaSHsEv8A2K5a
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="293971888"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="293971888"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 02:02:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="592861165"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="592861165"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 24 Nov 2022 02:02:29 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 02:02:29 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 02:02:28 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 02:02:28 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 02:02:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RobGCUBlny1EWHe93Rr3Xg5Xxd6yUvo3dij7Vpm/NsrB9TsKDZBJcSQCHrn7P4dQ/Ykax6T3wlWO7xZFx1PXZucNQlG/Czx30zG6We8p7VmF4CwbaurQhlpH92cdwJBN+iwrJMKQx0/2OBMcrV6h48ZTCiDV97IRMyt817/C0/tVSymavTaWQ3XhScZO+ovVsA5HH7w28CBpwSc/oHjCkXxjl1PE91e67s2NLpxlSoSUo15j0Ac9EcDbUGbLqPejIgXykaMOf9wWAsLjRltFcHwWNpebPvFoGTl/AK6L/guKtx+7B0cnHUEIJ6UyavxbLVQ9H9xM9UxNhWA5FHk0CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bKMIdjWzADOAlT9CqCoi6lU4zl59U7Q552dBIzu61j0=;
 b=nJUwJCIiaOv5OQJzCbirFxKrNnHkXlZHP8TC6AAqGS/RcWV32d3WAMi4fFqjheHwkO53Yv6sJu2UIMhxQ6ZbMIT21ac4gKdZiMJQydv+Mki6IKjKt7NZUL1pE1ADHruQA9udjXO/YEOhMtnP8X73lojY6wFbuDJ9FkL7WxOHf+Q4H7cri00UgqNJzYpUmmkE3sKcHdGK3gAVy5l4TBEQ4r7nN4nKGEEvEv1FLW9x9BUNvCRR9lKIOCuynLG/zvxur+BX7vGdiwULLvXPcmihNxXz/iSVWv1jNkjUle9rBVYPmwIkCObwKzGwiAp1yk2SPl7t9PHKJ81Y9vD5CYa35Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7506.namprd11.prod.outlook.com (2603:10b6:8:151::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 10:02:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 10:02:24 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Topic: [PATCH v7 10/20] x86/virt/tdx: Use all system memory when
 initializing TDX module as TDX memory
Thread-Index: AQHY/T3KCI/2IUKL7kSgXbHXnV3Az65NU9CAgAB/UwCAAAoTgA==
Date:   Thu, 24 Nov 2022 10:02:24 +0000
Message-ID: <699700de9d63fa72fda4620d052fda3427193b21.camel@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
         <9b545148275b14a8c7edef1157f8ec44dc8116ee.1668988357.git.kai.huang@intel.com>
         <637ecded7b0f9_160eb329418@dwillia2-xfh.jf.intel.com.notmuch>
         <Y384vDcfTpTnFxx+@hirez.programming.kicks-ass.net>
In-Reply-To: <Y384vDcfTpTnFxx+@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7506:EE_
x-ms-office365-filtering-correlation-id: c85aab9d-0e98-4426-1632-08dace02fc76
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SiQtnw8JqBUV/bqVqaLRz0jPbfGfj8lrnVA4vjf9X4rmHb9CQIA86ruLgk/6ERXwbL4FYWKcpHZLtnaxBW9xJROb/acjPN7XjV9n4S6OXf78UpncOteecaS5tvvQ3HkSYyNbCTnAOUMxQA4GOl06uAWubZYvyJyhT6zx68KxSxh/JljH58OfT1Wm2jACEhjhdgL07MzJkFR4ocMJGTsOI8wlm8K9teOkkpG4a1omhlmHwnsXAn3nE1+jeVs8j7lErd5rzak2PlpYEzBZ8wzBB8lrGVfvsH6QepAx707H7sfMXAaUj/vjCO2ahzq7LXYYIZG9825tnz+J2VE7dn2RZ/3ngGCL6l1/ZvE65+QXM+Di37kUnn5n94vecUdngKnquqXgKP1a18LdzwBOkJQ3TSfjKzUEbzh6KV8Xld28rn2c/YG6NKtA9Nu8Xg1osJxhdeIwgRIoH3qrF15Kje9ZYCjDbIqtGNb0+vynwi9BJnCmqePmf9Zlrs4uXWaHqf6I+/+4abzMpRSbKk7L2ttpDoMMYXVUkMNrDHGh24W0ri4NqOIMEksusg7iMKGynnjxN26uMKsVPQhTeh/5BSzMfFmJ3KVC+XqeWfTc2wpCvBQTOgMyw1OBQPP1+tiptSnpy7YoTcs2IOIvG6rTd6Pi5iUG0vMLlnjRTfiNN5ZBimYa/XmvaP7I4NE2/XqrEPzh/7GVerEOe0Diz1z6mh7Aow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(396003)(136003)(376002)(366004)(451199015)(36756003)(6486002)(478600001)(71200400001)(83380400001)(54906003)(110136005)(186003)(2616005)(38070700005)(4326008)(8676002)(64756008)(91956017)(66556008)(66446008)(66946007)(76116006)(66476007)(26005)(316002)(2906002)(6512007)(122000001)(38100700002)(82960400001)(86362001)(6506007)(5660300002)(7416002)(4001150100001)(8936002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1Qway9UVDF2SlN4djZJY051SC9QU3ZMcTVlOER1TDF3Mk94c0s5Y3hSbnB0?=
 =?utf-8?B?Z1pmbWppc0s1L1RURE9LbzYvbWRvTXJwdS9LOHFJQ1NCTlpObmgrZHBKMUt4?=
 =?utf-8?B?YkQ4ZU4veUtZcHZHV1ZYQlJSeElLVnErVi9zWWlLMmZFckJHeG9PRmx3NGo4?=
 =?utf-8?B?cnA0OHEzUDE0VExueFo4eVBRWWNSZ01nUUppOG1mQXpnSWw4YmtCaTRsY3N6?=
 =?utf-8?B?eWx1cWVnanhkOU93SXVOdnd3b3hENWdXYXlEZlhuVlY0cTZoTzdVSFRTWkp5?=
 =?utf-8?B?WEtvT3gzOGZPbU1iWVpMWGljVXVIcVNWTDdGRG9NUzBjaWIzNWlXUGswem1D?=
 =?utf-8?B?TE11U2s3VUFWTXN0TDEzZ1dEb1pyVCtJT3EydEtobk96Nm5rdk9US3RzMWds?=
 =?utf-8?B?VXB5ZGRybUV4Q3FtT3ovT0JMeHhRdk00b3N4T3ptYVUwb2FjdmxNTjM2WjF4?=
 =?utf-8?B?ME5jOFdFMkowV2hLUmVaWGhEWEhQTW4vb0krUnQ3UTI0d2pJQUVxbWJBditY?=
 =?utf-8?B?cjlKS3VSSXREbDFvYm5ZNmNrZDRhWTIzcndpTWVYVHNuOEhKaGh6Y3NHUkNZ?=
 =?utf-8?B?endiY21pSmhZN00zT0QxSy9BY1ZxOEV5Mm90VTdsUG82MDhGWFBjYzBhb3ZZ?=
 =?utf-8?B?Ny9SUktHN0E3TG1rQ0lWajNQQkprbEFwOWR3WFJvZlJqVHZob3k2cWRPZFNW?=
 =?utf-8?B?b3FxNFAyVWI3UlpHQWpCOGpmOHJrK3FlbEpsR2VQOEdBZWZYRVlpQnFWdWRM?=
 =?utf-8?B?NDlzUWxndGtrWkVsY3FQWnVzRndXb3FsREk3Q1F2NjFURHV4TElNSittbS9R?=
 =?utf-8?B?bW5OOENjSlh0QzliZmlrNTJKVzQzaTArMFIwcmZmczMwNWN6N1JjNEYxbFZu?=
 =?utf-8?B?NGk2OVgzTG9QWlJRcy9aUW5HT3Z0QWhKT2lXeDAzWkQ5MThrWmhsVkJ0OU1J?=
 =?utf-8?B?bWs2bzFHWjYvam00RDN0Zi9qUDdtZEtwQXpzRzk1TTIxWmNvdGxyQWE4UXln?=
 =?utf-8?B?NVREcm5BYnF5eG4xYXBjRDFHUEFQNVh2UnlINlV1ejE0UzRONzByL09jdW82?=
 =?utf-8?B?bUNDS2dVbG5qOThQbGRCdVg2MmxZMHpyQjZZMXpFbnZwaWRvUHJ4aEppSSsv?=
 =?utf-8?B?RFd6T2FxSzd5bDVOeU5CYndJcC9rQTJTZHl5bnptN2RpQW9od3lRWURkUlBS?=
 =?utf-8?B?Lyt0VG5SWkI2T09tY0ZPYUdFRVptMjZhUmNmUmpOVFBnbGxZaFViRUxlaU56?=
 =?utf-8?B?ZDFkZC8raTZ3WFJTMDBLd29wZmRzTWs0S3BXU1ptd2g5eEtrV3EwUHdjZ1pL?=
 =?utf-8?B?M1JYRUVBaGVZbitBTzNUSHlyR0QyQkFCV3BGZ3JmNEIyb1JPdWx6cXBVeEJx?=
 =?utf-8?B?MXJhUkpvQU9iTmJ2RTZMTVY1eFJQeHcyOXF3NnhqTzdJbFdIUE55Y1JEUFJv?=
 =?utf-8?B?NlN5cEJTREZpRGhtRjcrUUY2SVZyZVFYR0FKMjBCcnlFWTNKbGVPNHpHOGRh?=
 =?utf-8?B?SDR4Qm1SVkp4M1VFc080VjJwei9waG9DbC8raUZZZlJ6NDBZVEtXZEEyRkgv?=
 =?utf-8?B?OWpuUUU5bTFIeVRQMkpnY05aaUx6TmN4OFJ3Zmo1L25mSXJtTVhYVlUraHZ5?=
 =?utf-8?B?dEE4aTdyM2x4WlFIeDUwcXViSzNKRGVBSWQxOUJIOWhPc0RSTVQxb1RrK1lm?=
 =?utf-8?B?eWs0anJMeUEzblM1RHpOcXZsdXkwSk94UzdzeDBwZVBiZjZmc3VaWVZNZ3Zn?=
 =?utf-8?B?WThjZVF5dWRlbE94R29wYnNaZ0M0a2FBZXdudklraVUzSW5lVDVadVpJbTI2?=
 =?utf-8?B?OFg3RHE2ZXBudkJtSXlwV3JVbTdWcThmL2dPSFYwUWo4bFY3L2tCemxNdW1U?=
 =?utf-8?B?Y2Y1cjhISStGSktZUTJVWHZEWHJ2Tm9IVENFUjlVbWt2TlJVcm4rbFlUVTJv?=
 =?utf-8?B?RmtNeXFJbTRsL3Z3SEJlbS9ta3RINytzbEZoeWh6c3hWNG1QVWxXM0FEMzVS?=
 =?utf-8?B?M1hQUFJJVStUVTF3UldZdDlxZ2pYU2tmQmllU0tXRVZ1UGsvWlRtUWJhVm9w?=
 =?utf-8?B?MlJidnEyUmhaenhWakJ5WS9kc2l1Vi9ITU1NaENyTGRQbzFialljT1FUNU5D?=
 =?utf-8?B?TW0xbHJQZUFOYjZHYWcveW82ZnNKVndlN0p5ZWVWTEtrTnN5Z3l4dmRUY1ZY?=
 =?utf-8?B?Y1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <257C5022F9A92D48B27ECFA4BEF95F33@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c85aab9d-0e98-4426-1632-08dace02fc76
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 10:02:24.7044
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V7JPkTfsCmSqI/oEdO+l6BaJwoJS0XR82HRzo/RvuBNaRjcTXQpJFkzEHhaJJPhVLp48rJUGh7gXGrFyuib/BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7506
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTExLTI0IGF0IDEwOjI2ICswMTAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gV2VkLCBOb3YgMjMsIDIwMjIgYXQgMDU6NTA6MzdQTSAtMDgwMCwgRGFuIFdpbGxpYW1z
IHdyb3RlOg0KPiANCj4gPiBhcmNoX2FkZF9tZW1vcnkoKSBkb2VzIG5vdCBhZGQgbWVtb3J5IHRv
IHRoZSBwYWdlIGFsbG9jYXRvci4gIEZvcg0KPiA+IGV4YW1wbGUsIG1lbXJlbWFwX3BhZ2VzKCkg
dXNlcyBhcmNoX2FkZF9tZW1vcnkoKSBhbmQgZXhwbGljaXRseSBkb2VzIG5vdA0KPiA+IHJlbGVh
c2UgdGhlIG1lbW9yeSB0byB0aGUgcGFnZSBhbGxvY2F0b3IuIFRoaXMgY2hlY2sgYmVsb25ncyBp
bg0KPiA+IGFkZF9tZW1vcnlfcmVzb3VyY2UoKSB0byBwcmV2ZW50IG5ldyBtZW1vcnkgdGhhdCB2
aW9sYXRlcyBURFggZnJvbSBiZWluZw0KPiA+IG9ubGluZWQuIEhvcGVmdWxseSB0aGVyZSBpcyBh
bHNvIGFuIG9wdGlvbiB0byBkaXNhYmxlIFREWCBmcm9tIHRoZQ0KPiA+IGtlcm5lbCBib290IGNv
bW1hbmQgbGluZSB0byByZWNvdmVyIG1lbW9yeS1ob3RwbHVnIHdpdGhvdXQgbmVlZGluZyB0bw0K
PiA+IGJvb3QgaW50byB0aGUgQklPUyB0byB0b2dnbGUgVERYLg0KPiANCj4gU28gSSd2ZSBiZWVu
IHB1c2hpbmcgZm9yIGFsbCB0aGlzIHRvIGVpdGhlciByZXF1aXJlOiB0ZHg9Zm9yY2Ugb24gdGhl
DQo+IGNtZGxpbmUgdG8gYm9vdC10aW1lIGVuYWJsZSwgb3IgZGVsYXkgYWxsIHRoZSBtZW1vcnkg
YWxsb2NhdGlvbiB0byB0aGUNCj4gZmlyc3QgS1ZNL1REWCBpbnN0YW5jZSBiZWluZyBjcmVhdGVk
Lg0KPiANCj4gVGhhdCBpcywgYnkgZGVmYXVsdCwgbm9uZSBvZiB0aGlzIGNydWQgc2hvdWxkIGV2
ZXIgdHJpZ2dlciBhbmQgY29uc3VtZQ0KPiBtZW1vcnkgaWYgeW91J3JlIG5vdCB1c2luZyBURFgg
KG1vc3Qgb2YgdXMgcmVhbGx5KS4NCj4gDQo+IChldmVyeSBtYWNoaW5lIEkgaGF2ZSBsb2FkcyBr
dm0ua28gdW5jb25kaXRpb25hbGx5IC0tIGV2ZW4gaWYgSSBuZXZlcg0KPiB1c2VyIEtWTSwgc28g
a3ZtLmtvIGxvYWQgdGltZSBpcyBub3QgYSB2YWxpZCBwb2ludCBpbiB0aW1lIHRvIGRvIFREWA0K
PiBlbmFibGVtZW50KS4NCj4gDQoNClRoYW5rcyBmb3IgaW5wdXQuICBJIGFtIGZpbmUgd2l0aCAn
dGR4PWZvcmNlJy4NCg0KQWx0aG91Z2gsIEknZCBsaWtlIHRvIHBvaW50IG91dCBLVk0gd2lsbCBo
YXZlIGEgbW9kdWxlIHBhcmFtZXRlciAnZW5hYmxlX3RkeCcuDQoNCkhpIERhdmUsIFNlYW4sIGRv
IHlvdSBoYXZlIGFueSBjb21tZW50cz8NCg==
