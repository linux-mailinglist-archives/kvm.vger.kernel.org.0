Return-Path: <kvm+bounces-51347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE684AF6449
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 23:46:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4DA23B1B55
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 21:46:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56C2623D282;
	Wed,  2 Jul 2025 21:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uWIRhDgP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31C12DE70F;
	Wed,  2 Jul 2025 21:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751492807; cv=fail; b=cjjbEJqdudA6ujK7lcYw9moj8g5Qj04mzveJF98sybGXOp2ANI9EdsjKrwclzb2EqpFYKk0DITQu/889Ddx75OPSASjsvJqYGWXrNr9m1CHaogMywxNZdGlvIT3PDSp48KKysw99yTJlabKcQ7WXbdgHfd1IyC4WtUbyTwTu6MU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751492807; c=relaxed/simple;
	bh=yGeYR7nvxGL6UO8YYs0TxyoVNG8dPBI3FhKm5S2h4Oc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=e9+N+QzChpulcsR/oiud2CHG/oeHnvsv5sW69uP2QcUipoTnMebNJWgktGM+isIpiJfx2fr9Ug5AKnpaYc6xgV34UT2w6EIYyCmzxRtGJYdD7ah/xXnTRHPN4f++DduQ0+EDdQEck3ne4ZU3zZwMPAcpnZUtDnWlz5wkSGeqJx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uWIRhDgP; arc=fail smtp.client-ip=40.107.223.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YFOHkk/nNWJNztzIE4U84JXfIF37sYLHAa82mXKz9Frohm5gR/MzHJo9UAIybK7cteI2/22dS5GQj5RwEHcHDtW+sygeSY0egzpNe8X2Xec5VhpVFTZZKOOKZ8ES4+vg+D7YS/oYlaOExsDZxKlwW1sIKtzASsXN51/7LIDnPzKIlx3L09SIEiJJez1cRQ3EDRosJypPYj/gqlbsYtn0OxNohSLUDwJMx8sf+ZMcFOqpC8ViPD3e2xDFoINKa8ekBxJ7Vbcd0qEYLNEdv6Fc4n8sAceEO9hyhv47CHprKBmcG0nDtb78tCuI0abj6oIkIJxn5d5MdsyaDWe1Qpe5pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mY21lKKfYmqhWco7iGUmC6iniWG24YVNC9Ge6ifHaa0=;
 b=B9iQXLtcK7DbrVc8IshVNkklr4oKKoYT7F1fSoG9NrHxLrIzsZE4l2EqHTuaDWQ/LeKfNtpCa7m4DfvrauSxVYOokt3S0KWPSL38K1RfKyODNLzXIg3ENRUiTCHwczu45VBZyPn/lcTmvX8rMs9bTLpgYGiy2cRMCZSg2A4bdQz89P2mwvdSRFxEwcV4KyFmhhmebFlgL7EsIAWgrKT+1HdCgnUO1Kb1vljPmGQdrm2otmNtdeao26kvk/hFpuBkwHuvTZzXqtDfZQfGxzdCohH5KxJed6hL16qT+2mo/mOvPvu1tVduJqGim36gOZfBaD9cGH+SZ6S3Co54wHUcBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mY21lKKfYmqhWco7iGUmC6iniWG24YVNC9Ge6ifHaa0=;
 b=uWIRhDgP8K4WPtRQWXrPbGUK7KHAeXhNx5UHJ55fNuinU1E2gkgd3ucnbfUoz7ou/xNz8QbYvNXA0wWqcbiETESGuc3gY/aAKd3zXmSBhl6ZuzkmHRqDu8/7K3fkbudJhVKicv5nnx1GWKGSOqx4pV4JluIctBUtNZZC5SvYV7o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 IA1PR12MB6604.namprd12.prod.outlook.com (2603:10b6:208:3a0::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.19; Wed, 2 Jul 2025 21:46:43 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::66d2:1631:5693:7a06]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::66d2:1631:5693:7a06%7]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 21:46:42 +0000
Message-ID: <790fd770-de75-4bdf-a1dd-492f880b5fd6@amd.com>
Date: Wed, 2 Jul 2025 16:46:34 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: Ashish Kalra <Ashish.Kalra@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net, akpm@linux-foundation.org, rostedt@goodmis.org,
 paulmck@kernel.org
