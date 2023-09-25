Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B917ADE28
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 19:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbjIYR47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 13:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjIYR45 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 13:56:57 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B68A10F;
        Mon, 25 Sep 2023 10:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695664610; x=1727200610;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8OgWyGhH3+em0WoRMrkANjuXHhelVH3ySHtgV6HXZ3A=;
  b=aysDQB/z+99l7lQH4ztRLAxe1qdIW47MJW0xtDSiKk4D3MFjsXVv0iPf
   w7SXY/r8hrb293IpKNc+wnMFXw0eEqpolmXA6ERbduv8Q0qkiFkePXYSf
   0VoB5Ikk+4t9Vj12QAzy1noD5mDY27HliwXnGbBksmGRfhfQBuM2nyqmK
   8yy4uADFV9ORv0bboZPqy2GZHJ2r5+UNk4+yaZCWi8NcP+sZlmE8IwDbc
   a9uXUSRj9wPfNyJvsdSluF2h8P1AjMb/eNn9hHwtnPtE/x8zPQeMLWVBI
   gzSs8klfI7WtNZ0Oh5pfeLMU8KyD9rflliiiq0Nb7Uq2uIXinPBtQPeZf
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="445438072"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="445438072"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 10:56:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="891781370"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="891781370"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Sep 2023 10:55:46 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 25 Sep 2023 10:56:48 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 25 Sep 2023 10:56:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 25 Sep 2023 10:56:47 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 25 Sep 2023 10:56:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MmQDA+L+I2dioKL3EH0h07ZFQ8PDzlYAITAXcn0cqCcjaQCdd+hYJxIdPtQ1wj1LMzxPTaVVg/q4lKTzrn+o7D4ueZ02pKz2s0dVkKkMGk+W7Jv/1mO2igYK0V6ryjFX/kQfmhQ6+jzG6UVsgrP9IfYPW3u6QUisRmBivS9+1oWZfOOuH3lOY6KKLOsdbCmfji9prLKXJ1rEQakDcm7od0FC4STWnIM9Bs9Q0hQYBKy/JE/iEyqNnr3nZt9wd6XZoJSTh3x2vo6rYwkO/Vy5aQTiyhB6/4P4wBk2R3eLavOn/x3JpnELOdhQGrCtia0cs8++tqVJqgIrxk8IQ2RqrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8OgWyGhH3+em0WoRMrkANjuXHhelVH3ySHtgV6HXZ3A=;
 b=Z602iOoN6UtlY1ik77riMhmyFhFXUqEPlBGE5KTqVR17jizqtT2I97XCWoLU4LEMx8RFmjUbJWZWrAMyLf3mOia3okqpNsq+9/zBveARMIaTQUEiysUB8Rer4tP2HO+0wzDTQqkvyYLytjMQHS3Z/izsazrE8iiraLuwNY2jpCR8pjsCu1Rk4ZGkgyH8NrjViWJPBh2w0WglZfTXRthBhP1BXMcdkmMTEMgnhCIntuYhTne6GbY8c653G+4raXvo4yvP24p9uwNxVIYSTOCyijeFBWc0TJSihdqRxlUB+qAKw/60eQ3y5a2LKSt7/r5LdWSh2pUeAd/tidXH0qtQmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by SA1PR11MB8349.namprd11.prod.outlook.com (2603:10b6:806:383::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Mon, 25 Sep
 2023 17:56:44 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61%6]) with mapi id 15.20.6813.017; Mon, 25 Sep 2023
 17:56:44 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "H. Peter Anvin" <hpa@zytor.com>,
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
        "x86@kernel.org" <x86@kernel.org>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: RE: [PATCH v11 35/37] x86/syscall: Split IDT syscall setup code into
 idt_syscall_init()
Thread-Topic: [PATCH v11 35/37] x86/syscall: Split IDT syscall setup code into
 idt_syscall_init()
Thread-Index: AQHZ7gbj6LYYw3ax602r6dWz9pQ+t7AruMuAgAAdkCA=
Date:   Mon, 25 Sep 2023 17:56:44 +0000
Message-ID: <SA1PR11MB673481413BA6522B01218297A8FCA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230923094212.26520-1-xin3.li@intel.com>
 <20230923094212.26520-36-xin3.li@intel.com>
 <D4167CD5-B619-448D-B660-24ABC0786E0A@zytor.com>
In-Reply-To: <D4167CD5-B619-448D-B660-24ABC0786E0A@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|SA1PR11MB8349:EE_
x-ms-office365-filtering-correlation-id: 65b14c02-9d70-4712-8795-08dbbdf0c7ce
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v16Em4V9b3GfQIZ7xcCNCZAGmHKtj+5azXCRtNMT0Gy1t6HSoJhx+CU7+GPXdDZaLsbU8XtGyU59VBN2ealS9TRs1pVXELnKZBIjaKWgTRTxNYgJaREBK9hE6drk+or7/h9rHikhrZfyO5FpEUCCpwjHqkFXFh9WKPcesSQ1CGwQaxRo5Y3Jw49ChXiySgXCWYLQOveuEDon/XK4zl9+3sc6WXKreNhSrUGrjPFtwsyLrQN0TvG3+aAaIELRb2ft1dbZHVNyPVwGsdc5gJ0GneLn+LPQol+TCxnYYdWRWTmRcyfjJIcwsVPVU8KEfUYhEEqHgNzj6fQZNS26FFjEquyb2mJndRqpRtHMbnedBlKt5TO0QKhyjcQj1TA9UB5J1Sji7fApR+tZgGaJeorL7nq1Ty24bQreA/84x1ICySxks458skEoD0GrMbMroycx4+Iw3Ax12V4iu8UgEcvZm+MEw5YtdxOtUA/fhCIUiqbwTn/LmXxeJt355Ruc+IlnHKKCjCbQvcDCZm0+yo+Nb4qvNUrc+l7kRKZZbtCOLYb9g6W3nbKiNp2A4HbuboPNdkHRCl8l1yUdqPWx7pqIb/34o5kEzKMEy5XHEaFKcswDE3ckXHgvEkSS6WrssnF3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(396003)(346002)(366004)(230922051799003)(451199024)(186009)(1800799009)(52536014)(82960400001)(6506007)(7696005)(71200400001)(9686003)(110136005)(26005)(55016003)(478600001)(2906002)(83380400001)(66446008)(66556008)(5660300002)(66946007)(66476007)(7416002)(8676002)(54906003)(64756008)(8936002)(41300700001)(316002)(76116006)(4326008)(38100700002)(38070700005)(122000001)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YWZBMUFQS2dWbDhnTVBGSlREWVIzWHNTMDQ4bE54QmxTeWt0dllneUc5bjdz?=
 =?utf-8?B?WDk4OVgrb2h0ZjloZUNwdDd2aWhVUXRabmpaRll1WERtWS9McitUejJZaHd3?=
 =?utf-8?B?Vndlc0ZpdTFsaEI3VEtycVhLWGpLWkhjVGlWZXdlNFNhMjl6NDZ1Mjk5QkU4?=
 =?utf-8?B?eFZ1TGJsRG5RU254Q3dzRVAzdmFPSEwwL2JJaFhuU2dJMUpXWTlNTzlXN2Zl?=
 =?utf-8?B?alFLelY0QUZXdldrak5SbVhucTBxZWxZR2VxN1pINDdMZE9zV1BHTWhiTHpj?=
 =?utf-8?B?ZDFkMXBta1FtK0htajBzZ2FsNTNaVVQ5UG9Tc1d0TUhHaXdCTDBCVGMrMzln?=
 =?utf-8?B?SHFIbUdndzVMenZJOHpxUnpyNnFMa2ZEWnVjWHFCQU1zNnBDaDVsSWNvR2Nx?=
 =?utf-8?B?L3BBYXpxb20vUFhyeEpkSzIrSXJmOFo4Wk5nMUJ2TFMvM010eUZXYnhLUUNW?=
 =?utf-8?B?T2F6WjFmVG5ESkNHdXoyYll0anRTeEhScm1Vcmo1Y20zU01ENk96UTVxTUVv?=
 =?utf-8?B?VkdzNkNkQkFYU1FMV01HSlRIWE05ZDVKOWZKbnBkNGNpV2hSRFMxdFlYUThk?=
 =?utf-8?B?bitXN1UwYmxDOGl6bnJvNloyUVlvUUI0QzA1dzR5SnVOdFMrc0hqa0xhOGRD?=
 =?utf-8?B?aWV0bEtYWWxRU012QWpqeDViTjA3V0thYmR2L3Q4dmhOdHJYMmlJZ2x4WVFj?=
 =?utf-8?B?NDdsSjBDNmtvc1dqYTQzTEx2ckRkbUlQbC9qL1d5bHVKOVNpWUtKMTk2d2hn?=
 =?utf-8?B?Q0VIYk11WUdXeTRNaTBReFh1VWxjSGxObGFhV3JEYTRJSVVzc1lUdkpUenp1?=
 =?utf-8?B?RmxOTmR0ai9CeTdRbk5sZm5aYnJUdy9YSE5QNEpkbkxPNXFYMEUyWU5wRno5?=
 =?utf-8?B?UnJqUzVYbnVMQkFaaHRNSnNXcDJpbk5VTzYzY0VhL2dwbG9mSVJtSTNySUFq?=
 =?utf-8?B?S2ZOQnZNRUI5emhOZk1JTEdsUW9nRHRsdVdoRy9DNzczaHBNQ0Nzc1FsbWZT?=
 =?utf-8?B?MEovd2FESC80TFZlY09sVEMyQ3NIQjUrcFg3Vk81SFNXWmpkUVFxTmRDSFYy?=
 =?utf-8?B?c3pocjZzQTVCWStTZ0JUcVREdytFcWJYTFVTNTJVRWxpVTNUVDRSM3Y4RGQ5?=
 =?utf-8?B?V0Fta2JYV2F6TVU5WUt3cUlFWEJVb3U4eXdkSVd5dHcvMmJTbXlScTlQOTJH?=
 =?utf-8?B?Nyt3OTY3eVg2NUhVQnpzblloYXhrZlBQeXV6K0V5d3ZVZmVLL1dTQ2tKWjJx?=
 =?utf-8?B?WGdvZERWY0Z4dFRnNWVaWVdIVW1zVHZKR05rMFVFSUptOFo5ajBqRGFNWFR1?=
 =?utf-8?B?T3o5ZGNBSXZDaDhRWHkyRnY3Vm1aL0pYd0cxMVI4UHU0akJheHNPY2pKdEg0?=
 =?utf-8?B?ckR4SkxXZTdGOFBhMkE3UVlubzRhbjRZQktrSjBDOGJRQzdqN2ZnVS9VRk1X?=
 =?utf-8?B?dlpHSUY3Z2xFT3hDbkdQZnpSSUs4bExCcGlJbEVxN2ZLRGY4dzZJeEZhczI5?=
 =?utf-8?B?djI2YWhNanRuTmJ6VzBqdlpFZkZPS1BOc3BhVWNJdmF0TG5sUktYTVo0cGVa?=
 =?utf-8?B?TkVNVEpRSjJnSW5ZLzREa1MrY2dPSFZTQ1kwaEFiVW9waWVVYmJjcXVLNzk1?=
 =?utf-8?B?Tzlham1ra2tpdkdPeE1NeXErRWhMNHVubys1ZW1nQnBIenRKSzBRU1N4WTBK?=
 =?utf-8?B?dTh6TmZQMDhkS3l2Mmszc3Q1VjNJWHp1UkR4SlNkRDZ2ZXkvcy8yT3JtcmJY?=
 =?utf-8?B?eWJjQW1vRHVpSnZqUjd6STBwQTRXbFZkWjdxdGdHZHMveUY5ZTcxZWVjWDhH?=
 =?utf-8?B?Zm9ZUWFrc0lsbWNWWUJ3NzFpZkRCLzdSWmxXL3F1eG54WXVYSWc5SDdNQmlx?=
 =?utf-8?B?RW9kQTVEYm80bkdDbm8wQUwraHpJNnFoV1FMY1JzQWVpZW5HWE9GVXpnVG1X?=
 =?utf-8?B?elhtSTZhakZwZWI3QUQ0NWtpUkw4eTN3MGtoeWtveEphdnVxSitscXNxYXdk?=
 =?utf-8?B?RjlMY2dpVHVadmpxUnBjaDVVb2hybEJwSUo5enQ2cVNsNFhadUJ1V3hSREZM?=
 =?utf-8?B?UFFjZlNjb3hyanVFdDFSUldwb1VJSUxWc3FFQjloUGxKa1pnU0Z5YVZZS25G?=
 =?utf-8?Q?8ZtM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65b14c02-9d70-4712-8795-08dbbdf0c7ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2023 17:56:44.4490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Atv4K+biwUDTmIagcFwHbcjUEstXcchp+WrcIwTGI6tmuM1zr2s59kcNWQ8cXoAdIGE74KHVop63wDnYONqBsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8349
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMNCj4gPmIvYXJjaC94
ODYva2VybmVsL2NwdS9jb21tb24uYyBpbmRleCAyMGJiZWRiZjZkY2IuLjJlZTRlN2I1OTdhMyAx
MDA2NDQNCj4gPi0tLSBhL2FyY2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMNCj4gPisrKyBiL2Fy
Y2gveDg2L2tlcm5lbC9jcHUvY29tbW9uLmMNCj4gPkBAIC0yMDcxLDEwICsyMDcxLDggQEAgc3Rh
dGljIHZvaWQgd3Jtc3JsX2NzdGFyKHVuc2lnbmVkIGxvbmcgdmFsKQ0KPiA+IAkJd3Jtc3JsKE1T
Ul9DU1RBUiwgdmFsKTsNCj4gPiB9DQo+ID4NCj4gPi0vKiBNYXkgbm90IGJlIG1hcmtlZCBfX2lu
aXQ6IHVzZWQgYnkgc29mdHdhcmUgc3VzcGVuZCAqLyAtdm9pZA0KPiA+c3lzY2FsbF9pbml0KHZv
aWQpDQo+ID4rc3RhdGljIGlubGluZSB2b2lkIGlkdF9zeXNjYWxsX2luaXQodm9pZCkNCj4gPiB7
DQo+ID4tCXdybXNyKE1TUl9TVEFSLCAwLCAoX19VU0VSMzJfQ1MgPDwgMTYpIHwgX19LRVJORUxf
Q1MpOw0KPiA+IAl3cm1zcmwoTVNSX0xTVEFSLCAodW5zaWduZWQgbG9uZyllbnRyeV9TWVNDQUxM
XzY0KTsNCj4gPg0KPiA+IAlpZiAoaWEzMl9lbmFibGVkKCkpIHsNCj4gPkBAIC0yMTA4LDYgKzIx
MDYsMTUgQEAgdm9pZCBzeXNjYWxsX2luaXQodm9pZCkNCj4gPiAJICAgICAgIFg4Nl9FRkxBR1Nf
QUN8WDg2X0VGTEFHU19JRCk7DQo+ID4gfQ0KPiA+DQo+ID4rLyogTWF5IG5vdCBiZSBtYXJrZWQg
X19pbml0OiB1c2VkIGJ5IHNvZnR3YXJlIHN1c3BlbmQgKi8gdm9pZA0KPiA+K3N5c2NhbGxfaW5p
dCh2b2lkKSB7DQo+ID4rCS8qIFRoZSBkZWZhdWx0IHVzZXIgYW5kIGtlcm5lbCBzZWdtZW50cyAq
Lw0KPiA+Kwl3cm1zcihNU1JfU1RBUiwgMCwgKF9fVVNFUjMyX0NTIDw8IDE2KSB8IF9fS0VSTkVM
X0NTKTsNCj4gPisNCj4gPisJaWR0X3N5c2NhbGxfaW5pdCgpOw0KPiA+K30NCj4gPisNCj4gPiAj
ZWxzZQkvKiBDT05GSUdfWDg2XzY0ICovDQo+ID4NCj4gPiAjaWZkZWYgQ09ORklHX1NUQUNLUFJP
VEVDVE9SDQo+IA0KPiBBbSBJIG1pc3Npbmcgc29tZXRoaW5nLCBvciBpcyB0aGlzIHBhdGNoIGEg
bm9vcD8NCg0KWWVzLCB0aGlzIGlzIGEgbm9vcCwganVzdCBhIGNsZWFudXAgcGF0Y2ggdy9vIGZ1
bmN0aW9uYWxpdHkgY2hhbmdlLg0KDQo=
