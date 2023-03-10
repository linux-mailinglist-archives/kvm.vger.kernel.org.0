Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0346A6B38F2
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 09:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjCJIkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 03:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbjCJIkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 03:40:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7241010A129
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 00:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678437451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O8ovMxuqTav+RM59yevfCqZhcFC/qRlWg3JJtflmVmY=;
        b=GY6G42BoTJlkX5lWNmM1dhaPuFIaCAJ+YouFbQKNy1rnrXdKHUMpUNmWP76FNoyUGn5TTL
        W9urTHoB1cDDCSuOzGvShowk1hPhYUYS7/I5c6lpyAS3GZRXG7vaU5Q29/8wB4LxUPFjnW
        FSBFmLFhyIxyaxguvt5tEY7V+m37N1w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-aeJfNG9hNCulPHFvjVCupg-1; Fri, 10 Mar 2023 03:37:30 -0500
X-MC-Unique: aeJfNG9hNCulPHFvjVCupg-1
Received: by mail-wm1-f69.google.com with SMTP id az12-20020a05600c600c00b003e8910ec2fdso1526107wmb.6
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 00:37:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678437449;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O8ovMxuqTav+RM59yevfCqZhcFC/qRlWg3JJtflmVmY=;
        b=5vAMe621vfN1JkZNywiYJ3uzW6QnPy05pRk4t6/WLcZ7BI5q1+O6/RvGpQRY/qDpou
         0SqFQWkfssjVSgk7fC2BKwCtsegYl+N4WofVbW0nAyZyLmcb5qCBitRtTOrZ6JSPh2Qx
         jysggIKEsFvQS400uwySqIQny/Q+aKSH1OP8VtfB2/YUHEfElZ4LZcpMSx2pbRHJ3sRS
         iLLqZaapW1FiSzZKbEXpm15TOEZEAL0l7fKSdV7kzSM6SJLzKS/96morOjOYO8xrsSNy
         dSLcPDFCI1ggDUsu4ubAfeeSGdWPly8LK20BlDhelv+j6oUaoDIYte0QjNTLvo0PCqe0
         meow==
X-Gm-Message-State: AO0yUKUn/V6PITnWS2H6sN1mF58UfnMccuDzbdzNo1kHVc65OchkmH66
        BHHoIWtA+J15P8iPFfWmBb2In2Afi/qkh+YJXGA38wALwzm3v5I3i5RkDUO9qjCsXy7unQzpkYU
        Ol4taVQhcLtTT
X-Received: by 2002:a5d:6605:0:b0:2c7:7701:2578 with SMTP id n5-20020a5d6605000000b002c777012578mr15657386wru.54.1678437449505;
        Fri, 10 Mar 2023 00:37:29 -0800 (PST)
X-Google-Smtp-Source: AK7set+y1SLlYCLoZWlLhVUFLLO4mwRgZFYa2PT7ddRAXzE9lqne3QFfWheWewGObdmXBjz49fAnmw==
X-Received: by 2002:a5d:6605:0:b0:2c7:7701:2578 with SMTP id n5-20020a5d6605000000b002c777012578mr15657381wru.54.1678437449202;
        Fri, 10 Mar 2023 00:37:29 -0800 (PST)
Received: from redhat.com ([2.52.9.88])
        by smtp.gmail.com with ESMTPSA id c14-20020adffb0e000000b002c7107ce17fsm1562448wrr.3.2023.03.10.00.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 00:37:28 -0800 (PST)
Date:   Fri, 10 Mar 2023 03:37:25 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Cc:     Jason Wang <jasowang@redhat.com>, arei.gonglei@huawei.com,
        yechuan@huawei.com, huangzhichao@huawei.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: cleanup memory maps when closing vdpa fds
