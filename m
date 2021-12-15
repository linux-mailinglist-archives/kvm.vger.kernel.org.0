Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB26475AAD
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 15:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243378AbhLOOcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 09:32:10 -0500
Received: from foss.arm.com ([217.140.110.172]:53684 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234528AbhLOOcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 09:32:09 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 842511FB;
        Wed, 15 Dec 2021 06:32:09 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.67.176])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 21DA23F774;
        Wed, 15 Dec 2021 06:32:07 -0800 (PST)
Date:   Wed, 15 Dec 2021 14:32:04 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/6] KVM: arm64: Correctly treat writes to OSLSR_EL1
 as undefined
Message-ID: <Ybn8ZK29AI18WGPQ@FVFF77S0Q05N>
References: <20211214172812.2894560-1-oupton@google.com>
 <20211214172812.2894560-2-oupton@google.com>
 <YbnUDny3GSNpyabJ@FVFF77S0Q05N>
 <YbnpCFBPNgmkEXjf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbnpCFBPNgmkEXjf@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 15, 2021 at 01:09:28PM +0000, Oliver Upton wrote:
> Hi Mark,
> 
> On Wed, Dec 15, 2021 at 11:39:58AM +0000, Mark Rutland wrote:
> > Hi Oliver,
> > 
> > On Tue, Dec 14, 2021 at 05:28:07PM +0000, Oliver Upton wrote:
> > > Any valid implementation of the architecture should generate an
> > > undefined exception for writes to a read-only register, such as
> > > OSLSR_EL1. Nonetheless, the KVM handler actually implements write-ignore
> > > behavior.
> > > 
> > > Align the trap handler for OSLSR_EL1 with hardware behavior. If such a
> > > write ever traps to EL2, inject an undef into the guest and print a
> > > warning.
> > 
> > I think this can still be read amibguously, since we don't explicitly state
> > that writes to OSLSR_EL1 should never trap (and the implications of being
> > UNDEFINED are subtle). How about:
> > 
> > | Writes to OSLSR_EL1 are UNDEFINED and should never trap from EL1 to EL2, but
> > | the KVM trap handler for OSLSR_EL1 handlees writes via ignore_write(). This

Whoops, with s/handlees/handles/

> > | is confusing to readers of the code, but shouldn't have any functional impact.
> > |
> > | For clarity, use write_to_read_only() rather than ignore_write(). If a trap
> > | is unexpectedly taken to EL2 in violation of the architecture, this will
> > | WARN_ONCE() and inject an undef into the guest.
> 
> Agreed, I like your suggested changelog better :-)

Cool!

Mark.

> 
> > With that:
> > 
> > Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> 
> Thanks!
> 
> --
> Best,
> Oliver
