Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D191E1155
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 17:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391018AbgEYPLt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 11:11:49 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51451 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390990AbgEYPLt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 May 2020 11:11:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590419507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3mpYWtKyRgORiVGPfs1mMYQZAQgnaA9yUkeL6coUBH0=;
        b=d+6PU8AksLbzV66wvBFQtTnOvuegfiyj9i6WGOjm7ZWCFJHp8MMv6ad5RrxefczcN0DUQy
        gx6Nqi4sWiux9q+vDlt58ieFEwHEe85RXZun8P28aCZ0eAQf9eDTnzZs1qAEv9DlIlCsqa
        vawtF1bRv1ISRbK3oPcIxS0rfADFBcI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-egE34TlyNf6zCzM06mOwsg-1; Mon, 25 May 2020 11:11:45 -0400
X-MC-Unique: egE34TlyNf6zCzM06mOwsg-1
Received: by mail-qt1-f199.google.com with SMTP id x6so719687qts.3
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 08:11:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3mpYWtKyRgORiVGPfs1mMYQZAQgnaA9yUkeL6coUBH0=;
        b=ofnvRwXnhDSpaGqjOvVzoCrzbjl8pnvHfihCer1VdPymWBsGDo+ZSlI5Fxy6GnpTVD
         7+IP4FtG/tWYpLBEnTYA1L7sW82p4UhJjLkjt/9OHS8oR8yn9KsIuhBPdpll9VkScnsy
         MIaHtMOgeC2dPIQi2YyL2NfFE/eS0MOpLFN1aRMXOcFanRtY1mFmriOX+FKlL8tHK79/
         mzqnIfJCnh2iDX7hYESIh9hMOUp3bBVywjoZ1IS5bbRxQA5krGCwuMcemqO88SPIWfkR
         mzgbwjR5qBnf768vRmDMJOx2cbu0+VkDQdcf1htGodj80qQd15aK8zjnjIUCSHzcOHLH
         gTGA==
X-Gm-Message-State: AOAM530Wg95JPNPZPhJ99omDXqTVDuixhHDH66NX/Mo+KJ+38tqw22cm
        E9TG8UwKWWYwEbeBscQMWF/ZcTZlMgTLlaxWkPnfuvrPQByjPTSYBZ9xJQLU14ovE3qSKb1xy0J
        60x75D5hbe2Mg
X-Received: by 2002:aed:3f55:: with SMTP id q21mr14841973qtf.190.1590419505318;
        Mon, 25 May 2020 08:11:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLGO9HFRMMZ35OmlO3lthVjqkN5BxWSbWB0HvGtGQ8EL2CepNgl+pRq3Vcru4K9iTjPXschA==
X-Received: by 2002:aed:3f55:: with SMTP id q21mr14841935qtf.190.1590419505005;
        Mon, 25 May 2020 08:11:45 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id f14sm10796275qka.70.2020.05.25.08.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 08:11:44 -0700 (PDT)
Date:   Mon, 25 May 2020 11:11:42 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cohuck@redhat.com, cai@lca.pw,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v3 3/3] vfio-pci: Invalidate mmaps and block MMIO access
 on disabled memory
Message-ID: <20200525151142.GE1058657@xz-x1>
References: <159017449210.18853.15037950701494323009.stgit@gimli.home>
 <159017506369.18853.17306023099999811263.stgit@gimli.home>
 <20200523193417.GI766834@xz-x1>
 <20200523170602.5eb09a66@x1.home>
 <20200523235257.GC939059@xz-x1>
 <20200525122607.GC744@ziepe.ca>
 <20200525142806.GC1058657@xz-x1>
 <20200525144651.GE744@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200525144651.GE744@ziepe.ca>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 11:46:51AM -0300, Jason Gunthorpe wrote:
> On Mon, May 25, 2020 at 10:28:06AM -0400, Peter Xu wrote:
> > On Mon, May 25, 2020 at 09:26:07AM -0300, Jason Gunthorpe wrote:
> > > On Sat, May 23, 2020 at 07:52:57PM -0400, Peter Xu wrote:
> > > 
> > > > For what I understand now, IMHO we should still need all those handlings of
> > > > FAULT_FLAG_RETRY_NOWAIT like in the initial version.  E.g., IIUC KVM gup will
> > > > try with FOLL_NOWAIT when async is allowed, before the complete slow path.  I'm
> > > > not sure what would be the side effect of that if fault() blocked it.  E.g.,
> > > > the caller could be in an atomic context.
> > > 
> > > AFAICT FAULT_FLAG_RETRY_NOWAIT only impacts what happens when
> > > VM_FAULT_RETRY is returned, which this doesn't do?
> > 
> > Yes, that's why I think we should still properly return VM_FAULT_RETRY if
> > needed..  because IMHO it is still possible that the caller calls with
> > FAULT_FLAG_RETRY_NOWAIT.
> > 
> > My understanding is that FAULT_FLAG_RETRY_NOWAIT majorly means:
> > 
> >   - We cannot release the mmap_sem, and,
> >   - We cannot sleep
> 
> Sleeping looks fine, look at any FS implementation of fault, say,
> xfs. The first thing it does is xfs_ilock() which does down_write().

Yeah.  My wild guess is that maybe fs code will always be without
FAULT_FLAG_RETRY_NOWAIT so it's safe to sleep unconditionally (e.g., I think
the general #PF should be fine to sleep in fault(); gup should be special, but
I didn't observe any gup code called upon file systems)?

Or I must have missed something important...

Thanks,

-- 
Peter Xu

