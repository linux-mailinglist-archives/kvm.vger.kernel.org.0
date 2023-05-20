Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85C6070A424
	for <lists+kvm@lfdr.de>; Sat, 20 May 2023 03:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjETBCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 21:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjETBCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 21:02:42 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C0F1A4;
        Fri, 19 May 2023 18:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684544561; x=1716080561;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YP7JReTPyYFTvm8W8YvbkQJKFNcymHcA+Vrpk4UdMRs=;
  b=jGS2kFCU9iw+zzy1JiO5jVT/hA4ODxRGp58dB1neU9Aj6Ed2nK0pSK9+
   WzAOclYOJy+Z/hq59SIBoFveXQld79AGB7K2bvDPZ5XgH9cLBDT1fNe8y
   3rrVlcWerphomqkmiJ7omth9lVe49VCJhY/qKCrz6IhQ09md+tjdC1JWi
   IUZw66LcP47zp4EWQsVZ/OzuORYXkVpzcg33lWdLwIz0l5V/PQ1FWtuCN
   yqYKdO9wvWCHYo3iv6zCPwHIeT46MuNoEYiXeOSGH0NmrBIsc+dvJlRQG
   wPK3n+5hWsTJ6dfip+C9WH6dNhL5dSjM4m8S6LSl2ZjMJ9dMypfJxY8RO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="355748766"
X-IronPort-AV: E=Sophos;i="6.00,178,1681196400"; 
   d="scan'208";a="355748766"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 18:02:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10715"; a="814906286"
X-IronPort-AV: E=Sophos;i="6.00,178,1681196400"; 
   d="scan'208";a="814906286"
