Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4DA5697099
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 23:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbjBNWSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 17:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbjBNWR6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 17:17:58 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9996659CC;
        Tue, 14 Feb 2023 14:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676413075; x=1707949075;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6fiVfe9diwtOAMDgblekocczzvzK00CfjzEnV5hv0bs=;
  b=bmj1m2ojeH+X8zV/gi4pa81N8v5LvVDo8YrshwxQWOlMAGiz042Jy0r/
   sLUxeC9GVFvzQ62NbXFhaeyjP6Oec3hroUo06CFGkQI0Ftjlgif3l+YVP
   c+l0CpR3EFNut9mQJePYqHwaynVrMz5ZaHUNZ6JJAa7B79AF0hhXSuMBO
   uvIwsNh5ohg/K9uCQ4FF3sSMEID0GWPdyvTroKyBvwKigwdRbQbQ2ougl
   pTXqbymP0zNV4imBvz4i2RVRaSCNl4zygKrLpxNvRczG6aPP+GEVjT8NG
   Eo6969JKSgFyWmdPbd7XqlKd19C2OZKuAiCqvbWt/qSLCXCOAyXv80ihj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="332595120"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="332595120"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 14:17:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="733037487"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="733037487"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 14 Feb 2023 14:17:54 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 14:17:54 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 14:17:53 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 14:17:53 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 14:17:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SnnTgZG5v6CSFdN6aAZVWgrDr9Ssqa3HPp0LANmurTnMZY0MKLMa8SPd6GoLw1cWKNvgOXYUrNj6PODM5tjFePkwxjWXsW514MEkBrfZPnB97duNZM3dRKxkteXItqdtLdeIB3dG8uDbgYQk+HgbwjJG2K0XW8t/d/Xl8YeX22m1X8OQuH+CDx7kBF74hIQWLe6IN6fDGzYU/HmyPmnTqJNd0ycHcQeaR9FILtQOMg6XdcAbE2FJAl8LFDlqAUSrPtTjGVkMsXa1wqkHMkD2wEDM4UIGhu0fkkRI0EHPdcHJF4K6GaPpe1j8yz+2U+daV4A7fxPMatBr+SpGux193w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6fiVfe9diwtOAMDgblekocczzvzK00CfjzEnV5hv0bs=;
 b=gb60bTodCmRcT+8uOYzKuaQ62zs5lg5Wc2PZyeVxsR8oBFDxpBrAFv0nmITX71OUrBhD4I+2QSLH27tVzAKdZnuYuZwO+0aJpahDdRtTNloSmID8/Yv9wmuOXP3iUHh7zgoDh3AF/T6WRe0JDUfjqj1gxAnJJMxZ86ViQlWKkFZ2GpkL2BVRy3l1M+mcRdmeGQe9Gp5QyOSwtQna5a02uC8ssa0dsEApgJVNWtio9/uhbQ2/stQCC0Z549vZt0ooNvDRl/AgOlE/Wlhlrk/IJveqwloaP+ddAtwIUWRskj0YGJjVpWFWXiOwCVpqrluoBw5SbHr1V31muEUNhMiRzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB5824.namprd11.prod.outlook.com (2603:10b6:303:187::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Tue, 14 Feb
 2023 22:17:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3f19:b226:ebf1:b04a%7]) with mapi id 15.20.6086.026; Tue, 14 Feb 2023
 22:17:46 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v9 05/18] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Topic: [PATCH v9 05/18] x86/virt/tdx: Add SEAMCALL infrastructure
Thread-Index: AQHZP5usrWInYEMBIEu01+xNPQ5Ox67NeMUAgAAMHICAAKC7gIAAjngAgABRBYA=
Date:   Tue, 14 Feb 2023 22:17:46 +0000
Message-ID: <e06853c48d7dcb6aa44ce88a23fbe650f01ae8c0.camel@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
         <dd18d6b42768e0107d212fdebedae92cfd72cfe1.1676286526.git.kai.huang@intel.com>
         <37d5736e-93b1-aed1-c21c-07fe1044f2d0@intel.com>
         <f834ed91cba9fb7b14810fcc8ba0ae68b9b0e2d0.camel@intel.com>
         <16470ac19325d99947bad3d4b16f6982b0facafc.camel@intel.com>
         <5f29c397-d723-a18e-e0f0-660f9f22d998@intel.com>
