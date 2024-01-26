Return-Path: <kvm+bounces-7177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57C6983DE8B
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 17:22:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B111B281DA8
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 16:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6EB21DDEE;
	Fri, 26 Jan 2024 16:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EK8unZo/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8A91DDC8
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 16:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706286117; cv=none; b=PlTgGn5JKcB7Mmwyv3b3VLNYd/tWkTFbQqNBoqz9sXaD/TPLF2MGDjrFl0YTnKKOKTTxIJkrEDBPhW0I4VmiFDsABD3eCNcRDQxBbjjWqzFQrqdJVu2Z5Z4ge4qc6sX5JRa/5KHpNmFkrDA7k4+v5vn2xP+IDlT/1q4IhNoXhsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706286117; c=relaxed/simple;
	bh=U4RlufN+2/ttlS2ZzVyaGaxSUuXUT23VnoozMGXxZKw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bRaZtrVwZcPHVQPH6exoDvBflVD5QNfly8Sc+omIawlogSiMkXHLyzDJvXDeAMSS/bAIrr8O0a23b7xxSBT1uFY77wGakTSuMBoq3eoE128vkucLF1hEMWIurkK6Xkz6MKKaMv72m5R2c50V+tJnktmx88bvRHTcBZ70YB2gtk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EK8unZo/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706286114;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/DKHWYNIQ8pDBSd77D6euq+SK1mGoY9FE9L6w6bXw+I=;
	b=EK8unZo/jS68SrQjAovgmibs61Qq1md1V3u7D5YCM11C9R3pMGBTUBnZ5yP9oNTEOc8Yuo
	4l/o4kgMGXt0K0P2TuoektppxWSDwt43kB7pwGqYmBgf4rBE8G9pU2bhId3RWSjpnHfcsy
	rH7K2/6qU4qAXRAu5bPjozn8MWKlFvg=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-Xttqxn1KOYeWoFzb0R1OYQ-1; Fri, 26 Jan 2024 11:21:52 -0500
X-MC-Unique: Xttqxn1KOYeWoFzb0R1OYQ-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-429841cf378so12131581cf.0
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 08:21:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706286112; x=1706890912;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/DKHWYNIQ8pDBSd77D6euq+SK1mGoY9FE9L6w6bXw+I=;
        b=ZhbA0h+aG60eJdKmzYdOhLRdnwfUhdf6/nY5PIGpYOFlLJGxZFYVdzNqjsdaDnaqG6
         805ghGLG7db7t1oKsGSiPrWP2BWsr/gijip7PtU4Dpq/jPayOmi7Yhk3ydnvRtBBD/Fm
         D+Dv4VoBB9x+lcgIx7Xcp38wmT+fdHLkWU/DDnqhTdLd5u56vodcGh0Nv8AJGH2blt5j
         JxUU4QM6VvkSJIcnuj5/47M0iegpO49CjZkPSd1tnm/ig9AEp5OiefTIBEx8jyeNylJS
         FrXgVUWgebE5DlVM8nGreY1cvW3bs0M9hG4aTpPM58BHFK7Q126DDUzVDrYLHiqGEZhi
         7R3w==
X-Gm-Message-State: AOJu0Yym3CDpyKM0UYLwfb5KKqyTdB1V4J/cS0mwwov4GbnAfOm8FDlx
	lz21CKkEb89BLyC4uagzUEyj3VyrI9fjvVKNNM4bKFQUOUizTWwbPgtbbML2ebBW3dzK2moEr9I
	3+d7phzDDPPpBgoYRwH6HuYW/o97QwZASEJn7qFkK9HDjT2rQMw==
X-Received: by 2002:a05:622a:14c9:b0:42a:8571:a2cb with SMTP id u9-20020a05622a14c900b0042a8571a2cbmr86557qtx.84.1706286111983;
        Fri, 26 Jan 2024 08:21:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFivbhhWcR3ymCn6eXUjLbh0aQaVUngXs/Pq/CRsCJDMlAq7L5AHlbxId9Ivo6Fqj4oVb+1tg==
X-Received: by 2002:a05:622a:14c9:b0:42a:8571:a2cb with SMTP id u9-20020a05622a14c900b0042a8571a2cbmr86543qtx.84.1706286111691;
        Fri, 26 Jan 2024 08:21:51 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id hj1-20020a05622a620100b00429aba4a360sm637903qtb.81.2024.01.26.08.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jan 2024 08:21:51 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, David Matlack
 <dmatlack@google.com>, Xu Yilun <yilun.xu@linux.intel.com>, Sean
 Christopherson <seanjc@google.com>
Subject: Re: [PATCH 3/4] KVM: Get reference to VM's address space in the
 async #PF worker
