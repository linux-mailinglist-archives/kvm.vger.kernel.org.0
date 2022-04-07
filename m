Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407D74F71B5
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 03:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbiDGBvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 21:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiDGBvr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 21:51:47 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6A0171EEA;
        Wed,  6 Apr 2022 18:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649296187; x=1680832187;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WJrLoov+MjDP0lFzu4rpP8BuKdiCEexw6bxW6BUfq9E=;
  b=Jw0fWuIVJiOM5HqQVQIS0Qp5JBV95emLWYPV+LrNwSvuwTuvP1zOkLb8
   55uUVa2bzy5kIlydkiQgpozIFaeyfxXTfoPgRTShSvvOyrT5JHtT65uzj
   jjq4yR5w+DIelrqOr9MIdGSntUMwEifSbGWIQQnWwYBCN8v1fw5aSNlZr
   XrWyB3L6959CqfF0fYANiDqPNi9k962MPfStnG71NJPb+Yy5rikp8KiZB
   8K9RCRFo6f/dZDF58Kfbo9YMjGtkh86kZeZL3yoxTb9B9wdjFOQEknkxr
   5IKQmlAWYv8ljc1uFCXAOhBPEFMrLXG5dqB+E+M35GoZqyxxTz3th/+JR
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="286180840"
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="286180840"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 18:49:45 -0700
X-IronPort-AV: E=Sophos;i="5.90,241,1643702400"; 
   d="scan'208";a="652619313"
Received: from mgailhax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.55.23])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 18:49:43 -0700
Message-ID: <a975acec7aba5ee383a7112ecd45f51bb2665323.camel@intel.com>
Subject: Re: [RFC PATCH v5 058/104] KVM: x86/mmu: Focibly use TDP MMU for TDX
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Thu, 07 Apr 2022 13:49:41 +1200
In-Reply-To: <047e05425ffed2b5de321dba6679cb4d1c388f4e.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <047e05425ffed2b5de321dba6679cb4d1c388f4e.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:49 -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> At this point, TDX supports TDP MMU and doesn't support legacy MMU.
> Forcibly use TDP MMU for TDX irrelevant of kernel parameter to disable
> TDP MMU.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index b33ace3d4456..9df6aa4da202 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -16,7 +16,12 @@ module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
>  /* Initializes the TDP MMU for the VM, if enabled. */
>  bool kvm_mmu_init_tdp_mmu(struct kvm *kvm)
>  {
> -	if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
> +	/*
> +	 *  Because TDX supports only TDP MMU, forcibly use TDP MMU in the case
> +	 *  of TDX.
> +	 */
> +	if (kvm->arch.vm_type != KVM_X86_TDX_VM &&
> +		(!tdp_enabled || !READ_ONCE(tdp_mmu_enabled)))
>  		return false;
>  
>  	/* This should not be changed for the lifetime of the VM. */

Please move this patch forward before introducing any private/shared mapping
support, otherwise nothing prevents you from creating a TD against legacy MMU,
which is broken (especially you have allowed userspace to create TD in patch 10
"KVM: TDX: Make TDX VM type supported").

-- 
Thanks,
-Kai


