Return-Path: <kvm+bounces-16702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B15D88BCA6B
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 11:20:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D54A51C21BF4
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 09:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB6F01422D0;
	Mon,  6 May 2024 09:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TpREruTL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E90E1422C1;
	Mon,  6 May 2024 09:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714987213; cv=fail; b=RS8//2s602XblLa3ceepyTk/RcoH6NkLKsS68BxujA0xpC+Jh43aPcvCKG/qrFjZOxag1dVnRwbPhOtvUbaqTVRSK8VYgjEH4FdxEQUYWalu9C5jJ46l2Do+K1TaWlpAtFfyY/5F34ANhWPMxhBmkcwELNbGcgI4uf5O7/ZQyfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714987213; c=relaxed/simple;
	bh=W0WmQNFT7ybByZoQqZ4vYNo9VQWfCC2vo4EiIYoFHuM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nx2u3g5vG56xPEEZ3m4m6ZifgWLzSqJD5frAicccnOL1yqt2AZ9axCZzgvenykFSTwAZPDqn8RCvk+yLiY2QYOtA50KZh2mUMlXAjgcq/n101D5ND8fN1kYA0XSvO05qfuUOf2vWU4XVyVrd+8Dh//iHKjxX3SawBARN9vTs1gg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TpREruTL; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714987212; x=1746523212;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W0WmQNFT7ybByZoQqZ4vYNo9VQWfCC2vo4EiIYoFHuM=;
  b=TpREruTL+nCHU1zQZiseYbsAwh1US+p+nvBoZAERiNdoll8PQ7GHamy2
   FkJuGGgJNMtVd94lL55GcTS6lYEzYcoxy3/rdtZx8aMBMdD4xs6K+FfFS
   WlMqj3Q/XI77pLMYUT9XB5gedAmx5Kfz4oDyWBkHFTizsDmWxH+gj9z86
   Lo0FYW3TLgN9Mg+upecaE1rJzibKbL1JyknVj76PJjqaYWeFUt/jie+SO
   s0UNe5/OlPhCwmQ0GWl7Hf8D77BfpCsc6FjsBPoSJG17JdL+goubqHcKv
   xEHVt9T2uaYnGnLdxf6d+ZutEmaUXnoQBol4BcW2nNPgh7V8xsxM0MWtm
   Q==;
X-CSE-ConnectionGUID: YEStLEkpQl+Co7Pg91jfeA==
X-CSE-MsgGUID: HthxehulSf+etQOkG+pD/A==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="10880720"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="10880720"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 02:20:12 -0700
X-CSE-ConnectionGUID: 1tJxHwnESjSk8Fi6ZkyBPA==
X-CSE-MsgGUID: Q85daXy8Qo20DZKfwL2wPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="65541099"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 02:20:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 02:20:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 02:20:10 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 02:20:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8gwtlzVQaukx3dy2Yorpqfe7OdRKQDohGcWyrjc7MQ86/HMX8Xn1jAinGH64eySyjrcGJhPWy816dQjjUZ5uU8lC0niiepgkVNMt71DhJeXzAj5lxPyBJ397f/yTDivFdbVo6k7ryFG4dmb58o/MUm5vcJ2TTNJj5RN/vWRc17UrRdJ1IBmQX0zxcKqzw0xAFFQbtZCKbOlS5Z1xnd/halGVUUjokv5KC4R0p7lmNXD5aRcok49Myq60UQP6/PfAdecUSNrCDyTzHGZQB0fydwI3koqSxFznXAhVcNj7O5q6OWn7RtwWOQOtXcEppvfN0gV+sy8y54Psi4AbNWwEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OnjN+GuXFagqoNzOibd71fJQOY6hPgkCgWCaON+nGTI=;
 b=NP0dm3gL9vtFaol3A8sr4pIQ34BcpWsIr1flfDX+6bxOi4C5ZLgmEyehmaOdk35iDYYC+x9UdUjUSnt/naQfuI0kuOcOjAfB11g0i9qRK8nZNUdbBevZn1JMevyQ5G3mfgBpLclxYh18mBrzNjGFDPCEqt7aKqkOn3DtDXiiP/1Y1sy/0HVZ3+rtt0Ehy/uYKe3Bnt5EH/mB/32OVqogmtsW7Eywhrd6lHV0lVH33Fouok8pOh1UdBqkgAb5/qvnR95CT/cQ9ug84/vZnvSN/NrJl0lMBfC0T6uFHGeaw3YdZvbiysRec2P7wDfoq8zdcK1su25ptWjpK4HGlHZNyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA1PR11MB7110.namprd11.prod.outlook.com (2603:10b6:806:2b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 6 May
 2024 09:20:08 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%6]) with mapi id 15.20.7544.029; Mon, 6 May 2024
 09:20:08 +0000
