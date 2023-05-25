Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9B7711831
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 22:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241572AbjEYUeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 16:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233627AbjEYUeN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 16:34:13 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B66183;
        Thu, 25 May 2023 13:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685046840; x=1716582840;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XbEsnh0XvQPwp+NdV4jyUUSR/Afa5HTpPVjC2uDu5rA=;
  b=KKMGMAuiYHNQOHk6dDNomLlA1Jc8MAMN9/B+wOKjbHNtquSZbdIiZMTp
   Y6dKLS4Rbf+EIxRj8WkoPEAkLuFbEwVeX96PS/OIjnwp6Xs4N5Fxp2i9b
   /5FMFIYXQdNp6lWs3kueO6zIDpDqK7350eF0Xr4Of+NPVGXs8jN7rTXOr
   tKTuOpT1LsHyeoIHNkDvKfsTuAfVoDe+IKsynZ6AU2PrUIY6rqazLBYHc
   /b5dLcdOVj3QmBbWpcJfKj0gJFpkkLsYm8O4i6Huhljd5OplgqhqC98aD
   FY1l/Cif9fFzLwZHVq151PdTFUA1CA1SYk2KSxe5dYG2+NLglL/DrZ5+p
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="357270220"
X-IronPort-AV: E=Sophos;i="6.00,192,1681196400"; 
   d="scan'208";a="357270220"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 13:33:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="735718948"
X-IronPort-AV: E=Sophos;i="6.00,192,1681196400"; 
   d="scan'208";a="735718948"
Received: from favinash-mobl.amr.corp.intel.com (HELO desk) ([10.212.225.104])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 13:33:59 -0700
Date:   Thu, 25 May 2023 13:33:58 -0700
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
Message-ID: <20230525203358.mm7sb4a2iodgfhwo@desk>
References: <20230506030435.80262-1-chao.gao@intel.com>
 <b472b58d-0469-8a55-985c-1d966ce66419@intel.com>
 <ZGZhW/x5OWPmx1qD@google.com>
 <20230520010237.3tepk3q44j52leuk@desk>
 <ZGup1TjeqBF7bgWG@google.com>
 <ff2a97c2-1e8f-4adb-78c2-3cf5037f139f@intel.com>
 <20230522212328.uwyvp3hpwvte6t6g@desk>
 <aa65ec4f-ccf7-a344-692e-61abe9c95b47@intel.com>
 <20230523033405.dr2ci7h3ol5se64o@desk>
 <76c17c65-870b-d291-d223-6452e56d153a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76c17c65-870b-d291-d223-6452e56d153a@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 25, 2023 at 11:42:24PM +0800, Xiaoyao Li wrote:
> On 5/23/2023 11:34 AM, Pawan Gupta wrote:
> > > If a guest is exposed without ARCH_CAP_TAA_NO, ARCH_CAP_MDS_NO,
> > > ARCH_CAP_PSDP_NO, ARCH_CAP_FBSDP_NO, ARCH_CAP_SBDR_SSDP_NO and
> > > ARCH_CAP_FB_CLEAR, vmx_update_fb_clear_dis() will leave
> > > vmx->disable_fb_clear as true. So VERW doesn't clear Fill Buffer for guest.
> > > But in the view of guset, it expects VERW to clear Fill Buffer.
> > 
> > That is correct, but whether VERW clears the CPU buffers also depends on
> > if the hardware is affected or not, enumerating MD_CLEAR solely does not
> > guarantee that VERW will flush CPU buffers. This was true even before
> > MMIO Stale Data was discovered.
> > 
> > If host(hardware) enumerates:
> > 
> > 	MD_CLEAR | MDS_NO |   VERW behavior
> > 	---------|--------|-------------------
> > 	    1	 |    0	  | Clears CPU buffers
> > 
> > But on an MDS mitigated hardware(MDS_NO=1) if guest enumerates:
> > 
> > 	MD_CLEAR | MDS_NO |   VERW behavior
> > 	---------|--------|-----------------------
> > 	    1	 |    0	  | Not guaranteed to clear
> > 	                        CPU buffers
> > 
> > After MMIO Stale Data, FB_CLEAR_DIS was introduced to keep this behavior
> > intact(for hardware that is not affected by MDS/TAA).
> 
> Sorry, I don't understand it. What the behavior is?

That on a mitigated hardware VERW may not clear the micro-architectural
buffers.

There are many micro-architectural buffers, VERW only clears the
affected ones. This is indicated in section "Fill Buffer Clearing
Operations" of [1].

  Some processors may enumerate MD_CLEAR because they overwrite all
  buffers affected by MDS/TAA, but they do not overwrite fill buffer
  values. This is because fill buffers are not susceptible to MDS or TAA
  on those processors.

  For processors affected by FBSDP where MD_CLEAR may not overwrite fill
  buffer values, Intel has released microcode updates that enumerate
  FB_CLEAR so that VERW does overwrite fill buffer values.

> > If the userspace
> > truly wants the guest to have VERW flush behavior, it can export
> > FB_CLEAR.
> >
> > I see your point that from a guest's perspective it is being lied about
> > VERW behavior. OTOH, I am not sure if it is a good enough reason for
> > mitigated hardware to keep the overhead of clearing micro-architectural
> > buffers for generations of CPUs.
> 
> User takes the responsiblity because itself requests the specific feature
> combination for its guest.

As I understand, the MD_CLEAR enumeration on mitigated hardware is done
purely for VM migration compatibility. Software is not expected to use
VERW on mitigated hardware, below is from MDS documentation [2]:

  Future processors set the MDS_NO bit in IA32_ARCH_CAPABILITIES to
  indicate they are not affected by microarchitectural data sampling.
  Such processors will continue to enumerate the MD_CLEAR bit in CPUID.
  As none of these data buffers are vulnerable to exposure on such
  parts, no data buffer overwriting is required or expected for such
  parts, despite the MD_CLEAR indication. Software should look to the
  MDS_NO bit to determine whether buffer overwriting mitigations are
  required.

[1] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/processor-mmio-stale-data-vulnerabilities.html

[2] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/resources/processors-affected-mds.html
