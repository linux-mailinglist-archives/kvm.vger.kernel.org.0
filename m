Return-Path: <kvm+bounces-61403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F68BC1BB61
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 16:39:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE56E1895280
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 15:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42FFD3376A3;
	Wed, 29 Oct 2025 15:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="otWPKV86"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013032.outbound.protection.outlook.com [40.93.196.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98D82F5A32
	for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 15:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761752327; cv=fail; b=OgBBFIVa0483WAvX5zQjhvBHue82MTTku1VEnhhnqv4n1w9vjaju1It5LqHXtAZ/wK52N+Xbm0F7XSmxz6aM1lIfDShPiOjDjgywhPifPp4j9ZAgnNUQzFXdQ0XJOAo0+hDJ/4Vb4OUx31Yr2SDIfPZBxW0nd6c31zZbmeXm1tM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761752327; c=relaxed/simple;
	bh=rjDSH1fcZyjoIdOQaNTUjb5RCl0rcvDb37zublHDFo4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BGRbas/fYe+aTCeugrpIdfu9qFTaivW4XKSRiCgVgVdoqs/kExBEBwrGMdSI5U5KhOkq4EreHHFL9txyuTLdqebO25jBYIBnrlcRoAAZTXZf1qN9VL8JwJTuFwLM2GwZrvONJbA6tna0MhIcL2oVtRYmWfNbRmcO6ARIQJof0wQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=otWPKV86; arc=fail smtp.client-ip=40.93.196.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AxOESZW0V+JZ5Jn/6VOwa0+EkedG2Vd+qhH0eNnA8NmPz08r0Ls89RI/wMW5NJSx8DW5e7zjiLfS7o6gwy/LXboDnBgb2XB4AkTyt0ZtU+tbL1RQOoW9tqx/47HExjBuJs9s+eZhdhw6spP/GLyQ4ImVlhNQAX1ynrwNOvmxgf1H08nJctswRLSxz4j6WRcq18slZ9IrPnWAaFdX7kMe46KpE0JvhbYxX9NL1UXCor7rIxYle+g7AM7jlcDGnbyCLTyL9Enk21u4HUsou80kfa6rx+RC0kRfllztw3ZVuEInyyONAt6vYLd3EWEJri1AnqduBeF+Lrto8uJ9xS7OBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LITafvVPtJIez50lhDBTHrsPtdA5a4AbchXqfBf00vo=;
 b=YbesfZZgTGNxWIqgAxu6Tk2w/I60wkdQ2dsuGpBJrY1sFLXoUH5mvKWVFv1kvzXiwUVbZiHnj9vO3Z5cTAHzM0T6w2oPxa2xEe+F7jfhJyK3jQFC657UkLoMPpY55GmEwe5HBBZh8yACTr/hZ+YS0LCAJ8rVk/GmyzuGMjWfwZuktZebZ86qbZxq0UuvR4vPI9NWnDsoLRwobkcIh3dVd4py6g37vxkTpk/ms4w2v/NuE5u2147p8+bIXiZ1f3NCOzIC3ki4tfjrwjWItRdikG/3i2QYDQDWgZHtgzugyZ4MhPfT90B0ReRD3nMUGYyyUGNTOwUJFTCAfk2NbGGBNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LITafvVPtJIez50lhDBTHrsPtdA5a4AbchXqfBf00vo=;
 b=otWPKV86QwNBcZrC0SLPxaVf/3Th+W31J2M7n2PMOmVyTZ144AH3+b7X7nAE5fhS6QAKkh5Qjs1/UT42ru09hPnFE5tiLWriUC+LREo6ILjoOiIwmHuvlHPIfoOiOwZxVB4gRiHzlgDnMiOAxcJzNE6nu2MfBUC6nGbGaEfMsIg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by SN7PR12MB6929.namprd12.prod.outlook.com (2603:10b6:806:263::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Wed, 29 Oct
 2025 15:38:43 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%4]) with mapi id 15.20.9253.013; Wed, 29 Oct 2025
 15:38:43 +0000
Message-ID: <0a327c8d-c8a2-4b73-9231-bc5201e36e1e@amd.com>
Date: Wed, 29 Oct 2025 10:38:41 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SVM: Add module parameter to control SEV-SNP Secure
 TSC feature
To: Sean Christopherson <seanjc@google.com>,
 Nikunj A Dadhania <nikunj@amd.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, santosh.shukla@amd.com
