Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 282337C00E9
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 17:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbjJJP7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 11:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbjJJP7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 11:59:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BDD93
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696953501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oudCQHyxcWdtlvLX8YwEj24sygXojgTSTrmilxTDJr4=;
        b=Kl5y4w0xVdGIVy18xeounmpC/r4duFX75FpURZkVR4H/ADefR1VO0pLThcXAwY61ppQ/Zi
        K3tgkvm/jjzibVXTIv01Fk9SmgiL3WVHsJh0LYrUxbs4zohxF2bWLcy/Q6/XsJnqZi2Imx
        2X/tDet3w1TfAf3GtNcf/96ItkR2E4E=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-Ys3B5gv2OyezUkxH6fVrbw-1; Tue, 10 Oct 2023 11:58:19 -0400
X-MC-Unique: Ys3B5gv2OyezUkxH6fVrbw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4063dd6729bso38130105e9.2
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 08:58:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696953498; x=1697558298;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oudCQHyxcWdtlvLX8YwEj24sygXojgTSTrmilxTDJr4=;
        b=ayOw+n+sNOYDC4arn/wq4CFBMjnOBzf3mRJoTtuvIshl+isgsjPPyXF2gQIvqt9d2q
         rSCYHMESCiiNddbKx7+6rjyFmi7DAA72yMW2ffemvGnim5/Km+8p8TH3Ffu/qtI8Unr0
         6y5gr1perWnpWxt3Fdet6Oo52JsXoS3bYqk3cbcFlZwqWPT85GEF4D76WO7soATioKrw
         kNJkkyCmZAF/769ChwPlEa5mPVnp8HkqqFSRgcOFnwU8n1bsHO8LvvIPfVwjV/lQzj5P
         XUMYcsV9GQPdf+ma3VStVNgNMPPRNK2R+VOy+n3q6bfKZeymhUcCkKpQaKIiiifJvkki
         8FEg==
X-Gm-Message-State: AOJu0YxPcT0O0v0UTQ3qt/wwTtFcyvuFhD9ZCCFDNAsJ7xZKHwErn2Tq
        RqA+h62WMEh298ni+WEQsC1HIH7fO+9e3r76wf9qHedqLlYrUfknnIlF8OA2Wllg8EuaoJOB+lv
        3HKRZ5iBIgs11
X-Received: by 2002:a7b:cb89:0:b0:401:b6f6:d8fd with SMTP id m9-20020a7bcb89000000b00401b6f6d8fdmr16185161wmi.6.1696953498719;
        Tue, 10 Oct 2023 08:58:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG28WYkFmBDZib1M7Q1/8gOqudz57nP7zYs4YtXbOBDq/kTRAGT7TnBEIRoAQrgtiAun/WLYQ==
X-Received: by 2002:a7b:cb89:0:b0:401:b6f6:d8fd with SMTP id m9-20020a7bcb89000000b00401b6f6d8fdmr16185152wmi.6.1696953498343;
        Tue, 10 Oct 2023 08:58:18 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73d2:bf00:e379:826:5137:6b23])
        by smtp.gmail.com with ESMTPSA id y8-20020a7bcd88000000b00406447b798bsm16815932wmj.37.2023.10.10.08.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 08:58:17 -0700 (PDT)
Date:   Tue, 10 Oct 2023 11:58:14 -0400
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
Message-ID: <20231010115649-mutt-send-email-mst@kernel.org>
References: <ZR54shUxqgfIjg/p@infradead.org>
 <20231005111004.GK682044@nvidia.com>
 <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <8ea954ba-e966-0b87-b232-06ffd79db4e3@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ea954ba-e966-0b87-b232-06ffd79db4e3@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 06:43:32PM +0300, Yishai Hadas wrote:
> On 10/10/2023 18:14, Michael S. Tsirkin wrote:
> > On Tue, Oct 10, 2023 at 06:09:44PM +0300, Yishai Hadas wrote:
> > > On 10/10/2023 17:54, Michael S. Tsirkin wrote:
> > > > On Tue, Oct 10, 2023 at 11:08:49AM -0300, Jason Gunthorpe wrote:
> > > > > On Tue, Oct 10, 2023 at 09:56:00AM -0400, Michael S. Tsirkin wrote:
> > > > > 
> > > > > > > However - the Intel GPU VFIO driver is such a bad experiance I don't
> > > > > > > want to encourage people to make VFIO drivers, or code that is only
> > > > > > > used by VFIO drivers, that are not under drivers/vfio review.
> > > > > > So if Alex feels it makes sense to add some virtio functionality
> > > > > > to vfio and is happy to maintain or let you maintain the UAPI
> > > > > > then why would I say no? But we never expected devices to have
> > > > > > two drivers like this does, so just exposing device pointer
> > > > > > and saying "use regular virtio APIs for the rest" does not
> > > > > > cut it, the new APIs have to make sense
> > > > > > so virtio drivers can develop normally without fear of stepping
> > > > > > on the toes of this admin driver.
> > > > > Please work with Yishai to get something that make sense to you. He
> > > > > can post a v2 with the accumulated comments addressed so far and then
> > > > > go over what the API between the drivers is.
> > > > > 
> > > > > Thanks,
> > > > > Jason
> > > > /me shrugs. I pretty much posted suggestions already. Should not be hard.
> > > > Anything unclear - post on list.
> > > > 
> > > Yes, this is the plan.
> > > 
> > > We are working to address the comments that we got so far in both VFIO &
> > > VIRTIO, retest and send the next version.
> > > 
> > > Re the API between the modules, It looks like we have the below
> > > alternatives.
> > > 
> > > 1) Proceed with current approach where we exposed a generic API to execute
> > > any admin command, however, make it much more solid inside VIRTIO.
> > > 2) Expose extra APIs from VIRTIO for commands that we can consider future
> > > client usage of them as of LIST_QUERY/LIST_USE, however still have the
> > > generic execute admin command for others.
> > > 3) Expose API per command from VIRTIO and fully drop the generic execute
> > > admin command.
> > > 
> > > Few notes:
> > > Option #1 looks the most generic one, it drops the need to expose multiple
> > > symbols / APIs per command and for now we have a single client for them
> > > (i.e. VFIO).
> > > Options #2 & #3, may still require to expose the virtio_pci_vf_get_pf_dev()
> > > API to let VFIO get the VIRTIO PF (struct virtio_device *) from its PCI
> > > device, each command will get it as its first argument.
> > > 
> > > Michael,
> > > What do you suggest here ?
> > > 
> > > Thanks,
> > > Yishai
> > I suggest 3 but call it on the VF. commands will switch to PF
> > internally as needed. For example, intel might be interested in exposing
> > admin commands through a memory BAR of VF itself.
> > 
> The driver who owns the VF is VFIO, it's not a VIRTIO one.
> 
> The ability to get the VIRTIO PF is from the PCI device (i.e. struct
> pci_dev).
> 
> In addition,
> virtio_pci_vf_get_pf_dev() was implemented for now in virtio-pci as it
> worked on pci_dev.

On pci_dev of vf, yes? So again just move this into each command,
that's all. I.e. pass pci_dev to each.

> Assuming that we'll put each command inside virtio as the generic layer, we
> won't be able to call/use this API internally to get the PF as of cyclic
> dependencies between the modules, link will fail.
> 
> So in option #3 we may still need to get outside into VFIO the VIRTIO PF and
> give it as pointer to VIRTIO upon each command.
> 
> Does it work for you ?
> 
> Yishai

