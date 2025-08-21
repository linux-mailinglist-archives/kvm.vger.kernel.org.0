Return-Path: <kvm+bounces-55415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 165D6B30902
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 00:20:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EE4254E6092
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 22:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E2632EA740;
	Thu, 21 Aug 2025 22:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JO+xr2Sx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B022D3ECD;
	Thu, 21 Aug 2025 22:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755814745; cv=fail; b=Lqu0xUdsE7CBQc0jWObIspP1mr7EpqA6r5o0NCtSKGWzEmJhtGQX75+vSgyi/S9ySjgQIjvX/ueUvqP0Urx2eUCqNJckykPekc3YA6L/YpuxX9a1HvXunWXODeCT5VfNtxNpfRJzFsp6F1A/t1OF5fds48usAbA72bPQvP+YeNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755814745; c=relaxed/simple;
	bh=DfIDMWKzWgL+Ah6EkPURYg2jpngqUxGhVRWbixlWWrA=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=bW69Z9Gqb2me2SCn8uOUubAsFMpiQykxf02Xrli0DP958dbJcyDa8styQenGeg7wHoMt9Ty0e8ppvYk+1ERkjn8CoS/RJ0EiBMKDtr553AbAs47lC3ueDKRXp+aUnXN+VbNv9L+e3FgTEo95W8CK+QghfZZLKm+i7SswT2ecjj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JO+xr2Sx; arc=fail smtp.client-ip=40.107.93.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ILrvsMXPFd7Lgv0FzQyh7pqZo9k0kn5stYx+/I9yXjdhrTR6oWgfzPM5knEFDgkHPkuCvazk6zSoz9f5awRF/bvHuHMlbRNe7ouVeLpMC+InHRJXUJDkkjm8yFAAP1QoTB6oB0ymGnd4xqV1TFRaTelhYhaRVS7XET5YP/E1EVvtWHNe9t8TYmLJrmp/RJ4kZTkx8nw5XIAHQyrUBHiQnjhr4lkcXKMbqn7kbzecaS6jzoRd4HID0oWRoBNF9PKEc6xHo54yuFQK+Zfbm77+CU8fdF7JPSABJfp/MGFdOqNYRnkXG9MTQxMc/n4eXox6vBidr2fPMcBGwCmrH9AF3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWMwLHYV+gWFCbz54XzLimilRg6by4VaM3L6WMKlzSA=;
 b=PrVipZqDjWptd2/YDeP2rK8AYKCaeHO1NFTPGFkNwN+CT4iYgYqzUsCN4l40A5rRMkx01HFCRRthCnOIgbQHEVFWASN4/iL/ZDrFg+63lP1InDFcXx0GfHUFfzFY38dUkJI1Y9Lo1LEnyzTZDikUHYygr/oOw09wI4JG21Fl80fNqKRi3iLKlWhAeooh+9ej4bOD1XkbIQPIiLMWYSPGuq3fd5iU2spSnUeAVuhvR7HWUhidFHSGIMingLjhWKLzaoHZhniOsJrOIOjqV5oiypYLx4UcQ880t/NAuvBOCEUYpsYWiSyCGRN5WFEg27nZzFiH8TpQKXexMF5bUAlN6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWMwLHYV+gWFCbz54XzLimilRg6by4VaM3L6WMKlzSA=;
 b=JO+xr2SxnNN3I4L3fzf+lmsOS1ZGekzWMVSQ2kWOIGh8tLEDz40fcsvffsqVXHjkheYEiQjLMiPBhL+5KNoto+ub6aFaCUH1V+1lcFXMS53JsrBXECym7rBfJHrTAnvPjWL5eX9+LxjRIA1bS6S6sa3ZYR/uD9BOo4wRS5f6mWM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by PH7PR12MB9065.namprd12.prod.outlook.com (2603:10b6:510:1f7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Thu, 21 Aug
 2025 22:18:58 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%5]) with mapi id 15.20.9031.024; Thu, 21 Aug 2025
 22:18:58 +0000
Message-ID: <32c3a25d-8e5a-0f81-8cb2-655dd39f98ba@amd.com>
Date: Thu, 21 Aug 2025 17:18:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kim Phillips <kim.phillips@amd.com>
References: <20250821213841.3462339-1-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] KVM: SEV: Save the SEV policy if and only if LAUNCH_START
 succeeds
