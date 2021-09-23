Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4836541622D
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 17:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242042AbhIWPjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 11:39:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60025 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241991AbhIWPjX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 11:39:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632411471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AOSJdORroeY+L8lMWoT/k2QmeHNRD0UxneSQj0X18oA=;
        b=SGKrJ72+QbZsCz2Wc4n0VFxztRC18W23zMWtMguGb39HpIuvz5HGcKUdCV3S8HhStgEZYg
        41it/F7g6noEjsPXtm6KfN0lK8nBfW3EuIdEc5BOVI59svTQRH4x2BpSxUiItGW5ltxRvU
        blViAp4dnPtzuECSNu3yBzeIv4pIxzc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-kTTtNwjbMK-yIXpaPnJi_g-1; Thu, 23 Sep 2021 11:37:49 -0400
X-MC-Unique: kTTtNwjbMK-yIXpaPnJi_g-1
Received: by mail-ed1-f70.google.com with SMTP id m30-20020a50999e000000b003cdd7680c8cso7199183edb.11
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 08:37:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AOSJdORroeY+L8lMWoT/k2QmeHNRD0UxneSQj0X18oA=;
        b=ga8jqnVohH1UGgYn4Lz2ECW97HPyC6KjTHOrMvAEP/vCGppVmACEyLIcsQyk543hgC
         +jNdhtE7s452UAjaABBeGhdrGOV4ZyKC0IaxweelgALDapgXcygnkZ8vm+odMfSqxlk9
         AkNIkhtRmmdHRNlvuxGaggw+1I/vnG3Qoqq1lmAFdxlor8FRVE2HHReZ7SylHVIdJe1T
         r3Yof1kLGVCPTNmiPIayQ59ASrjO8TQTTwaHl81c/HyvoZ96UrwIevNgqf5d1X4PnNuS
         XOCuTlk8LMvMWiQKL2fSXIKpt1OwUtWhX2K88r7NiIm1CRSvU5s8UcsnQAMCZzHnMuzw
         PcnA==
X-Gm-Message-State: AOAM533Gmh7PUb+jy3+Vjc2i4P1QJCf+uyYSsceMhynTmv/DyGKOAy5I
        cxVTuo5J4hFi/2zy/+LOnV8n/3N5EB0pFUUPU9wIvW0oAOv4GeSbow0VyeVeufwaGW9Nrna6RDv
        RUSTzdJwzbzr5
X-Received: by 2002:a50:d84c:: with SMTP id v12mr6078255edj.201.1632411468263;
        Thu, 23 Sep 2021 08:37:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8DaBe4I+LkOVyQLu6cfQoWkqvgiBaOR5+1qn3bcBVQnRix8ZU/+hekqhUIynodgC4qCiRWw==
X-Received: by 2002:a50:d84c:: with SMTP id v12mr6078219edj.201.1632411468054;
        Thu, 23 Sep 2021 08:37:48 -0700 (PDT)
Received: from redhat.com ([2.55.11.56])
        by smtp.gmail.com with ESMTPSA id d3sm3738711edv.87.2021.09.23.08.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 08:37:47 -0700 (PDT)
Date:   Thu, 23 Sep 2021 11:37:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, hch@infradead.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        israelr@nvidia.com, nitzanc@nvidia.com, oren@nvidia.com,
        linux-block@vger.kernel.org
Subject: Re: [PATCH v3 1/1] virtio-blk: avoid preallocating big SGL for data
Message-ID: <20210923113644-mutt-send-email-mst@kernel.org>
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

OK by me.
Acked-by: Michael S. Tsirkin <mst@redhat.com>

I will queue it for the next kernel.
Thanks!


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

