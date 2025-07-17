Return-Path: <kvm+bounces-52694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 163DBB08468
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 07:56:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 350F11A6599B
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 05:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D3C52036F3;
	Thu, 17 Jul 2025 05:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0wOo4l7m"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2082.outbound.protection.outlook.com [40.107.236.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527DF4689;
	Thu, 17 Jul 2025 05:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752731807; cv=fail; b=k5YUpCBnmbkFqo0uAxly/5CZN3ZmFB2lTuw4dgwTAxmU8Zms8Eqn4gqNj0abSXJ6VO29QdIyHnOcu7AD/trvjqOp/Cm3JHZNcLuhdFG95JW5Cjo1hngzruFv3tWy7KJSCTH7YqTNUqjZjs0Bekr6+TCD40+i2AyXPEieqHt5Hh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752731807; c=relaxed/simple;
	bh=jz5cSA9U2XsywOZ3LjAeleH6wFP8qg9cfSH0a6jwjpU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lk6lu3pDI89jj5PJUnXlfuLS/ETxjgWe0665lK7FjeoICDfayzyM1yHT1NArygC0+crjyIvawqoboev24ya088nMgG35N3JM3m14wehIqnOd0veM9P1TFmNM54IRMvZNP2U6mTjCuYpaarp++qf6Sdy0MJT21LTo2MKKKJw815M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0wOo4l7m; arc=fail smtp.client-ip=40.107.236.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LYcUM+hZb64gEYRAiSGb8vP3soYxvrZyPdV7sAubMwmOLXmPlLPXPDpVchXtlUlGpTUaPjO7in3ZpVUR89ZBR8fNOebKIdUopAHwjrNVhaqQAHEx9F+bV7ZImDsIbjQd8iK6fDUElpfg/E6SUqyW3I1TRk+Bu3N/UhqnYqGiF5+RNe9e0pW5IIDtRMkwbVBObTH784X+vtbJoLTApe3sPEoSTca77ZZVudIfYqCnHD9US+dLSEntW82wWwfumG5+bE38fgFM+OEeZRj/bfm5neaUR+qxzOqTAlMrbgbA9r4Kf2CkQ3KrN8mTQnj8oIaGk2rASwZkA0fGqCkefbc6YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kYc48wR6UAmJX3PGzKGtm0dLDUwY8478kuLklYvnaXI=;
 b=j7MmxbFEuwhusUuoZsgIxW+aX1F0LGYjsdOD6MYCqfyRBThZSuuZgXvfhE+/jCkF27TnEnHAUJTrixFKF4/A++0dRLGW7kAgSOnH17hN3GYBpzeTa0kBg19vVW2MzYd0hKvdWBwtx9CRhUu0sBHU+IyYu2pTQLc8IclsPR7GOQGY3KIpZjQtbhzKLFgXJbJaR9bA5W715N8ahO4ZwbM52VMGh0rVW6wh3TFNiOTwKDOZPHmhz/geBNFjzq6Ti+WgDyKpnU4R9bqwc6TcXZ1BonWYr9FwHeA71xyvbHom2E5nW+qAr+JvEz0jxJL1yJdHvRkXdAi7C7FisMU6t5T1EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYc48wR6UAmJX3PGzKGtm0dLDUwY8478kuLklYvnaXI=;
 b=0wOo4l7moPrFgsuINc0EEOJNFNEF+tlik255sLSQKbV3+8Nni7g9fVNtQb7k10KNlW7rfCyhhgXuxO6M1OdIgthC7YJfbsQNctxrf3ixoNbdy/FY8I+eHe3ijsd/GCCOc/n64QH83vuGfJih3O92oYfEkHd+tU90Uz7KmR9+cn0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 IA1PR12MB6649.namprd12.prod.outlook.com (2603:10b6:208:3a2::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.39; Thu, 17 Jul 2025 05:56:43 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8922.037; Thu, 17 Jul 2025
 05:56:43 +0000
Message-ID: <18cae1ff-e6c1-46b6-aa60-53bd21bd7d1f@amd.com>
Date: Thu, 17 Jul 2025 11:26:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] crypto: ccp: Skip SNP INIT for kdump boot
To: "Kalra, Ashish" <ashish.kalra@amd.com>, joro@8bytes.org,
 suravee.suthikulpanit@amd.com, thomas.lendacky@amd.com,
 Sairaj.ArunKodilkar@amd.com, herbert@gondor.apana.org.au
Cc: seanjc@google.com, pbonzini@redhat.com, will@kernel.org,
 robin.murphy@arm.com, john.allen@amd.com, davem@davemloft.net, bp@alien8.de,
 michael.roth@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1752605725.git.ashish.kalra@amd.com>
 <ef1b21891b8aea8ffab90b521c37ab79d5513a7b.1752605725.git.ashish.kalra@amd.com>
 <d7b3e0d1-4a93-4245-b09a-701bb14553d4@amd.com>
 <d9638984-0d75-4887-8378-97807f6af2bd@amd.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <d9638984-0d75-4887-8378-97807f6af2bd@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0089.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2ae::7) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|IA1PR12MB6649:EE_
