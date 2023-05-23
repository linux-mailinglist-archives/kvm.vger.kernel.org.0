Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF0670D271
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 05:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbjEWDeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 23:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbjEWDeP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 23:34:15 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACAEE5;
        Mon, 22 May 2023 20:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684812851; x=1716348851;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vHwVs4S7JjiFah7OUkcxaesKhl5zkeIvce1HmrmuvLg=;
  b=LrFSPKNIrHfgfWN3RndU6T8l+FAFgwg6CfSLPzF7az7fbPMlhCaRoXSe
   DcmdsFQE6ZYgbP0sxtumC/JlqeBykXAD/1o5D9WM07NaBDqbZTPVNUBRI
   Jre2T8H4Kovan7dhtadKONGqnlsMM5fZgVWe7EitoQbFK6VwWE7yULFcf
   lAQDc0uklFp667/LA+EnryhUg8JohfO+F9pM6PV2PqMpl2OsXweK2IinN
   uqS7kPtiRZOaxdV8Ao+HqtuLqImysqMzwiSzrlqxU2d1Y7wYVc9gaTVUN
   ZhakaA8prX1OiMrycJRuVDzWfRWgtAB87eYPaiFfyykST5WaQC9X3pCQa
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="416580594"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="416580594"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 20:34:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="768812334"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="768812334"
Received: from arkaneta-mobl.amr.corp.intel.com (HELO desk) ([10.212.144.239])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 20:34:08 -0700
Date:   Mon, 22 May 2023 20:34:05 -0700
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
Message-ID: <20230523033405.dr2ci7h3ol5se64o@desk>
References: <20230506030435.80262-1-chao.gao@intel.com>
 <b472b58d-0469-8a55-985c-1d966ce66419@intel.com>
 <ZGZhW/x5OWPmx1qD@google.com>
 <20230520010237.3tepk3q44j52leuk@desk>
 <ZGup1TjeqBF7bgWG@google.com>
 <ff2a97c2-1e8f-4adb-78c2-3cf5037f139f@intel.com>
 <20230522212328.uwyvp3hpwvte6t6g@desk>
 <aa65ec4f-ccf7-a344-692e-61abe9c95b47@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa65ec4f-ccf7-a344-692e-61abe9c95b47@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 23, 2023 at 09:00:50AM +0800, Xiaoyao Li wrote:
> On 5/23/2023 5:23 AM, Pawan Gupta wrote:
> > On Tue, May 23, 2023 at 03:31:44AM +0800, Xiaoyao Li wrote:
> > > On 5/23/2023 1:43 AM, Sean Christopherson wrote:
> > > > > >     6. Performance aside, KVM should not be speculating (ha!) on what the guest
> > > > > >        will and will not do, and should instead honor whatever behavior is presented
> > > > > >        to the guest.  If the guest CPU model indicates that VERW flushes buffers,
> > > > > >        then KVM damn well needs to let VERW flush buffers.
> > > > > The current implementation allows guests to have VERW flush buffers when
> > > > > they enumerate FB_CLEAR. It only restricts the flush behavior when the
> > > > > guest is trying to mitigate against a vulnerability(like MDS) on a
> > > > > hardware that is not affected. I guess its common for guests to be
> > > > > running with older gen configuration on a newer hardware.
> > > > Right, I'm saying that that behavior is wrong.  KVM shouldn't assume the guest
> > > > the guest will do things a certain way and should instead honor the "architectural"
> > > > definition, in quotes because I realize there probably is no architectural
> > > > definition for any of this.
> > > > 
> > > > It might be that the code does (unintentionally?) honor the "architecture", i.e.
> > > > this code might actually be accurrate with respect to when the guest can expect
> > > > VERW to flush buffers.  But the comment is so, so wrong.
> > > 
> > > The comment is wrong and the code is wrong in some case as well.
> > > 
> > > If none of ARCH_CAP_FB_CLEAR, ARCH_CAP_MDS_NO, ARCH_CAP_TAA_NO,
> > > ARCH_CAP_PSDP_NO, ARCH_CAP_FBSDP_NO and ARCH_CAP_SBDR_SSDP_NO are exposed to
> > > VM, the VM is type of "affected by MDS".
> > > 
> > > And accroding to the page https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/processor-mmio-stale-data-vulnerabilities.html
> > > 
> > > if the VM enumerates support for both L1D_FLUSH and MD_CLEAR, it implicitly
> > > enumerates FB_CLEAR as part of their MD_CLEAR support.
> > 
> > This is the excerpt from the link that you mentioned:
> > 
> >    "For processors that are affected by MDS and support L1D_FLUSH
> >    operations and MD_CLEAR operations, the VERW instruction flushes fill
> >    buffers."
> > 
> > You are missing an important information here "For the processors
> > _affected_ by MDS". On such processors ...
> > 
> > > However, the code will leave vmx->disable_fb_clear as 1 if hardware supports
> > > it, and VERW intruction doesn't clear FB in the VM, which conflicts
> > > "architectural" definition.
> > 
> > ... Fill buffer clear is not enabled at all:
> > 
> >    vmx_setup_fb_clear_ctrl()
> >    {
> >    	u64 msr;
> >    	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES) &&
> >    	    !boot_cpu_has_bug(X86_BUG_MDS) &&
> >    	    !boot_cpu_has_bug(X86_BUG_TAA)) {
> >    		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, msr);
> >    		if (msr & ARCH_CAP_FB_CLEAR_CTRL)
> >    			vmx_fb_clear_ctrl_available = true;
> >    	}
> >    }
> 
> This is the check of bare metal, while the check in
> vmx_update_fb_clear_dis() is of guest VM.
> 
> For example, if the hardware (host) enumerates ARCH_CAP_TAA_NO,
> ARCH_CAP_MDS_NO, ARCH_CAP_PSDP_NO, ARCH_CAP_FBSDP_NO, ARCH_CAP_SBDR_SSDP_NO,
> ARCH_CAP_FB_CLEAR, and ARCH_CAP_FB_CLEAR_CTRL, the VERW on this hardware
> clears Fill Buffer (if FB_CLEAR_DIS is not enabled in
> MSR_IA32_MCU_OPT_CTRL). vmx_setup_fb_clear_ctrl() does set
> vmx_fb_clear_ctrl_available  to true.
> 
> If a guest is exposed without ARCH_CAP_TAA_NO, ARCH_CAP_MDS_NO,
> ARCH_CAP_PSDP_NO, ARCH_CAP_FBSDP_NO, ARCH_CAP_SBDR_SSDP_NO and
> ARCH_CAP_FB_CLEAR, vmx_update_fb_clear_dis() will leave
> vmx->disable_fb_clear as true. So VERW doesn't clear Fill Buffer for guest.
> But in the view of guset, it expects VERW to clear Fill Buffer.

That is correct, but whether VERW clears the CPU buffers also depends on
if the hardware is affected or not, enumerating MD_CLEAR solely does not
guarantee that VERW will flush CPU buffers. This was true even before
MMIO Stale Data was discovered.

If host(hardware) enumerates:

	MD_CLEAR | MDS_NO |   VERW behavior
	---------|--------|-------------------
	    1	 |    0	  | Clears CPU buffers

But on an MDS mitigated hardware(MDS_NO=1) if guest enumerates:

	MD_CLEAR | MDS_NO |   VERW behavior
	---------|--------|-----------------------
	    1	 |    0	  | Not guaranteed to clear
	                        CPU buffers

After MMIO Stale Data, FB_CLEAR_DIS was introduced to keep this behavior
intact(for hardware that is not affected by MDS/TAA). If the userspace
truly wants the guest to have VERW flush behavior, it can export
FB_CLEAR.

I see your point that from a guest's perspective it is being lied about
VERW behavior. OTOH, I am not sure if it is a good enough reason for
mitigated hardware to keep the overhead of clearing micro-architectural
buffers for generations of CPUs.
