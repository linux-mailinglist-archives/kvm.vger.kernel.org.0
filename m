Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD2A8153538
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 17:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgBEQ3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 11:29:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39103 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726359AbgBEQ3g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 11:29:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580920174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B+Mj3/ABbY5xnnRNytbcPUxlZHCIKx/r64rBUY1KC70=;
        b=hKaUsVPDDUOUBgHZMIgKtgpRQoYU0hohG4QmBJ6u19eD2mCAF49izlOXrLyiaeDr+IX5hO
        YetjQpkja4fHtsG6bG07RoM2CZV99bBNLU33mXG+sXMobZ0oagmHy/vnoazT8TUUoNhYSe
        ctJhLezCK5Et1x6R7zRAnUBu77di71c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-RvpDQUn3OnufkMAeaN68hg-1; Wed, 05 Feb 2020 11:29:18 -0500
X-MC-Unique: RvpDQUn3OnufkMAeaN68hg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C13A918C8C00;
        Wed,  5 Feb 2020 16:29:16 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D6658DC00;
        Wed,  5 Feb 2020 16:29:12 +0000 (UTC)
Date:   Wed, 5 Feb 2020 17:29:10 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 27/37] KVM: s390: protvirt: Only sync fmt4 registers
Message-ID: <20200205172910.2437729a.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-28-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-28-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:47 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> A lot of the registers are controlled by the Ultravisor and never
> visible to KVM. Also some registers are overlayed, like gbea is with
> sidad, which might leak data to userspace.
> 
> Hence we sync a minimal set of registers for both SIE formats and then
> check and sync format 2 registers if necessary.
> 
> Also we disable set/get one reg for the same reason. It's an old
> interface anyway.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> [Fixes and patch splitting]
> ---
>  arch/s390/kvm/kvm-s390.c | 116 ++++++++++++++++++++++++---------------
>  1 file changed, 72 insertions(+), 44 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index b9692d722c1e..00a0ce4a3d35 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3444,9 +3444,11 @@ static void kvm_arch_vcpu_ioctl_initial_reset(struct kvm_vcpu *vcpu)
>  	vcpu->arch.sie_block->gcr[0] = CR0_INITIAL_MASK;
>  	vcpu->arch.sie_block->gcr[14] = CR14_INITIAL_MASK;
>  	vcpu->run->s.regs.fpc = 0;
> -	vcpu->arch.sie_block->gbea = 1;
> -	vcpu->arch.sie_block->pp = 0;
> -	vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
> +	if (!kvm_s390_pv_handle_cpu(vcpu)) {
> +		vcpu->arch.sie_block->gbea = 1;
> +		vcpu->arch.sie_block->pp = 0;
> +		vcpu->arch.sie_block->fpf &= ~FPF_BPBC;

What about e.g. gcr[]? Is it something that just does not matter, while
these conflict somehow?

> +	}
>  }
>  
>  static void kvm_arch_vcpu_ioctl_clear_reset(struct kvm_vcpu *vcpu)
> @@ -4057,25 +4059,16 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>  	return rc;
>  }
>  
> -static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> +static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  {
>  	struct runtime_instr_cb *riccb;
>  	struct gs_cb *gscb;
>  
> -	riccb = (struct runtime_instr_cb *) &kvm_run->s.regs.riccb;
> -	gscb = (struct gs_cb *) &kvm_run->s.regs.gscb;
>  	vcpu->arch.sie_block->gpsw.mask = kvm_run->psw_mask;
>  	vcpu->arch.sie_block->gpsw.addr = kvm_run->psw_addr;
> -	if (kvm_run->kvm_dirty_regs & KVM_SYNC_PREFIX)
> -		kvm_s390_set_prefix(vcpu, kvm_run->s.regs.prefix);
> -	if (kvm_run->kvm_dirty_regs & KVM_SYNC_CRS) {
> -		memcpy(&vcpu->arch.sie_block->gcr, &kvm_run->s.regs.crs, 128);
> -		/* some control register changes require a tlb flush */
> -		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> -	}
> +	riccb = (struct runtime_instr_cb *) &kvm_run->s.regs.riccb;
> +	gscb = (struct gs_cb *) &kvm_run->s.regs.gscb;
>  	if (kvm_run->kvm_dirty_regs & KVM_SYNC_ARCH0) {
> -		kvm_s390_set_cpu_timer(vcpu, kvm_run->s.regs.cputm);
> -		vcpu->arch.sie_block->ckc = kvm_run->s.regs.ckc;
>  		vcpu->arch.sie_block->todpr = kvm_run->s.regs.todpr;
>  		vcpu->arch.sie_block->pp = kvm_run->s.regs.pp;
>  		vcpu->arch.sie_block->gbea = kvm_run->s.regs.gbea;
> @@ -4116,6 +4109,47 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  		vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
>  		vcpu->arch.sie_block->fpf |= kvm_run->s.regs.bpbc ? FPF_BPBC : 0;
>  	}
> +	if (MACHINE_HAS_GS) {
> +		preempt_disable();
> +		__ctl_set_bit(2, 4);
> +		if (current->thread.gs_cb) {
> +			vcpu->arch.host_gscb = current->thread.gs_cb;
> +			save_gs_cb(vcpu->arch.host_gscb);
> +		}
> +		if (vcpu->arch.gs_enabled) {
> +			current->thread.gs_cb = (struct gs_cb *)
> +						&vcpu->run->s.regs.gscb;
> +			restore_gs_cb(current->thread.gs_cb);
> +		}
> +		preempt_enable();
> +	}
> +	/* SIE will load etoken directly from SDNX and therefore kvm_run */
> +}
> +
> +static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> +{
> +	/*
> +	 * at several places we have to modify our internal view to not do
> +	 * things that are disallowed by the ultravisor. For example we must

But we are still free to do them for non-protected guests, right?

> +	 * not inject interrupts after specific exits (e.g. 112). We do this

Spell out what 112 is? Emergency call? ;)

> +	 * by turning off the MIE bits of our PSW copy. To avoid getting

What is MIE? The bits controlling machine check, I/O, external
interrupts?

> +	 * validity intercepts, we do only accept the condition code from
> +	 * userspace.
> +	 */
> +	vcpu->arch.sie_block->gpsw.mask &= ~PSW_MASK_CC;
> +	vcpu->arch.sie_block->gpsw.mask |= kvm_run->psw_mask & PSW_MASK_CC;
> +
> +	if (kvm_run->kvm_dirty_regs & KVM_SYNC_PREFIX)
> +		kvm_s390_set_prefix(vcpu, kvm_run->s.regs.prefix);
> +	if (kvm_run->kvm_dirty_regs & KVM_SYNC_CRS) {
> +		memcpy(&vcpu->arch.sie_block->gcr, &kvm_run->s.regs.crs, 128);
> +		/* some control register changes require a tlb flush */
> +		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> +	}
> +	if (kvm_run->kvm_dirty_regs & KVM_SYNC_ARCH0) {
> +		kvm_s390_set_cpu_timer(vcpu, kvm_run->s.regs.cputm);
> +		vcpu->arch.sie_block->ckc = kvm_run->s.regs.ckc;
> +	}
>  	save_access_regs(vcpu->arch.host_acrs);
>  	restore_access_regs(vcpu->run->s.regs.acrs);
>  	/* save host (userspace) fprs/vrs */

Diff reordering makes this a bit hard to review, but it seems
reasonable at a glance.

