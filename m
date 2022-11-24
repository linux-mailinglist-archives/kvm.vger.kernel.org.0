Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136BC636EF2
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 01:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiKXAcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 19:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiKXAcV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 19:32:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D385D2282
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 16:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669249886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HW0SsKqsSfPTSALmTnLO0XxNE81N4O12zVHgCNUXDa4=;
        b=h0vgrC73isC9a660zfdjIQlACuh3+PXcePx5aBnDeCZtBQmTxXk6UfoVCf9Ul3ofgJj6le
        tzyWECOx3g47mZnt3khuIyqnEtlbMfxb3GFGotVHSsgUNrbDZ9/m6Wy8b++6/hTYFDugiU
        8kf2YHpK7TtxdPwDKKiVIOSAhYDoFPo=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-377-jX8x_wIbOS6E5C1PATt40g-1; Wed, 23 Nov 2022 19:31:24 -0500
X-MC-Unique: jX8x_wIbOS6E5C1PATt40g-1
Received: by mail-ua1-f72.google.com with SMTP id c1-20020a9f3d81000000b00418b667e367so159453uai.0
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 16:31:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HW0SsKqsSfPTSALmTnLO0XxNE81N4O12zVHgCNUXDa4=;
        b=2B3VyIpZX5HE6GsXyITUkWGY8TqERs23HzRkqtX8DMh+5qCXxNKROb6AYlqWEXQl1Z
         4gWVr3NfC3mtGStGAceErH3dM1ijg82E3HPt+kOK26TQvAYVhrLvUDpfrj/8rBFw7Ynn
         Bu2E7dMgpHBt6VrLoOomQQgOwzTVZnpfnRJoHDH3yQ8zfxB8GutsjUbppxDEgRpc/aPn
         YOrzi0LTC0Fx0J7q6P56nSTTBEmWKdXIsiYIIYNacmLRq8VkGB3P9Hxba+cb/4QMv8UI
         mFyQwIoD0iN1WH1SMDougcEG2qn+KaPwJDQP0aRAYLEEQ3Ufh/WHr8dwtkiGAKi0wNG6
         KJ7A==
X-Gm-Message-State: ANoB5pnml1zEw4n4LCwPyeMhmq3rWAEZK6aJeboKHK0V+irNFBfKtUSl
        WDSbTRMiN8rvvyyWrJZTwliBcrrzA0uc9t93MosHsv8WF0nVjAqSxoI9OuM6G647yk6tM5I4CCm
        eJvdP7ivcIWLzlKRTCEZe8b97LnJ8
X-Received: by 2002:ab0:7286:0:b0:418:455f:2e94 with SMTP id w6-20020ab07286000000b00418455f2e94mr7215001uao.75.1669249883510;
        Wed, 23 Nov 2022 16:31:23 -0800 (PST)
X-Google-Smtp-Source: AA0mqf74waqSZ98OmqTb7CB/lkP2wgxp3ddFMaUZqbJmBWtMWqXLC9xo2fOwolV8HO5gNFmiy8a9gN7lm3ev5HKHCeA=
X-Received: by 2002:ab0:7286:0:b0:418:455f:2e94 with SMTP id
 w6-20020ab07286000000b00418455f2e94mr7214991uao.75.1669249883120; Wed, 23 Nov
 2022 16:31:23 -0800 (PST)
MIME-Version: 1.0
References: <20221119094659.11868-1-dwmw2@infradead.org> <20221119094659.11868-3-dwmw2@infradead.org>
 <681cf1b4edf04563bba651efb854e77f@amazon.co.uk> <Y3z3ZVoXXGWusfyj@google.com>
 <d7ae4bab-e826-ad0f-7248-81574a5f2b5c@gmail.com> <c552b55c926d8e284ba24773a02ea7da028787f5.camel@infradead.org>
