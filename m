Return-Path: <kvm+bounces-20790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB3F891DCFB
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 12:46:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 098291C213F4
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 10:46:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F14E142E62;
	Mon,  1 Jul 2024 10:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QVSyfX+k"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2063.outbound.protection.outlook.com [40.107.212.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C9413D625;
	Mon,  1 Jul 2024 10:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719830745; cv=fail; b=UBhVt3NuautSrUSZd+2m/KzIP/o6ilvqKO8DhwhH6QClW5vSXrSqWdnSLuP3chYvCftKsLZzNg62LenH3U9/PR8CpkeSEjTNyIoYdb86kNYsCosINjiK2Qpov0okVRFJnYZCUb3rhTY/bjAIXiVRk/5zEzxxgVf8jHGWVhg7m6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719830745; c=relaxed/simple;
	bh=jSpARc6REZpoUmBYf0anObMgdM1R7dCL+W0WHgXnNNM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tFsntdppo4GQ3EELwfMLZCy9ZMqYX3U9bRfy8AHmwP1ka+EhLc+Y2ZQSA0TqwBOXo0QkZt5hyvEzTYu+REyDSirJSh4GGNOoKIy3PlRG8CUlirY1zUCa9pvHJlBDIoFVhLzP7hZyOVRoMrhkQuCViFYiIF2Yf65MS8LZ01gRCbU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QVSyfX+k; arc=fail smtp.client-ip=40.107.212.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKYqF4ULtfg5R0XZ/A1QJ5CdJJG+PERpr+EdPfOm3L6UN9SZvYdKLTh4FdWkVPfne8+5MhQ3Urqrj9JQ0oBClrUDNaxvuHcT14xxcDVxYLTh7bN+tatI18sWgoLol0UWXHhdMUpBKDhA9VM9le85gotZrKU3j8rq23oAPykPntF2XboXjy5vpOVY86iVXUsFw3t9HR1HK7cdMYGUEJRtagZHvWQrNJuh9xaqQO5Wn//yAs45HQF2+SDVhIuSr/ZfKuDAcPCjQduQINTKrsM/GngPvHktPTSN9vO33SKAOWiClUPSmQfKIsyMnQ2cpx4v9IJkSzKVnwN/ggnc72ga0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tslcGes6PdFELoCZrJcn5JPGoidV8BSt8txnHl914i8=;
 b=kQ5/3007ZdN/ZwL9OkkBRnf7xzXPaJg95UW7QcVi3Cs7/lKx4kkVloz27KTJTr2pjiY0lwRPcoQtufbv7UBnM1iSrw2xC9u3wTE8bXxmI+239vm5CVxl39XGDPwf7XwnJxjjHlZH2r7Tc6gDrEkYrnf6dL3V3qkqXzrBoEE2WoS2P1NDBio4mgPQTj8pFJy211laBOS0Wbc5Go2iHPm7Y0vLo7/78B4Mj3tart5dHNeZJJ1A/NcBl7VH2/HyxHqbb8LjWr0387+x/R/zTdJKgLyooKZpIm2iDgNmFlUpXKI+e5c+967e7F4LzGPQeChq9J9yLpCYYxwMi+pegYA65g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tslcGes6PdFELoCZrJcn5JPGoidV8BSt8txnHl914i8=;
 b=QVSyfX+kddcEMXqGocT6IY3ex5JTRzJ/mAFSMO7u/DLVXouoajwlZAOtAuwkC4rTOND42/PUoHlMtuQpBHa3fneV14wyDNWxJM+L3CgvRuzLjaBCycMoAmXrW4Em4wF54lxp/oQGE0Z/DTvoRkuK95sdn8HtoZofKD/c1EndCFU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SJ1PR12MB6363.namprd12.prod.outlook.com (2603:10b6:a03:453::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7719.29; Mon, 1 Jul 2024 10:45:41 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.7719.028; Mon, 1 Jul 2024
 10:45:41 +0000
Message-ID: <007c2e93-d5cd-7f7e-bd29-bfc0da4c18ba@amd.com>
Date: Mon, 1 Jul 2024 16:15:31 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH v10 07/24] virt: sev-guest: Store VMPCK index to SNP guest
 device structure
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20240621123903.2411843-1-nikunj@amd.com>
 <20240621123903.2411843-8-nikunj@amd.com>
 <20240628035217.GAZn4zcWMZy3mgCKky@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240628035217.GAZn4zcWMZy3mgCKky@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0091.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::20) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SJ1PR12MB6363:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b104d0a-2493-4f4d-4b56-08dc99baf372
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZTlud0dEcTdvZW1DU0dXL01KZjdhTHU1ZndPZDR5ZGFuWXJ3NklmRXBaRU9t?=
 =?utf-8?B?NndOK0tDeUwrWFlISkN4N0VCVkI2OWp1bWVLaEhwaEZhSVBsMGl6RTZaRVNh?=
 =?utf-8?B?UGY2cXcvK2FSYmt0dWFYY3RacURwb0c5eG4rVURFdFR1MVlsazViZVVzcUpo?=
 =?utf-8?B?WUpvSEZnTEE3YkJzOE5UY2hDN09vUEpFV3I3VG9vdmZ6MTdINzRwaDhzeWZm?=
 =?utf-8?B?ZElvV0xnajZtK3Nrb0xHTUVvZ0k1YnVPb21Ycll5Q1RNcmtkNGQ1cTBGbFRi?=
 =?utf-8?B?WFdXWVltM09vTVFSYXM5OXBLYVJlalU0ZWY5UVp3TjhONU9vOXZ4NmdYR0lx?=
 =?utf-8?B?eENxWmlyWXlZeXF4RWg2a0hVWkR6SFhWZU5LVGlLQUw2VDBOdFFueHE2eHpF?=
 =?utf-8?B?Z0JVOFNHSHVzb1hSU1ByRlJPUHhuQ0xrcEFsNUVITjF3SDcrYVhKK0lLYnRN?=
 =?utf-8?B?TTcxUkZPb3Y2TkdzckNOSUhCb0lhYWkyYk5qaGNtOWZLcUg1ZTRYT203WHBy?=
 =?utf-8?B?VDlWUXBqWXFCUGE2cDRKNEdkM0twKzZhZi9CQkg0RHBnSmxPY1pFaHEyMGdC?=
 =?utf-8?B?R092c3Ewa1dNcHd4TFA2b0ZBTk5jL0FabUlBcUhJQTBsUjdiT1JqZ1U4Uldh?=
 =?utf-8?B?SnZTRnFtTzVEWkFyb2RRUkxEdkhZTzN3cjlpbkdWSWR2U0dJT203RXp1OWxD?=
 =?utf-8?B?azBmNlhGSVZrMWNmZUJKem81VjNLQUszTmdyL3V3SGw5NldPYjNsc2ozZ2Mx?=
 =?utf-8?B?bk5nc25vN2pUcDg0U2pUY3pwTGtXS2VrWUR5cTZFR0Z5OE1YZnl3OUtnZmtB?=
 =?utf-8?B?UlBxN0FZMWxQS0duV2ZPQUZDbjJuNVlFOURVWGJxUnBoRU9MejZWcC9XSUxO?=
 =?utf-8?B?NTZTTUxIVzdDU2NnWEhWOUR0dElpRXhmNnBZblZYMlNIK1RZalZzSnRjMGdp?=
 =?utf-8?B?TXVmMXZwUEdRMTNnNlpCK1VrNDl0K3NBcjgxd3M1UlVnR2FaRWpOQUN3TDE4?=
 =?utf-8?B?eDNQa3dkV1Z1OXRiSm1HdEZGR2tEcGFGQ2E5cTlHREltTk1RTkhna1JHcTJi?=
 =?utf-8?B?U2hSSHFJTjhEUjFzWkJaRUZoK3lqL2J1dmw0VnBDV1lrSWlVeDFsMUtoQ0tI?=
 =?utf-8?B?M01GVERrSDJMSHpBempBWldHZHVqeTA1ZytsMzRTV3lwWTB2VnE2YmV4MWtu?=
 =?utf-8?B?ektHaHRUNysvSDVYamE3L0VUNTRaVVZMSmVOYWpIZ2p4QlJuaGQ1VGNrV2tk?=
 =?utf-8?B?WUhodWxFb3phajkrVHZFUHovWGJqSjcrcHZNWS82NXREUi9jTTdveUlmbXRn?=
 =?utf-8?B?S2dHK3JGSjloN0g4ODVCMHdKZTRCVW5QNkp0eG85V3J2NFJzYmFuMG1CVjc0?=
 =?utf-8?B?WktQeWhEWEdDUjZ4aWJvblVOdHdpazluRjltWURPN3YvR1FQL0I3aTgwRWhs?=
 =?utf-8?B?UDh4SXlFdGxuemhWN3lDaXAxRmFkZkdsVERJSi9DUWN1NDRWV0FaT0w4bkNp?=
 =?utf-8?B?Tmd3UC9UK1NHMk5MOVpLME5uVU5uNmg1bDUwMGF1SFF0Q1N1TjYyZG54Y1ZV?=
 =?utf-8?B?OStLU0tLSDlzeWdRUXViZ2VmaW9UclFyNmg0RVFXSkcyN1g2VjhENjRDZERL?=
 =?utf-8?B?dWxLTUU4UGoxekl2Y1NZQW9BUFBZR2UzRGlBajdUUUp0d0JFYTlxMmhnUjZm?=
 =?utf-8?B?aFlOQlYyYTRCTS9FWHBtQ0VCa0FKR21kSzB1d3VPR1dpaXl3OTVjL0Mxbm9t?=
 =?utf-8?Q?zVEX9h1dm22Mzlq8c4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzNBYzU1a05IdkkvMWl0Qko0YnZ6UGJob2dNNFhMS3JDdU9CWWgzdjBlb3VJ?=
 =?utf-8?B?N29vVHZNSjFmc2xSMXFoemJpamU1eEVsaElYYUVOV3VSR2daaXVRSVRBcG5h?=
 =?utf-8?B?NFVwVGVpR3drelNsNGt3b0o1WitmWFJOOStmL0ordXg4emp1cmlBQ3VBL1U0?=
 =?utf-8?B?dDl4bit2dHpMY2xtVStkNnEwak94T1VlSFh2Sno4Unk2QkQ4Wkx1eUJLRk9n?=
 =?utf-8?B?M0lMa21XZ2xtZlFzOVlkOGVMVmhBVmtzTTdlbGVlZXk2cDFXY01vblNxbVVN?=
 =?utf-8?B?Qkc4TEVrWDRFRUtreXZvNktBa1krR0Z2aEc1YlVOTEpsOVZQZUEwM0phZVB3?=
 =?utf-8?B?VHpjL3ZUZjhsQ0JKZlVjeHRjZXpKRDNUWXMrTVJOS2JlR0plOC80UmFNZHFU?=
 =?utf-8?B?Y3NLejJPQ0Z6YlYwcFljZXlBVkd1Y3RWRWRVM3VINFBZWEhla2pZcmcydW8y?=
 =?utf-8?B?am53SjNHK1RPb29YWUtzaGtZOVBDT012WENHc3pFbmt6RTVqVisrTUZDa3c3?=
 =?utf-8?B?L1BVUWwwYnhFaXVrUEVmRTBhNzBlTm9yYWVkeEdNcWloTThpaEFYaEVNcTd2?=
 =?utf-8?B?L3ZNa2FrL2ZTQXhZSVRJa29lMG5DWVNub3JmM0xMSG1JeklBL2Q1S0JYT1Bx?=
 =?utf-8?B?QTV5UUJZY2hzc2tDdkVEVkJoQjRlS1FYR1ZGYUNOTVB2NGJ2ZnZjMW5EV0Rz?=
 =?utf-8?B?bjA3eGNGVjh3V1VyYURDWGVZK2Nzb0d4T2I3blpkeGR6aFRvRlQ3N2NDN2o1?=
 =?utf-8?B?OUtYZkdydmhjV0hyeUFnRG5hNzE4cmNkaDArMHdqU29tR3EvcldZei85U3Yy?=
 =?utf-8?B?UWxqNVJSa0N0V3FKL29HMXFPbEp4Q2I0N1VsMGNCaDdMcHpDQk5jVmppTVlw?=
 =?utf-8?B?VFBWS05QVk5PQ0Y0VXFsRHJpdDJ3b3dPRnZZcGhuaGRBMHJxZE9ZMG5vdmNE?=
 =?utf-8?B?cUdFOFN6ekhGRHYwZlorTGNzeVoxZ3ZLdUR3WEhKUWYxWVozemxBQU45S3dJ?=
 =?utf-8?B?MFVCQXlKTDN0bWwvNUJhWlNZejc0SDZWM1F4Q2tjK2NvZW8zWTI2MFF4R3RU?=
 =?utf-8?B?TU94by8wV2l6MFVyelBYOTZNMHVyQU8xeFlPUkZCSTNQR1M4b3NWay94Uy80?=
 =?utf-8?B?eXpRS2ZzUmt6azg3YUU0MGhtRExnVGFmUTVueHliTWtINGRaUndrdnl6NkZ3?=
 =?utf-8?B?K00xaDZER0lRRzB3NStzaFlEY2Yyb294T2Fhc3pZV2ZaTmdtWVIvUTREZTY2?=
 =?utf-8?B?TG1ueU1UOXZKYWplNWZPeVB1MkNuUGNlb0Z2bTdLeGREbmNoNlhaNUx0Nlla?=
 =?utf-8?B?OStBTjZnOVhydXNxZEF0b05ub1JuZ2paV2NpNk03RUFiaGg3Nks0TmR1M29v?=
 =?utf-8?B?dWlZNC9ZTzY5SGJMbWZ6MFRWNWwySDdzbUtVRThPWHFuVWlaWEZmM2s0Snl0?=
 =?utf-8?B?eHFrZ1hKazVPODBOVjN0Z2dHcDNYdkd0bFl0eXg4aVhIN2FxeW85bm5zV240?=
 =?utf-8?B?YTY3cFcvN3RGSHladXZUYThwSzYxQkdyS21JUU5kT0x4TERKakpNbmdqbFhk?=
 =?utf-8?B?WkVjcmpoOWVMTkZ2a2JYYWpsQXpLbmV3czVvdGtoRlY5SGNMQnhMdUtvdFhI?=
 =?utf-8?B?QmZQNkE2eGtPMFVia2NqMXV2YUhGTUdhVkxpNkoyeUlVRW5CWVdXQlZhOHRm?=
 =?utf-8?B?NVFZNzd5MjdCWGRkRkxoUkhweHBXWmk1RDhxSEViRHdndXROcXhOdUpTNXpN?=
 =?utf-8?B?RzZoVjVObnJoN0Yra3pYMzR4YXVMVjRjQ1FLNXZSSWp4Ly9rUklCNjArQnlQ?=
 =?utf-8?B?WTI5a0JHZE44VnltRUQ3OUZDVDJLeUdjNWY0Z2dVKzJadnJaMHBXdUN0N0tK?=
 =?utf-8?B?b1N3L0h1SnVFU1F6VjFma0M2clYzQk8vclA3NmN2dlhzenR1SDUrVjdvWGI0?=
 =?utf-8?B?MnM2S092NkVZVW0yM2NDSnJYTlowTlY0bmhuL0Z2blROMGZKWHpqNlNsSEZy?=
 =?utf-8?B?MnptaldmM2hxeGR4ME5uTjg5T0VwNzI4VFNBRFArNjJsekJ6NGpmamF1WGZN?=
 =?utf-8?B?TXc3cXZ4VENYRklvSWVsWTFEZFZHckxmL0VNRERXTDdpNHRXSkVSTjl0UllH?=
 =?utf-8?Q?CI73sumSHOWHkCBqFSM6+Evse?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b104d0a-2493-4f4d-4b56-08dc99baf372
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2024 10:45:41.0428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u7Y+rCjmRo3x0p7xFmFsfjKyG8Ymcwlzh91d8ez87AM1QLDrn5metzWEdS6TlsGmfh9F8NNJMlBSD2xNFTBW1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6363



On 6/28/2024 9:22 AM, Borislav Petkov wrote:
> On Fri, Jun 21, 2024 at 06:08:46PM +0530, Nikunj A Dadhania wrote:
>> Currently, SEV guest driver retrieves the pointers to VMPCK and
>> os_area_msg_seqno from the secrets page. In order to get rid of this
>> dependency,
> 
> And we do this because...?

Thinking more about this patch, I think I can drop this patch and retain
the VMPCK pointer and the os_area_msg_seqno.

In my v8 [1] and earlier series, I had dropped secrets pages pointer from
snp_guest_dev structure. But with newer changes in v9 secrets pages pointer
is retained so all these APIs will still be fine. 

> 
>> use vmpck_id to index the appropriate key and the corresponding
>> message sequence number.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Regards
Nikunj

1. https://lore.kernel.org/lkml/20240215113128.275608-8-nikunj@amd.com/

