Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46C6A7CA88C
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 14:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbjJPMyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 08:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbjJPMyJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 08:54:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E040E10A
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 05:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697460801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qlaE6UMbmEkqQ8GbXYTLhD3UOmAaRozmlT1OkfGtYBs=;
        b=gKfKAna1KgTP96278gr91iwwgIA1usAm4wOGqlJFFYhrSxhur+01KvagvzPhIm9J6LaRte
        xJy9RF7EQingkJkm/r1zWfZiSQ6t0FZZ46xTXumdKftMi0skUf54oc8z/+IrhgG1eoWGAF
        okNv5Mu8M0GfTrJE6QjNhnpb2DvzJo0=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-97-Wd3Ueq6dPSalXn8P1RG7cg-1; Mon, 16 Oct 2023 08:53:10 -0400
X-MC-Unique: Wd3Ueq6dPSalXn8P1RG7cg-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-5a818c1d2c7so49883417b3.0
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 05:53:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697460789; x=1698065589;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qlaE6UMbmEkqQ8GbXYTLhD3UOmAaRozmlT1OkfGtYBs=;
        b=tDnDhKDZ8fJKu+Rfx+g9+B5oCf3nlD2UcLOOvlZ1wf6RAwShCq+8Nlxvi/0PXnLrC7
         G7wjK+KSg+ICjEmq35JBJtQuY3v3LARvOKRkBt6gCwnVHMkm91vWN8hIo58OXI8GfCVn
         9x4RlL6EtnhMkID0hgFYwAleHEGA9MlEO/Y/+gjMER7Wok5BfxlF8GwuLRxjF1SNUYxW
         kjmnlXR18csTsAXNaJAzVUa6vVuT1Z0dfii83UhLUooCSUGH8Bl9lFDBGz/01oFk//oU
         mVAVtJUDrUDsG7gfWmCUftrOxaYCwjzjnf7yzkwtRISzHuCNbYD/DUXMvJ1PBPAmUEHH
         WYOQ==
X-Gm-Message-State: AOJu0YxrkBI82Ib4t2knebTcdZXpPLzYigIYbOyKAs/G/z/0RvyBscgv
        UcvTtXmZ9lv4Ui+LKA2hhXTZ7BthOxv8Oyxh7y7lbbrmkhQGbLHU5PlL9iyKta+Tksn2gcqAV/v
        AJYUWhOrb7xJu
X-Received: by 2002:a25:2d2:0:b0:d9a:fd25:e3ef with SMTP id 201-20020a2502d2000000b00d9afd25e3efmr8308116ybc.64.1697460789596;
        Mon, 16 Oct 2023 05:53:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYhJtGvFMJH3+J+3ml8N0ftf9iWMVMIFIewJx+Uj9uh1v48CMZ/xhFAmzEpldfClOge9GIog==
X-Received: by 2002:a25:2d2:0:b0:d9a:fd25:e3ef with SMTP id 201-20020a2502d2000000b00d9afd25e3efmr8308098ybc.64.1697460789118;
        Mon, 16 Oct 2023 05:53:09 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id f8-20020a0cc308000000b0066d05ed3778sm3399954qvi.56.2023.10.16.05.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 05:53:08 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 07/11] KVM: x86: Make Hyper-V emulation optional
In-Reply-To: <708a5bb2dfb0cb085bd9215c2e8e4d0b3db69665.camel@redhat.com>
References: <20231010160300.1136799-1-vkuznets@redhat.com>
 <20231010160300.1136799-8-vkuznets@redhat.com>
 <708a5bb2dfb0cb085bd9215c2e8e4d0b3db69665.camel@redhat.com>
Date:   Mon, 16 Oct 2023 14:53:06 +0200
Message-ID: <87h6mq91al.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> =D0=A3 =D0=B2=D1=82, 2023-10-10 =D1=83 18:02 +0200, Vitaly Kuznetsov =D0=
=BF=D0=B8=D1=88=D0=B5:
>> Hyper-V emulation in KVM is a fairly big chunk and in some cases it may =
be
>> desirable to not compile it in to reduce module sizes as well as attack
>> surface. Introduce CONFIG_KVM_HYPERV option to make it possible.
>>=20
>> Note, there's room for further nVMX/nSVM code optimizations when
>> !CONFIG_KVM_HYPERV, this will be done in follow-up patches.
>
> Maybe CONFIG_KVM_HYPERV_GUEST_SUPPORT or CONFIG_HYPERV_ON_KVM instead?
>
> IMHO CONFIG_KVM_HYPERV_GUEST_SUPPORT sounds good.

We already have CONFIG_KVM_XEN so I decided to stay concise. I do
understand that 'KVM-on-Hyper-V' and 'Hyper-V-on-KVM' mess which creates
the confusion though.

