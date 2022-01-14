Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24A548F272
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 23:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiANW33 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 17:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiANW32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 17:29:28 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A5AC061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 14:29:28 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so23591938pjj.2
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 14:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bPFEuJghAq85KSQIR4gB3+T+iHCDYNMGhh4VVUyK1yk=;
        b=iUPTHGiMqWfnxByHl2huCDUaGb0wNP2o2euAlNSouVPbCBZl4XMIh1AmkuMnqjN5eU
         Mt4oDa3xZfyZT4WzXA8Po0PMgvtrv94XnyRXYg19oMQFJJYUQLDN5jrCUPAA5a+W2MsX
         rzClEEKQ6HfrTVUsUbxMjQS9vpJjpMFklAQBTX6n/e+ClCE9jW9J0Wz0KIx1gqUUk6ao
         KvNhZCr9IHKKUNyQvvwtWb0ryNFznfs5+PtZPT4cvhGTPQ0MIzUhZm1qECz9urv7zf4F
         TS22RpHP9YVJ2p2vX+Jq0S/asF+xf02iRSQtsSowdiers4zz65zUMVhPSgwvFhYOtPWC
         mKng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bPFEuJghAq85KSQIR4gB3+T+iHCDYNMGhh4VVUyK1yk=;
        b=vRfyujfDHXIQd4OSLlEqQBCaNDBmgnb4pgSZCIY9Ta89ZWrHXoP+8C0nZJypm4msmN
         L4vzub2da+KftSyVpCbOr9DKWfhTZdsDN8I2N2yedRVLokz7d8qZhvyiT7PNGjP0p+yY
         1O849DGw+N4GsKMGXNNo8hbxVE32Zh1mFugMezWqWcFZJIGch6DBUMbVJZoYTRzXMYec
         gcN7lSFSV6ZSq2zcrQThrdXqsiq1L4MvrfZMQYzz8nHTH4p/VS5xPJMunwHrZhyoQy31
         UCSbrVDJNP0M6JnipaeXxxJaAphu7A94RXeINBUgwfBtQUxnpPoV35IMIficUhkyCG7z
         sWqw==
X-Gm-Message-State: AOAM533fIvHFH634mMXClf9Z8cgyBG0qo2s8cp8RkKndDC/cRd1YwNf4
        crQOde5mANQHDFgeI0rwEk18kIuMuQaMrA==
X-Google-Smtp-Source: ABdhPJx4zcKCPgpeoUwThTveqg+DDRKoEdKndJ5KKNdgJe8TaTFK2C1SxCYDaBBezeMcKSiSeGWMCQ==
X-Received: by 2002:a17:903:11d1:b0:149:57d1:acc6 with SMTP id q17-20020a17090311d100b0014957d1acc6mr11679606plh.134.1642199367284;
        Fri, 14 Jan 2022 14:29:27 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ls7sm647509pjb.54.2022.01.14.14.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 14:29:26 -0800 (PST)
Date:   Fri, 14 Jan 2022 22:29:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/4] KVM: x86/mmu: Document and enforce MMU-writable
 and Host-writable invariants
Message-ID: <YeH5QlwgGcpStZyp@google.com>
References: <20220113233020.3986005-1-dmatlack@google.com>
 <20220113233020.3986005-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113233020.3986005-4-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 13, 2022, David Matlack wrote:
> +/*
> + * *_SPTE_HOST_WRITEABLE (aka Host-writable) indicates whether the host permits
> + * writes to the guest page mapped by the SPTE. This bit is cleared on SPTEs
> + * that map guest pages in read-only memslots and read-only VMAs.
> + *
> + * Invariants:
> + *  - If Host-writable is clear, PT_WRITABLE_MASK must be clear.
> + *
> + *
> + * *_SPTE_MMU_WRITEABLE (aka MMU-writable) indicates whether the shadow MMU
> + * allows writes to the guest page mapped by the SPTE. This bit is cleared when
> + * the guest page mapped by the SPTE contains a page table that is being
> + * monitored for shadow paging. In this case the SPTE can only be made writable
> + * by unsyncing the shadow page under the mmu_lock.
> + *
> + * Invariants:
> + *  - If MMU-writable is clear, PT_WRITABLE_MASK must be clear.
> + *  - If MMU-writable is set, Host-writable must be set.
> + *
> + * If MMU-writable is set, PT_WRITABLE_MASK is normally set but can be cleared
> + * to track writes for dirty logging. For such SPTEs, KVM will locklessly set
> + * PT_WRITABLE_MASK upon the next write from the guest and record the write in
> + * the dirty log (see fast_page_fault()).
> + */
> +
> +/* Bits 9 and 10 are ignored by all non-EPT PTEs. */
> +#define DEFAULT_SPTE_HOST_WRITEABLE	BIT_ULL(9)
> +#define DEFAULT_SPTE_MMU_WRITEABLE	BIT_ULL(10)

Ha, so there's a massive comment above is_writable_pte() that covers a lot of
the same material.  More below.

> +
>  /*
>   * Low ignored bits are at a premium for EPT, use high ignored bits, taking care
>   * to not overlap the A/D type mask or the saved access bits of access-tracked
> @@ -316,8 +341,13 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
>  
>  static inline bool spte_can_locklessly_be_made_writable(u64 spte)
>  {
> -	return (spte & shadow_host_writable_mask) &&
> -	       (spte & shadow_mmu_writable_mask);
> +	if (spte & shadow_mmu_writable_mask) {
> +		WARN_ON_ONCE(!(spte & shadow_host_writable_mask));
> +		return true;
> +	}
> +
> +	WARN_ON_ONCE(spte & PT_WRITABLE_MASK);

I don't like having the WARNs here.  This is a moderately hot path, there are a
decent number of call sites, and the WARNs won't actually help detect the offender,
i.e. whoever wrote the bad SPTE long since got away.

And for whatever reason, I had a hell of a time (correctly) reading the second WARN :-)

Lastly, there's also an "overlapping" WARN in mark_spte_for_access_track().

> +	return false;

To kill a few birds with fewer stones, what if we:

  a. Move is_writable_pte() into spte.h, somewhat close to the HOST/MMU_WRITABLE
     definitions.

  b. Add a new helper, spte_check_writable_invariants(), to enforce that a SPTE
     is WRITABLE iff it's MMU-Writable, and that a SPTE is MMU-Writable iff it's
     HOST-Writable.

  c. Drop the WARN in mark_spte_for_access_track().

  d. Call spte_check_writable_invariants() when setting SPTEs.

  e. Document everything in a comment above spte_check_writable_invariants().