In-Reply-To: <20240110011533.503302-4-seanjc@google.com>
References: <20240110011533.503302-1-seanjc@google.com>
 <20240110011533.503302-4-seanjc@google.com>
Date: Fri, 26 Jan 2024 17:21:48 +0100
Message-ID: <87sf2k83qb.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> Get a reference to the target VM's address space in async_pf_execute()
> instead of gifting a reference from kvm_setup_async_pf().  Keeping the
> address space alive just to service an async #PF is counter-productive,
> i.e. if the process is exiting and all vCPUs are dead, then NOT doing
> get_user_pages_remote() and freeing the address space asap is
> desirable.

It took me a while to realize why all vCPU fds are managed by the same
mm which did KVM_CREATE_VM as (AFAIU) fds can be passed around. Turns
out, we explicitly forbid this in kvm_vcpu_ioctl():

        if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_dead)
                return -EIO;

so this indeed means that grabbing current->mm in kvm_setup_async_pf()
can be avoided. I'm not sure whether it's just me or a "all vCPUs are
quired to be managed by the same mm" comment somewhere would be helpful.

>
> Handling the mm reference entirely within async_pf_execute() also
> simplifies the async #PF flows as a whole, e.g. it's not immediately
> obvious when the worker task vs. the vCPU task is responsible for putting
> the gifted mm reference.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  include/linux/kvm_host.h |  1 -
>  virt/kvm/async_pf.c      | 32 ++++++++++++++++++--------------
>  2 files changed, 18 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7e7fd25b09b3..bbfefd7e612f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -238,7 +238,6 @@ struct kvm_async_pf {
>  	struct list_head link;
>  	struct list_head queue;
>  	struct kvm_vcpu *vcpu;
> -	struct mm_struct *mm;
>  	gpa_t cr2_or_gpa;
>  	unsigned long addr;
>  	struct kvm_arch_async_pf arch;
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index d5dc50318aa6..c3f4f351a2ae 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -46,8 +46,8 @@ static void async_pf_execute(struct work_struct *work)
>  {
>  	struct kvm_async_pf *apf =
>  		container_of(work, struct kvm_async_pf, work);
> -	struct mm_struct *mm = apf->mm;
>  	struct kvm_vcpu *vcpu = apf->vcpu;
> +	struct mm_struct *mm = vcpu->kvm->mm;
>  	unsigned long addr = apf->addr;
>  	gpa_t cr2_or_gpa = apf->cr2_or_gpa;
>  	int locked = 1;
> @@ -56,16 +56,24 @@ static void async_pf_execute(struct work_struct *work)
>  	might_sleep();
>  
>  	/*
> -	 * This work is run asynchronously to the task which owns
> -	 * mm and might be done in another context, so we must
> -	 * access remotely.
> +	 * Attempt to pin the VM's host address space, and simply skip gup() if
> +	 * acquiring a pin fail, i.e. if the process is exiting.  Note, KVM
> +	 * holds a reference to its associated mm_struct until the very end of
> +	 * kvm_destroy_vm(), i.e. the struct itself won't be freed before this
> +	 * work item is fully processed.
>  	 */
> -	mmap_read_lock(mm);
> -	get_user_pages_remote(mm, addr, 1, FOLL_WRITE, NULL, &locked);
> -	if (locked)
> -		mmap_read_unlock(mm);
> -	mmput(mm);
> +	if (mmget_not_zero(mm)) {
> +		mmap_read_lock(mm);
> +		get_user_pages_remote(mm, addr, 1, FOLL_WRITE, NULL, &locked);
> +		if (locked)
> +			mmap_read_unlock(mm);
> +		mmput(mm);
> +	}
>  
> +	/*
> +	 * Notify and kick the vCPU even if faulting in the page failed, e.g.
> +	 * so that the vCPU can retry the fault synchronously.
> +	 */
>  	if (IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC))
>  		kvm_arch_async_page_present(vcpu, apf);
>  
> @@ -129,10 +137,8 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>  #ifdef CONFIG_KVM_ASYNC_PF_SYNC
>  		flush_work(&work->work);
>  #else
> -		if (cancel_work_sync(&work->work)) {
> -			mmput(work->mm);
> +		if (cancel_work_sync(&work->work))
>  			kmem_cache_free(async_pf_cache, work);
> -		}
>  #endif
>  		spin_lock(&vcpu->async_pf.lock);
>  	}
> @@ -211,8 +217,6 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	work->cr2_or_gpa = cr2_or_gpa;
>  	work->addr = hva;
>  	work->arch = *arch;
> -	work->mm = current->mm;
> -	mmget(work->mm);
>  
>  	INIT_WORK(&work->work, async_pf_execute);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


