Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8CA716260E
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 13:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgBRMYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 07:24:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43621 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726116AbgBRMYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 07:24:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582028674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Alk0jrnOiObN+FWCca4O8WmI6pi+lrxEG186wdO2ETU=;
        b=iVomIBds5H7LOeqRZMz6LMaoGSVrqfiGtymOgZfetvvXimnHEIiF4qX+mIXgs1dhF0+FDl
        lvXU+0DznTww0sth/VtXrFn8n0Gtc0kBH5hmZ9CcAzVj/d77WEnLqX7Eon2QwvgxHRHE7z
        +doYHGmg5wNRO5TGfos51d8MiDnhjxM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-48J-ZEhLOlOVSrU6esanSQ-1; Tue, 18 Feb 2020 07:24:32 -0500
X-MC-Unique: 48J-ZEhLOlOVSrU6esanSQ-1
Received: by mail-wr1-f70.google.com with SMTP id s13so10659948wru.7
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 04:24:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Alk0jrnOiObN+FWCca4O8WmI6pi+lrxEG186wdO2ETU=;
        b=oHR1wmoYdqPXgpT67h0g3Lpr2Fm34NJ81ibbkWNB+sTVdRW7SVqBT5RXk6gWmpCa4C
         GOHfBRlwrzSnUN5mx+81+6lrfTj03nwk6Fxa+Db+36QgBRxtu2bE9ARLHscM86sb5Z34
         FU6k2bLulPZ7tRLRPEMDLeqT9T5x4ZVoniSxISp9EmrKEGU6xtQDEaPSWgHSfRJGGVpB
         H7lnejOssKHYa2QZSNuu3k2iwBv0kSXPDrXasclm6rmgwXDJhFlix7eyQ4PWvAJB9nXv
         LxlGJtnRUaNOrIAdeRy/0XbAl2WkImb6ZN3d+4NgiR7vZLh4XOHPzsf133hKuwNtBJz0
         OweA==
X-Gm-Message-State: APjAAAXGM7Kr1NCaPOtx8ucD+UA27svgq7KknUzBWMgtevpoaBW7ZVcg
        pC58ZI2cRUPbBedm2uB0SadpRwE2bm2qtoGxKwg8JZ8zRvlV2RvC79cqdaver8dDyarJhw/hYog
        No6DFNLAS5YQc
X-Received: by 2002:a5d:54c1:: with SMTP id x1mr27796861wrv.240.1582028671232;
        Tue, 18 Feb 2020 04:24:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqyA6FYHGZs9W8wM1Ptra5LE9QNYCipoS6y00ow6TtFfRgHhOk46P7/egIyN2DeCcKZJ5hy21A==
X-Received: by 2002:a5d:54c1:: with SMTP id x1mr27796833wrv.240.1582028670888;
        Tue, 18 Feb 2020 04:24:30 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id x6sm5896535wrr.6.2020.02.18.04.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 04:24:30 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: LAPIC: Recalculate apic map in batch
In-Reply-To: <1582022829-27032-1-git-send-email-wanpengli@tencent.com>
References: <1582022829-27032-1-git-send-email-wanpengli@tencent.com>
Date:   Tue, 18 Feb 2020 13:24:29 +0100
Message-ID: <87zhdg84n6.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> In the vCPU reset and set APIC_BASE MSR path, the apic map will be recalculated 
> several times, each time it will consume 10+ us observed by ftrace in my 
> non-overcommit environment since the expensive memory allocate/mutex/rcu etc 
> operations. This patch optimizes it by recaluating apic map in batch, I hope 
> this can benefit the serverless scenario which can frequently create/destroy 
> VMs.
>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>

An alternative idea: instead of making every caller return bool and
every call site handle the result (once) just add a
KVM_REQ_APIC_MAP_RECALC flag or a boolean flag to struct kvm. I
understand it may not be that easy as it sounds as we may be conunting
on valid mapping somewhere before we actually get to handiling
KVM_REQ_APIC_MAP_RECALC but we may preserve *some*
recalculate_apic_map() calls (and make it reset KVM_REQ_APIC_MAP_RECALC).

