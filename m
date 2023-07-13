Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BFC752B81
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 22:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbjGMURk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 16:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbjGMURi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 16:17:38 -0400
X-Greylist: delayed 1112 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Jul 2023 13:17:31 PDT
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D062D64
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 13:17:31 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1qK2SN-0005fS-MT; Thu, 13 Jul 2023 21:58:31 +0200
Message-ID: <3bd720ec-8f61-d3e9-c998-4873e0c4f778@maciej.szmigiero.name>
Date:   Thu, 13 Jul 2023 21:58:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Content-Language: en-US, pl-PL
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230616092654.175518-1-david@redhat.com>
 <20230616092654.175518-14-david@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v1 13/15] virtio-mem: Expose device memory via multiple
 memslots if enabled
In-Reply-To: <20230616092654.175518-14-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16.06.2023 11:26, David Hildenbrand wrote:
> Having large virtio-mem devices that only expose little memory to a VM
> is currently a problem: we map the whole sparse memory region into the
> guest using a single memslot, resulting in one gigantic memslot in KVM.
> KVM allocates metadata for the whole memslot, which can result in quite
> some memory waste.
> 
> Assuming we have a 1 TiB virtio-mem device and only expose little (e.g.,
> 1 GiB) memory, we would create a single 1 TiB memslot and KVM has to
> allocate metadata for that 1 TiB memslot: on x86, this implies allocating
> a significant amount of memory for metadata:
> 
> (1) RMAP: 8 bytes per 4 KiB, 8 bytes per 2 MiB, 8 bytes per 1 GiB
>      -> For 1 TiB: 2147483648 + 4194304 + 8192 = ~ 2 GiB (0.2 %)
> 
>      With the TDP MMU (cat /sys/module/kvm/parameters/tdp_mmu) this gets
>      allocated lazily when required for nested VMs
> (2) gfn_track: 2 bytes per 4 KiB
>      -> For 1 TiB: 536870912 = ~512 MiB (0.05 %)
> (3) lpage_info: 4 bytes per 2 MiB, 4 bytes per 1 GiB
>      -> For 1 TiB: 2097152 + 4096 = ~2 MiB (0.0002 %)
> (4) 2x dirty bitmaps for tracking: 2x 1 bit per 4 KiB page
>      -> For 1 TiB: 536870912 = 64 MiB (0.006 %)
> 
> So we primarily care about (1) and (2). The bad thing is, that the
> memory consumption *doubles* once SMM is enabled, because we create the
> memslot once for !SMM and once for SMM.
> 
> Having a 1 TiB memslot without the TDP MMU consumes around:
> * With SMM: 5 GiB
> * Without SMM: 2.5 GiB
> Having a 1 TiB memslot with the TDP MMU consumes around:
> * With SMM: 1 GiB
> * Without SMM: 512 MiB
> 
> ... and that's really something we want to optimize, to be able to just
> start a VM with small boot memory (e.g., 4 GiB) and a virtio-mem device
> that can grow very large (e.g., 1 TiB).
> 
> Consequently, using multiple memslots and only mapping the memslots we
> really need can significantly reduce memory waste and speed up
> memslot-related operations. Let's expose the sparse RAM memory region using
> multiple memslots, mapping only the memslots we currently need into our
> device memory region container.
> 
> * With VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE, we only map the memslots that
>    actually have memory plugged, and dynamically (un)map when
>    (un)plugging memory blocks.
> 
> * Without VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE, we always map the memslots
>    covered by the usable region, and dynamically (un)map when resizing the
>    usable region.
> 
> We'll auto-determine the number of memslots to use based on the suggested
> memslot limit provided by the core. We'll use at most 1 memslot per
> gigabyte. Note that our global limit of memslots accross all memory devices
> is currently set to 256: even with multiple large virtio-mem devices, we'd
> still have a sane limit on the number of memslots used.
> 
> The default is a single memslot for now ("multiple-memslots=off"). The
> optimization must be enabled manually using "multiple-memslots=on", because
> some vhost setups (e.g., hotplug of vhost-user devices) might be
> problematic until we support more memslots especially in vhost-user
> backends.
> 
> Note that "multiple-memslots=on" is just a hint that multiple memslots
> *may* be used for internal optimizations, not that multiple memslots
> *must* be used. The actual number of memslots that are used is an
> internal detail: for example, once memslot metadata is no longer an
> issue, we could simply stop optimizing for that. Migration source and
> destination can differ on the setting of "multiple-memslots".
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   hw/virtio/virtio-mem-pci.c     |  21 +++
>   hw/virtio/virtio-mem.c         | 265 ++++++++++++++++++++++++++++++++-
>   include/hw/virtio/virtio-mem.h |  23 ++-
>   3 files changed, 304 insertions(+), 5 deletions(-)
> 
> diff --git a/hw/virtio/virtio-mem-pci.c b/hw/virtio/virtio-mem-pci.c
> index b85c12668d..8b403e7e78 100644
> --- a/hw/virtio/virtio-mem-pci.c
> +++ b/hw/virtio/virtio-mem-pci.c
(...)
> @@ -790,6 +921,43 @@ static void virtio_mem_system_reset(void *opaque)
>       virtio_mem_unplug_all(vmem);
>   }
>   
> +static void virtio_mem_prepare_mr(VirtIOMEM *vmem)
> +{
> +    const uint64_t region_size = memory_region_size(&vmem->memdev->mr);
> +
> +    g_assert(!vmem->mr);
> +    vmem->mr = g_new0(MemoryRegion, 1);
> +    memory_region_init(vmem->mr, OBJECT(vmem), "virtio-mem",
> +                       region_size);
> +    vmem->mr->align = memory_region_get_alignment(&vmem->memdev->mr);
> +}
> +
> +static void virtio_mem_prepare_memslots(VirtIOMEM *vmem)
> +{
> +    const uint64_t region_size = memory_region_size(&vmem->memdev->mr);
> +    unsigned int idx;
> +
> +    g_assert(!vmem->memslots && vmem->nb_memslots);
> +    vmem->memslots = g_new0(MemoryRegion, vmem->nb_memslots);
> +
> +    /* Initialize our memslots, but don't map them yet. */
> +    for (idx = 0; idx < vmem->nb_memslots; idx++) {
> +        const uint64_t memslot_offset = idx * vmem->memslot_size;
> +        uint64_t memslot_size = vmem->memslot_size;
> +        char name[20];
> +
> +        /* The size of the last memslot might be smaller. */
> +        if (idx == vmem->nb_memslots) {                       ^
I guess this should be "vmem->nb_memslots - 1" since that's the last
memslot index.

> +            memslot_size = region_size - memslot_offset;
> +        }
> +
> +        snprintf(name, sizeof(name), "memslot-%u", idx);
> +        memory_region_init_alias(&vmem->memslots[idx], OBJECT(vmem), name,
> +                                 &vmem->memdev->mr, memslot_offset,
> +                                 memslot_size);
> +    }
> +}
> +

Thanks,
Maciej

