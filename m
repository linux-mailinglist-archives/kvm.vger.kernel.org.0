Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3895D392225
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 23:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhEZVgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 17:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbhEZVgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 17:36:23 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBA9C06175F
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 14:34:51 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id b7so1306818plg.0
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 14:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7VMYKzcvlmsaJsduijRinX5XOX/CXS23jVd0dixyLbI=;
        b=ie4BpCnntunaA4LGbURImMIKM08qZ48fG66Dt4d1CY7m+bmY3prfw3Evt/EvOnwkOv
         TN5wWKlaO8tHkc7V8lcvoKpwu78eWRa+5GwNc5YtIjXeBM4WM28fqhhTLvLcY6q91HOu
         O4waTVlnqTioDn7baVA84CHP+a25fcFR9pIcrBOjFg3+rDPj4vaQfi+lJpgGMGyufy4F
         Vq8ToRbH++LEDoYvTuxK8e7Q8sLys7NR76/vP9B9HTA9W/q+t+1lP5ohC/UPyY7+tvW1
         rsk7nPVcKA+SFs9DjNoAqokLtmR94Sa5wOKCpgNaVYk/43e2uFiMOwCid6aEBkq47W2m
         mNXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7VMYKzcvlmsaJsduijRinX5XOX/CXS23jVd0dixyLbI=;
        b=Zv7OiGy4y/ke9R+ta3Xm5QgblDD/RSOWaszuF4CX7JWM6YWRbwW9QuS5JsZGBteqba
         /ZlYPCxayaKyahuyF6zVVHQLmUGQUisHUCpsDvZ44ukz8w0z15D/jRlluiofBiydkrRS
         MFxwK9h6HfGr3fhPgWWguFFPDuE4Kuk7rlOhTQ8LpQ7n87F/iHT/1xNG432sdRn+V7Tx
         Erj6qWqJMTP9Kec2u5sjEzJD+l07t34O8g7yNgXhMIORp6DCDPSZd84yc2mVHCDqUIli
         rjzOuEP7PO4Uf3Emc0hAM8JQhEH0eUAzbkzePkQK7dhzT7GnlzIhaKlQbYQ9CgR6W4OJ
         vitA==
X-Gm-Message-State: AOAM531eVQBZ9tbBCy7CZW6akHMDP/kKc2jIeid3Ax+kehVQKu8TOiKa
        dt3Hsec26XZ6QERFrc/e4wEvVw==
X-Google-Smtp-Source: ABdhPJzJ+L9n0bvK/LiHvOSETtHso7f3OjuKFCauJaw+Q+/r06x4YdSHqJ6BlK3t0LLt5XD+mbFNaQ==
X-Received: by 2002:a17:90b:607:: with SMTP id gb7mr227800pjb.5.1622064890746;
        Wed, 26 May 2021 14:34:50 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id c130sm144294pfc.51.2021.05.26.14.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 14:34:50 -0700 (PDT)
Date:   Wed, 26 May 2021 21:34:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH v2 00/13] More parallel operations for the TDP MMU
Message-ID: <YK6+9lmToiFTpvmq@google.com>
References: <20210401233736.638171-1-bgardon@google.com>
 <c630df18-c1af-8ece-37d2-3db5dc18ecc8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c630df18-c1af-8ece-37d2-3db5dc18ecc8@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 02, 2021, Paolo Bonzini wrote:
> On 02/04/21 01:37, Ben Gardon wrote:
> > Now that the TDP MMU is able to handle page faults in parallel, it's a
> > relatively small change to expand to other operations. This series allows
> > zapping a range of GFNs, reclaiming collapsible SPTEs (when disabling
> > dirty logging), and enabling dirty logging to all happen under the MMU
> > lock in read mode.
> > 
> > This is partly a cleanup + rewrite of the last few patches of the parallel
> > page faults series. I've incorporated feedback from Sean and Paolo, but
> > the patches have changed so much that I'm sending this as a separate
> > series.
> > 
> > Ran kvm-unit-tests + selftests on an SMP kernel + Intel Skylake, with the
> > TDP MMU enabled and disabled. This series introduces no new failures or
> > warnings.
> > 
> > I know this will conflict horribly with the patches from Sean's series
> > which were just queued, and I'll send a v2 to fix those conflicts +
> > address any feedback on this v1.
> > 
> > Changelog
> > v2:
> > --	Rebased patches on top of kvm/queue to incorporate Sean's recent
> > 	TLB flushing changes
> > --	Dropped patch 5: "KVM: x86/mmu: comment for_each_tdp_mmu_root
> > 	requires MMU write lock" as the following patch to protect the roots
> > 	list with RCU adds lockdep which makes the comment somewhat redundant.
> > 
> > Ben Gardon (13):
> >    KVM: x86/mmu: Re-add const qualifier in
> >      kvm_tdp_mmu_zap_collapsible_sptes
> >    KVM: x86/mmu: Move kvm_mmu_(get|put)_root to TDP MMU
> >    KVM: x86/mmu: use tdp_mmu_free_sp to free roots
> >    KVM: x86/mmu: Merge TDP MMU put and free root
> >    KVM: x86/mmu: Refactor yield safe root iterator
> >    KVM: x86/mmu: Make TDP MMU root refcount atomic
> >    KVM: x86/mmu: handle cmpxchg failure in kvm_tdp_mmu_get_root
> >    KVM: x86/mmu: Protect the tdp_mmu_roots list with RCU
> >    KVM: x86/mmu: Allow zap gfn range to operate under the mmu read lock
> >    KVM: x86/mmu: Allow zapping collapsible SPTEs to use MMU read lock
> >    KVM: x86/mmu: Allow enabling / disabling dirty logging under MMU read
> >      lock
> >    KVM: x86/mmu: Fast invalidation for TDP MMU
> >    KVM: x86/mmu: Tear down roots in fast invalidation thread
> > 
> >   arch/x86/include/asm/kvm_host.h |  21 +-
> >   arch/x86/kvm/mmu/mmu.c          | 115 +++++++---
> >   arch/x86/kvm/mmu/mmu_internal.h |  27 +--
> >   arch/x86/kvm/mmu/tdp_mmu.c      | 375 +++++++++++++++++++++++---------
> >   arch/x86/kvm/mmu/tdp_mmu.h      |  28 ++-
> >   include/linux/kvm_host.h        |   2 +-
> >   6 files changed, 407 insertions(+), 161 deletions(-)
> > 
> 
> Applied to kvm/mmu-notifier-queue, thanks.

What's the plan for kvm/mmu-notifier-queue?  More specifically, are the hashes
stable, i.e. will non-critical review feedback get squashed?  I was finally
getting around to reviewing this, but what's sitting in that branch doesn't
appear to be exactly what's posted here.  If the hashes are stable, I'll probably
test and review functionality, but not do a thorough review.

Thanks!
