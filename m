Return-Path: <kvm+bounces-17497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C1E6E8C6FCD
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 03:04:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 301861F22A6D
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF045137E;
	Thu, 16 May 2024 01:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q8HC1qnK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482A864F;
	Thu, 16 May 2024 01:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715821479; cv=fail; b=G+7Vh/777LvNQjOM1bsBrXchx4GINfDBL+KoYQ6BUObNo6w9Uac4HHK1RVVBwaPnU+SLPn4iXwthVj44RuQ2/lKKoxWs6oT3sVkhh5ujk/75THYKoS/h+vM+Rx482P11VQHPLqTmpUIXBZciHXM25LdjOcLQfywgU60Jywjjl2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715821479; c=relaxed/simple;
	bh=BU39Do7WtiffY4HJDPQqAxYo1VBrB0WiXSB6HEtpLgI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ILWK3NwH3x7L+L3thUNT7JnbtqqGcx+/IiJ0HgjH7ZujJ3h648oQ8abWyqcgl6FRzaFlWqlhy2uF8QBBxC90Xt6acihJMfk8NC5delO6c+1am618P1m6O0cTVbQP+RtL+uoCs3LUr/ZaL1yFtWE2bNRhM/rPbvLjcMzLHJzo9Hc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q8HC1qnK; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715821477; x=1747357477;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BU39Do7WtiffY4HJDPQqAxYo1VBrB0WiXSB6HEtpLgI=;
  b=Q8HC1qnKauHCD0BxUz8B7HTNglCKZ3uj8t3eXYlURQlmqsMSqKrcIbnV
   ec1P96t/V5hXbfPQkSLqNMfV+5cr87E9RfOPZ3j3WLFpgkHCSqOxJXNvD
   nIRcbSd5oNqwUYNhDHnLlv39Ubf3yu6CYEH79z6uTx3mMPNhGQjX7qPD3
   8BMtZ/b/+qIsoH/DSep7+bx/Mn7/BligeEB07lAJQEbYCAyvc37Xf5emG
   wDD0Mo/ga95kyPftqpJW8yMKijsn3VemVl0H5UzSzunNQHYWsfuBIKOCt
   FHPUwAfPxGjCIdsOstW3ad+8fgJlnHwJujoT+0F8x++7NKKiwFfEP7BZQ
   w==;
