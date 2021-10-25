Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EA24395D1
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 14:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbhJYMSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 08:18:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25284 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233040AbhJYMSL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 08:18:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635164149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+svCtaVt5WNCI2a8SFz193AVVTA3zsioLuxmJStxiCQ=;
        b=EM5Jd1UEkYnlVU5tfBYYSf+NEVXck54kyqP+zd3gu4L5GyE6+spFp+hWsxwoXn1nPv1g0V
        WwnZGA1ZFCBy4JotXV3qP3yBLGKZ92V7GDkddrStQJT7jfISk+dQw6M2MYSHDfXmYHXygm
        tM2UAtlGkvVGOejdWKNOWKEjgj2W5KY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-F652IdsXPp-o6xnoSOXtWQ-1; Mon, 25 Oct 2021 08:15:47 -0400
X-MC-Unique: F652IdsXPp-o6xnoSOXtWQ-1
Received: by mail-ed1-f70.google.com with SMTP id u17-20020a50d511000000b003daa3828c13so9680421edi.12
        for <kvm@vger.kernel.org>; Mon, 25 Oct 2021 05:15:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+svCtaVt5WNCI2a8SFz193AVVTA3zsioLuxmJStxiCQ=;
        b=LAEmeZm95QXXy7mngq7eBrwl+XXzqK5rjtpPHu+Oxbh1nznZlGfTUt7SzVUnAVk6Ng
         uzynOv9aLBb9HWmNd3vfYT06Swtzej8X1oZ6+gETDXkms4mnqVoYvKEmv/RFhDvIQKvm
         4sMAlHKbxWaqbrITz4JzzM1av5u/B6vztv0yN/A2Ch2mO1ym2KMiUliVc+XX1if6LI0M
         Xidp2+gT8I8WMBCYZoi/NyFWGuvn1SpAhBdwk2NK6LrxmONRWNH7GOPkbhFltytmMSzR
         W1AOldPgkm5cGVNPxJP7CgxrLFgk2Pa5atviocvJh9g7gxYStb0JFzgzZbM3LiyeldZc
         tk0Q==
X-Gm-Message-State: AOAM530R0gvWp1171Czojf2C1h0qe9MjrGnpZKvNqE9Y/ZK5r0llu4ny
        I6vmiWhNKHZpDHC0XrW1B59VIBSv0A3Hr+3smQAvPtye1a/qiqDZPPuNAI6QgSULp/AdVjuvbP1
        9aaDZqk4AZX2v
X-Received: by 2002:a05:6402:154b:: with SMTP id p11mr27125420edx.325.1635164146462;
        Mon, 25 Oct 2021 05:15:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDQkaV2DZLmhsatpDenQqBwiFxvGX4QeAIC0w9o+HUmXJzTrAE5aWAf8+LKI91JAQC6F09ow==
X-Received: by 2002:a05:6402:154b:: with SMTP id p11mr27125395edx.325.1635164146240;
        Mon, 25 Oct 2021 05:15:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gs8sm759879ejc.84.2021.10.25.05.15.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 05:15:45 -0700 (PDT)
Message-ID: <271063bf-8fa5-1a68-ac48-9c1fa5db38a2@redhat.com>
Date:   Mon, 25 Oct 2021 14:15:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: x86: switch pvclock_gtod_sync_lock to a raw spinlock
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mtosatti@redhat.com, vkuznets@redhat.com,
        syzbot+b282b65c2c68492df769@syzkaller.appspotmail.com
References: <20210330165958.3094759-1-pbonzini@redhat.com>
 <20210330165958.3094759-3-pbonzini@redhat.com>
 <a836f7c1235079f666321e194fe6a6dcc894b197.camel@infradead.org>
 <1b02a06421c17993df337493a68ba923f3bd5c0f.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1b02a06421c17993df337493a68ba923f3bd5c0f.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/21 22:29, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> On the preemption path when updating a Xen guest's runstate times, this
> lock is taken inside the scheduler rq->lock, which is a raw spinlock.
> This was shown in a lockdep warning:
> 
> [   89.138354] =============================
> [   89.138356] [ BUG: Invalid wait context ]
> [   89.138358] 5.15.0-rc5+ #834 Tainted: G S        I E
> [   89.138360] -----------------------------
> [   89.138361] xen_shinfo_test/2575 is trying to lock:
> [   89.138363] ffffa34a0364efd8 (&kvm->arch.pvclock_gtod_sync_lock){....}-{3:3}, at: get_kvmclock_ns+0x1f/0x130 [kvm]
> [   89.138442] other info that might help us debug this:
> [   89.138444] context-{5:5}
> [   89.138445] 4 locks held by xen_shinfo_test/2575:
> [   89.138447]  #0: ffff972bdc3b8108 (&vcpu->mutex){+.+.}-{4:4}, at: kvm_vcpu_ioctl+0x77/0x6f0 [kvm]
> [   89.138483]  #1: ffffa34a03662e90 (&kvm->srcu){....}-{0:0}, at: kvm_arch_vcpu_ioctl_run+0xdc/0x8b0 [kvm]
> [   89.138526]  #2: ffff97331fdbac98 (&rq->__lock){-.-.}-{2:2}, at: __schedule+0xff/0xbd0
> [   89.138534]  #3: ffffa34a03662e90 (&kvm->srcu){....}-{0:0}, at: kvm_arch_vcpu_put+0x26/0x170 [kvm]
> ...
> [   89.138695]  get_kvmclock_ns+0x1f/0x130 [kvm]
> [   89.138734]  kvm_xen_update_runstate+0x14/0x90 [kvm]
> [   89.138783]  kvm_xen_update_runstate_guest+0x15/0xd0 [kvm]
> [   89.138830]  kvm_arch_vcpu_put+0xe6/0x170 [kvm]
> [   89.138870]  kvm_sched_out+0x2f/0x40 [kvm]
> [   89.138900]  __schedule+0x5de/0xbd0
> 
> Fixes: 30b5c851af79 ("KVM: x86/xen: Add support for vCPU runstate information")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>> However, in 5.15-rc5 I'm still seeing the warning below when I run
>> xen_shinfo_test. I confess I'm not entirely sure what it's telling
>> me.
> 
> I think this is what it was telling me...

