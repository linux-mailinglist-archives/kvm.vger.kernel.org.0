Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1066EE0D1D
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 22:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389278AbfJVUNZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 16:13:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:46875 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387645AbfJVUNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 16:13:25 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 13:13:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,217,1569308400"; 
   d="scan'208";a="188017062"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 22 Oct 2019 13:13:21 -0700
Date:   Tue, 22 Oct 2019 13:13:21 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v7 5/7] kvm: x86: Add CET CR4 bit and XSS support
Message-ID: <20191022201321.GN2343@linux.intel.com>
References: <20190927021927.23057-1-weijiang.yang@intel.com>
 <20190927021927.23057-6-weijiang.yang@intel.com>
 <CALMp9eStz-VCv5G60KFtumQ8W1Jqf9bOcK_=KwL1P3LLjgajnQ@mail.gmail.com>
 <20191017195642.GJ20903@linux.intel.com>
 <20191018015802.GD2286@local-michael-cet-test>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018015802.GD2286@local-michael-cet-test>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 18, 2019 at 09:58:02AM +0800, Yang Weijiang wrote:
> On Thu, Oct 17, 2019 at 12:56:42PM -0700, Sean Christopherson wrote:
> > On Wed, Oct 02, 2019 at 12:05:23PM -0700, Jim Mattson wrote:
> > > > +               u64 kvm_xss = kvm_supported_xss();
> > > > +
> > > > +               best->ebx =
> > > > +                       xstate_required_size(vcpu->arch.xcr0 | kvm_xss, true);
> > > 
> > > Shouldn't this size be based on the *current* IA32_XSS value, rather
> > > than the supported IA32_XSS bits? (i.e.
> > > s/kvm_xss/vcpu->arch.ia32_xss/)
> > 
> > Ya.
> >
> I'm not sure if I understand correctly, kvm_xss is what KVM supports,
> but arch.ia32_xss reflects what guest currently is using, shoudn't CPUID
> report what KVM supports instead of current status?
> Will CPUID match current IA32_XSS status if guest changes it runtime?

Not in this case.  Select CPUID output is dependent on current state as
opposed to being a constant defind by hardware.  Per the SDM, EBX is:

  The size in bytes of the XSAVE area containing all states enabled by
  XCRO | IA32_XSS

Since KVM is emulating CPUID for the guest, XCR0 and IA32_XSS in this
context refers to the guest's current/actual XCR0/IA32_XSS values.  The
purpose of this behavior is so that software can call CPUID to query the
actual amount of memory that is needed for XSAVE(S), as opposed to the
absolute max size that _might_ be needed.

MONITOR/MWAIT is the other case that comes to mind where CPUID dynamically
reflects configured state, e.g. MWAIT is reported as unsupported if it's
disabled via IA32_MISC_ENABLE MSR.
