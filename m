Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF4F8CA85
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 06:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbfHNEqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 00:46:44 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44969 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725265AbfHNEqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 00:46:44 -0400
Received: by mail-pl1-f196.google.com with SMTP id t14so50151541plr.11;
        Tue, 13 Aug 2019 21:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ZPf2xdT7M2M6kWC/jkAslolAwnjrK80p/BTTXTBEiBE=;
        b=f5V25LTN/nXamATHDZQThKMPXwTIAC+Ce2Q8pABA/t9MAApdF9ui93/VFx7X69rYeI
         PTPWchEQ6ZuhdBo86hs5QnyvN+qv6frBgSQqPh8pZKvbFo7ZTilzxygMCxTRkyBG2P+s
         fxVhrCQMyWj+vQYyaXGh9DUj6e3wg1BX8dNclR9URsxVmjVeZXqA/eQfNIbHYTp6CrfQ
         zR/70nwH4tzbdu5wa+5xk+pWznovSJfYmL7zdNckgbpXCZ90p1k+pM7+fd6WvM/sU9Os
         2SCJ6jAcrRQExzPZRpnQAQdVpgVoXO9B2FKqFgsx2FWKKIJ9fQy0iTvLLbrHloyN0sB5
         yNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ZPf2xdT7M2M6kWC/jkAslolAwnjrK80p/BTTXTBEiBE=;
        b=fLrWEVVfPvzBpx5AyxhgI406cM8GrN4qR1sji5JvrwyI9uVcf4HPVCSHCSig0I6XX7
         l8ZLbNZ5cyuiv4ZZenp/ZgrAPVtlRxNCKmK+AcEmI2uht88AK2GRfGyZsCfH8Sel77si
         VFD/0p6D+hb81q2oaoY2dj/LQDmMZizmwuBMNtMIuBFYCrIAh86CJTDxzzXc9TpiokTI
         MHafljRVY1MpL/e5jDQBhyNuS6FPx8dZnLphxyeA5qKHRJqd6Ara9UKbCIiJFacfKqPd
         tmVE2sS7FKuW6I9NpGHQwLtuFCjYWMebGB6hkFajtYFEkkU1PC8LKwDOhv0M4N6Wk47P
         jNxw==
X-Gm-Message-State: APjAAAW0gGGPNt4YG4kFuA2JUfsHon6cCpZyHS883ho2ZU0OeEMHi8tq
        2kVe87ifJ2ZL2PFaCAxV02DY9OXBLbY=
X-Google-Smtp-Source: APXvYqxULd4AVZWMxYzGkTnPlherzCbYa8Fg4e5w0XuicrETYRHRtWmLIbSVb7P7gQ1H9jzdfHbGbw==
X-Received: by 2002:a17:902:f01:: with SMTP id 1mr34669100ply.337.1565758003516;
        Tue, 13 Aug 2019 21:46:43 -0700 (PDT)
Received: from pasglop.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f20sm137966898pgg.56.2019.08.13.21.46.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 21:46:43 -0700 (PDT)
Message-ID: <53a17acd0330bc38190ab36625e48d1727a16fa4.camel@gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: PPC: Book3S HV: Fix race in re-enabling
 XIVE escalation interrupts
