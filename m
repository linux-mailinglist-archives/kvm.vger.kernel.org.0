Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1059618B8E
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 23:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiKCWbu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 18:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiKCWbq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 18:31:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4212C7B
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 15:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667514644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dFQqcskEaMsJv/nzLHsZye7Gc5BPG2pBqpBhEOGGuOc=;
        b=aQCSRS/8tMu8EW3fvts+j+Ag5AKyyftVJUvUPbx9ZsM1V5DYNVjmqPN9uTEzc7+HpSmEXU
        xWmUjDbTE4aKmS+5RiMODFiTxwVGoekS+Gjg73342J2cFL1zXCgPFj+RsVSl2EkDgcx2Px
        ZN6c8ze1jHWMWm10ed96nEay4wS6Ibs=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-442-fzAd24wMO9GE779lM1syvg-1; Thu, 03 Nov 2022 18:30:43 -0400
X-MC-Unique: fzAd24wMO9GE779lM1syvg-1
Received: by mail-io1-f69.google.com with SMTP id c14-20020a5ea80e000000b006d6e9b05e58so909553ioa.23
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 15:30:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dFQqcskEaMsJv/nzLHsZye7Gc5BPG2pBqpBhEOGGuOc=;
        b=5VJEM7VEn2gAPw78FqZngQV/2h2r7EsC4O4b8OCEnBbwbklWOUj9ZTP0F8ZWbD/wFH
         ufroOMq/VhKYf0Fsp3nk8Voxrra1H40nrMu6cnOKZoGh0phw5D/rlT1/M20Ikkjq0+di
         kedDMGjZaKxK9DIfAPswprx5bZkOunLewG2dSlagf/HxFcqCd17Lo73j1CTGI9sEz8tb
         KshMN0YPTLg2hEEz8GVbHBRhXQ6UTLzqRqfhKbmvCqzBr8nn9MltcxS33mxctyZ11qJn
         u8YIbycQ8uVu1h6t7EZqIK0oQlJ50Mw1jF2S4UIoxvqmRxUvpkePUgmlkPZOJg5fjHYM
         jIJg==
X-Gm-Message-State: ACrzQf0DB569ynLlKQVSnElV3OyVwNbD4SfkuMhvRzXxSwSzlsyYXdp8
        HQl/rw/5ipWt6Lt/l1m1SZqu/semN6ZoKjZQT/p6QWfPTJmsD3i5cUW2GwQz+DRirwK7bTO7M2q
        WKszZ66W2ckOD
X-Received: by 2002:a05:6e02:1605:b0:2fc:3e76:b264 with SMTP id t5-20020a056e02160500b002fc3e76b264mr18047210ilu.162.1667514642400;
        Thu, 03 Nov 2022 15:30:42 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7RLREM/wkJZOQevZ2zKDWblrtnQOLDy76/QTDrtYbqDrY3R3/3rU68xOGdsxr6aeWKyYQwiQ==
X-Received: by 2002:a05:6e02:1605:b0:2fc:3e76:b264 with SMTP id t5-20020a056e02160500b002fc3e76b264mr18047197ilu.162.1667514642215;
        Thu, 03 Nov 2022 15:30:42 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z10-20020a056602080a00b006a175fe334dsm812991iow.1.2022.11.03.15.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 15:30:41 -0700 (PDT)
Date:   Thu, 3 Nov 2022 16:30:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Anthony DeRossi <ajderossi@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "abhsahu@nvidia.com" <abhsahu@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>
Subject: Re: [PATCH v2] vfio-pci: Accept a non-zero open_count on reset
Message-ID: <20221103163040.31421b10.alex.williamson@redhat.com>
In-Reply-To: <Y2Q/wusmucaZF9bt@ziepe.ca>
References: <20221026194245.1769-1-ajderossi@gmail.com>
        <BN9PR11MB52763B921748415B14FFB57D8C369@BN9PR11MB5276.namprd11.prod.outlook.com>
        <Y2EFLVYwWumB9JbL@ziepe.ca>
        <20221102154527.3ad11fe2.alex.williamson@redhat.com>
        <Y2Q/wusmucaZF9bt@ziepe.ca>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Nov 2022 19:25:06 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Wed, Nov 02, 2022 at 03:45:27PM -0600, Alex Williamson wrote:
> > > open_count was from before we changed the core code to call
> > > open_device only once. If we are only a call chain from
> > > open_device/close_device then we know that the open_count must be 1.  
> > 
> > That accounts for the first test, we don't need to test open_count on
> > the calling device in this path, but the idea here is that we want to
> > test whether we're the last close_device among the set.  Not sure how
> > we'd do that w/o some visibility to open_count.  Maybe we need a
> > vfio_device_set_open_count() that when 1 we know we're the first open
> > or last close?  Thanks,  
> 
> Right, we are checking the open count on all the devices in the set,
> so I think that just this hunk is fine:
> 
> > > > > -		if (cur->vdev.open_count)
> > > > > +		if (cur != vdev && cur->vdev.open_count)
> > > > >  			return false;    
> 
> Because vfio_pci_dev_set_needs_reset() is always called from
> open/close (which is how it picks up the devset lock), so we never
> need to consider the current device by definition, it is always "just
> being closed"
> 
> A little comment to explain this and that should be it?

Yes, but the open question Kevin raised was that open_count is listed
as private in the header, so we ought not to be looking at it at all
from vfio-pci-core unless we want to change that or provide an alternate
interface to it.  Thanks,

Alex