X-MS-Office365-Filtering-Correlation-Id: 8eafc677-01c4-445c-cc32-08ddc4f6b466
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cnFSU2s2TXZMcGFlRGUrWjhBdERHcEh3c0pJbDcrNzl0Tyt2MVNlMDBHNGYv?=
 =?utf-8?B?NGM3WHRHb3pZN1BlQXZGNklXSlVuU01OcUlnK1gxaGlmWVFTbkRuTmx0dC92?=
 =?utf-8?B?RStqb1BZNzBHZFZnR1FzMlR6bktlOUE1Y1Vqa3ArL1hKdjltb25FUjRycFZs?=
 =?utf-8?B?V3BKYzJXRDI1a0NMM2haWm4rMkxhcmFUSVJBYno3cDBhQjZYSFVlV3lFVnZC?=
 =?utf-8?B?TFY5WHVVRUYrQ3UwUHpMTGNTVDVjZk1Tc1VDbTJsSmVicG5qcXoyaXBFczlx?=
 =?utf-8?B?QlRwMWo3MFMrbVdRck5UMVdrQzdHaVVLakgxQy85S2RBMWNyaS9XdTc0bzEv?=
 =?utf-8?B?T3RmdlVvNVpDdUk4QWptYnBqRmpoR1FqRytycXZ3Uk5sRHZnNFlZVWRrOHJy?=
 =?utf-8?B?dkwrSE1pUE1peW1aWk1BektxUU52SjlSOHNjYngyZ3hEc0xMUDZjL2p0MzRr?=
 =?utf-8?B?cnEyYStXck9zTXg1QW1QTSs0cVJoNy9SS25yNWIwN0RDQUFKRG01em9RN2V3?=
 =?utf-8?B?a3dPNXc4NEh6UFdWdktPNWt2U2l5VC90VEp1Q1hiREdjTDJHRTBjcXhwMXZR?=
 =?utf-8?B?NUUwOUk4U08rK0Fld0NoaTNPT3haQzNteGdzK0VES0FGYWxPZHY1Rk00Qjll?=
 =?utf-8?B?OGt5YjlCYVNYS01YeW9UaTBFRVZnQllEcCtzWGhjQ2ljNHhFODVtUFJjYnFZ?=
 =?utf-8?B?MnRFOWRZWURySlN5bTlSOElmOUVxU2h3Z3NIYUhaMUt0S0Y3cVB4RytMejBF?=
 =?utf-8?B?RXR5U2tNNW5tWERKSVpJSmhVWDFmanlBNUovYU45MHBQc3dyMmRLNHh6RlJn?=
 =?utf-8?B?Y3RsNldoMUhFNDRWWkdQdXdGSzhrM0xpcVJBd0VqallTV2RTYVRibEVCeGEy?=
 =?utf-8?B?cGJkU3hiT1pNUDdSS1E5N28wN2o0M3ZnL25XQzkyR1pUdjcyTDVhM3lQMkJQ?=
 =?utf-8?B?L1JudXJFNlQ1RnJSOHRjd0xLbUExTmN1T1djZEs1MXhkQkpFeXBSZUo5RE82?=
 =?utf-8?B?TFQvZ1pyWG5ma0NoT2JSd3J3Ym8wVmplOHRGS2lpRVdtcjFWV1JzNkNqNSta?=
 =?utf-8?B?VlRmUzBqMEpWaG9VZS9KdFc2T3F4YU1BOFF2eWoxRmllREErbmRERHI3N2N6?=
 =?utf-8?B?TXJ3aVRLRWlod0FDa3NXNE5ReDl6RWJsOXJNMnZKSW5hT0ZhWmJJdUR5a05n?=
 =?utf-8?B?TkczcmxoeER2eEVzazJSQ0RRY0VPYXp5Zjd1MVh0R3hkOGpSN1NLcG9tTnB0?=
 =?utf-8?B?MnNyVk5wTlk1azZBRFRPQ1hqV2d3Q0ppZDlBNDJ1bVExbGE3cFJzenRVVklx?=
 =?utf-8?B?SDk5VHF3TkovaUx0U0srK0tGNCtoUHRyZEJFUG9YdE5XRm5oZkMwRUJNbTZH?=
 =?utf-8?B?d3YyL2ErVHhBNVpqV2tLL0JidzBJRTg1MWY1MTAzTWRZTUR4bGdWY3lGL1lY?=
 =?utf-8?B?eTNNYW9pZ2dxRDJ5S3dyOWNYRnRrU1ZVQjRITm1KSU4vekJxUXl2STJXNXZi?=
 =?utf-8?B?ZUtNTm9DOGpQQWtkQ1RRRjFDQWlvTU1XdTVwQlI1M1ZwWFVjYjBuRVoySWhN?=
 =?utf-8?B?NGczdVU5V0Y0cEJvVDllTEp4WlE2UmRFRzNETVVWTVMvb0ZSRGl3TDd0V0ZM?=
 =?utf-8?B?ZlhPYTdNV1phem9ySFFPWmFRd0lSZXhrWTUzQ2t6dm9POTVVOUxBQWFadXp2?=
 =?utf-8?B?bVBTckhUdVdCNUh0VzRiUHBLbGtiN25RNUJqNGROMGQ4Yzl1TUZ3a2hZQmNJ?=
 =?utf-8?B?UTJNQ24xMjhPT1lEVkNXWlJvdHJremxuTlpzeFIrYnArekIwTUg2NlE5WlBS?=
 =?utf-8?B?TWowcmRjQlVVWDBuOWEwM3ptcHlJSmtEM3NRS0hYWGwyaWorR3ZkTWQ3NzRL?=
 =?utf-8?B?N3V0RlVkclBPM2UvdWNCdW5ia0NuR3AwUmpNYTNCQXg2cjZYMWZWQUtkc2JI?=
 =?utf-8?Q?/uALkESNgF8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MThCd3VFNXlpNzcrczVCVjdrRDUyd3pWM0J1SUhFS1UxSGtHTE95U2FaelV3?=
 =?utf-8?B?eGZreVBXK0pKcm5hMk9xQXhQWHR0VU9ZOTNrWjNYTERybjhuVitYTDBrVVVS?=
 =?utf-8?B?dy80czlJU1JoVkFTWGd5NzdwSzZYUVpZYjlTNDc1M1Y1Y3lUNERNSTZjZTZF?=
 =?utf-8?B?TldteFRiYVNqRVhNYmE2Z2IzZ1hwWm5xbURDRkg4OWp4TWNwWnpHeXgxOGRu?=
 =?utf-8?B?NnQzQ1RJc2NiL1VWL0g1ejVpbWh3aS9mNlRwbldhcUpnS1c4WDhXa1ZVZWhn?=
 =?utf-8?B?WGl0S2xsbFJnK3IvZGJ1a3RXYzJURWUrZ29hUm1ZWWQxTzdmSFovYjduTjJa?=
 =?utf-8?B?Vm00bUNoQ2V1ZkdtelQ1ei9lK0RBWVkvdGQvSGdBYTA1Sk9DLzRBTE1CL3Qx?=
 =?utf-8?B?SGw5NHVXdDRMR0NIT2ZpNzgvRWRRNzZSVnhacUVLQy9yUlpTTklxdjcyUUFv?=
 =?utf-8?B?NUZaaFhIeTlHY3VvZnVoOEVLOUE4YXRtUkVWbVNBMkd1Yk5OU2tBeEtlWGdC?=
 =?utf-8?B?VWxTZzZ3NHpCdTRqd1J0WmhERnZRbmh4b3JUN3Y1VVJUUWVGb1JDM0tyTlFY?=
 =?utf-8?B?RmVIMVlkOEJLbXBYME04Z0hLUHNVUzlxaEFJR3JXd0ZDWFJQTHpvcEtYb0RE?=
 =?utf-8?B?anVSNWlpdUg2MW9rV1dJRlQwTGx0bkpna3J4YkdnOXAwRmtPZ3dvUEZZZFBa?=
 =?utf-8?B?MGl2NEptOTMzQVRVV3A2WEQ2dnVjaU9vbzhGNUk4N3BjMlVwYkxvRklMTXlS?=
 =?utf-8?B?OFNFNWNHYmx4dGgzNm1TS3ZwRkZKcUo1SENKbEhHUlc1TENUaTlqQWJkQi9V?=
 =?utf-8?B?eU5FTVlJWVZuOXFsc044WjhhSk5TdHhxMDNhRFlHL1B3OVlFSWhkU1NWS0ow?=
 =?utf-8?B?OElaWDBXdXpvWG4yNEJmamp4SzA4RzdpREtVYXU4M0FYM0NVZ1RzYkxRQUtY?=
 =?utf-8?B?Q0J3bUFzNW9uMytxak1KNTcrTWU3VmI0OVJxa3FHUWFVQ21lblF5NUdqakRi?=
 =?utf-8?B?K2F0bkZLTWVsMENaeEdJTTNFUFJraE92eVpmRWtTeVoyT0lBWVBkVHN0UjYz?=
 =?utf-8?B?eUU0bDIyZlZhaGUwZjIyeEV1cy9TUlFMaDF3YkVqR2JHYTRIQ09JM0Ryc21a?=
 =?utf-8?B?TnFnOWFwRmtuMWFvZVpnd1lFaVZIcFdjYnBVeDVaMGFIcnlrUThMMnJBRTlD?=
 =?utf-8?B?M1lRLzlBRjE4UE14YVI2dzlENWxMVm9zVzY3Q2pxN014U1VEeWtqL0ppY2ha?=
 =?utf-8?B?RlJkUFB2T2dRVVB1aFVzcGM2eXMyVkdGRy9EK2JWVkdoc1pnUCtZclo3SjBz?=
 =?utf-8?B?dE1pekRpTjBJTnM2MXR6Q2hhRktraHpCeGxrYWxJMWR5WHFFeUFJSDllZ0wx?=
 =?utf-8?B?ZUtLSXovVlpqeFBUZ1VabFV0eStKVVF0MlBFN3hqTDBGL2ZMWENGb29MV2Rp?=
 =?utf-8?B?cFdVNjVRRVRVQmxvaDM3ZzRpdEpWWTREcm5sK0JjdWUvZGJjYmZHWTd1emlU?=
 =?utf-8?B?aEdVT081V1g5bkpqNm82dVFzZ1VWZHpqQ1hUV3BpWVNpRUE4MmN0RVd2L1hV?=
 =?utf-8?B?bjVWQ1F2Vnc0Ym0xcGhBalBKRi9OdzJBZEkrbG9UWVZjdUcxNDNodDlkblV2?=
 =?utf-8?B?SHBJSERYc2xHZ1RCbjdRNU13WjBoNVJ3Y21RNTEzc0RuaE1TTjhWYU4vQUV4?=
 =?utf-8?B?K0Z2eStDTzZVdGFZRTVEM0IvcDJEZHJwMXpzODZ4RExOSS9xMmhQRzNKWHIr?=
 =?utf-8?B?aHNTY2JrL3dIdnJLZFZ5d3VmSFRkb0gyTlNHcldWSGtTY3ZVM1lKZ2Z3aHda?=
 =?utf-8?B?VVA1U2JYRTY0bTdIdWhxZUxqdnhWWkN2Um9EV09lL2NydHFnM2pOUC92bUo3?=
 =?utf-8?B?azExemExUm4xUUEwaHdRUG1uZjZQeFJTWTF6MjBLd28yZ3dxV2xaeEdOK0pi?=
 =?utf-8?B?VS9JR09zdjlkSDlYbHY2SXVaUEFkck8yZEQ2U2FqdFNUb1VQQ0pZT0x2bnZ3?=
 =?utf-8?B?L3FCdGZSeFpvMXByZUdJNlpzS2Q0QTBIMUpHQjNHa3BwOVBLajZPOTI0OXNw?=
 =?utf-8?B?REpIUThjNWpNT3NYdDZNaWhlZmtoVFZkRG81WHFobFN6dTlwMEt1a3BINmpu?=
 =?utf-8?Q?qFraTYmWM3wFJh3Vu6qlj2yqK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eafc677-01c4-445c-cc32-08ddc4f6b466
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2025 05:56:42.8158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pyrThvuLzvhM2qSLAtGWcoJJUSHpJZdZi4IuPNKgnySD0xdYZP0EgMTSDjgJEDYBENqa3udx5zGxR5jSJioEdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6649

