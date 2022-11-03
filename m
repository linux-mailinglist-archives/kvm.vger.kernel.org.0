Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7F8618B5C
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 23:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiKCWZL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 18:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiKCWZK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 18:25:10 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52074140E6
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 15:25:09 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id x13so2118789qvn.6
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 15:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q6ulxAKzgwhOEAz+Vk416yC+zAh5tU2bKFMPZ+SDAAI=;
        b=OEi2IJ5t5LhiItl3w2w445nY5kMKTZdfnRucawu1E9eH1Hrk35dMNk6pGtepQIQrK7
         rAJy9hsBhQ+CcTvjbwyfMdRm7Ekz14sSKm+2Mb1LN7rOlmPns8CaSDg0lJqQBNVUW7Ik
         ZpIAi7mnujo/5cuY69dj9+lJJ9hb46N58JrRCcKdaaWZ6bENv8hc7b1K2zvMtp3eBcc4
         OARqKj4yGzBlM2VOvGLMaGEK51TX+jtRBb3PzMvH6I8Q2PHpIjZlyM8TG/vHZYdpnAAg
         4UZUK3c2lbupvCmLibBZckpA8FMocBwb99xEuKIiDT4fc5YwiWWzE+t6yNbrICFOCtsU
         ln4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q6ulxAKzgwhOEAz+Vk416yC+zAh5tU2bKFMPZ+SDAAI=;
        b=fFhgfFVIHhubR9MAYxJ9HndIWZ4rkaGLQGyRHPHzEhMXpmi6DwH0QO9v57Oul2FPTi
         1cvQl7kV16SvRaOYSY0F4GABGnZbActx4t9RAPECWk9fFQoUZgTS4O+dg1a7OP/ietPP
         Hgxjl/BzH5a41hVL6OhBigIJ6OM7iZ3HcZKf/6GGaLDjfIzUWFD5QNUCLNwPMTMa8haW
         sLFwvWKhOpFeR9N1/PbdBa/d2XR/NCvxnR9qpiU4m1U28zyFrzyJA2/WdHdLWaXmbHXB
         BA3krhzRq2VyPDc8IOarVm3F/GXKFeRs+l6qWA8LO+7xcSa3JCOHMa5N+71TGNb8tRz8
         rChg==
X-Gm-Message-State: ACrzQf3uU2xhYZSShOiE1M/ldE7XJZSCNmCGhHzgc5djsad/4+U21SEm
        XXvG5qXX+ou5lNM+NyXWcLR7aQ==
X-Google-Smtp-Source: AMsMyM5xKijdaz8+OvrGPP5D7JyWzVjnGwrcw8IsAPnceqepAaFSFeSNaigEAZzNPaui93Kd5Cwd/A==
X-Received: by 2002:a05:6214:1bc7:b0:4bb:7aa8:b5cd with SMTP id m7-20020a0562141bc700b004bb7aa8b5cdmr29253548qvc.78.1667514308515;
        Thu, 03 Nov 2022 15:25:08 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id o5-20020ac87c45000000b003a50d92f9b4sm1324734qtv.1.2022.11.03.15.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 15:25:07 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oqie2-008RIP-Ux;
        Thu, 03 Nov 2022 19:25:06 -0300
Date:   Thu, 3 Nov 2022 19:25:06 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Anthony DeRossi <ajderossi@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "abhsahu@nvidia.com" <abhsahu@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>
Subject: Re: [PATCH v2] vfio-pci: Accept a non-zero open_count on reset
Message-ID: <Y2Q/wusmucaZF9bt@ziepe.ca>
References: <20221026194245.1769-1-ajderossi@gmail.com>
 <BN9PR11MB52763B921748415B14FFB57D8C369@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y2EFLVYwWumB9JbL@ziepe.ca>
 <20221102154527.3ad11fe2.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102154527.3ad11fe2.alex.williamson@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 02, 2022 at 03:45:27PM -0600, Alex Williamson wrote:
> > open_count was from before we changed the core code to call
> > open_device only once. If we are only a call chain from
> > open_device/close_device then we know that the open_count must be 1.
> 
> That accounts for the first test, we don't need to test open_count on
> the calling device in this path, but the idea here is that we want to
> test whether we're the last close_device among the set.  Not sure how
> we'd do that w/o some visibility to open_count.  Maybe we need a
> vfio_device_set_open_count() that when 1 we know we're the first open
> or last close?  Thanks,

Right, we are checking the open count on all the devices in the set,
so I think that just this hunk is fine:

> > > > -		if (cur->vdev.open_count)
> > > > +		if (cur != vdev && cur->vdev.open_count)
> > > >  			return false;  

Because vfio_pci_dev_set_needs_reset() is always called from
open/close (which is how it picks up the devset lock), so we never
need to consider the current device by definition, it is always "just
being closed"

A little comment to explain this and that should be it?

Jason
