Return-Path: <kvm+bounces-28240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B9A1996B8C
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 15:16:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5051A28725E
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 13:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 786801991BE;
	Wed,  9 Oct 2024 13:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gzmv8hn6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2069.outbound.protection.outlook.com [40.107.237.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074A71991A1;
	Wed,  9 Oct 2024 13:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728479749; cv=fail; b=EXM8JjT7t0Xl/MTM3F86yk9rxBEv67QXWSh3qrLE8M12HREKI1z9phoJdFBJJqby1iHQnP6NGciPyaArkVCq8zmwyWodmrOk22gznWybN4/riTe+/Ui2yJJ33gPGZDjEzAwMnZws0BVbwtNASDFGMlFEtuK8h1CWsL4PJiOtiVk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728479749; c=relaxed/simple;
	bh=ylHPkSHDT6s6jsOEQnY3n8BzlK2TaBUWj1P7LQSVRuk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=trHPa5E8CqkENJWEvmilogqn9sm/iuYdD9s2C1bguFF0nctwTB8J0ZJZ7HGxQzmXhltEIeU/ZaOjcIn/EA+Qfqyeed/OfHvsrYQpx13gZYhiXLYAxa+80nEe96h+3+CTj8wbCC9HAsr7ZsxPbfGCQPRxGzDYR093ZvSuLfBDvEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gzmv8hn6; arc=fail smtp.client-ip=40.107.237.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sQLLlqv2X63vSuYzz5lXrPapK71GIQ/hWVAFkBJHLqKXzYEWZ1UiYivt4lWJOyu2YrYRu1eTnRHaCn+mvLse2br+xyokvsDKvKiG3y8pNFPtEf6d0iSgSYDrAghqO8Ary1+rEq4AIqawhNJWUdWHrwBsQhN17LrV6nWrBMTepLdEOaCEteXgprDBlOhrbEkNkaad1rIUOr4txHfpYjFJEqc4TMLkJljx+VVcFn9Xx9FU4dmC07f9fKYQV6B+o6ModKyuAh04bEQN/R6I/t6sPBWdpqnTCAvgovOwCFX7rKNK1QbGUkXgkrM89Kd8cuKjbKLnzwfy6pLIxRKijl0uyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sN51Y57rtyhAmcXRU2+6G3Io9GixkFdb0i6sG7+dOsE=;
 b=QeHCxpjj2MQUguHRSbIPOisetbREaTAhbhpPk27mSzYKd77frDQFDBnEWqTM+nKu7z6zwg3V25/VobuPDa+Qy5sH2Fa//YEiu0UU7M7nc5SOrdouid+wKEGYszDqHAu/4A8GfkHthgffojTgwpwnozx4F+EYScLyBoczr0UVAr283uJxZMuAj+bMqocq48pQqIxkQv1FFSvUIvEwOHrNAQQ7UIqk3g3i5jO5X17uR39oiRT5MmH9LH0jPccpTZV96i7il04L/TR3dly1LpMnUrZf/fQY1F+wN2RTd1AzSt0DB4pihJeFoZsbplhFVNV1jlCW67r/6aEaKvk4Qv++YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sN51Y57rtyhAmcXRU2+6G3Io9GixkFdb0i6sG7+dOsE=;
 b=gzmv8hn6l29HW3ZTifpX+DdxwJPSLGmIgwaNAHFCh4FKkBPjHhNdfeRI/2rDrAthB41fkDQTn+gOswrGMG0Gfmd5rZ0IQEEEKAhr08YHUXusd69tlDruP2+xI+y4vDayhI07L1jLjeAToVbXewQ50YCvlutscSzuUZllsD4Gybk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB7728.namprd12.prod.outlook.com (2603:10b6:8:13a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 13:15:44 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8048.013; Wed, 9 Oct 2024
 13:15:44 +0000
Message-ID: <1f57da63-cf29-c75d-af06-c2cd795f0b04@amd.com>
Date: Wed, 9 Oct 2024 08:15:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Content-Language: en-US
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
 <20241008191556.GNZwWE7EsxceGh4HM4@fat_crate.local>
 <8d0f9d2c-0ae4-442c-9ee4-288fd014599f@amd.com>
 <20241009052336.GAZwYTWDLWfSPtZe5b@fat_crate.local>
 <a1b2eba5-243c-4c7c-9ebd-3fce6cd4c973@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <a1b2eba5-243c-4c7c-9ebd-3fce6cd4c973@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0115.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::24) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB7728:EE_
X-MS-Office365-Filtering-Correlation-Id: a800276e-46a1-4b8a-4fc8-08dce8647b72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UUQ0R0lSNmhQQ1duempvMWt3c0xtRzB0SGsyVnFsbEVqV2g2aldYNmtseG94?=
 =?utf-8?B?UkRWWVEvZFY2RnRKKzhEK3ZDWDJjQVYvNUdZb1QwelJhWGd0V3doUzRUcCtj?=
 =?utf-8?B?dFJhLzhVSnA4MnNyZDNvTWFhTEpZdkhQUFZCNnJzakZSdGZyRXBGanh5YmZa?=
 =?utf-8?B?ZzlJU1hESFlKdTh6cUhCK3dxVlVOSFFIUFl2NTFhd0NxRWJJSmdjY0lwd1NI?=
 =?utf-8?B?UUNuUFNwYWhNWkxPc2laUlAzWC83V3ZvdzIvQTlxSkk1WURFN0tVTWNnNEZw?=
 =?utf-8?B?cGlTYnZzdDUzcmFlanYxc3ZVWHFaeHM3S3ZBbVM5bU04d3BaMVVuZFVvbDdR?=
 =?utf-8?B?QVl1WXBDRlkySm45c2RmK28vNW8vSnRjTmdXYytaVThvOUE0eTF6Z2o1M1VH?=
 =?utf-8?B?ZXNMNHZKTUJGMkJJNjM5eGxQemgydE0wSnhPZU4relR1NUZkYnBCdFlVaVc1?=
 =?utf-8?B?YjFtdFhZQytRL2pHbW1EcXV6c1BNNzBqREJnTzFTS09IZkl3R1BFRHdvOEtN?=
 =?utf-8?B?c1lOVUtCUlp1SjJmc3MxUGNSMmZia2gzdGwzZ1psUWNlaHBjWlRuUEE2STBk?=
 =?utf-8?B?dU1lOTB1QkhMV2E4UVd4VmVCRGg3TXdOU2UwQm9iTmtyeHNrdnkwaGZ6ZEFy?=
 =?utf-8?B?ckhDQVNXdVV0V3N5RWVyc3VkSVFZeTN1MnR3Z2l1WWpuTG5kWTZ3bDVIV21Q?=
 =?utf-8?B?dCsvRGZ5ZUhBaDRRbk16cTB1SXljUWNydEN3UEhhc1F2R2tVV1ZVLzVlY0p0?=
 =?utf-8?B?T05PVWlYWVYvMlI4ckhGM0VIMzhMTkZFQ2VGbWRNakJUU2JGdjBaQUFjNzFt?=
 =?utf-8?B?bWZHWnJLanEzaCtEY3FJTjY4RGhXZ2drTmVTZWlNYWk0QkNlVVNNWHRlaGF4?=
 =?utf-8?B?NGFPdVhmREhQTlBxR0t1aGlTdXloNVdyd21WM2Njb0VUbXB1Mms4U1dMMHZ3?=
 =?utf-8?B?eUJ6NmJqdW5Oei9wZG5KZnlxMUtaU1QweFJ2NXo3Zk9KSjBWdFkwRGV3Znd5?=
 =?utf-8?B?S3JSMUpWZmFVS3hzeVZqdEpWOVUxZHBjc2ZLMm5aVlZoRnBFS0FnVjRMejJ6?=
 =?utf-8?B?UnZVUUNqOHRRVWJ3b0h1MWpXWTZHNTRYeHZycjRBRzhEeWw5SGVJYjFKMnJx?=
 =?utf-8?B?QVB5Ym9TbVdiTXpKbHRJS2ppSERDak5maFREc0FJdjB2eHVWang3aFdDSkFY?=
 =?utf-8?B?UW4wbEVMRTdmcWE0cHFQS0lwNVRWR2VhKzZVUENVK2U2TTgrcDFsMmhsa1ZQ?=
 =?utf-8?B?UWN3VlppSWN2Wll1RDlYZmVZNzRwS2FoTzY3U3BCM1ViNk9GL0pLMnk4R2hM?=
 =?utf-8?B?RVFkM0Q0VWVWcmFsUWdEZzBZNlNPQXZiU1JtVThUeDFDTlkwL0hJajNlUkRi?=
 =?utf-8?B?NlVqbGt1T1BKakVyb0hiS3Q0c2xFak1WTE1UZzV0WjRBdElQM3BiWE8xU055?=
 =?utf-8?B?S1BISG85NzUrUWp3Q0pEczdaMktoOHU0MnhNOVVLZEdJMmdnb0VYNlBWRDJ1?=
 =?utf-8?B?MHhuTlpCK3VNQnZnbzBDTmFhME9TNW9ZRkFaOEtueDhXQmdyd2FJUEVsZDA4?=
 =?utf-8?B?a1UvU1d0RWFiWWFiZHBlNlYrQ2NycjZTdFVvcVJ2Qytvd0U0Z3Z5cW05UGlT?=
 =?utf-8?B?RGM5MzhjM1V3N1BNQ29JTDhyckh3Uy83TVRFazNMMGFsVUZWbFZTc2RmUmhk?=
 =?utf-8?B?UGpBM3d3L3IxMUNKMlFrTGRNK05wbDhTYTA1VnZKbHp6RXczNXplZW93PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SVNONC9pUGs3UGVLdDZ6TW02eFg2YW1hYUZMazIvUVFJZkxFQVdveU5oY1dG?=
 =?utf-8?B?WmFNTFdTMEp6WmVic2twMHNzeHp6Z3RpZ0l6SnBNSnhZT1VHaVhnMm5haXVR?=
 =?utf-8?B?YjU2TlJIZU5WekxlVjlJaVlRTnpOcjhXYUtEajhaczVzYVVKNmJMNTk5SnAx?=
 =?utf-8?B?eDc3b3dXRFB3VC9haXdra2JlclVXYW5TNEFLQXNoNlYxbU9ubEMwQzlqY1U3?=
 =?utf-8?B?QXl4NEFzcm85TmNQaFp0Skd3ME5nMUdJUU1IZU5udDhlUExTRC9LUVZJaC9B?=
 =?utf-8?B?T1VxZk91UDZDQ283bDh3cUhtWFc2OThNaUZoTGQxVjZ1M2c2aEpOd2RiL2ZH?=
 =?utf-8?B?Q2o2aWtLR2ZiS2dldThSQW8zSmxaN1NlZ29UU0RFTzZyZTNKNnNRMzk0My8r?=
 =?utf-8?B?c1VKaStLQytwVytvM0t0NXJ6eTRGU1ZUOUQ3bHhNbWVvdWkyN3VaL2I3Sno5?=
 =?utf-8?B?VG0vaUpQbnkzWVpBeEZRVFBFNTd3dk4ycFgzeHpvWTcxMWJOeG44UGFndXRM?=
 =?utf-8?B?RCsrYU9KR0FuUDdEdFlCN25hWWpuTTB1bEYyenJmU1lHZStLNit1MGdGRDhJ?=
 =?utf-8?B?MjZzZmErYlJpZHU1UFZRQlJ6NDQzMlVwQ1BGVWlHRnF4eU9razhOek9XVk5B?=
 =?utf-8?B?SFRKUXh5TEZHcUlndU9naUJXdXpqSVR2MElZcHdSYzRMeWQrdm5Qc0Z6OUhn?=
 =?utf-8?B?RmJqUWZiSGdvSnVod2R5VThYdWllM2NHU0xQYjI3amM2eEVVQjA4ck4xRERk?=
 =?utf-8?B?dUtxOTJpRUFybVZ5TkM0L3hXbEFTRTZrZ3prcXNvbVRFbFdKcmZ4M0QyK0tK?=
 =?utf-8?B?bTMzTGhkekJBRFhJdER1Uks2UTlqSmxUWEZOQmVSbG1VSHA2c3B5Z09ISlRM?=
 =?utf-8?B?cmR3Qmo0b3dXSktIcE9hSEVEY2VOamJyZnFXbkZQVUF0WlprdFM1STFibG9X?=
 =?utf-8?B?T3lxZEUwQ0FESUtqQ1QvbjNNWW9ZYnU1UVprdVlDNTN0UVU4MW0wTFU4bE5v?=
 =?utf-8?B?RXdMQW1JdjhFS1dtUXNVOE9CaW5jdW1SdzRobVZjV3VlRENwWjIzbGpTTGY1?=
 =?utf-8?B?MEZMYmk3OUdyS3lpUHZYY3BrNk44M3ZIRmpTQ1d5d0tBdy9SdkVFbDdKdzVs?=
 =?utf-8?B?bElLQmQ3R0diZnI3djBqTXcyVzErWnU4eEhEdXVKNzZidWJhWnI2NjNpV05n?=
 =?utf-8?B?WWVGRndoQjJiZE1RVStBQjFqbXRGUy84ZVhNT3RKS2Q0SHhCZWt4MHE4TFhZ?=
 =?utf-8?B?R3BQVGROMUJRNVdOdmZZOE8vZWZYYmtRTFZtLzl1R2RLUXoxMmREZm9wbFc3?=
 =?utf-8?B?aC9IaXNGZ1JkYWNhNXdtVjBkYzYrbmQ4Mk9FMkd5M0ltL25FcnNYdHZwWm9X?=
 =?utf-8?B?VVhKazV3N0x2QUh2ZjNkNGdvZjVrNjFUdDBkeEtEa3J3QWlKOFhRVmxzV0Ex?=
 =?utf-8?B?dmhGcWN4TTNmMkJ3djdqaEZtVFd5WTNaTFBFVWttaGZJRjlEdEhpZFE2VkJa?=
 =?utf-8?B?VVVZMHRidE9ZZi9abllWR2x1N2x1SnByM2dzMk9uVjJKNEFTSnhXWDB0TmJs?=
 =?utf-8?B?OXV0UjhsUlc0Z0lySlNlQ3MzOUdjVVRFc0tFV2cyYWZyUTNaZGNJNzJrcFRZ?=
 =?utf-8?B?bUtQSC9pVUljR3l6NVNDTUR1MExjL2hkVTZ5cWpxSXpKTFI5NnhrUWtxd2Zv?=
 =?utf-8?B?S0RHRno1NUcxSzdGRkRtbWdHdkdHTGZSQjBVOTZMOXVkWkpTM1c2R2J3MjlW?=
 =?utf-8?B?QldlTGZ2TEhvOEpwRVpxV1hCaHFsRVVUMWQxZmVZbGxPMUR5a0tDRTBsd3Nu?=
 =?utf-8?B?UFdlWTJsY2hnNHlIN1ErZi9xL2pkMm82S1NLSDRRbFdSODNwcGVUZHhQMGh2?=
 =?utf-8?B?aHVySkxVSjgwbDVXU2NkY1hUZzNYVzUzRHdpZjNsWDByOUFyRXdWSGFWZC85?=
 =?utf-8?B?a0xWeFJESW5qOU1oYUx2UmhSMnpvZC9WeVJOOUxCSklydTI5UE5iTHJ3Y0pL?=
 =?utf-8?B?VHlzcHErT2tndHgxTWorSHVHWVk0NnpRUk9WblZDZTZzbWVyejlCclc3citU?=
 =?utf-8?B?U3FJaXF5b3MrVXhEK1JkYkpCcGJUaklrMzFSSE1ZcHQ3VTdUNHJJcVRyemhw?=
 =?utf-8?Q?tBjIAsGvETkMFN9EK+PKMLRZh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a800276e-46a1-4b8a-4fc8-08dce8647b72
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 13:15:44.7454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ip9NGxX5nWDaHSl/98oMElDn+kiqhViUsZj78fo2MESTHqUpmZ1gazHMTHDg+l5bAy2mnxano9b4zBsVlbBUfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7728

On 10/9/24 01:01, Neeraj Upadhyay wrote:
> 
> 
> On 10/9/2024 10:53 AM, Borislav Petkov wrote:
>> On Wed, Oct 09, 2024 at 07:26:55AM +0530, Neeraj Upadhyay wrote:
>>> As SECURE_AVIC feature is not supported (as reported by snp_get_unsupported_features())
>>> by guest at this patch in the series, it is added to SNP_FEATURES_IMPL_REQ here. The bit
>>> value within SNP_FEATURES_IMPL_REQ hasn't changed with this change as the same bit pos
>>> was part of MSR_AMD64_SNP_RESERVED_MASK before this patch. In patch 14 SECURE_AVIC guest
>>> support is indicated by guest.
>>
>> So what's the point of adding it to SNP_FEATURES_IMPL_REQ here? What does that
>> do at all in this patch alone? Why is this change needed in here?
>>
> 
> Before this patch, if hypervisor enables Secure AVIC  (reported in sev_status), guest would
> terminate in snp_check_features(). The reason for this is, SNP_FEATURES_IMPL_REQ had the Secure
> AVIC bit set before this patch, as that bit was part of MSR_AMD64_SNP_RESERVED_MASK 
> GENMASK_ULL(63, 18).
> 
> #define SNP_FEATURES_IMPL_REQ	(MSR_AMD64_SNP_VTOM |			\
> 				 ...
> 				 MSR_AMD64_SNP_RESERVED_MASK)
> 
> 
> 
> Adding MSR_AMD64_SNP_SECURE_AVIC_BIT (bit 18) to SNP_FEATURES_IMPL_REQ in this patch
> keeps that behavior intact as now with this change MSR_AMD64_SNP_RESERVED_MASK becomes
> GENMASK_ULL(63, 19).
> 
> 
>> IOW, why don't you do all the feature bit handling in the last patch, where it
>> all belongs logically?
>>
> 
> If we do that, then hypervisor could have enabled Secure AVIC support and the guest
> code at this patch won't catch the missing guest-support early and it can result in some
> unknown failures at later point during guest boot.

Won't the SNP_RESERVED_MASK catch it? You are just renaming the bit
position value, right? It was a 1 before and is still a 1. So the guest
will terminate if the hypervisor sets the Secure AVIC bit both before
and after this patch, right?

Thanks,
Tom

> 
> 
> - Neeraj
> 
>> In the last patch you can start *testing* for
>> MSR_AMD64_SNP_SECURE_AVIC_ENABLED *and* enforce it with SNP_FEATURES_PRESENT.
>>

