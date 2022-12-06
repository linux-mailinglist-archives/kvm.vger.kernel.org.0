Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678386444CC
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 14:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiLFNoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 08:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLFNoN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 08:44:13 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A1B29822
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 05:44:11 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id q71so13388405pgq.8
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 05:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4qbkKWhWPanWRYEN6xzgaOcSVOJAns1k+cY++VtfwfI=;
        b=pMTEtuDRlb/LRGsjD9um2ZuhbgiEurbfTulD3JNY4dinWi9LzpixZtViJOlgsP5ukD
         QwZ7ovixznLKNSzMQRS6Vub7GRjRPRign7Qtc3IJa2NYlkptLhko0T28GgSzBD484JJ6
         CRx7ys70PFEALQUZ2MS6I1Nw8MHu0CbeBXoztNU2LHuQnIqLXSWFhzxlxONjWbSjnwwK
         lKAb8L5p2SIHMrFMgBoa2S5bQxyaLRF8qoN7JmSX5Ngnqh5hK9zyDwecixglL3xTef3r
         ZbDAGhH9tnvfkEswYSHUZl5s9FMTFx/elBmvPvSU1zmIDxOgKLXdJO+28vile3hAAG1Q
         oAIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4qbkKWhWPanWRYEN6xzgaOcSVOJAns1k+cY++VtfwfI=;
        b=Wi/Lrr8LKFfxltNosuQDsdTMCUCQQQpCzowps32gd8kLCXIoq5fYC83N/U6yRET1WF
         Jr9NaEa9/gFgqzR6dT0l+ENx3XATggwTIMirKL6fbu/sH6cV/8Y6UDuuIgwKAYGLbnIB
         p10licqdUA3GrPNMFP765P6yEQssvFued7khOCqj8SwH6PSthA5hjvE5Wvnb0nVQgUZc
         /CqA6KigmM+lS3pliDy2OecRmeYycztfKq9vlZSvZ2LpoqcRlxbzq0hCjCCB4o+vmax0
         51PwFdCITrMXhjHAZEAQ4PZveGm0VWzUsh11mIHseytxc3/V4p7e5wPKEsoFPUwmOQV+
         DzRA==
X-Gm-Message-State: ANoB5pk6n8Nvox6RdDYYo28YzJu1LFtVvnYbw23M0H6cGgWH/m3PHuPV
        3kMZoP6TG1Smcs9avg32Qlsz7g==
X-Google-Smtp-Source: AA0mqf7qnh+I/sFr2gLN57AjRk8weKbLt5zxdv5BY0erfYcMVzmg1gMkminrCllLyLKwgqjK2bBlGA==
X-Received: by 2002:a63:dd16:0:b0:476:d2d9:5151 with SMTP id t22-20020a63dd16000000b00476d2d95151mr58290007pgg.487.1670334250591;
        Tue, 06 Dec 2022 05:44:10 -0800 (PST)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id p10-20020a170902e74a00b00186acb14c4asm12688493plf.67.2022.12.06.05.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 05:44:10 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1p2YEy-004bTc-NA;
        Tue, 06 Dec 2022 09:44:08 -0400
Date:   Tue, 6 Dec 2022 09:44:08 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Lei Rao <lei.rao@intel.com>, kbusch@kernel.org, axboe@fb.com,
        kch@nvidia.com, sagi@grimberg.me, alex.williamson@redhat.com,
        cohuck@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        mjrosato@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, kvm@vger.kernel.org,
        eddie.dong@intel.com, yadong.li@intel.com, yi.l.liu@intel.com,
        Konrad.wilk@oracle.com, stephen@eideticom.com, hang.yuan@intel.com
Subject: Re: [RFC PATCH 1/5] nvme-pci: add function nvme_submit_vf_cmd to
 issue admin commands for VF driver.
Message-ID: <Y49HKHP9NrId39iH@ziepe.ca>
References: <20221206055816.292304-1-lei.rao@intel.com>
 <20221206055816.292304-2-lei.rao@intel.com>
 <20221206061940.GA6595@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206061940.GA6595@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 07:19:40AM +0100, Christoph Hellwig wrote:
> On Tue, Dec 06, 2022 at 01:58:12PM +0800, Lei Rao wrote:
> > The new function nvme_submit_vf_cmd() helps the host VF driver to issue
> > VF admin commands. It's helpful in some cases that the host NVMe driver
> > does not control VF's admin queue. For example, in the virtualization
> > device pass-through case, the VF controller's admin queue is governed
> > by the Guest NVMe driver. Host VF driver relies on PF device's admin
> > queue to control VF devices like vendor-specific live migration commands.
> 
> WTF are you even smoking when you think this would be acceptable?

Not speaking to NVMe - but this driver is clearly copying mlx5's live
migration driver, almost completely - including this basic function.

So, to explain why mlx5 works this way..

The VFIO approach is to fully assign an entire VF to the guest OS. The
entire VF assignment means every MMIO register *and all the DMA* of
the VF is owned by the guest operating system.

mlx5 needs to transfer hundreds of megabytes to gigabytes of in-device
state to perform a migration.

So, we must be able to use DMA to transfer the data. However, the VM
exclusively controls the DMA of the VF. The iommu_domain of the VF
belongs to the guest VM through VFIO, and we simply cannot mutate
it. Not only should not, but physically can not, ie when IOMMU nested
translation is in use and the IO page tables are in guest VM memory.

So the VF cannot be used to control the migration, or transfer the
migration data. This leaves only the PF.

Thus, mxl5 has the same sort of design where the VF VFIO driver
reaches into the PF kernel driver and asks the PF driver to perform
some commands targeting the PF's own VFs. The DMA is then done using
the RID of the PF, and reaches the kernel owned iommu_domain of the
PF. This way the entire operation is secure aginst meddling by the
guest.

We can contrast this with the hisilicon live migration driver that
does not use the PF for control. Instead it has a very small state
that the migration driver simply reads out of registers. The VF has a
page of registers that control pause/go of the queues and the VFIO
varient driver denies access to this page from the guest VM so that
the kernel VFIO driver has reliable control over the VF.

Without involving PASID this is broadly the only two choices for doing
SRIOV live migration, AFAIK.

Jason
