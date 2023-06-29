Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEC9742B99
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 19:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjF2R4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 13:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbjF2R42 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 13:56:28 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CE61FCD
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 10:56:27 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-565a33c35b1so7964667b3.0
        for <kvm@vger.kernel.org>; Thu, 29 Jun 2023 10:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688061386; x=1690653386;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4FkhFrr8w6aneHxfl/h27nLQhmkU8QpQuoyru1TLP4c=;
        b=QBg6Sw4tvE6/pClUmxNda3MWefmw+W4KGc9WF6HW+rF0vuDvCBcf5loU3jRbHfnYig
         i861uID1dQ78wFmjMi+gpotuXmWiokksT3ABBYgthg9VEjTpLXe4TrzIJhyzwNUk5HFh
         9qHbnx2awjERX0lkB5i5W6ZngQIDkJb01cP7TPCOqlgtsO8uP2HPC/wVmmjbjWZigHXx
         TtWWEoEkv5wmw7fV8AyWtGUG3tqc19WEekI6RjGmXtxPGURI/AmhqGmmHdaXHn7Rp0jF
         OXszuPhwDcVKGF9EUrX3uHG91CZmh4bEum8bnNqC5COQJGndLYd7mfCX/mwj0KT/id4B
         xIug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688061386; x=1690653386;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4FkhFrr8w6aneHxfl/h27nLQhmkU8QpQuoyru1TLP4c=;
        b=Z7IsBvHYLRFyUanHBHGuyT6TIuSwzStPAxWEvlI5DiBcaySfLLgbgEfYok6TKmQIF7
         nvCDW+SIV0J0QQtjpQT3bxZ9Mc7DLZDnkPNLVEN/rS0QEZCLBc+PofTmLijjaNoOQyM3
         +gFOZ4WRiGAymvkCsoEDFn+mX2Oe62QuqkzXC+LdtgluyWISMIcPIZ3oEd+PNqfTgB5Y
         44I8cNibsPjhQYWM8JYSSnQDoshKAPzFoehqR78ym/B0CFVCJRGhqZJFUt/jdRo3T71G
         s8wGmo5Q1ZeQv7NrT4W9UHjFC2K5RK+ZwEfrvvkB1FWUl4f+lQ1kp55r9n5xZMHb9jqA
         Uevw==
X-Gm-Message-State: ABy/qLZ249ZVd4gj/c5co+NGL4A04vsbJFzpQyeiPbmt2FmVW5wa61f+
        xxLQy2ZgUeK03Qac8rZdBAndBJiZIU4=
X-Google-Smtp-Source: APBJJlFJmT7oK8STRSANTG0ivP5lT2JUcbXj/ye4nh0QWb7UXGu2Pv6MV1qia3QdZDv0fFgARODG4ntvVgs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:c845:0:b0:56c:f8b7:d4f7 with SMTP id
 k5-20020a81c845000000b0056cf8b7d4f7mr819ywl.6.1688061386259; Thu, 29 Jun 2023
 10:56:26 -0700 (PDT)
Date:   Thu, 29 Jun 2023 10:56:24 -0700
In-Reply-To: <ZJ0w5pKk/41Zv26i@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230628071217.71126-1-ishiir@g.ecc.u-tokyo.ac.jp>
 <ZJxTTZzZnfbyMVIH@google.com> <ZJ0w5pKk/41Zv26i@yzhao56-desk.sh.intel.com>
