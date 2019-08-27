Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1079DE7F
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 09:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbfH0HPY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 03:15:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39836 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbfH0HPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 03:15:23 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 59EC5126E
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 07:15:22 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id 19so685773wmk.0
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 00:15:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ItBFnvOskiXPWW/tXExRRVa7JatdCAplFcozPV+0gNM=;
        b=adGw1n5J1inyo6KkICxFZhHDER15YDRT6Oo8H9HGees8bDnpkMjV3g0/gX/uVByrEa
         jSEId5/Zrn3I/09O+Z6LWEexyXS0Q9qoWr3RVLHMD3vunWXaN8ykkLY5rHPwFfFnLruU
         qwZfOm/Sth+5o2Qh1p0wqWM6k2yX4z9v9AUx9GFchw6uXhB/r5vXIuxHZtGuGNQRyh9D
         JG+KtImL+KPn51Lc10L8YTc7PQXlnsvgQlFUjho+Xf5np5CrJk2hJWWAXHfA8rsjpoIv
         FJBXYKx74yj2bu5xCtuI3zo3Z6QviZ4G4ongY+YD4fgBLq/6jCHyJZOXjTLSUBScu7MW
         7I4g==
X-Gm-Message-State: APjAAAXkfmaiar4XTlAN0Aml56VISpc5uYpWFoIpwm2Okdiw6PCBSQiQ
        sNcDgkea4Iuh8XuBTOcWOHfYY+Fg3QNzdMHLs2XdeKequAV14kiTtvWwBdNUJmzuvSEW1dvwN0U
        zoPnvGS7h2o8G
X-Received: by 2002:a1c:200a:: with SMTP id g10mr24606052wmg.160.1566890120713;
        Tue, 27 Aug 2019 00:15:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyawJTYbThIhs4NIo/tFME/qKqKlPHsP0+de4dcTQWRABs/Kb5yLEx6SvcczfmV6yic/7VhIg==
X-Received: by 2002:a1c:200a:: with SMTP id g10mr24606018wmg.160.1566890120434;
        Tue, 27 Aug 2019 00:15:20 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-89-176-161-20.net.upcbroadband.cz. [89.176.161.20])
        by smtp.gmail.com with ESMTPSA id a203sm1958111wme.11.2019.08.27.00.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 00:15:19 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Suthikulpanit\, Suravee" <Suravee.Suthikulpanit@amd.com>
Cc:     "pbonzini\@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar\@redhat.com" <rkrcmar@redhat.com>,
        "joro\@8bytes.org" <joro@8bytes.org>,
        "graf\@amazon.com" <graf@amazon.com>,
        "jschoenh\@amazon.de" <jschoenh@amazon.de>,
        "karahmed\@amazon.de" <karahmed@amazon.de>,
        "rimasluk\@amazon.com" <rimasluk@amazon.com>,
        "Grimm\, Jon" <Jon.Grimm@amd.com>,
        "Suthikulpanit\, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 01/15] kvm: x86: Modify kvm_x86_ops.get_enable_apicv() to use struct kvm parameter
In-Reply-To: <1565886293-115836-2-git-send-email-suravee.suthikulpanit@amd.com>
References: <1565886293-115836-1-git-send-email-suravee.suthikulpanit@amd.com> <1565886293-115836-2-git-send-email-suravee.suthikulpanit@amd.com>
Date:   Tue, 27 Aug 2019 09:15:18 +0200
Message-ID: <87d0grm649.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com> writes:

> Generally, APICv for all vcpus in the VM are enable/disable in the same
> manner. So, get_enable_apicv() should represent APICv status of the VM
> instead of each VCPU.
>
> Modify kvm_x86_ops.get_enable_apicv() to take struct kvm as parameter
> instead of struct kvm_vcpu.
>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  arch/x86/kvm/svm.c              | 5 +++--
>  arch/x86/kvm/vmx/vmx.c          | 2 +-
>  arch/x86/kvm/x86.c              | 2 +-
>  4 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 26d1eb8..56bc702 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1077,7 +1077,7 @@ struct kvm_x86_ops {
>  	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
>  	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
>  	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
> -	bool (*get_enable_apicv)(struct kvm_vcpu *vcpu);
> +	bool (*get_enable_apicv)(struct kvm *kvm);
>  	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
>  	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
>  	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index ccd5aa6..6851bce 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -384,6 +384,7 @@ struct amd_svm_iommu_ir {
>  static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
>  static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa);
>  static void svm_complete_interrupts(struct vcpu_svm *svm);
> +static bool svm_get_enable_apicv(struct kvm *kvm);

Why is this forward declaration needed [in this patch]?

>  
>  static int nested_svm_exit_handled(struct vcpu_svm *svm);
>  static int nested_svm_intercept(struct vcpu_svm *svm);
> @@ -5124,9 +5125,9 @@ static void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>  	return;
>  }
>  
> -static bool svm_get_enable_apicv(struct kvm_vcpu *vcpu)
> +static bool svm_get_enable_apicv(struct kvm *kvm)
>  {
> -	return avic && irqchip_split(vcpu->kvm);
> +	return avic && irqchip_split(kvm);
>  }
>  
>  static void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d98eac3..18a4b94 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3610,7 +3610,7 @@ void pt_update_intercept_for_msr(struct vcpu_vmx *vmx)
>  	}
>  }
>  
> -static bool vmx_get_enable_apicv(struct kvm_vcpu *vcpu)
> +static bool vmx_get_enable_apicv(struct kvm *kvm)
>  {
>  	return enable_apicv;
>  }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fafd81d..7daf0dd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9150,7 +9150,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  		goto fail_free_pio_data;
>  
>  	if (irqchip_in_kernel(vcpu->kvm)) {
> -		vcpu->arch.apicv_active = kvm_x86_ops->get_enable_apicv(vcpu);
> +		vcpu->arch.apicv_active = kvm_x86_ops->get_enable_apicv(vcpu->kvm);
>  		r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
>  		if (r < 0)
>  			goto fail_mmu_destroy;

With the above question answered (or declaration moved to the patch
where it's actually needed)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly
