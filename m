Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3DF36B466
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 15:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbhDZN7x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 09:59:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231862AbhDZN7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 09:59:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C11C601FC;
        Mon, 26 Apr 2021 13:59:09 +0000 (UTC)
Date:   Mon, 26 Apr 2021 09:59:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai+lkml@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2 2/2] KVM: VMX: Invoke NMI handler via indirect call
 instead of INTn
Message-ID: <20210426095907.698ec524@gandalf.local.home>
In-Reply-To: <ace4c4d81ef0ee461ead6d046c3b3d7308dd32ae.camel@redhat.com>
References: <20200915191505.10355-1-sean.j.christopherson@intel.com>
        <20200915191505.10355-3-sean.j.christopherson@intel.com>
        <CAJhGHyBOLUeqnwx2X=WToE2oY8Zkqj_y4KZ0hoq-goe+UWcR9g@mail.gmail.com>
        <bb2c2d93-8046-017a-5711-c61c8f1a4c09@redhat.com>
        <ace4c4d81ef0ee461ead6d046c3b3d7308dd32ae.camel@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 26 Apr 2021 14:44:49 +0300
Maxim Levitsky <mlevitsk@redhat.com> wrote:

> On Mon, 2021-04-26 at 12:40 +0200, Paolo Bonzini wrote:
> > On 26/04/21 11:33, Lai Jiangshan wrote:  
> > > When handle_interrupt_nmi_irqoff() is called, we may lose the
> > > CPU-hidden-NMI-masked state due to IRET of #DB, #BP or other traps
> > > between VMEXIT and handle_interrupt_nmi_irqoff().
> > > 
> > > But the NMI handler in the Linux kernel*expects*  the CPU-hidden-NMI-masked
> > > state is still set in the CPU for no nested NMI intruding into the beginning
> > > of the handler.

This is incorrect. The Linux kernel has for some time handled the case of
nested NMIs. It had to, to implement the ftrace break point updates, as it
would trigger an int3 in an NMI which would "unmask" the NMIs. It has also
been a long time bug where a page fault could do the same (the reason you
could never do a dump all tasks from NMI without triple faulting!).

But that's been fixed a long time ago, and I even wrote an LWN article
about it ;-)

 https://lwn.net/Articles/484932/

The NMI handler can handle the case of nested NMIs, and implements a
software "latch" to remember that another NMI is to be executed, if there
is a nested one. And it does so after the first one has finished.

-- Steve
