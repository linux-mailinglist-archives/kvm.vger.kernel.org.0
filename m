Return-Path: <kvm+bounces-52523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 775F8B06451
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 18:27:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C1B03A6DB5
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 16:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E65CB27381D;
	Tue, 15 Jul 2025 16:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fibHgnXG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2045.outbound.protection.outlook.com [40.107.94.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977AD23909F;
	Tue, 15 Jul 2025 16:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752596806; cv=fail; b=Ouk4hcWapKlv8RRih6lTh3WLKEeh3L7LKB26D9pZvl68cqJC7L9ShBMo8OBYiJXw8HM8KEzcuK+fZS5iLPYD5qkW3PfhHiIu4mUTIHJ6djK179Kak2oGjgIrrCcgF8abAkVD+clkWFq90v8KgFEBsRchN2wHVKrKE6kCiof3uyk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752596806; c=relaxed/simple;
	bh=bprUVglj3gfIoLS7sXAJOiHPw75/yFhPXJ5Ukq6pmg4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TY4oMdI42OtwW2zufKNcNZBzcovV9zrrZ1aLqZkRCo31a9FV2IIaeBFR+jmjwZqZ1ZnFDNeyFlur2XM7EUsc3FCYsT6zWQrMm0jPUkYmgOHY3sDCB4DOXxz6Hu/dH9Giip2aMphEPC8mWSRd1A8Yw5TqH/WUpvIvE77B7qmABfI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fibHgnXG; arc=fail smtp.client-ip=40.107.94.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lJ0MNj652hsJai7eDygV57k24Tx7qbughZniyl1aVLZ71ANy2bnD6or3Y9p46tG5GUUu86Kz5Y7PdHqcGaHtHd4jCTKMfMpIzi6lGdjNjbW0TJagDT99002GychSb4aP+9k0d2qv/F5cQ4ebSqgpN8iSpT0EQ4vgXSCkhLcQSe6dBr911p9E7HGY+n30ShrWCmP229j7uWFWW1g8ro9f8Q80YrkfKKD/2ZYCA2/EmKVEtd1AEGsNZLMXqVBywhraSr5/lsjkhZqxTOFAqBNbsFHG1iMMk+7huyOXEvMJCsKcCHCnrQtXD4Z1WfkuXYvavY+Js/V65YgffmZQSeGY2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pb62B8xcMmLO/4cyXnc3ChQ6dMl/DlpfD+ATqk0iUfE=;
 b=MNq4axnJA2M6A1rwLLdGZbnQkIUU9TVc5C2+oYeIzQfM0V0BOSjJ6upgeb6y0/oyjIL8HxPi4ckUMxeqJdXRnc0z3IAIN5UFcUpJzp8hTEBwbY7FMdYHyPZOpzV0XlDmr1WT8VU1kP1flV4EI5JOnxBjOoJfiR6qI3GjVYHTjSPBqUbizzLkW56PL7aiBRM8bMNamwfYfUYdDnsfkhjTXRDtkKTP5lus/NsmflGet0EhzmauuHp+o9tV/t/XrEz6GAuoDs5UYaPcIQgioR2eVvAdYO/Raz7lOSht1GKF+fwH0Jh5Lk5h/PkH//UJTTKAv3bcZNxyMPh6w0apuFog8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pb62B8xcMmLO/4cyXnc3ChQ6dMl/DlpfD+ATqk0iUfE=;
 b=fibHgnXGXaqOsNOFTa+ogjQms4WeGTQWSSnYbZzDxXwQ1eS/DpddghpCjPsWp3M4QVH+fw2ig+EvYFkYfcrbnXObVGazC1kFeb+pbthjIL/1UOA7ajpU5iRO7aRlKY1uYRvBvlq2X+vUFRjZ9Y6wNNfsa7Ans7EAfdqohYextYU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA1PR12MB7224.namprd12.prod.outlook.com (2603:10b6:806:2bb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.23; Tue, 15 Jul
 2025 16:26:41 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8901.023; Tue, 15 Jul 2025
 16:26:41 +0000
Message-ID: <844bdbc0-3e20-17bc-e219-2a935ca46d52@amd.com>
Date: Tue, 15 Jul 2025 11:26:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 4/7] crypto: ccp - Introduce new API interface to
 indicate SEV-SNP Ciphertext hiding feature
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org
Cc: nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, arnd@arndb.de, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <cover.1752531191.git.ashish.kalra@amd.com>
 <2afb8bf011d6d40419b880303f4556299a1a2c46.1752531191.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <2afb8bf011d6d40419b880303f4556299a1a2c46.1752531191.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::26) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA1PR12MB7224:EE_
