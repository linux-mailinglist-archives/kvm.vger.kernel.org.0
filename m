Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6738466B04
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 12:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfGLKof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 06:44:35 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43267 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfGLKoe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 06:44:34 -0400
Received: from [5.158.153.55] (helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hlt2D-0004oK-MD; Fri, 12 Jul 2019 12:44:13 +0200
Date:   Fri, 12 Jul 2019 12:44:02 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Dave Hansen <dave.hansen@intel.com>
cc:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        pbonzini@redhat.com, rkrcmar@redhat.com, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
In-Reply-To: <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com>
Message-ID: <alpine.DEB.2.21.1907120911160.11639@nanos.tec.linutronix.de>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com> <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Jul 2019, Dave Hansen wrote:

> On 7/11/19 7:25 AM, Alexandre Chartre wrote:
> > - Kernel code mapped to the ASI page-table has been reduced to:
> >   . the entire kernel (I still need to test with only the kernel text)
> >   . the cpu entry area (because we need the GDT to be mapped)
> >   . the cpu ASI session (for managing ASI)
> >   . the current stack
> > 
> > - Optionally, an ASI can request the following kernel mapping to be added:
> >   . the stack canary
> >   . the cpu offsets (this_cpu_off)
> >   . the current task
> >   . RCU data (rcu_data)
> >   . CPU HW events (cpu_hw_events).
> 
> I don't see the per-cpu areas in here.  But, the ASI macros in
> entry_64.S (and asi_start_abort()) use per-cpu data.
> 
> Also, this stuff seems to do naughty stuff (calling C code, touching
> per-cpu data) before the PTI CR3 writes have been done.  But, I don't
> see anything excluding PTI and this code from coexisting.

That ASI thing is just PTI on steroids.

So why do we need two versions of the same thing? That's absolutely bonkers
and will just introduce subtle bugs and conflicting decisions all over the
place.

The need for ASI is very tightly coupled to the need for PTI and there is
absolutely no point in keeping them separate.

The only difference vs. interrupts and exceptions is that the PTI logic
cares whether they enter from user or from kernel space while ASI only
cares about the kernel entry.

But most exceptions/interrupts transitions do not require to be handled at
the entry code level because on VMEXIT the exit reason clearly tells
whether a switch to the kernel CR3 is necessary or not. So this has to be
handled at the VMM level already in a very clean and simple way.

I'm not a virt wizard, but according to code inspection and instrumentation
even the NMI on the host is actually reinjected manually into the host via
'int $2' after the VMEXIT and for MCE it looks like manual handling as
well. So why do we need to sprinkle that muck all over the entry code?

From a semantical perspective VMENTER/VMEXIT are very similar to the return
to user / enter to user mechanics. Just that the transition happens in the
VMM code and not at the regular user/kernel transition points.

So why do you want ot treat that differently? There is absolutely zero
reason to do so. And there is no reason to create a pointlessly different
version of PTI which introduces yet another variant of a restricted page
table instead of just reusing and extending what's there already.

Thanks,

	tglx
