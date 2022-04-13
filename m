Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7294FF2B2
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 10:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbiDMIxr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 04:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbiDMIxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 04:53:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A002636B4D
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 01:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649839883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CXaBut5TtVX/5x8criaiy+9HCqtO5Zc1LaQGUaRBMEA=;
        b=WiI8PHrDgqEQzepEdzXaImZIebF0xzTHUD6WFhDwDQtHRBZGPauFkRW9JJlU0CoRy6q4f5
        WFux6I8g3oDKW+SGvmslR+gyQSeGfLF6ul0Z9D9WkZU1fQesejDbGKYN0sQnJhOn5Kb+sw
        6Mzta+m1gi8gxNhkAZWV9ludyYbc63I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-Sxv8HhbGNweWJvZXjlNpLw-1; Wed, 13 Apr 2022 04:51:22 -0400
X-MC-Unique: Sxv8HhbGNweWJvZXjlNpLw-1
Received: by mail-wm1-f70.google.com with SMTP id v191-20020a1cacc8000000b0038ce818d2efso614916wme.1
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 01:51:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=CXaBut5TtVX/5x8criaiy+9HCqtO5Zc1LaQGUaRBMEA=;
        b=LRvsMdB75Z6BA+IezBf9R+Dr1FM6v9OjehnTPiOYc2Eh5+1HsQJhIddvozSiTcOTNS
         WRsiDWi2mA7IvpO4bBWjTJcD7wPcBPC4SZeZcj0C0UKzpGsqiP6byEvhSN6SuGj28mPP
         MUUISr/nKvv6bU0bHyquSum5pTjl2e6mfoItABjn+aYXf8mn53pUJjfJoepODAF7+BYv
         KDJIsWw+htgrfsmDMpRYN201/cLoSYHXfbKxgKE4mr7PPGxnwZoLEL/XooIOenK0weNv
         9gJ7j3CzqHbb3WBFjIkd6CeU08mU9zLqmgA1PTFsGF7yxQuw4PI6xfSxOylMrekzcIxG
         jtzA==
X-Gm-Message-State: AOAM533uL6OUYp24r2iz3QfxVlvDWB4HvJDA6VMxs+DWiVxH+l0g4yPB
        vJmQT5HA6ipJngbzXLvWNzjvHVVtY5pHeffb5dztefJ7Z5LnkIqBgvnpAXfgl9LpF2R9AW1ISZi
        oLkHaEHKrG3q8
X-Received: by 2002:a7b:c844:0:b0:37b:b986:7726 with SMTP id c4-20020a7bc844000000b0037bb9867726mr8007996wml.160.1649839881425;
        Wed, 13 Apr 2022 01:51:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxn5qtF2uQ6pUNxFjxEXQhAZa5yNorXoA/krDl871AVJA2ATWMJLEmGmsp6F9Svpp/KYF0D+w==
X-Received: by 2002:a7b:c844:0:b0:37b:b986:7726 with SMTP id c4-20020a7bc844000000b0037bb9867726mr8007973wml.160.1649839881115;
        Wed, 13 Apr 2022 01:51:21 -0700 (PDT)
Received: from redhat.com ([2.55.135.33])
        by smtp.gmail.com with ESMTPSA id m20-20020a05600c3b1400b0038ebbbb2ad2sm1723628wms.44.2022.04.13.01.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 01:51:20 -0700 (PDT)
Date:   Wed, 13 Apr 2022 04:51:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Yao Hongbo <yaohongbo@linux.alibaba.com>,
        alikernel-developer@linux.alibaba.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] uio/uio_pci_generic: Introduce refcnt on open/release
Message-ID: <20220413044246-mutt-send-email-mst@kernel.org>
References: <1649833302-27299-1-git-send-email-yaohongbo@linux.alibaba.com>
 <YlZ8vZ9RX5i7mWNk@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YlZ8vZ9RX5i7mWNk@kroah.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 13, 2022 at 09:33:17AM +0200, Greg KH wrote:
> On Wed, Apr 13, 2022 at 03:01:42PM +0800, Yao Hongbo wrote:
> > If two userspace programs both open the PCI UIO fd, when one
> > of the program exits uncleanly, the other will cause IO hang
> > due to bus-mastering disabled.
> > 
> > It's a common usage for spdk/dpdk to use UIO. So, introduce refcnt
> > to avoid such problems.
> 
> Why do you have multiple userspace programs opening the same device?
> Shouldn't they coordinate?

Or to restate, I think the question is, why not open the device
once and pass the FD around?


> > 
> > Fixes: 865a11f987ab("uio/uio_pci_generic: Disable bus-mastering on release")


space missing before ( here .

> > Reported-by: Xiu Yang <yangxiu.yx@alibaba-inc.com>
> > Signed-off-by: Yao Hongbo <yaohongbo@linux.alibaba.com>
> > ---
> > Changes for v2:
> > 	Use refcount_t instead of atomic_t to catch overflow/underflows.
> > ---
> >  drivers/uio/uio_pci_generic.c | 16 +++++++++++++++-
> >  1 file changed, 15 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
> > index e03f9b5..1a5e1fd 100644
> > --- a/drivers/uio/uio_pci_generic.c
> > +++ b/drivers/uio/uio_pci_generic.c
> > @@ -31,6 +31,7 @@
> >  struct uio_pci_generic_dev {
> >  	struct uio_info info;
> >  	struct pci_dev *pdev;
> > +	refcount_t refcnt;
> >  };
> >  
> >  static inline struct uio_pci_generic_dev *
> > @@ -39,6 +40,14 @@ struct uio_pci_generic_dev {
> >  	return container_of(info, struct uio_pci_generic_dev, info);
> >  }
> >  
> > +static int open(struct uio_info *info, struct inode *inode)
> > +{
> > +	struct uio_pci_generic_dev *gdev = to_uio_pci_generic_dev(info);
> > +
> > +	refcount_inc(&gdev->refcnt);
> > +	return 0;
> > +}
> > +
> >  static int release(struct uio_info *info, struct inode *inode)
> >  {
> >  	struct uio_pci_generic_dev *gdev = to_uio_pci_generic_dev(info);
> > @@ -51,7 +60,9 @@ static int release(struct uio_info *info, struct inode *inode)
> >  	 * Note that there's a non-zero chance doing this will wedge the device
> >  	 * at least until reset.
> >  	 */
> > -	pci_clear_master(gdev->pdev);
> > +	if (refcount_dec_and_test(&gdev->refcnt))
> > +		pci_clear_master(gdev->pdev);
> 
> The goal here is to flush things when userspace closes the device, as
> the comment says.  So don't you want that to happen for when userspace
> closes the file handle no matter who opened it?
> 
> As this is a functional change, how is userspace going to "know" this
> functionality is now changed or not?
> 
> And if userspace really wants to open this multiple times, then properly
> switch the code to only create the device-specific structures when open
> is called.  Otherwise you are sharing structures here that are not
> intended to be shared, shouldn't you have your own private one?
> 
> this feels odd.
> 
> thanks,
> 
> greg k-h

Sigh. Maybe it was a mistake to do 865a11f987ab to begin with.
Anyone doing DMA with UIO is already on very thin ice.
But oh well.

-- 
MST

