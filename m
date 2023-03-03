Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B796B6A8EFD
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 02:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjCCBxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 20:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjCCBxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 20:53:07 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87C61ADC7;
        Thu,  2 Mar 2023 17:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677808217; x=1709344217;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FLa0cv+yud1SSOBXLdHjDgKVqwm7C1jrzAyH1GwTu9k=;
  b=aCnX+jRfE1gbzWCq0gMQ+KaniiYL6mQ/0CrCkaMsjvDDB9OVGvEcSNmT
   Qu+eP0HAjzqGXiUZuuwyc+1ppYtCJUSMk9y+m1DPQgjMy+oz3xMbYAlz3
   rAZQrfY5mjvkdulHlE7fY12+Nxx1Yhb3QoMlFxO0B4K5227pZr7RzDSso
   +jhY+WasRTxkX+U9Rzh1zlfXvO/W0RHN5doKH/VhmSwPE9kN9ayhjPcOY
   meu2aixTUpCMD9o9qmNX6Nbo0BHKx+65LrSR4xfVjkpzCzh/NGyBgYXVc
   kX6r08BDh0ndnXT0ZAaMxS/qCaeAHNj535Jyk1Gck7XUwC9KFvhVUDTe+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="399730794"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="399730794"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 17:50:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="785088364"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="785088364"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 02 Mar 2023 17:50:02 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 2 Mar 2023 17:50:02 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 2 Mar 2023 17:50:01 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 2 Mar 2023 17:50:01 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 2 Mar 2023 17:50:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRxT5Lteyk4bagJZedDW90aWZgtEB8ZcFru54YH2e0l/ZOmzqc6N+N/lHtDWKICpBm4mrhgAsQFLEXEB9XCKLOG+s7sDiX440KsCrqMTphvJjCHs8hRl1wgQayCPesuoiA8Jjc3sJCEqLhpals1F847yImyKqcxBI5DCyThuefS+XoetztOzf6rMJMkMjZeCuTfvIzljUxbJvkMmBJ/A4x5bXd6fFc8Dy7aeZJ6gGXC2cgZlRXMOs+7mEjGiEEM33wJK/wT7Fn5byfRAVtfSyCBBF8kKm39XUjY9Mr3ORcqGtR32l1wkMhOR0dupL6pI5DxXoEAUtE7wfQvMwL/QfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FLa0cv+yud1SSOBXLdHjDgKVqwm7C1jrzAyH1GwTu9k=;
 b=B0kLojTUwLg/XAss8DFLSoea8F1YWowX+iPpK4fotqXHNvPN/5aRKNTGJHTFoahGV6Vi0Ogu8e8BV0AR9c5OvDL2oDwkEyAgbER9Oxjfs99iG4JwBWMSGk9Wp9cI86IUppsL2Jvu4WeAoxlj0n4exnx/mNPni9TZgyK2Zmor3hXnqg22x3BoRwdHqL7AsaY1rAj6ylBT9Jz+fyQFvEA6VsVH4a7S8fH13PM6LwbcCgGL3Hxg5OVjEDHWs6tCG6L2PjGSq8k1hEo8FCBB1YgoyDbADf+ru4AUr0LgHvXFJrONCEFyr/SH//CRn5lU6YLmsDQ74b0WwRec4KBfSk+Fuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 SA3PR11MB8024.namprd11.prod.outlook.com (2603:10b6:806:300::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Fri, 3 Mar
 2023 01:49:53 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::7f91:b0b7:7b23:fa58%8]) with mapi id 15.20.6156.018; Fri, 3 Mar 2023
 01:49:53 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Mingwei Zhang <mizhang@google.com>
CC:     David Matlack <dmatlack@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Thread-Topic: [PATCH v1] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Thread-Index: AQHZTEMoO+JAZhQRUE2mrtrpaO2QJ67mVMSAgABZTgCAAD+sAIAAV8fggACG/4CAAHmhIA==
Date:   Fri, 3 Mar 2023 01:49:53 +0000
Message-ID: <DS0PR11MB63735E9AC8F4636AF27DAA4ADCB39@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20230301133841.18007-1-wei.w.wang@intel.com>
 <CALzav=eRYpnfg7bVQpVawAMraFdHu3OzqWr55Pg1SJC_Uh8t=Q@mail.gmail.com>
 <DS0PR11MB637348F1351260F8B7E97A15DCB29@DS0PR11MB6373.namprd11.prod.outlook.com>
 <ZAAsIBUuIIO1prZT@google.com>
 <DS0PR11MB6373DAA05CEF9AB8A83A6499DCB29@DS0PR11MB6373.namprd11.prod.outlook.com>
 <CAL715WLo90-JkJe6=GfX755t1jvaW-kqD_w++hv3Ed53fhLC3w@mail.gmail.com>