Message-ID: <ZJ3FyLUYrlr6+HLw@google.com>
Subject: Re: [PATCH] KVM: nVMX: Prevent vmlaunch with EPTP pointing outside
 assigned memory area
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>, shina@ecc.u-tokyo.ac.jp,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuan.yao@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 29, 2023, Yan Zhao wrote:
> On Wed, Jun 28, 2023 at 08:37:45AM -0700, Sean Christopherson wrote:
> ...
> > So I think we should try this:
> > 
> > ---
> >  arch/x86/kvm/mmu/mmu.c   | 19 -------------------
> >  include/linux/kvm_host.h |  1 -
> >  virt/kvm/kvm_main.c      | 13 ++-----------
> >  3 files changed, 2 insertions(+), 31 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 60397a1beda3..e305737edf84 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3671,19 +3671,6 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_mmu_free_guest_mode_roots);
> >  
> > -
> > -static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
> > -{
> > -	int ret = 0;
> > -
> > -	if (!kvm_vcpu_is_visible_gfn(vcpu, root_gfn)) {
> > -		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> > -		ret = 1;
> > -	}
> > -
> > -	return ret;
> > -}
> > -
> >  static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
> >  			    u8 level)
> >  {
> > @@ -3821,9 +3808,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
> >  	root_pgd = kvm_mmu_get_guest_pgd(vcpu, mmu);
> >  	root_gfn = root_pgd >> PAGE_SHIFT;
> >  
> > -	if (mmu_check_root(vcpu, root_gfn))
> > -		return 1;
> > -
> Hi Sean,
> The checking of existence of memslot is still useful,
> Otherwise NULL pointer dereference would be met as in below call trace.
>
> mmu_alloc_shadow_roots
>  |->mmu_alloc_root
>     |->mmu_alloc_root(root_gfn)
>        |->kvm_mmu_get_shadow_page
>           |->__kvm_mmu_get_shadow_page
>              |->kvm_mmu_alloc_shadow_page
>                 |->account_shadowed
>                    |->slot = __gfn_to_memslot(slots, gfn);                    ==>NULL pointer
>                    |  kvm_slot_page_track_add_page(kvm, slot, gfn,KVM_PAGE_TRACK_WRITE);
>                       |->update_gfn_track(slot, gfn, mode, 1);
>                          |->index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);  ==>NULL pointer dereference

Argh, right, the internal memslot might "work", but the no memslot case will not.
The non-root path effectively injects a page fault if there's no memslot.

Oof, and simply skipping the accounting for the no-slot case would result in an
imbalanced world if userspace creates a valid memslot before unaccount_shadowed()
is called.

As much as it pains me to propagate KVM's arbitrary behavior, doing the right from
an architectural perspective is really gross for KVM, e.g. would need all kinds of
dedicated code in the MMU.

I still don't like adding a non-architectural check to nested_vmx_check_eptp(),
especially since there would be a race, e.g. if a memslot were deleted between
nested_vmx_check_eptp() and allocating the root.

This is the least awful solution I can think of (not yet tested):

From: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 Jun 2023 10:54:12 -0700
Subject: [PATCH] KVM: nVMX: Allow triple fault shutdown in L2 to cancel nested
 VM-Enter

<need to test and write a changelog>

Reported-by: Reima Ishii <ishiir@g.ecc.u-tokyo.ac.jp>
Cc: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 22e08d30baef..6da6db575a27 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4729,8 +4729,15 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	/* Pending MTF traps are discarded on VM-Exit. */
 	vmx->nested.mtf_pending = false;
 
-	/* trying to cancel vmlaunch/vmresume is a bug */
-	WARN_ON_ONCE(vmx->nested.nested_run_pending);
+	/*
+	 * Canceling VMLAUNCH/VMRESUME is a KVM bug, but triple fault shutdown
+	 * is allowed due to limitations with KVM's shadow MMU, which requires
+	 * shadowed page tables to be associated with a valid memslot, and KVM
+	 * can't complete VM-Enter without a valid shadow root.
+	 */
+	WARN_ON_ONCE(vmx->nested.nested_run_pending &&
+		     vm_exit_reason != EXIT_REASON_TRIPLE_FAULT);
+	vmx->nested.nested_run_pending = false;
 
 	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
 		/*

base-commit: 61eb0bb88e6c154a5e19e62edd99299a86a2c6a7
-- 

