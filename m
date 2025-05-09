Return-Path: <kvm+bounces-46054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5525DAB0FD2
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 12:05:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBCA43A8E28
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 10:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5418E28E59A;
	Fri,  9 May 2025 10:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tz7brUIi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C25222576
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 10:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746785096; cv=fail; b=kxnVN84wIaw1eF0efKdc9ZJC9LX8RdAUNXczpBW/SUoJzGNJiHos9zwsLXFstN6KJ2gly0BGlGEr4fXjG573KTjusar/+PDGxrViZLSHqY9fWHO6RLcmlQKrxp2mPMHihmIJVqu3RSTEhaOrGkh7h6t8+2ktaZ+jK82f9Lo+oig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746785096; c=relaxed/simple;
	bh=c5qCAHl5ZOY4KypJieUVN4rgKgqqbZ1WwRbMJkRmoWI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XlYL82Wf7HbMvbY+zi12VLl8Tpj22A8663EpGT4edGfksxlIo1D+Exgk8HqsGU5Ek790qp9UncOlAoR7gE6I8Qbq/czEXiQPLKkE5EjRXVUU67AIHX3jdi4uzT7cyDGrr0IFGbGR+wlp0AHKeP/X90oo9F/YKpUPMRjFsBTGqxk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tz7brUIi; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746785095; x=1778321095;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=c5qCAHl5ZOY4KypJieUVN4rgKgqqbZ1WwRbMJkRmoWI=;
  b=Tz7brUIiqD8TLWAfRIMby9/0bi7qXn4ftfVepI9pxGNLJD3ZYMWjwoRU
   kmn74IW5ceD41UQfoJ66kmExnqlUZdtrc7/RY+2eurMRB5BqWryBikokf
   rWFuR4DRfIxH33LZSXvmoR/je52Q71SPc0x99J/oFoKjbqoLPTFn/ncRK
   LR392VJq1QPWtL2MZtcTCkBUEJfBaUQIYO7pWaqxsEieIHpyr8qTC0xc7
   VlwkFMT3QfiQ/VcomiWBf4t4Ss2AZ8MOwZ+UC+8WHrZc2pHEQxQd9ag70
   82wn5wwr1GZnNknhTlUc0JrUBikH2Y6GSxQP5mVuvRutDEXt7axTCxXdw
   w==;
X-CSE-ConnectionGUID: W0V1lCVqTKK6FdJGP4xBlQ==
X-CSE-MsgGUID: J986spXVQTm6QVO+DnFwzg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="52416533"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="52416533"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 03:04:26 -0700
X-CSE-ConnectionGUID: boJo56cDSXSzBJILY95V4w==
X-CSE-MsgGUID: aCoLgFNnRya01xbA+atoVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="136595129"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 03:04:26 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 9 May 2025 03:04:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 9 May 2025 03:04:25 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 9 May 2025 03:04:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WUlwb5R8vCVOx7SamHwuM/Ts1IKPXJ0kHOEOMnyv4gVWDXxe+/S4Bv5m4JBdViPj+EHdR6c571ZJNrkNjVZJfk2C53W8Bvbr1txesiphv+007pDEov0tpSFUtB3iFvAbJf4bimk+zFf8hkcYAM9zfXW0OlKNNv/zUVel/RAl9sFQfGMRtZ5zrJ5QYLJe2O7TQKrq8qb7u71xM4YEC6zUhErTXtaUcarVZta+iaE7F5/9tTulqDOd5sRlG0jdGCqJWjbRmzvoUUsh01C7RgN1h4PjvXP3jQl0MpydhIy/xnZ/WG7LpVuqDHH89UsCJxz5Ol0YKmUqq5tNBxLh+hsr2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y5nr6y0Ojo6jRGXSEvXjEc376qq87dnEZI4bJdvZ0WM=;
 b=A/e2ZXTIS/aVgABMxgzY8Sx4kHDMp4ngMu4TLgk0rTm9A/u4COYRs+K4f/70uecTZ4UpQsGv+M6FeLMu+gBswXDL1TR3JaJg/+P1uFuZl+/2ZekN2sg68Us8PTTGBorsSYHyjsD9S6dskQYdUxqolbbKkPF9/wQmZzhAlD3pVVYjvezjZ9DP0Aw1LEbOFbZhW8NHP6ztQDtGLQHUgosN2bKXYgVcuFrxNsDjbojDHSiSOlw9fYKNlIeV+Az+cHzNcwtPh9whslJQ5EMRbPE6O8QWtutOGNVhY+VyMVjbH6WWcYS/9Wuq4Ng6+jS9KbE1kOzcXAV+10LOnXl7MirmmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SA1PR11MB6872.namprd11.prod.outlook.com (2603:10b6:806:2b2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.24; Fri, 9 May
 2025 10:04:23 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8699.021; Fri, 9 May 2025
 10:04:23 +0000
Message-ID: <55547b18-be03-4684-9330-70fc2ba48954@intel.com>
Date: Fri, 9 May 2025 18:04:13 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/13] memory: Change NotifyStateClear() definition to
 return the result
