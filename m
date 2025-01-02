Return-Path: <kvm+bounces-34481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 582FD9FF7CF
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 11:07:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 536B21882E9C
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 10:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E8C1A23BE;
	Thu,  2 Jan 2025 10:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oml0dg03"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CA438F82;
	Thu,  2 Jan 2025 10:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735812412; cv=fail; b=L6hqIuZ/tcmC78CEk6fDAGdmcPYaST3qc0z+9qXPnfXdc85BoEUzWiD36PbimmZzORBojHdkZCuDFxTrpJetiZ1+qkCn4yGedmvHkeG+GqEngiOEsSCBXTh5W3ibNwEdWCXT5QFoXGp5QIK0XB1sZa25Ymu2cK6wRH92KjsMFQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735812412; c=relaxed/simple;
	bh=xVOfk3RE5DwsuFAWgmnudcDsTEuaVNhF3r9GFPB4gNA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=USGuhV3nSMGBDbXJompH2PLT+zhmeeMVxSl22/y+6NEqkW5h3y2ZAo2enO/KsUc1T4FA8v+bqqRuPWbt6mrs4PWMs9++mg5WrVJX/B4nEm2criOiLiTBvZN9vDnmgWLa/HD4KdVU+bDSZNl0YMYdinDRKoF4FL+O4GuN+1YZgJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oml0dg03; arc=fail smtp.client-ip=40.107.94.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ReudcH6Y72eM32OjiyiMhBxeAVW4rsIjISrjbYy1M97bsO4Gw2wRdnZUy8QPB5RcrMsnIWtXzvXxwxAfBKeOQ2JaFDFiQ5khqeTAshrBt0d6bRan4Gjqc+BDwvijRLdSOjxzH3/AQeyQruGF8xfbhvs+WTH1k1fKJG1ZeS4M9JofpjYvOckvvf//H5+J2BRlKirFXZ48CWqZuI+GbKKHDHJCVOo9MvobV7o1K/dsdktPpE57T/hZmewXvvUymdKGdDuh62wh75BMV8YTu2HLlZkSE3GgmH9F2niNiJ7RlIt4obEgMtHz4qoitCCYDPEzU9pP2lJE3TRTq5sYSJp/tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vNAwMMEY0XKzSUa/YtfT79icoQeJ0AiTabh01iKdI2U=;
 b=p4BRfas8vUZlbsHWCRpLh/qSmmZwXcmCiiOJwpSdFDn21l5HNYcnUEkJUKwt+1aHIcIKVTIA+EKy7/ajCuAFZXOf4uax3EnpUcdCimU/as+hedIQaiG/ZXoumGSFJIvLbE0gKRD0XdZpkpAj2Mdem3MmVhNNQ0tqkJTT8ZdIqV/PVP+vtLdaoqleQ9d1NtRX7mhpVKRcGfrOHIXmJmIOerVUaByFfK6zgkwRY+BsT4wjEtFHChNSkjeycgs7n9L9oqI0LIroBEhXFAuCBdI+HKMoZlP83zSqJTn7Q12IVNm1rW0U9uSjjW0jEZRIPQiXxyfx9XhfWFrM8gPlNicRSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vNAwMMEY0XKzSUa/YtfT79icoQeJ0AiTabh01iKdI2U=;
 b=oml0dg03IcyRHKST/M1TLFZ/zbEnP+KBHSl5f1ZAfENadIkZY/dQQVIsVYiXESrR2L77+PN8YtIs/E9YjgRi4QiHrsLIBSq+1VxDbuqE/6nqHgcd2iV4hDLGxfcQrMtmC4pL8TnBn6jxLsuksJcHGmueb1ugIeAB9uOH6n7CdQA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DM6PR12MB4074.namprd12.prod.outlook.com (2603:10b6:5:218::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.13; Thu, 2 Jan 2025 10:06:45 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8314.012; Thu, 2 Jan 2025
 10:06:45 +0000
Message-ID: <a77fb895-7988-4b3f-a555-3a66654ddc40@amd.com>
Date: Thu, 2 Jan 2025 15:36:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 12/13] x86/kvmclock: Abort SecureTSC enabled guest
 when kvmclock is selected
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-13-nikunj@amd.com>
 <20241230170453.GLZ3LStTw_bXGeiLnR@fat_crate.local>
 <f46f0581-1ea8-439e-9ceb-6973d22e94d2@amd.com>
 <20250101161923.GDZ3VrC9C7tWjRT8xR@fat_crate.local>
 <09187d10-78b3-402f-be77-138cea98d8b7@amd.com>
 <20250102092512.GDZ3ZbeGsxuPjXwc_K@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250102092512.GDZ3ZbeGsxuPjXwc_K@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PEPF0000018A.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::55) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DM6PR12MB4074:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d75b49d-42ad-4c6d-69aa-08dd2b1529d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NUdHT1RRWEljTHlqKzNxNkhjTm1kbElrUmhsSW9YaXY0TnZoRTl1ZHAwN3ZF?=
 =?utf-8?B?L25tYVQ5SFJQQjVLaCtIQysreTZFMUd1SWlUbUZ1VFJ4aG4xa2ZPcmtYdXNQ?=
 =?utf-8?B?cVdzQlF5TUMyeE1zMVJqYTV3WlNMOEVBOTgyNmx3S2NmbFdMemtVNVFOMnVR?=
 =?utf-8?B?YXYxOXVBUUEzR3pBdkxyczRvVGtpclBFUnRiV2hTMWtoSXo1RDIrYlhyYitP?=
 =?utf-8?B?NndVMkpFSE9RRGVlTmR2OTQ0Vm9Bcmg1UGZSV3RxR1BFTmlVWHgwNWxXTFFD?=
 =?utf-8?B?NXpocTlaZ0VrMGs2YlRuUjZBZkxvaFA5YTVQZFNJdUg0aFUwNzRJYS9JZmR0?=
 =?utf-8?B?MFJIcmRsSWZKSWtBcW5kTG1iSERWUUsyay9EQjBnNTB4RDRNcWN2NVg3ZXlV?=
 =?utf-8?B?Tno0SStCSHd6NnBmeGgzNWx1VEVUaVREajVLeXhKa081VkZBbGVCMWYrMGJq?=
 =?utf-8?B?VmY2LzUwRHpMb1BpU2t0ZDN4YWFzVDZFL2Uyb0VQZFRVWTl4Uyt0eFVaVUtm?=
 =?utf-8?B?UkZFNmxOTW9GbURaZStUN2N1NEdkQzBJNzBqL1gzN2cvT0dZSEJrS3JoVWUv?=
 =?utf-8?B?aUxWTkIxNkVmTUZOSWdsZ0tweW5uZEQ0OHpSZklJUm1TaEZaOHJRWTExNUVm?=
 =?utf-8?B?MmxOVkZoVGYxSlhWQm5wWVlneSs1bjdoOGhSMWtJQlBMY3FsS2Z4cjVyZDgv?=
 =?utf-8?B?bGJObzIyWnZTOUF1L1NyWkQzbW12bEhzL2VnU3hidTNycWxsSU96SFFyUzdN?=
 =?utf-8?B?QnZwOUEzNy9leVMzUllvV1JYWkYyZ01hT1BGQXNjVDdjajlQZ0d1MXU0b0JX?=
 =?utf-8?B?YjA4REJLcWZnSjRNU0cxN3VxT2QxVUJMdVNucFUvODhrTTRUeXNSUXY3TkY5?=
 =?utf-8?B?WVJHRHZpUFEzZk9hUHFydlRnL1lGVVhXYWVGRnAwa3hRY25SODNRRXRiM1Yw?=
 =?utf-8?B?WUhLNjdIY2RteHI2ejYzUGdnekplYSs5U1A1eWdSeS9ZK3FyTlNHUU95Q0NG?=
 =?utf-8?B?MXZjbHZNYnVFMzZYZjY2YlhLM1FJNTZWcnVvWlJZSE1VdTZqcXNGR0M3VTF2?=
 =?utf-8?B?R1lrYlgzU1FoUFU0em5IWHBVUDBRbWI3UmdLSDJRK1o5RnhNN0ZUZXVFNTZM?=
 =?utf-8?B?TFJRSUM0NnA1MGhPL2NYYTVUek92RGJpbHFFd0MxRzN6dUIyeko2YUVxdTVp?=
 =?utf-8?B?UWdiU21JUTNWR0dxamJwR0JMd2daOFFoVUM0ejJNeU45NHQ2UWNYUmpuQlVD?=
 =?utf-8?B?amFSWG5FRzk1NXJGZDFPVlZsZGdSdlVCVGsxUW1mUGRNQnJ4aUF6Wk52dHF6?=
 =?utf-8?B?SllpUGV6MUxEMitrZ2Urek5jdTBQRjl3bUt5K3RxVkwzK3RERCtYbENQQUVj?=
 =?utf-8?B?RVV5TUxzMmxhRHBrcVFXb1B3VVlnY3FRakI2SnV1VEd6cFFRSjJPcTQrWUll?=
 =?utf-8?B?VWtZdDZORDcwaDNQbXdZVnB0Z3ljdW1FOE9SaXRDZUJtT2hrUE0weVNLckFO?=
 =?utf-8?B?QTdiazUyQjc0MHhvV3ZjQi9xc0p0Z3E2Mk1jODQ1YVNtdjNibnBNMFRtOG1C?=
 =?utf-8?B?dkttRU5GRzBLQVowOC85UXpHc1NNd0YwbmRZdFlySm54YSt2VmVoc2RnMFJ0?=
 =?utf-8?B?N1BySFB5aWE4TTNQdlI5SDQwV2NsUXZnTGhnVXJTTEhxbWFvTE05bkhQeFQ3?=
 =?utf-8?B?aWJFMlFlNldkd3RKSzFoOHUvbHE1Mzl2dTNnUG1JOXQ0ZENxd1JEOGZlK2Mw?=
 =?utf-8?B?dVBvY25teGFCUU45NnNjd0d4OHlJUjZHVHNDR1o3dDFvdUR5WHpCajVQSWd3?=
 =?utf-8?B?U2d1TmNUcEVJWjlxYXd2SW5sMlhDMlpVQTZXSHl3NFRBR0VsbklHRWxlNzY1?=
 =?utf-8?Q?PTgC8iP4++Gwb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T2o3cmRWU3U3eDBTOEJtWE8rWFRzOUsrZ3MvSzZKeG5td1c5Qkhod3lzWHpk?=
 =?utf-8?B?N2VmdHJuTlRXUjZLY0sxcWlaWnc5cGJndkhzOVZtY1pBRXVuNWdQZ2VFc1Az?=
 =?utf-8?B?bjRJU1Vzd2dIa1FvTnVtTlQ2aDJRRnRxR1NJWm1vc1RpdjNabkx3QzdXeVJN?=
 =?utf-8?B?UGZNYm43d2lhTGVGRDAxRk5NVW9vb2lpMG5xaDdKcFc4NGdDK1dWdWRKM09O?=
 =?utf-8?B?TS9iTGRkWHllTkdFZ2t3Zldta1JmUFgwaTdzcVFVeHdBdXl3Z214SG5SZWtN?=
 =?utf-8?B?cGVvcDBJc3dzMFdXWHZyQm1uTUVvbWdlbHhYcFVRUlRPN1lVS2RjMEQ1bmZO?=
 =?utf-8?B?M2thVlpPaExtcjhQdDZCSmcvVWhhTUtWTkVEU1AvNDMxNG9NQ25VS0VyVEhN?=
 =?utf-8?B?aXBmRDMrdWpBVVNRZXREMnR6UkhpKzVUbHZib2V6bDNSS05pdGJ6VnJHTjJx?=
 =?utf-8?B?UFFRMnhaTlhXOHU3bHJBRXJock80Q2ZXM2RYM0xzM2luVmJiNUpYelBzS3Rs?=
 =?utf-8?B?UVBONDk3ZVRyT2RhZFZ6OFZCWHBIK3NleTZ6WjBCWmNVSGR3N1loVnVzWTh2?=
 =?utf-8?B?dGpmQjBhcTQ3dmd1K2xJRUcyV2UyZXZKZU82S3FueDE2Y0YzUzlJZXk3YUcy?=
 =?utf-8?B?ZHlBdDF6RkxDdnQxWi9JM3VTM25ESk1icVNXZUU1NUFiVjdGL1BkWUdldG9E?=
 =?utf-8?B?YkczM1A2WnpRN3cyYXZ1WlBEUWJTYmxlK1FmOVMrN1hDZ0hZVmhjRnVJa0Y2?=
 =?utf-8?B?RkhJNmFQZ1dWVXFCd1piS0ZucEdrNmlkUnZJZlBrb3c1YStuWUZEWkVpU0Qy?=
 =?utf-8?B?dlBhdGJJV1RzdEh6bjlnSUY5ZkNlNlYvZW9zcVczVmpWZUtMeEViZU13aXB3?=
 =?utf-8?B?MHpXcGVvT3NSV3lGNUZQOWV6T2J6L09SQ1JQMnhiWHU3TjM0MWgxRG1tVk9s?=
 =?utf-8?B?L0xpZkNZaVpJQ3JpaEV4TGRKaHEvbW5waWhXN2wxd2N5NEJjSVAwRXJJK0hL?=
 =?utf-8?B?WTcraExaWXZDSkRNNVgyeFJSUEJ4d212NVQzQkZ1U2hnZFJNOGZOYU5yMWx1?=
 =?utf-8?B?RkZwUEhyMEN6aDFNUTdRWVF1SUw2eDZ5Njd6NVZVWk1CQmdkLzNOWkIySm5Q?=
 =?utf-8?B?M2JGSG9pTy9OQlo2SUFERHlieFlUeXVPLzdGSDI1eU1Nd1NpQ3ZqdncvODl1?=
 =?utf-8?B?U05aRnFDME0yNUNvczJLcjZJQVVoazFpK2RvbnhSTHNac3ptZ1pwOVZLUmtW?=
 =?utf-8?B?aWJvSFJRQnFGbzdEYTc1T294NnR5c3NNNGdKMG9iaThteHphN0R4TzVjajRq?=
 =?utf-8?B?TEY0LzB0UGtkUUp6dEJWM3k1cXozeGNqOUR5T1lBcTZFbUhxeDNYU1lVT3Z3?=
 =?utf-8?B?M3hRUDU0K2VTNXRabDBNaUFwVXdxWndyR1ltRDV2Z3U5TFRaS3RSQ3FIYTR4?=
 =?utf-8?B?dE93cDNueWp1bjZGdkpVK2tSODZPNDRYYU8ybXVyK1lyTHk2UG9rK0d6dS9n?=
 =?utf-8?B?V3UwbGEwUVRtNzF5eHYrNWtHUjMvR1RHamZGWExCZlFNZGliZnRCblFmWVpB?=
 =?utf-8?B?NU8xZExwYjdCOUhOclB0U1BjdlJVekZlTnhja1lwQm9JTUxnU2pkYnZ5cG05?=
 =?utf-8?B?ZFhJdmVWVk1kOGlieEt5VElWa0ZiQjVGZDdoWmpuYXgrWkRqcUtFU1V6eXJ1?=
 =?utf-8?B?SGQzZzVFN2pDbldnR0o4VTZBZWViTmk5Nlk1MjJ3V2ZhMmZNdFByRXgvSzBt?=
 =?utf-8?B?TGxNKzdLdFlJVFA1MnI3V2srL0kvRzN1bkVIZlZNbmJmY3laT1YwZ3F5RDhn?=
 =?utf-8?B?VmRtSGZ1Q1dIVGdZUmRVV0t1a21CU2E4a2srQ3o4MnloUzZ1UnE0azBMajhR?=
 =?utf-8?B?VVV1OW5KZ2hQVXZNMXJVeG9GMHpLVDRnbDRiYnNhUXVoQ0tZZmUzZkRqSHBO?=
 =?utf-8?B?eForRm1tamxhUlRsdmRkSUhIVElVazhHOEc0ck5MQWhDTDFQZVUra0E5TWhM?=
 =?utf-8?B?dmNtcXVaN2d1L3RTM1hpenFBOHI3Y1lnT25WcTVpaUxobitlaDhGdFpBcFZa?=
 =?utf-8?B?T09scVpENkRKbGpwYURqbDNJS05sOE9CcmF2ZmVMQmFBWTFzV1dMRCtURGd3?=
 =?utf-8?Q?DlpmybCWr/VF6LBqJmGMVjTaV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d75b49d-42ad-4c6d-69aa-08dd2b1529d1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 10:06:45.5887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N+z2E8iuf8thmCFBFiEsn1oCzHGRixULKL/7DASu46Raudf0ye79nQ9GeEAp+iVX76OeTitavoPwB5qknDtl2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4074



