Return-Path: <kvm+bounces-41379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 531EAA67428
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 13:43:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 184A87A2AF8
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 12:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96C9120C499;
	Tue, 18 Mar 2025 12:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XLlU4rhF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2058.outbound.protection.outlook.com [40.107.93.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06049207665;
	Tue, 18 Mar 2025 12:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742301808; cv=fail; b=TjAZD4Wzi7sehCX0NtWCMoZiwVW3KcjxooovPsk6yoXiZUbndjWGlnS+EmIl9Ralu7T+36uHad1FNrT/DMOu1Kzm+gpfquSlfelzogolCiqJkWQ5Yqw5uTzOXDcSxsiR1KPysKrY6dvUBaZsv58TNEFfjj2nmiia2FalYTrY44M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742301808; c=relaxed/simple;
	bh=s3iL1GNjJIaQURiKjoA6pvoTAP3F8NIH6mjA4EJxD90=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Oo7xi2J7Ngj/6XRNIrKSDlxZsseNhDlUZv6hiDaOWwDpCasHPnpJ9zeN3WOTCE90roDiQB1I0/WNfhiDI2wCfARWdT55EAc6xfgYXSjwV2LZvSE7nXcrc3ajqkVgc8Uge+chrUT9t8vQbgmvQFZiFuNQ+8k466FCsqCBOLC4D4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XLlU4rhF; arc=fail smtp.client-ip=40.107.93.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tCfA73zh4Tqe9nwwUw3mxqf/johiQ46lEp8Zexhs2briOtRYZTGFH3+FbabQHXhXPq0es1bsM+XmA+Kbq2ttnN9oIK7cA5D3keCe9fSjqabUXtmorgMC8RTCu/EclyiSw9eTw4Y0cX5Y0HcY0TAJlXSIh/wpXmiqKp1y33aNDqpGnUkg9s6s6t2JvARn1oBE6l1iBbe5M8TaQW1GEWUfu/XS/E11M9JcvhJ+jnoAFQ9jLIQCB1U3YXQQMTvPXdao+Bv4B0f+g4ilJiE2CAxEwwO6F7pLAxTcWujtJPc1k1dI/eMizkQvj7+qolXi8a37vqUqzcLDq4leH+gd7ApJfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yZZmPju8C05BK67vG9SWFiLRsc6L40Fs1sqzTXq47CM=;
 b=FtIZBR6prkXghtRwZO9YmDVU/Ii2ExBq3EOzkED9vM8sjzcqVUhZheYVnlNgodsHf5+QTETfVK7aU1gKbUdv5ouFlffv3Szmun9nZYSQ8AcWko4wUdk7VBX/0FamBerHvCzmQviUXWUy0zhEArqHpSyhV4H5jqMwJ3Kmq8ZqT6pgocRfOcOjekEmorQ7i5MTwmf+bmyRd7lYomCmejJzby6igIavHDBsILaHPl2mzi/+9y+udVOVKBwWoKdB59lWwU0HXGr2K0d69lwx6gYYZh93LiUqEFZTR84YJusJO/bYJJttKjiMiGh/2J8wCdTcjThgVddhSUR8jye8QjVLmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZZmPju8C05BK67vG9SWFiLRsc6L40Fs1sqzTXq47CM=;
 b=XLlU4rhF9oBAqSFsuZ0NfPLux+I1Oz+OKHIbHK3Xc4iuM6cnaHZAE3qb36kKvPGTBbq/mwy6xSW2Yh8EHi6oTLrAuGfv/a1y5UmQg3OPsVaPzVoWEyhc5yCQs+leIJUxqGsPm8aDZH/gAv17mWgsd1HBJIaA3D8EDIwT0omKRpo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB8318.namprd12.prod.outlook.com (2603:10b6:8:f6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Tue, 18 Mar
 2025 12:43:23 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 12:43:23 +0000
Message-ID: <91b5126e-4b3e-bcbf-eb0d-1670a12b5216@amd.com>
Date: Tue, 18 Mar 2025 07:43:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: SVM: Fix SNP AP destroy race with VMRUN
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
References: <6053e8eba1456e4c1bf667f38cc20a0ea05bc72c.1742232014.git.thomas.lendacky@amd.com>
 <48899db8-c506-b4d1-06cd-6ba9041437f7@amd.com> <Z9hbwkqwDKlyPsqv@google.com>
 <8c0ed363-9ecc-19b2-b8d7-5b77538bda50@amd.com>
In-Reply-To: <8c0ed363-9ecc-19b2-b8d7-5b77538bda50@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0175.namprd04.prod.outlook.com
 (2603:10b6:806:125::30) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB8318:EE_
X-MS-Office365-Filtering-Correlation-Id: 2be4275e-4ad3-4b4b-13b1-08dd661a7848
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QVkvQ1RwajJNZ0wzWjJtUk5UVlV3S3h3YjNob3FycXlyTTI0RmRzUzQ0OEI3?=
 =?utf-8?B?THVZSUo2cGNaRHVhWW96d2R3Ty9aZGptQnhxcUdGMDJIVTRucTdBQWJwWVgw?=
 =?utf-8?B?UG1DZk1xQW9CcjM4dURkQnlJZUdQK0ZNT2hycmxiemZHTkFVc2ZCcjRzMjJS?=
 =?utf-8?B?OEdWZTVXaVIxbGwzZzlNdXhVemZGYXFZWHRRaGdvaTNveDRZTjhFY2lNeWR2?=
 =?utf-8?B?QTNTMFdOVWM2NlY2U1gyUmNCa2t1d3BXREF3V3M3UExSNnJaZTBHTGU0V3pW?=
 =?utf-8?B?Mit5SGtKUFlJRml3SmlHU3lLTG1vSFJWaHpRbEd0aXZQSG1VcUFjcXR4WnZy?=
 =?utf-8?B?cGY3VFFtR1JZajRCTkI4eGduenBRdWwxRDdMbGxMTXdlNHRWaVQwNFVXYTll?=
 =?utf-8?B?RHFvMFMwbE52NU9nS0R4aDBJYjJUTGIvN04yb1dKUFlzQU9icXpqSjB5bUty?=
 =?utf-8?B?QXkyTjdrT3QvZWJNb3ZMSGZOY2JNVTdjZ2FORXBDZWZjeFRnL1NaNTZ4djZw?=
 =?utf-8?B?Yk5HSWdMSmxzUEEyOTNLbDBjeVJDS2hCYzBxMEhmUGgzMFdOVmNUaXBXQXVJ?=
 =?utf-8?B?ekM4U3d2eDRjOCtFTlRpVUV1ZTljdDJyUTBsTEVDc0laV0t2em96ZEQ4TkVN?=
 =?utf-8?B?aGFCai83b1RlWStsaGg4TGhMZm5CdGlkNFAraFQxa0VYL2JPbDYxcm1OTmxH?=
 =?utf-8?B?aFlYTXJLaGhxOUFCYmZ6N0ZJOW8zWDcyMllWRWZhbUJVOWpjSm5ZY01vK0w1?=
 =?utf-8?B?ZjhOb1djbmFocWYzbnVPT2xmUTZSaDE1Qk5KZzJCT1RqNTlvVmhnM1ZpR25h?=
 =?utf-8?B?UmhidFpXeFZVRUZRaUwrUW1IbC9HaCsrWkNOR21jazhVT2N0TkVrOE1MaGs2?=
 =?utf-8?B?QnVCTXYxMGV4MTZmRkxKallkVzFITm5QYjZ0dVVGbnlvdnZrT21KM1d0UWhn?=
 =?utf-8?B?SXM3RGdaQ3J2U0kwTGk5a3AzUG9KTjZlUzJmVnZIQlVwRzNYcndQYjVheUN4?=
 =?utf-8?B?ZlQvQlQ0MWQya1BwRDNrRFBtSnZZMzRZUDJGNjN5cHhSMnVkRnVNdDlSRCs1?=
 =?utf-8?B?UXU1ZzdjSEdoUU5udGtCRGtEekU4VzJWaFZSY2ZFTlk1d09ETmtUSWtTdk5C?=
 =?utf-8?B?ck9SYSt3K2swY0NrU3Zoc25KWld1eVdPcU5Pai9ZT3NxY2svaGhjVjVyYXIz?=
 =?utf-8?B?N1hHTTBEVzZKazExcXg5SFdzZ2RsRlhPdnkyU2NaViswbGZwN0xhWXN5WnVN?=
 =?utf-8?B?cVJpRWRmLzhiRlFBWThoWGlwOGdtbzk0aGxwN1V4bHM0eWV4blVldjduYmE2?=
 =?utf-8?B?ZmNpQlVZNjRPaGlsY2cveWxsQ3BFMDgzTUN1VnJ3ODB6MHNIVG9wOWZKcFJG?=
 =?utf-8?B?dXNab09Bc1lrMXdVUFl6MXlwR3pNVXRYcjFzUk1Odk85b1ZpNUJ6Z0dUNHlj?=
 =?utf-8?B?amFTaHo2QUkwcUhGOFdCbTlHaWJZRitkbU04UzdGNTY4V2VwTHYvQjdsOGdD?=
 =?utf-8?B?L0xnWGppK1VuMXJzMkZLZmpFdGw3RmF1M0pOSC9wVk1MbCsydDhNOFc1ejJI?=
 =?utf-8?B?MTZHUXgrZ0o2NGNBWDQ1ZWI0dTAxdy9DbU5NUktXQjZmSHk4ZGRTZ3piT3gy?=
 =?utf-8?B?QUM4ckNwNjl4ZXhOb212cUR0YUNTK1lzOEZ5WU5VTWcrUG9KMUxKd254OU5W?=
 =?utf-8?B?NWZnWGp1bXc5YlpoVmhld3JibXBNLys0VFQ1RXVyWW5WLzlnZTFud1VYUDQ5?=
 =?utf-8?B?RnVnOEd6cXhGcDV6S2pSZnJCWElxTDkxODVYKzhSeXFYYmRFeTNTUDNaWEd3?=
 =?utf-8?B?ckg5VVlZQUp3WWtYQUhjaGhSYmNEUmppR05PSkpiVk5nQ2NDcTc4QXFBSjF2?=
 =?utf-8?Q?AxanqiQ8fkvuW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TkxNT0xTdEdJbW5EaGpuNHFPWURpNmlzT0lhODN3VGFWYjh4eVdnS0c4WEkx?=
 =?utf-8?B?ZzUreEMxR2hVVmVaYVpRTU4rbjU4KzlSbG5RSnVmMHNGTW9xNm9oQk9aRlpQ?=
 =?utf-8?B?WUNlTFFjRCtMNzk4dzluY3dqMGMzUDF1ZmROOFgvRkxxaDJRb25zYjVYbW1q?=
 =?utf-8?B?SW5IVDc0UjVhVkZYT09SM0dTMjZNUDBxV2tOUjU4N2JGODNreGExRWl4Vm9I?=
 =?utf-8?B?Qm9yeEsxbGVTNS9HdmJLaEVoRzlZNDd5VzE2OXBmUHZhMVRVc2VOZndDNHdU?=
 =?utf-8?B?emxQSzJrNmhST242ZnNHa3c3QTRVYWx1Wm5SaFh1dDhmYWxIS1RsMjJUNWhm?=
 =?utf-8?B?NEhkK2VGVU96OGQ5c1A3LzRZS1JPNythWEtFMlR5Y2srbi9SY3d6STRoT3Uz?=
 =?utf-8?B?UTIwdUFtdjY0YkpUWm1Vb0M2NEhZM2txSFJwRjVGM0M5ZnJiNEZZRm85d24w?=
 =?utf-8?B?M29vS05veU1sNUZCVndzbWNxc0kyQWNkR2gyT2NuVVhJb25uUFdCU2pmeXhj?=
 =?utf-8?B?eWY1TEJ1UVVkSjNuMnQ0K1RZakVqcVFRcEh2Y1MyODdJTEErRHRNZ1hEemFQ?=
 =?utf-8?B?dE1tZzY0K2YraVBCSHFqc1AwSDliVm5CN3NXdXVQTm9JQU1uWnQ5bFNpTEpO?=
 =?utf-8?B?NkQveXU4QkZuYjlzamw5WjFwbi9FbG5LMFZZbFVhYTk4bysweFpmbnBnTzlz?=
 =?utf-8?B?ZFJwaW9tYzA0QjhGdFFVSEhUb3pHdUlKZWRJN2xQdXBqQm1MQW1QZTlRc1pl?=
 =?utf-8?B?c2JwSWJwUnhBVDJrUzd6cmdmTVQ1Rmp2ellXNzMvOE0wNnJYdzB3V1AyZjc4?=
 =?utf-8?B?TnNKZ2dwaVBvR3FEaVdxYkNQNzJjL1Zod1ZLRXM3K1BOeWt4ZS9iM3VGdmJk?=
 =?utf-8?B?d0drck5LaGluN3R2L1dSQ0xkTGZvSnFIZkJ0VFFxc1VWdUJIMkFqWUpvL0ZF?=
 =?utf-8?B?eU40TXNxVnFFN1F5Q0NVcTBQSkxmdVZFRnptQW44LzV6Z1MwYkxhbHlhNE5n?=
 =?utf-8?B?bmN1N25maTRsQzcwSTRWTXlYTWQzamY4U2NIMWoxWnU2ZnczRkU2bjJsdWlE?=
 =?utf-8?B?dE12NSt3bS9MMTBIY3ZoTzdjOW5pdlBEcU8vMlU2UHRoU29nSUgwMmRzVjhh?=
 =?utf-8?B?NkUwMGVXV05xbkcrZnZsaEZxYk1FZ1BOTnRGM1NOU0FYMDR3NXFaYjA2UU4y?=
 =?utf-8?B?ZW5nNGJGRG03RTBaaTQwaGZxWnNJQjNqQlNQeTlpck1KUGZDNkY4YWRZdEZr?=
 =?utf-8?B?MlRFQ25pdkZUdU9FSk1jZHdTUkxlZ3prZVB4ZFJMRGZOOHdWL1hqVHg4Y0JO?=
 =?utf-8?B?UjVuc1BYd2RyVTB1WldaOXJrY3ZQdlh5T0JndDVIbGxGT0g4SVBPMmQzYmV0?=
 =?utf-8?B?aEVPVCt2aFVDVU9GemN5SG1xbjRLSTV3NnA5bGRnbUd6ZncyL0habFlDWU9H?=
 =?utf-8?B?czhTdWs5UHh2RGh0eUpqNTVpQW5YWFdnUDdiTGZpdk15Zjk3dVpCUUFJYXZV?=
 =?utf-8?B?NW5pVE1mVzl6N2tzU2I4RHh6eXFwRjZRTWV6YnRHcFZnOHJtRG9HaENuSjND?=
 =?utf-8?B?Q2FJcEZpOHNpaWJHT0ZyZ3BtU3Yrak1TeDExNFFNL0E5TTJBZTJpYjJzZVdV?=
 =?utf-8?B?RzdGUUtmR09DZ292UFdBanNVQmN1OXJwNHZ6QUVpZHJzcFp0cGxLZ1BsM0Zi?=
 =?utf-8?B?U0dMbzhRZWEwMUN0cytMNVh1ckdNVGlObGMzN3BPR1k4UkRvRFpCbHhabGJs?=
 =?utf-8?B?WmhKaEVpbnVQZ05xNUcwQmsyQUM1M2dob3RJd2k4UE5Ya3RnOWlRVTgxNHds?=
 =?utf-8?B?aGI2QmlaRzlqUXh6d3ArVmFCOXdKSUtlcTRQSjdXajE2bHpQRmV6MGhWN0dW?=
 =?utf-8?B?QkdLcDl2aTMrSU5TT3QzNXVFOTlxZld1TTJySEJLaFRPTWJXVVdqQWVNcnFn?=
 =?utf-8?B?T0ZOSUJmTDJqa2xhWlZvbHBEZVF1UmU3eTVtNG5BdTd4aEl5ZGt2MERhU1Fs?=
 =?utf-8?B?RkdNWGd4ZWgraXpNRjRjRDZxUUdqaG5NYWswSU82dHlibEFCcklnRitKR3Jx?=
 =?utf-8?B?bUxoMk9SSVhGRGE2SkMreVZpQVlkVzNBRFpyUmJHUnA3eis0S1UzM0dLVCsy?=
 =?utf-8?Q?NnjYjlehs2OCFVSeFNPlrnZlA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2be4275e-4ad3-4b4b-13b1-08dd661a7848
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 12:43:23.1444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +A84Hk0+ZAZl/fuO1b1kt1NjRl8MLgAAJ1bM/Qaud3sOxtupIx7ZI02pd9q493Dx++f2hmZ0xXGHp7r1SsWz1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8318

On 3/17/25 12:36, Tom Lendacky wrote:
> On 3/17/25 12:28, Sean Christopherson wrote:
>> On Mon, Mar 17, 2025, Tom Lendacky wrote:
>>> On 3/17/25 12:20, Tom Lendacky wrote:
>>>> An AP destroy request for a target vCPU is typically followed by an
>>>> RMPADJUST to remove the VMSA attribute from the page currently being
>>>> used as the VMSA for the target vCPU. This can result in a vCPU that
>>>> is about to VMRUN to exit with #VMEXIT_INVALID.
>>>>
>>>> This usually does not happen as APs are typically sitting in HLT when
>>>> being destroyed and therefore the vCPU thread is not running at the time.
>>>> However, if HLT is allowed inside the VM, then the vCPU could be about to
>>>> VMRUN when the VMSA attribute is removed from the VMSA page, resulting in
>>>> a #VMEXIT_INVALID when the vCPU actually issues the VMRUN and causing the
>>>> guest to crash. An RMPADJUST against an in-use (already running) VMSA
>>>> results in a #NPF for the vCPU issuing the RMPADJUST, so the VMSA
>>>> attribute cannot be changed until the VMRUN for target vCPU exits. The
>>>> Qemu command line option '-overcommit cpu-pm=on' is an example of allowing
>>>> HLT inside the guest.
>>>>
>>>> Use kvm_test_request() to ensure that the target vCPU sees the AP destroy
>>>> request before returning to the initiating vCPU.
>>>>
>>>> Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
>>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>>
>>> Sean,
>>>
>>> If you're ok with this approach for the fix, this patch may need to be
>>> adjusted given your series around AP creation fixes, unless you want to
>>> put this as an early patch in your series. Let me know what you'd like
>>> to do.
>>
>> This is unsafe as it requires userspace to do KVM_RUN _and_ for the vCPU to get
>> far enough along to consume the request.
>>
>> Very off-the-cuff, but I assume KVM_REQ_UPDATE_PROTECTED_GUEST_STATE just needs
>> to be annotated with KVM_REQUEST_WAIT.
> 
> Ok, nice. I wasn't sure if KVM_REQUEST_WAIT would be appropriate here.
> This is much simpler. Let me test it out and resend if everything goes ok.

So that doesn't work. I can still get an occasional #VMEXIT_INVALID. Let
me try to track down what is happening with this approach...

Thanks,
Tom

> 
> Thanks,
> Tom
> 
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 04e6c5604bc3..67abfe97c600 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -124,7 +124,8 @@
>>         KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>>  #define KVM_REQ_HV_TLB_FLUSH \
>>         KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>> -#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE   KVM_ARCH_REQ(34)
>> +#define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE \
>> +       KVM_ARCH_REQ_FLAGS(34, KVM_REQUEST_WAIT)
>>  
>>  #define CR0_RESERVED_BITS                                               \
>>         (~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
>>
>>

