Return-Path: <kvm+bounces-53468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79202B12368
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 19:59:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A548F7A4918
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 17:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CCB02F002E;
	Fri, 25 Jul 2025 17:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="d184GfqX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5372EFDBA;
	Fri, 25 Jul 2025 17:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753466323; cv=fail; b=PDJrT97pV+KCY2OIaD2labdRw/dJSeIlYBFjVb7dOLG/TU9j6kKK0PZSJrckZtl9gfZwJePTfHUyjeIW2d7XjKr4zrMTOoWuRJs4k72U2hCg1z55t0N6rpZx5xp0T/q1E6xq/e+lY+hZoFLnqoDI7x+3yCndSd6k7klrU2v7xp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753466323; c=relaxed/simple;
	bh=XIzv9P43+hzPZW4NhIsVFyPcUNLswRyYs/+7rK82RtM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=JOCdu2Ne/Vx2mZC0EKDRrIofhD0+1PMUool03Hii/n4Vo6tfYp4KKXlDa6KhES0AbDkX5/BjZQuITDUmyX/PspFgmMlCU4ao6akpkFRaZokMER41eWb6JyNt96acUvJmpAjw/ck78uxBIsKpZrPxQWNCALGaEHc1Mbgn72rXffI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=d184GfqX; arc=fail smtp.client-ip=40.107.220.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tAsXOVT1FUQtq5sEAmLplcmLY1gJdoGwT3nX+HGnoufPtLCouUuzp19dcPGLy9sjmIAvVnrvLV6Maib77wvGKRQkWAtK3nhlNVNcDuf3q7N/rb2a7jUOqy3kq8kgzKrxEndPqVXExdwF2VsBQ6i3zAivrpHJJqHtPonxakq8hti0gRRBBDsHlIggD328owDHqhuA5lhvtTQrE1/XH3sFxc/Gil1uP0oqq3iVuXRRcGXuCMYTdCxAKWuKkJQrsJrdygDT5/mz/PACNNU7iRXS6OYtzeOdzD0egEHNe+1JiEikt0G6Fr8uCaCIDLbK13XY5apjqFynkSTWnWj6w4l/9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0WT+lSoLpUTgVaO+iuxAdkXk6u4wL5miBbDG6REcIAg=;
 b=RH+15XSgZ4A8Z6Z7RyhPqe9jy+56HtIWPdJ0bXCe91h7JG63IVsXejtyTJv4jxsqde84JIi1vn20KGTCiAdarWFUvKyEi75LYc02BmranG9HD3QRGWEjWW/Z0XuBtw/k8T5bYq2/YkaBSooS8JMIKweu+oNOvRlhfi93JCmiye1vFioWzGD7XaZmyAUZ94PLiEe/imNgdx19WCLvriMFS4A7IbCCfMBpRn+aLrgFVaSnHB/+ebn0kPlG3gj9E4oytqbDP5TMdJuvwLj07Snm2ERa3AJZiruwtYRRHJp/rs+pJMZWvhSeVEd3dQ7ljW7uHyH9Ru6bvGZaUrthqGyd8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0WT+lSoLpUTgVaO+iuxAdkXk6u4wL5miBbDG6REcIAg=;
 b=d184GfqXiabJVLmFtjflWx3qXzFNwUS6b/jRLABffzPyKVlErsiDZ9GZO/z9So9cXNAJBgKYhblr0VJIz+0yFOwYGpLcssN78R32TUog48E0UIXsQ77TpAcHG/ymC5gSJ2ALjtsJ0TmmdBr29sL/Hea4O7MIJ5d5X+Pw/JC8sF8=
Received: from SJ0PR13CA0114.namprd13.prod.outlook.com (2603:10b6:a03:2c5::29)
 by CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Fri, 25 Jul
 2025 17:58:32 +0000
