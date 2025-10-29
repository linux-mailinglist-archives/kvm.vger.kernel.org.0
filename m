Return-Path: <kvm+bounces-61401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C9EA4C1B528
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 15:44:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 215F9562D70
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 14:32:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C0682D6E71;
	Wed, 29 Oct 2025 14:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Gvd3CDY4"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011024.outbound.protection.outlook.com [40.107.208.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A6D2D0636;
	Wed, 29 Oct 2025 14:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761748259; cv=fail; b=AOOuRXZ6dOvVV3dcXdXH3sFmmSw840U1mpnKeixzQJKVjaULIxd5lRg/nwHe6JK7MgZR7HDxrnJfJUNhOpAN/XdeJDQSsIjHdobjshywfVBgDARXLY4iQ6bQ6rHHOs+ilZ7tAK/bsmqXQC8TuI/ldg35sPptfPGEtF3wVCE6Bgk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761748259; c=relaxed/simple;
	bh=lpuBYmb3Ag/yAgpaIKgGBq4gC0RFDNUVh8ZMsWNoeXg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NdDQNS1ZAv8s0Nutw3payxtbqmjhL30k0yx9y3Yruvjn2CR6JaBJBgbhC55HdA1om5CDNWXHKaHWlp6xqqhVqdJ1lZpoTf3YKIOdBgMSEf3JvbwxI2eEvhS804keuHeMS58Wxl/uYTdOFsIZN7YEp04WJfdIhIHWkDoomZ2gvmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Gvd3CDY4; arc=fail smtp.client-ip=40.107.208.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UjRpnR3Fuzj/8AuhlJwlZ2BsmR/4p6iyloBSQmOKjWhOyG1KhS4frHwE2XJaLmDHHFyhQEDUlDouDRaO7e0QuOFiZggfPH9fdjcQVLQ5XD/3rVn6e77EIG0i6Dw3Yd2cxTI12geX22lh9tZeVDQm0zT9xHIGcLkWpAAaZ6bFKVEwqqBrVvnSgzxdiclT8MCb9gP3ZBnd+bV0a6DY0v16HY7Wgy6Uv+7RIN7lLj18DqJZP0Pl9Y08/+A+kMyNJqe9+awreQF2ZJBTYOVns5rBVPceNCBilItGY3hn+ZKp7qCAWIVBSboTlmRwkt1Lrmn+ecH8ngWs1pnZ+mrt78p6RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lRj2MVJNcgtYKDkdCnAQqbG1divBp3Q2Ni1yvYQTDwg=;
 b=NLOjNq0Tt2xIysidHE+3fqAp3iCfX4tU7my7LV4bPEFhgM7iJB4uH6/f8KJXJoY0021Giuh+bxP3+dM2dxY64AiJX9yyLAHm049uzVqRJeKeWeC2achKJ9xuQ2/+3CItCCmhTH0gDV2kJtDhtTWQvyxkrJ0YocgkXLfzAry2yyierzKBzbZdUTP5/H2on34hpLkDvyLraPxlNQ8ewDDwNw6snDsHoXx+WuT6FGXIPo6zcwES3UMkpXjX2z58UoKC3+yH2ykC4ma0/ZiKIiQO/8RUrXvecL1lsWoyzherrkUVhgscw8NcdWzHrHiqTEmH0y0GdGjpPQfbADVoKNfGZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRj2MVJNcgtYKDkdCnAQqbG1divBp3Q2Ni1yvYQTDwg=;
 b=Gvd3CDY4vueRp16LBF2KA6sdSood7JouMNx252WrRBmiG+8nSj6Bncg5g6H+Yh2g6oUxXQhGWaI0fb54kqoy/JU6tzJz1d3wqSiR+oJycTkJt3hZLTfAB7+mb30wuSkyL0Z4S6kcwwYF/DR1QQuQj4QWYGNVyUP+oDRiwrMd6BY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by MW4PR12MB6804.namprd12.prod.outlook.com (2603:10b6:303:20d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 29 Oct
 2025 14:30:51 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.20.9253.017; Wed, 29 Oct 2025
 14:30:51 +0000
Message-ID: <c712cb86-b143-446b-9613-87951c6e4909@amd.com>
Date: Wed, 29 Oct 2025 09:30:46 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/4] crypto: ccp: Skip SEV and SNP INIT for kdump boot
To: vsntk18@gmail.com
Cc: Sairaj.ArunKodilkar@amd.com, Vasant.Hegde@amd.com, davem@davemloft.net,
 herbert@gondor.apana.org.au, iommu@lists.linux.dev, john.allen@amd.com,
 joro@8bytes.org, kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, michael.roth@amd.com, pbonzini@redhat.com,
 robin.murphy@arm.com, seanjc@google.com, suravee.suthikulpanit@amd.com,
 thomas.lendacky@amd.com, will@kernel.org
