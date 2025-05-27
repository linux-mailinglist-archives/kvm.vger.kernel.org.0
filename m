Return-Path: <kvm+bounces-47761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 80EE5AC495E
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 09:35:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18DA218969DA
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 07:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDA29248865;
	Tue, 27 May 2025 07:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="op68rUkg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A382AF10
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 07:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748331329; cv=fail; b=XSfGEk3xIkjTQ4VRLpVMlQOQ6k4cxR0EPErUbwR4V+WkEALPSQUp9NBkykiu92rTSQYqaKiJZvYO9f8NjiTsymHikgATqTmiee9rZwacx4Hlo6EKZYqXEoOO32W0F+bMEJT6BV9l5LFDU3E1z723RLAZBibAjyL+vE7ztAnHXWc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748331329; c=relaxed/simple;
	bh=dYGjV6kBOFsA3Q8jUX1q109uZ8FCC6RVWQAN6Tr1LfQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Xangr7EId4bg1RFK8rbs2BX0cS3YuxU18pWhFLY/zu0eXAVdhCbJ2gIfcjKkGmws+nsB/IPOY9T4BXNuViXuLg4h3aUk5SQP2rBRP8/FxLhoRnX6GhUKmgeGIo68RH3CpH/AgqFi1DML8q+u//4U9Duau49G5qymOezF5zNOS04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=op68rUkg; arc=fail smtp.client-ip=40.107.237.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SxtYmj7Psh/nnpp8sjJ+16qWiIDKxT/rif+CHRM59Tvc+IC83XNp8uo6rG4f9SlsjqtfiBQKzFzQ7o0C246zU67pbGRRdivFroUKC+0DBQSYpVkCsh2ub0MSyjBw7QfTfjcl/CV0DVXFnQb6vZkIpkLTUzF8WqfZib/qHUfeYcMS5pjpgzWEp0CL8n5ivFGGH4nsmHrQfe7zJ5wyeo8dPJZabPr2SftzBglD2FVo4GcQKRUa8+ZchCmkPcGzbLZYZxV6T3NHOMjiZHtMq3Ss30h7XtqfYGZ+g1gtMivrWpejQGzltqlNObjqDUHnt1o2CxEFK96AhCXxzB4WVV7pTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4eoDLy0iJyZXL+O8ZBi/qDcZFcLFNR5JlRPtMOqhQTM=;
 b=GOnajJbsus3TnEpG5gvNEwKfbZEcTy5Hn7zm2hxmvwmstdj7KqyiyMAVwE9RxGXHTBVQTkxK1uzFKlWaXPV11PfCDDG++Vi/waMJyi+qGvp/3dIdfh4O63mpMrpO8H1yNSO6hFP1v93CsSD+YmA+uQNESgvFxOhR46D9vATfk5TiKkwdEjRMGyor4p48x7ruJnQsekLNHvNGVJp2UPgr36pqvqUYJiv/EB9APl2EG5eIPryh6dtPZhssM/aeu2OZno2/EMcckfIFvZWmNwtV0nlkJtAI0q7pGOZT55847mOaKqPehcvrtvY1Rq+iPguZ4WWNL53MSmHBkEL8cA9x4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4eoDLy0iJyZXL+O8ZBi/qDcZFcLFNR5JlRPtMOqhQTM=;
 b=op68rUkg/ywjQbkO1lJTTAGnYWOzAfQ6T7GjRo69D/1DH+qiK9upMPyQYWzA/HfTFrP+sDVhqbubEL82NSe3TGs0i+1SUonZW1xesYVGpFzdWjEnYMpL44izLGa/Qr4a6oo+wiWT5Du/2xfoqOfF/WR2qdqU0+hJ/OZfYEV+8+E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SA1PR12MB7175.namprd12.prod.outlook.com (2603:10b6:806:2b2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Tue, 27 May
 2025 07:35:22 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8769.022; Tue, 27 May 2025
 07:35:21 +0000
Message-ID: <952ff8ef-815e-484f-a319-3416dd3c03e8@amd.com>
Date: Tue, 27 May 2025 17:35:14 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v5 05/10] ram-block-attribute: Introduce a helper to
 notify shared/private state changes
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-6-chenyi.qiang@intel.com>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20250520102856.132417-6-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYAPR01CA0034.ausprd01.prod.outlook.com (2603:10c6:1:1::22)
 To CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SA1PR12MB7175:EE_
