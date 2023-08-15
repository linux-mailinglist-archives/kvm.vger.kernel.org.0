Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04EAB77CE73
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 16:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237726AbjHOOvT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 10:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237795AbjHOOvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 10:51:01 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF84E5B
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 07:51:00 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5633ad8446bso5969571a12.1
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 07:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692111060; x=1692715860;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BSaljbCebqXxAjoldD4Av0i/0DgZBw/2C/j7e5eHNTM=;
        b=CjVP1jj4QRBNiSjT17ZnmQ6IkpIiSXWRPUAGRWlcELiHLU8pm6JX08g26mT/E7NLgl
         Sk61Zoumk5UmABrUQ7A27qWDJ3N7uSNTDeyiI9stop74+DNWtWXsIho3spC61XYjmpJu
         fE0mgLPJytnijZFdWHVkJzO2eNC5Y0uztbNJlXFEud4rzzVINPh2Fcknv/7W4N25v2b+
         /zjy43E+hnTxlGUrLHSe7PN8r2hzn6zAhKJBV1WVgVM1M4jClB/0Y7Q3NWBRIZr+Z7Qy
         F8BxkmdjJ8VPe+9HyqLXQY3o94LyApXS+4COm6Ty/l5KK5tNuJ4OdFogp/iwb3SNclLL
         pf1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692111060; x=1692715860;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BSaljbCebqXxAjoldD4Av0i/0DgZBw/2C/j7e5eHNTM=;
        b=iCbxIXkZO4roYH53o5rjnBQvBnpzLbCLXo8+E4CeNBRJzDV2svuLKgLx/Pf7lVolct
         FtB+sYqR5OjODZ/CqKpw8JztQG6Rlf/t+7ErFuHoLpyuhbjAW0qB0kKKslj3cyTDpKsT
         RrJoSp+ue6nRPI4ji9MeowsANrMGPCn5snH3O6kQLnyUR0o5YnqOAlOlKmlY5jgfGXlh
         ljlDpKtLbRmkimLJmptqgwjUIvtVFGBGBV69wF6O/7IZbnVBZbmNOOo1rkI2C9huo7t8
         WFQOQ81XjuJEPCgBMBDG3OKONxn6/gMjF4MI/iKAaNUfl6zOITeLqtXouDUcy4gdWXm5
         b26Q==
X-Gm-Message-State: AOJu0YxtbreO7INi2N94KvO1v9VkdreyQu9ZkgSmQL46CVmlw3VerL7D
        1iv99uWO4zJuaCyshYoBlzRT/KC5jo4=
X-Google-Smtp-Source: AGHT+IHG966N7ESziWjOW/ZteQHTABZwY4fegm6FMIGRWX29Olk3z0GlVrc96GzO09joDfiuW0Hud8OUTxM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:77cc:0:b0:55f:d4a4:57ba with SMTP id
 s195-20020a6377cc000000b0055fd4a457bamr2231606pgc.8.1692111060425; Tue, 15
 Aug 2023 07:51:00 -0700 (PDT)
Date:   Tue, 15 Aug 2023 07:50:58 -0700
In-Reply-To: <ZNra3eDNTaKVc7MT@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230810085636.25914-1-yan.y.zhao@intel.com> <20230810090218.26244-1-yan.y.zhao@intel.com>
 <277ee023-dc94-6c23-20b2-7deba641f1b1@loongson.cn> <ZNWu2YCxy2FQBl4z@yzhao56-desk.sh.intel.com>
 <e7032573-9717-b1b9-7335-cbb0da12cd2a@loongson.cn> <ZNXq9M/WqjEkfi3x@yzhao56-desk.sh.intel.com>
 <ZNZshVZI5bRq4mZQ@google.com> <ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com>
 <ZNpZDH9//vk8Rqvo@google.com> <ZNra3eDNTaKVc7MT@yzhao56-desk.sh.intel.com>
Message-ID: <ZNuQ0grC44Dbh5hS@google.com>
Subject: Re: [RFC PATCH v2 5/5] KVM: Unmap pages only when it's indeed
 protected for NUMA migration
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     bibo mao <maobibo@loongson.cn>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, mike.kravetz@oracle.com, apopple@nvidia.com,
        jgg@nvidia.com, rppt@kernel.org, akpm@linux-foundation.org,
        kevin.tian@intel.com, david@redhat.com
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

On Tue, Aug 15, 2023, Yan Zhao wrote:
> On Mon, Aug 14, 2023 at 09:40:44AM -0700, Sean Christopherson wrote:
> > > > Note, I'm assuming secondary MMUs aren't allowed to map swap entries...
> > > > 
> > > > Compile tested only.
> > > 
> > > I don't find a matching end to each
> > > mmu_notifier_invalidate_range_start_nonblock().
> > 
> > It pairs with existing call to mmu_notifier_invalidate_range_end() in change_pmd_range():
> > 
> > 	if (range.start)
> > 		mmu_notifier_invalidate_range_end(&range);
> No, It doesn't work for mmu_notifier_invalidate_range_start() sent in change_pte_range(),
> if we only want the range to include pages successfully set to PROT_NONE.

Precise invalidation was a non-goal for my hack-a-patch.  The intent was purely
to defer invalidation until it was actually needed, but still perform only a
single notification so as to batch the TLB flushes, e.g. the start() call still
used the original @end.

The idea was to play nice with the scenario where nothing in a VMA could be migrated.
It was complete untested though, so it may not have actually done anything to reduce
the number of pointless invalidations.

> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 9e4cd8b4a202..f29718a16211 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4345,6 +4345,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> >  	if (unlikely(!fault->slot))
> >  		return kvm_handle_noslot_fault(vcpu, fault, access);
> >  
> > +	if (mmu_invalidate_retry_hva(vcpu->kvm, fault->mmu_seq, fault->hva))
> > +		return RET_PF_RETRY;
> > +
> This can effectively reduce the remote flush IPIs a lot!
> One Nit is that, maybe rmb() or READ_ONCE() is required for kvm->mmu_invalidate_range_start
> and kvm->mmu_invalidate_range_end.
> Otherwise, I'm somewhat worried about constant false positive and retry.

If anything, this needs a READ_ONCE() on mmu_invalidate_in_progress.  The ranges
aren't touched when when mmu_invalidate_in_progress goes to zero, so ensuring they
are reloaded wouldn't do anything.  The key to making forward progress is seeing
that there is no in-progress invalidation.

I did consider adding said READ_ONCE(), but practically speaking, constant false
positives are impossible.  KVM will re-enter the guest when retrying, and there
is zero chance of the compiler avoiding reloads across VM-Enter+VM-Exit.

I suppose in theory we might someday differentiate between "retry because a different
vCPU may have fixed the fault" and "retry because there's an in-progress invalidation",
and not bother re-entering the guest for the latter, e.g. have it try to yield
instead.  

All that said, READ_ONCE() on mmu_invalidate_in_progress should effectively be a
nop, so it wouldn't hurt to be paranoid in this case.

Hmm, at that point, it probably makes sense to add a READ_ONCE() for mmu_invalidate_seq
too, e.g. so that a sufficiently clever compiler doesn't completely optimize away
the check.  Losing the check wouldn't be problematic (false negatives are fine,
especially on that particular check), but the generated code would *look* buggy.
