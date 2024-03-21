Return-Path: <kvm+bounces-12374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D4289885850
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 12:28:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49AC01F2168E
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 11:28:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB64758ACC;
	Thu, 21 Mar 2024 11:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KOCwTsMI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E1958AB0;
	Thu, 21 Mar 2024 11:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711020472; cv=fail; b=bbbp2+S7t9su/G2Os9pz5H1zT+XIWHJgDE4B4k/p4+zL7s+rGqE/IKoAqpWqhUvatX0zmcjL5lwtKQ5B6IUHjnQfr86b4eKcVqGEpIvhT5WHx1SVDDpz0DMCEy6Nx3IIt6LRVoramdkHrfXy7ujs2sT2Syp5J59sdIz80ls4RV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711020472; c=relaxed/simple;
	bh=dD2EcBXj8wdUK7j+OL6bESzaz7Lb8eg9hpHmMwHx71k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KdgVx42NCs3h6/ttqiIBieg/O3DdTMwCzd5Mf1+9a2mdaDUgUvklWD/jiGhfRWnI+9JSBvWfyhCyY5W1DtM9wrYRnluLRNCX7s2bnHmzXpFREK8SIJwwrBBm6aYLtoAFJW41KkoReV0EU8qCRNp9Wq/imldVl2W3VSabE0e/7Og=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KOCwTsMI; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711020471; x=1742556471;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dD2EcBXj8wdUK7j+OL6bESzaz7Lb8eg9hpHmMwHx71k=;
  b=KOCwTsMIElPT/NIaGGxbC9VhgUuq4y4+5m3XtX1LI/g6jC4uMYV8mSym
   i7Qjw7fhR5Sre2FE0F35Khjify6/1N1GCIQgch4xKE/aBbw3a1iba1EPz
   PSZlzB4BvceuIBK8xCVvTxUlnOT0IbN6kMSA0gTOriKhrSqWCMAo2wCyj
   HD8xtXyG+XLya8xlpBwvFzN8e36Xme5tftySOnhI1LmrOcBqr+zvBkOvE
   P50QZYxnZ6adhUZsmVWyl3sVXf3J/lRgx3LogjZNg7ydxJ+mmL4rFeT7z
   2p67hk8kB1z9S6sZZKqYmNwnG5NgHmWT8JBHTXCkin2wqyhJ0yfTwyiuL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="31440284"
X-IronPort-AV: E=Sophos;i="6.07,142,1708416000"; 
   d="scan'208";a="31440284"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 04:27:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,142,1708416000"; 
   d="scan'208";a="14533126"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Mar 2024 04:27:49 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 04:27:49 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 04:27:49 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 21 Mar 2024 04:27:49 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 21 Mar 2024 04:27:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvVtSdL+BFpy5GiLwEt7sg0EyTeXlULuWlKpowmgZGcYTWXq0WiL2MjXLDv2mFkbxgUp0T7OaexP3h8D39CXS48z2H53Sw0tgeW9EuxkpcnfHDT/KxaCnj9ezpJF6p7Nwmd5hB4a2Wa+9mXkIsNVlRZFt8poO2CJgt34aV2RtE5w5Tx/PybAt0T+MeYNB85L8KyCwXbT3VC8nwrvmK42P8kB0Jb1oyyMpRoodNE0BMTRhr/vEmSeui43ZWv9TKTtCSlxbM2EbpCvlRjt9iiYEXFYluUctbz6+zt5Av7Kn56GtlgihNifq1gS97O/aRcLCEnQfMi11rt0cHkAdyOGBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dD2EcBXj8wdUK7j+OL6bESzaz7Lb8eg9hpHmMwHx71k=;
 b=heoATHTPQ7Ve4czg/2CrdTYuc9z9pePKsL8bBidmXZJckPEUXviTbQy0CvjgKAJ4SzcEVs2Pb5CaEfQC9Dtsl1Vd1op6hALQBvuDk1gH93JDQhU2k38ZcnuID45Uf+0i/xiOCvGdtDLqjoKlx5hIodrjCgfMW4hYjWoa33uHS2+LGdVaMdp7k6EOPzV1gvh2vWRRl+/XDQYkozKVlzx0xYGPXzkcMczeyYGRRX4PBQdoV2mt5iRx1PaXyGrNilX35778tIAE5kIxBt9GJJAlpQilZu9RYw+Xxbo1lrUjXyGwORe06V66C4mYfpbArNd/H1jDFFBaBOIoQp7TKQzSjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12; Thu, 21 Mar
 2024 11:27:46 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Thu, 21 Mar 2024
 11:27:46 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 022/130] KVM: x86/vmx: Refactor KVM VMX module
 init/exit functions
