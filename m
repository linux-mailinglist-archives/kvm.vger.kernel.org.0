Return-Path: <kvm+bounces-60131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1112ABE2596
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 11:24:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 86C5E350C6D
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 09:23:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 232ED3164C8;
	Thu, 16 Oct 2025 09:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uGjM4npn"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010010.outbound.protection.outlook.com [52.101.56.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB766325496
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 09:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760606633; cv=fail; b=h4RXaPC6mdd/gHFLfFuO6HZ2QxNOJr8SvPHSnS+MaVG5WuG7V+tPQcFbLaySk6L1NJDhivkupJaZXQsGnjYeukukchI5bgd3GSt9a7tef/a46Y2uMQ9MQe5HKxiQXXxvYJMN1HWyujTJyhfwBh02e+ZclXZO+Ac4eyTJZTIkgGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760606633; c=relaxed/simple;
	bh=CKMINANXBOhcR2IQWI2/SccktL9TASYQg/tA+vLkoXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=NZ67arFQxuYM72mWZB1teBHqRVYzSVMfThWS8/7vJ2SG7bSOg7VVT++XdPyFsHc9Z9aHCUo1CJPFY/V0pPJC/5Olc4CATEBak3dK6UG8XbN+la92FTRX007aKru//7ARbs8zenaFR2USiW27Sy0+zCoYujhCemDSrSQRdIHyNIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uGjM4npn; arc=fail smtp.client-ip=52.101.56.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g86BA4w84MpJANrFUfj5OkAx4Qb3kdDZpGyRYn50vBLiDJQ/G4TkHmqrOp4KHDumHAxpTSECOepvZYcF6iUJMqPnFqA/ipcwYcVTTzrwniAjTVfEAZDWlQ3OQxO0LMv4Jc6ncpqtuS8KH9YoxjSXrM7rEfMgtZSi/TevvyIZ3dLQTk7A6ODMgXkE+nqhvumghqWwnb12YmkbgoqMhwnQj70iCIzDGtDLYVikgV9M4ZgcwCbskVT8+1qzONCkXUOzC99LDJqy2SKUXdbgtm+m18iHC+Jt5iGfRRLVdxrw7FN0V3gIDW5osyNKhE7cQS6yOD73I1iV56f1KqqEPtNoLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cm0GHAPthcrjUspjrLdrtPx24b15/ggABtO43Agj5Rk=;
 b=lJ46YHR5nXBFtppVpeNZ18CISCPPwu7W/TUjiEqrAsZShDA2UlLUyYy5HEa0SwhUF2jdFNrJ8KwOTOXto7GEySVHf4XZ42MWv8A4nrGucyaJdW9tiQz2M3j6in6ayqLZSKfr9LUw0vsShyJKMhy84mbsqMVrGfb8wsp8iLsampiDu7ltUIZlVPURoTnp/BQxUzYkMSSIDPru7im34tfF90CbRjkOG76kK01cJredaJocOb76xe382KafjcsCww/6fROV/u7LwPtOjI8YNqwsCW7V/Mf2KYl4c2W98sLuDeSd7hKOLZuaQtxCoVfV2813SYQnb90ZMtEYOD4y1aSUhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cm0GHAPthcrjUspjrLdrtPx24b15/ggABtO43Agj5Rk=;
 b=uGjM4npnxGTeWSj4s0IgeoGJERPRhKtVTXeFRVli4Tcco4qdhKjHIc/8QI+ceahmCm6u016whg34O/uibwAv8kJUxpZdLMupRMHLURPRXR3DsGgAr24aiQfknSO2PNhiHGIHkD2PTGwVMuNB+KFkSfGwpMun9hdcOrHPs031oAM=