In-Reply-To: <c552b55c926d8e284ba24773a02ea7da028787f5.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 24 Nov 2022 01:31:11 +0100
Message-ID: <CABgObfY=jePpPmZJVLdA7nyuPut7B7qCYA64UVwGFxPsmvAVqg@mail.gmail.com>
Subject: Re: [PATCH 3/4] KVM: Update gfn_to_pfn_cache khva when it moves
 within the same page
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paul Durrant <xadimgnik@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        "Durrant, Paul" <pdurrant@amazon.co.uk>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mhal@rbox.co" <mhal@rbox.co>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 22, 2022 at 6:25 PM David Woodhouse <dwmw2@infradead.org> wrote:
>
> On Tue, 2022-11-22 at 16:49 +0000, Paul Durrant wrote:
> > > Tags need your real name, not just your email address, i.e. this should be:
> > >     Reviewed-by: Paul Durrant <paul@xen.org>
> >
> > Yes indeed it should. Don't know how I managed to screw that up... It's
> > not like haven't type that properly hundreds of times on Xen patch reviews.
>
> All sorted in the tree I'm curating
> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/gpc-fixes
>
> Of those, three are marked as Cc:stable and want to go into the 6.1 release:
>
>       KVM: x86/xen: Validate port number in SCHEDOP_poll
>       KVM: x86/xen: Only do in-kernel acceleration of hypercalls for guest CPL0
>       KVM: Update gfn_to_pfn_cache khva when it moves within the same page
>
> The rest (including the runstate compatibility fixes) are less
> critical.

I have picked them into both kvm/master and kvm/queue.

The gpc series probably will be left for 6.3. I had already removed Sean's
bits for the gpc and will rebase on top of your runstate compatibility fixes,
which I'm cherry-picking into kvm/queue.

But wow, is that runstate compatibility patch ugly.  Is it really worth it
having the two separate update paths, one which is ugly because of
BUILD_BUG_ON assertions and one which is ugly because of the
two-page stuff?

Like this (sorry about any word-wrapping, I'll repost it properly
after testing):

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index b246decb53a9..873a0ded3822 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -205,7 +205,7 @@ static void kvm_xen_update_runstate_guest(struct
kvm_vcpu *v, bool atomic)
 #ifdef CONFIG_X86_64
         /*
          * Don't leak kernel memory through the padding in the 64-bit
-         * struct if we take the split-page path.
+         * struct.
          */
         memset(&rs, 0, offsetof(struct vcpu_runstate_info, state_entry_time));
 #endif
@@ -251,83 +251,6 @@ static void kvm_xen_update_runstate_guest(struct
kvm_vcpu *v, bool atomic)
         read_lock_irqsave(&gpc1->lock, flags);
     }