>
>>=20
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |  4 +++
>>  arch/x86/kvm/Kconfig            |  9 ++++++
>>  arch/x86/kvm/Makefile           | 17 +++++++---
>>  arch/x86/kvm/cpuid.c            |  6 ++++
>>  arch/x86/kvm/hyperv.h           | 29 +++++++++++++++--
>>  arch/x86/kvm/irq_comm.c         |  9 +++++-
>>  arch/x86/kvm/svm/hyperv.h       |  7 +++++
>>  arch/x86/kvm/svm/nested.c       |  2 ++
>>  arch/x86/kvm/svm/svm_onhyperv.h |  2 ++
>>  arch/x86/kvm/vmx/hyperv.h       |  8 +++++
>>  arch/x86/kvm/vmx/nested.c       | 17 ++++++++++
>>  arch/x86/kvm/x86.c              | 56 +++++++++++++++++++++++----------
>>  12 files changed, 143 insertions(+), 23 deletions(-)
>>=20
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_=
host.h
>> index 711dc880a9f0..b0a55b736b47 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1085,6 +1085,7 @@ enum hv_tsc_page_status {
>>  	HV_TSC_PAGE_BROKEN,
>>  };
>>=20=20
>> +#ifdef CONFIG_KVM_HYPERV
>>  /* Hyper-V emulation context */
>>  struct kvm_hv {
>>  	struct mutex hv_lock;
>> @@ -1117,6 +1118,7 @@ struct kvm_hv {
>>=20=20
>>  	struct kvm_hv_syndbg hv_syndbg;
>>  };
>> +#endif
>>=20=20
>>  struct msr_bitmap_range {
>>  	u32 flags;
>> @@ -1338,7 +1340,9 @@ struct kvm_arch {
>>  	/* reads protected by irq_srcu, writes by irq_lock */
>>  	struct hlist_head mask_notifier_list;
>>=20=20
>> +#ifdef CONFIG_KVM_HYPERV
>>  	struct kvm_hv hyperv;
>> +#endif
>>=20=20
>>  #ifdef CONFIG_KVM_XEN
>>  	struct kvm_xen xen;
>> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
>> index ed90f148140d..a06e19a8a8f6 100644
>> --- a/arch/x86/kvm/Kconfig
>> +++ b/arch/x86/kvm/Kconfig
>> @@ -129,6 +129,15 @@ config KVM_SMM
>>=20=20
>>  	  If unsure, say Y.
>>=20=20
>> +config KVM_HYPERV
>> +	bool "Support for Microsoft Hyper-V emulation"
>> +	depends on KVM
>> +	default y
>> +	help
>> +	  Provides KVM support for emulating Microsoft Hypervisor (Hyper-V).
>
>
> It feels to me that the KConfig option can have a longer description.
>
> What do you think about something like that:
>
> "Provides KVM support for emulating Microsoft Hypervisor (Hyper-V).
>
> This makes KVM expose a set of paravirtualized interfaces,=20
> documented in the HyperV TLFS,=20
> https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/refere=
nce/tlfs,
> which consists of a subset of paravirtualized interfaces that HyperV expo=
ses
> to its guests.
>
> This improves performance of modern Windows guests.
>
> Say Y, unless you are sure that this kernel will not be used to run Windo=
ws guests."

Thanks) This was an RFC so I was too lazy to write such a paragraph :-)

>
>
>> +
>> +	  If unsure, say "Y".
>> +
>>  config KVM_XEN
>>  	bool "Support for Xen hypercall interface"
>>  	depends on KVM
>> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
>> index 8ea872401cd6..ccd477178f07 100644
>> --- a/arch/x86/kvm/Makefile
>> +++ b/arch/x86/kvm/Makefile
>> @@ -11,7 +11,7 @@ include $(srctree)/virt/kvm/Makefile.kvm
>>=20=20
>>  kvm-y			+=3D x86.o emulate.o i8259.o irq.o lapic.o \
>>  			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
>> -			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
>> +			   debugfs.o mmu/mmu.o mmu/page_track.o \
>>  			   mmu/spte.o
>>=20=20
>>  ifdef CONFIG_HYPERV
>> @@ -19,19 +19,28 @@ kvm-y			+=3D kvm_onhyperv.o
>>  endif
>>=20=20
>>  kvm-$(CONFIG_X86_64) +=3D mmu/tdp_iter.o mmu/tdp_mmu.o
>> +kvm-$(CONFIG_KVM_HYPERV) +=3D hyperv.o
>>  kvm-$(CONFIG_KVM_XEN)	+=3D xen.o
>>  kvm-$(CONFIG_KVM_SMM)	+=3D smm.o
>>=20=20
>>  kvm-intel-y		+=3D vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
>> -			   vmx/hyperv.o vmx/hyperv_evmcs.o vmx/nested.o vmx/posted_intr.o
>> +			   vmx/nested.o vmx/posted_intr.o
>> +ifdef CONFIG_KVM_HYPERV
>> +kvm-intel-y		+=3D vmx/hyperv.o vmx/hyperv_evmcs.o
>> +endif
>> +
>>  kvm-intel-$(CONFIG_X86_SGX_KVM)	+=3D vmx/sgx.o
>>=20=20
>>  ifdef CONFIG_HYPERV
>> -kvm-intel-y		+=3D vmx/vmx_onhyperv.o
>> +kvm-intel-y		+=3D vmx/vmx_onhyperv.o vmx/hyperv_evmcs.o
>>  endif
>>=20=20
>>  kvm-amd-y		+=3D svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic=
.o \
>> -			   svm/sev.o svm/hyperv.o
>> +			   svm/sev.o
>> +
>> +ifdef CONFIG_KVM_HYPERV
>> +kvm-amd-y		+=3D svm/hyperv.o
>> +endif
>
> I think that we can group all the files under one
> 'ifdef CONFIG_KVM_HYPERV'.

We sure can..

>
>>=20=20
>>  ifdef CONFIG_HYPERV
>>  kvm-amd-y		+=3D svm/svm_onhyperv.o
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 0544e30b4946..7a3533573f94 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -314,11 +314,15 @@ EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
>>=20=20
>>  static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int =
nent)
>>  {
>> +#ifdef CONFIG_KVM_HYPERV
>>  	struct kvm_cpuid_entry2 *entry;
>>=20=20
>>  	entry =3D cpuid_entry2_find(entries, nent, HYPERV_CPUID_INTERFACE,
>>  				  KVM_CPUID_INDEX_NOT_SIGNIFICANT);
>>  	return entry && entry->eax =3D=3D HYPERV_CPUID_SIGNATURE_EAX;
>> +#else
>> +	return false;
>> +#endif
>
> Do you think that it might make sense to still complain loudly if the use=
rspace
> still tries to enable hyperv cpuid?

I don't think so. In fact, userspace can now set whatever it wants in
guest visible CPUIDs, e.g. pretend being Vmware/Virtualbox/... and KVM
will just pass it through.  Enabling Hyper-V specific KVM capabilities
must fail, of course.

>
>>  }
>>=20=20
>>  static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>> @@ -441,11 +445,13 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, st=
ruct kvm_cpuid_entry2 *e2,
>>  		return 0;
>>  	}
>>=20=20
>> +#ifdef CONFIG_KVM_HYPERV
>>  	if (kvm_cpuid_has_hyperv(e2, nent)) {
>>  		r =3D kvm_hv_vcpu_init(vcpu);
>>  		if (r)
>>  			return r;
>>  	}
>> +#endif
>>=20=20
>>  	r =3D kvm_check_cpuid(vcpu, e2, nent);
>>  	if (r)
>> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
>> index ddb1d0b019e6..3a6acd8a9fa8 100644
>> --- a/arch/x86/kvm/hyperv.h
>> +++ b/arch/x86/kvm/hyperv.h
>> @@ -24,6 +24,8 @@
>>  #include <linux/kvm_host.h>
>>  #include "x86.h"
>>=20=20
>> +#ifdef CONFIG_KVM_HYPERV
>> +
>>  /* "Hv#1" signature */
>>  #define HYPERV_CPUID_SIGNATURE_EAX 0x31237648
>>=20=20
>> @@ -247,5 +249,28 @@ static inline int kvm_hv_verify_vp_assist(struct kv=
m_vcpu *vcpu)
>>  }
>>=20=20
>>  int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu);
>> -
>> -#endif
>> +#else /* CONFIG_KVM_HYPERV */
>> +static inline void kvm_hv_setup_tsc_page(struct kvm *kvm,
>> +					 struct pvclock_vcpu_time_info *hv_clock) {}
>> +static inline void kvm_hv_request_tsc_page_update(struct kvm *kvm) {}
>> +static inline void kvm_hv_init_vm(struct kvm *kvm) {}
>> +static inline void kvm_hv_destroy_vm(struct kvm *kvm) {}
>> +static inline int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu) { return 0; }
>> +static inline void kvm_hv_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>> +static inline bool kvm_hv_hypercall_enabled(struct kvm_vcpu *vcpu) { re=
turn false; }
>> +static inline int kvm_hv_hypercall(struct kvm_vcpu *vcpu) { return HV_S=
TATUS_ACCESS_DENIED; }
>> +static inline void kvm_hv_vcpu_purge_flush_tlb(struct kvm_vcpu *vcpu) {}
>> +static inline void kvm_hv_free_pa_page(struct kvm *kvm) {}
>> +static inline bool kvm_hv_synic_has_vector(struct kvm_vcpu *vcpu, int v=
ector) { return false; }
>> +static inline bool kvm_hv_synic_auto_eoi_set(struct kvm_vcpu *vcpu, int=
 vector) { return false; }
