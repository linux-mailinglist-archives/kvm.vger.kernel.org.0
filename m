Return-Path: <kvm+bounces-55093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DAB8B2D333
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 06:53:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1D5A7264B9
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 04:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B9EC258EF1;
	Wed, 20 Aug 2025 04:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Jri9T55l"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F8B21507C;
	Wed, 20 Aug 2025 04:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755665599; cv=fail; b=b71oIeRpiUiocIPCW+xpnvtV6WAid9m1hI4u8MsjGR5ZiYQxAdl/Re0+eAX98OCEb9xFtylLkFjTujxlW+7NbFx6aAkWyGQdBSt9lERvNpBtEf8ZnLKC/H9CBWMWpSfzv8RnMqtjJDO3U5vRCQo7lJEOToLWXLf3eyJHUjSkYyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755665599; c=relaxed/simple;
	bh=0U+7GCioX0sxGEY8rIRz0FJYnjwU0Rs/mFbu4oIfIbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=obRV4U6VZE9yGEHdm/8ibt5w0mn7Yv0rDGwSoNVbl0CM1mduzFQc6AAdRZeqZi88CN6rbU0fgU/tD6XhmdyESUpXSO1tAJ62tF1vcdL9TObElUfAKTUdn9Dv3DWtXhSqqd6IsMTxr6WPc5/z7FSCxwdDpiv0J2VWUXQlg+fpiJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Jri9T55l; arc=fail smtp.client-ip=40.107.94.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OfNlwGtPhwzCEApxaCOUO93oCS4rWZ9MvhxcaLFiQGjO3opAUQBf8lSSzJ9kasmewKVqoeUcMaB6g9p0VqQux4i4JOAWoDrfuEuiVdQeuQKbQWhH82/syjUq632y2aotczxDQ1TaMpst5P67hwdP3M4EINjElO4RSG/jcs11Bm1Ej/HcVqFg+P3wWuht2NNLmKU2NWT4xv+/RFrGk4uQCpriRNLDwEsA95mE3AEb46QidqHvUrEY0hGt32aT1Fqj26jvNV0t8K7jV0UDYbfVlg0akjust2FhA8NrrviYiWKgIA89caGxCLXjglvJODUIiacHRLSMEuMK2gpbRM66aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hHPmgNp63QEyJ5mU9QyvTl9ZNQrnwOU+sYVAUXeVuOw=;
 b=aykT2ieSXqMLP9eC5+U5vrTGYdDboPJruVfWaJDwpIkUSpoG8ssUBiRX3QvmYhpARUNW1cuJx9qcJ8RvM4GHUUFPs97jR2IaQOSi/5I/ltnQkH1R67eb/nqjjhBY2wcgQoA7bA7NwTcHa7nX1ikay2bCalwJtmdojRtt3qMxIjXempXeeoqarzC5fJKE7tAz5p37mjGf38drR48vVnBHz/WlcIiSk2ck2MnWgNJY0RetW5AVFSbr7kjWe+DOK+iypfrRs4pjMKpIWVmr2FXu58VfPSXeiGVan2uGp4oky8TkZq3Hr9/C+6hQJU7HlnlRyBUgpxfcbED9MDj8GfviPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hHPmgNp63QEyJ5mU9QyvTl9ZNQrnwOU+sYVAUXeVuOw=;
 b=Jri9T55lrqVkuh4meEDJp44hMYlIahDp2I8FcohMFDdYWT3MYbh6SodQpErMJ5dpsnm+FYxuRZ05/jusHzROYMx7cH94CxA7GoI4Qa93Hei6ywIoK8mA8YcifyN62Yb4j46cvGcTtxeeG9HheYYgt3xkpyy4YdBpHQZsEem+az0=
