Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F768658B55
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 10:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbiL2J6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 04:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbiL2J4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 04:56:34 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2675C6437;
        Thu, 29 Dec 2022 01:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672307793; x=1703843793;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pYSD2L5DbIuxzcHPXOG+UC1UUL7HaYM5Ul6M4t5rYeA=;
  b=EEy1vcwmwpY26PzK6Tqgvb7lTGsAs8sK/TjiXKuuPwX7thdOUi/tp51+
   +GxYCveiGI0jsF6IDdGDV9Wo7/yNbay5xlABhpVQsnbYcwVFxPwKX8T3D
   sxt7Fx1p82MAS/WBk0kh+MrfNvY7MOT1oOPnwuoyS5oFr6ll4FRvy/LNE
   BW3GEZ0v+fVHQcdZfXcoDHH8YmJXLGOXOvYSRYJmhUVSo0UCQaX3JESzz
   wZRQAfyFmjrGRmjcaqEQxpzz0tdR7kKasS8OKH2zPoVzjzIPkZ0cAtJCr
   He/uQ0/p3U9jJML09MkiJoDA0ryLFXVPGSW1zWWY7SjSJD5RqlPNioOmo
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="300703678"
X-IronPort-AV: E=Sophos;i="5.96,283,1665471600"; 
   d="scan'208";a="300703678"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2022 01:56:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10574"; a="684169391"
