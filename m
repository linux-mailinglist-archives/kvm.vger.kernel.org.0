Return-Path: <kvm+bounces-58183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F18D0B8B0DD
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:09:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7C89563827
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 19:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 187F22848BE;
	Fri, 19 Sep 2025 19:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KpfC5I06"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013021.outbound.protection.outlook.com [40.107.201.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AF8280CC8;
	Fri, 19 Sep 2025 19:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758308980; cv=fail; b=fcXGOXAzbsnC2MNj2cCkIuPT+JqvPB1iEmz8kDEdVhkm/E/gidTjT4sJ4u4GCRn9YlRveIcuddzleQ0ldFwuqZbzNd5yJR/cQrt1ScDVAJ6NmOIvVmCaEsxU9QwQhN60LohkajnqDPLpNEV9xwm26wbZgK0G3Q8FljMN1fdDa4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758308980; c=relaxed/simple;
	bh=RT8Ihz5syZjahrXEBJKzSlo7t1BbvxWc8WRkCCfb7fk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AH9t2XBw7CRekMRbEzISnWJMGP3vm7296UR6rcGm1czc0qNPyaNxZ5Rd6p/FZfAF6Wzx2IF7NZE82IgKiiSxoNpQHV3Ihj2ZreMZLWFjFpInKZrxMc30mF9Zc3z5h7OUOAD6OLjcu7i1mAW8g8H++XVRFtstbgNIBwtoybQZrJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KpfC5I06; arc=fail smtp.client-ip=40.107.201.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L+SSnZ84j5/ZvDXeOP8q69Xnw8AW0t8UC0ZlFdpV3pTqJYYM+UxjUHbBY+oh1Bse8wmPYYvcwN04PZRwLx8Y0NGsFOKJqLFnKT37z9YsdxhDdw4aNv65uaXj5l0cNRfL+vxxjiKxcPqrISRKNxT57zhzUv2uHyGUEjVMu/cDdqJFtTOQR+E7BiNez3qC27NuhiI0lPmnTrDxD07xJyZjMgwyc5D+wzIhNrU6So51mC/rSbuiJZGjhed0eiq49FMSon0U+85NGh5YY/z+oKQ+pUb6krFXRBwsR1Rvxii4WjwxnkQNYEAl0h7vDZcqGlV/kmAcMqtadwokGIUb5fvT3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Oacb69oYt4Aj6D057s8c0/kvasioPVNYRTs+0jZAZw=;
 b=d76VqsprSkt+5MS9AZEwDnR2k6lmMBBES/QsP2mVtsiRa7q1vXfk9EJGe/HznUQOv1rtL+d4Nt5UnwPUWBpjSlMAxjZwxczH1XgqE9fujU/cOtaxcfr2GaKRw7B8sRHHLfqZTnM5G/UF9skb6PeiJYEeVJcaCaQj5W4D3eTQqsVrhe+X7+OSw7druvMcCVbD9O9lzLthzdH1LSTu9xhB/Mm0pNIHPFBszjUEO8kdl7axuGmLytiLpdZDdoV+lxk4jLohpdJHleJbLWxLX4iW5viVg+wZeOnHsyh2j2G8Lg+sp8URY4nP2Pg+aOmmhHrCTW95N7bDv2qJmXFoXNqH5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Oacb69oYt4Aj6D057s8c0/kvasioPVNYRTs+0jZAZw=;
 b=KpfC5I06/q+AkQCVmUx21O+O8atPSNtBky5fReV4w5MpGKCji2byOIgFz40jXUQjZiSwltJAu5nNC5oY7exYcxnv9nXsODqF9FZG7JKZVtY/nshssp7uPmCJMWDdh+iwuhU9+HcssECULXFMejV+hY1d+SJ/IAq4XbGIKAWGJcg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by CH3PR12MB7665.namprd12.prod.outlook.com
 (2603:10b6:610:14a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Fri, 19 Sep
 2025 19:09:33 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9115.018; Fri, 19 Sep 2025
 19:09:32 +0000
Message-ID: <2e8e0424-71fd-4b4c-953f-e3979f4533a4@amd.com>
Date: Fri, 19 Sep 2025 14:09:27 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/10] fs/resctrl: Add user interface to enable/disable
 io_alloc feature
