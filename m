Return-Path: <kvm+bounces-71258-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MOl5NVnvlWlTWwIAu9opvQ
	(envelope-from <kvm+bounces-71258-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 17:56:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5287D157F64
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 17:56:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BBAFD304C10B
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 16:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B78CF34404E;
	Wed, 18 Feb 2026 16:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PHC6FZ+v"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012005.outbound.protection.outlook.com [40.107.200.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CB7334370;
	Wed, 18 Feb 2026 16:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771433760; cv=fail; b=nsJjivB9IK5Dn0iLsv4gSPX64itYRm6u68TNjoSfnIEpHQcXyoZHFcavXjzQhxG0cMVZWFbMgs0Vibeg6M+9CZMFsRU0lXT4k2RbGc27BMqtUHO+0/CIrMxSFQFlyhfFEKMdD+7h4KKlSyV0ubMq+RWTYK9RXaH1+x9TeypdcWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771433760; c=relaxed/simple;
	bh=I7CAmpIpvLtDTAqK6/nM4cLfrGTZsvMYfyZUzAFaRyk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QvJO0qPo+ZlawNdwIE50eS5qi474w8+bPJtjBIca5GjSBBDiInWB0dcCof0OQ8WhnzEHzq3310LNvcO81LUAvLhLR2YsVpoWm6ZIuT4nqCLPbBt+SqAiJcz2q7F9uV7QgQ9W8N2qFbxqh4op3BTORoiaXMxryJ6KB3oIcrYr0WQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PHC6FZ+v; arc=fail smtp.client-ip=40.107.200.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SNPxshiGXPT9z5yz54aG4uJuy2d/CW5XsiWRheNcQVpNts777r5KgPnTL1n1NxkwoqOf5Sy7ak13bca1Upg0HJFGnegWfwg2OXWuH21+DXbP1x8nMPUX+LzAv4GRHowpP5jKrepTuyVpcKtA9eIdCp/SFNotHMY4mXPdJ1Dtz5zn/SmHAMhC9kZdcme2bo7PaHGaEKD64rK5YgPhphjFFet9igwxDOCKdLaRy2XFTvUv787Y2C/yvaLzzWvXLmUWGR7erHZknBEtJZ1xtko4FEeiUs9Tg+4MJiF9XWEEXxtezS/IKHrJjs7/jIUkqusVfpcIUsE/NKPfBD5Ap/jrtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PyM4vH01Pz0C5/j3qgu6pSYm1kz4YHM1lkhfsHYyj68=;
 b=r9K4Yw0PVCbecBRMhV54+ltc0sAWSX+Ozwh05hnA3FycWjkwgFENVbPp+zWI+tRsWhwYNHv6aaExfY6OuCKk5EVeeI/dx2ZJf8+wFaOgcG1UslpgqDKmXjvQnkYks8V7stNF0pqckDt+SJxDMB1KiybUj/bswS7/8ykdE7N7Iw7FMiSrf9r1h0h30BJzINhFXGa0wKizNS9wixNl2hK2korhwx1ppggYcjQ25v1jYi1Rx6k2S/TSsc+7YlXoXzGl38u02cXTiNPljpq7QVGlUWKYJycRq7VB61CdpBXz5HzwSstpfFrlql4LnofiUMSYAqu8llxV83YHB0zWNl56NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PyM4vH01Pz0C5/j3qgu6pSYm1kz4YHM1lkhfsHYyj68=;
 b=PHC6FZ+vyXe1iM7j9x1uYzCdII942Tywb3SUtkvC54lSDvbKl7rc9+e9x7rY/GBy5HrNX5KigvwxIY40f+7wQ78pIHsLxP5iu9ewnCi/fdCo3fs7UUGcnXx1rTjF9nLCAvxkHfdC8KraY6bV/FQSt9mQN/9+d+bVRbvicuRUiTo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by CH2PR12MB9520.namprd12.prod.outlook.com (2603:10b6:610:280::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Wed, 18 Feb
 2026 16:55:51 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356%6]) with mapi id 15.20.9632.010; Wed, 18 Feb 2026
 16:55:51 +0000
