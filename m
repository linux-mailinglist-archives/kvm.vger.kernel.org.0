Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9474BF3C2
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 09:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiBVIfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 03:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiBVIff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 03:35:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE2B5158EAA
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 00:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645518909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E30WgXgAZRS6lQUJeUsCZdCeBdcikCP7h9EfQ36uBTo=;
        b=UJMzrzulJM+sJcwYbHJ7oHygzi6LHm2GPOWWkp8P9E2wBv6YBEGMbFbr4cFubqKiuUOdZZ
        WWWs+4WvIobdLTQMQJuNtl2SRcTfep1422bJql3B1s/ySvb5xOwvpW+rBa7xovpQ9VBf7s
        z8uJNIENFv1/EpH+NQ5+6BREwyFPGyA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-sHNCW9p_PkuFDx_D5q7J3w-1; Tue, 22 Feb 2022 03:35:08 -0500
X-MC-Unique: sHNCW9p_PkuFDx_D5q7J3w-1
Received: by mail-wm1-f69.google.com with SMTP id i20-20020a05600c051400b00380d5eb51a7so235065wmc.3
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 00:35:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=E30WgXgAZRS6lQUJeUsCZdCeBdcikCP7h9EfQ36uBTo=;
        b=3CICwuggCqZ+KeYjpmISh9OHQfjEGdm7W+tKNafp36IMdfiLsnaHy2QBGAx3i14YAE
         65OWlc0eUbkclS1/5Ps3hF9NhjAhrfJgEef4SMsglnsxdRkCZ1NIJDPWT7WNM5oJl9bU
         S/g9C96FZt2AXfPI7PRbfnamgsfe+GbXarTIooJP+F+2H/Xg0FVTlvakJxU1nbNyulry
         ARp3mN69z60tJHCNJSOSqRDtbFSdmCsIjPC/8OFk6TsfhgnZ3ZhJmuZ5tJszTfp1Jglb
         aO3FDup4yfBO4nAQ7AIVBEjQfneIHJHsy3Wwa8DRFKJ35AmI3o1m1gL5lsXcvJmDttFV
         Qw+w==
X-Gm-Message-State: AOAM530dWv6bAv61gF8whm5k9CwS+fbW0MPtgzoI5ZPWKxeuwC4EHGiA
        qPRBG0emt/KUgjJ0HF6N2het8GDcUngfouZWCgHx6wxgY4RMdEe1nVEVEHr+umKKVUCc/RvK5St
        1Nyhm1sctxsFO
X-Received: by 2002:a05:6000:1081:b0:1e3:16d0:1c47 with SMTP id y1-20020a056000108100b001e316d01c47mr18921370wrw.19.1645518906781;
        Tue, 22 Feb 2022 00:35:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzTFqlbUoKjOmzD6tEVN0k7Dy726wJbHNF/nP2PKCvE89SzHXdNF5wf7IME2kP/sJ798r1zNg==
X-Received: by 2002:a05:6000:1081:b0:1e3:16d0:1c47 with SMTP id y1-20020a056000108100b001e316d01c47mr18921343wrw.19.1645518906513;
        Tue, 22 Feb 2022 00:35:06 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id v5sm32603727wrr.7.2022.02.22.00.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 00:35:05 -0800 (PST)
Message-ID: <53d4b30e-2563-c13b-eadc-8372ae965fcb@redhat.com>
Date:   Tue, 22 Feb 2022 09:35:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4] KVM: Move VM's worker kthreads back to the original
 cgroup before exiting.
Content-Language: en-US
To:     Vipin Sharma <vipinsh@google.com>, seanjc@google.com
Cc:     mkoutny@suse.com, tj@kernel.org, lizefan.x@bytedance.com,
        hannes@cmpxchg.org, dmatlack@google.com, jiangshanlai@gmail.com,
        kvm@vger.kernel.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220222054848.563321-1-vipinsh@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220222054848.563321-1-vipinsh@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/22 06:48, Vipin Sharma wrote:
> VM worker kthreads can linger in the VM process's cgroup for sometime
> after KVM terminates the VM process.
> 
> KVM terminates the worker kthreads by calling kthread_stop() which waits
> on the 'exited' completion, triggered by exit_mm(), via mm_release(), in
> do_exit() during the kthread's exit.  However, these kthreads are
> removed from the cgroup using the cgroup_exit() which happens after the
> exit_mm(). Therefore, A VM process can terminate in between the
> exit_mm() and cgroup_exit() calls, leaving only worker kthreads in the
> cgroup.
> 
> Moving worker kthreads back to the original cgroup (kthreadd_task's
> cgroup) makes sure that the cgroup is empty as soon as the main VM
> process is terminated.
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> ---

Queued, thanks.

Paolo

> Thanks Sean, for the example on how to use the real_parent outside of the RCU
> critical region. I wrote your name in Suggested-by, I hope you are fine with
> it and this is the right tag/way to give you the credit.
> 
> v4:
> - Read task's real_parent in the RCU critical section.
> - Don't log error message from the cgroup_attach_task_all() API.
> 
> v3: https://lore.kernel.org/lkml/20220217061616.3303271-1-vipinsh@google.com/
> - Use 'current->real_parent' (kthreadd_task) in the
>    cgroup_attach_task_all() call.
> - Revert cgroup APIs changes in v2. Now, patch does not touch cgroup
>    APIs.
> - Update commit and comment message
> 
> v2: https://lore.kernel.org/lkml/20211222225350.1912249-1-vipinsh@google.com/
> - Use kthreadd_task in the cgroup API to avoid build issue.
> 
> v1: https://lore.kernel.org/lkml/20211214050708.4040200-1-vipinsh@google.com/
> 
>   virt/kvm/kvm_main.c | 22 +++++++++++++++++++++-
>   1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 83c57bcc6eb6..cdf1fa3c60ae 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5810,6 +5810,7 @@ static int kvm_vm_worker_thread(void *context)
>   	 * we have to locally copy anything that is needed beyond initialization
>   	 */
>   	struct kvm_vm_worker_thread_context *init_context = context;
> +	struct task_struct *parent;
>   	struct kvm *kvm = init_context->kvm;
>   	kvm_vm_thread_fn_t thread_fn = init_context->thread_fn;
>   	uintptr_t data = init_context->data;
> @@ -5836,7 +5837,7 @@ static int kvm_vm_worker_thread(void *context)
>   	init_context = NULL;
>   
>   	if (err)
> -		return err;
> +		goto out;
>   
>   	/* Wait to be woken up by the spawner before proceeding. */
>   	kthread_parkme();
> @@ -5844,6 +5845,25 @@ static int kvm_vm_worker_thread(void *context)
>   	if (!kthread_should_stop())
>   		err = thread_fn(kvm, data);
>   
> +out:
> +	/*
> +	 * Move kthread back to its original cgroup to prevent it lingering in
> +	 * the cgroup of the VM process, after the latter finishes its
> +	 * execution.
> +	 *
> +	 * kthread_stop() waits on the 'exited' completion condition which is
> +	 * set in exit_mm(), via mm_release(), in do_exit(). However, the
> +	 * kthread is removed from the cgroup in the cgroup_exit() which is
> +	 * called after the exit_mm(). This causes the kthread_stop() to return
> +	 * before the kthread actually quits the cgroup.
> +	 */
> +	rcu_read_lock();
> +	parent = rcu_dereference(current->real_parent);
> +	get_task_struct(parent);
> +	rcu_read_unlock();
> +	cgroup_attach_task_all(parent, current);
> +	put_task_struct(parent);
> +
>   	return err;
>   }
>   
> 
> base-commit: 1bbc60d0c7e5728aced352e528ef936ebe2344c0

