Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46D92888FB
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 14:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387579AbgJIMjz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 08:39:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgJIMjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 08:39:55 -0400
Received: from coco.lan (ip5f5ad5d0.dynamic.kabel-deutschland.de [95.90.213.208])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85AD3222B8;
        Fri,  9 Oct 2020 12:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602247193;
        bh=ruA15GjB/fFH2gJQRaoGIXfNQO5QPyDiPzMmJhWfrxQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ebPwE13hJTyu7GU7hqGujNTcQ3SJtz+JCoKsDWHQbhtRGSTdSLTjnjECptwHYqY3q
         MKQ41Y6J0y7haidc1ZWrDQLUW0A2sUpIAG5O9TanLsaA0fGLcNuObliZM9g/MbS7s+
         gKoB0ZuFxhI8SXftz7+Nxh4xSbD62xyIpNDeilOA=
Date:   Fri, 9 Oct 2020 14:39:47 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 09/17] mm: Add unsafe_follow_pfn
Message-ID: <20201009143947.751c5eb1@coco.lan>
In-Reply-To: <20201009143723.45609bfb@coco.lan>
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
        <20201009075934.3509076-10-daniel.vetter@ffwll.ch>
        <20201009123421.67a80d72@coco.lan>
        <20201009122111.GN5177@ziepe.ca>
        <20201009143723.45609bfb@coco.lan>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Em Fri, 9 Oct 2020 14:37:23 +0200
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> escreveu:

> Em Fri, 9 Oct 2020 09:21:11 -0300
> Jason Gunthorpe <jgg@ziepe.ca> escreveu:
> 
> > On Fri, Oct 09, 2020 at 12:34:21PM +0200, Mauro Carvalho Chehab wrote:  
> > > Hi,
> > > 
> > > Em Fri,  9 Oct 2020 09:59:26 +0200
> > > Daniel Vetter <daniel.vetter@ffwll.ch> escreveu:
> > >     
> > > > Way back it was a reasonable assumptions that iomem mappings never
> > > > change the pfn range they point at. But this has changed:
> > > > 
> > > > - gpu drivers dynamically manage their memory nowadays, invalidating
> > > > ptes with unmap_mapping_range when buffers get moved
> > > > 
> > > > - contiguous dma allocations have moved from dedicated carvetouts to
> > > > cma regions. This means if we miss the unmap the pfn might contain
> > > > pagecache or anon memory (well anything allocated with GFP_MOVEABLE)
> > > > 
> > > > - even /dev/mem now invalidates mappings when the kernel requests that
> > > > iomem region when CONFIG_IO_STRICT_DEVMEM is set, see 3234ac664a87
> > > > ("/dev/mem: Revoke mappings when a driver claims the region")
> > > > 
> > > > Accessing pfns obtained from ptes without holding all the locks is
> > > > therefore no longer a good idea.
> > > > 
> > > > Unfortunately there's some users where this is not fixable (like v4l
> > > > userptr of iomem mappings) or involves a pile of work (vfio type1
> > > > iommu). For now annotate these as unsafe and splat appropriately.
> > > > 
> > > > This patch adds an unsafe_follow_pfn, which later patches will then
> > > > roll out to all appropriate places.    
> > > 
> > > NACK, as this breaks an existing userspace API on media.    
> > 
> > It doesn't break it. You get a big warning the thing is broken and it
> > keeps working.
> > 
> > We can't leave such a huge security hole open - it impacts other
> > subsystems, distros need to be able to run in a secure mode.  
> 
> Well, if distros disable it, then apps will break.
> 
> > > While I agree that using the userptr on media is something that
> > > new drivers may not support, as DMABUF is a better way of
> > > handling it, changing this for existing ones is a big no, 
> > > as it may break usersapace.    
> > 
> > media community needs to work to fix this, not pretend it is OK to
> > keep going as-is.  
> 
> > Dealing with security issues is the one case where an uABI break might
> > be acceptable.
> > 
> > If you want to NAK it then you need to come up with the work to do
> > something here correctly that will support the old drivers without the
> > kernel taint.
> > 
> > Unfortunately making things uncomfortable for the subsystem is the big
> > hammer the core kernel needs to use to actually get this security work
> > done by those responsible.  
> 
> 
> I'm not pretending that this is ok. Just pointing that the approach
> taken is NOT OK.
> 
> I'm not a mm/ expert, but, from what I understood from Daniel's patch
> description is that this is unsafe *only if*  __GFP_MOVABLE is used.
> 
> Well, no drivers inside the media subsystem uses such flag, although
> they may rely on some infrastructure that could be using it behind
> the bars.
> 
> If this is the case, the proper fix seems to have a GFP_NOT_MOVABLE 
> flag that it would be denying the core mm code to set __GFP_MOVABLE.
> 
> Please let address the issue on this way, instead of broken an
> userspace API that it is there since 1991.

In time: I meant to say 1998.

Thanks,
Mauro