X-MS-Office365-Filtering-Correlation-Id: 94218e03-9c72-4ae9-b93b-08ddc3bc6149
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MHJhM3ZFQlc1WFJxbmY3ZW9UYXk5ZEJ1aHowdDgzMmJ1SzRrTzZPU0hwSTBn?=
 =?utf-8?B?bDFGT0RiMzN4QjFQOWpadmhSdnZ4ZmUrNFVYOUZLQmlLRU1xcHIvMXJJaVU2?=
 =?utf-8?B?VUNMQ28zVUE0QlFIRG53b01xanBGU1hvYzZxTFNGZHhrSGpRVGZPMG94WVVv?=
 =?utf-8?B?aVhUWUttemY0QlBoUzZmK2wvTXROaThIeVJIdVgwYkh4Unp4eHQwNWw3ZnRH?=
 =?utf-8?B?OHZJRlZEY0kyNTFiTUpsS0dLK2FCQ1pkRldncjFHRkxrS2tsYWRCVElkRzVD?=
 =?utf-8?B?aUxKM2lUQjRGQXdwVmpDc0hNTDZDNlY3NndNK2tYcS9XOWhPZjhhN2Z6dG1F?=
 =?utf-8?B?UGQ3Y2wyclQxY2tuYzhWN2lSYjlWTmcxcFFMRGNJUFdJbjNmTUgveDlpVDZr?=
 =?utf-8?B?cXhpa2g1OFEwSW9RM3JuR0dvVEZnUlNsUEtIN0MrdVF6UnkvY0dxMmVNT1Aw?=
 =?utf-8?B?WXJJUlppd2c4dE1jQUY3L3ZjVmVnTVNsN1NNdDVWNjJJSE5UaHNEZVRaWHVh?=
 =?utf-8?B?dGYwQk9BYUNJM1pCWEo4bWNsa1QyTzZtcWNwOUQ5V3pUVzVDTXdwNmIzcnla?=
 =?utf-8?B?RmNRdlV2NWtVV3NkTUphdGRIUlFjNjlxeERMSkZ2UkRGZ1IrdUR2R3BLU2RG?=
 =?utf-8?B?SlJVY0VuSk5XclpILzExK1R0VmxQQ1R5SG9hTDJsbTZXVWJUbENJM05MVVVw?=
 =?utf-8?B?VFpQdUZZcVdQbXV6alE0bENtbDZrR0I4ZkNOOWZ3TVM5S0JFeG42dCttazc4?=
 =?utf-8?B?U3JZdTE4YmJWUk95dFR4VUQwOFB1SVo0MWdwMi9pVXN6c2FaTlpXWmdLeXBJ?=
 =?utf-8?B?N0FDNUtvOERQYktqYmFBUzVobmlyQmFDZFNOOE1yMUpCcWNrUkpyc3R6MXM3?=
 =?utf-8?B?ZEhGT0dYZXQyZ0VacW9MTWpKWDR1dTUvQ0dCd3NvUStORERhZlZON2FDa1o4?=
 =?utf-8?B?K3hYWWh6cms3ZjFGdVBtYjJRcmcvc1Zwc1U4eG5oSy8rc2tSREg4d25UQk9C?=
 =?utf-8?B?VDJGS09HN0tydFhzVDFTR0JrdUZHN3RrTXJFSlJlY0FZYmRrM3ZOUGc3Q0cv?=
 =?utf-8?B?SUVwQWdkVjV5dm04OGVNMnlNdGVRWUJKeGRYMXJnVmhtTE9ua1RPdXIrSEZT?=
 =?utf-8?B?UW5yb3h6cW4vaDAwTUdXdnZWeWFsQi9BeHlwa29hQy91NExKaUhQRk1rVzFR?=
 =?utf-8?B?RDBzMjgzTDhrYXowak5wYWl5RGhaWGIrMXhqKzZQL1FPZ092V2xEUUlKNUxU?=
 =?utf-8?B?YkVNOThIWlVsYk1BUUVWenNIR2dsVDdxOHo0NG0yd1BxWHZaS2RHUVZvRTNW?=
 =?utf-8?B?NUhVRmExeXRUL01LUzRtdXFReGZZVXA5YnFCNC80SllSTyszNlFlNGs2VGZL?=
 =?utf-8?B?RkhCYkRnV25wZVRvTU9LTDV4ZTRNVFJ6UzE4U0ZvckpYQXN0Sm11M1cwQjJu?=
 =?utf-8?B?dm13dDlsalZhQ2YyQjFVVFZ6R0V1VkZnWHBKQnQ3TC85N2hTMjgrTnlFL0JL?=
 =?utf-8?B?ZXpmWklMVVZrVlFtbW5lUTZON2g4S1R4K0R5SkR0eTk2RlJPdndWbkMrcFpJ?=
 =?utf-8?B?QjRTNmtCQTNwWDZXajdHK1VwM1VzZ256NmlSZ0thalphMnJWVUVqaStIY0U3?=
 =?utf-8?B?YWhvcVdoazVsdE5KZkRLUng1cTJDZjMyZjhHMnZpcHgvbTQ2Y0FpSytjWFZD?=
 =?utf-8?B?SWNjYWdYOENBVVB0NHg1QUxab0xHZVQwOE8vY1JDSTA2ZkhRNUgyMHRDK2Z5?=
 =?utf-8?B?ajJoU1FaNWFKWDFsZVBNeWFvSTA0b2gzZWhhWlVjem1nK3N6Ym4vbXV6S3p1?=
 =?utf-8?B?YWR1RlBDeGliOWVwV3Npd3NydHQvL2RqeDhwNm1IMk9nUndXaVNIckxHK0FJ?=
 =?utf-8?B?YkNTWlpZaGpaa0VjZHVmY0JIL3hPR0VIbTk4VG9jRWRqRDZqVlpqQ3BPZkJl?=
 =?utf-8?B?YXdDaXg1UWx1Qmd4S3M1Y1NHaEMrMWZCUm9OQnF0YUVXZnYyUzRFMFJxR2Zi?=
 =?utf-8?B?OWlTOTh5UFVRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aGRoNUpWRVE2MDhKMWdpbnRMZHkwaVFlMHVmWTg2emhzS0lSbEFKcmhwSjlE?=
 =?utf-8?B?cW8vNllXUGxWOE5hNzJsak1xcmtQazdvcnVnV0N4dmNnKzdicHlRTm12aVFk?=
 =?utf-8?B?VHF6Ylo3TUEvYlU1TTdUWUYxOGhnUExEODdvNXRJbnZrcXRNR0hWVE1LdTVP?=
 =?utf-8?B?ZHFVZkdSMk91RG5wUWNUbXB5S3dHRnZnTFBqSS8rTk16VEdzaTVzblBsa0JU?=
 =?utf-8?B?VUtzRG1aQUErQWNFSFc1N1hxUHF5dzZ3QXVTVGZiQ2dFM2lnWm9haWFONEs3?=
 =?utf-8?B?b2dsMTFDWjhWemFqYkJoVk1qSWNSVi82czNKVmhFZ3JwYW5FUUYvcUJGLzZV?=
 =?utf-8?B?MzZCWG5tZEk5dDJ4Z0xHcnVSUVljcm1zSE1Vb1hHZUlKS1BycFJNa2xGY1Ez?=
 =?utf-8?B?SHR0aEUrWmc3dFkrbWFuTUZvMXAwRTZ3VjFEK3c0UGFVaGYwYklPTEJHMkdC?=
 =?utf-8?B?d0FBR29HQ2RwMkk2VjI5bXZZditQOWM1WUJabkpWVUxEeTdKUExyK1JQVFJk?=
 =?utf-8?B?bmFZdVo4QTJQVlZRV0RPTzJ1WWgwK2V2RlR1YmJkMlZ2dnl2cGFIMnNRTSt0?=
 =?utf-8?B?V0NLTkFodTJMUTliU01QZUF2M1B2ckwzbEtWYnN6VXA4VUdnU3BPaE1PSFR5?=
 =?utf-8?B?L0g4QjJnSzdGRmNzNDFBMTN3Z2VSaGdSMGZPSGE1NnF6RnNLUk1kMnhrbXkr?=
 =?utf-8?B?SGJiNStOMzMrT2cvbUc5WDFycEtDS1ZIek10cW90dGNrUHBhZXJxdzkxVEtX?=
 =?utf-8?B?ZVJCY3lDV3RKNXlkdDFMWmYraDFobm81OGtncVdqRnBXY3BWcVV6RlYzb3lF?=
 =?utf-8?B?d1ExdlFXWllGR2FuM0JKbkI2Tkg5aXVCeXJPZDNKREsvUXRlbXl1RThEOXl3?=
 =?utf-8?B?bmh1eEZMczFoOVVoWnR4RXh3NE9pUDNSMFBrZ3hzeElybmhqYTgzZHBhNmdr?=
 =?utf-8?B?TkpWVkd6clFweUlkUGxxSFR2a2hFMEVpdjF2RlFZZzlKR2liUEVDNDhPRlh3?=
 =?utf-8?B?RVRuaE5VQTZaTFoyd0ZrV2U1Kzd1Wnd0Q0p3dXhKVWlkaHNMQmozbWxvaFVE?=
 =?utf-8?B?VDVzbjNrOFAybnZ3ZnNmKzJ3U2ZZa2JmajNUSlZWLzFXc1FNeEVQeVlKTGwx?=
 =?utf-8?B?SW0wcUJFTU4xT2Q1UzdqUWtiYVlhNWRjcWNZYVBJN2hSZXd6NFcxbHBmcG9Z?=
 =?utf-8?B?YTdYYXhSMGYwb1F3c1g2TWpYYTRhTEZKbStQRllzeTRmS1ZmQWdQalFYRWdO?=
 =?utf-8?B?eTRnbXdrT2UxT2FjQVpZWFpJWUlwV2w1NFM1WW9YTXhrUDN1eW9ZK0JjRTRp?=
 =?utf-8?B?YmhoRUkyb0lkREdsU2Zyd2liNk1jS204Y2dtTGVGUFRjNlI3VXV5cWNOWUVG?=
 =?utf-8?B?UE1VbHBOcTlFZzYwS3pBbThoS2lrZ3hhSHJIR25qL0dhL1JGem1pdGY2UklP?=
 =?utf-8?B?RzUzZW1VeFlwNGNaY3RsTmtSVEZyUGJJaWdRNXhxbVdJWTFUOVptQVFUZEI1?=
 =?utf-8?B?dmVyVWpIRmpDRExiclNMUDNxRXJZaXFoMUZEQXhuUzN6djc1YTZmUkZ5SHZn?=
 =?utf-8?B?d1VsMENhbGoxd3RURW1odnpITHRzMS9RZkdUNGJKdzJWZGlvR3E2MHZIN3V3?=
 =?utf-8?B?cUFWOXMwdlhRZnArcTJmamRGWXJDM2hGTnN2TldoMEoreFVaWjF4eXg3djY3?=
 =?utf-8?B?KzR4c3F0OFRweGNtSWVGZUhyR05MUHQram1nTlYxLzVoNGEvN3FhU3pFUWdL?=
 =?utf-8?B?MlB4Vi85bmVPU0xJR0Y5dVZDRVNpZmdlanE0ZXRtdjVreVI2eE9NRlcyV0ps?=
 =?utf-8?B?akNBSklFd3JiV2JjSmNJTmRsVGViYnpoUlhkTUZVL2VOQndLSmZVYjJsV3pq?=
 =?utf-8?B?Rms4R0QwMmZlUTRFZHl1Y05rSXdvOStWbnJLMWJzVHp5UDVhcnhLT3dTaDli?=
 =?utf-8?B?QnVpU1lTVEQwRXNXZnBzOU1NeDFTSmxVZzRTN2Z6UEZlWFY2cnVBUjRwb0xu?=
 =?utf-8?B?T2Qrc3BEY2w2RXRodTNSdSt3cDhScllpRUFmS285QlY0U2hiRjhDQzdLZ1lV?=
 =?utf-8?B?TEJtbVUxaVpPQ0xBckpsQ0JLLzRuTkV0M0JpeERWVUE4MnBmTTBQOHNHVlJY?=
 =?utf-8?Q?IUNekxdUsr3aA578sFwogpoU5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94218e03-9c72-4ae9-b93b-08ddc3bc6149
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 16:26:41.2171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fPZXo5SZe6l9jSdGqioonxUzUPQdg/swJb1Wikz6mPk+VQDpfdMa+BscTDiBpSVy/L+nyD+1UlpAje//Fkoprg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7224

