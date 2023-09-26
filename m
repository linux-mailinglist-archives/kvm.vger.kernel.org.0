Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29787AE655
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 08:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbjIZG66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 02:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjIZG64 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 02:58:56 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D79F3;
        Mon, 25 Sep 2023 23:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695711530; x=1727247530;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Zb9d/HFuEpyvl/Z7q5P4+sf8PQIT0daBRtDHgwPyiMI=;
  b=A3Zs35O3uuQuB/VWRdJ6+/wl7khh8Vacz3lQvKc4IRwATH4bk1YINpst
   AwY8s0ps1zxmNHUcpyfbkrwqnfjgDO8FLuFXR5P+8Ypp6SRXU3AwWOnZE
   nikcnGtov28dgVurmb4r8NxiYjg/nCcHpuxvMV2+XOHOlhXVeh33IZf5m
   46XpdtNfM+m7qMO0csa9EIQDjuw3SblRvvmMDCIJHIylh0FtfhlI5zmCj
   GVzjliaXh1uX0r4jgtwSyvhW0Z68pFrp8uartZakgJl9lKJPyXWO8ACwx
   EYWBs4kByZsk8FTBnfN+bUvds10bYybKGbb0sNTHvBdciU2Q3XbsStFLE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="412417779"
X-IronPort-AV: E=Sophos;i="6.03,177,1694761200"; 
   d="scan'208";a="412417779"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 23:58:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="748718052"
X-IronPort-AV: E=Sophos;i="6.03,177,1694761200"; 
   d="scan'208";a="748718052"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Sep 2023 23:58:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 25 Sep 2023 23:58:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 25 Sep 2023 23:58:45 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 25 Sep 2023 23:58:45 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 25 Sep 2023 23:58:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQgtVbhRPBOz2k5Jb/58axG4kRrzoa2z2Sk15nNgwOFt/pXpUBtQso05G3h54AZBlq9gBeWbuOBZKQquAX9pn+BphPHMhYo2yEgQ2BmqvZlI6kAhU4ipEGgB55ch3F2w0kEjvtPm+Bg9apBKLGKBaOJIXGMLiJUteAko7SZ2wiaJicxMtl4n7oKwR4ZdQevE92XtxFra4KMDWcyY7bTrwB4BIP1WL952Dl8h7qzUzp1cH0s45ns6bqV6QAyJLSYrTEsTs8bei3mrmIDV1MdKI4xL5e4rfkbFUfVm7MdP+uT3Ays+8V7qXkas6wCqH97R275+Z6kT9fAxmUG3i/aFNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zb9d/HFuEpyvl/Z7q5P4+sf8PQIT0daBRtDHgwPyiMI=;
 b=GdyXk0LWhUWhoSjPLiegguxNznHJ91FVAs5QqYhUSnjUzaSHK0BHmDsEclBF30XN+An5g/3DNx5ieLtfrL6HPnUpihTzwIyKtfPRvHSpdoQtc64J6w0Rhc6OrRr5Oil8HbPMZ6BFoEa1RomuXi2v3GuLR/n4ZGCAdrTLW6bQLOzFMV3MW9qLEbyAGTdJI0Bv6zRyKxuTvtwEh2kxdyZkF/8bSqaimmSdlE9jMv6w5LOvQ0NOFn/J5mWa9mY/nue5qoDMeONbJmf7dIhE2zPP9mz492YWliT/sn9umx/KBhIZCsMc5wdEg3oXcIv6t6gG+rT0sFhpiDKAbSNu+Oijvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by IA1PR11MB6420.namprd11.prod.outlook.com (2603:10b6:208:3a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Tue, 26 Sep
 2023 06:58:37 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::922f:ec7c:601b:7f61%6]) with mapi id 15.20.6813.017; Tue, 26 Sep 2023
 06:58:37 +0000
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
Thread-Index: AQHZ7gbj6LYYw3ax602r6dWz9pQ+t7AruMuAgAAdkCCAABFkAIAAyWiQ
Date:   Tue, 26 Sep 2023 06:58:37 +0000
Message-ID: <SA1PR11MB6734A593C605A1010EB2D7DAA8C3A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230923094212.26520-1-xin3.li@intel.com>
 <20230923094212.26520-36-xin3.li@intel.com>
 <D4167CD5-B619-448D-B660-24ABC0786E0A@zytor.com>
 <SA1PR11MB673481413BA6522B01218297A8FCA@SA1PR11MB6734.namprd11.prod.outlook.com>
 <69867C92-3A02-469A-9B77-2E202A4D4A0F@zytor.com>
