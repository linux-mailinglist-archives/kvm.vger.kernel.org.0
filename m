Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296B76BC246
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 01:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbjCPAQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 20:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjCPAQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 20:16:32 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9C65CC30
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 17:16:31 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q68-20020a632a47000000b004f74bc0c71fso4835922pgq.18
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 17:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678925790;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aEOtW/UvBLbs+rdNOst01WJ3Nmt0dr4+Kg7urr3t254=;
        b=RlolKrOV2qpzwBK5xFbGpRrHQKhSRtQtHxriUvZp1S51GSP3QpS68JDYU+IKdBij0K
         GqRDtqrxIQI2GtQh1j458rsQL26utXeMYJR9nW0X8HoI08S3v4u78kNiLPJvY25nr8s+
         b18oQwTWQOtCpauTWNPKb0EHKUTcI7XykFWfwx671axGpbSEAanwd7vwNqJEk5QdRYPs
         CNgIP1dp384kzbLm3UMqJfigMCshKlWY79UOD9/5Ft5L03DNu7+3KewG9lnMnFoF/35+
         lxjGd+F39jFVx0/icIH0p0Csjr8q4Ei7Em7kRXr+XvLx8qENtjC5UcttNRyazXYdKarM
         Xw1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678925790;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aEOtW/UvBLbs+rdNOst01WJ3Nmt0dr4+Kg7urr3t254=;
        b=69BCYxTeCOQn1tDBg9B0dMk+hYBVIHeezcY8xr/lACD9KtH8ozjuFazdyU9di/+Si2
         j435rSRPCtLn3J0M//TLkW7oIocFNQLiRJLsRA6ErpxzOkZgJLP3/9K+Tr5Q7EnqgL8l
         mxTU2ofTnrLNmXlf+cFHh5jbDnm+y7fht+tn0YbCj/JyLjNZu9AMaLybjjpXFgtqKaIy
         TWWytLCuI6DER9TqOX93X5+feg/78NrfDf06UBRhbwv5GCp8zeaWNIkOqBW1KZwfGasg
         G3dAqGpCMKcW7Exvw/wjhTM7tmZjUzsr3NRhsj+qZAln5fDatT0z9pelcuMvKQVJAEwe
         Kheg==
X-Gm-Message-State: AO0yUKWu/2BCh2MPhaMydu8ny2Y+kK2KDr+gLXwclaqOMcNDOnccQzky
        871iNeWQzstvhvxwf7DTjXptn+XFYk4=
X-Google-Smtp-Source: AK7set9pRTpNFmcnx3jEqxce1TOHXrWf9E4JfoqIvt+Pki6qlZ8cK/LW8adBEnN6nY3vWJk/67tekDdto58=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ecc7:b0:19d:1dfe:eac6 with SMTP id
 a7-20020a170902ecc700b0019d1dfeeac6mr615813plh.1.1678925790528; Wed, 15 Mar
 2023 17:16:30 -0700 (PDT)
Date:   Wed, 15 Mar 2023 17:16:29 -0700
In-Reply-To: <20220818202701.3314045-3-dmy@semihalf.com>
Mime-Version: 1.0
References: <20220818202701.3314045-1-dmy@semihalf.com> <20220818202701.3314045-3-dmy@semihalf.com>
Message-ID: <ZBJfuOOioFb0pVB6@google.com>
Subject: Re: [PATCH v3 2/2] KVM: x86/ioapic: Resample the pending state of an
 IRQ when unmasking
From:   Sean Christopherson <seanjc@google.com>
To:     Dmytro Maluka <dmy@semihalf.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>, upstream@semihalf.com,
        Dmitry Torokhov <dtor@google.com>,
        Eddie Dong <eddie.dong@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Looks sane to me, just a bunch of cosmetic comments.  But this really needs input/review
from others.  I/O APIC and level triggered interrupts are not exactly in my wheelhouse.

