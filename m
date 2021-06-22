Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B933AFEE4
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 10:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbhFVIRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 04:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbhFVIRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 04:17:23 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CB0C06175F
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 01:15:06 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id hz1so10569817ejc.1
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 01:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YVCp8xiBvtUwUFNttbUN5nSyQGNG3BOtMHGI4CyjTHQ=;
        b=o28htubtbLEiarTQcM4helMW63ggtrRYD6odB80RYrMKlzXBuBNkg6jqk7xSk51aaf
         O28DIRNwUv88sKL7YBwXuvCLNoIBLB+qyueDzvX1XAPAF+lP7b6r00JG0ydO3mbfBvjj
         MITBvN5IFEf9VgWqwbQ5cTBOQbN005m0gdSrZ4UFZ5PhJfMcLeyIImvlDYQppBZOLOIs
         wivfY/Yy9LtygR+8wILj+pUcRikwSCVZB5LjievWPsu4MJMdYRsp3p46J9zcNoF3btSf
         hqfnJys8BLX9k98ZfHt7+Ao5s4RN54hEJpzwW0KS+1cLQ67k5xAElsfeANuN+ySwxymS
         gCeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YVCp8xiBvtUwUFNttbUN5nSyQGNG3BOtMHGI4CyjTHQ=;
        b=WgKR8kcPZk/gbgZrNROg2MuaBoJG/Z0TYLH+D9Vg1func0T74QFazEPDHzJcdbStzq
         6+XAx7D+SS4wLHU/wUOulfJEscHe8BuE3kmEw3m4ob2MX0qGQnVBDtdTwJFLxCIpyfkr
         L92LMDXxY/NtYSHxgGsbw1bjhcEaQNlMZiMa+42D35AtSrBaFfBR0xpNMeLM2P6bKmNn
         Bqp9geJE4D9qmhrwvbX7STEPViJ0F7GLNsM8wwQTSdAZn79JWdpfS3UcmBH0Moy9ibXX
         WaBlT8566Li2p75xAHTaAn/9o9/oSYBd8mddEm9IZ5rJS9PkUY62mj+EGb9zeF+icJWN
         40bw==
X-Gm-Message-State: AOAM533dG9HTSRWJAlMwG98Qnv+RhlqnEUswNgOh71PVNBlZQSewJEf+
        m5gbWn7SuyrnSWicugj6TOmeMEs5DSCNe3u/Jh+Y
X-Google-Smtp-Source: ABdhPJypM7pjKQ3KkOxcIFLDNBXVrECsVU1ZZT8FKvu2e7Av799B1KikoicL0OhYmYSH0T8F/YyLCEgy2EG+tm9UOts=
X-Received: by 2002:a17:907:1b11:: with SMTP id mp17mr2736493ejc.1.1624349704564;
 Tue, 22 Jun 2021 01:15:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210615141331.407-1-xieyongji@bytedance.com> <20210615141331.407-10-xieyongji@bytedance.com>
 <adfb2be9-9ed9-ca37-ac37-4cd00bdff349@redhat.com> <CACycT3tAON+-qZev+9EqyL2XbgH5HDspOqNt3ohQLQ8GqVK=EA@mail.gmail.com>
 <1bba439f-ffc8-c20e-e8a4-ac73e890c592@redhat.com> <CACycT3uzMJS7vw6MVMOgY4rb=SPfT2srV+8DPdwUVeELEiJgbA@mail.gmail.com>
 <0aeb7cb7-58e5-1a95-d830-68edd7e8ec2e@redhat.com>
In-Reply-To: <0aeb7cb7-58e5-1a95-d830-68edd7e8ec2e@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 22 Jun 2021 16:14:53 +0800
Message-ID: <CACycT3uuooKLNnpPHewGZ=q46Fap2P4XCFirdxxn=FxK+X1ECg@mail.gmail.com>
Subject: Re: Re: [PATCH v8 09/10] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 22, 2021 at 3:50 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/6/22 =E4=B8=8B=E5=8D=883:22, Yongji Xie =E5=86=99=E9=81=93=
:
> >> We need fix a way to propagate the error to the userspace.
> >>
> >> E.g if we want to stop the deivce, we will delay the status reset unti=
l
> >> we get respose from the userspace?
> >>
> > I didn't get how to delay the status reset. And should it be a DoS
> > that we want to fix if the userspace doesn't give a response forever?
>
>
> You're right. So let's make set_status() can fail first, then propagate
> its failure via VHOST_VDPA_SET_STATUS.
>

OK. So we only need to propagate the failure in the vhost-vdpa case, right?

Thanks,
Yongji
