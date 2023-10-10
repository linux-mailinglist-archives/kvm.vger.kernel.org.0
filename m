Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357377C41BC
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 22:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbjJJUnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 16:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234442AbjJJUnW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 16:43:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D1FB9
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 13:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696970548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x1XkdVIAATRQKg7AHNfv10yktqcK0FF54adD52mLpgs=;
        b=P3IW8F8257HuHKZ2p2wiY2LI9allgUp9jrxOXFJY+TyYkfIs6/DQQOKtRGUI7rmom14qhY
        xZnHNRr3KY1z+4tCWyuCbhaRyrJ+cx2eJLrTD7Cz1dNadV+FRqMP5CLZuDy403g8zu0nry
        eXmWT4YrQ3+90br7zJp8f/mN4rY7pDc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-HpAwtY_WOaKAwivTftsWuw-1; Tue, 10 Oct 2023 16:42:25 -0400
X-MC-Unique: HpAwtY_WOaKAwivTftsWuw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-30e3ee8a42eso4539997f8f.1
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 13:42:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970545; x=1697575345;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x1XkdVIAATRQKg7AHNfv10yktqcK0FF54adD52mLpgs=;
        b=Xag97gEqaFxa3oR04rJC0QmNUxIZoDPUCb0rLUFdT4sxSwLZMIkjn26hPet5voXJY4
         b3fjRQaUF6X+/IMbHePcDGMLm6GSCrMeGa0J01Hut2XZj0aFYExkQDsbPpomWk0oTuC+
         A7r6qr9bJucrrD39TNSg2teDvGxtakoWzthVYI2xMq99PzyQobj7cDaz940UNAC+fyXG
         PGTGvPOzfWf6wOy1UvjI/DG1/wNVXVxd3PgNlqmx3VcgP0kAJScL+Tzz9o4gG2aOlF67
         fOYD/yPdblXABAVVc6Tk3PCKNddLV8qDx5Pvz2T08gJiCk66zGkwO2OFGjrRqGKsWu38
         7igw==
X-Gm-Message-State: AOJu0YxMoMtPdEtb4c0ysgA4hmlWTQ2SRY/GrjNuc4IyghrnHO6vG8WG
        fitD/ZyHwYiE+FYlK2r73eHgvJaQtAMf0YopjHWWxt1Ye9rnJMfqrI+f0sq+q4VdX4KTDgYSJ8o
        oywkxffS0UvNX
X-Received: by 2002:a5d:4d8e:0:b0:324:7bdd:678e with SMTP id b14-20020a5d4d8e000000b003247bdd678emr15652313wru.60.1696970544810;
        Tue, 10 Oct 2023 13:42:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFqZyOhpPTeTKIlWFJfesH3VsxsWpp8rcGB8D55JEJraH8fvsymNK3DJLM+P5GzXRJP2B4zPQ==
X-Received: by 2002:a5d:4d8e:0:b0:324:7bdd:678e with SMTP id b14-20020a5d4d8e000000b003247bdd678emr15652301wru.60.1696970544527;
        Tue, 10 Oct 2023 13:42:24 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73d2:bf00:e379:826:5137:6b23])
        by smtp.gmail.com with ESMTPSA id r18-20020adfe692000000b0031912c0ffebsm13563615wrm.23.2023.10.10.13.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:42:23 -0700 (PDT)
Date:   Tue, 10 Oct 2023 16:42:20 -0400
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
Message-ID: <20231010163914-mutt-send-email-mst@kernel.org>
References: <ZSAG9cedvh+B0c0E@infradead.org>
 <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <8ea954ba-e966-0b87-b232-06ffd79db4e3@nvidia.com>
 <20231010115649-mutt-send-email-mst@kernel.org>
 <5d83d18a-0b5a-6221-e70d-32908d967715@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d83d18a-0b5a-6221-e70d-32908d967715@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 07:09:08PM +0300, Yishai Hadas wrote:
> 
> > > Assuming that we'll put each command inside virtio as the generic layer, we
> > > won't be able to call/use this API internally to get the PF as of cyclic
> > > dependencies between the modules, link will fail.

I just mean:
virtio_admin_legacy_io_write(sruct pci_device *,  ....)


internally it starts from vf gets the pf (or vf itself or whatever
the transport is) sends command gets status returns.

what is cyclic here?

-- 
MST