Thread-Topic: [PATCH v19 022/130] KVM: x86/vmx: Refactor KVM VMX module
 init/exit functions
Thread-Index: AQHaaI21YOooq2aMtkSKfcYGJ/b797FCNHmA
Date: Thu, 21 Mar 2024 11:27:46 +0000
Message-ID: <0f466c5845e9d75b25392ecb5129c4e984052c1b.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <11d5ae6a1102a50b0e773fc7efd949bb0bd2b776.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <11d5ae6a1102a50b0e773fc7efd949bb0bd2b776.1708933498.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7925:EE_
x-ms-office365-filtering-correlation-id: 7580dfd0-16bd-4527-4fca-08dc4999eee4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OAHmHyEsqUEfvXMSmnlKpEw0n5Upv4oxcz0PYHgircfwG5cf1xp2fZO34RGu7bULFzrh41w3Hzh3TLCpTtjaVb1YwrAYZpmGJGpyu34Zm0AvsaiQNcRXJglUoYK0hUMs1Jk1LvR2QIvXIG96usb026ZtuXSuuI6EHF9swWCIhBrvekSAbVIWjwKc1PeFvX/o5Uv4IXEtDpIrLjwuZxpX2xehO1WfEwo3vt5VQ3PFE9AQELWQDqWlB4kt/guKF0ucywyixeXUQOZxKiWivEGSj6kW0c498RWKY+GZYIYrODajR4lmaTN1UyibGa50A+3WpDj55t/hMVyFAuDEu4Ll3SlhTZmvsfakuLr5CVhS93OU/CXyG0n8QXZHdiSNEcFO1Qeb2s5z11wrOd0H/NHNjel7CGmCVWD0dtsmOo3QDfzcDCsgXeKj5GJdDldLe2Gsgc7Ts6SMq0oqv0V0Gv3CqieVSwGFrHFAFgxOhPoC90x8ZXXHj+w/1bfQpHx+k+P3Pi+6MIWZLuKbLWGkfae9qRqUiAkWqG3rnEozdhTxWyxSSoLXjFVW/YAy4WFkdsYiEo7Bz7RQFtFu/Xgu+mdjHe+u8tVCF7dMIqwelImcrzxeZYkgXVCvPnfGMdqEj+iuWetVef66liRiamLUd6fci4f8ZAXZIRcybl10/dtkV6A4EXDazeXu+f48yBLovb28HoR8CSZY/TpEUAxWqR5Oh9JwH6G2ZbcRYTJlf0FpVJs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVpmS05nb1JmdkxjWE5BYms1bElJWEZHNVhmQ0ZLdnR1RVhHUkdMdGxrNDV2?=
 =?utf-8?B?N1dxU3FYdCtBTXFOTEQwVjRHMFZCanhmOWRmL3NpR1k0cjhPWDJtSVU0RElD?=
 =?utf-8?B?RXVjT0lPUU5Rem9LOWc4eHZoYkpNMFBYOHgwL2M0QmhXMDhtbk9sc2lFWTRU?=
 =?utf-8?B?TGVId1NVeE45em9aM1A5OEt1L2FBV2hCcDUzWFdLWlZJWkZrWC9MaExwRHZM?=
 =?utf-8?B?anFFVW56S2lETVdPTEZRY2RGRnZoYVZsRHFIaERMdmNNQWlDbyt6aW1oTzBt?=
 =?utf-8?B?VytBWFBUKzRXUVdGaTFwR05EbW5hK1pRT0VZV0dESUFiVkNlbnBXcWh1d1JS?=
 =?utf-8?B?akY5c1ZqdUszcVJjUS9DRHZDQU1YT1kwSTQ1ZXJRWklUR0ZxVzdCalBCdWZx?=
 =?utf-8?B?ZEIwOGdCem54ZUkxZGRCYTdBOW9wcWpRU01KdCs1ZU8za2JKRWZBazdjc1hP?=
 =?utf-8?B?dXlYWGw5SmVEZlpwTENMdmZlYURqZ3JPVURBRThrNUVWdTNvYnRsa2tFK3pU?=
 =?utf-8?B?QVc0eitYQ2RZa1JNVXU3ZEFLcUFndkhNMTI5UkxOSE1rcFo5WGlSb3dQclZD?=
 =?utf-8?B?V3VOdG9sbEpYY3BhY1BRd1hDZm1LYU1DVU8vSEtKWEduSVNTMzJOa2RHcTFs?=
 =?utf-8?B?VkFzZm9xdm84YlR4Rzd3c2tQTklwWWVzejMxczc3REZCaVp5NCtFNFBrM3VH?=
 =?utf-8?B?QnFBc0JaMWk5UkRmOUh0cndpVG0vRnk0a3FHeTRudjdPR0xTL3NwUjdjME9Q?=
 =?utf-8?B?ZW9hQ3NJYXcwQklBaEoxYy9JaHowZjgrWXpIdzNRVHovVU9RMUZNVUExUmd0?=
 =?utf-8?B?cDhmNytSSU5vb0JTbWUrOXNsMU9waGV5WnZIWElGRUpqT1BtNWNlYnZkcEUy?=
 =?utf-8?B?ZmYrcGF6Y3pseVg3T0h3VUo3RWFwWk96MXdodXRGT3o0RGhiVFRsdnRvVWlZ?=
 =?utf-8?B?bTRFUWx4aHZIVUJ4cW5semhRMnEyQlB3aWRMZmNHOW1OQXRpbEtQdHZTM1pN?=
 =?utf-8?B?Z1J2R3lDSEJSR0RxaGFKSDRwZGltV2tMMlFkbTFMYTViZlRRaGN2cVRuOFRO?=
 =?utf-8?B?R3FXbGhjZXF5MnZnbit3N1ViUDZRcHd2QVZBQUlaVHRMNE1LQW9kT2FzelRk?=
 =?utf-8?B?QmhoMUNJSGd5V3ZHOWd2Ujh3WmlxMFozc2pENWsxSVhJejRMQ2NZZW9VdmRW?=
 =?utf-8?B?cFc0MnFrWVVQSXBBNUljMzYxc0wrVklSSUhBOHZDMXNZVDJCOVlnWnREOGxO?=
 =?utf-8?B?WTlLVTBFdGp0SENFMGFSdGVhWDdLaGh6OFJyQ3lWSWRBTVAxZ3V4blNqVmV6?=
 =?utf-8?B?bVVHRFhpdFdKN1ZFRStqNXR1aVA2RXc2aUpyZHlXejgxVGF3N25VL2U1ZnlK?=
 =?utf-8?B?WjZBSDlKL1hKZThoVE9QVXhOL1Y4V0QvN1R2ZFVDTUQ4UzV1WDZWVVVPUWlt?=
 =?utf-8?B?MWJvdGtsUEdJL1JEWGZhMjZMeGtjRHNOU3ZUUmJxWGJzVGVkNGk2QjMzRWVD?=
 =?utf-8?B?aVdRYmIzajJsc3l6OEtaMnRvS2hGdGkrSCt2M28wZ21JOU1OL2c4NTBpa0dE?=
 =?utf-8?B?QlZNZEd6RlRyRGpYK2tQRlByZjIwWklRQlVYcmkyMXFzaTJsWGFnTUlBdUs2?=
 =?utf-8?B?OHQ5K2IycktOY1Zla3hhbDA5NERsNktEdmMwZnZiNnk2RStXYzVMQmtlNTlZ?=
 =?utf-8?B?aXY0T2Jhby9DbzhZam43T0tFWGlxT0F5dXFnZUlJb2NUZWRkL3hIUk44TVor?=
 =?utf-8?B?enVqR1pEM2N0VlgxN2ZhdVVFSy94aEJNc0NDQ0VZUTVnUnpxNGNRbG9odC9W?=
 =?utf-8?B?OVlqREIrS1E0RWJiQXI3SGFwbzhHaHhQMk1EblQ0NE1Pb3NPMDdZNVlvM0xS?=
 =?utf-8?B?N0lCQXhhQ2dvZ1VvZTVIcXQ1eTJMakhiakg5R2dvcVJDVE55T3VVb0E2OGVQ?=
 =?utf-8?B?KytKZXA0NDFOMjJmTVlFM0NZWlc4TGV5Y3JTdmpaSDRDYTg4U2U3T2JwOUZF?=
 =?utf-8?B?N2FXWmVEbkhHTzhiWkxJUk9TYThoazJuL0MzNmV6d1p4Wm9CMFVjV3FqYkFp?=
 =?utf-8?B?Sm5iejFnT1VPYWplS2tORnlTam5ONUluUWx2ajB2MUNTVVY1WWNHNFg2UTgw?=
 =?utf-8?B?QkNpb04wTm8rcDBSK01SazIzOFBzTVc1YlRYMS9ldnZSZHhmNXo0dGRVY09v?=
 =?utf-8?B?d2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5AE7BDAA7A14394B87907DA72F4F3034@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7580dfd0-16bd-4527-4fca-08dc4999eee4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2024 11:27:46.5994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mpgJmEsfdVQKqq2sj3lcwrw8UILVIgPAQwblTdIVezQYpZ3kzGmoDQgsHWe82+AwYXJjXIVmWAY8L/EyI39IEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7925
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI1IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBDdXJyZW50bHksIEtWTSBWTVggbW9kdWxlIGluaXRpYWxpemF0aW9uL2V4aXQg
ZnVuY3Rpb25zIGFyZSBhIHNpbmdsZQ0KPiBmdW5jdGlvbiBlYWNoLiAgUmVmYWN0b3IgS1ZNIFZN
WCBtb2R1bGUgaW5pdGlhbGl6YXRpb24gZnVuY3Rpb25zIGludG8gS1ZNDQo+IGNvbW1vbiBwYXJ0
IGFuZCBWTVggcGFydCBzbyB0aGF0IFREWCBzcGVjaWZpYyBwYXJ0IGNhbiBiZSBhZGRlZCBjbGVh
bmx5Lg0KPiBPcHBvcnR1bmlzdGljYWxseSByZWZhY3RvciBtb2R1bGUgZXhpdCBmdW5jdGlvbiBh
cyB3ZWxsLg0KPiANCj4gVGhlIGN1cnJlbnQgbW9kdWxlIGluaXRpYWxpemF0aW9uIGZsb3cgaXMs
DQoNCgkJCQkJICBeICcsJyAtPiAnOicNCg0KQW5kIHBsZWFzZSBhZGQgYW4gZW1wdHkgbGluZSB0
byBtYWtlIHRleHQgbW9yZSBicmVhdGhhYmxlLg0KDQo+IDAuKSBDaGVjayBpZiBWTVggaXMgc3Vw
cG9ydGVkLA0KPiAxLikgaHlwZXItdiBzcGVjaWZpYyBpbml0aWFsaXphdGlvbiwNCj4gMi4pIHN5
c3RlbS13aWRlIHg4NiBzcGVjaWZpYyBhbmQgdmVuZG9yIHNwZWNpZmljIGluaXRpYWxpemF0aW9u
LA0KPiAzLikgRmluYWwgVk1YIHNwZWNpZmljIHN5c3RlbS13aWRlIGluaXRpYWxpemF0aW9uLA0K
PiA0LikgY2FsY3VsYXRlIHRoZSBzaXplcyBvZiBWTVgga3ZtIHN0cnVjdHVyZSBhbmQgVk1YIHZj
cHUgc3RydWN0dXJlLA0KPiA1LikgcmVwb3J0IHRob3NlIHNpemVzIHRvIHRoZSBLVk0gY29tbW9u
IGxheWVyIGFuZCBLVk0gY29tbW9uDQo+ICAgICBpbml0aWFsaXphdGlvbg0KDQpJcyB0aGVyZSBh
bnkgZGlmZmVyZW5jZSBiZXR3ZWVuICJLVk0gY29tbW9uIGxheWVyIiBhbmQgIktWTSBjb21tb24N
CmluaXRpYWxpemF0aW9uIj8gIEkgdGhpbmsgeW91IGNhbiByZW1vdmUgdGhlIGZvcm1lci4NCg0K
PiANCj4gUmVmYWN0b3IgdGhlIEtWTSBWTVggbW9kdWxlIGluaXRpYWxpemF0aW9uIGZ1bmN0aW9u
IGludG8gZnVuY3Rpb25zIHdpdGggYQ0KPiB3cmFwcGVyIGZ1bmN0aW9uIHRvIHNlcGFyYXRlIFZN
WCBsb2dpYyBpbiB2bXguYyBmcm9tIGEgZmlsZSwgbWFpbi5jLCBjb21tb24NCj4gYW1vbmcgVk1Y
IGFuZCBURFguICBJbnRyb2R1Y2UgYSB3cmFwcGVyIGZ1bmN0aW9uIGZvciB2bXhfaW5pdCgpLg0K
DQpTb3JyeSBJIGRvbid0IHF1aXRlIGZvbGxvdyB3aGF0IHlvdXIgYXJlIHRyeWluZyB0byBzYXkg
aW4gdGhlIGFib3ZlIHBhcmFncmFwaC4NCg0KWW91IGhhdmUgYWRlcXVhdGVseSBwdXQgd2hhdCBp
cyB0aGUgX2N1cnJlbnRfIGZsb3csIGFuZCBJIGFtIGV4cGVjdGluZyB0byBzZWUNCnRoZSBmbG93
IF9hZnRlcl8gdGhlIHJlZmFjdG9yIGhlcmUuDQogIA0KPiANCj4gVGhlIEtWTSBhcmNoaXRlY3R1
cmUgY29tbW9uIGxheWVyIGFsbG9jYXRlcyBzdHJ1Y3Qga3ZtIHdpdGggcmVwb3J0ZWQgc2l6ZQ0K
PiBmb3IgYXJjaGl0ZWN0dXJlLXNwZWNpZmljIGNvZGUuICBUaGUgS1ZNIFZNWCBtb2R1bGUgZGVm
aW5lcyBpdHMgc3RydWN0dXJlDQo+IGFzIHN0cnVjdCB2bXhfa3ZtIHsgc3RydWN0IGt2bTsgVk1Y
IHNwZWNpZmljIG1lbWJlcnM7fSBhbmQgdXNlcyBpdCBhcw0KPiBzdHJ1Y3Qgdm14IGt2bS4gIFNp
bWlsYXIgZm9yIHZjcHUgc3RydWN0dXJlLiBURFggS1ZNIHBhdGNoZXMgd2lsbCBkZWZpbmUNCg0K
CSBedm14X2t2bS4NCg0KUGxlYXNlIGJlIG1vcmUgY29uc2lzdGVudCBvbiB0aGUgd29yZHMuDQoN
Cj4gVERYIHNwZWNpZmljIGt2bSBhbmQgdmNwdSBzdHJ1Y3R1cmVzLg0KDQpJcyB0aGlzIHBhcmFn
cmFwaCByZWxhdGVkIHRvIHRoZSBjaGFuZ2VzIGluIHRoaXMgcGF0Y2g/DQoNCkZvciBpbnN0YW5j
ZSwgd2h5IGRvIHlvdSBuZWVkIHRvIHBvaW50IG91dCB3ZSB3aWxsIGhhdmUgVERYLXNwZWNpZmlj
ICdrdm0gYW5kDQp2Y3B1JyBzdHJ1Y3R1cmVzPw0KDQo+IA0KPiBUaGUgY3VycmVudCBtb2R1bGUg
ZXhpdCBmdW5jdGlvbiBpcyBhbHNvIGEgc2luZ2xlIGZ1bmN0aW9uLCBhIGNvbWJpbmF0aW9uDQo+
IG9mIFZNWCBzcGVjaWZpYyBsb2dpYyBhbmQgY29tbW9uIEtWTSBsb2dpYy4gIFJlZmFjdG9yIGl0
IGludG8gVk1YIHNwZWNpZmljDQo+IGxvZ2ljIGFuZCBLVk0gY29tbW9uIGxvZ2ljLiDCoA0KPiAN
Cg0KWy4uLl0NCg0KPiBUaGlzIGlzIGp1c3QgcmVmYWN0b3JpbmcgdG8ga2VlcCB0aGUgVk1YDQo+
IHNwZWNpZmljIGxvZ2ljIGluIHZteC5jIGZyb20gbWFpbi5jLg0KDQpJdCdzIGJldHRlciB0byBt
YWtlIHRoaXMgYXMgYSBzZXBhcmF0ZSBwYXJhZ3JhcGgsIGJlY2F1c2UgaXQgaXMgYSBzdW1tYXJ5
IHRvDQp0aGlzIHBhdGNoLg0KDQpBbmQgaW4gb3RoZXIgd29yZHM6IE5vIGZ1bmN0aW9uYWwgY2hh
bmdlIGludGVuZGVkPw0KDQo=

