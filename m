Return-Path: <kvm+bounces-42439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A4BF8A786C6
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 05:17:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A437B188D3C1
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 03:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E413F205E18;
	Wed,  2 Apr 2025 03:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BplFjatY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29100205ABB;
	Wed,  2 Apr 2025 03:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743563783; cv=fail; b=hDXf49IuqYi3KhMJea86d5KqyKGzxUM5b+AoM3SQmUD7o12xnmDYtXRNT6bwrNe3P0K2QoMqgUJjopyayQKRuZXqdask/O9Sq99O5BC/ZCYT7fTMUiWM/A3Sf2PrDjCct7/T/Iqjh+TWsDeaXSHrrOjpX3IWIgvgo6/KCbizWjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743563783; c=relaxed/simple;
	bh=k5u3lrOeFTdtfkXm60Hbm0MxEeJ97jFK4L5WIRuaJjY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lG0WjWQ0GjKUf+sZs8TSHXV1TJoTXSusKk+fOB45j0QvBB9Ab0M1pz+sfRN5+K/xtGH32VZzuLdueoyFvPKtp+cVFPgMOY8XZ2KlW6g3z++hYfeaJ4pAWSQMkL2pL0vwIN9LXgtco2PxV0CyI7xw1aXYlvKhs/FNkDC0jUNukDU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BplFjatY; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743563781; x=1775099781;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=k5u3lrOeFTdtfkXm60Hbm0MxEeJ97jFK4L5WIRuaJjY=;
  b=BplFjatYh8pvXzJ9oCgZlz/3pxnqIIyruf/ktoXZZeETl/9Bbll6SSc/
   eT0wGs6wB1uOfN7DwcYtkqWxHVOaEkKZIbErYCBrbfuWohPJGSxRDg+D5
   yGpNjG+gipz5F5WbUNYTt3NLJ+UXz0MYwCiPfQlaJF5X6NqkpH04SSE9K
   ozMr0qG3zvYeITtGFkSrGjmxZgoW01d8JVNsrHSN3087SKW6zCEfEyt3w
   ZaQXuQWkg2uknXKZ5SwoUQu41NcCQLZY6gNbWxf8s2IIES+he5VWrZ/Aq
   FFxiQaE1PSCMpmbEFqKv8iUs1XrOKy8MXm8/LaUgSa8BaJaX+joWLMwPk
   Q==;
