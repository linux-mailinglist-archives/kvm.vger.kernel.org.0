Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D74F6107FD
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 04:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbiJ1CbX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 22:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbiJ1CbU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 22:31:20 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0160A91856;
        Thu, 27 Oct 2022 19:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666924280; x=1698460280;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PGEkRpCOEYq4idHJ5OreKq9jpGeCHT5xXe/WHcJEZh4=;
  b=leDXuD3NTZDITVP9YShEwtQitTK3DaXjMOcXTFHmOvC2A3xVJtp+QKCp
   DoQsuacbIhyIHLy2arLVFSNkpKvp++m9fyzZ7leJ/dCm7BP5bIwE8wsDQ
   qLBHdSXktdvVNg+CxAL+16/ASJx7D5Alph4Qk++NxApdz9Ylhnp8aEVOE
   JIyzdDCVeulBmbSbnFsQdcgWvXVUua4ZZHbd+ZnERn6NLjzFgokaqRaC2
   5VyMUK/qZyWz1tf710Iq//HuXPyKaNBiis4OTPXEYVeXdkf0vHbcsAQSc
   sJyZM2kcm66CxA3NlP4U1r8k0A/8ngw8e8WbXjatPQ9IuQn28yx7AWS9F
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="307120640"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="307120640"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 19:31:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="610588732"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="610588732"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 27 Oct 2022 19:31:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 19:31:19 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 19:31:18 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 19:31:18 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 19:31:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8kYuVPcKUhOzvD/uCMheEWly/iQk8jB/owlpZqEgYUHW+kY1lrIsIPZ1eATYrSGN5+R56BEWtAvWmh2DCbvt8iDyRw1THAYiSFvkmKgqLLicynjGQVGSx5nQc4FMhixldqXHp4GBdU6PYpdIYBW0wSDSzgrKt29z44tn6nVK3dVKtR+4B2+QLfMlZflsv9usFofj9/voQ6hUG8e+uMbbFB2UCbPoTo3TBbVCbb+V3Edl8UsBCstfl/j84B+fHHnbif5rwWyhf8qQbQbUgjmenFmsjH7VJpdbea+Qn2D2NU4/Zz+BBF4EWaryyZu//mYh30fBDCHFpuICox57ggfLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PGEkRpCOEYq4idHJ5OreKq9jpGeCHT5xXe/WHcJEZh4=;
 b=i7tL01Ed/z3Z66o0CvFZc2eIMT3lrnT2O9zZDNq7GUdXF5Tdg20XEt2NwvXanbHIPXo4kwHZjxhHYRAPVcg61oKiIwwXK5OOurChWy/cpcfjAPdEvr57rQqhHPNAdrVYNgbJzbKkI4XKEZV5xOp2b4JYqH/YIVHTS/51NN3Ue6H584VgUhEH/AHRytL+ow1r9z+sUEh4ITf6yCYR24IkGQvoI0gOYJpXmT5c+Ij0DkN52+q/p+PGKxDle/0o78kwkB7COcDqzAgffALEVyJpi/EDz5XA09ZWUoLGyqWQbP2SN2KniRBNY0oj4sAUDDVjOHJkci70CA7ykgCBSNTwMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6393.namprd11.prod.outlook.com (2603:10b6:208:3ae::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Fri, 28 Oct
 2022 02:31:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::6eb:99bf:5c45:a94b%3]) with mapi id 15.20.5746.021; Fri, 28 Oct 2022
 02:31:12 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 21/21] Documentation/x86: Add documentation for TDX
 host support
Thread-Topic: [PATCH v6 21/21] Documentation/x86: Add documentation for TDX
 host support
Thread-Index: AQHY6Y2mdsF57Jg/xE+fOpfTsbg8Ta4iLtSAgADovgA=
Date:   Fri, 28 Oct 2022 02:31:11 +0000
Message-ID: <4c382e9983d577d4895257a606e5d03876cc82ff.camel@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
         <a3783eb87c0b3e652938dfd8714ed2fe93989c76.1666824663.git.kai.huang@intel.com>
         <b210d6f3-868c-9711-7703-1363dcd9269f@linux.intel.com>
