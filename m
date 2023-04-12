Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0FC26DF308
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 13:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjDLLSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 07:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjDLLSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 07:18:16 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B037EE1;
        Wed, 12 Apr 2023 04:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681298272; x=1712834272;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/4En2HhUqwF7IYZNCT7VqbrYPSfywnz8LJPEusGNNPI=;
  b=XtDep7+yP+YYDLdQr4Anve4g8d4h1nBejds7gFHwYk2LSBvTrLOhxRUV
   NiGLgtfzgiPQFhW4gW6C1tYUc6rayVCq6u7zpMwG1+bNxvteUVw1AOjKe
   svyUfHX8Ui5TJXV++EbvikjaxTMWfiYoKSuhOiwWouL3gPMatxswsZFT3
   7lvWzx25liOI5f9cPy67YBARDJJChwnn3BlHm4Z6a+RwhM1s3dZ2CjUea
   Qm73xXRGxyT42xTdEzD7wPgnLwzbX2cbsUTCfDUh3MlObp4VUECz2aC1K
   MAiM8WSt47UWyDbzsN5WLeA2mlTEVaKjnvt6L+9P9Nr6VrM0C5rK6S5yE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="345656423"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="345656423"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 04:15:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="721531398"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="721531398"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 12 Apr 2023 04:15:54 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 04:15:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 04:15:54 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 04:15:54 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 04:15:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVPwJg2HVQVZIg7PqDruRyuNJULqy2+d8ONAYtGhdBRiXKqIWaNME6eWHrQO0FDDBzwFOoKQmvSXx590KchZb1TbcVhsV+fLEv6qHG1+a0b/2lNMSEu43w8y5CM37MVWb6iuTrh8S6cIeRS6DFXdjEjsNjvAlxKULbQcmICQ4maO0kXa2/VtcLlZO4TmaBcU5rPp5tYaS4XeVjMTndsp15bcipKFT4Yzr+Sf6b4kdOCtka79xbfYo+nN9A2RuOQz4yA0OiWw6EkvrwJunYr9c/Sq5HC6Z8Bvbf0wyMrOPR2c/RolPlUY9iTTEhLYPI74lPfAf0mdimpYjNB5JX68lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/4En2HhUqwF7IYZNCT7VqbrYPSfywnz8LJPEusGNNPI=;
 b=X/2m8snzgAKQ4mO6RMJbc4TCJMwX+AvtakIcEE7qnKs8XzKA3wrl7UZMmK2OrGsiz1aoNBJv8EIuyDNd9NN4TJczSavXRZEbkIb9qPc3e7qB2P6IobHIoAGAjZixuo3EtatlZXlPYpNvep3GWwxt4LO+uSswpgGhf7cMW5RpaCsS+RmuR+nF2j6b4DOmrMAmHug1B3lTeeA5AZHR2CqM3R7GLf4kBzZI7VlaBEUEGzYgqIpRDVHwU/sC6WtqAnkQcqfh3lRej3BCODqTZhBQfi2jOBLzmpuCJpmcAg4aQ8RQx73Cv1uQ6QBfXdzHNyN30b4v5Tnrdbe02ZkkP1QSew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB4862.namprd11.prod.outlook.com (2603:10b6:a03:2de::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Wed, 12 Apr
 2023 11:15:35 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3c9e:36da:562b:f1f5%3]) with mapi id 15.20.6277.034; Wed, 12 Apr 2023
 11:15:35 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Subject: Re: [PATCH 2/2] KVM: VMX: Inject #GP, not #UD, if SGX2 ENCLS leafs
 are unsupported
Thread-Topic: [PATCH 2/2] KVM: VMX: Inject #GP, not #UD, if SGX2 ENCLS leafs
 are unsupported
Thread-Index: AQHZaBjVaqwUToI390GQi+QIa02Ixq8eASCAgACSBQCACPzaAA==
Date:   Wed, 12 Apr 2023 11:15:35 +0000
Message-ID: <5d537415da25ac654b332db64b4018dca0bae6a7.camel@intel.com>
References: <20230405234556.696927-1-seanjc@google.com>
         <20230405234556.696927-3-seanjc@google.com>
         <03504796e42badbb39d34b9e99c62ac4c2bb9b6f.camel@intel.com>
         <ZC8IsP5ehaJXQOnu@google.com>
