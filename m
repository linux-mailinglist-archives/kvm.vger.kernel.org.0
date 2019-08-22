Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66BF2992C3
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 14:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733306AbfHVL7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 07:59:33 -0400
Received: from foss.arm.com ([217.140.110.172]:44784 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731156AbfHVL7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 07:59:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27330337;
        Thu, 22 Aug 2019 04:59:32 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74E833F718;
        Thu, 22 Aug 2019 04:59:31 -0700 (PDT)
Date:   Thu, 22 Aug 2019 12:59:23 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org
Subject: Re: [PATCH v2] arm64: KVM: Only skip MMIO insn once
Message-ID: <20190822115923.GA33080@lakrids.cambridge.arm.com>
References: <20190822110305.18035-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822110305.18035-1-drjones@redhat.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 22, 2019 at 01:03:05PM +0200, Andrew Jones wrote:
> If after an MMIO exit to userspace a VCPU is immediately run with an
> immediate_exit request, such as when a signal is delivered or an MMIO
> emulation completion is needed, then the VCPU completes the MMIO
> emulation and immediately returns to userspace. As the exit_reason
> does not get changed from KVM_EXIT_MMIO in these cases we have to
> be careful not to complete the MMIO emulation again, when the VCPU is
> eventually run again, because the emulation does an instruction skip
> (and doing too many skips would be a waste of guest code :-) We need
> to use additional VCPU state to track if the emulation is complete.
> As luck would have it, we already have 'mmio_needed', which even
> appears to be used in this way by other architectures already.
> 
> Fixes: 0d640732dbeb ("arm64: KVM: Skip MMIO insn after emulation")
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Ouch; sorry about this!

I haven't dug too deeply, but from the commit message, the below makes
sense to me. FWIW:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
> v2: move mmio_needed use closer to other mmio state use [maz]
> 
>  virt/kvm/arm/mmio.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
> index a8a6a0c883f1..6af5c91337f2 100644
> --- a/virt/kvm/arm/mmio.c
> +++ b/virt/kvm/arm/mmio.c
> @@ -86,6 +86,12 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  	unsigned int len;
>  	int mask;
>  
> +	/* Detect an already handled MMIO return */
> +	if (unlikely(!vcpu->mmio_needed))
> +		return 0;
> +
> +	vcpu->mmio_needed = 0;
> +
>  	if (!run->mmio.is_write) {
>  		len = run->mmio.len;
>  		if (len > sizeof(unsigned long))
> @@ -188,6 +194,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  	run->mmio.is_write	= is_write;
>  	run->mmio.phys_addr	= fault_ipa;
>  	run->mmio.len		= len;
> +	vcpu->mmio_needed	= 1;
>  
>  	if (!ret) {
>  		/* We handled the access successfully in the kernel. */
> -- 
> 2.18.1
> 
