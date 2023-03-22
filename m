Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8586F6C404A
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 03:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjCVCW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 22:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCVCW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 22:22:57 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135571724;
        Tue, 21 Mar 2023 19:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679451776; x=1710987776;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ikRgK46k1Fr0UTZAwcQJQ6/mhl6c5m2vBirCrMpV/6k=;
  b=FN/k1pI0CCHuw86ao7/0NfPqLwaMJWWyFNmFtUvvidN56u5p4F1uePfn
   CkY4rptKDwYSMWUViRdJMX1BCDE31Kc6RP3Ialj8tPZsWZdDKYz+Fbw/k
   IjIbAlA+5ObIRt2MSa5ny3EWvKpst5BpKbg+WWdLb+MBFnUrqLepotRx2
   qaOcUrrkTyBiNBJaXufyFTjnts42mMinTOBPdtVMm0cp2ev5OQKyueW+l
   /YS4xp5D8+HXcrEAwof17dpH9w0cCPjm2JUdz4Thiok9tnb4N6cv8sM/Y
   SDW9g+tiNaNlk74hsY1ZIVFugS2PK94uJTpFHbltgKOb97mCHdKw5tQTp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="341466058"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="341466058"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 19:22:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="714245963"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="714245963"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 21 Mar 2023 19:22:54 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 19:22:54 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 19:22:53 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 19:22:53 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 19:22:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GIOwjShGoIk1rFEjZ8/A9V0P72tp9WmB9J6w6P+262PNj0lsUxP4OWIlg9lmnfhOUi6/qNBPADZ5qEx7b3mKAVdaJPNp6FR0LgauWkaKdoE85Oem15egMcV+X9rWWUWO+fYoErwE7KdJ5VODOzezDJ8r7Tlsg94TJafNoR6fQUgwyba+11fWoh49LgsNoFIjSuWziABW9VJeM2GI7cfVK2Klo7RpEp+2ynEqXDGSTIJSrTwbkzzqoFBHLqs+GTEE3kfoqIwH7xVBUqSuM8mc9oLPqfxa+L+IZ77N/KsmYc/8IQzgmbTbewOMweX948Ve8uedBT85AxS9SYWD0EyTCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ikRgK46k1Fr0UTZAwcQJQ6/mhl6c5m2vBirCrMpV/6k=;
 b=UDmCz627UcsQmP66Bs61fSnRvXlv+LG7/n/1CEOnzDxR7lvxOXSEsNHp9+HQQodYDUXrT9IfgGTnVtKbHN7hDvF8/+QDM3hVn/sMGVbP6BlrGR+X9w2Z9EmiqnEfnjXXFckBQA2Odxc+azwRrgqe59rsTBlmPovBRQds0TIt9T+i3t0pJfOsEPGa/2ruSAa/jnGtKStd7+YZZRTx3y/DIWaGu7+aTza3vQdPtKrwijFQZjYfZnArIzxMVEYVK0Y3eZLur26jMZbbBCi+G3N2MsXHT/d2koU6So3fRUGf1oY3Gl9+EEPL8/uJlrruE0+xe4gE9HYhj6xDixv2r/s4pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by DM4PR11MB8228.namprd11.prod.outlook.com (2603:10b6:8:180::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 02:22:43 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 02:22:43 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v5 22/34] x86/fred: FRED initialization code
Thread-Topic: [PATCH v5 22/34] x86/fred: FRED initialization code
Thread-Index: AQHZUKIwUYB0dIbGLUidau1bSRiyL67/CYqAgACFIwCAAJcqAIAF/rZg
Date:   Wed, 22 Mar 2023 02:22:42 +0000
Message-ID: <SA1PR11MB673486AB91F77B468ED1BD82A8869@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-23-xin3.li@intel.com>
 <CAJhGHyADXz-3PCFS3M_7TJ8qLGJ=4NcV9aBWrpjemuXB_SnMGg@mail.gmail.com>
 <5D679723-D84F-42F0-AD8A-8BD1A38FB6CD@zytor.com>
 <CAJhGHyC0_1xJD2R03-NoRVpMXFTHR4v8CdzyJOZe_k0rdv=NfQ@mail.gmail.com>
