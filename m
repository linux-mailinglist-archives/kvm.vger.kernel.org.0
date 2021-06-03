Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8414E39ABB1
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 22:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhFCUSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 16:18:45 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:35341 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhFCUSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 16:18:44 -0400
Received: by mail-pj1-f51.google.com with SMTP id lx17-20020a17090b4b11b029015f3b32b8dbso6173926pjb.0
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 13:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KkXZ4sXSYrDtinr9db7PbN7PZh+I0TjjzE8qan53Yqw=;
        b=HQKWOL8xmBXFF1rksHD1Y+UjZvhRCkMZmRtV/GoCfbBmjfWEcnWHbaSXbHkhuslMwd
         U89kleP9JhcNhU/pss2Ye1kZjcWEUzOBr8sg1B463QDrAJrVKh591MhGmhKC6fZA4fHm
         TJuDRKhqhDAqdvXx5rNi1dkVs7VZ9ocQfgVnCeiYosOh05PBuknD5nd+7myBg4hL2xwo
         fBFM/gUoRSBeiI4ACDCpTPPRlFXFRB40hA0RvHdtkwstLdBtMcntSfHAq3PzA7fkRwXd
         /rVxS63UoOxrbsRahUsQM9KvF4y/pinSp9YkqnEIZ/T3R/hNoJi5m/qKLiOW1rBKqAqw
         D/HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KkXZ4sXSYrDtinr9db7PbN7PZh+I0TjjzE8qan53Yqw=;
        b=Qr1x5arvHbfqMo1VfWjFRQmg2aL+3voUrnkEuU+2QJhrVwiAc2aNWWd8D0fii09oR0
         5sM1bZKUb1R+XfgJCGfuoiSe82bBc+iV12Yl1H75nRMUTtRBw/F5vjiSv6jxlOgyiv8W
         c1IGfNNBepZnran9x5ChCAvPwDSSZSsyqN7tK6xrneh+nWgtLX1mxrVuhTKyulqBjdbp
         4EEaqHKIruvDzJLkXWOQn2Z9AyCk2ueqVJiitv4NuFF13m88yYHXsaWF+glE20Wi4o6a
         zHLPuNktfZiYSBN8CGBEbhfOPqNdl8JnVHhxUoZxP+EWHjhxEeDhvO/8ButFhsB8CJu1
         6fRw==
X-Gm-Message-State: AOAM533e6BIZddUi6D+LfVL5Mn4dunG/51sQokplC3KBSZTmcsLSumfr
        d3QHMeeob1AA397StX2XepoUlw==
X-Google-Smtp-Source: ABdhPJzGt7UQZHAEA3b4VX3+SADBsxohwahUTfrm1TqdzFPVfW6F1Sf+M7UxVfM10t3CKtiUfIIObw==
X-Received: by 2002:a17:90a:e7c8:: with SMTP id kb8mr989516pjb.60.1622751359623;
        Thu, 03 Jun 2021 13:15:59 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id d12sm2699401pfv.190.2021.06.03.13.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 13:15:58 -0700 (PDT)
Date:   Thu, 3 Jun 2021 20:15:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        David Brazdil <dbrazdil@google.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 4/4] KVM: arm64: Introduce KVM_CAP_ARM_PROTECTED_VM
Message-ID: <YLk4e4hark3Zhi3f@google.com>
References: <20210603183347.1695-1-will@kernel.org>
 <20210603183347.1695-5-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603183347.1695-5-will@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021, Will Deacon wrote:
> +Enabling this capability causes all memory slots of the specified VM to be
> +unmapped from the host system and put into a state where they are no longer
> +configurable.

What happens if userspace remaps the hva of the memslot?  In other words, how
will the implementation ensure the physical memory backing the guest is truly
inaccessible?

And how will the guest/host share memory?  E.g. what if the guest wants to set
up a new shared memory region and the host wants that to happen in a new memslot?

On a related topic, would the concept of guest-only memory be useful[*]?  The
idea is to require userspace to map guest-private memory with a dedicated VMA
flag.  That will allow the host kernel to prevent userspace (or the kernel) from
mapping guest-private memory, and will also allow KVM to verify that memory that
the guest wants to be private is indeed private.

[*] https://lkml.kernel.org/r/20210416154106.23721-14-kirill.shutemov@linux.intel.com