On 1/2/2025 2:55 PM, Borislav Petkov wrote:
> On Thu, Jan 02, 2025 at 11:04:21AM +0530, Nikunj A. Dadhania wrote:
>>
>>
>> On 1/1/2025 9:49 PM, Borislav Petkov wrote:
>>> On Wed, Jan 01, 2025 at 03:14:12PM +0530, Nikunj A. Dadhania wrote:
>>>> I can drop this patch, and if the admin wants to change the clock 
>>>> source to kvm-clock from Secure TSC, that will be permitted.
>>>
>>> Why would the admin want that and why would we even support that?
>>
>> I am not saying that admin will do that, I am saying that it is a possibility.
>>
>> Changing clocksource is supported via sysfs interface:
>>
>> echo "kvm-clock" > /sys/devices/system/clocksource/clocksource0/current_clocksource
> 
> You can do that in the guest, right?

Yes.

> 
> Not on the host.

Right, kvm-clock is not available on host.

> If so, are you basically saying that users will be able to kill their guests
> simply by switching the clocksource?
> 
> Because this would be dumb of us.
> 
> And then the real thing to do should be something along the lines of
> 
> "You're running a Secure TSC guest, changing the clocksource is not allowed!"
> 
> or even better we warn when the user changes it but allow the change and taint
> the kernel.

Sure, that sounds better. I will keep the warning and taint the kernel.

Regards,
Nikunj


