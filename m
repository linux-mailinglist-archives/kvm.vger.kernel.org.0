Return-Path: <kvm+bounces-17266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75F538C34DA
	for <lists+kvm@lfdr.de>; Sun, 12 May 2024 04:07:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C42FF28198D
	for <lists+kvm@lfdr.de>; Sun, 12 May 2024 02:07:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04F0379F3;
	Sun, 12 May 2024 02:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fNfq0FrQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E84D2F52;
	Sun, 12 May 2024 02:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715479646; cv=fail; b=m3YABldtkWxOsM0bTNj/Ayemz7z8t346MJIn1QDqkPCqr04Y7INLUQpw3Usz19fA9qay0NiLTla9Y3M++R8uBcIEHm31uCPLevG5Svm6JAaWIj4yDwxQgf/UjU7IGI1RYPJ3yeZcYsx4SoApryU5STh/VKOZalyQXOX8tYdlBUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715479646; c=relaxed/simple;
	bh=bZd0OOkFJw2OwaEHZRLafwTRadk5CCQ4NBwQ8Uk3qEQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VIWotW62RFTmhSQY9pwi+RIgEQrdmfZ+1nFDdlWIIz48STAA15fqEy/SwwIK+1DI15VP+ywQ6okD1FmzlV+kSSbwEL4OQ4hMvU1aSJ7sXOh/R/oTMLSdwidFW0ObGGYIRD13M61wD+CWYtadt3HVChg9HtcT/kQYARHgYhsvJuM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fNfq0FrQ; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gTIw1Mz0lhWfoRUJX3eqpgSwCc8WT9SQi0zwqLIiSPb8XUzn7SAMra3IBrNt9OihQzlBb0Juf9sDDwPTI1gNYaj9dkSiY7+Cz6E+33L5dq76fnuzTsuK49VBZBgBkmY9L7Zrh2JYUhUJcrxZ7P0CGH25JtBaLMr4PkpZAykqMst/n72EyLsABPrg6zpbNyYLo/dzJBVcl6e6l6ISJbeQO9Zg+VyBr7Ac0nSv6C5sxGKXWFY63Neu3JX0f8FBmlPSsQdA6Q74IyoTabraByC7XqQNVw4Dx1o644E9UFTtKmeYI9Mkzc+dxRzZ1tkBYVP2DkplXAfDTwSQmnWddfF9Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hqICn3RBZpJXwMURcqIOKXaEIGBH38uMSSzSRNJaAZY=;
 b=Va92PY7LHB0IYxyP2FItSbsfMgZvDZyCsNoj563W/Xa3iXZmqNFIcj0GqxM/w+2XJRXcCmN/bsBh7JoEN/3pbSm6lrUGeImfza6VcwZ3LwdKS+KajT0e2oyTc2v0LAJwz3XDGl0Of5UPAncfDLMRmyHnDy6I+ajC489D/IPYzgAFHtqwN7Ado8HCXCW8Gv65FGfJSo7QBz1fpghCzJT3vIP6ezO6khfw2ONsDQMBLMVVTBKCOvtbL6JIODxbj95If/8vupqgxa9PqCFnaycFedDtg4ca+ctHGb1K/NOEYLT8l6VESBT8TTKE9g+kMN5sHb4KTbmwtAFqh6Wc34i4NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hqICn3RBZpJXwMURcqIOKXaEIGBH38uMSSzSRNJaAZY=;
 b=fNfq0FrQ2A0wf23ClZiBPeVZv8pMX0JGtb2OWj9w0Ff2kLhj9I9yKM0pwqgqjgUS4DZiCo4txY+kDXD7VYo16/bP4aIVhXBXTUUfGFF82tYgtxIMzvOvHZkA5NfXfJfVtJ00f5fufZC94/uUj//Pny9ZtzbXu54Q0ljSHGBMEDw=
