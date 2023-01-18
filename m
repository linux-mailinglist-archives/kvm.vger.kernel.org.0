Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31E96727EB
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 20:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjARTOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 14:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjARTOo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 14:14:44 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212A15357D;
        Wed, 18 Jan 2023 11:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674069284; x=1705605284;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qAaAUXNhnWPk4u6peKRfLzGznM242gaIV6o4SOzfUxo=;
  b=aMftZBNncrOFoyzUrgtq6b6YLPMqx7NmYrBVhipQkC91BovLFxWeILyw
   bdGguWIz3g328fHZkxuMCbmqJEm75Q/+n1adevLIxUmGJVm0rMo6/GTCr
   pjMBpN1oiiTq0iMlBNGrWsUbdfIv00YkKHtESQmOPIFqNeSXEZo92IE6V
   xpPg9+DpD0dWa91zchqwrAlDmdrBHI6YNWcA1AZX4CPvwRlm943UILFc+
   B/8pJdMSZ6sd0Gh+8HEodqmtDepOWtO96CjBTe7ELJfRvvLp2vutkrWZZ
   4p6rpBJiszvgQ0Cc0PmWe2U4eQp5Y+vYFCz6fjdoD151J+DGtzHHBRSR/
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="325126144"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="325126144"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 11:14:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="833705904"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="833705904"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 18 Jan 2023 11:14:43 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 11:14:42 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 11:14:42 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 11:14:42 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 11:14:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwpgfqcxEUgaMhXQDpc3kpM8AamoRVGJhpKHqyhVjroaBr181KJPwhiX7E3qVpZqFQeZy8avZpFDU7CT83K5KwwRiDpIggdN2TKhNBY1D3Cq+a9DVLp/QvkeXUMIQa26691uW/adzVohPD6YswKuOTCBpDZ60H+8yZsdJ/GxNJCiIrfFUKhwQPERzLnU0M35xkZEr39yl27MGyn7djInhhz1hTVGS2Z6VwcH7Su0+8ChU0fkIq9xNB09zmRMt7QjRrwnFkpjvZn0k5UMji1mN+qKuJsq7pbTvdx6eAZOBPzKD2vRBKwHKIGTMLlkMRQHzIGzF0HDIIc0YRhn6RinmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qAaAUXNhnWPk4u6peKRfLzGznM242gaIV6o4SOzfUxo=;
 b=SriWixiz02LUMqlT65Evm6QEa9hQPQ7EoE98PjZ/3OT+HOt4qtgbdNF504pjkplJNNK5Ujy0hskT0DILnFJZq+k5wGukGPv5AvaBOhMdsRg+2qWgx3T3e6fI7DMSgzi2k3QQeXG0gkVJaPAJ3jbzhxrtQY/tx85M59LA+UKArW1tUvmHledKuh7N6FKmjyulMztG0XQ6iX4YLmzHimTS+gGN0WtLrMWFabqYu8qe5kBcYoeHW6p9fPaZTchJg9rmSXKvtZLRxPmZpBeeKG4XjzobMc9broHyjemKkyYR/bTVfiA6EZcKmZhgyGqQL3cXTrCUIfCcnjaEJ9k0w7/J8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by CH3PR11MB7865.namprd11.prod.outlook.com (2603:10b6:610:128::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 19:14:39 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::52ef:33cf:9be9:fcb0]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::52ef:33cf:9be9:fcb0%5]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 19:14:39 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Lutomirski, Andy" <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [PATCH 0/7] KVM: VMX: Handle NMI VM-Exits in noinstr section