To: Reinette Chatre <reinette.chatre@intel.com>,
 Babu Moger <babu.moger@amd.com>, corbet@lwn.net, tony.luck@intel.com,
 Dave.Martin@arm.com, james.morse@arm.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, kas@kernel.org,
 rick.p.edgecombe@intel.com, akpm@linux-foundation.org, paulmck@kernel.org,
 pmladek@suse.com, pawan.kumar.gupta@linux.intel.com, rostedt@goodmis.org,
 kees@kernel.org, arnd@arndb.de, fvdl@google.com, seanjc@google.com,
 thomas.lendacky@amd.com, manali.shukla@amd.com, perry.yuan@amd.com,
 sohil.mehta@intel.com, xin@zytor.com, peterz@infradead.org,
 mario.limonciello@amd.com, gautham.shenoy@amd.com, nikunj@amd.com,
 dapeng1.mi@linux.intel.com, ak@linux.intel.com, chang.seok.bae@intel.com,
 ebiggers@google.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org
References: <cover.1756851697.git.babu.moger@amd.com>
 <2cc1e83ba1b232ff9e763111241863672b45d3ea.1756851697.git.babu.moger@amd.com>
 <d18dc408-0a05-47b4-9126-19a7bd5fff6b@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <d18dc408-0a05-47b4-9126-19a7bd5fff6b@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0156.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::19) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|CH3PR12MB7665:EE_