Hi Ashish,


On 7/17/2025 3:33 AM, Kalra, Ashish wrote:
> Hello Vasant,
> 
> On 7/16/2025 4:20 AM, Vasant Hegde wrote:
>>
>>
>> On 7/16/2025 12:57 AM, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> If SNP is enabled and initialized in the previous kernel then SNP is
>>> already initialized for kdump boot and attempting SNP INIT again
>>> during kdump boot causes SNP INIT failure and eventually leads to
>>> IOMMU failures.
>>>
>>> Skip SNP INIT if doing kdump boot.
>>
>> Just double checking, do we need check for snp_rmptable_init()?
>>
> 
> Do you mean adding this check in snp_rmptable_init() ?
> 
> We already have a check there for kexec boot: 
> 
> snp_rmptable_init()
> {
> ...
> ...
> 	/*
>          * Check if SEV-SNP is already enabled, this can happen in case of
>          * kexec boot.
>          */
>         rdmsrq(MSR_AMD64_SYSCFG, val);
>         if (val & MSR_AMD64_SYSCFG_SNP_EN)
>                 goto skip_enable;

Ah Ok. thanks!

> 
> And we still have to map the RMP table in the kernel as SNP is still enabled
> and initialized in this case for kdump boot, so that is still required as
> part of snp_rmptable_init().
> 
> Additionally, for this patch i also have to skip SEV INIT similar to what we
> are doing for SNP INIT as we get SEV INIT failure warnings as SEV is also
> initialized during this kdump boot similar to SNP.

Sure thanks!

-Vasant



