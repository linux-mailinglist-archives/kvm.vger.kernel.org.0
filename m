Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6EBD7D88BC
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 21:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjJZTHr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 15:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjJZTHp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 15:07:45 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938EE1A7;
        Thu, 26 Oct 2023 12:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698347263; x=1729883263;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EudwDoXQoHWpwZgKKjX9dS2pYiAfR24L11Z2/3zbV8w=;
  b=I7bwyw67MS/143mOrWdCXTROBUXP+2wztrsr9s+0RUjl7F79FQ/ZgV9t
   uobgbfWGSoK2enaQWMWDZcfr2w6k/LCR485K1vDoEfxswsku/2T/M2+jP
   r7Sb6Wr671IdmGkguFI/7p7lAF9K0POqZcNSVU4//xn0FCWGVgT32p2Tk
   PXShy7PN+K6DfQZoLM32+NWh745nUgI0QpSQSeqmbmCn+49KhYv43Jbnt
   h80YwvZzXUQMtf4smMLpCfq09cRXT+nFTtxwYbtUsrnWPzRB4rnx0gJ8o
   2ACOU/lkX2CBAnEKr38eGOoT55eWlzx3mnZ14iVvsBybkAPQGuh4VOk6t
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="366977002"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="366977002"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 12:07:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="709184493"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="709184493"
Received: from paseron-mobl4.amr.corp.intel.com (HELO desk) ([10.209.17.113])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 12:07:42 -0700
Date:   Thu, 26 Oct 2023 12:07:41 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Nikolay Borisov <nik.borisov@suse.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com
Subject: Re: [PATCH v3 6/6] KVM: VMX: Move VERW closer to VMentry for MDS
 mitigation
Message-ID: <20231026190741.vwpyvp3nvyrlcmsp@desk>
References: <20231025-delay-verw-v3-0-52663677ee35@linux.intel.com>
 <20231025-delay-verw-v3-6-52663677ee35@linux.intel.com>
 <cb8d8ae8-edf6-42a2-8cdc-3bd7b7e0711e@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb8d8ae8-edf6-42a2-8cdc-3bd7b7e0711e@suse.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 26, 2023 at 07:14:18PM +0300, Nikolay Borisov wrote:
> >   	if (static_branch_unlikely(&vmx_l1d_should_flush))
> >   		vmx_l1d_flush(vcpu);
> > -	else if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF))
> > -		mds_clear_cpu_buffers();
> >   	else if (static_branch_unlikely(&mmio_stale_data_clear) &&
> >   		 kvm_arch_has_assigned_device(vcpu->kvm))
> > +		/* MMIO mitigation is mutually exclusive with MDS mitigation later in asm */
> 
> Mutually exclusive implies that you have one or the other but not both,
> whilst I think the right formulation here is redundant? Because if mmio is
> enabled  mds_clear_cpu_buffers() will clear the buffers here  and later
> they'll be cleared again, no ?

No, because when mmio_stale_data_clear is enabled,
X86_FEATURE_CLEAR_CPU_BUF will not be set because of how mitigation is
selected in mmio_select_mitigation():

mmio_select_mitigation()
{
...
         /*
          * Enable CPU buffer clear mitigation for host and VMM if also affected
          * by MDS or TAA. Otherwise, enable mitigation for VMM only.
          */
         if (boot_cpu_has_bug(X86_BUG_MDS) || (boot_cpu_has_bug(X86_BUG_TAA) &&
                                               boot_cpu_has(X86_FEATURE_RTM)))
                 setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
         else
                 static_branch_enable(&mmio_stale_data_clear);

> Alternatively you might augment this check to only execute iff
> X86_FEATURE_CLEAR_CPU_BUF is not set?

It already is like that due to the logic above. That is what the
comment:

	/* MMIO mitigation is mutually exclusive with MDS mitigation later in asm */

... is trying to convey. Suggestions welcome to improve the comment.