X-MS-Office365-Filtering-Correlation-Id: 76125be8-5d88-4711-293a-08ddf7b010d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SlBMWERJN3FmUkhSbFlBbXdYR3BWVUs2WHgyWUFOdUpBQXpnQ2QyUkV4KzJ1?=
 =?utf-8?B?ZlJ6YjFCcFErMlZYdy8ydEVkK0dKOGU3RFJnZFdES1pwaTBiUUdReDBEbHd3?=
 =?utf-8?B?ZXJuSDY3bDJHTjR6TTh2UkUwamQyZ20vWFUrNFpuM1FoUndRK0pHZHFZdlFy?=
 =?utf-8?B?c0hmSzJFU2FuSExnTXFXcGJFYndkVTZTWkxNcmh1QkxxeHA5SHk4ZVdxcVkr?=
 =?utf-8?B?OEplZHRMaXRGckNhVzgvdlEvUHZVYlVUVmxUR0p0Mld4VzRsamo0RWtpcHVL?=
 =?utf-8?B?SUM4U0dzVlFJcXFsZGJGdFNmblNreHZ0M2VwTmtNM1lLdUVMOUFkZVhlNEM0?=
 =?utf-8?B?cEtFL0FxdUtBVzdsblVJa2tOcGgxQTZpemJhS2Zqb0kwR2VoN24wcWErRkR1?=
 =?utf-8?B?VWJWMkMxTlVtWTFCMS85SjRHcCs3VnNmd3NtVEtkMG5vck9sUkF3bmtxNnVB?=
 =?utf-8?B?eGJuOVk4c2xSMkpQak9xak1ETEpUWUJJRGlia1hzNlpoOVZOczJqLzIvaU43?=
 =?utf-8?B?VmlDemJrcCtxM0FCRklrVGdCRTJFWk5rQWUrUlJZb1UyRnQ5R1RyR292blVl?=
 =?utf-8?B?VnlKSGl2R2ZQVXczMVhxOEpRVjFKalZXTmdnWDdYSkVSR0JkQjFnVmlqTy9x?=
 =?utf-8?B?OEs2Z3lHYkRMNjkzTmFwK1pzeUFIZ2c0TFF2QlRycUI4aVlrWmt5cDQrbU02?=
 =?utf-8?B?cUxIcWltVkNEWmtXV3FrdHY1bFgrUDhSL2tMZVJqWTRPZzhxRURWYjRBRktP?=
 =?utf-8?B?elA3ZkpJSXBqM1VnL1FieFl5Y3JieHJIeHhnaHN2enFvMnYrS1VGb3F0YThj?=
 =?utf-8?B?c1prdERSRkx6NDFOQ0ZXaVVFM1d1alBSa1ZDdXBuSXE4ajY2dnJiUEJuOXRL?=
 =?utf-8?B?OFp1VmlWY2hNdE9BU29XT3Y5OWJERmRPQk5zK1lEL1lsSWprdi9HT3hjeTNx?=
 =?utf-8?B?VHd3SGFNQmNyYk5VTkNaTjc1ZDVnNDUxWmNCK0tSN050M0phRG5GZkZuNlJE?=
 =?utf-8?B?TnhoWFFCQ0k0Z1FSalBvZG82YkpHNGJ3YVZXYkdwR3VZcy9Rci9LbUYySjZG?=
 =?utf-8?B?aU44bmdwMjZzZ2poUlFsTmNTZGVWL2xOR21zUjYxakFSeWlyaUFuZUtWV0ZI?=
 =?utf-8?B?UHpUcjNLMnRqVHIyRmp2Tm9YVE5xVmlUaExlb21TVE1yRnR5R292THNUNDBF?=
 =?utf-8?B?OC90YytxdWVJMTdVUzVqQmIweHUvWEcvbUs5c2JrN2pxR2hoU3F3MlRxeG5Y?=
 =?utf-8?B?R2M1cHRkTVJRaVJQanR2M0RNMnQwV1loS1d0VUFTcmVDYnRVTVh0bkd6VUVZ?=
 =?utf-8?B?ZGpaOTJuSFdGbWUxYWwwQWk0UU96dS8rai8rV1FoaDdFWEgzRW1Udm5OV1dW?=
 =?utf-8?B?UEZZcktuWHk4QnR3WjlteWJhTE4yU0ZycFlEWVgxOGxDOFE0ejRpVWN1RFdU?=
 =?utf-8?B?bCtmUUt6Q3ZsTDhNVHZSQ0ROL3RhVjhlVFppUW5uc1JvOVh1bmlhTitucnpM?=
 =?utf-8?B?dWFZTU00QkNPYTdsdWJZUE96a0lNdzdqbGFGemhOVlZ2ZGE0KzlIRHRRRTY3?=
 =?utf-8?B?Nm5HQlYvSkFhZE9jRmRvUU1UMlY4dS9ZVkhTTmtZWlQrQ0ViSXVJdytYMEFX?=
 =?utf-8?B?VlRvd3c1SGlGNmZUcWViZEJKSzJEVy9nMXB6Rk5JcTk4THVacXhTUWk2bkRx?=
 =?utf-8?B?U2ZENUtqSExMZGZ1NURYYmwwK3E5S3hoT1RrL1c4VDJWeE9YVFVQVlJrVW9u?=
 =?utf-8?B?SnlyV0lMaTBobEJLcUsvTnk4UHFUU0ZIbS9Td1MrZnNOK2VZZHdvZXVLYlkz?=
 =?utf-8?B?bFlia3g1TU5yKzgrMVFxSU9XMVMvQVB1eGdIU0c1b2hkcUNYU2NqdXpWalhR?=
 =?utf-8?B?djRiamUxWHJvbFJxL05UbGo4NTlXckJkQjVRbzJNUXZpNXgxdTBqRU1ab1c3?=
 =?utf-8?B?VkkxV1VTZFN6SE1KSERERFM4WGUxY1VXOGlldW8xaXczcHg2TTNkbXdBRW5n?=
 =?utf-8?B?YW5MWUI2bm5BPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MGMzVzlReXg0UnNtd3VjWjUxMGVMOFhQeHBwQ2JRNUxTWGdDaDQ2Zy9GM21D?=
 =?utf-8?B?VUdQSzhIM1ZXQnl4eTlFNVRYUlQrTk85VUZ5eGtBUmNPM3FMeDJMaDhrQTU4?=
 =?utf-8?B?eEgwWmNia05nZEd4djVVQlRkb2VXR1dRckIyWURKc3pFNlpaUlRHU0ZuZnNx?=
 =?utf-8?B?d2NnVTJnVDl2MEl1UC82MGlRU1djT3Q0RjhORUZDanNIMUlENFY3RWY1cU13?=
 =?utf-8?B?c1h5UW93SzY2S0lHOHB2a0ZUbW9VNlhVbU5USFVENERlK0IxVjJRSnlyaFZp?=
 =?utf-8?B?aStXVTZ4MkUvWktCVGVtSDZnSEh4RVhNRUZhL08rM0pKYWVnb2YxWitsaUlP?=
 =?utf-8?B?ZDYvY1RabCt0cWVXbStGRXljUjl6YTU0YjI4T3Z1UW9BN3ZxejY3Vmh0MDZJ?=
 =?utf-8?B?TE5zK3I2anJBK0hzN0JWbXh5S3N1VGcvTkpUc0syK3oreGJscVFiSFJzL1FH?=
 =?utf-8?B?YlRFdElKWUZ5dCtVRVA1YTNzS3JMNldURmx1cEYwbkxPeGxxZit1aDJneW5C?=
 =?utf-8?B?azVENnd4NThzb1ZDNTUvK25zcHdtQ3R5Tm1zRHFSZXQycmNFaHVOTnpjZmpo?=
 =?utf-8?B?T1g3aUdWZlZmQ2k1Uk5WOW9mYVJIRDFiMnQyeG9QcGhSUlpqSlJOSmZXMUtR?=
 =?utf-8?B?OGsrcC9URk9LaGZKREMyaytPUUZpUDNHL2tEbm8rTkxlL2tINGZ0dTdPYWZp?=
 =?utf-8?B?dkRhcXBGQWRVUitocmtsZlU4dit5ZTI4R000YkdSQk5xSHVKOTFJejMwOFFM?=
 =?utf-8?B?WGlsTGZRdFd0cVZpZ0IyNXFmSUdsdExHSlJCS2prdU9KSVBvaisrK0t4VmxC?=
 =?utf-8?B?bEFPMFVvcTZLMFFRbERxb1puVmhzWnBzRnFiRVZKbWtZSGFhMG8xa2lxRGtF?=
 =?utf-8?B?OXpmSWhya29IQTd2bTVGeGV4L3Y5WGZlZ3dMUjFicy82WHozbjNqVTIrVG16?=
 =?utf-8?B?UlpuNmo1b1dQRzNsMGw3eFRlRk02OCt1SjhHUE5qcUttSmlPb21MS2s4eU1i?=
 =?utf-8?B?aGYrNFo0YUpVSFV6WCtUa3B4Q2pGMzhDMEgvbXpoaWxkUWV2QWxBbEtSbHh1?=
 =?utf-8?B?YlhrTGhkbGNNWEpOTTFjMklEK0ZGOUhPbW9PdXViQUZOY1oyM0JyaFhaUlpN?=
 =?utf-8?B?Znd5UU5yS0JUM1V5SmtUa0NBRXZoa3JVTUUxN003VFNlVGEycy9VYU9QY1RZ?=
 =?utf-8?B?eWFkaTIwU1Q5RWpOQXFsUjlGc3V0VytpbFJPRWVCYTUzRHUwWnMzcmpodldn?=
 =?utf-8?B?ZTNIWWsrVlk2bmphYjlDWEtWTzk3Smx6Q0E4RFVmZHQxekJzeVpOVHdIUERn?=
 =?utf-8?B?NFJhRUxaUHZCc01FRXRvMEZQeXZOWlR4b1BZVlhwcnJ2aFM3OUw1eFd2QnNE?=
 =?utf-8?B?MlBmOEkzWU1IY2FtN1NwamI4RnhxZ3I2Mm50WDBaODVLWEczM3loM256WnB5?=
 =?utf-8?B?TVM2bWh5Ny9RUEgvb2VjMFFQTWk4Ulk0K2JhRnpoUFZ2aFQ2elZJelR6c3Rr?=
 =?utf-8?B?a1BNbWFNaFVSY0xaMDkzamFhTE5RaEZNTjd3ZVB0b0FxajRSWVc2cHQ3VnBL?=
 =?utf-8?B?UTYwai9PeGtvVXJXVzlPcDFvYUdTdnc1b3FFVlpDczJONTFJdnFjMkVET1d0?=
 =?utf-8?B?MFk3ZWJVQXprYTFTd2xqamxabHJoOGZDY3BhOUhWT0VFL3RWVDZxN1d3azdI?=
 =?utf-8?B?TjhhM1F1U2NCUVJ1VnR4N25ZVjVJenJMV0FXWUppT2dsSUtrcXRheDVaU1I5?=
 =?utf-8?B?NjVEY3JyZzkwRjJ5NXlGVFcwcGo2clVIYWVIdUFHWVQwV0szc1pRK3FIZFI1?=
 =?utf-8?B?SW9hbEdRUzVycXhtTlZ1QVdhYVJISVg1dmQrbHA5UWxUcUJDa2g3ZFZMT3Vr?=
 =?utf-8?B?RnVWMGJadXVhaFhKTFRrU0JMYkNnSFFMRmNGTnhueTNENUFLM0pkc2hKS1Jo?=
 =?utf-8?B?RXFRUmRva0pKMWR2bkg0a0JXeXd3UTNxVmUrTDIvNWpzS3FwZWMybFNtc2JY?=
 =?utf-8?B?UjBZendtQzluZll0VWl4VkhuTDBXUVR4M09ROVIwV1RNQlFPWjh2SytFZWV5?=
 =?utf-8?B?WVFGNzB2dkZlZWgybG5iU0ZTdlg1eXJFSUhKSnluK3lGWGtOZXRWMmR0Ull3?=
 =?utf-8?Q?lpBjVe/XKfsGo3t3m0qXS7P2W?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76125be8-5d88-4711-293a-08ddf7b010d5
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 19:09:32.7220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9xFsbdK9s8Mp3wsR95X+hKA4rb6+72MsA4eGObzspEupGja2zhodnaQFnvF7ec4T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7665

