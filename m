Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62E8391431
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 11:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233720AbhEZJ6w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 05:58:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233633AbhEZJ6v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 05:58:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622023040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=unCurEyf03WeyFENhvIK3vbQ4htz+pnh3XxNexbl9u0=;
        b=Y0aZE1qVPFG3gcOA65xsuDC8XJAqtu7nu4C/raZH8Hmq35bvyByEGnvSmC69fx+EeZjPVT
        +5Uq8y8Eqnq/WcEr63R3vCJLxSwKzI+Jm0du89jdK6Gs27pLICxQ5soAXAtdt4uptYKPxH
        IqQDt/RjSMjVdznrzTQJlRBlwdKQQMw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-4dcgwtsCOO-omgphrP6d3Q-1; Wed, 26 May 2021 05:57:18 -0400
X-MC-Unique: 4dcgwtsCOO-omgphrP6d3Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADD6C802B78;
        Wed, 26 May 2021 09:57:16 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5329460CC6;
        Wed, 26 May 2021 09:57:14 +0000 (UTC)
Message-ID: <69697643ea2b5756fac99e7d87ef09c32c76f930.camel@redhat.com>
Subject: Re: [PATCH v2 4/5] KVM: x86: Invert APICv/AVIC enablement check
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
Date:   Wed, 26 May 2021 12:57:13 +0300
In-Reply-To: <20210518144339.1987982-5-vkuznets@redhat.com>
References: <20210518144339.1987982-1-vkuznets@redhat.com>
         <20210518144339.1987982-5-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-18 at 16:43 +0200, Vitaly Kuznetsov wrote:
> Now that APICv/AVIC enablement is kept in common 'enable_apicv' variable,
> there's no need to call kvm_apicv_init() from vendor specific code.
> 
> No functional change intended.

Minor nitpick: I don't see any invert here, but rather
a unification of SVM/VMX virtual apic enablement code.
Maybe update the subject a bit?

For the code:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 -
>  arch/x86/kvm/svm/svm.c          | 1 -
>  arch/x86/kvm/vmx/vmx.c          | 1 -
>  arch/x86/kvm/x86.c              | 6 +++---
>  4 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a2197fcf0e7c..bf5807d35339 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1662,7 +1662,6 @@ gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
>  				struct x86_exception *exception);
>  
>  bool kvm_apicv_activated(struct kvm *kvm);
> -void kvm_apicv_init(struct kvm *kvm, bool enable);
>  void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
>  void kvm_request_apicv_update(struct kvm *kvm, bool activate,
>  			      unsigned long bit);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 0d6ec34d1e4b..84f58e8b2f49 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4438,7 +4438,6 @@ static int svm_vm_init(struct kvm *kvm)
>  			return ret;
>  	}
>  
> -	kvm_apicv_init(kvm, enable_apicv);
>  	return 0;
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5e9ba10e9c2d..697dd54c7df8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7000,7 +7000,6 @@ static int vmx_vm_init(struct kvm *kvm)
>  			break;
>  		}
>  	}
> -	kvm_apicv_init(kvm, enable_apicv);
>  	return 0;
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 23fdbba6b394..22a1e2b438c3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8345,16 +8345,15 @@ bool kvm_apicv_activated(struct kvm *kvm)
>  }
>  EXPORT_SYMBOL_GPL(kvm_apicv_activated);
>  
> -void kvm_apicv_init(struct kvm *kvm, bool enable)
> +static void kvm_apicv_init(struct kvm *kvm)
>  {
> -	if (enable)
> +	if (enable_apicv)
>  		clear_bit(APICV_INHIBIT_REASON_DISABLE,
>  			  &kvm->arch.apicv_inhibit_reasons);
>  	else
>  		set_bit(APICV_INHIBIT_REASON_DISABLE,
>  			&kvm->arch.apicv_inhibit_reasons);
>  }
> -EXPORT_SYMBOL_GPL(kvm_apicv_init);
>  
>  static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
>  {
> @@ -10739,6 +10738,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
>  	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
>  
> +	kvm_apicv_init(kvm);
>  	kvm_hv_init_vm(kvm);
>  	kvm_page_track_init(kvm);
>  	kvm_mmu_init_vm(kvm);


