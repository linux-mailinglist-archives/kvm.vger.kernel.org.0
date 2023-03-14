Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003036B873A
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 01:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjCNAu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 20:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCNAu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 20:50:57 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2618D6A9DE;
        Mon, 13 Mar 2023 17:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678755054; x=1710291054;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TjHCVmJOGKhepo5Nj1r1vI/c2yB6OftAlp9qbZ+9v3c=;
  b=h2ZQYKBXpzB7efULvIuEd+P6bf050gtxeFTzGzEU233sCmyp5ROSAaHe
   4idEfvvtyaVKyAoVWHY14DQGl37iFBai9GeV91SJ9Q/GU/TCY9tfvPcb5
   Eph3oMONxlYxXEE2W6Ak0pvymrdXX9e99yQuw2ISpQbRYqOh+eboNWuMb
   huHBZRrL0YVEA/jBfwm1tIqZEFyxxynHE0vB7v24KL98zZg72AUq8ebDb
   WmiN69wbwWlW3jg7fBxhgDSPQAaY4T0KvIRg/oSX+Ridm7NijvqZSijQO
   4HsPHuETQKvnpz1qO6nUDuLJGA2Nqi3CBMPURTknmVCwoGSo5iTDwlUap
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="364959086"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="364959086"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 17:50:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="924707192"
X-IronPort-AV: E=Sophos;i="5.98,258,1673942400"; 
   d="scan'208";a="924707192"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 13 Mar 2023 17:50:48 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 17:50:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 13 Mar 2023 17:50:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 13 Mar 2023 17:50:47 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 13 Mar 2023 17:50:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jzeG9vZ87UE9BR/HFb91wtLRcaC1R5osSFokuzV3ELblZFG81ncy8JdhNGNRw6ueSmysXNj1owmGE4WpxE1iaGCPnUgXrWCL31EqSU+n7jlCj0y42i0y25YXD/EwSfVbDl1zpj73VzdhH8XIEBWUTd9XwaNkFP5WVFTRWmX2dA/0pLUxv8Pn2vm1NxBpUHaQi2pGnqpKvpnYl0ZhljQkIHKs6IvoM4ZgMqOCpshPxag0qA5X3Ccr7zFbLRDYVXkOJMRw/O/XiWC8Yul6uKiU+xczEw+w2rPBFBtI30gd190CBOdDfkDkCe5qXq6EpzUdtmT+TSGudSpXpubw/wZwMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TjHCVmJOGKhepo5Nj1r1vI/c2yB6OftAlp9qbZ+9v3c=;
 b=MeiasEYBzXIKJ+vGLWkc8HymKFC0vGedCvRk5HEBCjLbvuhSnHy8JljYSczpsAxkcB58oX3EBudq4MOr2niD6SsEFz2K4kaNca+9zlMioxRWlZTRLa8TPqYl8oTi+MF6nwpW6+xGLNxLC0oBPBlaSIYmcYiKyZ5uqLmSjDXCcHiIaz11YI3n+EAbni9ze+y597ZwvIF8Pg3T8LmgSpS8cfQ6+RtfceGuLtiQrkLsLMQgSSEv6gP0xf+nOd/dE7gBwGN9u89hSBwJrD17qiKKEKXPZU9rvHeAS7JBqywNwT0khZJjR24dFtNaaO+1CkJ+Elhs8U2vEHu+jF2ika3eSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7915.namprd11.prod.outlook.com (2603:10b6:610:12f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 00:50:44 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::f403:a0a2:e468:c1e9%5]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 00:50:44 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "Gao, Chao" <chao.gao@intel.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 07/18] x86/reboot: Disable virtualization during reboot
 iff callback is registered
Thread-Topic: [PATCH v2 07/18] x86/reboot: Disable virtualization during
 reboot iff callback is registered
