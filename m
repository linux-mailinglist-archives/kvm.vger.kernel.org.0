Return-Path: <kvm+bounces-12554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C1D4588A003
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 13:46:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0D5D5B4762F
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 11:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 406D43BC072;
	Mon, 25 Mar 2024 03:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FETsD2Hh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C748217CF63;
	Sun, 24 Mar 2024 23:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711323811; cv=fail; b=rnTPjNGqaYvNPfXdWPJrbDpt8lvLurCfgln68IPaRvKaNykIy/JyQrKI23yGSbh1vLmBmt7Izxz1YiopRXcJ45nNExqrRx0wwTLhkCWfk6UX7dqSTt39qAr0+necVyILylSHbPdQogdVUv6JGIMMEcvVFVS+1nHwmL1KhQkWGaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711323811; c=relaxed/simple;
	bh=z16ZABH5yQ7OeHwrlwREFzrEd9B5BmrBCHtthPyTRuw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HAICJ+/Hw1q+z8Gc8UXGbIz6pZp+FiySiWfgYpCHxAI9HlCXV1OwwAVdnb9A3VXBJ9OA+2bW7bKvBKJWqzojQBKd2L+x6de5aOTVSj17usqFPzdLzcl1reUa4alAixwQ7Kca+kIr8DF0TtNr04ADM6ptEFobdXF/1jQh7JVGAb8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FETsD2Hh; arc=fail smtp.client-ip=40.107.223.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n5EvTlkdNoJ0xkaFcKfQYx8MxL2/EnQivOvckEsiSCJo0jcTbiu11AukbtaZ6giGGj1B91UNQqYBEIdWu648q4UtKVI9keBNsTKtrFoK04ENcwsO9tQ3NCS8x7Jt+HiuB/3TaUCSSQDZ8aR2pHGN/juPvWY3mrmnc5fmCM8b21kUC2+FvKYvKNV3kJPncv6BSwbs8KwuNUwp56u2U0hy5h5CoUKYmqa7hWKRuJxgouNIFRwDrPnhvl7/vtlRoPaPec3Oke1VZOnCjzm5wbYQc9Yh6GREIysP6su3EVPL/L7yQ4ZOV8TdEmRhi1F2dksYc2OCxAOHQ7C3hhDuIJFIpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CMuLpCakxxsMDkQcNqM3yUQHABnpWMP6WdQgfWltTkQ=;
 b=RbQgyvzMB1wsHNm3CYkDVfZxMQb0tqdrg1H1aNnEvl5VjuBA8bX1wbEXZjpfGCPvhRFCtAHrrkIDh2zlZAvdBxQzIoOoJgJBQeD4lClCxelz3cD1Pi+D6Y1zXVzpyC6Nax1kktFgzqOIFqi7j2rY2LObGWEqEl5PHi4JfTlj6IMTIVvux5E+QZhxzPYD0zt60/yvXdJhjsTh0k2npXSnNz9A0UQA5yjh0uRB69JToHpkdxH+xpcnN6gGX21rTaxyFPxvntiMInd64S7G855pdayPdis98yoY2MInttK97/6FoA2x3WTC695SPc5gcxr/x73z15CiycGtiqhukjGmmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMuLpCakxxsMDkQcNqM3yUQHABnpWMP6WdQgfWltTkQ=;
 b=FETsD2HhWrqNw+NzfOaJbVFM1jTZDHukCDANBYwW6tD3TFpQVv/VEDqZ+IWktq1Q9H1pksa7rD4gUJ8TOx2HWt/X6uC8JbjqZzc73mlNf8xa1plRzA9xF136v8XjNWULXdtE7Yl0CIaxbJ3O5af4YByGRgCQgV+hToSDReIZZGw=
Received: from BN9P220CA0006.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::11)
 by CH2PR12MB4197.namprd12.prod.outlook.com (2603:10b6:610:ab::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Sun, 24 Mar
 2024 23:43:24 +0000
Received: from BN3PEPF0000B371.namprd21.prod.outlook.com
 (2603:10b6:408:13e:cafe::9d) by BN9P220CA0006.outlook.office365.com
 (2603:10b6:408:13e::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.13 via Frontend
 Transport; Sun, 24 Mar 2024 23:43:24 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B371.mail.protection.outlook.com (10.167.243.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7430.0 via Frontend Transport; Sun, 24 Mar 2024 23:43:22 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 24 Mar
 2024 18:43:21 -0500
Date: Sun, 24 Mar 2024 18:39:18 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<isaku.yamahata@intel.com>, <seanjc@google.com>, Dave Hansen
	<dave.hansen@linux.intel.com>
Subject: Re: [PATCH v4 09/15] KVM: SEV: sync FPU and AVX state at
 LAUNCH_UPDATE_VMSA time
Message-ID: <20240324233918.25tsnexp3rlnhtaa@amd.com>
References: <20240318233352.2728327-1-pbonzini@redhat.com>
 <20240318233352.2728327-10-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240318233352.2728327-10-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B371:EE_|CH2PR12MB4197:EE_
X-MS-Office365-Filtering-Correlation-Id: 152c9b4a-e7a9-4828-d5e2-08dc4c5c312a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QRROM/W7qimnQ18Kc27AXk12r0JF87jpaTakq6egpp/0s4gewQGedcLl/V7DjebbxiXIlLlBcyrcHic4zN2MNvIh4XF/XZ0sfI8B9G18p3cKOEIxuAxttQD9Fw8YfkrhoNZzl+VruVPUTUVEmzLBXbfU0zeE/t85wQQxvN3rU6ciQVXDs+48mpM1UfCcAfG/TsJgmHdnwc9HU1xh0DK+SN9kOlvW6HZknAKoo4k5jLSAKkbiHeGHnC+D4FfAwJs6qvHRYu0H5CsOTniqR/V5iH2mIuqILnc3CONheSKj8B6LRSpn/yge35mipR9TFug9igX0I6WXRswxXVWk6z7aE0jymZ104BWZ2CY+xE+EycV3SIBN/NWi0MjWSNSSykkc82ouipM5VvBNQKLJTrp/F1XdbXdFJQYIDI6W6f8QGT7O4X9x7GRi5eoshQZFucNf3NZQcEWk3t4v614q8ttRDLYPU6wpbwPUrXT1pnveAAub5Z0Nc8NpLCX74BLbpbb+7JMpqMUW0GTfBDK4nU0fdd3LSlEFPGBAyBiiY59eN2Eq8d31s1sIYMh2ecWN6EhezGify/cq4ovirYE1MAV0IBaOc+aHf25wOTh0UtQOZvY7yiJchkHmSsgy9flE61e8DumLbh35ftrbYTnC52oLk8V0OatehcEqNvQjqtZNvXRqqUhMflCRU+uJ7i6ecwnjfwd/IKV7EdTMG3mucIPcrAQzLUBKvu4M1e/1Z9vwP+9aBTq7lLnJxYrS2bfTxR/z
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2024 23:43:22.4110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 152c9b4a-e7a9-4828-d5e2-08dc4c5c312a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B371.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4197

On Mon, Mar 18, 2024 at 07:33:46PM -0400, Paolo Bonzini wrote:
> SEV-ES allows passing custom contents for x87, SSE and AVX state into the VMSA.
> Allow userspace to do that with the usual KVM_SET_XSAVE API and only mark
> FPU contents as confidential after it has been copied and encrypted into
> the VMSA.
> 
> Since the XSAVE state for AVX is the first, it does not need the
> compacted-state handling of get_xsave_addr().  However, there are other
> parts of XSAVE state in the VMSA that currently are not handled, and
> the validation logic of get_xsave_addr() is pointless to duplicate
> in KVM, so move get_xsave_addr() to public FPU API; it is really just
> a facility to operate on XSAVE state and does not expose any internal
> details of arch/x86/kernel/fpu.
> 
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/fpu/api.h |  3 +++
>  arch/x86/kernel/fpu/xstate.h   |  2 --
>  arch/x86/kvm/svm/sev.c         | 36 ++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c         |  8 --------
>  4 files changed, 39 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a8300646a280..800e836a69fb 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> +	xsave = &vcpu->arch.guest_fpu.fpstate->regs.xsave;
> +	save->x87_dp = xsave->i387.rdp;
> +	save->mxcsr = xsave->i387.mxcsr;
> +	save->x87_ftw = xsave->i387.twd;
> +	save->x87_fsw = xsave->i387.swd;
> +	save->x87_fcw = xsave->i387.cwd;
> +	save->x87_fop = xsave->i387.fop;
> +	save->x87_ds = 0;
> +	save->x87_cs = 0;
> +	save->x87_rip = xsave->i387.rip;
> +
> +	for (i = 0; i < 8; i++) {
> +		d = save->fpreg_x87 + i * 10;
> +		s = ((u8 *)xsave->i387.st_space) + i * 16;
> +		memcpy(d, s, 10);
> +	}
> +	memcpy(save->fpreg_xmm, xsave->i387.xmm_space, 256);
> +
> +	s = get_xsave_addr(xsave, XFEATURE_YMM);
> +	if (s)
> +		memcpy(save->fpreg_ymm, s, 256);
> +	else
> +		memset(save->fpreg_ymm, 0, 256);
> +
>  	pr_debug("Virtual Machine Save Area (VMSA):\n");
>  	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
>  
> @@ -657,6 +686,13 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  	if (ret)
>  	  return ret;
>  
> +	/*
> +	 * SEV-ES guests maintain an encrypted version of their FPU
> +	 * state which is restored and saved on VMRUN and VMEXIT.
> +	 * Mark vcpu->arch.guest_fpu->fpstate as scratch so it won't
> +	 * do xsave/xrstor on it.
> +	 */
> +	fpstate_set_confidential(&vcpu->arch.guest_fpu);
>  	vcpu->arch.guest_state_protected = true;
>  	return 0;
>  }
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c22e87ebf0de..03108055a7b0 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1433,14 +1433,6 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
>  		vmsa_page = snp_safe_alloc_page(vcpu);
>  		if (!vmsa_page)
>  			goto error_free_vmcb_page;
> -
> -		/*
> -		 * SEV-ES guests maintain an encrypted version of their FPU
> -		 * state which is restored and saved on VMRUN and VMEXIT.
> -		 * Mark vcpu->arch.guest_fpu->fpstate as scratch so it won't
> -		 * do xsave/xrstor on it.
> -		 */
> -		fpstate_set_confidential(&vcpu->arch.guest_fpu);

There may have be userspaces that previously relied on KVM_SET_XSAVE
being silently ignored when calculating the expected VMSA measurement.
Granted, that's sort of buggy behavior on the part of userspace, but QEMU
for instance does this. In that case, it just so happens that QEMU's reset
values don't appear to affect the VMSA measurement/contents, but there may
be userspaces where it would.

To avoid this, and have parity with the other interfaces where the new
behavior is gated on the new vm_type/KVM_SEV_INIT2 stuff (via
has_protected_state), maybe should limited XSAVE/FPU sync'ing to
has_protected_state as well?

-Mike

>  	}
>  
>  	err = avic_init_vcpu(svm);
> -- 
> 2.43.0
> 
> 

