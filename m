Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAE3221374
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 19:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgGORYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 13:24:15 -0400
Received: from mga05.intel.com ([192.55.52.43]:14801 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgGORYP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 13:24:15 -0400
IronPort-SDR: XfrtuW+XMvx9W7vz/obGzoORxpRIsckwEytAbNVy2VqzhU23Qa72dRnQb4GgoVM6dQZWF9aTwf
 CUJY/8Nc6nfg==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="234077841"
X-IronPort-AV: E=Sophos;i="5.75,355,1589266800"; 
   d="scan'208";a="234077841"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 10:24:13 -0700
IronPort-SDR: wsqayxnu2iV0RqIZ80mnY9a5n9quVCaoiOsHLNX9f8O9A+jvW/8ILDlG6gvYuLyd3EgAfM7oBR
 rHVA/jAbsmLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,355,1589266800"; 
   d="scan'208";a="430204423"
Received: from guptapadev.jf.intel.com (HELO guptapadev.amr) ([10.54.74.188])
  by orsmga004.jf.intel.com with ESMTP; 15 Jul 2020 10:24:13 -0700
Date:   Wed, 15 Jul 2020 10:18:20 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
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
Message-ID: <20200715171820.GA12379@guptapadev.amr>
References: <267631f4db4fd7e9f7ca789c2efaeab44103f68e.1594689154.git.pawan.kumar.gupta@linux.intel.com>
 <20200714014540.GH29725@linux.intel.com>
 <099d6985-9e9f-1d9f-7098-58a9e26e4450@intel.com>
 <20200714191759.GA7116@guptapadev.amr>
 <ba442a51-294e-8624-9a69-5613ff050551@intel.com>
 <20200714210442.GA10488@guptapadev.amr>
 <e12cd3b8-7df1-94e8-e603-39e00648c026@intel.com>
 <20200715005130.GE14404@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715005130.GE14404@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 05:51:30PM -0700, Sean Christopherson wrote:
> On Tue, Jul 14, 2020 at 02:20:59PM -0700, Dave Hansen wrote:
> > On 7/14/20 2:04 PM, Pawan Gupta wrote:
> > >> I see three inputs and four possible states (sorry for the ugly table,
> > >> it was this or a spreadsheet :):
> > >>
> > >> X86_FEATURE_VMX	CONFIG_KVM_*	hpage split  Result	   Reason
> > >> 	N			x	    x	     Not Affected  No VMX
> > >> 	Y			N	    x	     Not affected  No KVM
> 
> This line item is pointless, the relevant itlb_multihit_show_state()
> implementation depends on CONFIG_KVM_INTEL.  The !KVM_INTEL version simply
> prints ""Processor vulnerable".

While we are on it, for CONFIG_KVM_INTEL=n would it make sense to report "Not
affected(No KVM)"? "Processor vulnerable" is not telling much about the
mitigation.

Thanks,
Pawan
