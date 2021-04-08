Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF25358035
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 12:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhDHKF3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 06:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbhDHKF2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 06:05:28 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998E0C061762
        for <kvm@vger.kernel.org>; Thu,  8 Apr 2021 03:05:17 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id 12so1474604wrz.7
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 03:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=36bvTqcToGLAmD+a9gwi7UztJJlmmlryLAr2BU8KQ8s=;
        b=lIdZTKCpObM4Wmr4t/JuIwVigP9bm6yi8C5UN+QUf40InjOtA1Jdt5+tp80w3zNnQo
         VlSZtKdBmzi+ZwGrhGIMLGEyI3q+id+HoCUH4Q4tHYGMh2RoGkmAJXhHhZHaecvlKMmC
         QlFz7G/ND8mE2P823Sob9sGXYc3DtI/97X/D0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=36bvTqcToGLAmD+a9gwi7UztJJlmmlryLAr2BU8KQ8s=;
        b=egZwFjfrYsg+DiHUvan7HLf14qUlzgPNuOv4fic3J/GCb+Mn7MYvJCYS73s4vLwIAt
         vxYhc+OERZxGGSTkRYBBDa+75LurhYbFpKxM6UxPN37QWinaTW0TU4qjHhF28vSQI35h
         qi4YMP1fkpo0lw8pkDepN98mvGFmhYvjg24Xi5C/Eb54Yl145JBOvMyO97ohQsA78l7Z
         aS7sKn/WP2ssp2Sk4PNOHa4soB/4iz376kalbuxP+ttKHKJcEuxfJuj88AZ9j1uO9VrE
         8h0Mb/jc/cqDs/CWKXYq1OG7IbrFaSqoRkq/dLDSNRcn0Y34Myee061uWNoEpoC5oFIH
         lWAw==
X-Gm-Message-State: AOAM530rSZla1tOYC8ltqkrrforSx/mWYDCIajvBA2XUZXgx8efTBzdV
        ohX7QITG/6ezilr63lsUZG1IOA==
X-Google-Smtp-Source: ABdhPJzpwqYXCVUB+8r0nQC2/W7H7J7o+XDWVlyU4mTtGNJrkB+UEdkDLgvXZNrPAgIv0wJQsQSfww==
X-Received: by 2002:adf:f692:: with SMTP id v18mr713305wrp.206.1617876316263;
        Thu, 08 Apr 2021 03:05:16 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id l4sm12802446wmh.8.2021.04.08.03.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 03:05:15 -0700 (PDT)
Date:   Thu, 8 Apr 2021 12:05:13 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        3pvd@google.com, Jann Horn <jannh@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH 3/3] mm: unexport follow_pfn
Message-ID: <YG7VWWkvnv2IPEXt@phenom.ffwll.local>
Mail-Followup-To: Jason Gunthorpe <jgg@nvidia.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        3pvd@google.com, Jann Horn <jannh@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, Peter Xu <peterx@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Daniel Vetter <daniel.vetter@intel.com>
References: <20210316153303.3216674-1-daniel.vetter@ffwll.ch>
 <20210316153303.3216674-4-daniel.vetter@ffwll.ch>
 <20210329133101.GA1168973@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329133101.GA1168973@nvidia.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 29, 2021 at 10:31:01AM -0300, Jason Gunthorpe wrote:
> On Tue, Mar 16, 2021 at 04:33:03PM +0100, Daniel Vetter wrote:
> > Both kvm (in bd2fae8da794 ("KVM: do not assume PTE is writable after
> > follow_pfn")) and vfio (in 07956b6269d3 ("vfio/type1: Use
> > follow_pte()")) have lost their callsites of follow_pfn(). All the
> > other ones have been switched over to unsafe_follow_pfn because they
> > cannot be fixed without breaking userspace api.
> > 
> > Argueably the vfio code is still racy, but that's kinda a bigger
> 
> vfio and kvm

Hm I thought kvm is non-racy due to the mmu notifier catch races?

> 
> > picture. But since it does leak the pte beyond where it drops the pt
> > lock, without anything else like an mmu notifier guaranteeing
> > coherence, the problem is at least clearly visible in the vfio code.
> > So good enough with me.
> > 
> > I've decided to keep the explanation that after dropping the pt lock
> > you must have an mmu notifier if you keep using the pte somehow by
> > adjusting it and moving it into the kerneldoc for the new follow_pte()
> > function.
> > 
> > Cc: 3pvd@google.com
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Cornelia Huck <cohuck@redhat.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: linux-mm@kvack.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-samsung-soc@vger.kernel.org
> > Cc: linux-media@vger.kernel.org
> > Cc: kvm@vger.kernel.org
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > --- 
> >  include/linux/mm.h |  2 --
> >  mm/memory.c        | 26 +++++---------------------
> >  mm/nommu.c         | 13 +------------
> >  3 files changed, 6 insertions(+), 35 deletions(-)
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks for your r-b tags, I'll add them.
-Daniel

> 
> Jason

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
