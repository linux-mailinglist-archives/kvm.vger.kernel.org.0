Return-Path: <kvm+bounces-54950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A5108B2B7F0
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 05:48:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 017141B63C2F
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 03:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7F79BA4A;
	Tue, 19 Aug 2025 03:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pUxtHspa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2072.outbound.protection.outlook.com [40.107.96.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C0F2AD3E
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 03:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755575279; cv=fail; b=EhZlOdNevFbQBCzgrMyAl78SL0hk9Y8U/lhDdfmRHjmOLEU8bEVlY0p4p/iO5s4ERmasBQbscbet7chy2hpa2GbxY9QyxUWDoZVhOGQyiZ1fPaiC3nFurVaao0SwRARXQcJwxwqbWWoVK+AQwfDq/hrK4ofjcksgWX5V0R5i52U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755575279; c=relaxed/simple;
	bh=jW02BbYkgEgB2DfqolJx6Wnw+882rs13OsbIXuNVwC0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=F0Isrmp1ENi5m8XGyo9tjfxS/IWGqFNlRM0cWEpJN9x1OmthgTI473r2yT00c8Z4xLXMVg4/zM3ErEU/+VGqzo2Xz2bm90UY8WQUsyW1y03/AoXCwKdZ4mdquCLoIASOKJ2yhCdpxNMEjxz0QHsow/ZRgYppufCOQPk3ndbWwDo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pUxtHspa; arc=fail smtp.client-ip=40.107.96.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PyXDlcl7auIUJZrkD1Z7dHTjNA/fR88GI4dTL3cCKfiCSIUSsP3vsGN/85XuugxUVxn8ONnCQ31CqHZcwXbnvEWkZYMEL2RFvRRoJcTgC6ewS1g+yD3PA0pR8treKYj46PyNAYjXMEbQzg0Jg2SN6sEgpc4WjGMmLW0qeTa+FXYZz6Mp5MpfPFhkrnokatnb6XK0/4r/W5b5YlVqo63LCOOCys9MR0UyDHbg5LShk1uerlBeWcZHYoSeYzPkTKZImO4ylYQ1DKfApQKKRlyR8F8GQSoC6GpUysBLMU0h7CjGY7zbQbIv2c29piIdk7xCpMSJo99wy9+8NiJAm3CTiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j6ujKVupLWwvSH4RvygGThIbUP/U9SwFP7FMf+B2ejI=;
 b=Jk5GJn9ONNkefGIM33xJPlgIoEWfU0FH7qxzq9o6UO1dWlIzLkoO+Lvf0R5nGN7zOTC8e+u5IFS6bjB5PfPVXCqFIFLTSG3ubataMG7k9Scal+O6gjor+FZAlLwKe6M14pb1RD0RlXw97H1wboaS7VIbuhF4nV5yGnVZzpiKGkDKzHzUuqs+EB9nd1GhDZB42iVCX4nmfYQjW2G2EN7SXHTvldGHoPzsR8SWiAhO5Xd1lgYIDfqDgOl+NT3BBYvH9lj7TBrQlFEnAKwoiJmA8sdbqzEJR/HyNNgkIOreSUkcnh9/2sFd+9EdkAPJo3BZ4OS/un8+HkXdV9pBpHIMcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6ujKVupLWwvSH4RvygGThIbUP/U9SwFP7FMf+B2ejI=;
 b=pUxtHspaMH7/PT9lUTPg9guHxDk13Sbq3b4WP/F18Z4KCm9EjEf0MH1JeTnxIQkcbZpNGNseyh7SX/uck8WgZo/rtdyS9gsi1hipZikvws5hh65FQX6li20LK+JW3DJ7M9HaWYcNkEzLhXl+nS5TXjeDXSNABRL4x3tg1Q6su60=
Received: from CH0PR04CA0038.namprd04.prod.outlook.com (2603:10b6:610:77::13)
 by SN7PR12MB6744.namprd12.prod.outlook.com (2603:10b6:806:26c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 03:47:53 +0000
Received: from CH3PEPF00000013.namprd21.prod.outlook.com
 (2603:10b6:610:77:cafe::23) by CH0PR04CA0038.outlook.office365.com
 (2603:10b6:610:77::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.20 via Frontend Transport; Tue,
 19 Aug 2025 03:47:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CH3PEPF00000013.mail.protection.outlook.com (10.167.244.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.0 via Frontend Transport; Tue, 19 Aug 2025 03:47:53 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 18 Aug
 2025 22:47:52 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Mon, 18 Aug
 2025 20:47:52 -0700
Received: from [10.136.36.114] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Mon, 18 Aug 2025 22:47:49 -0500
Message-ID: <b9a6116e-ae48-4de4-922c-71297f046141@amd.com>
Date: Tue, 19 Aug 2025 09:17:48 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 0/2] Enable Secure TSC for SEV-SNP
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<isaku.yamahata@intel.com>, <vaishali.thakkar@suse.com>,
	<kai.huang@intel.com>
References: <20250804103751.7760-1-nikunj@amd.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250804103751.7760-1-nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000013:EE_|SN7PR12MB6744:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cbd9e59-ca83-4d30-cbf6-08ddded32d1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N25qemFBREVHT041dTNiVDVlYzVWSVFCZlBpNW1oSGFDbmhWTm14Sm0xM1hF?=
 =?utf-8?B?MmhDK3dUeU12ekNpZFVobVFqOHNsQWFvQ1FBSlFJQ0xENnNFOTkzZUNrWXlq?=
 =?utf-8?B?b05QTFJBaGgxSVBTSWZqMnNFVUJmaHgxRE1XSTRrZjJWS2ZmcWhaSFZqRmRr?=
 =?utf-8?B?K2o1UjhCY1J4ZHVWTGVCUXlwajNHSmJEdmJNcDdyUWFQRTlJSDBXUGQ2Unkv?=
 =?utf-8?B?V1ByN3p0bUtCWkIxNE45SC9mZzhXd045QkZjYTZlNC9LN3dncHZXYUtSRVRN?=
 =?utf-8?B?Wms1TEZudU1rbTZWTVJQV2MwbVNVVVpEUmhoVEt0OUJKUktDTC9qNm9RaDc1?=
 =?utf-8?B?MEUxUlNhKzJSVURiNDZMZEZHUVNMc05idGdXNWplWWlEWFJ6SHdKcnd2V1NO?=
 =?utf-8?B?NzlwemR2LytxQnU0akk1V0JFUXJLSENVTkNCd0dvSlBaNmt4RGZ1SXlRTVFa?=
 =?utf-8?B?VHRYZFFNSUpOay9XU0s1WlA2Q21wczg4QkdpdEVTZHlBSk1xS3BNN2hjSFVG?=
 =?utf-8?B?cGdnNldGd1kycC9yQlExc1Jaa0FzQWhnNUNoY2xxSC9DZVBIWmYxKzBxYTJF?=
 =?utf-8?B?Q1hXT3VPaGUzYWJ6Nlk4SUhFLzBQZG5ISWg0MFgvekpqQ1pmNnByR1RONHhX?=
 =?utf-8?B?OEtXb1hrZlhkUWYxOFpFdThyQzI3cEVYOThLT2RyMUpwUkNBdm80RUhabUJM?=
 =?utf-8?B?cHIwK3lnaG55NDhhc0pDaEd0dkhic0pZTWoxVEpaNStBRGFOc0QwNU1pRXdE?=
 =?utf-8?B?WGRpU3oxYWRBQ1dPYWZ2d1RmVXZqNTNYYnVZY2hEWElqaFRaeGp4dkpBSitp?=
 =?utf-8?B?UUxtZFBQNG9mNUk2cStTWmw1SnRiN2M3R2VEeTBEeWlMQnlONTdCWTQ1UE1i?=
 =?utf-8?B?bWs1ZXV2WmN3WHVFTFEzRVN5bUNPUktRN1RpYXBxN3dwc3plVlpNcFZ4Zktz?=
 =?utf-8?B?R0VEaDE3RDVsdS84OEw1M1ZHU1hFOUM5b3Q1T3lUTml6a0hjK3NEakxrc3ZU?=
 =?utf-8?B?K0hxL1A4Qlo0U1ByUExnSm1HNWRjcjhWeHk1RXRoY3NoSlgrcjUwNkhFY2Vq?=
 =?utf-8?B?OURVWjZkVkM0TU9EK3NYTVMrcVptNDR0UFMxblpQaGU3RzhWNGs1MzkrR3p1?=
 =?utf-8?B?QWgrd0RkbjRwTEcvcEw2VUpXTFBlLzhETldDK2pkNkNDM2RLbHd6dE4rYTMr?=
 =?utf-8?B?a2RSWHdScWEvb2RuT0hWVG53Tm9QNG1PMVVLZlZzbUFyaGR3Yi9XdnEvVnA5?=
 =?utf-8?B?L2hGLzYzb0d2SjJPQ1YyTjVSNzJ2WmJlZjZ2UEVuMHlZbFNzVlNKZkgrbk5M?=
 =?utf-8?B?QWxBYythVjhxMVJHYmJVV0ZHQktLRnp5L3Ryby9aMFNMMkpPNXg1dDBYWEpG?=
 =?utf-8?B?UHRiaUFMa1k2dHdrOU9UYUx4V0t0QUtROVFiUWdBSTZHcTBlRjRKZzRtRjNW?=
 =?utf-8?B?cGxqYzJ5NXdhMlV5alJWdXEvdUhWcEpMT3AxdXpPRXNlUityKzhRTElFSzA2?=
 =?utf-8?B?MDlhQ2sxMjhRQU9GcUU0Z2dsUjlUVmt5dy81YWZjZVoyUmIzYUtoYjYvNjlu?=
 =?utf-8?B?TmZwQ0FkNUFHcUN3WWkxZFprSTg5QUEza2o4dXAyV0J6RGlFME1HR1dSVWxj?=
 =?utf-8?B?ME5BaElWeHBnV2d0ekIvZFI4WkVTRDNvb09hZ2VmdlJJRFcrcE5qMWVtK1E2?=
 =?utf-8?B?ZGhHNnFxZGwvT2dyODdsTGRWWFJHeGRNN2lLY1U5aVlqK0twOXQyVTd4YTNh?=
 =?utf-8?B?TEZPdkh5ZlNRMUpNMkxFRFRhK3l5aFp2Z0hvVW5WYTdPekQ2UVB4bzRqYzYz?=
 =?utf-8?B?d3ZnSHdQNkErNERPU1V4Vmw1WG5wWWpyTytDTk5GZWN6UHV3Wm04bFF0NGRY?=
 =?utf-8?B?dzBqVTZ3MGZuVFFJbzgxVVQ5bzFZdkVQZGlJZUNtZ3lHZ3hNOEU3c2FrdTho?=
 =?utf-8?B?eE5uUkFmSjhGYkd1Ry9ab09mNy9SOWU2U1Z5a0dzRkhoUTdoMnVQbENIaUow?=
 =?utf-8?B?MVRHRkNZaVhnPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 03:47:53.2243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cbd9e59-ca83-4d30-cbf6-08ddded32d1c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000013.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6744



On 8/4/2025 4:07 PM, Nikunj A Dadhania wrote:
> Patches are based on kvm/next with [1] applied
> 
> Testing Secure TSC
> ------------------
> 
> Secure TSC guest patches are available as part of v6.14.
> 
> QEMU changes:
> https://github.com/AMDESE/qemu/tree/snp-securetsc-latest
> 
> QEMU command line SEV-SNP with Secure TSC:
> 
>   qemu-system-x86_64 -cpu EPYC-Milan-v2 -smp 4 \
>     -object memory-backend-memfd,id=ram1,size=1G,share=true,prealloc=false,reserve=false \
>     -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-tsc=on,stsc-freq=2000000000 \
>     -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
>     ...
> 
> Changelog:
> ----------
> v10:
> * Rebased on kvm/next
> * Collect RB from Kai Huang
> 
> v9: https://lore.kernel.org/kvm/20250716060836.2231613-1-nikunj@amd.com/
> * Set guest_tsc_protected during guest vCPU creation (Kai Huang)
> * Improve error handling (Kai Huang)
> * Disable MSR_AMD64_GUEST_TSC_FREQ write interception (Sean)
> 
> 
> 1. https://lore.kernel.org/kvm/20250804090945.267199-1-nikunj@amd.com/
Hi Sean,

A gentle reminder for review/merge.

Regards,
Nikunj