Message-ID: <20230310033706-mutt-send-email-mst@kernel.org>
References: <20230131145310.2069-1-longpeng2@huawei.com>
 <db99245c-606a-2f24-52fe-836a6972437f@redhat.com>
 <35b94992-0c6b-a190-1fce-5dda9c8dcf4b@huawei.com>
 <CACGkMEt0Rgkcmt9k4dWsp-qqtPvrM40mtgmSERc0A7Ve1wzKHw@mail.gmail.com>
 <ad0ab6b8-1e1e-f686-eb5c-78cc63869c54@huawei.com>
 <CACGkMEsOWmVGA1RYTNZybmzkz53g5cYEkJeMK_9uuQu-ezZcqg@mail.gmail.com>
 <af95c38d-fdca-aef0-55ae-bbb0baee6029@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <af95c38d-fdca-aef0-55ae-bbb0baee6029@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023 at 01:15:55PM +0800, Longpeng (Mike, Cloud Infrastructure Service Product Dept.) wrote:
> 
> 
> 在 2023/2/15 10:56, Jason Wang 写道:
> > On Wed, Feb 15, 2023 at 10:49 AM Longpeng (Mike, Cloud Infrastructure
> > Service Product Dept.) <longpeng2@huawei.com> wrote:
> > > 
> > > 
> > > 
> > > 在 2023/2/15 10:00, Jason Wang 写道:
> > > > On Tue, Feb 14, 2023 at 2:28 PM Longpeng (Mike, Cloud Infrastructure
> > > > Service Product Dept.) <longpeng2@huawei.com> wrote:
> > > > > 
> > > > > 
> > > > > 
> > > > > 在 2023/2/14 14:16, Jason Wang 写道:
> > > > > > 
> > > > > > 在 2023/1/31 22:53, Longpeng(Mike) 写道:
> > > > > > > From: Longpeng <longpeng2@huawei.com>
> > > > > > > 
> > > > > > > We must cleanup all memory maps when closing the vdpa fds, otherwise
> > > > > > > some critical resources (e.g. memory, iommu map) will leaked if the
> > > > > > > userspace exits unexpectedly (e.g. kill -9).
> > > > > > 
> > > > > > 
> > > > > > Sounds like a bug of the kernel, should we fix there?
> > > > > > 
> > > > > 
> > > > > For example, the iommu map is setup when QEMU calls VHOST_IOTLB_UPDATE
> > > > > ioctl and it'll be freed if QEMU calls VHOST_IOTLB_INVALIDATE ioctl.
> > > > > 
> > > > > So maybe we release these resources in vdpa framework in kernel is a
> > > > > suitable choice?
> > > > 
> > > > I think I need understand what does "resources" mean here:
> > > > 
> > > > For iommu mapping, it should be freed by vhost_vdpa_free_domain() in
> > > > vhost_vdpa_release()?
> > > > 
> > > 
> > > Please consider the following lifecycle of the vdpa device:
> > > 
> > > 1. vhost_vdpa_open
> > >       vhost_vdpa_alloc_domain
> > > 
> > > 2. vhost_vdpa_pa_map
> > >       pin_user_pages
> > >       vhost_vdpa_map
> > >         iommu_map
> > > 
> > > 3. kill QEMU
> > > 
> > > 4. vhost_vdpa_release
> > >       vhost_vdpa_free_domain
> > > 
> > > In this case, we have no opportunity to invoke unpin_user_pages or
> > > iommu_unmap to free the memory.
> > 
> > We do:
> > 
> > vhost_vdpa_cleanup()
> >      vhost_vdpa_remove_as()
> >          vhost_vdpa_iotlb_unmap()
> >              vhost_vdpa_pa_unmap()
> >                  unpin_user_pages()
> >                  vhost_vdpa_general_unmap()
> >                      iommu_unmap()
> > ?
> > 
> Oh, my codebase is linux-6.2-rc2 and the commit c070c1912a8 (vhost-vdpa: fix
> an iotlb memory leak) already fixed this bug in linux-6.2-rc3.

