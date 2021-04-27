Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFBB36BCCB
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 03:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235240AbhD0BBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 21:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232022AbhD0BBF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 21:01:05 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30CAF60BBB;
        Tue, 27 Apr 2021 01:00:22 +0000 (UTC)
Date:   Mon, 26 Apr 2021 21:00:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v2 2/2] KVM: VMX: Invoke NMI handler via indirect call
 instead of INTn
Message-ID: <20210426210020.417e3cfc@oasis.local.home>
In-Reply-To: <CAJhGHyDrAwKO1iht=d0j+OKD1U7e1fzLminudxo2sPHbF53TKQ@mail.gmail.com>
References: <20200915191505.10355-1-sean.j.christopherson@intel.com>
        <20200915191505.10355-3-sean.j.christopherson@intel.com>
        <CAJhGHyBOLUeqnwx2X=WToE2oY8Zkqj_y4KZ0hoq-goe+UWcR9g@mail.gmail.com>
        <bb2c2d93-8046-017a-5711-c61c8f1a4c09@redhat.com>
        <CAJhGHyDrAwKO1iht=d0j+OKD1U7e1fzLminudxo2sPHbF53TKQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Apr 2021 08:54:37 +0800
Lai Jiangshan <jiangshanlai+lkml@gmail.com> wrote:

> > However, I'm not sure which of the two situations is better: entering
> > the NMI handler on the IST without setting the hidden NMI-blocked flag
> > could be a recipe for bad things as well.  
> 
> The change makes the ASM NMI entry called on the kernel stack.  But the
> ASM NMI entry expects it on the IST stack and it plays with "NMI executing"
> variable on the IST stack.  In this change, the stranded ASM NMI entry
> will use the wrong/garbage "NMI executing" variable on the kernel stack
> and may do some very wrong thing.

I missed this detail.

> 
> Sorry, in my reply, "the NMI handler" meant to be the ASM entry installed
> on the IDT table which really expects to be NMI-masked at the beginning.
> 
> The C NMI handler can handle the case of nested NMIs, which is useful
> here.  I think we should change it to call the C NMI handler directly
> here as Andy Lutomirski suggested:

Yes, because that's the way x86_32 works.

> 
> On Mon, Apr 26, 2021 at 11:09 PM Andy Lutomirski <luto@amacapital.net> wrote:
> > The C NMI code has its own reentrancy protection and has for years.
> > It should work fine for this use case.  
> 
> I think this is the right way.

Agreed.

-- Steve
