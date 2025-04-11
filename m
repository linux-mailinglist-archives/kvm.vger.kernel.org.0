Return-Path: <kvm+bounces-43144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99978A856A9
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 10:36:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CEFF21B88C27
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 08:36:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 279B07083C;
	Fri, 11 Apr 2025 08:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zURtqv4X"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2074.outbound.protection.outlook.com [40.107.236.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB42E293B56;
	Fri, 11 Apr 2025 08:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744360479; cv=fail; b=ZlhWs0FdYFUA+d385MXgfD/f+na2AgayOG1kcK0gw4tZYUKYaH/EI2v8ocRxLT+qeQ/KhGbNKcIFMSvNGSwLHmIxhskbjLsC3NBP6ogXei95LwXxh2K71Ecs1IXeqAi0nviOwTdF3BnR+iYx2r9EGELWt9zoBpIjA0t7BUJl8MI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744360479; c=relaxed/simple;
	bh=8fqSN7c6cNEWZGCxtFwvzbyCCNqxU5tO3WfPbt9svEU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Lqr5ejyVO21VjJJGnOskC/4QJoeLu4Olh5VCEpeOkPH7fRf78DQEwq4Jurj7ABYfvD/eh3jIkG+g5ytK9ltuJvtjFqjDohYZLvXwGYAvQA79QaoJLkpgxzPH5ao7IXg9tD8QbhzLWC01qEY3L0HcVeXqYeiFYgTvDR+wBPG2J20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zURtqv4X; arc=fail smtp.client-ip=40.107.236.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nyGYschMHSoMZAUdzbcTmkQQo5hxjmRLFK0Eobi2+ZA+Ij0Plmm8rIPdJn2YNF71e7+/pvlqYSDUgW2nOyxIQnsrMFtdpSwAYuU+fNOR1Cgp3xiSf1g5LR33/RKKXCn16G4tupbMbPXt9ge3GpSP4lj+aeNXAfyN5IRXFevoxKjIQ4GRHBXZfmrIfzEU0K2RXQITFhk4Eey44wsfClFwbPrECaQ+A9WxnCAvZ9/RfeKCkNe0z+l3/VvqUs8165QKVkXWd3EZjD6dFrnAkkBdCGfM/IWw5CFeAPMtTEeZaUIbf+OA5+KkLzW9UTC6bMPsBgYWvLiHiWsIrvouWnC+yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uHzH1eYrtDX30QmOnUvnDe+UUrlQ8cN69EV+gWOaDA0=;
 b=k0XGOZzib51w0pLJ0p18e+QPBKG9AQJtOQHZwsSCDgjM4IDVf4buZm2qLHrteijOL+LbzYvK7LYQ/kH6kcUsMRcr72CD9CxCjwq32VZghcAHd6KQw4fFTYBGTAuRCuk8G23pi//cVVfKeZIfbrjl4SKjz+eKrj+XXLGyRUGEgu3LOOPnZGEI7KpetfN3CbxwvXREvL+qvzwcbsDRjwUpXlyXSArDEh56tTX2zuAhH6c4/WI/YPYtStUkBiobFsVfWJ+fgScKLO3v3fevcBZeLymNki6KgfiAlIPogbiYxh1uCdM1yR9awdKOaMDfQfzvGAEsr8WGmzbsfR9rh/r5oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHzH1eYrtDX30QmOnUvnDe+UUrlQ8cN69EV+gWOaDA0=;
 b=zURtqv4XX/LGvmnJ8vTklgJ7aoRlbJvRp0ROM7rwvL0mFluwaibhGhbMA3mn0W9hmr7f59SejfotL0GU9FN9B0+p3QvKG0G3VUkexaCMXhHcgFV+KLazgDrV0/dLMhR27HhIpVzJ3m1/XXRNjWFkh+n/6C1fMOqZB2GFhpdoasY=
