Return-Path: <kvm+bounces-31408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D41059C38D9
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 08:06:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 598541F214EB
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 07:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 057AB15852E;
	Mon, 11 Nov 2024 07:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="USBQGWys"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2063.outbound.protection.outlook.com [40.107.95.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AC312CD96;
	Mon, 11 Nov 2024 07:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731308806; cv=fail; b=KYJbjW32y5/9EXQvF2b/FQxJuAjoz/wPkNFmyDf5uGkoh1w8pC/2IUiLTqxAXI6OxDnNFkMW40Pwbd9Eb6pMEC60pXWvVE2sMEs4gklTQ2F6ohT3NlvkiDxOvsD2eHUcmsZun5dlCoZ8NR3tIBbT+x9ne779az5KIaSInfC2T/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731308806; c=relaxed/simple;
	bh=Yv1Dw9iiJknAJJIN08kKuzin65ug3X7GmEnQ3tpgwWs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jv9Ye0RR6dr5gDEotmKUMfdz/Crzj5HJtLtgqlVUxOdYreEdvQynZz+M/x512QS1+U/x3fH+E+XY/PwZSq5JX1u6m63DT4OuPbsWzhb8Rx8GI2ZhRA4nemdG3WaOLGdMgGccxCz7SBCW46QpQOWlLrYKJtLqCPBK5uNMdh8p/PI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=USBQGWys; arc=fail smtp.client-ip=40.107.95.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nSocsATy6OEHWgtN3/lYbQ0gVPBpR9sba2bylhcGa7gbmOwU9Q6sg8pVgjBPWBSYmnCtDM+034sq+NC/TE9Ej6Dk0tkoK7wWVv8mOXI6i04gWxydZFXCmMyETZvcZqa6nyIYJ/TpSgbI5BvUMhrGn7RtO4ogPQDdvjjSd9MpDs5VYlR7ZFL4ki3pFIkOsE75ypGrJnVdQGlcUTRXk3ZiiABnAhvZfDqtgkyptp+k+gwUCjVEW/uYwF0An8Xqc0GA3bXS+yY8MZ4+cry5R4VhmDC4xKni2NK+8gZuXhzDeS0N6+Okq5akGcPAlnH910n5O4B0lBPAyOn8WB7GQna4UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1FofWF9rMEH9AcHlXSx2QZIrLkh40W0TysSQ5e2AH5s=;
 b=KHxZN+BO4tkxg1yhPK0EFK4zQRx+4vnZVKIGPgGW2k+M6XXVbHA+TxKjplJoAD+6Wd3OYj3oObATDF5Kmd3U2QHSADoBpppBUOT4chmHvxCnfNjX1iHk+bz+jk3o46DuxPqMszSgNMJ57/k+OvioPJFIUOnAASaTbMvfLW9lgAv/20/ZW1+oXssfW9BNPHGIsLOJiK45ol7iBzdFwOgKLGaDIP/SakddpXr/AltquuNMZqRvJQoCYWZ4F2YE7dJE/Xj1YEDtJiJ9d3FqRsMLJYG20NFq8qNstdKtClhZjbqrALc34gnyhuWDpWasApybFgmi30MDgJEH6IGrzYdTMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1FofWF9rMEH9AcHlXSx2QZIrLkh40W0TysSQ5e2AH5s=;
 b=USBQGWyst5JwXWmAXl1P1l8KO3hZQgmslFdwYnJkbZ9v/gfvs8BdlG808kbLRpIVJve3ExM7EEmgiFgBKzV/UlsMw0T1g/YwORmQJF03AFaQMsGNtSUe1vhsJfWqrFfvVrDpei+RyXwC2gmKLExM3zDMmbbH974NQ0r2sNSm21U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB6811.namprd12.prod.outlook.com (2603:10b6:510:1b5::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.25; Mon, 11 Nov 2024 07:06:39 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 07:06:38 +0000
Message-ID: <8550a6f8-5a1e-1415-05e3-7af7bf7e5d6b@amd.com>
Date: Mon, 11 Nov 2024 12:36:51 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v14 04/13] x86/sev: Change TSC MSR behavior for Secure TSC
 enabled guests
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-5-nikunj@amd.com>
 <20241101164053.GLZyUElVm8I22ZZjor@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241101164053.GLZyUElVm8I22ZZjor@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0064.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::9) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB6811:EE_
