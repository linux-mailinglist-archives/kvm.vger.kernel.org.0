Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E58E41CC43
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 21:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346017AbhI2TDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 15:03:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22473 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345276AbhI2TDs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Sep 2021 15:03:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632942127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D8U60ISq1y5SlUXr1QirjUex5im4CPJVjD57FbSFIbw=;
        b=CLNiABDHvZGqhz4PDiyh0ngdGlqMjq8TguouqWO4Yp97cLi1EeH7WWXg9hZGmxOpDEURen
        muFPRQ+AlRQb7M3LfqNLNcx7jciRZ2Bh3j3bWRrhro1XjRCaaTZFv5mDoMKRBSFFiFCAHI
        nFTUevg232ioAg6Qj/NDAEwj9ZxcxlM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-eSy049SlOQ2v_6f24bHcQQ-1; Wed, 29 Sep 2021 15:02:01 -0400
X-MC-Unique: eSy049SlOQ2v_6f24bHcQQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8654824FB3;
        Wed, 29 Sep 2021 19:01:58 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-3.gru2.redhat.com [10.97.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 254C51009962;
        Wed, 29 Sep 2021 19:01:58 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 9593F416CE79; Wed, 29 Sep 2021 15:56:29 -0300 (-03)
Date:   Wed, 29 Sep 2021 15:56:29 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v8 4/7] KVM: x86: Report host tsc and realtime values in
 KVM_GET_CLOCK
Message-ID: <20210929185629.GA10933@fuller.cnet>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-5-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916181538.968978-5-oupton@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Oliver,

Do you have any numbers for the improvement in guests CLOCK_REALTIME
accuracy across migration, when this is in place?

On Thu, Sep 16, 2021 at 06:15:35PM +0000, Oliver Upton wrote:
> Handling the migration of TSCs correctly is difficult, in part because
> Linux does not provide userspace with the ability to retrieve a (TSC,
> realtime) clock pair for a single instant in time. In lieu of a more
> convenient facility, KVM can report similar information in the kvm_clock
> structure.
> 
> Provide userspace with a host TSC & realtime pair iff the realtime clock
> is based on the TSC. If userspace provides KVM_SET_CLOCK with a valid
> realtime value, advance the KVM clock by the amount of elapsed time. Do
> not step the KVM clock backwards, though, as it is a monotonic
> oscillator.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  Documentation/virt/kvm/api.rst  | 42 ++++++++++++++++++++++++++-------
>  arch/x86/include/asm/kvm_host.h |  3 +++
>  arch/x86/kvm/x86.c              | 36 +++++++++++++++++++++-------
>  include/uapi/linux/kvm.h        |  7 +++++-
>  4 files changed, 70 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index a6729c8cf063..d0b9c986cf6c 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -993,20 +993,34 @@ such as migration.
>  When KVM_CAP_ADJUST_CLOCK is passed to KVM_CHECK_EXTENSION, it returns the
>  set of bits that KVM can return in struct kvm_clock_data's flag member.
>  
> -The only flag defined now is KVM_CLOCK_TSC_STABLE.  If set, the returned
> -value is the exact kvmclock value seen by all VCPUs at the instant
> -when KVM_GET_CLOCK was called.  If clear, the returned value is simply
> -CLOCK_MONOTONIC plus a constant offset; the offset can be modified
> -with KVM_SET_CLOCK.  KVM will try to make all VCPUs follow this clock,
> -but the exact value read by each VCPU could differ, because the host
> -TSC is not stable.
> +FLAGS:
> +
> +KVM_CLOCK_TSC_STABLE.  If set, the returned value is the exact kvmclock
> +value seen by all VCPUs at the instant when KVM_GET_CLOCK was called.
> +If clear, the returned value is simply CLOCK_MONOTONIC plus a constant
> +offset; the offset can be modified with KVM_SET_CLOCK.  KVM will try
> +to make all VCPUs follow this clock, but the exact value read by each
> +VCPU could differ, because the host TSC is not stable.
> +
> +KVM_CLOCK_REALTIME.  If set, the `realtime` field in the kvm_clock_data
> +structure is populated with the value of the host's real time
> +clocksource at the instant when KVM_GET_CLOCK was called. If clear,
> +the `realtime` field does not contain a value.
> +
> +KVM_CLOCK_HOST_TSC.  If set, the `host_tsc` field in the kvm_clock_data
> +structure is populated with the value of the host's timestamp counter (TSC)
> +at the instant when KVM_GET_CLOCK was called. If clear, the `host_tsc` field
> +does not contain a value.
>  
>  ::
>  
>    struct kvm_clock_data {
>  	__u64 clock;  /* kvmclock current value */
>  	__u32 flags;
> -	__u32 pad[9];
> +	__u32 pad0;
> +	__u64 realtime;
> +	__u64 host_tsc;
> +	__u32 pad[4];
>    };
>  
>  
> @@ -1023,12 +1037,22 @@ Sets the current timestamp of kvmclock to the value specified in its parameter.
>  In conjunction with KVM_GET_CLOCK, it is used to ensure monotonicity on scenarios
>  such as migration.
>  
> +FLAGS:
> +
> +KVM_CLOCK_REALTIME.  If set, KVM will compare the value of the `realtime` field
> +with the value of the host's real time clocksource at the instant when
> +KVM_SET_CLOCK was called. The difference in elapsed time is added to the final
> +kvmclock value that will be provided to guests.
> +
>  ::
>  
>    struct kvm_clock_data {
>  	__u64 clock;  /* kvmclock current value */
>  	__u32 flags;
> -	__u32 pad[9];
> +	__u32 pad0;
> +	__u64 realtime;
> +	__u64 host_tsc;
> +	__u32 pad[4];
>    };
>  
>  
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index be6805fc0260..9c34b5b63e39 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1936,4 +1936,7 @@ int kvm_cpu_dirty_log_size(void);
>  
>  int alloc_all_memslots_rmaps(struct kvm *kvm);
>  
> +#define KVM_CLOCK_VALID_FLAGS						\
> +	(KVM_CLOCK_TSC_STABLE | KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC)
> +
>  #endif /* _ASM_X86_KVM_HOST_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 523c4e5c109f..cb5d5cad5124 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2815,10 +2815,20 @@ static void get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
>  	get_cpu();
>  
>  	if (__this_cpu_read(cpu_tsc_khz)) {
> +#ifdef CONFIG_X86_64
> +		struct timespec64 ts;
> +
> +		if (kvm_get_walltime_and_clockread(&ts, &data->host_tsc)) {
> +			data->realtime = ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec;
> +			data->flags |= KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC;
> +		} else
> +#endif
> +		data->host_tsc = rdtsc();
> +
>  		kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
>  				   &hv_clock.tsc_shift,
>  				   &hv_clock.tsc_to_system_mul);
> -		data->clock = __pvclock_read_cycles(&hv_clock, rdtsc());
> +		data->clock = __pvclock_read_cycles(&hv_clock, data->host_tsc);
>  	} else {
>  		data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
>  	}
> @@ -4062,7 +4072,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		r = KVM_SYNC_X86_VALID_FIELDS;
>  		break;
>  	case KVM_CAP_ADJUST_CLOCK:
> -		r = KVM_CLOCK_TSC_STABLE;
> +		r = KVM_CLOCK_VALID_FLAGS;
>  		break;
>  	case KVM_CAP_X86_DISABLE_EXITS:
>  		r |=  KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_PAUSE |
> @@ -5859,12 +5869,12 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_arch *ka = &kvm->arch;
>  	struct kvm_clock_data data;
> -	u64 now_ns;
> +	u64 now_raw_ns;
>  
>  	if (copy_from_user(&data, argp, sizeof(data)))
>  		return -EFAULT;
>  
> -	if (data.flags)
> +	if (data.flags & ~KVM_CLOCK_REALTIME)
>  		return -EINVAL;
>  
>  	kvm_hv_invalidate_tsc_page(kvm);
> @@ -5878,11 +5888,21 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
>  	 * is slightly ahead) here we risk going negative on unsigned
>  	 * 'system_time' when 'data.clock' is very small.
>  	 */
> -	if (kvm->arch.use_master_clock)
> -		now_ns = ka->master_kernel_ns;
> +	if (data.flags & KVM_CLOCK_REALTIME) {
> +		u64 now_real_ns = ktime_get_real_ns();
> +
> +		/*
> +		 * Avoid stepping the kvmclock backwards.
> +		 */
> +		if (now_real_ns > data.realtime)
> +			data.clock += now_real_ns - data.realtime;
> +	}

