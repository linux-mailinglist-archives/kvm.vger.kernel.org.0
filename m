Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8CB38044A
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 09:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbhENHcf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 03:32:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22890 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230462AbhENHca (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 May 2021 03:32:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620977478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qEwXortYNaxldB+sCYne8sqnUUpZSsLp70/SckpgE3s=;
        b=ZovNeuN2+SW2CTNZBpGQW07JXcA20pL8MPr7wUog1SJEctJGpYZmFP/IgOoWj33swUqlAe
        uICChviAlUV6BD+30qa6bz5/41VUI8VnsRFlbKxPN6qyIBJTPQgwDIv9X+vcJ2burR9TqD
        scroES6C8rqirWJJ5MiGCopadTFF+Gk=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-W2Y9sSZ5OEuNTkHitxp0ZQ-1; Fri, 14 May 2021 03:31:17 -0400
X-MC-Unique: W2Y9sSZ5OEuNTkHitxp0ZQ-1
Received: by mail-lj1-f199.google.com with SMTP id v26-20020a2e481a0000b02900bf48f13296so15632567lja.1
        for <kvm@vger.kernel.org>; Fri, 14 May 2021 00:31:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qEwXortYNaxldB+sCYne8sqnUUpZSsLp70/SckpgE3s=;
        b=qHrF+T3lITx5ZHLRjIsB7q9AdCm1rp5npjVMdr6ticESwKOSd/4pDPmsoUktZmmpnK
         rQt52Ck+PP7nCTW5zSpEq1P4KcvtIUWAhnZl9DpK/IEqouI4+xZ6fEDOEzoHcO/pcNF8
         aVYhZPTHd/f+BSdoBg52T1NwPNVFs0kNbHbYLtoCuFeASyUN4Y7NMuvQt4eAPns5CoZu
         PohTvjkVwQLuYp2pM/s239+RzpCGMT+0+TKIbAV04JvuCan7fEJqEvZLjZeYW9FMjTm9
         E9tM3B6AVnfwGkTU3VzBz2VNvCufRsUoaTurhd1J2sbSCqBWfGufL3VT6/w7uC7BM/Y+
         yWRg==
X-Gm-Message-State: AOAM5337xFshQNeLVdQv2r+XEamCrRMO2HUlxT1auIaTYAzZHjjrymbk
        CIQo7R7BMbsh50ImlDaBY37zLDsWvu43J0QAUSIZIxwA9dQ47yvFGHS8S3NOQ6CfSmSAxOAjJOM
        DSU2OGdvCO4aRJf7/3K1N3SgSV2AG
X-Received: by 2002:a2e:501a:: with SMTP id e26mr35677838ljb.260.1620977474854;
        Fri, 14 May 2021 00:31:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxG8avBVDLQcb88RwIjGEcI7lLXFcOmFPlv7+LK8Qxs01/mzkmQtnLTZTqGoCS/1yMev77rExPJWWaCKvsQL7A=
X-Received: by 2002:a2e:9c91:: with SMTP id x17mr24353676lji.385.1620977463809;
 Fri, 14 May 2021 00:31:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210423080942.2997-1-jasowang@redhat.com> <YJ1TgoFSwOkQrC+1@stefanha-x1.localdomain>
 <CACycT3v-2naEaXEtPqaKcGz8qpfnmp4VzrHefqLNhO=9=57jdQ@mail.gmail.com>
In-Reply-To: <CACycT3v-2naEaXEtPqaKcGz8qpfnmp4VzrHefqLNhO=9=57jdQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 14 May 2021 15:30:52 +0800
Message-ID: <CACGkMEvKByPZFwN8bU6_SfRbS9i43am7X5WGJQtE=Yh+YKWOHw@mail.gmail.com>
Subject: Re: Re: [RFC PATCH V2 0/7] Do not read from descripto ring
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm <kvm@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 14, 2021 at 2:07 PM Yongji Xie <xieyongji@bytedance.com> wrote:
>
> On Fri, May 14, 2021 at 12:27 AM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> >
> > On Fri, Apr 23, 2021 at 04:09:35PM +0800, Jason Wang wrote:
> > > Sometimes, the driver doesn't trust the device. This is usually
> > > happens for the encrtpyed VM or VDUSE[1].
> >
> > Thanks for doing this.
> >
> > Can you describe the overall memory safety model that virtio drivers
> > must follow? For example:
> >
> > - Driver-to-device buffers must be on dedicated pages to avoid
> >   information leaks.
> >
> > - Driver-to-device buffers must be on dedicated pages to avoid memory
> >   corruption.
> >
> > When I say "pages" I guess it's the IOMMU page size that matters?
> >
> > What is the memory access granularity of VDUSE?
> >
>
> Now we use PAGE_SIZE as the access granularity. I think it should be
> safe to access the Driver-to-device buffers in VDUSE case because we
> also use bounce-buffering mechanism like swiotlb does.
>
> Thanks,
> Yongji
>

Yes, while at this, I wonder it's possible the re-use the swiotlb
codes for VDUSE, or having some common library for this. Otherwise
there would be duplicated codes (bugs).

Thanks

