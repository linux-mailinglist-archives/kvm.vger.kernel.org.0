Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F654672B2
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 08:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378925AbhLCHnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 02:43:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350852AbhLCHnQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 02:43:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638517192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GGCgUfjn6OQpQU13zAQTWzs7Dy28ymhp2sUo8niZZ6o=;
        b=X9MzZuPhX+3v8PLaYSmZFMR0sB6xdE4sa10dZlPqxbNNesp+80W+oJ97NYbJeHUrqXfaqC
        VlJCM3IWr4PtP/Mtat/hk1PP7KUp58Cnr5LuHnwAb3F2Q3p09Eoo0qESFxQgX6TEsrhNn5
        puCtGYi8p3TATHx1/ivNIZBdsZL/Nz8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-64-3uS5TebrOO6TTghhs9fQ8g-1; Fri, 03 Dec 2021 02:39:49 -0500
X-MC-Unique: 3uS5TebrOO6TTghhs9fQ8g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F79A190D340;
        Fri,  3 Dec 2021 07:39:47 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 234005D9D5;
        Fri,  3 Dec 2021 07:39:41 +0000 (UTC)
Message-ID: <6a97d0ab100e596c3f4c26c64aaf945018d82a5e.camel@redhat.com>
Subject: Re: [PATCH v2 1/3] KVM: SVM: Refactor AVIC hardware setup logic
 into helper function
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org, seanjc@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, thomas.lendacky@amd.com,
        jon.grimm@amd.com
Date:   Fri, 03 Dec 2021 09:39:40 +0200
In-Reply-To: <20211202235825.12562-2-suravee.suthikulpanit@amd.com>
References: <20211202235825.12562-1-suravee.suthikulpanit@amd.com>
         <20211202235825.12562-2-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-12-02 at 17:58 -0600, Suravee Suthikulpanit wrote:
> To prepare for upcoming AVIC changes. There is no functional change.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 10 ++++++++++
>  arch/x86/kvm/svm/svm.c  |  8 +-------
>  arch/x86/kvm/svm/svm.h  |  1 +
>  3 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 8052d92069e0..6aca1682f4b7 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -1011,3 +1011,13 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  		kvm_vcpu_update_apicv(vcpu);
>  	avic_set_running(vcpu, true);
>  }
> +
> +bool avic_hardware_setup(bool avic, bool npt)
> +{
> +	if (!avic || !npt || !boot_cpu_has(X86_FEATURE_AVIC))
> +		return false;
Nitpick: Why to pass these as local variables? npt_enabled for example is
used in many places directly.

> +
> +	pr_info("AVIC enabled\n");
> +	amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
> +	return true;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 989685098b3e..d23bc7a7c48e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1031,13 +1031,7 @@ static __init int svm_hardware_setup(void)
>  			nrips = false;
>  	}
>  
> -	enable_apicv = avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
> -
> -	if (enable_apicv) {
> -		pr_info("AVIC enabled\n");
> -
> -		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
> -	}
> +	enable_apicv = avic = avic_hardware_setup(avic, npt_enabled);
>  
>  	if (vls) {
>  		if (!npt_enabled ||
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 5d30db599e10..1d2d72e56dd1 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -515,6 +515,7 @@ static inline bool avic_vcpu_is_running(struct kvm_vcpu *vcpu)
>  	return (READ_ONCE(*entry) & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK);
>  }
>  
> +bool avic_hardware_setup(bool avic, bool npt);
>  int avic_ga_log_notifier(u32 ga_tag);
>  void avic_vm_destroy(struct kvm *kvm);
>  int avic_vm_init(struct kvm *kvm);

Best regards,
	Maxim Levitsky

