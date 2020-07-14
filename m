Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C3121FD42
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 21:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgGNTXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 15:23:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:9953 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727930AbgGNTXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 15:23:51 -0400
IronPort-SDR: kWL5vu8lEG7WbOubWKGL/AZAtgk69fWGkm5J/r8kIHlbETWF6vuzdAM2f9cugRn5M62Fv6l55R
 7X235GhGpYAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="147022483"
X-IronPort-AV: E=Sophos;i="5.75,352,1589266800"; 
   d="scan'208";a="147022483"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 12:23:51 -0700
IronPort-SDR: PCMjJ49O7HM1ZDukmb0/xSV3g6OqD7Hs4Q4nkyKXVCpxH8AQYuOK6cDIyzUqcC1dWE+GGzGVQL
 DKKPOK90aDlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,352,1589266800"; 
   d="scan'208";a="285859255"
Received: from guptapadev.jf.intel.com (HELO guptapadev.amr) ([10.54.74.188])
  by orsmga006.jf.intel.com with ESMTP; 14 Jul 2020 12:23:51 -0700
Date:   Tue, 14 Jul 2020 12:17:59 -0700
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
Message-ID: <20200714191759.GA7116@guptapadev.amr>
References: <267631f4db4fd7e9f7ca789c2efaeab44103f68e.1594689154.git.pawan.kumar.gupta@linux.intel.com>
 <20200714014540.GH29725@linux.intel.com>
 <099d6985-9e9f-1d9f-7098-58a9e26e4450@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <099d6985-9e9f-1d9f-7098-58a9e26e4450@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 07:57:53AM -0700, Dave Hansen wrote:
> Let's stick to things which are at least static per reboot.  Checking
> for X86_FEATURE_VMX or even CONFIG_KVM_INTEL seems like a good stopping
> point.  "Could this kernel run a naughty guest?"  If so, report
> "Vulnerable".  It's the same as Meltdown: "Could this kernel run
> untrusted code?"  If so, report "Vulnerable".

Thanks, These are good inputs. So what I need to add is a boot time
check for VMX feature and report "Vulnerable" or "Not
affected(VMX disabled)".

Are you suggesting to not change the reporting when KVM deploys the
"Split huge pages" mitigation? Is this because VMX can still be used by
other VMMs?

The current mitigation reporting is very specific to KVM:

	- "KVM: Vulnerable"
	- "KVM: Mitigation: Split huge pages"

As the kernel doesn't know about the mitigation state of out-of-tree
VMMs can we add VMX reporting to always say vulnerable when VMX is
enabled:

	- "VMX: Vulnerable, KVM: Vulnerable"
	- "VMX: Vulnerable, KVM: Mitigation: Split huge pages"

And if VMX is disabled report:

	- "VMX: Not affected(VMX disabled)"

or something like that.

Thanks,
Pawan
