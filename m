Return-Path: <kvm+bounces-44471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A652EA9DE6F
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 03:41:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2CE4D7B2E4B
	for <lists+kvm@lfdr.de>; Sun, 27 Apr 2025 01:40:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82E0D1FFC55;
	Sun, 27 Apr 2025 01:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZfgbBOIQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9796A8BE7
	for <kvm@vger.kernel.org>; Sun, 27 Apr 2025 01:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745718073; cv=fail; b=jcR7gJx5tct++H1+bKaQztV2onS8ThE5RcPWOi0F+2R+SlzFzk+Ly/mQxSJrWnOluQK981GPue2/nvCauyYChm1c70NByQTZd4yZF/S37d4bbLHJm34OVlYslarMxg6YVLBp8hT3FquDLUCR3APaKtBtU+9TSNHUFXEWf0kV9r4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745718073; c=relaxed/simple;
	bh=WmeOBdp1muQfVZmjNXDqpmJ8AdwpZphRdOkYv6OvqBI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=c49+ffFtuI//K04qAzFSX6cLKsELFQcncyaaaP1GBRZLaAzM0Lyw4//7J9nhqlhKDd2B5vvm2/82pCpKWwu5EdI5hlDiaCeBMdsuTvNXiZrFnoEy0y9aZvy4nls9Yh/1xGC4XuZMmAypSV3MyDLHsCJQq8lFyTm0k8pwL1k5Qxs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZfgbBOIQ; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745718072; x=1777254072;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WmeOBdp1muQfVZmjNXDqpmJ8AdwpZphRdOkYv6OvqBI=;
  b=ZfgbBOIQF9lHUl/1r/aCOJEAHQzWSBItTVNj5W2k8+ygFkN824HL6Fj9
   B9K1uTZb8VtkARvQMLFoPFqpZxUfWSJaBHruQo09J0KKIm1fDFYQgb2qd
   Wf2H/ZhflSpCZ3viasxPtspPYKwwy/HNInMIZ7OqpkSn0nzvKIfv9XQEs
   ju6PyoQLzdVudu2o7RvbBXv17CDDHAb9TE4SLDabUa5TEpOTRvVWtizk9
   50uTHEFqIUO7lND+egnsSjDuzuZZQIdEgyY75671wSIgoN7m789B3kgK4
   IjkrJ878xSqaVrYVVrpaFMLgb1ae5Fe7L+u2ASvVUpiH0UbJjh1e6X4IR
   g==;
