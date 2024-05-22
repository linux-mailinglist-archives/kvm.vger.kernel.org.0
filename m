Return-Path: <kvm+bounces-18006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54DA98CC9FB
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 01:58:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08D7F283185
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 23:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 231AB14D28E;
	Wed, 22 May 2024 23:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P25M26iL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780742E631;
	Wed, 22 May 2024 23:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716422280; cv=fail; b=VaSfInObjfr4IEIl/l6OLtMl85vqrR3P0IpOIGDqmO2GJwvcLt2AR37I9N/yxKydo4Or26ARBzB+OEgNFWQXaJAA8EHZOaHfx829c/jl9vS7u9RwkmhqLvjic2OEaYUW0o43bf4re6S/DSqwR0q5IwTlrtbVcv1pNvTTQ/mEanU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716422280; c=relaxed/simple;
	bh=eQ2LH/jdSPL2tdBOeaW7XCWDkOHvF5oz5iCIMIFqSRY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M9gNRXpjNgs0NKg+vLndnP0IEANB90XhNu6lWAh0bLPfKyEZRkdwYjYjFEaJ+/cpjScsvL8zBlAKJl28V0rjVf1kg3gOOZGXPDUlpjfhFGRtrab29b5LGeIZjEfvlBMH0/L0JBRc3+WljyfPU7aarA02zlsNqsmYcuHLzH6EqoU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P25M26iL; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716422278; x=1747958278;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eQ2LH/jdSPL2tdBOeaW7XCWDkOHvF5oz5iCIMIFqSRY=;
  b=P25M26iL82k5wGcaZIMtG4lDvjOS4dbloqVECnUU0JwVyVEoSsar0HXl
   jrSHDx+K1letaympH/t+RMR/NjeDK69ZydlFP5bm6eNiPSSVjokrVVdES
   MVN2wOfkqXY1aKL3C2TPWQ/TshzXe67AyKuFkq7QE1fOY9O+y9WKAqK87
   viEoy/GF7o2Y9TPUYLUXezuhGsbTwf81AxCY33EicxGH5VZ2OXzOHaAmg
   HtsclsPg1E1jEZ7MAUynmS0P66hbB9u13YAIm2at387P1lU1tKkLRanzr
   r/IWpSFceY0FqktF6ea9cMH1XHtxf84XuJP0fW6TXgBfvM2tSYm9/7Kui
   w==;
X-CSE-ConnectionGUID: pW3IrLFmSX6TiZPqMaqRkA==
X-CSE-MsgGUID: MenzcrAZRBW1ToCTdTkefg==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="16549983"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="16549983"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 16:57:57 -0700
X-CSE-ConnectionGUID: ZGsRQusuTV+r+juZKtDUMA==
X-CSE-MsgGUID: v0sM9J/zTzi/VWQsG69Yrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="33308014"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 16:57:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 16:57:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 16:57:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 16:57:56 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 16:57:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbmME33n9c+MbTgIMg7ABUnSnm1lFPa3Iy172DoxL+M9lxBvTKjIdEspsTsyM12gk3qzNBq/M7YZm9rfEJtqU6k2UA6NiJ/yQ9lqmxImqoVmU/B0sUpqhGDlwlMyLdmLFQ9lF3Mn9A8d36+agqk9eBQLNdgfVtymixs3mbmPwugxcms82EKKbINm/c+ctSziMKrHXD19h0WV68TMAFXV8bywHTR2mFS68p31jowMHpzwWvQXoCAG8tZXVczU2HKRG8Rrn27y+i8/8Xpsoh+4CJ6MvyjqjbpHABj5a/vNup9LuhdC74q9wddjy2fEkq9feHvwW9r1XTzorGkWu8NX5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=95uNufamXq1WU0LR/EOKPZXEMbiNUE/XohAsNA2EnaU=;
 b=C8Mf6oJdx4Gp9eZfMRsBX1riE+EzU29eIY/8Nj9LaHa/HwKcJIAFCyIFA9REHVOapntEs5qxBeWDrJHOwje9LcizaGG6sDNfBpUcrSjs/WGohP3PFZw4nyBBn2TKCBZXFqsNIW3oC+XbhR9BHHuATkR6aoCRc4dCpStW5wYzNpItgEGaQDM3cH94iE91G5v190+Bzl3+PBH4IFx4oD06vkQ4Eq7GJBdfbZBlophRU0uiRiVMYo+iuZJRlpavMwPvSG0CS+55TM6yS6o6voxd5wE7jw+ySdYV7J5Z4CZpJOngLvFQj4JG96djkCgSzpXtqL/gV6Cj82/EKAzPd939TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2535.namprd11.prod.outlook.com (2603:10b6:a02:be::32)
 by DS7PR11MB6016.namprd11.prod.outlook.com (2603:10b6:8:75::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Wed, 22 May
 2024 23:57:55 +0000
Received: from BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7]) by BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7%5]) with mapi id 15.20.7587.035; Wed, 22 May 2024
 23:57:55 +0000
