Return-Path: <kvm+bounces-14113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55D5989EFD0
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 12:29:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C6DA283053
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 10:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C88BC1591F8;
	Wed, 10 Apr 2024 10:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GJ3OcgYX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130EA156F27;
	Wed, 10 Apr 2024 10:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712744959; cv=none; b=NHZhzlS+GwGaXtW0H0asdhN900ZOz9cwLMG8k8bCeYo65t0kM4+o0egx6M43FzVLP9ClHSs9byM7gG4+RT88rZDeb/0fvX4ptpzmqH/IRohdMUoYc0Wy4M982B/b8rVd1gt+oO8bPH3+yEEPv6sDvKSk7jMS/PgO/Kki4YZXujk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712744959; c=relaxed/simple;
	bh=AFjF4CiJb6IGV3uwNnUlkIJ7muZXr8iTZi2kT1N6Y3w=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=ADSNgjgLW1eNuauSWvHyibGvPJUa2lFx3Sybc+33gj3T70etdWmWq+prlEU/IsskMCFb9JJhfjuWCmKQGgVwJKdO4QVGkyuvFEd1M5c3iEme8T40MmoccHQ792Msr73XCPZNAWqRLWc29WaVheGC8a/4vMtOApLbCUnFoVCjLCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GJ3OcgYX; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-417c4bd59b3so47895e9.2;
        Wed, 10 Apr 2024 03:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712744955; x=1713349755; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ggmDJ4ODuoznnH+obJkgP9ZZPSU+EvIoCqrdrLvAFiU=;
        b=GJ3OcgYXt8oeE8XF+t+r6hE95Xf50vr15178oaK2z40HRHlCtDMOqEE8FIPKaTPBMB
         LgIG0ziEF6rP3yN0Qwi3/PXTRxXrXSN3GxBq+egDoshBBgpzSfvlW8LMiu8IIpupMWKm
         7xGI+QE7JOEe+wqOr2GcWvDkvmcN3BlczBsyIBvDxXP1Ma3G+6mQ4e09ehCJN0uFPOT9
         AvmpfR+vvxBGgD6bJkbXQkWxDafPbFlCJmuT4g4nrJ0dT3G+vBTFSbmMwrhSjH9P6odP
         yqTPUPNQ+qNMSfHBnOcwvqr5V16aol7tH4KWhI9/od5hQbbbA0YTNo2Abq7ud29WO38T
         2YdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712744955; x=1713349755;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ggmDJ4ODuoznnH+obJkgP9ZZPSU+EvIoCqrdrLvAFiU=;
        b=tzrUjjYky502z415dy5H5FPG97r5FnoS63gyiuhCzNkGO8gjdFsuSFH8aEAWEUbkhW
         nuy8LlBr4fszb1thozqAtfAHo//atDFWXggWE2ePRbFHX3WSgvRu4txYZ0hYiRGrNNaO
         XKcbgW57I6kb8ps+2MICjjp+c3P7cyKHX0r5BaDSwpZijsyoz5k9ZrRplsCqPUxbT0Fi
         D6QftRD/HsgY9r/XBuMGAIexIjSK979y3RhlniTQJ1nFwNu/WO5pJ2EqKkhoBizuw1DJ
         dk3e6scX9deFVxUi9ucWtCN99hjCqLp5vDAjQpZpc7w7CL5P2dsU1g+kquA+lFjncjoL
         Wh7A==
X-Forwarded-Encrypted: i=1; AJvYcCVaQwE73OAwWBeaLpoiy+8QUY/I8Kk69NRZV3KvPxIO2ErD7dUHtdGpXVQucoxMgGTbyGjfKZRleRvycys1HByoN/uqxrTDzs86NJ7k7dtatT94zmsFolgyDSyvkDSAwdkNGdg7eLeCt+dr7VQzEw7R0T5lj243h+bXuAkE
X-Gm-Message-State: AOJu0YzojwSjwlaHnCksAuIdoI+pgF03zlnGXY9Nvd8ZK96XqbwUJdvY
	MgK/mLBv7iqbJQStoyTIns5sO7teASdGCg0IheFcyEm1yw4O94Df
X-Google-Smtp-Source: AGHT+IHADtDbmvyWOUf7FMr11Y6g7lUUheaSHO6bMTumsllgsuIqktWh38pmVeYji+J9lQz1rhMELA==
X-Received: by 2002:a05:600c:4fd4:b0:416:7b2c:def5 with SMTP id o20-20020a05600c4fd400b004167b2cdef5mr1600159wmq.2.1712744955025;
        Wed, 10 Apr 2024 03:29:15 -0700 (PDT)
