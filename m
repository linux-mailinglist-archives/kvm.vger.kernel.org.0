Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB97426D30
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 17:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242862AbhJHPEG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 11:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242765AbhJHPEE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 11:04:04 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5906AC061755
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 08:02:09 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 75so3371526pga.3
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 08:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b5kFCA4Sqv5n1pkMZ9QWFD00Hw1HCcSsDCNRLCbAoi4=;
        b=O09XgIIyJxGU1JScsnBpGbcucFHriU2sIXhS13J3MwOvptL4vOdqESyqdeY4KUw7c2
         MMCAZGmdxruj+jlMyfWBWm2YDYx8R9Hq8C0VwUIt6fJ0LWv8SEPYp6XUH55p2Tiynufm
         NG/krSNN0zkCIlY2oykqsGdbvuogk+N5ah4Xb8MYlcaP1H/EL/UiPVyTKBf3KJnJbzUy
         PHCKWLsQpiMUE0wtFC19oWJJqWG8h1sUD+INjQfl2RUgKACZaws64IoZjqGWbnr1cQDh
         RkHcZv+50y80LGArbSBEY/dBemW55lPLyJ8jFMHzApxIiVKSYjMT+wPs/+1RYTXpW7Z/
         PeQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b5kFCA4Sqv5n1pkMZ9QWFD00Hw1HCcSsDCNRLCbAoi4=;
        b=hYdWzbePKi3gQkyctxd+lkjl6orf2fvzjMPNaKuGxE0pp1lMzQpvgpv1BdzJeB7H+F
         81XrQjzDSPt0hi25W2/4G/mdxkCd0JTcpL1RUyRO11Sr4HxApVeHJv4397oP0YFz7JwW
         VYVkiLrwmTNf/l0qRvLHhkLT18DFEQehmgVtOApIyitXcARqTli5zgfV4iBkVuxEQgLm
         A5e0FuCH6s9Ej8GcD+GKKcLrCS2msRT7b3YosISJmVn9VNbgtv7KBC7Pv4O89LwD/BOV
         Snnori3jb2O78J3CAvpnxJ/YGtItmL1Wr/gtZQ1gtXmMRV043uKwzS/YKSu4k6wx2fz9
         YTsw==
X-Gm-Message-State: AOAM530Xjcj0rWhIT5xBG00OnJMCpS9gsyasJWKI7BLpUggvnDHO1z7w
        x0XQHIyv12je/4jnGwo/l0GEgw==
X-Google-Smtp-Source: ABdhPJzQztT1vkshWbvA2jei1IGYww+ulxT3Z83ojh7KiFGMvo+cG5AF5glXll1PBSYxOr4R5LyFrQ==
X-Received: by 2002:a63:e10d:: with SMTP id z13mr5055836pgh.375.1633705328605;
        Fri, 08 Oct 2021 08:02:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e8sm3167677pfn.45.2021.10.08.08.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 08:02:08 -0700 (PDT)
Date:   Fri, 8 Oct 2021 15:02:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Atish Patra <atish.patra@wdc.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anup Patel <anup.patel@wdc.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>
Subject: Re: [PATCH v3 5/5] RISC-V: Add SBI HSM extension in KVM
Message-ID: <YWBdbCNQdikbhhBq@google.com>
References: <20211008032036.2201971-1-atish.patra@wdc.com>
 <20211008032036.2201971-6-atish.patra@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008032036.2201971-6-atish.patra@wdc.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 07, 2021, Atish Patra wrote:
> SBI HSM extension allows OS to start/stop harts any time. It also allows
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index c44cabce7dd8..278b4d643e1b 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -133,6 +133,13 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>  	struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
>  	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
>  	struct kvm_cpu_context *reset_cntx = &vcpu->arch.guest_reset_context;
> +	bool loaded;
> +
> +	/* Disable preemption to avoid race with preempt notifiers */

Stating what the code literally does is not a helpful comment, as it doesn't
help the reader understand _why_ preemption needs to be disabled.

> +	preempt_disable();
> +	loaded = (vcpu->cpu != -1);
> +	if (loaded)
> +		kvm_arch_vcpu_put(vcpu);

Oof.  Looks like this pattern was taken from arm64.  Is there really no better
approach to handling this?  I don't see anything in kvm_riscv_reset_vcpu() that
will obviously break if the vCPU is loaded.  If the goal is purely to effect a
CSR reset via kvm_arch_vcpu_load(), then why not just factor out a helper to do
exactly that?

>  
>  	memcpy(csr, reset_csr, sizeof(*csr));
>  
> @@ -144,6 +151,11 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
>  
>  	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
>  	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
> +
> +	/* Reset the guest CSRs for hotplug usecase */
> +	if (loaded)
> +		kvm_arch_vcpu_load(vcpu, smp_processor_id());

If the preempt shenanigans really have to stay, at least use get_cpu()/put_cpu().

> +	preempt_enable();
>  }
>  
>  int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
> @@ -180,6 +192,13 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  
>  void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
>  {
> +	/**
> +	 * vcpu with id 0 is the designated boot cpu.
> +	 * Keep all vcpus with non-zero cpu id in power-off state so that they
> +	 * can brought to online using SBI HSM extension.
> +	 */
> +	if (vcpu->vcpu_idx != 0)
> +		kvm_riscv_vcpu_power_off(vcpu);

Why do this in postcreate?

>  }
>  
>  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index dadee5e61a46..db54ef21168b 100644

...

> +static int kvm_sbi_hsm_vcpu_start(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_cpu_context *reset_cntx;
> +	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
> +	struct kvm_vcpu *target_vcpu;
> +	unsigned long target_vcpuid = cp->a0;
> +
> +	target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, target_vcpuid);
> +	if (!target_vcpu)
> +		return -EINVAL;
> +	if (!target_vcpu->arch.power_off)
> +		return -EALREADY;
> +
> +	reset_cntx = &target_vcpu->arch.guest_reset_context;
> +	/* start address */
> +	reset_cntx->sepc = cp->a1;
> +	/* target vcpu id to start */
> +	reset_cntx->a0 = target_vcpuid;
> +	/* private data passed from kernel */
> +	reset_cntx->a1 = cp->a2;
> +	kvm_make_request(KVM_REQ_VCPU_RESET, target_vcpu);
> +
> +	/* Make sure that the reset request is enqueued before power on */
> +	smp_wmb();

What does this pair with?  I suspect nothing, because AFAICT the code was taken
from arm64.

arm64 has the smp_wmb() in kvm_psci_vcpu_on() to ensure that the vCPU sees the
request if the vCPU sees the change in vcpu->arch.power_off, and so has a
smp_rmb() in kvm_reset_vcpu().

Side topic, how much of arm64 and RISC-V is this similar?  Would it make sense
to find some way for them to share code?

> +	kvm_riscv_vcpu_power_on(target_vcpu);
> +
> +	return 0;
> +}
> +
> +static int kvm_sbi_hsm_vcpu_stop(struct kvm_vcpu *vcpu)
> +{
> +	if ((!vcpu) || (vcpu->arch.power_off))

Too many parentheses, and the NULL vCPU check is unnecessary.

> +		return -EINVAL;
> +
> +	kvm_riscv_vcpu_power_off(vcpu);
> +
> +	return 0;
> +}
> +
