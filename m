Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEDE98F3C
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 11:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731667AbfHVJZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 05:25:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45120 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731436AbfHVJZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 05:25:18 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BFFFD85539;
        Thu, 22 Aug 2019 09:25:17 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A91A61001B36;
        Thu, 22 Aug 2019 09:25:16 +0000 (UTC)
Date:   Thu, 22 Aug 2019 11:25:14 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        mark.rutland@arm.com
Subject: Re: [PATCH] arm64: KVM: Only skip MMIO insn once
Message-ID: <20190822092514.5opwahkjjpqbbayd@kamzik.brq.redhat.com>
References: <20190821195030.2569-1-drjones@redhat.com>
 <177091d5-2d2c-6a75-472c-92702ee98e86@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177091d5-2d2c-6a75-472c-92702ee98e86@kernel.org>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 22 Aug 2019 09:25:17 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 22, 2019 at 09:30:44AM +0100, Marc Zyngier wrote:
> Hi Drew,
> 
> On 21/08/2019 20:50, Andrew Jones wrote:
> > If after an MMIO exit to userspace a VCPU is immediately run with an
> > immediate_exit request, such as when a signal is delivered or an MMIO
> > emulation completion is needed, then the VCPU completes the MMIO
> > emulation and immediately returns to userspace. As the exit_reason
> > does not get changed from KVM_EXIT_MMIO in these cases we have to
> > be careful not to complete the MMIO emulation again, when the VCPU is
> > eventually run again, because the emulation does an instruction skip
> > (and doing too many skips would be a waste of guest code :-) We need
> > to use additional VCPU state to track if the emulation is complete.
> > As luck would have it, we already have 'mmio_needed', which even
> > appears to be used in this way by other architectures already.
> > 
> > Fixes: 0d640732dbeb ("arm64: KVM: Skip MMIO insn after emulation")
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  virt/kvm/arm/arm.c  | 3 ++-
> >  virt/kvm/arm/mmio.c | 1 +
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index 35a069815baf..322cf9030bbe 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -669,7 +669,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  	if (ret)
> >  		return ret;
> >  
> > -	if (run->exit_reason == KVM_EXIT_MMIO) {
> > +	if (vcpu->mmio_needed) {
> > +		vcpu->mmio_needed = 0;
> >  		ret = kvm_handle_mmio_return(vcpu, vcpu->run);
> >  		if (ret)
> >  			return ret;
> > diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
> > index a8a6a0c883f1..2d9b5e064ae0 100644
> > --- a/virt/kvm/arm/mmio.c
> > +++ b/virt/kvm/arm/mmio.c
> > @@ -201,6 +201,7 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
> >  	if (is_write)
> >  		memcpy(run->mmio.data, data_buf, len);
> >  	vcpu->stat.mmio_exit_user++;
> > +	vcpu->mmio_needed	= 1;
> >  	run->exit_reason	= KVM_EXIT_MMIO;
> >  	return 0;
> >  }
> > 
> 
> Thanks for this. That's quite embarrassing. Out of curiosity,
> how was this spotted?

avocado has a guest execution state snapshotting feature. The feature
simply periodically uses QEMU's 'info registers' monitor command while
a guest is running. The monitor command kicks the vcpu to userspace with
a signal, and since avocado's snapshot rate was set relatively high that
increased the probability of causing a noticeable (weird things / guest
crashes) event during guest boot (when MMIO activity is also high). The
signals correlated with guest crashes lead me to this code.

> 
> Patch wise, I'd have a small preference for the following (untested)
> patch, as it keeps the mmio_needed accesses close together, making
> it easier to read (at least for me). What do you think?
> 
> 	M.
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

That looks good to me. Should I repost?

Thanks,
drew