X-CSE-ConnectionGUID: c9NY/0jvSz+d5hIr9Q0+Iw==
X-CSE-MsgGUID: TELco0UyQDWHHh6DonnJaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="70272164"
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="70272164"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 20:16:20 -0700
X-CSE-ConnectionGUID: Rc2Lzov5R2CcK59wnpPamw==
X-CSE-MsgGUID: DzwLgm8oRwuAHarPSQSpGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="126817877"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 20:16:20 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 1 Apr 2025 20:16:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 1 Apr 2025 20:16:19 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 20:16:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eoaZdVbKLGCo8U66Z/EDt0BQ5jWr+GDufNMWPBq5nsQ/DkFhQfcv0kqJfPy4Nvx5qTw249clbfG7+fMZvl0oFZbOD9KUDB0lOdusGYRB4rMYAKBqc/Nwx8/hm44ThTEy0/yTnUozxTvrPCoUY21F7KyWh3IHUqqLty95D6xO6PwMSqEyDu/GvnkWFMdU09HMcv6zu3cAW3v72ARRRDIG/i/tmr3DOKWZET3FswE40hNqES02RIa3uebsZ290ecwuTa0cGRMcZI2B7iOgJBL4h2FOyWKtFh4pRtAIqOBKzjX61HxE1fi12geg1gjgHDEdTRZQSR0KAiPLCO4yr703Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AzOV2vYQDdcm/PnrreKp9ILA6yws0P9OWg8OMB7BUIs=;
 b=DR75S0p60koQoUhyfO+oM6uGfF+otXHP9Qo4o1D95CSBXKjcC3Qc3YO492NsZXc9glYfvIkGbP0wV7CSOwloQwndYmoAlg1vKER3C4SkKJfSyOknLDZH7ANfPrFcicgr6J062KNsXbjZGZytIRErMaC4VuKty3Y5MDQmGjhJrdi1lrofF5/5HFnEXgqlA3w3IJGq5qz77EgcDT0D4eSieFQ2uzk+g3NHQdJHVc1d27AEoMKe8IusVrGrEcr3p8GdoxJyMgbHGzdq0r3ub8W/qKvsYWfdPX26LXZ8IWyyy5Kp29ysRFaJCJn2ZsNyYjSdBr5RRIPdUOJqWWGu2mkG9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by LV3PR11MB8460.namprd11.prod.outlook.com (2603:10b6:408:1b4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 2 Apr
 2025 03:16:16 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8534.048; Wed, 2 Apr 2025
 03:16:15 +0000
Date: Wed, 2 Apr 2025 11:16:02 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<tglx@linutronix.de>, <dave.hansen@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Ingo Molnar <mingo@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>, Mitchell Levy <levymitchell0@gmail.com>,
	Samuel Holland <samuel.holland@sifive.com>, Vignesh Balasubramanian
	<vigbalas@amd.com>, Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Subject: Re: [PATCH v4 4/8] x86/fpu/xstate: Differentiate default features
 for host and guest FPUs
Message-ID: <Z+yr8iOndr/WUOG4@intel.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
 <20250318153316.1970147-5-chao.gao@intel.com>
 <aaac7044-5c65-4d96-9e00-815b90be56e6@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aaac7044-5c65-4d96-9e00-815b90be56e6@intel.com>
X-ClientProxiedBy: SG2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:3:17::26) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|LV3PR11MB8460:EE_
X-MS-Office365-Filtering-Correlation-Id: 51d121fa-513d-4473-882e-08dd7194ba9a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UkpGUmlCWnJEd044ZHFQRDQ0dGVqcTV5U3Fycm1taXE4VHFZMGVUYUNHTWta?=
 =?utf-8?B?d3RsQm8vYldHVWJLeW1KUk9Ua0gzUTFOa2JJZHYyMFFhQ0xCc1VGa2U1MEc3?=
 =?utf-8?B?Uk1kZXNKbE5MNEJZTGJOaGRkd1l1OGMyYU5wYWZDOTNJSjZIblE3RmJZWkRo?=
 =?utf-8?B?YkxpSEtaNVM1OW1Hd1ZNTXdkeW1OeWxZSGJOOTlCenQrL1hTbEtERExwMzQz?=
 =?utf-8?B?TnhMM2ZVNHJwSUpoN3A5bSswNHZ3MTVyWUFBM09mcE03ZTdJbzhDbWNJRGZk?=
 =?utf-8?B?a1VRa0hxV1Z6eHlUajlSU0J6K0k0d1N3cHdpT0k0bTVzM2ZicmNRM1VZRDlv?=
 =?utf-8?B?SW1OWGdNQi93V2VXWkxQUFgxZTRmSzdGQVhaREMwOGJkcktUd21QWHdocmV3?=
 =?utf-8?B?VXF4VDFjaGF3VGh3U1JsSmZ4OW5wU0tKUktsaEhJNWNFSGxRWmp1UkFoRjBp?=
 =?utf-8?B?SWlPTWF0WGptM0ZLS3cwWVRQNnBhaE82S21SZUdoNzV0SExPck9xR1NnQ1ZZ?=
 =?utf-8?B?eHVyeWg4UXhwaTYvZW5lVFFoeGkwSlV2VXVudVJQUkNTUUFiTFdsQkIvZE1w?=
 =?utf-8?B?ZkhDak9pdS9DLzUyTXNXMjZKQ3JBZGxvbVpac2ZkaTRGUFFDcVMxNTBmS00y?=
 =?utf-8?B?Q3MyUnBwWm9qVmpEU2hIbWR0ODhOVXpsQWR1TUxEbkJEcUdBYjFiVTRJaVo5?=
 =?utf-8?B?bjdCb2hZYVlETnlnSzIvRnB1NElGWVJQaHo5ckJvNEh6ei9MVFRGM0psdG1M?=
 =?utf-8?B?N1hYcVpod3pVN2RHMlhOUXgyVzlSTFVmRzJBT0VCaS9FTTR6c2dqSTFHMThx?=
 =?utf-8?B?UmczSm5COXdyNDNaamxUSWZraWFkcGtCV28rUUFLWEU4Y2E5dExIZzdCUmtm?=
 =?utf-8?B?S2lwQitPbnUrK080S2tVSHU5QklwOFdvaU90VFBRRllZTE1ka0lOdUV4T3Nw?=
 =?utf-8?B?a3B3RDhiOXJnM0Uva0t5SDMySlZVQ3ovd2swdGFZWWNzWUR2SG12MnR0Tys2?=
 =?utf-8?B?d1R0SjZ3YlFDZ1p4Z2JpV3U3T0tUZm4xZGk3dTZId3FxZVlGUDRzUTNjNU1I?=
 =?utf-8?B?M2Fab0ZOTlhGY2VHVE9QV2o5UTJYT1ljWVhaZDNmdHJ6bSs4ZEhST1lrT0pM?=
 =?utf-8?B?Z1g3L2s0K0YxSkVCdnlLamFid3JoSjM4YjZ5bDNLTlA1emIyY0FhMm9hWTF3?=
 =?utf-8?B?OUxTM0oveDdIbEVQdTd4K0VkNjlNSWFIUzdCd29uUVVrTlNtSzdZK2tNLzNU?=
 =?utf-8?B?WXNBTm1GVFRWaXNjRHl5ckFBT2NLL3YwckJtOVdHYkRRUngrcktWbW1HTlF3?=
 =?utf-8?B?c2lpa25PZzR5eVZ2VFhQMDl4Uzc2SExlOEpaZG82RndFMkJjcllGMmNaNlBC?=
 =?utf-8?B?b1FaR3FHcllrYTFHU1JxQ29zaTRNYWZ0K0pmeUdBenJiMjRTbnF4cjlrWVVw?=
 =?utf-8?B?VzRDUFZVVGZrUzY2anQvOXpuazlUYk9qUHZMUlhGN29haXNTUWd4SXFLSHpK?=
 =?utf-8?B?UWVLMWhkcnlmMWVYR0RsSmFVc2dLa002TkViakdiQmNxL1ZoM2RldTBKUWlx?=
 =?utf-8?B?YmdpcHNUUkxpT3VKKy9hSVgwNUZJRk5wKzF2eGlRN0Z6VElFajM1T2hqam5z?=
 =?utf-8?B?c3kxMVZUTkJ1cU14N3A3ditTTzA0TVhGQTByNkw4K0pYRmNpTGxET1lPelF6?=
 =?utf-8?B?TURjZ3p3c0hsRGwxdXpSSi8wckl2UnJpb1daeGpmajJvRHlSTXV0bkFBdzZQ?=
 =?utf-8?B?WS9RVUI3Mk9ZMExLalZLdXR6RGduUHc3Mkwra21MWWhIcUpwNDltckZhVkdW?=
 =?utf-8?B?NVFUWmFBZEZEUkJ4RUxPUTBzV3BYdjJFcmtHbFdGcVpRUTlFUUlhbkJiZ1hr?=
 =?utf-8?Q?tb2mTDVBkuXDS?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGJSRzIyUGU2U2x1MTluSXArY0cxZHRxVXROZml3bjlSUFovaFdJK1QrRTZS?=
 =?utf-8?B?alE0Z01SbjZxMlVZcnc2cTErTGp6T3FLSjl5RXdubENnaEYyTk9oR3NZL2Ux?=
 =?utf-8?B?TVJuSzE2WEdjV3BJdnBzYTFDZjFqb1FwbmtnR2lNUGhSV0ZFRzU4cFN2SGQz?=
 =?utf-8?B?K0IxaEZiUlgvd0w4VTJVMHYxcWVWOEsyU2Rackk4bGtVSUZyaVRaOE1NMUtT?=
 =?utf-8?B?ZlFFdytyUS85N011eDBHNk1nc0RoV1BmNnhwcXdwbGR5U1c5QkdZYkFuMnlR?=
 =?utf-8?B?eC95S2p3MzE5UVFXVWR1MFMrVFAvNFlpcG83K2JBRmhkVzJ1L3VwdWdLcWlX?=
 =?utf-8?B?alFWQXlPeU43UkZ4UVVDcHRQemJOT25HUytnKy9HRUx4UHI0N2M3bURqdWt0?=
 =?utf-8?B?VVV3M0RjTlY0Z09zbVRPZ2dqQzNJdzBoTnV3Y0pnNnN1bG9VSytRUnhoT3lt?=
 =?utf-8?B?b1ZGVU9iKzl4azRzSmlJcjN4dmJVNG96UXpLQlVNVTk5a2swTFVyUExsZzJZ?=
 =?utf-8?B?QkN2dDRtcktTeFVoTjY5VEU2MHlYaFNsOVlDZk44Yy9TcVAzVFNSbDdQMG1N?=
 =?utf-8?B?ZFlOQTQrNUdDL2FrQzQxYlBtYVp2M0g1eWg0S05yVGo3czRvQloyd2ZPb1lz?=
 =?utf-8?B?ZXFBTjd1cWNBTjZEQzEvZUY4YU9JcTVDc1VUN0lqek1hQm1hUXN2ZVkyK1lS?=
 =?utf-8?B?VzhWVUdCQkwzWGtPbEVRVHc4WURKWi9oWE1GSDUyTEV6ZmRXa3ZRcTVIV3Mr?=
 =?utf-8?B?K01iYnJIYkNBSEtSWkR3bXg2UEJ2OVRuRUJvazRIaTEwYnRvVzM3ZjZScHdW?=
 =?utf-8?B?Yk5FQ0U4djhKYWdqRlNENEhpVFAvR0FjWEJiYWRWSjNrTzJ2cEp1ZVhpM0pl?=
 =?utf-8?B?di9sdDhvTjFXeG9hNGhEbzFrZ2JMb0E4Y2Z1b3owWCtMekhRSmh5QzVMd0x6?=
 =?utf-8?B?UG9xSi9BcG84SllVWk8xc2MydVZEQ3BVSjZWVU44WE5Yd1U4ZTdCUE1sZVFW?=
 =?utf-8?B?RlFpNEg0UmJvcjZJMmU3OWpnUHovZk8vUm9oY3FFQVJoWGZMVW9xeEpITzNo?=
 =?utf-8?B?blAremEyWEVQbTgzb3pXR24vakYyYzNJRGFhdEljKzgxTFJsS1ZLaDJ4N3kz?=
 =?utf-8?B?M1dTRXFoSHV0c1lyVDREUkJVLzRIWXFueDNOelU1ekZYM3RrY1NrbWxKSnZF?=
 =?utf-8?B?b01iRkFhcEpWNGY5ODN5QnhDY1MvZ3JYQmRnUVJLK1IyaXlZTzVPV3cwUEVG?=
 =?utf-8?B?NzJTNmcyZFZ6ZUE0aXIzYjA1a2toNVFHQ2ZPa1NXSlpETkhKbldBamYyV2Y5?=
 =?utf-8?B?cnl5ZE10VVY4d0FTeTk0UHltSGdCK0xmNHFLcmpzZXJ6R2ZwQkZveVVyS3Qv?=
 =?utf-8?B?bytiYXZTcEs5S3FMelpZcFRDdk44M01BY1JMbzB6MEErRU5IRkQ4ci9wU1dZ?=
 =?utf-8?B?UGRtNTlpZHBLcEdCT1FKWkY5d0pTT0Mra2kwWDdNeXhsYXpjamNpdmhQWU5V?=
 =?utf-8?B?Y3FOdElOLy94R21Tc0srK2dZZzVPQVUvYzRaUVBmSHJCaWs3TE9Ud1NXemYr?=
 =?utf-8?B?SlgxK0VaRzFuOWZBMFV3dm5WY0tWcDBLcXpLMHpGOXlqcEVTRndnZWFTTk1i?=
 =?utf-8?B?MzlLTCtKcjE4QU1yZFhxVjlOcUozUlJiTG92dUVGY1VIUFRpUnU3QTZDSk94?=
 =?utf-8?B?SXN3WmRlM0FYOWoyWTc1MjVpQVRUTmxLSEI0Y3ZIZCtzSGR0WGY1bmk5WW5Z?=
 =?utf-8?B?YUs2RktVc21Sc2E4T2JFSFBhVDdSUXZrVGlWclh1RElHT211OXZXSGZaL0xa?=
 =?utf-8?B?eUZNTjQ2OGpqYnlpQ3BQRFpxYlZORGxrYkhLV2pDb3BYSzBjaEx6SjRJaEx2?=
 =?utf-8?B?YWUvTldhVWFaUnBLWnhGVTBlYzNaMGhBeWMwaytGNUpWWHo1V1VSKzZCRC9T?=
 =?utf-8?B?MSs1Kzc5TzlyUk5ROUozbk51Sys1OWlqS1VCUVgzV1Z3R2dJTVY0SVptcEpI?=
 =?utf-8?B?dktFWmN3UzA0ZXNZcVNUMWNVTnkwcHdYMXVHekQwZ2dvelJnZ0VtdUc3ZURY?=
 =?utf-8?B?dlNzbWpGQTRXWHpQdU5MMWs1NkM3c3V5OFgrdXI0elh0L0pKTHFBMi8wbmxo?=
 =?utf-8?Q?bN6M1tygcJ4p7EWixUQDQDRHR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 51d121fa-513d-4473-882e-08dd7194ba9a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 03:16:15.7736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tR1BaW4QLo/QB0tYJ1BUx7eMJWE7/KFj3t0h2NPngn0tXBplmCfMVHHHLCBJlIfqOK3aawne/tSinrHbJlucbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8460
