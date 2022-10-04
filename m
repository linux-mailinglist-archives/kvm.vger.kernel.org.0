Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C6A5F4A37
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 22:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiJDUUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 16:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiJDUUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 16:20:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DEEFD14
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 13:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664914802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HrLswqjV07u6TAjC9uPJ3GVmJASl9vYq42jLKzbHRcs=;
        b=Kx8if09anebHaK4hgtqxQrKiqy0NHD+Om55h4PqT04d05ApnhJwoe1UIp5RQCOXw0lqaeq
        HD9nEtrAN5+OyQjY2N2WzQ9WDHzP6fUAucSysPKM+I/1Ue2AHrBiZ7JrHww5bOtTmDpa+4
        nA3mlTJp5e47GCLaTWbgjEonHte3hmY=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-240-hjqAvDNuPTuHxAO74Xqg_g-1; Tue, 04 Oct 2022 16:20:00 -0400
X-MC-Unique: hjqAvDNuPTuHxAO74Xqg_g-1
Received: by mail-il1-f199.google.com with SMTP id k3-20020a056e02156300b002f5623faa62so11747882ilu.0
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 13:20:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=HrLswqjV07u6TAjC9uPJ3GVmJASl9vYq42jLKzbHRcs=;
        b=gp83Wq5S3wwfzV813Z6b7zcHW6NMK7dMVF1lBUNzytGSWzYUCKybjlGaZEE3U+L3c4
         uCZuG/wvgpbJyA22Qdqpm5kJqIZWSr2sWZ4d0V27ddUq6LdGI6lGmKPhBeVCXneoRyN/
         5ART3pteJRfMG8nN6UbNDBrUTGenVzk4q6vkUuGy0jI4OHHaN5GdZDKENxZ3K0nv0oDU
         sawETTLhKJRCj94Nnn17Qj2nJX6pvA4ihCw7N76Sz4pzs7gvGP1/Dv5ZU0O+j/cDCLGB
         +LXZ81NyjyfVNvQjnlqO8oZSS7xAYjW1oBVxqDGw+XT3Jq+q8eXcerNxiRm1C/bTkOrj
         xyQQ==
X-Gm-Message-State: ACrzQf0/neS7wfhtbMxQpUN+qqX/Lc4tLoDn2ZvEPQzOg05KX+2QnQBA
        AWh4ACl8ssse5u8O3RPRdi0qczp7aO3CFqCXcQLmnYFZyKhoGdL23h5qLFCOJcmIdxp64SrINXN
        pB9D+aIjOm81a
X-Received: by 2002:a05:6e02:1ba3:b0:2fa:3547:477a with SMTP id n3-20020a056e021ba300b002fa3547477amr1845496ili.34.1664914799774;
        Tue, 04 Oct 2022 13:19:59 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6UyOI3iQL/Yldld2tmNURvJDWFpGbWdaP1J1mElR11eIUGZnr+JNCoyGtlwxuQJy+PDdMgng==
X-Received: by 2002:a05:6e02:1ba3:b0:2fa:3547:477a with SMTP id n3-20020a056e021ba300b002fa3547477amr1845481ili.34.1664914799441;
        Tue, 04 Oct 2022 13:19:59 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id y2-20020a029502000000b00363330785d6sm2726054jah.91.2022.10.04.13.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 13:19:58 -0700 (PDT)
Date:   Tue, 4 Oct 2022 14:19:57 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] vfio: Follow a strict lifetime for struct
 iommu_group
Message-ID: <20221004141957.5b990195.alex.williamson@redhat.com>
In-Reply-To: <051b7348-92d3-3528-3d29-4c9da1153d4e@linux.ibm.com>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
        <4cb6e49e-554e-57b3-e2d3-bc911d99083f@linux.ibm.com>
        <051b7348-92d3-3528-3d29-4c9da1153d4e@linux.ibm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 Oct 2022 15:59:12 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 9/26/22 1:03 PM, Matthew Rosato wrote:
> > On 9/22/22 8:06 PM, Jason Gunthorpe wrote:  
> >> The iommu_group comes from the struct device that a driver has been bound
> >> to and then created a struct vfio_device against. To keep the iommu layer
> >> sane we want to have a simple rule that only an attached driver should be
> >> using the iommu API. Particularly only an attached driver should hold
> >> ownership.
> >>
> >> In VFIO's case since it uses the group APIs and it shares between
> >> different drivers it is a bit more complicated, but the principle still
> >> holds.
> >>
> >> Solve this by waiting for all users of the vfio_group to stop before
> >> allowing vfio_unregister_group_dev() to complete. This is done with a new
> >> completion to know when the users go away and an additional refcount to
> >> keep track of how many device drivers are sharing the vfio group. The last
> >> driver to be unregistered will clean up the group.
> >>
> >> This solves crashes in the S390 iommu driver that come because VFIO ends
> >> up racing releasing ownership (which attaches the default iommu_domain to
> >> the device) with the removal of that same device from the iommu
> >> driver. This is a side case that iommu drivers should not have to cope
> >> with.
> >>
> >>    iommu driver failed to attach the default/blocking domain
> >>    WARNING: CPU: 0 PID: 5082 at drivers/iommu/iommu.c:1961 iommu_detach_group+0x6c/0x80
> >>    Modules linked in: macvtap macvlan tap vfio_pci vfio_pci_core irqbypass vfio_virqfd kvm nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink mlx5_ib sunrpc ib_uverbs ism smc uvdevice ib_core s390_trng eadm_sch tape_3590 tape tape_class vfio_ccw mdev vfio_iommu_type1 vfio zcrypt_cex4 sch_fq_codel configfs ghash_s390 prng chacha_s390 libchacha aes_s390 mlx5_core des_s390 libdes sha3_512_s390 nvme sha3_256_s390 sha512_s390 sha256_s390 sha1_s390 sha_common nvme_core zfcp scsi_transport_fc pkey zcrypt rng_core autofs4
> >>    CPU: 0 PID: 5082 Comm: qemu-system-s39 Tainted: G        W          6.0.0-rc3 #5
> >>    Hardware name: IBM 3931 A01 782 (LPAR)
> >>    Krnl PSW : 0704c00180000000 000000095bb10d28 (iommu_detach_group+0x70/0x80)
> >>               R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
> >>    Krnl GPRS: 0000000000000001 0000000900000027 0000000000000039 000000095c97ffe0
> >>               00000000fffeffff 00000009fc290000 00000000af1fda50 00000000af590b58
> >>               00000000af1fdaf0 0000000135c7a320 0000000135e52258 0000000135e52200
> >>               00000000a29e8000 00000000af590b40 000000095bb10d24 0000038004b13c98
> >>    Krnl Code: 000000095bb10d18: c020003d56fc        larl    %r2,000000095c2bbb10
> >>                           000000095bb10d1e: c0e50019d901        brasl   %r14,000000095be4bf20
> >>                          #000000095bb10d24: af000000            mc      0,0  
> >>                          >000000095bb10d28: b904002a            lgr     %r2,%r10  
> >>                           000000095bb10d2c: ebaff0a00004        lmg     %r10,%r15,160(%r15)
> >>                           000000095bb10d32: c0f4001aa867        brcl    15,000000095be65e00
> >>                           000000095bb10d38: c004002168e0        brcl    0,000000095bf3def8
> >>                           000000095bb10d3e: eb6ff0480024        stmg    %r6,%r15,72(%r15)
> >>    Call Trace:
> >>     [<000000095bb10d28>] iommu_detach_group+0x70/0x80
> >>    ([<000000095bb10d24>] iommu_detach_group+0x6c/0x80)
> >>     [<000003ff80243b0e>] vfio_iommu_type1_detach_group+0x136/0x6c8 [vfio_iommu_type1]
> >>     [<000003ff80137780>] __vfio_group_unset_container+0x58/0x158 [vfio]
> >>     [<000003ff80138a16>] vfio_group_fops_unl_ioctl+0x1b6/0x210 [vfio]
> >>    pci 0004:00:00.0: Removing from iommu group 4
> >>     [<000000095b5b62e8>] __s390x_sys_ioctl+0xc0/0x100
> >>     [<000000095be5d3b4>] __do_syscall+0x1d4/0x200
> >>     [<000000095be6c072>] system_call+0x82/0xb0
> >>    Last Breaking-Event-Address:
> >>     [<000000095be4bf80>] __warn_printk+0x60/0x68
> >>
> >> It indicates that domain->ops->attach_dev() failed because the driver has
> >> already passed the point of destructing the device.
> >>
> >> Fixes: 9ac8545199a1 ("iommu: Fix use-after-free in iommu_release_device")
> >> Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
> >> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> >> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >> ---
> >>  drivers/vfio/vfio.h      |  8 +++++
> >>  drivers/vfio/vfio_main.c | 68 ++++++++++++++++++++++++++--------------
> >>  2 files changed, 53 insertions(+), 23 deletions(-)
> >>
> >> v2
> >>  - Rebase on the vfio struct device series and the container.c series
> >>  - Drop patches 1 & 2, we need to have working error unwind, so another
> >>    test is not a problem
> >>  - Fold iommu_group_remove_device() into vfio_device_remove_group() so
> >>    that it forms a strict pairing with the two allocation functions.
> >>  - Drop the iommu patch from the series, it needs more work and discussion
> >> v1 https://lore.kernel.org/r/0-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com
> >>
> >> This could probably use another quick sanity test due to all the rebasing,
> >> Alex if you are happy let's wait for Matthew.
> >>  
> > 
> > I have been re-running the same series of tests on this version (on top of vfio-next) and this still resolves the reported issue.  Thanks Jason!
> >   
> 
> Hmm, there's more going on with this patch besides the issues with -ap and -ccw.  While it does indeed resolve the crashes I had been seeing, I just now noticed that I see monotonically increasing iommu group IDs (implying we are not calling iommu_group_release as much as we should be) when running the same testscase that would previously trigger the occasional crash (host device is powered off):
> 
> e.g. before this patch I would see:
> [  156.735855] pci 0003:00:00.0: Removing from iommu group 3
> [  160.299238] pci 0003:00:00.0: Adding to iommu group 3
> [  182.185975] pci 0003:00:00.0: Removing from iommu group 3
> [  185.770472] pci 0003:00:00.0: Adding to iommu group 3
> [  188.065652] pci 0003:00:00.0: Removing from iommu group 3
> [  191.590985] pci 0003:00:00.0: Adding to iommu group 3
> 
> 
> And now after this patch I see:
> [  115.091093] pci 0003:00:00.0: Removing from iommu group 3
> [  118.653818] pci 0003:00:00.0: Adding to iommu group 5
> [  139.721061] pci 0003:00:00.0: Removing from iommu group 5
> [  143.281589] pci 0003:00:00.0: Adding to iommu group 6
> [  162.651073] pci 0003:00:00.0: Removing from iommu group 6
> [  166.212440] pci 0003:00:00.0: Adding to iommu group 7

I need to break my next branch anyway to correct a Fixes: sha1, so let
me know if we should just drop this for now instead.  Thanks,

Alex

