Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE5D67255B
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 18:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjARRpi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 12:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbjARRpQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 12:45:16 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A495B5B6
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:43:56 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id o13so33040745pjg.2
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fdipg/e4fRuWWYxK3H9aGCTA3DbUCt12SK72zt21rzM=;
        b=d5LcAH7zwL18g39tFFPyrtTmow8BpqTSbmmMqSzPjDBQNYo7J/+zfBhvwKIuGqXPsL
         ydGdNA2GFez4En5eQvt++QxQxbWyXrZpb/E9jxO7CSDBswbF18VDdaUMCUdgqvOZmEBc
         LgydGdUoMlBIpTCaUbvxnAyfcc4HBUguYA9xlgzaOW6kueOYmdCKoOK2LmFoklDEpTPI
         XHVSOUriWggkjJElRv/P0qUWS+TcRFFsdEVvClaV3nasnzpdvwND5BGFGLr1kf2rwBCs
         VBwe7mq91A6yW2sF35PGnhyMMEoJX2TFchBRCOCLUEYOasQ5klyCTJlq+ZTVtNp+Y1Da
         DmNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fdipg/e4fRuWWYxK3H9aGCTA3DbUCt12SK72zt21rzM=;
        b=bem6wqsQSFwuDG9ONuVtzHtyHEliTbBrR68tyNi4YfYR766YI8X9jWVS/52FM0Z/v1
         L6Z8tIfItibcm6+O9n/40XnQbgOmt5oDsCa2xtktWjdLLh33RIC4PWu1hZh7SFzyfuN7
         EqvTV6FSDef+ng4TchgPygdJe6pl132wy2/XLI492mtjGBSWbqSq2L6Ud2NBsBFm+HNu
         yoEiLsqsBi6FB2CDKIvcNoU1SjsZbj/GA6B2uBp4TDiipcUg7PeO06bCdE8MWlBHvcWJ
         cBduGrfhwZdMP6FM1cu9WiBgt1FGNlhNgqc3U3VR1aRlk27C6WR7Hy0u5yCb7pbqlb4B
         q4og==
X-Gm-Message-State: AFqh2koH2tjJSoNin5mZYiQUStM7FTmYa6b7tDxK1UrcyIakM9E4PR5C
        jYBM3kAGg/hO4CuusLRnZF4Q/g==
X-Google-Smtp-Source: AMrXdXvvH4o58eJCx/PxcUDcLBwIRxh1v90Qqn4G2ig6i8PErgkz4Xjra3LwAs4nnnx3luW3K15kcg==
X-Received: by 2002:a17:902:82c2:b0:192:6bff:734 with SMTP id u2-20020a17090282c200b001926bff0734mr3481093plz.2.1674063830825;
        Wed, 18 Jan 2023 09:43:50 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l1-20020a170903244100b0019498477f31sm3912441pls.123.2023.01.18.09.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 09:43:50 -0800 (PST)
Date:   Wed, 18 Jan 2023 17:43:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     David Matlack <dmatlack@google.com>, pbonzini@redhat.com,
        bgardon@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v3 1/9] KVM: x86/mmu: Repurpose KVM MMU shrinker to purge
 shadow page caches
Message-ID: <Y8gv0srYi+6PvJml@google.com>
References: <20221222023457.1764-1-vipinsh@google.com>
 <20221222023457.1764-2-vipinsh@google.com>
 <Y64MsBubSyPNmMyk@google.com>
 <CAHVum0efBBe+OEiJw1-L+F1R8d-xPanAKjktgkg7Q2SXDot+KQ@mail.gmail.com>
 <CAHVum0cZtDYZN2bD3TZgUNpcWiy2-Qkw1mb40syut_2kkR=Agg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0cZtDYZN2bD3TZgUNpcWiy2-Qkw1mb40syut_2kkR=Agg@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

@all, trim your replies!

