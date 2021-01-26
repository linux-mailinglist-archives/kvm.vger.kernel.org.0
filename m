Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F757304CA6
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 23:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730603AbhAZWvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728187AbhAZWKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 17:10:32 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66059C061574
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 14:09:17 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id u11so10521566plg.13
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 14:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DgOOJIyrAOuxKdxDbP3b0J4w0iC1eThFFRxXm6cvjxI=;
        b=CvYDmm1zk+RbauYp2TZpO4RuyHkMi4wG1dsuBQ/xWsV54jtSA/nrsS6AhIRTlVkkNl
         oIaY9/Rw9m3nG+tMnJbuLXjpgpcSUIdSxMLM36caHJP4cCWQ9zeDmq3iugY2q7ydm4C7
         eOZuxF58jcMyMFoOJx4D3wkh+8oF5OLqRDjynEcXWpB8IY/xytryiQKl2HrNzn1Hyt+e
         J8x2K9IDK+0+rbWcmSGr7cKSNuxmuv/rTvbiEJIzEo4e2fRcIcrq5DZWXw0VAVBptoIv
         eHPJDIUlf/eojUvjZHAyomohaSlAL1Qs7q85F4BEhFB9Ax+guZekffwDPn3RHhGgyhH9
         t0pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DgOOJIyrAOuxKdxDbP3b0J4w0iC1eThFFRxXm6cvjxI=;
        b=adjTRYwfPG8N+uyEjc/UP2Aw6C5uhoDOaZgLhRR0T1OVcX77Ri+Yp6KkO5kcSdE7E9
         OPIqcW2vX4V2u4I/1mbSF7k0YgH9onA2GDP+868ULQajnN6a+5m6iy9qPeq8BhgdIkCg
         PJoMkJmp4/j8L2k7ArVOilEfV+viY330KsLSUMQvBXpnsluFQ5QVdVKpugtZiTMVuTK8
         vsd03gPlR1ZnrUdCsPEHu9WA5r/8qdnnvQdvMi1QEuN5hnAYOs35HDNanFPWdHxXfRbS
         vmLS0VtrgJmlbTkoCKnVQvUwpbkmtjZB/MMD1UlqcxGEbqpRpscTBNvlfU3jE0OSd1JZ
         S+2g==
X-Gm-Message-State: AOAM53102iuYwyDEn84y1667HIStFSpslYSKtMOeVP+nNgTrb3TQJw8E
        xFrktIvwF6kpMhMsfcxLsX15Lw==
X-Google-Smtp-Source: ABdhPJybnmUC10oi234Kov3s2eFe5NF1KW540CcpuQHQBb+AF8FvAEuefidt3+eCxyDGfmGm+EZGwg==
X-Received: by 2002:a17:902:9349:b029:df:fab3:64b8 with SMTP id g9-20020a1709029349b02900dffab364b8mr7892559plp.72.1611698956642;
        Tue, 26 Jan 2021 14:09:16 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id n1sm2886909pjv.47.2021.01.26.14.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 14:09:15 -0800 (PST)
Date:   Tue, 26 Jan 2021 14:09:09 -0800
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
Subject: Re: [PATCH 19/24] kvm: x86/mmu: Protect tdp_mmu_pages with a lock
Message-ID: <YBCTBQ4lfJQ51Imn@google.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-20-bgardon@google.com>
 <YAnUhCocizx97FWL@google.com>
 <YAnzB3Uwn3AVTXGN@google.com>
 <335d27f7-0849-de37-f380-a5018c5c5535@redhat.com>
 <YBCRcalZJwAlkO9F@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBCRcalZJwAlkO9F@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 26, 2021, Sean Christopherson wrote:
> On Tue, Jan 26, 2021, Paolo Bonzini wrote:
> > On 21/01/21 22:32, Sean Christopherson wrote:
> > > Coming back to this series, I wonder if the RCU approach is truly necessary to
> > > get the desired scalability.  If both zap_collapsible_sptes() and NX huge page
> > > recovery zap_only_  leaf SPTEs, then the only path that can actually unlink a
> > > shadow page while holding the lock for read is the page fault path that installs
> > > a huge page over an existing shadow page.
> > > 
> > > Assuming the above analysis is correct, I think it's worth exploring alternatives
> > > to using RCU to defer freeing the SP memory, e.g. promoting to a write lock in
> > > the specific case of overwriting a SP (though that may not exist for rwlocks),
> > > or maybe something entirely different?
> > 
> > You can do the deferred freeing with a short write-side critical section to
> > ensure all readers have terminated.
> 
> Hmm, the most obvious downside I see is that the zap_collapsible_sptes() case
> will not scale as well as the RCU approach.  E.g. the lock may be heavily
> contested when refaulting all of guest memory to (re)install huge pages after a
> failed migration.
> 
> Though I wonder, could we do something even more clever for that particular
> case?  And I suppose it would apply to NX huge pages as well.  Instead of
> zapping the leaf PTEs and letting the fault handler install the huge page, do an
> in-place promotion when dirty logging is disabled.  That could all be done under
> the read lock, and with Paolo's method for deferred free on the back end.  That
> way only the thread doing the memslot update would take mmu_lock for write, and
> only once per memslot update.

Oh, and we could even skip the remote TLB flush in that case since the GPA->HPA
translation is unchanged.
