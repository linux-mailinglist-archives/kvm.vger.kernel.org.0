Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D0E37AEDE
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 20:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbhEKS4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 14:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbhEKS4s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 14:56:48 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25820C06174A
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 11:55:42 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id i14so16425441pgk.5
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 11:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6CV/Ogv2k+2pDmDGhqvW2m8g2EESP7gyWTlebIXjFfA=;
        b=LokGQ/5F+E/QlHM7wtqfs3lxNKOPqpwSPZ1fAcNxJtSUTegVrsoke3T5wOEAgFpV8c
         pljKlJUuyXV/a1iKdeMuO5NGSokbEAEYY1G1AWNDbNF6wBLurD5SWhztTiIM53c0vanl
         wbJ7Cporb4a5VkZBNI3pRcWSQhRIzFF3lMGAVsBV7ifdvZN200uAGrWx5Fb28nhordUk
         azaHGbCizKsUe+bmcZd0wyApPKoLfPQJJd9FwxcibnVAsHSNhKQ0Qa57ZiDhw5Km9jE0
         jxWRWJuaduVQABk7jSrTmIlbSb3wS+pf5P+gp9thLBaemgJ7pgOyuMf62Og38y1nSHQi
         S9ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6CV/Ogv2k+2pDmDGhqvW2m8g2EESP7gyWTlebIXjFfA=;
        b=lKQvoSqGSYENLIdFWto2pvgFoAfTqDr7TMLjx5ksbSdCVtM9zryId73t4EYpew0J5q
         FE4t97uSkSy2xA2nBPY+DGIQM7KR3BphE/cgTgZHogtNdbxCjg4ND4AMmBCyHz2c0oqR
         boyMcGiSfTHTUeXqpzcUlauPtiCjnOkczFYxFvDtcPFwIe/AwGhtds9Tj3Tbg/xcGTdI
         jF3H9J7BUKQMQfwuRbFKhENkwXwRwb+ejDXqup+IULvYtL4RT/6Ri052L0QLLPsHoEnF
         Po9RZgCukXCg3kmp1jdkdDY/Myo7/w5tNM8PeacUNAZ3QONJW+Vr/MB7DBKTLgC4ipmI
         TN+Q==
X-Gm-Message-State: AOAM530HDp/D9gH4TY8cw7vxDZRp4DeKgeOVzXfpase/5HcgJQ8SiykM
        Rcf33gt9oJuj1XYPUSAgZe0yClqukZSkMg==
X-Google-Smtp-Source: ABdhPJzhJ/zdjZK416WtYXbwx5B97N0n976eoJV1tj2ZwV5gfKrg6ysVL2Ot9/jO1G94JH789tfn2g==
X-Received: by 2002:a62:2901:0:b029:28e:ef3d:10d2 with SMTP id p1-20020a6229010000b029028eef3d10d2mr30934510pfp.45.1620759341453;
        Tue, 11 May 2021 11:55:41 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id w81sm14021632pfc.106.2021.05.11.11.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 11:55:40 -0700 (PDT)
Date:   Tue, 11 May 2021 18:55:37 +0000
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
Subject: Re: [PATCH v4 4/7] KVM: mmu: Add slots_arch_lock for memslot arch
 fields
Message-ID: <YJrTKWAIanZsjAW6@google.com>
References: <20210511171610.170160-1-bgardon@google.com>
 <20210511171610.170160-5-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511171610.170160-5-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021, Ben Gardon wrote:
> Add a new lock to protect the arch-specific fields of memslots if they
> need to be modified in a kvm->srcu read critical section. A future
> commit will use this lock to lazily allocate memslot rmaps for x86.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  include/linux/kvm_host.h |  9 +++++++++
>  virt/kvm/kvm_main.c      | 31 ++++++++++++++++++++++++++-----
>  2 files changed, 35 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8895b95b6a22..2d5e797fbb08 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -472,6 +472,15 @@ struct kvm {
>  #endif /* KVM_HAVE_MMU_RWLOCK */
>  
>  	struct mutex slots_lock;
> +
> +	/*
> +	 * Protects the arch-specific fields of struct kvm_memory_slots in
> +	 * use by the VM. To be used under the slots_lock (above) or in a
> +	 * kvm->srcu read cirtical section where acquiring the slots_lock
                          ^^^^^^^^
			  critical

> +	 * would lead to deadlock with the synchronize_srcu in
> +	 * install_new_memslots.
> +	 */
> +	struct mutex slots_arch_lock;
>  	struct mm_struct *mm; /* userspace tied to this vm */
>  	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
>  	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
