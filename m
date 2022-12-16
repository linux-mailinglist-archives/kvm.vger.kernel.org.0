Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F416764EF39
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 17:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiLPQe3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 11:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiLPQeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 11:34:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F4922505
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671208406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z5m/uTP5bjpIgKQii7paVPxnHjd7vJJPvXm/y28JFgA=;
        b=irEd0NlSQk58hkhRMAyHXUxIEQ9uNYJZN5rSksm2HOzQ26hzn0zJDhP1pTO5nJd21JUoCd
        qHnstouveY6V/gBe66whhK4N/Zv6pIWgEGedq/QSYTJN9shoJ5F/u5JHYMRyTm5QaZdkPF
        LGKqsvV4f35BrM8G2RxMfUgjy1KaASU=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-478-X_M4Ji--NwyqKflo2l_tZQ-1; Fri, 16 Dec 2022 11:33:24 -0500
X-MC-Unique: X_M4Ji--NwyqKflo2l_tZQ-1
Received: by mail-io1-f72.google.com with SMTP id b24-20020a056602219800b006e2bf9902cbso1590079iob.4
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:33:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z5m/uTP5bjpIgKQii7paVPxnHjd7vJJPvXm/y28JFgA=;
        b=jrZ4no5bCxdw5rHVkziRb14v3xifpbRvTkToYOJGYD2lrNQm3fLJGJKFKL/Rjt7s7N
         8PT1Q6WJZI3LhJxceIu5XCgxIeFgMAHvvPTriJB5Xmy9jkeSTfpxH/tep8SPc8hDiMDK
         lAMBWeTS2hxoK3eHHc46DF9YjLv70PxXc0ypVzhQQZsywkjkmBivqX6OHqPV0rGyRbnm
         4JVJsXO8O458/UgQUilkBGYSlSvQ1dRjkrNvoyB9wp+2QJGZ03ytdW8uqkZt55l1+vyf
         /28p9RWBeCnIViZ9/ARRXXkjdv50PrBsBeHfplZ+A+QKwsdpEr/6rFGpZdEeO5CiXMGP
         sV8w==
X-Gm-Message-State: ANoB5pnBCP/apY2spy6qrE/VFtK9T7T6GDhJo8WcUm88tvhY33RW0UA+
        gu7I/IDWTGMrVIvqbo2+J6jZnChM6LZwQ6Ql7mO+6kqRXo9MyaBwwLgSlMdDLymi3Y7v/FXw7Oh
        hj9N5xpMMhLVy
X-Received: by 2002:a05:6e02:b4a:b0:303:2b9b:8338 with SMTP id f10-20020a056e020b4a00b003032b9b8338mr19278345ilu.31.1671208403830;
        Fri, 16 Dec 2022 08:33:23 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4JNU4S6VAxXZMo8QS9vBe6QThOe0RcqtamxXJishzuOAknEvztOSjUkh8dtM/OYWyYgIF1PQ==
X-Received: by 2002:a05:6e02:b4a:b0:303:2b9b:8338 with SMTP id f10-20020a056e020b4a00b003032b9b8338mr19278331ilu.31.1671208403549;
        Fri, 16 Dec 2022 08:33:23 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u11-20020a92da8b000000b003033505d81esm771329iln.58.2022.12.16.08.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 08:33:23 -0800 (PST)
Date:   Fri, 16 Dec 2022 09:33:21 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH V5 2/7] vfio/type1: prevent locked_vm underflow
Message-ID: <20221216093321.414b13f8.alex.williamson@redhat.com>
In-Reply-To: <68cbc774-4c2d-c29a-41cc-fee24af89604@oracle.com>
References: <1671141424-81853-1-git-send-email-steven.sistare@oracle.com>
        <1671141424-81853-3-git-send-email-steven.sistare@oracle.com>
        <Y5x8HoAEJA7r8ko+@nvidia.com>
        <12c07702-ac7a-7e62-8bea-1f38055dfbf3@oracle.com>
        <20221216091034.4c1cac89.alex.williamson@redhat.com>
        <68cbc774-4c2d-c29a-41cc-fee24af89604@oracle.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 16 Dec 2022 11:16:59 -0500
Steven Sistare <steven.sistare@oracle.com> wrote:

> On 12/16/2022 11:10 AM, Alex Williamson wrote:
> > On Fri, 16 Dec 2022 10:42:13 -0500
> > Steven Sistare <steven.sistare@oracle.com> wrote:
> >   
> >> On 12/16/2022 9:09 AM, Jason Gunthorpe wrote:  
> >>> On Thu, Dec 15, 2022 at 01:56:59PM -0800, Steve Sistare wrote:    
> >>>> When a vfio container is preserved across exec, the task does not change,
> >>>> but it gets a new mm with locked_vm=0.  If the user later unmaps a dma
> >>>> mapping, locked_vm underflows to a large unsigned value, and a subsequent
> >>>> dma map request fails with ENOMEM in __account_locked_vm.
> >>>>
> >>>> To avoid underflow, grab and save the mm at the time a dma is mapped.
> >>>> Use that mm when adjusting locked_vm, rather than re-acquiring the saved
> >>>> task's mm, which may have changed.  If the saved mm is dead, do nothing.
> >>>>
> >>>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> >>>> ---
> >>>>  drivers/vfio/vfio_iommu_type1.c | 17 ++++++++++-------
> >>>>  1 file changed, 10 insertions(+), 7 deletions(-)    
> >>>
> >>> Add fixes lines and a CC stable    
> >>
> >> This predates the update vaddr functionality, so AFAICT:
> >>
> >>     Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
> >>
> >> I'll wait on cc'ing stable until alex has chimed in.  
> > 
> > Technically, adding the stable Cc tag is still the correct approach per
> > the stable process docs, but the Fixes: tag alone is generally
> > sufficient to crank up the backport engines.  The original
> > implementation is probably the correct commit to identify, exec was
> > certainly not considered there.  Thanks,  
> 
> Should I cc stable on the whole series, or re-send individually?  If the
> latter, which ones?

Only for the Fixes: commits, and note that Cc: stable is effectively
just a tag like Fixes:, you don't actually need to copy the stable@vger
list on the patch (and IIRC you'll get some correctional email if you
do).  Thanks,

Alex

