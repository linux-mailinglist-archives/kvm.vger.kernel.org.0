Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30BC477D869
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 04:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241276AbjHPC0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 22:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241252AbjHPCZf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 22:25:35 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9554A1FDC;
        Tue, 15 Aug 2023 19:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692152734; x=1723688734;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MNKeGQ2oIfy+rzjOegKqpIVAK7slvi7D9FHZz8fSKv4=;
  b=PWishzowpOK8n6ovKdoVHxuMlKB723cbghbLSlhYCNpZ56B6EQU+XHD7
   /HZrtL+f9cTxFK5fcgpukcUOGeG+yitHDmlmQ1XGZy/PHMDg08XSwc5P0
   fkDEGynUK1tOyftfVHaE2602ttEPDczqUibUc61W0qhxfhlFsu0DD9tl7
   obq8Va4KPuVlU44EvHhBhz3SKtHSzw3v7+keC6q2zLofe7X402oIIZppT
   JO+Gye4ZfYTl5MhZdS43JlSu7XwgKz5RG75lg9BYjiucMONrLZwEJJwr5
   Tz7jjv/RipF70JYz1GZbVtXa27eUcaYxphVFPwse3SCbcI1iNZ1kBM7ri
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="403401665"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="403401665"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 19:25:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="769029986"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="769029986"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 15 Aug 2023 19:25:33 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 15 Aug 2023 19:25:33 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 15 Aug 2023 19:25:32 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 15 Aug 2023 19:25:32 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 15 Aug 2023 19:25:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWQtHKQxYQLlrEVdD1UDVtQyKa3NC2IOS38mIJQRPz+KbHCdcNyUoJ4HXgOMF7PN1Pwp/cFlDCLH/haYXp+ujt/PjXqONIhbSgwDOv3j5OjUOnUeBdlsEl2RXFf7Q0xJk8xslzgYOgef7uq7OG3nxOcBE7ECnKbeYWVnTpx04XtcOMKe5OxFuNA+YQlQpG9BvTG1T15I2qoc4jd7X+kyjvOdbVItp4sj7IVSnM0funn5PrUmjWkf6T1X8/n6q7YydWBYcvbbO77HxhEvD5lB/bhCaOUTbHXdHhKDGyLxcXQbuksF/BAVMr0YexSGQA7yo8L+ihj3ZEd5b4GbvUcsRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MNKeGQ2oIfy+rzjOegKqpIVAK7slvi7D9FHZz8fSKv4=;
 b=kwWgD0b2hRWloACHeyayNkTioERAoZASkUPsmdfQioO57ChwMJTKJnxd7NQKDrquAhr7ZARMqamSorBxddBuZ+fz0UoCunGBOKIBvJnbOYdCi+xv2VUJ2HLrtDI1kMDqpyHVMz0UIeABekeLQacbKDf57K6xOUNiyNHlvbWSZj5c4DugYvacBkMqk+OElJbnA93y3DJeP7Wz3FCMmLpEB7j67Pa6LalY2w8y83jsdtwEJBO8nrso52AQ4FRTSYlNZ6SOTMzySbtH6j++X2QZKFYn3A/YLmPVqRgsmvFOswiATHZGJvCWWaqGoTdeHzBSa8VsUuXltwsfTeqljvg9tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by SA2PR11MB5033.namprd11.prod.outlook.com (2603:10b6:806:115::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Wed, 16 Aug
 2023 02:25:19 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::1969:941b:6bab:8efa]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::1969:941b:6bab:8efa%7]) with mapi id 15.20.6678.025; Wed, 16 Aug 2023
 02:25:19 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yao, Yuan" <yuan.yao@intel.com>
Subject: Re: [PATCH v3 07/15] KVM: nVMX: Use KVM-governed feature framework to
 track "nested VMX enabled"
Thread-Topic: [PATCH v3 07/15] KVM: nVMX: Use KVM-governed feature framework
 to track "nested VMX enabled"
Thread-Index: AQHZz7iJgcXsbUyDlUCdfwdXBJPogq/sMlmA
Date:   Wed, 16 Aug 2023 02:25:19 +0000
Message-ID: <f6801a66218a05966fb52aec2856e32fadd038de.camel@intel.com>
References: <20230815203653.519297-1-seanjc@google.com>
         <20230815203653.519297-8-seanjc@google.com>
