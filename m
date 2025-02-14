Return-Path: <kvm+bounces-38138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B187FA35611
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 06:14:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 246233AD404
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 05:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 210D21891AA;
	Fri, 14 Feb 2025 05:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="abCSFRbs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5215E16DC28
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 05:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739510067; cv=fail; b=FnVd3f1h72THAb8NbjU4DHoMVidD8ET23ZDU9Azeg2hD9oCsU2vxDRLQXGdkgRoIA9R6KZz3zWbuVoc7ZcvBOqIZCO4t/O594OULC3VaoKuDs1OJ4uBpRK5tTJxLWJ8CsrlzLgYnth/lz2PIpVclf1IoPYlc5exuH9iFVbc+Sr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739510067; c=relaxed/simple;
	bh=LmbRTawLMBHtSvJdKd0axQQv+DeYXUmGMcL13F4j/4A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JdJ1B2Sgq58NJXHdTnnPtimWO6hh7TRbmM2ljOpgcJwoLPSnaMqjFtuaquiEQqWP3ZKd/iq9zwlN6ic6j39stwIFyj+VCeVNNQr+ld/3dzgjYe094dmF0eZo9wPtBy3qu5N2CG04jLWqWvFcomlzP6A49eJSwlHgy1pm3t+4mio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=abCSFRbs; arc=fail smtp.client-ip=40.107.243.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yia+iz5PR7lc6JBcDKcVnWWcDUINsQYtvE2kRLtAv4BENyJMKBaLVAqhtAH1S2z64UyL84QP5B6BumIuIccIcMIpPFOgUjekX2dT9I7AWqm2Q3rDU3hsRp53BzcSnjAkGnIybzxQAPv7WRnx96taPK+lxSXw5JLz/b/mFD+pFnDQcjcSV+HNxMyJkE4hlAYgkXb+SEFhoDcTQ6aZhuRfzSMz2KwpNPJtb5vmyevcVokM/edVN03UrPOiwM6NbDR5h9rEiFYRiO1p4xzlCdUaFzm4wZipk6+W9rZSgnmsQbgwfOf17qUPlQmL7HvM+C2mGJ+3ONlaajfU+8OT9bcCkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EQPfJ9wiuqRbu0RhhvXZ2cgbVeD5Pqeb4gsAtYdM8OI=;
 b=oF4y2RFlZ8ymzDpzY3Jni5VH5/jxGmhuPyv1bATRM9je9bMDtTh66KrQ4oxCkl6xCec5q+4PGj750hvsjyPfpRqy9yXkqrgxClXmRkNi7O/gjJcbxGdyt6gdYnsWRLBDcyzZ83fD6Y0nLJnZTbfRbqlnKU/lMMp5CF0lne/OCNwiS5JPWAMaTsqlaLY3bATL3BCu/SwDp0DyO6EbCaWGYNiO2o3KloEpJlsoxiWlPRQVq+LizRCUMBOQ9SvDNUmb7SxxgELOeiZSqMWvcZagmYvG0pPkslKbaGU5UO1giUKH7n3sNRCKthTHTm4MPwRvRzoHd2jIcjMwIGZGNXbKKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQPfJ9wiuqRbu0RhhvXZ2cgbVeD5Pqeb4gsAtYdM8OI=;
 b=abCSFRbsiEFLcGh4dKXD+kbkPnjlEn0vWjP0gFVJS7dMjTAA6ideUVAPoKw2Yz9Wkw67HNVgOn3MLzijZ2luWw3nTM96GdiAcAtc0Ozd3qzUcx8D2O1K0GIGaphoNElwqC/7J//79+dJ06TI9qwHGG1jMAPLRUDtIDvN65qqz0g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ1PR12MB6314.namprd12.prod.outlook.com (2603:10b6:a03:457::9)
 by SN7PR12MB7933.namprd12.prod.outlook.com (2603:10b6:806:342::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.11; Fri, 14 Feb
 2025 05:14:23 +0000
Received: from SJ1PR12MB6314.namprd12.prod.outlook.com
 ([fe80::e147:2125:585d:7bdc]) by SJ1PR12MB6314.namprd12.prod.outlook.com
 ([fe80::e147:2125:585d:7bdc%6]) with mapi id 15.20.8422.009; Fri, 14 Feb 2025
 05:14:22 +0000
Message-ID: <f1476003-5446-4527-8a78-ce0ad478331e@amd.com>
Date: Fri, 14 Feb 2025 10:44:14 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] KVM: SVM: Prevent writes to TSC MSR when Secure
 TSC is enabled
To: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, pbonzini@redhat.com,
 kvm@vger.kernel.org, santosh.shukla@amd.com, bp@alien8.de,
 ketanch@iitk.ac.in, isaku.yamahata@intel.com