In-Reply-To: <5f29c397-d723-a18e-e0f0-660f9f22d998@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB5824:EE_
x-ms-office365-filtering-correlation-id: 320c1af6-3522-431a-0f94-08db0ed94d01
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QhNvh7B+hg7xPzO79f1iHcZ57gPQQMOcmu1X73Nfu9SflJVIVZPFmtJAe5Q4j6VY08tZDIPIdAv4rYhnMNuU+QtO/hmDdwo4c0axKxiKj2OE+JzV8xJCoBXJ/MmZCJt6QH+AT13Q0ktKD3BikXtHuseY/JDrfWPLrRd9l3WjtDuh5KjT3+WN9boJFBRHnljnr5vu5L4P/JLdwlEE9EpJ8DTSMnCuFtwNydj93/VZRnJ2tKqRnMC9l8H6ouMcwa4g3Ng8Pp9lItAfQNuG9R+cFXD5HfcxwQZCLGAtuXXR6oKS4Lep0GjOuk4FEqrPyxRUXZNO1FpFI/aUzuiK3RdmS0Eqzb0/Jfgr5xD8EkEjDzsIz3whtOcJGVU3tAwKP7sfPCT9AFwcTNHwAPtOMHNCInjudm0AXtaNP7WxORnd+vJvGwIpGf7juDZiz3lzwqU7r0jVGT1bBqjbOZ/KlhnYZLgnYShWNWlygg2hFpNOPySMuCvK88e64hAm2v5oJFBVMIWF5EmZJnMb3BKhrW6rZ+0N6uU9zuXZIfyFsq2DwrRetqTJvNx1kMFFAzDZd6k/whxTpnEMuiDrqGBfTAdeAwEZXHKq6Rxp9F2VQMwwK4Ro0MnTN+GKqiJfZ721ur3ZCUIcyxX50s5fwbsSiyzCQwS8GpgUAc8btgtYi+z6w0CLbw2kkj5bRa+x6vMVf1oj/Z3FV8BNNtQcCUhLOuTN/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(396003)(136003)(346002)(376002)(451199018)(86362001)(54906003)(38070700005)(110136005)(316002)(2616005)(6486002)(66446008)(186003)(6512007)(26005)(64756008)(2906002)(66476007)(66556008)(41300700001)(5660300002)(6506007)(53546011)(478600001)(71200400001)(36756003)(8676002)(38100700002)(66946007)(83380400001)(7416002)(8936002)(91956017)(4326008)(122000001)(76116006)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2dNQm5VczVoZGplZURQZHRBMU1vaVNnQzF5aU4xeld6V2dLN3VMNVZ1TWRV?=
 =?utf-8?B?Ry9zdE9WekYxWkV2ZHRCRXVkOGNEWkQ3aWVUYUJvUVMwVHA4RGN1L0N2VERy?=
 =?utf-8?B?dDVUTEJKRWNlVmVQd2x2MVZjQ3FkbDBtSkJIWWpjQmw4WnJteEM2cVJEek5C?=
 =?utf-8?B?Vm9NcUlXMUJBRmQ1bERESFVub1Y1SzVIa243NnZoRitiU2prZ21NY21hQkRJ?=
 =?utf-8?B?N09sUnM5M2RyUGdLc2JWMzNPdnpFdWw2enlhdUFoaGQ2SUFyN0tkTEZEcWtG?=
 =?utf-8?B?bDVYRWp1OTBSS1FNT2VyUnh6MGRWSGRCR3VHeFZzZWo0NUgzYURCNElVekZk?=
 =?utf-8?B?Y3BQYWFBb1YxU3ZRcnZPZkhZMmd6Z3FkU3dlOEtIUW1Ccm1ZemJid210MGds?=
 =?utf-8?B?NUZUcGVNMEs0SEJzMHRZYU1BbW9VaDFKeHQ5Z3BLZkh4WXhBc2JVMExQdlhi?=
 =?utf-8?B?T2N4NHRuOUNMS0UrMTgxd282ZDRyUzhJY3JPQkdJZTBXMnhaQlZiaDVVQVhN?=
 =?utf-8?B?YUo0YVd6YVRWVkdQREh0UVFJY0V2WmhXZGhOS0sySmpQRjBMZU5uSlA1eTA2?=
 =?utf-8?B?NjlPVHNIMjVWSUVvbVZpZXpKeU5COUJZc3I0NUdPcE5IY3FmdHduRVM5MjBm?=
 =?utf-8?B?UmRpZHhVcG5CSExiYWxaWkhITml2MENnTUNhaUg3Q1B0cEllazZCTzFDZytu?=
 =?utf-8?B?M1hoeDNxaks2MlVnQlQrSzhXVUtqdEJYMjRpUUx1SVZlWDgvajFVVTFPMU5Q?=
 =?utf-8?B?Y3NndHd6VXlzN2JSTGFEUm1ZNUl3RWtQck00K0lGM2dTSUREbGFSQ3k0YUJw?=
 =?utf-8?B?QWY1M0p2YTVYdzJRQnpBZ1p0UWkvV0dmRkUvQ1ppT0lPYVRKb2kvVEl5cjRw?=
 =?utf-8?B?MmNaS3U5SVB2LzBjemtROWVMRWdUaXhnU3Y3NUV5dm9OdUpoVVh4UjA5WE5V?=
 =?utf-8?B?cDRkQUpyeFl3RzF6aGRSOFEwL0tuRHJPUW5DZGdWWlAvSHNFYzhaOEJrNDVt?=
 =?utf-8?B?NkZrUDJpaEVGbWVSSHJlb3BhaCtaY3ZIbU9rLzZhYlUwYnBoMW4vbEdRQ3Fa?=
 =?utf-8?B?aVJ1bzFsNlNvOXVnOWVUMzlFRFFWWmh0b2NLWWt2WFlTNEczWmMyUXVNL21p?=
 =?utf-8?B?M2NVUU9Ucm5CQ2FQZDJHdTZOQ2cwaHRISXorcnRobEZWTlBNRlB0bVlOOGxm?=
 =?utf-8?B?NXVBQ0tMNjJGQ0JBZ2hwaEtRSGlyb0VRUzhjUVVDVElVc3YvbzJxMlZyZE41?=
 =?utf-8?B?eTVQSURhdHRQMUVPYU4zZXlaOFJWQkNndGpLQnJVMWt3MFo3NlZhenQwUmdM?=
 =?utf-8?B?RVV3OFVGNUZMWll2NUIxUFBEUGtGL21uckJpUnlqV3gvYStCc0o5STNIcTFk?=
 =?utf-8?B?b2J0RGg3UEs1eWlaRFg0M3V1UjNqcy90b3Jjd1VVQWtYMVBXVVFkMlQ5K05r?=
 =?utf-8?B?bkNLeXhRTnpEcE5hY3RBZkhUVWNZNVlyTkJ3NWQ0QStzNGVoMmYrZDdCUVVp?=
 =?utf-8?B?UkUvbThzU0RqWmhXWVovTlVhVGhvNEZCcTBZRkkwSE9mb0VoMjRzMlI1Umkv?=
 =?utf-8?B?UFV2RnBqem4vOXNlQjdUSXBCTld5RWFHTFBCVnpyWnVkdXh6ako2d1pjR0M2?=
 =?utf-8?B?QldpNmpMT2R1Y2hFNUxFVndHUjVsQnpNTnZWQW84bElPRUlRZHA3NHhqb1pF?=
 =?utf-8?B?VzFBOTkyODM2ZVgzd01KWllvOUtWaGh4S3hmeHdTYWZqNVBUQjVEa2pTblZi?=
 =?utf-8?B?RzhYbitTTkhpeGt1dCtkWEtPRWR0OG5mR3lZcWNjTlRKczlsNDVlZytBZ3JJ?=
 =?utf-8?B?bURUMDNib2J6VE5VdGhscG9jR2E3S1lTVVJ5WEcweXdVVTZxVklmY1lQQ1Z1?=
 =?utf-8?B?OWdIS3RFMFI1V3I4dktVZU5HRU9ueDR1c0xjZklQRUNBZFJOU25LMTBSdGlq?=
 =?utf-8?B?RlpaVXdzaGQ2b2ZlNGd0eUhJZlZnQXhDamZ5cXVabzlhYmd3V1FDOWhDYXZo?=
 =?utf-8?B?NHBRZHNjYnRRVEwvUms5dUVFc3ZGT2JNdk50Mk1UakNXcHptU0NWdC9TZzhQ?=
 =?utf-8?B?YnltWXREWUZiQ3lCWnUxZWJmL2ZqQW4vZzVBZHdVQ3RpMEttcENqbEc2MUlN?=
 =?utf-8?B?UjkvaUhvUXBDTGtWVER6Q2tOU05va3lPNHZnb3RSVVZ0QjNzdkFyYW1DUlJL?=
 =?utf-8?B?Snc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA80ECB99E40F74C918087ECF8669327@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 320c1af6-3522-431a-0f94-08db0ed94d01
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 22:17:46.5351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BDSMHGzdqT2VV5NM4iJq4XGrRT9jGAOTjnM7zolw7q6auxko0c3tLLZtmRbH0wapnyhwg39+6ZtuaFJvNlZUWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5824
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTAyLTE0IGF0IDA5OjI3IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMi8xNC8yMyAwMDo1NywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBDb25zaWRlciB0aGlzIGNh
c2U6DQo+ID4gDQo+ID4gICAgICAgICAxKSBLVk0gZG9lcyBWTVhPTiBmb3IgYWxsIG9ubGluZSBj
cHVzIChhIFZNIGNyZWF0ZWQpDQo+ID4gICAgICAgICAyKSBBbm90aGVyIGtlcm5lbCBjb21wb25l
bnQgaXMgY2FsbGluZyB0ZHhfZW5hYmxlKCkNCj4gPiAgICAgICAgIDMpIEtWTSBkb2VzIFZNWE9G
RiBmb3IgYWxsIG9ubGluZSBjcHVzIChsYXN0IFZNIGlzIGRlc3Ryb3llZCkNCj4gDQo+IERvY3Rv
ciwgaXQgaHVydHMgd2hlbiBJLi4uDQo+IA0KPiBUaGVuIGxldCdzIGp1c3QgY2FsbCB0ZHhfZW5h
YmxlKCkgZnJvbSBvdGhlciBrZXJuZWwgY29tcG9uZW50cy4NCj4gDQo+IEthaSwgSSdtIHdvcnJp
ZWQgdGhhdCB0aGlzIGlzLCBhZ2FpbiwgbWFraW5nIHRoaW5ncyBtb3JlIGNvbXBsaWNhdGVkDQo+
IHRoYW4gdGhleSBoYXZlIHRvIGJlLg0KDQpUaGUgaGFuZGxpbmcgb2YgI1VELyNHUCBpdHNlbGYg
b25seSB0YWtlcyB+MTAgTG9DLiAgQWxsIHRob3NlIGNvbXBsaWNhdGVkIGxvZ2ljDQpjb21lcyBm
cm9tIHdlIGRlcGVuZCBvbiBjYWxsZXIgb2YgVERYIHRvIGVuc3VyZSBWTVhPTiBoYXMgYmVlbiBk
b25lLg0KDQpBRkFJQ1Qgd2UgaGF2ZSBiZWxvdyBvcHRpb25zOg0KDQoxKSBEb24ndCBzdXBwb3J0
IFZNWE9OIGluIHRoZSBjb3JlLWtlcm5lbCwgdGhlbiAgDQogIDEuYSBIYW5kbGUgI1VELyNHUCBp
biBhc3NlbWJseSBhcyBzaG93biBpbiB0aGlzIHBhdGNoOyBPcg0KICAxLmIgRGlzYWJsZSBpbnRl
cnJ1cHQgZnJvbSBDUjQuVk1YRSBjaGVjayB1bnRpbCBTRUFNQ0FMTCBpcyBkb25lIGluwqANCiAg
ICAgIHNlYW1jYWxsKCkuDQoNCjIpIExldCdzIHN1cHBvcnQgVk1YT04gaW4gdGhlIGNvcmUta2Vy
bmVsIChieSBtb3ZpbmcgVk1YT04gZnJvbSBLVk0gdG8gdGhlIGNvcmUtDQp4ODYpLCB0aGVuIHdl
IGdldCByaWQgb2YgYWxsIGFib3ZlLiAgV2UgZXhwbGljaXRseSBkbyBWTVhPTiAoaWYgaGF2ZW4n
dCBkb25lKQ0KaW5zaWRlIHRkeF9lbmFibGUoKSB0byBtYWtlICBzdXJlIFNFQU1DQUxMIGRvZXNu
J3QgY2F1c2UgI1VELiAgTm8gI1VELyNHUA0KaGFuZGxpbmcgaXMgbmVlZGVkIGluIGFzc2VtYmx5
LiAgTm8gaW50ZXJydXB0IGRpc2FibGUgaW4gc2VhbWNhbGwoKS4NCg0KKHdlbGwgI0dQIGNhbiB0
aGVvcmV0aWNhbGx5IHN0aWxsIGhhcHBlbiBpZiBCSU9TIGlzIGJ1Z2d5LCB3ZSBjYW4ga2VlcCBh
c3NlbWJseQ0KY29kZSBjaGFuZ2UgaWYgaXQncyBiZXR0ZXIgLS0ganVzdCB+MTAgTG9DKS4gDQoN
ClN1cHBvcnRpbmcgVk1YT04gaW4gdGhlIGNvcmUta2VybmVsIGFsc28gaGFzIG90aGVyIGFkdmFu
dGFnZXM6DQoNCjEpIFdlIGNhbiBnZXQgcmlkIG9mIHRoZSBsb2dpYyB0byBhbHdheXMgdHJ5IHRv
IGRvIExQLklOSVQgZm9yIGFsbCBvbmxpbmUgY3B1cy4NCkxQLklOSVQgY2FuIGp1c3QgYmUgZG9u
ZTogYSkgZHVyaW5nIG1vZHVsZSBpbml0aWFsaXphdGlvbjsgYikgaW4gVERYIENQVSBob3RwbHVn
DQpjYWxsYmFjay4NCg0KMikgVGhlIFREWCBDUFUgaG90cGx1ZyBjYWxsYmFjayBjYW4ganVzdCBk
byBWTVhPTiBhbmQgTFAuSU5JVC4gIE5vIENSNC5WTVhFDQpjaGVjayBpcyBuZWVkZWQuICBBbmQg
aXQgY2FuIGJlIHB1dCBiZWZvcmUgS1ZNIChhbGwgVERYIHVzZXJzKScgaG90cGx1Zw0KY2FsbGJh
Y2suDQoNClRoZSBkb3duc2lkZSBvZiBzdXBwb3J0aW5nIFZNWE9OIHRvIHRoZSBjb3JlLWtlcm5l
bDoNCg0KMSkgTmVlZCBwYXRjaChlcykgdG8gY2hhbmdlIEtWTSwgc28gdGhvc2UgcGF0Y2hlcyBu
ZWVkIHRvIGJlIHJldmlld2VkIGJ5IEtWTQ0KbWFpbnRhaW5lcnMuDQoyKSBObyBvdGhlciBjb25z
Lg0KDQpMb2dpY2FsbHksIHN1cHBvcnRpbmcgVk1YT04gaW4gdGhlIGNvcmUta2VybmVsIG1ha2Vz
IHRoaW5ncyBzaW1wbGUuICBBbmQgbG9uZy0NCnRlcm1seSwgSSBfdGhpbmtfIHdlIHdpbGwgbmVl
ZCBpdCB0byBzdXBwb3J0IGZ1dHVyZSBURFggZmVhdHVyZXMuDQoNClRoZSBlZmZvcnQgdG8gc3Vw
cG9ydCBWTVhPTiBpbiB0aGUgY29yZS1rZXJuZWwgd291bGQgYmUgfjMwMCBMT0MuICBJIGNhbiBh
bHJlYWR5DQp1dGlsaXplIHNvbWUgb2xkIHBhdGNoZXMsIGJ1dCBuZWVkIHRvIHBvbGlzaCB0aG9z
ZSBwYXRjaGVzIGFuZCBkbyBzb21lIHRlc3QuDQoNCldoYXQncyB5b3VyIHRoaW5raW5nPw0KDQo=
