Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F0E79DEA7
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 05:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238226AbjIMDeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 23:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235335AbjIMDeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 23:34:14 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F881719
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 20:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694576050; x=1726112050;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SD7AmeLgFY/w5cL4D+jcglNNvkCEZ4ncfywi1R2JHHc=;
  b=daiNIFH5imXgsXHaLnPwSCK6hCT7Orc/wT8xUfp0zLfaCz//ctLRKBER
   79eaPdYRSo/SIK3uhr/ubZvZk04R31C5nuHgfUPnHyqXNkr5wqC17JIkk
   +Pv5SjC970HZBZwpxAiAkUvnHS/qHS3iI14ugYJ40Fq7++NlYGCPGbQfk
   NsMIfn8sNOwXmLog3hIBfocPhqxCbsav2ySSfE/2CztIFE8JwRplA9HW0
   oUqhKhY4Kd7/n0AJdhEIZNuPlyyJFR4xPxvn/sJQx+nHxoFjK3vMoIVYJ
   8dsPFBLTIU9AlsoDTAhaaOrVfeEWrGz/4CtOFpBEi26KoteCpbSfdBP7X
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="363588673"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="363588673"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2023 20:34:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="693704662"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="693704662"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Sep 2023 20:34:09 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 12 Sep 2023 20:34:09 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Tue, 12 Sep 2023 20:34:09 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Tue, 12 Sep 2023 20:34:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Tue, 12 Sep 2023 20:34:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4bi4kmR/N3rbdVKsobITvwKAOZzaPVD/kyYHVPeNb9e0d/0ehkyoNB7TiBTIh2zqd9f11uJRNnA3xR+4BnJTUp2Ax+gQcwkxYGBOwHtV8Sk5HXr7BEDrpNIcXe/Bf2U5UIUMkkyANDbYNolUsem42jN6PDNv3fh0tPKCaXxImnqHMQUF7ZmFVcRnSUGBW8O4EVaUyHpUpQK97HVqf44cWvdfprQrSctDiW/D3PfO/FUIeslltKAOVAZSRxoscZB0OYEjcedbuvhkdQtro0JB9z7mhLAygGEvkk6MDbnjwfGtQr4O59eqd2jwhxU/Op+nn6SW0QMcX+dUq3KUNHFcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SD7AmeLgFY/w5cL4D+jcglNNvkCEZ4ncfywi1R2JHHc=;
 b=MM1t9Gd4yMIu5OMRNzAeQdtVzJjcoPnnXryyPiFBQC1OOAALUQPwn3JFVCJyTMk88VY7EwhpHBFf+DTTbsAeWlFuQXGTRA8uXTDrevYgyKbmRLi88wD4qf580ZGisOIVTg2rRuNlxd7r2rUjuLq41kijynJJZq8BWprHNrYbLGV02BnQQHz8uPvYchVB9wKCeXPPkrX6BqvKuZhuUbrvaUOS2re81VdYLY7nq3XvGxEvDVfaJ5pVKdWAQda4SvgNOepWyVMzHrcH5knces9IzHa4tZftzRoOBp9piQPuROEm4otitS4tdTN0G+XMJ+c4nZnTExURy6HczH9jljYwkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5824.namprd11.prod.outlook.com (2603:10b6:303:187::19)
 by LV8PR11MB8700.namprd11.prod.outlook.com (2603:10b6:408:201::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.31; Wed, 13 Sep
 2023 03:34:06 +0000
Received: from MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c8f6:72a0:67fa:5032]) by MW4PR11MB5824.namprd11.prod.outlook.com
 ([fe80::c8f6:72a0:67fa:5032%7]) with mapi id 15.20.6768.029; Wed, 13 Sep 2023
 03:34:06 +0000
From:   "Zhang, Xiong Y" <xiong.y.zhang@intel.com>
To:     Like Xu <like.xu.linux@gmail.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "Liang, Kan" <kan.liang@intel.com>,
        "dapeng1.mi@linux.intel.com" <dapeng1.mi@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 8/9] KVM: x86/pmu: Upgrade pmu version to 5 on intel
 processor
