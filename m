Return-Path: <kvm+bounces-17478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CAE88C6F2D
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:31:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD492281BE9
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 23:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCCFD4F60D;
	Wed, 15 May 2024 23:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OJu2lUtY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBF9101C8;
	Wed, 15 May 2024 23:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715815899; cv=fail; b=aflI2rZikkruLLLbqUXGfnGHePygnyrU3DfYFnkD2lHdwj5UNdf0vIp0Dn43fm0N5bq/sW8dgzwI6RWSq75LjjdGNQFqib278EJGmmEbA2c3KJzhgKg71XJxdM6AAQZWOd9FZgma/3ZG0/g9JRsUcxC8Qlk+m892r2+4WNZjN6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715815899; c=relaxed/simple;
	bh=r5aLWM4klLIhTaYBENZm9DiREObCcNpIWONK26108gs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RFurjp6PUh5lSXI1dz4oXtnrPVDiavlTdEatOU+RsrLILyjiaiGcHcBoUWN3RF6FbHFvS+2cS2ShCQo5O2pPAaSvxUxaVod1xSt3qHf8SrqBN4WViO33tQkABLMflD/E4e50Gd2N14NDq2KgOu49Uf65IoW9sx1QTseOWF8kbOU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OJu2lUtY; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715815897; x=1747351897;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r5aLWM4klLIhTaYBENZm9DiREObCcNpIWONK26108gs=;
  b=OJu2lUtYa+0dbgamFOkqu7/a6Q7fcjqJBqP4M40KLg7Z9GQRx8oFZ6U8
   7cVUGrccXjAHJEmmPOuOhBXMRXnlwnfcY8KZcoprU+s1CJsnO3/7TgMI8
   CMzxVqHgO9uu/6xyXoxWULkZYPULwggHpOUeFZ7nV+usD8ClYGebxfu3w
   tyYE6xOZW3cvMjDlujqhOXdYRvgWMJVjWCspjqP6zBfpf9sthxK3rb5hH
   TShmF/Htnm0GAjU+H1N01ZbrvlVH6i0mCvP9UV++23+W2y/mCuTYp/5iA
   +PQ6c5+J8PZTx2tCAQ4SSTyzpxiE9lrzDM9rObged1+5ZrPhS/8GAXMw0
   A==;
