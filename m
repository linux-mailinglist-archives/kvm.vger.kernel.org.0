Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC44735E823
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 23:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348408AbhDMVUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 17:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237436AbhDMVUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 17:20:30 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEC7C061574
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 14:20:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:104d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 2A6062CD;
        Tue, 13 Apr 2021 21:20:09 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 2A6062CD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1618348809; bh=Il5gLbQR40zpuhAPfRWF2re7BPxgJ1q3gUuDmwfRWFI=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=bd0VPsG3LjDeMZFrDljFe39cMIITBHXrgfHGBojH2JfqqacrElgmdxxWYBMtcxgAJ
         VtW4SrJZ1BrjW3aWJDkaTYMSSlt5U4y5QH4q0Vi0S/g8T4OYgr2m7wPga/7SN85TlM
         U5yJmypHmGxueczWS2W4dsIt7ODRM8zGgD/Z+pxKsLo8Df+wsT8jjam/I3zUNxzSNO
         b2C2zr9oms7737ESLQJ+hq9xNccFNiauUvtvNKu9W1Q1u4vkeJh7wlB99pG+dORTt9
         Iuga9LN3RRxqNYOv72+oZ/1//JaI5jAi++BPEeYkAXS3H53OsSUaS0HhB86GVerRqb
         Cwvgz+ATIAk0Q==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        linux-doc@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] doc/virt/kvm: move KVM_X86_SET_MSR_FILTER in section 8
In-Reply-To: <20210316170814.64286-1-eesposit@redhat.com>
References: <20210316170814.64286-1-eesposit@redhat.com>
Date:   Tue, 13 Apr 2021 15:20:08 -0600
Message-ID: <87v98priev.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Emanuele Giuseppe Esposito <eesposit@redhat.com> writes:

> KVM_X86_SET_MSR_FILTER is a capability, not an ioctl.
> Therefore move it from section 4.97 to the new 8.31 (other capabilities).
>
> To fill the gap, move KVM_X86_SET_MSR_FILTER (was 4.126) to
> 4.97, and shifted Xen-related ioctl (were 4.127 - 4.130) by
> one place (4.126 - 4.129).
>
> Also fixed minor typo in KVM_GET_MSR_INDEX_LIST ioctl description
> (section 4.3).
>
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst | 250 ++++++++++++++++-----------------
>  1 file changed, 125 insertions(+), 125 deletions(-)

Paolo, what's your thought on this one?  If it's OK should I pick it up?

Thanks,

jon