Received: from [192.168.12.203] (54-240-197-228.amazon.com. [54.240.197.228])
        by smtp.gmail.com with ESMTPSA id f18-20020a05600c4e9200b0041632fcf272sm1864338wmq.22.2024.04.10.03.29.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Apr 2024 03:29:14 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <005911c5-7f9d-4397-8145-a1ad4494484d@xen.org>
Date: Wed, 10 Apr 2024 11:29:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 1/2] KVM: x86: Add KVM_[GS]ET_CLOCK_GUEST for accurate
 KVM clock migration
To: Jack Allister <jalliste@amazon.com>
Cc: bp@alien8.de, corbet@lwn.net, dave.hansen@linux.intel.com,
 dwmw2@infradead.org, hpa@zytor.com, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
 pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de, x86@kernel.org,
 Dongli Zhang <dongli.zhang@oracle.com>
References: <20240408220705.7637-1-jalliste@amazon.com>
 <20240410095244.77109-1-jalliste@amazon.com>
 <20240410095244.77109-2-jalliste@amazon.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20240410095244.77109-2-jalliste@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/04/2024 10:52, Jack Allister wrote:
> In the common case (where kvm->arch.use_master_clock is true), the KVM
> clock is defined as a simple arithmetic function of the guest TSC, based on
> a reference point stored in kvm->arch.master_kernel_ns and
> kvm->arch.master_cycle_now.
> 
> The existing KVM_[GS]ET_CLOCK functionality does not allow for this
> relationship to be precisely saved and restored by userspace. All it can
> currently do is set the KVM clock at a given UTC reference time, which is
> necessarily imprecise.
> 
> So on live update, the guest TSC can remain cycle accurate at precisely the
> same offset from the host TSC, but there is no way for userspace to restore
> the KVM clock accurately.
> 
> Even on live migration to a new host, where the accuracy of the guest time-
> keeping is fundamentally limited by the accuracy of wallclock
> synchronization between the source and destination hosts, the clock jump
> experienced by the guest's TSC and its KVM clock should at least be
> *consistent*. Even when the guest TSC suffers a discontinuity, its KVM
> clock should still remain the *same* arithmetic function of the guest TSC,
> and not suffer an *additional* discontinuity.
> 
> To allow for accurate migration of the KVM clock, add per-vCPU ioctls which
> save and restore the actual PV clock info in pvclock_vcpu_time_info.
> 
> The restoration in KVM_SET_CLOCK_GUEST works by creating a new reference
> point in time just as kvm_update_masterclock() does, and calculating the
> corresponding guest TSC value. This guest TSC value is then passed through
> the user-provided pvclock structure to generate the *intended* KVM clock
> value at that point in time, and through the *actual* KVM clock calculation.
> Then kvm->arch.kvmclock_offset is adjusted to eliminate for the difference.
> 
> Where kvm->arch.use_master_clock is false (because the host TSC is
> unreliable, or the guest TSCs are configured strangely), the KVM clock
> is *not* defined as a function of the guest TSC so KVM_GET_CLOCK_GUEST
> returns an error. In this case, as documented, userspace shall use the
> legacy KVM_GET_CLOCK ioctl. The loss of precision is acceptable in this
> case since the clocks are imprecise in this mode anyway.
> 
> On *restoration*, if kvm->arch.use_master_clock is false, an error is
> returned for similar reasons and userspace shall fall back to using
> KVM_SET_CLOCK. This does mean that, as documented, userspace needs to use
> *both* KVM_GET_CLOCK_GUEST and KVM_GET_CLOCK and send both results with the
> migration data (unless the intent is to refuse to resume on a host with bad
> TSC).
> 
> (It may have been possible to make KVM_SET_CLOCK_GUEST "good enough" in the
> non-masterclock mode, as that mode is necessarily imprecise anyway. The
> explicit fallback allows userspace to deliberately fail migration to a host
> with misbehaving TSC where master clock mode wouldn't be active.)
> 
> Suggested-by: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Jack Allister <jalliste@amazon.com>
> CC: Paul Durrant <paul@xen.org>
> CC: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>   Documentation/virt/kvm/api.rst |  37 ++++++++++
>   arch/x86/kvm/x86.c             | 124 +++++++++++++++++++++++++++++++++
>   include/uapi/linux/kvm.h       |   3 +
>   3 files changed, 164 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 0b5a33ee71ee..80fcd93bba1b 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6352,6 +6352,43 @@ a single guest_memfd file, but the bound ranges must not overlap).
>   
>   See KVM_SET_USER_MEMORY_REGION2 for additional details.
>   
> +4.143 KVM_GET_CLOCK_GUEST
> +----------------------------
> +
> +:Capability: none
> +:Architectures: x86
> +:Type: vcpu ioctl
> +:Parameters: struct pvclock_vcpu_time_info (out)
> +:Returns: 0 on success, <0 on error
> +
> +Retrieves the current time information structure used for KVM/PV clocks,
> +in precisely the form advertised to the guest vCPU, which gives parameters
> +for a direct conversion from a guest TSC value to nanoseconds.
> +
> +When the KVM clock not is in "master clock" mode, for example because the
> +host TSC is unreliable or the guest TSCs are oddly configured, the KVM clock
> +is actually defined by the host CLOCK_MONOTONIC_RAW instead of the guest TSC.
> +In this case, the KVM_GET_CLOCK_GUEST ioctl returns -EINVAL.
> +
> +4.144 KVM_SET_CLOCK_GUEST
> +----------------------------
> +
> +:Capability: none
> +:Architectures: x86
> +:Type: vcpu ioctl
> +:Parameters: struct pvclock_vcpu_time_info (in)
> +:Returns: 0 on success, <0 on error
> +
> +Sets the KVM clock (for the whole VM) in terms of the vCPU TSC, using the
> +pvclock structure as returned by KVM_GET_CLOCK_GUEST. This allows the precise
> +arithmetic relationship between guest TSC and KVM clock to be preserved by
> +userspace across migration.
> +
> +When the KVM clock is not in "master clock" mode, and the KVM clock is actually
> +defined by the host CLOCK_MONOTONIC_RAW, this ioctl returns -EINVAL.