X-MS-Office365-Filtering-Correlation-Id: 4db4518c-c6de-4ebe-c85c-08dd021f62f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c3pzemROTVZ4NjJERllrS3pTN0ZIQy9GUnNoOERwajlIV1pSLzZMTWZVMWFQ?=
 =?utf-8?B?bjNLTlVZQWVtNE9IcXh0dnppeEZDRWJKM2xKdi9tOFpWSzFFLy9SdnBha1dn?=
 =?utf-8?B?dVJPcmlBVzd3QS8rSDAxYkVQeVMwekVCZWRmaUhBRmZ2dGhCL1ZjaHlrMjdo?=
 =?utf-8?B?RzFxQlFkRXZBc0lUc2VnUEtZTDc0WWE3aVVpSTNKb3dEcXNhZ0E5dDR1bHVh?=
 =?utf-8?B?SkFuVWdwZVlZSWZLZmVIRDhPN0hRNXByeXFPQWVUUzNRYmdnbjBxa2txVUpp?=
 =?utf-8?B?ZEYrTHd0eis5NzNCL0krOUludm04eFA3Nm8rbkd2RmlNVUlQeUJqdmQydFUx?=
 =?utf-8?B?b0tlRGZsb1pUOXlTcktRUGFkK2YvS0FGL20wbEZFUXh5YURYcCs1a3RtU0hW?=
 =?utf-8?B?bjlVYU5zd3pybUVyZGp5QU50a2ZUQndUNkxMSGhFUHRoZktDT1l5R01zd2Yw?=
 =?utf-8?B?blFManZoVyt5QTFKQStiM1lNRC9sR00vYXpkSU1ZelZVL0N2UnczaVlVRW5N?=
 =?utf-8?B?SmlzZzVjN2pMWGt0Z1RkaGFhUzJPZkovdFNWRmZOLysxUzZaS2QyNUU2SExv?=
 =?utf-8?B?MTdQOVFIaUIxRUFQNmVBaU8zTUhBUUNyKzVJZGY4WTZSZWlJREZORHZ1c1Zw?=
 =?utf-8?B?OHFURmxmMG56UEJKS1hsUVpvRnNhUWcvYVd6b0hBTjVUeEFRcDkyTlRmYVZY?=
 =?utf-8?B?bEsyN2YxZ1ZHV05RU1JOTHJUUkpMOHNYQXc0YXY4SW5UVW14ck9ZeDVVWmFQ?=
 =?utf-8?B?a1hKSElROGtFaTAvRE5wMmRWSFh0dVhVSE1KcDFrWmlNYlQwR3VodTZRdjJM?=
 =?utf-8?B?czZsWE9NaytwMjhuRHpta3VNR0pJU1laV1JlWHRLTGMxQkZ3S0NFYzQ1SWp3?=
 =?utf-8?B?dnJvSEN6ZURVZ0cxLzgraU8wdlM4a2htWDJZdXFrejZ1TlhSQUozdit2OXYv?=
 =?utf-8?B?S0c0ZytkRmFYR1YvdG5rb2Q1WGlrVjlHVlE3dUl3c0FmSzYyZUZqeUZFeHh0?=
 =?utf-8?B?YWErLzQ2RzZqSUNWUWVtanFLN3VxUEx0NUNDRmU5WWtvSkFqMFY0MHN5M3li?=
 =?utf-8?B?eisxOGpZbjVOWEh4UTJiY3dvcTBPSlduVTd1dzYvMnRQNzkrMmxVR1NGU0xR?=
 =?utf-8?B?bDA5cDUrWHMrVFpXd0RidFJWbmUzWW0wcDNrV3FmRUJ6OHNWWnlTZDhjRzBY?=
 =?utf-8?B?eXptUDdmVG1zSXNlZ0c1ZVp1NEgvK0s1N3FwOVFtUmVKQ252eUwyMHBiVTUz?=
 =?utf-8?B?Y21ubUQ0bEdIVVFwMXdqb2s5UEh5VGVLVWIrc0xtVVlYV0ZncVp6WE5xMklQ?=
 =?utf-8?B?SS9VUE9nam55YjIwdDdlQ2xod00rY1BPTmlxSlE2K25XUDk2VGltWTl0Q01W?=
 =?utf-8?B?T293NE5oZEhxeHRzS3B5Zld2RTE5TzE3Z01YNE1rdFRTSitqRmZDa3JLMWtV?=
 =?utf-8?B?Q2RRVC81eXk5VitBZW0xNWJtaURSai9sQkt4Qnk4TVNDWTg5Ti9WTWVMTHpS?=
 =?utf-8?B?TGU2QVdHQlg4d0NpRlV5Qjd5bXV5UXNBQUtBbDNrVm5hd2dtY0lSRHQ1MFM3?=
 =?utf-8?B?d0lsUEhJMElDNzBiVDJmL2xMSW9zd1JZYmsrOXA2ZFMrYytNR3NOd3V5K3dZ?=
 =?utf-8?B?U1dPOFllQm43emYvOUhyRkFlWnhsNGV5U25OWjBMVjNCS0xtMWo4S2g4T29t?=
 =?utf-8?B?ZlkwRWJma2p0RGZDOTBhZ3FFTE5DZWRuTm9idm9OaDlVZnhSMFViTkVZR21r?=
 =?utf-8?Q?auZg/jjTtPMETD0OA/eyvocAuXYZ8vixp7fnz67?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NXcraW1VOFVOdG92SHdpRXQraXViZmp2R25pNDYzZHNacWdLRUV2NEpIMWdF?=
 =?utf-8?B?MHJsMHM4WklxYnF2QTBQNEZWaHJQRVpCVzhNZ251ZjI1VnowWXlWb2E1T0hr?=
 =?utf-8?B?RzJ6VWtraXZ4S0h3RWVEZVM0ckxRUERLVEtDNEptbi9EbURDV09qaVFzdTdB?=
 =?utf-8?B?WndqU1hhaGxjOHNheFJrVjZxYkJQQ3ZuNHpXaUhyNXlZQ0VpZEptSXYrYk1T?=
 =?utf-8?B?ZmpmMU1EQUozeGE1Mk1LVXVyc3d1ZDg5RUdHc084NDRYVnViczNMVWM4eUl3?=
 =?utf-8?B?a2FyTUhxNDlhbTR1djBlQXVkbW5hbjEwMkVQOXZPUnNVRFliWHRTcUJwdW12?=
 =?utf-8?B?ODNvZzZwK1hWMUpSS2VTejhleHZXcGJ5UjZBRnRGMGVJNWk4WVpjWEVzcWlF?=
 =?utf-8?B?cGZMaFowbmNiTG0xc1dwdlozdFdGN1ovTGMwc1NnandSQVpPTnowd0w3N3pu?=
 =?utf-8?B?WUYvaWtiRlB1eDg1ZzZtdUlHOGJZd1VaNXhBeVkxV29xVHFBT2JkVGVMdnZ1?=
 =?utf-8?B?TzN6ZFVOUHJ1S0UwMGZ1blZmRzlGUmJPOEp4Y1EyU0dsZzVyb0hIUWx3WnJw?=
 =?utf-8?B?bzZlY0ZSY0xCeXVYMXhxUHduTTN6cmN6dVlGMXBsK2FCSEdGSXp5cEYyU2kw?=
 =?utf-8?B?VGpSanZlKzJSRWFXZkJQeWNSL3AzaGkra2NnelJERnZBYXVUZGNUdGFXS2xh?=
 =?utf-8?B?bFhmZThyd3Z4Z0JyOXIwcnY4akhmZkRGT2dJNm1MdFJDVnRBSmg4aElITWRE?=
 =?utf-8?B?RnpWdERYRjM2NFBBR3lGdWlNcGl4c0krdGxuOVdSdXhUTXVrY043QWpLcVJO?=
 =?utf-8?B?Q1htQUFQOWVmaUU0aEVZUE9hakhINEVCVnhlQnFOSmxNd2pMV1BPSTJUY2Na?=
 =?utf-8?B?RjA5cE15MDhHQnNqSXJiNVBpME5ORzdrVVdlKzhlT2RVTFlyT3dFKzBFNXhl?=
 =?utf-8?B?WGpTaVEzUGpKeFZlSnl0cStJVEV3MVdwUEhmWk5ZblRXREFKbGM3MW51Tkhj?=
 =?utf-8?B?U2tzbEdVSy9rWEk2eGl2MEwweEdlejBNcVVKaXRhZzA3TkFXTXk0T2ZEbnZw?=
 =?utf-8?B?d0t1VllDV1pZQWhHSDZ3TUtLMWljQyttVjNteFZ6UlhyeE1ub0NMYjFDampm?=
 =?utf-8?B?WDFUVGlOYTFTR2l6R3JZSTdVWkRPKzg2V1YvbGN0U2toem9jQTV4VmtHRHdJ?=
 =?utf-8?B?UXpXbEhEOFNlVlBudWN3b0F2QUtURXVCOTMyUjlQYVRWVUk3Zy9mQW5wR3l3?=
 =?utf-8?B?dTNuV2hGUWtUditUYlVybHZKUm1FeWl6dlFrN3pUcnBaZGlxaC90Ym9VUG1m?=
 =?utf-8?B?ekxocEMzazExQWIwOTRIL1pXaUhaY2xRTmZwaU1zWUN2bDFvd3FkS1lLakl6?=
 =?utf-8?B?YnJTeExRRXVTcTh6Z3V1N1pGWDQwWVhCZHhESlMxOTBFRkdGMjlCdGY2YXdr?=
 =?utf-8?B?TGh6SFk4dUJTZ0NhelY4WGNPSlVrT3JPREJGb0pYbk8wRW5mcEM2ak9qUEx0?=
 =?utf-8?B?REhLb2JPNkxENTI5bkd6WTk0MjFlQ2xIZXNUQUVBdHo5c0U5Z0l3Vk9TY1g2?=
 =?utf-8?B?NVhLV2Rpb3ZBOGROMEFZc0RmZGZWYzNhUDk4SzVQQWNDTWxYek9HTEx5S2FZ?=
 =?utf-8?B?SlhnNThCclZGQnM2WXBKT0RxOThydUE3bTE5NTZMdFU1Z3pJd21CalViL3NU?=
 =?utf-8?B?ZEtyNVcweGQ3VFlUaGZ1eGoreWxHWHFBS3NFN0NQZmJzM01IWldnQXYrWmZ4?=
 =?utf-8?B?QXdzSURXVGhNREVHczV1cEdvbG9YdDdialNreC81Tk1yVVZTa0IvcWk5MG9x?=
 =?utf-8?B?S1Q4c1hSb3c4VjQzVUJDRlZnSG4yTm1KRnBzU1I3MUxpbmZUR0dlMkRZeXJB?=
 =?utf-8?B?RE1FWTVYSDRreGpvN284Y3g3SjJpcEpGcCtzNG0vK0VqTTFML3FiaE15Tnhm?=
 =?utf-8?B?dDRsUHA5YUthMWlGNm04USs1aFlxYTR4TnBoY0lLbmtENkhMOHdTTUF2YWlM?=
 =?utf-8?B?VFZ3L2FtYmN4QTh3ZjdlZVN0VjNtMklEQnRvSDhXOGhjdFpvRWIvSnlzcUhi?=
 =?utf-8?B?N3MrQmcxdTFKZlFDUFhzVUFxWkxSSXk4SmIxc2o2YTVDM3V2N0hWWjgvMm5O?=
 =?utf-8?Q?Y6/wHcTKdtdkXZzPGkIdFI7jd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4db4518c-c6de-4ebe-c85c-08dd021f62f1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 07:06:38.7067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nCZlDBQ1Hy0LJ9Znd+LMzvJ/OlsJEQPxl6BHcYmXZDcfQBnWJNgSb3iJmiNvrnKKDP054MUrSbDKywulxOZDCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6811



