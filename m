Return-Path: <kvm+bounces-73249-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id VrvBC7gKrmlY/AEAu9opvQ
	(envelope-from <kvm+bounces-73249-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 00:48:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 98C51232C8D
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 00:48:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 36F8E300D6A7
	for <lists+kvm@lfdr.de>; Sun,  8 Mar 2026 23:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D5231195A;
	Sun,  8 Mar 2026 23:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BaU9HFqV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271E819CCF5;
	Sun,  8 Mar 2026 23:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773013683; cv=fail; b=WbcZD12wNuo2jFZE3gaKKfaHNHZGMWFdEAUROBgm7mez5WVz1eyD4+FP/VoPeXR3ogldbp9GG7wmqyTonlIyAjEvxZQYkDzLXCsmNsrz4+a/6A3mmiG5opHEc4OUR9tAAgkcVeeyOay/lK0UifGsWfhV7c1yxhnaHPjsyGoIna0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773013683; c=relaxed/simple;
	bh=yHcETiVTnmlZUWBd3oZOue54q9jV/Lp4MkseQEz77Xo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=o8vPUhMTcETnCfPpUPjalq/DDS63YBpazqGFNgXDE5KbQG8nkxQoqgbXre6yvHukYvhB5qYziumZjmmelV4z9E3xbA+DHCPYulLWtxOflFIr4tFQ2iBysTP+65q6lCGWYZcQWv61vi8AsqMSssqZ5h1+n8tf6xBTCJTf447JMw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BaU9HFqV; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773013682; x=1804549682;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yHcETiVTnmlZUWBd3oZOue54q9jV/Lp4MkseQEz77Xo=;
  b=BaU9HFqVt0z8YKS+j3id1XCSs0TUN3cxvpkpfoBPXIOv1cF22vKbcbRp
   DjdKRuOnlgOBiG4ZacJwFj4sG7L2ppIj+4DbzXtB6cCfe7kp7V03SiGs8
   xXA0hbFYqwnUMjsrS2prleCeX2Gj19syDPgqWk/KlR57bXaI0sPR8hnjU
   YRrcc71Q/FH3vM8IL/B3x/6fs9qPrjSxryGWpyO1Y7ahz6i4HoMyY9+RN
   3c/Qk08+sPPAhMlKmSgk5fWzCZTFgPwdA2uJj5WL49csWmMO0KlAmCjX1
   jpUveZC6AXPNd5mVKnmJMqZs5QO0bHeX0zaqUPobjOFDM6jdwqtMOhQ3E
   Q==;
X-CSE-ConnectionGUID: xBoNj70gRy6HpqXC0cvfAw==
X-CSE-MsgGUID: fnQsAe7KT9SsqpGv8LRWEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11723"; a="74004493"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="74004493"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2026 16:48:02 -0700
X-CSE-ConnectionGUID: z5ynG7RfSgC5pEzzX+wE2Q==
X-CSE-MsgGUID: Jv/oPkSWRFiwrXxiW8VNfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="218726613"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2026 16:48:02 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 8 Mar 2026 16:48:00 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sun, 8 Mar 2026 16:48:00 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.17) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 8 Mar 2026 16:48:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b3059OodqZjJCtLJNEjGoaigwSmctlgGCngmvSWXjgPbOWpfyn/vl7XG58eRCDRVuVsKsozcTtE0hiwbWoHhaP51gixl0lZcrQP+cUfYhiRPC/5c/4CCgTv3sepHybN6VXaqvMgLc8FRB1ALui33vsll6qkWwNCtDODsZQpdR+wLakw2pECJOL6xra1C8XY6nUwQT//uA4f3ydU/AulQv6fdhCVauUeQcaZx3QnHZ5fJUwSeMjdfLQE4IaevkFMqsAsB7lJJkRMp9mkffDIl92cXwQrlVWBXeXPI2FD0gUBfkodbXPk6jh02dI+idqZJIIDGQAqWzIZDPCmM7xJKag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yHcETiVTnmlZUWBd3oZOue54q9jV/Lp4MkseQEz77Xo=;
 b=qfrO9jjZCu5+9FOGjS88Hz7V8IdTwksy5ecMXv9YzoejuHct87yj/+H30e6BSJJPn5B2fqCP2nSVCWK0NLQPNL7kSol/UBjxEYXVmET7SbbGOCPeCxGiU6yGgbrQp0eMYLPwU093BMoEu/cj7cDvDn/j1x3QPCAoWhUVv077ippAMIRSkwSYu/xKWEKXJ+0NY7hJz6DjgxAJkun4pAx/GdaH2JpmORa2oL4EpHczSHtfDLsrGZkkcKG6sM9+SKiOhzSylDzPKIS//aiaYjvBRjwbzp5xutGDX6oinTdOXgovPryhLzywZWHfUyM6Uzi2nAYz1G/8o0hMhdF9XXiuFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 PH3PPF383C22AA3.namprd11.prod.outlook.com (2603:10b6:518:1::d17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.10; Sun, 8 Mar
 2026 23:47:51 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9700.003; Sun, 8 Mar 2026
 23:47:51 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "tglx@kernel.org" <tglx@kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Gao, Chao"
	<chao.gao@intel.com>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"sagis@google.com" <sagis@google.com>, "Verma, Vishal L"
	<vishal.l.verma@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>
