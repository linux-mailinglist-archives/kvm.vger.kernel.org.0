Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475F44672E4
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 08:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378979AbhLCHt7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 02:49:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44245 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351054AbhLCHt6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 02:49:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638517594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C857ynlLvgo/jXt0qPiJ3y2KIqa88RzxMT/SlvNUgfw=;
        b=DcSVhGnK41cQ/CYBWjfE4yU9YTYXCBikRzRwbKSyovjESMbDzcxN30M8huRaeCXrQMlruo
        Q9kITQJ8JTTu9TZ/vgrz+ECr77iRJxztzRCeE++POYzqB7eihJJiTNjwJUvKOaT13A2zK3
        NLZCk40gsxZFNzpntJNBIHB//IhgOgc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-Cbbq90tDOwKVKP9euiAD6g-1; Fri, 03 Dec 2021 02:46:31 -0500
X-MC-Unique: Cbbq90tDOwKVKP9euiAD6g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 752A3100D680;
        Fri,  3 Dec 2021 07:46:29 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E10945D64;
        Fri,  3 Dec 2021 07:46:16 +0000 (UTC)
Message-ID: <7dd1e7d1510f17f1140b7174dd42fed752eefc38.camel@redhat.com>
Subject: Re: [PATCH v2 3/3] KVM: SVM: Extend host physical APIC ID field to
 support more than 8-bit
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org, seanjc@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, thomas.lendacky@amd.com,
        jon.grimm@amd.com
Date:   Fri, 03 Dec 2021 09:46:15 +0200
In-Reply-To: <20211202235825.12562-4-suravee.suthikulpanit@amd.com>
References: <20211202235825.12562-1-suravee.suthikulpanit@amd.com>
         <20211202235825.12562-4-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-12-02 at 17:58 -0600, Suravee Suthikulpanit wrote:
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
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 28 ++++++++++++++++++++--------
>  arch/x86/kvm/svm/svm.h  |  1 -
>  2 files changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 6aca1682f4b7..2a0f58e6edf5 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -19,6 +19,7 @@
>  #include <linux/amd-iommu.h>
>  #include <linux/kvm_host.h>
>  
> +#include <asm/apic.h>
>  #include <asm/irq_remapping.h>
>  
>  #include "trace.h"
> @@ -63,6 +64,7 @@
>  static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
>  static u32 next_vm_id = 0;
>  static bool next_vm_id_wrapped = 0;
> +static u64 avic_host_physical_id_mask;
>  static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
>  
>  /*
> @@ -133,6 +135,20 @@ void avic_vm_destroy(struct kvm *kvm)
>  	spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
>  }
>  
> +static void avic_init_host_physical_apicid_mask(void)
> +{
> +	if (!x2apic_mode) {
Wonder why this is a exported  global variable and not function.
Not the patch fault though.
> +		/* If host is in xAPIC mode, default to only 8-bit mask. */
> +		avic_host_physical_id_mask = 0xffULL;
> +	} else {
> +		u32 count = get_count_order(apic_get_max_phys_apicid());
> +
> +		avic_host_physical_id_mask = BIT(count) - 1;
I think that there were some complains about using this macro and instead encouraged
to use 1 << x directly, but I see it used already in other places in avic.c so I don't know.


> +	}
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
> @@ -1018,6 +1029,7 @@ bool avic_hardware_setup(bool avic, bool npt)
>  		return false;
>  
>  	pr_info("AVIC enabled\n");
> +	avic_init_host_physical_apicid_mask();
>  	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
>  	return true;
>  }
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 1d2d72e56dd1..b4cb71c538b3 100644
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


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