In-Reply-To: <20250821213841.3462339-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:806:20::31) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|PH7PR12MB9065:EE_
X-MS-Office365-Filtering-Correlation-Id: 66e38fa7-3e65-4b6d-ea59-08dde100b928
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T0EzTmV2RXczTzZ2Mk1pVTBjNEtvNEhqZDYzV3JobTg3OFlDZkJYZU02aUlW?=
 =?utf-8?B?WkJ0Y1k0a0ZybERsSFJoa3UzWjhJblkxNlNkeTVGWFZyVXFvQm5TK0t2S0Vs?=
 =?utf-8?B?T2pUUWFnRC8yS0Z6ZmdMTUlQeC9vQWplM1N1dHZ4WjNSMkpBcEtLOStYM1hD?=
 =?utf-8?B?VEJpVE9LQWtXZ2hCVXBGVEMyOWtoRm1DZEYzY3F5aUdLUzNGK3h5VTdHV0FN?=
 =?utf-8?B?L2lJQUM5elMweE0xNmFCNDRZVFovcHMxOFBnSU01QXF2dFRKZThLUG1pTEZt?=
 =?utf-8?B?ZjQ3dTd6ZHhwd3Z5dFlsS1hnOVJGVTQxbmtTVG5tTndqWDVTc0FmMndyWGIz?=
 =?utf-8?B?SVBTeHJTZ3BWdFJ6aVNvVDdPdkJ0NUliMUVSak13Q1IwUndKazBCSWFDMSs4?=
 =?utf-8?B?dmxlN0dVRDV4M0ZrcHZHd3pBbjVMcDQzOE0wbzZkRDBVbzJwejVFWjc0OG1N?=
 =?utf-8?B?QVVnVmk0ZjhzVXR0YVdPR3daWUh1aklqOHFGeVo3SWFHV3FwY3pTa0hoTmdj?=
 =?utf-8?B?bUhTdGNnbWorRE1XYWgybkdJSmVxU3plZHJLTlYvd2JQekwvNFh0VWtRaDl5?=
 =?utf-8?B?UThhSy80R2ZRTEJibHpjdUtMTUVJbVVjZU9hTGk0R20vOXlES1RDMDNobGNi?=
 =?utf-8?B?VlUyNTNNem1TVUhBSnBMN2FCSTU2czd0eGJzZnV2ZTFRTVV3cjltOHZEeWN2?=
 =?utf-8?B?d1M3T0dzR1RhZVgwNUxTSmI0dFUvTGhCbTdScVR3RUVkTEMyNDRHYXg5c2pi?=
 =?utf-8?B?UGdFa1VXVm9CQUFoY3JOTzZ4eW9QVFBXWmtuM1NCNUFOUTBBT0N0cW5yMSts?=
 =?utf-8?B?dEpZMUd6YnJMMS9YUTNXVWNHUGdVMy8rOG8vYU9Vd0JWVjh0Nk9YQVQ2NlhQ?=
 =?utf-8?B?QS9sYXF6T0ZPOVRjRjRRWUowQ2NZV3kyZ2Zyb0NDa0tBMVN1WFhlYW5lQjZN?=
 =?utf-8?B?aGp5WGhIbmFFdVBaUFo3WHFHTVlybEFYREdIUjFsdkZSd3lPNWF3dHVydis2?=
 =?utf-8?B?U1pxKzRRb3RqT1hiSTlkYWpvRmh5a2kyUlQ2ck45U3NEZ3lPZTJCMkV5QVVm?=
 =?utf-8?B?a1B0Wm1oUmtLOW90U3ErSVAvOW5XOFlPY3VnMWppZjUreXhobWtnR1JSKzk0?=
 =?utf-8?B?TVBOUWpKKy8yQTZrajF2b3dCbkNKdFJDYW1rZXdrNHlOQmMvUVJXYXJBUHE1?=
 =?utf-8?B?TFRSd1k4YVlPbXF5RmN2bUJvY3VuMUdLQnc5UDFKK2lpbjhhd28weTM2MlRl?=
 =?utf-8?B?SEltdnhhZEgxZEZjSHFMRlRxNTREaTNmd1R1MjVpWEw4bVBMLzVtbUZCS01w?=
 =?utf-8?B?cHM4V2ZSRGtlYitJRFFReXd6eGlDeWxjQXl6ekxuRm0yTnRRYndkWmhpc1la?=
 =?utf-8?B?TzRtZXFvYmJYc0JCVFRnVEtlNFc0SFBQTUJ5YzNRbk9sKzZiOWlzdEU1QVJX?=
 =?utf-8?B?VDNpdG1nUUpsWmw4dWF6ZmJFWjc1NGFwSnFXc3pvWlR2VTUydTRVaE5CTitT?=
 =?utf-8?B?Ny84YUdneXFVaTB6ZnBuL1N0c2NzOERxM1c0ZWtsV2lPTXZ1eEw1MkI3MEdp?=
 =?utf-8?B?QUtBcU45MEFteHFPZGFCSGFLbklienMxV0tYOHhRVXF0Zlp4YXh0Z1ZteVBm?=
 =?utf-8?B?ZWk5VEs5UmZiR08xUDhhY2U5NGRteVNkaG8yRjB0U2ltTDNJMGhyUS8ycjhP?=
 =?utf-8?B?UlUzNFFFTUY3WnhDYlpTZUU0QnlTb21oYnVBRHJseUkxNHp6MVRPekpLVmdS?=
 =?utf-8?B?b0xhNk01dEVGbUx4NnByQk9ES1hxbTJMTG13amNIeThKbklrT2drajgvZ2hD?=
 =?utf-8?B?T1NzN1pWRHArNHV5OHY5SDNQRWltVVRPUFRYcUg1WEhWQzBudmJINUZ4eFJu?=
 =?utf-8?B?YmFiWGxIVlM1TXlDKzBSNzI5cGxBQzgvZVdnRTNaTktzR0MzOGN0VXVVRVF3?=
 =?utf-8?Q?BH0OQSDdIdU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mk4rS0xpS2Vhc3J1bjlralBkZkh5K1UrY2hsVlhtR1AvcEVvMzNPUVV1RWc0?=
 =?utf-8?B?UStjVlJLRHdxZzBFaER5QW4xUDRINk5wM3dsOVd2QVMxbjNUNFROMDhnbTcw?=
 =?utf-8?B?Q3JuUU40Q2tKaERVdzhra09qM1puN0RDeUs0dnZQRGxJV0FUSGc2elJuSHZG?=
 =?utf-8?B?dXFxNHZESU5wSDhOU0QwTTluNlpqZFBCMWZxQStoQSt4ZncyOWtRWGVmZmFs?=
 =?utf-8?B?QlV1U1AwbGt2Y2dpNVNUUlBQbTJOaHIzRTZ2WFljTTZpcVdLUWd3N01BMUx5?=
 =?utf-8?B?RHdNZFhnN1JxbDdLSGJTS0NVMEdUcEpNajNVNU9uNjVHU3BBenZ5TzZKbUpr?=
 =?utf-8?B?OEQvQnZRN0Q2UnRJWlVyWjdLWTNrdHBDdUFHaEpheTB2SnFoVzd3S25yYXBW?=
 =?utf-8?B?c2w2RGM2RHRNYXlaYVVSbExJeFQreGxDWGhQMld3RXFyRno3UzVidEM4aGwr?=
 =?utf-8?B?WHduL3B4L0FiSGE2K0djWjJGVno2Ym5qd1NoOFdaNXRCaitobnVHTi9zbUVj?=
 =?utf-8?B?citiL3hiOTd3VjFHQzlyM3N5cXJpV0hjUzZINU1yQkxwQk1uU3d3Wjdsaldx?=
 =?utf-8?B?Zi9CL1l6UTZwYkZ3QlVQRGY1ZnFPT3pLUWI3SE9BZTdYdGpBU2RVRXVGQmxn?=
 =?utf-8?B?V2tVNGowZlB6b1FBd3dmY2x6Wi9OS01tSGY3NmdVMGRQeWVBWlpiSk9RVEsv?=
 =?utf-8?B?Tk9nN2t5R3I2NExTWUpwdkNNRlRud2RxOGgxZ3VQRzJXQW9MMDFtZHNnb0pj?=
 =?utf-8?B?bHNWME9qOStLSXVERmJuRHM3emJzcVUxNmFqeDZtTUFlWG13UWhzQWlVQkhx?=
 =?utf-8?B?Mm14M0FHZS9tb2p2MWdWNzhvZUxLb2ExSEJWZ0ZNMkY0TGpVMGJRMXp6WVFU?=
 =?utf-8?B?dFN2WE9kam9XU3hSVkZlMzRXeXROempCNnBFeVpCMUNtb1ZNTUIxY2N5YndY?=
 =?utf-8?B?TTg3d2dTbXdzM2tCeEE5S25QZG43UXVqYjk2WHZleE1tRU5udnU4RWtOK0hR?=
 =?utf-8?B?a2paa1RDVU9oUnY0N254c2tYNUlRemxvUDBsajV5V2QrNVQ0bDltS0FkRE9R?=
 =?utf-8?B?NExaZGZFT0laNWs5d28yVTAwL3hlbHZPWWIxVEVHUjJTQkk2bWRGUTM2U0Z6?=
 =?utf-8?B?Y2F6L3pLS3BQWVVFVGJKeXRIdWJLVGpzMCtWbWxHUGhpcmI0UXI4SGZtN0Va?=
 =?utf-8?B?S2lCSnNBUWQ3SGhUYTNWNDJkRkNhTHdlRlp0am14VzBpaFpQS0o2d09kdjFB?=
 =?utf-8?B?SmJ5QnczQk9RaVM2UGdzT2EzZnBxUU9RUkZNV3dPWnNJVm82MUFrTXQrUkQ3?=
 =?utf-8?B?cXJNRWVFeU1xR1RkUWRtVzloakUzQmc2dWRXK1crVGhuU1lxNHR6MnMzSm1w?=
 =?utf-8?B?WFlIRkZFRVRXeE0yZjBZTnliRDVTcmFhQUFyYkMraDl2bkVidzFnOVhENllG?=
 =?utf-8?B?VGZaTWpDdXdJcytsK080cEY3UEhUL29qS2YrVWFTUGtqODIwa3F5OHlvRjZC?=
 =?utf-8?B?RSsrVU9qeGFVNmY3aE1rMGhoaVFEczg2YVJQYi9CRUN6YU9lSEEwazRENjk5?=
 =?utf-8?B?ZjBlNHlDd2tlWDMxREN6dUpGSWtnbTkzUTR0QXhtcithM1lWdUpqVUZNZk4v?=
 =?utf-8?B?SWorTDhOVVZEU3J5dTVJYnlkRE01bStQTE5UWVc4ajN3cUJRaWI4THdJTmZD?=
 =?utf-8?B?WEg1SDIyamp4M1I3RlhrMXN4ZXhCbXBNU3FETGlnUlQ3Sy9PeWRmb1dWeDRp?=
 =?utf-8?B?R3VzWVdJUk5pRnpmT3dxWUpWQ3pteXYvckdtQ3laVHlVM3BGYW4vRzcxTVVQ?=
 =?utf-8?B?WTg3ZE5idFhJd1NCMDl6cDQyQ0pPQ2V3RTljUmpHUHpMc1FZWW5pMEZ4S1RB?=
 =?utf-8?B?NG1OT3F3SHRESzlhaW1qRTVsSnVHQXNRdkJhRE8zcHJocnZ2azNUT2h4WENh?=
 =?utf-8?B?WTQxeDVQRmJ5OXdKaTdOR3VGdFdWY0w3dVhRR2RpcjFya3Eyc1RmcTlvYUZk?=
 =?utf-8?B?Z2ZBSEkvL0ZjUklxQW5vRFoxQnFCcmR6cnlpcHF0SGdjZWZmdkY2UFh6YWY3?=
 =?utf-8?B?NTZ5akM2c056Sm5ZZHZ3WndKRHNraklYZDdiMjVIcW9aTk5ydzJ3cHVHRS9D?=
 =?utf-8?Q?GDnnTA8r9KcidFcAnzB9tbF95?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66e38fa7-3e65-4b6d-ea59-08dde100b928
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 22:18:58.1550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dgZmJiBFBbJ5AeZPoPcsVbKpGHsgVyPr/427Wb0ZPwFHWTx5IOK4yxKFt2O0pSRNhN18E3sclxfr378Oc8BGeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9065

