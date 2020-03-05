Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8BC517AA71
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 17:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgCEQXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 11:23:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:44356 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgCEQXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 11:23:13 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Mar 2020 08:23:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,518,1574150400"; 
   d="scan'208";a="264022562"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 05 Mar 2020 08:23:11 -0800
Date:   Thu, 5 Mar 2020 08:23:11 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com,
        peterz@infradead.org, fenghua.yu@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/8] x86/split_lock: Ensure
 X86_FEATURE_SPLIT_LOCK_DETECT means the existence of feature
Message-ID: <20200305162311.GG11500@linux.intel.com>
References: <20200206070412.17400-1-xiaoyao.li@intel.com>
 <20200206070412.17400-3-xiaoyao.li@intel.com>
 <20200303185524.GQ1439@linux.intel.com>
 <20200303194134.GW1439@linux.intel.com>
 <ab2a83e1-8ae4-b471-1968-7f6baaac602e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab2a83e1-8ae4-b471-1968-7f6baaac602e@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 04, 2020 at 09:49:14AM +0800, Xiaoyao Li wrote:
> On 3/4/2020 3:41 AM, Sean Christopherson wrote:
> >On Tue, Mar 03, 2020 at 10:55:24AM -0800, Sean Christopherson wrote:
> >>On Thu, Feb 06, 2020 at 03:04:06PM +0800, Xiaoyao Li wrote:
> >>>When flag X86_FEATURE_SPLIT_LOCK_DETECT is set, it should ensure the
> >>>existence of MSR_TEST_CTRL and MSR_TEST_CTRL.SPLIT_LOCK_DETECT bit.
> >>
> >>The changelog confused me a bit.  "When flag X86_FEATURE_SPLIT_LOCK_DETECT
> >>is set" makes it sound like the logic is being applied after the feature
> >>bit is set.  Maybe something like:
> >>
> >>```
> >>Verify MSR_TEST_CTRL.SPLIT_LOCK_DETECT can be toggled via WRMSR prior to
> >>setting the SPLIT_LOCK_DETECT feature bit so that runtime consumers,
> >>e.g. KVM, don't need to worry about WRMSR failure.
> >>```
> >>
> >>>Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> >>>---
> >>>  arch/x86/kernel/cpu/intel.c | 41 +++++++++++++++++++++----------------
> >>>  1 file changed, 23 insertions(+), 18 deletions(-)
> >>>
> >>>diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> >>>index 2b3874a96bd4..49535ed81c22 100644
> >>>--- a/arch/x86/kernel/cpu/intel.c
> >>>+++ b/arch/x86/kernel/cpu/intel.c
> >>>@@ -702,7 +702,8 @@ static void init_intel(struct cpuinfo_x86 *c)
> >>>  	if (tsx_ctrl_state == TSX_CTRL_DISABLE)
> >>>  		tsx_disable();
> >>>-	split_lock_init();
> >>>+	if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
> >>>+		split_lock_init();
> >>>  }
> >>>  #ifdef CONFIG_X86_32
> >>>@@ -986,9 +987,26 @@ static inline bool match_option(const char *arg, int arglen, const char *opt)
> >>>  static void __init split_lock_setup(void)
> >>>  {
> >>>+	u64 test_ctrl_val;
> >>>  	char arg[20];
> >>>  	int i, ret;
> >>>+	/*
> >>>+	 * Use the "safe" versions of rdmsr/wrmsr here to ensure MSR_TEST_CTRL
> >>>+	 * and MSR_TEST_CTRL.SPLIT_LOCK_DETECT bit do exist. Because there may
> >>>+	 * be glitches in virtualization that leave a guest with an incorrect
> >>>+	 * view of real h/w capabilities.
> >>>+	 */
> >>>+	if (rdmsrl_safe(MSR_TEST_CTRL, &test_ctrl_val))
> >>>+		return;
> >>>+
> >>>+	if (wrmsrl_safe(MSR_TEST_CTRL,
> >>>+			test_ctrl_val | MSR_TEST_CTRL_SPLIT_LOCK_DETECT))
> >>>+		return;
> >>>+
> >>>+	if (wrmsrl_safe(MSR_TEST_CTRL, test_ctrl_val))
> >>>+		return;a
> >>
> >>Probing the MSR should be skipped if SLD is disabled in sld_options, i.e.
> >>move this code (and setup_force_cpu_cap() etc...) down below the
> >>match_option() logic.  The above would temporarily enable SLD even if the
> >>admin has explicitly disabled it, e.g. makes the kernel param useless for
> >>turning off the feature due to bugs.
> >
> >Hmm, but this prevents KVM from exposing SLD to a guest when it's off in
> >the kernel, which would be a useful debug/testing scenario.
> >
> >Maybe add another SLD state to forcefully disable SLD?  That way the admin
> >can turn of SLD in the host kernel but still allow KVM to expose it to its
> >guests.  E.g.
> 
> I don't think we need do this.
> 
> IMO, this a the bug of split_lock_init(), which assume the initial value of
> MSR_TEST_CTRL is zero, at least bit SPLIT_LOCK of which is zero.
> This is problem, it's possible that BIOS has set this bit.

Hmm, yeah, that's a bug.  But it's a separate bug.
 
> split_lock_setup() here, is to check if the feature really exists. So
> probing MSR_TEST_CTRL and bit MSR_TEST_CTRL_SPLIT_LOCK_DETECT here. If there
> all exist, setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT) to indicate
> feature does exist.
> Only when feature exists, there is a need to parse the command line config
> of split_lock_detect.

Toggling SPLIT_LOCK before checking the kernel param is bad behavior, e.g.
if someone has broken silicon that causes explosions if SPLIT_LOCK=1.  The
behavior is especially bad because cpu_set_core_cap_bits() enumerates split
lock detection using FMS, i.e. clearcpuid to kill CORE_CAPABILITIES
wouldn't work either.
