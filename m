Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366CB37AFE9
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 22:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhEKUE2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 16:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbhEKUE1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 16:04:27 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7BEC061574
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 13:03:19 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id g24so12278529pji.4
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 13:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aFa9eJIskol9erfOZLkvXwFKtvp+EqqmqlvTxyINBHA=;
        b=HnZ/XDQ2sFxXpGSN+sual0eelIiN/Cusckbtlsbq8QA34pcnEKkLzsw+VtdPkRa9PC
         A2ZzajXyJ1p6t/u02xKjS7M6doRoGAk4n234NeAoXanOE+2B6c6Qsc5sFYUIfC5Lzfwv
         33L3vgEyoJTmTE4Y9a93OeSN/5O0IT5TMiCAfk2cshtpKVKXt/xgz16zj/OoakkFUDL1
         lwYk1VKu6sExrBA5dZZ1izSd0Wsa2KIKE4lQ1ACZub72ZwvdOux6w+vSFdK2GtfiifT3
         YbWGUgSmmB0neEsg9S29OWlQZnbapJaz0y6mHGkgQx9EVxYzkzRIxLUX67VkJ+wDKXTx
         FgoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aFa9eJIskol9erfOZLkvXwFKtvp+EqqmqlvTxyINBHA=;
        b=sTn7jPzuWxADsCFawUgYOQ37crxo3xiDUQeq6lm0DsN6KBlMqPdFe5Bcy1WKdy318Q
         TQzfJN5C6dFaer6/GIiDzW8U9t2cYbkNfZJ+dGeUfXjqMDJ91nWaoq4P7bVbCoGyxoN5
         KNtzOxxhYzrw+4w5x2QJS02tPitS6A9WURhYeF7aHJOpuMMhNZZ/HbD1rko0F4B/srKm
         1HDxIyQ96qZbmyrUPuciUxW0DJi2O9N0Mew5I+1mFZgczEex0xME6+R9NZkL8qzIkicL
         8Xwj8lzzN/W/YZWJvjOvOWiikn7fWQwHCTdWRFk5zMLKxO2jiIsd4R5TrremuwJRzVWh
         6Dtg==
X-Gm-Message-State: AOAM532Vf/awFX6MaF1T9AEDjVQ6C9kHIef4bWMY6px+JqceMfCL0Atg
        DCg3NkBp8wJsmeQD+GPMaNiKNQ==
X-Google-Smtp-Source: ABdhPJyQ1H7KcFFHpjwDC5FXdMYIXQY1u4Bq9L6cTkHq11ClTnoNaBYw0jpserk/YfuAnBeVWwCwIA==
X-Received: by 2002:a17:902:ed95:b029:ee:aa46:547a with SMTP id e21-20020a170902ed95b02900eeaa46547amr31330084plj.27.1620763399188;
        Tue, 11 May 2021 13:03:19 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id o10sm6571132pjl.2.2021.05.11.13.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 13:03:18 -0700 (PDT)
Date:   Tue, 11 May 2021 20:03:14 +0000
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
Subject: Re: [PATCH v4 7/7] KVM: x86/mmu: Lazily allocate memslot rmaps
Message-ID: <YJrjAt5eyCZQNSkM@google.com>
References: <20210511171610.170160-1-bgardon@google.com>
 <20210511171610.170160-8-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511171610.170160-8-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021, Ben Gardon wrote:
> If the TDP MMU is in use, wait to allocate the rmaps until the shadow
> MMU is actually used. (i.e. a nested VM is launched.) This saves memory
> equal to 0.2% of guest memory in cases where the TDP MMU is used and
> there are no nested guests involved.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/mmu/mmu.c          | 53 +++++++++++++++++++++++----------
>  arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++--
>  arch/x86/kvm/mmu/tdp_mmu.h      |  4 +--
>  arch/x86/kvm/x86.c              | 45 +++++++++++++++++++++++++++-
>  5 files changed, 89 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index fc75ed49bfee..7b65f82ade1c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1868,4 +1868,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
>  
>  int kvm_cpu_dirty_log_size(void);
>  
> +int alloc_all_memslots_rmaps(struct kvm *kvm);
> +
>  #endif /* _ASM_X86_KVM_HOST_H */
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b0bdb924d519..183afccd2944 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1190,7 +1190,8 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
>  		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
>  				slot->base_gfn + gfn_offset, mask, true);
>  
> -	if (!kvm->arch.memslots_have_rmaps)
> +	/* Read memslots_have_rmaps before the rmaps themselves */

IIRC, you open coded reading memslots_have_rmaps because of a circular
dependency, but you can solve that simply by defining the helper in mmu.h
instead of kvm_host.h.

And I think you could even make it static in mmu.c and omit the smp_load_acuquire
from the three users in x86.c, though that's probably not worth it.

Either way, reading the same comment over and over and over, just to make
checkpatch happy, gets more than a bit tedious.

That would also allow you to elaborate on why the smp_load_acquire() is
necessary, and preferably what it pairs with.

> +	if (!smp_load_acquire(&kvm->arch.memslots_have_rmaps))
>  		return;
>  
>  	while (mask) {