Thread-Index: AQHZU5lLewEuXoBLxUmZ/uq2XZMwc6735YIAgAEp9QCAAGdWgA==
Date:   Tue, 14 Mar 2023 00:50:43 +0000
Message-ID: <1e96938021610b5c65f25eb2b32544e7e511d679.camel@intel.com>
References: <20230310214232.806108-1-seanjc@google.com>
         <20230310214232.806108-8-seanjc@google.com>
         <4ab086ad30cf5e1ddea863e1a2bcfa21ca72d37e.camel@intel.com>
         <ZA9t04+rtW22AMQq@google.com>
In-Reply-To: <ZA9t04+rtW22AMQq@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7915:EE_
x-ms-office365-filtering-correlation-id: bb2decd8-dbb4-46ef-c9f2-08db24262450
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V70Kig1FlQb6atmAMZuLs04qpnC1gEWM6PJ4mAiu004JD5kNSXsztbGwfWn1eDi7SP++j/7FvWW2h4cLdZoGze9qDO03ECkpmXCRf8q1UHdlS0GsklF7M+WbFTAh3HoxL96Emh7RSBmmcpFlzkYMuFjVwPBwTMap9QPVpkgziQf8z/lru9+QossiIn4MecdJwqvdjfgy84mP77T4VqERTrHQq5zVDFe5rJ/K3meXssMw4IW2GVrjVEgDdRxo/0mUHX+CLR3N2KKceejYQbp5S5F/gushMjIRxkFgOWBgN8rwI9FppHLA6t4wa+4cVGZrjk3SSVayFbCpPm7xEMO9xk/9Ku9evMJCK1+hyupRFNUEKoq4r3z2/08uYTf50ePx2w2T9iiuLveTatvQBn1XDy448+G3se3gxmKAyfh2vMgNTuLigrNHbm2NVlQMc8lAo5WUmtsrbzKMft3BMKZEimMSYQaRAdx02lseCAAQGi3OvgN0y7kBN+ky5V9v1jTVeiezqRq5CzbkVdbSea+aXXAy/4eAnrCgSrXFd/UwwyNEW51ZWKZI7D+dbT9/CSGxRbS0NtHGZ7UnDFTwN+nf8zVn/eUTiq0eFNlryMbWF33JaEdsM+h5Ev7UxWsMX9FvwdjgyXo3FIIbSN9LeAp8HNK3BEEtHd6MMsmmb3nywc5v2mSm7kHnDw1FJGCng6DZ6UcdDT0QLSixLo85hQiACg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(376002)(39860400002)(366004)(396003)(451199018)(6916009)(7416002)(4326008)(5660300002)(8936002)(2616005)(41300700001)(26005)(6512007)(186003)(6506007)(36756003)(86362001)(2906002)(76116006)(66556008)(66476007)(64756008)(66446008)(91956017)(8676002)(6486002)(54906003)(71200400001)(316002)(478600001)(66946007)(38070700005)(38100700002)(122000001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WW83TERBY3M2V3hkaG00WitRVkpMRUJsbmdlZHdCYi9ySGlLSXFwbTErMmZj?=
 =?utf-8?B?MWZoZHVFZE93cEpHTlc4TWttWUpmQzJEWWx5d0hTNmV4N0NBaVZjejEzZ0tv?=
 =?utf-8?B?dnRCZUxIaDhWTFVDL1FobkVlanNMQ0wvaTBhL3RqM1BzZ29XOVBMSXlwY21w?=
 =?utf-8?B?L1pCeTJRWStxVHZTdzZPamJ2blZHREhZOVRpL0Zya051b0trUEFFZm5mdXJu?=
 =?utf-8?B?Wm5uclg5UmU3cXloL0o5OXQ1TUlnbnJGaHE2UTFhcS9zWXJyY2d3bHh1di9C?=
 =?utf-8?B?QlZ1N05ESFREM2I4NHhSVWpqZHpPRVlhQ0ZIR2hyWW9nOFJXMzhiR2sxTUJz?=
 =?utf-8?B?Z1RDbzVnbWVnM2pQR1UyV3B3TVpsSTRubGN4SVpCcnNaYTZrNWVuSFZGdGR0?=
 =?utf-8?B?djllK2RwaHNqM29ZSkh3MW9jNUpHV2tBaFphSzg0UUlJYTQ0YnR3YUUvTnFk?=
 =?utf-8?B?UkxCYUNpMGRMQnE0K2FMTExWcHpNSnl6Y0RmdFpoQ1FQNzJCMDlBblZsbFh2?=
 =?utf-8?B?TFdWcEdVbkpzUXFZL0tPNGNsNCtaeVhKTDNNTFNPaWxadnFZU3hiNWRIRFZn?=
 =?utf-8?B?YVByZHBGWnltWnJZTk5ldzd5b1YxNXZSemJwL0oxVmZLVkxIWm0rWHFySkIr?=
 =?utf-8?B?a3FyQWduTzh4RWNmbU94Rko0Rndmbjg3YmhFdlltM1EvK0hiTU9uSFVCck1V?=
 =?utf-8?B?Q2VIaE4vUE9oa1VJUVp1YUtDRmJlVE5lR1ljRFpMbkJteXlZVk85RU5JRUh2?=
 =?utf-8?B?cit0K21hQUJ4cVM1aFZ1RUZQWGxhNThZeVVhcmhHbEdqU0kwb1Z2TE0zTTA4?=
 =?utf-8?B?NFFjSkcwMkx5V0VrOEVmVkJaaCtJaWE1Y1B4TitqdWtESzVpYXd2cUtRQlo5?=
 =?utf-8?B?c2V2MEVpRzF0MUdDN1pMYWYrOE9tc0ZIZGFDYTU5ZU9heDhqOVA5VUdwTURh?=
 =?utf-8?B?NFRMYmI5SWhncHRPckdOTzVYWGVPQlRFampBZ0Q2M0dicTN0QnNQOFJZSmVr?=
 =?utf-8?B?WkMvck5nTHFERzFEcG42MFJkN01XNTR5bFA0Q04wRk51cE5DS2x5ajI1RnZz?=
 =?utf-8?B?Z0VLQTlDSjdhK3FEbGZ2dTdVSkdjbERXMnpkRUZXUGRxUWJXdGorazhjSHEz?=
 =?utf-8?B?dTdQSUZqTGU3THM1bGpCSGliSWMzalFGQzFyam04YVA5bm8vMWl1NmUzY3Jx?=
 =?utf-8?B?L1VqSXd4TkdIeDI2K3kyR2RWUDVmZm5wbGI4a0paMFE4SXFuQVo2REdsTUVU?=
 =?utf-8?B?NkJmY081V1FibWRpZXJwMU5RZVk1MlprQzVVT1FJc0FJemJBcVJFRnpiQWZB?=
 =?utf-8?B?RXNWK21XcHVlYXVaLzg5SmRPazRNSGRvUE1jTzhDRFNPMzZ6M2Y1NXRzWUdP?=
 =?utf-8?B?L2w4d2RRT0FpaEhaMXlDOUQvL1J3VzkxYVU3SE1qLzZCZXEweGFXNUhlOGwv?=
 =?utf-8?B?TWFESGhpVWxQRVkwYTU2eVhVTWV3ZnY4TlRoR09LNzFxUzJLR3EvSUJnL01P?=
 =?utf-8?B?ZE5Nd2tYa3hoVTNwc2Jaa3ZqZG5xdzMrclE4RlFsSit4QmtiRHR5VVJlOTRw?=
 =?utf-8?B?RWVxQzFTeVRTMml6MFA2cFBkUGw5SkphM3M5cVV2NkNYVVZFbjBrc1o2WVJ6?=
 =?utf-8?B?WHk5RzJNUkQxaVN0WElST0RrWE11SGFISGtXNlZiVEU4aHRXTVpTTG5pVnlz?=
 =?utf-8?B?Y1lRTnlROFRQNVdyemFoeWJDZm5XRGE5L1hsY2NWWWFsZHJIN0RtdWwraHJm?=
 =?utf-8?B?WlNEemtyWDJYeW5ENWpGbm5OYjkyTUpkK1plZmxsZzJlOGJ3Y3FmU2FUZ1lQ?=
 =?utf-8?B?Qk1sK25LTnBaQzJqSjB4bStiWmg1NGQvKytIV3ZUL2Q0VVk5WE02ZVJRYnIy?=
 =?utf-8?B?cG5FbW9EUUNMaG9xTERFWVRFbi9FYUZ6RDBNRUN5TkREeVNrbGE0M0haQWRo?=
 =?utf-8?B?RFVGV1ZTRlo5WDhLcExLNVhISjNTMVk1Ym5HSklYVEVvb0xlU3FmaWZ6bVg4?=
 =?utf-8?B?MlFIbHhHUnRkZ3g0aG90Wkh2Q0tRTW5NQmh6OFVsZElGKzNqeldJZ3pvZHR1?=
 =?utf-8?B?SFFhUkVkVlpjemFCcmloYWtKSmR5M3VPTmRTbTlrWWhoT2d5Ny9qOW9mdFk3?=
 =?utf-8?B?bXlQWmt0bm5uZTU2bXlnbG9aU2FuZ2JBeUxFS1ppenhIbWlscmUwNE04S2hX?=
 =?utf-8?B?a1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CEEE638405AE094AA35F928472668050@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb2decd8-dbb4-46ef-c9f2-08db24262450
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 00:50:43.9218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nzux1jr63AUugW57vQWzs9AYjQosd/MMm6S38He0aOl6cAIlQuK8UsIPPxhda5l7V4gU08zoYx2MVyur57m/uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7915
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIzLTAzLTEzIGF0IDExOjQwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIE1hciAxMywgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBG
cmksIDIwMjMtMDMtMTAgYXQgMTM6NDIgLTA4MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6
DQo+ID4gPiBBdHRlbXB0IHRvIGRpc2FibGUgdmlydHVhbGl6YXRpb24gZHVyaW5nIGFuIGVtZXJn
ZW5jeSByZWJvb3QgaWYgYW5kIG9ubHkNCj4gPiA+IGlmIHRoZXJlIGlzIGEgcmVnaXN0ZXJlZCB2
aXJ0IGNhbGxiYWNrLCBpLmUuIGlmZiBhIGh5cGVydmlzb3IgKEtWTSkgaXMNCj4gPiA+IGFjdGl2
ZS4gIElmIHRoZXJlJ3Mgbm8gYWN0aXZlIGh5cGVydmlzb3IsIHRoZW4gdGhlIENQVSBjYW4ndCBi
ZSBvcGVyYXRpbmcNCj4gPiA+IHdpdGggVk1YIG9yIFNWTSBlbmFibGVkIChiYXJyaW5nIGFuIGVn
cmVnaW91cyBidWcpLg0KPiA+IA0KPiA+IElJVUMsIHRoaXMgcGF0Y2ggaXMgdGhlIGZpbmFsIG9u
ZSB0aGF0IHlvdSB3YW50IHRvIGFjaGlldmUgaG93IHRoZSAiZGlzYWJsZQ0KPiA+IHZpcnR1YWxp
emF0aW9uIiBjYWxsYmFjayBzaG91bGQgd29yayBpbiB0aGUgbm9uLUtWTSBjb3JlIGtlcm5lbCAo
dGhlIHJlc3QNCj4gPiBwYXRjaGVzIGFyZSByZWxhdGVkIHRvIG1vdmluZyBWTVhPRkYgY29kZSB0
byBLVk0gYXMgdGhlIGNvcmUta2VybmVsIG5vdyBqdXN0DQo+ID4gY2FsbHMgdGhlIGNhbGxiYWNr
LCBldGMpLiDDr8K/wr0NCj4gPiANCj4gPiBUaGVyZSBhcmUgbWlkZGxlIHN0ZXAgcGF0Y2hlcyAo
Mi03KSB0byBldmVudHVhbGx5IGhlbHAgdG8gZ2V0IHRvIHRoaXMgcG9pbnQuIA0KPiA+IEJ1dCB0
byBiZSBob25lc3QsIHBlcnNvbmFsbHksIEkgYW0gbm90IHN1cmUgd2hldGhlciB0aG9zZSBwYXRj
aGVzIGFyZSBuZWNlc3NhcnksDQo+ID4gaS5lLiB0byBtZSB0aGV5IGFjdHVhbGx5IGNvc3QgbW9y
ZSB0aW1lIHRvIHJldmlldyBzaW5jZSBJIGhhdmUgdG8gdGhpbmsgd2hldGhlcg0KPiA+IHN1Y2gg
aW50ZXJtZWRpYXRlIHN0YXR1cyBpcyByZWFzb25hYmxlIG9yIG5vdC4gIEkgYW0gd29uZGVyaW5n
IHdoZXRoZXIgd2UgY2FuDQo+ID4ganVzdCBtZXJnZSB0aG9zZSBwYXRjaGVzIHRvZ2V0aGVyIGFz
IHNpbmdsZSBvbmUsIHNvIGl0J3MgZWFzeSB0byBzZWUgd2hhdCBpcyB0aGUNCj4gPiBmaW5hbCBn
b2FsIHRvIGFjaGlldmU/DQo+IA0KPiBJIGFncmVlIHRoYXQgdGhlIGZpbmUgZ3JhbnVsYXJpdHkg
bWFrZXMgaXQgZGlmZmljdWx0IHRvIHNlZSB0aGUgZmluYWwgZm9ybSwgYnV0DQo+IGZyb20gYSBi
aXNlY3Rpb24gcGVyc3BlY3RpdmUgSSByZWFsbHksIHJlYWxseSB3YW50IGVhY2ggY2hhbmdlIHRv
IGJlIGlzb2xhdGVkIGFzDQo+IG11Y2ggYXMgcG9zc2libGUuICBUaGlzIGNvZGUgaXMgZXh0cmVt
ZWx5IGRpZmZpY3VsdCwgaWYgbm90IHByYWN0aWNhbGx5IGltcG9zc2libGUsDQo+IHRvIGV4aGF1
c3RpdmVseSB0ZXN0IGR1ZSB0byBtdWx0aXBsZSBwb2ludHMgb2YgZW50cnkgZnJvbSAidGhpcyBz
aG91bGQgbmV2ZXIgaGFwcGVuISINCj4gdHlwZXMgb2YgZmxvd3MuICBJZiBhbnkgb2YgdGhlc2Ug
Y2hhbmdlcyBicmVha3Mgc29tZW9uZXMgZGVwbG95bWVudCwgSSB3YW50IHRvDQo+IG1ha2UgaXQg
YXMgZWFzeSBhcyBwb3NzaWJsZSBmb3IgdGhhdCBzb21lb25lIHRvIGRldGVybWluZSBleGFjdGx5
IHdoYXQgYnJva2UuDQoNClllYWggc3VyZS4NCg0KWWVzIGluIGdlbmVyYWwgSSBhZ3JlZSB3ZSBz
aG91bGQgbWFrZSBiaXNlY3Rpb24gZWFzeSB0byBwaW5wb2ludCB0aGUgZXhhY3QgY29kZQ0Kd2hp
Y2ggYnJlYWtzIHNvbWV0aGluZywgYnV0IEkgdGhpbmsgb3Zlci1zcGxpdHRpbmcgaXMgYWxzbyB1
bm5lY2Vzc2FyeQ0KZXNwZWNpYWxseSB3aGVuIGNvZGUgY2hhbmdlIGlzIHNtYWxsIDspDQo=
