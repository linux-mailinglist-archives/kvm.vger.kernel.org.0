Return-Path: <kvm+bounces-35341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 893EDA0FDD3
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 02:10:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DE4E18890AD
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 01:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79DE23F9C5;
	Tue, 14 Jan 2025 01:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jQWQcl03"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A1E35975
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 01:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736817048; cv=fail; b=QQ1GlFcB5XjAWmSrMW034d9IZN4+P1mrf3pDhXOKm5OZEI+JlIDGsONCV8q4Af7gdO+6q723vhPNVCHsh+9JcN2KMa8MXRxG/es64uG3xtjKBd58lZweQTAlH4foS3IoVO4h6vtD+OeGmZxlJGhvo9spWw/Odt3A2X1qAk2LS6s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736817048; c=relaxed/simple;
	bh=qA1WUHZjB2/JgRKyHbwVVx5JsdhQyjS9Q+RGOpH8B+M=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=X+nVEf52K/4SB3jZpnaOeKnQia3w3K9hG7+Noqs7a7KZmjk+xTWCFy38EzdccfWTF34koXikqUT2Cb+PwHGSRq2USgwBboPo4uTMc6JuxyITTFPYfDiVcPiu7pg0KGryK1K7dD4Kslx2gb9faPGQdnJZI5mbgLnt0TG7fgafeas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jQWQcl03; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736817047; x=1768353047;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qA1WUHZjB2/JgRKyHbwVVx5JsdhQyjS9Q+RGOpH8B+M=;
  b=jQWQcl03oGK3mHoCJtvf1tvzrz/Rn0VewoXOyngWscQHy09KfA7hwECK
   d1hoZq71ILTkfI5Bfln/KqkpW7q7JNhmo0Ts/0NSadKDkvx7ENlJ3oX9F
   QfJTuaf+hU7gsHYP+WuEma4uNPaI8HBp34ITyUS0yNrrIHXrlsdAH3672
   i2M9fbRQdbZzHIzhCkPMczm2gsn6SjeDim7JTGbAUHppyKDAJzPf7Paax
   dmW7Z0ajfP/UIOXI3EHmJ8znzuoIXOL8xkVN/4lFu30KQ8cEpP9zBjm7W
   1HVTTt6Tu1DA0fIWg6ipG6xta4US0L/3v309iRUtBSwNyF6Oq0VkolBRb
   A==;
X-CSE-ConnectionGUID: /VEGBZI6TVeJPj8WPq1RnA==
X-CSE-MsgGUID: v2QRdSoJS7qu6VzBpV5rXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="48481292"
X-IronPort-AV: E=Sophos;i="6.12,312,1728975600"; 
   d="scan'208";a="48481292"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 17:10:46 -0800
X-CSE-ConnectionGUID: wYjvjwtwTp6dwk7dHFAO0A==
X-CSE-MsgGUID: H8NZKv1nQ6yS0jn6X2HvUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="109669671"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Jan 2025 17:10:46 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 13 Jan 2025 17:10:45 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 13 Jan 2025 17:10:45 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 13 Jan 2025 17:10:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FwhMBqhliRVWs3CCMcGu4LM//itefY7L5tIbGukomhqLZhuI5MmsbEEngupeMqxdzNlPkto6kfPxg+YCHElHLNEVqa/O2TZsWWY3Py1rQBMqT77Ou5sK9v+xQVCtabGgo6zNXX2yBgJFrc9jyj36iAxjDdCX3pHYBkCVW0+XfdZ0ST5zLcaC4n5grZ32NvRGhmRMipCT3qxWn/nm3uEBY5KU5GM34mqaMtcTHdSjSOgS9RC2Lr5eRcBYZvjJ2COXNJa8rf2DNgCl2HbZhjPxmheu2cWuQ3ryvFHqQNmWOD+tjKvM4XVoI0dP/PFRxMqrsh8SfmMXiBp8P+B9Xttl2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJAUp9+cqmLW70SE1w2jI3z1IdYmbB3tsYZb2TAkAYk=;
 b=ETFqB4bC+e1PD8XG5+x/Nr14nnXbOIy00GFYX17yhiG3AMayvGCNF6SLn5+0IOpQ1ApWYABjIANpitUVNdlxWeVtiFjXr/FCfvGnUEhUJ50MSZVnpS1RKT3m4nEngjLeC3Ss1KEYgGTGb7RVYqOUJ+SH0Ne7tRjZumZo9H5QXfAFQgV7ZOauspFlnCcSiEsg71apXtIrYt81VcOJDFW5UEMeiLxaPoYFgyldIUSfD+s6NxY2ydJgQuVdTSd8sWcXjaPdNx/n/7oz37ymOd+1HjneKrUvrkVJw6GIOe4iVpLu+ciC5nUN4W95NLODvPDOhxHl3aOdsGZzBsiwfJzwgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH7PR11MB6698.namprd11.prod.outlook.com (2603:10b6:510:1ac::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.18; Tue, 14 Jan 2025 01:10:43 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%5]) with mapi id 15.20.8335.017; Tue, 14 Jan 2025
 01:10:43 +0000
