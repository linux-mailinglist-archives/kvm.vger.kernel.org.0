Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22F54194AE
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 14:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbhI0M6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 08:58:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40157 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234360AbhI0M6U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 08:58:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632747402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8evR5N3FrUP1YdJdooxyAAIxmXSgiTAsg604Q8744VM=;
        b=dxL9Z+5qkDEfWPpbMozhy68ikIiGcf2eiTxZEZdbmnOkxWojmNqqgRtn/Z/m7rpYg3T1Mc
        cyTeXMLK3BEqjvB1Isg4VHLOIFcylKK7GJVdMdnnLrqrjXFGqhmEgeUTob/oim8nLTAsLh
        htKWaeOD45yO5K27HbHUJ0yrjL1vGqI=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-ODwSKF-9O66GwwyMol1LFA-1; Mon, 27 Sep 2021 08:56:40 -0400
X-MC-Unique: ODwSKF-9O66GwwyMol1LFA-1
Received: by mail-ot1-f71.google.com with SMTP id m12-20020a0568301e6c00b005469f1a7d70so14356904otr.15
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 05:56:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8evR5N3FrUP1YdJdooxyAAIxmXSgiTAsg604Q8744VM=;
        b=cin5dtG2SoyggtjdP7tCLkXDoWm/+RLyawMzm8tyRInXn56KDtltJB1vdQ3bOtg1h3
         oCLPp22HRGAGHxOOs23g3/1RjGL7OqAHlF7mdKKOcTmzmftkerHe1zV91DaSdlQTsWS2
         1RvKLaa7vN5GKwc4EaIJbmc2FgBNtYmi9FpLvZL132tnAWWFMTCa9cIYvGbvKc/Zgs/w
         5UCTsD+m8Ll/r9qIpmxhRiiwtsz8bY981d/iQnP1e7zUrLUyG8mAhlysmnTgRbZTvFep
         Hhz1u8/gjBkikOooBMtCVEzAEeYoIWszYWUxZB97IEnQss1tIKw/LWRQrr8alXyLZtYt
         VWXA==
X-Gm-Message-State: AOAM533xUdewAhUDh6gQustNuFPEWgX3vy7LpAANC5hXWYhdclNY43HX
        pKnX3x/ZvuY9ntPCnLmpdxZkzKu9lES7cwAqvf0C85mYfaxBNwmUtKpEVh5A/t+o2Ftn4VmCsZG
        234Jh9NAeGXaa
X-Received: by 2002:a9d:34e:: with SMTP id 72mr17064558otv.172.1632747399185;
        Mon, 27 Sep 2021 05:56:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyktlEzVcasGh0nHj9EKzP/wQACAnbEfa87ucpiBRKSd/5bKW/q9YyUErOwEEN12DL1FTQxyQ==
X-Received: by 2002:a9d:34e:: with SMTP id 72mr17064544otv.172.1632747399001;
        Mon, 27 Sep 2021 05:56:39 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id d10sm4220757ooj.24.2021.09.27.05.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 05:56:38 -0700 (PDT)
Date:   Mon, 27 Sep 2021 06:56:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 13/15] vfio/iommu_type1: initialize pgsize_bitmap in
 ->open
Message-ID: <20210927065637.696eb066.alex.williamson@redhat.com>
In-Reply-To: <20210927114928.GA23909@lst.de>
References: <20210924155705.4258-1-hch@lst.de>
        <20210924155705.4258-14-hch@lst.de>
        <20210924174852.GZ3544071@ziepe.ca>
        <20210924123755.76041ee0.alex.williamson@redhat.com>
        <20210927114928.GA23909@lst.de>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Sep 2021 13:49:28 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Fri, Sep 24, 2021 at 12:37:55PM -0600, Alex Williamson wrote:
> > > > +	iommu->pgsize_bitmap = ULONG_MAX;    
> > > 
> > > I wonder if this needs the PAGE_MASK/SIZE stuff?
> > > 
> > >    iommu->pgsize_bitmap = ULONG_MASK & PAGE_MASK;
> > > 
> > > ?
> > > 
> > > vfio_update_pgsize_bitmap() goes to some trouble to avoid setting bits
> > > below the CPU page size here  
> > 
> > Yep, though PAGE_MASK should already be UL, so just PAGE_MASK itself
> > should work.  The ULONG_MAX in the update function just allows us to
> > detect sub-page, ex. if the IOMMU supports 2K we can expose 4K minimum,
> > but we can't if the min IOMMU page is 64K.  Thanks,  
> 
> Do you just want to update this or do you want a full resend of the
> series?

So long as we have agreement, I can do it inline.  Are we doing
s/ULONG_MAX/PAGE_MASK/ across both the diff and commit log?  Thanks,

Alex

