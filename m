Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4F752D70F
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 17:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240384AbiESPLj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 11:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbiESPLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 11:11:37 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA94C3D04
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 08:11:36 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id oe17-20020a17090b395100b001df77d29587so9062894pjb.2
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 08:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4Wjqb7J0OT9KYHXXCeBLrYb3EVxh1eRmx0RuysFsRoM=;
        b=I0yQTVxRZpwSIlmUf2cUxCcSnR5KRgCqBTVQoKToBZaVFwsYSy5DtsR8LepAusQbef
         /e61wJa8WLr0udgE+QhWg+/yO2xOjccdfZW8sgsOK/4hYQVIYSJrQrR7H6LBQ/JTANPw
         YlhwrKwjHM0C+toCGBwaH87qTeRaljJYwqScpUe9+lKq9ZbcMJtqz9UCPpoEU6ikUJLt
         A5TJzQNSzgdTsXb62DcMj0IkGPGsImIi/O2M58+eBWRJ15lxO6YQln3IymCqwyyxA8cA
         Y8FL8+cyg+sSVL72rSdpEE4mHc09oGuM4eDaZwwd/WNKCJfSv/kdAxWGUZhnqVRcigL5
         4b2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4Wjqb7J0OT9KYHXXCeBLrYb3EVxh1eRmx0RuysFsRoM=;
        b=GWKPBN2/YpqBdRfgD39HhyXBCQitpJrfKSawg4Zz8DXozT1+Nm377pP2jUf7iAbd7k
         1N/qpMvISEXMewKFfHFPvFFPcM4y1/6OQkKsmWWQRc3G+qJpB9EQfrSyf6iyOPxmhhyi
         Ij/5Eb+4bYzKbeBbRpjhR8Uz0R9HEd1UOYxAQD0MJ0OKVcxlQk4svArfpTlP/l0Bx9++
         Dmto5pzlePHFukEyd4vuxG0QQ9+CJs4LjbGWlKvwQ4jaEyl/ERfcbzWA7S0tPcGPO/sC
         6fJu7Z4Cy4aD+ez4/RSzXd/HL64Pz6UgudX04qm8yhCqi4UNtqL0nNsOSsNsSNP7mThR
         6CIQ==
X-Gm-Message-State: AOAM533e/i4XromhrJyooLiKPefQdjCvACx5qaMZR6g2abXwKhFn70hq
        ygVq9/jhJ2D5qMkQvCqsfGXo3A==
X-Google-Smtp-Source: ABdhPJzzw3DUBhgsdAsLWa+WeYvi6+ZP3UNp6G5yONZSa8nWZ4fomRIz39UHTvL4f3IZHowvLJytqA==
X-Received: by 2002:a17:90b:3b45:b0:1dd:1f37:d159 with SMTP id ot5-20020a17090b3b4500b001dd1f37d159mr6255825pjb.44.1652973095836;
        Thu, 19 May 2022 08:11:35 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m2-20020a629402000000b0050dc76281b4sm4385287pfe.142.2022.05.19.08.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 08:11:35 -0700 (PDT)
Date:   Thu, 19 May 2022 15:11:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Move kzalloc out of atomic context on
 PREEMPT_RT
Message-ID: <YoZeI6UeQbP3t1dF@google.com>
References: <20220519090218.2230653-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519090218.2230653-1-yajun.deng@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"x86/kvm:" is the preferred shortlog scope for the guest side of things, "KVM: x86"
is for the host, i.e. for arch/x86/kvm.

On Thu, May 19, 2022, Yajun Deng wrote:
> The memory allocator is fully preemptible and therefore cannot
> be invoked from truly atomic contexts.
> 
> See Documentation/locking/locktypes.rst (line: 470)
> 
> Add raw_spin_unlock() before memory allocation and raw_spin_lock()
> after it.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  arch/x86/kernel/kvm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index d0bb2b3fb305..8f8ec9bbd847 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -205,7 +205,9 @@ void kvm_async_pf_task_wake(u32 token)
>  		 * async PF was not yet handled.
>  		 * Add dummy entry for the token.
>  		 */
> -		n = kzalloc(sizeof(*n), GFP_ATOMIC);
> +		raw_spin_unlock(&b->lock);
> +		n = kzalloc(sizeof(*n), GFP_KERNEL);
> +		raw_spin_lock(&b->lock);

This is flawed, if the async #PF is handled while the lock is dropped then this
will enqueue a second, duplicate entry and not call apf_task_wake_one() as it
should.  I.e. two entries will be leaked.

AFAICT, kfree() is safe to call under a raw spinlock, so this?  Compile tested
only...

--
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 19 May 2022 07:57:11 -0700
Subject: [PATCH] x86/kvm: Alloc dummy async #PF token outside of raw spinlock

Drop the raw spinlock in kvm_async_pf_task_wake() before allocating the
the dummy async #PF token, the allocator is preemptible on PREEMPT_RT
kernels and must not be called from truly atomic contexts.

Opportunistically document why it's ok to loop on allocation failure,
i.e. why the function won't get stuck in an infinite loop.

Reported-by: Yajun Deng <yajun.deng@linux.dev>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/kvm.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d0bb2b3fb305..5a4100896969 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -190,7 +190,7 @@ void kvm_async_pf_task_wake(u32 token)
 {
 	u32 key = hash_32(token, KVM_TASK_SLEEP_HASHBITS);
 	struct kvm_task_sleep_head *b = &async_pf_sleepers[key];
-	struct kvm_task_sleep_node *n;
+	struct kvm_task_sleep_node *n, *dummy = NULL;

 	if (token == ~0) {
 		apf_task_wake_all();
@@ -202,24 +202,34 @@ void kvm_async_pf_task_wake(u32 token)
 	n = _find_apf_task(b, token);
 	if (!n) {
 		/*
-		 * async PF was not yet handled.
-		 * Add dummy entry for the token.
+		 * Async #PF not yet handled, add a dummy entry for the token.
+		 * Allocating the token must be down outside of the raw lock
+		 * as the allocator is preemptible on PREEMPT_RT kernels.
 		 */
-		n = kzalloc(sizeof(*n), GFP_ATOMIC);
-		if (!n) {
-			/*
-			 * Allocation failed! Busy wait while other cpu
-			 * handles async PF.
-			 */
+		if (!dummy) {
 			raw_spin_unlock(&b->lock);
-			cpu_relax();
+			dummy = kzalloc(sizeof(*dummy), GFP_KERNEL);
+
+			/*
+			 * Continue looping on allocation failure, eventually
+			 * the async #PF will be handled and allocating a new
+			 * node will be unnecessary.
+			 */
+			if (!dummy)
+				cpu_relax();
+
+			/*
+			 * Recheck for async #PF completion before enqueueing
+			 * the dummy token to avoid duplicate list entries.
+			 */
 			goto again;
 		}
-		n->token = token;
-		n->cpu = smp_processor_id();
-		init_swait_queue_head(&n->wq);
-		hlist_add_head(&n->link, &b->list);
+		dummy->token = token;
+		dummy->cpu = smp_processor_id();
+		init_swait_queue_head(&dummy->wq);
+		hlist_add_head(&dummy->link, &b->list);
 	} else {
+		kfree(dummy);
 		apf_task_wake_one(n);
 	}
 	raw_spin_unlock(&b->lock);

base-commit: a3808d88461270c71d3fece5e51cc486ecdac7d0
--