> The memory slot corresponding to the ID passed in args[0] is
> +populated with the guest firmware image provided by the host firmware.

Why take a slot instead of an address range?  I assume copying the host firmware
into guest memory will utilize existing APIs, i.e. the memslot lookups to resolve
the GPA->HVA will Just Work (TM).

> +The first vCPU to enter the guest is defined to be the primary vCPU. All other
> +vCPUs belonging to the VM are secondary vCPUs.
> +
> +All vCPUs belonging to a VM with this capability enabled are initialised to a
> +pre-determined reset state irrespective of any prior configuration according to
> +the KVM_ARM_VCPU_INIT ioctl, with the following exceptions for the primary
> +vCPU:
> +
> +	===========	===========
> +	Register(s)	Reset value
> +	===========	===========
> +	X0-X14:		Preserved (see KVM_SET_ONE_REG)

What's the intended use case for allowing userspace to set a pile of registers?
Giving userspace control of vCPU state is tricky because the state is untrusted.
Is the state going to be attested in any way, or is the VMM trusted while the
VM is being created and only de-privileged later on?

> +	X15:		Boot protocol version (0)
> +	X16-X30:	Reserved (0)
> +	PC:		IPA base of firmware memory slot
> +	SP:		IPA end of firmware memory slot
> +	===========	===========
> +

...

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index c5d1f3c87dbd..e1d4a87d18e4 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1349,6 +1349,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  	bool writable = !(mem->flags & KVM_MEM_READONLY);
>  	int ret = 0;
>  
> +	if (kvm_vm_is_protected(kvm))
> +		return -EPERM;

FWIW, this will miss the benign corner case where KVM_SET_USER_MEMORY_REGION
does not actualy change anything about an existing region.

A more practical problem is that this check won't happen until KVM has marked
the existing region as invalid in the DELETE or MOVE case.  So userspace can't
completely delete a region, but it can temporarily delete a region by briefly
making it in invalid.  No idea what the ramifications of that are on arm64.

>  	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
>  			change != KVM_MR_FLAGS_ONLY)
>  		return 0;

...

> +static int pkvm_vm_ioctl_enable(struct kvm *kvm, u64 slotid)
> +{
> +	int ret = 0;

Deep into the nits: technically unnecessary since ret is guaranteed to be written
before being consumed.

> +	mutex_lock(&kvm->lock);
> +	if (kvm_vm_is_protected(kvm)) {
> +		ret = -EPERM;
> +		goto out_kvm_unlock;
> +	}
> +
> +	mutex_lock(&kvm->slots_lock);
> +	ret = pkvm_enable(kvm, slotid);
> +	if (ret)
> +		goto out_slots_unlock;
> +
> +	kvm->arch.pkvm.enabled = true;
> +out_slots_unlock:
> +	mutex_unlock(&kvm->slots_lock);
> +out_kvm_unlock:
> +	mutex_unlock(&kvm->lock);
> +	return ret;
> +}

...

> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 3fd9a7e9d90c..58ab8508be5e 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1082,6 +1082,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_SGX_ATTRIBUTE 196
>  #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
>  #define KVM_CAP_PTP_KVM 198
> +#define KVM_CAP_ARM_PROTECTED_VM 199

Rather than a dedicated (and arm-only) capability for protected VMs, what about
adding a capability to retrieve the supported VM types?  And obviously make
protected VMs a different type that must be specified at VM creation (there's
already plumbing for this).  Even if there's no current need to know at creation
time that a VM will be protected, it's also unlikely to be a burden on userspace
and could be nice to have down the road.  The late "activation" ioctl() can still
be supported, e.g. to start disallowing memslot updates.

x86 with TDX would look like:

        case KVM_CAP_VM_TYPES:
                r = BIT(KVM_X86_LEGACY_VM);
                if (kvm_x86_ops.is_vm_type_supported(KVM_X86_TDX_VM))
                        r |= BIT(KVM_X86_TDX_VM);
                break;

and arm64 would look like?

	case KVM_CAP_VM_TYPES:
		r = BIT(KVM_ARM64_LEGACY_VM);
		if (kvm_get_mode() == KVM_MODE_PROTECTED)
			r |= BIT(KVM_ARM64_PROTECTED_VM);
		break;

>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> -- 
> 2.32.0.rc0.204.g9fa02ecfa5-goog
> 
