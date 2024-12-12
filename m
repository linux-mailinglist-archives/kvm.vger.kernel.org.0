Return-Path: <kvm+bounces-33548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 659079EDEA7
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 05:53:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A41481669B6
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 04:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB176187342;
	Thu, 12 Dec 2024 04:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="K0bi0Mtl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E7E17BEB7;
	Thu, 12 Dec 2024 04:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733979197; cv=fail; b=CXTeT+vK+fs1O+J03N48si2x3zC41+aCDBc/mZxPHGbKncIJpL1zZsW9zoFXUg7bIvOlHd0yWVevQFjb5BpwFPaInBMwpr/MVTGcPxaAln2lRy1SdUkK9LCvdfSjZhw8dnNJwU02mkHF+719ZOwl+SMMSG3pI6PL1EBmAATrOGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733979197; c=relaxed/simple;
	bh=5rLOGaKy2xVaASPWJTQ/FFIDZWXKqEaCfObYuK0qe+E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cmGCjZv3QRfjMxlnqwdTBS36ruA+mN0pP+nxdtgH6uBeFd2iWcZwQKOC3iSFUnBQIlBzrCCh4E+t3+akV5MJwvzOE2Ih7dBuJYKUocPA6H/WXgDXVz0IYZXcVLh1HO+PZ2bLokGNrGYNO+dTEBXB+tgcm24apjOZtLZUNB2G3zE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=K0bi0Mtl; arc=fail smtp.client-ip=40.107.93.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ceBDnN9+7a/3tVMlrTZZfdCDjrCqYPAq7iUJjkpkOP6An6U4Wb0Pj1M3SPzs8gFD3K/bPv87/0BokPs0NXyWPNjnDUuhFar99PSdG72nNHCc8B4g4NWDKILVTHNy2HBwZpQeSYBGWjewDGGkSzQWgAzflsQW6U5tpADgCKO8AiwHEDFbuP/Yr3EgYWWiQjIyad4f0A7735p7NXjQrv8Apnw5ak9ao946b8+W7VRtAH3HcGdwWCBeVEWjZzhPjcYVXWBIzphBcJDkZihxa+jbAbU1Dw4dYa8vqpf9xeh4eYS5IJCG0obbusdaSnMgqCyu33aZF9LKoX45jnoOiL7hEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pMzM0eOdFTdsakDlWcCYqi8ULwtoawQI+zbhvuyvhI4=;
 b=ai3CSj2DD0J+/0jkXIeR07IMnFoM+NpW8aAtqiq8DMMfAOUs5HdgIl7f1EXCDekRxkh/O8yfpe/n+RZV1LRmCqTBF6/mueRBJjTpvT/XGwGVwxnNhOqkOhAE7shGxXaQ406OntUjihOOa3l6vfS8oPywiKjWtTg9opuxmhrisBCqK+neL6W8vdaSqqI0u9S4alZvRAigjM8iGhP4p1skXcGXETRNvOdpZ2g9xKTKS5nNfAFFkv7piL/5sofhiY6QcSgGCNmGs1HF49zsbC4uvxOGsweZlmnQ9kRjZear2rw9vDgIOmuPyVi+iV8ehksRizZWKc7smThmuBkCLHgPYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pMzM0eOdFTdsakDlWcCYqi8ULwtoawQI+zbhvuyvhI4=;
 b=K0bi0Mtl9xnJrxG243W9GKFUcxZhgeSi/IbhPFaRCe1sIFZcsVubJEWYnZci+9MzSoRspD8tPYDEZN5SiCN6goALPmLLkQ67P+AD8AnTDhOtfLYztHCY+Q3MAFtTeKFEh4jTwZZjtnT0/oNSVoh++ArgrXJ5o62IdoYFOGbVoPk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by LV3PR12MB9439.namprd12.prod.outlook.com (2603:10b6:408:20e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.15; Thu, 12 Dec
 2024 04:53:12 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%3]) with mapi id 15.20.8251.015; Thu, 12 Dec 2024
 04:53:12 +0000
Message-ID: <ff7226fa-683f-467b-b777-8a091a83231e@amd.com>
Date: Thu, 12 Dec 2024 10:23:01 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR
 interception for Secure TSC enabled guests
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-7-nikunj@amd.com>
 <20241210121127.GBZ1gv74Q6IRtAS1pl@fat_crate.local>
 <b1d90372-ed95-41ce-976f-3f119735707c@amd.com>
 <20241210171858.GKZ1h4Apb2kWr6KAyL@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241210171858.GKZ1h4Apb2kWr6KAyL@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PEPF000001AB.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::11) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|LV3PR12MB9439:EE_
