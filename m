Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F616561CB
	for <lists+kvm@lfdr.de>; Mon, 26 Dec 2022 11:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiLZKR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 05:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiLZKR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 05:17:27 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584871036;
        Mon, 26 Dec 2022 02:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672049846; x=1703585846;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MCq33FNvxrEHKsBX8ckvcoPQshXsxsVSKxApOD7Y6b4=;
  b=mgFCKpVr8sE/fGwjnDzU/VCBeUAVGI8xS3AFDVQ7Pj5wMawmRmXFWHON
   HdNM64Mq3XLl7/odWFwhiLjHePgQ5nKQkiLw+SIIxyRcHGB0J4i+3Xvc4
   KfIgYmiOewcA2auUoG/SioBP52UpfHjyi3id+EhEtGD7m298LXH+1N+oA
   Qw7ZuHbxKdQhgNvSRzZnocexl86wXZRIjg8rDU4Z9FQncIklPnCbeuFcE
   d3rcYanDYsZJbM+UDJnBa2h5Y176cT4+LNS78ngVLM/l87Z8DR4rmh72X
   P6prcUt204NoOumZIHIvPXGH7fYK7Q9czBfVzpZ4x4C0RAa7RAm6Jt1nd
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10571"; a="319274332"
X-IronPort-AV: E=Sophos;i="5.96,275,1665471600"; 
   d="scan'208";a="319274332"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Dec 2022 02:17:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10571"; a="683320360"
X-IronPort-AV: E=Sophos;i="5.96,275,1665471600"; 
   d="scan'208";a="683320360"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 26 Dec 2022 02:17:25 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 26 Dec 2022 02:17:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 26 Dec 2022 02:17:24 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 26 Dec 2022 02:17:24 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 26 Dec 2022 02:17:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nISGavXTiDGlkSzOERD8YNmpDaI7oHMgGCn0bJsi7YT83GaKki2/Bt/26r4dsidOk+OWAzJg2xmlNpMnd+bJ1eRkMsEywO5M2cn0o3qqWU/n5q8628AXEpmg5UCDgpT5qi39lvlC+6kUoh1aPNq80upolkslUWa6TnOTXSamfKwxwxV67BX6kCWf61ogl0E4OqSzonrhpU1ygy0Huq63zNzWyGXBgLEgCaQ1SMwcWt8PYGIDDQsIQD0G6w1dzLI0Zfw/EOF3W0jfS6xYuoFa+OdNxk7CSU/xGT7ziuRuN2G4OoA5jTDBIlGqGKeboBA2aPMizGn2PS2D69iGMM3pdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MCq33FNvxrEHKsBX8ckvcoPQshXsxsVSKxApOD7Y6b4=;
 b=kUkYLpmi7fWNiRWNJJa2PVuS3j/3YoTejij+WLILdgZQP4Szn3w1AZo8knJs2sGvF/L0x5RG5LMFgXOGULMYyHvPm3DlS1McW8Zqn0jMzC28dnmUSrO13Dx9JUd5KCPwGew0AVXYk7JPCpFJ2+Rev6HrkqUUZGyWr4zze0bd65LrDpS2SRkUj9pzLLB8TQaSKr22Jns3/c2LH27B4XTu/VpngWg3xCstwG97uZqpYoYsczBo33l1obITxgdn/P7FFox/DsExhtfvfa2mxzAN1ZDFoH0SUW+bZY9/+tjJjtndrOa2VIMOzCRLT4AhL82scLj5COONx3KxN1qJf4Hjtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 BN9PR11MB5419.namprd11.prod.outlook.com (2603:10b6:408:100::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.16; Mon, 26 Dec 2022 10:17:12 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::97ed:f538:dc6a:a9c4]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::97ed:f538:dc6a:a9c4%7]) with mapi id 15.20.5944.014; Mon, 26 Dec 2022
 10:17:11 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?5p+z6I+B5bOw?= <liujingfeng@qianxin.com>
