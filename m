Return-Path: <kvm+bounces-55514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEEB7B320C9
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 18:52:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EA0FAE4BD2
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 16:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C96B3126B9;
	Fri, 22 Aug 2025 16:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UDHCK4Sa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26B92367DF;
	Fri, 22 Aug 2025 16:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755881327; cv=fail; b=hAUFX7JzlDsWI53MK2yF6AGDhELJNJ+n+++fIu/u8IcSzMnaCgiofOO+AFgvIDu+rBzWe483S+3SRTvGsY8nY4Nql4c2raxPGm0lkRajK04E3Txx7jVeanh93AR5ufkVksKu7HQLWCNgPBpXw3cKTw3nLfnT5Fle5QxMTIVUm9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755881327; c=relaxed/simple;
	bh=Aa7dYJ/O4mk88AQjUU5lyQKvvDUMsXLMYWyb7udB+6Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RMswDYbQFOSmS8Vgar0UILGXBBihFanjCILdA5uJGyxFS2zqTR/rCc64hmAU1C3RLDrRu352Uu5w0dCtrBypVW0L/EsLYQ5R9n7QcO/ccvLE+PewPrFZDpg1ybEXIjfv2QeMKr8jkKf8MtT7qzfhxjDSeezGRHkk8FG+FA2nb50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UDHCK4Sa; arc=fail smtp.client-ip=40.107.94.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=djopB6avZCSTZyySd0sE+MfRQFjeM8E+D3LdfU56KaYc851Xdo7NZduYFvw9w3xIHhfb8b832yybvTfgM16scjAIBkxFqE2qS8MhWw9ajircR7bHlpapXKOVrc3I6qgSApY2Aa0o7JiGJHklMWCIwyOl2tt6TyVCY8epb83Bk9L5hZwRbyq3Ux5tBIdIqr7Ff00pNWuFLFjePZtT6HOXSAzq1XQfc2GLhel5B1CXpGWYUxhrlf5rK1xj8Jj0OCAZv9DUqapsMBrNeXhZSJip+cw3luW3jQO1VopUTBBPU8/1FdUf6m0IIiJEjJ2W9+tpT+/ukGbYaHmf8UxelLC+xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fhvoxnv+WL8nWtz1PovFHGs11d07OUmXaOdxmJWqrXQ=;
 b=o2IqwtfuzksiR7FKPWj4a8q98VFqvAZb5kxiIN0IUTC94AoCjIenE0tX72pReFrqmJ973rePxhdxnAAwKq9Sphix3LaBM0x0TSggMRyB/72jwI+nFOwTGS6YDPNow32tXlb6ywXURM0pjcwjBHlZqaAU10cOrn+H5kObOsk1eHlooebGRv2pC2A7nbZxfzBKUnTVWGTTIhHQnSlOZmdD+w4VLS5DF3/bb+YfcJxi9Jir8o/pu6dj9R/qhHzH5uqnfo85ymBgSoJyXaysRw7nVtCADAhMT8lp01bhCWVLVh2sZL6OdJx01WHvKssAAWLo/Hx0Vw8wGwrdf7xFIeQvcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fhvoxnv+WL8nWtz1PovFHGs11d07OUmXaOdxmJWqrXQ=;
 b=UDHCK4SaQWn/TMBf21zrnAp5XSMHDPSrNXdvz11royeNPNXzvloivhKYSoDPcXs1qN6PgNSOMWQC/zHFmV3NKNfAFoErfTx/KkhwTg1r5hALFZoNPcdBZk20AJ/0y4eVoR8Kwod/53w+GrJ3hTyOul0e+GN6Y7L3lp9wXoHGpGA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by SN7PR12MB8145.namprd12.prod.outlook.com (2603:10b6:806:350::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Fri, 22 Aug
 2025 16:48:43 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%5]) with mapi id 15.20.9031.024; Fri, 22 Aug 2025
 16:48:43 +0000