X-MS-Office365-Filtering-Correlation-Id: 8283494b-eb40-4a69-25d2-08dd1a68e161
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dEgrckhXdTZwT1NOUjd6UCt5ZnNiYUY0cnZIQ3hQNEU5K0JhUEgrWkNudW95?=
 =?utf-8?B?RjUxTjcycXFUamxUTllXQ2REZFozanhYUU9FdnU3aVFScUxib2VnNTBlQ0tX?=
 =?utf-8?B?ZHZSRkJvZ1lPUDFPdFNkR2xMVEk5Q3VuQ0Z6UmJFUG94Z29zNkpIcVhvNnV1?=
 =?utf-8?B?MzlIK2VDY0ZHT0VxRXNVdzNFZ3lhaFcxTGw4WlZaVlp6UjkyMTZGOUpvVlp3?=
 =?utf-8?B?NjJIcUF6bWhsQWN2eVVFM0NpNkFpck9uNE1wUWVSWDdVSS9RZkF6SnMvV3h1?=
 =?utf-8?B?M2IwSHhmc2pqc0ZCZXllUTVtYUIyN1FLK0dDb1VuTzFVVXZ4UHhjMzBFR2tr?=
 =?utf-8?B?VUszbWNzRmpHR3habFBzN2dmMm5XWHBLUUVJemhDRmJBNTcwdGp0VlNVQjBZ?=
 =?utf-8?B?OXJWWXlqNVJPSDVBd2R4T0cxTGNmR1pGTmUwV0orUm9KVURleU5OOW9tcUpT?=
 =?utf-8?B?STM5MnFhZUhsbnVWemt1c21JcTkzc2c3bXlqRFc5a1h3SUVKeGQ1NnR4YXA5?=
 =?utf-8?B?YzlyWmJQellWbDVubENYS2o3T0RQNWlyU3o3eHUxbEZ2UjZjVDZ0UDErVks0?=
 =?utf-8?B?dmo1cm1XOHJ0czJuT1crdUM5RWl3L2lTcnNnTVFrVWdJK2ZBMUhremQxZ1pk?=
 =?utf-8?B?UWxIYjNCWmJLN29sS1N2aDl4WWpXcFNnbXhaUzVLQURMS0NIYVVnUmtLc2xh?=
 =?utf-8?B?Y0poMXNNZmdLQjJ0ZWY0T25xT3F3UDdRY283OXNuaWNMM1N3YzlWblRWKzR3?=
 =?utf-8?B?dFUrMmVaV0U1L29lUm1xbkVDTUduTjh4UXpQOUxRcGs1WXlFMDJCcDdkV1JB?=
 =?utf-8?B?eUtmTCtaeEhCcUdFVW1NZTc4ZmlFM1JJSHJYaG1rV3pWbGtBaGVYY0VqSDVz?=
 =?utf-8?B?WFc4MGVXWFQwVWRHaGdwMVJMelBxWnByU1BIeHg4ME5xcGVPeXdxNjlVZjBG?=
 =?utf-8?B?ZlF6UnV3R3c2cEdsOU1ickxBLzJ1OHlSMlo1QWpucUxHSTJ1MFFlSjNVTEhZ?=
 =?utf-8?B?NUFZMnJwZzlSa2VqRUY1NVZ0cmIxNzB0b3NHLzFSUGs2elpPdUlqUDhUWWNj?=
 =?utf-8?B?NGNLNDZjb1I2eEM1Y1J5c3FUSEQ4aytlemFVTVdHb25jWHF5aUpPazc1ek5F?=
 =?utf-8?B?YUxMa3RWY2EveDJtVHdRamRzS1UyOUhodVVkdzB0UGkvRXZwZUxkY1JqRWRo?=
 =?utf-8?B?OE9uZHkycTZYakM5UXdlL1NRSlJTTXpGREZ0L0VMTzZtZHk0a2E0blc0Vitl?=
 =?utf-8?B?ZXVlRHo1Mm1qODkyTjdPV2xyR29sNkNua0dEbHg4Tlo5alY5L1NDYUp5WmZG?=
 =?utf-8?B?ZFZBdDJRbGVvWEJOMnFGQW45U2h4QytpS3JSenpmai9KeUlGUFJXeXFWL3RH?=
 =?utf-8?B?Zmk3bTh6MG5mbWpMOWFMMitDdUNHdzNreGNLOCtRYmlOSE0yWGpKSjIrRVFN?=
 =?utf-8?B?UnBrQ2h4a2xnS3ViUmtOdWdPb2NEbGs3eS9vWnY0UFRVUXZCN1liZ04veGZm?=
 =?utf-8?B?dmdhTVZyRm9kNm01cXZsSEdqdDlmWE53bHZrMWhxZGc4T1RIZ25jM2xGTjNG?=
 =?utf-8?B?amRsWXZkODNYcld3ZG1tcTVkb3BFQlJMRm9BMHFac3FhUXVLVTY0YmFjUWZ4?=
 =?utf-8?B?SzQ2TE1zQ1AzOHlWeERrTzNzejhvTmNYSzAzVFJPNldpTGVueXRPcU5EN1Fr?=
 =?utf-8?B?RlpxMlFZclpsQmcxNElpc2h3bTRMT3FsRHk0ZzlmU2tHcExIdjkvTit3dEU2?=
 =?utf-8?B?Qi9FQ3VPaTVsTWU4T1FoNjNJL3NXOGRYbVZ2RFAveGxTU0h2ekk0aHlpalQ3?=
 =?utf-8?B?Q3NDTE5WekV3UmJET3ZxUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y25Bek5aWHlhc01iaGtYa0RPdVFIcHJoMHI4dEd3bGMwcjFubzYvUzIwa0lp?=
 =?utf-8?B?alVqYkJrTWt6K1hxbHRneUhBeHYvdW1jYXFtbUFOYmJxSTdEbUs0T0pZdzVm?=
 =?utf-8?B?M3o4TmkwUTZCbm9KNmxrTE5Ed2tHVTNYMDlmY2ZiOVUxdnM0czNoWGU2ZTRI?=
 =?utf-8?B?ZVkwSy9QR2FmOXFEczFBdHVLRXRQTDZmTmtxcXp6QnBZMVd3S2hSUE03Lzc1?=
 =?utf-8?B?dDh3WGtmelA1d28vbUZsZG1qQ2M1U3J4MkZUM01wcFpyOGpEZ1RTUmxPUlpm?=
 =?utf-8?B?M1czbVk1K2xrdWhXalorTkxvQ2kyUHVSbE5JdENQQnJBQ2dScVJsbzArampZ?=
 =?utf-8?B?aWVZKzMyaWxqRmRGaHo2UGV0NEFEc3VSQ3F2bTY2NXk1Z3BBSlFMWkhWWVdR?=
 =?utf-8?B?VUpOamZ3Y3lQTkl2K3dYTWVka0FGMVdPekJONkZJeGsxMG9EeXlGNVA5bDhT?=
 =?utf-8?B?a1ozcU4yRE5wNllZQTFQQy9ta1pJSXV2ZEphTnZad2pkS1hNS2hoZWRGTWJz?=
 =?utf-8?B?c2hqUCtpeE5sQ1pkYlQ4UjR1TGF5dFJ1OHl4YU05US9zU0FLTDc3NjM3Nkp3?=
 =?utf-8?B?WlBtV3FzTmtLaENpci8wZ0VsMG01S1ZZbkYxdThyWmZ0bzZMMHRjZkc1ZWRm?=
 =?utf-8?B?bks1bWFFNGtYdGdBZTNWaHN5NEliSU9wRjkrVjdweTA3S3oycVJuRUEwRnJW?=
 =?utf-8?B?dk0zczQvc0YvTTduTHRWaU13SEJUVXQzOWU2aHE3cEE0MUJkdEtyaG4zV014?=
 =?utf-8?B?dVdEK0s2NTZhR0N5U295UTBzY3NPVksrVkoxc2RnaXF0RHJ5c0d5Sk02SmJQ?=
 =?utf-8?B?RmZZT0VhcWNpOVRWKzVyZWNlMEhscE1PZUZvNzV1MXpLMUFMOS9YYmVkSEll?=
 =?utf-8?B?azNTb1BXazFmeGh6Uml6TjlJbDlJckpKaDl4cVd3SjB2NHFjRnFIN2dhRHZN?=
 =?utf-8?B?Mm5HZGJDamUwcGh1WVdXbzIvWTZ6VXZrVUQwTXQ3SzBpUWxqazArenRiNEFl?=
 =?utf-8?B?MXV5QnIrcU5UU3ViMVZQclozK25IMjEyazIvR3gzSG1wWHZLV1FVRUE4MUpu?=
 =?utf-8?B?NjlSQnB2V0NvWCtxeWNaSExyeDIxaGNIMUZwVlJPVnFIUFhicXQxb2xFS01P?=
 =?utf-8?B?dFJGNDNoMjRWWEZLMWpKSGIybVNVYmg2elFWT1A3bithdFlJMUx0akZNaGdI?=
 =?utf-8?B?KzZ6M0JCbUxCNlRSU1lTSWxGZThCbjNMSzcyTkVKWDFoNEF2dzBpazRIWUpY?=
 =?utf-8?B?UC9yaERTQWVGR0hnR1BEK3ozVFZOVzZxOGdaV21wTUtZNzlCd1VidmNrUEwr?=
 =?utf-8?B?QzN1cldUZVlHdlQrMmlwdkNvK1NpRFV4WGU1RkRFMkFsSml3UW84K0E2VE9a?=
 =?utf-8?B?dDBqYmlWQi95bFJtR1kycXpFTGZPNkZpa3h0WDRpenhvdGw3Vmg1bHRzS1lj?=
 =?utf-8?B?eHhjQ0Y0cnJVTmY0eHZ2d2J5bHRUc3RNaG1NSnNBc2lqM3kxb0k3WmNISGVt?=
 =?utf-8?B?bmVkTkpqbU52TFNHRGdycjdrYU8zbUJObWt5SHlacFM5c2hUWVNjVHlBTWp1?=
 =?utf-8?B?NVQxaE9WZk5MaXRGUDVpaFVhNkFXdTNTbTNMR1lwRWdQMDNrNUdLRkZvMnNa?=
 =?utf-8?B?TWJNajl6OUVkV3BTVy9jMlVUcmRXM25QS0owMEF1Y2JzM3JXMCsvS2hMQ3ph?=
 =?utf-8?B?aVJtWjN6S1NNYnJlSE1hOEx1UGtuU29VNjdzMDhhS0k5T3RhQVpKbnBxeCta?=
 =?utf-8?B?VjlNTkxjdVZ2Yzc0NW9wbFVRMjZwdE5QbzJ1YmZLblNxemVZTnhpY2VNbXk2?=
 =?utf-8?B?RE9TeGdqOVg3N3pkU2ZNcE4rWHFpWkxTRTA0RkN3cnVLd1YwSm9aRjh5RnpK?=
 =?utf-8?B?NTQxVWU2bGZESmtaUnhqL1Y2MzZkb3F5RGljRzVSd2J4M1Qya0EwZ0dSVFJa?=
 =?utf-8?B?eE1KRCtabEZSQUd2dW1OaERyZUFCN3J5R0ljT014MVYwS2IzenkzQUZpeEJx?=
 =?utf-8?B?WXJCeXlLd0ZkT2JOcGd2aVpENWdVN2EwOG52d1FPelhrSk1obkVFSlpzNU5P?=
 =?utf-8?B?ZGkyMGFPZVQ2WkpMY1NJakNjVGVyeFhPN3BxN1hpbEhKeU1uZjV5MUpYQU9L?=
 =?utf-8?Q?RxrnZ3YqTLGN7J+tiRpFo0O7E?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8283494b-eb40-4a69-25d2-08dd1a68e161
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2024 04:53:12.5579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7JGfg9MCKfr84Y2GPm8DGeW4b3d9iND7EKs0+8CKzE/7HrUY2j15ayvCIPj2jtpfVYyQh3s1XajxevDY7Y2p9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9439



