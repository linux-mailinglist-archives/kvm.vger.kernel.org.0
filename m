Return-Path: <kvm+bounces-42605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 99464A7AFDB
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 23:03:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54B8D7A1FB5
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 21:01:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 361EF25C704;
	Thu,  3 Apr 2025 20:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aTYDD8iR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9869E25C6F0
	for <kvm@vger.kernel.org>; Thu,  3 Apr 2025 20:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743710723; cv=none; b=h0zrK1OBFVlbmU3Ob1xg2/MF1xa+7/M47hvqyzxtwnWCGBhNX91zDuikQ6VygMQUSIAQxb0hSzwT7Ejlhg97tBpOXgZfucsukQbIXzV7VLM6IQvVgcMxpWzeJnCTf8yVAl4XtnEIE6vCUDdzLhnNsgFQ/Lpru52yImYNQgVlKZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743710723; c=relaxed/simple;
	bh=2z7gpOBopP6mzRwdH/71QvjcZ+Il4PwlmeVS1h9BDc0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pBO/Xpl4a8sCtFDHLV8crMhgoSeL36VR//nIjALB1jHYZeL3ofLQvpYOnV/o+XJaQSwqr9aBxAJhCnY2+rVGeCNzSfKAbdsSLVumY37dab/KR3cxOyx6rD4mRrP4l+niVn/7jV7Uhj2EM71VjA4v/WFZ2XfG3T/Xcgp2y1hyPW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aTYDD8iR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743710719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pqWz8jc0Cqe1OSwpvbPHtdUwNBBKx4zhxiSnmOOprDA=;
	b=aTYDD8iR3v2xhP0ZZfUyp2L4Md0fYgv7isNshGdtV1kie4je3WWMKr81jAetFmNhEUW3MN
	+NP/6u4P7F1Fw/OdHS1uz8eL0DwLLJjPBh8ImC8qBCP9L2EXMkvccvtzee2fb1CfBbRfCO
	GSXl4hrtL4d7qrSp03BOrJ1qBLZcY5Q=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-Wj1_wZUFNyOEpvmSdHF9Kw-1; Thu, 03 Apr 2025 16:05:14 -0400
X-MC-Unique: Wj1_wZUFNyOEpvmSdHF9Kw-1
X-Mimecast-MFC-AGG-ID: Wj1_wZUFNyOEpvmSdHF9Kw_1743710714
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6ecfbdaaee3so21867986d6.3
        for <kvm@vger.kernel.org>; Thu, 03 Apr 2025 13:05:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743710714; x=1744315514;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pqWz8jc0Cqe1OSwpvbPHtdUwNBBKx4zhxiSnmOOprDA=;
        b=eOGZ7rxbdK/JH7so30sYoNnVbsBPya2X1FyHmO2Fcq0SWbIipbnYGvMmD4Nn9f4f2y
         edXwUUoHKTxkP/7jcx6jRJopvOKz9utb3fZwUwGvPps3nuGF9gQFs/a/tvI0P6tzzvmF
         TxQjdzPMox0BUw6Stngu4mOdJvFtXMMBNvM53ADIkieoyLJ0VPlfW110AbZ7yUcYoS8a
         vTrV9MWIULFtthmpdbpHTb6CLb7ULcoMKLJKvKa1mWCa6oaVoN1+dlLj/SavQNPVy492
         efWnhNQ6x9OM29o1Q1G3T1Ge1m93aUdZRy91R+k3mp/511fvmzySCgwAvExWWQeWbFUW
         0t3A==
X-Forwarded-Encrypted: i=1; AJvYcCUpiGBPMk3M7++aB8eBukls29ZNypSy51qxgBH89j3bBM/Z3Wk10OcPYwT0Y8wOJi5QA+0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAervlzWTI0lOYe3x4Mg0B52RNOY2Uy3G70Xwqk1I2ahe7HIeG
	R0jQWg4naWDTjsyPH+YHqrijQZ5aqnZN7i2fQClGDpo23izCju9ATOOyhomZgpj234Cb7ns72fH
	QIdjirWcj2qQpTO3LjmlhyXSETkCmlGY93rzyAv9UOjEtkMDPQw==
X-Gm-Gg: ASbGncsGWH7cOFZm6Ai2PC44SvrIGgaxiPRaARpAVKZjjMuPWV0eSXDLl+qiU7S5eh7
	zCee0GBTAOHL1WvU6QMN1219JU0zEfQbhFY3L0xDN5vKOd+Ns0Vo/7rqmqQziWWt5hpmduu+dfy
	ozbU15ufY1bnjkj7Hb/6pC+Afkk4KJ1eO/BvEiWRPIgCBkUPitEvCqK3Jk+k3ivB6uhB4JYsoNP
	z+n/dUtRmunVefBTxQri4eGjYBMfmeNu8r9NahlvecXxetDn/U0v4BTb2aZ5Wte0cBx+BH/g56N
	cZ4EBstkKHtQB8c=