Message-ID: <25d190b1-a8a4-49ae-a52c-207837a93fbc@intel.com>
Date: Wed, 22 May 2024 16:57:52 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] vfio/pci: Support 8-byte PCI loads and stores
To: Gerd Bayer <gbayer@linux.ibm.com>, Alex Williamson
	<alex.williamson@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Niklas Schnelle
	<schnelle@linux.ibm.com>
CC: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>, Ankit Agrawal
	<ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, Halil Pasic
	<pasic@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>, Ben Segal
	<bpsegal@us.ibm.com>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
 <20240425165604.899447-3-gbayer@linux.ibm.com>
 <d29a8b0d-37e6-4d87-9993-f195a5b7666c@intel.com>
 <72da2e56f6e71be4f485245688c8b935d9c3fa18.camel@linux.ibm.com>
Content-Language: en-US
From: Ramesh Thomas <ramesh.thomas@intel.com>
In-Reply-To: <72da2e56f6e71be4f485245688c8b935d9c3fa18.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0055.namprd07.prod.outlook.com
 (2603:10b6:a03:60::32) To BYAPR11MB2535.namprd11.prod.outlook.com
 (2603:10b6:a02:be::32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2535:EE_|DS7PR11MB6016:EE_
X-MS-Office365-Filtering-Correlation-Id: bec2dfb4-7ff1-4727-2009-08dc7abaff96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015|7416005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cmhHTDUrekNud2VkYUVaYVpYRzZiWVRTNTV2Zlg3OWpWMTRDdjlvV2cwaGt6?=
 =?utf-8?B?NkdHSGdhNGlnZGNxbmRrT1AwMm9YV0FLZHpMV1liSUFNbnZBUC8zUHZMVFFi?=
 =?utf-8?B?SDdEQmxVd3FteER6THM1MkdJY3dWQ0hFSjk5dVNLMlJ5WFBuK0h3Q1l4UVZ6?=
 =?utf-8?B?d28wSTlBTzNxSWRYRGlweXBnOXltZVF0L1k2cVpUOTQ5V3htNTgwUnhuTVRj?=
 =?utf-8?B?RXNWcERaQTBram5vQjNpMFdNU3IvZWFtZEVhaWIxZXBvN0czMVFpU2UwNHY5?=
 =?utf-8?B?Z05xZ1FyQzFRNzNJQTZHNDF1NUJVa1lIemZLam9oYk1PdThVNERhLzdzRkZ6?=
 =?utf-8?B?dmd2OWJoMEg4ZWhKZys1dXBPRkhmZ25qMUdtMVlzY0liL1MwSG5JVFRhL0ps?=
 =?utf-8?B?MG5BZmVuRmh5VnJpbUMyT0lFWG0xRFRHSFE1dnZuREk1L2RBbWxyK01YMkNt?=
 =?utf-8?B?TXdFd0o0ZFN6Rnl3ejYwWFQwVFd1MGFuRW1YY1AwQmJhRnh0RDdmREljV2NU?=
 =?utf-8?B?RE5CUUVUYXpJM0g4a3FEQXQrMUZRZU9Za1hUTW9xeFJxU2tLMnM5N2llYUph?=
 =?utf-8?B?R2FXYUhIZjZHc2VuM0hURjJ4S2MrTjNwVTZNUTlqL3UySWpGZkhmVnlBWnVx?=
 =?utf-8?B?eXd5c3hkK0NiMWRaVjlROC92eGRFNlpMTHJUL1lPZHp3ZkdzL0R4WDBwWVo3?=
 =?utf-8?B?YUo1bGJ2aStTRFBMeTZNMGRRWlhzbGFLRisxVXNab0JlYmcyRFNuYzdGemI0?=
 =?utf-8?B?YnJMUWJ3OU5JVlV2RzJYNDVTMzROK1g5L3c4ZUV2OU5aTEhNbzFpd0dVcDh1?=
 =?utf-8?B?MmtQTWFEVVgzakdYenVLdkRCOVZFZWNlbUJSMWVlUzA4QXRJc3FZYUtVUm44?=
 =?utf-8?B?ZnBCd0x5dC9rSndEZmJFeVJFS3hlOVZ3MmluWnhXL0NYZmxYamxnR1RjdDdK?=
 =?utf-8?B?V0ZBWFQ0djVkczYwVmZpTy85K0VTU1JDQXlMYlBRZDByTk9aQy9UYzNyVkx2?=
 =?utf-8?B?V0FiVnc2alJ1cU4wU0dRNnVrVm5ha3E1dDBodTZMcElkR0J6cXRLWitGQVFW?=
 =?utf-8?B?eGY0Q1p1b3pNd01pb25TNlVnTmhXbU1zOXd1V28vcDdGcm1DN0NHL3U4cnVh?=
 =?utf-8?B?aFJNRGhtL2JUaWdrb0owRVVIZmEzSThGQzNrb3FjVnpoazBDMEJVMjZUL2xP?=
 =?utf-8?B?MzlvTnR0L1ZvbnI2Tm9NQ00xZTJLOFB6NGtXRThNWTJRVXUwQmdpd1RqK1ov?=
 =?utf-8?B?NzQ4eXRxQ1AxUG1nWnJ0a3R5cmFRTlEvQkZqaHJGdklqem1PRHhnUlJqNjky?=
 =?utf-8?B?Zk5ETnRsSWtWU0ZhY3Z6V0lEdWgwbjk0ckxqaTBTWDNsNU5TbDJaMGxiNWRQ?=
 =?utf-8?B?TUlEcDFzcGYvcXdNOXBzVVlxVXNSL0x5eFVOV3JFZjVFc2xETFc1TEpyaDBq?=
 =?utf-8?B?Y1JlTjNJeDhnYXBSUEQzN1JudEp3UWVNMDNPZDhjMlRMNEhkNWFHd1FxQmRO?=
 =?utf-8?B?SFc0VHA1NzY2eCt3UThjb0tTQzc0cjVvNHFWYVY4Nk14REU0eCtQSVVLenZn?=
 =?utf-8?B?VlhrWlZOTzUvb2lxNTdFYVNwOHpJWVhNSXRLZTZVN1p5Z3kyeUpXcm0zakZC?=
 =?utf-8?B?VzluQUxiL0JZbk9wSTNhRXVDVzBpNVBXV2oycXArdU5od1pQYTBlUHFBQVJ5?=
 =?utf-8?B?L29OUWpRamZQKzlIRnQyOVhSR3BvV1hYcGN6TFpwaXRVeG4wWTVUQVdnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2535.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDl1eGhZUkhxWTVIQnI2dHVRa2pPSytiNjFraXFtYW5YSXExN1RsNmszZHor?=
 =?utf-8?B?WXRMY09HbUhHN0ZaQVNqNzlrak9TUlowMDYxaExrWXdFNEZzT3Jxb2c3Q200?=
 =?utf-8?B?OS90eVA2aEpzbHZ4UG94c1lHNENKTHpvQmU5cG1IN2JNbTUxcC9pV3BYb2R1?=
 =?utf-8?B?TCsxL0pQRlozWC93M0cvTERoTjZnSnlnQjZXcWVCUVAvTExUSHNpSWhiaVYx?=
 =?utf-8?B?L01pSDZURjRXemovZ2VlU1JnMzN6YWhIVnE3elU2dFg2YWdHSm5oRnptL1Vk?=
 =?utf-8?B?bDE3d0RMMUxROFZueUxmaHdONHNaSlh0Z1VzdGd2bFhSWnI3Z2JyMStuVEdL?=
 =?utf-8?B?b0pEWStqUXRDd0FZOWpuV2JqYktSZmgrMERNYmRPdmo5Rzc5ZDdBeHhVNThw?=
 =?utf-8?B?UDhIUXgyZGVSblFvaFlzYnhOOS9vNmtHWE1ha1dMaTNSL1dQM2IxQXRFek9M?=
 =?utf-8?B?ajB5RjBVei92SlhQL2JqTExpWjVsUVhQWDZLdnhpVFBrTTlkd2RjVWxDeFFn?=
 =?utf-8?B?UXBaMSszWjZDLzZvdHp3YVc2bS9JVkRKK0M5dlE0T2NuYUFTUlVVRnJvaU5r?=
 =?utf-8?B?end5L21MV2ExNEEraEpveGtvQW9ZTHNpOVlLTHVpZC9mM1JOTHhJN1FxTmU3?=
 =?utf-8?B?ejlCNm9tTTVKc2FNVVMzRFV6ZDF1bDB4WEMxUzErODREak9YRExVZ2JvSSsx?=
 =?utf-8?B?WUxlMXVaVlFMNWxKd2pEcFliSkorK0wrc00xVUlZT0lJU1UyQmV5MnozUitU?=
 =?utf-8?B?YUFnMHh1V2tWeVJoc1JYKzI4RzZldGNmbW9IU3RTRXhhVDREVnVZUnVVOUtu?=
 =?utf-8?B?dm5nWXE1MENnNnh0ZkJjVjk1cmJyM212Z1Y5WmV6NWlRNmp0eW9ZcjBuVkpa?=
 =?utf-8?B?UjJUL2g0NWxINVI2VXhDS1AveHlNeTdSUnJCWE5HTldGOUNvR241cmVIN1Ns?=
 =?utf-8?B?MXFVT0YxTjgrQjJRdDNIbDlvWkx3aFZ4NXAzL09iNXQvN0x0QkFXWkhVYktk?=
 =?utf-8?B?c09EM0lvUWJxdVEwSGVMMTFrdTJpWGdlczlIWGFraFJyY3hGbS9RZ2pXOGND?=
 =?utf-8?B?dVVpenRZZ0E4MkZmOGVZQVhpVllsZjR1c1dOSFNxNnhIeWRqZm1KQ202THdT?=
 =?utf-8?B?aFNveko2VjZacXRXTnU0VmtLbDZCYkJGU3FqemJGVERQR1ZFaFErdHVMQTZj?=
 =?utf-8?B?VmZiNGVOTlRhT2syOGF1MzMvaUQwdXV4RFhHd1E2MFlJTzQ1TTY2S3NrQVhL?=
 =?utf-8?B?VERscUt3Yk5WMDJGbmhMVHAyL1BLZGR4WE1tcnRibU5ob1lySlZCanRHbk4v?=
 =?utf-8?B?aEtoUzgrUFpMd0Q2S242a1duazR1NzA0MUU3b25GelIzcDlPREFsZGs2Nitn?=
 =?utf-8?B?bzRjYWQ1Y1FxRnNYZW5aOExqQjAvN2J6cjBCaUdxK2VRS2dDZVlsTG96WS9R?=
 =?utf-8?B?VEM5dEMycWdiQUFSLzdobkpyYnowaWhHcnBOMDNXN01nYlNHT3VuaUg1RVdr?=
 =?utf-8?B?cEFubVpBKzZxazQ1a211VHhzb3gxK1VNT0VRY2RrKzJRdnB4ek1Zd3BYQ1dV?=
 =?utf-8?B?TkN2NWcrQlh6RVlvK05BUGJXS0ZFVVozeEU2L3ZPaHZnUzE4dDhzODc4UVBy?=
 =?utf-8?B?NEJPWkY1ZWxsNnFTU0YrUEN1UitwSFRDcEpubWJ1b2wzaFRVajM1QkN6d2Zx?=
 =?utf-8?B?Tk9yNjlVSm0vMWc4eVZ5Y0k3Z3pabFRMdkE4V1UrMDdxNkQ5MFhmU0txekly?=
 =?utf-8?B?QzdhZFk2VEhYVXY4SDNFSUIvQnNGVllzZ3pVcmJQd0tUdUxaZUdHNW1qdzZE?=
 =?utf-8?B?Q3ZDWkVRbjJ2NEU0WEtncW5DODlWM1VzdmhieU1EbGltajBrSEZRRXZ2eVBH?=
 =?utf-8?B?VVNKRVZQc2s5QjB4eHdMcGc0NTBZdGlUbjR3TlE2UXVnNVpXV1Rtcm9WL1dQ?=
 =?utf-8?B?VDMzb1o3eTM5TGxXemRRTXM2cXovbHkzejYvRDh3QzdzQmorbllrT0dwNExB?=
 =?utf-8?B?WElrVVlGb2NWQVh3YjNSc1Zob3dGVytWSmxLaDFObkhJck1vS0RQSzRHZnAy?=
 =?utf-8?B?eUxoOG14RE9HUUVKamw3aTBjdFh1STIxMUZYVWt2T2c0RE5GYmlmc09DSm5N?=
 =?utf-8?Q?jHwPqJNexpAfsS2xipr+u9kE7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bec2dfb4-7ff1-4727-2009-08dc7abaff96
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2535.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 23:57:55.0900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f+qrS/H4m3QMrPgfUTDIXt+RYq8l2LxZ9rdnJxPdccvH0Hp/yHGmd7rP5thPRsEj+Ac675aw+zeC5yId6b/t8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6016
X-OriginatorOrg: intel.com

On 5/21/2024 9:40 AM, Gerd Bayer wrote:
> On Fri, 2024-05-17 at 03:29 -0700, Ramesh Thomas wrote:
>> On 4/25/2024 9:56 AM, Gerd Bayer wrote:
>>> From: Ben Segal <bpsegal@us.ibm.com>
>>>
>>> Many PCI adapters can benefit or even require full 64bit read
>>> and write access to their registers. In order to enable work on
>>> user-space drivers for these devices add two new variations
>>> vfio_pci_core_io{read|write}64 of the existing access methods
>>> when the architecture supports 64-bit ioreads and iowrites.
>>
>> This is indeed necessary as back to back 32 bit may not be optimal in
>> some devices.
>>
>>>
>>> Signed-off-by: Ben Segal <bpsegal@us.ibm.com>
>>> Co-developed-by: Gerd Bayer <gbayer@linux.ibm.com>
>>> Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
>>> ---
>>>    drivers/vfio/pci/vfio_pci_rdwr.c | 16 ++++++++++++++++
>>>    include/linux/vfio_pci_core.h    |  3 +++
>>>    2 files changed, 19 insertions(+)
>>>
>>> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c
>>> b/drivers/vfio/pci/vfio_pci_rdwr.c
>>> index 3335f1b868b1..8ed06edaee23 100644
>>> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
>>> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
>>> @@ -89,6 +89,9 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_ioread##size);
>>>    VFIO_IOREAD(8)
>>>    VFIO_IOREAD(16)
>>>    VFIO_IOREAD(32)
>>> +#ifdef ioread64
>>> +VFIO_IOREAD(64)
>>> +#endif
>>>    
>>>    #define
>>> VFIO_IORDWR(size)						\
>>>    static int vfio_pci_core_iordwr##size(struct vfio_pci_core_device
>>> *vdev,\
>>> @@ -124,6 +127,10 @@ static int vfio_pci_core_iordwr##size(struct
>>> vfio_pci_core_device *vdev,\
>>>    VFIO_IORDWR(8)
>>>    VFIO_IORDWR(16)
>>>    VFIO_IORDWR(32)
>>> +#if defined(ioread64) && defined(iowrite64)
>>> +VFIO_IORDWR(64)
>>> +#endif
>>> +
>>>    /*
>>>     * Read or write from an __iomem region (MMIO or I/O port) with
>>> an excluded
>>>     * range which is inaccessible.  The excluded range drops writes
>>> and fills
>>> @@ -148,6 +155,15 @@ ssize_t vfio_pci_core_do_io_rw(struct
>>> vfio_pci_core_device *vdev, bool test_mem,
>>>    		else
>>>    			fillable = 0;
>>>    
>>> +#if defined(ioread64) && defined(iowrite64)
>>
>> Can we check for #ifdef CONFIG_64BIT instead? In x86, ioread64 and
>> iowrite64 get declared as extern functions if CONFIG_GENERIC_IOMAP is
>> defined and this check always fails. In include/asm-generic/io.h,
>> asm-generic/iomap.h gets included which declares them as extern
>> functions.
> 
> I thinks that should be possible - since ioread64/iowrite64 depend on
> CONFIG_64BIT themselves.
> 
>> One more thing to consider io-64-nonatomic-hi-lo.h and
>> io-64-nonatomic-lo-hi.h, if included would define it as a macro that
>> calls a function that rw 32 bits back to back.
> 
> Even today, vfio_pci_core_do_io_rw() makes no guarantees to its users
> that register accesses will be done in the granularity they've thought
> to use. The vfs layer may coalesce the accesses and this code will then
> read/write the largest naturally aligned chunks. I've witnessed in my
> testing that one device driver was doing 8-byte writes through the 8-
> byte capable vfio layer all of a sudden when run in a KVM guest.
> 
> So higher-level code needs to consider how to split register accesses
> appropriately to get the intended side-effects. Thus, I'd rather stay
> away from splitting 64bit accesses into two 32bit accesses - and decide
> if high or low order values should be written first.

Sorry, I was not clear. The main reason to include 
io-64-nonatomic-hi-lo.h or io-64-nonatomic-lo-hi.h is to get the 
iowrite64 and ioread64 macros defined mapping to functions that 
implement them. They define and map them to generic functions in 
lib/iomap.c The 64 bit rw functions (readq/writeq) get called if 
present. If any architecture has not implemented them, then it maps them 
to functions that do 32 bit back to back.

> 
> 
>>> +		if (fillable >= 8 && !(off % 8)) {
>>> +			ret = vfio_pci_core_iordwr64(vdev,
>>> iswrite, test_mem,
>>> +						     io, buf, off,
>>> &filled);
>>> +			if (ret)
>>> +				return ret;
>>> +
>>> +		} else
>>> +#endif /* defined(ioread64) && defined(iowrite64) */
>>>    		if (fillable >= 4 && !(off % 4)) {
>>>    			ret = vfio_pci_core_iordwr32(vdev,
>>> iswrite, test_mem,
>>>    						     io, buf, off,
>>> &filled);
>>> diff --git a/include/linux/vfio_pci_core.h
>>> b/include/linux/vfio_pci_core.h
>>> index a2c8b8bba711..f4cf5fd2350c 100644
>>> --- a/include/linux/vfio_pci_core.h
>>> +++ b/include/linux/vfio_pci_core.h
>>> @@ -157,5 +157,8 @@ int vfio_pci_core_ioread##size(struct
>>> vfio_pci_core_device *vdev,	\
>>>    VFIO_IOREAD_DECLATION(8)
>>>    VFIO_IOREAD_DECLATION(16)
>>>    VFIO_IOREAD_DECLATION(32)
>>> +#ifdef ioread64
>>> +VFIO_IOREAD_DECLATION(64)
>> nit: This macro is referenced only in this file. Can the typo be
>> corrected (_DECLARATION)?
> 
> Sure thanks for pointing this out!
> I'll single this editorial change out into a separate patch of the
> series, though.
> 
>>
>>> +#endif
>>>    
>>>    #endif /* VFIO_PCI_CORE_H */
>>
>>
> 
> Thanks, Gerd


