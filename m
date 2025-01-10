Return-Path: <kvm+bounces-34987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 337B1A0886F
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 07:38:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D770F188AEE2
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 06:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8863E1C3BF7;
	Fri, 10 Jan 2025 06:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V/55O7hv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D2A433B3
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 06:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736491103; cv=fail; b=c2W4Gkjm3HJG/kzcA2BcDuaQoffUh0ngsQaUMhjdW9K+uJhCW48niV593TgZvZHkRCOKoQHMp94AOo3pG48rg/iXj13vSJKNdCpyOuDmqfJKS2eU1yo0tHadLxBwAaCvwJPTAo936ay/HfKvbhbZ7aaao03qjWRAkbNfx6ES/4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736491103; c=relaxed/simple;
	bh=DC6DrfDn2Tu2nJKwO5+NJFEG1SIH2xAmTCGPucejMO4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=W1hwwy58QSEiPG0U238FmzySlK0s19vHFLz413wOmjz9esV8scf5ZWouSdNNc82zh82F1px2nFXh8R8N0q7PcjNHDdEYs+ISUS8Rcr7dZwKJgs358ww6jaSKjSbpL46xIoe31T5PcDdzi+n7gCoUxL8Hu/mF3tyKLFKq/2Lp2O0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V/55O7hv; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736491101; x=1768027101;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DC6DrfDn2Tu2nJKwO5+NJFEG1SIH2xAmTCGPucejMO4=;
  b=V/55O7hvj3onrACRGO3lib4c6uiTbOIHc0evwgvxQtzPNlADvmWU/MVb
   9IbiMXIqETuSYKpPXkMPswSw8uH80n2sTOdXRxdcY2Va5runHSSZhghU2
   GYrYmut7go/bsOSzHt6tQruWt1W71Jqf0TZpl6alkxJkFR/wbCdZosOhP
   67CRlgNCi8b6xRb0yvU9Y9CpKvnMdFfwuxauwqj9P3yT7qp8c/9NryNKT
   KgLt4DzmAOXANNAZlKX27yPEbBeW5zC7rkVIIvy5o3yfpjFwNlclJJ/vv
   4gElCXhrjSPnnIUAnNu66NIvK9+W6IT8nSFyoq0jmk5HVue4vjggAvsN9
   A==;
X-CSE-ConnectionGUID: ZvJUPiihQ2WIbn+7dCIXfg==
X-CSE-MsgGUID: VOmNdnAKR7Or9bcGQeI39g==
X-IronPort-AV: E=McAfee;i="6700,10204,11310"; a="54192651"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="54192651"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 22:38:21 -0800
X-CSE-ConnectionGUID: C0Tglnp5S2yispEOsAOJeg==
X-CSE-MsgGUID: tEFrutUYQYaksgM+MzinZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="103460462"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jan 2025 22:38:20 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 9 Jan 2025 22:38:20 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 9 Jan 2025 22:38:20 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 9 Jan 2025 22:38:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JRayg1qaqDwXWBALvi3D46VPxbFt+8xw0Usz1fsHjg+MXtgjwBkWptAcxyw4LW4MpRQkxNE4y0XpDg+MW/v2tybEAIMzqUOvIqgmQgfNP8WdfFc5QInm8tDVbJHOqfuwG3HwvjkF19hi5oXJdkMYs0MqFeOHy/rfMQP0bTIlsWml59i98sa3VFUPZr8lnZySFQwxdo3S/vJQwFCBdOvQkgXcfAXGioeyh3EpjUgcxGRfee9DDd04FUnFTg4kAZ7+VYw+7rFMAYyzbSV8hwM5Btn+8VzUiNS1/wO/mUR7EaJaq7KTzRAqywtH6Qe628QNYZPNcyQ3nxVU0A3xX+owQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhmc1Rw13wWLGstHrJOxZgnrprVhmbalnKg700HkAIo=;
 b=ZkP3FMN9DR3y6u/gJovI9wgOnuuGcWy76rbiUM9GzcroGXSxrIHguQZ94SgUsi2HSFu4FYPXIhXtPCBrI4yx/2CLVy1wm5CGCTRnqyQSeSVzR9/KLAPoHt3dqCBkbL3SdBQYyoGYYOiDSwwP6JWsIJ5/1GjsPBbqsd4e/ikJMXIU+MikPI+CpNYoU7RJfcrKS4BhTOSILRHOQgiQirt5D4i4quLaPtOsBQ0tB3xZUmnotSuH+sw0OROiS1stF66n/UUiPajR75IdzXIzw2JQJKDs31hkhjYGRhpVq+GY04om7033QD2QDd7M0xvrdMD9ef8fGhgaOgYXcuc43chLFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 DS0PR11MB7621.namprd11.prod.outlook.com (2603:10b6:8:143::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.11; Fri, 10 Jan 2025 06:38:12 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%5]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 06:38:12 +0000
