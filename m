Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4257481E95
	for <lists+kvm@lfdr.de>; Thu, 30 Dec 2021 18:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241454AbhL3RWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Dec 2021 12:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236737AbhL3RWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Dec 2021 12:22:04 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0203CC06173E
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 09:22:04 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 2so21909280pgb.12
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 09:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dq74/60NlkA0VhWTz/mDFIF+UmOc1itrKWEOcms1GmY=;
        b=Ok++s6ypsPRIfdz9X4z3iKsIRkDEovBSSqbpU5pkoh3UYbBUo7Hwc1hVLhzw0+hWn4
         Pl+yy8TAmvVTmXmgJjQ4W1UtRbEklmNA3lfcHWRlCAz6Z3AX5gTLjcO2uFkcHlOSugCS
         mGbrBIsuZwhqk/g5L1f2rrmmoArEX3eUriZeXfof1oYZKKVZI+1Cl0jSuMP1Yc61jDbR
         H1F8yh0/fcnmcLs3MYI7yj/H9HqpJX393tT+Bn222ifjebGGXZCwHk50E+p43a5QhAqh
         1WPS3pJIAhJnACmxuHpKqR9k8nIn/L8keLPCyvCoW8rTxBXUwmN0zB4D+nVhWadP0UkL
         RGCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dq74/60NlkA0VhWTz/mDFIF+UmOc1itrKWEOcms1GmY=;
        b=1RJzrzp8vP2LVHj3TWF1v1kdgf2W22hEViYlOvIcWdJhHP/BV/5CDycnZme+WY6Y34
         9+mY7M8DP85TQoLIpOGKwAIfER7RKuvM6hM2TXvIBxkOR/1j/L1rG4X01gKYiz/OvL1O
         GvKKMVx0Ou9FqPmhnEUU0Z0WWXYCCSLLbmV7MfV+CJZyzpt1ZxfZYbGvThxwAvEBBsBz
         LU9OniAm9jSFz0teBX7/jIs6UbN+8CkuQ2okVopAW/LB4WsWlsjDEyIcNUESf5f0kRX7
         aXov6tcvTqstPThMoU8NE5wA0+GSwZdwLIiQIgIndyqehHxPEl0yb9U09a8xsmp0ghI4
         L5Hw==
X-Gm-Message-State: AOAM531Boc01JAYke9H9YFm8VvQMnPyvsPiE0l1OrEmQq6z8lDm5RmhU
        7c7CIvLQ4lA7vaRrssUa51dRsw==
X-Google-Smtp-Source: ABdhPJxUMBz1mYkfRhgkL1B0OoVEb5swzqdrHE1pZppy72lXwJ6bZSjXXqJXPaZGVmXSAevPIOO1HQ==
X-Received: by 2002:a05:6a00:3001:b0:4bb:ea7d:6c48 with SMTP id ay1-20020a056a00300100b004bbea7d6c48mr19669347pfb.51.1640884923198;
        Thu, 30 Dec 2021 09:22:03 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w76sm26514659pff.21.2021.12.30.09.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 09:22:02 -0800 (PST)
Date:   Thu, 30 Dec 2021 17:21:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, joro@8bytes.org, mlevitsk@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, thomas.lendacky@amd.com,
        jon.grimm@amd.com
Subject: Re: [PATCH v3 3/3] KVM: SVM: Extend host physical APIC ID field to
 support more than 8-bit
Message-ID: <Yc3qt/x1YPYKe4G0@google.com>
References: <20211213113110.12143-1-suravee.suthikulpanit@amd.com>
 <20211213113110.12143-4-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213113110.12143-4-suravee.suthikulpanit@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021, Suravee Suthikulpanit wrote:
> The AVIC physical APIC ID table entry contains the host physical
> APIC ID field, which the hardware uses to keep track of where each
> vCPU is running. Originally, the field is an 8-bit value, which can
> only support physical APIC ID up to 255.
> 
> To support system with larger APIC ID, the AVIC hardware extends
> this field to support up to the largest possible physical APIC ID
> available on the system.
> 
> Therefore, replace the hard-coded mask value with the value
> calculated from the maximum possible physical APIC ID in the system.

...

