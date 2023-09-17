Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276E97A3568
	for <lists+kvm@lfdr.de>; Sun, 17 Sep 2023 13:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjIQLrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Sep 2023 07:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbjIQLr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Sep 2023 07:47:26 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23AE126
        for <kvm@vger.kernel.org>; Sun, 17 Sep 2023 04:47:20 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1qhqF4-0005Jz-HO; Sun, 17 Sep 2023 13:47:10 +0200
Message-ID: <e9cdf797-1497-ae65-9ac9-da0effb303d6@maciej.szmigiero.name>
Date:   Sun, 17 Sep 2023 13:47:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 14/16] virtio-mem: Expose device memory via multiple
 memslots if enabled
Content-Language: en-US, pl-PL
To:     David Hildenbrand <david@redhat.com>
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
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org
References: <20230908142136.403541-1-david@redhat.com>
 <20230908142136.403541-15-david@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
In-Reply-To: <20230908142136.403541-15-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8.09.2023 16:21, David Hildenbrand wrote:
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
> We'll auto-detect the number of memslots to use based on the memslot limit
> provided by the core. We'll use at most 1 memslot per gigabyte. Note that
> our global limit of memslots accross all memory devices is currently set to
> 256: even with multiple large virtio-mem devices, we'd still have a sane
> limit on the number of memslots used.
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

Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Hope this patch was well-tested, especially on corner cases, since
it's very easy to make an off-by-one somewhere (like v1 had) and
much harder to spot it when doing a static code review.

Thanks,
Maciej

