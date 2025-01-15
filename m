Return-Path: <kvm+bounces-35489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BA0DA11653
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 02:03:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D20C17A2140
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 01:03:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06286224CC;
	Wed, 15 Jan 2025 01:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oGYXamMu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C163D76
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 01:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736903006; cv=fail; b=oL9qgu8IcRXncO4nkAsLK0jIoUrk7Oh/w3FZsDd9fnztrRGfEhp3TLZluyvv/c7APVcS6SuBQdZxnenzr25v+xquSdQwbm+Df8n4iKH+kP7lBnsP52J15+FTH+fAHDhO5IgUpHTdlNfbyBLril6TJLSW97dB7mqUBwZVkXqnIMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736903006; c=relaxed/simple;
	bh=yzK6streLfUcAzU9AUe+/HsLbAdwfkVR5vG55Hi+kLs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dxcrthfCaf+yCnp2QRgKpkLKCTgmh+gh69krK8u5R43ny2CYODN5ZGAFl1k2ZvFkL9xHMD1EsWnVUToHhSmPovpmXGy2mYoS55nDmV3nOlP9nMjEsWUFWdZRjy1A0Pn+Sh5QkzqXlAbB4mL+kMvoe8iKspab3TPmX6dFWMp8uMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oGYXamMu; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736903004; x=1768439004;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yzK6streLfUcAzU9AUe+/HsLbAdwfkVR5vG55Hi+kLs=;
  b=oGYXamMum9gVCy7lW9it+kjI7QZT/F/UI8feM4pQdsPs3j258PQcdkci
   iLr3vnnrxV7pSEn6HhaWvnaTnz5hnVh2Gf9CC4K0IayW3md1Y8F9b/E4Z
   uGsJTcwzc6hdijRk7rKNl0ozuUR3WCwqwIGm/7lYxBkZERoSNjw/PrxX/
   +FVP/tXTHA9ekuMPpJVpXxwJ7z6P4Dl1PUsjv3tJKi+R+bFlhQqA0IPpd
   4oY8DnW5W3c3RrcwCV8MWiilN/Bab1vce9Gv99aBr9ZpjZEbw9jYM8Bb3
   0FAYHoZ+5tKop4bYfPAFZH8W3PpfX7zwGOCw1JvLXrsKXFKMt+rWL9KcM
   w==;
X-CSE-ConnectionGUID: vD5XQq2IQXqJhudrfFEroA==
X-CSE-MsgGUID: TSE66hfnSiCAaCYKU4ULCw==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="40033664"
X-IronPort-AV: E=Sophos;i="6.12,315,1728975600"; 
   d="scan'208";a="40033664"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 17:03:24 -0800
