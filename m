Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5DE3FF5B4
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 23:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347450AbhIBVja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 17:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346956AbhIBVj3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 17:39:29 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E394EC061757
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 14:38:30 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id fs6so2294233pjb.4
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 14:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XAVKUYQj+y0aHlDsMuwQRtXtekPEP3GaQHKhvci9zCc=;
        b=BsC8e7/IPAUVyOmLsfsZS4cNOu3rDeFoMkJRDJiBK7MKiWrwojy2RlVOQgGIDrYvBp
         CXRJSOz3Vp+Q25sMBjo8CLxlirW/pCpSyqHFeeBPMjae/OOAZEP4L5Gt9IZyWoQwThex
         PkWHCxxVM1tOvlHrYL0H99gZ9VQMW0oc962UzBSzlSV4ytUWh2IuxGvK+icru3LKLUsg
         q3TOfXV8pvxK/8sRgvNayzmCf6dtoztdLpDvxaLn5OZwomu4BLlXblZrrZUvxCbcYZFH
         sg7NXHERVcIalxYhndZP0Hiv9z40ZdhVP3eYA9SX/arRegAkUdC3xK8hjq2hGIjJUqxb
         PtAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XAVKUYQj+y0aHlDsMuwQRtXtekPEP3GaQHKhvci9zCc=;
        b=iIN3vSVLJJOeAOkqkRKMURdMiS1ZvdNbBdpmZB7w6YOYWi4uQmhg+L1tOdluzhM6Fm
         FuzuYh1M4M9Sxf0zJKobSRhBN6zmRjk1t+/2T8EbMPpouFkTkqdN6ToEmuaiRCHLrBE5
         MyxJbar/H1JPIlEabP+Ycah7nmbL6K5mNf0Cr0JqxYs7P5IIBqv0GBSKp1pn/qZooupt
         rsZE6VgHqzrhIRL/kpjIeCXRx2Dl+MrSVrzbUW2YEpluf7dKIt2kQeR22wFAShcVNvm1
         gFuEL/qDd+ZsLIW/udQYlRFUOmg8YS4Kj9p6loYN9Nr8UVe6VLGWeU6CUAgpNqCotnKc
         SSjA==
X-Gm-Message-State: AOAM53143zDIbzK9avPZIpR4B5XnT6Jv+4vQlSIBBmPtUY6aA9ompygz
        IWae16E3/gPvN0eKPLT6kL77Uw==
X-Google-Smtp-Source: ABdhPJzeLRhYVtk7E31sohG+Cbp0WZ5nszCMPGF2I7t97uxYs/StEtFzGwnAM6MJTJZuf1ikMk3y5w==
X-Received: by 2002:a17:90b:4a03:: with SMTP id kk3mr231648pjb.30.1630618710262;
        Thu, 02 Sep 2021 14:38:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b5sm3003604pjq.2.2021.09.02.14.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 14:38:29 -0700 (PDT)
Date:   Thu, 2 Sep 2021 21:38:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 1/7] KVM: X86: Fix missed remote tlb flush in
 rmap_write_protect()
Message-ID: <YTFEUmrjcyI9V1z9@google.com>
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
 <20210824075524.3354-2-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824075524.3354-2-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> When kvm->tlbs_dirty > 0, some rmaps might have been deleted
> without flushing tlb remotely after kvm_sync_page().  If @gfn
> was writable before and it's rmaps was deleted in kvm_sync_page(),
> we need to flush tlb too even if __rmap_write_protect() doesn't
> request it.
> 
> Fixes: 4731d4c7a077 ("KVM: MMU: out of sync shadow core")

Should be

Fixes: a4ee1ca4a36e ("KVM: MMU: delay flush all tlbs on sync_page path")

> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4853c033e6ce..313918df1a10 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1420,6 +1420,14 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
>  			rmap_head = gfn_to_rmap(gfn, i, slot);
>  			write_protected |= __rmap_write_protect(kvm, rmap_head, true);
>  		}
> +		/*
> +		 * When kvm->tlbs_dirty > 0, some rmaps might have been deleted
> +		 * without flushing tlb remotely after kvm_sync_page().  If @gfn
> +		 * was writable before and it's rmaps was deleted in kvm_sync_page(),
> +		 * we need to flush tlb too.
> +		 */
> +		if (min_level == PG_LEVEL_4K && kvm->tlbs_dirty)
> +			write_protected = true;
>  	}
>  
>  	if (is_tdp_mmu_enabled(kvm))
> @@ -5733,6 +5741,14 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
>  		flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
>  					  start_level, KVM_MAX_HUGEPAGE_LEVEL,
>  					  false);
> +		/*
> +		 * When kvm->tlbs_dirty > 0, some rmaps might have been deleted
> +		 * without flushing tlb remotely after kvm_sync_page().  If @gfn
> +		 * was writable before and it's rmaps was deleted in kvm_sync_page(),
> +		 * we need to flush tlb too.
> +		 */
> +		if (start_level == PG_LEVEL_4K && kvm->tlbs_dirty)
> +			flush = true;
>  		write_unlock(&kvm->mmu_lock);
>  	}

My vote is to do a revert of a4ee1ca4a36e with slightly less awful batching, and
then improve the batching even further if there's a noticeable loss of performance
(or just tell people to stop using shadow paging :-D).  Zapping SPTEs but not
flushing is just asking for these types of whack-a-mole bugs.

E.g. instead of a straight revert, do this for sync_page():

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 50ade6450ace..1fca27a08c00 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1095,13 +1095,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
                        return 0;

                if (FNAME(prefetch_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte)) {
-                       /*
-                        * Update spte before increasing tlbs_dirty to make
-                        * sure no tlb flush is lost after spte is zapped; see
-                        * the comments in kvm_flush_remote_tlbs().
-                        */
-                       smp_wmb();
-                       vcpu->kvm->tlbs_dirty++;
+                       set_spte_ret |= SET_SPTE_NEED_REMOTE_TLB_FLUSH;
                        continue;
                }

@@ -1116,12 +1110,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)

                if (gfn != sp->gfns[i]) {
                        drop_spte(vcpu->kvm, &sp->spt[i]);
-                       /*
-                        * The same as above where we are doing
-                        * prefetch_invalid_gpte().
-                        */
-                       smp_wmb();
-                       vcpu->kvm->tlbs_dirty++;
+                       set_spte_ret |= SET_SPTE_NEED_REMOTE_TLB_FLUSH;
                        continue;
                }


