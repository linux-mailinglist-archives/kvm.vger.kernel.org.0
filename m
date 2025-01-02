Return-Path: <kvm+bounces-34471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DF5559FF645
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 06:34:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC03C1882B2A
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 05:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA31618BBAC;
	Thu,  2 Jan 2025 05:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fH6x0oB9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6D74315E;
	Thu,  2 Jan 2025 05:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735796082; cv=fail; b=tK7uB8grPhVuLGlioRPsBqsnWHdZwgEjIXh0yf+KLKFwmEGZaupbUvkThrG+4XlfwqdgomCwR4npyVVl0+lQ78XaYIxy+DII8P67FhMS8y6VsxBz1/F8k+Hmy2bx0YREynUHfIqKlHk7iPuh25arsUQDRWSbB95G6u4+mNv6ELc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735796082; c=relaxed/simple;
	bh=aqfyhTaSWZ+Av1W+pC0M4dR3XvVOYIEmcKzqV7rn2to=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=F1x7e4YUL9bthfeew+UCUVGEWEo9xeBCqphYevJipOziLPKSx5h0odoQzdqv5SV7kkMg90QTJzbJpfVgBHmouVS+KxyhBKcxhD6dHvL4Wv2hsTeQxAQgwf/jW2AJGBDIH9s+UkhaKV3CO0f1ntuce8nRRBdEqir8Hdl3IyDfer0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fH6x0oB9; arc=fail smtp.client-ip=40.107.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pjpSUU9p/S2YOBk3XGe6hCSStyXsNyxKz0Bjfpw0aCq67KnOSgBjtp2fOIOm+7UAPanSeqe/v5pLnSfWEf1yBDjC2cQBs6EfHK1ksKY3yD/PbPJwD15rMLLUGxHqvOYv9coKz+8vvgPKYrGwbGYk6/qTsW2C5cq64KTE+kvNbgCBm38uHfIQSVsGPeNv+VubccSgmFPkcW7r6nQlB9CLpS6oODPLppi2bdrWOVUCz2XznYH+cS2W2F7Fg0iV8o+ZGJXDAz5LsivOsgZKXLeHbjQdevJFqx9WODgK46Y6zCoqwEsILJTvoA8tink2d0a+AN+4furxahdYMrIx2SB2Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WOIq9ruraSM9oOqbKuE7ET5TIKOJNErEkYVAypYq6/M=;
 b=PMt4jKBR9VYg8NTK7gKpZ9Um5f03LyWfUYnvYYdkASoErLH5XTYm9qwX3dPy+ZO93nxL9t/2y/ReBkG1iQ7JtkMZpZKJFBwppMnBpJoTaLYbdRkGk8tycfDnWGE24TjI185/F5rsE+o842ZZW/hUr2U6kdCt6aGLpFLkpX2NajTELp0hEJ8FFrmN6fJSV/+3BRtIC3zD/SxHWrEmngV3CIl9SJ3NB5VhSHaKZrMVKLxLBSbJmTk4e0/nWbKPyxhJu0zdwlr+ciPK4YfUSJe4glIy/dbUS8333eSzddMkGoBuQUri2NKMVKb10+wMYtNnM0mNfiM1kIfeczkCi88FbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WOIq9ruraSM9oOqbKuE7ET5TIKOJNErEkYVAypYq6/M=;
 b=fH6x0oB9t0RLLbVB8H891V+hcpxGI3ZjAtrpMqMqUX4c+QniNCpw5fhJ8d2Nx3HomnQE8p41zBhmzUm7k5JqvK0F+Py5gNwaDr+pmSYeHKaLQd5m3MtQateL+cufQNWH9i7DxB1Ln3xciUjRBgC10Z+xHvvooNsvACa6nEgtmRM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 IA1PR12MB6651.namprd12.prod.outlook.com (2603:10b6:208:3a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.20; Thu, 2 Jan
 2025 05:34:34 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8314.012; Thu, 2 Jan 2025
 05:34:34 +0000
Message-ID: <09187d10-78b3-402f-be77-138cea98d8b7@amd.com>
Date: Thu, 2 Jan 2025 11:04:21 +0530
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
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250101161923.GDZ3VrC9C7tWjRT8xR@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0196.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::8) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|IA1PR12MB6651:EE_
X-MS-Office365-Filtering-Correlation-Id: 466f242a-c7ac-4a6d-a9bf-08dd2aef235e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UUFQY25jVUN5d2FGY05iUHJoQ1lqRkNGaWlkYlNuTmdnSGpmUDNtZTd2c3VY?=
 =?utf-8?B?ZG9FcWpQNnhkdlcvVnpzajFmcVErWTg5ZjBleEVjRkdZSGV2eC95bzdRcGp1?=
 =?utf-8?B?Vm1NSTdmck5jMjlRaHJSbVJWUVRSY0FJY09aTnZLZDBtZmNrMWI2ZmJhc3ls?=
 =?utf-8?B?UnY3V1RFdnFBeUw0dnBnZnFYaVF1U0plQjVyL0g3NmRBNDYxMjFzTEx4bHY2?=
 =?utf-8?B?ZlNXa0t4c2ZmSVh2QnBDQWk3WXdidW41d2QrRU9YOFBjQTlMdW1rd0FBdUYr?=
 =?utf-8?B?aXh5eGRyeHp6a29pTml4Q3hUR1RsT0YxcTUreFM5MlYzNDM4bWpHQUpqQSt2?=
 =?utf-8?B?ckJRTndPQ1lKalo3S3V5TlFiQytOMkxqVjZ6LzJ4N1ZOZkVjQzk1QnVNZVNq?=
 =?utf-8?B?NGhQWFNSeFRaWEcrMC84RjU2R1ZLSmRkZDZxaWMxYmV1Q21xT1lnRFhyRkVD?=
 =?utf-8?B?aXM5MXBKWlNJd3pjZUpGZ2o4ejlLQ0hWdXIrc0RLVXV1ZW93MDhZNmlyWkhi?=
 =?utf-8?B?L2VLSVJONDRNdStRUi9XMnVPYXArTUhjTlVrUWN6Si9ZNW8yUlZkQmZURUpq?=
 =?utf-8?B?UThBc2c3NW53a0huUHBSa3ZqQVZ4WThNZFcxcWVReFpwbW5EM1VPcUJQVGlh?=
 =?utf-8?B?bVVLTVBXayt3bkhMVlIyUFpPZmppenRPL2hhNkhCVTFRNytucklVTStFdlp2?=
 =?utf-8?B?V2ZtT1I1SDhUblV4QlhZMTRPZEg2eUEwMXVKaXozYVgvemR5djltZmhmRUpQ?=
 =?utf-8?B?amU2QVU1VURlY2pmd0ZJS3JFQ05OOENkWlhKRGFvbHRjVytqQnpxNi9odTky?=
 =?utf-8?B?aUtXdmwrdlVkTVN3RmNYUXFxL2hUWVh0cUlzd1hWY0hIb0YyU2FaMVBJQVJn?=
 =?utf-8?B?UkZGY09LdnVnQkhMZXpLWm9xQVpBeis0enIwREx0NkJNQTNmV24zN1d1ajdS?=
 =?utf-8?B?YWNNc0U1SDJtc2ZGRG5zMTI4QUlxd2RNYjVVTWRpQTZxc1pqcUt2TStsRGdZ?=
 =?utf-8?B?L2Z6NHRXYXZuV0RjYmFDVTF3UjhRM3VrTzBDNjNMQlJPV2hMZ2dVNVRMbmZh?=
 =?utf-8?B?SEhzTzRvYllJR21qZHUxUlkybHoydWVIVStFdVR5S2NjM3VENnhIUUZaM28z?=
 =?utf-8?B?ZXpnc3ZRT2Rqa3dKTFdTNEtXaVJoYkhGcW85eVp0cjc0cWErZkZFVS9xbWF1?=
 =?utf-8?B?OS9ENEZkYVQxYjI3NU0xUXJvd1pJZzB3VUlWN1IwWnJmUHF3bytWVUZtSTF2?=
 =?utf-8?B?N3U4czM3NkluYTgyZmdCeHBIVXVYaVhOVWFHSWprcEJRYmozdVBIcVhPODlv?=
 =?utf-8?B?ZzRFd1lKWDczWURKc09RZk40Z2VtUmtEd0w3eGtRMjRNZDRqR2s2NWRhUnlM?=
 =?utf-8?B?cFlpNFFwQzZNU2N6Z0x0eGh3SUZFbjEwNk1GS2hmcWIvZkhiODEwZVh4RUM2?=
 =?utf-8?B?aEc0SHFrQnJRYm9aQnkrVDJwbU5vZU1peC9WTjBUOU8vV0ZjM2VyTFllM0o2?=
 =?utf-8?B?RW8xQUVVQjBidFVaUDlpcGZwN09PaDlGSUZXZFpyaFFzbWlXMUJ0Z1JIWm1s?=
 =?utf-8?B?b3JjTGdvU3BlRnpXS09JQjQzS3dYRFFHM0hXeWNYNVFxUXQ5SFRwQVpkMS9r?=
 =?utf-8?B?d0xNRTZnRUZYSkQzWUdkK25KL0JtQlgxNVlOdTVGNkF0MTk2RThVU2JNc0dI?=
 =?utf-8?B?TGdBbkhXa0FGVWRPaU1nS3FzdTNuM1lRdnRSd0Rmd3pWb1l4dWpFUElzc0lG?=
 =?utf-8?B?elBwQW42OWd0Y0RqK1FDT3ZYeWc1UllxTS9CUjFCZnpQMDFsbjV6N1IyTU1P?=
 =?utf-8?B?bVIzSC9qVkJCTm1DYWRIZG5ERkpPOGJHNFZ5SzlrRGJZeGVjOXAycFhDWUZp?=
 =?utf-8?Q?ZPGq88pht9c9i?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SFc5SVNDd3JOY2VXaXRpdzVvSWt2STBLOWZzQ3dUSXordXlEOUdIQjY2WnlJ?=
 =?utf-8?B?N21UZHdHYTE2Smgra1h0bDlCOCtXSWJNTkdEeDRiUlBWWVY4M1lwMXM2NEhT?=
 =?utf-8?B?cXJObWhvUlZDWlhQSUg5cEt2cURRajNlWlZwbk1oaDFxdmNzR204U2RMVXh6?=
 =?utf-8?B?OERpTndocm1xZ09hamlEMmI3d3dQYXhSa3NSZVhPVUc0NjZ3RGZHNXhrNmRG?=
 =?utf-8?B?dzJWT3EzQVZ2M292b05icHdxc1hlVWs0VDlLTWhTaDN3emdMQ0lvNTVwZkQ2?=
 =?utf-8?B?YUZTZVhSdGQrS2hpYTFRdUR0bUE4Wk1OSVNudzBXZ3IySTU4bXdRSlZ5elZt?=
 =?utf-8?B?SDdTaXozSi9YMk9WdjJzV05PWi9icEdSejZGNjZVc2FLVE5COCtwMXI1aWtN?=
 =?utf-8?B?amtZaUh6SGMrbDBwaU11d01pa3BPeXFsNGJSemtIY1R0WGlNSXYyM3J6UWFj?=
 =?utf-8?B?WlNVNUdSK2wzRmplK0h0L2Fsd1dReW52OCsxZ0hMaXcrc2xwcTJEdXlmQ2Vr?=
 =?utf-8?B?aUVtL3RTZVBLanpiU2ZXNTN0dWxMeGUwek9YL2d4RGtVVjNRNmwvWGFiRkpr?=
 =?utf-8?B?Zzc5bWFNNFF5ejNFYVZzRFQzRVNBZXB3d3N6dXRFMy8yK3NtbzFQdVJHdWpk?=
 =?utf-8?B?RC9rRm92cXd1RHBjNGZEdGFzdFkvMXd5RDJvSzdaWjBXWWlSeTNmZnBCOHV2?=
 =?utf-8?B?cGJTUWZORmFGK29yWVNkRThONXdXYWtpU2tYUG94ZW5QV3JYNnl1N2h1anlK?=
 =?utf-8?B?RW12QU83YnZsV1Y4b2gxcm1QcGNDUVpNaTdQd29kMmN5Y0JmcWZzRUhRT2g2?=
 =?utf-8?B?NDl5Yk02STlmOXMwQ0U0VDFIaThsV0wwSmhqRUNVYlRkTTF4VzBZZmw4UFdD?=
 =?utf-8?B?dDRNVmY4d3JxNnFYWTA3cC9PZ1YwaVJZVlpHbTN4cnM1V3hBU3lMNVZwRDMy?=
 =?utf-8?B?OVpZWm9DRmcwY1hwV2FHWWNnQ3VMUEtxQUFzajRkcXhobXRRd09DNDJSQmlZ?=
 =?utf-8?B?b2JvWVptb1o5d2taVERWU0V4WWFveThGUklhd1R2emwvSEttbHVNMEdBbWZW?=
 =?utf-8?B?Q0tFcGkzUDQyTkVOdVpiNUQ5MUM2TEFVYkJGdWRXZGVYUktpaXYybStGd1Z4?=
 =?utf-8?B?MFNPakZ2dVo5TmZ4ZkV1Q3NKOWwwaDZRNlF1Rkpvd05ieHExaGFBV1FLU0dT?=
 =?utf-8?B?RHFySHlSckRkTUNPVkt3VlhoYlJYc0pqYUR0Y1FRYlRBY2l1Q0JjYVlsZm1a?=
 =?utf-8?B?ZTlWZXU1OEF4cUkzMHNENU1LVUZjNHZ4ZWVzdllLcWQ0dm11L1BLQmFhL2th?=
 =?utf-8?B?U2lFVUpCWFQraE5lM2RpRHRYTWRqOTNRYVIxOEgyUkdqOWNOVUphK2Fkb2Vo?=
 =?utf-8?B?UUI3aWlZMWpGM24xbDViODlwTk91V2JJT2FmVlFrMGV6UmF3KzR5dUtZVnBj?=
 =?utf-8?B?cHF3TzlYL0FEQXB0TmNwOFFGSkZjRE4zRWtZMHRpVVhXb1NXVWxaMjNBUmxr?=
 =?utf-8?B?UjJnV1pjQnoxbVRMQXk2MndUVXdFakRHNE1mL2J4YmhXbm91UTdjWW93L2ND?=
 =?utf-8?B?UXF3OGhrU3RqMHBicHg0SDR3ZTNudGtaL0ZSODJoa1VjeUV1TzE1VWl6a3k3?=
 =?utf-8?B?RVd1c1JSbFlHRkl6M2IzN3o4N0pGMUVScCtIVFVvbWxvMEZvUXMwcmd3SUhp?=
 =?utf-8?B?ZzFRK1lFSVRORVlXREtGWTF4UFJmclZMSmRuaTVTZlBsaUx1emplMXhSZjVq?=
 =?utf-8?B?eGdyeVhtSTdXVWt6R09CYmpMdmpZL1dxekYzb2pRN0NnY3ZENXBFTHNEbk40?=
 =?utf-8?B?QlVuMkpKZkVCbDJQMWRHVStTZjQyMVc5NU1JYUxkVXF1eUVIckRQUEd4MWxI?=
 =?utf-8?B?QTVodGQ0QlR6TDEreFFHQlAzUDB6WVFtVmVFK0xKb25vWmloYk5QYUlESlpN?=
 =?utf-8?B?TStuNGFqZ1pxNjk5Q2dHUU55Tkp5TkJDaHVoYnJDckpCdzd0TWFPKzFZZ09k?=
 =?utf-8?B?eEVVeUVxRnV1RUdpU0dpU3h4ODZIY3RiZmwvOGJ3TUNJNEl5M0pHa2t2eVFk?=
 =?utf-8?B?Y3o2VVdLVDJqSWU2RDhXaWdBd1BLMmhMRlM1VWFsbno0VFZ5UzZiK3JJdU5h?=
 =?utf-8?Q?RIHEsCrQYK3KSd50jBRXTWmyC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 466f242a-c7ac-4a6d-a9bf-08dd2aef235e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2025 05:34:33.9693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OC4Xu7yfGWva8LABg5hlE5Qyeepu1qnVNGwqDB6COq8CicYq7iJ7Kiy0OY7rNT10qruihtSJBvdgev7O22ZZ9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6651



On 1/1/2025 9:49 PM, Borislav Petkov wrote:
> On Wed, Jan 01, 2025 at 03:14:12PM +0530, Nikunj A. Dadhania wrote:
>> I can drop this patch, and if the admin wants to change the clock 
>> source to kvm-clock from Secure TSC, that will be permitted.
> 
> Why would the admin want that and why would we even support that?

I am not saying that admin will do that, I am saying that it is a possibility.

Changing clocksource is supported via sysfs interface:

echo "kvm-clock" > /sys/devices/system/clocksource/clocksource0/current_clocksource

This is what we are trying to prevent in this patch.

Regards,
Nikunj