Received: from BN9PR03CA0872.namprd03.prod.outlook.com (2603:10b6:408:13c::7)
 by DM4PR12MB6496.namprd12.prod.outlook.com (2603:10b6:8:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Sun, 12 May
 2024 02:07:21 +0000
Received: from BN2PEPF00004FBD.namprd04.prod.outlook.com
 (2603:10b6:408:13c:cafe::fb) by BN9PR03CA0872.outlook.office365.com
 (2603:10b6:408:13c::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.34 via Frontend
 Transport; Sun, 12 May 2024 02:07:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF00004FBD.mail.protection.outlook.com (10.167.243.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Sun, 12 May 2024 02:07:21 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sat, 11 May
 2024 21:07:21 -0500
Date: Sat, 11 May 2024 21:06:34 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>, Brijesh Singh <brijesh.singh@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>
Subject: Re: [PULL 09/19] KVM: SEV: Add support to handle Page State Change
 VMGEXIT
Message-ID: <20240512020634.6sh6cwfwszzmwknq@amd.com>
References: <20240510211024.556136-1-michael.roth@amd.com>
 <20240510211024.556136-10-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240510211024.556136-10-michael.roth@amd.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBD:EE_|DM4PR12MB6496:EE_
X-MS-Office365-Filtering-Correlation-Id: 97e2e1fd-f4d1-4237-a7b5-08dc7228426f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X2cQE8n6SMBF+b440oNO2+UWYbqTXPk1MEX5uv7M7EnSIfPcEG5IilMmdM4f?=
 =?us-ascii?Q?gK4Hj0T25ocD3nJTHrculiB4RtKkUzI7v6E338D2PAH1oXXkxSLp33g+iKZv?=
 =?us-ascii?Q?Mr6VviaT4yJYbOuh+0KrfH1rEtRdtVjiNol9l91f6vUNbLd2B0oZVA3QgE55?=
 =?us-ascii?Q?bRI5/QQhb2TrXg6s8gjpASmkYMUpGq5NKh6iJBE0zK6BG+qA9pfAYrq4B/7m?=
 =?us-ascii?Q?H77PslZ85elJiY9J+PnQpjp9xm/UvcxUusCOC6H9xtRVSQ/uyJP81DcDSqrQ?=
 =?us-ascii?Q?ERpuf7GEpWi/Ea0tJsg9cm17qCIwpF1cqjbfZfJ6+/kpF7TpB7DUZLA3nuag?=
 =?us-ascii?Q?NmWnbeWfToFqrbCPXS8VihPdz/J6YRgvHewENONpqyQmwpaneVlKs+qjhMLy?=
 =?us-ascii?Q?yY0C/ieGJVULh0Jl07CHIKLH0mTjocDCedD7UT8qQ0qG9pYXpq3kaFueQGSL?=
 =?us-ascii?Q?jQQFWIXxhSAp6wVMfC5asGGudB8TAYhSydClXzlaLHVjSzR7UYph/N8rqU0A?=
 =?us-ascii?Q?Evogr3O9LINQqQ3QaZsN2I5R3La0KkW4v5VEnHfgL6WzvOXy97jXRgSyc4zU?=
 =?us-ascii?Q?3xHDOU6v2YXAIjlpetSnqG20jkKULukaWF5J061N340QXM2PA1gWAeT9bQVv?=
 =?us-ascii?Q?/62qA0qocOVGTi0nFHQfa/kZ5Nxjd2EN3+NDRIkTamR7R6L00H0xrpmEho3o?=
 =?us-ascii?Q?nky6O4X6Z0tKUlGG7eYB31MRCqVIh+dSVXSLGcqpMl/NTJ47jzWaHLe4aYa0?=
 =?us-ascii?Q?cpsW82fy5cIhFDwkPd8w2IPHefqmBjEASSg3VYskf6yvRp0wfEdh7m/Y3qee?=
 =?us-ascii?Q?lIiJ+ECaJJulkq2qOznpO4GeDaEGdkkYY6c/lCA87HBI4iERyiTND9sLuBcO?=
 =?us-ascii?Q?XK9R4llHx5jm+CuQP1PEn7/f5G/ef1+zP1hGMTHVJi3GJhCL48siVE5tY+uB?=
 =?us-ascii?Q?Kp2KRun9DcLAxw/nSiXMkc9t6otjt5uIM/qbE47yv5vWjYgIdc0fg7+4VdkT?=
 =?us-ascii?Q?EEYpdF8yA8sskbv4bPHsSVW2xeFmON6cmaGYoAIcq6NNw9G5OKyAAvuiz2GQ?=
 =?us-ascii?Q?g61VV0ltalYzxNs/BuJXE8w72TwbSCkLsbP+RoDyqEIwkbt+jbGwRXF4I42u?=
 =?us-ascii?Q?bzq5tRMv7SdumT14HBuB0LfhfsF2fDs3EKrssOqB4MLj2B/pgeg8CVgvAkmY?=
 =?us-ascii?Q?BHrkH+OiIpvSixn17KZYkr0mkyOosSx9t5ipzfSsWFoSM2Hh6PsGHqSZD227?=
 =?us-ascii?Q?Q+e2z7O1Fs9opbscb4ZfYbg4GA2Mb82YUTcGkmvb+g7ReOTO5P+ZKcJwtBao?=
 =?us-ascii?Q?yioU/FU8eF06y2ZKJ7W2WEczMJ+HtFtTIvCSRWmsEgiXx9Z72ifWRLLfBlSS?=
 =?us-ascii?Q?m3n0Ioo=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2024 02:07:21.8171
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 97e2e1fd-f4d1-4237-a7b5-08dc7228426f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6496

On Fri, May 10, 2024 at 04:10:14PM -0500, Michael Roth wrote:
> SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
> table to be private or shared using the Page State Change NAE event
> as defined in the GHCB specification version 2.
> 
> Forward these requests to userspace as KVM_EXIT_VMGEXITs, similar to how
> it is done for requests that don't use a GHCB page.
> 
> As with the MSR-based page-state changes, use the existing
> KVM_HC_MAP_GPA_RANGE hypercall format to deliver these requests to
> userspace via KVM_EXIT_HYPERCALL.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Co-developed-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Message-ID: <20240501085210.2213060-11-michael.roth@amd.com>
> Co-developed-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/sev-common.h |  11 ++
>  arch/x86/kvm/svm/sev.c            | 188 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.h            |   5 +
>  3 files changed, 204 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 438f2e8b8152..46669431b53d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3274,6 +3274,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  	case SVM_VMGEXIT_HV_FEATURES:
>  	case SVM_VMGEXIT_TERM_REQUEST:
>  		break;
> +	case SVM_VMGEXIT_PSC:
> +		if (!sev_snp_guest(vcpu->kvm) || !kvm_ghcb_sw_scratch_is_valid(svm))
> +			goto vmgexit_err;
> +		break;
>  	default:
>  		reason = GHCB_ERR_INVALID_EVENT;
>  		goto vmgexit_err;
> @@ -3503,6 +3507,183 @@ static int snp_begin_psc_msr(struct vcpu_svm *svm, u64 ghcb_msr)
>  	return 0; /* forward request to userspace */
>  }
>  
> +struct psc_buffer {
> +	struct psc_hdr hdr;
> +	struct psc_entry entries[];
> +} __packed;
> +
> +static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc);
> +
> +static void snp_complete_psc(struct vcpu_svm *svm, u64 psc_ret)
> +{
> +	svm->sev_es.psc_inflight = 0;
> +	svm->sev_es.psc_idx = 0;
> +	svm->sev_es.psc_2m = false;
> +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, VMGEXIT_PSC_ERROR_GENERIC);

Unfortunately an important local change didn't make its way into the tagged
branch (commit 4b3f0135f759). I've updated the pull tag (tags/kvm-queue-snp)
to point to the updated branch (commit e704293d704d), which contains only
the following additional change:

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 398266bef2ca..57c2c8025547 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3560,7 +3560,7 @@ static void snp_complete_psc(struct vcpu_svm *svm, u64 psc_ret)
        svm->sev_es.psc_inflight = 0;
        svm->sev_es.psc_idx = 0;
        svm->sev_es.psc_2m = false;
-       ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, VMGEXIT_PSC_ERROR_GENERIC);
+       ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, psc_ret);
 }

 static void __snp_complete_one_psc(struct vcpu_svm *svm)

