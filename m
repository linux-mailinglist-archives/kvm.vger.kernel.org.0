Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB26470D2F6
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 06:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbjEWEtY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 00:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234826AbjEWEst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 00:48:49 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD43C18B;
        Mon, 22 May 2023 21:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684817307; x=1716353307;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sFdBUsSJtxlXldo4kXpHA6RwoU8+rIxaTMXMzmlGVxs=;
  b=W4uoX0W8n9SrAQs2F4R46FFgJEdOkOzI+KFJFxzGBfkhuUpZuK+yPetx
   HHF7VcFnFI32gX/x+bY+weJuOjGAoC/cOeQ5c3CTJDPQwBd5lvaVrqMm+
   VMu2ZxLyDk+AtWp5LShQsUTrtv9Uo+9MjbnSLa4VuShPp5xnyB3qySF4O
   MtHz0ak8bLDakWHlKTfGEcqj3eB7Nd8ccVr5Ldjy95B/LPom+vRAjWI6k
   3oS92V3/NBwIhzbFi3f7hYHo9+58NeB0dkzvWWMj6I4+DSSt8k6MwRK6v
   3rUS5HDQwgagjZmkA1J6f45JZTN6fS0BQObNEL3PbAnb43q7a7eRCU58r
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="353153973"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="353153973"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 21:47:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="950392617"
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="950392617"
Received: from arkaneta-mobl.amr.corp.intel.com (HELO desk) ([10.212.144.239])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 21:47:34 -0700
Date:   Mon, 22 May 2023 21:47:31 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        asit.k.mallick@intel.com
Subject: Re: [PATCH] KVM: x86: Track supported ARCH_CAPABILITIES in kvm_caps
Message-ID: <20230523044731.obkyesjyhwercj2q@desk>
References: <20230506030435.80262-1-chao.gao@intel.com>
 <b472b58d-0469-8a55-985c-1d966ce66419@intel.com>
 <ZGZhW/x5OWPmx1qD@google.com>
 <20230520010237.3tepk3q44j52leuk@desk>
 <ZGup1TjeqBF7bgWG@google.com>
 <20230522205453.kqhvk5aheye22hfa@desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522205453.kqhvk5aheye22hfa@desk>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 22, 2023 at 01:54:55PM -0700, Pawan Gupta wrote:
> On Mon, May 22, 2023 at 10:43:49AM -0700, Sean Christopherson wrote:
> > On Fri, May 19, 2023, Pawan Gupta wrote:
> > > On Thu, May 18, 2023 at 10:33:15AM -0700, Sean Christopherson wrote:
> > > > I made the mistake of digging into why KVM doesn't advertise ARCH_CAP_FB_CLEAR_CTRL...
> > > > 
> > > >   1. I see *nothing* in commit 027bbb884be0 ("KVM: x86/speculation: Disable Fill
> > > >      buffer clear within guests") that justifies 1x RDMSR and 2x WRMSR on every
> > > >      entry+exit.
> > > 
> > > Unnecessary VERWs in guest will have much higher impact than due to MSR
> > > read/write at vmentry/exit.
> > 
> > Can you provide numbers for something closeish to a real world workload?
> 
> I am collecting the numbers, will update here soon.

Looks like avoiding VERW flush behavior in guest results in 2-5%
improvement in performance.

Pybench and CPU bound sysbench test shows minor improvement when
avoiding reading/writing MSR_MCU_OPT_CTRL at VMentry/VMexit.

Baseline : v6.4-rc3
Target   : v6.4-rc3 + No read/write to MSR_MCU_OPT_CTRL at VMentry/VMexit

| Test      | Configuration | Relative |
| --------- | ------------- | -------- |
| nginx     | 200           | 0.977    |
| hackbench | 8 - Process   | 0.975    |
| sysbench  | RAM / Memory  | 0.946    |
| sysbench  | CPU           | 1.002    |
| pybench   | T.F.A.T.T     | 1.007    |

Host configuration (Icelake server):
  CPU family:                      6
  Model:                           106
  Stepping:                        6
  Vulnerability Itlb multihit:     Not affected
  Vulnerability L1tf:              Not affected
  Vulnerability Mds:               Not affected
  Vulnerability Meltdown:          Not affected
  Vulnerability Mmio stale data:   Mitigation; Clear CPU buffers; SMT vulnerable
  Vulnerability Retbleed:          Not affected
  Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass disabled via prctl
  Vulnerability Spectre v1:        Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  Vulnerability Spectre v2:        Vulnerable: eIBRS with unprivileged eBPF
  Vulnerability Srbds:             Not affected
  Vulnerability Tsx async abort:   Not affected


Guest configuration (Skylake Client):
  CPU family:			  6
  Model:			  94
  Stepping:			  3
  Vulnerabilities:
    Itlb multihit:         KVM: Mitigation: VMX unsupported
    L1tf:                  Mitigation; PTE Inversion
    Mds:                   Vulnerable: Clear CPU buffers attempted, no microcode;
                           SMT Host state unknown
    Meltdown:              Mitigation; PTI
    Mmio stale data:       Vulnerable: Clear CPU buffers attempted, no microcode;
                           SMT Host state unknown
    Retbleed:              Vulnerable
    Spec store bypass:     Vulnerable
    Spectre v1:            Mitigation; usercopy/swapgs barriers and __user pointer
                            sanitization
    Spectre v2:            Mitigation; Retpolines, STIBP disabled, RSB filling, PB
                           RSB-eIBRS Not affected
    Srbds:                 Unknown: Dependent on hypervisor status
    Tsx async abort:       Vulnerable: Clear CPU buffers attempted, no microcode;
                           SMT Host state unknown
