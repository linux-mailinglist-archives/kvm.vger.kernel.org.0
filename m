Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E252322017F
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 02:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgGOAvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 20:51:32 -0400
Received: from mga17.intel.com ([192.55.52.151]:64198 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbgGOAvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 20:51:32 -0400
IronPort-SDR: HVlwtCL7MGIt67/iZAqzhv1z6RBt0gQmlH++jzugDgJAO3/hYkJIi41KIwyuoWgFp1mCuzii+E
 KS85+eNkfuHw==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="129143297"
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="129143297"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 17:51:31 -0700
IronPort-SDR: tZVuTxoxURNmLUGrV7HsCtXOT6Rvob3NShDSo/T/sjerUQA38u1yg9gE0BUuA9hlrv5+qEKEgi
 sZlkEU4jhzzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="268801804"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 14 Jul 2020 17:51:30 -0700
Date:   Tue, 14 Jul 2020 17:51:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>,
        "Gomez Iglesias, Antonio" <antonio.gomez.iglesias@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Anthony Steinhauser <asteinhauser@google.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Mark Gross <mgross@linux.intel.com>,
        Waiman Long <longman@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] x86/bugs/multihit: Fix mitigation reporting when KVM is
 not in use
Message-ID: <20200715005130.GE14404@linux.intel.com>
References: <267631f4db4fd7e9f7ca789c2efaeab44103f68e.1594689154.git.pawan.kumar.gupta@linux.intel.com>
 <20200714014540.GH29725@linux.intel.com>
 <099d6985-9e9f-1d9f-7098-58a9e26e4450@intel.com>
 <20200714191759.GA7116@guptapadev.amr>
 <ba442a51-294e-8624-9a69-5613ff050551@intel.com>
 <20200714210442.GA10488@guptapadev.amr>
 <e12cd3b8-7df1-94e8-e603-39e00648c026@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e12cd3b8-7df1-94e8-e603-39e00648c026@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 02:20:59PM -0700, Dave Hansen wrote:
> On 7/14/20 2:04 PM, Pawan Gupta wrote:
> >> I see three inputs and four possible states (sorry for the ugly table,
> >> it was this or a spreadsheet :):
> >>
> >> X86_FEATURE_VMX	CONFIG_KVM_*	hpage split  Result	   Reason
> >> 	N			x	    x	     Not Affected  No VMX
> >> 	Y			N	    x	     Not affected  No KVM

This line item is pointless, the relevant itlb_multihit_show_state()
implementation depends on CONFIG_KVM_INTEL.  The !KVM_INTEL version simply
prints ""Processor vulnerable".

> >> 	Y			Y	    Y	     Mitigated	   hpage split
> >> 	Y			Y	    N	     Vulnerable
> > Thank you.
> > 
> > Just a note... for the last 2 cases kernel wont know about "hpage split"
> > mitigation until KVM is loaded. So for these cases reporting at boot
> > will be "Vulnerable" and would change to "Mitigated" once KVM is loaded
> > and deploys the mitigation. This is the current behavior.
> 
> That's OK with me, because it's actually pretty closely tied to reality.
>  You are literally "vulnerable" until you've committed to a mitigation
> and that doesn't happen until KVM is loaded.

Not that it really matters since itlb_multihit_show_state() reflects current
state, but loading KVM doesn't commit to a mitigation.  KVM's nx_huge_pages
module param is writable by root, e.g. the mitigation can be turned off
while KVM is loaded and even while guests are running.

To do the above table, KVM will also need to update itlb_multihit_kvm_mitigation
when it is unloaded, which seems rather silly.  That's partly why I suggested
keying off CR4.VMXE as it doesn't require poking directly into KVM.  E.g. the
entire fix becomes:

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index ed54b3b21c39..4452df7f332d 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1447,7 +1447,12 @@ static ssize_t l1tf_show_state(char *buf)

 static ssize_t itlb_multihit_show_state(char *buf)
 {
-       if (itlb_multihit_kvm_mitigation)
+       if (!boot_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
+           !boot_cpu_has(X86_FEATURE_VMX))
+               return sprintf(buf, "KVM: Mitigation: VMX unsupported\n");
+       else if (!(cr4_read_shadow() & X86_CR4_VMXE))
+               return sprintf(buf, "KVM: Mitigation: VMX disabled\n");
+       else if (itlb_multihit_kvm_mitigation)
                return sprintf(buf, "KVM: Mitigation: Split huge pages\n");
        else
                return sprintf(buf, "KVM: Vulnerable\n");
