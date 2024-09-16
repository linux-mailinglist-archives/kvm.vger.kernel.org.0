Return-Path: <kvm+bounces-26956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 002F6979B16
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 08:23:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 36741B22CED
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 06:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D67D40870;
	Mon, 16 Sep 2024 06:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZIBDXQvD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2043.outbound.protection.outlook.com [40.107.95.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3085538FA3;
	Mon, 16 Sep 2024 06:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726467797; cv=fail; b=ooE5IFK3gPKh/AXBhM2J2+OwhlWLB0fMTeUiYVPxuv+OQxHcSxEb8Vjc3sGxQlR0+Fqz09dK9LurC19hxKJoKI0+3wx8yELjmWcxsjlua3t7akt+pE6nKAgIiM4/ot44P6TMme8iABR3rh2QTw2ZcNNCpEYO6Bd2xA8Fe5wOLo8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726467797; c=relaxed/simple;
	bh=yTprD2RER+ZVaUK13BNWux7QW1SMplkit6eEVgOq+AQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=unpibDtFl/tYbv+wAeBHEdTmY1A3LA5TnT87+7dwNkupL8Do2ImI6MfxvqDZLbfJup49QNT3fMHQOqsCuleI3RDcFxMp4caXyW0ehtOjccpMAVPHExKiQtzQ47At4uMssVp1W9EKWsAYSFXOilB4cKZSptQQgHYDX4oUu8zlBTw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZIBDXQvD; arc=fail smtp.client-ip=40.107.95.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OyoXopl23HUnWxn/46NrVyLi/S0ZCYh0OHOKkSlwCxbZNsoYjKcryRCyvv3DWIX521/ILNpoUJNVVZQNu5EnmrHpF6f7z4mwx1uckpY0t5O8Zx8oJ5TovoBQbYR7lTquMbi1j9E8McdsSskGSqaKD+bBpzJsvbDSyqg45VeFmyh9xZfKG4SjJeE5hZLByyLmc3rXSxRb61j2q2AWx//h7Y09t9Aq2+bxFIK7CWclSuv2L5JTIErN5AJut/i2gDlxKpxOF35e/XiBXtBF5zVgd/DcGb6U+QnvO8tLEuWTf3kfxQJWWC8+n+uLRhBBtvz4knJRQfmCmsMIjvQHrhnSKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j8yloYn/pYedNd+m0/totCs5q90nsET4rVLEMbWdQoY=;
 b=Vy/2EE7+Zjm4ns2M/DV5pmmohuPjztpETP8oMhKgeFDOw67uxi7FeQzQkBDEWdpc/GSteM8d/WvKzbNDvfpIu2Hm9/K8TmIpO7KluFYKSaY2Lck7wCZahq0xTIiK71q9bNIh++0erH5f6OSh2uI3qQGZX31wi4BmxRUFCIyup7FgJeZQze4/7tXhSa9Nz8wCHTtLvmNZDPYpkYNC63k3dTHw1PqoZ0rjr4vxYyIKEcw/NpRNvKLzsxMGBfxdokbBd8JpsCHGpHleV1ML9EXoAIikduYtouxaroWk+ezXuJxEKR70oWPdgUukDv2VGfsg9Z3DUzAjGClvArGcSmmttg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j8yloYn/pYedNd+m0/totCs5q90nsET4rVLEMbWdQoY=;
 b=ZIBDXQvDYWbQXVCtuiVJdvnOeb0MHPG9UzvIn9R6J8Q/5DV/eamfsjn1w4I1jFY6GvjASH+ul2UIbVs0zH/Q2h10FKonDvy79GhVeUgvrqVNcfrqC2Jb0X9hfFP7umg0X+WzLrzOYUhzNPv6OegefYQwp5Q9RV1Q2QN/p/s8znQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DS0PR12MB7581.namprd12.prod.outlook.com (2603:10b6:8:13d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7962.23; Mon, 16 Sep 2024 06:23:11 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%5]) with mapi id 15.20.7962.022; Mon, 16 Sep 2024
 06:23:11 +0000
Message-ID: <fe7c8dcb-4936-2b70-4033-0ca730da10a0@amd.com>
Date: Mon, 16 Sep 2024 11:53:02 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v11 17/20] x86/sev: Allow Secure TSC feature for SNP
 guests
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-18-nikunj@amd.com>
 <ddd3dfe3-986d-4433-13c4-c65c15673e9a@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <ddd3dfe3-986d-4433-13c4-c65c15673e9a@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0083.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::28) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DS0PR12MB7581:EE_
