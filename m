Return-Path: <kvm+bounces-34389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B24149FD256
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 09:59:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 35BC31881B2F
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 08:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B0E15573D;
	Fri, 27 Dec 2024 08:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TZACzSYG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAE2155333;
	Fri, 27 Dec 2024 08:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735289962; cv=fail; b=rxPuD/IwBOIV2kYGYUiPEEmeRCjIx7GQ8I7vhixdCyL2IzS13BZUELyh4smnGrWyhS2Fjvsb7meSGxd1APuyDw17OJKImujq9r6Uh27PYz401xK3JCxF9IMhNinWu6JZdXAaRe/kDDFkgSq++p1J1GSSI3ZHhC9OFUiX9Dk1Vyc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735289962; c=relaxed/simple;
	bh=YRls6T3Ih/uVsPQLKC35snFhYHA2m/bd1kMdBZlAAlQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Gbi+uDEP2KpUAg/Ig1VMqGzoiijRzeyDm/UyJc+HzLxKUb/LyTj0/zYke85SYYUjylrSAbcaCAdtiQ/KsB7km0CLnH50mLwQtlsOoR+uOKAwhuoN1OxfXj3I4dNyMr/v++tvWtpjnHlTD73N/OCsXokFa6hKLq23iNarQa9J/CA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TZACzSYG; arc=fail smtp.client-ip=40.107.244.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yYPdCc1DNt/R93ddfQyaKTEPLRLywoWvcjSeqfDJcyieFAiclK0mgXTLtEdiL5FSHcniD39c17w/cj1GLlS9p1SCU4vB7XhBorbWm9WIr+rd19V3Kz1PKfjz9B+VbL++4aBBokkeHjWsvpHu4nMdNXwodPR6oJLwrba1GCdd1gPD0ds36IhjYi25zaCNQtRtpz00TySenwddPRWbhHy7AbmkyMFhGS32ddjzOVt146laS3qwJ0Di6C848JatVAqv0IXPytCjL3RrV33E19YuhmQqLMZbTDeDb8gsvwCljQR05gmaafA+ZTQJTAxFhAS7fhV2AjDA2K5/UCYGcaaJ0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dusyGhDU7xfJEeioRXM3fTpxEWSBf5HKXXmsTIfiZ70=;
 b=h+DkboOmrBGwNC+NIfOB15DZ+eCP8mEi6aGKo8jrduXdQGD8u4SSqWgtNMo3fqTACGj5i1d2iybGBnRDvSC0u+GBAFEZm4UfAbZO3VaT+WKOTSIIn8ZIqdRa4lmAkw7ExYdThvdfqcJQInNwwvcsv1s4bMvmP3Gr7nXaE20HAr0POlo9mOxCGWQanwO+O1RItO+DNFD+Ekzp5SzE2yQk8eILSWy2hVOAxTykpfe5mW9oqS1E8znfXgIQaems/nHFl1u3MIPdBq/PaVPUHVXIJ/Q0l65ACfTD9WFVQLLBO6CR46pf072HCbQ2LfTpnA8970e6uWrz9ten7BmZoIfhEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dusyGhDU7xfJEeioRXM3fTpxEWSBf5HKXXmsTIfiZ70=;
 b=TZACzSYGKJp8YjLPkyB/wjorT7gs6D7hMuHsatDcaTaTPWDpDnwrqKTGOluaJxO1BouOpXVK0KgbEC3DWxydS8uzkkW/3bIH3zfbcZhY93sicEjMgE/PpmZXfxT8BhzrD6Y7q5lbwqU3mYf2ubx9rlTlhyLkz7E5Py6CT2/6fjs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH8PR12MB6987.namprd12.prod.outlook.com (2603:10b6:510:1be::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.15; Fri, 27 Dec
 2024 08:59:14 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%4]) with mapi id 15.20.8293.000; Fri, 27 Dec 2024
 08:59:13 +0000
Message-ID: <9fb19323-3522-4f54-9b44-7053d29ee2d2@amd.com>
Date: Fri, 27 Dec 2024 19:59:06 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v2 2/9] crypto: ccp: Fix implicit SEV/SNP init and
 shutdown in ioctls
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1734392473.git.ashish.kalra@amd.com>
 <1e96d3b18245577cb0c2ae510092701901bbe81b.1734392473.git.ashish.kalra@amd.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <1e96d3b18245577cb0c2ae510092701901bbe81b.1734392473.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TP0P295CA0032.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::20) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH8PR12MB6987:EE_
