Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29FC3EBEF2
	for <lists+kvm@lfdr.de>; Sat, 14 Aug 2021 02:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235853AbhHNATr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 20:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235826AbhHNATr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 20:19:47 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3812C0617AD
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 17:19:19 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id b7so14099734plh.7
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 17:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4aBLFRrRApNXp2Xx8CYTjlo6hcEG/5cBNaMQeAv3eCY=;
        b=SEJbD4XN/1eQZ5Jj0HJyzgo2fsUcU26+Ccw7JSV6bCE7DZ5cSMQxngtYapC3m7Olit
         Fc9imgTAb8TIzNxAAUbKhfpt3mTYeDTbaT263DqflC/72BZDoYoWLcW0x8VBWzI8YBsK
         mp+N1zOLKyqPvAhvfDYzivb00mh4mJB1qYmDhINxV7ho32JZfnsjHwx7s9awLlsFllQP
         CfiTO/0qmMbsMF901gjSlq0zpovFHuqmCJ8/UnBKqL0ret1zrGRYCkmYjrMnUAhySBjf
         HxMoXqunFbCff5tPU1EbMkgoMER/nZxk56zQwn+8jUXGQo5NKGZlrB3MMJHTxxfxX+PM
         1Vcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4aBLFRrRApNXp2Xx8CYTjlo6hcEG/5cBNaMQeAv3eCY=;
        b=bQIKZ/37RfnKfjBFm30eAytA4P66DReNjk+pHJ6mWroCSPZ9X11pZQdeWDHf8RLTA8
         Ns2NKwTQFnz0nz2NQ3P7oWa5ARg1zMOippa5gnCenBBgAtu7kLuOsnOWWWx5n4oV6eBV
         3jR9aGO96ZMMcabPzsnb9Gl1IhA1T9zr4KsmEEOzjlZGhYe7k3QDCsl0B0Ax+dhElEF0
         ED9B2fX69DlttCb2T4+joQz1QyG/RM68Ho5J+javRTXsP9ZZb/1cGc/4txqC9SDrEIqb
         cQKERfzUP+YvnunR7Eu2liwhxpg1KHAmnKKb3zIxNANU5n66r5DSmJFFKhD5tjRVxq1z
         RTVQ==
X-Gm-Message-State: AOAM531KAiaiomspKy42uhUtxFB4C0VyLUfuwixTORaY7Zcz4o8eOLtb
        +UPW3r0BXqPsD+kdGZZ7hBRX6Q==
X-Google-Smtp-Source: ABdhPJx+qtJhG7LoXzOWAi6WKgmKRuA4EACWIk6g64RLWo4z+EcrKBh2wjC7PNGmLx3GcPANgXIwSw==
X-Received: by 2002:a17:90a:8801:: with SMTP id s1mr4948837pjn.166.1628900359318;
        Fri, 13 Aug 2021 17:19:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o14sm696044pgl.85.2021.08.13.17.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 17:19:18 -0700 (PDT)
Date:   Sat, 14 Aug 2021 00:19:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v3] KVM: stats: Add VM stat for the cumulative number of
 dirtied pages
Message-ID: <YRcMAXvvI/Kphb5R@google.com>
References: <20210813195433.2555924-1-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813195433.2555924-1-jingzhangos@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 13, 2021, Jing Zhang wrote:
> A per VCPU stat dirtied_pages is added to record the number of dirtied
> pages in the life cycle of a VM.
> The growth rate of this stat is a good indicator during the process of
> live migrations. The exact number of dirty pages at the moment doesn't
> matter. That's why we define dirtied_pages as a cumulative counter instead
> of an instantaneous one.
> 
> Original-by: Peter Feiner <pfeiner@google.com>
> Suggested-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3e67c93ca403..8c673198cc83 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3075,6 +3075,8 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>  			     struct kvm_memory_slot *memslot,
>  		 	     gfn_t gfn)
>  {
> +	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> +
>  	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
>  		unsigned long rel_gfn = gfn - memslot->base_gfn;
>  		u32 slot = (memslot->as_id << 16) | memslot->id;
> @@ -3084,6 +3086,9 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>  					    slot, rel_gfn);
>  		else
>  			set_bit_le(rel_gfn, memslot->dirty_bitmap);
> +
> +		if (vcpu)
> +			++vcpu->stat.generic.dirtied_pages;

I agree with Peter that this is a solution looking for a problem, and the stat is
going to be confusing because it's only active if dirty logging is enabled.

For Oliver's debug use case, it will require userspace to coordinate reaping the
dirty bitmap/ring with the stats, otherwise there's no baseline, e.g. the number
of dirtied pages will scale with how frequently userspace is clearing dirty bits.

At that point, userspace can do the whole thing itself, e.g. with a dirty ring
it's trivial to do "dirtied_pages += ring->dirty_index - ring->reset_index".
The traditional bitmap will be slower, but without additional userspace enabling
the dirty logging dependency means this is mostly limited to live migration being
in-progress.  In that case, something in userspace needs to actually be processing
the dirty pages, it should be easy for that something to keep a running count.
