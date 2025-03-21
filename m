Return-Path: <kvm+bounces-41643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C279A6B36C
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 04:44:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B6C227A736F
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 03:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B0A61E4929;
	Fri, 21 Mar 2025 03:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QYSClxll"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF5A2AD0C;
	Fri, 21 Mar 2025 03:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742528671; cv=fail; b=q6zCinxXeyoPuPD+aTmwdDQpMtqtO/rGcpNV3KK9D68IPS3YVV4BV6G5Ajw7+aFwkhRxMHobZAN7+hc5hPCyecJSJsivaX9/G38Z9rD4Gbx6CmqRLRegUVC2RRxNUQYgU3OubNojTmXMjkuJQZslqPZWM1MrhRQOqT/GMViBhXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742528671; c=relaxed/simple;
	bh=6ROh0sFhtrSzvbr3Oi+ldlfkTRQXpqrXqFPvoY+foAk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q1O2Zt4gMzmOYLb1EhP1z0TkZQOoSSBcKJnw2OstRaOJdnNWnvZvMq0KEpax8uPZK8+z5dfiQml4a/fUqjC0DIJIcHF95VJ5ev12LlNAoajr9QsQ3wShCMQ6ViqNQdLo8jtQxfMuZUXfZbvoq1aOsbi4HTN6dHjd5ltBrKX+atk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QYSClxll; arc=fail smtp.client-ip=40.107.237.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yb2sL2Vi6oF47klC2o9JPHQqk+KQKHnaz2FhMnjMzzQ6lyv/MRwnw4wd+wW9TBGoAw6DBc5/raBRabKZljzzQUMKgYp/RJ3jvCACHH8MEIXEXpFMJ2n5mOAoKFsvnF/qt8W/HZ2jS++jvWLglQ7u1uUMOLoEFP+scGvWc/CfpYv8rkfvMx2sfUeqGYAAWk8lOXNYUnIIAOtzjJtym049h1fLsBfRoptwuZFQPDu3sdWIdzMvHdj08e1v83barQvZOyMm0X5oQfonboEdn1py6mWxDW6HkX5iMrfav7vtpDv+40vRH5G4QXKRi4VnDiKd8aG0L4zOqzJ6tHvAx5ERUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i9XE8eJW06g9Qqw1pDpoo/JgO94JzYZkr4EOSDea3yg=;
 b=GU1fPvsOqI44PlgIEEu502X5YCOc3BPt3+yCtOIcb5eW53Vx8A8szC0B3d1aRzMpgtYj4H2RT0+7Zcw6a35+2rBBf/rRcz9iTdEx3mBSybZJ8q5HM2+eF9DQBITnGZUeRVfuQuOZoOiB6Whn4b3Zuvad8CeSLU2ck5e6tQoLy24JoMphfYZyzbZXeNG5cCh3fVQRVwBQbr2O0blsXDrfJUxy+1DuZ7H/qqTeUc+owfY67IS+1lx/f24epq/CLUneqraapovF3Re+PSwx8RQbr0shrxfyp6FSjmobFqla/wr+R0hJXQJIgZt40szxuOUSiaM4qQks8CwEN7QMlub9yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i9XE8eJW06g9Qqw1pDpoo/JgO94JzYZkr4EOSDea3yg=;
 b=QYSClxll6aNlYMyu73h5nw/55e96DcaUdtNvOmgUC1EDtYSXCeHMbT4AJX/kDF9rrVlKoRpY804SW5Sz64xmpK1pNvtrnfkTnqk9X7PqI0G3K/9e3dqoExb30kVLGngED56h00JmHmjMo84IAaNZMo0aK+Umb3dnPaupatnh9ec=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 PH0PR12MB5608.namprd12.prod.outlook.com (2603:10b6:510:143::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Fri, 21 Mar
 2025 03:44:26 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.034; Fri, 21 Mar 2025
 03:44:25 +0000
Message-ID: <a7422464-4571-4eb3-b90c-863d8b74adca@amd.com>
Date: Fri, 21 Mar 2025 09:14:15 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 01/17] x86/apic: Add new driver for Secure AVIC
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-2-Neeraj.Upadhyay@amd.com>
 <20250320155150.GNZ9w5lh9ndTenkr_S@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250320155150.GNZ9w5lh9ndTenkr_S@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::18) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|PH0PR12MB5608:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d5dd8b3-e142-43c4-475b-08dd682aac69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d09sbVY3dVk0VHA0RjZuV0dWcjliK3k2T2JGZW5weGNNMEZrbDBqRy9KY1Fu?=
 =?utf-8?B?ejA2YWx6R2ZWOTdrZllNTUVwajM3SkVQc2FqM2grWnYzcDJLOFU0Unk2VFFq?=
 =?utf-8?B?NzdhYVBjQXc5cnZYM1prMGtURFlONU41aExqdm9xQmt5ZEI5TERSNDFOUEtI?=
 =?utf-8?B?SjhodGNKTU8ybEFBRktaWStRcDlPTFNHVERabzdSWTR5bTA3akR5V2Q1TXRu?=
 =?utf-8?B?RkNnS2Voa0FQelZjcklJTjBPMGFia0VCcWtNd2RHUjlyeXJaMmk3T2JDSS80?=
 =?utf-8?B?ZEluTzROUEdDM0k1bUdwS3lGL1Uyc1VmSm9zSUhSL3crWllIcVNWL21FNGhG?=
 =?utf-8?B?RW1rSTVQVEVOZ2MyUnJyQ0dTOTVhcWQxU2FMNmhrclVROTMvVEZKdkxPUnZU?=
 =?utf-8?B?Z2liNlVCck1nb1pCYlpoSDRXZ1Y5U1RtVVg2NFNMRlk0dUY2T3Vzd25iN1Zw?=
 =?utf-8?B?bXJmRHRqbE1QSkhrbHRHTDRhTWo2dTBsRjFxMXdJdktPNE9zTWpJTlRzTmFM?=
 =?utf-8?B?L0dxQUdIclF6QVRUQTN2UjlqVUhqOUxwTUFuSzVUcXd2S0taZXBiM2pUeVdj?=
 =?utf-8?B?U2R5QjVNeEVTVTllVFYyczFFSGd0RVE1M2xTTUtBUU9ralNlaVM2aDB5WUZT?=
 =?utf-8?B?a1dNSkV1NmEzTkMrS3NmR2ZtaE44WWdrNFB4amNlNVdRc2hhaDhETEkrd1lX?=
 =?utf-8?B?ZWpZMENJbzVSMFphNjAyUzNCdGdLR2pOTmF5VGQ0dnh5S3ZzdCtZQXB3UDF1?=
 =?utf-8?B?cENtcWFaNDF2djR2eGFZbS9QV2lIS04xMm9YWG9JL1huSnhsWlVnN25PUkFL?=
 =?utf-8?B?eUJRNDgrbmhRcVFXOWZlbjI4NGIxZEdKMHdsb2luQXBMN1VDTmsrUFprK1hX?=
 =?utf-8?B?dDJNVzQyeUhtWlE1RmtxSEhaTVBzd1hBTmltci9TbkcxOE9KL1U5c0hwdits?=
 =?utf-8?B?ZEpoQjRJcERObVNmRG9CdENGS1BSL2V4S3gyMjc5UWs3c2JOcVJRS1pzeHF6?=
 =?utf-8?B?c2pLMDRhbFdQY0xoTlFJYUEvS3VqK253eUpJSDB0K0JaN0ovVVd1dnlhamhG?=
 =?utf-8?B?T0VXazBOV1hEc3FyWUFJcmJkMDRCS20xeDB4U2lzY25QcXlOT2g5cEtsMng4?=
 =?utf-8?B?akY4S2hpcnNZUHNqcGRjcENrdFh2MGN3aE0vT3h6eE1SSENOZlpNWUtmUk12?=
 =?utf-8?B?WklXdjhuL01qc2ZLZWNjdWFlV0E1TG9mR1pWaDdOR2hQaDdaSjF3OEN1TGtZ?=
 =?utf-8?B?THB6eis5RGR1MXdVL1FIRlJIaGprNTFJTjhsWmhUVGptTkZEUmIrUi9JWnJT?=
 =?utf-8?B?eWNONHQrTmZjMEhnZGNOQkwxU2VxWGFPNUg4emdkUllSaFFNSGhGNEkxVHpM?=
 =?utf-8?B?aU5IUTFsc21SUEh2dVllWHIxTzRYcWo2SHZjNXVIK0FVMjN3aDlqdGpZV1BC?=
 =?utf-8?B?SUszb1FBUnlWVGxlRWZrazFsRDdRSXBPNFNRdFJmb25RN2UrRFg1QWlNWG9J?=
 =?utf-8?B?TkRNR2JrbS93NE5iSDJOR1Q5RnZhRkIzU0xTYms3c1lWSVhFSXpMRk4xRFBq?=
 =?utf-8?B?Zy9TbkJVNXEycnF2Mzdvckw5RnJSSVQ5bzZZdHV5SGI0dUtYTFovRTJaYU1H?=
 =?utf-8?B?VXFsdWpSRFFaV2tYOERwS2tyeTdkUitjZG5nbVZVUW1oc3hjZmRRbk5zckRW?=
 =?utf-8?B?eXRlMDd2OVFGcXd4QU13RGFlVWdVN290eEVNRjIyQkZxS3laZ3daYW8rZEpS?=
 =?utf-8?B?ZzZ5d01MZXY1dmdsSGZldWZkWlZKZXBwV2xSWmhZS0lNbzFzaUhKMW1MZDdl?=
 =?utf-8?B?dGJWTmV3SDUxU3l3NVVSMkliSVU2RzVtbGN3SzNiUWNNRnl4L2dRR3VQa2lQ?=
 =?utf-8?Q?CRfCMjX2t+UHv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SzlqZ3hoczBpMXRXakN4QVJjZ003cFBjMXk1SUNySHFrUnJOU0lGdGxDd25w?=
 =?utf-8?B?VFV4Q1ZlSVR1Sy9zWWhNRlpCVklJQllaWGM1MXA0a3ZVY2pXSnR6TGthdUhw?=
 =?utf-8?B?L0l6L0ZJY0Q2ZVpMYnJCbmZrY2QvSURxbXliY0hiaVdXMGtNVm1CT0k3VUI2?=
 =?utf-8?B?UG9IcGx3UkpSa3RGbnRnazhKcG1qWmVta3h2czdMUWRGMU5KbFNZSlJpbDNQ?=
 =?utf-8?B?WVJTdDVwbWtRY0ZuMXJmUXVEbjhBK0hPUEtNejYzaGdla2xUOHY4a1RzS1dI?=
 =?utf-8?B?VU8vSHNBK3ovTng0OEF2d2VhK2VoeklIVDhST2RqT3ZBN1ZBdzd2TGVQVWJ5?=
 =?utf-8?B?SVphSnlteXl1MUZxQktudFpSVytpQjE0V1BzMGFyTUwxUWlxMFA0WlFya2pT?=
 =?utf-8?B?T2FGVUxXRnNpR3Z3NzFlN1FvVGxLamlSSFhseVU3NVFaKzIva1RVeFF5QnNY?=
 =?utf-8?B?d3RCNUdlT1NYRyt3OC9Qc1dWMmVPbnc3UG92UmRHR1FCclZLbUUrbmhzL1gv?=
 =?utf-8?B?Q3ZUTWVFWi9rVDV3NTlQd01PQU4yN2ZjeU5rS2piTXhFUEk5UVRxeTdCN3Vo?=
 =?utf-8?B?VjJZTmIxbE45QnY0UEg3OVBVRFFxSlQwL2ZzMnM1QVladURTdGFnUjVESEdy?=
 =?utf-8?B?SXpubzJ5YUlDd2dEWUhkTjdoQk5MVDNqUHhhV3BJdXcybE9OL29FYUNtcHBC?=
 =?utf-8?B?SkRzSmpkdS9yYzZsTzEyNDdKekkrc0h4V2F5ZzdvZkZqL0toMTYxN3pTdzli?=
 =?utf-8?B?TFFPOGJGYnd5SlA1V1hQQWhRd1NTOU0vdDlBOW5Cd21xeHhpRVFnOWtNYUkz?=
 =?utf-8?B?LzdzOHlpNVBEdDBRS0RTMWx5eFJxTlM0YXdnUUlFRy9saFhuT1NIakV1SGFK?=
 =?utf-8?B?dCs1WkdkUDJVTURwYmhuVGJMd0F5M2xVVkk3TnRKUG1GdFNXZjhFWXN1Z1ZJ?=
 =?utf-8?B?aWtRMnY3WldxeWJWQnIzWElMV05HdGlaUkJwQzJSKzFlS2RXY1hVTVZWS0xF?=
 =?utf-8?B?dGZqNlA0Q1czaGRITTR2SlI2L3Rlc2NiMnhNUlpYTEhjNDA5aFNhVlFsTjcz?=
 =?utf-8?B?Tll6b1VGeGdLanExUnlnMi93K3R1MlhHMW10cEtqaFBKOWZNdUlrRzY3SFRQ?=
 =?utf-8?B?OEM3ZFF0VDB4akxEVTBjMmFxcXpCbkkrelNQcDdvSTlKTXM2em5wQk9kVDhY?=
 =?utf-8?B?SHpLeXJIR1JCTTVoaTBLVlhPQWlBTE1DN3pCWWwybW5RdGJCeVBmSXY1Z0Ex?=
 =?utf-8?B?b0NqTSs5cGFKS3Y1aUYrOXc3RmhhYTF2Q2R1TFBQTnRmMVBlWFFhVElHVG15?=
 =?utf-8?B?bEIvMEhzd3dDZEtWbmROWmhwYTZoNWdmWDZTNlpYYTUyT202WTJzK1dtVDJK?=
 =?utf-8?B?NWkwRUV4MGxyZFpVSmxOVmpNTjNZNVNoM0ltbENnTFBtVDIxaWU2Szh5VVZv?=
 =?utf-8?B?Tzgva1hpTnNwMTdPcytmcDIzWjJoZU12QVlPU250dU9ZcmdJMGR0V2ZzanU4?=
 =?utf-8?B?V2Y1bDk5cGV1cGVjamw2dGRtbWl5TXI5R2Z5TW9LVzFFaUo2aEdCc25rWjli?=
 =?utf-8?B?MUdQS2hORW9SVzJQR2VvMmQ2L2VNWjhRTXZvUVpPR2U4d1MySEUwU3ZXS1dZ?=
 =?utf-8?B?MXVxSGxqZURvQ2Naa2dWUjZxSlJqdGdGT0tJYXlwbXM1eU92RllKeHl6NFE1?=
 =?utf-8?B?M1A5U3ltSG1KOXd4RlpVTnRKa2lsbWNJaFBtclpKcDRsb3ZJc2NRVW9DdE8w?=
 =?utf-8?B?UFpmdDU1MGxSNWUwcEx0SDVIeWdlb1JQTWI3NjYvZTZ1TGpveEZJV1I3UmRr?=
 =?utf-8?B?bHdGWFhXL0l2VGtWNFQ2RXIyV0tDZHRDeXRJcXlIMnZrMzF2Y3lCV3pGUDVw?=
 =?utf-8?B?UHM5b1gydE5heTFVZFo5dWpNUERTdlE5dmZ6NXQzT0VxMlA0VlJwai80Q0hx?=
 =?utf-8?B?Nm1WN2xPVUtOMGc0QVh2ekQ2WHhTRm13NnhmVjVIcmFTK1JDVllQWXlwblNB?=
 =?utf-8?B?RHcwWW1JT2VyKy9SUFdNSzdscnJKSkJpeWlrNll5YzcvWTJpdDNydVhKL2tX?=
 =?utf-8?B?bjViMmZUcHE5NEVVb3crMVBWcHp3TWlVVDZ3UUhnSlhFMFhHREZ4OENqSi91?=
 =?utf-8?Q?JdcE08wN7k99ZbSfSPZIpIRZk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d5dd8b3-e142-43c4-475b-08dd682aac69
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 03:44:25.0470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9WPrRkM5u0K1igWM3OVYh17So9I9VxAHRZKVT/pG/CQ+5OPpqwQUCzj6dj5P0tFVVe9NcgxJNVGfpACuXcKT+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5608



