Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B6970BEDD
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 14:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbjEVM5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 08:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234069AbjEVM5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 08:57:08 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25615FA;
        Mon, 22 May 2023 05:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684760221; x=1716296221;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kxPfEmH1qgLs5u90NIXK9fRHqZHVZKJ0NN7adCoOGTY=;
  b=XkXuDZ0my4eUm9scCgc8klybRmp6sMGml3Qt87lRzYdx1z4cGVJdDaQi
   Nf/JqNHPvE1/OYOrzhBFXY4ZOZzrfK1G4VmuOkxmBo1fHvxcVTChPntVm
   q3ODwHqMerokr7kEzVgXInAQTFeDpcYmq5lxiM0LER3vkM3zSWLF2e4ZQ
   8PyWMqSRO9+wsdmGv43xF90+m+M1wH8r46yTSaQhL8rdrVdp4kPrdFjUn
   n2J5I7j14o1M3XMprvCoR8VHKYI3gOOM+MDjMtPy27/Ysqq2J2uJM8fiW
   rSAj/ZL5xsDiz71Lv3KKwgjlw/qzK6lzOIkIqhF0HEvuT4WH6bsO39LNV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="333275589"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="333275589"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 05:56:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="773346513"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="773346513"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 22 May 2023 05:56:46 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 05:56:46 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 05:56:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 05:56:46 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 05:56:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGx0FIGx+uj3ssgNIU/9j/fHno6BPiXGgE8ltL94G6t4RSsRDmUMRquxJuX6xW1JxOHoafhz7JeV/0jQ/MIZO6R2JlCpygq+uS9H1g1P9prMsIFRFsOBlMf3f+GWXifJlIefMwt1rXVJJ+SaesNnijCh0H6ZTcMA/UaxMRygGAWOxmnAFvIb5FeEP905ltXijA4vAHb2eZRlhP0ZUhAU04yB3+jXWUAlKr1bdVLg9NR7w6OMFiYcj4NPq4Di7DPInsJjeg3Xoeew4iLJfil3ebtWhZxlI4v+jU4RUBtx6l94gJR+F6lDGTN/PzZCeZ0FDhrk9YEph5kyvnW5YzOmag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kxPfEmH1qgLs5u90NIXK9fRHqZHVZKJ0NN7adCoOGTY=;
 b=DapmGW1IzhYH/ZHwUrAWpl/eSpJMTY8+n9MHXIIIxM4dJliBsmXckrlOmC11IKNCQAX+1upO5F2PzBs3L7qi08zMjS0q+TFxQwRdrlw0DbAyG4Cf2BF4NEI73ZnHW7D9KiXgw3EGLtzIVf8tzlqnFSihix/5j3hgLTStK2AI7O/VzaC7Zr/nCdDNWVj7EiSZXP3GThDLLEKx0wH34J6mvMWnzML07PWEtLWSnuN2c6hqWOWLw/855Y2BTSLzOSVeHYQKuIVIPSSyOz2xCenioOchfX8FxNtAz3765/8+aZruU2b/y36OIP8ua+LLoLEBe6ZevuCuMk34JrkuHotFvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BN9PR11MB5273.namprd11.prod.outlook.com (2603:10b6:408:132::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.27; Mon, 22 May
 2023 12:56:41 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 12:56:41 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 04/18] x86/reboot: KVM: Disable SVM during reboot via
 virt/KVM reboot callback
Thread-Topic: [PATCH v3 04/18] x86/reboot: KVM: Disable SVM during reboot via
 virt/KVM reboot callback
Thread-Index: AQHZhSyXjSHJ+RgYukuosSV8fxFHxa9mT1cA
Date:   Mon, 22 May 2023 12:56:40 +0000
Message-ID: <849b657fb14e94d5842130bb61d702927a1fde23.camel@intel.com>
References: <20230512235026.808058-1-seanjc@google.com>
         <20230512235026.808058-5-seanjc@google.com>