From:   Jordan Niethe <jniethe5@gmail.com>
To:     Paul Mackerras <paulus@ozlabs.org>, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Date:   Wed, 14 Aug 2019 14:46:38 +1000
In-Reply-To: <20190813100349.GD9567@blackberry>
References: <20190813095845.GA9567@blackberry>
         <20190813100349.GD9567@blackberry>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.1 (3.30.1-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-08-13 at 20:03 +1000, Paul Mackerras wrote:
> Escalation interrupts are interrupts sent to the host by the XIVE
> hardware when it has an interrupt to deliver to a guest VCPU but that
> VCPU is not running anywhere in the system.  Hence we disable the
> escalation interrupt for the VCPU being run when we enter the guest
> and re-enable it when the guest does an H_CEDE hypercall indicating
> it is idle.
> 
> It is possible that an escalation interrupt gets generated just as we
> are entering the guest.  In that case the escalation interrupt may be
> using a queue entry in one of the interrupt queues, and that queue
> entry may not have been processed when the guest exits with an
> H_CEDE.
> The existing entry code detects this situation and does not clear the
> vcpu->arch.xive_esc_on flag as an indication that there is a pending
> queue entry (if the queue entry gets processed, xive_esc_irq() will
> clear the flag).  There is a comment in the code saying that if the
> flag is still set on H_CEDE, we have to abort the cede rather than
> re-enabling the escalation interrupt, lest we end up with two
> occurrences of the escalation interrupt in the interrupt queue.
> 
> However, the exit code doesn't do that; it aborts the cede in the
> sense
> that vcpu->arch.ceded gets cleared, but it still enables the
> escalation
> interrupt by setting the source's PQ bits to 00.  Instead we need to
> set the PQ bits to 10, indicating that an interrupt has been
> triggered.
> We also need to avoid setting vcpu->arch.xive_esc_on in this case
> (i.e. vcpu->arch.xive_esc_on seen to be set on H_CEDE) because
> xive_esc_irq() will run at some point and clear it, and if we race
> with
> that we may end up with an incorrect result (i.e. xive_esc_on set
> when
> the escalation interrupt has just been handled).
> 
> It is extremely unlikely that having two queue entries would cause
> observable problems; theoretically it could cause queue overflow, but
> the CPU would have to have thousands of interrupts targetted to it
> for
> that to be possible.  However, this fix will also make it possible to
> determine accurately whether there is an unhandled escalation
> interrupt in the queue, which will be needed by the following patch.
> 
> Cc: stable@vger.kernel.org # v4.16+
> Fixes: 9b9b13a6d153 ("KVM: PPC: Book3S HV: Keep XIVE escalation
> interrupt masked unless ceded")
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
> ---
> v2: don't set xive_esc_on if we're not using a XIVE escalation
> interrupt.
> 
>  arch/powerpc/kvm/book3s_hv_rmhandlers.S | 36 +++++++++++++++++++++
> ------------
>  1 file changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> index 337e644..2e7e788 100644
> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> @@ -2831,29 +2831,39 @@ kvm_cede_prodded:
>  kvm_cede_exit:
>  	ld	r9, HSTATE_KVM_VCPU(r13)
>  #ifdef CONFIG_KVM_XICS
> -	/* Abort if we still have a pending escalation */
> +	/* are we using XIVE with single escalation? */
> +	ld	r10, VCPU_XIVE_ESC_VADDR(r9)
> +	cmpdi	r10, 0
> +	beq	3f
> +	li	r6, XIVE_ESB_SET_PQ_00
Would it make sense to put the above instruction down into the 4: label
instead? If we do not branch to 4, r6 is overwriten anyway. 
I think that would save a load when we do not branch to 4. Also it
would mean that you could use r5 everywhere instead of changing it to
r6? 
> +	/*
> +	 * If we still have a pending escalation, abort the cede,
> +	 * and we must set PQ to 10 rather than 00 so that we don't
> +	 * potentially end up with two entries for the escalation
> +	 * interrupt in the XIVE interrupt queue.  In that case
> +	 * we also don't want to set xive_esc_on to 1 here in
> +	 * case we race with xive_esc_irq().
> +	 */
>  	lbz	r5, VCPU_XIVE_ESC_ON(r9)
>  	cmpwi	r5, 0
> -	beq	1f
> +	beq	4f
>  	li	r0, 0
>  	stb	r0, VCPU_CEDED(r9)
> -1:	/* Enable XIVE escalation */
> -	li	r5, XIVE_ESB_SET_PQ_00
> +	li	r6, XIVE_ESB_SET_PQ_10
> +	b	5f
> +4:	li	r0, 1
> +	stb	r0, VCPU_XIVE_ESC_ON(r9)
> +	/* make sure store to xive_esc_on is seen before xive_esc_irq
> runs */
> +	sync
> +5:	/* Enable XIVE escalation */
>  	mfmsr	r0
>  	andi.	r0, r0, MSR_DR		/* in real mode? */
>  	beq	1f
> -	ld	r10, VCPU_XIVE_ESC_VADDR(r9)
> -	cmpdi	r10, 0
> -	beq	3f
> -	ldx	r0, r10, r5
> +	ldx	r0, r10, r6
>  	b	2f
>  1:	ld	r10, VCPU_XIVE_ESC_RADDR(r9)
> -	cmpdi	r10, 0
> -	beq	3f
> -	ldcix	r0, r10, r5
> +	ldcix	r0, r10, r6
>  2:	sync
> -	li	r0, 1
> -	stb	r0, VCPU_XIVE_ESC_ON(r9)
>  #endif /* CONFIG_KVM_XICS */
>  3:	b	guest_exit_cont
>  

