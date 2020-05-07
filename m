Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCFA1C9F58
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 01:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgEGX4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 19:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726464AbgEGX4g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 19:56:36 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDCFC05BD43
        for <kvm@vger.kernel.org>; Thu,  7 May 2020 16:56:35 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id f13so1667066qkh.2
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 16:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WNSSh316ySa201Mw7VrhiFHflm8/gYZAhfxV4vkg9go=;
        b=HR3vE013iVwpNgLVzcugwB62eaIb1ObojGm72k1rmY+iAQ05ZLmbJuOYu/hb6QZ497
         beZh8XJRTQw38o8hvBnQ/1q8ocb0HItnNKvYte9stjIRoIdXR7EBbIRmMzbdgOutp7ZI
         QIXENHvx//ZdN+aX1QKzM/JLZNXljfkGn3qFA4d+c7S/R5vZbKajEuLp33s7EyXuVV/5
         eZjp16y9105PYVVTa5/FLrahfgryd2jBPexTl82B1iJMJwdkArgwCw0fzHiVgPdiFu9G
         xODYqemERPonyu3uXaGYkQezbOluv94yBhrvHSe6BCdOHYmdaHw7DSSvdQB5A14EhKsT
         b+wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WNSSh316ySa201Mw7VrhiFHflm8/gYZAhfxV4vkg9go=;
        b=UzN5IltVufAi1FgUZTtY2Oa+pY3n1LxBoJuaVNnpnXd7BO7Xhj7nE5CrsQIWxDtDAh
         fQ7M//qmgHCSw1OXoFdFj9tbG7zpzCUrA0ylF4SqnK0yIAN4VkpcLWSzXtJY3h/spnw9
         434a2JH+DuLoNDnvHTXuOeI+jsdN86gGN52mMYQ6qnoBWGmmcG4C3ANNsokK1J47tXyy
         sOqyKuje/xjYVqaJp77det99BhnY+EykYrQpymvqXJkZq8W+KGJWTJ/H1G8mk3GC0Mrc
         QxVjIqnKwH0H/r1cUTcNK1SlMrrwQshnXFDAMT4x7hE+TeMDF5AJ985cbI31t3QKoZzJ
         ulew==
X-Gm-Message-State: AGi0PuYttqxen+nO4mGy7plaAEsq2nqNCrVV2uOHhmvlei95xdiVIM+9
        3VF9IyspCPbrOMnSenVQJI+UFg==
X-Google-Smtp-Source: APiQypIYvzBf9Aqa1dYsG0k4BynsrLNtV9jqu7uZFuNqpJi3UFDm3EaLM9lkfW+Gzlx0LdBPQvsRnA==
X-Received: by 2002:a37:9a13:: with SMTP id c19mr17192qke.51.1588895794222;
        Thu, 07 May 2020 16:56:34 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id k33sm58716qtd.22.2020.05.07.16.56.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 May 2020 16:56:33 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jWqNV-00072G-5V; Thu, 07 May 2020 20:56:33 -0300
Date:   Thu, 7 May 2020 20:56:33 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Peter Xu <peterx@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com
Subject: Re: [PATCH v2 2/3] vfio-pci: Fault mmaps to enable vma tracking
Message-ID: <20200507235633.GL26002@ziepe.ca>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
 <158871569380.15589.16950418949340311053.stgit@gimli.home>
 <20200507214744.GP228260@xz-x1>
 <20200507160334.4c029518@x1.home>
 <20200507222223.GR228260@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507222223.GR228260@xz-x1>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 07, 2020 at 06:22:23PM -0400, Peter Xu wrote:
> On Thu, May 07, 2020 at 04:03:34PM -0600, Alex Williamson wrote:
> > On Thu, 7 May 2020 17:47:44 -0400
> > Peter Xu <peterx@redhat.com> wrote:
> > 
> > > Hi, Alex,
> > > 
> > > On Tue, May 05, 2020 at 03:54:53PM -0600, Alex Williamson wrote:
> > > > +/*
> > > > + * Zap mmaps on open so that we can fault them in on access and therefore
> > > > + * our vma_list only tracks mappings accessed since last zap.
> > > > + */
> > > > +static void vfio_pci_mmap_open(struct vm_area_struct *vma)
> > > > +{
> > > > +	zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);  
> > > 
> > > A pure question: is this only a safety-belt or it is required in some known
> > > scenarios?
> > 
> > It's not required.  I originally did this so that I'm not allocating a
> > vma_list entry in a path where I can't return error, but as Jason
> > suggested I could zap here only in the case that I do encounter that
> > allocation fault.  However I still like consolidating the vma_list
> > handling to the vm_ops .fault and .close callbacks and potentially we
> > reduce the zap latency by keeping the vma_list to actual users, which
> > we'll get to eventually anyway in the VM case as memory BARs are sized
> > and assigned addresses.
> 
> Yes, I don't see much problem either on doing the vma_list maintainance only in
> .fault() and .close().  My understandingg is that the worst case is the perf
> critical applications (e.g. DPDK) could pre-fault these MMIO region easily
> during setup if they want.  My question was majorly about whether the vma
> should be guaranteed to have no mapping at all when .open() is called.  But I
> agree with you that it's always good to have that as safety-belt anyways.

If the VMA has a mapping then that specific VMA has to be in the
linked list.

So if the zap is skipped then the you have to allocate something and
add to the linked list to track the VMA with mapping.

It is not a 'safety belt'

Jason
