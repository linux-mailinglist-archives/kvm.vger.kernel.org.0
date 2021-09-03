Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B094002ED
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 18:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349915AbhICQHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 12:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349898AbhICQHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 12:07:35 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40696C061757
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 09:06:35 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso4067617pjh.5
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 09:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3M5JCpWMIxRT573fJHbEQokfdtRRM/NHsmTat7Cr0bM=;
        b=quQSADvlfVhqQANdIB8SsWJFazjRHxKf2GAZUEVE9Br9WH5bg01jM2qDRM+6fgO9iN
         VdkXV011qDTLMJgpSWokeULYuucdHmt4EBb1wogoqEM/qIU+f3XH02GkrA9aQnrMPKmx
         rmdD3UgK+cD/5TRWC6kAsonuF91RBYRFG75k7L11o4UWUsYA2LQp5KjWw7TgaSnwNGMe
         IykI4R/LCp5fOI+yl4AKVtYW33Z1zPaBAbKMD5uOxLT7ZdZci4yOA9oBCb/eUkWM0HB2
         /NvhmBNjh+mbZrzxETvmf7DYwO4C9/XBn4Znzclcnb6hQW7P125YsM/9gqoiWqi6o8Hc
         2iFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3M5JCpWMIxRT573fJHbEQokfdtRRM/NHsmTat7Cr0bM=;
        b=SXkrnM+kaseIPKTq8WfVXAu6XL5UZd31iFiioyZoUObSCIBWntF3o61x7qWAJ7/dC5
         hJ4D971T2PeZT1sZIZTqHIi+NwAxibzMriuJtF7dA1QehjZeVn1JD4WJKcLi5h7sdPti
         vQAWPeE+PY4Bh0SWPQvOmarNHlvJauP664K5Su1MOEJU2QEhoCIu9SVPzuXXSR7X6sK3
         pwGiv/ey3hMhcGGEJs0ra2GUYI+kUcBac2pZPCkdtgucpfvx2A5TOctWoO5ss29QkhTa
         /oxqiOKQNen/ee2VhC6NBwpUvAtcVhpU2SP8M9AtTG0SbPSQxZyx/eRgu/2aiif5fGg9
         TdUA==
X-Gm-Message-State: AOAM533TgjTgIXp3iYdxce1UI/458MajbcK/yeXRtUV4Wizi2U5IkUqW
        Bq1IJrKiy/jmANhfznb9GLfW1g==
X-Google-Smtp-Source: ABdhPJwAn8IA8F+C9i5ZuLQqulewjQST1VCWK+zBL2c0oG0Fv743R2XuNTlXnrTPYT1A+0koICWrHA==
X-Received: by 2002:a17:90a:7d11:: with SMTP id g17mr1548686pjl.150.1630685194499;
        Fri, 03 Sep 2021 09:06:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j9sm7038793pgl.1.2021.09.03.09.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 09:06:33 -0700 (PDT)
Date:   Fri, 3 Sep 2021 16:06:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <laijs@linux.alibaba.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/7] KVM: X86: Synchronize the shadow pagetable before
 link it
Message-ID: <YTJIBr/lm5QU/Z3W@google.com>
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
 <20210824075524.3354-3-jiangshanlai@gmail.com>
 <YTFhCt87vzo4xDrc@google.com>
 <YTFkMvdGug3uS2e4@google.com>
 <c8cd9508-7516-0891-f507-4b869d7e4322@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8cd9508-7516-0891-f507-4b869d7e4322@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021, Lai Jiangshan wrote:
> 
> On 2021/9/3 07:54, Sean Christopherson wrote:
> > 
> >   trace_get_page:
> > diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> > index 50ade6450ace..5b13918a55c2 100644
> > --- a/arch/x86/kvm/mmu/paging_tmpl.h
> > +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> > @@ -704,6 +704,10 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> >   			access = gw->pt_access[it.level - 2];
> >   			sp = kvm_mmu_get_page(vcpu, table_gfn, fault->addr,
> >   					      it.level-1, false, access);
> > +			if (sp->unsync_children) {
> > +				kvm_make_all_cpus_request(KVM_REQ_MMU_SYNC, vcpu);
> > +				return RET_PF_RETRY;
> 
> Making KVM_REQ_MMU_SYNC be able remotely is good idea.
> But if the sp is not linked, the @sp might not be synced even we
> tried many times. So we should continue to link it.

Hrm, yeah.  The sp has to be linked in at least one mmu, but it may not be linked
in the current mmu, so KVM would have to sync all roots across all current and
previous mmus in order to guarantee the target page is linked.  Eww.

> But if we continue to link it, KVM_REQ_MMU_SYNC should be extended to
> sync all roots (current root and prev_roots).  And maybe add a
> KVM_REQ_MMU_SYNC_CURRENT for current root syncing.
> 
> It is not going to be a simple.  I have a new way to sync pages
> and also fix the problem,  but that include several non-fix patches.
> 
> We need to fix this problem in the simplest way.  In my patch
> mmu_sync_children() has a @root argument.  I think we can disallow
> releasing the lock when @root is false. Is it OK?

With a caveat, it should work.  I was exploring that option before the remote
sync idea.

The danger is inducing a stall in the host (RCU, etc...) if sp is an upper level
entry, e.g. with 5-level paging it can even be a PML4.  My thought for that is to
skip the yield if there are less than N unsync children remaining, and then bail
out if the caller doesn't allow yielding.  If mmu_sync_children() fails, restart
the guest and go through the entire page fault path.  Worst case scenario, it will
take a "few" rounds for the vCPU to finally resolve the page fault.

Regarding params, please use "can_yield" instead of "root" to match similar logic
in the TDP MMU, and return an int instead of a bool.

Thanks!

---
 arch/x86/kvm/mmu/mmu.c         | 18 ++++++++++++------
 arch/x86/kvm/mmu/paging_tmpl.h |  3 +++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4853c033e6ce..5be990cdb2be 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2024,8 +2024,8 @@ static void mmu_pages_clear_parents(struct mmu_page_path *parents)
 	} while (!sp->unsync_children);
 }

-static void mmu_sync_children(struct kvm_vcpu *vcpu,
-			      struct kvm_mmu_page *parent)
+static int mmu_sync_children(struct kvm_vcpu *vcpu,
+			     struct kvm_mmu_page *parent, bool can_yield)
 {
 	int i;
 	struct kvm_mmu_page *sp;
@@ -2050,7 +2050,15 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
 			flush |= kvm_sync_page(vcpu, sp, &invalid_list);
 			mmu_pages_clear_parents(&parents);
 		}
-		if (need_resched() || rwlock_needbreak(&vcpu->kvm->mmu_lock)) {
+		/*
+		 * Don't yield if there are fewer than <N> unsync children
+		 * remaining, just finish up and get out.
+		 */
+		if (parent->unsync_children > SOME_ARBITRARY_THRESHOLD &&
+		    (need_resched() || rwlock_needbreak(&vcpu->kvm->mmu_lock))) {
+			if (!can_yield)
+				return -EINTR;
+
 			kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
 			cond_resched_rwlock_write(&vcpu->kvm->mmu_lock);
 			flush = false;
@@ -2058,6 +2066,7 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
 	}

 	kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
+	return 0;
 }

 static void __clear_sp_write_flooding_count(struct kvm_mmu_page *sp)
@@ -2143,9 +2152,6 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 		}

-		if (sp->unsync_children)
-			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
-
 		__clear_sp_write_flooding_count(sp);

 trace_get_page:
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 50ade6450ace..2ff123ec0d64 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -704,6 +704,9 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			access = gw->pt_access[it.level - 2];
 			sp = kvm_mmu_get_page(vcpu, table_gfn, fault->addr,
 					      it.level-1, false, access);
+			if (sp->unsync_children &&
+			    mmu_sync_children(vcpu, sp, false))
+				return RET_PF_RETRY;
 		}

 		/*
--