X-CSE-ConnectionGUID: lW8HTIxvRpKaCFSNHhq5ng==
X-CSE-MsgGUID: PG6DJvWMSOWNizSbkQd2Ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="104843571"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jan 2025 17:03:23 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 14 Jan 2025 17:03:23 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 14 Jan 2025 17:03:23 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 14 Jan 2025 17:03:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HZlMH2TaQg60zIBXNQB4CKhn4Rj5eVMch6lf+UQ2ipZSAySe8t2e0sD+4ENDxnK2qurr52qPSnuWiZBThwxEoen/oVjaP43xzmzeT178d+yIeMbmkzeYvp5o7VZ6qcJRFA8eJAFdd4iO6Ii/38OydAzXQ+zOMwxpfNRYQDRz3aRfDt55ocTM7+biWKVeV2BYqLDIQYyBzu8IXheNe50gCXxXkKRt9uTq+qKjZ1JZcXfqDnfSEoDA39cKPnzYdm0ZB0afGIsuYKAGzm4se463QPRrVl7xr/O6QGOXqAsGQswT1Z9nvRonUgfSlqq28DNZEM8fRw39Ks4ZYQWtM0ZeZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bp5Vs+TLHOLC7GXgn1Gqv/j3IQhbXVGtSMtbkzFNPiE=;
 b=Ne2FLK1wMLtL4mzno9PgNOVKuyx61BAzGiB6w45wn84zVT5pCredn0s5B2/Y2ov5oxVE1Ule3XjujZWW4uBkPB/wGyE/3m2k5bYpDTQqouPzg8U5zRced+hyXgG4LCpDZrFYHwz65kpG+E4lhJ03YWNhRrQtRBnR7ylJwr5x4fqlaSQxn1cKK/3gXuwQ5vhFZ5BBW2azTCNCUThWh2KbBCGML977HT2nFU/DecWIEcR7aknhRryzVaK1oPYDmrPwGTTOw+9yhSBeNqDw/wHejkQMkevGSnQwqvoICTDcGOhby+F7DtvsWs7tHc9vk3jAfepiRASbG4LddK0B6e26Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA0PR11MB4733.namprd11.prod.outlook.com (2603:10b6:806:9a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Wed, 15 Jan
 2025 01:03:07 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8335.011; Wed, 15 Jan 2025
 01:03:07 +0000
Message-ID: <5d8d20da-8d08-4d8f-bd41-6cd4ebb62600@intel.com>
Date: Wed, 15 Jan 2025 09:08:22 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/5] vfio-pci support pasid attach/detach
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <zhenzhong.duan@intel.com>,
	<willy@infradead.org>, <zhangfei.gao@linaro.org>, <vasant.hegde@amd.com>
