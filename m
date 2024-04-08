Return-Path: <kvm+bounces-13933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59FF689CF0E
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 01:46:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1205B283C17
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 23:46:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC59149C71;
	Mon,  8 Apr 2024 23:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g3JkCdMv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEFD323C;
	Mon,  8 Apr 2024 23:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712619985; cv=fail; b=u/S2Q6iIIBe+L9SWvqFg7MsVNBM3QACtIK907N+gX2heM6A/y7MC0+tcUqvqTloEK4QQ/8oLqe+RsxV/oyd2ZNRJ1R1j9dHRE0s1duWybYy3dDcgzqsdBg2aZ/HuXqLOdliYmexjZwtflIDUoUsxjwml5qHhZcgHwSC17TAtyGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712619985; c=relaxed/simple;
	bh=2EvivLi/V5lLcC5xb4yxfAB6iKJqz4p9WnusOH2xuhw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ltWQgeOD0mV9fNojgJNdQaHG3GkXotLRMKns1B75gmUNVFmF5GW/3XxMbGF4jy9/cf9HYMoZDHbaUgxLImvsPth0bqIlyG8Okb4m5HYXE5JSJl994kzFMECdO5x30t51eiqGTRWiUSqE7PUbZ5pMN4rtEn3Ue0vPraH52MAUTRk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g3JkCdMv; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712619982; x=1744155982;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=2EvivLi/V5lLcC5xb4yxfAB6iKJqz4p9WnusOH2xuhw=;
  b=g3JkCdMv6B/Ro2obTr8eAYmqhu51Y10fvQ9KUVl1uxT9cVfoT45ocYMj
   2nnmU3ejbenMoc1anLUbDBuy7yAKYsgL/swuJSDpXdVE9uB1894SavKt5
   mR+K2RugUVslc09bEn4dTLNA7uLuLiSHJ46HXtXHbaX6qHUHwRVl1aXUz
   ayeGE4IpoBCGBgNbGb54N+giFyvFPywiUIhhDm9MrottwAPwOxjj0xgZl
   pmSkZ72f0LjwkI6UfuaS/OI1PZLILRRDWAV9LlmgDu4g2Pu1gZuJa3fgp
   OwOGpKlri9Z8acv8AMb4jyxgrc1ok0dcUMvbSDE3rTnifU8LXnIZnCX57
   A==;
X-CSE-ConnectionGUID: GRcbdQxqTlq7rbqZbDxX/g==
X-CSE-MsgGUID: zjijF6sJS9mHpt95Lces/A==
X-IronPort-AV: E=McAfee;i="6600,9927,11038"; a="18489435"
X-IronPort-AV: E=Sophos;i="6.07,187,1708416000"; 
   d="scan'208";a="18489435"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 16:46:22 -0700