>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 1a2b5210cdbf..a230140d6a7f 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -201,7 +201,7 @@ Errors:
>  
>    ======     ============================================================
>    EFAULT     the msr index list cannot be read from or written to
> -  E2BIG      the msr index list is to be to fit in the array specified by
> +  E2BIG      the msr index list is too big to fit in the array specified by
>               the user.
>    ======     ============================================================
>  
> @@ -3686,31 +3686,105 @@ which is the maximum number of possibly pending cpu-local interrupts.
>  
>  Queues an SMI on the thread's vcpu.
>  
> -4.97 KVM_CAP_PPC_MULTITCE
> --------------------------
> +4.97 KVM_X86_SET_MSR_FILTER
> +----------------------------
>  
> -:Capability: KVM_CAP_PPC_MULTITCE
> -:Architectures: ppc
> -:Type: vm
> +:Capability: KVM_X86_SET_MSR_FILTER
> +:Architectures: x86
> +:Type: vm ioctl
> +:Parameters: struct kvm_msr_filter
> +:Returns: 0 on success, < 0 on error
>  
> -This capability means the kernel is capable of handling hypercalls
> -H_PUT_TCE_INDIRECT and H_STUFF_TCE without passing those into the user
> -space. This significantly accelerates DMA operations for PPC KVM guests.
> -User space should expect that its handlers for these hypercalls
> -are not going to be called if user space previously registered LIOBN
> -in KVM (via KVM_CREATE_SPAPR_TCE or similar calls).
> +::
>  
> -In order to enable H_PUT_TCE_INDIRECT and H_STUFF_TCE use in the guest,
> -user space might have to advertise it for the guest. For example,
> -IBM pSeries (sPAPR) guest starts using them if "hcall-multi-tce" is
> -present in the "ibm,hypertas-functions" device-tree property.
> +  struct kvm_msr_filter_range {
> +  #define KVM_MSR_FILTER_READ  (1 << 0)
> +  #define KVM_MSR_FILTER_WRITE (1 << 1)
> +	__u32 flags;
> +	__u32 nmsrs; /* number of msrs in bitmap */
> +	__u32 base;  /* MSR index the bitmap starts at */
> +	__u8 *bitmap; /* a 1 bit allows the operations in flags, 0 denies */
> +  };
>  
> -The hypercalls mentioned above may or may not be processed successfully
> -in the kernel based fast path. If they can not be handled by the kernel,
> -they will get passed on to user space. So user space still has to have
> -an implementation for these despite the in kernel acceleration.
> +  #define KVM_MSR_FILTER_MAX_RANGES 16
> +  struct kvm_msr_filter {
> +  #define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
> +  #define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
> +	__u32 flags;
> +	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
> +  };
>  
> -This capability is always enabled.
> +flags values for ``struct kvm_msr_filter_range``:
> +
> +``KVM_MSR_FILTER_READ``
> +
> +  Filter read accesses to MSRs using the given bitmap. A 0 in the bitmap
> +  indicates that a read should immediately fail, while a 1 indicates that
> +  a read for a particular MSR should be handled regardless of the default
> +  filter action.
> +
> +``KVM_MSR_FILTER_WRITE``
> +
> +  Filter write accesses to MSRs using the given bitmap. A 0 in the bitmap
> +  indicates that a write should immediately fail, while a 1 indicates that
> +  a write for a particular MSR should be handled regardless of the default
> +  filter action.
> +
> +``KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE``
> +
> +  Filter both read and write accesses to MSRs using the given bitmap. A 0
> +  in the bitmap indicates that both reads and writes should immediately fail,
> +  while a 1 indicates that reads and writes for a particular MSR are not
> +  filtered by this range.
> +
> +flags values for ``struct kvm_msr_filter``:
> +
> +``KVM_MSR_FILTER_DEFAULT_ALLOW``
> +
> +  If no filter range matches an MSR index that is getting accessed, KVM will
> +  fall back to allowing access to the MSR.
> +
> +``KVM_MSR_FILTER_DEFAULT_DENY``
> +
> +  If no filter range matches an MSR index that is getting accessed, KVM will
> +  fall back to rejecting access to the MSR. In this mode, all MSRs that should
> +  be processed by KVM need to explicitly be marked as allowed in the bitmaps.
> +
> +This ioctl allows user space to define up to 16 bitmaps of MSR ranges to
> +specify whether a certain MSR access should be explicitly filtered for or not.
> +
> +If this ioctl has never been invoked, MSR accesses are not guarded and the
> +default KVM in-kernel emulation behavior is fully preserved.
> +
> +Calling this ioctl with an empty set of ranges (all nmsrs == 0) disables MSR
> +filtering. In that mode, ``KVM_MSR_FILTER_DEFAULT_DENY`` is invalid and causes
> +an error.
> +
> +As soon as the filtering is in place, every MSR access is processed through
> +the filtering except for accesses to the x2APIC MSRs (from 0x800 to 0x8ff);
> +x2APIC MSRs are always allowed, independent of the ``default_allow`` setting,
> +and their behavior depends on the ``X2APIC_ENABLE`` bit of the APIC base
> +register.
> +
> +If a bit is within one of the defined ranges, read and write accesses are
> +guarded by the bitmap's value for the MSR index if the kind of access
> +is included in the ``struct kvm_msr_filter_range`` flags.  If no range
> +cover this particular access, the behavior is determined by the flags
> +field in the kvm_msr_filter struct: ``KVM_MSR_FILTER_DEFAULT_ALLOW``
> +and ``KVM_MSR_FILTER_DEFAULT_DENY``.
> +
> +Each bitmap range specifies a range of MSRs to potentially allow access on.
> +The range goes from MSR index [base .. base+nmsrs]. The flags field
> +indicates whether reads, writes or both reads and writes are filtered
> +by setting a 1 bit in the bitmap for the corresponding MSR index.
> +
> +If an MSR access is not permitted through the filtering, it generates a
> +#GP inside the guest. When combined with KVM_CAP_X86_USER_SPACE_MSR, that
> +allows user space to deflect and potentially handle various MSR accesses
> +into user space.
> +
> +If a vCPU is in running state while this ioctl is invoked, the vCPU may
> +experience inconsistent filtering behavior on MSR accesses.
>  
>  4.98 KVM_CREATE_SPAPR_TCE_64
>  ----------------------------
> @@ -4706,107 +4780,7 @@ KVM_PV_VM_VERIFY
>    Verify the integrity of the unpacked image. Only if this succeeds,
>    KVM is allowed to start protected VCPUs.
>  
> -4.126 KVM_X86_SET_MSR_FILTER
> -----------------------------
> -
> -:Capability: KVM_X86_SET_MSR_FILTER
> -:Architectures: x86
> -:Type: vm ioctl
> -:Parameters: struct kvm_msr_filter
> -:Returns: 0 on success, < 0 on error
> -
> -::
> -
> -  struct kvm_msr_filter_range {
> -  #define KVM_MSR_FILTER_READ  (1 << 0)
> -  #define KVM_MSR_FILTER_WRITE (1 << 1)
> -	__u32 flags;
> -	__u32 nmsrs; /* number of msrs in bitmap */
> -	__u32 base;  /* MSR index the bitmap starts at */
> -	__u8 *bitmap; /* a 1 bit allows the operations in flags, 0 denies */
> -  };
> -
> -  #define KVM_MSR_FILTER_MAX_RANGES 16
> -  struct kvm_msr_filter {
> -  #define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
> -  #define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
> -	__u32 flags;
> -	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
> -  };
> -
> -flags values for ``struct kvm_msr_filter_range``:
> -
> -``KVM_MSR_FILTER_READ``
> -
> -  Filter read accesses to MSRs using the given bitmap. A 0 in the bitmap
> -  indicates that a read should immediately fail, while a 1 indicates that
> -  a read for a particular MSR should be handled regardless of the default
> -  filter action.
> -
> -``KVM_MSR_FILTER_WRITE``
> -
> -  Filter write accesses to MSRs using the given bitmap. A 0 in the bitmap
> -  indicates that a write should immediately fail, while a 1 indicates that
> -  a write for a particular MSR should be handled regardless of the default
> -  filter action.
> -
> -``KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE``
> -
> -  Filter both read and write accesses to MSRs using the given bitmap. A 0
> -  in the bitmap indicates that both reads and writes should immediately fail,
> -  while a 1 indicates that reads and writes for a particular MSR are not
> -  filtered by this range.
> -
> -flags values for ``struct kvm_msr_filter``:
> -
> -``KVM_MSR_FILTER_DEFAULT_ALLOW``
> -
> -  If no filter range matches an MSR index that is getting accessed, KVM will
> -  fall back to allowing access to the MSR.
> -
> -``KVM_MSR_FILTER_DEFAULT_DENY``
> -
> -  If no filter range matches an MSR index that is getting accessed, KVM will
> -  fall back to rejecting access to the MSR. In this mode, all MSRs that should
> -  be processed by KVM need to explicitly be marked as allowed in the bitmaps.
> -
> -This ioctl allows user space to define up to 16 bitmaps of MSR ranges to
> -specify whether a certain MSR access should be explicitly filtered for or not.
> -
> -If this ioctl has never been invoked, MSR accesses are not guarded and the
> -default KVM in-kernel emulation behavior is fully preserved.
> -
> -Calling this ioctl with an empty set of ranges (all nmsrs == 0) disables MSR
> -filtering. In that mode, ``KVM_MSR_FILTER_DEFAULT_DENY`` is invalid and causes
> -an error.
> -
> -As soon as the filtering is in place, every MSR access is processed through
> -the filtering except for accesses to the x2APIC MSRs (from 0x800 to 0x8ff);
> -x2APIC MSRs are always allowed, independent of the ``default_allow`` setting,
> -and their behavior depends on the ``X2APIC_ENABLE`` bit of the APIC base
> -register.
> -
> -If a bit is within one of the defined ranges, read and write accesses are
> -guarded by the bitmap's value for the MSR index if the kind of access
> -is included in the ``struct kvm_msr_filter_range`` flags.  If no range
> -cover this particular access, the behavior is determined by the flags
> -field in the kvm_msr_filter struct: ``KVM_MSR_FILTER_DEFAULT_ALLOW``
> -and ``KVM_MSR_FILTER_DEFAULT_DENY``.
> -
> -Each bitmap range specifies a range of MSRs to potentially allow access on.
> -The range goes from MSR index [base .. base+nmsrs]. The flags field
> -indicates whether reads, writes or both reads and writes are filtered
> -by setting a 1 bit in the bitmap for the corresponding MSR index.
> -
> -If an MSR access is not permitted through the filtering, it generates a
> -#GP inside the guest. When combined with KVM_CAP_X86_USER_SPACE_MSR, that
> -allows user space to deflect and potentially handle various MSR accesses
> -into user space.
> -
> -If a vCPU is in running state while this ioctl is invoked, the vCPU may
> -experience inconsistent filtering behavior on MSR accesses.
> -
> -4.127 KVM_XEN_HVM_SET_ATTR
> +4.126 KVM_XEN_HVM_SET_ATTR
>  --------------------------
>  
>  :Capability: KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO
> @@ -4849,7 +4823,7 @@ KVM_XEN_ATTR_TYPE_SHARED_INFO
>  KVM_XEN_ATTR_TYPE_UPCALL_VECTOR
>    Sets the exception vector used to deliver Xen event channel upcalls.
>  
> -4.128 KVM_XEN_HVM_GET_ATTR
> +4.127 KVM_XEN_HVM_GET_ATTR
>  --------------------------
>  
>  :Capability: KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO
> @@ -4861,7 +4835,7 @@ KVM_XEN_ATTR_TYPE_UPCALL_VECTOR
>  Allows Xen VM attributes to be read. For the structure and types,
>  see KVM_XEN_HVM_SET_ATTR above.
>  
> -4.129 KVM_XEN_VCPU_SET_ATTR
> +4.128 KVM_XEN_VCPU_SET_ATTR
>  ---------------------------
>  
>  :Capability: KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO
> @@ -4923,7 +4897,7 @@ KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST
>    or RUNSTATE_offline) to set the current accounted state as of the
>    adjusted state_entry_time.
>  
> -4.130 KVM_XEN_VCPU_GET_ATTR
> +4.129 KVM_XEN_VCPU_GET_ATTR
>  ---------------------------
>  
>  :Capability: KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO
> @@ -6721,3 +6695,29 @@ vcpu_info is set.
>  The KVM_XEN_HVM_CONFIG_RUNSTATE flag indicates that the runstate-related
>  features KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR/_CURRENT/_DATA/_ADJUST are
>  supported by the KVM_XEN_VCPU_SET_ATTR/KVM_XEN_VCPU_GET_ATTR ioctls.
> +
> +8.31 KVM_CAP_PPC_MULTITCE
> +-------------------------
> +
> +:Capability: KVM_CAP_PPC_MULTITCE
> +:Architectures: ppc
> +:Type: vm
> +
> +This capability means the kernel is capable of handling hypercalls
> +H_PUT_TCE_INDIRECT and H_STUFF_TCE without passing those into the user
> +space. This significantly accelerates DMA operations for PPC KVM guests.
> +User space should expect that its handlers for these hypercalls
> +are not going to be called if user space previously registered LIOBN
> +in KVM (via KVM_CREATE_SPAPR_TCE or similar calls).
> +
> +In order to enable H_PUT_TCE_INDIRECT and H_STUFF_TCE use in the guest,
> +user space might have to advertise it for the guest. For example,
> +IBM pSeries (sPAPR) guest starts using them if "hcall-multi-tce" is
> +present in the "ibm,hypertas-functions" device-tree property.
> +
> +The hypercalls mentioned above may or may not be processed successfully
> +in the kernel based fast path. If they can not be handled by the kernel,
> +they will get passed on to user space. So user space still has to have
> +an implementation for these despite the in kernel acceleration.
> +
> +This capability is always enabled.
> \ No newline at end of file
> -- 
> 2.29.2