On 7/14/25 17:40, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Implement an API that checks the overall feature support for SEV-SNP
> ciphertext hiding.
> 
> This API verifies both the support of the SEV firmware for the feature
> and its enablement in the platform's BIOS.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 21 +++++++++++++++++++++
>  include/linux/psp-sev.h      |  5 +++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 8f4e22751bc4..ed18cd113724 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1074,6 +1074,27 @@ static void snp_set_hsave_pa(void *arg)
>  	wrmsrq(MSR_VM_HSAVE_PA, 0);
>  }
>  
> +bool sev_is_snp_ciphertext_hiding_supported(void)
> +{
> +	struct psp_device *psp = psp_master;
> +	struct sev_device *sev;
> +
> +	if (!psp || !psp->sev_data)
> +		return false;
> +
> +	sev = psp->sev_data;
> +
> +	/*
> +	 * Feature information indicates if CipherTextHiding feature is
> +	 * supported by the SEV firmware and additionally platform status
> +	 * indicates if CipherTextHiding feature is enabled in the
> +	 * Platform BIOS.
> +	 */
> +	return ((sev->snp_feat_info_0.ecx & SNP_CIPHER_TEXT_HIDING_SUPPORTED) &&
> +		 sev->snp_plat_status.ciphertext_hiding_cap);
> +}
> +EXPORT_SYMBOL_GPL(sev_is_snp_ciphertext_hiding_supported);
> +
>  static int snp_get_platform_data(struct sev_device *sev, int *error)
>  {
>  	struct sev_data_snp_feature_info snp_feat_info;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 5fb6ae0f51cc..d83185b4268b 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -843,6 +843,8 @@ struct snp_feature_info {
>  	u32 edx;
>  } __packed;
>  
> +#define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  
>  /**
> @@ -986,6 +988,7 @@ void *psp_copy_user_blob(u64 uaddr, u32 len);
>  void *snp_alloc_firmware_page(gfp_t mask);
>  void snp_free_firmware_page(void *addr);
>  void sev_platform_shutdown(void);
> +bool sev_is_snp_ciphertext_hiding_supported(void);
>  
>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
> @@ -1022,6 +1025,8 @@ static inline void snp_free_firmware_page(void *addr) { }
>  
>  static inline void sev_platform_shutdown(void) { }
>  
> +static inline bool sev_is_snp_ciphertext_hiding_supported(void) { return false; }
> +
>  #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
>  
>  #endif	/* __PSP_SEV_H__ */

