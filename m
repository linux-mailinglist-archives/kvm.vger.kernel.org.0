Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C28E204C4D
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 10:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731792AbgFWIZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 04:25:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26328 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731630AbgFWIZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 04:25:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592900752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uatLoTht3LpxtV8y54s42CvqtAcAPf7U2lYUBgXuz/c=;
        b=fVb3U84p2K2Yg+P/gazZWZawGmI4PlUwIxqiyU/xOwJ46x7o8PuY/6PZmCGXjFeVPFbL2d
        kh5IEEmuSLpgzhBhboXsUUB2cXqXyU75nE1M69H3ROW2WVU22x0tocnY2gpH/Vga3wR6s6
        DhFC3VDudS6Uh4nNWD4lM1AdnW8Hc/E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-OBbQLGRLNjGHiyNx8QOtmg-1; Tue, 23 Jun 2020 04:25:50 -0400
X-MC-Unique: OBbQLGRLNjGHiyNx8QOtmg-1
Received: by mail-wr1-f70.google.com with SMTP id e11so4969491wrs.2
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 01:25:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=uatLoTht3LpxtV8y54s42CvqtAcAPf7U2lYUBgXuz/c=;
        b=J10sF8z8yDIyWgSDcNWBpIHbIoFvK8eSx3EBHM4FjnpDt/IiAjs3zXkpJzkR/noX1r
         WeY/KrETLgPD4+s/HdXMgX2YkSE09kUhe3xk6fr2Do9fp5pTtJRjuTP2cTAFp8cHUh0h
         uGRvvvs9FCTd7TV8od9kwJ7QJot41knqu+zHMobVx3ZhNsWk2w+ZvZlwZSWzUDDa8QXU
         yTPiHEJRUhMWByqfatb4ugjWZ9JeevlqQ4cf4/d/0pCOjQVt5H95kdz+E/dvyO0XDbde
         Jg4OBvYYZNI4jH04nBFMxkjXMp7NqvDf0RTLvgu/OcKOOiT/qe2/YrD0tNob37TQ20vE
         VgJQ==
X-Gm-Message-State: AOAM533IFdOmUSwugV+IlkXtT4K0a2fFL5oUCeAhIL/ZY3kNmMEbYzXr
        ks3NyodpE2SaEhAy3USea55rdplYxXScwhzkPAb5NIH8tDnYlYNRtktR2bcVP7HA26I17anpn9f
        1i0SLdEsf+3qs
X-Received: by 2002:adf:e482:: with SMTP id i2mr36530wrm.75.1592900749387;
        Tue, 23 Jun 2020 01:25:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwc3XogzeNwsdZ7v2sDlZRwXqKbrYs2e6doW+SBbFx4Sho/d0OEnV4LbHlJbrymQKkvurtxAg==
X-Received: by 2002:adf:e482:: with SMTP id i2mr36515wrm.75.1592900749185;
        Tue, 23 Jun 2020 01:25:49 -0700 (PDT)
Received: from redhat.com (bzq-79-182-31-92.red.bezeqint.net. [79.182.31.92])
        by smtp.gmail.com with ESMTPSA id e5sm19713184wrs.33.2020.06.23.01.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 01:25:48 -0700 (PDT)
Date:   Tue, 23 Jun 2020 04:25:46 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
Message-ID: <20200623042456-mutt-send-email-mst@kernel.org>
References: <20200611113404.17810-1-mst@redhat.com>
 <20200611113404.17810-3-mst@redhat.com>
 <0332b0cf-cf00-9216-042c-e870efa33626@redhat.com>
 <20200622115946-mutt-send-email-mst@kernel.org>
 <c56cc86d-a420-79ca-8420-e99db91980fa@redhat.com>
 <CAJaqyWc3C_Td_SpV97CuemkQH9vH+EL3sGgeWGE82E5gYxZNCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJaqyWc3C_Td_SpV97CuemkQH9vH+EL3sGgeWGE82E5gYxZNCA@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 09:00:57AM +0200, Eugenio Perez Martin wrote:
> On Tue, Jun 23, 2020 at 4:51 AM Jason Wang <jasowang@redhat.com> wrote:
> >
> >
> > On 2020/6/23 上午12:00, Michael S. Tsirkin wrote:
> > > On Wed, Jun 17, 2020 at 11:19:26AM +0800, Jason Wang wrote:
> > >> On 2020/6/11 下午7:34, Michael S. Tsirkin wrote:
> > >>>    static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
> > >>>    {
> > >>>     kfree(vq->descs);
> > >>> @@ -394,6 +400,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
> > >>>     for (i = 0; i < dev->nvqs; ++i) {
> > >>>             vq = dev->vqs[i];
> > >>>             vq->max_descs = dev->iov_limit;
> > >>> +           if (vhost_vq_num_batch_descs(vq) < 0) {
> > >>> +                   return -EINVAL;
> > >>> +           }
> > >> This check breaks vdpa which set iov_limit to zero. Consider iov_limit is
> > >> meaningless to vDPA, I wonder we can skip the test when device doesn't use
> > >> worker.
> > >>
> > >> Thanks
> > > It doesn't need iovecs at all, right?
> > >
> > > -- MST
> >
> >
> > Yes, so we may choose to bypass the iovecs as well.
> >
> > Thanks
> >
> 
> I think that the kmalloc_array returns ZERO_SIZE_PTR for all of them
> in that case, so I didn't bother to skip the kmalloc_array parts.
> Would you prefer to skip them all and let them NULL? Or have I
> misunderstood what you mean?
> 
> Thanks!

Sorry about being unclear. I just meant that it seems cleaner
to check for iov_limit being 0 not for worker thread.

-- 
MST