References: <20251029055753.5742-1-nikunj@amd.com>
 <aQIdgeaeQ0wzGUz7@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <aQIdgeaeQ0wzGUz7@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS0PR17CA0016.namprd17.prod.outlook.com
 (2603:10b6:8:191::7) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|SN7PR12MB6929:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ac7a248-4970-41bb-b5fe-08de17013dda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a1VQUTlvSFkyOWE1czNzc2RvTGJHb1dFVExnK2ZSWVRHTkREWjBUWTl3akdS?=
 =?utf-8?B?UE9TRjhBRi9LbHh0VjhTeGpUeTZwK0U0WW9KVmYrUWg4dXVLSjloZndXZ0Fj?=
 =?utf-8?B?VDBJTUltRlB1YWpIUHZTeFYxSDl4TnVla0J4TFQ5SmNQQklTZDRvaGNPcXVz?=
 =?utf-8?B?U2YxSWJ4Y1V2bkUyay9FT0NMWnB4eFpVbkdSNnF1enVqOUR0c0ZOVzVkcUdw?=
 =?utf-8?B?V05vVWJPNFZJNXdOSkJEZEY5ZTZnU1hCS2dhdlkwYzc4T1RTMndJbFhnZWJK?=
 =?utf-8?B?T1lWd2hTWTZTRWlMbWRzbGxiMmlZYzBqMmFhUFc4QXBFNWIwbnBMc2VQZCtB?=
 =?utf-8?B?bVpmYVorWXhEQko3bEU1RS83eEdjc1RsbG9odjcvK0ZtYUZRZWYyengvZUdT?=
 =?utf-8?B?c3lYRExZaFVDamZ5KzdKdUN5R053OUJYNDJmQjBkbWsycEQxclJQaVpwd2pu?=
 =?utf-8?B?MU05YUhCZ1FGVXRMQ2VJd3NsM0UyeTMxYzlNYVllR1daMmV3cEJlTTR0WE9Z?=
 =?utf-8?B?VitVWkFZVnlFQVk1RVpNd0NBaEZNMytEVm5xcnFucnFWNVpsMFN6VFdSVG5U?=
 =?utf-8?B?WWk2R3BTZnJuQzdTYVZsaWp3QVFyTlc2SlcwYXRtRVh0OGV5TFJvK2ErRk1z?=
 =?utf-8?B?a0haTDJ3TjR6QytSSElNbW5KNmdoUXNoLyt3RitpL0tDQmVVbitOdlg1TFIy?=
 =?utf-8?B?Z1E4dHJ0Z052NXdMUEtkVnd5cEtRdzhSUlBNcFVwMVFwSHFkUndBQnVONk5j?=
 =?utf-8?B?cnBpTUtvRm01R01yeFZCbzdEbk90VitKbnhlK1ppRUFDYlA0RjN2TlVJa3Bm?=
 =?utf-8?B?a3RzTjNmM0w2R2pFdjQ3cXAvOU8rcU1iZDNwaFRRbVZyem82QWtZZ3VMZyts?=
 =?utf-8?B?UE5YNEZnS1UyTnhId0V2dFI1ZDMwSFF3MUhlYVcwekk1c2NibHhsdHc4N0Fr?=
 =?utf-8?B?d3FDRzBlc3lmSTF3dW9MQ0d6RG1SbjRweDBMd1F4b1lWZlpIV2tnK05IWWNL?=
 =?utf-8?B?NEtNVGpHZCtQdVRJcXE5Y0VRWVZkS0RZY1o2YUFvOWh3bE14VDVyalN5L29E?=
 =?utf-8?B?WmJOTE1VdVl6NktzQVhyai9oNitmU0hDcVFCQlNXdFhKZDQyWEJNRDFRMExG?=
 =?utf-8?B?ZVQ2ZlNUZWx1QXA0SHpNV1AvYXNnRWVlN05kdkl3aDFnVm9QbjNXRFRLdFgr?=
 =?utf-8?B?eTdrU0lSc294RkJYTHhsUWJmWHlON1B1Tm1od1RYdlVJdkRRTzRndHM4aXVE?=
 =?utf-8?B?VnpvUTRYWkdpUVkrcEhRRFdTemhPZWZaWTR3YVd5enpHS0ZPaEdQYncwbWJP?=
 =?utf-8?B?M0E4YjBIa3Q0WEZEc3pMTlV6dW5mOUpTMWJOTHRSNFFIT2lENWxKZEFNWVQy?=
 =?utf-8?B?VWszZFZTK293ejh4ZE5RcjM4L3pibE5ERGFveng1Nm5HLytaZjE4RFlJVXZT?=
 =?utf-8?B?ZllFL2NxQy9jOWlmTHFnaEtIMVgvVDZRSExNd3pQMGpUSEpsak5YU2hEc3dH?=
 =?utf-8?B?ZVRFcTI4K25xdGFjdzYyT05tMS9sOStiejdETEpzbnN4YmFlNHEzWks2SDNZ?=
 =?utf-8?B?aWlRaGtKN28xMHlGUVZpdG5tU3pqelhic2k2RTV2OGFpektyYzU0SEtwZmVj?=
 =?utf-8?B?T2pGaHZ5YUt3WWV5c3FXY25MWmRpdU1SZmxCbkRCZHhQR3pyZFc0ZWI5WnJ6?=
 =?utf-8?B?YnU5dDZFUnVMR3dGc0hTM2ZSaFNSNlFRNkJKTHAwL0I0WW5BN25wUSt0K0Fk?=
 =?utf-8?B?Y09EYmI5ZjU1RjlmQXRuWEFSMHlwbm9OeE9GM3NacUNFN1pPamRCLytmSXZr?=
 =?utf-8?B?UTR5N1ZLbklXenJlN1k3OWtsVWp2elpwMy9LOTg5RDBrUkpuQlVLaWFWM1R0?=
 =?utf-8?B?S0lhSUIva3FhTE5lMGFGQnBxUklYQy9DU0pGbG83S1d1L0xqRlZGbFJHenND?=
 =?utf-8?Q?z31hyKSfzz3nw5i0CJu8gG/sw16ROoXY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWM5TDVBSTZucHBEWk5VazZMWFIxdzdDVDNjWFJiMGMrWThaVEVhc2RnRmxa?=
 =?utf-8?B?NyswbHZpQnlZcnNnVmFMU3hXdm8xZSt6bGpReTNRd1hpNnZQVVlXOU5RUWY4?=
 =?utf-8?B?MU91am54eTJBMXpLS1RSRXVsUEdVNTNmT1gzdEJOZEViVzlBNzhOWXZpTUI2?=
 =?utf-8?B?MEZFV3prZmVmbWc0UE91VmFqWnJWVjBYZmR1ZERVV054SlM0WThxekJVOUNN?=
 =?utf-8?B?bjI4ck9hVnllSGM2aWhDSWNUVlJTRTE1SHNzeGRMT0NTWFJicmFGS1hEci9W?=
 =?utf-8?B?L3hyaEo3RXc4dmF0aFNod2lYNHRqekU4TnJxbHhEMjBrY0ZmejJMenBwT1o5?=
 =?utf-8?B?QmhnVUsrTmlMQjVBNFZTK1lwcG9oR21PZktNbVdMTk9mcTRXM2Y5V3h3L1ZS?=
 =?utf-8?B?TS91b3N1MGE3NnFzSzJncy8wUEJTNGFVUWJCYlY4V0V2S0tTTkwzNmtDOW5v?=
 =?utf-8?B?VUpxVDVKS21tMmdoc3VDUnpMTmxpNkUvRTBCWHIxMUUvZGFVcVNFbnBiVERO?=
 =?utf-8?B?QkVKbmZKcnJnS1hkT2tXdDdzTlZReUVoaVp6blRwL3dYNENrNFJZY2hLbnlx?=
 =?utf-8?B?aHdpbUhWcmVBWUwybmIwR0pCcjUvaUtReUt5RTJSdXpENlhhVjVEazJlV2gx?=
 =?utf-8?B?dW1FK3QvdUtMWDFjeXJqelc5c2xKQkdmRXJ4WXR3OHpXbURjcjgxaWlYRklL?=
 =?utf-8?B?WUtYSE9DTmlBaU5SeVMrUkhWaWpqOTlhcmhZeXJ0S3Y3cUdzZFZyL1ROekZv?=
 =?utf-8?B?dW9leng5dTgrVGFWYTQwZzg2bTVXSmpFRW9uM2dLWU5Rcmp6ODVQbUN4bkhq?=
 =?utf-8?B?eTg2a291S2xjVmszMlFTMjkzdXRYNGxMMnJqT2k0RHUzYXU5MDVBbm81QUJq?=
 =?utf-8?B?VGlNY1o3VDFMT0c0RDdBTCtUWUlRYm5yaFp6R2E4bEhMUU13ak8wRFlBR2Jp?=
 =?utf-8?B?TDNHd3dBdmlMeHliNU1xRmdHSStWMisyZUZjRmE0L2tsdHR4ODNLSlZrT2tF?=
 =?utf-8?B?bEpJQ3JGMCtjTnZwZlJtZEJ4OUNSZk56T0RmODVRZDhsMkQwYWxqL2V6TXo2?=
 =?utf-8?B?cEdVeGtIZkVoZHRJMXNlSG8yOVRXUnRvMkI0Sko2TEpiSmVtZzNnVk83em1O?=
 =?utf-8?B?bGZPeGxwclE2cDlGL1BQYnR2TFg2bnl4cTZsTmcya3Z1eVRXekJWNnpxWmN5?=
 =?utf-8?B?dHQ0bkZYbHhmRG5vei83OVhkS1VKSlVWQkc4ZWl4Zjh4NGNYUHlEZVZjWFNo?=
 =?utf-8?B?SjE5cmFLRXNXOTdRbE1DNnozY2tpeFU4K2Y5NXlzK1dROWk5MDdUZDJVa0RD?=
 =?utf-8?B?ZUhuTUs2bEVoaG9ET251UURzS0xwNXpub0hJM1VycnVXN29lUE5lclVjRU83?=
 =?utf-8?B?ajh3eElKNENQaHNYT0NMMHp0RldONWQ4QS96UUliUXJqVVcvbmp1S2FXb3NP?=
 =?utf-8?B?K1luK3o3YmJHMEhrYVUvQ3dtNkxiUDVkdXpwUUhPdllLOCtuQ3ZwVExaWVlk?=
 =?utf-8?B?UTdBU3JZcWlnellSbmt2eno3UFpSM0FKelZmMEFpYlExVjhCOURDTlVSUzhU?=
 =?utf-8?B?cHlPSnBQc05Dc1g5K3R4dUJVZThaUkpmVllTUXdQaHNnTkMyVlEzTE9FY09z?=
 =?utf-8?B?blRkcnFTN09PVEx0Q0VmQ3hUUzhXbVlwSlRlOWZhZVVRVU1Rd0lMRDVIMlBq?=
 =?utf-8?B?N1dMV0FYUzhraDYwWHpObExoUDNrS1JuRXE3c04reU1vRk1Eb2VTcHg2Z3Aw?=
 =?utf-8?B?d0NmSlRDanI1czZrN2prbUQ1M3hQU3FPakxOb3d2SWp2WWtoQjY3S0hEYlhw?=
 =?utf-8?B?UnJQUHlvUTl3UXljcmVac21od082MUZBZU5WSXVYSXE2OUJ6L2RmVUVRRkky?=
 =?utf-8?B?aU9NcVJ4WEJYZHA4V2Q3T2Q0dEJ4ZEFPa01XWUhLWXd5cWxKSU43S3VMV3p0?=
 =?utf-8?B?VVM0WXVmZEtoaUM1TEE3ZG5OZUJJcElRVkh3NnRrVFgwWFdWRm1tc1VoeTZw?=
 =?utf-8?B?b0F0bGZKd3N4Ti9LUmRkeUNZSEl2d2UvTWJwL1hibjdvSkx5QXk0NXc3NjRo?=
 =?utf-8?B?RUxxZGpHSzVqeGNIZ0M1aVdFU1dtZ0NmR09kQytobmVrcDhSTERGS09TSTJx?=
 =?utf-8?Q?oUqWibTbqriOq+FwtFLgiwyk/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ac7a248-4970-41bb-b5fe-08de17013dda
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 15:38:43.4912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2zGiq8pktjqf5SJ73+OaPl5u/F2whBl0AzPD37BE19eSdHwqNBlE9LqivgvC5d+HEFhNxSgwRsJZk8lfOYBEAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6929

On 10/29/25 08:58, Sean Christopherson wrote:
> On Wed, Oct 29, 2025, Nikunj A Dadhania wrote:
>> Add a module parameter secure_tsc to allow control of the SEV-SNP Secure
>> TSC feature at module load time, providing administrators with the ability
>> to disable Secure TSC support even when the hardware and kernel support it.
> 
> Why?

That's on me. Based on the debug_swap parameter I thought we wanted to
be able to control all SEV features that are advertised and thought this
was just missed for Secure TSC. I'm good with not adding it we don't
need to do that.

Thanks,
Tom