Thread-Topic: [PATCH 0/7] KVM: VMX: Handle NMI VM-Exits in noinstr section
Thread-Index: AQHZDrl/1BljPxmiqUeeDW9Xymc1LK6kxHxA
Date:   Wed, 18 Jan 2023 19:14:39 +0000
Message-ID: <SA1PR11MB67342CAA9AE9A7E766AF54E9A8C79@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20221213060912.654668-1-seanjc@google.com>
In-Reply-To: <20221213060912.654668-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|CH3PR11MB7865:EE_
x-ms-office365-filtering-correlation-id: 308d77ec-7d82-43a6-ca4f-08daf9883ef8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /eEXTWIjOzzl4ZKWTQeq9tlkkwCNwrqI2QqGN/R2gTxHA2BonOyQDfIcDB2FzF6vEd9eUEhTGZGLI9yXDzwn8ifp2tPkHRBPAoeXeNRXGa6yw+vi3xvdvhk0WEz+Di3QRk0hIGM7y2cLMXwSKJksdA+PYMyHjr16qiyT20MvpMtUxBzemOuVzpt5tDzb/zPzekFuVI/16CgceH8AifASd74XyYbi0/VciNf+iCKIXf0W1ZSEalND2CdkcLoOsrn9k5gOshKMzGulXSyp7z/ZGhhl4dtlnZcSt+vK61JyiCct/+EY0MiLEJiCrM0Wx0CBsFb0WhbxQrG7YaAiqsRPuiAna1ljCJ6F2wakGSb0hmT3lAGpPr9K0snpcED8OdPzU/MNoiEN03qOeEfIo236zG1rvT/9ssz+bBa2KJ8XebQXaKW4RFU9Vaft3wUPD8+jYRnRFGK7znO6N8paWjxeHdI5hSIGyYTkNRxvGD5e3ufM+K48wzekbsx2LTqlJq5MX+MjpO8aKta11ay4VplXyobPXdWgXeTBvBNGVRYgF5gmNPqvlzNBoGVF9fASDhlaaiDZQbEvqjslseuV3u01XKLfBpPauhgTkj5hNW/4yNO0ru6/AVLKKglhFOnZWzXoM++l4NtZG9FVgJO1aSOX0YtXEu55QjXStYYorAu6OF81eq+l25qjLTPs/8+RWXQoCP4Ucg74BL+MLbJ83k27qw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(396003)(136003)(376002)(346002)(451199015)(8936002)(52536014)(5660300002)(41300700001)(66446008)(66946007)(76116006)(64756008)(66556008)(2906002)(66476007)(316002)(110136005)(8676002)(54906003)(478600001)(186003)(7696005)(82960400001)(38100700002)(71200400001)(26005)(4326008)(53546011)(9686003)(6506007)(33656002)(55016003)(38070700005)(86362001)(122000001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Yy9CNytUYmZBSSs0MTQ2RlhWd0FndlVlYnJ3TXZ5eDZNek1sNnBzRm55bnZ1?=
 =?utf-8?B?MU0zM2I5UWJ3YWVXbnVvQmUyVzk2TW03NkNESmZYbWhuRytLQVYvVTA2Q1RN?=
 =?utf-8?B?b2M2VFBQaGs1TWJpVldiUlBnSnYzTkdjVC9td25XbzA0Q0drVzY2Q0x3SFRT?=
 =?utf-8?B?Tm1XcldDRkRXbmYyelFYMThXd3M1d0tWdDdJdUlTR1o0Y1Z2MWJzcitGL3pR?=
 =?utf-8?B?UmFVcStsMUJQNllJeUhVbzY2eGJjcTcyWmRGaGRJTzFMTm9jUlBhSURsdjRH?=
 =?utf-8?B?bHVUZkJ5amtDOTZETkIyNCt0M2o1NmtiNTQ5eElvTUg0ekFrdkRQNTdjQnRW?=
 =?utf-8?B?enBqcU1IdWRNbllteE5Pa0JCL1I5NkNxdHNHMmNZaklVMGJxUkw0MmdteXh6?=
 =?utf-8?B?RXBIUzEwbG9lTmRlaHVHV2RtUzNEUEJzcmxiUzZqUkpxWXd5ZU11OFFsOGx0?=
 =?utf-8?B?UWpLT3p3VndXNjlGaVhtYWJmaWFYYUl1amFsaGI4a2M2WWNlZEYvNjN5ZTBk?=
 =?utf-8?B?M3ZaSXFVeWZXWng4cUcyTm5Ud0NPSVBXSFJnb1RBeXlNcjJFdC9wMEVsZENo?=
 =?utf-8?B?clczcDZKQnJrc1RmM3g3L3piY0s5N1UySGhnUU1jOURKczhRMVd2eWdWd2E2?=
 =?utf-8?B?RTRtY3g1eXN4Vi9QampYQWk4M3JMYUp1U3Z4VDFhRHJ2NVg5T1JlUDl1MUMr?=
 =?utf-8?B?dnEvQURDam9wNVZ3TERxK2JPdlZoNWREYkdzVGNFU0gwSmlDd2x1czZzdTV1?=
 =?utf-8?B?dDBjQzQvaGtRaEY1R1I1VXFkZWJ0MzU3NFpSSGdrTEdCN2IwYmhNbWEwc1FT?=
 =?utf-8?B?Z0E5QkVqTzFhbGR4K0p2SlpRTzlacWVBS3ZYbkxlYWRsc1dVVXJyeWFWY2xz?=
 =?utf-8?B?MFY3MjFBMnF2WmovTUp5NHloWENJODNjb1NPTDBZYVVzczhZM0NKTmovS3J4?=
 =?utf-8?B?eFg4V1lVN2hjVUg3ZVYvUmpZT1lqMElYUGFrcVhGUVd3Mmh3UkgxV2ZXVDVI?=
 =?utf-8?B?Wkhxa2ZRRFJMT3dPMno0dmFoUFhQVFRJV0F5NERIR0ovTDdGK3lBcUZ0YkMr?=
 =?utf-8?B?d2pjNitsTWEyQTJXZGx1bjhtUDZIUWVIQ3JVOEVkS2pxY3RyekRSS0Y1OW1u?=
 =?utf-8?B?aFZnWkVPUnVEUWIxWmFDUkRzTlhoaVpOQjFyMUhvV2JXVVpwSG1wcFZLa2xn?=
 =?utf-8?B?dFZneUN0RUVOR2NMNUlBRkJJZVhKOUg3SFBNNThBUlR5T3g2c1BlL0NQQk5t?=
 =?utf-8?B?dU0wNVhmTjM2WkNmWDFXN0szdThKdTIzR0RQV3Q5VS9sMHlqVkNTRS84UzNS?=
 =?utf-8?B?N0QwdEhVSnpLS2g2c3N3clFvaDA1NVdUdGRMUEVQNFI4aGNYQWNiNmN0Q2RM?=
 =?utf-8?B?QXZhNUxGcGlEQkMrNUFUWUQreFZmRE9Jc055UUNvUkdRcjAySEthR1h4cHFO?=
 =?utf-8?B?b214TGpCbFBlNklNZElNK0d6TUo0MkJsSFdYR2FvcHpNRFZLZU9CSndGRDIw?=
 =?utf-8?B?c1MzcVU3NXRQYUVMRlM3dHJpTGZRUThWdjBGelZSRU5NdHNPUlN4Q25pMmVh?=
 =?utf-8?B?Ris4aCtuRCsyb1pQaG9QeW5oaVBZNVB5L3doNng3a1BZbFhUQjRoc3B0TEdk?=
 =?utf-8?B?bW04RS9MMTNFdVRPemFZQ2VYRGNQb0ZkbUgwNUxZQWNzeUJKZXRnK2g1dkUx?=
 =?utf-8?B?UjZTMjBlUWpld3ZyY0JJYlpWUjNWS0ZlK3JRQ1A0KzBac1ErTDAycU5zUnQ5?=
 =?utf-8?B?SzdEaVMvU2F3ZUJscm9yYWdYRTgvSTYyNm4xb01ZM2xqNk16ZkpBZS9vY2p1?=
 =?utf-8?B?SlJIdGh1RUY3b2FsblRqTTBUZTU3dzIyVzQydjF5YnZkZXpQUHRneFhUTjFm?=
 =?utf-8?B?OXhLUk83Y2ZKRXVycnQwRnRKQUxQTzdyOWVZV2NEVDZneW5tWGlSMGx2Nysy?=
 =?utf-8?B?U0RnNEJ0QlR6Smo2NStWYVdnUU9NS21abEIxbnh6WUVTb0JSbG1FVDZRUzI5?=
 =?utf-8?B?YkI1MGRadldWdTFPaUo0MUM4NS9nWXhIdVRVTmZzR3YrUWV5MWlydlM3ZkVt?=
 =?utf-8?B?ckZraHhpcnNQa2FjczhVNktFNW5sVkZRcURxT0hiY0UySmlxdDZpTXE0WHM1?=
 =?utf-8?Q?2eRUtgNQ1wHKD51/PSfrMit3e?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 308d77ec-7d82-43a6-ca4f-08daf9883ef8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 19:14:39.3082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lbzaEVCWryddFH6d80PjibwN9AYA+oSbo4sIdKdsi1/nb/RvyF2kAM7AlBCdt/W4MN6yKh2dOy5WM4DhP8/8vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7865
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

U2VhbiwNCg0KSXMgdGhpcyBtZXJnZWQgaW50byB4ODYgS1ZNIHRyZWU/DQoNClRoYW5rcyENCiAg
ICBYaW4NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTZWFuIENocmlz
dG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gU2VudDogTW9uZGF5LCBEZWNlbWJlciAx
MiwgMjAyMiAxMDowOSBQTQ0KPiBUbzogQ2hyaXN0b3BoZXJzb24sLCBTZWFuIDxzZWFuamNAZ29v
Z2xlLmNvbT47IFBhb2xvIEJvbnppbmkNCj4gPHBib256aW5pQHJlZGhhdC5jb20+DQo+IENjOiBr
dm1Admdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBQZXRlciBa
aWpsc3RyYQ0KPiA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+OyBMdXRvbWlyc2tpLCBBbmR5IDxsdXRv
QGtlcm5lbC5vcmc+OyBUaG9tYXMgR2xlaXhuZXINCj4gPHRnbHhAbGludXRyb25peC5kZT4NCj4g
U3ViamVjdDogW1BBVENIIDAvN10gS1ZNOiBWTVg6IEhhbmRsZSBOTUkgVk0tRXhpdHMgaW4gbm9p
bnN0ciBzZWN0aW9uDQo+IA0KPiBNb3ZlIE5NSSBWTS1FeGl0IGhhbmRsaW5nIGludG8gdm14X3Zj
cHVfZW50ZXJfZXhpdCgpIHRvIGZpeCBhIChtb3N0bHkNCj4gYmVuaWduPykgYnVnIHdoZXJlIE5N
SXMgY2FuIGJlIHVuYmxvY2tlZCBwcmlvciB0byBzZXJ2aWNpbmcgdGhlIE5NSSB0aGF0DQo+IHRy
aWdnZXJlZCB0aGUgVk0tRXhpdCwgZS5nLiBpZiBpbnN0cnVtZW50YXRpb24gdHJpZ2dlcnMgYSBm
YXVsdCBhbmQgdGh1cyBhbiBJUkVULiAgSQ0KPiBkZWxpYmVyYXRlbHkgZGlkbid0IHRhZyBhbnkg
b2YgdGhlc2UgZm9yIHN0YWJsZUAgYXMgdGhlIG9kZHMgb2YgbWUgc2NyZXdpbmcNCj4gc29tZXRo
aW5nIHVwIG9yIG9mIGEgYmFja3BvcnQgZ29pbmcgc2lkZXdheXMgc2VlbXMgaGlnaGVyIHRoYW4g
b3V0LW9mLW9yZGVyDQo+IE5NSXMgY2F1c2luZyBtYWpvciBwcm9ibGVtcy4NCj4gDQo+IFRoZSBi
dWxrIG9mIHRoaXMgc2VyaWVzIGlzIGp1c3QgZ2V0dGluZyB2YXJpb3VzIGhlbHBlcnMvcGF0aHMg
cmVhZHkgZm9yIG5vaW5zdHINCj4gdXNhZ2UuDQo+IA0KPiBJIGtlcHQgdGhlIHVzZSBvZiBhIGRp
cmVjdCBjYWxsIHRvIGEgZGVkaWNhdGVkIGVudHJ5IHBvaW50IGZvciBOTUlzIChkb3VibGVkIGRv
d24NCj4gcmVhbGx5KS4gIEFGQUlDVCwgdGhlcmUgYXJlIG5vIGlzc3VlcyB3aXRoIHRoZSBkaXJl
Y3QgY2FsbCBpbiB0aGUgY3VycmVudCBjb2RlLCBhbmQgSQ0KPiBkb24ndCBrbm93IGVub3VnaCBh
Ym91dCBGUkVEIHRvIGtub3cgaWYgdXNpbmcgSU5UICQyIHdvdWxkIGJlIGJldHRlciBvciB3b3Jz
ZSwNCj4gaS5lLiBsZXNzIGNodXJuIHNlZW1lZCBsaWtlIHRoZSB3YXkgdG8gZ28uICBBbmQgaWYg
cmV2ZXJ0aW5nIHRvIElOVCAkMiBpbiB0aGUgZnV0dXJlDQo+IGlzIGRlc2lyYWJsZSwgc3BsaXR0
aW5nIE5NSSBhbmQgSVJRIGhhbmRsaW5nIG1ha2VzIGl0IHF1aXRlIGVhc3kgdG8gZG8gc28gYXMg
YWxsIHRoZQ0KPiByZWxldmFudCBjb2RlIHRoYXQgbmVlZHMgdG8gYmUgcmlwcGVkIG91dCBpcyBp
c29sYXRlZC4NCj4gDQo+IFNlYW4gQ2hyaXN0b3BoZXJzb24gKDcpOg0KPiAgIEtWTTogeDg2OiBN
YWtlIHZteF9nZXRfZXhpdF9xdWFsKCkgYW5kIHZteF9nZXRfaW50cl9pbmZvKCkNCj4gICAgIG5v
aW5zdHItZnJpZW5kbHkNCj4gICBLVk06IFZNWDogQWxsb3cgVk0tRmFpbCBwYXRoIG9mIFZNUkVB
RCBoZWxwZXIgdG8gYmUgaW5zdHJ1bWVudGVkDQo+ICAgS1ZNOiBWTVg6IEFsd2F5cyBpbmxpbmUg
ZVZNQ1MgcmVhZC93cml0ZSBoZWxwZXJzDQo+ICAgS1ZNOiBWTVg6IEFsd2F5cyBpbmxpbmUgdG9f
dm14KCkgYW5kIHRvX2t2bV92bXgoKQ0KPiAgIHg4Ni9lbnRyeTogS1ZNOiBVc2UgZGVkaWNhdGVk
IFZNWCBOTUkgZW50cnkgZm9yIDMyLWJpdCBrZXJuZWxzIHRvbw0KPiAgIEtWTTogVk1YOiBQcm92
aWRlIHNlcGFyYXRlIHN1YnJvdXRpbmVzIGZvciBpbnZva2luZyBOTUkgdnMuIElSUQ0KPiAgICAg
aGFuZGxlcnMNCj4gICBLVk06IFZNWDogSGFuZGxlIE5NSSBWTS1FeGl0cyBpbiBub2luc3RyIHJl
Z2lvbg0KPiANCj4gIGFyY2gveDg2L2luY2x1ZGUvYXNtL2lkdGVudHJ5LmggfCAxNiArKystLS0t
LQ0KPiAgYXJjaC94ODYva2VybmVsL25taS5jICAgICAgICAgICB8ICA4ICsrLS0NCj4gIGFyY2gv
eDg2L2t2bS9rdm1fY2FjaGVfcmVncy5oICAgfCAxMiArKysrKysNCj4gIGFyY2gveDg2L2t2bS92
bXgvaHlwZXJ2LmggICAgICAgfCAyMCArKysrLS0tLS0NCj4gIGFyY2gveDg2L2t2bS92bXgvdm1j
cy5oICAgICAgICAgfCAgNCArLQ0KPiAgYXJjaC94ODYva3ZtL3ZteC92bWVudGVyLlMgICAgICB8
IDcyICsrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLQ0KPiAgYXJjaC94ODYva3ZtL3Zt
eC92bXguYyAgICAgICAgICB8IDU1ICsrKysrKysrKysrKystLS0tLS0tLS0tLS0NCj4gIGFyY2gv
eDg2L2t2bS92bXgvdm14LmggICAgICAgICAgfCAxOCArKysrLS0tLS0NCj4gIGFyY2gveDg2L2t2
bS92bXgvdm14X29wcy5oICAgICAgfCAgMiArDQo+ICBhcmNoL3g4Ni9rdm0veDg2LmggICAgICAg
ICAgICAgIHwgIDYgKy0tDQo+ICAxMCBmaWxlcyBjaGFuZ2VkLCAxMTcgaW5zZXJ0aW9ucygrKSwg
OTYgZGVsZXRpb25zKC0pDQo+IA0KPiANCj4gYmFzZS1jb21taXQ6IDIwOGYxYzY0ZTI1NWZlM2Ey
OTA4Mzg4MDgxOGUwMTBlYmRmNTg1YzYNCj4gLS0NCj4gMi4zOS4wLnJjMS4yNTYuZzU0ZmQ4MzUw
YmQtZ29vZw0KDQo=
