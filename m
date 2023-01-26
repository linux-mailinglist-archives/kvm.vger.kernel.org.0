Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7053867D328
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 18:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbjAZR2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 12:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbjAZR2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 12:28:33 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0946BBD7
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 09:28:24 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 20so1543305pfu.13
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 09:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u2zLYdjH49JUqfTyi6IT1khQZ+jZFRsuFDpPpb1hjEk=;
        b=jjC25OrEoCAJRLe9vY8i8hySXJ3NFIKBU9J5m3U69F/Ld37sFTxdlPMQXVniSq0wH/
         ex+CfOXpbjuVrmfQQj+tFryvzXQR62NQXM/niThnl+JFyN1nljJSKsAnA+XNwKbqCK4y
         pb8FMhFne71Fifdrvi1nhZQen39JR7QZLLjyR/ZsfPxHl92o13E30Mr77twbhcdTuVNN
         K1KKMCPFkFJNHzHxPzR6HDHCtqTzg9OzSaHCnQ44BXlfuFcTMgiGayd8KqpgastHJ5yv
         50TkFb8SKY/VGHWE6Soakfx15WmjyRF4zH2BfRXNGSplQwFIw0OaKi5oRGxCCMpZdlUz
         PxwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u2zLYdjH49JUqfTyi6IT1khQZ+jZFRsuFDpPpb1hjEk=;
        b=4jxuosIOQlbcMRB/4Bc/SybcEW6A4rSklhW8dr3GqmNTJwwNzX23dOHCRHbUXQkQZw
         DOcUCEoA9HNzlnsLxlbhnnaOBOtBls/vWT9dnyzp0C/eVvfk1mCFZWPVvwJSF1emR1JM
         TUZi/CuqhSdnTrcOajL/bHBL9DFYLO9W6lTZtG//hEe/vMUHK8qhgfY+dp+C7AOD7Uny
         tdbrLuxaUbeouxqmczqpyb8ws6ty1yE1/TSB2WOpo/9c+IEwrbhyzGh//L48Bnjdn3al
         0mV5BfMskom4BrsDySIGtYM4yCs4yf+4PvZHl32GRxskCPqj7V2dM2L4WesB9/Fh2GCd
         +VsQ==
X-Gm-Message-State: AO0yUKV6IpPfK0fFkvdCVZgzfWTaNJKgWaML5Zl851IMdSepXcOmF/9K
        a049ubfV8XXvbtXAg/DSi+VtldhGGk1/qXbBUx4=
X-Google-Smtp-Source: AK7set8Gd77u0bqjUhh8HbLJ0f4hnKKuY9nyuED+kZOSnseRrxpk5yOKkwKURk2LjJmIhlJ6tDyDPg==
X-Received: by 2002:a05:6a00:b55:b0:576:9252:d06 with SMTP id p21-20020a056a000b5500b0057692520d06mr1435001pfo.0.1674754103575;
        Thu, 26 Jan 2023 09:28:23 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n15-20020a62e50f000000b0058d90bc57basm1123103pff.90.2023.01.26.09.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 09:28:22 -0800 (PST)
Date:   Thu, 26 Jan 2023 17:28:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "dmatlack@google.com" <dmatlack@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v11 018/113] KVM: TDX: create/destroy VM structure
Message-ID: <Y9K4Mnx/Je4j+RsD@google.com>
References: <Y8ljwsrrBBdh1aYw@google.com>
 <02b0e551647beed9ec3a2fefd3b659eb52c4846c.camel@intel.com>
 <Y8m34OEVBfL7Q4Ns@google.com>
 <1c71eda35e03372f29162c6a5286f5b4d1e1d7e1.camel@intel.com>
 <Y8ndcGHUHQjHfbF9@google.com>
 <CALzav=d4vwHTnXP8wetA_Hqd3Tzc_NLp=3M-akwNSN1-ToL+Eg@mail.gmail.com>
 <Y8st2PjGDQ+Q0LlW@google.com>
 <3951e178bc38191074f5cccadc442212ff15c737.camel@intel.com>
 <Y87GzHrx8vxZLBEJ@google.com>
 <e5912f7d04ce7a27a68ce4328fc50ce594295c6c.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5912f7d04ce7a27a68ce4328fc50ce594295c6c.camel@intel.com>
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

On Thu, Jan 26, 2023, Huang, Kai wrote:
> On Mon, 2023-01-23 at 17:41 +0000, Sean Christopherson wrote:
> > I think there's an opportunity and motivation to improve the TDP MMU as a whole on
> > this front though.  Rather than recursively zap children in handle_removed_pt(),
> > we can use the RCU callback to queue the page table for removal.  Setting the parent
> > (target page table) !PRESENT and flushing the TLBs ensures that all children are
> > unreachable, i.e. KVM doesn't need to immediately set children !PRESENT.  Unlike
> > the shadow MMU, which maintains a hash table of shadow pages, once a parent page
> > table is removed from the TDP MMU, its children are unreachabled.
> 
> Do you mean something like (pseudo):
> 
> 	rcu_callback(&removed_sp->rcu_head, handle_removed_pt);