>> +static inline void kvm_hv_synic_send_eoi(struct kvm_vcpu *vcpu, int vec=
tor) {}
>> +static inline bool kvm_hv_invtsc_suppressed(struct kvm_vcpu *vcpu) { re=
turn false; }
>> +static inline void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu, bool hyperv_=
enabled) {}
>> +static inline bool kvm_hv_has_stimer_pending(struct kvm_vcpu *vcpu) { r=
eturn false; }
>> +static inline bool kvm_hv_is_tlb_flush_hcall(struct kvm_vcpu *vcpu) { r=
eturn false; }
>> +static inline bool guest_hv_cpuid_has_l2_tlb_flush(struct kvm_vcpu *vcp=
u) { return false; }
>> +static inline int kvm_hv_verify_vp_assist(struct kvm_vcpu *vcpu) { retu=
rn 0; }
>> +static inline u32 kvm_hv_get_vpindex(struct kvm_vcpu *vcpu) { return vc=
pu->vcpu_idx; }
>> +#endif /* CONFIG_KVM_HYPERV */
>> +
>> +#endif /* __ARCH_X86_KVM_HYPERV_H__ */
>> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
>> index 16d076a1b91a..68f3f6c26046 100644
>> --- a/arch/x86/kvm/irq_comm.c
>> +++ b/arch/x86/kvm/irq_comm.c
>> @@ -144,7 +144,7 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry =
*e,
>>  	return kvm_irq_delivery_to_apic(kvm, NULL, &irq, NULL);
>>  }
>>=20=20
>> -
>> +#ifdef CONFIG_KVM_HYPERV
>>  static int kvm_hv_set_sint(struct kvm_kernel_irq_routing_entry *e,
>>  		    struct kvm *kvm, int irq_source_id, int level,
>>  		    bool line_status)
>> @@ -154,6 +154,7 @@ static int kvm_hv_set_sint(struct kvm_kernel_irq_rou=
ting_entry *e,
>>=20=20
>>  	return kvm_hv_synic_set_irq(kvm, e->hv_sint.vcpu, e->hv_sint.sint);
>>  }
>> +#endif
>>=20=20
>>  int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
>>  			      struct kvm *kvm, int irq_source_id, int level,
>> @@ -163,9 +164,11 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq=
_routing_entry *e,
>>  	int r;
>>=20=20
>>  	switch (e->type) {
>> +#ifdef CONFIG_KVM_HYPERV
>>  	case KVM_IRQ_ROUTING_HV_SINT:
>>  		return kvm_hv_set_sint(e, kvm, irq_source_id, level,
>>  				       line_status);
>> +#endif
>>=20=20
>>  	case KVM_IRQ_ROUTING_MSI:
>>  		if (kvm_msi_route_invalid(kvm, e))
>> @@ -314,11 +317,13 @@ int kvm_set_routing_entry(struct kvm *kvm,
>>  		if (kvm_msi_route_invalid(kvm, e))
>>  			return -EINVAL;
>>  		break;
>> +#ifdef CONFIG_KVM_HYPERV
>>  	case KVM_IRQ_ROUTING_HV_SINT:
>>  		e->set =3D kvm_hv_set_sint;
>>  		e->hv_sint.vcpu =3D ue->u.hv_sint.vcpu;
>>  		e->hv_sint.sint =3D ue->u.hv_sint.sint;
>>  		break;
>> +#endif
>>  #ifdef CONFIG_KVM_XEN
>>  	case KVM_IRQ_ROUTING_XEN_EVTCHN:
>>  		return kvm_xen_setup_evtchn(kvm, e, ue);
>> @@ -438,5 +443,7 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
>>=20=20
>>  void kvm_arch_irq_routing_update(struct kvm *kvm)
>>  {
>> +#ifdef CONFIG_KVM_HYPERV
>>  	kvm_hv_irq_routing_update(kvm);
>> +#endif
>>  }
>> diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
>> index 02f4784b5d44..14eec2d9b6be 100644
>> --- a/arch/x86/kvm/svm/hyperv.h
>> +++ b/arch/x86/kvm/svm/hyperv.h
>> @@ -11,6 +11,7 @@
>>  #include "../hyperv.h"
>>  #include "svm.h"
>>=20=20
>> +#ifdef CONFIG_KVM_HYPERV
>>  static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
>>  {
>>  	struct vcpu_svm *svm =3D to_svm(vcpu);
>> @@ -41,5 +42,11 @@ static inline bool nested_svm_l2_tlb_flush_enabled(st=
ruct kvm_vcpu *vcpu)
>>  }
>>=20=20
>>  void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcp=
u);
>> +#else /* CONFIG_KVM_HYPERV */
>> +static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu=
) {}
>> +static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcp=
u) { return false; }
>> +static inline void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct=
 kvm_vcpu *vcpu) {}