X-OriginatorOrg: intel.com

On Tue, Apr 01, 2025 at 10:18:07AM -0700, Chang S. Bae wrote:
>On 3/18/2025 8:31 AM, Chao Gao wrote:
>> 
>> @@ -807,9 +811,11 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>>   	/* Clean out dynamic features from default */
>>   	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
>>   	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>> +	fpu_kernel_cfg.guest_default_features = fpu_kernel_cfg.default_features;
>>   	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
>>   	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>> +	fpu_user_cfg.guest_default_features = fpu_user_cfg.default_features;
>
>And you'll add up this on patch7:
>
>  + /* Clean out guest-only features from default */
>  + fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_SUPERVISOR_GUEST;
>
>
>I'm not sure this overall hunk is entirely clear.

I agree that this hunk is unclear, and your version is much better.

>
>
>Taking a step back, we currently define three types of xfeature sets:
>
>  1. 'default_features'     in a task-inlined buffer
>  2. 'max_features'         in an extended buffer
>  3. 'independent_features' in a separate buffer (only for LBR)
>
>The VCPU fpstate has so far followed (1) and (2). Now, since we're
>introducing divergence at (1), you've named it guest_default_features:
>
>  'default_features' < 'guest_default_features' < 'max_features'
>
>I don’t see a strong reason against introducing this new field, as 'guest'
>already implies the VCPU state. However, rather than directly modifying or
>extending struct fpu_state_config — which may not align well with VCPU FPU
>properties — a dedicated struct could provide a cleaner and more structured
>alternative:
>
>  struct vcpu_fpu_config {
>    unsigned int size;
>    unsigned int user_size;
>    u64 features;
>    u64 user_features;
>  } guest_default_cfg;

Your suggestion looks good to me, and I can definitely incorporate the change
in the next version. Thanks a lot, Chang.

