Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5325C04A4
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 18:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiIUQum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 12:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbiIUQuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 12:50:17 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B1C956B4
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 09:45:31 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id b23so6477838pfp.9
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 09:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=JZfIBMlS2x8Yy9k3gjqr0aT1iELoQxmYkxILnyXMMIU=;
        b=QMTsI7sI0sDBmr4p1PRMig5+jVttyHA6AUnNS0PKcAkiLoVBwcc431trVt0qT6edyM
         +dGKqMAbZYLKJvcZKYhEDS8oIEl94it51RkKYnMFiD3y+DR3sTaI+1lImTXYOskCOuvr
         fTVNWFcW0sU/OHTVMjuZcBuhbScWU0VhNdQCSDpddFBYsat1912NiZwVydVpu5ycF+4/
         3VPUsi5q6BCQVl/3ONDnhPpe8ja46lRaOpFmyEfTQzwyWcH63YX5E8+9lKYNj76x16PC
         8biwyzjt4ewkLeoQmVVvWIkbQZvsqJzIHdrmGxSAoRiDvzdARR58tBw22+z3ilC01GIj
         GBSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=JZfIBMlS2x8Yy9k3gjqr0aT1iELoQxmYkxILnyXMMIU=;
        b=kS8TOtTbsABRsZgUpA8dUUAI9oCnsEUAl/eLfuNuGQ80UGG8XyjveUkO012SHkrHrZ
         R+HfFULYEx7ehcMB6IFzs3RwfsC5/MOJUZPcLxOnVHf0Y+MwihvgjnDSExZbxy4kAT+o
         s46o1LYGH9BnRab/GBHkZqk4CKk1j8IPEa4d05AxnHqd6NCVrKAQRkG3tCC+aNMFps4L
         wk1Z3wjfrauxfMNAMzOqKmFiiLIJiKye1UNiCl9wU2zqcn6dXEX8PxB4GiaozP16UCYi
         2cWZpqJp741/MjHUpQ0ZYZR5o9Qc0VIT7cWhBZCPB67J9llE8qsT1+ZWcdVeTF7WYzfQ
         SWdw==
X-Gm-Message-State: ACrzQf184sEML9H0S2XeSvUQFU+/zYAE0eimz/YezW1pxMLg3uKoItt5
        UYEz6eSPFU69eVMXeDk5QBFEYQ==
X-Google-Smtp-Source: AMsMyM4mABv3skhAlczhBXEuZ/6OucFGsARbNjRuiuKVL72UiLewaLH756FSmN4LJxyGTlqIi2113w==
X-Received: by 2002:a65:6a4d:0:b0:439:a0fb:322b with SMTP id o13-20020a656a4d000000b00439a0fb322bmr25639153pgu.10.1663778730870;
        Wed, 21 Sep 2022 09:45:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u1-20020a1709026e0100b00179988ca61bsm37972plk.161.2022.09.21.09.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 09:45:30 -0700 (PDT)
Date:   Wed, 21 Sep 2022 16:45:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 02/39] KVM: x86: hyper-v: Resurrect dedicated
 KVM_REQ_HV_TLB_FLUSH flag
Message-ID: <Yys/pv0d+8ywcbUy@google.com>
References: <20220921152436.3673454-1-vkuznets@redhat.com>
 <20220921152436.3673454-3-vkuznets@redhat.com>
 <Yys6b1ZqYbw9Umyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yys6b1ZqYbw9Umyu@google.com>
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

On Wed, Sep 21, 2022, Sean Christopherson wrote:
> On Wed, Sep 21, 2022, Vitaly Kuznetsov wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index f62d5799fcd7..86504a8bfd9a 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3418,11 +3418,17 @@ static inline void kvm_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
> >   */
> >  void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
> >  {
> > -	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
> > +	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu)) {
> >  		kvm_vcpu_flush_tlb_current(vcpu);
> > +		kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
> 
> This isn't correct, flush_tlb_current() flushes "host" TLB entries, i.e. guest-physical
> mappings in Intel terminology, where flush_tlb_guest() and (IIUC) Hyper-V's paravirt
> TLB flush both flesh "guest" TLB entries, i.e. linear and combined mappings.
> 
> Amusing side topic, apparently I like arm's stage-2 terminology better than "TDP",
> because I actually typed out "stage-2" first.
> 
> > +	}
> >  
> > -	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu))
> > +	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu)) {
> > +		kvm_vcpu_flush_tlb_guest(vcpu);
> > +		kvm_clear_request(KVM_REQ_HV_TLB_FLUSH, vcpu);

Looking at future patches where KVM needs to reset the FIFO when doing a "guest"
TLB flush, i.e. needs to do more than just clearing the request, what about putting
this in kvm_vcpu_flush_tlb_guest() right away?

Ah, and there's already a second caller to kvm_vcpu_flush_tlb_guest().  I doubt
KVM's paravirt TLB flush will ever collide with Hyper-V's paravirt TLB flush,
but logically a "guest" flush that is initiated through KVM's paravirt interface
should also clear Hyper-V's queue/request.

And for consistency, slot this in before this patch:

From: Sean Christopherson <seanjc@google.com>
Date: Wed, 21 Sep 2022 09:35:34 -0700
Subject: [PATCH] KVM: x86: Move clearing of TLB_FLUSH_CURRENT to
 kvm_vcpu_flush_tlb_all()

Clear KVM_REQ_TLB_FLUSH_CURRENT in kvm_vcpu_flush_tlb_all() instead of in
its sole caller that processes KVM_REQ_TLB_FLUSH.  Regardless of why/when
kvm_vcpu_flush_tlb_all() is called, flushing "all" TLB entries also
flushes "current" TLB entries.

Ideally, there will never be another caller of kvm_vcpu_flush_tlb_all(),
and moving the handling "requires" extra work to document the ordering
requirement, but future Hyper-V paravirt TLB flushing support will add
similar logic for flush "guest" (Hyper-V can flush a subset of "guest"
entries).  And in the Hyper-V case, KVM needs to do more than just clear
the request, the queue of GPAs to flush also needs to purged, and doing
all only in the request path is undesirable as kvm_vcpu_flush_tlb_guest()
does have multiple callers (though it's unlikely KVM's paravirt TLB flush
will coincide with Hyper-V's paravirt TLB flush).

Move the logic even though it adds extra "work" so that KVM will be
consistent with how flush requests are processed when the Hyper-V support
lands.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f62d5799fcd7..3ea2e51a8cb5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3383,6 +3383,9 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.tlb_flush;
 	static_call(kvm_x86_flush_tlb_all)(vcpu);
+
+	/* Flushing all ASIDs flushes the current ASID... */
+	kvm_clear_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 }
 
 static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
@@ -10462,12 +10465,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_mmu_sync_roots(vcpu);
 		if (kvm_check_request(KVM_REQ_LOAD_MMU_PGD, vcpu))
 			kvm_mmu_load_pgd(vcpu);
-		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu)) {
+
+		/*
+		 * Note, the order matters here, as flushing "all" TLB entries
+		 * also flushes the "current" TLB entries, i.e. servicing the
+		 * flush "all" will clear any request to flush "current".
+		 */
+		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
 			kvm_vcpu_flush_tlb_all(vcpu);
-
-			/* Flushing all ASIDs flushes the current ASID... */
-			kvm_clear_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
-		}
 		kvm_service_local_tlb_flush_requests(vcpu);
 
 		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {

base-commit: ed102fe0b59586397b362a849bd7fb32582b77d8
-- 

