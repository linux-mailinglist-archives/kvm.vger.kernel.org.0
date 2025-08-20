Return-Path: <kvm+bounces-55121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56E71B2DAFA
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 13:32:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D68735E5E4A
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 11:31:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2F722E54B8;
	Wed, 20 Aug 2025 11:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EJjYg3HN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2065.outbound.protection.outlook.com [40.107.236.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486AE2E54DD;
	Wed, 20 Aug 2025 11:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755689447; cv=fail; b=Um+4Zb1PHKLAbGnuS24KPMfWRSNg30Y2jpp63xIaP9EnQvvw6XwreP/8kQqxpGiMdwx7uGslbwo+PUca1qRDbdMt5w8wkAAhH4UmP79LsVomZpaKQTSZ5Cstbw007tDOYGhgYbKj29OkmDF4jUVUSFQVALCgPwATFPKQ+2+0RSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755689447; c=relaxed/simple;
	bh=ax4ukcH/UQs6KdVPUiwjxcvPLGBwIr9S9oMrGZtiDDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Op+UQBDnkZFFYnu/ZKpayp/Ke/OHxjFywg1XorOFhXP8hd6f57CClxatSgagHM5nFgv/tYnQgt8PwtrcQDuUQSEx1SeRF11zf31zU8qJAU8xLBX367al3/Hnttun4ZLSxBkLDvGCTW2p3mlqhdPqcEGInrTdaCczXxbFPSOx8WY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EJjYg3HN; arc=fail smtp.client-ip=40.107.236.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eu8bQIa4q6c1m3AXpXxN43PtgpFZFaJchddi9N7w8S5E/NVhQF1RFXYHfazNF6uLtQj9C84jCI+UcI6sDNCfcYJ/eAFPZnZQUoP4CLfhOxkUPgFYPu0GgqqEEzTZb9DUu3lwZUxxz09MD625I4NX0XdIohpDOWMFJZH0zLJBtn76zPWDoJa2Yo0opR6vYILIBn0On2iLKti2Yj4uGVLO0MpDQkZ370G4/pF8jcVBQx/sOXrv6ItK8s1liNT1EB/ickKsB8YTGTJVy+yoR58Pl44JYatEup80kycRy0L6mKD2aXsADMIUR8LvAVsv2SWypbTfs3wzHa+tgJyxViSCvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gHfiM8Ln64A0shykxkm7WoG939OFXacreaxfIrqU6DQ=;
 b=CwH3t1RIVbnDOxBYMGItZbIaf1yvsnEhuGFoZ8/fhSRAHAD9uI9C+ftAptWWcMcBExbgF+6I+GqXqepfsNfUVYtDPYIWGKttSIwgSfgJVUb8zsWvJdg5SC7ZaGWTJUo8ggnnzUb0KP9/k8S/1/jj4BPROi+MpMv8mxYpy3HQy3j2f2Yi/Ihc7wKRtybjtqCoYHBac2wfMVR4g3IZM6KFcwGxKQ0ILNXunPqsAMgn99ybY5pjJ7XeRuXvFDooq6Z7xpoyi/abdqHsX/bviwM0HJ7mFUbTp6tP+MJe+WPLeru2T7vZZdmPgsZuC9Qj0KmhilA8ueDRXyg/P8y9nA8yPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gHfiM8Ln64A0shykxkm7WoG939OFXacreaxfIrqU6DQ=;
 b=EJjYg3HN1NwiiGvlbRt83FBPLQR+/m+6PL2uxWi13NVM3ST51m3U3JRMjAAP3o5rBrosr5Dx41oP6M04CPYp+YXYEgpg2/LTLWyF7Kv+y0+Knfj2eGykfgmraiMIVSvfpZtR7M8FfZRGk0Fg/4M1v0Ar8iOfauePPjU5Ucf6VJI=
Received: from BL1PR13CA0336.namprd13.prod.outlook.com (2603:10b6:208:2c6::11)
 by IA0PR12MB8226.namprd12.prod.outlook.com (2603:10b6:208:403::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Wed, 20 Aug
 2025 11:30:43 +0000
Received: from BL02EPF0001A107.namprd05.prod.outlook.com
 (2603:10b6:208:2c6:cafe::e1) by BL1PR13CA0336.outlook.office365.com
 (2603:10b6:208:2c6::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.13 via Frontend Transport; Wed,
 20 Aug 2025 11:30:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL02EPF0001A107.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 11:30:43 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 20 Aug
 2025 06:30:43 -0500
Received: from [10.252.207.152] (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 20 Aug 2025 06:30:40 -0500
Message-ID: <0a2e3ae2-6459-46eb-a9a3-2cab284a49f7@amd.com>
Date: Wed, 20 Aug 2025 17:00:39 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 0/8] KVM: SVM: Enable Secure TSC for SEV-SNP
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "vaishali.thakkar@suse.com"
	<vaishali.thakkar@suse.com>, "Ketan.Chaturvedi@amd.com"
	<Ketan.Chaturvedi@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "bp@alien8.de" <bp@alien8.de>, <david.kaplan@amd.com>
References: <20250819234833.3080255-1-seanjc@google.com>
 <afcf9a0b-7450-4df7-a21b-80b56264fc15@amd.com>
 <755ca898eab309445e461ee9f542ba7a4057d36c.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <755ca898eab309445e461ee9f542ba7a4057d36c.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Received-SPF: None (SATLEXMB03.amd.com: nikunj@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A107:EE_|IA0PR12MB8226:EE_
X-MS-Office365-Filtering-Correlation-Id: 179c0c75-5b82-4799-43e6-08dddfdcfffd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VEVFS0E0Z2pIZi95UEladStDeS9EbUZpOTdiT291WE5vaS9DbTM2ZTVlYUdX?=
 =?utf-8?B?bG9YSXJMK1A4VlNYbW5Ga25jVWZUU2NjeW1MelZXYkZ3Q2ZPd2ZFMjRBNXdt?=
 =?utf-8?B?QjlaQ0ZJb1RBYTY2Zm1nL1hvOGpBUTRGb0pqdDZuSlZnOGIxeDNpK3VZNllK?=
 =?utf-8?B?YjRqRG9TdUZBZ1AybFhmTlA0TkFMZEcvdzc3OWxZMHU3ZGNqdnlUMGRxbVdW?=
 =?utf-8?B?bUFKRHJabHhjNmRiajBlblQ2SngxQUlVc2I4dCsrU1BLc0htMWYxZDJsaHRS?=
 =?utf-8?B?bnpNaGpwM2Z1SThqcXhZUzZPTzlDVloyVHRmSHZRUGMyNWIzaDZqOEJYcWJT?=
 =?utf-8?B?eGszUGlkdk9teWR2OTBGZ0o5RFJmZFRhTjN5aXpoZThMRmo1WG90TmIxRnl3?=
 =?utf-8?B?d2xsamNtaGRsUU55LzNzMEh0NjhmNDd3NURKajBCakpHRVIrTE9yTmt2T1pl?=
 =?utf-8?B?Vk1NMHdzbHRlaUttRlFUejVSaEpDQnVsNkw5QUpQZEhaTSt4Uis5RktZOFUy?=
 =?utf-8?B?WWtrWHlIZWVLYWo1QnZ1MUtQSVhNSEdYclZVSUdHRitxTVNLM2d4SHE3ZXFU?=
 =?utf-8?B?bkYzRlZDVVNiWjZxM2RuV29PWkNoZmlBdjl2bzBTdUZPUE1HalZmK2s4SjV0?=
 =?utf-8?B?aVNDMjkvS2pEdGF6ditIYmxlSDZZeitnbi8rZm9oK2pqaUF1bzI0WGJqRUg0?=
 =?utf-8?B?ZGJxa2h3NjhPV1JCK0lLTjNDcmJudkdhSktEMDN3OHJoZXhobWpsVk1aVmdW?=
 =?utf-8?B?MG1nMGt2UDBDR0w5em1FbW12NzJKdmJZd3NnaFZSR0x3dmtneVRDN2daV254?=
 =?utf-8?B?QkRDWHRNcTJxb1lSOWhxUVlpNE1jdHM1QkFOWkRPVzY1c2Q1b3RNWnZNamkr?=
 =?utf-8?B?Tk5oNW5zUFVxMGh0ejEzZFJjMFF4MnZVd2lWTlJqMjhFVWR1TkRuSFhPYVFv?=
 =?utf-8?B?L3RhOTIxcWRzc2F2NHFTRWQ2LzdSZ2gwNzJNR3ZnK0YyVXh5U1NWTUw4ZzZ1?=
 =?utf-8?B?TzUxS0hRWkZ5ZitoUGtRT3VlSzZMM2VlMnBXMzBJSVYvN2dDS0xOK1RRdWNt?=
 =?utf-8?B?UW9KNmpUZWNFeFdvZVNMemY5UFhoSWpFTGtrdThvZXZFRXJYSnhtRFB1My85?=
 =?utf-8?B?bUE5Q1h2SzdvcHVMMjVCK0ttSmQvRHdoWlpZcTc0V25KVncyNlErWVhDWnVF?=
 =?utf-8?B?c0F2czU1aHpocXBnUyszaGtPdTI4MXBEVFNJZVFOcDZHbUxIV0JWT2p1eWF5?=
 =?utf-8?B?eXRVSXVmVkRRRjF2aWF0WnQyVGtjVkpSb0o1VmVtMU5WditpTU9STVpJWk9n?=
 =?utf-8?B?a0szOEFzanJhbUQvVTRGQk1sRTRtU0xIN2VpeGMvWDAvZmJLU25wYnFlcDRF?=
 =?utf-8?B?bDM5S0YxSVRlbWxmYmVNMUhqU2xCUm1pQ2dhcUxpTU1rTnBSb2g2NkpwckJN?=
 =?utf-8?B?QThWRzMrek1vVkNCbFVHRm5sWkVuSXgzV092OTlBOVN2eVlzYUNYUkUxVU4r?=
 =?utf-8?B?TklpZUtIcDRuNkhTV3k3dmRtL3hDWEVJRmhOd3plOTQ4S0hLM2ZyRC9GVE1p?=
 =?utf-8?B?VENpTG1kTmswUDdkRjZtVG10WVlkUkx4eVZvSGM4YndUVkk0dnJ4WEFscEtZ?=
 =?utf-8?B?OTlnN3BTelU0Q3pqZ1Fnbkw1R2g2Q3BjSFB1eXhOaHhLMlY2WWNQMEV4Wnc2?=
 =?utf-8?B?QWk4RFpNYzhBYlFFc2J2WnFMOW9NcVZXOTFDWDZFSXNzck9xSVpoQjFwbmpV?=
 =?utf-8?B?QmdrUHZJdmNncTlzdjZicnYyeUNBUWxEN2J0TnFhTlhNei9DbzQ2WDMyZUpr?=
 =?utf-8?B?WjlodDNZYUdaSUpoelRuN0lxcHFtRTloVG5SVzljK3NRbktDSjR4c2VxTEFk?=
 =?utf-8?B?MUxicllZZzFwdkJZMkJHdGNPVVRqUzFVd2E0OURCS1MwYjVtOEVBM2dXMnZI?=
 =?utf-8?B?VkhiQ25FK0trd2JuL0JFcS9LdzZMMllpS0M5RTg0RzdmM0xXTkQ0QTAzU2Ry?=
 =?utf-8?B?Z1k3ZU1ueE55MFBOZGxLeWxXVVQrRktnMzVuSUNRenJ5M3h3U1IxOWQvL2lI?=
 =?utf-8?B?aGJxS0RKRXRwMVZpMlg0d245L1dSKzlYVjhYdz09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 11:30:43.6625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 179c0c75-5b82-4799-43e6-08dddfdcfffd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A107.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8226



On 8/20/2025 4:55 PM, Huang, Kai wrote:
> On Wed, 2025-08-20 at 14:18 +0530, Nikunj A. Dadhania wrote:
>>>   - Continue on with snp_launch_start() if default_tsc_khz is '0'.  AFAICT,
>>>     continuing on doesn't put the host at (any moer) risk. [Kai]
>>
>> If I hack default_tsc_khz  as '0', SNP guest kernel with SecureTSC spits out
>> couple of warnings and finally panics:
>>  
> 
> It's a surprise that the SEV_CMD_SNP_LAUNCH_START didn't fail in such
> configuration. :-)

As mentioned here[1], this is an unsupported configuration as per the SNP
Firmware ABI.

Regards,
Nikunj

1. https://lore.kernel.org/all/c3e638e9-631f-47af-b0d2-06cea949ec1e@amd.com/