X-MS-Office365-Filtering-Correlation-Id: a3eb0261-ddc1-475d-0731-08dcd618098b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?alRFSGJIVFhFZ3RIcmZqS0czOVlxVFpURkluQTdHWVRGM0VFdnVDSjdXNlhM?=
 =?utf-8?B?VCtWeWpJdWM2TGpvQVNnQmFxQlJSQzBibmhDRUxSL0ErbUJ6WGZzVmt2NmdX?=
 =?utf-8?B?NnlzSE9zVXZuM0NiSHNla2tkVDRuRnU1WmxGZllRT3NESnB4dElSaEVidEp4?=
 =?utf-8?B?alFTRHk0eU4vOS8wejRSMlNSRnY2T1JUUWZhVDFERGhCM0N4Mkx1Z0dZUUpx?=
 =?utf-8?B?bTRVZ1ZBcXNJQXFBQ084UXBTRkdkb0NxMzV1amhRU0dpZHdVZTN2ZzJkM1lH?=
 =?utf-8?B?R0N6RkZFSUh6YjlXM2pTTTdVSyswUFkrVHQ4S3JvRUozcktBWHNzOVplUi9M?=
 =?utf-8?B?c2w0aHJGYThDNUJiM0JWbVZKQ0ozRGk5QjdBQjZITlhIeE1jZTJWRVFtdTFU?=
 =?utf-8?B?RHZaMDhrTE1CczM2OEtQaDR4SmExSnZyUXMyS1poRnZqbkRLK2J5eWNJZEVK?=
 =?utf-8?B?T3l4UHM4OUduSStzSXJ4SGVZQzg1YytlakxoUkpaaTFyMVlVWlN5MlRabEpB?=
 =?utf-8?B?dHFDWUVhck9KRzJnY3dOYzdRRHRsU1pxQTJ1dVUyVUloUm5KaUc0TTNkMkpm?=
 =?utf-8?B?Ujh3TUVvOXc2eXMvNVd6VUgvY1Y0bEIwbXhRbFR2azBscm1mT204QkRGTlF1?=
 =?utf-8?B?RWlhK3VrQllJb3FqL29NNm5ldHZESXNsMmFaWDJNYnBGazJrL0RTZURPeEVH?=
 =?utf-8?B?RW5pU3pNN1gwUXNYU0xoMW52a3A0cHNkTW9aL25rSW16V2VDbUpobGZ6dEFl?=
 =?utf-8?B?ckRxcWFhMzJ5dlFma1Q5Ykt0ZFdnM3hIbVBMUzhhMm54eDBkMlZJTDR0TWJN?=
 =?utf-8?B?T1ZQZ1lQTXpnUDArUy9Kc2JGS2pSKzZpS0VvNTN1M1F6WU1IbUFROVJLbWdC?=
 =?utf-8?B?NnJCTHBsalArdDhoVnZiNjFDL2d5cjhmYU1FTlNLL0tpVXNjRnBlbmYrRHZ0?=
 =?utf-8?B?QkdlaityR3NnNENneThOV3ZranlWVHk2Nzg0SnQweVBvQTlXRktFNVRvMEww?=
 =?utf-8?B?NDZReWJSK0l6YWt6ZFI3NGNveW9SaEc5U2lscEhZMy9UeTBFa1NpY1JoOE54?=
 =?utf-8?B?MmZHTG9jdnNGM3IrWEpQTnMyQld0cjk3RG05bXFmWnMzYkJweWFZVlJaMjNZ?=
 =?utf-8?B?dnhrdU5nSjFBcWJ5N3dJNXh6UERVcldmcmlDMzJOOHdkRERsaVR0dWNOdXAw?=
 =?utf-8?B?cDhiZFV6aWU3RlgzVUU4RlRjZEd1dU4xWXdwS2Rvdy8xcTFBQldocWkrTGU2?=
 =?utf-8?B?cVhpaHZOeHBud2lQUmxHU2tNNU9zUnkrTDFNRnB0TC8zVER5dkJqT2VoV2Zk?=
 =?utf-8?B?Yy80Vi9lSnZlWmVzSXVXRHpDRDNkK0lJdjcxQ1ZzeXlGOVgrWUYyTmZTQ21C?=
 =?utf-8?B?WXFRdE8wQ215eUVCbXJpWnp5MGgyY21PSUJ0VExMZTB4RlNhQzdXNHpEQUUw?=
 =?utf-8?B?UzM5ODhHOXlsMFczUHFvMWdyeDRWRjk5N2xEYnJncE10djRaK1RMR1JOM00z?=
 =?utf-8?B?YVVHRitXN01BVVVFN1RiTDJWQTgwTVdCdjZjWnZIMzM0ZGQxQThDaXk2dEln?=
 =?utf-8?B?ZkZuckEvc2M4Ri9sazJaK1M3bE02Wi81MkUzTi9vUE9sMU5pdjJMQUxaUTRM?=
 =?utf-8?B?TWxlUGNkSXZxdkx5OWFEcnpDWHJ3L2JaWFppQTZ1YlNJRy9ZaW4vbDE3RGhR?=
 =?utf-8?B?Y1R3Qy9oR25xSE9JUVlQeUlVNU14QTgzb1dLMmZKMllrZ1NEMUp3TEM3a2Jk?=
 =?utf-8?B?Ty96NUtab2tSTE5VQjJZMTlSSVF6Y2xlWk54dGZtK3pJSlBJRlFFckhIMzJ1?=
 =?utf-8?B?UDk5K0R3R1JHYkRraEd5dz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aVh6ZXZzSG8yM0N2cTJZZm1BNlBNNmZ2VkwxZElzc1dlS1V1a01CdFNhM0Rm?=
 =?utf-8?B?RFBsTnVaM3FFQlpEL3RxdnFMZGp6QlRNZWhKWFFvZmVkTHgwSTJKMG1UMmc2?=
 =?utf-8?B?T1FvR2NUU05ISlJYbDJ3a0lSWGpPUFM3MDBHNGtxaFVBTmdmMnd4aFEyWkF5?=
 =?utf-8?B?TmFIMlVmd0J1TEtTZ29IMDcycGdVOGZuOFdSS1l3VnZ1WUlxamkxQ1VNamVh?=
 =?utf-8?B?WGg4VTFkZEhGSXJuSGFYeGdzdHViOE1KdW1SRjRtbE1Ob0tVZDJHSXQxOGJU?=
 =?utf-8?B?TERxU2xaR09JZDRqRXVrZHRnOTd4RFByd3hFTS9KS0ZrRmpoMmRSVFlpTGxY?=
 =?utf-8?B?SEtQSmNURjlKQ1BtZEdiTDBvWlp2Z3pRcWlRQ0kxOE5RbHNZMTVqWnNLaGxz?=
 =?utf-8?B?V2hZSjgxaFVkY0x2ZnYxbTFMdjBmYUo0NTNHcXRrRGo4WjIwZXZteUpDdnFu?=
 =?utf-8?B?MmFEOGx5aEZTMFJtTkVnWHBYMFZBTXoxQkFKR2NGR1ZIQVlGaVVDSEE4OHZ2?=
 =?utf-8?B?aUEweHpmdWlmOEdZN2dtVXNCcWtoVzRvSnlvTWtEL1g0cWZKaGRERFNLTWc3?=
 =?utf-8?B?VVhUT1ZUcFNNMytrQlNCVlFsaDg0K3A2ZlFVcTJUbzk5NmVEbUlmZVFCa3FP?=
 =?utf-8?B?K3dURS9pQ3RtbWs1a2ZqMGlIVDJ1OStncENvSGpDaGtpcGtlS0Y4VjN6VU9u?=
 =?utf-8?B?OEtpZmI0LzZSTVp0OTVvZ3JBOWxHckdhb2VtSVBNd0FrYmQ2aWtSMVgvY1NU?=
 =?utf-8?B?bk9xcm1tQWNWWit1dXZPRjZGZDkzNlA4WGhnaDlrL0l1d1V0d0NPeDYxRjNj?=
 =?utf-8?B?ZEE3Vmh3djBlbXBvYUM0U0RYUk1LNFl5NTZlTXBabGF5U1R2OFFMTkJIUzBJ?=
 =?utf-8?B?YUZGMzBEM3Y3STRJVTNDTzZuMXVOL0xDa3lDbzZzQ2N2dDVVMUs5SGdPQnBt?=
 =?utf-8?B?SDd3UHNWRHczNjJVTGtmSnJHaFFacVdDRWc4S2VyTEVjakdhN1B5bVNheExO?=
 =?utf-8?B?ZUp4TWZrRnZrMldXZWVnb3VIVS84VlRzOUZSdGRGU2NLOEVHV1BYZzV6cDVE?=
 =?utf-8?B?V1hFZlo3MlArRU93VGdlV1JSTkVZeDVDa0F4OENrMWl0Qm9TbngyNTh1YVVE?=
 =?utf-8?B?MlM3dkRBdEMvakIxbldpN2ZtOFRQc0dCSnZTOVAwZU9NUC80enA1Ti81MWtI?=
 =?utf-8?B?aElRWHZLencydVE5bVY2eHVjV0xRUldzTVdTNnZkM29xazZJQXJ1SjJ3RjVq?=
 =?utf-8?B?NUJjOEk4c0h4d1YxeTBMU2QxSkIxbTBvanZHU2NkUFNaRkhydVJSb0liby94?=
 =?utf-8?B?a0I4a01KWjVHa1FFdTJVcnFiRGx1S0F2SytxbmJGZ2ZLaVowMkp1bStBUlBv?=
 =?utf-8?B?c1I5TEF6Nk1YZlFybkgzQ3I4RUJ5SGJ0cGI0OStuZG9hbENyNENPMHdvL28r?=
 =?utf-8?B?VzV1a0JGakxYSStHUlI1OXNSdERsYUxrT3JBbmNRQjhCT1NnUHlLYVJ6c3JH?=
 =?utf-8?B?ZkhRMDd0Ymx6UUdhcFI3b3ozNmVjMFhpMS9BTTY5R013UHYrU1V2dmhZYW92?=
 =?utf-8?B?QXlCRzhSVzJnV3pFSkdGR1NFWXFlZG1Xb2xSWnIxMnlYd0xrU3A5R3Z4ZjNU?=
 =?utf-8?B?dk5taFF6UVpiSitlTDlkSi91dlBxbFVYU3lCYkJQbG45MmhoSy9wL2xxUExv?=
 =?utf-8?B?MzF0Z1BLc3dVYitSMWZ5ZENEc3JjZVBRSmJCTU9FNnkxZUNXeGtRa0xMRXpl?=
 =?utf-8?B?NXhrSGNjbkdLZkVRcFF3bE1nUFJZckp0MXdXTmJiSjFqYnBQb0ljcVBWOGxy?=
 =?utf-8?B?RGttU3M4YThYM005SFQyeWYzUWJXQjFCZE1KY05ZUm1lWngvWjZEL2twbjZT?=
 =?utf-8?B?UnFyVUZwODB1TVVkZkhBNTlHcWQ5SWowSWhzVVR2Y09mWVRyRzhEblUvUWND?=
 =?utf-8?B?eXAwcm5DNzVSeTVQTlVrMk5pdnU5MmpObWdVVDc3bFZ5NFJBWWp2dGE2S3Ro?=
 =?utf-8?B?d0tnUThFME1TUWx1MFl6QTNkM0FyYXlaMiszcTYyOWhlRHhTZjdtQVR1S0xs?=
 =?utf-8?B?M3cvZ3B5ZHZsckpVcXFpVkovOTNMNDJpeWh3Ui90YjlEaThaN09GbUZhRFlC?=
 =?utf-8?Q?LvGv8pSfHxqoUCThvhwZj52s+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3eb0261-ddc1-475d-0731-08dcd618098b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2024 06:23:11.1435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yQcoVlsGtgdPDfyum2cslOkx4GyVG9VKEcxAeI/RvM/cRT4aOUOqS0fdmN7EkxtVm3bgtk/M9esVBIGKwzDedw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7581



On 9/13/2024 10:23 PM, Tom Lendacky wrote:
> On 7/31/24 10:08, Nikunj A Dadhania wrote:
>> Now that all the required plumbing is done for enabling SNP Secure TSC
>> feature, add Secure TSC to SNP features present list.
> 
> So I think this should be the last patch in the series after the TSC is
> marked reliable, kvmclock is bypassed, etc. This way everything is in
> place when the guest is allowed to run with Secure TSC.

Sure, I can re-arrange that. I had re-arranged it in this order so the
TSC related problems are visible after SecureTSC is enabled and fix them.

> 
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Tested-by: Peter Gonda <pgonda@google.com>
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Regards
Nikunj