References: <20250210092230.151034-1-nikunj@amd.com>
 <20250210092230.151034-4-nikunj@amd.com>
 <8ec1bef9-829d-4370-47f6-c94e794cc5d5@amd.com> <Z6vRHK72H66v7TRq@google.com>
 <858qqbtv6m.fsf@amd.com> <Z6yqeEQeLoTQx_QD@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <Z6yqeEQeLoTQx_QD@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::28) To SJ1PR12MB6314.namprd12.prod.outlook.com
 (2603:10b6:a03:457::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6314:EE_|SN7PR12MB7933:EE_
X-MS-Office365-Filtering-Correlation-Id: 35915f77-04c9-4aee-dc6d-08dd4cb67146
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VU1aYVNJMElOeDRnSlVRdGI1NFZwNFl3MEhRNFgrdEV1S0V3MHVDdXR2aHp1?=
 =?utf-8?B?ZmZFNk9wZWYvTkphejA1dmRCRGwrSlU3ZUptUnl2eWNJbWpHd28rM3lVYnl2?=
 =?utf-8?B?UkNJb0k3aGhEUFZCVERSRm9vQWJnMmFSQk91L0Z0TDF0cFRacWN3OVpRMkhG?=
 =?utf-8?B?UzM3Um85UzJpK3dCUVN1Y0hxWG9sT2xqdlU2WFJnbWJDRkFzM2tiK25ETjMr?=
 =?utf-8?B?OEhCOFNYL0JRR3FQYzZSTHp1dzZNdlY1Y2FGOHRobUdhanNhVUZTaWhwNy9l?=
 =?utf-8?B?TGVZdUJ2cmgvSGtlNjg4aTZFb2JUVExTVUZDc0x0am9uNUJlbm1WeVU1VFlI?=
 =?utf-8?B?aVZON3Y5czR6bFdtSWZ2R0dtYlVJMHlmajlHS0pqODM0OC83MVhtZDc1RUcx?=
 =?utf-8?B?Z09sS2NDOXlESG1BWmpZQ1dEOWxTd0gvbjJHOTNZR3Y1alVIOGZhYXh2SENz?=
 =?utf-8?B?VFZKV2pHSFVjbjI4ZUZFMEthb0U1NkJTUllNbW9QSXNFNzNqTDZ0MjBVMGhq?=
 =?utf-8?B?MkEvNXpvR3dsRGpzUjQ2UzNhUG9jTjBjcFhCZmQwejhLT21DSHoxQ0l6LzBI?=
 =?utf-8?B?UjdlMTFZUnh6MDNlUzFrakpPUy92aW04QzB6V0o1RnR3TlI3TmlpRzJSQVJQ?=
 =?utf-8?B?VDRQRXBsVENqcUt5NC9ydlVyUDdpdnFxb1J4eTI1bENlM1pGSVozWTRjcHJh?=
 =?utf-8?B?VFJwcGtxM1FMZVVTWU41K0JCL1NBeEJFVTB3anpWSm9iemFST29IR3lDRnJN?=
 =?utf-8?B?U3N2eXAzdHM0Rkx3ZDB2WnZjUWVJUkw2Y0lYejFkUXQxRnlDM2hOZG85TFBW?=
 =?utf-8?B?Vjl0aTJ6MUR1T3FBeTd2UjhVeFk5WmJIZkNQM3J0ZWJ5cEc3eFZUdjdOdDg0?=
 =?utf-8?B?NzA3NVZiMHhKYTgvdXordkh4SHdqYkJjSURpZ0pNaHpOVEg1eW4xWWZROHlZ?=
 =?utf-8?B?YnNyaW5LZ1M3RFpsUUR0WmhlQTJZcVRMOEpBYklEV3dmZ01OSWhzOGZzeG9W?=
 =?utf-8?B?amNzeGpTbmsxQ245QzFzTDRpS3lHeUhMUmZyMFJsMlQyN2NIWHhEayttV0pN?=
 =?utf-8?B?V2F1RmJxaTBtV3VaZHZRKzF0cEg5NnZwWXArei9YWWlwRnFoTWtkYXdyd2ZM?=
 =?utf-8?B?S0dyS1liN0huTk8zNVNPWitpSXBURE1vcW1jb0czTkZtZXU1ZnB1OS9DbXBz?=
 =?utf-8?B?TzZtbVV5dU5mV0hOSVNWcUh1c2YybXhmcTRvdENhSVMwRm9KckhLeW9NVzcy?=
 =?utf-8?B?SEJEY2hJdHMzY2JqNlpHYjI5QVpjOU9uU2FtejBSSWFtU3NwMC9rOHJRVzNV?=
 =?utf-8?B?c1QxNmhYM0g0SEhFQ2Z4SlgrOE1MVy9wSHcvSWM0V282bVpndFlwK3ZYNE82?=
 =?utf-8?B?T242ZGQ1YXVvalNoNERtZmMzZHRmSE1VVTY3dHl4UjZmanpGVUV4K1Fjcnl3?=
 =?utf-8?B?YWFhbCtXTUhRSG5yWGc2eEdkYy9JZVVJRjAxcnk5MEtmZUpMQ2ZhVWkyRVFN?=
 =?utf-8?B?bGYzR2RBM1VzUE5QT0N5VlBpSlNQRWR6dlhWODlDRHh3aE1GSSt5TjFrOGRZ?=
 =?utf-8?B?d3BQTFllR2l3S1hlYm4vRTM1aU1QNXlNV3V0eStJNnZ0QVJoWGMyazM1Ujlx?=
 =?utf-8?B?eExHVGQ5MC9Vd0Zlc0ZrVXR1SXp5bjhoekRFQkROVE1sYXZLeGREem9jNDQw?=
 =?utf-8?B?T2wxY2hrcnNGb3pWOVNHQ0M0WXRHUEN1K1l5N29ZR25RTDlGNE5UQ3ZmMkN4?=
 =?utf-8?B?RUdpU0tCTXBCTkw5eU1wUXBRN0N6ODFidVlUdktIdFB1QVZWTEpVUVlqSmRp?=
 =?utf-8?B?eUpsY040MS9FM01xbjU3bFVGc0VoTlFrSXU1ZFFvVjNiNndEZWR3UDdmU3M3?=
 =?utf-8?Q?z36KRwZWaxlcp?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6314.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V1k2YUZ2NUY3Q1B6cVJyRjN3RXZ0bDF1dWhtYTlUZXhTbzU5dEFPWVFETnli?=
 =?utf-8?B?MmU5QmhGdm8xVGs3UWFPZXMvR2dGbUZnZzljWVpxbkZUVzcyRDJnR1ZZMmxl?=
 =?utf-8?B?RHZYUE1kbjNPamMzd1dLWi9TYUFnMTd3TFB4ckQ3Y2liZG1yZXpTWmN4QkVp?=
 =?utf-8?B?NHJiVVlLbHZoL01Jbi9TTFlEU1k3a1JJbTROOVZHbTZHNzgvNzJ2SHM3MTlm?=
 =?utf-8?B?Qit2V2NGckZJekhEYTdkMU9zMjJqeW5UMmdESlNISVZXSjBuelp3RG9MUUVw?=
 =?utf-8?B?eS83YVN5dERkeXV5eVdGa3NJSy9oeVdxdTJPVFZSZlllNm1JUUtYcW9HdnJn?=
 =?utf-8?B?M3d5bHl0V000WHRpaU5xcE9RdVJmUHUrU09EZ2F3MzY5QUM4UFVBd25PNjVY?=
 =?utf-8?B?Yllvdmdoc3VSMDZXeFZCdU5tNCtDZDI5Vlp6SDNwMnUrZlc3VTRLZ29BWms4?=
 =?utf-8?B?Z1dRV2ZoSG41UHdXSEtybjYvNlgvR0FHR1FYekdIVXk2dmhJVTRyOXdjc3hO?=
 =?utf-8?B?OWw5dmVPaU1vSUFCdWtaQ1BIdHJGbjNWdzlmMlRBL3J2MHErNTJ2Um50UW8y?=
 =?utf-8?B?Q3VoRFdvd3htcVA0dG4zU2VVMlZEbkZRT2hhVnI3Y3JyRy8xZkhydklHNjNV?=
 =?utf-8?B?bUJXZXFKeCtkajV1Qnh1L3FyS25sUUxaREpIRWxEVzJNZFdjMitIS050WUsx?=
 =?utf-8?B?VnhQYmxJRktjUE4zT09hbkRseEVmTXI3SmFkRDhnamd3Zi96cFpEc0tvRUFP?=
 =?utf-8?B?SnppWXFMQ2ZQNS9zaUhBcDY5ZjlGQStDcGFCSWxpL1U3QlhWUklNWkYyR0U3?=
 =?utf-8?B?M2NBSTdIRS8rVjVmTUQ0OUo4THV2Q3ppTllVeGhFYXF1QU1vOG9LVWowV0lv?=
 =?utf-8?B?NkgwbVdycHlML2lEcWlGZFl6MFBZR3FuSG9BdVVQOUFDeG5yaXNtTEZEbEd0?=
 =?utf-8?B?NXN6YjcyaVJDNnVWSXVraUhQTmhjS3F1WXRrMXNXOFFUenJ2OHJyQWc0dTA0?=
 =?utf-8?B?UUtsRDZ1TEVTM2xJaUtNbGdDb1J3NklKQjkyZXhyY0pzMlR6WldIcFNHZnl0?=
 =?utf-8?B?N2ZSZUJiLzQwMytzWlhiVWdmcGh6YzFXTUdCN0lzRGtxbk50QWNVM1V3WmRB?=
 =?utf-8?B?NXdtQWcra203TEtJR1pSckxVSHNBRUNtdVllT2N4WUpvZFJ2MjVud2ZPN3RZ?=
 =?utf-8?B?SzJqSEFZdWFRcGpIQUtBQmwwSmM2VlhxTVhKRHc0WFJXSzRVZUhSb291MU9Q?=
 =?utf-8?B?bmxwZzVFNzBMcmpoYUNkQk9KaTJ4aDZBK0JSaUN0YmcyS0RNVXh2L2ZncTAx?=
 =?utf-8?B?bllUTk52dENJNGdHSHRudC9yWlU4bGJHd0NtNFNwRHUvMlpFSU8vV2JhU3g1?=
 =?utf-8?B?SWFucXdTNG5NNU0rbXQwK3g1Mk1SVWh3dHd5SGdHRDZ1Mlk2MjVRYWEzRDFE?=
 =?utf-8?B?RlVTcHpPZlJlSGpBaVB3V2hxL3FtTjZNOHk0cnRXcSs4M1VkTWMyS3YwSjRP?=
 =?utf-8?B?eC9TVXNOdlFXRVR3N2xPazdCZWlrVzRBS2Ivb2IyZVBCRDFTQWhYUnhWQk45?=
 =?utf-8?B?cGx4NUwrM29adWJSbmNCWkY5YlROVHZtbXVFZjh1YmdaeFlqdW9tcXpOUlVj?=
 =?utf-8?B?YUdMM0N3REJJeTdzYWNab296b2pqS2FTV1NNRmdobjU0cU9pZkg4TTNkVTh4?=
 =?utf-8?B?WStPL2hIRVFqZ2xpM1FBbzB0cTYxazhqaWMyQnVla2hQQUFvLzJGRHFjZ2hk?=
 =?utf-8?B?U0d1THZnWXdZbEZrbFNUNzBxajc0YVAyV05mM0o0SnU4VnhGcmFBQWZnOG9L?=
 =?utf-8?B?MldhRSsvZEpMOGh5M2dZeUlRVXI0MDVobVo1aXdSZ0ROY2VIMjhxN0dIbFhp?=
 =?utf-8?B?a202VU91cDVqdFAzeHd0QUFnTGFlYTJhUEJobFZvV1RyV1ltN0hqTG9xVWRy?=
 =?utf-8?B?cDRtR2ZxUUExMWQ1dVNqb0JMcWJEblNUNVU3eU9vUE15SGFHWDRUazdXcWNs?=
 =?utf-8?B?TThtUWltdzZWb0RRdWZtNnM4dXlxSy9jNVdLL0NKd25JTnZaK3R3Q3VOaUNQ?=
 =?utf-8?B?UzVuT1NKWWpWcWRBVWdIRVBZRkFlc0xFbHRJV0Y2NUJuT3B1WlFMYVkzNFFv?=
 =?utf-8?Q?nlRKhSqGWYlO2DEZHJ9iTmD1l?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35915f77-04c9-4aee-dc6d-08dd4cb67146
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6314.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 05:14:22.8439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6n5+6rlAN5S5tFJPBZ+kYhdSpiLVOlXUkyagZVPE5JqSV2GqkWPTy1/uLRntiRWYIZphVfbNCRwUqOaHopR1wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7933



On 2/12/2025 7:34 PM, Sean Christopherson wrote:
> On Wed, Feb 12, 2025, Nikunj A Dadhania wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>>     Secure TSC enabled guests, as these writes are not expected to reach the
>>     hypervisor. Log the error and return #GP to the guest.
> 
> Again, none of this ever says what actually happens if KVM tries to emulate a
> write to MSR_IA32_TSC.  Based on what the APM says, the TSC fields in the control
> area are ignored.  _That's_ what's relevant.
> >   The TSC value is first scaled with the GUEST_TSC_SCALE value from the VMSA and
>   then is added to the VMSA GUEST_TSC_OFFSET value. The P0 frequency, TSC_RATIO
>   (C001_0104h) and TSC_OFFSET (VMCB offset 50h) values are not used in the calculation.

Sure, I will update the commit.

Thanks,
Nikunj



