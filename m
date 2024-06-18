Return-Path: <kvm+bounces-19890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C87F190DDFD
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 23:07:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F3EA282C8F
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 21:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 050EC176AC8;
	Tue, 18 Jun 2024 21:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="s/cWb0fX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D265516D4E4;
	Tue, 18 Jun 2024 21:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718744813; cv=fail; b=GUbYocp8+8TbPVsIydvA4kE2vTZoAxtFdo/a68V1OjYzsdLpomfM+u9OW3MW4yV+oxOE7ieLzqnD+mhh2pHp+iGERgONvPyAUFZDo5NGD10/10wGs9NoNB62qGdogwwq0TjnLxFEIHklZswx8Gy710CZlndWMhKhU8kEf+4RYEo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718744813; c=relaxed/simple;
	bh=p3PHA56xTqFQvc2FhXJaFSlqsLej07I2bxZFV1cm+kA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sF7Usnjlji/x2S3sNYf/tR5MQxW61Uc0VsHnkN+zZfiHg4jh8ZgrQ0CrGvCWKqe1nCUVQ2tbW5BcByYfkP5+yn3Y4uZz5Y6jYqymCwyNXcarcs34Gyj6yTsWAlEM1Yw8p+VSJUwkSWk697NyXDA5jD5XfNOpODa1HBmmLpUyOY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=s/cWb0fX; arc=fail smtp.client-ip=40.107.94.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=arzbXuih76eEB2YlJiaD+3BNj4tuKN5r0NakEhsiO11GKsZ6t1c4BTlGk9NYS0MabV7U9ztSCePnl9b8Pd7tJpL++YmLMNZi30e3sZK3KiLKSwpiuTiELV7yfX3Go/EccJ1Uq3R/+ziBSzIQ4qe5R8QztWPIue+fS/Hcv9H6UAlZ6mbopETRJ2oUjotgONxWwoBGhu7TUyy9+N3e2Fxjj8sDikJuox7RGwGb0mBx/HfIkowwHRrI2POGcf0G4lOkwV1q4VCi8+0M20l4kAaZN1o2K4WXFtjr+hl9sPKcREQyFNtEpD4JBjCVrmF3bES8CUHAfpPqzxbr4fafBpApaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eDqauxyGSdzeBymjR5CnVUMw1LGhR35xAU0m98v5Wd0=;
 b=hub8f23ef+q1C01aWWDR0GDQdPMnox5IGDO/lmCYKzGo1Ec88PzKDxAj4ciDds5Uk8RJLHXFDF9CHnl6UmCRxoBjpjsrMEWti5egda8Jhs4LXtp7bXCBzeWDt5VgsHJQT0f80QJ5NudBYoevDulS5MmlYSKyBeo6bh83ZGWhRtwy3/o1Ax4WFBJGMvi3S2/EjmSQd9/IyTCcs6Boye/iG6VxUe0Jqw/meB34QqWjAuq2JmyFFNY8JIVGdFOOlqsY9J5eqDfCe5IH/k799NTZb5yb9+zHwCs03lbzyiRV8QeZiCi29uZDLj+KgAxVXM8Gf7bhwmTlGpn8xus8uKn51A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDqauxyGSdzeBymjR5CnVUMw1LGhR35xAU0m98v5Wd0=;
 b=s/cWb0fX+EyOzU5YHEnkKplj8APkvjU95NwuS0BA1Y3YewiV6uz/vIBgCGz4JA0Ps+YGylUOn6a+5o5I5ID7TeH64JzFNvr8znK5kKgMBcPZ/jUHytuQdaZoVuJnMPTxD7yyvvG4lyFZK2kR5gcu8iARxE1s41lUA/BXHxZFNlE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by PH7PR12MB6417.namprd12.prod.outlook.com (2603:10b6:510:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Tue, 18 Jun
 2024 21:06:49 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%6]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 21:06:46 +0000
Message-ID: <afe9e396-e912-bf8b-ba80-5ed3296b920a@amd.com>
Date: Tue, 18 Jun 2024 16:06:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v9 04/24] virt: sev-guest: Add SNP guest request structure
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240531043038.3370793-1-nikunj@amd.com>
 <20240531043038.3370793-5-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240531043038.3370793-5-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:806:20::32) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|PH7PR12MB6417:EE_