In-Reply-To: <CAJhGHyC0_1xJD2R03-NoRVpMXFTHR4v8CdzyJOZe_k0rdv=NfQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|DM4PR11MB8228:EE_
x-ms-office365-filtering-correlation-id: 31eaf255-ade9-4a5c-8516-08db2a7c5136
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5B+/reukvqOd23zDeqFdlBDBz6sV60jshNyNyYvtbic1z2NqsjwZdYwqbb1vsZY60M9N0rxAYd6OZQPo9pi+TZWybKimThgtXSx6Dy24GjS485aSSy9hoeJ1DfafZYjbFNg9TLB78LamYN9jFJhlUpWuTaEiyj/LXlFZpm9HcbtdvGgOVtzqrTci+4BuN/Kt8V8H3NYCU4yUaNT5+nfmlaoFhFFPCOn+uvZ46m9wlpbZZHtWipaRsgLzvzkCBe5u041WEAONZN4vpFk+a71+sFHbvd8TzpQaLPCZWPuk7pXE800syDcZfXsJJnOdH4kQGJhfECKrXt+tNYq0GXDKm5OX/FXdORLHmmMVopgIZ4qVYi5eMKKmX+zH0fW+8MTaBDgJGalIA5/KJ2p9P9ftTaZ+aBDU4Fd1n5m2MmS8U2Tm2aAZVsewpgNHD1kQ3P29JjeeST/EmSmVpZef1VNDJ6Ph4XQ2EoaI7SgbRsqhBSxZpAmQHHoFOHuORFbivXByT2mIr/szYn7Dcc4y/Uhhz15OKXPAxVt7mOv4HL4V8TxOy3OHk3B0j2R75I5kP25cBPOvT9LxMDT6BoNBCYdSJaMhDWBy/hL3ejMJ+oV3oC/cRCn794wweEbr8Wd8CdPklY3+7Taapr0/xpr6jp1EIh/2oJTPGOWhAyjz6o8YwckwCzSjffsNWKM1g+vP85L6lm5VXOoakd04a6bXpBxCag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(39860400002)(396003)(346002)(366004)(451199018)(6506007)(110136005)(66476007)(66446008)(478600001)(76116006)(7416002)(66946007)(64756008)(5660300002)(8936002)(66556008)(8676002)(54906003)(41300700001)(52536014)(4744005)(4326008)(33656002)(86362001)(38070700005)(7696005)(316002)(186003)(26005)(82960400001)(122000001)(55016003)(9686003)(2906002)(83380400001)(38100700002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZFJSYlFUMXZOZ1ZwVUhwaTR4VlpZU24rUXdBbFlXNTA3Y1RIcW10S1dSNVU2?=
 =?utf-8?B?NDRUMkZRV0FnS1YvRFNWZmVPT2ZaU3A5clExcXI4c3E4Wkp0Q29KU3FJNVZr?=
 =?utf-8?B?NTVZelI2MDQ0a1ZvTFh6WVZteHBqWVYzU0g5aGhMOHpUeFFYSlR1V2RjSmN6?=
 =?utf-8?B?M2xabjVaejByNE1FK0pJTG1rVXVMQ0ZoRXg3Y2U1NEJkTUZMY1BhZWVIcE5D?=
 =?utf-8?B?V2RSd0EzcVg0V3JoL2NITnF6NVNQTDFhQy9wNGVrRllYQ3RXem9zcDdlYm1X?=
 =?utf-8?B?d2p2bFFXMks4aE5wQ0hsZTRQdHNsTE1CejNVWWJJSWM3S0pHMjBkYlRYcmdv?=
 =?utf-8?B?VFBvS01CQmVqd1VObzYxcmMzUmRsMFBqUUdaTTR0cU9EWmozSU53d2dJMXZG?=
 =?utf-8?B?cDZMRkd6NmZLUS9ZVHp6TTZ2M05aOFpxWWN2K2JqSml6aWNCUTBQejZtbVEz?=
 =?utf-8?B?ZUUySXk0ekZscGhRTjVPZWZJM2pzYm05c2J5MThyZ1FvekZXK3ZCekdkazly?=
 =?utf-8?B?UEJxWm1WTUhQWDg1UmlSVERQTmJBRGpTTVh0dFdtVTF0enVGRFBVeDZHeDYv?=
 =?utf-8?B?M1NQMldRL3BuUWk4TUo3N3JFbVdNcVZyNkNHV1JQaTMzZ3AyaHJkUldwbVJR?=
 =?utf-8?B?dHp6Qk9UeUtCTTI5M3JoR3FFR0F4TFNZTGFxQm9Kc21lbndXM2pLeGpibnZx?=
 =?utf-8?B?d0M0UWtUdXpUbm5pQ0VaTis3WncvcTh2MVJ4TkZ3Ymh3UG1OdkhkZjhmUU1N?=
 =?utf-8?B?OGtJbUorSlVDNHdCVFpONlVSNTV4M1JpdkdPcHl6WjZwelk5OVd2YUFZa0JT?=
 =?utf-8?B?amtadHAyZGJZTy95WVRrTjRjN0pSc3ZQbjEwb0hkb0QxVnNRS0ZJRkxXVnB0?=
 =?utf-8?B?OHUzNjFQNlI4d2tWak9HZFZQTVdMeVpEL3RvK0FhOG8xbm8rNmVNazV0ZEdB?=
 =?utf-8?B?UkRBZVZqaFh2SENDU3RLMEgwa1FQWkI5NlBuNWlXbnd2N01HT041T210NWF1?=
 =?utf-8?B?RTV0SHhhbE1IMGhwTU50QXRuYU9GS3liaHB6Wm95dEZ0UlYyTEdJekhydGNE?=
 =?utf-8?B?QXFsMjZCS0ptUnhYcjNvZThaZ09LZVdNYmFGdFR6c3I3MGN0eWprMzgwZWla?=
 =?utf-8?B?RXhVb1c4K3RZWFcvRzM2em8weG1yb2ZMNERFWVpWc2k4UWRWZWdGNnhJRThE?=
 =?utf-8?B?MVN0WGJYdVI5enBOem52c0xDMHdBeG1ERldQUjFDT2h5cXFXNlhTV0huYXNF?=
 =?utf-8?B?QlVhNjN6WmVQODYyMXpXTE91Mng5dFVBbnZMd2FsbVdRVlZKbHQrc0I4SWhX?=
 =?utf-8?B?RjN2TXFsK0V0K20vQkROQUhnc00rUkNnZ2t4Q2NGV1V0VlZ0Z3kyK3NXM2Z0?=
 =?utf-8?B?emZ6U3ZrVmFuMG5vdlVQdGMvUldRci8vZ3ROdUFueCtPajUvMUJLS25GQUlC?=
 =?utf-8?B?L0lyMzlMNktNNk9XVzVoNWpuUkVseWhLQXZzcTRTRCtlbC8vb21IQnNWeUhJ?=
 =?utf-8?B?QWpiaEVkQldPbUhUdVhLVm5HV0FGcXRhQ1lGL3BzVC9jc29wZEVXVnQ3Tnpx?=
 =?utf-8?B?c1pDd1hTa1JqMWl2VDYxMjhxWVNjK0Z2TjJ0U1BqZDZ2amRKQ3VtTHN5V0tJ?=
 =?utf-8?B?ZUNCNjlTdElhZkQ3M2tncVlZTEhWeWNQaXFxQjZuWHBmVkZydVBHSGFTUWNI?=
 =?utf-8?B?VzlaODZDclZHVUdHY1N0ZDFTaHJNK2lmUTI2Ylp5N2piTjRJZHFTdTV3elFj?=
 =?utf-8?B?anNrNjZaZERYYzY2eWVtUXNnTXVKbVpFelpwQmxjSmQ2aG8vRXg1Q0F5NE1M?=
 =?utf-8?B?UUNDcGxlWTR6K0FvVzR0U0FHdHBaUktTbFUxY3lWNm5YWmdLcFhBdXJlU0p2?=
 =?utf-8?B?TjNndEdWOW4xV3dQdTBxcys5bm9PT1IxbGZJdXNCWDBYTzBXQUV4cVMwYWdQ?=
 =?utf-8?B?SXJFSjJLVWNoZTE3bW9FMG0rakc2MEJpY0R5TVk2cG1qeTJ2cHpYZU9HQ3FP?=
 =?utf-8?B?RTk1NFFPbTBIM0taMzQ3VjdETytNSDJDanlmNHhrWGdUN08yM3JNa2duMTMr?=
 =?utf-8?B?UVFmUUhBd0FQUGd0OFR1SlEwKy8yKzg3dU5UU3d3djBqemxNcWlWbEpaNHd1?=
 =?utf-8?Q?jNvc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31eaf255-ade9-4a5c-8516-08db2a7c5136
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 02:22:42.9583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b8g9WwR8/jSmYby43QKcaRwaHEW+blH2kV8yA/n1To1yOLzYgg1br9Gvgcyh86LlSnU/f0ldRwDqbMAk+xehwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8228
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBJZiB0aGVyZSBpcyBubyBvdGhlciBjb25jcmV0ZSByZWFzb24gb3RoZXIgdGhhbiBvdmVyZmxv
d2luZyBmb3IgYXNzaWduaW5nIE5NSSBhbmQNCj4gI0RCIHdpdGggYSBzdGFjayBsZXZlbCA+IDAs
ICNWRSBzaG91bGQgYWxzbyBiZSBhc3NpZ25lZCB3aXRoIGEgc3RhY2sgbGV2ZWwgPiAwLCBhbmQN
Cj4gI0JQIHRvby4gI1ZFIGNhbiBoYXBwZW4gYW55dGltZSBhbmQgYW55d2hlcmUsIHNvIGl0IGlz
IHN1YmplY3QgdG8gb3ZlcmZsb3dpbmcgdG9vLg0KDQpXaXRoIElEVCwgYm90aCAjVkUgYW5kICNC
UCBkbyBub3QgdXNlIElTVCwgYnV0IE5NSSwgI0RCLCAjTUMgYW5kICNERiBkby4NCg0KTGV0J3Mg
a2VlcCB0aGlzICJzZWNyZXQiIGxvZ2ljIGZvciBub3csIGkuZS4sIG5vdCBjaGFuZ2UgdGhlIHN0
YWNrIGxldmVscw0KZm9yICNWRSBhbmQgI0JQIGF0IHRoaXMgcG9pbnQuIFdlIGNhbiBkbyAib3B0
aW1pemF0aW9uIiwgaS5lLiwgY2hhbmdlIHRoZW0NCmxhdGVyIDopLg0KDQo=