On 11/1/2024 10:10 PM, Borislav Petkov wrote:
> On Mon, Oct 28, 2024 at 11:04:22AM +0530, Nikunj A Dadhania wrote:
>> +	/*
>> +	 * TSC related accesses should not exit to the hypervisor when a
>> +	 * guest is executing with SecureTSC enabled, so special handling
>> +	 * is required for accesses of MSR_IA32_TSC:
>> +	 *
>> +	 * Writes: Writing to MSR_IA32_TSC can cause subsequent reads
>> +	 *         of the TSC to return undefined values, so ignore all
>> +	 *         writes.
>> +	 * Reads:  Reads of MSR_IA32_TSC should return the current TSC
>> +	 *         value, use the value returned by RDTSC.
>> +	 */
>> +	if (regs->cx == MSR_IA32_TSC && (sev_status & MSR_AMD64_SNP_SECURE_TSC)) {
>> +		u64 tsc;
>> +
>> +		if (exit_info_1)
>> +			return ES_OK;
>> +
>> +		tsc = rdtsc();
> 
> rdtsc_ordered() I guess.

Yes, will update.

> 
>> +		regs->ax = UINT_MAX & tsc;
>> +		regs->dx = UINT_MAX & (tsc >> 32);
>> +
>> +		return ES_OK;
>> +	}
>> +
> 
> All that you're adding - put that in a __vc_handle_msr_tsc() helper so that it
> doesn't distract from the function's flow.

Sure, I noticed your patch adding __vc_handle_msr_caa().

Regards
Nikunj