X-MS-Office365-Filtering-Correlation-Id: be817c94-9799-4f87-c06f-08dc8fda8fee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|1800799021|376011|7416011;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RDV1T01jd0lXWHFOUGovZDRwNHlqL1BtaEJOUEhDaUo0Y2RvN0c0UnpHclRy?=
 =?utf-8?B?QUJtVUd0RkJJQmN0VHY1QWYwNVZXOHNZZE1xWE9ZZjlGaWFBWE5CeUNYczJn?=
 =?utf-8?B?M2JodGRpMkdrYzV4UEdwRHY2SW92R202L1FXL21iS3ZVZGFsRGNBUjUxVE1I?=
 =?utf-8?B?UGJCUlhmM1g4OVBNWGxDS2k5VmREellJWkk1bGtrdnVRdXNTZ0p0REFDWFIw?=
 =?utf-8?B?U0ZoZ0YvNEtaN2trcldHUThDaVJLcXhuYnF2SnRnOVRaYlV5Ym5zd3dGZmJh?=
 =?utf-8?B?Y3Y0dHRzVThkVzBIQktTTWd5S1oxZ3JXV05WWWZiTDdWNVZaN29yYVYwcHAz?=
 =?utf-8?B?Y0JJQktLOW01SHIrS3dzcWVRM0JEN3VoYUh4enI3bTY2TDZQY3JhaWhCdnhB?=
 =?utf-8?B?NDRhcG1nVHZlVUxsakRaaEZpT3g1MUw4NFF6V0lZYnhvWko5NlZacGhSUElT?=
 =?utf-8?B?alBjeWFEU3JCNS9MSXM1R1AyaGxGYjdEclpkMTFIdTdPamk2NUE4blJYZE1s?=
 =?utf-8?B?aXJUVWxPaGJaMWxrbEpvUGIrVFJYOExxbjBBTmRNNzl6SENJaTg4a3BpUWNH?=
 =?utf-8?B?b08zVkdZQ1gwUnNRcStTSGxySWltVFdmMDdDMHVKZmxNWUxmeGVrOTI5YUZv?=
 =?utf-8?B?a0FXU0p5N2Nna3ArMkRWSUR6bGNhNUViY29KNWxjMnhsYzNJekZPVGJOd0th?=
 =?utf-8?B?T0k3MDYvS3I0UzY4dk50MmNUUkNTc0JjSkJUR3VDSFBJRGdTTGRPYVg5eHNk?=
 =?utf-8?B?ci9yQnhPdkFyK3hKeitITnhEN0hmWmlucXBVWmxWaFVBVlV0Z0lzQ0cwdlcw?=
 =?utf-8?B?MGI4a2xMeXNrTVF6SGkwUWMvdFhlV1lXbEFVUzRRVTVpQzdTdUsrTWk3UTV4?=
 =?utf-8?B?dkthMGoxUVhTanFqNnJueW9HMWNOTGJrQmZFb1lTSWVjVW0zRWpuWXV5alFO?=
 =?utf-8?B?aXBCcWF0UEpiaUFZR2lxaVdxUmRkRFptYkpTM0xwcHhSYmhIUzRZZ0hhUGQy?=
 =?utf-8?B?WWxqUllwbURSSmVXcUgwV2RpaTE1WjdzbzFvN1dkRUpxQjlvTk1VblZWbXcr?=
 =?utf-8?B?alBNWkFtdkF2cGhEYU9SV3NucUhlKy9DWmt5OFFWOUNlaUM0RjllRCtmS3FW?=
 =?utf-8?B?Zmd5NHJTL0VpNXQrOWNQQjhiQlNWOEVCLzMvdENNRUt6WjA3TWJUdUU4U29a?=
 =?utf-8?B?dGFyc3dWdnVpeEhhelBxaXRXRExpa3dZTVNVTnhDQTdLVFpicXhFait6eWhi?=
 =?utf-8?B?UzR2Y1lFTXBla2V2Nll0cHZaRWlNVG9yaXRmUVQ4aThTaFFSMEtXSHRlamVU?=
 =?utf-8?B?YS95b1lZQi9od0pZQzV4L3Y3eE1pWVF5ZTJqTWh1aEtDazRHT0xWcTYzaVFX?=
 =?utf-8?B?bVRSZkdMMXdZbnU0d0VnUERnYkVyRUtCbHhVaWVSd0phOXljaThvT08rcUpI?=
 =?utf-8?B?akNaaVJlODB5WjBVVFBzYndkNTU4TWFVc3Uyb1hRTnBFNGE1Tno2Wkt6QUd4?=
 =?utf-8?B?WmhQN2Y0amxSaTdPMWtaVUV6d2I3RFZScVhzc3N6SWwrWTJEdnc1aHBaWmll?=
 =?utf-8?B?bGV4MkIyM3Y1aGxDNUFvQXZFL3g3Wko0d0p1ZkVNRllpWDB4NWt0c3ZvZzBM?=
 =?utf-8?B?WlN2ckNiaGpwM1NoTS9iQVZkN1BBeUdQNVZ2MGtKdXl3VVZSMm1rNXBZNnlx?=
 =?utf-8?B?WGg2akIrYXZjVlVXVGtrUUxuanBmT0ZPOHhGZmlYYXE4bWZ2Y3Y1U3BQMzlU?=
 =?utf-8?Q?zXEvmKEUamwUXFyTmA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011)(7416011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzFJYVE1ckFBeGlUUHRnbVlZVzR3S055NHBXREdYdXlmd01tdko0cHJERGVR?=
 =?utf-8?B?VDBBbjBuWlViWGF5MnNRbUhVcGtBR2lMdWJ1ZGgxMWZXeEtqRXpCODk3RE5Q?=
 =?utf-8?B?TnhVMGc1WjFrVnpCdFRVc251N3dod0tQK08xcHpvN29ralZVMFdLNExJai9C?=
 =?utf-8?B?bjZwTUY4VWgvYmwrOVdHWW1ubDVPU0dtNm1abG91b0NqbzY0ZE1pNGlEQmRS?=
 =?utf-8?B?RFp6Qk9hcE9aZSthenlwV0YvWkxWcE80RnI2VGJ5bzMyTng0SmswbHJKbHQ3?=
 =?utf-8?B?dlVHbDVMUjB5N2F1US9yeFEwb24vS3Y1M2tIZXBsN1VuUG4wb2d5bDlZRkpV?=
 =?utf-8?B?ekJUaXIySm1GUkh1bmhKVE9KR0hPNlZTTUFBK3g1SjlEZENJd3VSdmZQMjJv?=
 =?utf-8?B?cjRLbXl5OUNZRFZySnhQcGo5VGI1eE4wT0lJU2E4eE1DZWFmeDV3Nk0rdnhP?=
 =?utf-8?B?VHQ0R1NlZmkrajBmVVhjaTNSTFB3R2k5TE9lZjhRWWFsVVpSeGtndUlZZXZz?=
 =?utf-8?B?VS9Ua1l1M2xaZEhzS2JWRkJ4YmFQSjlHNXJtNTJoR3k3aHlyamFuQjZTQS9T?=
 =?utf-8?B?cjZGMi9rOEVGUWE1S003MWgrb1BOZU0yY1VSdlpiT0NUTG04SWpKZ0Z2OGxw?=
 =?utf-8?B?aGsyV1dLak9qZFBySndsV0pjVVZtNm9hUEhSSmlqbzU1aVlYandidjBTRVJT?=
 =?utf-8?B?MjFLVk44UVFXNGVhbWhQbjJQMm5lMzdlOElialVwNXJHOG5XNHRPZndXUEQx?=
 =?utf-8?B?dDJwbDdkclJnV2d6NWllZmhrTDE4OEhtamY1KzdPbm9ZZWw3SE1LVlJBbExl?=
 =?utf-8?B?SzR3TXpZVkJ5anQwcUZkL0pNOW90NEFUL1BJVGFCWGZaZVdUdUJnMlFUaUdm?=
 =?utf-8?B?K0ZGVWp1czVWTnhkNFVmeWVuNlJETkRBTkF2ZVhOUVY1T1g2RUZOU3dDc3Qz?=
 =?utf-8?B?Q0NiWHZ6a3RMK0xjUVl0MWNIbkliREFTR0wvdU5LemlWK2dxQitIVE1aZW9T?=
 =?utf-8?B?aVNqR3ozcDBWZ0s5VXZmcWFqbjRaYzIwcEV4S3hKek43SFphQU91YXBGaXhG?=
 =?utf-8?B?cll5RFF3RklLNXQ2d1E5SnAxNnNtYjhoYVRJZmlESDhrc3NBSHRQRXVIVHRS?=
 =?utf-8?B?aWlPNFl0WnJlUFNsNjBvRHI5amYyNkFYdVhxV1BvUnI3emEwQTJ2Qmtianlm?=
 =?utf-8?B?eFJkbzVkaEhGNW13ajl2RGZGMEFoYjl4a21OU1dwbWhNRDBLR2ozWGpodWxM?=
 =?utf-8?B?bGlWQ1NsbmQ5KzErYUZ1eGhoUnkyTG0wckJNRGp2YVFlbUFibEtKZkxYeG5v?=
 =?utf-8?B?RUNoSUd5VnhzaC9oUEFYUVpweVBYT0NhMEVudnR6dW5neWtqRUVPUDJpNnVL?=
 =?utf-8?B?aG1rNitmRjErWEdsdEdYUFB3Zm9UUnN2ZHB2Vy9xZ2FBbThCaVNqdDRNaU1i?=
 =?utf-8?B?cm1RelF2cGRSUW4xQ2F6c2cxWXRjV3oxL2RCREhJUzhlc3RYazlRV29UUjFY?=
 =?utf-8?B?VlkwUlZsWEplNkMyMk5vLzRiZUN3dS9sZjdnUEY2WkJTa2kxLyttcGhCWWVt?=
 =?utf-8?B?MEVNYllzMlFlblJxVkRjMUxxVmJ0dU9MSSswYWpHQXpJSzVDVXBsUEVRaUhW?=
 =?utf-8?B?NTNlVHhsN25uditNYUhtdXJ2UUZaK05ERnFpKzdFdjJIYmF6MFJaVFU0Qmlh?=
 =?utf-8?B?L3FNbGNkVnk4b2FnWU1TOXY2eHZJMW91SHErRHYvOVpqZVBlSUVHOW8zZ2ZH?=
 =?utf-8?B?NFppWHIzWGNoZkxKTlBPUjRjZlVTTzBsbEoweHNiTmRUUHg3NWxDR1ZyaDk4?=
 =?utf-8?B?WDg1L20wNjNCY2dKNWNJQ05TYkY2VEZiYXBaNU82VGw4VXE4NnhMZnFuN1JN?=
 =?utf-8?B?TnhCak1DY21lQnA1SG9QanErMENXbjVHOCtINTkrNnBXb3J0cUFCTkM4M0pS?=
 =?utf-8?B?bll1NDUwbzZXbG5seE1KVHZrOFRVWU9jVlU5QWg3WkdDMHRvbkVHNzJ1WGMy?=
 =?utf-8?B?dDA4bDBjdWZJVXQxZWQxRWxZZVB6NW90M0JSdUNHbFZyV2VXaFdKUlpBNU1B?=
 =?utf-8?B?dUs4dlo1WTNjWmNWNmorY25vVGszODdMazZ3WlBKQmdLUS9yMDlVd2tzU2Ft?=
 =?utf-8?Q?awvy1RTp7UQccFPj8lW1WI8mV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be817c94-9799-4f87-c06f-08dc8fda8fee
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2024 21:06:46.1636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 31k+ZOHREajQWcm6A3M1b/tX/kL8N0CJ15v3kDTfQUIFu1eRvacWgEcxnPkPEnh8vqF+rkQdst4YSZ34njBw7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6417

On 5/30/24 23:30, Nikunj A Dadhania wrote:
> Add a snp_guest_req structure to simplify the function arguments. This
> structure will be used to call the SNP Guest message request API instead
> of passing a long list of parameters.
> 
> Update the snp_issue_guest_request() prototype to include the new guest
> request structure and move all the sev-guest.h header content to sev.h.
> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/asm/sev.h              |  78 ++++++++++-
>  drivers/virt/coco/sev-guest/sev-guest.h |  69 ----------
>  arch/x86/kernel/sev.c                   |  15 ++-
>  drivers/virt/coco/sev-guest/sev-guest.c | 169 +++++++++++++-----------
>  4 files changed, 177 insertions(+), 154 deletions(-)
>  delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h
> 