To: Baolu Lu <baolu.lu@linux.intel.com>, David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>, Peter Xu <peterx@redhat.com>, "Gupta
 Pankaj" <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-11-chenyi.qiang@intel.com>
 <c7ee2562-5f66-44ed-b31f-db06916d3d7b@intel.com>
 <5fcf90b9-dff5-466c-9be5-2b6571a5de8a@linux.intel.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <5fcf90b9-dff5-466c-9be5-2b6571a5de8a@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:3:17::26) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SA1PR11MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: db7670d0-796e-4035-00ba-08dd8ee0df47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Zld3WkZWcTBqQmFCSGFFMFdXbk54OGRtWlZkQkkvampMTFlaN1BUalArdWJW?=
 =?utf-8?B?LzVtSkVhZjZhSEs5dEg1U0JKM01OdG1CakYxUkNWbk8xMmVwS1h2ZElnWHFj?=
 =?utf-8?B?UEdPSDl6eG9Kd0p4djIrRC8weFRmMDRMSlJSZEd0UllZanE3SXJWbXJHNVdS?=
 =?utf-8?B?Y0g2VHdyb2RWaFFZSi91NStTYXU0cCtqVmdUZ3JwallwU1VGTnNaa3VKSWhi?=
 =?utf-8?B?cmRTbU96TUJRbFA0TUhkN0t4UjlBUWpKOU1rU2RERjlRbTI4TzIyOC96UWJ0?=
 =?utf-8?B?ZFo5dmo3Y0YreWFCTGRRQk9tNFdYWVlSR1lYMGUrVVZDUlNiRVNwL3k0L0xJ?=
 =?utf-8?B?czV1OXE2eGxISk54ZC9QY2piOU5UNzFqNGlqZXNiZHZMZEk4VUxVTHMrYlVI?=
 =?utf-8?B?SFhGZlhBTlJYNDNZVDdhS3hrOHRKS1BDTlh2TlIwNlVtT1JxNjVFVFdrY2ZS?=
 =?utf-8?B?RkNlcWNkdDgrendyMC9CRUVucDZUSkRqTHE1Z2NKTDVxd3VkVDhuaW1jS2F1?=
 =?utf-8?B?aEp5dEtTTmdUTzFTcUVaWVM4d3hoVzN2MUlkVjVyeVFYK0xhRWJKcWxWWVQ4?=
 =?utf-8?B?SzBwSW9sbXg2bXE5bG53VjY2bGYyU2NxdjZ6c0lQSTc3bFhmVFFBSndkWnBG?=
 =?utf-8?B?dSt1TmNVMklSQWsveWJLWGlLK3Vod0c3WXJMUzE1NVRxb1pMbVdwZFJ1SzIr?=
 =?utf-8?B?bmcrdUtJOTMva2xPcXJCMW9WS3hiL2dCd0o1dW4xUEVIR0ZJTXk5djlXU3Vo?=
 =?utf-8?B?VkFrUERyUnVCUVBuNHROandtdVdjWk5wNFZpZVBJV0ZxTUdTSndWMGhPbW5K?=
 =?utf-8?B?YWpuSVdaWXpIMjZScWd6RTJUVVpZT2dXTFJUNDhBdGM3NFN5WmlhTmc2NVQ0?=
 =?utf-8?B?VHExQWh3OEVkTXlZSjdQajdiNyt0VGZONGtxRWVZeUxsVFhhYXB4QlZ1S1k0?=
 =?utf-8?B?bWJWZDdxcDJsMHNyZDliYkw1emcxejZZbmxqek1KZW8rcmp4dXFRa24va3c0?=
 =?utf-8?B?L01mclp5QVhoSHZQanl1SHpQb0dkYkdKSThGanhpVTZJU0ZGaW9VRFI3U0NK?=
 =?utf-8?B?MGNnUndoTWtYQVc2dnRoVzQwcGN2eSttSUxWQ01pVkd4bnFGV2kwMTQ1VmVy?=
 =?utf-8?B?NEFLS1FrK3JPcGVrSGh2OXRLV3d5aDVJMjBkZlZvUkVwUkxENDh2REx1SG1Q?=
 =?utf-8?B?NTdnYnpGQlR6b1J6MEIrR3p6MlprZnJBYVRPdG93T08vOFJVUWdTa2tkQjVX?=
 =?utf-8?B?RUpUSU0vQ1Y4REltcERlL1ZtYlZTeVEwWG42M3dCYzNEbVNtYTUzRG9RSFhT?=
 =?utf-8?B?eGxvSUp6UmlDcU9nbDZUSUFLanFvRTdRQkpraTNtR2tGcTEvQlllZ3lhMkpr?=
 =?utf-8?B?ZUptNnk5bmJoZ3dQSnBuZ0ljTnVaeVNLMVBJRnNEclVNMU94dXRhTElsTXZS?=
 =?utf-8?B?clE5cWRjbXBrZ2RQeEltbjNNQWJ5QlpYaDR2OWhXWWlObzlud3VvOVIwV20r?=
 =?utf-8?B?VlRuMU1zcms3US9XMkRzbEt0NUVjWDFhWVhwb0I5dTMwTlR2Y3pwbXZoajZM?=
 =?utf-8?B?Z0JBUzRaekMvcGhqVForQlFYYmFDK2h3WFZtTkJ5cUJtdWc0OTlMOXBoRzd4?=
 =?utf-8?B?d0IzRkJaaldMaERwU05yWVN6MVVpZTlpWEh4Z0RwSVRnTEt6QkN5b1JoaHFI?=
 =?utf-8?B?NmdsL3h6b05OTHVoMUE4bE1jYlRKNklvMjdXZWJGaXBxZ054dWRHWlFCYWZx?=
 =?utf-8?B?ajEyNlBkVVZxcG5EUFBSUmlDQzF4d3BxNFBaTms4bDk3SGRIRW1ienRaK0ox?=
 =?utf-8?B?MVlKdU9uSXVXc3FRZUFUcXdwTEUzalR6amRacUs3RDFNaEYvc3JzcjdRem4y?=
 =?utf-8?B?M1JLSTJ2MDNsaGgrYVF1dFdXVGRLYTBlc21QSmtqYjVFN3c9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUxIRTJjTG1VVzJYMGdzc3ZIeEpiQ2JEQ0VQN1J3bStCb2tvYnN2L2lCVmlS?=
 =?utf-8?B?ckt1RmlqbmgxUHhiN3puRDJPekFrMHRsaXVHTXI2dUtyQ2xlNGtBSGJ3eUlo?=
 =?utf-8?B?U0VHb28wNDkzWnFrVkdrUWxQa1BiajFiY2ordHBHTU9PVE1RNlo0L1NZS1dV?=
 =?utf-8?B?aGZIdXhjcUtuY0VadGt4MHJrU0RKekg3K3dYTU9lSCtIdGM0NkF5UHdrWnhq?=
 =?utf-8?B?QUFTOUo0WndtSzJNNlZCYzhCWURmWTVtQUtkS2ZRYkNUZVZJWGY4WWhPYzEx?=
 =?utf-8?B?VmZyZHh6U3RhS2dFaTdsZVhoaUdRVmF2S3VZWlRVOG16enVmSVV0UXlLUXNt?=
 =?utf-8?B?eTVwTkd6SDIzYXlreVZMLzY4N0NRTFpsU214UXN5V056K2FGYlM3SVkzK25J?=
 =?utf-8?B?ZDNkMFgwY2R3L01zcVRwQWljY3VNeC9rcThmaXdaRStITGFSRExhRllHNFVw?=
 =?utf-8?B?azRkWS8yUHBuTUtTd0N0M1U3K0hZNHJCRUZzOEY4Q25jYUpMdlh0TngzU0py?=
 =?utf-8?B?K0ZUS2YveUp5V2tYMlVRRnF6ejFaY0xBZUlNdHEyT0dGcHdneHorRDMwWk5Y?=
 =?utf-8?B?anNPR0NwSVE3WitWL1dWcWhwcmtEVFVpR0pzM2JucEtoWVRUZkVEOWRlczdG?=
 =?utf-8?B?MjlwV1lQbTM3V2txTnVjcUFva2x4NzFVMDR6K3Q2MlN0VTJUVHJpR2tpa21l?=
 =?utf-8?B?OTB2a1g3c2lKdVJlc2VWMytpdXdZZTBKU3MySFd0WE1sa1RYM2FkU1Zab0Zh?=
 =?utf-8?B?SnBJL2JDWVJVWHRBK0VNaFBpM0NXQ3B4a09mODAzYXZrQmcxOC9pRGV3Yzhr?=
 =?utf-8?B?TVR3YW9VMjBCRzQ3YnZqSkwvcXhtTXo1RGFuMVpmOThqRUttRkdMb1pMSUN1?=
 =?utf-8?B?N25yNHk5ZS9oU1c5endNejhZaXh6ajR6ZkpXQ1F1bkdlcy9xK3hFUElad3Z4?=
 =?utf-8?B?dUpTOFY0NkZlR3pjdGVPS2czaVptbjlPM1NINW9LRW0zN3JDcml3Nm5Ec1dU?=
 =?utf-8?B?N0k2ZGczSXZiSkRnUm9VVVMwQjMwRXJlL3drYlg4b1RnK2E2dFZ4enJ2dXVq?=
 =?utf-8?B?TDFOdHNzV2kzN2oxaVlkamxSTUhhbm5RMGVqMUZnNThjMFh4YjhFdUNoRmVs?=
 =?utf-8?B?UFAzMzJPdkphdlF6Sk9SdEQxN3NuNGxsU2hIVWhjRGVIN3poeDJzaU02SW52?=
 =?utf-8?B?Ty9DcEw0SzY0N1R0dERYVDJkN0ZGWGcxWTF1eDFBN1RCalljU0hGRzMwcVVj?=
 =?utf-8?B?bDBIc0JsdVZXcWxCeDJzdVUyQk5GTUxwQzUzQXV0YmlCNFY2T2diY21FMzEz?=
 =?utf-8?B?OE1NL0xBQVFtZWQ4RG5Uc0dieVZqRlhId2ltN2FET1g4eVdsa3ZqbFhkWGlE?=
 =?utf-8?B?dk1CaGNpa2pqUEUxWHVNSE5nU0JKUE9JVFJ6b2NIY2dxUmxsQVVOM1ljbDZC?=
 =?utf-8?B?R3dCTGV2cUdGR2FZSFpMNENXOWFwbkFONHQwNzZUcHJLSk9LZDZ6OFJCZmlU?=
 =?utf-8?B?R0txZDA2QVhtN1lBQmVVZXgwSndqMXg0VXBsbGZCZUhtZ3ZKUG5VUFp2QVZX?=
 =?utf-8?B?ZmNtdld4U3BQN24wOXVFNlBSSTdMRlZyYlh0am5kT04rSzlwb2hUaEswYmJU?=
 =?utf-8?B?b1dYODlhQ002cjV4NHpLZ2NqN2VSaFlrWElpZDdZaXVXUTZEZHlGc0p0MnFE?=
 =?utf-8?B?djJjZFFFR0wvWFlHajBEd3F6VUJVcHJhS05WS3V0azJVYXBOTWhlM3ljYWdR?=
 =?utf-8?B?Nkc3Rk5FZ29FZGFBdlB5TGdtOGJ1SmJ0UDZXVXJPdTdaR2l3K1pFUDg3dElV?=
 =?utf-8?B?REFXYVl3UmVhemtnWENYNnZFMUhrN1c5cEFWSFJkRUxnK29RMlRqVWJRYmJ6?=
 =?utf-8?B?ZEJtOHo3VE0wSnR1QmtiZ0lpRzZxVXZsTzBXKzcyTzIydnR4TExva0VLRzNh?=
 =?utf-8?B?b0kvRHplVlNMUVRLTGU1dWNQMUdPZi9HNVpyajBmWFl1UWlHYW9RRGNmRENP?=
 =?utf-8?B?VVpxQTYwbVh4VVM2K0ZEd003Z200aVdQekMvUkR5cWl1TEwzOXcvWjU4NDZE?=
 =?utf-8?B?Y1VjSW40KzBGSTZ1ei9YMmFETmZldmM1bnRqbzRVRXAwcWMzcnNxdUI5QWwy?=
 =?utf-8?B?R0lVODdGUnRZU1BQSzRjZDluenhmS1JaVFJSZngzTDZTbUt5KzFLZG45U1hy?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db7670d0-796e-4035-00ba-08dd8ee0df47
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2025 10:04:22.9401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZaWbA97W+1OLsdzDFsCdRjEoISiwiOclvrvc8al7hVUI3zMk7pgjSZpWK1OSHLDgzrkKty6Zc6ZBbXdmDybx5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6872
X-OriginatorOrg: intel.com



On 5/9/2025 4:22 PM, Baolu Lu wrote:
> On 4/27/2025 10:26 AM, Chenyi Qiang wrote:
>> Hi David,
>>
>> Any thought on patch 10-12, which is to move the change attribute into a
>> priority listener. A problem is how to handle the error handling of
>> private_to_shared failure. Previously, we thought it would never be able
>> to fail, but right now, it is possible in corner cases (e.g. -ENOMEM) in
>> set_attribute_private(). At present, I simply raise an assert instead of
>> adding any rollback work (see patch 11).
> 
> Do the pages need to be pinned when converting them to a shared state
> and unpinned when converting to a private state? Or is this handled
> within the vfio_state_change_notify callbacks?

I think it is handled in vfio_state_change_notify(). Just like the
device passthrough in legacy VM, the shared memory will be pinned during
vfio dma-map and unpin during unmap.

> 
> Thanks,
> baolu


