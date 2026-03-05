Return-Path: <kvm+bounces-72939-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uCOEE7/YqWlXGQEAu9opvQ
	(envelope-from <kvm+bounces-72939-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:25:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BD91E2177C6
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 20:25:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0D294305DA30
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 19:22:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7D4537D109;
	Thu,  5 Mar 2026 19:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="osF2Oax8"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010014.outbound.protection.outlook.com [52.101.56.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3458238C1B;
	Thu,  5 Mar 2026 19:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772738551; cv=fail; b=l7Dd3OuNW69jOdwIBEPIzvpZ3OUaSn6XuyC35SiQOwXqVeCnYKd298itpjCVkcXPJnH+51XUTfPVoStRTY/hAaErSnxdn9miMkAe/soxNddIKowowotpB/iWood5amfpoiEaDOMQ3RtZqTAu7CffSZmbahMsMWhxGdrx51QKXTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772738551; c=relaxed/simple;
	bh=DPTaK4J/opukvKgIdf+eRTgrt1KgUmGOJkWOR+AnJnk=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l0Zf8I1Mi//KFGHvmGRNTaiEbDE7JZygaxYd3uu4q3Gy9NhRps8rXx9Zx4864w9k8kLFeneII5ZNgeNRiFW8oxowHgda0IzJpNmzaa+C1gZ+3Oc2rkXw8yh/KW6hF9nk6fCu32ctJcnRhp+7vxiMVO4h6k/lj9K9bRdsh9AiZ+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=osF2Oax8; arc=fail smtp.client-ip=52.101.56.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T0uStUcHMvHqXdob/TLfY8I7XmxWedq4kLZBmvhwhLCPDgfmWVLp6YL97jEBcoKM2eE9gQKkPPcMJrHtx3ApfUzohyVQcF38nc4WrHNHmR4XwrM2UFYhqOyLTUr9pxeO0f27CExxA65P4SumbwM3s14oEK2PRm4TFYdxlNMzLRTbkZ8k/TeCp9K6jei8iKqoE+GcqfY5ZdwFRsVz+Os29QI+K7ozJPNRyQxfR7qW8DrzQMlM7+wp+5sQkNhqEQaaeSlXH3r7vN1ivNi1SjVq91gcqDWjMtVxMG+VgRWkXB8pZxBXK2DxGg9eh0Zmjc0YBWg26Es82Kj981YjvfujpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zt2yfzk3aHf1sfmLAFlB7dcEMu8Mt6XG4IYvZF4ompc=;
 b=pqWbcDdy7YEZt9cuyf4tCtXJcsIJ3CAE1gYsPaNXwlrYwsZz1Gbnouim9aP/Q4CuWFu6LnRB1iEvmLAuEEKrDLSPXXNttrSa15H+d61XXFYAOuKcLG0qLdqJDmgsn6+lFGMpyKTkp1kKevK0ytYNliBkxrO9iZXL6XwkCOAH2xMjtFttM0Er2V7rUPxCMVmE4epzByDpaXC4If1wKootAYgHP2RPmwLYKV2HcJdjNXGaz2/LPFk7ztHni6vIfHf9N1LDYUEx8tUvWZxXSed/rVdBFlTn8bmXO6Rr9nf2LdEdmg+BpzU2UeLrBNZq145OBn4jCevcr6nQKvaxyK1ZWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zt2yfzk3aHf1sfmLAFlB7dcEMu8Mt6XG4IYvZF4ompc=;
 b=osF2Oax8EGYE3cRK6JMPRh06JcASntzKWftU92RuvzRHUR2DFhChfAtX9mDnIYohq8X1HU20/+RWIL23B/FdC1asgbYAiB8EmXt2ZBJWvItGnf4evSvlnuOQ89Y8z33c4fsr6pgE9YcJ+MYXWIZVl2ka6szEV5j2ov63Fe7hMRQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by MW3PR12MB4362.namprd12.prod.outlook.com (2603:10b6:303:5d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Thu, 5 Mar
 2026 19:22:26 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.20.9678.017; Thu, 5 Mar 2026
 19:22:26 +0000
Message-ID: <6a4f4ecf-ffc0-43a9-98d4-06235b42063e@amd.com>
Date: Thu, 5 Mar 2026 13:22:21 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] x86/sev: add support for RMPOPT instruction
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: Dave Hansen <dave.hansen@intel.com>,
 Sean Christopherson <seanjc@google.com>
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 peterz@infradead.org, thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, ardb@kernel.org, pbonzini@redhat.com, aik@amd.com,
 Michael.Roth@amd.com, KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com,
 Nathan.Fontenot@amd.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1772486459.git.ashish.kalra@amd.com>
 <8dc0198f1261f5ae4b16388fc1ffad5ddb3895f9.1772486459.git.ashish.kalra@amd.com>
 <aahH4XARlftClMrQ@google.com>
 <7ab8d3af-b4f5-481c-ab2e-059ddd7e718e@intel.com>
 <0fbb94ad-bfcf-4fbe-bf40-d79051d67ad8@amd.com>
Content-Language: en-US
In-Reply-To: <0fbb94ad-bfcf-4fbe-bf40-d79051d67ad8@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0040.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::8) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|MW3PR12MB4362:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ad3998f-180d-44d7-b1e4-08de7aec88ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	7HZXaD7/+/LIPeJcZz1oqck+gMUIo+T91FskFhsDOFeSrP8s5wCrSg4nCpNCF4H7LHdyn36zMogzYkQvZexwkPkguMHExxDM2QcFKLb6ZpWAdJbmuGaTTvgiLeRmwb+uZI6Iq3E9ZScbRYGu7Mc9JPbQ1IAM7c7v3t4VWnP9xe3W6rjBfQRAzXj3gnI9Be+inX5AQ332aYeJJ0DrMOZLMMqhC7Yq1ECoE/M8VEjFccLzYGJQ/copRWY4Lkd0f/kXECPAYe6RwKjqHm8UkgDuIy9QMBptheAmE/DfMawC/ZE/MmaJLD37fRrqZqrSKaYMhTe+ZL//RZkqrSpXYt72F/I5gq8JNPpNmVoxYvjxdLrzSqtN5S70quMt7kg5hmJPP+Qi+iu8Ne2CyHErfpswckiFX7aySka/22uqPjIMCGmhW9Wfl+3Cw8nMSHDJe8XazOHgfoUZ1TzRotHkU8lmSZyE/HxpuCoFYgU1eJTq9+Q30ugSR8Mb4G/XmTiWoLE0nSbSFVUM9ziaWYBzwf5cpAHxthj2jr7JiyuFelqZKkk028hy8tus8aPK7IM2USUpz6WhMJuaQDIWWjRG95ynY1TGv6QOGitmnyfO4HEA1Gudqotm+9MY2jPacLESkDoQlGvoDnwLkoLSp4tt/JkGdEn14RcrCVGlojEDW+P3DRuQ99xGhi5/wq/XK1t4qlkNb8zD6L6Za/Je8zcC0TE+n9u2qSanwFuR+yGMPKPfeN8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L09pT1hZV3hLS0ZHSmc3TnVpbm1mR25MY0VxZE01TmprUnoxNEtVdW9SVDBY?=
 =?utf-8?B?Vk9ZL2NZSWNieFFJc2NBTm5oMUtzM0hpbVlhUUs2S29aeXY0YzFjc0hNWUs1?=
 =?utf-8?B?Uk94UUt0OGhoUm5lUUdvZk40UFVCZHFCc3ArRksyMHlsMjNFdXlrSzU4czlS?=
 =?utf-8?B?ME5KcVFXRkl5SzBQNXlZVGY0ZGxPVkVDdGh6U3IzZUxYUktlZVM1WUMzNFFQ?=
 =?utf-8?B?ZnVGNi9iMTFEQWF3QkdoeDZ1YVFpbEdHVGtGV0ZQUFpYK3NXaTkxUWE0SjFG?=
 =?utf-8?B?aEROaVZVUFdxWC85S2dPSklQU0JZcExyMlZXWDl4REhQTXVoRmExMDlGT0hC?=
 =?utf-8?B?ZTJlVkpFMklPbjBMY3piVXRiRHFzY2I1ZkhQQzJaUUdVSkYrRkEwV01aN3pk?=
 =?utf-8?B?SVlpM0VTeVJ0RFM2TUxzdHI4eXFKWkZCQVNMMjdIdmRoUlg0bzBmMjlFWXh1?=
 =?utf-8?B?NzBmRHQwK0lSUyszSXlBejJmU210UzIvU3RvK1M5RlRJTS8wQjB1RGx0Rks1?=
 =?utf-8?B?SFhQTndrUHRLdWF3S2ZPa0ZQVEIxUU1VL3pDSFdadzZXVDVhU2FQbDBBaGx2?=
 =?utf-8?B?Ny9zTG1XWFVnVTQ1MzZXRUZWZjJNbFUxVlNiNGQrUmVWSnEyeUdTVmw2Ri85?=
 =?utf-8?B?anhnVlRmTmRTUGthcHM4VmlGOTU0U3UvbkZLd1BHV2w1VW5TTGpFdXFTQ010?=
 =?utf-8?B?L3dhY1JwY1oyZCtNdVlXS2E5Q2IzSjlGTWR0aWNSUDV0UE1yVmszT04yYURx?=
 =?utf-8?B?dlJWTXlSS1Y5ejVjcTVQR1FzNUIwT0lmbllXTDJvVmxrY2ZwQ3VuQ1pPMWJ3?=
 =?utf-8?B?ZkY1aDM5alFlK3graTkwNE1oYXloK1BhamFpM2hxTHZlWnJLL2xDRk1seHZ5?=
 =?utf-8?B?N0p1b200U3V1Q2svZkY4REl1VWF6UVY1WkxpYld3M3RHdUUwZUtkckYyV0hu?=
 =?utf-8?B?ZmVLRG1DbzdsRGU5WnA2OUI2ajhLdjJveWg5d0dKR3JVbEw0aGRyN2hwd1Z2?=
 =?utf-8?B?NElZNFordlFIVnZpMFc2L0hkYWVWRnoxSTN6SHR0UHUxQ0FpWi9tMC9nb1RI?=
 =?utf-8?B?ZG8zZVUzRkRqcyt1Tmt2d2xuNmlXRjlFUThFWEVlNXRBU2xtdnNyUTNJZzh2?=
 =?utf-8?B?bmg5TjNLS2R2ZUVreG1yWVFZR05mbDAwRWlvSUZZd3EySmxSa1BIUGV0RXl5?=
 =?utf-8?B?dmVLcm9PL2g3WnpWNW1mcDJ0QlJLbXplZjl5RGhuN1p3N0hiWkQ1YnhxNWlZ?=
 =?utf-8?B?VFFkWmJXd2xuanlSNVlRV21mUjMxSHVSUWZLNUdMR2U0N2xHdHRLb0NDZVZp?=
 =?utf-8?B?QU00TXJ6c0FJV3A5WFJsYXFnVlUxSC9zOGdjS2t5MFNuNU9ZNHp1TjZJRjJX?=
 =?utf-8?B?R2xuajlpSVlvbll2Y1J3QTVZQkdwZ3pvZUg3QzUyR3Vyc29hNFJmcnV4ZFZJ?=
 =?utf-8?B?VDE2UUl3aHQrejRER3pyRjZQZ3c4bWtxSVJMeVJFNWpreWhzYk5Bd2ZkMzVB?=
 =?utf-8?B?ZGtWSzFKSWNXV2FWdXczSkNoelNLdVMwMGhmUU0vdTcvaFZ6ZkxDekRXME96?=
 =?utf-8?B?Q0ZZSkxxcVZjdkFlRDVYTkFSLzRSclV2YlgvUGgzSkF6WW5wUll0NHN6bS94?=
 =?utf-8?B?K1BYZ2JVWENTdFpIZ0R5V2NwcHZpT0pvemdVNng4Z0V0dkNQay9QcEYxN1RE?=
 =?utf-8?B?K1ZWTSt2aFhzOGxXb29aMVNSYkU5M0h3cjA5THlodk5HMFhGSVM3LzBkenp6?=
 =?utf-8?B?YXl3K2V1Yy9XRURjRklXU3hGcDFSRUsxNlljZWtKa09CT3N6RG5Ja2VPNlFI?=
 =?utf-8?B?bHZWS0E5aWxzWEFROERiOGY0TFNqVnNFWlZqUWx6c3hzYUZneCtIaVk3dFU3?=
 =?utf-8?B?Y0Y0WWNuY1RLQlhmdDNMQ3Bzcit5VU5mNWNKUm9zeEc1anhMT0JTOHVmUDRv?=
 =?utf-8?B?YnozL3QzTi9rVWlOb0hnTlVtUVdwOFJEa3dwUzU5cVFYaXAxaWpTMDdPdnEv?=
 =?utf-8?B?K2FUb29MdGs3UkVrajVhM2h0ZkdEN0dXYzN2akltWW5DdWViWFNrOTg4MFUz?=
 =?utf-8?B?aTRNVFhvVEovRDFhY3ZtZTdvZUpWUW43SnJUOTdVZmFDOG5ZZFpoRUlQK3Fl?=
 =?utf-8?B?b05mc3YwM0xEb2dWTUh3dDA5TFprN2NHKy9uSUxNRlRlVUNISWRiKzBXSUp3?=
 =?utf-8?B?L0s2dk9SUE1lRmZmTiswendZQWRYMjdOdDk4OHMvaDlQUy9QYnp3NFJNcnc1?=
 =?utf-8?B?VTJ0ZURxQmRaclN4M0ZFSlpta3VCZlh2S0hUV2V2cVc0cXVVbmpnSEVvSGF3?=
 =?utf-8?B?RHg2ZDY2QnVXV2FJTWx6cENaNFhmSER4a1YyZGhLaE8ySTM3ZHNMdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad3998f-180d-44d7-b1e4-08de7aec88ef
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2026 19:22:26.3723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gQPZ7Zs5c1VBMEXt3Q9/J4wMncY8/QrEr4KpuyN1nTjzSDxDL4+sRW7M2KztkHRgDTceNJzanyii4f26kbhmiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4362
X-Rspamd-Queue-Id: BD91E2177C6
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72939-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ashish.kalra@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

An update on performance data: 

> 
> RMPOPT after SNP guest shutdown:
> ...
> [  298.746893] SEV-SNP: RMPOPT max. CPU cycles 248083620
> [  298.746898] SEV-SNP: RMPOPT min. CPU cycles 60
> [  298.746900] SEV-SNP: RMPOPT average cycles 127859
> 
> 

A single RMPOPT instruction should not be taking 248M cycles, so i looked at
my performance measurement code : 

I was not disabling interrupts around my measurement code, so probably this 
measurement code was getting interrupted/preempted and causing this discrepancy: 

I am now measuring with interrupts disabled around this code: 

static void rmpopt(void *val)
{
        bool optimized;
        u64 start, end;

        local_irq_disable();
        start = rdtsc_ordered();

        asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc"
                     : "=@ccc" (optimized)
                     : "a" ((u64)val & PUD_MASK), "c" ((u64)val & 0x1)
                     : "memory", "cc");

        end = rdtsc_ordered();
        local_irq_enable();

	total_cycles += (end - start);
        ++iteration;

        if ((end - start) > largest_cycle_rmpopt) {
                pr_info("RMPOPT max cycle on cpu %d, addr 0x%llx, cycles %llu, prev largest %llu\n",
                                smp_processor_id(), ((u64)val & PUD_MASK), end - start, largest_cycle_rmpopt);
                largest_cycle_rmpopt = end - start;
        }
...
...

But, the following is interesting, if I invoke rmpopt() using smp_call_on_cpu() which issues
RMPOPT on each CPU serially compared to using on_each_cpu_mask() above which will execute rmpopt()
function and RMPOPT instruction in parallel on multiple CPUs (by sending IPIs in parallel),
I observe a significant difference and improvement in "individual" RMPOPT instruction performance: 

rmpopt() executing serially using smp_call_on_cpu(): 

[  244.518677] SEV-SNP: RMPOPT instruction cycles 3300
[  244.518716] SEV-SNP: RMPOPT instruction cycles 2840
[  244.518758] SEV-SNP: RMPOPT instruction cycles 3260
[  244.518800] SEV-SNP: RMPOPT instruction cycles 3640
[  244.518838] SEV-SNP: RMPOPT instruction cycles 1980
[  244.518878] SEV-SNP: RMPOPT instruction cycles 3420
[  244.518919] SEV-SNP: RMPOPT instruction cycles 3620
[  244.518958] SEV-SNP: RMPOPT instruction cycles 3120
[  244.518997] SEV-SNP: RMPOPT instruction cycles 2160
[  244.519038] SEV-SNP: RMPOPT instruction cycles 3040
[  244.519078] SEV-SNP: RMPOPT instruction cycles 3700
[  244.519119] SEV-SNP: RMPOPT instruction cycles 3960
[  244.519158] SEV-SNP: RMPOPT instruction cycles 3420
[  244.519211] SEV-SNP: RMPOPT instruction cycles 5080
[  244.519254] SEV-SNP: RMPOPT instruction cycles 3000
[  244.519295] SEV-SNP: RMPOPT instruction cycles 3420
[  244.527150] SEV-SNP: RMPOPT max cycle on cpu 256, addr 0x40000000, cycles 34680, prev largest 22100
[  244.529622] SEV-SNP: RMPOPT max cycle on cpu 320, addr 0x40000000, cycles 36800, prev largest 34680
[  244.559314] SEV-SNP: RMPOPT max cycle on cpu 256, addr 0x80000000, cycles 39740, prev largest 36800
[  244.561718] SEV-SNP: RMPOPT max cycle on cpu 320, addr 0x80000000, cycles 41840, prev largest 39740
[  244.562837] SEV-SNP: RMPOPT max cycle on cpu 352, addr 0x80000000, cycles 42160, prev largest 41840
[  244.886705] SEV-SNP: RMPOPT max cycle on cpu 384, addr 0x300000000, cycles 42300, prev largest 42160
[  247.701377] SEV-SNP: RMPOPT max cycle on cpu 384, addr 0x1980000000, cycles 42400, prev largest 42300
[  250.322355] SEV-SNP: RMPOPT max cycle on cpu 384, addr 0x2ec0000000, cycles 42420, prev largest 42400
[  250.755457] SEV-SNP: RMPOPT max cycle on cpu 384, addr 0x3240000000, cycles 42540, prev largest 42420
[  264.271293] SEV-SNP: RMPOPT max cycle on cpu 32, addr 0xa040000000, cycles 50400, prev largest 42540
[  264.333739] SEV-SNP: RMPOPT max cycle on cpu 32, addr 0xa0c0000000, cycles 50940, prev largest 50400
[  264.395521] SEV-SNP: RMPOPT max cycle on cpu 32, addr 0xa140000000, cycles 51240, prev largest 50940
[  264.733133] SEV-SNP: RMPOPT max cycle on cpu 32, addr 0xa400000000, cycles 51480, prev largest 51240
[  269.500891] SEV-SNP: RMPOPT max cycle on cpu 0, addr 0xcac0000000, cycles 66080, prev largest 51480
[  273.507009] SEV-SNP: RMPOPT max cycle on cpu 320, addr 0xeb40000000, cycles 83680, prev largest 66080
[  276.435091] SEV-SNP: RMPOPT largest cycles 83680
[  276.435096] SEV-SNP: RMPOPT smallest cycles 60
[  276.435097] SEV-SNP: RMPOPT average cycles 5658
[  276.435098] SEV-SNP: RMPOPT cycles taken for physical address range 0x0000000000000000 - 0x0000010380000000 on all cpus 63815935380 cycles

Compare this to executing rmpopt() in parallel:

[ 1238.809183] SEV-SNP: RMPOPT average cycles 114372


So, looks like executing RMPOPT in parallel is causing performance degradation, which we will investigate. 

But, these are the performance numbers you should be considering : 

RMPOPT during boot: 

[   49.913402] SEV-SNP: RMPOPT largest cycles 1143020
[   49.913407] SEV-SNP: RMPOPT smallest cycles 60
[   49.913408] SEV-SNP: RMPOPT average cycles 5226


RMPOPT after SNP guest shutdown: 

[  276.435091] SEV-SNP: RMPOPT largest cycles 83680
[  276.435096] SEV-SNP: RMPOPT smallest cycles 60
[  276.435097] SEV-SNP: RMPOPT average cycles 5658


Thanks,
Ashish