X-MS-Office365-Filtering-Correlation-Id: a4319c44-9707-4cbe-b9ce-08dd9cf10955
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OXd5L3dHVmRjUnQrUFZ1VUJaaDR4TGc0dUZMRHZYWHh4ZWt5OGtUbTVubGNn?=
 =?utf-8?B?NXFIamFFYnlxSk5XcWwzYzRSN0xvZDZMYzFUMW1qN0FINmNqS1NVbkFlanc4?=
 =?utf-8?B?anBEWEgrN3ZHd3Z2K1VlbGxuNER6MGx0TU0zUmxobGhFbktJSkJNVUlNWEdT?=
 =?utf-8?B?OGRRVHdHTDFUcXB5eVd4VnBsOG54MDdqdzk5OGVvZjhoQ2VxaDNWeTBreCtu?=
 =?utf-8?B?dHRHV3JuVCtlbTgxVjdhMytra3Z2ZnpIbmdCUlBJWXlYYkprazRwL0twOE9P?=
 =?utf-8?B?Z21Yc2Y4Q2VoRDBxMUZnY2JUV0ZqSWlNRWlmM3lCcGRLdXVRNG1OTXB0WHpj?=
 =?utf-8?B?cHQvU2RPZ0VzK2d4R1BtN1JUUzd5L1lIU1gwelQzajloQ2ZqVlVHYldndG5w?=
 =?utf-8?B?OVBRbTJiQmU2NEpMdnpDT0IrQTdvbkxLTDZIQm1RSmhGVFM0QXYwanVOd3pa?=
 =?utf-8?B?ZzBKWnJsck5DM3lmYm1VOWpRamZFbi9FaTBMOU8yUFdPSk5WQnphdXlWd2Rz?=
 =?utf-8?B?cTJGWHlGVHJvWUR1SVBSU0dlQ2dyN3JoOGlCcUk0UWJ1S0hBQWJhOTJmeXZn?=
 =?utf-8?B?NWFXd1dFVVFyM2NtbHExb3Y5eGRKdHE5bEN0S0lId3V4Um5mZ2pTZDdjVm9M?=
 =?utf-8?B?SGxQM1lBbTNid1VCSTJ2V2hBdWw5K0xscml3STYxZ1ZGYlE1VklndlNudDdv?=
 =?utf-8?B?THVGMFVjZXVwMnIxeE5kL1VNRlY2RHpkNnZjcTBxWUVwTmt0MGpGWXlCcFY5?=
 =?utf-8?B?SVJkMHl2OHQ3K1RiTTRvdWp3aEMrQWFHOEZFYi83SVVmWU5waU9Dc0dpMThJ?=
 =?utf-8?B?RjJiejEwN1ZrUFBnL2FuUFJpNGh0NDlzZ3ZETUE2bFB1QmVJbHBxbTViUzRq?=
 =?utf-8?B?bXhOL2QwWm82UDMwRUJhS0hHbjV5emxaRGRxQjMvOTV2UjJqQTJTeGdjYzVy?=
 =?utf-8?B?QytDUzZWeDdYdXFzRzl5b2U1eW9xK1JScWtoaDlhMHFFV1A0ZGhoZGlETnM2?=
 =?utf-8?B?VlA2MzN1ZWdwK2J6dlhUYkJTUG9LWFpUWWxKc2lmcDZIUHYwYnp4RGlxblds?=
 =?utf-8?B?MXpETGhtS0pYUG9FNmwvaHgvZVA1LzFZZ3BBekp5a2szWUQ4Sk9YRmwxb0kr?=
 =?utf-8?B?RmZtbFNLbndtZWY0VlJldktLRVIzYlBNVzlxaFg3ajlmNERPWjZicDVIS1dS?=
 =?utf-8?B?VlJoQWs2RDJBN1dmdERDekp3aEo5aUxPUFFudEI2eUZvRlJIY0YvTDIzdFpx?=
 =?utf-8?B?dU41U3BaMStrcS82YlFQNXZQQi9hMWY1L1JaWFFvSGdWV2ZDKzFpV3FwZ2Ni?=
 =?utf-8?B?djVmNnpKMXd3STFXNEMwZ1VETDZTamM4SGI5Q2kvVGxVb0JJNWh2eXJNVVhQ?=
 =?utf-8?B?blJEeEVpTmlqUG9kT2krZStiVlBUK1JtRnVwTDVxcXN3M2VGZjRVTEhGVlNK?=
 =?utf-8?B?b1UyUDRNKzhPQ1VzZ0liWDg2S2hmZnoxSFpWeWovZkM5aDNZNVlDVk9SaEFn?=
 =?utf-8?B?b0JvZk1hcnJpS2p1ZisyakJOSVMzTDZyK21OeWs4aVlGT0ptT0lEcWxQMGNy?=
 =?utf-8?B?WWtzS2RjNWZVT3hMZ3RhS2JIdFowNnBtQXNOd2JNbDR4bzdzWGRURDl1VkE5?=
 =?utf-8?B?QUtna2pONmZWeStBTmdJM2NRUnBiT3FEVGV0YVJCMDNUZGJmREpmY2YySlFo?=
 =?utf-8?B?MnR3Rk5uVnUzalMxUzAvbThNMzhIeDVSc0RET0xtUzNYdU5ySEVMY3h6Ri9B?=
 =?utf-8?B?ZDRJb1RPUkQzaVptQktaRnpZeG9FRGhmVXpxNlVSNkFxakc3RkNMTU01azBv?=
 =?utf-8?B?SFBYWmEvcXhHY0YyYXo4akpsRVIvTXNOZWNqRkg2Nld4YzFKcmVqM2h4Y0FR?=
 =?utf-8?Q?Oi4J9VqW5FFHo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YkpUbnRjaWhYQUI1MWVSTy9BaE9ncVFMNDNHaVVqQ2xrVmRncVNXTTY5c2Vi?=
 =?utf-8?B?d3VFSDN1VEJuQ1A3eEpNN29yaDlYZUlYK0s0V3IyZmt4czQ2MGphZitJRmN3?=
 =?utf-8?B?KzlPRFVJZjBpMDdENjFoZ205ZFJ3QmJmZmRWZ3JEeVJHcEtQYlJHM2tHdi9D?=
 =?utf-8?B?Z2xHYUFHUkE1WmpOZlJXb3c5S3lPTjdYZmVMd0t6aHNHTzgxS0Fna21IWEhq?=
 =?utf-8?B?ZFlhM20yVUVHNFBQSGJCWnllUDFzNzlpMlhtRmRhTWZGbFdzeWhERlg2c09Z?=
 =?utf-8?B?NDRwNFFhbmVwRFBRcWVhY0g3eUg5RXdEWDRxMmZweTNEd3g2R2tpL3VCclZO?=
 =?utf-8?B?K2FZbXUxOXdERnJuVzBmQ3UyTFBwNDdGdk5Yc3VIZ3R4NVBrUWl3aVRIcjJ5?=
 =?utf-8?B?bG04RTRTN2JvZERacGdJdFRick9LRUsvVWhXOGFSSGJ6NFdVSWpmSG9PQXBs?=
 =?utf-8?B?NXI5eFpNSWlXSklRQlJBZC82Zm8rN0lCdTAwN2NZc0pHVjFvK0J4SGpmazhS?=
 =?utf-8?B?TzZidWppYi9MSWVsVjhPQnY3aVREN0t1dFBjNWl2OWtuUVo0L3ZOeEpIQmFR?=
 =?utf-8?B?TDJiVWxMMXZWWFE3allLbVhFMSsxdEZTZ3ZmZjRSeFRMU080YWpqU093QlJl?=
 =?utf-8?B?QkNRSDFxWVpGZGN5cGh4WWxiRjhKZU5CTjdzK0Y2TVpHTW1ackxwb3NvaFE1?=
 =?utf-8?B?UlZhTEsvUTFhYTNQTlhva0JyTGxVclpsMU5mSnFNM2VMR1VTY0hRMTBrT0Nt?=
 =?utf-8?B?UU5vWFAvOEl2RnJxdkdyOEc4R2tKV1l3cDFkV3dDUzh1WGkxMEgxWER4T1VI?=
 =?utf-8?B?bTNWSGxoemJFT0dUYU9EcEJPSDRwR0xvcG50WkJwdVN5SnlhRzUzOE5JMGo5?=
 =?utf-8?B?MGlOU3YxcmRKYWlGVzVNejI2OEE3SU9XT0Q4YXV4bmZCeDNBNGE4bzYzamJH?=
 =?utf-8?B?NzNOcFFBcGsrSE9qcDNBS1E2VXpzU3hmK1BwTHV3ajZFSFYxeDFDT29BT3JU?=
 =?utf-8?B?a2dpOVN6cXhXSldzNC8zREFoOS9oUTFOS3B0cDkveVlseGFDa2JMMmhBSGN0?=
 =?utf-8?B?MWVCVURzUWhKaUdZbUFJTWpQcUdLQ0c0MEFIODlvSUs0ckVXdGdpSUo5ZzI3?=
 =?utf-8?B?U29jcmZNcTJRTWU1MTh0Q3JKUFZXK1dmK1FkL1QwbHJ6NTFRSTJ5UzZ6WFFy?=
 =?utf-8?B?RTJXeGtFd1BpTTdLOEVvb0lvdU0rc24zUVRDQ3VVbHZRcGpjQTZHYUJnemxE?=
 =?utf-8?B?ZzlMQzhPaVlJb2tNcG1CNEV1b1J6YUY3b3MxbGh2REZ0YkxaZlYxZjAyNERw?=
 =?utf-8?B?eVdXSkFyOWNQQkJwWHV4di9nOU03bzhGRHJKdlhlR01WVll2d3Y3eDI1UVha?=
 =?utf-8?B?Nkx0QTFWcVZ5M2VlRE13VVVJODlFL3p3UGdNUXVsSGJRZldidFVrNjluc0ZF?=
 =?utf-8?B?SFJOQ3haOTk4SkpNWjQyNmgrV0FQc3VWbGRaOG1ON3NKQ1lEd0ZrSFpMOTQw?=
 =?utf-8?B?aVBjUllldWxzWG9BczlVbHdMOXlia3JOY2Z5R1RrcVBXQkVPTFBITHpVWWtw?=
 =?utf-8?B?QkZUZ2dNTitwQUFzb2lGdjl3akFjd25jejNGOWZyMzU0Mk9HOVQvUXFOYWdp?=
 =?utf-8?B?UDAxU2JwOVpTdlE4UFdTRDFjSk1aZFlEUllqOGFQTUhsMENuZ1RORXJGeG1q?=
 =?utf-8?B?blc0NTRlSUJXbHNHbUFEN3NIcFUzNXVMMEtldjRmeHJJZ2xkazEyRE5OeFFM?=
 =?utf-8?B?bTVjM3MvcmFWbm1ZMTNlRG9BN1BnVlI1eUcwL2h3RExzTCszMXNxRzVvbHdW?=
 =?utf-8?B?YTBSTGZQY2FYM2Yvd1M2N1FGNk9mMzJLUUl2VWZLZmpLNVB0dUdJYWVrZjdt?=
 =?utf-8?B?VkdMNEh0VnhWYmZydHNoVTJMWDVtY0xhSm9OaVlWbkQ4M0JHY24waFZiVGov?=
 =?utf-8?B?cXhUbHdIMEt2RmxGam9yQWpNVS94RmdKZkxvTHBNOFBWMDJ4a0FYNFRIdytX?=
 =?utf-8?B?YkJNY0JtNjBDbldBaE1Hbmx1ZjJ6TUpUc0JXVEMxazFaYlpJeG5KMllnZS9F?=
 =?utf-8?B?R0twSmgzd29tY2NHMWtPTzFCbmhVa2ZCSERibnpTd0gzbU1OQnhBMkY4TkQy?=
 =?utf-8?Q?9SG6mBkTRPqkgjluToENJqryF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4319c44-9707-4cbe-b9ce-08dd9cf10955
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2025 07:35:21.7594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 27ch86IyCEkd54H0kX8uA2Q701+4QSenk0Rii5bpWjrNS5IKRC48i5Xf0JbWZDkt/0GvbkFRhkl3vhsZ/ksQ4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7175