Received: from SJ1PEPF000026C4.namprd04.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::4f) by SJ0PR13CA0114.outlook.office365.com
 (2603:10b6:a03:2c5::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.9 via Frontend Transport; Fri,
 25 Jul 2025 17:58:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000026C4.mail.protection.outlook.com (10.167.244.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Fri, 25 Jul 2025 17:58:32 +0000
Received: from [10.236.30.53] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 25 Jul
 2025 12:58:30 -0500
Message-ID: <9132edc0-1bc2-440a-ac90-64ed13d3c30c@amd.com>
Date: Fri, 25 Jul 2025 12:58:24 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: Ashish Kalra <Ashish.Kalra@amd.com>, <corbet@lwn.net>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<akpm@linux-foundation.org>, <rostedt@goodmis.org>, <paulmck@kernel.org>
CC: <nikunj@amd.com>, <Neeraj.Upadhyay@amd.com>, <aik@amd.com>,
	<ardb@kernel.org>, <michael.roth@amd.com>, <arnd@arndb.de>,
	<linux-doc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
References: <cover.1752869333.git.ashish.kalra@amd.com>
 <44866a07107f2b43d99ab640680eec8a08e66ee1.1752869333.git.ashish.kalra@amd.com>
From: Kim Phillips <kim.phillips@amd.com>
Content-Language: en-US
In-Reply-To: <44866a07107f2b43d99ab640680eec8a08e66ee1.1752869333.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C4:EE_|CH3PR12MB8728:EE_
X-MS-Office365-Filtering-Correlation-Id: 0863ef5d-0469-4ffe-1af8-08ddcba4de7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UEk0OE1MSlRuUU1zUWJxaE92N1ZJV0NNZkFQWnZ4Tnd5OTh2UmhGZEgzdWlT?=
 =?utf-8?B?SFYrWDdZSTJjUnMvWHRqRDVnVTRvRzlJU0pmZEhDK3FicHkxRHc2UWhVbCtz?=
 =?utf-8?B?alppcmFpaWVEYVkyQmVaS2RBVEdZdEJ6QW5HdFN5M2xGaXNqalJZWmM2UnZ3?=
 =?utf-8?B?clFCUWR5TlA4b0Z6bWZyK2lyK0RBbHlvTzBkdjVibXI3WEVvekxDVFFTd01J?=
 =?utf-8?B?SU9tdTdtRTFHd0JISVhCME85NkdxdFdEblFuK0ZYY2FEaFloNXMyeEF1KzVk?=
 =?utf-8?B?NGJjMnFiYjNyYUJ5VjR6bDdjTjJqOTdaZE5sU0ZNOVFVRFA1Q0Z4UHNNQUUr?=
 =?utf-8?B?aERReUwzNHpvQ3lrd3A1ajZLWlRaaUh3UHlvaHBQVVFya3l5aG5obDA5MUZl?=
 =?utf-8?B?TnhRRVY0MGpZaXBoenNFYTZLcnA3amxaRlIxY0hHdXJpdTU3a21OdWZqb2Jr?=
 =?utf-8?B?RTdaNU1sNEZTRUw3QS9ENzJrRlY2cElXMUc0RC9UTmpwRmxrODNpc0g1MllG?=
 =?utf-8?B?SXBRU3A1MjVIL0tMSmpLL1NtY1Vpd2ttL2ZyTjFkQ0ZhOU5SdVlKWHQzNTBq?=
 =?utf-8?B?VlVWczVnZnp4eXZPWmxWMzFOQnRJd1BhdmxsUEpMdTdleFRrWGtIajQwbG5t?=
 =?utf-8?B?N1lSTGpkUmVLQThWd0VRTWJ4djB4NmZIN01za2lzWDNlakJkbjRkR09HWHZB?=
 =?utf-8?B?YnpyTm5kNXpkN0EzTXpzSW5iL3kvR3ZQK2IxN052U09veUZ5RzcrNjhpdmw0?=
 =?utf-8?B?WmVOZTZzOWhIb1YraHYwVHRFRCt3cEVtNzNuVDRxQjlSRzVJWlN6WW9PUHd3?=
 =?utf-8?B?Qlk4VzE2aVpPZ0ZlWGhGcWE3SHlQNkhKdkx6bmI0QmZTdUZITUtyWGpuODZj?=
 =?utf-8?B?aEtUYytPZ0l4U3Bmb0ExckRucy9TdDUzMWNuR1JsbWcvRjdiM1FXUjJZZUNH?=
 =?utf-8?B?dzJYYmVVVzZXU3ZyckNLTHNVcU5kVEZGVFV1bDZGbnBKTFBpQVgxUXUzeEdo?=
 =?utf-8?B?V2JrdUdPd0NKMFF0SE1iVUJHeC8wZXpwOU12bWVGbjlUUzN3WS9EMkVLeEFs?=
 =?utf-8?B?NE5ESVIyYVlpbElRT2hKbmhTYzQ4RXlaWWNXRE1SUmlzd3BlV0xLeUFCN2k4?=
 =?utf-8?B?czZYUFF3eUppR1NnSWZRZi9MWkNRdDVnOXhXdlhYSXROeWxvbmQ4TTEyMlZU?=
 =?utf-8?B?UzE5NmkxVmlrSTZKQlJoalR4Mm0rR1J5aUs2LzBVMWpyL21IeTRjUVhjR3kx?=
 =?utf-8?B?WGtIdGY4blMwbDhTMzZZVS9oZ1lUZnVhMWlyMmtxZU0zMHpJZ0JFYXlHdXlK?=
 =?utf-8?B?QWtMbDg0MDJVUkJ5b055ODNXbXJIUi9UdEFpTHc0WTFGaXhCb2huQ3c2eVZ0?=
 =?utf-8?B?aTBnbm5GdW4zalFvZjlOTW9JNERMVUgvL3pMSEl6czVwNmFyR1gzSit6U1Mz?=
 =?utf-8?B?RTBTSlFxemNjRDFDblh4WjhQUXR5Vm43ZTAvNHNQTWVhSllDNlVkaW9IOUIz?=
 =?utf-8?B?ZzMrVTR0aFQvNGR1MnhndGM1Z1RweE9md3RHNjhEUTVENy9sTy9tclhFb1R5?=
 =?utf-8?B?U3RHQ1c0eXpFcVlFSXRoaVUxNjQ4aTVnSmhvTkNlVnVZWUZmaUtsUE51Wnpa?=
 =?utf-8?B?RStqbGdVT25rMm10Y2R2U0xDaHV0ZkRtdytSOHpBYzBuTUIrWnJ6am1Bd1U0?=
 =?utf-8?B?UjZ1bmxIS2hkZ1dvWWVHQUxtTkdGN2VZMzRRVHBDcjR2dUxWaFhZVHpkUXhY?=
 =?utf-8?B?WGdJY0dNK1BRUDQ1WFgyZUVINUtNUWRKT244L3pzOXlLL1ZXRy9mTnlDWDJu?=
 =?utf-8?B?dEl0VFZxRDdVc05hcklxMktZcU1RZ0RFQ3lVcGluK285dWVrRllpSEUvd1Bk?=
 =?utf-8?B?cXVLeTYxUzZtZGhDSnllSmdYN0NiMnZlcXMvamM1WnQrQ08xUXhNWCtydWlB?=
 =?utf-8?B?QXhlNEVYdjlkTEhremI4dFRsMzgxVW9nUDdzUDdWZHZUZFlyaTluZ3JjRUZX?=
 =?utf-8?B?Q0hJUDB5VTNqTVhmcGZkV0Q2ZFR5TS82UlE5Z1BOYkJWNThsVFhYb0VCcWkz?=
 =?utf-8?B?TXVjMVhReWJndFo5WW5vdXFXTlZmQVNuRVh5UT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 17:58:32.3029
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0863ef5d-0469-4ffe-1af8-08ddcba4de7f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8728

Hi Ashish,

For patches 1 through 6 in this series:

Reviewed-by: Kim Phillips <kim.phillips@amd.com>

For this 7/7 patch, consider making the simplification changes I've supplied
in the diff at the bottom of this email: it cuts the number of lines for
check_and_enable_sev_snp_ciphertext_hiding() in half.

Thanks,

Kim

On 7/21/25 9:14 AM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Ciphertext hiding prevents host accesses from reading the ciphertext of
> SNP guest private memory. Instead of reading ciphertext, the host reads
> will see constant default values (0xff).
>
> The SEV ASID space is split into SEV and SEV-ES/SEV-SNP ASID ranges.
> Enabling ciphertext hiding further splits the SEV-ES/SEV-SNP ASID space
> into separate ASID ranges for SEV-ES and SEV-SNP guests.
>
> Add new module parameter to the KVM module to enable ciphertext hiding
> support and a user configurable system-wide maximum SNP ASID value. If
> the module parameter value is "max" then the complete SEV-ES/SEV-SNP
> ASID space is allocated to SEV-SNP guests.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   .../admin-guide/kernel-parameters.txt         | 18 ++++++
>   arch/x86/kvm/svm/sev.c                        | 60 ++++++++++++++++++-
>   2 files changed, 77 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index eb2fab9bd0dc..379350d7ae19 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2942,6 +2942,24 @@
>   			(enabled). Disable by KVM if hardware lacks support
>   			for NPT.
>   
> +	kvm-amd.ciphertext_hiding_asids=
> +			[KVM,AMD] Ciphertext hiding prevents host accesses from reading
> +			the ciphertext of SNP guest private memory. Instead of reading
> +			ciphertext, the host will see constant default values (0xff).
> +			The SEV ASID space is split into SEV and joint SEV-ES and SEV-SNP
> +			ASID space. Ciphertext hiding further partitions the joint
> +			SEV-ES/SEV-SNP ASID space into separate SEV-ES and SEV-SNP ASID
> +			ranges with the SEV-SNP ASID range starting at 1. For SEV-ES/
> +			SEV-SNP guests the maximum ASID available is MIN_SEV_ASID - 1
> +			where MIN_SEV_ASID value is discovered by CPUID Fn8000_001F[EDX].
> +
> +			Format: { <unsigned int> | "max" }
> +			A non-zero value enables SEV-SNP ciphertext hiding feature and sets
> +			the ASID range available for SEV-SNP guests.
> +			A Value of "max" assigns all ASIDs available in the joint SEV-ES
> +			and SEV-SNP ASID range to SNP guests, effectively disabling
> +			SEV-ES.
> +
>   	kvm-arm.mode=
>   			[KVM,ARM,EARLY] Select one of KVM/arm64's modes of
>   			operation.
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b5f4e69ff579..7ac0f0f25e68 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -59,6 +59,11 @@ static bool sev_es_debug_swap_enabled = true;
>   module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
>   static u64 sev_supported_vmsa_features;
>   
> +static char ciphertext_hiding_asids[16];
> +module_param_string(ciphertext_hiding_asids, ciphertext_hiding_asids,
> +		    sizeof(ciphertext_hiding_asids), 0444);
> +MODULE_PARM_DESC(ciphertext_hiding_asids, "  Enable ciphertext hiding for SEV-SNP guests and specify the number of ASIDs to use ('max' to utilize all available SEV-SNP ASIDs");
> +
>   #define AP_RESET_HOLD_NONE		0
>   #define AP_RESET_HOLD_NAE_EVENT		1
>   #define AP_RESET_HOLD_MSR_PROTO		2
> @@ -201,6 +206,9 @@ static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
>   	/*
>   	 * The min ASID can end up larger than the max if basic SEV support is
>   	 * effectively disabled by disallowing use of ASIDs for SEV guests.
> +	 * Similarly for SEV-ES guests the min ASID can end up larger than the
> +	 * max when ciphertext hiding is enabled, effectively disabling SEV-ES
> +	 * support.
>   	 */
>   	if (min_asid > max_asid)
>   		return -ENOTTY;
> @@ -2269,6 +2277,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
>   				ret = -EFAULT;
>   				goto err;
>   			}
> +
>   			kunmap_local(vaddr);
>   		}
>   
> @@ -2959,6 +2968,46 @@ static bool is_sev_snp_initialized(void)
>   	return initialized;
>   }
>   
> +static bool check_and_enable_sev_snp_ciphertext_hiding(void)
> +{
> +	unsigned int ciphertext_hiding_asid_nr = 0;
> +
> +	if (!ciphertext_hiding_asids[0])
> +		return false;
> +
> +	if (!sev_is_snp_ciphertext_hiding_supported()) {
> +		pr_warn("Module parameter ciphertext_hiding_asids specified but ciphertext hiding not supported\n");
> +		return false;
> +	}
> +
> +	if (isdigit(ciphertext_hiding_asids[0])) {
> +		if (kstrtoint(ciphertext_hiding_asids, 10, &ciphertext_hiding_asid_nr))
> +			goto invalid_parameter;
> +
> +		/* Do sanity check on user-defined ciphertext_hiding_asids */
> +		if (ciphertext_hiding_asid_nr >= min_sev_asid) {
> +			pr_warn("Module parameter ciphertext_hiding_asids (%u) exceeds or equals minimum SEV ASID (%u)\n",
> +				ciphertext_hiding_asid_nr, min_sev_asid);
> +			return false;
> +		}
> +	} else if (!strcmp(ciphertext_hiding_asids, "max")) {
> +		ciphertext_hiding_asid_nr = min_sev_asid - 1;
> +	}
> +
> +	if (ciphertext_hiding_asid_nr) {
> +		max_snp_asid = ciphertext_hiding_asid_nr;
> +		min_sev_es_asid = max_snp_asid + 1;
> +		pr_info("SEV-SNP ciphertext hiding enabled\n");
> +
> +		return true;
> +	}
> +
> +invalid_parameter:
> +	pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
> +		ciphertext_hiding_asids);
> +	return false;
> +}
> +
>   void __init sev_hardware_setup(void)
>   {
>   	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
> @@ -3068,6 +3117,13 @@ void __init sev_hardware_setup(void)
>   out:
>   	if (sev_enabled) {
>   		init_args.probe = true;
> +		/*
> +		 * The ciphertext hiding feature partitions the joint SEV-ES/SEV-SNP
> +		 * ASID range into separate SEV-ES and SEV-SNP ASID ranges with
> +		 * the SEV-SNP ASID starting at 1.
> +		 */
> +		if (check_and_enable_sev_snp_ciphertext_hiding())
> +			init_args.max_snp_asid = max_snp_asid;
>   		if (sev_platform_init(&init_args))
>   			sev_supported = sev_es_supported = sev_snp_supported = false;
>   		else if (sev_snp_supported)
> @@ -3082,7 +3138,9 @@ void __init sev_hardware_setup(void)
>   			min_sev_asid, max_sev_asid);
>   	if (boot_cpu_has(X86_FEATURE_SEV_ES))
>   		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
> -			str_enabled_disabled(sev_es_supported),
> +			sev_es_supported ? min_sev_es_asid <= max_sev_es_asid ? "enabled" :
> +										"unusable" :
> +										"disabled",
>   			min_sev_es_asid, max_sev_es_asid);
>   	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
>   		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",


diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7ac0f0f25e68..bd0947360e18 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -59,7 +59,7 @@ static bool sev_es_debug_swap_enabled = true;
  module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
  static u64 sev_supported_vmsa_features;

-static char ciphertext_hiding_asids[16];
+static char ciphertext_hiding_asids[10];
  module_param_string(ciphertext_hiding_asids, ciphertext_hiding_asids,
              sizeof(ciphertext_hiding_asids), 0444);
  MODULE_PARM_DESC(ciphertext_hiding_asids, "  Enable ciphertext hiding 
for SEV-SNP guests and specify the number of ASIDs to use ('max' to 
utilize all available SEV-SNP ASIDs");
@@ -2970,42 +2970,22 @@ static bool is_sev_snp_initialized(void)

  static bool check_and_enable_sev_snp_ciphertext_hiding(void)
  {
-    unsigned int ciphertext_hiding_asid_nr = 0;
-
-    if (!ciphertext_hiding_asids[0])
-        return false;
-
-    if (!sev_is_snp_ciphertext_hiding_supported()) {
-        pr_warn("Module parameter ciphertext_hiding_asids specified but 
ciphertext hiding not supported\n");
-        return false;
-    }
-
-    if (isdigit(ciphertext_hiding_asids[0])) {
-        if (kstrtoint(ciphertext_hiding_asids, 10, 
&ciphertext_hiding_asid_nr))
-            goto invalid_parameter;
-
-        /* Do sanity check on user-defined ciphertext_hiding_asids */
-        if (ciphertext_hiding_asid_nr >= min_sev_asid) {
-            pr_warn("Module parameter ciphertext_hiding_asids (%u) 
exceeds or equals minimum SEV ASID (%u)\n",
-                ciphertext_hiding_asid_nr, min_sev_asid);
-            return false;
-        }
-    } else if (!strcmp(ciphertext_hiding_asids, "max")) {
-        ciphertext_hiding_asid_nr = min_sev_asid - 1;
+    if (!strcmp(ciphertext_hiding_asids, "max")) {
+        max_snp_asid = min_sev_asid - 1;
+        return true;
      }

-    if (ciphertext_hiding_asid_nr) {
-        max_snp_asid = ciphertext_hiding_asid_nr;
-        min_sev_es_asid = max_snp_asid + 1;
-        pr_info("SEV-SNP ciphertext hiding enabled\n");
-
-        return true;
+    /* Do sanity check on user-defined ciphertext_hiding_asids */
+    if (kstrtoint(ciphertext_hiding_asids, 
sizeof(ciphertext_hiding_asids), &max_snp_asid) ||
+        max_snp_asid >= min_sev_asid ||
+        !sev_is_snp_ciphertext_hiding_supported()) {
+        pr_warn("ciphertext_hiding not supported, or invalid 
ciphertext_hiding_asids \"%s\", or !(0 < %u < minimum SEV ASID %u)\n",
+            ciphertext_hiding_asids, max_snp_asid, min_sev_asid);
+        max_snp_asid = min_sev_asid - 1;
+        return false;
      }

-invalid_parameter:
-    pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
-        ciphertext_hiding_asids);
-    return false;
+    return true;
  }

  void __init sev_hardware_setup(void)
@@ -3122,8 +3102,11 @@ void __init sev_hardware_setup(void)
           * ASID range into separate SEV-ES and SEV-SNP ASID ranges with
           * the SEV-SNP ASID starting at 1.
           */
-        if (check_and_enable_sev_snp_ciphertext_hiding())
+        if (check_and_enable_sev_snp_ciphertext_hiding()) {
+            pr_info("SEV-SNP ciphertext hiding enabled\n");
              init_args.max_snp_asid = max_snp_asid;
+            min_sev_es_asid = max_snp_asid + 1;
+        }
          if (sev_platform_init(&init_args))
              sev_supported = sev_es_supported = sev_snp_supported = false;
          else if (sev_snp_supported)


