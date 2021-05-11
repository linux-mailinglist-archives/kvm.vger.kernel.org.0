Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222A637AEF1
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 20:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhEKS7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 14:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbhEKS7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 14:59:08 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC61C061574
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 11:58:00 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id t2-20020a17090ae502b029015b0fbfbc50so58225pjy.3
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 11:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oLyk2sgqTL5Vn/TKBovsUc1DwhBNmb78942+z6JgkFk=;
        b=VY6g8j2sEMXzCcSYW74rKGa5U9UpB5xe1yY6CRFpyuD+pNCkDDeO/JH1RtSF5Y95nj
         RdJmSVGXGoMyYryeRQbkzfdhDP4t5I+3HP1mS/q7QAOlf/c/BRPjh7W0W/xupnLY1dDm
         PNCG4m8kYULgCDgLwXOVeL3u3G16aj/oYDP18LOVCWPKVOPzC9usudGj47t3Gq7HWSAb
         Kq6TyFmTIMe8IaMVps9eNuO1Fm4P3qaA2fGyXN8R7KQHVuPwy5m7YKRL6/t6Kr5GOkre
         W7NXOvr7qgk4wOqGu8fOHfjDVlaJd1MsbKI5PEUHix5HRh7m3ZTpydWrxiQcD+R3sVuY
         A1bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oLyk2sgqTL5Vn/TKBovsUc1DwhBNmb78942+z6JgkFk=;
        b=MuB0bGLjZr94RskP1XuR3O4q+3daRZO8Xi8izNVJOtJfW+iAoBK1wt4+aSRbhFy7ab
         FgO/YNudI25C8kP/3XbdpRpNQrz32HK7G4zcLiQ+luaplo8JV2cjJLrqWi9GZspJJG1q
         hrpeoJFbABtaD4CCnMDfekylU+8WT0oSqrQY6E1kFzppxU5QhxtQX/IIQSPA3hiqct2S
         VudLQyK9a6YJDoyprT9hzXhG7/IQ9a+VSawY/AKMVJx0219Ta7d3PGSWNd2KJpiTfOsS
         rOoM/7qWHtS/JTlYWj5QpGtlhXyn62CxDI7QRcqpW+4n2U22Yk9J/RYSkKMweiOiERtu
         0tqA==
X-Gm-Message-State: AOAM533zQ7cYSrzCHuOlQ+WYJ/O7tyaUPvvMy24AzPnAImOqIANSK9Kx
        FBzHnH37asJLa7TpGwZW0tDExg==
X-Google-Smtp-Source: ABdhPJxOmU8XVtfPkJEbrBQRMNcmKDLmTjhnp407EL2ZJE/UpgkfYOAaR51m44vi5Yh8cmWDEsb79Q==
X-Received: by 2002:a17:902:e986:b029:ee:d430:6bf9 with SMTP id f6-20020a170902e986b02900eed4306bf9mr31780254plb.0.1620759479901;
        Tue, 11 May 2021 11:57:59 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 130sm13473105pfy.75.2021.05.11.11.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 11:57:59 -0700 (PDT)
Date:   Tue, 11 May 2021 18:57:55 +0000
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
Message-ID: <YJrTs6LlHFWSdGc7@google.com>
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
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> @@ -10935,6 +10937,46 @@ static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
>  	return 0;
>  }
>  
> +int alloc_all_memslots_rmaps(struct kvm *kvm)
> +{
> +	struct kvm_memslots *slots;
> +	struct kvm_memory_slot *slot;
> +	int r = 0;

No need to initialize r.  And then it makes sense to put i and r on the same
line.

> +	int i;
> +
> +	/*
> +	 * Check memslots_have_rmaps early before acquiring the
> +	 * slots_arch_lock below.
> +	 */
> +	if (smp_load_acquire(&kvm->arch.memslots_have_rmaps))
> +		return 0;
> +
> +	mutex_lock(&kvm->slots_arch_lock);
> +
> +	/*
> +	 * Read memslots_have_rmaps again, under the slots arch lock,
> +	 * before allocating the rmaps
> +	 */
> +	if (smp_load_acquire(&kvm->arch.memslots_have_rmaps))
> +		return 0;

This fails to drop slots_arch_lock.

> +
> +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +		slots = __kvm_memslots(kvm, i);
> +		kvm_for_each_memslot(slot, slots) {
> +			r = memslot_rmap_alloc(slot, slot->npages);
> +			if (r) {
> +				mutex_unlock(&kvm->slots_arch_lock);
> +				return r;
> +			}
> +		}
> +	}
> +
> +	/* Write rmap pointers before memslots_have_rmaps */
> +	smp_store_release(&kvm->arch.memslots_have_rmaps, true);
> +	mutex_unlock(&kvm->slots_arch_lock);
> +	return 0;
> +}
> +
>  static int kvm_alloc_memslot_metadata(struct kvm *kvm,
>  				      struct kvm_memory_slot *slot,
>  				      unsigned long npages)
> @@ -10949,7 +10991,8 @@ static int kvm_alloc_memslot_metadata(struct kvm *kvm,
>  	 */
>  	memset(&slot->arch, 0, sizeof(slot->arch));
>  
> -	if (kvm->arch.memslots_have_rmaps) {
> +	/* Read memslots_have_rmaps before allocating the rmaps */
> +	if (smp_load_acquire(&kvm->arch.memslots_have_rmaps)) {
>  		r = memslot_rmap_alloc(slot, npages);
>  		if (r)
>  			return r;
> -- 
> 2.31.1.607.g51e8a6a459-goog
> 
