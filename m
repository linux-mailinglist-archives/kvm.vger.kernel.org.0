Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6583623AE6A
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 22:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgHCUvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 16:51:07 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:31360 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgHCUvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 16:51:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596487863; x=1628023863;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=7hmJiqXO1QjsVHf3ybMRPRmWTRuaiQ2Cm7xIu6hQ4/0=;
  b=mDQKhPFYtjd/qNUd76k9ogftOy/NWpvUjNm0EKPR2JuXgA8PV8jZQq8n
   ngsmNQ3PANk6CCOB5c2nmvZPrp1GWIu+eA2nk59LKZCwUDMCWpDl2u5/0
   T0EHJj/2OGFw4rYrCQ2Uw7S5fVcqOVzzVJ19+Gz4S6kR3XXBmXhOrHPyX
   0=;
IronPort-SDR: fJScCY2otQlwkz6R5aO9aNbPMM+1a+Aosgc5qAbeNXO05JSFOFh2VSZvmH71aFrbBRZe9mkNVC
 QRooikfCh0mw==
X-IronPort-AV: E=Sophos;i="5.75,431,1589241600"; 
   d="scan'208";a="45770694"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 03 Aug 2020 20:51:01 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id 769ADA04B2;
        Mon,  3 Aug 2020 20:50:59 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 3 Aug 2020 20:50:58 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.34) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 3 Aug 2020 20:50:55 +0000
Subject: Re: [PATCH v3 2/3] KVM: x86: Introduce allow list for MSR emulation
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "KarimAllah Raslan" <karahmed@amazon.de>,
        Aaron Lewis <aaronlewis@google.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200731214947.16885-1-graf@amazon.com>
 <20200731214947.16885-3-graf@amazon.com>
 <87zh7cot7t.fsf@vitty.brq.redhat.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <2585c6d6-81b0-8375-78ed-862da226ad6c@amazon.com>
Date:   Mon, 3 Aug 2020 22:50:53 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <87zh7cot7t.fsf@vitty.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.34]
X-ClientProxiedBy: EX13D27UWA002.ant.amazon.com (10.43.160.30) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 03.08.20 13:37, Vitaly Kuznetsov wrote:
> =

> Alexander Graf <graf@amazon.com> writes:
> =

>> It's not desireable to have all MSRs always handled by KVM kernel space.=
 Some
>> MSRs would be useful to handle in user space to either emulate behavior =
(like
>> uCode updates) or differentiate whether they are valid based on the CPU =
model.
>>
>> To allow user space to specify which MSRs it wants to see handled by KVM,
>> this patch introduces a new ioctl to push allow lists of bitmaps into
>> KVM. Based on these bitmaps, KVM can then decide whether to reject MSR a=
ccess.
>> With the addition of KVM_CAP_X86_USER_SPACE_MSR it can also deflect the
>> denied MSR events to user space to operate on.
>>
>> If no allowlist is populated, MSR handling stays identical to before.
>>
>> Signed-off-by: KarimAllah Ahmed <karahmed@amazon.de>
>> Signed-off-by: Alexander Graf <graf@amazon.com>
>>
>> ---
>>
>> v2 -> v3:
>>
>>    - document flags for KVM_X86_ADD_MSR_ALLOWLIST
>>    - generalize exit path, always unlock when returning
>>    - s/KVM_CAP_ADD_MSR_ALLOWLIST/KVM_CAP_X86_MSR_ALLOWLIST/g
>>    - Add KVM_X86_CLEAR_MSR_ALLOWLIST
>> ---
>>   Documentation/virt/kvm/api.rst  |  91 +++++++++++++++++++++
>>   arch/x86/include/asm/kvm_host.h |  10 +++
>>   arch/x86/include/uapi/asm/kvm.h |  15 ++++
>>   arch/x86/kvm/x86.c              | 135 ++++++++++++++++++++++++++++++++
>>   include/uapi/linux/kvm.h        |   5 ++
>>   5 files changed, 256 insertions(+)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api=
.rst
>> index 79c3e2fdfae4..d611ddd326fc 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -4697,6 +4697,82 @@ KVM_PV_VM_VERIFY
>>     Verify the integrity of the unpacked image. Only if this succeeds,
>>     KVM is allowed to start protected VCPUs.
>>
>> +4.126 KVM_X86_ADD_MSR_ALLOWLIST
>> +-------------------------------
>> +
>> +:Capability: KVM_CAP_X86_MSR_ALLOWLIST
>> +:Architectures: x86
>> +:Type: vm ioctl
>> +:Parameters: struct kvm_msr_allowlist
>> +:Returns: 0 on success, < 0 on error
>> +
>> +::
>> +
>> +  struct kvm_msr_allowlist {
>> +         __u32 flags;
>> +         __u32 nmsrs; /* number of msrs in bitmap */
>> +         __u32 base;  /* base address for the MSRs bitmap */
>> +         __u32 pad;
>> +
>> +         __u8 bitmap[0]; /* a set bit allows that the operation set in =
flags */
>> +  };
>> +
>> +flags values:
>> +
>> +KVM_MSR_ALLOW_READ
>> +
>> +  Filter read accesses to MSRs using the given bitmap. A 0 in the bitmap
>> +  indicates that a read should immediately fail, while a 1 indicates th=
at
>> +  a read should be handled by the normal KVM MSR emulation logic.
>> +
>> +KVM_MSR_ALLOW_WRITE
>> +
>> +  Filter write accesses to MSRs using the given bitmap. A 0 in the bitm=
ap
>> +  indicates that a write should immediately fail, while a 1 indicates t=
hat
>> +  a write should be handled by the normal KVM MSR emulation logic.
>> +
>> +KVM_MSR_ALLOW_READ | KVM_MSR_ALLOW_WRITE
>> +
> =

