Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F951E379D
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 07:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgE0FDw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 01:03:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:12110 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgE0FDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 01:03:52 -0400
IronPort-SDR: idtH4SsVZEYvZMTG8zEKs2DTHDAkXQyLLSS2iypxRZkF7vc7JRH0Zz5lwM6S/7PdiNvNqybexQ
 QEll9H43bRXg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 22:03:51 -0700
IronPort-SDR: IDjJYMB2xhItrESlJ3Zifboi+czkTD8eZyWtdEyEMjzj7RutpCtZfFIP0/59NUCUakiJ6uxEAm
 YB5Mp0JYfFrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,440,1583222400"; 
   d="scan'208";a="310471960"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by FMSMGA003.fm.intel.com with ESMTP; 26 May 2020 22:03:50 -0700
Date:   Tue, 26 May 2020 22:03:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFC 02/16] x86/kvm: Introduce KVM memory protection feature
Message-ID: <20200527050350.GK31696@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200522125214.31348-3-kirill.shutemov@linux.intel.com>
 <87d06s83is.fsf@vitty.brq.redhat.com>
 <20200525151525.qmfvzxbl7sq46cdq@box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525151525.qmfvzxbl7sq46cdq@box>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 06:15:25PM +0300, Kirill A. Shutemov wrote:
> On Mon, May 25, 2020 at 04:58:51PM +0200, Vitaly Kuznetsov wrote:
> > > @@ -727,6 +734,15 @@ static void __init kvm_init_platform(void)
> > >  {
> > >  	kvmclock_init();
> > >  	x86_platform.apic_post_init = kvm_apic_init;
> > > +
> > > +	if (kvm_para_has_feature(KVM_FEATURE_MEM_PROTECTED)) {
> > > +		if (kvm_hypercall0(KVM_HC_ENABLE_MEM_PROTECTED)) {
> > > +			pr_err("Failed to enable KVM memory protection\n");
> > > +			return;
> > > +		}
> > > +
> > > +		mem_protected = true;
> > > +	}
> > >  }
> > 
> > Personally, I'd prefer to do this via setting a bit in a KVM-specific
> > MSR instead. The benefit is that the guest doesn't need to remember if
> > it enabled the feature or not, it can always read the config msr. May
> > come handy for e.g. kexec/kdump.
> 
> I think we would need to remember it anyway. Accessing MSR is somewhat
> expensive. But, okay, I can rework it MSR if needed.

I think Vitaly is talking about the case where the kernel can't easily get
at its cached state, e.g. after booting into a new kernel.  The kernel would
still have an X86_FEATURE bit or whatever, providing a virtual MSR would be
purely for rare slow paths.

That being said, a hypercall plus CPUID bit might be better, e.g. that'd
allow the guest to query the state without risking a #GP.

> Note, that we can avoid the enabling algother, if we modify BIOS to deal
> with private/shared memory. Currently BIOS get system crash if we enable
> the feature from time zero.

Which would mesh better with a CPUID feature bit.