In-Reply-To: <ZC8IsP5ehaJXQOnu@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.4 (3.46.4-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB4862:EE_
x-ms-office365-filtering-correlation-id: 729751f6-9925-4370-1aa5-08db3b473d2e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LDNuKv7Pe5AW+uWejHkIjxchQeujqUkRKIwYy4pPdMjaPWDBdsUxCeN9eF+2pRQdkLwlTTIyP0mzMyeLDt/JytpMFWpLzeAIYRy9bdo3Ril78RsFsY2IvsIc2GRWLnByGH66s4J6mtypyFlEIEjBXiWoCYl5noo/DMIEjQ8adXeAAmRul1sC4uFo3L1A5JoIeXXb/Gfbxpysr8mqzSpIuUVd/+Xr95aQ+D4LI+C2rNnnQKf5AXtEnlCfdvcQow2Z28JlH/1fTgXTMdkZGJq7mkiHXByBSRBOttTEbWN+2hsJQJPTqjA9hbeBq8Lgrj/Z/YT1XhZkoBHUgWwOt7so9G6yncbAozsjx0oSwMNvPNl9cJIZM54jZyx0QrMdG8KqsmeXpFW0pmCCcQ4xlIPpUuNuk/EJLa1BlpQJxinLhtvlwkrSMi+CPMiBAG+/HrgEi3Jsr62JNeKCIEuu3JtGQLy4cJK4UQ5vbZ67BY0vNc+5IdwzXeL0yRpv1nc44ESm0wlGAFaMJEOluKFg/u7fLgQyHL5920W9oqqzSkVq26GGsxU3+atnInbqu/Ue+ce8tc37bkm4ob3ZJFKtdKJM/PynnznUFceaNAH3ow8cwa9iX9Rozn+EkM4+34Gm95c7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199021)(71200400001)(36756003)(122000001)(38100700002)(5660300002)(2906002)(38070700005)(316002)(8676002)(8936002)(86362001)(66946007)(66446008)(6916009)(66556008)(64756008)(82960400001)(41300700001)(66476007)(4326008)(91956017)(2616005)(83380400001)(76116006)(6506007)(186003)(26005)(6512007)(54906003)(478600001)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eDdxUDVFNGlpZ1RLQjRZWUwxSTk5eHUyZzdLRitPai8wNCt4bnZmellOblF5?=
 =?utf-8?B?OW9od2ZobE41S3ZLNGFDTkhTeTMxZDd5NVc0WlBXb1BtN01qU29JcUx6S0tE?=
 =?utf-8?B?NnY0Z1RxclN1YUVKaTk2amNldUdMWWpFQXJMYXh2aGF4ZlMrN1VlMWRzL0pR?=
 =?utf-8?B?by9VZnBzc09Tc1QrdGIwcEhsVEZiMmdRc2FKR0hSWGFXWUdoUFlXRWhNNUlM?=
 =?utf-8?B?bFJTY3VMOG1VdDEzN2hMeWVpZE84TXdTL3loWmFvWUkzWTJDTGdsQWZLVEhm?=
 =?utf-8?B?MzBraEpnL2RBNHJKUmVkZnN0MU5jL2xTUUVMcUp6K0xVRDZ0T284WjZZekRr?=
 =?utf-8?B?QXZQeVRXV2toa2lMOGJiV2JwbWI5bGFBdndSdXh1S0E0aFhJdThOM1BPQlZm?=
 =?utf-8?B?WDlwMDVwblIvQUthR3NRbTlGM0kxcTVheS9XSE9ZQVVJNHBNa2lCY2Z0MlZn?=
 =?utf-8?B?Z3pCUmNKMW5XWU9yKzlLenhLcmVWUHhrZjRTeGZzdU9BZ094b2lvVXVLNkVM?=
 =?utf-8?B?TzVJTjM1YUlUT3N4aGJadFNzTGQvbW4yYVAvNDhRbnFrbElhckRHaEl0d0Ux?=
 =?utf-8?B?SkFWS0ZYRzRhMTdoMkpHbzZoVnZjMWN2WGY5QjVOWHcyUVhUNU1lYW43a25v?=
 =?utf-8?B?SmpFSHQ2bzNkZ3dmbmxHb1dWaW9oajZYOE0zbTMzQ0JOWm9PMjd3UUpJcmJm?=
 =?utf-8?B?Q1NreDBHWkRTcFVHZ1VWTFc2VW5DSlI4eS9vOHVOY1dNTDNlSFVWVVBuMFQv?=
 =?utf-8?B?Q2FvYWNKaXZucG5vWlhQUGV5dDRRcC95ZS96OHoyeEpmdGlNYWNHZHF5OWdn?=
 =?utf-8?B?YXhEcXFRZHZCaFhKbmhmK2xVdU8vblNSeEV3VEdJWWZueUVpUXRyKzRFekhv?=
 =?utf-8?B?RllGcnc1Q3NpQ3kyK01DTUVkQ0Q1RVBpVlZkd2ZLQmZXZ0hkMG45Q2pFdWxn?=
 =?utf-8?B?a0ptYVo2S0hVckF4VXg5b1dMaGFRMXprWjF0MVRqbnVrZkdNdDR6WjM5UnlV?=
 =?utf-8?B?VEdFY1luMG91NzcxdWUrN3FxdTJVKzl1UjczUjJOb2NSVi9ndzlqMWpOYWli?=
 =?utf-8?B?QzJZRmpCL1BhcDd2dVlkV2xUVWMybEFwUGN2dnlqclR1eWYwcVVEY2JYVjdi?=
 =?utf-8?B?TmZ3dEpKZ0FyajRLSlFoMW12N2xNNnRKbktLRWhzU05STU1XaDIrLzJUZjc2?=
 =?utf-8?B?Y05sRVVlOWpPUDdWZmdPQTFIdTNXczNGZERjU1hqTWNsU1Rmc285RDh3Y09H?=
 =?utf-8?B?VHloQUV5SnVmNExoSEwyNDNOazR6bnBzZGpZOHl4OFJtS2FOZnJ6eW1EaGJx?=
 =?utf-8?B?eU9OVEd4Mk82NHIyaEZXZFVvSzdGUERnTDRwMzROVEFpK2N5L09rSm1jM0tr?=
 =?utf-8?B?WENneGFIQ3ovaFBzWXQxREJxdzFuMmtOajh6T3RUUzZrR205aEhjUmp3UVhv?=
 =?utf-8?B?WGY0YzV5ZTNoVVQyU3kySGl0Ymk5d3VqcjRWWWdtNTJ5QmxWSWFIejkwcUZM?=
 =?utf-8?B?SUg0aUxFbUYwYlI2a05LZDk4RUlvVDdmNG5aeHhWempmTEk3WXVuYTRqMzFs?=
 =?utf-8?B?NkFPQkJmYjJGZC95YTQ1Z1pNalVsQnF4Z3dkL2hpVDd6WnRoQitiQjg2cW9m?=
 =?utf-8?B?SUQ5WUkzL0JnVk5mNHJOQmFDeVBqWEk0Si90cExZSE43Z0tpYTY1R0lDODhx?=
 =?utf-8?B?cHZxY2psa2FyejU0MFFteVlaTGVBcXlId1JsY0hUQ0o1cVdLQnBCRE1aaFFs?=
 =?utf-8?B?ZWFOY1JQY2ViNjVFYU0vT0NsQXhZOCt6cklONEwvQzlNQXNCeHFmcElUMVlh?=
 =?utf-8?B?V2xSZ0ZFMkRnc0tMMS92RjBLQ0NxRFp1eHdMb2JlY1N5aFB4TkpYbThxd2Za?=
 =?utf-8?B?LzU4dGVpZ3phdHdsZ1VOOGh6TjYzT2tvQlJVR0tkWVdqcFJJVXNnWG9BK1px?=
 =?utf-8?B?L3R0MCs2ZVBaVzVLS1lSZGtvS1NRd29Dc1pOSDlDdmdDZWFTL3d1eHdBR0Zu?=
 =?utf-8?B?ODQwNlVBemJ6MDRyeGZmalU5ZEpZZUVYeVEzcG1KMnM2eDNJUVEva3BTQmN1?=
 =?utf-8?B?dGtxMzRuMEh1MElJQU9SUUQvbmpJWE9Pd1VkZGNtZUVKcGY4ek9NbU5aUjM1?=
 =?utf-8?Q?fV8KScC25bxSXf4IEksu5H/8w?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7AB42F4FC244A54A8AE06AFCC6528F26@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 729751f6-9925-4370-1aa5-08db3b473d2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2023 11:15:35.7849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tYq+3kuLmZvyqbA0K98AZrFN4WJc7KxgmLr1C70bfgBQep5WdSFM74OKeua96/svRJnGFLcNjXQeKM4aLPaReQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4862
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

