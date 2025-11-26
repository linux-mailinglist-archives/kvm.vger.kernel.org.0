Return-Path: <kvm+bounces-64772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BFE76C8C3AE
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:34:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DA1ED4E8354
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 22:33:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2587933F8B3;
	Wed, 26 Nov 2025 22:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lbuPtpZF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B262E5B0E;
	Wed, 26 Nov 2025 22:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764196433; cv=fail; b=SH7FzTuzXF33lqG6DawuWh6VnRf/vomXXFKLl4ew53fV5/3M6cxVOHBpOoBeh6tFtcyZZA23oEwip1Ws1Z94KtZlapmOg1b6vAS031G33R+kQcRHORP0+hm1Jma42k/OXv0ORDj+cmuV3U66LLJKAm4DAx79HumJmaum/Je4VdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764196433; c=relaxed/simple;
	bh=TbYQFc8DAtCNlHW0ZpGyIHmOopJHo0YqMnKmI2PUjus=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EkuANLLjOsVPipIZGB2h9S+P2QfnSHkmhcRDLm1kOU+kGt9oMe8oct5NegvfiZnLHaJE6r+7ugPjTQ9adB1sNr7LJt8t3BLnp4bUzLi7O701YSDPmQcnNuBo1vkrQgh/FXd9cig2ICUpbEvtC1sXFQywzmMrf4ZFtr93CZ3Q7DE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lbuPtpZF; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764196432; x=1795732432;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TbYQFc8DAtCNlHW0ZpGyIHmOopJHo0YqMnKmI2PUjus=;
  b=lbuPtpZFs1WQB2A8naQAG5eHrYTXxgWvHJMBt9DDFUa6pP5WzSWbCbzI
   KBJKZitEwLC07GL9hvbIeqhse3QHcVfETApXCi9b6HQE75VnSL1awpiMc
   ze3Im2kVYDf62Epsj7Vdke0Rsyenw6CiMJZyg3TgDjXWo3bUZVqQIXoTL
   43rMeKG3G7APIRZP2reohdApQ9z2Doj4jO0Lg6iLhy8QvkrNw9V9Hd8Ks
   hXHoGB9xRtB8rQVk7S24RGClxfmd5tywBki3lnoXGaoNACgDvK1KLJb4A
   Hechc6ScbOlG9CBHRD8YZIFH6tng7X82MfxTAkW1HK3awOFNNvDFk2qPa
   g==;
X-CSE-ConnectionGUID: l36W+VZJTw60tBK+UhXgWQ==
X-CSE-MsgGUID: U4kLvNteRYiDLEC0Qjx7yA==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="76931168"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="76931168"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:33:51 -0800
X-CSE-ConnectionGUID: CCHWl6EPRXizI39Qau4UVg==
X-CSE-MsgGUID: +W3iBiJ5R0ytgsWrDjt/kg==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:33:51 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 14:33:50 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 26 Nov 2025 14:33:50 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.57) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 14:33:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HTDDPAT443z3N4Yhro9MzbAURSoWNxQ5BSherwrnKUtjuPSgmz90DmBNoWRXyE+KYBCXQ8REEJTWrccf/moMYPborGcFIpUJ1Oz/V5FAQBBu0OitQQExRQFHbCiaUStBzRub8D9TDv1qLLpD0mKcqeHfpHwETPFYOkaBxOy4TKGe6ln3/jO9OOo1sTGW29d/BB41o2luTMcbXQ8eSosyN67Hb1KcZypcTnHDra0m4bNIMSD4JJg3rV55ReYUQC9RdxyoIIgD8oBXkC7wrha9VU9X2WsQGqxPzcyyZzHd514yjmOxtrHhpAdQxVgDPCCAUF1gIJgvMNSjnsdW5SCskw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TbYQFc8DAtCNlHW0ZpGyIHmOopJHo0YqMnKmI2PUjus=;
 b=yo4a9gNsk33yFY+Y/ulxnJjtgDyBhkpFA+2YP+hN1esVz9rTYI+xJrE50EbUAJfvjWq2w1cbOeuQexOSy5hTdM9kjqYAMyTZ0ZPNDzFYNtvImGilIhP2eOS01IWKYysRU3fZhCPULRZbrm+AO7lLvPmF7+4Pk1grAAQzAjIYKSeTO5ev89tCHzXFyw11rzEGG+5c2LpwgkX0tB7cYojojimkoE7fv/m61mvJQnc3j/JQ1rPKHHPqRoGYXML9NSbwZtpcQ5h5SoQX0FequkWKXucS0D+9XXSRhcdz6aVXu3rqhNmbfFdOTmwFLuRzqPbcsxFUxRvd6d46kKKqBJ0HNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH3PPF5AF05F6D9.namprd11.prod.outlook.com (2603:10b6:518:1::d24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 22:33:47 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 22:33:47 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v4 13/16] KVM: TDX: Handle PAMT allocation in fault path
