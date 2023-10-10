Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7233B7C0023
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 17:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbjJJPPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 11:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbjJJPPu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 11:15:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A2DAC
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696950913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GHpFxBERmN94QT85J+WdpBBalBO00T++ys1+HPeoAWk=;
        b=KsR6mttQxMmJ5sFM3frTEvGArg5J9/UatrLnsQgJUB0zrsB+XPaVXaWSpM+i6LYtjG7f6A
        Y102it6/ZacRIvwQIL7IjMB5x4RV/yhwj8x/oYKwTKt/EPMOCFYNEW9XDd/nwR+C/Rg+Td
        HYyDH3NGMbKCCfJf0tpGeHEreKKdIE4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-185-E0oJ82amOrm28IWUIu9NfQ-1; Tue, 10 Oct 2023 11:15:01 -0400
X-MC-Unique: E0oJ82amOrm28IWUIu9NfQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-32d33e3aea5so411376f8f.0
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:15:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696950900; x=1697555700;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GHpFxBERmN94QT85J+WdpBBalBO00T++ys1+HPeoAWk=;
        b=APLypjmG3x4q+olzMxxwiuoOvJDuh0dUxLt1255Rrx6/PJWKx6RnPhE3kmIYxcC3ho
         0R4sWiqFFlkyRfIaA5OAzVF8nC8BATqlhCw4iorfMNh/mUL0DcJD/B56uC8JPROzRxYY
         sPGhU3Jzx2r2Bm22XE38Cb1BdLBhSxS7pxB86pR9azumTiTeE1SrCgF4W+BcR8P36X0/
         93OuxAqXUCwSJyRnGJ/4jSCsyit6aO8LukgYc+NVkXJ6sFvi3d8+DWxmGky1aMtcMLWp
         /P5iTQG3BcB+xqHLw+S9+HQnQdjopu7AXUY6Rc5V42ihrpIiBERLTMWI65YenCO/1ppC
         qKCA==
X-Gm-Message-State: AOJu0YxXeVH+7xOLfJW6e4K7UmZcrjZBL3BsjfcDoDVBiAIOOcw/wlzF
        4sqWEPJYcBmeTMjOPV0UxMG4MZggBailNkkWcBNkI/E0AtIwq3sQYrHm5V2R7wFk78NWZK4D/En
        ljwATYPt8WwUG
X-Received: by 2002:a5d:6a07:0:b0:321:7844:de44 with SMTP id m7-20020a5d6a07000000b003217844de44mr16804693wru.45.1696950900460;
        Tue, 10 Oct 2023 08:15:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG84AaoUmlneyrEi00sIOswcQ5D6yjewF+xLa/MTuiZ1Uy9G0hmbcn7y3K+vJT1cU5isAVSoA==
X-Received: by 2002:a5d:6a07:0:b0:321:7844:de44 with SMTP id m7-20020a5d6a07000000b003217844de44mr16804672wru.45.1696950899983;
        Tue, 10 Oct 2023 08:14:59 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73d2:bf00:e379:826:5137:6b23])
        by smtp.gmail.com with ESMTPSA id w15-20020adfcd0f000000b0030647449730sm13068784wrm.74.2023.10.10.08.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 08:14:59 -0700 (PDT)
Date:   Tue, 10 Oct 2023 11:14:56 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        alex.williamson@redhat.com, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231010111339-mutt-send-email-mst@kernel.org>
References: <ZRpjClKM5mwY2NI0@infradead.org>
 <20231002151320.GA650762@nvidia.com>
 <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com>
 <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 06:09:44PM +0300, Yishai Hadas wrote:
> On 10/10/2023 17:54, Michael S. Tsirkin wrote:
> > On Tue, Oct 10, 2023 at 11:08:49AM -0300, Jason Gunthorpe wrote:
> > > On Tue, Oct 10, 2023 at 09:56:00AM -0400, Michael S. Tsirkin wrote:
> > > 
> > > > > However - the Intel GPU VFIO driver is such a bad experiance I don't
> > > > > want to encourage people to make VFIO drivers, or code that is only
> > > > > used by VFIO drivers, that are not under drivers/vfio review.
> > > > So if Alex feels it makes sense to add some virtio functionality
> > > > to vfio and is happy to maintain or let you maintain the UAPI
> > > > then why would I say no? But we never expected devices to have
> > > > two drivers like this does, so just exposing device pointer
> > > > and saying "use regular virtio APIs for the rest" does not
> > > > cut it, the new APIs have to make sense
> > > > so virtio drivers can develop normally without fear of stepping
> > > > on the toes of this admin driver.
> > > Please work with Yishai to get something that make sense to you. He
> > > can post a v2 with the accumulated comments addressed so far and then
> > > go over what the API between the drivers is.
> > > 
> > > Thanks,
> > > Jason
> > /me shrugs. I pretty much posted suggestions already. Should not be hard.
> > Anything unclear - post on list.
> > 
> Yes, this is the plan.
> 
> We are working to address the comments that we got so far in both VFIO &
> VIRTIO, retest and send the next version.
> 
> Re the API between the modules, It looks like we have the below
> alternatives.
> 
> 1) Proceed with current approach where we exposed a generic API to execute
> any admin command, however, make it much more solid inside VIRTIO.
> 2) Expose extra APIs from VIRTIO for commands that we can consider future
> client usage of them as of LIST_QUERY/LIST_USE, however still have the
> generic execute admin command for others.
> 3) Expose API per command from VIRTIO and fully drop the generic execute
> admin command.
> 
> Few notes:
> Option #1 looks the most generic one, it drops the need to expose multiple
> symbols / APIs per command and for now we have a single client for them
> (i.e. VFIO).
> Options #2 & #3, may still require to expose the virtio_pci_vf_get_pf_dev()
> API to let VFIO get the VIRTIO PF (struct virtio_device *) from its PCI
> device, each command will get it as its first argument.
> 
> Michael,
> What do you suggest here ?
> 
> Thanks,
> Yishai

I suggest 3 but call it on the VF. commands will switch to PF
internally as needed. For example, intel might be interested in exposing
admin commands through a memory BAR of VF itself.

-- 
MST

