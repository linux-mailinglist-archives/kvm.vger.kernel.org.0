Return-Path: <kvm+bounces-68050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 248BAD1F519
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 15:10:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A2579304435F
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 14:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67C812C0F69;
	Wed, 14 Jan 2026 14:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="12c/VMCn"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011030.outbound.protection.outlook.com [40.107.208.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3430D2C0F97
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 14:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768399731; cv=fail; b=i+02Qy5culQOtzW0CLyedTOaJezunSa8tReZtwZvDnekLpSC3rYWDu8GvKoC2oddgq+czYpshGm33IlCT++e8Fy5FwEVG10hftfWMHSIZeifwnjZVOQAFq0MA8V7m/2Rn/QAqs06WSNoyK7Rr+gav8NCnfI8i0sxc99Ut0rfYOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768399731; c=relaxed/simple;
	bh=hg8Yqa4zSs1lbzvhGRDhLUGouqvgwbXrU/F7+76tEtA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Nv0EZZW09P4gp/OFD2B7NWwbsJYbtGTmh67hc16KC6B5hKNaTUV+IidWeuyOm+0Yw+RRzrpIO1RZznNGubXTVZrlYu4Zh5SVhpHJqxZFEG2Qlni6LuHVFjQ7mUJGFKxcqVm6ryauTE6pKoOBiB2ag5sQfHWKJVIuUJOaHacX4KU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=12c/VMCn; arc=fail smtp.client-ip=40.107.208.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uVtvPGYTs2rhjV03tuDP8c7of2eiKsR/3JNXGQ2amrvsIuKip6Snu+2K51ESBcuiCtyZV1bo6SHld47e1xNz6as9MKXYgLhigO63lkEFGWbFp6fjkSrtDyL/26bORrnM7JRuzaEZ4eQs58wlzmK9ri6USO1xJePg+YnY9Fv3Yctiu2ZKatyFmLYJ4Byl3BWxLsd8jKLPgq18XUj3e7mQMYSg/UZwES+5SdevJZnD5UWvHCvo8Fl5Q0ba3vuxRQFjbu1fJ+C4VGVohwmZItm2HFgT+0jzqNC5ebhZlrrept3dDwBU+QkU1KBVJlIyGjB07Upc5tfqNfJ1Zsn/Dci6mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rNBtWon5YDjOvxXNKXy/RAS4vSVgHhF6EIHtB2FTAXY=;
 b=j4kA7MNX249yJcumCpShaLsLMBqyX5Ctw0UKdMS7oWaVw056k2oSq/t3yKyvmoDO5TKndBqY6URr3ce8hKSkcN4bwMjvtcnSEE9qsjpVExZIhJf+smffC5LaBTHX/p3nMrHHsNLnC/TNlUOF/0tVNTi6F6C7KliZFDyoknF5REDiSRw//VxM14ji4SVdkgPvGFbH57VUhU1I/0MQhPYdVLY6Hs9iG0CacHvvzBUyZU3oBf9up24/cVucBZbTSVgF+krlAVcs+LS4DEIB2DR926mQm3yjn8KLnouNcoUpPDK2ZtnNC71uBRSCfG6HxFVyPj47jMNhY8/5gkflYtrNNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNBtWon5YDjOvxXNKXy/RAS4vSVgHhF6EIHtB2FTAXY=;
 b=12c/VMCntvBApcsgia2h3aJfxoeiLFvF9lLMXpcLeRm+VKe/dCA/QIhzbJ5xcpKtuu8903De9kGeYcdl9rNZnzdRCuNgRi+Yx9x+IxKAVCNvmlVlkN+y5EJsFncYtDO6h5/LR76k0eDvFo4es+P3KlPhT2MH135kLMSX2dOltP0=
Received: from SJ2PR07CA0013.namprd07.prod.outlook.com (2603:10b6:a03:505::15)
 by BY5PR12MB4291.namprd12.prod.outlook.com (2603:10b6:a03:20c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Wed, 14 Jan
 2026 14:08:44 +0000
Received: from CO1PEPF000042A8.namprd03.prod.outlook.com
 (2603:10b6:a03:505:cafe::45) by SJ2PR07CA0013.outlook.office365.com
 (2603:10b6:a03:505::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.6 via Frontend Transport; Wed,
 14 Jan 2026 14:08:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CO1PEPF000042A8.mail.protection.outlook.com (10.167.243.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Wed, 14 Jan 2026 14:08:42 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Wed, 14 Jan
 2026 08:03:41 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 14 Jan
 2026 08:03:40 -0600
Received: from [172.31.177.37] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 14 Jan 2026 06:03:37 -0800
Message-ID: <2669381c-ddbf-4cb2-a770-8308cd5ff353@amd.com>
Date: Wed, 14 Jan 2026 19:33:31 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 7/8] KVM: SVM: Add Page modification logging support
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
References: <20260105063622.894410-1-nikunj@amd.com>
 <20260105063622.894410-8-nikunj@amd.com>
 <3d89f9d545d5d8b4558b591201cae19ad4cfb285.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <3d89f9d545d5d8b4558b591201cae19ad4cfb285.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Received-SPF: None (SATLEXMB04.amd.com: nikunj@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A8:EE_|BY5PR12MB4291:EE_
X-MS-Office365-Filtering-Correlation-Id: dbaf4855-22e4-44cc-8755-08de53766c93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mnl0VEpPbmRrR3huNjdGcUFhVGpOL21OZmE3VUpXdWR0dDRkOUxja1JFNU1n?=
 =?utf-8?B?SHdUSzBHb0N2YVZCeWhKWGdSejdQNWxXbVVVNVJTQkF0UmV3Yk1Ob2oxd3RH?=
 =?utf-8?B?cHJRTVo5SnFiSjNHcFN5TEF1Uzk5Yzk1ZWJoMU85WVdPaisyeWwzNVlsTk1H?=
 =?utf-8?B?dXA5dEVUSVFLamYvcTdFZ1BUYzNZUHVUdlIvYnNYcG9UY0lxcHdGRXhwb0hD?=
 =?utf-8?B?V0l0M29uSEhwTmMzT1ZMMElRdG9JUHVlZWlXNmdWK2l4K2RJT0kwV3RoZ0dX?=
 =?utf-8?B?Y1pqWVE1Q0FQcnhENlZUTWhEbjBrR1haQUdoZnFickpyUklvNWNHNTl1aVFM?=
 =?utf-8?B?S0ZDd0pqQWI2dEJBZmIzTkoySzZHNEM1dTU3WDUzZHVsYkprTTFJR3dyMlZD?=
 =?utf-8?B?elpqYVRHazF3TVdyTlByajVpVVVLTU9YenM5bFErdW94V0RSNUV2UTdySDQ3?=
 =?utf-8?B?cWE0U1NVdUNEVWJpbmluS3IvV1Z2d2VIajN5MnEzRGdob3hPMll6M1JaZGRM?=
 =?utf-8?B?YVVNWFpHZFA0MC9Dcy9IN05XOG5DNnV4d0xjbm9NeFRqaGVUZTZwUDlzZk9P?=
 =?utf-8?B?di82U0pkdDJXZVFuVWhyZnFETFdBVTBSdUhwdE9BU3FQeWlFaFgrT0VYUm5n?=
 =?utf-8?B?MnhVU1h3TDJoNzdpNDVDQ1JFT0dVY29OZUdUWVNwdTZMQnI3OENoY0IvLy9k?=
 =?utf-8?B?d0RyU09JSVZKdG5PL3pranhoanptSFdHcm9TNDRZd21Ka3JOb0lNN3ZIT21y?=
 =?utf-8?B?T04yMUxKWklvMkpYV2JxOGtzSXVXOXczbkR1TkZEVnY1OHBWaEl4VXBWeWNk?=
 =?utf-8?B?VVpvaUJuOXFuZjZ6Y25oc2pFd3h1aW44TjlpWWZXd0p0MVNKRWQ1YXg1dFJj?=
 =?utf-8?B?UjVWS3VOdk5jNUlDOGxBLy80Y2ZVdFJMRE1XMkRVUmZyVThEeHRaNTgzN25C?=
 =?utf-8?B?N0VndnBmRk9PNnlDSW5QdFc3YjgwNWZKOUwwNDRDV3daR3RUL2tlcEZUSGRp?=
 =?utf-8?B?VmZTSlFVcDRKOUFBT3dmVzFld3VtZlFnbjh2KzB1dFN5cDdEdHRjcVNqOFpw?=
 =?utf-8?B?TEdPYWNqRi9JbmRqSnNJVzJkMHJIeHRMalZpeXRsT0pyN2M4S3o2bjZwN2Jt?=
 =?utf-8?B?MEVTa1Q5YzhuUWw3SngySjk2THFGSDRHaGd1TU1QK3FSRStrdStWNFZNa2ZV?=
 =?utf-8?B?NU1hZzhZQW41cVlmM1ZkL2FlcG83L3pRYVVhOGo3QlE2OUYzME5ZOTIveGc1?=
 =?utf-8?B?OVQ1OHU5MHpjOURTNFI2WFZrYldxRE1mRlhqNnBjWWtzR3NHL0NrdzV0ckpL?=
 =?utf-8?B?cVorYWZNWEJpTzhnVWlNSUZPRjhnZmJ0RzVKdWFOZm5tald3ek1Id1BLMXZo?=
 =?utf-8?B?THAwbUJEMU9URWplNVo0QTBKN3B2K2tMOFh4YVB3MzE5SURWaUpGSW44TGZk?=
 =?utf-8?B?a0dyWlMwdGZPQXFLbjFNMHBCRktDN282VHRseFI4dnNGWk83YW8vdHRsb25O?=
 =?utf-8?B?UVAzLy9xQWI4ZXVwNEE4amdxaVE3VjBUOUFFTUlkUGpYdXNiNFFvUE9KbEs2?=
 =?utf-8?B?MEt3ZkFBaytHeEtTQ2JQMUJDcGlpSXJXRWZMUnBWN0tGTTAxbWV4clBXV2RZ?=
 =?utf-8?B?RTdsVzFiR2NLWDJyVmNYQlJTR0RxdTB5VzVzRExxcVZZMTJ3c1Nmc2tReXE2?=
 =?utf-8?B?M3dsSzhqc1FSc0h2SDhoTGczQ1QzelB2TjRkam9LbEw3QUsvaGJSODRmWW9H?=
 =?utf-8?B?UTB4N3A4eHkrVEtIUXZEcFRDaHQ1aVNIcDJjM292ZVVVaHVvVVdwSSs1OXda?=
 =?utf-8?B?ems2ek95blJEckNxNXhTR2JlMlZJYWhoSWI5bThUaTdMaGpnVGNaK1djY2Qy?=
 =?utf-8?B?a1QrcytrdVdGZVZTSWFiSU9zT3NhMEpDRWE3OGFsVWtGQWc0S0ZMZ0JSZk9W?=
 =?utf-8?B?ZkhKa3ZCRy9KOTllRHVoMDM1NzVsZEpvcXhIUVpGZ1p1TmlOZU9LN2FxVGVD?=
 =?utf-8?B?eWZ4R215ZnBhMW1RdFplSXl5NENYSzZBcXZuNHdRSmxKQ0RYdUZLYjZSQUpF?=
 =?utf-8?B?a0U1YW4rK0ZaK2t0SzhPUmZ4QlFTZEJHdWNwUlhEQ1hiSkN6ZjZFOEVPZVV1?=
 =?utf-8?B?bDNrNy83ejEyVnAzemlrVDEyWk5WYmhwZkJxVW05cUVUS2R6L3NZMkxBNE9p?=
 =?utf-8?B?YnBlQ05qZm5jMTlLZG9qZk5GbUxHWEZNNEdqNEV0c3dlUllJdzU3RUFVbmRm?=
 =?utf-8?B?TEViQUhoTk5Mc0Y1YStXbEhVN2xRPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 14:08:42.5225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbaf4855-22e4-44cc-8755-08de53766c93
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042A8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4291



On 1/12/2026 3:54 PM, Huang, Kai wrote:
> On Mon, 2026-01-05 at 06:36 +0000, Nikunj A Dadhania wrote:
>> Currently, dirty logging relies on write protecting guest memory and
>> marking dirty GFNs during subsequent write faults. This method works but
>> incurs overhead due to additional write faults for each dirty GFN.
>>
>> Implement support for the Page Modification Logging (PML) feature, a
>> hardware-assisted method for efficient dirty logging. PML automatically
>> logs dirty GPA[51:12] to a 4K buffer when the CPU sets NPT D-bits. Two new
>> VMCB fields are utilized: PML_ADDR and PML_INDEX. The PML_INDEX is
>> initialized to 511 (8 bytes per GPA entry), and the CPU decreases the
>> PML_INDEX after logging each GPA. When the PML buffer is full, a
>> VMEXIT(PML_FULL) with exit code 0x407 is generated.
>>
>> Disable PML for nested guests.
>>
>> PML is enabled by default when supported and can be disabled via the 'pml'
>> module parameter.
> 
> Nit:
> 
> If a new version is needed, use imperative mode:
> 
>   Add a new module parameter to enable/disable PML, and enable it by 
>   default when supported.

Ack

> 
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> 
> It's a bit weird for me to review, but I did anyway and it seems fine to
> me, so:

Thank you for taking the time to review the patches and for the detailed feedback
throughout this series. Your insights have been very helpful.

> 
> Acked-by: Kai Huang <kai.huang@intel.com>
> 
> One minor thing below ...
> 
> [...]
> 
>> @@ -748,12 +748,19 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>>  						V_NMI_BLOCKING_MASK);
>>  	}
>>  
>> -	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
>> +	/* Copied from vmcb01. msrpm_base/nested_ctl can be overwritten later. */
>>  	vmcb02->control.nested_ctl = vmcb01->control.nested_ctl;
>>  	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
>>  	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
>>  	vmcb_mark_dirty(vmcb02, VMCB_PERM_MAP);
>>  
>> +	/* Disable PML for nested guest as the A/D update is emulated by MMU */
> 
> This comment isn't accurate to me.  I think the key reason is, for L2 if
> PML enabled the recorded GPA will be L2's GPA, but not L1's.
> 
> Please update the comment if a new version is needed?

How about the below:

+	/*
+	 * Disable PML for nested guests. When L2 runs with PML enabled, the
+	 * CPU logs L2 GPAs rather than L1 GPAs, breaking dirty page tracking
+	 * for the L0 hypervisor.
+	 */

Regards
Nikunj

