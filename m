Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805E170BED4
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 14:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbjEVM4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 08:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbjEVM4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 08:56:02 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119CAAA;
        Mon, 22 May 2023 05:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684760161; x=1716296161;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HTrMoQQcHFoq0fGnhUoixqvPWgpP/OEVH3/Uy+IxHrA=;
  b=HoNUS77xXPFky4EICB3BZwi+2HJ2OtQ92x7P12Dk10yYICEDdhJ6N9CH
   HYkWCgPLHnFJ9MztoauMFbyosT6qJAKGGBwE4wIj7B+mJkLEuInWE07S6
   5QGerC78pIXIgK2vXMVCuiSjqCr6iBvZg45PYyAhPYokkhid9z9AemSOG
   DMTMqyW52rRpQ4kk+XHbMi28qn5OgQcnySZl5K8LMpPnfG4AMYHSztNxC
   c1X2GDoc++uLwpIzsCcxks0JrEpQQKZiuU2y5sS+QRHmqve0d259JsmIL
   TCt/Kj8sESk0AQRrcoIlpQ11Hf847/MzMLa096Ho/x7sl1xECEqVrwPeN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="337499313"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="337499313"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 05:56:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="950068792"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="950068792"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 22 May 2023 05:56:00 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 05:55:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 05:55:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 05:55:59 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 05:55:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eznaf2cqSDYygeycYhYftcKl5nDKO4XwLkSd+yKf0w05VoCVw1dt9lfasQFKL5SkcrMECW6U4jGk9NU9ZSKbsAUuELnwkjHCfMw3pMBZTFazg++kFKSrxs+UHq8X3XWjaF+vLbzlFsZa987jrxmvpIawVPCHQq0mEHTUQcDpCiWU4GOkGDaPMtz3wCNDteB2J/iO4psNLnpBg3iV6uWjVV4suZ8Xni2t7wmeKtJSB8sgMH7KyozHmZQWARrRcXYLoinfb9+GK1gYPyHiT2+TKHhVwrO0bobi3ykknyJgMGTTdYVlUtFmrfqGcuIib8/H6BIHT7Wg2Y/vMhd64o9U3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HTrMoQQcHFoq0fGnhUoixqvPWgpP/OEVH3/Uy+IxHrA=;
 b=Vlm8Q04nD3+zCp+HOngZI4YlSMkSd+YLoP9GMkRXCynALKIEcipIDTGrZZXIPqzpx4tL3hdZ99p5WjFtxHcUPjNvei+qpkSL89ijuW7SZH5+oVPM7UtO4IK2pzrzrPJo8vjI4rsKwF7eKx7pOfFC6rop/cYNoYeIOlxyZXTFBh0tuL/WK5WZ/WB4DxvREBSVoW7lr4hk4kMuAcRGF46+P8RqiHnxLUNlJziQatbhtenkk1L2k6UuCT0+C6G2CTk8/qRWxZ8ojFutZm7eAgT68LaF0hC6We0MfX5hyExiizlrwW0n6HWBKtdoD63GjXFuFefw0RLNzYJA/2yIkPMt9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BN9PR11MB5273.namprd11.prod.outlook.com (2603:10b6:408:132::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.27; Mon, 22 May
 2023 12:55:57 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::3a8a:7ef7:fbaa:19e2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 12:55:56 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gao, Chao" <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 03/18] x86/reboot: KVM: Handle VMXOFF in KVM's reboot
 callback
Thread-Topic: [PATCH v3 03/18] x86/reboot: KVM: Handle VMXOFF in KVM's reboot
 callback
Thread-Index: AQHZhSyZF/oiSVHqKEGDwdWF74Ok0K9mTyMA
Date:   Mon, 22 May 2023 12:55:56 +0000
Message-ID: <0f683245388e36917facbda4d0b69934fce7b0a8.camel@intel.com>
References: <20230512235026.808058-1-seanjc@google.com>
         <20230512235026.808058-4-seanjc@google.com>
In-Reply-To: <20230512235026.808058-4-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BN9PR11MB5273:EE_
x-ms-office365-filtering-correlation-id: d5ca6f67-8c34-46e0-bff3-08db5ac3e27d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wP1MFTKT3rRFPeDgic9AGQgBlddUU6Mg+zkmrCa/niWbSzO6BjmsAHDJDZMAkBXmnp93h8KMtoJRwa008w0INybK7tGQEGchBo5kdtc7X1qUac7nXtN9G2BfKL6NOD9xG8h62/ybHJ6J7uIWEuv3YkZi9Hutt/xcxqv+B1Un83bXs7qHVmz7lj6tttLhHe97Cy28Gywho7KEwrfHJ1Y8jGsUXrtVUx7tAhMs7frVtLekrpcQg6d8AE9DltMcDsFog0kPgksr5rYh2u1Su3dEbFHjavlEwyG9fguSnYqH9holjzhR/5L65MYxDhT93I/nckdsFfq4Z/mK58l6wbiZ2audRP0Q65FRoaf/Ezn8cfmL5TuvoakH00cJUJXwKsHi4WjzGvRHiFNp83YHmdhy30iyUwXwIy5gI8Jsb+cPORTNpQrudceDOCgMV4U5JtCZvt4CdKCrT3VTZ6WHiZaDA1fSAXp4yI7LF3Lm5Crhw7+1aHxvfQCBwsMNCKY2v2AtD6TIf73GYsTmyxzkqlU/XcXPQsB/sivZ1YKrzwS1JHMVQYvMCcAI4Hia5ju5xfKQHf5xi1dAfyDEYQpMDQ6rMIAND3fM292uBAm11reA5JgHpx7KvkB4hxXtlIV28urs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(136003)(39860400002)(366004)(346002)(451199021)(2906002)(110136005)(54906003)(5660300002)(8676002)(8936002)(41300700001)(64756008)(91956017)(316002)(66946007)(66556008)(76116006)(66446008)(66476007)(478600001)(4326008)(36756003)(71200400001)(6486002)(26005)(6512007)(6506007)(122000001)(38100700002)(86362001)(2616005)(186003)(83380400001)(38070700005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RlJucGpTYlVnODZBamRjZlVSbE5kSnhra1F4RlRmT1dCTXY0c2wyeXB6WkQ2?=
 =?utf-8?B?U0hIQjE2RnNZc2QrK3pWWFo1amE5Q0ZuNWFqVnlSUURkc0JDRFA1MDkvd1dZ?=
 =?utf-8?B?bmE1N0J4L0pMWDZjeXR1YTI2NkxJYW91d2kwOHVtY0hTMGs5U25taExVRlE2?=
 =?utf-8?B?SHZlTWNiSVhtK1l5RXkyVUYzbHQvSjlQMzNUMVZiNlE4dUc1VVpMUkltTG5L?=
 =?utf-8?B?WHB1bTMvbnhCaFUxTnRqRE5sKzdLSkZvdXYrajBUUHV0ZEd1djh0STFod3Ri?=
 =?utf-8?B?VUl1L25WcTV6MTlZSW1ydlJXZWpFMWdqdk1kU3pUWHljazJIZHVoSUVVUFN2?=
 =?utf-8?B?S2krYmhsQ2RER3FIcnZ0UGhIUFlPYXpzSG11KzRFcjI0TWVTSUlGdWZkOWcx?=
 =?utf-8?B?aG43T1QwWDZiYldCTXV1OWdld1JrYUh4YitLVC9LdGhTWnNsdEtiMFY5Z1Jn?=
 =?utf-8?B?ZExnaG9uM0ZYbHBDa001ZWlBY3NOaXVDdDRiZUdXcXZTWGh3a2I1eDRWRXdi?=
 =?utf-8?B?TmdzNXN5QnNrdWRzRkcwcm5OUnJTSmZmd0JLeFlVM0NwZml2NmxsT1VOTUVo?=
 =?utf-8?B?MmJaWlB5RGxyYnN0UFhHYmVsSnk2elpuYTI2MWo1eVIzMEFCSGMyWGpiMUt6?=
 =?utf-8?B?UHZzdlQ4VEptUWY1MytocXpLaWJQb1pjKzJxa0FTeWJocnJZSTdPdnorWnBB?=
 =?utf-8?B?V0Myd2ppUWVQTVNJamFES2tWYVBmWHpPYngxTU1vRm5iQlNNZERNbk1MNEE0?=
 =?utf-8?B?aGJoR2JRNnk1OTg5enF1ZTBNckRNOTZ4NXNOMHl2dStEalJpZWtIaldiWUxs?=
 =?utf-8?B?STYrSGJOSHd4MlJJQmxlSFptRnYyU3pSV2VsSG0xQURabXFXa2ZKcnc3WmQz?=
 =?utf-8?B?MmJKQXZvODZWOHJaOWJFU3NKMzFuY2JPR3I1eXlCNTU5S2dyTnkwYU9FUEQx?=
 =?utf-8?B?UGEwcnZKRHVFaEF4b0I3ZFBRcjRVNXkwa0FKQWVURHpKVTFRMERHM3VYUHFU?=
 =?utf-8?B?ZDd0U0krdzdFb0g2SjBCK3h2NFpMUVlXY2JoRTJ3RTVTcHVGVGc5NVpMZHVy?=
 =?utf-8?B?SmlQZFJPcHVGKzlsTmUvRlpRa1pMVDh3NUR2NHd0bTZuQUR2RnNmTFJSMlZq?=
 =?utf-8?B?dHNJRFkvQkJsV3dvQi9VS0IrRGJEamE5OWwvN3czcVFueWRLZjBNeFJqT2pK?=
 =?utf-8?B?UStHQnUveGczTjRkTXRvTTlIMlNpOW1odmM5UXJDQzVYVFZFQ3JaQW01dG1M?=
 =?utf-8?B?VXU5YklyKzM2Snc5SG1YQThCU3M4TmJJbDlLYkkwZWtqckpYZFFNK015L1Yv?=
 =?utf-8?B?aFo0cDlGbm5kVDdOazlBWi9OWXJBcUo1STZjMEN0T2xqVGI4WTVwZGVONzR5?=
 =?utf-8?B?Zmx1VytkTVBEaDlqMVZTY0JXZE9icTl4QXRuUFY1U213UW5IOEorZmVqTjdG?=
 =?utf-8?B?ZWdpajJsQmc3RkRHdms3dVRnZm00eDgrbU9SQldEYXlONHdtSGMxZWd4aThi?=
 =?utf-8?B?Y2NQYUlqTE0xeW1paW9MTkdjSktsREpybmJLTTFyaXBSbXFzWENiRnpWc0NW?=
 =?utf-8?B?ekplVUM2dDkrenl4SWYzWTY4L3ZVTC95SFlWM1BRMG12RXZ6clJQaXA1WWF1?=
 =?utf-8?B?cUZmazU4SjBveHNiRFdUa3ArUVZYWXhBSytEZERLcXhVQ1hRV2NTYWRNOHJO?=
 =?utf-8?B?QVJRSldudnFRUCtabE14aExSOWNhQnFrRHlIbitldHlxN09CTWZsUHl6UzVo?=
 =?utf-8?B?L3MxQ0MzYTRwN2RXNE9WZW1zcFlPZU42UWUyVU9EWmR2MVFOSmxXWDNoK09G?=
 =?utf-8?B?M1dPWEYyZ25TS2xIZGRoWFhGeVVTL2dWeDZ6VndYRHhmVlI2bUFCb1hUTFpH?=
 =?utf-8?B?RTkxZThLQmRweXNlYzdnYlNLeGdSeFVoT09UaXpsV0RSUFJPeXlQaExwNWEw?=
 =?utf-8?B?Tm5UY2tOSTY4WXhhTU5Gbm9vMDU3MEZoL0MyL0R3Y3ppS0ZNMEtDMVd2U1dj?=
 =?utf-8?B?bkNHa0pkYStzaCtTN09YYW1ldk1LbVhBWEZ0ZHdQMEdYUk1adlFpcTU3azF6?=
 =?utf-8?B?ZUh4VzFaYXlDR0ROSkY1LzJzNDdGRS9tQVowNWZDRUF0ZVQ1TXRGWFpKbHNx?=
 =?utf-8?B?bDk5VkdwdlNHU2cwOGQ3ZTVmSk5rRGswcEpZcHZFa0xMb1ByNW5xQmx6MWVn?=
 =?utf-8?B?dWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8271265FC618A4CB508877A189923D2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5ca6f67-8c34-46e0-bff3-08db5ac3e27d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2023 12:55:56.7683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5gJoIbNkUtTpp6bnb4/jUPUellpI2OK/la7UAlVX/pO5XYQfq0pjcnk9vG2br7Gtq/1I0M1QZZYe6Zdc9sUKlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5273
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIzLTA1LTEyIGF0IDE2OjUwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBVc2UgS1ZNIFZNWCdzIHJlYm9vdC9jcmFzaCBjYWxsYmFjayB0byBkbyBWTVhPRkYg
aW4gYW4gZW1lcmdlbmN5IGluc3RlYWQNCj4gb2YgbWFudWFsbHkgYW5kIGJsaW5kbHkgZG9pbmcg
Vk1YT0ZGLiAgVGhlcmUncyBubyBuZWVkIHRvIGF0dGVtcHQgVk1YT0ZGDQo+IGlmIGEgaHlwZXJ2
aXNvciwgaS5lLiBLVk0sIGlzbid0IGxvYWRlZC9hY3RpdmUsIGkuZS4gaWYgdGhlIENQVSBjYW4n
dA0KPiBwb3NzaWJseSBiZSBwb3N0LVZNWE9OLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBD
aHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IC0tLQ0KPiAgYXJjaC94ODYvaW5j
bHVkZS9hc20vdmlydGV4dC5oIHwgMTAgLS0tLS0tLS0tLQ0KPiAgYXJjaC94ODYva2VybmVsL3Jl
Ym9vdC5jICAgICAgIHwgMjkgKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gIGFyY2gv
eDg2L2t2bS92bXgvdm14LmMgICAgICAgICB8ICA4ICsrKysrLS0tDQo+ICAzIGZpbGVzIGNoYW5n
ZWQsIDE0IGluc2VydGlvbnMoKyksIDMzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2luY2x1ZGUvYXNtL3ZpcnRleHQuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Zp
cnRleHQuaA0KPiBpbmRleCAzYjEyZTZiOTk0MTIuLjViYzI5ZmFiMTVkYSAxMDA2NDQNCj4gLS0t
IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdmlydGV4dC5oDQo+ICsrKyBiL2FyY2gveDg2L2luY2x1
ZGUvYXNtL3ZpcnRleHQuaA0KPiBAQCAtNzAsMTYgKzcwLDYgQEAgc3RhdGljIGlubGluZSB2b2lk
IF9fY3B1X2VtZXJnZW5jeV92bXhvZmYodm9pZCkNCj4gIAkJY3B1X3ZteG9mZigpOw0KPiAgfQ0K
PiAgDQo+IC0vKiogRGlzYWJsZSBWTVggaWYgaXQgaXMgc3VwcG9ydGVkIGFuZCBlbmFibGVkIG9u
IHRoZSBjdXJyZW50IENQVQ0KPiAtICovDQo+IC1zdGF0aWMgaW5saW5lIHZvaWQgY3B1X2VtZXJn
ZW5jeV92bXhvZmYodm9pZCkNCj4gLXsNCj4gLQlpZiAoY3B1X2hhc192bXgoKSkNCj4gLQkJX19j
cHVfZW1lcmdlbmN5X3ZteG9mZigpOw0KPiAtfQ0KPiAtDQo+IC0NCj4gLQ0KPiAgDQo+ICAvKg0K
PiAgICogU1ZNIGZ1bmN0aW9uczoNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9yZWJv
b3QuYyBiL2FyY2gveDg2L2tlcm5lbC9yZWJvb3QuYw0KPiBpbmRleCA3MzllMDk1MjdkYmIuLjBj
ZjIyNjFjMmRlYyAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva2VybmVsL3JlYm9vdC5jDQo+ICsr
KyBiL2FyY2gveDg2L2tlcm5lbC9yZWJvb3QuYw0KPiBAQCAtNzg3LDEzICs3ODcsNyBAQCB2b2lk
IG1hY2hpbmVfY3Jhc2hfc2h1dGRvd24oc3RydWN0IHB0X3JlZ3MgKnJlZ3MpDQo+ICB9DQo+ICAj
ZW5kaWYNCj4gIA0KPiAtLyoNCj4gLSAqIFRoaXMgaXMgdXNlZCB0byBWTUNMRUFSIGFsbCBWTUNT
cyBsb2FkZWQgb24gdGhlDQo+IC0gKiBwcm9jZXNzb3IuIEFuZCB3aGVuIGxvYWRpbmcga3ZtX2lu
dGVsIG1vZHVsZSwgdGhlDQo+IC0gKiBjYWxsYmFjayBmdW5jdGlvbiBwb2ludGVyIHdpbGwgYmUg
YXNzaWduZWQuDQo+IC0gKg0KPiAtICogcHJvdGVjdGVkIGJ5IHJjdS4NCj4gLSAqLw0KPiArLyog
UkNVLXByb3RlY3RlZCBjYWxsYmFjayB0byBkaXNhYmxlIHZpcnR1YWxpemF0aW9uIHByaW9yIHRv
IHJlYm9vdC4gKi8NCj4gIHN0YXRpYyBjcHVfZW1lcmdlbmN5X3ZpcnRfY2IgX19yY3UgKmNwdV9l
bWVyZ2VuY3lfdmlydF9jYWxsYmFjazsNCj4gIA0KPiAgdm9pZCBjcHVfZW1lcmdlbmN5X3JlZ2lz
dGVyX3ZpcnRfY2FsbGJhY2soY3B1X2VtZXJnZW5jeV92aXJ0X2NiICpjYWxsYmFjaykNCj4gQEAg
LTgxNSwxNyArODA5LDYgQEAgdm9pZCBjcHVfZW1lcmdlbmN5X3VucmVnaXN0ZXJfdmlydF9jYWxs
YmFjayhjcHVfZW1lcmdlbmN5X3ZpcnRfY2IgKmNhbGxiYWNrKQ0KPiAgfQ0KPiAgRVhQT1JUX1NZ
TUJPTF9HUEwoY3B1X2VtZXJnZW5jeV91bnJlZ2lzdGVyX3ZpcnRfY2FsbGJhY2spOw0KPiAgDQo+
IC1zdGF0aWMgaW5saW5lIHZvaWQgY3B1X2NyYXNoX3ZtY2xlYXJfbG9hZGVkX3ZtY3NzKHZvaWQp
DQo+IC17DQo+IC0JY3B1X2VtZXJnZW5jeV92aXJ0X2NiICpjYWxsYmFjazsNCj4gLQ0KPiAtCXJj
dV9yZWFkX2xvY2soKTsNCj4gLQljYWxsYmFjayA9IHJjdV9kZXJlZmVyZW5jZShjcHVfZW1lcmdl
bmN5X3ZpcnRfY2FsbGJhY2spOw0KPiAtCWlmIChjYWxsYmFjaykNCj4gLQkJY2FsbGJhY2soKTsN
Cj4gLQlyY3VfcmVhZF91bmxvY2soKTsNCj4gLX0NCj4gLQ0KPiAgLyogVGhpcyBpcyB0aGUgQ1BV
IHBlcmZvcm1pbmcgdGhlIGVtZXJnZW5jeSBzaHV0ZG93biB3b3JrLiAqLw0KPiAgaW50IGNyYXNo
aW5nX2NwdSA9IC0xOw0KPiAgDQo+IEBAIC04MzYsOSArODE5LDE1IEBAIGludCBjcmFzaGluZ19j
cHUgPSAtMTsNCj4gICAqLw0KPiAgdm9pZCBjcHVfZW1lcmdlbmN5X2Rpc2FibGVfdmlydHVhbGl6
YXRpb24odm9pZCkNCj4gIHsNCj4gLQljcHVfY3Jhc2hfdm1jbGVhcl9sb2FkZWRfdm1jc3MoKTsN
Cj4gKwljcHVfZW1lcmdlbmN5X3ZpcnRfY2IgKmNhbGxiYWNrOw0KPiAgDQo+IC0JY3B1X2VtZXJn
ZW5jeV92bXhvZmYoKTsNCj4gKwlyY3VfcmVhZF9sb2NrKCk7DQo+ICsJY2FsbGJhY2sgPSByY3Vf
ZGVyZWZlcmVuY2UoY3B1X2VtZXJnZW5jeV92aXJ0X2NhbGxiYWNrKTsNCj4gKwlpZiAoY2FsbGJh
Y2spDQo+ICsJCWNhbGxiYWNrKCk7DQo+ICsJcmN1X3JlYWRfdW5sb2NrKCk7DQo+ICsNCj4gKwkv
KiBLVk1fQU1EIGRvZXNuJ3QgeWV0IHV0aWxpemUgdGhlIGNvbW1vbiBjYWxsYmFjay4gKi8NCj4g
IAljcHVfZW1lcmdlbmN5X3N2bV9kaXNhYmxlKCk7DQo+ICB9DQo+ICANCj4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2t2bS92bXgvdm14LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+IGluZGV4
IGZjOWNkYjQxMTRjYy4uNzZjZGIxODlmMWI1IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0v
dm14L3ZteC5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gQEAgLTc0NCw3ICs3
NDQsNyBAQCBzdGF0aWMgaW50IHZteF9zZXRfZ3Vlc3RfdXJldF9tc3Ioc3RydWN0IHZjcHVfdm14
ICp2bXgsDQo+ICAJcmV0dXJuIHJldDsNCj4gIH0NCj4gIA0KPiAtc3RhdGljIHZvaWQgY3Jhc2hf
dm1jbGVhcl9sb2NhbF9sb2FkZWRfdm1jc3Modm9pZCkNCj4gK3N0YXRpYyB2b2lkIHZteF9lbWVy
Z2VuY3lfZGlzYWJsZSh2b2lkKQ0KPiAgew0KPiAgCWludCBjcHUgPSByYXdfc21wX3Byb2Nlc3Nv
cl9pZCgpOw0KPiAgCXN0cnVjdCBsb2FkZWRfdm1jcyAqdjsNCj4gQEAgLTc1Miw2ICs3NTIsOCBA
QCBzdGF0aWMgdm9pZCBjcmFzaF92bWNsZWFyX2xvY2FsX2xvYWRlZF92bWNzcyh2b2lkKQ0KPiAg
CWxpc3RfZm9yX2VhY2hfZW50cnkodiwgJnBlcl9jcHUobG9hZGVkX3ZtY3NzX29uX2NwdSwgY3B1
KSwNCj4gIAkJCSAgICBsb2FkZWRfdm1jc3Nfb25fY3B1X2xpbmspDQo+ICAJCXZtY3NfY2xlYXIo
di0+dm1jcyk7DQo+ICsNCj4gKwlfX2NwdV9lbWVyZ2VuY3lfdm14b2ZmKCk7DQoNCl9fY3B1X2Vt
ZXJnZW5jeV92bXhvZmYoKSBpbnRlcm5hbGx5IGNoZWNrcyB3aGV0aGVyIFZNWCBpcyBlbmFibGVk
IGluIENSNC4gIA0KTG9naWNhbGx5LCBsb29rcyBpdCdzIG1vcmUgcmVhc29uYWJsZSB0byBkbyBz
dWNoIGNoZWNrIGJlZm9yZSBWTUNMRUFSIGFjdGl2ZQ0KVk1DU2VzLCBhbHRob3VnaCBpbiBwcmFj
dGljZSB0aGVyZSBzaG91bGQgYmUgbm8gcHJvYmxlbSBJIHRoaW5rLg0KDQpCdXQgdGhpcyBwcm9i
bGVtIGluaGVyaXRzIGZyb20gdGhlIGV4aXN0aW5nIGNvZGUgaW4gIHVwc3RyZWFtLCBzbyBub3Qg
c3VyZQ0Kd2hldGhlciBpdCBpcyB3b3J0aCBmaXhpbmcuDQoNCj4gIH0NCj4gIA0KPiAgc3RhdGlj
IHZvaWQgX19sb2FkZWRfdm1jc19jbGVhcih2b2lkICphcmcpDQo+IEBAIC04NTQ3LDcgKzg1NDks
NyBAQCBzdGF0aWMgdm9pZCBfX3ZteF9leGl0KHZvaWQpDQo+ICB7DQo+ICAJYWxsb3dfc21hbGxl
cl9tYXhwaHlhZGRyID0gZmFsc2U7DQo+ICANCj4gLQljcHVfZW1lcmdlbmN5X3VucmVnaXN0ZXJf
dmlydF9jYWxsYmFjayhjcmFzaF92bWNsZWFyX2xvY2FsX2xvYWRlZF92bWNzcyk7DQo+ICsJY3B1
X2VtZXJnZW5jeV91bnJlZ2lzdGVyX3ZpcnRfY2FsbGJhY2sodm14X2VtZXJnZW5jeV9kaXNhYmxl
KTsNCj4gIA0KPiAgCXZteF9jbGVhbnVwX2wxZF9mbHVzaCgpOw0KPiAgfQ0KPiBAQCAtODU5Nyw3
ICs4NTk5LDcgQEAgc3RhdGljIGludCBfX2luaXQgdm14X2luaXQodm9pZCkNCj4gIAkJcGlfaW5p
dF9jcHUoY3B1KTsNCj4gIAl9DQo+ICANCj4gLQljcHVfZW1lcmdlbmN5X3JlZ2lzdGVyX3ZpcnRf
Y2FsbGJhY2soY3Jhc2hfdm1jbGVhcl9sb2NhbF9sb2FkZWRfdm1jc3MpOw0KPiArCWNwdV9lbWVy
Z2VuY3lfcmVnaXN0ZXJfdmlydF9jYWxsYmFjayh2bXhfZW1lcmdlbmN5X2Rpc2FibGUpOw0KPiAg
DQo+ICAJdm14X2NoZWNrX3ZtY3MxMl9vZmZzZXRzKCk7DQo+ICANCj4gLS0gDQo+IDIuNDAuMS42
MDYuZ2E0YjFiMTI4ZDYtZ29vZw0KPiANCg0K