Thread-Topic: [PATCH v4 13/16] KVM: TDX: Handle PAMT allocation in fault path
Thread-Index: AQHcWoEJdIDcZq+TtUiucO7shdqNWbUEffCAgAEWggA=
Date: Wed, 26 Nov 2025 22:33:47 +0000
Message-ID: <54f8e13966729b9e10a573b112e254474c31bdf8.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-14-rick.p.edgecombe@intel.com>
	 <8d5c0f57-bf91-4ea3-bd7e-5a02bcb5cc09@linux.intel.com>
In-Reply-To: <8d5c0f57-bf91-4ea3-bd7e-5a02bcb5cc09@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH3PPF5AF05F6D9:EE_
x-ms-office365-filtering-correlation-id: 7aba2ee3-3448-4694-881f-08de2d3bdd75
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bVV3ZjJ5dFFlOFdKL3JDSzB0ZmhCQXBzd25CS00wTktIZkN4b0N5bUEwZlpp?=
 =?utf-8?B?bWlsTWtHYXh3L2I2TTFDT3hNckZQc3QvWTA5dTdhRytEVmk4T1RXYVFab0NI?=
 =?utf-8?B?Z2MwN2xqRFdLYm8vUnVuNEJOTUtjN1lzSXQzZ1ZHLzFXdWhMOSsyT01lMTFt?=
 =?utf-8?B?Tk1ZOC9PcXI0TnI5am82ZktsVEZRRnMxZmRvOG82SGV5bkdjZWxLMXYzMGli?=
 =?utf-8?B?M3ZjbVJrcFB4eDA1VG5zNzY1cFJLVFJONXR4Ym1qV3RrV0tFS2RSZjVWWE1m?=
 =?utf-8?B?Nk5ydGtpTVdVT1paOU03bTYwVFBvb1hQN1gyNGtVcFpMcGF2ODdJWkhiMEEx?=
 =?utf-8?B?d2dxZlVVakc3SUtTNFZ5QjFLcXRqeGduTnZVMWRNTmEySjVqYmdOK0hKV21P?=
 =?utf-8?B?MmJIWkJzU1JTQXpEUUQvQ1dsRVhqdnU2d3I4YnlJS3RyZS9GY1RTU2M3bGty?=
 =?utf-8?B?bm9OL2VPbk1pTVZaVFRVVERCWEhTSTFNV0FISXNTNmQrc3BzVW9RSXRwdnhr?=
 =?utf-8?B?anBIbWZEVXg1alpncFUzMnpPWU15c1lMbUFzZzJLRjFUMSs3dWZWNEtLZVJF?=
 =?utf-8?B?SFZCeFhJWld1ODRva1MxWnVEa1hEUzlKYmFLYkRsM01pV1N1SWp2eXFXWWR2?=
 =?utf-8?B?Uldma2JERVVEMWptT3hNa1cyKzdXZzhGQlBhRUFQenVUU0FDZmdodUE0dVlp?=
 =?utf-8?B?YU1GblBsUXlpQld0bzJxeFVlUFUxSmUwc0pXODBqUUNVNHdya0RweWt6RzZB?=
 =?utf-8?B?QktvS2xoQ2VWUjh4cndQWEc5Y3lnTzB4VXlYSlArY2JDNFd3ZXFVdmt1YzJM?=
 =?utf-8?B?a1F2SmE3MDhJNHlzQ1piUlFrNXVSYWJ5WGx1bWpNV21vclFhS2k2SW1CbWo1?=
 =?utf-8?B?ZGNoNlN2UmlCT1JGMFpxeEc1S2ZRNm5HdjYrMTA4SkpuZGpZbDB3Q0Z1dSsz?=
 =?utf-8?B?QTRsZUFwT2ZqMHRzWHZ6cHFLbnlYZGszdTllbXJ4MjZDNVVzWHF0eVlFY1Fq?=
 =?utf-8?B?UFk4NW1NSTVlWHZEUjBEV0VPSkdPNVpXOUZicCtOREQ5UGpNOCtWMUx0Y2FQ?=
 =?utf-8?B?bm1mK2NTSUxCdEVBQWE2VGZ6SEs1dFJDUWlzZHFRZkdEUkJvZVd2aHd3T1hE?=
 =?utf-8?B?UWdjTzZxeG1uTFhzaDU0UEgxYzF6bFdvWjJ6clNmQ2Z4eUFMbGdiMWVraUhw?=
 =?utf-8?B?TUhmZVVpVzFoem9zZkhNTGlqSlBHQ2R5WWFDeHJEWEU3TURkYjlqd0haTGRT?=
 =?utf-8?B?UjdTdnV1eVJvek1uZ3hqeWlneENhbHhFM0JYb3ZFWHdENkVsMTVIaGI5TjQz?=
 =?utf-8?B?cmFhTDJSaXd2bzhTMGhyR1hUUFU3WTdQU1N0UnBGcXFteURiMUxxcHpCNDJi?=
 =?utf-8?B?UGlkWmVoT3RnemN1UjRwOGxwcVhGKzR3aC9taVNsazArNlFTQTJpWWtWdmxx?=
 =?utf-8?B?dDBrM2lLS3FucWtsTm8zdGE1eC9pQWdjZGtFT0Ewb1RyWVRaK2JEbUlPSVp2?=
 =?utf-8?B?bE13Mzc1RHd5VjRmSHNmVmlSZ1czRWx4ZWI1WitHSVdDTjZqMkhwR3dOYVYw?=
 =?utf-8?B?SlR4YVBZSEFOSEpCMys5MHBzRm9NaG92UHlFTkpGa0ZPdVVDWG5wOUw5bHVO?=
 =?utf-8?B?VVhFVnBkVjRlakg2bnZTZVhTUy95elpkZk0vRzYwa0QxWDcvdkVCUklSRjVP?=
 =?utf-8?B?Q1JqZUZwaEYvbWNmUTBsSXhOeDZqM3MzYktTOVdVTVN1dWJ0SFpjY01rcEFi?=
 =?utf-8?B?aFdRSlU4Ny9MQ0tMQmNTMFQrQW5oWVlQQmZuWWM4cjh0ck9oUGV5RXkwT2d6?=
 =?utf-8?B?Mm5wQ0VKMXZQMnRIcEQ1SG1BalBWQ2d3aHV5azRLbG1LSlhCUmtLOGhiUFV6?=
 =?utf-8?B?ejNjS0I0andRcjFCMzdhd0UyN012YXBKdGNHQmNIQ2Q0Wkl1eTRLZ0l2YzBS?=
 =?utf-8?B?cFk3a1ZEK2htL2dCcERZck1JellzZktMM00wRnRFRkhQY245QVh3bm9TS1Zu?=
 =?utf-8?B?dXhRTUFFd1pzN0VVNHFJbUE0Rzh3RmE2Z0tQaHZIYTNBS3pwelV1cElOZzJk?=
 =?utf-8?Q?BuZUCh?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MzFWdFZ1OHJFNkI1OUpjR3Y2YTFzRml3ZUFzUVFTK2lTS3hpaFI1N3RjaVd6?=
 =?utf-8?B?bGFrL08vWFhuTUtxbVZWODdRYWRNQ3c5bjZrSDRleEFwVlNTWWJuVnMwajNa?=
 =?utf-8?B?aUpNL0RUZVAvNEgyUC9kU2IvQjNtNEl0VTh5Q1VkclBpNldiWDVrVklTbnFz?=
 =?utf-8?B?b3NoU05zSkZSM1F4Um9lUGNPMlgwTlZoSk1XMW0zNVY0K0ZjZWVIb0R6RHFU?=
 =?utf-8?B?dXF2M3dNQ01xcjlHRGFPQzUrM3JDU0t6YzlmZHErQUhTRUtqNWxSakJaaUlS?=
 =?utf-8?B?TlZhRGZvV2JwSVNTaXNJSlc4V0UzZlBuZ0g4bExsbDlwZWI4ankrZ0tQMTNB?=
 =?utf-8?B?dDk4bVpFVlVQMEhObzJKcFVabEhkUytrU2NNSjNxdll1Q3NLNzV5UStOY0Zi?=
 =?utf-8?B?Sm1udjNncWd6Zk1oSHA3VW1mUHFGdy9JWnJUMHoyRGdHMVRrRiszN0wxYWFh?=
 =?utf-8?B?aDJaMnBjQVVmV2NWRTBhRWQ4TjNxY3k5YlArZEp1eDYyKzN2d1V1ZjAwVVkz?=
 =?utf-8?B?ejdNb2txNExWQ29MTkxuUzFxUGZtbEtSRDdZOFExcmt2SjdxOC9wdlJzWUJW?=
 =?utf-8?B?Y2h5TGRyV3ZUS0x0bGl5UXROazRETzV6bitpbG1sd0JOWWtFeDMxY3FLaEFs?=
 =?utf-8?B?Tm9XT29BVEtEMXQ5U01OQzZHMkxTZEpjbmVMeFpyWU0zNkZncTRvSWJuUDlI?=
 =?utf-8?B?STBpN3NHVlpQL29MUUxtc2MxK3lUOUFGdkZxc2x1ZU9HN1h2Rkg0cTdqSXRF?=
 =?utf-8?B?QURTa3ZMU3pHWHRkNWF4bTJhUmNWbW5ud1dMWjFGZGdxMnVqd2NPTlNUSE5M?=
 =?utf-8?B?OElxMzhyc05zdUlEZ0JuUGtYQ2I0RkVDdHpmRzhEeVZQL2lYQVpNV2F3R0Qx?=
 =?utf-8?B?bU9Nb3I1eCs1UkE1T09vMFJHNHhoUzlSSFJoM0gwRkthajlIRTZrNWp0c3Q0?=
 =?utf-8?B?WE5GTUtnQit1Qm9yV0dyejZZYTUxZHViMEtjMXdvdjhXU2FtM1ljWjlVd29h?=
 =?utf-8?B?WXA1eHBhQnVaMWw3N3RnNUtld2NnUGhVdFpaRWdxa3FhR3dKaUNnWUwzMXNl?=
 =?utf-8?B?a3Uxd2JUTkxKd0xVc0FBWlM4Mm43M0xiUUtJenl3d0hSWExqTjMyTlMrVVhD?=
 =?utf-8?B?RlhpQ0ljNkQrdVgxY0lVdFhMb3Ywc3QveGp6Rk1UVCs1MGUyUlE2N2g1M0Nt?=
 =?utf-8?B?Wlo1RlROL2ZPQ3ptV3dwRTFzYWhNS082YlFhYUJWalkwNHg4aktSbjlFaURU?=
 =?utf-8?B?QkVvTzh6ZktCWkNNckVha29iRnVsTDBXNEhDbmFGeW1EOXZCd0tWWm81VURN?=
 =?utf-8?B?cHAvdjk0Ymc2d29tM3BFcDlkLzlRWWlScHRBTEFJQ01yLzVkZW5maG5VS0JU?=
 =?utf-8?B?cFlGTjRyUEVCNGRQWVBJVlNYaWluZUxMNWErZzVicnFnVFhSeHJxUVZ6KzFP?=
 =?utf-8?B?YU9WbGNUV2oxN0M3WnUrY0wrNEdFVkphSGlmaUhvNnpJYUpOUENRWjZtd3BV?=
 =?utf-8?B?QTV2YlZXdWpvcXJYT3FHRG5FUUxWaTd2YkhVcHc3OEJaSnZoTGhNQU9LMjRW?=
 =?utf-8?B?WEZoeldheWJXL3djM3Rjd1dvUFVqTGFSNkU4Vm51Uk90aWZLRnh5OUY4WkZP?=
 =?utf-8?B?bkEwRW9RRS9LZVJDVG1OOVJjTmFlcEh1VlpWOGxIcXg0UzRoNjltcmQxcVRW?=
 =?utf-8?B?aHJFRHA4SkFCcy94UGhyM05EMEw2akxJbWNJWU1nYWZqVDljQVZlYlFqZm8x?=
 =?utf-8?B?NGVGK2NaclNUbUtyTG9LUlo5Qm5qK3FaMlRDdmg1bHdXQ3F4TVZSaCtSVko1?=
 =?utf-8?B?Z2IvVXZScVpETmE0NmZQNjJiREJnc1hqWnJJS2VBZzRndDlTT3ArMHpJRzJE?=
 =?utf-8?B?U2N2WExEeUZhbFdzTjA2M3hTRWhKNWVxRmNka2JnZ0cxQUFaV0RBdFZXTitq?=
 =?utf-8?B?LzAxNlJrYXhvNnA4SW9XbHVhUDNlZm04QS9iU0NuQWRZQ1dkaTRmd3FjUU5i?=
 =?utf-8?B?dlNSWGdjZWFlaGg2OGs2YUJOdTFvVDRVcmhneXVNNGNPZzJTcWZkbk1kVjhH?=
 =?utf-8?B?cHkxNlBWbVYxMGhUdER1RnNIYnhEMHQwRnZhTGVPU04wNHg1Ri8rdmhZdmli?=
 =?utf-8?B?bmJpSjNOSU5odWluUjN4WWdmM1lMR01lVTNlMEtmS3p6My9RemtQazJCS3Vt?=
 =?utf-8?B?UXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA217209B71398449BDC58598106A4A4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aba2ee3-3448-4694-881f-08de2d3bdd75
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 22:33:47.4374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: obYt5Gq04PSdcAVtm4Yva3sFQJ0i9Jk5FlR2EBbrGJTb1yKKFw8fEJLlaMeMOVnkK7uuLiw138gx8GrITjHoT+n6op5jhJtgr4DJqbIZioQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF5AF05F6D9
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTExLTI2IGF0IDEzOjU2ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4g
LS0tIGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiA+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgv
dGR4LmMNCj4gPiBAQCAtNjgzLDYgKzY4Myw4IEBAIGludCB0ZHhfdmNwdV9jcmVhdGUoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+IMKgwqDCoAlpZiAoIWlycWNoaXBfc3BsaXQodmNwdS0+a3Zt
KSkNCj4gPiDCoMKgwqAJCXJldHVybiAtRUlOVkFMOw0KPiA+IMKgwqAgDQo+ID4gKwlJTklUX0xJ
U1RfSEVBRCgmdGR4LT5wcmVhbGxvYy5wYWdlX2xpc3QpOw0KPiA+ICsNCj4gDQo+IFNob3VsZCB0
aGlzIGNoYW5nZSBiZSBtb3ZlZCB0byBwYXRjaCAxMj8NCj4gQmVjYXVzZSB0aGUgcHJlLWFsbG9j
IHBhZ2UgbGlzdCBoYXMgc3RhcnRlZCB0byBiZSB1c2VkIGluIHBhdGNoIDEyIGZvcg0KPiBleHRl
cm5hbA0KPiBwYWdlIHRhYmxlcyBldmVuIHdpdGhvdXQgZW5hYmxpbmcgZHluYW1pYyBQQU1ULg0K
DQpPaCwgeWVzLiB0aGFua3MuDQo=