References: <20241219133534.16422-1-yi.l.liu@intel.com>
 <20250114140047.GK26854@ziepe.ca>
 <3428d2b7-8f91-43ed-8c8a-08358850cc66@intel.com>
 <20250115005503.GP26854@ziepe.ca>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20250115005503.GP26854@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0175.apcprd04.prod.outlook.com
 (2603:1096:4:14::13) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA0PR11MB4733:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fac9546-cdee-45a4-dddb-08dd35005eee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RDZKcEFGbXR1UDlYV0tsY2QvMEkwVG1lajU4UFlpejB1V2syNTl2TW1ldHlT?=
 =?utf-8?B?NW5JU1dielYxWGU5dzAxQzF1V3pCRWo0eHltRitzd1Q4T3FnL0RVUEV3a08w?=
 =?utf-8?B?UVZIQll2dUpPL25FaUdSeUs0RDJrL0M5UU5YUngvMGUvZkVCeEZpa3lOUTVV?=
 =?utf-8?B?UmdpYkZubU1CVGZMSXNHcGJpNkpZUFBSdy9EQUI1eHFBUDZvYXR6TGxETE05?=
 =?utf-8?B?UFRGNW8yTlVMUGpuODIvQ3BTZ2gzcVRtWDZGd3hoTW9KZjdVRjR0RmtjMktG?=
 =?utf-8?B?VDBNWEVkdjRmYmYxT01VSmRJQ1djblJBd1dBZjk0NldFNlBpZG1rbEJyV1RG?=
 =?utf-8?B?bWxFOThPcXMrc1h6cndybmJoZ2tuZDhsNFVYcEZOR3RuVGQrei9SRVg4ekd2?=
 =?utf-8?B?NEJmUm5sUnhESEJra2lTOWZXdUxvbitxaCtYYkdJQWRyNUh4Yk1FbCtGSzNX?=
 =?utf-8?B?YWV0ZWliejdVY0JKUy93RmVYTGxQTk9oMWoxdkZoV29sMlR1SS9NWUxDRGhM?=
 =?utf-8?B?U2U3dlBTVjl4WTNUc1RHL001Uk53bTRzWFVWT2xuMlpydVFZRTFjTENFcFds?=
 =?utf-8?B?TklQaTlnOE45RU56Z2JsUEkwR1UybGdFRkk4VWxGTUFnNFY1eWV2MERLUnNX?=
 =?utf-8?B?cFNSTUZrK3VwUWJuQWNuZFl6VktlVnlKUE1veWxPRkE4SjdIOXgxc0h2YnAy?=
 =?utf-8?B?RFZ5Qm1ObkxmcGJDTnRsU2J3VFREa29ZWmtNUDJBcG1VaDRSRTh0WGVHREFx?=
 =?utf-8?B?ZFVZRTBpWkNDeWdZSWNKZGFLRWowOGN5SHZHRGRob3NjSGxXOWY2S0JHQnJI?=
 =?utf-8?B?RHFNRDg1dGJzdC9tUGlCYjA5Z1pvWEZQenZYV25UYmczS21uSmRGYmNFV2Nq?=
 =?utf-8?B?TE9Ib1E5ZmZDMEpnYXp5N3pLMFQzaDduc0FqbkVsRFdCSXZQK1VNYS91OTU5?=
 =?utf-8?B?MVc2c2x0VGk0Rjd1Q0VuREYxeDBPK0RuQ2VnaXpTalFIbXhhWFJkdzNCc0E1?=
 =?utf-8?B?QlI3UUNaZ0diNllFcG5iOGM3em1OVkVtS2VIRkdhNjVNTzhISG5QbGhteWVs?=
 =?utf-8?B?NU5HN0YxNUlTVUxWS0NtZi9KNlpHZ1RtQnp4VUxTVWxkMFl0UkJ6NloyeWZn?=
 =?utf-8?B?OG5TbTlCR1BSTWNlV29wRjBWT1JWUnlISmhEd016WHNUYmRxaEtCUGFMTlFh?=
 =?utf-8?B?cHIwdnJZMHlRaU55OHpYbFBxUVNFUWRBSC9XUEk0amRxaFl2K3YrZGc0UnNr?=
 =?utf-8?B?VnRmMUt3T1NYeHVIdmRSMVBuRDFrZ1o5YnVnazdEUzd6bXA1SGpFb0h4UzVp?=
 =?utf-8?B?OTA2VWFGSkN6clM0UzFoZlMzbXpmOGdEK0h3dlhNd3ViL05HbHEySXRwNDBB?=
 =?utf-8?B?c2lOSHp1RDlvWGpsZXVXVSt6OXR5RDNwWjNra0xCbFg3WkxOUmFTZmxxZnpm?=
 =?utf-8?B?eWdkcFR3M0p0bWROT25TRjVJbXFMbm9zcXJueFVPVmdkU09jSUpDa0dXZkpW?=
 =?utf-8?B?KzJRb0ptSm1XQTViNGxXSWxNRTVWa0VBc3JQU1BzbnhzYjRtTkVrcFdwNEdS?=
 =?utf-8?B?WDIwK0dvY2wzQ2xSV2p0RDVBQ2FlNkFMR1Exd3ZTaUtLLzgzWHF3NkhCQXZI?=
 =?utf-8?B?bWRuU1FhRGNkdmdSeEpMM2tYOU1PVnR6NzBWaXhMYlYrSHY2Zm0rM3dtVldW?=
 =?utf-8?B?OVg5eVdlYjUyZHBodmF5VHpwNVAzclN0TDgxNzNYQ1ZuTUJ6WHV6ZzlWdTdh?=
 =?utf-8?B?eHBYaUg2dG0wMWZEbUNpR0R0YnIzYVFlZHZyT2xhY1gzQ0svcFZtZFJJdzBT?=
 =?utf-8?B?bGVDeEZ2K25ucG1abi92aytoK25qbjN6N1lzb0tTM1lSa2d1NWdDaUhjYXdx?=
 =?utf-8?Q?fJROZrQZrPHyz?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXREQlAydjJOZGtsNFNHK0E2OEtyaUV3OGRlWXJxS3NpdHlLQlBiZURQYXBh?=
 =?utf-8?B?bjA4OXgvOG13bjRFcHhCeld5T000WllTUUdBNkJMSDZQclhjM1VwdDZOZWtu?=
 =?utf-8?B?MG1yNjNwSFVwWVU1em1aYi9oTW83SVhzN0lPNXprZWFocG9XOUJaWWZ4eGhl?=
 =?utf-8?B?Umh2WTY0b3Q5TWRrei85S0xVaktOSnNqU2RPWnliaGVlZWRDYUR6Q1MxR0Nv?=
 =?utf-8?B?VW95dVc1Y2J2b1BJUFgzYXE1ZEduZGZhNm9QUU8wWkx0UUNCNnBOcVNQRS95?=
 =?utf-8?B?RkNBRDJEUDZZYTYxLzZqb25STWxMZm5pbEtDQ3JGQ3BNNmNhaUlaUDU2NG40?=
 =?utf-8?B?ZjFnZFZyNGVBM2FqWVdMcFVadVJqcm5udkZCd1NRMEloV1V4S0RHNzBxM0ZP?=
 =?utf-8?B?MUFBYVppRkJVK3dROUVFd0NqMkxIWnRmbVoyZlk2bXhLb3RuQ3hvNEpPZkNB?=
 =?utf-8?B?NGwxSWFFcGxJNGNyZUh5RzMwYU41Ym45RFpoQWpvbkRlRkRWNGlCWWgzdi8r?=
 =?utf-8?B?T2E1ZG9iNFcvaEtEcVBrOTkrZFpFaG5VSk5LQ3crQmxkdCtXNm9IMk1aUVVq?=
 =?utf-8?B?T2gyQXBWa3RjOWZOSUozbElsTXBYQnpYZVB3aWdmNXl6REpLZElWYyt4eWVs?=
 =?utf-8?B?L3ZGMmlWNDBaQ3lwVEd4RFk2dUdDRjVtVDE0S2pMNFRmTXZ2YlY3OWZkVVRK?=
 =?utf-8?B?dU5aWW9NdjF4ZWoyV3VaMVBEd1pVVTQzWWczREY1N3dSa1dDYmo1bi9CVHdJ?=
 =?utf-8?B?SGE3R2piemVWMUowSks4TTNkVkoxUGpjd2JXb21nVy9aekxCOGwvTWJmaVZS?=
 =?utf-8?B?TkovdkRpdVNWaklteEJYaUd6VUVaTm5lVnBpT0xhMG1Jek9WMjc5YnZrTmZp?=
 =?utf-8?B?YWJmL2J6REt5bG9PWHhxbklxU29ZRGxTc3l0emVoYlJSaFNLUGxOcGtQSU5h?=
 =?utf-8?B?M1JZUDB5RkNvMEZTVVRBdXF4MVQxRWxJK05VRVVsbnA0QkRiYzQyVmRKbTR1?=
 =?utf-8?B?azZtK3l3MkorMG01SmpRYmlYdVBKbnBvZUY3MEYxZzZ5TlZWbUFlSEs0ZzhH?=
 =?utf-8?B?NGVrbkJvd1RwaFdsWjlON0U0N2VoZ2wvN25Ea2w5dEVvUExrM3M1OFRPUGdG?=
 =?utf-8?B?bTVYSUNCRldDZyt1SmlSRzNleDcyVndtZERtWnBhMmRMSnVkSGZXSit5SUIx?=
 =?utf-8?B?cnI5YWJEL2pxcENUbkVzQ1k4MWtUQkQvM2Q2RGZmSXRhVnA1OXZ0SGMwVHZC?=
 =?utf-8?B?a2dxSVpKSGZGNVhGQmtqWnBNc3ZoK0IzcVFoZUlqQjM1TFE4cWx3WXRaSHVU?=
 =?utf-8?B?YTZkZkJmWmwzbW5qNkR3c3FBYkRiNzFyNm5hL2NUeitiSldEWlFjeW9MUG5E?=
 =?utf-8?B?eElwckFVazhiZGNMTW1xTGNVaEFaQWtSZ0lKVjBDZGM3ZkV4OGpENXZqTHBG?=
 =?utf-8?B?NkpZSWQyTGcybWJ1d1BOeTdRTWVqUHBGYkdSeXBrRmpHWnlJTzlDTnZWSk1L?=
 =?utf-8?B?RnhENm1zUXpHOVhibGNPUFl0K1diVGo0OHE1R2JKUlNRVDB5YWU3aDg5YnZF?=
 =?utf-8?B?cWUvNGdYZGd4SXY4MmZNZ3BTQlpsbzEyUHFka2c0QmdHRm0wYXhwZ0Jyc2NZ?=
 =?utf-8?B?WTAzMDliaTZaaGtzbXA1aDVJZFpFMEhEcnA3S2FrTUZKWXNZeEgyaW40VlJr?=
 =?utf-8?B?MSsyV2tUcHpQK2ZyM0FkY3ZqcHkrS2dsOENxV3htc0ZoMjdpN2RQUU0zRndt?=
 =?utf-8?B?MGxhenEyQk44QUZqSTZJVWE3aGZKNnZHby9INERzdXZzcFI2dmRabm1NWHRE?=
 =?utf-8?B?SHllbXNYQkM5QjB3c0tpUCtqM2FYUGovUVJEeUpXaGNQcG1uNzM3ZllCNTRw?=
 =?utf-8?B?WmZ5QkhLSkhVQmlWd0xLU1JMMEJkcGU4R0lndTJJaWxMTU5FYkhsTFF5OVF6?=
 =?utf-8?B?Tmw5dGFiMm1xVlJmWG45WnBHMU1kRkdXZlhFODkwRG1UT2o3c05TWWtVdlpD?=
 =?utf-8?B?aXR3T0xuTWdETGd0V3QyRVAzMzBWRU5NVy9nWTFmWGVPVWsyNlNVVVZCS0RO?=
 =?utf-8?B?R29lMFovWHJ3L0hCdFVXVGNyVzBDMGlTVlNueHdNZHlqZHE0Q1RwclZBOWx5?=
 =?utf-8?Q?JWVXboIcTWP5RVRB37tc4R8W7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fac9546-cdee-45a4-dddb-08dd35005eee
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 01:03:07.2339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gwv60flrwz5MiB7M3u6z4A4QltznzVo+0PzZHemaRGAI4hCWycJdD9eyAiFkXGlm+CSsrCAUVoFSz6XlFgurxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4733
X-OriginatorOrg: intel.com

