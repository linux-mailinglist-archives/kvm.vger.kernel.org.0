Return-Path: <kvm+bounces-32374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 632029D62A2
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 17:54:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 919A5160E5D
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 16:54:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE2071632C8;
	Fri, 22 Nov 2024 16:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="qaOvtTx9"
X-Original-To: kvm@vger.kernel.org
Received: from CY4PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11020095.outbound.protection.outlook.com [40.93.198.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C2022339
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 16:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294470; cv=fail; b=h+SNq9+2M7Tqfcd8xy5BkJsKHHyqG8Hfbkb3yi77CxkdlnA1TpJCLqjdrktIZ4c1+A2I0AvA//Rh0VNp8e53mJqt20+jlQxRHd6gzQK5kxdevQ8PPXGH7THzoym4GnWd6KZsqBdkeMAn13e0xn9dvC+lAj8JB5LYYNMsigufSjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294470; c=relaxed/simple;
	bh=VoIiFBJ2PLTI2UC36AulXrqK9t5dh7D8iGMet8Ru0fo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ccy5Ju2u7VNLOtD1/HWkR6wsWmVT6XzSW+axnMbgMcXmg8LRbrf54rAgzxCD6CDdDlHpk/lmKiGxyhssFYOYo+ef/uAAuG/iZESBUT5aoS4gsAL4L2C5VwydqIbATVY8+V6s26Vtqh/QwaTbHIDY1WsoIg5uomOuLR3Qssr+acQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=qaOvtTx9; arc=fail smtp.client-ip=40.93.198.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T9htRAO59D3B7/kIBArElSIiXcXKJPQuaIXD2HTHilPLvz3REuvG4PSUdg3c1UxFDzFEN3sadCujcbT9Uhdzqtn41i9ikzLZULb32TcJn5RXcuMLh5hVvhoX+42KBKZqUJll3HssUCCEJy5mpJ5GinUb21YSwOunf9zqrFzislSOFp45+Kl0t142I0TdHRezq7BVtRG0uPks8gBSYq/oW2F8lnViPbtG8uTXQD/1CnRyvuxLcvZSZf7wdZSkabJEAJHCcqDOkHrfvitzbko5C1hhheRBvtZc6xHQ4/lwVDiTzTzgakx4szMJPccp95Rxy4YhWyJvwO6mrqCnKxOppg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9wKXcMOZNlieIf0QHOHIVf6q8EkgDfQ94UzxS21nNV0=;
 b=ij4H0bTdrwBkhhgXfnz397C/KvT6v3u+gTh5xlQ2bPY2/+o4xy61Ki+5y/xvKOueO2SZAIii98yBvjZY99TVSnRg9nWcBewXIhNMarPCyHExHau3BNW8FYoBSS4cip4LuJyTg4wZ3MAwgm/P2QiskxDIqKWXQ4gSD9oFoMLZPxfWkFnsN8qKh/2epgTPgSsP9QSa1UV+3i8I7NC27c2HxMO1LJunF9+ex8KsQditgIT2Vf+VSPrWD0+3Bk4plL3KU1sy9TY7lhFkso6NNAEcLX0tO18SjbaznvQXyavWFn/wR4ymbMii3zflwNjWh2z0kqkxD9yeGeRa1p4zw0rxtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9wKXcMOZNlieIf0QHOHIVf6q8EkgDfQ94UzxS21nNV0=;
 b=qaOvtTx9aS1h6pypMk5PKnVzw15pQaS9VxqwuHkefF+UDa4c2ZujK2t7SzHT3ziBfU+rKk3a9skmXPtc6n0DaxTgRHnI7im95Rve05sadh0vdcxYDtOobqX2oJbsA4BiDUMN+2CUANj52fisKIz4g4iKUak+W1C2lt1RL2QfRJ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from PH0PR01MB8094.prod.exchangelabs.com (2603:10b6:510:298::15) by
 SA3PR01MB8546.prod.exchangelabs.com (2603:10b6:806:3a1::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.18; Fri, 22 Nov 2024 16:54:24 +0000
Received: from PH0PR01MB8094.prod.exchangelabs.com
 ([fe80::33f6:85c:db7c:d9af]) by PH0PR01MB8094.prod.exchangelabs.com
 ([fe80::33f6:85c:db7c:d9af%7]) with mapi id 15.20.8182.011; Fri, 22 Nov 2024
 16:54:23 +0000
Message-ID: <38339ef8-6e69-43b5-8d16-b7fd66775c93@os.amperecomputing.com>
Date: Fri, 22 Nov 2024 22:24:16 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/16] KVM: arm64: nv: Shadow stage-2 page table
 handling
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 Christoffer Dall <christoffer.dall@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 James Morse <james.morse@arm.com>, Joey Gouly <joey.gouly@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>
References: <20240614144552.2773592-1-maz@kernel.org>
 <171878647493.242213.9111337124987897859.b4-ty@linux.dev>
 <46bea470-3a3b-4dcc-b4a8-a74830c66774@os.amperecomputing.com>
 <86plmov8n3.wl-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <86plmov8n3.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0202.apcprd04.prod.outlook.com
 (2603:1096:4:187::20) To PH0PR01MB8094.prod.exchangelabs.com
 (2603:10b6:510:298::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR01MB8094:EE_|SA3PR01MB8546:EE_
X-MS-Office365-Filtering-Correlation-Id: c124e6e8-c82c-453d-eecf-08dd0b16513e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R0YzVE1xd1hscXNROHIwdUdwVlh4ZktIdnpmOHlkNURZRDVZdHhUN3lqYkdV?=
 =?utf-8?B?cVJpbUc4UUhCUUlsSmJuM3JXYnQ0NGkvM0Q1eS9wOUdhMEdHbEVYV1BNQy9B?=
 =?utf-8?B?VytkM1RVK2U4emxiQ3ErdU9MNHRPSXJkUW5udUhSUk5IZzg4SVJBVXRXRHE1?=
 =?utf-8?B?YzRHUzNaUk1oU25pdzFMVzBtbkxGV2xGQTZQM3pVL1ZTYlZNcHRSMEF0dHB2?=
 =?utf-8?B?QjhpMTZnMUhRVE4wa1VNNkZ3Y0hBM2xjNE9YZWphQitrZFR4eThZc3hOeU0x?=
 =?utf-8?B?M09GM21CY29SQk13ZFpzbGlGWU5iZXFjQXdNbzEwNG52aFRacUlaVGdhSkJV?=
 =?utf-8?B?c2I2OFpOOGpra1NwTVZmeEF3QTZCUTBmMndlN3ltMVZvaEh0TCs2WFFydnZO?=
 =?utf-8?B?V3RicDhkNnRicTYrYmw1UkxNbGdRaWhjSG9wZ2VyMDBMMWoySXJiWVd0Y1Bw?=
 =?utf-8?B?eGRQVXc1c2NZMTV6WGRHQlNUQXkycERYbzJVMEZobU1zOGNKYm5xUU93VURC?=
 =?utf-8?B?U1NrV3oyalVBVTkyVWZadlA0UEJRUjBHajN2amVlbnJFdmM2aTdmRlkxVVho?=
 =?utf-8?B?Mkluam8xSHROTTZ6Z003dmpvYnFOT2xmTWlPa05qY05yeGJjY2xTalEzQ0tW?=
 =?utf-8?B?Y3JDZHMyNUJpSUtaNVNGanlETWJ4cnZVc1dNL3VKWG1VWGZkUzY3TVF4eEQw?=
 =?utf-8?B?NmVMVHRiOE5TQk85bi9TZzdqZTZtTURzcWY5TFJ6TjJnU1UxU1R4RGlOOWE2?=
 =?utf-8?B?VlN6aDRxM2hrVm1CaWpVdDZURGxWbjd4ZnJjSnRYYjJWTWRXT1lLUTdiOE95?=
 =?utf-8?B?d1c3SndZb2xUcXluajhPNzNnS2RXUUxqbVA4R3Q4TGpXenFsb29EVWRQWnlk?=
 =?utf-8?B?bEV3bU9BNGRQOFF4bVk1UVVLNHFzWTVhMXovOVloT2VVUERubzk5WVVzTlM4?=
 =?utf-8?B?MG9CYysxNFRSTWIzNGFaME9ud3FIcm1QN1lyRDlONjQxV0lkd1VObjlyRUY2?=
 =?utf-8?B?eDl5TTZ0eFBGWS91MHpBUjYyYnVmZThjblBGSFBWRnU0ZGxLWnJZbWhEUkg1?=
 =?utf-8?B?Rjh0cGlYOGFFS2FTdndyMTBmZEFrOUtYbktSc1lnd2JqbC9rbmN4NGI5QnFI?=
 =?utf-8?B?NFNkQW1zMlgzS1hlSGJjY0wzdXEzcEFBWDM1RDAyd0Z0eTlOaVExenNHRzFD?=
 =?utf-8?B?aktrY3hDeE9KSzMwdkY3QWpBRVE2NGNjelRoK09TVHhSUS9nNk0zVlB0VW9L?=
 =?utf-8?B?My9RdGQ2dkVFV1dHbFZ2eEprUkNkVnowZ01FdHQ0Sm5RK0tmWWJpV1E2MEV1?=
 =?utf-8?B?aHhQUlYvV2NYRDl5UHUvajJuNzNYZ1pXYWRCME1XRXFEc2dzNEpxSExscFIr?=
 =?utf-8?B?Uzl5Sm9HRXpxMUJPdXF5bTl1dHBmZEtETjJPTDAxVXo2S2pNR2s4dE90K2ZF?=
 =?utf-8?B?dnpPT0VjdExkYVRvOUJHNEV1cGd1cmo2c1ZpaEhzRmEyaHpCd2g2YVlFd002?=
 =?utf-8?B?bnlFd0g3TWxWTDNxQjJ6S0FuZ3hkcXJZbGV4dGVid05xSHZacEVrQUo5NVpI?=
 =?utf-8?B?WGJjTTI1UTN3YVgwZStDZ0szM3lrK0NxSmdUYVRjRENCbDVhbE1wd2s3TUI5?=
 =?utf-8?B?S09vMGR1YWplbDJVaDFZQ0doaHp2SzVYUmEvM3Z5NlR0WHhmZFpGSFNQVExI?=
 =?utf-8?B?a1FGelNjMExxMlp5aDVvczl3NWFQYVluQTZ0dSswYXozc3dBdHNxdmc5WlEr?=
 =?utf-8?B?NE9pcVRCVUNBcWUxRUFwMzVBcDA3Qnd6QkhXT0VYSUMwa2k5a3F3YTBtdG5a?=
 =?utf-8?B?Wk5oalYveDczZE5HRzVQUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR01MB8094.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QW1BeTRpRmJYazdjNEk1b1p5VjBMZmlNbVdFZTZHZnk4eFoxUEdwbld3UVdm?=
 =?utf-8?B?VE90cFFtaUEvQUNIbENQS3Q0M01rWU0ya0czalVlRWJRU0ZKZ1hMU1E0a202?=
 =?utf-8?B?WUpRSzBxVjJpVjM3aTVVdmRIMVd1eWdZVVNBR1JRTWQwb2FHS2paNThFSEVt?=
 =?utf-8?B?b2J5UUkzWTRBb2FTNXhLQk9nWWYrKzBIQU1tc2liT0R2S0JLenkvcGFpWFNH?=
 =?utf-8?B?Q1Voc0FvVFV3dFBGSEtsRFdIUjFLTWFLRCtaWFd3b2lNM1dlU3pTRjhUMnha?=
 =?utf-8?B?WnBjdS9mMG14cVA5b3VnVTF3VjVxWEgvcWZSWWVNZXNOdjJhTnJRK2FGa1ZH?=
 =?utf-8?B?QU1EY1grVTZha0xmNTdqVGd1M3IzaGJGVEFsZE5BdW1PUmUzWE82eGFUMlNY?=
 =?utf-8?B?aTFYeG5aeUhLSUltS2J0MmRnR1R5ckJJMlF2RXo0anVYdTZrVFJQQlNwYlpq?=
 =?utf-8?B?dkxRbEtKVkRXcnBCUFZkbUtHSTcrSCs4UjdnVUhTbFpwWlNHZGpnalB4RUZa?=
 =?utf-8?B?eXppS3NZZGQxdzFVYlNaT3g3MU9iSHpleDFFcmVNdkdacEVpanBtR2Iza285?=
 =?utf-8?B?T1R4TzR5RTdlNW1JdXdSZEs1eDgrUngvUlhDYnF6VkRGWEVJaGZEQ0lrekdt?=
 =?utf-8?B?ekoyam05TTBtSWhXMzRLbTlXdzBPM1k4eCtNcFZLcFpuQ2p0TzNLWWV1TFVu?=
 =?utf-8?B?QURhSUU0TTZuRHViMnBLZ0dlTjVYLzBnQkNFanNjNSsxc2R6Uy9mT2hzS1FD?=
 =?utf-8?B?VEVYb3JHbkI5dllnbGxsWXBDelg0aVRhMGxid0xQUkcxSGpCUVdHcUVVY2x5?=
 =?utf-8?B?RGNqZnYzV3ZtSmdlTmlxQkl6M0dnQ3dSTUdvWGNsNWhFbzZ3L0JOa3RmRzRP?=
 =?utf-8?B?bWRrakgvNGZSbmp4cEgvbG9Ud0s1U1RJNDdUQllyNFQ2VjBWV2lWNzE4ekM3?=
 =?utf-8?B?ZXV5am1CNFhzOU1jdDgrb3dBVG1TMU0zMUxNaW9uZDM4eG9UQzl4aEZlc0pT?=
 =?utf-8?B?UmM2K3ZRY3VpMzVieUhGbU42M2Ivbk00V1dONUNoSmtTWEYxdHBLQmZMZDlS?=
 =?utf-8?B?Tk8wZjFjTmQrTVZRUnl6dXQxWHd3em1VQVh6ei9yWVJaT3l2VEswQTYrNFVS?=
 =?utf-8?B?cGcvRnpRZ2NOaGdmRmlMenRORTFRbkt4YzlFNjU3WTB6NXY5bHRtait0SGRp?=
 =?utf-8?B?eXBOd3RaY2lZcmRRYlJlc1J3T2l4YWJMSFAxUGFDQXNzekVnRnJFZWNEU2tG?=
 =?utf-8?B?a0x2aUM4b2JuVlpyeTg0ZW8vS09tcnRNWklZUVRqNjcyM0JTNW5TSVhOV2kr?=
 =?utf-8?B?VHlyWUtQMVJTbXI2NXpRMWdxMzczV0w3ZVErUVY1SkVNU1BlN1RVL3lZUWJs?=
 =?utf-8?B?bXZObmxscjdxOVZTZzhyNGN6RFhQRkNyVWk4bVo3MXZJc2ZpTmdUNDJ5ZHpV?=
 =?utf-8?B?eGlzb0x5TUhPdFJ6cDgxM2RYTGhlamgzY0NwRHlQbVA1ZXZkNXNmK3pScmlm?=
 =?utf-8?B?aVFxaFgvR1ZJSTZMTlVWVVV3NEZlTEdKREdPWDJTQnFzV2tmM0hXYm9SMnpx?=
 =?utf-8?B?T240Q1AvSkh1TWN0djFTbGxtcVYyVkpiTTY0b0c5aHVnbEliL0ZYdjBFamVH?=
 =?utf-8?B?aDBidXlxanY3WjE1d0VVTm1pa0VpN2R6SDFlOStyNzd1QW16YXB4MkJYcUU2?=
 =?utf-8?B?bGkzWkUxa0srUGJZRlVIRmFEdFFlVWVWd2tjSnY5bnFydjZiemFrOHFCMk5M?=
 =?utf-8?B?bkZmTko0dFdTUlpISDhxS3hndXNzdjM0djlvdExmaWZocUJxL1dmWGd3UkQx?=
 =?utf-8?B?NTNXMHBSSW1VS0Q5QWp1UTJNMHF2WmY2ZXdBbGxhMHFPZ05EK0RQYnB0VjJS?=
 =?utf-8?B?amdONmJsSkxGN1VySWYrdVJpcU8zS3RpWThkeFlwc2VTcThIVVVnVGx1YWcy?=
 =?utf-8?B?cmg1VDVhMk5qNlVuK2JmSWEyYTJ6R1hwMTdZcVpMSnpKZHA1UmcrUzJBOGZB?=
 =?utf-8?B?UWROVjlXZmhpakxFclQ1T1ZGVE9mTFhBam8wa0VuWWx5WFFYL0pvYUpWZmV4?=
 =?utf-8?B?bXdsd3RDek1adnpLNmNRME9Bd0RKcjFmcWlUeENGdTIwUTZ1SXkyVGpMeHVa?=
 =?utf-8?B?YnhPelBrQjhNbjd2NmZwUTNVejdYb2Zwbmk0NFprTENJUWVZaHV1WFkvYVZK?=
 =?utf-8?Q?xXX7zBjaG2J/bqg72cPF8/0=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c124e6e8-c82c-453d-eecf-08dd0b16513e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR01MB8094.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2024 16:54:23.8175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5AYNMgCzLMmRAsA4/XSsPdhI0gjXa7g61eZ3srhXnTryveVXyREjOWj9eVfd4j9fwIEN+tt9zBrMycCMK2ujWrxB3KK24AxJoJW5Qt1cd1hYQs/q8npyUcHvecUnx05b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR01MB8546



On 21-11-2024 10:14 pm, Marc Zyngier wrote:
> On Thu, 21 Nov 2024 08:11:00 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
> 
> Hi Ganapatrao,
> 
>> IIRC, Most of the patches that are specific to NV have been merged
>> upstream. However I do see that, some of the vGIC and Timer related
>> patches are still in your private NV repository. Can these patches be
>> prioritized to upstream, so that we can have have the first working
>> version of NV on mainline.
> 
> Who is *we*?
> 
> Things get upstreamed when we (people doing the actual work) decide
> they are ready. At the moment, they are not.
> 
> Also, while I enjoy working on NV, this isn't *my* priority.

Sure, I understand that it's not your priority right now.  I'm happy to 
spend some time on it, please do let us know in what areas/patches needs 
attention before the code would be ready to merge?

-- 
Thanks,
Ganapat/GK

