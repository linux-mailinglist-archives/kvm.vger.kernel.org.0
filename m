Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD6C799141
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 12:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732349AbfHVKqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 06:46:33 -0400
Received: from ozlabs.org ([203.11.71.1]:52375 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730333AbfHVKqd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 06:46:33 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 46Dh6H04Gkz9sNC; Thu, 22 Aug 2019 20:46:30 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 959c5d5134786b4988b6fdd08e444aa67d1667ed
In-Reply-To: <20190813100349.GD9567@blackberry>
To:     Paul Mackerras <paulus@ozlabs.org>, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v2 1/3] KVM: PPC: Book3S HV: Fix race in re-enabling XIVE escalation interrupts
Message-Id: <46Dh6H04Gkz9sNC@ozlabs.org>
Date:   Thu, 22 Aug 2019 20:46:30 +1000 (AEST)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-08-13 at 10:03:49 UTC, Paul Mackerras wrote:
> Escalation interrupts are interrupts sent to the host by the XIVE
> hardware when it has an interrupt to deliver to a guest VCPU but that
> VCPU is not running anywhere in the system.  Hence we disable the
> escalation interrupt for the VCPU being run when we enter the guest
> and re-enable it when the guest does an H_CEDE hypercall indicating
> it is idle.
> 
> It is possible that an escalation interrupt gets generated just as we
> are entering the guest.  In that case the escalation interrupt may be
> using a queue entry in one of the interrupt queues, and that queue
> entry may not have been processed when the guest exits with an H_CEDE.
> The existing entry code detects this situation and does not clear the
> vcpu->arch.xive_esc_on flag as an indication that there is a pending
> queue entry (if the queue entry gets processed, xive_esc_irq() will
> clear the flag).  There is a comment in the code saying that if the
> flag is still set on H_CEDE, we have to abort the cede rather than
> re-enabling the escalation interrupt, lest we end up with two
> occurrences of the escalation interrupt in the interrupt queue.
> 
> However, the exit code doesn't do that; it aborts the cede in the sense
> that vcpu->arch.ceded gets cleared, but it still enables the escalation
> interrupt by setting the source's PQ bits to 00.  Instead we need to
> set the PQ bits to 10, indicating that an interrupt has been triggered.
> We also need to avoid setting vcpu->arch.xive_esc_on in this case
> (i.e. vcpu->arch.xive_esc_on seen to be set on H_CEDE) because
> xive_esc_irq() will run at some point and clear it, and if we race with
> that we may end up with an incorrect result (i.e. xive_esc_on set when
> the escalation interrupt has just been handled).
> 
> It is extremely unlikely that having two queue entries would cause
> observable problems; theoretically it could cause queue overflow, but
> the CPU would have to have thousands of interrupts targetted to it for
> that to be possible.  However, this fix will also make it possible to
> determine accurately whether there is an unhandled escalation
> interrupt in the queue, which will be needed by the following patch.
> 
> Cc: stable@vger.kernel.org # v4.16+
> Fixes: 9b9b13a6d153 ("KVM: PPC: Book3S HV: Keep XIVE escalation interrupt masked unless ceded")
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>

Applied to powerpc topic/ppc-kvm, thanks.

https://git.kernel.org/powerpc/c/959c5d5134786b4988b6fdd08e444aa67d1667ed

cheers
