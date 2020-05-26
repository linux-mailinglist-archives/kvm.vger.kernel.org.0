Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDB41E2352
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 15:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgEZNuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 09:50:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59284 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728218AbgEZNuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 09:50:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590500999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xFBlBZWC8AF7yCEYzueJxo7F/xZ4SJZE1DQ6e6ZS30Y=;
        b=AdrV5cjtZkt1KQnppcIKu+BDCxiKaxwzMfOpofupEioU9l0ko8f3y4+4YJWu9DyYFZC8LN
        SroSzvMhdHmE7q8hpyCnGWFuKdiu1+BLeOvcyqdL3U2/kvmuQ9ceDFBf6PBgNsFqU/ojQ/
        wbTlbVfdQU/FObsnIUWdACQ2laJp2go=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-gAEgq9_RM8eVtyvBHP7XPw-1; Tue, 26 May 2020 09:49:57 -0400
X-MC-Unique: gAEgq9_RM8eVtyvBHP7XPw-1
Received: by mail-qk1-f200.google.com with SMTP id d145so11999224qkg.22
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 06:49:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xFBlBZWC8AF7yCEYzueJxo7F/xZ4SJZE1DQ6e6ZS30Y=;
        b=d+UgOy9olXSoM8b8572bmi4swRWyz8CXoYQefa7jjuNepLZorr1cnT3LvaCfJkDr71
         b+nAaYZYCOOV8zva5OkNKfoMKrUpfJuz4k8MuDRov4WU73NUJwy4nh39cKQI/M2n+RCn
         MYc9rWaFArdHXHJ4pXtkbZg+Py2pQj7FA7TKEcKAjt+emHGKqyFHuwj0PjRyXgcArC/d
         PMVODZ/7sLsGrqkPEj8lE7Atf6Y5Q3PVXFFPWG3xn8Uq4kcS1LQTCCYwWlb9TJFzyeha
         BF7Sm4nmzFN2EKrghPPQGOqX434bZBtzx2Wp2wjO1uYW2RpdQBo2w3oyQtyuwNmeugQz
         DzoA==
X-Gm-Message-State: AOAM532e9KHUCHNGOrYSN3XvHbn0svNU16NMJcTbACgGVf07PUJ2Pbpb
        psSM7GteOT2ibDdsYXS9jiLVeNAQo0B75ePnQZTL6xR9U13l3cSGT8lItL5GBdEML6z5gpci8eF
        nSpADUUSMUzuU
X-Received: by 2002:a05:620a:21cc:: with SMTP id h12mr207241qka.194.1590500997235;
        Tue, 26 May 2020 06:49:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwW+SJpicJXuqvl2lxXngg9xX37ULjP0/u82Jcjf9Mx/AgkgHJKX/7o1q0P2H2FDSQOAsLqYA==
X-Received: by 2002:a05:620a:21cc:: with SMTP id h12mr207200qka.194.1590500996867;
        Tue, 26 May 2020 06:49:56 -0700 (PDT)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id d78sm2522059qkg.106.2020.05.26.06.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 06:49:55 -0700 (PDT)
Date:   Tue, 26 May 2020 09:49:54 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, cai@lca.pw,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v3 3/3] vfio-pci: Invalidate mmaps and block MMIO access
 on disabled memory
Message-ID: <20200526134954.GA1125781@xz-x1>
References: <20200523193417.GI766834@xz-x1>
 <20200523170602.5eb09a66@x1.home>
 <20200523235257.GC939059@xz-x1>
 <20200525122607.GC744@ziepe.ca>
 <20200525142806.GC1058657@xz-x1>
 <20200525144651.GE744@ziepe.ca>
 <20200525151142.GE1058657@xz-x1>
 <20200525165637.GG744@ziepe.ca>
 <3d9c1c8b-5278-1c4d-0e9c-e6f8fdb75853@nvidia.com>
 <20200526003705.GK744@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200526003705.GK744@ziepe.ca>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 09:37:05PM -0300, Jason Gunthorpe wrote:
> On Mon, May 25, 2020 at 01:56:28PM -0700, John Hubbard wrote:
> > On 2020-05-25 09:56, Jason Gunthorpe wrote:
> > > On Mon, May 25, 2020 at 11:11:42AM -0400, Peter Xu wrote:
> > > > On Mon, May 25, 2020 at 11:46:51AM -0300, Jason Gunthorpe wrote:
> > > > > On Mon, May 25, 2020 at 10:28:06AM -0400, Peter Xu wrote:
> > > > > > On Mon, May 25, 2020 at 09:26:07AM -0300, Jason Gunthorpe wrote:
> > > > > > > On Sat, May 23, 2020 at 07:52:57PM -0400, Peter Xu wrote:
> > > > > > > 
> > > > > > > > For what I understand now, IMHO we should still need all those handlings of
> > > > > > > > FAULT_FLAG_RETRY_NOWAIT like in the initial version.  E.g., IIUC KVM gup will
> > > > > > > > try with FOLL_NOWAIT when async is allowed, before the complete slow path.  I'm
> > > > > > > > not sure what would be the side effect of that if fault() blocked it.  E.g.,
> > > > > > > > the caller could be in an atomic context.
> > > > > > > 
> > > > > > > AFAICT FAULT_FLAG_RETRY_NOWAIT only impacts what happens when
> > > > > > > VM_FAULT_RETRY is returned, which this doesn't do?
> > > > > > 
> > > > > > Yes, that's why I think we should still properly return VM_FAULT_RETRY if
> > > > > > needed..  because IMHO it is still possible that the caller calls with
> > > > > > FAULT_FLAG_RETRY_NOWAIT.
> > > > > > 
> > > > > > My understanding is that FAULT_FLAG_RETRY_NOWAIT majorly means:
> > > > > > 
> > > > > >    - We cannot release the mmap_sem, and,
> > > > > >    - We cannot sleep
> > > > > 
> > > > > Sleeping looks fine, look at any FS implementation of fault, say,
> > > > > xfs. The first thing it does is xfs_ilock() which does down_write().
> > > > 
> > > > Yeah.  My wild guess is that maybe fs code will always be without
> > > > FAULT_FLAG_RETRY_NOWAIT so it's safe to sleep unconditionally (e.g., I think
> > > > the general #PF should be fine to sleep in fault(); gup should be special, but
> > > > I didn't observe any gup code called upon file systems)?
> > > 
> > > get_user_pages is called on filesystem backed pages.
> > > 
> > > I have no idea what FAULT_FLAG_RETRY_NOWAIT is supposed to do. Maybe
> > > John was able to guess when he reworked that stuff?
> > > 
> > 
> > Although I didn't end up touching that particular area, I'm sure it's going
> > to come up sometime soon, so I poked around just now, and found that
> > FAULT_FLAG_RETRY_NOWAIT was added almost exactly 9 years ago. This flag was
> > intended to make KVM and similar things behave better when doing GUP on
> > file-backed pages that might, or might not be in memory.
> > 
> > The idea is described in the changelog, but not in the code comments or
> > Documentation, sigh:
> > 
> > commit 318b275fbca1ab9ec0862de71420e0e92c3d1aa7
> > Author: Gleb Natapov <gleb@redhat.com>
> > Date:   Tue Mar 22 16:30:51 2011 -0700
> > 
> >     mm: allow GUP to fail instead of waiting on a page
> > 
> >     GUP user may want to try to acquire a reference to a page if it is already
> >     in memory, but not if IO, to bring it in, is needed.  For example KVM may
> >     tell vcpu to schedule another guest process if current one is trying to
> >     access swapped out page.  Meanwhile, the page will be swapped in and the
> >     guest process, that depends on it, will be able to run again.
> > 
> >     This patch adds FAULT_FLAG_RETRY_NOWAIT (suggested by Linus) and
> >     FOLL_NOWAIT follow_page flags.  FAULT_FLAG_RETRY_NOWAIT, when used in
> >     conjunction with VM_FAULT_ALLOW_RETRY, indicates to handle_mm_fault that
> >     it shouldn't drop mmap_sem and wait on a page, but return VM_FAULT_RETRY
> >     instead.
> 
> So, from kvm's perspective it was to avoid excessively long blocking in
> common paths when it could rejoin the completed IO by somehow waiting
> on a page itself?
> 
> It all seems like it should not be used unless the page is going to go
> to IO?

I think NOWAIT is used as a common flag for kvm for its initial attempt to
fault in a normal page, however...  I just noticed another fact that actually
__get_user_pages() won't work with PFNMAP (check_vma_flags should fail), but
KVM just started to support fault() for PFNMAP from commit add6a0cd1c5b (2016)
using fixup_user_fault(), where nvidia seems to have a similar request to have
a fault handler on some mapped BARs.

> 
> Certainly there is no reason to optimize the fringe case of vfio
> sleeping if there is and incorrect concurrnent attempt to disable the
> a BAR.

If fixup_user_fault() (which is always with ALLOW_RETRY && !RETRY_NOWAIT) is
the only path for the new fault(), then current way seems ok.  Not sure whether
this would worth a WARN_ON_ONCE(RETRY_NOWAIT) in the fault() to be clear of
that fact.

Thanks,

-- 
Peter Xu