Received: from jasampan-mobl.amr.corp.intel.com (HELO desk) ([10.212.248.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 18:02:39 -0700
Date:   Fri, 19 May 2023 18:02:37 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: x86: Track supported ARCH_CAPABILITIES in kvm_caps
Message-ID: <20230520010237.3tepk3q44j52leuk@desk>
References: <20230506030435.80262-1-chao.gao@intel.com>
 <b472b58d-0469-8a55-985c-1d966ce66419@intel.com>
 <ZGZhW/x5OWPmx1qD@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGZhW/x5OWPmx1qD@google.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 18, 2023 at 10:33:15AM -0700, Sean Christopherson wrote:
> +Jim
> 
> On Thu, May 18, 2023, Xiaoyao Li wrote:
> > On 5/6/2023 11:04 AM, Chao Gao wrote:
> > > to avoid computing the supported value at runtime every time.
> > > 
> > > No functional change intended.
> > 
> > the value of kvm_get_arch_capabilities() can be changed due to
> > 
> > 	if (l1tf_vmx_mitigation != VMENTER_L1D_FLUSH_NEVER)
> > 		data |= ARCH_CAP_SKIP_VMENTRY_L1DFLUSH;
> > 
> > and l1tf_vmx_mitigation can be runtime changed by vmentry_l1d_flush module
> > param.
> 
> Nice catch!
> 
> > We need a detailed analysis that in no real case can
> > ARCH_CAP_SKIP_VMENTRY_L1DFLUSH bit change runtime.
> 
> No, the fact that it _can_ be modified by a writable module param is enough to
> make this patch buggy.
> 
> I do like snapshotting and then updating the value, even though there's likely no
> meaningful performance benefit, as that would provide a place to document that
> the "supported" value is dynamic.  Though the fact that it's dynamic is arguably a bug
> in its own right, e.g. if userspace isn't careful, a VM can have vCPUs with different
> values for ARCH_CAPABILITIES.  But fixing that is probably a fool's errand.  So
> I vote to snapshot the value and toggle the ARCH_CAP_SKIP_VMENTRY_L1DFLUSH bit
> when l1tf_vmx_mitigation is modified.
> 
> On a somewhat related topic, what in the absolute #$#$ is going on with FB_CLEAR_DIS!?!?
> I made the mistake of digging into why KVM doesn't advertise ARCH_CAP_FB_CLEAR_CTRL...
> 
>   1. I see *nothing* in commit 027bbb884be0 ("KVM: x86/speculation: Disable Fill
>      buffer clear within guests") that justifies 1x RDMSR and 2x WRMSR on every
>      entry+exit.

Unnecessary VERWs in guest will have much higher impact than due to MSR
read/write at vmentry/exit. On an Icelake system it is pointless for a
guest to incur VERW penalty when the system is not affected by MDS/TAA and
guests don't need mitigation for MMIO Stale Data. MSR writes are only
done when the guest is likely to execute unnecessary VERWs(e.g. when the
guest thinks its running on an older gen CPU).

>   2. I'm pretty sure conditioning mmio_stale_data_clear on kvm_arch_has_assigned_device()
>      is a bug.  AIUI, the vulnerability applies to _any_ MMIO accesses.

Vulnerability applies to MMIO access to devices that don't respect "byte
enable" (which indicates valid bytes in a transaction), and don't error
on incorrect read or write size.

>      Assigning a device is necessary to let the device DMA into the
>      guest, but it's not necessary to let the guest access MMIO
>      addresses, that's done purely via memslots.

I will get back on this. The guest would typically need access to an
area that doesn't fail an incorrectly sized MMIO.

>   3. Irrespective of whether or not there is a performance benefit, toggling the
>      MSR on every entry+exit is completely unnecessary if KVM won't do VERW before
>      VM-Enter, i.e. if (!mds_user_clear && !mmio_stale_data_clear), then the
>      toggling can be done in vmx_prepare_switch_to_{guest,host}().  This probably
>      isn't worth pursuing though, as #4 below is more likely, especially since
>      X86_BUG_MSBDS_ONLY is limited to Atom (and MIC, lol) CPUs.
>
>   4. If the host will will _never_ do VERW, i.e. #3 + !X86_BUG_MSBDS_ONLY, then

Is it likely that KVM will not do VERW when affected by MMIO Stale Data?
If you mean on a hardware that is not vulnerable to MDS and MMIO Stale
Data, in that case MSR writes are unnecessary and will be skipped
because FB_CLEAR_DIS is not available on unaffected hardware.

>      KVM just needs to context switch the MSR between guests since the value that's
>      loaded while running in the host is irrelevant.  E.g. use a percpu cache to

I will be happy to avoid the MSR read/write, but its worth considering
that this MSR can receive more bits that host may want to toggle, then
percpu cache implementation would likely change.

>      track the current value.
> 
>   5. MSR_IA32_MCU_OPT_CTRL is not modified by the host after a CPU is brought up,
>      i.e. the host's desired value is effectively static post-boot, and barring
>      a buggy configuration (running KVM as a guest), the boot CPU's value will be
>      the same as every other CPU.

Would the MSR value be same on every CPU, if only some guests have
enumerated FB_CLEAR and others haven't? MSR writes (to disable FB_CLEAR)
are not done when a guest enumerates FB_CLEAR. Enumeration of FB_CLEAR
in guest will depend on its configuration.

>   6. Performance aside, KVM should not be speculating (ha!) on what the guest
>      will and will not do, and should instead honor whatever behavior is presented
>      to the guest.  If the guest CPU model indicates that VERW flushes buffers,
>      then KVM damn well needs to let VERW flush buffers.

The current implementation allows guests to have VERW flush buffers when
they enumerate FB_CLEAR. It only restricts the flush behavior when the
guest is trying to mitigate against a vulnerability(like MDS) on a
hardware that is not affected. I guess its common for guests to be
running with older gen configuration on a newer hardware.

>   7. Why on earth did Intel provide a knob that affects both the host and guest,
>      since AFAICT the intent of the MSR is purely to suppress FB clearing for an
>      unsuspecting (or misconfigured?) guest!?!?!

Thats true.