In-Reply-To: <b210d6f3-868c-9711-7703-1363dcd9269f@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB6393:EE_
x-ms-office365-filtering-correlation-id: bd8588c1-5244-4a8b-efbf-08dab88c7aea
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +Zl+mPHohyiIyv431RftpE2hzJE54yoNzobhcMwtZGqgKy1kJ15sfyeLG2kddR8O/1hnMganAebizy1LmQZ75MNgsjtDObSzZgDkMziXPG3qV0bUqNAaSJekxq/fSSHs7SPdtP6JOtLcLxtl6oUiC45OEDCXMmMknHw3pnh7YX9XBmP6x5pjv3erbq+41g2hBe1c4L22WahRy904WatMcs5OSVF39BJqWEpoJwsjJEfllMF/aVwyKIg+KxTBtv31WZlzWv+btl+VW0h4GD6RyWHYptnh/G8K/xGOuUpHt5L33jrwWRQNB/6QXu2b+5nCnb5dZQfBvK98cqG0H3GVOHvlZ6ej3bTlmeXaRi03EMosckzTVHOPr385PuaNsp604w0ZAUnpClGguOmnbOuLdalOana3BkUYtfkJeB8+JNpRsi9KBsY98iRVjjL0jEIcLazThUTJjIQ9kYfkqBCGhuLUrYkOBUs7dafGDeyujeGp+z1pwR1DG5JWg239HAj67IuOTHTTPkLTyEERKmP/yjk48HUxm3UqlsdW4JBXnREPLnaF5WYjMvh4TM6bFgv3IlNx9hlAUXy+h5x4/ehpHw/vwQRlzMcoQ/pmtep+/w9turg4QlE7L+p3vWj4+O/wVxvEzJkkRif+yZZtHvEt4QsfmXThYuaik26C5MSDyV0+4WEfhEq7+b2tCKdl73+KR9YHzZuMwb9ArqfZqt9NOUUOzX6EAW7ggiuoyn9Rmh7LLkiaCNzogI9/gJJG7kv6WocolMHlE1iMFxnBzbfWiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(366004)(396003)(376002)(451199015)(54906003)(66946007)(64756008)(66476007)(8676002)(66556008)(86362001)(5660300002)(110136005)(4001150100001)(186003)(316002)(2906002)(82960400001)(76116006)(8936002)(91956017)(41300700001)(4326008)(66446008)(122000001)(38100700002)(478600001)(6486002)(71200400001)(38070700005)(2616005)(26005)(6506007)(6512007)(7416002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UHllMTBBM1FSUWQvZzJOQmJDWjJZcEFRaTI4SmRqUUF2RFVRbVZqbHJaUkxB?=
 =?utf-8?B?ZzhCZDM1dUR1M1dJL2YyOGRMOFVROUVKYjZjVmxjZTNCLzk1VnJwOEhmc2NR?=
 =?utf-8?B?NXFoVk04SjF6blBheUxiZkQvKzNPOTQzT0IvcHV2eDNtNmdJYis4Q1JGQkVG?=
 =?utf-8?B?TkVBTHlBNjU4bE83SmRZc2dKcmFhZlZLRXBSbnlTYnIrdFpRT000UUJwVGcz?=
 =?utf-8?B?emVVWFpNNUxnVzhkWEJFRmR3SzlyNVVlaHBsZzZucitQSDU0UkpjcFVCeUMz?=
 =?utf-8?B?MVllN3RFcHlrR1lvdUI1eVU5K2FyQ1cwVERGN1Q4VzRYWlE5SVlPZDBJeVJS?=
 =?utf-8?B?U0hQVHZNV2ZQVjFrUTJtYVhnKzdPNnNUNjErTEJzUjZLSEQvTGlMZjd2UzdD?=
 =?utf-8?B?dmt1cVZZRUFOeDFrM1dwSFc4ZXpWUEJYRk9jTGdrUHVoblZxQmsyM2w5Tmdi?=
 =?utf-8?B?R2swOThxK0dFNGVBM2czL2lqRkJtRzlvLytVMTlRVEU0MDlWVTdEcG94TzhI?=
 =?utf-8?B?bytiSktjL2RpcWxZOWtvK01ieUJGSWJWeHVUaDI4R2trRy9FcVA5QWVCa1Mr?=
 =?utf-8?B?dy9ZK2FLUFhVdzF5RFFibHlFMG5mZFhrbjN6S3UxcjRkZHJYeHBFV3lkVE5t?=
 =?utf-8?B?Lys0a2JrT0wzS1VjeU1wRU9mL2doYUJQZ3BuQ25WY0M1d0w5S01oQmRHVW5U?=
 =?utf-8?B?eGdjakhLbTBvbkt6S25PSjl4ZDl0RUNPVXh3MTBVenZvbC9uaDg1NGFrbFBZ?=
 =?utf-8?B?a04xcUhyVmUxa1pEWUFSN3R5bXRjeEZCQ1pEVUtpZ2RnSExZbU9HL1lsMDFC?=
 =?utf-8?B?MHBJZ1dzWGtqZDRvUlZMSnJjTklGUHRUem9ZOW9abEVMR1I0NlBZU1I0NUox?=
 =?utf-8?B?Mit3UjFNd0hpT2VLWUllU3l5a2JOYmk4c2YrNWx5K2tnZHQ0SUlQckxCb1VH?=
 =?utf-8?B?QWlQK3pmdE95MlhrNVVBUmVmd3ViR20zM2h4b01yUzVhSXRtMmc0QmxNM3BR?=
 =?utf-8?B?c0NIWUpXcWlhN2tlaFlNVW1PbEVyL0kyN0x1UkJsNHluVm1FbGgzRVREQ1Ja?=
 =?utf-8?B?VU9uUGJwM0ozZVR1c1ZTNk5MbEU4a0p5b084Z2ZSWDJkc0hnZXZtMy9Xb2xu?=
 =?utf-8?B?Q1hJR05sbmJUc1BxT2U3ZVFEN1VlRWxkN0M0UEpDbTU4QzFaTlRvZnBEQmZ0?=
 =?utf-8?B?NG9qaitudTJlanBabXJCb3BXSVhyM2NkQWVBUmhFclU4WmJWYzdMQzZCRjlJ?=
 =?utf-8?B?U3BraTh5aFJVTzc0cWJJOTk0UzJVRHFSSjFLTldEaFhEbExlSGh4ai9WUzhB?=
 =?utf-8?B?VEtVMXFNK1BLejRscVkzRVJSb3JhakZieE9mbzA3UkN3SmlSMXRFYnBYQmVD?=
 =?utf-8?B?KzNLZ0E5Q2hiUjh6N1EwWXpKTFp3WEo1VzA4Z05uWW42akU5WGlXVHhGNVJQ?=
 =?utf-8?B?SldZQlR6aGdoUy85Vk9MZkpFR2FGQmVwUVJjbDlRUjdxQlV3OWhoT1ZVdGFH?=
 =?utf-8?B?dUtCbWVuT2tiZUtuL3dkRU1UNkQyaVBMQ3VmYnc3bm5DRURpTVlsMERxRzM1?=
 =?utf-8?B?V0RxUk1pUXpsZktseDVWcXVQNGI2OFB4MlQzMU80V0l1cnNoZnNiVGRMM2U0?=
 =?utf-8?B?bG5ObjNyY1ordHNnOFk1bGJyVmR4UTlIZUdzUlcrdytaK1lraUhBRnY4S24y?=
 =?utf-8?B?U1U5WjlrYnpJT3dNZG9yNS81b0FqVnZkMzVWRm0rQ1BMcjdxa2R2bi82a2Ru?=
 =?utf-8?B?eUJ1SE5DU09RbEUvSVlYQjN4YkRuaVRSNnpDTnZWWnNQVGJ2NVM1SzFiQUhX?=
 =?utf-8?B?NGV6M1B0aFhUbEVVMlRjYThDVUJ2OEF6UnVhODgzMHJ0N0t2d2QrNWphdGx0?=
 =?utf-8?B?Q2pEUUF5cUV4VnU1QUpuSlJFN0NmdExYMU1rZHdhSVNWS0FuR1lTSzJqZ0cx?=
 =?utf-8?B?bkJLSk5JVkN3WFV5MVRjTTNzOU13Qk40WnphcGVrSXgzdzRQZ1k0ZnFOMlRF?=
 =?utf-8?B?Z1RMcG5lZVhoRWZ2VVdxSHZWakJhbndTMU1JcDFaWGR3WU9oSzh4QThpNlJO?=
 =?utf-8?B?ZFRMekpBSzR0NW5QVS9Zb0EwdTRVc09pZ3dsZjA5dC9peHNMRTFNaEU5Y1Zk?=
 =?utf-8?B?dFN2UmhxNEtqazljMGV2b0FlVXJybThiT1FWcDA5Y1RsMFJJTDRtZWc0UkZF?=
 =?utf-8?B?K1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B4BD316BBA3ED4F99781A393425B0A5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd8588c1-5244-4a8b-efbf-08dab88c7aea
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 02:31:12.3026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t5CwjFgDIAIBncAq9Elpk6Rch/tSo53BKT0bSZLp3K+Ymka1yg7qLsAKhW+sGHX0j1QYwKWCUbu6h/66rIYxiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6393
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIyLTEwLTI3IGF0IDA1OjM4IC0wNzAwLCBBbmRpIEtsZWVuIHdyb3RlOg0KPiA+
ICtUaGUgY3VycmVudCBpbXBsZW1lbnRhdGlvbiBkb2Vzbid0IGV4cGxpY2l0bHkgcHJldmVudCBh
ZGRpbmcgYW55IG5vbi1URFgNCj4gPiArbWVtb3J5IHRvIHN5c3RlbS13aWRlIG1lbW9yeSBwb29s
LCBidXQgZGVwZW5kcyBvbiB0aGUgbWFjaGluZSBvd25lciB0bw0KPiA+ICttYWtlIHN1cmUgc3Vj
aCBvcGVyYXRpb24gd29uJ3QgaGFwcGVuLsKgIEZvciBleGFtcGxlLCB0aGUgbWFjaGluZSBvd25l
cg0KPiA+ICtzaG91bGQgbmV2ZXIgcGx1ZyBhbnkgTlZESU1NIG9yIENYTCBtZW1vcnkgdG8gdGhl
IG1hY2hpbmUsIG9yIHVzZSBrbWVtDQo+ID4gK2RyaXZlciB0byBob3QtYWRkIGFueSB0byB0aGUg
Y29yZS1tbS4NCj4gDQo+IA0KPiBJIGFzc3VtZSB0aGF0IHdpbGwgYmUgZml4ZWQgaW4gc29tZSBm
b3JtLCBzbyBkb2Vzbid0IG5lZWQgdG8gYmUgaW4gdGhlIA0KPiBkb2N1bWVudGF0aW9uLg0KDQpC
YXNlZCBvbiB3ZSBuZWVkIHRvIGhhbmRsZSB0aGlzIGluIHNvbWUgd2F5IHNvIHllcyB0aGlzIHdp
bGwgZ28gYXdheS4NCg0KPiANCj4gDQo+ID4gKw0KPiA+ICtUbyBrZWVwIHRoaW5ncyBzaW1wbGUs
IHRoaXMgc2VyaWVzIGRvZXNuJ3QgaGFuZGxlIG1lbW9yeSBob3RwbHVnIGF0IGFsbCwNCj4gPiAr
YnV0IGRlcGVuZHMgb24gdGhlIG1hY2hpbmUgb3duZXIgdG8gbm90IGRvIGFueSBtZW1vcnkgaG90
cGx1ZyBvcGVyYXRpb24uDQo+ID4gK0ZvciBleGFtcGxlLCB0aGUgbWFjaGluZSBvd25lciBzaG91
bGQgbm90IHBsdWcgYW55IE5WRElNTSBvciBDWEwgbWVtb3J5DQo+ID4gK2ludG8gdGhlIG1hY2hp
bmUsIG9yIHVzZSBrbWVtIGRyaXZlciB0byBwbHVnIE5WRElNTSBvciBDWEwgbWVtb3J5IHRvIHRo
ZQ0KPiA+ICtjb3JlLW1tLg0KPiANCj4gDQo+IERpdG8uIERvY3VtZW50YXRpb24vKiBzaG91bGRu
J3QgY29udGFpbiB0ZW1wb3JhcnkgdGhpbmdzIGxpa2UgYSBjb21taXQgbG9nLg0KDQpPb3BzLiAg
SSBqdXN0IGNvcGllZCBmcm9tIHNvbWUgY29tbWl0IGxvZy4gIFRoYW5rcyBmb3IgY2F0Y2hpbmch
DQo=