X-IronPort-AV: E=Sophos;i="5.96,283,1665471600"; 
   d="scan'208";a="684169391"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 29 Dec 2022 01:56:32 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 29 Dec 2022 01:56:31 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 29 Dec 2022 01:56:31 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 29 Dec 2022 01:56:31 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 29 Dec 2022 01:56:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMBf0TWcjphUM9799Et16dxMEayHf/aKuRg4kN4Lnw0bYYF2e4aJy4lKP/2Q6UciIOn9jC/9w8UJnDdqnCQziNnAkKcNVaweusC/5VAgEjA+YcO6/PXr1pWaPZGzbEciGnNKNZXCSedGP7bsCqp7u2dD4cC4J1Ul3KKRrdSrwTIdYS1JogVyQGrgzMmG2/zQvW2wFzypGxbkMmhEcPJkX5Tn4H8h5Fxjbxr17pE2ljpasIAv6vrsMOFYqHiyrOzrvojzB3uDLdB3w5bVWNyt//A0U3TKzZ7xZgKOijIYnQpuJmJXE5VPgcwxMgTRx6urqJOdjRpMrEPIg7Quf8+3Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pYSD2L5DbIuxzcHPXOG+UC1UUL7HaYM5Ul6M4t5rYeA=;
 b=m74Xt0T1hL4v/t/5v4bedzxr2eztzci2+ZGuePqLUHJUmGnk2mg2kLTX5fC4LpT/r9UNyL0Pu+HZT9gmjjLh3PmCh3pH+ETdiiiWjY7uVq4H69BJMdH1GFQcq84Ofr302hgJIUJ9v/HEPN/mzJFJcf0b7ltNo8878mmCCE79EzTn2ZgBDaChXGzPyAu5qgHd1qfxX2y7NDLv3v7ZD5Wu95yfgot6la5CnyyEtpJVOPv8tgW1U2ACHNmdBEZjupOwtI0gilzrbxDNIbp5nc2vWGtJuhkVYVaJDWJ0bCRdwGVgmyKRI3LZFhLn6fQ08+naxbz5Rp6Rx+VbPPbFkRvlOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB0031.namprd11.prod.outlook.com (2603:10b6:301:69::37)
 by BL1PR11MB5413.namprd11.prod.outlook.com (2603:10b6:208:30b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 09:56:29 +0000
Received: from MWHPR11MB0031.namprd11.prod.outlook.com
 ([fe80::b05:c765:b545:78c5]) by MWHPR11MB0031.namprd11.prod.outlook.com
 ([fe80::b05:c765:b545:78c5%7]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 09:56:29 +0000
From:   "Zhang, Chen" <chen.zhang@intel.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>
CC:     "Gao, Chao" <chao.gao@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH 6/9] kvm/x86: Add ARCH_CAP_VIRTUAL_ENUM for guest
 MSR_IA32_ARCH_CAPABILITIES
Thread-Topic: [RFC PATCH 6/9] kvm/x86: Add ARCH_CAP_VIRTUAL_ENUM for guest
 MSR_IA32_ARCH_CAPABILITIES
Thread-Index: AQHZDLMiQbmbfwYsK06hcLGAwsuJI653yRSAgAsc9kCAAae2gIAACZ3wgAARN4CAABH90A==
Date:   Thu, 29 Dec 2022 09:56:29 +0000
Message-ID: <MWHPR11MB00315B3E8EFA05E62F37A41D9BF39@MWHPR11MB0031.namprd11.prod.outlook.com>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
 <20221210160046.2608762-7-chen.zhang@intel.com>
 <d4dec151-553f-e762-7fcc-81ae82b5c211@intel.com>
 <MWHPR11MB0031EEA971FDA614271C22449BF39@MWHPR11MB0031.namprd11.prod.outlook.com>
 <cbbdb23f-4261-4f48-4143-c5fb6c78da06@intel.com>
 <MWHPR11MB0031974C4A46C1895FF8C9929BF39@MWHPR11MB0031.namprd11.prod.outlook.com>
 <ec4f0298-f169-4f23-5dc5-3e3cba2a1b24@intel.com>
In-Reply-To: <ec4f0298-f169-4f23-5dc5-3e3cba2a1b24@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB0031:EE_|BL1PR11MB5413:EE_
x-ms-office365-filtering-correlation-id: cbeec8bb-a825-41e8-9baf-08dae982f51b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GtqF+PEfH8XE/TiJOXuNsd1jL0EkRxFfXktO1Ar6jTGwZGxDCvQVDIvQ4JPgKl9dWfKsT4//IEFFW2f7DGLW03DOK8SODZf1xsDkPcFtBQbhexupjVosYJchnHYbPZuEJ+I0KKSptb0B10kTlN5zcH54WIc1ecCBjvd9vfKCSGEh2vnAhbaiZzW0uLQIGOFjj6U/PaarewQ6o1yyRwRfFHMJGUHLMe8zLMzC5Fk5gaUZv0Jcunsq4Ds4PV4GLf3UJ2fXmoj9tYAFpLUavScOT+RGRUUgdQs8aDHt6IesMWNiEMn+HMEWM++MOAZ73GulW7hZ8Ry1XwSW2rmFAnYdSJ7Y6VT9KGh8IH20alPts0/lbsNttP87FqMF8X9amv94/2DVqakKRLCsWX1A842XhbU5Yg5xOvXTznlOrl3SirLIEVIlKOoAb51vR5TYNDYl/Di/FihHZvNz27pKnFpQ+/ffv54IE2GnN5ON29mxTnY5phsC06KyrMWRYinDHBvrEs5y0gZx70heXAPBfQvn2oetH/nR0JsIlNO36eXepVm3pdzHtDyW/6Rt+O01zDsB9EUBd4V3X9PcmxMULXw/JgPbYagYCAge/oqLFcsmMhfRFwwt+BfTohbpylVoM2tA8pxKbn4/CBTQfkkjaVrPyP3rbvqEfOU6IcIy8jOENMH9ajr+k6g7i4cl/hnVoPUGPYvSv9nuq4DQ2ew2BkBB+HMXMKCnJUDsEThyPbuVsAU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB0031.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199015)(86362001)(55016003)(186003)(9686003)(33656002)(966005)(478600001)(71200400001)(7696005)(53546011)(41300700001)(6506007)(66556008)(5660300002)(8676002)(66446008)(6862004)(66476007)(4326008)(64756008)(76116006)(7416002)(52536014)(2906002)(6636002)(316002)(54906003)(8936002)(38100700002)(38070700005)(66946007)(82960400001)(122000001)(26005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?STNySCs4SkUzMXJMaXdNaTdKMHl3WGVzcWFuS1QzaHJvUzlmcjJML1c2Ujht?=
 =?utf-8?B?OER3alJ5QVZCTXJKeWdBL2IwMXc5WU54bnNaKzNMK1JjdEcrM3lkYkJSWkpl?=
 =?utf-8?B?ODVrM0Q5Z083TjYzVFF2RUVkS0xnZjU4WmhiUGdIQTRsN0IzOWY5VnU1YTEw?=
 =?utf-8?B?QlAraFNRUlJqN0t5Unk2Rjd4WnBiQlVVdmdVMTBTb1NOaTNxRkp4REJpMnU4?=
 =?utf-8?B?Qkdmb3FNVE13UzlGOS84VmVkcXFsb3g3ZER0bkwyZysxeENaYjYzaURwVGUx?=
 =?utf-8?B?OGdqSzNVLzZQNmt6ckhuc01VWXJtZGNaS2REZFUxVUc4L3ZZQUdiTGJHVkF2?=
 =?utf-8?B?aFpFNDJlUVovbFFoVHFjVkQ5U0FxVHh6UXhNd3FQSjloVFFEc3hQMlNDckpz?=
 =?utf-8?B?TzlQWHFIVDRnN2UveURPRnNHYnZGSVIvUHRmMDJvK1Z2cUpZTHhHdmxZUEY5?=
 =?utf-8?B?ZjQ1VTBQM0VwVS95U1BzOE80UlhkZ0UyUTFIbnNuYWlKUUo4dVdZTWhwRENo?=
 =?utf-8?B?aVN6UTIwUjBRa1pvVDc0UFdCSVRkSzV2dHJLQlcyMW41Y2VLc1Awc05Cb0ZJ?=
 =?utf-8?B?YncwSHdUM3gzaHEvTWszZEhQclpjWHFqSDZOZjJ5cTlTOURxU09SM2lzTDcv?=
 =?utf-8?B?QjRCTDd0UG8wc0lvVzRxaGUxUnlHNjlJbmZjRzVxQTB0ZEdBWFhFN3Q1dCtk?=
 =?utf-8?B?UHZXNnBQcVBEY1ZKeG9MZW8yMXduSUNSM25RZGpZQzNVU0VaM1V5cGhIYU9J?=
 =?utf-8?B?aUJQd1pUdlp0QURIelRIMjgyM3JvTWFrQndpVjN0Vkh1TEtiaDJwM2ppNnpX?=
 =?utf-8?B?SDZMUnd2WjV5dGFjNG5YYlcyZEM4Rk1KQW83M3p4NDFML2Fmb25sUDZtQXls?=
 =?utf-8?B?UUYvYmNma0VjbS9yd2dCU0g4SktUem1saVN2ZkxKcnlnUUloZXN3YjJKcUNS?=
 =?utf-8?B?U3ZWcnBHSDhyc0V2djR4b29MQ281dGN2WWFhQ1JyZ2tXbmh2ZDZ2a0w0M0Ix?=
 =?utf-8?B?YVViVVhZNjNjYi9VQ1FNS2M5RkpZVlFzcHlEeklJaFZTZG9RclIwc29LbEdR?=
 =?utf-8?B?RC8yZlc0dWdGNlIvdlJrOVdlSGFjMFFXbWFtVEM2RlBveHJ5c3J3aEpPS09w?=
 =?utf-8?B?YUhTYmJZSVk5eDVlWHBidnBlOGIrQk16WUlLd1UvNkVSNk80WkkvTFVDdUhN?=
 =?utf-8?B?cW9tSFZGR1E5eHZQYXVmRlAyRzBENmkxc3VBMXRmTDVFS2p2VFVOTEhnUno2?=
 =?utf-8?B?UHg1dXdNaWhJN2VDN2dvR1Z0K1dBcXh6MFF2NVV5MkFIZ2RvRlo5blppWjJC?=
 =?utf-8?B?SGVSUVQrRUZnSXJkL29nVHV3bTJzbXc5K3JHMGZkN0FmNXlxeXZLamNpN016?=
 =?utf-8?B?RUxydEZ1bUJ6cXB2YTZrK1M0eUl3YjVzS2ZhUXcwcTlvTDJXaGVWbDVRaVd1?=
 =?utf-8?B?OXJQVUt4R2NCRzFObDJjWm1vbm1CTElIckVzQ3hucTBCbHZXZG9zZGVFYkxh?=
 =?utf-8?B?d0Rwa3I4eTlYQ2hML2ZRd2JmUUNRcUtPNXp3ZlJjRDNsTWcvVForQnJITkFz?=
 =?utf-8?B?OW5YQ1M0SWcvUUhtT3BYN244K1Fzb3BrMFRkRlpEUXNScFo0R0xIRGdZM1Ay?=
 =?utf-8?B?WlRXQVRSSzlBdk9sQ1BSb29qaEtiRitFc0NLZEZTWFduc2YwQUJaZlI3eDB2?=
 =?utf-8?B?eXloRE1IdjNpeXUvaS83MTlycCt0YlBteGJpMWg5UnoreW9WaVU3SVJIa1Z1?=
 =?utf-8?B?ZEVqcDBRYjBobUc4T2lQUmZoaXFlcU5Cc29HZEFvK3hjUUVmVk9pSXlzUjVk?=
 =?utf-8?B?eEpTbTlCRkdTOFRDZ0gwWXFmbWRuVU11Nld6T2UwMTlKeGt2bkU4QStSYW5t?=
 =?utf-8?B?bFN3R3FMV2M2M2RFcStnMzdCN0JvNElic01aZG9NeVU0SVZXT0RnVWI4d05D?=
 =?utf-8?B?UVdyMWliTk8wZ1dVT0Nva2hxNG5SRDRxaUhMb0NnTEhRVjRuUEY0NEJiWjl2?=
 =?utf-8?B?QlVKOGlTNGZwSmwyTlFwVUpVTyt2dk8zNWJwSGJIT2lZNDAyZ1J2THBJQXMz?=
 =?utf-8?B?cGEvSjhoNklyRmJ3a1RsRnlLa1Bmc0xXUW1wUHhYZlE4REhNWlM3YnVheDdJ?=
 =?utf-8?Q?tH/qedHFzawN1K+IUYdMTulyN?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB0031.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbeec8bb-a825-41e8-9baf-08dae982f51b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Dec 2022 09:56:29.3437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QED9RBIQoSzRVvUdN9vRMe9jR4XK6dS96m0OHrUEcyiImGAZiVG4epNj5m4EkDalnZiKYwtfAL81ynJGtmYpww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5413
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogWWFuZywgV2Vpamlhbmcg
PHdlaWppYW5nLnlhbmdAaW50ZWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgRGVjZW1iZXIgMjks
IDIwMjIgNDozOSBQTQ0KPiBUbzogWmhhbmcsIENoZW4gPGNoZW4uemhhbmdAaW50ZWwuY29tPg0K
PiBDYzogR2FvLCBDaGFvIDxjaGFvLmdhb0BpbnRlbC5jb20+OyBQYXdhbiBHdXB0YQ0KPiA8cGF3
YW4ua3VtYXIuZ3VwdGFAbGludXguaW50ZWwuY29tPjsgUGFvbG8gQm9uemluaQ0KPiA8cGJvbnpp
bmlAcmVkaGF0LmNvbT47IENocmlzdG9waGVyc29uLCwgU2VhbiA8c2VhbmpjQGdvb2dsZS5jb20+
OyBILg0KPiBQZXRlciBBbnZpbiA8aHBhQHp5dG9yLmNvbT47IERhdmUgSGFuc2VuIDxkYXZlLmhh
bnNlbkBsaW51eC5pbnRlbC5jb20+Ow0KPiBCb3Jpc2xhdiBQZXRrb3YgPGJwQGFsaWVuOC5kZT47
IEluZ28gTW9sbmFyIDxtaW5nb0ByZWRoYXQuY29tPjsgVGhvbWFzDQo+IEdsZWl4bmVyIDx0Z2x4
QGxpbnV0cm9uaXguZGU+OyB4ODZAa2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVs
Lm9yZzsNCj4ga3ZtQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1JGQyBQQVRDSCA2
LzldIGt2bS94ODY6IEFkZCBBUkNIX0NBUF9WSVJUVUFMX0VOVU0gZm9yDQo+IGd1ZXN0IE1TUl9J
QTMyX0FSQ0hfQ0FQQUJJTElUSUVTDQo+IA0KPiANCj4gT24gMTIvMjkvMjAyMiAzOjQxIFBNLCBa
aGFuZywgQ2hlbiB3cm90ZToNCj4gPg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
PiA+PiBGcm9tOiBZYW5nLCBXZWlqaWFuZyA8d2VpamlhbmcueWFuZ0BpbnRlbC5jb20+DQo+ID4+
IFNlbnQ6IFRodXJzZGF5LCBEZWNlbWJlciAyOSwgMjAyMiAzOjAzIFBNDQo+ID4+IFRvOiBaaGFu
ZywgQ2hlbiA8Y2hlbi56aGFuZ0BpbnRlbC5jb20+DQo+ID4+IENjOiBHYW8sIENoYW8gPGNoYW8u
Z2FvQGludGVsLmNvbT47IFBhd2FuIEd1cHRhDQo+ID4+IDxwYXdhbi5rdW1hci5ndXB0YUBsaW51
eC5pbnRlbC5jb20+OyBQYW9sbyBCb256aW5pDQo+ID4+IDxwYm9uemluaUByZWRoYXQuY29tPjsg
Q2hyaXN0b3BoZXJzb24sLCBTZWFuIDxzZWFuamNAZ29vZ2xlLmNvbT47IEguDQo+ID4+IFBldGVy
IEFudmluIDxocGFAenl0b3IuY29tPjsgRGF2ZSBIYW5zZW4NCj4gPj4gPGRhdmUuaGFuc2VuQGxp
bnV4LmludGVsLmNvbT47IEJvcmlzbGF2IFBldGtvdiA8YnBAYWxpZW44LmRlPjsgSW5nbw0KPiA+
PiBNb2xuYXIgPG1pbmdvQHJlZGhhdC5jb20+OyBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRy
b25peC5kZT47DQo+ID4+IHg4NkBrZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnOyBrdm1Admdlci5rZXJuZWwub3JnDQo+ID4+IFN1YmplY3Q6IFJlOiBbUkZDIFBBVENIIDYv
OV0ga3ZtL3g4NjogQWRkIEFSQ0hfQ0FQX1ZJUlRVQUxfRU5VTSBmb3INCj4gPj4gZ3Vlc3QgTVNS
X0lBMzJfQVJDSF9DQVBBQklMSVRJRVMNCj4gPj4NCj4gPj4NCj4gPj4gT24gMTIvMjkvMjAyMiAx
MDo1OCBBTSwgWmhhbmcsIENoZW4gd3JvdGU6DQo+ID4+DQo+ID4+IFsuLi5dDQo+ID4+DQo+ID4+
Pj4gXA0KPiA+Pj4+PiArCSBBUkNIX0NBUF9WSVJUVUFMX0VOVU0pDQo+ID4+Pj4+DQo+ID4+Pj4+
ICAgICBzdGF0aWMgdTY0IGt2bV9nZXRfYXJjaF9jYXBhYmlsaXRpZXModm9pZCkNCj4gPj4+Pj4g
ICAgIHsNCj4gPj4+Pj4gQEAgLTE2MDcsNiArMTYxMSwxMyBAQCBzdGF0aWMgdTY0IGt2bV9nZXRf
YXJjaF9jYXBhYmlsaXRpZXModm9pZCkNCj4gPj4+Pj4gICAgIAkgKi8NCj4gPj4+Pj4gICAgIAlk
YXRhIHw9IEFSQ0hfQ0FQX1BTQ0hBTkdFX01DX05POw0KPiA+Pj4+Pg0KPiA+Pj4+PiArCS8qDQo+
ID4+Pj4+ICsJICogVmlydHVhbCBNU1JzIGNhbiBhbGxvdyBndWVzdHMgdG8gbm90aWZ5IFZNTSB3
aGV0aGVyIG9yIG5vdA0KPiA+Pj4+PiArCSAqIHRoZXkgYXJlIHVzaW5nIHNwZWNpZmljIHNvZnR3
YXJlIG1pdGlnYXRpb24sIGFsbG93aW5nIGEgVk1NDQo+ID4+Pj4+ICsJICogdG8gZW5hYmxlIHRo
ZXJlIGhhcmR3YXJlIGNvbnRyb2wgb25seSB3aGVyZSBuZWNlc3NhcnkuDQo+ID4+Pj4+ICsJICov
DQo+ID4+Pj4+ICsJZGF0YSB8PSBBUkNIX0NBUF9WSVJUVUFMX0VOVU07DQo+ID4+Pj4gSU1PLCB0
aGlzIGlzOsKgIGRhdGEgJj0gQVJDSF9DQVBfVklSVFVBTF9FTlVNOyBiZWNhdXNlIGl0IHJlcXVp
cmVzDQo+ID4+Pj4gcGxhdGZvcm0gc3VwcG9ydC4NCj4gPj4+IEludGVsIGRlZmluZWQgdGhlIHZp
cnR1YWwgTVNScyBmb3Igc29mdHdhcmUgbWl0aWdhdGlvbnMgZm9yIGFsbCBwbGF0Zm9ybXMuDQo+
ID4+PiBLVk0gc2hvdWxkIGJlIHVuY29uZGl0aW9uYWxseSBvcGVuZWQgaXQgZm9yIHRoZSBzb2Z0
d2FyZSBtaXRpZ2F0aW9uDQo+ID4+PiBpbg0KPiA+PiBtaWdyYXRpb24gcG9vbHMuDQo+ID4+PiBG
b3IgZXhhbXBsZSBtaWdyYXRpb24gZnJvbSB0aGUgb2xkIHBsYXRmb3JtIHRvIHRoZSBuZXcgcGxh
dGZvcm0uDQo+ID4+PiBQbGVhc2UgY2hlY2sgdGhlIFNvZnR3YXJlIE1pdGlnYXRpb25zIGluIE1p
Z3JhdGlvbiBQb29scyBzZWN0aW9uIGluDQo+ID4+IGRvY3VtZW50czoNCj4gPj4+IGh0dHBzOi8v
d3d3LmludGVsLmNvbS9jb250ZW50L3d3dy91cy9lbi9kZXZlbG9wZXIvYXJ0aWNsZXMvdGVjaG5p
Y2FsDQo+ID4+PiAvcw0KPiA+Pj4gb2Z0d2FyZS1zZWN1cml0eS1ndWlkYW5jZS90ZWNobmljYWwt
ZG9jdW1lbnRhdGlvbi9icmFuY2gtaGlzdG9yeS1pbmoNCj4gPj4+IGVjDQo+ID4+PiB0aW9uLmh0
bWwNCj4gPj4gSWYgdGhpcyBzZXJpZXMgcnVubmluZyBvbiBvbGQgcGxhdGZvcm1zLCBob3cgVk1N
IGNhbiBzZXQgc3BlY2lmaWMNCj4gPj4gdm1jcyBmaWVsZHMsDQo+ID4+DQo+ID4+IGUuZy4sIOKA
nHZpcnR1YWxpemUgSUEzMl9TUEVDX0NUUkzigJ0gVk0tZXhlY3V0aW9uIGNvbnRyb2wsIHRvIG1p
dGlnYXRlDQo+ID4+IGd1ZXN0IGlzc3Vlcz8NCj4gPiBFbmFibGUgdGhlIHZpcnR1YWwgTVNScyBk
b2VzIG5vdCBtZWFucyB0byBlbmFibGUgdGhlIOKAnHZpcnR1YWxpemUNCj4gSUEzMl9TUEVDX0NU
UkzigJ0uDQo+ID4gS1ZNIHdpbGwgY2hlY2sgImNwdV9oYXNfdmlydF9zcGVjX2N0cmwoKSIgYmVm
b3JlIHNldCBzcGVjaWZpYyBWTUNTLg0KPiANCj4gDQo+IFdoYXQgSSdtIGNvbmNlcm5lZCBpcywg
aWYgdGhlIGZlYXR1cmUgaXMgbm90IHN1cHBvcnRlZCBvbiBzb21lIHBsYXRmb3JtcywNCj4gdW5j
b25kaXRpb25hbGx5DQo+IA0KPiBleHBvc2luZyB0byBndWVzdCB3b3VsZCBtYWtlIGl0IHdyb25n
bHkgInRoaW5rIsKgIHRoZSBmZWF0dXJlIGlzIHN1cHBvcnRlZCBvbg0KPiBIVywgYnV0IGFjdHVh
bGx5DQo+IA0KPiBXTU0gY2FuIGRvIG5vdGhpbmcgdG8gbWl0aWdhdGUgaXNzdWVzLiBSZWFkIHRo
cm91Z2ggdGhlIHBhdGNoIHNldCwgbG9va3MgbGlrZQ0KPiBndWVzdCBjYW5ub3QNCj4gDQo+IGV2
ZW4gZ2V0IGFueSBlcnJvcnMgZHVyaW5nIGZlYXR1cmUgY29uZmlndXJhdGlvbiBpbiB0aGlzIGNh
c2UuIFNvIEkgc3VnZ2VzdCBhZGQNCj4gbW9yZQ0KPiANCj4gc2FuaXR5IGNoZWNrcy4gRGlkIEnC
oCBtaXNzIHNvbWV0aGluZz8NCg0KVW5kZXJzdGFuZCB5b3VyIGNvbmNlcm4sIGJ1dCBJIHRoaW5r
IG5vIG5lZWQgdG8gY29uY2VybiBhYm91dCBpdC4NCkFsdGhvdWdoIHdlIGhhdmUgdW5jb25kaXRp
b25hbGx5IHR1cm5lZCBvbiB2aXJ0dWFsIE1TUnMgaW4gYWxsIHBsYXRmb3JtcywNClRoZSBkZXRh
aWxlZCB2aXJ0dWFsIE1TUiBiaXRzIHN0aWxsIGNhbiB0ZWxsIGd1ZXN0IHdoYXQgZmVhdHVyZSBp
cyBzdXBwb3J0ZWQgb24gSFcuDQpRRU1VIHdpbGwgc2V0dXAgdGhlIE1TUl9WSVJUVUFMX01JVElH
QVRJT05fRU5VTSgweDUwMDAwMDAxKSBiaXRzDQpMaWtlIHRoZSBCSEJfQ0xFQVJfU0VRX1NfU1VQ
UE9SVC9SRVRQT0xJTkVfU19TVVBQT1JUIGJlZm9yZSBib290IFZNcy4NCg0KVGhhbmtzDQpDaGVu
DQoNCj4gDQo+IA0KPiA+DQo+ID4gVGhhbmtzDQo+ID4gQ2hlbg0KPiA+DQo+ID4+DQo+ID4+Pj4+
ICsNCj4gPj4+Pj4gICAgIAkvKg0KPiA+Pj4+PiAgICAgCSAqIElmIHdlJ3JlIGRvaW5nIGNhY2hl
IGZsdXNoZXMgKGVpdGhlciAiYWx3YXlzIiBvciAiY29uZCIpDQo+ID4+Pj4+ICAgICAJICogd2Ug
d2lsbCBkbyBvbmUgd2hlbmV2ZXIgdGhlIGd1ZXN0IGRvZXMgYQ0KPiB2bWxhdW5jaC92bXJlc3Vt
ZS4NCj4gPj4+Pj4gQEAgLTE2NTcsNiArMTY2OCw5IEBAIHN0YXRpYyBpbnQga3ZtX2dldF9tc3Jf
ZmVhdHVyZShzdHJ1Y3QNCj4gPj4+PiBrdm1fbXNyX2VudHJ5ICptc3IpDQo+ID4+Pj4+ICAgICAJ
Y2FzZSBNU1JfSUEzMl9VQ09ERV9SRVY6DQo+ID4+Pj4+ICAgICAJCXJkbXNybF9zYWZlKG1zci0+
aW5kZXgsICZtc3ItPmRhdGEpOw0KPiA+Pj4+PiAgICAgCQlicmVhazsNCj4gPj4+Pj4gKwljYXNl
IE1TUl9WSVJUVUFMX0VOVU1FUkFUSU9OOg0KPiA+Pj4+PiArCQltc3ItPmRhdGEgPSBWSVJUX0VO
VU1fTUlUSUdBVElPTl9DVFJMX1NVUFBPUlQ7DQo+ID4+Pj4gTmVlZCB0byBjaGVjayBiaXQgNjMg
b2YgaG9zdCBNU1JfQVJDSF9DQVBBQklMSVRJRVMgYmVmb3JlIGV4cG9zZQ0KPiA+Pj4+IHRoZSBm
ZWF0dXJlLg0KPiA+Pj4gUmVmZXIgdG8gdGhlIGFib3ZlIGNvbW1lbnRzLg0KPiA+Pj4NCj4gPj4+
IFRoYW5rcw0KPiA+Pj4gQ2hlbg0KPiA+Pj4NCj4gPj4+Pj4gKwkJYnJlYWs7DQo+ID4+Pj4+ICAg
ICAJZGVmYXVsdDoNCj4gPj4+Pj4gICAgIAkJcmV0dXJuIHN0YXRpY19jYWxsKGt2bV94ODZfZ2V0
X21zcl9mZWF0dXJlKShtc3IpOw0KPiA+Pj4+PiAgICAgCX0NCg==