Cc: nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, arnd@arndb.de, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <cover.1751397223.git.ashish.kalra@amd.com>
 <b43351fec4d513c6efcf9550461cb4c895357196.1751397223.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Kim Phillips <kim.phillips@amd.com>
Organization: AMD
In-Reply-To: <b43351fec4d513c6efcf9550461cb4c895357196.1751397223.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0148.namprd13.prod.outlook.com
 (2603:10b6:806:27::33) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|IA1PR12MB6604:EE_
X-MS-Office365-Filtering-Correlation-Id: 814a3d58-8933-4f05-d7c4-08ddb9b1eebe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WWxKWWx5VVcrbjM0OCtBSFMwcFdIU1dGNHNySkpkZUpQRnNKSzFZUTRJQjhz?=
 =?utf-8?B?emV2R2NZcEx4ODJ1SWhGY2VSQWh0aEVWWlZjeUlkVjNGR25lQ3VJS3VFaTZ1?=
 =?utf-8?B?czRFZlk4UnZWRGxZOG5sQmNTUEUwaDVady9vWDlEODU1M3p2V0RCYUtKSUNo?=
 =?utf-8?B?d3M0VmhpVEhSUzFWREpPaUlMRFVUVGhvb3dTZXRXZkJiLzYzcVBGTGtnVy9n?=
 =?utf-8?B?UGEyY1dzc09Va3Aycm42MlROalBKM0JCaHhhSkVXYnVGaExNUVFBNCtBSVpD?=
 =?utf-8?B?aXh4cG1ITzNYUW9rdDZtWmhJRmRHcjIrRHFwaEVjME1MUE5DVHZkcVdpbnlK?=
 =?utf-8?B?SmptbVlGUTlmL3QxMXNSMEJtcVZLUVFGY3Nzd0M0c2lQS0Fwek5DSFVwVjZW?=
 =?utf-8?B?ZC9taVM3aTRnVVNoWGk2T0VDSk1rblVEbjRzZjJVc2RVVE9yUkUxOXJmY0dB?=
 =?utf-8?B?Zmx3T01ESkZ4OER0Qi9IRWlIaDYzU2xhQVdOVlNxSlBvZ2tJbjVqOFJVMVhJ?=
 =?utf-8?B?engyQ3ZTak1xM2lOZlAyWHdUN0hUWkR4ei95c2JqTGpBWVFpR0NKdTFZZmVm?=
 =?utf-8?B?aG4xMjNFdjhNZEVkSTdjRmRpUmNxRkJRais1NjhQNStlaUhUUno3SWtYbTdz?=
 =?utf-8?B?OVlOdjRkT2NGQlRuNnRQcytmc21IMmZqb2F1VWFMZWZXYXV6M0ROQ0ZZM2I2?=
 =?utf-8?B?VXdlUVM5eUJiZHYxTjJHcFVOcXVZdTRzTXZ0RlAxMmJISHNSY2pDc1E2b0Er?=
 =?utf-8?B?WTVBdmlmdDJGTWxXRExsMkNUbWMzMmdrY0Q1dEdYUlVaNzRFdWhQZENYWW1L?=
 =?utf-8?B?d29lZVp6V1F3dFhjb0JTdjdPNGxhWThlTGtlMUppK1FlUS9VM29HN1c2MExa?=
 =?utf-8?B?Q1NlazdsQ2tsQjlGaVJzZmZCSFg5ell2RUYxSDdPS0svektRam9QSEdPNFdw?=
 =?utf-8?B?RFV4VUk2SkZQa1NzdFBGUFVnUDFmMU1sY2VCT0pxdThkUUZOaFRNVU1EbVpX?=
 =?utf-8?B?K2ptWTg0Q3o2NXJCTks0SEkwTDQ0NXJMY2FXbS91U3RnWitVV1pVcUNIMHFj?=
 =?utf-8?B?TjM0S0dwV2gydjFQRGw4dDZFTnplL2ZIM2ZGdXBPdWhPbCt6ajVOWitSWmV3?=
 =?utf-8?B?VFA5OFZNb2xTRWF2TGNTRWZxNHFZNTlkRHJES05SQ3BhdHYzTnNoUUd3Rlht?=
 =?utf-8?B?SFlUSWVVeFRNV1Jwd2tUVG9hVVRDWDM0dnJpdnZmc0ZhWU50Y0lnR3B5b3pn?=
 =?utf-8?B?RDRvdVpxVUJ0Y01aQVVLZW9OOVVWVmY1VCtMQ0xGMGUyMFpzWmRxandoNEpT?=
 =?utf-8?B?aXVFNEFuVnRDQVBGb3Zac0kwZmI5WWpBK3BZRVBJcjY4aFBJMy9mZ1NPRTY1?=
 =?utf-8?B?anFUT1Z2QUxsZmZNQTZWZHpaTnZPTWpubS9sNlQ5Ujg2Z2p2ZDVqTElYZ2V6?=
 =?utf-8?B?MFgxRHQ2K0R3OHhIZ2FKSmhyM3VmU0FRZ0hETGJ0bkhMc0gxbWRRWHhDM3lY?=
 =?utf-8?B?by94VGhKNjhrZnFGRTd3V3hSZ0FxM1NmZDBZWmdPRzZyQTNUeUtnVG5XVk81?=
 =?utf-8?B?ZmVTcFhlSjduNkRFdTZ6WFE3UUZ1cG5zdzVrR3pSUlRyNW1aRnpaMDNBREdi?=
 =?utf-8?B?RkxRV0hxbi9VMVp3Szk5VlZNeWNKME0vQnV4UytGY3V6L09paVZNNU5adngz?=
 =?utf-8?B?eGxJS0MrSnR3QVVhdVB5N3Q4UzJSTDhxQzdPWW1vamFBMGhqeGRQT3l4TDBz?=
 =?utf-8?B?TnJNYlJyTFl4c2IvZmF5RHI2bzdpWGE3UU1UUU5iMHI0ekl4TEZXWXNYZE5i?=
 =?utf-8?B?K0xFTmgvK3RxTHNwbGdDYWRPd1NOeEJjeExhaWJiZ3JTYlllRmZ2ajhCTFJU?=
 =?utf-8?B?RGhZUnFJQTllLzZpQkpCdDYwWmh6dXFLR0szM1VQWmY0eWJyNHZDQWZrRnll?=
 =?utf-8?B?ZEVTMy9XblBtVE10ME9sVk5TSG5TUTdRakV0bmxSQXpRRHE5cmJJajJHcENk?=
 =?utf-8?B?Qjc1dW9aTHdnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDdsaXQ2RXJyVjJtMHkwUlcyYmJtdzB4MHB0MldVWUF6ZEJ1QmNZTldycURr?=
 =?utf-8?B?NEpDU3U3RjNYYndGaVVPMVd6Sm1VQTJXYm13RncvZnB3MDQrQk56amJ4VS9V?=
 =?utf-8?B?RGl5anhjUWFYMjZ6TjJPRTh0aHpnek9XZXUxOEJudGhsNWQ3WFMwRkgrNVBw?=
 =?utf-8?B?RDlpQ0hBbEhxdEVRRTdKTzlFNjBLbzRmTlh6SDB3WDJObHd4WDYrdEFDOEFt?=
 =?utf-8?B?aS80aUFQaUV2RkdFYjUvVEFGREpwRUtzK0l2OEhTVS9xT3hjdjFVTUdGQnQz?=
 =?utf-8?B?VG5xak5rVGhjSm1ucFRrWFRkZnA0NUFlSVNiaUlsTzk3MHd0NjN3NUg1eUpL?=
 =?utf-8?B?SjEyd3JSZFo2L3RyTnB4cjJnRHovYVVIQndoVVJNOHpTdndSNGIza0JZV05X?=
 =?utf-8?B?b3lPUmZ6eUZKbHZVQ0lDWTZwYVcwaWlTNHoxQTl5UlV2S1RSWG9ZQk5MQjZ4?=
 =?utf-8?B?K1Q3UFFaVWVkMGtBdFh3aVBJMmN6S0dVSlNJcW5Id0tIM3VTMzM4eS9mNWpP?=
 =?utf-8?B?eTRDVkhJZEpCc1JnckFVcDdISlBuWjE2c3BBd2ZGMzM3ZEpneG85V2FsL3ZY?=
 =?utf-8?B?Uk04Tkp4SWpKdVlvSnV6WktWeHZoQnBicnJVTUErZVUrZzlRQ3FYZlUwZ204?=
 =?utf-8?B?OWl5ZXJiQWhsT2kwTGR6M01QSzgvK2pGNkUrTHNENG9tNHd3ZUxOT3A2Rmsr?=
 =?utf-8?B?RThQM1FlWk1rYWhrWEx3VjJWYnJnQjdJU2JlOXdGRjVOR1hMZi96Y0JRTEtY?=
 =?utf-8?B?cTg1WTRxSSs0S25Jb0JvSWJPT0lBWEZOdUt5VXE2RHJHb3RMVmxBYUMxcjlm?=
 =?utf-8?B?N1hqYkQwdEJUamRoNmFKL2FGNzFzdnlqc1BDeGZRbkNQVFJmbUxaRUJZd29x?=
 =?utf-8?B?ZzJZRXgzUFpMekovOU1oQTJCK0VGL1YxZ2p1QytGd3hQTU5BUGgrNWVNcWoy?=
 =?utf-8?B?OWk4ZllORWx4KzRYL3ozOVN5SU1aaWV1akladU9sdks3cUxPRURoaFlSYnRX?=
 =?utf-8?B?ZElxMGZkZmttWlEwZ1NXdjlUeURNZG5vUGRsY2M2TnBhMm9LMWFpWkttblI1?=
 =?utf-8?B?L2toc1hIUmVBTTdWa2x0V1ozdkNFbS9xcDlvRjRsdURQQWtjMzVYQitYUWRz?=
 =?utf-8?B?bU12c2prd0JPbnlZdUZlR1VpYWJYS0lJeXh3aFl3RjB0M2ViYjhVUGk0Nncr?=
 =?utf-8?B?TW54VTF3NWZ0L0VhdWVlRVI1S3pqQWl6N2lCaktleC9EQllsd1M0RVlqbENX?=
 =?utf-8?B?ckdFdkVFVkU2Q21MMmFUOGdGQXdVVmE2Q29YcDJwUWpqWngwanU5NDYrMjB0?=
 =?utf-8?B?bWtCRVdkbFpXMHVWMDZHT1BnNmJDVGovdEJYS1YyQzlicmx2ekY0NW5sdWk2?=
 =?utf-8?B?eW9XV1dhakw0WDJyN25NMVRGNC9qK3dBcUh5WjdvZTIxMERKSGczWFhjVHdq?=
 =?utf-8?B?cFFzZWhnNENSakJyRW1DbTNHUTFaQnBKMytlUHRKc0Z1aVliUzVWS2JZd3Jk?=
 =?utf-8?B?dGdQYko0WGdKSHRQb1NlNGE1ZS9OWWwvYmpuKzZGc21ndG1ZVDhENk1MUFBU?=
 =?utf-8?B?eEI1QzVHK0VhVnBaeFc0TUlOS3l2YzVQLzk4cGZzc09oVEhVckZ5dXgwd2U3?=
 =?utf-8?B?Z3FnNUp6VDZveGpMME1HMnVtTkc1OEk3RS9BQ2FFRnp0UXQ5N1RHZkVhbFNo?=
 =?utf-8?B?Z3FlTTVaeXdrZE5wMHBFYkNwMlFUZy9uZlc3bWtQckNzR0ovdEJmTThBNEgz?=
 =?utf-8?B?c0c2ZEdRakYwV1pSYlhISjRFSWJkRjhyanJqeUlXMG1XdGV2NVpveFVOY0NE?=
 =?utf-8?B?dHZvQ2NjWC9nNUI4QmhIRHhJWmJmdDNsOVgxRDZzZXFhVHlBSVZEdmUvbXhw?=
 =?utf-8?B?aWx0ZmhIa2NNY1k5UU0vSTBXSFNyVEhJTUVNUndSLys3a3dhZll5ZFJZQ3c5?=
 =?utf-8?B?MTdaS1FycklBSTEzZ2wwV3RhODU0b2R6SlZwOU9oMDlSYnFlQk5UaGpTb2Ja?=
 =?utf-8?B?U1JaUFhRbjB0bDByWmF0SmFNaVNFZDB0eFR3QytaNW9FRHFzWU1RekxUUWNo?=
 =?utf-8?B?alA5K21Id25wQ0N3aDRhUGdYWFpJTksrd3pIRkdibU9EcFlRZXkzOHdrQVB0?=
 =?utf-8?Q?Hx5h54gJ27BFOvDUrIsh6H6RB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 814a3d58-8933-4f05-d7c4-08ddb9b1eebe
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 21:46:42.4271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V6ETwmmxkzuz2FUspyIkyWM0aWtgrzDIOvZzMGUISClECNKiTGolapKuVdQav9l3PnZq83chrAvVgjozLWvoSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6604