On Thu, Aug 18, 2022, Dmytro Maluka wrote:
> ---
>  arch/x86/kvm/ioapic.c    | 36 ++++++++++++++++++++++++++++++++++--
>  include/linux/kvm_host.h |  8 ++++++++
>  virt/kvm/eventfd.c       | 39 +++++++++++++++++++++++++++++++++------
>  3 files changed, 75 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index 765943d7cfa5..da7074d9b04e 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -368,8 +368,40 @@ static void ioapic_write_indirect(struct kvm_ioapic *ioapic, u32 val)
>  		if (mask_before != mask_after)
>  			kvm_fire_mask_notifiers(ioapic->kvm, KVM_IRQCHIP_IOAPIC, index, mask_after);
>  		if (e->fields.trig_mode == IOAPIC_LEVEL_TRIG
> -		    && ioapic->irr & (1 << index))
> -			ioapic_service(ioapic, index, false);
> +		    && ioapic->irr & (1 << index)
> +		    && !e->fields.mask
> +		    && !e->fields.remote_irr) {

Can you opportunistically change these to fit the preferred style of putting the &&
on the previous line?  Ignore the file's existing "style", this crud is ancient and
ugly (this goes for all of my comments).

> @@ -1987,6 +1988,13 @@ static inline int kvm_irqfd(struct kvm *kvm, struct kvm_irqfd *args)
>  }
>  
>  static inline void kvm_irqfd_release(struct kvm *kvm) {}
> +
> +static inline bool kvm_notify_irqfd_resampler(struct kvm *kvm,
> +					      unsigned irqchip,
> +					      unsigned pin)

"unsigned int" instead of bare "unsigned"

> +{
> +	return false;
> +}
>  #endif
>  
>  #else
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 61aea70dd888..71f327019f1e 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -55,6 +55,16 @@ irqfd_inject(struct work_struct *work)
>  			    irqfd->gsi, 1, false);
>  }
>  
> +/* Called within kvm->irq_srcu read side. */

Ne need for the comment, let lockdep do the heavy lifting.

> +static void __irqfd_resampler_notify(struct kvm_kernel_irqfd_resampler *resampler)

I don't see a need for the double underscores.  I assume the idea is to convey
that this is called under kvm->irq_srcu, but I just ended up looking for a version
without the underscores.

> +{
> +	struct kvm_kernel_irqfd *irqfd;
> +
> +	list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
> +	    srcu_read_lock_held(&resampler->kvm->irq_srcu))

Align the indentation, i.e.

	struct kvm_kernel_irqfd *irqfd;

	list_for_each_entry_srcu(irqfd, &resampler->list, resampler_link,
				 srcu_read_lock_held(&resampler->kvm->irq_srcu))
		eventfd_signal(irqfd->resamplefd, 1);

> @@ -648,6 +653,28 @@ void kvm_irq_routing_update(struct kvm *kvm)
>  	spin_unlock_irq(&kvm->irqfds.lock);
>  }
>  
> +bool kvm_notify_irqfd_resampler(struct kvm *kvm, unsigned irqchip, unsigned pin)
> +{
> +	struct kvm_kernel_irqfd_resampler *resampler;
> +	int gsi, idx;
> +
> +	idx = srcu_read_lock(&kvm->irq_srcu);
> +	gsi = kvm_irq_map_chip_pin(kvm, irqchip, pin);
> +	if (gsi != -1)

This if-statement needs curly braces, the exemption doesn't apply if there are
multiple blocks? (can't think of the right name at the moment) in the guts of
the if-statement.

> +		list_for_each_entry_srcu(resampler,
> +					 &kvm->irqfds.resampler_list, link,
> +					 srcu_read_lock_held(&kvm->irq_srcu)) {
> +			if (resampler->notifier.gsi == gsi) {
> +				__irqfd_resampler_notify(resampler);
> +				srcu_read_unlock(&kvm->irq_srcu, idx);
> +				return true;
> +			}
> +		}
> +	srcu_read_unlock(&kvm->irq_srcu, idx);
> +
> +	return false;
> +}
> +
>  /*
>   * create a host-wide workqueue for issuing deferred shutdown requests
>   * aggregated from all vm* instances. We need our own isolated
> -- 
> 2.37.1.595.g718a3a8f04-goog
> 
