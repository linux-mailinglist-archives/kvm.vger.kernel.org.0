Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D3240673B
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 08:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhIJGeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 02:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbhIJGeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 02:34:02 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD360C061574;
        Thu,  9 Sep 2021 23:32:51 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id t190so925730qke.7;
        Thu, 09 Sep 2021 23:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wsf5hPUH3MYL5lrAiO50lKX+4L4mH3UTRgfpXirFAAc=;
        b=MqCiBW484db2PJ93autlPemRbVAD+dtdje6igzgdnXOevdZ8+oS7fRLZzImz5JgvHR
         WD7R9YxkJoiLVnXiSBRmBPSPqOISMirRnS9bohHAKYAC+Y0vOcJ8I7Ci0QIMU60chC4f
         Vpm2kTh3nhiStHP3XzBBTP87H4Yk6Tdwo28RGpX2/EIm+mPuRSQZ9B6Rhk2fwoSBuuX8
         9MaIyUDddS1m5RumUkcU9yyGBSNQbe+b2UR+t7Yl8h2EgcZeRtppHDKsdlO2yov9EU5d
         lDa6gFwMIv7hnxsMlX4OP4Zw4cKqUSdVuSpUfWzgFQq9PP/AQIfOGSVoryGeAKmcDveY
         /Teg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wsf5hPUH3MYL5lrAiO50lKX+4L4mH3UTRgfpXirFAAc=;
        b=Q06812RBkEmESMRnIULtmG0n4DuKhNYyQqMgE61ByUyBIaKFQF77V5kwbpMbe0MNTA
         vHUMarXaD54W71BaDZDBfjWX6rgBUvrmDt4UcKIMRKl93g/+Kd/zwCmci9CEt6UPUaWw
         oWfYh8BbnQYpAP64oHV0itvcdLzzzsQeHVvOmdxlCSWDncRVSB22UqL4SicrTpMJcqOw
         xcZ9CIS1MsJ9YhmrBt+7lKrbYJ3J9mwzdrP8wO13XCET9JwbtxZq+3raL3da4FarTNMX
         8sQ+GnQvsbHOfnhZOSnLBMS+EtLXY73/1J0JGRKBxiDeIRpfy+URSvPyl5Ct+CEQazD9
         nUNw==
X-Gm-Message-State: AOAM530b5hQU7mZI1DKz2EazWomltXupJPKsrBz31stn+4FvfaOyuBxy
        h1KeMt8CubOpC0b/OEgQwucbQHOwmIGXOOxt0aY=
X-Google-Smtp-Source: ABdhPJxqdfwJQrz4egs3WTw1rREh6nLLPa50d7pE/eI+qOfEwebXuNf0LVXhG896eTPiHPbk9X1g/3EqxxDE7UZ795c=
X-Received: by 2002:a05:620a:4042:: with SMTP id i2mr6511644qko.336.1631255570807;
 Thu, 09 Sep 2021 23:32:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210901131434.31158-1-mgurtovoy@nvidia.com> <YTYvOetMHvocg9UZ@stefanha-x1.localdomain>
In-Reply-To: <YTYvOetMHvocg9UZ@stefanha-x1.localdomain>
From:   Feng Li <lifeng1519@gmail.com>
Date:   Fri, 10 Sep 2021 14:32:24 +0800
Message-ID: <CAEK8JBAz8Y6b1a2v+_EhXowdSEQgpv0CxmYX1kMP+wN8W1qOdA@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] virtio-blk: avoid preallocating big SGL for data
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, hch@infradead.org,
        mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, israelr@nvidia.com, nitzanc@nvidia.com,
        oren@nvidia.com, linux-block <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 6, 2021 at 11:39 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Wed, Sep 01, 2021 at 04:14:34PM +0300, Max Gurtovoy wrote:
> > No need to pre-allocate a big buffer for the IO SGL anymore. If a device
> > has lots of deep queues, preallocation for the sg list can consume
> > substantial amounts of memory. For HW virtio-blk device, nr_hw_queues
> > can be 64 or 128 and each queue's depth might be 128. This means the
> > resulting preallocation for the data SGLs is big.
> >
> > Switch to runtime allocation for SGL for lists longer than 2 entries.
> > This is the approach used by NVMe drivers so it should be reasonable for
> > virtio block as well. Runtime SGL allocation has always been the case
> > for the legacy I/O path so this is nothing new.
> >
> > The preallocated small SGL depends on SG_CHAIN so if the ARCH doesn't
> > support SG_CHAIN, use only runtime allocation for the SGL.
> >
> > Re-organize the setup of the IO request to fit the new sg chain
> > mechanism.
> >
> > No performance degradation was seen (fio libaio engine with 16 jobs and
> > 128 iodepth):
> >
> > IO size      IOPs Rand Read (before/after)         IOPs Rand Write (before/after)
> > --------     ---------------------------------    ----------------------------------
> > 512B          318K/316K                                    329K/325K
> >
> > 4KB           323K/321K                                    353K/349K
> >
> > 16KB          199K/208K                                    250K/275K
> >
> > 128KB         36K/36.1K                                    39.2K/41.7K
>
> I ran fio randread benchmarks with 4k, 16k, 64k, and 128k at iodepth 1,
> 8, and 64 on two vCPUs. The results look fine, there is no significant
> regression.
>
> iodepth=1 and iodepth=64 are very consistent. For some reason the
> iodepth=8 has significant variance but I don't think it's the fault of
> this patch.
>
> Fio results and the Jupyter notebook export are available here (check
> out benchmark.html to see the graphs):
>
> https://gitlab.com/stefanha/virt-playbooks/-/tree/virtio-blk-sgl-allocation-benchmark/notebook
>
> Guest:
> - Fedora 34
> - Linux v5.14
> - 2 vCPUs (pinned), 4 GB RAM (single host NUMA node)
> - 1 IOThread (pinned)
> - virtio-blk aio=native,cache=none,format=raw
> - QEMU 6.1.0
>
> Host:
> - RHEL 8.3
> - Linux 4.18.0-240.22.1.el8_3.x86_64
> - Intel(R) Xeon(R) Silver 4214 CPU @ 2.20GHz
> - Intel Optane DC P4800X
>
> Stefan

Reviewed-by: Feng Li <lifeng1519@gmail.com>
