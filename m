Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E87F74FF0A
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 08:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbjGLGJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 02:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbjGLGIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 02:08:55 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD23210E;
        Tue, 11 Jul 2023 23:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689142100; x=1720678100;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CH+BgLUDKN7wzFrNHeRudgNib9NyLEvOxPXuiPpSf+Q=;
  b=I6pLDoddjnuooaSOadDHuJnHk65UhirF9md9PjwFW6Jmn2h1KcDepSoq
   LpnWX77skwWRw++VBx8p5ZRZWMTL86sYlcMtASi2zkILJoLWSXlpRiEc/
   06Oku44HYpI1rmlcxHs7Nqt1PzdKW/bWwTs3p5kKRzZI7+rxPi5LksjsB
   hY4sJi0BQzxH7l7r9h+y4brdHo/2tvnyGJXkYAxwjhSorkVvP85RQ6qxg
   jmR3FKFezIokCrtX88pyoJv1/ZzFhPLEmG8+2GrYNxmcd0kQEV2N1DxQY
   fxRmHbL0G7uEVTLujLsHD8hw0PCEgPFUwpUsqLcIRmxxYe1i/EVb8Neml
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="354716213"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="354716213"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 23:08:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="895473500"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="895473500"
Received: from qianwen-mobl1.ccr.corp.intel.com (HELO [10.238.5.29]) ([10.238.5.29])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 23:08:17 -0700
Message-ID: <48951fc1-4e98-b32a-af4f-343b7ea2d44d@intel.com>
Date:   Wed, 12 Jul 2023 14:08:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v14 072/113] KVM: TDX: handle vcpu migration over logical
 processor
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <7a57603a0668ec51a7ac324ab3d1a8acb9863e7b.1685333728.git.isaku.yamahata@intel.com>
From:   "Wen, Qian" <qian.wen@intel.com>
In-Reply-To: <7a57603a0668ec51a7ac324ab3d1a8acb9863e7b.1685333728.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/29/2023 12:19 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> For vcpu migration, in the case of VMX, VMCS is flushed on the source pcpu,
> and load it on the target pcpu.  There are corresponding TDX SEAMCALL APIs,
> call them on vcpu migration.  The logic is mostly same as VMX except the
> TDX SEAMCALLs are used.
> 
> When shutting down the machine, (VMX or TDX) vcpus needs to be shutdown on
> each pcpu.  Do the similar for TDX with TDX SEAMCALL APIs.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/main.c    |  32 ++++++-
>  arch/x86/kvm/vmx/tdx.c     | 168 +++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx/tdx.h     |   2 +
>  arch/x86/kvm/vmx/x86_ops.h |   4 +
>  4 files changed, 203 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 17fb1515e56a..29ebd171dbe3 100644

...

> @@ -455,6 +606,19 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
>  		return;
>  	}
>  
> +	/*
> +	 * kvm_free_vcpus()
> +	 *   -> kvm_unload_vcpu_mmu()
> +	 *
> +	 * does vcpu_load() for every vcpu after they already disassociated
> +	 * from the per cpu list when tdx_vm_teardown(). So we need to
> +	 * disassociate them again, otherwise the freed vcpu data will be
> +	 * accessed when do list_{del,add}() on associated_tdvcpus list
> +	 * later.
> +	 */

Nit: kvm_free_vcpus() and tdx_vm_teardown() are typos? I don't find these functions.

> +	tdx_disassociate_vp_on_cpu(vcpu);
> +	WARN_ON_ONCE(vcpu->cpu != -1);
> +
>  	if (tdx->tdvpx_pa) {
>  		for (i = 0; i < tdx_info.nr_tdvpx_pages; i++) {
>  			if (tdx->tdvpx_pa[i])