X-CSE-ConnectionGUID: FK+9YhlsS6SRrSeSWIvVxw==
X-CSE-MsgGUID: PR5C+tUiR4uKroz3C6RiZg==
X-IronPort-AV: E=McAfee;i="6700,10204,11415"; a="47349905"
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="47349905"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2025 18:41:11 -0700
X-CSE-ConnectionGUID: x7dbksjcSK6V4pw0sCO2Cw==
X-CSE-MsgGUID: os7Cn/AmQcGgl1ShOvd0Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="137255380"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2025 18:41:10 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sat, 26 Apr 2025 18:41:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sat, 26 Apr 2025 18:41:10 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sat, 26 Apr 2025 18:41:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GQuLLTRbkh/WZAKo2P4vneJHXXmtLNWdhKiNt1ik9gWShgjfQjTS/DSlBDKY+3W/BQ5W17B33FugPobw9+xg8jeVLXi+sR2FwNtejzi0FUE+tS7NFwvuKVeVU8LZWunFxH8NBQ8XNcVHMMFuELpP97E03D/ypjR9bp5y8hRTQtqCMFPsLz7nvIp+hxfl1k73ck2RIjxjSp7WkGiyZ36Zm1ibJeOgEboJaimM8N6aCQmaANXldO+oq939I7q6Vl+ZbOab4cp31ruySPFi39qhIUnUuUj8k6Vj+qGYcXDVdkHhBjJVGGqJpiLECRyhUioeDlIA6M11sFMa5CAVNRx/bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FcTTD0ogf9/kBRSeYvz4KItKksTwbRLuB740Se9ioUk=;
 b=dZsiR8IAQKN1tjTYbiYPM2mAskeDXc8mx3whi+d/o4l9r60H9QVNcjY8yApJylSMu/jOgSj9Hj5SzowYHPqSmP8QPH65RGhBa9XLgmuM76ePf6wlZ8IFv2OwSYBW+E9AF8WZcqtiyP08jsTVDDsh9YZMP7THyDq/gTJFy3HLwtZfGkcpPvRbc8ypHQJ06KLIV+F+eUj1vvGy3daIi2UA7BV9+iCP+kanyyRyTtFzKExox20ktItPzRMgI7J/RD5WvTppsAj2BbPkj7BzUXT4jVwDquS3/DR7MsapEpr2RpNHn0RTRRDKfRbtz0MDT3rVwgtbk6hlW2tqepSc6+W2Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 MW6PR11MB8368.namprd11.prod.outlook.com (2603:10b6:303:246::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.30; Sun, 27 Apr
 2025 01:41:07 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8678.028; Sun, 27 Apr 2025
 01:41:06 +0000
Message-ID: <6a1088ed-5b78-406d-9e50-87dec04cd28e@intel.com>
Date: Sun, 27 Apr 2025 09:40:57 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/13] memory: Introduce PrivateSharedManager Interface
 as child of GenericStateManager
To: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-6-chenyi.qiang@intel.com>
 <5ab45e5c-93cd-4053-8c26-253d27176fab@redhat.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <5ab45e5c-93cd-4053-8c26-253d27176fab@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR02CA0012.apcprd02.prod.outlook.com
 (2603:1096:820:c::17) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|MW6PR11MB8368:EE_
