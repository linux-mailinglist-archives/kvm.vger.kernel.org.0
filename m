Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93144697B08
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 12:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbjBOLqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 06:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233682AbjBOLql (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 06:46:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62533A9B
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 03:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676461554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gx6lloEADLK78/decfvNuOIH7Z76rhDLA1nc7SYA9k8=;
        b=i+4w98R29+6POkF+evXYpaVViOdJ/idasPb1lXdESa5/riW24m5E2lZOcM98vHperxPjSI
        XHIlnDvZfGqiVkoQaEYshpT3rT0CQZFsI1MaHhl8g9rn89WTxDZlCm7m96aWEgwWNDtMnG
        bCKwioCy0G9r4QMXZPILnAa2kHqp0Ug=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-325-vhrLaGT5MVyjkVVwXu8j_g-1; Wed, 15 Feb 2023 06:45:53 -0500
X-MC-Unique: vhrLaGT5MVyjkVVwXu8j_g-1
Received: by mail-wm1-f72.google.com with SMTP id b19-20020a05600c4e1300b003e10d3e1c23so1096278wmq.1
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 03:45:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gx6lloEADLK78/decfvNuOIH7Z76rhDLA1nc7SYA9k8=;
        b=AwDHswpAaKvkjznPdXiaCLfwU+CWQrykL9HlqqMl3cPlYvJpctHwz005puFj5FQDh8
         gfy8Y+sAez3nodhBAb48c0ME4J07mfTVySm3BeJt21pueP6FAkRoAoUDqtvvhPDrqNmn
         vMbL/3l3jsBWfZy/SrG7HsjBWxCerDSmmAPNsnp1B7ZBJ4Y8qqZ/lGq1YxdVZtHQ7bkR
         AbRkttIo+ckfxv6/T4Zxm/g/LOnQNRDS55Pq9iSUi7eaO97EvxfqAxEllsjAWe+rQoXR
         TZ8X08PHryMTmIz0guhH+a1Y3xR6AVgKTFrpBH/A83QwPl5VOZqqouCN+8Sww5tz/9+P
         8cow==
X-Gm-Message-State: AO0yUKUQu1wKeXKYpllEZVhHtdahBtrd+byi6k7jB073l7xQVc7fpyCA
        U3+nnfxl1V5AvNk2/zLu1mTPqB0VzhcCk9SdusmT2WPLbM0vcjmTDm0/qRx/I4CyPyU/K+jlLYc
        OFpZU86JrCvtn
X-Received: by 2002:a05:600c:2b46:b0:3df:f85a:472f with SMTP id e6-20020a05600c2b4600b003dff85a472fmr1810826wmf.13.1676461552403;
        Wed, 15 Feb 2023 03:45:52 -0800 (PST)
X-Google-Smtp-Source: AK7set8nZozTolWM0zXwr30WCnlRjDTIljGjpf4il41K3/g5Ih7zAXVQocFbwFd0cPMbnJUphz/2fw==
X-Received: by 2002:a05:600c:2b46:b0:3df:f85a:472f with SMTP id e6-20020a05600c2b4600b003dff85a472fmr1810808wmf.13.1676461552152;
        Wed, 15 Feb 2023 03:45:52 -0800 (PST)
Received: from redhat.com ([2.52.5.34])
        by smtp.gmail.com with ESMTPSA id w8-20020a05600c474800b003de2fc8214esm1967316wmo.20.2023.02.15.03.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 03:45:51 -0800 (PST)
Date:   Wed, 15 Feb 2023 06:45:48 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Cc:     Jason Wang <jasowang@redhat.com>, arei.gonglei@huawei.com,
        yechuan@huawei.com, huangzhichao@huawei.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: cleanup memory maps when closing vdpa fds
Message-ID: <20230215064454-mutt-send-email-mst@kernel.org>
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
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
> 
> > Btw, it looks like we should call vhost_vdpa_free_domain() *after*
> > vhost_vdpa_cleanup() otherwise it's a UAF?
> > 
> I think so, the v->domain is set to NULL in vhost_vdpa_free_domain(), it
> seems would trigger null-pointer access in my case.


OK I'll drop this patch for now then?

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