X-MS-Office365-Filtering-Correlation-Id: 4de7f204-aefd-4893-065d-08dd2654bc6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TW5tamRlV3RXZERPdUtFbEkwM3QzS2x2MUtmSGFJdlJaaHdjOCtvaTdyUkhF?=
 =?utf-8?B?T1NuUnlPWVdLQXVvTUdCSEFrcHZ0cFc5WmY3RjFlN2t0dlFBdkRNQXpiNklZ?=
 =?utf-8?B?TXZ6Y1JuVzBQaUJZYVg1T2lSQUxDTHoxZDFTMWxnNkFiQXQ1bVVkQ1VjNS9B?=
 =?utf-8?B?aFBBeDBDbDZtaFlKM0pHMzY4ZTlSbFIzNUp5WElQSEFmcTRwVEpYc3BMTVJ1?=
 =?utf-8?B?VzkrQjgzdFh4dE83UCtmU1hRSDdBVE13TnBQTytNWXc5bkNwM2lKZ0xLYUhK?=
 =?utf-8?B?T0Z2MGdlbmw0S2w0ZUtnbk40SHpHWGZUNXNsdzRsd0Y1R01mTlJLS3JueUQx?=
 =?utf-8?B?VWJjbHpPUVNJNnZ5ejY3NTRRaXZTeUFKSUNwSllPNWk3RjdaWmRCU2w5ZitQ?=
 =?utf-8?B?aTJNd0VLVGlqWjNKU2hqV21BUU1qQWFxR0pDYlBxaHpGYjdWK3lnZnNKZDhJ?=
 =?utf-8?B?Sm1YSkFzOTI2RnR3dmMzUlFVUlpnTm8wZTFyQ1h3ZFhZOXVpd2tDaXF6TjhE?=
 =?utf-8?B?Tm15eWRzRTJOYWFxdUM5YmNuV1QzOEVhM2F6ZC9TNm5DNFVvdmRNTDFxZmts?=
 =?utf-8?B?N1p4bjErdDlTdWNKT0tPNWh4UDhzQWZueXRGVWhmbWFQTndwR3V4bGZvUFVI?=
 =?utf-8?B?WGtkY3dUOElnNHBpUDlXa21YQWk0aVoyeWtYNjE5a09ScDZnQTAyakZEOFcy?=
 =?utf-8?B?VkhxVjN5NURZdzdTZzVKMHhWdjIyb0VpY0ZINmI0ejJ3a1I0WjZWQVF6c0xW?=
 =?utf-8?B?UDFwY3UxWkdWZ045YzZsS3FVUlBjeGs1OG1FdkNQQWJrNW83SEVvNWlIYkU2?=
 =?utf-8?B?aUQ4aGMvUWMxUnloaHYxeW9hTWZQLzF2eXpYKzFOVnNXTXBwMFdaZmRMMTlr?=
 =?utf-8?B?SEFId25YYTRJUlllSVV0OG9XUmg3R3JQTDZRWnNacThWQ1JEZ3VzTWFsU0xN?=
 =?utf-8?B?MVptUXY4Z1VmOFZ4TTgxMjJZV0ZaM0FMa3JiamFFamdaQ0c2V3d0WWk3V0Zj?=
 =?utf-8?B?WDRLeW1tcEVvUFp2RHlCdzQwckZ4UnQ4eUtxMVF3MzZCWjJmQXBUdVpCNUJQ?=
 =?utf-8?B?ZGtldHdpQTYwa0lRdFdyUjEvK2Q3RWVYSDVhWklnODMxVW92K2FqdGhhdlYy?=
 =?utf-8?B?b3ppYkYxdXdJZHd2aG5MU21vZTkrMTExYzBDbXEyNVFLMXlaek43VlNXRjE2?=
 =?utf-8?B?U2FBcDgxZCsrNjdPMkRlbndpRS8yYi9jUW5ucDZUT1N6ZVRVY2VEVElVYVl5?=
 =?utf-8?B?Sk1SMVA3UllIL0FXejE4Z3FGcWdTNHVsSzdXNk51T3BoenJIcXloRkZiWUUy?=
 =?utf-8?B?by9JSkNmYy85VTBTQjVIOU5ZZTN3cUduSlB6dnlEb2J3MG01RFpndWJybk9p?=
 =?utf-8?B?Si85ZUp1Q1BUZWVhOUJ4ZzBrUE1lM0VqY3FDbkR3VzNRemtBS2hMVGxuMUNH?=
 =?utf-8?B?bkRDNjA3ckFXU0ZaSjBwQVoxUnEwVjRVT1ZOYmorbU50WUY3aVJ0ajc4UkFq?=
 =?utf-8?B?M3I2WHM4TEQ4a3lWWWNGSUM3dU5oTmFpV3BLL0VXSTAyR0lDeGFVcVRkRnhK?=
 =?utf-8?B?alpqS0daUHEzV3ZTeTdQWmZaenpnRW9LQ2h3eDhzbUNYYVUwOCswMnJXcTJL?=
 =?utf-8?B?NldiY3BrWWxpSWRmU1VTT2FzdjU1UndaWUVkRmlmQUt6bFBXcEh6NXJDaHVw?=
 =?utf-8?B?STNQWXJSZGdWYjRPS2FKSEpSQmZSWU1ZemF2SzFrY0FpY0FEaUk4bVRPY2RT?=
 =?utf-8?B?OTExSjdYWitNN0NJcHNGbjNITTVMY2VBT1kvOUJ5MmV2bUtKNWpxNGRqcSts?=
 =?utf-8?B?M05CQzhFQWpoZUZzcmZFQVd6cFVBY2JrQzNBSStIckZMV2Q3N0NTVHA4Zjlp?=
 =?utf-8?B?T2ptSkFhNXY4amFOUnN3T1NxWGVmQ3Yxc0VSSEdSakcxaHNTb3NhTkdEVndt?=
 =?utf-8?Q?KSYHzen5k9U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TmJ1a2IzMFNsZW1jRTZkd1ErWWdtQ1hyVE9hVUt6N0tIK3R4dmJsd2RPYkZu?=
 =?utf-8?B?aWgwUWswWGQ3V1puSXpVNzk3SFU3MmhYSFVYL3VQS3BBTWV0TUtTQlFtd1Yw?=
 =?utf-8?B?YXlMNFpYR1YwREVralhrRHViU1FKUnJjYmxzbVBpRmtuN0FLUHNuNTdtL3F6?=
 =?utf-8?B?YmtmZWRtbUtjT0R6UzVoY0ZhRGNid1gwaVVyVDlwczVGR2JHbXFxTnRzbmtr?=
 =?utf-8?B?Zm1NSE5KL2FnZFBvNUlaN21wYzFIbjBZUVhSc0RxRGJBYWdweDdNM0h4OXVW?=
 =?utf-8?B?RFRvWWZndW9iUCtmZ2NrMHA4ajZoVUlXcFlwRjBWSys3clZyT04wSlp5K2No?=
 =?utf-8?B?QjBpeHpMR0NaZ01CYno2ZktpZjhwWVNZQXl5bno5aEFZRmwzNndzSk5OTWRt?=
 =?utf-8?B?bGpNRlVSOERxSVJmS0RyL29pN29XUFUreHhSeUMrNU5oWSs5SWhvVDgvMFZD?=
 =?utf-8?B?RzBBdys5UThvK3JxTFYvRk8yd2tqV1F5STZFcjh0V0ZqMFhpUklQRWdQRllk?=
 =?utf-8?B?Sjd5S2tWclFZYTRheGpFNzNWSzJlVjJmYW10M1dDYklXREtXK2trQkF3T1dI?=
 =?utf-8?B?UVhFcVM2VStKa0J2RkJxOFZWc2RFbzIyc0dxSnVNMTdJSFljRndwUldZclZw?=
 =?utf-8?B?aFpNeGM1WWlsVUtlSlVjSHRmd1VGYVFOSmE2MkhpOUt3bGxNSGFsTmNuOHJY?=
 =?utf-8?B?a0FFZEVYRDJnelVVZ3JOWkhjcVRiaGVqYlpiTnBFZEN0VGdxWlBVN0F3K3dl?=
 =?utf-8?B?U2pjcjAyNFdCUnhWcC8zK0ZZbDd3d3BzM0xCR3Q3N3YyRVV6NFM4RkVRdkFF?=
 =?utf-8?B?ZGJkQ1V5MnNraklLaHVUaUNCbEdHUGZZUnUzUnNzKytFbURodmJ4ZmkyaXJv?=
 =?utf-8?B?WkVKVW1VNks4R0dEaXUrRTgyeG1iUU5oeEVmRUV0eU5PR1hFeVRxc21RZ0N4?=
 =?utf-8?B?dXF0RWNVQ1pxWFdnWjF4UlIyRElYSWI3bG56SnZuNUQxUUwybEsza1dFd09j?=
 =?utf-8?B?SE5PdElKL050cVQrdWo4d1J5WFd3RDREZFBYRWF4R1owSzJ6V2llRVNIQmwz?=
 =?utf-8?B?alVMY3JoYWRRaGpSM0FkVSsyUDA0c3hpenhMTmwvZG5KWDZsNGFVUFV3Y1J4?=
 =?utf-8?B?VnlnTEdGOHFGOExCL0pRSmZDZGNaNkp2aFJkODYxNk9LNWZvbzhuNGI0YWJ4?=
 =?utf-8?B?ZnYvSUwxMFI3SWZraTZ3YnBwT1FveSsveGZKT3NXZzhzektKbWEzUXBwU2gr?=
 =?utf-8?B?RVhzZWpkQmJ1bS9CaUl3SWgyUUY5SVc4ekx1MHZ5S2c2YXo0U0MwZFh5eFA4?=
 =?utf-8?B?aUd3UFZGZHJNRU1IblIyQmY0bXFBakNNUHRmZFVNaGFJaFVHOHNrWk9jM1FR?=
 =?utf-8?B?MHFveG1HRzI3M21zYm9TTDZ5Q0d4SVhIN25Ub0hRZUVPYmM5eUcvRGtvY3la?=
 =?utf-8?B?UG9KL2JRM0U4M1o5ak9uTGpnSk9vdzBWS2pIYzlVclF3eE15TjJJMkxHbHpE?=
 =?utf-8?B?MjJWdVFiM0h0Y1lsRGhtZGl4K3pudUpHcGtleEVTcFhsUE1nVDhBa1kzb1A1?=
 =?utf-8?B?bElsakQ0MDZrdGxoaW1DNkNLWm93Vi85ellEVGhQQ016VmpiS3FldVpxaTZG?=
 =?utf-8?B?M1B0SGhoaERxNE15Y0pjQ3I0OTlvSmsyTTBnc1FmWUdoam5XU0VLdmh3M1FU?=
 =?utf-8?B?R2JJd2duL2VadjNmK3Q4V1NUQzh2cnRmQ2V1UWVzbFpLQWZzbmFpdXQwS3Vr?=
 =?utf-8?B?ZGhUdkhXMFRMVUxwdWZlK01xaEk3SXNUc29wRWNZZCszb1BoazQvY0NaOEVx?=
 =?utf-8?B?K2FYOHJGdTQ5UUxhVDBWQTdFeTdCQ0YxL3JvTWlkT204cG5pU1ExYTRzcFZx?=
 =?utf-8?B?YzdheU9SZlVtWXJuUk8yNFg1b2NvcnZiZGFWZFZ6eUtHYTJOUHkvVjVUdzg3?=
 =?utf-8?B?NUNZUDlYbHNhaDBUTlhPdkpnTDdaVTFVUXB3bzVhaGk1N2lvTWw1dEdnakls?=
 =?utf-8?B?b0xJSmsyZlkwdWFqVzhKcUZjQnlCeUc3RXpPT3dXRW4vWWlSL3Juc3VZTFJP?=
 =?utf-8?B?dTFTMTg0bXRZaVZVR2FpKzU5OWxEWmVtUTFIbEpBZkZ5MXo4MGI5d25CK3lK?=
 =?utf-8?Q?lQBC8h5eglm7PvdN+JbPX2AtG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4de7f204-aefd-4893-065d-08dd2654bc6c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 08:59:13.8606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OZjSCpSEw2A4l9+XcnNgCqFR3Q3IHvjBUM+YhIBOUnGg/0x/F7qCUlujXv0Bz37YPlESErOJsoXbGPY+pHgLtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6987