X-CSE-ConnectionGUID: VeyvdiJNRfmKSL1lacQ56g==
X-CSE-MsgGUID: 0f3b0IN2R8KgBQyt6Zz+xA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="29396382"
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="29396382"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 18:04:28 -0700
X-CSE-ConnectionGUID: LTkwffj0SnmgB6L18MOvRw==
X-CSE-MsgGUID: OIBsqTtTTlCE8+SJAdhSsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="31350378"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 18:04:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 18:04:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 18:04:19 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 18:04:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+SvEotTvB1NtcS79cJlws68CSdNxk3CwuqMs0TEA5Iw3jW0ioyS+Sc2HMGeKVIL6rQZFW9BljW/oTpKoVNRvZzcslXbaVC6XoxbxsUuZZYOOSf6lO3WLwscA8It8UwpPNOoF0q29qVs7YqVkUslro1/IwKMjDGQnUZYxjy7IiCow8CpJ9/ecXFHxuh1+Z19MgNWXZEUwvrgdwjyoTObdvKdNFP3aKAI2kwRSZ4NE4bVdW5jSpZXKNy9frQg1XB4R9km+2ey/TL14irNCH851gxLUma3koakLHmHdd2b1euewLxkjsHDaOdb0Edhk0P1mCgqx1fgvkqeH3JBb+0xaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cpVnqko0TgxdystzK5CuCzDhuzLCvT8dTVfrLcxCwWE=;
 b=BJuKtX5TSpPA79Z1bZuWOkj0NaEJX3f6FO6Yl9HQu52KeGILrku8Oo4cFpbVsp2i15YFpHeJN5LjllMEcsSpbEJPfLnKOMw7g8Qzgho7C90YLjotPYbw1jGrk1/I+FI8G6b3t5e7bJ25+3RDmtz8OHtN/Najz7+52ejAXc/mTei+qXoIm0NvNnymbYXTdy76+lzjDmfZuEfRBGTrtQ17pHSrW7jxlbLOz2Aiar4p4PUV4CV2iUYS5croa5oL3guevAd5Ca9wZ+TcqTNZydVRTOOFhdaf9OxE1FnJIyJIyIYqowfJihgHi+iUej95CTnPmmv+gZfFGUATqI8T6booPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by LV8PR11MB8510.namprd11.prod.outlook.com (2603:10b6:408:1e8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.26; Thu, 16 May
 2024 01:04:14 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Thu, 16 May 2024
 01:04:14 +0000
Message-ID: <d5c37fcc-e457-43b0-8905-c6e230cf7dda@intel.com>
Date: Thu, 16 May 2024 13:04:05 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "dmatlack@google.com" <dmatlack@google.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
 <9f315b56-7da8-428d-bc19-224e19f557e0@intel.com>
 <307f2360707e5c7377a898b544fabc7d72421572.camel@intel.com>
 <eb98d0e7-8fbd-40d2-a6b3-0bf98edb77f9@intel.com>
 <fe9687d5f17fa04e5e15fdfd7021fa6e882d5e37.camel@intel.com>
 <465b8cb0-4ce1-4c9b-8c31-64e4a503e5f2@intel.com>
 <bf1038ae56693014e62984af671af52a5f30faba.camel@intel.com>
 <4e0968ae-11db-426a-b3a4-afbd4b8e9a49@intel.com>
 <0a168cbcd8e500452f3b6603cc53d088b5073535.camel@intel.com>
 <6df62046-aa3b-42bd-b5d6-e44349332c73@intel.com>
 <1270d9237ba8891098fb52f7abe61b0f5d02c8ad.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <1270d9237ba8891098fb52f7abe61b0f5d02c8ad.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0147.namprd04.prod.outlook.com
 (2603:10b6:303:84::32) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|LV8PR11MB8510:EE_
X-MS-Office365-Filtering-Correlation-Id: 681a0106-0fb9-4f6e-1c36-08dc75441a52
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SWRGazBicmRoUmR0aVlkaFJhK1h1Z0JISE02NHJPTVNnSzUwODVmblVpd0dH?=
 =?utf-8?B?eXg4ZzhrWlR2VXcvb1h1YU5FQW11cFg0NXBnZHVsemJyOGVFQk5IRmR3bUdH?=
 =?utf-8?B?QjFnS1M4eUNGMzNGUk53ZTd6R01mVmhpRE5PSVg5YzBHc2V4ZmdoNUF6MFBY?=
 =?utf-8?B?eHVsS08zV21CSnJqcENVNU54Z1hiQnQ1bzZBeGdJZU12eERPa3l6b0luVDRm?=
 =?utf-8?B?VTZVSFBkNDAzYVhqYjUzTG9JeEE5ay9rbTYrcnUyOXhYN3BqZ29MTUlPNUZs?=
 =?utf-8?B?ckFlVnVUb0tsc0FPVGZJM3piY0VleTNMWFRmTFUvcDNWaldFVWJwdlBUTUVh?=
 =?utf-8?B?dE45T2hoOFBsd05TMU5zUUFhWkVTaXhFMk5oTFdWcnIwR0tIaS9vMWs3M3Ux?=
 =?utf-8?B?ZG1TVmQybG5qL2F4dXI1eXlhZ1hyN2YwSkNucUE5VVJ0NTE1dCtPZEtJNDFX?=
 =?utf-8?B?MG5uc2YrWEZzeWN4ZkZYc0FRc1BZbzAzTVE4WXhtTmxLNmZhQk9LdGp4elYv?=
 =?utf-8?B?eG1nZllXa1pwSUhMeXUvcmg2cS9pZklRQUNHcERYNTFYOUpDYnFJTGdCMEVz?=
 =?utf-8?B?YUhIeHo0eGhKNEViNy80SHYvQ2NzSnhoYjRsb1NoUFlQL2h1SGRZNFBlWEVh?=
 =?utf-8?B?R2NJUkFiUDZrQnBGbVBmZkE3MFF6VlhZbEhEWkNBN1NneXFVNzF0cWlEd01t?=
 =?utf-8?B?cVQyVFFCNUhJVzZYeHZNNG1GUCs2VFBIUmpsUWJLU1h2U1Bza2dYNzk1RjVi?=
 =?utf-8?B?b2RqNnJXZWZXTUxSMXlGdmhqYW9vbXpVOUk4Rk5kSU92T3NwTWk1elB0dDll?=
 =?utf-8?B?K0VDb2FkblczM0Q5enpXa3FKNU9NVUdRTXB6ckxOTXg0Sk9GcWNwcGIwZzUy?=
 =?utf-8?B?OXNmb1ZiT1dmUkhHUzBBT3F4K3FyYTkwS2gvRXVBWmtVbUlMNVBqUTlYcEdN?=
 =?utf-8?B?Q1N5Yit3bHRNWnNOeFpWQUh4OEJFS3lxYzB5S2tYbkx6RDlIKzRpeVRHZGVk?=
 =?utf-8?B?aHdyNkY3clpWbW9FNnhUZGJFSGlYc1htTjhONkY3SVlMaXpIeHU0czNTSVhJ?=
 =?utf-8?B?L0Q3MnpuSEF4ZnRuOWxqcmU4cWJxd3JFOWJPcGU0a28rcU85TFN5bCtjaHlW?=
 =?utf-8?B?OWxzR05HbHRieWZ2VStUd2VVZHB3WGhTd3J6U1F1SzByL01VL0NOQUFhdVVj?=
 =?utf-8?B?d3FJTy9mNHZseHZTbEVlMkdQZjFlaVpwVzFhL2s2K1AyOHRhY1dZTlV2SkZw?=
 =?utf-8?B?cmF0TitnOENSU1dwaWhRMUZMUWxsRHJ6MVFyZWZ3c080U2hNbEVWTTV2cEE0?=
 =?utf-8?B?MnZUams3MWFrNlh0WVBaaG5LYklXY3ZMZ0MvT0VYeC96V2lrTjRkbi9Ga3Y3?=
 =?utf-8?B?Rkl4ajNsaHdJcXVid2FSZEgwTTZtaEw0cUhRUkdsSG1iR1AvNEkwYWkyMlNK?=
 =?utf-8?B?RmRvcU9jVzdKZVFFMUk2RVNJaGxkcmNBTWtGWnhJMTJNNEI5dlYvMXNtdVh0?=
 =?utf-8?B?OWUzdUhaTXRWbkZWanp1VUJlTlRtdUZhdTZjdTNLY3pSOGRrOVR5bXMwTDd2?=
 =?utf-8?B?b1VVeURic09DMk5tSlFmbXlOYXYvSGRCUm1nVGJVTEpiTjd1NXdHVHEzUDMv?=
 =?utf-8?B?L2lVQzYvQ2FiYTJmcG0wb1d6ZlY3ZEZoYTNkNWVjZnZRTm1ML2Z6M2x0b2ZM?=
 =?utf-8?B?VE56R0JzY1NqUTZTWGZrT29tK3VkTVlnc3FJc245Zk9hT1RGV2FONU5nPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1VwQWtDaDUzSDJERXYxOWR6VWlNV3dXSklWUzRzeE9kemFrVWhSazVjdWRo?=
 =?utf-8?B?bFRzaHZmVEtPbks0YTVhZ1JxRkZIcUNLRWFkQnlzODJtTzlsdzQ1bUxpYVlq?=
 =?utf-8?B?U0szSURoSHlaMk56N0VYd2F0a2dlYk1McXBlVTdIUFJBTmVtY3kveldPUFVa?=
 =?utf-8?B?Q2YwZWVnYXRGZ1pDK3UxM0Q3NGdPUnA5RVd0bGVhckd6aU5xMlowNHNLd1p0?=
 =?utf-8?B?cmVwY0daZldlTXN2d0w3ZkFFZHh3OTQ4UENnaGluRExoUzJiMjFpN1hKaXZR?=
 =?utf-8?B?a0Urc3A0N3FKRkxYa1R1VUhvVUNTNDlZQ2JzQzJPajBxd044V2NtNVBrQUNz?=
 =?utf-8?B?WWcvZ3VjZzlwVGZ1Wkt2Y1BVMlN2dFp2WTlOSkxnemN0ZnNTbS9jdmQwNXll?=
 =?utf-8?B?TVFHSFI1YVFOUDBac3d6cktXOHI0TjZpTHplSHJ1enM0V2lDK01ERVozU2Q5?=
 =?utf-8?B?MDdOSnljaHV1UGRMOE0zUEFOd09nRUJFSllSWXVNZUNydnlrZUVPaTVMdzFr?=
 =?utf-8?B?MWVyeUova255QitKM25HcVUrT0l5OU44TEFzb05URXNIMFJqVEx3SVJUZ2RC?=
 =?utf-8?B?TWZwbm5ZaEt4TWZmTzliYmM0dmlKK3JuNnRMRHF0emRuUUtrWFJJUElEYWtn?=
 =?utf-8?B?SVFodGlvUjlQa0U1aXRla0dTSHBnTFhFc2ljbnMzOU02ZldFRTBWWFY2THNa?=
 =?utf-8?B?S1Q2UTQ4QWRkQ2tPZ1hTTkw1dGFMSXp2WXRNKzQ3b2xPVS95MmErL0wrTXRD?=
 =?utf-8?B?VGhGV2wrd3E0TWZzWkxnZVdCQm11UDhXTUNEbmpmWUhJMlFrSWpVYW13MWVS?=
 =?utf-8?B?MVhoTVQyd1kwNE9KQW84NXdSb0FpRU81bVIzZk4xUHI0eG8yQksxSG1pQUlv?=
 =?utf-8?B?OVA0QkhNZ2ZIdG9rK2daWUY4N25EWDlzU2NSaGtLV1Z0bDhhVEs4eEdmSUxR?=
 =?utf-8?B?QTB5ZFU2bTc0K1FBMjFSS3NZYXZzWXVhWjZ6SlREeU5tTnEzdng2N0E4MFQx?=
 =?utf-8?B?M2NsRWREaTRUaVVWNE5rVjQzYll5cXZONldOQ1B1OXl1S2orOXZVcDdnUjRO?=
 =?utf-8?B?UWtUL2RCM0Y4a0NCdWhUT2RrQVdLVVVKalY0SjlyWmFwc2FSL0FTelVZZWYw?=
 =?utf-8?B?dWpndnM4VXlPNCtLck1Ta091aWdyRWIvb2JSOHRLWkNkVnV5WnNodnhJWVFi?=
 =?utf-8?B?L2hSZzNZcEFwSVFrcnFCQnlwK3k0MmR2K0gwclFKTVdQcVJ2YXhROE4zT2pz?=
 =?utf-8?B?dVVBdzdYanlyWmUvN08xcGYxRlZCY1ExVTdYaXBqQ2ZQYVFnMUEvTWVXTXFN?=
 =?utf-8?B?TDZmWnBGNHBpZ1JDc05TTDlzeU9Pb3c2K2RhZVl0ZzU4UFB4djYzeXUxTWNF?=
 =?utf-8?B?ZnM4NFNtZDV5a3kwb3k1LzNHYXR6dzFOb3R4bGNxT1A0Nllwa3QwYytEaXZO?=
 =?utf-8?B?eTJuLzZDZEhGRnB0NmJ5aitnOWdDSGxUOWl4T2N2TkozYWZybXYwSEU4MkJo?=
 =?utf-8?B?bVJYeTNYcFFxVXcvSU1TbklnK3JyV1Y3NE9FdUVpZUxVRzJubXVPT1g3bVZu?=
 =?utf-8?B?SW5LYldIV01FOWhkRlpjOVFXNGlMbTMvQzcrRXZkTHZRTytUWUE0K0ZpbHJT?=
 =?utf-8?B?V0hMcXI3OVEyUVVadUVTNTN1YkFzVXpVQU1QQTdZdVdRSUlzQ0JyUGUxU2ly?=
 =?utf-8?B?YU9YZFYrWjVhNzJjSnk3aTlDaVRuT1ZicDVaN3N1bzNlVkxQWXVlWWlXTjU0?=
 =?utf-8?B?MXF0b1ZpZEdEMTdWdk9sK0owaFRTTnArMHFDSC9Wd290dWlUcUVhbjZYcFE1?=
 =?utf-8?B?VEM2S0xWaWNES3EzTytzNWlHMHVlTHNSRHBNOG5wcVZVb01UVDFFVTZXRW9y?=
 =?utf-8?B?dmdxOXZTU2srNVNVUTNVYzhyZENxdFpFdGpVS2UyVnNoMVplM3ZtVEJ4OVZR?=
 =?utf-8?B?eXJIOWdvSTJVcXNEREZvRlFkVzV4OUpWQmJ5L2p1M2s0eXFrcXArL2JsREM4?=
 =?utf-8?B?MHpxQWRMbkNDTWNTK3ExMEtFbjdFbkRYalIxTmtMUng3Y3l4UTF1TDFTNGZa?=
 =?utf-8?B?RXpLdGk4K3RTeWRucGNHWENJQzU0WDRqcXh5WVpYMmlveGRGam4zZUdNZ3ox?=
 =?utf-8?Q?Ptn4BIK2hlfS80ZLLB+HkzoGq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 681a0106-0fb9-4f6e-1c36-08dc75441a52
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 01:04:14.1153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0yL9UiLquEo8PEntJAG47dPnqGob1ZBIDc95/z5JFGni8A3oEgZ+ZHBxLhU+oY1FkBrDKtAosE6bQ7GROsMq+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8510
X-OriginatorOrg: intel.com



On 16/05/2024 12:35 pm, Edgecombe, Rick P wrote:
> On Thu, 2024-05-16 at 12:25 +1200, Huang, Kai wrote:
>>
>>
>> On 16/05/2024 12:19 pm, Edgecombe, Rick P wrote:
>>> On Thu, 2024-05-16 at 12:12 +1200, Huang, Kai wrote:
>>>>
>>>> I don't have strong objection if the use of kvm_gfn_shared_mask() is
>>>> contained in smaller areas that truly need it.  Let's discuss in
>>>> relevant patch(es).
>>>>
>>>> However I do think the helpers like below makes no sense (for SEV-SNP):
>>>>
>>>> +static inline bool kvm_is_private_gpa(const struct kvm *kvm, gpa_t gpa)
>>>> +{
>>>> +       gfn_t mask = kvm_gfn_shared_mask(kvm);
>>>> +
>>>> +       return mask && !(gpa_to_gfn(gpa) & mask);
>>>> +}
>>>
>>> You mean the name? SNP doesn't have a concept of "private GPA" IIUC. The C
>>> bit
>>> is more like an permission bit. So SNP doesn't have private GPAs, and the
>>> function would always return false for SNP. So I'm not sure it's too
>>> horrible.
>>
>> Hmm.. Why SNP doesn't have private GPAs?  They are crypto-protected and
>> KVM cannot access directly correct?
> 
> I suppose a GPA could be pointing to memory that is private. But I think in SNP
> it is more the memory that is private. Now I see more how it could be confusing.
> 
>>
>>>
>>> If it's the name, can you suggest something?
>>
>> The name make sense, but it has to reflect the fact that a given GPA is
>> truly private (crypto-protected, inaccessible to KVM).
> 
> If this was a function that tested whether memory is private and took a GPA, I
> would call it is_private_mem() or something. Because it's testing the memory and
> takes a GPA, not testing the GPA. Usually a function name should be about what
> the function does, not what arguments it takes.
> 
> I can't think of a better name, but point taken that it is not ideal. I'll try
> to think of something.
> 

I really don't see difference between ...

	is_private_mem(gpa)

... and

	is_private_gpa(gpa)

If it confuses me, it can confuses other people.

The point is there's really no need to distinguish the two.  The GPA is 
only meaningful when it refers to the memory that it points to.

So far I am not convinced we need this helper, because such info we can 
already get from:

   1) fault->is_private;
   2) Xarray which records memtype for given GFN.

So we should just get rid of it.


