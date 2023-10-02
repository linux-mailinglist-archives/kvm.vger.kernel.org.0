Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948D17B4E6D
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 11:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbjJBJAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 05:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjJBI76 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 04:59:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C288B3
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 01:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696237148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wxgm+8Bfp8FIpwJp0F8Lsnx34gN58d0JfUtgLpCGQBE=;
        b=GkU/itPDeaSlt34OaH2U/Ajsh3IDRohypDz9yT6EUFe95xBsCpM6omHHPtcdz+wcvFssKQ
        kagV968zZclo+9aq4ZCxa4e79eqcg/tZb7jGXPTSp3yOm10sVoHi4ec7ejjh0PC03vw1wx
        lBD7zWjmp/V7tVxE6/1XRno5LTESdi0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-8O5BSCxwNP-LOMwQ-puUmQ-1; Mon, 02 Oct 2023 04:58:56 -0400
X-MC-Unique: 8O5BSCxwNP-LOMwQ-puUmQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3231f43fc5eso9810378f8f.2
        for <kvm@vger.kernel.org>; Mon, 02 Oct 2023 01:58:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696237136; x=1696841936;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wxgm+8Bfp8FIpwJp0F8Lsnx34gN58d0JfUtgLpCGQBE=;
        b=rU9hnp3ZJSFyeyQ6IRNnZsUMAzYUP/TTt0sx/1Ix45UjQOUC0oJX6N0/n/KdTc4VX0
         8fyiR3WHEuEkIb82TTvMN2IPSmo3AjuC7fBfBqAtY/Ou510kfdNtNJmvYX9g6TJUP0Ej
         cBxDgv0/LaAMbCusXH78oq3m8PF+h0mySIp7JPm5pN+IiUY8VqhKOzZSoAWAIZODrO+p
         vtot1r5G8AHraR6Ro3Of4NotI2C9q/ZTaUroh58tGyrwjKg6bMP3TzfTd7aghbQx50b4
         sKoaV6n5TzN41BrUdpgkKEvLOoQ0+PEcQpLLdiVdJk+3oJScBjSYptcohknWPQGrAync
         OiWg==
X-Gm-Message-State: AOJu0YzcobYGSl9nDufkXLC45sOfIZbIBKx7USA0Szs8IMvWJTSV7VLM
        T9iDK8mvIo2m347ClkKSJQNZ24rMzNHivFwp7f9W2NU1oRU+1owFmXaTt4QLXf/WpyHVJstUPo/
        bzp9xW5UoyDup
X-Received: by 2002:adf:fc81:0:b0:323:37a3:8d1e with SMTP id g1-20020adffc81000000b0032337a38d1emr8808141wrr.0.1696237135689;
        Mon, 02 Oct 2023 01:58:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfCMXfIIwkIEgnzxGA3HJaP/BwimwF8mHAu3w+YCG8lwk09csa41Lgg8LzF3B0mOFWm6kLjg==
X-Received: by 2002:adf:fc81:0:b0:323:37a3:8d1e with SMTP id g1-20020adffc81000000b0032337a38d1emr8808120wrr.0.1696237135274;
        Mon, 02 Oct 2023 01:58:55 -0700 (PDT)
Received: from ?IPV6:2003:cb:c735:f200:cb49:cb8f:88fc:9446? (p200300cbc735f200cb49cb8f88fc9446.dip0.t-ipconnect.de. [2003:cb:c735:f200:cb49:cb8f:88fc:9446])
        by smtp.gmail.com with ESMTPSA id f1-20020a5d50c1000000b003142e438e8csm27549025wrt.26.2023.10.02.01.58.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Oct 2023 01:58:54 -0700 (PDT)
Message-ID: <de10b63e-0142-d9c5-8c7a-acf2c58e78cb@redhat.com>
Date:   Mon, 2 Oct 2023 10:58:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 00/18] virtio-mem: Expose device memory through
 multiple memslots
