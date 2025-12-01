Return-Path: <kvm+bounces-64992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B1FEC97198
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 12:47:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CAE784E187F
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 11:47:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B015E2E9ECC;
	Mon,  1 Dec 2025 11:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="F+7Bm5MH"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010026.outbound.protection.outlook.com [52.101.201.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E5A2E9721;
	Mon,  1 Dec 2025 11:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764589623; cv=fail; b=kE6zsQZYXygpblYGWrAvP47iCeFUEHuIv7BddhpnaMyjWqsbGYHfULpdo68Edd+ffSzuubWCJJNjh46PuCTyczGoA1QwkKWBsXaAI72B4CU4gMz3ja05lL5lXeDA9N7kkaXu9cCXpgWgbHZUXuRLmyEO83AuqEJSgB5dF7t67CU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764589623; c=relaxed/simple;
	bh=2zoF4en4H5WI3o4Aytsfhn5U7+mJqDMiZnxU3nI846I=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ihqwlI81LS+FSONb88+h15kP3+R1zkyCc0TNTAPNdWVm0ai2DgPxqR7gOWorer0F5+WSK2QD88IZXsWqHIpbDsTsoY/0gwBuBxMsSkIjlw1yIhjnSzw0DsqMuQiNrWnvL4sn3irdnF0qTFbrAfNBDbKybu1ROkallYECjMmSOgk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=F+7Bm5MH; arc=fail smtp.client-ip=52.101.201.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bofUoXDomGqnEM+IzGpYoobPZLPop3Tt2QwRSV3cHu+h33pHQmWMdP8BqBoKOwu9xNsxExlAth0Vfylnc8sBcoa8Xpl0WcC29M7PUE8CyZFgeqMU59baIYO6xknDuE2B8JKGECVlcrTR9XbvI6tnKsY9W2C984HueAaTgj+OikIL+ZpAkIeABL7/cTunfRQ8wkmJkITMTmG7qMSOuXOi5MiFyLIFyD2nxnWtP4R42l1F/ZLqvaNynHoasMbPsDlF2UgD9y1QETBe0trwFgzCcj2I0/ahgOLmjPQVgLfhBsT1fIOS9J6IuhOLktutjOubile+inqcy3hJrg1FUQtRSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8xXR6dOXkl/312w7P2VonzJWKPlg3G+Gkj9rg+BOTUk=;
 b=jtcLrQGZCk4YI80Kyi4o1G8476zvDHDEQ69J+Pdm7mYsjP1oLxcJKDsLrTZfGAQG9HMnKBx4RIs9VnLMiw1oj9a0/7WmnF4IqdqYgWZ/yXTz5PvaYISgozA6lTcD+N6p4RueQ+kI4+yFEM9Y/w9UaucII4UvmgLqY+8ArBoK8fTtxPkl0mr+7ou+bsxDqixIs6sOX7b/xIYvs7rSytT6f+5elwQTz+9BEZZ4tw/JyW8fh0+vJ9h8jJnp/IsrHgBjqlDxNElf1hGufEb26+GLDs7tyNHb8tvZ57PiZJJaHUwRr+up+a3oq+R26O0padVsg+jRA+A3Mfy+acoVlxudrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8xXR6dOXkl/312w7P2VonzJWKPlg3G+Gkj9rg+BOTUk=;
 b=F+7Bm5MH2pDtQjFkgKu8Kootxgdy+CgLzCHZPoKUnFiaD9l8U8ZEwg5VlniwqmSIV0QhBmvDQYhG6fD9weBlPA//F+d0U+qtIH2hTsbdLB1Nej5pZ2gR0oiEwXCscPXyUHMW6HKW0s/pmohdGI3kRNk8W8N4OSkSWgn1DBSmmOI=
Received: from BN9PR03CA0204.namprd03.prod.outlook.com (2603:10b6:408:f9::29)
 by IA0PR12MB8086.namprd12.prod.outlook.com (2603:10b6:208:403::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 11:46:57 +0000
Received: from BN2PEPF000044A0.namprd02.prod.outlook.com
 (2603:10b6:408:f9:cafe::3e) by BN9PR03CA0204.outlook.office365.com
 (2603:10b6:408:f9::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.17 via Frontend Transport; Mon,
 1 Dec 2025 11:46:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A0.mail.protection.outlook.com (10.167.243.151) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Mon, 1 Dec 2025 11:46:57 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 1 Dec
 2025 05:46:53 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: Thomas Courrege <thomas.courrege@vates.tech>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <corbet@lwn.net>, <ashish.kalra@amd.com>,
	<thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <thomas.courrege@vates.tech>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] KVM: SEV: Add hypervisor report request for SNP guests
In-Reply-To: <20251126191114.874779-1-thomas.courrege@vates.tech>
References: <20251126191114.874779-1-thomas.courrege@vates.tech>
Date: Mon, 1 Dec 2025 11:46:51 +0000
Message-ID: <85h5uabf10.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A0:EE_|IA0PR12MB8086:EE_
X-MS-Office365-Filtering-Correlation-Id: be30661b-fdf3-4298-e4fe-08de30cf5520
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?I6xeRdNStoCTwvVT5XO2ZrDLjUOiZ7Y9ezspjFELjegO8xKGVEXL3jrHFpEj?=
 =?us-ascii?Q?snW+qbmGFj00zyJk3dDp6lIP/egyu7ILpbfc18jhOBV0+WeqwTHFAQN9Ki6+?=
 =?us-ascii?Q?XIYKZAJIVpQonAaE+dNQxyFJOwZLgqWYjykN+PrYRSzXA17ACtt913yNKh3U?=
 =?us-ascii?Q?oWa9jvD0HVZW8PEgW2YmsN6JqwpqX3Ztkpb95tw8jcjNpgBqzADxZEa2mLOG?=
 =?us-ascii?Q?UvLx2RXMW0V9Fd5NKXXnLdlDJclDjOINLc3RJj09PjiTnV4J2TE8lbgKrqwy?=
 =?us-ascii?Q?jMkRhJidHA1OZns/RWrdWvxg0GmgTnk19XfioImabf3vw120s3VrDUkNnJVL?=
 =?us-ascii?Q?NuXNCv4LUMEI1tMoyw4nLVl6wy4OHzoOmyIMYlq11w7JX2+lVmrCPViKUiJ1?=
 =?us-ascii?Q?+dWIocAKldsWPF6rSWHVyDfVTQ/D1ou7Imjs0pgKvfawpsUB8MnkTeimNaFv?=
 =?us-ascii?Q?1dpAeURhxDvnAPGAJ3lh8te/+6u6h8qcdR0VCo1ku5K3bBtPNQBNOpCnH0hE?=
 =?us-ascii?Q?SWuMmUX/U2hdqDxphMjJLcV9fQZpWqbud/r4450UK+Gms1f2iVn8WoKzOLVW?=
 =?us-ascii?Q?YNJY3SE7Bknade+TbvCpnvjDOQUuACe5AflmXt3nVpSyk0aIC2o9d/KJ8Fdj?=
 =?us-ascii?Q?q+/YNmEfyWbJUTHqNgNw8gn94/4RP6heaDXIG6S+Kq/lQnjEm4t87YFwkeFA?=
 =?us-ascii?Q?Wajzb754OufcytZjfD8pKjluJsjxWCsxfCbm51sFPhA0/YBkhQk4SxUYch+f?=
 =?us-ascii?Q?+VtoZhYEcSlYzegHrrGw2Jd1kVdHL5smfU/4kiJQmCUPZDZFmUpGxtF9IdoN?=
 =?us-ascii?Q?doNZQIi+WCyEE4eozvGZbrLkmZs3t3QaQ/UkKVIx2PT0dFIfDae/akjDphMz?=
 =?us-ascii?Q?r13SEwIf6jfIyPvVu3mQvQT4R7J0Y4QLMZvo6COC3R7/41bjFWu/xS4nVzaR?=
 =?us-ascii?Q?tD4NGO1oubsSsmUNPcRpvhTqfI74HpMYIvWAP9YHKD3QrxW22YWQxgnMbIqw?=
 =?us-ascii?Q?/34iP87p0EJVONkKRmS8/ogL9X7gvyuwLSK83mKncc4dlORo5bp+Bxjcv55D?=
 =?us-ascii?Q?WMB3nCO85FMTwiCtdOR99n8B7r2yC4Gyf7SLYaSXjTUxUzVBn4s6jNacUAiv?=
 =?us-ascii?Q?hL5KeuUxichujmzsQhrzVKa9qnaICZFCOl4KQbLTFlhHFx2sSR6b/V6YG4l4?=
 =?us-ascii?Q?hMf5OksI0uVo9lNrnemViZinkw9AMIYl8mMazRwIrFYycBrylIAL/Hq2xBvo?=
 =?us-ascii?Q?J6aAI7j97mCfzkuAIxV4zmR/vluYOtumJcySYPOJ/p/XcKbFytt3DVpfAfUq?=
 =?us-ascii?Q?dUW13ichKSo1k4zylLMU7ocWtVwe8wUa+da73DszKPW34dUPslXzXE8nYIn5?=
 =?us-ascii?Q?NIIr9b4fFmwc3Y4/R7AsMA8IcvaEHkzi20uZmBOy7+dlzjV3vxzKjF4wenM4?=
 =?us-ascii?Q?IYky2P5Lp1Yc6omrWSK4zGcYBxhkkmi8wcVGeBSAZPROE8IeUetReQJmxevJ?=
 =?us-ascii?Q?eVmpQXIqqyW1fqcIALxDeBL1Yhk2P8LVqBbm8mR6tJHSB61UpMhOEuENtwfD?=
 =?us-ascii?Q?y6tLx2QuIiJeaQSgBcE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 11:46:57.7335
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be30661b-fdf3-4298-e4fe-08de30cf5520
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8086

"Thomas Courrege" <thomas.courrege@vates.tech> writes:

> Add support for retrieving the SEV-SNP attestation report via the
> SNP_HV_REPORT_REQ firmware command and expose it through a new KVM
> ioctl for SNP guests.
>
> Signed-off-by: Thomas Courrege <thomas.courrege@vates.tech>
> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    | 18 ++++++
>  arch/x86/include/uapi/asm/kvm.h               |  7 +++
>  arch/x86/kvm/svm/sev.c                        | 60 +++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.c                  |  1 +
>  include/linux/psp-sev.h                       | 28 +++++++++
>  5 files changed, 114 insertions(+)
>
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index 1ddb6a86ce7f..f473e9304634 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -572,6 +572,24 @@ Returns: 0 on success, -negative on error
>  See SNP_LAUNCH_FINISH in the SEV-SNP specification [snp-fw-abi]_ for further
>  details on the input parameters in ``struct kvm_sev_snp_launch_finish``.
>  
> +21. KVM_SEV_SNP_GET_HV_REPORT
> +-----------------------------

The ioctl name is KVM_SEV_SNP_HV_REPORT_REQ in code but documented as
KVM_SEV_SNP_GET_HV_REPORT

> +
> +The KVM_SEV_SNP_GET_HV_REPORT command requests the hypervisor-generated
> +SNP attestation report. This report is produced by the PSP using the
> +HV-SIGNED key selected by the caller.
> +
> +Parameters (in): struct kvm_sev_snp_hv_report_req
> +
> +Returns:  0 on success, -negative on error
> +
> +::
> +        struct kvm_sev_snp_hv_report_req {
> +                __u8 key_sel;
> +                __u64 report_uaddr;
> +                __u64 report_len;
> +        };
> +

Should we document the valid values of key_sel here?

>  Device attribute API
>  ====================
>  
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index d420c9c066d4..ff034668cac4 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -742,6 +742,7 @@ enum sev_cmd_id {
>  	KVM_SEV_SNP_LAUNCH_START = 100,
>  	KVM_SEV_SNP_LAUNCH_UPDATE,
>  	KVM_SEV_SNP_LAUNCH_FINISH,
> +	KVM_SEV_SNP_HV_REPORT_REQ,
>  
>  	KVM_SEV_NR_MAX,
>  };
> @@ -870,6 +871,12 @@ struct kvm_sev_receive_update_data {
>  	__u32 pad2;
>  };
>  
> +struct kvm_sev_snp_hv_report_req {
> +	__u8 key_sel;
> +	__u64 report_uaddr;
> +	__u64 report_len;
> +};
> +
>  struct kvm_sev_snp_launch_start {
>  	__u64 policy;
>  	__u8 gosvw[16];
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0835c664fbfd..4ab572d970a4 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2253,6 +2253,63 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return rc;
>  }
>  
> +static int sev_snp_report_request(struct kvm *kvm, struct kvm_sev_cmd
> *argp)

s/sev_snp_report_request/sev_snp_hv_report_request/

> +{
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> +	struct sev_data_snp_hv_report_req data;
> +	struct kvm_sev_snp_hv_report_req params;
> +	void __user *u_report;
> +	void __user *u_params = u64_to_user_ptr(argp->data);
> +	struct sev_data_snp_msg_report_rsp *report_rsp = NULL;
> +	int ret;

Variable declarations: Not in reverse Christmas tree order (preferred
but not mandatory per KVM x86 guidelines)

> +
> +	if (!sev_snp_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (copy_from_user(&params, u_params, sizeof(params)))
> +		return -EFAULT;
> +
> +	/* A report uses 1184 bytes */
> +	if (params.report_len < 1184)

Can we use a define (ATTESTATION_REPORT_SIZE) for the magic number?

> +		return -ENOSPC;
> +
> +	memset(&data, 0, sizeof(data));
> +
> +	u_report = u64_to_user_ptr(params.report_uaddr);
> +	if (!u_report)
> +		return -EINVAL;
> +
> +	report_rsp = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!report_rsp)
> +		return -ENOMEM;
> +
> +	data.len = sizeof(data);
> +	data.hv_report_paddr = __psp_pa(report_rsp);
> +	data.key_sel = params.key_sel;
> +
> +	data.gctx_addr = __psp_pa(sev->snp_context);
> +	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_HV_REPORT_REQ, &data,
> +			    &argp->error);
> +
> +	if (ret)
> +		goto e_free_rsp;
> +
> +	params.report_len = report_rsp->report_size;
> +	if (copy_to_user(u_params, &params, sizeof(params)))
> +		ret = -EFAULT;
> +
> +	if (params.report_len < report_rsp->report_size) {
> +		ret = -ENOSPC;
> +		/* report is located right after rsp */

I think the above comment is for "report_rsp + 1", but is embedded in
the if { }, that is confusing.

> +	} else if (copy_to_user(u_report, report_rsp + 1, report_rsp->report_size)) {
> +		ret = -EFAULT;
> +	}
> +
> +e_free_rsp:

Should we zero the report_rsp before freeing (contains sensitive
attestation data) ?

            memzero_explicit(report_rsp, PAGE_SIZE);

Regards
Nikunj

> +	snp_free_firmware_page(report_rsp);
> +	return ret;
> +}
> +
>  struct sev_gmem_populate_args {
>  	__u8 type;
>  	int sev_fd;
> @@ -2664,6 +2721,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_SNP_LAUNCH_FINISH:
>  		r = snp_launch_finish(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_SNP_HV_REPORT_REQ:
> +		r = sev_snp_report_request(kvm, &sev_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 0d13d47c164b..5236d5ee19ac 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -251,6 +251,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
>  	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
>  	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
> +	case SEV_CMD_SNP_HV_REPORT_REQ:		return sizeof(struct sev_data_snp_hv_report_req);
>  	default:				return 0;
>  	}
>  
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index e0dbcb4b4fd9..c382edc8713a 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -91,6 +91,7 @@ enum sev_cmd {
>  	SEV_CMD_SNP_GCTX_CREATE		= 0x093,
>  	SEV_CMD_SNP_GUEST_REQUEST	= 0x094,
>  	SEV_CMD_SNP_ACTIVATE_EX		= 0x095,
> +	SEV_CMD_SNP_HV_REPORT_REQ	= 0x096,
>  	SEV_CMD_SNP_LAUNCH_START	= 0x0A0,
>  	SEV_CMD_SNP_LAUNCH_UPDATE	= 0x0A1,
>  	SEV_CMD_SNP_LAUNCH_FINISH	= 0x0A2,
> @@ -554,6 +555,33 @@ struct sev_data_attestation_report {
>  	u32 len;				/* In/Out */
>  } __packed;
>  
> +/**
> + * struct sev_data_snp_hv_report_req - SNP_HV_REPORT_REQ command params
> + *
> + * @len: length of the command buffer in bytes
> + * @key_sel: Selects which key to use for generating the signature.
> + * @gctx_addr: System physical address of guest context page
> + * @hv_report_paddr: System physical address where MSG_EXPORT_RSP will be written
> + */
> +struct sev_data_snp_hv_report_req {
> +	u32 len;		/* In */
> +	u32 key_sel:2;		/* In */
> +	u32 rsvd:30;
> +	u64 gctx_addr;		/* In */
> +	u64 hv_report_paddr;	/* In */
> +} __packed;
> +/**
> + * struct sev_data_snp_msg_export_rsp
> + *
> + * @status: Status : 0h: Success. 16h: Invalid parameters.
> + * @report_size: Size in bytes of the attestation report
> + */
> +struct sev_data_snp_msg_report_rsp {
> +	u32 status;			/* Out */
> +	u32 report_size;		/* Out */
> +	u8 rsvd[24];
> +} __packed;
> +
>  /**
>   * struct sev_data_snp_download_firmware - SNP_DOWNLOAD_FIRMWARE command params
>   *
> -- 
> 2.52.0

