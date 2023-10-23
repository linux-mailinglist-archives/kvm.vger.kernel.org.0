Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A1F7D3BD1
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 18:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjJWQKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 12:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbjJWQKP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 12:10:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779E510C3
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 09:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698077362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bqqE5czpXMxH5iFgmUcq2irlpONgu0FEk0Dvm4SVDQU=;
        b=R86D1YbVnJUc4OOS5bZrRpCufNR1t+Ab/85A1S/+z2Vdsftx+foBFcvNn8tDQHQnzssQq6
        6UWEJXSnhc85rzjHs73ApL4z2y2a0nBfVlka9bUGIC1K2eiUWBaVazKrMulIW6Tt6fPXti
        n8dJShZKQbdNQOnQv26Jtc/G+lhqvrM=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-qAkLXVbtPsaUuR1koXffXA-1; Mon, 23 Oct 2023 12:09:16 -0400
X-MC-Unique: qAkLXVbtPsaUuR1koXffXA-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-79fd91b8494so471451339f.3
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 09:09:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698077355; x=1698682155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bqqE5czpXMxH5iFgmUcq2irlpONgu0FEk0Dvm4SVDQU=;
        b=ZT6GYkkzozpB98Kf56RmkPijUknjcwVzDFiNinCRnRi+AeJ1u32v20zeYG6pL3mjrc
         K7aTfzZWLrJL+OR9377ZLmiBLs0ffHGAoKaX9CvCVv20NQYC7l+Uxojk5XPrIwTNNffD
         zsMGfjKE4ByLJskBzzHdJiJfQs5a6lRZmB0gHL7I4bfBoUjAigq9pu0mE0W2JnYG3Nf5
         LXb25L7KOLry78yTYemPekNixNKdMlTSNS1pNM7U+FobSc7x6kCv60uUPXlWJHkyyi0a
         kOageIwckNu0oYHNNbsgj3Olbm/bZag5nAndVnQ5lsLA/RkZJ1v71Garmvaaf6vWqRBH
         LAKQ==
X-Gm-Message-State: AOJu0YywrO4P4HPt18vEnBaKvRmg99v5TxOxJwv5j3GSrtGDa8fKH6e3
        LIKVuGdnhc7SD2BtvIEOQftiNMmxjQ9sWYs3xq1MvhLGTqmt48pfp51fvcyjbp/K5yUZCGvjO5a
        8LCe7LY5DjfEM
X-Received: by 2002:a05:6602:150d:b0:7a9:5ac1:549e with SMTP id g13-20020a056602150d00b007a95ac1549emr4219050iow.8.1698077355388;
        Mon, 23 Oct 2023 09:09:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMh98OjQBLUxNybkpE1MPJ4Xw+W2v26Ibokh2vgJ0Hf/IrBfQpSS6ukaHHKPqIszxXCSSIOw==
X-Received: by 2002:a05:6602:150d:b0:7a9:5ac1:549e with SMTP id g13-20020a056602150d00b007a95ac1549emr4219022iow.8.1698077355151;
        Mon, 23 Oct 2023 09:09:15 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id fw13-20020a0566381d8d00b0042b4b55f46fsm2275798jab.117.2023.10.23.09.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 09:09:14 -0700 (PDT)
Date:   Mon, 23 Oct 2023 10:09:13 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com,
        si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com,
        jasowang@redhat.com
Subject: Re: [PATCH V1 vfio 0/9] Introduce a vfio driver over virtio devices
Message-ID: <20231023100913.39dcefba.alex.williamson@redhat.com>
In-Reply-To: <20231023154257.GZ3952@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
        <6e2c79c2-5d1d-3f3b-163b-29403c669049@nvidia.com>
        <20231023093323.2a20b67c.alex.williamson@redhat.com>
        <20231023154257.GZ3952@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Oct 2023 12:42:57 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Oct 23, 2023 at 09:33:23AM -0600, Alex Williamson wrote:
> 
> > > Alex,
> > > Are you fine to leave the provisioning of the VF including the control 
> > > of its transitional capability in the device hands as was suggested by 
> > > Jason ?  
> > 
> > If this is the standard we're going to follow, ie. profiling of a
> > device is expected to occur prior to the probe of the vfio-pci variant
> > driver, then we should get the out-of-tree NVIDIA vGPU driver on board
> > with this too.  
> 
> Those GPU drivers are using mdev not vfio-pci..

The SR-IOV mdev vGPUs rely on the IOMMU backing device support which
was removed from upstream.  They only exist in the mdev form on
downstreams which have retained this interface for compatibility and
continuity.  I'm not aware of any other means by which the SR-IOV RID
can be used in the mdev model, therefore only the pre-SR-IOV GPUs
should continue to use the mdev interface.

> mdev doesn't have a way in its uapi to configure the mdev before it is
> created.

Of course.  Thanks,

Alex