Message-ID: <2b799426-deaa-4644-aa17-6ef31899113b@intel.com>
Date: Fri, 10 Jan 2025 14:38:04 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <219a4a7a-7c96-4746-9aba-ed06a1a00f3e@amd.com>
 <58b96b74-bf9c-45d3-8c2e-459ec2206fc8@intel.com>
 <8c8e024d-03dc-4201-8038-9e9e60467fad@amd.com>
 <ca9bc239-d59b-4c53-9f14-aa212d543db9@intel.com>
 <4d22d3ce-a5a1-49f2-a578-8e0fe7d26893@amd.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <4d22d3ce-a5a1-49f2-a578-8e0fe7d26893@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:194::12) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|DS0PR11MB7621:EE_
X-MS-Office365-Filtering-Correlation-Id: 345fcbd3-3bbf-4e9e-2c61-08dd31415af7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?REdhTjBrT09jWGhyaHk2b2MyNi9vck1rN0V0eGdZeUVDV0I1V1F3cHBhOFNC?=
 =?utf-8?B?VlNtN1kzb3hYZWZ6bVdvZWdXYVJFUDJ4ckVaWitwT0FoRFpxY0hXc0dyclY5?=
 =?utf-8?B?WVZTZ1B6dHBBcTZCanJWZXdubXVwd21vd0Jlcms2cGxRZEFybWhrbTM1cWUr?=
 =?utf-8?B?WWZsT2MzYnlmOEJIaVBHYmxYcjZ5QmlkRWdxOU9QNUdIOU1vSll6TzJrWlQw?=
 =?utf-8?B?czFiS0thaGdUaHBSTGpnSTlhcGZ2R0o1UEFGRGY3cUN5eHNyNGFJaDlpUENT?=
 =?utf-8?B?dnBTVm9rSVFRaSt3RWxEeEE0emJPcmRCQUI2M1NFR01LZldLaHc4VTBBMnVW?=
 =?utf-8?B?ZGdiSzJEZHVqYzJ3UExUSTRvNkhFQTdzRWxMZ3M5Tmw4QmY4Q1R3dXQxcmFl?=
 =?utf-8?B?VTFjZTRIQjBybjZwKzNIVC9oVXRWREpHNlN2UGlKZG5GQ25PYS9TZWhaRDVn?=
 =?utf-8?B?VHhGTElCWlR5YURnUWc5ZElhSW9XTlh5T29QZGJNSFkzVGNQZTN3T2hjMU16?=
 =?utf-8?B?UlBNczRFVFY1RXg3WUlmOVFtd0RJWmUxQ2hpd1lqVHR3MWsxSjZLTHI3aDdF?=
 =?utf-8?B?ODQvVFIxNlY1N0dFYVIra1k3aHV6TWZlNlMzMHprdVJHWU0zNWJzMXh3S2JP?=
 =?utf-8?B?elhROHdGVVdrREZYQ2tBcGhUd3ZrVUlBWHRjbzhxS1lEVGxFcTJuQWl0RnB0?=
 =?utf-8?B?TTQ4T2JiNlkxSzhCbHdhVWtvcTNudnRDbmFkenA5VEZZeldaSDRLeDJYcFB0?=
 =?utf-8?B?a0I1SVZoTTRjMjk2RFhFUGdOVEJ4cTFyQkE4R1lPeFRGUmlma1VmS3A1YzVw?=
 =?utf-8?B?UGRrc0t2dmwzakkxRHN2Yjd2QzVxMDAwTzhSN2Q3Qm9wZWVqdm0vYlRrb0VP?=
 =?utf-8?B?ODJUVGlDT3p2eUFwSTVTWEhwQyt5MERHa1dHcjJmR3NNR2t5L05hR05PelZ0?=
 =?utf-8?B?MWN6QzVjQUdXYlRsdS9Md3JjeE9DQVJWS2dsSjNCWTN0L2hJWTd6RlJzMlY3?=
 =?utf-8?B?a0FVZExSUGVubDVqNkFQQWdsVm01K3RmbFBXdzhCaWZFKzVkeGxCS2FOOWNQ?=
 =?utf-8?B?bW80Qkd1RDFnL2NkMjA3M1FWNnVnVkpiaXU0Y2RYT3lhRXRJL1o1ZHlVZFdl?=
 =?utf-8?B?UFlxYzVtcVRPbUhIYzhJYTQ1dXFjVmFoTmlISlg1R2FGSHh0clJUU3VPalh5?=
 =?utf-8?B?dS94RHpZR1d5WnZoZXZKK2JiTFJCOVVYdytFYkdvTWNGTWxUTHM3UE0yOXY1?=
 =?utf-8?B?cExhV3VpT3oxYSs2bzZETENDMXE1TktSSGNsLzhVdjh2RVNoeThzQU9ESW5V?=
 =?utf-8?B?QVViKys3aEdVMksybmhYQ24wYjVTKzl6L1FNRmxLbEYwVGdzTGYzamFCUWN1?=
 =?utf-8?B?VCtiL001enBjZTNxV05tQ2V3bDczS2hKRm1MR0VVdkRCVXg0QkdKT1NBQ2Uw?=
 =?utf-8?B?Y1Q3Z1FiNFgvREdVNDJJYURrbmR2WkhETm80bkpGWUlnVkNZb2dCUWlKcEYx?=
 =?utf-8?B?V2hxaUM0WFdLeXZxcXZsM0wxRnhhNzZxaStlZ1lJeTRIeDZabXo3MzQ4aVJI?=
 =?utf-8?B?NHJxc0VhRWxJbnhQZktYRUpGWWhUSms4dDZwWjJqbUNjcFFNNFIwdFIxSGhj?=
 =?utf-8?B?Sm1jNS9uRE5RRmVLODlzbURINXhMQzNjZ28vRmV1V1h6N1RqcGtVZ2dNdXdF?=
 =?utf-8?B?STVsUWNKdUhZcFhySFFOSzJ5Z3NEdVE0UHJDQWtWTTJjc2hOWGxRS05EbDhN?=
 =?utf-8?B?OHpCRHdJanJwcm5tNjhXZjFEcU5ySDg3VS83MHFTZmptNElxNVhEaDJaVFFX?=
 =?utf-8?B?bmE1eWJ6Mm80dE80MTl3dz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1IvVENDZG1nN2Z5OGE5SHVxVkRWNm94cloza005ZVBkMHlwVGo4dVhVR1R2?=
 =?utf-8?B?ZmFmWnRZSkduUkpGMTk4cFpHOVV5YzZHNUpadzJQWE1pNEpVQ1JhTEtTd2J4?=
 =?utf-8?B?ZW5tMUY5Y0ZNRCtqU3lSUnA4TVhkVW5XblRXYTk3Q0xMQmI2ZUk4Z0hmdldS?=
 =?utf-8?B?ZEdaWGU0WVhvQXY4NCtHRERoYWZuY1NtL3VNczNzaUpHVnQ4WWE4SXZVbjNM?=
 =?utf-8?B?alJRM3IrODNBd0l2Y2s0ejBQdy9YcnF2ZzN4MUg2aUxQRkRGWmUxZWlhbk9Q?=
 =?utf-8?B?NGcrVGVnbzlSL3A2ek9takJxSjE1MDdhck43N01hNEhDSnlCbGRiMWM4dUpU?=
 =?utf-8?B?QW1YM29jdGpNYjRJdXA4a1Q4OFZDS1dDWmxKbFhHZk1Za3FFVFlGRDNMekIw?=
 =?utf-8?B?bnc0WEtUaEJOeGdnMnU2WVk0WHIrVlE0VnU2V2tqZ29vY2x5SGxsejdxNnhr?=
 =?utf-8?B?cGFOMGIwcmVsZzlqc3d1VWpVcGRJaE9JeVJ3NTVwenQ1VG45dXU5ZWI4NkFI?=
 =?utf-8?B?eUlMZ01UZVd3VjVJZFM5NVR0UnZ4alpGdysvcDlwb1ZHK1FhbGdWWHdXcFFT?=
 =?utf-8?B?L3YwSEJjblhDcHRYcHcxMzhTbXZsdWJ6d0RoRThCQkxaSXBIK3AwQTNzck9E?=
 =?utf-8?B?WEM5Tlpob0ZtWVpxRWlOV1M3N3k1YXlkVm43cDBnZW9WVEhxenRqTnRMdi9u?=
 =?utf-8?B?NVAxcUJXMXYxVXA0ZGNrM3Y0MU9VWnlrTmVDem1EV1p5Z2o1WVZpYVpzTmdo?=
 =?utf-8?B?K0VhVzMyTUlKKzFOQXlrNHRlQUNQVXJCVmZJTHlSaVNURjBrYmVBOElWUEVH?=
 =?utf-8?B?Sm9aYldaUXh3Ny9WeG1XeUN4N25YZHQxNXZFYVh0b28vYkZONjZvZ1NNdUl6?=
 =?utf-8?B?VzhUK0dub3VFRndNMzl4YkdHd3U2RDl1eEFGVVZtOTJGaG02NjZaN29OOTRt?=
 =?utf-8?B?RFhJZkNveU5ONVE2Y2FZYTIzZmwrVkpSdFhkamg5TVREalZUZXYzaWcyeitD?=
 =?utf-8?B?VjdzeFkxdFFyNVArQ09oM2JQdFEyb0Q1QjYzVlNrNWw4UGJKVFZVZkRYUERW?=
 =?utf-8?B?NTdWK1FnbTJ3RHhRUENhMlRsd3EvUU1KTC94THdWdE1SanA0NHBmQ3lRL1N2?=
 =?utf-8?B?SDFmY3g4TmlaUFZWVHJGVWNYMDhnbUlpdWlLT3hoUUJjNVdKcHhrc1RGdlFh?=
 =?utf-8?B?L052b2N6UzVrUEQyYmhneC80dGI5UXFPMVlUMGNVOGpnN25LR09OYjFKS0xq?=
 =?utf-8?B?NG9SVjFJZXc5d0k5MlM0UGxIWEUwVXNyKzdYNlNhSkVINXgrWktKemRTQ1Rw?=
 =?utf-8?B?L2ZiZHZ0Vk5qREN6VXpOVUt0bFhEVW5FUy84UUFhQTZaTWpJK0c4eTlpeExP?=
 =?utf-8?B?SThrNGYyajBxN29oYXdPZ2pib3I5eGNtOHA0NEFkRjgrZnpIOTBlLzVvbUcv?=
 =?utf-8?B?Q2lBV1ZzUllsL090MHRiMHZsM1hlSUErOUZkNzliV0UwTlNNR2hINjR1TUxY?=
 =?utf-8?B?SzNOaExRNnpEYjhwRXhDOEkrQjROVmFnWlFWc3VoMDZKcmhxQzJUbEc1YnJa?=
 =?utf-8?B?c3RxdTJhckFRNzBBR0R0YUhTMEtiTjJRUlNoWUI3RWsrZ1ZnWlZaZEQvSGl1?=
 =?utf-8?B?SXp5WUc3b1U5d0hvTlUyVTR6V0h5TTJFYVlOQ0I0eFhqeTQ5TTFqUmRBU0dL?=
 =?utf-8?B?akl1Ykc1Y3h5Y3pzNFJqbDZnRUlTWWwyQS83MXo4djI5WXJiV2tmc2VyMEhK?=
 =?utf-8?B?UGxSRG9BUHFoVG12R0Nsa3ZDektNQnB4OXpNcElnUW1YVTh0dU1BdzBINU9x?=
 =?utf-8?B?WFB5VU5scFZSNVREL0loRllpOWZpYVQ0NUx4dnFEQlJCblB5NXU0cjc1SDdR?=
 =?utf-8?B?MEhtV3c4TWtja3dhWHZOSFpxL2hPWHRiWFlSRXBTMkRFZmFmclBvdmdIVXZ3?=
 =?utf-8?B?RFY2aHByZ2hIRmxIRnIxUkUwaVFFdWVIT2xaVGpQcE83NDRzY25jR2VlbWhJ?=
 =?utf-8?B?Z29hR2pIMDRqeTNIeGtHOHJWMm1pNVRNVWVRV3M1NHVmRjY5Y0ExcW14cjRL?=
 =?utf-8?B?bjdCVUxCM0hwbVdiRW9FWnBBZmxJcXFVWTFDd0lWajcySUR0M1BJZVZPSGc4?=
 =?utf-8?B?ajNBWTJKLzNkYWxTNWg4cUZ2NURUdU5HNkxrNlh3ZEJXUTE0NXZEMEpTUXN0?=
 =?utf-8?B?bHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 345fcbd3-3bbf-4e9e-2c61-08dd31415af7
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 06:38:12.6357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hFloxoOdSU58I/CcT4v87fyk8rUXB+5OepjQqfTcnGwqsQt7GD0O7RobTGTPkV687gpAwKYQpf35TPnWsDcq5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7621
X-OriginatorOrg: intel.com