Content-Language: en-US
To:     qemu-devel@nongnu.org
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
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        kvm@vger.kernel.org
References: <20230926185738.277351-1-david@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230926185738.277351-1-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.09.23 20:57, David Hildenbrand wrote:
> Quoting from patch #16:
> 
>      Having large virtio-mem devices that only expose little memory to a VM
>      is currently a problem: we map the whole sparse memory region into the
>      guest using a single memslot, resulting in one gigantic memslot in KVM.
>      KVM allocates metadata for the whole memslot, which can result in quite
>      some memory waste.
> 
>      Assuming we have a 1 TiB virtio-mem device and only expose little (e.g.,
>      1 GiB) memory, we would create a single 1 TiB memslot and KVM has to
>      allocate metadata for that 1 TiB memslot: on x86, this implies allocating
>      a significant amount of memory for metadata:
> 
>      (1) RMAP: 8 bytes per 4 KiB, 8 bytes per 2 MiB, 8 bytes per 1 GiB
>          -> For 1 TiB: 2147483648 + 4194304 + 8192 = ~ 2 GiB (0.2 %)
> 
>          With the TDP MMU (cat /sys/module/kvm/parameters/tdp_mmu) this gets
>          allocated lazily when required for nested VMs
>      (2) gfn_track: 2 bytes per 4 KiB
>          -> For 1 TiB: 536870912 = ~512 MiB (0.05 %)
>      (3) lpage_info: 4 bytes per 2 MiB, 4 bytes per 1 GiB
>          -> For 1 TiB: 2097152 + 4096 = ~2 MiB (0.0002 %)
>      (4) 2x dirty bitmaps for tracking: 2x 1 bit per 4 KiB page
>          -> For 1 TiB: 536870912 = 64 MiB (0.006 %)
> 
>      So we primarily care about (1) and (2). The bad thing is, that the
>      memory consumption doubles once SMM is enabled, because we create the
>      memslot once for !SMM and once for SMM.
> 
>      Having a 1 TiB memslot without the TDP MMU consumes around:
>      * With SMM: 5 GiB
>      * Without SMM: 2.5 GiB
>      Having a 1 TiB memslot with the TDP MMU consumes around:
>      * With SMM: 1 GiB
>      * Without SMM: 512 MiB
> 
>      ... and that's really something we want to optimize, to be able to just
>      start a VM with small boot memory (e.g., 4 GiB) and a virtio-mem device
>      that can grow very large (e.g., 1 TiB).
> 
>      Consequently, using multiple memslots and only mapping the memslots we
>      really need can significantly reduce memory waste and speed up
>      memslot-related operations. Let's expose the sparse RAM memory region using
>      multiple memslots, mapping only the memslots we currently need into our
>      device memory region container.
> 
> The hyper-v balloon driver has similar demands [1].
> 
> For virtio-mem, this has to be turned manually on ("dynamic-memslots=on"),
> due to the interaction with vhost (below).
> 
> If we have less than 509 memslots available, we always default to a single
> memslot. Otherwise, we automatically decide how many memslots to use
> based on a simple heuristic (see patch #12), and try not to use more than
> 256 memslots across all memory devices: our historical DIMM limit.
> 
> As soon as any memory devices automatically decided on using more than
> one memslot, vhost devices that support less than 509 memslots (e.g.,
> currently most vhost-user devices like with virtiofsd) can no longer be
> plugged as a precaution.
> 
> Quoting from patch #12:
> 
>      Plugging vhost devices with less than 509 memslots available while we
>      have memory devices plugged that consume multiple memslots due to
>      automatic decisions can be problematic. Most configurations might just fail
>      due to "limit < used + reserved", however, it can also happen that these
>      memory devices would suddenly consume memslots that would actually be
>      required by other memslot consumers (boot, PCI BARs) later. Note that this
>      has always been sketchy with vhost devices that support only a small number
>      of memslots; but we don't want to make it any worse.So let's keep it simple
>      and simply reject plugging such vhost devices in such a configuration.
> 
>      Eventually, all vhost devices that want to be fully compatible with such
>      memory devices should support a decent number of memslots (>= 509).
> 
> 
> The recommendation is to plug such vhost devices before the virtio-mem
> decides, or to not set "dynamic-memslots=on". As soon as these devices
> support a reasonable number of memslots (>= 509), this will start working
> automatically.
> 
> I run some tests on x86_64, now also including vfio and migration tests.
> Seems to work as expected, even when multiple memslots are used.
> 
> 
> Patch #1 -- #3 are from [2] that were not picked up yet.
> 
> Patch #4 -- #12 add handling of multiple memslots to memory devices
> 
> Patch #13 -- #16 add "dynamic-memslots=on" support to virtio-mem
> 
> Patch #15 -- #16 make sure that virtio-mem memslots can be enabled/disable
>               atomically


If there is no further feedback until the end of the week, I'll queue 
this to mem-next.

-- 
Cheers,

David / dhildenb

