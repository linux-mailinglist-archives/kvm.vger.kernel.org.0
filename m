Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C48467454A
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 22:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjASV4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 16:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjASV4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 16:56:12 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01951BC761
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:36:38 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id z1-20020a17090a66c100b00226f05b9595so3098537pjl.0
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KbsQPaprkHSBHTpU4bUWi90+sKhBjwi80Xw27RY5QK4=;
        b=a86Quj1YJ7xhR1Z7/QMfVE8urweLYcv3DdyGJe2wnQ2+47GrH64iRK+ppq9BL/iicS
         M4BzASeIAzlQnCzsH2idXLXMgpYjyn/jHmKNuUX9lEO8YvDb8KY71RStMJOuqed/BuE0
         0xLOVaVboMYj3NmxXu9baS2NILRq/k9yb/ofX/ejksksOY7ySKc2iSV85PwPq7wPmhz9
         G+n0tFbutM6WI9ZXGMNXw+mugxfvCx9zq5Hil07FzdTQ6+Q1qa3uUI/kwlfkVXx823ik
         evnGhB1In1ICxzkhG+nvRvLosoxTp1GeLrVCFQq7+xAiay6gq276kkaM8c6q+ky8yBTd
         lq/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KbsQPaprkHSBHTpU4bUWi90+sKhBjwi80Xw27RY5QK4=;
        b=FWo5GMggdEwmTcvW0XLE549OWj1jb8YD25r5udJQHD0wlja5kDHwVz7QgG5S0DtoI3
         7p8alS7XjM+SvqdgagMpX1QL9B14WW7X6BIHkHsU/NkocYzEfVcmO/vcUzEuuOmB55Eo
         Zm3ciExYVOnlS2/FPJwQnN6Ldt5NI/DdwkCwxbqivM4GoFo4OnynqNXhm2r0dgmQKpw6
         Jz2XcFOLilE3HdYQ6e7ChVH6vf1qCz01KcTV2xQd3lU35eE2uGuDcE03OYS6iT1iD/W+
         KCRDyS81onrgzUpicdhfCeyv3SmEBbp6yywbWO+jsCFBKvs+PTUrSy4L/Y+5yEAwXOib
         Xq4w==
X-Gm-Message-State: AFqh2kovz9Wi5tJ4XrUG0be3OhDBdT3qrtuc15w1d3Ng2blB/g+W7CKo
        JTo4MYdV1yuaqnfBT8PR+1E62Q==
X-Google-Smtp-Source: AMrXdXslDG21mZPI/MFDZt7ssuuoSaoEGJsHG+s7kt6c0nh2VNjHbwWdOoT2KWDWN9y3s8b+tBsLIQ==
X-Received: by 2002:a05:6a21:358b:b0:b8:e33c:f160 with SMTP id az11-20020a056a21358b00b000b8e33cf160mr89811pzc.0.1674164196862;
        Thu, 19 Jan 2023 13:36:36 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d22-20020a170902aa9600b001871461688esm25521453plr.175.2023.01.19.13.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 13:36:36 -0800 (PST)
Date:   Thu, 19 Jan 2023 21:36:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Message-ID: <Y8m34OEVBfL7Q4Ns@google.com>
References: <20230113151258.00006a6d@gmail.com>
 <Y8F1uPsW56fVdhmC@google.com>
 <20230114111621.00001840@gmail.com>
 <Y8bFCb+rs25dKcMY@google.com>
 <20230117214414.00003229@gmail.com>
 <Y8cLcY12zDWqO8nd@google.com>
 <Y8cMnjHFNIFaoX27@google.com>
 <eadc4a4e37ea0b04b8348395244b792bd34a762d.camel@intel.com>
 <Y8ljwsrrBBdh1aYw@google.com>
 <02b0e551647beed9ec3a2fefd3b659eb52c4846c.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02b0e551647beed9ec3a2fefd3b659eb52c4846c.camel@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023, Huang, Kai wrote:
> On Thu, 2023-01-19 at 15:37 +0000, Sean Christopherson wrote:
> > On Thu, Jan 19, 2023, Huang, Kai wrote:
> > > On Tue, 2023-01-17 at 21:01 +0000, Sean Christopherson wrote:
> > > > On Tue, Jan 17, 2023, Sean Christopherson wrote:
> > > > > On Tue, Jan 17, 2023, Zhi Wang wrote:
> > > > Oh, the other important piece I forgot to mention is that dropping mmu_lock deep
> > > > in KVM's MMU in order to wait isn't always an option.  Most flows would play nice
> > > > with dropping mmu_lock and sleeping, but some paths, e.g. from the mmu_notifier,
> > > > (conditionally) disallow sleeping.
> > > 
> > > Could we do something similar to tdp_mmu_iter_cond_resched() but not simple busy
> > > retrying "X times",  at least at those paths that can release mmu_lock()?
> > 
> > That's effectively what happens by unwinding up the stak with an error code.
> > Eventually the page fault handler will get the error and retry the guest.
> > 
> > > Basically we treat TDX_OPERAND_BUSY as seamcall_needbreak(), similar to
> > > rwlock_needbreak().  I haven't thought about details though.
> > 
> > I am strongly opposed to that approach.  I do not want to pollute KVM's MMU code
> > with a bunch of retry logic and error handling just because the TDX module is
> > ultra paranoid and hostile to hypervisors.
> 
> Right.  But IIUC there's legal cases that SEPT SEAMCALL can return BUSY due to
> multiple threads trying to read/modify SEPT simultaneously in case of TDP MMU. 
> For instance, parallel page faults on different vcpus on private pages.  I
> believe this is the main reason to retry.

Um, crud.  I think there's a bigger issue.  KVM always operates on its copy of the
S-EPT tables and assumes the the real S-EPT tables will always be synchronized with
KVM's mirror.  That assumption doesn't hold true without serializing SEAMCALLs in
some way.  E.g. if a SPTE is zapped and mapped at the same time, we can end up with:

  vCPU0                      vCPU1
  =====                      =====
  mirror[x] = xyz
                             old_spte = mirror[x]
                             mirror[x] = REMOVED_SPTE
                             sept[x] = REMOVED_SPTE
  sept[x] = xyz

In other words, when mmu_lock is held for read, KVM relies on atomic SPTE updates.
With the mirror=>s-ept scheme, updates are no longer atomic and everything falls
apart.

Gracefully retrying only papers over the visible failures, the really problematic
scenarios are where multiple updates race and _don't_ trigger conflicts in the TDX
module.

> We previously used spinlock around the SEAMCALLs to avoid, but looks that is
> not preferred.

That doesn't address the race above either.  And even if it did, serializing all
S-EPT SEAMCALLs for a VM is not an option, at least not in the long term.

The least invasive idea I have is expand the TDP MMU's concept of "frozen" SPTEs
and freeze (a.k.a. lock) the SPTE (KVM's mirror) until the corresponding S-EPT
update completes.

The other idea is to scrap the mirror concept entirely, though I gotta imagine
that would provide pretty awful performance.

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 0d8deefee66c..bcb398e71475 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -198,9 +198,9 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
 /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
 static_assert(!(REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
 
-static inline bool is_removed_spte(u64 spte)
+static inline bool is_frozen_spte(u64 spte)
 {
-       return spte == REMOVED_SPTE;
+       return spte == REMOVED_SPTE || spte & FROZEN_SPTE;
 }
 
 /* Get an SPTE's index into its parent's page table (and the spt array). */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bba33aea0fb0..7f34eccadf98 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -651,6 +651,9 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 
        lockdep_assert_held_read(&kvm->mmu_lock);
 
+       if (<is TDX> && new_spte != REMOVED_SPTE)
+               new_spte |= FROZEN_SPTE;
+
        /*
         * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
         * does not hold the mmu_lock.
@@ -662,6 +665,9 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
                              new_spte, iter->level, true);
        handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
 
+       if (<is TDX> && new_spte != REMOVED_SPTE)
+               __kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
+
        return 0;
 }
 

