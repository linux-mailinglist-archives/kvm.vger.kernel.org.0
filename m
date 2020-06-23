Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C004205BD7
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 21:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387464AbgFWTfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 15:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733248AbgFWTfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 15:35:00 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE32C061755
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 12:35:00 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id g11so10249706qvs.2
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 12:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TE5ntCaSpjYIzrnOzW7Fo/LNskIj78RHoGfLUiRTlbw=;
        b=qeiQ3FKTri5M91kFVxsMTf+0fB7T4iwOp/W2An9fLoEuPbnEyRRTQd7wzSv6AC3DKK
         KF/MfiSVlY3L2b5hjlABvii2s2RjpZ73gqhfljKv+ePyh62WoEctR9YXYhl3zOlDy81q
         +NdLvE5U4qwLfJji3/P5CywVp+59sMMi2ItU4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TE5ntCaSpjYIzrnOzW7Fo/LNskIj78RHoGfLUiRTlbw=;
        b=hq7yVCddeNsJIR2NSgqW92dL5cmocdHrzwGiyAFraqPGTSrbzXeJbDtzl7YrGRCNAX
         XlZXJ9TTm9WyGgsXkxyczfdv93pYvm4ZbI06LAG9xwOtVWa/8+RpGNvjdcYJUoiB5uRt
         DGsIgUp3zbNktBF4H9wRjl5/Z3xHjFGvORKicxVthtIl4TpV4xw6OXU/hqnWitk4yx0v
         fdDRIfpdpOYMTKrMooBKec4dqEnKdgcV8T8uI9G1ZU5SLgq/S9/f1jy3MCPneBrnB8SB
         FuHL3Fnm1FMx7SKuUtCT+CVHTsFElXm0tnVJIvnIzS9IDG0CJQC+cr0dLpRCXV4sFOCb
         KjXw==
X-Gm-Message-State: AOAM532n2ciAJCO2AkrCVmDaIM2CFMHcBssBu+e/DOE05EE1YpKM36Z/
        yASX9qBkJgjb4SSTC8vOFAx04A==
X-Google-Smtp-Source: ABdhPJxLQC4UWVYjtUxRiJ6yQzxY9atjusT3rDoIHP9nTyFYP2/e5AwX2hPF52Y9T4QGikRv+c/Urg==
X-Received: by 2002:ad4:55eb:: with SMTP id bu11mr27889598qvb.182.1592940899724;
        Tue, 23 Jun 2020 12:34:59 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id x11sm1345556qti.60.2020.06.23.12.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 12:34:59 -0700 (PDT)
Date:   Tue, 23 Jun 2020 15:34:58 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de,
        bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v2] kvm: Fix false positive RCU usage warning
Message-ID: <20200623193458.GB68372@google.com>
References: <20200516082227.22194-1-madhuparnabhowmik10@gmail.com>
 <9fff3c6b-1978-c647-16f7-563a1cdf62ff@redhat.com>
 <20200623150236.GD9005@google.com>
 <20200623153036.GB9914@madhuparna-HP-Notebook>
 <20200623153901.GG9247@paulmck-ThinkPad-P72>
 <20200623174920.GA13794@madhuparna-HP-Notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623174920.GA13794@madhuparna-HP-Notebook>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 11:19:20PM +0530, Madhuparna Bhowmik wrote:
