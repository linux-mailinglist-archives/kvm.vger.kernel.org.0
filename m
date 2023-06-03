Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCCA7212C9
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 22:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbjFCUv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Jun 2023 16:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjFCUv6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Jun 2023 16:51:58 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9036DA6;
        Sat,  3 Jun 2023 13:51:56 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1685825514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FYRhO5tm+egQGj0VtLRHygSd1rVDQErSuxLMnzfSdv8=;
        b=0n4CvGExlFAiQOFUYi0WTfQCqKhHk3/3cfXG1uCEype+muRoJY8ntPSFJObHSIG5lyPK2y
        05o9vviiz52SP2Lq28KQ3gL5eaKxKll/hYocC8nhF6V4+P5l2OX0VBU9r4H2FodUY/nN1k
        3jRJ6cCexsq8npqf4Ftza0JePXpisUouT57oUcUMRIi6Jm/oKDFhogNbRagiJV85UtPN5d
        3mpSpOVRIBGPr/hsaBpkh7nOF+oTL1EAz52M48ChogJpUKHKlK37YDlGRu+MJLE7nnGeCX
        7HrEcUsin2F496AlKhi5LY9T1LHNESyK44VIZD2mgshCuhcHIRPNgtxdRTA8CA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1685825514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FYRhO5tm+egQGj0VtLRHygSd1rVDQErSuxLMnzfSdv8=;
        b=q1woBCgZZqp3xbfT7uoawg4xNoNsW6mH9m0273HBQZusqSUq0JaAjouD+KoDG/m+NhCfUZ
        n5cw61h2vqU9NSDw==
To:     Xin Li <xin3.li@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, peterz@infradead.org, andrew.cooper3@citrix.com,
        seanjc@google.com, pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 01/33] x86/traps: let common_interrupt() handle
 IRQ_MOVE_CLEANUP_VECTOR
In-Reply-To: <20230410081438.1750-2-xin3.li@intel.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-2-xin3.li@intel.com>
Date:   Sat, 03 Jun 2023 22:51:54 +0200
Message-ID: <87leh08e1h.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 10 2023 at 01:14, Xin Li wrote:
> IRQ_MOVE_CLEANUP_VECTOR is the only one of the system IRQ vectors that
> is *below* FIRST_SYSTEM_VECTOR. It is a slow path, so just push it
> into common_interrupt() just before the spurious interrupt handling.

This is a complete NOOP on not FRED enabled systems as the IDT entry is
still separate. So this change makes no sense outside of the FRED
universe. Can we pretty please make this consistent?

Aside of that the change comes with zero justification. I can see why
this is done, i.e. to spare range checking in the FRED exception entry
code, but that brings up an interesting question:

IRQ_MOVE_CLEANUP_VECTOR is at vector 0x20 on purpose. 0x20 is the lowest
priority vector so that the following (mostly theoretical) situation
gets resolved:

sysvec_irq_move_cleanup()
  if (is_pending_in_apic_IRR(vector_to_clean_up))
     apic->send_IPI_self(IRQ_MOVE_CLEANUP_VECTOR);

I.e. when for whatever reasons the to be cleaned up vector is still
pending in the local APIC IRR the function retriggers
IRQ_MOVE_CLEANUP_VECTOR and returns. As the pending to be cleaned up
vector has higher priority it gets handled _before_ the cleanup
vector. Otherwise this ends up in a live lock.

So the question is whether FRED is changing that priority scheme or not.

> @@ -248,6 +248,10 @@ DEFINE_IDTENTRY_IRQ(common_interrupt)
>  	desc = __this_cpu_read(vector_irq[vector]);
>  	if (likely(!IS_ERR_OR_NULL(desc))) {
>  		handle_irq(desc, regs);
> +#ifdef CONFIG_SMP
> +	} else if (vector == IRQ_MOVE_CLEANUP_VECTOR) {
> +		sysvec_irq_move_cleanup(regs);

This nests IDTENTRY:

common_interrupt()
  irqentry_enter();
  kvm_set_cpu_l1tf_flush_l1d();
  run_irq_on_irqstack_cond(__common_interrupt, ....)
    __common_interrupt()
        sysvec_irq_move_cleanup()
          irqentry_enter();             <- FAIL
          kvm_set_cpu_l1tf_flush_l1d(); <- WHY again?
          run_sysvec_on_irqstack_cond(__sysvec_irq_move_cleanup);
            __sysvec_irq_move_cleanup();
          irqentry_exit();

It does not matter whether the cleanup vector is a slow path or
not. Regular interrupts are not nesting, period. Exceptions nest, but
IRQ_MOVE_CLEANUP_VECTOR is not an exception and we don't make an
exception for it.

Stop this mindless hackery and clean it up so it is correct for all
variants.

Thanks,

        tglx
