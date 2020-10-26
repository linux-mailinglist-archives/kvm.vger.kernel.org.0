Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F09298F1B
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 15:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780805AbgJZOWG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 10:22:06 -0400
Received: from foss.arm.com ([217.140.110.172]:40792 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1780743AbgJZOWF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 10:22:05 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FD4530E;
        Mon, 26 Oct 2020 07:22:05 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.56.187])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E35753F68F;
        Mon, 26 Oct 2020 07:22:03 -0700 (PDT)
Date:   Mon, 26 Oct 2020 14:22:01 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 07/11] KVM: arm64: Inject AArch64 exceptions from HYP
Message-ID: <20201026142201.GH12454@C02TD0UTHF1T.local>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-8-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026133450.73304-8-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 26, 2020 at 01:34:46PM +0000, Marc Zyngier wrote:
> Move the AArch64 exception injection code from EL1 to HYP, leaving
> only the ESR_EL1 updates to EL1. In order to come with the differences
> between VHE and nVHE, two set of system register accessors are provided.
> 
> SPSR, ELR, PC and PSTATE are now completely handled in the hypervisor.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

>  void kvm_inject_exception(struct kvm_vcpu *vcpu)
>  {
> +	switch (vcpu->arch.flags & KVM_ARM64_EXCEPT_MASK) {
> +	case KVM_ARM64_EXCEPT_AA64_EL1_SYNC:
> +		enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
> +		break;
> +	case KVM_ARM64_EXCEPT_AA64_EL1_IRQ:
> +		enter_exception64(vcpu, PSR_MODE_EL1h, except_type_irq);
> +		break;
> +	case KVM_ARM64_EXCEPT_AA64_EL1_FIQ:
> +		enter_exception64(vcpu, PSR_MODE_EL1h, except_type_fiq);
> +		break;
> +	case KVM_ARM64_EXCEPT_AA64_EL1_SERR:
> +		enter_exception64(vcpu, PSR_MODE_EL1h, except_type_serror);
> +		break;
> +	default:
> +		/* EL2 are unimplemented until we get NV. One day. */
> +		break;
> +	}
>  }

Huh, we're going to allow EL1 to inject IRQ/FIQ/SERROR *exceptions*
directly, rather than pending those via HCR_EL2.{VI,VF,VSE}? We never
used to have code to do that.

If we're going to support that we'll need to check against the DAIF bits
to make sure we don't inject an exception that can't be architecturally
taken. 

I guess we'll tighten that up along with the synchronous exception
checks, but given those three cases aren't needed today it might be
worth removing them from the switch for now and/or adding a comment to
that effect.

Thanks,
Mark.
