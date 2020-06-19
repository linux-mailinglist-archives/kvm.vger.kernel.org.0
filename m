Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BD92008CB
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 14:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732450AbgFSMgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 08:36:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29911 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730721AbgFSMgj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 08:36:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592570197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y1qI9Lu8O6AKxVi/xPQ/l5dr2VXql2gGRHF+/HFBzMk=;
        b=ESdxoavDri13R5CT9r0jylMpbM4Few76SKunPdjyl3XjphaRcjOYqTiXRVzXgzykFX3vvG
        epcYPEeUfdfNeZT/Z4qg+q+SbLHgvqkWDjTGP+DkG77nlknVrNjXxmLpd5cN3NM9AjIBL0
        o7avTNIsp0KxrVT8eRVm7FOS06KtlTk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-2mUE2hZrPLOWkuOcTPZgpg-1; Fri, 19 Jun 2020 08:36:35 -0400
X-MC-Unique: 2mUE2hZrPLOWkuOcTPZgpg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 229BB464;
        Fri, 19 Jun 2020 12:36:34 +0000 (UTC)
Received: from localhost (unknown [10.40.208.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7FB2A60BF4;
        Fri, 19 Jun 2020 12:36:29 +0000 (UTC)
Date:   Fri, 19 Jun 2020 14:36:26 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v3] KVM: LAPIC: Recalculate apic map in batch
Message-ID: <20200619143626.1b326566@redhat.com>
In-Reply-To: <1582684862-10880-1-git-send-email-wanpengli@tencent.com>
References: <1582684862-10880-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 26 Feb 2020 10:41:02 +0800
Wanpeng Li <kernellwp@gmail.com> wrote:

> From: Wanpeng Li <wanpengli@tencent.com>
> 
> In the vCPU reset and set APIC_BASE MSR path, the apic map will be recalculated 
> several times, each time it will consume 10+ us observed by ftrace in my 
> non-overcommit environment since the expensive memory allocate/mutex/rcu etc 
> operations. This patch optimizes it by recaluating apic map in batch, I hope 
> this can benefit the serverless scenario which can frequently create/destroy 
> VMs. 
> 
> Before patch:
> 
> kvm_lapic_reset  ~27us
> 
> After patch:
> 
> kvm_lapic_reset  ~14us 
> 
> Observed by ftrace, improve ~48%.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
this broke CPU hotplug,

qemu-kvm -m 2G -smp 4,maxcpus=8  -monitor stdio
(qemu) device_add qemu64-x86_64-cpu,socket-id=4,core-id=0,thread-id=0

in guest fails with:

 smpboot: do_boot_cpu failed(-1) to wakeup CPU#4

which makes me suspect that  INIT/SIPI wasn't delivered

Is it a know issue?

> ---
> v2 -> v3:
>  * move apic_map_dirty to kvm_arch
>  * add the suggestions from Paolo
> 
> v1 -> v2:
>  * add apic_map_dirty to kvm_lapic
>  * error condition in kvm_apic_set_state, do recalcuate  unconditionally
> 
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/lapic.c            | 46 ++++++++++++++++++++++++++++++++---------
>  arch/x86/kvm/lapic.h            |  1 +
>  arch/x86/kvm/x86.c              |  1 +
>  4 files changed, 39 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 40a0c0f..4380ed1 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -920,6 +920,7 @@ struct kvm_arch {
>  	atomic_t vapics_in_nmi_mode;
>  	struct mutex apic_map_lock;
>  	struct kvm_apic_map *apic_map;
> +	bool apic_map_dirty;
>  
>  	bool apic_access_page_done;
>  	unsigned long apicv_inhibit_reasons;
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index afcd30d..de832aa 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -164,14 +164,28 @@ static void kvm_apic_map_free(struct rcu_head *rcu)
>  	kvfree(map);
>  }
>  
> -static void recalculate_apic_map(struct kvm *kvm)
> +void kvm_recalculate_apic_map(struct kvm *kvm)
>  {
>  	struct kvm_apic_map *new, *old = NULL;
>  	struct kvm_vcpu *vcpu;
>  	int i;
>  	u32 max_id = 255; /* enough space for any xAPIC ID */
>  
> +	if (!kvm->arch.apic_map_dirty) {
> +		/*
> +		 * Read kvm->arch.apic_map_dirty before
> +		 * kvm->arch.apic_map
> +		 */
> +		smp_rmb();
> +		return;
> +	}
> +
>  	mutex_lock(&kvm->arch.apic_map_lock);
> +	if (!kvm->arch.apic_map_dirty) {
> +		/* Someone else has updated the map. */
> +		mutex_unlock(&kvm->arch.apic_map_lock);
> +		return;
> +	}
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm)
>  		if (kvm_apic_present(vcpu))
> @@ -236,6 +250,12 @@ static void recalculate_apic_map(struct kvm *kvm)
>  	old = rcu_dereference_protected(kvm->arch.apic_map,
>  			lockdep_is_held(&kvm->arch.apic_map_lock));
>  	rcu_assign_pointer(kvm->arch.apic_map, new);
> +	/*
> +	 * Write kvm->arch.apic_map before
> +	 * clearing apic->apic_map_dirty
> +	 */
> +	smp_wmb();
> +	kvm->arch.apic_map_dirty = false;
>  	mutex_unlock(&kvm->arch.apic_map_lock);
>  
>  	if (old)
> @@ -257,20 +277,20 @@ static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
>  		else
>  			static_key_slow_inc(&apic_sw_disabled.key);
>  
> -		recalculate_apic_map(apic->vcpu->kvm);
> +		apic->vcpu->kvm->arch.apic_map_dirty = true;
>  	}
>  }
>  
>  static inline void kvm_apic_set_xapic_id(struct kvm_lapic *apic, u8 id)
>  {
>  	kvm_lapic_set_reg(apic, APIC_ID, id << 24);
> -	recalculate_apic_map(apic->vcpu->kvm);
> +	apic->vcpu->kvm->arch.apic_map_dirty = true;
>  }
>  
>  static inline void kvm_apic_set_ldr(struct kvm_lapic *apic, u32 id)
>  {
>  	kvm_lapic_set_reg(apic, APIC_LDR, id);
> -	recalculate_apic_map(apic->vcpu->kvm);
> +	apic->vcpu->kvm->arch.apic_map_dirty = true;
>  }
>  
>  static inline u32 kvm_apic_calc_x2apic_ldr(u32 id)
> @@ -286,7 +306,7 @@ static inline void kvm_apic_set_x2apic_id(struct kvm_lapic *apic, u32 id)
>  
>  	kvm_lapic_set_reg(apic, APIC_ID, id);
>  	kvm_lapic_set_reg(apic, APIC_LDR, ldr);
> -	recalculate_apic_map(apic->vcpu->kvm);
> +	apic->vcpu->kvm->arch.apic_map_dirty = true;
>  }
>  
>  static inline int apic_lvt_enabled(struct kvm_lapic *apic, int lvt_type)
> @@ -1912,7 +1932,7 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  	case APIC_DFR:
>  		if (!apic_x2apic_mode(apic)) {
>  			kvm_lapic_set_reg(apic, APIC_DFR, val | 0x0FFFFFFF);
> -			recalculate_apic_map(apic->vcpu->kvm);
> +			apic->vcpu->kvm->arch.apic_map_dirty = true;
>  		} else
>  			ret = 1;
>  		break;
> @@ -2018,6 +2038,8 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  		break;
>  	}
>  
> +	kvm_recalculate_apic_map(apic->vcpu->kvm);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(kvm_lapic_reg_write);
> @@ -2166,7 +2188,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>  			static_key_slow_dec_deferred(&apic_hw_disabled);
>  		} else {
>  			static_key_slow_inc(&apic_hw_disabled.key);
> -			recalculate_apic_map(vcpu->kvm);
> +			vcpu->kvm->arch.apic_map_dirty = true;
>  		}
>  	}
>  
> @@ -2207,6 +2229,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	if (!apic)
>  		return;
>  
> +	vcpu->kvm->arch.apic_map_dirty = false;
>  	/* Stop the timer in case it's a reset to an active apic */
>  	hrtimer_cancel(&apic->lapic_timer.timer);
>  
> @@ -2258,6 +2281,8 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  
>  	vcpu->arch.apic_arb_prio = 0;
>  	vcpu->arch.apic_attention = 0;
> +
> +	kvm_recalculate_apic_map(vcpu->kvm);
>  }
>  
>  /*
> @@ -2479,17 +2504,18 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	int r;
>  
> -
>  	kvm_lapic_set_base(vcpu, vcpu->arch.apic_base);
>  	/* set SPIV separately to get count of SW disabled APICs right */
>  	apic_set_spiv(apic, *((u32 *)(s->regs + APIC_SPIV)));
>  
>  	r = kvm_apic_state_fixup(vcpu, s, true);
> -	if (r)
> +	if (r) {
> +		kvm_recalculate_apic_map(vcpu->kvm);
>  		return r;
> +	}
>  	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
>  
> -	recalculate_apic_map(vcpu->kvm);
> +	kvm_recalculate_apic_map(vcpu->kvm);
>  	kvm_apic_set_version(vcpu);
>  
>  	apic_update_ppr(apic);
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index ec6fbfe..7581bc2 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -78,6 +78,7 @@ void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
>  void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
>  void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
>  u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
> +void kvm_recalculate_apic_map(struct kvm *kvm);
>  void kvm_apic_set_version(struct kvm_vcpu *vcpu);
>  int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val);
>  int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 79bc995..d3802a2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -350,6 +350,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	}
>  
>  	kvm_lapic_set_base(vcpu, msr_info->data);
> +	kvm_recalculate_apic_map(vcpu->kvm);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_apic_base);

