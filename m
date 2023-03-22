Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DAE6C423F
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 06:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjCVFk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 01:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjCVFk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 01:40:57 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7C22C66E;
        Tue, 21 Mar 2023 22:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679463650; x=1710999650;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z474GMlpKNxN0k7E/n6bsN0SlIqFX4GfkDTlccDvKjk=;
  b=KXVjczRAHdjHNzIY2I5IYkV8VTYUYPcldbH71OCNJ9xvavn4n+4s7bDh
   ij8G6bNSgzg937wkNN2HYn/fpfBQP4xZ+S+pGEdzWEYbcOnYey7A53SLy
   nBnX0PtBDP9ZuPETLhNDg5P/Tzzi8WZz11FTUVFXEN597X9TF3sAVJwtY
   SN+FC+mV6XS6tuFLc6TetbOLhd1fOmBII7ATEnLebnj6kNvOHAmKly61h
   WPAGqa4ma74zFmYx4vZkqqmc23tm4p7hwub14v0Kc0wJg3grgGKl1uj0k
   80NlaRKH7cq9MESIJhMXChjqT+d8zdg2pkqd2JdGOL+s4Z883mkZClIzR
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="404015712"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="404015712"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 22:40:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="770921813"
X-IronPort-AV: E=Sophos;i="5.98,280,1673942400"; 
   d="scan'208";a="770921813"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Mar 2023 22:40:49 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 22:40:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 21 Mar 2023 22:40:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 21 Mar 2023 22:40:48 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 21 Mar 2023 22:40:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aq9JZ1hgm65IXX8jxffaqOG8tJnBJqOSC0pJnrUs3erTaQyx4b3ABYJNWzqZSDUyY1VdHOLzGwRnoJviIAkVHExmdRMEXlHJbgW576vinfslvZF0VdZNfMSodMze2qDcjzLMEJPMMkQ5XoQXqGUDiDlEMpFbuvzk4InwoDP4wuXU99HHwRZ6q/f/66N+L8e9oImUapHsAp4Z0gnQXj49kkmoj2Pw5z5FShq3bi220984h+B1WmEWcH9mj94xAfGDWtgXZJVZ2to4s+6nKXTM2Z2y2pBSdZGaXpmrdywt94kiT+8chFPfUgpc+eYhUrC/KfdnyQGZmVkXWdnMDXYNYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z474GMlpKNxN0k7E/n6bsN0SlIqFX4GfkDTlccDvKjk=;
 b=esC90uVJCZWHxE9ktanNFctY0+IrwQHyxJ3ofkOu4pgja63/VY6fwRO41cNXWzd10zyl4v4qlPGroyJXrTvsqgYmA2HM3XYOUE1ysgCfg8lBc4/Q2kNp97l/gDaZILzg7wCHIjSuGRcgQBVaG9wzauBaR8Ixguk+r71x/vVSmRbiHbXeQr/iKTLhLF2MVT4CAjd7a7oZB3trtOjcBDWImeorZr0umVnx8aXIqWQ3CAt7C5yojYtj2W1GdSNhUlvXgXtxE8CB+NP7+7IUR4eh/VjnMochzHc81oPZnoY1mPE6RS390Hhlpi0isIQYwZHO5qukADxGOUZHwuugC5XPng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by IA0PR11MB7936.namprd11.prod.outlook.com (2603:10b6:208:3dd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 05:40:44 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 05:40:44 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
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
Thread-Index: AQHZUKIwUYB0dIbGLUidau1bSRiyL67/CYqAgACFIwCAAJcqAIAF/rZggAAgFoCAABtjkA==
Date:   Wed, 22 Mar 2023 05:40:44 +0000
Message-ID: <SA1PR11MB673425B267E04C637A01EEF0A8869@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-23-xin3.li@intel.com>
 <CAJhGHyADXz-3PCFS3M_7TJ8qLGJ=4NcV9aBWrpjemuXB_SnMGg@mail.gmail.com>
 <5D679723-D84F-42F0-AD8A-8BD1A38FB6CD@zytor.com>
 <CAJhGHyC0_1xJD2R03-NoRVpMXFTHR4v8CdzyJOZe_k0rdv=NfQ@mail.gmail.com>
 <SA1PR11MB673486AB91F77B468ED1BD82A8869@SA1PR11MB6734.namprd11.prod.outlook.com>
 <7a3bf16a-5ad2-39b0-c68d-f36d40b8dfc4@intel.com>
In-Reply-To: <7a3bf16a-5ad2-39b0-c68d-f36d40b8dfc4@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|IA0PR11MB7936:EE_
x-ms-office365-filtering-correlation-id: 37bcb3b3-2e7c-42c7-fb97-08db2a97fb37
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GQxQYpzRr165K0X6zNYYAFV8wBO8Vzt4yQDyzjjZTA14VUEVnx21WZVi/nR9jRA+mqPyBFZrt1WeuyyYbYF0UNASmR1reAPsYM5CKeVN5+2w/jf0T4lH+F0BPL0lsgkVUIGVhxWCOB8HhLvVwD5wENFP6cwKpupAWro0IUR+/keUm7nmajxh7XF0+BdOi1xVrbiCT3SCOhUyVN70X655mmKccZ+PDdmb/DMPir+eOC3xqLXp/m5bK6aXEPr/DNAP5kxFHuHsllJrwdXNKXgV1eKjHVA5wew2TsT1Mth2THEAnT87jGHm8ciIAUGrHS7QyGJnDe2BfdJ1sQ1wfNBaMF6OoaOeYroSKf/69o4bZMxLeoQlc+kqsI9X/UzjBeU6a9NiBpblZzEgzT0TZoF7FN+2wtKQvm1XUSUuNfQCMjOZ/l6t3p0OCWoxjjkb4LoPy/lDuphcwKj8/nr1Dj7DHpi0EsJhNF3wJ+D1E/Cnf1+CqR8JzWuLS6+UCRFESt3BEkyXyDs7CLN6iHuz4wXblItmB5MbfzwwXkhCO6cmbg9L0Oa0BIiIvpbc7VzcELvfz3Rj6Pqrq1HYjbqknCNuav1v4C8fEqXHyWDJyLstabrHAnJLb5/oCTC1+O1MEXQHkVSJTYZjMf3PbtKboMPPhJIp6XqE68WjiMCF3tF6K41/BobsV9312KgYGijaJEhE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(136003)(39860400002)(376002)(346002)(451199018)(71200400001)(83380400001)(316002)(54906003)(9686003)(966005)(5660300002)(33656002)(6506007)(7696005)(7416002)(26005)(478600001)(122000001)(66946007)(186003)(38100700002)(110136005)(4326008)(86362001)(55016003)(38070700005)(66556008)(2906002)(76116006)(52536014)(8936002)(8676002)(66476007)(64756008)(82960400001)(66446008)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bldpQWp5SmRxUmxYSVZPcmFxZndkRzNWSE93bVdCdURVb3RlOFEzSFlLdUcr?=
 =?utf-8?B?S3NzRUE0QWhLWW9TNFJxWmprU3Bwc1JHNDJjcU42VC8wazZWWHB3di9YUExr?=
 =?utf-8?B?ZHI1aTRvT0FlZVZNdDYyWHQ3OGJEdk1RdWdLUjhUV1E1T0IxRm9Sd3ozNGUy?=
 =?utf-8?B?RUEzQlRzRzRhRzhwYnMrWUwwWU9qc1JRT1BmZmp2dTd0K0l0KzdDTlQvdXdu?=
 =?utf-8?B?QVRZVEhKU2EvbVBLV2ZuaERNd2hON2pIS245MG5IMVFQYStuOHIzdnhoeVpU?=
 =?utf-8?B?TUZwK29XWlorcFBKbTkzb0p0anFYU3pIL0FEUmsxMGZ0OUdTS0QyUkNvZnlr?=
 =?utf-8?B?bk9iaWNudFovVFZ3YkR3WVVXVG1EOEh6SVVaTkhKKzRNRXNzOC9MQmNEVkJM?=
 =?utf-8?B?dGxSZUZOdTV3Q0JzTS91N1BBVTl2b3FIK1c1Mlk0VWU1UmRzSDYxRUJDYk5P?=
 =?utf-8?B?YngwbDdPemZOekVFOUsxTlJ2UWhlTDdkbDRDQnVCNXFERXVvQVRreVZSSFhR?=
 =?utf-8?B?ZTFYUFpqRE9HWk44S2ZFZFJJYTRvTWYyM2lPQS9iMDIycW1NcGI5MXFvTGNi?=
 =?utf-8?B?MVdPWkJVZ2dxSWNyMENsRDJleHZ5dk5nd2hYWXIzaFlMMzdkYVVaaGRUNUgz?=
 =?utf-8?B?MmxJaGhKd2F1Q0c5QTlXRmVzTmxwMmtyQ0kyMHo4dUFvdy9GWms3Rzd3MGU0?=
 =?utf-8?B?NFZ1bjV2WlduTFRQWmx4cjRFTjJsSkxDTVdmcjVOTVd1K1B0c1FUbzdQVzBj?=
 =?utf-8?B?Ullsc1YvM3J4Wm1WVkVOK041S1RHbWJnVEQyZVNGSVhMcWNUai92d0NFbnRD?=
 =?utf-8?B?QWpvZ3VDdkpCcW1hQXQrOFhRaFVLdm50TTdnamtVUGxtaXZjMzYvVi9FV1J3?=
 =?utf-8?B?Y2pqbG9JREZVOFcxLzE3ZC9pMGR2QTFpakZOa2hxR3FST0xkTHV4OEVKenc4?=
 =?utf-8?B?S2YyRUhuQUtmTnppRVl0Ymo0Vm1VSTVuSm9hVlFqVlFqMTRVL3JlSDVSc0RN?=
 =?utf-8?B?WWl2aFcyQ0Z1bFNYVkU4eGZWVmJOTDJtZWNHbkpubGV2U3dEYmhpbGlvRk5q?=
 =?utf-8?B?aFhOeG5ab2lnVDlxYzVNM3p3QlNZOE1JY1dRSCtWamlHdnBVdE5xcGxRWU9I?=
 =?utf-8?B?SS9LeDgwVzdSeFJCVFdIZGxhbmRFSGUzY3JzazJLQVp2OG43ZHJYNUFTdmJw?=
 =?utf-8?B?K0FUei96T05kRU5iamdTclZNQXB6alg2dG1maG12bTZONDl2SGV6WFkzcEVM?=
 =?utf-8?B?dGRMS1k4Y1BvaFYwK1AzYXNuazM1MnlWdXY5MkRrbmZlRWlmZlZFbFYvdkpI?=
 =?utf-8?B?SDdKL05kQ0hnTDlaekFBTnc4bUN2Z2pyN0tIbTFBUVlRVHlYelJjZzB0T2Ra?=
 =?utf-8?B?UTNoMjYzYm5PNm5EdHFnWWdJdHZxRFFHdHJSdVVPais4VHAyUjQzRUZLeVRB?=
 =?utf-8?B?MWZ5RU9uUS9ERWpPMmZ3Y2ZDK1g0VGdETHRQUEU0QlZkZ05Rd0JROG5HVm4w?=
 =?utf-8?B?SWFiOHRra1lUbzljaU1zZTNDalpveWpybVcyNFNhZWRHdzNsY1N0N0dnQ2tI?=
 =?utf-8?B?dTdRbFFYd2pqQXQrVEtmWXhBcXFkY09wbXNrVUhpSjZudjFBMm5iRmM4Unl2?=
 =?utf-8?B?MjIyNDZ5RVpVNW1mVS9XZUcxdUhBdmdRSjJvNU5uY0xEa0tzY3RCYUdob3ZP?=
 =?utf-8?B?bXNiS0M5TENwdUI5YnRZNHhTV1NleXYrbnQ4cHJrbTJoSzRzYmpGa0hSOVNa?=
 =?utf-8?B?QXMwZ1ZaVTNuNlhsSnJocTliUWZ2WUVQMUVueVZiaEpQcGsrMlF6K1dQWTlU?=
 =?utf-8?B?UGVzWmNGbE1IVG01UnJMVU9haXhCVmU3TloveExzWU1UWm9KVWltYUNDZUdm?=
 =?utf-8?B?bTZISEdNYVVqL212US9CRGpFaG9oRkFhV25ocUJucW5kSmFucFR5VHA4SmN5?=
 =?utf-8?B?WUVheWdsM1JwV3FCTGlzSlZvVndFZXhodDBjRnBqbjM1MUFSaUM1VUZBSitI?=
 =?utf-8?B?ZTh5NVBwbkZWODZNTWdITFdpMlJTWDJpcmYxMDBzdzJYUlQ2cHpaZkF1MGg1?=
 =?utf-8?B?ZE9odWlrZDNFQTJnK1dpci9sTENNYXFOWVlLb0tOcWFFbjg3dUJxMkhnSzk4?=
 =?utf-8?Q?QjDM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37bcb3b3-2e7c-42c7-fb97-08db2a97fb37
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 05:40:44.6079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3snuNUaezedvqTKPb/vqjp+qA6NIKvdgcYIFfFF4BfDoQUBSyhaHYPYNScwPUWEv5tX8WWHfKuXkEyJnjpcQfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7936
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+PiBJZiB0aGVyZSBpcyBubyBvdGhlciBjb25jcmV0ZSByZWFzb24gb3RoZXIgdGhhbiBvdmVy
Zmxvd2luZyBmb3IgYXNzaWduaW5nIE5NSQ0KPiBhbmQNCj4gPj4gI0RCIHdpdGggYSBzdGFjayBs
ZXZlbCA+IDAsICNWRSBzaG91bGQgYWxzbyBiZSBhc3NpZ25lZCB3aXRoIGEgc3RhY2sgbGV2ZWwg
PiAwLA0KPiBhbmQNCj4gPj4gI0JQIHRvby4gI1ZFIGNhbiBoYXBwZW4gYW55dGltZSBhbmQgYW55
d2hlcmUsIHNvIGl0IGlzIHN1YmplY3QgdG8NCj4gb3ZlcmZsb3dpbmcgdG9vLg0KPiA+IFdpdGgg
SURULCBib3RoICNWRSBhbmQgI0JQIGRvIG5vdCB1c2UgSVNULCBidXQgTk1JLCAjREIsICNNQyBh
bmQgI0RGIGRvLg0KPiA+DQo+ID4gTGV0J3Mga2VlcCB0aGlzICJzZWNyZXQiIGxvZ2ljIGZvciBu
b3csIGkuZS4sIG5vdCBjaGFuZ2UgdGhlIHN0YWNrIGxldmVscw0KPiA+IGZvciAjVkUgYW5kICNC
UCBhdCB0aGlzIHBvaW50LiBXZSBjYW4gZG8gIm9wdGltaXphdGlvbiIsIGkuZS4sIGNoYW5nZSB0
aGVtDQo+ID4gbGF0ZXIg8J+YhC4NCj4gDQo+ICNWRSBhbHNvIGNhbid0IGhhcHBlbiBhbnl3aGVy
ZS4gIFRoZXJlIGlzIHNvbWUgZG9jdW1lbnRhdGlvbiBhYm91dCBpdCBpbg0KPiBoZXJlOg0KPiAN
Cj4gCWh0dHBzOi8vZG9jcy5rZXJuZWwub3JnL3g4Ni90ZHguaHRtbCNsaW51eC12ZS1oYW5kbGVy
DQo+IA0KPiBCdXQsIGJhc2ljYWxseSwgdGhlIG9ubHkgaGFsZndheSBzYW5lIHRoaW5nIGEgZ3Vl
c3QgbWlnaHQgZG8gdG8gaGl0IGENCj4gI1ZFIGlzIHRvdWNoIHNvbWUgIk1NSU8iLiAgVGhlIGhv
c3QgY2FuICpub3QqIGNhdXNlIHRoZW0gaW4gYXJiaXRyYXJ5DQo+IHBsYWNlcyBiZWNhdXNlIG9m
IHRoZSBTRVBUX1ZFX0RJU0FCTEUgYXR0cmlidXRlLg0KPiANCj4gI1ZFJ3MgYWxzbyBjYW4ndCBu
ZXN0IHVudGlsIGFmdGVyIHRoZSBndWVzdCByZXRyaWV2ZXMgdGhlICJWRSBpbmZvIi4NCj4gVGhh
dCBtZWFucyB0aGF0IHRoZSAjVkUgaGFuZGxlciBhdCBfbGVhc3RfIHJlYWNoZXMgQyBjb2RlIGJl
Zm9yZSBpdCdzDQo+IHN1YmplY3QgdG8gYW5vdGhlciAjVkUgYW5kIHRoYXQgc2Vjb25kIG9uZSB3
b3VsZCBzdGlsbCBuZWVkIHRvIGJlDQo+IGluZHVjZWQgYnkgc29tZXRoaW5nIHRoZSBndWVzdCBk
b2VzIGV4cGxpY2l0bHkuDQoNClRoYW5rcyBhIGxvdCBmb3IgdGhlIGRldGFpbGVkIGJhY2tncm91
bmQhDQo=
