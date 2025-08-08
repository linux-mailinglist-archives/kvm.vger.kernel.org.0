Return-Path: <kvm+bounces-54334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 68C8AB1EE42
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 20:13:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EFF9A7A3751
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 18:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CD29274668;
	Fri,  8 Aug 2025 18:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Qj25JSB4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F26D1DA3D;
	Fri,  8 Aug 2025 18:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754676803; cv=fail; b=fNecJCf4CelgLyqxEGeqEcwA85bFcaHIWTu4MMHByzBm7tuYP34sCBwThL1cZCfhCS6c5ZsXKsrFUxU0Isaeo0HZkmkUGaMFytEBbC1g5z/2wnJ8v9NM0feYQuAlLUTFZpS6TgSw2a7UTHx744XGMSrw7y0erKau6gWq09t3eC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754676803; c=relaxed/simple;
	bh=l5Ygk3Sz/r+wn0O+rfSHLduSVdVh1W/+G+gOoCOhq2s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MVeTCFJNjd5AoJHO4+V27xzi2vb3+nHmjOrxKB1nI01N9ULLtFB4k/LflNCZUQpcagc33+tD7CEVrzjQnOZzn/VprpghrfMP7zM56QgLrEheEZVodoQ9H79NsM0ON386HXfC83l/zdMJdZS0zyTmgq0qItwduasjt6Wf7EQjSAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Qj25JSB4; arc=fail smtp.client-ip=40.107.93.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FJsja1l3EWKw799TfbOCr0KLm/P1T/tIX9vFwFvYLhNw5Zc8Dl5ayj7HLUsdlIcXY8QzxewfgY3FfUzSpb3jRr4+unFyuzdErIp3focXyuM9BNHbip/psYH+5IIlGQLCH5IRg00APgtTIA4WxdlYZ3B/lVgWczC8xXWeOY4tGVdiIpTclbrIpQk1ZrQ87FF8Y+yfBygCR4clbLJrbhYqYmDYrrVXxhhwh0D/dCYjrJ5oRQIbw9pPKnchZP3Qujnm7Ro/C9tnNJKCCy7xDph+2W9tTRHlcXpOKAySEWD359okPDspKtybhnHv4SnfOOsIhKpBUFacfygXAkzsmWizrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G+vBPS864Lq8dFL4u+2fFPan+Ppcls9a0vY/CJVgqWk=;
 b=xSmjoEWvXlCKG2n5I13jo6IyrflX+Oo5kx4LJriBhRsfha1p4gd0yYB33cL9U8DgvX+VbfBW+6VQfAzQwNPH6vdvPNDhMr3zJddP18KCPz3zcZdaE3LB7R/6xTNKoMOcs969fZiCoivZXzfnDeJzvMJBdI8/gwvjuxFC591NoktGzP77iUfJclyXYHi2qLSd+cv9+gNL/3mestgmXKqEmEekYm4hu8UWAUyuAKZH6Nl3hAt2L9nYVY5O0ZWCLK11ZCplRq7hMCm8FIvGIge1CpvBuh0inB7ZZ3ON8Qxz9gJDPmjlLZHE4CexgL2svNHKykJ3OZT7HOH5uSfnLnCyHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+vBPS864Lq8dFL4u+2fFPan+Ppcls9a0vY/CJVgqWk=;
 b=Qj25JSB4GsSE/FCknbAI0pPWIAL47ZiuDqdh10vbcj+MSTBg935jJr0fUHiJKfmLZ/hWhZbhv4GXfE3iQL2dB6Q3g9O6Nu1FiHqlFjtLVk1A02INs3vPiT2126ZY8XSvda57BLISmAZUi3l6H6JWBYaO/6LsoktWLjJrohWoCvI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SN7PR12MB7812.namprd12.prod.outlook.com (2603:10b6:806:329::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Fri, 8 Aug
 2025 18:13:19 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%6]) with mapi id 15.20.9009.017; Fri, 8 Aug 2025
 18:13:19 +0000