>> +#endif /* CONFIG_KVM_HYPERV */
>> +
>>=20=20
>>  #endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index dd496c9e5f91..4d8cd378a30b 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -487,6 +487,7 @@ static void nested_save_pending_event_to_vmcb12(stru=
ct vcpu_svm *svm,
>>=20=20
>>  static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
>>  {
>> +#ifdef CONFIG_KVM_HYPERV
>>  	/*
>>  	 * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VP_ID or
>>  	 * L2's VP_ID upon request from the guest. Make sure we check for
>> @@ -495,6 +496,7 @@ static void nested_svm_transition_tlb_flush(struct k=
vm_vcpu *vcpu)
>>  	 */
>>  	if (to_hv_vcpu(vcpu) && npt_enabled)
>>  		kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
>> +#endif
>>=20=20
>>  	/*
>>  	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
>> diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhy=
perv.h
>> index f85bc617ffe4..c25cf56e6adb 100644
>> --- a/arch/x86/kvm/svm/svm_onhyperv.h
>> +++ b/arch/x86/kvm/svm/svm_onhyperv.h
>> @@ -79,6 +79,7 @@ static inline void svm_hv_vmcb_dirty_nested_enlightenm=
ents(
>>=20=20
>>  static inline void svm_hv_update_vp_id(struct vmcb *vmcb, struct kvm_vc=
pu *vcpu)
>>  {
>> +#ifdef CONFIG_KVM_HYPERV
>>  	struct hv_vmcb_enlightenments *hve =3D &vmcb->control.hv_enlightenment=
s;
>>  	u32 vp_index =3D kvm_hv_get_vpindex(vcpu);
>>=20=20
>> @@ -86,6 +87,7 @@ static inline void svm_hv_update_vp_id(struct vmcb *vm=
cb, struct kvm_vcpu *vcpu)
>>  		hve->hv_vp_id =3D vp_index;
>>  		vmcb_mark_dirty(vmcb, HV_VMCB_NESTED_ENLIGHTENMENTS);
>>  	}
>> +#endif
>>  }
>>  #else
>>=20=20
>> diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
>> index d4ed99008518..933ef6cad5e6 100644
>> --- a/arch/x86/kvm/vmx/hyperv.h
>> +++ b/arch/x86/kvm/vmx/hyperv.h
>> @@ -20,6 +20,7 @@ enum nested_evmptrld_status {
>>  	EVMPTRLD_ERROR,
>>  };
>>=20=20
>> +#ifdef CONFIG_KVM_HYPERV
>>  u64 nested_get_evmptr(struct kvm_vcpu *vcpu);
>>  uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
>>  int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>> @@ -28,5 +29,12 @@ void nested_evmcs_filter_control_msr(struct kvm_vcpu =
*vcpu, u32 msr_index, u64 *
>>  int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
>>  bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu);
>>  void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcp=
u);
>> +#else
>> +static inline u64 nested_get_evmptr(struct kvm_vcpu *vcpu) { return EVM=
PTR_INVALID; }
>> +static inline void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcp=
u, u32 msr_index, u64 *pdata) {}
>> +static inline bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *v=
cpu) { return false; }
>> +static inline int nested_evmcs_check_controls(struct vmcs12 *vmcs12) { =
return 0; }
>> +#endif
>> +
>>=20=20
>>  #endif /* __KVM_X86_VMX_HYPERV_H */
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index c5ec0ef51ff7..ca7e06759aa3 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -226,6 +226,7 @@ static void vmx_disable_shadow_vmcs(struct vcpu_vmx =
*vmx)
>>=20=20
>>  static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
>>  {
>> +#ifdef CONFIG_KVM_HYPERV
>>  	struct kvm_vcpu_hv *hv_vcpu =3D to_hv_vcpu(vcpu);
>>  	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>>=20=20
>> @@ -241,6 +242,7 @@ static inline void nested_release_evmcs(struct kvm_v=
cpu *vcpu)
>>  		hv_vcpu->nested.vm_id =3D 0;
>>  		hv_vcpu->nested.vp_id =3D 0;
>>  	}
>> +#endif
>>  }
>>=20=20
>>  static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
>> @@ -1139,6 +1141,7 @@ static void nested_vmx_transition_tlb_flush(struct=
 kvm_vcpu *vcpu,
>>  {
>>  	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>>=20=20
>> +#ifdef CONFIG_KVM_HYPERV
>>  	/*
>>  	 * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VP_ID or
>>  	 * L2's VP_ID upon request from the guest. Make sure we check for
>> @@ -1147,6 +1150,7 @@ static void nested_vmx_transition_tlb_flush(struct=
 kvm_vcpu *vcpu,
>>  	 */
>>  	if (to_hv_vcpu(vcpu) && enable_ept)
>>  		kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
>> +#endif
>>=20=20
>>  	/*
>>  	 * If vmcs12 doesn't use VPID, L1 expects linear and combined mappings
>> @@ -1576,6 +1580,7 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx =
*vmx)
>>  	vmcs_load(vmx->loaded_vmcs->vmcs);
>>  }
>>=20=20
>> +#ifdef CONFIG_KVM_HYPERV
>>  static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_cle=
an_fields)
>>  {
>>  	struct vmcs12 *vmcs12 =3D vmx->nested.cached_vmcs12;
>> @@ -2083,6 +2088,10 @@ static enum nested_evmptrld_status nested_vmx_han=
dle_enlightened_vmptrld(
>>=20=20
>>  	return EVMPTRLD_SUCCEEDED;
>>  }
>> +#else /* CONFIG_KVM_HYPERV */
>> +static inline void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32=
 hv_clean_fields) {}
>> +static inline void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx) {}
>> +#endif /* CONFIG_KVM_HYPERV */
>>=20=20
>>  void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu)
>>  {
>> @@ -3161,6 +3170,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_=
vcpu *vcpu)
>>  	return 0;
>>  }
>>=20=20
>> +#ifdef CONFIG_KVM_HYPERV
>>  static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
>>  {
>>  	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
>> @@ -3188,6 +3198,9 @@ static bool nested_get_evmcs_page(struct kvm_vcpu =
*vcpu)
>>=20=20
>>  	return true;
>>  }
>> +#else
>> +static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu) { return true;=
 }
