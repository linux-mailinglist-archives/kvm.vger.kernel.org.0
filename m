Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84C566722C
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 17:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbfGLPRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 11:17:22 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44192 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGLPRW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 11:17:22 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hlxIF-0003Mo-Lj; Fri, 12 Jul 2019 17:17:03 +0200
Date:   Fri, 12 Jul 2019 17:16:58 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Peter Zijlstra <peterz@infradead.org>
cc:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, Paul Turner <pjt@google.com>
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
In-Reply-To: <20190712125059.GP3419@hirez.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.21.1907121459180.1788@nanos.tec.linutronix.de>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com> <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com> <alpine.DEB.2.21.1907120911160.11639@nanos.tec.linutronix.de> <61d5851e-a8bf-e25c-e673-b71c8b83042c@oracle.com>
 <20190712125059.GP3419@hirez.programming.kicks-ass.net>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Jul 2019, Peter Zijlstra wrote:
> On Fri, Jul 12, 2019 at 01:56:44PM +0200, Alexandre Chartre wrote:
> 
> > I think that's precisely what makes ASI and PTI different and independent.
> > PTI is just about switching between userland and kernel page-tables, while
> > ASI is about switching page-table inside the kernel. You can have ASI without
> > having PTI. You can also use ASI for kernel threads so for code that won't
> > be triggered from userland and so which won't involve PTI.
> 
> PTI is not mapping         kernel space to avoid             speculation crap (meltdown).
> ASI is not mapping part of kernel space to avoid (different) speculation crap (MDS).
> 
> See how very similar they are?
> 
> Furthermore, to recover SMT for userspace (under MDS) we not only need
> core-scheduling but core-scheduling per address space. And ASI was
> specifically designed to help mitigate the trainwreck just described.
> 
> By explicitly exposing (hopefully harmless) part of the kernel to MDS,
> we reduce the part that needs core-scheduling and thus reduce the rate
> the SMT siblngs need to sync up/schedule.
> 
> But looking at it that way, it makes no sense to retain 3 address
> spaces, namely:
> 
>   user / kernel exposed / kernel private.
> 
> Specifically, it makes no sense to expose part of the kernel through MDS
> but not through Meltdow. Therefore we can merge the user and kernel
> exposed address spaces.
> 
> And then we've fully replaced PTI.
> 
> So no, they're not orthogonal.

Right. If we decide to expose more parts of the kernel mappings then that's
just adding more stuff to the existing user (PTI) map mechanics.

As a consequence the CR3 switching points become different or can be
consolidated and that can be handled right at those switching points
depending on static keys or alternatives as we do today with PTI and other
mitigations.

All of that can do without that obscure "state machine" which is solely
there to duct-tape the complete lack of design. The same applies to that
mapping thing. Just mapping randomly selected parts by sticking them into
an array is a non-maintainable approach. This needs proper separation of
text and data sections, so violations of the mapping constraints can be
statically analyzed. Depending solely on the page fault at run time for
analysis is just bound to lead to hard to diagnose failures in the field.

TBH we all know already that this can be done and that this will solve some
of the issues caused by the speculation mess, so just writing some hastily
cobbled together POC code which explodes just by looking at it, does not
lead to anything else than time waste on all ends.

This first needs a clear definition of protection scope. That scope clearly
defines the required mappings and consequently the transition requirements
which provide the necessary transition points for flipping CR3.

If we have agreed on that, then we can think about the implementation
details.

Thanks,

	tglx