-    /*
-     * The common case is that it all fits on a page and we can
-     * just do it the simple way.
-     */
-    if (likely(!user_len2)) {
-        /*
-         * We use 'int *user_state' to point to the state field, and
-         * 'u64 *user_times' for runstate_entry_time. So the actual
-         * array of time[] in each state starts at user_times[1].
-         */
-        int *user_state = gpc1->khva;
-        u64 *user_times = gpc1->khva + times_ofs;
-
-        /*
-         * The XEN_RUNSTATE_UPDATE bit is the top bit of the state_entry_time
-         * field. We need to set it (and write-barrier) before writing to the
-         * the rest of the structure, and clear it last. Just as Xen does, we
-         * address the single *byte* in which it resides because it might be
-         * in a different cache line to the rest of the 64-bit word, due to
-         * the (lack of) alignment constraints.
-         */
-        BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info,
state_entry_time) !=
-                 sizeof(uint64_t));
-        BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info,
state_entry_time) !=
-                 sizeof(uint64_t));
-        BUILD_BUG_ON((XEN_RUNSTATE_UPDATE >> 56) != 0x80);
-
-        update_bit = ((u8 *)(&user_times[1])) - 1;
-        *update_bit = (vx->runstate_entry_time | XEN_RUNSTATE_UPDATE) >> 56;
-        smp_wmb();
-
-        /*
-         * Next, write the new runstate. This is in the *same* place
-         * for 32-bit and 64-bit guests, asserted here for paranoia.
-         */
-        BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=
-                 offsetof(struct compat_vcpu_runstate_info, state));
-        BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state) !=
-                 sizeof(vx->current_runstate));
-        BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state) !=
-                 sizeof(vx->current_runstate));
-        *user_state = vx->current_runstate;
-
-        /*
-         * Then the actual runstate_entry_time (with the UPDATE bit
-         * still set).
-         */
-        *user_times = vx->runstate_entry_time | XEN_RUNSTATE_UPDATE;
-
-        /*
-         * Write the actual runstate times immediately after the
-         * runstate_entry_time.
-         */
-        BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
-                 offsetof(struct vcpu_runstate_info, time) - sizeof(u64));
-        BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info,
state_entry_time) !=
-                 offsetof(struct compat_vcpu_runstate_info, time) -
sizeof(u64));
-        BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
-                 sizeof_field(struct compat_vcpu_runstate_info, time));
-        BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
-                 sizeof(vx->runstate_times));
-        memcpy(user_times + 1, vx->runstate_times, sizeof(vx->runstate_times));
-
-        smp_wmb();
-
-        /*
-         * Finally, clear the 'updating' bit. Don't use &= here because
-         * the compiler may not realise that update_bit and user_times
-         * point to the same place. That's a classic pointer-aliasing
-         * problem.
-         */
-        *update_bit = vx->runstate_entry_time >> 56;
-        smp_wmb();
-
-        goto done_1;
-    }
-
     /*
      * The painful code path. It's split across two pages and we need to
      * hold and validate both GPCs simultaneously. Thankfully we can get
@@ -336,7 +259,7 @@ static void kvm_xen_update_runstate_guest(struct
kvm_vcpu *v, bool atomic)
      */
     read_lock(&gpc2->lock);

-    if (!kvm_gpc_check(v->kvm, gpc2, gpc2->gpa, user_len2)) {
+    if (user_len2 && !kvm_gpc_check(v->kvm, gpc2, gpc2->gpa, user_len2)) {
         read_unlock(&gpc2->lock);
         read_unlock_irqrestore(&gpc1->lock, flags);

@@ -361,6 +284,20 @@ static void kvm_xen_update_runstate_guest(struct
kvm_vcpu *v, bool atomic)
         goto retry;
     }

+    /*
+     * The XEN_RUNSTATE_UPDATE bit is the top bit of the state_entry_time
+     * field. We need to set it (and write-barrier) before writing to the
+     * the rest of the structure, and clear it last. Just as Xen does, we
+     * address the single *byte* in which it resides because it might be
+     * in a different cache line to the rest of the 64-bit word, due to
+     * the (lack of) alignment constraints.
+     */
+    BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state_entry_time) !=
+             sizeof(uint64_t));
+    BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info,
state_entry_time) !=
+             sizeof(uint64_t));
+    BUILD_BUG_ON((XEN_RUNSTATE_UPDATE >> 56) != 0x80);
+
     /*
      * Work out where the byte containing the XEN_RUNSTATE_UPDATE bit is.
      */
@@ -370,6 +307,17 @@ static void kvm_xen_update_runstate_guest(struct
kvm_vcpu *v, bool atomic)
         update_bit = ((u8 *)gpc2->khva) + times_ofs + sizeof(u64) - 1 -
             user_len1;

+    /*
+     * Next, write the new runstate. This is in the *same* place
+     * for 32-bit and 64-bit guests, asserted here for paranoia.
+     */
+    BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=
+             offsetof(struct compat_vcpu_runstate_info, state));
+    BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state) !=
+             sizeof(vx->current_runstate));
+    BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state) !=
+             sizeof(vx->current_runstate));
+
     /*
      * Create a structure on our stack with everything in the right place.
      * The rs_state pointer points to the start of it, which in the case
@@ -378,29 +326,44 @@ static void kvm_xen_update_runstate_guest(struct
kvm_vcpu *v, bool atomic)
      */
     *rs_state = vx->current_runstate;
     rs.state_entry_time = vx->runstate_entry_time | XEN_RUNSTATE_UPDATE;
