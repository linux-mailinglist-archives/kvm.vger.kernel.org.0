Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCB6A8D4C
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732147AbfIDQoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 12:44:20 -0400
Received: from mga05.intel.com ([192.55.52.43]:47900 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731719AbfIDQoU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 12:44:20 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 09:44:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,467,1559545200"; 
   d="scan'208";a="382576763"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 04 Sep 2019 09:44:18 -0700
Date:   Wed, 4 Sep 2019 09:44:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH v2 1/2] KVM: VMX: Disable posted interrupts for odd IRQs
Message-ID: <20190904164418.GD24079@linux.intel.com>
References: <20190904133511.17540-1-graf@amazon.com>
 <20190904133511.17540-2-graf@amazon.com>
 <20190904144045.GA24079@linux.intel.com>
 <fcaefade-16c1-6480-aeab-413bcd16dc52@amazon.com>
 <20190904155125.GC24079@linux.intel.com>
 <3f15f8d5-6129-e202-f56e-a5809c41782c@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f15f8d5-6129-e202-f56e-a5809c41782c@amazon.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 04, 2019 at 05:58:08PM +0200, Alexander Graf wrote:
> 
> On 04.09.19 17:51, Sean Christopherson wrote:
> >On Wed, Sep 04, 2019 at 05:36:39PM +0200, Alexander Graf wrote:
> >>
> >>-	if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu)) {
> >>+	if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
> >>+	    !kvm_irq_is_generic(&irq)) {
> >
> >I've never heard/seen the term generic used to describe x86 interrupts.
> >Maybe kvm_irq_is_intr() or kvm_irq_is_vectored_intr()?
> 
> I was trying to come up with any name that describes "interrupt that we can
> post". If "intr" is that, I'll be happy to take it. Vectored_intr sounds
> even worse IMHO :).

kvm_irq_is_intr() is fine by me if it's clear to everyone else.
Alternatively, we could be more literal, e.g. kvm_irq_is_postable().

> 
> >
> >>  		pr_debug("SVM: %s: use legacy intr remap mode for irq %u\n",
> >>  			 __func__, irq.vector);
> >>  		return -1;
> >>@@ -5314,6 +5315,7 @@ static int svm_update_pi_irte(struct kvm *kvm,
> >>unsigned int host_irq,
> >>  		 * 1. When cannot target interrupt to a specific vcpu.
> >>  		 * 2. Unsetting posted interrupt.
> >>  		 * 3. APIC virtialization is disabled for the vcpu.
> >>+		 * 4. IRQ has extended delivery mode (SMI, INIT, etc)
> >
> >Similarly, 'extended delivery mode' isn't really a thing, it's simply the
> >delivery mode.
> 
> s/extended/incompatible/ maybe?

Ya, much better.