X-CSE-ConnectionGUID: yRMrFbbtQ5idy6v5EhgEIA==
X-CSE-MsgGUID: 5r8GGNgLQZC1mS95RDgnyw==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11748351"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="11748351"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 16:31:36 -0700
X-CSE-ConnectionGUID: G4/GMjsTQEOnwwW4drxsmA==
X-CSE-MsgGUID: iWz9exO5R96pRId7vEi0QA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31054072"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 16:31:35 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 16:31:35 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 16:31:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 16:31:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nACOOjhVnmkl0q6FAp0ymBLxbl6Lvpa094Jv2abfRN0uWNPOIEaRrYTWXBheqRHuCnmbmApVE+HtMNYyj+cYF5VAps0RAXCy9et7BsAdrNA2Tg6WQ/tTzLzgk2o+9IBohi4E0pb2nanmaG5RdPO35Fqp1R2j8onnEsBHkBH+rH7+mOY7U38k/amQH9h5oTGekNxsyv51LGajZSBH4xBKo5mHcIu2TlBS27W4mpElsBSrji8YrmIVXjkVbXkP99ktFgQZg11+G2V7pzXarsSWXCR9xZ35w85j0x2TC0ZRfnb+jCopfEmzKCawVKkZNFacNitAa4EmiKHqekMN/5f45Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9wW1KvLxE67NeHcvKe/K3YRBEvxWsF52CPRAfNpuG+0=;
 b=OkZ99QrR9I33bG5cKL6aWrGWLeWvON9ZHt6ZwQEIbaPxFKWRPR5bfR2Kyi7MRie9EZqgMlmM4p+9UMk86hmNX0+UyD6KdX9w/wkWZ67hya8lSYqqObqdiA4B69TpWLswzQcNMEsCYd1FwN5wWW73qbo4R64bOAt03pIzsXIACmptfCOAnhAe+VMh2d3kHqcn7rKekF+x2RBJVdWBYuSG660xrqW4+HvghaK8dynqKy/KuRKCYpG/lb8V+WQqXu8MSX6KRQ8V2eR/FKQFiUgvsRA6Qu0+zHr/Gld4W56VSZ9ayP1IyuRFnLEyjwwOjBOXG6A2DuP+pLLZy5ti2oODWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB7562.namprd11.prod.outlook.com (2603:10b6:510:287::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 23:31:32 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Wed, 15 May 2024
 23:31:27 +0000
Message-ID: <eb98d0e7-8fbd-40d2-a6b3-0bf98edb77f9@intel.com>
Date: Thu, 16 May 2024 11:31:19 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "sagis@google.com" <sagis@google.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
 <9f315b56-7da8-428d-bc19-224e19f557e0@intel.com>
 <307f2360707e5c7377a898b544fabc7d72421572.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <307f2360707e5c7377a898b544fabc7d72421572.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0271.namprd03.prod.outlook.com
 (2603:10b6:303:b5::6) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB7562:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ced0953-30cc-41d0-8171-08dc75372403
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WStmMUFiSE96SzJYVU9kL29OM0NKTmlhLzdNZU9TRUo4cTZpaDRqUVh1Qk9U?=
 =?utf-8?B?WVpMMUQzY09aMHdVOHJBYUhpMi93YXo4TzQ0RnRqd1M2dHdmS0dZYmNyTTdI?=
 =?utf-8?B?Vi9FL1NjTGl6OW14bkJoaW5qWHFUbUdLOVRzUlQ3a1B1ZGhtampidksxZUx0?=
 =?utf-8?B?QXFNQXpRTVJVeW9jRUlwWGZ5TzdrZ2NPSllXUUFqVk1UZE1GenhQVW5wd0dN?=
 =?utf-8?B?UnRzeUZ2czYzcldlaWE4UkJLSm5yZk42WXh2QmFJSmZrODNvdVFHNndZZWxz?=
 =?utf-8?B?cXYvQjZpYnRSc2lYNkxSbitSMEZ5bGMvdEhob1JkSW8wYkZDcWo1UkJ2S2lR?=
 =?utf-8?B?UlVXZVRGRWxGWDRKVCs3NzQ0dnp0V2c3Q0tCREk1cG44OGh2bEloNEUzR3dj?=
 =?utf-8?B?SFdIZjR3SjVTWTAvbG5hSEE4YjNSWHlrNy9tT3IxeHM4SG9sUkRoZkhWcERD?=
 =?utf-8?B?ZFlhazc1eXJXTFV6cExKZDBNdmNYOHZQWGEwTVkxZW1aNGFuc3pFR05DNk9p?=
 =?utf-8?B?d21DUnNkYkw2cnlBdnNDb3o5K1MzSzlQM21wQnJ0d2t2N21QVDZvZ0FPQ0lo?=
 =?utf-8?B?MTFxVmZYeTVNSHBmcHlaYWdhYlRNTXlmakxNMlBIS2NPM3FnaExlLzlSOWdB?=
 =?utf-8?B?N2ZacUFGalh6NzF3cDN3ODY4QThFMkxWU3ZFUHovVE9LYzVFNEt5YUtmblBh?=
 =?utf-8?B?VkRkelNOUERycmJ5SCtmWFJCQkZtS2Q3cjBzbWRFdUVWTGNWZUhFa2ozdFJz?=
 =?utf-8?B?a29aSElKN0lZVlBPeENGcVRFNXNsaU1ZOHBXQXQ2RWxHVk4rMFk0Zno1aWhP?=
 =?utf-8?B?WXRBeVYzQVNFMmZib2JoWWZRWWtTRXV0ZWh0Tm9UNTdES3ltT2ZWQmtVN25U?=
 =?utf-8?B?RDJvSXdneVhQMDltbUlXR0dUbjdhdTRZakIzdDdTSVFZQngyVXp4bXRjYmhP?=
 =?utf-8?B?UkdYd2c1S0hXMVNCZVVQV29DRHRxRE1NallsNERITnhSalBLditqeUhiaTkw?=
 =?utf-8?B?aExIenNrMXp2Rll3M1RFRFRXYUgvRGZ4QUVoYTlSV3YxcWFHZnA1Y2pmc2Nj?=
 =?utf-8?B?NmtaTWlkazU5VGJzRzJaSDdVeksxdlpObWR0WlVLYVN0QzBUSThudDdtbUow?=
 =?utf-8?B?TmpnQ0VvNEIyVzArVEZuRlBmU0hZNFBZRXNUd2k5bk1KS2hMcmtobHJXRHl5?=
 =?utf-8?B?U1hmTmFFVDJORnI2cG1sblB5aFhOV0RWTGtiNVlkY0UvNUYrOEg0ZS93dFNW?=
 =?utf-8?B?YlV3bi9wRDduTmVobHpQZHhxckJ3N1kwMmRXTlBodC9PVWhFUHRrV3p2aTln?=
 =?utf-8?B?VWZPYVZYTUY2VE1ydDBqUlBsVjhSVnMrckJPelBtRG5ZZ2YxdUV0VG9NU2xB?=
 =?utf-8?B?RkhQQXNkYUJ2RjZNOWJVNmIrcmVCVVprZHpIc1V3ZnM3WmtPT1N4R2xEWUp3?=
 =?utf-8?B?ODRuL2Y1T201Rk5ieno5WnpjMWxWeGtRaEV2THhYdTNsbll0aXFSNmFXUDFw?=
 =?utf-8?B?cE13MTZlejNpK2c1N2padlpWUGJKdXRST2owM2NBRmpJWlV2ZHlXY1ZKOFpI?=
 =?utf-8?B?VU1FWUd4c3BYTHhzRHloUmlsUGd4ZjRVQU1NY2xiUC84dGt6WEJBQTYyeVNK?=
 =?utf-8?B?RnZRZndXYWVmWmNCVkkyK0pvdm1GblFxREJPeXRpak8wbCtES0YrbGVRY283?=
 =?utf-8?B?ajgxMGFqM0pjYkRvMXc1STNsa1Urb1RJdnZQWXBpVEMvSktaRUZlamRRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a083YVh6TVZsUU9XYUZEcmhNR1UwT3V0RGgrQ0VIQ3NrT3BBWjdvVTBNaGJG?=
 =?utf-8?B?NExleFcwbzh0WmMzbTZJWjIyNlZIV2pZMUVwczIvbmpaS2ROcURUUjZlQlZW?=
 =?utf-8?B?WHB5MmtQTE40ZFZ4QmZBS1RGME5Wak82Yy9KcUt3dHd3VHUyeXhnQnF3SzBl?=
 =?utf-8?B?LytHK3hXdnk0d2o3ZzlKakR2UFltTGw3SVVRVExTdmdFSUZSR3h2MHVhdmpj?=
 =?utf-8?B?SDIveEVOWnFqSFJ2aldCYlczMTVoVlpKMkZSWFBZUTNIaHlYTkw4VVR0a25R?=
 =?utf-8?B?cmRqWlhRZ2lYYzJzdDdkTVh1YXpUMXc5a2tsaExFL0NPZG5zcGdmR3pRS0NL?=
 =?utf-8?B?Q3hoMU1JdHVNYmZtNTE3aVFxOG1OYk1IT1g2a2dpTHdyYitLUE54cjZ4U25r?=
 =?utf-8?B?VmZQU1g5OVE2U2xNbWV1aXNrb0JvSGpzQmFlNkZhSGtOOUppcEdjeHJtRkc4?=
 =?utf-8?B?M0hBbFJscEJtWUNldjJtRkFwNmc3dTVyb2REQjcwdXFtU2dubEJ1U1pSMFY0?=
 =?utf-8?B?NWdPWHVIZm13VU80NlkrZnhXZEVMMHR2aEtRYjRoMUhEME42aVVCRkdBMUJu?=
 =?utf-8?B?ZUJoeDNENUJDcE1XNjdydmlwTjdPTzZoamVZcW5KLzlHQ25pK2NEeFdJSDdZ?=
 =?utf-8?B?NE1oMEFrTmhiZ2VFeXlnZjBvT0ZDZEc3OUFMeElQazRJc2x3NDhqa0cvaUFD?=
 =?utf-8?B?RXdWeEYrTmhIYk1RN3VDZlZRMUw4QTNzNitqM2dQK29EaTM3UjJ0Z2M4cms2?=
 =?utf-8?B?VllzSUU0NURJNlduTDRzNENyYllFZll1aWU4ekxNUTEwUWxkdW51cjYzWnFN?=
 =?utf-8?B?TkFUWnZ0bFFCTklUaEtyS1NLZ0xVTU8yUmVuNlRiQVNRS0NsZDQyNHdqMGlW?=
 =?utf-8?B?M1NpMlVWYm1WTVBNNUg3L3R3OGpZdE1vZkZaVXZzMnFIQ3FwMFdpVUZ6QzZp?=
 =?utf-8?B?TVlxSmlPd3dIVlJ5b2VidVNqbzdXVmR3WGRENWRkUVlQcXluWW5iYjlFVWlz?=
 =?utf-8?B?NVRmOWpBcGFXV0NpMzBLbGZ6dGZxWGY1RlRmSlpPcjMxTnROdTlsYjJaUzFX?=
 =?utf-8?B?dFBVYVc2dDB2dzBLQld6TWVhZ2d0dDMxY0NrWlZvUXNEc1NIeWxaU2FGWnZW?=
 =?utf-8?B?RVN6cHpEbFQvRlZPTmxLaW9EdTVXSHludEZrQnZ1bHoxR3FET0d1Zno5azEy?=
 =?utf-8?B?V25XSkdEWnlCakNLeVpQWGE3b2d6VlROb2RhMHVPUnNMbDJYYXpTSjByLzU2?=
 =?utf-8?B?dGVTMHUwTEVmNGM4b2NYMldDQmpxS0Y3akUwSUQ5TzA4cHMwVm4zN3F5QmpG?=
 =?utf-8?B?a0lUdmhoMXBOZ0xpczZKclEvOGxjU3hid1dzME9FUG5NK1lLN0J3UER6bHpo?=
 =?utf-8?B?YkdPRUZsWlhXQzJEZTRuWGpabW1OZHRXTVBENVhORnJuZ3ZYdXBJQ3dYcDlr?=
 =?utf-8?B?TDFOaE91Z250KytOY0dSUnhVaVNFNGtUKzJLNjVNQWtXK3Vlc3M3Q1U5MjdU?=
 =?utf-8?B?dFhlMmlBWGNzTmQrcCthalhPWDUzTWJaZkQ1ZzI4b3NvL3hLZzB2cUZ0UXl4?=
 =?utf-8?B?OFQ0c0U3RTVsNHZTWG1lVjlqWWN1VDJlNUJFbEFHSlU3UFk2c21USk9yNmZV?=
 =?utf-8?B?ZWhybHIxOWMxTlBiYmRJaEYwKzhROWN6RUM5RGdLbkR3Z2RwMVJWOHJyY2hr?=
 =?utf-8?B?dmwxenRnRW9HOElFN2ZlSzU1enEzQlRZWUxabmxYM3NzU0JHaHI1WUxZYldQ?=
 =?utf-8?B?djQ2UStMMjZ0WmFURTZvRGdpZ2k3akpITS9WZjBLME1ROSt4dmp0WGtEQWFr?=
 =?utf-8?B?dnh1YkhVREI5SkdNUDFVT0NLUCt5SmpkWERIUmtreUE2SnpyeW9EV3AzcnZn?=
 =?utf-8?B?Nkx6R3dpTlNwS3FFVlV0KzhhN0dDdDdRS2dyVDNpekJRVWZoTERqVUxQbEdY?=
 =?utf-8?B?UnZsZGxyUjdDdWhIUjFnYVo0TkhsN2tXSzBKdGdud0pseXNoZWFZNWxvTXdq?=
 =?utf-8?B?OTNUU0oyV3NwTTF4cnFLL1FNQ0FXQ3FEc1VLYnkyY2VsdXpKZ2R2bGxNeDdM?=
 =?utf-8?B?b1dzN2wrbEFRZkJ4RW9UczAyc2tpSE9MbXRzcWFic2FtdGo0bzc5SjVDR2NI?=
 =?utf-8?Q?5NCap0IAklHZzhIhe5aHetYkb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ced0953-30cc-41d0-8171-08dc75372403
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 23:31:26.9366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xe884WwIZIQmhVmQJZaslSe1vqo85h5eeXtDi84w4o7KgLOD3GcMIEG7GUAF/TOWTzg7A16/y+2Gd1qHqKuUjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7562
X-OriginatorOrg: intel.com



On 16/05/2024 11:21 am, Edgecombe, Rick P wrote:
> On Thu, 2024-05-16 at 10:34 +1200, Huang, Kai wrote:
>>
>>
>> On 15/05/2024 12:59 pm, Rick Edgecombe wrote:
>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>
>>> Introduce a "gfn_shared_mask" field in the kvm_arch structure to record GPA
>>> shared bit and provide address conversion helpers for TDX shared bit of
>>> GPA.
>>>
>>> TDX designates a specific GPA bit as the shared bit, which can be either
>>> bit 51 or bit 47 based on configuration.
>>>
>>> This GPA shared bit indicates whether the corresponding physical page is
>>> shared (if shared bit set) or private (if shared bit cleared).
>>>
>>> - GPAs with shared bit set will be mapped by VMM into conventional EPT,
>>>      which is pointed by shared EPTP in TDVMCS, resides in host VMM memory
>>>      and is managed by VMM.
>>> - GPAs with shared bit cleared will be mapped by VMM firstly into a
>>>      mirrored EPT, which resides in host VMM memory. Changes of the mirrored
>>>      EPT are then propagated into a private EPT, which resides outside of
>>> host
>>>      VMM memory and is managed by TDX module.
>>>
>>> Add the "gfn_shared_mask" field to the kvm_arch structure for each VM with
>>> a default value of 0. It will be set to the position of the GPA shared bit
>>> in GFN through TD specific initialization code.
>>>
>>> Provide helpers to utilize the gfn_shared_mask to determine whether a GPA
>>> is shared or private, retrieve the GPA shared bit value, and insert/strip
>>> shared bit to/from a GPA.
>>
>> I am seriously thinking whether we should just abandon this whole
>> kvm_gfn_shared_mask() thing.
>>
>> We already have enough mechanisms around private memory and the mapping
>> of it:
>>
>> 1) Xarray to query whether a given GFN is private or shared;
>> 2) fault->is_private to indicate whether a faulting address is private
>> or shared;
>> 3) sp->is_private to indicate whether a "page table" is only for private
>> mapping;
> 
> You mean drop the helpers, or the struct kvm member? I think we still need the
> shared bit position stored somewhere. memslots, Xarray, etc need to operate on
> the GFN without the shared it.

The struct member, and the whole thing.  The shared bit is only included 
in the faulting address, and we can strip that away upon 
handle_ept_violation().

One thing I can think of is we still need to append the shared bit to 
the actual GFN when we setup the shared page table mapping.  For that I 
am thinking whether we can do in TDX specific code.

Anyway, I don't think the 'gfn_shared_mask' is necessarily good at this 
stage.