On 1/10/2025 8:58 AM, Alexey Kardashevskiy wrote:
> 
> 
> On 9/1/25 15:29, Chenyi Qiang wrote:
>>
>>
>> On 1/9/2025 10:55 AM, Alexey Kardashevskiy wrote:
>>>
>>>
>>> On 9/1/25 13:11, Chenyi Qiang wrote:
>>>>
>>>>
>>>> On 1/8/2025 7:20 PM, Alexey Kardashevskiy wrote:
>>>>>
>>>>>
>>>>> On 8/1/25 21:56, Chenyi Qiang wrote:
>>>>>>
>>>>>>
>>>>>> On 1/8/2025 12:48 PM, Alexey Kardashevskiy wrote:
>>>>>>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>>>>>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>>>>>>> uncoordinated discard") highlighted, some subsystems like VFIO
>>>>>>>> might
>>>>>>>> disable ram block discard. However, guest_memfd relies on the
>>>>>>>> discard
>>>>>>>> operation to perform page conversion between private and shared
>>>>>>>> memory.
>>>>>>>> This can lead to stale IOMMU mapping issue when assigning a
>>>>>>>> hardware
>>>>>>>> device to a confidential VM via shared memory (unprotected memory
>>>>>>>> pages). Blocking shared page discard can solve this problem, but it
>>>>>>>> could cause guests to consume twice the memory with VFIO, which is
>>>>>>>> not
>>>>>>>> acceptable in some cases. An alternative solution is to convey
>>>>>>>> other
>>>>>>>> systems like VFIO to refresh its outdated IOMMU mappings.
>>>>>>>>
>>>>>>>> RamDiscardManager is an existing concept (used by virtio-mem) to
>>>>>>>> adjust
>>>>>>>> VFIO mappings in relation to VM page assignment. Effectively page
>>>>>>>> conversion is similar to hot-removing a page in one mode and
>>>>>>>> adding it
>>>>>>>> back in the other, so the similar work that needs to happen in
>>>>>>>> response
>>>>>>>> to virtio-mem changes needs to happen for page conversion events.
>>>>>>>> Introduce the RamDiscardManager to guest_memfd to achieve it.
>>>>>>>>
>>>>>>>> However, guest_memfd is not an object so it cannot directly
>>>>>>>> implement
>>>>>>>> the RamDiscardManager interface.
>>>>>>>>
>>>>>>>> One solution is to implement the interface in HostMemoryBackend.
>>>>>>>> Any
>>>>>>>
>>>>>>> This sounds about right.
> 
> btw I am using this for ages:
> 
> https://github.com/aik/qemu/commit/3663f889883d4aebbeb0e4422f7be5e357e2ee46
> 
> but I am not sure if this ever saw the light of the day, did not it?
> (ironically I am using it as a base for encrypted DMA :) )

