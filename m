Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF45A5B0A44
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 18:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiIGQk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 12:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIGQk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 12:40:56 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AC26EF28
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 09:40:54 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id m9so8476571qvv.7
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 09:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=oOtsIfLgo+dpW6bJd1WimKnWJ8hG0+yd1C7QnZJgzys=;
        b=NLEjy+firPpiQwLoDTWKF2YlJU06b7+MpQCjV9boLFcGlndFOsSeLn4xVITIO7j1VY
         3oYDGu/QrFrJp0lH7j5JnP43Q0ozPiidOwZiERCRViBoXL+ySmscfO84ZNklVxkzSstF
         3z1XYaEmSgAWcdrqm0P9e/9I87jTUM2Ktdxc8OihgL204wniUGX9uooTHatLhmYtFYp6
         NdGaE88tHGNEt514DJNVD55o6v3qLlrVmnRGTkVhWmLW5LzRlZds9toqv82dmQh5FHDv
         65GriHVlpGkKAWAWHDojF8N+ad5NPHupswjGtn0ujB3Ap3k3VVTv6S+XsBCh1TD43pdA
         uq/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=oOtsIfLgo+dpW6bJd1WimKnWJ8hG0+yd1C7QnZJgzys=;
        b=gcUBlA4FddoNC2/NhLa8m1dBhApGMVP4oFVR9vlA56btgymwgcLqQkOcVbCIMHmmFZ
         jtZnJAiKcCOUGdIiLEaQq6BVUqnQJKsXuvIDcviUZQyZeHaoLv5aR1OxYIyzYJHIwoKJ
         d77nV/zMcV7/y56cXujtBGTP9xNnIo1AHsypM6hneEiFYzL1CdP7LWNy6dgVv0DUxmEJ
         /g/gI5Hwwo2jvB3sqZLOoGaF0bZq+qXz1qb0VaYU/U6q1KFMhP07EwbqoTglEFwvD80W
         jwN2f7dNeVtMeAP4gGLv4fArtpNyijo/ZKwYOU6qs5A5y9V5QCluzkJig6RcFmwc+hHq
         ciqQ==
X-Gm-Message-State: ACgBeo3cx0X2J0ml6tLM/NGS2juA7bY6IWIluJJAwYXbsBKYxVg8AonP
        5YSBcRYQfhetTrg5xENUbPi0dw==
X-Google-Smtp-Source: AA6agR5aqyqDQj8p4rDj/DRP4aqjwXj4zv8D3N4lHGDYenpdWlbkDHCrOsWAlxztCdbeU0pA3oV2wQ==
X-Received: by 2002:a05:6214:27e4:b0:476:be6a:91c1 with SMTP id jt4-20020a05621427e400b00476be6a91c1mr3810500qvb.39.1662568854158;
        Wed, 07 Sep 2022 09:40:54 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id x11-20020ac87ecb000000b0031ee918e9f9sm12833581qtj.39.2022.09.07.09.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 09:40:53 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oVy6e-008gbP-Tw;
        Wed, 07 Sep 2022 13:40:52 -0300
Date:   Wed, 7 Sep 2022 13:40:52 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lpivarc@redhat.com" <lpivarc@redhat.com>,
        "Liu, Jingqi" <jingqi.liu@intel.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: Re: [PATCH] vfio/type1: Unpin zero pages
Message-ID: <YxjJlM5A0OLhaA7K@ziepe.ca>
References: <166182871735.3518559.8884121293045337358.stgit@omen>
 <BN9PR11MB527655973E2603E73F280DF48C7A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d71160d1-5a41-eae0-6405-898fe0a28696@redhat.com>
 <YxfX+kpajVY4vWTL@ziepe.ca>
 <b365f30b-da58-39c0-08e9-c622cc506afa@redhat.com>
 <YxiTOyGqXHFkR/DY@ziepe.ca>
 <20220907095552.336c8f34.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220907095552.336c8f34.alex.williamson@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 07, 2022 at 09:55:52AM -0600, Alex Williamson wrote:

> > So, if we go back far enough in the git history we will find a case
> > where PUP is returning something for the zero page, and that something
> > caused is_invalid_reserved_pfn() == false since VFIO did work at some
> > point.
> 
> Can we assume that?  It takes a while for a refcount leak on the zero
> page to cause an overflow.  My assumption is that it's never worked, we
> pin zero pages, don't account them against the locked memory limits
> because our is_invalid_reserved_pfn() test returns true, and therefore
> we don't unpin them.

Oh, you think it has been buggy forever? That is not great..
 
> > IHMO we should simply go back to the historical behavior - make
> > is_invalid_reserved_pfn() check for the zero_pfn and return
> > false. Meaning that PUP returned it.
> 
> We've never explicitly tested for zero_pfn and as David notes,
> accounting the zero page against the user's locked memory limits has
> user visible consequences.  VMs that worked with a specific locked
> memory limit may no longer work.  

Yes, but the question is if that is a strict ABI we have to preserve,
because if you take that view it also means because VFIO has this
historical bug that David can't fix the FOLL_FORCE issue either.

If the view holds for memlock then it should hold for cgroups
also. This means the kernel can never change anything about
GFP_KERNEL_ACCOUNT allocations because it might impact userspace
having set a tight limit there.

It means we can't fix the bug that VFIO is using the wrong storage for
memlock.

It means qemu can't change anything about how it sets up this memory,
ie Kevin's idea to change the ordering.

On the other hand the "abi break" we are talking about is that a user
might have to increase a configured limit in a config file after a
kernel upgrade.

IDK what consensus exists here, I've never heard of anyone saying
these limits are a strict ABI like this.. I think at least for cgroup
that would be so invasive as to immediately be off the table.

Jason
