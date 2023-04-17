Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15F86E4A31
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 15:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbjDQNoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 09:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbjDQNoN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 09:44:13 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6401BEB;
        Mon, 17 Apr 2023 06:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681739051; x=1713275051;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kmSOmY3QNePtyG8F3+4cyMxFsK3PUPALSsrrBGU+A3E=;
  b=JVpqmLAnZSSyG2HOuU3acbJpU4u7mcxIAdLTrAL1fWY6UFohPFHiHiui
   Kj/cY93t6OgaFdrunOuLE/0xOJk1w2kDsiUFcDm6mq2GB8M5gR3bSkb+l
   zr8C4MVhDezuQgUlJS2wfFQ4pbt3c5d7/tT18mtZGo8wTA+qzUlOPFk3P
   2+G0695vccHPWwRJu4+NqalybbLAVKVF4GvmluIikOI9VH/yySKEFQbYW
   rxfHZrmkU1RCN4XidLHS35BUAHYVUkCH1L+My+QOaw+m9L/nc5jheGKy9
   dfa3rk7lOgXOP96oZCERXIqvLaVRj1dKc0XlxPK2fXmLJ0DkAAIQPySP0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="329062601"
X-IronPort-AV: E=Sophos;i="5.99,204,1677571200"; 
   d="scan'208";a="329062601"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 06:44:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10683"; a="759953412"
X-IronPort-AV: E=Sophos;i="5.99,204,1677571200"; 
   d="scan'208";a="759953412"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.174.28]) ([10.249.174.28])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2023 06:44:00 -0700
Message-ID: <0312c900-fa7d-2ae5-22f7-956a7517193c@linux.intel.com>
Date:   Mon, 17 Apr 2023 21:43:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH v2 05/11] x86/bugs: Use Virtual MSRs to request
 hardware mitigations
To:     Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org
Cc:     Jiaan Lu <jiaan.lu@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Zhang Chen <chen.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Babu Moger <babu.moger@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        linux-kernel@vger.kernel.org
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-6-chao.gao@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230414062545.270178-6-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/14/2023 2:25 PM, Chao Gao wrote:
> From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>
> Guests that have different family/model than the host may not be aware
> of hardware mitigations(such as RRSBA_DIS_S) available on host. This is
> particularly true when guests migrate. To solve this problem Intel
> processors have added a virtual MSR interface through which guests can
> report their mitigation status and request VMM to deploy relevant
> hardware mitigations.
>
> Use this virtualized MSR interface to request relevant hardware controls
> for retpoline mitigation.
>
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Co-developed-by: Zhang Chen <chen.zhang@intel.com>
> Signed-off-by: Zhang Chen <chen.zhang@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Tested-by: Jiaan Lu <jiaan.lu@intel.com>
> ---
>   arch/x86/include/asm/msr-index.h | 25 +++++++++++++++++++++++++
>   arch/x86/kernel/cpu/bugs.c       | 25 +++++++++++++++++++++++++
>   2 files changed, 50 insertions(+)
>
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 60b25d87b82c..aec213f0c6fc 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -166,6 +166,7 @@
>   						 * IA32_XAPIC_DISABLE_STATUS MSR
>   						 * supported
>   						 */
> +#define ARCH_CAP_VIRTUAL_ENUM		BIT_ULL(63) /* MSR_VIRTUAL_ENUMERATION supported */
>   
>   #define MSR_IA32_FLUSH_CMD		0x0000010b
>   #define L1D_FLUSH			BIT(0)	/*
> @@ -1103,6 +1104,30 @@
>   #define MSR_IA32_VMX_MISC_INTEL_PT                 (1ULL << 14)
>   #define MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS (1ULL << 29)
>   #define MSR_IA32_VMX_MISC_PREEMPTION_TIMER_SCALE   0x1F
> +
> +/* Intel virtual MSRs */
> +#define MSR_VIRTUAL_ENUMERATION			0x50000000
> +#define VIRT_ENUM_MITIGATION_CTRL_SUPPORT	BIT(0)	/*
> +							 * Mitigation ctrl via virtual
> +							 * MSRs supported
> +							 */
> +
> +#define MSR_VIRTUAL_MITIGATION_ENUM		0x50000001
> +#define MITI_ENUM_BHB_CLEAR_SEQ_S_SUPPORT	BIT(0)	/* VMM supports BHI_DIS_S */
> +#define MITI_ENUM_RETPOLINE_S_SUPPORT		BIT(1)	/* VMM supports RRSBA_DIS_S */
> +
> +#define MSR_VIRTUAL_MITIGATION_CTRL		0x50000002
> +#define MITI_CTRL_BHB_CLEAR_SEQ_S_USED_BIT	0	/*
> +							 * Request VMM to deploy
> +							 * BHI_DIS_S mitigation
> +							 */
> +#define MITI_CTRL_BHB_CLEAR_SEQ_S_USED		BIT(MITI_CTRL_BHB_CLEAR_SEQ_S_USED_BIT)