Hi Reinette,

On 9/18/2025 12:37 AM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 9/2/25 3:41 PM, Babu Moger wrote:
>> "io_alloc" feature in resctrl enables direct insertion of data from I/O
>> devices into the cache.
> 
> (repetition)
> 
>>
>> On AMD systems, when io_alloc is enabled, the highest CLOSID is reserved
>> exclusively for I/O allocation traffic and is no longer available for
>> general CPU cache allocation. Users are encouraged to enable it only when
>> running workloads that can benefit from this functionality.
>>
>> Since CLOSIDs are managed by resctrl fs, it is least invasive to make the
>> "io_alloc is supported by maximum supported CLOSID" part of the initial
>> resctrl fs support for io_alloc. Take care not to expose this use of CLOSID
>> for io_alloc to user space so that this is not required from other
>> architectures that may support io_alloc differently in the future.
>>
>> Introduce user interface to enable/disable io_alloc feature. Check to
>> verify the availability of CLOSID reserved for io_alloc, and initialize
>> the CLOSID with a usable CBMs across all the domains.
> 
> I think the flow will improve if above two paragraphs are swapped. This is
> also missing the non-obvious support for CDP. As mentioned in previous patch, if
> the related doc change is moved from patch 5 to here it can be handled together.
> 
> Trying to put it all together, please feel free to improve:
> 
> 	AMD's SDCIAE forces all SDCI lines to be placed into the L3 cache portions
> 	identified by the highest-supported L3_MASK_n register, where n is the maximum
> 	supported CLOSID.
> 
> 	To support AMD's SDCIAE, when io_alloc resctrl feature is enabled, reserve the
> 	highest CLOSID exclusively for I/O allocation traffic making it no longer available for
> 	general CPU cache allocation.
> 
> 	Introduce user interface to enable/disable io_alloc feature and encourage users
> 	to enable io_alloc only when running workloads that can benefit from this
> 	functionality. On enable, initialize the io_alloc CLOSID with all usable CBMs
> 	across all the domains.
> 
> 	Since CLOSIDs are managed by resctrl fs, it is least invasive to make
> 	"io_alloc is supported by maximum supported CLOSID" part of the initial
> 	resctrl fs support for io_alloc. Take care to minimally (only in error messages)
> 	expose this use of CLOSID for io_alloc to user space so that this is
> 	not required from other	architectures that may support io_alloc differently in the future.
> 
> 	When resctrl is mounted with "-o cdp" to enable code/data prioritization
> 	there are two L3 resources that can support I/O allocation: L3CODE and L3DATA.
> 	From resctrl fs perspective the two resources share a CLOSID and the
> 	architecture's available CLOSID are halved to support this.
> 	The architecture's underlying CLOSID used by SDCIAE when CDP is enabled is
> 	the CLOSID associated with the L3CODE resource, but from resctrl's perspective
> 	there is only one CLOSID for both L3CODE and L3DATA. L3DATA is thus not usable
> 	for general (CPU) cache allocation nor I/O allocation. Keep the L3CODE and
> 	L3DATA I/O alloc status in sync to avoid any confusion to user space. That
> 	is, enabling io_alloc on L3CODE does so on L3DATA and vice-versa, and
> 	keep the I/O allocation CBMs of L3CODE and L3DATA in sync.
> 