Message-ID: <4e912046-8ae0-4cb2-b2cb-11c754df7536@amd.com>
Date: Wed, 18 Feb 2026 10:55:45 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] x86/sev: add support for enabling RMPOPT
To: Dave Hansen <dave.hansen@intel.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, jackyli@google.com,
 pgonda@google.com, rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1771321114.git.ashish.kalra@amd.com>
 <7df872903e16ccee9fce73b34280ede8dfc37063.1771321114.git.ashish.kalra@amd.com>
 <10baddd3-add6-4771-a1ce-f759d3ec69d2@intel.com>
 <b860e5f4-4111-4de7-acc7-aec4a3f23908@amd.com>
 <59c0b0f0-26b0-4311-82a9-a5f8392ec4c6@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <59c0b0f0-26b0-4311-82a9-a5f8392ec4c6@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS2PEPF00004566.namprd21.prod.outlook.com
 (2603:10b6:f:fc00::508) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|CH2PR12MB9520:EE_
X-MS-Office365-Filtering-Correlation-Id: c3ab4252-1f54-440d-4c23-08de6f0e9273
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M2N1UDl6ZE1QY2cwR29GaWJqRFhoQ1lOQk9VaUozcnBlRmVKZ20xZ2NydjA2?=
 =?utf-8?B?S055Tk9nT0ZPa3E4TUdlMk93dWNkeHhIc3VwRFpTR1NEbXlvVmhQUXZMdzN3?=
 =?utf-8?B?dHBTckFkRjFWV05uRlRYQXVYcmxpeTV4aysxdmNxcDdXQ08rbDFQT01tK1F3?=
 =?utf-8?B?NnByMWx3SW5ZbFlUTk5ndW9WWUZJY0g4WW5rQm1Ud2d4NHF2V3NlZzZDSFdE?=
 =?utf-8?B?V0g5c2RDNjhSWThiOHg0YnRqTHVyQWdyT3lKay9mRmVXZGZRaFVudldqemxP?=
 =?utf-8?B?REJ0SXBjR2JJVVVaKzFkbUNHQjZUYkFDTXpkUWxmUWZNZUN6ZTFpd2gxNFZB?=
 =?utf-8?B?Y0o1VFBKZXhGN2FEUTJLK3N3Q2ZhQUVsTHQxZ0ptcHJ0RE9QMXJiQzFodzFR?=
 =?utf-8?B?Z3FzbHNtZ0JxVStxdDd1VnJYRUswV2VKSnBaajJHWDFJdmpyNlZkZmR0ZElH?=
 =?utf-8?B?cllpNkZDM3JkYlRBeWpWcE9aaXNHdmlMS24xbTNBQnVuOGY5VW5yQ0R2d29O?=
 =?utf-8?B?bjhzYkN4MTZaRVJQNi9CNG1rOTVkWThDZWRmZ1dCYndUcXB3Z1ljUkt0djNT?=
 =?utf-8?B?UjhVS0ZMSC9uY0hLOHlGSzQ4YXdmS1JDQmNUNU5VTTRJTlBrd3N4MkdUVFNK?=
 =?utf-8?B?bURvdlh1NHBnTHVIblBRUFhvS09lWHMwanBBaWIwVk52UkozTWJIZUJGbzdz?=
 =?utf-8?B?R3o1N0czeE9nZitMQnNzTFc5VzlhcC9BT3QxZC9LZmZ0b3luMGxFQzIvWGxx?=
 =?utf-8?B?NHlEMGx1YUYxWDZ3cndpekR5U1U4YThETURyc0d3eVVhSWI0L0pMTlVIN3NS?=
 =?utf-8?B?Q2ZLU1Jlb3hyR0JDYW5xay9wRFpvb240cW1IL0RXWjJPam9FeWVTSlJ1d09k?=
 =?utf-8?B?VXV2U2xISmpaelZxQklWVzgxU1poQnFkT3AyQnBZMythdkdLbU53MFdPSjJE?=
 =?utf-8?B?dEgyNEpJV1ZNTTNnUGozYmJzcUJqL0lnaTN0dFVtNHB0UHNTUlBlZElja0k0?=
 =?utf-8?B?V0p0TWdCODIwRjJNRzk2Uk02Umt6REFvbElOb1YxSitUSk91OUtOcTdLRmxP?=
 =?utf-8?B?MDNYK3hCcmJPZjJoaHZVdUNYTDVja1BhSWo5YVF5ZVJHTnVhYVlwY2duSlFB?=
 =?utf-8?B?UU9kQjNFTCszTzZSVkZFeDFINmJoM2FmVnAzY0lEekswTkc2Mlg3YjlsWWxv?=
 =?utf-8?B?bWlFV08vUFY1NmpZVllyWmkrNUFneEI0SEdCS01wVkExWDhIT3dQWnBlWVRN?=
 =?utf-8?B?Mnl5WUl4QjRWNFZOZlNrZk52Sy93V0hGWWRDRWVkSEhzNlhic0NJZ3VsdjNz?=
 =?utf-8?B?S2dWUFplQUhvNUplQnlNNk82YTA0d1ZucW1Va3BYZ28zWmtPb1Q0NXkyR3p2?=
 =?utf-8?B?aWV3cG9YbzVadDFKTjBPYTdPVFJXY2VnQjhuNDJUUGZUdE41NlZBQTNaTGR5?=
 =?utf-8?B?L0hYdEpISjVjZzJoclNyU0FpQzJjV1M0aUdkcmRQWU9uSS9VQm5BSGRmMkly?=
 =?utf-8?B?N2Q5K3JGVk0xWWl1cGNlazZaMy9aY3J4ek1nMWFEMW9nb2IzZUsyVWEwbjI1?=
 =?utf-8?B?Nk1MT1RaakszckRQckNYZlBmM25tL1o0OWVrME5WeFZTak1WYndUV3Z4Njdo?=
 =?utf-8?B?Mkg3MDdzTS9oQktmOUZpZmtKeXE1MlI4NTlpRG5tSi96bmdjQmJkeDBTNnhs?=
 =?utf-8?B?V3NMYWZvaVZoOFl6b25KSWJBNVY3TzB2ekJCdnBYNkpVaU9PQmRnWUJSVGNT?=
 =?utf-8?B?RkQrdTdiRmdsK3VvYjFXL3Z0eXc1UEVpYWVWKzMxWkZ3MkZhMkZJdXhGakRk?=
 =?utf-8?B?Q2JseGo3V2RBU0dGMHNsVHhGdFBhRmV4TGlES0hCdUM2aWhEMmlVcnJPdXBV?=
 =?utf-8?B?VkRhbExTdmJva0hGNDJXWWRFTW1GeVlLVU1lUisyVGIxOGxXVXNPWGUzbTZI?=
 =?utf-8?B?V3FLTXNkTjBFb3lGaTZzYnAyNzVJTGdXWDdrM1kzYm5CSkxacjlwOWpsOGk4?=
 =?utf-8?B?a3NKZGU3aE9adktJelhPTGxqeFdkL2N5YWRhanMyTWNmOEp2NDEvdHZ5Z2R1?=
 =?utf-8?B?dWJOUEZXZXdwanU4Tmx0UjBsdFVYUE1OVlFaQTQvWVR0MTZNZ2NLN3ZlaGtD?=
 =?utf-8?B?dWZnQmtDNWdycFFmREJOSVZPaVhXT0VITzZJaWtESnZLb2FyK1R0bk9sTVhT?=
 =?utf-8?B?Smc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bjVnOHZkLzhWUUJGUENHWW8zQzAwanhUa1hreWhTMmNVOWlha0NieFdzUExx?=
 =?utf-8?B?UkRFY01MNGJ1QVMzMDkzV0hmTmI1WjB0S205cWNjaUQ2NkNhcmNyNHpuYkFN?=
 =?utf-8?B?bWVqR3UwRk5kWHJNUUcwRDRVUDhJRERneE1jRXB3anlIZVFZc3lscDNqZjgw?=
 =?utf-8?B?eTF1V3BjUTE0RUpXUCt0RjBoR3JGeDA5cXNVZS80VWpkcktXK0lHaGUxcXIr?=
 =?utf-8?B?c2dJMGR5cTR2MmV5andaZlVaWkFoK3lZVWdPOEY2NEtXZVk4YUR5NGJnQzBw?=
 =?utf-8?B?eHV2bCtmMmhwckVZVVd4NzdGYk03TVJVcW1uZnNieGNuODlORjNjMXgzWUlW?=
 =?utf-8?B?QUZrMi9CM2Rva1QrVkFkemp5aXpUZnp2M0U0WUszUzdnZ0IxQWozNGVzOUgy?=
 =?utf-8?B?ZGdkWXdRekRzN25OelgyU3Jsdnd5NVFmbHU2MkI0ZEwzSEZ5REF4QTBuYktj?=
 =?utf-8?B?UVRzTkprb2pPd2xjSk82K3EvOGY0V2tVNjZPU3U4UzFROHdnc3h3N3FpWDBW?=
 =?utf-8?B?VUVuUGQ0dDdoUWhxalZidzV5d0ZRcmRQL2x1bFM4ZG9mbWI0WVlhd0pLYWFL?=
 =?utf-8?B?cWFBK2NxbmdzOElTSGdNTElXdVcyNTNwRHNZRXphbTlBLzlTZUR1S0cxM2lz?=
 =?utf-8?B?WXI5VW81SWxxZ2JBaTJqNWVod0tLNVFJT1NyTmk5ZlYyMGM3NTk4WHpJZ0l0?=
 =?utf-8?B?MGM0YUdDUHlDa295dk00cXhCZkNtMHk3bTdaNGwyNDNTZFRjSGg4SmIrOGJS?=
 =?utf-8?B?RE96YkNlOGRvY0YydXM2YVNxcUdHSWU3bG9XVS9yL3ZDK3JhekhLY1llL1ZO?=
 =?utf-8?B?TVNwQWswV0VnajFsZkVxQjhTYy9nZ3IyelljbC93ajE0YmpNaWhqVVFSdzc3?=
 =?utf-8?B?V2VoL0owNTl3akdPekNmQUNSZWZEU3FUQzZVWk1HNjlOK1VTdVVVdllLd3pN?=
 =?utf-8?B?MXFFbWFyVS9nd1NSdFdtMnNXNVNvSmRWblNBMFBXTzhrUlRxaWFpOTB3YStO?=
 =?utf-8?B?WU9YeEVmZWNoZU5rQlU3cjVuY1JqYkxTY0RIdFhlWnllSm1TakZLQzFGK1R0?=
 =?utf-8?B?Nkp4cnl0UE9wT2FEOFVtYkFueGtvaHlCT094L0FySFhLQjA3WEtPc1E4ajg3?=
 =?utf-8?B?aEF2anpjWmRCMmVmTWRXQXlKN0xRUDhnUTdTZ2FPWWhGR0c1VWcrWHlETm5a?=
 =?utf-8?B?cEFLSlBXcm8zNDRzbTZQUXp0bkQvY0crOWZINzFqRjdNTHB2Y2hvblQ5eDgx?=
 =?utf-8?B?Zm9vNG82Z3pVN2ltQW9FQTMxeGFpcUd1S0F5UVM3WjZ5bUt0TUhuS29ZdTl0?=
 =?utf-8?B?VXpvWDYzdXJBOHBtKzhtdzgrK3l6UDN0d3YvajAwSU9JenJYRDdSSFZteWg4?=
 =?utf-8?B?c1ZueCtrdG8vSC84cVZIdUlpVkhCZkw0TjJnSERlQ2d1MkFxcUhXSWE0ZmZI?=
 =?utf-8?B?WDdiMWFHZkpINUxzaU84RXFRbDQ0c3pEOUZQdXZXUmdlQm85Q0tOMG9RWEdH?=
 =?utf-8?B?ajM4VGJKbGhldmlqVGh6c2ZsYTJRQVc1VjVDbG9UdURIYWRCZVhVSHFNRmVQ?=
 =?utf-8?B?enVtL1h5d3J6WTFJUDcreEh3T0lsMkdINEQ0VEFtd3lJaUxFYzlqcFIrSCs0?=
 =?utf-8?B?c2dBWENYTG8wbXVhaEIvTVdkSHZ5blFYcG1iWUdCZXBPS1A3UUp2MTU5NkFO?=
 =?utf-8?B?SFRQR3pGbjJkUFIxb3ZtRW9FSXBPNjRoYmQ1d3JjMjBxaWJiVXdoSDA4b0FK?=
 =?utf-8?B?L2NsSDR0aFMvN2hyMUs5M0pCYnRhaWJBYnpLQi8ya1Q0S0srU3p0U2loUmZv?=
 =?utf-8?B?NWI2Zkt0Tlg5dElmLzdyOE00cmJQRlBnZGhod3hQMThjTk1HSlFlMC9ScjVK?=
 =?utf-8?B?SEtRVGNQUEpBd2hnYm5EaWdtdkRpS0FHK0RTY0l0bnlPQzBwdGNPQUd3ek04?=
 =?utf-8?B?endBTllJRms2OXhvZXdVRzVpK05FeUNNcmVxMHhmdnVSV0xMcDVoR2ZQS2Qx?=
 =?utf-8?B?cVRoYkx5bm1CZjJaQ1BzZ3gyejIrcXNtM0R4WThSaDJOODU2U2tlUi9OUUlM?=
 =?utf-8?B?VTRjWC9KZkJleE9yQS9JWHBMMnZUOW5pc2ZWUG00M2JHUWpjVjhKY2VUWklE?=
 =?utf-8?B?Yk5oUWtsc0o0bEg4VmN2bkRvUk5XMW1QaDZMUGNNR1V1Ylp1RzNMT1gvYk5Q?=
 =?utf-8?B?MkdFOGhiME43bkQrU2M4ZmQ4cC84dENZK2YxVFJrOGRLR09UY2lQQjlRVGpV?=
 =?utf-8?B?bEZQM0hGL3I5ajc5TTcxSlNBTjJPRFZYYmNqWE5yaHZ0TDBTaEtmOWh3ZWVp?=
 =?utf-8?B?ZEJhSTRXT01VZC9ORU5UMkozVEdOR0g2MFVlczJwbWxyQkd3RnRtUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3ab4252-1f54-440d-4c23-08de6f0e9273
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 16:55:51.3136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s1LpWR5oW/7ikgG9fGcULnX2YLbuPZwI+2AiFeoQWUeucGN5gK/pATkMRNwNkbZRe0BWhdM9KxedNwzagklmsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9520
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_FROM(0.00)[bounces-71258-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ashish.kalra@amd.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: 5287D157F64
X-Rspamd-Action: no action



On 2/18/2026 8:59 AM, Dave Hansen wrote:
> On 2/17/26 19:08, K Prateek Nayak wrote:
>> Hello Dave,
>>
>> On 2/18/2026 3:36 AM, Dave Hansen wrote:
>>>> +/*
>>>> + * Build a cpumask of online primary threads, accounting for primary threads
>>>> + * that have been offlined while their secondary threads are still online.
>>>> + */
>>>> +static void get_cpumask_of_primary_threads(cpumask_var_t cpulist)
>>>> +{
>>>> +	cpumask_t cpus;
>>>> +	int cpu;
>>>> +
>>>> +	cpumask_copy(&cpus, cpu_online_mask);
>>>> +	for_each_cpu(cpu, &cpus) {
>>>> +		cpumask_set_cpu(cpu, cpulist);
>>>> +		cpumask_andnot(&cpus, &cpus, cpu_smt_mask(cpu));
>>>> +	}
>>>> +}
>>>
>>> Don't we have a primary thread mask already? I thought we did.
>>
>> If you are referring to cpu_primary_thread_mask(), the CPUs are set on it
>> based on the LSB of APICID, specifically:
>>
>>     !(apicid & (__max_threads_per_core - 1))
>>
>> It can so happen, the primary thread ((apicid & 1) == 0) of the core is
>> offline while the secondary thread ((apicid & 1) == 1) is online but the
>> traversal of (cpu_primary_thread_mask() & cpu_online_mask()) will simply
>> skip these cores.
>>
>> Is there an equivalent mask that sets the first online CPU of each core?
> 
> No I don't think we have that sitting around.
> 
> But, stepping back, why is this even necessary? Is it just saving a few
> IPIs in the super rare case that someone has offlined the primary thread
> but not a secondary one?
> 
> Why bother?

Because, setting RMPOPT_BASE MSR (which is a per-core MSR) and RMPOPT instruction
need to be issued on only one thread per core. If the primary thread is offlined
and secondary thread is not considered, we will miss/skip setting either the
RMPOPT_BASE MSR or not issuing the RMPOPT instruction for that physical CPU, which means
no RMP optimizations enabled for that physical CPU.

Thanks,
Ashish