Seems it is defined, but not used to request VMM to deploy BHI_DIS_S 
mitigation?


And IMO, it is more natual to put this patch after the four capability 
advertising patches.


> +#define MITI_CTRL_RETPOLINE_S_USED_BIT		1	/*
> +							 * Request VMM to deploy
> +							 * RRSBA_DIS_S mitigation
> +							 */
> +#define MITI_CTRL_RETPOLINE_S_USED		BIT(MITI_CTRL_RETPOLINE_S_USED_BIT)
> +
>   /* AMD-V MSRs */
>   
>   #define MSR_VM_CR                       0xc0010114
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index f9d060e71c3e..5326c03d9d5e 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -1435,6 +1435,27 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
>   	dump_stack();
>   }
>   
> +/* Speculation control using virtualized MSRs */
> +static void spec_ctrl_setup_virtualized_msr(void)
> +{
> +	u64 msr_virt_enum, msr_mitigation_enum;
> +
> +	/* When retpoline is being used, request relevant hardware controls */
> +	if (!boot_cpu_has(X86_FEATURE_RETPOLINE))
> +		return;
> +
> +	if (!(x86_read_arch_cap_msr() & ARCH_CAP_VIRTUAL_ENUM))
> +		return;
> +
> +	rdmsrl(MSR_VIRTUAL_ENUMERATION, msr_virt_enum);
> +	if (!(msr_virt_enum & VIRT_ENUM_MITIGATION_CTRL_SUPPORT))
> +		return;
> +
> +	rdmsrl(MSR_VIRTUAL_MITIGATION_ENUM, msr_mitigation_enum);
> +	if (msr_mitigation_enum & MITI_ENUM_RETPOLINE_S_SUPPORT)
> +		msr_set_bit(MSR_VIRTUAL_MITIGATION_CTRL, MITI_CTRL_RETPOLINE_S_USED_BIT);
> +}
> +
>   static void __init spectre_v2_select_mitigation(void)
>   {
>   	enum spectre_v2_mitigation_cmd cmd = spectre_v2_parse_cmdline();
> @@ -1546,6 +1567,8 @@ static void __init spectre_v2_select_mitigation(void)
>   	    mode == SPECTRE_V2_RETPOLINE)
>   		spec_ctrl_disable_kernel_rrsba();
>   
> +	spec_ctrl_setup_virtualized_msr();
> +
>   	spectre_v2_enabled = mode;
>   	pr_info("%s\n", spectre_v2_strings[mode]);
>   
> @@ -2115,6 +2138,8 @@ void x86_spec_ctrl_setup_ap(void)
>   
>   	if (ssb_mode == SPEC_STORE_BYPASS_DISABLE)
>   		x86_amd_ssb_disable();
> +
> +	spec_ctrl_setup_virtualized_msr();
>   }
>   
>   bool itlb_multihit_kvm_mitigation;
