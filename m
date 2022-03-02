Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440074CACCD
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244360AbiCBSC2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244343AbiCBSC1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:02:27 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6979D5DF1
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 10:01:43 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id z11so2233441pla.7
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 10:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ghxvLbBxxsI2q0Cumn+E+luGTHcGT5EcvSoKD1OR3J0=;
        b=sbLwc5+sUDMIWQaaab5ASuqK4VJmVcHXfJzDA7SnzHIfpBy+SgPHkUhqad229M2hxH
         uLlasaR5Y9jZsx0l1BfLCjnsWgm8ABD9vAwWuuR2RTBQCDksz9WzVu6MhqIfDhIqXbpb
         Hcyvl37b2ZTxrF/rWsOGCVV79fWH+49MIEfFco92Ad+TmOPBceolsKrAFKJIjj6exGPk
         7iuPehBZ7viSl9PzGFsCsm2f9PDDov++kJF0xh+BmSsKJRCfSvusFZr3067tkN0bvbYY
         uXOar6+SPDePmTWCAEk/1R3R8dWoyRKxKpViH3zkuDJdatJ+P1lrzR+QkZ9OqhUph3zI
         JenA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ghxvLbBxxsI2q0Cumn+E+luGTHcGT5EcvSoKD1OR3J0=;
        b=OFWtmOGUTtV938TOFcNh374Yiox4m5vk1ptz/3UTe4zqU/SILQLl0QHpwRMCdtqFnp
         UBhRy5rPPcs6JTzrUe9Za+zu8oPHtNCWuwA/O7tJOPCR3P4FHKsH0lAYJy2w+8j/NKOb
         cLppvf9h3pAJktrtwQCTy4/sA2eQ210ItcRwu5kenm4CfEaTRU+Vo/w6No1m7Voi1Y0x
         RZFD46RyzMvVzCwpZH9UoeSkXVTyeb6DAiEHxdhwvswBYtgk5ndhPpyHwzK05Q6+/F5A
         8fJwBVp4csDn57iaOkZiCcsjfN11Iqq3bqKFS0ySje81FMbDWz5JMJwgENnw6gBkI7km
         Tc/A==
X-Gm-Message-State: AOAM531QYheZP7QcnflUU3OReCw6XJfjFVq9Duqk3A2Lt4EjmdKEgDO0
        5I/IWkCx20vuJh7aXxDrB+o4lw==
X-Google-Smtp-Source: ABdhPJzz/d72FZYh+K2pIp31FS88zIIWQF1AKDPlKc2QSTZS5hbm3PiGLvfsb34ZAkubGz0R5FnCXA==
X-Received: by 2002:a17:90b:4b0d:b0:1bc:4cdb:ebe3 with SMTP id lx13-20020a17090b4b0d00b001bc4cdbebe3mr1008662pjb.176.1646244103075;
        Wed, 02 Mar 2022 10:01:43 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c72-20020a624e4b000000b004f3ff3a3fb2sm13157960pfb.118.2022.03.02.10.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 10:01:42 -0800 (PST)
Date:   Wed, 2 Mar 2022 18:01:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v3 22/28] KVM: x86/mmu: Zap defunct roots via
 asynchronous worker
Message-ID: <Yh+xA31FrfGoxXLB@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-23-seanjc@google.com>
 <b9270432-4ee8-be8e-8aa1-4b09992f82b8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9270432-4ee8-be8e-8aa1-4b09992f82b8@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022, Paolo Bonzini wrote:
> On 2/26/22 01:15, Sean Christopherson wrote:
> > Zap defunct roots, a.k.a. roots that have been invalidated after their
> > last reference was initially dropped, asynchronously via the system work
> > queue instead of forcing the work upon the unfortunate task that happened
> > to drop the last reference.
> > 
> > If a vCPU task drops the last reference, the vCPU is effectively blocked
> > by the host for the entire duration of the zap.  If the root being zapped
> > happens be fully populated with 4kb leaf SPTEs, e.g. due to dirty logging
> > being active, the zap can take several hundred seconds.  Unsurprisingly,
> > most guests are unhappy if a vCPU disappears for hundreds of seconds.
> > 
> > E.g. running a synthetic selftest that triggers a vCPU root zap with
> > ~64tb of guest memory and 4kb SPTEs blocks the vCPU for 900+ seconds.
> > Offloading the zap to a worker drops the block time to <100ms.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> 
> Do we even need kvm_tdp_mmu_zap_invalidated_roots() now?  That is,
> something like the following:

Nice!  I initially did something similar (moving invalidated roots to a separate
list), but never circled back to idea after implementing the worker stuff.

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index bd3625a875ef..5fd8bc858c6f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5698,6 +5698,16 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>  {
>  	lockdep_assert_held(&kvm->slots_lock);
> +	/*
> +	 * kvm_tdp_mmu_invalidate_all_roots() needs a nonzero reference
> +	 * count.  If we're dying, zap everything as it's going to happen
> +	 * soon anyway.
> +	 */
> +	if (!refcount_read(&kvm->users_count)) {
> +		kvm_mmu_zap_all(kvm);
> +		return;
> +	}

I'd prefer we make this an assertion and shove this logic to set_nx_huge_pages(),
because in that case there's no need to zap anything, the guest can never run
again.  E.g. (I'm trying to remember why I didn't do this before...)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b2c1c4eb6007..d4d25ab88ae7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6132,7 +6132,8 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 
                list_for_each_entry(kvm, &vm_list, vm_list) {
                        mutex_lock(&kvm->slots_lock);
-                       kvm_mmu_zap_all_fast(kvm);
+                       if (refcount_read(&kvm->users_count))
+                               kvm_mmu_zap_all_fast(kvm);
                        mutex_unlock(&kvm->slots_lock);
 
                        wake_up_process(kvm->arch.nx_lpage_recovery_thread);


> +
>  	write_lock(&kvm->mmu_lock);
>  	trace_kvm_mmu_zap_all_fast(kvm);
> @@ -5732,20 +5742,6 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>  	kvm_zap_obsolete_pages(kvm);
>  	write_unlock(&kvm->mmu_lock);
> -
> -	/*
> -	 * Zap the invalidated TDP MMU roots, all SPTEs must be dropped before
> -	 * returning to the caller, e.g. if the zap is in response to a memslot
> -	 * deletion, mmu_notifier callbacks will be unable to reach the SPTEs
> -	 * associated with the deleted memslot once the update completes, and
> -	 * Deferring the zap until the final reference to the root is put would
> -	 * lead to use-after-free.
> -	 */
> -	if (is_tdp_mmu_enabled(kvm)) {
> -		read_lock(&kvm->mmu_lock);
> -		kvm_tdp_mmu_zap_invalidated_roots(kvm);
> -		read_unlock(&kvm->mmu_lock);
> -	}
>  }
>  static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index cd1bf68e7511..af9db5b8f713 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -142,10 +142,12 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  	WARN_ON(!root->tdp_mmu_page);
>  	/*
> -	 * The root now has refcount=0 and is valid.  Readers cannot acquire
> -	 * a reference to it (they all visit valid roots only, except for
> -	 * kvm_tdp_mmu_zap_invalidated_roots() which however does not acquire
> -	 * any reference itself.
> +	 * The root now has refcount=0.  It is valid, but readers already
> +	 * cannot acquire a reference to it because kvm_tdp_mmu_get_root()
> +	 * rejects it.  This remains true for the rest of the execution
> +	 * of this function, because readers visit valid roots only

One thing that keeps tripping me up is the "readers" verbiage.  I get confused
because taking mmu_lock for read vs. write doesn't really have anything to do with
reading or writing state, e.g. "readers" still write SPTEs, and so I keep thinking
"readers" means anything iterating over the set of roots.  Not sure if there's a
shorthand that won't be confusing.

> +	 * (except for tdp_mmu_zap_root_work(), which however operates only
> +	 * on one specific root and does not acquire any reference itself).
> 
>  	 *
>  	 * Even though there are flows that need to visit all roots for
>  	 * correctness, they all take mmu_lock for write, so they cannot yet

...

> It passes a smoke test, and also resolves the debate on the fate of patch 1.

+1000, I love this approach.  Do you want me to work on a v3, or shall I let you
have the honors?
