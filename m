Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD9170CC44
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 23:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbjEVVXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 17:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjEVVXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 17:23:32 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE929D;
        Mon, 22 May 2023 14:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684790611; x=1716326611;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MSCK5/ZmT0Ta9TMdmCSZCIk6yXVnYQVqi0zAmRZLbZM=;
  b=MJdecoNyfUX25Np+PkBiBleiRoPA/gaGDvi5QrP8CBxMnqN5raXe7VrS
   Tu3NkzajGIs34juz51S6BUFWq8h9+8GAHk31D/pPX+XAKS5TkcNbWu2Q5
   MGZW9r8Dobi0ZFVc5HJuATHH908b/O1yztKYJwgzYVCeswUFGnzksu3AH
   +V/lR00Nw3C+YIdFr+u+ceUROj63Prqr5YNf6cUdxmgeFHGNIHwNrFaIE
   1AVbMkVTqZ6AUnDZSR5hV5Den/6cRZyRMcTwXav38V3EBVIMxrATvQFqC
   1J9ScON8CKOZQTFkjMk2ysrx51hggqCByCOPtIfEPZwLTRfylGU0Taks9
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="381285813"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="381285813"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 14:23:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="706693491"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="706693491"
Received: from arkaneta-mobl.amr.corp.intel.com (HELO desk) ([10.212.144.239])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 14:23:30 -0700
Date:   Mon, 22 May 2023 14:23:28 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>
Subject: Re: [PATCH] KVM: x86: Track supported ARCH_CAPABILITIES in kvm_caps
Message-ID: <20230522212328.uwyvp3hpwvte6t6g@desk>
References: <20230506030435.80262-1-chao.gao@intel.com>
 <b472b58d-0469-8a55-985c-1d966ce66419@intel.com>
 <ZGZhW/x5OWPmx1qD@google.com>
 <20230520010237.3tepk3q44j52leuk@desk>
 <ZGup1TjeqBF7bgWG@google.com>
 <ff2a97c2-1e8f-4adb-78c2-3cf5037f139f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff2a97c2-1e8f-4adb-78c2-3cf5037f139f@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 23, 2023 at 03:31:44AM +0800, Xiaoyao Li wrote:
> On 5/23/2023 1:43 AM, Sean Christopherson wrote:
> > > >    6. Performance aside, KVM should not be speculating (ha!) on what the guest
> > > >       will and will not do, and should instead honor whatever behavior is presented
> > > >       to the guest.  If the guest CPU model indicates that VERW flushes buffers,
> > > >       then KVM damn well needs to let VERW flush buffers.
> > > The current implementation allows guests to have VERW flush buffers when
> > > they enumerate FB_CLEAR. It only restricts the flush behavior when the
> > > guest is trying to mitigate against a vulnerability(like MDS) on a
> > > hardware that is not affected. I guess its common for guests to be
> > > running with older gen configuration on a newer hardware.
> > Right, I'm saying that that behavior is wrong.  KVM shouldn't assume the guest
> > the guest will do things a certain way and should instead honor the "architectural"
> > definition, in quotes because I realize there probably is no architectural
> > definition for any of this.
> > 
> > It might be that the code does (unintentionally?) honor the "architecture", i.e.
> > this code might actually be accurrate with respect to when the guest can expect
> > VERW to flush buffers.  But the comment is so, so wrong.
> 
> The comment is wrong and the code is wrong in some case as well.
> 
> If none of ARCH_CAP_FB_CLEAR, ARCH_CAP_MDS_NO, ARCH_CAP_TAA_NO,
> ARCH_CAP_PSDP_NO, ARCH_CAP_FBSDP_NO and ARCH_CAP_SBDR_SSDP_NO are exposed to
> VM, the VM is type of "affected by MDS".
> 
> And accroding to the page https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/processor-mmio-stale-data-vulnerabilities.html
> 
> if the VM enumerates support for both L1D_FLUSH and MD_CLEAR, it implicitly
> enumerates FB_CLEAR as part of their MD_CLEAR support.

This is the excerpt from the link that you mentioned:

  "For processors that are affected by MDS and support L1D_FLUSH
  operations and MD_CLEAR operations, the VERW instruction flushes fill
  buffers."

You are missing an important information here "For the processors
_affected_ by MDS". On such processors ...

> However, the code will leave vmx->disable_fb_clear as 1 if hardware supports
> it, and VERW intruction doesn't clear FB in the VM, which conflicts
> "architectural" definition.

... Fill buffer clear is not enabled at all:

  vmx_setup_fb_clear_ctrl()
  {
  	u64 msr;
  
  	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES) &&
  	    !boot_cpu_has_bug(X86_BUG_MDS) &&
  	    !boot_cpu_has_bug(X86_BUG_TAA)) {
  		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, msr);
  		if (msr & ARCH_CAP_FB_CLEAR_CTRL)
  			vmx_fb_clear_ctrl_available = true;
  	}
  }
