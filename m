Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED6942E30E
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 23:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhJNVHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 17:07:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29219 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231134AbhJNVHB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 17:07:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634245495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MQBCABj4UeApXkMaCL6n9c35UutDuFqeQw/+Jz4vJPE=;
        b=gBxdkK2/6WWqO2GbqoEX5F1zufEayzTr68vRgbEeA1jSuyTRYn26CgAOgKoEI18JyfiBhc
        Rq5BJR2HdPWi15Tc00NggJ2Cy2ZV80onkt6q3hIsoXgQ+XzXjtyojMEyxQmBJYUZfafYNt
        vaPJ/4Hcu4N4D+C7jOivDOGesmWRcQI=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-pa2Mo-w7NyyXB4NhlAdXEg-1; Thu, 14 Oct 2021 17:04:54 -0400
X-MC-Unique: pa2Mo-w7NyyXB4NhlAdXEg-1
Received: by mail-oo1-f69.google.com with SMTP id u18-20020a4a6c52000000b002b6eeeabd60so3198320oof.16
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 14:04:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MQBCABj4UeApXkMaCL6n9c35UutDuFqeQw/+Jz4vJPE=;
        b=zw+uiJrtZ91ZPu3/R4xz1MnO6kXvnklP336VFvs3C5fd2NgMuya9pt3wrHobw72yv1
         9dTWAiBb6Bb55txqdl1l5pGz/jRP9BJyLGGJ6b6GL9Ij+KdEuWjxbnLrcBPsXYa/Tqxy
         snoCUIRsAbnU3j5pkae6ov6obxx8KHX29kBNDO3vpoOnn6CiAhTTugW3zmbM88iVc6+w
         uNP1o5HcBorHdTbBWOKYsLSLPqcPW1Lw86qyPAbE525O+W9h5y9h+wBKP+m+TLeBLm39
         cpjgb+58msjAJiOcjiN3aEoPhMfIKu6rYK7BJVLSDkzkby9r2iMVr1kwsBV1DPSigS59
         654A==
X-Gm-Message-State: AOAM5336mhdHX3cymhC2gaIb5dQhKI79CIQU3v5hgL2nZ49zXooDN+nk
        at7USghdKnFBOcGRxkpflyedcX12uqC7nvzLAJHQRMtk2VRqCEpe/okgG6xHBGBfYqAIrMLonor
        CgfBeJ1HP8TdK
X-Received: by 2002:a05:6830:239b:: with SMTP id l27mr4580699ots.115.1634245493472;
        Thu, 14 Oct 2021 14:04:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYHQg39fPptbDX7EXrpmjwTVYPpbg64YhA5AVhXzeLlu9PrVeXrT04mlYra7hKQ0IwFqxDIQ==
X-Received: by 2002:a05:6830:239b:: with SMTP id l27mr4580670ots.115.1634245493180;
        Thu, 14 Oct 2021 14:04:53 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l7sm646023oog.22.2021.10.14.14.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 14:04:52 -0700 (PDT)
Date:   Thu, 14 Oct 2021 15:04:50 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>, Cornelia Huck <cohuck@redhat.com>,
        kvm@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 5/5] vfio: Use cdev_device_add() instead of
 device_create()
Message-ID: <20211014150450.6d97b416.alex.williamson@redhat.com>
In-Reply-To: <20211013174251.GK2744544@nvidia.com>
References: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
        <5-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
        <20211013170847.GA2954@lst.de>
        <20211013174251.GK2744544@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Oct 2021 14:42:51 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Oct 13, 2021 at 07:08:47PM +0200, Christoph Hellwig wrote:
> > > +/* returns true if the get was obtained */
> > > +static bool vfio_group_try_get(struct vfio_group *group)
> > >  {
> > > +	return refcount_inc_not_zero(&group->users);
> > >  }  
> > 
> > Do we even need this helper?  Just open coding the refcount_inc_not_zero
> > would seem easier to read to me, and there is just a single caller
> > anyway.  
> 
> No we don't, I added it only to have symmetry with the
> vfio_group_put() naming.
> 
> Alex, what is your taste here?

I like the symmetry, but afaict this use of inc_not_zero is
specifically to cover the gap where vfio_group_fops_open() could race
vfio_group_put, right?  All the use cases of vfio_group_get() guarantee
that the group->users refcount is >0 based on either the fact that it's
found under the vfio.group_lock or the that call is based on an existing
open group.

If that's true, then this helper function seems like it invites
confusion and misuse more so than providing symmetry.  Open coding with
a comment explaining the vfio_group_get() calling requirements and
noting the race this inc_not_zero usage solves seems like the better
option to me.  Thanks,

Alex

