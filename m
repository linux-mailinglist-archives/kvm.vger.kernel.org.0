Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FBF437492
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 11:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbhJVJSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 05:18:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44159 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232570AbhJVJSN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 05:18:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634894155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G3cW3zoVlu4oi/52XaFtkNhCU8dR251sfiAlQbdZmxw=;
        b=VsBSEFrI65sryTfKimMmOuEcd8aQUYsvm93TygY6/ED2R/fJgiFd1kp48ysZFqyA9d4r3h
        8FqIsd3/nGVK3KOUEDbUfKyEt2ObTJQcpTE+v/TCZWtIutcx3P+DDYFYXSBuxEpnWNhhje
        Qmn1MvCqxFHQC33h7ylcvmWBK5ekeWo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-zU-Re_52Nj-GJGTLC80Wcg-1; Fri, 22 Oct 2021 05:15:53 -0400
X-MC-Unique: zU-Re_52Nj-GJGTLC80Wcg-1
Received: by mail-wm1-f69.google.com with SMTP id k20-20020a7bc414000000b0030dcd454771so754919wmi.8
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 02:15:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G3cW3zoVlu4oi/52XaFtkNhCU8dR251sfiAlQbdZmxw=;
        b=qJpoEWrRFRAZIP5YlA15JmRs1XZ7CCjZEUA2PVadJgo+/TV0rFh/66wapRp6GbWVBx
         8dQcRNlRrLEwdXOBts0ICuWHzwZqhVjD8N8qqdaS/gEmXU/7EyVt1W6xdyo6V4RxD18G
         W+Qa8QzS+UbmaxeqsiUZ+cZa6vh5FJWG69Msj+JZSFxJx26aayNNyca4KYBfy9hWQjjG
         svSQEBv54TZValdHjTanlF5/EZKW1OtKelB9iWDp38OK4SBQX/ZTsqOJDuXoLoDyQiI/
         czn0WsmAaXzM34J6BRMHGPIRp6M5EAocY2uouwlsD7qiuglDkZkXyjoRBrmUI2AFVEtz
         zp2w==
X-Gm-Message-State: AOAM532YjUU1M1fGrZ6/tfT6DHb0YdUvHttazXvFvkJ/xXyLFN0g50za
        wERkX64u1zXMWzuTg1aKm9nsNfCGejJ2GCXqy93fP6ZPH4JV8jNA12aAq5wpj0qgP5nx5jqD3tG
        Wpx/HZhFIopnb
X-Received: by 2002:adf:c986:: with SMTP id f6mr14715335wrh.216.1634894152797;
        Fri, 22 Oct 2021 02:15:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9UzrJ47jd8AVMlb0zsnyhbeLN4MbCsLDsxpH5rzw33A79i6LywRRy6NMmtWFyEM7afYZFuw==
X-Received: by 2002:adf:c986:: with SMTP id f6mr14715317wrh.216.1634894152607;
        Fri, 22 Oct 2021 02:15:52 -0700 (PDT)
Received: from redhat.com ([2.55.24.172])
        by smtp.gmail.com with ESMTPSA id q18sm10324419wmc.7.2021.10.22.02.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 02:15:51 -0700 (PDT)
Date:   Fri, 22 Oct 2021 05:15:47 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, hch@infradead.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        israelr@nvidia.com, nitzanc@nvidia.com, oren@nvidia.com,
        linux-block@vger.kernel.org
Subject: Re: [PATCH v3 1/1] virtio-blk: avoid preallocating big SGL for data
Message-ID: <20211022051343-mutt-send-email-mst@kernel.org>
References: <20210901131434.31158-1-mgurtovoy@nvidia.com>
 <YTYvOetMHvocg9UZ@stefanha-x1.localdomain>
 <692f8e81-8585-1d39-e7a4-576ae01438a1@nvidia.com>
 <YUCUF7co94CRGkGU@stefanha-x1.localdomain>
 <56cf84e2-fec0-08e8-0a47-24bb1df71883@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56cf84e2-fec0-08e8-0a47-24bb1df71883@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