> +static void avic_init_host_physical_apicid_mask(void)
> +{
> +	if (!x2apic_mode) {
> +		/* If host is in xAPIC mode, default to only 8-bit mask. */
> +		avic_host_physical_id_mask = 0xffULL;

Use GENMASK(7:0) instead of open coding the equivalent.  Oh, and
avic_host_physical_id_mask doesn't need to be a u64, it's hard capped at 12 bits
and so can be a simple int.

> +	} else {
> +		u32 count = get_count_order(apic_get_max_phys_apicid());
> +
> +		avic_host_physical_id_mask = BIT_ULL(count) - 1;
> +	}

Why is the "legal" mask dynamically calculated?  That's way more complicated and
convoluted then this needs to be.

The cover letter says

  However, newer AMD systems can have physical APIC ID larger than 255,
  and AVIC hardware has been extended to support upto the maximum physical
  APIC ID available in the system.

and newer versions of the APM have bits

  11:8 - Reserved/SBZ for legacy APIC; extension of Host Physical APIC ID when
         x2APIC is enabled.
  7:0  - Host Physical APIC ID Physical APIC ID of the physical core allocated by
         the VMM to host the guest virtual processor. This field is not valid
	 unless the IsRunning bit is set.

whereas older versions have

  11:8 - Reserved, SBZ. Should always be set to zero.

That implies that an APIC ID > 255 on older hardware what ignores bits 11:8 even
in x2APIC will silently fail, and the whole point of this mask is to avoid exactly
that.

To further confuse things, the APM was only partially updated and needs to be fixed,
e.g. "Figure 15-19. Physical APIC Table in Memory" and the following blurb wasn't
updated to account for the new x2APIC behavior.

But at least one APM blurb appears to have been wrong (or the architecture is broken)
prior to the larger AVIC width:

  Since a destination of FFh is used to specify a broadcast, physical APIC ID FFh
  is reserved.

We have Rome systems with 256 CPUs and thus an x2APIC ID for a CPU of FFh.  So
either the APM is wrong or AVIC is broken on older large systems.

Anyways, for the new larger mask, IMO dynamically computing the mask based on what
APIC IDs were enumerated to the kernel is pointless.  If the AVIC doesn't support
using bits 11:0 to address APIC IDs then KVM is silently hosed no matter what if
any APIC ID is >255.

Ideally, there would be a feature flag enumerating the larger AVIC support so we
could do:

	if (!x2apic_mode || !boot_cpu_has(X86_FEATURE_FANCY_NEW_AVIC))
		avic_host_physical_id_mask = GENMASK(7:0);
	else
		avic_host_physical_id_mask = GENMASK(11:0);

but since it sounds like that's not the case, and presumably hardware is smart
enough not to assign APIC IDs it can't address, this can simply be

	if (!x2apic_mode)
		avic_host_physical_id_mask = GENMASK(7:0);
	else
		avic_host_physical_id_mask = GENMASK(11:0);

and patch 01 to add+export apic_get_max_phys_apicid() goes away.

> +	pr_debug("Using AVIC host physical APIC ID mask %#0llx\n",
> +		 avic_host_physical_id_mask);
> +}
> +
>  int avic_vm_init(struct kvm *kvm)
>  {
>  	unsigned long flags;
> @@ -943,22 +959,17 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
>  void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>  	u64 entry;
> -	/* ID = 0xff (broadcast), ID > 0xff (reserved) */
>  	int h_physical_id = kvm_cpu_get_apicid(cpu);
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> -	/*
> -	 * Since the host physical APIC id is 8 bits,
> -	 * we can support host APIC ID upto 255.
> -	 */
> -	if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
> +	if (WARN_ON(h_physical_id > avic_host_physical_id_mask))

Not really your code, but this should really be

	if (WARN_ON((h_physical_id & avic_host_physical_id_mask) != h_physical_id))
		return;

otherwise a negative value will get a false negative.

LOL, and with respect to FFh being reserved, the current KVM code doesn't treat
it as reserved.  Which is probably a serendipituous bug as it allows addressing
APID ID FFh when x2APIC is enabled.  I suspect we also want:

	if (WARN_ON(!x2apic_mode && h_physical_id == 0xff))
		return;

>  		return;
>  
>  	entry = READ_ONCE(*(svm->avic_physical_id_cache));
>  	WARN_ON(entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
>  
> -	entry &= ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK;
> -	entry |= (h_physical_id & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK);
> +	entry &= ~avic_host_physical_id_mask;
> +	entry |= h_physical_id;
>  
>  	entry &= ~AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK;
>  	if (svm->avic_is_running)
> @@ -1018,6 +1029,7 @@ bool avic_hardware_setup(bool avic)
>  		return false;
>  
>  	pr_info("AVIC enabled\n");
> +	avic_init_host_physical_apicid_mask();
>  	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
>  	return true;
>  }
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 3fa975031dc9..bbe2fb226b52 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -497,7 +497,6 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
>  #define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
>  #define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
>  
> -#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	(0xFFULL)
>  #define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
>  #define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
>  #define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
> -- 
> 2.25.1
> 