Message-ID: <f5f9925c-1d20-4b2f-a0df-082e8e011710@amd.com>
Date: Fri, 8 Aug 2025 13:13:16 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] x86/sev-es: Include XSS value in GHCB CPUID request
To: John Allen <john.allen@amd.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org, seanjc@google.com,
 pbonzini@redhat.com, dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com, mlevitsk@redhat.com, weijiang.yang@intel.com,
 chao.gao@intel.com, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
References: <20250806204659.59099-1-john.allen@amd.com>
 <20250806204659.59099-3-john.allen@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20250806204659.59099-3-john.allen@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0086.namprd04.prod.outlook.com
 (2603:10b6:806:121::31) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SN7PR12MB7812:EE_
X-MS-Office365-Filtering-Correlation-Id: f03e36a0-0203-4c0a-c290-08ddd6a740a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MlVVY1N1dVhMenpiQ1B2YjJIQUQzU3RxK3hYRmlGMUdsQW84c1pMbGgwc0dp?=
 =?utf-8?B?ZUZ4SDlNRE1tRGtOWkJqNENIM0w5Nm5rT1owdlgvbWk1QmwvK2hyVjBQOWNZ?=
 =?utf-8?B?K0hoNG1qZm5pZyt2MU02VWRXVURRd21UbFlZNUpBbXZEUFRHeFliOGJYMlhJ?=
 =?utf-8?B?cGFwc3h6NkZvMEtHV2tQS1ptMWdJSXFDcUhkYUFZdUREQzV0NUs4SWJWTTVI?=
 =?utf-8?B?RGVWaUVBSHJla3ZTSGI1UW9iNEpQNjRzZjdaNW5SZjlQWTE4MWp1d0h5aHI0?=
 =?utf-8?B?WXdKOGgzMks3MHd4SkRPQ3N1UGVJRXkxNVY3NHBOR3pWN1NSTDVtbWRCRzNx?=
 =?utf-8?B?OGUwa2pIaENhVy9EMHByWTVHUlNicTJjMDdGSyt4YWpvenhaYVJHWlpCbUcz?=
 =?utf-8?B?ZCtmSGFRbHYzQWVCa1l0enlRb016bUlBbDViY0NzN1FmcFh3L1YxaGRMK3Ri?=
 =?utf-8?B?NW1MbnJkM2svSEZKc0dyS2F2Ui94SWdJRFkvYmZrcTE3V0xCb3RNd0FjbjBa?=
 =?utf-8?B?Q1pOY3E0UzJwV3pZSXRPVzFNdFBnYVFoU0V5dSttbUdBVEkrVnVkRWhIY3Yy?=
 =?utf-8?B?bm5nKytiRFNvSlJLL1BaOVVwU3ZwVlQwL090elNUeTNKL3FqYXd3MDRHc3Ns?=
 =?utf-8?B?TkhZU1FFblU0aFdxamtNZG9GVnE3YTZzb0JGUVRSN0psN2ZCZXIvSWtPdEcw?=
 =?utf-8?B?ckJPZHN6SE1MU09OZ0xHb3NMN00xeDh5S0VFS2VTeXJoNXFLTGlGc1ZxRDg3?=
 =?utf-8?B?RGk1WllxSk1BcklZNXJMNW16KzlvYnBIcS8wYW01c3FlMEpqMGNjVUdqejBJ?=
 =?utf-8?B?OHl0VE1EczlCREZRbUlVdkgxTUlBTjBoeUtFODAvQXFQVHczQlkzUDdXZzlN?=
 =?utf-8?B?dzVUYWZiRlhFamQyWVNwSUU1Mlc2MGNDMG5IdkNIdXpreXVreXgxU2NOeGRO?=
 =?utf-8?B?N0RLMCt2d3VZUWVPZC9LL2pkZllJaVhPdG9NbzQ4M0cxK200NTBPeWVDWStO?=
 =?utf-8?B?N2NNRzdXVTVvSG5zWW9kdHROMUtKaU5vNS9CUDdqbXQ5dUhwZ3ZDZEVwbEQv?=
 =?utf-8?B?cXFlKzh3MkJEZktneVBpL0R1NWtvNzdxZEQ1S0xnWWJSQVVEODQ2dUNXbnlJ?=
 =?utf-8?B?NUdlSnhjMXlyaGwvZ01IMmhnNXhLcmpLWVNHdHlaQ013NVVtWGNKVFZLWTFq?=
 =?utf-8?B?SlRLOHJUOFdvTkVxZllWeUtjNlp0MUF4cXdqQ1VqQ1dOZDdEaGt4c20yWGll?=
 =?utf-8?B?V0hXdjdGbWZpYUJob05BQTVIWjc0RERoQzNLamtkT0hqZWpFcVhmTDIycEcz?=
 =?utf-8?B?cEdmTFZDaGdyMWpVQldYelNJNnMwdHJUMnV2dWdjY2NBY2RSdjlxajJpSk4x?=
 =?utf-8?B?blU4T2o3ZTdiRm1MOVRaSG5FdmZLOW9QRTd3a1pSeUlWbmticENKTXh6TFFN?=
 =?utf-8?B?a3gwWjNiK3BON0tOQXFKbzRXNjlpb0Vxczg2ajBpQzQwR3V2UUQwdS9teGhx?=
 =?utf-8?B?bW9IRlllelN4U1lLY0JQSHlrTFdpMUxuUjNMVzZGUHM4ZWFEZHk4b3hKTkVD?=
 =?utf-8?B?VVhZY05QQy9kb0RDNUtvRUZDRDQ4V0tVWHVqelZqYk1RQmI1S3NxaWN4aG4v?=
 =?utf-8?B?U2pwMzIyQUNTa2hjQVFablBMY1lPVyt4cVdnNW1IWWZvUmhXMlprWHJPQktl?=
 =?utf-8?B?WFNpNnErKzVBYThVcC93OVF5L1MvUEVISXRhWmZ0Nm1lZlZwS0o5dmxHbm01?=
 =?utf-8?B?bjFUNzlqR3JvYlZVS0VhZERaSzVCVGhlTVRCZ1JvNlhLcWVvOWsxV0l0aG9H?=
 =?utf-8?B?Z3NmZ2p5c3AxVjdhVzRIeVlhRU1wUk5EOEsvazlrdEQxSW1udmVlWmptUG5t?=
 =?utf-8?B?ajUyang3NHJrQ0d0UkRZSWFaQXo1eWxHWm1FZytaQkJIQUE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUE1bXhNUnNLeE9IR1ZMS3JnQjBnWjZUanhKelFGaGthbnV0MTNsOHBKYTFO?=
 =?utf-8?B?ektYY0xEMExsaTlQdmkrQklMTzQ3aTRqS1BtWEtmYnpMczNvbFJld05ZU0VQ?=
 =?utf-8?B?Tjc3SDAweElNbnZzVTE5Ukw3c1h2M2gyLzh4YVZSakFVS2JQeHBtMGJ3ejJL?=
 =?utf-8?B?UDlVWkN0czJiV0c4YzdlVkQ0MjFQM1JERDl0cGZJM3pRYXZ3SjVySGNkczlj?=
 =?utf-8?B?czNkekFGN1F3SzhkeHhoTU5VVXloeEhBTm16RmNlQXdqOGlPWFZHYjAxWnpp?=
 =?utf-8?B?d1hOdGJ3TWlYWnlFTitDM1BnaWZQYkJ6ZDR1ZUFBRnVtUjJmN0JCT2R6dm9P?=
 =?utf-8?B?NUlOL3BUYUMvWVFqRERtemNTcERLYW51L05vbnJINXB5OW1BLzE0dUxGT3F0?=
 =?utf-8?B?RGZUb3l6TC9NQTB6RUpFRXlsTXE4eTRqYTNOVmZHdzFSNUtJL0sxbVhWbUFD?=
 =?utf-8?B?U3dxUGlOdDNmVWdLL00rQjNQakt5a2hpOCsreElPSU15dWVwVVZIYjd4dVBw?=
 =?utf-8?B?Um1Xa2pxR1dGRGRzYldaYzBQRnhLVUo2ZFFTZzZHZ3ptR0ZQNFdnY3NXVENU?=
 =?utf-8?B?THhZM1FrdWNoSVlqMXNEL0RtWUE1YnVJQVlaWGpwZHFoTUJlUEd4a0NmcG9n?=
 =?utf-8?B?aHlLWXNBZlVBY2F1Q1p0bmFIY3dqRnZ0TllXZ3E0cXEvY1FWVmtHVVRsV29B?=
 =?utf-8?B?Vnk3NytKdmhiTW5ZdDgrek9FYkdPSFp2ZWdZSlAxM093M054RE9XQzZVZUk0?=
 =?utf-8?B?ZkcxMjFLenAvQzVVNGNoazR6aXdvQnY5WHVBMkZtc0ZsdmFxVjAvSkYra1pQ?=
 =?utf-8?B?S25hM2s2UnpiUWhTeTQwbEtMdm9ObnNzNDFnYTFndXJLNWxIejlKZVhzRGIz?=
 =?utf-8?B?QnhDaUZZa3J0QjllODlYUXBPc1RKblBXamVNRVczK0s0WkhSc1BIN0NoV1BI?=
 =?utf-8?B?bTEvZk16NzREVHA2SUNQSzZsVURQVThNelJqS0NaRDV5WXQ4K1FOMUpXUnZa?=
 =?utf-8?B?RTJyWE9RdHRxUVROUnE5SWU1U3ZsRC9PVjVLN3d6Wlg2NC85SXkrNFY3SXpD?=
 =?utf-8?B?Y0lrSkxWTkcwWVgwVVRxb0JmZ0M3b3R2VVFRd3ZKSHgrSXJwZ2lWZ3RQRXVh?=
 =?utf-8?B?VFhpVGJwcGFSbFdHRldYK0oyazBrS2pxVng0QWorczUyaGRlVUVhSm9BSGRu?=
 =?utf-8?B?U2RhSk1EN3dzNHl0emJNbEVxcTBISnQ4YUxvYWV3Y3JQUEd6dnlQS1g5Sm9C?=
 =?utf-8?B?cDFBd0ZIWGdLUFhOa1lCVkpZZlA2c1NWK2Mza0c0TWlpZTBCaUMvWGd2a1ZR?=
 =?utf-8?B?cFhRQjNNUnIyV2laWUFEaktEcWlQVmtLdFVQYlZvTmkvbTN5a0owVENYVXMr?=
 =?utf-8?B?bjRUaG9HeldLR2tSTDNkWkNzcGwzWXFSQTAvSFZtaFh5a3hkdmh0SW5RVzdw?=
 =?utf-8?B?TCtYeDNTQVpFQVBrYnUzM3lqNXhxSS9XUnpDS2kvTFV2eXJqOXdKem1XeCtM?=
 =?utf-8?B?WUhETHAyc054QWhqTk9ra2dzMjdGbEhBaVB0UzJ5YWhjV2RHM2x2czY2NnQz?=
 =?utf-8?B?U3FKSVFsYW01Y09vSGVZWGwwUk5vNFVtcWRDRW1BSmt3OTJaVyt1d3VRR3g1?=
 =?utf-8?B?T2pXYTdVMmFtM3pBREdDR1lPaTJQZWpaN3JiSHV5Z2o5ZzRuN3haUTFCTmEw?=
 =?utf-8?B?U1dZT0FHbUZWRFFIblBKb080ZVd2MVY0V3lHNGpNcDUrejhEeDBkajdvRVFq?=
 =?utf-8?B?RWRvYzJPVmF3QngvU3JnbDNTQTR6aG9DZEZaOWpVVVd1MjNXb0ZVbzNrTktW?=
 =?utf-8?B?aTJHM3p2SU4wWDhLODZsK0gvQXIva2Jyckova0d5bnJuWHdVQVhLUXFHeDJE?=
 =?utf-8?B?eVF5MlZ5anBFRC9lVUlzZnU1V29SR3A2WmFoTXlwQ2M2c1VwSjR2RkV0djdq?=
 =?utf-8?B?Y2FmZmNKbkJSQkgxODhGTnNJQngydGR4Y2d2TzRDMVQzNG4xZkNudjA3Vk4w?=
 =?utf-8?B?dE9tVFNDUXNjbThWU25aazZ2SEJXQjduMmdmMGVqeTNqVGt5YmZWU0FTUEhq?=
 =?utf-8?B?ZTBZK2FCQVl3VnBpaE1EN3dTcmNwSUpyb3BTWmV6eFFNbkZjeVRBUndrQzVs?=
 =?utf-8?Q?ZtFTV+M8OOY3LcUAMqhlGfmZ/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f03e36a0-0203-4c0a-c290-08ddd6a740a5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 18:13:19.1885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PAAe3nIYA9fjXQO6tqOjIQyW9aSFZDCDPWe72wReJOs1e4lUYRu9Oa9OxYBl9YBeeqoKD1XC/bm/19ULNT4sNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7812

