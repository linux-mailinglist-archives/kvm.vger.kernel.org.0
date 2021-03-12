Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7A6339744
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 20:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbhCLTQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 14:16:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20191 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234107AbhCLTQT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 14:16:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615576579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eVjqGVZoICZZjA+qkatGRQYeCm6jx7YodrGSvV5+S90=;
        b=Au1EWyutCzHzi+eISnEoBTD1rNGCXcLDkwEtukVw3jWuQGombLxYOMasRY7I6mRBKBMKE6
        c5rZfUoXYPyZG5NV5JJC2B2i7WmGB82Vmt1iU3ZNHnqcG3oKpYBJsT8JfVARln4h/pWYFK
        PMhmP9xkrZd7P//T1f51YDzed5OaEh0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-uj7z9W6YNL-MpJWmBlCUfA-1; Fri, 12 Mar 2021 14:16:17 -0500
X-MC-Unique: uj7z9W6YNL-MpJWmBlCUfA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07141800D55;
        Fri, 12 Mar 2021 19:16:16 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F13B60CD1;
        Fri, 12 Mar 2021 19:16:12 +0000 (UTC)
Date:   Fri, 12 Mar 2021 12:16:11 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com, prime.zeng@hisilicon.com, cohuck@redhat.com
Subject: Re: [PATCH] vfio/pci: Handle concurrent vma faults
Message-ID: <20210312121611.07a313e3@omen.home.shazbot.org>
In-Reply-To: <20210310184011.GA2356281@nvidia.com>
References: <161539852724.8302.17137130175894127401.stgit@gimli.home>
        <20210310181446.GZ2356281@nvidia.com>
        <20210310113406.6f029fcf@omen.home.shazbot.org>
        <20210310184011.GA2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Mar 2021 14:40:11 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Mar 10, 2021 at 11:34:06AM -0700, Alex Williamson wrote:
> 
> > > I think after the address_space changes this should try to stick with
> > > a normal io_rmap_pfn_range() done outside the fault handler.  
> > 
> > I assume you're suggesting calling io_remap_pfn_range() when device
> > memory is enabled,  
> 
> Yes, I think I saw Peter thinking along these lines too
> 
> Then fault just always causes SIGBUS if it gets called

Trying to use the address_space approach because otherwise we'd just be
adding back vma list tracking, it looks like we can't call
io_remap_pfn_range() while holding the address_space i_mmap_rwsem via
i_mmap_lock_write(), like done in unmap_mapping_range().  lockdep
identifies a circular lock order issue against fs_reclaim.  Minimally we
also need vma_interval_tree_iter_{first,next} exported in order to use
vma_interval_tree_foreach().  Suggestions?  Thanks,

Alex