On 8/21/25 16:38, Sean Christopherson wrote:
> Wait until LAUNCH_START fully succeeds to set a VM's SEV/SNP policy so
> that KVM doesn't keep a potentially stale policy.  In practice, the issue
> is benign as the policy is only used to detect if the VMSA can be
> decrypted, and the VMSA only needs to be decrypted if LAUNCH_UPDATE and
> thus LAUNCH_START succeeded.
> 
> Fixes: 962e2b6152ef ("KVM: SVM: Decrypt SEV VMSA in dump_vmcb() if debugging is enabled")
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Kim Phillips <kim.phillips@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f4381878a9e5..65b59939754c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -583,8 +583,6 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
>  		return -EFAULT;
>  
> -	sev->policy = params.policy;
> -
>  	memset(&start, 0, sizeof(start));
>  
>  	dh_blob = NULL;
> @@ -632,6 +630,7 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		goto e_free_session;
>  	}
>  
> +	sev->policy = params.policy;
>  	sev->handle = start.handle;
>  	sev->fd = argp->sev_fd;
>  
> @@ -2201,8 +2200,6 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		start.desired_tsc_khz = kvm->arch.default_tsc_khz;
>  	}
>  
> -	sev->policy = params.policy;
> -
>  	sev->snp_context = snp_context_create(kvm, argp);
>  	if (!sev->snp_context)
>  		return -ENOTTY;
> @@ -2218,6 +2215,7 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  		goto e_free_context;
>  	}
>  
> +	sev->policy = params.policy;
>  	sev->fd = argp->sev_fd;
>  	rc = snp_bind_asid(kvm, &argp->error);
>  	if (rc) {
> 
> base-commit: ecbcc2461839e848970468b44db32282e5059925

