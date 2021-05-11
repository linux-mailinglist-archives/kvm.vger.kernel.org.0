Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C75A37AEA0
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 20:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbhEKSse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 14:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbhEKSsc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 14:48:32 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14734C061574
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 11:47:24 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id t2-20020a17090ae502b029015b0fbfbc50so41991pjy.3
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 11:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PUfD2hUn3KDMj/HYtm6y3Z3XD5hUc0CS8SfLuKj/HzM=;
        b=hH8iZ5uGg4DljK1HEHhLdreVMW5K51visxVgKumGRH38RbTsi3BTytZLhStmDbQ4uF
         h53yWZqjuULTlImML+ZiT0MVhbrfviY0KnVR1MipAvU43rvHh4Y/1CpvF9jVlxa8d2hN
         6KtOwEmXbdzHxwnpQ0Z5c49tNpWvzrZ2Fpj89ALnnKjQIqQcUzC6JktdGHwnSo1n7AA3
         UHVT8j6ckH6x3ZPtj0xzBxA1kTk4wd7ASvHx8CgzuqGj9M8CjfT+cQJKfKg08r22Zs84
         wqowq7p7x6pBqe4YACHao4OBFlFrFjh/1qycJKCDQzomPgmoKBhMyjhhCTaH9q/UHq85
         Nxow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PUfD2hUn3KDMj/HYtm6y3Z3XD5hUc0CS8SfLuKj/HzM=;
        b=pJxiH+ukfmWCbWeLVtGfT4P7wCQALlrK5sUEdsDaOp5x5b58t5uinRtNgJe6diJ8rM
         2Lk/YJYja3ysgitnRdIpoiGrHsp/rFzpWZXzVP7cjPaavqaJRLuLAqilsucEp3Ay0sZb
         gEH6rOmGIeX9xGie5hdSMpmTfu0ydtOLJiWly0Kee9Uy6qExaZXJCtKS59S9TJUU0u3w
         vUvD3bSCKvJmhVBwvfBzmCsgTcJLa2lxwOarPdmwa1iHCWCpjCsDDOo1yh5sdAVWWuRN
         213uFBpvK62PLJWkUzp7j8Twg7+nwTdGSwA5ElWV5Iezw9C1rML7MpfKyahrcK49eBb6
         N10w==
X-Gm-Message-State: AOAM533AVjAwXA9C9Q6hveIatpsVeOtNVzOoffRX2Qdq0j8LnTsIMbLW
        90ri8Vw9KY6ubicquzx3TqOhbQ==
X-Google-Smtp-Source: ABdhPJyJXjVPc7O99wKXfMTd5Ucm7ji44HBjrPgZP13aR2e1NJRgR8Tywj+LrdHY+pCgd3ONM6a+ug==
X-Received: by 2002:a17:90a:390d:: with SMTP id y13mr9283273pjb.52.1620758843332;
        Tue, 11 May 2021 11:47:23 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id i8sm7089806pgt.58.2021.05.11.11.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 11:47:22 -0700 (PDT)
Date:   Tue, 11 May 2021 18:47:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v4 3/7] KVM: mmu: Refactor memslot copy
Message-ID: <YJrRN2S3EJI/S01o@google.com>
References: <20210511171610.170160-1-bgardon@google.com>
 <20210511171610.170160-4-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511171610.170160-4-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021, Ben Gardon wrote:
> Factor out copying kvm_memslots from allocating the memory for new ones
> in preparation for adding a new lock to protect the arch-specific fields
> of the memslots.
> 
> No functional change intended.
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  virt/kvm/kvm_main.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6b4feb92dc79..9e106742b388 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1306,6 +1306,18 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
>  	return old_memslots;
>  }
>  
> +static size_t kvm_memslots_size(int slots)

Can we call this kvm_calc_memslots_size()?  This doesn't actually return the
true size of a given memslots instance since the allocated size may be greater
than the size computed by looking at used_slots.

> +{
> +	return sizeof(struct kvm_memslots) +
> +	       (sizeof(struct kvm_memory_slot) * slots);
> +}
> +
> +static void kvm_copy_memslots(struct kvm_memslots *from,
> +			      struct kvm_memslots *to)
> +{
> +	memcpy(to, from, kvm_memslots_size(from->used_slots));
> +}
> +
>  /*
>   * Note, at a minimum, the current number of used slots must be allocated, even
>   * when deleting a memslot, as we need a complete duplicate of the memslots for
> @@ -1315,19 +1327,16 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
>  					     enum kvm_mr_change change)
>  {
>  	struct kvm_memslots *slots;
> -	size_t old_size, new_size;
> -
> -	old_size = sizeof(struct kvm_memslots) +
> -		   (sizeof(struct kvm_memory_slot) * old->used_slots);
> +	size_t new_size;
>  
>  	if (change == KVM_MR_CREATE)
> -		new_size = old_size + sizeof(struct kvm_memory_slot);
> +		new_size = kvm_memslots_size(old->used_slots + 1);
>  	else
> -		new_size = old_size;
> +		new_size = kvm_memslots_size(old->used_slots);
>  
>  	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
>  	if (likely(slots))
> -		memcpy(slots, old, old_size);
> +		kvm_copy_memslots(old, slots);
>  
>  	return slots;
>  }
> -- 
> 2.31.1.607.g51e8a6a459-goog
> 