EINVAL doesn't seem appropriate. ENOTSUP perhaps? Same for getting the 
clock info I suppose.

> Userspace
> +may choose to set the clock using the less precise KVM_SET_CLOCK ioctl, or may
> +choose to fail, denying migration to a host whose TSC is misbehaving.
> +
>   5. The kvm_run structure
>   ========================
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 47d9f03b7778..d5cae3ead04d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5859,6 +5859,124 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>   	}
>   }
>   
> +static int kvm_vcpu_ioctl_get_clock_guest(struct kvm_vcpu *v, void __user *argp)
> +{
> +	struct pvclock_vcpu_time_info *vcpu_pvti = &v->arch.hv_clock;
> +	struct pvclock_vcpu_time_info local_pvti = { 0 };
> +	struct kvm_arch *ka = &v->kvm->arch;
> +	uint64_t host_tsc, guest_tsc;
> +	bool use_master_clock;
> +	uint64_t kernel_ns;
> +	unsigned int seq;
> +
> +	/*
> +	 * CLOCK_MONOTONIC_RAW is not suitable for GET/SET API,
> +	 * see kvm_vcpu_ioctl_set_clock_guest equivalent comment.
> +	 */
> +	if (!static_cpu_has(X86_FEATURE_CONSTANT_TSC))
> +		return -EINVAL;
> +
> +	/*
> +	 * Querying needs to be performed in a seqcount loop as it's possible
> +	 * another vCPU has triggered an update of the master clock. If so we
> +	 * should store the host TSC & time at this point.
> +	 */
> +	do {
> +		seq = read_seqcount_begin(&ka->pvclock_sc);
> +		use_master_clock = ka->use_master_clock;
> +		if (use_master_clock) {
> +			host_tsc = ka->master_cycle_now;
> +			kernel_ns = ka->master_kernel_ns;
> +		}
> +	} while (read_seqcount_retry(&ka->pvclock_sc, seq));

You could bail from the loop if `use_master_clock` is false, couldn't you?

> +
> +	if (!use_master_clock)
> +		return -EINVAL;
> +
> +	/*
> +	 * It's possible that this vCPU doesn't have a HVCLOCK configured
> +	 * but the other vCPUs may. If this is the case calculate based
> +	 * upon the time gathered in the seqcount but do not update the
> +	 * vCPU specific PVTI. If we have one, then use that.

Given this is a per-vCPU ioctl, why not fail in the case the vCPU 
doesn't have HVCLOCK configured? Or is your intention that a GET/SET 
should always work if TSC is stable?

> +	 */
> +	if (!vcpu_pvti->tsc_timestamp && !vcpu_pvti->system_time) {
> +		guest_tsc = kvm_read_l1_tsc(v, host_tsc);
> +
> +		local_pvti.tsc_timestamp = guest_tsc;
> +		local_pvti.system_time = kernel_ns + ka->kvmclock_offset;
> +	} else {
> +		local_pvti = *vcpu_pvti;
> +	}
> +
> +	if (copy_to_user(argp, &local_pvti, sizeof(local_pvti)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +


