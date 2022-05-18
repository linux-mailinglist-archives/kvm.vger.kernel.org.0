Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02B052BEFD
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 18:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239750AbiERPzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 11:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239726AbiERPzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 11:55:45 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2B0E2E;
        Wed, 18 May 2022 08:55:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MQqJJQJnIe8pHhfJdem7w4wnFMDy2H8xymPpvzU6jLTy0+vLzout6uLv9jGm8eV7w7OgoUDkMJpwimcuFAO1JlVhD3jkzW1LqOfs3Ezh/gOGcMZqlFkPQUkycg5RXXUTTCWDuc5fZ7z2jOUs/uUJhq3A5kjwlwsyFkmaGnTlAsp3kV/9OXZevXh5wyW2+vxkWB0IHTNeNXdmVUKZZEtGJkiEhub2f9YzDYls11ZM8Fw+Uht834K3adU6gqXOqKK1uPl2Z78wLUWjMwKQ+6ZITh0yEgIH/Yd2nuXTCFmwNPInkexPbIHLAh5qX/3TC8FYlOyKBUoxr7+xshW7ROAh4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vEqe0CSG3opFHLnEfDK20aZ1ibqzgoHXxTP7CIUYEWM=;
 b=mUGEc4OQVzRlLmZVT+RxNgvYNPYBrkkMJbS6ZOa9QOBTS8VEVSGfygVkS6+pSQQdc8XFu/kcwImOU8wvTPCWfE6CPD9fvrSXIXHHwnW0FlKlWvSnDYetqIpNUdhI/3OQtH+un9ONmqJHuMLO0U+UXSnBWqPlgLgBwnFx/60p1iwTwmpUB7KdXwgwrVtkIG36Uwoj5Qo0DBRBiDZrwj6/Pa+KfsiZTOWcfhpiWFoLJt3uZlKciSNJ1GfEKxSt7UVzD0RVg8vZLhOdh0VdpoiBeX6ySggoJG8DfRs/31NQEjqdZ4uPZlDlxwVFYe7XI9qili4C8Pv5/jKC/Vx1oiN7EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vEqe0CSG3opFHLnEfDK20aZ1ibqzgoHXxTP7CIUYEWM=;
 b=rqKzZ68LJxO6P5Gsq+F0cXvSsWrRHq2/ZepLg/sjznTGpldbg6GgZzmYTyphkyJuKPVi9gTvl9/48Zs5cDUDKWPZ48LcIHwiunw5yEhZmVYXQ1wgWmp1faYCN6hD299zoHInuHJgIvfci3yQcC3AP5KbxuXjDVettRWz5rF46BM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by MN0PR12MB6079.namprd12.prod.outlook.com (2603:10b6:208:3c9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 15:55:39 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::f010:1c99:9c9f:7cc6]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::f010:1c99:9c9f:7cc6%9]) with mapi id 15.20.5250.013; Wed, 18 May 2022
 15:55:39 +0000
Date:   Wed, 18 May 2022 10:55:31 -0500
From:   John Allen <john.allen@amd.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        yu.c.zhang@linux.intel.com, john.allen@amd.com
Subject: Re: [PATCH v15 07/14] KVM: VMX: Emulate reads and writes to CET MSRs
Message-ID: <YoUW4Oh0eRL9um5m@dell9853host>
References: <20210203113421.5759-1-weijiang.yang@intel.com>
 <20210203113421.5759-8-weijiang.yang@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203113421.5759-8-weijiang.yang@intel.com>
X-ClientProxiedBy: CH2PR16CA0012.namprd16.prod.outlook.com
 (2603:10b6:610:50::22) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 954bc124-8555-4f82-1b8e-08da38e6daca