Received: from SN7PR04CA0088.namprd04.prod.outlook.com (2603:10b6:806:121::33)
 by SA1PR12MB7368.namprd12.prod.outlook.com (2603:10b6:806:2b7::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Thu, 16 Oct
 2025 09:23:47 +0000
Received: from SA2PEPF00003F62.namprd04.prod.outlook.com
 (2603:10b6:806:121:cafe::41) by SN7PR04CA0088.outlook.office365.com
 (2603:10b6:806:121::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9228.11 via Frontend Transport; Thu,
 16 Oct 2025 09:23:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00003F62.mail.protection.outlook.com (10.167.248.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Thu, 16 Oct 2025 09:23:47 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 16 Oct
 2025 02:23:45 -0700
Received: from [10.85.38.18] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 16 Oct 2025 02:23:43 -0700
Message-ID: <894b62e1-03cd-43b0-8105-3f3d52b19abe@amd.com>
Date: Thu, 16 Oct 2025 14:53:42 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] KVM: x86: Move nested CPU dirty logging logic to
 common code
To: "Huang, Kai" <kai.huang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>, "bp@alien8.de"
	<bp@alien8.de>, "santosh.shukla@amd.com" <santosh.shukla@amd.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
 <20251013062515.3712430-5-nikunj@amd.com>
 <30dd3c26d3e3f6372b41c0d7741abedb5b51d57d.camel@intel.com>
 <8b1f31fec081c7e570ddec93477dd719638cc363.camel@intel.com>
 <aO6_juzVYMdRaR5r@google.com>
 <431935458ca4b0bf078582d6045b0bd7f43abcea.camel@intel.com>
 <48e668bb-0b5e-4e47-9913-bc8e3ad30661@amd.com>
 <90621050a295d15ed97b82e2882cb98d3df554d5.camel@intel.com>
 <c459768f-5f9d-4ce5-95ff-85678452da57@amd.com>
 <0b333ab4b73bcc26bd143b522b4034055ec4e770.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <0b333ab4b73bcc26bd143b522b4034055ec4e770.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F62:EE_|SA1PR12MB7368:EE_
X-MS-Office365-Filtering-Correlation-Id: 32b548f2-3d32-4d2d-3f75-08de0c95b5b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?azVNLzBWd3B4bUZTeFFTdURJbVJuQitUNHUrRml4ZS9iM2ZSeEtYaWNIOTFY?=
 =?utf-8?B?VGZ2MytGK3JtVVRrSmp2T1hQOVJNZHd0Y2lKcFBjTTh2QWoxZCtpSWlGdm9p?=
 =?utf-8?B?VjhzOFNSSWVEZGlsbTNGb2wyUWpNSFBValJ6bnczSVJ5SzJSN2M5OHdHWUJB?=
 =?utf-8?B?RGZjRmlwSW5EdFJmaTdaOFhteE8vdG5VZVFZa0VPbndLekdVRzB4Y2lKUENY?=
 =?utf-8?B?Y0Q4YTJmNkVGU3VGVW1PUm5QT0t4MnlYMzBOVjhmZE5jaHJTaEhoN3RQN2M4?=
 =?utf-8?B?ZjhISDBTZldBeDFoOWFqQlFzTktmRWVLN0djZjFWVGJjRjgvWmxraDcxMTNj?=
 =?utf-8?B?Rm12R1BRVjdwVnpVMklVZWZCa1FRVURPemRBMjRpaTArUGtwYmh4NTZaV3NE?=
 =?utf-8?B?VHZFYmM5dlF6SlUxdVF1Mko1TDIzQzFOdWV2N1BBcVhGWjdNZmpHc1hOR3BS?=
 =?utf-8?B?Y0tnYmRDT0tVd0U5YlQ5S1V5bEJNU0tVUmMvY2VDNEx3NkpzRXRKUDRXaHRG?=
 =?utf-8?B?SDh5M09Eck9ycTdEdmd6MHJvM3BOMlFNdzZFQ1JWREZrRkMwbWhmRnlleWlM?=
 =?utf-8?B?WUZHRnNaakVBcjE1RldQRzIwbU0rSzhwWHFpSVBCYUJGRWpiVmdGajkrQkRH?=
 =?utf-8?B?YXNycVlUNjVORnpMYXV3ZUxRbjlYSm1abFdiMytWczVQdWtDaEQ1WFl6TXRs?=
 =?utf-8?B?NmJpZlZ1U3lJcU42NGZsN3hxRFYydC8wVFN4RFFZKzJsN21hYWtld3poSW14?=
 =?utf-8?B?U2ZUSVlrSXFUNFZ2Q3piYlA3NVErQUZzajF5WVNLV1M4V0hOdjRnNEFnUDN4?=
 =?utf-8?B?Z3JxcS90VE5lTnBEcFdLcU1PWGtWTmdmZXpZWDNNZ0xVMVArNXplOG8yRnpC?=
 =?utf-8?B?U1daMmN0QStkNTY3VXRrYXBjS0JjcFY2S3dxc045UGl0VkNTaFdHakpUM21H?=
 =?utf-8?B?NXZKK2pOeERid3c4Mmh5TTRlZEZlM09IQVh3ZGZEUHd3ZUVLZWpFeDVFRzZI?=
 =?utf-8?B?c0xMbWpFdDhmRnpPdVZXNUVtV2RBNjliYVpndnBuMG94amdOL0pkc3NmZjhM?=
 =?utf-8?B?NGJxWEkxTVc0TDBJT3J6V1RFVkpIcFpUUlpkcUNYbHJZaWNuajAyeDFEOHpv?=
 =?utf-8?B?OTVQTmNic3pNQWJtWjlxejNVaW9nZWpySWZOV2FXak9QNzFxeVRQajBBbnRs?=
 =?utf-8?B?a1dhcVJjMGtzREV2dFNKbVVCWUtOY0oxRy81dHgxTzE3Uks0RHIyTzFrVktD?=
 =?utf-8?B?Y0J0TEtwK2ZHYVNoTS9PTlQ5U1dlUjR4YXJRanIxQXBweFhWOWxmOWkrcFJm?=
 =?utf-8?B?b3ZCOERDS3VmWXJNc1kzYkVibTR6YlBpVzV6RU52SStqaitjYW9VaUp1MTA0?=
 =?utf-8?B?dzk0ODJuRFl2bndpTjVIN29vL3Jod0s0TmgvYVdwVGlrOU9KNmhXbjRhbGho?=
 =?utf-8?B?OUZGemg3WXBKNlhGZjJZNWZLcjVkNTlpbGtQamZ4TDJVaXh5Vzc5dThDZE5D?=
 =?utf-8?B?aC8zSC83T2lwa0ZCeS9wbjRvbnc5b2xleUVVU0xqVzhqcko2RHBtT1JnaGNa?=
 =?utf-8?B?T29GQzV3Uk9WTlNPcGtNS002UFIzenIvalJCMXFPaFh2M1RSM0lMdG5QRFYr?=
 =?utf-8?B?Um5rdHNCd211MzBzeXluWEw0Z3pPdCt0cm1DSEpEUElsRUpkOFhzRnRHc2ht?=
 =?utf-8?B?dW5yYTg1SDdFOFBHSHVxSG5rUGhndlVwMmRzRERVTmlLVkZLU1MreVRVT3FD?=
 =?utf-8?B?UldBVXg2L05XOG10azVlSGRxRU05VDBVTGNqT1RzVWpIalBGSnk0eEtwZHEx?=
 =?utf-8?B?L3p1SDA2RlQvOThGelpRNjZSSVVhQWpSUnRJN2dreWNtYmM2dUQwL2dYczRh?=
 =?utf-8?B?SUNpMFVLYjIyY1dWL2tkdHhHUVJJL28rNFEwd3FzZzVVQWpMa1E2V2c1VFpS?=
 =?utf-8?B?K0h3VzRrYXJVYURRRFdNM1B3dEo3UndwczNKbXo1K2dLWm84QThiYWF2MnpW?=
 =?utf-8?B?V1pmK0xnUjRQUDRpalB5MnBWNzk0bkx4a0dzUUpDbFBOd1VUOS8xQlhobjN6?=
 =?utf-8?B?OGRQYUlPYmloY3RTcnQ4aHVvRDFMMWRYclZTN3U1cFJ1VVkwS1dUYWl6UFBp?=
 =?utf-8?Q?m37U=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2025 09:23:47.1001
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32b548f2-3d32-4d2d-3f75-08de0c95b5b9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7368


On 10/16/2025 3:07 AM, Huang, Kai wrote:
>>
>> I have something like this as a separate patch in my stack:
>>
>> From 21c3b91ad53dfc2682c01663fe65d60c9424318d Mon Sep 17 00:00:00 2001
>> From: Nikunj A Dadhania <nikunj@amd.com>
>> Date: Tue, 30 Sep 2025 05:10:15 +0000
>> Subject: [PATCH] KVM: VMX: Use cpu_dirty_log_size instead of enable_pml for
>>  PML checks
>>
>> Replace the enable_pml check with cpu_dirty_log_size in VMX PML code
>> to determine whether PML is enabled on a per-VM basis. The enable_pml
>> module parameter is a global setting that doesn't reflect per-VM
>> capabilities, whereas cpu_dirty_log_size accurately indicates whether
>> a specific VM has PML enabled.
>>
>> For example, TDX VMs don't yet support PML. Using cpu_dirty_log_size
>> ensures the check correctly reflects this, while enable_pml would
>> incorrectly indicate PML is available.
>>
>> This also improves consistency with kvm_mmu_update_cpu_dirty_logging(),
>> which already uses cpu_dirty_log_size to determine PML enablement.
> 
> I would add this is a preparation for moving this code out to x86 common
> to share with AMD PML.  Otherwise it's not a mandatory change, albeit it
> is slightly better in terms of code consistency.

This change is not related to AMD PML, but instead its a generic
future proof change for both VMX/SVM.

> 
>>
>> Suggested-by: Kai Huang <kai.huang@intel.com>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> 
> Thanks for doing this:
> 
> Reviewed-by: Kai Huang <kai.huang@intel.com>

Thanks
Nikunj