Message-ID: <3eae371b-929b-4615-a8f2-cb89281fb175@amd.com>
Date: Fri, 22 Aug 2025 11:48:40 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/4] crypto: ccp: Skip SEV and SNP INIT for kdump boot
To: Ashish Kalra <Ashish.Kalra@amd.com>, joro@8bytes.org,
 suravee.suthikulpanit@amd.com, Sairaj.ArunKodilkar@amd.com,
 Vasant.Hegde@amd.com, herbert@gondor.apana.org.au
Cc: seanjc@google.com, pbonzini@redhat.com, will@kernel.org,
 robin.murphy@arm.com, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1753911773.git.ashish.kalra@amd.com>
 <71e80dca138ed59bd2a948d7b79c01c30515d789.1753911773.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <71e80dca138ed59bd2a948d7b79c01c30515d789.1753911773.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:5:40::49) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|SN7PR12MB8145:EE_
X-MS-Office365-Filtering-Correlation-Id: 60fca6ab-5d1f-4db1-8986-08dde19bc140
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V1Rpa1ZjVG5FVGJFRmdiLzRrUW9YYklDL1ZKUU1mUmxRNVhNK3BESEFtdkVs?=
 =?utf-8?B?cHAzMCtQbVBRNXNwWGVNMUJsN3ZYWkkrS1NoSmk3c1dOZm1TN2N1NGs4bXYr?=
 =?utf-8?B?ek5LeFBpRDdFWER4M2poM0ladXlESGQxRlYvVkhXQmkxMUZBd3RaK0ZNV3cv?=
 =?utf-8?B?SnR5UzMyNm5iNUhmZWhsTDJMV090ZWlsZ05zLys0RnVsb0I0OHlIUmhuYTRo?=
 =?utf-8?B?NWlQekZEN09ZRXRjZzUyek1TNzhua1pxSjlpUXc3bmNUbWUwUUcxcEY4di9E?=
 =?utf-8?B?bFVsZFBrVDJOVVpMemJNMVlSblVhV1B1ZWdwRjhHbXZkNjFpNy80QkJGb2lt?=
 =?utf-8?B?MUxGVGFsL0RCQ252d3RYUjRSTi9KdmhHeGFzUWdpVElibmRzMFFRYXFNbUxm?=
 =?utf-8?B?aCtVcXBlK3JnSG95dzduMlN3bTVENVNuR1pjL1dpeXBHanJQQlRrMlkrQXF6?=
 =?utf-8?B?UGJMQTloNDRXUjFORkwrWGo1Y3JrSHZ3dk1UZFFEblEwU2JBOHBNRjhNSDYw?=
 =?utf-8?B?TUxUVVhUMVU4TTB4QlBBS1FvbUZRZmk1cnI0dlp1cFozcUszNVlaaDlsV2NW?=
 =?utf-8?B?ME9RbENTeWl3ZGt2UUZOZ1Z1MVRUQ2RITitwajRyd1QyQ2h1V0Jnb2txYms3?=
 =?utf-8?B?V0ZQWmRGd1VtaHZZSG9HSHVwdzl0ZGsydk9tVm5BRU5yOEQxcXFHeTgxSnRF?=
 =?utf-8?B?bXRxVHgwYlN3MVExUVBLZTVLMnk3UGlWcU5IemZiYTVxWVlIWVNxcCtIeGhl?=
 =?utf-8?B?aU1jLy9IVm1HeDJGM1dadUl6VDNFUW5XZ0N0Z21FR0dyaDFtWVIvTXJ6Y1U1?=
 =?utf-8?B?ci9YNi83L25XQy9YSkE2aC9ZMUYwN3R2WDlJMm9tVzhGZkY0Uy9GT3BrZWNR?=
 =?utf-8?B?NG05SHAzbk9DeXRsdDRuMGJtMTlFRGo0K1V6RDBoRUdGVm5nVXcwQUdndW1Q?=
 =?utf-8?B?QXQwVXgrQnR3Q2dxQWZIMHRZQm5xanpZNjA1ZzJUY291THA2YXE1dnFSU2pX?=
 =?utf-8?B?RzFqd0thWHVLUXJBLzRIZVFNeS96Znh6VzB0b1J4SHdpdDl2c0xUSmltc3kz?=
 =?utf-8?B?SDZrazhvRHdDMG83NzFBRFJKblR3d1NhS09JbEVLWDBrVXZubjlSb3pBZlRo?=
 =?utf-8?B?SUxZTUtwR2V4V0lCZm9EZGJxYjBBWTExckx6a3Y3UC84QTVFMDYxQ255WGpY?=
 =?utf-8?B?Qjlnb0tQSkYwUGdwM0lzSzI5ZHd4eEJlZHROVzkrSGdOOUROd2M0clcyTGNY?=
 =?utf-8?B?YTYra0tydmZsNkVYMzB6SFcxSzJGaTZUaWd4R05RY3h0c1FQUmRWZkl2Rmh6?=
 =?utf-8?B?c2plT3Y0YVVDMFFUTHNXTXBKRFFEWER4YXFMVURRUlA4QWZ6RHljVTI4VWpt?=
 =?utf-8?B?U3RWVWVKMDgyTjNHR3BpWGRzUkE3QTE1UWdMMStjSDM4TTNIdlFHZS94cGVK?=
 =?utf-8?B?NUgxMytvdEg2dUlQK0tOYXFCYkt6WncvZEhRMXowRk1xZGowekJ2N2J1SnRZ?=
 =?utf-8?B?QVAydjdYejBHRVc4cWZrYjhQT0NHZEZsZ3hTR3FrV2xlYjJ0M3hXYUlmK2ls?=
 =?utf-8?B?dDAwbzlHdzRWVFlJTGdDTmpwd0IxV1ZMUGZ6Q295YUtSS3ZsUFNKL1ArTC9m?=
 =?utf-8?B?RGJ6enN2b2dTbW1IVGI0MkFJUlFpL2hoa2FSK0Z3eXI2dWZXbThPQ1RvcGYw?=
 =?utf-8?B?azB3bmhYY2V2RnpjblkwOE9CNkdIeXdTL3N4RVRGWUp3Yk9oZFFhSmFsYy9w?=
 =?utf-8?B?UG9TMndmNW9jSE1OOFFodC9nYXVCb1BnWGRxNGpNRzNnQ0dVTW40TXNnazB3?=
 =?utf-8?B?cGE5aDRGSUdLTDk0YXFwY3ZKaWVGVndLMXVWczgvQUNjQ1FGalp2VmkzeHZU?=
 =?utf-8?B?RHhCVjZZMFY2OFQvZkhPUU5UQW5FRE1PcnVsNnZ4REdZRXBUa0pRVTBQL3FM?=
 =?utf-8?Q?lmUz55RmDrg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MFBBOE5oQ01TeHlvMjlpT05CV2t6RUtZZ1Y3UWV2Vi93TEs1OGhVV214MnBQ?=
 =?utf-8?B?bmVRa01xOVlxbmkvTGRkUFpCQmdFU2xtbnhFNDVWbENET0I3M3QwSmtWMU9Y?=
 =?utf-8?B?c3lJMlc5OU9TejlWbXlmU1NSN24xYnFBWnlyUGJCVmJxRHJiUEd4Qlk4bVRu?=
 =?utf-8?B?QkNuZ0dhRzBGcTkxa3E2cUIvQUI1QUUvOUZhbjc2dk1iYWpMcHVHV2NOc05z?=
 =?utf-8?B?UlZ2WnAwSVJueitwNGdnV29aYzRmTnRBbVlHWSsxZjlhQjdWcWFJVmNwWHFw?=
 =?utf-8?B?UW1scXd4ZEY4d0JlVTQ5MGpEdURPdUtuank1L2NEVG5icVpNeEhUajQ0MldQ?=
 =?utf-8?B?amU5bTFsYy81ZHBObzcxVXFDV21SZTJISFBPZExlb2o0LzhPbkZ4NWZ2TGpi?=
 =?utf-8?B?MUh6empldWJVanorL280enFxVk9ENWg3b2JLNG42WXRZN3F1S0RrWUxOSEQ2?=
 =?utf-8?B?RUlEZEo5blpQZjdXdnllbmtXbzV5eTF3WWVsUHNQMml3TkVZTGVpVUk1dVlN?=
 =?utf-8?B?Rkd0c01vZDNTTXNDem9QWEZVVCtjeCtDaG1vSzd4TTY0L0J3dmJZNGxXUGpp?=
 =?utf-8?B?WTlIaGN0UFIxZlNoaWJtY1VmaVp5dVlnc1EraEUrSTFKTk9GbmlabkE3Z0xw?=
 =?utf-8?B?Y0cxV2p4cFFBZVJtUGVHY1JlZ3VYRkw2K0tCNi9xY1RVU0paa2sxb0pqVCtj?=
 =?utf-8?B?Sm00dGRDK0o0T1dUQ1J5TjlFcGNuWVp6RGJtQlBocVBKWnU1bk5waUhWWmZU?=
 =?utf-8?B?VnhsQlRWU1hvWFhxNWpMZS8venR0SUZld09UZFdwU1M1OEdxcGJiakFFZVE2?=
 =?utf-8?B?T0MxTzc5U2Y4VVkrcDBFZUU1SmtJVDFLVXkxRitRaXFyREJZeENrUW9sdGlE?=
 =?utf-8?B?ZkRnU2pZRjk1SzNFZDlaMk03WDdZd2hJSlljYm1IczdobjlnWUNMT0dTUW1U?=
 =?utf-8?B?cTNTdVNlV2htRnN5U3htUnBPM05mTDNJV1hrMjZKYUgvKzVWQWFHVVBNam83?=
 =?utf-8?B?SHZ6eFoxdjFCa1hVRmE5SUVwRzFEbElERy9Rc3FzbjJNaVRFN002NlJVaVd5?=
 =?utf-8?B?K0Frbk0xNTBlVEdrbkY3blVlREY5SWY0M2pvakh2ZmtpNVdSNFVDUnN2Q3Vx?=
 =?utf-8?B?aERpN0NtWkZyb2dKeWNMYnVyem1seTJrOVhqR3dwUHowTmFlZWdrK0NhL25m?=
 =?utf-8?B?a3J6TXBzZG13dm5xYVRPZWZlM3pSWkNCVjJMWTgrdFBTbW5mZVJtVENlN21Q?=
 =?utf-8?B?OWtHbDJFYkdyd1BhanJRMGI1YitreVdFOTZBbTQ0SjNabUNmblVPdzBEelht?=
 =?utf-8?B?L0Q2UVNvS2NIQzZ3QkoxUEZReTBNS05oM09tcnRoMGh6aFNINms0R3VSMlJo?=
 =?utf-8?B?bjdDdzQvN2hQeHg1aS9PSDc5M2poM2xpTFdsY0FuQlJaQmVGQm9ROHZmaWhH?=
 =?utf-8?B?d3NieTdwSmxlbVVFemd2Mm9nYlkxSDZBTFdYZW1WSjFvaUtuSElLN3I0MnNH?=
 =?utf-8?B?eS9QckxZSDMwcHM1clNBR1VzaXRkK3MrSDRWVkp2eFhzMlZralZFUWNUVnBH?=
 =?utf-8?B?NFh1aTZWNzR5dS85Q3kyT1R0OTcxa3h6dTlzWU14MnYvOEVFTFFSOW5xcHYx?=
 =?utf-8?B?OXphcmRBdzVENzBWZzJ0RVhtYmJFWTdCTi84bUR5M0p6REZadlBYRnV6SjlO?=
 =?utf-8?B?MGVaRlBTYk9EWHFFblpENHd6Y2MrV05xaWZQcHJ1MWd6dW4rMG5MajJVaC8x?=
 =?utf-8?B?U1l6aTkyTUt4TDBDdCswcVBsTk1qYnJCRWZzYWxpQ2ZvKzVuaGpQRDJOSVI0?=
 =?utf-8?B?cU9kMmhwSDcrMUt4dXVhMW5RRWpEVnBIRlhtYnpEVFRvWExPYnBqOW9aSTVC?=
 =?utf-8?B?dGxVeVdBbkM1eVRQc0NaTWNpOVRIRW1IUmZjUEltOGhjMHVzQXFyT0JVVUsw?=
 =?utf-8?B?OFp6emd2TFc2eHhKeEJLSTY4Tng0NzJkaXFvNmtOcGVGTDZqNHhJMkphSjA5?=
 =?utf-8?B?aDNhL2wrU1lDUHFDdzUrakI5MkpZTUFmRno1WDRrbEZUVHdQUk5UMzRSQ3pv?=
 =?utf-8?B?QjVuR25CU3JmNlFXS3JkVDRPZEdIMXB3azlidXJxRHh3VFYwM2NXZXh1SHNZ?=
 =?utf-8?Q?7CDA4zhH5JRmDKRLuEQqlcysJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60fca6ab-5d1f-4db1-8986-08dde19bc140
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 16:48:43.6447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oMsx0+MpJu4db+zuMboockzI03UOKDwDzgMyWO2iS1w9KUd+UGFQFg5P8mW2CJcNGDwE2TKuu2DJOkjmHCPLdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8145

On 7/30/25 16:56, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> If SNP is enabled and initialized in the previous kernel then SNP is
> already initialized for kdump boot and attempting SNP INIT again

s/for/during/

s/SNP INIT/to initialize SNP/

> during kdump boot causes SNP INIT failure and eventually leads to

s/during kdump boot/in the kdump kernel/
s/causes SNP INIT failure/results in an SNP initialization failure/
s/ and eventually/. This leads to/

> IOMMU failures.

s/IOMMU failures/IOMMU initialization failure/

> 
> For SEV avoid SEV INIT failure warnings during kdump boot if SEV
> is enabled and initialized in the previous kernel.
> 
> Skip SNP and SEV INIT if doing kdump boot.

These last two paragraphs seem disjointed. Make a single paragraph that
combines the sentences and says why you're doing what you're doing, e.g.:

Since SEV guests will not be run under a kdump kernel, there is no reason
to attempt initialization of SEV or SNP. This can prevent initialization
errors that leads to IOMMU initialization failure if SEV or SNP were
previously initialized.

Massage as needed.

> 
> Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index e058ba027792..c204831ca4a6 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -28,6 +28,7 @@
>  #include <linux/fs_struct.h>
>  #include <linux/psp.h>
>  #include <linux/amd-iommu.h>
> +#include <linux/crash_dump.h>
>  
>  #include <asm/smp.h>
>  #include <asm/cacheflush.h>
> @@ -1345,6 +1346,13 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>  	if (!psp_master || !psp_master->sev_data)
>  		return -ENODEV;
>  
> +	/*
> +	 * Skip SNP/SEV INIT for kdump boot as SEV/SNP is already initialized

s/INIT for kdump boot/initialization under a kdump kernel/
s/is already/may already be/

> +	 * in previous kernel if SEV/SNP is enabled.

s/in previous/in the previous/
s/ if SEV/SNP is enabled//

Also state here that since no guests will be run under a kdump kernel it
is ok do skip initialization.

Thanks,
Tom

> +	 */
> +	if (is_kdump_kernel())
> +		return 0;
> +
>  	sev = psp_master->sev_data;
>  
>  	if (sev->state == SEV_STATE_INIT)


