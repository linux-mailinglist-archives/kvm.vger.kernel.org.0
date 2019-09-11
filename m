Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6782B04AE
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 21:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730396AbfIKTyB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 15:54:01 -0400
Received: from mga07.intel.com ([134.134.136.100]:63887 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727581AbfIKTyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 15:54:01 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 12:54:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,494,1559545200"; 
   d="scan'208";a="184583231"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 11 Sep 2019 12:53:58 -0700
Date:   Wed, 11 Sep 2019 12:53:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jan Dakinevich <jan.dakinevich@virtuozzo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Denis Lunev <den@virtuozzo.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Denis Plotnikov <dplotnikov@virtuozzo.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/3] fix emulation error on Windows bootup
Message-ID: <20190911195359.GK1045@linux.intel.com>
References: <1566911210-30059-1-git-send-email-jan.dakinevich@virtuozzo.com>
 <b35c8b24-7531-5a5d-1518-eaf9567359ae@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b35c8b24-7531-5a5d-1518-eaf9567359ae@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 11, 2019 at 05:51:05PM +0200, Paolo Bonzini wrote:
> On 27/08/19 15:07, Jan Dakinevich wrote:
> > This series intended to fix (again) a bug that was a subject of the 
> > following change:
> > 
> >   6ea6e84 ("KVM: x86: inject exceptions produced by x86_decode_insn")
> > 
> > Suddenly, that fix had a couple mistakes. First, ctxt->have_exception was 
> > not set if fault happened during instruction decoding. Second, returning 
> > value of inject_emulated_instruction was used to make the decision to 
> > reenter guest, but this could happen iff on nested page fault, that is not 
> > the scope where this bug could occur.
> > 
> > However, I have still deep doubts about 3rd commit in the series. Could
> > you please, make me an advise if it is the correct handling of guest page 
> > fault?
> > 
> > Jan Dakinevich (3):
> >   KVM: x86: fix wrong return code
> >   KVM: x86: set ctxt->have_exception in x86_decode_insn()
> >   KVM: x86: always stop emulation on page fault
> > 
> >  arch/x86/kvm/emulate.c | 4 +++-
> >  arch/x86/kvm/x86.c     | 4 +++-
> >  2 files changed, 6 insertions(+), 2 deletions(-)
> > 
> 
> Queued, thanks.  I added the WARN_ON_ONCE that Sean suggested.

Which version did you queue?  It sounds like you queued v1, which breaks
VMware backdoor emulation due to incorrect patch ordering.  v3[*] fixes
the ordering issue and adds the WARN_ON_ONCE.

[*] https://patchwork.kernel.org/cover/11120627/