My tree is ok.
Looks like your patch was developed on top of some other tree,
not plan upstream linux, so git am fails. I applied it using
patch and some manual tweaking, and it seems to work for
me but please do test it in linux-next and confirm -
will push to a linux-next branch in my tree soon.

On Thu, Sep 23, 2021 at 04:40:56PM +0300, Max Gurtovoy wrote:
> Hi MST/Jens,
> 
> Do we need more review here or are we ok with the code and the test matrix ?
> 
> If we're ok, we need to decide if this goes through virtio PR or block PR.
> 
> Cheers,
> 
> -Max.
> 
> On 9/14/2021 3:22 PM, Stefan Hajnoczi wrote:
> > On Mon, Sep 13, 2021 at 05:50:21PM +0300, Max Gurtovoy wrote:
> > > On 9/6/2021 6:09 PM, Stefan Hajnoczi wrote:
> > > > On Wed, Sep 01, 2021 at 04:14:34PM +0300, Max Gurtovoy wrote:
> > > > > No need to pre-allocate a big buffer for the IO SGL anymore. If a device
> > > > > has lots of deep queues, preallocation for the sg list can consume
> > > > > substantial amounts of memory. For HW virtio-blk device, nr_hw_queues
> > > > > can be 64 or 128 and each queue's depth might be 128. This means the
> > > > > resulting preallocation for the data SGLs is big.
> > > > > 
> > > > > Switch to runtime allocation for SGL for lists longer than 2 entries.
> > > > > This is the approach used by NVMe drivers so it should be reasonable for
> > > > > virtio block as well. Runtime SGL allocation has always been the case
> > > > > for the legacy I/O path so this is nothing new.
> > > > > 
> > > > > The preallocated small SGL depends on SG_CHAIN so if the ARCH doesn't
> > > > > support SG_CHAIN, use only runtime allocation for the SGL.
> > > > > 
> > > > > Re-organize the setup of the IO request to fit the new sg chain
> > > > > mechanism.
> > > > > 
> > > > > No performance degradation was seen (fio libaio engine with 16 jobs and
> > > > > 128 iodepth):
> > > > > 
> > > > > IO size      IOPs Rand Read (before/after)         IOPs Rand Write (before/after)
> > > > > --------     ---------------------------------    ----------------------------------
> > > > > 512B          318K/316K                                    329K/325K
> > > > > 
> > > > > 4KB           323K/321K                                    353K/349K
> > > > > 
> > > > > 16KB          199K/208K                                    250K/275K
> > > > > 
> > > > > 128KB         36K/36.1K                                    39.2K/41.7K
> > > > I ran fio randread benchmarks with 4k, 16k, 64k, and 128k at iodepth 1,
> > > > 8, and 64 on two vCPUs. The results look fine, there is no significant
> > > > regression.
> > > > 
> > > > iodepth=1 and iodepth=64 are very consistent. For some reason the
> > > > iodepth=8 has significant variance but I don't think it's the fault of
> > > > this patch.
> > > > 
> > > > Fio results and the Jupyter notebook export are available here (check
> > > > out benchmark.html to see the graphs):
> > > > 
> > > > https://gitlab.com/stefanha/virt-playbooks/-/tree/virtio-blk-sgl-allocation-benchmark/notebook
> > > > 
> > > > Guest:
> > > > - Fedora 34
> > > > - Linux v5.14
> > > > - 2 vCPUs (pinned), 4 GB RAM (single host NUMA node)
> > > > - 1 IOThread (pinned)
> > > > - virtio-blk aio=native,cache=none,format=raw
> > > > - QEMU 6.1.0
> > > > 
> > > > Host:
> > > > - RHEL 8.3
> > > > - Linux 4.18.0-240.22.1.el8_3.x86_64
> > > > - Intel(R) Xeon(R) Silver 4214 CPU @ 2.20GHz
> > > > - Intel Optane DC P4800X
> > > > 
> > > > Stefan
> > > Thanks, Stefan.
> > > 
> > > Would you like me to add some of the results in my commit msg ? or Tested-By
> > > sign ?
> > Thanks, there's no need to change the commit description.
> > 
> > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > Tested-by: Stefan Hajnoczi <stefanha@redhat.com>