Message-ID: <b3492f28-238f-466b-9e06-c483a58d521a@intel.com>
Date: Mon, 6 May 2024 17:19:58 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 25/27] KVM: nVMX: Introduce new VMX_BASIC bit for
 event error_code delivery to L1
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-26-weijiang.yang@intel.com>
 <ZjLN5iGKE6DgEyVa@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZjLN5iGKE6DgEyVa@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0009.apcprd06.prod.outlook.com
 (2603:1096:4:186::17) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA1PR11MB7110:EE_
X-MS-Office365-Filtering-Correlation-Id: a80dc507-88c0-42e5-30b8-08dc6dadb8fb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U0wzVDhyNnhOZ1F1cXg1WmNHR09UbzROdlBNTXFRVG1HODYvY1hpUFJuNFFt?=
 =?utf-8?B?NUZrV285VTYrV2htdlNxWXBibmJYZzVITFUvSnhQT3kwL0lWRlZJcTZtT2JT?=
 =?utf-8?B?T3NrQTVjZ0tsN1lCRVpGVk11Q3dIWjB6WHRxYTcyTjBqc3lvZkhHSXdrNkhV?=
 =?utf-8?B?L01PVXJ5ZUdxVTZGRkJzNC9sOGJFdTJHazZzS2VHRkY2d3R0ZlZRUllsZDIr?=
 =?utf-8?B?NmZKK3dTck9zRm9jN3lrZzkxMS9vZThQajlDZlV0TGF1WDEzcUtBY3NBaDNX?=
 =?utf-8?B?NDMyTUlYWEF4a1hab2Y3cmRvcGJFMnk2ME9pWjFaWGRZQVBjUVJxRkxHTkh2?=
 =?utf-8?B?NCtEN2tPSzBpUXVYdENUSFpOSWMvcm9xd0FPQ3hoblMwOTNZWlJHUWtDb1lq?=
 =?utf-8?B?OTRDS1pnZDlTOXBnWHZzT1hHVjhhRUtBUFFlRmJHWGhtQ2lKRUY0SG1PTVZN?=
 =?utf-8?B?d1lVWmRkZm1rS3pRd0RneFoycWFZbjQwWUhDYlN2RVEzMVhHaVRCWktCSmpt?=
 =?utf-8?B?V1FHQlYreTQ0SlF4cklZSmt4V1dPbmRPWHJNY09zeGs1U2t0ZnhzeUcwQkIz?=
 =?utf-8?B?bmJjdm5DS0lPSnplS1prTWlhK0VtaXhPMlgraE1jeE1HTktBNUFUS2U1VzV6?=
 =?utf-8?B?M3NxM3FhL1dwcUF4aGF4cnBXM09aNkkxb0E5NXRlVGRHUmFBY2RlQ0FhaW5U?=
 =?utf-8?B?cTJIWDR0TnYrU2RIVURVT25qRkZSdmtMZkl2Zm0rQnE3VWg0YUdtYmxaNHZ4?=
 =?utf-8?B?Y1p5MU1mYVhkY1NRa3RxRFJSWVE3M3BjVHdSRDhQNlNaU0ZOVEhlc1dtUHJI?=
 =?utf-8?B?SE9aV0JXMnpwQ2Q3ZStCTkIrdEpKSDdaYUFVbWk1eWR0SXRqNTZ0UXhMLy9v?=
 =?utf-8?B?ZkU5c0FyVjZERnQxekxLRVZzaThRVWFDK2pSNGVseCtFcVgxM2hzaUtpQ3hh?=
 =?utf-8?B?ekFxZWttanFaVXpwc2lJUU91cGJ3NG4weEpLK0p0aURKc0pwRjdETEQ2WHJx?=
 =?utf-8?B?SEczbVJ0T2FnK3BjY28zM0hUT3FpVlBZQVJhaWpxYmhsRGRSN0Uwdk0zNzlT?=
 =?utf-8?B?THl4NUtSaEMvRDV6M0QzcnJNMStuZ3BNY0V6QytFdEVOelBKeGpCTW4wOGFa?=
 =?utf-8?B?K2R3VkVxZUt5M291OElwMEZXT04vcGlrYjEwQVpWSUttL2dMaUI3RnpZdUJY?=
 =?utf-8?B?Yzc5OURUdSt3bzNuV3J5eFhIQ0lsaUVTQ0c1TGdiRHlpenhxYkxOcFpIaTJL?=
 =?utf-8?B?RXFla2FKcVBKZlBINXl6c2FYdHlkcjRMbndqT0UwdTNrZ2tjMktDRUpnQU44?=
 =?utf-8?B?L0loR2J6SlQ3bDdueWJqVXZ0QkovK3h5UXZRSWtHcTdUdklyV05JM1ZNMXVD?=
 =?utf-8?B?aWw3Y3E0SUdxT3dqMWVsdXpZdVZWdUxEUkkzczJFbElhLzRQZzlEVjhIR1o3?=
 =?utf-8?B?NUZKZTU1YWpVVEpuRXRBVlJRS2lkQ1JXSm1QVjRwU0ladlQ1ZzJ2KzVnazlt?=
 =?utf-8?B?eDRNVEdaL0ErYS9NUk42MHBzZmM5RWg5OWhBY0E5Zmp0Z2NvbWpiZWl2N0Vl?=
 =?utf-8?B?ZUhmL1BleHU0WjhzRkdTQkt6aGsvaTFqQVhVVWo3QVNPNFhNdW5ab2g0clla?=
 =?utf-8?B?M0hnT01tODVEMEltNElCSmFxTlA3a2c2VUdPdlp0UnVLbE5sTlR6K01yUkdH?=
 =?utf-8?B?eFRpTXY4Ujlwc2htdVRPcU0xQVZ6ZFNLOFRodW9kZnVjc1V3WlZIdU9BPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWM4Tzh3OEkxbG4wVjJVNFMwTlp6WHBVeGozUHJsam1aZHpEVjkzeEtEUmxM?=
 =?utf-8?B?Q3dKczJrcGM0NGYvcE1ObllZWnVoQUNRakFpeUFLVXVhNkthTW85bXFseFhp?=
 =?utf-8?B?ZWk5UzRVT2xSd05GTVdJZTFDOFcrQmcxbTN0dWUxUFQxdGgyMG96WXZoOEJC?=
 =?utf-8?B?UGZ5ckpRbzJWcG5acUNtbm9oL2tWS0ZBSGhNMCtMR3FiRCs0VjZOM2pxLzlU?=
 =?utf-8?B?Q0hKbFgySUE1NFIxamxmZk5sZXZZTUV0VWlKeVd3QXVFS1YzdERpa05mbGdD?=
 =?utf-8?B?djdrWWwybmRSaGU2K3R1bTdPUmVsTWc4cEtUa3I0aHEvTUU3eUVYVzZmQWI1?=
 =?utf-8?B?eHpDYmd2VG5lSEVsK2l2dW5vZU51WUphcGF2V0VyMS9RNlNrcDNIWCtLQWhL?=
 =?utf-8?B?eGZuWWRIZjNMdTh2dUFjYSs2VDY4cVIxa1ZRKyttUHFHRS9WVHRQSTF1UExD?=
 =?utf-8?B?TEQ4VGJsNVhYaW1BQy9mN3VvcFFDZWZ6VTJXemtJNVdnMlh2ZkVCOUNUbngv?=
 =?utf-8?B?RFZRODA5U01YMFdzZnRqMDdzNFNCSFVsNXRCeFpNMHlEMTV1NzhqQVR6MnZV?=
 =?utf-8?B?ZFJxWEU3YWtXSmV5citSVUZkMXIzZ28vNVNDb1pONEZpNTNNK3QzRlpOZmRZ?=
 =?utf-8?B?eDduMXhGYmkwaVNTTkV4VmpOdnU4aDltdEdrbldHaFRhMFdqd0JTQ3QxSlQw?=
 =?utf-8?B?RXc1bVA4NVVJclMzR0ovMGxQSXQ5VGNvbkhRVlNtVElWbit6Zi9BRjdqUDhY?=
 =?utf-8?B?MGRuYmxyVzI5cm1TZENzUFRGc1hYOVJoeHA0T0dRbDE4bC9yL1FFblVqL3B1?=
 =?utf-8?B?L2ZDNXJNSEJFVzBKazZLUE9nWEMwUXZwc3g5bjVPU0o1ajlRd3RCMHlmL2NU?=
 =?utf-8?B?ano5QmREbnJ3cXpoeUZNUGxhNGtjVFJnQVlLQUxsNGJZQzlhekpuZ05GNU5D?=
 =?utf-8?B?ZkpvUVlRWjhpWHdQNkkrbUh3S1dXaXEzYkNKdHkxWlNvTUd1SDNDS0JOMFUr?=
 =?utf-8?B?SkJ5VnRNb0xxaWZ0bHdYdjFETGpvVWFDcGVOOE41blB4RXZXRzdIb3lGL2J5?=
 =?utf-8?B?QjduTUk4aDhRNmNKU2Fwa0t3dEs1am5ISjE4cEhZaW0zMjNQOTF4WFVnUnpL?=
 =?utf-8?B?OU9CN3hxbzNmU1dleks1emx1cDZQTXEzM2lBY282TUR5VWVaTUYwRG1FNDMw?=
 =?utf-8?B?TDVqbXlOVmw2dndxaW8wbmlYTXRRNTI2bzhPa0JMYk9HdktXU1VsdktTdmkw?=
 =?utf-8?B?OGpOcFo0ZFY1a1oybHh2dXMvaS80eEpaZXNvT2lKSkVwSGlnNjIxVEdrVmlK?=
 =?utf-8?B?Z1BWY2wzOStIWXJlTlJGQ2lvTXI1c091UTNyQ0cvNUlPSHBkRWlMTDJSMzZO?=
 =?utf-8?B?RUI4UC9Fc2FPN1RlNnFvU3ozWU1rSTljUmhGeEtFMWNBMFc4cU5xK0RlM0p1?=
 =?utf-8?B?SXVtNEttZVZHdGMvUzRzME1GM2VXa3Mrd0ZmcjJNMHpWOTFUdk5LVzlQRy9t?=
 =?utf-8?B?blIwdXJxTlZicGVoWEZlRG5uT3BmYnFmak43WDd6K3dhS2JydWV2M1I4SlJH?=
 =?utf-8?B?V2tZS29qdjNmWXhMVWxkSk9Ob1c1MEdEcmxzdjdtaGZkWUNjY2sxMGl2N3JI?=
 =?utf-8?B?Zm5yeEF0ekxibHJmUk5QeDNSa09welpyRW5kbDNZbDdSWDdkWVZSblRMajVL?=
 =?utf-8?B?V0g3b21NbzR3SmQ1ckR4TVJJaUFRVnR4Y1BGNTNXVkRHMXdJVjdNeDhLUXo5?=
 =?utf-8?B?b2Y4Sk1JTFcxSHZoMEV0N3V6blQ2TVI0cmlyUWNtUEN6Nm5xS3NlSWNnMGM4?=
 =?utf-8?B?ZDV3aXB3bkFWQjNnTVJiOEdUSmRucEJsV0Y0TnpOZURYOFo2YkgrOHVWbGZK?=
 =?utf-8?B?d2xoZEMxVGJjcTZxWEt2VXIzVXRTTHJxQm1HeDVkQnQwYnRVM0FBWGh3SUJh?=
 =?utf-8?B?OFhaZG5VMTIxSUtaZ21qOWMwcjFUZGg0N216b1BXOHBLR1dFSE5wVXBTeit6?=
 =?utf-8?B?bEtVR045VWRGRWlNOVdlSUxad0tRby8yL2p3Q21QckpTYmhiVXk3V1Q0dlZ2?=
 =?utf-8?B?L2xKZnluMlNSRXhIbk5NcjZQQU1CYkNmQVV1aUZiUERWS09JVUR0S3BoMFcz?=
 =?utf-8?B?WTF6SmVGdFJTT0d5S05UbUpHS1RncXM1SmdUWm13Q0Z5dnJpVVlCUFM5WGU2?=
 =?utf-8?B?a0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a80dc507-88c0-42e5-30b8-08dc6dadb8fb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 09:20:08.3359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: odPhkNbcSmt6M5aydmnNkiBmYtcfaldKe0Z7WbLPwJaXo2oXnbTFg2yg9t2CQ3OTqJcFr8vnynkT4KqmNCvEBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7110
X-OriginatorOrg: intel.com

On 5/2/2024 7:19 AM, Sean Christopherson wrote:
> The shortlog is wrong, or perhaps just misleading.  This isn't "for event error_code
> delivery to L1", it's for event inject error code deliver for _L2_, i.e. from L1
> to L2.
>
> The shortlog should be something more like:
>
>   KVM: nVMX: Virtualize NO_HW_ERROR_CODE_CC for L1 event injection to L2

OK, will change it, thanks!