On 3/20/2025 9:21 PM, Borislav Petkov wrote:
> On Wed, Feb 26, 2025 at 02:35:09PM +0530, Neeraj Upadhyay wrote:
>> +config AMD_SECURE_AVIC
>> +	bool "AMD Secure AVIC"
>> +	depends on X86_X2APIC
>> +	help
>> +	  This enables AMD Secure AVIC support on guests that have this feature.
> 
> "Enable this to get ..."
> 

Will update.

>> +	  AMD Secure AVIC provides hardware acceleration for performance sensitive
>> +	  APIC accesses and support for managing guest owned APIC state for SEV-SNP
>> +	  guests. Secure AVIC does not support xapic mode. It has functional
>> +	  dependency on x2apic being enabled in the guest.
>> +
>> +	  If you don't know what to do here, say N.
>> +
>>  config X86_POSTED_MSI
>>  	bool "Enable MSI and MSI-x delivery by posted interrupts"
>>  	depends on X86_64 && IRQ_REMAP
>> @@ -1557,6 +1570,7 @@ config AMD_MEM_ENCRYPT
>>  	select X86_MEM_ENCRYPT
>>  	select UNACCEPTED_MEMORY
>>  	select CRYPTO_LIB_AESGCM
>> +	select AMD_SECURE_AVIC
> 
> AMD_MEM_ENCRYPT doesn't absolutely need AMD_SECURE_AVIC so this can go.
> 