Message-ID: <94763b5c-8e8a-4bff-92e0-66532ada7d5f@intel.com>
Date: Tue, 14 Jan 2025 09:10:34 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
To: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
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
 <9dfde186-e3af-40e3-b79f-ad4c71a4b911@redhat.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <9dfde186-e3af-40e3-b79f-ad4c71a4b911@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:3:17::29) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH7PR11MB6698:EE_
X-MS-Office365-Filtering-Correlation-Id: 70f72248-4cdf-4569-fd67-08dd34384474
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bW5TR3FPMlpkeGFjR0F2bU5EbXlLU0hSNE9vRWE4cU9KZjV0SXNKajFSdHl1?=
 =?utf-8?B?STVsMTdCc1FOdW9xaDdlUlYxdCs1SUcwNnZVY2crSTFhbk1rVnJ1QlVpS0tT?=
 =?utf-8?B?T0dDYVFQZkJ4SGdmMWZ6SXgrRzhsd0JiR0ZOTmRXNzhxVFhuNE8zSVBWZVhj?=
 =?utf-8?B?UTNXdXk0UFBvczJGbUYxd2dUREh5WkVqK3R5N1RtTXBTRnFnYURHSm4reE55?=
 =?utf-8?B?MkVnSDNTWXVqdlRWQnBFS2o1b3Q3ZE0vc2xEd1I3emJ6anFMR0VWTzd2YVNy?=
 =?utf-8?B?elEyR05VdDFQLzltZlZPUER0VnBXYUI4bG0zTnBZQUtqdmdNclBkdW5DWHVZ?=
 =?utf-8?B?NHpvVUVVYXk4RUpCMlBxUVk0U1U1cUM1WkZXNVRVYlJIRkltNEZaV2ovUW5V?=
 =?utf-8?B?aG9LWkFjdHRuL04zcUFyVlBrZEhaWTZOWFVtUDhhYjZFdEJ1cmZPQ0puQTRx?=
 =?utf-8?B?c2tVSjc4aWpldEdDc3k0QW10S2FEbUdsQ1YzL1VLeTdIa1NLNjR6M013bDNF?=
 =?utf-8?B?VmhSZUY3VVhWd1NWTktWYzhKVXNwczM5VFVwY0c2bmQ0TnZoOVNKNUZKSWd3?=
 =?utf-8?B?OUc0bUFrSERJNldtejdnVGY5Wk9Dd2xjTThWdmw5MXd1dWVHcTd5SmtsNkFW?=
 =?utf-8?B?WDZwZDBSQzlBYTE2bVBTRmFVT0dWWG5JM1o0azd5K1FvdGwxWS9kUWtHTStD?=
 =?utf-8?B?ckFTUGdsZXhhTytMU3BENkVCMG56SXh5UFFWbEtlN2NqSWtZdXBLUWdVNm9K?=
 =?utf-8?B?YUhQa0l5ZWxWdmhIL3RXSVJjeWl4cjV0UGVxZ2FTbFloOU1IRTJQQytiSGI2?=
 =?utf-8?B?ZnRiTEw1ZHVpdkJ4aGZCc2pZQTFEWFJRa3Qzb2Y0QU1yV3d4aWJvbkRjSkIw?=
 =?utf-8?B?WFBmbVVZZm5NK2lBcjI0Qk1abmRSZlp6cUFEa0luL1JYbmdILzZaaW1uTUp1?=
 =?utf-8?B?aFJzc1hpQzRsTzBrcmFOajk4eEYyNVpRbGNIcmo5bGx1MnZ3dUxSWjdXcmZk?=
 =?utf-8?B?S0g1YWZITXhSdnFmV0QyY0lBeHZwMVQ5VWJEb0xISlJ5ekF5eE5Kd2ZBTXRH?=
 =?utf-8?B?WnpyWHRkWnJZY05BMys4YU5kaVM2Z2kxZ0Q1TG5kalJIeE8yYzRaS05UOS9v?=
 =?utf-8?B?VWxzMVNFSTVNd1R6aTU0cjRYWm9yRVFxckY2SmdCZ0VVRmQ1TEt2QXBLYXdD?=
 =?utf-8?B?WVQ0QWhxRmh3RnZCelJHU2Fka3plcjZCUG8xbW5yc3dGK3p3VkNid1c5eDFL?=
 =?utf-8?B?RUQ0VU5vSkRWbjYzODRjak9tcTVOSXpBMDJGdGJ5eGRYV0FSenBUNCswdjRY?=
 =?utf-8?B?ZzBMVXNQaDhlUG9VRlBjcmlseEJCaFdrMEVlcjVKUlZOcUIwRUpkdTEzak5h?=
 =?utf-8?B?Tkhuay9mNEtDVHBRMGlHM0gzUXFuaUlVTjBsQ0hiektXM3JSREIxTWxrSzRa?=
 =?utf-8?B?VW11emkyNTB1ZkpKTE1sYjdKb0ZyM1ZVR2FjOEVWVzlaMEVyZ0R3UGZOdG1W?=
 =?utf-8?B?Zmo0UjVtZEVvODlEdUZIWmxGTzJubUxObUIyRDloTG5IZTJPc1hyWlZtK0tX?=
 =?utf-8?B?R05oUVFlM25OUkk5YW1oK3pMUFkxTHRjRGU3blp3cXNVcjZaZmhuV3RWY3I3?=
 =?utf-8?B?cjBDSStFUGNYVDE5dUxhaVZ4dnNrVHJadVpjMG96a2I1YnJlK2QrcHcvUXg2?=
 =?utf-8?B?VTRHV2ROSnEyRjBDY2xpQnFBTGVCVlphRXl0V1QyMHdtbzRKYnUvVEZkSXNL?=
 =?utf-8?B?K1RtSzNZcnR6V2IzM21HdWVSRExZMmY1ekxZMEo2L0d6c1AzK3VTZVhsZ3Ny?=
 =?utf-8?B?K21SNUZXVXRhRUNVK0V0dTNFV2ppLzg4RmUybWtpd1V6TG9UR0FUU2NEbzZY?=
 =?utf-8?Q?7hhpW+aytx0qI?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aDhsV2RXbEwrUjQyVVUvQUxDVHhlK1JjN0prNnZudmNtQ3VSNC9Pdkd6eXZw?=
 =?utf-8?B?WHpBV0l2SVVPdU9YS3JvcFp0SXhUYk5ISjBrOTJzYUZSOGtIajRxWkJPSlgx?=
 =?utf-8?B?VTZJdS92ejhOQjRvL0U3bGVIU0VUbE5BL3htc2RSU1JkYi9DRklpc1RVUGJB?=
 =?utf-8?B?alFyS1JHcTBKd2UvOElNalYxR0g1Y3RoOGYwTWdxM3dMM2szMEdlUmp3NUM1?=
 =?utf-8?B?V0loVFdNeWtLOHZXTGNFTU4rS1JJWU5ENm5LV3BlbWZLWGd2R1lveFdRc2R1?=
 =?utf-8?B?NkpHUXF3RU9FdTEyK2YxQllJU1lJcGlaTGtQWU1TTXlENDlDSW5JZGhRbWJs?=
 =?utf-8?B?eVBhRXN1OStjcVRqeU5JcmpaMnRMcno2aVFnYjNjWS9Id3BGdDE4cTViTy9R?=
 =?utf-8?B?bjNtR2ZQOUNuYUovOUFTYUl3aHJnMS9uTjNRZmtzT2RxcVFEQVZnZTVPL1Ez?=
 =?utf-8?B?amlqSW1vSENIVENxWURmeWNZV1ozTHFRMnpSQnN4cXV3bnk4YnZIWDRZc1hP?=
 =?utf-8?B?SnZsT2lGTHJyVnFDL2Y1L0lZekg0eU9YVW5BUGdBek9BbUg4MHhUSzBGbTIw?=
 =?utf-8?B?R0lsMlJYamxNWVhRMUFLQjliSGI2YXd0aXBXTzgxL1JLRXd0VXRXK1RYZ2hT?=
 =?utf-8?B?aFlML0VLQ2hHUjhhcmFtVVlOTjFsRlZoTkl0TXlSVlVsQXMyZUFXa1lUdFFx?=
 =?utf-8?B?b3NyUGt3TXJFNk9MUHNYaTVjUXZTMFprdE1lRmJEUnV5ZkRnY1B0TytoM3ZJ?=
 =?utf-8?B?RUtlaTVkd1lmam9TZ0F6bWNOUlN4ay9mVnhObWZucnQ1WjdYUEhpQVBvbnZS?=
 =?utf-8?B?bU1YWTJyeDliOUlOYzBlM2V5OTJwN2hCeWR1K0k1V0xKelFoNmtYb1hrS1Bi?=
 =?utf-8?B?VmkxRGVxcGhlVk9RQmpadVdXQnVTSnA2V0FQYldWZ04rd2VMVHdOTjEyMkE1?=
 =?utf-8?B?VDhSWGZMRm01MXh5S3RsUnMyYjBXNmQxeEJNb0ROSUdwNS8zR0M3MzlVVzJY?=
 =?utf-8?B?OE1pWlNxc3JMZ3ErUXVxKzBmU2sySXlmSk0vcXBSZzlST2lqYkN3LzU0d1dY?=
 =?utf-8?B?Q0MrMURvaTRjbXkwSTV5THBTYjY3S3BucEg2Nkp6UGlUbk1iOVRieWZDYmpo?=
 =?utf-8?B?OCtSM3JwSHQzZXVEN3VsMWlyQUZLM0ZCZGZMa0xBcEhWTDFMRmlXRHNiclpC?=
 =?utf-8?B?VTB6bS8zQ3lObFJFK2hFbXdyZmNHTDhGbmlBZGI1cEhaUVV1VnVySzY4TEo0?=
 =?utf-8?B?bmJBL0tkWnVycnJBK2dFUUh1bGNGZWhyU2x4dWdPeE5wdmhNRWhZcHNxT1gy?=
 =?utf-8?B?Yi9BSGk4L0xyWEVMNGhNNUVVcDVLU3NKb0EzOVp5T2RDZDZTZVJ5bFdlVG5C?=
 =?utf-8?B?V0dCejBydEtkUG90L2N5Z1ZZQmpRYkFnRkdUUFFWR2xpT2tnK1ZhTyt6L014?=
 =?utf-8?B?a1ZkRVBMMHNNUTMyUjNYZHIzdVhkWUFMbWl6U29aNklicHFibVIyQ1ZKSzVV?=
 =?utf-8?B?MWMzMnU0YVgvSytkcllsTHFnUE9xYXEydGs1NGU4aEVHYlpnblJ4TWJGM2s5?=
 =?utf-8?B?OWVRUGJEblJPRWRWWmtFTUdkeG5wb2NCTC9rTTlDWHIxNmQ2bTJraTFvcTdk?=
 =?utf-8?B?a3lqUWJ3Y0YvVVMwOExrR2JFeFhsOGJMT0ZaN1ZZWnRKMHZPS3dTZkFnVUYw?=
 =?utf-8?B?Z09QdVlEYi8xaWVkK3dtOE9BdVBUUlJIUlI3RThNaFoyQ2tHZFBvOHBqV2tx?=
 =?utf-8?B?M2c5ZzJJTk4yK3hHczZIaHBJL2o2VGlHT0tvZHZrTVV5MWVOTnpRcG55QURZ?=
 =?utf-8?B?QzAwOHJXdHBjU1U0UmhsYTdlS1FpQ2UyeldnTTZEOGhyakRZV1hSSlE0ekY1?=
 =?utf-8?B?T0FlQ2NZMVpIbmRYbHpEQ3c5ZkdpOFFZbERpL2lnTDJDN21odmtCMDBmbjhL?=
 =?utf-8?B?c2RVZ3QvTnhJZ3ZIK2RBQkx5UXJCZ0JIbk1CWEhlRzZIVkJQUnRCYXZZYXBU?=
 =?utf-8?B?eExFTkVqOHlwenN3OTgzRTdFQlhRZ01YUWlaQ1BEV2poZ295VE5TNWQvenBS?=
 =?utf-8?B?bzI2SmpYVFRMaExpVUdrRnJsQ0dzcnNvSkVLUVVDQTRTekdGME0wcy9KVHV3?=
 =?utf-8?B?S3Q3MUthSU5Mbk5iREY3cW4xeHhsS2Z4RXY1cDhjcUV0YWJyNmh0djlkRnpT?=
 =?utf-8?B?RFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 70f72248-4cdf-4569-fd67-08dd34384474
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2025 01:10:43.1739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lMW0pKS+ee4Y8TCuc8ZxTPab/x7PoCSCID1M4rFx2EPYIYUt/eX3LTvSN4ltYU65hVyQiFpiQplAoPL41vI9/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6698
X-OriginatorOrg: intel.com