In-Reply-To: <69867C92-3A02-469A-9B77-2E202A4D4A0F@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|IA1PR11MB6420:EE_
x-ms-office365-filtering-correlation-id: 4e19c239-10dc-40e5-a63a-08dbbe5e0246
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QPA9MzqcQ2k9TUSeVWz/oApKN++tlV97NhAbHI/JCm/x1w9JzvkyhZvXsGRdhHTaDz4Bp0a7hlXWi0i6H75XAdQAlm7YoNYB/SnSelKPAWYoSuSJAER7vSqEbW75OZ0sGr4VUW74ABj/P3BG7x9X6sCZt/dWNN9GdLHNNI+gvd95GsMlvmt4SArXjSG7DY5g0te51pyqT/xepFO5R6YDwzNF7VgGaHG7FPvLRL+RKIU1l+MFrmj29YrXLc+/Z/ypGgapC99Xcl03zNdwD2yd95ApMsS/dBm21EKiJMIPDLTsqN1GRAIOFJqyysi2TLT74Yn7llYE2vcHdtePfHls7n2EMngAYC6YN24eV7QmsLfAE3sinya5vOIvHb9C5TpSx8Mo+unPsmB0P43G0VFVhtxT1SdsNuFXG1PhRexB8gqXr5zM7GHzUEoMI3pGUFYghElWWdU6WJ4jdJuQZct7mOI0Inluk0xmvP4JCtDaxOvGFW7Ps/Lgjb5Zu2BYQBh8kgEP0iDloEVeOzGy9cuB7Eyd2iQmdSXdLJD54KCratCLnKFnAuFSPSX7syy6Jj7kll4lclLYE0NR3ZLYubSwHqdOURiOsqi7X/WxnCq5G8cvC6SEJt+KBKYCSGJ8QthU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(136003)(366004)(346002)(230922051799003)(451199024)(186009)(1800799009)(7416002)(478600001)(6506007)(7696005)(71200400001)(9686003)(26005)(55016003)(2906002)(66446008)(64756008)(66946007)(110136005)(316002)(66556008)(66476007)(54906003)(86362001)(76116006)(8676002)(52536014)(5660300002)(4326008)(41300700001)(33656002)(38070700005)(122000001)(38100700002)(4744005)(8936002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ak1xSFE5Ui9OQ0dvcTI3QkV5NWZlSkdlMDBqai9keEo1V0hTUnI4T2FnQUl4?=
 =?utf-8?B?UGNpeW8wWVVmNGcxRS96QWxWTHJoNU82T243VXEyMW1QalFKU0d1N0p2M1NV?=
 =?utf-8?B?UEdDd0wycFhYR040Q2x1YjV6N0xObDk2em80RWIzMVFENnhRQmczNVU4Szlu?=
 =?utf-8?B?OGMzZzE5T1g1ZEQxTzltaldJNlpEa0pFczBpTEZwcGpPYkZ0ZlVQdXQ4LzJO?=
 =?utf-8?B?a1ZwdGFGeld0V2lrTHlJeVJTVzR6Tm8wbHY4SzV6VXFuL1JjQUdkSitFNk01?=
 =?utf-8?B?cU1xeFpTZmxmaGdsS3JtUFdWSitpS3I5L3U3Z3ZPdzFOamRGS3YvZkFacndY?=
 =?utf-8?B?Ny9oazRJYXY5YVhNMEc4Q3NITXJsMk9uTkpHcGhoUzkvVVJNNEUvTUlra3pp?=
 =?utf-8?B?a0RXL01MUWZtVEg5V0pIbnZod0doKzh5NmFDQzlpWFNaOEtsZmVqOXNob1B5?=
 =?utf-8?B?aDhwWTBIa1FBdnBKTU1FWE9RUjNFRU9Ib0FQV2V3NGtWWVRqK2xxT09hNmtK?=
 =?utf-8?B?Vk1CU3EyeHN4UVRDTVdCTTJZR2pTUFlEcE1UdXIvdk9aQnBGT0M4V28rOW9v?=
 =?utf-8?B?TTNsNnNvMVZpb3J1MzZoTGptSVorV3J6MURzcU5CaitaUjdhb3o5NGdNVmhG?=
 =?utf-8?B?UVp4Y0lmTGZBTmZiV0ZibWVQRzdNTnB6T0lZaGVxQWV2NHFMNFMyMVVaNjdP?=
 =?utf-8?B?UmlqNFRoL01kWlBnVnF1S1l3K3dqNlovMW9rOXltdzljSTlKSHN4blZ2aW1Z?=
 =?utf-8?B?K3BNejRJRzFXZWY0SFVVTTlnSU4remZva2I3NkpUZUJoeTkxdDAxRW1NRkFR?=
 =?utf-8?B?MStYLzlNN3JzM0M1N1U3NHZLdUhmWWRvcFFJaG93bG41NjhDK1dEWUMxSG94?=
 =?utf-8?B?ZkFaV3U0RnRLVG9aSWMzT2RGdzNFM0Qvek9Ud0V6d3o4Zi96ZWJ3elZnbHN3?=
 =?utf-8?B?UGN3NndOOWVaUU5UaWppa0hPNUhJNXdQTytraThNRjZGanVlRWdCbUJVdnlJ?=
 =?utf-8?B?K0lNcUVBOVhQTDFocTlGM3E5NG5DUXRJM2owc2tueWIxblpkVStpN2NCVHQw?=
 =?utf-8?B?VFdOQkRIaXdtME9wODlDQ3o4YXV1aWdSaU1wdE1URjl5U1FyVlNTblgwWkpB?=
 =?utf-8?B?T1dEQk03MWFLSHNpd0pEaUdUTEJlMTVFSlVaOFNRbmNEWlhtR2hzVzNGYkQy?=
 =?utf-8?B?RnBFVFViNE5uRUtFbGZ0RmR6V0pjclNmR05qbU9BVU9rSWZZWTV1aWVzb1ls?=
 =?utf-8?B?K2ovOFl5NkpzV3FkblhOeUt4MWRsYmpoKzNtb3RWOFkzemxsTjZkRlBIcE1Q?=
 =?utf-8?B?T2FKSlJ0N2hzR29XTkMyZXpaVThjZm5KTWdqU2hQMEtzeGRMWEZDTUR6RXRD?=
 =?utf-8?B?Um82WFYveHRIZHdaUW1tN0hZLzNwbVZZL2YyZmprdHArNFU3MlBVNWNLVXJq?=
 =?utf-8?B?c3VsVWhNSXVPZ3d2eFQrT0IzNUkxaXRzTy9QWFFhOUZjNDRFWk9QSFUwUUJj?=
 =?utf-8?B?cEhQa2dKZC9ub0Q2UmFRZ0dhZytMcDZkVDJxQUg5WWlCbEVHc3g0TUR0UVUr?=
 =?utf-8?B?QlRMcVptY2N6bXBJdTdkRlF0Q0VuWW12RDlYajY3TkNtSTdIVjFzaGRLTlVS?=
 =?utf-8?B?QVlMWUNzUjk1M0QrMjJHQTFWaHVJSXJ1OHVCQnl4c0c1QUYybkx2UkxubEwr?=
 =?utf-8?B?QjlmWEIxaWhhaFl3N243U0ZteW16dGFyOGVERTJVQTRuV0ZrL0diUHpadVpj?=
 =?utf-8?B?eENmZFMvckw4cVNzU1FpVndlQzFPV3k5UlEzWW9PRUdZdlNGMU1yQ1BwQVlr?=
 =?utf-8?B?UHRHVFMyUFRmbFZ0RTdxNkxBSUROdmRzdHBwc3NiNlhmQnI3QW1JcGVlWUdD?=
 =?utf-8?B?eTVTNVNmV0pNbmxFS1NyZ2ZOSXBnNE9yVnhqN1ozR0hNdWU3OUkzZjMva3ky?=
 =?utf-8?B?WnltM2tCSWVmYzBtU0NNeWFTZUxvSk1ZUjRyYVo0cW9hdlB0a29tSi9wcExt?=
 =?utf-8?B?dWZHTTNQWWp0QUdJbEhYdnJQcThhSHhZRmV2SnpiNWJyRGcranY0N0R2aC83?=
 =?utf-8?B?UG44Z1k4Q1RMVHhjTkVYWDk2SjV5cHF1ZHVPMjcxeUpBSXo4dmxaNmhYam1F?=
 =?utf-8?Q?fNV0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e19c239-10dc-40e5-a63a-08dbbe5e0246
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2023 06:58:37.7407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AH/5EserwP4WD9hSsTi5PpDmNkpmcdSYileSHF4PgvPY/i7Bm2FetJs8xB2LvOzTeg3GW2LLmzGXPGhRw9pGQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6420
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+WWVzLCB0aGlzIGlzIGEgbm9vcCwganVzdCBhIGNsZWFudXAgcGF0Y2ggdy9vIGZ1bmN0aW9u
YWxpdHkgY2hhbmdlLg0KPiA+DQo+IEl0IGp1c3Qgc2VlbXMgdG8gYmUgY29tcGxldGVseSByZWR1
bmRhbnQuIFdlIGNhbiBqdXN0IGRyb3AgaXQsIG5vPyBJZiB3ZSBhcmVuJ3QgZ29pbmcNCj4gdG8g
ZXhwbGljaXRseSBjbG9iYmVyIHRoZSByZWdpc3RlcnMgdGhlcmUgaXMgbm8gaGFybSBpbiBzZXR0
aW5nIHRoZW0gdXAgZm9yIElEVA0KPiB1bmNvbmRpdGlvbmFsbHkuDQoNCklmIG5vIG9iamVjdGlv
biwgSSBjYW4gbWFrZSB0aGUgY2hhbmdlLCBpLmUuLCB1bmNvbmRpdGlvbmFsbHkgc2V0IHRoZXNl
DQpNU1JzIHVwIGZvciBJRFQuDQo=
