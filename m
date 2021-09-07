Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F70402E70
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 20:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345882AbhIGSgL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 14:36:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33475 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230354AbhIGSgK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Sep 2021 14:36:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631039703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=39gFd33ByEeHabxlUVexH9bqw8RdJNvKyWEswyYIiZE=;
        b=jIfeNQfp6pVyDWAgjLJE9NaeJ2woFrHdXpRGR7Jfm61uzGdLMnkeGMsYtO3nVxMls2tm4b
        gB4L1kFboxlZh4PetI3u4VfXsWDgUruvgeHsZx9+WAyeb1iCSffxVRhzPiTkY60zazlVA0
        xsYAKIX8sRyC06PjjdT3JrpsoVJQRfA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-myDqf5mQPpy7Ly5xvOfCjg-1; Tue, 07 Sep 2021 14:35:02 -0400
X-MC-Unique: myDqf5mQPpy7Ly5xvOfCjg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AD9F107ACCD;
        Tue,  7 Sep 2021 18:35:00 +0000 (UTC)
Received: from localhost (unknown [10.22.8.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5BA836A255;
        Tue,  7 Sep 2021 18:34:58 +0000 (UTC)
Date:   Tue, 7 Sep 2021 14:34:57 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 3/6] x86/kvm: introduce per cpu vcpu masks
Message-ID: <20210907183457.53ws6tqqqpzkeil4@habkost.net>
References: <20210903130808.30142-1-jgross@suse.com>
 <20210903130808.30142-4-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210903130808.30142-4-jgross@suse.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021 at 03:08:04PM +0200, Juergen Gross wrote:
> In order to support high vcpu numbers per guest don't use on stack
> vcpu bitmasks. As all those currently used bitmasks are not used in
> functions subject to recursion it is fairly easy to replace them with
> percpu bitmasks.
> 
> Disable preemption while such a bitmask is being used in order to
> avoid double usage in case we'd switch cpus.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
> V2:
> - use local_lock() instead of preempt_disable() (Paolo Bonzini)
> ---
>  arch/x86/include/asm/kvm_host.h | 10 ++++++++++
>  arch/x86/kvm/hyperv.c           | 25 ++++++++++++++++++-------
>  arch/x86/kvm/irq_comm.c         |  9 +++++++--
>  arch/x86/kvm/x86.c              | 22 +++++++++++++++++++++-
>  4 files changed, 56 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3513edee8e22..a809a9e4fa5c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -15,6 +15,7 @@
>  #include <linux/cpumask.h>
>  #include <linux/irq_work.h>
>  #include <linux/irq.h>
> +#include <linux/local_lock.h>
>  
>  #include <linux/kvm.h>
>  #include <linux/kvm_para.h>
> @@ -1591,6 +1592,15 @@ extern bool kvm_has_bus_lock_exit;
>  /* maximum vcpu-id */
>  unsigned int kvm_max_vcpu_id(void);
>  
> +/* per cpu vcpu bitmasks, protected by kvm_pcpu_mask_lock */
> +DECLARE_PER_CPU(local_lock_t, kvm_pcpu_mask_lock);
> +extern unsigned long __percpu *kvm_pcpu_vcpu_mask;
> +#define KVM_VCPU_MASK_SZ	\
> +	(sizeof(*kvm_pcpu_vcpu_mask) * BITS_TO_LONGS(KVM_MAX_VCPUS))
> +extern u64 __percpu *kvm_hv_vp_bitmap;
> +#define KVM_HV_MAX_SPARSE_VCPU_SET_BITS DIV_ROUND_UP(KVM_MAX_VCPUS, 64)
> +#define KVM_HV_VPMAP_SZ		(sizeof(u64) * KVM_HV_MAX_SPARSE_VCPU_SET_BITS)

I have just realized that the Hyper-V sparse bitmap format can
support only up to 4096 CPUs, and the current implementation of
sparse_set_to_vcpu_mask() won't even work correctly if
KVM_MAX_VCPUS is larger than 4096.

This means vp_bitmap can't and will never be larger than 512
bytes.  Isn't a per-CPU variable for vp_bitmap overkill in this
case?

> [...]

-- 
Eduardo