Subject: Re: [PATCH 1/4] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Topic: [PATCH 1/4] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Index: AQHcrc5SZaItNyyLB0K41MhcBRvbyrWlUFGA
Date: Sun, 8 Mar 2026 23:47:51 +0000
Message-ID: <19ae1ea7f3dc62ac95f5283f2f101066e52450f4.camel@intel.com>
References: <20260307010358.819645-1-rick.p.edgecombe@intel.com>
	 <20260307010358.819645-2-rick.p.edgecombe@intel.com>
In-Reply-To: <20260307010358.819645-2-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.58.3 (3.58.3-1.fc43) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|PH3PPF383C22AA3:EE_
x-ms-office365-filtering-correlation-id: d6c99bd2-f3ee-4069-daf4-08de7d6d1c77
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|38070700021;
x-microsoft-antispam-message-info: SljC1O6rRdLYb6PowdVlOW8z4JWnABunQdd4ZdOnrJGM+0Y4o8hA06DxPQAd84aXGfwt6cvhclZRgTHI9RHUMOMQ/s4cMfiIZLFvl1ajxxGjaFPtRUd5n5Qz+8e3WLQLKpU2oHOew3QEKAIvUaOPZQX9dsNkXbvkID9HW4wJJ7wu7S8mCbusl0a8+9ZyC+J36W0kMLjVgra5kGtqtql2muTbkBoYZoALFpPurhxLqW+sdg9SipUY1YAJ6bSmAfzVahQF9G4IJ6uf65xVpRGEOWIbuKCmrzRNuesGevmjSSdj077XBq/wmbl2+0+TKOregksm7GeIkCefD4vapsDrfQf7Vq1qifgeIX5DVdQonwdZ6jfRl42FfmUTgr727BLoNNpJteAhY2lAnT6VLPE4jr25tbP2RPbwgUjMtG9wG5OIcoSqvc9kDKrI7UErpU8GHNb6JuJufRnmB4DZayWEckB9tfzyVVLitQqVagG07U85hcrBNU521TZH39OxGBXUrL/CyR1/CYZOt9C3FHOwk+EWs3WRHC2XfFjMX9o+0+x4QyO21DJUNoPeAsx7iNBXlxuPz9CPYgUcgv+9VYK9/GiDqBIvMNwfBb6HtJ27BL9KplPKTADCwZgcPyWoS9FGacn3Wq3oin+OevAeh8KwLon/fSrVcHjUaQgeJg+LvqRFe3uqnW1O+wLxl9OKRl7hZQq61miY02pvoeCmduB4BL4rA0licYjXBCsQo+Ms33aaquEwLPjq1SUld43+qg/9hPasWcR2L1mJM7RCj1Sreg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SlNoVEVENmF2Qks3d3pKckhnUWVsdjJwUEY5VE1aeXM5VXR2cHk2NEJQRGla?=
 =?utf-8?B?WmhtZmhxazdibk92eThJL2kzb3dWTTBKeWlMQTdQR1VZVCs3empyL0tyYlhr?=
 =?utf-8?B?bGN1NG91L2IvWGEyRFRHbG03SWhhK2ZTZ3AycUdndFZrcW1TNGRjVWZacnFo?=
 =?utf-8?B?N0VJbC82RmVMMGRvTm01aWhHT1FlVnVaYVgzUDR1VTJFVjIxZTR6U0VzQ05H?=
 =?utf-8?B?bGdPTXIyZHNWM2R4TnQ5MFUyRGpBQnB6RjhJMi9ITVlGNisxRWpvV25IUzdw?=
 =?utf-8?B?NS9KeXpwa0ZQL1c0amFpYk5LRXFJTGt5TzBRelE4N2pkUG5NSW14bDRnaGZ2?=
 =?utf-8?B?T1pmZjdrcGhNZXNsa1FnZXYzbU4wbnRYb2pHN2VLZHBORVRLYm42STZQdm5s?=
 =?utf-8?B?a3pwd1ZsYjEyaDJsTUloaEhjQ0R4U3NYVjY0cFYwbGYzd1J4U2xndHBobjRO?=
 =?utf-8?B?L0ZPTXFkdHFFamJiRzdLc2RaazUvbFd6cjd1ZW12cDhnSy9JZ3hHMTEySUFK?=
 =?utf-8?B?SC9SYjVBVVJqUEcrRDhxcm5rNlFYaHNLVTFrRlkraHZtK3o4Um1jOTdGaklD?=
 =?utf-8?B?NnhBK05vNCtNMUFlQkxIRldmVEpzcGtvNFVWRDZ3ei9zRFdIR2tDRHlFZW9D?=
 =?utf-8?B?NnZaWVB2bFBNQ0FtZmc3TGZKTFFvZmpUYUZKWEM4bHU0bXNSeVp2OVJvVzdD?=
 =?utf-8?B?U3BOcDdNbktEKzg2VnJZOW5iTWJZeUJpbjhjdS9yVXpBc2NvQ29WVEdGSUJV?=
 =?utf-8?B?azhVRThYcEZ0Y0dYaERTQUYzWkFGbS9aUHBySldyQnZSRkUxOWNMaFQ4TjdU?=
 =?utf-8?B?Smd4eEVZNjFGU3NkcTNsTHo4dkdwSllFVExwQmc3NkF2b3Mzcnlsd0NhejIy?=
 =?utf-8?B?bnRoNVo5Qjh0TllmUVNkMXk4MVFia3k0Q1dDRWpKRzc4Ky96R2RmMjdUQVdP?=
 =?utf-8?B?clNma2FrY0hKMjBwQnJkczZ6c00yUnA3NkFybW1lcEF3NnpOaFMwZnIvdCt0?=
 =?utf-8?B?eG5TL1hvbWFmVVZCby9RQzZjMEExVnZ2dDdnSDZNQU5UUnR5T1FkVTY1L3VW?=
 =?utf-8?B?SXpxbXdUMk1iOXpwTnA2U05PeTlodVhvZTVEMy9PVC91cUN2RXlZVXNzNkpZ?=
 =?utf-8?B?N3k0R0REVkRZWjJyc1lmOWlOYUtSYkY4L1NoSGlaNTVMWnJTUjdobUZQM2Vu?=
 =?utf-8?B?ZEM5VjlmdnQ4aFo5U2ZNK3RVMDk3YXg1L0hJZjJkamtHZG9SS0k5dHJVYkpO?=
 =?utf-8?B?T1Iydk5Gd3p2eHR0bk9EWnNNaWIyVmVmK1pTVHk5ZWdocy95aURHejgrcGl5?=
 =?utf-8?B?eTNFVWVCSEVzMDJVVHhNQWd2d2NQSXdYaGdUT1FPYjZkRWtFdjJQRXlHa2hW?=
 =?utf-8?B?MGdZWS82SUVaaVZsS3RrSXBnZTNFTGJUQVBSdHJXQUtVRzBkZEZtY1pwa1Rp?=
 =?utf-8?B?M1orKzkyakNIcXFlU281NnRUMm1wM2M2SDl6WWs1VlgveGVTNVlYK2RTcVN3?=
 =?utf-8?B?aWtrbmlBZ2VneCtVK2NtZmlKbVdUdnBoc05NN2Z2bzdmUEtVYzdwYWtFZHRu?=
 =?utf-8?B?UnhBUUxmMjFac1U4bFpTN0FsYVBoSmZTTmxkd0dhb0dyK29JV1RmLzIrY0xC?=
 =?utf-8?B?VUQ3MTZWcXkrNVkxVTVtUHladDFKRjJvQnZjZndlNm9NNlRrVU43S0dqUzFw?=
 =?utf-8?B?Y2lucnJ1UVlLZjkrOVdoT2sySmEyWVo5WWVtT3h3WEZVaTBqVG5JZVBGVytx?=
 =?utf-8?B?TlBXRzF0TzlJU2dXMUcyakwvY1VERGN5WEk0eU8xTlpnK0JsT2QyVzN6ekJ1?=
 =?utf-8?B?c2pQUnpmL1BpVzBpaVo3TXcxeEt3MWxlaG45VWFYcEVUWk1lT2lDUVNQbTZF?=
 =?utf-8?B?Wi92VTF6aUlhKzN5VjRzalUxbmRMQ05tSlBJVFNPdUFDUW5xSkx5NXVsMXg4?=
 =?utf-8?B?U3IrdnA4d1FvRVEwU09FSjZxQlloMi9oT2RvMEs4clVVUGgxVjNWdnA2NkF3?=
 =?utf-8?B?SmJxbEYwK3pNRkR6UWJWMDBvN1podk1icWp2OU41NEt4RWphRXRZam41a2Zm?=
 =?utf-8?B?NFdyZXFoSk5KVUNCeUxkRWs3RU9PNTRkMVhHYWl0aU56VjFVM3hXdmhoSDYw?=
 =?utf-8?B?alRmL0FWZjAxUnRuSHZVbFJ4ZDNMZEhxOEVhQTVQYk81Y0JEWWRYRUxrRytv?=
 =?utf-8?B?S3hIZ0pxMXZMRjRrQUp6TWlRTlpKak5KV3JQYU0rOEREeGV4Z25iVWo0M2h4?=
 =?utf-8?B?QU1XQWdkMHpOU1piUUI4VERWc1E4OHZpVUpRYWd2Tk1KNTlJMjBtazBTOVM3?=
 =?utf-8?B?YVVuR1pYcVJlUitJckpQSDg4Y3ZHZUZuMFNKSWRRQ2JtZ0Z0aXNZQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <288B0E896057794B8ACB6BF52083AAFF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: sEn9oO+NsytKMxGiQHm8M3pxkk1DpHAYBnKQTgsHnD2/jQ4vMjylmp5s7yuKLrT/bF5IOOVncNy+S2u279+Kb4iQ0I+2QY/dnDMR3/R4+aOmgFtO/o5tumASPcQmGubhDaQwgPjdrUZauZYZchKcLbACl2LOV0yHdb7BdUt/vJhvnL73tYb7xbt3Pbd9q2goAZnjhvLULho+QoDn7My4+ajXzXDL9Bg/WjxdumnzVd/kY8K95/GPdtLzGbotmAKatVMVMTkSSAlMG1GKorbwmlEjwMujs8SqaSz8l38hqXDjpl8Cl0eIE51TOwewfrbXQcgzMowqv8pq7DNaXB6+yg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6c99bd2-f3ee-4069-daf4-08de7d6d1c77
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2026 23:47:51.5671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8zlhsJSfZk3FoPug2PPszLoM9nBPflRL7ITAZyav3ERk3ewCb0Sq0o6rar0xfbbRZllrhqphAEOnjJ6dLB9MNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF383C22AA3
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 98C51232C8D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	TAGGED_FROM(0.00)[bounces-73249-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAzLTA2IGF0IDE3OjAzIC0wODAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gRnJvbTogIktpcmlsbCBBLiBTaHV0ZW1vdiIgPGtpcmlsbC5zaHV0ZW1vdkBsaW51eC5pbnRl
bC5jb20+DQo+IA0KPiBUb2RheSB0aGVyZSBhcmUgdHdvIHNlcGFyYXRlIGxvY2F0aW9ucyB3aGVy
ZSBURFggZXJyb3IgY29kZXMgYXJlIGRlZmluZWQ6DQo+ICAgICAgICAgIGFyY2gveDg2L2luY2x1
ZGUvYXNtL3RkeC5oDQo+ICAgICAgICAgIGFyY2gveDg2L2t2bS92bXgvdGR4X2Vycm5vLmgNCj4g
DQo+IFRoZXkgaGF2ZSBzb21lIG92ZXJsYXAgdGhhdCBpcyBhbHJlYWR5IGRlZmluZWQgc2ltaWxh
cmx5LiBSZWR1Y2UgdGhlDQo+IGR1cGxpY2F0aW9uIGFuZCBwcmVwYXJlIHRvIGludHJvZHVjZSBz
b21lIGhlbHBlcnMgZm9yIHRoZXNlIGVycm9yIGNvZGVzIGluDQo+IHRoZSBjZW50cmFsIHBsYWNl
IGJ5IHVuaWZ5aW5nIHRoZW0uIEpvaW4gdGhlbSBhdDoNCj4gICAgICAgICBhc20vc2hhcmVkL3Rk
eF9lcnJuby5oDQo+IC4uLmFuZCB1cGRhdGUgdGhlIGhlYWRlcnMgdGhhdCBjb250YWluZWQgdGhl
IGR1cGxpY2F0ZWQgZGVmaW5pdGlvbnMgdG8NCj4gaW5jbHVkZSB0aGUgbmV3IHVuaWZpZWQgaGVh
ZGVyLg0KPiANCj4gUGxhY2UgdGhlIG5ldyBoZWFkZXIgaW4gImFzbS9zaGFyZWQiLiBXaGlsZSB0
aGUgY29tcHJlc3NlZCBjb2RlIGZvciB0aGUNCj4gZ3Vlc3QgZG9lc24ndCB1c2UgdGhlc2UgZXJy
b3IgY29kZSBoZWFkZXIgZGVmaW5pdGlvbnMgdG9kYXksIGl0IGRvZXMNCj4gbWFrZSB0aGUgdHlw
ZXMgb2YgY2FsbHMgdGhhdCByZXR1cm4gdGhlIHZhbHVlcyB0aGV5IGRlZmluZS4gUGxhY2UgdGhl
DQo+IGRlZmluZXMgaW4gInNoYXJlZCIgbG9jYXRpb24gc28gdGhhdCBjb21wcmVzc2VkIGNvZGUg
aGFzIHRoZSBkZWZpbml0aW9ucw0KPiBhY2Nlc3NpYmxlLCBidXQgbGVhdmUgY2xlYW51cHMgdG8g
dXNlIHByb3BlciBlcnJvciBjb2RlcyBmb3IgZnV0dXJlDQo+IGNoYW5nZXMuDQo+IA0KPiBPcHBv
cnR1bmlzdGljYWxseSBtYXNzYWdlIHNvbWUgY29tbWVudHMuIEFsc28sIGFkanVzdA0KPiBfQklU
VUwoKS0+X0JJVFVMTCgpIHRvIGFkZHJlc3MgMzIgYml0IGJ1aWxkIGVycm9ycyBhZnRlciB0aGUg
bW92ZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEtpcmlsbCBBLiBTaHV0ZW1vdiA8a2lyaWxsLnNo
dXRlbW92QGxpbnV4LmludGVsLmNvbT4NCj4gW2VuaGFuY2UgbG9nXQ0KPiBUZXN0ZWQtYnk6IFNh
Z2kgU2hhaGFyIDxzYWdpc0Bnb29nbGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlz
dG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gQWNrZWQtYnk6IFZpc2hhbCBBbm5hcHVy
dmUgPHZhbm5hcHVydmVAZ29vZ2xlLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogVmlzaGFsIFZlcm1h
IDx2aXNoYWwubC52ZXJtYUBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFJpY2sgRWRnZWNv
bWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCj4gDQoNClNlZW1zIHRoaXMgcGF0Y2gg
d2FzIGZyb20geW91ciBEUEFNVCB2NC4NCg0KSSBtYWRlIGNvdXBsZSBvZiBzbWFsbCBjb21tZW50
cyB0byB0aGF0Og0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vNjk2OGRjYjQ0NmZiODU3
YjNmMjU0MDMwZTQ4N2Q4ODliNDY0ZDdjZS5jYW1lbEBpbnRlbC5jb20vDQpodHRwczovL2xvcmUu
a2VybmVsLm9yZy9rdm0vYWY3YzhmM2VjODY2ODg3MDljY2U1NTBhMmZjMTcxMTBlM2ZkMTJiNy5j
YW1lbEBpbnRlbC5jb20vDQoNCi4uIGFuZCBzZWVtcyB5b3UgYWdyZWVkIHRvIGFkZHJlc3MgdGhl
bS4NCg0KSWYgeW91IHBsYW4gdG8gYWRkcmVzcyBpbiB0aGUgbmV4dCB2ZXJzaW9uLCBmcmVlIGZy
ZWUgdG8gYWRkOg0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29t
Pg0KDQoNCg0KDQo=

