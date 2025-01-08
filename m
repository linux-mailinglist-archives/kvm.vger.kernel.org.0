Return-Path: <kvm+bounces-34739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1D03A0524D
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 05:47:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF653167AF4
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 04:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 997C719F42C;
	Wed,  8 Jan 2025 04:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HtMVK+DD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2079.outbound.protection.outlook.com [40.107.236.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28D12594A1
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 04:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736311667; cv=fail; b=c9J2PJ7vheawNrbn1+q4vqL6yOniSed8YIfRQChWANLCoHfViEXgJ/SoKy4a+mQuyXxdEWTgG9gH968sXI/kpwQGm8/5g50BtR0lu1vPsYRE7nIuRPcaPDetIt0ucz+/n1ftHAQuy/PcVNobSjFFl4As9NmqpMcLLE60A0V2mBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736311667; c=relaxed/simple;
	bh=COZhXXbFGeqkV3MPNlm9Z/2TDAYHrN81xAjcPvWPt8A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EoAgaWqA18Sa0aTA6rS2d4BP/L7WvF9G/Q8dEoUuU2cOaTxrxSnCHzyhOqfHBE1ldVb1lhVd0+LJlpCSPHWTXIKsKwDvp0noQGi8ROXWz/nprcq4gTjBORoxOJ5TkhT4FMAhx2oiJGsDKR2qLvlGhZWvT2Rl6VxAp4E1iZEnjgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HtMVK+DD; arc=fail smtp.client-ip=40.107.236.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yswirXtn8N03OarOi9oDZi/o7EZ7FkHDqv4ApPFMDjs0yGN6qzWCIarA5esOh4FVsJrCmE2u7HeG+4QnSwR2jUL6IiJ1p7j4rBP6axFKX03Q7X/Rc6ccPQL5oOdkLLMkfx5Ib3wtWoc6dqpg2lR+chauiTZW1tEbcc3A6vE/uCJ4qVd6wjGX8vJXlYRJZ3+J9xH/kLNwXbQtLE2N1B3EGeMOYCHWQH3TQ0Vs8P564/z7SmuKb9tVbmoxhVTiJxszC52h2njk0qkYavRvUQ0IOeS+q9+xtrQum3vw0L/ISd+6hFfSwrfXVpe6sreMxHRlTJ4dzNbU1RPPvAc/xSGsng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rup0mJ1nAsTSqii5n/WC/SQHqE+ZOO/3q4Q78pi3aDg=;
 b=Tjq0RwsG8Mb8l2qE8t2T6fDwLi9V34RTIEw1pXY+eYD3O80md/UBZg47ijSuhBNqTy1Ebjrq0un/DlYjKfl4cr/O0CySVauC17pHZuVTEagCKrAOO6vmtam150isb6azD5W6fCSRLaMXTMx/FxlnY8hZTLy5OwRiZ32T8WOYYife+PHN1eosxHH/QNubUmJRn9X8Eh5x4jHSh9LyaTaHMju8iuE1hf6PUlZ6z9gviSuPC5zJz5J+fptXBiuqqpI5gjQ8G8bCCvmoA/rv4VnFdOIKN7phNvGpkXDhpAkXh4OXQhhRHjtjgfY2zUv1bJgPf+UpewtkrGRh7F3WdiK0dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rup0mJ1nAsTSqii5n/WC/SQHqE+ZOO/3q4Q78pi3aDg=;
 b=HtMVK+DD0Ieqk8xTsdcWGLUnv5XptHKQfj8QlFjecFxlQXe1cLmVdeOZH8RGEyr0DHQZRGdRatq08bIQ+kMdzt8FwOoiPI6KwZhwrThTM53v8gkZo3/OGAAF5hrq/O5njGTH0rflw8KP+a2dTZqxU2yVeVh7qadjDjUFxhHabzQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SA1PR12MB9247.namprd12.prod.outlook.com (2603:10b6:806:3af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Wed, 8 Jan
 2025 04:47:39 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8314.015; Wed, 8 Jan 2025
 04:47:39 +0000
Message-ID: <30624aca-a718-4a7d-b14f-25ab26e6bded@amd.com>
Date: Wed, 8 Jan 2025 15:47:36 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 1/7] memory: Export a helper to get intersection of a
 MemoryRegionSection with a given range
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-2-chenyi.qiang@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20241213070852.106092-2-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEWPR01CA0009.ausprd01.prod.outlook.com
 (2603:10c6:220:1e3::13) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SA1PR12MB9247:EE_
X-MS-Office365-Filtering-Correlation-Id: e0b9ebdd-6c70-40b2-074f-08dd2f9f9496
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dktHTldwMEF5YnlqTENsN1kweG5UVUk4eG4wbnVBRURJUyswS0V0MEJtNFRT?=
 =?utf-8?B?aDNqYmtEK0IrMzdqMmNtMFoxRWZ0N1RwWFViVkhUS0g5d0xjM0wxdnYvZkdI?=
 =?utf-8?B?ZHdxaG4zRUVQemVRd1grcmNHQW9oR1ROZ00yOTNUMnlyZ3h5TTNVRXFCczBD?=
 =?utf-8?B?OEF1akJIV0IyVFd3b0U3MEcrenEwNjcxYWc0V2diRnAwVVhVSXlucHJNeUdN?=
 =?utf-8?B?QWxPM3l4OFhzQXBsd0pPNi8rbzM1TkpXaE4vWEtYa25Oa204ZTVlOGFPNFBo?=
 =?utf-8?B?MFJndjFNRVNWZjdRR0czYXpxQUV3SFVvK3dGWm56eXJpcUtnYTVDK0VDSnRU?=
 =?utf-8?B?UHpLYmpuQnNINFBtMFVtWDFwVTFYMDlSeW1mQi8vOU5UVnl3UklicGZYU0t6?=
 =?utf-8?B?eDBtc0hCWDlET1lCSDZBcWxyZDBERWl0d1Y5VWVBeWlKRWNzNnFHcTMzTHZ4?=
 =?utf-8?B?cnJQdjdFOTdaZ3ZObkMzR0E2aHlydzhkZFhQRWJ3cGFvRk1aTnNXSXZSMzhD?=
 =?utf-8?B?c1VwWFpZeFROcjR1RDdPUXJycUlBOWlTOHJJRTFCRnNPQ3Z4akF1U1RpbU5U?=
 =?utf-8?B?UkJvWVJnaWtoUEJ4bjhlQS9vYWN5Vm5QbWpTTFdQVVVFSHdBeXM4VVZVLytU?=
 =?utf-8?B?TnVscVhmOW1yTTQrMXlGdmtnVVFZWW82RHZTZFRhWHh0MUF2U0g1VXdqMi9X?=
 =?utf-8?B?UGVFOThLamJwcDBwbkJGSkRPOGhUQmNxUmdHVHptbmhpL2pWS0ZVZTAyZ1Mw?=
 =?utf-8?B?T0xhdUNjTGlMd3F3b09NMko1Z2JBaDdIeEM0Zi9lTWIzM1EzbXBFWW54RWFX?=
 =?utf-8?B?NDVvV3V6WkJrMXI4U2F5T2hiYUhsMVQrQXJ4SC9BTUNuUCthTFRicmdvYlAz?=
 =?utf-8?B?RlRDeWRZenpmS1BYNHNJOS83UEQvTlJ4S2p6Q0VlQitNYzd1bmYrdmhoY0o0?=
 =?utf-8?B?STkraDh4dUtIR01wYlR2V1padm83ZU9MY1hRZytkZjNMaUljYm9Mb1QvVnJV?=
 =?utf-8?B?NVdUOUN0YnFKU2ZGRjNFSHQxbHN4dG5pQS9LRnhhL0Z1RTBXZEtFblpoOUx2?=
 =?utf-8?B?MFQ0QXZKYk9WWDFUUFc0UU05aVArM285OWgrOEtMKzQzTkpxSFZDUlJWd0FL?=
 =?utf-8?B?MHdsZHpYM2xDVUp3dDRHMW9seTNwZ2QzOTQ5bFd4RFExS3Q3VkRSV2tsTlpa?=
 =?utf-8?B?NnBiWHlqc0ttY1JiS3BYTFRCdzNQN1doREhuOUM0SlhuMitlTnV6WGdnbHU4?=
 =?utf-8?B?Y0cwbkhjR2RPclU4Y2VmazZqRjN3R3JHd1ZZUlpiL0lYZEpJbEV6emYvYUVI?=
 =?utf-8?B?K2o1VmRPQ2tTWXRNTWZheDlJeU9zcnIxd2hLcG9hSXRkcWxRUVVaUlBma2Yx?=
 =?utf-8?B?WHV6OGdiM3pMVytjTnkvS2YwdFNMdkUxcWR2ZFgvOGQ0VVVNUGZvdER0REpI?=
 =?utf-8?B?NDh4b29jdm5Yc1k2UlpwR0xwek9DQ2ZvTmg0cWZkUStPZzFXbTREamlqeURG?=
 =?utf-8?B?b2VSRzE5cnlTSU9FR2VZR2hiQ1RyM0t2MGRaMEdMV2IxQjBIZEh4cEdDZ0hy?=
 =?utf-8?B?VmdKWm5ZQmpHMk5wcDRrKzFPem5WYzV1RFdnT0Vkb29BWThzTUJRYnVVRU11?=
 =?utf-8?B?cGlmdkRibFgxSTRuVFhVTmRUYkhKSnU5NFE5N1Y2TStmM1QzRUhzS3oyK3dX?=
 =?utf-8?B?cmhlQ2NBdmMwVjlKWTJDcE5NbUU3L3hiUmNSRFFXbVppKzZLSW9oK0U1d1Ax?=
 =?utf-8?B?MTVIc2J0eDY3RDhvbzc0d1BwRXFsSG1WNzJXZWl6SDRDRnQ1M2EzQkJXSnYw?=
 =?utf-8?B?U1RlVXQ1ZzE0WkFVUHVwOEhCV0NVWmNKK0krOHArVmk5ODd3V2I5QnhzZVNn?=
 =?utf-8?Q?37EW3LbR44EWP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WG40ZkllZ2RjUlkxUmg4bnZ4U29OdDlxOWVZRmhBNjExSERCcE9JOTNUNTYy?=
 =?utf-8?B?aWhlQ2ExT2hNTnQrZXVzY2xHWk85cVBrNnd0TFpoU1dGYmZnLzZzOEtTNzVI?=
 =?utf-8?B?cFc2Uk1oMyt1WEpiVnZKNVF0c1JITEwwMGxBb0xVeHlxb3IrK2J0Y0FBUXps?=
 =?utf-8?B?STQ4Y2hRaWpYMVN2aCtPUzRRS0JDODZqL2FMYW0vTG5UbmR4RnYwQ3NxT2pl?=
 =?utf-8?B?cXFlaVQ4U2xZblg2SkhDZmEyWmNzQStBY2lhTVNSMHNYeVZBQ1dSZmNnQUVS?=
 =?utf-8?B?cDl1STIvTTZ0bWtSN25nb0VhOWxMdXJWV0QzdUhVUmw5ZUZ4REdDclhFbHhS?=
 =?utf-8?B?WkpIWS82KytVcTAwTkFnN3BTeXBDa21RYWxwM3dJUVBDelk2ZVZYbjFWV3JM?=
 =?utf-8?B?QlZZZkh4MXQ1SnVmVFJoM3dRajF3UC9xYkFuRDVrK2VzcjBCeFZ6bGFtRFdT?=
 =?utf-8?B?MDlpTHBjNmxZY1cwMWI1Qk04bHZWUDlVS2tWblpqeVZ1WG9hYlpleXIrUVNm?=
 =?utf-8?B?U3FTOCtpczMwU3dOOCsrZWJ4ZGN3NVAyVG9DQ1NTZlBzOWdNWkROR3dTV3li?=
 =?utf-8?B?bjh1RTdRWG1JS08xRkZmdGgrVGpHaFRRT2V0ak0rWkluajc1MDlOMHBNK0pD?=
 =?utf-8?B?ZW9PNU9RdHJXMWFjN2pBK3NnNlFqNWU1L2pwZWYybDFzYTUzT2tSdEF6ckFp?=
 =?utf-8?B?Y1laeDdQTEZmVHB6bUJIWU9rMXMrMmFyZTh6TWNleWU1bGhyMTAyZHp0ZjBG?=
 =?utf-8?B?RC9zWHcxQWN0UFBLYmxhU0RoVDZEbS93ZmI4L25MRGFONzVkOUhjOVZ4Ynh4?=
 =?utf-8?B?M3RMY3krQVFqQno5WE5yMklRUXljUktjNUNPM1hRVTBwcDEyTVFTU3pDanQ0?=
 =?utf-8?B?VzBvQytNb2Nzc2hMZDJOTmFNRFFLeGl2OFBGVXpDdE5qQ2pqZVErbm0rQ21t?=
 =?utf-8?B?NjQvWENKZitmTitiK2lyTUhPSHhtenV5UTlMa3VIV2puckhUNkZMZU9JVktm?=
 =?utf-8?B?WG1palFQMlB5MEVzbXdxcGVNOVdib29OR1BxVUdWdGlSL1hUbU9IbERNNHhQ?=
 =?utf-8?B?ZEhsNmJkbitsQ1lsWGNua2JtTSt4TGlqVFFjYmdHcDY5Y2VYRk1QcndBT3Nw?=
 =?utf-8?B?Umxyd3ArN3lSRjBRWDJPaUhsRzZHSFlvUnFjZERadkU4QUJuZmFZbUVGci9k?=
 =?utf-8?B?a3NlWmJKTFZFSFZDakN4UVd2TC9sejRjREhiZ0lIbWNraURTbTVwR2RrSDU2?=
 =?utf-8?B?Y3ZrT3h4ZVdORndOQ09rdUlaclA1QVVqV3A2R05mVHgxd2pmZE1yYklsd1lG?=
 =?utf-8?B?aHhibHhTQ1NBeVhHeGZ6RXFwcVRNTVpDYU02NzVZL0hyQmkxa1oySDB2THpv?=
 =?utf-8?B?RWg0STlCNHZ6eTh3NWdXS21kYjgwS3JsRzFpRzVyamJjcjU5VmRKTnlvZFZm?=
 =?utf-8?B?enMrUTQzTFdyR0VBbWM4d21YUzJxRElDQnFsVFlnbExZbit0TjNKd1A4SFVj?=
 =?utf-8?B?bkU0MG5xRU5lR3owRmJPWE51alpzYXUwVlhDK0ZQSVFzWHFiMng2cytrNk1R?=
 =?utf-8?B?aVl3blpoZ0loWXF1Z3VOTDRQV1h1d0VyR1RLM2tKUFM1cEtPcWRVRlNJYnNj?=
 =?utf-8?B?d2E4c001d25Jb1dzbW1rc2FMWFVOYTVuTDdVbzYzbm4ybDBmekVkWGN4RGU3?=
 =?utf-8?B?ZUtJZnliTnlkWVVab0hzS0d3U0hGZVVSaUdLSmRxL1NEN3dEN2VIZjl3VUk5?=
 =?utf-8?B?cWpnaUFiMHBCZlZhaHNPQTNhWkVWazFKUTFoK3djNXozYVc2d3VYYU5sazkx?=
 =?utf-8?B?L1FXVHlvbFlkak1kTW16eXZZOEFqc2VFTEJnS1dRVHY4aEhBazVBYnhROHU4?=
 =?utf-8?B?b1BZTkFKV3FkQ3ZMRmpDUVFlSXUyR1ZWV0xnVjJEdUR6T1QzNGMvZmt0OU9W?=
 =?utf-8?B?Y28yWHdLN0I1WVEwUmQzaHMwWnhIbG01UTgvRFVLMSs3cWcvODhEaGJ4Q2FE?=
 =?utf-8?B?Q1RDMTF0YlhOc1QwZmFmeW11dGZpT2RUVzJuSWpBNEJYSEY3VmRUaUMvTytE?=
 =?utf-8?B?Wjl4NmR3V0VxUUMvNGtmYnJtYmcySHcxUDB5Y1NWa3dEbDZkaFZlQlRWb28z?=
 =?utf-8?Q?Xz7+o7kiidmlY7D77vvk1Bp1Q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0b9ebdd-6c70-40b2-074f-08dd2f9f9496
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 04:47:39.6822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V34y5YSSnBZzLBufkstQpGAcXKSaPwX3WSV+DAW8+GiTxiRl2bRTQjoziQiA3ucvny5EQlyfWfNnpyRhsr7SPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9247

On 13/12/24 18:08, Chenyi Qiang wrote:
> Rename the helper to memory_region_section_intersect_range() to make it
> more generic.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>   hw/virtio/virtio-mem.c | 32 +++++---------------------------
>   include/exec/memory.h  | 13 +++++++++++++
>   system/memory.c        | 17 +++++++++++++++++
>   3 files changed, 35 insertions(+), 27 deletions(-)
> 
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index 80ada89551..e3d1ccaeeb 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -242,28 +242,6 @@ static int virtio_mem_for_each_plugged_range(VirtIOMEM *vmem, void *arg,
>       return ret;
>   }
>   
> -/*
> - * Adjust the memory section to cover the intersection with the given range.
> - *
> - * Returns false if the intersection is empty, otherwise returns true.
> - */
> -static bool virtio_mem_intersect_memory_section(MemoryRegionSection *s,
> -                                                uint64_t offset, uint64_t size)
> -{
> -    uint64_t start = MAX(s->offset_within_region, offset);
> -    uint64_t end = MIN(s->offset_within_region + int128_get64(s->size),
> -                       offset + size);
> -
> -    if (end <= start) {
> -        return false;
> -    }
> -
> -    s->offset_within_address_space += start - s->offset_within_region;
> -    s->offset_within_region = start;
> -    s->size = int128_make64(end - start);
> -    return true;
> -}
> -
>   typedef int (*virtio_mem_section_cb)(MemoryRegionSection *s, void *arg);
>   
>   static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
> @@ -285,7 +263,7 @@ static int virtio_mem_for_each_plugged_section(const VirtIOMEM *vmem,
>                                         first_bit + 1) - 1;
>           size = (last_bit - first_bit + 1) * vmem->block_size;
>   
> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>               break;
>           }
>           ret = cb(&tmp, arg);
> @@ -317,7 +295,7 @@ static int virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
>                                    first_bit + 1) - 1;
>           size = (last_bit - first_bit + 1) * vmem->block_size;
>   
> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>               break;
>           }
>           ret = cb(&tmp, arg);
> @@ -353,7 +331,7 @@ static void virtio_mem_notify_unplug(VirtIOMEM *vmem, uint64_t offset,
>       QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
>           MemoryRegionSection tmp = *rdl->section;
>   
> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>               continue;
>           }
>           rdl->notify_discard(rdl, &tmp);
> @@ -369,7 +347,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
>       QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
>           MemoryRegionSection tmp = *rdl->section;
>   
> -        if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>               continue;
>           }
>           ret = rdl->notify_populate(rdl, &tmp);
> @@ -386,7 +364,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
>               if (rdl2 == rdl) {
>                   break;
>               }
> -            if (!virtio_mem_intersect_memory_section(&tmp, offset, size)) {
> +            if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>                   continue;
>               }
>               rdl2->notify_discard(rdl2, &tmp);
> diff --git a/include/exec/memory.h b/include/exec/memory.h
> index e5e865d1a9..ec7bc641e8 100644
> --- a/include/exec/memory.h
> +++ b/include/exec/memory.h
> @@ -1196,6 +1196,19 @@ MemoryRegionSection *memory_region_section_new_copy(MemoryRegionSection *s);
>    */
>   void memory_region_section_free_copy(MemoryRegionSection *s);
>   
> +/**
> + * memory_region_section_intersect_range: Adjust the memory section to cover
> + * the intersection with the given range.
> + *
> + * @s: the #MemoryRegionSection to be adjusted
> + * @offset: the offset of the given range in the memory region
> + * @size: the size of the given range
> + *
> + * Returns false if the intersection is empty, otherwise returns true.
> + */
> +bool memory_region_section_intersect_range(MemoryRegionSection *s,
> +                                           uint64_t offset, uint64_t size);
> +
>   /**
>    * memory_region_init: Initialize a memory region
>    *
> diff --git a/system/memory.c b/system/memory.c
> index 85f6834cb3..ddcec90f5e 100644
> --- a/system/memory.c
> +++ b/system/memory.c
> @@ -2898,6 +2898,23 @@ void memory_region_section_free_copy(MemoryRegionSection *s)
>       g_free(s);
>   }
>   
> +bool memory_region_section_intersect_range(MemoryRegionSection *s,
> +                                           uint64_t offset, uint64_t size)
> +{
> +    uint64_t start = MAX(s->offset_within_region, offset);
> +    uint64_t end = MIN(s->offset_within_region + int128_get64(s->size),
> +                       offset + size);

imho @end needs to be Int128 and s/MIN/int128_min/, etc to be totally 
correct (although it is going to look horrendous). May be it was alright 
when it was just virtio but now it is a wider API. I understand this is 
cut-n-paste and unlikely scenario of offset+size crossing 1<<64 but 
still. Thanks,


> +
> +    if (end <= start) {
> +        return false;
> +    }
> +
> +    s->offset_within_address_space += start - s->offset_within_region;
> +    s->offset_within_region = start;
> +    s->size = int128_make64(end - start);
> +    return true;
> +}
> +
>   bool memory_region_present(MemoryRegion *container, hwaddr addr)
>   {
>       MemoryRegion *mr;

-- 
Alexey


