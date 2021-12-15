Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754F3475802
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 12:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhLOLkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 06:40:03 -0500
Received: from foss.arm.com ([217.140.110.172]:49640 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230037AbhLOLkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 06:40:02 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1807BD6E;
        Wed, 15 Dec 2021 03:40:02 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.67.176])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 038E83F774;
        Wed, 15 Dec 2021 03:40:00 -0800 (PST)
Date:   Wed, 15 Dec 2021 11:39:58 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/6] KVM: arm64: Correctly treat writes to OSLSR_EL1
 as undefined
Message-ID: <YbnUDny3GSNpyabJ@FVFF77S0Q05N>
References: <20211214172812.2894560-1-oupton@google.com>
 <20211214172812.2894560-2-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214172812.2894560-2-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Tue, Dec 14, 2021 at 05:28:07PM +0000, Oliver Upton wrote:
> Any valid implementation of the architecture should generate an
> undefined exception for writes to a read-only register, such as
> OSLSR_EL1. Nonetheless, the KVM handler actually implements write-ignore
> behavior.
> 
> Align the trap handler for OSLSR_EL1 with hardware behavior. If such a
> write ever traps to EL2, inject an undef into the guest and print a
> warning.

I think this can still be read amibguously, since we don't explicitly state
that writes to OSLSR_EL1 should never trap (and the implications of being
UNDEFINED are subtle). How about:

| Writes to OSLSR_EL1 are UNDEFINED and should never trap from EL1 to EL2, but
| the KVM trap handler for OSLSR_EL1 handlees writes via ignore_write(). This
| is confusing to readers of the code, but shouldn't have any functional impact.
|
| For clarity, use write_to_read_only() rather than ignore_write(). If a trap
| is unexpectedly taken to EL2 in violation of the architecture, this will
| WARN_ONCE() and inject an undef into the guest.

With that:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e3ec1a44f94d..11b4212c2036 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -292,7 +292,7 @@ static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
>  			   const struct sys_reg_desc *r)
>  {
>  	if (p->is_write) {
> -		return ignore_write(vcpu, p);
> +		return write_to_read_only(vcpu, p, r);
>  	} else {
>  		p->regval = (1 << 3);
>  		return true;
> -- 
> 2.34.1.173.g76aa8bc2d0-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
