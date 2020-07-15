Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C512217B9
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 00:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgGOWWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 18:22:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:26585 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726356AbgGOWWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 18:22:48 -0400
IronPort-SDR: 4qjusR9XZc2bonGbPSxd7GO7OphSJebHX3Wv6We2zcR1gQzRLr6LfAL+A4AfbSEN9ulOuUx7iQ
 WXbGwjLyzO4w==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="150668678"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="150668678"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 15:22:47 -0700
IronPort-SDR: yr9CiLl5Ckrxm4euE8qLp1tV/RLZORTEXOZT6yO/FV1G2cAxvZ5spp3ETmst5h/vx9/44KbLyc
 F64GMCQQzqow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="316847391"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga008.jf.intel.com with ESMTP; 15 Jul 2020 15:22:47 -0700
Date:   Wed, 15 Jul 2020 15:22:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Karl Heubaum <karl.heubaum@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] nVMX: Restore active host RIP/CR4
 after test_host_addr_size()
Message-ID: <20200715222247.GE12349@linux.intel.com>
References: <20200714002355.538-1-sean.j.christopherson@intel.com>
 <20200714002355.538-2-sean.j.christopherson@intel.com>
 <378edd35-38eb-1d62-8471-f111c17afee7@oracle.com>
 <20200715184810.GC12349@linux.intel.com>
 <c00836d0-45bb-3d50-5082-6670c1c5e2a9@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c00836d0-45bb-3d50-5082-6670c1c5e2a9@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 15, 2020 at 02:34:23PM -0700, Krish Sadhukhan wrote:
> 
> On 7/15/20 11:48 AM, Sean Christopherson wrote:
> >On Wed, Jul 15, 2020 at 11:34:46AM -0700, Krish Sadhukhan wrote:
> >>On 7/13/20 5:23 PM, Sean Christopherson wrote:
> >>>Perform one last VMX transition to actually load the host's RIP and CR4
> >>>at the end of test_host_addr_size().  Simply writing the VMCS doesn't
> >>>restore the values in hardware, e.g. as is, CR4.PCIDE can be left set,
> >>>which causes spectacularly confusing explosions when other misguided
> >>>tests assume setting bit 63 in CR3 will cause a non-canonical #GP.
> >>>
> >>>Fixes: 0786c0316ac05 ("kvm-unit-test: nVMX: Check Host Address Space Size on vmentry of nested guests")
> >>>Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> >>>Cc: Karl Heubaum <karl.heubaum@oracle.com>
> >>>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >>>---
> >>>  x86/vmx_tests.c | 5 +++++
> >>>  1 file changed, 5 insertions(+)
> >>>
> >>>diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> >>>index 29f3d0e..cb42a2d 100644
> >>>--- a/x86/vmx_tests.c
> >>>+++ b/x86/vmx_tests.c
> >>>@@ -7673,6 +7673,11 @@ static void test_host_addr_size(void)
> >>>  		vmcs_write(ENT_CONTROLS, entry_ctrl_saved | ENT_GUEST_64);
> >>>  		vmcs_write(HOST_RIP, rip_saved);
> >>>  		vmcs_write(HOST_CR4, cr4_saved);
> >>>+
> >>>+		/* Restore host's active RIP and CR4 values. */
> >>>+		report_prefix_pushf("restore host state");
> >>>+		test_vmx_vmlaunch(0);
> >>>+		report_prefix_pop();
> >>>  	}
> >>>  }
> >>Just for my understanding.  When you say, "other misguided tests", which
> >>tests are you referring to ?  In the current sequence of tests in
> >>vmx_host_state_area_test(), test_load_host_perf_global_ctrl() is the  one
> >>that follows and it runs fine.
> >See test_mtf_guest() in patch 2/2.  https://patchwork.kernel.org/patch/11661189/
> 
> I ran the two tests as follows but couldn't reproduce it:
> 
>     ./x86/run x86/vmx.flat  -smp 1 -cpu host,+vmx -append
> "vmx_host_state_area_test vmx_mtf_test"
> 
> 
> How did you run the them ?

I ran the VMX testcase from x86/unittest.cfg (below) on HSW.  I eventually
narrowed it down to just test_host_addr_size() and the MTF test.  Note, the
failure signature will change depending on whether vmx_cr_load_test() is
run between those two.  If it's not run, the failure is a straightforward
triple fault.  If it is run, for me the failure morphed into a an emulation
error because the unit test was able to generate a valid translation out of
CR3=0 and hit a non-existent memslot, which was all kinds of confusing.

./x86/run x86/vmx.flat -smp 1 -cpu host,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test"
