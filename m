Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53BEE7CA2B3
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 10:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbjJPIxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 04:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbjJPIxR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 04:53:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502BAE8
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 01:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697446343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/Hrw2mCbpNBx3OcS5SFnx9OpOefvyyFxXG99mO1HFz0=;
        b=I5GORQwBW2L+BRjfA+ddIQA5lAXe/yKArZMko8exm2qqn5V1Dqe780YfVDyQBnynWxYCs6
        JGvO5Ay1rhhhd6knaW+SfI0Km6cuOLfrB85cMbf5RCNGmWMG3Z+t/9IveAUZW0TgpwphVy
        js5VXzQxTbtawxjOsU4yVU+Yh2s5PEA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-ftS4obFuOkOrYzITWzHJrQ-1; Mon, 16 Oct 2023 04:52:11 -0400
X-MC-Unique: ftS4obFuOkOrYzITWzHJrQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-323334992fbso2641356f8f.1
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 01:52:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697446330; x=1698051130;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Hrw2mCbpNBx3OcS5SFnx9OpOefvyyFxXG99mO1HFz0=;
        b=lslrJE9UpVI7lOl60jI86+em9Y+bTiVLQPRlGcIoLRsaLJ8Bniw7hYQFjRgnWPopCB
         RCIp9JouZLPAvAk3JslYYU5LRouqu3UrQzpBhA2GE5drkUbMjUeBVHgctSgEoeT961Sh
         4cHoKWy1G14TUPAbn99CTewpBWBM8YX22ieACznEPKTJM+NvxnIvwPbzRPR/JJTWXtyr
         c3/oa6Lsk0PMIFpVHS6GzkqXMrG3k6kLZHYkyBme+vhUrFV9w8ZIZgpGjKX06GiHcyij
         l0EEXPuTNETfrqGB4Q+nFF26H4xNy7xmNT3WUpEXGoBoKWNy0cdY6G5b5lMboQBcxWFZ
         c1rw==
X-Gm-Message-State: AOJu0YwOFd2glN/oSqs3lZ3MKVSGBuxm9dakAD6sA4xL+o7leXypLLEc
        Q1hgcEJ50AIfXBr5JyiiMXoarYAFwZNuEWRCS59l4Ukj9Y5tbXrODMKtQHoPW+I/DPHPFm6w2D6
        6n3EPy9DqmiXD
X-Received: by 2002:a5d:56c8:0:b0:321:4de3:fd5c with SMTP id m8-20020a5d56c8000000b003214de3fd5cmr28286173wrw.51.1697446330046;
        Mon, 16 Oct 2023 01:52:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHFHEdbEdPLPHcD0JmCIqUYkAJJe/RYZ2tIkcF4fsieSA7SiZgzIOKXHz1uInqieWq65N3GLQ==
X-Received: by 2002:a5d:56c8:0:b0:321:4de3:fd5c with SMTP id m8-20020a5d56c8000000b003214de3fd5cmr28286159wrw.51.1697446329731;
        Mon, 16 Oct 2023 01:52:09 -0700 (PDT)
Received: from redhat.com ([2a02:14f:178:f56b:1acf:3cb7:c133:f86d])
        by smtp.gmail.com with ESMTPSA id n9-20020adff089000000b0031ad2f9269dsm26639385wro.40.2023.10.16.01.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 01:52:08 -0700 (PDT)
Date:   Mon, 16 Oct 2023 04:52:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Maor Gottlieb <maorg@nvidia.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231016045050-mutt-send-email-mst@kernel.org>
References: <20231010155937.GN3952@nvidia.com>
 <ZSY9Cv5/e3nfA7ux@infradead.org>
 <20231011021454-mutt-send-email-mst@kernel.org>
 <ZSZHzs38Q3oqyn+Q@infradead.org>
 <PH0PR12MB5481336B395F38E875ED11D8DCCCA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <c75bb669-76fe-ef12-817e-2a8b5f0b317b@intel.com>
 <20231012132749.GK3952@nvidia.com>
 <840d4c6f-4150-4818-a66c-1dbe1474b4c6@intel.com>
 <20231013094959-mutt-send-email-mst@kernel.org>
 <818c4212-9d9a-4775-80f3-c07e82057be8@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <818c4212-9d9a-4775-80f3-c07e82057be8@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023 at 04:33:10PM +0800, Zhu, Lingshan wrote:
> 
> 
> On 10/13/2023 9:50 PM, Michael S. Tsirkin wrote:
> > On Fri, Oct 13, 2023 at 06:28:34PM +0800, Zhu, Lingshan wrote:
> > > 
> > > On 10/12/2023 9:27 PM, Jason Gunthorpe wrote:
> > > 
> > >      On Thu, Oct 12, 2023 at 06:29:47PM +0800, Zhu, Lingshan wrote:
> > > 
> > > 
> > >          sorry for the late reply, we have discussed this for weeks in virtio mailing
> > >          list. I have proposed a live migration solution which is a config space solution.
> > > 
> > >      I'm sorry that can't be a serious proposal - config space can't do
> > >      DMA, it is not suitable.
> > > 
> > > config space only controls the live migration process and config the related
> > > facilities.
> > > We don't use config space to transfer data.
> > > 
> > > The new added registers work like queue_enable or features.
> > > 
> > > For example, we use DMA to report dirty pages and MMIO to fetch the dirty data.
> > > 
> > > I remember in another thread you said:"you can't use DMA for any migration
> > > flows"
> > > 
> > > And I agree to that statement, so we use config space registers to control the
> > > flow.
> > > 
> > > Thanks,
> > > Zhu Lingshan
> > > 
> > > 
> > >      Jason
> > > 
> > If you are using dma then I don't see what's wrong with admin vq.
> > dma is all it does.
> dma != admin vq,

Well they share the same issue that they don't work for nesting
because DMA can not be intercepted.

> and I think we have discussed many details in pros and cons
> in admin vq live migration proposal in virtio-comment.
> I am not sure we should span the discussions here, repeat them over again.
> 
> Thanks
> > 

Yea let's not.

-- 
MST

