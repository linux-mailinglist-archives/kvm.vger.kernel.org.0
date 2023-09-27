Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57CDA7AF9F9
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 07:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjI0FVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 01:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjI0FUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 01:20:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863F57287;
        Tue, 26 Sep 2023 22:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695791750; x=1727327750;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4BNSzxsrwpMS4BgNXvVndRoaECTZh36FogVc34hU2DY=;
  b=SpJq5BBie5OAflXMdQ5Jl6qrmF/tvqajrpMc1m54lXQrhFO7xw1B9XPq
   M9/C0dNN0a2R0I2rVubitHaB3Lyc2fk/W5dH7MNoonUv4l91ElXHxD4nY
   x/Jnh5mPdRMJK2zSC01/3Uco7YLwbIS46b6p4MvgK1L0SaF6294xLKIXB
   b1kmnIdjMp40lESx0psOLQlIaoeyEo6U4r1804SCU2mVsZaaubdV6Vqb3
   26V4NIq18k+JJf5pxx+sf3KE1IYRxYDHUTJmWXkv45OIW0KGZ22/88lKF
   NFMaNSbaJIUNjdQG7wxE0gxWTrFo7/h7Lba5rn57K3DnZTAkaMsRBWZWk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="381632959"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="381632959"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 22:15:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="839286745"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="839286745"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Sep 2023 22:15:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 26 Sep 2023 22:15:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 26 Sep 2023 22:15:49 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 26 Sep 2023 22:15:49 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 26 Sep 2023 22:15:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZQ4ikI8ruAZPEg4n7mKDC2vJEmeiIsBfQKzRvp/hCqmSJfzpV7lSf2Z/4rpOY+j3EVq+czlOt0EA6DbHDqCxSf5tqDf1maavs8boQvc9Uu16WStvMpYS6JgamPTvEFwITE5vK/iK2tTFFRTe30Q6zEdFzjgSvAkKOq91PXuyZuGBBozHspOBMi6M0V9/auQlrCWPRXqCwzVKM2txeKikbmrH4dG6ckZgymfDWTfMvyjVcNOcJw7BprCVoemDk+rRo0NXI939bfYL+1abEjiK7ceLTcd1BC9CHh3vfVmODZJi8XaKJwKQw6pdBdXEC6UnFXCTLltRiTIPS4rqYLqoVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4BNSzxsrwpMS4BgNXvVndRoaECTZh36FogVc34hU2DY=;
 b=Wq9EHWe2hS3ziuVlK6j5HjNySTlIV6AMEhOPXgLxMJv662j0TL4kPUzYAhT75tygZVSXgsrRWMRid+k28g4X2hZws0u0PCYOKf1Dm/+xPApXQNyoVwAtc1t3qfxjKlZ2obYRTf5HxnI5yPJCG1G416u8+T9hR0tRiM9S6Q5IeU3iWNnj8Mu/XVSaFgt48gR7w5adLEtXZ6/pdnC5R6iHf983dgWMuyTkjAwjRXX45jb7v1fvudFdfeD4xe3H7Yb9xfxNBy06nArhpdZaLe5RvpwLf/bY/YSx2MNrASjLBJSO2bxMlcuoMhifnNKT6EWsUnmsyGqZBgH5WP6Paszo+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CH3PR11MB8705.namprd11.prod.outlook.com (2603:10b6:610:1cc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.21; Wed, 27 Sep
 2023 05:15:40 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61%6]) with mapi id 15.20.6813.017; Wed, 27 Sep 2023
 05:15:40 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        Nikolay Borisov <nik.borisov@suse.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>
Subject: RE: [PATCH v11 05/37] x86/trapnr: Add event type macros to
 <asm/trapnr.h>
Thread-Topic: [PATCH v11 05/37] x86/trapnr: Add event type macros to
 <asm/trapnr.h>
