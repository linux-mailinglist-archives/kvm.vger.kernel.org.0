Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4EEB589FBF
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 19:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237361AbiHDROf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 13:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235054AbiHDROd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 13:14:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6012C2A26F
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 10:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659633270;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=epnJ9cFtbfykSL5dQTq9BC22fTPD6LWwfsa0Brsgrf4=;
        b=cvj7UVXJ1aB9isX2nOAHoCf9DEH2WOY3B0mhaX5SlYEv5fyNdqm9h8+1/z1tuEXmp7hVZQ
        AzLh2FNbjqD1oqVgdXtGpdkW0vmRlKfF/u/EEFYniZRJTmAdFieHzsjlhPoGhCBt+7Ua87
        kNrF2PKeHizO+ZL/wUdMemhFsixYp8k=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-9nE1NdxIMZat6XI6V-RBew-1; Thu, 04 Aug 2022 13:14:29 -0400
X-MC-Unique: 9nE1NdxIMZat6XI6V-RBew-1
Received: by mail-qk1-f200.google.com with SMTP id m8-20020a05620a24c800b006b5d8eb23efso51259qkn.10
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 10:14:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=epnJ9cFtbfykSL5dQTq9BC22fTPD6LWwfsa0Brsgrf4=;
        b=V3G7U1lYV885sn7gmpvC7rZwzGAKQFGV6W1kVgCSIORDdpIW6iZQfPzx0g7r6pNjBj
         nx94YaigJK7iTY2RlK9zHMXD3dj8VyBiSaNSNT0pTFuJJlfQKrd9GZth1lZWLFFUPCE3
         XZsU8yx6s3JfpB+XID+WrORKIQ1Zsd7HSRWaiWBEUaJnWEM3v9+iCk3ce3LU9kkArlJw
         W97qpcTOv4GepiDL2Bug5Jl3lXIqL/NuM3jGlaxdw3BIUz+/N9MxGXcyKWBBhiaCabzC
         3YNQT7DHC/PR+AqzaX+IpTgY2Faxngjmk9Aw5BEffCVQlxRQN4Kj2lfcfkb4iubScMAr
         uFBg==
X-Gm-Message-State: ACgBeo3sIOBaLecZhIV5IiEAKOoyQPoJyw5MFKn9/CrN3+YclBHjJBf+
        qFGvJ0LsG2HxvnMM+F7GJwia2rhUl6okSCKlelhCo3U6DI0ju7khT8KleOpDjBh/LpKfeJlUwu8
        x199HwsDU+lIv
X-Received: by 2002:ac8:7dc3:0:b0:31f:3305:a4d7 with SMTP id c3-20020ac87dc3000000b0031f3305a4d7mr2431083qte.661.1659633266901;
        Thu, 04 Aug 2022 10:14:26 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4l3Gni56JyTMRMZ+NpwPTtKhOZTsTWjiAA7DqljqQp8+QBYG4ob9T0dsYzua+nZ5zmmw1ieQ==
X-Received: by 2002:ac8:7dc3:0:b0:31f:3305:a4d7 with SMTP id c3-20020ac87dc3000000b0031f3305a4d7mr2431042qte.661.1659633266560;
        Thu, 04 Aug 2022 10:14:26 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id i9-20020ac87649000000b0033d7ea63684sm955316qtr.54.2022.08.04.10.14.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Aug 2022 10:14:25 -0700 (PDT)
Message-ID: <06cdd944-a00c-9dea-192f-7d6156e487fb@redhat.com>
Date:   Thu, 4 Aug 2022 19:14:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 2/3] KVM: x86: Add kvm_irq_is_masked()
Content-Language: en-US
To:     Dmytro Maluka <dmy@semihalf.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>
References: <20220715155928.26362-1-dmy@semihalf.com>
 <20220715155928.26362-3-dmy@semihalf.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220715155928.26362-3-dmy@semihalf.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dmytro

