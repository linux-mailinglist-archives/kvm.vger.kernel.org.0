Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF7FD9913F
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 12:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732324AbfHVKqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 06:46:33 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:57077 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfHVKqd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 06:46:33 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 46Dh6F6clVz9sN6; Thu, 22 Aug 2019 20:46:29 +1000 (AEST)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 237aed48c642328ff0ab19b63423634340224a06
In-Reply-To: <20190806172538.5087-1-clg@kaod.org>
To:     =?utf-8?q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Paul Mackerras <paulus@samba.org>
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        =?utf-8?q?C=C3=A9dric_Le?= =?utf-8?q?_Goater?= <clg@kaod.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: XIVE: Free escalation interrupts before disabling the VP
Message-Id: <46Dh6F6clVz9sN6@ozlabs.org>
Date:   Thu, 22 Aug 2019 20:46:29 +1000 (AEST)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-08-06 at 17:25:38 UTC, =?utf-8?q?C=C3=A9dric_Le_Goater?= wrote:
> When a vCPU is brought done, the XIVE VP is first disabled and then
> the event notification queues are freed. When freeing the queues, we
> check for possible escalation interrupts and free them also.
> 
> But when a XIVE VP is disabled, the underlying XIVE ENDs also are
> disabled in OPAL. When an END is disabled, its ESB pages (ESn and ESe)
> are disabled and loads return all 1s. Which means that any access on
> the ESB page of the escalation interrupt will return invalid values.
> 
> When an interrupt is freed, the shutdown handler computes a 'saved_p'
> field from the value returned by a load in xive_do_source_set_mask().
> This value is incorrect for escalation interrupts for the reason
> described above.
> 
> This has no impact on Linux/KVM today because we don't make use of it
> but we will introduce in future changes a xive_get_irqchip_state()
> handler. This handler will use the 'saved_p' field to return the state
> of an interrupt and 'saved_p' being incorrect, softlockup will occur.
> 
> Fix the vCPU cleanup sequence by first freeing the escalation
> interrupts if any, then disable the XIVE VP and last free the queues.
> 
> Signed-off-by: Cédric Le Goater <clg@kaod.org>

Applied to powerpc topic/ppc-kvm, thanks.

https://git.kernel.org/powerpc/c/237aed48c642328ff0ab19b63423634340224a06

cheers
