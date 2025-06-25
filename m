Return-Path: <kvm+bounces-50599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9B1EAE7437
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 03:19:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9D39B7A73F7
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 01:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6083D148830;
	Wed, 25 Jun 2025 01:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VIhsixBe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2044.outbound.protection.outlook.com [40.107.100.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E876126F0A;
	Wed, 25 Jun 2025 01:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750814351; cv=fail; b=FbTSMKzIFqnFgz0zcWIqhhvwKOD0te9pF7JwSqpBU+dQXUOqA6TAT/0FVmNTjp2h6PfqzS+kjx80+l/QEmv11WjnZChgjSqCWeuVgjqCtOS7qhOabrBSq9YzA5Q6ZCE2wHjEePGjIAZfx9H4Gcmxxkq2PxDdLUtTy9YleaLXZqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750814351; c=relaxed/simple;
	bh=PEGQL846Eg+qIW3kqcfyIT+2D4CtjVrZNWnDnQQC7iw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OxHI+RI9Vyc7qU+G1oSiqTmRctb1mEzFDiIZnMIGrB+xRS+FPnJD7YD480OV5/lXTFmJYT/Ahr2bFKM6DfwdFyJsRP05PXo28Xud1SpGxhWM+94O/XvTeiv6qjJrAephssThtZ+e0V55ZZS3heYY4d7LzN2e9m/bp0ykiQisIBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VIhsixBe; arc=fail smtp.client-ip=40.107.100.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yl7QMYj5d3Vc5Ww5SNEgYxszaGvn7Hp1gJYzzc2yPCCwk95+TRffXY3ubvrKwcZtp9vScb+OND1ORcPzBETlHVdRDpKjVr5T7yH/iRk4X769w4Kxhv8yl+zb0jWfEPXCiA3EWjLcjktXP5hF521rYFXQrWaeS3R+AmGRnjQvZ67P9ynrAtgvwHj9NZ8U03NE7vgMok9B4SAMQ31Yc5o97Gkd97GWwX2NaPz4mTlaGolsaTNFOI5mQxslwp1JwvUaQOVYL6QxZKqKXb1HdVPyxyMa9T2n3ahuZBkQ3xw8AlTGfpyO3TIIY23A4DsdAsxYcVw0rxPfaJbJRZrINaxV6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8+5eZ4gGM9MtMpfyH+jkWrUTz6xu0mXRBbJdNmZCz3M=;
 b=Txwd3xa6s+/Qw1PIXxFrm+G165q0ebtw+djis9ZlmrmzUOxt3+FWcTa9Der8GxCUsMGX3j7FWxmTTRo3VHjbPdnX5KWZdmH7DxXiOFJLc9MKbf2UlIC+NSwoUGQQ4MjYhm0RRqoMTjPJYW00dx+sKAqpHUGqh3XZaerEKp1jDpr/KylqHvCLtEwyawg31M/VhXNgrNA2hM6nGLmYbrXytyCB1SP0Y5sl9I9+DGLitI/cGZXDeyQitJvq9HAAfAuqx996EOyC+uQFiBbpQyoPPeUMBFM3zk3F9XBIOOo7+LFy+Y27BnfS3/lAJgYeILsFVqvP7yo2++QAwrfEArH5Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+5eZ4gGM9MtMpfyH+jkWrUTz6xu0mXRBbJdNmZCz3M=;
 b=VIhsixBew2cR3J2UKRvenlu88HtugSmdeEKuNPBkvmuuToiT1Nblrvfj8q0kmwaQNdUIlcuW+44XeIOB/Kx5RioJ8a+VM9BaThUK7ClPKfgHDxiMo7TGUl/PvJbrz2t4LW1TAGzGYYh78AIP7MU0ni3pturZqKQsxor6iHSXQJc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 MW4PR12MB7287.namprd12.prod.outlook.com (2603:10b6:303:22c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.28; Wed, 25 Jun 2025 01:19:03 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%7]) with mapi id 15.20.8857.022; Wed, 25 Jun 2025
 01:19:03 +0000
Message-ID: <8d1e6138-2d08-4207-8ece-d38366d9a27e@amd.com>
Date: Wed, 25 Jun 2025 06:48:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v7 01/37] KVM: lapic: Remove
 __apic_test_and_{set|clear}_vector()
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com,
 francescolavra.fl@gmail.com, tiala@microsoft.com
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
 <20250610175424.209796-2-Neeraj.Upadhyay@amd.com>
 <20250623112612.GEaFk51EOLBBvZWWJm@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250623112612.GEaFk51EOLBBvZWWJm@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0020.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::7)
 To DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|MW4PR12MB7287:EE_
