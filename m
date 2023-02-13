Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C1D69506F
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 20:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjBMTMC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 14:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjBMTMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 14:12:01 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFCB6E80
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 11:12:00 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id z14-20020a17090abd8e00b00233bb9d6bdcso8015617pjr.4
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 11:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wNo8g2FDXWrD077kenEeFscJy4crSRwPtvpHt4+NdF4=;
        b=dOEunVEWr15oKfG1FH7QOOyoKBOj26L4aXFaLGzBNVFvRArUHl906ciK+AcHBMmzGw
         FCVj9aIQ9hw/2dczqLEHUOe9e5iRlTi7Yzw/32jP0O19NXK7H8KdeSzwZtgICqoWuadZ
         +Zwulq22O1VPuYkJ/k9bfOwLxufVfRTMf6W2SKwcLIQY8nQCJi3lA6Sf3XcsTMbr6glD
         0/h52WY/6SLu8abVB/mVtU798HiFRxlMiOrF96mYI61T2bOC/1uTGrvtPp3+rji5fABr
         TVjwTBnphNaxrlsJ1SEkTY7TPyqmY7fnaYJp78iTcJfS8SRz0Qv6pbn4HxTel30znMHE
         uuDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wNo8g2FDXWrD077kenEeFscJy4crSRwPtvpHt4+NdF4=;
        b=bqkdSXh8+OoMQNuBqq25bwABW3pLpQmg1yAfoKXZjjraLmtF5UqfUtOyrVXf2xITfO
         NcZI6A3S1PNdHPyrY/6ODUK0KYSC1xGNIRMe0LhwLWE9nQqus/JWGG5/MoVeVbwUEMky
         /SN3R8t+aYa23XVjdYzpe4QXYjCsk6plFRVeRHFf5Lzsx8tImSJosycnUpunw3ohK7/+
         7El+P1WiK3szcX6CRt7wGzIQke7ak3aYmbZB0vgUc+bG75vk1t0TeYxwLf4/qFwoYVJQ
         MB9cYppS6ou9G74NpUK7sA7/vrmDL16GsztdGAuZVGwOpxavCT3HiaGqEvwyOt9KNjlJ
         63nA==
X-Gm-Message-State: AO0yUKVdLSbFycgyQT1O7PjkkllYqZKB+Nq5+i4Y/rUt61BpPhO3MWWf
        88j1gfgiORPQhBGud2EBUURtH0M97X3JVuAwoAg=
X-Google-Smtp-Source: AK7set8xH9xHdV3xwC60AjSdp0D5eQq9RjykssiGR30wPVTS16uOIxS3gKUxF1MGYIWy32VgmIOzog==
X-Received: by 2002:a17:902:ba84:b0:194:6d3c:38a5 with SMTP id k4-20020a170902ba8400b001946d3c38a5mr8226pls.1.1676315519838;
        Mon, 13 Feb 2023 11:11:59 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 19-20020aa79213000000b00576259507c0sm8321435pfo.100.2023.02.13.11.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 11:11:59 -0800 (PST)
Date:   Mon, 13 Feb 2023 19:11:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tianyu Lan <ltykernel@gmail.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Subject: Re: "KVM: x86/mmu: Overhaul TDP MMU zapping and flushing" breaks SVM
 on Hyper-V
Message-ID: <Y+qLe42h9ZPRINrG@google.com>
References: <43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com>
 <Y+p1j7tYT+16MX6B@google.com>
 <35ff8f48-2677-78ea-b5f3-329c75ce65c9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35ff8f48-2677-78ea-b5f3-329c75ce65c9@redhat.com>
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

On Mon, Feb 13, 2023, Paolo Bonzini wrote:
> On 2/13/23 18:38, Sean Christopherson wrote:
> > On Fri, Feb 10, 2023, Jeremi Piotrowski wrote:
> > > Hi Paolo/Sean,
> > > 
> > > We've noticed that changes introduced in "KVM: x86/mmu: Overhaul TDP MMU
> > > zapping and flushing" conflict with a nested Hyper-V enlightenment that is
> > > always enabled on AMD CPUs (HV_X64_NESTED_ENLIGHTENED_TLB). The scenario that
> > > is affected is L0 Hyper-V + L1 KVM on AMD,
> > 
> > Do you see issues with Intel and HV_X64_NESTED_GUEST_MAPPING_FLUSH?  IIUC, on the
> > KVM side, that setup is equivalent to HV_X64_NESTED_ENLIGHTENED_TLB.
> 
> My reading of the spec[1] is that HV_X64_NESTED_ENLIGHTENED_TLB will cause
> svm_flush_tlb_current to behave (in Intel parlance) as an INVVPID rather
> than an INVEPT.

Oh!  Good catch!  Yeah, that'll be a problem.  Copy-pasting the relevant snippet
so future me doesn't have to reread the spec:

  If the nested hypervisor opts into the enlightenment, ASID invalidations just
  flush TLB entires derived from first level address translation (i.e. the
  virtual address space).

