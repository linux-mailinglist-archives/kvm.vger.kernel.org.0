Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14BA62EA67
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 01:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238946AbiKRAhX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 19:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbiKRAhU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 19:37:20 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB8E7D527
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 16:37:20 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 62so3578930pgb.13
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 16:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kEdI6Pefgjdm+EKzofsS1dkV8ASnDhMDZc0vg3AoaOk=;
        b=mpgCnkF+5w2+/AujiObw8Mqy6X7d1iuTYnxLCp6HL6YfGduKPhj42N7MHYAkG8qwb2
         mLlB81pCP/nyVIfWWWM/nTIY2EqAjoqRextyWToJy4O9KP7z7/U5OR3cCqT5fEk+jzhV
         HRVM3212zxnk7hU8uMpho9eL+/bTkhSkXYEQaMNCIcqHp6yJcsBJkHaQMCbFREv6+WIR
         QLNVGXqwsIwWsxN0FfMq6n1R+Byak77CKre5n7N3eWYEDiFVqx06189l0ybO7ju3qwxX
         wf1iYunf2IAwpwnumyGQV7IHqNtpAEF/vIuDkC5ZuBbhhiBdVURP29I+B4ahY7Cj5aia
         132A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kEdI6Pefgjdm+EKzofsS1dkV8ASnDhMDZc0vg3AoaOk=;
        b=TLo/JF/Cm0dNHleQe8LpLK9F6Ja8vH7/9WqT97y5bmsZg7dl4tNRDhKbd9WWXQ3J+H
         UKpZidD4DsgtOpOMff6S8A1+a8p+ZGMbHE3bihr0WlwvTu75itJqrH28F5MR+skhinol
         1ctTNUftUal3WwVFFZeqofi/ut4gxf8I3r2ewHOz+XDJ4X3/x5JUg0GdBnJX/AzduwbJ
         e3P4OpmiW8k5GEfjrXIn8IQ3Ck2/VmGgD1Bomh1sUe8nUntTK64BLSv1Mj5ypq5/O/d5
         +FmYVjZJBjp8UF0Ghr6vxhs9JxSOIrD4uMQq1awUeQFxopFHlJdBjCGcPOfwWX96vdA+
         TVlw==
X-Gm-Message-State: ANoB5pmAbERLUDKxMtzmy5DT1xnRYRGoJrSPWZxGiZEsUpKP66cVRyTF
        dFpObuLxYLN+uydSuwsm76s3KA==
X-Google-Smtp-Source: AA0mqf45/scTNkT3/7wF/3cL82iaVbqBOprfXBPSjDQhA5Vf1PJDWzW1ny9LGtDqJPp51v/zIeJ2Tw==
X-Received: by 2002:a05:6a00:2444:b0:558:991a:6671 with SMTP id d4-20020a056a00244400b00558991a6671mr5432059pfj.58.1668731839598;
        Thu, 17 Nov 2022 16:37:19 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c65-20020a621c44000000b0056bcd7e1e04sm1760270pfc.124.2022.11.17.16.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 16:37:18 -0800 (PST)
Date:   Fri, 18 Nov 2022 00:37:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH] KVM: x86: avoid memslot check in NX hugepage recovery if
 it cannot be true
Message-ID: <Y3bTu4/nUfpX+Enm@google.com>
References: <20221117173109.3126912-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117173109.3126912-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 17, 2022, Paolo Bonzini wrote:
> +		if (atomic_read(&kvm->nr_logpage_memslots)) {

Can we use something like nr_dirty_logged_memslots?  logpage doesn't precisely
capture the "dirty log" aspect, e.g. for a (very brief) second I though this was
log(nr_memslot_pages).

> +			slot = gfn_to_memslot(kvm, sp->gfn);
> +			WARN_ON_ONCE(!slot);
> +		}
> +
>  		if (slot && kvm_slot_dirty_track_enabled(slot))
>  			unaccount_nx_huge_page(kvm, sp);
>  		else if (is_tdp_mmu_page(sp))
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e6e66c5e56f2..b3c2b975e737 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -722,6 +722,11 @@ struct kvm {
>  	/* The current active memslot set for each address space */
>  	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
>  	struct xarray vcpu_array;
> +	/*
> +	 * Protected by slots_lock, but can be read outside if an
> +	 * incorrect answer is acceptable.
> +	 */
> +	atomic_t nr_logpage_memslots;
>  
>  	/* Used to wait for completion of MMU notifiers.  */
>  	spinlock_t mn_invalidate_lock;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 43bbe4fde078..7670ebd29bcf 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1627,6 +1627,11 @@ static int kvm_prepare_memory_region(struct kvm *kvm,

This needs to be done in the commit stage, e.g. if kvm_arch_prepare_memory_region()
fails the count will be all kinds of wrong.  Even better, since this seems to be
x86-centric, put it in kvm_mmu_slot_apply_flags() under the

	if ((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES)

to avoid atomic operations if dirty logging isn't being toggled.  That would also
deal with the NULL pointer issues David pointed out.

>  		}
>  	}
>  
> +	atomic_set(&kvm->nr_logpage_memslots,
> +		   atomic_read(&kvm->nr_logpage_memslots)
> +		   + !!(new->flags & KVM_MEM_LOG_DIRTY_PAGES)
> +		   - !!(old->flags & KVM_MEM_LOG_DIRTY_PAGES));

I belive this can be:

	atomic_add(+ !!(new_flags & KVM_MEM_LOG_DIRTY_PAGES)
		   - !!(old_flags & KVM_MEM_LOG_DIRTY_PAGES), ...);

or less weirdly...

	if ((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES) {
		...

		if (new_flags & KVM_MEM_LOG_DIRTY_PAGES)
			atomic_inc(...);
		else
			atomic_dec(...);
	}