Yeah, we are doing the same work. I saw a solution from Michael long
time ago (when there was still
a dedicated hostmem-memfd-private backend for restrictedmem/gmem)
(https://github.com/AMDESE/qemu/commit/3bf5255fc48d648724d66410485081ace41d8ee6)

For your patch, it only implement the interface for
HostMemoryBackendMemfd. Maybe it is more appropriate to implement it for
the parent object HostMemoryBackend, because besides the
MEMORY_BACKEND_MEMFD, other backend types like MEMORY_BACKEND_RAM and
MEMORY_BACKEND_FILE can also be guest_memfd-backed.

Think more about where to implement this interface. It is still
uncertain to me. As I mentioned in another mail, maybe ram device memory
region would be backed by guest_memfd if we support TEE IO iommufd MMIO
in future. Then a specific object is more appropriate. What's your opinion?

> 
>>>>>>>
>>>>>>>> guest_memfd-backed host memory backend can register itself in the
>>>>>>>> target
>>>>>>>> MemoryRegion. However, this solution doesn't cover the scenario
>>>>>>>> where a
>>>>>>>> guest_memfd MemoryRegion doesn't belong to the HostMemoryBackend,
>>>>>>>> e.g.
>>>>>>>> the virtual BIOS MemoryRegion.
>>>>>>>
>>>>>>> What is this virtual BIOS MemoryRegion exactly? What does it look
>>>>>>> like
>>>>>>> in "info mtree -f"? Do we really want this memory to be DMAable?
>>>>>>
>>>>>> virtual BIOS shows in a separate region:
>>>>>>
>>>>>>     Root memory region: system
>>>>>>      0000000000000000-000000007fffffff (prio 0, ram): pc.ram KVM
>>>>>>      ...
>>>>>>      00000000ffc00000-00000000ffffffff (prio 0, ram): pc.bios KVM
>>>>>
>>>>> Looks like a normal MR which can be backed by guest_memfd.
>>>>
>>>> Yes, virtual BIOS memory region is initialized by
>>>> memory_region_init_ram_guest_memfd() which will be backed by a
>>>> guest_memfd.
>>>>
>>>> The tricky thing is, for Intel TDX (not sure about AMD SEV), the
>>>> virtual
>>>> BIOS image will be loaded and then copied to private region.
>>>> After that,
>>>> the loaded image will be discarded and this region become useless.
>>>
>>> I'd think it is loaded as "struct Rom" and then copied to the MR-
>>> ram_guest_memfd() which does not leave MR useless - we still see
>>> "pc.bios" in the list so it is not discarded. What piece of code are you
>>> referring to exactly?
>>
>> Sorry for confusion, maybe it is different between TDX and SEV-SNP for
>> the vBIOS handling.
>>
>> In x86_bios_rom_init(), it initializes a guest_memfd-backed MR and loads
>> the vBIOS image to the shared part of the guest_memfd MR.
>> For TDX, it
>> will copy the image to private region (not the vBIOS guest_memfd MR
>> private part) and discard the shared part. So, although the memory
>> region still exists, it seems useless.
>> It is different for SEV-SNP, correct? Does SEV-SNP manage the vBIOS in
>> vBIOS guest_memfd private memory?
> 
> This is what it looks like on my SNP VM (which, I suspect, is the same
> as yours as hw/i386/pc.c does not distinguish Intel/AMD for this matter):

Yes, the memory region object is created on both TDX and SEV-SNP.

> 
>  Root memory region: system
>   0000000000000000-00000000000bffff (prio 0, ram): ram1 KVM gmemfd=20
>   00000000000c0000-00000000000dffff (prio 1, ram): pc.rom KVM gmemfd=27
>   00000000000e0000-000000001fffffff (prio 0, ram): ram1
> @00000000000e0000 KVM gmemfd=20
> ...
>   00000000ffc00000-00000000ffffffff (prio 0, ram): pc.bios KVM gmemfd=26
> 
> So the pc.bios MR exists and in use (hence its appearance in "info mtree
> -f").
> 
> 
> I added the gmemfd dumping:
> 
> --- a/system/memory.c
> +++ b/system/memory.c
> @@ -3446,6 +3446,9 @@ static void mtree_print_flatview(gpointer key,
> gpointer value,
>                  }
>              }
>          }
> +        if (mr->ram_block && mr->ram_block->guest_memfd >= 0) {
> +            qemu_printf(" gmemfd=%d", mr->ram_block->guest_memfd);
> +        }
> 

