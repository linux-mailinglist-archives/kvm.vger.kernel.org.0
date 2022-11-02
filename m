Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B1D6169F9
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 18:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbiKBRHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 13:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiKBRHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 13:07:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8321D12752
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 10:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667408787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MzSlArbLjLwuYh4coYhcF492GFrAwrpr5F1CiSw7i+g=;
        b=KRIut3ohCRr0wqfwdMdctFBSiWsDZ0hNSD3SESZXb3+9LoIC9IJqRM04qn72V83mGlrZ7m
        ++WOGMLc/7dl7aRW9U8WuRkdzLD7nzZGvhDkDW64bzO6hF7RLWxNG9P1m+frN0tgWVbi1O
        4lEmpXNKUnNYryYKGBjlZru1X3UaaK4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-425-mfW4090sP3qwDxs-AtHyAw-1; Wed, 02 Nov 2022 13:06:26 -0400
X-MC-Unique: mfW4090sP3qwDxs-AtHyAw-1
Received: by mail-ej1-f70.google.com with SMTP id gt15-20020a1709072d8f00b007aaac7973fbso10472499ejc.23
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 10:06:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MzSlArbLjLwuYh4coYhcF492GFrAwrpr5F1CiSw7i+g=;
        b=HrQufAf3rwiQjCvTbSyvcepUMNCj2l7FbISpiCjM+5hlXFHJLC9MzhQ22cUDkptbNM
         DG4z5RFpud0sNPQPC8bWJoyl+2W8HHhky7EJU1hiw1KKsym2DE3c24wMkC+4DkeBA+3Z
         L5lA+h1qc2iMZEsXhfY25i5LCppIH5a2ZGwDlBnMgk5MuZmCn6/jSjvujO2tkHkhxZy7
         UZgBlmyRf4c8giEGAmuCzl+RALuk9yNOUuzFJT+kpwdCPHur0sxVsD+p6bxGmn1I81id
         jX8ZVl2gR67v9VosWnLFvo4xYvxPLi4nyn6e0mRJg7HhEXT2wSB1P4DIB3TF+757WPwc
         +8OQ==
X-Gm-Message-State: ACrzQf1regkc/tL+W5ILILS8b0qiDtE9z5q2mu3JF6r3xtijrv0QRXF9
        DCCyt4OQq+4C0nkXzKI+KQlkAnl58ofqeQbjHq5Mjkht2sZid3mmcL6rhrARWzYEKB8PZIg6t6m
        nhmSrPZzlJZAA
X-Received: by 2002:aa7:c1d9:0:b0:463:aeaf:3383 with SMTP id d25-20020aa7c1d9000000b00463aeaf3383mr10397476edp.253.1667408785383;
        Wed, 02 Nov 2022 10:06:25 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4a5aiauK1J6VQYUF9mjlkxz4BZlsbuGTOro+zFT5daW27YWQJ+DquzsEIfrHyUKJnR8l1zDg==
X-Received: by 2002:aa7:c1d9:0:b0:463:aeaf:3383 with SMTP id d25-20020aa7c1d9000000b00463aeaf3383mr10397444edp.253.1667408785114;
        Wed, 02 Nov 2022 10:06:25 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id g11-20020a170906394b00b007abafe43c3bsm5575689eje.86.2022.11.02.10.06.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 10:06:24 -0700 (PDT)
Message-ID: <bb2e70cb-002d-8032-d8c2-bb64dd2476a0@redhat.com>
Date:   Wed, 2 Nov 2022 18:06:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v4 1/4] mm/gup: Add FOLL_INTERRUPTIBLE
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Matlack <dmatlack@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Mike Kravetz <mike.kravetz@oracle.com>
References: <20221011195809.557016-1-peterx@redhat.com>
 <20221011195809.557016-2-peterx@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221011195809.557016-2-peterx@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/22 21:58, Peter Xu wrote:
> We have had FAULT_FLAG_INTERRUPTIBLE but it was never applied to GUPs.  One
> issue with it is that not all GUP paths are able to handle signal delivers
> besides SIGKILL.
> 
> That's not ideal for the GUP users who are actually able to handle these
> cases, like KVM.
> 
> KVM uses GUP extensively on faulting guest pages, during which we've got
> existing infrastructures to retry a page fault at a later time.  Allowing
> the GUP to be interrupted by generic signals can make KVM related threads
> to be more responsive.  For examples:
> 
>    (1) SIGUSR1: which QEMU/KVM uses to deliver an inter-process IPI,
>        e.g. when the admin issues a vm_stop QMP command, SIGUSR1 can be
>        generated to kick the vcpus out of kernel context immediately,
> 
>    (2) SIGINT: which can be used with interactive hypervisor users to stop a
>        virtual machine with Ctrl-C without any delays/hangs,
> 
>    (3) SIGTRAP: which grants GDB capability even during page faults that are
>        stuck for a long time.
> 
> Normally hypervisor will be able to receive these signals properly, but not
> if we're stuck in a GUP for a long time for whatever reason.  It happens
> easily with a stucked postcopy migration when e.g. a network temp failure
> happens, then some vcpu threads can hang death waiting for the pages.  With
> the new FOLL_INTERRUPTIBLE, we can allow GUP users like KVM to selectively
> enable the ability to trap these signals.
> 
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>