OK I dropped this.

> > Btw, it looks like we should call vhost_vdpa_free_domain() *after*
> > vhost_vdpa_cleanup() otherwise it's a UAF?
> > 
> I think so, the v->domain is set to NULL in vhost_vdpa_free_domain(), it
> seems would trigger null-pointer access in my case.
> 
> > Thanks
> > 
> > > 
> > > > static int vhost_vdpa_release(struct inode *inode, struct file *filep)
> > > > {
> > > >           struct vhost_vdpa *v = filep->private_data;
> > > >           struct vhost_dev *d = &v->vdev;
> > > > 
> > > >           mutex_lock(&d->mutex);
> > > >           filep->private_data = NULL;
> > > >           vhost_vdpa_clean_irq(v);
> > > >           vhost_vdpa_reset(v);
> > > >           vhost_dev_stop(&v->vdev);
> > > >           vhost_vdpa_free_domain(v);
> > > >           vhost_vdpa_config_put(v);
> > > >           vhost_vdpa_cleanup(v);
> > > >           mutex_unlock(&d->mutex);
> > > > 
> > > >           atomic_dec(&v->opened);
> > > >           complete(&v->completion);
> > > > 
> > > >           return 0;
> > > > }
> > > > 
> > > > > 
> > > > > By the way, Jason, can you reproduce the problem in your machine?
> > > > > 
> > > > 
> > > > Haven't got time in doing this but it should be the responsibility of
> > > > the author to validate this anyhow.
> > > > 
> > > > Thanks
> > > > 
> > > > > > Thanks
> > > > > > 
> > > > > > 
> > > > > > > 
> > > > > > > Signed-off-by: Longpeng <longpeng2@huawei.com>
> > > > > > > ---
> > > > > > >     drivers/vhost/vdpa.c | 13 +++++++++++++
> > > > > > >     1 file changed, 13 insertions(+)
> > > > > > > 
> > > > > > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > > > > > index a527eeeac637..37477cffa5aa 100644
> > > > > > > --- a/drivers/vhost/vdpa.c
> > > > > > > +++ b/drivers/vhost/vdpa.c
> > > > > > > @@ -823,6 +823,18 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v,
> > > > > > >             vhost_vdpa_remove_as(v, asid);
> > > > > > >     }
> > > > > > > +static void vhost_vdpa_clean_map(struct vhost_vdpa *v)
> > > > > > > +{
> > > > > > > +    struct vhost_vdpa_as *as;
> > > > > > > +    u32 asid;
> > > > > > > +
> > > > > > > +    for (asid = 0; asid < v->vdpa->nas; asid++) {
> > > > > > > +        as = asid_to_as(v, asid);
> > > > > > > +        if (as)
> > > > > > > +            vhost_vdpa_unmap(v, &as->iotlb, 0ULL, 0ULL - 1);
> > > > > > > +    }
> > > > > > > +}
> > > > > > > +
> > > > > > >     static int vhost_vdpa_va_map(struct vhost_vdpa *v,
> > > > > > >                      struct vhost_iotlb *iotlb,
> > > > > > >                      u64 iova, u64 size, u64 uaddr, u32 perm)
> > > > > > > @@ -1247,6 +1259,7 @@ static int vhost_vdpa_release(struct inode
> > > > > > > *inode, struct file *filep)
> > > > > > >         vhost_vdpa_clean_irq(v);
> > > > > > >         vhost_vdpa_reset(v);
> > > > > > >         vhost_dev_stop(&v->vdev);
> > > > > > > +    vhost_vdpa_clean_map(v);
> > > > > > >         vhost_vdpa_free_domain(v);
> > > > > > >         vhost_vdpa_config_put(v);
> > > > > > >         vhost_vdpa_cleanup(v);
> > > > > > 
> > > > > > .
> > > > > 
> > > > 
> > > > .
> > > 
> > 
> > .

