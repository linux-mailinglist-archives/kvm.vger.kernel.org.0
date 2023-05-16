Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71BC970461E
	for <lists+kvm@lfdr.de>; Tue, 16 May 2023 09:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjEPHRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 May 2023 03:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbjEPHRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 May 2023 03:17:19 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF0910D7;
        Tue, 16 May 2023 00:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684221437; x=1715757437;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CF0PB4WyLDyRSIxIQH72Oz59jXQfGxiqd8zGQ1WP2Do=;
  b=YUJQGQc0SCX969GByBLSmZvBnBnywZYqv+6340np5hMkD8bn5DWe3xyc
   FACpzvRayV8Zw89S5EoWT6eDQ3RR+UUoybmB/Y1ye9PljukFkun004tcI
   DWy5KGPDwcYpPvu3Lsul5C0DuGPGwHyVV38/nUZRn/xrbWH0pz3EHblwo
   HU5npBUlhU2zDwkjtjOantvaxhm4wvXWTLRjMiFaNCKoA1ZafiicZjt/l
   DXdkBBWveb7gnF82n80vhCe3F6EG7VQ1aqkk5dMD9+RpBM2tYD8hyRBJM
   n2o4uIbA09UbCEMD1iQojIW1uGKBbRHsGXKDERdP/5RYlgTUGKvjydS6F
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="414810525"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="414810525"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 00:17:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="770929129"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="770929129"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.31.11]) ([10.255.31.11])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 00:17:01 -0700
Message-ID: <6b861c8d-9b93-74f2-6073-6f1284e72fd2@intel.com>
Date:   Tue, 16 May 2023 15:16:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
Subject: Re: [RFC PATCH v2 04/11] KVM: VMX: Add IA32_SPEC_CTRL virtualization
 support
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org
Cc:     Jiaan Lu <jiaan.lu@intel.com>, Zhang Chen <chen.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20230414062545.270178-1-chao.gao@intel.com>
 <20230414062545.270178-5-chao.gao@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230414062545.270178-5-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/14/2023 2:25 PM, Chao Gao wrote:

...

> +static inline void vmx_set_guest_spec_ctrl(struct vcpu_vmx *vmx, u64 val)
> +{
> +	vmx->guest_spec_ctrl = val;
> +
> +	/*
> +	 * For simplicity, always keep IA32_SPEC_CTRL_SHADOW up-to-date,
> +	 * regardless of the MSR intercept state.
> +	 */
> +	if (cpu_has_spec_ctrl_virt())
> +		vmcs_write64(IA32_SPEC_CTRL_SHADOW, val);
> +
> +	/*
> +	 * Update the effective value of IA32_SPEC_CTRL to reflect changes to
> +	 * guest's IA32_SPEC_CTRL. Bits in the mask should always be set.
> +	 */

Why bits in the mask should always be set?

The bits set in the mask only means them cannot be modified by guest. 
KVM can use the mask to force the bits to 0 as well.

> +	vmx->spec_ctrl = val | vmx_get_spec_ctrl_mask(vmx);
> +}
>   #endif /* __KVM_X86_VMX_H */

