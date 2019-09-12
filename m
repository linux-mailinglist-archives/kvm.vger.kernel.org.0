Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA8AB16C1
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 01:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbfILXwG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 19:52:06 -0400
Received: from mga17.intel.com ([192.55.52.151]:44578 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbfILXwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 19:52:06 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 16:52:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="386225320"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 12 Sep 2019 16:52:05 -0700
Date:   Thu, 12 Sep 2019 16:52:05 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Fuqian Huang <huangfq.daxian@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: work around leak of uninitialized stack
 contents
Message-ID: <20190912235205.GA6588@linux.intel.com>
References: <20190912041817.23984-1-huangfq.daxian@gmail.com>
 <CALMp9eSL_rDdWmgeWNwuqP_J_yu7x5Gs8DUBpJFdie18NEz=ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSL_rDdWmgeWNwuqP_J_yu7x5Gs8DUBpJFdie18NEz=ow@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 12, 2019 at 02:20:09PM -0700, Jim Mattson wrote:
> On Wed, Sep 11, 2019 at 9:18 PM Fuqian Huang <huangfq.daxian@gmail.com> wrote:
> >
> > Emulation of VMPTRST can incorrectly inject a page fault
> > when passed an operand that points to an MMIO address.
> > The page fault will use uninitialized kernel stack memory
> > as the CR2 and error code.
> >
> > The right behavior would be to abort the VM with a KVM_EXIT_INTERNAL_ERROR
> > exit to userspace; however, it is not an easy fix, so for now just ensure
> > that the error code and CR2 are zero.
> >
> > Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
> > ---
> >  arch/x86/kvm/x86.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 290c3c3efb87..7f442d710858 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5312,6 +5312,7 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
> >         /* kvm_write_guest_virt_system can pull in tons of pages. */
> >         vcpu->arch.l1tf_flush_l1d = true;
> >
> > +       memset(exception, 0, sizeof(*exception));
> >         return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
> >                                            PFERR_WRITE_MASK, exception);
> >  }
> > --
> > 2.11.0
> >
> Perhaps you could also add a comment like the one Paolo added when he
> made the same change in kvm_read_guest_virt?
> See commit 353c0956a618 ("KVM: x86: work around leak of uninitialized
> stack contents (CVE-2019-7222)").

I have a better hack-a-fix, we can handle the unexpected MMIO using master
abort semantics, i.e. reads return all ones, writes are dropped.  It's not
100% correct as KVM won't handle the case where the address is legit MMIO,
but it's at least sometimes correct and thus better than a #PF.

Patch and a unit test incoming...
