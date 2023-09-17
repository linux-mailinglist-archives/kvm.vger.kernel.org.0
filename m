Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683567A353D
	for <lists+kvm@lfdr.de>; Sun, 17 Sep 2023 12:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbjIQKq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Sep 2023 06:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237242AbjIQKqw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Sep 2023 06:46:52 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7E7185
        for <kvm@vger.kernel.org>; Sun, 17 Sep 2023 03:46:46 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1qhpIR-00050A-FF; Sun, 17 Sep 2023 12:46:35 +0200
Message-ID: <75866f2e-13c3-220e-cea8-bebc983b8cf7@maciej.szmigiero.name>
Date:   Sun, 17 Sep 2023 12:46:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 12/16] memory-device,vhost: Support automatic decision
 on the number of memslots
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
 <20230908142136.403541-13-david@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
In-Reply-To: <20230908142136.403541-13-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8.09.2023 16:21, David Hildenbrand wrote:
> We want to support memory devices that can automatically decide how many
> memslots they will use. In the worst case, they have to use a single
> memslot.
> 
> The target use cases are virtio-mem and the hyper-v balloon.
> 
> Let's calculate a reasonable limit such a memory device may use, and
> instruct the device to make a decision based on that limit. Use a simple
> heuristic that considers:
> * A memslot soft-limit for all memory devices of 256; also, to not
>    consume too many memslots -- which could harm performance.
> * Actually still free and unreserved memslots
> * The percentage of the remaining device memory region that memory device
>    will occupy.
> 
> Further, while we properly check before plugging a memory device whether
> there still is are free memslots, we have other memslot consumers (such as
> boot memory, PCI BARs) that don't perform any checks and might dynamically
> consume memslots without any prior reservation. So we might succeed in
> plugging a memory device, but once we dynamically map a PCI BAR we would
> be in trouble. Doing accounting / reservation / checks for all such
> users is problematic (e.g., sometimes we might temporarily split boot
> memory into two memslots, triggered by the BIOS).
> 
> We use the historic magic memslot number of 509 as orientation to when
> supporting 256 memory devices -> memslots (leaving 253 for boot memory and
> other devices) has been proven to work reliable. We'll fallback to
> suggesting a single memslot if we don't have at least 509 total memslots.
> 
> Plugging vhost devices with less than 509 memslots available while we
> have memory devices plugged that consume multiple memslots due to
> automatic decisions can be problematic. Most configurations might just fail
> due to "limit < used + reserved", however, it can also happen that these
> memory devices would suddenly consume memslots that would actually be
> required by other memslot consumers (boot, PCI BARs) later. Note that this
> has always been sketchy with vhost devices that support only a small number
> of memslots; but we don't want to make it any worse.So let's keep it simple
> and simply reject plugging such vhost devices in such a configuration.
> 
> Eventually, all vhost devices that want to be fully compatible with such
> memory devices should support a decent number of memslots (>= 509).
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---

Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

I would be nice to ultimately allow raising the 509 memslot limit,
considering that KVM had supported 32k memslots for more than two years
now and had a much more scalable implementation since early 2022.

Thanks,
Maciej