The intent here is to prevent a configuration where CONFIG_AMD_SECURE_AVIC
is disabled in build  and sev_status (features enabled in hypervisor) says Secure
AVIC is enabled. In this configuration, while SNP_FEATURES_PRESENT says
Secure AVIC feature is present in guest and snp_get_unsupported_features()
would not flag mismatched features between host and guest, guest would boot
without Secure AVIC apic driver being selected. Do you think we should
handle this case differently and not force select AMD_SECURE_AVIC config
when AMD_MEM_ENCRYPT config is enabled?

#define SNP_FEATURES_PRESENT    (MSR_AMD64_SNP_DEBUG_SWAP |     \
                                 MSR_AMD64_SNP_SECURE_TSC |     \
                                 MSR_AMD64_SNP_SECURE_AVIC)

u64 snp_get_unsupported_features(u64 status)
{
        if (!(status & MSR_AMD64_SEV_SNP_ENABLED))
                return 0;

        return status & SNP_FEATURES_IMPL_REQ & ~SNP_FEATURES_PRESENT;
}



>>  	help
>>  	  Say yes to enable support for the encryption of system memory.
>>  	  This requires an AMD processor that supports Secure Memory
> 
> ...
> 
>> +static void x2apic_savic_send_IPI(int cpu, int vector)
>> +{
>> +	u32 dest = per_cpu(x86_cpu_to_apicid, cpu);
>> +
>> +	/* x2apic MSRs are special and need a special fence: */
>> +	weak_wrmsr_fence();
>> +	__x2apic_send_IPI_dest(dest, vector, APIC_DEST_PHYSICAL);
>> +}
>> +
>> +static void
> 
> Unnecessary line break.
> 

