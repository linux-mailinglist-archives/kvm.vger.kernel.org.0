Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46427175FB7
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 17:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgCBQc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 11:32:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41235 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727101AbgCBQc5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 11:32:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583166775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X9rcUbisKxxmFlt7qW9aNoQqeqD9jDa6T4zDyj5oRUY=;
        b=Vf/1v0TFP383X4KR7W/gVj0w8uIQO1c+No/hYLlVSfB18Q70rVuI/asAIAQDdU86JFXUck
        YNrKu5HriHdzw67GFUV8B2L4r56D5TB7Bs0JI1si8XuhYt12UZAig8qoB30twevok6YgFw
        wLEgxbcWAApy77mWCDFGidf9amuxq/M=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-zIGqNtNcMwmWog2R2-O2UA-1; Mon, 02 Mar 2020 11:32:53 -0500
X-MC-Unique: zIGqNtNcMwmWog2R2-O2UA-1
Received: by mail-wm1-f69.google.com with SMTP id b67so13509wmb.8
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 08:32:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X9rcUbisKxxmFlt7qW9aNoQqeqD9jDa6T4zDyj5oRUY=;
        b=qD7+TG/Hklfk/URmeKCWqRZEgtPlj+zwI3IwhAAEuYUqzBtrPCDIYQPSUYjzw601fj
         avNCDkK9LyuiT0smmyOd6CgHHNNOgaW/sjMbrpJ9nSZRtkWO6aItmxFWxBUH3dy9TF7j
         Vk+t3yQL7ZENdtqLOenZ9ikieXKBvAg9SqadgahHIFnQo+tSOpYdhRJaEdVEHH+Koobr
         lNYbcRFEhvd8tjYvt/JYnhHvAK/Hih8rdccUSDbdVHC72Gy1or3tRhzi2w4wfZz0ZHeF
         i/oUDDtbAtiQiV3MUYyjrBFtv51ewf6KrIXyIN6fDfOukNU5Os+8iHYL7/0N1nXiCaw4
         Pu5w==
X-Gm-Message-State: ANhLgQ3PMOsG1N2JXBFqs2M4yQebDypf8ISKcM5+pitwevZqgdxxW8oP
        sEqSLG92q9Ly4pe6cqyhAGQ1pvW9lJhEsFIValTGRDu6mizCBc/Pc7OgR/lZBclLz490lHBSPCT
        Nkll3i19+yt7w
X-Received: by 2002:a5d:4443:: with SMTP id x3mr360687wrr.379.1583166771754;
        Mon, 02 Mar 2020 08:32:51 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvuZEjb6Nr8Jrwbslhtq5FeU7KvE06qDYUKp17eJgGVM+1Fh2zFoywyfkUqFHbCBpG23lH0lg==
X-Received: by 2002:a5d:4443:: with SMTP id x3mr360656wrr.379.1583166771449;
        Mon, 02 Mar 2020 08:32:51 -0800 (PST)
Received: from [192.168.178.40] ([151.30.85.6])
        by smtp.gmail.com with ESMTPSA id s15sm973084wrr.45.2020.03.02.08.32.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 08:32:50 -0800 (PST)
Subject: Re: [PATCH v3] KVM: LAPIC: Recalculate apic map in batch
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1582684862-10880-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <441ae2d3-cece-2c74-900c-22c7fa7ff373@redhat.com>
Date:   Mon, 2 Mar 2020 17:32:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1582684862-10880-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/02/20 03:41, Wanpeng Li wrote:
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
> 

Queued, thanks.

Paolo