Thanks David for your review!

On 1/13/2025 6:54 PM, David Hildenbrand wrote:
> On 08.01.25 11:56, Chenyi Qiang wrote:
>>
>>
>> On 1/8/2025 12:48 PM, Alexey Kardashevskiy wrote:
>>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>>> uncoordinated discard") highlighted, some subsystems like VFIO might
>>>> disable ram block discard. However, guest_memfd relies on the discard
>>>> operation to perform page conversion between private and shared memory.
>>>> This can lead to stale IOMMU mapping issue when assigning a hardware
>>>> device to a confidential VM via shared memory (unprotected memory
>>>> pages). Blocking shared page discard can solve this problem, but it
>>>> could cause guests to consume twice the memory with VFIO, which is not
>>>> acceptable in some cases. An alternative solution is to convey other
>>>> systems like VFIO to refresh its outdated IOMMU mappings.
>>>>
>>>> RamDiscardManager is an existing concept (used by virtio-mem) to adjust
>>>> VFIO mappings in relation to VM page assignment. Effectively page
>>>> conversion is similar to hot-removing a page in one mode and adding it
>>>> back in the other, so the similar work that needs to happen in response
>>>> to virtio-mem changes needs to happen for page conversion events.
>>>> Introduce the RamDiscardManager to guest_memfd to achieve it.
>>>>
>>>> However, guest_memfd is not an object so it cannot directly implement
>>>> the RamDiscardManager interface.
>>>>
>>>> One solution is to implement the interface in HostMemoryBackend. Any
>>>
>>> This sounds about right.
>>>
>>>> guest_memfd-backed host memory backend can register itself in the
>>>> target
>>>> MemoryRegion. However, this solution doesn't cover the scenario where a
>>>> guest_memfd MemoryRegion doesn't belong to the HostMemoryBackend, e.g.
>>>> the virtual BIOS MemoryRegion.
>>>
>>> What is this virtual BIOS MemoryRegion exactly? What does it look like
>>> in "info mtree -f"? Do we really want this memory to be DMAable?
>>
>> virtual BIOS shows in a separate region:
>>
>>   Root memory region: system
>>    0000000000000000-000000007fffffff (prio 0, ram): pc.ram KVM
>>    ...
>>    00000000ffc00000-00000000ffffffff (prio 0, ram): pc.bios KVM
>>    0000000100000000-000000017fffffff (prio 0, ram): pc.ram
>> @0000000080000000 KVM
>>
>> We also consider to implement the interface in HostMemoryBackend, but
>> maybe implement with guest_memfd region is more general. We don't know
>> if any DMAable memory would belong to HostMemoryBackend although at
>> present it is.
>>
>> If it is more appropriate to implement it with HostMemoryBackend, I can
>> change to this way.
> 
> Not sure that's the right place. Isn't it the (cc) machine that controls
> the state?
> 
> It's not really the memory backend, that's just the memory provider.

Yes, the cc machine defines the require_guest_memfd. And besides the
normal memory, there's also some other memory region requires the state
control. See in another thread, For example, private mmio may require
the state change notification but not belong to memory backend. So I
think it is still better to define a specific object to control the state.

> 