Looks good. Thanks

>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
> 
> ...
> 
>> +ssize_t resctrl_io_alloc_write(struct kernfs_open_file *of, char *buf,
>> +			       size_t nbytes, loff_t off)
>> +{
>> +	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
>> +	struct rdt_resource *r = s->res;
>> +	char const *grp_name;
>> +	u32 io_alloc_closid;
>> +	bool enable;
>> +	int ret;
>> +
>> +	ret = kstrtobool(buf, &enable);
>> +	if (ret)
>> +		return ret;
>> +
>> +	cpus_read_lock();
>> +	mutex_lock(&rdtgroup_mutex);
>> +
>> +	rdt_last_cmd_clear();
>> +
>> +	if (!r->cache.io_alloc_capable) {
>> +		rdt_last_cmd_printf("io_alloc is not supported on %s\n", s->name);
>> +		ret = -ENODEV;
>> +		goto out_unlock;
>> +	}
>> +
>> +	/* If the feature is already up to date, no action is needed. */
>> +	if (resctrl_arch_get_io_alloc_enabled(r) == enable)
>> +		goto out_unlock;
>> +
>> +	io_alloc_closid = resctrl_io_alloc_closid(r);
>> +	if (!resctrl_io_alloc_closid_supported(io_alloc_closid)) {
>> +		rdt_last_cmd_printf("io_alloc CLOSID (ctrl_hw_id) %d is not available\n",
> 
> %d -> %u ?

Sure.

> 
>> +				    io_alloc_closid);
>> +		ret = -EINVAL;
>> +		goto out_unlock;
>> +	}
>> +
>> +	if (enable) {
>> +		if (!closid_alloc_fixed(io_alloc_closid)) {
>> +			grp_name = rdtgroup_name_by_closid(io_alloc_closid);
>> +			WARN_ON_ONCE(!grp_name);
>> +			rdt_last_cmd_printf("CLOSID (ctrl_hw_id) %d for io_alloc is used by %s group\n",
> 
> %d -> %u ?

sure.

Thank you.

> 
>> +					    io_alloc_closid, grp_name ? grp_name : "another");
>> +			ret = -ENOSPC;
>> +			goto out_unlock;
>> +		}
>> +
>> +		ret = resctrl_io_alloc_init_cbm(s, io_alloc_closid);
>> +		if (ret) {
>> +			rdt_last_cmd_puts("Failed to initialize io_alloc allocations\n");
>> +			closid_free(io_alloc_closid);
>> +			goto out_unlock;
>> +		}
>> +	} else {
>> +		closid_free(io_alloc_closid);
>> +	}
>> +
>> +	ret = resctrl_arch_io_alloc_enable(r, enable);
>> +
>> +out_unlock:
>> +	mutex_unlock(&rdtgroup_mutex);
>> +	cpus_read_unlock();
>> +
>> +	return ret ?: nbytes;
>> +}
> 
> Reinette
> 
> 
> 