X-CSE-ConnectionGUID: oerNlGzlTKGPXI859GXoQg==
X-CSE-MsgGUID: fwWxpdEiRG2/bFJSlWAXCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,187,1708416000"; 
   d="scan'208";a="19916069"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Apr 2024 16:46:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 8 Apr 2024 16:46:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 8 Apr 2024 16:46:21 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 16:46:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KctGD3hutEb4wXooRAIIKQ8yLkuDXTEk14RRzUL2RHW5sx66pr9JLD85s91JX4RW2TdNsLE4ZppYAMl4mI7vd/NwuthAGgLlwCxKrh4EkF3e3xrYKvi96C5FmQJNbVsl4mzl4fwfdr3Q6FDkF7rvNyohkNec9h6pwOdU/Nvej6lxZ4wWgkqnU2Ob+QrAxCYN+zCRcTYbcFYCxybVEh5U9JmkFKLHSb6Mqxxd8HcJxcx36CHpU7QwsO4OVtzXKMhFepLDBhXsv+nHVaZY6LpW3dU4oPJe6UZHJgYKZq1OJhI4hdsZdmbJk3E2E/nJ9a+GLRlgwQ1dxFONbyFcfVbg5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2EvivLi/V5lLcC5xb4yxfAB6iKJqz4p9WnusOH2xuhw=;
 b=lIr1/OKVV/e4Oo2FSLn/bb2XD1zfGkXbpvEz6jk0N8ensT7yMdKarKzHCj4+7C6eCgpxvI29QrmQ0Cf87EJ6HYrJHATY/L/ypW2Ur4ltWBJ8KuE15bVtSWbMaftoR3a4Gd+Nu4se34KqIM8fyMz7svHMIT6Bf6J8KJUJBMxwFt0VKAgx6f8Xemm/W9L0kyqOo3TShyRHZjra9bcQ/rO+Fi039PLPcqVaFffLMJ7mHMH8piaX8zazbQN9CGGM6kSJsS5Sae+viKD2a4XV3fLAvn4GyDRq/P3DpcG53EqsPZhnszBduNZo9ov9U7j5aV3HRZvHHST6u+snNGI8RTDAlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6342.namprd11.prod.outlook.com (2603:10b6:930:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Mon, 8 Apr
 2024 23:46:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7452.019; Mon, 8 Apr 2024
 23:46:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "davidskidmore@google.com" <davidskidmore@google.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "srutherford@google.com"
	<srutherford@google.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Wang, Wei W" <wei.w.wang@intel.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Topic: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Index: AQHah3qOMqOgejWDsE6lTffyy9yei7FcJJkAgAJt44CAABa0AIAAE3AAgAAzlgCAAAskgIAAE5mA
Date: Mon, 8 Apr 2024 23:46:19 +0000
Message-ID: <957b26d18ba7db611ed6582366066667267d10b8.camel@intel.com>
References: <20240405165844.1018872-1-seanjc@google.com>
	 <73b40363-1063-4cb3-b744-9c90bae900b5@intel.com>
	 <ZhQZYzkDPMxXe2RN@google.com>
	 <a17c6f2a3b3fc6953eb64a0c181b947e28bb1de9.camel@intel.com>
	 <ZhQ8UCf40UeGyfE_@google.com>
	 <5faaeaa7bc66dbc4ea86a64ef8e8f9b22fd22ef4.camel@intel.com>
	 <ZhRxWxRLbnrqwQYw@google.com>
In-Reply-To: <ZhRxWxRLbnrqwQYw@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6342:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 16DN1O4Q+s1cEEdckIiGLjN+TNa7jQPlpVyPazfAocZTUtxei6v9FcBo/+t6uS5ygkif1pN4Ey0hm2dGxHp8Rl+aOtz1Ib1+UqwjOu5Xy+hXUpHk2fwjJE8mvCBtCFMk/HjANj9FdAsnG/G9sjnFaIcz6MrIEChz64NTMpoksbbrvdIPvmPLRvqUq3nwuhs5MvDN/imgrZF4RLsEtycP2BdF+ZXKSZroC8r4NhyM6nxQVWwtef60WKekiNS6W5zfVUX+u4pzAswXeAGw6P/iZY85mpfLb/Qfyfnvj2mvb99AjxiKnYOX8eBuOCf/tHSOuD0em1KmpdvWC7O38RreVu7jH2ZVK8V0+fXFetMJ6wg4LZfl3rgtj6kF209UrFfWYBS8xXynCieOAbh+3l1qvxpYUd2elIOelY2/D4eCizASlS0mg5EniHcuUUvfjoWKQLpOxBcMH2jjVUchAt4Td9sga2SHHhq7fMQmMcyyTCzlAb/xDbTcSrY5Oj8yr+31i5bwxys3+roM82a/smbuOVSJro8lR6MhxKtDkpKsGzEYLyFdJVBHFqAUEf+d2X6zNDLnoR8TOL8UzRtAKqYcHDiM3GTRkcoI1Od6SiLI4LZjhTRX4MtS2a5g9qS0pALbri3pFBGvnyABuam+eBswK7zd520vT2DKZozBUiWtnAE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?REI0b01BWS9UQWVkeC9PaEwrUXRvVlBUM1dha2U4NkU5ZzR3MkZMZUZlWnUz?=
 =?utf-8?B?M2htMlJPVkoyQXY3dSsyMktzdXJTbG9kZnZLeEYwMTUvZ3VVb0g3MURCVTZY?=
 =?utf-8?B?eGtxclJZamQ4bDFWZWo1eFRWcXJTeGFPQ1NCMTZYQ21KbzNyTlU3a2RsandG?=
 =?utf-8?B?WlZaTGlVdW81NE9adGl1SGhOd1F5UVRobElpdkFDT3I4RzZ0YmtSYVpWZWZD?=
 =?utf-8?B?QlV1WU9sSzZXbzR6ci9lYzJQUlhZM2Y1MmNCNVlvL2VhMDVDdmhieDZ0enZ0?=
 =?utf-8?B?OHFYTlA1TEZvbTJWV1J5NitINFdhL1FXMjRmUFdUUTVDNEJCK01ObW9VT0Ja?=
 =?utf-8?B?Z0NHTHZQYmFlZHNwcW91QmhRWkwvV0F5NkdteUxJM1lQRitPZmNFTDA2WDNF?=
 =?utf-8?B?bHp0U0pZV1FZYmV1QlFpTDNla2JsZTVDL1h3S1hteVZ0QUN1cUU1OTVGNHNB?=
 =?utf-8?B?QzFPRnVaWU03Y1EwQUFBbXdJSG1HM1FQSVNCQWN3NmQrYWhOMmJ0MjlyaXI4?=
 =?utf-8?B?TGZPZHdFZGpsWmQxZlQzYUFPL2dnUkJ2VW9GMzdqaGhVQ2VPaTFqejVaY2F5?=
 =?utf-8?B?NWViWUI3OFN6ZnZ2TWlyU1FQUll4MzI3Z2NHL2M1akk0TjRLTDBhaTV1M0lw?=
 =?utf-8?B?WEpubk1KOTkxM3EyVGRKNS9VUWdRUDF2WURKMk5ZYm84aUVwK1ZNMW1KMGRZ?=
 =?utf-8?B?K0hyN2VFTHk1MWF0VGp4UkY3YTJsRGtPZ1dHWkhIcHgxRVpjV3lycVNURGpp?=
 =?utf-8?B?VFJKMHZwQVY0ak1QTlZNQ2R2dkRKNTY3NUJMbDhEK2NlODRLdEhmcyt1cDdI?=
 =?utf-8?B?QjlQaXZ4NENVOEVSdlRDN2tuSklWaUw3UDBhL2E2SjN6NURYRmhscVZDdUlq?=
 =?utf-8?B?dnY1a1FJZ2d6Q29Cd2llSFVKaFdNTkFkZElYSHM3Zy82ZDFueDc4MVdpSWg1?=
 =?utf-8?B?ZVBxQjd2TkZuSXJFdDhtcVNVMGY4WXFwcHp1VWxrbnRnN29ySkJlWDBJVjVE?=
 =?utf-8?B?MEVZME9zVHcvUzRyZnRLa1dWVjErNXQ5ZHFDeHZ6TjAyQUZrYVhLeEFSdmMz?=
 =?utf-8?B?djBmMmN3UXd2cHRxL2dJTWMvZ21EYStyOTgzZWRDTW9WV01GWXF4eFplbkNN?=
 =?utf-8?B?by94bGpxZkhzR05ram0xa3JEYkp2NGdWMHBvZm5DYlJ4bWg4Nnpsai96U3Zy?=
 =?utf-8?B?c3lsUW5xVDV4ajZqbllLTzY2SFVrTy9pM1JJTHQrVzB3VXVjY0xkRXNDWEFX?=
 =?utf-8?B?TlFmYVJWQUcwN3BZUzRRUHRzalNWQWtaY1E4bVZ2N2g1SUkxQnpwdGRkWU9w?=
 =?utf-8?B?THVPOW5GY0RIaTdyT0VOYzE4TUc5Y2hyWkFELzZKYklqSDZha25EeDVod1N6?=
 =?utf-8?B?ak1YSWdxcFE0aHJKNUVCWEpvK1RLTUZxUUdzUGFqODhEd0dmcFE3Z3Jtbmlp?=
 =?utf-8?B?VG9qRFRMVThEL1BtdFo1NjhXS0J5UmF5LzZKNTh3VWNxOWM2TGhGaFdCT2Jz?=
 =?utf-8?B?dXVMa0JvVVgrQk5xU1A1cHM1Unl0RXAxN3BIbWpManY2N1lCU24zZTBTbXVV?=
 =?utf-8?B?Sks1b1VtNk9xVjk4cWtCQXNrM1Z3QnNjOXdWUFpPOTdWamp1V0Y3bmtuYXVO?=
 =?utf-8?B?SDBETWdWajlhd1NDclBtYzM0TG1nSE5xeHFLSFloQVBUTE91M2YwYitXTXFM?=
 =?utf-8?B?Z0F3dk5WY1hGd3NDcS9FY0tvajRlRW5CYVY2amxneFV3R2JjdjYydXZmbU1Q?=
 =?utf-8?B?M2ZaSEdiMnYzdHorWW9pa29JMUhPWFFoSWl5WVozeGFWMVRpTERlVXlTeTN2?=
 =?utf-8?B?VS9Wald0Znk1Vi9MMExLSi91L3dGenYxRDZRUGlmVzRsbDZpcmNPZGtMYmNJ?=
 =?utf-8?B?YlMrMkZvREN3NzBBajhjcmI2S2NTeEVRemJkWVZjQWhrQlJ4dExuVGdjSXV2?=
 =?utf-8?B?SXorVkhZNFRtSUFlUWhFa2VsenNqYTREMWVtd01LSHZIZEhxUlk1T3ZLK2pY?=
 =?utf-8?B?RHVZTG96b3VyUi9KdzRPS2dKdlpjOFhJREY1OTJ0T3Vtb0pPbVUrZU16Yktm?=
 =?utf-8?B?cHhCYnkwQjJRRXFtOE44ZURTL2QwaC9FNFA0ajEybGR0YU9LOTIvbFgwaWtQ?=
 =?utf-8?B?cmVMYytTMWVOdTNmY0RGdU82ZXMzSnNZOWlzRUhoV2UwWVdZL1YxZWZHcjdI?=
 =?utf-8?B?T0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3CCF5B7EE1FCF341BABE616A796E6315@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 923ad7b1-8b80-4098-0017-08dc58261704
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2024 23:46:19.7453
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vgp5Z0XgRIHn+hS4930/CHset6uszCe1sc6znvnlpGFblTAVbA4PpItq/qNYs/qquCVw0BNcfOKNM3qttaBHQO/D6tDwyvsIRSeWhprUKA0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6342
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA0LTA4IGF0IDE1OjM2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEN1cnJlbnRseSB0aGUgdmFsdWVzIGZvciB0aGUgZGlyZWN0bHkgc2V0dGFibGUg
Q1BVSUQgbGVhZnMgY29tZSB2aWEgYSBURFgNCj4gPiBzcGVjaWZpYyBpbml0IFZNIHVzZXJzcGFj
ZSBBUEkuDQo+IA0KPiBJcyBndWVzdC5NQVhQSFlBRERSIG9uZSBvZiB0aG9zZT/CoCBJZiBzbywg
dXNlIHRoYXQuDQoNCk5vIGl0IGlzIG5vdCBjb25maWd1cmFibGUuIEknbSBsb29raW5nIGludG8g
bWFrZSBpdCBjb25maWd1cmFibGUsIGJ1dCBpdCBpcyBub3QNCmxpa2VseSB0byBoYXBwZW4gYmVm
b3JlIHdlIHdlcmUgaG9waW5nIHRvIGdldCBiYXNpYyBzdXBwb3J0IHVwc3RyZWFtLiBBbg0KYWx0
ZXJuYXRpdmUgd291bGQgYmUgdG8gaGF2ZSB0aGUgS1ZNIEFQSSBwZWFrIGF0IHRoZSB2YWx1ZSwg
YW5kIHRoZW4gZGlzY2FyZCBpdA0KKG5vdCBwYXNzIHRoZSBsZWFmIHZhbHVlIHRvIHRoZSBURFgg
bW9kdWxlKS4gTm90IGlkZWFsLiBPciBoYXZlIGEgZGVkaWNhdGVkIEdQQVcNCmZpZWxkIGFuZCBl
eHBvc2UgdGhlIGNvbmNlcHQgdG8gdXNlcnNwYWNlIGxpa2UgWGlhb3lhbyB3YXMgdGFsa2luZyBh
Ym91dC4NCg0KPiANCj4gPiBTbyBzaG91bGQgd2UgbG9vayBhdCBtYWtpbmcgdGhlIFREWCBzaWRl
IGZvbGxvdyBhDQo+ID4gS1ZNX0dFVF9TVVBQT1JURURfQ1BVSUQvS1ZNX1NFVF9DUFVJRCBwYXR0
ZXJuIGZvciBmZWF0dXJlIGVuYWJsZW1lbnQ/IE9yIGFtDQo+ID4gSQ0KPiA+IG1pc3JlYWRpbmcg
Z2VuZXJhbCBndWlkYW5jZSBvdXQgb2YgdGhpcyBzcGVjaWZpYyBzdWdnZXN0aW9uIGFyb3VuZCBH
UEFXPyANCj4gDQo+IE5vP8KgIFdoZXJlIEkgd2FzIGdvaW5nIHdpdGggdGhhdCwgaXMgX2lmXyB2
Q1BVcyBjYW4gYmUgY3JlYXRlZCAoaW4gS1ZNKSBiZWZvcmUNCj4gdGhlIEdQQVcgaXMgc2V0IChp
biB0aGUgVERYIG1vZHVsZSksIHRoZW4gdXNpbmcgdkNQVTAncyBndWVzdC5NQVhQSFlBRERSIHRv
DQo+IGNvbXB1dGUgdGhlIGRlc2lyZWQgR1BBVyBtYXkgYmUgdGhlIGxlYXN0IGF3ZnVsIHNvbHV0
aW9uLCBhbGwgdGhpbmdzDQo+IGNvbnNpZGVyZWQuDQoNClNvcnJ5LCBJIHdhcyB0cnlpbmcgdG8g
dXBsZXZlbCB0aGUgY29udmVyc2F0aW9uIHRvIGJlIGFib3V0IHRoZSBnZW5lcmFsIGNvbmNlcHQN
Cm9mIG1hdGNoaW5nIFREIGNvbmZpZ3VyYXRpb24gdG8gQ1BVSUQgYml0cy4gTGV0IG1lIHRyeSB0
byBhcnRpY3VsYXRlIHRoZSBwcm9ibGVtDQphIGxpdHRsZSBiZXR0ZXIuDQoNClRvZGF5LCBLVk3i
gJlzIEtWTV9HRVRfU1VQUE9SVEVEX0NQVUlEIGlzIGEgd2F5IHRvIHNwZWNpZnkgd2hpY2ggZmVh
dHVyZXMgYXJlDQp2aXJ0dWFsaXphYmxlIGJ5IEtWTS4gQ29tbXVuaWNhdGluZyB0aGlzIHZpYSBD
UFVJRCBsZWFmIHZhbHVlcyB3b3JrcyBmb3IgdGhlDQptb3N0IHBhcnQsIGJlY2F1c2UgQ1BVSUQg
aXMgYWxyZWFkeSBkZXNpZ25lZCB0byBjb21tdW5pY2F0ZSB3aGljaCBmZWF0dXJlcyBhcmUNCnN1
cHBvcnRlZC4gQnV0IFREWCBoYXMgYSBkaWZmZXJlbnQgbGFuZ3VhZ2UgdG8gY29tbXVuaWNhdGUg
d2hpY2ggZmVhdHVyZXMgYXJlDQpzdXBwb3J0ZWQuIFRoYXQgaXMgc3BlY2lhbCBmaWVsZHMgdGhh
dCBhcmUgcGFzc2VkIHdoZW4gY3JlYXRpbmcgYSBWTTogWEZBTQ0KKG1hdGNoaW5nIFhDUjAgZmVh
dHVyZXMpIGFuZCBBVFRSSUJVVEVTIChURFggc3BlY2lmaWMgZmxhZ3MgZm9yIE1TUiBiYXNlZA0K
ZmVhdHVyZXMgbGlrZSBQS1MsIGV0YykuIFNvIGNvbXBhcmVkIHRvIEtWTV9HRVRfU1VQUE9SVEVE
X0NQVUlEL0tWTV9TRVRfQ1BVSUQsDQp0aGUgVERYIG1vZHVsZSBpbnN0ZWFkIGFjY2VwdHMgb25s
eSBhIGZldyBDUFVJRCBiaXRzIHRvIGJlIHNldCBkaXJlY3RseSBieSB0aGUNClZNTSwgYW5kIHNl
dHMgb3RoZXIgQ1BVSUQgbGVhZnMgdG8gbWF0Y2ggdGhlIGNvbmZpZ3VyZWQgZmVhdHVyZXMgdmlh
IFhGQU0gYW5kDQpBVFRSSUJVVEVTLg0KDQpUaGVyZSBhcmUgYWxzbyBzb21lIGJpdHMvZmVhdHVy
ZXMgdGhhdCBoYXZlIGZpeGVkIHZhbHVlcy4gV2hpY2ggbGVhZnMgYXJlIGZpeGVkDQphbmQgd2hh
dCB0aGUgdmFsdWVzIGFyZSBpc24ndCBzb21ldGhpbmcgcHJvdmlkZWQgYnkgYW55IGN1cnJlbnQg
VERYIG1vZHVsZSBBUEkuDQpJbnN0ZWFkIHRoZXkgYXJlIG9ubHkga25vd24gdmlhIGRvY3VtZW50
YXRpb24sIHdoaWNoIGlzIHN1YmplY3QgdG8gY2hhbmdlLiBUaGUNCnF1ZXJ5YWJsZSBpbmZvcm1h
dGlvbiBpcyBsaW1pdGVkIHRvIGNvbW11bmljYXRpbmcgd2hpY2ggYml0cyBhcmUgZGlyZWN0bHkN
CmNvbmZpZ3VyYWJsZS4gDQoNClNvIHRoZSBjdXJyZW50IGludGVyZmFjZSB3b24ndCBhbGxvdyB1
cyB0byBwZXJmZWN0bHkgbWF0Y2ggdGhlDQpLVk1fR0VUX1NVUFBPUlRFRF9DUFVJRC9LVk1fU0VU
X0NQVUlELiBFdmVuIGV4Y2x1ZGluZyB0aGUgdm0tc2NvcGVkIHZzIHZjcHUtDQpzY29wZWQgZGlm
ZmVyZW5jZXMuIEhvd2V2ZXIsIHdlIGNvdWxkIHRyeSB0byBtYXRjaCB0aGUgZ2VuZXJhbCBkZXNp
Z24gYSBsaXR0bGUNCmJldHRlci4NCg0KSGVyZSB3ZSB3ZXJlIGRpc2N1c3NpbmcgbWFraW5nIGdw
YXcgY29uZmlndXJhYmxlIHZpYSBhIGRlZGljYXRlZCBuYW1lZCBmaWVsZCwNCmJ1dCB0aGUgc3Vn
Z2VzdGlvbiBpcyB0byBpbnN0ZWFkIGluY2x1ZGUgaXQgaW4gQ1BVSUQgYml0cy4gVGhlIGN1cnJl
bnQgQVBJIHRha2VzDQpBVFRSSUJVVEVTIGFzIGEgZGVkaWNhdGVkIGZpZWxkIHRvby4gQnV0IHRo
ZXJlIGFjdHVhbGx5IGFyZSBDUFVJRCBiaXRzIGZvciBzb21lDQpvZiB0aG9zZSBmZWF0dXJlcy4g
VGhvc2UgQ1BVSUQgYml0cyBhcmUgY29udHJvbGxlZCBpbnN0ZWFkIHZpYSB0aGUgYXNzb2NpYXRl
ZA0KQVRUUklCVVRFUy4gU28gd2UgY291bGQgZXhwb3NlIHN1Y2ggZmVhdHVyZXMgdmlhIENQVUlE
IGFzIHdlbGwuIFVzZXJzcGFjZSB3b3VsZA0KZm9yIGV4YW1wbGUsIHBhc3MgdGhlIFBLUyBDUFVJ
RCBiaXQgaW4sIGFuZCBLVk0gd291bGQgc2VlIGl0IGFuZCBjb25maWd1cmUgUEtTDQp2aWEgdGhl
IEFUVFJJQlVURVMgYml0Lg0KDQpTbyB3aGF0IEkgd2FzIGxvb2tpbmcgdG8gdW5kZXJzdGFuZCBp
cywgd2hhdCBpcyB0aGUgZW50aHVzaWFzbSBmb3IgZ2VuZXJhbGx5DQpjb250aW51aW5nIHRvIHVz
ZSBDUFVJRCBoYXMgdGhlIG1haW4gbWV0aG9kIGZvciBzcGVjaWZ5aW5nIHdoaWNoIGZlYXR1cmVz
IHNob3VsZA0KYmUgZW5hYmxlZC92aXJ0dWFsaXplZCwgaWYgd2UgY2FuJ3QgbWF0Y2ggdGhlIGV4
aXN0aW5nDQpLVk1fR0VUX1NVUFBPUlRFRF9DUFVJRC9LVk1fU0VUX0NQVUlEIEFQSXMuIElzIHRo
ZSBob3BlIGp1c3QgdG8gbWFrZSB1c2Vyc3BhY2Uncw0KY29kZSBtb3JlIHVuaWZpZWQgYmV0d2Vl
biBURFggYW5kIG5vcm1hbCBWTXM/DQo=

