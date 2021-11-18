Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D2B455F84
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 16:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbhKRPdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 10:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbhKRPdW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 10:33:22 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7913C061574
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 07:30:22 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 200so5656201pga.1
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 07:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O9HW8VN8FD0mQUuNl0O7hTZetbVOFYwSJ/10X1Qi/dg=;
        b=VEz76Ih4++By0aewhJfkfWBIpULKWUjt9W5wyeG7SvksDqYyv5JxzJD1/2Og/sXCTU
         +UyfUDS8aE3KvwbapaaVhBW1vS5K6+twNIGAoLO7unxx80El83rQYjaVCQdXxvRc5FKr
         LWkxvKCVYzZYTFhHaDDwEuISeCmqorOr9eqpUcxXCg5MDCOXXbK47Wzk+cysKVRtrQQN
         lH71xN4vTDYvuZNEeCbuNYwaRRm7Davx2M//PgZR62W5ZQtCXLkqWu5khDmUt/leLeVq
         8GkyjKYNQuBNA1qYuRP8bFb7s93N/Rn4MBj2fMoS/WQrvHWMV4FNFBa/Cq8v7upxnyFI
         fmmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O9HW8VN8FD0mQUuNl0O7hTZetbVOFYwSJ/10X1Qi/dg=;
        b=Kkr7VaZ5art2RfqdC0uK99kzyL80DuEva4mSS24ZX67XlZbMETsW/b3KvFzptkKwBP
         wa+1pndHSQj7BJ7Oyf2wGjEug4eowstQSn4cjrALyyWpWUoEY80HJIIYdkYQxUyMWpcT
         loZ0bKLvAOUmk+Rq0pxHJU18y3PgigNBO0KmDfTCsiL4URGVNbbzx8w5HN71BodyPTE3
         0f/5w2quU3s7DT4p+QBTOfYr94kcFp468BrYk5lRma6Vx2cwlbKDQ/HvZO25GD8j7dIV
         LRHExlXGsFziiE+9b6SDfBhjKDu4Pd5Y0vw6nskxrw2RfC57YDv89c3pOYNCk89k93v3
         NuIA==
X-Gm-Message-State: AOAM531To1Bau7nVfxRBsXqRYbgGE7FpYyVngT9ZxaU9W7zC4ht7g0DZ
        LgCbjs/qgQy4VAB5Sq0klXsscA==
X-Google-Smtp-Source: ABdhPJxfM/6/NQ7XWwirjRlwpSH8CUpTFiWf5wqmIzfCsQcYwXKe1gl7GFrQ9W3s2mRyTtWZX26xgw==
X-Received: by 2002:a63:5813:: with SMTP id m19mr11804373pgb.451.1637249422122;
        Thu, 18 Nov 2021 07:30:22 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u11sm11706pfk.152.2021.11.18.07.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 07:30:21 -0800 (PST)
Date:   Thu, 18 Nov 2021 15:30:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH 11/15] KVM: x86/MMU: Refactor vmx_get_mt_mask
Message-ID: <YZZxivgSeGH4wZnB@google.com>
References: <20211115234603.2908381-1-bgardon@google.com>
 <20211115234603.2908381-12-bgardon@google.com>
 <a1be97c6-6784-fd5f-74a8-85124f039530@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1be97c6-6784-fd5f-74a8-85124f039530@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021, Paolo Bonzini wrote:
> On 11/16/21 00:45, Ben Gardon wrote:
> > Remove the gotos from vmx_get_mt_mask to make it easier to separate out
> > the parts which do not depend on vcpu state.
> > 
> > No functional change intended.
> > 
> > 
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> 
> Queued, thanks (with a slightly edited commit message; the patch is a
> simplification anyway).

Don't know waht message you've queued, but just in case you kept some of the original,
can you further edit it to remove any snippets that mention separating out the parts
that don't depend on vCPU state?

IMO, we should not separate vmx_get_mt_mask() into per-VM and per-vCPU variants,
because the per-vCPU variant is a lie.  The memtype of a SPTE is not tracked anywhere,
which means that if the guest has non-uniform CR0.CD/NW or MTRR settings, KVM will
happily let the guest consumes SPTEs with the incorrect memtype.  In practice, this
isn't an issue because no sane BIOS or kernel uses per-CPU MTRRs, nor do they have
DMA operations running while the cacheability state is in flux.

If we really want to make this state per-vCPU, KVM would need to incorporate the
CR0.CD and MTRR settings in kvm_mmu_page_role.  For MTRRs in particular, the worst
case scenario is that every vCPU has different MTRR settings, which means that
kvm_mmu_page_role would need to be expanded by 10 bits in order to track every
possible vcpu_idx (currently capped at 1024).

So unless we want to massively complicate kvm_mmu_page_role and gfn_track for a
scenario no one cares about, I would strongly prefer to acknowledge that KVM assumes
memtypes are a per-VM property, e.g. on top:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 77f45c005f28..8a84d30f1dbd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6984,8 +6984,9 @@ static int __init vmx_check_processor_compat(void)
        return 0;
 }

-static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+static u64 vmx_get_mt_mask(struct kvm *kvm, gfn_t gfn, bool is_mmio)
 {
+       struct kvm_vcpu *vcpu;
        u8 cache;

        /* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
@@ -7009,11 +7010,15 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
        if (is_mmio)
                return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;

-       if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
+       if (!kvm_arch_has_noncoherent_dma(kvm))
                return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;

+       vcpu = kvm_get_vcpu_by_id(kvm, 0);
+       if (KVM_BUG_ON(!vcpu, kvm))
+               return;
+
        if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
-               if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
+               if (kvm_check_has_quirk(kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
                        cache = MTRR_TYPE_WRBACK;
                else
                        cache = MTRR_TYPE_UNCACHABLE;