On 7/15/22 17:59, Dmytro Maluka wrote:
> In order to implement postponing resamplefd event until an interrupt is
> unmasked, we need not only to track changes of the interrupt mask state
> (which is made possible by the previous patch "KVM: x86: Move
> kvm_(un)register_irq_mask_notifier() to generic KVM") but also to know
> its initial mask state at the time of registering a resamplefd
it is not obvious to me why the vIRQ is supposed to be masked at
resamplefd registration time. I would have expected the check to be done
in the resamplefd notifier instead (when the vEOI actually happens)?

Eric
> listener. So implement kvm_irq_is_masked() for that.
>
> Actually, for now it's implemented for x86 only (see below).
>
> The implementation is trickier than I'd like it to be, for 2 reasons:
>
> 1. Interrupt (GSI) to irqchip pin mapping is not a 1:1 mapping: an IRQ
>    may map to multiple pins on different irqchips. I guess the only
>    reason for that is to support x86 interrupts 0-15 for which we don't
>    know if the guest uses PIC or IOAPIC. For this reason kvm_set_irq()
>    delivers interrupt to both, assuming the guest will ignore the
>    unused one. For the same reason, in kvm_irq_is_masked() we should
>    also take into account the mask state of both irqchips. We consider
>    an interrupt unmasked if and only if it is unmasked in at least one
>    of PIC or IOAPIC, assuming that in the unused one all the interrupts
>    should be masked.
>
> 2. For now ->is_masked() implemented for x86 only, so need to handle
>    the case when ->is_masked() is not provided by the irqchip. In such
>    case kvm_irq_is_masked() returns failure, and its caller may fall
>    back to an assumption that an interrupt is always unmasked.
>
> Link: https://lore.kernel.org/kvm/31420943-8c5f-125c-a5ee-d2fde2700083@semihalf.com/
> Signed-off-by: Dmytro Maluka <dmy@semihalf.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/i8259.c            | 11 +++++++++++
>  arch/x86/kvm/ioapic.c           | 11 +++++++++++
>  arch/x86/kvm/ioapic.h           |  1 +
>  arch/x86/kvm/irq_comm.c         | 16 ++++++++++++++++
>  include/linux/kvm_host.h        |  3 +++
>  virt/kvm/irqchip.c              | 34 +++++++++++++++++++++++++++++++++
>  7 files changed, 77 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 39a867d68721..64618b890700 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1840,6 +1840,7 @@ static inline int __kvm_irq_line_state(unsigned long *irq_state,
>  
>  int kvm_pic_set_irq(struct kvm_pic *pic, int irq, int irq_source_id, int level);
>  void kvm_pic_clear_all(struct kvm_pic *pic, int irq_source_id);
> +bool kvm_pic_irq_is_masked(struct kvm_pic *pic, int irq);
>  
>  void kvm_inject_nmi(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> index e1bb6218bb96..2d1ed3bc7cc5 100644
> --- a/arch/x86/kvm/i8259.c
> +++ b/arch/x86/kvm/i8259.c
> @@ -211,6 +211,17 @@ void kvm_pic_clear_all(struct kvm_pic *s, int irq_source_id)
>  	pic_unlock(s);
>  }
>  
> +bool kvm_pic_irq_is_masked(struct kvm_pic *s, int irq)
> +{
> +	bool ret;
> +
> +	pic_lock(s);
> +	ret = !!(s->pics[irq >> 3].imr & (1 << irq));
> +	pic_unlock(s);
> +
> +	return ret;
> +}
> +
>  /*
>   * acknowledge interrupt 'irq'
>   */
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index 765943d7cfa5..874f68a65c87 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -478,6 +478,17 @@ void kvm_ioapic_clear_all(struct kvm_ioapic *ioapic, int irq_source_id)
>  	spin_unlock(&ioapic->lock);
>  }
>  
> +bool kvm_ioapic_irq_is_masked(struct kvm_ioapic *ioapic, int irq)
> +{
> +	bool ret;
> +
> +	spin_lock(&ioapic->lock);
> +	ret = !!ioapic->redirtbl[irq].fields.mask;
> +	spin_unlock(&ioapic->lock);
> +
> +	return ret;
> +}
> +
>  static void kvm_ioapic_eoi_inject_work(struct work_struct *work)
>  {
>  	int i;
> diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
> index 539333ac4b38..fe1f51319992 100644
> --- a/arch/x86/kvm/ioapic.h
> +++ b/arch/x86/kvm/ioapic.h
> @@ -114,6 +114,7 @@ void kvm_ioapic_destroy(struct kvm *kvm);
>  int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int irq_source_id,
>  		       int level, bool line_status);
>  void kvm_ioapic_clear_all(struct kvm_ioapic *ioapic, int irq_source_id);
> +bool kvm_ioapic_irq_is_masked(struct kvm_ioapic *ioapic, int irq);
>  void kvm_get_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
>  void kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state);
>  void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index 43e13892ed34..5bff6d6ac54f 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -34,6 +34,13 @@ static int kvm_set_pic_irq(struct kvm_kernel_irq_routing_entry *e,
>  	return kvm_pic_set_irq(pic, e->irqchip.pin, irq_source_id, level);
>  }
>  
> +static bool kvm_is_masked_pic_irq(struct kvm_kernel_irq_routing_entry *e,
> +				     struct kvm *kvm)
> +{
> +	struct kvm_pic *pic = kvm->arch.vpic;
> +	return kvm_pic_irq_is_masked(pic, e->irqchip.pin);
> +}
> +
>  static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
>  			      struct kvm *kvm, int irq_source_id, int level,
>  			      bool line_status)
> @@ -43,6 +50,13 @@ static int kvm_set_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
>  				line_status);
>  }
>  
> +static bool kvm_is_masked_ioapic_irq(struct kvm_kernel_irq_routing_entry *e,
> +				     struct kvm *kvm)
> +{
> +	struct kvm_ioapic *ioapic = kvm->arch.vioapic;
> +	return kvm_ioapic_irq_is_masked(ioapic, e->irqchip.pin);
> +}
> +
>  int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
>  		struct kvm_lapic_irq *irq, struct dest_map *dest_map)
>  {
> @@ -275,11 +289,13 @@ int kvm_set_routing_entry(struct kvm *kvm,
>  			if (ue->u.irqchip.pin >= PIC_NUM_PINS / 2)
>  				return -EINVAL;
>  			e->set = kvm_set_pic_irq;
> +			e->is_masked = kvm_is_masked_pic_irq;
>  			break;
>  		case KVM_IRQCHIP_IOAPIC:
>  			if (ue->u.irqchip.pin >= KVM_IOAPIC_NUM_PINS)
>  				return -EINVAL;
>  			e->set = kvm_set_ioapic_irq;
> +			e->is_masked = kvm_is_masked_ioapic_irq;
>  			break;
>  		default:
>  			return -EINVAL;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 9e12ef503157..e8bfb3b0d4d1 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -625,6 +625,8 @@ struct kvm_kernel_irq_routing_entry {
>  	int (*set)(struct kvm_kernel_irq_routing_entry *e,
>  		   struct kvm *kvm, int irq_source_id, int level,
>  		   bool line_status);
> +	bool (*is_masked)(struct kvm_kernel_irq_routing_entry *e,
> +			  struct kvm *kvm);
>  	union {
>  		struct {
>  			unsigned irqchip;
> @@ -1598,6 +1600,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *irq_entry, struct kvm *kvm,
>  int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
>  			       struct kvm *kvm, int irq_source_id,
>  			       int level, bool line_status);
> +int kvm_irq_is_masked(struct kvm *kvm, int irq, bool *masked);
>  bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin);
>  void kvm_notify_acked_gsi(struct kvm *kvm, int gsi);
>  void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin);
> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> index 58e4f88b2b9f..9252ebedba55 100644
> --- a/virt/kvm/irqchip.c
> +++ b/virt/kvm/irqchip.c
> @@ -97,6 +97,40 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
>  	return ret;
>  }
>  
> +/*
> + * Return value:
> + *  = 0   Interrupt mask state successfully written to `masked`
> + *  < 0   Failed to read interrupt mask state
> + */
> +int kvm_irq_is_masked(struct kvm *kvm, int irq, bool *masked)
> +{
> +	struct kvm_kernel_irq_routing_entry irq_set[KVM_NR_IRQCHIPS];
> +	int ret = -1, i, idx;
> +
> +	/* Not possible to detect if the guest uses the PIC or the
> +	 * IOAPIC. So assume the interrupt to be unmasked iff it is
> +	 * unmasked in at least one of both.
> +	 */
> +	idx = srcu_read_lock(&kvm->irq_srcu);
> +	i = kvm_irq_map_gsi(kvm, irq_set, irq);
> +	srcu_read_unlock(&kvm->irq_srcu, idx);
> +
> +	while (i--) {
> +		if (!irq_set[i].is_masked)
> +			continue;
> +
> +		if (!irq_set[i].is_masked(&irq_set[i], kvm)) {
> +			*masked = false;
> +			return 0;
> +		}
> +		ret = 0;
> +	}
> +	if (!ret)
> +		*masked = true;
> +
> +	return ret;
> +}
> +
>  static void free_irq_routing_table(struct kvm_irq_routing_table *rt)
>  {
>  	int i;

