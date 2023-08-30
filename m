Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B1478E120
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 23:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240171AbjH3VEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 17:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240147AbjH3VEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 17:04:40 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2F6CF2
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 14:04:09 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id d75a77b69052e-411fc812914so1501011cf.0
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 14:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693429375; x=1694034175; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZbCG0tdyar/6+EAaNY79S340Vu6kvaT6TpEIPobVhxc=;
        b=npAYAAXm9D7I/oBWbTImnzPN9U4R5bxRcMfReCSKZ0VTUyXFtLey9nCZYS+MZg/CC/
         XKq2lbm9zV9LshIFlgRV2JNpBMeyLCGkJbETM1rVzCEclUOSO6kPSiTVCGOYeIlgZHsW
         60hHVaGsL6jSeTXZgE2imfVnXd7N46erLldwBUWsP/FUVRc+KBgW459F4hgIsz9qBM00
         K0NNBYg7bCKVqbZwrDEBxp+N+OMVd6/Ub31HlUNzW0EHIFHDHkycJB41xQ3fTWZBa8C7
         aISxgJH9tSafydaQdcPkW2f/X6vrfuXRxZXHYtvdl4B1/yP/qSatiTCfGOM8wGiT4IIT
         Khqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693429375; x=1694034175;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZbCG0tdyar/6+EAaNY79S340Vu6kvaT6TpEIPobVhxc=;
        b=bIH/tfL9ockTNp1Hk6E2s6Lw5adry/3Be/GyAsUpi//HqIOkMBB3obYmmavA3Ytn76
         aW3VaHwV0aOZB0w2Pfzr3foIFaWxVM65V/l5qfnCLBMF4O2z5BFOtiak/EGRjifyThq3
         e28KeVcgymhwOj3Bkd7IqjDW8ijALy5kEay99PhjiUlnwH0vflWCQexyTb+tASX6BN3G
         YlZG3qRBTAZfcaNop1iAzMCAK5v8ybuQaDdh6fXid+qdSqvMGecCQaDC7YDEQ+nffyrw
         2amk9Aw6O+gNnz/nuuMPPvSi124oZm383vjGQnkGZ3XFtZYrNr6yZv8Wqn6Rh+m7Zuyw
         XJPA==
X-Gm-Message-State: AOJu0YxJ6/Yw50tuyntOf3LyfB33TM4HksWhiybab9/iNswCrTA55QD1
        TMrdtajHNecY7iTldOZho/QThvQjJZI=
X-Google-Smtp-Source: AGHT+IF5b6gqdFR2LDLZ3RJxfd4VjOhdzQk4NFKot509LSj0408O/0vZ9+YO40BiHXDBFLY89BYeBDPkQrA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:234a:b0:1bc:5182:1de2 with SMTP id
 c10-20020a170903234a00b001bc51821de2mr856300plh.1.1693428644421; Wed, 30 Aug
 2023 13:50:44 -0700 (PDT)
Date:   Wed, 30 Aug 2023 13:50:42 -0700
In-Reply-To: <6c691bc5-dbfc-46f9-8c09-9c74c51d8708@gmail.com>
Mime-Version: 1.0
References: <20230729013535.1070024-1-seanjc@google.com> <20230729013535.1070024-17-seanjc@google.com>
 <6c691bc5-dbfc-46f9-8c09-9c74c51d8708@gmail.com>
Message-ID: <ZO+roobNH2QbZZWn@google.com>
Subject: Re: [PATCH v4 16/29] KVM: x86: Reject memslot MOVE operations if
 KVMGT is attached
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 30, 2023, Like Xu wrote:
> On 2023/7/29 09:35, Sean Christopherson wrote:
> > Disallow moving memslots if the VM has external page-track users, i.e. if
> > KVMGT is being used to expose a virtual GPU to the guest, as KVMGT doesn't
> > correctly handle moving memory regions.
> > 
> > Note, this is potential ABI breakage!  E.g. userspace could move regions
> > that aren't shadowed by KVMGT without harming the guest.  However, the
> > only known user of KVMGT is QEMU, and QEMU doesn't move generic memory
> 
> This change breaks two kvm selftests:
> 
> - set_memory_region_test;
> - memslot_perf_test;

It shoudn't.  As of this patch, KVM doesn't register itself as a page-track user,
i.e. KVMGT is the only remaining caller to kvm_page_track_register_notifier().
Unless I messed up, the only way kvm_page_track_has_external_user() can return
true is if KVMGT is attached to the VM.  The selftests most definitely don't do
anything with KVMGT, so I don't see how they can fail.

Are you seeing actually failures?

> Please help confirm if the tests/doc needs to be updated,
> or if the assumption needs to be further clarified.

What assumption?

> > regions.  KVM's own support for moving memory regions was also broken for
> > multiple years (albeit for an edge case, but arguably moving RAM is
> > itself an edge case), e.g. see commit edd4fa37baa6 ("KVM: x86: Allocate
> > new rmap and large page tracking when moving memslot").
> > 
> > Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
> > Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/include/asm/kvm_page_track.h | 3 +++
> >   arch/x86/kvm/mmu/page_track.c         | 5 +++++
> >   arch/x86/kvm/x86.c                    | 7 +++++++
> >   3 files changed, 15 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
> > index 8c4d216e3b2b..f744682648e7 100644
> > --- a/arch/x86/include/asm/kvm_page_track.h
> > +++ b/arch/x86/include/asm/kvm_page_track.h
> > @@ -75,4 +75,7 @@ kvm_page_track_unregister_notifier(struct kvm *kvm,
> >   void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> >   			  int bytes);
> >   void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot);
> > +
> > +bool kvm_page_track_has_external_user(struct kvm *kvm);
> > +
> >   #endif
> > diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> > index 891e5cc52b45..e6de9638e560 100644
> > --- a/arch/x86/kvm/mmu/page_track.c
> > +++ b/arch/x86/kvm/mmu/page_track.c
> > @@ -303,3 +303,8 @@ void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
> >   			n->track_flush_slot(kvm, slot, n);
> >   	srcu_read_unlock(&head->track_srcu, idx);
> >   }
> > +
> > +bool kvm_page_track_has_external_user(struct kvm *kvm)
> > +{
> > +	return hlist_empty(&kvm->arch.track_notifier_head.track_notifier_list);
> > +}
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 059571d5abed..4394bb49051f 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12606,6 +12606,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
> >   				   struct kvm_memory_slot *new,
> >   				   enum kvm_mr_change change)
> >   {
> > +	/*
> > +	 * KVM doesn't support moving memslots when there are external page
> > +	 * trackers attached to the VM, i.e. if KVMGT is in use.
> > +	 */
> > +	if (change == KVM_MR_MOVE && kvm_page_track_has_external_user(kvm))
> > +		return -EINVAL;
> > +
> >   	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE) {
> >   		if ((new->base_gfn + new->npages - 1) > kvm_mmu_max_gfn())
> >   			return -EINVAL;
