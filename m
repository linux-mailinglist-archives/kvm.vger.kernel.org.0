Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63DA57E982
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 00:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbiGVWLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 18:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiGVWLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 18:11:37 -0400
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A1FAA9B96
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 15:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658527894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WTAu9Ie82eyCEnPfOUrQ1UYOeYONO590WPWh6n6IMVk=;
        b=WDOdnPD64wypU5Jv9czfl31On5jo1g2bP//1LHUSVGQhxQx673dyv+Baooe5kyLnTqctuQ
        olOqYQYV2pxddiJyD4OPIVYkiQUi0I2S2SmX8MtbNc6FkBQoo32Cz18w2GoV8jIVhWmEli
        405KZov8ffh1NU9Orc5bkhcMsTytC2Y=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-waqHf6jYOzKUj3iiikDs2Q-1; Fri, 22 Jul 2022 18:11:33 -0400
X-MC-Unique: waqHf6jYOzKUj3iiikDs2Q-1
Received: by mail-io1-f72.google.com with SMTP id 130-20020a6b0188000000b0067bd829cf29so2266299iob.17
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 15:11:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=WTAu9Ie82eyCEnPfOUrQ1UYOeYONO590WPWh6n6IMVk=;
        b=GuxeyJfeir5WfpgavX+7iK5in4gHv1VmhyoWp91zshw94Di+PfwEccf8Nnrh9GBgPw
         f2uHs5jW03UkzWkjxeQ0kxPo+EQQr5sc8ixEGf7WiKB13gDOXuSv1ybqhusJt/qpdPT0
         0fTUXBZeMdFZ8P0MKnt3V22pmiM4XCj8D3/loh2Sm8pCOkaYruXd35O4Om+6znz+nV6R
         f2sK/BJ7tTpD/iFhShIX91qj03JiM28Tj7tjEudRGStkmtW1xmr5PNqPe4KCwOlHLoUZ
         VTHP38xLj66iPHhBK2csS5DMqewNcqCk76hTErxdTIIEFLhcFbD5rXK1MAI2gEbz7Opj
         v7Kw==
X-Gm-Message-State: AJIora+79f+yJEo9eYnb0jIWC56bkYw0m39oWw4qfwPqI04rYzi+UJ3H
        qbbLbmcKgILev4do9paF9UIyIA/OxoC+a9mAbw47t3Ub4zr70i9N0cfxNyJLGxYZbmaUZsqtGr5
        yoI6YuMibbv0Z
X-Received: by 2002:a05:6e02:180d:b0:2dc:2561:4b81 with SMTP id a13-20020a056e02180d00b002dc25614b81mr808843ilv.149.1658527892263;
        Fri, 22 Jul 2022 15:11:32 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tQfszjfffkbsvzx/Y2n9I9Nnb9tw/K3y9spbP6QR/C0TjwJrze6wv6O0NmOZWFKAIyPdjySw==
X-Received: by 2002:a05:6e02:180d:b0:2dc:2561:4b81 with SMTP id a13-20020a056e02180d00b002dc25614b81mr808821ilv.149.1658527891986;
        Fri, 22 Jul 2022 15:11:31 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id o22-20020a02c6b6000000b003415de88347sm2486092jan.123.2022.07.22.15.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 15:11:31 -0700 (PDT)
Date:   Fri, 22 Jul 2022 16:11:29 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     <kwankhede@nvidia.com>, <corbet@lwn.net>, <hca@linux.ibm.com>,
        <gor@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <borntraeger@linux.ibm.com>, <svens@linux.ibm.com>,
        <zhenyuw@linux.intel.com>, <zhi.a.wang@intel.com>,
        <jani.nikula@linux.intel.com>, <joonas.lahtinen@linux.intel.com>,
        <rodrigo.vivi@intel.com>, <tvrtko.ursulin@linux.intel.com>,
        <airlied@linux.ie>, <daniel@ffwll.ch>, <farman@linux.ibm.com>,
        <mjrosato@linux.ibm.com>, <pasic@linux.ibm.com>,
        <vneethv@linux.ibm.com>, <oberpar@linux.ibm.com>,
        <freude@linux.ibm.com>, <akrowiak@linux.ibm.com>,
        <jjherne@linux.ibm.com>, <cohuck@redhat.com>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>, <hch@infradead.org>,
        <jchrist@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <terrence.xu@intel.com>