X-MS-Office365-Filtering-Correlation-Id: b72f82ee-276a-4b53-59d4-08dd852c941b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YzhleUYzblFEYVFnWGR0Z3ArME8rQjZNaFRQa2lGeEU1a01XYzFmSWpuSlAz?=
 =?utf-8?B?Sld3L1RwdDFQNDdTVXBjaG44ak5rcWhadThHMHVCUjJsSjhBSGVKTG9zb1Jt?=
 =?utf-8?B?QnZ3T1NVbzRZUUpLTEI0bXBvdDVaN2xjalNvNEZxT05Qa0ZTbDVWVC81aHZk?=
 =?utf-8?B?M21PNEZETUljNzIxRG5idVNieWNFU3ZsOVFSN2drQVIvVGVOTVd1ZCtUS1Fa?=
 =?utf-8?B?MHhHQk1BVmR3aE9PSjIwOVFQSHNqVjhXVnhzb3RYNGszNGpTUG1rYXRmVVhV?=
 =?utf-8?B?YVFPMGpMc1pkUEZBb1M2Ym9XdDM2TmtkU0dIV3Y2TzZTWjhISW90a3FvdjVN?=
 =?utf-8?B?VkNrdUkzdjNaV0hqMXVwQkZLRGxtZnA1UUh6Q3pMTEpUdjIyVTdMMk9PZ3VT?=
 =?utf-8?B?L2NQVFYrUjNJM2lqRkorVFRDcDMyRG9NejRueXJ3Ti9wa1lkSjVzczNiOXNW?=
 =?utf-8?B?azNQVjduR0NBemtKT3RBaTVSei80UjJYMy9vcWJJOE1zTkhrTEppRGFiS1VR?=
 =?utf-8?B?dnU1WWYrdGMrVklRYVdUTm03dVdnYkxEZm9yZTNTNU5jSTdXYy82V0dRK2Fk?=
 =?utf-8?B?cDd4VFNIVm5xUnJhN2RmTzZMM2tzWDFDbWx0SHVDWjBZcXpxYVVWMFFaSVp2?=
 =?utf-8?B?cm9vTi9ZN0tQTEtNQ094S1pHTVZvaVlXbFYrZm1QR3FsTDltMElKRkZOcG45?=
 =?utf-8?B?aFlLVUQzaWxMZ0pHcjVRMVZvbk05Uzg0R2dId0hVRzZMYitnTi80Wk83Q0RS?=
 =?utf-8?B?eXBOR25pU01vRGpsdFdsOS9DUlhueUVaK3pVdWZXSDNOeFBmdUlXWnhHeUxJ?=
 =?utf-8?B?RHhvdnlMRDhweGExd2dDb1ptbEt5SGpyOHlBT2QrNXdUS3pRUnVwUWtVQjdB?=
 =?utf-8?B?M2g0bloraTJMYUVHK1hpL3NKQVl1RUF1ZXhuVEtnQTk2Qk00eUVUdzBreUVY?=
 =?utf-8?B?QkJZdHEzZmU2clhCamI3YkVPNkRYdXVBeHBGbDFYd29XTnlySGZJNHA4VFk5?=
 =?utf-8?B?RzVqaEw0TWNqOUdqZW5ZcUZhVnBCYXRBUW9QeHhhWkIxMVQ1WUg0Ym5QK2h4?=
 =?utf-8?B?Sko1V1QyV3hnQWIxV0ViMm9XM0VIdDBMQWdtYjcwNGdYVGFXTWVSakVpTmZ4?=
 =?utf-8?B?eTJMT2tURXJTVVdlM3FndzJVcVVJZEs1T2tjYVJTTFBHanY1cVJ3OExud0h2?=
 =?utf-8?B?SnA4TVhHZXRtS2tlYzdINElXOVFFQU5yNjRIOHRsNlRLUnZDRUUrUzJZQkEw?=
 =?utf-8?B?QXVycTlOTjRTaDhEL2cyczNNTDBWZW5WbWo0dTl0UFFZQ1F1MGI2aXRZbllz?=
 =?utf-8?B?elN6YVdGY0hJZjNWRXErT1k2V0JFL0RPUTBpVW9JMWhsd0FnUExnN25Ca3Ax?=
 =?utf-8?B?eWs2UmRWUCs2YkpOdGpVZ1JJVnEwdkZacW9hRU0yRFIrR2pSaTJCQmQ5ZjQr?=
 =?utf-8?B?aFQxSFhzOER1eE9nQkkxL01TdFNTVU1rakNSTHpaL252Ui95c2dDamVMcUxr?=
 =?utf-8?B?V0NDZ0orT2NObWxkZGp2WXl1UHQxZGRrNXNuOThuYU9oYVY1UlNHN0NJSmkr?=
 =?utf-8?B?NUFJSHJJRjFDQzRGazk4bXRpdVFPWWhUdnFRQmFNN0lqQS9HZVR6UTh1Q0lU?=
 =?utf-8?B?QStQbzVpZE1VRFAvYTJhYzFkZkRLa2hvRlR3UTBTMS9NSmNkdzFlN0VNVmJL?=
 =?utf-8?B?ZUsyL2pKcFY1eXFrV3E2UUNCMGduTVVnZjBxTVdTd1cvWk9xVzRUeDc1dW9R?=
 =?utf-8?B?K3NXTVk1TUV2ZjJabmloZjBTK0ltQ3gyUHJyMnRPNXJ6OWVJcVE3d2dvNXpk?=
 =?utf-8?B?ZDVnQ0ZNZnk3T1NFSEpmM1N4V0FuRlp1UXlSd1h4NjRZWlF6clkxV2JKSTNI?=
 =?utf-8?B?T0o0RnJYT05MRHZmTVlwbmVleGg4STlDekZMYXB4eEh1TndvcVRibFRNcEtU?=
 =?utf-8?Q?QCge8aFDlNo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3VGWElpQWxoOXhRbjdXME8rRlVSQmk1T0pDVVlvTWcrQlJ2RzE1NGE5ZDVG?=
 =?utf-8?B?NHJPRmVrSmpVaE16bHFvWEtFSjRGOUhkVm1XSTJDci81My8wMll0REtPazJD?=
 =?utf-8?B?cEYrem5aMG9hb1BTQVBDeG9jZWUrdHNzRCs5NHBraWtjOFdsN210TzlmZHlj?=
 =?utf-8?B?Z3JuR1ArL0doQUJJWDdjSk5oQXB4RlBOay9UL1FxNnQ5YXNrMi9MbDZwYWZu?=
 =?utf-8?B?WWFqR0dwUytVR3NubUl4N0dvK3lTaXlrOWpXVExVclBuMVpaZ0F6djdvbzJY?=
 =?utf-8?B?SEFhSG1ha0dqRFQxYXNkdFlsQmdmL3g2QTl1YmI0bzFFS2lDdk9EZzFlV0xS?=
 =?utf-8?B?TGt6MkdBcGZ5VDNUZjBXbHZMaTFaQnZacDlsQUxRRHBMWUdoaytVYU1zMVJL?=
 =?utf-8?B?N0hvMFhYRWN6ditaZUFrM1B3aGl1dnQxY2VmQlljNmR4ZjNLandGU1lMZmhm?=
 =?utf-8?B?ZjBnTDlWbjNIZ0JvVy9uRVlqR25ZK1ZsWmR0WHk3SHNDQmZldXAwN25PRW9Z?=
 =?utf-8?B?VjQrQ1JFanoxeDBjSWZtdXRSSG01MjJ4a2tEbWNhYTdjZkw1SU40ZjNUN2sy?=
 =?utf-8?B?eVBqa29rRk1MY2FkdURDdDFyYW9IZE8xT2RqblFQb0diUUJTUk9GK2o1cC9X?=
 =?utf-8?B?ZFNJZkwvdXJpay9oaUVHQktCbUlJMldwVSsvY2Z6M1VWOUY3V1J3Zy9MM3Zm?=
 =?utf-8?B?K0RLN3dNbWdWUkl0RWJ1UUR0MHJGWWtZWmVQa0U3eXBRRnN6blI2N0twck4z?=
 =?utf-8?B?Q1lNaTZkL3dOUTlpbVR5cG8rR3I4S1JpMW0zSGhPT3JHdkFrS2h3Z3ZBL1pR?=
 =?utf-8?B?aFN6YXNGaXBLd1hNbVc2UktDT0ZTcnA0UDRhazBFbmViSzNVS3NhakJlVzF2?=
 =?utf-8?B?M1F3c3NEemN2QnJrZTZpK29OempTNi9kaEVCSFNjNXg1YUlGMnYyUHBoVEtq?=
 =?utf-8?B?dUp6c3VOOTZOdU56UjdGOU5wbjRpbjgySTRGLzM0YkdpZ3oydXVTZThiUVFz?=
 =?utf-8?B?MWFQVnN5WEpFVUY1L1ZYRDdQQTl2L1NxbWFGQjBvOTd5STN4blBldmM2L2sy?=
 =?utf-8?B?elhQNXAzT0N3aGVtTmhQM1htZ1gvZmpIdFpzZEFqeDNoZUdUcVUvck1yVGRl?=
 =?utf-8?B?VnFMLzBvcld5UzZKbWhYWDB2MmQydXB3RWx2bEFGZWtaaVBPbXc2NmRxakdP?=
 =?utf-8?B?V2Z2M0Z2TTMzbGxaUmFmVFdqWEZ0UjFncVZ1QmdmaVdlV3lvOXUzNFdyUFhv?=
 =?utf-8?B?RjZrZHdTSUN5RU9KMi9tRWhPV1g2VVdlVkY4VDRnbk5PUmhQbHc3UDlUMFVi?=
 =?utf-8?B?azJkNWpUdENiRWh5RDcveEE5UGwwYlhnNGdYazJZVTFyNStheVFjQkVBT0Ev?=
 =?utf-8?B?UXVHcXhjaFM5dGJmNXpaMUpQNk1WazZTdnBaanVhR3dkK3RxYmdOYkkyVTR0?=
 =?utf-8?B?RElkTkRWc0JRa0VYS3dGQWZpWjExMHpJSUErL0hnRWNha3RRWS95RUdoUEJu?=
 =?utf-8?B?WmJoSlRNWTBobm5abTM3WEdXand1a0N4WU1LNU1LSzIycEpqbkpqOHdBbXR4?=
 =?utf-8?B?a3RpMWxsYmhPVnFTcjNqbFlHa3MzU09IZldlc1dMUTNaOWZseWxsL3c1elgx?=
 =?utf-8?B?ZzNmZW5va3BpOU1VYmJVZXpqN1pDdkhZQ2NPK2JQOU5YTWdrZGJVbXk2M2lq?=
 =?utf-8?B?bnRRUGdPV2dobDREUk1zblJOVUdSWDRvc2N6alR5cTRVWHRTMUlKbzh2KzVV?=
 =?utf-8?B?YTVrcUpLeVZLcko5cjdtdUZLY2pLeThsc09YaTBZMUFoV1R0aGNLRTZqN3ZT?=
 =?utf-8?B?SXJ5RGYzcVBNYnQ4Z3lDTjRLUFVNYlhLUjRpbTRGREZKbEZDeGJYNWZGVzN1?=
 =?utf-8?B?V0hVQWRzZW43SjVSYkxrcXBsamJSbE5CdWxrcEZHRkptRW9WNXczMk5VdTR3?=
 =?utf-8?B?WHd1eUFSaGdUWnF4ZnBDNkd6cjI4OWI5MmRVMlNCQzB1bGhxZ01WUUpReXA4?=
 =?utf-8?B?MENuN3AyWFI2Q0x4NmYwWXZMeWlmanNOUEZUcVh3YVFUZlVUbk1CNFo5YjdQ?=
 =?utf-8?B?Zkp1b2RBanNvWTQrWEthK2VINm1nQlk0R25Kc2dnNTZkT3Fsd0VST2xJYVFX?=
 =?utf-8?B?cDFhV3FBU1pjdFdQbjFqbjh3blp5RFg0S0FqK0ZuR3V2S2hCL2VoNTJXUWpW?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b72f82ee-276a-4b53-59d4-08dd852c941b
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2025 01:41:06.9436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3BxLXZB8/n3HKhAZceD7pXnxWaiejdNPjTXgv+FZRX0MbNnXbraNeFu3nHgynfETIdqZUvXwCDi8Ovo3Ct1t1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8368
X-OriginatorOrg: intel.com



On 4/25/2025 8:57 PM, David Hildenbrand wrote:
> On 07.04.25 09:49, Chenyi Qiang wrote:
>> To manage the private and shared RAM states in confidential VMs,
>> introduce a new class of PrivateShareManager as a child of
>> GenericStateManager, which inherits the six interface callbacks. With a
>> different interface type, it can be distinguished from the
>> RamDiscardManager object and provide the flexibility for addressing
>> specific requirements of confidential VMs in the future.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
> 
> See my other mail, likely this is going into the wrong direction.
> 
> If we want to abstract more into a RamStateManager, then it would have
> to have two two sets of states, and allow for registering a provider for
> each of the states.
> 
> It would then merge these informations.
> 
> But the private vs. shared provider and the plugged vs. unplugged
> provider would not be a subclass of the RamStateManager.
> 
> They would have a different interface.
> 
> (e.g., RamDiscardStateProvider vs. RamPrivateStateProvider)

Got it! Before the real use case (guest_memfd + virtio-mem) comes, I
would keep the original design. Maybe seek the new framework after that
work.

> 