X-MS-Office365-Filtering-Correlation-Id: 372e9d91-d321-4f05-c4b7-08ddb3864533
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MmN4ZEZIdmxqMVhWYUQ1UDYrSzAwc1p2NVliK1hYdHV5LzF1cHZJTzVrYURC?=
 =?utf-8?B?NkJ0bURYK0lYdzZJbENodW1UUXU0N1RQazIwRzdTTUE4MURXcTJDV3Q0U1I0?=
 =?utf-8?B?MDFnYmdTUWRwZkdTNjEvc2ZwaXFrNW14eUlQb2dFOGNyc1h2dEpsNFJDajZR?=
 =?utf-8?B?Z0REYktQUEozQUVSRnhBVXJBRUJtUE92eHJWci84WHRHZFhCM3RXc1U4cG5S?=
 =?utf-8?B?MFFuUVlnbTZyUUtaY2xNaS9DYUM1TUU5MUxlWFNQMTFHa2lteG5YeDF1aGJt?=
 =?utf-8?B?cG1WSU0wdmJmOWp2NVcxeFhDcHNhemllRzBnWGxYVHF6QjNrU3ROQ2U5aTVN?=
 =?utf-8?B?UlRuRkpCOFJmTmpJc3FqUW92U3FyOWo2Z2h3b0lHaHFRQ24vdDg4ZVB4OGIw?=
 =?utf-8?B?UHNNNjhFWGptOGUzM1hYc1NpaXp3MDdMQThuc1d6MnZBYk9DOGw5c3BOSFBD?=
 =?utf-8?B?ekpzWlFNeEt4em4weXpLaEtaaWJjT3NBN3B6SDNzd2JOZDVGQTdxa05xV1Zz?=
 =?utf-8?B?cU5PQ2YrSHptY2VpTWI0YUdSZWNGQUlRcWp0TVFIZytVVzR1N1pISGxLZUlI?=
 =?utf-8?B?OEdZejZhRkhabzltNzJ3Y1c1ZDRLYnVlYWo0WXhZREgwOU9kcjFYWS9LSWhT?=
 =?utf-8?B?ZUowSzdDV3RvRno1aG1YMmxXclk3Tm5ZdVZYNC9IU1hOV0FOZ0UzZmNCdjJi?=
 =?utf-8?B?Y3pYYmoyK3dCSEd2OWxQTXlvQlZLM1JOVEh0K3ZqRngvSFZSUmcwdENpZklK?=
 =?utf-8?B?SG1aR2dRUGdUcS9UMksvbXNlMDZRMTFjT3k5SnJLN2wrdkY5bEF0MjV2c0Nj?=
 =?utf-8?B?Umhkejl1Z1l4ditzVW5hS1JER3dXNkdySGtpcUxvNEZ4djNCRmNXMjZPK3pw?=
 =?utf-8?B?Tm42TUYwclpMVThSQzRLVFBqS0JSTUF1SzBvUzFxMU1Bck4rWGxsQVB5Y0Zh?=
 =?utf-8?B?WGpWSFBLM1VQTmU0ajRFamEyQUREMmxoakM4MUl2eU9CTnZxMnhCT1lHWkNl?=
 =?utf-8?B?RmtiMFM4NnFueEVSWkw0Sk9wWWJtRFBkbHZtUTM4R0xad29ZOUlZVkFyOVpp?=
 =?utf-8?B?bTNGN3o4WktZRFpZUWhTcENKMmxQeWNhNkVFZnNxeW5jdGNEa3grR05DV1U4?=
 =?utf-8?B?SUx5clFmdEhad2F6TEdhaFZ3UkY5R1NpNlZ1blhsODVyTWk0VHVwVm5yMllt?=
 =?utf-8?B?L2JldHNaa29GSCtRdk4vbzRJUlZzNlpVNFVYbDVNRHVSS1N1YVVseXRYOC9m?=
 =?utf-8?B?elluMmV6cnFhQXI0QkladEk0blNVUFdMdDhieTllekU2aHVFSXVDeFlycjFr?=
 =?utf-8?B?Qkc4V3B2dWtRMDBXYnhHYVF2ajQ2YUlCRmc5Tm5QOXQyKzVER3lLQlFJZW5i?=
 =?utf-8?B?TXZoV3lHZTBuYitJV3pGR3dKSG5idFppbkpYY3VGUjhJZTFLRzQzTjVCKy9T?=
 =?utf-8?B?d096ZVJRUXIySkt5dG4rd3RHOVBhYUpUMlY3QjVvdWUxN3NPemRKb2VSN0ZH?=
 =?utf-8?B?RG9KU2szK2VBUkdrY1VEcXpzbDV3UGpMTngvMWg3SXFPaGVOdklqRGsxcHg0?=
 =?utf-8?B?Yld3ZFpueHJWWVpaQThWS21jejFJVE0zbjJnMk12eUx4a1BoeU1mU1c3aG5Z?=
 =?utf-8?B?K2VqNGFPUW5raE5YcmlhOUE1bWZkTnM3ZUhsU1d5VnptR0ZabHM5UWlnUGdL?=
 =?utf-8?B?dTgzZkRjQkFQMEY2b3I2OHZkbmx2NmtsSGZVeWZWVVpsaHU0VXU0V3pvNjcz?=
 =?utf-8?B?MUVEMW5Kb2swNHVyRkV1N3pRc1o4UGVKOHZJRW1vY2pDN3RxOUtZOGdNUGM3?=
 =?utf-8?B?eEhMMWpzZk4yRGU4c3IvdjZYK0FLZHpJYVRBaGFvZEg1cHQwZkFaaTJtZGth?=
 =?utf-8?B?UGcrNTR0ZDk1VGFBVXBUQjMyMlpvek5xSTZIYmVMc2h0emlvbDBFVmkvVkhZ?=
 =?utf-8?Q?ZNuz0+v2awg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UEhiaDlSeVFWYkdSdHoxeGE5elFSQUNRS3JqMG9UNFM5bEFBRjZjSEZjZ1Zo?=
 =?utf-8?B?Mm5Ma3E0RFRYMU9HTG1Bc3NiOEJTNTJKRitubGIyZkk1ZW9EYzNyT28rUnFQ?=
 =?utf-8?B?SzRUMXlTemdNci9XSnlZaGx6dlU1TElGSHE3dzVzS1lBVXIyd2hVdzRMQlJG?=
 =?utf-8?B?Yk1iYlo1WkNkQWpjWFdLaVc1VUxVR1FUMGtGNGdwNWpXYXByYlpaelNoNTlj?=
 =?utf-8?B?Sk5kRW5wbEo5dDVJd3VSNHNRenZseE9FYlZrQndNdUZUVU1ZOHROYmpoMjR2?=
 =?utf-8?B?VHp4d1J3OGtZTlAxQnFSdkNGOGx3SFNUOEExaGF1NGtLTEpaVUoyRTdVeVpY?=
 =?utf-8?B?OUlva0Q5Ym1LRVVjeUNuWHJiSE1mNjVKZVBQT0RxWVRMR29sZzl4RlhrKzM5?=
 =?utf-8?B?WGEyc1ExRmtZMHBHMHYxbDNaMnFZNi92WktST0VFUlZENGZYOS9vT1hQeE9U?=
 =?utf-8?B?ZTgzT1BZbUhSa0ZZUHMveWphYUJ6MlFhcXF4R0dXd0RKcWk1MzNNSXpaYnhp?=
 =?utf-8?B?a29tdDNGQUY1ZkkrdlFWQy9WVlFtSnVxK1ptTnA1UnBNZlY1OHJQbTREdmZt?=
 =?utf-8?B?S1dQMFRuaWxWR2dJQndweGFXallRYTY5UTNDR3JtZEtUVE1RQUs1dklQTzdU?=
 =?utf-8?B?am1OTGRDSG51N0F1UlBoTGJLZ0xiZEtwT3RxKzV5Tm5WNGc0ZGk5WDN6dloz?=
 =?utf-8?B?aGh1TmVMeTdoQy9ERDdEOUFUWW0xYkRGc2E4QWN1SGhNWHcwTmhjRzVqTWd1?=
 =?utf-8?B?ZS9JZjlMZjllK2phbWpQTTI4M3UyaHlsVDE4SGZtRVl5cE5vMTZXSjR6Z3RF?=
 =?utf-8?B?L2Zqdkd2aGNvOFZ1K1lOVmRtTVhWeGJjeHc0U1FKdWhyYzBnVkUzSHpma29F?=
 =?utf-8?B?cEhFNGE3eTcwaHFMSEhheFJyWDFVRnpNM29UK3cwYWY2ZjQyNU8vd1JHUitq?=
 =?utf-8?B?N2h3MytGTFdjdDY4MFZwaktMb3htTHZrMXN5QjZ1NzkxSHkvd0dldzI0WFlh?=
 =?utf-8?B?UWl0MU5YZVFWMmxqYmNkY0JvNzMzd3hWSk1CV3ZienkyNkxiYjlQKzk5M2hK?=
 =?utf-8?B?RUtuYkFhMzhSR3pzNG5OYXJUdFhvajNWazdsbyt6MzREWjNzTXFNT2RBUDVn?=
 =?utf-8?B?MXpUSzZrQzFJZjlaZlp0M1B1Unk1NDNMdWtGYS9haHRXdzlOK3k4U25TdjlH?=
 =?utf-8?B?ZkdZK1pNZzZxMXNhdjgyTDBvUTNpR29DaGc1b0p2bFlORlY2MnZJQ0xPdEZ6?=
 =?utf-8?B?OU5iQ0pCbGJGQ085N2lTdXVzWHpXMjFIQ2xrQmJMRkZ4cXVxK2xCY1plSkts?=
 =?utf-8?B?RW5ZRW5lbDcxRWRSZ24wYTZXSk4weWZoenQwbTkxWnp1ZFpieittTXNlbnBl?=
 =?utf-8?B?V1RMQ2tGYzdWUXRTTjdWTkdhL3dSZnVuaU1zZzZXeHZqeGcxTFJHTU1QSU1h?=
 =?utf-8?B?VkZDRTZld0gwYmZ4QmVGZXNoZGdubiswUE1NOWpTZ1A3Sm96VjUzRCswVGhk?=
 =?utf-8?B?ditXQ1l0bzhlam12VzRtL0lZN0J0cVhTY0lXSU56VXpCMlJvK1lnL2N5L3ZH?=
 =?utf-8?B?dzFmTGVwVEJFTVJrcEJDczBJSDBQcHdrYWJTR1VLTEdHRktJVVNaZVVTNHRy?=
 =?utf-8?B?OU9zR20wa0djMkh5WUdMWFBnV2Z5b0FiZEppMHhUVWQ2bVEzMk5jM2hQVUNS?=
 =?utf-8?B?ck81LzBXcGg4SFZ3MTJnZElTR0JFQjZyNmpXTmF4ZkcxM0hoVlNjR1NhamtZ?=
 =?utf-8?B?QTJwMStrZmNqSDJQUkNaeU1NUXhSZW5jUGNFS3BKZXN2ajlyT0FjeEp0bVRQ?=
 =?utf-8?B?ZVhTaUJhai95RjhPaXhRZW1zZUlmU29BUW9iUHVaWHVTRHZsWjBldXJHRFBB?=
 =?utf-8?B?clNGdng5eUR6dmxsaDlvbUsrYmdOQ2pySHBnMCsxbUliUnhyNkJDSTQ2YkVm?=
 =?utf-8?B?TGNMbnZJVTdGYUpTckl2QlBFazVmT1MyTVZtMG8yK2VtaW93QVF4Ujk5TVpr?=
 =?utf-8?B?TitmanM2UDZ3ZDlGMWJ0cURiWjI4cFhOVjByK2x5bGV5Wk91QUU5azVFMHls?=
 =?utf-8?B?STl0ZFJ6dE13RG1sTStreWR3dUYvME5jelRkeXV3TVRrUW1qQXI4QWdySjgz?=
 =?utf-8?Q?BCL7ASNApxrjYo1k0ppxCVEoU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 372e9d91-d321-4f05-c4b7-08ddb3864533
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 01:19:03.3817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0jmCr5ebcB5dttUqKcBvrGV1bmfTtERg+sMVGCtNAb8FroGFRUJb0CJEjkR8+I8M9Z1b15ViI1x/+NHMpw8IAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7287



On 6/23/2025 4:56 PM, Borislav Petkov wrote:
> On Tue, Jun 10, 2025 at 11:23:48PM +0530, Neeraj Upadhyay wrote:
>> Remove __apic_test_and_set_vector() and __apic_test_and_clear_vector(),
>> because the _only_ register that's safe to modify with a non-atomic
>> operation is ISR, because KVM isn't running the vCPU, i.e. hardware can't
>> service an IRQ or process an EOI for the relevant (virtual) APIC.
>>
>> No functional change intended.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> [Neeraj: Add "inline" for apic_vector_to_isr()]
>> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
>> ---
>> Changes since v6:
>>
>>  - New change.
>>
>>  arch/x86/kvm/lapic.c | 19 +++++++------------
>>  1 file changed, 7 insertions(+), 12 deletions(-)
> 
> FWIW: LGTM.
> 
> :-)
> 

Thank you for the review!

- Neeraj