Hi Ashish,

I can confirm that this v5 series fixes v4's __sev_do_cmd_locked
assertion failure problem, thanks.  More comments inline:

On 7/1/25 3:16 PM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>

Extra From: line not necessary.

> @@ -2913,10 +2921,46 @@ static bool is_sev_snp_initialized(void)
>   	return initialized;
>   }
>   
> +static bool check_and_enable_sev_snp_ciphertext_hiding(void)
> +{
> +	unsigned int ciphertext_hiding_asid_nr = 0;
> +
> +	if (!sev_is_snp_ciphertext_hiding_supported()) {
> +		pr_warn("Module parameter ciphertext_hiding_asids specified but ciphertext hiding not supported or enabled\n");
> +		return false;
> +	}
> +
> +	if (isdigit(ciphertext_hiding_asids[0])) {
> +		if (kstrtoint(ciphertext_hiding_asids, 10, &ciphertext_hiding_asid_nr)) {
> +			pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
> +				ciphertext_hiding_asids);
> +			return false;
> +		}
> +		/* Do sanity checks on user-defined ciphertext_hiding_asids */
> +		if (ciphertext_hiding_asid_nr >= min_sev_asid) {
> +			pr_warn("Requested ciphertext hiding ASIDs (%u) exceeds or equals minimum SEV ASID (%u)\n",
> +				ciphertext_hiding_asid_nr, min_sev_asid);
> +			return false;
> +		}
> +	} else if (!strcmp(ciphertext_hiding_asids, "max")) {
> +		ciphertext_hiding_asid_nr = min_sev_asid - 1;
> +	} else {
> +		pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
> +			ciphertext_hiding_asids);
> +		return false;
> +	}

