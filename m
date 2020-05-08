Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0471CA0F4
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 04:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgEHCcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 22:32:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55262 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726678AbgEHCcC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 22:32:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588905120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bIUx96mA/EP7X7OGaqdPckgPL6bFvqgGtFSQHtpt5Dw=;
        b=UHTHr65DqkYo0WZzbShmHt4zB1NMRgUkslyHVcxls5WgfER/V2EJWgl9HmLdFkDxEZZcgi
        qFbA/nnim4M4dh3Tr1aScpVHZ0olLyw+j8gBNr3yPixIHGobQ7JVJ0AGmh8B13juCjG9cg
        WCHCjqX2lXmTbY+/+TWQY9Cm1KxhbXM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-wzSg8r-PMUGtm-e4DCzhjA-1; Thu, 07 May 2020 22:31:59 -0400
X-MC-Unique: wzSg8r-PMUGtm-e4DCzhjA-1
Received: by mail-qk1-f197.google.com with SMTP id v6so428937qkd.9
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 19:31:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bIUx96mA/EP7X7OGaqdPckgPL6bFvqgGtFSQHtpt5Dw=;
        b=qa7fO2FaP7Eima5HY5v6BYEbGWg2OTnQEsWvHYewzFv1nu/2ODJoPkGUmhQNqJlyX+
         l06GVOvcn+O6/zkamVHLWhfEhriVOt5hOwgkp/4tWIVPNas5hrnzJoUhBgFdsSNIXr/5
         jbXIVfNAjfT+SFUb9Z5ItQcoZHwRbaqm4XPMr2MbC+pGocDvbs5J8tGePPHxcHK6P0v5
         nNGvDI2k/U4l1S8V7ESXeCnyWkFHU41QrorejT9DhZkl10WATRC6UOVL9cdKPF2xpcLK
         axruJ1wOD/TIG+8bHumoeR8YbjA7Y5yykfyDReEzOMl/zHpek4H3zy+5nn+ELB7a/ZaB
         x7ng==
X-Gm-Message-State: AGi0PuY/vfaiiHoMktEz00h8Nc3OgWWK0RLUiDVX1D9fB7BtI4dApjWf
        3gOrTbFb3zrQt2MGvIP+sq1XoJ8hnJTV4R3xepHouaDYFktBKu2SOH9ij7bm8Ktm/sbv9ySZ9/H
        RGw2N5Ka9Osa7
X-Received: by 2002:aed:2744:: with SMTP id n62mr612556qtd.112.1588905118349;
        Thu, 07 May 2020 19:31:58 -0700 (PDT)
X-Google-Smtp-Source: APiQypIcclFny/DXEGjmyqjelNu3QHTKwYMIpTiZjqFGlhy9uH/EYQIP+qoJWgqSp4XGqubYl7AoHQ==
X-Received: by 2002:aed:2744:: with SMTP id n62mr612540qtd.112.1588905118097;
        Thu, 07 May 2020 19:31:58 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id p22sm365463qte.2.2020.05.07.19.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 19:31:57 -0700 (PDT)
Date:   Thu, 7 May 2020 22:31:56 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, jgg@ziepe.ca
Subject: Re: [PATCH v2 0/3] vfio-pci: Block user access to disabled device
 MMIO
Message-ID: <20200508023156.GV228260@xz-x1>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
 <20200507215908.GQ228260@xz-x1>
 <20200507163437.77b4bf2e@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200507163437.77b4bf2e@x1.home>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 07, 2020 at 04:34:37PM -0600, Alex Williamson wrote:
> On Thu, 7 May 2020 17:59:08 -0400
> Peter Xu <peterx@redhat.com> wrote:
> 
> > On Tue, May 05, 2020 at 03:54:36PM -0600, Alex Williamson wrote:
> > > v2:
> > > 
> > > Locking in 3/ is substantially changed to avoid the retry scenario
> > > within the fault handler, therefore a caller who does not allow retry
> > > will no longer receive a SIGBUS on contention.  IOMMU invalidations
> > > are still not included here, I expect that will be a future follow-on
> > > change as we're not fundamentally changing that issue in this series.
> > > The 'add to vma list only on fault' behavior is also still included
> > > here, per the discussion I think it's still a valid approach and has
> > > some advantages, particularly in a VM scenario where we potentially
> > > defer the mapping until the MMIO BAR is actually DMA mapped into the
> > > VM address space (or the guest driver actually accesses the device
> > > if that DMA mapping is eliminated at some point).  Further discussion
> > > and review appreciated.  Thanks,  
> > 
> > Hi, Alex,
> > 
> > I have a general question on the series.
> > 
> > IIUC this series tries to protect illegal vfio userspace writes to device MMIO
> > regions which may cause platform-level issues.  That makes perfect sense to me.
> > However what if the write comes from the devices' side?  E.g.:
> > 
> >   - Device A maps MMIO region X
> > 
> >   - Device B do VFIO_IOMMU_DMA_MAP on Device A's MMIO region X
> >     (so X's MMIO PFNs are mapped in device B's IOMMU page table)
> > 
> >   - Device A clears PCI_COMMAND_MEMORY (reset, etc.)
> >     - this should zap all existing vmas that mapping region X, however device
> >       B's IOMMU page table is not aware of this?
> > 
> >   - Device B writes to MMIO region X of device A even if PCI_COMMAND_MEMORY
> >     cleared on device A's PCI_COMMAND register
> > 
> > Could this happen?
> 
> Yes, this can happen and Jason has brought up variations on this
> scenario that are important to fix as well.  I've got some ideas, but
> the access in this series was the current priority.  There are also
> issues in the above scenario that if a platform considers a DMA write
> to an invalid IOMMU PTE and triggering an IOMMU fault to have the same
> severity as the write to disabled MMIO space we've prevented, then our
> hands are tied.  Thanks,

I see the point now; it makes sense to start with a series like this. Thanks, Alex.

-- 
Peter Xu