Yep.

> > The RCU callback must run in near-constant time, but that's easy to solve as we
> > already have a workqueue for zapping page tables, i.e. the RCU callback can simply
> > add the target page to the zap workqueue.  That would also allow for a (very minor)
> > simplification of other TDP MMU code: tdp_mmu_zap_root() wouldn't needed to zap in
> > two passes since zapping children of the top-level SPTEs would be deferred to the
> > workqueue.
> 
> Do you mean zapping the entire page table (from root) doesn't need to be in RCU
> read-critical section, but can/should be done after grace period?  I think this
> makes sense since zapping entire root must happen when root is already invalid,
> which cannot be used anymore when the new faults come in?

Yes, minus the "from root" restriction.  When a page table (call it "branch" to
continue the analogy) PTE has been zapped/blocked ("pruned"), KVM just needs to
wait for all potential readers to go away.  That guarantee is provided by RCU;
software walkers, i.e. KVM itself, are required to hold RCU, and hardware walkers,
i.e. vCPUs running in the guest, are protected by proxy as the zapper ("arborist"?)
is required to hold RCU until all running vCPUs have been kicked.

In other words, once the PTE is zapped/blocked (branch is pruned), it's completely
removed from the paging tree and no other tasks can access the branch (page table
and its children).  I.e. the only remaining reference to the branch is the pointer
handed to the RCU callback.  That means the RCU callback has exclusive access to the
branch, i.e. can operate as if it were holding mmu_lock for write.  Furthermore, the
RCU callback also doesn't need to flush TLBs because that was again done when
pruning the branch.

It's the same idea that KVM already uses for root SPs, the only difference is how
KVM determines that there is exactly one entity that holds a reference to the SP.

> > Back to TDX, to play nice with the restriction that parents are removed only after
> > children are removed, I believe KVM can use TDH.MEM.RANGE.BLOCK to make the parent
> > !PRESENT.  That will effectively prune the S-EPT entry and all its children, and
> > the RCU callback will again ensure all in-flight SEAMCALLs for the children complete
> > before KVM actually tries to zap the children.
> 
> Reading the spec, it seems TDH.MEM.RANGE.BLOCK only sets the Secure EPT entry
> which points to the entire range as "blocked", but won't go down until leaf to
> mark all EPT entries as "blocked", which makes sense anyway.
> 
> But it seems TDH.MEM.PAGE.REMOVE and TDH.MEM.SEPT.REMOVE both only checks
> whether that target EPT entry is "blocked", but doesn't check whether any parent
> has been marked as "blocked".  Not sure whether this will be a problem.  But
> anyway if this is a problem, we perhaps can get TDX module to fix.

Oh, I didn't mean to suggest KVM skip TDH.MEM.RANGE.BLOCK for children, I simply
forgot that all S-EPT entries need to be blocked before they can be removed.

> > And if we rework zapping page tables, I suspect we can also address David's concern
> > (and my not-yet-voiced concern) about polluting the TDP MMU code with logic that is
> > necessary only for S-EPT (freezing SPTEs before populating them).  Rather than update
> > S-EPT _after_ the TDP MMU SPTE, do the S-EPT update first, i.e. invoke the KVM TDX
> > hook before try_cmpxchg64() (or maybe instead of?).  That way KVM TDX can freeze the
> > to-be-installed SPTE without common TDP MMU needing to be aware of the change.
> 
> I don't quite understand how putting SEAMCALL before the try_cmpxchg64() can
> work.  Let's say one thread is populating a mapping and another is zapping it. 
> The populating thread makes SEAMCALL successfully but then try_cmpxchg64()
> fails, in this case how to proceed?

Ah, sorry, that was unclear.  By "invoke the KVM TDX hook" I didn't mean "do the
SEAMCALL", I meant KVM TDX could do its own manipulation of the KVM-managed SPTEs
before the common/standard flow.  E.g. something like:

	if (kvm_x86_ops.set_private_spte && private)
		r = static_call(kvm_x86_set_private_spte(...)
	else
		r = try_cmpxchg64(...) ? 0 : -EBUSY;

so that the common code doesn't need to do, or even be aware of, the freezing.
Then I think we just need another hook in handle_removed_pt(), or maybe in what
is currently __kvm_tdp_mmu_write_spte()?

I.e. fully replace the "write" operations in the TDP MMU instead of trying to
smush S-EPT's requirements into the common path.
