Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20732277F0
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 07:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgGUFEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 01:04:53 -0400
Received: from ozlabs.org ([203.11.71.1]:46591 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726003AbgGUFEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 01:04:52 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4B9mjt342fz9sSJ; Tue, 21 Jul 2020 15:04:50 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1595307890; bh=F77WFg+4dndurqYjYW+EYiJiX3wkHQ0Go7Hn9Xv1mhY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DivInJNueA+UccbiuANm5nHiHdMSq1dBegGb0Qi7XOrxUwx8qMXEe14MxEW4C9bWJ
         VfjM0sYFtB5ndIRadWr57LjUNrnzvoP4GSzN8twwv3qGFtm4xc3H1dXY+d2O3Pd5ib
         e6JM0ZVmoD8b35ixh03vQ2VUiy48z8q+pQ4dQ7Quli0av6un79xsnGfEbv9x/F3iRk
         LGodlffg7TZG5Y7OYCxIFbj+3LoFJV2uwMLVjarNIeFlJE0IVtGJXgjzuCimK0ZNmG
         83dgoFx2Nl7AC4/xqPw9lJ0QVe1LqhhkxIRSLWN2yRs+MR7jtNkhG56D3tXpKyLKT9
         r1oATtEG7PkpQ==
Date:   Tue, 21 Jul 2020 15:04:45 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Use feature flag CPU_FTR_P9_TIDR
 when accessing TIDR
Message-ID: <20200721050445.GA3878639@thinks.paulus.ozlabs.org>
References: <20200623165027.271215-1-clg@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200623165027.271215-1-clg@kaod.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 06:50:27PM +0200, C�dric Le Goater wrote:
> The TIDR register is only available on POWER9 systems and code
> accessing this register is not always protected by the CPU_FTR_P9_TIDR
> flag. Fix that to make sure POWER10 systems won't use it as TIDR has
> been removed.

I'm concerned about what this patch would do if we are trying to
migrate from a P9 guest to a guest on P10 in P9-compat mode, in that
the destination QEMU would get an error on doing the SET_ONE_REG for
the TIDR.  I don't think the lack of TIDR is worth failing the
migration for given that TIDR only actually does anything if you are
using an accelerator, and KVM has never supported use of accelerators
in guests.  I'm cc'ing David Gibson for his comments on the
compatibility and migration issues.

In any case, given that both move to and move from TIDR will be no-ops
on P10 (for privileged code), I don't think there is a great urgency
for this patch.

Paul.
