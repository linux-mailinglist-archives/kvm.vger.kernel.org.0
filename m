Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17258298ED0
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 15:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780938AbgJZOEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 10:04:40 -0400
Received: from foss.arm.com ([217.140.110.172]:40292 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1780184AbgJZOEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 10:04:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 894B230E;
        Mon, 26 Oct 2020 07:04:39 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.56.187])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 180C33F68F;
        Mon, 26 Oct 2020 07:04:37 -0700 (PDT)
Date:   Mon, 26 Oct 2020 14:04:35 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 03/11] KVM: arm64: Make kvm_skip_instr() and co private
 to HYP
Message-ID: <20201026140435.GE12454@C02TD0UTHF1T.local>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026133450.73304-4-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 26, 2020 at 01:34:42PM +0000, Marc Zyngier wrote:
> In an effort to remove the vcpu PC manipulations from EL1 on nVHE
> systems, move kvm_skip_instr() to be HYP-specific. EL1's intent
> to increment PC post emulation is now signalled via a flag in the
> vcpu structure.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

[...]

> +/*
> + * Adjust the guest PC on entry, depending on flags provided by EL1
> + * for the purpose of emulation (MMIO, sysreg).
> + */
> +static inline void __adjust_pc(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu->arch.flags & KVM_ARM64_INCREMENT_PC) {
> +		kvm_skip_instr(vcpu);
> +		vcpu->arch.flags &= ~KVM_ARM64_INCREMENT_PC;
> +	}
> +}

What's your plan for restricting *when* EL1 can ask for the PC to be
adjusted?

I'm assuming that either:

1. You have EL2 sanity-check all responses from EL1 are permitted for
   the current state. e.g. if EL1 asks to increment the PC, EL2 must
   check that that was a sane response for the current state.

2. You raise the level of abstraction at the EL2/EL1 boundary, such that
   EL2 simply knows. e.g. if emulating a memory access, EL1 can either
   provide the response or signal an abort, but doesn't choose to
   manipulate the PC as EL2 will infer the right thing to do.

I know that either are tricky in practice, so I'm curious what your view
is. Generally option #2 is easier to fortify, but I guess we might have
to do #1 since we also have to support unprotected VMs?

Thanks,
Mark.