On Tue, Jan 03, 2023, Vipin Sharma wrote:
> On Tue, Jan 3, 2023 at 10:01 AM Vipin Sharma <vipinsh@google.com> wrote:
> >
> > On Thu, Dec 29, 2022 at 1:55 PM David Matlack <dmatlack@google.com> wrote:
> > > > @@ -6646,66 +6690,49 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
> > > >  static unsigned long
> > > >  mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
> > > >  {
> > > > -     struct kvm *kvm;
> > > > -     int nr_to_scan = sc->nr_to_scan;
> > > > +     struct kvm_mmu_memory_cache *cache;
> > > > +     struct kvm *kvm, *first_kvm = NULL;
> > > >       unsigned long freed = 0;
> > > > +     /* spinlock for memory cache */
> > > > +     spinlock_t *cache_lock;
> > > > +     struct kvm_vcpu *vcpu;
> > > > +     unsigned long i;
> > > >
> > > >       mutex_lock(&kvm_lock);
> > > >
> > > >       list_for_each_entry(kvm, &vm_list, vm_list) {
> > > > -             int idx;
> > > > -             LIST_HEAD(invalid_list);
> > > > -
> > > > -             /*
> > > > -              * Never scan more than sc->nr_to_scan VM instances.
> > > > -              * Will not hit this condition practically since we do not try
> > > > -              * to shrink more than one VM and it is very unlikely to see
> > > > -              * !n_used_mmu_pages so many times.
> > > > -              */
> > > > -             if (!nr_to_scan--)
> > > > +             if (first_kvm == kvm)
> > > >                       break;
> > > > -             /*
> > > > -              * n_used_mmu_pages is accessed without holding kvm->mmu_lock
> > > > -              * here. We may skip a VM instance errorneosly, but we do not
> > > > -              * want to shrink a VM that only started to populate its MMU
> > > > -              * anyway.
> > > > -              */
> > > > -             if (!kvm->arch.n_used_mmu_pages &&
> > > > -                 !kvm_has_zapped_obsolete_pages(kvm))
> > > > -                     continue;
> > > > +             if (!first_kvm)
> > > > +                     first_kvm = kvm;
> > > > +             list_move_tail(&kvm->vm_list, &vm_list);
> > > >
> > > > -             idx = srcu_read_lock(&kvm->srcu);
> > > > -             write_lock(&kvm->mmu_lock);
> > > > +             kvm_for_each_vcpu(i, vcpu, kvm) {
> > >
> > > What protects this from racing with vCPU creation/deletion?
> > >
> 
> vCPU deletion:
> We take kvm_lock in mmu_shrink_scan(), the same lock is taken in
> kvm_destroy_vm() to remove a vm from vm_list. So, once we are
> iterating vm_list we will not see any VM removal which will means no
> vcpu removal.
> 
> I didn't find any other code for vCPU deletion except failures during
> VM and VCPU set up. A VM is only added to vm_list after successful
> creation.

Yep, KVM doesn't support destroying/freeing a vCPU after it's been added.

> vCPU creation:
> I think it will work.
> 
> kvm_vm_ioctl_create_vcpus() initializes the vcpu, adds it to
> kvm->vcpu_array which is of the type xarray and is managed by RCU.
> After this online_vcpus is incremented. So, kvm_for_each_vcpu() which
> uses RCU to read entries, if it sees incremented online_vcpus value
> then it will also sees all of the vcpu initialization.

Yep.  The shrinker may race with a vCPU creation, e.g. not process a just-created
vCPU, but that's totally ok in this case since the shrinker path is best effort
(and purging the caches of a newly created vCPU is likely pointless).

> @Sean, Paolo
> 
> Is the above explanation correct, kvm_for_each_vcpu() is safe without any lock?

Well, in this case, you do need to hold kvm_lock ;-)

But yes, iterating over vCPUs without holding the per-VM kvm->lock is safe, the
caller just needs to ensure the VM can't be destroyed, i.e. either needs to hold
a reference to the VM or needs to hold kvm_lock.
