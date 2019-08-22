Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB0FB99145
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 12:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732407AbfHVKqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 06:46:37 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:45313 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730333AbfHVKqg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 06:46:36 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 46Dh6K3mW5z9sNk; Thu, 22 Aug 2019 20:46:33 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: da15c03b047dca891d37b9f4ef9ca14d84a6484f
In-Reply-To: <20190813100648.GE9567@blackberry>
To:     Paul Mackerras <paulus@ozlabs.org>, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v2 3/3] powerpc/xive: Implement get_irqchip_state method for XIVE to fix shutdown race
Message-Id: <46Dh6K3mW5z9sNk@ozlabs.org>
Date:   Thu, 22 Aug 2019 20:46:33 +1000 (AEST)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-08-13 at 10:06:48 UTC, Paul Mackerras wrote:
> Testing has revealed the existence of a race condition where a XIVE
> interrupt being shut down can be in one of the XIVE interrupt queues
> (of which there are up to 8 per CPU, one for each priority) at the
> point where free_irq() is called.  If this happens, can return an
> interrupt number which has been shut down.  This can lead to various
> symptoms:
> 
> - irq_to_desc(irq) can be NULL.  In this case, no end-of-interrupt
>   function gets called, resulting in the CPU's elevated interrupt
>   priority (numerically lowered CPPR) never gets reset.  That then
>   means that the CPU stops processing interrupts, causing device
>   timeouts and other errors in various device drivers.
> 
> - The irq descriptor or related data structures can be in the process
>   of being freed as the interrupt code is using them.  This typically
>   leads to crashes due to bad pointer dereferences.
> 
> This race is basically what commit 62e0468650c3 ("genirq: Add optional
> hardware synchronization for shutdown", 2019-06-28) is intended to
> fix, given a get_irqchip_state() method for the interrupt controller
> being used.  It works by polling the interrupt controller when an
> interrupt is being freed until the controller says it is not pending.
> 
> With XIVE, the PQ bits of the interrupt source indicate the state of
> the interrupt source, and in particular the P bit goes from 0 to 1 at
> the point where the hardware writes an entry into the interrupt queue
> that this interrupt is directed towards.  Normally, the code will then
> process the interrupt and do an end-of-interrupt (EOI) operation which
> will reset PQ to 00 (assuming another interrupt hasn't been generated
> in the meantime).  However, there are situations where the code resets
> P even though a queue entry exists (for example, by setting PQ to 01,
> which disables the interrupt source), and also situations where the
> code leaves P at 1 after removing the queue entry (for example, this
> is done for escalation interrupts so they cannot fire again until
> they are explicitly re-enabled).
> 
> The code already has a 'saved_p' flag for the interrupt source which
> indicates that a queue entry exists, although it isn't maintained
> consistently.  This patch adds a 'stale_p' flag to indicate that
> P has been left at 1 after processing a queue entry, and adds code
> to set and clear saved_p and stale_p as necessary to maintain a
> consistent indication of whether a queue entry may or may not exist.
> 
> With this, we can implement xive_get_irqchip_state() by looking at
> stale_p, saved_p and the ESB PQ bits for the interrupt.
> 
> There is some additional code to handle escalation interrupts
> properly; because they are enabled and disabled in KVM assembly code,
> which does not have access to the xive_irq_data struct for the
> escalation interrupt.  Hence, stale_p may be incorrect when the
> escalation interrupt is freed in kvmppc_xive_{,native_}cleanup_vcpu().
> Fortunately, we can fix it up by looking at vcpu->arch.xive_esc_on,
> with some careful attention to barriers in order to ensure the correct
> result if xive_esc_irq() races with kvmppc_xive_cleanup_vcpu().
> 
> Finally, this adds code to make noise on the console (pr_crit and
> WARN_ON(1)) if we find an interrupt queue entry for an interrupt
> which does not have a descriptor.  While this won't catch the race
> reliably, if it does get triggered it will be an indication that
> the race is occurring and needs to be debugged.
> 
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>

Applied to powerpc topic/ppc-kvm, thanks.

https://git.kernel.org/powerpc/c/da15c03b047dca891d37b9f4ef9ca14d84a6484f

cheers