This code can be made much simpler if all the invalid
cases were combined to emit a single pr_warn().

> @@ -3036,7 +3090,9 @@ void __init sev_hardware_setup(void)
>   			min_sev_asid, max_sev_asid);
>   	if (boot_cpu_has(X86_FEATURE_SEV_ES))
>   		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
> -			str_enabled_disabled(sev_es_supported),
> +			sev_es_supported ? min_sev_es_asid < min_sev_asid ? "enabled" :
> +									    "unusable" :
> +									    "disabled",
>   			min_sev_es_asid, max_sev_es_asid);
>   	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
>   		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",

If I set ciphertext_hiding_asids=99, I get the new 'unusable':

kvm_amd: SEV-SNP ciphertext hiding enabled
...
kvm_amd: SEV enabled (ASIDs 100 - 1006)
kvm_amd: SEV-ES unusable (ASIDs 100 - 99)
kvm_amd: SEV-SNP enabled (ASIDs 1 - 99)

Ok.

Now, if I set ciphertext_hiding_asids=0, I get:

kvm_amd: SEV-SNP ciphertext hiding enabled
...
kvm_amd: SEV enabled (ASIDs 100 - 1006)
kvm_amd: SEV-ES enabled (ASIDs 1 - 99)
kvm_amd: SEV-SNP enabled (ASIDs 1 - 0)

..where SNP is unusable this time, yet it's not flagged as such.

If there's no difference between "unusable" and not enabled, then
I think it's better to keep the not enabled messaging behaviour
and just not emit the line at all:  It's confusing to see the
invalid "100 - 99" and "1 - 0" ranges.

Thanks,

Kim

