Return-Path: <kvm+bounces-29587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A51639ADAC2
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 06:01:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE5CB1C21954
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 04:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8C71662E8;
	Thu, 24 Oct 2024 04:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Hw3dLPgk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFE3481B3;
	Thu, 24 Oct 2024 04:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729742479; cv=fail; b=CA1uRZqSdj7wlD0117BnQjNlSWMAJztRpR6xIBfedZuI7Mdu2GqR8fas0tzUWE8vqKU5b9X+EmWe9LRNRGgRTLftMAdm0cLXa94GsWf9lV3lIoFB3UoCJ/bkBDq5pZBKO0fGDvIax5XGROzDJzMefo2hPYZTSzKcyzO83ZQdCuU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729742479; c=relaxed/simple;
	bh=3k+yEtnABsq7WJYSNGDkafjfaAr37uoz1FRyx7SKEHI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g1rkLwxqTn8Fx+SDTFguDcjY3jPG1WBnzdIHfME28O9am1o8/f538a1S1oYl5zGiarzw1yZUXYdCAiC56k3YVVlLxRbiy0gmklKCj/eczsspiKFEEbx4q8mhaifI2JsdLrBeSW3Q/3wWkAr68CTChM5K8pxKSli7ebD9Ny9w+gc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Hw3dLPgk; arc=fail smtp.client-ip=40.107.243.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZU/lFHAjS/BPIZVqO/sQT5708U8mGB2rKV6oXtUp7CDLdZYnTXmLRoB4wvVIvvvBjqb5uNN1paajKCJ/S7RFOAOE9WEUePzevMledXnATlX1I27rQ6q5aRqI4F3VuQ+/nBGSOWUItMOFbLXmWYPdHYXuHtnKCzRNSo3TTfYTdTl0n5BKN/PnRM9KALzTax5Ls35U7wS5mA6ErhegegwCNayP1wpUFj8EMfiSQTnxm1wJqPhVavQsd8fV/b0xfkxWlUNVWOqWb2eJw6P9Vs47rnlzMa4hfbQN5AqYMJcCt8ea8OGOmAeevyQojPryCtOSqL+4SvoXQC7exq+1+WICDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zj629QuraNxxO6GbeRTz0l7pFelQiOG3qWST6r/v/Ug=;
 b=GtnZFJrGjCG/PciO00tVOJEtXnJgyZgplUnkbVWz2LFkJdY17Jr4ASGsV/upuPAKw/hhYGQGQ4BPtoiYiS9w8khBAmbsPcsP6zQiElz9zKagGg8TCCNesaRZjiqFqEawIl2uBebXp5XlgLoj174NVI4bgQ0O8AAGp6Nf8w1ml58Hj9fjle2RCMf286L6KhrozKVcNFYuaMYp4IdGd+aeHJwWUdKxaK0Lds5c1iGAY6i6YsLPt0wSqARPmNVvGXMh2d8rEdyKigcjo03CBFOpsb/EhJIkmYPKfs7NF8ytOUZQIdO2TWKBDb+JYNqZo19Qs7i3HQhDtld35UD43+S0vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zj629QuraNxxO6GbeRTz0l7pFelQiOG3qWST6r/v/Ug=;
 b=Hw3dLPgk/h+8Pi7bIE0f4DgS8vFzD5NF/JvG8bHQ6Dn0SLOH7pj+G0cmvC0WxYq9g4kYoqHN+mp/smAOvz27WnFkS6RPp1crtIUDMTfjYzohKm7vjcQ/Zwd0gAd5OB/WQTYuJIgN10QTEbbaS0sgH6VvL912/NYTyOuUMdHJ7mU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 SJ0PR12MB5662.namprd12.prod.outlook.com (2603:10b6:a03:429::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.17; Thu, 24 Oct 2024 04:01:13 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8069.027; Thu, 24 Oct 2024
 04:01:13 +0000
Message-ID: <12f51956-7c53-444d-a39b-8dc4aa40aa92@amd.com>
Date: Thu, 24 Oct 2024 09:31:01 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 02/14] x86/apic: Initialize Secure AVIC APIC backing page
To: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-3-Neeraj.Upadhyay@amd.com>
 <9b943722-c722-4a38-ab17-f07ef6d5c8c6@intel.com>
 <4298b9e1-b60f-4b1c-876d-7ac71ca14f70@amd.com>
 <2436d521-aa4c-45ac-9ccc-be9a4b5cb391@intel.com>
 <e4568d3d-f115-4931-bbc6-9a32eb04ee1c@amd.com>
 <20241023163029.GEZxkkpdfkxdHWTHAW@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20241023163029.GEZxkkpdfkxdHWTHAW@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0045.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::8) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|SJ0PR12MB5662:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c9c650f-be12-4e81-479b-08dcf3e0804d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V29Md0pBTWlXRFltVUJhaktxcnQ5S0FrOUpUSU9rMVd0TWFuS25VNGVwYlNi?=
 =?utf-8?B?ZUt1ZkdKUzFIaldWZG1qc0o5NCtUSDJUU2RETzNwR3V4YVlBaEFnaFpaUG1a?=
 =?utf-8?B?dmQ5WGRHWDVnenlMSFpTZnNmRzJuOEF4NnkwNGxHYXhQcWFlbUZCaVFYeWI2?=
 =?utf-8?B?WnRZK2p1RU5lSFd4UTZUQkNpSkh1RjF6QmxYaUVEVjJtSXpLcmRFaHdPSXlF?=
 =?utf-8?B?T3pTL1ZrbUw5c2ZTWjlYbnBQeTNiang5K0hMSWZFSFJRWWtYNnROdG8vNDZS?=
 =?utf-8?B?anRzem1vTE91eDY2S1pXTnZZb3BRYW1uRk4xRjVrb2FUU2JJUklNMzNhT3J4?=
 =?utf-8?B?QStld0FQNkxMN2tvZEUrVlF5em8vc1hhb2hEcXJWV1RGWTIzYzg1azdrd2Jx?=
 =?utf-8?B?NDNqQlJnYjFXNXFSeU12bE1vYVdIMUhWQU44TFI0Tml2Mkx4ZG1QZ0VyZGZa?=
 =?utf-8?B?ejIxd1pKbGpWTkk0Nk5mZVNSSk9PbUZLZjRUcFFMMnVuVGtDUzVrZlpWNUVW?=
 =?utf-8?B?STF0S0xJV3U4aVp2Qy9FTVcwNmMvdXNBbHgzdE1GSXcvLzV5Rm05OGxiSjY3?=
 =?utf-8?B?Z2g4Q1NBODF4ZmZDdmhuVkJrVzc1R2VnbFpZVlZwYW5mQW5WdEdXbGtXaUZt?=
 =?utf-8?B?MUlVY204K3lUZm13SFJRcWJDYUxVQzhTcWRoWkVOcVkyVHpKYlZhcm0vRUZn?=
 =?utf-8?B?Wkw5bnB2UWJmQXhCUldvdjdaTlZoR2FIN3JmeXlJTENnNklZdFBNNlBweXBh?=
 =?utf-8?B?Q3JRSWt2YzlYeHNBUWtCSFNjb0crL2VyMnRPc2VrYjVidmtnT2ptQmlHMS9K?=
 =?utf-8?B?RHBxZEdwNTVrUkJQeE1oVW1kVWxuU3duTE8wQzdRcG5HcnIzUDY3b093SUZM?=
 =?utf-8?B?NzBURTdKV1lVZzdmdlhESGh5dFRpQ0NZMW5IVHd0RXc4YTM5MnFtd0RVUkpF?=
 =?utf-8?B?eUYzNVdGYnQ1TFhLRGY3NXF0OFc1cHZmemZ0dGkwTFk0OHVVTEJJQUw5K1NC?=
 =?utf-8?B?NDk3WTJYeE4xMDIzUUhqNGpVZ0dJQlJPZjB2cmNZenArVEJZcHN5c1drMENP?=
 =?utf-8?B?VjVUOW9ZWnJHUDZYTkNjVGhvRm12M2w2VUFzSmFlL2FVVDlEMzU5TUlSQVBU?=
 =?utf-8?B?eWRHbG5yYnNhUkJNQ3BTakVtNnJzT0JweEM2RnJOc3VLSlpIYjdVaW80NFBY?=
 =?utf-8?B?elV6ZFNkTHh5T2VVYWhiaHpERUR1VXR3TDJPYm55MUd4WnVnTGhCZFE3MTd6?=
 =?utf-8?B?bnBnTjNSREtUQkdqZzdhSXVGZVc0cXltTmZ3WlJaTHRSdnRBamU1RjNqSHMr?=
 =?utf-8?B?d3NpTy9jRi9ZaG9ZMEhPRjJvajlwRnNtZUJjZlpsVGE5L3lXQ0NnbkZqZ1hi?=
 =?utf-8?B?UGQ0elRmemJvK0J0Wk0raXhTQk9EV1NUU3VxZHNOWFd6V2JwUURXL3FNS3Rr?=
 =?utf-8?B?VnZ3dlhVdmtkL2NRMjZGV2htSGl2dlplcEFQNWlGaGNrRXU5bkNBUGJ4UGhh?=
 =?utf-8?B?dW0wOEk1bUJTWjJnM3NNaW01d3VvSDlwVzI4WG1FUnVlMjhpenYrU2Jwb0Jq?=
 =?utf-8?B?bTdqTUozSVFNK3hyTk9TckRtUEg2MW9mZGNMSnkvVmpscnZhalVsc3NlUzRG?=
 =?utf-8?B?K1h0Um03Q0V3cjk4VUlRc2ZsVytzUS9yYmhqcUlxTmlPOFp4VXdGRUVBTk9T?=
 =?utf-8?B?SmxUejNjeUtCM2xBNW81bHlYZUpGcUt4ZmVpTVVpTEd4bUJOTEdRU0trSmRL?=
 =?utf-8?Q?d1LEzUhshKPbDrD1kI72OE6LmExhQRfCy9AHHgl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SWhJa3Q3cmZ6OGZBbnVQMFc3akw5U051Yy9iNVlYVjFQak5CWmtSQUs0MWtU?=
 =?utf-8?B?Uk5RUVQrNUcxeUNmWHI2a3c4NGRGZ25JQkRPZVdhYTdFR2tJVUdRZ3hHOXhR?=
 =?utf-8?B?L2IxMnRnWCs5UVhqbEJ1c3YxaDNQb09iTk1OVzJnbFUrN3M3VnBSNHZFeC9r?=
 =?utf-8?B?NitvK0ZpTEpxdUpNVG1xTTlrZ2dQYTRnejdOOEpWYUtNV25PSFJ2NmswQWVR?=
 =?utf-8?B?R1FSUW1zQW5MSVRlMFhpUHdqZ2RQR1puOXVoeU10LzIwbW9BQlhEZnNWTUpr?=
 =?utf-8?B?UlhBM21JdEpRSmVjTGRiVDM3Y2EybmFEVWh1MUY4Sm9qRjJxd0JCYmQ3U3RT?=
 =?utf-8?B?TFVUU3VXenNtbjhZMVRscVZ4cUhCdytBb2pNeVU5SU5qSUV0aVNzT0Q0TG1L?=
 =?utf-8?B?bXk0K3gxb2oyajZUSXdBS2lMNmJOQlFHcndOMnAwV2lhMWhsa3libUVyU1c1?=
 =?utf-8?B?dVZHOEg1N3lBRVlQU0FGNnJzalpGSzM3WloraTdlem94NlNuNGREOVBmUEow?=
 =?utf-8?B?aXdpdndIVHRyeExBZlNBUkkrZFVBTmQ1YXExSis3OW9LMmJRN2NrRFpwSk50?=
 =?utf-8?B?ZlNreDEzTUg0SGNra1pRUFN1VWxNZzZVcm1oMEdhWk04TjlWZW9SNitRRklm?=
 =?utf-8?B?NkhmWWlNM29IYThvV3B6YW1FQTZJbndUUU91SUQwUDdodFNIa1hjc1ZaUitw?=
 =?utf-8?B?MGxCejJPcjg2QVFaOGgrODd5SmtUTkN6NkhpYkYxMnN6cmJ6VTNPOVBrNVZa?=
 =?utf-8?B?Tjc2SUVQd05valR6UWNOd2dQbDR5NExCMEN4QWFzU3VjTXlwTnNzdmZVMDMw?=
 =?utf-8?B?d1A2SERoK0x1WXNTWUJkYWJGVUlmNG5PSEQrVEQ0L0NvZ0tIV2VqMytHT2VU?=
 =?utf-8?B?ZE4yYmdqZHNqRHFQQTFySG1uUWsxcE9JSEJkMlo5c01JaFY4T3JDR1h6M09x?=
 =?utf-8?B?NzVBcElBQ2dOZWc4UE5Gd0IyZnhMWFo0eGxFZUFoUS9USTU1YlVxbVFJaE81?=
 =?utf-8?B?TTU1Q0U4eHlPb1hpZDluM0lJSExFdkZDZDFLejd5TUNlSkd3cHA5djBYUFBn?=
 =?utf-8?B?NDdTdHBqL0ZSRHBmK0g2cmM2aFFMbEhCTUxmWHI0YitIVzRNVGNmcmt4TkFI?=
 =?utf-8?B?SlFiV3lKd3IzUWZ6eDlUcjh5eDZnZllaQ2dTbDV3eDV6dEN1UjJnMzN0VE9X?=
 =?utf-8?B?dkU2RUxGaWdXYjVCMTByR0k5bWpOMFh5SUdjSEpmSW1Rb1BkQVNIMmxuSFdk?=
 =?utf-8?B?NnRXS1prTXM0WE5tTmxHUnNQcEpSQVBNN1hRQk05TGVvczJhYmwrTjlOWHcw?=
 =?utf-8?B?ajVNV3lFZlRiSE1Gbm5JMHU1bDFkMFhsL3ovZnEwOExsTWY2MWd2SjRsNDlt?=
 =?utf-8?B?cm80OTA1Y0haZEhNZnF1VmxWdC9ncnZPM0trWXVQQS94RVdCcVNQWGR2UCtx?=
 =?utf-8?B?L1hJMkVVZ2NTZG96bUVEWFYzaVZYLysvdXlndXp3YnM0ZzNTOVZKL3ZPdmNj?=
 =?utf-8?B?ZHVIQjQ0WnQ2WC95MEZFZkVzQ1NaOWNucGc2WklIWmRURmRscGVDS1Bkc1FQ?=
 =?utf-8?B?T2ROTGZCWHdDcmQ3N2FVS2ZyRU1waFhYUVIxcVg0RjVEZkZUY084ZThMcG1p?=
 =?utf-8?B?WmhQZGQxeUozZU5TbDlJRXBGMGlwaVJXWERlQjl3WkRZVWpCRVRCSG1wRG5N?=
 =?utf-8?B?K3FBcFBQdXRVU3dtQUl4V2x4MEdqR2ZuOSsxcUFmV3c5ZzZNZm9lQThwNmQz?=
 =?utf-8?B?NElhRlV2RU81encydTBDTG00Wm5tTDB3UW1QUTY1b1k3QXp4anJVN1ZpbnFQ?=
 =?utf-8?B?ZVNFWFVPQkowczJkR2QvcXJRanppam53NmNPcFhmY1gvK3AzQjl4aDIvUk91?=
 =?utf-8?B?MTZ5UHV5N3RYVWVla2tTSGJtQUdRWldNcXpNUTMxb3ZYV1l2cFRubWJrcUc5?=
 =?utf-8?B?OFR6NVBNUlA1QXNRcXJ1Y21IMDJhRVY2U1NiYlJLUHJKVkVuVThXYUQ5UUQw?=
 =?utf-8?B?Z0szQ1B1Wm5xMDRNNFNGdlRhZEFHekw5eGxSNXZWdnVDMTZnemVHL0NiYnpX?=
 =?utf-8?B?dERKNmI1cWUwSlBsSXI0WVI0SXIvRjRSL2x0ZXdYRUxzUE53dE5lRXorVUFk?=
 =?utf-8?Q?5Lx3pDTjFu+lb9Tv8HOfMkHV7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c9c650f-be12-4e81-479b-08dcf3e0804d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 04:01:13.4636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qkYOOfRYpse3zgLPNqARHHLVhiCDSemxRz0/dJsxtXbU/0aDGVhv+nBZ7KxIQRlzItXdN2Ob21Cm20gwEYqf0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5662



On 10/23/2024 10:00 PM, Borislav Petkov wrote:
> On Wed, Oct 09, 2024 at 11:22:58PM +0530, Neeraj Upadhyay wrote:
>> I will start with 4K. For later, I will get the performance numbers to propose
>> a change in allocation scheme  - for ex, allocating a bigger contiguous
>> batch from the total allocation required for backing pages (num_possible_cpus() * 4K)
>> without doing 2M reservation.
> 
> Why does performance matter here if you're going to allocate simply a 4K page
> per vCPU and set them all up in the APIC setup path? And then you can do the
> page conversion to guest-owned as part of the guest vCPU init path?
> 
Please let me know if I didn't understand your questions correctly. The performance
concerns here are w.r.t. these backing page allocations being part of a single
hugepage.

Grouping of allocation together allows these pages to be part of the same 2M NPT
and RMP table entry, which can provide better performance compared to having
separate 4K entries for each backing page. For example, to send IPI to target CPUs,
->send_IPI callback (executing on source CPU) in Secure AVIC driver writes to the
backing page of target CPU. Having these backing pages as part of the single
2M entry could provide better caching of the translation and require single entry
in TLB at the source CPU.



- Neeraj