In-Reply-To: <20230512235026.808058-5-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BN9PR11MB5273:EE_
x-ms-office365-filtering-correlation-id: f99f2e30-a98b-4a71-56c3-08db5ac3fcd5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G8+/uGqLQC8k1TTDco7RnwXbwXp5mRCaP5iXsrjigua3Vi/dN7PalZZIW0ek7OWSjV0y1X59RH2ood+hGhghk+5CrlE5pgsJQM1lhjmDbHWvpzkZ87Dc+WvoOWmELNgCvGrHsb6zuRC2l8uTYOH3ot0szOYQ8yPIp/Cx847r3eAsiNABM8YqDDZg683OXnS/OivDfkh4QGfbgmILaVMMa6G0umDEmAR5mhXZAE8X/vdyk8tpG3/bJohxnXyHaApGCJ+37/YhVwfqG/m+RqDsNFTA+kyGiLklVoWcZFoi75xAQzJZQ1DNB5u6dehzAWs9bSlk4z+G21GbKyXPiB5CMOEZ1GFDQYEBaKHrzfRr5Q/iifWab1jUfZqKOqcscsOhVL5U6JSoYl55oYtUq1XDw4FVNBnrOvhWzaf8WBe5jNsXrSFb1gOnasH88KA8TQadu4P8+PdPiyCeO6zuGJJ0bHgxcbcZBVi/oq3FyHBVHOg+atR2lwvqpfN33+cW42IlTk4m9ew6kdJy33rcn8Xe0d/IEiGMmKWrdGiKVu6yzocvLq1lHgNvrjW5klMUU1jsitQucCkefNPFtDGlCnLhlqTVpxyVP1twExgeV538w0tFvUmvtNfHjNNIHTGv5xTC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(136003)(39860400002)(366004)(346002)(451199021)(2906002)(110136005)(54906003)(5660300002)(8676002)(8936002)(41300700001)(64756008)(91956017)(316002)(66946007)(66556008)(76116006)(66446008)(66476007)(478600001)(4326008)(36756003)(71200400001)(6486002)(26005)(6512007)(6506007)(122000001)(38100700002)(86362001)(2616005)(186003)(83380400001)(38070700005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TkYxSG1vWWtqcjNXVWJUNVQ3RDRiVjhWNWwzR1NvOGUwK2hyYm9nMDE4Zkxq?=
 =?utf-8?B?czkyaEljNG10N0NtL216alE5TjhKUnRYT25oc2RseWk1MFpwWk4xYnNOZ0t6?=
 =?utf-8?B?dFNad2E1eTBSSzVIdXJiVVJPcngrbXR3elJGQ2Q4bmNUNDAwTkxHb3hoQUl3?=
 =?utf-8?B?N2VzMTNzcnZTRU8wOVV3UG1aOVhUTGM4aXg0SC9RRUpMdG0wWU9DZzRlSE9u?=
 =?utf-8?B?VWJheG9LbEtnL2d1UTZ4cGxyL25oRHVTYWNHeWQ1a3ljNTNvL3BoT3JIMmRB?=
 =?utf-8?B?cTA1RUtyeGJ2TEZGMU11aWZvdEU0NGc2eDUrQkxhMmVTYU00UVRvR0ppR3Iz?=
 =?utf-8?B?RXBBRlVGa3h1WlZPMkZBQzZjdGgwUUdsbzV2WGFIejF6SUxqQnd5TDY3bkNV?=
 =?utf-8?B?czFQVFdHVHR5SkZ6Mmd5T1IxYURYWFNJV1JuTWE1bE8zNTdRWXl2R0tvUDRY?=
 =?utf-8?B?cFJTc0xjZ056S3I2amVLRVF3dGtLYmYyaWVFTkNoSk05Qno2UC9KclNEWWNP?=
 =?utf-8?B?dmZ1MmV4NkVLVXJxTThFMmJvay9FazVUSFhKUml6dGJWZmZuU21QL0Y4eU41?=
 =?utf-8?B?bDF6WjcvNWxKSTUyR2ZOZ2lwNzVoSzNiZWh0aDNlTEE5ZlFWMlpPT216b1pE?=
 =?utf-8?B?QUF5U25kZU9NK3JtWjNkWXNNNkN2S08yeGVYaHlSRzhEN2RBWTRFR0dNUHpw?=
 =?utf-8?B?TUd1emVLREtsZnBsc1ZZMlJtZFdvT3lKSDZRcXFTS1F6S1RNS2dHK2MzS3JF?=
 =?utf-8?B?bWRYNFJteG5WeXVxb0g4VHNuaEwxalJhdjVjQ2s4RXlvSXdGN0hkTFhsUjJE?=
 =?utf-8?B?QlhTWStNQWRlVis5LzVTTDZIMVlZaDkzUkpIdE1FdzlENmF6d0ozOUtOcXJn?=
 =?utf-8?B?Rjlnd2FJTWF3c3FHMVU5VE9rcE5ZSVIzWmxhQkJnZEFWYW9ZamVmOU5jQlZO?=
 =?utf-8?B?SE1ON3JyTFYwY2ljNjgxZGxEY3B0ODEwSVd4RGIrRUhJeWo0SG1jbkV6M3B6?=
 =?utf-8?B?WVFCWjNFc1l1Qno4TkFYaUhoNG9hMGtaKzErZ3haQkFHMndSSUtyYlRyaSth?=
 =?utf-8?B?MnY5MDZQMVFTVnJTMlRsMk12a2wxUVB4dU4rNUhBUVFjWXVJem5wbmk4UkpH?=
 =?utf-8?B?UTd6eHdtSGpjem03Y0Q2WXoxaWxRMjJ6R3VqRDNXUVJHa3Q2RHB4aDNtdkV5?=
 =?utf-8?B?RUx4QjJxa1hwcXNNZXduTGJQV05lTWZiaDVCa2dNV0V5RkZyazVyTy9JUXVC?=
 =?utf-8?B?emduYVZ1elMweTdRUjk4dDhwbjUzYlRkVzJVZGRrWTQ3QUowMFI3YXFKekNK?=
 =?utf-8?B?VTRHUXlCcjVCdzFwbDg4WmxoSWhzNnVvOU1kM3ZBVEg3MldPUE9NN2hJRGVs?=
 =?utf-8?B?NW9KbityMi9uRHVDMGhzTGtRakpxVGFJcnBlNy80bW9tV0NUYk1yQXhsOEIy?=
 =?utf-8?B?bWtQVGtUZ0dFNHUxZEt2NEFBZHlKUno0Yis3TGRiS1RTRXFqMnFpS0ZPek5u?=
 =?utf-8?B?NG95U1Z6VzRIeTc0aUttV1JvYnMzcjRaVU1PL2pYM3VHbURWOU1kZUowRU9l?=
 =?utf-8?B?bzdKcXdkOExicUZqWU4rMVg5NlBWSmp1NVZ2cFBlSWRhMjY3dDhMSU43RUl0?=
 =?utf-8?B?SytsYnZrVVNaVWVORFlBSFhBdzZzNmRDU05EU2p3RXNJTGthRTllREN3Mk1O?=
 =?utf-8?B?V1YxV2cxYmtqSVFhRHg4bU9nN0o2SHJIMDFaV25rVURwR2NocVNtQjdncnAy?=
 =?utf-8?B?NS9mZmVqcUxxQ05kWjZmOTQ3blpiS1FZeVlhLzRlUmhnNWM2OFI2Wjg0MFIr?=
 =?utf-8?B?bmFTdFhYVjBVam1aSTJvT2YydmpSQ0grdnRqTEdBV0JUN0JHcTQwOXY0RWZQ?=
 =?utf-8?B?UGM4T2Y0cDhYOWRDSjN3TjJLVWt3eXB3c3JWTzhESzFSYlRLMDdIWXE2T1pB?=
 =?utf-8?B?b3hTYVdCL0FYRE1CUVdwOVl4aVZaV3RJL09yUlY4WHRidExIN3Awc2VWdW9G?=
 =?utf-8?B?NmRrREx0Ull5eExVOGcxMjJycmxGR0w1SWdHeHVja2I4MFVieTBPenNodFZn?=
 =?utf-8?B?UWI1a1JoMGRoWGVWbUFKQmRTaVZZbDNqZkU3bVJ5YkFrdi9meFM1WXJYZUE5?=
 =?utf-8?B?UmF2amt2NjRtR21wVFpnZUtTZEZUTC82RE9jR3ZRbEhETFNibkI3Um0wblZn?=
 =?utf-8?B?SXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C509151C44D42C4589418D883B6FBA1E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f99f2e30-a98b-4a71-56c3-08db5ac3fcd5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 12:56:40.9775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yz+KJqgCQXjzuunSx08+At3e+DH/2NhabVArWDT5WfpD6JH12bLx2o+4zKhHqVpnMsIapd1+/4HviGSSmryhLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5273
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA1LTEyIGF0IDE2OjUwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBVc2UgdGhlIHZpcnQgY2FsbGJhY2sgdG8gZGlzYWJsZSBTVk0gKGFuZCBzZXQgR0lG
PTEpIGR1cmluZyBhbiBlbWVyZ2VuY3kNCj4gaW5zdGVhZCBvZiBibGluZGx5IGF0dGVtcHRpbmcg
dG8gZGlzYWJsZSBTVk0uICBMaWtlIHRoZSBWTVggY2FzZSwgaWYgYQ0KPiBoeXBlcnZpc29yLCBp
LmUuIEtWTSwgaXNuJ3QgbG9hZGVkL2FjdGl2ZSwgU1ZNIGNhbid0IGJlIGluIHVzZS4NCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0K
DQpBY2tlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KDQo+IC0tLQ0KPiAg
YXJjaC94ODYvaW5jbHVkZS9hc20vdmlydGV4dC5oIHwgIDggLS0tLS0tLS0NCj4gIGFyY2gveDg2
L2tlcm5lbC9yZWJvb3QuYyAgICAgICB8ICAzIC0tLQ0KPiAgYXJjaC94ODYva3ZtL3N2bS9zdm0u
YyAgICAgICAgIHwgMTkgKysrKysrKysrKysrKysrKystLQ0KPiAgMyBmaWxlcyBjaGFuZ2VkLCAx
NyBpbnNlcnRpb25zKCspLCAxMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS92aXJ0ZXh0LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS92aXJ0ZXh0
LmgNCj4gaW5kZXggNWJjMjlmYWIxNWRhLi5hYWVkNjYyNDljY2YgMTAwNjQ0DQo+IC0tLSBhL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL3ZpcnRleHQuaA0KPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS92aXJ0ZXh0LmgNCj4gQEAgLTEzMywxMiArMTMzLDQgQEAgc3RhdGljIGlubGluZSB2b2lkIGNw
dV9zdm1fZGlzYWJsZSh2b2lkKQ0KPiAgCX0NCj4gIH0NCj4gIA0KPiAtLyoqIE1ha2VzIHN1cmUg
U1ZNIGlzIGRpc2FibGVkLCBpZiBpdCBpcyBzdXBwb3J0ZWQgb24gdGhlIENQVQ0KPiAtICovDQo+
IC1zdGF0aWMgaW5saW5lIHZvaWQgY3B1X2VtZXJnZW5jeV9zdm1fZGlzYWJsZSh2b2lkKQ0KPiAt
ew0KPiAtCWlmIChjcHVfaGFzX3N2bShOVUxMKSkNCj4gLQkJY3B1X3N2bV9kaXNhYmxlKCk7DQo+
IC19DQo+IC0NCj4gICNlbmRpZiAvKiBfQVNNX1g4Nl9WSVJURVhfSCAqLw0KPiBkaWZmIC0tZ2l0
IGEvYXJjaC94ODYva2VybmVsL3JlYm9vdC5jIGIvYXJjaC94ODYva2VybmVsL3JlYm9vdC5jDQo+
IGluZGV4IDBjZjIyNjFjMmRlYy4uOTJiMzgwZTE5OWEzIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4
Ni9rZXJuZWwvcmVib290LmMNCj4gKysrIGIvYXJjaC94ODYva2VybmVsL3JlYm9vdC5jDQo+IEBA
IC04MjYsOSArODI2LDYgQEAgdm9pZCBjcHVfZW1lcmdlbmN5X2Rpc2FibGVfdmlydHVhbGl6YXRp
b24odm9pZCkNCj4gIAlpZiAoY2FsbGJhY2spDQo+ICAJCWNhbGxiYWNrKCk7DQo+ICAJcmN1X3Jl
YWRfdW5sb2NrKCk7DQo+IC0NCj4gLQkvKiBLVk1fQU1EIGRvZXNuJ3QgeWV0IHV0aWxpemUgdGhl
IGNvbW1vbiBjYWxsYmFjay4gKi8NCj4gLQljcHVfZW1lcmdlbmN5X3N2bV9kaXNhYmxlKCk7DQo+
ICB9DQo+ICANCj4gICNpZiBkZWZpbmVkKENPTkZJR19TTVApDQo+IGRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9rdm0vc3ZtL3N2bS5jIGIvYXJjaC94ODYva3ZtL3N2bS9zdm0uYw0KPiBpbmRleCBlYjMw
OGM5OTk0ZjkuLjBmMGQwNDkwMGJmMiAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3N2bS9z
dm0uYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jDQo+IEBAIC0zOCw2ICszOCw3IEBA
DQo+ICAjaW5jbHVkZSA8YXNtL3NwZWMtY3RybC5oPg0KPiAgI2luY2x1ZGUgPGFzbS9jcHVfZGV2
aWNlX2lkLmg+DQo+ICAjaW5jbHVkZSA8YXNtL3RyYXBzLmg+DQo+ICsjaW5jbHVkZSA8YXNtL3Jl
Ym9vdC5oPg0KPiAgI2luY2x1ZGUgPGFzbS9mcHUvYXBpLmg+DQo+ICANCj4gICNpbmNsdWRlIDxh
c20vdmlydGV4dC5oPg0KPiBAQCAtNTY4LDYgKzU2OSwxMSBAQCB2b2lkIF9fc3ZtX3dyaXRlX3Rz
Y19tdWx0aXBsaWVyKHU2NCBtdWx0aXBsaWVyKQ0KPiAgCXByZWVtcHRfZW5hYmxlKCk7DQo+ICB9
DQo+ICANCj4gK3N0YXRpYyB2b2lkIHN2bV9lbWVyZ2VuY3lfZGlzYWJsZSh2b2lkKQ0KPiArew0K
PiArCWNwdV9zdm1fZGlzYWJsZSgpOw0KPiArfQ0KPiArDQo+ICBzdGF0aWMgdm9pZCBzdm1faGFy
ZHdhcmVfZGlzYWJsZSh2b2lkKQ0KPiAgew0KPiAgCS8qIE1ha2Ugc3VyZSB3ZSBjbGVhbiB1cCBi
ZWhpbmQgdXMgKi8NCj4gQEAgLTUxODQsNiArNTE5MCwxMyBAQCBzdGF0aWMgc3RydWN0IGt2bV94
ODZfaW5pdF9vcHMgc3ZtX2luaXRfb3BzIF9faW5pdGRhdGEgPSB7DQo+ICAJLnBtdV9vcHMgPSAm
YW1kX3BtdV9vcHMsDQo+ICB9Ow0KPiAgDQo+ICtzdGF0aWMgdm9pZCBfX3N2bV9leGl0KHZvaWQp
DQo+ICt7DQo+ICsJa3ZtX3g4Nl92ZW5kb3JfZXhpdCgpOw0KPiArDQo+ICsJY3B1X2VtZXJnZW5j
eV91bnJlZ2lzdGVyX3ZpcnRfY2FsbGJhY2soc3ZtX2VtZXJnZW5jeV9kaXNhYmxlKTsNCj4gK30N
Cj4gKw0KPiAgc3RhdGljIGludCBfX2luaXQgc3ZtX2luaXQodm9pZCkNCj4gIHsNCj4gIAlpbnQg
cjsNCj4gQEAgLTUxOTcsNiArNTIxMCw4IEBAIHN0YXRpYyBpbnQgX19pbml0IHN2bV9pbml0KHZv
aWQpDQo+ICAJaWYgKHIpDQo+ICAJCXJldHVybiByOw0KPiAgDQo+ICsJY3B1X2VtZXJnZW5jeV9y
ZWdpc3Rlcl92aXJ0X2NhbGxiYWNrKHN2bV9lbWVyZ2VuY3lfZGlzYWJsZSk7DQo+ICsNCj4gIAkv
Kg0KPiAgCSAqIENvbW1vbiBLVk0gaW5pdGlhbGl6YXRpb24gX211c3RfIGNvbWUgbGFzdCwgYWZ0
ZXIgdGhpcywgL2Rldi9rdm0gaXMNCj4gIAkgKiBleHBvc2VkIHRvIHVzZXJzcGFjZSENCj4gQEAg
LTUyMDksMTQgKzUyMjQsMTQgQEAgc3RhdGljIGludCBfX2luaXQgc3ZtX2luaXQodm9pZCkNCj4g
IAlyZXR1cm4gMDsNCj4gIA0KPiAgZXJyX2t2bV9pbml0Og0KPiAtCWt2bV94ODZfdmVuZG9yX2V4
aXQoKTsNCj4gKwlfX3N2bV9leGl0KCk7DQo+ICAJcmV0dXJuIHI7DQo+ICB9DQo+ICANCj4gIHN0
YXRpYyB2b2lkIF9fZXhpdCBzdm1fZXhpdCh2b2lkKQ0KPiAgew0KPiAgCWt2bV9leGl0KCk7DQo+
IC0Ja3ZtX3g4Nl92ZW5kb3JfZXhpdCgpOw0KPiArCV9fc3ZtX2V4aXQoKTsNCj4gIH0NCj4gIA0K
PiAgbW9kdWxlX2luaXQoc3ZtX2luaXQpDQo+IC0tIA0KPiAyLjQwLjEuNjA2LmdhNGIxYjEyOGQ2
LWdvb2cNCj4gDQoNCg==
