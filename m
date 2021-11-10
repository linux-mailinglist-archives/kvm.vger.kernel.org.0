Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC4844C481
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 16:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhKJPj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 10:39:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33564 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231408AbhKJPj5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Nov 2021 10:39:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636558629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TsMK8Ym36EtrROun3gA7xiKiYj4bqI5P7kgHHKBVFyA=;
        b=g4FeNr+u+9ZzjznZffLHgfJ5lfdJDzedodtUlqoS28w94lFIy5x/wultiqDR8XYemZeDIl
        EdlChEgj+FFg2bSb+EbywNpms0LCjmqQi0Y9Z2Tx4fQUbjmUtqWUABOSeg9L6ZKb46DAJw
        0Cy8emibbF292ZlExnmoiMP48gx6iK4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-JKKJfHR2NOWobHnKeq2DBw-1; Wed, 10 Nov 2021 10:37:07 -0500
X-MC-Unique: JKKJfHR2NOWobHnKeq2DBw-1
Received: by mail-wr1-f69.google.com with SMTP id y10-20020adffa4a000000b0017eea6cb05dso503305wrr.6
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 07:37:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TsMK8Ym36EtrROun3gA7xiKiYj4bqI5P7kgHHKBVFyA=;
        b=8EaPBUZXBSb0e47mDOUY2VdM2oxU7oF+V7sYBEZHLsugpFwCZCcp8dTBuix7SwdHX6
         dG/+NJ8cDsE3kWbfBVy8QUctnHwu8ApRC5LbmZ4ODf+QiNgftaAA1P73eKDQSc8upvSM
         z1CJtJmX/XaBBBuFVhwsIfTap9JGMggCSir5z9ZlJhG5ovLVw5mI84qQxXJzfobP8L45
         qBBnmhP1GCsDv3UD4AqdR7h+j5tUPMTvhP6gRJmIWzDhyOkiBxS5mSZSCdwHvN9fkXKA
         TDpmf1zGQgOrp6zhyBIRLvh/rERJxh1qMKqMS0J6pXMcKWpIdf+pdkC+k18R25n5YX7u
         xrOg==
X-Gm-Message-State: AOAM531lB9rOMjFlT2aG7yY6qW+9oKhnbDuIAvymo72z2gvtZ3vGjnts
        Nj6N1JE4qvzRBlV8C5soMfLFm8IUkQV+Bw1IcaMyK5W7JXds7kU7hyMiu4850kKmflTj0oEWGMl
        SlfvjbOxdF/vX
X-Received: by 2002:a5d:6501:: with SMTP id x1mr747756wru.390.1636558625622;
        Wed, 10 Nov 2021 07:37:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJycXSjChwKB0BbkM3ANwTjPHehWgOpLyLq/W1gEpfqQx0APhVPiRmZJycKMvLPxdh+qEJNvlg==
X-Received: by 2002:a5d:6501:: with SMTP id x1mr747721wru.390.1636558625424;
        Wed, 10 Nov 2021 07:37:05 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id n32sm6983581wms.1.2021.11.10.07.37.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 07:37:04 -0800 (PST)
Subject: Re: [PATCH v4 02/15] KVM: async_pf: Add helper function to check
 completion queue
To:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
        shan.gavin@gmail.com, Jonathan.Cameron@huawei.com,
        pbonzini@redhat.com, vkuznets@redhat.com, will@kernel.org
References: <20210815005947.83699-1-gshan@redhat.com>
 <20210815005947.83699-3-gshan@redhat.com>
From:   Eric Auger <eauger@redhat.com>
Message-ID: <56d8dbec-a8fd-b109-0c0f-b01c1aef4741@redhat.com>
Date:   Wed, 10 Nov 2021 16:37:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210815005947.83699-3-gshan@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Gavin,

On 8/15/21 2:59 AM, Gavin Shan wrote:
> This adds inline helper kvm_check_async_pf_completion_queue() to
> check if there are pending completion in the queue. The empty stub
> is also added on !CONFIG_KVM_ASYNC_PF so that the caller needn't
> consider if CONFIG_KVM_ASYNC_PF is enabled.
> 
> All checks on the completion queue is done by the newly added inline
> function since list_empty() and list_empty_careful() are interchangeable.
why is it interchangeable?

> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  arch/x86/kvm/x86.c       |  2 +-
>  include/linux/kvm_host.h | 10 ++++++++++
>  virt/kvm/async_pf.c      | 10 +++++-----
>  virt/kvm/kvm_main.c      |  4 +---
>  4 files changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e5d5c5ed7dd4..7f35d9324b99 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11591,7 +11591,7 @@ static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
>  
>  static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>  {
> -	if (!list_empty_careful(&vcpu->async_pf.done))
> +	if (kvm_check_async_pf_completion_queue(vcpu))
>  		return true;
>  
>  	if (kvm_apic_has_events(vcpu))
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 85b61a456f1c..a5f990f6dc35 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -339,12 +339,22 @@ struct kvm_async_pf {
>  	bool				notpresent_injected;
>  };
>  
> +static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)
> +{
> +	return !list_empty_careful(&vcpu->async_pf.done);
> +}
> +
>  void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
>  void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu);
>  bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  			unsigned long hva, struct kvm_arch_async_pf *arch);
>  int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
>  #else
> +static inline bool kvm_check_async_pf_completion_queue(struct kvm_vcpu *vcpu)
> +{
> +	return false;
> +}
> +
>  static inline void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu) { }
>  #endif
>  
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index dd777688d14a..d145a61a046a 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -70,7 +70,7 @@ static void async_pf_execute(struct work_struct *work)
>  		kvm_arch_async_page_present(vcpu, apf);
>  
>  	spin_lock(&vcpu->async_pf.lock);
> -	first = list_empty(&vcpu->async_pf.done);
> +	first = !kvm_check_async_pf_completion_queue(vcpu);
>  	list_add_tail(&apf->link, &vcpu->async_pf.done);
>  	apf->vcpu = NULL;
>  	spin_unlock(&vcpu->async_pf.lock);
> @@ -122,7 +122,7 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>  		spin_lock(&vcpu->async_pf.lock);
>  	}
>  
> -	while (!list_empty(&vcpu->async_pf.done)) {
> +	while (kvm_check_async_pf_completion_queue(vcpu)) {
this is replaced by a stronger check. Please can you explain why is it
equivalent?
>  		struct kvm_async_pf *work =
>  			list_first_entry(&vcpu->async_pf.done,
>  					 typeof(*work), link);
> @@ -138,7 +138,7 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_async_pf *work;
>  
> -	while (!list_empty_careful(&vcpu->async_pf.done) &&
> +	while (kvm_check_async_pf_completion_queue(vcpu) &&
>  	      kvm_arch_can_dequeue_async_page_present(vcpu)) {
>  		spin_lock(&vcpu->async_pf.lock);
>  		work = list_first_entry(&vcpu->async_pf.done, typeof(*work),
> @@ -205,7 +205,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
>  	struct kvm_async_pf *work;
>  	bool first;
>  
> -	if (!list_empty_careful(&vcpu->async_pf.done))
> +	if (kvm_check_async_pf_completion_queue(vcpu))
>  		return 0;
>  
>  	work = kmem_cache_zalloc(async_pf_cache, GFP_ATOMIC);
> @@ -216,7 +216,7 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
>  	INIT_LIST_HEAD(&work->queue); /* for list_del to work */
>  
>  	spin_lock(&vcpu->async_pf.lock);
> -	first = list_empty(&vcpu->async_pf.done);
> +	first = !kvm_check_async_pf_completion_queue(vcpu);
>  	list_add_tail(&work->link, &vcpu->async_pf.done);
>  	spin_unlock(&vcpu->async_pf.lock);
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b50dbe269f4b..8795503651b1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3282,10 +3282,8 @@ static bool vcpu_dy_runnable(struct kvm_vcpu *vcpu)
>  	if (kvm_arch_dy_runnable(vcpu))
>  		return true;
>  
> -#ifdef CONFIG_KVM_ASYNC_PF
> -	if (!list_empty_careful(&vcpu->async_pf.done))
> +	if (kvm_check_async_pf_completion_queue(vcpu))
>  		return true;
> -#endif
>  
>  	return false;
>  }
> 
Thanks

Eric

