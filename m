Return-Path: <kvm+bounces-13919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2592689CDE3
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 23:56:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D128B21258
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 21:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 444D6149007;
	Mon,  8 Apr 2024 21:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gzcEjVAU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CECF148836;
	Mon,  8 Apr 2024 21:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712613384; cv=fail; b=CLJ3dXdFXx4Y66dpc7J2y+LAt3vkQycO90MwI3D6gwFDwkf/fYbLwTBvHy0k2ymFhpNDknWMAuY1Dvlc4IorIftF6VW+2QHN/s5Ii5jGyP6Ccud96MIJ6R8wBsQ5ndnYIcMCbyOiU0VNv8EOXaq7fZCiaALq8VvNbY/VSOPzc/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712613384; c=relaxed/simple;
	bh=81VhCuNzVK+bGjG7r/FM2V4dC3c/ogLydYcAn8GfpYg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R1+VJPrK8TKOJ7MBJN6GX2ggUWMje4iSpZxBibmAqiChAUDLoMqR0pngD3Hdkhz0cXJoTY/8Dvn09D/HxuG0Raz4SnCYigFvBxgeATys6K68E1qLgNpSsHbEHBelJOtClnhXTgh5twVXc0EUGDUdgKfTqAMJxZWq8bpEpwlLtLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gzcEjVAU; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712613382; x=1744149382;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=81VhCuNzVK+bGjG7r/FM2V4dC3c/ogLydYcAn8GfpYg=;
  b=gzcEjVAUR1vfxZCEazqQlvxNsU4tgDaFEgRDIRfYn0GLOhUz3d8X0ToU
   CVjTOZunKCw/84E+mzfDq4Rx/dQMyDXACu3IVoGlc7eoh98s0AGv4NvGK
   29Ybg6i4sJbTSco3GoO5sJjJAE1nkRaeINLnkF3E86azraoCQ8cys2h/T
   1DtDZ8rXhW6K+rpj+F6FVkoa94ydrGLK/oPHwNkoHpm4ZhJbwaw4BhNL2
   JZgdW3b5hCuU1F2gvzpo1xQckoa1afShd306cf+Rov+ixOmIqRUABH3Cj
   mQlUET7Y2eB82WC0Gz7ufQsfmOGAVyBY2Mf52U8QeYPksNoadZGVwiVoL
   Q==;
X-CSE-ConnectionGUID: QOqNP/1cQuep6Vc2p1o2qg==
X-CSE-MsgGUID: to5hDBT1RlyOJhbb7dkU5A==
X-IronPort-AV: E=McAfee;i="6600,9927,11038"; a="7780642"
X-IronPort-AV: E=Sophos;i="6.07,187,1708416000"; 
   d="scan'208";a="7780642"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 14:56:22 -0700
X-CSE-ConnectionGUID: ptabrEJbQu6oUKG72Tu2tg==
X-CSE-MsgGUID: G2AIsORdQteSm/GPV7tF/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,187,1708416000"; 
   d="scan'208";a="19971539"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Apr 2024 14:56:21 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 8 Apr 2024 14:56:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 8 Apr 2024 14:56:20 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 14:56:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBfOqsHt95GIehynOCDzz6XMH5qkgkxZGpY77NLwm7WDUTXaYwNjYNCiB+QDTnhfs78rDTII+uehWw9vH9KcU7hFcOZhmKx31Wy6ZLbLIe3jlguFkrTpIWwSwI1js3G4QZOI+td2xIRVszPoDIdSIj+RuTnf7wMoSgrQSr5xtqLdR56mpUsU1oyGxzDEyi9nAxitnUHDarVRpUzHjqO+mGxkEJBx6IX0GOGLLDWcF7CaP6RUXKwdePKRoVmApJye+F3RblqrEkkKSvivmgdcAe8MLTttC0zEAei31dN8K2b5vvybcvx6yA8sHU+BJrNXThPjkTXkdaXRELO9Kcsjpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=81VhCuNzVK+bGjG7r/FM2V4dC3c/ogLydYcAn8GfpYg=;
 b=AwPB7SBgA1BpfaojYJRbhKRuToZH3MRWaUez7Zt6X6tUBJsQ2YY8Hp+3FAaktIU2I06gFIMkB+2EwDzBQUKPVMf/6+VeWquCgQoiDjvPInHGLBPZKdqJWH5Lta6GQFgrIjBxDT1TcpKafX3AIDhdkBTJ2DHEz8kSY11dBgmpNBcCTItkQMYMhLfFLh7pK0/Is8JQBxlXUWxWxLaYCJljWmPyE+tfvneHU9B6/vv7xdZxaw0BQysgE421XHc/XhAf6BpFIPXqImim0uxcjxUcwjcMqQv+15uVUq8zC38F0jD01t9fILsEzJviwlnY5MsYgNWkA7qnen9k/U+4/dYMiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH0PR11MB5283.namprd11.prod.outlook.com (2603:10b6:610:be::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Mon, 8 Apr
 2024 21:56:18 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7452.019; Mon, 8 Apr 2024
 21:56:18 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "davidskidmore@google.com" <davidskidmore@google.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "srutherford@google.com"
	<srutherford@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Wang, Wei W" <wei.w.wang@intel.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Topic: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Index: AQHah3qOMqOgejWDsE6lTffyy9yei7FcJJkAgAJt44CAABa0AIAAE3AAgAAzlgA=
Date: Mon, 8 Apr 2024 21:56:18 +0000
Message-ID: <5faaeaa7bc66dbc4ea86a64ef8e8f9b22fd22ef4.camel@intel.com>
References: <20240405165844.1018872-1-seanjc@google.com>
	 <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
	 <ZhQZYzkDPMxXe2RN@google.com>
	 <a17c6f2a3b3fc6953eb64a0c181b947e28bb1de9.camel@intel.com>
	 <ZhQ8UCf40UeGyfE_@google.com>
In-Reply-To: <ZhQ8UCf40UeGyfE_@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH0PR11MB5283:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lfp3AGtalummpu4a/ThNzFtzRxgu2rCzLiP+wi57k4GGXdaCH27tjnqwlPxIhb16X+ao5+/ODIbzlyb00IK/lKz6kHsbl8ZZzQ6CaRPe+5h36vCJTd9dJ00ZpuAUY1UGJ8k+OySC2KVq6SJvlhvO0eM7stTxwArjlNfTxl79b1ApaWYasrz4nKyZcXTRChg35tYsQJ0ql34hzMyHA1gE7RlZyJnJmCTwVIQ0xN4cHKwSikel52WQsrnxnGc6MJby/oQj++cQ4350I/BqXYlNryVaGNxGDy477p73wocQdf1l2ii3hzDXmGHPQlxdypPKZpBdcnkA54fGoPa6giOqy3jleA/wXmiXvMF3u6s6hv4384SihtBVRNb4F12bzIYa0Tz789wo6bmRExqSUd2lb7O3Rp8f+pNiIK055CDVahr6izR5RpFIcMT1li6TFB47LVN/ST+mjLX9mdGU3Dp/fnKyfUdISgTKwLUBBaymPFTBj16F6XQDCqfEi7Rf684QAcPvNqh9cJetWR4lY8hxbnCgoTqhNopZ6hlEg5Oahy8hb1twhpcZrbLsjUlY9jmZezAEz0yqcBF3O2bL+C2YVarRNe043eldEAJOCE8KKrVs+iqB5IwYheLika6fQLGA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RHFMTjhoNEVOaVYrYi9xL1hlNVladjMwNG5PQzZxMU9aK3FlOEgwZS9TRXpQ?=
 =?utf-8?B?VmJaM1dhSk9DN1NMQzg3MkhIN2lWbzFNV25DQ0hSdHpRS1RZWEIvcEx0bHJt?=
 =?utf-8?B?NGJXR2orc3BOd3YxbVUya3k0K200Yjc4aWc2TTB1aEZkRVJoVEsrMlFZTFRz?=
 =?utf-8?B?anVXVWhZZ1dGQmVGWURoVmNuejdUeXhvTlBiV2NyODFMdGsvVXFXM25iQlY0?=
 =?utf-8?B?M1VZNzVRT0hPSW5BWmRJZHFwTnFJVlIxSzdmTGdnS0xObnNJN0VzUW1GQUly?=
 =?utf-8?B?dWxEbkE0N1FJdkhvTzhQNXBYcTVITjkydWlQaUNyT3p0UmozbnA4NWNBS1dn?=
 =?utf-8?B?VWd6L01UMU10RFI5YlY1cUEyc085TnpoMzQwVzJhNlR3ak9WZEJ3UUVuK05N?=
 =?utf-8?B?QXhhM2lDNkVxTXVpRTJ3WU1kMUtYWjZxZkVnTDJ6SEM4Rkw2TVl3dGZSV3RZ?=
 =?utf-8?B?VGJYYjFCVHVuTzNNdjdKeUdEUlJmcWFzOWF4UUloaWd6eDhmai9ERkJtRk5F?=
 =?utf-8?B?VVBLMVJUNS9jWXpUUnNGUkpjNWVjQ3NNMmpzYm9HMy9GdHdJRjlBcVQ5aHhX?=
 =?utf-8?B?Q0E5Z2xrcE85cm1nN3pPOXpvWm54MTZZZWZRaVRKKzVDKzJYeDdvT2xwRFE2?=
 =?utf-8?B?YWR2dlVSTm9VaFNXQW1MZFBveEpKdG1UbW9uMTN3ZG8xVnM4aHhrUnRpRFBK?=
 =?utf-8?B?YlNGZVptNklURHEyTVNwcjgwQW5VdVpjL09yL3BrU2tHRnRCSWJadnZrMnV5?=
 =?utf-8?B?UmtjZkpqQjg1T3diTGFaSFE4M21iNmpLVTFxL21RdHFlVXdtUE1tVFFqb0JP?=
 =?utf-8?B?eVZoRWZDZ240RGY3SjFmbkd5T2lLcmxWR0ltUnYxZTkvNU9DWTU4T25idFBM?=
 =?utf-8?B?VVhPakdERGNGcjR2V2o1LytTK2FQbktQNHVocmRjUHVLUG5GNnNOMmhBRmhw?=
 =?utf-8?B?S2MyUGNEVUR0MVBuSjBVWUM0eERMQWRXMG1KeDZSUzRNZU1Mb3BDd240bDRk?=
 =?utf-8?B?dGtxOXVNZTlueVNBNE1CZnhWZk10NEJSMTduaVVzWkNHV3JGeDUwUWpWY21I?=
 =?utf-8?B?U1QvTWVUckZLSUIxb2ZhVlJVOWp2NzMxYU4wVDA5V2hrcFpRcEZaaFRsejlj?=
 =?utf-8?B?cW8rblp5cVd1ZFF1M2dLNkZ5N05WOWowV3o5ZU13cGJ2WUVhd0pVaHA1Q05j?=
 =?utf-8?B?OTN6eEFtM28wc0I1RWpGVmZEbW1jak1aVFBVQ0tRMWxmdDlJNUxNU1QxaXJ1?=
 =?utf-8?B?R2VoTHFQbndrc21aRVNSUi9GQ3llSU9LTHBMZUVMT1V2Ui9OTDhPWmhWV0wr?=
 =?utf-8?B?SXV3WGdqUXVIQUh3UUZGMTZERUJjVHkrUlI5SVhkVmV2ZXNLelRLRmM4bVFR?=
 =?utf-8?B?OWhoTkZsdjRlZU1URFNsR1ByK3JrZXhzME92eTFnVEhNQzR6M1c4OEh1aFpZ?=
 =?utf-8?B?Y2xnd291bTJRQUxpRytkZk1vN2VkQTczWm9VUDFReEl4dmtpemhvVHdCMnlw?=
 =?utf-8?B?eHkvMXl1bzYrTnFKbFQxb3JaVDV3M3hGSGtzR3kvdWV3M09mc0pJS0llQWxr?=
 =?utf-8?B?SmJqcUViRENXR25KazhsMkdBQ2xsaW5QUlR6b3VNcjRBZW03NUwwOU8xNGIz?=
 =?utf-8?B?V0YrN2JxUEd1WlV5RFI5Lzh1VzZ5VEVUdHJQbHVIWXhqVXdSTlUzS3RYaWF6?=
 =?utf-8?B?VEN4VWNOeTN0S3Z5cUUyMjBJWXFsQzJEY2N2MW9HME9FT0Vqa3JnQ1JGZmxQ?=
 =?utf-8?B?bWVWbDNTZWhYYTErOUNDT2lBNnlIeVZUem1Sa1FUdjJNOUswZnFRTXVLRmlO?=
 =?utf-8?B?aW43TzF0MFlTdmJOTkRFMjBaeDUweE4zMUpZdlU5em9ER0ZLSlIxUXVIOVVY?=
 =?utf-8?B?alliRzREdkdPMjlUNGJhU2RPU3VtdzJDM1VRTlZiL1U2a09KSG5vWDlHQUs4?=
 =?utf-8?B?WkFUS2VENDVNaUJQNTFMOHNvNFQ5WE1WZU9DR2NYVGNVK2F5eTBOaTZmQlVG?=
 =?utf-8?B?dFp4Uk5sRng4MDZpZ0NlaklFWW5rZlh6VHlBeHdUa0lSRVg1dER0TSs5YUw1?=
 =?utf-8?B?UTg2dld3NGYxdm5yZzBaZzEwOXh3RmtWNWdmVjcxbVpacHl2WG44L1FreE03?=
 =?utf-8?B?bElUTWJCV3QzcVZSclFlVjdzY0NJS21Sd0VleVNrY21nN3BVbkpxQ0FpV01h?=
 =?utf-8?B?QkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9120F33581CCAD4DA9949533772BACE0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27fc2c9c-f1cb-41fe-46db-08dc5816b87f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2024 21:56:18.7503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PmIs6tUo/m2JtsrIgJ1hTcxWWfp1JfSjVD33ZxG1lrdtGHcWsxqTVcbMM7RlL3JY/eH23ZoW8E2g7TVUPN0rVkprD9QZQ5f7b1u88BTqQq0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5283
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA0LTA4IGF0IDE4OjUxICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPZmYgdG9waWMsIGFueSBjaGFuY2UgSSBjYW4gYnJpYmUvY29udmluY2UgeW91IHRv
IHdyYXAgeW91ciBlbWFpbCByZXBsaWVzDQo+IGNsb3Nlcg0KPiB0byA4MCBjaGFycywgbm90IDEw
MD/CoCBZZWFoLCBjaGVja3BhdGggbm8gbG9uZ2VyIGNvbXBsYWlucyB3aGVuIGNvZGUgZXhjZWVk
cw0KPiA4MA0KPiBjaGFycywgYnV0IG15IGJyYWluIGlzIHNvIHdlbGwgdHJhaW5lZCBmb3IgODAg
dGhhdCBpdCBhY3R1YWxseSBzbG93cyBtZSBkb3duIGENCj4gYml0IHdoZW4gcmVhZGluZyBtYWls
cyB0aGF0IGFyZSB3cmFwcGVkIGF0IDEwMCBjaGFycy4NCg0KSGVoLCBzdXJlLiBJIHdhcyB0cnlp
bmcgMTAwIGNoYXJzIHJlY2VudGx5IGFzIGFuIGV4cGVyaW1lbnQgdG8gYmV0dGVyIHF1b3RlIGNv
ZGUNCmluIG1haWxzLiBJIHdhcyBhbHNvIGdldHRpbmcgdGhyb3duIGEgbGl0dGxlLg0KDQo+IA0K
PiA+IE9yIGFyZSB5b3Ugc3VnZ2VzdGluZyB0aGF0IEtWTSBzaG91bGQgbG9vayBhdCB0aGUgdmFs
dWUgb2YNCj4gPiBDUFVJRCgwWDgwMDBfMDAwOCkuZWF4WzIzOjE2XSBwYXNzZWQgZnJvbQ0KPiA+
IHVzZXJzcGFjZT8NCj4gDQo+IFRoaXMuwqAgTm90ZSwgbXkgcHNldWRvLXBhdGNoIGluY29ycmVj
dGx5IGxvb2tlZCBhdCBiaXRzIDE1OjgsIHRoYXQgd2FzIGp1c3QgbWUNCj4gdHJ5aW5nIHRvIGdv
IG9mZiBtZW1vcnkuDQo+IA0KPiA+IEknbSBub3QgZm9sbG93aW5nIHRoZSBjb2RlIGV4YW1wbGVz
IGludm9sdmluZyBzdHJ1Y3Qga3ZtX3ZjcHUuIFNpbmNlIFREWA0KPiA+IGNvbmZpZ3VyZXMgdGhl
c2UgYXQgYSBWTSBsZXZlbCwgdGhlcmUgaXNuJ3QgYSB2Y3B1Lg0KPiANCj4gQWgsIEkgdGFrZSBp
dCBHUEFXIGlzIGEgVk0tc2NvcGUga25vYj8NCg0KWWVhLg0KDQo+IMKgIEkgZm9yZ2V0IHdoZXJl
IHdlIGVuZGVkIHVwIHdpdGggdGhlIG9yZGVyaW5nDQo+IG9mIFREWCBjb21tYW5kcyB2cy4gY3Jl
YXRpbmcgdkNQVXMuwqAgRG9lcyBLVk0gYWxsb3cgY3JlYXRpbmcgdkNQVSBzdHJ1Y3R1cmVzDQo+
IGluDQo+IGFkdmFuY2Ugb2YgdGhlIFREWCBJTklUIGNhbGw/wqAgSWYgc28sIHRoZSBsZWFzdCBh
d2Z1bCBzb2x1dGlvbiBtaWdodCBiZSB0byB1c2UNCj4gdkNQVTAncyBDUFVJRC4NCg0KQ3VycmVu
dGx5IHRoZSB2YWx1ZXMgZm9yIHRoZSBkaXJlY3RseSBzZXR0YWJsZSBDUFVJRCBsZWFmcyBjb21l
IHZpYSBhIFREWA0Kc3BlY2lmaWMgaW5pdCBWTSB1c2Vyc3BhY2UgQVBJLiBUaGVyZSB3YXMgc29t
ZSBkaXNjdXNzaW9uIG9uIGZvcmNpbmcgdGhlIHZhbHVlcw0KcHJvdmlkZWQgdGhlcmUgdG8gYmUg
Y29uc2lzdGVudCB3aXRoIHRoZSBDUFVJRHMgc2V0IG9uIHRoZSBWQ1BVcyBsYXRlcjoNCmh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvWkRiTXVaS2hBVWJya3JjN0Bnb29nbGUuY29tLw0KDQpX
aGljaCBsZWFkIHRvOg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtL2FjNDI0YjE2NzIxMDI4
OGNkZjMyYWM5NDBiY2M2ZWM4NGY4YTQ1YjkuMTcwODkzMzQ5OC5naXQuaXNha3UueWFtYWhhdGFA
aW50ZWwuY29tLw0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtL2QzOTQ5MzgxOTcwNDRiNDBi
YmU2ZDljZTI0MDJmNzJhNjZhOTllODAuMTcwODkzMzQ5OC5naXQuaXNha3UueWFtYWhhdGFAaW50
ZWwuY29tLw0KDQpTbyBLVk0gaGFzIHRvIHJlamVjdCBLVk1fU0VUX0NQVUlEIGlmIGl0IGRvZXNu
J3QgbWF0Y2ggdGhlIFZNLXdpZGUgY29uZmlndXJhdGlvbg0KYW55d2F5LCBob3dldmVyIHRoZSBW
TS1zY29wZWQgQ1BVSUQgc3RhdGUgZW5kcyB1cCBnZXR0aW5nIGNvbmZpZ3VyZWQuIFRoZW4gaWYg
d2UNCmxlYXZlIHRoZSBWTS1zY29wZWQgQ1BVSUQgY29uZmlndXJhdGlvbiB3aXRoIHRoZSBWTS1z
Y29wZWQgb3BlcmF0aW9ucyBpdCBkb2Vzbid0DQpmb3JjZSBLVk1fU0VUX0NQVUlEIHRvIGxlYXJu
IGFib3V0IHJlamVjdGluZyBURFggaW5jb21wYXRpYmxlIENQVUlEIHN0YXRlIChzdGF0ZQ0KdGhh
dCBpcyBub3QgZGlyZWN0bHkgY29uZmlndXJhYmxlKS4NCg0KDQpTbyBzaG91bGQgd2UgbG9vayBh
dCBtYWtpbmcgdGhlIFREWCBzaWRlIGZvbGxvdyBhDQpLVk1fR0VUX1NVUFBPUlRFRF9DUFVJRC9L
Vk1fU0VUX0NQVUlEIHBhdHRlcm4gZm9yIGZlYXR1cmUgZW5hYmxlbWVudD8gT3IgYW0gSQ0KbWlz
cmVhZGluZyBnZW5lcmFsIGd1aWRhbmNlIG91dCBvZiB0aGlzIHNwZWNpZmljIHN1Z2dlc3Rpb24g
YXJvdW5kIEdQQVc/IA0K