Subject: Re: [PATCH v3 00/10] Update vfio_pin/unpin_pages API
Message-ID: <20220722161129.21059262.alex.williamson@redhat.com>
In-Reply-To: <20220708224427.1245-1-nicolinc@nvidia.com>
References: <20220708224427.1245-1-nicolinc@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 8 Jul 2022 15:44:18 -0700
Nicolin Chen <nicolinc@nvidia.com> wrote:

> This is a preparatory series for IOMMUFD v2 patches. It prepares for
> replacing vfio_iommu_type1 implementations of vfio_pin/unpin_pages()
> with IOMMUFD version.
> 
> There's a gap between these two versions: the vfio_iommu_type1 version
> inputs a non-contiguous PFN list and outputs another PFN list for the
> pinned physical page list, while the IOMMUFD version only supports a
> contiguous address input by accepting the starting IO virtual address
> of a set of pages to pin and by outputting to a physical page list.
> 
> The nature of existing callers mostly aligns with the IOMMUFD version,
> except s390's vfio_ccw_cp code where some additional change is needed
> along with this series. Overall, updating to "iova" and "phys_page"
> does improve the caller side to some extent.
> 
> Also fix a misuse of physical address and virtual address in the s390's
> crypto code. And update the input naming at the adjacent vfio_dma_rw().
> 
> This is on github:
> https://github.com/nicolinc/iommufd/commits/vfio_pin_pages
> 
> Terrence has tested this series on i915; Eric has tested on s390.
> 
> Thanks!
> 
> Changelog
> v3:
>  * Added a patch to replace roundup with DIV_ROUND_UP in i915 gvt
>  * Dropped the "driver->ops->unpin_pages" and NULL checks in PATCH-1
>  * Changed to use WARN_ON and separate into lines in PATCH-1
>  * Replaced "guest" words with "user" and fix typo in PATCH-5
>  * Updated commit log of PATCH-1, PATCH-6, and PATCH-10
>  * Added Reviewed/Acked-by from Christoph, Jason, Kirti, Kevin and Eric
>  * Added Tested-by from Terrence (i915) and Eric (s390)
> v2: https://lore.kernel.org/kvm/20220706062759.24946-1-nicolinc@nvidia.com/
>  * Added a patch to make vfio_unpin_pages return void
>  * Added two patches to remove PFN list from two s390 callers
>  * Renamed "phys_page" parameter to "pages" for vfio_pin_pages
>  * Updated commit log of kmap_local_page() patch
>  * Added Harald's "Reviewed-by" to pa_ind patch
>  * Rebased on top of Alex's extern removal path
> v1: https://lore.kernel.org/kvm/20220616235212.15185-1-nicolinc@nvidia.com/
> 
> Nicolin Chen (10):
>   vfio: Make vfio_unpin_pages() return void
>   drm/i915/gvt: Replace roundup with DIV_ROUND_UP
>   vfio/ap: Pass in physical address of ind to ap_aqic()
>   vfio/ccw: Only pass in contiguous pages
>   vfio: Pass in starting IOVA to vfio_pin/unpin_pages API
>   vfio/ap: Change saved_pfn to saved_iova
>   vfio/ccw: Change pa_pfn list to pa_iova list
>   vfio: Rename user_iova of vfio_dma_rw()
>   vfio/ccw: Add kmap_local_page() for memcpy
>   vfio: Replace phys_pfn with pages for vfio_pin_pages()
> 
>  .../driver-api/vfio-mediated-device.rst       |   6 +-
>  arch/s390/include/asm/ap.h                    |   6 +-
>  drivers/gpu/drm/i915/gvt/kvmgt.c              |  49 ++---
>  drivers/s390/cio/vfio_ccw_cp.c                | 195 +++++++++++-------
>  drivers/s390/crypto/ap_queue.c                |   2 +-
>  drivers/s390/crypto/vfio_ap_ops.c             |  54 +++--
>  drivers/s390/crypto/vfio_ap_private.h         |   4 +-
>  drivers/vfio/vfio.c                           |  54 ++---
>  drivers/vfio/vfio.h                           |   8 +-
>  drivers/vfio/vfio_iommu_type1.c               |  45 ++--
>  include/linux/vfio.h                          |   9 +-
>  11 files changed, 215 insertions(+), 217 deletions(-)
> 

GVT-g explodes for me with this series on my Broadwell test system,
continuously spewing the following:

[   47.344126] ------------[ cut here ]------------
[   47.348778] WARNING: CPU: 3 PID: 501 at drivers/vfio/vfio_iommu_type1.c:978 vfio_iommu_type1_unpin_pages+0x7b/0x100 [vfio_iommu_type1]
[   47.360871] Modules linked in: xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink tun bridge stp llc rfkill sunrpc vfat fat intel_rapl_msr intel_rapl_common x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel iTCO_wdt at24 mei_wdt mei_hdcp intel_pmc_bxt mei_pxp rapl iTCO_vendor_support intel_cstate pcspkr e1000e mei_me intel_uncore i2c_i801 mei lpc_ich i2c_smbus acpi_pad fuse zram ip_tables kvmgt mdev vfio_iommu_type1 vfio kvm irqbypass i915 crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel pinctrl_lynxpoint i2c_algo_bit drm_buddy video drm_display_helper drm_kms_helper cec ttm drm
[   47.423398] CPU: 3 PID: 501 Comm: gvt:rcs0 Tainted: G        W         5.19.0-rc4+ #3
[   47.431228] Hardware name:  /NUC5i5MYBE, BIOS MYBDWi5v.86A.0054.2019.0520.1531 05/20/2019
[   47.439408] RIP: 0010:vfio_iommu_type1_unpin_pages+0x7b/0x100 [vfio_iommu_type1]
[   47.446818] Code: 10 00 00 45 31 ed 48 8b 7b 40 48 85 ff 74 12 48 8b 47 18 49 39 c6 77 23 48 8b 7f 10 48 85 ff 75 ee 48 8b 3c 24 e8 45 57 92 e4 <0f> 0b 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 03 47 28 49
[   47.465573] RSP: 0018:ffff9ac5806cfbe0 EFLAGS: 00010246
[   47.470807] RAX: ffff8cb42f4c5180 RBX: ffff8cb4145c03c0 RCX: 0000000000000000
[   47.477948] RDX: 0000000000000000 RSI: 0000163802000000 RDI: ffff8cb4145c03e0
[   47.485088] RBP: 0000000000000001 R08: 0000000000000000 R09: ffff9ac581aed000
[   47.492230] R10: ffff9ac5806cfc58 R11: 00000001b2202000 R12: 0000000000000001
[   47.499370] R13: 0000000000000000 R14: 0000163802001000 R15: 0000163802000000
[   47.506513] FS:  0000000000000000(0000) GS:ffff8cb776d80000(0000) knlGS:0000000000000000
[   47.514608] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   47.520361] CR2: ffffdc0933f76192 CR3: 0000000118118003 CR4: 00000000003726e0
[   47.527510] Call Trace:
[   47.529976]  <TASK>
[   47.532091]  intel_gvt_dma_unmap_guest_page+0xd5/0x110 [kvmgt]
[   47.537948]  ppgtt_invalidate_spt+0x323/0x340 [kvmgt]
[   47.543017]  ppgtt_invalidate_spt+0x173/0x340 [kvmgt]
[   47.548088]  ppgtt_invalidate_spt+0x173/0x340 [kvmgt]
[   47.553159]  ppgtt_invalidate_spt+0x173/0x340 [kvmgt]
[   47.558228]  invalidate_ppgtt_mm+0x5f/0x110 [kvmgt]
[   47.563124]  _intel_vgpu_mm_release+0xd6/0xe0 [kvmgt]
[   47.568193]  intel_vgpu_destroy_workload+0x1b7/0x1e0 [kvmgt]
[   47.573872]  workload_thread+0xa4c/0x19a0 [kvmgt]
[   47.578613]  ? _raw_spin_rq_lock_irqsave+0x20/0x20
[   47.583422]  ? dequeue_task_stop+0x70/0x70
[   47.587530]  ? _raw_spin_lock_irqsave+0x24/0x50
[   47.592072]  ? intel_vgpu_reset_submission+0x40/0x40 [kvmgt]
[   47.597746]  kthread+0xe7/0x110
[   47.600902]  ? kthread_complete_and_exit+0x20/0x20
[   47.605702]  ret_from_fork+0x22/0x30
[   47.609293]  </TASK>
[   47.611503] ---[ end trace 0000000000000000 ]---

Line 978 is the WARN_ON(i != npage) line.  For the cases where we don't
find a matching vfio_dma, I'm seeing addresses that look maybe like
we're shifting  a value that's already an iova by PAGE_SHIFT somewhere.
Thanks,

Alex