Forward jumps can also cause problems, for example:

* Kernel watchdogs

* https://patchwork.ozlabs.org/project/qemu-devel/patch/20130618233825.GA19042@amt.cnet/

So perhaps limiting the amount of forward jump that is allowed 
would be a good thing? (which can happen if the two hosts realtime
clocks are off).

Now by how much, i am not sure.

Or, as mentioned earlier, only enable KVM_CLOCK_REALTIME if userspace
KVM code checks clock synchronization.

Thomas, CC'ed, has deeper understanding of problems with 
forward time jumps than I do. Thomas, any comments?

As a note: this makes it not OK to use KVM_CLOCK_REALTIME flag 
for either vm pause / vm resume (well, if paused for long periods of time) 
or savevm / restorevm.

> +	if (ka->use_master_clock)
> +		now_raw_ns = ka->master_kernel_ns;
>  	else
> -		now_ns = get_kvmclock_base_ns();
> -	ka->kvmclock_offset = data.clock - now_ns;
> +		now_raw_ns = get_kvmclock_base_ns();
> +	ka->kvmclock_offset = data.clock - now_raw_ns;
>  	kvm_end_pvclock_update(kvm);
>  	return 0;
>  }
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index a067410ebea5..d228bf394465 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1223,11 +1223,16 @@ struct kvm_irqfd {
>  
>  /* Do not use 1, KVM_CHECK_EXTENSION returned it before we had flags.  */
>  #define KVM_CLOCK_TSC_STABLE		2
> +#define KVM_CLOCK_REALTIME		(1 << 2)
> +#define KVM_CLOCK_HOST_TSC		(1 << 3)
>  
>  struct kvm_clock_data {
>  	__u64 clock;
>  	__u32 flags;
> -	__u32 pad[9];
> +	__u32 pad0;
> +	__u64 realtime;
> +	__u64 host_tsc;
> +	__u32 pad[4];
>  };
>  
>  /* For KVM_CAP_SW_TLB */
> -- 
> 2.33.0.309.g3052b89438-goog
> 
> 

