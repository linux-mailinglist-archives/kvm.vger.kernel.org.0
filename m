Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826D21E2615
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 17:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731245AbgEZPxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 11:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729710AbgEZPxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 11:53:33 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824FAC03E96E
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 08:53:33 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id v15so9653091qvr.8
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 08:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jlzpUqOYdHV1vxWH1ghpZ5NGGPs3KIgh2WBW3uooNyo=;
        b=aOxeeiHs3Gji6/AEWR2ZvosQKYQBQENiEkhQwl1NKLn2O8TIhxXA5l5jX4IwCXpTNy
         LCe/8dGn9TpuIppdW2DyEuF5xO3Wu5PyEoimljK59a1Nm+wbIDPvNiMeQ0rIB6VR0L0A
         7vUw+l9TFFsVgnqBLpm+GQ/e+z2ikDYnGqFOzDtizixstcS8d0h9wKJuxDvLw7z2t5CF
         oM8HEcXf1ctNDH75ArYQ7Z86jPiVZ02Yz21UTZJ3wr6V4lfkUIUVGNBRuYHGVmL3yVSb
         q+IGL1+xtTMNSaJ3RzXqImGG3L8SG2cTydkGE/F1hqcrWzaqZvkYG/8WqhlVZTEjV1BF
         AZGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jlzpUqOYdHV1vxWH1ghpZ5NGGPs3KIgh2WBW3uooNyo=;
        b=ZUes7Zsewv/AwvYPHx0ubil9KPWhtInS7biUNCpXO6gV5IURIi+J6HbxKO3udjRvsW
         QnHBU+B56ZcbXLZ1ZmYBYuoQGCNzxd5e2Uz+l4LKr0xgE3UbvSZ0hwZ7L2MtLfaauugV
         fojMNwKl6xaO6gmEcDgT94E1lDHnqNfIuU13Bkjk26oq4nByJFkYeezLwLqITgEoppvG
         82z7f+wpQLJuaHNHb0E7IIB0trmlK56/TXBcTdJSvUg7UTZHskL/Ptz633zzZPUp1ZfP
         n08TvB9EOPcEkdFvBcGiQXW//dQjJ+cjyN6wJgC35dt0EcR5sPsZ8pMaD2POLgA5PS0Z
         ysJw==
X-Gm-Message-State: AOAM533WAunaWyFkJyROrLTiaYJnQXfbCG7myVBZk8DhYvH4IhaCN7ve
        /b26KvuLg3pHG/cCCEmZ56Zh0zoIRWs=
X-Google-Smtp-Source: ABdhPJzonweq5dYvv3Hmq6kHR/xpDqKc1wJWZ6DuU5wFcA1lHqG8wEGPtzkZiqfBxBTQ/1rffOABUQ==
X-Received: by 2002:a0c:ee25:: with SMTP id l5mr19982495qvs.5.1590508412775;
        Tue, 26 May 2020 08:53:32 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id v1sm21344qkb.19.2020.05.26.08.53.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 May 2020 08:53:32 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jdbtT-00012F-Km; Tue, 26 May 2020 12:53:31 -0300
Date:   Tue, 26 May 2020 12:53:31 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, John Hubbard <jhubbard@nvidia.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, cai@lca.pw,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v3 3/3] vfio-pci: Invalidate mmaps and block MMIO access
 on disabled memory
Message-ID: <20200526155331.GN744@ziepe.ca>
References: <20200523235257.GC939059@xz-x1>
 <20200525122607.GC744@ziepe.ca>
 <20200525142806.GC1058657@xz-x1>
 <20200525144651.GE744@ziepe.ca>
 <20200525151142.GE1058657@xz-x1>
 <20200525165637.GG744@ziepe.ca>
 <3d9c1c8b-5278-1c4d-0e9c-e6f8fdb75853@nvidia.com>
 <20200526003705.GK744@ziepe.ca>
 <20200526134954.GA1125781@xz-x1>
 <20200526083218.40402f01@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526083218.40402f01@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 26, 2020 at 08:32:18AM -0600, Alex Williamson wrote:
> > > Certainly there is no reason to optimize the fringe case of vfio
> > > sleeping if there is and incorrect concurrnent attempt to disable the
> > > a BAR.  
> > 
> > If fixup_user_fault() (which is always with ALLOW_RETRY && !RETRY_NOWAIT) is
> > the only path for the new fault(), then current way seems ok.  Not sure whether
> > this would worth a WARN_ON_ONCE(RETRY_NOWAIT) in the fault() to be clear of
> > that fact.
> 
> Thanks for the discussion over the weekend folks.  Peter, I take it
> you'd be satisfied if this patch were updated as:
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index aabba6439a5b..35bd7cd4e268 100644
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1528,6 +1528,13 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
>  	struct vfio_pci_device *vdev = vma->vm_private_data;
>  	vm_fault_t ret = VM_FAULT_NOPAGE;
>  
> +	/*
> +	 * We don't expect to be called with NOWAIT and there are conflicting
> +	 * opinions on whether NOWAIT suggests we shouldn't wait for locks or
> +	 * just shouldn't wait for I/O.
> +	 */
> +	WARN_ON_ONCE(vmf->flags & FAULT_FLAG_RETRY_NOWAIT);

I don't think this is right, this implies there is some reason this
code fails with FAULT_FLAG_RETRY_NOWAIT - but it is fine as written,
AFAICT

Jason