> Should we probably say what KVM_MSR_ALLOW_READ/KVM_MSR_ALLOW_WRITE are
> equal to? (1 << 0, 1 << 1)?
> =

>> +  Filter booth read and write accesses to MSRs using the given bitmap. =
A 0
>> +  in the bitmap indicates that both reads and writes should immediately=
 fail,
>> +  while a 1 indicates that reads and writes should be handled by the no=
rmal
>> +  KVM MSR emulation logic.
>> +
>> +This ioctl allows user space to define a set of bitmaps of MSR ranges to
>> +specify whether a certain MSR access is allowed or not.
>> +
>> +If this ioctl has never been invoked, MSR accesses are not guarded and =
the
>> +old KVM in-kernel emulation behavior is fully preserved.
>> +
>> +As soon as the first allow list was specified, only allowed MSR accesses
>> +are permitted inside of KVM's MSR code.
>> +
>> +Each allowlist specifies a range of MSRs to potentially allow access on.
>> +The range goes from MSR index [base .. base+nmsrs]. The flags field
>> +indicates whether reads, writes or both reads and writes are permitted
>> +by setting a 1 bit in the bitmap for the corresponding MSR index.
>> +
>> +If an MSR access is not permitted through the allow list, it generates a
>> +#GP inside the guest. When combined with KVM_CAP_X86_USER_SPACE_MSR, th=
at
>> +allows user space to deflect and potentially handle various MSR accesses
>> +into user space.
>> +
>> +4.124 KVM_X86_CLEAR_MSR_ALLOWLIST
>> +---------------------------------
>> +
>> +:Capability: KVM_CAP_X86_MSR_ALLOWLIST
>> +:Architectures: x86
>> +:Type: vcpu ioctl
>> +:Parameters: none
>> +:Returns: 0
>> +
>> +This ioctl resets all internal MSR allow lists. After this call, no all=
ow
>> +list is present and the guest would execute as if no allow lists were s=
et,
>> +so all MSRs are considered allowed and thus handled by the in-kernel MSR
>> +emulation logic.
>> +
>> +No vCPU may be in running state when calling this ioctl.
>> +
>>
>>   5. The kvm_run structure
>>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>> @@ -6213,3 +6289,18 @@ writes to user space. It can be enabled on a VM l=
evel. If enabled, MSR
>>   accesses that would usually trigger a #GP by KVM into the guest will
>>   instead get bounced to user space through the KVM_EXIT_X86_RDMSR and
>>   KVM_EXIT_X86_WRMSR exit notifications.
>> +
>> +8.25 KVM_CAP_X86_MSR_ALLOWLIST
>> +------------------------------
>> +
>> +:Architectures: x86
>> +
>> +This capability indicates that KVM supports emulation of only select MSR
>> +registers. With this capability exposed, KVM exports two new VM ioctls:
>> +KVM_X86_ADD_MSR_ALLOWLIST which user space can call to specify bitmaps =
of MSR
>> +ranges that KVM should emulate in kernel space and KVM_X86_CLEAR_MSR_AL=
LOWLIST
>> +which user space can call to remove all MSR allow lists from the VM con=
text.
>> +
>> +In combination with KVM_CAP_X86_USER_SPACE_MSR, this allows user space =
to
>> +trap and emulate MSRs that are outside of the scope of KVM as well as
>> +limit the attack surface on KVM's MSR emulation code.
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_=
host.h
>> index 809eed0dbdea..21358ed4e590 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -904,6 +904,13 @@ struct kvm_hv {
>>        struct kvm_hv_syndbg hv_syndbg;
>>   };
>>
>> +struct msr_bitmap_range {
>> +     u32 flags;
>> +     u32 nmsrs;
>> +     u32 base;
>> +     unsigned long *bitmap;
>> +};
>> +
>>   enum kvm_irqchip_mode {
>>        KVM_IRQCHIP_NONE,
>>        KVM_IRQCHIP_KERNEL,       /* created with KVM_CREATE_IRQCHIP */
>> @@ -1008,6 +1015,9 @@ struct kvm_arch {
>>        /* Deflect RDMSR and WRMSR to user space when they trigger a #GP =
*/
>>        bool user_space_msr_enabled;
>>
>> +     struct msr_bitmap_range msr_allowlist_ranges[10];
>> +     int msr_allowlist_ranges_count;
>> +
>>        struct kvm_pmu_event_filter *pmu_event_filter;
>>        struct task_struct *nx_lpage_recovery_thread;
>>   };
>> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm=
/kvm.h
>> index 0780f97c1850..c33fb1d72d52 100644
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -192,6 +192,21 @@ struct kvm_msr_list {
>>        __u32 indices[0];
>>   };
>>
>> +#define KVM_MSR_ALLOW_READ  (1 << 0)
>> +#define KVM_MSR_ALLOW_WRITE (1 << 1)
>> +
>> +/* Maximum size of the of the bitmap in bytes */
>> +#define KVM_MSR_ALLOWLIST_MAX_LEN 0x600
>> +
>> +/* for KVM_X86_ADD_MSR_ALLOWLIST */
>> +struct kvm_msr_allowlist {
>> +     __u32 flags;
>> +     __u32 nmsrs; /* number of msrs in bitmap */
>> +     __u32 base;  /* base address for the MSRs bitmap */
>> +     __u32 pad;
>> +
>> +     __u8 bitmap[0]; /* a set bit allows that the operation set in flag=
s */
>> +};
>>
>>   struct kvm_cpuid_entry {
>>        __u32 function;
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 24c72250f6df..7a2be00a3512 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1472,6 +1472,29 @@ void kvm_enable_efer_bits(u64 mask)
>>   }
>>   EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
>>
>> +static bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
>> +{
>> +     struct msr_bitmap_range *ranges =3D vcpu->kvm->arch.msr_allowlist_=
ranges;
>> +     u32 count =3D vcpu->kvm->arch.msr_allowlist_ranges_count;
>> +     u32 i;
>> +
>> +     /* MSR allowlist not set up, allow everything */
>> +     if (!count)
>> +             return true;
>> +
>> +     for (i =3D 0; i < count; i++) {
>> +             u32 start =3D ranges[i].base;
>> +             u32 end =3D start + ranges[i].nmsrs;
>> +             int flags =3D ranges[i].flags;
> =

> u32 flags?

Yes, much better :).

> =

>> +             unsigned long *bitmap =3D ranges[i].bitmap;
>> +
>> +             if ((index >=3D start) && (index < end) && (flags & type))
>> +                     return !!test_bit(index - start, bitmap);
>> +     }
>> +
>> +     return false;
>> +}
>> +
>>   /*
>>    * Write @data into the MSR specified by @index.  Select MSR specific =
fault
>>    * checks are bypassed if @host_initiated is %true.
>> @@ -1483,6 +1506,9 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u3=
2 index, u64 data,
>>   {
>>        struct msr_data msr;
>>
>> +     if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_ALLOW=
_WRITE))
>> +             return -ENOENT;
>> +
>>        switch (index) {
>>        case MSR_FS_BASE:
>>        case MSR_GS_BASE:
>> @@ -1528,6 +1554,9 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index=
, u64 *data,
>>        struct msr_data msr;
>>        int ret;
>>
>> +     if (!host_initiated && !kvm_msr_allowed(vcpu, index, KVM_MSR_ALLOW=
_READ))
>> +             return -ENOENT;
>> +
>>        msr.index =3D index;
>>        msr.host_initiated =3D host_initiated;
>>
>> @@ -3550,6 +3579,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, =
long ext)
>>        case KVM_CAP_EXCEPTION_PAYLOAD:
>>        case KVM_CAP_SET_GUEST_DEBUG:
>>        case KVM_CAP_X86_USER_SPACE_MSR:
>> +     case KVM_CAP_X86_MSR_ALLOWLIST:
>>                r =3D 1;
>>                break;
>>        case KVM_CAP_SYNC_REGS:
>> @@ -5075,6 +5105,101 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>        return r;
>>   }
>>
>> +static bool msr_range_overlaps(struct kvm *kvm, struct msr_bitmap_range=
 *range)
>> +{
>> +     struct msr_bitmap_range *ranges =3D kvm->arch.msr_allowlist_ranges;
>> +     u32 i, count =3D kvm->arch.msr_allowlist_ranges_count;
>> +
>> +     for (i =3D 0; i < count; i++) {
>> +             u32 start =3D max(range->base, ranges[i].base);
>> +             u32 end =3D min(range->base + range->nmsrs,
>> +                           ranges[i].base + ranges[i].nmsrs);
>> +
>> +             if ((start < end) && (range->flags & ranges[i].flags))
>> +                     return true;
>> +     }
>> +
>> +     return false;
>> +}
>> +
>> +static int kvm_vm_ioctl_add_msr_allowlist(struct kvm *kvm, void __user =
*argp)
>> +{
>> +     struct msr_bitmap_range *ranges =3D kvm->arch.msr_allowlist_ranges;
>> +     struct kvm_msr_allowlist __user *user_msr_allowlist =3D argp;
>> +     struct msr_bitmap_range range;
>> +     struct kvm_msr_allowlist kernel_msr_allowlist;
>> +     unsigned long *bitmap =3D NULL;
>> +     size_t bitmap_size;
>> +     int r =3D 0;
>> +
>> +     if (copy_from_user(&kernel_msr_allowlist, user_msr_allowlist,
>> +                        sizeof(kernel_msr_allowlist))) {
>> +             r =3D -EFAULT;
>> +             goto out;
>> +     }
>> +
>> +     bitmap_size =3D BITS_TO_LONGS(kernel_msr_allowlist.nmsrs) * sizeof=
(long);
>> +     if (bitmap_size > KVM_MSR_ALLOWLIST_MAX_LEN) {
>> +             r =3D -EINVAL;
>> +             goto out;
>> +     }
>> +
>> +     bitmap =3D memdup_user(user_msr_allowlist->bitmap, bitmap_size);
>> +     if (IS_ERR(bitmap)) {
>> +             r =3D PTR_ERR(bitmap);
>> +             goto out;
>> +     }
>> +
>> +     range =3D (struct msr_bitmap_range) {
>> +             .flags =3D kernel_msr_allowlist.flags,
>> +             .base =3D kernel_msr_allowlist.base,
>> +             .nmsrs =3D kernel_msr_allowlist.nmsrs,
>> +             .bitmap =3D bitmap,
>> +     };
>> +
>> +     if (range.flags & ~(KVM_MSR_ALLOW_READ | KVM_MSR_ALLOW_WRITE)) {
>> +             r =3D -EINVAL;
>> +             goto out;
>> +     }
>> +
>> +     /*
>> +      * Protect from concurrent calls to this function that could trigg=
er
>> +      * a TOCTOU violation on kvm->arch.msr_allowlist_ranges_count.
>> +      */
>> +     mutex_lock(&kvm->lock);
>> +
>> +     if (kvm->arch.msr_allowlist_ranges_count >=3D
>> +         ARRAY_SIZE(kvm->arch.msr_allowlist_ranges)) {
>> +             r =3D -E2BIG;
>> +             goto out_locked;
>> +     }
>> +
>> +     if (msr_range_overlaps(kvm, &range)) {
>> +             r =3D -EINVAL;
>> +             goto out_locked;
>> +     }
>> +
>> +     /* Everything ok, add this range identifier to our global pool */
>> +     ranges[kvm->arch.msr_allowlist_ranges_count++] =3D range;
>> +
>> +out_locked:
>> +     mutex_unlock(&kvm->lock);
>> +out:
>> +     if (r)
>> +             kfree(bitmap);
>> +
>> +     return r;
>> +}
>> +
>> +static int kvm_vm_ioctl_clear_msr_allowlist(struct kvm *kvm)
>> +{
>> +     mutex_lock(&kvm->lock);
>> +     kvm->arch.msr_allowlist_ranges_count =3D 0;
>> +     mutex_unlock(&kvm->lock);
> =

> Are we also supposed to kfree() bitmaps here?

Phew. Yes, because without the kfree() we're leaking memory. =

Unfortunately if I just put in a kfree() here, we may allow a =

concurrently executing vCPU to access already free'd memory.

So I'll also add locking around the range check. Let's hope it won't =

regress performance too much.


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



