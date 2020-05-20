Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797C61DA672
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 02:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgETAYc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 20:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgETAYb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 20:24:31 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86334C061A0E
        for <kvm@vger.kernel.org>; Tue, 19 May 2020 17:24:31 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id p4so542846qvr.10
        for <kvm@vger.kernel.org>; Tue, 19 May 2020 17:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+E0kIe70syNL6UAJLN3BrixhuqHouK19XEdYSaz4boc=;
        b=Fy9UQtONhqqEyoT6JmaD8ZWUnGxG2gZuC2E3cEOWtLwNQF0SIgpqUFvE9KUjKC89q+
         XtceAwte+1dGT/OhpeYI3ntI0RPTtUT+XfgXYR1NYWwCRXvCeRE+Ul9GyfDY/0qWXY46
         A1GAG7bBwmxQ3451vi6Jsx9UNZ863wFu8CkooGlunMDGao0JPlGNXOVdDht0fZbVUpTB
         cooBF8O4DF9LAX9OgBTVTHvmL8UuuAQoap8rR5QMGz08VZtBv526dmgst+bzuECwzHP2
         rHyOGuKeLOrq1/ijJXLF6YBbA0oJXUTq01Z/kbX8jn8OpuXdfUSMsEjVCYlbxFYUIm+a
         EfMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+E0kIe70syNL6UAJLN3BrixhuqHouK19XEdYSaz4boc=;
        b=KSKzQjDqWetn3mVWxcX+Z8gIRsyuhGGEjt1CUOOHI9YqWu47OoivoKoPCiTzZQZVWu
         /Ns9K3nlSYisSopG2UIruKQIjYAWkchU9pSWl//EJ3ssxdW/9c4KU9z5vTuSPZNqnKAk
         OC/MYEFXtgFflUWDPiKNuLf7nKWjt/1yECILo515vBSD6wINHWXqXVsc1dby8dLWm1wW
         0wKfDoPHrZYX9MotL4pj7eMXrn34g/adYYtUOgQHr33RIssfQTvnupVwtwpaTVmiO5Df
         Dpisa0LkYuDpHxlUIcnF8QgfdoD+7gJKOeG9+gqlQDO22KXH0DBhNGKpL6PB3aDVZg0K
         veuA==
X-Gm-Message-State: AOAM532CWbbgrlt1QzRN8lXlOLM6aUNeqrmcWFW2z9wkN6IFaR+HINLE
        JHC+c60OrkW7j80WWARlD9e2Lw==
X-Google-Smtp-Source: ABdhPJzepcju1X6ZbEK/rqZRJGs7XRG5GX9RZoCeTzWm53K2Qq7a4cM8kRPLEcG1JwR0CyqZG0/SmA==
X-Received: by 2002:a0c:b992:: with SMTP id v18mr2366070qvf.223.1589934270821;
        Tue, 19 May 2020 17:24:30 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id m59sm1124723qtd.46.2020.05.19.17.24.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 May 2020 17:24:30 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jbCX8-0003W3-0k; Tue, 19 May 2020 21:24:30 -0300
Date:   Tue, 19 May 2020 21:24:30 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com
Subject: Re: [PATCH 0/2] vfio/type1/pci: IOMMU PFNMAP invalidation
Message-ID: <20200520002429.GE31189@ziepe.ca>
References: <158947414729.12590.4345248265094886807.stgit@gimli.home>
 <20200514212538.GB449815@xz-x1>
 <20200514161712.14b34984@w520.home>
 <20200514222415.GA24575@ziepe.ca>
 <20200514165517.3df5a9ef@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514165517.3df5a9ef@w520.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 14, 2020 at 04:55:17PM -0600, Alex Williamson wrote:
> On Thu, 14 May 2020 19:24:15 -0300
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> > On Thu, May 14, 2020 at 04:17:12PM -0600, Alex Williamson wrote:
> > 
> > > that much.  I think this would also address Jason's primary concern.
> > > It's better to get an IOMMU fault from the user trying to access those
> > > mappings than it is to leave them in place.  
> > 
> > Yes, there are few options here - if the pages are available for use
> > by the IOMMU and *asynchronously* someone else revokes them, then the
> > only way to protect the kernel is to block them from the IOMMUU.
> > 
> > For this to be sane the revokation must be under complete control of
> > the VFIO user. ie if a user decides to disable MMIO traffic then of
> > course the IOMMU should block P2P transfer to the MMIO bar. It is user
> > error to have not disabled those transfers in the first place.
> > 
> > When this is all done inside a guest the whole logic applies. On bare
> > metal you might get some AER or crash or MCE. In virtualization you'll
> > get an IOMMU fault.
> > 
> > > due to the memory enable bit.  If we could remap the range to a kernel
> > > page we could maybe avoid the IOMMU fault and maybe even have a crude
> > > test for whether any data was written to the page while that mapping
> > > was in place (ie. simulating more restricted error handling, though
> > > more asynchronous than done at the platform level).    
> > 
> > I'm not if this makes sense, can't we arrange to directly trap the
> > IOMMU failure and route it into qemu if that is what is desired?
> 
> Can't guarantee it, some systems wire that directly into their
> management processor so that they can "protect their users" regardless
> of whether they want or need it.  Yay firmware first error handling,
> *sigh*.  Thanks,

I feel like those system should just loose the ability to reliably
mirror IOMMU errors to their guests - trying to emulate it by scanning
memory/etc sounds too horrible.

Jason