In-Reply-To: <CAL715WLo90-JkJe6=GfX755t1jvaW-kqD_w++hv3Ed53fhLC3w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|SA3PR11MB8024:EE_
x-ms-office365-filtering-correlation-id: 75598c26-8e41-4fd4-6217-08db1b899570
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f9Pm5rsgk8N+4gwZxumaHHVWmTjXl0oDa6tR/RWcVjIelwtlrg/Zppeh0vSE5aBo/JT7gui6EMd/VMoBC76Ix7N6fS4QS3Z05WUEVN9VMRzb+8Uu45u8XQg1cHjG/tkCvhcE8gOADyOu/kDSSQbGw53IAaRX0ATJOj0XMQ4xn1fj5IEKlq3JcaKBXQaM6vQ4fb2MtNyqKWNdUUl1nVwAEgy2bpTrC4iHQpqP9HGTIe3Hs3EaMeKIGw4DE2CRIpO4sCQnhExncrDNQ8rwKTPo5CPDemu7TvxlS5uUwmD/fVGpVobVbzfQ2i0tf77gPJLvd4C8YyBgJg6YQW89DuBmmwihJL5pUseeOtaNvwmU0KwSUQECm9Nm0beQwjJGlYhSenQWlEPtA5NPjkxxQ0TrNuL9v1GIouZMU1/VmAs5ojCLbfpa8BWSU8xdsgYwRffYXJMT6ARrrb83ajnRQfOigvpiHtRzJQIvtR7oxRKRNmM7TRhzCmC+oAMDmbv+VhFB3Z4qtLpKgNZCdiGmytS3I55Mp4Q7V8Ll9yT+G9MjEncbKYCi6j9sAAi61aLJ0BKn2jj3tB1zkz/V8qN/NrpTMuqy89eqN7fsq2AP3N1C4ipqbznkrCb1F4SnTM8BpsZ+VxUOlVnpvM/USegxB4JIjVjnZ4Pr/7dAoDA3bCxxsXzMTCeodgqK6Tj/2bdnXSfbLlRXmQ4v+JpzcStaOnY8ig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199018)(53546011)(6506007)(9686003)(26005)(186003)(41300700001)(54906003)(316002)(76116006)(2906002)(6916009)(8676002)(64756008)(7696005)(66946007)(4326008)(66446008)(52536014)(38070700005)(8936002)(82960400001)(33656002)(478600001)(5660300002)(38100700002)(71200400001)(55016003)(86362001)(66476007)(66556008)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?akxHaDJMOUlibVVFcGdwckxvU0E3ekZxZ2s2QjVQTHgwUVM4Vm0xdjdFZEJl?=
 =?utf-8?B?V0owdmFPQUdlT3o3WCt6aU5wY3B6YUNIVTMyTCtvWmtxNnU0VUdGQnFZaTFq?=
 =?utf-8?B?MU10YkN4MVhBUXZVQUJqc3J2TlBicWsrQVovMnl0YUtkRnFXQi9XS3YwTHdI?=
 =?utf-8?B?Z3UvK2tHamY2L084L0FHaHJsUHZmZUpsVjFnRnF0MlF3K01rOU1WTXdPSElE?=
 =?utf-8?B?T3JTcDVHeW01SlhmWitLWnp1a2p1MkJlamVtQUZjeDFkKzNQRmZLbWlMeFJX?=
 =?utf-8?B?VWlDY1dSOEZ4cWppNzIzOTBSUzVPbXNsazY0cjJrY2tieVpnZ0RHVkxZTXlQ?=
 =?utf-8?B?QU1wRWdHK0phOU5mR1NyOCs4dDQxdGxLeDJBTk5iNUh1RlRrMXlGSlBVTVFJ?=
 =?utf-8?B?TndqSWEzSHZYMzBqTWx1am0xd3ppNmRjNlJyUWw2QjN0NFBJc24vZTgzZ1Nn?=
 =?utf-8?B?SjY5dFRDTEphZXhoV2pTc2tZazZSQWR2SzRGbTFPWXhJMHhaNHY1aEtwbWRQ?=
 =?utf-8?B?SFZ2ZGNaQml1US9aN0V5R2ZDSkxjSWgyR1dRcmpvTVZvRmw0emNzRkhmaW9s?=
 =?utf-8?B?WHQrNVdYUDg4VmlpWklGbkorQm5oT01nc1o0UjlmdVJ3TXpyM2tjLzB5WG5V?=
 =?utf-8?B?NWxqYlhMcnlML0tEeFhlaXpjbmFIa1pxUnZIbkNjRW1kcjd1RS9jdmt5aXY5?=
 =?utf-8?B?bUJBWFJSQStCOUxKYkZMdThMdmEvWHoyaGx4Yk0yWjVXZUVucVFHT2xQVThj?=
 =?utf-8?B?MGZENlk4TlhhUkdJcUFFRXNZc0VqcGFiWGxkS2FNN2RpdGcxSkZ2ZjcxbXFM?=
 =?utf-8?B?dFBaU0RPSCsvNVdkc3lJVkxQb3hjU2d1Z0ZkQWNEKzJTQ2ZPa1JBYUoveG9X?=
 =?utf-8?B?VlhNTlZoNGNZNFFwb2V5cXRxNlIzcks3SFF3aUc1d0RnL1NHZitYTW56aXl0?=
 =?utf-8?B?WDQvVjZ4NlN0UXJid3VlVHdTUk0xdE9jM1ozZ3ZZUDJxZWE3S0tSQytXaklv?=
 =?utf-8?B?ZWJsVEFpTHovNlRPNnkrWG8vOEpoYldZMWZ4ZzJsVHYxQkRyaGlOWXJScmlw?=
 =?utf-8?B?ZmlnTy8vTXNDanFabE1UTVdObGlJUmtwZ2s0bURWc1VIbjZpNXJvSVQwbnFE?=
 =?utf-8?B?b1REbE0rYWdsYmZLRHhBVWhSTk1JRnp1TUdSbmlHUXBPUmR4NDkycm9odU9M?=
 =?utf-8?B?cGZxMTIrUnJtUzdSMGRQODFCOXNjTG43T0dvZ1dwcFNLMi9PbGtBK3lDTHFZ?=
 =?utf-8?B?dWF6NWlIckhqK2l5RHlDYU1keGp4VlUyVFgrcGg2alVvK1JHaTZyRlpTczBT?=
 =?utf-8?B?TUVyb2VmZmV2OTk1ekMxVERzNWJuZ29uaXpadVhTbW1xZFlXMU40UXNWME5t?=
 =?utf-8?B?MVlVelBYdjFBZUtNT0FwQldtSEFWaGtxRC96VFBFRUxaRUZnVm1mUGdsWUZ0?=
 =?utf-8?B?MmJYOHRVMG5adGxWYTEyU0hWOVRNcUtUWVR6WU5tb0MwSG84cjluVEk0Ym1a?=
 =?utf-8?B?QVdxYnEvUW42RVJzWG91Y1h0cVVuU3NIUjl0SzFzNTlWTlo5VEVJazk0LzJi?=
 =?utf-8?B?b0E3RklnejNHYlJiOHJNRXFLcld1VUtTWk8rRlpJK1VBZ2lwYmJ1dXNBRFBN?=
 =?utf-8?B?QU1wWU52WkJXekhicjIxVVJ6bng5alNyeTMrdDAxb2ZGSGZwYS91YVBZbTQz?=
 =?utf-8?B?NjFObjB6KzlBK2NUckNtZS90SHVqTEwzdFlXNWprZ2RENVZjcllQYTkzTzFk?=
 =?utf-8?B?bDZ0SncvZ1l0WWtRdmVUTlZOWnBwcUhrc3lzSm5DK2lqN1F6c1oyZmVXQUlK?=
 =?utf-8?B?anlzQVU1eVFNbXYwMUovZFdzVGszSVF5cStzVFUwUGxBZllra28zNVVlUVlC?=
 =?utf-8?B?QWtyS3B2aWRCVUZhWW5idXBSVjZuc2ViWHBaMmRnS1RZTUxldzBOYllubkNQ?=
 =?utf-8?B?eFZxcHhZWTEyMEpFdE4vaEhNUlc1MVZlM1kvcFhQUE1NSVF1TUxvNU56QnhP?=
 =?utf-8?B?cnNKZTkzOHJ5L0x3ZXkwOW9PQytMaUtKRS9DcUt2UEN4NjZHOVZYQVRjQzBE?=
 =?utf-8?B?WmFGSjhNTVExa2l0K0NPWGxrUjI4Uys4cHJva3RYTzIyR2JYV01VZ2NXU0xM?=
 =?utf-8?Q?5ri4jOUDRjMYlui4uV1+Mjt/l?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75598c26-8e41-4fd4-6217-08db1b899570
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2023 01:49:53.4540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UcTugepo+QDiS3v65pJ1jxZwCmdPxF/9l0VHmJPjh1apV1dxMNLX3Pg0mqEMt47OfcFXMSumgiCx6pZ2sZFVOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8024
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpZGF5LCBNYXJjaCAzLCAyMDIzIDI6MTIgQU0sIE1pbmd3ZWkgWmhhbmcgd3JvdGU6DQo+
ID4gT24gVGh1cnNkYXksIE1hcmNoIDIsIDIwMjMgMTI6NTUgUE0sIE1pbmd3ZWkgWmhhbmcgd3Jv
dGU6DQo+ID4gPiBJIGRvbid0IGdldCBpdC4gV2h5IGJvdGhlcmluZyB0aGUgdHlwZSBpZiB3ZSBq
dXN0IGRvIHRoaXM/DQo+ID4gPg0KPiA+ID4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgva3Zt
X2hvc3QuaCBiL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaA0KPiA+ID4gaW5kZXggNGYyNmIyNDRm
NmQwLi4xMDQ1NTI1M2M2ZWEgMTAwNjQ0DQo+ID4gPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2t2bV9o
b3N0LmgNCj4gPiA+ICsrKyBiL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaA0KPiA+ID4gQEAgLTg0
OCw3ICs4NDgsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQga3ZtX3ZtX2J1Z2dlZChzdHJ1Y3Qga3Zt
DQo+ID4gPiAqa3ZtKQ0KPiA+ID4NCj4gPiA+ICAjZGVmaW5lIEtWTV9CVUcoY29uZCwga3ZtLCBm
bXQuLi4pICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ID4gICh7ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gPiAt
ICAgICBpbnQgX19yZXQgPSAoY29uZCk7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIFwNCj4gPiA+ICsgICAgIGludCBfX3JldCA9ICEhKGNvbmQpOyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgXA0KPiA+DQo+ID4gVGhpcyBpcyBlc3NlbnRpYWxseSAiYm9vbCBf
X3JldCIuIE5vIGJpZ2dpZSB0byBjaGFuZ2UgaXQgdGhpcyB3YXkuDQo+IA0KPiAhISB3aWxsIHJl
dHVybiBhbiBpbnQsIG5vdCBhIGJvb2xlYW4sIGJ1dCBpdCBpcyB1c2VkIGFzIGEgYm9vbGVhbi4N
Cg0KV2hhdCdzIHRoZSBwb2ludCBvZiBkZWZpbmluZyBpdCBhcyBhbiBpbnQgd2hlbiBhY3R1YWxs
eSBiZWluZyB1c2VkIGFzIGEgQm9vbGVhbj8NCk9yaWdpbmFsIHJldHVybmluZyBvZiBhbiAnaW50
JyBpcyBhIGJ1ZyBpbiB0aGlzIHNlbnNlLiBFaXRoZXIgcmV0dXJuaW5nIGEgQm9vbGVhbiBvcg0K
dGhlIHNhbWUgdHlwZSAobGVuZ3RoKSBhcyBjb25kIGlzIGdvb2Qgd2F5IHRvIG1lLg0KDQo+IFRo
aXMgaXMgY29uc2lzdGVudCB3aXRoIHRoZSBvcmlnaW5hbCBjb2RlIHdoaWNoIF9pc18gcmV0dXJu
aW5nIGFuIGludGVnZXIuDQo+IA0KPiA+IEJ1dCBJJ20gaW5jbGluZWQgdG8gcmV0YWluIHRoZSBv
cmlnaW5hbCBpbnRlbnRpb24gdG8gaGF2ZSB0aGUgbWFjcm8NCj4gPiByZXR1cm4gdGhlIHZhbHVl
IHRoYXQgd2FzIHBhc3NlZCBpbjoNCj4gPiB0eXBlb2YoY29uZCkgX19yZXQgPSAoY29uZCk7DQo+
IA0KPiBobW0sIEkgdGhpbmsgaXQgaXMgYXBwcm9wcmlhdGUgdG8gcmV0YWluIHRoZSBvcmlnaW5h
bCB0eXBlIG9mICdjb25kJw0KPiBlc3BlY2lhbGx5IHNpbmNlIGl0IG1heSBhbHNvIGludm9sdmUg
b3RoZXIgYXJpdGhtZXRpYyBvcGVyYXRpb25zLiBCdXQgSSBkb3VidCBpdA0KPiB3aWxsIGJlIHZl
cnkgdXNlZnVsLiBGb3IgaW5zdGFuY2UsIHdobyBpcyBnb2luZyB0byB3cml0ZSB0aGlzIGNvZGU/
DQo+IA0KDQpNYXliZSB0aGVyZSBpcywgbWF5YmUgbm90LiBCdXQgaXQgZG9lc27igJl0IGh1cnQg
YW55dGhpbmcgdG8gbGVhdmUgdGhlDQpmbGV4aWJpbGl0eSB0aGVyZSB1c2luZyB0eXBlb2YoY29u
ZCkuIEFzIHNhaWQsIEknbSBhbHNvIGZpbmUgdG8gdXNlICdib29sIHJldCcsDQpidXQgcHJvYmFi
bHkgbm90ICdpbnQnIGZvciBubyBnb29kIHJlYXNvbi4NCg==
