Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F457C4CC4
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 10:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjJKIOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 04:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjJKIN7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 04:13:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08541BE
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 01:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697011980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KJR9k3TyCi9rex4tczfmOP96qxEW6csQZHxstTbn6es=;
        b=MUMaD+3ILRmAgYNpKt9kzVVevBvW+T5+YBgAYk5EVF3Ae5QVJCdfW7HUa7exd4HdgNEJQP
        wKUVQyn1/9iM43tb6PiZTbcFRLUCF7KekpbRyEcQEefpsQllbJLlRIcnGt/l2jgfLEfXSV
        Wo5wSUdCjqQzwFWcj+PWoe6mNzLU4bM=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-pS3rKKtRP76eLcCF0qbMYw-1; Wed, 11 Oct 2023 04:12:58 -0400
X-MC-Unique: pS3rKKtRP76eLcCF0qbMYw-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5047e8f812bso6300082e87.3
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 01:12:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697011977; x=1697616777;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KJR9k3TyCi9rex4tczfmOP96qxEW6csQZHxstTbn6es=;
        b=IK8FfjIvhQ4HRMGA6vM3PcfHqjK+wEyupHNZc1BxLGzNn1jszponAyNb5YKZ/xKuD9
         Ql4q7d8PXxajWx4J+E0IQQLxLG83mvgrkBzih6ejdvSzG0GuOXqWZpxvUJheaS9xPZ+e
         K+iYfasEHVRyjs2ZKWhtklRbWn7OGr0tlLoA7zjUwf/o9hWMT74Rtopxfrm5fz7o3N9r
         Awies86lDitIb8y4o2893nvOwiEXRXtXBjPMGlaUG5GyxHnpV5Ukzh4HfgKinCTVn9/y
         C4NAZrLZucAlDI0K32YcLjuH/1q+XV9KUhjfKbZYAgI3rUzCpEynS/mc1RI9OsIJ9b8A
         QLiQ==
X-Gm-Message-State: AOJu0YwhmqR1ht2qjnStfePslM3cnHh/CoZCChtMCvMvZYeu7QSzgz3A
        Xd3Qv04ghbWrj7HMlyhPiq5EY8sdGQbk1Jl6vEEMRgCr+ck5M7psBAIjCFmI+sCed+rDMPLiWfJ
        QyB55Ax8VAtnP
X-Received: by 2002:a05:6512:1089:b0:503:3808:389a with SMTP id j9-20020a056512108900b005033808389amr21020369lfg.11.1697011977036;
        Wed, 11 Oct 2023 01:12:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFGvRlYTp7ZjpbVRDV35Dk+uDQKxvqQ4kOkBKv489ldCkGcUWPdwk4vXDctVI+NDSRdGsoUhw==
X-Received: by 2002:a05:6512:1089:b0:503:3808:389a with SMTP id j9-20020a056512108900b005033808389amr21020348lfg.11.1697011976624;
        Wed, 11 Oct 2023 01:12:56 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73d2:bf00:e379:826:5137:6b23])
        by smtp.gmail.com with ESMTPSA id g7-20020a5d5407000000b00327df8fcbd9sm14814757wrv.9.2023.10.11.01.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 01:12:55 -0700 (PDT)
Date:   Wed, 11 Oct 2023 04:12:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231011041155-mutt-send-email-mst@kernel.org>
References: <20231010131031.GJ3952@nvidia.com>
 <20231010094756-mutt-send-email-mst@kernel.org>
 <20231010140849.GL3952@nvidia.com>
 <20231010105339-mutt-send-email-mst@kernel.org>
 <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <20231010155937.GN3952@nvidia.com>
 <ZSY9Cv5/e3nfA7ux@infradead.org>
 <20231011021454-mutt-send-email-mst@kernel.org>
 <ZSZHzs38Q3oqyn+Q@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSZHzs38Q3oqyn+Q@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 11:59:26PM -0700, Christoph Hellwig wrote:
> On Wed, Oct 11, 2023 at 02:43:37AM -0400, Michael S. Tsirkin wrote:
> > > Btw, what is that intel thing everyone is talking about?  And why
> > > would the virtio core support vendor specific behavior like that?
> > 
> > It's not a thing it's Zhu Lingshan :) intel is just one of the vendors
> > that implemented vdpa support and so Zhu Lingshan from intel is working
> > on vdpa and has also proposed virtio spec extensions for migration.
> > intel's driver is called ifcvf.  vdpa composes all this stuff that is
> > added to vfio in userspace, so it's a different approach.
> 
> Well, so let's call it virtio live migration instead of intel.
> 
> And please work all together in the virtio committee that you have
> one way of communication between controlling and controlled functions.
> If one extension does it one way and the other a different way that's
> just creating a giant mess.

Absolutely, this is exactly what I keep suggesting. Thanks for
bringing this up, will help me drive the point home!

-- 
MST