Specifically, the "missing" flushes when a root's (nCR3) refcount goes to zero
are expected because KVM relies on flushing via svm_flush_tlb_current() when the
old, stale root might be reused.  That would lead to consuming stale entries when
reusing a previously freed root.

  int kvm_mmu_load(struct kvm_vcpu *vcpu)
  {
	int r;

	...

	/*
	 * Flush any TLB entries for the new root, the provenance of the root
	 * is unknown.  Even if KVM ensures there are no stale TLB entries
	 * for a freed root, in theory another hypervisor could have left
	 * stale entries.  Flushing on alloc also allows KVM to skip the TLB
	 * flush when freeing a root (see kvm_tdp_mmu_put_root()).
	 */
	static_call(kvm_x86_flush_tlb_current)(vcpu);
  out:
	return r;
  }

> So svm_flush_tlb_current has to be changed to also add a
> call to HvCallFlushGuestPhysicalAddressSpace.  I'm not sure if that's a good
> idea though.

That's not strictly necessary, e.g. flushes from kvm_invalidate_pcid() and
kvm_post_set_cr4() don't need to effect a full flush.  I believe the virtual
address flush is also sufficient for avic_activate_vmcb().  Nested (from KVM's
perspective, i.e. running L3) can just be mutually exclusive with
HV_X64_NESTED_ENLIGHTENED_TLB.

That just leaves kvm_mmu_new_pgd()'s force_flush_and_sync_on_reuse and the
aforementioned kvm_mmu_load().

That said, the above cases where a virtual address flush is sufficient are
rare operations when using NPT, so adding a new KVM_REQ_TLB_FLUSH_ROOT or
whatever probably isn't worth doing.

> First, that's a TLB shootdown rather than just a local thing;
> flush_tlb_current is supposed to be relatively cheap, and there would be a
> lot of them because of the unconditional calls to
> nested_svm_transition_tlb_flush on vmentry/vmexit.

This isn't a nested scenario for KVM though.  

> Second, while the nCR3 matches across virtual processors for SVM, the (nCR3,
> ASID) pair does not, so it doesn't even make much sense to do a TLB
> shootdown.
> 
> Depending on the performance results of adding the hypercall to
> svm_flush_tlb_current, the fix could indeed be to just disable usage of
> HV_X64_NESTED_ENLIGHTENED_TLB.

Minus making nested SVM (L3) mutually exclusive, I believe this will do the trick:

---
 arch/x86/kvm/kvm_onhyperv.c | 9 +++++++++
 arch/x86/kvm/kvm_onhyperv.h | 4 ++++
 arch/x86/kvm/svm/svm.c      | 3 +++
 3 files changed, 16 insertions(+)

diff --git a/arch/x86/kvm/kvm_onhyperv.c b/arch/x86/kvm/kvm_onhyperv.c
index 482d6639ef88..e03e9296c1cf 100644
--- a/arch/x86/kvm/kvm_onhyperv.c
+++ b/arch/x86/kvm/kvm_onhyperv.c
@@ -107,3 +107,12 @@ void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
 	}
 }
 EXPORT_SYMBOL_GPL(hv_track_root_tdp);
+
+void hv_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+	if (kvm_x86_ops.tlb_remote_flush != hv_remote_flush_tlb)
+		return;
+
+	WARN_ON_ONCE(hyperv_flush_guest_mapping(vcpu->arch.mmu->root.hpa));
+}
+EXPORT_SYMBOL_GPL(hv_flush_tlb_current);
diff --git a/arch/x86/kvm/kvm_onhyperv.h b/arch/x86/kvm/kvm_onhyperv.h
index 287e98ef9df3..30789dfd3544 100644
--- a/arch/x86/kvm/kvm_onhyperv.h
+++ b/arch/x86/kvm/kvm_onhyperv.h
@@ -11,10 +11,14 @@ int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 		struct kvm_tlb_range *range);
 int hv_remote_flush_tlb(struct kvm *kvm);
 void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp);
+void hv_flush_tlb_current(struct kvm_vcpu *vcpu);
 #else /* !CONFIG_HYPERV */
 static inline void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
 {
 }
+static inline void hv_flush_tlb_current(struct kvm_vcpu *vcpu)
+{
+}
 #endif /* !CONFIG_HYPERV */
 
 #endif
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b43775490074..bfc71dfa8482 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3733,6 +3733,9 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	/* blah blah blah */
+	hv_flush_tlb_current(vcpu);
+
 	/*
 	 * Unlike VMX, SVM doesn't provide a way to flush only NPT TLB entries.
 	 * A TLB flush for the current ASID flushes both "host" and "guest" TLB

base-commit: 9fa259abdb42051e5ab4cbf0bc0cd21adcf95a4f
-- 

