Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAC11CAA46
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 14:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgEHMIE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 08:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726751AbgEHMID (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 08:08:03 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC60C05BD43
        for <kvm@vger.kernel.org>; Fri,  8 May 2020 05:08:03 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id i68so991809qtb.5
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 05:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jNcOJdj0FMsiZ/cz6XctSErT2eXavWVo0wmEW9tkg9M=;
        b=fOMZJstT2RX/AhoKfmsee3tP8RBwx6fgcky3Oxy2XCpR2wyYS1EN/nFjW0Tl68c4TD
         nNIwZs4awDPpb4PDBSsopqtK3+4peg+9piOjTodwwsZdQVFEe6M2yK1bop1RQdHisLOg
         JmENbj6q6f/y1kBXv9XnsnqCNgg0gI8itmOmk7PWYcbIOi/aJgH3qlf3btCcNLQOOZeB
         OLeLiJiB6KzK0nmW82mL9ijXOtXT1i+RHQ9fn1hhR61LtwFSLKUasqzYwrQk0CaCyt5r
         oWr9CozcTpX0YZzrmJkCD1X0r28l/mRCuXPzS555GQLfctnJfsZBRc0hl8chhDph7Kaj
         z2vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jNcOJdj0FMsiZ/cz6XctSErT2eXavWVo0wmEW9tkg9M=;
        b=aNSMj1I7idEPSoTRUsay38aHA+T5/KFuSRsfX3NO35eGD6OP3TKL3ACD52iqfeH6oM
         P1pWMhGVxswdGnxpOP3Rf17aiUZyKysBo/COyVR3mkZ7xq4VYxJzwuUB4cJ5ddxov6QX
         q3hz1Hkh0fYa/7eygiOKiuV28DacUQaD2oRRe5GPhnLbMCzsnypHmRVqYkUNFWE2tuvD
         1OGohqELmwj22aP9voL7s6MbyeWQeSi4ZKFW/Mq8cepWPkYwaDoXNmbAIuxO3TOzaZJb
         dtsnr4BvyN3OlqDz5K9HeYUSL5t7imRPiKZtQzWKfDSPpTTNHYV+TaPb7oV600d7eDZi
         Q8cg==
X-Gm-Message-State: AGi0PuY7xN4Qllw678iREjZxmrB9lNOmtwIfPWJz4mAU/W6kT1+AKib/
        6J9SRspJVqqlwWmCVMoYH2lDa0Fdyno=
X-Google-Smtp-Source: APiQypImoGg3seh1MMi5XajuwTrRav+mB7403kAKyblW/aBj9ai6BW7rHo9BQVpeLS/fQ4quUO41YA==
X-Received: by 2002:ac8:7942:: with SMTP id r2mr2764437qtt.288.1588939682425;
        Fri, 08 May 2020 05:08:02 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id x19sm965232qkb.136.2020.05.08.05.08.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 May 2020 05:08:01 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jX1nN-0003Yl-5m; Fri, 08 May 2020 09:08:01 -0300
Date:   Fri, 8 May 2020 09:08:01 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Peter Xu <peterx@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com
Subject: Re: [PATCH v2 2/3] vfio-pci: Fault mmaps to enable vma tracking
Message-ID: <20200508120801.GN26002@ziepe.ca>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
 <158871569380.15589.16950418949340311053.stgit@gimli.home>
 <20200507214744.GP228260@xz-x1>
 <20200507160334.4c029518@x1.home>
 <20200507222223.GR228260@xz-x1>
 <20200507235633.GL26002@ziepe.ca>
 <20200508021656.GS228260@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508021656.GS228260@xz-x1>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 07, 2020 at 10:16:56PM -0400, Peter Xu wrote:
> On Thu, May 07, 2020 at 08:56:33PM -0300, Jason Gunthorpe wrote:
> > On Thu, May 07, 2020 at 06:22:23PM -0400, Peter Xu wrote:
> > > On Thu, May 07, 2020 at 04:03:34PM -0600, Alex Williamson wrote:
> > > > On Thu, 7 May 2020 17:47:44 -0400
> > > > Peter Xu <peterx@redhat.com> wrote:
> > > > 
> > > > > Hi, Alex,
> > > > > 
> > > > > On Tue, May 05, 2020 at 03:54:53PM -0600, Alex Williamson wrote:
> > > > > > +/*
> > > > > > + * Zap mmaps on open so that we can fault them in on access and therefore
> > > > > > + * our vma_list only tracks mappings accessed since last zap.
> > > > > > + */
> > > > > > +static void vfio_pci_mmap_open(struct vm_area_struct *vma)
> > > > > > +{
> > > > > > +	zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);  
> > > > > 
> > > > > A pure question: is this only a safety-belt or it is required in some known
> > > > > scenarios?
> > > > 
> > > > It's not required.  I originally did this so that I'm not allocating a
> > > > vma_list entry in a path where I can't return error, but as Jason
> > > > suggested I could zap here only in the case that I do encounter that
> > > > allocation fault.  However I still like consolidating the vma_list
> > > > handling to the vm_ops .fault and .close callbacks and potentially we
> > > > reduce the zap latency by keeping the vma_list to actual users, which
> > > > we'll get to eventually anyway in the VM case as memory BARs are sized
> > > > and assigned addresses.
> > > 
> > > Yes, I don't see much problem either on doing the vma_list maintainance only in
> > > .fault() and .close().  My understandingg is that the worst case is the perf
> > > critical applications (e.g. DPDK) could pre-fault these MMIO region easily
> > > during setup if they want.  My question was majorly about whether the vma
> > > should be guaranteed to have no mapping at all when .open() is called.  But I
> > > agree with you that it's always good to have that as safety-belt anyways.
> > 
> > If the VMA has a mapping then that specific VMA has to be in the
> > linked list.
> > 
> > So if the zap is skipped then the you have to allocate something and
> > add to the linked list to track the VMA with mapping.
> > 
> > It is not a 'safety belt'
> 
> But shouldn't open() only be called when the VMA is created for a memory range?
> If so, does it also mean that the address range must have not been mapped yet?

open is called whenever a VMA is copied, I don't think it is called
when the VMA is first created?

Jason
