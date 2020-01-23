Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0204B14744A
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 00:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbgAWXCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 18:02:02 -0500
Received: from mga18.intel.com ([134.134.136.126]:46816 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729154AbgAWXCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 18:02:02 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 15:01:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,355,1574150400"; 
   d="scan'208";a="276175592"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Jan 2020 15:01:25 -0800
Date:   Thu, 23 Jan 2020 15:01:25 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linmiaohe <linmiaohe@huawei.com>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: nVMX: set rflags to specify success in
 handle_invvpid() default case
Message-ID: <20200123230125.GA24211@linux.intel.com>
References: <1579749241-712-1-git-send-email-linmiaohe@huawei.com>
 <8736c6sga7.fsf@vitty.brq.redhat.com>
 <1a083ac8-3b01-fd2d-d867-2b3956cdef6d@redhat.com>
 <87wo9iqzfa.fsf@vitty.brq.redhat.com>
 <ee7d815f-750f-3d0e-2def-1631be66a483@redhat.com>
 <CALMp9eRRUY6a_QzbG-rHoZi5zc1YWHLk243=V2VBSQa=HL-Dpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRRUY6a_QzbG-rHoZi5zc1YWHLk243=V2VBSQa=HL-Dpw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 23, 2020 at 10:22:24AM -0800, Jim Mattson wrote:
> On Thu, Jan 23, 2020 at 1:54 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 23/01/20 10:45, Vitaly Kuznetsov wrote:
> > >>> SDM says that "If an
> > >>> unsupported INVVPID type is specified, the instruction fails." and this
> > >>> is similar to INVEPT and I decided to check what handle_invept()
> > >>> does. Well, it does BUG_ON().
> > >>>
> > >>> Are we doing the right thing in any of these cases?
> > >>
> > >> Yes, both INVEPT and INVVPID catch this earlier.
> > >>
> > >> So I'm leaning towards not applying Miaohe's patch.
> > >
> > > Well, we may at least want to converge on BUG_ON() for both
> > > handle_invvpid()/handle_invept(), there's no need for them to differ.
> >
> > WARN_ON_ONCE + nested_vmx_failValid would probably be better, if we
> > really want to change this.
> >
> > Paolo
> 
> In both cases, something is seriously wrong. The only plausible
> explanations are compiler error or hardware failure. It would be nice
> to handle *all* such failures with a KVM_INTERNAL_ERROR exit to
> userspace. (I'm also thinking of situations like getting a VM-exit for
> INIT.)

Ya.  Vitaly and I had a similar discussion[*].  The idea we tossed around
was to also mark the VM as having encountered a KVM/hardware bug so that
the VM is effectively dead.  That would also allow gracefully handling bugs
that are detected deep in the stack, i.e. can't simply return 0 to get out
to userspace.

[*] https://lkml.kernel.org/r/20190930153358.GD14693@linux.intel.com