> On Tue, Jun 23, 2020 at 08:39:01AM -0700, Paul E. McKenney wrote:
> > On Tue, Jun 23, 2020 at 09:00:36PM +0530, Madhuparna Bhowmik wrote:
> > > On Tue, Jun 23, 2020 at 11:02:36AM -0400, Joel Fernandes wrote:
> > > > On Tue, Jun 23, 2020 at 09:39:53AM +0200, Paolo Bonzini wrote:
> > > > > On 16/05/20 10:22, madhuparnabhowmik10@gmail.com wrote:
> > > > > > From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > > > > > 
> > > > > > Fix the following false positive warnings:
> > > > > > 
> > > > > > [ 9403.765413][T61744] =============================
> > > > > > [ 9403.786541][T61744] WARNING: suspicious RCU usage
> > > > > > [ 9403.807865][T61744] 5.7.0-rc1-next-20200417 #4 Tainted: G             L
> > > > > > [ 9403.838945][T61744] -----------------------------
> > > > > > [ 9403.860099][T61744] arch/x86/kvm/mmu/page_track.c:257 RCU-list traversed in non-reader section!!
> > > > > > 
> > > > > > and
> > > > > > 
> > > > > > [ 9405.859252][T61751] =============================
> > > > > > [ 9405.859258][T61751] WARNING: suspicious RCU usage
> > > > > > [ 9405.880867][T61755] -----------------------------
> > > > > > [ 9405.911936][T61751] 5.7.0-rc1-next-20200417 #4 Tainted: G             L
> > > > > > [ 9405.911942][T61751] -----------------------------
> > > > > > [ 9405.911950][T61751] arch/x86/kvm/mmu/page_track.c:232 RCU-list traversed in non-reader section!!
> > > > > > 
> > > > > > Since srcu read lock is held, these are false positive warnings.
> > > > > > Therefore, pass condition srcu_read_lock_held() to
> > > > > > list_for_each_entry_rcu().
> > > > > > 
> > > > > > Reported-by: kernel test robot <lkp@intel.com>
> > > > > > Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> > > > > > ---
> > > > > > v2:
> > > > > > -Rebase v5.7-rc5
> > > > > > 
> > > > > >  arch/x86/kvm/mmu/page_track.c | 6 ++++--
> > > > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > > > > 
> > > > > > diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
> > > > > > index ddc1ec3bdacd..1ad79c7aa05b 100644
> > > > > > --- a/arch/x86/kvm/mmu/page_track.c
> > > > > > +++ b/arch/x86/kvm/mmu/page_track.c
> > > > > > @@ -229,7 +229,8 @@ void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa, const u8 *new,
> > > > > >  		return;
> > > > > >  
> > > > > >  	idx = srcu_read_lock(&head->track_srcu);
> > > > > > -	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
> > > > > > +	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node,
> > > > > > +				srcu_read_lock_held(&head->track_srcu))
> > > > > >  		if (n->track_write)
> > > > > >  			n->track_write(vcpu, gpa, new, bytes, n);
> > > > > >  	srcu_read_unlock(&head->track_srcu, idx);
> > > > > > @@ -254,7 +255,8 @@ void kvm_page_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
> > > > > >  		return;
> > > > > >  
> > > > > >  	idx = srcu_read_lock(&head->track_srcu);
> > > > > > -	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node)
> > > > > > +	hlist_for_each_entry_rcu(n, &head->track_notifier_list, node,
> > > > > > +				srcu_read_lock_held(&head->track_srcu))
> > > > > >  		if (n->track_flush_slot)
> > > > > >  			n->track_flush_slot(kvm, slot, n);
> > > > > >  	srcu_read_unlock(&head->track_srcu, idx);
> > > > > > 
> > > > > 
> > > > > Hi, sorry for the delay in reviewing this patch.  I would like to ask
> > > > > Paul about it.
> > > > > 
> > > > > While you're correctly fixing a false positive, hlist_for_each_entry_rcu
> > > > > would have a false _negative_ if you called it under
> > > > > rcu_read_lock/unlock and the data structure was protected by SRCU.  This
> > > > > is why for example srcu_dereference is used instead of
> > > > > rcu_dereference_check, and why srcu_dereference uses
> > > > > __rcu_dereference_check (with the two underscores) instead of
> > > > > rcu_dereference_check.  Using rcu_dereference_check would add an "||
> > > > > rcu_read_lock_held()" to the condition which is wrong.
> > > > > 
> > > > > I think instead you should add hlist_for_each_srcu and
> > > > > hlist_for_each_entry_srcu macro to include/linux/rculist.h.
> > > > > 
> > > > > There is no need for equivalents of hlist_for_each_entry_continue_rcu
> > > > > and hlist_for_each_entry_from_rcu, because they use rcu_dereference_raw.
> > > > >  However, it's not documented why they do so.
> > > > 
> > > > You are right, this patch is wrong, we need a new SRCU list macro to do the
> > > > right thing which would also get rid of the last list argument.
> > > >
> > > Can we really get rid of the last argument? We would need the
> > > srcu_struct right for checking?
> > 
> > Agreed!  However, the API could be simplified by passing in a pointer to
> > the srcu_struct instead of a lockdep expression.  An optional lockdep
> > expression might still be helpful for calls from the update side,
> > of course.
> >
> Sure, I will work on this.

Cool, thanks !!!

 - Joel