Thread-Index: AQHZ7gZyHDaIF1QhlEKbn4wr9Yc91LAsxeCAgAAVJICAAUuagA==
Date:   Wed, 27 Sep 2023 05:15:20 +0000
Message-ID: <SA1PR11MB673482336F1F1C7C68EAD320A8C2A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230923094212.26520-1-xin3.li@intel.com>
 <20230923094212.26520-6-xin3.li@intel.com>
 <7acd7bb3-0406-4fd9-8396-835bfd951d87@suse.com>
 <6e0064bc-65c1-24f5-c29d-c1d1c027e2d3@citrix.com>
In-Reply-To: <6e0064bc-65c1-24f5-c29d-c1d1c027e2d3@citrix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CH3PR11MB8705:EE_
x-ms-office365-filtering-correlation-id: 1d84010b-46be-4d7a-b312-08dbbf18bf0d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IWEQzXCsAIpHh+lpoJ5yWBwwdvqZcIyutbifH/3lNvEnp16+usPlEvVI6V4XtOZwGZLiZc+OxdnX6eyhSA/CEXzbqlCYp09sXJizGDYQPNbtyqK9UBCdviXVLUVpeb3ejRGrR+FkPC3pKmBfqGWqzav2M+0RzcQUQ8vwoBXbOdkYG2MJVHdwhErbUsKtqgcgII+UYR40pYOaA/f/gi0oII1JeeUhyiwIrqvc50z4REirORjgxhSRP1jkNnrdfyvyh/MWXXmeXqzcx1MUoi5LDQ2vPOZsFZJ5esyraj6cNspLCABFoyhhzuLJTXJ79Vba9HH1ZIunppMrmtAjX3J6i0+kN21nWllFk5XorH5WkayLgcPiOnHr5KVpLzp9wxXRFE6mIjlRcRMpEzFH4lcsKTTeIYkJMics1dbGrdaxegHnsQ4QVYJMUzd/+Tlw/8vLVf8MLm07ZtoN5/nN5ZXkOcJ6VAnddwks7o7N4t0kPuqisQbuRihw3uQ/JG9tR8v5KJJE88ZhpptwkkDuSa3YC/zRCSJxJmECaTo5PHF5DwCH7ev7r+3Z2MTyPAE7DR4ZzaPRA9z2+xZbKkBjQIZLs9ej2Pcy17014O/xxRaBm2NXacISxbIg194pXjw0bENl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(376002)(366004)(396003)(136003)(230922051799003)(1800799009)(186009)(451199024)(110136005)(54906003)(55016003)(9686003)(66446008)(316002)(38100700002)(122000001)(66946007)(38070700005)(66476007)(64756008)(71200400001)(41300700001)(66556008)(478600001)(26005)(7696005)(6506007)(6666004)(82960400001)(7416002)(2906002)(76116006)(4744005)(33656002)(86362001)(4326008)(8936002)(52536014)(5660300002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TC9Pb3krV0czMEgzaGVXMzYvNUFkTkZiZzVBd2ExVE9BTDRaVnk2c3M5RmF6?=
 =?utf-8?B?ZXN1Z2VtVFEvcStQb2Q3Z0p2eUUzS2Q0YkMwanVTTUoyQXlGTWtWb08yemZu?=
 =?utf-8?B?cEs2cUlCTm1sL1hpdEdMSWl3bzNoYnFFRGZJaXkzbTZRc0MzenVERHZHbkRL?=
 =?utf-8?B?d1IwaFNRM00xMVdsc0IvOHhZVkFub2N2Qkw5b1ZiL2RTb05wY1h0ajFpdDdD?=
 =?utf-8?B?VHRFanlqQXkrRmFSZk92UWg3dVAxODg5RGpaSlBUM2JWRER5Nm15c3pHRUlm?=
 =?utf-8?B?cVNxY2xpMmNlL3d0c2VIaHhNVGp1V2tNS2dkalFzWnVPOHFnTmV1MXZuMUE2?=
 =?utf-8?B?VE5ZSU9KTUoxVHVIWG9qR2lEbVo1OForbS8xeVR5bzdDdDY4VXppNUFwUUdn?=
 =?utf-8?B?L2N4TndHMFJmN3h6VWZKU1I4bmt3bkZ3eWt6dm54OWg0cU1xU0RIQ2J1b3Zm?=
 =?utf-8?B?eDB1Qm8wU0xKcXhVSVloMnU0Yk9aQlVTWVkveHdnWFdsdytNeGNjUTkreHd3?=
 =?utf-8?B?TG5MSjEyVXhGM0dIc1FUaVZzbTJFbGdHYmUyOVhvbUJ4bnRObkdTdXVJRnd6?=
 =?utf-8?B?MkZUaUs0eUZ4LzF0NXlQdEZVM2dqeTI4T1VOeU1HUzExYSt0WXJXWGtPb3B0?=
 =?utf-8?B?OEY5cG5rWHdxeWprQThaTUZHRTR5dy8zSzdGK3hKM3VQamltM1lYbnNZVXFs?=
 =?utf-8?B?YzVwTGNjWGpsdVBmakNEYytMRnhZdDVjTHJNT05DS0NUSURWUnBEeGdwdnVz?=
 =?utf-8?B?a0pDNVY1VE94OXZPZXBTZUt1MW5KaHh5RDVJQ0QwNEMvbEFWejZTejVmeDdv?=
 =?utf-8?B?dVVNZVZIN0JFc09rMXV0RmhHZXRVUGJmcVZwRi9VQ2lycDhzSllBR3dXOExk?=
 =?utf-8?B?Zm9Gc2lBWmU5WWpKakY0QlI5VFhyTWp6VUNjZUt1SUVnNWFZZ21jd1Z0UGtQ?=
 =?utf-8?B?bnoyd2htcThxemhBNGdWY1UyK05VSFZnM1dMeHM1SXUzMGFkTi9ibzJUMGpS?=
 =?utf-8?B?Z3dBbEViSS9TbnNnbk1SdXQzQUtjbGdQT0Y4MktieUZ1bGJLWEpxSDFWRVBt?=
 =?utf-8?B?ZFIyTEQ4QmNQMkFCL3pndGlaaXlxNC9kNjFhRlQxZC9aVWhQdU81MlFxV2tG?=
 =?utf-8?B?OXNWVkpraTQ4QkJlSnNtOWJWclFDZEJQWUNicFBkUW8rVk50L3VON3BJQ0ly?=
 =?utf-8?B?Qi8zZWx5VVVkNU5Fb2EvVjl6anhlN2JmWjFFTnhyeDM1eTdrTVkvSkZmZXRG?=
 =?utf-8?B?ZC9MTWpVaWYwNXkxbFV2VUpYTFQzR1cyaGJBOS9JdThQV0d0YUJubUI0eExG?=
 =?utf-8?B?YzNMZ1BCWWpmb0hQdmF0dXFGOElaZzVRMmo1Sll3bDd3UVhOUG1ieXFaT0ZU?=
 =?utf-8?B?c29iLzhDc05pUGQwa04wSnE0Z21IOW1aLzFxeGVMQzZwWkZGa2FMVVJ5anpQ?=
 =?utf-8?B?RURqWnNLR0VXWjRKbnhrM2J1WXZMcDhVbmNHbkRrK0YxTFFoN1RpQVRkSnd0?=
 =?utf-8?B?R1VoQk1heG9uRnoxMVF0RnRhN2M1YS9HV2VLNWduNTFRWXo5UGJJQ2NsTGgw?=
 =?utf-8?B?NFNTY09YNTd1Y29uYndsNlJZVjN1dmcxZlQ1MW1nekNjNURaSVlsVXBYU1R5?=
 =?utf-8?B?NWpmZ2U0Z0JoZTVsUXB5SFNoeTBna3hFZkllblh4ZDlRemp4emI3eVZNVVR1?=
 =?utf-8?B?TU1hUWx2SDc1Tk9UTFFrTGdFbmRRYjU4c2FmY2NDb1JSOWR6TUk2UHJyL2NL?=
 =?utf-8?B?dVZVdW5zSlFLSjZGaENnblRyMmtWS3RZQ0tPMDJDelNZbWcyeWJoWmhLSnZD?=
 =?utf-8?B?RDVLYWFMQTc4bTE4ZHhZK0xrS0I1Q2tNWUVudHlqL3lIdnM4SXJkT0N6ZHla?=
 =?utf-8?B?S1lPNDVtRERkWHN4S3R3MVZ0OG5RRk5JSmN1bGxBajJ4cEo4dzkyb1YwQVcz?=
 =?utf-8?B?cUg5eEVVVm4wSTdqTGx0cGdXT3drR1lwSGlKTW9UYWR6TkFHc0d0R0tJMmx0?=
 =?utf-8?B?SUtQcmpHdDBudTd4Ui96UmVpYUtIdlBJNjE5MDROR1FiSWhBNnlKVEtZL3ZF?=
 =?utf-8?B?MUJtRHd1aEtjM2VKN2Z5L0M0aHZXQ1VTS1Z1dUNvZkx5eE9BWjJkVHZDSE1M?=
 =?utf-8?Q?uX0c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d84010b-46be-4d7a-b312-08dbbf18bf0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2023 05:15:20.7966
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gzuJxK4grIB0fIh3QGiloe3BKDtyhVlPdgkj7s+f0xGq2fxmwY4neHPFZdqVWEtyKJJD7aOLWOrtKU6u1J6ATg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8705
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+PiArRVZFTlRfVFlQRV9QUklWX1NXRVhDwqDCoMKgIDXCoMKgwqAgLy8gSU5UMSAjZGVmaW5l
IEVWRU5UX1RZUEVfU1dFWEPCoMKgwqAgNg0KPiA+PiArLy8gSU5UTywgSU5UMw0KPiA+DQo+ID4g
bml0OiBUaGlzIHR1cm5lZCBpbnRvIElOVE8gKE9oKSByYXRoZXIgdGhhbiBJTlQwKCB6ZXJvKSBp
biB2MTENCj4gDQo+IFllcywgdjExIGNvcnJlY3RlZCBhIGJ1ZyBpbiB2MTAuDQo+IA0KPiBUaGUg
SU5UTyBpbnN0cnVjdGlvbiBpcyAiSU5UIG9uIE92ZXJmbG93Ii7CoCBObyB6ZXJvIGludm9sdmVk
Lg0KPiANCj4gSU5UMyBpcyB0aHVzbHkgbmFtZWQgYmVjYXVzZSBpdCBnZW5lcmF0ZXMgdmVjdG9y
IDMuwqAgU2ltaWxhcmx5IGZvciBJTlQxIGFsdGhvdWdoIGl0DQo+IGhhZCB0aGUgdW5vZmZpY2lh
bCBuYW1lIElDRUJQIGxvbmcgYmVmb3JlIElOVDEgZ290IGRvY3VtZW50ZWQuDQo+IA0KPiBJZiBJ
TlRPIHdlcmUgdG8gaGF2ZSBhIG51bWJlciwgaXQgd291bGQgbmVlZCB0byBiZSA0LCBidXQgaXQn
cyBiZWhhdmlvdXIgaXMNCj4gY29uZGl0aW9uYWwgb24gdGhlIG92ZXJmbG93IGZsYWcsIHVubGlr
ZSBJTlQzLzEgd2hpY2ggYXJlIHVuY29uZGl0aW9uYWwNCj4gZXhjZXB0aW9ucy4NCg0KbGl2ZSB4
ODYgU0RNIQ0K