References: <d884eff5f6180d8b8c6698a6168988118cf9cba1.1756157913.git.ashish.kalra@amd.com>
 <20251029104342.47980-1-vsntk18@gmail.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20251029104342.47980-1-vsntk18@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR18CA0032.namprd18.prod.outlook.com
 (2603:10b6:5:15b::45) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|MW4PR12MB6804:EE_
X-MS-Office365-Filtering-Correlation-Id: 108aadf5-6111-4974-2458-08de16f7c22d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K0JRU3plU2pXaG9BRkFERzUrS3E1UC9YSG9xQ2ovVXd5dUY5bVd3bnR1RWNi?=
 =?utf-8?B?QmFGWlQyVmtRcS9ibHkyWmVpVkpMM0s4QTE2KzhkT0tXajBnd01DWWFLdG81?=
 =?utf-8?B?ZjhtVGJ5UWpWcG1qdU1NMUF4Rm04L1JVdFlLREF2S1h4akQweTh3YUUvU1A2?=
 =?utf-8?B?YUtPb2lSSm0zcE5LcTBidVArcjZTeEtXV3UwUW1TaGlDOUhzWXM0U3dWaEdW?=
 =?utf-8?B?ZE5Fb2RDZzJTOW9TenRXa1h4Z1NMMnhIenRyVWJ2MkFtY3pCV2d0WjJ5NUdX?=
 =?utf-8?B?Y2RxQisrR09tL1ZiMVdJdkQ2RHRFdmxmWWlOc0tvbG1ITFJiSXNKaXF4RzZB?=
 =?utf-8?B?RndXYXpldXVBeXVXRWVzZUEyUWZzNFRhSWFRUGRpRGdKNE9GNHpsa2pEL2Vv?=
 =?utf-8?B?MjNEMFZDN1RmQkUxMGJYV2FlMlMya2ZkLy91REM5QStuNzdhbjZwYk4vNFla?=
 =?utf-8?B?dzlFa1REVGo2QVlncWt3bDlYQkdFYWVmR1pFcHpxak5iT3JhbmJoSnA1WGI2?=
 =?utf-8?B?QmNoOEwvSjJZVkNIZWJPVHNrYTVVZHRQeVMrNEhFT3R4UkNtYnZKRDZnTHox?=
 =?utf-8?B?QUZjcjJBcFFrN2g3dHgxWFdNcXBNcyswcnVTRjZZakwyZ2w1R08yRnkvVS9z?=
 =?utf-8?B?U1J0cjZWVVhVUFRBOHM4TzBoZ3orV0lVOXFYKzlWQ0tUSFFGOFN5NVR5TWg5?=
 =?utf-8?B?MW8ybGE2TkJBWExEY0EvK1F0T0VMSjdJMmZYdlN1ZzRYS2xKeU5FOXY1UE8y?=
 =?utf-8?B?Z3NyR1MwVEdiMmJpK0hXZE0rRFVwTldrVktLb3RzWjUwVm5lV0JlaGw4TC84?=
 =?utf-8?B?MFp3UlRkOWwxek5PZ3VQNWViZ1FIN0p2RGdidklNdkpDWStBTnd5ZVVnQndx?=
 =?utf-8?B?TkRMelVlRTgyUTEzYUFmbGVnYk5CbjNlU3ljWUNIQzcwam5HcmZxRXpVTFJu?=
 =?utf-8?B?cWRKSnAvVGNWTTdsT2wxWFdydFRXMmVPMTdIYXhGcjJxSDRkUGhHZ2d1MlJG?=
 =?utf-8?B?NHNMSzBLOEQwRlFvOGFuUjBZYTAxV1pHdHEzR1dIdWhoRmxkT0owTzR3QU5Q?=
 =?utf-8?B?cXg2dlFUemdBWHFYWnoweVVxeURzclhHWWRwSU9YTDkrRHNzTDJHS24xUUVm?=
 =?utf-8?B?Ykllb0x2T081YmVMMlFWcmE1NlJyZXl6TE9aUjkrb0F2dWZtb1crTzVhTkZG?=
 =?utf-8?B?VHVHRjdwNzNJUzZuY3kyY2p3TjRJUXVBYmVOWFZKUEpicFFFV3p1bk1jVHJa?=
 =?utf-8?B?cXFhamhwTXB3a0Qyb2JvUFpiYWVlUmJhNnFuenFVQ2dlMnIzUHI4N0hFUC8v?=
 =?utf-8?B?bExvZXRqM3MzanYzOWdJd0VDODFmUXRBRmJZSHJNRCtQZG9zbVZUWGZrWG9B?=
 =?utf-8?B?b25UeCtNeWFmdWc2WWhCZFE2djZxRmtJZGVqa21md0pkaTVXWEtIQTNmVDVJ?=
 =?utf-8?B?clpqa1pDUERqblJJOUdDWEMvUUw1TVduR3ludVE5L1JoQnBKaEszWGRzWnZV?=
 =?utf-8?B?SHZHMmVxNmQ1QmVrYVdreEFMcUZFd0MyV0dKZXNHdWhUVnN5N1ZTRkt3OTkr?=
 =?utf-8?B?cDgxUXhpQmdXR3JLcTc4YWdnZGI5NWJ5dmtYUzBocDRXa3ViYkJ2UTN5emRV?=
 =?utf-8?B?ZHA4bW8xRkN5dG9wNncyb3k2QlY2NEorNVFIdnNlN2hQeFRnam02SllIV1hN?=
 =?utf-8?B?amZYRHNRWEttSlF0RmZTT0J5em9JeDBubFRJbFZsejlnMm4zL0FUcEhnMTVN?=
 =?utf-8?B?WnpuRlUvOE9VYUY0bmpuM3lwS214LzU5R3NzeWh1REpLeDBvampyL1VBb1pn?=
 =?utf-8?B?bDZ3TmNRTmh3T0w1cy9FWGh1eDIwVE55eHMvREpUSEtCN3NBaTYySVdLOXpC?=
 =?utf-8?B?OVh4dk1oTjlJZ2k5N2RGZWo4cmw3TncwSkk3b3RTNWRrcjhqR3lDZmxZUHht?=
 =?utf-8?Q?ibWCCYd6b1MZ/SYPTvI45g+Ig5to+qXJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cG9DTDA2ZTlLMDRKazVCZFFuYnVsRnR0WHRlbTYwOU1KWWtObS9BWW5rWloz?=
 =?utf-8?B?MHV4YXlGdFBWTGhzTlM2NUJNeWpWRjFjTmhyVUI4bFJPMFdJT3VtTGxjRUJL?=
 =?utf-8?B?czBkTjBtNHhPTzNCdnRRY0dSYmdlQlVabXpaZ2duK0xTZGdTVmtsZVFGeEtY?=
 =?utf-8?B?NGxPOXVaeks1Uy9jRkdwa0tISTB1alBXYVdXNDltZWZsckx4WGZlVjRkS0FS?=
 =?utf-8?B?cUxId2R0SUpjM1VraHlMRFg5S3lSQzg5WElPaHRzc3pMUXNWV2pSOUlVOVJF?=
 =?utf-8?B?MWp3eFZ5VEpaQlhCSERPcWdxWi95UmlnZVJQMEdrYTJmRVNGejM3QVd3M3RO?=
 =?utf-8?B?aEwxNTM4YjF6eE1MY2hobkxETE5reG02c3JhejlLb3ppU0FZM3QwMzFJbzQ2?=
 =?utf-8?B?cHhWc0psa3dXMmwxZlE5VFZZYjMwK0lZaW1pS1NRaEtMaXRPNVF5eStYbnF4?=
 =?utf-8?B?ZEhUQ0ljTGp6WUpJKzBBdEhqaDFmOGNCQ2pReDZBK2NTanpWR09PbWs1NEI1?=
 =?utf-8?B?aXFmdTc1TkNPQzFCZVhlQUwxdGZ4VGNzMVpKUlpvck1OZ1p6UExaU3dabWlp?=
 =?utf-8?B?cUZPbnRydjBnNlBxTVhpVnFtaGhyRzdhNUFYYnB6RzJQcmsvV1ByN1ZVTHVO?=
 =?utf-8?B?KzJDMXRid1RXWUhyWWdoNkEyNVFDSnkrL2pib3VjK3RGcjA0YWJWWWh0R09C?=
 =?utf-8?B?SWNuN0NGRnZZSDRYYjRtSk56cDJ3cCtsQjIrZytuZVRVQStXVDkxS1VIYjE0?=
 =?utf-8?B?a0JJSG4zbE8rVWIycTBKa2o2T0d4SUZ2NzQ1N0Rtek1PdlBKQmFndTQ2K2FQ?=
 =?utf-8?B?WWpIR3d3K0NuZWtZS1BwQlJWWXlodGRUb24rS0M5RUl6TEcrQnFiR0U2MS9N?=
 =?utf-8?B?UjhBVk90aUZQZDFvNXh5Z3hXUW40S0Q5WlJ3RjNmdGFVd1ZldFRlT1RUb21q?=
 =?utf-8?B?NGhJRGpRcW5uMWtKRVJWU3dXWUhKRVhENXBZSU1KMXE2Wk1EWnhNRi9ER2tB?=
 =?utf-8?B?T2Fnc0lGZ3kvYjVBV3dORC8zTjczMzhiM21oYU1neVNoelJia3A1M2k5VXgw?=
 =?utf-8?B?bjV4azMxbTBDM2NVSmZ0UHQ0V1p2L3JmWW9GWk5nM1g0MldTSDM3UnJTM2hn?=
 =?utf-8?B?OFNDbmErNiswbHpqMExMb0pVOUkyZ3QxSlpTNFhhU1hQb2oxbFBXU0pGQjN6?=
 =?utf-8?B?S3dtVGF1VlF6V2FYRGdiNmNUTVp0Vm9qVC8vN29td0xoUVI3ZEYxUVJETG1H?=
 =?utf-8?B?b3FoZ0Y4bjgrZ3VvT2g5ZFVWTUdEaVFsZ0MrbzhHdy9LQ3ovUXJBQ2tZcGFS?=
 =?utf-8?B?aEZGaVZibzB6eDFjdzRPY0sxRTcyQS9uUEdlTWNLSDVsZHUxc3pLOWd4cWNG?=
 =?utf-8?B?UW5leFpwWFQ2UWFMNHRYRVc3TC94V1BRNHBpMm1UYXVGV3lMbzhLVUxPdS9L?=
 =?utf-8?B?MEtzWUlBSDR4aURLaWVyNjJZRm1aVmtZOHVTbEtGaHNXbEFIRlhpQUVBZU1j?=
 =?utf-8?B?bVZ3b0NESVpqQ0RJTXFFRXZwRHBhdkh4U2VRcTYxejRkc0Y3bHNBNVgyN1NT?=
 =?utf-8?B?UnVybmR3blVQNGlTazd3MVNrb2xKVGlMd2owc05mUzRzakNFYzZXSzlIb25F?=
 =?utf-8?B?L3pzMTFGMUxGd3dOR3IvL2VLQ1BmRUNwOE1DcWFTMUdkalFBT2FMTWVvZDdK?=
 =?utf-8?B?MXlEMXNzczByQkp0Q1hEUk5jV1pWM1R4Y3hhS1doU2txWHVNQ1lnZUYwWmt0?=
 =?utf-8?B?eXJSTDBueXROTDdnZC9pTXFaaHEyNXVzTGhMNFVxUEt0WGZOeWh4aVdFRW1x?=
 =?utf-8?B?UVVoY1NpbURzSWZtREdCY0JjVGdTRDdpc1Z6TzcvNUNOeUpWY3dpTGk3VWtP?=
 =?utf-8?B?M0lXR2k5WVFVK0lzVlVUSDZYVVFTRTJxaVBXMkNtNk1zWVozR3J1dWVCK2Y2?=
 =?utf-8?B?VDNiSmNYM2JoY0sreW9QTmlXR1l4blRtMk9ScEhWL3E4M0VkdFBUbXhER1hv?=
 =?utf-8?B?VGNpY2lhNzJjUjN3eUd4U1Noai9EMnV0bUROQ0ozdUJHMk9RNVhTZkZEQ3U2?=
 =?utf-8?B?cnN2SGMzNW10VFdZWGVDZ1dPL2g2OWQ5VlpQNkw5cDA5WVZhWkl0aE90NTFX?=
 =?utf-8?Q?ssnyIE6SRxNztN9tVC4m/JYYn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 108aadf5-6111-4974-2458-08de16f7c22d
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 14:30:50.9090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +nzJqG+pezcN5x2IyU9EZieE27/Q/knPYBccu73+dJHD1waUggvecvmh0w5ki44q/gE/sm6cUbUzxlepP31cQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6804


On 10/29/2025 5:43 AM, vsntk18@gmail.com wrote:
> Hi,
> 
>    these changes seem to have been overwritten after
>    459daec42ea0c("crypto: ccp - Cache SEV platform status and platform state")
>    has been merged upstream.
> 
>    I can send a patch if that's not been done already. Please let me know.
>

Hi,

I believe that the IOMMU updates for 6.18 (containing this patch) were merged 
after this commit: 

commit 459daec42ea0cf5e276dfb82e90ed91e2db45d9e("crypto: ccp - Cache SEV platform status and platform state")

Thanks,
Ashish
 
> Thanks,
> Vasant
> 