On 12/10/2024 10:48 PM, Borislav Petkov wrote:
> On Tue, Dec 10, 2024 at 10:43:05PM +0530, Nikunj A Dadhania wrote:
>> This is incorrect, for a non-Secure TSC guest, a read of intercepted 
>> MSR_AMD64_GUEST_TSC_FREQ will return value of rdtsc_ordered(). This is an invalid 
>> MSR when SecureTSC is not enabled.
> 
> So how would you change this diff to fix this?

How about the below change, this also keeps the behavior intact for non-Secure TSC guests (SEV-ES/SNP):

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 25a4c47f58c4..fa57adf5a2c6 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1448,15 +1448,18 @@ static enum es_result __vc_handle_msr_tsc(struct pt_regs *regs, bool write)
 {
 	u64 tsc;
 
-	if (!(sev_status & MSR_AMD64_SNP_SECURE_TSC))
-		goto read_tsc;
+	/*
+	 * GUEST_TSC_FREQ should not be intercepted when Secure TSC is
+	 * enabled. Terminate the SNP guest when the interception is enabled.
+	 */
+	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ)
+		return ES_VMM_ERROR;
 
 	if (write) {
 		WARN_ONCE(1, "TSC MSR writes are verboten!\n");
 		return ES_OK;
 	}
 
-read_tsc:
 	tsc = rdtsc_ordered();
 	regs->ax = lower_32_bits(tsc);
 	regs->dx = upper_32_bits(tsc);
@@ -1477,19 +1480,13 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	case MSR_SVSM_CAA:
 		return __vc_handle_msr_caa(regs, write);
 	case MSR_IA32_TSC:
-		return __vc_handle_msr_tsc(regs, write);
+	case MSR_AMD64_GUEST_TSC_FREQ:
+		if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+			return __vc_handle_msr_tsc(regs, write);
 	default:
 		break;
 	}
 
-	/*
-	 * GUEST_TSC_FREQ should not be intercepted when Secure TSC is
-	 * enabled. Terminate the SNP guest when the interception is enabled.
-	 */
-	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ && (sev_status & MSR_AMD64_SNP_SECURE_TSC))
-		return ES_VMM_ERROR;
-
-
 	ghcb_set_rcx(ghcb, regs->cx);
 	if (write) {
 		ghcb_set_rax(ghcb, regs->ax);
 
---

Regards
Nikunj