On 8/6/25 15:46, John Allen wrote:
> When a guest issues a cpuid instruction for Fn0000000D_x0B

This should be for Fn0000000D_{x00,x01}, not x0B, as the code below is
checking for RCX being <= 1.

> (CetUserOffset), the hypervisor may intercept and access the guest XSS

s/intercept and/be intercepting the CPUID instruction and need to/

> value. For SEV-ES, this is encrypted and needs to be included in the

s/this/the XSS value/

> GHCB to be visible to the hypervisor.
> 
> Signed-off-by: John Allen <john.allen@amd.com>

With the change log updates:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/coco/sev/vc-shared.c | 11 +++++++++++
>  arch/x86/include/asm/svm.h    |  1 +
>  2 files changed, 12 insertions(+)
> 
> diff --git a/arch/x86/coco/sev/vc-shared.c b/arch/x86/coco/sev/vc-shared.c
> index 2c0ab0fdc060..079fffdb12c0 100644
> --- a/arch/x86/coco/sev/vc-shared.c
> +++ b/arch/x86/coco/sev/vc-shared.c
> @@ -1,5 +1,9 @@
>  // SPDX-License-Identifier: GPL-2.0
>  
> +#ifndef __BOOT_COMPRESSED
> +#define has_cpuflag(f)                  boot_cpu_has(f)
> +#endif
> +
>  static enum es_result vc_check_opcode_bytes(struct es_em_ctxt *ctxt,
>  					    unsigned long exit_code)
>  {
> @@ -452,6 +456,13 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
>  		/* xgetbv will cause #GP - use reset value for xcr0 */
>  		ghcb_set_xcr0(ghcb, 1);
>  
> +	if (has_cpuflag(X86_FEATURE_SHSTK) && regs->ax == 0xd && regs->cx <= 1) {
> +		struct msr m;
> +
> +		raw_rdmsr(MSR_IA32_XSS, &m);
> +		ghcb_set_xss(ghcb, m.q);
> +	}
> +
>  	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
>  	if (ret != ES_OK)
>  		return ret;
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index ffc27f676243..870ebfef86d6 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -700,5 +700,6 @@ DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
>  DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
>  DEFINE_GHCB_ACCESSORS(sw_scratch)
>  DEFINE_GHCB_ACCESSORS(xcr0)
> +DEFINE_GHCB_ACCESSORS(xss)
>  
>  #endif


