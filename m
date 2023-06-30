Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB71D7438BE
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 11:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbjF3Jzq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 05:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbjF3Jzk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 05:55:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB498173C;
        Fri, 30 Jun 2023 02:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688118938; x=1719654938;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=txAZTB9mu8KiFMHMxRd/SkAReJuYXX8iYaMt42FzxjA=;
  b=TUimfVfdBO2Jj9IRx1uA6WiWan3zUUYRcyLGEDItTRrlZ15Gd9FmVRRK
   f5Wj+dQH5jfap/lvBvlnVsDtaPhe3DxWp03ZH7t4eu+m05SxaWtoPgEuo
   fbkKz5OCAvsgBOgIl7SkczDg585dnQqdIAemFCz2Hy+U19MWzA6iJCpfF
   ftSiPZvSK8iyzSsYF9FQe4QYAnMeSMD4klXGslsGRUxII2YJ502t4TLo6
   2CUaPRXI7ayQXAo23VDKdMhKdqWKVHPeqwKUvq/Lwsh2FcxxXPle7sgb1
   3GcNkfFgbtAAlT6mVrx3vvAnY6tAlX9TPTeZL2InnYg4fHZ84Z+kL4x/q
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="393085941"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="393085941"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 02:55:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10756"; a="752941897"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="752941897"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 30 Jun 2023 02:55:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 02:55:37 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 02:55:36 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 02:55:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 02:55:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOpUlN4AGUMPoSf+G2r4+Xmoxw3ICJWNIhX7UWS7sMR+FnWktEcZrhbvxKKzjZII/fkB100stdFr7tm0AXxvMuok1RTbI51jE6ZowbRWigf2G3rh34E1ZOf4v+gRY1/aEC5LlB1jjuzSVMCVX0zdRoi7R4x7eCvbVtWxZRJcVWICq98efclHdOEw5yDuqdYzvGhqdx5WAIYk3PPQGuUsDtmJn2IXZw80eLHO/XTRaV8HJa8pg5+pQPdnVSQIBDV7pdp0sA/dt9fXH3Q+cembQJOAdBLO2131xMCDd3bia0xtHOtWRQA67sJ3fqdzZLoohUGIwoAMeKaxhqFVif/HGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txAZTB9mu8KiFMHMxRd/SkAReJuYXX8iYaMt42FzxjA=;
 b=W2W0/5996ToxKCk1W8TNqG/5FfKU+RtANhBTiNppNrsvDw028gul8pEiJx/vUj+H6ldz0XffD/cG/1QSmARdYtovMTGbCxNum5tQ/vvWNW/g17SViaXtvPM6wx6aqmklpM6fS39NjQuwQ/grabpMOCtlC8FcebtemQYpQKJjE22DT+R2SOTIXlUbwppW6R16bUCpoLhc9vvYX4c9WpMSuoP2R8Kz4Y2VtI+vHjcgLlDTFCL/HW3E0ppZ7IEX96+9NxYvcPkf1Ow4TIFCkVmru9tuK5DcuiXeSjbI2uv8oOJ7aes3uUyVKvr2X+dQbWM+GM4xs+GE+nueAA24a8q0YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB7702.namprd11.prod.outlook.com (2603:10b6:a03:4e2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 30 Jun
 2023 09:55:33 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Fri, 30 Jun 2023
 09:55:33 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Topic: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Thread-Index: AQHZqDWtW8hO2PRC3kCMr0lha9GzWK+gNU2AgAC2WwCAAi3CgIAACCuA
Date:   Fri, 30 Jun 2023 09:55:32 +0000
Message-ID: <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
         <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
         <20230628131717.GE2438817@hirez.programming.kicks-ass.net>
         <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
         <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
In-Reply-To: <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.3 (3.48.3-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB7702:EE_
x-ms-office365-filtering-correlation-id: 7b21490c-42a5-406f-fb0a-08db79502509
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NJbRKaaOs0S5t9uLTK+HtZoYtaN09UdDn1mjlw3ZJMIfN7Ee+lM1bC+/trN2j/xKY2VDDj1TxaG+YTKBGhqdUgnlBD+Qn2GV2hA3rnhJFfaaVPSXOHMcKdAomvMTVToFmGJuvUdBWVM+6FOaBV64SCCjBmrdKtxPOyI5cmFuq1qh4BlLssa8jr05/AebvxAfYHnaAUGkFKaPGqHx8eqYt4m/+kLtTxbGPVHHlZHwGuLypCQIH+mhVft1WxmzJ8R8SCYhTQbjf44Y0Lc7hfErmGC4G82N/Q/wnubVwpugiW8wfoUByVbvcE7Y+Qe/IFIWPmcUg94UEG5xQfMpRV01DKYN8PS0ksHZ0JNtPD9EQkxLlc4pL6vhz/GB8O1eFDwL7a6P7ld+GUORbghXYfeqt9aMTaK9M3eMzXPe4wamcsPm0M/bF6snSPX3vAHck6tF8CJga5nelbLvXN+vSEUu43XD1PENt8ThZ/HJgebEnyVdAGOhLt1tjnFylXK8U3ANpMmHPXMB8PIXhcqszL8JWu43nbGsfM79f9WL6VmQUgI7E1AkUf5VzzEn4yzjvarqbC1HOZZD/THuaJD09CCwyz2uN9Urf4649X049iVfixhpg7CTcYr4C8C8q8x9zli9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(376002)(136003)(346002)(39860400002)(451199021)(66446008)(36756003)(38070700005)(5660300002)(64756008)(7416002)(86362001)(91956017)(66476007)(66556008)(41300700001)(6916009)(122000001)(8676002)(316002)(76116006)(4326008)(8936002)(38100700002)(82960400001)(66946007)(2906002)(478600001)(6506007)(186003)(6512007)(26005)(2616005)(6486002)(83380400001)(71200400001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SWdTa0ptc3FQcDE5WlliaCt6R1MzVCs2MXRJakJUbElmUE9vdEZ0TGhocE5w?=
 =?utf-8?B?dnIvdjZFbUxXRHdVQ2swWVplL0UyR2ZWcXh2WlhOMndmcWs4a25QeUlRS0NB?=
 =?utf-8?B?RmFuRnRiL05ZN3A0bHV6S2Z1K0NuRjRac251elJRRjQwNGRrdW9VV1U3TlBL?=
 =?utf-8?B?VmZDaHFVSEpDZ2dma21yQzVKRUQzRFFVSXJIOGUxSCthVlo1c1l0VnVpT1k1?=
 =?utf-8?B?TmNtVUJyZlVkVkdyTkpZN1lRdnJ5MkZCS1dvVFBtcHI3bHhhYTYwdHVHNTNK?=
 =?utf-8?B?Tm4rQ1RpWG5zOEhpK3BoOXMwY1RiaXZIQldhanYyRll5YlQzMUxOLzlabVc1?=
 =?utf-8?B?aE1JajdjeHh6VFBKSjU0Y1czZXVPSlVWMkxlQ2htVDdwMzd6QXJ2Y3hyN2c3?=
 =?utf-8?B?ek1FVVN3RjZVOEl1WTNDQzR3MHQ0dVZQWmFlaWdjNUJjZGRwVDhJaERlb0pC?=
 =?utf-8?B?SzkwTWhzb3p3ZXdkTEpZNXc1bm5iWjZmT3Bkcnpxa0JCSFBxcVJXUk9TZHl1?=
 =?utf-8?B?bW8wTjdqSWVhcUVPN0l5SFJIbExhVnpGY2dPUjBOdGhxaHFIRjdVRVlmL1dW?=
 =?utf-8?B?SjMvaGFnYlhMaFFvemFVblZCY3dHUDh1cVlxR01yaUFOeEF2ajkxaTBueE5j?=
 =?utf-8?B?VUZhTmVtV05KRE1IQVdYNlU0YkdvM2VmZ0dRQWtSazVZbWVqQlRwOWt1dzk2?=
 =?utf-8?B?RFZWcmVNS0hPM2c3OU5pdThzODRIaVJNdmE0dnJtSmg3TWs1bHJwL2hQN2cx?=
 =?utf-8?B?dFlKemFIcFIxQ05yT0xkN1d4cC9xMnNyM0dua2hYSEVRaE9WUEdBNzJ2UHZH?=
 =?utf-8?B?NENKWm9BN0laWXNQWFlrS0VkemxFNDZjS3FNcnFVNlB5WWhIRDNJb0gwTkxj?=
 =?utf-8?B?c2dxYjVtOWQ5bVJCV3pkYkQ0M3ZvWkdtTnk1Z0NsN3RjdjBsbzYvWUNUYW8y?=
 =?utf-8?B?Mk9CVm5RYTBiZlFUeWFSWklkNE1iakZoYTE0b3g5NnJmSHVtb1Z0Q1NCQzl3?=
 =?utf-8?B?UVpwcEFKT0x3ZEo2WUJ0Yys3Z0tEcjFmZmg5cjFpanh4VVl5WkxoSDlDZWQw?=
 =?utf-8?B?SGRmb0poTVl4QUdqYUJBZXVxa2RpMWRDNVdaVHlqTkZPTnM2N3JDc3M1MzVp?=
 =?utf-8?B?YmFST0tKTWNwYW0wUHdNeWZ1MFVNMklCaHVmb1ZkMmFqaVFJMGdSYjljd3FH?=
 =?utf-8?B?WDZ5eUN3QjRzODgrUSt4VkN4UmREWGFqS0daMXJzOHZvU2tBRnVHQ2k0VWZE?=
 =?utf-8?B?eWdsdjN0V3czV2g3WUs1MU1WelU1dVJ4Qk43WWhxblBkUEEvcVRoUU1ReFJ6?=
 =?utf-8?B?YmxndThUaEJ0dFIyVDdnV1NITkJkSko1QkhrclpnNjdLU3hwcGNkUnVJS0Nt?=
 =?utf-8?B?cGo3Qy9idXl2YjR0UWFocWFkdkk1T0t2UXlQZi9LM1pIdjgxdkpocG5hdlZQ?=
 =?utf-8?B?MnNhdjdoQkUrRUxUVlJKZDJYL1JNTU04VWtqV2VXM1V2NVd5aGZaKy9XTGZ2?=
 =?utf-8?B?TG1EL3ZnN0pzWTk1dVh3Ri9lRFhXOTJvdWZKWVlVeG0xOVdubDM1T25BV1RC?=
 =?utf-8?B?T25tQm9vUWFJazB2dUhpUVhHM3JjY3NxeUpqMFBReGpIb3M1WFBOV08zcTBY?=
 =?utf-8?B?MmV5YzBLUmxEbSttbURzdC9lMW9uNmJockFpSzBDc0p1bDZwWVMrVVpiVEF0?=
 =?utf-8?B?Mit3bVZ3SzQ4UU5YMldvRjROR255NjdiemozWnBZOWZFY2pFMWhpTG1YVXVY?=
 =?utf-8?B?aW1zRDNUVTBWeVVGK3psV2kxQmpmZC9KVndiY0hvakcxcEZHYThPbGJ4WXZD?=
 =?utf-8?B?empUWEZYcXBjUnRRWkl4bitoRWR2SXdTdUZmQ2NvNWpYdTVTRDZOaFNNeVNt?=
 =?utf-8?B?NVM3VW1iWmhReW4xYi9jdFRtQlVCNGtLdjNPMHoxdWlpa3piSmJuSHFmUnA1?=
 =?utf-8?B?cUdlaUFJeFR2UEQwR0NSNnVWN2taR2ltdmFRV0JsYkY3YmhvN2g3ZlowMXFR?=
 =?utf-8?B?ZWlwU3kzOHNtVFFaN1JGR01ZUkRCRmRMcEVKKzZCeUpGUlZLWmdRVXB0d3Ir?=
 =?utf-8?B?RGlSRzdHWElGN01KdHpxeDhkbkJObVZaVnFHeHJUSGpPcTdTV2VNQnBGU2Ex?=
 =?utf-8?Q?jjwmWMVRMLRPRCNylZqpCPKAX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ED839DB68748584F9E3DDA61D2AAC436@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b21490c-42a5-406f-fb0a-08db79502509
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2023 09:55:32.8643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eGirnG1v6omFok/xhJp881CB5DvJq1N2G0/a9/6SpNCvrGX/O295006Yx8A718CrnM0GpdA/MOkrFJql9ajWiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7702
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA2LTMwIGF0IDExOjI2ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVGh1LCBKdW4gMjksIDIwMjMgYXQgMTI6MTA6MDBBTSArMDAwMCwgSHVhbmcsIEthaSB3
cm90ZToNCj4gPiBPbiBXZWQsIDIwMjMtMDYtMjggYXQgMTU6MTcgKzAyMDAsIFBldGVyIFppamxz
dHJhIHdyb3RlOg0KPiA+ID4gT24gVHVlLCBKdW4gMjcsIDIwMjMgYXQgMDI6MTI6MzdBTSArMTIw
MCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+ID4gPiArRVhQT1JUX1NZTUJPTF9HUEwodGR4X2NwdV9l
bmFibGUpOw0KPiA+ID4gDQo+ID4gPiBJIGNhbid0IGZpbmQgYSBzaW5nbGUgY2FsbGVyIG9mIHRo
aXMuLiB3aHkgaXMgdGhpcyBleHBvcnRlZD8NCj4gPiANCj4gPiBJdCdzIGZvciBLVk0gVERYIHBh
dGNoIHRvIHVzZSwgd2hpY2ggaXNuJ3QgaW4gdGhpcyBzZXJpZXMuDQo+ID4gDQo+ID4gSSdsbCBy
ZW1vdmUgdGhlIGV4cG9ydC4gIEtWTSBURFggc2VyaWVzIGNhbiBleHBvcnQgaXQuDQo+IA0KPiBG
YWlyIGVub3VnaDsgd2hlcmUgd2lsbCB0aGUgS1ZNIFREWCBzZXJpZXMgY2FsbCB0aGlzPyBFYXJs
aWVyIHRoZXJlIHdhcw0KPiB0YWxrIGFib3V0IGRvaW5nIGl0IGF0IGt2bSBtb2R1bGUgbG9hZCB0
aW1lIC0tIGJ1dCBJIG9iamVjdGVkIChhbmQgc3RpbGwNCj4gZG8gb2JqZWN0KSB0byB0aGF0Lg0K
PiANCj4gV2hhdCdzIHRoZSBjdXJyZW50IHBsYW4/DQo+IA0KDQpUaGUgZGlyZWN0aW9uIGlzIHN0
aWxsIGRvaW5nIGl0IGR1cmluZyBtb2R1bGUgbG9hZCAobm90IG15IHNlcmllcyBhbnl3YXkpLiAg
QnV0DQp0aGlzIGNhbiBiZSBhIHNlcGFyYXRlIGRpc2N1c3Npb24gd2l0aCBLVk0gbWFpbnRhaW5l
cnMgaW52b2x2ZWQuDQoNCkkgdW5kZXJzdGFuZCB5b3UgaGF2ZSBjb25jZXJuIHRoYXQgeW91IGRv
bid0IHdhbnQgdG8gaGF2ZSB0aGUgbWVtb3J5ICYgY3B1IHRpbWUNCndhc3RlZCBvbiBlbmFibGlu
ZyBURFggYnkgZGVmYXVsdC4gIEZvciB0aGF0IHdlIGNhbiBoYXZlIGEga2VybmVsIGNvbW1hbmQg
bGluZQ0KdG8gZGlzYWJsZSBURFggb25jZSBmb3IgYWxsICh3ZSBjYW4gZXZlbiBtYWtlIGl0IGRl
ZmF1bHQpLiAgSXQncyBqdXN0IG5vdCBpbg0KdGhpcyBpbml0aWFsIFREWCBzdXBwb3J0IHNlcmll
cyBidXQgSSdsbCBzZW5kIG9uZSBvbmNlIHRoaXMgaW5pdGlhbCBzdXBwb3J0IGlzDQpkb25lLCBh
cyBtZW50aW9uZWQgaW4gdGhlIGNvdmVyIGxldHRlciBvZiB0aGUgcHJldmlvdXMgdmVyc2lvbiAo
c2FkbHkgSSByZW1vdmVkDQp0aGlzIHBhcmFncmFwaCBmb3IgdGhlIHNha2Ugb2YgbWFraW5nIHRo
ZSBjb3ZlciBsZXR0ZXIgc2hvcnRlcik6DQoNCiINCkFsc28sIHRoZSBwYXRjaCB0byBhZGQgdGhl
IG5ldyBrZXJuZWwgY29tbGluZSB0ZHg9ImZvcmNlIiBpc24ndCBpbmNsdWRlZA0KaW4gdGhpcyBp
bml0aWFsIHZlcnNpb24sIGFzIERhdmUgc3VnZ2VzdGVkIGl0IGlzbid0IG1hbmRhdG9yeS4gIEJ1
dCBJDQp3aWxsIGFkZCBvbmUgb25jZSB0aGlzIGluaXRpYWwgdmVyc2lvbiBnZXRzIG1lcmdlZC4N
CiINCg0KQWxzbywgS1ZNIHdpbGwgaGF2ZSBhIG1vZHVsZSBwYXJhbWV0ZXIgJ2VuYWJsZV90ZHgn
LiAgSSBhbSBob3BpbmcgdGhpcyBjb3VsZA0KcmVkdWNlIHlvdXIgY29uY2VybiB0b28uDQoNCg==