Received: from SJ0PR03CA0081.namprd03.prod.outlook.com (2603:10b6:a03:331::26)
 by DM6PR12MB4219.namprd12.prod.outlook.com (2603:10b6:5:217::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.22; Fri, 11 Apr
 2025 08:34:34 +0000
Received: from SJ5PEPF000001F1.namprd05.prod.outlook.com
 (2603:10b6:a03:331:cafe::32) by SJ0PR03CA0081.outlook.office365.com
 (2603:10b6:a03:331::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.26 via Frontend Transport; Fri,
 11 Apr 2025 08:34:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F1.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.13 via Frontend Transport; Fri, 11 Apr 2025 08:34:33 +0000
Received: from [10.136.43.133] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 11 Apr
 2025 03:34:29 -0500
Message-ID: <686dced1-17e6-4ba4-99c3-a7b8672b0e0d@amd.com>
Date: Fri, 11 Apr 2025 14:04:27 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/67] iommu/amd: Return an error if vCPU affinity is set
 for non-vCPU IRTE
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, David Woodhouse
	<dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
CC: <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, "Joao
 Martins" <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Naveen N Rao <naveen.rao@amd.com>,
	"Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-6-seanjc@google.com>
Content-Language: en-US
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <20250404193923.1413163-6-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F1:EE_|DM6PR12MB4219:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b6ebf47-dc17-48f4-57fc-08dd78d3afe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Uk1HZ08zYVNhNEYxRjBNRkJ2RXJMa25KbUhOQjA4Q3hFRzd1dWVMeS9hU0Jy?=
 =?utf-8?B?MjFwclA4Z2VFVGdtUW1sZjdQQUI3TXdsV09qK3J2VU8ya3ZwQm1wdkFYK2Fh?=
 =?utf-8?B?WG1pUFhEM1JXU3BycnFoazQ1YXNrUlpkVEorbUtDZzdsNU1oT1g1NnUwRXRv?=
 =?utf-8?B?bWJvd2pmd2ZTNVYydUdIdm5TZ2RNUnZGVHd4OXI4b05qbkZzTzhXd2R4QjAr?=
 =?utf-8?B?VGFTbEl3eVUyUUFzSDBqNC9rYUtFQVJqb3lxU1krelVwSHlBZ09FK2gvTlFY?=
 =?utf-8?B?REFRL1Q4YlQvMlh2YWpOTGtxeWNZVyszNU90NDYyTlA4dXFDVUI2K0xlRGxu?=
 =?utf-8?B?V0lIMXJWaEFhTW5iZWk1OU9WUzhjK296VXhMYUR5aFNHaEx6V1dwOXNVUndn?=
 =?utf-8?B?SHN5ZjlaT2VzcUV0amxIdkUyU0JrYzh1ak9aUFJLYmppQkozYmNDanpPM0c1?=
 =?utf-8?B?NU43M0tMMFRVN1owL2ttMEM5ZFpIOGFRSnhFN3NOVTNhc0M5cEN0Vy9VWVc3?=
 =?utf-8?B?SU9Odm9QaE5QaXNSblh4V25WWTR0dTA4NVRldUZjUXFPTTVBckRaYThqM3hR?=
 =?utf-8?B?aTRrcEF6V3BoMHhkQ010NjE1YXlPMkkydFBqVFhGVlhHWkh6ck5IZmVuNElr?=
 =?utf-8?B?RjRwdkNrOVNTVE5Md3NrckZCSU5DcUsvSlg5NHVNQkVWTUxzUURHYWxWbDVV?=
 =?utf-8?B?elBwendmUnNXNU92NUYwVWJQbTdmSU9UTFdvbHl0cDE2ZmRGMExwZGF6TXdH?=
 =?utf-8?B?WDA2MEZKNThPOVRJVHRybDRYbWtOem5kbkNFYUV0YXB6V0lVaWU5aUc2MzVn?=
 =?utf-8?B?aWRiZWZIcUEwdlhxQXBqSEJ0Y29lWkpXQ3UrdjU0RXNXSWloWTcwT1pLemdk?=
 =?utf-8?B?cFFvVHlaSmh1dW9YR1laeVFDdTZ5QW9yVS9vaWIzSFV6M3RGUjZIUUs1S3R0?=
 =?utf-8?B?MlNZV3JSUEdjNGhyTzFtZ09qeG1yTjR5VElCci9HdXBMaGs2WW9mVFFWems5?=
 =?utf-8?B?VHJDbzN4WXN6K2JyN2ZreksyRVNmNVVLdFB0U2pwYUd1d29oRTdHaUpvS291?=
 =?utf-8?B?dlM4dEV6dnkyalBhN1lROUFGLzhHZGJPeDJJbm5qTTVKRG0vWVNGaFpLdXdR?=
 =?utf-8?B?MmZOdDE0UDVFbmJLZHlvU0tweGRzQ2p5aHByTnRGL0dDMXZKUHQwT09YSTRV?=
 =?utf-8?B?OTN4Yzl6cDBPb1VCOW0wdGFmUVBxcWtYZTFQb1grTVNyNzN1RU0xckJWbDhJ?=
 =?utf-8?B?YU4rMzFSVnBGZ3ZKUGMwb0gvYWFjSDZQSktsdUlzdVBwVG52WG94U0ZsdDQz?=
 =?utf-8?B?SCt2OXI1alUzOHB3aVpTSEJlS2M3WTVRQmtEa2tOMEY1RHN2RlltcFBuTDBF?=
 =?utf-8?B?eENISmkvWXMyOUlsMTdmK3RRS0RDazZMOHpXOFBkU0FudW5td3JLSk92ZTkv?=
 =?utf-8?B?alNhSU8rcDcyNTRCMmRUVEJWTTgxWjE5ZW82V1ZlZWd4Z0h2MkRrUnhHQXpM?=
 =?utf-8?B?ZE9MR0MwN0lUNWUvdHVUSkxObzArc1IvWDhhemk2ZndxdVVxSTh6M1BOaUE5?=
 =?utf-8?B?SGtMV0J6QUtFbDNUUVYxSklweXJEZGV2a2s3Y1pvQ2JWNzdIOG9Da2ZiRENS?=
 =?utf-8?B?ajJZcFhtdlZnam05YWk5UWxXcmJVL0VBUzlMTjZUS0NEV2VBbzVFT3c3aTJZ?=
 =?utf-8?B?RzcrZ1pjWHIvNE1LbFBpb29pZlVHSjhvS1BDZk9GMTMzSjVucGVaZnU2cFVt?=
 =?utf-8?B?VFk4elc3cVFkaDk0UENHY2ZhbzYwUG1VYklpdTR4RDVxeGthVXRzY0RDRGxz?=
 =?utf-8?B?czl0L1NCK0hyUWNnVW8yY3JQajlDaUNLL2V0UVo0c0hndWJQSHVZalo5V1cz?=
 =?utf-8?B?MndpWnBVTE1VU0xjZ0FhRGxkQzZvOGNoU1Z6TGEvQzdiUXVPWjBiZGY3ejlC?=
 =?utf-8?B?Nnl6U1duMFFlZWcyZXBCaUNBZDdYMkhadEZvS2xzWFFKazBSUmtmYXBJR1V3?=
 =?utf-8?B?RHB1b010ak9rVWZtUWQzT3MwWjh5andpdi9INmJOWEFWSGNNQmVkM0pJUGlJ?=
 =?utf-8?Q?/WQ8I4?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2025 08:34:33.9285
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b6ebf47-dc17-48f4-57fc-08dd78d3afe1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4219

On 4/5/2025 1:08 AM, Sean Christopherson wrote:
> Return -EINVAL instead of success if amd_ir_set_vcpu_affinity() is
> invoked without use_vapic; lying to KVM about whether or not the IRTE was
> configured to post IRQs is all kinds of bad.
> 
> Fixes: d98de49a53e4 ("iommu/amd: Enable vAPIC interrupt remapping mode by default")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   drivers/iommu/amd/iommu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index cd5116d8c3b2..b3a01b7757ee 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -3850,7 +3850,7 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
>   	 * we should not modify the IRTE
>   	 */
>   	if (!dev_data || !dev_data->use_vapic)
> -		return 0;
> +		return -EINVAL;
>   

Hi Sean,
you can update following functions as well to return error when
IOMMU is using legacy interrupt mode.
1. amd_iommu_update_ga
2. amd_iommu_activate_guest_mode
3. amd_iommu_deactivate_guest_mode

Currently these functions return 0 to the kvm layer when they fail to
set the IRTE.

Regards
Sairaj Kodilkar

