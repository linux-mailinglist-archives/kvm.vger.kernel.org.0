Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D81721FFAF
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 23:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgGNVKm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 17:10:42 -0400
Received: from mga18.intel.com ([134.134.136.126]:65232 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgGNVKm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 17:10:42 -0400
IronPort-SDR: 6+s5bw4acGe2g7m+sK+NOJt3pf2ba2KvZwJEV+Eo+yf1P2P9vC7GeBE88It1S6OJ6baFctxNHX
 nCST0cCqfniA==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="136484542"
X-IronPort-AV: E=Sophos;i="5.75,352,1589266800"; 
   d="scan'208";a="136484542"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 14:10:37 -0700
IronPort-SDR: mRkXTVY8FE9FnwRg6IsgUfaEkC8DpaHNd/BqpxFkylEOZPR+MChTgPVgZnEjcYDnaI8aFQ4di4
 gSW6y8eJWUvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,352,1589266800"; 
   d="scan'208";a="390597299"
Received: from guptapadev.jf.intel.com (HELO guptapadev.amr) ([10.54.74.188])
  by fmsmga001.fm.intel.com with ESMTP; 14 Jul 2020 14:10:34 -0700
Date:   Tue, 14 Jul 2020 14:04:42 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
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
Message-ID: <20200714210442.GA10488@guptapadev.amr>
References: <267631f4db4fd7e9f7ca789c2efaeab44103f68e.1594689154.git.pawan.kumar.gupta@linux.intel.com>
 <20200714014540.GH29725@linux.intel.com>
 <099d6985-9e9f-1d9f-7098-58a9e26e4450@intel.com>
 <20200714191759.GA7116@guptapadev.amr>
 <ba442a51-294e-8624-9a69-5613ff050551@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba442a51-294e-8624-9a69-5613ff050551@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 12:54:26PM -0700, Dave Hansen wrote:
> On 7/14/20 12:17 PM, Pawan Gupta wrote:
> > On Tue, Jul 14, 2020 at 07:57:53AM -0700, Dave Hansen wrote:
> >> Let's stick to things which are at least static per reboot.  Checking
> >> for X86_FEATURE_VMX or even CONFIG_KVM_INTEL seems like a good stopping
> >> point.  "Could this kernel run a naughty guest?"  If so, report
> >> "Vulnerable".  It's the same as Meltdown: "Could this kernel run
> >> untrusted code?"  If so, report "Vulnerable".
> > 
> > Thanks, These are good inputs. So what I need to add is a boot time
> > check for VMX feature and report "Vulnerable" or "Not
> > affected(VMX disabled)".
> > 
> > Are you suggesting to not change the reporting when KVM deploys the
> > "Split huge pages" mitigation? Is this because VMX can still be used by
> > other VMMs?
> > 
> > The current mitigation reporting is very specific to KVM:
> > 
> > 	- "KVM: Vulnerable"
> > 	- "KVM: Mitigation: Split huge pages"
> > 
> > As the kernel doesn't know about the mitigation state of out-of-tree
> > VMMs can we add VMX reporting to always say vulnerable when VMX is
> > enabled:
> > 
> > 	- "VMX: Vulnerable, KVM: Vulnerable"
> > 	- "VMX: Vulnerable, KVM: Mitigation: Split huge pages"
> > 
> > And if VMX is disabled report:
> > 
> > 	- "VMX: Not affected(VMX disabled)"
> 
> I see three inputs and four possible states (sorry for the ugly table,
> it was this or a spreadsheet :):
> 
> X86_FEATURE_VMX	CONFIG_KVM_*	hpage split  Result	   Reason
> 	N			x	    x	     Not Affected  No VMX
> 	Y			N	    x	     Not affected  No KVM
> 	Y			Y	    Y	     Mitigated	   hpage split
> 	Y			Y	    N	     Vulnerable

Thank you.

Just a note... for the last 2 cases kernel wont know about "hpage split"
mitigation until KVM is loaded. So for these cases reporting at boot
will be "Vulnerable" and would change to "Mitigated" once KVM is loaded
and deploys the mitigation. This is the current behavior.

Thanks,
Pawan