Received: from SA0PR11CA0108.namprd11.prod.outlook.com (2603:10b6:806:d1::23)
 by DM4PR12MB5747.namprd12.prod.outlook.com (2603:10b6:8:5e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Wed, 20 Aug
 2025 04:53:15 +0000
Received: from SA2PEPF00003AEB.namprd02.prod.outlook.com
 (2603:10b6:806:d1:cafe::19) by SA0PR11CA0108.outlook.office365.com
 (2603:10b6:806:d1::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.25 via Frontend Transport; Wed,
 20 Aug 2025 04:53:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003AEB.mail.protection.outlook.com (10.167.248.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Wed, 20 Aug 2025 04:53:14 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 19 Aug
 2025 23:53:14 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Tue, 19 Aug
 2025 21:53:13 -0700
Received: from [10.252.207.152] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Tue, 19 Aug 2025 23:53:10 -0500
Message-ID: <c3e638e9-631f-47af-b0d2-06cea949ec1e@amd.com>
Date: Wed, 20 Aug 2025 10:23:09 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 8/8] KVM: SVM: Enable Secure TSC for SNP guests
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Thomas Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Borislav
 Petkov" <bp@alien8.de>, Vaishali Thakkar <vaishali.thakkar@suse.com>, "Kai
 Huang" <kai.huang@intel.com>, <David.Kaplan@amd.com>
References: <20250819234833.3080255-1-seanjc@google.com>
 <20250819234833.3080255-9-seanjc@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250819234833.3080255-9-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AEB:EE_|DM4PR12MB5747:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e1cb5b4-5868-40c2-2426-08dddfa578d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0M5bVJzKzJoclpKMDF3V3pmZStrUXNJYWhlb2VmM0FoNnJPY2VxVlFQZzhI?=
 =?utf-8?B?TjNlVUIwSTBFOUFoWWVPaER4YkdYVmNnbW9WMGpDMG9maVhLUm14UVY1WWhU?=
 =?utf-8?B?N2N5RnpsYkFCY3g5Ymx6eExEcUV1bjE0N3I4K3NtRkN5U3E0cHE2RC95N2Fv?=
 =?utf-8?B?Ti9GNmN0UVFrdmJ2UUtwK1ZKeGRaMnVWY0lieTEzdTF0dGM3dEs4eVNOU3NS?=
 =?utf-8?B?OVVsT1hhUTFtS3BON1B1aHo3ZmFnMjhaSEV0QTU0T0hMcUI4aWRKSGhoUG4v?=
 =?utf-8?B?UXU4TVpNSjVBSWtzd1c5bzFwcXRJcWRXamF4M0ZvTy91RlMwc0JiM1lXSEFa?=
 =?utf-8?B?Nk5rbmNoc0Y0Y1BOdXU0UGc5MUN6RVROc2hacW5NRnhSK245cWlYeXFaWlhp?=
 =?utf-8?B?VW9YN2xBbEpUYXpmekVrbjFkMzcvMmNGTFRJalNRVnZMa1kyWXFLNHdMWnlJ?=
 =?utf-8?B?K2QyWDhYSEhycWhzSmhIZHMrS3lJQUZwaklDb0pLMjhSOTdjbUpYMzJSOU5F?=
 =?utf-8?B?V0Jvc1BqMSthcjNUdzhaM2UybTh0UUtwV2NjSElFaWp6T0ppTEJNZ001MFA1?=
 =?utf-8?B?RktQWlErdFhLOVRNT0NqcFBYc1lCVStHUmFsSkFZSWR6NEMyZ1BZcDVCODdj?=
 =?utf-8?B?NDdxSjc1WnkyV01lT09wYTJYZnlBdTBER2FKaHlmVkhBS0lHQjY1UGo0d3pK?=
 =?utf-8?B?eVBwSGsvK3puNUQwbnZySjBtMXNWM3RNSlR1Tmdic24rSCtaVHRsNXlsaVp6?=
 =?utf-8?B?anAvSlFVanRIa3NXNElhdGhUMyswQUZ0UEl1SHdGYWQ2WVlVa0Z6NFVpdk93?=
 =?utf-8?B?YVhSQWZwazNXMXRNUzRZVVNzSnhmWTNTdkdUWWQvbDVQMGNUWGljdUtINm5y?=
 =?utf-8?B?V2MyeWRQc2NLNTNkOGswdWhtUlF2RUZ4UVFlM00zbE44Z2V2UldkdkVreTJt?=
 =?utf-8?B?UFk5U2lrYzNwdk1OUTRXVVNUT1dHYmNwb1FBdCtwUVFYNnVrdnY0NG52TzU2?=
 =?utf-8?B?VWM3bnNjM3FLMmNGZTV3ZHIzdmJwMVcwWnc4TVVjRkJaQjJYWUhEZGJTS29J?=
 =?utf-8?B?TGxDdVVOOWlYTlhpdzN1ZlNLMEszcHNwNkhPUHhaZGtDTytxZlNaeXpERlZ6?=
 =?utf-8?B?elFocVphQlZiOHF4ZEsrNmdqVjlnRXZQZExrTm1uR2ZWR1VudExXUUp2TjQw?=
 =?utf-8?B?b1VVc3FobGRDZSs4UDlKOVpVMHdEblFqSTdtTnBzQkcxSmVVZEVSUzBHV25M?=
 =?utf-8?B?U1hUSWdSdERxQUhhMFhrS2xCYXJMSTlpNWpMK0NOVzI4RjZWeERTTWtkdDFx?=
 =?utf-8?B?RGtSNzhDYnVuakhMNXZWUG0yRTZSTVhYNk1xUDVMdUZKNlEzbmY2NzFjZ3Fo?=
 =?utf-8?B?SDlUNUdOMkRwaWpBYzk3MGplQWpxdjN4SFFrRGdNZjhiMDlzTk5FUEZod3pX?=
 =?utf-8?B?UnRjcHJ6bmQ5YXhqaWJKb1RQMHM0R1R3MEVUY3FnYzRUdXZnOEhvdUF0bFda?=
 =?utf-8?B?cHVpazlsOW9XVDRWYUpYZlZVc2hDRnJ5OWNualIxdk5iSFBZZCsvenpQUXY0?=
 =?utf-8?B?RHBPdS9mTUFSd1p5NzhPZkVYck1MSzJvWUtrUS9ieUNFWWhzc2FQTjlHZTl3?=
 =?utf-8?B?SFZOZlFWNGlxOENBR3BkYUpMd3hnMGo5NUN4Z2xIb3k1NFo5VGU4SGdLTW40?=
 =?utf-8?B?dUZKaWhha0RTTHNsWFM2eDd4aDZBa0x4VWppdUdma2xheDlRa0kzNmkveGR2?=
 =?utf-8?B?TnBNSHNIdmpDQkg0YWtvYTBLdWJlNXJSVFdSeHZQTEhmZVpIZHlMUm5jVVBX?=
 =?utf-8?B?NXBFWVo2REhkUUJ4SktSL1M1dmdoUmhaUHhsUW41RHQ5ZEdnUm83eFluYnJ6?=
 =?utf-8?B?aE5UbnREckRhNUxRMkloRnJoVThOdWdHRmdRd2lUbGxOc0t0eW5LaTJzdWNi?=
 =?utf-8?B?TlRoZ1FHYlhXMmRObm85eWQ3Z0NTcGh3MVpocklrSjZBUFQwZ2M3MldqYWxG?=
 =?utf-8?B?K2pjYnVlenhVaWdlbHJUMnJ1NVlvczk2NWJ4eWNsczNCK09kZ1RoZ0RpekZk?=
 =?utf-8?Q?YKtsZo?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 04:53:14.5330
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e1cb5b4-5868-40c2-2426-08dddfa578d0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AEB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5747



On 8/20/2025 5:18 AM, Sean Christopherson wrote:
> From: Nikunj A Dadhania <nikunj@amd.com>
> 
> @@ -2195,6 +2206,12 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  	start.gctx_paddr = __psp_pa(sev->snp_context);
>  	start.policy = params.policy;
> +
> +	if (snp_is_secure_tsc_enabled(kvm)) {
> +		WARN_ON_ONCE(!kvm->arch.default_tsc_khz);

Any particular reason to drop the the following change: 

+		if (WARN_ON(!kvm->arch.default_tsc_khz)) {
+			rc = -EINVAL;
+			goto e_free_context;
+		}

As this is an unsupported configuration as per the SEV SNP Firmware ABI Specification: 

8.16 SNP_LAUNCH_START

DESIRED_TSC_FREQ
Hypervisor-desired mean TSC frequency in KHz of the guest. This field has no effect if guests
do not enable Secure TSC in the VMSA. The hypervisor should set this field to 0h if it 
*does not support Secure TSC* for this guest.

> +		start.desired_tsc_khz = kvm->arch.default_tsc_khz;
> +	}
> +
Regards,Nikunj

