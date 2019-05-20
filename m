Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAB7923BB3
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 17:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388340AbfETPIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 11:08:30 -0400
Received: from mga17.intel.com ([192.55.52.151]:31104 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732596AbfETPI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 11:08:29 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 May 2019 08:08:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,491,1549958400"; 
   d="scan'208";a="173647902"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga002.fm.intel.com with ESMTP; 20 May 2019 08:08:29 -0700
Date:   Mon, 20 May 2019 08:08:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH v3 5/5] KVM: LAPIC: Optimize timer latency further
Message-ID: <20190520150829.GB28482@linux.intel.com>
References: <1557975980-9875-1-git-send-email-wanpengli@tencent.com>
 <1557975980-9875-6-git-send-email-wanpengli@tencent.com>
 <20190517195049.GI15006@linux.intel.com>
 <CANRm+CwfDbVS2tYG0XCD8Gvx6GtszGLphiTvFMBYmwdt13P=1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+CwfDbVS2tYG0XCD8Gvx6GtszGLphiTvFMBYmwdt13P=1Q@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 20, 2019 at 04:19:47PM +0800, Wanpeng Li wrote:
> On Sat, 18 May 2019 at 03:50, Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Thu, May 16, 2019 at 11:06:20AM +0800, Wanpeng Li wrote:
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > > index 6b92eaf..955cfcb 100644
> > > --- a/arch/x86/kvm/svm.c
> > > +++ b/arch/x86/kvm/svm.c
> > > @@ -5638,6 +5638,10 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
> > >       clgi();
> > >       kvm_load_guest_xcr0(vcpu);
> > >
> > > +     if (lapic_in_kernel(vcpu) &&
> > > +             vcpu->arch.apic->lapic_timer.timer_advance_ns)
> >
> > Nit: align the two lines of the if statement, doing so makes it easier to
> >      differentiate between the condition and execution, e.g.:
> >
> >         if (lapic_in_kernel(vcpu) &&
> >             vcpu->arch.apic->lapic_timer.timer_advance_ns)
> >                 kvm_wait_lapic_expire(vcpu);
> 
> This can result in checkpatch.pl complain:
> 
> WARNING: suspect code indent for conditional statements (8, 24)
> #94: FILE: arch/x86/kvm/vmx/vmx.c:6436:
> +    if (lapic_in_kernel(vcpu) &&
> [...]
> +            kvm_wait_lapic_expire(vcpu);

That warning fires when the last line of the check and the code block of
the if statement are aligned (and the indent isn't a full tab stop, which
is why your original code isn't flagged).  Examples with explicit leading
whitespace:

Good:

\tif (lapic_in_kernel(vcpu) &&
\t\s\s\s\svcpu->arch.apic->lapic_timer.timer_advance_ns)
\t\tkvm_wait_lapic_expire(vcpu);

Bad:

\tif (lapic_in_kernel(vcpu) &&
\t\s\s\s\svcpu->arch.apic->lapic_timer.timer_advance_ns)
\t\s\s\s\skvm_wait_lapic_expire(vcpu);