X-MS-TrafficTypeDiagnostic: MN0PR12MB6079:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB607982CEF8F19DA382991B219AD19@MN0PR12MB6079.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qAVZdoHD6Gqosnjlbp9+56+pSqGxIqqOJYRPp++1hnD8g5oJ8rFwzCe94WeWaLUFqPbLW8totGzNaXgE0JNUL+gkp9It5I3mhFFBhRL+ISi5KeJxhRYpKICqLxbjc4UatHfhuEiVW5kFcwwyMLUs8Zjjrepxurb1tgeZPUo7hGcgH5cqVL0gGJjIf66v02jMnqbyEbzHZtS15iPN9PcydJNjD0YhlZcZr5yGI8ARdwzLos4hhxqkwNYx0frCO3R38i0c2YGRxu0LIDwN/fMRRFuzov1hY4zxXMhOp8abq2y3qKC2WGcm02csl0tDQVGcIryiNDX1PU05OczBs1w62AanhsPpUwr9II0YCXatBe8gruwlMbz1EJ+UQ17EtHOKigfW1pdKaEmPw7JiRx7v2p1vi3iF3p+VggkB+CvHsUGYXkxsVrACqWSXOndqCWFlWlUdZm81smBADbyPEUZA0kK+REuICYpVi2E0eHhQMldzid4YstBwtxx+7mTuNxaxH4AAoXKC4V/PhdkVlKvO7MSQ7PMR2bOBTYHqeDHMRfolIAZ3lspJVtJSgqaCY456s8M9upB32qPf/WtSHwf/EQA8RJTp6/U47rbC20v+BPIy0DHaNv3IvcmUHJiyORqqhCFsxpKUFRkwpEYp8Qu4ZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(4326008)(66946007)(66556008)(316002)(8676002)(2906002)(33716001)(9686003)(26005)(66476007)(6916009)(6486002)(44832011)(186003)(6512007)(8936002)(83380400001)(6666004)(38100700002)(86362001)(5660300002)(6506007)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vSaiEmQI6RJ6IxIW2e//rnx0x2M/o8Lyw5XVxVR/gNTW3Xl8beVPoup2NG/s?=
 =?us-ascii?Q?v+coXD+B7x+0upKO7aPrBPFyFQUwdb1ZwK/humvC1wY4I8SWuoTeTxX13X26?=
 =?us-ascii?Q?o0b//kUlUbsPdZNNf6hD3MnEcr+VskaTWyX584jQHDrepm+5cwEMXgHe3jtp?=
 =?us-ascii?Q?Mnv/JsnyOSefPTNYBjdEHNV/jTyCfa7wr8+N+ggZRrCQUXYmuXdEiA486+FP?=
 =?us-ascii?Q?4VUP9IBpB/j/V7VYHFcf8R57J11enIJhbvRE10oS1ziBtBIjgAJR3aCC/bgQ?=
 =?us-ascii?Q?AbZwrMzs/5tRg+YPPCe6M48LNzxCnMte/GbfZjHYwwKY8rFiplKJ+W0V8mko?=
 =?us-ascii?Q?1e4dk7BKBqPVXJzrm7vCUx8gWNlfCC2WEKpagK6MJ872CH8a8CAy9nKwmmNA?=
 =?us-ascii?Q?3liMgNSQ3x5GX91LtXA2gXzNAp1NnXsUh3UwsgfUn45/JXTY8Or2h2+YTziR?=
 =?us-ascii?Q?ws2dbORFpkA3V9usJRLKZfuuv66Japv3N3LYmsG7XaMIEHNnLFP8dhNeSX8M?=
 =?us-ascii?Q?JnShURoS9ireJScDsyRFN9a4i3Z6Uez4I699qSXfljOINMHE6QNzEd50YEgV?=
 =?us-ascii?Q?Sxj2e5m24R4Q0+w56Hbyi7b0AyGRznJVS4t3y3xsEmjaks3jX+te9G1j8LGU?=
 =?us-ascii?Q?teEzrk807RA7tNfDH0L6q0MEorpxMzn7izlaNe/5p4k8PapKSExvYzHs+hVr?=
 =?us-ascii?Q?T55SzihiTdD3RDbFemX4K0Th9KPY1WDNILEYS9/CvA/WUBwpA28xs1O882EM?=
 =?us-ascii?Q?YgPRlACLCK7NaycyIM87DvgnIEgrVGciSrL2AMStaVCXuamnpRVApLweTPFp?=
 =?us-ascii?Q?zAtnHx3HTZ4J+TCUVIC1Kk3Q5rcKIZ/YZT1fm0ijHnSSOoXs9FHPUzhSSAzN?=
 =?us-ascii?Q?l4iJTPXWIOHTNTq+rhRl0/k85gGDtZoBI9gmv+OyW41467gLNXmgavmiEASV?=
 =?us-ascii?Q?dCnjD9PJIAi2HXlOFLUZZdaXSnD1tdEgvHduzeYh6AjMHXCytQr6b/G5Qq3D?=
 =?us-ascii?Q?TOKtfBCTk7YY7vFPF1zb9a8g0NH0d9bnvzljJL6+8+r0i4FkRa3WQCTpmc6/?=
 =?us-ascii?Q?Aa63sra9GmHFCScNY2AtdsPIiqGEk6Ng/YQLW+SaOllT2H1fbDZFpFO/9uxp?=
 =?us-ascii?Q?Uilpt8zf0XEZuy0l6X442ucvHF0dtHKNLXavOt0yM5PPSf+5XxO6TXhYRoNv?=
 =?us-ascii?Q?sSdHU6KlMrhfpnV4KBPiMAjcxvGXjR8Qb3Q9P3a5Tg9Y+fRis5qVTx1hNsn1?=
 =?us-ascii?Q?Ai/m0NSJdEhRQiq/6BjSmEAPEKRD4cVxIn/kzagjWbYeZYalD0SDZNTw4B4x?=
 =?us-ascii?Q?OolMv+wn+oyHFqgkAZO9tAK8diKTa6jlR3uzNkD4JYn5cLS7UPsfJjD8CZg5?=
 =?us-ascii?Q?CfAT0fLytNiwSSu8MCttjGBedZM7WIh4gL3VskOc9/4jKx11sPBLqKcwXdmL?=
 =?us-ascii?Q?o+avfnBmgM+VGqdIY+gPahsGwjU4r4YJzbG+x7udg7IsEkLP1GgPksajIp+b?=
 =?us-ascii?Q?Tfh1JjCy3IsU/Kwp4O3Yd0MPMirqwB6eiG93Dao4dimVexMhWC/m6toZNKen?=
 =?us-ascii?Q?riI3wj++wpLir0EWd3Uo3RJ6Buz3ZmgnlFZ9M5Btwu5hIF70XySwfNjKM+Ef?=
 =?us-ascii?Q?o7asoXr/Dp81GN4Y5nF5Wj1E9YRpvGlnMq5wUiOJb4VsOgLKY/+SSCVN/CYb?=
 =?us-ascii?Q?EnRzUFmAYySbWtAGYCrWBHJZPtdHbjBRWwzOQJtIHKy4qdBccodj8QuFrCSU?=
 =?us-ascii?Q?Ydbzngc+UQ=3D=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 954bc124-8555-4f82-1b8e-08da38e6daca
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 15:55:39.3939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DVfiQxyYcrdGjT0DHd8XShbfuG1ksOaoc46w6v/4TkexlwhDkmvmrGJoehs1zE4UpEWEmKS1/Ftlf7brTVPPtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6079
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 03, 2021 at 07:34:14PM +0800, Yang Weijiang wrote:
> Add support for emulating read and write accesses to CET MSRs.  CET MSRs
> are universally "special" as they are either context switched via
> dedicated VMCS fields or via XSAVES, i.e. no additional in-memory
> tracking is needed, but emulated reads/writes are more expensive.
> 
> MSRs that are switched through XSAVES are especially annoying due to the
> possibility of the kernel's FPU being used in IRQ context.  Disable IRQs
> and ensure the guest's FPU state is loaded when accessing such MSRs.
> 
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 105 +++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.h     |   5 ++
>  2 files changed, 110 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cc60b1fc3ee7..694879c2b0b7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1787,6 +1787,66 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
>  	}
>  }
>  
> +static void vmx_get_xsave_msr(struct msr_data *msr_info)
> +{
> +	local_irq_disable();
> +	if (test_thread_flag(TIF_NEED_FPU_LOAD))
> +		switch_fpu_return();
> +	rdmsrl(msr_info->index, msr_info->data);
> +	local_irq_enable();
> +}
> +
> +static void  vmx_set_xsave_msr(struct msr_data *msr_info)
> +{
> +	local_irq_disable();
> +	if (test_thread_flag(TIF_NEED_FPU_LOAD))
> +		switch_fpu_return();
> +	wrmsrl(msr_info->index, msr_info->data);
> +	local_irq_enable();
> +}
> +
> +static bool cet_is_ssp_msr_accessible(struct kvm_vcpu *vcpu,
> +				      struct msr_data *msr)
> +{
> +	u64 mask;
> +
> +	if (!kvm_cet_supported())
> +		return false;
> +
> +	if (msr->host_initiated)
> +		return true;
> +
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> +		return false;
> +
> +	if (msr->index == MSR_IA32_INT_SSP_TAB)
> +		return true;
> +
> +	mask = (msr->index == MSR_IA32_PL3_SSP) ? XFEATURE_MASK_CET_USER :
> +						  XFEATURE_MASK_CET_KERNEL;
> +	return !!(vcpu->arch.guest_supported_xss & mask);
> +}
> +
> +static bool cet_is_control_msr_accessible(struct kvm_vcpu *vcpu,
> +					  struct msr_data *msr)
> +{
> +	u64 mask;
> +
> +	if (!kvm_cet_supported())
> +		return false;
> +
> +	if (msr->host_initiated)
> +		return true;
> +
> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
> +	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
> +		return false;
> +
> +	mask = (msr->index == MSR_IA32_U_CET) ? XFEATURE_MASK_CET_USER :
> +						XFEATURE_MASK_CET_KERNEL;
> +	return !!(vcpu->arch.guest_supported_xss & mask);
> +}
> +
>  /*
>   * Reads an msr value (of 'msr_index') into 'pdata'.
>   * Returns 0 on success, non-0 otherwise.
> @@ -1919,6 +1979,26 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		else
>  			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
>  		break;
> +	case MSR_IA32_S_CET:
> +		if (!cet_is_control_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		msr_info->data = vmcs_readl(GUEST_S_CET);
> +		break;
> +	case MSR_IA32_U_CET:
> +		if (!cet_is_control_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		vmx_get_xsave_msr(msr_info);
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		if (!cet_is_ssp_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
> +		break;
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		if (!cet_is_ssp_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		vmx_get_xsave_msr(msr_info);
> +		break;
>  	case MSR_TSC_AUX:
>  		if (!msr_info->host_initiated &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> @@ -2188,6 +2268,31 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		else
>  			vmx->pt_desc.guest.addr_a[index / 2] = data;
>  		break;
> +	case MSR_IA32_S_CET:
> +	case MSR_IA32_U_CET:
> +		if (!cet_is_control_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		if (data & GENMASK(9, 6))
> +			return 1;
> +		if (msr_index == MSR_IA32_S_CET)
> +			vmcs_writel(GUEST_S_CET, data);
> +		else
> +			vmx_set_xsave_msr(msr_info);
> +		break;
> +	case MSR_IA32_INT_SSP_TAB:
> +		if (!cet_is_control_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		if (is_noncanonical_address(data, vcpu))
> +			return 1;
> +		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
> +		break;
> +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> +		if (!cet_is_ssp_msr_accessible(vcpu, msr_info))
> +			return 1;
> +		if ((data & GENMASK(2, 0)) || is_noncanonical_address(data, vcpu))

Sorry to revive this old thread. I'm working on the corresponding SVM
bits for shadow stack and I noticed the above check. Why isn't this
GENMASK(1, 0)? The *SSP MSRs should be a 4-byte aligned canonical
address meaning that just bits 1 and 0 should always be zero. I was
looking through the previous versions of the set and found that this
changed between versions 11 and 12, but I don't see any discussion
related to this on the list.

Thanks,
John

> +			return 1;
> +		vmx_set_xsave_msr(msr_info);
> +		break;
>  	case MSR_TSC_AUX:
>  		if (!msr_info->host_initiated &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index fd8c46da2030..16c661d94349 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -288,6 +288,11 @@ static inline bool kvm_mpx_supported(void)
>  		== (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
>  }
>  
> +static inline bool kvm_cet_supported(void)
> +{
> +	return supported_xss & XFEATURE_MASK_CET_USER;
> +}
> +
>  extern unsigned int min_timer_period_us;
>  
>  extern bool enable_vmware_backdoor;
> -- 
> 2.26.2
> 