Thread-Topic: [PATCH 8/9] KVM: x86/pmu: Upgrade pmu version to 5 on intel
 processor
Thread-Index: AQHZ3KYYF2BAvFXWeUSXQAL2obPP2LAXHJmAgAEPT8A=
Date:   Wed, 13 Sep 2023 03:34:06 +0000
Message-ID: <MW4PR11MB5824B8627CC41A5C0F3737A8BBF0A@MW4PR11MB5824.namprd11.prod.outlook.com>
References: <20230901072809.640175-1-xiong.y.zhang@intel.com>
 <20230901072809.640175-9-xiong.y.zhang@intel.com>
 <e0dea9df-501e-acd2-a81b-b5126ddc7be0@gmail.com>
In-Reply-To: <e0dea9df-501e-acd2-a81b-b5126ddc7be0@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5824:EE_|LV8PR11MB8700:EE_
x-ms-office365-filtering-correlation-id: 8a2260c1-58bf-48d0-c6fa-08dbb40a4899
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ENAACfFb1GO4zCJLLgP2oHEgStLF9sdf/7kivFqdgsSfL6zHgxp9Z3kK40PK9n/cX2UIh1hWuCwZGGmkJN2Le7t2iqcFLvnTXQ18bkcqTe9DRz19hOV11PwuECbpVxU4b7AJirRIZsLdkTZDFF0nF3fap+aPqoke07dN2MhV3EL0+syGt1tRJs/cv7Yw2A7QWYfytiRiaOsu586+71XULnROspafvqR0ADPhccpXNeNzmRHQV09VUEgDBeFr6mHIlTB8Rqmbk+/6CjYm4f4JJy9zjlaU12CBHFm5M34xjrO9wu2WCr+I/kGPeXkvQr2qRzmn6+6adC6Zgdmya5/u5wiP6hbXzGYZvhDfdCe11flStQal7gMSKaLOO3JwycmtOZWouPE8nD+9jhZ2y2pQeF/pXNF0SEpokRn1RQMgvdP4TP9acGLLWkUPhQBE2l812HWIiNFEEkYcHi0Ns6F7eWy5/rCTHB0J7DMFVpwP75iQvZ8zHCCqIgnnpgMnOjxo/IZyOWPSrJApGRhwJ9gvUIHNUYFyYcH2N2Fl6Lf+fYkvb8brxBX0PbJFC9Llq9vyRyPldA2x67s298YVC/dA11CaNxLLB0ilUYib3TVfKJl6bi25py+qY1rkMC//4Ws1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(39860400002)(366004)(396003)(186009)(1800799009)(451199024)(6506007)(52536014)(53546011)(7696005)(9686003)(38100700002)(71200400001)(83380400001)(86362001)(122000001)(82960400001)(38070700005)(33656002)(55016003)(26005)(6916009)(316002)(41300700001)(4326008)(66446008)(8676002)(76116006)(66476007)(64756008)(54906003)(2906002)(478600001)(5660300002)(66946007)(8936002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y1IvcVpWckNaVEMrNC9yVWxCYlAzMzJSaG8yOW9FR1hBeWpPY0pSR3gxRFNF?=
 =?utf-8?B?SFd1aG1hRU5CV3g3NkEvcVBwYTI0VlM2czA5RHBNUlJ0enJYTEFiYzVhaHNv?=
 =?utf-8?B?MitvYXlBT3F1NzBDNG1NUi9GV3JvVk5WMmUvK3pJRE9aNVluM0dLb3RZbWw0?=
 =?utf-8?B?UmYzVXNmZEhTMVQ0NGhxVHIycjFJTWU5RE1HMEhydlZPcExvTFJZM21aZlpN?=
 =?utf-8?B?VVhuWFZNdkdRekd2RGN6SnloSy9ieVlESWY0dEFLcVhubUxnNG4zNVdsQXpH?=
 =?utf-8?B?M2xBSzVQMlh2MmUyekRqWk9BaGJwb1BDVlZoeXNPZG0yTEFKdGVyeTUya3h2?=
 =?utf-8?B?RENRaDYvR1hhQURXZzdxMElDcnM2S20vNW5BUS9oRVNHK1Y3eVJkeCs3a1hE?=
 =?utf-8?B?RHRDRVFMQm00UmVHTTE0akxqMFJhVVRrTUxINWg2a2E0d1FHWStJcTBYKzBx?=
 =?utf-8?B?N1JudmNMYVhrYWF2UmFHOWRBaEFNYVkvWnRJY2VOVm5TbXJHNTIwN0V3eXk1?=
 =?utf-8?B?VTI2SUt4dmxRR091UzBDSGFRcllTTzJ6Z2Z4ajYxR2hXS3ZCSlFHSloxcHVK?=
 =?utf-8?B?eWRiV2lxK1BsWGVyU0dSZFJ4Rzh1T3dSWjlza2dFTnkwRlkyT3lWM3RVbERs?=
 =?utf-8?B?R1BRbzRDd2F3TytkTGJJcmhEbS9lUk8xb1lBbGJJOHc2dzBvalJ0VWdIRCtt?=
 =?utf-8?B?eG9TblVVZEVwNllWTXdZMkFSS2FsT3FDQXpHZjRFTndydXFpTkVFaGMzaDMw?=
 =?utf-8?B?amREaU1LVFBwdmFZRWZ6YVM2dlBEd0ptc2FGaFhpNkozcXczUHhBajVxSEtK?=
 =?utf-8?B?eFZFRGxzU1B6dUR0dFhhVXhJeXVlNUFhcTk2Q2d6dU9KMkNjdExrS2FsbTRF?=
 =?utf-8?B?RXZQc3RpWUNhMHdtbUpxdjFzR0Z5SnVKalFaZ2psWjVQV1RBSkZNRVNVYW9z?=
 =?utf-8?B?WkdDZ21oRTA1K0R1TGY3amRUcTRCbVRIZkt4WTB0QVdjdTVCdEpFY0NRNjRH?=
 =?utf-8?B?WGtGeUQ5TEtvMXdDODlrRVdCa0VaYVcxZkFPS29YV0lXeVI4K2E0cHBaNGFi?=
 =?utf-8?B?Z0xJRHYrVkZESHZjTkoyZXhOakFodDYwY1ljMFdDZGxieU9aRWcvL0xKWUlu?=
 =?utf-8?B?S0k1Rk5meUtLUHRUMUwrSUwwZXpVaG1CNTdsMEozNTRKOXNPdittVVBCMllZ?=
 =?utf-8?B?aC9qelF3Q3JkaWtKMEdLMCthZzJJOUNCeXlXS3Eya2JLd2lVTHc2SHRUY1dy?=
 =?utf-8?B?MW5XOEVtY0lmSjNQdm8zUStIeUI4ZGxjZXJTKzYrR25sd1ZUaURCcXp2UmpK?=
 =?utf-8?B?MmJHdWpBeXVSVjVuQk1TSzRKaGZ4Qy9aaVBUbXJCMlp2K2tPS1RSdDVTdnVR?=
 =?utf-8?B?L01CMUhRT0NCVWU2LzhRa3BZZTBEMnJpRFk2LzdGVDViOTE2WWp0NGk0Zzkw?=
 =?utf-8?B?b1laZTZFaFdOb0YwRHpMaWlWMUhwaUd0ZzJJU0h6ZTRLTFlBejdIWjlRbnhx?=
 =?utf-8?B?ZEhxTnprWTRRV1duSDgvekV2ZkFEZGVoMzkyb05YZzFoNnlzVktOdkFVdjhi?=
 =?utf-8?B?RkVXanNqb1JTOFVmT3lTTHlsUVFLT1Y2NUwrZW40OGNlYnhDSHN4NUdSYSs4?=
 =?utf-8?B?c1J1TDFKUGhhcHk0cHpEOUxMLzRnSFRxTjhDWWY5czdxd1FVZmdwN0hSc3Fu?=
 =?utf-8?B?akJMY21zSEExTG9RVFo3VHdmUHFtOUFVOWg0RWpBRWN5RE5UN0I2L1lNYUs0?=
 =?utf-8?B?cTQ3T0dRK25tYU5Sb0lJdDA5UW9BWjNaWXhsNmtyNzRlaXhJRnExQi8xa3Jl?=
 =?utf-8?B?NzA0TVJJWUEyZkZUOHJldmxBRDdpWC9VY2tuaTRCWjA3UFVQeDYwT2xNK0RS?=
 =?utf-8?B?UzhTcXNtK0h4cFVwMlhYb1dna1J2SU1mbDBld09jcG1kQ3F3R2VKRlJYcVE0?=
 =?utf-8?B?QnhmTm1SZDc1K0ozb3B1bzlOWlJiWndOdTdRZlNpSkdTaS92Y0k3OWlwbEJF?=
 =?utf-8?B?eUoyS2RJT3gyR3d1RHkrY2xia2cwRGF6WHY4eEF6N2xxQ3hMVXk3blJqRk1O?=
 =?utf-8?B?K0pMZGVjeTBEblFaWDF5VTdSbzdvckRXZmMyRFA3T2gvVUd3QVNVTDBVOVZq?=
 =?utf-8?Q?strYap6GVu5QK4LKledtYjx9I?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a2260c1-58bf-48d0-c6fa-08dbb40a4899
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2023 03:34:06.3472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5mCgUVOIfsX2NVBBQjdpqFsrpabEu2kEM1FohwFTKC8hPQA0htoz44cEnAF+GUqQgSbd8kAEVL1sPOVMQPOM3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8700
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiAxLzkvMjAyMyAzOjI4IHBtLCBYaW9uZyBaaGFuZyB3cm90ZToNCj4gPiBNb2Rlcm4gaW50
ZWwgcHJvY2Vzc29ycyBoYXZlIHN1cHBvcnRlZCBBcmNoaXRlY3R1cmFsIFBlcmZvcm1hbmNlDQo+
ID4gTW9uaXRvcmluZyBWZXJzaW9uIDUsIHRoaXMgY29tbWl0IHVwZ3JhZGUgSW50ZWwgdmNwdSdz
IHZQTVUgdmVyc2lvbg0KPiA+IGZyb20gMiB0byA1Lg0KPiA+DQo+ID4gR28gdGhyb3VnaCBQTVUg
ZmVhdHVyZXMgZnJvbSB2ZXJzaW9uIDMgdG8gNSwgdGhlIGZvbGxvd2luZyBmZWF0dXJlcw0KPiA+
IGFyZSBub3Qgc3VwcG9ydGVkOg0KPiA+IDEuIEFueVRocmVhZCBjb3VudGluZzogaXQgaXMgYWRk
ZWQgaW4gdjMsIGFuZCBkZXByZWNhdGVkIGluIHY1Lg0KPiA+IDIuIFN0cmVhbWVkIEZyZWV6ZV9Q
ZXJmTW9uX09uX1BNSSBpbiB2NCwgc2luY2UgbGVnYWN5DQo+ID4gRnJlZXplX1Blck1vbl9PTl9Q
TUkgaXNuJ3Qgc3VwcG9ydGVkLCB0aGUgbmV3IG9uZSB3b24ndCBiZSBzdXBwb3J0ZWQNCj4gbmVp
dGhlci4NCj4gPiAzLiBJQTMyX1BFUkZfR0xPQkFMX1NUQVRVUy5BU0NJW2JpdCA2MF06IFJlbGF0
ZWQgdG8gU0dYLCBhbmQgd2lsbCBiZQ0KPiA+IGVtdWxhdGVkIGJ5IFNHWCBkZXZlbG9wZXIgbGF0
ZXIuDQo+ID4gNC4gRG9tYWluIFNlcGFyYXRpb24gaW4gdjUuIFdoZW4gSU5WIGZsYWcgaW4gSUEz
Ml9QRVJGRVZUU0VMeCBpcyB1c2VkLA0KPiA+IGEgY291bnRlciBzdG9wcyBjb3VudGluZyB3aGVu
IGxvZ2ljYWwgcHJvY2Vzc29yIGV4aXRzIHRoZSBDMCBBQ1BJIEMtc3RhdGUuDQo+ID4gRmlyc3Qg
Z3Vlc3QgSU5WIGZsYWcgaXNuJ3Qgc3VwcG9ydGVkLCBzZWNvbmQgZ3Vlc3QgQUNQSSBDLXN0YXRl
IGlzIHZhZ3VlLg0KPiA+DQo+ID4gV2hlbiBhIGd1ZXN0IGVuYWJsZSB1bnN1cHBvcnRlZCBmZWF0
dXJlcyB0aHJvdWdoIFdSTVNSLCBLVk0gd2lsbA0KPiA+IGluamVjdCBhICNHUCBpbnRvIHRoZSBn
dWVzdC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFhpb25nIFpoYW5nIDx4aW9uZy55LnpoYW5n
QGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiAgIGFyY2gveDg2L2t2bS9wbXUuaCB8IDUgKysrKy0N
Cj4gPiAgIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4g
Pg0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vcG11LmggYi9hcmNoL3g4Ni9rdm0vcG11
LmggaW5kZXgNCj4gPiA0YmFiNDgxOWVhNmMuLjhlNmJjOWIxYTc0NyAxMDA2NDQNCj4gPiAtLS0g
YS9hcmNoL3g4Ni9rdm0vcG11LmgNCj4gPiArKysgYi9hcmNoL3g4Ni9rdm0vcG11LmgNCj4gPiBA
QCAtMjE1LDcgKzIxNSwxMCBAQCBzdGF0aWMgaW5saW5lIHZvaWQga3ZtX2luaXRfcG11X2NhcGFi
aWxpdHkoY29uc3QNCj4gc3RydWN0IGt2bV9wbXVfb3BzICpwbXVfb3BzKQ0KPiA+ICAgCQlyZXR1
cm47DQo+ID4gICAJfQ0KPiA+DQo+ID4gLQlrdm1fcG11X2NhcC52ZXJzaW9uID0gbWluKGt2bV9w
bXVfY2FwLnZlcnNpb24sIDIpOw0KPiANCj4gRm9yIEFNRCBhcyBvZiBub3csIHRoZSBrdm1fcG11
X2NhcC52ZXJzaW9uIHdpbGwgbm90IGV4Y2VlZCAyLg0KPiBUaHVzIHRoZXJlJ3Mgbm8gbmVlZCB0
byBkaWZmZXJlbnRpYXRlIGJldHdlZW4gSW50ZWwgYW5kIEFNRC4NCj4gDQpHZXQgaXQuDQoNCnRo
YW5rcw0KPiA+ICsJaWYgKGlzX2ludGVsKQ0KPiA+ICsJCWt2bV9wbXVfY2FwLnZlcnNpb24gPSBt
aW4oa3ZtX3BtdV9jYXAudmVyc2lvbiwgNSk7DQo+ID4gKwllbHNlDQo+ID4gKwkJa3ZtX3BtdV9j
YXAudmVyc2lvbiA9IG1pbihrdm1fcG11X2NhcC52ZXJzaW9uLCAyKTsNCj4gPiAgIAlrdm1fcG11
X2NhcC5udW1fY291bnRlcnNfZ3AgPQ0KPiBtaW4oa3ZtX3BtdV9jYXAubnVtX2NvdW50ZXJzX2dw
LA0KPiA+ICAgCQkJCQkgIHBtdV9vcHMtPk1BWF9OUl9HUF9DT1VOVEVSUyk7DQo+ID4gICAJa3Zt
X3BtdV9jYXAubnVtX2NvdW50ZXJzX2ZpeGVkID0NCj4gPiBtaW4oa3ZtX3BtdV9jYXAubnVtX2Nv
dW50ZXJzX2ZpeGVkLA0K