T24gVGh1LCAyMDIzLTA0LTA2IGF0IDExOjAwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEFwciAwNiwgMjAyMywgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBX
ZWQsIDIwMjMtMDQtMDUgYXQgMTY6NDUgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6
DQo+ID4gPiBQZXIgSW50ZWwncyBTRE0sIHVuc3VwcG9ydGVkIEVOQ0xTIGxlYWZzIHJlc3VsdCBp
biBhICNHUCwgbm90IGEgI1VELg0KPiA+ID4gU0dYMSBpcyBhIHNwZWNpYWwgc25vd2ZsYWtlIGFz
IHRoZSBTR1gxIGZsYWcgaXMgdXNlZCBieSB0aGUgQ1BVIGFzIGENCj4gPiA+ICJzb2Z0IiBkaXNh
YmxlLCBlLmcuIGlmIHNvZnR3YXJlIGRpc2FibGVzIG1hY2hpbmUgY2hlY2sgcmVwb3J0aW5nLCBp
LmUuDQo+ID4gPiBoYXZpbmcgU0dYIGJ1dCBub3QgU0dYMSBpcyBlZmZlY3RpdmVseSAiU0dYIGNv
bXBsZXRlbHkgdW5zdXBwb3J0ZWQiIGFuZA0KPiA+ID4gYW5kIHRodXMgI1VEcy4NCj4gPiANCj4g
PiBJZiBJIHJlY2FsbCBjb3JyZWN0bHksIHRoaXMgaXMgYW4gZXJyYXR1bSB3aGljaCBjYW4gY2xl
YXIgU0dYMSBpbiBDUFVJRCB3aGlsZQ0KPiA+IHRoZSBTR1ggZmxhZyBpcyBzdGlsbCBpbiBDUFVJ
RD8NCj4gDQo+IE5vcGUsIG5vdCBhbiBlcnJhdHVtLCBhcmNoaXRlY3R1cmFsIGJlaGF2aW9yLg0K
DQpJIGZvdW5kIHRoZSByZWxldmFudCBzZWN0aW9uIGluIFNETToNCg0KQWxsIHN1cHBvcnRlZCBJ
QTMyX01DaV9DVEwgYml0cyBmb3IgYWxsIHRoZSBtYWNoaW5lIGNoZWNrIGJhbmtzIG11c3QgYmUg
c2V0IGZvcg0KSW50ZWwgU0dYIHRvIGJlIGF2YWlsYWJsZQ0KKENQVUlELlNHWF9MZWFmLjA6RUFY
W1NHWDFdID09IDEpLiBBbnkgYWN0IG9mIGNsZWFyaW5nIGJpdHMgZnJvbSAnMSB0byAnMCBpbiBh
bnkNCm9mIHRoZSBJQTMyX01DaV9DVEwgcmVnaXN0ZXINCm1heSBkaXNhYmxlIEludGVsIFNHWCAo
c2V0IENQVUlELlNHWF9MZWFmLjA6RUFYW1NHWDFdIHRvIDApIHVudGlsIHRoZSBuZXh0DQpyZXNl
dC4NCg0KTG9va2luZyBhdCB0aGUgY29kZSwgaXQgc2VlbXMgY3VycmVudGx5IEtWTSB3b24ndCBj
bGVhciBTR1gxIGJpdCBpbiBDUFVJRCB3aGVuDQpndWVzdCBkaXNhYmxlcyBJQTMyX01DaV9DVEwg
KHdyaXRpbmcgMCkuICBTaG91bGQgd2UgZG8gdGhhdD8NCg0KPiANCj4gPiBCdXQgSSBhbSBub3Qg
c3VyZSB3aGV0aGVyIHRoaXMgcGFydCBpcyByZWxldmFudCB0byB0aGlzIHBhdGNoPyAgQmVjYXVz
ZSBTRE0NCj4gPiBhbHJlYWR5IHNheXMgRU5DTFMgY2F1c2VzICNVRCBpZiBTR1gxIGlzbid0IHBy
ZXNlbnQuICBUaGlzIHBhdGNoIGNoYW5nZXMNCj4gPiAidW5zdXBwb3J0ZWQgbGVhZiIgZnJvbSBj
YXVzaW5nICNVRCB0byBjYXVzaW5nICNHUCwgd2hpY2ggaXMgYWxzbyBkb2N1bWVudGVkIGluDQo+
ID4gU0RNLg0KPiANCj4gSSB3YW50ZWQgdG8gY2FwdHVyZSB3aHkgU0dYMSBpcyBkaWZmZXJlbnQg
YW5kIGdpdmVuIHNwZWNpYWwgdHJlYXRtZW50IGluIHRoZSBTRE0uDQo+IEkuZS4gdG8gZXhwbGFp
biB3aHkgU0dYMSBsZWFmcyBhcmUgYW4gZXhjZXB0aW9uIHRvIHRoZSAiI0dQIGlmIGxlYWYgdW5z
dXBwb3J0ZWQiDQo+IGNsYXVzZS4NCg0KT0suDQoNCj4gDQo+ID4gPiBGaXhlczogOTc5OGFkYmMw
NGNmICgiS1ZNOiBWTVg6IEZyYW1lIGluIEVOQ0xTIGhhbmRsZXIgZm9yIFNHWCB2aXJ0dWFsaXph
dGlvbiIpDQo+ID4gPiBDYzogQmluYmluIFd1IDxiaW5iaW4ud3VAbGludXguaW50ZWwuY29tPg0K
PiA+ID4gQ2M6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gPiA+IFNpZ25lZC1v
ZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiA+ID4gLS0t
DQo+ID4gPiAgYXJjaC94ODYva3ZtL3ZteC9zZ3guYyB8IDE1ICsrKysrKysrKy0tLS0tLQ0KPiA+
ID4gIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQo+ID4g
PiANCj4gPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3NneC5jIGIvYXJjaC94ODYv
a3ZtL3ZteC9zZ3guYw0KPiA+ID4gaW5kZXggZjg4MWY2ZmY2NDA4Li4xYzA5MmFiODljMzMgMTAw
NjQ0DQo+ID4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3NneC5jDQo+ID4gPiArKysgYi9hcmNo
L3g4Ni9rdm0vdm14L3NneC5jDQo+ID4gPiBAQCAtMzUwLDExICszNTAsMTIgQEAgc3RhdGljIGlu
dCBoYW5kbGVfZW5jbHNfZWluaXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+ID4gIA0KPiA+
ID4gIHN0YXRpYyBpbmxpbmUgYm9vbCBlbmNsc19sZWFmX2VuYWJsZWRfaW5fZ3Vlc3Qoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1LCB1MzIgbGVhZikNCj4gPiA+ICB7DQo+ID4gPiAtCWlmICghZW5hYmxl
X3NneCB8fCAhZ3Vlc3RfY3B1aWRfaGFzKHZjcHUsIFg4Nl9GRUFUVVJFX1NHWCkpDQo+ID4gPiAt
CQlyZXR1cm4gZmFsc2U7DQo+ID4gPiAtDQo+ID4gPiArCS8qDQo+ID4gPiArCSAqIEVOQ0xTICNV
RHMgaWYgU0dYMSBpc24ndCBzdXBwb3J0ZWQsIGkuZS4gdGhpcyBwb2ludCB3aWxsIGJlIHJlYWNo
ZWQNCj4gPiANCj4gPiBXaHkgI1VEcyBpbnN0ZWFkIG9mICNVRD8gIElzICNVRCBhIHZlcmI/DQo+
IA0KPiBIZWgsIGl0IGlzIG5vdyA7LSkgIEkgY2FuIHJld29yZCB0byBzb21ldGhpbmcgbGlrZQ0K
PiANCj4gCS8qDQo+IAkgKiBFTkNMUyBnZW5lcmF0ZXMgYSAjVUQgaWYgU0dYMSBpc24ndCBzdXBw
b3J0ZWQgLi4uDQo+IAkgKi8NCj4gDQo+IGlmIG15IG1hZGUgdXAgZ3JhbW1hciBpcyBjb25mdXNp
bmcuDQo+IA0KPiA+ID4gKwkgKiBpZiBhbmQgb25seSBpZiB0aGUgU0dYMSBsZWFmcyBhcmUgZW5h
YmxlZC4NCj4gPiA+ICsJICovDQo+ID4gDQo+ID4gSXMgaXQgYmV0dGVyIHRvIG1vdmUgIkVOQ0xT
ICNVRHMgaWYgU0dYMSBpc24ndCBzdXBwb3J0ZWQiIHBhcnQgdG8gLi4uDQo+ID4gDQo+ID4gPiAg
CWlmIChsZWFmID49IEVDUkVBVEUgJiYgbGVhZiA8PSBFVFJBQ0spDQo+ID4gPiAtCQlyZXR1cm4g
Z3Vlc3RfY3B1aWRfaGFzKHZjcHUsIFg4Nl9GRUFUVVJFX1NHWDEpOw0KPiA+ID4gKwkJcmV0dXJu
IHRydWU7DQo+ID4gPiAgDQo+ID4gPiAgCWlmIChsZWFmID49IEVBVUcgJiYgbGVhZiA8PSBFTU9E
VCkNCj4gPiA+ICAJCXJldHVybiBndWVzdF9jcHVpZF9oYXModmNwdSwgWDg2X0ZFQVRVUkVfU0dY
Mik7DQo+ID4gPiBAQCAtMzczLDkgKzM3NCwxMSBAQCBpbnQgaGFuZGxlX2VuY2xzKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSkNCj4gPiA+ICB7DQo+ID4gPiAgCXUzMiBsZWFmID0gKHUzMilrdm1fcmF4
X3JlYWQodmNwdSk7DQo+ID4gPiAgDQo+ID4gPiAtCWlmICghZW5jbHNfbGVhZl9lbmFibGVkX2lu
X2d1ZXN0KHZjcHUsIGxlYWYpKSB7DQo+ID4gPiArCWlmICghZW5hYmxlX3NneCB8fCAhZ3Vlc3Rf
Y3B1aWRfaGFzKHZjcHUsIFg4Nl9GRUFUVVJFX1NHWCkgfHwNCj4gPiA+ICsJICAgICFndWVzdF9j
cHVpZF9oYXModmNwdSwgWDg2X0ZFQVRVUkVfU0dYMSkpIHsNCj4gPiA+ICAJCWt2bV9xdWV1ZV9l
eGNlcHRpb24odmNwdSwgVURfVkVDVE9SKTsNCj4gPiANCj4gPiAuLi4gYWJvdmUgaGVyZSwgd2hl
cmUgdGhlIGFjdHVhbCBjb2RlIHJlc2lkZT8NCj4gDQo+IE15IGdvYWwgd2FzIHRvIGRvY3VtZW50
IHdoeSBlbmNsc19sZWFmX2VuYWJsZWRfaW5fZ3Vlc3QoKSB1bmNvbmRpdGlvbmFsbHkgcmV0dXJu
cw0KPiB0cnVlIGZvciBTR1gxIGxlYWZzLCBpLmUuIHdoeSBpdCBkb2Vzbid0IHF1ZXJ5IFg4Nl9G
RUFUVVJFX1NHWDEuICBJJ20gZGVmaW5pdGVseQ0KPiBub3Qgb3Bwb3NlZCB0byBhbHNvIGFkZGlu
ZyBhIGNvbW1lbnQgaGVyZSwgYnV0IEkgZG8gd2FudCB0byBrZWVwIHRoZSBjb21tZW50IGluDQo+
IGVuY2xzX2xlYWZfZW5hYmxlZF9pbl9ndWVzdCgpLg0KDQpTdXJlLg0KDQpBbnl3YXksDQoNClJl
dmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoNCg0K