>> +#endif
>>=20=20
>>  static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>>  {
>> @@ -3558,11 +3571,13 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu,=
 bool launch)
>>  	if (!nested_vmx_check_permission(vcpu))
>>  		return 1;
>>=20=20
>> +#ifdef CONFIG_KVM_HYPERV
>>  	evmptrld_status =3D nested_vmx_handle_enlightened_vmptrld(vcpu, launch=
);
>>  	if (evmptrld_status =3D=3D EVMPTRLD_ERROR) {
>>  		kvm_queue_exception(vcpu, UD_VECTOR);
>>  		return 1;
>>  	}
>> +#endif
>>=20=20
>>  	kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
>>=20=20
>> @@ -7096,7 +7111,9 @@ struct kvm_x86_nested_ops vmx_nested_ops =3D {
>>  	.set_state =3D vmx_set_nested_state,
>>  	.get_nested_state_pages =3D vmx_get_nested_state_pages,
>>  	.write_log_dirty =3D nested_vmx_write_pml_buffer,
>> +#ifdef CONFIG_KVM_HYPERV
>>  	.enable_evmcs =3D nested_enable_evmcs,
>>  	.get_evmcs_version =3D nested_get_evmcs_version,
>>  	.hv_inject_synthetic_vmexit_post_tlb_flush =3D vmx_hv_inject_synthetic=
_vmexit_post_tlb_flush,
>> +#endif
>>  };
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index e273ce8e0b3f..78e18d28bc61 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1504,6 +1504,8 @@ static unsigned num_msrs_to_save;
>>  static const u32 emulated_msrs_all[] =3D {
>>  	MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
>>  	MSR_KVM_SYSTEM_TIME_NEW, MSR_KVM_WALL_CLOCK_NEW,
>> +
>> +#ifdef CONFIG_KVM_HYPERV
>>  	HV_X64_MSR_GUEST_OS_ID, HV_X64_MSR_HYPERCALL,
>>  	HV_X64_MSR_TIME_REF_COUNT, HV_X64_MSR_REFERENCE_TSC,
>>  	HV_X64_MSR_TSC_FREQUENCY, HV_X64_MSR_APIC_FREQUENCY,
>> @@ -1521,6 +1523,7 @@ static const u32 emulated_msrs_all[] =3D {
>>  	HV_X64_MSR_SYNDBG_CONTROL, HV_X64_MSR_SYNDBG_STATUS,
>>  	HV_X64_MSR_SYNDBG_SEND_BUFFER, HV_X64_MSR_SYNDBG_RECV_BUFFER,
>>  	HV_X64_MSR_SYNDBG_PENDING_BUFFER,
>> +#endif
>>=20=20
>>  	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
>>  	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF_INT, MSR_KVM_ASYNC_PF_ACK,
>> @@ -3914,6 +3917,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, stru=
ct msr_data *msr_info)
>>  		 * the need to ignore the workaround.
>>  		 */
>>  		break;
>> +#ifdef CONFIG_KVM_HYPERV
>>  	case HV_X64_MSR_GUEST_OS_ID ... HV_X64_MSR_SINT15:
>>  	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>>  	case HV_X64_MSR_SYNDBG_OPTIONS:
>> @@ -3926,6 +3930,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, stru=
ct msr_data *msr_info)
>>  	case HV_X64_MSR_TSC_INVARIANT_CONTROL:
>>  		return kvm_hv_set_msr_common(vcpu, msr, data,
>>  					     msr_info->host_initiated);
>> +#endif
>>  	case MSR_IA32_BBL_CR_CTL3:
>>  		/* Drop writes to this legacy MSR -- see rdmsr
>>  		 * counterpart for further detail.
>> @@ -4270,6 +4275,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, stru=
ct msr_data *msr_info)
>>  		 */
>>  		msr_info->data =3D 0x20000000;
>>  		break;
>> +#ifdef CONFIG_KVM_HYPERV
>>  	case HV_X64_MSR_GUEST_OS_ID ... HV_X64_MSR_SINT15:
>>  	case HV_X64_MSR_SYNDBG_CONTROL ... HV_X64_MSR_SYNDBG_PENDING_BUFFER:
>>  	case HV_X64_MSR_SYNDBG_OPTIONS:
>> @@ -4283,6 +4289,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, stru=
ct msr_data *msr_info)
>>  		return kvm_hv_get_msr_common(vcpu,
>>  					     msr_info->index, &msr_info->data,
>>  					     msr_info->host_initiated);
>> +#endif
>>  	case MSR_IA32_BBL_CR_CTL3:
>>  		/* This legacy MSR exists but isn't fully documented in current
>>  		 * silicon.  It is however accessed by winxp in very narrow
>> @@ -4420,6 +4427,7 @@ static inline bool kvm_can_mwait_in_guest(void)
>>  		boot_cpu_has(X86_FEATURE_ARAT);
>>  }
>>=20=20
>> +#ifdef CONFIG_KVM_HYPERV
>>  static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
>>  					    struct kvm_cpuid2 __user *cpuid_arg)
>>  {
>> @@ -4440,6 +4448,7 @@ static int kvm_ioctl_get_supported_hv_cpuid(struct=
 kvm_vcpu *vcpu,
>>=20=20
>>  	return 0;
>>  }
>> +#endif
>>=20=20
>>  int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>  {
>> @@ -4764,9 +4773,11 @@ long kvm_arch_dev_ioctl(struct file *filp,
>>  	case KVM_GET_MSRS:
>>  		r =3D msr_io(NULL, argp, do_get_msr_feature, 1);
>>  		break;
>> +#ifdef CONFIG_KVM_HYPERV
>>  	case KVM_GET_SUPPORTED_HV_CPUID:
>>  		r =3D kvm_ioctl_get_supported_hv_cpuid(NULL, argp);
>>  		break;
>> +#endif
>>  	case KVM_GET_DEVICE_ATTR: {
>>  		struct kvm_device_attr attr;
>>  		r =3D -EFAULT;
>> @@ -5580,14 +5591,11 @@ static int kvm_vcpu_ioctl_device_attr(struct kvm=
_vcpu *vcpu,
>>  static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>>  				     struct kvm_enable_cap *cap)
>>  {
>> -	int r;
>> -	uint16_t vmcs_version;
>> -	void __user *user_ptr;
>> -
>>  	if (cap->flags)
>>  		return -EINVAL;
>>=20=20
>>  	switch (cap->cap) {
>> +#ifdef CONFIG_KVM_HYPERV
>>  	case KVM_CAP_HYPERV_SYNIC2:
>>  		if (cap->args[0])
>>  			return -EINVAL;
>> @@ -5599,16 +5607,22 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_=
vcpu *vcpu,
>>  		return kvm_hv_activate_synic(vcpu, cap->cap =3D=3D
>>  					     KVM_CAP_HYPERV_SYNIC2);
>>  	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
>> -		if (!kvm_x86_ops.nested_ops->enable_evmcs)
>> -			return -ENOTTY;
>> -		r =3D kvm_x86_ops.nested_ops->enable_evmcs(vcpu, &vmcs_version);
>> -		if (!r) {
>> -			user_ptr =3D (void __user *)(uintptr_t)cap->args[0];
>> -			if (copy_to_user(user_ptr, &vmcs_version,
>> -					 sizeof(vmcs_version)))
>> -				r =3D -EFAULT;
>> +		{
>> +			int r;
>> +			uint16_t vmcs_version;
>> +			void __user *user_ptr;CONFIG_KVM_HYPERV_GUEST_SUPPORT
>> +
>> +			if (!kvm_x86_ops.nested_ops->enable_evmcs)
>> +				return -ENOTTY;
>> +			r =3D kvm_x86_ops.nested_ops->enable_evmcs(vcpu, &vmcs_version);
>> +			if (!r) {
>> +				user_ptr =3D (void __user *)(uintptr_t)cap->args[0];
>> +				if (copy_to_user(user_ptr, &vmcs_version,
>> +						 sizeof(vmcs_version)))
>> +					r =3D -EFAULT;
>> +			}
>> +			return r;
>>  		}
>> -		return r;
>>  	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
>>  		if (!kvm_x86_ops.enable_l2_tlb_flush)
>>  			return -ENOTTY;
>> @@ -5617,6 +5631,7 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vc=
pu *vcpu,
>>=20=20
>>  	case KVM_CAP_HYPERV_ENFORCE_CPUID:
>>  		return kvm_hv_set_enforce_cpuid(vcpu, cap->args[0]);
>> +#endif
>>=20=20
>>  	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
>>  		vcpu->arch.pv_cpuid.enforce =3D cap->args[0];
>> @@ -6009,9 +6024,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>  		srcu_read_unlock(&vcpu->kvm->srcu, idx);
>>  		break;
>>  	}
>> +#ifdef CONFIG_KVM_HYPERV
>>  	case KVM_GET_SUPPORTED_HV_CPUID:
>>  		r =3D kvm_ioctl_get_supported_hv_cpuid(vcpu, argp);
>>  		break;
>> +#endif
>>  #ifdef CONFIG_KVM_XEN
>>  	case KVM_XEN_VCPU_GET_ATTR: {
>>  		struct kvm_xen_vcpu_attr xva;
>> @@ -7066,6 +7083,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned =
int ioctl, unsigned long arg)
>>  		r =3D static_call(kvm_x86_mem_enc_unregister_region)(kvm, &region);
>>  		break;
>>  	}
>> +#ifdef CONFIG_KVM_HYPERV
>>  	case KVM_HYPERV_EVENTFD: {
>>  		struct kvm_hyperv_eventfd hvevfd;
>>=20=20
>> @@ -7075,6 +7093,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned =
int ioctl, unsigned long arg)
>>  		r =3D kvm_vm_ioctl_hv_eventfd(kvm, &hvevfd);
>>  		break;
>>  	}
>> +#endif
>>  	case KVM_SET_PMU_EVENT_FILTER:
>>  		r =3D kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
>>  		break;
>> @@ -10445,19 +10464,20 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *=
vcpu)
>>=20=20
>>  static void vcpu_load_eoi_exitmap(struct kvm_vcpu *vcpu)
>>  {
>> -	u64 eoi_exit_bitmap[4];
>> -
>>  	if (!kvm_apic_hw_enabled(vcpu->arch.apic))
>>  		return;
>>=20=20
>> +#ifdef CONFIG_KVM_HYPERV
>>  	if (to_hv_vcpu(vcpu)) {
>> +		u64 eoi_exit_bitmap[4];
>> +
>>  		bitmap_or((ulong *)eoi_exit_bitmap,
>>  			  vcpu->arch.ioapic_handled_vectors,
>>  			  to_hv_synic(vcpu)->vec_bitmap, 256);
>>  		static_call_cond(kvm_x86_load_eoi_exitmap)(vcpu, eoi_exit_bitmap);
>>  		return;
>>  	}
>> -
>> +#endif
>>  	static_call_cond(kvm_x86_load_eoi_exitmap)(
>>  		vcpu, (u64 *)vcpu->arch.ioapic_handled_vectors);
>>  }
>> @@ -10548,9 +10568,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vc=
pu)
>>  		 * the flushes are considered "remote" and not "local" because
>>  		 * the requests can be initiated from other vCPUs.
>>  		 */
>> +#ifdef CONFIG_KVM_HYPERV
>>  		if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu) &&
>>  		    kvm_hv_vcpu_flush_tlb(vcpu))
>>  			kvm_vcpu_flush_tlb_guest(vcpu);
>> +#endif
>>=20=20
>>  		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
>>  			vcpu->run->exit_reason =3D KVM_EXIT_TPR_ACCESS;
>> @@ -10603,6 +10625,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcp=
u)
>>  			vcpu_load_eoi_exitmap(vcpu);
>>  		if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
>>  			kvm_vcpu_reload_apic_access_page(vcpu);
>> +#ifdef CONFIG_KVM_HYPERV
>>  		if (kvm_check_request(KVM_REQ_HV_CRASH, vcpu)) {
>>  			vcpu->run->exit_reason =3D KVM_EXIT_SYSTEM_EVENT;
>>  			vcpu->run->system_event.type =3D KVM_SYSTEM_EVENT_CRASH;
>> @@ -10633,6 +10656,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcp=
u)
>>  		 */
>>  		if (kvm_check_request(KVM_REQ_HV_STIMER, vcpu))
>>  			kvm_hv_process_stimers(vcpu);
>> +#endif
>>  		if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
>>  			kvm_vcpu_update_apicv(vcpu);
>>  		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
>
>
> Looks reasonable, I didn't check everything though, I might have missed s=
omething.
>
>
> Best regards,
> 	Maxim Levitsky
>

--=20
Vitaly