Yes, indeed - I will commit this to 5.15 (with a 'fake' merge commit to 
kvm/next to inform git that the pvclock_gtod_sync_lock is gone in 5.16 - 
and the replacement is already a raw spinlock for partly unrelated reasons).

Paolo

>   arch/x86/include/asm/kvm_host.h |  2 +-
>   arch/x86/kvm/x86.c              | 28 ++++++++++++++--------------
>   2 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f8f48a7ec577..70771376e246 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1097,7 +1097,7 @@ struct kvm_arch {
>   	u64 cur_tsc_generation;
>   	int nr_vcpus_matched_tsc;
>   
> -	spinlock_t pvclock_gtod_sync_lock;
> +	raw_spinlock_t pvclock_gtod_sync_lock;
>   	bool use_master_clock;
>   	u64 master_kernel_ns;
>   	u64 master_cycle_now;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index aabd3a2ec1bc..f0874c3d12ce 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2542,7 +2542,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>   	kvm_vcpu_write_tsc_offset(vcpu, offset);
>   	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
>   
> -	spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
> +	raw_spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
>   	if (!matched) {
>   		kvm->arch.nr_vcpus_matched_tsc = 0;
>   	} else if (!already_matched) {
> @@ -2550,7 +2550,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>   	}
>   
>   	kvm_track_tsc_matching(vcpu);
> -	spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
> +	raw_spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
>   }
>   
>   static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
> @@ -2780,9 +2780,9 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
>   	kvm_make_mclock_inprogress_request(kvm);
>   
>   	/* no guest entries from this point */
> -	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
> +	raw_spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
>   	pvclock_update_vm_gtod_copy(kvm);
> -	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
> +	raw_spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
>   
>   	kvm_for_each_vcpu(i, vcpu, kvm)
>   		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
> @@ -2800,15 +2800,15 @@ u64 get_kvmclock_ns(struct kvm *kvm)
>   	unsigned long flags;
>   	u64 ret;
>   
> -	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
> +	raw_spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
>   	if (!ka->use_master_clock) {
> -		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
> +		raw_spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
>   		return get_kvmclock_base_ns() + ka->kvmclock_offset;
>   	}
>   
>   	hv_clock.tsc_timestamp = ka->master_cycle_now;
>   	hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
> -	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
> +	raw_spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
>   
>   	/* both __this_cpu_read() and rdtsc() should be on the same cpu */
>   	get_cpu();
> @@ -2902,13 +2902,13 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>   	 * If the host uses TSC clock, then passthrough TSC as stable
>   	 * to the guest.
>   	 */
> -	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
> +	raw_spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
>   	use_master_clock = ka->use_master_clock;
>   	if (use_master_clock) {
>   		host_tsc = ka->master_cycle_now;
>   		kernel_ns = ka->master_kernel_ns;
>   	}
> -	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
> +	raw_spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
>   
>   	/* Keep irq disabled to prevent changes to the clock */
>   	local_irq_save(flags);
> @@ -6100,13 +6100,13 @@ long kvm_arch_vm_ioctl(struct file *filp,
>   		 * is slightly ahead) here we risk going negative on unsigned
>   		 * 'system_time' when 'user_ns.clock' is very small.
>   		 */
> -		spin_lock_irq(&ka->pvclock_gtod_sync_lock);
> +		raw_spin_lock_irq(&ka->pvclock_gtod_sync_lock);
>   		if (kvm->arch.use_master_clock)
>   			now_ns = ka->master_kernel_ns;
>   		else
>   			now_ns = get_kvmclock_base_ns();
>   		ka->kvmclock_offset = user_ns.clock - now_ns;
> -		spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
> +		raw_spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
>   
>   		kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
>   		break;
> @@ -8139,9 +8139,9 @@ static void kvm_hyperv_tsc_notifier(void)
>   	list_for_each_entry(kvm, &vm_list, vm_list) {
>   		struct kvm_arch *ka = &kvm->arch;
>   
> -		spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
> +		raw_spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
>   		pvclock_update_vm_gtod_copy(kvm);
> -		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
> +		raw_spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
>   
>   		kvm_for_each_vcpu(cpu, vcpu, kvm)
>   			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
> @@ -11182,7 +11182,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   
>   	raw_spin_lock_init(&kvm->arch.tsc_write_lock);
>   	mutex_init(&kvm->arch.apic_map_lock);
> -	spin_lock_init(&kvm->arch.pvclock_gtod_sync_lock);
> +	raw_spin_lock_init(&kvm->arch.pvclock_gtod_sync_lock);
>   
>   	kvm->arch.kvmclock_offset = -get_kvmclock_base_ns();
>   	pvclock_update_vm_gtod_copy(kvm);
> 

