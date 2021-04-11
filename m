Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A240435B6E9
	for <lists+kvm@lfdr.de>; Sun, 11 Apr 2021 22:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236567AbhDKUtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Apr 2021 16:49:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50802 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235933AbhDKUtR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 11 Apr 2021 16:49:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618174140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WgCMOQWQVsoo18S8HwQ+Un6/4nDLRTxeG+tZrHLLzJw=;
        b=bdYSWC3XE+cTZlbNJ5prS7TWyaTetI1UTadbwdB3OZ8Bms/mP2E7+2Qfq4OlGxDaDwHByl
        LrpVwOvWlCOqryAbtUmYpyO0ENdagHyCutOo3jEtCtalbpuijVoGgerbf0ORsIaJ98PpXF
        xuPKlL5VInMRM+8sB4eGbYT8QrHq56s=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-_Mr92jYDNoSpl9iT1NR0zA-1; Sun, 11 Apr 2021 16:48:58 -0400
X-MC-Unique: _Mr92jYDNoSpl9iT1NR0zA-1
Received: by mail-wr1-f69.google.com with SMTP id 75so5092799wrl.3
        for <kvm@vger.kernel.org>; Sun, 11 Apr 2021 13:48:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WgCMOQWQVsoo18S8HwQ+Un6/4nDLRTxeG+tZrHLLzJw=;
        b=AJtxRJjjgbyfXeveVlq67j0GHp85qNsNWffacBcTaWB9KpClEeZcdvswH4/fuasLRn
         JmgQaHJlYkM9e44Ce2Rqdm8QxTSTYqg8o7MK2awupEUIMoEH81jVUJ4Oq9rOI1oWwwss
         hPGIFmxx327ox6oqKe8JB24s/vCaR6/ZrVwkX7LU66QZYt9LlKXACReC/mxACLx4xwP3
         ok3/L7gURBJqpzCQoexuPz1/KaDlUfKwcR9POfJW20HHcR7gECupcd9PUE5epZBox4A6
         ZM787V4ylB/op0S8s2CvvdQ/sY52sgQHI9riLNz/RtyWv19n6u2yxaIjtJwrPlMnvLZx
         HLSw==
X-Gm-Message-State: AOAM532OhFEtaDZvhYYXAOXjuEdK4td6bFO87+TlgI89qPBOMq3WLjhA
        qI7qLpxYjoUT9yf4MI9V+L22/33YWMrhPKz2rrWnHfOzu6qnsyOM60QKDDYQdApB6RSWpgV3gBz
        bow6K7pCelMA0
X-Received: by 2002:adf:f64f:: with SMTP id x15mr12219239wrp.266.1618174137327;
        Sun, 11 Apr 2021 13:48:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZ8f1z7+lBgJ+qTQWMzJhdvfvlDPXwnCbDDkLtc7bGWr9KZU5tbgznyW47X/5g4qaJepDMnQ==
X-Received: by 2002:adf:f64f:: with SMTP id x15mr12219231wrp.266.1618174137201;
        Sun, 11 Apr 2021 13:48:57 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id a8sm15566507wrh.91.2021.04.11.13.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 13:48:56 -0700 (PDT)
Date:   Sun, 11 Apr 2021 16:48:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Re: [PATCH v6 03/10] vhost-vdpa: protect concurrent access to
 vhost device iotlb
Message-ID: <20210411164827-mutt-send-email-mst@kernel.org>
References: <20210331080519.172-1-xieyongji@bytedance.com>
 <20210331080519.172-4-xieyongji@bytedance.com>
 <20210409121512-mutt-send-email-mst@kernel.org>
 <CACycT3tPWwpGBNEqiL4NPrwGZhmUtAVHUZMOdbSHzjhN-ytg_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACycT3tPWwpGBNEqiL4NPrwGZhmUtAVHUZMOdbSHzjhN-ytg_A@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 11, 2021 at 01:36:18PM +0800, Yongji Xie wrote:
> On Sat, Apr 10, 2021 at 12:16 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, Mar 31, 2021 at 04:05:12PM +0800, Xie Yongji wrote:
> > > Use vhost_dev->mutex to protect vhost device iotlb from
> > > concurrent access.
> > >
> > > Fixes: 4c8cf318("vhost: introduce vDPA-based backend")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> >
> > I could not figure out whether there's a bug there now.
> > If yes when is the concurrent access triggered?
> >
> 
> When userspace sends the VHOST_IOTLB_MSG_V2 message concurrently?
> 
> vhost_vdpa_chr_write_iter -> vhost_chr_write_iter ->
> vhost_vdpa_process_iotlb_msg()
> 
> Thanks,
> Yongji

And then what happens currently?

-- 
MST

