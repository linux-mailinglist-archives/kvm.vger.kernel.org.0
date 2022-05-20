Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3744C52ED58
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 15:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349898AbiETNlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 09:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiETNlY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 09:41:24 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2863531379;
        Fri, 20 May 2022 06:41:22 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id eg11so10815166edb.11;
        Fri, 20 May 2022 06:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lcv326N5l/221uSMBna/cd7I8SJc4EhekStbcIIhtpE=;
        b=ovZ4Vh1BHfKy5NEow/4z/wJot02yZZDFl2MFFmTx+Y0ahHPvGO+OEd6jNsWe/NU85P
         3JNbwpGKECltQJAgwwrtifTsDGRh3BTsN1RajwOSmgiWbyH/s+slzHjwX35zlIVY80X1
         Klj2fA4h6DaZs7ePqd55KKqEEEoXRQqvC4CMg4VyubGP2KF4V1+pittAuSLVn7EfekjV
         v79/UrjinmQ2DjUtJEb/t04+VP0O8hGcnMHIjHuplrLhGLBy/ocFZL78tp8GCJbIlWBu
         pFS7KjISI6NfXU4NGAm+RWCRj3fVNUHHv5yRaoef+rPZ75ems59xrln35IMy4L0TNw5i
         Z7VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lcv326N5l/221uSMBna/cd7I8SJc4EhekStbcIIhtpE=;
        b=z9eF3J3DXMxnNrG0bYyoHCMOUdTkWELQzzpYs/dIJ+M7aACmPzvnYdBWfWJhAccybl
         AJg/uBSd7ga4cjMood2ziP4QHzrCpsj+8q1DNBjT/ckp3wGcGmh9UJTP993aLtXyJjZY
         /BltpkLXP4s9VquV+Bb51Lgi4SkqZ1api2vyo1WblmQoJ6IzzpiKj7JrEMcaupG7Woux
         GU+9SVhcTdsu0sF4bPGnb0Z95bv3aurG+BwHSTdB/vpdQSZe9Ni3h4QfP4w4zHCiNOlK
         e5CT6afi5USJsOhq8SfLTzlsQ6OElV9eFznrVSHNsVb0N779p41z0dB2bAs/DiwAhbpo
         fSbQ==
X-Gm-Message-State: AOAM533ncUQlhLCJUK5foBv2bky6BaRZx8o6cdbE5PWV5fUd9/NwFF32
        fBU+IoA/1HEQBSjuaGJiIUXjppM8VVviKg==
X-Google-Smtp-Source: ABdhPJxoDGyuC3nchI3VwzaFElzcGpiBzu4U57f8FPYzC3YYoTsdhQ8nh2Bcgd2WAIQVRCzpC869lA==
X-Received: by 2002:aa7:c506:0:b0:42a:b067:cbe7 with SMTP id o6-20020aa7c506000000b0042ab067cbe7mr10991176edq.4.1653054080609;
        Fri, 20 May 2022 06:41:20 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id m5-20020a17090677c500b006f3ef214e24sm3187796ejn.138.2022.05.20.06.41.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 06:41:19 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <f7585471-43be-4b40-f398-dfd7dc937131@redhat.com>
Date:   Fri, 20 May 2022 15:41:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] KVM: x86: Move kzalloc out of atomic context on
 PREEMPT_RT
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Yajun Deng <yajun.deng@linux.dev>
Cc:     vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220519090218.2230653-1-yajun.deng@linux.dev>
 <YoZeI6UeQbP3t1dF@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YoZeI6UeQbP3t1dF@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/19/22 17:11, Sean Christopherson wrote:
> AFAICT, kfree() is safe to call under a raw spinlock, so this?  Compile tested
> only...

Freeing outside the lock is not complicated enough to check if it is:

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6aa1241a80b7..f849f7c9fbf2 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -229,12 +229,15 @@ void kvm_async_pf_task_wake(u32 token)
  		dummy->cpu = smp_processor_id();
  		init_swait_queue_head(&dummy->wq);
  		hlist_add_head(&dummy->link, &b->list);
+		dummy = NULL;
  	} else {
-		kfree(dummy);
  		apf_task_wake_one(n);
  	}
  	raw_spin_unlock(&b->lock);
-	return;
+
+	/* A dummy token might be allocated and ultimately not used.  */
+	if (dummy)
+		kfree(dummy);
  }
  EXPORT_SYMBOL_GPL(kvm_async_pf_task_wake);


I queued your patch with the above fixup.

Paolo
> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Thu, 19 May 2022 07:57:11 -0700
> Subject: [PATCH] x86/kvm: Alloc dummy async #PF token outside of raw spinlock
> 
> Drop the raw spinlock in kvm_async_pf_task_wake() before allocating the
> the dummy async #PF token, the allocator is preemptible on PREEMPT_RT
> kernels and must not be called from truly atomic contexts.
> 
> Opportunistically document why it's ok to loop on allocation failure,
> i.e. why the function won't get stuck in an infinite loop.
> 
> Reported-by: Yajun Deng <yajun.deng@linux.dev>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kernel/kvm.c | 38 ++++++++++++++++++++++++--------------
>   1 file changed, 24 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index d0bb2b3fb305..5a4100896969 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -190,7 +190,7 @@ void kvm_async_pf_task_wake(u32 token)
>   {
>   	u32 key = hash_32(token, KVM_TASK_SLEEP_HASHBITS);
>   	struct kvm_task_sleep_head *b = &async_pf_sleepers[key];
> -	struct kvm_task_sleep_node *n;
> +	struct kvm_task_sleep_node *n, *dummy = NULL;
> 
>   	if (token == ~0) {
>   		apf_task_wake_all();
> @@ -202,24 +202,34 @@ void kvm_async_pf_task_wake(u32 token)
>   	n = _find_apf_task(b, token);
>   	if (!n) {
>   		/*
> -		 * async PF was not yet handled.
> -		 * Add dummy entry for the token.
> +		 * Async #PF not yet handled, add a dummy entry for the token.
> +		 * Allocating the token must be down outside of the raw lock
> +		 * as the allocator is preemptible on PREEMPT_RT kernels.
>   		 */
> -		n = kzalloc(sizeof(*n), GFP_ATOMIC);
> -		if (!n) {
> -			/*
> -			 * Allocation failed! Busy wait while other cpu
> -			 * handles async PF.
> -			 */
> +		if (!dummy) {
>   			raw_spin_unlock(&b->lock);
> -			cpu_relax();
> +			dummy = kzalloc(sizeof(*dummy), GFP_KERNEL);
> +
> +			/*
> +			 * Continue looping on allocation failure, eventually
> +			 * the async #PF will be handled and allocating a new
> +			 * node will be unnecessary.
> +			 */
> +			if (!dummy)
> +				cpu_relax();
> +
> +			/*
> +			 * Recheck for async #PF completion before enqueueing
> +			 * the dummy token to avoid duplicate list entries.
> +			 */
>   			goto again;
>   		}
> -		n->token = token;
> -		n->cpu = smp_processor_id();
> -		init_swait_queue_head(&n->wq);
> -		hlist_add_head(&n->link, &b->list);
> +		dummy->token = token;
> +		dummy->cpu = smp_processor_id();
> +		init_swait_queue_head(&dummy->wq);
> +		hlist_add_head(&dummy->link, &b->list);
>   	} else {
> +		kfree(dummy);
>   		apf_task_wake_one(n);
>   	}
>   	raw_spin_unlock(&b->lock);
> 
> base-commit: a3808d88461270c71d3fece5e51cc486ecdac7d0
> --
> 

