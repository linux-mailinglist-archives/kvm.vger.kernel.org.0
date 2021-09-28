Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F102B41B9D0
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 00:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243005AbhI1WE7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 18:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242130AbhI1WE6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 18:04:58 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F0BC061746
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 15:03:18 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s11so496208pgr.11
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 15:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HhWJHJzwSlwok1AmtMjKCRhZCZC7gZ0nzg2WuvY1qEE=;
        b=tigZj4v4CeD0329C4UL89vBMNZKnQ83w87+ZjG/BkopVGCTWeqLcdLtmMMMyBh4mY7
         7Dg9uin+BfDKQe3/AO/kBYz/oYXaVu1zZluev925ki7GPxG9RsFR+LVM6CwXOErqWOQ1
         pcncNiTkf8gIAQ18xmLQoQFFSVJjeL/kv9WgotyouEYXoN9oN4CFt1v1v3hF+tD2MuSP
         4hRr4rqTnaTfyQu2hB8T0n1Sl6+dT/y/KrjaEze5I0PN5XK1QLwnll8S68T9w3WOhivA
         8src448DI7RUYdTJ7WPFB9p1z6qh3ARAEdVyO8+kHbRNjGL0an+DZUP9EMoHBQVa5OH2
         UFig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HhWJHJzwSlwok1AmtMjKCRhZCZC7gZ0nzg2WuvY1qEE=;
        b=pOS8305zi6pOiTAbpU2+v62bCmRyB4eI18Q3bABQo1IN0J3T/qN8qEOqg01+mDjBSC
         bD7hpZSlcOWioj5ztQfvxfbgDA9Xq6xI+IArkaBzIudritPbVVY/xhFhwuBHS2PDFOHH
         uOjA7JG25UGeUJyABjwGJbL6w2KBTSWe3NjU8GVhi3pjoIer+AR5xBfOzW6K597lEBn5
         9GnCpU9DodsfuVw9l3zhzOdCsAGLTZTLqcsU+3wd4CTRXvzNpXOric5Ifr3tiLfaJXMK
         4UDqpubEx/1A+YZxCrxfW2zKEwgxpYtcGinBtF+CEGbv4j5OWiEOvbSpuwA1HDnl9hIe
         EA7w==
X-Gm-Message-State: AOAM530Jnx4YC8xTeUTmADeCAK9rqSHYXDwOx46y78y01cEocXG/PcX/
        mVka30YNMLWaSYeLKX9f5WQ8Yu5Ng/0b509S
X-Google-Smtp-Source: ABdhPJz8FBfuYulYfix3SaPNrNClCNKJqQQmFIru90iSEGa1D9tLSPPzdOByJRFDeYbge7PjxYA/EA==
X-Received: by 2002:aa7:980a:0:b0:43e:670:8505 with SMTP id e10-20020aa7980a000000b0043e06708505mr7905502pfl.74.1632866597392;
        Tue, 28 Sep 2021 15:03:17 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id t33sm129606pfg.71.2021.09.28.15.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 15:03:16 -0700 (PDT)
Date:   Tue, 28 Sep 2021 22:03:13 +0000
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 10/14] KVM: Split out a kvm_vcpu_block() helper from
 kvm_vcpu_halt()
Message-ID: <YVORIQVU3Vz/gWUI@google.com>
References: <20210925005528.1145584-1-seanjc@google.com>
 <20210925005528.1145584-11-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210925005528.1145584-11-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 24, 2021 at 05:55:24PM -0700, Sean Christopherson wrote:
> Factor out the "block" part of kvm_vcpu_halt() so that x86 can emulate
> non-halt wait/sleep/block conditions that should not be subjected to
> halt-polling.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/kvm_main.c      | 50 ++++++++++++++++++++++++++++------------
>  2 files changed, 36 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d2a8be3fb9ba..655c2b24db2d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -966,6 +966,7 @@ void kvm_sigset_activate(struct kvm_vcpu *vcpu);
>  void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
>  
>  void kvm_vcpu_halt(struct kvm_vcpu *vcpu);
> +bool kvm_vcpu_block(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu);
>  void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu);
>  bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 280cf1dca7db..fe34457530c2 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3199,6 +3199,34 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> +/*
> + * Block the vCPU until the vCPU is runnable, an event arrives, or a signal is
> + * pending.  This is mostly used when halting a vCPU, but may also be used
> + * directly for other vCPU non-runnable states, e.g. x86's Wait-For-SIPI.
> + */
> +bool kvm_vcpu_block(struct kvm_vcpu *vcpu)
> +{
> +	bool waited = false;
> +
> +	kvm_arch_vcpu_blocking(vcpu);
> +
> +	prepare_to_rcuwait(&vcpu->wait);
> +	for (;;) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +
> +		if (kvm_vcpu_check_block(vcpu) < 0)
> +			break;
> +
> +		waited = true;
> +		schedule();
> +	}
> +	finish_rcuwait(&vcpu->wait);
> +
> +	kvm_arch_vcpu_unblocking(vcpu);
> +
> +	return waited;
> +}
> +
>  static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>  					  ktime_t end, bool success)
>  {
> @@ -3221,6 +3249,12 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>  	}
>  }
>  
> +/*
> + * Emulate a vCPU halt condition, e.g. HLT on x86, WFI on arm, etc...  If halt
> + * polling is enabled, busy wait for a short time before blocking to avoid the
> + * expensive block+unblock sequence if a wake event arrives soon after the vCPU
> + * is halted.
> + */
>  void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>  {
>  	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
> @@ -3245,21 +3279,7 @@ void kvm_vcpu_halt(struct kvm_vcpu *vcpu)
>  		} while (kvm_vcpu_can_poll(cur, stop));
>  	}
>  
> -	kvm_arch_vcpu_blocking(vcpu);
> -
> -	prepare_to_rcuwait(&vcpu->wait);
> -	for (;;) {
> -		set_current_state(TASK_INTERRUPTIBLE);
> -
> -		if (kvm_vcpu_check_block(vcpu) < 0)
> -			break;
> -
> -		waited = true;
> -		schedule();
> -	}
> -	finish_rcuwait(&vcpu->wait);
> -
> -	kvm_arch_vcpu_unblocking(vcpu);
> +	waited = kvm_vcpu_block(vcpu);
>  
>  	cur = ktime_get();
>  	if (waited) {
> -- 
> 2.33.0.685.g46640cef36-goog
> 