Subject: RE: [PATCH] KVM: Destroy target device if coalesced MMIO
 unregistration fails
Thread-Topic: [PATCH] KVM: Destroy target device if coalesced MMIO
 unregistration fails
Thread-Index: AQHZE8418VzPZWSUokiiYWnmvIEhgq52BguAgAW2JYCAAt1qQA==
Date:   Mon, 26 Dec 2022 10:17:11 +0000
Message-ID: <DS0PR11MB6373F27D0EE6CD28C784478BDCEC9@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221219171924.67989-1-seanjc@google.com>
 <DS0PR11MB637301E9103F92EE5617D5B2DCEA9@DS0PR11MB6373.namprd11.prod.outlook.com>
 <84acd990-3040-c3ee-c56f-6647900ca30f@redhat.com>
In-Reply-To: <84acd990-3040-c3ee-c56f-6647900ca30f@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|BN9PR11MB5419:EE_
x-ms-office365-filtering-correlation-id: 0759129e-d119-43c9-d456-08dae72a5a71
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g4PK3UuLpkbh8mKbLWa9sDOvGNnbfmhdGKuavUIM2m/2xHMpp5VwbbAL1pZjWP7UHNGD0rg1QQwH4g1KNmojMAQ6/xZD1WYh63eXtlQJxyzelYirmfi/ua/YCNySyplV0GcC7eGlco0UlaRFGdgBpDff2CQnjqBGHD/TwZ6CMsM3wZY2u7YR0JvBQQAsAJzvm9Egsqdw++dNDCf+GUCCFxB8wjmE1pACftCOInhf241+56P81jHMFtSBAAqQySRGR5j5Pmqz5UhC72jQ6oWP6JYN+98q3/n3evwPnrt3rlVt2Y/ZwTxB8HrBesxKRuCLNZMsCcDj4QEFewqqJQ2/rRpnp5QIGftJ/d1MUtr4gBR+bbXiCcokpcLolZqPSyneluxCC6zaIiotnoSN3OrzIMUuVZAN7yUlcQlob1yby7QgIZyQx+AnFLVWj8Rq5ox6Ccifs7O5a6O3X/kbX6JuVHT1yLZSiv0OTtIZjQD4JTHwhL3xxYbPm+gNGPNVcxKf6woMGcaqN5Lqar2KnvLKkRRM0IXY4z47dEJ8nPe5axZQ4L0gr8q8FJ6EZv94cyqTQhYHe0M0Bx8hoqck2zg18WTdOtzqgdV2nHVAeNkiR9ucHHFJpAOje3l4ve+LCpje/joANqpdviyYzAh85pvZfiYC2Zli+MUPIRfoVOMXF0aDlcmm00CQRJMw155h8moIJ4BIMtpZiDigX1P4uRtncQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199015)(52536014)(9686003)(26005)(186003)(5660300002)(4744005)(41300700001)(66446008)(8936002)(4326008)(66946007)(76116006)(8676002)(64756008)(66556008)(66476007)(54906003)(2906002)(110136005)(71200400001)(33656002)(478600001)(316002)(86362001)(55016003)(53546011)(7696005)(6506007)(38070700005)(82960400001)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RzdVL0k5aUZyZlF3T1hEVm9UejZJMk4ybXc1Sk5JdER0WTBwaDBYS05VcW1i?=
 =?utf-8?B?RVN5UEphZGNqajFUUVUwcm1xeXJWTGJ5M2xrdGcwcHdwRExQVlFkd3BpRTBv?=
 =?utf-8?B?MTA2QnJJVVVuZ1hqOEIwdHNGY05ocW04c3dQVDlvSi92VTRMbmpJdzk0QjhJ?=
 =?utf-8?B?cEt0L1lXZHpaTVFNejVnTDJObHZIZVRydnZ5aHpKK3F3bmNjMDZMOW04NXFa?=
 =?utf-8?B?MERsS1pYYmVtNTMrWjE2SHZwL2thQjhRWFVhNzZZaDlVQ2Z1SDkvNkIyYzVn?=
 =?utf-8?B?RjlhTnptRWlaME81ZWE0VXFqSkJtUTZXUmNKS2dUUXB0UGZEbmZEd1NlYXFE?=
 =?utf-8?B?OEpGMng2UkE5VmowUWdOWmp5ODh0ZW9ycytEaVk3WitmOGZoRFBIUW92S2pV?=
 =?utf-8?B?UU54N3JpL2VDWTZQTUVMTjBHbGhjQzZqWWo2TlJ2ZHcyNWdiM0tXQ0JKaEc2?=
 =?utf-8?B?QlFlNkd1SFkrNTNRdmQzNkgybXdWV2EvTDh6WWlCQjRVdkk0K2krTWFudkdz?=
 =?utf-8?B?STFmR2hEMTdmTTZSNzQ3d0xaWEs0TVJEeVBUSEpYTzRQaVZnRGg3RllHVlY1?=
 =?utf-8?B?YUIxTmRFY2JtU25iSkR5SXIySDBOUVV0b2hZRWVrQTQ5NENMVHljd2hrWHFX?=
 =?utf-8?B?bDV3M2VHUEttcmtxZXQyMGpWLzlJQTAxL0cwbzRtMDllT1J2amI3N3AvTkkx?=
 =?utf-8?B?WjBWZnpTeVlSSVlzUnNJUHlsai9QKzU3NHgvTExVN3RLQlBwR0h3NXI2MmNI?=
 =?utf-8?B?VG9EOFZ5ZUtQY2xLaG4zUlhaNjVTenYxU3pDRGswWlJxOVM0VGJzak1tTWFP?=
 =?utf-8?B?RW5HK0lyTEhVcEtxVThFdytBeGRZOGVlOEw5Z2paMWtwSitzTUtpdGdiNzhp?=
 =?utf-8?B?QiswMy9kcENGcjBMNVcvVlRKSlcxdC80UlQzZVFBSis2ZW84eXZ4bCs2cU5C?=
 =?utf-8?B?T3A2WE4yMHhrT3VWc2R0SWpYZ1oxQnN3QlcrK1JrQ29Ndm95UGQ3Zng4eXNL?=
 =?utf-8?B?K1RkUzZheVpZSU5PVUdnNjM5MEt0QjdIbUJ4bUplRm9manIrVDY0MlduYjFj?=
 =?utf-8?B?eDZDZFNFOUdXNm9sZ0NXejlRcjI4NlNJT1FRS2llN3M5OFRxT01nays4cnk1?=
 =?utf-8?B?cFBSZzlmTXNXZ3JwN3JWVVBiUzhRSVVScGRCT1dsNG5lc2NPbXNsNm4vbTRs?=
 =?utf-8?B?dzUvR2NqVVQ4Ty9XUVRvSm5URWEyOVpUbGZraC93a1NMQ0U2d1FpMjF6amJK?=
 =?utf-8?B?Y0F6YytaTzBzcVplVFBIUnJFV25pNUxnRS95QVB1RkE2TW1RdmRLbWY0WTUy?=
 =?utf-8?B?Zm1KMXNBR2J0aFovclZtUERWTFR2aHJQVFZKd0lqMFNINXQ4K0VqZEtpcUpB?=
 =?utf-8?B?NjhqYjVvOTlVdEVla0FqZ0x0bzVaU0FuSFNFUkxORVJ0bGZTdlpBQy9tdTRh?=
 =?utf-8?B?N3U5NHZOcVd2MjNBaTJXdXlsRkVXMlI0eldkSS9nbUNrWDhTSXIvRDNjalM2?=
 =?utf-8?B?Q25mbmlOMVhKN1VPM2Y5UTlkb2k5d0pSUlFqenI2THJISlJQV2RaM24yZFho?=
 =?utf-8?B?alp4aFhzVzlKMGlHY0ZGS3RPU29PZHJEUTFyYTJMaENPMkVXdVhZaUN2d1c3?=
 =?utf-8?B?bjRVRno5MnJRVldsWmJCdytyL0pOZXFxMWt0dHhXRjd1b0c5aE5TbzlTZzdM?=
 =?utf-8?B?K0xlcityM252NUMwZlVOeTluVTRKRy85dlFyWkUwamZtUXZZQlVJR3hTR3JN?=
 =?utf-8?B?U0VkQUdMY2dUTXZVQ3ZKRU1ZK0pPWStvdng3cFVtSGRYTGc0TWlkOUc2K0J3?=
 =?utf-8?B?OFJrVDlzVXp1UzNDZmh6OXZkTkJsTUlsdUtwL0o3S1lkYUhlVEt3T1VYQW83?=
 =?utf-8?B?MzAzWXZHNHVlUmEwRlNhSkczYTJNUzZYY3FwMjNEUnROUHE5RUtZc0lodTdH?=
 =?utf-8?B?cG8waWhIUnhCWlBLWGFrM3JYTUltQ3VMeGE1b3VxQS8zR0lOVndQVk83LzJN?=
 =?utf-8?B?QkxnV0x1dXN6aDNCK0JwN0x0MkZLN0NwVDdQSHJsWnZFeXM1MFVqZUx5bjFO?=
 =?utf-8?B?VWlsRFB4Y1lSbmZPMFpQYnE2NEJoV2lRZ2ZPRzVMa05hT2kzK0dvcHJaWXlj?=
 =?utf-8?Q?aOosBpdhGQVO36nYAxTm49zwr?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0759129e-d119-43c9-d456-08dae72a5a71
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Dec 2022 10:17:11.8086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pJZg7iO2SVcfKweCjmZfA4FP5QY1blxMC1+w+AxaQT35N9GguNx+Ad0HCm5pfvDH1APm2A1J+uC/E0yuP2QTwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5419
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gU2F0dXJkYXksIERlY2VtYmVyIDI0LCAyMDIyIDE6MTQgQU0sIFBhb2xvIEJvbnppbmkgd3Jv
dGU6DQo+IE9uIDEyLzIwLzIyIDA0OjA0LCBXYW5nLCBXZWkgVyB3cm90ZToNCj4gPiBBbm90aGVy
IG9wdGlvbiBpcyB0byBsZXQga3ZtX2lvX2J1c191bnJlZ2lzdGVyX2RldiBoYW5kbGUgdGhpcywg
YW5kIG5vDQo+ID4gbmVlZCBmb3IgY2FsbGVycyB0byBtYWtlIHRoZSBleHRyYSBrdm1faW9kZXZp
Y2VfZGVzdHJ1Y3RvcigpIGNhbGwuDQo+ID4gVGhpcyBzaW1wbGlmaWVzIHRoZSB1c2FnZSBmb3Ig
Y2FsbGVycyAoZS5nLiByZWR1Y2luZyBMT0NzIGFuZCBubyBsZWFrYWdlcyBsaWtlDQo+IHRoaXMp
Og0KPiANCj4gQ2FuIHlvdSBzZW5kIHRoaXMgYXMgYSBwYXRjaD8gIFRoYW5rcyENCg0KU3VyZS4g
SSBjYW4gZG8gaXQuIEknbSBhbHNvIGZpbmUgaWYgU2VhbiB3b3VsZCBiZSBpbnRlcmVzdGVkIGlu
IHRha2luZyBvdmVyIHRoZQ0KY29kZSAob3IgYW55dGhpbmcgSSBzaG91bGQgZG8gdG8ga2VlcCBo
aXMgY3JlZGl0cyBmb3IgdGhlIG9yaWdpbmFsIGZpeGluZz8pDQo=