On 17/12/24 10:57, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Modify the behavior of implicit SEV initialization in some of the
> SEV ioctls to do both SEV initialization and shutdown and adds
> implicit SNP initialization and shutdown to some of the SNP ioctls
> so that the change of SEV/SNP platform initialization not being
> done during PSP driver probe time does not break userspace tools
> such as sevtool, etc.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   drivers/crypto/ccp/sev-dev.c | 149 +++++++++++++++++++++++++++++------
>   1 file changed, 125 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 1c1c33d3ed9a..0ec2e8191583 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1454,7 +1454,8 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
>   static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
> -	int rc;
> +	bool shutdown_required = false;
> +	int rc, ret, error;
>   
>   	if (!writable)
>   		return -EPERM;
> @@ -1463,19 +1464,30 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool wr
>   		rc = __sev_platform_init_locked(&argp->error);
>   		if (rc)
>   			return rc;
> +		shutdown_required = true;
> +	}
> +
> +	rc = __sev_do_cmd_locked(cmd, NULL, &argp->error);
> +
> +	if (shutdown_required) {
> +		ret = __sev_platform_shutdown_locked(&error);
> +		if (ret)
> +			dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
> +				error, ret);
>   	}
>   
> -	return __sev_do_cmd_locked(cmd, NULL, &argp->error);
> +	return rc;
>   }
>   
>   static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
>   	struct sev_user_data_pek_csr input;
> +	bool shutdown_required = false;
>   	struct sev_data_pek_csr data;
>   	void __user *input_address;
> +	int ret, rc, error;
>   	void *blob = NULL;
> -	int ret;
>   
>   	if (!writable)
>   		return -EPERM;
> @@ -1506,6 +1518,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>   		ret = __sev_platform_init_locked(&argp->error);
>   		if (ret)
>   			goto e_free_blob;
> +		shutdown_required = true;
>   	}
>   
>   	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
> @@ -1524,6 +1537,13 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>   	}
>   
>   e_free_blob:
> +	if (shutdown_required) {
> +		rc = __sev_platform_shutdown_locked(&error);
> +		if (rc)
> +			dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
> +				error, rc);
> +	}
> +
>   	kfree(blob);
>   	return ret;
>   }
> @@ -1739,8 +1759,9 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>   	struct sev_device *sev = psp_master->sev_data;
>   	struct sev_user_data_pek_cert_import input;
>   	struct sev_data_pek_cert_import data;
> +	bool shutdown_required = false;
>   	void *pek_blob, *oca_blob;
> -	int ret;
> +	int ret, rc, error;
>   
>   	if (!writable)
>   		return -EPERM;
> @@ -1772,11 +1793,19 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>   		ret = __sev_platform_init_locked(&argp->error);
>   		if (ret)
>   			goto e_free_oca;
> +		shutdown_required = true;
>   	}
>   
>   	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
>   
>   e_free_oca:
> +	if (shutdown_required) {
> +		rc = __sev_platform_shutdown_locked(&error);
> +		if (rc)
> +			dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
> +				error, rc);
> +	}
> +
>   	kfree(oca_blob);
>   e_free_pek:
>   	kfree(pek_blob);
> @@ -1893,17 +1922,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>   	struct sev_data_pdh_cert_export data;
>   	void __user *input_cert_chain_address;
>   	void __user *input_pdh_cert_address;
> -	int ret;
> -
> -	/* If platform is not in INIT state then transition it to INIT. */
> -	if (sev->state != SEV_STATE_INIT) {
> -		if (!writable)
> -			return -EPERM;
> -
> -		ret = __sev_platform_init_locked(&argp->error);
> -		if (ret)
> -			return ret;
> -	}
> +	bool shutdown_required = false;
> +	int ret, rc, error;
>   
>   	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>   		return -EFAULT;
> @@ -1944,6 +1964,16 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>   	data.cert_chain_len = input.cert_chain_len;
>   
>   cmd:
> +	/* If platform is not in INIT state then transition it to INIT. */
> +	if (sev->state != SEV_STATE_INIT) {
> +		if (!writable)
> +			return -EPERM;

goto e_free_cert, not return, otherwise leaks memory.


> +		ret = __sev_platform_init_locked(&argp->error);
> +		if (ret)
> +			goto e_free_cert;
> +		shutdown_required = true;
> +	}
> +
>   	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
>   
>   	/* If we query the length, FW responded with expected data. */
> @@ -1970,6 +2000,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>   	}
>   
>   e_free_cert:
> +	if (shutdown_required) {
> +		rc = __sev_platform_shutdown_locked(&error);
> +		if (rc)
> +			dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
> +				error, rc);
> +	}
> +
>   	kfree(cert_blob);
>   e_free_pdh:
>   	kfree(pdh_blob);
> @@ -1979,12 +2016,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>   static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
> +	bool shutdown_required = false;
>   	struct sev_data_snp_addr buf;
>   	struct page *status_page;
> +	int ret, rc, error;
>   	void *data;
> -	int ret;
>   
> -	if (!sev->snp_initialized || !argp->data)
> +	if (!argp->data)
>   		return -EINVAL;
>   
>   	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
> @@ -1993,6 +2031,13 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>   
>   	data = page_address(status_page);
>   
> +	if (!sev->snp_initialized) {
> +		ret = __sev_snp_init_locked(&argp->error);
> +		if (ret)
> +			goto cleanup;
> +		shutdown_required = true;
> +	}
> +
>   	/*
>   	 * Firmware expects status page to be in firmware-owned state, otherwise
>   	 * it will report firmware error code INVALID_PAGE_STATE (0x1A).
> @@ -2021,6 +2066,13 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>   		ret = -EFAULT;
>   
>   cleanup:
> +	if (shutdown_required) {
> +		rc = __sev_snp_shutdown_locked(&error, false);
> +		if (rc)
> +			dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
> +				error, rc);
> +	}
> +
>   	__free_pages(status_page, 0);
>   	return ret;
>   }
> @@ -2029,21 +2081,38 @@ static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
>   	struct sev_data_snp_commit buf;
> +	bool shutdown_required = false;
> +	int ret, rc, error;
>   
> -	if (!sev->snp_initialized)
> -		return -EINVAL;
> +	if (!sev->snp_initialized) {
> +		ret = __sev_snp_init_locked(&argp->error);
> +		if (ret)
> +			return ret;
> +		shutdown_required = true;
> +	}
>   
>   	buf.len = sizeof(buf);
>   
> -	return __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
> +
> +	if (shutdown_required) {
> +		rc = __sev_snp_shutdown_locked(&error, false);
> +		if (rc)
> +			dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
> +				error, rc);
> +	}
> +
> +	return ret;
>   }
>   
>   static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
>   	struct sev_user_data_snp_config config;
> +	bool shutdown_required = false;
> +	int ret, rc, error;
>   
> -	if (!sev->snp_initialized || !argp->data)
> +	if (!argp->data)
>   		return -EINVAL;
>   
>   	if (!writable)
> @@ -2052,17 +2121,34 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
>   	if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
>   		return -EFAULT;
>   
> -	return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
> +	if (!sev->snp_initialized) {
> +		ret = __sev_snp_init_locked(&argp->error);
> +		if (ret)
> +			return ret;
> +		shutdown_required = true;
> +	}
> +
> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
> +
> +	if (shutdown_required) {
> +		rc = __sev_snp_shutdown_locked(&error, false);
> +		if (rc)
> +			dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
> +				error, rc);
> +	}
> +
> +	return ret;
>   }
>   
>   static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
>   	struct sev_user_data_snp_vlek_load input;
> +	bool shutdown_required = false;
> +	int ret, rc, error;
>   	void *blob;
> -	int ret;
>   
> -	if (!sev->snp_initialized || !argp->data)
> +	if (!argp->data)
>   		return -EINVAL;
>   
>   	if (!writable)
> @@ -2081,8 +2167,23 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>   
>   	input.vlek_wrapped_address = __psp_pa(blob);
>   
> +	if (!sev->snp_initialized) {
> +		ret = __sev_snp_init_locked(&argp->error);
> +		if (ret)
> +			goto cleanup;
> +		shutdown_required = true;
> +	}
> +
>   	ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
>   
> +	if (shutdown_required) {
> +		rc = __sev_snp_shutdown_locked(&error, false);
> +		if (rc)
> +			dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
> +				error, rc);
> +	}


It is the same template 8 times, I'd declare rc and error inside the "if 
(shutdown_required)" scope or even drop them and error messages as 
__sev_snp_shutdown_locked() prints dev_err() anyway.

if (shutdown_required)
	__sev_snp_shutdown_locked(&error, false);

and that's it. Thanks,

> +
> +cleanup:
>   	kfree(blob);
>   
>   	return ret;

-- 
Alexey