Then I think the virtual BIOS is another case not belonging to
HostMemoryBackend which convince us to implement the interface in a
specific object, no?

> 
>>>
>>>
>>>> So I
>>>> feel like this virtual BIOS should not be backed by guest_memfd?
>>>
>>>  From the above it sounds like the opposite, i.e. it should :)
>>>
>>>>>
>>>>>>      0000000100000000-000000017fffffff (prio 0, ram): pc.ram
>>>>>> @0000000080000000 KVM
>>>>>
>>>>> Anyway if there is no guest_memfd backing it and
>>>>> memory_region_has_ram_discard_manager() returns false, then the MR is
>>>>> just going to be mapped for VFIO as usual which seems... alright,
>>>>> right?
>>>>
>>>> Correct. As the vBIOS is backed by guest_memfd and we implement the RDM
>>>> for guest_memfd_manager, the vBIOS MR won't be mapped by VFIO.
>>>>
>>>> If we go with the HostMemoryBackend instead of guest_memfd_manager,
>>>> this
>>>> MR would be mapped by VFIO. Maybe need to avoid such vBIOS mapping, or
>>>> just ignore it since the MR is useless (but looks not so good).
>>>
>>> Sorry I am missing necessary details here, let's figure out the above.
>>>
>>>>
>>>>>
>>>>>
>>>>>> We also consider to implement the interface in HostMemoryBackend, but
>>>>>> maybe implement with guest_memfd region is more general. We don't
>>>>>> know
>>>>>> if any DMAable memory would belong to HostMemoryBackend although at
>>>>>> present it is.
>>>>>>
>>>>>> If it is more appropriate to implement it with HostMemoryBackend,
>>>>>> I can
>>>>>> change to this way.
>>>>>
>>>>> Seems cleaner imho.
>>>>
>>>> I can go this way.
>>
>> [...]
>>
>>>>>>>> +
>>>>>>>> +static int guest_memfd_rdm_replay_populated(const
>>>>>>>> RamDiscardManager
>>>>>>>> *rdm,
>>>>>>>> +                                            MemoryRegionSection
>>>>>>>> *section,
>>>>>>>> +                                            ReplayRamPopulate
>>>>>>>> replay_fn,
>>>>>>>> +                                            void *opaque)
>>>>>>>> +{
>>>>>>>> +    GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(rdm);
>>>>>>>> +    struct GuestMemfdReplayData data = { .fn =
>>>>>>>> replay_fn, .opaque =
>>>>>>>> opaque };
>>>>>>>> +
>>>>>>>> +    g_assert(section->mr == gmm->mr);
>>>>>>>> +    return guest_memfd_for_each_populated_section(gmm, section,
>>>>>>>> &data,
>>>>>>>> +
>>>>>>>> guest_memfd_rdm_replay_populated_cb);
>>>>>>>> +}
>>>>>>>> +
>>>>>>>> +static int guest_memfd_rdm_replay_discarded_cb(MemoryRegionSection
>>>>>>>> *section, void *arg)
>>>>>>>> +{
>>>>>>>> +    struct GuestMemfdReplayData *data = arg;
>>>>>>>> +    ReplayRamDiscard replay_fn = data->fn;
>>>>>>>> +
>>>>>>>> +    replay_fn(section, data->opaque);
>>>>>>>
>>>>>>>
>>>>>>> guest_memfd_rdm_replay_populated_cb() checks for errors though.
>>>>>>
>>>>>> It follows current definiton of ReplayRamDiscard() and
>>>>>> ReplayRamPopulate() where replay_discard() doesn't return errors and
>>>>>> replay_populate() returns errors.
>>>>>
>>>>> A trace would be appropriate imho. Thanks,
>>>>
>>>> Sorry, can't catch you. What kind of info to be traced? The errors
>>>> returned by replay_populate()?
>>>
>>> Yeah. imho these are useful as we expect this part to work in general
>>> too, right? Thanks,
>>
>> Something like?
>>
>> diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-manager.c
>> index 6b3e1ee9d6..4440ac9e59 100644
>> --- a/system/guest-memfd-manager.c
>> +++ b/system/guest-memfd-manager.c
>> @@ -185,8 +185,14 @@ static int
>> guest_memfd_rdm_replay_populated_cb(MemoryRegionSection *section, voi
>>   {
>>       struct GuestMemfdReplayData *data = arg;
>>       ReplayRamPopulate replay_fn = data->fn;
>> +    int ret;
>>
>> -    return replay_fn(section, data->opaque);
>> +    ret = replay_fn(section, data->opaque);
>> +    if (ret) {
>> +        trace_guest_memfd_rdm_replay_populated_cb(ret);
>> +    }
>> +
>> +    return ret;
>>   }
>>
>> How about just adding some error output in
>> guest_memfd_for_each_populated_section()/
>> guest_memfd_for_each_discarded_section()
>> if the cb() (i.e. replay_populate()) returns error?
> 
> this will do too, yes. Thanks,
> 