X-Received: by 2002:a05:6214:5003:b0:6e8:e828:820d with SMTP id 6a1803df08f44-6f01e770a99mr12634746d6.36.1743710713962;
        Thu, 03 Apr 2025 13:05:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHI0uNwzM0Zr9e35g9LBvdZ4c5VLY88VwkoSIVcvFfwX4IuCidMY0KeMWE7XWbiyje9oA7n8A==
X-Received: by 2002:a05:6214:5003:b0:6e8:e828:820d with SMTP id 6a1803df08f44-6f01e770a99mr12634106d6.36.1743710713605;
        Thu, 03 Apr 2025 13:05:13 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ef0f047a77sm11414696d6.53.2025.04.03.13.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 13:05:13 -0700 (PDT)
Message-ID: <de73e879d6775a9900789a64fcea0f90e557681f.camel@redhat.com>
Subject: Re: [RFC PATCH 09/24] KVM: SEV: Generalize tracking ASID->vCPU with
 xarrays
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
 <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Rik van Riel <riel@surriel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,  x86@kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Apr 2025 16:05:12 -0400
In-Reply-To: <20250326193619.3714986-10-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
	 <20250326193619.3714986-10-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2025-03-26 at 19:36 +0000, Yosry Ahmed wrote:
> Following changes will track ASID to vCPU mappings for all ASIDs, not
> just SEV ASIDs. Using per-CPU arrays with the maximum possible number of
> ASIDs would be too expensive.

Maybe add a word or two to explain that currently # of SEV ASIDS is small
but # of all ASIDS is relatively large (like 16 bit number or so)?