Will update.

>> +__send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
>> +{
>> +	unsigned long query_cpu;
>> +	unsigned long this_cpu;
>> +	unsigned long flags;
>> +
>> +	/* x2apic MSRs are special and need a special fence: */
>> +	weak_wrmsr_fence();
>> +
>> +	local_irq_save(flags);
>> +
>> +	this_cpu = smp_processor_id();
>> +	for_each_cpu(query_cpu, mask) {
>> +		if (apic_dest == APIC_DEST_ALLBUT && this_cpu == query_cpu)
>> +			continue;
>> +		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
>> +				       vector, APIC_DEST_PHYSICAL);
>> +	}
>> +	local_irq_restore(flags);
>> +}
>> +
>> +static void x2apic_savic_send_IPI_mask(const struct cpumask *mask, int vector)
>> +{
>> +	__send_IPI_mask(mask, vector, APIC_DEST_ALLINC);
>> +}
>> +
>> +static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
>> +{
>> +	__send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
>> +}
>> +
>> +static int x2apic_savic_probe(void)
>> +{
>> +	if (!cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
>> +		return 0;
>> +
>> +	if (!x2apic_mode) {
>> +		pr_err("Secure AVIC enabled in non x2APIC mode\n");
>> +		snp_abort();
>> +	}
>> +
>> +	pr_info("Secure AVIC Enabled\n");
> 
> That's not necessary.
> 

Will update.

> Actually, you could figure out why that
> 
> 	pr_info("Switched APIC routing to: %s\n", driver->name);
> 
> doesn't come out in current kernels anymore:
> 

Interesting. I see it working on 6.14-rc7 and master branch.

dmesg | grep -i "switched apic"
[    1.044435] APIC: Switched APIC routing to: physical x2apic


- Neeraj

> $ dmesg | grep -i "switched apic"
> $
> 
> and fix that as a separate patch.
> 
> Looks like it broke in 6.10 or so:
> 
> $ grep -E "Switched APIC" *
> 04-rc7+:Switched APIC routing to physical flat.
> 05-rc1+:Switched APIC routing to physical flat.
> 05-rc2+:Switched APIC routing to physical flat.
> 05-rc3+:Switched APIC routing to physical flat.
> 05-rc4+:APIC: Switched APIC routing to: physical flat
> 05-rc6+:Switched APIC routing to physical flat.
> 06-rc4+:APIC: Switched APIC routing to: physical flat
> 06-rc6+:APIC: Switched APIC routing to: physical flat
> 07-0+:APIC: Switched APIC routing to: physical flat
> 07-rc1+:APIC: Switched APIC routing to: physical flat
> 07-rc7+:APIC: Switched APIC routing to: physical flat
> 08-rc1+:APIC: Switched APIC routing to: physical flat
> 08-rc3+:APIC: Switched APIC routing to: physical flat
> 08-rc6+:APIC: Switched APIC routing to: physical flat
> 08-rc7+:APIC: Switched APIC routing to: physical flat
> 09-rc7+:APIC: Switched APIC routing to: physical flat
> 10-rc1+:APIC: Switched APIC routing to: physical flat
> 10-rc6+:APIC: Switched APIC routing to: physical flat
> <--- EOF
> 
> Thx.
> 
> 


