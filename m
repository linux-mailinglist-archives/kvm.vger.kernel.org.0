Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E90C288889
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 14:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732594AbgJIMVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 08:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731081AbgJIMVN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 08:21:13 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E36CC0613D8
        for <kvm@vger.kernel.org>; Fri,  9 Oct 2020 05:21:13 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id p88so746223qtd.12
        for <kvm@vger.kernel.org>; Fri, 09 Oct 2020 05:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GEBFnNzCc2Aa+VvpaaWfqgqAphuQOGzaQHxTmQfOeXI=;
        b=dRexUDY3H8MczQ4QLPjINl81RcewsEJoOwrcRnS/wdN6+1ahY+3vJqHFQSRB3AKEat
         Z5ZaXXZPosq4Wbd2jnV/U3qSyNEiSVNzFD8cJAswQl5FTJES+qJJJxPuS2/N1xstVsKE
         DmLKmIoNq1PULtGkiX9+m6e1iqZaCGoeY5Z+TbjwSmpmk3vladKQnD3eC3IjfehfAuWk
         OAoO3ZuMd+rz9DNMaLq4YRdS5/enCBHoI5KrUmpa+3FN6vqOFl+XYKf3xsXAEqCHUZGe
         a3qzy4AHPVKLKT9jFp2Z0TSDspqDK1w0Z9U5mPCKkR2TBx/oNoqCaY/YIuclFEo3wtty
         CzGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GEBFnNzCc2Aa+VvpaaWfqgqAphuQOGzaQHxTmQfOeXI=;
        b=ie3MnkfnToxBvP6QAQMnKhDgdzb6f0Ec8w10O3uDS7/8P0nMJUwr+eNikXj6ikyJqb
         IJq/q0rcd8lcOWjb75lEZ4ScvkT7YbllEUITO76qrHTyuxgt+7sMhLNBerM5Rmymh6xx
         tmirTcCe/mB7VlKifGjLktOlANqg/gfBitBnXm9dGrAfTmxzZA9ZQ2j/pJzxi3siMVdj
         AX29vb966tE8a33IiLcFmmadmanj2y8yR3mFplICG2GRIhTGL+FSoXBRvudCVkvAm38z
         Uuk7pFRJ3gt7Q7Eqve+HpX9TLkCapRhhpSUJBniK3C/lvUZqTh/pJE48fZGq14S2xCOM
         Z/1Q==
X-Gm-Message-State: AOAM530AJx2NQiRxtxJdnk3y2UoGdRLKpSfrWtOvek/CRHlYfCGabVtL
        +IJhD6ammKIEjzUSptjiK4/ddw==
X-Google-Smtp-Source: ABdhPJxabis31V1ruCjg81xS+awnWmlIxScXs/iSYcl2LZthnsEHjAadouQof92mVKkzbF3fOMDQng==
X-Received: by 2002:ac8:1910:: with SMTP id t16mr12554428qtj.351.1602246072505;
        Fri, 09 Oct 2020 05:21:12 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id x7sm3318061qkc.24.2020.10.09.05.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 05:21:11 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kQrOZ-001xjJ-2z; Fri, 09 Oct 2020 09:21:11 -0300
Date:   Fri, 9 Oct 2020 09:21:11 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
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
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 09/17] mm: Add unsafe_follow_pfn
Message-ID: <20201009122111.GN5177@ziepe.ca>
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
 <20201009075934.3509076-10-daniel.vetter@ffwll.ch>
 <20201009123421.67a80d72@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009123421.67a80d72@coco.lan>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 09, 2020 at 12:34:21PM +0200, Mauro Carvalho Chehab wrote:
> Hi,
> 
> Em Fri,  9 Oct 2020 09:59:26 +0200
> Daniel Vetter <daniel.vetter@ffwll.ch> escreveu:
> 
> > Way back it was a reasonable assumptions that iomem mappings never
> > change the pfn range they point at. But this has changed:
> > 
> > - gpu drivers dynamically manage their memory nowadays, invalidating
> > ptes with unmap_mapping_range when buffers get moved
> > 
> > - contiguous dma allocations have moved from dedicated carvetouts to
> > cma regions. This means if we miss the unmap the pfn might contain
> > pagecache or anon memory (well anything allocated with GFP_MOVEABLE)
> > 
> > - even /dev/mem now invalidates mappings when the kernel requests that
> > iomem region when CONFIG_IO_STRICT_DEVMEM is set, see 3234ac664a87
> > ("/dev/mem: Revoke mappings when a driver claims the region")
> > 
> > Accessing pfns obtained from ptes without holding all the locks is
> > therefore no longer a good idea.
> > 
> > Unfortunately there's some users where this is not fixable (like v4l
> > userptr of iomem mappings) or involves a pile of work (vfio type1
> > iommu). For now annotate these as unsafe and splat appropriately.
> > 
> > This patch adds an unsafe_follow_pfn, which later patches will then
> > roll out to all appropriate places.
> 
> NACK, as this breaks an existing userspace API on media.

It doesn't break it. You get a big warning the thing is broken and it
keeps working.

We can't leave such a huge security hole open - it impacts other
subsystems, distros need to be able to run in a secure mode.

> While I agree that using the userptr on media is something that
> new drivers may not support, as DMABUF is a better way of
> handling it, changing this for existing ones is a big no, 
> as it may break usersapace.

media community needs to work to fix this, not pretend it is OK to
keep going as-is.

Dealing with security issues is the one case where an uABI break might
be acceptable.

If you want to NAK it then you need to come up with the work to do
something here correctly that will support the old drivers without the
kernel taint.

Unfortunately making things uncomfortable for the subsystem is the big
hammer the core kernel needs to use to actually get this security work
done by those responsible.

Jason