If no one shouts I will queue the series for 6.2, but it would be nice 
to get an ACK from the mm folks.

> ---
>   include/linux/mm.h |  1 +
>   mm/gup.c           | 33 +++++++++++++++++++++++++++++----
>   mm/hugetlb.c       |  5 ++++-
>   3 files changed, 34 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 21f8b27bd9fd..488a9f4cce07 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2897,6 +2897,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
>   #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
>   #define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
>   #define FOLL_FAST_ONLY	0x80000	/* gup_fast: prevent fall-back to slow gup */
> +#define FOLL_INTERRUPTIBLE  0x100000 /* allow interrupts from generic signals */
>   
>   /*
>    * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
> diff --git a/mm/gup.c b/mm/gup.c
> index 5abdaf487460..d51e7ccaef32 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -970,8 +970,17 @@ static int faultin_page(struct vm_area_struct *vma,
>   		fault_flags |= FAULT_FLAG_WRITE;
>   	if (*flags & FOLL_REMOTE)
>   		fault_flags |= FAULT_FLAG_REMOTE;
> -	if (locked)
> +	if (locked) {
>   		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
> +		/*
> +		 * FAULT_FLAG_INTERRUPTIBLE is opt-in. GUP callers must set
> +		 * FOLL_INTERRUPTIBLE to enable FAULT_FLAG_INTERRUPTIBLE.
> +		 * That's because some callers may not be prepared to
> +		 * handle early exits caused by non-fatal signals.
> +		 */
> +		if (*flags & FOLL_INTERRUPTIBLE)
> +			fault_flags |= FAULT_FLAG_INTERRUPTIBLE;
> +	}
>   	if (*flags & FOLL_NOWAIT)
>   		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT;
>   	if (*flags & FOLL_TRIED) {
> @@ -1380,6 +1389,22 @@ int fixup_user_fault(struct mm_struct *mm,
>   }
>   EXPORT_SYMBOL_GPL(fixup_user_fault);
>   
> +/*
> + * GUP always responds to fatal signals.  When FOLL_INTERRUPTIBLE is
> + * specified, it'll also respond to generic signals.  The caller of GUP
> + * that has FOLL_INTERRUPTIBLE should take care of the GUP interruption.
> + */
> +static bool gup_signal_pending(unsigned int flags)
> +{
> +	if (fatal_signal_pending(current))
> +		return true;
> +
> +	if (!(flags & FOLL_INTERRUPTIBLE))
> +		return false;
> +
> +	return signal_pending(current);
> +}
> +
>   /*
>    * Please note that this function, unlike __get_user_pages will not
>    * return 0 for nr_pages > 0 without FOLL_NOWAIT
> @@ -1461,11 +1486,11 @@ static __always_inline long __get_user_pages_locked(struct mm_struct *mm,
>   		 * Repeat on the address that fired VM_FAULT_RETRY
>   		 * with both FAULT_FLAG_ALLOW_RETRY and
>   		 * FAULT_FLAG_TRIED.  Note that GUP can be interrupted
> -		 * by fatal signals, so we need to check it before we
> +		 * by fatal signals of even common signals, depending on
> +		 * the caller's request. So we need to check it before we
>   		 * start trying again otherwise it can loop forever.
>   		 */
> -
> -		if (fatal_signal_pending(current)) {
> +		if (gup_signal_pending(flags)) {
>   			if (!pages_done)
>   				pages_done = -EINTR;
>   			break;
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index e070b8593b37..202f3ad7f35c 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6206,9 +6206,12 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
>   				fault_flags |= FAULT_FLAG_WRITE;
>   			else if (unshare)
>   				fault_flags |= FAULT_FLAG_UNSHARE;
> -			if (locked)
> +			if (locked) {
>   				fault_flags |= FAULT_FLAG_ALLOW_RETRY |
>   					FAULT_FLAG_KILLABLE;
> +				if (flags & FOLL_INTERRUPTIBLE)
> +					fault_flags |= FAULT_FLAG_INTERRUPTIBLE;
> +			}
>   			if (flags & FOLL_NOWAIT)
>   				fault_flags |= FAULT_FLAG_ALLOW_RETRY |
>   					FAULT_FLAG_RETRY_NOWAIT;