In-Reply-To: <20230815203653.519297-8-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|SA2PR11MB5033:EE_
x-ms-office365-filtering-correlation-id: 9347e0b5-64b6-4dae-c499-08db9e000971
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M6cSX6vFBmNu2kvKNVVHa92BVwRi0uipe1IBsJuAUkHrcXoDUEjWih5wCgmeQoVx/3eZkIx+34RkjVQ8FrYj5to6iEUMt6RdNgD3ReNDqso+UonZpH9SUk/z1B46MlrHg0bipJqWZgVn9fK4+krEVJER+JJGFo1o/Smlmn0EGE4/4vhb+SszeKQrdVNhGIG49bFS0SfLIHyIOjoxRm6hIzz/HLgYpdiRS/lNP748h3W9Y2XZkJ/8K6rUAcTU8DCu6yCVzgPs9n0SlyZZ3QywV5G8SsacwqweJ47ICkW7ORyf0Jd2/7PawSJM95MZZD4UwuwSjnWXoOn181qocSCWiNaVKktRyVUemIzr7EI5giOs6LUd7zFi1OM6PI4G7quQqlFi2NR/PlKXcO1q/5EWHk3W+QbUq5SEwmngKI7EAWUZmOtYFeO8/05b7FQ8lxSjL5o/bqroayLVipVPYi0px1/ecN59gyzGd/MmjojtXMRYmuKKquoFESMg7jft70g1FkV0E5VKucc+07iGf25tJoV/prJmcc7FifBtOHKFcdMF7kk5PdvO2VQ7oV85dE83khQTyYF/6IA2yfT5GYbeBDHZoR6vMagHhEr4fAIugNwJndKqtbdrm3AiTH7qzuRr
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(376002)(366004)(346002)(451199024)(186009)(1800799009)(86362001)(4326008)(41300700001)(64756008)(38070700005)(2906002)(316002)(478600001)(5660300002)(71200400001)(2616005)(122000001)(82960400001)(38100700002)(66556008)(26005)(107886003)(8936002)(6506007)(6512007)(8676002)(6486002)(54906003)(76116006)(4744005)(36756003)(110136005)(66946007)(66446008)(66476007)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHNzZ3R0U3RhTjlFQmtNakxvQm5ZQ3B6bTJFZEkwdEFGeEhwRmQ3cjhXcmxT?=
 =?utf-8?B?SW5XRTNLYjVsb29jZDgvcDhkdXdKRVRDNzF5dTlIeWh5MVdUTHU1OHRMblkw?=
 =?utf-8?B?UXlHTk5wRE8rN2ZETUZaSk5iTzIrU1U5eVdFSDdWNGNMSi9MdVkyMVhvQXRV?=
 =?utf-8?B?TlpPU0w1RndGZEprVkY0NXdmbHJNWERlTFBiTk56MVliS3loaHJHUGx5b1lh?=
 =?utf-8?B?a09WRUtpSVVTRDhWcXRPM2xnckVnWDBVRlZUemREbm9nRENOTHFCc3hCSWFL?=
 =?utf-8?B?UUJaQTQwclc3NmlrbXFkQ0wzd1Q1VmhWdGtYbnFxcXhiZy9ZTFlGYlVtcm9U?=
 =?utf-8?B?THE0RzMxK2wxdnR4OTdhWEFFM0p0czBYcmFLRVIzUU5ZYWo4cmtjNDBkQjJk?=
 =?utf-8?B?N2RxdENXaG1UU1RodzZ3MDV5eERDOUtZSUNLa1IxMEZHcXZnNDYwWHA2OGM0?=
 =?utf-8?B?Qm9ndk8xSnpEeWVESWZXcUkrdHJzbm1LSkduVmUrcFNtODBtNzdHVWhUOFd5?=
 =?utf-8?B?dEJLbTM0NktKaXRJUGsxZ0NCMUFOYXI1dFI4eHF1TEsxVkhUaWhDVkdtczhq?=
 =?utf-8?B?TjJVOGdHUmcrblRYQ2VjM3FKK0tkckxOTVhWNFRhTFFDeDBpS1ZaeVIwbSth?=
 =?utf-8?B?SUdCakFEOGhxNWtLTDRYOFFOY2IvS3lENlpoaUNJcmJEczlIbTdUekdZeVh0?=
 =?utf-8?B?NDdibnBra3N5eUdNZ2RnMTZsVEMrZm5CWDhTNUhtVm5ta1NVdTRmL2FMKzRi?=
 =?utf-8?B?ZHdoclpNM3Z1NElRbjM4dVNSTEVWYm04TWl6b2tBS3ZkY0pUNlovZzlIQnJT?=
 =?utf-8?B?Zjhrc1ZkbmJiQUhHTXJvUzJCOVBDMWhsdm5DTXRKRmE2c2F1QjlKU25GNjEv?=
 =?utf-8?B?SEVndCtSa3RFVHZKOXBMaSsrYUMvazBrNExTOGNiaWY0M1hRd1B4OExnNFJy?=
 =?utf-8?B?NUR0ZFFDcDJzUUhiMXVTQjZydC9VYnkwb0pWcGM0ZzI3aURyUG9vME5tZ3hK?=
 =?utf-8?B?RUxVYVRUNG9ieVNNTDIwckxYeWdYN0ZWRThjWjFuRDRBRHlGQWhHQVE1Y2gy?=
 =?utf-8?B?akc5cytwcFFsNE5pS3grdTFudDdYSVhRZ3htSWh0WGxXK0cxQk1Janc3MFk5?=
 =?utf-8?B?M21IWFdraTRPaFdzNW9VNkFXYm9wc285T2xFSDhJZWhBOVF2Q1NNMm45eDZS?=
 =?utf-8?B?Z0ZUYXBUOXIza3Z2K2hNZTdiWTc3dGFKUDlQZ01DcnZnSkQzYUsvZFZmcm1q?=
 =?utf-8?B?Z3RidlUxcnQ0Q2xoR3NDMnJmTDJRK1RTa1RhYTQ2SWZtemUwZndTZllYcFAr?=
 =?utf-8?B?ZkZlTHUxdmJZbCtvNFkxYkxMNU1haUpzanRDNHZLNHVRMHlVSlNYdmRUUDJU?=
 =?utf-8?B?ODY1N1F3ZlA2ZEUvVVpGbHhRQ0F1T3NkaWV3UldiaktieEZPSys1SGxsOUxy?=
 =?utf-8?B?QUd2TTB0Y3RsNnBOZjAxWlRta2pJaG9tOUNCOFVIRlZucFZhSkRJelY4eXR4?=
 =?utf-8?B?UkRYclo1amtRbkpWeERZeXFWSXhNREttYjhhY1puVzNPK05yQk91dzZYSGNF?=
 =?utf-8?B?SDdPc3dQRW9Ma09CL0UyMDZOeWxlUnNVMVBkS2FQRkc3WWdhYUY3RC9kcHVF?=
 =?utf-8?B?bGF2SkRXM1BjMEEyaWg1S2trNW9zSm5STVhUYllQUEw5b3ZZTUxsUlZDMUxm?=
 =?utf-8?B?dUdQZUxoY3Q2M1luY0xjZDBOb3ljRXFxYmZEM3hnVGlpMVJyb3cyNHkwWURT?=
 =?utf-8?B?Q2t2TmJjYUZ4L3BjdEsxaUtCMmt2bjB1VWVRYS9tdFdScEZyZDgzWFNydEpa?=
 =?utf-8?B?RGpLem1icGtvY2xPQUFIV0lQMXUyU0t4VWJ3VGpKMVhTcHNOZ2lvRThtd0tR?=
 =?utf-8?B?ZFJlN0pZYTJ3ekcrN1hRUGlQYWlRdmZKM2R4M3lZTkQvY09VQ2VOOWVzT0dk?=
 =?utf-8?B?bjMzSU1LdGV1VTNFa3RZKzRveFowSTZKV3pUYlh6VUFBYXlrTEU2T3RIbjcw?=
 =?utf-8?B?YnREWWI4dEdUQm9rdW1ONmkrY2NaOVY1UllCUnkvR0VlVU01OVUzZ0FNVXNm?=
 =?utf-8?B?S1hPR0xMS1JiZlNvQzVZNjlsTSttVzhZa3dscE1zMnRIZ3F3a014RjExN002?=
 =?utf-8?Q?d7kXjzCMBkxuA/kXD/v7xXGaz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <27F43452DF00204598C89AB852477A71@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9347e0b5-64b6-4dae-c499-08db9e000971
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2023 02:25:19.8076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wxNs7IOXY4DCprWgE0Gnzcy0Un8C6BGaWOgw0aPjGcrS7Y+ZCkQNLyUS4mevstMfu5yjhDxRjSGl4YESzdVpig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5033
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIzLTA4LTE1IGF0IDEzOjM2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBUcmFjayAiVk1YIGV4cG9zZWQgdG8gTDEiIHZpYSBhIGdvdmVybmVkIGZlYXR1cmUg
ZmxhZyBpbnN0ZWFkIG9mIHVzaW5nIGENCj4gZGVkaWNhdGVkIGhlbHBlciB0byBwcm92aWRlIHRo
ZSBzYW1lIGZ1bmN0aW9uYWxpdHkuICBUaGUgbWFpbiBnb2FsIGlzIHRvDQo+IGRyaXZlIGNvbnZl
cmdlbmNlIGJldHdlZW4gVk1YIGFuZCBTVk0gd2l0aCByZXNwZWN0IHRvIHF1ZXJ5aW5nIGZlYXR1
cmVzDQo+IHRoYXQgYXJlIGNvbnRyb2xsYWJsZSB2aWEgbW9kdWxlIHBhcmFtIChTVk0gbGlrZXMg
dG8gY2FjaGUgbmVzdGVkDQo+IGZlYXR1cmVzKSwgYXZvaWRpbmcgdGhlIGd1ZXN0IENQVUlEIGxv
b2t1cHMgYXQgcnVudGltZSBpcyBqdXN0IGEgYm9udXMNCj4gYW5kIHVubGlrZWx5IHRvIHByb3Zp
ZGUgYW55IG1lYW5pbmdmdWwgcGVyZm9ybWFuY2UgYmVuZWZpdHMuDQo+IA0KPiBObyBmdW5jdGlv
bmFsIGNoYW5nZSBpbnRlbmRlZC4NCj4gDQo+IFJldmlld2VkLWJ5OiBZdWFuIFlhbyA8eXVhbi55
YW9AaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFu
amNAZ29vZ2xlLmNvbT4NCg0KUmV2aXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwu
Y29tPg0KDQoNCg==
