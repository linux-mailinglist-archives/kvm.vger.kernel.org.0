Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C091A203BB9
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 18:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbgFVQA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 12:00:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53684 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729295AbgFVQAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 12:00:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592841654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KVVo1o4umZNzjH+FG7Lke6lFdsLIhTFS1KQNZFyeoJQ=;
        b=FKCvN8bHyyGHUcIk6+tsYHn3iMsyl/0lsRJdtghmB4QNvIvpiqk2XetE1zvKcrJAeJOHTZ
        T8HZfjqiujaus7GDMsmroyJmiLEnIAVKZqBb4I6rtEPy/DfoJ+IW/c7GmjjvO3EyzjyDxz
        9q8FNMn3KIe20l7l0AGGbqPVU5tQu1Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-VYs7kg8COQymo8Dy22i3fQ-1; Mon, 22 Jun 2020 12:00:52 -0400
X-MC-Unique: VYs7kg8COQymo8Dy22i3fQ-1
Received: by mail-wr1-f69.google.com with SMTP id l3so1845049wrw.4
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 09:00:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KVVo1o4umZNzjH+FG7Lke6lFdsLIhTFS1KQNZFyeoJQ=;
        b=bwsYm3SQEULakVW4BcBrPdKh4moJRqzEQbGxx2ZN9Ozlq+zYw2tX4jxyozfe18JjPl
         GBBF3Q13of05+Qo7Uy2rWFPHTY0VJ1eUADQYCgAB5VklQ1JRUmBuS+W99u4iDkCntUoX
         shNMhWGIHT3yek7jCx7pCmutchCNayGTL1f+av+If8AIr6claAdG8SvE5qiEbyCGZKLz
         uwRR6Ii2pTIo9zn+jgQQFWEZuUNIELyMTe9xGZ2+0Kxy7HEkVvxpLhuqgynYlvsaJgbl
         wTeIiB9Sh4CnWj0mwa6+7QCYeGICWg4mfVJyotyzJMCXbgHfFd1RSRW2Xyma8yeVYlw2
         pp+Q==
X-Gm-Message-State: AOAM5322GmixegJ4tnCUyO4Jb5Lla3HsUoU0EV25e6cen/bRtVcgrADE
        kzdMktQO6oOhFHxdtTTPCbE8bUMp5iARlOZx79NwtS3sm6ntZ40Jl8vCz2gwFx9tktrUIYQfIh8
        g0ce4qScH+/CN
X-Received: by 2002:a7b:c385:: with SMTP id s5mr20342981wmj.121.1592841651776;
        Mon, 22 Jun 2020 09:00:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvgPO5JBany+h/NfYkGnwDtTNClIm0IeoiYnCbawxbhnKhPFgGcHzSS6vD+M99GoPOJKnLZg==
X-Received: by 2002:a7b:c385:: with SMTP id s5mr20342963wmj.121.1592841651583;
        Mon, 22 Jun 2020 09:00:51 -0700 (PDT)
Received: from redhat.com (bzq-79-178-18-124.red.bezeqint.net. [79.178.18.124])
        by smtp.gmail.com with ESMTPSA id 125sm2256wmc.23.2020.06.22.09.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 09:00:50 -0700 (PDT)
Date:   Mon, 22 Jun 2020 12:00:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        eperezma@redhat.com
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
Message-ID: <20200622115946-mutt-send-email-mst@kernel.org>
References: <20200611113404.17810-1-mst@redhat.com>
 <20200611113404.17810-3-mst@redhat.com>
 <0332b0cf-cf00-9216-042c-e870efa33626@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0332b0cf-cf00-9216-042c-e870efa33626@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 17, 2020 at 11:19:26AM +0800, Jason Wang wrote:
> 
> On 2020/6/11 下午7:34, Michael S. Tsirkin wrote:
> >   static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
> >   {
> >   	kfree(vq->descs);
> > @@ -394,6 +400,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
> >   	for (i = 0; i < dev->nvqs; ++i) {
> >   		vq = dev->vqs[i];
> >   		vq->max_descs = dev->iov_limit;
> > +		if (vhost_vq_num_batch_descs(vq) < 0) {
> > +			return -EINVAL;
> > +		}
> 
> 
> This check breaks vdpa which set iov_limit to zero. Consider iov_limit is
> meaningless to vDPA, I wonder we can skip the test when device doesn't use
> worker.
> 
> Thanks

It doesn't need iovecs at all, right?

-- 
MST