On 20/5/25 20:28, Chenyi Qiang wrote:
> A new state_change() helper is introduced for RamBlockAttribute
> to efficiently notify all registered RamDiscardListeners, including
> VFIO listeners, about memory conversion events in guest_memfd. The VFIO
> listener can dynamically DMA map/unmap shared pages based on conversion
> types:
> - For conversions from shared to private, the VFIO system ensures the
>    discarding of shared mapping from the IOMMU.
> - For conversions from private to shared, it triggers the population of
>    the shared mapping into the IOMMU.
> 
> Currently, memory conversion failures cause QEMU to quit instead of
> resuming the guest or retrying the operation. It would be a future work
> to add more error handling or rollback mechanisms once conversion
> failures are allowed. For example, in-place conversion of guest_memfd
> could retry the unmap operation during the conversion from shared to
> private. However, for now, keep the complex error handling out of the
> picture as it is not required:
> 
> - If a conversion request is made for a page already in the desired
>    state, the helper simply returns success.
> - For requests involving a range partially in the desired state, there
>    is no such scenario in practice at present. Simply return error.
> - If a conversion request is declined by other systems, such as a
>    failure from VFIO during notify_to_populated(), the failure is
>    returned directly. As for notify_to_discard(), VFIO cannot fail
>    unmap/unpin, so no error is returned.
> 
> Note that the bitmap status is updated before callbacks, allowing
> listeners to handle memory based on the latest status.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Change in v5:
>      - Move the state_change() back to a helper instead of a callback of
>        the class since there's no child for the RamBlockAttributeClass.
>      - Remove the error handling and move them to an individual patch for
>        simple management.
> 
> Changes in v4:
>      - Add the state_change() callback in PrivateSharedManagerClass
>        instead of the RamBlockAttribute.
> 
> Changes in v3:
>      - Move the bitmap update before notifier callbacks.
>      - Call the notifier callbacks directly in notify_discard/populate()
>        with the expectation that the request memory range is in the
>        desired attribute.
>      - For the case that only partial range in the desire status, handle
>        the range with block_size granularity for ease of rollback
>        (https://lore.kernel.org/qemu-devel/812768d7-a02d-4b29-95f3-fb7a125cf54e@redhat.com/)
> 
> Changes in v2:
>      - Do the alignment changes due to the rename to MemoryAttributeManager
>      - Move the state_change() helper definition in this patch.
> ---
>   include/system/ramblock.h    |   2 +
>   system/ram-block-attribute.c | 134 +++++++++++++++++++++++++++++++++++
>   2 files changed, 136 insertions(+)
> 
> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
> index 09255e8495..270dffb2f3 100644
> --- a/include/system/ramblock.h
> +++ b/include/system/ramblock.h
> @@ -108,6 +108,8 @@ struct RamBlockAttribute {
>       QLIST_HEAD(, RamDiscardListener) rdl_list;
>   };
>   
> +int ram_block_attribute_state_change(RamBlockAttribute *attr, uint64_t offset,
> +                                     uint64_t size, bool to_private);

Not sure about the "to_private" name. I'd think private/shared is something KVM operates with and here, in RamBlock, it is discarded/populated.

>   RamBlockAttribute *ram_block_attribute_create(MemoryRegion *mr);
>   void ram_block_attribute_destroy(RamBlockAttribute *attr);
>   
> diff --git a/system/ram-block-attribute.c b/system/ram-block-attribute.c
> index 8d4a24738c..f12dd4b881 100644
> --- a/system/ram-block-attribute.c
> +++ b/system/ram-block-attribute.c
> @@ -253,6 +253,140 @@ ram_block_attribute_rdm_replay_discard(const RamDiscardManager *rdm,
>                                               ram_block_attribute_rdm_replay_cb);
>   }
>   
> +static bool ram_block_attribute_is_valid_range(RamBlockAttribute *attr,
> +                                               uint64_t offset, uint64_t size)
> +{
> +    MemoryRegion *mr = attr->mr;
> +
> +    g_assert(mr);
> +
> +    uint64_t region_size = memory_region_size(mr);
> +    int block_size = ram_block_attribute_get_block_size(attr);

It is size_t, not int.

> +
> +    if (!QEMU_IS_ALIGNED(offset, block_size)) {

Does not the @size have to be aligned too?

> +        return false;
> +    }
> +    if (offset + size < offset || !size) {

This could be just (offset + size <= offset).
(these overflow checks always blow up my little brain)

> +        return false;
> +    }
> +    if (offset >= region_size || offset + size > region_size) {

Just (offset + size > region_size) should do.

> +        return false;
> +    }
> +    return true;
> +}
> +
> +static void ram_block_attribute_notify_to_discard(RamBlockAttribute *attr,
> +                                                  uint64_t offset,
> +                                                  uint64_t size)
> +{
> +    RamDiscardListener *rdl;
> +
> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
> +        MemoryRegionSection tmp = *rdl->section;
> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            continue;
> +        }
> +        rdl->notify_discard(rdl, &tmp);
> +    }
> +}
> +
> +static int
> +ram_block_attribute_notify_to_populated(RamBlockAttribute *attr,
> +                                        uint64_t offset, uint64_t size)
> +{
> +    RamDiscardListener *rdl;
> +    int ret = 0;
> +
> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
> +        MemoryRegionSection tmp = *rdl->section;
> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            continue;
> +        }
> +        ret = rdl->notify_populate(rdl, &tmp);
> +        if (ret) {
> +            break;
> +        }
> +    }
> +
> +    return ret;
> +}
> +
> +static bool ram_block_attribute_is_range_populated(RamBlockAttribute *attr,
> +                                                   uint64_t offset,
> +                                                   uint64_t size)
> +{
> +    const int block_size = ram_block_attribute_get_block_size(attr);

size_t.

> +    const unsigned long first_bit = offset / block_size;
> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
> +    unsigned long found_bit;
> +
> +    /* We fake a shorter bitmap to avoid searching too far. */

What is "fake" about it? We truthfully check here that every bit in [first_bit, last_bit] is set.

> +    found_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
> +                                   first_bit);
> +    return found_bit > last_bit;
> +}
> +
> +static bool
> +ram_block_attribute_is_range_discard(RamBlockAttribute *attr,
> +                                     uint64_t offset, uint64_t size)
> +{
> +    const int block_size = ram_block_attribute_get_block_size(attr);

size_t.

> +    const unsigned long first_bit = offset / block_size;
> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
> +    unsigned long found_bit;
> +
> +    /* We fake a shorter bitmap to avoid searching too far. */
> +    found_bit = find_next_bit(attr->bitmap, last_bit + 1, first_bit);
> +    return found_bit > last_bit;
> +}
> +
> +int ram_block_attribute_state_change(RamBlockAttribute *attr, uint64_t offset,
> +                                     uint64_t size, bool to_private)
> +{
> +    const int block_size = ram_block_attribute_get_block_size(attr);

size_t.

> +    const unsigned long first_bit = offset / block_size;
> +    const unsigned long nbits = size / block_size;
> +    int ret = 0;
> +
> +    if (!ram_block_attribute_is_valid_range(attr, offset, size)) {
> +        error_report("%s, invalid range: offset 0x%lx, size 0x%lx",
> +                     __func__, offset, size);
> +        return -1;

May be -EINVAL?

> +    }
> +
> +    /* Already discard/populated */
> +    if ((ram_block_attribute_is_range_discard(attr, offset, size) &&
> +         to_private) ||
> +        (ram_block_attribute_is_range_populated(attr, offset, size) &&
> +         !to_private)) {

A tracepoint would be useful here imho.

> +        return 0;
> +    }
> +
> +    /* Unexpected mixture */
> +    if ((!ram_block_attribute_is_range_populated(attr, offset, size) &&
> +         to_private) ||
> +        (!ram_block_attribute_is_range_discard(attr, offset, size) &&
> +         !to_private)) {
> +        error_report("%s, the range is not all in the desired state: "
> +                     "(offset 0x%lx, size 0x%lx), %s",
> +                     __func__, offset, size,
> +                     to_private ? "private" : "shared");
> +        return -1;

-EBUSY?

> +    }
> +
> +    if (to_private) {
> +        bitmap_clear(attr->bitmap, first_bit, nbits);
> +        ram_block_attribute_notify_to_discard(attr, offset, size);
> +    } else {
> +        bitmap_set(attr->bitmap, first_bit, nbits);
> +        ret = ram_block_attribute_notify_to_populated(attr, offset, size);
> +    }

and a successful tracepoint here may be?

> +
> +    return ret;
> +}
> +
>   RamBlockAttribute *ram_block_attribute_create(MemoryRegion *mr)
>   {
>       uint64_t bitmap_size;

-- 
Alexey


