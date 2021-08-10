Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63EA3E84A2
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 22:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhHJUvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 16:51:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23558 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233549AbhHJUvr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 16:51:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628628684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BRAP3UcLgpqf8XsYQHiUMWSMjCOCoU43rTaFEkutFE4=;
        b=VQ5V6RZT+eXQvel8/CD/v9/r/nUWZxKSSF6+mhzVRCAKQu5rocml+KXkqml22mvnVUSImg
        obWtLVqQQMxZ7NcWIXpnuJbB9bs8wZ56zcFgfqkBMSkY75/XOZwI2+tjZotKGrCAByR2i8
        3VMMlpfMQwZNBBqLrPNNO5MWPP0UysE=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-kF-XguTDNwevxAdUPTx9cg-1; Tue, 10 Aug 2021 16:51:23 -0400
X-MC-Unique: kF-XguTDNwevxAdUPTx9cg-1
Received: by mail-oi1-f197.google.com with SMTP id c6-20020aca35060000b029025c5504f461so263262oia.22
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 13:51:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BRAP3UcLgpqf8XsYQHiUMWSMjCOCoU43rTaFEkutFE4=;
        b=eSjiqpodi4lZREN5L1F2zUDCzcQ10Q33dJ/f/peDcNeFY0mg1jEz4K+gA0cw1K9I1X
         C7SNCu3NUd4lGu0HztR55XPE/llACTzsXAZ75ae+mxS1QjI0+4aaG0X0K816Tc4ktpWl
         4acTzrPnPvFUNbiOAm8YhOLlvp7N8EygtJDDnbReiKjOhZB9U9ryIBM/8mO+pdgL0LN7
         /ukDDN5STmk0bmzjN+HZAU7aiwPCx5YGekbbMNFeYkeWaBCtHE9L0+663XJiu7maecrT
         iBT3rlPP9yzhPigmpumMa6up/INUABZAGHHjRkZUiy9u0dl51Tp2SkFHf4c2WqJIYviQ
         XsAw==
X-Gm-Message-State: AOAM530mUXmq12+9cu+ncg9ktBuZBnoZ0qrEPteOXFym/WdeewfxC6de
        R2Isz3F3zlOMTe71ZNtaY0Mj0HEQUDzjzxc5PvvinewOHG/fanGvakVEsXdDaL3M8oZc7zAP2FM
        GoOkx8If9r9nf
X-Received: by 2002:aca:4554:: with SMTP id s81mr5073409oia.41.1628628682453;
        Tue, 10 Aug 2021 13:51:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy78YX4WsIPZVstJJSezqWHWGPHEZO0W2taQXaEHV3PPUALBc3Bl+022KgyUSRnEeR2u7YVTQ==
X-Received: by 2002:aca:4554:: with SMTP id s81mr5073400oia.41.1628628682265;
        Tue, 10 Aug 2021 13:51:22 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id e20sm621635otj.4.2021.08.10.13.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 13:51:22 -0700 (PDT)
Date:   Tue, 10 Aug 2021 14:51:20 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 3/7] vfio/pci: Use vfio_device_unmap_mapping_range()
Message-ID: <20210810145120.28759d65.alex.williamson@redhat.com>
In-Reply-To: <YRLNMv3UhwVa8Pd4@t490s>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
        <162818325518.1511194.1243290800645603609.stgit@omen>
        <YRI+nsVAr3grftB4@infradead.org>
        <YRLNMv3UhwVa8Pd4@t490s>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 Aug 2021 15:02:10 -0400
Peter Xu <peterx@redhat.com> wrote:

> On Tue, Aug 10, 2021 at 10:53:50AM +0200, Christoph Hellwig wrote:
> > On Thu, Aug 05, 2021 at 11:07:35AM -0600, Alex Williamson wrote:  
> > > +static void vfio_pci_zap_bars(struct vfio_pci_device *vdev)
> > >  {
> > > +	vfio_device_unmap_mapping_range(&vdev->vdev,
> > > +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX),
> > > +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX) -
> > > +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX));  
> > 
> > Maybe make this a little more readable by having local variables:  
> 
> Or just pass in unmap_mapping_range(start=0, len=0)?  As unmap_mapping_range()
> understands len==0 as "to the end of file".  Thanks,

But we're not actually trying to unmap the entire device fd, we're only
targeting the ranges of it that correspond to standard MMIO resources
of the device.  Our vma-to-pfn function for vfio-pci also only knows
how to lookup vmas in this range.  If there were mmap'able regions
outside of this, for example provided by vendor specific extensions, we
a) don't generically know if they're related to the device itself or
some supporting information managed in software (ex. IGD OpRegion) and
b) don't know how to lookup the pfn to remap them when MMIO is
re-enabled.

I don't think we have any such extensions today, but we might with
vfio-pci-core and we'd need to figure out how to include those regions
in some future work.  Thanks,

Alex

