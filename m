Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA03C1E1313
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 18:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389173AbgEYQ4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 12:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388093AbgEYQ4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 12:56:39 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37B7C05BD43
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 09:56:38 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id i68so14166172qtb.5
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 09:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RnbJoGkQSYIWhb4JMOjqZuj7XoQ9RKkNiJGhYUTG/14=;
        b=PRazj8dqsHPcMBvgSXtvLmKfZYFt7JxdLhnSOh4obxSgjAk85cTFADryOFh8Fg18sg
         EpxrmsqTcm4d1xC3/m0iD1s1C0e/iuvGubSm0ztOuLryqXXT/f+u9eC3P6EeGu+RgYFT
         MAh8QDfRAY1IO5mqmqHQQi6I/a5u89pBZgZgLWE7prCOHG0QUyD+hH4d/dOFenmDdFOX
         Xy2PTECgONmjq2/kiEmvA8b9PwmK9f6Q4+8/gfEluZq4C5kxPWjLrd24pkhlOvCY+ddU
         NiNokE9Rt0FTD2Dvnpmtrx4fHEBrOLOL06BFfO7TlEpqDfpScEJnJ5hhaDMKAPBC5y8n
         19PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RnbJoGkQSYIWhb4JMOjqZuj7XoQ9RKkNiJGhYUTG/14=;
        b=A5ml4irvi1xzpE3/9H3f0tF99Mj3X1XpYi2qFqttJ/BR0XCV9d2291LJ7ABQq1iA0q
         slAWIwHmqx0ApSxWbL2M4sfDEhdrKTuUdFbrym/3OiXC6STSaCTknt4MVs1wVPLuN3BC
         lmwESHGeS87U6kev1ZfnLGuK6kzIUqb0CXSR1sBUc+4A98+D1NKW9p6sVqNzvg2WgHVc
         ryDKZXd5jyiioHJuF7zAYfaO17q6vYRxifOi/ncgD3Whk65DZtGcMV1DzU1JLUCEmUI4
         8VSy/mt6fnRIR08t4ufYUyp8WY5F4W4neqJyLG+MCT0wes0m37BDbV2KcPEcCVT1xdEE
         4ZkQ==
X-Gm-Message-State: AOAM531ubQYaYfah0kgSPAX3Wzwv8fCzJAGtrZyHJ6ImyebaYfA1Vwpm
        zVAuc1mmdc18CNThV4dPTixxug==
X-Google-Smtp-Source: ABdhPJw6zu/8YdulBeKKyQPfp5GMUWfj0KuegI6y6cTz6YXz7Ixh0WaTklaUm68u4nSbhhksBv6Xcw==
X-Received: by 2002:aed:3bf2:: with SMTP id s47mr27767416qte.126.1590425798160;
        Mon, 25 May 2020 09:56:38 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id n85sm11837193qkn.31.2020.05.25.09.56.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 May 2020 09:56:37 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jdGOz-0003i1-9R; Mon, 25 May 2020 13:56:37 -0300
Date:   Mon, 25 May 2020 13:56:37 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Peter Xu <peterx@redhat.com>, John Hubbard <jhubbard@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com, cai@lca.pw,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v3 3/3] vfio-pci: Invalidate mmaps and block MMIO access
 on disabled memory
Message-ID: <20200525165637.GG744@ziepe.ca>
References: <159017449210.18853.15037950701494323009.stgit@gimli.home>
 <159017506369.18853.17306023099999811263.stgit@gimli.home>
 <20200523193417.GI766834@xz-x1>
 <20200523170602.5eb09a66@x1.home>
 <20200523235257.GC939059@xz-x1>
 <20200525122607.GC744@ziepe.ca>
 <20200525142806.GC1058657@xz-x1>
 <20200525144651.GE744@ziepe.ca>
 <20200525151142.GE1058657@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525151142.GE1058657@xz-x1>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 11:11:42AM -0400, Peter Xu wrote:
> On Mon, May 25, 2020 at 11:46:51AM -0300, Jason Gunthorpe wrote:
> > On Mon, May 25, 2020 at 10:28:06AM -0400, Peter Xu wrote:
> > > On Mon, May 25, 2020 at 09:26:07AM -0300, Jason Gunthorpe wrote:
> > > > On Sat, May 23, 2020 at 07:52:57PM -0400, Peter Xu wrote:
> > > > 
> > > > > For what I understand now, IMHO we should still need all those handlings of
> > > > > FAULT_FLAG_RETRY_NOWAIT like in the initial version.  E.g., IIUC KVM gup will
> > > > > try with FOLL_NOWAIT when async is allowed, before the complete slow path.  I'm
> > > > > not sure what would be the side effect of that if fault() blocked it.  E.g.,
> > > > > the caller could be in an atomic context.
> > > > 
> > > > AFAICT FAULT_FLAG_RETRY_NOWAIT only impacts what happens when
> > > > VM_FAULT_RETRY is returned, which this doesn't do?
> > > 
> > > Yes, that's why I think we should still properly return VM_FAULT_RETRY if
> > > needed..  because IMHO it is still possible that the caller calls with
> > > FAULT_FLAG_RETRY_NOWAIT.
> > > 
> > > My understanding is that FAULT_FLAG_RETRY_NOWAIT majorly means:
> > > 
> > >   - We cannot release the mmap_sem, and,
> > >   - We cannot sleep
> > 
> > Sleeping looks fine, look at any FS implementation of fault, say,
> > xfs. The first thing it does is xfs_ilock() which does down_write().
> 
> Yeah.  My wild guess is that maybe fs code will always be without
> FAULT_FLAG_RETRY_NOWAIT so it's safe to sleep unconditionally (e.g., I think
> the general #PF should be fine to sleep in fault(); gup should be special, but
> I didn't observe any gup code called upon file systems)?

get_user_pages is called on filesystem backed pages.

I have no idea what FAULT_FLAG_RETRY_NOWAIT is supposed to do. Maybe
John was able to guess when he reworked that stuff?

Jason