>  Use xarrays to generalize tracking the
> mappings instead. The logic is also mostly moved outside the SEV code to
> allow future changes to reuse it for normal SVM VMs.
> 
> Storing into an xarray is more expensive than reading/writing to an
> array, but is only done on vCPU load and should be mostly uncontended.
> Also, the size of the xarray should be O(# of VMs), so it is not
> expected to be huge. In fact, the xarray will probably use less memory
> than the normal array even for SEV on machines that only run a few VMs.
> 
> When a new ASID is allocated, reserve an entry for it on all xarrays on
> all CPUs. This allows the memory allocations to happen in a more relaxed
> context (allowing reclaim and accounting), and failures to be handled at
> VM creation time. However, entries will be allocated even on CPUs that
> never run the VM.
> 
> The alternative is relying on on-demand GFP_ATOMIC allocations with
> xa_store() on vCPU load.  These allocations are more likely to fail and
> more difficult to handle since vCPU load cannot fail. Flushing the TLB
> if the xa_store() fails is probably sufficient handling, but
> preallocations are easier to reason about.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/sev.c | 25 ++++-----------------
>  arch/x86/kvm/svm/svm.c | 50 +++++++++++++++++++++++++++++++-----------
>  arch/x86/kvm/svm/svm.h |  7 +++---
>  3 files changed, 44 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 1742f51d4c194..c11da3259c089 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -211,6 +211,9 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>  		goto e_uncharge;
>  	}
>  
> +	if (!svm_register_asid(asid))
> +		goto e_uncharge;
> +
>  	__set_bit(asid, sev_asid_bitmap);
>  
>  	mutex_unlock(&sev_bitmap_lock);
> @@ -231,18 +234,10 @@ unsigned int sev_get_asid(struct kvm *kvm)
>  
>  static void sev_asid_free(struct kvm_sev_info *sev)
>  {
> -	struct svm_cpu_data *sd;
> -	int cpu;
> +	svm_unregister_asid(sev->asid);
>  
>  	mutex_lock(&sev_bitmap_lock);
> -
>  	__set_bit(sev->asid, sev_reclaim_asid_bitmap);
> -
> -	for_each_possible_cpu(cpu) {
> -		sd = per_cpu_ptr(&svm_data, cpu);
> -		sd->sev_vcpus[sev->asid] = NULL;
> -	}
> -
>  	mutex_unlock(&sev_bitmap_lock);
>  
>  	sev_misc_cg_uncharge(sev);
> @@ -3076,18 +3071,6 @@ void sev_hardware_unsetup(void)
>  	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
>  }
>  
> -int sev_cpu_init(struct svm_cpu_data *sd)
> -{
> -	if (!sev_enabled)
> -		return 0;
> -
> -	sd->sev_vcpus = kcalloc(nr_asids, sizeof(void *), GFP_KERNEL);
> -	if (!sd->sev_vcpus)
> -		return -ENOMEM;
> -
> -	return 0;
> -}
> -
>  /*
>   * Pages used by hardware to hold guest encrypted state must be flushed before
>   * returning them to the system.
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ce67112732e8c..b740114a9d9bc 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -694,7 +694,7 @@ static void svm_cpu_uninit(int cpu)
>  	if (!sd->save_area)
>  		return;
>  
> -	kfree(sd->sev_vcpus);
> +	xa_destroy(&sd->asid_vcpu);
>  	__free_page(__sme_pa_to_page(sd->save_area_pa));
>  	sd->save_area_pa = 0;
>  	sd->save_area = NULL;
> @@ -711,18 +711,11 @@ static int svm_cpu_init(int cpu)
>  	if (!save_area_page)
>  		return ret;
>  
> -	ret = sev_cpu_init(sd);
> -	if (ret)
> -		goto free_save_area;
> +	xa_init(&sd->asid_vcpu);
>  
>  	sd->save_area = page_address(save_area_page);
>  	sd->save_area_pa = __sme_page_pa(save_area_page);
>  	return 0;
> -
> -free_save_area:
> -	__free_page(save_area_page);
> -	return ret;
> -
>  }
>  
>  static void set_dr_intercepts(struct vcpu_svm *svm)
> @@ -1557,6 +1550,7 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	unsigned int asid;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
> +	struct kvm_vcpu *prev;
>  
>  	if (vcpu->scheduled_out && !kvm_pause_in_guest(vcpu->kvm))
>  		shrink_ple_window(vcpu);
> @@ -1573,13 +1567,13 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	if (sev_guest(vcpu->kvm)) {
>  		/*
>  		 * Flush the TLB when a different vCPU using the same ASID is
> -		 * run on the same CPU.
> +		 * run on the same CPU. xa_store() should always succeed because
> +		 * the entry is reserved when the ASID is allocated.
>  		 */
>  		asid = sev_get_asid(vcpu->kvm);
> -		if (sd->sev_vcpus[asid] != vcpu) {
> -			sd->sev_vcpus[asid] = vcpu;
> +		prev = xa_store(&sd->asid_vcpu, asid, vcpu, GFP_ATOMIC);
> +		if (prev != vcpu || WARN_ON_ONCE(xa_err(prev)))

Tiny nitpick: I would have prefered to have WARN_ON_ONCE(xa_err(prev) first in the above condition,
because in theory we shouldn't use a value before we know its not an error,
but in practice this doesn't really matter.


>  			kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> -		}
>  	}
>  }
>  
> @@ -5047,6 +5041,36 @@ static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>  	sev_vcpu_deliver_sipi_vector(vcpu, vector);
>  }
>  
> +void svm_unregister_asid(unsigned int asid)
> +{
> +	struct svm_cpu_data *sd;
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		sd = per_cpu_ptr(&svm_data, cpu);
> +		xa_erase(&sd->asid_vcpu, asid);
> +	}
> +}
> +
> +bool svm_register_asid(unsigned int asid)
> +{
> +	struct svm_cpu_data *sd;
> +	int cpu;
> +
> +	/*
> +	 * Preallocate entries on all CPUs for the ASID to avoid memory
> +	 * allocations in the vCPU load path.
> +	 */
> +	for_each_possible_cpu(cpu) {
> +		sd = per_cpu_ptr(&svm_data, cpu);
> +		if (xa_reserve(&sd->asid_vcpu, asid, GFP_KERNEL_ACCOUNT)) {
> +			svm_unregister_asid(asid);
> +			return false;
> +		}
> +	}
> +	return true;
> +}
> +
>  static void svm_vm_destroy(struct kvm *kvm)
>  {
>  	avic_vm_destroy(kvm);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 3ab2a424992c1..4929b96d3d700 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -340,8 +340,7 @@ struct svm_cpu_data {
>  
>  	struct vmcb *current_vmcb;
>  
> -	/* index = sev_asid, value = vcpu pointer */
Maybe keep the above comment?

> -	struct kvm_vcpu **sev_vcpus;
> +	struct xarray asid_vcpu;
>  };
>  
>  DECLARE_PER_CPU(struct svm_cpu_data, svm_data);
> @@ -655,6 +654,8 @@ void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
>  void svm_set_x2apic_msr_interception(struct vcpu_svm *svm, bool disable);
>  void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
>  				     int trig_mode, int vec);
> +bool svm_register_asid(unsigned int asid);
> +void svm_unregister_asid(unsigned int asid);
>  
>  /* nested.c */
>  
> @@ -793,7 +794,6 @@ void sev_vm_destroy(struct kvm *kvm);
>  void __init sev_set_cpu_caps(void);
>  void __init sev_hardware_setup(void);
>  void sev_hardware_unsetup(void);
> -int sev_cpu_init(struct svm_cpu_data *sd);
>  int sev_dev_get_attr(u32 group, u64 attr, u64 *val);
>  extern unsigned int max_sev_asid;
>  void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
> @@ -817,7 +817,6 @@ static inline void sev_vm_destroy(struct kvm *kvm) {}
>  static inline void __init sev_set_cpu_caps(void) {}
>  static inline void __init sev_hardware_setup(void) {}
>  static inline void sev_hardware_unsetup(void) {}
> -static inline int sev_cpu_init(struct svm_cpu_data *sd) { return 0; }
>  static inline int sev_dev_get_attr(u32 group, u64 attr, u64 *val) { return -ENXIO; }
>  #define max_sev_asid 0
>  static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code) {}


Overall looks good to me.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




