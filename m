Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D65663ED4
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 12:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbjAJLCS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 06:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbjAJLCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 06:02:02 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8AC1275D;
        Tue, 10 Jan 2023 03:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673348504; x=1704884504;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3zrpiDJlKr8mODYwJEMXC7TDPfHtk1No94+v8cCzo64=;
  b=ad+aplNU8pw2/cAmsKopbQeqSE6CRtCKUDEF2DMAkB8KW6I7elrMeTZ4
   hsXgBzQLFWLSqMZBHf3q3n4jmaRTVDmD0AXHiiht6K6qwfYJrbBTms/kn
   GW82xcfyE07Cg/Bnx253nidMdlyffJ/qHj0P2tb3qoBQdW4cSUzvLdTjB
   h/cjQWbT5gL90azH+gDrHJbm/ACfNCnrTkU1L45waj6/uJ14ic6/lGsxj
   KXlpsbasGkDT950lLZFp8ftNDvFO28zAu8RVV+b3ZpypfJG2DQpOWtTtr
   yuEqpGLSqRm32nLtwW8T529NiW6WUuKsKtfiyQexhhtI/k1HQz9e2EvkR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="310919154"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="310919154"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 03:01:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10585"; a="781026956"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="781026956"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 10 Jan 2023 03:01:43 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 03:01:43 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 03:01:42 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 03:01:42 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 10 Jan 2023 03:01:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oGcd75VoAljJgJXoCDT99wuyfUU8KCANNpCy7gzgligkFOgDkrvC2/s9MHz37LIqBUV7hdHs3qnCS4ZwtVFn6Zv/mTUUuBDQ865+qst2/DZ2IUDo5E0dEVXlvCJsCCvxZc29CnW1uDY0VXZITAJLe66sYbT5riLz59e+KJeh1andNzS9naizUaRWJ1zAGolbMfpO7juh/r38O80n1lKB+Lg+yUT5vkMn2qp+IUfbmss+1sYGZ010SCUKxXwn49lAPAzmLVljFrhj+SQFS73nN4UM/QHOz3vQd0U8X8TzDdXxwEm/l8+q0pu+GIkMtIv6GSEWs27RRkPZ3bmuPBntLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3zrpiDJlKr8mODYwJEMXC7TDPfHtk1No94+v8cCzo64=;
 b=PdlNU3wKLnufl9n2sFHJqVwxkEEEddv+cZfsk3JITigqo7QTtC0v+fedBKPjJjmEOyDEV21F1TPsUfgo65HNYVei66xM9wPvB32AVtKPCq6SUZD+I6T6YoeNfukVIZn+5Jg+ylq/7xCb0bfEEhB61vG3x6fbNc4oiBfyfRaJA08Smzmd5cROyHAl6cbS3mVtqjsN2uO81vscUAwus7TCnWNKFuwUQc6NWCAYVNErvwEkjE282NCyLoLAI+SNvKIPJGIaDaXrqswef/IWy9ht2zlXuVm2TE2JOZGyVv7oZ0blcuqgBdPhUZ+8LrHK1lzo6ZO+DPa3mV0LPnGU92QJBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6218.namprd11.prod.outlook.com (2603:10b6:208:3ea::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 11:01:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 11:01:37 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 11/16] x86/virt/tdx: Designate reserved areas for all
 TDMRs
Thread-Topic: [PATCH v8 11/16] x86/virt/tdx: Designate reserved areas for all
 TDMRs
Thread-Index: AQHZC5gQ3FCTeDpWDE6DayveLyjo/66SH22AgATsd4CAAADVAIAAoeWA
Date:   Tue, 10 Jan 2023 11:01:36 +0000
Message-ID: <24ea02aa4db7d470adeb7a64b7692d8bd5a428ca.camel@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
         <27dcd2781a450b3f77a2aec833de6a3669bc0fb8.1670566861.git.kai.huang@intel.com>
         <2d7d2824-7aa7-5f96-d79b-b44ff7fe2ef9@intel.com>
         <b971cd8b4e6ce9e96c6b4c6192adb74cc6722d54.camel@intel.com>
         <778a6c80-a955-620d-a82a-c2ca82f26363@intel.com>
In-Reply-To: <778a6c80-a955-620d-a82a-c2ca82f26363@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB6218:EE_
x-ms-office365-filtering-correlation-id: 20d1074c-4269-47f3-9d20-08daf2fa0b1c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RG3fkdAS+dGMwJ1fB/lMc2IM0nB241iVnywYRRqt5klOCQj25dmOevx9rBaGkAXT7CXdBHnrjF1nk5AX/dkRe6NPQCGsrzeJ8wx5dILt7tlBGXgHZQXwOT07eTzB+4v+6frWv5S8aBXS7WrZAmAli9G1z9+0+ZlR57e/J0zK9rnKxGDZkVLbxlBa0DUcESjggP7J17U3gzI3OqWNCqZx8l+I3pqOW0STRo5i7kmHdqpLjfacIyxObAAQZKDuIx+B39gHlzVlG3rHj0QdsJtYVSNR6Gbjna7047/6lFRYxgPZ+0MA1Rwn/KguhK03Xt6KEmZJH5RW3RuZfvOyvcUPdmrwXc1j9GAkJXKrg9R+A+Ph9Bz0dzHttJilFsKlTEMiapyLvWNu8byVPtEcceMirac9+mvWr4E99i391BJ72Rg0/6l+40rVlTIqBbHJm0dBpSS8CPhsd8VBFyrdRUrPyU7kmCIbTpstJyjoK3TZpo3gipdMDIrZd/sTnMUtijllL5py/9XSS4O/EPcs5vV5YFbGRNH1Yjm7BEbFox3a4S869OTWSTnjncKAE3jYTnuwMgIPtPTdQmR/XtkxILIhWoxHaKd1/NhhT8XaKzVKUgLMPWTX+vixvZ56x3ncnEfiRbHfor3/MoA9IpX/4LqMRQeWic4RSME0NBIGHl5kloP8v3OJf9k3hUMaZfX0TxIq051q9mCunaaEzb8YTMTUiCXyVYtmK5pYnQ0F/wL69Ww=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199015)(41300700001)(110136005)(4326008)(54906003)(2616005)(8676002)(76116006)(66446008)(64756008)(36756003)(66476007)(66946007)(66556008)(91956017)(86362001)(38070700005)(82960400001)(38100700002)(8936002)(122000001)(7416002)(83380400001)(5660300002)(316002)(2906002)(71200400001)(53546011)(6506007)(6486002)(186003)(6512007)(478600001)(26005)(17423001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?clF1MVZXSjVid0xjVmRGYXFFdHNTUTdhbU1pR3ljb1F0Y2tod0ZvZVMrUlpx?=
 =?utf-8?B?UmluaTZ3UzloUTlOWStlRmIzZjhEWHF2K1NuTnJ6S0FGSkRuVG9oUWtOaXUx?=
 =?utf-8?B?TEVoK0pTaWVSZzA4TjZoNjIyQ1J2bjFvV21SY0oxODFQWkptd0txdmZsUlIr?=
 =?utf-8?B?RmszRTVCZWtSRzNRdGgvTURTSWNidTliTzZqNHlIWERURkVDVTZhM0ZLN1Fy?=
 =?utf-8?B?T1RHSTUrM05FQy8zR0QwMTBJd1hVazVNZkphcVNPNzJ0M3pwYTNvV2hsRUpx?=
 =?utf-8?B?NFRnMWZobllqRUtKelpPM0hMT1NBNERObHFXMXFJRzZaZmZzaDJHVi96TmlC?=
 =?utf-8?B?cGYxS096SDByWFEzQjY4OHF6VnVKMmR5YnUyNi9aSWZqWGplQUR0OTZIdlIz?=
 =?utf-8?B?V3Vzb201RUZKejRZbncwNktWcFBNbEFHVk4razYvNXU2MjdFV3NxaXk0TGN5?=
 =?utf-8?B?Zi9CYWdMNjVmcWhyTkJ2V2J4MTNQa0dFR3l5enRmS05OLzI5ajlzSjJEdEF6?=
 =?utf-8?B?UGRVTDZuSVlIZzhNbzExR2pKSGFRaitEZ3M3QWFSajhRY1ByYnpMVUpDUllH?=
 =?utf-8?B?aFNybmFiL1RjSnVmbEovNTdUUGltcEEzQlVlRzBBbkVrOG1jUkRvcENxSUd1?=
 =?utf-8?B?YS9Qam85cVcwbFhlQ1FxSlBGWmNiTDF5SWxpdFNGVFhkT2MwbjdvWVQzZnZH?=
 =?utf-8?B?ZzhpVDd5UHlmSjZySEZQTk9SUWxNbjhtVGFkNDk1RTRqYTZGa01jTUhLSFpm?=
 =?utf-8?B?dXBoN2trWHErem96RUdDSmtGR1F3SG1WbDhyeC8vWW5yNjR4Njl3ZGJlMzNr?=
 =?utf-8?B?OEk5N3A3OENLM1h1bnpvbHptTTROeWlJSVhhMXF0dlhieERYTDI0Qkx0L1hP?=
 =?utf-8?B?UndFSmFaZG54RnFHYldPMGR5YmwrWVJreGdweW80M1cwc2EwcytUS21Bc1Fm?=
 =?utf-8?B?OEpqMzUvUy93eGlmZUFPSmsxZDJIckVHNk5xRGNkdUJ4QlgyUktnUkMySGlM?=
 =?utf-8?B?aCtqWjYwYkZhb00rSVhOY2JVK3hVV3dxaVdhZ3JseVNaTC95TGZNYUpnSzNu?=
 =?utf-8?B?N2RnWFMrV1djUnI4b1VRYkM5OWVPMlZvMURkMFBxZDRwaGl4TnYvR2U0M2pD?=
 =?utf-8?B?YmxZNUtKV3dmdzZTcG1qZ3lZRVNjdkJjYnRRYWJ6TjdRbURKQ3QycDBlOExJ?=
 =?utf-8?B?M1NaRGpxUHl3TFJsaTVQaUpnay9mQ0taS0poTXRGQjh5Q1MwdlFFNHN5UHFu?=
 =?utf-8?B?WkdVVWVsSTA0STA0azlTRXZ4K0pTN3d3MUJ5RE83R0Z6SHpGZHRONGpld1hV?=
 =?utf-8?B?cmh5QWl2WVVRZXdtSmJPc2tvMkRySC9OQXZ1eThrUTk2aUovMjFHblp3ZS9C?=
 =?utf-8?B?S0FLYUZXNTFPU1J1M2s3OWM5NXR2elRRRDZtWnNRNDNWK2hVd0hHMUFXZHZ3?=
 =?utf-8?B?VXEreW85UU5sRFg0M2tMK1VVL1JWL2lKZG1BV3dnL1lSU09BVmh0Z3ErOEw5?=
 =?utf-8?B?bWpvZUY3OXZGYjBJWnpLWnN2QVZPU0FUMi9CN0V5NDkwZHZrTW0vTk5Idm13?=
 =?utf-8?B?TlQ0NmozVWNlOUhvM2VoYzd1Tm0wdko4NUI5TW1IeWxjNFVUSDVudFVPN2Vp?=
 =?utf-8?B?dWcxdDhHT1hWNzRiZEtFYjFjL1NwTEJ3TTRQMFVGcTR1RStzWWdocW56blli?=
 =?utf-8?B?NkIyaFRudWMvUTRWMkRXSS96MHkyYlhBWHNTVVI4RUhRVjhUNzdzVXVZVk8y?=
 =?utf-8?B?RVc0Qm5PMVoxTXlva2NWb2hIQTZwcFplUUUxcWVaSjQrcGNHNGQrMmxPcStO?=
 =?utf-8?B?V3pUYUI1KzJSVkoyLzZyc2p3OFBVTmUzU2NGZDkvSkNEa055emZ5bjBYaEVD?=
 =?utf-8?B?YWFlVnBNUFd1cWoxSEFjMW5XUklyNVJodkQ5VSt0Y2krbjIxRDU4RXVEeXhK?=
 =?utf-8?B?Y24vUkVuckg4eUVmUitUaXpwcGJVSmZpRVh4QUpXeXNReFNTZjBiYnNLYksy?=
 =?utf-8?B?WmlpME5XWGlKRUxZVkRNdUR5Vkd2MVd4b2Uzb2dhYmozTXQrTGNnUTFnMjUz?=
 =?utf-8?B?bjlkZFFtSFRCVll1WUJPazNlRzluMjduQWN5aFJPRnVaeE11aDFHeVVBeGUv?=
 =?utf-8?B?czhvMUx3d1Z6Q0VrenN3TWg1L2N0OEQ5c2hjZUl4WGJNRkJKdzUxb3FyMC91?=
 =?utf-8?B?ckE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB94938DB1DE6243B3233627C91BD6D5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20d1074c-4269-47f3-9d20-08daf2fa0b1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 11:01:36.8204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LefiBQnUdu/XttwdRgBZMzeM5cGFR8Q7Nf6AR4HZWmBJVPB0PdqL2H/1cXTmRgmD7D+XokNCn7j7mwwRQ0NqNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6218
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

T24gTW9uLCAyMDIzLTAxLTA5IGF0IDE3OjIyIC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMS85LzIzIDE3OjE5LCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+ID4gSXQncyBwcm9iYWJseSBh
bHNvIHdvcnRoIG5vdGluZyAqc29tZXdoZXJlKiB0aGF0IHRoZXJlJ3MgYSBiYWxhbmNlIHRvIGJl
DQo+ID4gPiBoYWQgYmV0d2VlbiBURE1ScyBhbmQgcmVzZXJ2ZWQgYXJlYXMuICBBIHN5c3RlbSB0
aGF0IGlzIHJ1bm5pbmcgb3V0IG9mDQo+ID4gPiByZXNlcnZlZCBhcmVhcyBpbiBhIFRETVIgY291
bGQgc3BsaXQgYSBURE1SIHRvIGdldCBtb3JlIHJlc2VydmVkIGFyZWFzLg0KPiA+ID4gQSBzeXN0
ZW0gdGhhdCBoYXMgcnVuIG91dCBvZiBURE1ScyBjb3VsZCByZWxhdGl2ZWx5IGVhc2lseSBjb2Fs
ZXNjZSB0d28NCj4gPiA+IGFkamFjZW50IFRETVJzIChiZWZvcmUgdGhlIFBBTVRzIGFyZSBhbGxv
Y2F0ZWQpIGFuZCB1c2UgYSByZXNlcnZlZCBhcmVhDQo+ID4gPiBpZiB0aGVyZSB3YXMgYSBnYXAg
YmV0d2VlbiB0aGVtLg0KPiA+IFdlIGNhbiBhZGQgYWJvdmUgdG8gdGhlIGNoYW5nZWxvZyBvZiB0
aGlzIHBhdGNoLCBvciB0aGUgcGF0Y2ggMDkgKCJ4ODYvdmlydC90ZHg6DQo+ID4gRmlsbCBvdXQg
VERNUnMgdG8gY292ZXIgYWxsIFREWCBtZW1vcnkgcmVnaW9ucyIpLiAgVGhlIGxhdHRlciBwZXJo
YXBzIGlzIGJldHRlcg0KPiA+IHNpbmNlIHRoYXQgcGF0Y2ggaXMgdGhlIGZpcnN0IHBsYWNlIHdo
ZXJlIHRoZSBiYWxhbmNlIG9mIFRETVJzIGFuZCByZXNlcnZlZA0KPiA+IGFyZWFzIGlzIHJlbGF0
ZWQuDQo+ID4gDQo+ID4gV2hhdCBpcyB5b3VyIHN1Z2dlc3Rpb24/DQo+IA0KPiBKdXN0IHB1dCBp
dCBjbG9zZSB0byB0aGUgY29kZSB0aGF0IGFjdHVhbGx5IGhpdHMgdGhlIHByb2JsZW0gc28gdGhl
DQo+IHBvdGVudGlhbCBzb2x1dGlvbiBpcyBjbG9zZSBhdCBoYW5kIHRvIHdob2V2ZXIgaGl0cyB0
aGUgcHJvYmxlbS4NCj4gDQoNClNvcnJ5IHRvIGRvdWJsZSBjaGVjazrCoHRoZSBjb2RlIHdoaWNo
IGhpdHMgdGhlIHByb2JsZW0gaXMgdGhlICdpZiAoaWR4ID49DQptYXhfcmVzZXJ2ZWRfcGVyX3Rk
bXIpJyBjaGVjayBpbiB0ZG1yX2FkZF9yc3ZkX2FyZWEoKSwgc28gSSB0aGluayBJIGNhbiBhZGQN
CnJpZ2h0IGJlZm9yZSB0aGlzIGNoZWNrPw0KDQo=