On 2025/1/15 08:55, Jason Gunthorpe wrote:
> On Wed, Jan 15, 2025 at 08:22:59AM +0800, Yi Liu wrote:
>> On 2025/1/14 22:00, Jason Gunthorpe wrote:
>>> On Thu, Dec 19, 2024 at 05:35:29AM -0800, Yi Liu wrote:
>>>> This adds the pasid attach/detach uAPIs for userspace to attach/detach
>>>> a PASID of a device to/from a given ioas/hwpt. Only vfio-pci driver is
>>>> enabled in this series. After this series, PASID-capable devices bound
>>>> with vfio-pci can report PASID capability to userspace and VM to enable
>>>> PASID usages like Shared Virtual Addressing (SVA).
>>>
>>> It looks like all the dependencies are merged now, so we should be
>>> able to consider merging this and the matching iommufd series for the
>>> next cycle. Something like week of Feb 10 if things are OK with the
>>> series?
>>
>> Hi Jason,
>>
>> I think the major undone dependency is the iommufd pasid series. We might
>> need to wait for it before merging this. :)
> 
> I aim to take them together, we should try to avoid adding unused code
> to the kernel, I'd look to Alex to Ack this and we'd taken them all at
> once.

got it. I'm addressing the comments came through in the past week to the
iommufd series. Also, there were some off-list discussion with Nic on
making the iommufd_attach_handle code out of the fault scope. I'll try to
send another version this week.

-- 
Regards,
Yi Liu

