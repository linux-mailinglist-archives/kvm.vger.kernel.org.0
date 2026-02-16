Return-Path: <kvm+bounces-71128-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cJdgJF1Ak2kg2wEAu9opvQ
	(envelope-from <kvm+bounces-71128-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 17:05:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E1B6145EA9
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 17:05:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 056953019113
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 16:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C88AE3328E3;
	Mon, 16 Feb 2026 16:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YXx4rigq"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013014.outbound.protection.outlook.com [40.107.201.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D7A30F542;
	Mon, 16 Feb 2026 16:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771257935; cv=fail; b=Gosi6ZNc4wkWeBDckEP1RcPFaNU7Ok2cNMXbWpOVpOKZwFO5zCzRwme5BjfmRiafAjBq7HrtIcR/84WG4s3AGhx1QHqJhisTKJdkcU4xDRLEtWxPCacX+rHYlq73MHDveCxNDPqINXZz+FffF3VPlu84fBkJdH6oCS6lDT0zzqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771257935; c=relaxed/simple;
	bh=R1EWybFBKQH4ftsHKg4bSRcUaDfN0rjKKKMhxVc2Vdo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SvQuSRWhYeeWn59LNd46tCn9/dKCSv6+7EZUyPL/MB5+PRDWQajhEnce7iPjebCiTNHlttqaZE0Pp/6/VHph1ST1nO9Hwsd+6hbbO7ylozYOTIN3qRAL2TmHhR25E+YJ3Blr6aC2GI4NUnq1/FKOUf4s/JvJ4JnSFTiQvEQkOQA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YXx4rigq; arc=fail smtp.client-ip=40.107.201.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S7Lqx4hxIG1KsJIwV/c5eI/YSoYlBFL0YtyEqjhjnfiCWDgR9HlLJJJYYVAxuMVzE16C9EEQb20XCY3JYOeaS1bggoeYcX6F1rQtsKfTu6+aeYdB4SFISeIXe15Kzo0FhcaO/T4IMvZ/ke74YHvUygmhDwAk556jExWeNphqmFXXlnpd4atoUPN34OpvUf19eSYWCbvbKj0N2fXNQyxDSKORG2syUoB/70U+pspRoxfF3PbJy2Hc6MkuIWg4xPY4KiotFXozJRNcZ8RNEGrX96fdy3rgfu6tdXkBZMK0yAOGvQjgru4DMm8Ig5j2AGyR6POCGuuXwAkZzeYNnOk69Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qUCaZfovWoVMox9c/HvTBAHXAmaK4VwCv++p429dpPM=;
 b=U9HEAVMeGdVe4uj/tzkx6BSq+XO5BTQC8ldiwYI5LZw1xOGXLozD9qsOoBPiFNo9c8xreB602AbFtvtnFWsA1B1RC9EkqNDtXa+7vsKvkMBaE1yr6qvjuosWH3Zejj/KhMpFvpBz/Ynb23Qd4kLzSZhUWFmXJdXHl/A0y+dxA/vtUlFnKZQZAaSZW228L5wAUJiwGFRhyy11plyKsuHFJMgP9Su338b7wMVALhyGq9jSiC6N2K0y+0DwoL4HYCZHMFWUTLF0X2X0TZGkrwFRkyKCNFN4fYevIYujvPPgDIeMdMHF68HWWyu54q1ESXgYQKUuQJ5KV/t3VBQHyX/Urg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUCaZfovWoVMox9c/HvTBAHXAmaK4VwCv++p429dpPM=;
 b=YXx4rigqXv14Wp9GBE0HKtJhOVIiUckPDgXQ8Iaj13kW3pCiC0O9f4QU9kubN0niu1Qyd9QH8jA99C3o4V4jeJBIkCWCMNm8P6mAHsHC7Xk0qfzfULZM0CxeaiV213BRhGjBfiaaYEAyMXnEbo0HsxgV4Jc1tyleGuFmZ0sqB7o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by SA3PR12MB8812.namprd12.prod.outlook.com
 (2603:10b6:806:312::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 16:05:27 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9611.008; Mon, 16 Feb 2026
 16:05:27 +0000
Message-ID: <4ed30838-0cf3-4db8-8925-503afd6e4d80@amd.com>
Date: Mon, 16 Feb 2026 10:05:23 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global
 Bandwidth Enforcement (GLBE)
To: Reinette Chatre <reinette.chatre@intel.com>, "Moger, Babu"
 <bmoger@amd.com>, corbet@lwn.net, tony.luck@intel.com, Dave.Martin@arm.com,
 james.morse@arm.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, akpm@linux-foundation.org,
 pawan.kumar.gupta@linux.intel.com, pmladek@suse.com,
 feng.tang@linux.alibaba.com, kees@kernel.org, arnd@arndb.de,
 fvdl@google.com, lirongqing@baidu.com, bhelgaas@google.com,
 seanjc@google.com, xin@zytor.com, manali.shukla@amd.com,
 dapeng1.mi@linux.intel.com, chang.seok.bae@intel.com,
 mario.limonciello@amd.com, naveen@kernel.org, elena.reshetova@intel.com,
 thomas.lendacky@amd.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peternewman@google.com,
 eranian@google.com, gautham.shenoy@amd.com
References: <cover.1769029977.git.babu.moger@amd.com>
 <aba70a013c12383d53104de0b19cfbf87690c0c3.1769029977.git.babu.moger@amd.com>
 <eb4b7b12-7674-4a1e-925d-2cec8c3f43d2@intel.com>
 <f0f2e3eb-0fdb-4498-9eb8-73111b1c5a84@amd.com>
 <9b02dfc6-b97c-4695-b765-8cb34a617efb@intel.com>
 <3a7c17c0-bb51-4aad-a705-d8d1853ea68a@amd.com>
 <06a237bd-c370-4d3f-99de-124e8c50e711@intel.com>
 <91d50431-41f3-49d7-a9e6-a3bee2de5162@amd.com>
 <557a3a1e-4917-4c8c-add6-13b9db39eecb@intel.com>
 <f72a62af-e646-40ae-aa16-11c7d98ecf03@amd.com>
 <280af0e2-9cfb-4e08-a058-5b4975dd1d16@intel.com>
 <6e4fc363-7f3f-41fe-aaaa-fc60967baade@amd.com>
 <cd6b3030-50be-4e75-bd88-af306644cf7f@intel.com>
Content-Language: en-US
From: Babu Moger <babu.moger@amd.com>
In-Reply-To: <cd6b3030-50be-4e75-bd88-af306644cf7f@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:806:130::9) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|SA3PR12MB8812:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d961cd1-4ac1-434f-52ba-08de6d7532f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N1hEZU93d01xOXlhQUxiWjlXL1ZEVzhuMDV1MXh0T1BESjRHckZZbE5RUWNX?=
 =?utf-8?B?UmM0ZlVXbStFdTRkSk5rcUJHelA0UjZXSlo5U2lObFFHVVZjUldob2U0amhI?=
 =?utf-8?B?WXAyOE5uYTBmK2VGWjFRaXJGN3RKcEY4bnhKbHdXNVBVb1habDEvc0k2V29s?=
 =?utf-8?B?UlU4Y3pxcFdkc2htK3lIVWw2akVLTi9scUx4OUYycFR0cUVsRkUrcXREdlJt?=
 =?utf-8?B?ZGxjTlRzTmJBTjlCNmRhVWR1MUh4TzF4UlpGb3c4WUlJMHQzdzNhZ2Y1QTcx?=
 =?utf-8?B?TlBnUzJaVWJJeW5mR3V3MEp3RktxMFVzdU9lRlZXeGgxWnRzc1RlRXBUWElD?=
 =?utf-8?B?UklQVlg4V0dhK1F1OEZqbXgvcjRPUHN5ckZjT0NOWHBBN3hkU0JteWtpYWJW?=
 =?utf-8?B?c2k0V3BPdVdyazRjc0ZlN0VTWGFTTVpSV05TT0dlb01CS09GMmtaNlo1elRm?=
 =?utf-8?B?RHJXTExiRDdjUkRSVktGR1hPZWQvRnFtUm9Qb2RkMGxVRVRYQ1Y1bER5Rkcv?=
 =?utf-8?B?V1hLWUdIMkxma0RFaGUwRzkyVDJkMWExL1QvS1huWmU0WjBQbE1qMGNRTllV?=
 =?utf-8?B?WHlHUmFtY1I4MWp4eGFzTFh3bFk1N2t3VERYYnY5RTBsWDVzd01vMUJIRjhr?=
 =?utf-8?B?NU1pN0FDRGxBdGwzZHU1TG8wL0I3Q3VzaG9KOXhXQWhpQnppRXlHT3hvWDA1?=
 =?utf-8?B?Vm13OTl2LzBDZjY3UVZ4OUpXdFczUlhKWGx2bmhWUnZFbTJmMFpKQi8wbld2?=
 =?utf-8?B?WDZLNTdidzBWOERaSThPaXRselIxdDNqS0JxRzR2TElnWU1tSlVsZWwzNVc0?=
 =?utf-8?B?UnBZWHNxbmZ0YjFCS3JGbnlMOFBWTkZWRlZYWDh4UkE0K1d5YWxHVDVXMEV6?=
 =?utf-8?B?RzBiWlBxNGM4cHpDcGtPUytOMVhpZFpma09FWUUxK1dva0hIUkl4S2ZVVWNT?=
 =?utf-8?B?ZlF4N2JmM1cwZ0JPY2dkK3JiNWRmL1orZWQxQi9pR3NSWHk2ZVlNV090YkFI?=
 =?utf-8?B?VzBISG05YVZJYVRDN0J0M21MUUhTU3dYK29aQ2JFek5yM0RVWUkyMEg5bk1s?=
 =?utf-8?B?RGxiWXJIblQ2dVgyWGY3K0xOY0M1WDdRVUNRemdIZ1IzZkNRZkZpeWtDbndx?=
 =?utf-8?B?bDZqeEZGZXgzWGFXQ3Q0QUliVnk3OUpkZndJNkloaENBaUxTTHpyTnZ6d01V?=
 =?utf-8?B?VGpvcndha0l2YU1lVFVzL1NVZTl5NnkxaXZBL05YdWQwWXdyZGxlSi9XU0tz?=
 =?utf-8?B?OXZVNitiUUZSUGgzVWNGRkxvTnNEbkN1dEpoT2NEYmFNajk2eDNncGQyRUx6?=
 =?utf-8?B?Y2owUmwrQWJHSUtlcmNZU25mdUZNcnh2RXlqcnY1VEZjRWFlRERkSVpiR0lN?=
 =?utf-8?B?WmJ4eTZUU3JmVUhHNVZMRkdGcFNVdlkxanRBdS9ja0ZPT0QzUExKdHFhUmt2?=
 =?utf-8?B?b1czSnVacVYyUHdIU3JQdDZzQUhrVmRZRm9oK00vOHR6NUJ4M0ppWm9ZVjlw?=
 =?utf-8?B?amUzaTF6b3BRcE8vT1hPMFBLdzQ2ZEpLTGgrSm1yL2xOSEhVVWpPditXZW9j?=
 =?utf-8?B?RzdwRFFMSWFEdmVYTXA3ajh3NzBScWxJYitlcXVEejk2S09uSUptdUgrQmJs?=
 =?utf-8?B?WTMrVHgrNy9vSVcraVgyVitmQUprYVNWdG9zUHc5dDRrSkhGZk5Cc0dleGth?=
 =?utf-8?B?QUdJN1NtOGlNZ0ZoaXZzcURZa1NBeTJldzZKRDU3WUV3Uzd3QS9FSTdJZVUr?=
 =?utf-8?B?UGg3UjlWL0h5NFFEYTdqQ3JtTUNzeFhpa1k2MjZpb2kvZGMzQ2FPR3MwN21t?=
 =?utf-8?B?MXhiL1dvWFliZTlLY2VTYU0xMFZMQ0gwY213WWxXRDU5N3p1elAxOTlvODJ2?=
 =?utf-8?B?ZDlpQk9SSWxuWi91eDRsd3BvU3VPazRkVGNiNTg2b0plRkpCd1RoTW5wZDdC?=
 =?utf-8?B?VFhuWTBCcGFoL0paNlRSckpDQ1BQdys1bnA2ekhZYTR3VE1MVWtORlZ2UGVK?=
 =?utf-8?B?ZjE0cDNDNkwwNHE0YWNiNTYyQUhRTjl3MjZ4RThHYko1dzhSWGRmU3l5L2Ew?=
 =?utf-8?B?WTVzRG92UnV2a0F4aFdYRlZsUXFobDROUWlndklNWWtKRWRJR3d1TFJ0Mld3?=
 =?utf-8?B?R3lPZ1FQUWZvZzE3VTVzNjBSMzFxK0ViY3hlVW1xUzVzR0tyL3F2ejF2TEla?=
 =?utf-8?Q?jxsYcKy9WZ4VLgRKLSelpy4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZHF3RGpwaEtCNllrMTN4QzJSRk43RHpQL0N5UEtUOUhDUnZKN0xJUEI4R1JY?=
 =?utf-8?B?dlN0VG9XbW5lL3prTnlybzFNbWZud0dPNE1QdW5ja0hxd1ZEUFJyMEVSMW43?=
 =?utf-8?B?ZGFCaTZISnI4WnlST24zMC9lT3p0K2tHWDd4OXBsa3hWS1g3WisyMVJsSFdI?=
 =?utf-8?B?TFZrei9SUENRZnJTdUlielh6c1Jzb2FFVDBwdFAxb2tyMjM1NnJYZEQ2Y01o?=
 =?utf-8?B?OG54UkNTVnVYYWwrY3BDY01rT1BUaHFOUmR4SU9qeWI1NDNFY3lMOWxGVUtW?=
 =?utf-8?B?MmE2WUdoZWlISUlxcDFiRHI0NkFlUm1NT0dCaWNtM0dPNk02T1JjU2c5QlZQ?=
 =?utf-8?B?M0JWMDRLS1JxcFBSdEhDT200aEloZWpPQ2tDcCtnVFZveGo2VTNSamJIYkpG?=
 =?utf-8?B?aXNUUWkzVS9IaUwvY0JaWEFtT09ISlRrWVRUeVdJOUJtUTI5aDdBdk1mRitZ?=
 =?utf-8?B?YXVyQTFaRXVLRDVyeXNWNW4yUk1jQU1CK1B4aEl2VXQ1OVdqZ0l4UlJIck9I?=
 =?utf-8?B?YmtHdnppbTZkbnpNRk1lTFZBMVRNeHRvOGpSbjZHV2ZBVmhvenlJMFZ2WUVM?=
 =?utf-8?B?MG5icDFhRGxzajBkM25rMEVwYnVnbkdRWmo1bDJTQ0xoWTRzNGljUkZqR1d1?=
 =?utf-8?B?TkNTMlZxT0JNdVdGVFpoSW5LZDhwQ3RVSmRKME9oaG9kajBmdGdKc3Z4dEt3?=
 =?utf-8?B?UVRKQWxLZ2I0NGhLVTVDcjZFTWdoaW1xd24wRFpIRmhGRjZseUFVNXRRVGR4?=
 =?utf-8?B?N2t0aUFMNHhzWlhRTU9FOWhQOVg1ZjVkUTc3ZTlVdEFnZFR0bWNJaStmNDlu?=
 =?utf-8?B?cjZPMDBPR3dRYzJrMHM3eStvckVwK052MmNBLy9BdWh1dGNRU2k5REliTjNq?=
 =?utf-8?B?cXFCclVldW5IQ1NUYjEyWnprOGlNVWFnd08wc0k2eXJxNmxGOUMwaE1oWHg5?=
 =?utf-8?B?cFNpSkZpTjU5anJRRE9NNFhxK250bTFBcnprQmtMSXRXV3BOaGRvK01uL2Fn?=
 =?utf-8?B?L3BNZUNXeFpZNForUnZzdU40dHZPMXlOSE5DczR0VW1xYnBkT25VQWFNYlZy?=
 =?utf-8?B?d25qcFREQTQzWmxwTjBKNm40YnhGdFhNM1ZmTnk5TURiS3BtVkFjT0tmM05K?=
 =?utf-8?B?UkM2Nmh4ZlpIbFlSNE5SS3RvRjdubHlGc2NZZDVZc2I5R3dXS3kzSlQzamJp?=
 =?utf-8?B?QlZoQ0lsTjFCaHkxSTJqekVoZVdGSFBGVmdMRFpNNzB3MEk4QU9QY3lQdFZ0?=
 =?utf-8?B?R0pmSkxXZktsMkRmYXlMdWtEUDdVNjE2aHNLNDRKZTUvU1JpVjF3dDBoZFRn?=
 =?utf-8?B?QkdZaE5YdFdWSHI4aTVBbE1hd2RrV0pqRTlTUjI5NklmOHk1cmxJVm9nREpz?=
 =?utf-8?B?UWhvblpSaVl0S1d5YnBjcHpiK0tQdjNRT2lqczR3dXg1Z2hWbWdxRTVySTJa?=
 =?utf-8?B?T1FLSHFaNUtDRDVib0lyOU1EZ0JpWW5SeVBIbzFGVnBFYVB4R3Z6RktkV0k5?=
 =?utf-8?B?ZXUxcUFqNnlmUUl3cEhaZmVic2NvckVXRnlIdU5TYkJqdVFzY2hKM0M4T1Nq?=
 =?utf-8?B?ZWd6NHNsekpVdndGaG5SSlIrN3hXWkk5TFY4ckNjSmlXSDdBQ29heWZ5VHVR?=
 =?utf-8?B?Q1hhWkNCalRqOXE3RmtsV3ljMVBSU1RKVHRVdlF2NnNUU1ZJN0RYOWcwWUMv?=
 =?utf-8?B?eUQ2K0NlL2xWV3lkUytsRmIwZGRiRzlHUTkyQ0hhUlVRWlFuQ3dOQThiRTd1?=
 =?utf-8?B?Y2JqbVI2RGVIaHIvck8xK3JsWlNXa3dKQkdBVzA5ODR6SjY3V2hWMmthVEpt?=
 =?utf-8?B?K1BtRVlLaEhTSExoM1Z2VFA2QWwvREtUSVR1dTducEg3Qm1GaGxnUTBlRDdO?=
 =?utf-8?B?WmVrRFI2MUFMQVBnTEVwRlQ5N3ZDR2JnUjQ2RmgraGtmRVAyZGp3ZEZBRGkz?=
 =?utf-8?B?UURxaVdUcUI3bGZLY0dZS1M4bUJvWUJVeC90UmdoRWdFUWRiTTZBenp0ZFdl?=
 =?utf-8?B?aFdLcVNBKzgzL1RjTkpjQTJKcS9KOEc4aGYrTG10NWNtTjlSTDBUUUpsdDhr?=
 =?utf-8?B?c1RJOEJ4WUI1ZFhQRCtWSUlxbFozRTdGUDhOdUlMUzFyVXNWd3RQaHkvQ2Vm?=
 =?utf-8?B?MmZOTU1MUkkwelhPRjg3cC8yTm02TjlzT0o3OGhNSExsYm0vVjk2NlBBTWhl?=
 =?utf-8?B?OWYxVGxuUUZ0KzNKZFQ5RSswMUpXTklLOFE3K1RiUFVnbUVDRU9MMk04UXJC?=
 =?utf-8?B?K0ZDbHVWMTVtNmRtdXJvTDZEa05NWkNTQU9FSUt6TUxjN3E3bnZiaDdlWk9r?=
 =?utf-8?Q?nakZrb3I2K9kcE02GV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d961cd1-4ac1-434f-52ba-08de6d7532f8
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 16:05:26.9200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bMEJB+hXrm+cCqENCPZc3+XooHQzpwZJkh1xWKkGGAmQ33RILpmMzA0+9tkknbL8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8812
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_FROM(0.00)[bounces-71128-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[babu.moger@amd.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: 2E1B6145EA9
X-Rspamd-Action: no action

Hi Reinette,

On 2/13/26 18:01, Reinette Chatre wrote:
> Hi Babu,
>
> On 2/13/26 3:14 PM, Moger, Babu wrote:
>> Hi Reinette,
>>
>>
>> On 2/13/2026 10:17 AM, Reinette Chatre wrote:
>>> Hi Babu,
>>>
>>> On 2/12/26 5:51 PM, Moger, Babu wrote:
>>>> On 2/12/2026 6:05 PM, Reinette Chatre wrote:
>>>>> On 2/12/26 11:09 AM, Babu Moger wrote:
>>>>>> On 2/11/26 21:51, Reinette Chatre wrote:
>>>>>>> On 2/11/26 1:18 PM, Babu Moger wrote:
>>>>>>>> On 2/11/26 10:54, Reinette Chatre wrote:
>>>>>>>>> On 2/10/26 5:07 PM, Moger, Babu wrote:
>>>>>>>>>> On 2/9/2026 12:44 PM, Reinette Chatre wrote:
>>>>>>>>>>> On 1/21/26 1:12 PM, Babu Moger wrote:
>>>>> ...
>>>>>
>>>>>>>>> Another question, when setting aside possible differences between MB and GMB.
>>>>>>>>>
>>>>>>>>> I am trying to understand how user may expect to interact with these interfaces ...
>>>>>>>>>
>>>>>>>>> Consider the starting state example as below where the MB and GMB ceilings are the
>>>>>>>>> same:
>>>>>>>>>
>>>>>>>>>        # cat schemata
>>>>>>>>>        GMB:0=2048;1=2048;2=2048;3=2048
>>>>>>>>>        MB:0=2048;1=2048;2=2048;3=2048
>>>>>>>>>
>>>>>>>>> Would something like below be accurate? Specifically, showing how the GMB limit impacts the
>>>>>>>>> MB limit:
>>>>>>>>>           # echo"GMB:0=8;2=8" > schemata
>>>>>>>>>        # cat schemata
>>>>>>>>>        GMB:0=8;1=2048;2=8;3=2048
>>>>>>>>>        MB:0=8;1=2048;2=8;3=2048
>>>>>>>> Yes. That is correct.  It will cap the MB setting to  8.   Note that we are talking about unit differences to make it simple.
>>>>>>> Thank you for confirming.
>>>>>>>
>>>>>>>>> ... and then when user space resets GMB the MB can reset like ...
>>>>>>>>>
>>>>>>>>>        # echo"GMB:0=2048;2=2048" > schemata
>>>>>>>>>        # cat schemata
>>>>>>>>>        GMB:0=2048;1=2048;2=2048;3=2048
>>>>>>>>>        MB:0=2048;1=2048;2=2048;3=2048
>>>>>>>>>
>>>>>>>>> if I understand correctly this will only apply if the MB limit was never set so
>>>>>>>>> another scenario may be to keep a previous MB setting after a GMB change:
>>>>>>>>>
>>>>>>>>>        # cat schemata
>>>>>>>>>        GMB:0=2048;1=2048;2=2048;3=2048
>>>>>>>>>        MB:0=8;1=2048;2=8;3=2048
>>>>>>>>>
>>>>>>>>>        # echo"GMB:0=8;2=8" > schemata
>>>>>>>>>        # cat schemata
>>>>>>>>>        GMB:0=8;1=2048;2=8;3=2048
>>>>>>>>>        MB:0=8;1=2048;2=8;3=2048
>>>>>>>>>
>>>>>>>>>        # echo"GMB:0=2048;2=2048" > schemata
>>>>>>>>>        # cat schemata
>>>>>>>>>        GMB:0=2048;1=2048;2=2048;3=2048
>>>>>>>>>        MB:0=8;1=2048;2=8;3=2048
>>>>>>>>>
>>>>>>>>> What would be most intuitive way for user to interact with the interfaces?
>>>>>>>> I see that you are trying to display the effective behaviors above.
>>>>>>> Indeed. My goal is to get an idea how user space may interact with the new interfaces and
>>>>>>> what would be a reasonable expectation from resctrl be during these interactions.
>>>>>>>
>>>>>>>> Please keep in mind that MB and GMB units differ. I recommend showing only the values the user has explicitly configured, rather than the effective settings, as displaying both may cause confusion.
>>>>>>> hmmm ... this may be subjective. Could you please elaborate how presenting the effective
>>>>>>> settings may cause confusion?
>>>>>> I mean in many cases, we cannot determine the effective settings correctly. It depends on benchmarks or applications running on the system.
>>>>>>
>>>>>> Even with MB (without GMB support), even though we set the limit to 10GB, it may not use the whole 10GB.  Memory is shared resource. So, the effective bandwidth usage depends on other applications running on the system.
>>>>> Sounds like we interpret "effective limits" differently. To me the limits(*) are deterministic.
>>>>> If I understand correctly, if the GMB limit for domains A and B is set to x GB then that places
>>>>> an x GB limit on MB for domains A and B also. Displaying any MB limit in the schemata that is
>>>>> larger than x GB for domain A or domain B would be inaccurate, no?
>>>> Yea. But, I was thinking not to mess with values written at registers.
>>> This is not about what is written to the registers but how the combined values
>>> written to registers control system behavior and how to accurately reflect the
>>> resulting system behavior to user space.
>>>
>>>>> When considering your example where the MB limit is 10GB.
>>>>>
>>>>> Consider an example where there are two domains in this example with a configuration like below.
>>>>> (I am using a different syntax from schemata file that will hopefully make it easier to exchange
>>>>> ideas when not having to interpret the different GMB and MB units):
>>>>>
>>>>>       MB:0=10GB;1=10GB
>>>>>
>>>>> If user space can create a GMB domain that limits shared bandwidth to 10GB that can be displayed
>>>>> as below and will be accurate:
>>>>>
>>>>>       MB:0=10GB;1=10GB
>>>>>       GMB:0=10GB;1=10GB
>>>>>
>>>>> If user space then reduces the combined bandwidth to 2GB then the MB limit is wrong since it
>>>>> is actually capped by the GMB limit:
>>>>>
>>>>>       MB:0=10GB;1=10GB <==== Does reflect possible per-domain memory bandwidth which is now capped by GMB
>>>>>       GMB:0=2GB;1=2GB
>>>>>
>>>>> Would something like below not be more accurate that reflects that the maximum average bandwidth
>>>>> each domain could achieve is 2GB?
>>>>>
>>>>>       MB:0=2GB;1=2GB <==== Reflects accurate possible per-domain memory bandwidth
>>>>>       GMB:0=2GB;1=2GB
>>>> That is reasonable. Will check how we can accommodate that.
>>> Right, this is not about the values in the L3BE registers but instead how those values
>>> are impacted by GLBE registers and how to most accurately present the resulting system
>>> configuration to user space. Thank you for considering.
>>
>> I responded too quickly earlier—an internal discussion surfaced several concerns with this approach.
>>
>> schemata represents what user space explicitly configured and what the hardware registers contain, not a derived “effective” value that depends on runtime conditions.
>> Combining configured limits (MB/GMB) with effective bandwidth—which is inherently workload‑dependent—blurs semantics, breaks existing assumptions, and makes debugging more difficult.
>>
>> MB and GMB use different units and encodings, so auto‑deriving values can introduce rounding issues and loss of precision.
>>
>> I’ll revisit this and come back with a refined proposal.
> Are we still talking about below copied from https://lore.kernel.org/lkml/f0f2e3eb-0fdb-4498-9eb8-73111b1c5a84@amd.com/ ?
>
> 	The MBA ceiling is applied at the QoS domain level.
> 	The GLBE ceiling is applied at the GLBE control  domain level.
> 	If the MBA ceiling exceeds the GLBE ceiling, the effective MBA limit will be capped by the GLBE ceiling.

Yes. That is correct.

The main challenge is debugging customer issues. AMD systems often 
support multiple domains  - sometimes as many as 16.

If we replace the MB values with the effective MB values across all 
domains, we lose visibility into the actual MB settings programmed in 
hardware. In most cases, we only have access to the schemata values, and 
we cannot ask customers to run |rdmsr| to retrieve the real register 
values. This makes it difficult to diagnose complex issues.

That is  why we are recommending that the MB values remain unchanged.

Thanks

Babu