-    memcpy(rs.time, vx->runstate_times, sizeof(vx->runstate_times));
-
     *update_bit = rs.state_entry_time >> 56;
     smp_wmb();

+    /*
+     * Write the actual runstate times immediately after the
+     * runstate_entry_time.
+     */
+    BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
+             offsetof(struct vcpu_runstate_info, time) - sizeof(u64));
+    BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info,
state_entry_time) !=
+             offsetof(struct compat_vcpu_runstate_info, time) - sizeof(u64));
+    BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
+             sizeof_field(struct compat_vcpu_runstate_info, time));
+    BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
+             sizeof(vx->runstate_times));
+    memcpy(rs.time, vx->runstate_times, sizeof(vx->runstate_times));
+
     /*
      * Having constructed the structure starting at *rs_state, copy it
      * into the first and second pages as appropriate using user_len1
      * and user_len2.
      */
     memcpy(gpc1->khva, rs_state, user_len1);
-    memcpy(gpc2->khva, ((u8 *)rs_state) + user_len1, user_len2);
+    if (user_len2)
+        memcpy(gpc2->khva, ((u8 *)rs_state) + user_len1, user_len2);
     smp_wmb();

     /*
-     * Finally, clear the XEN_RUNSTATE_UPDATE bit.
+     * Finally, clear the 'updating' bit. Don't use &= here because
+     * the compiler may not realise that update_bit and user_times
+     * point to the same place. That's a classic pointer-aliasing
+     * problem.
      */
     *update_bit = vx->runstate_entry_time >> 56;
     smp_wmb();

     if (user_len2)
         read_unlock(&gpc2->lock);
- done_1:
     read_unlock_irqrestore(&gpc1->lock, flags);

     mark_page_dirty_in_slot(v->kvm, gpc1->memslot, gpc1->gpa >> PAGE_SHIFT);


? Yet another possibility is to introduce a

/* Copy from src to dest_ofs bytes into the combined area pointed to by
 * dest1 (up to dest1_len bytes) and dest2 (the rest). */
void split_memcpy(void *dest1, void *dest2, size_t dest_ofs, size_t
dest1_len, void *src, size_t src_len)

so that the on-stack struct is not needed at all. This makes it possible to
avoid the rs_state hack as well.

It's in kvm/queue only, so there's time to include a new version.

Paolo

> Sean, given that this now includes your patch series which in turn you
> took over from Michal, how would you prefer me to proceed?
>
> David Woodhouse (7):
>       KVM: x86/xen: Validate port number in SCHEDOP_poll
>       KVM: x86/xen: Only do in-kernel acceleration of hypercalls for guest CPL0
>       KVM: x86/xen: Add CPL to Xen hypercall tracepoint
>       MAINTAINERS: Add KVM x86/xen maintainer list
>       KVM: x86/xen: Compatibility fixes for shared runstate area
>       KVM: Update gfn_to_pfn_cache khva when it moves within the same page
>       KVM: x86/xen: Add runstate tests for 32-bit mode and crossing page boundary
>
> Michal Luczaj (6):
>       KVM: Shorten gfn_to_pfn_cache function names
>       KVM: x86: Remove unused argument in gpc_unmap_khva()
>       KVM: Store immutable gfn_to_pfn_cache properties
>       KVM: Use gfn_to_pfn_cache's immutable "kvm" in kvm_gpc_check()
>       KVM: Clean up hva_to_pfn_retry()
>       KVM: Use gfn_to_pfn_cache's immutable "kvm" in kvm_gpc_refresh()
>
> Sean Christopherson (4):
>       KVM: Drop KVM's API to allow temporarily unmapping gfn=>pfn cache
>       KVM: Do not partially reinitialize gfn=>pfn cache during activation
>       KVM: Drop @gpa from exported gfn=>pfn cache check() and refresh() helpers
>       KVM: Skip unnecessary "unmap" if gpc is already valid during refresh
>
> We can reinstate the 'immutable length' thing on top, if we pick one of
> the discussed options for coping with the fact that for the runstate
> area, it *isn't* immutable. I'm slightly leaning towards just setting
> the length to '1' despite it being a lie.

