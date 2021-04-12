Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBF735BF2B
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 11:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237897AbhDLJDG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 05:03:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47635 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239635AbhDLJA7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 05:00:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618218041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RO2S6yuC/fkuz9B4sqL4SZHXLtN0NgAiJyds25neUik=;
        b=F65/dqilpIY3dlFhHJlfBUHtCJO1etStPCYwuddmqfDQGG5O+sQpdBkHB5Xh+u4A8e2a/U
        r2nWNgUeYXc3OxjPm/WekCHtspMVuMidT9jHx0Lc0kCn8DyvXGDiSbSD7JZcGCoK2AovBb
        meM4Trhdu4hmSh4SZpLKdIUABhoOX3o=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-V8ASh7qDO0-ivJaeh_ULXA-1; Mon, 12 Apr 2021 05:00:39 -0400
X-MC-Unique: V8ASh7qDO0-ivJaeh_ULXA-1
Received: by mail-wm1-f72.google.com with SMTP id u7-20020a05600c19c7b029010c8bb11793so1871764wmq.0
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 02:00:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RO2S6yuC/fkuz9B4sqL4SZHXLtN0NgAiJyds25neUik=;
        b=H5UZh64O+m7bxaA/vX1mTTVz4gHXXeIm3PytsIAf+OjXSzX/wxUNP8F9tMxoC1OS/7
         6r91/z1DzVWcOAZ2s6SQYrDwXlnhSKdAYqKTDtX1vvIcsn/hRirJmF+8kIblfVhF9NlT
         w9LNIKWBgvfTlHfwdbTVcJZzFzzLgu0LiV8vn2WXQElQJyB3zq+a0b6l8yzfRZC3XrHz
         GG9p1N6B199c//hjDTx7S3SuKRY6Ou1tJHi0nxm98Vnty0x8ZherdGinkJdsp16j+xXm
         s0GenYy6C64RCchVdVZuzjL/ZDAgjr7JW7MbECcTigrh0EVbZB/DMbC0Y6EY23rMPO/b
         +Bww==
X-Gm-Message-State: AOAM530Fcxz+EMZyLejVK0NWSjM1YDGICIDI4C3hgynw+edaU9EPt/dI
        o9bCo1MQK3DPVAlPgY7NMf+G9VvpAyWOUV3tRnZQO02qBDMymX6v/vtk0wZu8z1eV0xCGwq/2yX
        d9zKQjupebvoi
X-Received: by 2002:a5d:6b82:: with SMTP id n2mr29772917wrx.399.1618218038399;
        Mon, 12 Apr 2021 02:00:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxR/AIXG2BimYzUPAOwQOnyWTMrNFFGz9SnJpjM9QiX4VEr9DYg+h2pMbQsHiZXPHGLQ0yBvg==
X-Received: by 2002:a5d:6b82:: with SMTP id n2mr29772882wrx.399.1618218038215;
        Mon, 12 Apr 2021 02:00:38 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id m5sm15675048wrx.83.2021.04.12.02.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 02:00:37 -0700 (PDT)
Date:   Mon, 12 Apr 2021 05:00:33 -0400
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
Subject: Re: Re: Re: [PATCH v6 03/10] vhost-vdpa: protect concurrent access
 to vhost device iotlb
Message-ID: <20210412045900-mutt-send-email-mst@kernel.org>
References: <20210331080519.172-1-xieyongji@bytedance.com>
 <20210331080519.172-4-xieyongji@bytedance.com>
 <20210409121512-mutt-send-email-mst@kernel.org>
 <CACycT3tPWwpGBNEqiL4NPrwGZhmUtAVHUZMOdbSHzjhN-ytg_A@mail.gmail.com>
 <20210411164827-mutt-send-email-mst@kernel.org>
 <CACycT3v5Z8s9_pL79m0FY5jxx3fTRHHbtARfg0On3xTnNCOdkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACycT3v5Z8s9_pL79m0FY5jxx3fTRHHbtARfg0On3xTnNCOdkg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 10:29:17AM +0800, Yongji Xie wrote:
> On Mon, Apr 12, 2021 at 4:49 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Sun, Apr 11, 2021 at 01:36:18PM +0800, Yongji Xie wrote:
> > > On Sat, Apr 10, 2021 at 12:16 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Wed, Mar 31, 2021 at 04:05:12PM +0800, Xie Yongji wrote:
> > > > > Use vhost_dev->mutex to protect vhost device iotlb from
> > > > > concurrent access.
> > > > >
> > > > > Fixes: 4c8cf318("vhost: introduce vDPA-based backend")
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > > > Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> > > >
> > > > I could not figure out whether there's a bug there now.
> > > > If yes when is the concurrent access triggered?
> > > >
> > >
> > > When userspace sends the VHOST_IOTLB_MSG_V2 message concurrently?
> > >
> > > vhost_vdpa_chr_write_iter -> vhost_chr_write_iter ->
> > > vhost_vdpa_process_iotlb_msg()
> > >
> > > Thanks,
> > > Yongji
> >
> > And then what happens currently?
> >
> 
> Then we might access vhost_vdpa_map() concurrently and cause
> corruption of the list and interval tree in struct vhost_iotlb.
> 
> Thanks,
> Yongji

OK. Sounds like it's actually needed in this release if possible.  Pls
add this info in the commit log and post it as a separate patch. 

-- 
MST