> ---
>  arch/x86/kvm/lapic.c | 74 ++++++++++++++++++++++++++++++++++------------------
>  arch/x86/kvm/lapic.h |  3 ++-
>  arch/x86/kvm/x86.c   |  3 ++-
>  3 files changed, 53 insertions(+), 27 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index afcd30d..71f843a 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -164,7 +164,7 @@ static void kvm_apic_map_free(struct rcu_head *rcu)
>  	kvfree(map);
>  }
>  
> -static void recalculate_apic_map(struct kvm *kvm)
> +void kvm_recalculate_apic_map(struct kvm *kvm)
>  {
>  	struct kvm_apic_map *new, *old = NULL;
>  	struct kvm_vcpu *vcpu;
> @@ -244,9 +244,10 @@ static void recalculate_apic_map(struct kvm *kvm)
>  	kvm_make_scan_ioapic_request(kvm);
>  }
>  
> -static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
> +static inline bool apic_set_spiv(struct kvm_lapic *apic, u32 val)
>  {
>  	bool enabled = val & APIC_SPIV_APIC_ENABLED;
> +	bool need_recal = false;
>  
>  	kvm_lapic_set_reg(apic, APIC_SPIV, val);
>  
> @@ -257,20 +258,20 @@ static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
>  		else
>  			static_key_slow_inc(&apic_sw_disabled.key);
>  
> -		recalculate_apic_map(apic->vcpu->kvm);
> +		need_recal = true;
>  	}
> +
> +	return need_recal;
>  }
>  
>  static inline void kvm_apic_set_xapic_id(struct kvm_lapic *apic, u8 id)
>  {
>  	kvm_lapic_set_reg(apic, APIC_ID, id << 24);
> -	recalculate_apic_map(apic->vcpu->kvm);
>  }
>  
>  static inline void kvm_apic_set_ldr(struct kvm_lapic *apic, u32 id)
>  {
>  	kvm_lapic_set_reg(apic, APIC_LDR, id);
> -	recalculate_apic_map(apic->vcpu->kvm);
>  }
>  
>  static inline u32 kvm_apic_calc_x2apic_ldr(u32 id)
> @@ -286,7 +287,6 @@ static inline void kvm_apic_set_x2apic_id(struct kvm_lapic *apic, u32 id)
>  
>  	kvm_lapic_set_reg(apic, APIC_ID, id);
>  	kvm_lapic_set_reg(apic, APIC_LDR, ldr);
> -	recalculate_apic_map(apic->vcpu->kvm);
>  }
>  
>  static inline int apic_lvt_enabled(struct kvm_lapic *apic, int lvt_type)
> @@ -1882,14 +1882,16 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
>  int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  {
>  	int ret = 0;
> +	bool need_recal = false;
>  
>  	trace_kvm_apic_write(reg, val);
>  
>  	switch (reg) {
>  	case APIC_ID:		/* Local APIC ID */
> -		if (!apic_x2apic_mode(apic))
> +		if (!apic_x2apic_mode(apic)) {
>  			kvm_apic_set_xapic_id(apic, val >> 24);
> -		else
> +			need_recal = true;
> +		} else
>  			ret = 1;
>  		break;
>  
> @@ -1903,16 +1905,17 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  		break;
>  
>  	case APIC_LDR:
> -		if (!apic_x2apic_mode(apic))
> +		if (!apic_x2apic_mode(apic)) {
>  			kvm_apic_set_ldr(apic, val & APIC_LDR_MASK);
> -		else
> +			need_recal = true;
> +		} else
>  			ret = 1;
>  		break;
>  
>  	case APIC_DFR:
>  		if (!apic_x2apic_mode(apic)) {
>  			kvm_lapic_set_reg(apic, APIC_DFR, val | 0x0FFFFFFF);
> -			recalculate_apic_map(apic->vcpu->kvm);
> +			need_recal = true;
>  		} else
>  			ret = 1;
>  		break;
> @@ -1921,7 +1924,8 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  		u32 mask = 0x3ff;
>  		if (kvm_lapic_get_reg(apic, APIC_LVR) & APIC_LVR_DIRECTED_EOI)
>  			mask |= APIC_SPIV_DIRECTED_EOI;
> -		apic_set_spiv(apic, val & mask);
> +		if (apic_set_spiv(apic, val & mask))
> +			need_recal = true;
>  		if (!(val & APIC_SPIV_APIC_ENABLED)) {
>  			int i;
>  			u32 lvt_val;
> @@ -2018,6 +2022,9 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  		break;
>  	}
>  
> +	if (need_recal)
> +		kvm_recalculate_apic_map(apic->vcpu->kvm);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(kvm_lapic_reg_write);
> @@ -2143,10 +2150,11 @@ u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu)
>  	return (tpr & 0xf0) >> 4;
>  }
>  
> -void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
> +bool kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>  {
>  	u64 old_value = vcpu->arch.apic_base;
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> +	bool need_recal = false;
>  
>  	if (!apic)
>  		value |= MSR_IA32_APICBASE_BSP;
> @@ -2157,7 +2165,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>  		kvm_update_cpuid(vcpu);
>  
>  	if (!apic)
> -		return;
> +		return need_recal;

Just 'return false;' maybe?

>  
>  	/* update jump label if enable bit changes */
>  	if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE) {
> @@ -2166,12 +2174,14 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>  			static_key_slow_dec_deferred(&apic_hw_disabled);
>  		} else {
>  			static_key_slow_inc(&apic_hw_disabled.key);
> -			recalculate_apic_map(vcpu->kvm);
>  		}
> +		need_recal = true;
>  	}
>  
> -	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE))
> +	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE)) {
>  		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
> +		need_recal = true;
> +	}
>  
>  	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE))
>  		kvm_x86_ops->set_virtual_apic_mode(vcpu);
> @@ -2182,6 +2192,8 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>  	if ((value & MSR_IA32_APICBASE_ENABLE) &&
>  	     apic->base_address != APIC_DEFAULT_PHYS_BASE)
>  		pr_warn_once("APIC base relocation is unsupported by KVM");
> +
> +	return need_recal;
>  }
>  
>  void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
> @@ -2203,6 +2215,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	int i;
> +	bool need_recal = false;
>  
>  	if (!apic)
>  		return;
> @@ -2214,6 +2227,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  		kvm_lapic_set_base(vcpu, APIC_DEFAULT_PHYS_BASE |
>  		                         MSR_IA32_APICBASE_ENABLE);
>  		kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
> +		need_recal = true;
>  	}
>  	kvm_apic_set_version(apic->vcpu);
>  
> @@ -2227,10 +2241,13 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
>  
>  	kvm_lapic_set_reg(apic, APIC_DFR, 0xffffffffU);
> -	apic_set_spiv(apic, 0xff);
> +	if (apic_set_spiv(apic, 0xff))
> +		need_recal = true;
>  	kvm_lapic_set_reg(apic, APIC_TASKPRI, 0);
> -	if (!apic_x2apic_mode(apic))
> +	if (!apic_x2apic_mode(apic)) {
>  		kvm_apic_set_ldr(apic, 0);
> +		need_recal = true;
> +	}
>  	kvm_lapic_set_reg(apic, APIC_ESR, 0);
>  	kvm_lapic_set_reg(apic, APIC_ICR, 0);
>  	kvm_lapic_set_reg(apic, APIC_ICR2, 0);
> @@ -2246,8 +2263,8 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	update_divide_count(apic);
>  	atomic_set(&apic->lapic_timer.pending, 0);
>  	if (kvm_vcpu_is_bsp(vcpu))
> -		kvm_lapic_set_base(vcpu,
> -				vcpu->arch.apic_base | MSR_IA32_APICBASE_BSP);
> +		need_recal = kvm_lapic_set_base(vcpu,
> +					vcpu->arch.apic_base | MSR_IA32_APICBASE_BSP);
>  	vcpu->arch.pv_eoi.msr_val = 0;
>  	apic_update_ppr(apic);
>  	if (vcpu->arch.apicv_active) {
> @@ -2258,6 +2275,9 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  
>  	vcpu->arch.apic_arb_prio = 0;
>  	vcpu->arch.apic_attention = 0;
> +
> +	if (need_recal)
> +		kvm_recalculate_apic_map(vcpu->kvm);
>  }
>  
>  /*
> @@ -2478,18 +2498,22 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	int r;
> +	bool need_recal = false;
>  
> -
> -	kvm_lapic_set_base(vcpu, vcpu->arch.apic_base);
> +	need_recal = kvm_lapic_set_base(vcpu, vcpu->arch.apic_base);
>  	/* set SPIV separately to get count of SW disabled APICs right */
> -	apic_set_spiv(apic, *((u32 *)(s->regs + APIC_SPIV)));
> +	if (apic_set_spiv(apic, *((u32 *)(s->regs + APIC_SPIV))))
> +		need_recal = true;
>  
>  	r = kvm_apic_state_fixup(vcpu, s, true);
> -	if (r)
> +	if (r) {
> +		if (need_recal)
> +			kvm_recalculate_apic_map(vcpu->kvm);

This is an error condition, I'd suggest to drop need_recal check here
and do it unconditionally.

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
> index ec6fbfe..58c07ad 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -76,8 +76,9 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event);
>  u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
>  void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
>  void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
> -void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
> +bool kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
>  u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
> +void kvm_recalculate_apic_map(struct kvm *kvm);
>  void kvm_apic_set_version(struct kvm_vcpu *vcpu);
>  int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val);
>  int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 79bc995..e961e65 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -349,7 +349,8 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			return 1;
>  	}
>  
> -	kvm_lapic_set_base(vcpu, msr_info->data);
> +	if (kvm_lapic_set_base(vcpu, msr_info->data))
> +		kvm_recalculate_apic_map(vcpu->kvm);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_apic_base);

-- 
Vitaly

